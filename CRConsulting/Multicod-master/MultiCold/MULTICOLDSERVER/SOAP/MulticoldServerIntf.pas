{ Invokable interface IMulticoldServer }

unit MulticoldServerIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type

  { Invokable interfaces must derive from IInvokable }
  IMulticoldServer = interface(IInvokable)
  ['{F574303D-A912-4B90-A273-538BD0FAE800}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function LogIn(Const Usuario, Senha: WideString; out ConnectionID: Integer): WideString; stdCall;
    function GetRelatorio(const Usuario, Senha: WideString; ConnectionID: Integer; const ListaCodRel: WideString; var FullPaths: WideString): WideString; stdCall;
//    function GetPagina(const Usuario, Senha: WideString; ConnectionID: Integer; const Relatorio: WideString; PagNum: Integer; out QtdBytes: Integer; out Pagina: OleVariant): WideString; stdCall;
    function GetPagina(const Usuario, Senha: WideString; ConnectionID: Integer; const Relatorio: WideString; PagNum: Integer; out QtdBytes: Integer; out Pagina: WideString): WideString; stdCall;
    function AbreRelatorio(const Usuario: WideString; const Senha: WideString; ConnectionID: Integer; const FullPath: WideString; out QtdPaginas: Integer; out StrCampos: WideString; out Rel64: Byte; out Rel133: Byte; out CmprBrncs: Byte): Integer; stdCall;
    function ExecutaQueryFacil(const comandoSql: WideString; const PathDB: WideString; const eBDE: Boolean):widestring; stdCall;
    function ExecutaNovaQueryFacil(const gridXML, fileName, usuario : WideString; var mensagem, xmlData : WideString): boolean; stdCall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IMulticoldServer));

end.
