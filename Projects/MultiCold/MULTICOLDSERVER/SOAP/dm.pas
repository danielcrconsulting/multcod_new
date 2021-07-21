unit dm;

interface

uses
  SysUtils, Classes, DB, ADODB, DBTables, SqlExpr, FMTBcd,
  Data.DBXMSSQL;

type
  TDataModule1 = class(TDataModule)
    ibEventosQuery1: TADOQuery;
    Query1: TQuery;
    Query2: TQuery;
    Session1: TSession;
    DataBaseLocal: TADOConnection;
    IBQuery1: TADOQuery;
    DataBaseEventos: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
with DatabaseLocal do
  begin
  connectionString := 'FILE NAME='+extractFilePath(ParamStr(0))+'Multicold.udl';
  loginPrompt := false;
  commandTimeout := 30;
  connectionTimeout := 15;
  connectOptions := coConnectUnspecified;
  cursorLocation := clUseServer;
  IsolationLevel := ilCursorStability;
  keepConnection := true;
  mode := cmUnknown;
  provider := 'SQLOLEDB.1';
  end;
with DatabaseEventos do
  begin
  connectionString := 'FILE NAME='+extractFilePath(ParamStr(0))+'MulticoldEventos.udl';
  loginPrompt := false;
  commandTimeout := 30;
  connectionTimeout := 15;
  connectOptions := coConnectUnspecified;
  cursorLocation := clUseServer;
  IsolationLevel := ilCursorStability;
  keepConnection := true;
  mode := cmUnknown;
  provider := 'SQLOLEDB.1';
  end;
end;

procedure TDataModule1.DataModuleDestroy(Sender: TObject);
begin
if DatabaseLocal.Connected then
  DatabaseLocal.Close;
if DatabaseEventos.Connected then
  DatabaseEventos.Close;
end;

end.
