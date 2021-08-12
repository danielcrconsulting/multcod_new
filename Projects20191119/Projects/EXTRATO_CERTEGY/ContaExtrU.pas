Unit ContaExtrU;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

Type
  TContaExtrForm = Class(TForm)
    Memo1: TMemo;
    SairButton: TButton;
    SalvarButton: TButton;
    ContaButton: TButton;
    SaveDialog1: TSaveDialog;
    Procedure SairButtonClick(Sender: TObject);
    procedure ContaButtonClick(Sender: TObject);
    procedure SalvarButtonClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  ContaExtrForm: TContaExtrForm;

Implementation

Uses Avisoi, SuGeral, Subrug;

{$R *.dfm}

Procedure TContaExtrForm.SairButtonClick(Sender: TObject);
Begin
Close
End;

Procedure TContaExtrForm.ContaButtonClick(Sender: TObject);
Var
  LinAux : AnsiString;
  PosAux,
  J : Integer;
Begin
Memo1.Text := '';

For J := 0 To NArqExtr.Count - 1 Do
  Begin

  PosAux := Pos('MOVTO',UpperCase(NArqExtr[J]));
  If PosAux = 0 Then
    LinAux := ''
  Else
    LinAux := Copy(NArqExtr[J],PosAux+11,6);

  AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqExtr[J])+SeArquivoSemExt(NArqExtr[J])+'CONTA.IND');
  Reset(ArqIndiceContaCartao);
  Memo1.Lines.Add(LinAux+' '+IntToStr(FileSize(ArqIndiceContaCartao)));
  Application.ProcessMessages;
  CloseFile(ArqIndiceContaCartao);
  End;

SalvarButton.Enabled := True;

End;

Procedure TContaExtrForm.SalvarButtonClick(Sender: TObject);
Var
  Arq : System.Text;
Begin
If SaveDialog1.Execute Then
  Begin
  AssignFile(Arq,SaveDialog1.FileName);
  ReWrite(Arq);

  WriteLn(Arq,Memo1.Text);

  CloseFile(Arq);
  ShowMessage('Salvo...');
  End;
End;

End.
