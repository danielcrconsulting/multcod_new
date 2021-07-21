Unit Imprim;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Printers,
  StdCtrls, ComCtrls;

Type
  TFrmImprim = Class(TForm)
    ImpriAtuRdBut: TRadioButton;
    ImpriRangeRdBut: TRadioButton;
    ImpriTudoRdBut: TRadioButton;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    Edit3: TEdit;
    ImpriPesqRdBut: TRadioButton;
    ApenasLinhasComPesquisaCheckBox: TCheckBox;
    StrPagina: TMemo;
    PrintDialog1: TPrintDialog;
    Procedure FormCreate(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure Edit1Change(Sender: TObject);
    Procedure ImpriTudoRdButClick(Sender: TObject);
    procedure ImpriPesqRdButClick(Sender: TObject);
    procedure ImpriRangeRdButClick(Sender: TObject);
    procedure ApenasLinhasComPesquisaCheckBoxClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FrmImprim: TFrmImprim;

Implementation

Uses Mdiedit, MdiMultiCold, SuGeral, SutypGer, ZLib, LogInForm;

{$R *.DFM}

Procedure TFrmImprim.FormCreate(Sender: TObject);
Begin
ImpriAtuRdBut.Checked := True;
End;

Procedure TFrmImprim.Button1Click(Sender: TObject);

Var
  Linha,
  Linha133 : String;
  PgIni,
  PgFin,
  Erro,
  I : Integer;
  LinPrese : Set Of Byte;
  TempImp : System.Text;
  ComandoDeCarro : Char;

  Procedure ImprimeLinha(Linha : String);

  Begin

  If Length(Linha) = 0 Then
    Begin
    WriteLn(TempImp);
    Exit;
    End;

  If Linha[1] = Chr(1) Then  { é uma linha marcada }
    Begin
    Delete(Linha,1,1);
    Printer.Canvas.Font.Style := Printer.Canvas.Font.Style + [FsBold];
    End;

  ComandoDeCarro := ' ';
  If TEditForm(FrameForm.ActiveMDIChild).Report133CC Then
    Begin
    If Linha[1] = '1' Then
      Linha[1] := ' '
    Else
      If Linha[1] = '0' Then
        Begin
        Linha[1] := ' ';                  { Pula Uma Linha BEFORE}
        WriteLn(TempImp)
        End
      Else
        Begin
        ComandoDeCarro := Linha[1];
        Linha[1] := ' ';
        End;
    End;

  WriteLn(TempImp,Linha);

  If ComandoDeCarro = '-' Then  { Pula Uma Linha AFTER}
    WriteLn(TempImp);

  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [FsBold];
  End;

  Procedure TrabalhaADescompactacao(I : Integer);

  Var
    Ind : Integer;
    Posic : Integer;

  Begin

  Linha := '';
  Linha133 := '';
  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, Linha133, Linha);

  StrPagina.Lines.Clear;
  StrPagina.Lines.Text := Linha;

  If ImpriPesqRdBut.Checked And ApenasLinhasComPesquisaCheckBox.Checked Then
    Begin
    If TEditForm(FrameForm.ActiveMDIChild).Report133CC Then
      StrPagina.Lines.Text := Linha133;                        // Usa o não acertado

    LinPrese := [];
    If TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
      Begin
      PgIni := TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[1].AsInteger;
      While (PgIni = TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[1].AsInteger) And
            (Not TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Eof)  Do
        Begin
        Posic := 3;
        While Posic <= TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.FieldCount Do
          Begin
          LinPrese := LinPrese + [Byte(TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[Posic].AsInteger)];
          TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Next;
          Inc(Posic,5);
          End;
        End;                                                     // Imprime apenas o conteudo selecionado
      End
    Else
      Begin
      PgIni := TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger;
      While (PgIni = TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger) And
            (Not TEditForm(FrameForm.ActiveMDIChild).Query1.Eof)  Do
        Begin
        Posic := 3;
        While Posic <= TEditForm(FrameForm.ActiveMDIChild).Query1.FieldCount Do
          Begin
          LinPrese := LinPrese + [Byte(TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[Posic].AsInteger)];
          TEditForm(FrameForm.ActiveMDIChild).Query1.Next;
          Inc(Posic,5);
          End;
        End;                                                     // Imprime apenas o conteudo selecionado
      End;

    For Ind := 0 To StrPagina.Lines.Count - 1 Do
      If Ind+1 In LinPrese Then
        ImprimeLinha(StrPagina.Lines[Ind]);
    End
  Else
    Begin
    For Ind := 0 To StrPagina.Lines.Count - 1 Do             // Imprime o conteudo Do Memo
      ImprimeLinha(StrPagina.Lines[Ind]);
    End;

  If Not ImpriPesqRdBut.Checked Then
    ProgressBar1.Position := I;

  Edit3.Text := IntToStr(I);
  Application.ProcessMessages;
  End;

Begin
If ImpriAtuRdBut.Checked Then
  Begin
  If PrintDialog1.Execute Then
    Begin

    AssignPrn(TempImp);
    ReWrite(TempImp);
    Reset(TEditForm(FrameForm.ActiveMDIChild).ArqImp);

    While Not Eof(TEditForm(FrameForm.ActiveMDIChild).ArqImp) Do
      Begin
      ReadLn(TEditForm(FrameForm.ActiveMDIChild).ArqImp,Linha);
      ImprimeLinha(Linha);
      End;

    CloseFile(TEditForm(FrameForm.ActiveMDIChild).ArqImp);
    CloseFile(TempImp);

    ShowMessage('Fim da Impressão!');

    End;
  End
Else
If ImpriPesqRdBut.Checked Then
  Begin

  If TEditForm(FrameForm.ActiveMDIChild).Ocorre = 0 Then
    Begin
    ShowMessage('Nenhuma pesquisa realizada???');
    Exit;
    End;

  If PrintDialog1.Execute Then
    Begin

    ProgressBar1.Min := 0;
    ProgressBar1.Max := FileSize(TEditForm(FrameForm.ActiveMDIChild).ArqPsq);

    AssignPrn(TempImp);
    ReWrite(TempImp);

    For I := 1 To TEditForm(FrameForm.ActiveMDIChild).Ocorre Do
      Begin
      Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,I-1);
      {$i-}
      Read(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,TEditForm(FrameForm.ActiveMDIChild).RegPsq);
      {$i+}
      If IoResult <> 0 Then
        Begin
        ShowMessage('Erro de Seek Prn');
        Application.Terminate;
        End;

      If TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
        Begin
        TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.First;
        TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.MoveBy(TEditForm(FrameForm.ActiveMDIChild).RegPsq.PosQuery-1);
        TrabalhaADescompactacao(TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[1].AsInteger);
        End
      Else
        Begin
        TEditForm(FrameForm.ActiveMDIChild).Query1.First;
        TEditForm(FrameForm.ActiveMDIChild).Query1.MoveBy(TEditForm(FrameForm.ActiveMDIChild).RegPsq.PosQuery-1);
        TrabalhaADescompactacao(TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger);
        End;

      ProgressBar1.Position := I;
      
      If I <> TEditForm(FrameForm.ActiveMDIChild).Ocorre Then
        If Not ApenasLinhasComPesquisaCheckBox.Checked Then
          Begin
          CloseFile(TempImp);
          AssignPrn(TempImp);
          ReWrite(TempImp);
          End;

      End;
    CloseFile(TempImp);

    TEditForm(FrameForm.ActiveMDIChild).RestauraPosArqPsq;
    ShowMessage('Fim da Impressão!');
    Edit3.Text := '';
    ProgressBar1.Position := 0;
    Application.ProcessMessages;
    End;
  End
Else
If ImpriRangeRdBut.Checked Or ImpriTudoRdBut.Checked Then
  Begin
  If ImpriRangeRdBut.Checked Then
    Begin
    Val(Edit1.Text,PgIni,Erro);
    If (Erro <> 0) Or (PgIni < 1) Then
      Begin
      ShowMessage('Valor Inicial Inválido ');
      Exit;
      End;
    Val(Edit2.Text,PgFin,Erro);
    If (Erro <> 0) Or (PgIni > PgFin) Or (PgFin > TEditForm(FrameForm.ActiveMDIChild).Paginas) Then
      Begin
      ShowMessage('Valor Final Inválido ');
      Exit;
      End;
    End
  Else
    Begin
    PgIni := 1;
    PgFin := TEditForm(FrameForm.ActiveMDIChild).Paginas;
    End;

  If PrintDialog1.Execute Then
    Begin

    ProgressBar1.Max := PgFin;
    ProgressBar1.Min := PgIni;

    For I := PgIni To PgFin Do
      Begin
      AssignPrn(TempImp);
      ReWrite(TempImp);

      TrabalhaADescompactacao(I);

      CloseFile(TempImp);
      End;

                      { Back To the original place }
    If Not TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
      If TEditForm(FrameForm.ActiveMDIChild).Pagina64 Then
        Begin
        Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag64,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
        Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag64);
        End
      Else
        Begin
        Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag32,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
        Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag32);
        End;

    ShowMessage('Fim da Impressão!');
    Edit3.Text := '';
    ProgressBar1.Position := PgIni;
    Application.ProcessMessages;

    End;
  End;
End;

Procedure TFrmImprim.Button2Click(Sender: TObject);
Begin
Close;
End;

Procedure TFrmImprim.Edit1Change(Sender: TObject);
Begin
If Edit1.Text = '' Then
  Exit;
ImpriRangeRdBut.Checked := True;
Application.ProcessMessages;
End;

Procedure TFrmImprim.ImpriTudoRdButClick(Sender: TObject);
Begin
Edit1.Text := '';
Edit2.Text := '';
ApenasLinhasComPesquisaCheckBox.Checked := False;
Application.ProcessMessages;
End;

Procedure TFrmImprim.ImpriPesqRdButClick(Sender: TObject);
Begin
Edit1.Text := '';
Edit2.Text := '';
Application.ProcessMessages;
End;

Procedure TFrmImprim.ImpriRangeRdButClick(Sender: TObject);
Begin
ApenasLinhasComPesquisaCheckBox.Checked := False;
Application.ProcessMessages;
End;

Procedure TFrmImprim.ApenasLinhasComPesquisaCheckBoxClick(Sender: TObject);
Begin
If ApenasLinhasComPesquisaCheckBox.Checked = False Then
  Exit;
Edit1.Text := '';
Edit2.Text := '';
ImpriPesqRdBut.Checked := True;
Application.ProcessMessages;
End;

End.
