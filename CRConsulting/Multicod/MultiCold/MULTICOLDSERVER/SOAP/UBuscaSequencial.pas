unit UBuscaSequencial;

interface

uses Soap.InvokeRegistry, UMulticoldReport;

Type
  TQueryFacilDTO = Class(TRemotable)
  private
    FCampo: WideString;
    FOperador: Integer;
    FValor: WideString;
    FConector: Integer;
    FIndex: WideString;
  published
    property Index: WideString read FIndex write FIndex;
    property Campo: WideString read FCampo write FCampo;
    property Operador: Integer read FOperador write FOperador;
    property Valor: WideString read FValor write FValor;
    property Conector: Integer read FConector write FConector;
  End;

  QueryFacilArrayDTO = array of TQueryFacilDTO;

  TBuscaSequencialDTO = Class(TRemotable)
  private
    FPagIni,
    FPagFin,
    FLinIni,
    FLinFin,
    FColuna : Integer;
    FValorBusca: WideString;
    FTipoBusca: TTipoBuscaSequencial;
    FQueryFacil: QueryFacilArrayDTO;
    FConectorQuery: String;
  published
    property PagIni: Integer read FPagIni write FPagIni;
    property PagFin: Integer read FPagFin write FPagFin;
    property LinIni: Integer read FLinIni write FLinIni;
    property LinFin: Integer read FLinFin write FLinFin;
    property Coluna: Integer read FColuna write FColuna;
    property ValorBusca: WideString read FValorBusca write FValorBusca;
    property TipoBusca: TTipoBuscaSequencial read FTipoBusca write FTipoBusca;
    property QueryFacil: QueryFacilArrayDTO read FQueryFacil write FQueryFacil;
    property ConectorQuery: String read FConectorQuery write FConectorQuery;
  End;

Type
  TResultadoBuscaSequencialDTO = Class(TRemotable)
  private
    FLocalizou: Boolean;
    FLinhaLocalizada: Integer;
    FColunaLocalizada: Integer;
    FPagina: WideString;
    FIndexPagLoc: Integer;
    FQtdeTotalPag: Integer;
    FQtdeBytesPag: Integer;
    FIndexPagLocPesq: Integer;
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

implementation



end.
