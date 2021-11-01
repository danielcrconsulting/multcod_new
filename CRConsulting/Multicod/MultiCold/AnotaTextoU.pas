Unit AnotaTextoU;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, ADODB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

Type
  TAnotaTextoForm = Class(TForm)
    SairBut: TButton;
    Memo1: TMemo;
    SalvarButton: TButton;
    ExcluirButton: TButton;
    Panel1: TPanel;
    PublicaRadioButton: TRadioButton;
    PrivadaRadioButton: TRadioButton;
    ADOQuery1: TADOQuery;
    Label1: TLabel;
    ScrollBar1: TScrollBar;
    Label5: TLabel;
    FDQuery1: TFDQuery;
    Memtb: TFDMemTable;
    procedure SairButClick(Sender: TObject);
    procedure SalvarButtonClick(Sender: TObject);
    procedure ExcluirButtonClick(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure Memo1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Implementation

{$R *.dfm}

Uses Sugeral, MdiEdit, MdiMultiCold, Subrug;

Procedure TAnotaTextoForm.SairButClick(Sender: TObject);
Begin
Close;
End;

Procedure TAnotaTextoForm.SalvarButtonClick(Sender: TObject);
Var
  Posic : Integer;
  strlst : TStringlist;
  strPar : TFDParams;
  Param  : TFDParam;
Begin
  strPar := TFDParams.Create;
  strLst := TStringList.Create;
  strlst.Add(' INSERT INTO COMENTARIOSTXT                                       ');
  strlst.Add(' (CODUSUARIO, CODREL, PATHREL, FLAGPUBLICO, PAGINA, COMENTARIOTXT)');
  strlst.Add(' VALUES (:A,  :B,  :C,  :D, :E, :F)                               ');

  Param := strPar.Add;
  Param.Name := ':A';
  Param.Value := UpperCase(GetCurrentUserName);;
  Param := strPar.Add;
  Param.Name := ':B';
  Param.Value := RegDFN.CODREL;
  Param := strPar.Add;
  Param.Name := ':C';
  Param.Value :=  ExtractFileName(TEditForm(FrameForm.ActiveMDIChild).Filename);
  Param := strPar.Add;
  Param.Name := ':D';
  If PublicaRadioButton.Checked Then
    Param.Value := 'T'
  Else
    Param.Value := 'F';
  Param := strPar.Add;
  Param.Name := ':E';
  Param.Value := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;;
  Param := strPar.Add;
  Param.Name := ':F';
  Param.Value := Memo1.Text;


  FormGeral.QueryInsAnotText.Close;
  FormGeral.QueryInsAnotText.Parameters[0].Value := UpperCase(GetCurrentUserName);
  FormGeral.QueryInsAnotText.Parameters[1].Value := RegDFN.CODREL;
  FormGeral.QueryInsAnotText.Parameters[2].Value := ExtractFileName(TEditForm(FrameForm.ActiveMDIChild).Filename);
  If PublicaRadioButton.Checked Then
    FormGeral.QueryInsAnotText.Parameters[3].Value := 'T'
  Else
    FormGeral.QueryInsAnotText.Parameters[3].Value := 'F';
  FormGeral.QueryInsAnotText.Parameters[4].Value := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;
  FormGeral.QueryInsAnotText.Parameters[5].AppendChunk(Memo1.Text);

  If Memo1.Text <> ADOQuery1.FieldByName('COMENTARIOTXT').AsString Then
    Try
      FormGeral.QueryInsAnotText.ExecSQL;
      Posic := ScrollBar1.Position;
      TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, TEditForm(FrameForm.ActiveMDIChild).PaginaAtu);
      If Sender = SalvarButton Then
        Begin
        While ADOQuery1.RecNo <> Posic+1 Do
          ADOQuery1.Next;
        ScrollBar1.Position := Posic + 1;
        Memo1.Text := ADOQuery1.FieldByName('COMENTARIOTXT').AsString;
        End;
      ShowMessage('Anotação de texto salva com sucesso...');
    Except
    On e: Exception Do
      Begin
      ShowMessage('Erro ao tentar salvar a anotação: '+e.Message);
      End;
      End;

End;

Procedure TAnotaTextoForm.ExcluirButtonClick(Sender: TObject);
Begin
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.SQL.Clear;
FormGeral.QueryLocal1.SQL.Add('DELETE FROM COMENTARIOSTXT WHERE COMENTARIOID = '+ADOQuery1.Fields[0].AsString);
{FormGeral.QueryLocal1.SQL.Add('DELETE FROM COMENTARIOSTXT WHERE CODREL = '''+RegDFN.CODREL+'''');
FormGeral.QueryLocal1.SQL.Add('AND PATHREL = '''+ExtractFileName(TEditForm(FrameForm.ActiveMDIChild).Filename)+'''');
FormGeral.QueryLocal1.SQL.Add('AND PAGINA = '+IntToStr(TEditForm(FrameForm.ActiveMDIChild).PaginaAtu));
FormGeral.QueryLocal1.SQL.Add('AND ((CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''')');
FormGeral.QueryLocal1.SQL.Add('OR   (FLAGPUBLICO = ''T''))');}
Try
  ADOQuery1.Close;
  FormGeral.QueryLocal1.ExecSQL;
  TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, TEditForm(FrameForm.ActiveMDIChild).PaginaAtu);
  ShowMessage('Anotação de texto excluída com sucesso...');
//  Memo1.Text := '';
//  FrameForm.Animate1.Visible := False;
Except
  ShowMessage('Erro ao tentar excluir a anotação de texto...');
  End;
End;

Procedure TAnotaTextoForm.Memo1KeyPress(Sender: TObject; var Key: Char);
Begin
TEditForm(FrameForm.ActiveMDIChild).FezAnotacoesDeTexto := True;
End;

Procedure TAnotaTextoForm.Memo1Change(Sender: TObject);
Begin
If Memo1.Text = '' Then
  TEditForm(FrameForm.ActiveMDIChild).FezAnotacoesDeTexto := False;
End;

Procedure TAnotaTextoForm.FormCreate(Sender: TObject);
Begin
Label1.Caption := '0 de 0';
End;

Procedure TAnotaTextoForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
Begin
If ScrollCode <> scEndScroll Then
  Exit;
If ADOQuery1.RecNo = ScrollPos Then
  Exit;
If ADOQuery1.RecNo < ScrollPos Then
  ADOQuery1.Next
Else
  ADOQuery1.Prior;
Memo1.Text := ADOQuery1.FieldByName('COMENTARIOTXT').AsString;
If ADOQuery1.FieldByName('FLAGPUBLICO').AsString = 'T' Then
  PublicaRadioButton.Checked := True
Else
  PrivadaRadioButton.Checked := True;
Label1.Caption := IntToStr(ScrollPos)+' de '+IntToStr(ScrollBar1.Max);
End;

End.
