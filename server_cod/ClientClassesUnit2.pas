//
// Created by the DataSnap proxy generator.
// 04/04/2022 18:17:38
//

unit ClientClassesUnit2;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FDSServerModuleDestroyCommand: TDSRestCommand;
    FDSServerModuleCreateCommand: TDSRestCommand;
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FRetornarParametrosConnCommand: TDSRestCommand;
    FRetornarDadosBancoCommand: TDSRestCommand;
    FPersistirBancoCommand: TDSRestCommand;
    FBaixarArquivoCommand: TDSRestCommand;
    FBaixarArquivoCommand_Cache: TDSRestCommand;
    FAbreRelatorioCommand: TDSRestCommand;
    FInsereEventosVisuCommand: TDSRestCommand;
    FfazerumtesteCommand: TDSRestCommand;
    FGetPaginaCommand: TDSRestCommand;
    FLogInCommand: TDSRestCommand;
    FGetRelatorioCommand: TDSRestCommand;
    FExecutaNovaQueryFacilCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure DSServerModuleDestroy(Sender: TObject);
    procedure DSServerModuleCreate(Sender: TObject);
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function RetornarParametrosConn(var servidor: string; var driverservidor: string; var porta: string; var banco: string; var usuario: string; var senha: string; var NomeEstacao: string; const ARequestFilter: string = ''): Boolean;
    function RetornarDadosBanco(SQL: string; bd: Integer; const ARequestFilter: string = ''): string;
    procedure PersistirBanco(SQL: string; bd: Integer);
    function BaixarArquivo(arq: string; const ARequestFilter: string = ''): TJSONArray;
    function BaixarArquivo_Cache(arq: string; const ARequestFilter: string = ''): IDSRestCachedJSONArray;
    function AbreRelatorio(Usuario: WideString; Senha: WideString; ConnectionID: Integer; FullPath: WideString; QtdPaginas: Integer; StrCampos: WideString; Rel64: Byte; Rel133: Byte; CmprBrncs: Byte; tipo: Integer; log: Boolean; const ARequestFilter: string = ''): string;
    procedure InsereEventosVisu(Arquivo: string; Diretorio: string; CodRel: string; CodUsuario: string; NomeGrupoUsuario: string; Grupo: Integer; SubGrupo: Integer; CodMens: Integer);
    procedure fazerumteste;
    function GetPagina(Usuario: WideString; Senha: WideString; ConnectionID: Integer; Relatorio: WideString; PagNum: Integer; QtdBytes: Integer; Pagina: WideString; const ARequestFilter: string = ''): string;
    function LogIn(Usuario: WideString; Senha: WideString; ConnectionID: Integer; const ARequestFilter: string = ''): string;
    function GetRelatorio(Usuario: WideString; Senha: WideString; ConnectionID: Integer; ListaCodRel: WideString; FullPaths: WideString; tipo: Integer; const ARequestFilter: string = ''): string;
    function ExecutaNovaQueryFacil(gridXML: WideString; fileName: WideString; usuario: WideString; mensagem: WideString; xmlData: WideString; const ARequestFilter: string = ''): string;
  end;

const
  TServerMethods1_DSServerModuleDestroy: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'Sender'; Direction: 1; DBXType: 37; TypeName: 'TObject')
  );

  TServerMethods1_DSServerModuleCreate: array [0..0] of TDSRestParameterMetaData =
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

  TServerMethods1_RetornarDadosBanco: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'SQL'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'bd'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_PersistirBanco: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'SQL'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'bd'; Direction: 1; DBXType: 6; TypeName: 'Integer')
  );

  TServerMethods1_BaixarArquivo: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'arq'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONArray')
  );

  TServerMethods1_BaixarArquivo_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'arq'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_AbreRelatorio: array [0..11] of TDSRestParameterMetaData =
  (
    (Name: 'Usuario'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'Senha'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'ConnectionID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'FullPath'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'QtdPaginas'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'StrCampos'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'Rel64'; Direction: 1; DBXType: 29; TypeName: 'Byte'),
    (Name: 'Rel133'; Direction: 1; DBXType: 29; TypeName: 'Byte'),
    (Name: 'CmprBrncs'; Direction: 1; DBXType: 29; TypeName: 'Byte'),
    (Name: 'tipo'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'log'; Direction: 1; DBXType: 4; TypeName: 'Boolean'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_InsereEventosVisu: array [0..7] of TDSRestParameterMetaData =
  (
    (Name: 'Arquivo'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'Diretorio'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'CodRel'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'CodUsuario'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'NomeGrupoUsuario'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'Grupo'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'SubGrupo'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'CodMens'; Direction: 1; DBXType: 6; TypeName: 'Integer')
  );

  TServerMethods1_GetPagina: array [0..7] of TDSRestParameterMetaData =
  (
    (Name: 'Usuario'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'Senha'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'ConnectionID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'Relatorio'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'PagNum'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'QtdBytes'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'Pagina'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_LogIn: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'Usuario'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'Senha'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'ConnectionID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_GetRelatorio: array [0..6] of TDSRestParameterMetaData =
  (
    (Name: 'Usuario'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'Senha'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'ConnectionID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ListaCodRel'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'FullPaths'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'tipo'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ExecutaNovaQueryFacil: array [0..5] of TDSRestParameterMetaData =
  (
    (Name: 'gridXML'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'fileName'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'usuario'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'mensagem'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: 'xmlData'; Direction: 1; DBXType: 26; TypeName: 'WideString'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
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

procedure TServerMethods1Client.DSServerModuleCreate(Sender: TObject);
begin
  if FDSServerModuleCreateCommand = nil then
  begin
    FDSServerModuleCreateCommand := FConnection.CreateCommand;
    FDSServerModuleCreateCommand.RequestType := 'POST';
    FDSServerModuleCreateCommand.Text := 'TServerMethods1."DSServerModuleCreate"';
    FDSServerModuleCreateCommand.Prepare(TServerMethods1_DSServerModuleCreate);
  end;
  if not Assigned(Sender) then
    FDSServerModuleCreateCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FDSServerModuleCreateCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FDSServerModuleCreateCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(Sender), True);
      if FInstanceOwner then
        Sender.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FDSServerModuleCreateCommand.Execute;
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

function TServerMethods1Client.RetornarDadosBanco(SQL: string; bd: Integer; const ARequestFilter: string): string;
begin
  if FRetornarDadosBancoCommand = nil then
  begin
    FRetornarDadosBancoCommand := FConnection.CreateCommand;
    FRetornarDadosBancoCommand.RequestType := 'GET';
    FRetornarDadosBancoCommand.Text := 'TServerMethods1.RetornarDadosBanco';
    FRetornarDadosBancoCommand.Prepare(TServerMethods1_RetornarDadosBanco);
  end;
  FRetornarDadosBancoCommand.Parameters[0].Value.SetWideString(SQL);
  FRetornarDadosBancoCommand.Parameters[1].Value.SetInt32(bd);
  FRetornarDadosBancoCommand.Execute(ARequestFilter);
  Result := FRetornarDadosBancoCommand.Parameters[2].Value.GetWideString;
end;

procedure TServerMethods1Client.PersistirBanco(SQL: string; bd: Integer);
begin
  if FPersistirBancoCommand = nil then
  begin
    FPersistirBancoCommand := FConnection.CreateCommand;
    FPersistirBancoCommand.RequestType := 'GET';
    FPersistirBancoCommand.Text := 'TServerMethods1.PersistirBanco';
    FPersistirBancoCommand.Prepare(TServerMethods1_PersistirBanco);
  end;
  FPersistirBancoCommand.Parameters[0].Value.SetWideString(SQL);
  FPersistirBancoCommand.Parameters[1].Value.SetInt32(bd);
  FPersistirBancoCommand.Execute;
end;

function TServerMethods1Client.BaixarArquivo(arq: string; const ARequestFilter: string): TJSONArray;
begin
  if FBaixarArquivoCommand = nil then
  begin
    FBaixarArquivoCommand := FConnection.CreateCommand;
    FBaixarArquivoCommand.RequestType := 'GET';
    FBaixarArquivoCommand.Text := 'TServerMethods1.BaixarArquivo';
    FBaixarArquivoCommand.Prepare(TServerMethods1_BaixarArquivo);
  end;
  FBaixarArquivoCommand.Parameters[0].Value.SetWideString(arq);
  FBaixarArquivoCommand.Execute(ARequestFilter);
  Result := TJSONArray(FBaixarArquivoCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TServerMethods1Client.BaixarArquivo_Cache(arq: string; const ARequestFilter: string): IDSRestCachedJSONArray;
begin
  if FBaixarArquivoCommand_Cache = nil then
  begin
    FBaixarArquivoCommand_Cache := FConnection.CreateCommand;
    FBaixarArquivoCommand_Cache.RequestType := 'GET';
    FBaixarArquivoCommand_Cache.Text := 'TServerMethods1.BaixarArquivo';
    FBaixarArquivoCommand_Cache.Prepare(TServerMethods1_BaixarArquivo_Cache);
  end;
  FBaixarArquivoCommand_Cache.Parameters[0].Value.SetWideString(arq);
  FBaixarArquivoCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONArray.Create(FBaixarArquivoCommand_Cache.Parameters[1].Value.GetString);
end;

function TServerMethods1Client.AbreRelatorio(Usuario: WideString; Senha: WideString; ConnectionID: Integer; FullPath: WideString; QtdPaginas: Integer; StrCampos: WideString; Rel64: Byte; Rel133: Byte; CmprBrncs: Byte; tipo: Integer; log: Boolean; const ARequestFilter: string): string;
begin
  if FAbreRelatorioCommand = nil then
  begin
    FAbreRelatorioCommand := FConnection.CreateCommand;
    FAbreRelatorioCommand.RequestType := 'GET';
    FAbreRelatorioCommand.Text := 'TServerMethods1.AbreRelatorio';
    FAbreRelatorioCommand.Prepare(TServerMethods1_AbreRelatorio);
  end;
  FAbreRelatorioCommand.Parameters[0].Value.SetWideString(Usuario);
  FAbreRelatorioCommand.Parameters[1].Value.SetWideString(Senha);
  FAbreRelatorioCommand.Parameters[2].Value.SetInt32(ConnectionID);
  FAbreRelatorioCommand.Parameters[3].Value.SetWideString(FullPath);
  FAbreRelatorioCommand.Parameters[4].Value.SetInt32(QtdPaginas);
  FAbreRelatorioCommand.Parameters[5].Value.SetWideString(StrCampos);
  FAbreRelatorioCommand.Parameters[6].Value.SetUInt8(Rel64);
  FAbreRelatorioCommand.Parameters[7].Value.SetUInt8(Rel133);
  FAbreRelatorioCommand.Parameters[8].Value.SetUInt8(CmprBrncs);
  FAbreRelatorioCommand.Parameters[9].Value.SetInt32(tipo);
  FAbreRelatorioCommand.Parameters[10].Value.SetBoolean(log);
  FAbreRelatorioCommand.Execute(ARequestFilter);
  Result := FAbreRelatorioCommand.Parameters[11].Value.GetWideString;
end;

procedure TServerMethods1Client.InsereEventosVisu(Arquivo: string; Diretorio: string; CodRel: string; CodUsuario: string; NomeGrupoUsuario: string; Grupo: Integer; SubGrupo: Integer; CodMens: Integer);
begin
  if FInsereEventosVisuCommand = nil then
  begin
    FInsereEventosVisuCommand := FConnection.CreateCommand;
    FInsereEventosVisuCommand.RequestType := 'GET';
    FInsereEventosVisuCommand.Text := 'TServerMethods1.InsereEventosVisu';
    FInsereEventosVisuCommand.Prepare(TServerMethods1_InsereEventosVisu);
  end;
  FInsereEventosVisuCommand.Parameters[0].Value.SetWideString(Arquivo);
  FInsereEventosVisuCommand.Parameters[1].Value.SetWideString(Diretorio);
  FInsereEventosVisuCommand.Parameters[2].Value.SetWideString(CodRel);
  FInsereEventosVisuCommand.Parameters[3].Value.SetWideString(CodUsuario);
  FInsereEventosVisuCommand.Parameters[4].Value.SetWideString(NomeGrupoUsuario);
  FInsereEventosVisuCommand.Parameters[5].Value.SetInt32(Grupo);
  FInsereEventosVisuCommand.Parameters[6].Value.SetInt32(SubGrupo);
  FInsereEventosVisuCommand.Parameters[7].Value.SetInt32(CodMens);
  FInsereEventosVisuCommand.Execute;
end;

procedure TServerMethods1Client.fazerumteste;
begin
  if FfazerumtesteCommand = nil then
  begin
    FfazerumtesteCommand := FConnection.CreateCommand;
    FfazerumtesteCommand.RequestType := 'GET';
    FfazerumtesteCommand.Text := 'TServerMethods1.fazerumteste';
  end;
  FfazerumtesteCommand.Execute;
end;

function TServerMethods1Client.GetPagina(Usuario: WideString; Senha: WideString; ConnectionID: Integer; Relatorio: WideString; PagNum: Integer; QtdBytes: Integer; Pagina: WideString; const ARequestFilter: string): string;
begin
  if FGetPaginaCommand = nil then
  begin
    FGetPaginaCommand := FConnection.CreateCommand;
    FGetPaginaCommand.RequestType := 'GET';
    FGetPaginaCommand.Text := 'TServerMethods1.GetPagina';
    FGetPaginaCommand.Prepare(TServerMethods1_GetPagina);
  end;
  FGetPaginaCommand.Parameters[0].Value.SetWideString(Usuario);
  FGetPaginaCommand.Parameters[1].Value.SetWideString(Senha);
  FGetPaginaCommand.Parameters[2].Value.SetInt32(ConnectionID);
  FGetPaginaCommand.Parameters[3].Value.SetWideString(Relatorio);
  FGetPaginaCommand.Parameters[4].Value.SetInt32(PagNum);
  FGetPaginaCommand.Parameters[5].Value.SetInt32(QtdBytes);
  FGetPaginaCommand.Parameters[6].Value.SetWideString(Pagina);
  FGetPaginaCommand.Execute(ARequestFilter);
  Result := FGetPaginaCommand.Parameters[7].Value.GetWideString;
end;

function TServerMethods1Client.LogIn(Usuario: WideString; Senha: WideString; ConnectionID: Integer; const ARequestFilter: string): string;
begin
  if FLogInCommand = nil then
  begin
    FLogInCommand := FConnection.CreateCommand;
    FLogInCommand.RequestType := 'GET';
    FLogInCommand.Text := 'TServerMethods1.LogIn';
    FLogInCommand.Prepare(TServerMethods1_LogIn);
  end;
  FLogInCommand.Parameters[0].Value.SetWideString(Usuario);
  FLogInCommand.Parameters[1].Value.SetWideString(Senha);
  FLogInCommand.Parameters[2].Value.SetInt32(ConnectionID);
  FLogInCommand.Execute(ARequestFilter);
  Result := FLogInCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.GetRelatorio(Usuario: WideString; Senha: WideString; ConnectionID: Integer; ListaCodRel: WideString; FullPaths: WideString; tipo: Integer; const ARequestFilter: string): string;
begin
  if FGetRelatorioCommand = nil then
  begin
    FGetRelatorioCommand := FConnection.CreateCommand;
    FGetRelatorioCommand.RequestType := 'GET';
    FGetRelatorioCommand.Text := 'TServerMethods1.GetRelatorio';
    FGetRelatorioCommand.Prepare(TServerMethods1_GetRelatorio);
  end;
  FGetRelatorioCommand.Parameters[0].Value.SetWideString(Usuario);
  FGetRelatorioCommand.Parameters[1].Value.SetWideString(Senha);
  FGetRelatorioCommand.Parameters[2].Value.SetInt32(ConnectionID);
  FGetRelatorioCommand.Parameters[3].Value.SetWideString(ListaCodRel);
  FGetRelatorioCommand.Parameters[4].Value.SetWideString(FullPaths);
  FGetRelatorioCommand.Parameters[5].Value.SetInt32(tipo);
  FGetRelatorioCommand.Execute(ARequestFilter);
  Result := FGetRelatorioCommand.Parameters[6].Value.GetWideString;
end;

function TServerMethods1Client.ExecutaNovaQueryFacil(gridXML: WideString; fileName: WideString; usuario: WideString; mensagem: WideString; xmlData: WideString; const ARequestFilter: string): string;
begin
  if FExecutaNovaQueryFacilCommand = nil then
  begin
    FExecutaNovaQueryFacilCommand := FConnection.CreateCommand;
    FExecutaNovaQueryFacilCommand.RequestType := 'GET';
    FExecutaNovaQueryFacilCommand.Text := 'TServerMethods1.ExecutaNovaQueryFacil';
    FExecutaNovaQueryFacilCommand.Prepare(TServerMethods1_ExecutaNovaQueryFacil);
  end;
  FExecutaNovaQueryFacilCommand.Parameters[0].Value.SetWideString(gridXML);
  FExecutaNovaQueryFacilCommand.Parameters[1].Value.SetWideString(fileName);
  FExecutaNovaQueryFacilCommand.Parameters[2].Value.SetWideString(usuario);
  FExecutaNovaQueryFacilCommand.Parameters[3].Value.SetWideString(mensagem);
  FExecutaNovaQueryFacilCommand.Parameters[4].Value.SetWideString(xmlData);
  FExecutaNovaQueryFacilCommand.Execute(ARequestFilter);
  Result := FExecutaNovaQueryFacilCommand.Parameters[5].Value.GetWideString;
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
  FDSServerModuleCreateCommand.DisposeOf;
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FRetornarParametrosConnCommand.DisposeOf;
  FRetornarDadosBancoCommand.DisposeOf;
  FPersistirBancoCommand.DisposeOf;
  FBaixarArquivoCommand.DisposeOf;
  FBaixarArquivoCommand_Cache.DisposeOf;
  FAbreRelatorioCommand.DisposeOf;
  FInsereEventosVisuCommand.DisposeOf;
  FfazerumtesteCommand.DisposeOf;
  FGetPaginaCommand.DisposeOf;
  FLogInCommand.DisposeOf;
  FGetRelatorioCommand.DisposeOf;
  FExecutaNovaQueryFacilCommand.DisposeOf;
  inherited;
end;

end.

