unit TipoCon_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, Windows, ADODB, Data.DB,
  Vcl.Grids, Vcl.DBGrids;


type
  TTipoCon = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Label4:  TLabel;
    Label5:  TLabel;
    Label13:  TLabel;
    Label12:  TLabel;
    Label6:  TLabel;
    Label7:  TLabel;
    Label8:  TLabel;
    Line1:  TShape;
    Label9:  TLabel;
    Label10:  TLabel;
    Label11:  TLabel;
    Label14:  TLabel;
    Label15:  TLabel;
    Label16:  TLabel;
    Text1:  TEdit;
    Text2:  TEdit;
    Command1:  TButton;
    Command2:  TButton;
    Text3:  TEdit;
    Text4:  TEdit;
    Text5:  TEdit;
    Text14:  TEdit;
    Text37:  TEdit;
    Text6:  TEdit;
    Frame1:  TGroupBox;
    Command3:  TButton;
    Command4:  TButton;
    Frame2:  TGroupBox;
    Command7:  TButton;
    Command8:  TButton;
    Text7:  TEdit;
    Check1:  TCheckBox;
    Check2:  TCheckBox;
    Text8:  TEdit;
    Text9:  TEdit;
    Text10:  TEdit;
    Text11:  TEdit;
    Text12:  TEdit;
    Text13:  TEdit;
    gBanco: TADOConnection;
    RsDb: TADOQuery;
    grdDebito: TDBGrid;
    grdCredito: TDBGrid;
    DataSourceDeb: TDataSource;
    DataSourceCred: TDataSource;

    procedure Check1Click(Sender: TObject);
    procedure Check2Click(Sender: TObject);
    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure Command4Click(Sender: TObject);
    procedure Command7Click(Sender: TObject);
    procedure Command3Click(Sender: TObject);
    procedure Command8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Text1Exit(Sender: TObject);
    procedure Text14Exit(Sender: TObject);
    procedure Text3Exit(Sender: TObject);
    procedure LimpaTela();
    procedure AtualizaGrid();
    procedure TrataErro();
    procedure Text8Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  cnAdoConect: TADOConnection;
  RsAdoDeb, RsAdoCred: TADODataSet;

    procedure Form_Unload(var Cancel: Smallint);
    //procedure grdCredito_LostFocus();
    //procedure grdDebito_LostFocus();
    //procedure RsAdoDeb_WillChangeRecord(adReason: ADODB.EventReasonEnum; cRecords: Longint; var adStatus: ADODB.EventStatusEnum; pRecordset: TADODataSet);
    //procedure RsAdoCred_WillChangeRecord(adReason: ADODB.EventReasonEnum; cRecords: Longint; var adStatus: ADODB.EventStatusEnum; pRecordset: TADODataSet);

  public
    { Public declarations }
  end;

var
  TipoCon: TTipoCon;

implementation

uses  Dialogs, SysUtils, Module1, RotGerais, VBto_Converter;

{$R *.dfm}

 //=========================================================
procedure TTipoCon.Check1Click(Sender: TObject);
begin
  if (Self.Check1.State=cbChecked) then begin
    if Self.Check2.State=cbChecked then begin
      Self.Check2.State := cbUnchecked;
    end;
  end;
end;

procedure TTipoCon.Check2Click(Sender: TObject);
begin
  if (Self.Check2.State=cbChecked) then begin
    if Self.Check1.State=cbChecked then begin
      Self.Check1.State := cbUnchecked;
    end;
  end;
end;
procedure TTipoCon.Command1Click(Sender: TObject);
var
  myDb: TAdoConnection;
begin
  sSql := 'select * from tb_grupocon where cd_grupo_con = '#39''+Text1.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.SQL.Add(sSql);
  RsDb.Open;

  if RsDb.EOF then begin
    Application.MessageBox('Grupo não está cadastrado...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text1.SetFocus();
    Exit;
  end;

//  myDb := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
  Conecta(myDb, ExtractFileDir(Application.ExeName) + '\admin.udl');

  if (AnsiUpperCase(Text14.Text)<>'D') and (AnsiUpperCase(Text14.Text)<>'C') then begin
    Application.MessageBox('Ordem de Atualização so pode ser D ou C ...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text14.SetFocus();
    Exit;
  end;

  if (AnsiUpperCase(Text14.Text)<>'D') and (AnsiUpperCase(Text14.Text)<>'C') then begin
    Application.MessageBox('Ordem de Atualização so pode ser D ou C ...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text14.SetFocus();
    Exit;
  end;

  sSql := 'select * from tb_tipo_con where cd_grupo_con = '#39''+Text1.Text+''#39'';
  sSql := sSql+' and conta_contabil = '#39''+TiraPontos(Text3.Text, IntToStr(1))+''#39'';
  sSql := sSql+' and cliente = '#39''+Text8.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.Close;
  RsDb.SQL.Add(sSql);
  RsDb.Open;

//  with RsDb do
  if RsDb.EOF then
    RsDb.Insert
  else
    RsDb.Edit;

  VBtoADOFieldSet(RsDb, 'cd_grupo_con', Text1.Text);
  VBtoADOFieldSet(RsDb, 'nm_grupo', Text2.Text);
  VBtoADOFieldSet(RsDb, 'conta_contabil', TiraPontos(Text3.Text, IntToStr(1)));
  VBtoADOFieldSet(RsDb, 'nm_conciliacao', Text37.Text);
  VBtoADOFieldSet(RsDb, 'cd_cli_banco', Text4.Text);
  VBtoADOFieldSet(RsDb, 'centro_custo', Text5.Text);
  VBtoADOFieldSet(RsDb, 'natureza_conta', AnsiUpperCase(Text14.Text));
  VBtoADOFieldSet(RsDb, 'Padrao_Conta', StrToInt(Text6.Text));
  VBtoADOFieldSet(RsDb, 'LimiteVariacao', StrToInt(Text7.Text));
  VBtoADOFieldSet(RsDb, 'cliente', Text8.Text);
  VBtoADOFieldSet(RsDb, 'Agendamento', AnsiUpperCase(Text9.Text));
  VBtoADOFieldSet(RsDb, 'AtualizaGeral', AnsiUpperCase(Text10.Text));
  VBtoADOFieldSet(RsDb, 'EliminaDuplicacao', AnsiUpperCase(Text11.Text));
  VBtoADOFieldSet(RsDb, 'LimpAuto', StrToInt(Text12.Text));
  VBtoADOFieldSet(RsDb, 'real', 0);
  VBtoADOFieldSet(RsDb, 'dolar', 0);
  if Self.Check1.State=cbChecked then
    VBtoADOFieldSet(RsDb, 'real', 1);

  if Self.Check2.State=cbChecked then
    VBtoADOFieldSet(RsDb, 'dolar', 1);

  VBtoADOFieldSet(RsDb, 'cd_cli_banco', '  ');
  RsDb.UpdateRecord;

  // Atualiza opções do menu

 // Desconecta();
  RsDb.UpdateBatch(arAll);
  RsDb.Close;
  gBanco.Close;

  if (gTipo_Rec=2) and (gCliente<>Text8.Text) then
//    gBanco := gWork.OpenDatabase(gAdmPath+'\'+Text8.Text+'\'+Text8.Text+'.mdb');
    Conecta(gBanco, gAdmPath+'\'+Text8.Text+'\'+Text8.Text+'.udl')
  else
//    if  not Conecta('') then
    if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
      Exit;

  sSql := 'select * from tb_opcao ';
  sSql := sSql+'where conta_contabil = '#39''+Text3.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.Close;
  RsDb.SQL.Add(sSql);
  RsDb.Open;

//  with RsDb do
  begin
  if RsDb.EOF then
    RsDb.Insert
  else
    RsDb.Edit;

  VBtoADOFieldSet(RsDb, 'grupo', Text1.Text);
  VBtoADOFieldSet(RsDb, 'opcao', Text37.Text);
  VBtoADOFieldSet(RsDb, 'cliente', Text8.Text);
  VBtoADOFieldSet(RsDb, 'conta_contabil', TiraPontos(Text3.Text, IntToStr(1)));

  if AnsiUpperCase(Text10.Text) = 'N' then
    VBtoADOFieldSet(RsDb, 'AtualizaGeral', 'NAO')
  else
    VBtoADOFieldSet(RsDb, 'AtualizaGeral', 'SIM');

    RsDb.UpdateRecord;
  end;

  gConciliacao := '';
  Concil.ContaContabil := '';
  BarraStatus();
  LimpaTela();
  Close();
end;

procedure TTipoCon.Command2Click(Sender: TObject);
begin
  Close;
end;

procedure TTipoCon.Command4Click(Sender: TObject);
label
  Erro;
begin
  try  // On Error GoTo Erro
    with RsAdoDeb do begin
      Delete;
      Next;
      if EOF then Last;
    end;
    Exit;
  except  // Erro:
    TrataErro;
//    Err.Clear();
  end;
end;

procedure TTipoCon.Command7Click(Sender: TObject);
label
  Erro;
begin
  try  // On Error GoTo Erro
    with RsAdoCred do begin
      Delete;
      Next;
      if EOF then Last;
    end;
    Exit;
  except  // Erro:
    ShowMessage('Erro na Exclusão');
//    Err.Clear();
  end;
end;

procedure TTipoCon.Command3Click(Sender: TObject);
label
  Erro;
begin
  try  // On Error GoTo Erro

    if  not RsAdoDeb.EOF then begin
      RsAdoDeb.Last;
      if RsAdoDeb.FieldByName('Codigo').AsString = '0' then begin
        ShowMessage('Digite os dados da conta.');
        Exit;
      end;
    end;
    RsAdoDeb.Insert;
    VBtoADOFieldSet(RsAdoDeb, 'conta_contabil', TiraPontos(Text3.Text, IntToStr(1)));
    VBtoADOFieldSet(RsAdoDeb, 'Natureza', 'D');
    VBtoADOFieldSet(RsAdoDeb, 'Codigo', '0');
    VBtoADOFieldSet(RsAdoDeb, 'Ref', '0');
//    Self.grdDebito.Columns(0).Visible := false;
//    Self.grdDebito.Columns(2).Visible := false;

//    Self.grdDebito.Col := 1;
    Self.grdDebito.SetFocus();
    Exit;
  except  // Erro:
    ShowMessage('Conta Duplicada');
//    Err.Clear();
  end;
end;

procedure TTipoCon.Command8Click(Sender: TObject);
label
  Erro;
begin
  try  // On Error GoTo Erro

    if  not RsAdoCred.EOF then begin
      RsAdoCred.Last;
      if RsAdoCred.FieldByName('Codigo').AsString = '0' then begin
        ShowMessage('Digite os dados da conta.');
        Exit;
      end;
    end;
    RsAdoCred.Insert;
    VBtoADOFieldSet(RsAdoCred, 'conta_contabil', TiraPontos(Text3.Text, IntToStr(1)));
    VBtoADOFieldSet(RsAdoCred, 'Natureza', 'C');
    VBtoADOFieldSet(RsAdoCred, 'Codigo', '0');
    VBtoADOFieldSet(RsAdoCred, 'Ref', '0');
//    Self.grdCredito.Columns(0).Visible := false;
//    Self.grdCredito.Columns(2).Visible := false;

//    Self.grdCredito.Col := 1;
    Self.grdCredito.SetFocus();
    Exit;
  except  // Erro:
    ShowMessage('Conta Duplicada   ');
//    Err.Clear();
  end;
end;
procedure TTipoCon.FormShow(Sender: TObject);
var
  strq: String;
begin
  // Me.Top = 0
  // Me.Height = 8220
  // Me.Width = 11715
  // Me.Left = (fMainForm.Width - Me.Width) / 2

//  if  not Conecta('adm') then
  If not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

//  strq := 'provider=Microsoft.Jet.OLEDB.3.51;data source='+String(gDataPath)+gDataFile;
  strq := gDataPath + gDataFile;
  cnAdoConect.CursorLocation := clUseClient;
//  VBtoADOConnection_Open(cnAdoConect, strq);
  Conecta(cnAdoConect, strq);

  RsAdoDeb := TADODataSet.Create(nil);
  RsAdoCred := TADODataSet.Create(nil);

  if gTipo_Rec<>1 then
    begin
    sSql := 'select * from tb_tipo_con ';
    sSql := sSql+'where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(1))+''#39'';
    sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
  //  RsDb := gBanco.OpenRecordset(sSql);
    RsDb.Close;
    RsDb.SQL.Add(sSql);
    RsDb.Open;

//    with RsDb do
    begin
    if RsDb.EOF then
      Application.MessageBox('Conta Contábil não está cadastrada...', 'Tipo de Conciliação', MB_ICONSTOP)
    else
      begin
      Self.Text1.Text := RsDb.FieldByName('cd_grupo_con').Value;
      Self.Text2.Text := RsDb.FieldByName('nm_grupo').Value;
      Self.Text3.Text := RsDb.FieldByName('conta_contabil').Value;
      Self.Text4.Text := RsDb.FieldByName('cd_cli_banco').Value;
      Self.Text5.Text := RsDb.FieldByName('centro_custo').Value;
      Self.Text6.Text := RsDb.FieldByName('padrao_conta').Value;
      Self.Text7.Text := RsDb.FieldByName('LimiteVariacao').Value;
      Self.Text9.Text := RsDb.FieldByName('Agendamento').Value;
      Self.Text10.Text := RsDb.FieldByName('AtualizaGeral').Value;
      Self.Text11.Text := RsDb.FieldByName('EliminaDuplicacao').Value;
      Self.Text12.Text := RsDb.FieldByName('LimpAuto').Value;
      Self.Text14.Text := RsDb.FieldByName('natureza_conta').Value;
      Self.Text37.Text := RsDb.FieldByName('nm_conciliacao').Value;
        // Me.Text38.Text = .Fields("Arq_Entrada")
      Self.Text8.Text := RsDb.FieldByName('Cliente').Value;
      Self.Text1.Enabled := false;
      Self.Text3.Enabled := false;

      if RsDb.FieldByName('real').AsInteger = 1 then
        Self.Check1.State := cbChecked;

      if RsDb.FieldByName('dolar').AsInteger = 1 then
        Self.Check2.State := cbChecked;
      AtualizaGrid;
      end;
    end;
    Self.Text8.Enabled := false;
    end
  else
    begin
    if Length(Trim(gCliente))<>0 then begin
      Self.Text8.Text := gCliente;
    end;
    Self.Text8.Enabled := true;
    AtualizaGrid;
  end;
  Screen.Cursor := crDefault;
end;

procedure TTipoCon.Form_Unload(var Cancel: Smallint);
begin
   {? On Error Resume Next  }
  Self.grdCredito.DataSource.Free;
  Self.grdDebito.DataSource.Free;
  RsAdoDeb.Free;
  RsAdoCred.Free;
  cnAdoConect.Close;
  cnAdoConect.Free;

  //Desconecta();
  RsDb.Close;
  gBanco.Close;
end;

procedure TTipoCon.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

procedure TTipoCon.Text1Exit(Sender: TObject);
begin
  if Length(Text1.Text)=0 then begin
    Exit;
  end;
  sSql := 'select * from tb_grupocon where cd_grupo_con = '#39''+Text1.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.SQL.Add(sSql);
  RsDb.Open;

  if RsDb.EOF then begin
    Application.MessageBox('Grupo não está cadastrado...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text1.SetFocus();
    Exit;
  end;
  Text2.Text := RsDb.FieldByName('nm_grupo').Value;

  if Length(Text3.Text)=0 then Text3.Text := Text1.Text;
end;

procedure TTipoCon.Text14Exit(Sender: TObject);
begin
  if Length(Text14.Text)>0 then begin
    if (AnsiUpperCase(Text14.Text)<>'D') and (AnsiUpperCase(Text14.Text)<>'C') then begin
      Application.MessageBox('Ordem de Atualização so pode ser D ou C ...', 'Tipo de Conciliação', MB_ICONSTOP);
      Text14.SetFocus();
    end;
  end;
end;

procedure TTipoCon.Text3Exit(Sender: TObject);
begin

  if Copy(Text3.Text, 1, 2)<>Trim(Text1.Text) then begin
    ShowMessage('Conta não pertence a este grupo!');
    Text3.SetFocus();
    Exit;
  end;
  Text3.Enabled := false;
  Text1.Enabled := false;
  AtualizaGrid();
end;
//{$DEFINE defUse_RsAdoDeb_WillChangeRecord}
{$IF Defined(defUse_RsAdoDeb_WillChangeRecord)}
// VBto upgrade warning: adStatus As ADODB.EventStatusEnum  OnWrite(ADODB.EventStatusEnum)
procedure TTipoCon.RsAdoDeb_WillChangeRecord(adReason: ADODB.EventReasonEnum; cRecords: Longint; var adStatus: ADODB.EventStatusEnum; pRecordset: TADODataSet);
var
  bCancel: Boolean;
begin
  bCancel := false;

  // This is where you put validation code
  // This event gets called when the following actions occur
  
  if adReason=adRsnAddNew then begin
  end
  else if adReason=adRsnClose then begin
  end
  else if adReason=adRsnDelete then begin
  end
  else if adReason=adRsnFirstChange then begin
  end
  else if adReason=adRsnMove then begin
  end
  else if adReason=adRsnRequery then begin
  end
  else if adReason=adRsnResynch then begin
  end
  else if adReason=adRsnUndoAddNew then begin
  end
  else if adReason=adRsnUndoDelete then begin
  end
  else if adReason=adRsnUndoUpdate then begin
  end
  else if adReason=adRsnUpdate then begin
  end;

  if bCancel then adStatus := adStatusCancel;
end;
{$IFEND} // defUse_RsAdoDeb_WillChangeRecord
//{$DEFINE defUse_RsAdoCred_WillChangeRecord}
{$IF Defined(defUse_RsAdoCred_WillChangeRecord)}
// VBto upgrade warning: adStatus As ADODB.EventStatusEnum  OnWrite(ADODB.EventStatusEnum)
procedure TTipoCon.RsAdoCred_WillChangeRecord(adReason: ADODB.EventReasonEnum; cRecords: Longint; var adStatus: ADODB.EventStatusEnum; pRecordset: TADODataSet);
var
  bCancel: Boolean;
begin
  bCancel := false;

  // This is where you put validation code
  // This event gets called when the following actions occur
  
  if adReason=adRsnAddNew then begin
  end
  else if adReason=adRsnClose then begin
  end
  else if adReason=adRsnDelete then begin
  end
  else if adReason=adRsnFirstChange then begin
  end
  else if adReason=adRsnMove then begin
  end
  else if adReason=adRsnRequery then begin
  end
  else if adReason=adRsnResynch then begin
  end
  else if adReason=adRsnUndoAddNew then begin
  end
  else if adReason=adRsnUndoDelete then begin
  end
  else if adReason=adRsnUndoUpdate then begin
  end
  else if adReason=adRsnUpdate then begin
  end;

  if bCancel then adStatus := adStatusCancel;
end;
{$IFEND} // defUse_RsAdoCred_WillChangeRecord
procedure TTipoCon.LimpaTela();
begin
  Text1.Text := '';
  Text2.Text := '';
  Text3.Text := '';
  Text37.Text := '';
  Text4.Text := '';
  Text5.Text := '';
  Text14.Text := '';
  Text6.Text := '';
  Text7.Text := '';
  Text8.Text := '';
  Check1.State := cbUnchecked;
  Check2.State := cbUnchecked;
  AtualizaGrid();
end;
procedure TTipoCon.AtualizaGrid();
label
  Erro;
begin

  try  // On Error GoTo Erro
    sSql := 'select * from tbcontas ';
    if Length(Text3.Text)>0 then begin
      sSql := sSql+'where conta_contabil = '#39''+TiraPontos(Text3.Text, IntToStr(1))+''#39'';
      sSql := sSql+' and Natureza  = '#39'D'#39' order by codigo';
     end  else  begin
      sSql := sSql+'where conta_contabil = '#39'999999'#39'';
    end;
    RsAdoDeb.Close;
//    VBtoADODataSet_Open(RsAdoDeb, sSql, cnAdoConect, ctKeyset, ltOptimistic);
    RsAdoDeb.Connection := cnAdoConect;
    RsAdoDeb.CommandText := sSql;
    RsAdoDeb.Open;

//    Self.grdDebito.DataSource := RsAdoDeb;   Fiz em design mode
    DatasourceDeb.DataSet := RsAdoDeb;

    sSql := 'select * from tbcontas ';
    if Length(Text3.Text) > 0 then
      begin
      sSql := sSql+'where conta_contabil = '#39''+TiraPontos(Text3.Text, IntToStr(1))+''#39'';
      sSql := sSql+' and Natureza  = '#39'C'#39' order by codigo,Ref';
      end
    else
      sSql := sSql+'where conta_contabil = '#39'999999'#39'';

    RsAdoCred.Close;
//    VBtoADODataSet_Open(RsAdoCred, sSql, cnAdoConect, ctKeyset, ltOptimistic);
    RsAdoCred.Connection := cnAdoConect;
    RsAdoCred.CommandText := sSql;
    RsAdoCred.Open;

//    Self.grdCredito.DataSource := RsAdoCred;
    DatasourceCred.DataSet := RsAdoCred;

 {   Self.grdCredito.Columns(0).Visible := false;
    Self.grdCredito.Columns(2).Visible := false;
    Self.grdCredito.Columns(6).Visible := false;

    Self.grdDebito.Columns(0).Visible := false;
    Self.grdDebito.Columns(2).Visible := false;
    Self.grdDebito.Columns(6).Visible := false;

    Self.grdDebito.Columns(1).Width := 700;
    Self.grdCredito.Columns(1).Width := 700;
    Self.grdDebito.Columns(3).Width := 700;
    Self.grdCredito.Columns(3).Width := 700;

    Self.grdCredito.Columns(4).Width := 700;
    Self.grdCredito.Columns(5).Width := 700;
    Self.grdCredito.Columns(7).Width := 1700;
    Self.grdCredito.Columns(8).Width := 1700;
    Self.grdCredito.Columns(9).Width := 4000;
    Self.grdCredito.Columns(10).Width := 500;

    Self.grdDebito.Columns(4).Width := 700;
    Self.grdDebito.Columns(5).Width := 700;
    Self.grdDebito.Columns(7).Width := 1700;
    Self.grdDebito.Columns(8).Width := 1700;
    Self.grdDebito.Columns(9).Width := 4000;
    Self.grdDebito.Columns(10).Width := 500;

    Self.grdCredito.Columns(9).Caption := 'Descrição da Transação';
    Self.grdDebito.Columns(9).Caption := 'Descrição da Transação';     }
    Exit;
  except  // Erro:
 //   Err.Clear();
    { Resume Next }
  end;
end;
procedure TTipoCon.TrataErro();
begin
  if  not RsAdoDeb.EOF then begin
    if sizeof(RsAdoDeb.FieldByName('Codigo').Value)=0 then begin
      Application.MessageBox('Digite o número da conta...', 'Tipo de Conciliação', MB_ICONSTOP);
    end;
    if sizeof(RsAdoDeb.FieldByName('Ref').Value)=0 then begin
      Application.MessageBox('Digite a Referência 1...', 'Tipo de Conciliação', MB_ICONSTOP);
    end;
  end;
end;
procedure TTipoCon.Text8Exit(Sender: TObject);
begin
  // Verifica se o cliente está cadastrado
  if Length(Text8.Text)=0 then begin
    Exit;
  end;
  sSql := 'select * from clientes where nome_reduzido = '#39''+Text8.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.SQL.Add(sSql);

  if RsDb.EOF then begin
    Application.MessageBox('Cliente não está cadastrado...', 'Tipo de Conciliação', MB_ICONSTOP);
    // Text8.SetFocus
    Exit;
  end;
  Text8.Enabled := false;
end;



procedure TTipoCon.FormCreate(Sender: TObject);
begin
  cnAdoConect := TADOConnection.Create(nil);
end;

end.
