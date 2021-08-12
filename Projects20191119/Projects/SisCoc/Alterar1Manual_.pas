unit Alterar1Manual_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows, Variants;


type
  TAlterar1Manual = class(TForm)
    Label5:  TLabel;
    Label4:  TLabel;
    Label3:  TLabel;
    Label2:  TLabel;
    Label1:  TLabel;
    Label6:  TLabel;
    Label7:  TLabel;
    Label8:  TLabel;
    Label9:  TLabel;
    Label10:  TLabel;
    Label11:  TLabel;
    Label12:  TLabel;
    Label13:  TLabel;
    Label14:  TLabel;
    Label15:  TLabel;
    Label16:  TLabel;
    Label17:  TLabel;
    Label18:  TLabel;
    cmdCancel:  TButton;
    cmdGravar:  TButton;
    txtVlCredito:  TEdit;
    txtVlDebito:  TEdit;
    txtNroCartao:  TEdit;
    txtDtCredito:  TEdit;
    txtDtDebito:  TEdit;
    txtDD_0:  TEdit;
    txtTD_0:  TEdit;
    txtDD_2:  TEdit;
    txtTD_1:  TEdit;
    txtObsDeb:  TEdit;
    txtVariacao:  TEdit;
    txtObsCred:  TEdit;
    txtRelCred_2:  TEdit;
    txtRelDeb_1:  TEdit;
    txtCodCred_3:  TEdit;
    txtCodDeb_3:  TEdit;
    txtDeptDeb_0:  TEdit;
    txtDeptCred_0:  TEdit;

    procedure cmdCancelClick(Sender: TObject);
    procedure cmdGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txtObsCredKeyPress(Sender: TObject; var Key: char);
    procedure txtObsDebKeyDown(Sender: TObject; var KeyCode: WORD; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  sDtDebito, sDtCredito: String;

  public
    { Public declarations }

    txtDeptCred:  array[0..0] of TEdit;  // Control array
    txtDeptDeb:  array[0..0] of TEdit;  // Control array
    txtCodDeb:  array[0..3] of TEdit;  // Control array
    txtCodCred:  array[0..3] of TEdit;  // Control array
    txtRelDeb:  array[0..1] of TEdit;  // Control array
    txtRelCred:  array[0..2] of TEdit;  // Control array
    txtTD:  array[0..1] of TEdit;  // Control array
    txtDD:  array[0..2] of TEdit;  // Control array

  end;

var
  Alterar1Manual: TAlterar1Manual;

implementation

uses  Dialogs, SysUtils, AlterarManual_, Module1, RotGerais, VBto_Converter;

{$R *.dfm}

 //=========================================================
procedure TAlterar1Manual.cmdCancelClick(Sender: TObject);
begin
  Close();
  AlterarManual.txtCartao.Text := '';
  AlterarManual.AtualizaGrid(false);
end;
procedure TAlterar1Manual.cmdGravarClick(Sender: TObject);
label
  Erro;
Var
  xData : TDateTime;
begin

  try  // On Error GoTo Erro

    if Self.txtVlCredito.Text='' then Self.txtVlCredito.Text := '0';
    if Self.txtVlDebito.Text='' then Self.txtVlDebito.Text := '0';
    if Self.txtVariacao.Text='' then Self.txtVariacao.Text := '0';

    if Self.txtDD[0].Text='' then Self.txtDD[0].Text := '0';
    if Self.txtDD[2].Text='' then Self.txtDD[2].Text := '0';
    if Self.txtTD[0].Text='' then Self.txtTD[0].Text := '0';
    if Self.txtTD[1].Text='' then Self.txtTD[1].Text := '0';

    // Verifica se as datas são válida e se os valores correspondentes foram digitados
    if isDataValida(txtDtDebito.Text) and ( not isValorValido(txtVlDebito.Text)) then begin
      Application.MessageBox('Valor do Débito inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
      txtVlDebito.SetFocus();
      Exit;
    end;

    if ( not isDataValida(txtDtDebito.Text)) and (isValorValido(txtVlDebito.Text)) then begin
      Application.MessageBox('Data do Débito inválida. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
      txtVlDebito.SetFocus();
      Exit;
    end;

    if (isDataValida(txtDtCredito.Text)) and ( not isValorValido(txtVlCredito.Text)) then begin
      Application.MessageBox('Valor do Crédito inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
      txtVlCredito.SetFocus();
      Exit;
    end;

    if ( not isDataValida(txtDtCredito.Text)) and (isValorValido(txtVlCredito.Text)) then begin
      if ( not isDataValida(txtDtCredito.Text)) then begin
        Application.MessageBox('Data do Crédito inválida. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtVlCredito.SetFocus();
        Exit;
      end;
    end;

    if (Self.txtDeptDeb[0].Text<>'') or (Self.txtRelDeb[1].Text<>'') or (Self.txtCodDeb[3].Text<>'') or (Self.txtObsDeb.Text<>'') then begin
      if ( not isDataValida(txtDtDebito.Text)) then begin
        Application.MessageBox('Data do Débito inválida. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtVlCredito.SetFocus();
        Exit;
      end;
    end;

    if (Self.txtDeptCred[0].Text<>'') or (Self.txtRelCred[2].Text<>'') or (Self.txtCodCred[3].Text<>'') or (Self.txtObsCred.Text<>'') then begin
      if ( not isDataValida(txtDtCredito.Text)) then begin
        Application.MessageBox('Data do Crédito inválida. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtVlCredito.SetFocus();
        Exit;
      end;
    end;

    // Se existir debito e crédito, os valores devem ser iguais
    if (isDataValida(txtDtDebito.Text)) and (isDataValida(txtDtCredito.Text)) then
      if StrToFloat(txtVlDebito.Text) <> StrToFloat(txtVlCredito.Text) then
        if Application.MessageBox('Confirma Alteração com valores Diferentes(DB/CRD)?', 'Excluir Registros', MB_YESNO)=IDNO then
          Exit;

    if isDataValida(txtDtDebito.Text) then begin
      if Self.txtCodDeb[3].Text='' then begin
        Application.MessageBox('Cod Débito Inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtCodDeb[3].SetFocus();
        Exit;
      end;
      if Self.txtRelDeb[1].Text='' then begin
        Application.MessageBox('Rel Débito Inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtRelDeb[1].SetFocus();
        Exit;
      end;
      if Self.txtDeptDeb[0].Text='' then begin
        Application.MessageBox('Depto Débito Inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtDeptDeb[0].SetFocus();
        Exit;
      end;
    end;

    if isDataValida(txtDtCredito.Text) then begin
      if Self.txtCodCred[3].Text='' then begin
        Application.MessageBox('Cod Créito Inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtCodCred[3].SetFocus();
        Exit;
      end;
      if Self.txtRelCred[2].Text='' then begin
        Application.MessageBox('Rel Créito Inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtRelCred[2].SetFocus();
        Exit;
      end;
      if Self.txtDeptCred[0].Text='' then begin
        Application.MessageBox('Depto Créito Inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtDeptCred[0].SetFocus();
        Exit;
      end;
    end;

    // Se existir debito verifica DeptoDeb
    // AINDA NÃO PODE DEVIDO AOS DADOS JA EXISTENTES
    // If isDataValida(txtDtDebito.Text) Then
    // If Len(Trim(Me.txtDeptDeb(0))) <> 3 Then
    // 
    // MsgBox ("Digite o Depto de Débito!")
    // Exit Sub
    // End If
    // End If

    // Se existir crédito verifica DeptoCred
    // AINDA NÃO PODE DEVIDO AOS DADOS JA EXISTENTES
    // If isDataValida(txtDtCredito.Text) Then
    // If Len(Trim(Me.txtDeptDeb(0))) <> 3 Then
    // MsgBox ("Digite o Depto de Crédito!")
    // Exit Sub
    // End If
    // End If

    // Os dados estão válidos, GRAVAR

//  AlterarManual.DbGrid.Redraw := false;
    AlterarManual.DbGrid.DataSource.DataSet.DisableControls;

    with AlterarManual.Data1.DataSource do
      begin
      Edit;
      if TryStrToDateTime(Self.txtDtCredito.Text, xData) then
        DataSet.FieldByName('Data_Credito').AsString := Self.txtDtCredito.Text
      else
        DataSet.FieldByName('Data_Credito').Value := NULL;

      if TryStrToDateTime(Self.txtDtDebito.Text, xData) then
        DataSet.FieldByName('Data_Debito').Value := StrToFloat(Self.txtDtDebito.Text)
      else
        DataSet.FieldByName('Data_Debito').Value := NULL;

      DataSet.FieldByName('cartao').Value := Trim(Self.txtNroCartao.Text);
      DataSet.FieldByName('cartao1').Value := Copy(DataSet.FieldByName('cartao').Value, 1, 13);
//      DataSet.FieldByName('Vl_DebitoDolar').Value := FormataValor(txtDD[0].Text);
      DataSet.FieldByName('Vl_DebitoDolar').Value := StrToFloat(txtDD[0].Text);
      if txtTD[0].Text <> '' then
        DataSet.FieldByName('Taxa_Debito').Value := StrToFloat(txtTD[0].Text);
      DataSet.FieldByName('Vl_CreditoDolar').Value := StrToFloat(txtDD[2].Text);
      if txtTD[1].Text <> '' then
        DataSet.FieldByName('Taxa_Credito').Value := StrToFloat(txtTD[1].Text);
      DataSet.FieldByName('Vl_DebitoReal').Value := StrToFloat(txtVlDebito.Text);
      DataSet.FieldByName('Vl_CreditoReal').Value := StrToFloat(txtVlCredito.Text);
      // .Fields("Vl_CreditoReal") = CDbl(txtVlCredito)
      DataSet.FieldByName('Variacao').Value := StrToFloat(txtVariacao.Text);

      DataSet.FieldByName('Vl_Saldo').Value := DataSet.FieldByName('Vl_DebitoReal').Value -
                                               DataSet.FieldByName('Vl_CreditoReal').Value - DataSet.FieldByName('Variacao').Value;

      // Alterações visando a implementação da CONTABILIDADE
      DataSet.FieldByName('Obs_Deb').Value := Self.txtObsDeb.Text;
      DataSet.FieldByName('Obs_Cred').Value := Self.txtObsCred.Text;

      if isDataValida(txtDtDebito.Text) then begin
        DataSet.FieldByName('Cod_Deb').Value := Self.txtCodDeb[3].Text;
        DataSet.FieldByName('Rel_Deb').Value := Self.txtRelDeb[1].Text;
        DataSet.FieldByName('Depto_Deb').Value := Self.txtDeptDeb[0].Text;
      end;
      if isDataValida(txtDtCredito.Text) then begin
        DataSet.FieldByName('Cod_Cred').Value := Self.txtCodCred[3].Text;
        DataSet.FieldByName('Rel_Cred').Value := Self.txtRelCred[2].Text;
        DataSet.FieldByName('Depto_Cred').Value := Self.txtDeptCred[0].Text;
      end;
      DataSet.UpdateRecord;
//      GravaLog4(AlterarManual.Data1.DataSource.DataSet, 'Alteração');
      GravaLog4(AlterarManual.Data1_DataSet, 'Alteração');
    end;

    if LinhaAtual > 0 then
//      AlterarManual.Data1.DataSource.AbsolutePosition := LinhaAtual-1;
      AlterarManual.Data1_DataSet.RecNo := LinhaAtual-1;

    AlterarManual.Data1_DataSet.Close;
    AlterarManual.Data1_DataSet.Open;

//    AlterarManual.DbGrid.Redraw := true;
    AlterarManual.DbGrid.DataSource.DataSet.EnableControls;
    Close;
    Exit;

  except on E:exception do  // Erro:
    ShowMessage(E.Message);
    { Resume Next }
  end;
end;

procedure TAlterar1Manual.FormShow(Sender: TObject);
Var
  xData : TDateTime;
begin
  CenterForm(Self);

  try  // On Error GoTo Erro

    if Length(AlterarManual.Data1.DataSource.DataSet.FieldByName('Data_Debito').Value)>0 then begin
      sDtDebito := AlterarManual.Data1.DataSource.DataSet.FieldByName('Data_Debito').Value;
     end  else  begin
      sDtDebito := '';
    end;
    if Length(AlterarManual.Data1.DataSource.DataSet.FieldByName('Data_Credito').Value)>0 then begin
      sDtCredito := AlterarManual.Data1.DataSource.DataSet.FieldByName('Data_Credito').Value;
     end  else  begin
      sDtCredito := '';
    end;

    txtDtDebito.Text := sDtDebito;
    txtDtCredito.Text := sDtCredito;

    txtNroCartao.Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Cartao').Value;
    txtVlDebito.Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('VL_DebitoReal').Value;
    txtVlCredito.Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Vl_CreditoReal').Value;
    txtVariacao.Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Variacao').Value;

    txtDD[0].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Vl_DebitoDolar').Value;
    txtTD[0].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Taxa_Debito').Value;
    Self.txtDD[2].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Vl_CreditoDolar').Value;
    txtTD[1].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Taxa_Credito').Value;

    txtDtCredito.Enabled := true;
    txtVlCredito.Enabled := true;
    txtDtDebito.Enabled := true;
    txtVlDebito.Enabled := true;

    if gNivel<cADM then begin
      if TryStrToDate(sDtCredito, xData) then
        begin
        txtDtCredito.Enabled := false;
        txtVlCredito.Enabled := false;
        Self.txtCodCred[3].Enabled := false;
        Self.txtRelCred[2].Enabled := false;
        end;
      if TryStrToDate(sDtDebito, xData) then
        begin
        txtDtDebito.Enabled := false;
        txtVlDebito.Enabled := false;
        Self.txtCodDeb[3].Enabled := false;
        Self.txtRelDeb[1].Enabled := false;
        end;
    end;
    // Alterações visando a implementação da CONTABILIDADE
    if Length(Trim(AlterarManual.Data1.DataSource.DataSet.FieldByName('Obs_Deb').Value))>0 then begin
      Self.txtObsDeb.Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Obs_Deb').Value;
    end;

    if Length(Trim(AlterarManual.Data1.DataSource.DataSet.FieldByName('Obs_Cred').Value))>0 then begin
      Self.txtObsCred.Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Obs_Cred').Value;
    end;

    Self.txtCodDeb[3].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Cod_Deb').Value;
    Self.txtCodCred[3].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Cod_Cred').Value;

    Self.txtRelDeb[1].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Rel_Deb').Value;
    Self.txtRelCred[2].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Rel_Cred').Value;

    Self.txtDeptDeb[0].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Depto_Deb').Value;
    Self.txtDeptCred[0].Text := AlterarManual.Data1.DataSource.DataSet.FieldByName('Depto_Cred').Value;

    with AlterarManual.Data1.DataSource do begin
      gSalva.Data_Debito := 0; // '00:00:00';
      gSalva.Data_Credito := 0; //'00:00:00';
//      if not IsNull(DataSet.FieldByName('Data_Debito').Value) then
      if not (DataSet.FieldByName('Data_Debito').Value=Null) then
        gSalva.Data_Debito := DataSet.FieldByName('Data_Debito').Value;
      if not (DataSet.FieldByName('Data_Credito').Value=Null) then
        gSalva.Data_Credito := DataSet.FieldByName('Data_Credito').Value;
      gSalva.Cartao := DataSet.FieldByName('cartao').Value;
      gSalva.Vl_DebitoDolar := DataSet.FieldByName('Vl_DebitoDolar').Value;
      gSalva.Taxa_Debito := DataSet.FieldByName('Taxa_Debito').Value;
      gSalva.Vl_CreditoDolar := DataSet.FieldByName('Vl_CreditoDolar').Value;
      gSalva.Taxa_Credito := DataSet.FieldByName('Taxa_Credito').Value;
      gSalva.Vl_DebitoReal := DataSet.FieldByName('Vl_DebitoReal').Value;
      gSalva.Vl_CreditoReal := DataSet.FieldByName('Vl_CreditoReal').Value;
      gSalva.Variacao := DataSet.FieldByName('Variacao').Value;
      gSalva.Vl_Saldo := DataSet.FieldByName('Vl_Saldo').Value;

      // Alterações visando a implementação da CONTABILIDADE
      gSalva.Cod_Deb := DataSet.FieldByName('Cod_Deb').Value;
      gSalva.Cod_Cred := DataSet.FieldByName('Cod_Cred').Value;
      gSalva.Rel_Deb := DataSet.FieldByName('Rel_Deb').Value;
      gSalva.Rel_Cred := DataSet.FieldByName('Rel_Cred').Value;
      gSalva.Rel_Deb := DataSet.FieldByName('Rel_Deb').Value;
      gSalva.Rel_Cred := DataSet.FieldByName('Rel_Cred').Value;
      gSalva.Obs_Deb := DataSet.FieldByName('Obs_Deb').Value;
      gSalva.Obs_Cred := DataSet.FieldByName('Obs_Cred').Value;

    end;
    Exit;
  except on E:Exception do  // Erro:
//    if Err.Number=94 then { Resume Next }
    ShowMessage(E.Message);
  end;
end;

procedure TAlterar1Manual.txtObsCredKeyPress(Sender: TObject; var Key: char);
begin
  if Length(txtObsCred.Text)>40 then begin
    ShowMessage('Mensagem maior que o limite!!!');
    txtObsCred.Text := Copy(txtObsCred.Text, 1, 40);
  end;

end;

procedure TAlterar1Manual.txtObsDebKeyDown(Sender: TObject; var KeyCode: WORD; Shift: TShiftState);
begin
  if Length(txtObsDeb.Text)>40 then begin
    ShowMessage('Mensagem maior que o limite!!!');
    txtObsDeb.Text := Copy(txtObsDeb.Text, 1, 40);
  end;
end;

procedure TAlterar1Manual.FormCreate(Sender: TObject);
begin
  ZeroMemory(@txtDeptCred, SizeOf(txtDeptCred));
  txtDeptCred[0] := txtDeptCred_0;

  ZeroMemory(@txtDeptDeb, SizeOf(txtDeptDeb));
  txtDeptDeb[0] := txtDeptDeb_0;

  ZeroMemory(@txtCodDeb, SizeOf(txtCodDeb));
  txtCodDeb[3] := txtCodDeb_3;

  ZeroMemory(@txtCodCred, SizeOf(txtCodCred));
  txtCodCred[3] := txtCodCred_3;

  ZeroMemory(@txtRelDeb, SizeOf(txtRelDeb));
  txtRelDeb[1] := txtRelDeb_1;

  ZeroMemory(@txtRelCred, SizeOf(txtRelCred));
  txtRelCred[2] := txtRelCred_2;

  ZeroMemory(@txtTD, SizeOf(txtTD));
  txtTD[1] := txtTD_1;
  txtTD[0] := txtTD_0;

  ZeroMemory(@txtDD, SizeOf(txtDD));
  txtDD[2] := txtDD_2;
  txtDD[0] := txtDD_0;
end;

end.
