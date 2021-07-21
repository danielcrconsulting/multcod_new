unit ConsultaCon_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, DBCtrls, DB, ADODB,
  Vcl.Grids, Vcl.DBGrids, Winapi.Messages;

type
  TConsultaCon = class(TForm)
    cmdSair:  TButton;
    Data1:  TDBNavigator;
    Data1_DataSource:  TDataSource;
    Data1_DataSet:  TADODataSet;
    cmdRelatorio:  TButton;
    Frame1:  TGroupBox;
    optDecres:  TRadioButton;
    cmbOrdena:  TComboBox;
    optCres:  TRadioButton;
    DbGrid: TDBGrid;
    gBanco: TADOConnection;
    Label1: TLabel;
    ComboBox1: TComboBox;

    procedure cmbOrdenaClick(Sender: TObject);
    procedure cmbOrdena_Click();
    procedure cmdSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure optCresClick(Sender: TObject);
    procedure optDecresClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);

  private
    { Private declarations }
    lOrdenAtual: Smallint;
    FOrgDBGridWndProc: TWndMethod;

    procedure MontaCombo();
    procedure Form_Unload(var Cancel: Smallint);
    procedure DBGridWndProc(var Msg: TMessage);
    procedure Titulos;

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
Var
  SobeOuDesce : String;
begin

if OptCres.Checked then
  SobeOuDesce := ''
else
  SobeOuDesce := ' DESC';

  DbGrid.DataSource.DataSet.DisableControls;

  sSql := 'Select * from conciliacoes ';

  if (Combobox1.Items[Combobox1.ItemIndex] <> 'Todos') and (Combobox1.Items[Combobox1.ItemIndex] <> '') then
    sSql := sSql + 'WHERE nome_cliente = ' + #39 + Combobox1.Items[Combobox1.ItemIndex] + #39;

  case cmbOrdena.ItemIndex of
    0: sSql := sSql + ' order by nome_cliente, conta_contabil';

    1: sSql := sSql + ' order by conta_contabil, nome_cliente';

    2: sSql := sSql + ' order by Codigo, nome_cliente';

  end;

  Data1_DataSet.Close;
  Data1_DataSet.CommandText := sSql + SobeOuDesce;
  Data1_DataSet.Open;

  Titulos;

  DbGrid.DataSource.DataSet.EnableControls;

end;

procedure TConsultaCon.cmbOrdena_Click;
begin
  cmbOrdenaClick(cmbOrdena);
end;

procedure TConsultaCon.cmdSairClick(Sender: TObject);
begin
  Close;
end;

procedure TConsultaCon.ComboBox1Select(Sender: TObject);
begin

  cmbOrdenaClick(Self);

end;

procedure TConsultaCon.FormShow(Sender: TObject);
Var
  W, i: Integer;
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

  Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl');

//  DbGrid.FormatString := '0.00';                      Rever

  Screen.Cursor := crHourGlass;

  DbGrid.DataSource.DataSet.DisableControls;

  Data1_DataSet.Connection := gBanco;

  sSql := 'Select distinct nome_cliente from conciliacoes';
  sSql := sSql + ' order by nome_cliente';
  Data1_DataSet.Close;
  Data1_DataSet.CommandText := sSql;
  Data1_DataSet.Open;
  Combobox1.Clear;
  while not (Data1_DataSet.Eof) do
    begin
      Combobox1.Items.Add(Data1_DataSet.Fields[0].AsString);
      Data1_DataSet.Next
    end;
  Combobox1.Items.Add('Todos');

  sSql := 'Select * from conciliacoes';
  sSql := sSql + ' order by nome_cliente';
  Data1_DataSet.Close;
  Data1_DataSet.CommandText := sSql;
  Data1_DataSet.Open;

  DbGrid.DataSource.DataSet.EnableControls;

  MontaCombo;

  DbGrid.DataSource.DataSet.EnableControls;
  Screen.Cursor := crDefault;

  Titulos;

  W := 0;                                                 //Redimensiona o form e o Grid
  for i := 0 to DBGrid.Columns.Count - 1 do
    W := W + DBGrid.Columns[i].Width + 2;
  DBGrid.ClientWidth := W;
  Self.ClientWidth := (DBGrid.Left * 2) + DBGrid.Width;

  CenterForm(Self);

end;

procedure TConsultaCon.MontaCombo;
begin
  cmbOrdena.Clear;
  cmbOrdena.Items.Add('Cliente');
  cmbOrdena.Items.Add('Conta');
  cmbOrdena.Items.Add('Código');
end;

procedure TConsultaCon.Form_Unload(var Cancel: Smallint);
begin
  Data1_DataSet.Close;
  Data1_DataSet.CommandText := '';
  gBanco.Close;
end;

procedure TConsultaCon.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Cancel: Smallint;
begin
  Cancel := 0;

  Form_Unload(Cancel);
  If Cancel <> 0 Then
    CanClose := false;
end;

procedure TConsultaCon.optCresClick(Sender: TObject);
begin
  if Self.optCres.Checked=true then
    begin
    Self.optDecres.Checked := false;
    lOrdenAtual := 1;
    if cmbOrdena.ItemIndex >= 0 then
      cmbOrdena_Click;
    end;
end;

procedure TConsultaCon.optDecresClick(Sender: TObject);
begin
  if Self.optDecres.Checked=true then
    begin
    Self.optCres.Checked := false;
    lOrdenAtual := 2;
    if cmbOrdena.ItemIndex >= 0 then
      cmbOrdena_Click;
    end;
end;

procedure TConsultaCon.DBGridWndProc(var Msg: TMessage);
begin
  if (Msg.Msg = WM_VSCROLL) and
    (LongRec(Msg.wParam).Lo = 5 {SB_THUMBTRACK}) then
  begin
      LongRec(Msg.wParam).Lo := 4 {SB_THUMBPOSITION};
  end;
  if Assigned(FOrgDBGridWndProc) then
    FOrgDBGridWndProc(Msg);
end;

procedure TConsultaCon.FormCreate(Sender: TObject);
begin
  lOrdenAtual := 0;
  FOrgDBGridWndProc := DBGrid.WindowProc;
  DBGrid.WindowProc := DBGridWndProc;
end;

procedure TConsultaCon.Titulos;
begin

  DbGrid.Fields[0].DisplayLabel := 'Cliente';
  DbGrid.Fields[1].DisplayLabel := 'Conta Contábil';
  DbGrid.Fields[2].DisplayLabel := 'Código';
  DbGrid.Fields[3].DisplayLabel := 'Código Para';
  DbGrid.Fields[4].DisplayLabel := 'Natureza';
  DbGrid.Fields[5].DisplayLabel := 'Hist R$';
  DbGrid.Fields[6].DisplayLabel := 'Hist US$';
  DbGrid.Fields[7].DisplayLabel := 'Bandeira';
  DbGrid.Fields[8].DisplayLabel := 'Rel. Origem';
  DbGrid.Fields[9].DisplayLabel := 'Template';
  DbGrid.Fields[10].DisplayLabel := 'Arquivo Saída';
  DbGrid.Fields[11].DisplayLabel := 'Observação';
  DbGrid.Fields[12].DisplayLabel := 'Junta';
  DbGrid.Fields[13].DisplayLabel := 'Interface';
  DbGrid.Fields[14].DisplayLabel := 'Junta 2';
  DbGrid.Fields[15].DisplayLabel := 'Interface 2';

end;

end.
