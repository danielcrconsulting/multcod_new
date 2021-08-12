unit Incluir_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows;


type
  TIncluir = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Label4:  TLabel;
    Label5:  TLabel;
    Label6:  TLabel;
    Label7:  TLabel;
    Label8:  TLabel;
    Label9:  TLabel;
    Label10:  TLabel;
    Label11:  TLabel;
    Label18:  TLabel;
    Label17:  TLabel;
    Label16:  TLabel;
    Label15:  TLabel;
    Label14:  TLabel;
    Label13:  TLabel;
    txtDtDebito:  TEdit;
    txtDtCredito:  TEdit;
    txtNroCartao:  TEdit;
    txtVlDebito:  TEdit;
    txtVlCredito:  TEdit;
    cmdGravar:  TButton;
    cmdCancel:  TButton;
    txtDD_0:  TEdit;
    txtTD_0:  TEdit;
    txtCD:  TEdit;
    txtTD_1:  TEdit;
    txtObsDeb:  TEdit;
    txtObsCred:  TEdit;
    txtDeptCred_0:  TEdit;
    txtDeptDeb_0:  TEdit;
    txtCodDeb_3:  TEdit;
    txtCodCred_3:  TEdit;
    txtRelDeb_1:  TEdit;
    txtRelCred_2:  TEdit;

    procedure cmdCancelClick(Sender: TObject);
    procedure cmdGravarClick(Sender: TObject);
    procedure LimpaTela();
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

    txtRelCred:  array[0..2] of TEdit;  // Control array
    txtRelDeb:  array[1..2] of TEdit;  // Control array
    txtCodCred:  array[0..3] of TEdit;  // Control array
    txtCodDeb:  array[0..3] of TEdit;  // Control array
    txtDeptDeb:  array[0..0] of TEdit;  // Control array
    txtDeptCred:  array[0..0] of TEdit;  // Control array
    txtTD:  array[0..1] of TEdit;  // Control array
    txtDD:  array[0..0] of TEdit;  // Control array

  end;

var
  Incluir: TIncluir;

implementation

uses  Dialogs, SysUtils, Module1, VBto_Converter, AdoDB, RotGerais;

{$R *.dfm}

 //=========================================================
procedure TIncluir.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TIncluir.cmdGravarClick(Sender: TObject);
label
  Erro;
var
  ClienteAdoConnection : TAdoConnection;
  RsDb : TAdoDataSet;

begin
  try  // On Error GoTo Erro

    // Verificar se data debito tem que ter valor débito
    // Verificar se data crédito tem que ter valor crédito
    // Se houver os dois valores tem que ser iguais

    if txtVlCredito.Text='' then txtVlCredito.Text := '0';
    if txtVlDebito.Text='' then txtVlDebito.Text := '0';
    // Verifica Nro do Cartão
    if ( not IsStringNum(txtNroCartao.Text)) or (Length(Trim(txtNroCartao.Text))<>16) then begin
      Application.MessageBox('Número do Cartão inválido. Digite novamente.', '', MB_ICONSTOP);
      txtNroCartao.SetFocus();
      Exit;
    end;
    // Verifica se foi digitada uma data
    if ( not isDataValida(txtDtDebito.Text)) and ( not isDataValida(txtDtCredito.Text)) then begin
      Application.MessageBox('Data inválida. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
      txtDtDebito.SetFocus();
      Exit;
    end;
    // Verifica se as datas são válida e se os valores correspondentes foram digitados
    if isDataValida(txtDtDebito.Text) then begin
      if ( not isValorValido(txtVlDebito.Text)) then begin
        Application.MessageBox('Valor do Debito inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtVlDebito.SetFocus();
        Exit;
      end;
      if Self.txtCodDeb[3].Text='' then begin
        Application.MessageBox('Digite O Código do débito.', PCHAR(Self.Caption), MB_ICONSTOP);
        Self.txtCodDeb[3].SetFocus();
        Exit;
      end;
      if Self.txtRelDeb[1].Text='' then begin
        Application.MessageBox('Digite O Relatório do débito.', PCHAR(Self.Caption), MB_ICONSTOP);
        Self.txtRelDeb[1].SetFocus();
        Exit;
      end;
      if Self.txtDeptDeb[0].Text='' then begin
        Application.MessageBox('Digite O Depto do débito.', PCHAR(Self.Caption), MB_ICONSTOP);
        Self.txtDeptDeb[0].SetFocus();
        Exit;
      end;
    end;

    if isDataValida(txtDtCredito.Text) then begin
      if  not isValorValido(txtVlCredito.Text) then begin
        Application.MessageBox('Valor do Crédito inválido. Digite novamente.', PCHAR(Self.Caption), MB_ICONSTOP);
        txtVlCredito.SetFocus;
        Exit;
      end;
      if Self.txtCodCred[3].Text='' then begin
        Application.MessageBox('Digite O Código do débito.', PCHAR(Self.Caption), MB_ICONSTOP);
        Self.txtCodCred[3].SetFocus;
        Exit;
      end;
      if Self.txtRelCred[2].Text='' then begin
        Application.MessageBox('Digite O Relatório do crédito.', PCHAR(Self.Caption), MB_ICONSTOP);
        Self.txtRelDeb[2].SetFocus;
        Exit;
      end;
      if Self.txtDeptCred[0].Text='' then begin
        Application.MessageBox('Digite O Depto do débito.', PCHAR(Self.Caption), MB_ICONSTOP);
        Self.txtDeptCred[0].SetFocus;
        Exit;
      end;
    end;
    // Se existir debito e crédito, os valores devem ser iguais
    if (isDataValida(txtDtDebito.Text)) and (isDataValida(txtDtCredito.Text)) then begin
      if Trim(txtVlDebito.Text)<>Trim(txtVlCredito.Text) then begin
        if Application.MessageBox('Confirma Alteração com valores Diferentes(DB/CRD)?', 'Excluir Registros', MB_YESNO)=IDNO then begin
          // MsgBox "Valor do Credito diferente do Valor do Debito. Digite novamente.", vbCritical
          Exit;
        end;
      end;
    end;

    // Excluido em 18/12/2000 - Pedido do Jonas com apoio do Daniel
    // If (isDataMenorIgual_Igual(txtDtDebito.Text, txtDtCredito.Text)) Then
    // If (Len(txtDtDebito) > 0) And (Len(txtDtCredito) > 0) Then
    // Testar se data de débito < data de crédito
    // MsgBox "Data do Credito MENOR que data do Debito. Digite novamente.", vbCritical
    // Exit Sub
    // End If
    // End If
    // Os dados estão válidos, GRAVAR

    if Length(txtVlDebito.Text)=0 then
      txtVlDebito.Text := '0';
    if Length(txtVlCredito.Text)=0 then
      txtVlCredito.Text := '0';

    sSql := 'Select * from [Lancamentos]';
    if Length(txtDtDebito.Text)<>0 then
      begin
      sSql := sSql+' where str(Data_Debito) = '#39''+txtDtDebito.Text+''#39'';
      if Length(txtDtCredito.Text)<>0 then
        sSql := sSql+' and str(Data_Credito) = '#39''+txtDtCredito.Text+''#39'';
      end
    else
      // sSql = sSql & " where Data_Credito = '" & dDataCred & "'"
      sSql := sSql+' where str(Data_Credito) = '#39''+txtDtCredito.Text+''#39'';

    sSql := sSql+' and Cartao = '#39''+txtNroCartao.Text+''#39'';

    Conecta(ClienteAdoConnection, gDataPath + gDataFile + '.udl');

    RsDb := TAdoDataSet.Create(nil);
    RsDb.Connection := ClienteAdoConnection;

    RsDb.CommandText := sSql;
    RsDb.Open;

//    RsDb := gBanco.OpenRecordset(sSql);

    with RsDb do begin
      gNegativo := false;
      Insert;
      if isDataValida(txtDtDebito.Text) then begin
        VBtoADOFieldSet(RsDb, 'Data_Debito', txtDtDebito.Text);
        VBtoADOFieldSet(RsDb, 'Rel_Deb', 'MANUAL');
        VBtoADOFieldSet(RsDb, 'Cod_Deb', Self.txtCodDeb[3].Text);
        VBtoADOFieldSet(RsDb, 'Depto_Deb', Self.txtDeptDeb[0].Text);
      end;
      if isDataValida(txtDtCredito.Text) then begin
        VBtoADOFieldSet(RsDb, 'Data_Credito', txtDtCredito.Text);
        VBtoADOFieldSet(RsDb, 'Rel_Cred', 'MANUAL');
        VBtoADOFieldSet(RsDb, 'Cod_Cred', Self.txtCodCred[3].Text);
        VBtoADOFieldSet(RsDb, 'Depto_Cred', Self.txtDeptCred[0].Text);
      end;
      VBtoADOFieldSet(RsDb, 'Cliente', gCliente);
      VBtoADOFieldSet(RsDb, 'conta_contabil', Trim(Concil.ContaContabil));
      VBtoADOFieldSet(RsDb, 'Cartao', TiraPontos(txtNroCartao.Text, IntToStr(16)));
      VBtoADOFieldSet(RsDb, 'Cartao1', TiraPontos(txtNroCartao.Text, IntToStr(13)));

//      VBtoADOFieldSet(RsDb, 'Vl_DebitoDolar', FormataValor(Self.txtDD[0].Text));
      VBtoADOFieldSet(RsDb, 'Vl_DebitoDolar', StrToFloat(Self.txtDD[0].Text));
      if Self.txtTD[0].Text<>'' then VBtoADOFieldSet(RsDb, 'Taxa_Debito', StrToFloat(Self.txtTD[0].Text));
      VBtoADOFieldSet(RsDb, 'Vl_CreditoDolar', StrToFloat(Self.txtCD.Text));
      if Self.txtTD[1].Text<>'' then VBtoADOFieldSet(RsDb, 'Taxa_Credito', StrToFloat(Self.txtTD[1].Text));

      VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', StrToFloat(txtVlDebito.Text));
      VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', StrToFloat(txtVlCredito.Text));

      VBtoADOFieldSet(RsDb, 'Vl_Saldo', FieldByName('Vl_DebitoReal').AsExtended - FieldByName('Vl_CreditoReal').AsExtended);

      VBtoADOFieldSet(RsDb, 'Dias_Pendentes', 0);

      // Alterações visando a implementação da CONTABILIDADE
      VBtoADOFieldSet(RsDb, 'Obs_Deb', Self.txtObsDeb.Text);
      VBtoADOFieldSet(RsDb, 'Obs_Cred', Self.txtObsCred.Text);

      if Self.txtDD[0].Text='' then Self.txtDD[0].Text := '0';
      if Self.txtTD[0].Text='' then Self.txtTD[0].Text := '0';
      if Self.txtCD.Text='' then Self.txtCD.Text := '0';
      if Self.txtTD[1].Text='' then Self.txtTD[1].Text := '0';

      UpdateRecord;
    end;

    RsDb.Last;
    GravaLog3(RsDb, 'Inclusão');

    // Desconecta

    LimpaTela;

    txtDtDebito.SetFocus;

    RsDb.Close;
    RsDb.Free;
    ClienteAdoConnection.Close;
    ClienteAdoConnection.Free;

  except on E:Exception do  // Erro:
    begin
    ShowMessage(E.Message);
    LimpaTela;
    end;
  end;
end;

procedure TIncluir.LimpaTela();
begin
  Self.txtCD.Text := '';
  Self.txtCodCred[3].Text := '';
  Self.txtCodDeb[3].Text := '';
  Self.txtDD[0].Text := '';
  Self.txtDeptDeb[0].Text := '';
  Self.txtDeptCred[0].Text := '';
  Self.txtDtDebito.Text := '';
  Self.txtDtCredito.Text := '';
  Self.txtNroCartao.Text := '';
  Self.txtObsCred.Text := '';
  Self.txtObsDeb.Text := '';
  Self.txtRelDeb[1].Text := '';
  Self.txtRelCred[2].Text := '';
  Self.txtTD[0].Text := '';
  Self.txtTD[1].Text := '';
  Self.txtVlDebito.Text := '';
  Self.txtVlCredito.Text := '';
end;


procedure TIncluir.FormCreate(Sender: TObject);
begin
  ZeroMemory(@txtRelCred, SizeOf(txtRelCred));
  txtRelCred[2] := txtRelCred_2;

  ZeroMemory(@txtRelDeb, SizeOf(txtRelDeb));
  txtRelDeb[1] := txtRelDeb_1;

  ZeroMemory(@txtCodCred, SizeOf(txtCodCred));
  txtCodCred[3] := txtCodCred_3;

  ZeroMemory(@txtCodDeb, SizeOf(txtCodDeb));
  txtCodDeb[3] := txtCodDeb_3;

  ZeroMemory(@txtDeptDeb, SizeOf(txtDeptDeb));
  txtDeptDeb[0] := txtDeptDeb_0;

  ZeroMemory(@txtDeptCred, SizeOf(txtDeptCred));
  txtDeptCred[0] := txtDeptCred_0;

  ZeroMemory(@txtTD, SizeOf(txtTD));
  txtTD[1] := txtTD_1;
  txtTD[0] := txtTD_0;

  ZeroMemory(@txtDD, SizeOf(txtDD));
  txtDD[0] := txtDD_0;
end;

end.
