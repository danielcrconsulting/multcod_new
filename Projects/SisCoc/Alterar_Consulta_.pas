unit Alterar_Consulta_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, Windows, DBCtrls, DB,
  ADODB, Vcl.Grids, Vcl.DBGrids;


type
  TAlterar_Consulta = class(TForm)
    cmdSair:  TButton;
    Data1:  TDBNavigator;
    Data1_DataSource:  TDataSource;
    Data1_DataSet:  TADODataSet;
    Frame1:  TGroupBox;
    txtCartao:  TEdit;
    Frame2:  TGroupBox;
    Text1:  TEdit;
    OrdemDtDeb:  TButton;
    OrdemDtCred:  TButton;
    OrdemCartao:  TButton;
    cmdOrdemVlDeb:  TButton;
    cmdOrdemVlCred:  TButton;
    cmdOrdemVlSaldo:  TButton;
    cmdOrdemCredDolar:  TButton;
    cmdOrdemDebDolar:  TButton;
    cmdOrdemVariac:  TButton;
    cmdOrdemObs:  TButton;
    cmdOrdemBanco:  TButton;
    Command1:  TButton;
    Command2:  TButton;
    DBGrid: TDBGrid;

    procedure cmdOrdemBancoClick(Sender: TObject);
    procedure cmdOrdemCredDolarClick(Sender: TObject);
    procedure cmdOrdemDebDolarClick(Sender: TObject);
    procedure cmdOrdemObsClick(Sender: TObject);
    procedure cmdOrdemVariacClick(Sender: TObject);
    procedure cmdOrdemVlCredClick(Sender: TObject);
    procedure cmdOrdemVlDebClick(Sender: TObject);
    procedure cmdOrdemVlSaldoClick(Sender: TObject);
    procedure cmdSairClick(Sender: TObject);
    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OrdemCartaoClick(Sender: TObject);
    procedure OrdemDtCredClick(Sender: TObject);
    procedure OrdemDtDebClick(Sender: TObject);
    procedure Text1Enter(Sender: TObject);
    procedure Text1KeyPress(Sender: TObject; var Key: char);
    procedure txtCartaoEnter(Sender: TObject);
    procedure txtCartaoKeyPress(Sender: TObject; var Key: char);
    procedure txtCartao_KeyPress(var KeyAscii: Smallint);
    procedure AtualizaGrid(Msg: Boolean);
    procedure AtualizaGrid_Valor(Msg: Boolean);
    procedure txtCartaoExit(Sender: TObject);
    procedure Ordena;
    procedure Titulos;

  private
    { Private declarations }

    procedure Form_Unload(var Cancel: Smallint);
    
    procedure txtCartaoKeyPress_2(KeyAscii: Smallint);

  public
    { Public declarations }
  end;

var
  Alterar_Consulta: TAlterar_Consulta;

implementation

uses  Dialogs, SysUtils, Module1, RotGerais, VBto_Converter;

{$R *.dfm}

 //=========================================================
procedure TAlterar_Consulta.cmdOrdemBancoClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by registro';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by registro';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdOrdemCredDolarClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_CreditoDolar';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_CreditoDolar';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdOrdemDebDolarClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_DebitoDolar';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_DebitoDolar';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdOrdemObsClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Observacao';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Observacao';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdOrdemVariacClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Variacao';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Variacao';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdOrdemVlCredClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_CreditoReal';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_CreditoReal';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdOrdemVlDebClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_DebitoReal';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_DebitoReal';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdOrdemVlSaldoClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_Saldo';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_Saldo';
  end;
  Ordena;
end;

procedure TAlterar_Consulta.cmdSairClick(Sender: TObject);
begin
  Close;
end;

procedure TAlterar_Consulta.Command1Click(Sender: TObject);
begin
  AtualizaGrid_Valor(true);
end;

procedure TAlterar_Consulta.Command2Click(Sender: TObject);
begin
//  txtCartao_KeyPress_2(13);
  txtCartaoKeyPress_2(13);
end;

procedure TAlterar_Consulta.FormShow(Sender: TObject);
var
  DbTemp,
  AdoConnection: TAdoConnection;
  gBanco : TAdoDataSet;
begin
 //  gWork := DBEngine.Workspaces(0);
  if not Conecta(DbTemp, gDataPath + gDataFile + '.udl') then
    Exit;

//  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
  gBanco := TAdoDataSet.Create(nil);
  gBanco.Connection := DbTemp;

  // Copia Tabela para CC_Temp.mdb
  if not GeraTempDb then
    begin
    gBanco.Close;
    Exit;
    end;
  gBanco.Close;

  // Set DbTemp = gWork.OpenDatabase(gAdmPath & "\CC_TempVisa.mdb")

  Screen.Cursor := crHourGlass;
  if gAlteraLanc=GERAL then
    begin
    gOrdemGrid := ' order by registro';
    end
  else
    begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by registro';
    end;

  DbGrid.DataSource.DataSet.DisableControls;   // Redraw := false;

  //Data1.DatabaseName := gTempDir+'CC_TempVisa.mdb';

  if not Conecta(AdoConnection, gTempDir+'CC_TempVisa.udl') then
    Exit;

  sSql := 'Select ';
  sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
  sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
  // CUIDADO   sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo, Observacao "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred, Obs_Deb,Obs_Cred "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred, Obs_Deb,Obs_Cred "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo "
  // Contabilidade
  sSql := sSql+',Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred, Obs_Deb,Obs_Cred ';

  sSql := sSql+'from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+gOrdemGrid;
  Data1_DataSet.CommandText := sSql;
  Data1_DataSet.Close;
  Data1_DataSet.Open;
  DbGrid.DataSource.DataSet.EnableControls;    // DbGrid.Redraw := true;
  Self.Left := 0;
  Self.Top := 0;
  Self.Width := 12000;
  Self.Height := 7600;

  CenterForm(Self);
  if False{Data1.DataSource.DataSet.Eof} then begin
    ShowMessage('Não existe movimento.');
    Screen.Cursor := crDefault;
    Exit;
  end;

{  DbGrid.ColWidth(0) := 350;               REVISAR!!!
  DbGrid.ColWidth(1) := 1000;
  DbGrid.ColWidth(2) := 1000;
  DbGrid.ColWidth(3) := 1650;
  DbGrid.ColWidth(4) := 0;
  DbGrid.ColWidth(5) := 800;
  DbGrid.ColWidth(6) := 650;
  DbGrid.ColWidth(7) := 800;
  DbGrid.ColWidth(8) := 680;
  DbGrid.ColWidth(9) := 1200;
  DbGrid.ColWidth(10) := 1200;
  DbGrid.ColWidth(11) := 800;
  DbGrid.ColWidth(12) := 1200;
  DbGrid.ColWidth(13) := 1000;
  DbGrid.ColWidth(14) := 1000;
  DbGrid.ColWidth(15) := 1000;
  DbGrid.ColWidth(16) := 1000;
  DbGrid.ColWidth(17) := 2000;
  DbGrid.ColWidth(18) := 2000;}

  // DbGrid.ColWidth(13) = 2000

  LinhaAtual := -1;
  DbGrid.DataSource.DataSet.DisableControls;   // Redraw := false;
  txtCartao.Text := '';
  Screen.Cursor := crDefault;

  Ordena;

  (*sSql := DbGrid.TextMatrix(2, 9);          // Revisar
  sSql := FormatVB(sSql,'##,##0.00');
  DbGrid.TextMatrix(2, 9) := sSql;           //(Row, Col)

  sSql := DbGrid.TextMatrix(3, 9);
  sSql := FormatVB(sSql,'##,##0.00');
  DbGrid.TextMatrix(3, 9) := sSql;

  sSql := DbGrid.TextMatrix(4, 9);
  sSql := FormatVB(sSql,'##,##0.00');
  DbGrid.TextMatrix(4, 9) := sSql;   *)
end;

procedure TAlterar_Consulta.Form_Unload(var Cancel: Smallint);
begin
//  Desconecta();
  Data1_DataSet.CommandText := '';
  Data1_DataSet.Close;
end;

procedure TAlterar_Consulta.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

procedure TAlterar_Consulta.OrdemCartaoClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Cartao';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Cartao';
  end;
  Ordena();
end;

procedure TAlterar_Consulta.OrdemDtCredClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Data_Credito';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Data_Credito';
  end;
  Ordena();
end;

procedure TAlterar_Consulta.OrdemDtDebClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Data_Debito';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Data_Debito';
  end;
  Ordena();
end;

procedure TAlterar_Consulta.Text1Enter(Sender: TObject);
begin
  txtCartao.Text := '';
end;

procedure TAlterar_Consulta.Text1KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then begin
    // Verifica Valor
    AtualizaGrid_Valor(true);
  end;
end;

procedure TAlterar_Consulta.txtCartaoEnter(Sender: TObject);
begin
  Text1.Text := '';
end;

procedure TAlterar_Consulta.txtCartaoKeyPress_2(KeyAscii: Smallint);
begin
txtCartaoKeyPress(TxtCartao, Char(KeyAscii));
end;

procedure TAlterar_Consulta.txtCartaoKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then begin
    // Verifica Nro do Cartão
    if ( not IsStringNum(txtCartao.Text)) then begin
      Application.MessageBox('Número do Cartão inválido. Digite novamente.', '', MB_ICONSTOP);
      txtCartao.SetFocus();
      txtCartao.SelStart := 0;
      txtCartao.SelLength := Length(txtCartao.Text);
      Screen.Cursor := crDefault;
      Exit;
    end;

    AtualizaGrid(true);
  end;
  if Length(txtCartao.Text)>12 then begin
    Beep();
    Key := #0;
  end;
end;

procedure TAlterar_Consulta.txtCartao_KeyPress(var KeyAscii: Smallint);
var
  chKeyAscii: char;
begin
  chKeyAscii := char(KeyAscii);
  txtCartaoKeyPress(txtCartao, chKeyAscii);
end;
procedure TAlterar_Consulta.AtualizaGrid(Msg: Boolean);
begin

//  DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;
  sSql := 'Select ';
  sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
  sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo, Observacao "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred, Obs_Deb,Obs_Cred "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred, Obs_Deb,Obs_Cred "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo "
  // Contabilidade
  sSql := sSql+',Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred, Obs_Deb,Obs_Cred ';

  sSql := sSql+'from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+' and cartao1 = '#39''+Copy(txtCartao.Text, 1, 13)+''#39'';
  sSql := sSql+gOrdemGrid;
  Data1_DataSet.CommandText := sSql;
//  DbRefresh(Data1_DataSet);
  Data1_DataSet.Close;
  Data1_DataSet.Open;
  Titulos;
//  DbGrid.Redraw := True;
  DbGrid.DataSource.DataSet.EnableControls;
  if False{Data1.DataSource.DataSet.Eof} then begin
    if Msg then ShowMessage(PChar('Cartão não encontrado: '+txtCartao.Text));
    // Reconstitui a tela
//    DbGrid.Redraw := false;
    DbGrid.DataSource.DataSet.DisableControls;
    sSql := 'Select ';
    sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
    sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
    // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo, Observacao "
    // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred, Obs_Deb,Obs_Cred "
    // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred, Obs_Deb,Obs_Cred "
    // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo "
    // Contabilidade
    sSql := sSql+',Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred, Obs_Deb,Obs_Cred ';
    sSql := sSql+'from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    sSql := sSql+gOrdemGrid;
    Data1_DataSet.CommandText := sSql;
//    DbRefresh(Data1_DataSet);
    Data1_DataSet.Close;
    Data1_DataSet.Open;

    Titulos();
    //DbGrid.Redraw := true;
    DbGrid.DataSource.DataSet.EnableControls;
    txtCartao.Text := '';
    Text1.Text := '';
    LinhaAtual := -1;
  end;

end;
procedure TAlterar_Consulta.AtualizaGrid_Valor(Msg: Boolean);
begin
//  DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.EnableControls;
  sSql := 'Select ';
  sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
  sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo, Observacao "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred, Obs_Deb,Obs_Cred "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred, Obs_Deb,Obs_Cred "
  sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred, Obs_Deb,Obs_Cred ';

  sSql := sSql+'from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+' and (Vl_DebitoReal = '+FormataValor2(Text1.Text);
  sSql := sSql+' or Vl_CreditoReal = '+FormataValor2(Text1.Text);
  sSql := sSql+' or Vl_DebitoDolar = '+FormataValor2(Text1.Text);
  sSql := sSql+' or Vl_CreditoDolar = '+FormataValor2(Text1.Text)+')';
  sSql := sSql+gOrdemGrid;
  Data1_DataSet.CommandText := sSql;
//  DbRefresh(Data1_DataSet);
  Data1_DataSet.Close;
  Data1_DataSet.Open;

  Titulos();
  //DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  if False{Data1.DataSource.DataSet.Eof} then begin
    if Msg then ShowMessage(PChar('Valor não encontrado: '+FormatVB(Text1.Text,'##,##0.00')));
    // Reconstitui a tela
    //DbGrid.Redraw := false;
    DbGrid.DataSource.DataSet.EnableControls;
    sSql := 'Select ';
    sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
    sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
    // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo, Observacao "
    // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred, Obs_Deb,Obs_Cred "
    // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred, Obs_Deb,Obs_Cred "
    sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred, Obs_Deb,Obs_Cred ';

    sSql := sSql+'from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    sSql := sSql+gOrdemGrid;
    Data1_DataSet.CommandText := sSql;
    Titulos();
//    DbRefresh(Data1_DataSet);
    Data1_DataSet.Close;
    Data1_DataSet.Open;

    //DbGrid.Redraw := true;
    DbGrid.DataSource.DataSet.EnableControls;
    Text1.Text := '';
    LinhaAtual := -1;
  end;

  Titulos();

  LinhaAtual := -1;
  //DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  txtCartao.Text := '';
  Text1.Text := '';
end;

procedure TAlterar_Consulta.txtCartaoExit(Sender: TObject);
begin
  // Verifica Nro do Cartão
  if ( not IsStringNum(txtCartao.Text)) then begin
    Application.MessageBox('Número do Cartão inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
    txtCartao.SetFocus();
    txtCartao.SelStart := 0;
    txtCartao.SelLength := Length(txtCartao.Text);
    Screen.Cursor := crDefault;
    Exit;
  end;
  // AtualizaGrid False
end;

procedure TAlterar_Consulta.Ordena;
begin
  Screen.Cursor := crHourGlass;
  //DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;
//  Data1.DatabaseName := gTempDir+'CC_TempVisa.mdb';
  Data1_DataSet.Connection.ConnectionString := String(gDataPath)+gDataFile+'.udl';
  sSql := 'Select ';
  sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
  sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
  // CUIDADO   sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo, Observacao "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred, Obs_Deb,Obs_Cred "
  // sSql = sSql & ",Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred, Obs_Deb,Obs_Cred "
  sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred, Obs_Deb,Obs_Cred ';

  sSql := sSql+'from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+gOrdemGrid;
  Data1_DataSet.CommandText := sSql;
//  DbRefresh(Data1_DataSet);
  Data1_DataSet.Close;
  Data1_DataSet.Open;

  Titulos();
  //DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  Screen.Cursor := crDefault;
end;

procedure TAlterar_Consulta.Titulos();
begin
  LinhaAtual := 0;

(*  DbGrid.Row := 0;                              REVISAR!!!
  DbGrid.Col := 1;
  DbGrid.Text := 'Data Debito';

  DbGrid.Col := 2;
  DbGrid.Text := 'Data Crédito';

  DbGrid.Col := 5;
  DbGrid.Text := 'Deb US$';
  DbGrid.Col := 6;
  DbGrid.Text := 'Tx. Deb';
  DbGrid.Col := 7;
  DbGrid.Text := 'Cred US$';
  DbGrid.Col := 8;
  DbGrid.Text := 'Tx. Cred';
  DbGrid.Col := 9;
  DbGrid.Text := 'Deb Real';
  DbGrid.Col := 10;
  DbGrid.Text := 'Cred Real';
  DbGrid.Col := 11;
  DbGrid.Text := 'Variação';
  DbGrid.Col := 12;
  DbGrid.Text := 'Saldo';

  if  not False{Data1.DataSource.DataSet.Eof} then begin
    DbGrid.Row := 1;
  end;                       *)

end;


end.
