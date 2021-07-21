unit ConsultaCon_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, DBCtrls, DB, ADODB,
  Vcl.Grids, Vcl.DBGrids;


type
  TConsultaCon = class(TForm)
    cmdSair:	TButton;
    Data1:	TDBNavigator;
    Data1_DataSource:	TDataSource;
    Data1_DataSet:	TADODataSet;
    cmdRelatorio:	TButton;
    Frame1:	TGroupBox;
    optDecres:	TRadioButton;
    cmbOrdena:	TComboBox;
    optCres:	TRadioButton;
    DbGrid: TDBGrid;

    procedure cmbOrdenaClick(Sender: TObject);
    procedure cmbOrdena_Click();
    procedure cmdRelatorioClick(Sender: TObject);
    procedure cmdSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure optCresClick(Sender: TObject);
    procedure optDecresClick(Sender: TObject);
    //procedure AtualizaGrid(Msg: Boolean);
    procedure Titulos();
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
	lOrdenAtual: Smallint;

    //procedure DbGrid_Click();
    procedure MontaCombo();
    procedure Form_Unload(var Cancel: Smallint);
    //procedure Option1_Click();

  public
    { Public declarations }
  end;

var
  ConsultaCon: TConsultaCon;

implementation

uses  Dialogs, SysUtils, Module1, frmMain_, RotGerais, VBto_Converter;

{$R *.dfm}

 //=========================================================
procedure TConsultaCon.cmbOrdenaClick(Sender: TObject);
begin
	{case cmbOrdena.ItemIndex of                       REVISAR
		0: begin
			DbGrid.Col := 1;
			DbGrid.Sort := lOrdenAtual;
		end;
		1: begin
			DbGrid.Col := 2;
			DbGrid.Sort := lOrdenAtual;
		end;
		2: begin
			DbGrid.Col := 3;
			DbGrid.Sort := lOrdenAtual;
		end;
	end; }
end;

procedure TConsultaCon.cmbOrdena_Click();
begin
	cmbOrdenaClick(cmbOrdena);
end;

procedure TConsultaCon.cmdRelatorioClick(Sender: TObject);
var
	Ordem: String;
begin
(*	fMainForm.CrystalReport1.SortFields(0) := '';
	
	if gOrdemGrid=' order by Observacao' then begin
		fMainForm.CrystalReport1.SortFields(0) := '+{Conciliacoes.Observacao}';
	end
	else if gOrdemGrid=' order by Relatorio_Origem' then begin
		fMainForm.CrystalReport1.SortFields(0) := '+{Conciliacoes.Relatorio_Origem}';
	end
	else if gOrdemGrid=' order by template' then begin
		fMainForm.CrystalReport1.SortFields(0) := '+{Conciliacoes.Template}';
	end
	else if gOrdemGrid=' order by Cliente' then begin
		fMainForm.CrystalReport1.SortFields(0) := '+{Conciliacoes.Cliente}';
	end
	else if gOrdemGrid=' order by conta_contabil' then begin
		fMainForm.CrystalReport1.SortFields(0) := '+{Conciliacoes.conta_contabil}';
	end
	else if gOrdemGrid=' order by codigo' then begin
		fMainForm.CrystalReport1.SortFields(0) := '+{Conciliacoes.Codigo}';
	end;

	fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
	fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\teste.rpt';
	fMainForm.CrystalReport1.WindowState := crptMaximized;
	Result := fMainForm.CrystalReport1.PrintReport;
	if Result<>0 then begin
		ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
	end;          *)

end;

procedure TConsultaCon.cmdSairClick(Sender: TObject);
begin
	Close();
end;

//{$DEFINE defUse_DbGrid_Click}
{$IF Defined(defUse_DbGrid_Click)}
procedure TConsultaCon.DbGrid_Click();
begin
	sSql := DbGrid.ColSel;
	// DbGrid.Sort = True
end;
{$IFEND} // defUse_DbGrid_Click

procedure TConsultaCon.FormShow(Sender: TObject);
Var
  gBanco : TAdoConnection;
begin
	// Ordem básica crescente
	Self.optCres.Checked := true;
	Self.optDecres.Checked := false;
	lOrdenAtual := 1;

	Screen.Cursor := crHourGlass;
	// Monta Tabela Temporária
	if  not MontaTabela then
    begin
		ShowMessage('Erro no Banco de Dados');
		Screen.Cursor := crDefault;
		Exit;
	  end;

//	gBanco := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl');

//	DbGrid.FormatString := '0.00';                      Rever

	Screen.Cursor := crHourGlass;
	gOrdemGrid := ' order by Cliente';
	//DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;

//	Data1.DatabaseName := gAdmPath+'\admin.mdb';
  Data1_DataSet.Connection := gBanco;
	sSql := 'Select * from conciliacoes';
	Data1_DataSet.CommandText := sSql;
	Data1_DataSet.Close;
  Data1_DataSet.Open;
//	DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
	Self.Left := 0;
	Self.Top := 0;
	Self.Width := 12000;
	Self.Height := 7600;

	CenterForm(Self);

	// DbGrid.Sort = True
{	DbGrid.ColWidth(0) := 100;
	DbGrid.ColWidth(1) := 1500; // cliente
	DbGrid.ColWidth(2) := 800; // cc
	DbGrid.ColWidth(3) := 2400; // codigo
	DbGrid.ColWidth(4) := 2400; // codigo2
	DbGrid.ColWidth(5) := 500; // Hist R$
	DbGrid.ColWidth(6) := 500; // Hist US$
	DbGrid.ColWidth(7) := 500;
	DbGrid.ColWidth(8) := 1000; // Bandeira
	DbGrid.ColWidth(9) := 2000;
	DbGrid.ColWidth(10) := 2000;
	DbGrid.ColWidth(11) := 2000;
	DbGrid.ColWidth(12) := 2000;
	DbGrid.ColWidth(13) := 500;
	DbGrid.ColWidth(14) := 500;
	DbGrid.ColWidth(15) := 0;
	DbGrid.ColWidth(16) := 0;   }

	Titulos;
	MontaCombo;
//	DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
	Screen.Cursor := crDefault;
  gBanco.Close;
  gBanco.Free;
end;

procedure TConsultaCon.MontaCombo();
begin
	with cmbOrdena do begin
		Clear();
		AddItem('Cliente',nil);
		AddItem('Conta',nil);
		AddItem('Código',nil);
	end;
end;
procedure TConsultaCon.Form_Unload(var Cancel: Smallint);
begin
//	Desconecta();
  Data1_DataSet.Close;
	Data1_DataSet.CommandText := '';
end;

procedure TConsultaCon.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

//{$DEFINE defUse_Option1_Click}
{$IF Defined(defUse_Option1_Click)}
procedure TConsultaCon.Option1_Click();
begin
 //empty ;-)

end;
{$IFEND} // defUse_Option1_Click

procedure TConsultaCon.optCresClick(Sender: TObject);
begin
	if Self.optCres.Checked=true then begin
		Self.optDecres.Checked := false;
		lOrdenAtual := 1;
		if cmbOrdena.ItemIndex>=0 then begin
			cmbOrdena_Click();
		end;

	end;
end;

procedure TConsultaCon.optDecresClick(Sender: TObject);
begin
	if Self.optDecres.Checked=true then begin
		Self.optCres.Checked := false;
		lOrdenAtual := 2;
		if cmbOrdena.ItemIndex>=0 then begin
			cmbOrdena_Click();
		end;

	end;
end;

//{$DEFINE defUse_AtualizaGrid}
{$IF Defined(defUse_AtualizaGrid)}
procedure TConsultaCon.AtualizaGrid(Msg: Boolean);
begin
//	DbGrid.Redraw := false;
  DbGrid.DataSource.DataSet.DisableControls;
	sSql := 'Select * from conciliacoes';
	sSql := sSql+gOrdemGrid;
	Data1_DataSet.CommandText := sSql;
	DbRefresh(Data1_DataSet);
	Titulos;
//	DbGrid.Redraw := true;
  DbGrid.DataSource.DataSet.EnableControls;
	if False{Data1.DataSource.DataSet.Eof} then
    begin
		// Reconstitui a tela
		DbGrid.Redraw := false;
		sSql := 'Select * from conciliacoes';
		sSql := sSql+gOrdemGrid;
		Data1_DataSet.CommandText := sSql;
		DbRefresh(Data1_DataSet);
		Titulos;
		DbGrid.Redraw := true;
	  end;
end;
{$IFEND} // defUse_AtualizaGrid

procedure TConsultaCon.Titulos();
var
	I: Smallint;
begin
(*	I := 1;                                   //Rever
	DbGrid.Row := 0;

	DbGrid.Col := I;
	DbGrid.Text := 'Cliente';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Conta';
	I := I+1;

	DbGrid.Col := I;
	DbGrid.Text := 'Código';

	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Código2';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Natureza';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Hist R$';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Hist US$';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Bandeira';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Rel Origem';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Template';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Arquivo Saida';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Obs';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Junta';
	I := I+1;
	DbGrid.Col := I;
	DbGrid.Text := 'Interface';


	if  not False{Data1.DataSource.DataSet.Eof} then begin
		DbGrid.Row := 1;
	end;                   *)

end;



procedure TConsultaCon.FormCreate(Sender: TObject);
begin
	lOrdenAtual := 0;
end;

end.
