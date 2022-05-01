// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8080/wsdl/IMulticoldServer
//  >Import : http://localhost:8080/wsdl/IMulticoldServer>0
//  >Import : http://localhost:8080/wsdl/IMulticoldServer>1
// Codegen  : [wfMapStringsToWideStrings+]
// Version  : 1.0
// (29/05/2020 01:48:59 - - $Rev: 96726 $)
// ************************************************************************ //

unit IMulticoldServer1;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:unsignedByte    - "http://www.w3.org/2001/XMLSchema"[]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  TResultadoBuscaSequencialDTO = class;         { "urn:UBuscaSequencial"[GblCplx] }
  TQueryFacilDTO       = class;                 { "urn:UBuscaSequencial"[GblCplx] }
  TBuscaSequencialDTO  = class;                 { "urn:UBuscaSequencial"[GblCplx] }

  {$SCOPEDENUMS ON}
  { "urn:UMulticoldReport"[GblSmpl] }
  TTipoBuscaSequencial = (tbNormal, tbPesquisa);

  {$SCOPEDENUMS OFF}

  QueryFacilArrayDTO = array of TQueryFacilDTO;   { "urn:UBuscaSequencial"[GblCplx] }


  // ************************************************************************ //
  // XML       : TResultadoBuscaSequencialDTO, global, <complexType>
  // Namespace : urn:UBuscaSequencial
  // ************************************************************************ //
  TResultadoBuscaSequencialDTO = class(TRemotable)
  private
    FLocalizou: Boolean;
    FLinhaLocalizada: Integer;
    FColunaLocalizada: Integer;
    FPagina: WideString;
    FIndexPagLoc: Integer;
    FIndexPagLocPesq: Integer;
    FQtdeTotalPag: Integer;
    FQtdeBytesPag: Integer;
  published
    property Localizou:        Boolean     read FLocalizou write FLocalizou;
    property LinhaLocalizada:  Integer     read FLinhaLocalizada write FLinhaLocalizada;
    property ColunaLocalizada: Integer     read FColunaLocalizada write FColunaLocalizada;
    property Pagina:           WideString  read FPagina write FPagina;
    property IndexPagLoc:      Integer     read FIndexPagLoc write FIndexPagLoc;
    property IndexPagLocPesq: Integer read FIndexPagLocPesq write FIndexPagLocPesq;
    property QtdeTotalPag:     Integer     read FQtdeTotalPag write FQtdeTotalPag;
    property QtdeBytesPag:     Integer     read FQtdeBytesPag write FQtdeBytesPag;
  end;



  // ************************************************************************ //
  // XML       : TQueryFacilDTO, global, <complexType>
  // Namespace : urn:UBuscaSequencial
  // ************************************************************************ //
  TQueryFacilDTO = class(TRemotable)
  private
    FIndex_: WideString;
    FCampo: WideString;
    FOperador: Integer;
    FValor: WideString;
    FConector: Integer;
  published
    property Index_:   WideString  read FIndex_ write FIndex_;
    property Campo:    WideString  read FCampo write FCampo;
    property Operador: Integer     read FOperador write FOperador;
    property Valor:    WideString  read FValor write FValor;
    property Conector: Integer     read FConector write FConector;
  end;



  // ************************************************************************ //
  // XML       : TBuscaSequencialDTO, global, <complexType>
  // Namespace : urn:UBuscaSequencial
  // ************************************************************************ //
  TBuscaSequencialDTO = class(TRemotable)
  private
    FPagIni: Integer;
    FPagFin: Integer;
    FLinIni: Integer;
    FLinFin: Integer;
    FColuna: Integer;
    FValorBusca: WideString;
    FTipoBusca: TTipoBuscaSequencial;
    FQueryFacil: QueryFacilArrayDTO;
    FConectorQuery: String;
  public
    destructor Destroy; override;
  published
    property PagIni:     Integer               read FPagIni write FPagIni;
    property PagFin:     Integer               read FPagFin write FPagFin;
    property LinIni:     Integer               read FLinIni write FLinIni;
    property LinFin:     Integer               read FLinFin write FLinFin;
    property Coluna:     Integer               read FColuna write FColuna;
    property ValorBusca: WideString            read FValorBusca write FValorBusca;
    property TipoBusca:  TTipoBuscaSequencial  read FTipoBusca write FTipoBusca;
    property QueryFacil: QueryFacilArrayDTO    read FQueryFacil write FQueryFacil;
    property ConectorQuery: String read FConectorQuery write FConectorQuery;
  end;


  // ************************************************************************ //
  // Namespace : urn:MulticoldServerIntf-IMulticoldServer
  // soapAction: urn:MulticoldServerIntf-IMulticoldServer#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IMulticoldServerbinding
  // service   : IMulticoldServerservice
  // port      : IMulticoldServerPort
  // URL       : http://localhost:8080/soap/IMulticoldServer
  // ************************************************************************ //
  IMulticoldServer = interface(IInvokable)
  ['{F8F07BFF-8646-BE44-255F-DB2F03796ACB}']
    function  LogIn(const Usuario: WideString; const Senha: WideString; out ConnectionID: Integer): WideString; stdcall;
    function  GetRelatorio(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const ListaCodRel: WideString; var FullPaths: WideString): WideString; stdcall;
    function  GetPagina(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const Relatorio: WideString; const PagNum: Integer; out QtdBytes: Integer; 
                        out Pagina: WideString): WideString; stdcall;
    function  AbreRelatorio(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const FullPath: WideString; out QtdPaginas: Integer; out StrCampos: WideString; 
                            out Rel64: Byte; out Rel133: Byte; out CmprBrncs: Byte): Integer; stdcall;
    function  ExecutaQueryFacil(const comandoSql: WideString; const PathDB: WideString; const eBDE: Boolean): WideString; stdcall;
    function  ExecutaNovaQueryFacil(const gridXML: WideString; const fileName: WideString; const usuario: WideString; var mensagem: WideString; var xmlData: WideString): Boolean; stdcall;
    function  BuscaSequencial(const Usuario: WideString; const Senha: WideString; const ConnectionID: Integer; const Relatorio: WideString; const buscaSequencial: TBuscaSequencialDTO): TResultadoBuscaSequencialDTO; stdcall;
    function  teste(const p1: WideString; const p2: Integer): WideString; stdcall;
  end;

function GetIMulticoldServer(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IMulticoldServer;


implementation
  uses System.SysUtils;

function GetIMulticoldServer(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IMulticoldServer;
const
  defWSDL = 'http://localhost:8080/wsdl/IMulticoldServer';
  defURL  = 'http://localhost:8080/soap/IMulticoldServer';
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


destructor TBuscaSequencialDTO.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FQueryFacil)-1 do
    System.SysUtils.FreeAndNil(FQueryFacil[I]);
  System.SetLength(FQueryFacil, 0);
  inherited Destroy;
end;

initialization
  { IMulticoldServer }
  InvRegistry.RegisterInterface(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer#%operationName%');
  RemClassRegistry.RegisterXSInfo(TypeInfo(QueryFacilArrayDTO), 'urn:UBuscaSequencial', 'QueryFacilArrayDTO');
  RemClassRegistry.RegisterXSClass(TResultadoBuscaSequencialDTO, 'urn:UBuscaSequencial', 'TResultadoBuscaSequencialDTO');
  RemClassRegistry.RegisterXSClass(TQueryFacilDTO, 'urn:UBuscaSequencial', 'TQueryFacilDTO');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(TQueryFacilDTO), 'Index_', '[ExtName="Index"]');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TTipoBuscaSequencial), 'urn:UMulticoldReport', 'TTipoBuscaSequencial');
  RemClassRegistry.RegisterXSClass(TBuscaSequencialDTO, 'urn:UBuscaSequencial', 'TBuscaSequencialDTO');

end.