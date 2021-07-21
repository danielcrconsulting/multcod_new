unit formGrade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, DB, DBCtrls, Buttons, ADODB, System.UITypes;

type
  TDBGrid = class(DBGrids.TDBGrid)
  private
    procedure WmVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  end;

  TfGrade = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    dGrade: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

    function getTitulo:String;
    function getTabela:TAdoQuery;
    function getFormulario:TForm;
    function getSql:String;
    function getNomeColuna:variant;
    function getMostraColuna:variant;
    procedure setTitulo(valor:String);
    procedure setTabela(valor:TAdoQuery);
    procedure setFormulario(valor:TForm);
    procedure setSql(valor:String);
    procedure setNomeColuna(valor:variant);
    procedure setMostraColuna(valor:variant);

  public
    { Public declarations }
    procedure CarregaGrid;
  published
    property sql: String read getSql write setSql;
    property titulo: String read getTitulo write setTitulo;
    property tabela: TAdoQuery read getTabela write setTabela;
    property formulario: TForm read getFormulario write setFormulario;
    property nomeColuna: variant read getNomeColuna write setNomeColuna;
    property mostraColuna: variant read getMostraColuna write setMostraColuna;
  end;

var
  fGrade: TfGrade;

implementation

uses dataModule;

{$R *.dfm}

var
  ColunaFiltro : integer;
  ColunasFiltro,
  sSql,
  sTitulo : String;
  tPesquisa : TAdoQuery;
  fFormulario : TForm;
  aNomeColuna : array of string;
  aMostraColuna : array of string;

procedure TDBGrid.WmVScroll(var Message: TWMVScroll);
begin
  if Message.ScrollCode = SB_THUMBTRACK then
    Message.ScrollCode := SB_THUMBPOSITION;
  inherited;
end;

function TfGrade.getTitulo:String;
begin
result := sTitulo;
end;

function TfGrade.getTabela:TAdoQuery;
begin
result := tPesquisa;
end;

function TfGrade.getFormulario:TForm;
begin
result := fFormulario;
end;

function TfGrade.getNomeColuna:variant;
begin
result := aNomeColuna;
end;

function TfGrade.getMostraColuna:variant;
begin
result := aMostraColuna;
end;

function TfGrade.getSql:String;
begin
result := sSql;
end;

procedure TfGrade.setTitulo(valor:String);
begin
sTitulo := valor;
end;

procedure TfGrade.setTabela(valor:TAdoQuery);
begin
tPesquisa := valor;
end;

procedure TfGrade.setFormulario(valor:TForm);
begin
fFormulario := valor;
end;

procedure TfGrade.setSql(valor:String);
begin
sSql := valor;
end;

procedure TfGrade.setNomeColuna(valor:variant);
begin
aNomeColuna := valor;
end;

procedure TfGrade.setMostraColuna(valor:variant);
begin
aMostraColuna := valor;
end;

procedure TfGrade.DBGrid1DblClick(Sender: TObject);
var
  i, x : integer;
begin
x := tPesquisa.RecNo-1;   // Guarda a posição do grid!!!!

fGrade.Visible := false;
fFormulario.Tag := 0;
fFormulario.ShowModal;

tPesquisa.Close;       //     Isso coloca o cursor de volta na linha 1 do grid
tPesquisa.Open;
for i := 0 to high(aNomeColuna) do
  begin
  tPesquisa.Fields[i].DisplayLabel := aNomeColuna[i];
  DBGrid1.Columns.Items[i].DisplayName := aNomeColuna[i];
  DBGrid1.Columns.Items[i].Visible := (aMostraColuna[i]='true');
  end;

fGrade.Visible := true;     //     Isso coloca o cursor de volta na linha 1 do grid, então vamos deixar na que tem foco
tPesquisa.MoveBy(x);
Application.ProcessMessages;
end;

procedure TFGrade.CarregaGrid;
var
  i : integer;
  xX : String;
begin
tPesquisa.Filtered := false;
tPesquisa.Filter := '';
dbGrid1.Refresh;
ColunaFiltro := 0;
caption := sTitulo;
dGrade.DataSet := tPesquisa;
tPesquisa.SQL.Clear;
tPesquisa.SQL.Add(sSql+' ORDER BY 1 ');

xX := tPesquisa.SQL.Text;
for i := 0 to high(aNomeColuna) do
  if i>0 then
    xX := xX + ','+IntToStr(i+1);
tPesquisa.SQL.Text := xX;

tPesquisa.open;

for i := 0 to high(aNomeColuna) do
  begin
  tPesquisa.Fields[i].DisplayLabel := aNomeColuna[i];
  DBGrid1.Columns.Items[i].DisplayName := aNomeColuna[i];
  DBGrid1.Columns.Items[i].Visible := (aMostraColuna[i]='true');
  end;

//tPesquisa.close;
//tPesquisa.SQL.Text := xX;
//tPesquisa.open;
end;

procedure TfGrade.SpeedButton2Click(Sender: TObject);
begin
fGrade.Close;
end;

procedure TfGrade.SpeedButton1Click(Sender: TObject);
var
  i : integer;
begin
fGrade.Visible := false;
fFormulario.Tag := 1;
fFormulario.ShowModal;
tPesquisa.Close;
tPesquisa.Open;
for i := 0 to high(aNomeColuna) do
  begin
  tPesquisa.Fields[i].DisplayLabel := aNomeColuna[i];
  DBGrid1.Columns.Items[i].DisplayName := aNomeColuna[i];
  DBGrid1.Columns.Items[i].Visible := (aMostraColuna[i]='true');
  end;
fGrade.Visible := true;
end;

procedure TfGrade.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then
  DBGrid1DblClick(Sender);
end;

procedure TfGrade.SpeedButton3Click(Sender: TObject);
var
  strFiltro : string;
begin
strFiltro := inputBox('Filtrar grid','Entre com um valor para o filtro ou deixe o campo em branco para remover um filtro já existente.'+#13#10+'O filtro será aplicado para o campo: '+aNomeColuna[ColunaFiltro],'');
if length(trim(strFiltro)) > 0 then
  begin
  if (tPesquisa.Fields[ColunaFiltro].DataType = ftString) or
     (tPesquisa.Fields[ColunaFiltro].DataType = ftWideString) or
     (tPesquisa.Fields[ColunaFiltro].DataType = ftFixedChar) then
    tPesquisa.Filter := tPesquisa.Fields[ColunaFiltro].FieldName + ' LIKE ''%' + strFiltro + '%'''
  else if (tPesquisa.Fields[ColunaFiltro].DataType = ftSmallint)	or
          (tPesquisa.Fields[ColunaFiltro].DataType = ftInteger)	or
          (tPesquisa.Fields[ColunaFiltro].DataType = ftWord)	or
          (tPesquisa.Fields[ColunaFiltro].DataType = ftFloat)	or
          (tPesquisa.Fields[ColunaFiltro].DataType = ftCurrency)	or
          (tPesquisa.Fields[ColunaFiltro].DataType = ftFloat)then
    tPesquisa.Filter := tPesquisa.Fields[ColunaFiltro].FieldName + ' = ' + strFiltro
  else
    begin
    tPesquisa.Filter := '';
    messageDlg('Opção de filtro não disponível para este tipo de dado',mtInformation,[mbOk],0);
    end;
  end
else
  tPesquisa.Filter := '';

if length(trim(tPesquisa.Filter)) > 0 then
  tPesquisa.Filtered := true
else
  tPesquisa.Filtered := false;

//tPesquisa.Refresh;
tPesquisa.Close;
tPesquisa.Open;
end;

procedure TfGrade.FormClose(Sender: TObject; var Action: TCloseAction);
begin
tPesquisa.Close;
end;

procedure TfGrade.FormShow(Sender: TObject);
begin
CarregaGrid;         // Romero 18/09/2013
end;

procedure TfGrade.DBGrid1TitleClick(Column: TColumn);
var
  strSql : String;
  i : integer;
begin
SpeedButton3.Enabled := true;
ColunasFiltro := '';
ColunaFiltro := column.Index;
strSql := sSql+' ORDER BY '+intToStr(column.Index+1);
tPesquisa.Close;
tPesquisa.SQL.Clear;
tPesquisa.SQL.Add(strSql);
tPesquisa.open;
for i := 0 to high(aNomeColuna) do
  begin
  tPesquisa.Fields[i].DisplayLabel := aNomeColuna[i];
  DBGrid1.Columns.Items[i].DisplayName := aNomeColuna[i];
  DBGrid1.Columns.Items[i].Visible := (aMostraColuna[i]='true');
  end;
end;

procedure TfGrade.SpeedButton4Click(Sender: TObject);
var
  strSql : String;
  i : integer;
begin
speedButton3.Enabled := false;
ColunaFiltro := -1;
ColunasFiltro := '';
if not inputQuery('Classificação especial','Informe os números das colunas que deseja classificar separados por vírgula',ColunasFiltro) then
  exit;
strSql := sSql+' ORDER BY '+ColunasFiltro;
tPesquisa.Close;
tPesquisa.SQL.Clear;
tPesquisa.SQL.Add(strSql);
try
  tPesquisa.open;
except
  begin
  tPesquisa.close;
  messageDlg('Erro na classificação. Verifique se os números das colunas informados estão corretos e se eles estão separados por vírgulas.',mtError,[mbOk],0);
  exit;
  end;
end;
for i := 0 to high(aNomeColuna) do
  begin
  tPesquisa.Fields[i].DisplayLabel := aNomeColuna[i];
  DBGrid1.Columns.Items[i].DisplayName := aNomeColuna[i];
  DBGrid1.Columns.Items[i].Visible := (aMostraColuna[i]='true');
  end;
end;

procedure TfGrade.SpeedButton5Click(Sender: TObject);
var
  f : system.text;
  i : integer;
  nomeArq,
  s : string;
begin
if not saveDialog1.Execute then
  exit;
nomeArq := changeFileExt(saveDialog1.FileName,'.csv');
if fileExists(saveDialog1.FileName) then
  if messageDlg('O arquivo selecionado já existe, sobrescrever ?',mtConfirmation,[mbYes,mbNo],0)=mrNo then
    exit;
assignFile(f,nomeArq);
rewrite(f);
tPesquisa.First;
s := '';
for i := 0 to DBGrid1.Columns.Count-1 do
  if DBGrid1.Columns.Items[i].Visible then
    s := s + aNomeColuna[i] + ';';
writeLn(f,s);
while not tPesquisa.eof do
  begin
  s := '';
  for i := 0 to tPesquisa.FieldCount-1 do
    if DBGrid1.Columns.Items[i].Visible then
      s := s + tPesquisa.Fields[i].AsString + ';';
  writeLn(f,s);
  tPesquisa.Next;
  end;
closeFile(f);
messageDlg('O arquivo: '+nomeArq+' foi gerado com sucesso.',mtInformation,[mbOk],0);
end;

end.
