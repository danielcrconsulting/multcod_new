unit frmAgenda1_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, ADODB;


type
  TfrmAgenda1 = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Label4:  TLabel;
    Label5:  TLabel;
    Line1:  TShape;
    Label6:  TLabel;
    Label7:  TLabel;
    Text1:  TEdit;
    Text2:  TEdit;
    Text3:  TEdit;
    Text4:  TEdit;
    Command1:  TButton;
    Command2:  TButton;
    Text5:  TEdit;
    Text6:  TEdit;
    Text7:  TEdit;
    Text8:  TEdit;
    cmdRelat:  TButton;

    procedure cmdRelatClick(Sender: TObject);
    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GravaRel(Rs1: TADOTable; Rs2: TADODataSet);

  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  frmAgenda1: TfrmAgenda1;

implementation

uses  Dialogs, SysUtils, StrUtils, Module1, frmMain_, RotGerais, VBto_Converter;

{$R *.dfm}

 //=========================================================

procedure TfrmAgenda1.cmdRelatClick(Sender: TObject);
var
  DbLocal: TADOConnection;
  cnAdoConect: TADOConnection;
  RsLocal: TADOTable;
  RsDb: TADODataSet;
begin
  //DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
   Conecta(DbLocal, ExtractFileDir(Application.ExeName) + '\admin.udl');
   Conecta(cnAdoConect, gDataPath + gDataFile + '.udl');

  RsLocal :=  TADOTable.Create(nil);
  RsLocal.Connection := DbLocal;

  RsDb :=  TADODataSet.Create(nil);
  RsDb.Connection :=  cnAdoConect;

  GravaHeaderRel(DbLocal, RsLocal, 2);

  RsLocal.Close;

 // sSql := 'select * from Relatorio';
  RsLocal.TableName := 'Relatorio';
  RsLocal.Open;

  // Valores em Reais
  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and str(Data_Debito) =  '#39''+gData1+''#39'';
  sSql := sSql+' and Data_Credito =  null';
  sSql := sSql+' and Vl_DebitoDolar =  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.CommandText := sSql;
  RsDb.Open;

  while not RsDb.EOF do
    begin
    GravaRel(RsLocal, RsDb);
    Next;
    end;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and Data_Debito = null ';
  sSql := sSql+' and str(Data_Credito) = '#39''+gData1+''#39'';
  sSql := sSql+' and Vl_CreditoDolar =  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  while not RsDb.EOF do
    begin
    GravaRel(RsLocal, RsDb);
    Next;
    end;

  // Valores em Dolar

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and str(Data_Debito) =  '#39''+gData1+''#39'';
  sSql := sSql+' and Data_Credito =  null';
  sSql := sSql+' and Vl_DebitoDolar > 0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  while not RsDb.EOF do
    begin
    GravaRel(RsLocal, RsDb);
    Next;
    end;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and Data_Debito = null ';
  sSql := sSql+' and str(Data_Credito) = '#39''+gData1+''#39'';
  sSql := sSql+' and Vl_CreditoDolar >  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  while not RsDb.EOF do
    begin
    GravaRel(RsLocal, RsDb);
    Next;
    end;

  RsLocal.Close;
  RsLocal.Free;
  RsDb.Close;
  RsDb.Free;
   DbLocal.Close;
  cnAdoConect.Close;
   DbLocal.Free;
  cnAdoConect.Free;

  // Mostra Relatório
  Application.ProcessMessages;

(*  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\agenda.rpt';
  fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;*)
  // fMainForm.CrystalReport1.Action = 1

end;

procedure TfrmAgenda1.Command1Click(Sender: TObject);
var
  DbLocal: TADOConnection;
  cnAdoConect: TADOConnection;
  RsLocal: TADOTable;
  RsDb: TADODataSet;
begin
  // Obter taxa
//  sSql := 'select * from tb_moeda where str(data) = '#39''+gData1+''#39'or STR(data) = '#39''+dataDezBarra(gData1)+''#39'';

   Conecta(DbLocal, ExtractFileDir(Application.ExeName) + '\admin.udl');

  RsLocal :=  TADOTable.Create(nil);
  RsLocal.Connection := DbLocal;

  sSql := 'select * from tb_moeda where str(data) = '#39'' + gData1 + ''#39'or STR(data) = '#39'' +
           FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39'';

  Conecta(cnAdoConect, gDataPath + gDataFile + '.udl');
  RsDb :=  TADODataSet.Create(nil);
  RsDb.Connection :=  cnAdoConect;

  RsDb.CommandText := sSql;
  RsDb.Open;

  if RsDb.EOF then
    begin
    ShowMessage('Dolar não está cadastrado');
    RsDb.Close;
    RsDb.Free;
    cnAdoConect. Close;
    cnAdoConect.Free;
    Exit;
    end;

  gTaxa := RsDb.FieldByName('valor').Value;
  RsDb.Close;

  Screen.Cursor := crHourGlass;

   Conecta(DbLocal, ExtractFileDir(Application.ExeName) + '\admin.udl');
  RsLocal :=  TADOTable.Create(nil);
  RsLocal.Connection := DbLocal;

  GravaHeaderRel(DbLocal, RsLocal, 2);

  RsLocal.Close;
//  sSql := 'select * from Relatorio';
  RsLocal.TableName := 'Relatorio';
  RsLocal.Open;

  // Valores em Reais
  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql + ' and (str(Data_Debito) =  '#39''+gData1+''#39' or str(Data_Debito) = '#39'' +
                 FormatDateTime('YYYY/MM/DD',StrToDate(gData1))+''#39')';
  sSql := sSql+' and Data_Credito =  null';
  sSql := sSql+' and Vl_DebitoDolar =  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.CommandText := sSql;
  RsDb.Open;

  while  not RsDb.EOF do
    begin
    RsDb.Edit;
    VBtoADOFieldSet(RsDb, 'Data_Credito', gData2);
    VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', RsDb.FieldByName('Vl_DebitoReal').Value);
    VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal').AsExtended -
                                      RsDb.FieldByName('Vl_CreditoReal').AsExtended);
    RsDb.UpdateRecord;
    GravaRel(RsLocal, RsDb);
    RsDb.Next;
    end;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+' and Data_Debito = null ';
  sSql := sSql+' and (str(Data_Credito) =  '#39''+gData1+''#39' or str(Data_Credito) = '#39'' +
               FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
  sSql := sSql+' and Vl_CreditoDolar =  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  while  not EOF do
    begin
    RsDb.Edit;
    VBtoADOFieldSet(RsDb, 'Data_Debito', gData2);
    VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', RsDb.FieldByName('Vl_CreditoReal').Value);
    VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal').AsExtended -
                                      RsDb.FieldByName('Vl_CreditoReal').AsExtended);
    RsDb.UpdateRecord;
    GravaRel(RsLocal, RsDb);
    RsDb.Next;
    end;

  // Valores em Dolar

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+' and (str(Data_Debito) =  '#39''+gData1+''#39' or str(Data_Debito) = '#39'' +
               FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
  sSql := sSql+' and Data_Credito =  null';
  sSql := sSql+' and Vl_DebitoDolar > 0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  while not RsDb.EOF do
    begin
    RsDb.Edit;
    VBtoADOFieldSet(RsDb, 'Data_Credito', gData2);
    VBtoADOFieldSet(RsDb, 'Vl_CreditoDolar', RsDb.FieldByName('Vl_DebitoDolar').Value);
    VBtoADOFieldSet(RsDb, 'Taxa_Credito', gTaxa);
//    VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', RoundTo(CDbl(FieldByName('Vl_CreditoDolar').Value)*CDbl(FieldByName('Taxa_Credito').Value), -2));
    VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', ((RsDb.FieldByName('Vl_CreditoDolar').Value)*(RsDb.FieldByName('Taxa_Credito').Value)));
    VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal').AsExtended -
                                      RsDb.FieldByName('Vl_CreditoReal').AsExtended);
    RsDb.UpdateRecord;
    GravaRel(RsLocal, RsDb);
    RsDb.Next;
    end;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+' and Data_Debito = null ';
  sSql := sSql+' and (str(Data_Debito) =  '#39''+gData1+''#39' or str(Data_Debito) = '#39'' +
               FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
  sSql := sSql+' and Vl_CreditoDolar >  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  while not RsDb.EOF do
    begin
    RsDb.Edit;
    VBtoADOFieldSet(RsDb, 'Data_Debito', gData2);
    VBtoADOFieldSet(RsDb, 'Vl_DebitoDolar', RsDb.FieldByName('Vl_CreditoDolar').Value);
    VBtoADOFieldSet(RsDb, 'Taxa_Debito', gTaxa);
//    VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', RoundTo(CDbl(FieldByName('Vl_DebitoDolar').Value)*CDbl(FieldByName('Taxa_Debito').Value), -2));
    VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', ((RsDb.FieldByName('Vl_DebitoDolar').Value)*(RsDb.FieldByName('Taxa_Debito').Value)));
    VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal').AsExtended -
                                      RsDb.FieldByName('Vl_CreditoReal').AsExtended);
    RsDb.UpdateRecord;
    GravaRel(RsLocal, RsDb);
    RsDb.Next;
    end;

  Screen.Cursor := crDefault;

  RsLocal.Close;
  RsLocal.Free;
  RsDb.Close;
  RsDb.Free;
   DbLocal.Close;
  cnAdoConect.Close;
   DbLocal.Free;
  cnAdoConect.Free;

  // Faz BackUp do Banco de Dados no diretório Backup_Temp
  // Nome do Arquivo = AAAAMMDD_HHMMSS_NomeConciliação.mdb
  // Qdo faz Backup via menu no diretório Backup,
  // deleta o Backup_Temp
  BackupBanco;

  Close;

  // Mostra Relatório
  Screen.Cursor := crHourGlass;

  Application.ProcessMessages;

(*  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\agenda.rpt';
  fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;
  // fMainForm.CrystalReport1.Action = 1*)

  Screen.Cursor := crDefault;

end;

procedure TfrmAgenda1.Command2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAgenda1.FormShow(Sender: TObject);
Var
  DbLocal: TADOConnection;
  cnAdoConect: TADOConnection;
  RsLocal: TADODataSet;
  RsDb: TADODataSet;
  sSql : String;
begin

  CenterForm(Self);

//  if  not Conecta('') then Exit;

   Conecta(DbLocal, ExtractFileDir(Application.ExeName) + '\admin.udl');
   Conecta(cnAdoConect, gDataPath + gDataFile + '.udl');

  RsLocal :=  TADODataSet.Create(nil);
  RsLocal.Connection := DbLocal;

  RsDb :=  TADODataSet.Create(nil);
  RsDb.Connection :=  cnAdoConect;

  Screen.Cursor := crHourGlass;

  // Valores em Reais
  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+' and (str(Data_Debito) = '#39''+gData1+''#39' or STR(Data_Debito) = '#39'' +
               FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
  sSql := sSql+' and Data_Credito =  null';

  sSql := sSql+' and Vl_DebitoDolar =  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.CommandText := sSql;
  RsDb.Open;

  if not RsDb.EOF then
    begin
    RsDb.Last;
    Text6.Text := IntToStr(RsDb.RecordCount);
    sSql := 'select sum( vl_debitoreal) from lancamentos where conta_contabil='#39'';
    sSql := sSql+Trim(Concil.ContaContabil)+''#39'';
    // sSql = sSql & " and str(Data_Debito) =  '" & gData1 & "'"
    sSql := sSql+' and (str(Data_Debito) = '#39''+gData1+''#39' or STR(Data_Debito) = '#39'' +
                 FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
    sSql := sSql+' and Data_Credito =  null';
    sSql := sSql+' and Vl_DebitoDolar =  0';
    sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

    RsDb.Close;
    RsDb.CommandText := sSql;
    RsDb.Open;

    gTDebReal := RsDb.Fields[0].Value;
    Text5.Text := FormatVB(gTDebReal,'###,##0.00');
    end;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and Data_Debito = null ';
  // sSql = sSql & " and str(Data_Credito) = '" & gData1 & "'"
  sSql := sSql+' and (str(Data_Credito) = '#39''+gData1+''#39' or STR(Data_Credito) = '#39'' +
               FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
  sSql := sSql+' and Vl_CreditoDolar =  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  if  not RsDb.EOF then
    begin
    RsDb.Last;
    Text8.Text := IntToStr(RsDb.RecordCount);
    sSql := 'select sum( vl_creditoreal) from lancamentos where conta_contabil='#39'';
    sSql := sSql+Trim(Concil.ContaContabil)+''#39'';
    sSql := sSql+' and Data_Debito = null ';
    sSql := sSql+' and (str(Data_Credito) = '#39''+gData1+''#39' or STR(Data_Credito) = '#39'' +
                 FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
    sSql := sSql+' and Vl_CreditoDolar =  0';
    sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

    RsDb.Close;
    RsDb.CommandText := sSql;
    RsDb.Open;

    gTCredReal := RsDb.Fields[0].Value;
    Text7.Text := FormatVB(gTCredReal,'###,##0.00');
    end;

  // Valores em Dolar
  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  // sSql = sSql & " and str(Data_Debito) =  '" & gData1 & "'"
  sSql := sSql+' and (str(Data_Debito) = '#39''+gData1+''#39' or STR(Data_Debito) = '#39'' +
          FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
  sSql := sSql+' and Data_Credito =  null';
  sSql := sSql+' and Vl_DebitoDolar > 0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  if  not RsDb.EOF then
    begin
    RsDb.Last;
    Text1.Text := IntToStr(RsDb.RecordCount);
    sSql := 'select sum( vl_debitodolar) from lancamentos where conta_contabil='#39'';
    sSql := sSql+Trim(Concil.ContaContabil)+''#39'';
    // sSql = sSql & " and str(Data_Debito) =  '" & gData1 & "'"
    sSql := sSql+' and (str(Data_Debito) = '#39''+gData1+''#39' or STR(Data_Debito) = '#39'' +
                 FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
    sSql := sSql+' and Data_Credito =  null';
    sSql := sSql+' and Vl_DebitoDolar > 0';
    sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

    RsDb.Close;
    RsDb.CommandText := sSql;
    RsDb.Open;

//    Text2.Text := FormatVB(RsDb.Fields[0].Value,'###,##0.00');

    Text2.Text := FormatCurr('###,##0.00', RsDb.Fields[0].Value);
    end;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and Data_Debito = null ';
  // sSql = sSql & " and str(Data_Credito) = '" & gData1 & "'"
  sSql := sSql+' and (str(Data_Credito) = '#39''+gData1+''#39' or STR(Data_Credito) = '#39'' +
               FormatDateTime('YYYY/MM/DD',StrToDate(gData1)) + ''#39')';
  sSql := sSql+' and Vl_CreditoDolar >  0';
  sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  if  not RsDb.EOF then
    begin
    RsDb.Last;
    Text3.Text := IntToStr(RsDb.RecordCount);
    sSql := 'select sum( vl_creditodolar) from lancamentos where conta_contabil='#39'';
    sSql := sSql+Trim(Concil.ContaContabil)+''#39'';
    sSql := sSql+' and Data_Debito = null ';
    sSql := sSql+' and str(Data_Credito) = '#39''+gData1+''#39'';
    sSql := sSql+' and Vl_CreditoDolar >  0';
    sSql := sSql+' and right(cartao,8) <> '#39'99999999'#39'';

    RsDb.Close;
    RsDb.CommandText := sSql;
    RsDb.Open;

//    Text4.Text := FormatVB(RsDb.Fields[0].Value,'###,##0.00');
     Text4.Text := FormatCurr('###,##0.00', RsDb.Fields[0].Value);

    end;

  RsLocal.Close;
  RsLocal.Free;
  RsDb.Close;
  RsDb.Free;
   DbLocal.Close;
  cnAdoConect.Close;
   DbLocal.Free;
  cnAdoConect.Free;

  Self.Text1.Enabled := false;
  Self.Text2.Enabled := false;
  Self.Text3.Enabled := false;
  Self.Text4.Enabled := false;
  Self.Text5.Enabled := false;
  Self.Text6.Enabled := false;
  Self.Text7.Enabled := false;
  Self.Text8.Enabled := false;

  Screen.Cursor := crDefault;

end;

procedure TfrmAgenda1.GravaRel(Rs1: TADOTable; Rs2: TADODataSet);
begin
  // Gravar Relatório
  with Rs2 do
    begin
    Rs1.Insert;
    VBtoADOFieldSet(Rs1, 'Data_Debito', FieldByName('Data_Debito').Value);
    VBtoADOFieldSet(Rs1, 'Data_Credito', FieldByName('Data_Credito').Value);

    if Length(FieldByName('Data_Debito').Value)=0 then
      VBtoADOFieldSet(Rs1, 'Data_Ordem', FieldByName('Data_Credito').Value)
    else
      if Length(FieldByName('Data_Credito').Value)=0 then
        VBtoADOFieldSet(Rs1, 'Data_Ordem', FieldByName('Data_Debito').Value);

    if (Length(FieldByName('Data_Debito').AsString) <> 0) and (Length(FieldByName('Data_Credito').Value) <> 0) then
      if ((FieldByName('Data_Debito').Value) <= (FieldByName('Data_Credito').Value)) then
        // pega data menor
        VBtoADOFieldSet(Rs1, 'Data_Ordem', FieldByName('Data_Credito').Value);

//    if (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') then begin
    if (RightStr(Rs2.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(Rs2.FieldByName('Cartao').Value, 8)<>'99999999') then
      begin
      VBtoADOFieldSet(Rs1, 'Cartao', FieldByName('Cartao').Value);
      VBtoADOFieldSet(Rs1, 'Cartao1', FieldByName('Cartao1').Value);
      end
    else
      VBtoADOFieldSet(Rs1, 'Cartao', 'Variação Cambial');

    VBtoADOFieldSet(Rs1, 'Vl_DebitoDolar', FieldByName('Vl_DebitoDolar').Value);
    VBtoADOFieldSet(Rs1, 'Taxa_Debito', FieldByName('Taxa_Debito').Value);
    VBtoADOFieldSet(Rs1, 'Vl_CreditoDolar', FieldByName('Vl_CreditoDolar').Value);
    VBtoADOFieldSet(Rs1, 'Taxa_Credito', FieldByName('Taxa_Credito').Value);
    VBtoADOFieldSet(Rs1, 'Vl_DebitoReal', FieldByName('Vl_DebitoReal').Value);
    VBtoADOFieldSet(Rs1, 'Vl_CreditoReal', FieldByName('Vl_CreditoReal').Value);
    VBtoADOFieldSet(Rs1, 'Variacao', FieldByName('Variacao').Value);
    VBtoADOFieldSet(Rs1, 'Vl_Saldo', FieldByName('Vl_Saldo').Value);
    VBtoADOFieldSet(Rs1, 'Dias_Pendentes', FieldByName('Dias_Pendentes').Value);
    // Alterações visando a implementação da CONTABILIDADE
    // Rs1.Fields("Obs_Deb") = .Fields("Obs_Deb")
    // Rs1.Fields("Obs_Cred") = .Fields("Obs_Cred")

    Rs1.UpdateRecord;
  end;
end;

end.
