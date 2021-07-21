unit fProtocolo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, DB, Grids, DBGrids, Buttons, System.UITypes;

type
  TfProtocol = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fProtocol: TfProtocol;

implementation

uses dataModule, login;

{$R *.dfm}

procedure TfProtocol.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfProtocol.SpeedButton1Click(Sender: TObject);
var
   strData : String;
   dData : TDateTime;
begin
strData := '';
strData := inputBox('Limpeza de log','Informe a data limite para limpeza (dd/mm/aaaa)','');
if strData = '' then
   exit;
try
  dData := EncodeDate(strToInt(copy(strData,7,4)), strToInt(copy(strData,4,2)), strToInt(copy(strData,1,2)));
except
  on e:exception do
    begin
    messageDlg('A data informada não é uma data válida. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
    exit;
    end;
end;
if messageDlg('Todos os registros do log inferiores a ' + strData + ' serão apagados. Deseja continuar ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  exit;

with repositorioDeDados do
  begin
  dbMulticoldLog.BeginTrans;
  try
    logQuery.close;
    logQuery.SQL.Clear;
    logQuery.SQL.Add(' DELETE FROM PROTOCOLO WHERE DTFIMPROC < :A ');
    logQuery.Parameters[0].Value := dData;
    logQuery.ExecSQL;
  except
    on e:exception do
      begin
      dbMulticoldLog.RollbackTrans;
      MessageDlg('Erro apagando log.'+#10#13+'Detalhes do erro: '+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticoldLog.InTransaction then
    dbMulticoldLog.CommitTrans;

  repositorioDeDados.logQuery.SQL.Clear;
  repositorioDeDados.logQuery.SQL.Add(' SELECT * FROM PROTOCOLO ORDER BY 1 ');
  repositorioDeDados.logQuery.Open;
  dbGrid1.Refresh;
  
  end;
end;

procedure TfProtocol.SpeedButton5Click(Sender: TObject);
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
repositorioDeDados.logQuery.First;
s := '';
for i := 0 to DBGrid1.Columns.Count-1 do
  s := s + DBGrid1.Columns[i].FieldName + ';';
writeLn(f,s);
while not repositorioDeDados.logQuery.eof do
  begin
  s := '';
  for i := 0 to repositorioDeDados.logQuery.FieldCount-1 do
    s := s + repositorioDeDados.logQuery.Fields[i].AsString + ';';
  writeLn(f,s);
  repositorioDeDados.logQuery.Next;
  end;
closeFile(f);
messageDlg('O arquivo: '+nomeArq+' foi gerado com sucesso.',mtInformation,[mbOk],0);
end;

end.
