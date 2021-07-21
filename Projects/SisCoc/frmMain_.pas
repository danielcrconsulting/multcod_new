unit frmMain_;

interface

uses  Forms, Classes, Controls, ExtCtrls, ComCtrls, Menus, Dialogs, Windows,
  Graphics, DB, ADODB, Vcl.StdCtrls;


type
  TfMainForm = class(TForm)
    FormBackgroundImage:  TImage;
    sbStatusBar:  TStatusBar;
    dlgCommonDialog:  TOpenDialog;
    mMainMenu1:  TMainMenu;
    mnuManut1:  TMenuItem;
    mnuGC:  TMenuItem;
    mnuTC:  TMenuItem;
    mnuTCInc:  TMenuItem;
    mnuTCAlterar:  TMenuItem;
    mnuTCExcl:  TMenuItem;
    mnuCCConsultar:  TMenuItem;
    mnuCadBIN:  TMenuItem;
    mnuConvMes:  TMenuItem;
    mnuRotMes:  TMenuItem;
    mnuEPB:  TMenuItem;
    mnuRestaura:  TMenuItem;
    mnuNovoCli:  TMenuItem;
    mnuNovo:  TMenuItem;
    mnuNCAlt:  TMenuItem;
    mnuNCCon:  TMenuItem;
    mnuCadUsuario:  TMenuItem;
    cmdCadPaths:  TMenuItem;
    cmdAlteraPath:  TMenuItem;
    cmdConPath:  TMenuItem;
    mnuTeste1:  TMenuItem;
    mnuClientes:  TMenuItem;
    mnuCliente_0:  TMenuItem;
    mnuCliente_1:  TMenuItem;
    mnuCliente_2:  TMenuItem;
    mnuCliente_3:  TMenuItem;
    mnuCliente_4:  TMenuItem;
    mnuCliente_5:  TMenuItem;
    mnuCliente_6:  TMenuItem;
    mnuCliente_7:  TMenuItem;
    mnuCliente_8:  TMenuItem;
    mnuCliente_9:  TMenuItem;
    mnuCliente_10:  TMenuItem;
    mnuCliente_11:  TMenuItem;
    mnuCliente_12:  TMenuItem;
    mnuCliente_13:  TMenuItem;
    mnuCliente_14:  TMenuItem;
    mnuCliente_15:  TMenuItem;
    mnuCliente_16:  TMenuItem;
    mnuCliente_17:  TMenuItem;
    mnuCliente_18:  TMenuItem;
    mnuCliente_19:  TMenuItem;
    mnuCliente_20:  TMenuItem;
    mnuCliente_21:  TMenuItem;
    mnuTipoCon:  TMenuItem;
    mnu1_1:  TMenuItem;
    mnu1_2:  TMenuItem;
    mnu1_3:  TMenuItem;
    mnu1_4:  TMenuItem;
    mnu1_5:  TMenuItem;
    mnu1_6:  TMenuItem;
    mnu1_7:  TMenuItem;
    mnu1_8:  TMenuItem;
    mnu1_9:  TMenuItem;
    mnuArquivo:  TMenuItem;
    mnuAtualiza:  TMenuItem;
    mnuDD:  TMenuItem;
    mnuDDInc:  TMenuItem;
    mnuDDAlt:  TMenuItem;
    mnuDDExcl:  TMenuItem;
    mnuADCons:  TMenuItem;
    mnuGM:  TMenuItem;
    mnuJuncao:  TMenuItem;
    mnuJuncaoJuntados:  TMenuItem;
    mnuGBB:  TMenuItem;
    mnuNormal:  TMenuItem;
    mnuBat:  TMenuItem;
    mnuAtGeral:  TMenuItem;
    mnuAualiza:  TMenuItem;
    mnuAgenda:  TMenuItem;
    mnuAjuste:  TMenuItem;
    mnuAMAlterar:  TMenuItem;
    mnuALAGeral:  TMenuItem;
    mnuALAPendencias:  TMenuItem;
    AtComp:  TMenuItem;
    mnuSep1:  TMenuItem;
    mnuInterface:  TMenuItem;
    mnuBkp:  TMenuItem;
    mnuLog:  TMenuItem;
    mnuSepLog:  TMenuItem;
    mnuBkpMensal:  TMenuItem;
    mnuConf:  TMenuItem;
    mnuNotas:  TMenuItem;
    mnuTeste:  TMenuItem;
    mnuRelatorios:  TMenuItem;
    mnuSDia:  TMenuItem;
    mnuSaldoCont:  TMenuItem;
    mnuBa:  TMenuItem;
    mnuBGeral:  TMenuItem;
    mnuOdata:  TMenuItem;
    mnuGODSem:  TMenuItem;
    mnuGODCom:  TMenuItem;
    mnuOcartao:  TMenuItem;
    mnuGOOSem:  TMenuItem;
    mnuGOOCom:  TMenuItem;
    mnuBPeriodo:  TMenuItem;
    mnuOdata2:  TMenuItem;
    mnuGPODSem:  TMenuItem;
    mnuGPODCom:  TMenuItem;
    mnuOcartao2:  TMenuItem;
    mnuGPOCSem:  TMenuItem;
    mnuGPOCCom:  TMenuItem;
    mnuPend:  TMenuItem;
    mnuPGeral:  TMenuItem;
    mnuOdata3:  TMenuItem;
    mnuPGODSem:  TMenuItem;
    mnuPGODCom:  TMenuItem;
    mnuOcartao3:  TMenuItem;
    mnuPOCSem:  TMenuItem;
    mnuPOCCom:  TMenuItem;
    mnuPPeriodo:  TMenuItem;
    mnuOdata4:  TMenuItem;
    mnuPPODSem:  TMenuItem;
    mnuPPODCom:  TMenuItem;
    mnuOcartao4:  TMenuItem;
    mnuPPOCSem:  TMenuItem;
    mnuPPOCCom:  TMenuItem;
    mnuVariac:  TMenuItem;
    mnuVarGer:  TMenuItem;
    mnuVarMes:  TMenuItem;
    mnuVarPend:  TMenuItem;
    mnuExcell:  TMenuItem;
    mnuGAESem:  TMenuItem;
    mnuGAECom:  TMenuItem;
    mnuExcelGeral:  TMenuItem;
    mnuEXGerSem:  TMenuItem;
    mnuEXGerCom:  TMenuItem;
    mnuCBD:  TMenuItem;
    mnuHistorico:  TMenuItem;
    mnuCBDGeral:  TMenuItem;
    mnuCBDPendencias:  TMenuItem;
    mnuInterf:  TMenuItem;
    mnuInterfCon:  TMenuItem;
    mnuInterfSaci:  TMenuItem;
    mnuCopyFile:  TMenuItem;
    mnuSair:  TMenuItem;
    gBanco: TADOConnection;
    RsDbDs: TADODataSet;
    RsTb: TADOTable;
    RsDbQry: TADOQuery;
    gBancoCli: TADOConnection;
    RsDbQryCli: TADOQuery;
    RsDbDsCli: TADODataSet;
    RsTb2: TADOTable;
    RsDbQry2: TADOQuery;
    Edit1: TEdit;

    procedure AtCompClick(Sender: TObject);
    procedure cmdAlteraPathClick(Sender: TObject);
    procedure cmdConPathClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnu1_1Click(Sender: TObject);
    procedure mnu1_2Click(Sender: TObject);
    procedure mnu1_3Click(Sender: TObject);
    procedure mnu1_4Click(Sender: TObject);
    procedure mnu1_5Click(Sender: TObject);
    procedure mnu1_6Click(Sender: TObject);
    procedure mnu1_7Click(Sender: TObject);
    procedure mnu1_8Click(Sender: TObject);
    procedure mnu1_9Click(Sender: TObject);
    procedure mnuADConsClick(Sender: TObject);
    procedure mnuAgendaClick(Sender: TObject);
    procedure mnuAjusteClick(Sender: TObject);
    procedure mnuALAGeralClick(Sender: TObject);
    procedure mnuALAPendenciasClick(Sender: TObject);
    procedure mnuAtGeralClick(Sender: TObject);
    procedure mnuAualizaClick(Sender: TObject);
    procedure mnuBatClick(Sender: TObject);
    procedure mnuBkpClick(Sender: TObject);
    procedure mnuBkpMensalClick(Sender: TObject);
    procedure mnuCBDGeralClick(Sender: TObject);
    procedure mnuCBDPendenciasClick(Sender: TObject);
    procedure mnuCliente_0Click(Sender: TObject);
    procedure mnuCliente_1Click(Sender: TObject);
    procedure mnuCliente_2Click(Sender: TObject);
    procedure mnuCliente_3Click(Sender: TObject);
    procedure mnuCliente_4Click(Sender: TObject);
    procedure mnuCliente_5Click(Sender: TObject);
    procedure mnuCliente_6Click(Sender: TObject);
    procedure mnuCliente_7Click(Sender: TObject);
    procedure mnuCliente_8Click(Sender: TObject);
    procedure mnuCliente_9Click(Sender: TObject);
    procedure mnuCliente_10Click(Sender: TObject);
    procedure mnuCliente_11Click(Sender: TObject);
    procedure mnuCliente_12Click(Sender: TObject);
    procedure mnuCliente_13Click(Sender: TObject);
    procedure mnuCliente_14Click(Sender: TObject);
    procedure mnuCliente_15Click(Sender: TObject);
    procedure mnuCliente_16Click(Sender: TObject);
    procedure mnuCliente_17Click(Sender: TObject);
    procedure mnuCliente_18Click(Sender: TObject);
    procedure mnuCliente_19Click(Sender: TObject);
    procedure mnuCliente_20Click(Sender: TObject);
    procedure mnuCliente_21Click(Sender: TObject);
    procedure mnuConfClick(Sender: TObject);
    procedure mnuCopyFileClick(Sender: TObject);
    procedure mnuEPBClick(Sender: TObject);
    procedure mnuEXGerComClick(Sender: TObject);
    procedure mnuEXGerSemClick(Sender: TObject);
    procedure GeraExcel(ComSem: Boolean);
    procedure GeraLista;
    procedure mnuGAEComClick(Sender: TObject);
    procedure mnuGAESemClick(Sender: TObject);
    procedure mnuDDAltClick(Sender: TObject);
    procedure mnuDDExclClick(Sender: TObject);
    procedure mnuDDIncClick(Sender: TObject);
    procedure mnuGMClick(Sender: TObject);
    procedure mnuGODComClick(Sender: TObject);
    procedure mnuGODSemClick(Sender: TObject);
    procedure mnuGOOComClick(Sender: TObject);
    procedure mnuGOOSemClick(Sender: TObject);
    procedure mnuGPOCComClick(Sender: TObject);
    procedure mnuGPOCSemClick(Sender: TObject);
    procedure mnuGPODComClick(Sender: TObject);
    procedure mnuGPODSemClick(Sender: TObject);
    procedure mnuHistoricoClick(Sender: TObject);
    procedure mnuInterfaceClick(Sender: TObject);
    procedure mnuInterfConClick(Sender: TObject);
    procedure mnuInterfSaciClick(Sender: TObject);
    procedure mnuJuncaoClick(Sender: TObject);
    procedure mnuJuncaoJuntadosClick(Sender: TObject);
    procedure mnuLogClick(Sender: TObject);
    procedure mnuNCAltClick(Sender: TObject);
    procedure mnuNCConClick(Sender: TObject);
    procedure mnuNormalClick(Sender: TObject);
    procedure mnuNotasClick(Sender: TObject);
    procedure mnuNovoClick(Sender: TObject);
    procedure mnuPGODComClick(Sender: TObject);
    procedure mnuPGODSemClick(Sender: TObject);
    procedure mnuPOCComClick(Sender: TObject);
    procedure mnuPOCSemClick(Sender: TObject);
    procedure mnuPPOCComClick(Sender: TObject);
    procedure mnuPPOCSemClick(Sender: TObject);
    procedure mnuPPODComClick(Sender: TObject);
    procedure mnuPPODSemClick(Sender: TObject);
    procedure mnuRestauraClick(Sender: TObject);
    procedure mnuRotMesClick(Sender: TObject);
    procedure mnuSairClick(Sender: TObject);
    procedure mnuSaldoContClick(Sender: TObject);
    procedure mnuSDiaClick(Sender: TObject);
    procedure mnuTCAlterarClick(Sender: TObject);
    procedure mnuTCExclClick(Sender: TObject);
    procedure mnuTCIncClick(Sender: TObject);
    procedure mnuTeste1Click(Sender: TObject);
    procedure mnuVarGerClick(Sender: TObject);
    procedure mnuVarMesClick(Sender: TObject);
    procedure mnuVarPendClick(Sender: TObject);
    procedure BatimentoConta();
    //procedure BatimentoConta2();
    //procedure GravaRecX(Buf: String; sDebito: OleVariant; sCredito: OleVariant);
    procedure ContasResultado(Var NomeArquivo : String);
    procedure GravaRec3(Buf: String; sDebito: TField; sCredito: TField; Var RsDb : TAdoQuery);
    //function TestaRec4(Buffer: String): Boolean;
    procedure GravaRec4(Buffer: String; Var RsDb: TAdoTable);
    function getDataFromNome(sNome: String): String;
    procedure mnuCadUsuarioClick(Sender: TObject);
    procedure mnuConvMesClick(Sender: TObject);
    procedure mnuCadBINClick(Sender: TObject);
    procedure mnuGCClick(Sender: TObject);
    procedure mnuCCConsultarClick(Sender: TObject);

  private
    { Private declarations }

    procedure mnu1Click(Index: Smallint; Sender: TObject);
    procedure mnuClienteClick(Index: Smallint; Sender: TObject);
    procedure AbreMenu(Menu: Integer);

  public
    { Public declarations }

    Procedure MontaMenus;
    Procedure MontaBinGeral;

  end;

var
  fMainForm: TfMainForm;
  Buffer : Array[1..10000000] of Char;

implementation

uses  SysUtils, StrUtils, Module1, DataMov_, RotGerais, frmLog_, frmPath_, SimulaMenu_, Consulta_, frmAgenda_, frmAgenda1_,
  frmMes_, AlterarManual_, Incluir_, Alterar_Consulta_, ConsultaCon_,
  ConsultaCvMes_, Periodo_, PBar_, DataLimite_, atMoeda_, frmGeraMov_, Historico_, frmJuncao_, DataDeAte_,
  NovoClienteAlt_, frmBaixaBanco_, frmRelease_, NovoCliente_, frmAbout_, TipoConAdm_, frmMes1_,
  VBto_Converter, FileHandles, DataModuleFormUnit, Types, IoUtils, IdGlobalProtocols, PedeAlteraca;

{$R *.dfm}

 //=========================================================
procedure TfMainForm.AtCompClick(Sender: TObject);
var
  Buffer, Buffer1, buffer2,
  sSql: String;
  I: Integer;
  NomeTmp,
  NomeArquivo: String;
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  // gDataRelatorio = ""
  DataMov.ShowModal;
  if  not isDataValida(gDataRelatorio) then
    Exit;

//  if  not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

  // sSql = "select * from tb_moeda where strdata) = '" &

  sSql := 'select * from tb_moeda where str(data) = '#39''+DateToStr(gDataRelatorio) + ''#39'';
//  sSql := sSql+' or str(data)= '#39''+dataDezBarra(gDataRelatorio)+''#39'';
  sSql := sSql+' or str(data)= '#39'' + DateToStr(gDataRelatorio)+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);

  RsDbQry.Open;

  if RsDbQry.EOF then
    begin
    ShowMessage('Dolar não está cadastrado');
    RsDbQry.Close;
    Exit;
    end;

  gTaxa := RsDbQry.FieldByName('valor').Value;
  //Desconecta();
  RsDbQry.Close;
  gBanco.Close;

//  NomeArquivo := GetPath()+'\';
  NomeArquivo := ExtractFileDir(Application.ExeName) + '\';
  // NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ArqEntrada)
  NomeArquivo := NomeArquivo+gCliente+'\entrada\'+'JUNTADO';
  // NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ContaContabil)
  NomeArquivo := NomeArquivo+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeArquivo := NomeArquivo+'.txt';

  NomeTmp := ExtractFileDir(Application.ExeName) + '\';
  NomeTmp := NomeTmp+gCliente+'\entrada\'+Trim(Concil.ContaContabil);
  NomeTmp := NomeTmp+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeTmp := NomeTmp+'.tmp';

  if GeraTemp(NomeTmp, NomeArquivo) then
    begin
    NomeArquivo := TiraExt(NomeArquivo)+'.tmp';
    NomeArquivo := NomeTmp;
    end
  else
    Exit;

  gArquivo11 := '';
  frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+(Concil.ContaContabil)+' - '+gConciliacao+#10+'     Débitos    Créditos       Saldo'+#10+#10;
  gAutomatico := false;
  gTotDebito := 0;
  gTotCredito := 0;
  gSaldo := FloatToStr(GetSaldo());
  if Concil.Natureza='D' then
    begin
    // Processa primeiro Dolar
    for I:=0 to ncDebito-1 do
      begin
      if  not DataModule.ContaDebitoComp(I, '840', NomeArquivo) then
        Exit;
      end; // I
    for I:=0 to ncCredito-1 do begin
      if  not DataModule.ContaCreditoComp(I, '840', NomeArquivo) then Exit;
    end; // I

    for I:=0 to ncDebito-1 do begin
      if  not DataModule.ContaDebitoComp(I, '986', NomeArquivo) then Exit;
    end; // I
    for I:=0 to ncCredito-1 do begin
      if  not DataModule.ContaCreditoComp(I, '986', NomeArquivo) then Exit;
    end; // I
   end  else  begin
    // Processa primeiro Dolar
    for I:=0 to ncCredito-1 do begin
      if  not DataModule.ContaCreditoComp(I, '840', NomeArquivo) then Exit;
    end; // I
    for I:=0 to ncDebito-1 do begin
      if  not DataModule.ContaDebitoComp(I, '840', NomeArquivo) then Exit;
    end; // I

    for I:=0 to ncCredito-1 do begin
      if  not DataModule.ContaCreditoComp(I, '986', NomeArquivo) then Exit;
    end; // I
    for I:=0 to ncDebito-1 do begin
      if  not DataModule.ContaDebitoComp(I, '986', NomeArquivo) then Exit;
    end; // I
  end;

  // Faz Backup do banco de dados com as novas movimentações
  BackupBanco;

  // Mostra Débitos e Créditos
  Buffer := FormatVB(gTotDebito,'###,##0.00');
  Buffer1 := FormatVB(gTotCredito,'###,##0.00');
  buffer2 := FormatVB(GetSaldo(),'###,##0.00');

  frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+#10+StringOfChar(' ', 15-Length(Buffer))+Buffer+' '+StringOfChar(' ', 15-Length(Buffer1))+Buffer1+' '+StringOfChar(' ', 15-Length(buffer2))+buffer2+#10;

  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close;
  frmLog.ShowModal;

end;

procedure TfMainForm.cmdAlteraPathClick(Sender: TObject);
begin

  if  not Autoriza(cADM) then
    Exit;

  gOpcao := 'altera';
  frmPath.ShowModal;

end;

procedure TfMainForm.cmdConPathClick(Sender: TObject);
begin

  if  not Autoriza(cADM) then
    Exit;

  gOpcao := 'consulta';
  frmPath.ShowModal;

end;

procedure TfMainForm.FormShow(Sender: TObject);
var
  I, J: Smallint;
begin

  Concil.ContaContabil := StringOfChar(' ', 14);

  gAdmPath := ExtractFileDir(Application.ExeName);

  gBanco.Close;
  RsDbQry.Close;

  if  not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

  I := 0;
  sSql := 'select * from tb_grupocon order by cd_grupo_con';
  RsDbQry.SQL.Clear;
  RsDbQry.Sql.Add(sSql);
  RsDbQry.Open;

  SetLength(tbTipoCon, RsDbQry.RecordCount+1);

  while not RsDbQry.EOF do
    begin
    J:=0;
    while (J <= I-1) { for J:=1 to I-1 } do
      begin
      if Trim(tbTipoCon[J].NmGrupo) = RsDbQry.FieldByName('nm_grupo').AsString then
        begin
          // Pega o proximo e testa de novo, pode ter 2 seguidos
        RsDbQry.Next;
        J := 0;
        end;
      Inc(J);
      end; // J

    tbTipoCon[I].Indice := I;
    tbTipoCon[I].Cd_Grupo_Con := RsDbQry.FieldByName('cd_grupo_con').Value;
    tbTipoCon[I].NmGrupo := RsDbQry.FieldByName('nm_grupo').Value;
    Inc(I);
    RsDbQry.Next;
    end;

tbTipoCon[I].NmGrupo := '999999';
gBanco.Close;
RsDbQry.Close;
end;

procedure TfMainForm.mnu1Click(Index: Smallint; Sender: TObject);
var
  I: Longint;
  S: String;
begin
  // Gambi para mostrar todos os Patrimonial ativo juntos
  sSql := 'select * from tb_grupocon where nm_grupo = '#39'';
  sSql := sSql+Trim(tbTipoCon[Index].NmGrupo)+''#39'';
//  if  not Conecta('adm') then Exit;
  if  not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
  RsDbQry.Open;

  // monta string para pegar todos grupos com o mesmo nome

  S := RsDbQry.FieldByName('cd_grupo_con').Value;
  RsDbQry.Next;
  while not RsDbQry.EOF do
    begin
    S := S+''#39' or grupo = '#39''+RsDbQry.FieldByName('cd_grupo_con').AsString;
    RsDbQry.Next;
    end;

//  Desconecta();
  RsDbQry.Close;
//  gBanco.Close;

  sSql := 'select * from tb_opcao where (grupo = '#39'';
  sSql := sSql+S;
  sSql := sSql+''#39') and cliente = '#39''+gCliente+''#39'';

  SimulaMenu.simulSql := sSql;
  SimulaMenu.Caption := mnuTipoCon.Items[1].Caption;  // mnu1[1].Caption;
  gOpcao := '';

  SimulaMenu.ShowModal;
  fMainForm.mnuRelatorios.Enabled := true;
  fMainForm.mnuArquivo.Enabled := true;
  if gOpcao <> '' then
    begin
    fMainForm.mnuClientes.Enabled := true;
    // Me.mnuArquivo.Caption = gOpcao
    gConciliacao := gOpcao;
    end
  else
    begin
    Screen.Cursor := crDefault;
    Exit;
    end;

//  Desconecta();
//  if  not Conecta('adm') then Exit;

  sSql := 'Select * from [tb_tipo_con]';
  sSql := sSql+' where nm_conciliacao = '#39''+gConciliacao+''#39'';
  sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.Close;
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
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
      // Limpeza Automática
    gLimpAuto := RsDbQry.FieldByName('LimpAuto').Value;

      // Concil.ArqEntrada = .Fields("Arq_Entrada")
    Concil.ContaContabil := Trim(RsDbQry.FieldByName('conta_contabil').Value);
    Concil.ContaEmissor := Trim(RsDbQry.FieldByName('cd_cli_banco').Value);
    Concil.Natureza := RsDbQry.FieldByName('Natureza_conta').Value;
    Concil.nome := Trim(RsDbQry.FieldByName('nm_conciliacao').Value);

    gLimiteVariacao := GetLimite(gCliente, (Concil.ContaContabil));

    end
  else
    begin
    ShowMessage('Banco de Dados Vazio ou Corrompido');
//      Desconecta();
    RsDbQry.Close;
    gBanco.Close;
    Screen.Cursor := crDefault;
    Exit;
    end;

//  Desconecta();
//  if  not Conecta('adm') then Exit;

  sSql := '';
  sSql := sSql+'Select * from [tbContasAdm] ';
  sSql := sSql+'Where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39' ';
  sSql := sSql+'And Natureza = '#39'D'#39' ';
  sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
  sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.Close;
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
  RsDbQry.Open;

  ncDebito := 0;
  if not EOF then
    begin
    RsDbQry.Last;
    ncDebito := RsDbQry.RecordCount;
    SetLength(ctDebito, ncDebito+1);
    for I:=0 to ncDebito-1 do
      begin
      ctDebito[I].Conta := '    ';
      ctDebito[I].conta_para := '';
      end; // I
    RsDbQry.First;
    end;

  while not RsDbQry.EOF do
    begin
    ctDebito[RsDbQry.RecNo].Conta := RsDbQry.FieldByName('Codigo').Value;
    ctDebito[RsDbQry.Recno].conta_para := limpaString(RsDbQry.FieldByName('Codigo_Para').AsString);
    RsDbQry.Next;
    end;

  sSql := '';
  sSql := sSql+'Select * from [tbContasAdm] ';
  sSql := sSql+'Where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39' ';
  sSql := sSql+'And Natureza = '#39'C'#39' ';
  sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
  sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.Close;
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
  RsDbQry.Open;

  ncCredito := 0;
  if not RsDbQry.EOF then
    begin
    RsDbQry.Last;
    ncCredito := RsDbQry.RecordCount;
    SetLength(ctCredito, ncCredito+1);
    for I:=0 to ncCredito-1 do
      begin
      ctCredito[I].Conta := '    ';
      ctCredito[I].conta_para := '';
      end; // I
    RsDbQry.First;
    end;

  while not RsDbQry.EOF do
    begin
    ctCredito[RsDbQry.RecNo].Conta := RsDbQry.FieldByName('Codigo').Value;
    ctCredito[RsDbQry.RecNo].conta_para := limpaString(RsDbQry.FieldByName('Codigo_Para').AsString);
    RsDbQry.Next;
    end;

//  Desconecta();
//  if  not Conecta('') then Exit;
  RsDbQry.Close;
  gBanco.Close;

  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

//  sSql := 'Select * from [id]';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsTb.TableName := 'Id';
  RsTb.Filter := '';
  RsTb.Open;

  if RsTb.EOF then
    RsTb.Insert
  else
    RsTb.Edit;

  RsTb.FieldByName('Codigo').AsInteger := Relatorio.CdCliente;
  RsTb.FieldByName('Nome_Cliente').AsString := Relatorio.IdRelatorio;
  // RsDb.Fields("Titulo_Relatorio") = Relatorio.IdRelatorio
  // RsDb.Fields("NomeArquivo") = gArquivo
  RsTb.Post;
  //Desconecta();
  RsTb.Close;
  gBanco.Close;
  mnuArquivo.Enabled := true;
  mnuRelatorios.Enabled := true;
  mnuArquivo.Enabled := true;

  BarraStatus;
  Screen.Cursor := crDefault;

end;

procedure TfMainForm.mnu1_1Click(Sender: TObject);
begin mnu1Click(1, Sender); end;
procedure TfMainForm.mnu1_2Click(Sender: TObject);
begin mnu1Click(2, Sender); end;
procedure TfMainForm.mnu1_3Click(Sender: TObject);
begin mnu1Click(3, Sender); end;
procedure TfMainForm.mnu1_4Click(Sender: TObject);
begin mnu1Click(4, Sender); end;
procedure TfMainForm.mnu1_5Click(Sender: TObject);
begin mnu1Click(5, Sender); end;
procedure TfMainForm.mnu1_6Click(Sender: TObject);
begin mnu1Click(6, Sender); end;
procedure TfMainForm.mnu1_7Click(Sender: TObject);
begin mnu1Click(7, Sender); end;
procedure TfMainForm.mnu1_8Click(Sender: TObject);
begin mnu1Click(8, Sender); end;
procedure TfMainForm.mnu1_9Click(Sender: TObject);
begin mnu1Click(9, Sender); end;

procedure TfMainForm.mnuADConsClick(Sender: TObject);
Var
  sSql : String;
begin
  sSql := 'select data,valor from tb_moeda';
  sSql := sSql + ' order by data desc';
  Consulta.sSqlConsulta := sSql;
  gOpcao := '';
  Consulta.ShowModal;
end;

procedure TfMainForm.mnuAgendaClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

//  if  not Conecta('adm') then Exit;
  if  not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

  sSql := 'select * from tb_tipo_con where conta_contabil = '#39''+TiraPontos((Concil.ContaContabil), IntToStr(2))+''#39'';
  sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  if RsDbDs.EOF then
    begin
    ShowMessage(PChar('Conciliação '+TiraPontos((Concil.ContaContabil), IntToStr(2))+' Inválida'));
//    Desconecta();
    RsDbDs.Close;
    gBanco.Close;
    Exit;
    end;

  if RsDbDs.FieldByName('Agendamento').AsString <> 'S' then
    begin
    Application.MessageBox('Agendamento não permitido para esta Conciliação', 'Seleção de Conciliação', MB_ICONSTOP);
//    Desconecta();
    RsDbDs.Close;
    gBanco.Close;
    Exit;
    end;

  // Pedir Datas
  gData1 := '';
  gData2 := '';
  frmAgenda.ShowModal;
  Application.ProcessMessages;
  if (gData1 <> '') and (gData2 <> '') then
    frmAgenda1.ShowModal;

  RsDbDs.Close;
  gBanco.Close;

end;

procedure TfMainForm.mnuAjusteClick(Sender: TObject);
var
  DbLocal: TAdoConnection; //Database;
  RsLocal: TADOTable;
  Mes, Ano: String;
begin
  // Variação

  if  not Autoriza(cATUALIZA) then
    Exit;

  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  // Pedir Mês
  gData1 := '';
  gData2 := '';
  frmMes.ShowModal;
  Application.ProcessMessages;

  if Length(gData1) > 0 then
    begin
    Mes := Copy(gData1, 1, 2);
    Ano := Copy(gData1, 4, 4);
    if (Mes = '') or (StrToInt(Mes) > 12) then
      begin
      ShowMessage('Data da Variação Inválida.');
      Exit;
      end;
    end;

  if (Length(gData1) > 0) and (not isDataValida(gData2)) then
    begin
    ShowMessage('Data do Lançamento Inválida.');
    Exit;
    end;

  if (Length(gData1) = 0) or (Length(gData2) = 0) then
    Exit;

  // Localizar registros
//  if  not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

//  sSql := 'Select * from [Lancamentos]';
//  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := 'conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and Vl_DebitoReal <> 0';
  sSql := sSql+' and Vl_CreditoReal <> 0';
  sSql := sSql+' and Vl_Saldo <> 0';
  // If Concil.Natureza = "D" Then
  sSql := sSql+' and (( month(Data_Credito) =  ' + Mes;
  sSql := sSql+' and year(Data_Credito) =  ' + Ano;
  sSql := sSql+' and Data_Credito >= Data_Debito ' + ')';
  // Else
  sSql := sSql+' or ( month(Data_Debito) =  ' + Mes;
  sSql := sSql+' and year(Data_Debito) =  ' + Ano;
  sSql := sSql+' and Data_Debito >= Data_Credito ' + '))';
  // End If
//  RsDb := gBanco.OpenRecordset(sSql);
  RsTb.TableName := 'Lancamentos';
  RsTb.Filter := sSql;
  RsTb.Open;

  if RsTb.EOF then
    begin
    ShowMessage('Não Existe Variação a Processar.');
    //Desconecta();
    RsTb.Close;
    gBanco.Close;
    Exit;
    end;

  //DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Deleta Dados de Relatorio
  // sSql = "delete from Relatorio"
  // DbLocal.Execute sSql
  // 
  // Grava Período na tabela para Relarório
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // If RsLocal.EOF Then
  // RsLocal.AddNew
  // Else
  // RsLocal.Edit
  // End If
  // RsLocal.Fields("MesVariacao") = NomeDoMes(gData1)
  // 
  // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
  // RsLocal.Fields("Nome_Reduzido") = gCliente
  // 
  // RsLocal.Fields("nm_conciliacao") = gConciliacao
  // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  // RsLocal.Update

  // Faz tudo comentado acima

  Conecta(DbLocal,gAdmPath+'\admin.udl');
  RsLocal := TAdoTable.Create(nil);
  RsLocal.Connection := DbLocal;
  GravaHeaderRel(DbLocal, RsLocal, 1);

  sSql := 'select * from Relatorio';   (*
  RsLocal := DbLocal.OpenRecordset(sSql);

  // Fazer Variação
  with RsDb do begin
    while  not EOF do begin
      // Teste colocado em 08/11/2000 a pedido do Jonas para evitar variação de
      // lançamentos em Real
      if (CDbl(FieldByName('Vl_CreditoDolar').Value)<>0) or (CDbl(FieldByName('Vl_DebitoDolar').Value)<>0) then begin
        if (FieldByName('Data_Credito')<=CDate(gData2)) or (FieldByName('Data_Debito')<=CDate(gData2)) then begin
          Edit();
          VBtoADOFieldSet(RsDb, 'Variacao', FieldByName('Vl_Saldo').Value);
          VBtoADOFieldSet(RsDb, 'Vl_Saldo', CDbl(0));
          VBtoADOFieldSet(RsDb, 'Data_variacao', CDate(gData2));
          UpdateRecord;
          // Gravar Relatório
          RsLocal.Insert;
          VBtoADOFieldSet(RsLocal, 'Data_Debito', FieldByName('Data_Debito').Value);
          VBtoADOFieldSet(RsLocal, 'Data_Credito', FieldByName('Data_Credito').Value);

          if sizeof(FieldByName('Data_Debito').Value)=0 then begin
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Credito').Value);
           end  else  begin
            if sizeof(FieldByName('Data_Credito').Value)=0 then begin
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Debito').Value);
            end;
          end;
          if (sizeof(FieldByName('Data_Debito').Value)<>0) and (sizeof(FieldByName('Data_Credito').Value)<>0) then begin
            if isDataMenorIgual(String(FieldByName('Data_Debito').Value), String(FieldByName('Data_Credito').Value)) then begin
              // pega data menor
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
            end;
          end;

          if (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') then begin
            VBtoADOFieldSet(RsLocal, 'Cartao', FieldByName('Cartao').Value);
            VBtoADOFieldSet(RsLocal, 'Cartao1', FieldByName('Cartao1').Value);
           end  else  begin
            VBtoADOFieldSet(RsLocal, 'Cartao', 'Variação Cambial');
          end;
          VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', FieldByName('Vl_DebitoDolar').Value);
          VBtoADOFieldSet(RsLocal, 'Taxa_Debito', FieldByName('Taxa_Debito').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', FieldByName('Vl_CreditoDolar').Value);
          VBtoADOFieldSet(RsLocal, 'Taxa_Credito', FieldByName('Taxa_Credito').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal', FieldByName('Vl_DebitoReal').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal', FieldByName('Vl_CreditoReal').Value);
          VBtoADOFieldSet(RsLocal, 'Data_variacao', FieldByName('Data_Variacao').Value);
          VBtoADOFieldSet(RsLocal, 'Variacao', FieldByName('Variacao').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_Saldo').Value);
          VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', FieldByName('Dias_Pendentes').Value);

          // Alterações visando a implementação da CONTABILIDADE
          // If Not IsNull(.Fields("Obs_Deb")) Then
          // RsLocal.Fields("Obs_Deb") = RsDb.Fields("Obs_Deb")
          // End If
          // If Not IsNull(.Fields("Obs_Cred")) Then
          // RsLocal.Fields("Obs_Cred") = RsDb.Fields("Obs_Cred")
          // End If

          RsLocal.UpdateRecord;
        end;
      end;
      Next;
    end;
  end;

  // Mostra Relatório
  Application.ProcessMessages();
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\variac.rpt';
  fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;
  // fMainForm.CrystalReport1.Action = 1

  // Faz BackUp do Banco de Dados no diretório Backup_Temp
  // Nome do Arquivo = AAAAMMDD_HHMMSS_NomeConciliação.mdb
  // Qdo faz Backup via menu no diretório Backup,
  // deleta o Backup_Temp
  BackupBanco();             *)

end;

procedure TfMainForm.mnuALAGeralClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then begin
    Exit;
  end;
  if Length(gConciliacao)=0 then begin
    ShowMessage('Selecione Conciliação...');
    Exit;
  end;

  gConsulta := 0;
  gAlteraLanc := GERAL;
  AlterarManual.ShowModal;
end;

{procedure TfrmMain.mnuAMIncluir_Click;  Esta porra está perdida!!!
begin
  Incluir.Show;
end;}

procedure TfMainForm.mnuALAPendenciasClick(Sender: TObject);
begin
  if not Autoriza(cATUALIZA) then begin
    Exit;
  end;
  if Length(gConciliacao)=0 then begin
    ShowMessage('Selecione Conciliação...');
    Exit;
  end;

  gConsulta := 0;
  gAlteraLanc := PENDENCIA;
  AlterarManual.ShowModal;
end;

procedure TfMainForm.mnuAtGeralClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  DataModule.AtualizaTotal;
end;

procedure TfMainForm.mnuAualizaClick(Sender: TObject);
var
  Buffer, Buffer1, buffer2,
  NomeArquivo : String;
  I: Longint;
  NomeTmp: String;
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  // gDataRelatorio = ""
  DataMov.ShowModal;
  if  not isDataValida(gDataRelatorio) then
    Exit;

//  if  not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

  // sSql = "select * from tb_moeda where strdata) = '" &

  // sSql = "select * from tb_moeda where str(data) = '" &
  // Mid$(gDataRelatorio, 1, 6) & "20" & Mid$(gDataRelatorio, 7, 2) & "'"
  sSql := 'select * from tb_moeda ';
  sSql := sSql+'where str(data) = '#39''+DateToStr(gDataRelatorio) + ''#39'';
  sSql := sSql+' or str(data) = '#39''+'20'+Copy(DateToStr(gDataRelatorio), 1, 6) +
                                 Copy(DateToStr(gDataRelatorio), 7, 2)+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  if RsDbDs.EOF then
    begin
    ShowMessage('Dolar não está cadastrado');
    RsDbDs.Close;
    gBanco.Close;
    Exit;
    end;

  gTaxa := RsDbDs.FieldByName('valor').Value;

  RsDbDs.Close;

  sSql := 'Select * from [Lancamentos]';

  gData1 := FormatVB(DateToStr(gDataRelatorio),'DD/MM/YYYY');

  sSql := sSql+' where (str(Data_Debito) = '#39''+gData1+''#39'';
  sSql := sSql+' or str(Data_Credito) = '#39'' + gData1+''#39' or str(Data_Credito) = '#39'' +
          DateToStr(gDataRelatorio) + ''#39')';
  sSql := sSql+' and conta_contabil = '#39'' + Trim(Concil.ContaContabil) + ''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  if not RsDbDs.EOF then
    begin
    ShowMessage('Movimento já foi Processado.');
//    Desconecta();
    RsDbDs.Close;
    gBanco.Close;
    Exit;
    end;

//  Desconecta();
  RsDbDs.Close;
  gBanco.Close;

  gAutomatico := true;

  NomeArquivo := ExtractFileDir(Application.ExeName) + '\';
  // NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ArqEntrada)
  NomeArquivo := NomeArquivo+gCliente+'\entrada\'+'JUNTADO';
  NomeArquivo := NomeArquivo+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeArquivo := NomeArquivo+'.txt';

  NomeTmp := ExtractFileDir(Application.ExeName) + '\';
  NomeTmp := NomeTmp+gCliente+'\entrada\'+Trim(Concil.ContaContabil);
  NomeTmp := NomeTmp+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeTmp := NomeTmp+'.tmp';

  // If gAtualizaGeral Then
  gAutomatico := false;
  if GeraTemp(NomeTmp, NomeArquivo) then
    NomeArquivo := NomeTmp
  else
    Exit;

  // Verifica se conta tem Limpeza Automática

  if gLimpAuto>0 then
    LimpaConta((Concil.ContaContabil), gLimpAuto);

  // End If
  gArquivo11 := '';
  frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+(Concil.ContaContabil)+' - '+gConciliacao+#10+'         Débitos    Créditos       Saldo'+#10+#10;
  gAutomatico := false;
  gTotDebito := 0;
  gTotCredito := 0;
  gSaldo := FloatToStr(GetSaldo());
  if gAtualizaGeral then begin
    if Concil.Natureza='D' then
      begin

      for I:=0 to ncDebito-1 do
        begin
        if  not ContaDebito(I, '840', NomeArquivo) then
          Exit;
        end; // I
      for I:=0 to ncCredito-1 do
        begin
        if  not ContaCredito(I, '840', NomeArquivo) then
          Exit;
        end; // I
      for I:=0 to ncDebito-1 do
        begin
        if  not ContaDebito(I, '986', NomeArquivo) then
          Exit;
        end; // I
      for I:=0 to ncCredito-1 do
        begin
        if  not ContaCredito(I, '986', NomeArquivo) then
          Exit;
        end; // I
      end
    else
      begin
      for I:=0 to ncCredito-1 do
        begin
        if  not ContaCredito(I, '840', NomeArquivo) then
          Exit;
        end; // I
      for I:=0 to ncDebito-1 do
        begin
        if  not ContaDebito(I, '840', NomeArquivo) then
          Exit;
        end; // I

      for I:=0 to ncCredito-1 do
        begin
        if  not ContaCredito(I, '986', NomeArquivo) then
          Exit;
        end; // I
      for I:=0 to ncDebito-1 do
        begin
        if  not ContaDebito(I, '986', NomeArquivo) then
          Exit;
        end; // I
      end;
    end
  else
    // Processa Contas de Resultado. Possui alto volume e é transitória
    // ou seja, o Débito e o Crédito são processados no mesmo dia
    ContasResultado(NomeArquivo);

  // Faz Backup do banco de dados com as novas movimentações
  BackupBanco;

  // Mostra Débitos e Créditos
  Buffer := FormatVB(gTotDebito,'###,##0.00');
  Buffer1 := FormatVB(gTotCredito,'###,##0.00');
  buffer2 := FormatVB(GetSaldo(),'###,##0.00');

  frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+#10+StringOfChar(' ', 14-Length(Buffer))+Buffer+' '+StringOfChar(' ', 14-Length(Buffer1))+Buffer1+' '+StringOfChar(' ', 14-Length(buffer2))+buffer2+#10;

  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close;
  frmLog.ShowModal;
end;

procedure TfMainForm.mnuBatClick(Sender: TObject);
var
  NomeArquivo : String;
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  // If Len(gConciliacao) = 0 Then
  // MsgBox "Selecione Conciliação..."
  // Exit Sub
  // End If
  // gDataRelatorio = ""
  DataMov.ShowModal;
  if  not isDataValida(gDataRelatorio) then
    Exit;

  // If Not Conecta("") Then Exit Sub
  // Tirar moeda
  // sSql = "select * from tb_moeda "
  // sSql = sSql & "where str(data) = '" & gDataRelatorio & "'"
  // sSql = sSql & " or str(data) = '" & "20" & Mid$(gDataRelatorio, 1, 6) & Mid$(gDataRelatorio, 7, 2) & "'"
  // Set RsDb = gBanco.OpenRecordset(sSql)
  // If RsDb.EOF Then
  // MsgBox "Dolar não está cadastrado"
  // Exit Sub
  // End If
  // gTaxa = RsDb.Fields("valor")
  // sSql = "Select * from [Lancamentos]"

  gData1 := FormatVB(DateToStr(gDataRelatorio),'DD/MM/YYYY');

  // sSql = sSql & " where (str(Data_Debito) = '" & gData1 & "'"
  // sSql = sSql & " or str(Data_Credito) = '" & gData1 & "' or str(Data_Credito) = '" & gDataRelatorio & "')"
  // sSql = sSql & " and conta_contabil = '" & Trim(Concil.ContaContabil) & "'"
  // Set RsDb = gBanco.OpenRecordset(sSql)
  // 
  // If Not RsDb.EOF Then
  // MsgBox "Movimento já foi Processado."
  // Desconecta
  // Exit Sub
  // End If
  // Desconecta

  gAutomatico := true;

  NomeArquivo := ExtractFileDir(Application.ExeName) + '\';
  NomeArquivo := NomeArquivo+gCliente+'\Bx_Banco_Deb\'+Trim(Concil.ContaContabil);
  NomeArquivo := NomeArquivo+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeArquivo := NomeArquivo+'.prn';

  if Not FileExists(NomeArquivo) then
    begin
    ShowMessage('Arquivo '+NomeArquivo+'nao localizado');
    Exit;
    end;

  NomeArquivo := ExtractFileDir(Application.ExeName) + '\';
  NomeArquivo := NomeArquivo+gCliente+'\Bx_Banco_Cred\'+Trim(Concil.ContaContabil);
  NomeArquivo := NomeArquivo+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeArquivo := NomeArquivo+'.prn';

  if Not FileExists(NomeArquivo) then
    begin
    ShowMessage('Arquivo '+NomeArquivo+'nao localizado');
    Exit;
    end;

  // If gAtualizaGeral Then
  // gAutomatico = False
  // If GeraTemp(NomeTmp) Then
  // NomeArquivo = NomeTmp
  // Else
  // Exit Sub
  // End If

  // End If
  gArquivo11 := '';
  frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+(Concil.ContaContabil)+' - '+gConciliacao+#10+'         Débitos    Créditos       Saldo'+#10+#10;
  gAutomatico := false;
  gTotDebito := 0;
  gTotCredito := 0;
  gSaldo := FloatToStr(GetSaldo());

  // Processa Contas de Resultado. Possui alto volume e é transitória
  // ou seja, o Débito e o Crédito são processados no mesmo dia
  BatimentoConta();

  // Faz Backup do banco de dados com as novas movimentações
  BackupBanco();

  // Mostra Débitos e Créditos
  // Buffer = Format$(gTotDebito, "###,##0.00")
  // Buffer1 = Format$(gTotCredito, "###,##0.00")
  // buffer2 = Format$(GetSaldo, "###,##0.00")
  // 
  // frmLog.RichTextBox1.Text = frmLog.RichTextBox1.Text & Chr(10) &
  // Space(14 - Len(Buffer)) & Buffer & " " &
  // Space(14 - Len(Buffer1)) & Buffer1 & " " &
  // Space(14 - Len(buffer2)) & buffer2 & Chr(10)

  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close();
  frmLog.ShowModal();

end;

procedure TfMainForm.mnuBkpClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  BackupGeral;
end;

procedure TfMainForm.mnuBkpMensalClick(Sender: TObject);
label
  Erro;
var
  sData,
  NomeArquivo : String;
  DynArray: TStringDynArray;
  I : Integer;
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  if Application.MessageBox('O Mês ja foi fechado? Confirma Operação?', 'Backup do Movimento Zerado', MB_YESNO)=IDNO then
    Exit;

  // BackUp Mensal do Banco de Dados

  Screen.Cursor := crHourGlass;

  // Backup do Banco antes de quebrar
  LimpaBackUp(10);
  NomeArquivo := gAdmPath+'\';
  NomeArquivo := NomeArquivo+gCliente+'\Backup\';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
  NomeArquivo := NomeArquivo+gCliente+'_';
  NomeArquivo := NomeArquivo+'Geral'+'.mdb';

  CopyFile(PChar((gDataPath)+gDataFile), PChar(NomeArquivo), false);

  if  not QuebraBanco() then begin
    ShowMessage('Erro na Cópia do Banco');
    Screen.Cursor := crDefault;
    Exit;
  end;

//  Desconecta();

  LimpaBackUp(10);
  NomeArquivo := gAdmPath+'\';
  NomeArquivo := NomeArquivo+gCliente+'\BackupMensal\';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
  NomeArquivo := NomeArquivo+'Hist_'+gCliente+'_';
  NomeArquivo := NomeArquivo+'Mensal'+'.mdb';

  try  // On Error GoTo Erro
    // Copia o Arquivo gerado pelo Quebrabanco para o diretório
    // BackupMensal
    CopyFile(PChar((gDataPath)+'Hist_'+gDataFile), PChar(NomeArquivo), false);

    LimpaBackUp(10);
    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\Backup\';
    NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
    NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
    NomeArquivo := NomeArquivo+gCliente+'_';
    NomeArquivo := NomeArquivo+'Geral'+'.mdb';

    // Copia o Arquivo com movimento gerado pelo Quebrabanco
    // para o diretório Backup
    CopyFile(PChar((gDataPath)+gDataFile), PChar(NomeArquivo), false);

    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\Backup_temp\';

//    nome := Dir(NomeArquivo+'*.mdb');
{    while Dir(NomeArquivo+'*.mdb')<>'' do
      begin
      if (1+Pos('Geral', PChar(nome)+1))=0 then
        begin
        DeleteFile(NomeArquivo+nome);
        end;
      nome := Dir(NomeArquivo+'*.mdb');
      end; }

    DynArray := TDirectory.GetFiles(NomeArquivo, '*.mdb', TSearchOption.soTopDirectoryOnly);
    for I := Low(DynArray) to High(DynArray) do
      if (1+Pos('Geral', PChar(DynArray[I])+1))=0 then
        DeleteFile(DynArray[I]);

    // Deleta arquivos antigos

    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\entrada\';
//    nome := Dir(NomeArquivo+'*.*');

    DynArray := TDirectory.GetFiles(NomeArquivo, '*.*', TSearchOption.soTopDirectoryOnly);
    for I := Low(DynArray) to High(DynArray) do
      Begin
      if Length(Trim(DateToStr(gDataRelatorio)))=0 then
        break;
      sData := FormatVB(DateToStr(gDataRelatorio),'YYYYMMDD');
      if (1+Pos(sData, PChar(DynArray[I])+1))=0 then
        DeleteFile(DynArray[I]);
      End;

    {while nome<>'' do begin
      if Length(Trim(DateToStr(gDataRelatorio)))=0 then break;
      sData := FormatVB(DateToStr(gDataRelatorio),'YYYYMMDD');
      if (1+Pos(sData, PChar(nome)+1))=0 then begin
        DeleteFile(NomeArquivo+nome);
        nome := Dir(NomeArquivo+'*.*');
       end  else  begin
        nome := Dir();
      end;
    end;}

    Screen.Cursor := crDefault;
    ShowMessage('BackUp Mensal Efetuado.');
    Exit;
  except  // Erro:
    Screen.Cursor := crDefault;
    ShowMessage(PChar('Erro no BackUp.'+#10+'Err.Description'));
    //Err.Clear();
  end;
end;

procedure TfMainForm.mnuCadBINClick(Sender: TObject);
begin

  sSql := 'select * from tbBIN order by BIN';
  gOpcao := '';
  ConsultaCvMes.Caption := 'Cadastramento de BIN';
  ConsultaCvMes.ShowModal;

  Exit;

  Consulta.sSqlConsulta := 'select * from tbBIN order by BIN';
  gOpcao := '';
  if Length(Trim(gCliente))=0 then
    begin
    ShowMessage('Selecione um Cliente');
    Exit;
    end;
  Consulta.Caption := 'Consulta BIN';
  Consulta.ShowModal;

end;

procedure TfMainForm.mnuCadUsuarioClick(Sender: TObject);
begin

  if  not Autoriza(cADM) then
    Exit;

  Consulta.Caption := 'Cadastro de usuários';
  Consulta.sSqlConsulta := 'select Id_usuario, Nome_usuario, cd_grupo_usu, senha from usuarios';
  gOpcao := 'adm';
  Consulta.ShowModal;
end;

procedure TfMainForm.mnuCBDGeralClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  if not ChecaTempDb then
    begin
    ShowMessage('Arquivo não encontrado...');
    Exit;
    end;
  gAlteraLanc := GERAL;
  Alterar_Consulta.ShowModal;
end;

procedure TfMainForm.mnuCBDPendenciasClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  if not ChecaTempDb then
    begin
    ShowMessage('Arquivo não encontrado...');
    Exit;
    end;
  gAlteraLanc := PENDENCIA;
  Alterar_Consulta.ShowModal();
end;

procedure TfMainForm.mnuCCConsultarClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  ConsultaCon.Caption := 'Cadastramento de conciliação';
  gArquivo11 := 'Geral';
  ConsultaCon.ShowModal;
end;

// Private Sub mnuCCConsultar_Click()
// If Not Autoriza(cADM) Then
// Exit Sub
// End If

// ConsultaCon.Show vbModal

// sSql = "select cliente,conta_contabil,nm_conciliacao from tb_tipo_Con"
// If gCliente <> "" Then
// sSql = sSql & " where cliente = '" & gCliente & "'"
// End If
// gOpcao = "adm"
// Consulta.Show vbModal
// End Sub

procedure TfMainForm.mnuClienteClick(Index: Smallint; Sender: TObject);
begin
  AbreMenu(Index+1);
end;

procedure TfMainForm.mnuCliente_0Click(Sender: TObject); begin mnuClienteClick(0, Sender); end;
procedure TfMainForm.mnuCliente_1Click(Sender: TObject); begin mnuClienteClick(1, Sender); end;
procedure TfMainForm.mnuCliente_2Click(Sender: TObject); begin mnuClienteClick(2, Sender); end;
procedure TfMainForm.mnuCliente_3Click(Sender: TObject); begin mnuClienteClick(3, Sender); end;
procedure TfMainForm.mnuCliente_4Click(Sender: TObject); begin mnuClienteClick(4, Sender); end;
procedure TfMainForm.mnuCliente_5Click(Sender: TObject); begin mnuClienteClick(5, Sender); end;
procedure TfMainForm.mnuCliente_6Click(Sender: TObject); begin mnuClienteClick(6, Sender); end;
procedure TfMainForm.mnuCliente_7Click(Sender: TObject); begin mnuClienteClick(7, Sender); end;
procedure TfMainForm.mnuCliente_8Click(Sender: TObject); begin mnuClienteClick(8, Sender); end;
procedure TfMainForm.mnuCliente_9Click(Sender: TObject); begin mnuClienteClick(9, Sender); end;
procedure TfMainForm.mnuCliente_10Click(Sender: TObject); begin mnuClienteClick(10, Sender); end;
procedure TfMainForm.mnuCliente_11Click(Sender: TObject); begin mnuClienteClick(11, Sender); end;
procedure TfMainForm.mnuCliente_12Click(Sender: TObject); begin mnuClienteClick(12, Sender); end;
procedure TfMainForm.mnuCliente_13Click(Sender: TObject); begin mnuClienteClick(13, Sender); end;
procedure TfMainForm.mnuCliente_14Click(Sender: TObject); begin mnuClienteClick(14, Sender); end;
procedure TfMainForm.mnuCliente_15Click(Sender: TObject); begin mnuClienteClick(15, Sender); end;
procedure TfMainForm.mnuCliente_16Click(Sender: TObject); begin mnuClienteClick(16, Sender); end;
procedure TfMainForm.mnuCliente_17Click(Sender: TObject); begin mnuClienteClick(17, Sender); end;
procedure TfMainForm.mnuCliente_18Click(Sender: TObject); begin mnuClienteClick(18, Sender); end;
procedure TfMainForm.mnuCliente_19Click(Sender: TObject); begin mnuClienteClick(19, Sender); end;
procedure TfMainForm.mnuCliente_20Click(Sender: TObject); begin mnuClienteClick(20, Sender); end;
procedure TfMainForm.mnuCliente_21Click(Sender: TObject); begin mnuClienteClick(21, Sender); end;

procedure TfMainForm.mnuConfClick(Sender: TObject);
var
  versao: String;
begin
  // Mostra a configuração da conciliação
  gArquivo11 := '';

  versao := 'Versão do Programa.... ver. ';
//  versao := versao+String(App.Major)+'.';
//  versao := versao+String(App.Minor)+' rev. ';
//  versao := versao+String(App.Revision);

  // LastAtualiza

  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Configuração da Conciliação' + #10+#10;
  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Diretório de Trabalho: ' + gAdmPath + #10 + 'Cliente .............. ' +
                              gCliente + #10 + 'Conciliação........... ' + gConciliacao + #10 + 'Conta Contabil........ ' +
                              Concil.ContaContabil + #10 + 'Usuário............... ' + gOperador + #10 + versao+#13#10;

  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close;
  frmLog.ShowModal;
end;

procedure TfMainForm.mnuConvMesClick(Sender: TObject);
begin
  sSql := 'select Relatorio,Jan,Fev,Mar,Abr,Mai,Jun,Jul,Ago,[Set],Out,Nov,Dez from tbConvMes';
  sSql := sSql+' order by Relatorio';
  gOpcao := 'ADM';
  ConsultaCvMes.Caption := 'Conversão de Mês';
  ConsultaCvMes.ShowModal;
end;

procedure TfMainForm.mnuCopyFileClick(Sender: TObject);
label
  Erro;
var
  arqOrigem, arqDestino, nome, sDir: String;
  listaArquivos: TStringList;
  I: Smallint;
  DynArray : TStringDynArray;
begin
  listaArquivos := nil;

  if  not Autoriza(cATUALIZA) then
    Exit;

  if gNomeComputador='CR-SCC' then
    begin
    arqOrigem := 'm:\destino\';
    arqOrigem := 'C:\ROM\CONCILIA\MOVTO_20080909\';
    arqDestino := 'C:\ROM\CONCILIA\';
    end
  else
    begin
    arqOrigem := '\\srvsccspd01\concilia\';
    arqDestino := 'C:\ROM\CONCILIA\';
    end;
  try  // On Error GoTo Erro
{    nome := Dir(arqOrigem+'*.*');
    if Length(nome)=0 then begin
      ShowMessage(PChar('Nenhum arquivo encontrado em: '+arqOrigem));
      Exit;
    end;}

    DynArray := TDirectory.GetFiles(arqOrigem, '*.*', TSearchOption.soTopDirectoryOnly);
    if Length(DynArray) = 0 then
      begin
      ShowMessage(PChar('Nenhum arquivo encontrado em: '+arqOrigem));
      Exit;
      end;

    sDir := getDataFromNome(nome);

     {? On Error Resume Next  }
//    Dir(arqDestino+'MOVTO_'+sDir);

    frmLog.Show;

    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Copiando Arquivos do servicor ROM para o servicor Concilia. '+#10+#10;

{    I := 1;
    while nome <> '' do begin
      ReDimPreserve(listaArquivos, I+1);
      listaArquivos[I] := nome;
      I := I+1;
      nome := Dir();
    end;}

    for I := Low(DynArray) to High(DynArray) do
      listaArquivos.Add(DynArray[I]);

    listaArquivos.Add('999999');

//    I := 1;
    I := 0;
    while listaArquivos[I] <> '999999' do
      begin

      if FileExists(arqDestino+sDir+'\' + ExtractFileName(listaArquivos[I])) then
        frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+'Arquivo '+listaArquivos[I]+' Já existe...'+#10
      else
        begin

        gArquivo11 := frmLog.RichTextBox1.Text;

        frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+'Copiando Arquivo '+arqDestino+sDir+'\'+listaArquivos[I]+'...'+#10;
        frmLog.RichTextBox1.SelStart := 0;
        frmLog.RichTextBox1.SelLength := Length(gArquivo11);
        frmLog.RichTextBox1.Font.Name := 'Courier New';
        frmLog.RichTextBox1.SelLength := 0;

        frmLog.RichTextBox1.Visible := true;
        Application.ProcessMessages();
        // Copia o arquivo
        CopyFile(PChar(arqOrigem+listaArquivos[I]), PChar(arqDestino+'MOVTO_'+sDir+'\'+listaArquivos[I]), false);
        // sLog = sLog + arqDestino + sDir + "\" + nome & Chr(10)
      end;
      I := I+1;
      Application.ProcessMessages();
    end;
    // MsgBox sLog
    frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+#10+'Fim da Cópia dos Arquivos. '+DateTimeToStr(Now())+#10;
    gArquivo11 := frmLog.RichTextBox1.Text;
    Application.ProcessMessages();

    Exit;
  except  // Erro:
  //  if Err.Number=52 then { Resume Next }
  end;
end;

procedure TfMainForm.mnuEPBClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  ShowMessage('Rever esta rotina de relatório');     (*

  // Limpar movimento de um período

  if Length(gCliente)=0 then begin
    ShowMessage('Selecione Cliente');
    Exit;
  end;
  if Length(gConciliacao)=0 then begin
    ShowMessage('Selecione Conciliação');
    Exit;
  end;

  gData1 := '';
  gData2 := '';

  Periodo.ShowModal();
  Application.ProcessMessages();
  if gData1='' then begin
    Exit;
  end;

  ReCalcula(gAtualizacao);
  // Desconecta
  gWork := DBEngine.Workspaces(0);
  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Grava Período na tabela
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // If RsLocal.EOF Then
  // RsLocal.AddNew
  // Else
  // RsLocal.Edit
  // End If
  // If Len(Data1) = 0 Then
  // RsLocal.Fields("De") = Null
  // RsLocal.Fields("Ate") = Null
  // Else
  // RsLocal.Fields("Ate") = CDate(Data1)
  // 
  // End If
  // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
  // 
  // RsLocal.Fields("nm_conciliacao") = gConciliacao
  // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  // RsLocal.Update

  // Faz tudo comentado acima
  GravaHeaderRel(DbLocal, RsLocal, 1);

  sSql := 'Delete from [Excluidos]';
  gBanco.Execute(sSql);
  DbLocal.Execute(sSql);

  sSql := 'Select * from [Excluidos]';
  RsExc := gBanco.OpenRecordset(sSql);
  RsLocal := DbLocal.OpenRecordset(sSql);

  sSql := '';
  sSql := sSql+'Select * from [Lancamentos] ';
  sSql := sSql+' where  conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  sSql := sSql+' and  data_debito <= cdate('#39''+gData2+''#39')';
  sSql := sSql+' and  data_debito >= cdate('#39''+gData1+''#39')';
  sSql := sSql+' and  vl_saldo = 0 ';

  RsDb := gBanco.OpenRecordset(sSql);
  if RsDb.EOF then begin
    ShowMessage('Não ha Registros a Excluir');
    Exit;
  end;
  RsDb.Last;
  RecCount := RsDb.RecordCount;
  RsDb.First;

  // query para pegar os lançamentos de um período
  // select *  from lancamentos where conta_contabil='110531'
  // and data_debito <  cdate('01/11/2000')
  // and data_debito >  cdate('15/09/2000')

  PBar.Show();
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Excluindo Período';
  PBar.ProgressBar1.Max := RecCount;

  with RsDb do begin
    while  not RsDb.EOF do begin

      // If IsOk(gData1, gData2) And ((Len(.Fields("Vl_DebitoReal")) > 0)
      // And (Len(.Fields("Vl_CreditoReal") > 0) And (CDbl(.Fields("Vl_Saldo")) = 0))) Then
      PBar.ProgressBar1.Position := RecCount-RsDb.RecordCount;
      Application.ProcessMessages();
      RsExc.Insert;
      VBtoADOFieldSet(RsExc, 'Data_Debito', FieldByName('Data_Debito').Value);
      VBtoADOFieldSet(RsExc, 'Data_Credito', FieldByName('Data_Credito').Value);
      VBtoADOFieldSet(RsExc, 'Cartao', FieldByName('Cartao').Value);
      VBtoADOFieldSet(RsExc, 'Cartao1', FieldByName('Cartao1').Value);

      VBtoADOFieldSet(RsExc, 'Vl_DebitoDolar', FieldByName('Vl_DebitoDolar').Value);
      VBtoADOFieldSet(RsExc, 'Taxa_Debito', FieldByName('Taxa_Debito').Value);
      VBtoADOFieldSet(RsExc, 'Vl_CreditoDolar', FieldByName('Vl_CreditoDolar').Value);
      VBtoADOFieldSet(RsExc, 'Taxa_Credito', FieldByName('Taxa_Credito').Value);

      VBtoADOFieldSet(RsExc, 'Vl_Debito', FieldByName('Vl_DebitoReal').Value);
      VBtoADOFieldSet(RsExc, 'Vl_Credito', FieldByName('Vl_CreditoReal').Value);
      VBtoADOFieldSet(RsExc, 'Vl_Saldo', FieldByName('Vl_Saldo').Value);
      // Alterações visando a implementação da CONTABILIDADE
      // RsExc.Fields("Historico_Deb") = .Fields("Obs_Deb")
      // RsExc.Fields("Historico_Cred") = .Fields("Obs_Cred")
      // If .Fields("Obs_Deb") = 0 Then
      // RsExc.Fields("Historico_Deb") = " "
      // End If
      // If .Fields("Obs_Cred") = 0 Then
      // RsExc.Fields("Historico_Cred") = " "
      // End If
      RsExc.UpdateRecord;

      RsLocal.Insert;
      VBtoADOFieldSet(RsLocal, 'Data_Debito', FieldByName('Data_Debito').Value);
      VBtoADOFieldSet(RsLocal, 'Data_Credito', FieldByName('Data_Credito').Value);
      VBtoADOFieldSet(RsLocal, 'Cartao', FieldByName('Cartao').Value);
      VBtoADOFieldSet(RsLocal, 'Cartao1', FieldByName('Cartao1').Value);

      VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', FieldByName('Vl_DebitoDolar').Value);
      VBtoADOFieldSet(RsLocal, 'Taxa_Debito', FieldByName('Taxa_Debito').Value);
      VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', FieldByName('Vl_CreditoDolar').Value);
      VBtoADOFieldSet(RsLocal, 'Taxa_Credito', FieldByName('Taxa_Credito').Value);

      VBtoADOFieldSet(RsLocal, 'Vl_Debito', FieldByName('Vl_DebitoReal').Value);
      VBtoADOFieldSet(RsLocal, 'Vl_Credito', FieldByName('Vl_CreditoReal').Value);
      VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_Saldo').Value);
      // Alterações visando a implementação da CONTABILIDADE
      // RsLocal.Fields("Historico_Deb") = .Fields("Obs_Deb")
      // RsLocal.Fields("Historico_Cred") = .Fields("Obs_Cred")
      // If .Fields("Obs_Deb") = 0 Then
      // RsLocal.Fields("Historico_Deb") = " "
      // End If
      // If .Fields("Obs_Cred") = 0 Then
      // RsLocal.Fields("Historico_Cred") = " "
      // End If
      RsLocal.UpdateRecord;

      Gravalog(RsDb, 'Exclusão');
      Delete; // Deleta registro
      RsDb.Next;
    end;
  end;

  RsExc.Close();
  RsLocal.Close();
  DbLocal.Close();
  RsExc := nil;
  RsLocal := nil;
  DbLocal := nil;
  Desconecta();
  PBar.Close();

  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\'+String(excluido.rpt);
  fMainForm.CrystalReport1.SortFields(0) := '';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;
  // fMainForm.CrystalReport1.Action = 1    *)
end;

procedure TfMainForm.mnuEXGerComClick(Sender: TObject);
var
  J: Smallint;
begin
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data do Relatório';
  DataLimite.Label1.Caption := 'Relatório até:';
  DataLimite.ShowModal; // Alterado em 7/11/2000
  if gData1='' then
    begin
    ShowMessage('Operação Cancelada');
    Exit;
    end;
  GeraLista;
  J := 0;
  while J < gMaxCon do
    begin
    gConciliacao := gArrConcil[J];
    gLimiteVariacao := GetLimite(gArrConcil3[J], gArrConcil2[J]);
    DataModule.SimulaNovaCon;
    GeraExcel(true);
    J := J+1;
    end;

  ShowMessage(PChar('Planilhas geradas em '+(gExcelPath)));

end;

procedure TfMainForm.mnuEXGerSemClick(Sender: TObject);
var
  J: Smallint;
begin
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data do Relatório';
  DataLimite.Label1.Caption := 'Relatório até:';
  DataLimite.ShowModal(); // Alterado em 7/11/2000
  if gData1='' then
    begin
    ShowMessage('Operação Cancelada');
    Exit;
    end;
  GeraLista;
  J := 0;
  while J < gMaxCon do
    begin
    gConciliacao := gArrConcil[J];
    gLimiteVariacao := GetLimite(gArrConcil3[J], gArrConcil2[J]);
    DataModule.SimulaNovaCon;
    GeraExcel(false);
    J := J+1;
    end;
  ShowMessage(PChar('Planilhas geradas em '+(gExcelPath)));
end;

procedure TfMainForm.GeraExcel(ComSem: Boolean);
Var
  xData : TDateTime;
begin
  Application.ProcessMessages;
  if gData1<>'' then
    begin
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    xData := StrToDate(gData1);
    MontaRelExcell(xData, ComSem, false);
    gData1 := DateToStr(xData);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.GeraLista;
{var
  Work, Banco: OleVariant;
  DbLocal: Database;
  RsLocal: TADODataSet;}
begin
//  Work := DBEngine.Workspaces(0);
//  Banco := Work.OpenDatabase(gAdmPath+'\admin.mdb');
  Conecta(gBanco, gAdmPath+'\admin.mdb');

  sSql := 'select * from tb_tipo_con ';
  sSql := sSql+' where excel='#39'S'#39'';
  sSql := sSql+' and cliente='#39''+gCliente+''#39'';
//  RsLocal := Banco.OpenRecordset(sSql);

  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  gMaxCon := 0;

  RsDbDs.Last;
//  ReDim(gArrConcil, RsLocal.RecordCount+1);
//  ReDim(gArrConcil2, RsLocal.RecordCount+1);
//  ReDim(gArrConcil3, RsLocal.RecordCount+1);
  RsDbDs.First;
  while not RsDbDs.EOF do
    begin
    gArrConcil.Add(RsDbDs.FieldByName('nm_conciliacao').Value);
    gArrConcil2.Add(Trim(RsDbDs.FieldByName('conta_contabil').Value));
    gArrConcil3.Add(RsDbDs.FieldByName('cliente').Value);
    gMaxCon := gMaxCon+1;
    RsDbDs.Next;
    end;
{  RsLocal.Close;
  RsLocal := nil;
  Banco.Close;
  Banco := nil;  }

  RsDbDs.Close;
  gBanco.Close;
end;

procedure TfMainForm.mnuGAEComClick(Sender: TObject);
Var
  xData : TDateTime;
begin
  // Gerar Relatório Excell Com Mensagem
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data do Relatório';
  DataLimite.Label1.Caption := 'Relatório até:';
  DataLimite.ShowModal; // Alterado em 7/11/2000
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    xData := StrToDate(gData1);
    MontaRelExcell(xData, true, true);
    gData1 := DateToStr(xData);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuGAESemClick(Sender: TObject);
Var
  xData : tDateTime;
begin
  // Gerar Relatório Excell Sem Mensagem
  if Length(gConciliacao)=0 then begin
    ShowMessage('Selecione Conciliação...');
    Exit;
  end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data do Relatório';
  DataLimite.Label1.Caption := 'Relatório até:';
  DataLimite.ShowModal(); // Alterado em 7/11/2000
  Application.ProcessMessages();
  if gData1<>'' then
    begin
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    xData := StrToDate(gData1);
    MontaRelExcell(xData, false, true);
    gData1 := DateToStr(xData);
    Screen.Cursor := crDefault;
    end;
end;
procedure TfMainForm.mnuGCClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  sSql := 'select * from tb_GrupoCon';
  gOpcao := 'adm';
  ConsultaCvMes.Caption := 'Grupo de Conciliação';
  ConsultaCvMes.ShowModal;

  Exit;

  Consulta.sSqlConsulta := 'select * from tb_GrupoCon';
  gOpcao := 'adm';
  Consulta.ShowModal;
end;

procedure TfMainForm.mnuDDAltClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  atMoeda.Caption := 'Altera Valor da Moeda';
  atMoeda.ShowModal;
end;

procedure TfMainForm.mnuDDExclClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  PedeAlteracao.Caption := 'Exclui Dolar do Dia';
  PedeAlteracao.Label1.Caption := 'Data (DD/MM/AAAA)';
  gOpcao := '';
  PedeAlteracao.ShowModal();
  if isDataValida(gOpcao) then
    begin
//    if  not Conecta('') then Exit;
    if  not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
      Exit;

//  sSql := 'select * from tb_moeda where str(data) = '#39''+gOpcao+''#39' or str(data) = '#39''+dataDezBarra(gOpcao)+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);

    RsTb.TableName := 'tb_moeda';
    RsTb.Filter := 'str(data) = '#39''+gOpcao+''#39' or str(data) = '#39'' + gOpcao + ''#39'';
    RsTb.Open;

    if RsTb.EOF then
//      begin
      Application.MessageBox('Moeda não Cadastrada', 'Moeda do Dia', MB_ICONSTOP)
//      Desconecta();
//      Exit;
//      end;
    else
    if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then
      RsTb.Delete;
//    Desconecta;
    RsTb.Close;
    gBanco.Close;
    end
  else
    if Length(gOpcao)>0 then Application.MessageBox('Data Inválida...', 'Moeda do Dia', MB_ICONSTOP);
end;

procedure TfMainForm.mnuDDIncClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  gData2 := '';
  atMoeda.Caption := 'Inclui Valor da Moeda';
  atMoeda.ShowModal;
end;

procedure TfMainForm.mnuGMClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  frmGeraMov.Show;
end;

procedure TfMainForm.mnuGODComClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  // DataLimite.Show 1
  gData1 := FormatVB(Now,'DD/MM/YYYY');
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    gData2 := gData1;
    gData1 := '';
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    MontaRelatorioSaldo(StrToDate(gData2), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuGODSemClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  gData1 := FormatVB(Now(),'DD/MM/YYYY');
  Application.ProcessMessages();
  if gData1='' then Exit;
  Screen.Cursor := crHourGlass;
  gOrdem := 1;
  MontaRelatorioSaldo(StrToDate(gData1), false);
  Screen.Cursor := crDefault;
end;

procedure TfMainForm.mnuGOOComClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  gData1 := FormatVB(Now(),'DD/MM/YYYY');
  Application.ProcessMessages();
  if gData1<>'' then
    begin
    gData2 := gData1;
    gData1 := '';
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelatorioSaldo(StrToDate(gData2), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuGOOSemClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  gData1 := FormatVB(Now(),'DD/MM/YYYY');
  Application.ProcessMessages();
  if gData1 <> '' then
    begin
    gData2 := gData1;
    gData1 := '';
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelatorioSaldo(StrToDate(gData2), false);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuGPOCComClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);

  DataLimite.Caption := 'Data do Balancete';
  DataLimite.ShowModal;
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelatorioSaldo(StrToDate(gData1), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuGPOCSemClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data do Balancete';
  DataLimite.ShowModal;
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelatorioSaldo(StrToDate(gData1), false);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuGPODComClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data do Balancete';
  DataLimite.ShowModal();
  Application.ProcessMessages();
  if gData1 <> '' then
    begin
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    MontaRelatorioSaldo(StrToDate(gData1), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuGPODSemClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);

  DataLimite.Caption := 'Data do Balancete';
  DataLimite.ShowModal;
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    MontaRelatorioSaldo(StrToDate(gData1), false);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuHistoricoClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  if  not ChecaTempDb then
    begin
    ShowMessage('Arquivo não encontrado...');
    Exit;
    end;
  gAlteraLanc := GERAL;
  Historico.ShowModal;
end;

procedure TfMainForm.mnuInterfaceClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  DataMov.ShowModal;
  if  not isDataValida(gDataRelatorio) then
    Exit;

  if not DataModule.Gera_Interface then
    // mensagen de erro
    Exit;
end;

procedure TfMainForm.mnuInterfConClick(Sender: TObject);
var
  salvaConciliacao: String;
begin
  // Mostra tela de opção não liberada !!!
  // frmNaoLib.Show vbModal
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);

  DataMov.Caption := 'Consulta Interface';
  DataMov.ShowModal;
  Application.ProcessMessages;
  if DateToStr(gDataRelatorio) <> '' then
    begin
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gData1 := DateToStr(gDataRelatorio);
    salvaConciliacao := gConciliacao;
    gConciliacao := 'Registros de Interface';
    MontaRelatorioInterface(gDataRelatorio, false);
    gConciliacao := salvaConciliacao;
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuInterfSaciClick(Sender: TObject);
var
  salvaConciliacao: String;
begin
  // Mostra tela de opção não liberada !!!
  // frmNaoLib.Show vbModal
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);

  DataMov.Caption := 'Consulta Interface';
  DataMov.ShowModal();
  Application.ProcessMessages();
  if DateToStr(gDataRelatorio) <> '' then begin
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gData1 := DateToStr(gDataRelatorio);
    salvaConciliacao := gConciliacao;
    gConciliacao := 'Registros Sem perna(Saci)';
    MontaRelatorioSaci(gDataRelatorio, false);
    gConciliacao := salvaConciliacao;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfMainForm.mnuJuncaoClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;
  frmJuncao.Show;
end;

procedure TfMainForm.mnuJuncaoJuntadosClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;
  DataDeAte.Show;
end;

procedure TfMainForm.mnuLogClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  if  not Autoriza(cATUALIZA) then
    begin
    Screen.Cursor := crDefault;
    Exit;
    end;

  ShowMessage('Rever esta rotina de relatório');

  (*gWork := DBEngine.Workspaces(0);
  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  sSql := 'delete  from [log2]';
  DbLocal.Execute(sSql);

  GravaHeaderRel(DbLocal, RsLocal, 1);

  if  not Conecta('') then Exit;

  sSql := 'Select * from [log2] ';
  RsDb := gBanco.OpenRecordset(sSql);
  RsLocal := DbLocal.OpenRecordset(sSql);

  if RsDb.EOF then begin
    Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
    RsLocal.Close();
    RsLocal := nil;
    Desconecta();
    Exit;
  end;
  while  not RsDb.EOF do begin
    RsLocal.Insert;
    VBtoADOFieldSet(RsLocal, 'Data_Alteracao', RsDb.FieldByName('Data_Alteracao').Value);
    VBtoADOFieldSet(RsLocal, 'Operacao', RsDb.FieldByName('Operacao').Value);
    VBtoADOFieldSet(RsLocal, 'Operador', RsDb.FieldByName('Operador').Value);
    VBtoADOFieldSet(RsLocal, 'Conta_Contabil', RsDb.FieldByName('Conta_Contabil').Value);

    VBtoADOFieldSet(RsLocal, 'Data_Debito_A', RsDb.FieldByName('Data_Debito_A').Value);
    VBtoADOFieldSet(RsLocal, 'Data_Credito_A', RsDb.FieldByName('Data_Credito_A').Value);
    VBtoADOFieldSet(RsLocal, 'Cartao_A', RsDb.FieldByName('Cartao_A').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar_A', RsDb.FieldByName('Vl_DebitoDolar_A').Value);
    VBtoADOFieldSet(RsLocal, 'Taxa_Debito_A', RsDb.FieldByName('Taxa_Debito_A').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar_A', RsDb.FieldByName('Vl_CreditoDolar_A').Value);
    VBtoADOFieldSet(RsLocal, 'Taxa_Credito_A', RsDb.FieldByName('Taxa_Credito_A').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal_A', RsDb.FieldByName('Vl_DebitoReal_A').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal_A', RsDb.FieldByName('Vl_CreditoReal_A').Value);
    VBtoADOFieldSet(RsLocal, 'Variacao_A', RsDb.FieldByName('Variacao_A').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_Saldo_A', RsDb.FieldByName('Vl_Saldo_A').Value);
    // RsLocal.Fields("Obs_Deb_A") = RsDb.Fields("Obs_Deb_A")
    // RsLocal.Fields("Obs_Cred_A") = RsDb.Fields("Obs_Cred_A")
    VBtoADOFieldSet(RsLocal, 'Data_Debito_D', RsDb.FieldByName('Data_Debito_D').Value);
    VBtoADOFieldSet(RsLocal, 'Data_Credito_D', RsDb.FieldByName('Data_Credito_D').Value);
    VBtoADOFieldSet(RsLocal, 'Cartao_D', RsDb.FieldByName('Cartao_D').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar_D', RsDb.FieldByName('Vl_DebitoDolar_D').Value);
    VBtoADOFieldSet(RsLocal, 'Taxa_Debito_D', RsDb.FieldByName('Taxa_Debito_D').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar_D', RsDb.FieldByName('Vl_CreditoDolar_D').Value);
    VBtoADOFieldSet(RsLocal, 'Taxa_Credito_D', RsDb.FieldByName('Taxa_Credito_D').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal_D', RsDb.FieldByName('Vl_DebitoReal_D').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal_D', RsDb.FieldByName('Vl_CreditoReal_D').Value);
    VBtoADOFieldSet(RsLocal, 'Variacao_D', RsDb.FieldByName('Variacao_D').Value);
    VBtoADOFieldSet(RsLocal, 'Vl_Saldo_D', RsDb.FieldByName('Vl_Saldo_D').Value);
    // RsLocal.Fields("Obs_Deb_D") = RsDb.Fields("Obs_Deb_D")
    // RsLocal.Fields("Obs_Cred_D") = RsDb.Fields("Obs_Cred_D")
    RsLocal.UpdateRecord;

    RsDb.Next;
  end;

  RsLocal.Close();
  DbLocal.Close();
  RsLocal := nil;
  DbLocal := nil;
  Desconecta();
  Screen.Cursor := crDefault;
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\log.rpt';
  fMainForm.CrystalReport1.SortFields(0) := '';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;                              *)
end;

procedure TfMainForm.mnuNCAltClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  // Altera um Cliente cadastrado
  // Admin.mdb => Nome_Cliente = Opção de menu e Nome do Banco de Dados
  // Titulo_Relatorio
  // No Banco de dados do cliente também deve existir o
  // nome do cliente e o código na tabela Id
  // O banco de dados vai para o diretório Dados
  NovoClienteAlt.Show;
end;

procedure TfMainForm.mnuNCConClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  Consulta.sSqlConsulta := 'select codigo_cliente,Nome_reduzido,nome_cliente from clientes';
  gOpcao := 'adm';
  Consulta.ShowModal;
end;

procedure TfMainForm.mnuNormalClick(Sender: TObject);
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  frmBaixaBanco.Show;
end;

procedure TfMainForm.mnuNotasClick(Sender: TObject);
begin
  frmRelease.ShowModal;
end;

procedure TfMainForm.mnuNovoClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  // Cria um Cliente novo
  // Admin.mdb => Nome_Cliente = Opção de menu e Nome do Banco de Dados
  // Titilo_Relatorio
  // No Banco de dados do cliente também deve existir o
  // nome do cliente e o código na tabela Id
  // O banco de dados vai para o diretório Dados
  NovoCliente.Show;
end;

procedure TfMainForm.mnuPGODComClick(Sender: TObject);
begin
  // Saldo <> 0
  // Chama o Relatório do Crystal Report
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
//  if IsDate(gAtualizacao) then
  if gAtualizacao <> 0 then
    gData1 := DateTimeToStr(gAtualizacao)
  else
    gData1 := FormatVB(Now(),'DD/MM/YYYY');

  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    MontaRelPendencias(StrToDate(gData1), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuPGODSemClick(Sender: TObject);
begin
  // Saldo <> 0
  // Chama o Relatório do Crystal Report
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);

//  if IsDate(gAtualizacao) then
  if gAtualizacao <> 0 then
    gData1 := DateTimeToStr(gAtualizacao)
  else
    gData1 := FormatVB(Now(),'DD/MM/YYYY');

  Application.ProcessMessages;

  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    MontaRelPendencias(StrToDate(gData1), false);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuPOCComClick(Sender: TObject);
begin
  // Saldo <> 0
  // Chama o Relatório do Crystal Report
  if Length(gConciliacao)=0 then begin
    ShowMessage('Selecione Conciliação...');
    Exit;
  end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
//  if IsDate(gAtualizacao) then
  if gAtualizacao <> 0 then
    gData1 := DateTimeToStr(gAtualizacao)
  else
    gData1 := FormatVB(Now(),'DD/MM/YYYY');

  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelPendencias(StrToDate(gData1), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuPOCSemClick(Sender: TObject);
begin
  // Saldo <> 0
  // Chama o Relatório do Crystal Report
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
//  if IsDate(gAtualizacao) then begin
  if gAtualizacao <> 0 then
    gData1 := DateTimeToStr(gAtualizacao)
  else
    gData1 := FormatVB(Now(),'DD/MM/YYYY');

  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelPendencias(StrToDate(gData1), false);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuPPOCComClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data da Pendência';
  DataLimite.Label1.Caption := 'Pendências até';
  DataLimite.ShowModal; // Alterado em 7/11/2000
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelPendencias(StrToDate(gData1), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuPPOCSemClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data da Pendência';
  DataLimite.Label1.Caption := 'Pendências até';
  DataLimite.ShowModal; // Alterado em 7/11/2000
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 2;
    MontaRelPendencias(StrToDate(gData1), false);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuPPODComClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data da Pendência';
  DataLimite.Label1.Caption := 'Pendências até';
  DataLimite.ShowModal; // Alterado em 7/11/2000
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    MontaRelPendencias(StrToDate(gData1), true);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuPPODSemClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;
  gData1 := '';
  gData2 := DateTimeToStr(gAtualizacao);
  DataLimite.Caption := 'Data da Pendência';
  DataLimite.Label1.Caption := 'Pendências até';
  DataLimite.ShowModal; // Alterado em 7/11/2000
  Application.ProcessMessages;
  if gData1 <> '' then
    begin
    // gData2 = gData1
    // gData1 = ""
    // Chama o Relatório do Crystal Report
    Screen.Cursor := crHourGlass;
    gOrdem := 1;
    MontaRelPendencias(StrToDate(gData1), false);
    Screen.Cursor := crDefault;
    end;
end;

procedure TfMainForm.mnuRestauraClick(Sender: TObject);
var
  NomeArquivo : String;
begin
  if  not Autoriza(cADM) then
    Exit;

  if Length(gCliente)=0 then
    begin
    ShowMessage('Selecione Cliente');
    Exit;
    end;

  //Desconecta();
  with fMainForm.dlgCommonDialog do
    begin
    Filter := 'Access MDB (*.mdb)';
    Title := 'Banco de Dados a Restaurar';

    InitialDir := (gDataPath)+'Backup';
    FileName := '';
    Execute();
    if FileName<>'' then
      begin
      NomeArquivo := FileName;
      if AnsiUpperCase(RightStr(NomeArquivo, 4))<>'.MDB' then
        begin
        ShowMessage('Arquivo não é Banco de Dados');
        end
      else
        begin
        Screen.Cursor := crHourGlass;
        if FileExists(NomeArquivo) then
          begin
          if (1+Pos(gCliente+'_', PChar(NomeArquivo)+1))=0 then
            begin
            ShowMessage('Banco de Dados não é deste Cliente');
            end
          else
            begin
            CopyFile(PChar(NomeArquivo), PChar((gDataPath)+gCliente+'.MDB'), false);
//            Conecta('');           ?????????????????????????????
            Screen.Cursor := crDefault;
            ShowMessage('Backup Restaurado!!!');
            end;
          end;
        Screen.Cursor := crDefault;
        end;
    end;
  end;
end;

procedure TfMainForm.mnuRotMesClick(Sender: TObject);
label
  Erro;
var
  NomeArquivo: String;
begin
  if  not Autoriza(cATUALIZA) then
    Exit;

  if Application.MessageBox('O Mês ja foi fechado? Confirma Operação?', 'Backup do Movimento Zerado', MB_YESNO)=IDNO then
    Exit;

  // BackUp Mensal do Banco de Dados

  Screen.Cursor := crHourGlass;

  // Backup do Banco antes de quebrar
  LimpaBackUp(10);
  NomeArquivo := gAdmPath+'\';
  NomeArquivo := NomeArquivo+gCliente+'\Backup\';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
  NomeArquivo := NomeArquivo+gCliente+'_';
  NomeArquivo := NomeArquivo+'Geral'+'.mdb';

  CopyFile(PChar((gDataPath)+gDataFile), PChar(NomeArquivo), false);

  if  not QuebraBanco() then begin
    ShowMessage('Erro na Cópia do Banco');
    Screen.Cursor := crDefault;
    Exit;
  end;

  //Desconecta();

  LimpaBackUp(10);
  NomeArquivo := gAdmPath+'\';
  NomeArquivo := NomeArquivo+gCliente+'\BackupMensal\';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
  NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
  NomeArquivo := NomeArquivo+'Hist_'+gCliente+'_';
  NomeArquivo := NomeArquivo+'Mensal'+'.mdb';

  try  // On Error GoTo Erro
    // Copia o Arquivo gerado pelo Quebrabanco para o diretório
    // BackupMensal
    CopyFile(PChar((gDataPath)+'Hist_'+gDataFile), PChar(NomeArquivo), false);

    LimpaBackUp(10);
    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\Backup\';
    NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
    NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
    NomeArquivo := NomeArquivo+gCliente+'_';
    NomeArquivo := NomeArquivo+'Geral'+'.mdb';

    // Copia o Arquivo com movimento gerado pelo Quebrabanco
    // para o diretório Backup
    CopyFile(PChar((gDataPath)+gDataFile), PChar(NomeArquivo), false);

    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\Backup_temp\';
{    nome := Dir(NomeArquivo+'*.mdb');              // Isso não faz sentido no SQLServer, pelo menos não desse jeito!
    while Dir(NomeArquivo+'*.mdb')<>'' do
      begin
      if (1+Pos('Geral', PChar(nome)+1))=0 then
        begin
        DeleteFile(NomeArquivo+nome);
        end;
      nome := Dir(NomeArquivo+'*.mdb');
      end;  }

    // Deleta arquivos antigos

    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\entrada\';
{    nome := Dir(NomeArquivo+'*.*');
    while nome<>'' do begin
      if Length(Trim(DateToStr(gDataRelatorio)))=0 then break;
      sData := FormatVB(DateToStr(gDataRelatorio),'YYYYMMDD');
      if (1+Pos(sData, PChar(nome)+1))=0 then begin
        DeleteFile(NomeArquivo+nome);
        nome := Dir(NomeArquivo+'*.*');
       end  else  begin
        nome := Dir();
      end;
    end;      }

    Screen.Cursor := crDefault;
    ShowMessage('BackUp Mensal Efetuado.');
    Exit;
  except  // Erro:
    Screen.Cursor := crDefault;
    ShowMessage(PChar('Erro no BackUp.'+#10+'Err.Description'));
    //Err.Clear();
  end;
end;

procedure TfMainForm.mnuSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfMainForm.mnuSaldoContClick(Sender: TObject);
var
  sSaldo: String;
  STR, STR1, STR2: TStringList;
  Pont: Smallint;
begin
 STR := TStringList.Create;
 STR1 := TStringList.Create;
 STR2 := TStringList.Create;

  // Mostra os saldos atuais das contas
  gArquivo11 := '';

//  if  not Conecta('adm') then Exit;
  if not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

  sSql := 'select nm_conciliacao,conta_contabil,cd_cli_banco from tb_tipo_con ';
  sSql := sSql+'where cliente = '#39''+gCliente+''#39'';
  sSql := sSql+' order by conta_contabil ';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  while not RsDbDs.EOF do
    begin
      STR.Add(Copy(RsDbDs.FieldByName('nm_conciliacao').AsString, 1, 36));
      STR1.Add(RsDbDs.FieldByName('conta_contabil').AsString);
      STR2.Add(RsDbDs.FieldByName('cd_cli_banco').AsString);
      Next;
    end;

  STR1.Add('999999');

  RsDbDs.Close;
  gBanco.Close;

//  if  not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

  sSql := 'select * from tbBalancete ';
  // sSql = sSql & "where str(Data) = '09/05/2003'"
  sSql := sSql+'where str(Data) = '#39''+FormatVB(Now()-1,'DD/MM/YYYY')+''#39'';
  sSql := sSql+' order by conta_contabil ';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  if RsDbDs.EOF then
    begin
    //Desconecta();
    Str.Clear;
    Str1.Clear;
    Str2.Clear;
//    ReDim(STR, 0+1);
//    ReDim(STR1, 0+1);
//    ReDim(STR2, 0+1);
    RsDbDs.Close;
    gBanco.Close;
    ShowMessage('Relatório vazio !!!');
    Exit;
    end;

  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Balancete de Verificação               Dolar: ' +
                              RsDbDs.FieldByName('UsDolar').Value + #10+#10 +
                              '     Descrição da Conta              Conta XXX       Conta      ' +
                              'Saldo Anterior            Débito           Crédito       Saldo Atual'
    +#10+#10;

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Gerando Balancete do Dia';

  while not RsDbDs.EOF do
    begin
    PBar.ProgressBar1.Position := RsDbDs.Recno; //PercentPosition;
    Application.ProcessMessages;

    Pont := 0; //1;
    while STR1[Pont] <> RsDbDs.FieldByName('Conta_Contabil').AsString do
      Inc(Pont);

       {? On Error Resume Next  }

    frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+STR[Pont]+StringOfChar(' ', 38-Length(STR[Pont]))+STR1[Pont]+StringOfChar(' ', 16-Length(STR2[Pont]))+STR2[Pont];

      // Space (16) ' Conta ????

    sSaldo := FormatVB(RsDbDs.FieldByName('SaldoAnt').AsString,'##,###,###,##0.00');
    frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+StringOfChar(' ', 18-Length(sSaldo))+sSaldo;

    sSaldo := FormatVB(RsDbDs.FieldByName('Debito').AsString,'##,###,###,##0.00');
    frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+StringOfChar(' ', 18-Length(sSaldo))+sSaldo;

    sSaldo := FormatVB(RsDbDs.FieldByName('Credito').AsString,'##,###,###,##0.00');
    frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+StringOfChar(' ', 18-Length(sSaldo))+sSaldo;

    sSaldo := FormatVB(RsDbDs.FieldByName('SaldoAnt').AsCurrency + RsDbDs.FieldByName('Credito').AsCurrency -
                       RsDbDs.FieldByName('Debito').AsCurrency,'##,###,###,##0.00');
    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + StringOfChar(' ', 18-Length(sSaldo)) + sSaldo + #10;

    RsDbDs.Next;
    end;

  Str.Free;// ReDim(STR, 0+1);
  Str1.Free;//ReDim(STR1, 0+1);
  Str2.Free;//ReDim(STR2, 0+1);

  //Desconecta();
  RsDbDs.Close;
  gBanco.Close;

  PBar.Close;
  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close;
  frmLog.WindowState := wsMaximized;
  frmLog.ShowModal;

end;

procedure TfMainForm.mnuSDiaClick(Sender: TObject);
var
  RsLocal: TADODataSet;
  Saldo: Extended;
  sSaldo,
  Conta: String;
  dMovimento,
  xDt1, xDt2: TDateTime;


    function MaxData : TDateTime;
    begin

  // Retorna a data do lançamento mais recente

      sSql := 'select max(data_debito) from lancamentos where conta_contabil='#39'';
      sSql := sSql + Conta+''#39'';
      RsDbQry.SQL.Clear;
      RsDbQry.SQL.Add(sSql);
      RsDbQry.Open;
      xDt1 := RsDbQry.Fields[0].AsDateTime;

      sSql := 'select max(data_credito) from lancamentos where conta_contabil='#39'';
      sSql := sSql + Conta+''#39'';
      RsDbQry.Close;
      RsDbQry.SQL.Clear;
      RsDbQry.SQL.Add(sSql);
      RsDbQry.Open;
      xDt2 := RsDbQry.Fields[0].AsDateTime;

      if xDt1 > xDt2 then
        Result := xDt1
      else
        Result := xDt2;

      RsDbQry.Close;

    end;


begin
  // Mostra os saldos atuais das contas
  gArquivo11 := '';

//  if  not Conecta('') then Exit;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    Exit;

  LastAtualiza;

  sSql := 'select * from tb_opcao ';
  sSql := sSql+'order by conta_contabil ';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  RsLocal := TAdoDataSet.Create(nil);
  RsLocal.Connection := gBanco;

//  RsLocal := gBanco.OpenRecordset(sSql);
  RsLocal.CommandText := sSql;
  RsLocal.Open;
  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Saldo atualizado até: ' + DateTimeToStr(gAtualizacao) + #10 +
                              StringOfChar(' ', 62) + 'Último' + #10 + StringOfChar(' ', 62) + 'Movimento      ' + '         Saldo' +
                              #10+#10;

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Gerando Saldos do Dia';

  while not RsDbDs.EOF do
    begin
    PBar.ProgressBar1.Position := RsDbDs.RecNo; // .PercentPosition;
    Application.ProcessMessages;
    Conta := RsDbDs.FieldByName('conta_contabil').AsString;
    sSql := 'select sum(vl_saldo) from lancamentos where conta_contabil='#39'';
    sSql := sSql + Conta + ''#39'';
    RsLocal.Close;
//      RsLocal := gBanco.OpenRecordset(sSql);
    RsLocal.CommandText := sSql;
    RsLocal.Open;
       {? On Error Resume Next  }
    Saldo := RsLocal.Fields[0].AsExtended;
       {? On Error GoTo 0 }
    sSaldo := FormatVB(Saldo,'##,###,##0.00');
    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + Conta + StringOfChar(' ', 17 - length(Conta)) +
                                RsDbDs.FieldByName('opcao').AsString;

    dMovimento := MaxData;
//      if not IsDate(dMovimento) then
    if dMovimento = 0 then
      dMovimento := StrToDateTime(StringOfChar(' ', 10));
    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + StringOfChar(' ', 55-sizeof(RsDbDs.FieldByName('opcao').Value)-10) +
                                DateTimeToStr(dMovimento) + StringOfChar(' ', 30-Length(sSaldo)-Length(DateTimeToStr(dMovimento))) +
                                sSaldo+#10;

    RsDbDs.Next;
    end;

  RsLocal.Close;
  RsLocal.Free;
//  Desconecta();
  RsDbDs.Close;
  gBanco.Close;
  PBar.Close;
  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close;
  frmLog.WindowState := wsMaximized;
  frmLog.ShowModal;
end;

procedure TfMainForm.mnuTCAlterarClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  if Length(gCliente)=0 then
    begin
    PedeAlteracao.Caption := 'Inclui Conciliação';
    PedeAlteracao.Label1.Caption := 'Nome do Cliente';
    gOpcao := '';
    PedeAlteracao.ShowModal;
    if Trim(gOpcao) = '' then
      Exit
    else
      begin
      gCliente := gOpcao;
      gDataPath := ExtractFileDir(Application.ExeName) + '\'+gCliente+'\';
      gDataFile := gCliente+'.mdb';

      if FileExists((gDataPath)+gDataFile) then
        begin
        ShowMessage('Cliente não Cadastrado');
        gCliente := '';
        Exit;
        end;
      end;
    end;

  if gCliente = '' then
    begin
    gCliente := gOpcao;
    fMainForm.sbStatusBar.Panels.Items[1-1].Text := 'Cliente: '+gCliente;
    end;

  PedeAlteracao.Caption := 'Altera Tipo de Conciliação';
  PedeAlteracao.Label1.Caption := 'Conta Contábil';
  gOpcao := '';

  PedeAlteracao.ShowModal;
  Screen.Cursor := crHourGlass;
  if gOpcao <> '' then
    begin
//    if  not Conecta('adm') then Exit;
    if  not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
      Exit;

    sSql := 'select * from tb_tipo_con where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
    sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDbDs.CommandText := sSql;
    if RsDbDs.EOF then
      Application.MessageBox('Conciliação não Cadastrada', 'Seleção de Conciliação', MB_ICONSTOP)
//      Desconecta();
    else
      begin
      gTipo_Rec := 2;
    // TipoCon.Show
      TipoConAdm.Show;
      end;
    RsDbDs.Close;
    gBanco.Close;
    Screen.Cursor := crDefault;
    end;
  Screen.Cursor := crDefault;
end;

procedure TfMainForm.mnuTCExclClick(Sender: TObject);
label
  Saida;
//var
//  DbLocal: Database;
//  RsLocal: TADODataSet;
begin
  if  not Autoriza(cADM) then
    Exit;

  if Length(gCliente)=0 then
    begin
    PedeAlteracao.Caption := 'Exclui Conciliação';
    PedeAlteracao.Label1.Caption := 'Nome do Cliente';
    gOpcao := '';
    PedeAlteracao.ShowModal;
    if Trim(gOpcao)='' then
      Exit
    else
      begin
      gCliente := gOpcao;
      gDataPath := ExtractFileDir(Application.ExeName) + '\'+gCliente+'\';
      gDataFile := gCliente+'.mdb';

      if Not FileExists((gDataPath)+gDataFile) then
        begin
        ShowMessage('Cliente não Cadastrado');
        gCliente := '';
        Exit;
        end;
      end;
    end;

  PedeAlteracao.Caption := 'Exclui Conciliação';
  PedeAlteracao.Label1.Caption := 'Conta Contábil';
  gOpcao := '';
  PedeAlteracao.ShowModal();
  if gOpcao='' then
//    Desconecta();
    Exit;

//  if gOpcao <> '' then
//    begin
//    DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
  Conecta(gBanco, gAdmPath+'\admin.udl');
//    sSql := 'select * from tb_tipo_con where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
  sSql := 'conta_contabil = '#39''+TiraPontos(gOpcao, '2')+''#39'';
  sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
//    RsLocal := DbLocal.OpenRecordset(sSql);
  RsTb.TableName := 'tb_tipo_con';
  RsTb.Filter := sSql;
  RsTb.Open;

  if RsTb.EOF then
    begin
    Application.MessageBox('Conciliação não Cadastrada', 'Seleção de Conciliação', MB_ICONSTOP);
    RsTb.Close;
    gBanco.Close;
    Exit;
    end;

//    if  not Conecta('') then
  if not Conecta(gBancoCli, gDataPath + gDataFile + '.udl') then
    begin
    RsTb.Close;
    gBanco.Close;
    Exit;
    end;

  sSql := '';
  sSql := sSql+'Select * from [lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
  sSql := sSql+' and Vl_Saldo <> 0';
  //RsDb := gBanco.OpenRecordset(sSql);

  RsDbQryCli.SQL.Clear;
  RsDbQryCli.SQL.Add(sSql);
  RsDbQryCli.Open;

  if not RsDbQryCli.EOF then
    begin
    ShowMessage('Conciliação tem lançamentos abertos. Não pode ser excluida');
    RsDbQryCli.Close;
    RsTb.Close;
    gBanco.Close;
    gBancoCli.Close;
    Exit;
    end;

    // sSql = ""
    // sSql = sSql & "Select * from [lancamentos] "
    // sSql = sSql & " where conta_contabil = '" & TiraPontos(gOpcao, 2) & "'"
    // Set RsDb = gBanco.OpenRecordset(sSql)
    // If RsDb.EOF Then
    // GoTo Saida
    // End If
  if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then
    begin
      // Deleta os lançamentos
      // sSql = ""
      // sSql = sSql & "Delete * from [lancamentos] "
      // sSql = sSql & " where conta_contabil = '" & TiraPontos(gOpcao, 2) & "'"
      // gBanco.Execute sSql
      // RsDb.Delete
    sSql := '';
    sSql := sSql+'Delete * from [tb_opcao] ';
    sSql := sSql+' where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
    gBancoCli.Execute(sSql);

      // Deleta de admin.tb_tipo_con
    RsTb.Delete;

    sSql := '';
      // sSql = sSql & "Delete * from [tbcontas] "
    sSql := sSql+'Delete * from [tbcontasAdm] ';
    sSql := sSql+' where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
      // gBanco.Execute sSql
    gBanco.Execute(sSql);
    end;
  // Deleta registro do Admin
//  Desconecta();

  RsDbQryCli.Close;
  RsTb.Close;
  gBanco.Close;
  gBancoCli.Close;

end;

procedure TfMainForm.mnuTCIncClick(Sender: TObject);
begin
  if  not Autoriza(cADM) then
    Exit;

  if Length(gCliente) = 0 then
    begin
    PedeAlteracao.Caption := 'Inclui Conciliação';
    PedeAlteracao.Label1.Caption := 'Nome do Cliente';
    gOpcao := '';
    PedeAlteracao.ShowModal;
    if Trim(gOpcao) = '' then
      Exit
    else
      begin
      gCliente := gOpcao;
      gDataPath := ExtractFileDir(Application.ExeName) + '\'+gCliente+'\';
      gDataFile := gCliente+'.udl';

      if not FileExists(gDataPath+gDataFile) then
        begin
        ShowMessage('Cliente não Cadastrado');
        gCliente := '';
        Exit;
        end;
      end;
    end;
  gTipo_Rec := 1;
  // TipoCon.Show
  TipoConAdm.Show;
end;

procedure TfMainForm.mnuTeste1Click(Sender: TObject);
var
  DbAdm, DbConsulta: TAdoConnection;
  RsDb, RsAdm: TADODataSet;
  RsDb2: TAdoTable;
begin

//begin
  // Gera_Resumo        Este estava originalmente comentado
//  Gera_Resumo_2();

  // Le dados da tabela Consulta e atualiza a tabela cliente.tb_opcao
//  DbAdm := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
//  DbConsulta := gWork.OpenDatabase(gAdmPath+'\contabil.mdb');
  Conecta(DbAdm, gAdmPath+'\admin.udl');
  Conecta(DbConsulta, gAdmPath+'\contabil.udl');

  RsDb := TAdoDataSet.Create(nil);
  RsAdm := TAdoDataSet.Create(nil);
  RsDb2 := TAdoTable.Create(nil);

  // sSql = ""
  // sSql = sSql & "select * from [consulta] "
  // Set RsConsulta = DbAdm.OpenRecordset(sSql)

  sSql := '';
  sSql := sSql+'Select * from [clientes] ';
  //RsAdm := DbAdm.OpenRecordset(sSql);
  RsAdm.Connection := DbAdm;
  RsAdm.CommandText := sSql;
  RsAdm.CommandType := cmdText;
  RsAdm.Open;

  while not RsAdm.EOF do
    begin // Clientes
    // Obtem o nome do banco de dados e o diretorio de trabalho
    gDataFile := RsAdm.FieldByName('Nome_Reduzido').Value+'.udl';
    gCliente := RsAdm.FieldByName('Nome_Reduzido').Value;
    gDataPath := gAdmPath+'\'+gCliente+'\';

    if not Conecta(gBanco, gDataPath + gDataFile) then//    if  not Conecta('') then begin
      begin
      RsDb.Free;
      RsAdm.Free;
      RsDb2.Free;
      ShowMessage('Erro na Abertura do banco: '+gDataFile);
      Exit;
      end;

    sSql := '';
    sSql := sSql+'Select * from [consulta] ';
    sSql := sSql+'where cliente = '#39''+(RsAdm.FieldByName('Nome_Reduzido').Value)+''#39'';
//    RsDb := DbConsulta.OpenRecordset(sSql);
    RsDb.Connection := DbConsulta;
    RsDb.CommandText := sSql;
    RsDb.Open;

    while not RsDb.EOF do
      begin // tb_opcao
      sSql := '';
//      sSql := sSql+'Select * from [tbcontas] ';
//      sSql := sSql+'where conta_contabil = '#39''+(RsDb.FieldByName('conta_contabil').Value)+''#39'';
      sSql := sSql+'conta_contabil = '#39''+(RsDb.FieldByName('conta_contabil').Value)+''#39'';
      sSql := sSql+' and codigo = '#39''+(RsDb.FieldByName('conta').Value)+''#39'';
      sSql := sSql+' and natureza = '#39''+(RsDb.FieldByName('natureza').Value)+''#39'';
      sSql := sSql+' and ref = '#39''+String(RsDb.FieldByName('ref').Value)+''#39'';
//      RsDb2 := gBanco.OpenRecordset(sSql);
      RsDb2.Connection := gBanco;
      RsDb2.TableName := 'tbcontas';
      RsDb2.Filter := sSql;
      RsDb2.Filtered := True;
      RsDb2.Open;

      if RsDb2.EOF then;
        // MsgBox "??"
      while not RsDb2.EOF do
        begin // tb_opcao
//        with RsDb2 do

        RsDb2.Edit;

        VBtoADOFieldSet(RsDb2, 'Relatorio_Origem', RsDbDs.FieldByName('Rel_Origem_Primario').Value);
          // .Fields("Rel_Origem_Secundario") = " "
        VBtoADOFieldSet(RsDb2, 'Template', RsDb.FieldByName('template').Value);
        VBtoADOFieldSet(RsDb2, 'Arquivo_Saida', RsDb.FieldByName('template').Value);
        VBtoADOFieldSet(RsDb2, 'Obs_Deb', RsDb.FieldByName('Obs_Deb').Value);
        VBtoADOFieldSet(RsDb2, 'Obs_Cred', RsDb.FieldByName('Obs_Cred').Value);

        RsDb2.Post;

        RsDb2.Next; // Próxima Conta
        end;
      RsDb.Next; // Próxima Conta Contabil
    end;
    RsAdm.Next; // Próximo cliente
  end;

  ShowMessage('Arquivo Atualizado');

  RsDb.Close;
  RsAdm.Close;
  RsDb2.Close;
  DbAdm.Close;
  DbConsulta.Close;
  gBanco.Close;

  RsDb.Free;
  RsAdm.Free;
  RsDb2.Free;
  DbAdm.Free;
  DbConsulta.Free;
//  Desconecta;
end;

procedure TfMainForm.mnuVarGerClick(Sender: TObject);
begin
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  ShowMessage('Rever esta rotina de relatório');

 (* gData1 := FormatVB(Now(),'DD/MM/YYYY');
  // Localizar registros
  if  not Conecta('') then Exit;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and  month(Data_Variacao) <> Null ';
  sSql := sSql+' and year(Data_Variacao) <> Null ';
  RsDb := gBanco.OpenRecordset(sSql);
  if RsDb.EOF then begin
    ShowMessage('Não Existe Variação a Processar.');
    Desconecta();
    Exit;
  end;
  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Deleta Dados de Relatorio
  // sSql = "delete from Relatorio"
  // DbLocal.Execute sSql
  // 
  // Grava Período na tabela para Relarório
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // If RsLocal.EOF Then
  // RsLocal.AddNew
  // Else
  // RsLocal.Edit
  // End If
  // RsLocal.Fields("MesVariacao") = NomeDoMes(Month(gData1))
  // 
  // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
  // RsLocal.Fields("Nome_Reduzido") = gCliente
  // 
  // RsLocal.Fields("nm_conciliacao") = gConciliacao
  // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  // RsLocal.Update

  // Faz tudo comentado acima
  GravaHeaderRel(DbLocal, RsLocal, 1);

  sSql := 'select * from Relatorio';
  RsLocal := DbLocal.OpenRecordset(sSql);

  // Fazer Variação
  with RsDb do begin
    while  not EOF do begin
      // Teste colocado em 08/11/2000 a pedido do Jonas para evitar variação de
      // lançamentos em Real
      if (CDbl(FieldByName('Vl_CreditoDolar').Value)<>0) or (CDbl(FieldByName('Vl_DebitoDolar').Value)<>0) then begin
        RsLocal.Insert;
        VBtoADOFieldSet(RsLocal, 'Data_Debito', FieldByName('Data_Debito').Value);
        VBtoADOFieldSet(RsLocal, 'Data_Credito', FieldByName('Data_Credito').Value);
        VBtoADOFieldSet(RsLocal, 'Data_Variacao', FieldByName('Data_Variacao').Value);
        if sizeof(FieldByName('Data_Debito').Value)=0 then begin
          VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Credito').Value);
         end  else  begin
          if sizeof(FieldByName('Data_Credito').Value)=0 then begin
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Debito').Value);
          end;
        end;
        if (sizeof(FieldByName('Data_Debito').Value)<>0) and (sizeof(FieldByName('Data_Credito').Value)<>0) then begin
          if isDataMenorIgual(String(FieldByName('Data_Debito').Value), String(FieldByName('Data_Credito').Value)) then begin
            // pega data menor
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
          end;
        end;
        if (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') then begin
          VBtoADOFieldSet(RsLocal, 'Cartao', FieldByName('Cartao').Value);
          VBtoADOFieldSet(RsLocal, 'Cartao1', FieldByName('Cartao1').Value);
         end  else  begin
          VBtoADOFieldSet(RsLocal, 'Cartao', 'Variação Cambial');
        end;
        VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', FieldByName('Vl_DebitoDolar').Value);
        VBtoADOFieldSet(RsLocal, 'Taxa_Debito', FieldByName('Taxa_Debito').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', FieldByName('Vl_CreditoDolar').Value);
        VBtoADOFieldSet(RsLocal, 'Taxa_Credito', FieldByName('Taxa_Credito').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal', FieldByName('Vl_DebitoReal').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal', FieldByName('Vl_CreditoReal').Value);
        VBtoADOFieldSet(RsLocal, 'Variacao', FieldByName('Variacao').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_Saldo').Value);
        VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', FieldByName('Dias_Pendentes').Value);

        // Alterações visando a implementação da CONTABILIDADE
        // If Not IsNull(.Fields("Obs_Deb")) Then
        // RsLocal.Fields("Obs_Deb") = RsDb.Fields("Obs_Deb")
        // End If
        // If Not IsNull(.Fields("Obs_Cred")) Then
        // RsLocal.Fields("Obs_Cred") = RsDb.Fields("Obs_Cred")
        // End If

        RsLocal.UpdateRecord;
      end;
      Next;
    end;
  end;

  // Mostra Relatório
  Application.ProcessMessages();
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\variac_g.rpt';
  fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;
  // fMainForm.CrystalReport1.Action = 1       *)
end;

procedure TfMainForm.mnuVarMesClick(Sender: TObject);
begin
  // Pedir Mês
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  ShowMessage('Rever esta rotina de relatório');

  (*gData1 := '';
  gData2 := '';
  frmMes1.ShowModal();
  Application.ProcessMessages();
  if gData1='' then begin
    Exit;
  end;
  if  not isDataValida('01/'+gData1) then begin
    ShowMessage('Data da Variação Inválida.');
    Exit;
  end;
  Mes := Copy(gData1, 1, 2);
  Ano := Copy(gData1, 4, 4);

  // Localizar registros
  if  not Conecta('') then Exit;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and ( month(Data_Variacao) =  '+FloatToStr(vbVal(Mes));
  sSql := sSql+' and year(Data_Variacao) =  '+FloatToStr(vbVal(Ano))+')';
  RsDb := gBanco.OpenRecordset(sSql);

  if RsDb.EOF then begin
    ShowMessage('Não Existe Variação a Processar.');
    Desconecta();
    Exit;
  end;

  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Deleta Dados de Relatorio
  // sSql = "delete from Relatorio"
  // DbLocal.Execute sSql
  // 
  // Grava Período na tabela para Relarório
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // If RsLocal.EOF Then
  // RsLocal.AddNew
  // Else
  // RsLocal.Edit
  // End If
  // RsLocal.Fields("MesVariacao") = NomeDoMes(gData1)
  // 
  // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
  // RsLocal.Fields("Nome_Reduzido") = gCliente
  // 
  // RsLocal.Fields("nm_conciliacao") = gConciliacao
  // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  // RsLocal.Update

  // Faz tudo comentado acima
  GravaHeaderRel(DbLocal, RsLocal, 1);

  sSql := 'select * from Relatorio';
  RsLocal := DbLocal.OpenRecordset(sSql);

  // Fazer Variação
  with RsDb do begin
    while  not EOF do begin
      // Teste colocado em 08/11/2000 a pedido do Jonas para evitar variação de
      // lançamentos em Real
      if (CDbl(FieldByName('Vl_CreditoDolar').Value)<>0) or (CDbl(FieldByName('Vl_DebitoDolar').Value)<>0) then begin
        RsLocal.Insert;
        VBtoADOFieldSet(RsLocal, 'Data_Debito', FieldByName('Data_Debito').Value);
        VBtoADOFieldSet(RsLocal, 'Data_Credito', FieldByName('Data_Credito').Value);
        VBtoADOFieldSet(RsLocal, 'Data_Variacao', FieldByName('Data_Variacao').Value);

        if sizeof(FieldByName('Data_Debito').Value)=0 then begin
          VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Credito').Value);
         end  else  begin
          if sizeof(FieldByName('Data_Credito').Value)=0 then begin
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Debito').Value);
          end;
        end;
        if (sizeof(FieldByName('Data_Debito').Value)<>0) and (sizeof(FieldByName('Data_Credito').Value)<>0) then begin
          if isDataMenorIgual(String(FieldByName('Data_Debito').Value), String(FieldByName('Data_Credito').Value)) then begin
            // pega data menor
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
          end;
        end;

        if (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') then begin
          VBtoADOFieldSet(RsLocal, 'Cartao', FieldByName('Cartao').Value);
          VBtoADOFieldSet(RsLocal, 'Cartao1', FieldByName('Cartao1').Value);
         end  else  begin
          VBtoADOFieldSet(RsLocal, 'Cartao', 'Variação Cambial');
        end;
        VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', FieldByName('Vl_DebitoDolar').Value);
        VBtoADOFieldSet(RsLocal, 'Taxa_Debito', FieldByName('Taxa_Debito').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', FieldByName('Vl_CreditoDolar').Value);
        VBtoADOFieldSet(RsLocal, 'Taxa_Credito', FieldByName('Taxa_Credito').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal', FieldByName('Vl_DebitoReal').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal', FieldByName('Vl_CreditoReal').Value);
        VBtoADOFieldSet(RsLocal, 'Variacao', FieldByName('Variacao').Value);
        VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_Saldo').Value);
        VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', FieldByName('Dias_Pendentes').Value);

        // Alterações visando a implementação da CONTABILIDADE
        // If Not IsNull(.Fields("Obs_Deb")) Then
        // RsLocal.Fields("Obs_Deb") = RsDb.Fields("Obs_Deb")
        // End If
        // If Not IsNull(.Fields("Obs_Cred")) Then
        // RsLocal.Fields("Obs_Cred") = RsDb.Fields("Obs_Cred")
        // End If

        RsLocal.UpdateRecord;
      end;
      Next;
    end;
  end;

  // Mostra Relatório
  Application.ProcessMessages();
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\variac.rpt';
  fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;
  // fMainForm.CrystalReport1.Action = 1               *)
end;

procedure TfMainForm.mnuVarPendClick(Sender: TObject);
begin
  // Pedir Mês
  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

  ShowMessage('Rever esta rotina de relatório');

  (*gData1 := '';
  gData2 := '';
  Application.ProcessMessages();
  gData2 := FormatVB(Now(),'DD/MM/YYYY');
  // Localizar registros
  if  not Conecta('') then Exit;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

  sSql := sSql+' and Vl_DebitoReal <>  '+FloatToStr(CDbl(0));
  sSql := sSql+' and Vl_CreditoReal <>  '+FloatToStr(CDbl(0));
  sSql := sSql+' and Vl_Saldo <>  '+FloatToStr(CDbl(0));
  RsDb := gBanco.OpenRecordset(sSql);

  if RsDb.EOF then begin
    ShowMessage('Não Existe Variação Pendente.');
    Desconecta();
    Exit;
  end;

  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Deleta Dados de Relatorio
  // sSql = "delete from Relatorio"
  // DbLocal.Execute sSql
  // 
  // Grava Período na tabela para Relarório
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // If RsLocal.EOF Then
  // RsLocal.AddNew
  // Else
  // RsLocal.Edit
  // End If
  // RsLocal.Fields("MesVariacao") = NomeDoMes(gData1)
  // 
  // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
  // RsLocal.Fields("Nome_Reduzido") = gCliente
  // 
  // RsLocal.Fields("nm_conciliacao") = gConciliacao
  // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  // RsLocal.Update

  // Faz tudo comentado acima
  GravaHeaderRel(DbLocal, RsLocal, 1);

  sSql := 'select * from Relatorio';
  RsLocal := DbLocal.OpenRecordset(sSql);

  // Fazer Variação
  with RsDb do begin
    while  not EOF do begin
      // Teste colocado em 08/11/2000 a pedido do Jonas para evitar variação de
      // lançamentos em Real
      if (CDbl(FieldByName('Vl_CreditoDolar').Value)<>0) or (CDbl(FieldByName('Vl_DebitoDolar').Value)<>0) then begin
        if (FieldByName('Data_Credito')<=CDate(gData2)) or (FieldByName('Data_Debito')<=CDate(gData2)) then begin
          // Gravar Relatório
          RsLocal.Insert;
          VBtoADOFieldSet(RsLocal, 'Data_Debito', FieldByName('Data_Debito').Value);
          VBtoADOFieldSet(RsLocal, 'Data_Credito', FieldByName('Data_Credito').Value);
          VBtoADOFieldSet(RsLocal, 'Data_Variacao', FieldByName('Data_Variacao').Value);

          if sizeof(FieldByName('Data_Debito').Value)=0 then begin
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Credito').Value);
           end  else  begin
            if sizeof(FieldByName('Data_Credito').Value)=0 then begin
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', FieldByName('Data_Debito').Value);
            end;
          end;
          if (sizeof(FieldByName('Data_Debito').Value)<>0) and (sizeof(FieldByName('Data_Credito').Value)<>0) then begin
            if isDataMenorIgual(String(FieldByName('Data_Debito').Value), String(FieldByName('Data_Credito').Value)) then begin
              // pega data menor
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
            end;
          end;

          if (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') then begin
            VBtoADOFieldSet(RsLocal, 'Cartao', FieldByName('Cartao').Value);
            VBtoADOFieldSet(RsLocal, 'Cartao1', FieldByName('Cartao1').Value);
           end  else  begin
            VBtoADOFieldSet(RsLocal, 'Cartao', 'Variação Cambial');
          end;
          VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', FieldByName('Vl_DebitoDolar').Value);
          VBtoADOFieldSet(RsLocal, 'Taxa_Debito', FieldByName('Taxa_Debito').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', FieldByName('Vl_CreditoDolar').Value);
          VBtoADOFieldSet(RsLocal, 'Taxa_Credito', FieldByName('Taxa_Credito').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal', FieldByName('Vl_DebitoReal').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal', FieldByName('Vl_CreditoReal').Value);
          VBtoADOFieldSet(RsLocal, 'Variacao', FieldByName('Variacao').Value);
          VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_Saldo').Value);
          VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', FieldByName('Dias_Pendentes').Value);
          // Alterações visando a implementação da CONTABILIDADE
          // If Not IsNull(.Fields("Obs_Deb")) Then
          // RsLocal.Fields("Obs_Deb") = RsDb.Fields("Obs_Deb")
          // End If
          // If Not IsNull(.Fields("Obs_Cred")) Then
          // RsLocal.Fields("Obs_Cred") = RsDb.Fields("Obs_Cred")
          // End If
          RsLocal.UpdateRecord;
        end;
      end;
      Next;
    end;
  end;
  RsLocal.Close();
  RsDb.Close();
  RsDb := nil;
  RsLocal := nil;

  // Mostra Relatório
  Application.ProcessMessages();
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\variac_p.rpt';
  fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;
  // fMainForm.CrystalReport1.Action = 1         *)
end;

procedure TfMainForm.BatimentoConta;
var
  ArqEntrada: System.Text;
  cont, Tam: Smallint;
  Buffer, A, B,
  NomeArquivo: String;
  iFileLen, iPos, lCountLine: Longint;
  DbLocal: TAdoConnection;
  RsDb: TAdoTable;
begin
  gAdmPath := ExtractFileDir(Application.ExeName);
//  gWork := DBEngine.Workspaces(0);
  //gBanco := gWork.OpenDatabase(gAdmPath+'\CC_Temp1.mdb');
  Conecta(gBanco, gAdmPath+'\CC_Temp1.udl');
  RsDb := TAdoTable.Create(nil);
  RsDb.Connection := gBanco;

//  ArqEntrada := 1{indifferently};
  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);

//  sSql := 'delete  from JuntadoDC';
  sSql := 'Truncate table JuntadoDC';
  gBanco.Execute(sSql);

  sSql := 'select * from JuntadoDC';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.TableName := 'JuntadoDC';
  RsDb.Open;

  iPos := 0;
  lCountLine := 0;
  iFileLen := FileSizeByName(NomeArquivo);
  PegaPar;
  PBar.Caption := 'Fase 1 de 3 Cred';
  PBar.ProgressBar1.Visible := true;

  while not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    // Tabela de Créditos
    if Length(Buffer) < 20 then
      break;
    RsDb.Insert;
    VBtoADOFieldSet(RsDb, 'Texto', Buffer+'C');
    RsDb.Post;

    iPos := iPos+Length(Buffer);
    lCountLine := lCountLine+1;
    // If lCountLine = 370 Then Exit Do
    if (lCountLine mod 10) = 0 then
      begin
      PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
      Application.ProcessMessages;
      end;
    end;

  PBar.ProgressBar1.Position := 100;
  PBar.ProgressBar1.Visible := false;
  CloseFile(ArqEntrada);

  NomeArquivo := ExtractFileDir(Application.ExeName) + '\';
  NomeArquivo := NomeArquivo+gCliente+'\Bx_Banco_Deb\'+Trim(Concil.ContaContabil);
  NomeArquivo := NomeArquivo+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeArquivo := NomeArquivo+'.prn';

  AssignFile(ArqEntrada, NomeArquivo); Reset(ArqEntrada);

  iPos := 0;
  lCountLine := 0;
  iFileLen := FileSizeByName(NomeArquivo);
  PegaPar();
  PBar.Caption := 'Fase 1 de 3 Deb';
  PBar.ProgressBar1.Visible := true;

  while not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    // Tabela de Débitos
    if Length(Buffer) < 20 then
      break;
    RsDb.Insert;
    VBtoADOFieldSet(RsDb, 'Texto', Buffer+'D');
    RsDb.Post;

    iPos := iPos+Length(Buffer);
    lCountLine := lCountLine+1;
    if (lCountLine mod 10) = 0 then
      begin
      PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
      Application.ProcessMessages();
      end;
    end;
  PBar.ProgressBar1.Position := 100;
  CloseFile(ArqEntrada);

  cont := 12;
  while cont > 0 do
    begin
//    sSql := 'select * from JuntadoDC order by Texto';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDb.Close;
    RsDb.Open;

    PBar.Caption := 'Fase 2 de 3';

    PBar.ProgressBar1.Visible := true;
    Application.ProcessMessages();

//    with RsDb do
    begin
//    if not RsDb.EOF then
//      RsDb.Last;
    iFileLen := RsDb.RecordCount;
//      if  not EOF then First;
    lCountLine := 0;
    PBar.ProgressBar1.Position := 0;
    Tam := 60;
    A := Copy(RsDb.FieldByName('Texto').AsString, 1, Tam);
    B := RightStr(RsDb.FieldByName('Texto').Value, 1);
    while not RsDb.EOF do
      begin
      RsDb.Next;
      if EOF then
        break;
      if Copy(RsDb.FieldByName('Texto').Value, 1, Tam) = A then
        begin
          // Verifica se é debito e credito
        if RightStr(RsDb.FieldByName('Texto').Value, 1) <> B then
          begin
            // pendencia
          RsDb.Prior;
          RsDb.Delete;
          RsDb.Next;
          lCountLine := lCountLine+1;
          if EOF then
            break;
          if not RsDb.EOF then
            begin
            RsDb.Delete;
            RsDb.Next;
            lCountLine := lCountLine+1;
            end;

          if RsDb.EOF then
            break;
          A := Copy(RsDb.FieldByName('Texto').Value, 1, Tam);
          B := RightStr(RsDb.FieldByName('Texto').Value, 1);
          end
        else
          begin
          A := Copy(RsDb.FieldByName('Texto').Value, 1, Tam);
          B := RightStr(RsDb.FieldByName('Texto').Value, 1);
          end;
        end
      else
        begin
        A := Copy(RsDb.FieldByName('Texto').Value, 1, Tam);
        B := RightStr(RsDb.FieldByName('Texto').Value, 1);
        end;
      if (lCountLine mod 10) = 0 then
        begin
        if (lCountLine/iFileLen) < 1 then
          begin
          PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
          end
        else
          begin
          PBar.ProgressBar1.Position := 100;
          end;
        Application.ProcessMessages;
        end;
        // lCountLine = lCountLine + 1
      end;
    end;
    cont := cont-1;
  end;

//  DbLocal := gWork.OpenDatabase(gAdmPath+'\'+gCliente+'\'+gDataFile);
  Conecta(DbLocal, gAdmPath+'\'+gCliente+'\'+gDataFile);

//  sSql := 'select * from lancamentos where conta_contabil = '#39'999999'#39'';
  sSql := 'conta_contabil = '#39'999999'#39'';
//  RsDb := DbLocal.OpenRecordset(sSql);
  RsDb.Connection := DbLocal;
  RsDb.TableName := 'lancamentos';
  RsDb.Filter := sSql;
  RsDb.Filtered := True;
  RsDb.Open;

  sSql := 'select * from JuntadoDC ';
  sSql := sSql+' order by Texto';

//  RsDb2 := gBanco.OpenRecordset(sSql);
  RsDbDs.CommandText := sSql;
  RsDbDs.Open;

  PBar.Caption := 'Fase 3 de 3';
//  if not RsDbDs.EOF then
//    RsDbDs.Last;
  iFileLen := RsDbDs.RecordCount;
//  if not RsDbDs.EOF then
//    RsDbDs.First;
  lCountLine := 0;

  Buffer := 'Relatório de lançamentos abertos '+#10+#10;
  frmLog.RichTextBox1.Text := Buffer;
  Buffer := 'Cartão                                                  Valor'+#10;
  frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text)+Buffer;

  while not RsDbDs.EOF do
    begin
    Buffer := (RsDbDs.Fields[1].AsString)+'   ';

    frmLog.RichTextBox1.Text := (frmLog.RichTextBox1.Text) + Buffer + #10;
    // Grava registro no banco sem fazer nenhum teste
    GravaRec4(RsDbDs.Fields[1].AsString, RsDb);

    RsDbDs.Next;
    lCountLine := lCountLine+1;
    // If lCountLine Mod 10 = 0 Then
    if lCountLine/iFileLen<1 then
      PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100)
    else
      PBar.ProgressBar1.Position := 100;

    Application.ProcessMessages;
    // End If
  end;

  RsDb.Close;
  RsDbDs.Close;
  gBanco.Close;
  // DbLocal.Close
//  gWork.Close;

  RsDb := nil;
  RsDbDs.Free;
//  gBanco := nil;
  DbLocal.Free;
//  gWork := nil;

  // MsgBox "Registros Processados: " & Str(lCountLine) & Chr(10) & "Tempo de Leitura = " & Format(Now - Inicio, "hh:mm:ss")
  ShowMessage('Fim da Atualização...');
  PBar.ProgressBar1.Visible := false;
  PBar.Close;
end;

procedure TfMainForm.ContasResultado(Var NomeArquivo : String);
var
  ArqEntrada: System.Text;
  Buffer: String;
  iFileLen, iPos, lCountLine: Longint;
  bFim: Boolean;
begin
//  gAdmPath := GetPath();
  gAdmPath := ExtractFileDir(Application.ExeName);
//  gWork := DBEngine.Workspaces(0);
//  gBanco := gWork.OpenDatabase(gAdmPath+'\CC_Temp1.mdb');
  Conecta(gBanco, gAdmPath+'\CC_Temp1.mdb');

  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);

  sSql := 'delete from Debito';
  gBanco.Execute(sSql);
  sSql := 'delete from Credito';
  gBanco.Execute(sSql);

  sSql := 'select * from Debito';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.LockType := ltBatchOptimistic;
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
  RsDbQry.Open;

  sSql := 'select * from Credito';
//  RsDb2 := gBanco.OpenRecordset(sSql);
  RsDbQry2.LockType := ltBatchOptimistic;
  RsDbQry2.SQL.Clear;
  RsDbQry2.SQL.Add(sSql);
  RsDbQry2.Open;

  iPos := 0;
  lCountLine := 0;
  iFileLen := FileSizeByName(NomeArquivo);
  PegaPar();
  PBar.Caption := 'Fase 1 de 3';
  PBar.ProgressBar1.Visible := true;

  while not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    if RightStr(Buffer, 1)='D' then
      begin
      // Tabela de Débitos
      RsDbQry.Insert;
      VBtoADOFieldSet(RsDbQry, 'Cartao', Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho));
      VBtoADOFieldSet(RsDbQry, 'Debito', Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
      VBtoADOFieldSet(RsDbQry, 'Texto', Buffer);
      RsDbQry.Post;
      end
    else
      begin
      // Tabela de Créditos
      RsDbQry2.Insert;
      VBtoADOFieldSet(RsDbQry2, 'Cartao', Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho));
      VBtoADOFieldSet(RsDbQry2, 'Credito', Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
      VBtoADOFieldSet(RsDbQry2, 'Texto', Buffer);
      RsDbQry2.Post;
      end;
    iPos := iPos+Length(Buffer);
    lCountLine := lCountLine+1;
    // If lCountLine = 370 Then Exit Do
    if lCountLine mod 100=0 then
      begin
      PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
      Application.ProcessMessages;
      end;
    end;

  RsDbQry.UpdateBatch(arAll);
  RsDbQry.Close;

  RsDbQry2.UpdateBatch(arAll);
  RsDbQry2.Close;

  PBar.ProgressBar1.Position := 100;
  PBar.ProgressBar1.Visible := false;
  CloseFile(ArqEntrada);

  sSql := 'select * from Debito order by Cartao';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
  RsDbQry.Open;

  sSql := 'select * from Credito order by Cartao';
//  RsDb2 := gBanco.OpenRecordset(sSql);
  RsDbQry2.SQL.Clear;
  RsDbQry2.SQL.Add(sSql);
  RsDbQry2.Open;

  PBar.Caption := 'Fase 2 de 3';

  PBar.ProgressBar1.Visible := true;
//  with RsDb2 do
  begin
//  if not RsDb2.EOF then
//    RsDb2.Last;
  iFileLen := RsDbQry2.RecordCount;
//  if not RsDb2.EOF then
//    RsDb2.First;
  lCountLine := 0;
  bFim := false;
  PBar.ProgressBar1.Position := 0;
  while not RsDbQry2.EOF and not bFim do
    begin
    if RsDbQry.EOF then
      begin
      break;
      end
    else
      begin
      RsDbQry.First;
      end;

    if LeftStr(RsDbQry2.FieldByName('Cartao').Value, 13)=LeftStr(RsDbQry.FieldByName('Cartao').Value, 13) then
      begin
      if (RsDbQry2.FieldByName('Credito'))=RsDbQry.FieldByName('Debito') then
        begin
        RsDbQry2.Edit;
        VBtoADOFieldSet(RsDbQry2, 'Debito', RsDbQry.FieldByName('Debito').Value);
        RsDbQry2.Post;
        RsDbQry.Delete;
        if RsDbQry.EOF then
          begin
          bFim := true;
          end
        else
          begin
          RsDbQry.First;
          end;
        end
      else
        begin
        while LeftStr(RsDbQry2.FieldByName('Cartao').Value, 13)=LeftStr(RsDbQry.FieldByName('Cartao').Value, 13) do
          begin
          RsDbQry.Next;
          if (RsDbQry2.FieldByName('Credito'))=RsDbQry.FieldByName('Debito') then
            begin
            RsDbQry2.Edit;
            VBtoADOFieldSet(RsDbQry2, 'Debito', RsDbQry.FieldByName('Debito').Value);
            RsDbQry2.Post;
            RsDbQry.Delete;
            if RsDbQry.EOF then
              begin
              bFim := true;
              end
            else
              begin
              RsDbQry.First;
              end;
            break;
            end;
          end;
        end;
      end
    else
      begin
      if LeftStr(RsDbQry2.FieldByName('Cartao').Value, 13)>LeftStr(RsDbQry.FieldByName('Cartao').Value, 13) then
        begin
        while LeftStr(RsDbQry2.FieldByName('Cartao').Value, 13)>LeftStr(RsDbQry.FieldByName('Cartao').Value, 13) do
          begin
          RsDbQry2.Insert;
          VBtoADOFieldSet(RsDbQry2, 'Cartao', RsDbQry.FieldByName('Cartao').Value);
          VBtoADOFieldSet(RsDbQry2, 'Debito', RsDbQry.FieldByName('Debito').Value);
          VBtoADOFieldSet(RsDbQry2, 'Texto', RsDbQry.FieldByName('Texto').Value);
          RsDbQry2.Post;
          RsDbQry.Delete;
          if RsDbQry.EOF then
            begin
            bFim := true;
            end
          else
            begin
            RsDbQry.First;
            end;
          if RsDbQry.EOF then
            break;
          end;
        end;
        if not RsDbQry.EOF then
          begin
          if LeftStr(RsDbQry2.FieldByName('Cartao').Value, 13)=LeftStr(RsDbQry.FieldByName('Cartao').Value, 13) then
            begin
            if (RsDbQry2.FieldByName('Credito'))=RsDbQry.FieldByName('Debito') then
              begin
              RsDbQry2.Edit;
              VBtoADOFieldSet(RsDbQry2, 'Debito', RsDbQry.FieldByName('Debito').Value);
              RsDbQry2.Post;
              RsDbQry.Delete;
              if RsDbQry.EOF then
                begin
                bFim := true;
                end
              else
                begin
                RsDbQry.First;
                end;
             end;
           end;
         end;
      end;
      if (lCountLine mod 100) = 0 then
        begin
        if (lCountLine/iFileLen) < 1 then
          begin
          PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
          end
        else
          begin
          PBar.ProgressBar1.Position := 100;
          end;
        Application.ProcessMessages;
        end;
      RsDbQry2.Next;
      lCountLine := lCountLine+1;
      end;
    while not RsDbQry.EOF do
      begin
      RsDbQry2.Insert;
      VBtoADOFieldSet(RsDbQry2, 'Cartao', RsDbQry.FieldByName('Cartao').Value);
      VBtoADOFieldSet(RsDbQry2, 'Debito', RsDbQry.FieldByName('Debito').Value);
      VBtoADOFieldSet(RsDbQry2, 'Texto', RsDbQry.FieldByName('Texto').Value);
      RsDbQry2.Post;
      RsDbQry.Delete;
      RsDbQry.First;
    end;
  end;

  RsDbQry.UpdateBatch(arAll);
  RsDbQry.Close;

  RsDbQry2.UpdateBatch(arAll);
  RsDbQry2.Close;

  // Set DbLocal = gWork.OpenDatabase(gAdmPath & "\real\real.mdb")

  //DbLocal := gWork.OpenDatabase(gAdmPath+'\'+gCliente+'\'+gDataFile);

  Conecta(gBancoCli, gAdmPath+'\'+gCliente+'\'+gDataFile);

  sSql := 'select * from lancamentos where conta_contabil = '#39'999999'#39'';
  //RsDb := DbLocal.OpenRecordset(sSql);
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
  RsDbQry.Open;

  sSql := 'select * from Credito order by Cartao';
//  RsDb2 := gBanco.OpenRecordset(sSql);
  RsDbQryCli.SQL.Clear;
  RsDbQryCli.SQL.Add(sSql);
  RsDbQryCli.Open;

  RsDbQryCli.Last;
  iFileLen := RsDbQryCli.RecordCount;
  lCountLine := 0;
  RsDbQryCli.First;
  PBar.Caption := 'Fase 3 de 3';
  PBar.ProgressBar1.Visible := true;

  while not RsDbQryCli.EOF do
    begin
    GravaRec3((RsDbQryCli.FieldByName('Texto').Value), RsDbQryCli.FieldByName('Debito'), RsDbQryCli.FieldByName('Credito'), RsDbQry);
    RsDbQryCli.Next;
    if (lCountLine mod 100) = 0 then
      begin
      PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
      Application.ProcessMessages();
      end;
    lCountLine := lCountLine+1;
    end;

  RsDbQryCli.Close;
  RsDbQry.UpdateBatch(arAll);
  RsDbQry.Close;

  PBar.ProgressBar1.Position := 100;

//  gWork.Close();

  gBanco.Close;
  gBancoCli.Close;
//  gWork := nil;
  // MsgBox "Registros Processados: " & Str(lCountLine) & Chr(10) & "Tempo de Leitura = " & Format(Now - Inicio, "hh:mm:ss")
  ShowMessage('Fim da Atualização...');
  PBar.ProgressBar1.Visible := false;
  PBar.Close;
end;

// VBto upgrade warning: Buf As String  OnWrite(TField)
// VBto upgrade warning: sDebito As OleVariant --> As TField
// VBto upgrade warning: sCredito As OleVariant --> As TField
procedure TfMainForm.GravaRec3(Buf: String; sDebito: TField; sCredito: TField; Var RsDb : TAdoQuery);
var
  sCartao, sMoeda, sValor, sData: String;
begin
  sCartao := Copy(Buf, Param.Cartao.Posicao, Param.Cartao.Tamanho);
  sMoeda := Copy(Buf, Param.Moeda.Posicao, Param.Moeda.Tamanho);
  sValor := Copy(Buf, Param.Valor.Posicao, Param.Valor.Tamanho);
  sData := Copy(Buf, Param.Data.Posicao, Param.Data.Tamanho);

  RsDb.Insert;
  VBtoADOFieldSet(RsDb, 'cliente', gCliente);
  if sCredito.AsExtended <> 0 then
    VBtoADOFieldSet(RsDb, 'Data_Credito', StrToDate(sData));
  if sDebito.AsExtended <> 0 then
    VBtoADOFieldSet(RsDb, 'Data_Debito', StrToDate(sData));
  VBtoADOFieldSet(RsDb, 'Cartao', sCartao);
  VBtoADOFieldSet(RsDb, 'Cartao1', Copy(sCartao, 1, 13));

  if (sMoeda='986') or (sMoeda='000') then
    begin
    VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', sCredito.AsExtended);
    VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', sDebito.AsExtended);
    end
  else
    begin
    VBtoADOFieldSet(RsDb, 'Vl_CreditoDolar', sCredito.AsExtended);
    if RsDb.FieldByName('Vl_CreditoDolar').AsExtended > 0 then
      VBtoADOFieldSet(RsDb, 'Taxa_Credito', StrToFloat(gTaxa));
    VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', sCredito.AsExtended*StrToFloat(gTaxa));

    VBtoADOFieldSet(RsDb, 'Vl_DebitoDolar', sDebito.AsExtended);
    if RsDb.FieldByName('Vl_DebitoDolar').AsExtended > 0 then
      VBtoADOFieldSet(RsDb, 'Taxa_Debito', RsDb.FieldByName('Taxa_Credito').Value);
    VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', sDebito.AsExtended*StrToFloat(gTaxa));
    end;
  VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal').AsExtended - RsDb.FieldByName('Vl_CreditoReal').AsExtended);
  VBtoADOFieldSet(RsDb, 'conta_contabil', Trim(Concil.ContaContabil));

  gTotDebito := gTotDebito+RsDb.FieldByName('Vl_DebitoReal').AsExtended;
  gTotCredito := gTotCredito+RsDb.FieldByName('Vl_CreditoReal').AsExtended;

  RsDb.Post;

end;

// VBto upgrade warning: Buffer As String  OnWrite(TField)
procedure TfMainForm.GravaRec4(Buffer: String; Var RsDb: TAdoTable);
var
  sCartao, sValor, sMoeda, sData: String;
  iLenBuf: Longint;
begin
  iLenBuf := Length(Buffer);
  sCartao := Copy(Buffer, 1, 16);
  sValor := Copy(Buffer, iLenBuf-14, 14);
  sData := DateToStr(gDataRelatorio);
  sMoeda := '986';
  RsDb.Insert;
  if RightStr(Buffer, 1)='D' then
    begin
    if StrToFloat(sValor) <> 0 then
      VBtoADOFieldSet(RsDb, 'Data_Debito', StrToDate(sData));
    VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', StrToFloat(sValor));
    end
  else
    begin
    if StrToFloat(sValor) <> 0 then
      VBtoADOFieldSet(RsDb, 'Data_Credito', StrToDate(sData));
    VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', StrToFloat(sValor));
    end;

  VBtoADOFieldSet(RsDb, 'cliente', gCliente);
  VBtoADOFieldSet(RsDb, 'Cartao', sCartao);
  VBtoADOFieldSet(RsDb, 'Cartao1', Copy(sCartao, 1, 13));

  VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal').AsExtended - RsDb.FieldByName('Vl_CreditoReal').AsExtended);
  VBtoADOFieldSet(RsDb, 'conta_contabil', Trim(Concil.ContaContabil));

  gTotDebito := gTotDebito+RsDb.FieldByName('Vl_DebitoReal').AsExtended;
  gTotCredito := gTotCredito+RsDb.FieldByName('Vl_CreditoReal').AsExtended;

  RsDb.Post;

end;

function TfMainForm.getDataFromNome(sNome: String): String;
var
  I: Smallint;
begin
  Result := '';
  I := 1;
  while Copy(sNome, I, 1)<>'_' do begin
    I := I+1;
  end;
  I := I+2;

  while Copy(sNome, I, 1)<>'_' do begin
    Result := Result+Copy(sNome, I, 1);
    I := I+1;
  end;

end;

procedure TfMainForm.AbreMenu(Menu: Integer);
begin
  // Seleciona Banco de Dados, habilita o menu arquivo

  Screen.Cursor := crHourGlass;
  gDataFile := GetDataBaseName(Menu);
  if gDataFile='' then
    begin
    Application.MessageBox('Erro Grave', 'Seleção de Cliente', MB_ICONSTOP);
    fMainForm.mnuArquivo.Enabled := false;
    Exit;
    end;

  sbStatusBar.Panels.Items[1-1].Text := 'Cliente: ' + mnuClientes[Menu+1].Caption;
  case gNivel of

    1: begin
       fMainForm.mnuRelatorios.Enabled := true;
       fMainForm.mnuManut1.Enabled := false;
       end;
    2: begin
       fMainForm.mnuTipoCon.Enabled := true;
       fMainForm.mnuRelatorios.Enabled := true;
       fMainForm.mnuArquivo.Enabled := true;
       fMainForm.mnuManut1.Enabled := false;
       end;
    3: begin
       fMainForm.mnuTipoCon.Enabled := true;
       fMainForm.mnuRelatorios.Enabled := true;
       fMainForm.mnuArquivo.Enabled := true;
       fMainForm.mnuManut1.Enabled := true;
       end;
  end;

//  gDataFile := GetDataBaseName(Menu);                         Again?
//  if  not Conecta('') then Application.Terminate;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    begin
    Application.Terminate;
    Close;
    end;

  sSql := 'Select * from [Path]';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDbQry.SQL.Clear;
  RsDbQry.SQL.Add(sSql);
  RsDbQry.Open;

  if not RsDbQry.EOF then begin
    gExcelPath := RsDbQry.FieldByName('PathArquivoExcel').Value;
  end;

  BarraStatus;
  Screen.Cursor := crDefault;

  gBanco.Close;

end;

procedure TfMainForm.MontaMenus;
var
  I: Integer;
  AdminAdoConnection : TAdoConnection;
  RsDb : TAdoDataSet;
  sSql : String;
begin
  try

    gDataPath := ExtractFileDir(Application.ExeName);

    fMainForm.mnuClientes.Enabled := true;
    fMainForm.mnuTipoCon.Enabled := false;
    fMainForm.mnuRelatorios.Enabled := false;
    fMainForm.mnuArquivo.Enabled := false;
    fMainForm.mnuManut1.Enabled := false;

    fMainForm.mnuClientes.Items[0].Visible := True;

    for I:=0 to 21 do begin
      fMainForm.mnuClientes.Items[I].Visible := false;
    end;

    if  not Conecta(AdminAdoConnection, ExtractFileDir(Application.ExeName) + '\admin.udl') then
      Exit;

    RsDb := TAdoDataSet.Create(nil);
    RsDb.Connection := AdminAdoConnection;

    // Monta o Menu Clientes

    sSql := 'Select * from [Clientes] ORDER BY NOME_REDUZIDO';
    RsDb.CommandText := sSql;
    RsDb.Active := True;

    while not RsDb.EOF do
      Begin
      If Conecta(gBancoCli, gDataPath + '\' + RsDb.FieldByName('Nome_Reduzido').Value + '\' +
                         RsDb.FieldByName('Nome_Reduzido').Value + '.udl') then
        begin
        I := RsDb.RecNo;
        fMainForm.mnuClientes[I-1].Visible := true;
        fMainForm.mnuClientes[I-1].Caption := RsDb.FieldByName('Nome_Reduzido').Value;
        gCodigo := RsDb.FieldByName('Codigo').Value;
        gBancoCli.Close;
        end;
      RsDb.Next;
      End;

    I := 0;
    if Length(tbTipoCon) > 0 then
    while tbTipoCon[I].NmGrupo <> '999999' do
      begin
      case I+1 of
        1: begin
//          fMainForm.mnu1[I].Visible := true;                Vou assumir que é mnuTipoCon
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
//          fMainForm.mnuTipoCon[9].Visible := false;
        end;
        2: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
        3: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
        4: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
        5: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
        6: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
        7: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
        8: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
        9: begin
          fMainForm.mnuTipoCon[I].Visible := true;
          fMainForm.mnuTipoCon[I].Caption := tbTipoCon[I].NmGrupo;
        end;
      end;
      Inc(I);
    end;

  except On E:exception do
    ShowMessage(E.Message);
  end;
end;

procedure TfMainForm.MontaBinGeral;
var
  Clientes: TStringList;
  I : Integer;
  AdminAdoConnection,
  DbTemp : TAdoConnection;
  RsDb : TAdoDataSet;
//  RsTemp : TAdoDataSet;

//  Arq : System.Text;
// J : Integer;

begin

  Clientes := TStringList.Create;

  try  // On Error GoTo Erro
//    if  not Conecta('adm') then

    if not Conecta(AdminAdoConnection, ExtractFileDir(Application.ExeName) + '\admin.udl') then
      Begin
      Application.Terminate;
      Close;
      Exit;
      End;

    RsDb := TAdoDataSet.Create(nil);
    RsDb.Connection := AdminAdoConnection;
//    RsTemp := TAdoDataSet.Create(nil);

    // Pega lista de clientes
    sSql := 'select * from clientes';
    RsDb.CommandText := sSql;
    RsDb.Open;

    while not RsDb.EOF do
      begin
      Clientes.Add(RsDb.FieldByName('Nome_Reduzido').AsString);
      RsDb.Next;
      end;

    Clientes.Add('999999');

    // Limpa tabela
//    sSql := 'delete from tbBinGeral';
    sSql := 'TRUNCATE TABLE tbBinGeral';
    AdminAdoConnection.Execute(sSql);

    RsDb.Close;
//    sSql := 'select * from tbBinGeral';
//    RsDb.CommandText := sSql;
//    RsDb.Open;

    I := 0;
    while Clientes[I] <> '999999' do
      begin
      If Conecta(DbTemp, gDataPath+'\'+Clientes[I]+'\'+Clientes[I]+'.udl') then
        begin

{        RsTemp.Connection := DbTemp;              OLD WAY

        sSql := 'select * from tbBin';
        RsTemp.CommandText := sSql;
        RsTemp.Open;

        while not RsTemp.EOF do
          begin
          RsDB.Append;
          RsDb.FieldByName('BIN').Value := RsTemp.FieldByName('BIN').Value;
          RsDb.Post;
          RsTemp.Next;
          end;  }

        sSql := 'INSERT INTO [SISCOC_Admin].[dbo].[tbBinGeral] SELECT [BIN] FROM [SISCOC_';
        sSql := sSql + Clientes[I] + '].[dbo].[tbBIN]';
        DbTemp.Execute(sSql);

//INSERT INTO [SISCOC_Admin].[dbo].[tbBinGeral] SELECT [BIN] FROM [SISCOC_CC_BANCOX_VISA].[dbo].[tbBIN]

{        RsDbQryCli.Connection := DbTemp;
        AssignFile(Arq, 'C:\Rom\x.txt');
        System.SetTextBuf(Arq, Buffer);
        Rewrite(Arq);

        RsDbQryCli.SQL.Add('BULK INSERT tbBIN FROM ''c:\rom\x.txt''');

        for J := 0 to 999999 do
          begin
          WriteLn(Arq, Format('%.6d', [J]) + #9 + 'PJ');
          if (J mod 10000) = 0 then
            begin
              Edit1.Text := IntToStr(I);
              Application.ProcessMessages;
            end;
          end;

        CloseFile(Arq);
        Edit1.Text := '1000000';
        Application.ProcessMessages;

        RsDbQryCli.ExecSQL;
        Edit1.Text := 'Foi Para o Banco';
        Application.ProcessMessages;   }

        DbTemp.Close;
        DbTemp.Free;
        end;
      Inc(I);
      end;

//    RsDb.Close;
    RsDb.Free;
    AdminAdoConnection.Close;
    DbTemp.Close;
    AdminAdoConnection.Free;

  except  On E:Exception do
//    if (Err.Number=3044) or (Err.Number=3078) then {? Resume Repete }
    ShowMessage(E.Message);
    { Resume Next }
  end;
end;

End.
