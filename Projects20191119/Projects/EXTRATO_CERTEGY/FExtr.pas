Unit FExtr;

{

20030515 - Subtrair os encargos do total nacional para mostrar s� ototal de comprar nacional
           Fix - Lan�amentos de todos os ciclos eram mostrados na tela de lan�amentos...
20030520 - Se o banco de dados estivesse incompleto, s� com arquivos de EXTR, o loop de pesquisa
           de Detex n�o limpava o buffer, ficando com os lan�amentos do m�s anterior pesquisado com dados.
           Coloquei um Detex.Clear fora do loop de pesquisa de arquivos Detex na base.

}

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls;

Type
  TExtrForm = Class(TForm)
    Label1: TLabel;
    EditConta: TEdit;
    NovaConsultaButton: TButton;
    SairButton: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label17: TLabel;
    EditOrg: TEdit;
    EditLogo: TEdit;
    Edit8: TEdit;
    Edit7: TEdit;
    Edit6: TEdit;
    Edit5: TEdit;
    Edit4: TEdit;
    ScrollBar1: TScrollBar;
    Label8: TLabel;
    Label9: TLabel;
    Edit9: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    Label11: TLabel;
    Edit11: TEdit;
    Label12: TLabel;
    Edit12: TEdit;
    Label13: TLabel;
    Edit13: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Label28: TLabel;
    Edit27: TEdit;
    ExtratoButton: TButton;
    Label29: TLabel;
    EditNome: TEdit;
    Label20: TLabel;
    Edit19: TEdit;
    Label22: TLabel;
    Image1: TImage;
    LancamentosButton: TButton;
    Image2: TImage;
    Procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ExtratoButtonClick(Sender: TObject);
    procedure NovaConsultaButtonClick(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
    Procedure Carrega(Posic : Integer);
    Procedure LevantaDetexPortadores(J : Integer);
    Procedure MontaDetalheExtrato;
  End;

Var
  ExtrForm: TExtrForm;

Implementation

{$R *.DFM}
Uses SuGeral, Subrug, SelCont, EditTest, PortaCartU, Lancamentos;

Procedure TExtrForm.MontaDetalheExtrato;
Var
  K : Integer;
  RegUnsDetexAux : TgUnsDetex;
  AuxStr : AnsiString;
  Soma : Boolean;

  Procedure EscreveNome;
  Begin
  Extrato.Add('N          '+Nome+' '+Copy(CartaoAnt,1,4)+'.'+Copy(CartaoAnt,5,4)+'.'+Copy(CartaoAnt,9,4)+'.'+
              Copy(CartaoAnt,13,4));
  End;

  Function TestaFimDePagina(Incremento : Integer) : Boolean;
  Begin
  Result := False;
//  If Extrato.Count = ILct Then // Ta na primeira linha de uma p�gina, descarrega o nome de novo....
  If Extrato.Count >= ILct Then // Ta na primeira linha de uma p�gina, descarrega o nome de novo....
    Begin
    Result := True;
    EscreveNome;
    Inc(ILct,Incremento);
    Inc(TotalPags);
    End;
  End;

  Procedure Totaliza;
  Begin
  TestaFimdePagina(ILctEmpr2);
  If ((TotalReal <> 0) And (TotalUsd <> 0)) Then
    Begin
    Extrato.Add('           TOTAL DESP/ENCARGOS/REAL/DOLAR          '+
                Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',TotalReal)])+' '+
                Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,##0.00',TotalUsd)]));

    If Extrato.Count-1 <> ILct Then
      Extrato.Add('');
    End
  Else
  If ((TotalReal = 0) And (TotalUsd <> 0)) Then
    Begin
    Extrato.Add('           TOTAL DESP/ENCARGOS/REAL/DOLAR          '+
          Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,###.##',TotalReal)])+' '+
          Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,##0.00',TotalUsd)]));
    If Extrato.Count-1 <> ILct Then
      Extrato.Add('');
    End
  Else
  If ((TotalReal <> 0) And (TotalUsd = 0)) Then
    Begin
    Extrato.Add('           TOTAL DESP/ENCARGOS/REAL/DOLAR          '+
          Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',TotalReal)])+' '+
          Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,###.##',TotalUsd)]));
    If Extrato.Count-1 <> ILct Then
      Extrato.Add('');
    End
  Else
    Extrato.Add('');

  TotalReal := 0;
  TotalUsd := 0;
  End;

Begin
TotalPags := 1;
Nome := '';
CartaoAnt := '';
Extrato.Clear;
XVlrOri := 17;
XVlrUsdR := 18;
If TVlrOri > 17 Then     // Valores para a formata��o dos campos
  XVlrOri := TVlrOri;
If TVlrUsdR > 18 Then
  XVlrUsdR := TVlrUsdR;

If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL4') Then
  Begin
  Empresarial := True;
  ILct := ILctEmpr1;
  TotalReal := 0;
  TotalUsd := 0;
  TotalRealGeral := 0;
  TotalUsdGeral := 0;
  Extrato.Add('Data       Demonstrativo das Transa��es                         Em R$            Em US$        Na Moeda Origem');
  Extrato.Add('');

  For K := 0 To Detex.Count-1 Do
    Begin
    AuxStr := Detex[K];
    Move(AuxStr[1],RegUnsDetexAux,SizeOf(RegUnsDetexAux));

    If RegUnsDetexAux.Cartao <> CartaoAnt Then
      Begin
      If CartaoAnt <> '' Then // Tem que totalizar
        Totaliza;

      CartaoAnt := RegUnsDetexAux.Cartao;
      DlgTest.PesquisaNome;

//      If Extrato.Count+1 = ILct Then // Ultima linha, pula para o in�cio da pr�xima p�gina......
//      If Extrato.Count-2 >= ILct Then // Pen�ltima linha, pula para o in�ciar da pr�xima p�gina......
//        Extrato.Add('');
//      If Extrato.Count-1 >= ILct Then // Ultima linha, pula para o in�cio da pr�xima p�gina......
//        Extrato.Add('');

      If Extrato.Count >= ILct-2 Then // Pen�ltima linha, pula para o in�ciar da pr�xima p�gina......
        Extrato.Add('');
      If Extrato.Count >= ILct-1 Then // Ultima linha, pula para o in�cio da pr�xima p�gina......
        Extrato.Add('');

      If Not TestaFimDePagina(ILctEmpr2) Then
        EscreveNome;
      End;

    FormatSettings.DecimalSeparator := '.';
    ValAux1 := StrToFloat(Trim(RegUnsDetexAux.MoedaOrig));
    ValAux2 := StrToFloat(Trim(RegUnsDetexAux.Valor));

    Sinal := ' ';
    If Pos('-',RegUnsDetexAux.Valor) = 0 Then
      Begin
      Soma := True;
      If (Pos('PAGTO',RegUnsDetexAux.Historico) <> 0) Then
        Begin
        Sinal := '-';
        Soma := False;
        End;
      If (Pos('PAGAMENTO',RegUnsDetexAux.Historico) <> 0) Then
        Begin
        Sinal := '-';
        Soma := False;
        End;
      If (Pos('-CR',RegUnsDetexAux.Historico) <> 0) Then
        Begin
        Sinal := '-';
        Soma := False;
        End;
      If (Pos('ESTORNO COMPRA',RegUnsDetexAux.Historico) <> 0) Then
        Begin
        Sinal := '-';
        Soma := False;
        End;
      If (Pos('AJUSTE A CREDITO',RegUnsDetexAux.Historico) <> 0) Then
        Sinal := '-';
      End
    Else
      Soma := False;

    FormatSettings.DecimalSeparator := ',';
    TestaFimDePagina(ILctEmpr2);

    If Copy(RegUnsDetexAux.DataTrans,7,2) = '99' Then
      DataTransAux := '          '
    Else
      DataTransAux := Copy(RegUnsDetexAux.DataTrans,7,2)+'/'+Copy(RegUnsDetexAux.DataTrans,5,2)+'/'+
                      Copy(RegUnsDetexAux.DataTrans,1,4);

    If (RegUnsDetexAux.Moeda <> '   ') Then
      Begin
      Extrato.Add(DataTransAux+' '+Format('%-39s',[Trim(RegUnsDetexAux.Historico)])+'                   '+
                  Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',ValAux2)])+'  '+
                  Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,##0.00',ValAux1)])+' '+
                  RegUnsDetexAux.Moeda);
      If Soma Then
        If Sinal = ' ' Then
          Begin
          TotalUsdGeral := TotalUsdGeral + ValAux2;
          TotalUsd := TotalUsd + ValAux2;
          End
        Else
          Begin
          TotalUsdGeral := TotalUsdGeral - ValAux2;
          TotalUsd := TotalUsd - ValAux2;
          End;
      End
    Else
      Begin
      If Soma Then
        If Sinal = ' ' Then
          Begin
          TotalRealGeral := TotalRealGeral + ValAux2;
          TotalReal := TotalReal + ValAux2;
          End
        Else
          Begin
          TotalRealGeral := TotalRealGeral - ValAux2;
          TotalReal := TotalReal - ValAux2;
          End;
      If ValAux1 <> 0 Then
        Extrato.Add(DataTransAux+' '+Format('%-39s',[Trim(RegUnsDetexAux.Historico)])+' '+
                    Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',ValAux2)])+' '+
                    Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,##0.00',ValAux1)]))
      Else
        Extrato.Add(DataTransAux+' '+Format('%-39s',[Trim(RegUnsDetexAux.Historico)])+' '+
                    Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',ValAux2)])+Sinal)
      End;
    End;   // For

  If ((TotalRealGeral <> 0) Or (TotalUsdGeral <> 0)) Then
    Begin
    Totaliza;

    If (TotalRealGeral <> 0) Or (TotalUsdGeral <> 0) Then
      If Extrato.Count >= ILct Then // Ta na primeira linha de uma p�gina, descarrega outra p�gina
        Begin
        Inc(ILct,ILctEmpr2);
        Inc(TotalPags);
        End;

    If (TotalRealGeral <> 0) And (TotalUsdGeral <> 0) Then
      Extrato.Add('           TOTAL GERAL DESP/ENCARGOS/REAL/DOLAR    '+
                  Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',TotalRealGeral)])+' '+
                  Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,##0.00',TotalUsdGeral)]))
    Else
    If (TotalRealGeral = 0) And (TotalUsdGeral <> 0) Then
      Extrato.Add('           TOTAL GERAL DESP/ENCARGOS/REAL/DOLAR    '+
                  Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,###.##',TotalRealGeral)])+' '+
                  Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,##0.00',TotalUsdGeral)]))
    Else
    If (TotalRealGeral <> 0) And (TotalUsdGeral = 0) Then
      Extrato.Add('           TOTAL GERAL DESP/ENCARGOS/REAL/DOLAR    '+
                  Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',TotalRealGeral)])+' '+
                  Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,###.##',TotalUsdGeral)]));
    End;

  ILct := ILctEmpr1;
  End
Else
  Begin

  // Tratamento do n�o empresarial...................

  Empresarial := False;
  ILct := ILctFis1;
  Extrato.Add('DATA       HIST�RICO                                     MOEDA DE ORIGEM          EM R$/US$');
  Extrato.Add('');

  For K := 0 To Detex.Count-1 Do
    Begin
    AuxStr := Detex[K];
    If Length(Detex[K]) >= (SizeOf(RegUnsDetexAux)-2) Then
      Begin
      Move(AuxStr[1],RegUnsDetexAux,SizeOf(RegUnsDetexAux)-2);
      If RegUnsDetexAux.Ciclo <> RgRcb.RegUnsrExtr.Ciclo Then // Pula os registros do outro ciclo...Trim(Edit5.Text)
        Continue;
      End
    Else
      Continue;

    FormatSettings.DecimalSeparator := '.';
    ValAux1 := StrToFloat(Trim(RegUnsDetexAux.MoedaOrig));
    ValAux2 := StrToFloat(Trim(RegUnsDetexAux.Valor));
    FormatSettings.DecimalSeparator := ',';
    TestaFimDePagina(ILctFis2);

    If RegUnsDetexAux.Cartao <> CartaoAnt Then
      Begin
      CartaoAnt := RegUnsDetexAux.Cartao;
      DlgTest.PesquisaNome;

//      If Extrato.Count-1 = ILct Then // Ultima linha, pula para o in�cio da pr�xima p�gina......
//      If Extrato.Count-1 >= ILct Then // Ultima linha, pula para o in�cio da pr�xima p�gina......

      If Extrato.Count >= ILct-1 Then // Ultima linha, pula para o in�cio da pr�xima p�gina......
        Extrato.Add('');

      If Not TestaFimDePagina(ILctFis2) Then
        EscreveNome;
      End;

    If Copy(RegUnsDetexAux.DataTrans,7,2) = '99' Then
      DataTransAux := '          '
    Else
      DataTransAux := Copy(RegUnsDetexAux.DataTrans,7,2)+'/'+Copy(RegUnsDetexAux.DataTrans,5,2)+'/'+
                      Copy(RegUnsDetexAux.DataTrans,1,4);

    If ValAux1 = 0 Then
    Extrato.Add(DataTransAux+' '+Format('%-39s',[Trim(RegUnsDetexAux.Historico)])+' '+
                '    '+Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,###.##',ValAux1)])+' '+
                Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',ValAux2)]))
    Else
    Extrato.Add(DataTransAux+' '+Format('%-39s',[Trim(RegUnsDetexAux.Historico)])+' '+
                RegUnsDetexAux.Moeda+' '+Format('%'+IntToStr(XVlrOri)+'s',[FormatFloat('###,###,###,##0.00',ValAux1)])+' '+
                Format('%'+IntToStr(XVlrUsdR)+'s',[FormatFloat('###,###,###,##0.00',ValAux2)]));

    End;
  ILct := ILctFis1;
  End;

End;

Procedure TExtrForm.Carrega(Posic : Integer);
Var
  AuxStr : AnsiString;
Begin
AuxStr := DadosDeExtrato[Posic];
Move(AuxStr[1],RgRcb.RegUnsrExtr,SizeOf(RgRcb.RegUnsrExtr));

EditLogo.Text := RgRcb.RegUnsrExtr.Logo;   // Romero lance do logo em 23/02/2010

With RgRcb.RegUnsrExtr Do
  Begin
  FormatSettings.DecimalSeparator := '.';
  ValAux1 := StrToFloat(Trim(VlrLimAtu));
  ValAux2 := StrToFloat(Trim(VlrLimSaque));
  ValAux3 := StrToFloat(Trim(VlrSaldoExtrAnter));
  ValAux4 := StrToFloat(Trim(VlrAmortPagtos));
  If (CodOrgSelecionada = '275') Or (CodOrgSelecionada = '356') Then
    Begin
    End
  Else
    ValAux4 := ValAux4 * (-1);  
  ValAux6 := StrToFloat(Trim(VlrEncargos));
  ValAux7 := StrToFloat(Trim(VlrTaxasAnuid));
  ValAux8 := StrToFloat(Trim(VlrAjustes1));
  ValAux9 := StrToFloat(Trim(VlrCompras));
  ValAux10 := StrToFloat(Trim(VlrParcFixas));
  ValAux11 := StrToFloat(Trim(VlrSaldoAtu));        // TotalUsd
  ValAux12 := StrToFloat(Trim(VlrSaldoAtuConvert)); // TotalInternacional
  ValAux13 := StrToFloat(Trim(VlrCota));
  ValAux14 := StrToFloat(Trim(VlrSaldoAtual));
  ValAux15 := StrToFloat(Trim(VlrPagtoMinTotal));
//  ValAux18 := StrToFloat(Trim(VlrSaldoConvertR)); // SaldoUsd[IAnoMesExtrato]
//  If Empresarial And (RegUnsrCont.TipoConta = 'J') Then
//    ValAux20 := StrToFloat(Trim(VlrSaldoAtu))
//  Else
  ValAux20 := StrToFloat(Trim(VlrSaldoAtual));
  ValAux21 := StrToFloat(Trim(VlrPremioSeguro));

  ValAux5 := StrToFloat(Trim(VlrTaxaJuros));          // Juros
  ValAux16 := StrToFloat(Trim(VlrTaxaJurosAtraso));
  ValAux17 := StrToFloat(Trim(VlrTaxaJurosProxPer));
  ValAux19 := StrToFloat(Trim(VlrTaxaJurosProxPerAtraso));

  FormatSettings.DecimalSeparator := ',';
  FormatSettings.ThousandSeparator := '.';

//  If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL4') Then
//    Empresarial := True
//  Else
//    Empresarial := False;

  Edit4.Text := Format('%18s',[Copy(AnoMes,5,2)+'/'+Copy(AnoMes,1,4)]);
  Edit5.Text := Format('%18s',[String(Ciclo)]);
  Edit6.Text := Format('%18.2n',[ValAux1]);   // Limite atual
  Edit7.Text := Format('%18.2n',[ValAux2]);   // Limite de saque
  Edit8.Text := Format('%18s',[Copy(DataVencto,7,2)+'/'+Copy(DataVencto,5,2)+'/'+Copy(DataVencto,1,4)]); // Data de vencimento
//  Edit9.Text := Format('%18.2n',[ValAux3+ValAux18]);  // Total da fatura anterior;
  Edit9.Text := Format('%18.2n',[ValAux3]);  // Total da fatura anterior;
  Edit13.Text := Format('%18.2n',[ValAux4]);  // Pagamentos
//  Edit12.Text := Format('%18.2n',[(ValAux3+ValAux18)-ValAux4]); // Saldo da fatura anterior atualizado
  Edit12.Text := Format('%18.2n',[ValAux3-ValAux4]); // Saldo da fatura anterior atualizado
  Edit14.Text := Format('%18.2n',[ValAux6]); // Encargos
  Edit15.Text := Format('%18.2n',[ValAux7+ValAux21]); // Taxas e anuidades
  Edit16.Text := Format('%18.2n',[ValAux8]); // Ajustes

  if DataVencto >= '20171107' then        // Romero acerto conductor
    Edit17.Text := Format('%18.2n',[ValAux9])
  else
    Edit17.Text := Format('%18.2n',[ValAux9+ValAux12]); // Compras e saques do m�s

  Edit18.Text := Format('%18.2n',[ValAux10]); // Parcelas fixas

  if DataVencto >= '20171107' then        // Romero acerto conductor
    Edit10.Text := Format('%18.2n',[ValAux14])
  else
    Edit10.Text := Format('%18.2n',[ValAux12+ValAux14]); // Total desta fatura

  Edit23.Text := Format('%18.2n',[ValAux15]); // Pagamento m�nimo
  Edit22.Text := ' '+Copy(DataCota,7,2)+'/'+Copy(DataCota,5,2)+'/'+Copy(DataCota,1,4); // Data da cota��o
  Edit21.Text := Format('%18.4n',[ValAux13]);         // Cota��o do d�lar
  Edit20.Text := Format('%18.2n',[ValAux11]);  // Total USD
  Edit11.Text := Format('%18.2n',[ValAux12]);  // Total USD convertido em Real
//  Edit19.Text := Format('%18.2n',[ValAux20]);  // Total Nacional
  Edit19.Text := Format('%18.2n',[ValAux20-ValAux6-ValAux7]);  // Total Nacional - Encargos Maciel 20030515
                                                               // - Taxas e anuidades 20030517
  Edit24.Text := Format('%18.2n',[ValAux5])+'%';
  Edit25.Text := Format('%18.2n',[ValAux16])+'%';
  Edit26.Text := Format('%18.2n',[ValAux17])+'%';
  Edit27.Text := Format('%18.2n',[ValAux19])+'%';

//  If Empresarial And (RegUnsrCont.TipoConta = 'J') Then
//    Begin
//    Edit10.Text := Format('%18.2n',[ValAux14]);
//    Try
//      Edit20.Text := Format('%18.2n',[ValAux12 / ValAux13]);
//    Except
//      Edit20.Text := '              0.00';
//      End; // Except
//    End;

  End;
Application.ProcessMessages;
End;

Procedure TExtrForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; Var ScrollPos: Integer);
Begin
If ScrollCode <> scEndScroll Then
  Exit;
Label8.Caption := IntToStr(ScrollPos)+' de '+IntToStr(DadosDeExtrato.Count);
Carrega(ScrollPos-1);
End;

Procedure TExtrForm.LevantaDetexPortadores(J : Integer);
Var
  I,
  K,
  L,
  IConta : Integer;
  NumContaAux : Int64;
  AuxStr,
  AuxConta : AnsiString;
  ArrConta : Array[1..10000] Of Int64;
Begin
AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTAEMPRESA.IND');

DadosDeContaDePortadores.Clear;
Reset(ArqIndiceContaCartao);
TestarFlag := False;
DadosDeContaDePortadores.Text := Selecons.PesquisaCarregaContaCartao(NumConta, NArqCont);
CloseFile(ArqIndiceContaCartao);

If DadosDeContaDePortadores.Count = 0 Then
  Begin
  Screen.Cursor := crDefault;
  ShowMessage('Dados de contas de portadores n�o encontrados, verifique...');
  Exit;
  End;
AuxStr := DadosDeContaDePortadores[0];
Move(AuxStr[1],RgRcb.RegUnsrContAux,Length(DadosDeContaDePortadores[0]));
AuxConta := Trim(RgRcb.RegUnsrContAux.ContNormal.Conta);

AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND');

DadosDeCartaoDePortadores.Clear;
Reset(ArqIndiceContaCartao);
IConta := 1;
Repeat
  NumContaAux := StrToInt64(AuxConta);
  TestarFlag := False;
  DadosDeCartaoDePortadores.Text := DadosDeCartaoDePortadores.Text + Selecons.PesquisaCarregaContaCartao(NumContaAux, NArqCart);
  Inc(IConta);
//  If IConta >= DadosDeContaDePortadores.Count Then
  If IConta > DadosDeContaDePortadores.Count Then
    Break;
  AuxStr := DadosDeContaDePortadores[IConta-1];
  Move(AuxStr[1],RgRcb.RegUnsrContAux,Length(DadosDeContaDePortadores[IConta-1]));
  AuxConta := Trim(RgRcb.RegUnsrContAux.ContNormal.Conta);
Until False;
CloseFile(ArqIndiceContaCartao);

If DadosDeCartaoDePortadores.Count = 0 Then
  Begin
  Screen.Cursor := crDefault;
  ShowMessage('Dados de cart�o de portadores n�o encontrados, verifique...');
  Exit;
  End;

AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqDetex[J])+SeArquivoSemExt(NArqDetex[J])+'CONTA.IND');
Reset(ArqIndiceContaCartao);
//Detex.Clear;
//Detex.Sorted := False;
I := 0;
K := 0;
For IConta := 0 To DadosDeCartaoDePortadores.Count-1 Do
  Begin
  Inc(I);
  PortaForm.StringGrid1.RowCount := I+1;
  AuxStr := DadosDeCartaoDePortadores[IConta];
  Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(DadosDeCartaoDePortadores[IConta]));
  NumContaAux := StrToInt64(Trim(RgRcb.RegUnsrCartAux.CartNormal.Conta));
  Inc(K);
  ArrConta[K] := NumContaAux;
  For L := 1 To K-1 Do
    If NumContaAux = ArrConta[L] Then
      Begin
      AuxStr := 'NNN';
      Break;
      End;
  If AuxStr = 'NNN' Then
    Continue;
  TestarFlag := False;
  AuxStr := Selecons.PesquisaCarregaContaCartao(NumContaAux, NArqDetex[J]);
  If AuxStr <> '' Then
    Detex.Text := Detex.Text + AuxStr;
  PortaForm.StringGrid1.Cells[0,I] := RgRcb.RegUnsrCartAux.CartNormal.Conta;
  PortaForm.StringGrid1.Cells[1,I] := RgRcb.RegUnsrCartAux.CartNormal.Cartao;
  PortaForm.StringGrid1.Cells[2,I] := RgRcb.RegUnsrCartAux.CartNormal.NomeCartao;
  PortaForm.StringGrid1.Cells[3,I] := RgRcb.RegUnsrCartAux.CartNormal.Status;
  End;
CloseFile(ArqIndiceContaCartao);
End;

Procedure TExtrForm.ExtratoButtonClick(Sender: TObject);
Var
  J, Kx, Kz : Integer;
  RegUnsDetexAux : TgUnsDetex;
  AuxStr : AnsiString;
  SGCS : Array of Integer;

Begin
{AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTA.IND');
DadosDeConta.Clear;
Reset(ArqIndiceContaCartao);
NumConta := StrToInt64(Trim(Selecons.StringGrid1.Cells[0,Selecons.StringGrid1.Row]));
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
NumConta := StrToInt64(Trim(Selecons.StringGrid1.Cells[0,Selecons.StringGrid1.Row]));
TestarFlag := False;
DadosDeCartao.Text := Selecons.PesquisaCarregaContaCartao(NumConta, NArqCart);
CloseFile(ArqIndiceContaCartao);

If DadosDeCartao.Count = 0 Then
  Begin
  ShowMessage('Dados de Cart�o n�o encontrados, verifique...');
  Exit;
  End;  ESTES DADOS DEVER�O ESTAR PREVIAMENTE LIDOS}

Detex.Clear;
Detex.Sorted := False;
IAnoMesExtrato := ScrollBar1.Position-1;
For J := 0 To NArqDetex.Count - 1 Do
  If Pos(Copy(Trim(Edit4.Text),4,4)+Copy(Trim(Edit4.Text),1,2),NArqDetex[J]) <> 0 Then
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
      LevantaDetexPortadores(J);

    End;

//If Detex.Count <> 0 Then
//  Begin
Detex.Sorted := True; // Ordena para a impress�o......

If Sender = ExtratoButton Then
  Begin
  MontaDetalheExtrato;
  DlgTest.ShowModal;    // vai montar extrato mesmo sem detex, pois pode n�o haver movimento, s� extr....
  End
Else
  Begin
  LancamentosForm.StringGrid1.RowCount := 2;
  SetLength(SGCS,14);
  For J := 0 To LancamentosForm.StringGrid1.ColCount-1 Do
    SGCS[J] := LancamentosForm.StringGrid1.ColWidths[J];
  LancamentosForm.StringGrid1.ColCount := 1;
  LancamentosForm.StringGrid1.ColCount := 14;
  For J := 0 To LancamentosForm.StringGrid1.ColCount-1 Do
    LancamentosForm.StringGrid1.ColWidths[J] := SGCS[J];

  Kz := 0;
  For Kx := 0 To Detex.Count-1 Do
    Begin
    AuxStr := Detex[Kx];
    Move(AuxStr[1],RegUnsDetexAux,SizeOf(RegUnsDetexAux));

    If RegUnsDetexAux.Ciclo = RgRcb.RegUnsrExtr.Ciclo Then // Pula os registros do outro ciclo...Trim(Edit5.Text)
      With LancamentosForm.StringGrid1 Do
        Begin
        Cells[0,Kz+1] := RegUnsDetexAux.Org;
        Cells[1,Kz+1] := RegUnsDetexAux.Logo;
        Cells[2,Kz+1] := RegUnsDetexAux.Conta;
        Cells[3,Kz+1] := RegUnsDetexAux.AnoMes;
        Cells[4,Kz+1] := RegUnsDetexAux.Ciclo;
        Cells[5,Kz+1] := RegUnsDetexAux.Cartao;
        Cells[6,Kz+1] := RegUnsDetexAux.DataTrans;
        Cells[7,Kz+1] := RegUnsDetexAux.Seq;
        Cells[8,Kz+1] := RegUnsDetexAux.Cartao2;
        Cells[9,Kz+1] := RegUnsDetexAux.Historico;
        Cells[10,Kz+1] := RegUnsDetexAux.Moeda;
        Cells[11,Kz+1] := RegUnsDetexAux.MoedaOrig;
        Cells[12,Kz+1] := RegUnsDetexAux.Valor;
        Cells[13,Kz+1] := RegUnsDetexAux.NumRef;
        Inc(Kz);
        End;
    End;
//  LancamentosForm.StringGrid1.RowCount := Detex.Count+1;
  LancamentosForm.StringGrid1.RowCount := Kz+1;
  LancamentosForm.Show;
  End;

//  End
//Else
//  ShowMessage('Dados de Extrato (Detex) n�o encontrados, verifique...');

End;

Procedure TExtrForm.NovaConsultaButtonClick(Sender: TObject);
Begin
Selecons.Show;
Close;
End;

Procedure TExtrForm.SairButtonClick(Sender: TObject);
Begin
Selecons.Close;
Close;
End;

End.