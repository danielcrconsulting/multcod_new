Unit Imprim;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Printers,
  StdCtrls, ComCtrls, ExtCtrls;

Type
  TFrmImprim = Class(TForm)
    ImpriAtuRdBut: TRadioButton;
    ImpriRangeRdBut: TRadioButton;
    ImpriTudoRdBut: TRadioButton;
    ImprBut: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    SairBut: TButton;
    ProgressBar1: TProgressBar;
    Edit3: TEdit;
    ImpriPesqRdBut: TRadioButton;
    ApenasLinhasComPesquisaCheckBox: TCheckBox;
    StrPagina: TMemo;
    PrintDialog1: TPrintDialog;
    Panel1: TPanel;
    ImpGraphRadioButton: TRadioButton;
    ImpTextRadioButton: TRadioButton;
    InclAntTxtCheckBox: TCheckBox;
    ImpGraphAnotRadioButton: TRadioButton;
    Procedure FormCreate(Sender: TObject);
    Procedure ImprButClick(Sender: TObject);
    Procedure SairButClick(Sender: TObject);
    Procedure Edit1Change(Sender: TObject);
    Procedure ImpriTudoRdButClick(Sender: TObject);
    procedure ImpriPesqRdButClick(Sender: TObject);
    procedure ImpriRangeRdButClick(Sender: TObject);
    procedure ApenasLinhasComPesquisaCheckBoxClick(Sender: TObject);
    procedure ImpGraphRadioButtonClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FrmImprim: TFrmImprim;

Implementation

Uses Mdiedit, MdiMultiCold, SuGeral, SutypGer, ZLib, LogInForm, Subrug;

{$R *.DFM}

Procedure TFrmImprim.FormCreate(Sender: TObject);
Begin
ImpriAtuRdBut.Checked := True;
End;

Procedure TFrmImprim.ImprButClick(Sender: TObject);

Var
  StrAux : String;
  ContaLinha : Integer;
  PgIni,
  PgFin,
  PgOri,
  Erro,
  I : Integer;
  LinPrese : Set Of Byte;
  TempImp : System.Text;
  ComandoDeCarro : Char;
  AnotGraf : Boolean;
//  B: TBitmap;

  Procedure ImprimeLinha(piLinha : String);

  Begin

  If Length(piLinha) = 0 Then
    Begin
    WriteLn(TempImp);
    Exit;
    End;

  If piLinha[1] = Chr(1) Then  { é uma linha marcada }
    Begin
    Delete(piLinha,1,1);
    Printer.Canvas.Font.Style := Printer.Canvas.Font.Style + [FsBold];
    End;

  ComandoDeCarro := ' ';
  If TEditForm(FrameForm.ActiveMDIChild).Report133CC Then
    Begin
    If piLinha[1] = '1' Then
      piLinha[1] := ' '
    Else
      If piLinha[1] = '0' Then
        Begin
        piLinha[1] := ' ';                  { Pula Uma Linha BEFORE}
        WriteLn(TempImp)
        End
      Else
        Begin
        ComandoDeCarro := piLinha[1];
        piLinha[1] := ' ';
        End;
    End;

  WriteLn(TempImp,piLinha);

  If ComandoDeCarro = '-' Then  { Pula Uma Linha AFTER}
    WriteLn(TempImp);

  Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [FsBold];
  End;

  Procedure VerificaAnotacaoDeTexto;
  Var
    I : Integer;
  Begin
  If InclAntTxtCheckBox.Checked Then
    If TEditForm(FrameForm.ActiveMdiChild).AnotaTextoForm.Memo1.Lines.Count <> 0 Then
      Begin
      AssignPrn(TempImp);
      ReWrite(TempImp);
      WriteLn(TempImp,'   ANOTAÇÔES DE TEXTO - PÁGINA: '+IntToStr(TEditForm(FrameForm.ActiveMdiChild).PaginaAtu));
      WriteLn(TempImp,'');
      For I := 0 To TEditForm(FrameForm.ActiveMdiChild).AnotaTextoForm.Memo1.Lines.Count-1 Do
        Begin
        WriteLn(TempImp,'   '+TrimRight(TEditForm(FrameForm.ActiveMdiChild).AnotaTextoForm.Memo1.Lines[I]));
        End;
      CloseFile(TempImp);
//      If PrintDialog1.Execute Then;  // Retirar 
      End;
  End;

  Procedure TrabalhaADescompactacao(I : Integer);

  Var
    Ind,
    Posic : Integer;

  Begin

//  If TEditForm(FrameForm.ActiveMDIChild).Mascara Then
  If ImpGraphRadioButton.Checked Then
    With TEditForm(FrameForm.ActiveMDIChild) Do
      Begin
      CarregaImagem(False,I);
//      B:= nil;
//      Printer.BeginDoc;
//      DFEngine1.Pages[0].PrinterStretch := False;
//      If PrimeiraPagina Then
//        Begin
//        PrimeiraPagina := False;
//        DFEngine1.PrintDialog;
//        End
//      Else
      DFEngine1.Print;
//        Try
//          B := TBitmap.create;
//          B.Width:= RFMImage1.RFM.Header.Width;
//          B.Height:= RFMImage1.RFM.Header.Height;
//          RFMImage1.RFM.DrawTo(Rect(0,0,RFMImage1.RFM.Header.Width,RFMImage1.RFM.Header.Height), B.Canvas, True);
//          PrintBitMap( B, 0, 0);
//        Finally
//          B.free;
//        End; // Try
//      Printer.EndDoc;
      End
  Else
//  If ImpGraphRadioButton.Checked Then
  If ImpGraphAnotRadioButton.Checked Then
    Begin
    With TEditForm(FrameForm.ActiveMDIChild) Do
      Begin
      CarregaImagem(False,I);
      FrameForm.MostraAsImagens;
      PrintPageBMP;
      End;
    End
  Else
    Begin

    TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada := '';
    TEditForm(FrameForm.ActiveMDIChild).PaginaNormal := '';
//  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, Linha133, Linha, False);
    TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, False,'','','','','', '');

    StrPagina.Lines.Clear;
    StrPagina.Lines.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada;

    If ImpriPesqRdBut.Checked And ApenasLinhasComPesquisaCheckBox.Checked Then
      Begin
      If TEditForm(FrameForm.ActiveMDIChild).Report133CC Then
        StrPagina.Lines.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaNormal;                        // Usa o não acertado

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
          If Length(TEditForm(FrameForm.ActiveMDIChild).ArrBloqCamposDoRel) = 0 Then
            ImprimeLinha(TrimRight(StrPagina.Lines[Ind]))
          Else
            ImprimeLinha(TrimRight(TEditForm(FrameForm.ActiveMDIChild).TrataBloqueio(StrPagina.Lines[Ind], Ind+1)));
      End
    Else
      Begin
      If Length(TEditForm(FrameForm.ActiveMDIChild).ArrBloqCamposDoRel) = 0 Then
        For Ind := 0 To StrPagina.Lines.Count - 1 Do             // Imprime o conteudo Do Memo
          ImprimeLinha(TrimRight(StrPagina.Lines[Ind]))
      Else
        For Ind := 0 To StrPagina.Lines.Count - 1 Do             // Imprime o conteudo Do Memo
          ImprimeLinha(TrimRight(TEditForm(FrameForm.ActiveMDIChild).TrataBloqueio(StrPagina.Lines[Ind], Ind+1)));

      End;
    End; // End do novo begin da mascara

  If Not ImpriPesqRdBut.Checked Then
    ProgressBar1.Position := I;

  Edit3.Text := IntToStr(I);
  Application.ProcessMessages;
  End;

Begin
QuerCancelar := False;
AnotGraf := False;
If ImpriAtuRdBut.Checked Then
  Begin
  If PrintDialog1.Execute Then
    Begin
    If TEditForm(FrameForm.ActiveMDIChild).DFActiveDisplay1.Width = 0 Then
      AnotGraf := True;

    PgOri := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;

    VerificaAnotacaoDeTexto;
    
    If ImpGraphRadioButton.Checked Then
      Begin
      TEditForm(FrameForm.ActiveMDIChild).DFEngine1.Print;
      End
    Else
    If ImpGraphAnotRadioButton.Checked Then
      Begin
      FrameForm.MostraAsImagens;
      Printer.BeginDoc;
      TEditForm(FrameForm.ActiveMDIChild).PrintPageBMP;
      Printer.EndDoc;
      End
    Else
      Begin
      AssignPrn(TempImp);
      ReWrite(TempImp);
      Reset(TEditForm(FrameForm.ActiveMDIChild).ArqImp);
      ContaLinha := 0;
      While Not Eof(TEditForm(FrameForm.ActiveMDIChild).ArqImp) Do
        Begin
        ReadLn(TEditForm(FrameForm.ActiveMDIChild).ArqImp,StrAux);
        Inc(ContaLinha);
        If Length(TEditForm(FrameForm.ActiveMDIChild).ArrBloqCamposDoRel) = 0 Then
          ImprimeLinha(TrimRight(StrAux))
        Else
          ImprimeLinha(TrimRight(TEditForm(FrameForm.ActiveMDIChild).TrataBloqueio(StrAux, ContaLinha)));
        End;
      CloseFile(TEditForm(FrameForm.ActiveMDIChild).ArqImp);
      CloseFile(TempImp);
      End;
      
    If Not AnotGraf Then
      TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, PgOri);    // Volta a página anterior
    FormGeral.MostraMensagem('Fim da Impressão!');
    End;
  End
Else
If ImpriPesqRdBut.Checked Then
  Begin

  If TEditForm(FrameForm.ActiveMDIChild).Ocorre = 0 Then
    Begin
    FormGeral.MostraMensagem('Nenhuma pesquisa realizada???');
    Exit;
    End;

  If TEditForm(FrameForm.ActiveMDIChild).Mascara Then
    If ApenasLinhasComPesquisaCheckBox.Checked Then
      Begin
      FormGeral.MostraMensagem('Este tipo de impressão não é permitida neste modo...');
      Exit;
      End;
                      // Executar esta parte do if apenas quando primeiro = true;
//  If (Not Primeiro) Or (PrintDialog1.Execute) Then
  If (AbriuArqDsc) Or (PrintDialog1.Execute) Then
    Begin

    AbriuArqDsc := True;
    ProgressBar1.Min := 0;
    ProgressBar1.Max := FileSize(TEditForm(FrameForm.ActiveMDIChild).ArqPsq);

//    If Not TEditForm(FrameForm.ActiveMDIChild).Mascara Then
//    If ImpTextRadioButton.Checked Then

    If ImpTextRadioButton.Checked Or ApenasLinhasComPesquisaCheckBox.Checked Then
      Begin
      AssignPrn(TempImp);
      ReWrite(TempImp);
      End;

//    If ImpGraphRadioButton.Checked Then
    If ImpGraphAnotRadioButton.Checked Then
      Printer.BeginDoc;

    For I := 1 To TEditForm(FrameForm.ActiveMDIChild).Ocorre Do
      If Not QuerCancelar Then
        Begin

        If I <> 1 Then
//          If ImpGraphRadioButton.Checked Then
          If ImpGraphAnotRadioButton.Checked Then
            If (Printer.PageNumber mod 10) = 0 Then
              Begin
              Printer.EndDoc;
              Printer.BeginDoc;
              End
            Else
              Printer.NewPage;

        Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,I-1);
        {$i-}
        Read(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,TEditForm(FrameForm.ActiveMDIChild).RegPsq);
        {$i+}
        If IoResult <> 0 Then
          Begin
          FormGeral.MostraMensagem('Erro de Seek Prn');
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

//        If Not TEditForm(FrameForm.ActiveMDIChild).Mascara Then
          If I <> TEditForm(FrameForm.ActiveMDIChild).Ocorre Then
            If Not ApenasLinhasComPesquisaCheckBox.Checked Then
              If ImpTextRadioButton.Checked Then
                Begin
                CloseFile(TempImp);
                AssignPrn(TempImp);
                ReWrite(TempImp);
                End;
        End;

    TEditForm(FrameForm.ActiveMDIChild).RestauraPosArqPsq;
    If TEditForm(FrameForm.ActiveMDIChild).Mascara Or ImpGraphRadioButton.Checked Then
      TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True,    // Volta a página anterior
                                                        TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger)
    Else
      CloseFile(TempImp);

    If QuerCancelar Then
      FormGeral.MostraMensagem('Cancelado pelo usuário')
    Else
      FormGeral.MostraMensagem('Fim da Impressão!');

//    If ImpGraphRadioButton.Checked Then
    If ImpGraphAnotRadioButton.Checked Then
      Printer.EndDoc;

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
      FormGeral.MostraMensagem('Valor Inicial Inválido ');
      Exit;
      End;
    Val(Edit2.Text,PgFin,Erro);
    If (Erro <> 0) Or (PgIni > PgFin) Or (PgFin > TEditForm(FrameForm.ActiveMDIChild).Paginas) Then
      Begin
      FormGeral.MostraMensagem('Valor Final Inválido ');
      Exit;
      End;
    End
  Else
    Begin
    PgIni := 1;
    PgFin := TEditForm(FrameForm.ActiveMDIChild).Paginas;
    End;

  PgOri := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;

  If PrintDialog1.Execute Then
    Begin
    If TEditForm(FrameForm.ActiveMDIChild).DFActiveDisplay1.Width = 0 Then
      AnotGraf := True;

    ProgressBar1.Min := 0;
    ProgressBar1.Max := PgFin;
    ProgressBar1.Min := PgIni;

    If InclAntTxtCheckBox.Checked Then
      For I := PgIni To PgFin Do
        Begin
        TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(False,I);
        VerificaAnotacaoDeTexto;
        End;

//    If ImpGraphRadioButton.Checked Then
    If ImpGraphAnotRadioButton.Checked Then
      Printer.BeginDoc;

//    If TEditForm(FrameForm.ActiveMDIChild).Mascara Then
    If ImpGraphRadioButton.Checked Then
      For I := PgIni To PgFin Do
        Begin
        If Not QuerCancelar Then
          TrabalhaADescompactacao(I);
        End
    Else
      For I := PgIni To PgFin Do
        If Not QuerCancelar Then
          Begin
          If ImpTextRadioButton.Checked Then
            Begin
            AssignPrn(TempImp);
            ReWrite(TempImp);
            End;
          If I <> PgIni Then
//            If ImpGraphRadioButton.Checked Then
            If ImpGraphAnotRadioButton.Checked Then
              If (Printer.PageNumber mod 10) = 0 Then
                Begin
                Printer.EndDoc;
                Printer.BeginDoc;
                End
              Else
                Printer.NewPage;
          TrabalhaADescompactacao(I);
//          ShowMessage('Pausa...');       // Retirar
          If ImpTextRadioButton.Checked Then
            Begin
            CloseFile(TempImp);
//            If PrintDialog1.Execute Then; // Retirar
            End;
          End;

                      { Back To the original place }
    If Not TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
      Begin
      Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag64,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
      Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag64);
      End;

//    If TEditForm(FrameForm.ActiveMDIChild).Mascara Or ImpGraphRadioButton.Checked Then
    TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, PgOri);    // Volta a página anterior

    If AnotGraf Then
      FrameForm.MostraAsImagens;

    If QuerCancelar Then
      FormGeral.MostraMensagem('Cancelado pelo usuário')
    Else
      FormGeral.MostraMensagem('Fim da Impressão!');

//    If ImpGraphRadioButton.Checked Then
    If ImpGraphAnotRadioButton.Checked Then
      Printer.EndDoc;

    Edit3.Text := '';
    ProgressBar1.Position := PgIni;
    Application.ProcessMessages;

    End;
  End;
End;

Procedure TFrmImprim.SairButClick(Sender: TObject);
Begin
QuerCancelar := True;
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

//If ImpGraphRadioButton.Checked Then      //Imprimir linhas do relat só se for text...
ImpTextRadioButton.Checked := True;
InclAntTxtCheckBox.Checked := False;

Application.ProcessMessages;
End;

Procedure TFrmImprim.ImpGraphRadioButtonClick(Sender: TObject);
Begin
If InclAntTxtCheckBox.Checked = False Then
  Exit;
ApenasLinhasComPesquisaCheckBox.Checked := False;
Application.ProcessMessages;
End;

End.
