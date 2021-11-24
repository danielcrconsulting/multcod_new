//
// Created by the DataSnap proxy generator.
// 22/11/2021 12:43:27
//

unit ClientClassesUnit2;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FDSServerModuleDestroyCommand: TDSRestCommand;
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FRetornarParametrosConnCommand: TDSRestCommand;
    FRetornarDadosBancoCommand: TDSRestCommand;
    FPersistirBancoCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure DSServerModuleDestroy(Sender: TObject);
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function RetornarParametrosConn(var servidor: string; var driverservidor: string; var porta: string; var banco: string; var usuario: string; var senha: string; var NomeEstacao: string; const ARequestFilter: string = ''): Boolean;
    function RetornarDadosBanco(SQL: string; const ARequestFilter: string = ''): string;
    procedure PersistirBanco(SQL: string);
  end;

const
  TServerMethods1_DSServerModuleDestroy: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'Sender'; Direction: 1; DBXType: 37; TypeName: 'TObject')
  );

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

  TServerMethods1_RetornarDadosBanco: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'SQL'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_PersistirBanco: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'SQL'; Direction: 1; DBXType: 26; TypeName: 'string')
  );

implementation

procedure TServerMethods1Client.DSServerModuleDestroy(Sender: TObject);
begin
  if FDSServerModuleDestroyCommand = nil then
  begin
    FDSServerModuleDestroyCommand := FConnection.CreateCommand;
    FDSServerModuleDestroyCommand.RequestType := 'POST';
    FDSServerModuleDestroyCommand.Text := 'TServerMethods1."DSServerModuleDestroy"';
    FDSServerModuleDestroyCommand.Prepare(TServerMethods1_DSServerModuleDestroy);
  end;
  if not Assigned(Sender) then
    FDSServerModuleDestroyCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FDSServerModuleDestroyCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FDSServerModuleDestroyCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(Sender), True);
      if FInstanceOwner then
        Sender.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FDSServerModuleDestroyCommand.Execute;
end;

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

function TServerMethods1Client.RetornarDadosBanco(SQL: string; const ARequestFilter: string): string;
begin
  if FRetornarDadosBancoCommand = nil then
  begin
    FRetornarDadosBancoCommand := FConnection.CreateCommand;
    FRetornarDadosBancoCommand.RequestType := 'GET';
    FRetornarDadosBancoCommand.Text := 'TServerMethods1.RetornarDadosBanco';
    FRetornarDadosBancoCommand.Prepare(TServerMethods1_RetornarDadosBanco);
  end;
  FRetornarDadosBancoCommand.Parameters[0].Value.SetWideString(SQL);
  FRetornarDadosBancoCommand.Execute(ARequestFilter);
  Result := FRetornarDadosBancoCommand.Parameters[1].Value.GetWideString;
end;

procedure TServerMethods1Client.PersistirBanco(SQL: string);
begin
  if FPersistirBancoCommand = nil then
  begin
    FPersistirBancoCommand := FConnection.CreateCommand;
    FPersistirBancoCommand.RequestType := 'GET';
    FPersistirBancoCommand.Text := 'TServerMethods1.PersistirBanco';
    FPersistirBancoCommand.Prepare(TServerMethods1_PersistirBanco);
  end;
  FPersistirBancoCommand.Parameters[0].Value.SetWideString(SQL);
  FPersistirBancoCommand.Execute;
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
  FDSServerModuleDestroyCommand.DisposeOf;
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FRetornarParametrosConnCommand.DisposeOf;
  FRetornarDadosBancoCommand.DisposeOf;
  FPersistirBancoCommand.DisposeOf;
  inherited;
end;

end.

