unit AlterarManual_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, Windows, DBCtrls, DB,
  ADODB, Vcl.Grids, Vcl.DBGrids;


type
  TAlterarManual = class(TForm)
    cmdSair:  TButton;
    cmdAlterar:  TButton;
    Data1:  TDBNavigator;
    Data1_DataSource:  TDataSource;
    Frame1:  TGroupBox;
    txtCartao:  TEdit;
    Frame2:  TGroupBox;
    Text1:  TEdit;
    cmdExcluir:  TButton;
    cmdIncluir:  TButton;
    OrdemDtDeb:  TButton;
    OrdemDtCred:  TButton;
    OrdemCartao:  TButton;
    cmdOrdemVlDeb:  TButton;
    cmdOrdemVlCred:  TButton;
    cmdOrdemVlSaldo:  TButton;
    cmdOrdemCredDolar:  TButton;
    cmdOrdemDebDolar:  TButton;
    cmdOrdemVariac:  TButton;
    cmdOrdemBanco:  TButton;
    Command1:  TButton;
    Command2:  TButton;
    DBGrid: TDBGrid;
    Data1_DataSet: TADODataSet;

    procedure cmdAlterarClick(Sender: TObject);
    procedure cmdExcluirClick(Sender: TObject);
    procedure cmdIncluirClick(Sender: TObject);
    procedure cmdOrdemBancoClick(Sender: TObject);
    procedure cmdOrdemCredDolarClick(Sender: TObject);
    procedure cmdOrdemDebDolarClick(Sender: TObject);
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

    //procedure DbGrid_Click();
    //procedure DbGrid_DragDrop(Source: TControl; x: Single; y: Single);
    //procedure DbGrid_DragOver(Source: TControl; x: Single; y: Single; State: Smallint);
    //procedure DbGrid_EnterCell();
    //procedure DbGrid_GotFocus();
    //procedure DbGrid_LeaveCell();
    //procedure DbGrid_RowColChange();
    //procedure DbGrid_Scroll();
    //procedure DbGrid_SelChange();

    procedure Form_Unload(var Cancel: Smallint);
    
    procedure txtCartaoKeyPress_2(KeyAscii: Smallint);

  public
    { Public declarations }
  end;

var
  AlterarManual: TAlterarManual;

implementation

uses  Dialogs, SysUtils, Module1, Alterar1Manual_, Incluir_, RotGerais, VBto_Converter, Subrug;

{$R *.dfm}

 //=========================================================
procedure TAlterarManual.cmdAlterarClick(Sender: TObject);
begin
  with AlterarManual.Data1.DataSource do begin
    if  not False{AlterarManual.Data1.DataSource.DataSet.Eof} then begin
      if LinhaAtual<>-1 then begin
        if (AlterarManual.Data1.DataSource.DataSet.FieldByName('Vl_Saldo').Value)=0 then begin
          if Application.MessageBox('Confirma Alteração de Lançamento Batido?', 'Excluir Registros', MB_YESNO)=IDNO then begin
            Exit;
          end;
        end;
        // Tela para digitar dados
        gData1 := '';
        Alterar1Manual.ShowModal();
       end  else  begin
        Application.MessageBox('Selecione um Cartão', 'Alterar Registros', MB_ICONSTOP);
      end;
    end;
  end;
  if gData1='123' then Alterar1Manual.Close();
end;

procedure TAlterarManual.cmdExcluirClick(Sender: TObject);
var
  Posicao: Longint;
  xData : TDateTime;
begin
  if False{AlterarManual.Data1.DataSource.DataSet.Eof} then
    Exit;

  if LinhaAtual <> -1 then
    begin
    if TryStrToDate(Data1.DataSource.DataSet.FieldByName('Data_Debito').AsString, xData) then
      begin
      if (gAtualizacao < Data1.DataSource.DataSet.FieldByName('Data_Debito').Value) then
        begin
        Application.MessageBox('Lançamento com data anterior. Não pode ser excluido', '', MB_ICONSTOP);
        Exit;
        end;
    end;

    if TryStrToDate(Data1.DataSource.DataSet.FieldByName('Data_Credito').AsString, xData) then
      begin
      if gAtualizacao < Data1.DataSource.DataSet.FieldByName('Data_Credito').Value then
        begin
        Application.MessageBox('Lançamento com data anterior. Não pode ser excluido', '', MB_ICONSTOP);
        Exit;
        end;
      end;

    if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then
      begin
      Screen.Cursor := crHourGlass;
//      Data1.DataSource.DataSet.AbsolutePosition := LinhaAtual-1;  //
      Data1.DataSource.DataSet.First;
      Data1.DataSource.DataSet.MoveBy(LinhaAtual-1);

      Posicao := LinhaAtual;
      with AlterarManual.Data1.DataSource do
        begin

//        Gravalog(Data1.DataSource, 'Exclusão');
        Gravalog(Data1_DataSet, 'Exclusão');

        Data1.DataSource.DataSet.Delete;
//        DbGrid.Redraw := false;
        DbGrid.DataSource.DataSet.DisableControls;
        Data1_DataSet.Close;
        Data1_DataSet.Open;
        if Posicao > 1 then;
//          DbGrid.Row := Posicao-1;
        DbGrid.SetFocus;
//        DbGrid.Redraw := true;
        DbGrid.DataSource.DataSet.EnableControls;
        SendKeys(38); // (crUpArrow);
        SendKeys(38); //(crUpArrow);
      end;
    end;
   end  else  begin
    Application.MessageBox('Selecione um Cartão', 'Excluir Registros', MB_ICONSTOP);
  end;
  Screen.Cursor := crDefault;
  // AtualizaGrid False

end;

procedure TAlterarManual.cmdIncluirClick(Sender: TObject);
begin
  Incluir.ShowModal();
  AtualizaGrid(false);
end;

procedure TAlterarManual.cmdOrdemBancoClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by registro';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by registro';
  end;
  Ordena;
end;

procedure TAlterarManual.cmdOrdemCredDolarClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_CreditoDolar';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_CreditoDolar';
  end;
  Ordena;
end;

procedure TAlterarManual.cmdOrdemDebDolarClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_DebitoDolar';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_DebitoDolar';
  end;
  Ordena();
end;


procedure TAlterarManual.cmdOrdemVariacClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Variacao';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Variacao';
  end;
  Ordena();
end;

procedure TAlterarManual.cmdOrdemVlCredClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_CreditoReal';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_CreditoReal';
  end;
  Ordena();
end;

procedure TAlterarManual.cmdOrdemVlDebClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_DebitoReal';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_DebitoReal';
  end;
  Ordena();
end;

procedure TAlterarManual.cmdOrdemVlSaldoClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Vl_Saldo';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Vl_Saldo';
  end;
  Ordena();
end;

procedure TAlterarManual.cmdSairClick(Sender: TObject);
begin
  Close();
end;

procedure TAlterarManual.Command1Click(Sender: TObject);
begin
  AtualizaGrid_Valor(true);
end;

procedure TAlterarManual.Command2Click(Sender: TObject);
begin
  txtCartaoKeyPress_2(13);
end;

//{$DEFINE defUse_DbGrid_Click}
{$IF Defined(defUse_DbGrid_Click)}
procedure TAlterarManual.DbGrid_Click();
begin
  LinhaAtual := DbGrid.Row;
  Data1.DataSource.AbsolutePosition := LinhaAtual-1;
  txtCartao.Text := Data1.DataSource.DataSet.FieldByName('Cartao').Value;
end;
{$IFEND} // defUse_DbGrid_Click

//{$DEFINE defUse_DbGrid_DragDrop}
{$IF Defined(defUse_DbGrid_DragDrop)}
procedure TAlterarManual.DbGrid_DragDrop(Source: TControl; x: Single; y: Single);
begin
  // MsgBox "dragDrop"
end;
{$IFEND} // defUse_DbGrid_DragDrop

//{$DEFINE defUse_DbGrid_DragOver}
{$IF Defined(defUse_DbGrid_DragOver)}
procedure TAlterarManual.DbGrid_DragOver(Source: TControl; x: Single; y: Single; State: Smallint);
begin
  // MsgBox "dragOver"

end;
{$IFEND} // defUse_DbGrid_DragOver

//{$DEFINE defUse_DbGrid_EnterCell}
{$IF Defined(defUse_DbGrid_EnterCell)}
procedure TAlterarManual.DbGrid_EnterCell();
begin
  // MsgBox "EnterCell"
end;
{$IFEND} // defUse_DbGrid_EnterCell

//{$DEFINE defUse_DbGrid_GotFocus}
{$IF Defined(defUse_DbGrid_GotFocus)}
procedure TAlterarManual.DbGrid_GotFocus();
begin
  // MsgBox "GotFocus"

end;
{$IFEND} // defUse_DbGrid_GotFocus

//{$DEFINE defUse_DbGrid_LeaveCell}
{$IF Defined(defUse_DbGrid_LeaveCell)}
procedure TAlterarManual.DbGrid_LeaveCell();
begin
  // MsgBox "LeaveCell"
end;
{$IFEND} // defUse_DbGrid_LeaveCell

//{$DEFINE defUse_DbGrid_RowColChange}
{$IF Defined(defUse_DbGrid_RowColChange)}
procedure TAlterarManual.DbGrid_RowColChange();
begin
  if DbGrid.Row<>LinhaAtual then begin
    LinhaAtual := DbGrid.RowSel;
    Data1.DataSource.AbsolutePosition := LinhaAtual-1;
    txtCartao.Text := Data1.DataSource.DataSet.FieldByName('Cartao').Value;
  end;
end;
{$IFEND} // defUse_DbGrid_RowColChange

//{$DEFINE defUse_DbGrid_Scroll}
{$IF Defined(defUse_DbGrid_Scroll)}
procedure TAlterarManual.DbGrid_Scroll();
begin
  // MsgBox "Scroll"

end;
{$IFEND} // defUse_DbGrid_Scroll

//{$DEFINE defUse_DbGrid_SelChange}
{$IF Defined(defUse_DbGrid_SelChange)}
procedure TAlterarManual.DbGrid_SelChange();
begin
  // MsgBox "SelChange"

end;
{$IFEND} // defUse_DbGrid_SelChange

procedure TAlterarManual.FormShow(Sender: TObject);
begin

//  gWork := DBEngine.Workspaces(0);
//  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
  Screen.Cursor := crHourGlass;
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by registro';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by registro';
  end;
//  DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;
  Data1_DataSet.Connection.ConnectionString := String(gDataPath) + gDataFile + '.udl';
  sSql := 'Select ';
  sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
  sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
  sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,';
  sSql := sSql+'Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred,';
  sSql := sSql+'Obs_Deb,Obs_Cred from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+gOrdemGrid;

  Data1_DataSet.CommandText := sSql;
  // Data1.Database.OpenRecordset (sSql)
  // Set RsDb = gBanco.OpenRecordset(sSql)
  Data1_DataSet.Close;
  Data1_DataSet.Open;
//  DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  Self.Left := 0;
  Self.Top := 0;
  Self.Width := 12000;
  Self.Height := 7600;

  CenterForm(Self);
  if False{Data1.DataSource.DataSet.Eof} then begin
    ShowMessage('Não existe movimento.');
  end;

  Titulos;

  LinhaAtual := -1;
//  DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  txtCartao.Text := '';
  Screen.Cursor := crDefault;
  Data1_DataSet.Connection.ConnectionString := '';

  Ordena;

end;

procedure TAlterarManual.Form_Unload(var Cancel: Smallint);
begin
//  Desconecta();
  Data1_DataSet.Close;
  Data1_DataSet.CommandText := '';
end;

procedure TAlterarManual.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

procedure TAlterarManual.OrdemCartaoClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Cartao';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Cartao';
  end;
  Ordena();
end;

procedure TAlterarManual.OrdemDtCredClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Data_Credito';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Data_Credito';
  end;
  Ordena();
end;

procedure TAlterarManual.OrdemDtDebClick(Sender: TObject);
begin
  if gAlteraLanc=GERAL then begin
    gOrdemGrid := ' order by Data_Debito';
   end  else  begin
    gOrdemGrid := ' and Vl_Saldo <> 0 order by Data_Debito';
  end;
  Ordena();
end;

procedure TAlterarManual.Text1Enter(Sender: TObject);
begin
  txtCartao.Text := '';
end;

procedure TAlterarManual.Text1KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then begin
    // Verifica Valor
    AtualizaGrid_Valor(true);
  end;
end;

procedure TAlterarManual.txtCartaoEnter(Sender: TObject);
begin
  Text1.Text := '';
end;

procedure TAlterarManual.txtCartaoKeyPress_2(KeyAscii: Smallint);
begin
txtCartaoKeyPress(AlterarManual, Char(KeyAscii));
end;

procedure TAlterarManual.txtCartaoKeyPress(Sender: TObject; var Key: char);
begin
//  if KeyAscii=13 then begin
  if Key=#13 then begin
    // Verifica Nro do Cartão
    if ( not IsStringNum(txtCartao.Text)) then begin
      Application.MessageBox('Número do Cartão inválido. Digite novamente.', '', MB_ICONSTOP);
      txtCartao.SetFocus();
      txtCartao.SelStart := 0;
      txtCartao.SelLength := Length(txtCartao.Text);
      Exit;
    end;

    AtualizaGrid(true);
  end;
  if Length(txtCartao.Text)>12 then begin
    Beep();
//    KeyAscii := 0;
    Key := #0;
  end;
end;

procedure TAlterarManual.txtCartao_KeyPress(var KeyAscii: Smallint);
var
  chKeyAscii: char;
begin
  chKeyAscii := char(KeyAscii);
  txtCartaoKeyPress(txtCartao, chKeyAscii);
end;

procedure TAlterarManual.AtualizaGrid(Msg: Boolean);
begin

//  DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;
  sSql := 'Select ';
  sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
  sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
  sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,';
  sSql := sSql+'Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred,';
  sSql := sSql+'Obs_Deb,Obs_Cred from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+gOrdemGrid;

  Data1_DataSet.CommandText := sSql;
  Data1_DataSet.Close;
  Data1_DataSet.Open;
  Titulos;
//  DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  if False{Data1.DataSource.DataSet.Eof} then begin
    if Msg then ShowMessage(PChar('Cartão não encontrado: '+txtCartao.Text));
    // Reconstitui a tela

//    DbGrid.Redraw := false;
    DbGrid.DataSource.DataSet.DisableControls;

    sSql := 'Select ';
    sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
    sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
    sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,';
    sSql := sSql+'Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred,';
    sSql := sSql+'Obs_Deb,Obs_Cred from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    sSql := sSql+gOrdemGrid;

    Data1_DataSet.CommandText := sSql;
    Data1_DataSet.Close;
    Data1_DataSet.Open;
    Titulos();
//    DbGrid.Redraw := true;
    DbGrid.DataSource.DataSet.EnableControls;
    txtCartao.Text := '';
    Text1.Text := '';
    LinhaAtual := -1;
  end;

end;

procedure TAlterarManual.AtualizaGrid_Valor(Msg: Boolean);
begin
//  DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;
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
  Data1_DataSet.Close;
  Data1_DataSet.Open;
  Titulos;
//  DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  if False{Data1.DataSource.DataSet.Eof} then begin
    if Msg then ShowMessage(PChar('Valor não encontrado: '+FormatVB(Text1.Text,'##,##0.00')));
    // Reconstitui a tela
 //    DbGrid.Redraw := false;
    DbGrid.DataSource.DataSet.DisableControls;
    sSql := 'Select ';
    sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
    sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
    sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,';
    sSql := sSql+'Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred,';
    sSql := sSql+'Obs_Deb,Obs_Cred from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    sSql := sSql+gOrdemGrid;
    Data1_DataSet.CommandText := sSql;
    Titulos;
    Data1_DataSet.Close;
    Data1_DataSet.Open;
 //    DbGrid.Redraw := true;
    DbGrid.DataSource.DataSet.EnableControls;
    Text1.Text := '';
    LinhaAtual := -1;
  end;

  Titulos();

  LinhaAtual := -1;
 //  DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  txtCartao.Text := '';
  Text1.Text := '';
end;

procedure TAlterarManual.txtCartaoExit(Sender: TObject);
begin
  // Verifica Nro do Cartão
  if ( not IsStringNum(txtCartao.Text)) then begin
    Application.MessageBox('Número do Cartão inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
    txtCartao.SetFocus();
    txtCartao.SelStart := 0;
    txtCartao.SelLength := Length(txtCartao.Text);
    Exit;
  end;

  // AtualizaGrid False
end;

procedure TAlterarManual.Ordena;
begin
  Screen.Cursor := crHourGlass;
 //  DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;
//  Data1.DatabaseName := String(gDataPath)+gDataFile;
  Data1_DataSet.Connection.ConnectionString := String(gDataPath)+gDataFile+'.udl';

  sSql := 'Select ';
  sSql := sSql+'Data_Debito,Data_Credito,Cartao,Cartao1,Vl_DebitoDolar';
  sSql := sSql+',Taxa_Debito, Vl_CreditoDolar,Taxa_Credito,Vl_DebitoReal';
  sSql := sSql+',Vl_CreditoReal,Variacao,Vl_Saldo,Cod_Deb,Cod_Cred,';
  sSql := sSql+'Rel_Deb,Rel_Cred,Moeda_Deb,Moeda_Cred,Depto_Deb,Depto_Cred,';
  sSql := sSql+'Obs_Deb,Obs_Cred from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+gOrdemGrid;

  Data1_DataSet.CommandText := sSql;
  Data1_DataSet.Close;
  Data1_DataSet.Open;
  Titulos;
//  DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
  Screen.Cursor := crDefault;
end;

procedure TAlterarManual.Titulos;
begin

// Revisar depois que o inline voltar

  {DbGrid.ColWidth(0) := 350;
  DbGrid.ColWidth(3) := 1650;
  DbGrid.ColWidth(4) := 0;

  LinhaAtual := 0;
  DbGrid.Row := 0;
  DbGrid.Col := 1;
  DbGrid.Text := 'Data Debito';
  DbGrid.ColWidth(1) := 1000;

  DbGrid.Col := 2;
  DbGrid.Text := 'Data Crédito';
  DbGrid.ColWidth(2) := 1000;

  DbGrid.Col := 5;
  DbGrid.Text := 'Db US$';
  DbGrid.ColWidth(5) := 700;
  DbGrid.Col := 6;
  DbGrid.Text := 'Tx Deb';
  DbGrid.ColWidth(6) := 700;
  DbGrid.Col := 7;
  DbGrid.ColWidth(7) := 700;
  DbGrid.Text := 'Cr US$';
  DbGrid.Col := 8;
  DbGrid.Text := 'Tx Cred';
  DbGrid.ColWidth(8) := 700;
  DbGrid.Col := 9;
  DbGrid.Text := 'Db R$';
  DbGrid.ColWidth(9) := 1000;
  DbGrid.Col := 10;
  DbGrid.Text := 'Cr R$';
  DbGrid.ColWidth(10) := 1000;
  DbGrid.Col := 11;
  DbGrid.Text := 'Varição';
  DbGrid.ColWidth(11) := 700;
  DbGrid.Col := 12;
  DbGrid.Text := 'Saldo';
  DbGrid.ColWidth(12) := 1000;
  // Contabilidade
  DbGrid.Col := 13;
  DbGrid.Text := 'Cód Débito';
  DbGrid.ColWidth(13) := 3000;
  DbGrid.Col := 14;
  DbGrid.Text := 'Cód Credito';
  DbGrid.ColWidth(14) := 3000;
  DbGrid.Col := 15;
  DbGrid.Text := 'Rel Db';
  DbGrid.ColWidth(15) := 1000;
  DbGrid.Col := 16;
  DbGrid.Text := 'Rel Cr';
  DbGrid.ColWidth(16) := 1000;
  DbGrid.Col := 17;
  DbGrid.Text := 'M Db';
  DbGrid.ColWidth(17) := 500;
  DbGrid.Col := 18;
  DbGrid.Text := 'M Cr';
  DbGrid.ColWidth(18) := 500;
  DbGrid.Col := 19;
  DbGrid.Text := 'Dp Db';
  DbGrid.ColWidth(19) := 600;
  DbGrid.Col := 20;
  DbGrid.Text := 'Dp Cr';
  DbGrid.ColWidth(20) := 600;
  DbGrid.Col := 21;
  DbGrid.Text := 'Obs Débito';
  DbGrid.ColWidth(21) := 3300;
  DbGrid.Col := 22;
  DbGrid.Text := 'Obs Crédito';
  DbGrid.ColWidth(22) := 3300;

  if  not False{Data1.DataSource.DataSet.Eof} {then begin
    DbGrid.Row := 1;
  end;             }

end;


end.
