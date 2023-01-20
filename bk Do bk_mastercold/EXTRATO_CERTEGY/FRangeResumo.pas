Unit FRangeResumo;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, dfPdf;

Type
  TRangeFormResumo = Class(TForm)
    NovaConsultaButton: TButton;
    SairButton: TButton;
    ListBox1: TListBox;
    Label3: TLabel;
    ImprimirButton: TButton;
    Image1: TImage;
    Label4: TLabel;
    EditOrg: TEdit;
    Label5: TLabel;
    EditLogo: TEdit;
    Label6: TLabel;
    Label29: TLabel;
    EditNome: TEdit;
    EditConta: TEdit;
    GerarPdfButton: TButton;
    SaveDialog1: TSaveDialog;
    Image2: TImage;
    GerarTxtButton: TButton;
    GerarTxtButtonFmt: TButton;
    procedure ImprimirButtonClick(Sender: TObject);
    procedure NovaConsultaButtonClick(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  RangeFormResumo: TRangeFormResumo;

Implementation

{$R *.DFM}

Uses SuGeral, Subrug, SelCont, EditTest, FExtr, RelResumoU;

Procedure TRangeFormResumo.ImprimirButtonClick(Sender: TObject);
Var
  GerouPdf,
  Imprimiu,
  Faiou,
  GerouCabec : Boolean;
  I      : Integer;
  ArqTxt : System.Text;
  AuxStr : AnsiString;

  Procedure GravaArqTxt(Diminui : Integer);
  Var
    X : Integer;
  Begin
  Append(ArqTxt);

  With RelResumo.DFEngine1 Do
    Begin

    if (Sender = GerarTxtButton) Then
      For X := 1 To CntMnt Do
        WriteLn(ArqTxt, Setiraponto(FieldByName('FieldConta').AsString) +
                        FieldByName('Field_Dt'+IntToStr(X)).AsString +
                        SeImpRel(Setiraponto(FieldByName('FieldSan'+IntToStr(X)).AsString), 'D', 15) +
                        SeImpRel(Setiraponto(FieldByName('Field_CS'+IntToStr(X)).AsString), 'D', 15) +
                        SeImpRel(Setiraponto(FieldByName('Field_ts'+IntToStr(X)).AsString), 'D', 15) +
                        SeImpRel(Setiraponto(FieldByName('Field_te'+IntToStr(X)).AsString), 'D', 15) +
                        SeImpRel(Setiraponto(FieldByName('Field_Ep'+IntToStr(X)).AsString), 'D', 15) +
                        SeImpRel(Setiraponto(FieldByName('FieldSat'+IntToStr(X)).AsString), 'D', 15) +
                        SeImpRel(Setiraponto(FieldByName('Field_enc'+IntToStr(X)).AsString), 'D', 15) +
                        SeImpRel(Setiraponto(FieldByName('Field_Pgto'+IntToStr(X)).AsString), 'D', 15) +
                        FieldByName('Field_dia'+IntToStr(X)).AsString +
                        SeImpRel(Setiraponto(FieldByName('Field_sld_rema'+IntToStr(X)).AsString), 'D', 15))
    else
      begin         // (Sender = GerarTxtButtonFmt)
      If not GerouCabec then
        begin
        Writeln(ArqTxt,'CONTA;DATA VENCIMENTO;SALDO ANTERIOR;COMPRAS E SAQUES;TAXAS E ANUIDADES; AJUSTES;ENCARGOS;SALDO;TAXA;PAGAMENTO;DIA;SALDO REMANESCENTE');
        GerouCabec := true;
        end;
      For X := 1 To CntMnt-Diminui Do
        WriteLn(ArqTxt, Setiraponto(FieldByName('FieldConta').AsString) + ';' +
                        FieldByName('Field_Dt'+IntToStr(X)).AsString + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('FieldSan'+IntToStr(X)).AsString), 'D', 15)) +  ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('Field_CS'+IntToStr(X)).AsString), 'D', 15)) + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('Field_ts'+IntToStr(X)).AsString), 'D', 15)) + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('Field_te'+IntToStr(X)).AsString), 'D', 15)) + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('Field_Ep'+IntToStr(X)).AsString), 'D', 15)) + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('FieldSat'+IntToStr(X)).AsString), 'D', 15)) + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('Field_enc'+IntToStr(X)).AsString), 'D', 15)) + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('Field_Pgto'+IntToStr(X)).AsString), 'D', 15)) + ';' +
                        Trim(FieldByName('Field_dia'+IntToStr(X)).AsString) + ';' +
                        Trim(SeImpRel(Setiraponto(FieldByName('Field_sld_rema'+IntToStr(X)).AsString), 'D', 15)))
      end;
    End;

  CloseFile(ArqTxt);
  End;

Begin
//SaveDialog1.InitialDir := 'C:\';
Pdf := Tdf6ToPdfConverter.Create;

CntMnt := 0;
For I := 0 To ListBox1.Items.Count-1 Do
  If ListBox1.Selected[I] Then
    Inc(CntMnt);

CntMnt := CntMnt + 1; //Agora tem totais, então vai ter mais um conjunto de informações

TotalPags := CntMnt div ICntExtRes;
If ((CntMnt mod ICntExtRes) <> 0) Then
  Inc(TotalPags);

CntMnt := 0;
Paginacao := 0;
Imprimiu := False;
GerouPdf := False;
RelResumo.InicializaTotais;
Faiou := False;
GerouCabec := False;

If (Sender = GerarTxtButton) or (Sender = GerarTxtButtonFmt) Then
  Begin
  SaveDialog1.FilterIndex := 2;
  If SaveDialog1.Execute Then
    begin
    AssignFile(ArqTxt,SaveDialog1.FileName);
    if FileExists(SaveDialog1.FileName) then
    begin
      If MessageDlg('O Arquivo: ' + SaveDialog1.FileName + ' já existe, deseja sobrepor ?',mtConfirmation,[mbyes,mbno],0) = mryes then
        ReWrite(ArqTxt)
      else
        Append(ArqTxt);
    end
    else
      ReWrite(ArqTxt);
    CloseFile(ArqTxt);
    end
  else
    Faiou := True;
  End
Else
    SaveDialog1.FilterIndex := 1;

Try
For I := 0 To ListBox1.Items.Count-1 Do
  Begin
  If (ListBox1.Selected[I]) and (Not Faiou) Then
    Begin
    Imprimiu := True;
    Inc(CntMnt);

    AuxStr := DadosDeExtrato[I];               // Atualiza para o registro de Extr correspondente
    Move(AuxStr[1], RelResumoU.RegUnsrExtrAux, SizeOf(RgRcb.RegUnsrExtr));

      // Monta o próximo registro...
    If I < ListBox1.Items.Count-1 Then
      Begin
      AuxStr := DadosDeExtrato[I+1];               // Atualiza para o registro de Extr correspondente
      Move(AuxStr[1],RgRcb.RegUnsrExtr, SizeOf(RgRcb.RegUnsrExtr));
      End
    Else
      FillChar(RgRcb.RegUnsrExtr, SizeOf(RgRcb.RegUnsrExtr), '0');

    If (Sender = GerarTxtButton) or (Sender = GerarTxtButtonFmt) Then
      Begin
      RelResumo.MontaPagina(CntMnt, False);
      If (CntMnt = ICntExtRes) Then
        Begin
        Imprimiu := False;
        GravaArqTxt(0);
        CntMnt := 0;
        End;
      End
    Else
    If Sender = ImprimirButton Then
      Begin
      RelResumo.MontaPagina(CntMnt, False);
      If (CntMnt = ICntExtRes) Then
        Begin
        Imprimiu := False;
        RelResumo.mPrint.Click;
        RelResumo.Close;
        CntMnt := 0;
        End;
      End
    Else
      Begin
        // Pdf Staff;
      RelResumo.MontaPagina(CntMnt, False);
      GerouPdf := True;
      If (CntMnt = ICntExtRes) Then
        Begin
        Imprimiu := False;
        Pdf.MaxPages := Pdf.MaxPages + 1;    // armazena esta página um no pdf
        Pdf.AddDFPage(RelResumo.DFEngine1.Pages[0]);
        CntMnt := 0;
        RelResumo.Close;
        End;

      End;
    End;
  End;

  // Descarga dos totais
  Inc(CntMnt);

  If not faiou then
    Imprimiu := True;

  RelResumo.MontaPagina(CntMnt, True);

  If Imprimiu Then
    If (Sender = GerarTxtButton) Then
      GravaArqTxt(0)
    Else
    If (Sender = GerarTxtButtonFmt) Then
      GravaArqTxt(1)
    else
    If Sender = ImprimirButton Then
      RelResumo.mPrint.Click
    Else
      Begin
      Pdf.MaxPages := Pdf.MaxPages + 1;    // armazena esta página um no pdf
      Pdf.AddDFPage(RelResumo.DFEngine1.Pages[0]);
      End;

  If (GerouPdf) And (Sender = GerarPdfButton) And (SaveDialog1.Execute) Then
    Pdf.SaveToFile(SaveDialog1.FileName);

  ShowMessage('Ok...');
Finally
  Pdf.Free;
  End; // Try
End;

Procedure TRangeFormResumo.NovaConsultaButtonClick(Sender: TObject);
Begin
Selecons.Show;
Close;
End;

Procedure TRangeFormResumo.SairButtonClick(Sender: TObject);
Begin
Selecons.Close;
Close;
End;

End.
