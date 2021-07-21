unit frmMain_;

interface

uses  Forms, Classes, Controls, ExtCtrls, ComCtrls, Menus, Dialogs, Windows,
  Graphics, DB, ADODB;


type
  TfMainForm = class(TForm)
    FormBackgroundImage:	TImage;
    sbStatusBar:	TStatusBar;
    dlgCommonDialog:	TOpenDialog;
    CrystalReport1Rect:	TShape;
    mMainMenu1:	TMainMenu;
    mnuManut1:	TMenuItem;
    mnuGC:	TMenuItem;
    mnuMGCInc:	TMenuItem;
    mnuMGCAlt:	TMenuItem;
    mnuMGCExc:	TMenuItem;
    mnuGCConsultar:	TMenuItem;
    mnuTC:	TMenuItem;
    mnuTCInc:	TMenuItem;
    mnuTCAlterar:	TMenuItem;
    mnuTCExcl:	TMenuItem;
    mnuCCConsultar:	TMenuItem;
    mnuCCGeral:	TMenuItem;
    mnuCCCliente:	TMenuItem;
    mnuCadBIN:	TMenuItem;
    mnuIncBIN:	TMenuItem;
    mnuAltBIN:	TMenuItem;
    mnuExcBIN:	TMenuItem;
    mnuConBIN:	TMenuItem;
    mnuConvMes:	TMenuItem;
    mnuCvMesIncluir:	TMenuItem;
    mnuCvMesAlterar:	TMenuItem;
    mnuCvMesExcluir:	TMenuItem;
    mnuCvMesConsultar:	TMenuItem;
    mnuRotMes:	TMenuItem;
    mnuEPB:	TMenuItem;
    mnuRestaura:	TMenuItem;
    mnuNovoCli:	TMenuItem;
    mnuNovo:	TMenuItem;
    mnuNCAlt:	TMenuItem;
    mnuNCCon:	TMenuItem;
    mnuCadUsuario:	TMenuItem;
    mnuCUIns:	TMenuItem;
    mnuCUAlt:	TMenuItem;
    mnuCUExc:	TMenuItem;
    mnuCons:	TMenuItem;
    cmdCadPaths:	TMenuItem;
    cmdAlteraPath:	TMenuItem;
    cmdConPath:	TMenuItem;
    mnuTeste1:	TMenuItem;
    mnuClientes:	TMenuItem;
    mnuCliente_0:	TMenuItem;
    mnuCliente_1:	TMenuItem;
    mnuCliente_2:	TMenuItem;
    mnuCliente_3:	TMenuItem;
    mnuCliente_4:	TMenuItem;
    mnuCliente_5:	TMenuItem;
    mnuCliente_6:	TMenuItem;
    mnuCliente_7:	TMenuItem;
    mnuCliente_8:	TMenuItem;
    mnuCliente_9:	TMenuItem;
    mnuCliente_10:	TMenuItem;
    mnuCliente_11:	TMenuItem;
    mnuCliente_12:	TMenuItem;
    mnuCliente_13:	TMenuItem;
    mnuCliente_14:	TMenuItem;
    mnuCliente_15:	TMenuItem;
    mnuCliente_16:	TMenuItem;
    mnuCliente_17:	TMenuItem;
    mnuCliente_18:	TMenuItem;
    mnuCliente_19:	TMenuItem;
    mnuCliente_20:	TMenuItem;
    mnuCliente_21:	TMenuItem;
    mnuTipoCon:	TMenuItem;
    mnu1_1:	TMenuItem;
    mnu1_2:	TMenuItem;
    mnu1_3:	TMenuItem;
    mnu1_4:	TMenuItem;
    mnu1_5:	TMenuItem;
    mnu1_6:	TMenuItem;
    mnu1_7:	TMenuItem;
    mnu1_8:	TMenuItem;
    mnu1_9:	TMenuItem;
    mnuArquivo:	TMenuItem;
    mnuAtualiza:	TMenuItem;
    mnuDD:	TMenuItem;
    mnuDDInc:	TMenuItem;
    mnuDDAlt:	TMenuItem;
    mnuDDExcl:	TMenuItem;
    mnuADCons:	TMenuItem;
    mnuGM:	TMenuItem;
    mnuJuncao:	TMenuItem;
    mnuJuncaoJuntados:	TMenuItem;
    mnuGBB:	TMenuItem;
    mnuNormal:	TMenuItem;
    mnuBat:	TMenuItem;
    mnuAtGeral:	TMenuItem;
    mnuAualiza:	TMenuItem;
    mnuAgenda:	TMenuItem;
    mnuAjuste:	TMenuItem;
    mnuAMAlterar:	TMenuItem;
    mnuALAGeral:	TMenuItem;
    mnuALAPendencias:	TMenuItem;
    AtComp:	TMenuItem;
    mnuSep1:	TMenuItem;
    mnuInterface:	TMenuItem;
    mnuBkp:	TMenuItem;
    mnuLog:	TMenuItem;
    mnuSepLog:	TMenuItem;
    mnuBkpMensal:	TMenuItem;
    mnuConf:	TMenuItem;
    mnuNotas:	TMenuItem;
    mnuTeste:	TMenuItem;
    mnuRelatorios:	TMenuItem;
    mnuSDia:	TMenuItem;
    mnuSaldoCont:	TMenuItem;
    mnuBa:	TMenuItem;
    mnuBGeral:	TMenuItem;
    mnuOdata:	TMenuItem;
    mnuGODSem:	TMenuItem;
    mnuGODCom:	TMenuItem;
    mnuOcartao:	TMenuItem;
    mnuGOOSem:	TMenuItem;
    mnuGOOCom:	TMenuItem;
    mnuBPeriodo:	TMenuItem;
    mnuOdata2:	TMenuItem;
    mnuGPODSem:	TMenuItem;
    mnuGPODCom:	TMenuItem;
    mnuOcartao2:	TMenuItem;
    mnuGPOCSem:	TMenuItem;
    mnuGPOCCom:	TMenuItem;
    mnuPend:	TMenuItem;
    mnuPGeral:	TMenuItem;
    mnuOdata3:	TMenuItem;
    mnuPGODSem:	TMenuItem;
    mnuPGODCom:	TMenuItem;
    mnuOcartao3:	TMenuItem;
    mnuPOCSem:	TMenuItem;
    mnuPOCCom:	TMenuItem;
    mnuPPeriodo:	TMenuItem;
    mnuOdata4:	TMenuItem;
    mnuPPODSem:	TMenuItem;
    mnuPPODCom:	TMenuItem;
    mnuOcartao4:	TMenuItem;
    mnuPPOCSem:	TMenuItem;
    mnuPPOCCom:	TMenuItem;
    mnuVariac:	TMenuItem;
    mnuVarGer:	TMenuItem;
    mnuVarMes:	TMenuItem;
    mnuVarPend:	TMenuItem;
    mnuExcell:	TMenuItem;
    mnuGAESem:	TMenuItem;
    mnuGAECom:	TMenuItem;
    mnuExcelGeral:	TMenuItem;
    mnuEXGerSem:	TMenuItem;
    mnuEXGerCom:	TMenuItem;
    mnuCBD:	TMenuItem;
    mnuHistorico:	TMenuItem;
    mnuCBDGeral:	TMenuItem;
    mnuCBDPendencias:	TMenuItem;
    mnuInterf:	TMenuItem;
    mnuInterfCon:	TMenuItem;
    mnuInterfSaci:	TMenuItem;
    mnuCopyFile:	TMenuItem;
    mnuSair:	TMenuItem;

    procedure AtCompClick(Sender: TObject);
    procedure cmdAlteraPathClick(Sender: TObject);
    procedure cmdConPathClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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
    procedure mnuAltBINClick(Sender: TObject);
    procedure mnuAtGeralClick(Sender: TObject);
    procedure mnuAualizaClick(Sender: TObject);
    procedure mnuBatClick(Sender: TObject);
    procedure mnuBkpClick(Sender: TObject);
    procedure mnuBkpMensalClick(Sender: TObject);
    procedure mnuCBDGeralClick(Sender: TObject);
    procedure mnuCBDPendenciasClick(Sender: TObject);
    procedure mnuCCClienteClick(Sender: TObject);
    procedure mnuCCGeralClick(Sender: TObject);
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
    procedure mnuConBINClick(Sender: TObject);
    procedure mnuConfClick(Sender: TObject);
    procedure mnuConsClick(Sender: TObject);
    procedure mnuCopyFileClick(Sender: TObject);
    procedure mnuCUAltClick(Sender: TObject);
    procedure mnuCUExcClick(Sender: TObject);
    procedure mnuCUInsClick(Sender: TObject);
    procedure mnuCvMesAlterarClick(Sender: TObject);
    procedure mnuCvMesConsultarClick(Sender: TObject);
    procedure mnuCvMesExcluirClick(Sender: TObject);
    procedure mnuCvMesIncluirClick(Sender: TObject);
    procedure mnuEPBClick(Sender: TObject);
    procedure mnuExcBINClick(Sender: TObject);
    procedure mnuEXGerComClick(Sender: TObject);
    procedure mnuEXGerSemClick(Sender: TObject);
    procedure GeraExcel(ComSem: Boolean);
    procedure GeraLista();
    procedure mnuGAEComClick(Sender: TObject);
    procedure mnuGAESemClick(Sender: TObject);
    procedure mnuGCConsultarClick(Sender: TObject);
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
    procedure mnuIncBINClick(Sender: TObject);
    procedure mnuInterfaceClick(Sender: TObject);
    procedure mnuInterfConClick(Sender: TObject);
    procedure mnuInterfSaciClick(Sender: TObject);
    procedure mnuJuncaoClick(Sender: TObject);
    procedure mnuJuncaoJuntadosClick(Sender: TObject);
    procedure mnuLogClick(Sender: TObject);
    procedure mnuMGCAltClick(Sender: TObject);
    procedure mnuMGCExcClick(Sender: TObject);
    procedure mnuMGCIncClick(Sender: TObject);
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
    procedure ContasResultado();
    procedure GravaRec3(Buf: String; sDebito: TField; sCredito: TField);
    //function TestaRec4(Buffer: String): Boolean;
    procedure GravaRec4(Buffer: String);
    function getDataFromNome(sNome: String): String;

  private
    { Private declarations }

    procedure MDIForm_Unload(var Cancel: Smallint);
    procedure mnu1Click(Index: Smallint; Sender: TObject);
    //procedure mnuAMIncluir_Click();
    procedure mnuClienteClick(Index: Smallint; Sender: TObject);
    //procedure mnuRotMen_Click();
    //procedure mnuSobre_Click();
    //procedure mnuTMAlt_Click();
    //procedure mnuTMExcl_Click();
    //procedure mnuTMInc_Click();

  public
    { Public declarations }


  end;

var
  fMainForm: TfMainForm;

implementation

uses  SysUtils, StrUtils, Module1, DataMov_, RotGerais, frmLog_, frmPath_
  , SimulaMenu_, Consulta_, frmAgenda_, frmAgenda1_, frmMes_
  , AlterarManual_, Incluir_, frmBIN_, Alterar_Consulta_, PedeAlteração_
  , ConsultaCon_, frmAltUsuario_, frmUsuario_, frmConvMes_
  , ConsultaCvMes_, Periodo_, PBar_, DataLimite_, atMoeda_, frmGeraMov_
  , Historico_, frmJuncao_, DataDeAte_, GrupoConAlt_
  , GrupoCon_, NovoClienteAlt_, frmBaixaBanco_, frmRelease_, NovoCliente_
  , frmAbout_, TipoConAdm_, frmMes1_, VBto_Converter, FileHandles;

{$R *.dfm}

 //=========================================================
procedure TfMainForm.AtCompClick(Sender: TObject);
var
	Buffer, Buffer1, buffer2: String;
	I: Longint;
	sPath, NomeTmp: String;
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;

	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	// gDataRelatorio = ""
	DataMov.ShowModal();
	if  not isDataValida(gDataRelatorio) then begin
		Exit;
	end;

	if  not Conecta('') then Exit;

	// sSql = "select * from tb_moeda where strdata) = '" &

	sSql := 'select * from tb_moeda where str(data) = '#39''+gDataRelatorio+''#39'';
	sSql := sSql+' or str(data)= '#39''+dataDezBarra(gDataRelatorio)+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);
	if RsDb.EOF then begin
		ShowMessage('Dolar não está cadastrado');
		Exit;
	end;
	gTaxa := RsDb.FieldByName('valor').Value;
	Desconecta();

	NomeArquivo := GetPath()+'\';
	// NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ArqEntrada)
	NomeArquivo := NomeArquivo+gCliente+'\entrada\'+'JUNTADO';
	// NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ContaContabil)
	NomeArquivo := NomeArquivo+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 4, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 1, 2);
	NomeArquivo := NomeArquivo+'.txt';

	NomeTmp := GetPath()+'\';
	NomeTmp := NomeTmp+gCliente+'\entrada\'+Trim(Concil.ContaContabil);
	NomeTmp := NomeTmp+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeTmp := NomeTmp+Copy(gDataRelatorio, 4, 2);
	NomeTmp := NomeTmp+Copy(gDataRelatorio, 1, 2);
	NomeTmp := NomeTmp+'.tmp';

	if GeraTemp(NomeTmp) then begin
		NomeArquivo := TiraExt(NomeArquivo)+'.tmp';
		NomeArquivo := NomeTmp;
	 end  else  begin
		Exit;
	end;

	gArquivo11 := '';
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+String(Concil.ContaContabil)+' - '+gConciliacao+#10+'     Débitos    Créditos       Saldo'+#10+#10;
	gAutomatico := false;
	gTotDebito := 0;
	gTotCredito := 0;
	gSaldo := FloatToStr(GetSaldo());
	if Concil.Natureza='D' then begin
		// Processa primeiro Dolar
		for I:=0 to ncDebito-1 do begin
			if  not ContaDebitoComp(I, '840') then Exit;
		end; // I
		for I:=0 to ncCredito-1 do begin
			if  not ContaCreditoComp(I, '840') then Exit;
		end; // I

		for I:=0 to ncDebito-1 do begin
			if  not ContaDebitoComp(I, '986') then Exit;
		end; // I
		for I:=0 to ncCredito-1 do begin
			if  not ContaCreditoComp(I, '986') then Exit;
		end; // I
	 end  else  begin
		// Processa primeiro Dolar
		for I:=0 to ncCredito-1 do begin
			if  not ContaCreditoComp(I, '840') then Exit;
		end; // I
		for I:=0 to ncDebito-1 do begin
			if  not ContaDebitoComp(I, '840') then Exit;
		end; // I

		for I:=0 to ncCredito-1 do begin
			if  not ContaCreditoComp(I, '986') then Exit;
		end; // I
		for I:=0 to ncDebito-1 do begin
			if  not ContaDebitoComp(I, '986') then Exit;
		end; // I
	end;

	// Faz Backup do banco de dados com as novas movimentações
	BackupBanco();

	// Mostra Débitos e Créditos
	Buffer := FormatVB(gTotDebito,'###,##0.00');
	Buffer1 := FormatVB(gTotCredito,'###,##0.00');
	buffer2 := FormatVB(GetSaldo(),'###,##0.00');

	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+#10+StringOfChar(' ', 15-Length(Buffer))+Buffer+' '+StringOfChar(' ', 15-Length(Buffer1))+Buffer1+' '+StringOfChar(' ', 15-Length(buffer2))+buffer2+#10;

	gArquivo11 := frmLog.RichTextBox1.Text;
	frmLog.Close();
	frmLog.ShowModal();

end;

procedure TfMainForm.cmdAlteraPathClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	sSql := 'select * from path';
	gOpcao := 'altera';
	frmPath.ShowModal();
end;

procedure TfMainForm.cmdConPathClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	sSql := 'select * from path';
	gOpcao := 'consulta';
	frmPath.ShowModal();

end;

procedure TfMainForm.FormShow(Sender: TObject);
var
	tbTipoCon: array of OleVariant;
	I, J: Smallint;
begin
	Self.Left := GetSetting(Application.Title, 'Settings', 'MainLeft', 1000);
	Self.Top := GetSetting(Application.Title, 'Settings', 'MainTop', 1000);
	Self.Width := GetSetting(Application.Title, 'Settings', 'MainWidth', 6500);
	Self.Height := GetSetting(Application.Title, 'Settings', 'MainHeight', 6500);

	// Le Banco de Dados e Monta os Menus
	// gRpt1File = "\ba_ge_co.rpt"
	// gRpt3File = "\excluido.rpt"
	// gRpt4File = "\rcontpe1.rpt"

	// gRpt1sFile = "\rcontge0.rpt"

	Concil.ContaContabil := StringOfChar(' ', 14);

	gAdmPath := GetPath();
	fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';

	Desconecta();
	if  not Conecta('adm') then Exit;

	sSql := 'Select * from [tb_tipo_con]';
	sSql := sSql+' where nm_conciliacao = '#39''+gConciliacao+''#39'';
	sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);

	I := 1;
	sSql := 'select * from tb_grupocon order by cd_grupo_con';
	RsDb := gBanco.OpenRecordset(sSql);
	with RsDb do begin
		while  not EOF do begin
			SetLength(tbTipoCon, I+1);
			J:=1; while (J <= I-1) { for J:=1 to I-1 } do begin
				if Trim(tbTipoCon[J].NmGrupo)=FieldByName('nm_grupo') then begin
					// Pega o proximo e testa de novo, pode ter 2 seguidos
					Next;
					J := 0;
				end;
				J :=  J + 1;
			end; // J
			tbTipoCon[I].Indice := I;
			tbTipoCon[I].Cd_Grupo_Con := FieldByName('cd_grupo_con').Value;
			tbTipoCon[I].NmGrupo := FieldByName('nm_grupo').Value;
			I := I+1;
			Next;
		end;
		SetLength(tbTipoCon, I+1);
		tbTipoCon[I].NmGrupo := '999999';
	end;
	Desconecta();
end;
procedure TfMainForm.MDIForm_Unload(var Cancel: Smallint);
begin
	if Self.WindowState<>wsMinimized then begin
		SaveSetting(Application.Title, 'Settings', 'MainLeft', Self.Left);
		SaveSetting(Application.Title, 'Settings', 'MainTop', Self.Top);
		SaveSetting(Application.Title, 'Settings', 'MainWidth', Self.Width);
		SaveSetting(Application.Title, 'Settings', 'MainHeight', Self.Height);
	end;
end;

procedure TfMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

procedure TfMainForm.mnu1Click(Index: Smallint; Sender: TObject);
var
	I: Longint;
	S: String;
begin
	// Gambi para mostrar todos os Patrimonial ativo juntos
	sSql := 'select * from tb_grupocon where nm_grupo = '#39'';
	sSql := sSql+Trim(tbTipoCon[Index].NmGrupo)+''#39'';
	if  not Conecta('adm') then Exit;

	RsDb := gBanco.OpenRecordset(sSql);
	// monta string para pegar todos grupos com o mesmo nome
	with RsDb do begin
		S := FieldByName('cd_grupo_con').Value;
		Next;
		while  not EOF do begin
			S := S+''#39' or grupo = '#39''+String(FieldByName('cd_grupo_con').Value);
			Next;
		end;
	end;
	Desconecta();

	sSql := 'select * from tb_opcao where (grupo = '#39'';
	sSql := sSql+S;
	sSql := sSql+''#39') and cliente = '#39''+gCliente+''#39'';

  SimulaMenu.simulSql := sSql;

	SimulaMenu.Caption := mnu1[1].Caption;
	gOpcao := '';

	SimulaMenu.ShowModal();
	fMainForm.mnuRelatorios.Enabled := true;
	fMainForm.mnuArquivo.Enabled := true;
	if gOpcao<>'' then begin
		fMainForm.mnuClientes.Enabled := true;
		// Me.mnuArquivo.Caption = gOpcao
		gConciliacao := gOpcao;
	 end  else  begin
		Screen.Cursor := crDefault;
		Exit;
	end;

	Desconecta();
	if  not Conecta('adm') then Exit;

	sSql := 'Select * from [tb_tipo_con]';
	sSql := sSql+' where nm_conciliacao = '#39''+gConciliacao+''#39'';
	sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);
	with RsDb do begin

		if  not EOF then begin
			gAtualizaGeral := true;
			if AnsiUpperCase(RsDb.FieldByName('AtualizaGeral').Value)='N' then begin
				gAtualizaGeral := false;
			end;
			gEliminaDuplicacao := true;
			if AnsiUpperCase(RsDb.FieldByName('EliminaDuplicacao').Value)='N' then begin
				gEliminaDuplicacao := false;
			end;
			gForcaReal := true;
			if AnsiUpperCase(RsDb.FieldByName('Real').Value)='0' then begin
				gForcaReal := false;
			end;
			gForcaDolar := true;
			if AnsiUpperCase(RsDb.FieldByName('Dolar').Value)='0' then begin
				gForcaDolar := false;
			end;
			// Limpeza Automática
			gLimpAuto := RsDb.FieldByName('LimpAuto').Value;

			// Concil.ArqEntrada = .Fields("Arq_Entrada")
			Concil.ContaContabil := Trim(FieldByName('conta_contabil').Value);
			Concil.ContaEmissor := Trim(FieldByName('cd_cli_banco').Value);
			Concil.Natureza := FieldByName('Natureza_conta').Value;
			Concil.nome := Trim(FieldByName('nm_conciliacao').Value);

			gLimiteVariacao := GetLimite(gCliente, String(Concil.ContaContabil));

		 end  else  begin
			ShowMessage('Banco de Dados Vazio ou Corrompido');
			Desconecta();
			Screen.Cursor := crDefault;
			Exit;
		end;
	end;

	Desconecta();
	if  not Conecta('adm') then Exit;

	sSql := '';
	sSql := sSql+'Select * from [tbContasAdm] ';
	sSql := sSql+'Where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39' ';
	sSql := sSql+'And Natureza = '#39'D'#39' ';
	sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
	sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';
	RsDb := gBanco.OpenRecordset(sSql);

	ncDebito := 0;
	with RsDb do begin
		if  not EOF then begin
			Last;
			ncDebito := RecordCount;
			SetLength(ctDebito, ncDebito+1);
			for I:=0 to ncDebito-1 do begin
				ctDebito[I].Conta := '    ';
				ctDebito[I].conta_para := '';
			end; // I
			First;
		end;

		while  not EOF do begin
			ctDebito[AbsolutePosition].Conta := FieldByName('Codigo').Value;
			ctDebito[AbsolutePosition].conta_para := limpaString(String(FieldByName('Codigo_Para').Value));
			Next;
		end;
	end;

	sSql := '';
	sSql := sSql+'Select * from [tbContasAdm] ';
	sSql := sSql+'Where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39' ';
	sSql := sSql+'And Natureza = '#39'C'#39' ';
	sSql := sSql+' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
	sSql := sSql+' or Bandeira = '#39'VISA-MC'#39') order by codigo';
	RsDb := gBanco.OpenRecordset(sSql);

	ncCredito := 0;
	with RsDb do begin
		if  not EOF then begin
			Last;
			ncCredito := RecordCount;
			SetLength(ctCredito, ncCredito+1);
			for I:=0 to ncCredito-1 do begin
				ctCredito[I].Conta := '    ';
				ctCredito[I].conta_para := '';
			end; // I
			First;
		end;


		while  not EOF do begin
			ctCredito[AbsolutePosition].Conta := FieldByName('Codigo').Value;
			ctCredito[AbsolutePosition].conta_para := limpaString(String(FieldByName('Codigo_Para').Value));
			Next;
		end;
	end;

	Desconecta();
	if  not Conecta('') then Exit;

	sSql := 'Select * from [id]';
	RsDb := gBanco.OpenRecordset(sSql);
	if RsDb.EOF then begin
		RsDb.Insert;
	 end  else  begin
		RsDb.Edit();
	end;
	VBtoADOFieldSet(RsDb, 'Codigo', Relatorio.CdCliente);
	VBtoADOFieldSet(RsDb, 'Nome_Cliente', Relatorio.IdRelatorio);
	// RsDb.Fields("Titulo_Relatorio") = Relatorio.IdRelatorio
	// RsDb.Fields("NomeArquivo") = gArquivo
	RsDb.UpdateRecord;
	Desconecta();
	mnuArquivo.Enabled := true;
	mnuRelatorios.Enabled := true;
	mnuArquivo.Enabled := true;

	BarraStatus();
	Screen.Cursor := crDefault;

end;
procedure TfMainForm.mnu1_1Click(Sender: TObject); begin mnu1Click(1, Sender); end;
procedure TfMainForm.mnu1_2Click(Sender: TObject); begin mnu1Click(2, Sender); end;
procedure TfMainForm.mnu1_3Click(Sender: TObject); begin mnu1Click(3, Sender); end;
procedure TfMainForm.mnu1_4Click(Sender: TObject); begin mnu1Click(4, Sender); end;
procedure TfMainForm.mnu1_5Click(Sender: TObject); begin mnu1Click(5, Sender); end;
procedure TfMainForm.mnu1_6Click(Sender: TObject); begin mnu1Click(6, Sender); end;
procedure TfMainForm.mnu1_7Click(Sender: TObject); begin mnu1Click(7, Sender); end;
procedure TfMainForm.mnu1_8Click(Sender: TObject); begin mnu1Click(8, Sender); end;
procedure TfMainForm.mnu1_9Click(Sender: TObject); begin mnu1Click(9, Sender); end;

procedure TfMainForm.mnuADConsClick(Sender: TObject);
begin
	sSql := 'select data,valor from tb_moeda';
	sSql := sSql+' order by data desc';
	gOpcao := '';
	Consulta.ShowModal();
end;

procedure TfMainForm.mnuAgendaClick(Sender: TObject);
var
	DbLocal: Database;
	RsLocal: TADODataSet;
	Mes, Ano: String;
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;

	if  not Conecta('adm') then Exit;

	sSql := 'select * from tb_tipo_con where conta_contabil = '#39''+TiraPontos(String(Concil.ContaContabil), IntToStr(2))+''#39'';
	sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);
	if RsDb.EOF then begin
		ShowMessage(PChar('Conciliação '+TiraPontos(String(Concil.ContaContabil), IntToStr(2))+' Inválida'));
		Desconecta();
		Exit;
	end;
	if RsDb.FieldByName('Agendamento')<>'S' then begin
		Application.MessageBox('Agendamento não permitido para esta Conciliação', 'Seleção de Conciliação', MB_ICONSTOP);
		Desconecta();
		Exit;
	end;

	// Pedir Datas
	gData1 := '';
	gData2 := '';
	frmAgenda.ShowModal();
	Application.ProcessMessages();
	if (gData1<>'') and (gData2<>'') then begin
		frmAgenda1.ShowModal();
	end;

end;
procedure TfMainForm.mnuAjusteClick(Sender: TObject);
var
	DbLocal: Database;
	RsLocal: TADODataSet;
	Mes, Ano: String;
begin
	// Variação

	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	// Pedir Mês
	gData1 := '';
	gData2 := '';
	frmMes.ShowModal();
	Application.ProcessMessages();
	if Length(gData1)>0 then begin
		Mes := Copy(gData1, 1, 2);
		Ano := Copy(gData1, 4, 4);
		if (Mes='') or (vbVal(Mes)>12) then begin
			ShowMessage('Data da Variação Inválida.');
			Exit;
		end;
	end;
	if (Length(gData1)>0) and ( not isDataValida(gData2)) then begin
		ShowMessage('Data do Lançamento Inválida.');
		Exit;
	end;
	if (Length(gData1)=0) or (Length(gData2)=0) then Exit;

	// Localizar registros
	if  not Conecta('') then Exit;

	sSql := 'Select * from [Lancamentos]';
	sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';

	sSql := sSql+' and Vl_DebitoReal <>  '+FloatToStr(CDbl(0));
	sSql := sSql+' and Vl_CreditoReal <>  '+FloatToStr(CDbl(0));
	sSql := sSql+' and Vl_Saldo <>  '+FloatToStr(CDbl(0));
	// If Concil.Natureza = "D" Then
	sSql := sSql+' and (( month(Data_Credito) =  '+FloatToStr(vbVal(Mes));
	sSql := sSql+' and year(Data_Credito) =  '+FloatToStr(vbVal(Ano));
	sSql := sSql+' and Data_Credito >= Data_Debito '+')';
	// Else
	sSql := sSql+' or ( month(Data_Debito) =  '+FloatToStr(vbVal(Mes));
	sSql := sSql+' and year(Data_Debito) =  '+FloatToStr(vbVal(Ano));
	sSql := sSql+' and Data_Debito >= Data_Credito '+'))';
	// End If
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
	BackupBanco();

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
	AlterarManual.ShowModal();
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
	AlterarManual.ShowModal();
end;

procedure TfMainForm.mnuAltBINClick(Sender: TObject);
begin
	if not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	gData2 := '';
	frmBIN.Caption := 'Altera BIN';
	frmBIN.ShowModal();
end;

procedure TfMainForm.mnuAtGeralClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	AtualizaTotal();
end;
procedure TfMainForm.mnuAualizaClick(Sender: TObject);
var
	Buffer, Buffer1, buffer2: String;
	I: Longint;
	sPath, NomeTmp: String;
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	// gDataRelatorio = ""
	DataMov.ShowModal();
	if  not isDataValida(gDataRelatorio) then begin
		Exit;
	end;

	if  not Conecta('') then Exit;

	// sSql = "select * from tb_moeda where strdata) = '" &

	// sSql = "select * from tb_moeda where str(data) = '" &
	// Mid$(gDataRelatorio, 1, 6) & "20" & Mid$(gDataRelatorio, 7, 2) & "'"
	sSql := 'select * from tb_moeda ';
	sSql := sSql+'where str(data) = '#39''+gDataRelatorio+''#39'';
	sSql := sSql+' or str(data) = '#39''+'20'+Copy(gDataRelatorio, 1, 6)+Copy(gDataRelatorio, 7, 2)+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);
	if RsDb.EOF then begin
		ShowMessage('Dolar não está cadastrado');
		Exit;
	end;
	gTaxa := RsDb.FieldByName('valor').Value;
	sSql := 'Select * from [Lancamentos]';

	gData1 := FormatVB(CDate(gDataRelatorio),'DD/MM/YYYY');

	sSql := sSql+' where (str(Data_Debito) = '#39''+gData1+''#39'';
	sSql := sSql+' or str(Data_Credito) = '#39''+gData1+''#39' or str(Data_Credito) = '#39''+gDataRelatorio+''#39')';
	sSql := sSql+' and conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);

	if  not RsDb.EOF then begin
		ShowMessage('Movimento já foi Processado.');
		Desconecta();
		Exit;
	end;
	Desconecta();

	gAutomatico := true;

	NomeArquivo := GetPath()+'\';
	// NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ArqEntrada)
	NomeArquivo := NomeArquivo+gCliente+'\entrada\'+'JUNTADO';
	NomeArquivo := NomeArquivo+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 4, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 1, 2);
	NomeArquivo := NomeArquivo+'.txt';

	NomeTmp := GetPath()+'\';
	NomeTmp := NomeTmp+gCliente+'\entrada\'+Trim(Concil.ContaContabil);
	NomeTmp := NomeTmp+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeTmp := NomeTmp+Copy(gDataRelatorio, 4, 2);
	NomeTmp := NomeTmp+Copy(gDataRelatorio, 1, 2);
	NomeTmp := NomeTmp+'.tmp';

	// If gAtualizaGeral Then
	gAutomatico := false;
	if GeraTemp(NomeTmp) then begin
		NomeArquivo := NomeTmp;
	 end  else  begin
		Exit;
	end;


	// Verifica se conta tem Limpeza Automática

	if gLimpAuto>0 then begin
		LimpaConta(String(Concil.ContaContabil), gLimpAuto);
	end;

	// End If
	gArquivo11 := '';
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+String(Concil.ContaContabil)+' - '+gConciliacao+#10+'         Débitos    Créditos       Saldo'+#10+#10;
	gAutomatico := false;
	gTotDebito := 0;
	gTotCredito := 0;
	gSaldo := FloatToStr(GetSaldo());
	if gAtualizaGeral then begin
		if Concil.Natureza='D' then begin
			for I:=0 to ncDebito-1 do begin
				if  not ContaDebito(I, '840') then Exit;
			end; // I
			for I:=0 to ncCredito-1 do begin
				if  not ContaCredito(I, '840') then Exit;
			end; // I

			for I:=0 to ncDebito-1 do begin
				if  not ContaDebito(I, '986') then Exit;
			end; // I
			for I:=0 to ncCredito-1 do begin
				if  not ContaCredito(I, '986') then Exit;
			end; // I
		 end  else  begin
			for I:=0 to ncCredito-1 do begin
				if  not ContaCredito(I, '840') then Exit;
			end; // I
			for I:=0 to ncDebito-1 do begin
				if  not ContaDebito(I, '840') then Exit;
			end; // I

			for I:=0 to ncCredito-1 do begin
				if  not ContaCredito(I, '986') then Exit;
			end; // I
			for I:=0 to ncDebito-1 do begin
				if  not ContaDebito(I, '986') then Exit;
			end; // I
		end;
	 end  else  begin
		// Processa Contas de Resultado. Possui alto volume e é transitória
		// ou seja, o Débito e o Crédito são processados no mesmo dia
		ContasResultado();
	end;
	// Faz Backup do banco de dados com as novas movimentações
	BackupBanco();

	// Mostra Débitos e Créditos
	Buffer := FormatVB(gTotDebito,'###,##0.00');
	Buffer1 := FormatVB(gTotCredito,'###,##0.00');
	buffer2 := FormatVB(GetSaldo(),'###,##0.00');

	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+#10+StringOfChar(' ', 14-Length(Buffer))+Buffer+' '+StringOfChar(' ', 14-Length(Buffer1))+Buffer1+' '+StringOfChar(' ', 14-Length(buffer2))+buffer2+#10;

	gArquivo11 := frmLog.RichTextBox1.Text;
	frmLog.Close();
	frmLog.ShowModal();
end;

procedure TfMainForm.mnuBatClick(Sender: TObject);
var
	I: Smallint;
	sPath, NomeTmp: String;
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	// If Len(gConciliacao) = 0 Then
	// MsgBox "Selecione Conciliação..."
	// Exit Sub
	// End If
	// gDataRelatorio = ""
	DataMov.ShowModal();
	if  not isDataValida(gDataRelatorio) then begin
		Exit;
	end;

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

	gData1 := FormatVB(CDate(gDataRelatorio),'DD/MM/YYYY');

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

	NomeArquivo := GetPath()+'\';
	NomeArquivo := NomeArquivo+gCliente+'\Bx_Banco_Deb\'+Trim(Concil.ContaContabil);
	NomeArquivo := NomeArquivo+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 4, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 1, 2);
	NomeArquivo := NomeArquivo+'.prn';

	if Dir(NomeArquivo)='' then begin
		ShowMessage(PChar('Arquivo '+NomeArquivo+'nao localizado'));
		Exit;
	end;

	NomeArquivo := GetPath()+'\';
	NomeArquivo := NomeArquivo+gCliente+'\Bx_Banco_Cred\'+Trim(Concil.ContaContabil);
	NomeArquivo := NomeArquivo+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 4, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 1, 2);
	NomeArquivo := NomeArquivo+'.prn';

	if Dir(NomeArquivo)='' then begin
		ShowMessage(PChar('Arquivo '+NomeArquivo+'nao localizado'));
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
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+String(Concil.ContaContabil)+' - '+gConciliacao+#10+'         Débitos    Créditos       Saldo'+#10+#10;
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
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	BackupGeral();
end;
procedure TfMainForm.mnuBkpMensalClick(Sender: TObject);
label
	Erro;
var
	nome, sData: String;
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	if Application.MessageBox('O Mês ja foi fechado? Confirma Operação?', 'Backup do Movimento Zerado', MB_YESNO)=IDNO then begin
		Exit;
	end;
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

	CopyFile(PChar(String(gDataPath)+gDataFile), PChar(NomeArquivo), false);

	if  not QuebraBanco() then begin
		ShowMessage('Erro na Cópia do Banco');
		Screen.Cursor := crDefault;
		Exit;
	end;

	Desconecta();

	LimpaBackUp(10);
	NomeArquivo := gAdmPath+'\';
	NomeArquivo := NomeArquivo+gCliente+'\BackupMensal\';
	NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
	NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
	NomeArquivo := NomeArquivo+'Hist_'+gCliente+'_';
	NomeArquivo := NomeArquivo+'Mensal'+'.mdb';

	try	// On Error GoTo Erro
		// Copia o Arquivo gerado pelo Quebrabanco para o diretório
		// BackupMensal
		CopyFile(PChar(String(gDataPath)+'Hist_'+gDataFile), PChar(NomeArquivo), false);

		LimpaBackUp(10);
		NomeArquivo := gAdmPath+'\';
		NomeArquivo := NomeArquivo+gCliente+'\Backup\';
		NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
		NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
		NomeArquivo := NomeArquivo+gCliente+'_';
		NomeArquivo := NomeArquivo+'Geral'+'.mdb';

		// Copia o Arquivo com movimento gerado pelo Quebrabanco
		// para o diretório Backup
		CopyFile(PChar(String(gDataPath)+gDataFile), PChar(NomeArquivo), false);

		NomeArquivo := gAdmPath+'\';
		NomeArquivo := NomeArquivo+gCliente+'\Backup_temp\';
		nome := Dir(NomeArquivo+'*.mdb');
		while Dir(NomeArquivo+'*.mdb')<>'' do begin
			if (1+Pos('Geral', PChar(nome)+1))=0 then begin
				DeleteFile(NomeArquivo+nome);
			end;
			nome := Dir(NomeArquivo+'*.mdb');
		end;

		// Deleta arquivos antigos

		NomeArquivo := gAdmPath+'\';
		NomeArquivo := NomeArquivo+gCliente+'\entrada\';
		nome := Dir(NomeArquivo+'*.*');
		while nome<>'' do begin
			if Length(Trim(gDataRelatorio))=0 then break;
			sData := FormatVB(CDate(gDataRelatorio),'YYYYMMDD');
			if (1+Pos(sData, PChar(nome)+1))=0 then begin
				DeleteFile(NomeArquivo+nome);
				nome := Dir(NomeArquivo+'*.*');
			 end  else  begin
				nome := Dir();
			end;
		end;

		Screen.Cursor := crDefault;
		ShowMessage('BackUp Mensal Efetuado.');
		Exit;
	except	// Erro:
		Screen.Cursor := crDefault;
		ShowMessage(PChar('Erro no BackUp.'+#10+'Err.Description'));
		Err.Clear();
	end;
end;
procedure TfMainForm.mnuCBDGeralClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;

	if  not ChecaTempDb() then begin
		ShowMessage('Arquivo não encontrado...');
		Exit;
	end;
	gAlteraLanc := GERAL;
	Alterar_Consulta.ShowModal();

end;
procedure TfMainForm.mnuCBDPendenciasClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;

	if  not ChecaTempDb() then begin
		ShowMessage('Arquivo não encontrado...');
		Exit;
	end;
	gAlteraLanc := PENDENCIA;
	Alterar_Consulta.ShowModal();
end;
procedure TfMainForm.mnuCCClienteClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	PedeAlteração.Caption := 'Consulta Conciliação';
	PedeAlteração.Label1.Caption := 'Nome do Cliente';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if Trim(gOpcao)='' then begin
		Exit;
	 end  else  begin
		gCliente := gOpcao;
		gDataPath := GetPath()+'\'+gCliente+'\';
		gDataFile := gCliente+'.mdb';

		if Dir(String(gDataPath)+gDataFile)='' then begin
			ShowMessage('Cliente não Cadastrado');
			gCliente := '';
			Exit;
		end;
		gArquivo11 := gCliente;
		ConsultaCon.ShowModal();
	end;
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

procedure TfMainForm.mnuCCGeralClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	gArquivo11 := 'Geral';
	ConsultaCon.ShowModal();
end;

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

procedure TfMainForm.mnuConBINClick(Sender: TObject);
begin
	Consulta.sSqlConsulta := 'select * from tbBIN';
	Consulta.sSqlConsulta := Consulta.sSqlConsulta + ' order by BIN';
	gOpcao := '';
	if Length(Trim(gCliente))=0 then begin
		ShowMessage('Selecione um Cliente');
		Exit;
	end;
	Consulta.Caption := 'Consulta BIN';
	Consulta.ShowModal();
end;

procedure TfMainForm.mnuConfClick(Sender: TObject);
var
	versao: String;
begin
	// Mostra a configuração da conciliação
	gArquivo11 := '';

	versao := 'Versão do Programa.... ver. ';
	versao := versao+String(App.Major)+'.';
	versao := versao+String(App.Minor)+' rev. ';
	versao := versao+String(App.Revision);

	// LastAtualiza

	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Configuração da Conciliação'+#10+#10;
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Diretório de Trabalho: '+gAdmPath+#10+'Cliente .............. '+gCliente+#10+'Conciliação........... '+gConciliacao+#10+'Conta Contabil........ '+String(Concil.ContaContabil)+#10+'Usuário............... '+gOperador+#10
		+versao+#13#10;

	gArquivo11 := frmLog.RichTextBox1.Text;
	frmLog.Close();
	frmLog.ShowModal();
end;
procedure TfMainForm.mnuConsClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	sSql := 'select Id_usuario,Nome_usuario,cd_grupo_usu,senha from usuarios';
	gOpcao := 'adm';
	Consulta.ShowModal();
end;

procedure TfMainForm.mnuCopyFileClick(Sender: TObject);
label
	Erro;
var
	arqOrigem, arqDestino, NomeArquivo, nome, sDir, sLog: String;
	listaArquivos: TStringList;
	I: Smallint;
begin
	listaArquivos := nil;

	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	if gNomeComputador='CR-SCC' then begin
		arqOrigem := 'm:\destino\';
		arqOrigem := 'C:\ROM\CONCILIA\MOVTO_20080909\';
		arqDestino := 'C:\ROM\CONCILIA\';
	 end  else  begin
		arqOrigem := '\\srvsccspd01\concilia\';
		arqDestino := 'C:\ROM\CONCILIA\';
	end;
	try	// On Error GoTo Erro
		nome := Dir(arqOrigem+'*.*');
		if Length(nome)=0 then begin
			ShowMessage(PChar('Nenhum arquivo encontrado em: '+arqOrigem));
			Exit;
		end;
		sDir := getDataFromNome(nome);

		 {? On Error Resume Next  }
		Dir(arqDestino+'MOVTO_'+sDir);

		frmLog.Show();


		frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Copiando Arquivos do servicor ROM para o servicor Concilia. '+#10+#10;

		I := 1;
		while nome<>'' do begin
			ReDimPreserve(listaArquivos, I+1);
			listaArquivos[I] := nome;
			I := I+1;
			nome := Dir();
		end;

		listaArquivos[I] := '999999';

		I := 1;
		while listaArquivos[I]<>'999999' do begin

			if Dir(arqDestino+sDir+'\'+listaArquivos[I])<>'' then begin
				frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Arquivo '+listaArquivos[I]+' Já existe...'+#10;
			 end  else  begin

				gArquivo11 := frmLog.RichTextBox1.Text;

				frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Copiando Arquivo '+arqDestino+sDir+'\'+listaArquivos[I]+'...'+#10;
				frmLog.RichTextBox1.SelStart := 0;
				frmLog.RichTextBox1.SelLength := Length(gArquivo11);
				frmLog.RichTextBox1.SelFontName := 'Courier New';
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
		frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+#10+'Fim da Cópia dos Arquivos. '+DateTimeToStr(Now())+#10;
		gArquivo11 := frmLog.RichTextBox1.Text;
		Application.ProcessMessages();

		Exit;
	except	// Erro:
		if Err.Number=52 then { Resume Next }
	end;
end;
procedure TfMainForm.mnuCUAltClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	frmAltUsuario.ShowModal();
end;

procedure TfMainForm.mnuCUExcClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	PedeAlteração.Caption := 'Exclui Usuário';
	PedeAlteração.Label1.Caption := 'Id do Usuário';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if gOpcao<>'' then begin
		if  not Conecta('adm') then Exit;
		sSql := 'select * from usuarios where id_usuario = '#39''+gOpcao+''#39'';
		RsDb := gBanco.OpenRecordset(sSql);
		if RsDb.EOF then begin
			Application.MessageBox('Usuário não Cadastrado', 'Cadastro de Usuários', MB_ICONSTOP);
			Desconecta();
			Exit;
		end;
		if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then begin
			RsDb.Delete;
		end;
		Desconecta();
	end;
end;

procedure TfMainForm.mnuCUInsClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	frmUsuario.ShowModal();
end;

procedure TfMainForm.mnuCvMesAlterarClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	gData2 := '';
	frmConvMes.Caption := 'Altera Relatório';
	frmConvMes.ShowModal;
end;

procedure TfMainForm.mnuCvMesConsultarClick(Sender: TObject);
begin
	sSql := 'select Relatorio,Jan,Fev,Mar,Abr,Mai,Jun,Jul,Ago,Set,Out,Nov,Dez from tbConvMes';
	sSql := sSql+' order by Relatorio';
	gOpcao := 'ADM';
	Consulta.Caption := 'Consulta Tabela de Conversão de Data';
	ConsultaCvMes.ShowModal;
end;

procedure TfMainForm.mnuCvMesExcluirClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	gData2 := '';
	PedeAlteração.Caption := 'Exclui Relatório';
	PedeAlteração.Label1.Caption := 'Digite o Relatório';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if gOpcao='' then Exit;
	if  not Conecta('ADM') then Exit;

	sSql := 'select * from tbConvMes where Relatorio = '#39''+gOpcao+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);
	if RsDb.EOF then begin
		Application.MessageBox('Relatorio não Cadastrado', 'Cadastro de Relatorio', MB_ICONSTOP);
		Desconecta();
		Exit;
	end;
	if Application.MessageBox(PCHAR('Confirma Exclusão do Relatorio '+gOpcao), 'Excluir Registros', MB_YESNO)=IDYES then begin
		RsDb.Delete;
		ShowMessage('Relatorio Excluido!!!');
	end;
	Desconecta();

end;

procedure TfMainForm.mnuCvMesIncluirClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	gData2 := '';
	frmConvMes.Caption := 'Inclui Relatório';
	frmConvMes.ShowModal();
end;

procedure TfMainForm.mnuEPBClick(Sender: TObject);
var
	RsExc, RsLocal: TADODataSet;
	DbLocal: Database;
	RecCount: Longint;
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
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
	// fMainForm.CrystalReport1.Action = 1
end;

procedure TfMainForm.mnuExcBINClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	PedeAlteração.Caption := 'Exclui BIN';
	PedeAlteração.Label1.Caption := 'Digite o BIN';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if gOpcao='' then Exit;
	if  not Conecta('') then Exit;

	sSql := 'select * from tbBIN where BIN = '#39''+gOpcao+''#39'';
	RsDb := gBanco.OpenRecordset(sSql);
	if RsDb.EOF then begin
		Application.MessageBox('BIN não Cadastrado', 'Cadastro de BIN', MB_ICONSTOP);
		Desconecta();
		Exit;
	end;
	if Application.MessageBox(PCHAR('Confirma Exclusão do BIN '+gOpcao), 'Excluir Registros', MB_YESNO)=IDYES then begin
		RsDb.Delete;
	end;
	Desconecta();

end;

procedure TfMainForm.mnuEXGerComClick(Sender: TObject);
var
	J: Smallint;
begin
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	DataLimite.Caption := 'Data do Relatório';
	DataLimite.Label1.Caption := 'Relatório até:';
	DataLimite.ShowModal(); // Alterado em 7/11/2000
	if gData1='' then begin
		ShowMessage('Operação Cancelada');
		Exit;
	end;
	GeraLista();
	J := 0;
	while J<gMaxCon do begin
		gConciliacao := gArrConcil[J];
		gLimiteVariacao := GetLimite(gArrConcil3[J], gArrConcil2[J]);
		SimulaNovaCon();
		GeraExcel(true);
		J := J+1;
	end;
	ShowMessage(PChar('Planilhas geradas em '+String(gExcelPath)));

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
	if gData1='' then begin
		ShowMessage('Operação Cancelada');
		Exit;
	end;
	GeraLista();
	J := 0;
	while J<gMaxCon do begin
		gConciliacao := gArrConcil[J];
		gLimiteVariacao := GetLimite(gArrConcil3[J], gArrConcil2[J]);
		SimulaNovaCon();
		GeraExcel(false);
		J := J+1;
	end;
	ShowMessage(PChar('Planilhas geradas em '+String(gExcelPath)));
end;
procedure TfMainForm.GeraExcel(ComSem: Boolean);
begin
	Application.ProcessMessages();
	if gData1<>'' then begin
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelExcell(gData1, ComSem, false);
		Screen.Cursor := crDefault;
	end;

end;
procedure TfMainForm.GeraLista();
var
	Work, Banco: OleVariant;
	DbLocal: Database;
	RsLocal: TADODataSet;
begin
	Work := DBEngine.Workspaces(0);
	Banco := Work.OpenDatabase(gAdmPath+'\admin.mdb');

	sSql := 'select * from tb_tipo_con ';
	sSql := sSql+' where excel='#39'S'#39'';
	sSql := sSql+' and cliente='#39''+gCliente+''#39'';
	RsLocal := Banco.OpenRecordset(sSql);
	gMaxCon := 0;
	with RsLocal do begin
		RsLocal.Last;
		ReDim(gArrConcil, RsLocal.RecordCount+1);
		ReDim(gArrConcil2, RsLocal.RecordCount+1);
		ReDim(gArrConcil3, RsLocal.RecordCount+1);
		RsLocal.First;
		while  not EOF do begin
			gArrConcil[gMaxCon] := FieldByName('nm_conciliacao').Value;
			gArrConcil2[gMaxCon] := Trim(FieldByName('conta_contabil').Value);
			gArrConcil3[gMaxCon] := FieldByName('cliente').Value;
			gMaxCon := gMaxCon+1;
			Next;
		end;
	end;
	RsLocal.Close();
	RsLocal := nil;
	Banco.Close();
	Banco := nil;

end;

procedure TfMainForm.mnuGAEComClick(Sender: TObject);
begin
	// Gerar Relatório Excell Com Mensagem
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
	if gData1<>'' then begin
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelExcell(gData1, true, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuGAESemClick(Sender: TObject);
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
	if gData1<>'' then begin
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelExcell(gData1, false, true);
		Screen.Cursor := crDefault;
	end;

end;
// Private Sub mnuGBB_Click()
// If Not Autoriza(cATUALIZA) Then
// Exit Sub
// End If
// frmBaixaBanco.Show
// End Sub
procedure TfMainForm.mnuGCConsultarClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	sSql := 'select * from tb_GrupoCon';
	gOpcao := 'adm';
	Consulta.ShowModal();
end;
procedure TfMainForm.mnuDDAltClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	atMoeda.Caption := 'Altera Valor da Moeda';
	atMoeda.ShowModal();
end;
procedure TfMainForm.mnuDDExclClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	PedeAlteração.Caption := 'Exclui Dolar do Dia';
	PedeAlteração.Label1.Caption := 'Data (DD/MM/AAAA)';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if isDataValida(gOpcao) then begin
		if  not Conecta('') then Exit;

		sSql := 'select * from tb_moeda where str(data) = '#39''+gOpcao+''#39' or str(data) = '#39''+dataDezBarra(gOpcao)+''#39'';
		RsDb := gBanco.OpenRecordset(sSql);
		if RsDb.EOF then begin
			Application.MessageBox('Moeda não Cadastrada', 'Moeda do Dia', MB_ICONSTOP);
			Desconecta();
			Exit;
		end;
		if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then begin
			RsDb.Delete;
		end;
		Desconecta();
	 end  else  begin
		if Length(gOpcao)>0 then Application.MessageBox('Data Inválida...', 'Moeda do Dia', MB_ICONSTOP);
	end;
end;

procedure TfMainForm.mnuDDIncClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	gData2 := '';
	atMoeda.Caption := 'Inclui Valor da Moeda';
	atMoeda.ShowModal();
end;

procedure TfMainForm.mnuGMClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	frmGeraMov.Show();
end;

procedure TfMainForm.mnuGODComClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	// DataLimite.Show 1
	gData1 := FormatVB(Now(),'DD/MM/YYYY');
	Application.ProcessMessages();
	if gData1<>'' then begin
		gData2 := gData1;
		gData1 := '';
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelatorioSaldo(gData2, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuGODSemClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
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
	MontaRelatorioSaldo(gData1, false);
	Screen.Cursor := crDefault;

end;
procedure TfMainForm.mnuGOOComClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	gData1 := FormatVB(Now(),'DD/MM/YYYY');
	Application.ProcessMessages();
	if gData1<>'' then begin
		gData2 := gData1;
		gData1 := '';
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelatorioSaldo(gData2, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuGOOSemClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	gData1 := FormatVB(Now(),'DD/MM/YYYY');
	Application.ProcessMessages();
	if gData1<>'' then begin
		gData2 := gData1;
		gData1 := '';
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelatorioSaldo(gData2, false);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuGPOCComClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);

	DataLimite.Caption := 'Data do Balancete';
	DataLimite.ShowModal();
	Application.ProcessMessages();
	if gData1<>'' then begin
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelatorioSaldo(gData1, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuGPOCSemClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	DataLimite.Caption := 'Data do Balancete';
	DataLimite.ShowModal();
	Application.ProcessMessages();
	if gData1<>'' then begin
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelatorioSaldo(gData1, false);
		Screen.Cursor := crDefault;
	end;

end;
procedure TfMainForm.mnuGPODComClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	DataLimite.Caption := 'Data do Balancete';
	DataLimite.ShowModal();
	Application.ProcessMessages();
	if gData1<>'' then begin
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelatorioSaldo(gData1, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuGPODSemClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);

	DataLimite.Caption := 'Data do Balancete';
	DataLimite.ShowModal();
	Application.ProcessMessages();
	if gData1<>'' then begin
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelatorioSaldo(gData1, false);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuHistoricoClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;

	if  not ChecaTempDb() then begin
		ShowMessage('Arquivo não encontrado...');
		Exit;
	end;
	gAlteraLanc := GERAL;
	Historico.ShowModal();
end;

procedure TfMainForm.mnuIncBINClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	gData2 := '';
	frmBIN.Caption := 'Inclui BIN';
	frmBIN.ShowModal();
end;

procedure TfMainForm.mnuInterfaceClick(Sender: TObject);
var
	DbLocal: Database;
	RsLocal: TADODataSet;
	I: Smallint;
	sPath, NomeTmp: String;
begin

	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	DataMov.ShowModal();
	if  not isDataValida(gDataRelatorio) then begin
		Exit;
	end;

	if  not Gera_Interface() then begin
		// mensagen de erro
		Exit;
	end;

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
	DataMov.ShowModal();
	Application.ProcessMessages();
	if gDataRelatorio<>'' then begin
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gData1 := gDataRelatorio;
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
	if gDataRelatorio<>'' then begin
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gData1 := gDataRelatorio;
		salvaConciliacao := gConciliacao;
		gConciliacao := 'Registros Sem perna(Saci)';
		MontaRelatorioSaci(gDataRelatorio, false);
		gConciliacao := salvaConciliacao;
		Screen.Cursor := crDefault;
	end;
end;

procedure TfMainForm.mnuJuncaoClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	frmJuncao.Show();
end;

procedure TfMainForm.mnuJuncaoJuntadosClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	DataDeAte.Show();
end;
procedure TfMainForm.mnuLogClick(Sender: TObject);
var
	DbLocal: Database;
	RsLocal: TADODataSet;
begin
	Screen.Cursor := crHourGlass;
	if  not Autoriza(cATUALIZA) then begin
		Screen.Cursor := crDefault;
		Exit;
	end;
	gWork := DBEngine.Workspaces(0);
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
	end;
end;

procedure TfMainForm.mnuMGCAltClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	PedeAlteração.Caption := 'Altera Grupo de Conciliação';
	PedeAlteração.Label1.Caption := 'Código do Grupo';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if gOpcao<>'' then begin
		if  not Conecta('adm') then Exit;

		sSql := 'select * from tb_GrupoCon where cd_grupo_con = '#39''+gOpcao+''#39'';
		RsDb := gBanco.OpenRecordset(sSql);
		if RsDb.EOF then begin
			Application.MessageBox('Grupo não Cadastrado', 'Seleção de Conciliação', MB_ICONSTOP);
			Desconecta();
			Exit;
		end;
		GrupoConAlt.ShowModal();
	end;
end;

procedure TfMainForm.mnuMGCExcClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	PedeAlteração.Caption := 'Exclui Grupo de Conciliação';
	PedeAlteração.Label1.Caption := 'Grupo de Conciliação';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if gOpcao<>'' then begin
		if  not Conecta('adm') then Exit;
		sSql := 'select * from tb_tipo_con ';
		sSql := sSql+'where cd_grupo_con = '#39''+gOpcao+''#39'';
		RsDb := gBanco.OpenRecordset(sSql);
		if  not RsDb.EOF then begin
			ShowMessage('Exclua as contas contábeis deste grupo antes de excluir o grupo!');
			Desconecta();
			Exit;
		end;

		sSql := 'select * from tb_GrupoCon where cd_grupo_con = '#39''+gOpcao+''#39'';
		RsDb := gBanco.OpenRecordset(sSql);
		if RsDb.EOF then begin
			Application.MessageBox('Grupo de Conciliação não Cadastrado', 'Seleção de Conciliação', MB_ICONSTOP);
			Desconecta();
			Exit;
		end;
		if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then begin
			RsDb.Delete;
		end;
		Desconecta();
	end;
end;

procedure TfMainForm.mnuMGCIncClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	GrupoCon.ShowModal();
end;

procedure TfMainForm.mnuNCAltClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	// Altera um Cliente cadastrado
	// Admin.mdb => Nome_Cliente = Opção de menu e Nome do Banco de Dados
	// Titulo_Relatorio
	// No Banco de dados do cliente também deve existir o
	// nome do cliente e o código na tabela Id
	// O banco de dados vai para o diretório Dados
	NovoClienteAlt.Show();
end;
procedure TfMainForm.mnuNCConClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	sSql := 'select codigo_cliente,Nome_reduzido,nome_cliente from clientes';
	gOpcao := 'adm';
	Consulta.ShowModal();
end;

procedure TfMainForm.mnuNormalClick(Sender: TObject);
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	frmBaixaBanco.Show();
end;

procedure TfMainForm.mnuNotasClick(Sender: TObject);
begin
	frmRelease.ShowModal();
end;
procedure TfMainForm.mnuNovoClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	// Cria um Cliente novo
	// Admin.mdb => Nome_Cliente = Opção de menu e Nome do Banco de Dados
	// Titilo_Relatorio
	// No Banco de dados do cliente também deve existir o
	// nome do cliente e o código na tabela Id
	// O banco de dados vai para o diretório Dados
	NovoCliente.Show();
end;
procedure TfMainForm.mnuPGODComClick(Sender: TObject);
begin
	// Saldo <> 0
	// Chama o Relatório do Crystal Report
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	if IsDate(gAtualizacao) then begin
		gData1 := DateTimeToStr(gAtualizacao);
	 end  else  begin
		gData1 := FormatVB(Now(),'DD/MM/YYYY');
	end;
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelPendencias(gData1, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuPGODSemClick(Sender: TObject);
begin
	// Saldo <> 0
	// Chama o Relatório do Crystal Report
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);

	if IsDate(gAtualizacao) then begin
		gData1 := DateTimeToStr(gAtualizacao);
	 end  else  begin
		gData1 := FormatVB(Now(),'DD/MM/YYYY');
	end;
	Application.ProcessMessages();
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelPendencias(gData1, false);
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
	if IsDate(gAtualizacao) then begin
		gData1 := DateTimeToStr(gAtualizacao);
	 end  else  begin
		gData1 := FormatVB(Now(),'DD/MM/YYYY');
	end;
	Application.ProcessMessages();
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelPendencias(gData1, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuPOCSemClick(Sender: TObject);
begin
	// Saldo <> 0
	// Chama o Relatório do Crystal Report
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	if IsDate(gAtualizacao) then begin
		gData1 := DateTimeToStr(gAtualizacao);
	 end  else  begin
		gData1 := FormatVB(Now(),'DD/MM/YYYY');
	end;
	Application.ProcessMessages();
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelPendencias(gData1, false);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuPPOCComClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	DataLimite.Caption := 'Data da Pendência';
	DataLimite.Label1.Caption := 'Pendências até';
	DataLimite.ShowModal(); // Alterado em 7/11/2000
	Application.ProcessMessages();
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelPendencias(gData1, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuPPOCSemClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	DataLimite.Caption := 'Data da Pendência';
	DataLimite.Label1.Caption := 'Pendências até';
	DataLimite.ShowModal(); // Alterado em 7/11/2000
	Application.ProcessMessages();
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 2;
		MontaRelPendencias(gData1, false);
		Screen.Cursor := crDefault;
	end;

end;
procedure TfMainForm.mnuPPODComClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	DataLimite.Caption := 'Data da Pendência';
	DataLimite.Label1.Caption := 'Pendências até';
	DataLimite.ShowModal(); // Alterado em 7/11/2000
	Application.ProcessMessages();
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelPendencias(gData1, true);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuPPODSemClick(Sender: TObject);
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
	gData2 := DateTimeToStr(gAtualizacao);
	DataLimite.Caption := 'Data da Pendência';
	DataLimite.Label1.Caption := 'Pendências até';
	DataLimite.ShowModal(); // Alterado em 7/11/2000
	Application.ProcessMessages();
	if gData1<>'' then begin
		// gData2 = gData1
		// gData1 = ""
		// Chama o Relatório do Crystal Report
		Screen.Cursor := crHourGlass;
		gOrdem := 1;
		MontaRelPendencias(gData1, false);
		Screen.Cursor := crDefault;
	end;
end;
procedure TfMainForm.mnuRestauraClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	if Length(gCliente)=0 then begin
		ShowMessage('Selecione Cliente');
		Exit;
	end;
	Desconecta();
	with fMainForm.dlgCommonDialog do begin
		Filter := 'Access MDB (*.mdb)';
		Title := 'Banco de Dados a Restaurar';

		InitialDir := String(gDataPath)+'Backup';
		FileName := '';
		Execute();
		if FileName<>'' then begin
			NomeArquivo := FileName;
			if AnsiUpperCase(RightStr(NomeArquivo, 4))<>'.MDB' then begin
				ShowMessage('Arquivo não é Banco de Dados');
			 end  else  begin
				Screen.Cursor := crHourGlass;
				if Dir(NomeArquivo)<>'' then begin
					if (1+Pos(gCliente+'_', PChar(NomeArquivo)+1))=0 then begin
						ShowMessage('Banco de Dados não é deste Cliente');
					 end  else  begin
						CopyFile(PChar(NomeArquivo), PChar(String(gDataPath)+gCliente+'.MDB'), false);
						Conecta('');
						Screen.Cursor := crDefault;
						ShowMessage('Backup Restaurado!!!');
					end;
				end;
				Screen.Cursor := crDefault;
			end;
		end;
	end;
end;
//{$DEFINE defUse_mnuRotMen_Click}
{$IF Defined(defUse_mnuRotMen_Click)}
procedure TfrmMain.mnuRotMen_Click();
begin
	ShowMessage('Opção não está liberada!');
end;
{$IFEND} // defUse_mnuRotMen_Click

procedure TfMainForm.mnuRotMesClick(Sender: TObject);
label
	Erro;
var
	nome, sData: String;
begin
	if  not Autoriza(cATUALIZA) then begin
		Exit;
	end;
	if Application.MessageBox('O Mês ja foi fechado? Confirma Operação?', 'Backup do Movimento Zerado', MB_YESNO)=IDNO then begin
		Exit;
	end;
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

	CopyFile(PChar(String(gDataPath)+gDataFile), PChar(NomeArquivo), false);

	if  not QuebraBanco() then begin
		ShowMessage('Erro na Cópia do Banco');
		Screen.Cursor := crDefault;
		Exit;
	end;

	Desconecta();

	LimpaBackUp(10);
	NomeArquivo := gAdmPath+'\';
	NomeArquivo := NomeArquivo+gCliente+'\BackupMensal\';
	NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
	NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
	NomeArquivo := NomeArquivo+'Hist_'+gCliente+'_';
	NomeArquivo := NomeArquivo+'Mensal'+'.mdb';

	try	// On Error GoTo Erro
		// Copia o Arquivo gerado pelo Quebrabanco para o diretório
		// BackupMensal
		CopyFile(PChar(String(gDataPath)+'Hist_'+gDataFile), PChar(NomeArquivo), false);

		LimpaBackUp(10);
		NomeArquivo := gAdmPath+'\';
		NomeArquivo := NomeArquivo+gCliente+'\Backup\';
		NomeArquivo := NomeArquivo+FormatVB(Now(),'YYYYMMDD')+'_';
		NomeArquivo := NomeArquivo+FormatVB(Now(),'HHMMSS')+'_';
		NomeArquivo := NomeArquivo+gCliente+'_';
		NomeArquivo := NomeArquivo+'Geral'+'.mdb';

		// Copia o Arquivo com movimento gerado pelo Quebrabanco
		// para o diretório Backup
		CopyFile(PChar(String(gDataPath)+gDataFile), PChar(NomeArquivo), false);

		NomeArquivo := gAdmPath+'\';
		NomeArquivo := NomeArquivo+gCliente+'\Backup_temp\';
		nome := Dir(NomeArquivo+'*.mdb');
		while Dir(NomeArquivo+'*.mdb')<>'' do begin
			if (1+Pos('Geral', PChar(nome)+1))=0 then begin
				DeleteFile(NomeArquivo+nome);
			end;
			nome := Dir(NomeArquivo+'*.mdb');
		end;

		// Deleta arquivos antigos

		NomeArquivo := gAdmPath+'\';
		NomeArquivo := NomeArquivo+gCliente+'\entrada\';
		nome := Dir(NomeArquivo+'*.*');
		while nome<>'' do begin
			if Length(Trim(gDataRelatorio))=0 then break;
			sData := FormatVB(CDate(gDataRelatorio),'YYYYMMDD');
			if (1+Pos(sData, PChar(nome)+1))=0 then begin
				DeleteFile(NomeArquivo+nome);
				nome := Dir(NomeArquivo+'*.*');
			 end  else  begin
				nome := Dir();
			end;
		end;

		Screen.Cursor := crDefault;
		ShowMessage('BackUp Mensal Efetuado.');
		Exit;
	except	// Erro:
		Screen.Cursor := crDefault;
		ShowMessage(PChar('Erro no BackUp.'+#10+'Err.Description'));
		Err.Clear();
	end;
end;

procedure TfMainForm.mnuSairClick(Sender: TObject);
begin
	Application.Terminate();
end;

procedure TfMainForm.mnuSaldoContClick(Sender: TObject);
var
	RsLocal: TADODataSet;
	Saldo: Double;
	sSaldo: String;
	dMovimento: TDateTime;
	STR, STR1, STR2: TStringList;
	Pont: Smallint;
begin
	STR := nil;
	STR1 := nil;
	STR2 := nil;

	// Mostra os saldos atuais das contas
	gArquivo11 := '';

	if  not Conecta('adm') then Exit;

	sSql := 'select nm_conciliacao,conta_contabil,cd_cli_banco from tb_tipo_con ';
	sSql := sSql+'where cliente = '#39''+gCliente+''#39'';
	sSql := sSql+' order by conta_contabil ';
	RsDb := gBanco.OpenRecordset(sSql);

	Pont := 1;
	with RsDb do begin
		while  not EOF do begin
			ReDimPreserve(STR, Pont+1);
			STR[Pont] := Copy(FieldByName('nm_conciliacao').Value, 1, 36);
			ReDimPreserve(STR1, Pont+1);
			STR1[Pont] := FieldByName('conta_contabil').Value;
			ReDimPreserve(STR2, Pont+1);
			STR2[Pont] := FieldByName('cd_cli_banco').Value;
			Pont := Pont+1;
			Next;
		end;
	end;

	ReDimPreserve(STR1, Pont+1);
	STR1[Pont] := '999999';

	if  not Conecta('') then Exit;

	sSql := 'select * from tbBalancete ';
	// sSql = sSql & "where str(Data) = '09/05/2003'"
	sSql := sSql+'where str(Data) = '#39''+FormatVB(Now()-1,'DD/MM/YYYY')+''#39'';
	sSql := sSql+' order by conta_contabil ';
	RsDb := gBanco.OpenRecordset(sSql);

	if RsDb.EOF then begin
		Desconecta();
		ReDim(STR, 0+1);
		ReDim(STR1, 0+1);
		ReDim(STR2, 0+1);
		ShowMessage('Relatório vazio !!!');
		Exit;
	end;
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Balancete de Verificação               Dolar: '+String(RsDb.FieldByName('UsDolar').Value)+#10+#10+'     Descrição da Conta              Conta XXX       Conta      '+'Saldo Anterior            Débito           Crédito       Saldo Atual'
		+#10+#10;

	PBar.Show();
	PBar.Label1.Visible := true;
	PBar.ProgressBar1.Visible := true;
	PBar.Label1.Caption := 'Gerando Balancete do Dia';

	with RsDb do begin
		while  not EOF do begin
			PBar.ProgressBar1.Position := RsDb.PercentPosition;
			Application.ProcessMessages();

			Pont := 1;
			while STR1[Pont]<>FieldByName('Conta_Contabil') do begin
				Pont := Pont+1;
			end;

			 {? On Error Resume Next  }

			frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+STR[Pont]+StringOfChar(' ', 38-Length(STR[Pont]))+STR1[Pont]+StringOfChar(' ', 16-Length(STR2[Pont]))+STR2[Pont];

			// Space (16) ' Conta ????

			sSaldo := FormatVB(FieldByName('SaldoAnt').Value,'##,###,###,##0.00');
			frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+StringOfChar(' ', 18-Length(sSaldo))+sSaldo;

			sSaldo := FormatVB(FieldByName('Debito').Value,'##,###,###,##0.00');
			frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+StringOfChar(' ', 18-Length(sSaldo))+sSaldo;

			sSaldo := FormatVB(FieldByName('Credito').Value,'##,###,###,##0.00');
			frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+StringOfChar(' ', 18-Length(sSaldo))+sSaldo;

			sSaldo := FormatVB(FieldByName('SaldoAnt')+FieldByName('Credito')-FieldByName('Debito'),'##,###,###,##0.00');
			frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+StringOfChar(' ', 18-Length(sSaldo))+sSaldo+#10;

			Next;
		end;
	end;

	ReDim(STR, 0+1);
	ReDim(STR1, 0+1);
	ReDim(STR2, 0+1);

	Desconecta();
	PBar.Close();
	gArquivo11 := frmLog.RichTextBox1.Text;
	frmLog.Close();
	frmLog.WindowState := wsMaximized;
	frmLog.ShowModal();

end;

procedure TfMainForm.mnuSDiaClick(Sender: TObject);
var
	RsLocal: TADODataSet;
	Saldo: Double;
	sSaldo: String;
	dMovimento: TDateTime;
begin
	// Mostra os saldos atuais das contas
	gArquivo11 := '';

	if  not Conecta('') then Exit;

	LastAtualiza();

	sSql := 'select * from tb_opcao ';
	sSql := sSql+'order by conta_contabil ';
	RsDb := gBanco.OpenRecordset(sSql);

	RsLocal := gBanco.OpenRecordset(sSql);
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Saldo atualizado até: '+DateTimeToStr(gAtualizacao)+#10+StringOfChar(' ', 62)+'Último'+#10+StringOfChar(' ', 62)+'Movimento      '+'         Saldo'+#10+#10;

	PBar.Show();
	PBar.Label1.Visible := true;
	PBar.ProgressBar1.Visible := true;
	PBar.Label1.Caption := 'Gerando Saldos do Dia';

	with RsDb do begin
		while  not EOF do begin
			PBar.ProgressBar1.Position := RsDb.PercentPosition;
			Application.ProcessMessages();
			sSql := 'select sum( vl_saldo) from lancamentos where conta_contabil='#39'';
			sSql := sSql+String(RsDb.FieldByName('conta_contabil').Value)+''#39'';
			RsLocal := gBanco.OpenRecordset(sSql);
			 {? On Error Resume Next  }
			Saldo := 0;
			Saldo := RsLocal.Fields[0].Value;
			 {? On Error GoTo 0 }
			sSaldo := FormatVB(Saldo,'##,###,##0.00');
			frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+String(RsDb.FieldByName('conta_contabil').Value)+StringOfChar(' ', 17-sizeof(RsDb.FieldByName('conta_contabil').Value))+String(RsDb.FieldByName('opcao').Value);

			dMovimento := MaxData(String(RsDb.FieldByName('conta_contabil').Value));
			if  not IsDate(dMovimento) then begin
				dMovimento := StrToDateTime(StringOfChar(' ', 10));
			end;
			frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+StringOfChar(' ', 55-sizeof(RsDb.FieldByName('opcao').Value)-10)+DateTimeToStr(dMovimento)+StringOfChar(' ', 30-Length(sSaldo)-Length(DateTimeToStr(dMovimento)))+sSaldo+#10;

			Next;
		end;
	end;
	RsLocal.Close();
	RsLocal := nil;
	Desconecta();
	PBar.Close();
	gArquivo11 := frmLog.RichTextBox1.Text;
	frmLog.Close();
	frmLog.WindowState := wsMaximized;
	frmLog.ShowModal();
end;

//{$DEFINE defUse_mnuSobre_Click}
{$IF Defined(defUse_mnuSobre_Click)}
procedure TfrmMain.mnuSobre_Click();
begin
	frmAbout.ShowModal();
end;
{$IFEND} // defUse_mnuSobre_Click

procedure TfMainForm.mnuTCAlterarClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	if Length(gCliente)=0 then begin
		PedeAlteração.Caption := 'Inclui Conciliação';
		PedeAlteração.Label1.Caption := 'Nome do Cliente';
		gOpcao := '';
		PedeAlteração.ShowModal();
		if Trim(gOpcao)='' then begin
			Exit;
		 end  else  begin
			gCliente := gOpcao;
			gDataPath := GetPath()+'\'+gCliente+'\';
			gDataFile := gCliente+'.mdb';

			if Dir(String(gDataPath)+gDataFile)='' then begin
				ShowMessage('Cliente não Cadastrado');
				gCliente := '';
				Exit;
			end;
		end;
	end;

	if gCliente='' then begin
		gCliente := gOpcao;
		fMainForm.sbStatusBar.Panels.Items[1-1].Text := 'Cliente: '+gCliente;
	end;

	PedeAlteração.Caption := 'Altera Tipo de Conciliação';
	PedeAlteração.Label1.Caption := 'Conta Contábil';
	gOpcao := '';

	PedeAlteração.ShowModal();
	Screen.Cursor := crHourGlass;
	if gOpcao<>'' then begin
		if  not Conecta('adm') then Exit;

		sSql := 'select * from tb_tipo_con where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
		sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
		RsDb := gBanco.OpenRecordset(sSql);
		if RsDb.EOF then begin
			Application.MessageBox('Conciliação não Cadastrada', 'Seleção de Conciliação', MB_ICONSTOP);
			Desconecta();
			Screen.Cursor := crDefault;
			Exit;
		end;
		gTipo_Rec := 2;
		// TipoCon.Show
		TipoConAdm.Show();
	end;
	Screen.Cursor := crDefault;
end;
procedure TfMainForm.mnuTCExclClick(Sender: TObject);
label
	Saida;
var
	DbLocal: Database;
	RsLocal: TADODataSet;
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	if Length(gCliente)=0 then begin
		PedeAlteração.Caption := 'Exclui Conciliação';
		PedeAlteração.Label1.Caption := 'Nome do Cliente';
		gOpcao := '';
		PedeAlteração.ShowModal();
		if Trim(gOpcao)='' then begin
			Exit;
		 end  else  begin
			gCliente := gOpcao;
			gDataPath := GetPath()+'\'+gCliente+'\';
			gDataFile := gCliente+'.mdb';

			if Dir(String(gDataPath)+gDataFile)='' then begin
				ShowMessage('Cliente não Cadastrado');
				gCliente := '';
				Exit;
			end;
		end;
	end;
	PedeAlteração.Caption := 'Exclui Conciliação';
	PedeAlteração.Label1.Caption := 'Conta Contábil';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if gOpcao='' then begin
		Desconecta();
		Exit;
	end;
	if gOpcao<>'' then begin
		DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
		sSql := 'select * from tb_tipo_con where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
		sSql := sSql+' and cliente = '#39''+gCliente+''#39'';
		RsLocal := DbLocal.OpenRecordset(sSql);
		if RsLocal.EOF then begin
			Application.MessageBox('Conciliação não Cadastrada', 'Seleção de Conciliação', MB_ICONSTOP);
			RsLocal.Close();
			DbLocal.Close();
			RsLocal := nil;
			DbLocal := nil;
			Exit;
		end;
		if  not Conecta('') then begin
			RsLocal.Close();
			DbLocal.Close();
			RsLocal := nil;
			DbLocal := nil;
			Exit;
		end;
		sSql := '';
		sSql := sSql+'Select * from [lancamentos] ';
		sSql := sSql+' where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
		sSql := sSql+' and Vl_Saldo <> 0';
		RsDb := gBanco.OpenRecordset(sSql);
		if  not RsDb.EOF then begin
			ShowMessage('Conciliação tem lançamentos abertos. Não pode ser excluida');
			goto Saida;
		end;
		// sSql = ""
		// sSql = sSql & "Select * from [lancamentos] "
		// sSql = sSql & " where conta_contabil = '" & TiraPontos(gOpcao, 2) & "'"
		// Set RsDb = gBanco.OpenRecordset(sSql)
		// If RsDb.EOF Then
		// GoTo Saida
		// End If
		if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then begin
			// Deleta os lançamentos
			// sSql = ""
			// sSql = sSql & "Delete * from [lancamentos] "
			// sSql = sSql & " where conta_contabil = '" & TiraPontos(gOpcao, 2) & "'"
			// gBanco.Execute sSql
			// RsDb.Delete
			sSql := '';
			sSql := sSql+'Delete * from [tb_opcao] ';
			sSql := sSql+' where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
			gBanco.Execute(sSql);

			// Deleta de admin.tb_tipo_con
			RsLocal.Delete;

			sSql := '';
			// sSql = sSql & "Delete * from [tbcontas] "
			sSql := sSql+'Delete * from [tbcontasAdm] ';
			sSql := sSql+' where conta_contabil = '#39''+TiraPontos(gOpcao, IntToStr(2))+''#39'';
			// gBanco.Execute sSql
			DbLocal.Execute(sSql);
		 end  else  begin
			goto Saida;
		end;
	 end  else  begin
		Desconecta();
		Exit;
	end;
	// Deleta registro do Admin
Saida:
	RsLocal.Close();
	DbLocal.Close();
	RsLocal := nil;
	DbLocal := nil;
	Desconecta();
	Exit;
end;
procedure TfMainForm.mnuTCIncClick(Sender: TObject);
begin
	if  not Autoriza(cADM) then begin
		Exit;
	end;
	if Length(gCliente)=0 then begin
		PedeAlteração.Caption := 'Inclui Conciliação';
		PedeAlteração.Label1.Caption := 'Nome do Cliente';
		gOpcao := '';
		PedeAlteração.ShowModal();
		if Trim(gOpcao)='' then begin
			Exit;
		 end  else  begin
			gCliente := gOpcao;
			gDataPath := GetPath()+'\'+gCliente+'\';
			gDataFile := gCliente+'.mdb';

			if Dir(String(gDataPath)+gDataFile)='' then begin
				ShowMessage('Cliente não Cadastrado');
				gCliente := '';
				Exit;
			end;
		end;
	end;
	gTipo_Rec := 1;
	// TipoCon.Show
	TipoConAdm.Show();
end;
//{$DEFINE defUse_mnuTMAlt_Click}
{$IF Defined(defUse_mnuTMAlt_Click)}
procedure TfrmMain.mnuTMAlt_Click();
begin
	MoedaAlt.Show(1);
end;
{$IFEND} // defUse_mnuTMAlt_Click
//{$DEFINE defUse_mnuTMExcl_Click}
{$IF Defined(defUse_mnuTMExcl_Click)}
procedure TfrmMain.mnuTMExcl_Click();
begin
	PedeAlteração.Caption := 'Exclui Moeda';
	PedeAlteração.Label1.Caption := 'Código da Moeda';
	gOpcao := '';
	PedeAlteração.ShowModal();
	if Length(Trim(gOpcao))=3 then begin
		if  not Conecta('adm') then Exit;
		sSql := 'select * from tb_moeda where cd_moeda = '#39''+gOpcao+''#39'';
		RsDb := gBanco.OpenRecordset(sSql);
		if RsDb.EOF then begin
			Application.MessageBox('Dolar não Cadastrado', 'Moeda', MB_ICONSTOP);
			Desconecta();
			Exit;
		end;
		if Application.MessageBox('Confirma Exclusão do Registro Selecionado?', 'Excluir Registros', MB_YESNO)=IDYES then begin
			RsDb.Delete;
		end;
		Desconecta();
	 end  else  begin
		Application.MessageBox('Código de Moeda Inválido...', 'Moeda', MB_ICONSTOP);
	end;
end;
{$IFEND} // defUse_mnuTMExcl_Click
//{$DEFINE defUse_mnuTMInc_Click}
{$IF Defined(defUse_mnuTMInc_Click)}
procedure TfrmMain.mnuTMInc_Click();
begin
	Moeda.Show(1);
end;
{$IFEND} // defUse_mnuTMInc_Click
procedure TfMainForm.mnuTeste1Click(Sender: TObject);
begin
	// Gera_Resumo
	Gera_Resumo_2();
end;
procedure TfMainForm.mnuVarGerClick(Sender: TObject);
var
	DbLocal: Database;
	RsLocal: TADODataSet;
	Mes, Ano: String;
begin
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := FormatVB(Now(),'DD/MM/YYYY');
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
	// fMainForm.CrystalReport1.Action = 1
end;
procedure TfMainForm.mnuVarMesClick(Sender: TObject);
var
	DbLocal: Database;
	RsLocal: TADODataSet;
	Mes, Ano: String;
begin
	// Pedir Mês
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
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
	// fMainForm.CrystalReport1.Action = 1
end;
procedure TfMainForm.mnuVarPendClick(Sender: TObject);
var
	DbLocal: Database;
	RsLocal: TADODataSet;
	Mes, Ano: String;
begin
	// Pedir Mês
	if Length(gConciliacao)=0 then begin
		ShowMessage('Selecione Conciliação...');
		Exit;
	end;
	gData1 := '';
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
	// fMainForm.CrystalReport1.Action = 1
end;
procedure TfMainForm.BatimentoConta();
var
	ArqEntrada: Longint;
	ArqSaida, cont, Tam: Smallint;
	Inicio: TDateTime;
	Buffer, A, B: String;
	iFileLen, iPos, lCountLine: Longint;
	bFim: Boolean;
	DbLocal: Database;
begin
	gAdmPath := GetPath();
	gWork := DBEngine.Workspaces(0);
	gBanco := gWork.OpenDatabase(gAdmPath+'\CC_Temp1.mdb');

	ArqEntrada := 1{indifferently};
	AssignFile(FileHandle_ArqEntrada, NomeArquivo); Reset(FileHandle_ArqEntrada);

	sSql := 'delete  from JuntadoDC';
	gBanco.Execute(sSql);

	sSql := 'select * from JuntadoDC';
	RsDb := gBanco.OpenRecordset(sSql);

	Inicio := Now();
	iPos := 0;
	lCountLine := 0;
	iFileLen := FileLen(NomeArquivo);
	PegaPar();
	PBar.Caption := 'Fase 1 de 3 Cred';
	PBar.ProgressBar1.Visible := true;

	while  not Eof(FileHandle_ArqEntrada) do begin
		ReadLn(FileHandle_ArqEntrada, Buffer);
		// Tabela de Créditos
		if Length(Buffer)<20 then break;
		RsDb.Insert;
		VBtoADOFieldSet(RsDb, 'Texto', Buffer+'C');
		RsDb.UpdateRecord;

		iPos := iPos+Length(Buffer);
		lCountLine := lCountLine+1;
		// If lCountLine = 370 Then Exit Do
		if lCountLine mod 10=0 then begin
			PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
			Application.ProcessMessages();
		end;
	end;
	PBar.ProgressBar1.Position := 100;
	PBar.ProgressBar1.Visible := false;
	CloseFile(FileHandle_ArqEntrada);

	NomeArquivo := GetPath()+'\';
	NomeArquivo := NomeArquivo+gCliente+'\Bx_Banco_Deb\'+Trim(Concil.ContaContabil);
	NomeArquivo := NomeArquivo+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 4, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 1, 2);
	NomeArquivo := NomeArquivo+'.prn';

	AssignFile(FileHandle_ArqEntrada, NomeArquivo); Reset(FileHandle_ArqEntrada);

	Inicio := Now();
	iPos := 0;
	lCountLine := 0;
	iFileLen := FileLen(NomeArquivo);
	PegaPar();
	PBar.Caption := 'Fase 1 de 3 Deb';
	PBar.ProgressBar1.Visible := true;

	while  not Eof(FileHandle_ArqEntrada) do begin
		ReadLn(FileHandle_ArqEntrada, Buffer);
		// Tabela de Débitos
		if Length(Buffer)<20 then break;
		RsDb.Insert;
		VBtoADOFieldSet(RsDb, 'Texto', Buffer+'D');
		RsDb.UpdateRecord;

		iPos := iPos+Length(Buffer);
		lCountLine := lCountLine+1;
		if lCountLine mod 10=0 then begin
			PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
			Application.ProcessMessages();
		end;
	end;
	PBar.ProgressBar1.Position := 100;
	CloseFile(FileHandle_ArqEntrada);

	cont := 12;
	while cont>0 do begin
		sSql := 'select * from JuntadoDC order by Texto';
		RsDb := gBanco.OpenRecordset(sSql);

		PBar.Caption := 'Fase 2 de 3';

		PBar.ProgressBar1.Visible := true;
		Application.ProcessMessages();

		with RsDb do begin
			if  not EOF then Last;
			iFileLen := RecordCount;
			if  not EOF then First;
			lCountLine := 0;
			bFim := false;
			PBar.ProgressBar1.Position := 0;
			Tam := 60;
			A := Copy(FieldByName('Texto').Value, 1, Tam);
			B := RightStr(FieldByName('Texto').Value, 1);
			while  not EOF do begin

				Next;
				if EOF then break;
				if Copy(FieldByName('Texto').Value, 1, Tam)=A then begin
					// Verifica se é debito e credito
					if RightStr(FieldByName('Texto').Value, 1)<>B then begin
						// pendencia
						Prior;
						Delete;
						Next;
						lCountLine := lCountLine+1;
						if EOF then break;
						if  not EOF then begin
							Delete;
							Next;
							lCountLine := lCountLine+1;
						end;
						if EOF then break;
						A := Copy(FieldByName('Texto').Value, 1, Tam);
						B := RightStr(FieldByName('Texto').Value, 1);
					 end  else  begin
						A := Copy(FieldByName('Texto').Value, 1, Tam);
						B := RightStr(FieldByName('Texto').Value, 1);
					end;
				 end  else  begin
					A := Copy(FieldByName('Texto').Value, 1, Tam);
					B := RightStr(FieldByName('Texto').Value, 1);
				end;
				if lCountLine mod 10=0 then begin
					if lCountLine/iFileLen<1 then begin
						PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
					 end  else  begin
						PBar.ProgressBar1.Position := 100;
					end;
					Application.ProcessMessages();
				end;
				// lCountLine = lCountLine + 1
			end;

		end;
		cont := cont-1;
	end;



	DbLocal := gWork.OpenDatabase(gAdmPath+'\'+gCliente+'\'+gDataFile);

	sSql := 'select * from lancamentos where conta_contabil = '#39'999999'#39'';
	RsDb := DbLocal.OpenRecordset(sSql);



	sSql := 'select * from JuntadoDC ';
	sSql := sSql+' order by Texto';

	RsDb2 := gBanco.OpenRecordset(sSql);
	PBar.Caption := 'Fase 3 de 3';
	if  not RsDb2.EOF then RsDb2.Last;
	iFileLen := RsDb2.RecordCount;
	if  not RsDb2.EOF then RsDb2.First;
	lCountLine := 0;

	Buffer := 'Relatório de lançamentos abertos '+#10+#10;
	frmLog.RichTextBox1.Text := Buffer;
	Buffer := 'Cartão                                                  Valor'+#10;
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+Buffer;

	while  not RsDb2.EOF do begin
		Buffer := String(RsDb2.Fields[1].Value)+'   ';

		frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+Buffer+#10;
		// Grava registro no banco sem fazer nenhum teste
		GravaRec4(String(RsDb2.Fields[1].Value));

		RsDb2.Next;
		lCountLine := lCountLine+1;
		// If lCountLine Mod 10 = 0 Then
		if lCountLine/iFileLen<1 then begin
			PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
		 end  else  begin
			PBar.ProgressBar1.Position := 100;
		end;
		Application.ProcessMessages();
		// End If
	end;

	RsDb.Close();
	RsDb2.Close();
	gBanco.Close();
	// DbLocal.Close
	gWork.Close();

	RsDb := nil;
	RsDb2 := nil;
	gBanco := nil;
	DbLocal := nil;
	gWork := nil;

	// MsgBox "Registros Processados: " & Str(lCountLine) & Chr(10) & "Tempo de Leitura = " & Format(Now - Inicio, "hh:mm:ss")
	ShowMessage('Fim da Atualização...');
	PBar.ProgressBar1.Visible := false;
	PBar.Close();
end;
//{$DEFINE defUse_BatimentoConta2}
{$IF Defined(defUse_BatimentoConta2)}
procedure TfrmMain.BatimentoConta2();
var
	ArqEntrada: Longint;
	ArqSaida: Smallint;
	Inicio: TDateTime;
	Buffer: String;
	iFileLen, iPos, lCountLine: Longint;
	bFim: Boolean;
	DbLocal: Database;
begin
	gAdmPath := GetPath();
	gWork := DBEngine.Workspaces(0);
	gBanco := gWork.OpenDatabase(gAdmPath+'\CC_Temp1.mdb');

	ArqEntrada := 1{indifferently};
	AssignFile(FileHandle_ArqEntrada, NomeArquivo); Reset(FileHandle_ArqEntrada);

	sSql := 'delete  from Debito';
	gBanco.Execute(sSql);
	sSql := 'delete  from Credito';
	gBanco.Execute(sSql);

	sSql := 'select * from Debito';
	RsDb := gBanco.OpenRecordset(sSql);

	sSql := 'select * from Credito';
	RsDb2 := gBanco.OpenRecordset(sSql);

	Inicio := Now();
	iPos := 0;
	lCountLine := 0;
	iFileLen := FileLen(NomeArquivo);
	PegaPar();
	PBar.Caption := 'Fase 1 de 3';
	PBar.ProgressBar1.Visible := true;

	while  not Eof(FileHandle_ArqEntrada) do begin
		ReadLn(FileHandle_ArqEntrada, Buffer);
		// Tabela de Créditos
		if Length(Buffer)<20 then break;
		RsDb2.Insert;
		// RsDb2.Fields("Cartao") = Mid$(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho)
		// RsDb2.Fields("Credito") = Mid$(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho)
		VBtoADOFieldSet(RsDb2, 'Texto', Buffer);
		RsDb2.UpdateRecord;

		iPos := iPos+Length(Buffer);
		lCountLine := lCountLine+1;
		// If lCountLine = 370 Then Exit Do
		if lCountLine mod 10=0 then begin
			PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
			Application.ProcessMessages();
		end;
	end;
	PBar.ProgressBar1.Position := 100;
	PBar.ProgressBar1.Visible := false;
	CloseFile(FileHandle_ArqEntrada);

	NomeArquivo := GetPath()+'\';
	NomeArquivo := NomeArquivo+gCliente+'\Bx_Banco_Deb\'+Trim(Concil.ContaContabil);
	NomeArquivo := NomeArquivo+'_20'+Copy(gDataRelatorio, 7, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 4, 2);
	NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 1, 2);
	NomeArquivo := NomeArquivo+'.prn';

	AssignFile(FileHandle_ArqEntrada, NomeArquivo); Reset(FileHandle_ArqEntrada);

	Inicio := Now();
	iPos := 0;
	lCountLine := 0;
	iFileLen := FileLen(NomeArquivo);
	PegaPar();
	PBar.Caption := 'Fase 1 de 3';
	PBar.ProgressBar1.Visible := true;

	while  not Eof(FileHandle_ArqEntrada) do begin
		ReadLn(FileHandle_ArqEntrada, Buffer);
		// Tabela de Débitos
		if Length(Buffer)<20 then break;
		RsDb.Insert;
		// RsDb.Fields("Cartao") = Mid$(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho)
		// RsDb.Fields("Debito") = Mid$(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho)
		VBtoADOFieldSet(RsDb, 'Texto', Buffer);
		RsDb.UpdateRecord;

		iPos := iPos+Length(Buffer);
		lCountLine := lCountLine+1;
		// If lCountLine = 370 Then Exit Do
		if lCountLine mod 10=0 then begin
			PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
			Application.ProcessMessages();
		end;
	end;
	PBar.ProgressBar1.Position := 100;
	// PBar.ProgressBar1.Visible = False
	CloseFile(FileHandle_ArqEntrada);

	sSql := 'select * from Debito order by Texto';
	RsDb := gBanco.OpenRecordset(sSql);

	sSql := 'select * from Credito order by Texto';
	RsDb2 := gBanco.OpenRecordset(sSql);

	PBar.Caption := 'Fase 2 de 3';

	PBar.ProgressBar1.Visible := true;
	Application.ProcessMessages();

	with RsDb2 do begin
		if  not EOF then Last;
		iFileLen := RecordCount;
		if  not EOF then First;
		lCountLine := 0;
		bFim := false;
		PBar.ProgressBar1.Position := 0;
		while  not EOF and  not bFim do begin
			if RsDb.EOF then begin
				break;
			 end  else  begin
				RsDb.First;
			end;

			// If Left(.Fields("Cartao"), 13) = Left(RsDb.Fields("Cartao"), 13) Then
			// If (.Fields("Credito")) = RsDb.Fields("Debito") Then
			// .Edit
			// .Fields("Debito") = RsDb.Fields("Debito")
			// .Update
			// RsDb.Delete
			// If RsDb.EOF Then
			// bFim = True
			// Else
			// RsDb.MoveFirst
			// End If
			// Else
			// Do While Left(.Fields("Cartao"), 13) = Left(RsDb.Fields("Cartao"), 13)
			// RsDb.MoveNext
			// If Not RsDb.EOF Then
			// If (.Fields("Credito")) = RsDb.Fields("Debito") Then
			// .Edit
			// .Fields("Debito") = RsDb.Fields("Debito")
			// .Update
			// RsDb.Delete
			// If RsDb.EOF Then
			// bFim = True
			// Else
			// RsDb.MoveFirst
			// End If
			// Exit Do
			// End If
			// Else
			// Exit Do
			// End If
			// Loop
			// End If
			// Else
			// If Left(.Fields("Cartao"), 13) > Left(RsDb.Fields("Cartao"), 13) Then
			// Do While Left(.Fields("Cartao"), 13) > Left(RsDb.Fields("Cartao"), 13)
			// .AddNew
			// .Fields("Cartao") = RsDb.Fields("Cartao")
			// .Fields("Debito") = RsDb.Fields("Debito")
			// .Fields("Texto") = RsDb.Fields("Texto")
			// .Update
			// RsDb.Delete
			// If RsDb.EOF Then
			// bFim = True
			// Else
			// RsDb.MoveFirst
			// End If
			// If RsDb.EOF Then Exit Do
			// Loop
			// End If
			// If Not RsDb.EOF Then
			// If Left(.Fields("Cartao"), 13) = Left(RsDb.Fields("Cartao"), 13) Then
			// If (.Fields("Credito")) = RsDb.Fields("Debito") Then
			// .Edit
			// .Fields("Debito") = RsDb.Fields("Debito")
			// .Update
			// RsDb.Delete
			// If RsDb.EOF Then
			// bFim = True
			// Else
			// RsDb.MoveFirst
			// End If
			// End If
			// End If
			// End If
			// End If

			// Compara linha com cartao e valor das tabelas debito e credito
			// Deleta os que baterem da tabela debito e credito
			// 

			if FieldByName('Texto')=RsDb.FieldByName('Texto') then begin
				RsDb.Delete;
				Delete;
				if RsDb.EOF then begin
					bFim := true;
				 end  else  begin
					RsDb.First;
				end;
			 end  else  begin
				bFim := false;
				RsDb.Next;
				while  not EOF and  not RsDb.EOF and  not bFim do begin
					if FieldByName('Texto')=RsDb.FieldByName('Texto') then begin
						RsDb.Delete;
						Delete;
						if RsDb.EOF then begin
							bFim := true;
						 end  else  begin
							RsDb.First;
						end;
					 end  else  begin
						if LeftStr(FieldByName('Texto').Value, 16)>LeftStr(RsDb.FieldByName('Texto').Value, 16) then begin
							RsDb.First;
							bFim := true;
						end;
					end;
					RsDb.Next;
				end;
			end;

			if lCountLine mod 10=0 then begin
				if lCountLine/iFileLen<1 then begin
					PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
				 end  else  begin
					PBar.ProgressBar1.Position := 100;
				end;
				Application.ProcessMessages();
			end;
			Next;
			lCountLine := lCountLine+1;
			bFim := false;
		end;

		while  not RsDb.EOF do begin
			Insert;
			VBtoADOFieldSet(RsDb2, 'Cartao', RsDb.FieldByName('Cartao').Value);
			VBtoADOFieldSet(RsDb2, 'Debito', RsDb.FieldByName('Debito').Value);
			VBtoADOFieldSet(RsDb2, 'Texto', RsDb.FieldByName('Texto').Value);
			UpdateRecord;
			RsDb.Delete;
			RsDb.First;
		end;
	end;

	// Set DbLocal = gWork.OpenDatabase(gAdmPath & "\real\real.mdb")

	// Fase 3 3liminada, gerar relatorio com os lançamentos SACI

	// Set DbLocal = gWork.OpenDatabase(gAdmPath & "\" & gCliente & "\" & gDataFile)

	// sSql = "select * from lancamentos where conta_contabil = '999999'"
	// Set RsDb = DbLocal.OpenRecordset(sSql)

	// sSql = "select * from Credito order by Cartao"
	// Set RsDb2 = gBanco.OpenRecordset(sSql)
	// RsDb2.MoveLast
	// iFileLen = RsDb2.RecordCount
	// lCountLine = 0
	// RsDb2.MoveFirst
	// PBar.Caption = "Fase 3 de 3"
	// PBar.ProgressBar1.Visible = True
	// Do While Not RsDb2.EOF
	// GravaRec3 RsDb2.Fields("Texto"), RsDb2.Fields("Debito"), RsDb2.Fields("Credito")
	// RsDb2.MoveNext
	// If lCountLine Mod 10 = 0 Then
	// PBar.ProgressBar1.Value = (lCountLine / iFileLen) * 100
	// DoEvents
	// End If
	// lCountLine = lCountLine + 1
	// Loop
	// PBar.ProgressBar1.Value = 100

	sSql := 'select * from Credito ';
	sSql := sSql+' where debito <= 0 or credito <= 0';
	sSql := sSql+' order by Cartao';

	RsDb2 := gBanco.OpenRecordset(sSql);

	Buffer := 'Relatório de lançamentos abertos '+#10+#10;
	frmLog.RichTextBox1.Text := Buffer;
	Buffer := 'Cartão                      Débito           Crédito '+#10;
	frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+Buffer;

	while  not RsDb2.EOF do begin
		Buffer := String(RsDb2.Fields[1].Value)+'   ';
		sSql := FormatVB(RsDb2.Fields[3].Value,'###,##0.00');
		Buffer := Buffer+StringOfChar(' ', 15-Length(sSql))+sSql+'   ';
		sSql := FormatVB(RsDb2.Fields[2].Value,'###,##0.00');
		Buffer := Buffer+StringOfChar(' ', 15-Length(sSql))+sSql+'   ';

		frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+Buffer+#10;
		RsDb2.Next;
	end;

	RsDb.Close();
	RsDb2.Close();
	gBanco.Close();
	// DbLocal.Close
	gWork.Close();

	RsDb := nil;
	RsDb2 := nil;
	gBanco := nil;
	DbLocal := nil;
	gWork := nil;

	// MsgBox "Registros Processados: " & Str(lCountLine) & Chr(10) & "Tempo de Leitura = " & Format(Now - Inicio, "hh:mm:ss")
	ShowMessage('Fim da Atualização...');
	PBar.ProgressBar1.Visible := false;
	PBar.Close();
end;
{$IFEND} // defUse_BatimentoConta2
//{$DEFINE defUse_GravaRecX}
{$IF Defined(defUse_GravaRecX)}
procedure TfrmMain.GravaRecX(Buf: String; sDebito: OleVariant; sCredito: OleVariant);
var
	sCartao, sMoeda, sValor, sData: String;
begin
	sCartao := Copy(Buf, Param.Cartao.Posicao, Param.Cartao.Tamanho);
	sMoeda := Copy(Buf, Param.Moeda.Posicao, Param.Moeda.Tamanho);
	sValor := Copy(Buf, Param.Valor.Posicao, Param.Valor.Tamanho);
	sData := Copy(Buf, Param.Data.Posicao, Param.Data.Tamanho);

	RsDb.Insert;
	VBtoADOFieldSet(RsDb, 'cliente', gCliente);
	if CDbl(sCredito)<>0 then VBtoADOFieldSet(RsDb, 'Data_Credito', CDate(sData));
	if CDbl(sDebito)<>0 then VBtoADOFieldSet(RsDb, 'Data_Debito', CDate(sData));
	VBtoADOFieldSet(RsDb, 'Cartao', sCartao);
	VBtoADOFieldSet(RsDb, 'Cartao1', Copy(sCartao, 1, 13));

	if (sMoeda='986') or (sMoeda='000') then begin
		VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', FormataValor(String(sCredito)));
		VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', FormataValor(String(sDebito)));
	 end  else  begin
		VBtoADOFieldSet(RsDb, 'Vl_CreditoDolar', FormataValor(String(sCredito)));
		if RsDb.FieldByName('Vl_CreditoDolar')>0 then VBtoADOFieldSet(RsDb, 'Taxa_Credito', CDbl(gTaxa));
		VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', FormataValor(FloatToStr(RoundTo(CDbl(sCredito)*CDbl(gTaxa), -2))));

		VBtoADOFieldSet(RsDb, 'Vl_DebitoDolar', FormataValor(String(sDebito)));
		if RsDb.FieldByName('Vl_DebitoDolar')>0 then VBtoADOFieldSet(RsDb, 'Taxa_Debito', RsDb.FieldByName('Taxa_Credito').Value);
		VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', FormataValor(FloatToStr(RoundTo(CDbl(sDebito)*CDbl(gTaxa), -2))));
	end;
	VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal')-RsDb.FieldByName('Vl_CreditoReal'));
	VBtoADOFieldSet(RsDb, 'conta_contabil', Trim(Concil.ContaContabil));

	gTotDebito := gTotDebito+RsDb.FieldByName('Vl_DebitoReal');
	gTotCredito := gTotCredito+RsDb.FieldByName('Vl_CreditoReal');

	RsDb.UpdateRecord;

end;
{$IFEND} // defUse_GravaRecX
procedure TfMainForm.ContasResultado();
var
	ArqEntrada: Longint;
	ArqSaida: Smallint;
	Inicio: TDateTime;
	Buffer: String;
	iFileLen, iPos, lCountLine: Longint;
	bFim: Boolean;
	DbLocal: Database;
begin
	gAdmPath := GetPath();
	gWork := DBEngine.Workspaces(0);
	gBanco := gWork.OpenDatabase(gAdmPath+'\CC_Temp1.mdb');

	ArqEntrada := 1{indifferently};
	AssignFile(FileHandle_ArqEntrada, NomeArquivo); Reset(FileHandle_ArqEntrada);

	sSql := 'delete  from Debito';
	gBanco.Execute(sSql);
	sSql := 'delete  from Credito';
	gBanco.Execute(sSql);

	sSql := 'select * from Debito';
	RsDb := gBanco.OpenRecordset(sSql);

	sSql := 'select * from Credito';
	RsDb2 := gBanco.OpenRecordset(sSql);

	Inicio := Now();
	iPos := 0;
	lCountLine := 0;
	iFileLen := FileLen(NomeArquivo);
	PegaPar();
	PBar.Caption := 'Fase 1 de 3';
	PBar.ProgressBar1.Visible := true;

	while  not Eof(FileHandle_ArqEntrada) do begin
		ReadLn(FileHandle_ArqEntrada, Buffer);
		if RightStr(Buffer, 1)='D' then begin
			// Tabela de Débitos
			RsDb.Insert;
			VBtoADOFieldSet(RsDb, 'Cartao', Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho));
			VBtoADOFieldSet(RsDb, 'Debito', Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
			VBtoADOFieldSet(RsDb, 'Texto', Buffer);
			RsDb.UpdateRecord;
		 end  else  begin
			// Tabela de Créditos
			RsDb2.Insert;
			VBtoADOFieldSet(RsDb2, 'Cartao', Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho));
			VBtoADOFieldSet(RsDb2, 'Credito', Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
			VBtoADOFieldSet(RsDb2, 'Texto', Buffer);
			RsDb2.UpdateRecord;
		end;
		iPos := iPos+Length(Buffer);
		lCountLine := lCountLine+1;
		// If lCountLine = 370 Then Exit Do
		if lCountLine mod 100=0 then begin
			PBar.ProgressBar1.Position := Round((iPos/iFileLen)*100);
			Application.ProcessMessages();
		end;
	end;
	PBar.ProgressBar1.Position := 100;
	PBar.ProgressBar1.Visible := false;
	CloseFile(FileHandle_ArqEntrada);

	sSql := 'select * from Debito order by Cartao';
	RsDb := gBanco.OpenRecordset(sSql);

	sSql := 'select * from Credito order by Cartao';
	RsDb2 := gBanco.OpenRecordset(sSql);

	PBar.Caption := 'Fase 2 de 3';

	PBar.ProgressBar1.Visible := true;
	with RsDb2 do begin
		if  not EOF then Last;
		iFileLen := RecordCount;
		if  not EOF then First;
		lCountLine := 0;
		bFim := false;
		PBar.ProgressBar1.Position := 0;
		while  not EOF and  not bFim do begin
			if RsDb.EOF then begin
				break;
			 end  else  begin
				RsDb.First;
			end;
			if LeftStr(FieldByName('Cartao').Value, 13)=LeftStr(RsDb.FieldByName('Cartao').Value, 13) then begin
				if (FieldByName('Credito'))=RsDb.FieldByName('Debito') then begin
					Edit();
					VBtoADOFieldSet(RsDb2, 'Debito', RsDb.FieldByName('Debito').Value);
					UpdateRecord;
					RsDb.Delete;
					if RsDb.EOF then begin
						bFim := true;
					 end  else  begin
						RsDb.First;
					end;
				 end  else  begin
					while LeftStr(FieldByName('Cartao').Value, 13)=LeftStr(RsDb.FieldByName('Cartao').Value, 13) do begin
						RsDb.Next;
						if (FieldByName('Credito'))=RsDb.FieldByName('Debito') then begin
							Edit();
							VBtoADOFieldSet(RsDb2, 'Debito', RsDb.FieldByName('Debito').Value);
							UpdateRecord;
							RsDb.Delete;
							if RsDb.EOF then begin
								bFim := true;
							 end  else  begin
								RsDb.First;
							end;
							break;
						end;
					end;
				end;
			 end  else  begin
				if LeftStr(FieldByName('Cartao').Value, 13)>LeftStr(RsDb.FieldByName('Cartao').Value, 13) then begin
					while LeftStr(FieldByName('Cartao').Value, 13)>LeftStr(RsDb.FieldByName('Cartao').Value, 13) do begin
						Insert;
						VBtoADOFieldSet(RsDb2, 'Cartao', RsDb.FieldByName('Cartao').Value);
						VBtoADOFieldSet(RsDb2, 'Debito', RsDb.FieldByName('Debito').Value);
						VBtoADOFieldSet(RsDb2, 'Texto', RsDb.FieldByName('Texto').Value);
						UpdateRecord;
						RsDb.Delete;
						if RsDb.EOF then begin
							bFim := true;
						 end  else  begin
							RsDb.First;
						end;
						if RsDb.EOF then break;
					end;
				end;
				if  not RsDb.EOF then begin
					if LeftStr(FieldByName('Cartao').Value, 13)=LeftStr(RsDb.FieldByName('Cartao').Value, 13) then begin
						if (FieldByName('Credito'))=RsDb.FieldByName('Debito') then begin
							Edit();
							VBtoADOFieldSet(RsDb2, 'Debito', RsDb.FieldByName('Debito').Value);
							UpdateRecord;
							RsDb.Delete;
							if RsDb.EOF then begin
								bFim := true;
							 end  else  begin
								RsDb.First;
							end;
						end;
					end;
				end;
			end;
			if lCountLine mod 100=0 then begin
				if lCountLine/iFileLen<1 then begin
					PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
				 end  else  begin
					PBar.ProgressBar1.Position := 100;
				end;
				Application.ProcessMessages();
			end;
			Next;
			lCountLine := lCountLine+1;
		end;
		while  not RsDb.EOF do begin
			Insert;
			VBtoADOFieldSet(RsDb2, 'Cartao', RsDb.FieldByName('Cartao').Value);
			VBtoADOFieldSet(RsDb2, 'Debito', RsDb.FieldByName('Debito').Value);
			VBtoADOFieldSet(RsDb2, 'Texto', RsDb.FieldByName('Texto').Value);
			UpdateRecord;
			RsDb.Delete;
			RsDb.First;
		end;
	end;

	// Set DbLocal = gWork.OpenDatabase(gAdmPath & "\real\real.mdb")

	DbLocal := gWork.OpenDatabase(gAdmPath+'\'+gCliente+'\'+gDataFile);

	sSql := 'select * from lancamentos where conta_contabil = '#39'999999'#39'';
	RsDb := DbLocal.OpenRecordset(sSql);

	sSql := 'select * from Credito order by Cartao';
	RsDb2 := gBanco.OpenRecordset(sSql);
	RsDb2.Last;
	iFileLen := RsDb2.RecordCount;
	lCountLine := 0;
	RsDb2.First;
	PBar.Caption := 'Fase 3 de 3';
	PBar.ProgressBar1.Visible := true;
	while  not RsDb2.EOF do begin
		GravaRec3(String(RsDb2.FieldByName('Texto').Value), RsDb2.FieldByName('Debito'), RsDb2.FieldByName('Credito'));
		RsDb2.Next;
		if lCountLine mod 100=0 then begin
			PBar.ProgressBar1.Position := Round((lCountLine/iFileLen)*100);
			Application.ProcessMessages();
		end;
		lCountLine := lCountLine+1;
	end;
	PBar.ProgressBar1.Position := 100;

	RsDb.Close();
	RsDb2.Close();
	gBanco.Close();
	DbLocal.Close();
	gWork.Close();

	RsDb := nil;
	RsDb2 := nil;
	gBanco := nil;
	DbLocal := nil;
	gWork := nil;
	// MsgBox "Registros Processados: " & Str(lCountLine) & Chr(10) & "Tempo de Leitura = " & Format(Now - Inicio, "hh:mm:ss")
	ShowMessage('Fim da Atualização...');
	PBar.ProgressBar1.Visible := false;
	PBar.Close();
end;
// VBto upgrade warning: Buf As String	OnWrite(TField)
// VBto upgrade warning: sDebito As OleVariant --> As TField
// VBto upgrade warning: sCredito As OleVariant --> As TField
procedure TfMainForm.GravaRec3(Buf: String; sDebito: TField; sCredito: TField);
var
	sCartao, sMoeda, sValor, sData: String;
begin
	sCartao := Copy(Buf, Param.Cartao.Posicao, Param.Cartao.Tamanho);
	sMoeda := Copy(Buf, Param.Moeda.Posicao, Param.Moeda.Tamanho);
	sValor := Copy(Buf, Param.Valor.Posicao, Param.Valor.Tamanho);
	sData := Copy(Buf, Param.Data.Posicao, Param.Data.Tamanho);

	RsDb.Insert;
	VBtoADOFieldSet(RsDb, 'cliente', gCliente);
	if CDbl(sCredito)<>0 then VBtoADOFieldSet(RsDb, 'Data_Credito', CDate(sData));
	if CDbl(sDebito)<>0 then VBtoADOFieldSet(RsDb, 'Data_Debito', CDate(sData));
	VBtoADOFieldSet(RsDb, 'Cartao', sCartao);
	VBtoADOFieldSet(RsDb, 'Cartao1', Copy(sCartao, 1, 13));

	if (sMoeda='986') or (sMoeda='000') then begin
		VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', FormataValor(String(sCredito.Value)));
		VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', FormataValor(String(sDebito.Value)));
	 end  else  begin
		VBtoADOFieldSet(RsDb, 'Vl_CreditoDolar', FormataValor(String(sCredito.Value)));
		if RsDb.FieldByName('Vl_CreditoDolar')>0 then VBtoADOFieldSet(RsDb, 'Taxa_Credito', CDbl(gTaxa));
		VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', FormataValor(FloatToStr(RoundTo(CDbl(sCredito)*CDbl(gTaxa), -2))));

		VBtoADOFieldSet(RsDb, 'Vl_DebitoDolar', FormataValor(String(sDebito.Value)));
		if RsDb.FieldByName('Vl_DebitoDolar')>0 then VBtoADOFieldSet(RsDb, 'Taxa_Debito', RsDb.FieldByName('Taxa_Credito').Value);
		VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', FormataValor(FloatToStr(RoundTo(CDbl(sDebito)*CDbl(gTaxa), -2))));
	end;
	VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal')-RsDb.FieldByName('Vl_CreditoReal'));
	VBtoADOFieldSet(RsDb, 'conta_contabil', Trim(Concil.ContaContabil));

	gTotDebito := gTotDebito+RsDb.FieldByName('Vl_DebitoReal');
	gTotCredito := gTotCredito+RsDb.FieldByName('Vl_CreditoReal');

	RsDb.UpdateRecord;

end;
//{$DEFINE defUse_TestaRec4}
{$IF Defined(defUse_TestaRec4)}
function TfrmMain.TestaRec4(Buffer: String): Boolean;
var
	iLenBuf: Longint;
	sCartao, sValor: String;
begin
	// Não esta sendo utilizado
	// 27/01/09

	iLenBuf := Length(Buffer);
	sCartao := Copy(Buffer, 1, 16);
	sValor := Copy(Buffer, iLenBuf-14, 14);

	if RightStr(Buffer, 1)='D' then begin
		sSql := 'select cartao, Vl_Debito from lancamentos ';
		sSql := sSql+'where cartao = '#39''+sCartao+''#39'';
		sSql := sSql+'and  Vl_Debito = '+sValor+''#39'';
	 end  else  begin
		sSql := 'select cartao, Vl_Credito from lancamentos ';
		sSql := sSql+'where cartao = '#39''+sCartao+''#39'';
		sSql := sSql+'and  Vl_Credito = '+sValor+''#39'';
	end;

	RsDb := gBanco.OpenRecordset(sSql);

	Result := RsDb.EOF;

end;
{$IFEND} // defUse_TestaRec4
// VBto upgrade warning: Buffer As String	OnWrite(TField)
procedure TfMainForm.GravaRec4(Buffer: String);
var
	sCartao, sValor, sDebito, sCredito, sMoeda, sData: String;
	iLenBuf: Longint;
begin
	iLenBuf := Length(Buffer);
	sCartao := Copy(Buffer, 1, 16);
	sValor := Copy(Buffer, iLenBuf-14, 14);
	sData := gDataRelatorio;
	sMoeda := '986';
	RsDb.Insert;
	if RightStr(Buffer, 1)='D' then begin
		if CDbl(sValor)<>0 then VBtoADOFieldSet(RsDb, 'Data_Debito', CDate(sData));
		VBtoADOFieldSet(RsDb, 'Vl_DebitoReal', FormataValor(sValor));
	 end  else  begin
		if CDbl(sValor)<>0 then VBtoADOFieldSet(RsDb, 'Data_Credito', CDate(sData));
		VBtoADOFieldSet(RsDb, 'Vl_CreditoReal', FormataValor(sValor));
	end;
	VBtoADOFieldSet(RsDb, 'cliente', gCliente);
	VBtoADOFieldSet(RsDb, 'Cartao', sCartao);
	VBtoADOFieldSet(RsDb, 'Cartao1', Copy(sCartao, 1, 13));

	VBtoADOFieldSet(RsDb, 'Vl_Saldo', RsDb.FieldByName('Vl_DebitoReal')-RsDb.FieldByName('Vl_CreditoReal'));
	VBtoADOFieldSet(RsDb, 'conta_contabil', Trim(Concil.ContaContabil));

	gTotDebito := gTotDebito+RsDb.FieldByName('Vl_DebitoReal');
	gTotCredito := gTotCredito+RsDb.FieldByName('Vl_CreditoReal');

	RsDb.UpdateRecord;

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



end.
