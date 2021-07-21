// 
// Created by the DataSnap proxy generator.
// 05/07/2021 18:28:13
// 

unit ClientClassesUnit2;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FRetornarParametrosConnCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function RetornarParametrosConn(var servidor: string; var driverservidor: string; var porta: string; var banco: string; var usuario: string; var senha: string; var NomeEstacao: string; const ARequestFilter: string = ''): Boolean;
  end;

const
  TServerMethods1_EchoString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ReverseString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_RetornarParametrosConn: array [0..7] of TDSRestParameterMetaData =
  (
    (Name: 'servidor'; Direction: 3; DBXType: 26; TypeName: 'string'),
    (Name: 'driverservidor'; Direction: 3; DBXType: 26; TypeName: 'string'),
    (Name: 'porta'; Direction: 3; DBXType: 26; TypeName: 'string'),
    (Name: 'banco'; Direction: 3; DBXType: 26; TypeName: 'string'),
    (Name: 'usuario'; Direction: 3; DBXType: 26; TypeName: 'string'),
    (Name: 'senha'; Direction: 3; DBXType: 26; TypeName: 'string'),
    (Name: 'NomeEstacao'; Direction: 3; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

implementation

function TServerMethods1Client.EchoString(Value: string; const ARequestFilter: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FConnection.CreateCommand;
    FEchoStringCommand.RequestType := 'GET';
    FEchoStringCommand.Text := 'TServerMethods1.EchoString';
    FEchoStringCommand.Prepare(TServerMethods1_EchoString);
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.Execute(ARequestFilter);
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.ReverseString(Value: string; const ARequestFilter: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FConnection.CreateCommand;
    FReverseStringCommand.RequestType := 'GET';
    FReverseStringCommand.Text := 'TServerMethods1.ReverseString';
    FReverseStringCommand.Prepare(TServerMethods1_ReverseString);
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.Execute(ARequestFilter);
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.RetornarParametrosConn(var servidor: string; var driverservidor: string; var porta: string; var banco: string; var usuario: string; var senha: string; var NomeEstacao: string; const ARequestFilter: string): Boolean;
begin
  if FRetornarParametrosConnCommand = nil then
  begin
    FRetornarParametrosConnCommand := FConnection.CreateCommand;
    FRetornarParametrosConnCommand.RequestType := 'GET';
    FRetornarParametrosConnCommand.Text := 'TServerMethods1.RetornarParametrosConn';
    FRetornarParametrosConnCommand.Prepare(TServerMethods1_RetornarParametrosConn);
  end;
  FRetornarParametrosConnCommand.Parameters[0].Value.SetWideString(servidor);
  FRetornarParametrosConnCommand.Parameters[1].Value.SetWideString(driverservidor);
  FRetornarParametrosConnCommand.Parameters[2].Value.SetWideString(porta);
  FRetornarParametrosConnCommand.Parameters[3].Value.SetWideString(banco);
  FRetornarParametrosConnCommand.Parameters[4].Value.SetWideString(usuario);
  FRetornarParametrosConnCommand.Parameters[5].Value.SetWideString(senha);
  FRetornarParametrosConnCommand.Parameters[6].Value.SetWideString(NomeEstacao);
  FRetornarParametrosConnCommand.Execute(ARequestFilter);
  servidor := FRetornarParametrosConnCommand.Parameters[0].Value.GetWideString;
  driverservidor := FRetornarParametrosConnCommand.Parameters[1].Value.GetWideString;
  porta := FRetornarParametrosConnCommand.Parameters[2].Value.GetWideString;
  banco := FRetornarParametrosConnCommand.Parameters[3].Value.GetWideString;
  usuario := FRetornarParametrosConnCommand.Parameters[4].Value.GetWideString;
  senha := FRetornarParametrosConnCommand.Parameters[5].Value.GetWideString;
  NomeEstacao := FRetornarParametrosConnCommand.Parameters[6].Value.GetWideString;
  Result := FRetornarParametrosConnCommand.Parameters[7].Value.GetBoolean;
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FRetornarParametrosConnCommand.DisposeOf;
  inherited;
end;

end.
