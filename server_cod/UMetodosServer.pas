unit UMetodosServer;

interface

uses
  System.SysUtils, System.Classes, ClientClassesUnit2,System.NetEncoding,
    Datasnap.DSClientRest, System.IniFiles;

type
  clsMetodosServer = class
  private
    DSRestConnection1: TDSRestConnection;
    FInstanceOwner: Boolean;
    FServerMethodsPrincipalClient: TServerMethods1Client;

    function GetServerMethodsPrincipalClient: TServerMethods1Client;

    { Private declarations }
  public

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Configurar;

    function TestarConnect(var ErrorMsg: String): Boolean;
    function RetornarConexao: String;

    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property ServerMethodsPrincipalClient: TServerMethods1Client read GetServerMethodsPrincipalClient write FServerMethodsPrincipalClient;
  end;

implementation

procedure clsMetodosServer.Configurar;
var
  ArquivoINI: TIniFile;
  host, port : String;
begin
  try
    if FileExists(GetCurrentDir + '/conf.ini') then
    begin
      ArquivoINI := TIniFile.Create(GetCurrentDir + '/conf.ini');

      host := ArquivoINI.ReadString('configuracoes', 'server',    '');
      port := ArquivoINI.ReadString('configuracoes', 'port',      '');

      DSRestConnection1.Host := host;
      DSRestConnection1.Port := StrToInt(port);
    end;
  except
    on e: exception do begin
      raise Exception.Create('Erro ao configurar: ' + e.Message);
    end;
  end;
end;


function clsMetodosServer.TestarConnect(var ErrorMsg: String): Boolean;
var
  returned: String;
begin
  Result := True;
  try
    DSRestConnection1.TestConnection([toNoLoginPrompt]);
  except
  on e: exception do
    begin
      Result := False;
      ErrorMsg := e.Message;
    end
  end;
end;

constructor clsMetodosServer.Create(AOwner: TComponent);
begin
  FInstanceOwner := True;
  DSRestConnection1 := TDSRestConnection.Create(nil);
end;

destructor clsMetodosServer.Destroy;
begin
  FServerMethodsPrincipalClient := nil;
  FServerMethodsPrincipalClient.DisposeOf;
  inherited;
end;

function clsMetodosServer.GetServerMethodsPrincipalClient: TServerMethods1Client;
begin
  if FServerMethodsPrincipalClient = nil then
    FServerMethodsPrincipalClient:= TServerMethods1Client.Create(DSRestConnection1, FInstanceOwner);
  Result := FServerMethodsPrincipalClient;
end;

function clsMetodosServer.RetornarConexao: String;
begin
  Result := DSRestConnection1.Connection;
end;

end.
