//
// Created by the DataSnap proxy generator.
// 18/07/2022 18:35:03
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
    FRetornarParametroADCommand: TDSRestCommand;
    FGravarLOGADCommand: TDSRestCommand;
    FRetornarDadosBancoCommand: TDSRestCommand;
    FPersistirBancoCommand: TDSRestCommand;
    FBaixarArquivoCommand: TDSRestCommand;
    FBaixarArquivoCommand_Cache: TDSRestCommand;
    FfazerumtesteCommand: TDSRestCommand;
    FLimpaMemoriaCommand: TDSRestCommand;
    FValidarADCommand: TDSRestCommand;
    FRetornarContaCartaoCommand: TDSRestCommand;
    FRetornarContaCPFCommand: TDSRestCommand;
    FRetornarContaNomeCommand: TDSRestCommand;
    FRetornarContaAuxCommand: TDSRestCommand;
    FRetornarContaEmpresaCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure DSServerModuleDestroy(Sender: TObject);
    procedure DSServerModuleCreate(Sender: TObject);
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function RetornarParametrosConn(var servidor: string; var driverservidor: string; var porta: string; var banco: string; var usuario: string; var senha: string; var NomeEstacao: string; const ARequestFilter: string = ''): Boolean;
    function RetornarParametroAD(const ARequestFilter: string = ''): string;
    procedure GravarLOGAD(usuario: string; status: string);
    function RetornarDadosBanco(SQL: string; bd: Integer; const ARequestFilter: string = ''): string;
    procedure PersistirBanco(SQL: string; bd: Integer);
    function BaixarArquivo(arq: string; const ARequestFilter: string = ''): TJSONArray;
    function BaixarArquivo_Cache(arq: string; const ARequestFilter: string = ''): IDSRestCachedJSONArray;
    procedure fazerumteste;
    procedure LimpaMemoria;
    function ValidarAD(pUsuario: string; pSenha: string; const ARequestFilter: string = ''): Boolean;
    function RetornarContaCartao(arquivo: string; cartao: string; NArqCart: string; const ARequestFilter: string = ''): string;
    function RetornarContaCPF(arquivo: string; cpf: string; const ARequestFilter: string = ''): string;
    function RetornarContaNome(arquivo: string; nome: string; sobrenome: string; const ARequestFilter: string = ''): string;
    function RetornarContaAux(arquivo: string; contaaux: string; const ARequestFilter: string = ''): string;
    function RetornarContaEmpresa(arquivo: string; conta: Int64; const ARequestFilter: string = ''): string;
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

  TServerMethods1_RetornarParametroAD: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_GravarLOGAD: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'usuario'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'status'; Direction: 1; DBXType: 26; TypeName: 'string')
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

  TServerMethods1_ValidarAD: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'pUsuario'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'pSenha'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

  TServerMethods1_RetornarContaCartao: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'arquivo'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'cartao'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'NArqCart'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_RetornarContaCPF: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'arquivo'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'cpf'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_RetornarContaNome: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'arquivo'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'nome'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'sobrenome'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_RetornarContaAux: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'arquivo'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'contaaux'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_RetornarContaEmpresa: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'arquivo'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'conta'; Direction: 1; DBXType: 18; TypeName: 'Int64'),
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

function TServerMethods1Client.RetornarParametroAD(const ARequestFilter: string): string;
begin
  if FRetornarParametroADCommand = nil then
  begin
    FRetornarParametroADCommand := FConnection.CreateCommand;
    FRetornarParametroADCommand.RequestType := 'GET';
    FRetornarParametroADCommand.Text := 'TServerMethods1.RetornarParametroAD';
    FRetornarParametroADCommand.Prepare(TServerMethods1_RetornarParametroAD);
  end;
  FRetornarParametroADCommand.Execute(ARequestFilter);
  Result := FRetornarParametroADCommand.Parameters[0].Value.GetWideString;
end;

procedure TServerMethods1Client.GravarLOGAD(usuario: string; status: string);
begin
  if FGravarLOGADCommand = nil then
  begin
    FGravarLOGADCommand := FConnection.CreateCommand;
    FGravarLOGADCommand.RequestType := 'GET';
    FGravarLOGADCommand.Text := 'TServerMethods1.GravarLOGAD';
    FGravarLOGADCommand.Prepare(TServerMethods1_GravarLOGAD);
  end;
  FGravarLOGADCommand.Parameters[0].Value.SetWideString(usuario);
  FGravarLOGADCommand.Parameters[1].Value.SetWideString(status);
  FGravarLOGADCommand.Execute;
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

procedure TServerMethods1Client.LimpaMemoria;
begin
  if FLimpaMemoriaCommand = nil then
  begin
    FLimpaMemoriaCommand := FConnection.CreateCommand;
    FLimpaMemoriaCommand.RequestType := 'GET';
    FLimpaMemoriaCommand.Text := 'TServerMethods1.LimpaMemoria';
  end;
  FLimpaMemoriaCommand.Execute;
end;

function TServerMethods1Client.ValidarAD(pUsuario: string; pSenha: string; const ARequestFilter: string): Boolean;
begin
  if FValidarADCommand = nil then
  begin
    FValidarADCommand := FConnection.CreateCommand;
    FValidarADCommand.RequestType := 'GET';
    FValidarADCommand.Text := 'TServerMethods1.ValidarAD';
    FValidarADCommand.Prepare(TServerMethods1_ValidarAD);
  end;
  FValidarADCommand.Parameters[0].Value.SetWideString(pUsuario);
  FValidarADCommand.Parameters[1].Value.SetWideString(pSenha);
  FValidarADCommand.Execute(ARequestFilter);
  Result := FValidarADCommand.Parameters[2].Value.GetBoolean;
end;

function TServerMethods1Client.RetornarContaCartao(arquivo: string; cartao: string; NArqCart: string; const ARequestFilter: string): string;
begin
  if FRetornarContaCartaoCommand = nil then
  begin
    FRetornarContaCartaoCommand := FConnection.CreateCommand;
    FRetornarContaCartaoCommand.RequestType := 'GET';
    FRetornarContaCartaoCommand.Text := 'TServerMethods1.RetornarContaCartao';
    FRetornarContaCartaoCommand.Prepare(TServerMethods1_RetornarContaCartao);
  end;
  FRetornarContaCartaoCommand.Parameters[0].Value.SetWideString(arquivo);
  FRetornarContaCartaoCommand.Parameters[1].Value.SetWideString(cartao);
  FRetornarContaCartaoCommand.Parameters[2].Value.SetWideString(NArqCart);
  FRetornarContaCartaoCommand.Execute(ARequestFilter);
  Result := FRetornarContaCartaoCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.RetornarContaCPF(arquivo: string; cpf: string; const ARequestFilter: string): string;
begin
  if FRetornarContaCPFCommand = nil then
  begin
    FRetornarContaCPFCommand := FConnection.CreateCommand;
    FRetornarContaCPFCommand.RequestType := 'GET';
    FRetornarContaCPFCommand.Text := 'TServerMethods1.RetornarContaCPF';
    FRetornarContaCPFCommand.Prepare(TServerMethods1_RetornarContaCPF);
  end;
  FRetornarContaCPFCommand.Parameters[0].Value.SetWideString(arquivo);
  FRetornarContaCPFCommand.Parameters[1].Value.SetWideString(cpf);
  FRetornarContaCPFCommand.Execute(ARequestFilter);
  Result := FRetornarContaCPFCommand.Parameters[2].Value.GetWideString;
end;

function TServerMethods1Client.RetornarContaNome(arquivo: string; nome: string; sobrenome: string; const ARequestFilter: string): string;
begin
  if FRetornarContaNomeCommand = nil then
  begin
    FRetornarContaNomeCommand := FConnection.CreateCommand;
    FRetornarContaNomeCommand.RequestType := 'GET';
    FRetornarContaNomeCommand.Text := 'TServerMethods1.RetornarContaNome';
    FRetornarContaNomeCommand.Prepare(TServerMethods1_RetornarContaNome);
  end;
  FRetornarContaNomeCommand.Parameters[0].Value.SetWideString(arquivo);
  FRetornarContaNomeCommand.Parameters[1].Value.SetWideString(nome);
  FRetornarContaNomeCommand.Parameters[2].Value.SetWideString(sobrenome);
  FRetornarContaNomeCommand.Execute(ARequestFilter);
  Result := FRetornarContaNomeCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.RetornarContaAux(arquivo: string; contaaux: string; const ARequestFilter: string): string;
begin
  if FRetornarContaAuxCommand = nil then
  begin
    FRetornarContaAuxCommand := FConnection.CreateCommand;
    FRetornarContaAuxCommand.RequestType := 'GET';
    FRetornarContaAuxCommand.Text := 'TServerMethods1.RetornarContaAux';
    FRetornarContaAuxCommand.Prepare(TServerMethods1_RetornarContaAux);
  end;
  FRetornarContaAuxCommand.Parameters[0].Value.SetWideString(arquivo);
  FRetornarContaAuxCommand.Parameters[1].Value.SetWideString(contaaux);
  FRetornarContaAuxCommand.Execute(ARequestFilter);
  Result := FRetornarContaAuxCommand.Parameters[2].Value.GetWideString;
end;

function TServerMethods1Client.RetornarContaEmpresa(arquivo: string; conta: Int64; const ARequestFilter: string): string;
begin
  if FRetornarContaEmpresaCommand = nil then
  begin
    FRetornarContaEmpresaCommand := FConnection.CreateCommand;
    FRetornarContaEmpresaCommand.RequestType := 'GET';
    FRetornarContaEmpresaCommand.Text := 'TServerMethods1.RetornarContaEmpresa';
    FRetornarContaEmpresaCommand.Prepare(TServerMethods1_RetornarContaEmpresa);
  end;
  FRetornarContaEmpresaCommand.Parameters[0].Value.SetWideString(arquivo);
  FRetornarContaEmpresaCommand.Parameters[1].Value.SetInt64(conta);
  FRetornarContaEmpresaCommand.Execute(ARequestFilter);
  Result := FRetornarContaEmpresaCommand.Parameters[2].Value.GetWideString;
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
  FRetornarParametroADCommand.DisposeOf;
  FGravarLOGADCommand.DisposeOf;
  FRetornarDadosBancoCommand.DisposeOf;
  FPersistirBancoCommand.DisposeOf;
  FBaixarArquivoCommand.DisposeOf;
  FBaixarArquivoCommand_Cache.DisposeOf;
  FfazerumtesteCommand.DisposeOf;
  FLimpaMemoriaCommand.DisposeOf;
  FValidarADCommand.DisposeOf;
  FRetornarContaCartaoCommand.DisposeOf;
  FRetornarContaCPFCommand.DisposeOf;
  FRetornarContaNomeCommand.DisposeOf;
  FRetornarContaAuxCommand.DisposeOf;
  FRetornarContaEmpresaCommand.DisposeOf;
  inherited;
end;

end.

