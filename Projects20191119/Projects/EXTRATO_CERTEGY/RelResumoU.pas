Unit RelResumoU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, dfclasses, dfcontrols, dfPdf, SuGeral;

Type
  TRelResumo = Class(TForm)
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
    DFEngine2: TDFEngine;
    Procedure FormShow(Sender: TObject);
    Procedure FileMenuClick(Sender: TObject);
    Procedure ScaleMenuClick(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    procedure PginaAnterior1Click(Sender: TObject);
    procedure PrximaPgina1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
  Public
    Procedure MontaPagina(Pagina : Integer; Totais : Boolean);
    Function LevantarNumeroDeExtratos(Var DfEngine : TDFEngine) : Integer;
    Procedure InicializaTotais;
    Procedure PesquisaNome;
  End;

Var
  RelResumo: TRelResumo;
  LastScale: TObject;
  RegUnsrExtrAux : TgUnsrExtr;
  Paginacao: integer;

Implementation

{$R *.DFM}

Uses
  MasterU;

Var
  PaginaAtu : Integer;
  AuxStr//, AuxCep
   : AnsiString;

  vaTotPagto,
  vaTotCmpSq,
  vaTotTxAnu,
  vaTotAjustes,
  vaTotEnc : Extended;
  Pdf : TDF6toPDFConverter; // 20/03/2018

Procedure TRelResumo.PesquisaNome;
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

Procedure TRelResumo.InicializaTotais;
begin
  vaTotPagto := 0;
  vaTotCmpSq := 0;
  vaTotTxAnu := 0;
  vaTotAjustes := 0;
  vaTotEnc := 0;
end;

Function TRelResumo.LevantarNumeroDeExtratos(Var DfEngine : TDFEngine) : Integer;
Begin
Result := 1;
Repeat
  Try
    DFEngine.FieldByName('Fieldsan'+IntToStr(Result)).AsString := '';
  Except
    Dec(Result);
    Break;
  End; // Try
  Inc(Result);
Until False;

End;

Procedure TRelResumo.MontaPagina(Pagina : Integer; Totais : Boolean);
Var
  J : Integer;

Begin
If CntMnt = 1 Then
  Begin
  Inc(Paginacao);
  DFEngine1.ClearFields;
  DFEngine1.BeginUpdate;
  End;

DFActiveDisplay1.FormEngine := DFEngine1;   // Precisa atualizar por causa da atribuição anterior...
DFActiveDisplay1.Autosize := True;

For J := DadosDeCartao.Count-1 DownTo 0 Do
  Begin
  AuxStr := DadosDeCartao[J];
  Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(AuxStr));
  If RgRcb.RegUnsrCartAux.CartNormal.Titular = '0' Then
    Break;
  End;

DFEngine1.FieldByName('FieldNome').AsString := RgRcb.RegUnsrCont.ContNormal.NomeExt;  // .NomeCartao;

DFEngine1.FieldByName('FieldConta').AsString := Copy(RgRcb.RegUnsrCont.ContNormal.Conta,1,4)+'.'+
                                                Copy(RgRcb.RegUnsrCont.ContNormal.Conta,5,4)+'.'+
                                                Copy(RgRcb.RegUnsrCont.ContNormal.Conta,9,4)+'.'+
                                                Copy(RgRcb.RegUnsrCont.ContNormal.Conta,13,4);

//DFEngine1.FieldByName('FieldCartao').AsString := Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,1,4)+'.'+
//                                                 Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,5,4)+'.'+
//                                                 Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,9,4)+'.'+
//                                                 Copy(RgRcb.RegUnsrCart.CartNormal.Cartao,13,4);

If Totais Then
  begin
  DFEngine1.FieldByName('Field_Dt'+IntToStr(CntMnt)).AsString := 'Totais    ';
  DFEngine1.FieldByName('Field_dia'+IntToStr(CntMnt)).AsString := '  ';
  DFEngine1.FieldByName('FieldSan'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',0);
  DFEngine1.FieldByName('Field_Pgto'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',vaTotPagto);
  DFEngine1.FieldByName('Field_enc'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',0);
  DFEngine1.FieldByName('Field_Ep'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',vaTotEnc);
  DFEngine1.FieldByName('Field_ts'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',vaTotTxAnu);
  DFEngine1.FieldByName('Field_te'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',vaTotAjustes);
  DFEngine1.FieldByName('Field_CS'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',vaTotCmpSq);
  DFEngine1.FieldByName('FieldSat'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',0);
  DFEngine1.FieldByName('Field_sld_rema'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',0);
  end
Else
  begin
  DFEngine1.FieldByName('Field_Dt'+IntToStr(CntMnt)).AsString := Copy(RegUnsrExtrAux.DataVencto,7,2)+'/'+
                                                     Copy(RegUnsrExtrAux.DataVencto,5,2)+'/'+
                                                     Copy(RegUnsrExtrAux.DataVencto,1,4);

  Try
    EncodeDate(StrToInt(Copy(RegUnsrExtrAux.DataVencto,1,4)), StrToInt(Copy(RegUnsrExtrAux.DataVencto,5,2)), 28);
    DFEngine1.FieldByName('Field_dia'+IntToStr(CntMnt)).AsString := '28';
  Except
  End;
  Try
    EncodeDate(StrToInt(Copy(RegUnsrExtrAux.DataVencto,1,4)), StrToInt(Copy(RegUnsrExtrAux.DataVencto,5,2)), 29);
    DFEngine1.FieldByName('Field_dia'+IntToStr(CntMnt)).AsString := '29';
  Except
  End;
  Try
    EncodeDate(StrToInt(Copy(RegUnsrExtrAux.DataVencto,1,4)), StrToInt(Copy(RegUnsrExtrAux.DataVencto,5,2)), 30);
    DFEngine1.FieldByName('Field_dia'+IntToStr(CntMnt)).AsString := '30';
  Except
  End;
  Try
    EncodeDate(StrToInt(Copy(RegUnsrExtrAux.DataVencto,1,4)), StrToInt(Copy(RegUnsrExtrAux.DataVencto,5,2)), 31);
    DFEngine1.FieldByName('Field_dia'+IntToStr(CntMnt)).AsString := '31';
  Except
  End;

  FormatSettings.DecimalSeparator := '.';

  ValAux1 := StrToFloat(Trim(RegUnsrExtrAux.VlrLimAtu));

  If Empresarial And (RgRcb.RegUnsrCont.ContNormal.TipoConta = 'J') Then
    ValAux2 := 0
  Else
    ValAux2 := StrToFloat(Trim(RegUnsrExtrAux.VlrLimSaque));

  ValAux3 := StrToFloat(Trim(RegUnsrExtrAux.VlrSaldoExtrAnter));

  ValAux4 := StrToFloat(Trim(RegUnsrExtrAux.VlrAmortPagtos));

  If ValAux4 > 0 Then
    ValAux4 := ValAux4 * (-1);

//ValAux4_Prox := StrToFloat(Trim(RgRcb.RegUnsrExtr.VlrAmortPagtos));
//If ValAux4_Prox > 0 Then
//  ValAux4_Prox := ValAux4_Prox * (-1);

  ValAux5 := StrToFloat(Trim(RegUnsrExtrAux.VlrTaxaJuros));          // Juros (20091301)

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
                                            // ValAux4 é negativo, portanto para subtrair somamos...
  DFEngine1.FieldByName('FieldSan'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux3);
  DFEngine1.FieldByName('Field_Pgto'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux4);
  DFEngine1.FieldByName('Field_enc'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux5);
  DFEngine1.FieldByName('Field_Ep'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux6);
//  DFEngine1.FieldByName('Field_Ep'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux12+ValAux14
//                                                                                                  -ValAux3-ValAux4
//                                                                                                  -ValAux9-ValAux10-ValAux12
//                                                                                                  -ValAux7-ValAux8);
  DFEngine1.FieldByName('Field_ts'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux7);
  DFEngine1.FieldByName('Field_te'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux8);

  if RegUnsrExtrAux.DataVencto >= '20171107' then        // Romero acerto conductor
    begin
    DFEngine1.FieldByName('Field_CS'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux9+ValAux10);
    DFEngine1.FieldByName('FieldSat'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux14-ValAux4);
    DFEngine1.FieldByName('Field_sld_rema'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux14);
    vaTotCmpSq := vaTotCmpSq + ValAux9+ValAux10;
    end
  else
    begin
    DFEngine1.FieldByName('Field_CS'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',ValAux9+ValAux10+ValAux12);
    DFEngine1.FieldByName('FieldSat'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',{ValAux3+}ValAux12+ValAux14-ValAux4{-ValAux3});
                                                                                                                  //       +Pagto(--) -DebAnt
                        // ValAux4_Prox é negativo, portanto para subtrair somamos...
    DFEngine1.FieldByName('Field_sld_rema'+IntToStr(CntMnt)).AsString := FormatFloat('###,###,###,##0.00',{ValAux3+}ValAux12+ValAux14
                                                                                                        {+ValAux4});
    vaTotCmpSq := vaTotCmpSq + ValAux9+ValAux10+ValAux12;
    end;

  vaTotPagto := vaTotPagto + ValAux4;
//  vaTotCmpSq := vaTotCmpSq + ValAux9+ValAux10+ValAux12;
  vaTotTxAnu := vaTotTxAnu + ValAux7;
  vaTotAjustes := vaTotAjustes + ValAux8;
  vaTotEnc := vaTotEnc + ValAux6;

  end;

DFEngine1.FieldByName('FieldPagina').AsString := 'Página '+IntToStr(Paginacao)+'/'+IntToStr(TotalPags);

DFEngine1.EndUpdate;
End;

Procedure TRelResumo.FileMenuClick(Sender: TObject);
Var
  PagImp : Integer;
Begin
PagImp := 1;
MontaPagina(PagImp, False);
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
    MontaPagina(PagImp, False);
Until PagImp > TotalPags;
If PagImp <> PaginaAtu Then
  If PagImp <> 0 Then
    MontaPagina(PaginaAtu, False);

End;

Procedure TRelResumo.ScaleMenuClick(Sender: TObject);
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

Procedure TRelResumo.FormResize(Sender: TObject);
Begin
  ScaleMenuClick(LastScale);
End;

Procedure TRelResumo.PginaAnterior1Click(Sender: TObject);
Begin
Dec(PaginaAtu);
MontaPagina(PaginaAtu, False);
End;

Procedure TRelResumo.PrximaPgina1Click(Sender: TObject);
Begin
Inc(PaginaAtu);
MontaPagina(PaginaAtu, False);
End;

Procedure TRelResumo.FormCreate(Sender: TObject);

Begin
ScrollBox1.Align := AlClient;
End;

Procedure TRelResumo.FormShow(Sender: TObject);
Begin
ILct := -1;
PaginaAtu := 1;
MontaPagina(PaginaAtu, False);
ScaleMenuClick(mScreenWidth);
End;

End.
