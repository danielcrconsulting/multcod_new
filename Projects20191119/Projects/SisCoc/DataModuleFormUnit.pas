unit DataModuleFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls;

type

  DePara = record
           Conta_contabil: String;
           Codigo: String;
           mInterface: Boolean;
           end;

  TDePara = array of DePara;

  PF_PJ = record
          BIN : Integer;
          end;

  TPF_PJ = array of PF_PJ;

  Saci = record
         Codigo: String;
         TemPerna: Boolean;
         end;

  TSaci = array of Saci;


  TDataModule = class(TForm)
    gBanco: TADOConnection;
    RsDbDs: TADODataSet;
    RsDbTb: TADOTable;
    RsDbQry: TADOQuery;
    gBancoCli: TADOConnection;
    RsDbDsCli: TADODataSet;
    RsDbTbCli: TADOTable;
    RsDbQryCli: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }

    mInterface: TDePara;
    TipoPessoa: TPF_PJ;
    creditoSACI,
    debitoSACI: TSaci;

    Function ContaDebitoComp(Indice: Integer; Moeda, NomeArquivo: String): Boolean;
    Function ContaCreditoComp(Indice: Integer; Moeda, NomeArquivo: String): Boolean;
    Procedure AtualizaTotal;
    Procedure SimulaNovaCon;

    Procedure ConectaAdm;
    Procedure DesconectaAdm;

    function Get_Codigo_Para(Conta: String): String;
    Procedure Monta_Interface;
    Procedure Monta_PFPJ;
    Procedure Monta_SACI;
    function GerarInterface(Cod: String): Boolean;
    function pegaSaci(Cod: String; DecCred: String): Boolean;
    Function Gera_Interface: Boolean;

  end;

var
  DataModule: TDataModule;

implementation

{$R *.dfm}

Uses
  Module1, frmLog_, PBar_, RotGerais, IdGlobalProtocols, VBto_Converter,
  DataMov_;

function TDataModule.ContaDebitoComp(Indice: Integer; Moeda, NomeArquivo: String): Boolean;
label
  Saida;
var
  ArqEntrada: System.Text;
  Buffer, sCartao, sValor, sMoeda,
  sSql: String;
  iPosicao, Posicao: Integer;
  iFileLen, lTotDebito, lTotCredito, Variacao: Extended;
  I: Integer;
  Pula: Boolean;
  DataLocal,
  xData: TDateTime;
begin
  iPosicao := 0;

  // Abre o arquivo de entrada
//  if Dir(NomeArquivo)<>'' then begin
  if FileExists(NomeArquivo) then
    begin
    AssignFile(ArqEntrada, NomeArquivo);
    Reset(ArqEntrada);
    end
  else
    begin
    Result := false;
    ShowMessage('Arquivo: '+NomeArquivo+' não encontrado');
    Exit;
    end;

  // I = PegaPar(gArquivo)
  I := PegaPar;

  ReadLn(ArqEntrada, Buffer);
  if (Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho) <> DateToStr(gDataRelatorio)) then
    begin
    if gAutomatico then
      frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Data do Movimento Inválida...'+#10
    else
      Application.MessageBox('Data do Movimento Inválida...', 'Atualização de Arquivo', MB_ICONSTOP);

    Result := false;
    CloseFile(ArqEntrada);
    Exit;
    end;

  Result := true;

  CloseFile(ArqEntrada);
  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);

//  if not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

//  sSql := 'select * from lancamentos where conta_contabil='#39'';
  sSql := 'conta_contabil='#39'';
  sSql := sSql+Trim(Concil.ContaContabil)+''#39'';
  //RsDb := gBanco.OpenRecordset(sSql);


  // Pega totais antes de processar
  lTotDebito := GetTotDebito(gBanco);
  lTotCredito := GetTotCredito(gBanco);

//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbTb.TableName := 'lancamentos';
  RsDbTb.Filtered := True;
  RsDbTb.Filter := sSql;
  RsDbTb.Open;

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Atualizando Banco...';
  iFileLen := FileSizeByName(NomeArquivo);

  while not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    iPosicao := iPosicao+Length(Buffer)+2;
    if iPosicao/iFileLen<=1 then
      PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
    else
      PBar.ProgressBar1.Position := 100;

    Application.ProcessMessages;

    if ContaValida(Buffer, Indice, 'D', true, Moeda) then
      begin
      iCountReg := iCountReg+1;
      gNroReg := gNroReg+1;
      sCartao := Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho);
      sValor := Trim(Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
      sMoeda := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);
      // Gerar registro

//      sSql := '';
//      sSql := 'Select * from [Lancamentos]';
//      sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
      sSql := 'conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
      sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
      Pula := false;
      // Verifica se o lançamento já foi contabilizado

      if (sMoeda='986') or (sMoeda='000') then
        begin
        sSql := sSql+' and Vl_CreditoReal = '+FormataValor2(sValor);
        sSql := sSql+' and (str(Data_Debito) = '#39''+DateToStr(gDataRelatorio)+''#39'';
        sSql := sSql+' or str(Data_Debito) = '#39''+FormatVB(gDataRelatorio,'DD/MM/YYYY')+''#39')';
        // sSql = sSql & " and Data_Debito = " & Format$(gDataRelatorio, "DD/MM/YYYY")
        //RsDb := gBanco.OpenRecordset(sSql);
        RsDbTb.Close;
        RsDbTb.Filter := sSql;
        RsDbTb.Open;

        if not RsDbTb.EOF then
          Pula := true;
        end
      else
        if sMoeda='840' then
          begin
          sSql := sSql+' and Vl_CreditoDolar = '+FormataValor2(sValor);
          sSql := sSql+' and (str(Data_Debito) = '#39''+DateToStr(gDataRelatorio)+''#39'';
          sSql := sSql+' or str(Data_Debito) = '#39''+FormatVB(gDataRelatorio,'DD/MM/YYYY')+''#39')';
     //      RsDb := gBanco.OpenRecordset(sSql);
          RsDbTb.Close;
          RsDbTb.Filter := sSql;
          RsDbTb.Open;

          if not RsDbTb.EOF then
            Pula := true;
          end
        else
          Pula := true;

      if not Pula then
        begin
        if RsDbTb.EOF then
          begin
          // Antes de criar novo registro, verificar se não é uma variação
          // 1-Verificar se existe Deb ou Cred em US$
          // 2-Se houver, verificar se o valor esta dentro do limite cadatrado para conta
          // 3-Se tiver, matar lançamento
          if (sMoeda='986') or (sMoeda='000') then
            begin
//            sSql := '';
//            sSql := 'Select * from [Lancamentos]';
//            sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := 'conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
            sSql := sSql+' and Vl_DebitoReal = 0 ';
            sSql := sSql+' and Vl_CreditoReal > 0 ';
     //      RsDb := gBanco.OpenRecordset(sSql);
            RsDbTb.Close;
            RsDbTb.Filter := sSql;
            RsDbTb.Open;

            // Verifica variação
            if not RsDbTb.EOF then
              begin
              while not RsDbTb.EOF do
                begin
                Variacao := Abs(StrToFloat(sValor)-RsDbTb.FieldByName('Vl_CreditoReal').AsExtended);
                if Variacao/RsDbTb.FieldByName('Vl_CreditoReal').AsExtended <= (gLimiteVariacao/100) then
                  begin
                  RsDbTb.Edit;
                  break;
                  end;
                RsDbTb.Next;
                end;
              if RsDbTb.EOF then
                RsDbTb.Insert;
              end;
            end
          else
            if (sMoeda='840') then
              begin
//              sSql := '';
//              sSql := 'Select * from [Lancamentos]';
//              sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
              sSql := 'conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
              sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
              sSql := sSql+' and Vl_DebitoDolar = 0 ';
              sSql := sSql+' and Vl_CreditoDolar > 0 ';

//              RsDb := gBanco.OpenRecordset(sSql);
              RsDbTb.Close;
              RsDbTb.Filter := sSql;
              RsDbTb.Open;

            // Verifica variação
              if not RsDbTb.EOF then
                begin
                while not RsDbTb.EOF do
                  begin
                  Variacao := Abs(StrToFLoat(sValor)-RsDbTb.FieldByName('Vl_CreditoDolar').AsExtended);
                  if Variacao/RsDbTb.FieldByName('Vl_CreditoDolar').AsExtended <= (gLimiteVariacao/100) then
                    begin
                    RsDbTb.Edit;
                    break;
                    end;
                  RsDbTb.Next;
                  end;
                if RsDbTb.EOF then
                  RsDbTb.Insert;
                end
              else
                RsDbTb.Insert;
              end
            else
              RsDbTb.Insert;
            end
        else
          begin
          // se tiver + de um lançamento, matar o mais antigo (3/11/00)
          RsDbTb.Last;
          if RsDbTb.RecordCount > 1 then
            begin
            RsDbTb.First;
            Posicao := 0;
            DataLocal := Now;
            while not RsDbTb.EOF do
              begin
              if (TryStrToDateTime(RsDbTb.FieldByName('Data_Debito').AsString, xData)) then
                begin
                if xData < DataLocal then
                  begin
                  DataLocal := RsDbTb.FieldByName('Data_Debito').Value;
                  Posicao := RsDbTb.Recno; // .AbsolutePosition;
                end;
              end;
              if (TryStrToDateTime(RsDbTb.FieldByName('Data_Credito').AsString, xData)) then
                begin
                if xData < DataLocal then
                  begin
                  DataLocal := RsDbTb.FieldByName('Data_Credito').Value;
                  Posicao := RsDbTb.RecNo; //RsDb.AbsolutePosition;
                 end;
              end;
            RsDbTb.Next;
            end;
          RsDbtb.First;
          while not RsDbTb.EOF do
            begin
            if (TryStrToDateTime(RsDbTb.FieldByName('Data_Credito').AsString, xData)) then
              if xData = DataLocal then
                  break;
              if (TryStrToDateTime(RsDbTb.FieldByName('Data_Debito').AsString, xData)) then
                if xData = DataLocal then
                  break;
            RsDbTb.Next;
            end;
          end;
        RsDbTb.Edit;
        end;

        // 15/10/2002
      if RsDbTb.EOF then
        RsDbTb.Insert;

      RsDbTb.FieldByName('cliente').AsString := gCliente;
      RsDbTb.FieldByName('Data_Debito').AsDateTime := gDataRelatorio;
      RsDbTb.FieldByName('Cartao').AsString := TiraPontos(sCartao, '16');
      RsDbTb.FieldByName('Cartao1').AsString := TiraPontos(sCartao, '13');
      if (sMoeda='986') or (sMoeda='000') then
        RsDbTb.FieldByName('Vl_DebitoReal').AsString := sValor
      else
        begin
        RsDbTb.FieldByName('Vl_DebitoDolar').AsString := sValor;
        RsDbTb.FieldByName('Taxa_Debito').AsString := gTaxa;
        RsDbTb.FieldByName('Vl_DebitoReal').AsCurrency := StrToFloat(sValor) * StrToFloat(gTaxa);
        end;

      RsDbTb.FieldByName('Vl_Saldo').AsCurrency := RsDbtb.FieldByName('Vl_DebitoReal').AsCurrency -
                                                   RsDbTb.FieldByName('Vl_CreditoReal').AsCurrency;
      RsDbTb.FieldByName('conta_contabil').AsString := Trim(Concil.ContaContabil);

      RsDbTb.FieldByName('Cod_Deb').AsString := ctDebito[Indice].Conta; // & "-" & ctDebito(Indice).Ref
      RsDbTb.FieldByName('Rel_Deb').AsString := Copy(Buffer, Param.Relatorio.Posicao, Param.Relatorio.Tamanho);
      RsDbTb.FieldByName('Depto_Deb').AsString := Copy(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho);
      RsDbTb.FieldByName('Moeda_Deb').AsString := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);

      RsDbTb.UpdateRecord;

      end;
    end;

  end;

  // Calcula totais depois de processar
  gTotDebito := gTotDebito+GetTotDebito(gBanco)-lTotDebito;
  gTotCredito := gTotCredito+GetTotCredito(gBanco)-lTotCredito;
Saida:
  CloseFile(ArqEntrada);
//  Desconecta;
  gBanco.Close;
  RsDbTb.Close;
  // If Not gAutomatico Then
  PBar.Close;
  // End If
end;

function TDataModule.ContaCreditoComp(Indice: Integer; Moeda, NomeArquivo: String): Boolean;
label
  Saida;
var
  ArqEntrada: System.Text;
  Buffer, sCartao, sValor, sMoeda: String;
  iPosicao, Posicao: Integer;
  iFileLen, lTotDebito, lTotCredito, Variacao: Extended;
  I: Integer;
  Pula: Boolean;
  DataLocal,
  xData: TDateTime;
begin
  iPosicao := 0;

  // Abre o arquivo de entrada
  if FileExists(NomeArquivo) then
    begin
    AssignFile(ArqEntrada, NomeArquivo);
    Reset(ArqEntrada);
    end
  else
    begin
    Result := false;
    ShowMessage('Arquivo: '+NomeArquivo+' não encontrado');
    Exit;
    end;

  // I = PegaPar(Mid$(gArquivo, 1, 6))
  I := PegaPar;

  ReadLn(ArqEntrada, Buffer);
  if (Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho) <> DateToStr(gDataRelatorio)) then
    begin
    if gAutomatico then
      frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Data do Movimento Inválida...'+#10
    else
      Application.MessageBox('Data do Movimento Inválida...', 'Atualização de Arquivo', MB_ICONSTOP);
    Result := false;
    CloseFile(ArqEntrada);
    Exit;
    end;

  Result := true;

  CloseFile(ArqEntrada);
  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);

//  if not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

  // Pega totais antes de processar
  lTotDebito := GetTotDebito(gBanco);
  lTotCredito := GetTotCredito(gBanco);

//  sSql := 'select * from lancamentos where conta_contabil='#39'';
  sSql := 'conta_contabil='#39'';
  sSql := sSql+Trim(Concil.ContaContabil)+''#39'';
  //RsDb := gBanco.OpenRecordset(sSql);

  RsDbTb.TableName := 'lancamentos';
  RsDbTb.Filtered := True;
  RsDbTb.Filter := sSql;
  RsDbTb.Open;

  // If Not gAutomatico Then
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Atualizando Banco... ' + Concil.ContaContabil;
  iFileLen := FileSizeByName(NomeArquivo);
  // End If
  while not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    // If Not gAutomatico Then
    iPosicao := iPosicao+Length(Buffer)+2;
    if iPosicao/iFileLen<=1 then
      PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
    else
      PBar.ProgressBar1.Position := 100;

    // End If
    Application.ProcessMessages;

    if ContaValida(Buffer, Indice, 'C', true, Moeda) then
      begin
      iCountReg := iCountReg+1;
      gNroReg := gNroReg+1;
      sCartao := Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho);
      sValor := Trim(Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
      sMoeda := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);

      // Gerar registro
//      sSql := '';
//      sSql := 'Select * from [Lancamentos]';
//      sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
      sSql := 'conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
      sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
      Pula := false;
      // Verifica se o lançamento já foi contabilizado

      if (sMoeda='986') or (sMoeda='000') then
        begin
        sSql := sSql+' and Vl_DebitoReal = '+FormataValor2(sValor);
        sSql := sSql+' and (STR(Data_Credito) = '#39''+DateToStr(gDataRelatorio)+''#39'';
        sSql := sSql+' or STR(Data_Credito) = '#39''+FormatVB(gDataRelatorio,'dd/mm/yyyy')+''#39')';
//        RsDb := gBanco.OpenRecordset(sSql);
        RsDbTb.Close;
        RsDbTb.Filter := sSql;
        RsDbTb.Open;

        if not RsDbTb.EOF then
          Pula := true;
        end
      else
        if sMoeda='840' then
          begin
          sSql := sSql+' and Vl_DebitoReal = '+FormataValor2(sValor);
          sSql := sSql+' and (STR(Data_Credito) = '#39''+DateToStr(gDataRelatorio)+''#39'';
          sSql := sSql+' or STR(Data_Credito) = '#39''+FormatVB(gDataRelatorio,'dd/mm/yyyy')+''#39')';
        //RsDb := gBanco.OpenRecordset(sSql);
          RsDbTb.Close;
          RsDbTb.Filter := sSql;
          RsDbTb.Open;

          if not RsDbTb.EOF then
            Pula := true;
          end
        else
          Pula := true;

      if not Pula then
        begin
        if RsDbTb.EOF then
          begin
          // Antes de criar novo registro, verificar se não é uma variação
          // 1-Verificar se existe Deb ou Cred em US$
          // 2-Se houver, verificar se o valor esta dentro do limite cadatrado para conta
          // 3-Se tiver, matar lançamento
          if (sMoeda='986') or (sMoeda='000') then
            begin
//            sSql := '';
//            sSql := 'Select * from [Lancamentos]';
//            sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := 'conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
            sSql := sSql+' and Vl_CreditoReal = 0 ';
            sSql := sSql+' and Vl_DebitoReal > 0 ';
//            RsDb := gBanco.OpenRecordset(sSql);
            RsDbTb.Close;
            RsDbTb.Filter := sSql;
            RsDbTb.Open;

            // Verifica variação
            if not RsDbTb.EOF then
              begin
              while not RsDbTb.EOF do
                begin
//                Variacao := Abs(CDbl(sValor)-CDbl(RsDb.FieldByName('Vl_DebitoReal').Value));
//                if Variacao/CDbl(RsDb.FieldByName('Vl_DebitoReal').Value)<=CDbl(gLimiteVariacao/100) then
                Variacao := Abs(StrToFloat(sValor)-RsDbTb.FieldByName('Vl_DebitoReal').AsExtended);
                if Variacao/RsDbTb.FieldByName('Vl_DebitoReal').AsExtended <= (gLimiteVariacao/100) then
                  begin
                  RsDbTb.Edit;
                  break;
                  end;
                RsDbTb.Next;
                end;
              if RsDbTb.EOF then
                RsDbTb.Insert;
              end
            else
              RsDbTb.Insert;

          end
        else
          if (sMoeda='840') then
            begin
//            sSql := '';
//            sSql := 'Select * from [Lancamentos]';
//            sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := 'conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
            sSql := sSql+' and Vl_CreditoDolar = 0 ';
            sSql := sSql+' and Vl_DebitoDolar > 0 ';
//            RsDb := gBanco.OpenRecordset(sSql);
            RsDbTb.Close;
            RsDbTb.Filter := sSql;
            RsDbTb.Open;

            // Verifica variação
            if not RsDbTb.EOF then
              begin
              while not RsDbTb.EOF do
                begin
//                Variacao := Abs(CDbl(sValor)-CDbl(RsDb.FieldByName('Vl_DebitoDolar').Value));
//                if Variacao/CDbl(RsDb.FieldByName('Vl_DebitoDolar').Value)<=CDbl(gLimiteVariacao/100) then
                Variacao := Abs(StrToFLoat(sValor)-RsDbTb.FieldByName('Vl_DebitoDolar').AsExtended);
                if Variacao/RsDbTb.FieldByName('Vl_DebitoDolar').AsExtended <= (gLimiteVariacao/100) then
                  begin
                  RsDbTb.Edit;
                  break;
                  end;
                RsDbTb.Next;
                end;
              if RsDbTb.EOF then
                RsDbTb.Insert;
              end
            else
              RsDbTb.Insert;
            end
          else
            RsDbTb.Insert;
          end
        else
          begin
          // se tiver + de um lançamento, matar o mais antigo (3/11/00)
          RsDbTb.Last;
          if RsDbTb.RecordCount>1 then begin
            RsDbTb.First;
            Posicao := 0;
            DataLocal := Now;
            while not RsDbTb.EOF do
              begin
              if (TryStrToDateTime(RsDbTb.FieldByName('Data_Debito').AsString, xData)) then
                begin
                if xData < DataLocal then
                  begin
                  DataLocal := RsDbTb.FieldByName('Data_Debito').Value;
                  Posicao := RsDbTb.RecNo; // .AbsolutePosition;
                  end;
              end;
              if (TryStrToDateTime(RsDbTb.FieldByName('Data_Credito').AsString, xData)) then
                begin
                if xData < DataLocal then
                  begin
                  DataLocal := RsDbTb.FieldByName('Data_Credito').Value;
                  Posicao := RsDbTb.RecNo; //.AbsolutePosition;
                  end;
                end;
              RsDbTb.Next;
              end;
            RsDbTb.First;
            while not RsDbTb.EOF do
              begin
              if (TryStrToDateTime(RsDbTb.FieldByName('Data_Credito').AsString, xData)) then
                if xData = DataLocal then
                  break;
              if (TryStrToDateTime(RsDbTb.FieldByName('Data_Debito').AsString, xData)) then
                if xData = DataLocal then
                  break;
              RsDbTb.Next;
            end;
          end;
        RsDbTb.Edit;
        end;

{        VBtoADOFieldSet(RsDb, 'cliente', gCliente);
        VBtoADOFieldSet(RsDb, 'Data_Credito', gDataRelatorio);
        VBtoADOFieldSet(RsDb, 'Cartao', TiraPontos(sCartao, IntToStr(16)));
        VBtoADOFieldSet(RsDb, 'Cartao1', TiraPontos(sCartao, IntToStr(13)));

        if (sMoeda='986') or (sMoeda='000') then
          VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', FormataValor(sValor))
        else
          begin
          VBtoADOFieldSet(RsDb, 'Vl_CreditoDolar', FormataValor(sValor));
          VBtoADOFieldSet(RsDb, 'Taxa_Credito', CDbl(gTaxa));
          VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', FormataValor(FloatToStr(RoundTo(CDbl(sValor)*CDbl(gTaxa), -2))));
          end;

        if (RsDb.FieldByName('Vl_CreditoReal'))<0 then
          VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', -(RsDb.FieldByName('Vl_CreditoReal')));

        VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal')-RsDb.FieldByName('Vl_CreditoReal'));
        VBtoADOFieldSet(RsDb, 'conta_contabil', Trim(Concil.ContaContabil));

        VBtoADOFieldSet(RsDb, 'Cod_Cred', ctCredito[Indice].Conta); // & "-" & ctCredito(Indice).Ref
        VBtoADOFieldSet(RsDb, 'Rel_Cred', Copy(Buffer, Param.Relatorio.Posicao, Param.Relatorio.Tamanho));
        VBtoADOFieldSet(RsDb, 'Depto_Cred', Copy(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho));
        VBtoADOFieldSet(RsDb, 'Moeda_Cred', Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho));}

      RsDbTb.FieldByName('cliente').AsString := gCliente;
      RsDbTb.FieldByName('Data_Credito').AsDateTime := gDataRelatorio;
      RsDbTb.FieldByName('Cartao').AsString := TiraPontos(sCartao, '16');
      RsDbTb.FieldByName('Cartao1').AsString := TiraPontos(sCartao, '13');
      if (sMoeda='986') or (sMoeda='000') then
        RsDbTb.FieldByName('Vl_CreditoReal').AsString := sValor
      else
        begin
        RsDbTb.FieldByName('Vl_CreditoDolar').AsString := sValor;
        RsDbTb.FieldByName('Taxa_Credito').AsString := gTaxa;
        RsDbTb.FieldByName('Vl_CreditoReal').AsCurrency := StrToFloat(sValor) * StrToFloat(gTaxa);
        end;

      if RsDbTb.FieldByName('Vl_CreditoReal').AsCurrency < 0 then
        RsDbTb.FieldByName('Vl_CreditoReal').AsCurrency := RsDbTb.FieldByName('Vl_CreditoReal').AsCurrency * (-1);

      RsDbTb.FieldByName('Vl_Saldo').AsCurrency := RsDbtb.FieldByName('Vl_DebitoReal').AsCurrency -
                                                   RsDbTb.FieldByName('Vl_CreditoReal').AsCurrency;
      RsDbTb.FieldByName('conta_contabil').AsString := Trim(Concil.ContaContabil);

      RsDbTb.FieldByName('Cod_Cred').AsString := ctDebito[Indice].Conta; // & "-" & ctDebito(Indice).Ref
      RsDbTb.FieldByName('Rel_Cred').AsString := Copy(Buffer, Param.Relatorio.Posicao, Param.Relatorio.Tamanho);
      RsDbTb.FieldByName('Depto_Cred').AsString := Copy(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho);
      RsDbTb.FieldByName('Moeda_Cred').AsString := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);

      RsDbTb.UpdateRecord;
      end;
    end;

  end;
  // Pega totais antes de processar
  gTotDebito := gTotDebito+GetTotDebito(gBanco) - lTotDebito;
  gTotCredito := gTotCredito+GetTotCredito(gBanco) - lTotCredito;

Saida:
  CloseFile(ArqEntrada);
//  Desconecta;
  gBanco.Close;
  RsDbTb.Close;
  // If Not gAutomatico Then
  PBar.Close;
  // End If
end;

procedure TDataModule.SimulaNovaCon;
begin

  // fMainForm.mnuArquivo.Caption = gConciliacao

  //Desconecta;
  //if  not Conecta('adm') then Exit;
  if  not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

  sSql := 'Select * from [tb_tipo_con]';
  sSql := sSql+' where nm_conciliacao = '#39''+gConciliacao+''#39'';
  sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.Sql.Add(sSql);
  RsDbQry.Open;

  if not RsDbQry.EOF then
    begin
    gAtualizaGeral := true;
    if AnsiUpperCase(RsDbQry.FieldByName('AtualizaGeral').Value)='N' then
      gAtualizaGeral := false;

    gEliminaDuplicacao := true;
    if AnsiUpperCase(RsDbQry.FieldByName('EliminaDuplicacao').Value)='N' then
      gEliminaDuplicacao := false;

    gForcaReal := true;
    if AnsiUpperCase(RsDbQry.FieldByName('Real').Value)='0' then
      gForcaReal := false;

    gForcaDolar := true;
    if AnsiUpperCase(RsDbQry.FieldByName('Dolar').Value)='0' then
      gForcaDolar := false;

      // Concil.ArqEntrada = .Fields("Arq_Entrada")
    Concil.ContaContabil := Trim(RsDbQry.FieldByName('conta_contabil').Value);
    Concil.Natureza := RsDbQry.FieldByName('Natureza_conta').Value;
    Concil.nome := Trim(RsDbQry.FieldByName('nm_conciliacao').Value);
    end;

//  Desconecta;
//  if  not Conecta('ADM') then Exit;
  RsDbQry.Close;

  sSql := '';
  sSql := sSql+'Select * from [tbContasAdm] ';
  sSql := sSql+'Where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39' ';
  sSql := sSql+'And Natureza = '#39'D'#39' ';
  sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
  sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';
//RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.Sql.Add(sSql);
  RsDbQry.Open;

  ncDebito := 0;
  if not RsDbQry.EOF then
    begin
    RsDbQry.Last;
    ncDebito := RsDbQry.RecordCount;
    SetLength(ctDebito, ncDebito+1);
    RsDbQry.First;
    end;

  while not RsDbQry.EOF do
    begin
    ctDebito[RsDbQry.RecNo].Conta := RsDbQry.FieldByName('Codigo').Value;
    ctDebito[RsDbQry.RecNo].conta_para := limpaString(RsDbQry.FieldByName('Codigo_Para').AsString);
    RsDbQry.Next;
      // If Not .EOF Then ctDebito(.AbsolutePosition).nRef = 0
    end;

  sSql := '';
  sSql := sSql+'Select * from [tbContasAdm] ';
  sSql := sSql+'Where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39' ';
  sSql := sSql+'And Natureza = '#39'C'#39' ';
  sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
  sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.Close;
  RsDbQry.Sql.Add(sSql);
  RsDbQry.Open;

  ncCredito := 0;
  if not RsDbQry.EOF then
    begin
    RsDbQry.Last;
    ncCredito := RsDbQry.RecordCount;
    SetLength(ctCredito, ncCredito+1);
    RsDbQry.First;
    end;

  while not RsDbQry.EOF do
    begin
    ctCredito[RsDbQry.RecNo].Conta := RsDbQry.FieldByName('Codigo').Value;
    ctCredito[RsDbQry.RecNo].conta_para := limpaString(RsDbQry.FieldByName('Codigo_Para').AsString);
      // ctCredito(.AbsolutePosition).nRef = ctCredito(.AbsolutePosition).nRef + 1
    RsDbQry.Next;
      // If Not .EOF Then ctCredito(.AbsolutePosition).nRef = 0
    end;

//  Desconecta;
//  if  not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

//  sSql := 'Select * from [id]';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbTb.TableName := 'Id';

  if RsDbTb.EOF then
    RsDbTb.Insert
  else
    RsDbTb.Edit;

  VBtoADOFieldSet(RsDbTb, 'Codigo', Relatorio.CdCliente);
  VBtoADOFieldSet(RsDbTb, 'Nome_Cliente', Relatorio.IdRelatorio);
  RsDbTb.UpdateRecord;
//  Desconecta;

  RsDbTb.Close;
  gBanco.Close;

end;

procedure TDataModule.AtualizaTotal;
label
  NextReg, Saida;
var
  I: Integer;
  J: Integer;
  sPath, Buffer, Buffer1, buffer2, NomeTmp,
  NomeArquivo: String;
  RsLocal: TADODataSet;
  Banco: TAdoConnection;
//  Work: Workspace;
begin

  // gDataRelatorio = ""
  gAutomatico := true;
  DataMov.ShowModal;
  if  not isDataValida(gDataRelatorio) then
    Exit;

  gDtMovInvalida := false;
//  if  not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

  // Mostra Tela - LOG
  gArquivo11 := '';
  // frmLog.Show

  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Data do Movimento: ' + DateToStr(gDataRelatorio)+#10+#10;

  sSql := 'select * from tb_moeda ';
  sSql := sSql+'where str(data) = '#39''+DateToStr(gDataRelatorio)+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.Sql.Add(sSql);
  RsDbQry.Open;

  if RsDbQry.EOF then
    begin
    ShowMessage('Dolar não está cadastrado');
    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Dolar não está cadastrado'+#10;
    //goto Saida;
    RsDbQry.Close;
    Exit;
    end;

  gTaxa := RsDbQry.FieldByName('valor').Value;
  sSql := 'Select * from [Lancamentos]';

  //Work := DBEngine.Workspaces(0);
//  Banco := Work.OpenDatabase(gDataPath+gDataFile);
  Conecta(Banco, gDataPath + gDataFile + '.udl');

  RsLocal := TAdoDataSet.Create(nil);
  RsLocal.Connection := Banco;

  sSql := 'select * from tb_opcao ';
  sSql := sSql+'order by conta_contabil ';
//  RsLocal := Banco.OpenRecordset(sSql);
  RsLocal.CommandText := sSql;
  RsLocal.Open;

  gMaxCon := 0;
//  with RsLocal do begin
  RsLocal.Last;
//  ReDim(gArrConcil, RsLocal.RecordCount+1);
//  ReDim(gArrConcil2, RsLocal.RecordCount+1);
//  ReDim(gArrConcil3, RsLocal.RecordCount+1);
  RsLocal.First;
  while not RsLocal.EOF do
    begin
//    gArrConcil[gMaxCon] := RsLocal.FieldByName('Opcao').Value;
//    gArrConcil2[gMaxCon] := RsLocal.FieldByName('conta_contabil').Value;
//    gArrConcil3[gMaxCon] := RsLocal.FieldByName('cliente').Value;
    gArrConcil.Add(RsLocal.FieldByName('Opcao').Value);
    gArrConcil2.Add(RsLocal.FieldByName('conta_contabil').Value);
    gArrConcil3.Add(RsLocal.FieldByName('cliente').Value);
    gMaxCon := gMaxCon+1;
    RsLocal.Next;
  end;
  RsLocal.Close;
  Banco.Close;

  J := 0;
  gNReg := 0;
  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + StringOfChar(' ', 67) +
                              'Débitos        Créditos           Saldo'+#10+#10;
  while J < gMaxCon do
    begin
    gConciliacao := gArrConcil[J];
    gLimiteVariacao := GetLimite(gArrConcil3[J], gArrConcil2[J]);
    Concil.ContaContabil := gArrConcil2[J];
    // frmLog.RichTextBox1.Text = frmLog.RichTextBox1.Text &
    // Concil.ArqEntrada & "   " & Space(50 - Len(gConciliacao))

    SimulaNovaCon;
    if  not gAtualizaGeral then begin
      frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + gArrConcil2[J] + '   ' + gConciliacao +
                                  StringOfChar(' ', 50-Length(gConciliacao)) + 'Atualização Geral Bloqueada'+#10;
      goto NextReg;
    end;
    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + gArrConcil2[J] + '   ' + gConciliacao +
                                StringOfChar(' ', 50-Length(gConciliacao));

//    NomeArquivo := GetPath+'\';
    NomeArquivo := ExtractFileDir(Application.ExeName)+'\';
    // NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ArqEntrada)
    NomeArquivo := NomeArquivo+gCliente+'\entrada\'+'JUNTADO';
    NomeArquivo := NomeArquivo+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
    NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
    NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);
    NomeArquivo := NomeArquivo+'.txt';

//    NomeTmp := GetPath+'\';
    NomeTmp := ExtractFileDir(Application.ExeName)+'\';
    NomeTmp := NomeTmp+gCliente+'\entrada\'+Trim(Concil.ContaContabil);
    NomeTmp := NomeTmp+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
    NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 4, 2);
    NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 1, 2);
    NomeTmp := NomeTmp+'.tmp';

    gTotDebito := 0;
    gTotCredito := 0;
    gSaldo := FloatToStr(GetSaldo);
    if GeraTemp(NomeTmp, NomeArquivo) then
      // NomeArquivo = TiraExt(NomeArquivo) & ".tmp"
      NomeArquivo := NomeTmp
    else
      begin
      if gDtMovInvalida then
        Exit;
      Buffer := FormatVB(gTotDebito,'###,##0.00');
      Buffer1 := FormatVB(gTotCredito,'###,##0.00');
      buffer2 := FormatVB(GetSaldo,'###,##0.00');

      frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + StringOfChar(' ', 15-Length(Buffer)) + Buffer + ' ' +
                                  StringOfChar(' ', 15-Length(Buffer1)) + Buffer1 + ' ' +
                                  StringOfChar(' ', 15-Length(buffer2)) + buffer2 + #10;
      // frmLog.RichTextBox1.Text = frmLog.RichTextBox1.Text &
      // "Não há Movimento" & Chr(10)
      Application.ProcessMessages;
      goto NextReg;
      end;

    gData1 := FormatVB(DateToStr(gDataRelatorio),'DD/MM/YYYY');
    sSql := 'Select * from [Lancamentos]';
    sSql := sSql+' where (str(Data_Debito) = '#39''+gData1+''#39' or str(Data_Debito) = '#39''+DateToStr(gDataRelatorio)+''#39' ';
    sSql := sSql+' or str(Data_Credito) = '#39''+gData1+''#39' or str(Data_Debito) = '#39''+DateToStr(gDataRelatorio)+''#39')';
    sSql := sSql+' and conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
 //   if  not Conecta('') then Exit;
 //   RsDb := gBanco.OpenRecordset(sSql);

    if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
      Exit;

    RsDbQry.Close;
    RsDbQry.Sql.Add(sSql);
    RsDbQry.Open;

    if not RsDbQry.EOF then
      begin
      frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Movimento já foi Processado.' + #10;
      goto NextReg;
      end;

//    Desconecta;
    RsDbQry.Close;

    gNroReg := 0;
    if Concil.Natureza='D' then begin
      // Processa primeiro Dolar
      for I:=0 to ncDebito-1 do begin
        if  not ContaDebito(I, '840', NomeArquivo) then goto Saida;
      end; // I
      for I:=0 to ncCredito-1 do begin
        if  not ContaCredito(I, '840', NomeArquivo) then goto Saida;
      end; // I

      for I:=0 to ncDebito-1 do begin
        if  not ContaDebito(I, '986', NomeArquivo) then goto Saida;
      end; // I
      for I:=0 to ncCredito-1 do begin
        if  not ContaCredito(I, '986', NomeArquivo) then goto Saida;
      end; // I
     end  else  begin
      for I:=0 to ncCredito-1 do begin
        if  not ContaCredito(I, '840', NomeArquivo) then goto Saida;
      end; // I
      for I:=0 to ncDebito-1 do begin
        if  not ContaDebito(I, '840', NomeArquivo) then goto Saida;
      end; // I

      for I:=0 to ncCredito-1 do begin
        if  not ContaCredito(I, '986', NomeArquivo) then goto Saida;
      end; // I
      for I:=0 to ncDebito-1 do begin
        if  not ContaDebito(I, '986', NomeArquivo) then goto Saida;
      end; // I
    end;

    Buffer := FormatVB(gTotDebito,'###,##0.00');
    Buffer1 := FormatVB(gTotCredito,'###,##0.00');
    buffer2 := FormatVB(GetSaldo,'###,##0.00');

    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + StringOfChar(' ', 15-Length(Buffer)) + Buffer + ' ' +
                                StringOfChar(' ', 15-Length(Buffer1)) + Buffer1 + ' ' +
                                StringOfChar(' ', 15-Length(buffer2)) + buffer2 + #10;

    // Grava dados no Balancete

//    if  not Conecta('') then Exit;        Não já está conectado?

    // sSql = "Select * from [tbBalancete]"
    // Set RsDb = gBanco.OpenRecordset(sSql)
    // With RsDb
    // .AddNew
    // .Fields("Data") = gDataRelatorio
    // .Fields("Conta_Contabil") = Concil.ContaContabil
    // .Fields("SaldoAnt") = gSaldo
    // .Fields("Debito") = gTotDebito
    // .Fields("Credito") = gTotCredito
    // .Fields("UsDolar") = gTaxa
    // .Update
    // End With

    // Registra a atualização realizada
    // If Not Conecta("") Then Exit Sub

{    sSql := 'Select * from [Atualizacao]';
    RsDb := gBanco.OpenRecordset(sSql);   }
    RsDbTb.TableName := 'Atualizacao';
    RsDbTb.Filter := '';

    RsDbTb.Insert;
    VBtoADOFieldSet(RsDbTb, 'Atualizacao', gDataRelatorio);
    VBtoADOFieldSet(RsDbTb, 'Conta_Contabil', Trim(Concil.ContaContabil));
    VBtoADOFieldSet(RsDbTb, 'Tot_Debito', gTotDebito);
    VBtoADOFieldSet(RsDbTb, 'Tot_Credito', gTotCredito);
    RsDbTb.UpdateRecord;
//    Desconecta;
    RsDbTb.Close;

  NextReg:
    J := J+1;
    Application.ProcessMessages;
  end;
  // Libera memória
  gNReg := 0;
//  ReDim(gArqEntrada, gNReg+1);
  // Faz Backup do banco de dados com as novas movimentações
  BackupBanco;
  // LastAtualiza

Saida:
//  ReDim(gArrConcil, 0+1);
//  ReDim(gArrConcil2, 0+1);
//  ReDim(gArrConcil3, 0+1);
  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + #10+'Fim da Atualização  -  '+FormatVB(Now,'hh:mm:ss')+#10;
  gArquivo11 := frmLog.RichTextBox1.Text;
  // Unload frmLog
  frmLog.ShowModal;
end;

Procedure TDataModule.ConectaAdm;
Begin
  Conecta(gBanco,gAdmPath + '\admin.udl');
End;

Procedure TDataModule.DesconectaAdm;
Begin
  gBanco.Close;
End;

function TDataModule.Get_Codigo_Para(Conta: String): String;
var
  I: Integer;
begin
  // 2008/09/04
  // Pega codigo_para na atualização manual, conta tipo 110506

  Result := '';
  I := 1;
  while mInterface[I].Codigo <> '999999' do
    begin
    if mInterface[I].Conta_contabil = Conta then
      begin
      Result := mInterface[I].Codigo;
      break;
      end;
    Inc(I);
  end;
end;

Procedure TDataModule.Monta_Interface;
var
  I: Integer;
begin
  // Popula um array para verificação de contas para arquivo Interface
  // e para obter codigo_para a partir da conta_contabil

  sSql := 'select * from tbContasAdm';
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  RsDbDs.Last;

  SetLength(mInterface, RsDbDs.RecordCount+1);
  RsDbDs.First;
  I := 0;
  while not RsDbDs.EOF do
    begin
    mInterface[I].Conta_contabil := RsDbDs.FieldByName('conta_contabil').Value;
    mInterface[I].Codigo := RsDbDs.FieldByName('Codigo_Para').Value;
    mInterface[I].mInterface := RsDbDs.FieldByName('Interface').Value;
    Inc(I);
    RsDbDs.Next;
    end;

  mInterface[I].Codigo := '999999';

  RsDbDs.Close;
end;

Procedure TDataModule.Monta_PFPJ;
var
  I: Integer;
begin
  // Popula um array para verificação de pessoa fisica / juridica
  // baseado na tabela BIN
  // Em principio não esta sendo utilizada pois o campo esta indo em branco na Interface

  sSql := 'select * from tbBIN where PF_PJ = '#39'PJ'#39'';

  RsDbDsCli.CommandText := sSql;
  RsDbDsCli.Open;

  I := 0;

  RsDbDsCli.Last;
  SetLength(TipoPessoa, RsDbDsCli.RecordCount+1);
  RsDbDsCli.First;
  while not RsDbDsCli.EOF do
    begin
    TipoPessoa[I].BIN := RsDbDsCli.FieldByName('BIN').AsInteger;
    Inc(I);
    RsDbDsCli.Next;
    end;

  TipoPessoa[I].BIN := 999999;

  RsDbDsCli.Close;

end;

Procedure TDataModule.Monta_SACI;
var
  I, J, K: Integer;
  ArqInterface: System.Text;
  NomeInterface, Buffer: String;
begin
  // Popula um array para verificação de contas de uma perna SO'
  // Primero gera Débitos e Créditos
  // Marca os SACIs e guarda para NAO GERAR INTERFACE
  // Gerar arquivo de SACIs

  {
  SELECT *
  FROM [SISCOC_Admin].[dbo].[tbContasAdm]
  WHERE nome_cliente = 'BANCOX_VISA'
  AND Interface2 = 'S'
  AND Natureza = 'C'
  AND (conta_contabil NOT IN (SELECT conta_contabil FROM [SISCOC_Admin].[dbo].[tbContasAdm]
                              WHERE nome_cliente = 'BANCOX_VISA'
                                    AND Interface2 = 'S'
                                    AND Natureza = 'D'))
  }

  {
SELECT *
  FROM [SISCOC_Admin].[dbo].[tbContasAdm]
  WHERE nome_cliente = 'BANCOX_VISA'
  AND Interface2 = 'S'
  AND Natureza = 'D'
  AND (conta_contabil NOT IN (SELECT conta_contabil FROM [SISCOC_Admin].[dbo].[tbContasAdm]
                              WHERE nome_cliente = 'BANCOX_VISA'
                                    AND Interface2 = 'S'
                                    AND Natureza = 'C'))  }

  sSql := '';
  sSql := sSql+'Select * from [tbcontasAdm] ';
  sSql := sSql+'where nome_cliente = '#39''+gCliente+''#39'';
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  I := 1;         // Começando por 1 para armazenar 9999 no final
  J := 1;
  while not RsDbDs.EOF do
    begin
    if (RsDbDs.FieldByName('Interface2').AsString = 'S') Then
      if (RsDbDs.FieldByName('Natureza').AsString = 'D') then
        Inc(I)
      else
        Inc(J);
    RsDbDs.Next;
    end;

  SetLength(debitoSACI, I);
  SetLength(creditoSACI, J);
  RsDbDs.First;
  I := 0;
  J := 0;

  while not RsDbDs.EOF do
    begin
    if (RsDbDs.FieldByName('Interface2').AsString = 'S') then
      if (RsDbDs.FieldByName('Natureza').AsString = 'D') then
        begin
        // Gera Debito
        debitoSACI[I].Codigo := RsDbDs.FieldByName('Codigo_Para').AsString;
        debitoSACI[I].TemPerna := false;
        Inc(I);
        end
      else
        begin
        // guarda
        SetLength(creditoSACI, J+1);
        creditoSACI[J].Codigo := RsDbDs.FieldByName('Codigo_Para').AsString;
        creditoSACI[J].TemPerna := false;
        Inc(J);
        end;
    RsDbDs.Next;
    end;

  debitoSACI[I].Codigo := '999999';
  creditoSACI[J].Codigo := '999999';

    // Verifica se tem algum lançamento sem perna
  if I > J then
    begin
      // Tem mais crédito que Débito
    I := 0;
    while debitoSACI[I].Codigo <> '999999' do
      begin
        // Procura débitos para matar créditos
      K := J-1;
      while K > 0 do
        begin
        if debitoSACI[I].Codigo = creditoSACI[K].Codigo then
          begin
          if (debitoSACI[I].TemPerna = false) and (creditoSACI[K].TemPerna = false) then
            begin
            debitoSACI[I].TemPerna := true;
            creditoSACI[K].TemPerna := true;
            K := 0;
            end;
          end;
        Dec(K);
        end;
      Inc(I);
      end;
    end
  else
    begin
      // Tem mais Débito que Crédito
    J := 0;
    while creditoSACI[J].Codigo <> '999999' do
      begin
        // Procura créditos para matar débitos
      K := I-1;
      while K > 0 do
        begin
        if creditoSACI[J].Codigo = debitoSACI[K].Codigo then
          begin
          if (creditoSACI[J].TemPerna = false) and (debitoSACI[K].TemPerna = false) then
            begin
            creditoSACI[J].TemPerna := true;
            debitoSACI[K].TemPerna := true;
            K := 0;
            end;
          end;
        Dec(K);
        end;
      Inc(J);
      end;
    end;

  // Verifica se tem algum lançamento com perna = sem perna
  // Se tiver, corta a perna
  I := 0;
  while debitoSACI[I].Codigo <> '999999' do
    begin
    // Procura débitos sem perna
    if (debitoSACI[I].TemPerna = false) then
      begin
      K := 0;
      while Trim(creditoSACI[K].Codigo) <> '999999' do
        begin
        if debitoSACI[I].Codigo = creditoSACI[K].Codigo then
          creditoSACI[K].TemPerna := false;
        Inc(K);
        end;

      K := 0;
      while Trim(debitoSACI[K].Codigo) <> '999999' do
        begin
        if debitoSACI[I].Codigo = debitoSACI[K].Codigo then
          debitoSACI[K].TemPerna := true;
        Inc(K);
        end;
      end;
    Inc(I);
    end;

  // Monta data sem barras
  Buffer := '20' + Copy(DateToStr(gDataRelatorio), 7, 2) + Copy(DateToStr(gDataRelatorio), 4, 2) +
            Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeInterface := ExtractFileDir(Application.ExeName)+'\'+gCliente+'\Interface\SACI_'+Buffer+'.txt';
  if FileExists(NomeInterface) then
    DeleteFile(NomeInterface);

  AssignFile(ArqInterface, NomeInterface);
  Rewrite(ArqInterface);

//  sSql := 'Créditos sem Perna (SACI)'+#10+#10;
  WriteLn(ArqInterface, 'Créditos sem Perna (SACI)'+#10+#10);
  I := 0;
  J := 0;
  while creditoSACI[I].Codigo <> '999999' do
    begin
    if creditoSACI[I].TemPerna = false then
      begin
//      sSql := sSql + StringOfChar(' ', 8) + creditoSACI[I].Codigo + #10;
      WriteLn(ArqInterface, StringOfChar(' ', 8) + creditoSACI[I].Codigo + #10);
      end;
    Inc(I);
    end;

//  sSql := sSql+#10+#10;
  WriteLn(ArqInterface);

//  sSql := sSql + 'Débitos sem Perna (SACI)' +#10+#10;
  WriteLn(ArqInterface, 'Débitos sem Perna (SACI)'+#10+#10);

  while Trim(debitoSACI[J].Codigo)<>'999999' do
    begin
    if debitoSACI[J].TemPerna=false then
      begin
//      sSql := sSql + StringOfChar(' ', 8) + debitoSACI[J].Codigo+#10;
      WriteLn(ArqInterface, StringOfChar(' ', 8) + debitoSACI[J].Codigo+#10);
      end;
    Inc(J);
    end;
  // MsgBox sSql

  CloseFile(ArqInterface);
  RsDbDs.Close;
end;

function TDataModule.GerarInterface(Cod: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  I := 0;
  while mInterface[I].Codigo <> '999999' do
    begin
    if mInterface[I].Codigo = Cod then
      begin
      if mInterface[I].mInterface then
        begin
        Result := true;
        break;
        end;
      end;
    Inc(I);
    end;
end;

function TDataModule.pegaSaci(Cod: String; DecCred: String): Boolean;
var
  I: Integer;
begin

  Result := false;

  I := 0;
  while (creditoSACI[I].Codigo)<>'999999' do
    begin
    if mInterface[I].Codigo = Cod then
      begin
      if DecCred = 'C' then
        begin
        if creditoSACI[I].TemPerna = false then
          begin
          Result := true;
          break;
          end;
        end;
      end;
    Inc(I);
    end;

  I := 0;
  while (debitoSACI[I].Codigo) <> '999999' do
    begin
    if mInterface[I].Codigo = Cod then
      begin
      if DecCred = 'D' then
        begin
        if debitoSACI[I].Codigo = Cod then
          begin
          if creditoSACI[I].TemPerna=false then
            begin
            Result := true;
            break;
            end;
          end;
        end
      else
        begin
        if creditoSACI[I].Codigo=Cod then
          begin
          if creditoSACI[I].TemPerna=false then
            begin
            Result := true;
            break;
            end;
          end;
        end;
      end;
    Inc(I);
    end;

end;

function TDataModule.Gera_Interface: Boolean;
var
  ArqInterface, ArqSaci: System.Text;
  NomeInterface, NomeSaci, Buffer, Codigo, S: String;
  cntInter, cntSaci: Integer;
  TipoCartão : Array['3'..'5'] of Char;
begin

TipoCartão['3'] := 'A';
TipoCartão['4'] := 'V';
TipoCartão['5'] := 'M';

  // Le dados das tabelas cliente.Lancamentos, cliente.tb_opcao e cliente.tbcontas
  // e gera arquivo txt interface_aaaammdd.txt.
{  DbAdm := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
  DbLocal := gWork.OpenDatabase(gAdmPath+'\'+gCliente+'\'+gDataFile);}

  Conecta(gBanco,gAdmPath + '\admin.udl');
  Conecta(gBancoCli,gAdmPath+'\' + gCliente+'\' + gDataFile + '.udl');

  // Monta tabela Interface
  Monta_Interface;
  // Monta tabela de BIN PJ
  Monta_PFPJ;

  // Rever 20/09/08
  // Parece que não precisa
  Monta_SACI;

  // =======================================================================================
  // Recupera os lancamento fechados (ZERADOS)
  // sSql = "select * from Lancamentos "
  // sSql = sSql & "where ( (str(Data_Credito) = '20/09/08' and Not IsNull(Data_Debito))"
  // sSql = sSql & "or (str(Data_Debito) = '20/09/08' and Not IsNull(Data_Credito)) )"
  // sSql = sSql & "and VL_Saldo = 0"

  // sSql = "select * from Lancamentos "
  // sSql = sSql & "where str(Data_Credito) = '" & CDate(gDataRelatorio) & "'"
  // sSql = sSql & " or str(Data_Debito) = '" & CDate(gDataRelatorio) & "'"

  // sSql = "select * from Lancamentos "
  // sSql = sSql & "where str(Data_Credito) <= '" & CDate(gDataRelatorio) & "'"
  // sSql = sSql & " or str(Data_Debito) <= '" & CDate(gDataRelatorio) & "'"
  // =======================================================================================

//  sSql := 'select * from Lancamentos ';
//  sSql := sSql+'where str(Data_Credito) <= '#39''+(DateToStr(gDataRelatorio))+''#39'';
  sSql := 'str(Data_Credito) <= '#39''+(DateToStr(gDataRelatorio))+''#39'';
  sSql := sSql+' or str(Data_Debito) <= '#39''+DateToStr(gDataRelatorio)+''#39'';

//  RsDb := DbLocal.OpenRecordset(sSql);
  RsDbTbCli.Filter := sSql;
  RsDbTbCli.Filtered := True;
  RsdbTbCli.Open;

  // Monta data sem barras
  Buffer := '20' + Copy(DateToStr(gDataRelatorio), 7, 2) + Copy(DateToStr(gDataRelatorio), 4, 2) +
                   Copy(DateToStr(gDataRelatorio), 1, 2);

  NomeInterface := ExtractFileDir(Application.ExeName)+'\'+gCliente+'\Interface\Interface_'+Buffer+'.txt';
  if FileExists(NomeInterface) then
    DeleteFile(NomeInterface);

  NomeSaci := ExtractFileDir(Application.ExeName)+'\'+gCliente+'\Interface\Saci_'+Buffer+'.txt';
  if FileExists(NomeSaci) then
    DeleteFile(NomeSaci);

  AssignFile(ArqInterface, NomeInterface);
  Rewrite(ArqInterface);

  AssignFile(ArqSaci, NomeSaci);
  Rewrite(ArqSaci);

  cntInter := 0;
  cntSaci := 0;

  PegaParCodigo;
  begin
  while not RsDbTbCli.EOF do
    begin
//    if not IsNull(FieldByName('Data_Debito')) and IsNull(FieldByName('Data_Inter_Debito')) then begin
    if not (String.IsNullOrEmpty(RsDbTbCli.FieldByName('Data_Debito').AsString) and
            String.IsNullOrEmpty(RsDbTbCli.FieldByName('Data_Inter_Debito').AsString)) then
      begin
      Codigo := RsDbTbCli.FieldByName('Cod_Deb').Value;
      if GerarInterface(Codigo) then
        begin
          // Gera Debito
        Buffer := 'F20'; // Fixo
        Buffer := Buffer + Copy(RsDbTbCli.FieldByName('Cartao').AsString, 1, 6) + '   '; // BIN 4,9
        Codigo := RsDbTbCli.FieldByName('Cod_Deb').AsString;
        Buffer := Buffer + Copy(Codigo, Param_Codigo.SRC.Posicao, Param_Codigo.SRC.Tamanho); // 13,3
        Buffer := Buffer+'00';
          // TCRC
        Buffer := Buffer+Copy(Codigo, Param_Codigo.TCRC.Posicao, Param_Codigo.TCRC.Tamanho); // 20,1
          // D_C
          // Buffer = Buffer & Mid$(Codigo, Param_Codigo.D_C.Posicao, Param_Codigo.D_C.Tamanho)   '  20,1
        Buffer := Buffer+'D';
        Buffer := Buffer+Copy(Codigo, Param_Codigo.REJ.Posicao, Param_Codigo.REJ.Tamanho); // 20,1
        Buffer := Buffer+Copy(Codigo, Param_Codigo.REV.Posicao, Param_Codigo.REV.Tamanho);
          // Primeiro digito: 3= "A"mex 4 = "V"isa e 5 = "M"aster
        Buffer := Buffer + tipoCartão[RsDbTbCli.FieldByName('Cartao').AsString.Chars[0]];
        Buffer := Buffer+Copy(Codigo, Param_Codigo.DEST.Posicao, Param_Codigo.DEST.Tamanho);
          // Tipo de Produto (Product Type)
          // Buffer = Buffer & Mid$(Codigo, Param_Codigo.TPP.Posicao, Param_Codigo.TPP.Tamanho)
          // Buffer = Buffer & TipoDePessoa(Mid$(.Fields("Cartao"), 1, 6))  ' BIN
        Buffer := Buffer+'  ';

        Buffer := Buffer+Copy(Codigo, Param_Codigo.T_E.Posicao, Param_Codigo.T_E.Tamanho);
        Buffer := Buffer+'      '; // PLAN-ID
        Buffer := Buffer + RsDbTbCli.FieldByName('Moeda_Deb').AsString;
        Buffer := Buffer+Copy(Codigo, Param_Codigo.CHO.Posicao, Param_Codigo.CHO.Tamanho);
        Buffer := Buffer+Copy(Codigo, Param_Codigo.BIL.Posicao, Param_Codigo.BIL.Tamanho);
          // Buffer = Buffer & " "   'BILLED-CODE
          // Formatar e tira virgula
        S := Tiravirgula(FormataValor3(RsDbTbCli.FieldByName('Vl_DebitoReal').AsString));
        Buffer := Buffer + StringOfChar('0', 13-Length(S)) + S;
        Buffer := Buffer + RsDbTbCli.FieldByName('Cartao').AsString;
          // BIL-DAY = "00"
        Buffer := Buffer+'00';
        Buffer := Buffer + FormatDateTime('yyyymmdd', gDataRelatorio);
          // Filler
        Buffer := Buffer + StringOfChar(' ', 17);
          // Pega SACI
        if pegaSaci(Codigo, 'D') then
          begin
          WriteLn(ArqSaci, Buffer);
          cntSaci := cntSaci+1;
          end
        else
          begin
          WriteLn(ArqInterface, Buffer);
          cntInter := cntInter+1;
          RsDbTbCli.Edit;
          VBtoADOFieldSet(RsDbTbCli, 'Data_Inter_Debito', Now);
          RsDbTbCli.UpdateRecord;
          end;
        end;
      end;

//      if  not IsNull(FieldByName('Data_Credito')) and IsNull(FieldByName('Data_Inter_Credito')) then begin
      if  not (String.IsNullOrEmpty(RsDbTbCli.FieldByName('Data_Credito').AsString) and
               String.IsNullOrEmpty(RsDbTbCli.FieldByName('Data_Inter_Credito').AsString)) then
        begin
        Codigo := RsDbTbCli.FieldByName('Cod_Cred').Value;
        if GerarInterface(Codigo) then begin
          // Gera Credito
          Buffer := 'F20'; // Fixo
          Buffer := Buffer+Copy(RsDbTbCli.FieldByName('Cartao').Value, 1, 6)+'   '; // BIN
          Codigo := RsDbTbCli.FieldByName('Cod_Cred').Value;
          Buffer := Buffer+Copy(Codigo, Param_Codigo.SRC.Posicao, Param_Codigo.SRC.Tamanho);
          Buffer := Buffer+'00';
          // TCRC
          Buffer := Buffer+Copy(Codigo, Param_Codigo.TCRC.Posicao, Param_Codigo.TCRC.Tamanho); // 20,1
          // D_C
          // Buffer = Buffer & Mid$(Codigo, Param_Codigo.D_C.Posicao, Param_Codigo.D_C.Tamanho)   '  20,1
          Buffer := Buffer+'C';

          Buffer := Buffer+Copy(Codigo, Param_Codigo.REJ.Posicao, Param_Codigo.REJ.Tamanho); // 20,1
          Buffer := Buffer+Copy(Codigo, Param_Codigo.REV.Posicao, Param_Codigo.REV.Tamanho);
          // Primeiro digito: 3= "A"mex 4 = "V"isa e 5 = "M"aster
          Buffer := Buffer + tipoCartão[RsDbTbCli.FieldByName('Cartao').AsString.Chars[0]];
          Buffer := Buffer+Copy(Codigo, Param_Codigo.DEST.Posicao, Param_Codigo.DEST.Tamanho);
          // Tipo de Produto (Product Type)
          // Buffer = Buffer & Mid$(Codigo, Param_Codigo.TPP.Posicao, Param_Codigo.TPP.Tamanho)
          // Buffer = Buffer & TipoDePessoa(Mid$(.Fields("Cartao"), 1, 6)) ' BIN
          Buffer := Buffer+'  ';
          Buffer := Buffer+Copy(Codigo, Param_Codigo.T_E.Posicao, Param_Codigo.T_E.Tamanho);
          Buffer := Buffer+'      '; // PLAN-ID
          Buffer := Buffer+RsDbTbCli.FieldByName('Moeda_Cred').Value;
          Buffer := Buffer+Copy(Codigo, Param_Codigo.CHO.Posicao, Param_Codigo.CHO.Tamanho);
          // BILLED-CODE
          Buffer := Buffer+Copy(Codigo, Param_Codigo.BIL.Posicao, Param_Codigo.BIL.Tamanho);
          // Formatar e tira virgula
          S := Tiravirgula(FormataValor3(RsDbTbCli.FieldByName('Vl_CreditoReal').Value));
          Buffer := Buffer + StringOfChar('0', 13-Length(S)) + S;
          Buffer := Buffer + RsDbTbCli.FieldByName('Cartao').Value;
          // BIL-DAY = "00"
          Buffer := Buffer + '00';
          Buffer := Buffer + FormatDateTime('yyyymmdd', gDataRelatorio);
          // Filler
          // Buffer = Buffer & Mid$(Codigo, Param_Codigo.Filler.Posicao, Param_Codigo.Filler.Tamanho)
          Buffer := Buffer+StringOfChar(' ', 17);
          // Pega SACI
          if pegaSaci(Codigo, 'C') then
            begin
            WriteLn(ArqSaci, Buffer);
            cntSaci := cntSaci+1;
            end
          else
            begin
            WriteLn(ArqInterface, Buffer);
            cntInter := cntInter+1;
            RsDbTbCli.Edit;
            VBtoADOFieldSet(RsDbTbCli, 'Data_Inter_Credito', Now);
            RsDbTbCli.UpdateRecord;
            end;
          end;
        end;
        Next;
      end;
    end;

  RsdbTbCli.Close;
  gBanco.Close;
  gBancoCli.Close;
  CloseFile(ArqInterface);
  CloseFile(ArqSaci);

  // Copia interface com o nome esperado pelo mainframe
  // FileCopy a, b
  if cntInter > 0 then
    begin
    sSql := NomeInterface+' gerado: '+mStr(cntInter)+' Registros !!!'+#10;
    sSql := sSql+NomeSaci+' gerado: '+mStr(cntSaci)+' Registros !!!';
    ShowMessage(PChar(sSql));

    Buffer := ExtractFileDir(Application.ExeName)+'\'+gCliente+'\Interface\PDAXCD.ARP.GLITSCC.TRI(+1)';
    CopyFile(PChar(NomeInterface), PChar(Buffer), false);
    end
  else
    ShowMessage('Nenhum registro válido para geração !!!');

Result := True;

end;

end.
