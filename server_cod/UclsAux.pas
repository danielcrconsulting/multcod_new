unit UclsAux;

interface

uses Soap.InvokeRegistry;

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
  TTipoBuscaSequencial_new = (tbNormal_new, tbPesquisa_new);

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
    FIndex : String;
    FPagIni: Integer;
    FPagFin: Integer;
    FLinIni: Integer;
    FLinFin: Integer;
    FColuna: Integer;
    FValorBusca: WideString;
    FTipoBusca: Integer;
    FQueryFacil: QueryFacilArrayDTO;
    FConectorQuery: String;
  published
    property index:      String                read FIndex  write FIndex;
    property PagIni:     Integer               read FPagIni write FPagIni;
    property PagFin:     Integer               read FPagFin write FPagFin;
    property LinIni:     Integer               read FLinIni write FLinIni;
    property LinFin:     Integer               read FLinFin write FLinFin;
    property Coluna:     Integer               read FColuna write FColuna;
    property ValorBusca: WideString            read FValorBusca write FValorBusca;
    property TipoBusca:  Integer               read FTipoBusca write FTipoBusca;
    property QueryFacil: QueryFacilArrayDTO    read FQueryFacil write FQueryFacil;
    property ConectorQuery: String read FConectorQuery write FConectorQuery;
  end;

  TBuscaSequencialDTO_M = class(TRemotable)
  private
    FIndex : String;
    FPagIni: Integer;
    FPagFin: Integer;
    FLinIni: Integer;
    FLinFin: Integer;
    FColuna: Integer;
    FValorBusca: WideString;
    FTipoBusca: Integer;
    FQueryFacil: QueryFacilArrayDTO;
    FConectorQuery: String;
  published
    property index:      String                read FIndex  write FIndex;
    property PagIni:     Integer               read FPagIni write FPagIni;
    property PagFin:     Integer               read FPagFin write FPagFin;
    property LinIni:     Integer               read FLinIni write FLinIni;
    property LinFin:     Integer               read FLinFin write FLinFin;
    property Coluna:     Integer               read FColuna write FColuna;
    property ValorBusca: WideString            read FValorBusca write FValorBusca;
    property TipoBusca:  Integer               read FTipoBusca write FTipoBusca;
    property QueryFacil: QueryFacilArrayDTO    read FQueryFacil write FQueryFacil;
    property ConectorQuery: String read FConectorQuery write FConectorQuery;
  end;

  TResultadoBuscaSequencial = Class(TObject)
    strict private
      FLocalizou: Boolean;
      FLinhaLocalizada: Integer;
      FColunaLocalizada: Integer;
      FPagina: WideString;
      FIndexPagLoc: Integer;
      FQtdeTotalPag: Integer;
      FIndexPagLocPesq: Integer;
      FQtdeBytesPag: Integer;
    published
      property Localizou: Boolean read FLocalizou write FLocalizou;
      property LinhaLocalizada: Integer read FLinhaLocalizada write FLinhaLocalizada;
      property ColunaLocalizada: Integer read FColunaLocalizada write FColunaLocalizada;
      property Pagina: WideString read FPagina write FPagina;
      property IndexPagLoc: Integer read FIndexPagLoc write FIndexPagLoc;
      property IndexPagLocPesq: Integer read FIndexPagLocPesq write FIndexPagLocPesq;
      property QtdeTotalPag: Integer read FQtdeTotalPag write FQtdeTotalPag;
      property QtdeBytesPag: Integer read FQtdeBytesPag write FQtdeBytesPag;
    End;

  TBuscaSequencial = Class(TObject)
    strict protected
      //FMulticoldManager: TMulticoldManager;
      FPagIni,
      FPagFin,
      FLinIni,
      FLinFin,
      FColuna : Integer;
      FValorBusca: WideString;
      FTipoBusca: TTipoBuscaSequencial_new;
    public
      property PagIni: Integer read FPagIni write FPagIni;
      property PagFin: Integer read FPagFin write FPagFin;
      property LinIni: Integer read FLinIni write FLinIni;
      property LinFin: Integer read FLinFin write FLinFin;
      property Coluna: Integer read FColuna write FColuna;
      property ValorBusca: WideString read FValorBusca write FValorBusca;
      property TipoBusca: TTipoBuscaSequencial_new read FTipoBusca write FTipoBusca;

      function ExecutarBusca : TResultadoBuscaSequencial; virtual; abstract;
      //Constructor Create(MulticoldManager: TMulticoldManager); virtual;
    End;


implementation

{ TBuscaSequencial }


end.
