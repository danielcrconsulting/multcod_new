unit TipoConAdm_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, Windows, ADODB, Vcl.Grids,
  Vcl.DBGrids, Data.DB, Vcl.DBCtrls, Winapi.Messages;


type
  TTipoConAdm = class(TForm)
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
    Label14:  TLabel;
    Label15:  TLabel;
    Label16:  TLabel;
    Label17:  TLabel;
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
    Text8:  TEdit;
    Text9:  TEdit;
    Text10:  TEdit;
    Text11:  TEdit;
    Text12:  TEdit;
    Text13:  TEdit;
    txtHistorico:  TEdit;
    grdDebito: TDBGrid;
    grdCredito: TDBGrid;
    bancoAdm: TADOConnection;
    bancoCli: TADOConnection;
    RsDb: TADOQuery;
    AdoTable: TADOTable;
    Forçar: TGroupBox;
    RadioButtonReal: TRadioButton;
    RadioButtonDolar: TRadioButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ComboBox1: TComboBox;
    ADODataSet1: TADODataSet;
    ADODataSet2: TADODataSet;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure Command7Click(Sender: TObject);
    procedure Command3Click(Sender: TObject);
    procedure Command8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Text14Exit(Sender: TObject);
    procedure Text3Exit(Sender: TObject);
    //procedure Junta_Interface(Op: String);
    procedure LimpaTela;
    procedure AtualizaGrid;
    procedure TrataErro;
    procedure Text8Exit(Sender: TObject);
    procedure Text13Exit(Sender: TObject);
    procedure Text10Exit(Sender: TObject);
    procedure Text9Exit(Sender: TObject);
    procedure Text11Exit(Sender: TObject);
    procedure Text14KeyPress(Sender: TObject; var Key: Char);
    procedure Text13KeyPress(Sender: TObject; var Key: Char);
    procedure Text9KeyPress(Sender: TObject; var Key: Char);
    procedure Text10KeyPress(Sender: TObject; var Key: Char);
    procedure Text11KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Exit(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    RsAdoDeb, RsAdoCred: TADOQuery;

    procedure Form_Unload(var Cancel: Smallint);

  public
    { Public declarations }
  end;

var
  TipoConAdm: TTipoConAdm;

implementation

uses  Dialogs, SysUtils, Module1, RotGerais, VBto_Converter;

{$R *.dfm}

procedure TTipoConAdm.ComboBox1Exit(Sender: TObject);
Var
  sSql : String;
begin

if Self.Command2.Focused then
  Exit;

  if Length(ComboBox1.Text)=0 then
    begin
    Beep;
    ShowMessage('Escolha um Grupo');
    ActiveControl := nil;
    PostMessage(Self.ComboBox1.Handle, WM_SETFOCUS, 0, 0);
    Self.ComboBox1.SetFocus;
    Exit;
    end;

  sSql := 'select * from tb_grupocon where cd_grupo_con = '#39''+ComboBox1.Text+''#39'';

  RsDb.Close;
  RsDb.Sql.Text := (sSql);
  RsDb.Open;

  if RsDb.EOF then
    begin
    Application.MessageBox('Grupo não está cadastrado...', 'Tipo de Conciliação', MB_ICONSTOP);
    ComboBox1.Text := '';
    ComboBox1.SetFocus;
    Exit;
    end;

  Text2.Text := RsDb.FieldByName('nm_grupo').Value;

  if Length(Text3.Text) = 0 then
    Text3.Text := ComboBox1.Text;
end;

procedure TTipoConAdm.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
key:=#0;
end;

procedure TTipoConAdm.Command1Click(Sender: TObject);
var
  sSql : String;
begin

  AdoTable.Connection := bancoAdm;
  Conecta(bancoAdm, ExtractFileDir(Application.ExeName) + '\admin.udl');

  RsDb.SQL.Text := ('select * from tb_grupocon where cd_grupo_con = '#39''+ComboBox1.Text+''#39'');
  RsDb.Open;

  if RsDb.EOF then
    begin
    RsDb.Close;
    Application.MessageBox('Grupo não está cadastrado...', 'Tipo de Conciliação', MB_ICONSTOP);
    ComboBox1.SetFocus;
    Exit;
    end;

  RsDb.Close;

  if (AnsiUpperCase(Text14.Text)<>'D') and (AnsiUpperCase(Text14.Text)<>'C') then
    begin
    Application.MessageBox('Natureza da Conta só pode ser D ou C ...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text14.SetFocus;
    Exit;
    end;

  if (AnsiUpperCase(Text9.Text)<>'S') and (AnsiUpperCase(Text9.Text)<>'N') then
    begin
    Application.MessageBox('Agendamento so pode ser S ou N ...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text9.SetFocus;
    Exit;
    end;

  if (AnsiUpperCase(Text10.Text)<>'S') and (AnsiUpperCase(Text10.Text)<>'N') then
    begin
    Application.MessageBox('Atualização Geral so pode ser S ou N ...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text10.SetFocus;
    Exit;
    end;

  if (AnsiUpperCase(Text13.Text)<>'S') and (AnsiUpperCase(Text13.Text)<>'N') then
    begin
    Application.MessageBox('Excel so pode ser S ou N ...', 'Tipo de Conciliação', MB_ICONSTOP);
    Text13.SetFocus;
    Exit;
    end;

//  sSql := 'select * from tb_tipo_con where cd_grupo_con = '#39''+Text1.Text+''#39'';
  sSql := 'cd_grupo_con = '#39''+ComboBox1.Text+''#39'';
  sSql := sSql+' and conta_contabil = '#39''+TiraPontos(Text3.Text, IntToStr(1))+''#39'';
  sSql := sSql+' and cliente = '#39''+Text8.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  AdoTable.TAbleName := 'tb_tipo_con';
  AdoTable.Filter := sSql;
  AdoTable.Open;

//  with RsDb do begin
  if AdoTable.EOF then
    AdoTable.Insert
  else
    AdoTable.Edit;

  AdoTable.FieldByName('cd_grupo_con').AsString := ComboBox1.Text;
  AdoTable.FieldByName('nm_grupo').AsString := Text2.Text;
  AdoTable.FieldByName('conta_contabil').AsString := TiraPontos(Text3.Text, '1');
  AdoTable.FieldByName('nm_conciliacao').AsString := Text37.Text;
  AdoTable.FieldByName('cd_cli_banco').AsString := Text4.Text;
  AdoTable.FieldByName('centro_custo').AsString := Text5.Text;
  AdoTable.FieldByName('natureza_conta').AsString := Text14.Text;
  AdoTable.FieldByName('Padrao_Conta').AsString := Text6.Text;
  AdoTable.FieldByName('LimiteVariacao').AsString := Text7.Text;
  AdoTable.FieldByName('cliente').AsString := Text8.Text;
  AdoTable.FieldByName('Agendamento').AsString := Text9.Text;
  AdoTable.FieldByName('AtualizaGeral').AsString := Text10.Text;
  if Length(Text11.Text)=0 then
    Text11.Text := 'N';
  AdoTable.FieldByName('EliminaDuplicacao').AsString := Text11.Text;

  AdoTable.FieldByName('LimpAuto').AsString := Text12.Text;
  AdoTable.FieldByName('excel').AsString := Text13.Text;

  AdoTable.FieldByName('real').AsString := '0';
  AdoTable.FieldByName('dolar').AsString := '0';

  if RadioButtonReal.Checked then
    AdoTable.FieldByName('real').AsString := '1'
  else
    AdoTable.FieldByName('dolar').AsString := '1';

//    if sizeof(FieldByName('cd_cli_banco').Value)=0 then VBtoADOFieldSet(RsDb, 'cd_cli_banco', '  ');
  if AdoTable.FieldByName('cd_cli_banco').AsString = '' then
    AdoTable.FieldByName('cd_cli_banco').AsString := '  ';

  AdoTable.Post;

  // Atualiza opções do menu

  AdoTable.Close;
  bancoAdm.Close;

  if (gTipo_Rec=2) and (gCliente <> Text8.Text) then
//    gBanco := gWork.OpenDatabase(gAdmPath+'\'+Text8.Text+'\'+Text8.Text+'.mdb');
    Conecta(bancoCli, gAdmPath+'\'+Text8.Text+'\'+Text8.Text+'.udl')
  else
//    if  not Conecta('') then Exit;
    if  not Conecta(bancoCli, gDataPath + gDataFile + '.udl') then
      Exit;

//  sSql := 'select * from tb_opcao ';
//  sSql := sSql+'where conta_contabil = '#39''+Text3.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);

  AdoTable.Connection := bancoCli;
  AdoTable.Filter := 'conta_contabil = '#39''+Text3.Text+''#39'';
  AdoTable.Open;

  if AdoTable.EOF then
    AdoTable.Insert
  else
    AdoTable.Edit;

  AdoTable.FieldByName('grupo').AsString := ComboBox1.Text;
  AdoTable.FieldByName('opcao').AsString := Text37.Text;
  AdoTable.FieldByName('cliente').AsString := Text8.Text;
  AdoTable.FieldByName('conta_contabil').AsString := TiraPontos(Text3.Text, '1');

  if Text10.Text = 'N' then
    AdoTable.FieldByName('AtualizaGeral').AsString := 'NAO'
  else
    AdoTable.FieldByName('AtualizaGeral').AsString := 'SIM';

  AdoTable.Post;

  AdoTable.Close;

  gConciliacao := '';
  Concil.ContaContabil := '';
  Concil.ContaEmissor := '';
  BarraStatus;
  LimpaTela;
  Close;
end;

procedure TTipoConAdm.Command2Click(Sender: TObject);
begin
  Close;
end;

procedure TTipoConAdm.Command7Click(Sender: TObject);
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

procedure TTipoConAdm.Command3Click(Sender: TObject);
begin

    RsAdoDeb.FieldByName('conta_contabil').AsString := TiraPontos(Text3.Text, '1');
    RsAdoDeb.FieldByName('Natureza').AsString := 'D';
    RsAdoDeb.FieldByName('Codigo').AsString := '0';
    RsAdoDeb.FieldByName('Ref').AsString := '0';

end;

procedure TTipoConAdm.Command8Click(Sender: TObject);
label
  Erro;
begin
  try  // On Error GoTo Erro

    if  not RsAdoCred.EOF then
      begin
      RsAdoCred.Last;
      if RsAdoCred.FieldByName('Codigo').AsString = '0' then
        begin
        ShowMessage('Digite os dados da conta.');
        Exit;
        end;
      end;

    RsAdoCred.Insert;
     RsAdoDeb.FieldByName('conta_contabil').AsString := TiraPontos(Text3.Text, '1');
    RsAdoDeb.FieldByName('Natureza').AsString := 'C';
    RsAdoDeb.FieldByName('Codigo').AsString := '0';
    RsAdoDeb.FieldByName('Ref').AsString := '0';

//    Self.grdCredito.Columns(0).Visible := false;
//    Self.grdCredito.Columns(2).Visible := false;
//    Self.grdCredito.Col := 1;

    AtualizaGrid;
    Self.grdCredito.SetFocus;
    Exit;
  except  // Erro:
//    if Err.Number=-231 then { Resume Next }
//    if Err.Number=-123 then { Resume Next }
    ShowMessage('Conta Duplicada   ');
//    Err.Clear();
  end;
end;

procedure TTipoConAdm.FormShow(Sender: TObject);
var
  sSql : String;
begin
//  if  not Conecta('adm') then
  if  not Conecta(bancoAdm, gAdmPath+'\ADMIN.udl') then
    Exit;

//  strq := 'provider=Microsoft.Jet.OLEDB.3.51;data source='+String(gDataPath)+gDataFile;
//  strq := 'provider=Microsoft.Jet.OLEDB.3.51;data source='+gAdmPath+'\ADMIN.MDB';
//  cnAdoConectAdm.CursorLocation := clUseClient;
//  VBtoADOConnection_Open(cnAdoConectAdm, strq);
//  Conecta(cnAdoConectAdm, gAdmPath+'\ADMIN.udl');

  sSql := 'select * from [tbContasAdm] ';
  sSql := sSql+'where Natureza = ''D''';
  sSql := sSql+' and Nome_Cliente = '#39''+gCliente+''#39'';
  sSql := sSql+' ORDER BY Conta_Contabil ';
  AdoDataSet1.CommandText := sSql;
  AdoDataSet1.Open;

  sSql := 'select * from [tbContasAdm] ';
  sSql := sSql+'where Natureza = ''C''';
  sSql := sSql+' and Nome_Cliente = '#39''+gCliente+''#39'';
  sSql := sSql+' ORDER BY Conta_Contabil ';
  AdoDataSet2.CommandText := sSql;
  AdoDataSet2.Open;

  RsAdoDeb := TADOQuery.Create(nil);
  RsAdoCred := TADOQuery.Create(nil);

  RsAdoDeb.Connection := bancoAdm;
  RsAdoCred.Connection := bancoAdm;

  if gTipo_Rec <> 1 then
    begin
    sSql := 'select * from tb_tipo_con ';
    sSql := sSql+'where conta_contabil = '#39''+TiraPontos(gOpcao, '1')+''#39'';
    sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);

    RsDb.Close;
    RsDb.Sql.Text := (sSql);
    RsDb.Open;

  with RsDb do
    begin
    if RsDb.EOF then
        Application.MessageBox('Conta Contábil não está cadastrada...', 'Tipo de Conciliação', MB_ICONSTOP)
    else
      begin
//      Self.Text1.Text := FieldByName('cd_grupo_con').Value;
      Self.Text2.Text := FieldByName('nm_grupo').Value;
      Self.Text3.Text := FieldByName('conta_contabil').Value;
      Self.Text4.Text := FieldByName('cd_cli_banco').Value;
      Self.Text5.Text := FieldByName('centro_custo').Value;
      Self.Text6.Text := FieldByName('padrao_conta').Value;
      Self.Text7.Text := FieldByName('LimiteVariacao').Value;
      Self.Text9.Text := FieldByName('Agendamento').Value;
      Self.Text10.Text := FieldByName('AtualizaGeral').Value;
      Self.Text11.Text := FieldByName('EliminaDuplicacao').Value;
      Self.Text12.Text := FieldByName('LimpAuto').Value;
      Self.Text13.Text := FieldByName('Excel').Value;
        // Me.txtHistorico = .Fields("Historico")
      Self.Text14.Text := FieldByName('natureza_conta').Value;
      Self.Text37.Text := FieldByName('nm_conciliacao').Value;
        // Me.Text38.Text = .Fields("Arq_Entrada")
      Self.Text8.Text := FieldByName('Cliente').Value;

//      Self.ComboBox1.Enabled := false;
//      Self.Text3.Enabled := false;

      if FieldByName('real').AsInteger = 1 then
        RadioButtonReal.Checked := True
      else
        if FieldByName('dolar').AsInteger  =1 then
          RadioButtonDolar.Checked := True;

        AtualizaGrid;
      end;
    end;

//    Self.Text8.Enabled := false;
    end
  else
    if Length(Trim(gCliente)) <> 0 then
      Self.Text8.Text := gCliente;

//  Self.Text8.Enabled := true;
//  Self.Text3.Enabled := true;
//  Self.ComboBox1.Enabled := True;

  AtualizaGrid;

  Self.Text8.SetFocus;

  Screen.Cursor := crDefault;

end;

procedure TTipoConAdm.Form_Unload(var Cancel: Smallint);
begin
RsAdoDeb.Close;
RsAdoCred.Close;
RsAdoDeb.Free;
RsAdoCred.Free;
BancoAdm.Close;
BancoCli.Close;
end;

procedure TTipoConAdm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
Cancel := 0;

Form_Unload(Cancel);
If Cancel<>0 Then
  CanClose := false;
end;

procedure TTipoConAdm.Text10Exit(Sender: TObject);
begin
if ((Text10.Text) <> 'S') and ((Text10.Text) <> 'N') then
  begin
  Application.MessageBox('Atualização Geral só pode ser S ou N ...', 'Tipo de Conciliação', MB_ICONSTOP);
  Text10.SetFocus;
  end;
end;

procedure TTipoConAdm.Text10KeyPress(Sender: TObject; var Key: Char);
begin
if not CharInSet(key, [#08, 'S', 'N', 's', 'n']) then
  begin
  Beep;
  key := #0;
  end;
end;

procedure TTipoConAdm.Text11Exit(Sender: TObject);
begin
  if Length(Text11.Text) > 0 then
    begin
    if ((Text11.Text) <> 'S') and ((Text11.Text) <> 'N') then
      begin
      Application.MessageBox('Eliminar Duplicado só pode ser S ou N ...', 'Tipo de Conciliação', MB_ICONSTOP);
      Text11.SetFocus;
      end;
  end;
end;

procedure TTipoConAdm.Text11KeyPress(Sender: TObject; var Key: Char);
begin
if not CharInSet(key, [#08, 'S', 'N', 's', 'n']) then
  begin
  Beep;
  key := #0;
  end;
end;

procedure TTipoConAdm.Text13Exit(Sender: TObject);
begin
if ((Text13.Text) <> 'S') and ((Text13.Text) <> 'N') then
  begin
  Application.MessageBox('Gerar Excel só pode ser S ou N ...', 'Tipo de Conciliação', MB_ICONSTOP);
  Text13.SetFocus;
  end;
end;

procedure TTipoConAdm.Text13KeyPress(Sender: TObject; var Key: Char);
begin
if not CharInSet(key, [#08, 'S', 'N', 's', 'n']) then
  begin
  Beep;
  key := #0;
  end;
end;

procedure TTipoConAdm.Text14Exit(Sender: TObject);
begin
if ((Text14.Text) <> 'D') and ((Text14.Text) <> 'C') then
  begin
  Application.MessageBox('Natureza da Conta só pode ser D ou C ...', 'Tipo de Conciliação', MB_ICONSTOP);
  Text14.SetFocus;
  end;
end;

procedure TTipoConAdm.Text14KeyPress(Sender: TObject; var Key: Char);
begin
if not CharInSet(key, [#08, 'C', 'D', 'c', 'd']) then
  begin
  Beep;
  key := #0;
  end;
end;

procedure TTipoConAdm.Text3Exit(Sender: TObject);
begin
  if Copy(Text3.Text, 1, Length(ComboBox1.Text)) <> ComboBox1.Text then
    begin
    ShowMessage('Conta não pertence a este grupo!');
    Text3.SetFocus;
    Exit;
    end;
//  Text3.Enabled := false;
//  ComboBox1.Enabled := false;
  AtualizaGrid;
end;

procedure TTipoConAdm.LimpaTela;
begin
  ComboBox1.Text := '';
  Text2.Text := '';
  Text3.Text := '';
  Text37.Text := '';
  Text4.Text := '';
  Text5.Text := '';
  Text14.Text := '';
  Text6.Text := '';
  Text7.Text := '';
  Text8.Text := '';
  RadioButtonReal.Checked := True;
  AtualizaGrid;
end;

procedure TTipoConAdm.AtualizaGrid;
Var
  sSql : String;
begin

Exit;

  try  // On Error GoTo Erro
    sSql := 'select * from tbContasAdm ';
    if Length(Text3.Text)>0 then
      begin
      sSql := sSql + 'Where conta_contabil = '#39''+TiraPontos(Text3.Text, IntToStr(1))+''#39'';
      sSql := sSql + ' and Natureza  = '#39'D'#39'';
      end
    else
      sSql := sSql + 'Where conta_contabil = '#39'999999'#39'';

    // sSql = sSql & " and Bandeira ='" & Trim(gBandeira) & "' order by codigo"
    sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
//    sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';
    sSql := sSql+' or Bandeira = '#39'VISA-MC'#39')';

    RsAdoDeb.Close;
    RsAdoDeb.Sql.Text := (sSql);
//    VBtoADODataSet_Open(RsAdoDeb, sSql, cnAdoConectAdm, ctKeyset, ltOptimistic);
    RsAdoDeb.Open;

//    Self.grdDebito.DataSource := RsAdoDeb;
    DataSource1.DataSet := RsAdoDeb;

    sSql := 'select * from tbContasAdm ';
    if Length(Text3.Text) > 0 then
      begin
      sSql := sSql+'where conta_contabil = '#39''+TiraPontos(Text3.Text, IntToStr(1))+''#39'';
      sSql := sSql+' and Natureza  = '#39'C'#39'';
      end
    else
      sSql := sSql+'where conta_contabil = '#39'999999'#39'';

    // sSql = sSql & " and Bandeira ='" & Trim(gBandeira) & "'  order by codigo,Ref"
    sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
    sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';

    RsAdoCred.Close;
    RsAdoCred.Sql.Text := (sSql);
//    VBtoADODataSet_Open(RsAdoCred, sSql, cnAdoConectAdm, ctKeyset, ltOptimistic);
    RsAdoCred.Open;

    //Self.grdCredito.DataSource := RsAdoCred;
    DataSource2.DataSet := RsAdoCred;

    {Self.grdCredito.Columns(0).Visible := false; // CLIENTE
    Self.grdCredito.Columns(1).Visible := false; // CONTA CONTABIL
    Self.grdCredito.Columns(4).Visible := false; // NATUREZA
    // Me.grdCredito.Columns(13).Visible = False
    Self.grdCredito.Columns(14).Visible := false;
    Self.grdCredito.Columns(15).Visible := false;
    Self.grdCredito.Columns(16).Visible := false;
    Self.grdDebito.Columns(0).Visible := false;
    Self.grdDebito.Columns(1).Visible := false;
    Self.grdDebito.Columns(4).Visible := false;
    // Me.grdCredito.Columns(13).Visible = False
    Self.grdCredito.Columns(14).Visible := false;
    Self.grdCredito.Columns(15).Visible := false;
    Self.grdCredito.Columns(16).Visible := false;
    Self.grdDebito.Columns(14).Width := 0;
    Self.grdDebito.Columns(15).Width := 0;
    Self.grdDebito.Columns(16).Width := 0;
    Self.grdCredito.Columns(14).Width := 0;
    Self.grdCredito.Columns(15).Width := 0;
    Self.grdCredito.Columns(16).Width := 0;
    Self.grdDebito.Columns(1).Width := 2000;
    Self.grdCredito.Columns(1).Width := 2000;
    Self.grdDebito.Columns(2).Width := 2000;
    Self.grdCredito.Columns(2).Width := 2000;
    Self.grdDebito.Columns(4).Width := 500;
    Self.grdCredito.Columns(4).Width := 500;
    Self.grdCredito.Columns(5).Width := 800;
    Self.grdCredito.Columns(6).Width := 800;
    Self.grdCredito.Columns(7).Width := 800;
    Self.grdCredito.Columns(8).Width := 800;
    Self.grdCredito.Columns(9).Width := 1200;
    Self.grdCredito.Columns(10).Width := 1700;
    Self.grdCredito.Columns(11).Width := 4000;
    Self.grdCredito.Columns(12).Width := 500;
    Self.grdCredito.Columns(13).Width := 500;
    Self.grdDebito.Columns(5).Width := 800;
    Self.grdDebito.Columns(6).Width := 800;
    Self.grdDebito.Columns(7).Width := 800;
    Self.grdDebito.Columns(8).Width := 800;
    Self.grdDebito.Columns(9).Width := 1200;
    Self.grdDebito.Columns(10).Width := 1700;
    Self.grdDebito.Columns(11).Width := 4000;
    Self.grdDebito.Columns(12).Width := 500;
    Self.grdDebito.Columns(13).Width := 500;
    Self.grdCredito.Columns(11).Caption := 'Descrição da Transação';
    Self.grdDebito.Columns(11).Caption := 'Descrição da Transação';
    Self.grdCredito.Columns(12).Caption := 'Junta';
    Self.grdCredito.Columns(13).Caption := 'Inter';
    Self.grdDebito.Columns(12).Caption := 'Junta';
    Self.grdDebito.Columns(13).Caption := 'Inter'; }

    Exit;
  except  // Erro:
 //    Err.Clear();
    { Resume Next }
  end;
end;

procedure TTipoConAdm.TrataErro;
begin
  if  not RsAdoDeb.EOF then
    begin
    if length(RsAdoDeb.FieldByName('Codigo').AsString)=0 then
      Application.MessageBox('Digite o número da conta...', 'Tipo de Conciliação', MB_ICONSTOP);

    if Length(RsAdoDeb.FieldByName('Ref').AsString)=0 then
      Application.MessageBox('Digite a Referência 1...', 'Tipo de Conciliação', MB_ICONSTOP);

  end;
end;

procedure TTipoConAdm.Text8Exit(Sender: TObject);
Var
  Cb1Txt : String;
begin
  // Verifica se o cliente está cadastrado
  if Length(Text8.Text) = 0 then
    Exit;

  if Self.Command2.Focused then
    Exit;

  sSql := 'Select distinct [cd_grupo_con] from [tb_grupoCon] order by cd_grupo_con';
  RsDb.SQL.Text  := (sSql);
  RsDb.Open;

  if RsDb.EOF then
    begin
    Application.MessageBox('Grupo de conciliações vazio...', 'Tipo de Conciliação', MB_ICONSTOP);
    // Text8.SetFocus
    RsDb.Close;
    Exit;
    end
  else
    begin
    Cb1Txt := ComboBox1.Text;
    ComboBox1.Clear;
    while Not (RsDb.Eof) do
      begin
        Combobox1.Items.Add(RsDb.Fields[0].AsString);
        RsDb.Next;
      end;
    ComboBox1.Sorted := True;
    ComboBox1.Text := Cb1Txt;
    end;
  RsDb.Close;

  sSql := 'select * from clientes where nome_reduzido = '#39''+Text8.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);

  RsDb.SQL.Text  := (sSql);
  RsDb.Open;

  if RsDb.EOF then
    Begin
    Application.MessageBox('Cliente não está cadastrado...', 'Tipo de Conciliação', MB_ICONSTOP);
    // Text8.SetFocus
    RsDb.Close;
    Exit;
    end;

  RsDb.Close;
//  Text8.Enabled := false;

  ActiveControl := nil;
  PostMessage(Self.ComboBox1.Handle, WM_SETFOCUS, 0, 0);
  ComboBox1.SetFocus;

end;

procedure TTipoConAdm.Text9Exit(Sender: TObject);
begin
//  if Length(Text9.Text) > 0 then
    begin
    if ((Text9.Text) <> 'S') and ((Text9.Text) <> 'N') then
      begin
      Application.MessageBox('Agendamento só pode ser S ou N ...', 'Tipo de Conciliação', MB_ICONSTOP);
      Text9.SetFocus;
      end;
  end;
end;

procedure TTipoConAdm.Text9KeyPress(Sender: TObject; var Key: Char);
begin
if not CharInSet(key, [#08, 'S', 'N', 's', 'n']) then
  begin
  Beep;
  key := #0;
  end;
end;

end.
