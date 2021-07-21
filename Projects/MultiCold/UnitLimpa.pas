Unit UnitLimpa;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Mask, ComCtrls;

Type
  TForm1 = Class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    Configuraes1: TMenuItem;
    Diretrios1: TMenuItem;
    TreeView1: TTreeView;
    MaskEdit1: TMaskEdit;
    Label1: TLabel;
    Button1: TButton;
    Button3: TButton;
    Edit1: TEdit;
    GravaoeLimpeza1: TMenuItem;
    N1: TMenuItem;
    Procedure Sair1Click(Sender: TObject);
    procedure Diretrios1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure init;
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;
  autoLogin: boolean;

Implementation

uses JaConfU, SuGeral, SuBrug, LogInU;


{$R *.DFM}

procedure TForm1.init;
begin
Edit1.Text := 'Andamento da limpeza...';
If viNDiasPerm = '' Then
  Exit;
MaskEdit1.Text := viNDiasPerm
end;

Procedure TForm1.Sair1Click(Sender: TObject);
Begin
Close;
End;

Procedure TForm1.Diretrios1Click(Sender: TObject);
Begin
JaConf.ShowModal;
End;

Procedure TForm1.Button3Click(Sender: TObject);
Begin
Termina := True;
Close;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Var
  Dia,
  Mes,
  Ano : Word;
  Root : TTreeNode;
  Base,
  NewDir,
  AuxStr : String;
  RefData : TDateTime;
  NavDir : TSearchRec;
  I,
  IItem : Integer;

  Procedure AddDir(Dir : TTreeNode; DirName : String);
  Var
    NavDir,
    NavDat,
    NavAll : TSearchRec;
    NomArq,
    NewDir,
    NomeIn,
    NomeOut : String;
    SoData : TDate;
  Begin
  If FindFirst(DirName+'*',faAnyFile,NavDir) = 0 Then
    Repeat
      If Termina Then
        Begin
        ShowMessage('Cancelado...');
        Application.Terminate;
        End;

      If (NavDir.Name <> '.') And (NavDir.Name <> '..') And (DirectoryExists(DirName + NavDir.Name)) Then
        Begin
        NewDir := DirName + NavDir.Name + '\';
        AddDir(TreeView1.Items.AddChild(Dir,'.'+NavDir.Name+'\'), NewDir);
        End;
    Until FindNext(NavDir) <> 0;
  FindClose(NavDir);

  If Termina Then
    Begin
    ShowMessage('Cancelado...');
    Application.Terminate;
    End;

//  ShowMessage('Indo atrás dos dats');
  If FindFirst(DirName+'*.dat',faAnyFile,NavDat) = 0 Then
    Repeat

    If Termina Then
      Begin
      ShowMessage('Cancelado...');
      Application.Terminate;
      End;

    SoData := FileDateToDateTime(NavDat.Time);

    If (FileExists(DirName + NavDat.Name)) And
       (Sodata < RefData) Then  // Mover os arquivos
      Begin
      NomArq := DirName + SeArquivoSemExt(NavDat.Name) + '*.*';
      If FindFirst(NomArq,faAnyFile,NavAll) = 0 Then
        Repeat
          If Not (FileExists(DirName + NavAll.Name)) Then
            Continue;

          If Termina Then
            Begin
            ShowMessage('Cancelado...');
            Exit;
            End;

          NomeIn := ExtractFilePath(NomArq)+NavAll.Name;
          NomeOut := JaConf.Edit2.Text +
                     Copy(NomeIn, Length(JaConf.Edit1.Text),
                          Length(NomeIn)-Length(JaConf.Edit1.Text)+1);

          Edit1.Text := NomeIn;
          Application.ProcessMessages;

          ForceDirectories(ExtractFilePath(NomeOut));

            // Mover o arquivo

          If Not MoveFile(Pchar(NomeIn), Pchar(NomeOut)) Then
            Begin
            CopyFile(Pchar(NomeIn), Pchar(NomeOut), False); // OverWrite If Exists
            DeleteFile(NomeIn);
            End; //   Deixar a deleção desligada para testes...

        Until FindNext(NavAll) <> 0;

      RemoveDir(ExcludeTrailingPathDelimiter(ExtractFilePath(NomArq))); // Tenta remover o diretório original
      FindClose(NavAll);

      End;
    Application.ProcessMessages;
    Until FindNext(NavDat) <> 0;
  FindClose(NavDat);
  End;

Begin
Termina := False;
If MaskEdit1.Text = '' Then
  Begin
  ShowMessage('Informe a data limite para a limpeza');
  MaskEdit1.SetFocus;
  Exit;
  End;
Try
  Ano := StrToInt(Trim(Copy(MaskEdit1.Text,5,4)));
Except
  ShowMessage('Erro ao converter o ano');
  MaskEdit1.SetFocus;
  Exit;
  End; // Try
Try
  Mes := StrToInt(Trim(Copy(MaskEdit1.Text,3,2)));
Except
  ShowMessage('Erro ao converter o mês');
  MaskEdit1.SetFocus;
  Exit;
  End; // Try
Try
  Dia := StrToInt(Trim(Copy(MaskEdit1.Text,1,2)));
Except
  ShowMessage('Erro ao converter o dia');
  MaskEdit1.SetFocus;
  Exit;
  End; // Try
Try
  RefData := EncodeDate(Ano,Mes,Dia);
Except
  ShowMessage('Data informada inválida');
  MaskEdit1.SetFocus;
  Exit;
  End; // Try

FormGeral.InsereEventos(MaskEdit1.Text,JaConf.Edit2.Text,LogInForm.UsuEdit.Text,7,'');

JaConf.Edit2.Text := ExcludeTrailingPathDelimiter(JaConf.Edit2.Text); // Fica sem...
TreeView1.Items.Clear;
TreeView1.ReadOnly := True;
TreeView1.SortType := stNone;

JaConf.Edit1.Text := IncludeTrailingPathDelimiter(JaConf.Edit1.Text);
Base := JaConf.Edit1.Text;
Root := Nil;
AuxStr := ExtractFileDrive(Base);
If AuxStr = '' Then
  Exit;

Root := TreeView1.Items.Add(Root,'.'+AuxStr+'\');  // Insere a raiz
IItem := 0;

Delete(Base,1,Length(AuxStr)+1);

While Pos('\',Base) <> 0 Do                        // Insere o path básico
  Begin
  Root := TreeView1.Items.AddChild(Root,'.'+Copy(Base,1,Pos('\',Base)));
  Delete(Base,1,Pos('\',Base));
  Inc(IItem);
  End;

//ShowMessage('Indo montar base de diretórios');
If FindFirst(JaConf.Edit1.Text+'*',faAnyFile,NavDir) = 0 Then
  Repeat
//    If (NavDir.Attr <> 2096) And (NavDir.Attr <> 2080) And (NavDir.Attr <> 2064) Then
//      ShowMessage('1 '+NavDir.Name+' '+IntToStr(NavDir.Attr)); // No NT retorna 2096, 2064 para diretório
//                                                                       2080 para arquivo
//    If (NavDir.Name <> '.') And (NavDir.Name <> '..') And ((NavDir.Attr = 2064) Or
//                                                           (NavDir.Attr = 2096) Or
//                                                           (NavDir.Attr = faDirectory)) Then
    If (NavDir.Name <> '.') And (NavDir.Name <> '..') And (DirectoryExists(JaConf.Edit1.Text + NavDir.Name)) Then
      Begin
      NewDir := JaConf.Edit1.Text + NavDir.Name + '\';
      AddDir(TreeView1.Items.AddChild(Root,'.'+NavDir.Name+'\'), NewDir);
      Application.ProcessMessages;
      End;
  Until FindNext(NavDir) <> 0;
FindClose(NavDir);

TreeView1.SortType := stText;

For I := 0 To IItem Do                                // Expande o path básico
  TreeView1.Items[I].Expand(False);

Edit1.Text := '';
Application.ProcessMessages;

if not (autoLogin) then
  ShowMessage('Fim de limpeza...');

End;

Procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
Begin
FormGeral.DatabaseEventos.Connected := False;
FormGeral.DatabaseMulticold.Connected := False;
FormGeral.DatabaseLog.Connected := False;
End;

End.
