// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://LocalHost/multicold/MulticoldISAPIServer.dll/wsdl/IMulticoldServer
// Encoding : utf-8
// Version  : 1.0
// (15/4/2013 03:47:26 - 1.33.2.5)
// ************************************************************************ //

unit IMulticoldServer1;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"
  // !:int             - "http://www.w3.org/2001/XMLSchema"
  // !:anyType         - "http://www.w3.org/2001/XMLSchema"
  // !:unsignedByte    - "http://www.w3.org/2001/XMLSchema"
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"


  // ************************************************************************ //
  // Namespace : urn:MulticoldServerIntf-IMulticoldServer
  // soapAction: urn:MulticoldServerIntf-IMulticoldServer#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // binding   : IMulticoldServerbinding
  // service   : IMulticoldServerservice
  // port      : IMulticoldServerPort
  // URL       : http://LocalHost/multicold/MulticoldISAPIServer.dll/soap/IMulticoldServer
  // ************************************************************************ //
  IMulticoldServer = interface(IInvokable)
  ['{F8F07BFF-8646-BE44-255F-DB2F03796ACB}']
    function  LogIn(const Usuario: WideString; const Senha: WideString; out ConnectionID: Integer): WideString; stdcall;
    function  GetRelatorio(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const ListaCodRel: WideString; var FullPaths: WideString): WideString; stdcall;
//    function  GetPagina(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const Relatorio: WideString; const PagNum: Integer; out QtdBytes: Integer; out Pagina: Variant): WideString; stdcall;
    function  GetPagina(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const Relatorio: WideString; const PagNum: Integer; out QtdBytes: Integer; out Pagina: WideString): WideString; stdcall;
    function  AbreRelatorio(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const FullPath: WideString; out QtdPaginas: Integer; out StrCampos: WideString; out Rel64: Byte; out Rel133: Byte; out CmprBrncs: Byte): Integer; stdcall;
    function  ExecutaQueryFacil(const comandoSql: WideString; const PathDB: WideString; const eBDE: Boolean): WideString; stdcall;
    function  ExecutaNovaQueryFacil(const gridXML: WideString; const fileName: WideString; const usuario: WideString; var mensagem: WideString; var xmlData: WideString): Boolean; stdcall;
  end;

function GetIMulticoldServer(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IMulticoldServer;


implementation

function GetIMulticoldServer(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IMulticoldServer;
const
  defWSDL = 'http://192.168.0.106/multicold/MulticoldServer.exe/wsdl/IMulticoldServer';
  defURL  = 'http://192.168.0.106/multicold/MulticoldServer.exe/soap/IMulticoldServer';
  defSvc  = 'IMulticoldServerservice';
  defPrt  = 'IMulticoldServerPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IMulticoldServer);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer#%operationName%');

end. 