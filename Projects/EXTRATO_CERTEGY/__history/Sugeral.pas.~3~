Unit Sugeral;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, {DBTables,} IniFiles, SuTypGer, IBX.IBDatabase, IBX.IBSQL, IBX.IBCustomDataSet,
  IBX.IBTable, IBX.IBQuery, StdCtrls, Data.DBXFirebird, Data.SqlExpr{, dfPdf}, uMetodosServer;

Type
  TFormGeral = Class(TForm)
    TableLogProc: TIBTable;
    TableProtocolo: TIBTable;
    TableUsuRel: TIBTable;
    TableDFN: TIBTable;
    TableGUsuarios: TIBTable;
    TableUsuarios: TIBTable;
    TableSubGruposDFN: TIBTable;
    TableGruposDFN: TIBTable;
    TableTemp: TIBTable;
    IBSQLAux1: TIBSQL;
    TableProd: TIBTable;
    TableAux2: TIBTable;
    TableAux1: TIBTable;
    IBAdmRemotoTransaction: TIBTransaction;
    IBAdmRemotoDatabase: TIBDatabase;
    IBLogRemotoTransaction: TIBTransaction;
    IBLogRemotoDatabase: TIBDatabase;
    QueryLocal2: TIBQuery;
    QueryLocal1: TIBQuery;
    QueryProd: TIBQuery;
    QueryAux2: TIBQuery;
    QueryAux1: TIBQuery;
    IBQueryAuxL1: TIBQuery;
    IBQueryInsertProtocolo: TIBQuery;
    IBQueryInsertLogProc: TIBQuery;
    IBProtocoloTransaction: TIBTransaction;
    procedure FormCreate(Sender: TObject);
    procedure TableDFNBeforePost(DataSet: TDataSet);
    procedure TableDFNAfterScroll(DataSet: TDataSet);
    procedure TableDFNAfterInsert(DataSet: TDataSet);
    procedure TableGruposDFNAfterPost(DataSet: TDataSet);
    procedure TableGUsuariosAfterPost(DataSet: TDataSet);
  Private
    { Private declarations }
  Public
    { Public declarations }
  Procedure MapeiaBase;
  Procedure InsereLog(Arquivo,Mensagem : AnsiString; Var SeqLog : Integer; Agora : TDateTime);
  Procedure Conecta;
  Procedure IniciaTransacaoLog;
  End;

Procedure LerIni(TheFileName : AnsiString);

Const
// Geral
  ScreenWidth: LongInt = 800;   { I designed my form in 800x600 mode. }
  ScreenHeight: LongInt = 600;

  TamContBmg = 347;
  TamCartBmg = 91;
  TamExtrBmg = 302;
  TamDetexBmg = 156;

// Analisador
  TamCodRel = 15;

// Index
  BufSize = 1024*1024; // Um mega de buffer out....

Type
// Geral

  TgIndiceNumGer = Record
                   Valor,            // Cpf, Cgc, Cartão
                   Conta : Int64;
                   End;

  TgIndiceNumCnt = Record
                   Conta : Int64;
                   Ciclo : Byte;
                   PosIni : Int64;
                   Tam : Word;
                   End;

  TgIndiceNome = Record
                 Valor : TgArr040;
                 Conta : Int64;
                 End;

  TgArqIndiceNumGer = File Of TgIndiceNumGer;
  TgArqIndiceNumCnt = File Of TgIndiceNumCnt;
  TgArqIndiceNome = File Of TgIndiceNome;


TgUnsrExtr = Record
             Org                       : TgArr003;  //1
             Logo                      : TgArr003;  //4
             Conta                     : TgArr016;  //7
             AnoMes                    : TgArr006;  //23
             Ciclo                     : TgArr002;  //29
             VlrLimAtu                 : TgArr014;  //31
             VlrLimSaque               : TgArr014;  //45
             DataVencto                : TgArr008;  //59
             VlrSaldoAtu               : TgArr014;  //67  INVERTIDO A PEDIDO DE MACIEL
             VlrSaldoAtuConvert        : TgArr014;  //81
             VlrSaldoExtrAnter         : TgArr014;  //95
             VlrAmortPagtos            : TgArr014;  //109
             VlrEncargos               : TgArr014;  //123
             VlrTaxasAnuid             : TgArr014;  //137
             VlrAjustes1               : TgArr014;  //151
             VlrCompras                : TgArr014;  //165
             VlrParcFixas              : TgArr014;  //179
             VlrPremioSeguro           : TgArr014;  //193
             VlrSaldoAtual             : TgArr014;  //207
             VlrCota                   : TgArr009;
             DataCota                  : TgArr008;
             VlrPagtoMinTotal          : TgArr014;
             VlrTaxaJuros              : TgArr008;
             VlrTaxaJurosAtraso        : TgArr008;
             VlrTaxaJurosProxPer       : TgArr008;
             VlrTaxaJurosProxPerAtraso : TgArr008;
             CrLf                      : TgArr002;
             End;

// Registro especial para BMG
TgUnsrExtrBmg = Record
                Sistema                   : TgArr002;
                Corp                      : TgArr003;
                SubProduto                : TgArr003;
                Produto                   : TgArr003;
                Conta                     : TgArr016;
                AnoMes                    : TgArr006;
                Ciclo                     : TgArr002;
                VlrLimAtu                 : TgArr014;
                VlrLimSaque               : TgArr014;
                DataVencto                : TgArr008;
                VlrSaldoAtu               : TgArr014;
                VlrSaldoAtuConvert        : TgArr014;
                VlrSaldoExtrAnter         : TgArr014;
                VlrAmortPagtos            : TgArr014;
                VlrEncargos               : TgArr014;
                VlrTaxasAnuid             : TgArr014;
                VlrAjustes1               : TgArr014;
                VlrCompras                : TgArr014;
                VlrParcFixas              : TgArr014;
                VlrPremioSeguro           : TgArr014;
                VlrSaldoAtual             : TgArr014;
                VlrCota                   : TgArr009;
                DataCota                  : TgArr008;
                VlrPagtoMinTotal          : TgArr014;
                VlrTaxaJuros              : TgArr008;
                VlrTaxaJurosAtraso        : TgArr008;
                VlrTaxaJurosProxPer       : TgArr008;
                VlrTaxaJurosProxPerAtraso : TgArr008;
                VlrPrevia                 : TgArr014;
                CrLf                      : TgArr002;
                End;

// Registro especial para o Real Conquista - EDS
TgUnsrExtrRQ = Record
                     Org                       : TgArr003;
                     Logo                      : TgArr003;
                     Conta                     : TgArr016;
                     AnoMes                    : TgArr006;
                     Ciclo                     : TgArr002;
                     VlrLimAtu                 : TgArr014;
                     VlrLimSaque               : TgArr014;
                     DataVencto                : TgArr008;
                     VlrSaldoAtu               : TgArr014;
                     VlrSaldoAtuConvert        : TgArr014;
                     VlrSaldoExtrAnter         : TgArr014;
                     VlrAmortPagtos            : TgArr014;
                     VlrEncargos               : TgArr014;
                     VlrTaxasAnuid             : TgArr014;
                     VlrAjustes1               : TgArr014;
                     VlrCompras                : TgArr014;
                     VlrParcFixas              : TgArr014;
                     VlrPremioSeguro           : TgArr014;
                     VlrSaldoAtual             : TgArr014;
                     VlrCota                   : TgArr009;
                     DataCota                  : TgArr008;
                     VlrPagtoMinTotal          : TgArr014;
                     VlrTaxaJuros              : TgArr008;
                     VlrTaxaJurosAtraso        : TgArr008;
                     VlrTaxaJurosProxPer       : TgArr008;
                     VlrTaxaJurosProxPerAtraso : TgArr008;
                     IndicaParcelado           : TgArr001; // Específico para Real Conquista
                     VlrFaturaAnterior         : TgArr015; // Específico para Real Conquista
                     OpcaoPagtoAderida         : TgArr015; // Específico para Real Conquista
                     DiferencaDeLancamentos    : TgArr015; // Específico para Real Conquista
                     VlrAcumuladoParcelas      : TgArr015; // Específico para Real Conquista
                     VlrParcelaPagtoOpc1       : TgArr015; // Específico para Real Conquista
                     VlrAPagarOpc1             : TgArr015; // Específico para Real Conquista
                     VlrNaoParcelado           : TgArr015; // Específico para Real Conquista
                     QtdParcelasPagtoOpc2      : TgArr002; // Específico para Real Conquista
                     VlrParcelaPagtoOpc2       : TgArr015; // Específico para Real Conquista
                     VlrAPagarOpc2             : TgArr015; // Específico para Real Conquista
                     TxParcelamentoPagtoOpc2   : TgArr008; // Específico para Real Conquista
                     QtdParcelasPagtoOpc3      : TgArr002; // Específico para Real Conquista
                     VlrParcelaPagtoOpc3       : TgArr015; // Específico para Real Conquista
                     VlrAPagarOpc3             : TgArr015; // Específico para Real Conquista
                     TxParcelamentoPagtoOpc3   : TgArr008; // Específico para Real Conquista
                     QtdParcelasPagtoOpc4      : TgArr002; // Específico para Real Conquista
                     VlrParcelaPagtoOpc4       : TgArr015; // Específico para Real Conquista
                     VlrAPagarOpc4             : TgArr015; // Específico para Real Conquista
                     TxParcelamentoPagtoOpc4   : TgArr008; // Específico para Real Conquista
                     DataUltimoSorteio         : TgArr010; // Específico para Real Conquista // Formato dd/mm/ssaa - Eds não se deu ao trabalho de verificar os padrões do nosso arquivo... paciência ;)
                     NumeroSorteado            : TgArr006; // Específico para Real Conquista
                     DataInicioValidNumSorte   : TgArr010; // Específico para Real Conquista // Formato dd/mm/ssaa - Eds não se deu ao trabalho de verificar os padrões do nosso arquivo... paciência ;)
                     DataFimValidNumSorte      : TgArr010; // Específico para Real Conquista // Formato dd/mm/ssaa - Eds não se deu ao trabalho de verificar os padrões do nosso arquivo... paciência ;)
                     NumeroSorte1              : TgArr006; // Específico para Real Conquista
                     NumeroSorte2              : TgArr006; // Específico para Real Conquista
                     NumeroSorte3              : TgArr006; // Específico para Real Conquista
                     NumeroSorte4              : TgArr006; // Específico para Real Conquista
                     NumeroSerie               : TgArr003; // Específico para Real Conquista
                     MensagemCapitalizacao1    : TgArr051; // Específico para Real Conquista
                     MensagemCapitalizacao2    : TgArr051; // Específico para Real Conquista
                     AnoCorteProgramaAnuidade  : TgArr002; // Específico para Real Conquista
                     VlrMes1                   : TgArr015; // Específico para Real Conquista
                     VlrMes2                   : TgArr015; // Específico para Real Conquista
                     VlrMes3                   : TgArr015; // Específico para Real Conquista
                     VlrMediaTrimestral1       : TgArr015; // Específico para Real Conquista
                     VlrMes4                   : TgArr015; // Específico para Real Conquista
                     VlrMes5                   : TgArr015; // Específico para Real Conquista
                     VlrMes6                   : TgArr015; // Específico para Real Conquista
                     VlrMediaTrimestral2       : TgArr015; // Específico para Real Conquista
                     VlrMes7                   : TgArr015; // Específico para Real Conquista
                     VlrMes8                   : TgArr015; // Específico para Real Conquista
                     VlrMes9                   : TgArr015; // Específico para Real Conquista
                     VlrMediaTrimestral3       : TgArr015; // Específico para Real Conquista
                     VlrMes10                  : TgArr015; // Específico para Real Conquista
                     VlrMes11                  : TgArr015; // Específico para Real Conquista
                     VlrMes12                  : TgArr015; // Específico para Real Conquista
                     VlrMediaTrimestral4       : TgArr015; // Específico para Real Conquista
                     CrLf                      : TgArr002;
                     End;

TgUnsrCart = Record
             Org        : TgArr003; // 1
             Logo       : TgArr003; // 4
             Cartao     : TgArr016; // 7
             Conta      : TgArr016; // 23
             Status     : TgArr002; // 39
             CgcCpf     : TgArr015; // 41
             NomeCartao : TgArr019; // 56
             Titular    : TgArr001; // 75
             TipoConta  : TgArr001; // 76
             CrLf       : TgArr002;
             End;

TgUnsrCartVP = Record
               Org         : TgArr003; // 1
               Logo        : TgArr003; // 4
               Cartao      : TgArr016; // 7
               Conta       : TgArr016;
               Status      : TgArr002;
               CgcCpf      : TgArr015;
               NomeCartao  : TgArr019;
               Titular     : TgArr001;
               TipoConta   : TgArr001;
               CodBloqueio : TgArr001;
               DtBloqueio  : TgArr008;
               CrLf        : TgArr002;
               End;

TgUnsrCartBmg = Record
                Sistema     : TgArr002; // 
                Corp        : TgArr003; //
                SubProduto  : TgArr003; //
                Produto     : TgArr003; //
                Cartao      : TgArr016; //
                Conta       : TgArr016; //
                Status      : TgArr002; //
                CgcCpf      : TgArr015; //
                NomeCartao  : TgArr019; //
                Titular     : TgArr001;
                TipoConta   : TgArr001;
                CodBloqueio : TgArr002;
                DtBloqueio  : TgArr008;
                CrLf        : TgArr002;
                End;

TgUnsrCont = Record
             Org               : TgArr003;  // 1
             Logo              : TgArr003;  // 4
             Conta             : TgArr016;  // 7 0000000002641178
             ContaEmpres       : TgArr016;
             CpfCgc            : TgArr015;
             Status            : TgArr002;
             NomeExt           : TgArr040;
             EndResidenc       : TgArr040;
             EndResidencCompl  : TgArr010;
             EndResidencBairro : TgArr015;
             EndResidencCep    : TgArr008;
             EndResidencCidade : TgArr020;
             EndResidencUf     : TgArr002;
             EndResidencDdd    : TgArr004;
             EndResidencFone   : TgArr008;
             EndResidencRamal  : TgArr004;
             Opc               : TgArr001;
             EndEmpr           : TgArr040;
             EndEmprCompl      : TgArr010;
             EndEmprBairro     : TgArr015;
             EndEmprCep        : TgArr008;
             EndEmprCidade     : TgArr020;
             EndEmprUf         : TgArr002;
             EndEmprDdd        : TgArr004;
             EndEmprFone       : TgArr008;
             EndEmprRamal      : TgArr004;
             TipoConta         : TgArr001;
             CrLf              : TgArr002;
             End;

TgUnsrContBmg = Record
                Sistema           : TgArr002;
                Corp              : TgArr003;
                SubProduto        : TgArr003;
                Produto           : TgArr003;
                Conta             : TgArr016;  
                ContaEmpres       : TgArr016;
                CpfCgc            : TgArr015;
                Status            : TgArr002;
                NomeExt           : TgArr040;
                EndResidenc       : TgArr040;
                EndResidencCompl  : TgArr010;
                EndResidencBairro : TgArr015;
                EndResidencCep    : TgArr008;
                EndResidencCidade : TgArr020;
                EndResidencUf     : TgArr002;
                EndResidencDdd    : TgArr004;
                EndResidencFone   : TgArr008;
                EndResidencRamal  : TgArr004;
                Opc               : TgArr001;
                EndEmpr           : TgArr040;
                EndEmprCompl      : TgArr010;
                EndEmprBairro     : TgArr015;
                EndEmprCep        : TgArr008;
                EndEmprCidade     : TgArr020;
                EndEmprUf         : TgArr002;
                EndEmprDdd        : TgArr004;
                EndEmprFone       : TgArr008;
                EndEmprRamal      : TgArr004;
                TipoConta         : TgArr001;
                DebitoCC          : TgArr001;
                CodBloqueioUm     : TgArr002;
                DtBloqueioUm      : TgArr008;
                ReasonCodeUm      : TgArr003;
                CodBloqueioDois   : TgArr001;
                DtBloqueioDois    : TgArr008;
                CrLf              : TgArr002;
                End;

TgUnsrContVP = Record
               Org               : TgArr003;  // 1
               Logo              : TgArr003;  // 4
               Conta             : TgArr016;  // 7 0000000002641178
               ContaEmpres       : TgArr016;  // 23
               CpfCgc            : TgArr015;  // 39
               Status            : TgArr002;  // 54
               NomeExt           : TgArr040;  // 56
               EndResidenc       : TgArr040;  // 96
               EndResidencCompl  : TgArr010;  // 136
               EndResidencBairro : TgArr015;  // 146
               EndResidencCep    : TgArr008;  // 161
               EndResidencCidade : TgArr020;  // 169
               EndResidencUf     : TgArr002;  // 189
               EndResidencDdd    : TgArr004;  // 191
               EndResidencFone   : TgArr008;  // 195
               EndResidencRamal  : TgArr004;  // 203
               Opc               : TgArr001;  // 207
               EndEmpr           : TgArr040;  // 208
               EndEmprCompl      : TgArr010;  // 248
               EndEmprBairro     : TgArr015;  // 258
               EndEmprCep        : TgArr008;  // 273
               EndEmprCidade     : TgArr020;  // 281
               EndEmprUf         : TgArr002;  // 301
               EndEmprDdd        : TgArr004;  // 303
               EndEmprFone       : TgArr008;  // 307
               EndEmprRamal      : TgArr004;  // 315
               TipoConta         : TgArr001;  // 319
               DebitoCC          : TgArr001;  // 320 01 BYTE FLAG DE DEBITO EM CONTA CORRENTE  ( S / N )
               CodBloqueioUm     : TgArr001;  // 321 01 BYTE CODIGO DE BLOQUEIO UM
               DtBloqueioUm      : TgArr008;  // 322 08 BYTES DATA DO CÓDIGO DE BLOQUEIO UM (AAAAMMDD ) ou zeros
               CodBloqueioDois   : TgArr001;  // 330 01 BYTE CODIGO DE BLOQUEIO DOIS
               DtBloqueioDois    : TgArr008;  // 331 08 BYTES DATA DO CÓDIGO DE BLOQUEIO DOIS (AAAAMMDD ) OU ZEROS..
               CrLf              : TgArr002;  // 339
               End;                           // 341

TgUnsDetex = Record
             Org       : TgArr003;
             Logo      : TgArr003;
             Conta     : TgArr016;
             AnoMes    : TgArr006;
             Ciclo     : TgArr002;
             Cartao    : TgArr016;
             DataTrans : TgArr008;
             Seq       : TgArr003;
             Cartao2   : TgArr003;
             Historico : TgArr039;
             Moeda     : TgArr003;
             MoedaOrig : TgArr012;
             Valor     : TgArr014;
             NumRef    : TgArr023;
             CrLf      : TgArr002;
             End;

TgUnsDetexBmg = Record
                Sistema    : TgArr002;
                Corp       : TgArr003;
                SubProduto : TgArr003;
                Produto    : TgArr003;
                Conta      : TgArr016;
                AnoMes     : TgArr006;
                Ciclo      : TgArr002;
                Cartao     : TgArr016;
                DataTrans  : TgArr008;
                Seq        : TgArr003;
                Cartao2    : TgArr003;
                Historico  : TgArr039;
                Moeda      : TgArr003;
                MoedaOrig  : TgArr012;
                Valor      : TgArr014;
                NumRef     : TgArr023;
                CrLf       : TgArr002;
                End;

TgUnsDetexRQ = Record
               Org       : TgArr003;
               Logo      : TgArr003;
               Conta     : TgArr016;
               AnoMes    : TgArr006;
               Ciclo     : TgArr002;
               Cartao    : TgArr016;
               DataTrans : TgArr008;
               Seq       : TgArr003;
               Cartao2   : TgArr003;
               Historico : TgArr039;
               Moeda     : TgArr003;
               MoedaOrig : TgArr012;
               Valor     : TgArr014;
               NumRef    : TgArr023;
               TipoReg   : TgArr002;
               SeqReg    : TgArr005;
               CrLf      : TgArr002;
               End;

TgStatus = Array[1..6] Of Record
                          Tabela : TIBTable;
                          TActive  : Boolean;
                          RecordNo : Integer;
                          End;

{TgIndiceI64F = Record
               Case Byte Of
                 0 : (Valor : Int64;
                      TipoConta  : TgArr001;
                      PosIni : Int64;
                      Tam : Int64);
                 1 : (Chave : Array[1..17] Of Char;
                      TTam : Int64);
               End;}

TgIndiceI64F = Record
               Valor : Int64;
               TipoConta  : TgArr001;
               PosIni : Int64;
               Tam : Int64;
               End;

TgIndiceNomeCartao = Record
                     Valor : TgArr019;
                     TipoConta : TgArr001;
                     PosIni,
                     Tam : Int64;
                     End;

TgArqIndiceContaCartao = File Of TgIndiceI64F;
TgArqIndiceDetex = File Of TgIndiceI64F;
TgArqIndiceNomeCartao = File Of TgIndiceNomeCartao;

TgRegContComum = Record
                   Case Byte of
                     0 : (ContNormal : TgUnsrCont);
                     1 : (ContVP     : TgUnsrContVP)
                 End;
TgRegCartComum = Record
                   Case Byte of
                     0 : (CartNormal : TgUnsrCart);
                     1 : (CartVP     : TgUnsrCartVP)
                 End;
                 
TgRcb = Record
        RegUnsrExtr : TgUnsrExtr;
        
        LeuConta : Boolean;
        ContaNormal : Boolean;
        RegUnsrCont : TgRegContComum;
        RegUnsrContAux : TgRegContComum;
        RegUnsrContEmpresaDoPortador : TgRegContComum;

        LeuCartao : Boolean;
        CartaoNormal : Boolean;
        RegUnsrCart : TgRegCartComum;
        RegUnsrCartAux : TgRegCartComum;
        End;

//Tratamento de históricos
  TgTrataHist = Record
                StringHist : AnsiString;
                PosIni : Integer;
                SinalEntra,
                SinalSaida,
                Operacao : AnsiString;
                End;
               
//MapaFilU
  TgRegMapa = Array[0..255] of Byte;

Var
// MapaFilU
  RegMapa : TgRegMapa;
  ArqMapa : File Of TgRegMapa;
  Parcial,
  Semaforo : Boolean;
  Agora : TDateTime;
// Geral
  ArTrataHistorico : Array Of TgTrataHist;
  RgRcb : TgRcb;
  OkParaReprocessarGeral,
  Primeira,
  CancelouImpressao,
  Empresarial : Boolean;
  ValAux1,
  ValAux2,
  ValAux3,
  ValAux4,
//  ValAux4_Prox,
  ValAux5,
  ValAux6,
  ValAux7,
  ValAux8,
  ValAux9,
  ValAux10,
  ValAux11,
  ValAux12,
  ValAux13,
  ValAux14,
  ValAux15,
  ValAux16,
  ValAux17,
//  ValAux18,
  ValAux19,
  ValAux20,
  ValAux21,
  ValAux99,
  TotalReal,
  TotalUsd,
  TotalRealGeral,
  TotalUsdGeral : Extended;
  CodOrgSelecionada,
  SubForm,
  Sinal,
  Nome,
  CartaoAnt,
  DataTransAux,
  Operacao,
  NomeDescricaoOrg : AnsiString;
  ArqIndiceContaCartao : TgArqIndiceContaCartao;
  ArqIndiceNomeCartao : TgArqIndiceNomeCartao;
  NArqDetex,
  NArqExtr,
  Detex,
  Extrato,
  DadosDeCartao,
  DadosDeCartaoDePortadores,
  DadosDeConta,
  DadosDeCartaoCpfNome,
  DadosDeContaDePortadores,
  DadosDeExtrato,
  ListaDeArquivosAProcessar : TStringList;
  IndiceConta,
  IndiceCartao : TgIndiceI64F;
  IndiceNomeCartao : TgIndiceNomeCartao;
  BufI,
  BufCmp : Pointer;
  LinCli1,
  LinCli2,
  PathLogo,
  NomeArqIndice,
  NomeArqDat,
  NArqCont,
  NArqCart,
  NArqCpf,
  NArqNome : AnsiString;
  AuxConta,
  NumConta,
  NumCartao,
  NumCpf : Int64;
  TVlrUsdR,
  TVlrOri,
  IAnoMesExtrato,
  XVlrOri,
  XVlrUsdR,
  ICntExtRes,
  CntMnt,
  ILct,
  ILct1,
  ILctEmpr1,
  ILctEmpr2,
  ILctFis1,
  ILctFis2,
  TotalPags,
  PaginaAtu : Integer;
//  Pdf : Tdf6ToPdfConverter;

  TestarFlag : Boolean;
  TheFileName : Array[0..MAX_PATH] Of char;
  MensErros : TStringList;
  pDest : Integer;
  RemoteServer,
  PathServer,
  viIndNew,
  viPgmFiltro,
  viDirTrabApl,
  viPathBaseLocal,
  viServProd,
  viDirEntraFil,
  viDirSaiFil,
  viBackAutoSN,
  viDirBackAuto,
  viExecAutoSN,
  viInterExec,
  viNBufIO,
  viOtimGer,
  viGrupo,
  viSubGrupo : AnsiString;
  DescarregaTotaldoClienteAnterior : Boolean;

  FormGeral: TFormGeral;

  ControleFiltro : Char;

//********************************************************************************** CeA

Implementation

Uses Analisador, Subrug, LogInU;

{$R *.DFM}

Procedure TFormGeral.InsereLog(Arquivo,Mensagem : AnsiString; Var SeqLog : Integer; Agora : TDateTime);
Begin
IBQueryInsertLogProc.Params[0].AsInteger := SeqLog;
Inc(SeqLog);
IBQueryInsertLogProc.Params[1].AsDateTime := Agora;
IBQueryInsertLogProc.Params[2].AsDateTime := Agora;
IBQueryInsertLogProc.Params[3].AsDateTime := Now;
IBQueryInsertLogProc.Params[4].AsDateTime := Now;
IBQueryInsertLogProc.Params[5].AsString := Arquivo;
IBQueryInsertLogProc.Params[6].AsString := Mensagem;

IniciaTransacaoLog;
IBQueryInsertLogProc.ExecSQL;
IBLogRemotoTransaction.Commit;
End;

Procedure TFormGeral.Conecta;

Begin
Screen.Cursor := crSQLWait;

IBAdmRemotoDatabase.Connected := False;
IBLogRemotoDatabase.Connected := False;

Try
  IBAdmRemotoDatabase.Connected := True;
  IBLogRemotoDatabase.Connected := True;
Except
  If viServProd = '' Then
    ShowMessage('Servidor Interbase Local não operacional')
  Else
    ShowMessage('Servidor Interbase remoto não operacional. Operações na produção não serão possíveis');
  End; // Try

Screen.Cursor := crDefault;
End;

Procedure TFormGeral.IniciaTransacaoLog;

Begin
If IBLogRemotoTransaction.InTransaction Then
  IBLogRemotoTransaction.Commit;
IBLogRemotoTransaction.StartTransaction;
End;

Procedure TFormGeral.MapeiaBase;
Begin
IBAdmRemotoDatabase.Connected := False;
IBLogRemotoDatabase.Connected := False;
If (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDADM.EXE') Then
  Begin
  If viServProd = '' Then
    Begin
    IBAdmRemotoDatabase.DatabaseName := viPathBaseLocal+'MASTERCOLD.GDB';
    IBLogRemotoDatabase.DatabaseName := viPathBaseLocal+'MASTERLOG.GDB';
    End
  Else
    Begin
    IBAdmRemotoDatabase.DatabaseName := viServProd+':'+viPathBaseLocal+'MASTERCOLD.GDB';
    IBLogRemotoDatabase.DatabaseName := viServProd+':'+viPathBaseLocal+'MASTERLOG.GDB';
    End
  End
Else
If (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDINDEXA.EXE') Or
   (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDLIMPA.EXE') Then
  Begin
  IBAdmRemotoDatabase.DatabaseName := viPathBaseLocal+'MASTERCOLD.GDB';
  IBLogRemotoDatabase.DatabaseName := viPathBaseLocal+'MASTERLOG.GDB';
  End
Else
If (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLD.EXE') Or
   (UpperCase(ExtractFileName(TheFileName)) = 'CEAEXTRATO.EXE') Or
   (UpperCase(ExtractFileName(TheFileName)) = 'EDSEXTRATO.EXE') Or
   (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDEXTRATO.EXE') Then
  Begin
  IBAdmRemotoDatabase.DatabaseName := PathServer+'MASTERCOLD.GDB';
  IBLogRemotoDatabase.DatabaseName := PathServer+'MASTERLOG.GDB';
  If RemoteServer <> '' Then
    If UpperCase(RemoteServer) <> UpperCase(GetCurrentComputerName) Then
      Begin
      IBAdmRemotoDatabase.DatabaseName := RemoteServer+':'+IBAdmRemotoDatabase.DatabaseName;
      IBLogRemotoDatabase.DatabaseName := RemoteServer+':'+IBLogRemotoDatabase.DatabaseName;
      End;
  End;
End;

Procedure TFormGeral.FormCreate(Sender: TObject);
Begin
MapeiaBase;

If (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDADM.EXE') Then
  Begin
  DefReport.CarregaIni;
  DefReport.FecConfBut.Click;
  End;

DefReport.StatusTabelas[1].Tabela := TableGruposDFN;
DefReport.StatusTabelas[2].Tabela := TableSubGruposDFN;
DefReport.StatusTabelas[3].Tabela := TableUsuarios;
DefReport.StatusTabelas[4].Tabela := TableGUsuarios;
DefReport.StatusTabelas[5].Tabela := TableDFN;
DefReport.StatusTabelas[6].Tabela := TableUsuRel;

End;

Procedure LerIni(TheFileName : AnsiString);
Var
  f : TIniFile;
Begin

f := TIniFile.Create('MasterCold.Ini');

If Not f.SectionExists('Cold') Then
  Begin
  f.WriteString('Cold', 'AppName', ExtractFilePath(TheFileName)+'MasterColdIndexa.Exe');
  f.WriteString('Cold', 'FiltroName', ExtractFilePath(TheFileName)+'MasterColdFiltro.Exe');
  f.WriteString('Cold', 'DirBase', ExtractFilePath(TheFileName));
  f.WriteString('Cold', 'PathLocal', ExtractFilePath(TheFileName)+'DATABASE\');
  f.WriteString('Cold', 'ServProd', '');
  f.WriteString('Filtro','DirEntra','');
  f.WriteString('Filtro','DirSai','');
  f.WriteString('Processa','BackAutoSN','');
  f.WriteString('Processa','DirBackAuto','');
  f.WriteString('Processa','ExecAutoSN','');
  f.WriteString('Processa','InterExec','');
  f.WriteString('Processa','BufIO','3');
  f.WriteString('Processa','OtimGer','N');
  f.WriteString('Nomes', 'Grupo', 'Grupo');
  f.WriteString('Nomes', 'SubGrupo', 'SubGrupo');
  End;

viIndNew := f.ReadString('Cold','AppName','');
viPgmFiltro := f.ReadString('Cold','FiltroName','');
viDirTrabApl := IncludeTrailingPathDelimiter(f.ReadString('Cold','DirBase','')); // Com Back Slash
viPathBaseLocal := IncludeTrailingPathDelimiter(f.ReadString('Cold','PathLocal',''));
viServProd := f.ReadString('Cold','ServProd','');
viDirEntraFil := IncludeTrailingPathDelimiter(f.ReadString('Filtro','DirEntra',''));
viDirSaiFil := IncludeTrailingPathDelimiter(f.ReadString('Filtro','DirSai',''));
viBackAutoSN := UpperCase(f.ReadString('Processa','BackAutoSN',''));
viDirBackAuto := IncludeTrailingPathDelimiter(f.ReadString('Processa','DirBackAuto',''));
viExecAutoSN := UpperCase(f.ReadString('Processa','ExecAutoSN',''));
viInterExec := f.ReadString('Processa','InterExec','');
viNBufIO := f.ReadString('Processa','BufIO','');
viOtimGer := f.ReadString('Processa','OtimGer','');
viGrupo := f.ReadString('Nomes','Grupo','');
viSubGrupo := f.ReadString('Nomes','SubGrupo','');

f.Free;
End;

Procedure TFormGeral.TableDFNBeforePost(DataSet: TDataSet);
Begin
If DefReport.DBCheckAuto.State = cbGrayed Then
  DataSet.FieldByName('CodGrupAuto').AsString := 'F';
If DefReport.DBCheckAuto.Checked Then
  Begin
  If DefReport.DBEditColAuto.Text = '' Then
    Begin
    ShowMessage('Informe o número de colunas da procura automática');
    Abort;
    End;
  If DefReport.DBEditLinAuto.Text = '' Then
    Begin
    ShowMessage('Informe o número de linhas da procura automática');
    Abort;
    End;
  If DefReport.DBEditTamAuto.Text = '' Then
    Begin
    ShowMessage('Informe o tamanho da procura automática');
    Abort;
    End;
  End;
End;

Procedure TFormGeral.TableDFNAfterScroll(DataSet: TDataSet);
Begin
DefReport.DFNShowAuto;
End;

Procedure TFormGeral.TableDFNAfterInsert(DataSet: TDataSet);
Begin
If DefReport.DBCheckAuto.State = cbGrayed Then
  Try
    DataSet.FieldByName('CodGrupAuto').AsString := 'F';
  Except
    End; // Try
DefReport.DFNEscondeCampos;
End;

Procedure TFormGeral.TableGruposDFNAfterPost(DataSet: TDataSet);
Var
  RecPos : Integer;
Begin
RecPos := TableGruposDFN.RecNo;

If TableSubGruposDFN.Active Then
  Begin
  DefReport.DbGrid3.Columns.Items[0].PickList.Clear;
  TableGruposDFN.First;
  While Not TableGruposDFN.Eof Do
    Begin
    DefReport.DbGrid3.Columns.Items[0].PickList.Add(TableGruposDFN.Fields[0].asString);
    TableGruposDFN.Next;
    End;
  End;

If TableDFN.Active Then
  Begin
  DefReport.DbGrid6.Columns[2].PickList.Clear;
  TableGruposDFN.First;
  While Not TableGruposDFN.Eof Do
    Begin
    DefReport.DbGrid6.Columns[2].PickList.Add(TableGruposDFN.Fields[0].asString);
    TableGruposDFN.Next;
    End;
  End;

TableGruposDFN.RecNo := RecPos;
End;

Procedure TFormGeral.TableGUsuariosAfterPost(DataSet: TDataSet);
Var
  RecPos : Integer;
Begin
If TableUsuarios.Active Then
 Begin
  DefReport.DbGrid4.Columns.Items[1].PickList.Clear;
  RecPos := TableGUsuarios.RecNo;
  TableGUsuarios.First;
  While Not TableGUsuarios.Eof Do
    Begin
    DefReport.DbGrid4.Columns.Items[1].PickList.Add(TableGUsuarios.Fields[0].asString);
    TableGUsuarios.Next;
    End;
  TableGUsuarios.RecNo := RecPos;
  End;
End;

Begin
MensErros := TStringList.Create;
//Senha := 'ghqp4908';

FillChar(TheFileName, sizeof(TheFileName), #0);
GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));

If (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDADM.EXE') Or
   (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDINDEXA.EXE') Then
  Begin
  LerIni(TheFileName);
  {$i-}
  ChDir(viDirTrabApl);
  {$i+}
  If IoResult <> 0 Then
    Begin
    ShowMessage('Diretório de Trabalho especificado em MasterCold.Ini é inválido, verifique...');
    Application.Terminate;
    End;
  End
Else
If (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDLIMPA.EXE') Or
   (UpperCase(ExtractFileName(TheFileName)) = 'MASTERCOLDFILTRO.EXE') Then
  LerIni(TheFileName)
Else
  Begin
  viDirTrabApl := ExtractFilePath(TheFileName);
  pDest := Pos('DESTINO',UpperCase(viDirTrabApl));
  If pDest <> 0 Then
    Begin
    viDirTrabApl := Copy(viDirTrabApl,1,pDest-1) + 'Origem\';
    viPathBaseLocal := Copy(viDirTrabApl,1,pDest-1) + 'DataBase\';
    End;
  End;

Detex := TStringList.Create;
Extrato := TStringList.Create;
DadosDeCartao := TStringList.Create;
DadosDeCartaoDePortadores := TStringList.Create;
DadosDeContaDePortadores := TStringList.Create;
DadosDeConta := TStringList.Create;
DadosDeCartaoCpfNome := TStringList.Create;
DadosDeExtrato := TStringList.Create;
ListaDeArquivosAProcessar := TStringList.Create;
NArqDetex := TStringList.Create;
NArqExtr := TStringList.Create;
TestarFlag := True;
ControleFiltro := ' ';
End.
