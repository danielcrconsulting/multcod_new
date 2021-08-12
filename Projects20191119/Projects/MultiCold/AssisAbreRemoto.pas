Unit AssisAbreRemoto;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, ComCtrls, IMulticoldServer1, ExtCtrls;

Type
  TAssisAbreRemotoForm = Class(TForm)
    Panel1: TPanel;
    TreeView1: TTreeView;
    Panel2: TPanel;
    Button1: TButton;
    Panel3: TPanel;
    ListBox2: TListBox;
    Panel4: TPanel;
    Button3: TButton;
    Button2: TButton;
    Procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  AssisAbreRemotoForm: TAssisAbreRemotoForm;
  FullPaths : TStringList;

Implementation

Uses MdiMultiCold, Subrug, LogInForm, Sugeral, Avisoi, zLib;

{$R *.DFM}

Procedure TAssisAbreRemotoForm.Button3Click(Sender: TObject);
Begin
Close;
End;

Procedure TAssisAbreRemotoForm.Button1Click(Sender: TObject);
Var
  Lista : TStringList;
  FullPathsTemp : WideString;
  SisStr,
  GrupoStr : String;
  I,
  Sistema,
  Grupo,
  SubGrupo : Integer;

//  lixo : string;


  Function RetNomeSis(Sistema : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArSisRemoto)-1 Do  // Achar o nome do grupo
    If (ArSisRemoto[I].CodSis = Sistema) Then
      Begin
      Result := ArSisRemoto[I].NomeSis + '\';
      Break;
      End;
  End;

  Function RetCodSis(Sistema : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := 0;
  For I := 0 To Length(ArSisRemoto)-1 Do  // Achar o nome do grupo
    If (ArSisRemoto[I].NomeSis = Sistema) Then
      Begin
      Result := ArSisRemoto[I].CodSis;
      Break;
      End;
  End;

  Function RetNomeGrupo(Sistema, Grupo : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArGrupoRemoto)-1 Do  // Achar o nome do grupo
    If (ArGrupoRemoto[I].CodSis = Sistema) And (ArGrupoRemoto[I].CodGrupo = Grupo) Then
      Begin
      Result := ArGrupoRemoto[I].NomeGrupo+'\';
      Break;
      End;
  End;

  Function RetNomeSubGrupo(Sistema, Grupo, SubGrupo : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArSubGrupoRemoto)-1 Do  // Achar o nome do subgrupo
    If (ArSubGrupoRemoto[I].CodSis = Sistema) And
       (ArSubGrupoRemoto[I].CodGrupo = Grupo) And
       (ArSubGrupoRemoto[I].CodSubGrupo = SubGrupo) Then
      Begin
      Result := ArSubGrupoRemoto[I].NomeSubGrupo+'\';
      Break;
      End;
  End;

  Function RetSubGrupo(CodRel : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := 0;
  For I := 0 To Length(ArDFNRemoto)-1 Do  // Achar o nome do grupo
    If ArDFNRemoto[I].CodRel = CodRel Then
      Begin
      Result := ArDFNRemoto[I].CodSubGrupo;
      Break;
      End;
  End;
                            // Retorna o grupo original da dfn
  Function RetGrupo(CodRel : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := 0;
  For I := 0 To Length(ArDFNRemoto)-1 Do  // Achar o nome do grupo
    If ArDFNRemoto[I].CodRel = CodRel Then
      Begin
      Result := ArDFNRemoto[I].CodGrupo;
      Break;
      End;
  End;

Begin
If TreeView1.Selected = Nil Then
  Begin
  Avisop.Label1.Caption := 'Nenhum código de relatório selecionado!';
  Avisop.Show;
  End
Else
If TreeView1.Selected.HasChildren Then
  Begin
  Avisop.Label1.Caption := 'Selecione um Grupo abaixo do relatório desejado...';
  Avisop.Show;
  End
Else  
If (Length(TreeView1.Selected.Text) > 1) And (Copy(TreeView1.Selected.Text,1,2)='  ') Then
  Begin
  Avisop.Label1.Caption := 'Módulo do Relatório...';
  Avisop.Show;
  End
Else
  Begin
  ListBox2.Clear;
  ListBox2.MultiSelect := True;
  ListBox2.Sorted := False;

  Lista := TStringList.Create;
  Lista.Add(TreeView1.Selected.Parent.Text);

  FullPaths.Clear;
  With FrameForm Do
    Begin
    Screen.Cursor := crHourGlass;

    GrupoStr := Copy(TreeView1.Selected.Text,2,Length(TreeView1.Selected.Text)-1);
    GrupoStr := Copy(GrupoStr,1,Pos('-',GrupoStr)-2);

    Sistema := 0;
    Grupo := 0;
    SubGrupo := 0;
    For I := 0 To Length(ArDFNRemoto)-1 Do // Achar o código do sistema
      If ArDFNRemoto[I].CodRel = TreeView1.Selected.Parent.Text Then
        Begin
        Sistema := ArDFNRemoto[I].CodSis;
        Grupo := ArDFNRemoto[I].CodGrupo;
        SubGrupo := ArDFNRemoto[I].CodSubGrupo;
        Break;
        End;

    SisStr := intToStr(Sistema);
    if Sistema = -1 then
      Begin
      SisStr := TreeView1.Selected.Parent.getFirstChild.Text;
      SisStr := Copy(SisStr,3,Length(SisStr));
      SisStr := Copy(SisStr,Pos(' ',SisStr)+1,Length(SisStr));
      SisStr := intToStr(RetCodSis(SisStr));
      End;

    GrupoStr := Copy(TreeView1.Selected.Text,2,Length(TreeView1.Selected.Text)-1);
    GrupoStr := Copy(GrupoStr,1,Pos('-',GrupoStr)-2);

    FullPathsTemp := RetNomeSis(strToInt(SisStr)) +
                     RetNomeGrupo(strToInt(SisStr), strToInt(GrupoStr)) +
                     RetNomeSubGrupo(Sistema, Grupo, SubGrupo) +
                     TreeView1.Selected.Parent.Text+'\';

    Avisop.Label2.Caption := FullPathsTemp;

    Try
      //ListBox2.Items.Text := WebConnection1.AppServer.GetRelatorio(LogInRemotoForm.UsuEdit.Text,
      //                                         LogInRemotoForm.PassEdit.Text, ConnectionID, Lista.Text, FullPathsTemp);
//      lixo := (formGeral.HTTPRIO1 as IMulticoldServer).GetRelatorio(LogInRemotoForm.UsuEdit.Text,
//                                               LogInRemotoForm.PassEdit.Text, ConnectionID, Lista.Text, FullPathsTemp);

      ListBox2.Items.Text := deCompressHexReturnString((formGeral.HTTPRIO1 as IMulticoldServer).GetRelatorio(LogInRemotoForm.UsuEdit.Text,
                                               LogInRemotoForm.PassEdit.Text, ConnectionID, Lista.Text, FullPathsTemp));
      FullPaths.Text := deCompressHexReturnString(FullPathsTemp);
//      ListBox2.Items.Text := (lixo);
//      FullPaths.Text := (FullPathsTemp);

    Finally
      Screen.Cursor := crDefault;
      End; // Try


    If FullPaths.Text = '' Then
      Begin
//      ConectouRemoto := False;
      Avisop.Label1.Caption := 'Nenhum relatório encontrado...';
      Avisop.Show;
      Lista.Free;
      Exit;
      End;

    End;

  Lista.Free;

  If ListBox2.Items.Count = 0 Then
    Begin
    Avisop.Label1.Caption := 'Nenhum relatório encontrado...';
    Avisop.Show;
    End
  Else
    Begin
    StrSrt.Text := ListBox2.Items.Text;   // Ordena Ascii e descendente......
    StrSrt.CustomSort(SortCompareDesc);
    ListBox2.Items.Text := StrSrt.Text;
    FullPaths.CustomSort(SortCompareDesc); // Coloca os nomes de arquivo no mesma ordem
    End;
  End;
End;

Procedure TAssisAbreRemotoForm.Button2Click(Sender: TObject);
Var
  I,
  RetVal : Integer;
Begin
If ListBox2.SelCount = 0 Then
  Begin
  Avisop.Label1.Caption := 'Nenhum relatório selecionado para abertura';
  Avisop.Show;
  End
Else
  Begin
  Avisop.Close;

  For I := 0 To ListBox2.Items.Count-1 Do
    If ListBox2.Selected[I] Then
      With FrameForm Do
        Begin
        Screen.Cursor := crHourGlass;
        Try
          //RetVal := WebConnection1.AppServer.AbreRelatorio(LogInRemotoForm.UsuEdit.Text,
          //                                                 LogInRemotoForm.PassEdit.Text,
          //                                                 ConnectionID,
          //                                                 Copy(FullPaths[I], 21,Length(FullPaths[I])-20),
          //                                                 QtdPaginas,
          //                                                 StrCampos,
          //                                                 Rel64,
          //                                                 Rel133,
          //                                                 CmprBrncs);
          RetVal := (formGeral.HTTPRIO1 as IMulticoldServer).AbreRelatorio(LogInRemotoForm.UsuEdit.Text,
                                                           LogInRemotoForm.PassEdit.Text,
                                                           ConnectionID,
                                                           Copy(FullPaths[I], 21,Length(FullPaths[I])-20),
                                                           QtdPaginas,
                                                           StrCampos,
                                                           Rel64,
                                                           Rel133,
                                                           CmprBrncs);

        Finally
          Screen.Cursor := crDefault;
          Rel133 := Rel133;
          End; // Try
        Case RetVal Of
          0 : AbreRel(Copy(FullPaths[I], 21,Length(FullPaths[I])-20), True);
          1 : ShowMessage('Usuário '+LogInRemotoForm.UsuEdit.Text+' não autorizado a abrir este relatório: '+
                          ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
          2 : ShowMessage('Falha de I/O '+ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
          3 : ShowMessage('Relatório vazio '+ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
          4 : ShowMessage('DFN inválida '+ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
          5 : ShowMessage('ArqPag 2 '+ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
          6 : ShowMessage('ArqPag 1 '+ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
      99999 : ShowMessage('Erro não detectado '+ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
          End; //Case
        End;
  Avisop.Close;
  End;
End;

Procedure TAssisAbreRemotoForm.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
Avisop.Close;
End;

procedure TAssisAbreRemotoForm.FormShow(Sender: TObject);
begin
Self.Width := FrameForm.Width - 20;
Self.Left := FrameForm.Left + 10;
Self.Top := FrameForm.Height - Self.Height - 20;
end;

Begin
FullPaths := TStringList.Create;
End.
