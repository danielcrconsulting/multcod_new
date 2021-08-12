unit MultiColdServer_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 29/10/10 23:03:30 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Arquivos de programas\Borland\Delphi7\Projects\MultiCold\MULTICOLDSERVER\MultiColdServer.tlb (1)
// LIBID: {D0B9EF00-43A8-11D4-851A-D6944F25B66A}
// LCID: 0
// Helpfile: 
// HelpString: MultiColdServer Library
// DepndLst: 
//   (1) v1.0 Midas, (C:\WINDOWS\system32\midas.dll)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, Midas, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  MultiColdServerMajorVersion = 1;
  MultiColdServerMinorVersion = 0;

  LIBID_MultiColdServer: TGUID = '{D0B9EF00-43A8-11D4-851A-D6944F25B66A}';

  IID_IMultiColdDataServer: TGUID = '{D0B9EF01-43A8-11D4-851A-D6944F25B66A}';
  CLASS_MultiColdDataServer: TGUID = '{D0B9EF03-43A8-11D4-851A-D6944F25B66A}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IMultiColdDataServer = interface;
  IMultiColdDataServerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MultiColdDataServer = IMultiColdDataServer;


// *********************************************************************//
// Interface: IMultiColdDataServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D0B9EF01-43A8-11D4-851A-D6944F25B66A}
// *********************************************************************//
  IMultiColdDataServer = interface(IAppServer)
    ['{D0B9EF01-43A8-11D4-851A-D6944F25B66A}']
    function GetRelatorio(const Usuario: WideString; const Senha: WideString; 
                          ConnectionID: Integer; const ListaCodRel: WideString; 
                          var FullPaths: WideString): WideString; safecall;
    function GetPagina(const Usuario: WideString; const Senha: WideString; ConnectionID: Integer; 
                       const Relatorio: WideString; PagNum: Integer; out QtdBytes: Integer; 
                       out Pagina: OleVariant): WideString; safecall;
    function LogIn(const Usuario: WideString; const Senha: WideString; out ConnectionID: Integer): WideString; safecall;
    function AbreRelatorio(const Usuario: WideString; const Senha: WideString; 
                           ConnectionID: Integer; const FullPath: WideString; 
                           out QtdPaginas: Integer; out StrCampos: WideString; out Rel64: Byte; 
                           out Rel133: Byte; out CmprBrncs: Byte): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IMultiColdDataServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D0B9EF01-43A8-11D4-851A-D6944F25B66A}
// *********************************************************************//
  IMultiColdDataServerDisp = dispinterface
    ['{D0B9EF01-43A8-11D4-851A-D6944F25B66A}']
    function GetRelatorio(const Usuario: WideString; const Senha: WideString; 
                          ConnectionID: Integer; const ListaCodRel: WideString; 
                          var FullPaths: WideString): WideString; dispid 1610809344;
    function GetPagina(const Usuario: WideString; const Senha: WideString; ConnectionID: Integer; 
                       const Relatorio: WideString; PagNum: Integer; out QtdBytes: Integer; 
                       out Pagina: OleVariant): WideString; dispid 2;
    function LogIn(const Usuario: WideString; const Senha: WideString; out ConnectionID: Integer): WideString; dispid 3;
    function AbreRelatorio(const Usuario: WideString; const Senha: WideString; 
                           ConnectionID: Integer; const FullPath: WideString; 
                           out QtdPaginas: Integer; out StrCampos: WideString; out Rel64: Byte; 
                           out Rel133: Byte; out CmprBrncs: Byte): Integer; dispid 4;
    function AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; MaxErrors: Integer; 
                             out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant; dispid 20000000;
    function AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer; 
                           Options: Integer; const CommandText: WideString; var Params: OleVariant; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000001;
    function AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant; dispid 20000002;
    function AS_GetProviderNames: OleVariant; dispid 20000003;
    function AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant; dispid 20000004;
    function AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000005;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                         var Params: OleVariant; var OwnerData: OleVariant); dispid 20000006;
  end;

// *********************************************************************//
// The Class CoMultiColdDataServer provides a Create and CreateRemote method to          
// create instances of the default interface IMultiColdDataServer exposed by              
// the CoClass MultiColdDataServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMultiColdDataServer = class
    class function Create: IMultiColdDataServer;
    class function CreateRemote(const MachineName: string): IMultiColdDataServer;
  end;

implementation

uses ComObj;

class function CoMultiColdDataServer.Create: IMultiColdDataServer;
begin
  Result := CreateComObject(CLASS_MultiColdDataServer) as IMultiColdDataServer;
end;

class function CoMultiColdDataServer.CreateRemote(const MachineName: string): IMultiColdDataServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MultiColdDataServer) as IMultiColdDataServer;
end;

end.
