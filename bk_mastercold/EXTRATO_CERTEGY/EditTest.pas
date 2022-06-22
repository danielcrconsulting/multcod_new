Unit EditTest;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, dfclasses, dfcontrols, dfPdf;

Type
  TdlgTest = Class(TForm)
    ScrollBox1: TScrollBox;
    MainMenu1: TMainMenu;
    Scale1: TMenuItem;
    File1: TMenuItem;
    N2: TMenuItem;
    mClose: TMenuItem;
    N1: TMenuItem;
    mPrint: TMenuItem;
    mScreenHeight: TMenuItem;
    mScreenWidth: TMenuItem;
    m100: TMenuItem;
    m50: TMenuItem;
    m150: TMenuItem;
    OpenDialog1: TOpenDialog;
    mExportPDF: TMenuItem;
    SaveDialog1: TSaveDialog;
    PrintDialog1: TPrintDialog;
    PginaAnterior1: TMenuItem;
    PrximaPgina1: TMenuItem;
    Pgina1deX1: TMenuItem;
    DFEngine1: TDFEngine;
    m200: TMenuItem;
    m75: TMenuItem;
    DFActiveDisplay1: TDFActiveDisplay;
    DFEngineEmpr1: TDFEngine;
    DFEngineEmpr2: TDFEngine;
    DFEngineFis1: TDFEngine;
    DFEngineFis2: TDFEngine;
    Procedure FormShow(Sender: TObject);
    Procedure FileMenuClick(Sender: TObject);
    Procedure ScaleMenuClick(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    procedure PginaAnterior1Click(Sender: TObject);
    procedure PrximaPgina1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
  Public
    Procedure MontaPagina(Pagina : Integer);
    Function LevantarNumeroDeLancamentosDetex(Var DfEngine : TDFEngine) : Integer;
    Procedure PesquisaNome;
  End;

Var
  DlgTest: TdlgTest;
  LastScale: TObject;
  Pdf : TDF6toPDFConverter;

Implementation

{$R *.DFM}

Uses
  MasterU, SuGeral;

Var
  PaginaAtu : Integer;
  RegUnsrExtrAux : TgUnsrExtr;
  AuxStr,
  AuxCep : AnsiString;

Procedure TdlgTest.PesquisaNome;
Var
  L : Integer;
  AuxStr : AnsiString;
Begin
Nome := '';
If (Empresarial) And (RgRcb.RegUnsrCont.ContNormal.TipoConta = 'J') Then
  Begin
  For L := 0 To DadosDeCartaoDePortadores.Count-1 Do
    Begin
    AuxStr := DadosDeCartaoDePortadores[L];
    Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(AuxStr));
    If RgRcb.RegUnsrCartAux.CartNormal.Cartao = CartaoAnt Then
      Begin
      Nome := RgRcb.RegUnsrCartAux.CartNormal.NomeCartao;
      Break;
      End;
    End;
  If Nome = '' Then // Ainda não achou o nome, vai procurar na lista normal...
    For L := 0 To DadosDeCartao.Count-1 Do
      Begin
      AuxStr := DadosDeCartao[L];
      Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(AuxStr));
      If RgRcb.RegUnsrCartAux.CartNormal.Cartao = CartaoAnt Then
        Begin
        Nome := RgRcb.RegUnsrCartAux.CartNormal.NomeCartao;
        Break;
        End;
      End;
  End
Else          
  Begin
  For L := 0 To DadosDeCartao.Count-1 Do
    Begin
    AuxStr := DadosDeCartao[L];
    Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(AuxStr));
    If RgRcb.RegUnsrCartAux.CartNormal.Cartao = CartaoAnt Then
      Begin
      Nome := RgRcb.RegUnsrCartAux.CartNormal.NomeCartao;
      Break;
      End;
    End;
  End;
End;

Function TdlgTest.LevantarNumeroDeLancamentosDetex(Var DfEngine : TDFEngine) : Integer;
Begin
Result := 1;
Repeat
  Try
    DFEngine.FieldByName('Field'+IntToStr(Result)).AsString := '';
  Except
    Dec(Result);
    Break;
  End; // Try
  Inc(Result);
Until False;
End;

Procedure TdlgTest.MontaPagina(Pagina : Integer);
Var
  J,
  K : Integer;

Begin
If Empresarial Then
  Begin
  If Pagina = 1 Then
    Begin
    DFEngine1 := DFEngineEmpr1;
    End
  Else
    Begin
    DFEngine1 := DFEngineEmpr2;
    End
  End
Else
  Begin
  If Pagina = 1 Then
    Begin
    DFEngine1 := DFEngineFis1;
    End
  Else
    Begin
    DFEngine1 := DFEngineFis2;
    End
  End;

DFEngine1.ClearFields;
DFEngine1.BeginUpdate;

DFActiveDisplay1.FormEngine := DFEngine1;   // Precisa atualizar por causa da atribuição anterior...
DFActiveDisplay1.Autosize := True;

Try
  DFEngine1.FieldByName('FieldServCli1').AsString := LinCli1;
  DFEngine1.FieldByName('FieldServCli2').AsString := LinCli2;
  J := DFEngine1.Pages[0].Width;
  DFengine1.FieldByName('FieldServCli1').Left := (J - DFengine1.FieldByName('FieldServCli1').Width) Div 2;
  DFengine1.FieldByName('FieldServCli2').Left := (J - DFengine1.FieldByName('FieldServCli2').Width) Div 2;
Except
  End; // Try

For J := DadosDeCartao.Count-1 DownTo 0 Do
  Begin
  AuxStr := DadosDeCartao[J];
  Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(AuxStr));
  If RgRcb.RegUnsrCartAux.CartNormal.Titular = '0' Then
    Break;
  End;

DFEngine1.FieldByName('FieldNome').AsString := RgRcb.RegUnsrCont.ContNormal.NomeExt;  // .NomeCartao;
If Empresarial And (RgRcb.RegUnsrCont.ContNormal.TipoConta = 'P') Then
  DFEngine1.FieldByName('FieldNomeEmpresa').AsString := RgRcb.RegUnsrContEmpresaDoPortador.ContNormal.NomeExt;

Try
  DFEngine1.FieldByName('FieldCartao').AsString := Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,1,4)+'.'+
                                                   Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,5,4)+'.'+
                                                   Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,9,4)+'.'+
                                                   Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,13,4);
  Except
  End; //Try
  
AuxStr := DadosDeExtrato[IAnoMesExtrato];
Move(AuxStr[1],RegUnsrExtrAux,SizeOf(RegUnsrExtrAux));

If Empresarial Then
  Begin
  DFEngine1.FieldByName('FieldConta').AsString := IntToStr(StrToInt64(RgRcb.RegUnsrCont.ContNormal.Conta));
  DFEngine1.FieldByName('FieldVencimento').AsString := Copy(RegUnsrExtrAux.DataVencto,7,2)+'/'+
                                                       Copy(RegUnsrExtrAux.DataVencto,5,2)+'/'+
                                                       Copy(RegUnsrExtrAux.DataVencto,1,4);
  End
Else
  Try
    FormatSettings.DecimalSeparator := '.';
    ValAux5 := StrToFloat(Trim(RegUnsrExtrAux.VlrTaxaJuros));          // Juros
    ValAux16 := StrToFloat(Trim(RegUnsrExtrAux.VlrTaxaJurosAtraso));
    ValAux17 := StrToFloat(Trim(RegUnsrExtrAux.VlrTaxaJurosProxPer));
    ValAux19 := StrToFloat(Trim(RegUnsrExtrAux.VlrTaxaJurosProxPerAtraso));

    FormatSettings.DecimalSeparator := ',';
    DFEngine1.FieldByName('FieldTaxaDeJuros0').AsString := FormatFloat('##0.00',ValAux5)+' %(AM)';
    DFEngine1.FieldByName('FieldTaxaDeJuros1').AsString := FormatFloat('##0.00',ValAux16)+' %(AM)';
    DFEngine1.FieldByName('FieldTaxaDeJuros2').AsString := FormatFloat('##0.00',ValAux17)+' %(AM)';
    DFEngine1.FieldByName('FieldTaxaDeJuros3').AsString := FormatFloat('##0.00',ValAux19)+' %(AM)';
  Except
    End; // Try

If Pagina = 1 Then
  Begin
  DFEngine1.FieldByName('FieldVencimento').AsString := Copy(RegUnsrExtrAux.DataVencto,7,2)+'/'+
                                                       Copy(RegUnsrExtrAux.DataVencto,5,2)+'/'+
                                                       Copy(RegUnsrExtrAux.DataVencto,1,4);
  FormatSettings.DecimalSeparator := '.';

  ValAux1 := StrToFloat(Trim(RegUnsrExtrAux.VlrLimAtu));

  If Empresarial And (RgRcb.RegUnsrCont.ContNormal.TipoConta = 'J') Then
    ValAux2 := 0
  Else
    ValAux2 := StrToFloat(Trim(RegUnsrExtrAux.VlrLimSaque));

  ValAux3 := StrToFloat(Trim(RegUnsrExtrAux.VlrSaldoExtrAnter));
  ValAux4 := StrToFloat(Trim(RegUnsrExtrAux.VlrAmortPagtos));

  If (CodOrgSelecionada = '275') Or (CodOrgSelecionada = '356') Then
    Begin
    End
  Else
    ValAux4 := ValAux4 * (-1);  
  
  ValAux6 := StrToFloat(Trim(RegUnsrExtrAux.VlrEncargos));
  ValAux7 := StrToFloat(Trim(RegUnsrExtrAux.VlrTaxasAnuid));
  ValAux8 := StrToFloat(Trim(RegUnsrExtrAux.VlrAjustes1));
  ValAux9 := StrToFloat(Trim(RegUnsrExtrAux.VlrCompras));
  ValAux10 := StrToFloat(Trim(RegUnsrExtrAux.VlrParcFixas));
  ValAux11 := StrToFloat(Trim(RegUnsrExtrAux.VlrSaldoAtu));        // TotalUsd
  ValAux12 := StrToFloat(Trim(RegUnsrExtrAux.VlrSaldoAtuConvert)); // TotalInternacional
  ValAux13 := StrToFloat(Trim(RegUnsrExtrAux.VlrCota));
  ValAux14 := StrToFloat(Trim(RegUnsrExtrAux.VlrSaldoAtual));
  ValAux15 := StrToFloat(Trim(RegUnsrExtrAux.VlrPagtoMinTotal));
  ValAux20 := StrToFloat(Trim(RegUnsrExtrAux.VlrSaldoAtual));
  ValAux21 := StrToFloat(Trim(RegUnsrExtrAux.VlrPremioSeguro));

  FormatSettings.DecimalSeparator := ',';
  DFEngine1.FieldByName('FieldLimiteCredito').AsString := FormatFloat('###,###,###,##0.00',ValAux1);
  DFEngine1.FieldByName('FieldLimiteSaque').AsString := FormatFloat('###,###,###,##0.00',ValAux2);
  DFEngine1.FieldByName('FieldCreditos').AsString := FormatFloat('###,###,###,##0.00',ValAux4);

  If ValAux8 < 0 Then // Se ele é negativo ao subtrair o programa estará somando na realidade
    DFEngine1.FieldByName('FieldCreditos').AsString := FormatFloat('###,###,###,##0.00',ValAux4-ValAux8);

  If Empresarial Then
    Begin
//    If ValAux8 < 0 Then // Se ele é negativo ao subtrair o programa estará somando na realidade
//      DFEngine1.FieldByName('FieldCreditos').AsString := FormatFloat('###,###,###,##0.00',ValAux4-ValAux8);
                // Total empresarial fica igual ao total mínimo - 16/05/2002
    DFEngine1.FieldByName('FieldTotalFatura').AsString := FormatFloat('###,###,###,##0.00',ValAux15);
    End
  Else
    Begin
    Try
      DFEngine1.FieldByName('FieldTotFatAnt').AsString := FormatFloat('###,###,###,##0.00',ValAux3);
      Except
      End; //Try
    Try
      DFEngine1.FieldByName('FieldAmortizacoes').AsString := FormatFloat('###,###,###,##0.00',ValAux4);
      Except
      End; //Try
//    If (CodOrgSelecionada = '275') Or (CodOrgSelecionada = '356') Then
    Try
      DFEngine1.FieldByName('FieldSldFatAntAtu').AsString := FormatFloat('###,###,###,##0.00',(ValAux3)-ValAux4);
      Except
      End; //Try
//    Else
//      DFEngine1.FieldByName('FieldSldFatAntAtu').AsString := FormatFloat('###,###,###,##0.00',(ValAux3)+ValAux4);
    Try
      DFEngine1.FieldByName('FieldEncargos').AsString := FormatFloat('###,###,###,##0.00',ValAux6);
      Except
      End; //Try
    Try
      DFEngine1.FieldByName('FieldTaxasAnuidades').AsString := FormatFloat('###,###,###,##0.00',ValAux7+ValAux21);
      Except
      End; //Try
    Try
      DFEngine1.FieldByName('FieldAjustes').AsString := FormatFloat('###,###,###,##0.00',ValAux8);
      Except
      End; //Try
    Try
      if RegUnsrExtrAux.DataVencto >= '20171107' then        // Romero acerto conductor
        DFEngine1.FieldByName('FieldComprasSaques').AsString := FormatFloat('###,###,###,##0.00',ValAux9)
      else
        DFEngine1.FieldByName('FieldComprasSaques').AsString := FormatFloat('###,###,###,##0.00',ValAux9+ValAux12);
      Except
      End; //Try
    Try
      DFEngine1.FieldByName('FieldParcelasFixas').AsString := FormatFloat('###,###,###,##0.00',ValAux10);
      Except
      End; //Try
    Try
      if RegUnsrExtrAux.DataVencto >= '20171107' then
        DFEngine1.FieldByName('FieldTotalFaturaII').AsString := FormatFloat('###,###,###,##0.00',ValAux14)
      else
        DFEngine1.FieldByName('FieldTotalFaturaII').AsString := FormatFloat('###,###,###,##0.00',ValAux12+ValAux14);
      Except
      End; //Try
    Try
      if RegUnsrExtrAux.DataVencto >= '20171107' then
        DFEngine1.FieldByName('FieldTotalFatura').AsString := FormatFloat('###,###,###,##0.00',ValAux14)
      Else
        DFEngine1.FieldByName('FieldTotalFatura').AsString := FormatFloat('###,###,###,##0.00',ValAux12+ValAux14);
      Except
      End; //Try
    End;

  DFEngine1.FieldByName('FieldTotalUsd').AsString := FormatFloat('###,###,###,##0.00',ValAux11);
  DFEngine1.FieldByName('FieldSaldoAnterior').AsString := FormatFloat('###,###,###,##0.00',ValAux3);

  If ValAux8 > 0 Then
    DFEngine1.FieldByName('FieldDebitos').AsString := FormatFloat('###,###,###,##0.00',ValAux6+ValAux7+ValAux8+ValAux9+
                                                                                       ValAux10+ValAux21)
  Else
    DFEngine1.FieldByName('FieldDebitos').AsString := FormatFloat('###,###,###,##0.00',ValAux6+ValAux7+ValAux9+ValAux10+
                                                                                       ValAux21);

  DFEngine1.FieldByName('FieldTotalNacional').AsString := FormatFloat('###,###,###,##0.00',ValAux20);
  DFEngine1.FieldByName('FieldTotalInternacional').AsString := FormatFloat('###,###,###,##0.00',ValAux12);
//  DFEngine1.FieldByName('FieldCotacao').AsString := FormatFloat('###,###,###,##0.00',ValAux13);
  DFEngine1.FieldByName('FieldCotacao').AsString := FormatFloat('#,###,###,##0.0000',ValAux13);
  DFEngine1.FieldByName('FieldPagtoMinimo').AsString := FormatFloat('###,###,###,##0.00',ValAux15);
  DFEngine1.FieldByName('FieldDtCotacao').AsString := Copy(RegUnsrExtrAux.DataCota,7,2)+'/'+
                                                      Copy(RegUnsrExtrAux.DataCota,5,2)+'/'+
                                                      Copy(RegUnsrExtrAux.DataCota,1,4);

//  AuxStr := DadosDeConta[0];                               Será que precisa?
//  Move(AuxStr[1],RegUnsrCont,SizeOf(RegUnsrCont));

  DFEngine1.FieldByName('FieldNomeEnder').AsString := RgRcb.RegUnsrCont.ContNormal.NomeExt;
  If RgRcb.RegUnsrCont.ContNormal.Opc = '2' Then
    Begin
    AuxCep := Trim(RgRcb.RegUnsrCont.ContNormal.EndEmprCep);
    While Length(AuxCep) < 8 Do
      AuxCep := '0' + AuxCep;
    AuxCep := Copy(AuxCep,1,5) + '-' + Copy(AuxCep,6,3);

    DFEngine1.FieldByName('FieldEnder0').AsString := RgRcb.RegUnsrCont.ContNormal.EndEmpr;
    DFEngine1.FieldByName('FieldEnder1').AsString := RgRcb.RegUnsrCont.ContNormal.EndEmprCompl;
    DFEngine1.FieldByName('FieldEnder2').AsString := RgRcb.RegUnsrCont.ContNormal.EndEmprBairro;
    DFEngine1.FieldByName('FieldEnder3').AsString := AuxCep;
    DFEngine1.FieldByName('FieldEnder4').AsString := RgRcb.RegUnsrCont.ContNormal.EndEmprCidade;
    DFEngine1.FieldByName('FieldEnder5').AsString := RgRcb.RegUnsrCont.ContNormal.EndEmprUf;
    End
  Else
    Begin
    AuxCep := Trim(RgRcb.RegUnsrCont.ContNormal.EndResidencCep);
    While Length(AuxCep) < 8 Do
      AuxCep := '0' + AuxCep;
    AuxCep := Copy(AuxCep,1,5) + '-' + Copy(AuxCep,6,3);

    DFEngine1.FieldByName('FieldEnder0').AsString := RgRcb.RegUnsrCont.ContNormal.EndResidenc;
    DFEngine1.FieldByName('FieldEnder1').AsString := RgRcb.RegUnsrCont.ContNormal.EndResidencCompl;
    DFEngine1.FieldByName('FieldEnder2').AsString := RgRcb.RegUnsrCont.ContNormal.EndResidencBairro;
    DFEngine1.FieldByName('FieldEnder3').AsString := AuxCep;
    DFEngine1.FieldByName('FieldEnder4').AsString := RgRcb.RegUnsrCont.ContNormal.EndResidencCidade;
    DFEngine1.FieldByName('FieldEnder5').AsString := RgRcb.RegUnsrCont.ContNormal.EndResidencUf;
    End;
  End;

If Empresarial Then
  If Pagina = 1 Then
    Begin
    K := 0;
    ILct := ILctEmpr1;
    End
  Else
    Begin
    K := ILctEmpr1 + (Pagina-2)*ILctEmpr2;
    ILct := ILctEmpr2;
    End
Else
  If Pagina = 1 Then
    Begin
    K := 0;
    ILct := ILctFis1;
    End
  Else
    Begin
    K := ILctFis1 + (Pagina-2)*ILctFis2;
    ILct := ILctFis2;
    End;

For J := 1 To ILct Do
  Begin
  Try
    If Length(Extrato.Strings[K]) > 0 Then
      If Extrato.Strings[K][1] = 'N' Then
        Begin
        DFEngine1.FieldByName('Field'+IntToStr(J)).FontStyle := [fsBold];
        DFEngine1.FieldByName('Field'+IntToStr(J)).AsString := ' '+Copy(Extrato.Strings[K],2,Length(Extrato.Strings[K])-1);
        End
      Else
        Begin
        DFEngine1.FieldByName('Field'+IntToStr(J)).FontStyle := [];
        DFEngine1.FieldByName('Field'+IntToStr(J)).AsString := Extrato.Strings[K];
        End;
  Except
    Break;
    End; // Try
  Inc(K);
  If Extrato.Count = K Then  // Avoid error...
    Break;
  End;

Pgina1deX1.Caption := 'Página '+IntToStr(Pagina)+' de '+IntToStr(TotalPags);
DFEngine1.FieldByName('FieldPagina').AsString := 'Página '+IntToStr(Pagina)+'/'+IntToStr(TotalPags);

If Pagina = 1 Then
  Begin
  PginaAnterior1.Enabled := False;
  If TotalPags = 1 Then
    PrximaPgina1.Enabled := False
  Else
    PrximaPgina1.Enabled := True;
  End
Else
If Pagina = TotalPags Then
  Begin
  PrximaPgina1.Enabled := False;
  PginaAnterior1.Enabled := True;
  End
Else
  Begin
  PrximaPgina1.Enabled := True;
  PginaAnterior1.Enabled := True;
  End;
DFEngine1.EndUpdate;
End;

Procedure TdlgTest.FileMenuClick(Sender: TObject);
Var
  PagImp : Integer;
Begin
PagImp := 1;
MontaPagina(PagImp);
Repeat
  If Sender = mPrint Then
    If PagImp = 1 Then
      Begin
        DFEngine1.PrintJob := 'Extrato de Cartão de Crédito - MasterCold';
        If Not DFEngine1.PrintDialog Then
          Break;
      End
    Else
      Begin
      DFEngine1.PrintJob := 'Extrato de Cartão de Crédito - MasterCold';
      DFEngine1.Print;
      End;
  If Sender = mExportPDF Then
    Begin
    If PagImp = 1 Then
      Begin
      SaveDialog1.InitialDir := 'C:\';
      If Not SaveDialog1.Execute Then
        Break;
      Pdf := Tdf6ToPdfConverter.Create; 
      End;
//      Pdf := Tdf6ToPdfConverter.Create;
    Pdf.MaxPages := Pdf.MaxPages + 1;
    Pdf.AddDFPage(DFEngine1.Pages[0]);
    If PagImp = TotalPags Then
      Begin
//      Pdf.ConvertToPDF(DFEngine1);
//      Pdf.SaveToFile(ExtractFilePath(SaveDialog1.FileName)+
//                     ExtractFileName(SaveDialog1.FileName)+
//                     Format('%2.2d',[PagImp])+'.pdf');
      Pdf.SaveToFile(SaveDialog1.FileName);
      Pdf.Free;
      End
    End;
  If Sender = mClose Then
    ModalResult:= mrCancel;
  Inc(PagImp);
//  If PagImp = PaginaAtu Then
//    Inc(PagImp);
//  If PagImp <> PaginaAtu Then
  If PagImp <= TotalPags Then
    MontaPagina(PagImp);
Until PagImp > TotalPags;
If PagImp <> PaginaAtu Then
  If PagImp <> 0 Then
    MontaPagina(PaginaAtu);
End;

Procedure TdlgTest.ScaleMenuClick(Sender: TObject);
Begin
  LastScale:= Sender;
  If Sender = mScreenHeight Then
  Begin
    mScreenHeight.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,'PH');
  End;
  If Sender = mScreenWidth Then
  Begin
    mScreenWidth.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,'PW');
  End;
  If Sender = m200 Then
  Begin
    m200.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,200);
  End;
  If Sender = m150 Then
  Begin
    m150.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,150);
  End;
  If Sender = m100 Then
  Begin
    m100.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,100);
  End;
  If Sender = m75 Then
  Begin
    m75.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,75);
  End;
  If Sender = m50 Then
  Begin
    m50.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,50);
  End;
End;

Procedure TdlgTest.FormResize(Sender: TObject);
Begin
  ScaleMenuClick(LastScale);
End;

Procedure TdlgTest.PginaAnterior1Click(Sender: TObject);
Begin
Dec(PaginaAtu);
MontaPagina(PaginaAtu);
End;

Procedure TdlgTest.PrximaPgina1Click(Sender: TObject);
Begin
Inc(PaginaAtu);
MontaPagina(PaginaAtu);
End;

Procedure TdlgTest.FormCreate(Sender: TObject);

Begin
ScrollBox1.Align := AlClient;
End;

Procedure TdlgTest.FormShow(Sender: TObject);
Begin
ILct := -1;
PaginaAtu := 1;
MontaPagina(PaginaAtu);
ScaleMenuClick(mScreenWidth);
End;

End.
