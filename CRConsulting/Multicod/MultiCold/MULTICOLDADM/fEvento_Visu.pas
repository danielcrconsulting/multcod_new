unit fEvento_Visu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, DB, Grids, DBGrids, Buttons, StdCtrls, System.UITypes;

type
  TfEventosVisu = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ComboBox1: TComboBox;
    SpeedButton5: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEventosVisu: TfEventosVisu;

implementation

uses dataModule, login, principal;

{$R *.dfm}

procedure TfEventosVisu.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfEventosVisu.SpeedButton1Click(Sender: TObject);
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
  dbMulticoldEvento.BeginTrans;
  try
    repositorioDeDados.QueryEvento.Close;
    QueryEvento2.Parameters[0].Value := dData;
    QueryEvento2.ExecSQL;
    QueryEvento3.Parameters[0].Value := Now;
    QueryEvento3.Parameters[1].Value := Now;
    QueryEvento3.Parameters[2].Value := '';
    QueryEvento3.Parameters[3].Value := '';
    QueryEvento3.Parameters[4].Value := '';
    QueryEvento3.Parameters[5].Value := Null;
    QueryEvento3.Parameters[6].Value := Null;
    QueryEvento3.Parameters[7].Value := nomeDoUsuarioDaSessao;
    QueryEvento3.Parameters[8].Value := '';
    QueryEvento3.Parameters[9].Value := 10;
    QueryEvento3.ExecSQL;
    repositorioDeDados.QueryEvento.Open;
  except
    on e:exception do
      begin
      dbMulticoldEvento.RollbackTrans;
      MessageDlg('Erro apagando log.'+#10#13+'Detalhes do erro: '+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticoldEvento.InTransaction then
    dbMulticoldEvento.CommitTrans;
  end;
end;

procedure TfEventosVisu.ComboBox1Change(Sender: TObject);
begin
repositorioDeDados.QueryEvento.Close;
repositorioDeDados.QueryEvento.Sql.Clear;

if DataI = '' then
   begin
   messageDlg('Falta informar a data inicial. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
   exit;
   end;
try
  tDataI := EncodeDate(strToInt(copy(DataI,7,4)), strToInt(copy(DataI,4,2)), strToInt(copy(DataI,1,2)));
except
  on e:exception do
    begin
    messageDlg('A data inicial informada não é uma data válida. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
    exit;
    end;
end;

if DataF = '' then
   begin
   messageDlg('Falta informar a data final. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
   exit;
   end;
try
  tDataF := EncodeDate(strToInt(copy(DataF,7,4)), strToInt(copy(DataF,4,2)), strToInt(copy(DataF,1,2)));
except
  on e:exception do
    begin
    messageDlg('A data final informada não é uma data válida. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
    exit;
    end;
end;

if (ComboBox1.ItemIndex = 0) or (ComboBox1.ItemIndex = -1) then
  begin
  SpeedButton1.Enabled := true;
  repositorioDeDados.QueryEvento.Sql.Add(' SELECT ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.DT, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.HR, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.ARQUIVO, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.DIRETORIO, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.CODREL, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.GRUPO, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.SUBGRUPO, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.CODUSUARIO, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.NOMEGRUPOUSUARIO, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	B.MENSAGEM ');
  repositorioDeDados.QueryEvento.Sql.Add(' FROM ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	EVENTOS_VISU A, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	MENSAGENS B ');
  repositorioDeDados.QueryEvento.Sql.Add(' WHERE ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.CODMENSAGEM = B.CODMENSAGEM ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	AND A.DT >= :A01 ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	AND A.DT <= :A02 ');
  repositorioDeDados.QueryEvento.Sql.Add(' ORDER BY ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.DT, ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	A.HR DESC ');
  end
else if ComboBox1.ItemIndex = 1 then
  begin
  SpeedButton1.Enabled := false;
  repositorioDeDados.QueryEvento.Sql.Add(' select a.codrel, max(b.dt) as ''Último acesso''');
  repositorioDeDados.QueryEvento.Sql.Add(' from ');
  repositorioDeDados.QueryEvento.Sql.Add(repositorioDeDados.dbMulticold.DefaultDatabase+'..dfn a');
  repositorioDeDados.QueryEvento.Sql.Add('  left outer join '+repositorioDeDados.dbMulticoldEvento.DefaultDatabase+'..eventos_visu b ');
//  repositorioDeDados.QueryEvento.Sql.Add('  left outer join multicold_evento..eventos_visu b ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	on cast(a.codrel as varchar(20)) COLLATE Latin1_General_CI_AI  = cast(b.codrel as varchar(20)) COLLATE Latin1_General_CI_AI ');
  repositorioDeDados.QueryEvento.Sql.Add(' where a.codrel <> ''*'' ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	AND b.DT >= :A01 ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	AND b.DT <= :A02 ');
  repositorioDeDados.QueryEvento.Sql.Add(' group by a.codrel ');
  repositorioDeDados.QueryEvento.Sql.Add(' order by a.codrel ');
  end
else // if ComboBox1.ItemIndex = 2 then
  begin
  repositorioDeDados.dbMulticoldLog.Connected := True;
  SpeedButton1.Enabled := false;
  repositorioDeDados.QueryEvento.Sql.Add(' select a.codrel, max(b.dtfimproc) ''Último processamento''');
  repositorioDeDados.QueryEvento.Sql.Add(' from ');
  repositorioDeDados.QueryEvento.Sql.Add(repositorioDeDados.dbMulticold.DefaultDatabase+'..dfn a');
  repositorioDeDados.QueryEvento.Sql.Add(' left outer join '+repositorioDeDados.dbMulticoldLog.DefaultDatabase+'..protocolo b ');
//  repositorioDeDados.QueryEvento.Sql.Add(' left outer join multicold_log..protocolo b ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	on cast(a.codrel as varchar(20)) COLLATE Latin1_General_CI_AI  = cast(b.codrel as varchar(20)) COLLATE Latin1_General_CI_AI ');
  repositorioDeDados.QueryEvento.Sql.Add(' where a.codrel <> ''*'' ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	AND b.dtfimproc >= :A01 ');
  repositorioDeDados.QueryEvento.Sql.Add(' 	AND b.dtfimproc <= :A02 ');
  repositorioDeDados.QueryEvento.Sql.Add(' group by a.codrel ');
  repositorioDeDados.QueryEvento.Sql.Add(' order by a.codrel ');
  repositorioDeDados.dbMulticoldLog.Connected := False;
  end;
repositorioDeDados.QueryEvento.Parameters[0].Value := tDataI;
repositorioDeDados.QueryEvento.Parameters[1].Value := tDataF;
repositorioDeDados.QueryEvento.Open;
end;

procedure TfEventosVisu.FormCreate(Sender: TObject);
begin
ComboBox1.Text := COmboBox1.Items.Strings[0];
end;

procedure TfEventosVisu.SpeedButton5Click(Sender: TObject);
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
repositorioDeDados.QueryEvento.First;
s := '';
for i := 0 to repositorioDeDados.QueryEvento.FieldCount-1 do
  s := s + repositorioDeDados.QueryEvento.FieldList.Fields[i].FieldName + ';';
writeLn(f,s);
while not repositorioDeDados.QueryEvento.eof do
  begin
  s := '';
  for i := 0 to repositorioDeDados.QueryEvento.FieldCount-1 do
    s := s + repositorioDeDados.QueryEvento.Fields[i].AsString + ';';
  writeLn(f,s);
  repositorioDeDados.QueryEvento.Next;
  end;
closeFile(f);
messageDlg('O arquivo: '+nomeArq+' foi gerado com sucesso.',mtInformation,[mbOk],0);
end;

end.
