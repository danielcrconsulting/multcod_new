Unit FRange;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, dfPdf;

Type
  TRangeForm = Class(TForm)
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
    procedure ImprimirButtonClick(Sender: TObject);
    procedure NovaConsultaButtonClick(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  RangeForm: TRangeForm;

Implementation

{$R *.DFM}

Uses SuGeral, Subrug, SelCont, EditTest, FExtr;

Procedure TRangeForm.ImprimirButtonClick(Sender: TObject);
Var
//  Primeiro,
  Imprimiu : Boolean;
//  TemMovto : Boolean;
  PagImp,
  I, J : Integer;
  AuxStr : AnsiString;
Begin
Imprimiu := False;
//Primeiro := True;
SaveDialog1.InitialDir := 'C:\';
Pdf := Tdf6ToPdfConverter.Create;
Try
For I := 0 To ListBox1.Items.Count-1 Do
  Begin
  If ListBox1.Selected[I] Then
    Begin
    Imprimiu := True;
{    AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTA.IND');
    DadosDeConta.Clear;
    Reset(ArqIndiceContaCartao);
    TestarFlag := False;
    DadosDeConta.Text := Selecons.PesquisaCarregaContaCartao(NumConta, NArqCont);
    CloseFile(ArqIndiceContaCartao);

    If DadosDeConta.Count = 0 Then
      Begin
      ShowMessage('Dados de Conta n�o encontrados, verifique...');
      Exit;
      End;

    AuxStr := DadosDeConta[0];
    Move(AuxStr[1],RegUnsrCont,Length(DadosDeConta[0])); 

    AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND');
    DadosDeCartao.Clear;
    Reset(ArqIndiceContaCartao);
    TestarFlag := False;
    DadosDeCartao.Text := Selecons.PesquisaCarregaContaCartao(NumConta, NArqCart);
    CloseFile(ArqIndiceContaCartao);

    If DadosDeCartao.Count = 0 Then
      Begin
      ShowMessage('Dados de Cart�o n�o encontrados, verifique...');
      Exit;
      End;            ESTES DADOS DEVEM ESTAR PREVIAMENTE LIDOS}

    IAnoMesExtrato := I;
    Detex.Clear;
    Detex.Sorted := False;
//    TemMovto := False;
    For J := 0 To NArqDetex.Count - 1 Do
      If Pos(ListBox1.Items[I],NArqDetex[J]) <> 0 Then
          Begin
          AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqDetex[J])+SeArquivoSemExt(NArqDetex[J])+'CONTA.IND');
          Reset(ArqIndiceContaCartao);
          TestarFlag := False;
          AuxStr := Selecons.PesquisaCarregaContaCartao(NumConta, NArqDetex[J]);
          Detex.Clear;
          Detex.Sorted := False;
          If AuxStr <> '' Then
            Detex.Text := AuxStr;
          CloseFile(ArqIndiceContaCartao);

          If RgRcb.RegUnsrCont.ContNormal.TipoConta = 'J' Then
            Begin
            Empresarial := True;
            ExtrForm.LevantaDetexPortadores(J);
            End
          Else
            Empresarial := False;

          End;

//    If Detex.Count = 0 Then
//      ShowMessage('Dados de Extrato deste per�odo n�o encontrados: '+ListBox1.Items[I])
//    Else
//      Begin

    AuxStr := DadosDeExtrato[I];               // Atualiza para o registro de Extr correspondente 
    Move(AuxStr[1],RgRcb.RegUnsrExtr,SizeOf(RgRcb.RegUnsrExtr));

    Detex.Sorted := True; // Ordena para a impress�o......
    ExtrForm.MontaDetalheExtrato;   // monta extrato mesmo sem detex, pois pode haver s� extr sem lan�amentos...
    If Sender = ImprimirButton Then
      Begin
      DlgTest.Show;
      DlgTest.mPrint.Click;
      DlgTest.Close;
      End
    Else
      Begin
        // Pdf Staff;
      DlgTest.Show; // Monta a p�gina 1 automaticamente
      Pdf.MaxPages := Pdf.MaxPages + 1;    // armazena esta p�gina um no pdf
      Pdf.AddDFPage(DlgTest.DFEngine1.Pages[0]);
      PagImp := 2;    // aponta para a p�gina 2
      While PagImp <= TotalPags Do // se h� 2 ou mais p�ginas, monta e completa o pdf
        Begin
        DlgTest.MontaPagina(PagImp);
        Pdf.MaxPages := Pdf.MaxPages + 1;
        Pdf.AddDFPage(DlgTest.DFEngine1.Pages[0]);
        Inc(PagImp);
        End;
      DlgTest.Close;
      End;
//      End;
    End;
  End;
If Not Imprimiu Then
  ShowMessage('Nenhum extrato selecionado')
Else
  Begin
  If (Sender = GerarPdfButton) And (SaveDialog1.Execute) Then
      Pdf.SaveToFile(SaveDialog1.FileName);
  ShowMessage('Ok...');
  End;
Finally
  Pdf.Free;
  End; // Try
End;

Procedure TRangeForm.NovaConsultaButtonClick(Sender: TObject);
Begin
Selecons.Show;
Close;
End;

Procedure TRangeForm.SairButtonClick(Sender: TObject);
Begin
Selecons.Close;
Close;
End;

End.