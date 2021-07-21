// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost/multicold/Project1.dll/wsdl/ITeste
// Encoding : utf-8
// Version  : 1.0
// (15/4/2013 01:42:57 - 1.33.2.5)
// ************************************************************************ //

unit ITeste1;

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


  // ************************************************************************ //
  // Namespace : urn:TesteIntf-ITeste
  // soapAction: urn:TesteIntf-ITeste#GetRelatorio
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // binding   : ITestebinding
  // service   : ITesteservice
  // port      : ITestePort
  // URL       : http://localhost/multicold/Project1.dll/soap/ITeste
  // ************************************************************************ //
  ITeste = interface(IInvokable)
  ['{391FD459-173F-DD26-79D8-8EE5FB1C2255}']
    function  GetRelatorio(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const ListaCodRel: WideString; var FullPaths: WideString): WideString; stdcall;
  end;

function GetITeste(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ITeste;


implementation

function GetITeste(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ITeste;
const
  defWSDL = 'http://localhost/multicold/Project1.dll/wsdl/ITeste';
  defURL  = 'http://localhost/multicold/Project1.dll/soap/ITeste';
  defSvc  = 'ITesteservice';
  defPrt  = 'ITestePort';
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
    Result := (RIO as ITeste);
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
  InvRegistry.RegisterInterface(TypeInfo(ITeste), 'urn:TesteIntf-ITeste', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ITeste), 'urn:TesteIntf-ITeste#GetRelatorio');

end. 