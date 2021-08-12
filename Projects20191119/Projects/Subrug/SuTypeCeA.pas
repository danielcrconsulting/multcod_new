Unit SuTypeCeA;

Interface

Uses SuTypGer;

// 1	******************************************************************	Descrição
// 2	*                                                                *
// 3	*     -------------------- NEAR ARCHIVE --------------------     *
// 4	*                                                                *
// 5	*      VAS905 - RECORD LAYOUT SHORT INFORMATIONS
// 6	*                AMNA    AMBS     AMBI    AMED    AMSL
// 7	*                AMPH    AMOS                                    *
// 8	*                                                                *
// 9	*      LENGTH RECORD   - 4338 - 23838 BYTES
// 10	*                                                                *
// 11	******************************************************************
// 12	*

//135	**** RECORD LAYOUT AMED

{$A-} //Pack

Type
  AmedCards = Record // TAMANHO DO REGISTRO [29]
              EdCardNbr        : TgArr019; // Número do cartão
              EdDateOpened     : TgArr007; // Data abertura do cartão
              EdStatus         : TgArr001; // Status do cartão
                                           // ED-ACTIVE            VALUE '0' '1'.
                                           // ED-PERMANENT         VALUE '0'.
                                           // ED-TEMPORARY         VALUE '1'.
                                           // ED-CNS-TRANSFER      VALUE 'T'.
                                           // ED-PURGED            VALUE 'P'.
              EdBlockCode      : TgArr001; // Block-code do cartão
              EdCardHolderFlag : TgArr001; // Titular ou Adicional
                                           // 0 = Titular
                                           // 1 = Adicional
              End;

//163	**** RECORD LAYOUT AMPH

  PhPhtEntry = Record // TAMANHO DO REGISTRO [43]
               PhPhtDate        : TgArr007; // Data dos 6 últimos pagamentos
               PhPhtPmtAmtS     : TgArr001; // Sinal de Valor dos 6 últimos pagamentos
               PhPhtPmtAmt      : TgArr017; // Valor dos 6 últimos pagamentos
               PhPhtOrigPmtAmtS : TgArr001; // Sinal de Valor do pagamento original
               PhPhtOrigPmtAmt  : TgArr017; // Valor do pagamento original
               End;

//229	**** RECORD LAYOUT TXN

  SlTxn = Record // TAMANHO DO REGISTRO [130]
          SlTxnCode          : TgArr003; // Código da transação
          SlEffDate          : TgArr007; // Data da transação
          SlType             : TgArr001; // Tipo da transação (D ou C)
          SlPlan             : TgArr005; // Plano de crédito da transação
          SlPostingFlag      : TgArr002; // Status da transação
          SlLogicMod         : TgArr002; // Módulo de lógica
          SlSource           : TgArr005; // Origem do lote da transação (loja, Visa, MC, etc)
          SlOrigUsAmtS       : TgArr001; // Sinal de Valor em Dolar
          SlOrigUsAmt        : TgArr017; // Valor em Dolar
          SlUsNod            : TgArr001; // Nº de decimais do valor em Dolar
          SlOrigExchRate     : TgArr015; // Valor do Dolar para conversão no momento da transação
          SlOrigExchRateNod  : TgArr001; // Nº de decimais do valor do dolar para conversão no momento da transação
          SlAmountS          : TgArr001; // Sinal de Valor da transação
          SlAmount           : TgArr017; // Valor da transação
          SlMerchantOrg      : TgArr003; // Estabelecimento
          SlMerchantStore    : TgArr009; // Loja
          SlDesc             : TgArr040; // Descrição da transação - origem
          End;


//**********************************************************************************************************


  Vas905 = Record
           Org            : TgArr003;
           Logo           : TgArr003;
           Acct           : TgArr019; //Nº da conta
           DateFile       : TgArr007; //Último dia do Mês que o arquivo foi gerado (aaaaddd)

//23	**** RECORD LAYOUT AMNA - INÍCIO NA POSICAO 33 DO ARQUIVO

           NaOrg          : TgArr003;
           NaAcct         : TgArr019; // Nº do cliente
           NaSsan         : TgArr015; // CPF ou CNPJ
           NaNameEmployer : TgArr040; // Nome do cliente ou razão social
           NaFlagTypeInd  : TgArr001; // 0 = Pessoa Física; 1 = Pessoa Jurídica
           NaAddr1        : TgArr040; // Endereço
           NaAddr2        : TgArr040; // Complemento do endereço
           NaCity         : TgArr030; // Cidade
           NaState        : TgArr003; // Estado
           NaPstlCd       : TgArr010; // CEP
           NaCntryCd      : TgArr003; // País
           NaHomePhone    : TgArr020; // Telefone residencial
           NaEmpPhone     : TgArr020; // Telefone comercial
           NaFaxPhone     : TgArr020; // Fax
           NaMobilePhone  : TgArr020; // Telefone celular
           NaTitle        : TgArr010; // Ramo atividade (pessoa jurídica)
           NaDob          : TgArr007; // Data de nascimento
           NaFiller       : TgArr150; // Filler

//66	**** RECORD LAYOUT AMBS - INÍCIO NA POSIÇÃO 484 DO ARQUIVO

           BsDateOpened   : TgArr007; // Data abertura da conta
           BsIntStatus    : TgArr001; // Status da conta
                                      // BS-IS-NEW             VALUE 'N'.
                                      // BS-IS-ACTIVE          VALUE 'A' 'F' 'S'.
                                      // BS-IS-DORMANT         VALUE 'D'.
                                      // BS-IS-ACTIVE-NO-FRAUD VALUE 'A'.
                                      // BS-IS-NORMAL          VALUE 'A' 'D' 'I' 'M' 'N'.
                                      // BS-IS-CGOFF-NORMAL    VALUE 'Z'.
                                      // BS-IS-FRAUD           VALUE 'F'.
                                      // BS-IS-CONV            VALUE 'B' 'C' 'H' 'V' 'X' 'W'.
                                      // BS-IS-PRE-CGOFF-CONV  VALUE 'W'.
                                      // BS-IS-ACH-VALID       VALUE 'A' 'D' 'Q' 'J' 'M' 'N' 'S'.
                                      // BS-CONV-FRAUD         VALUE 'B'.
                                      // BS-CONV-TRANSFER      VALUE 'C'.
                                      // BS-IS-CLOSED-CONV     VALUE 'H'.
                                      // BS-IS-REG-CONV        VALUE 'V' 'W'.
                                      // BS-IS-CGOFF-CONV      VALUE 'X'.
                                      // BS-IS-XFR             VALUE 'T' 'F' 'L' 'U'.
                                      // BS-IS-CGOFF           VALUE 'Z' 'X'.
                                      // BS-IS-XFR-OUT         VALUE 'R' 'K'.
                                      // BS-IS-XFR-IN          VALUE 'Q' 'J'.
                                      // BS-IS-CLOSED-NORMAL   VALUE '8'.
                                      // BS-IS-CLOSED          VALUE '8' 'H'.
                                      // BS-IS-TO-BE-PURGED    VALUE '9' 'P'.
                                      // BS-IS-PENDING-PURGE   VALUE '9'.
                                      // BS-IS-PURGED          VALUE 'P'.
                                      // BS-IS-INACTIVE        VALUE 'I'.
                                      // BS-IS-REACTIVATE      VALUE 'M' 'J' 'K'.
                                      // BS-IS-REACTIVATE-ONLY VALUE 'M'.
                                      // BS-IS-XFR-NO-FRAUD    VALUE 'T'.
                                      // BS-IS-QTR-RPT-BLK     VALUE 'B' 'C' 'F' 'H' 'P' 'T' 'X' 'Z' '8' '9'.
                                      // BS-IS-TEMP-STATUS     VALUE 'J' 'K' 'M' 'Q' 'R'.
                                      // BS-IS-PRE-CGOFF       VALUE 'S'.
           BsBlockCode1   : TgArr001; // Block-code da conta
           BsBlockCode2   : TgArr001; // Block-code da conta
           BsPmtCycleDue  : TgArr001; // Código delinquência da conta
                                      // BS-PMT-CD-CURR           VALUE 0 1.
                                      // BS-PMT-CD-PAST-DUE       VALUE 2.
                                      // BS-PMT-CD-OVER-30        VALUE 3 THRU 9.
           BsDueDay       : TgArr002; // Dia do vencimento
           BsBillingCycle : TgArr002; // Dia do corte
           BsCrLimS       : TgArr001; // Sinal de Limite de crédito ou renda declarada
           BsCrLim        : TgArr017; // Limite de crédito ou renda declarada
           BsFiller       : TgArr150; // Filler

//135	**** RECORD LAYOUT AMED - INÍCIO NA POSIÇÃO 667 DO ARQUIVO

           AmedData       : Array[1..100] Of AmedCards; // 2900 POSIÇÕES
           EdFiller       : TgArr150; // Filler

//163	**** RECORD LAYOUT AMPH - INÍCIO NA POSIÇÃO 3717 DO ARQUIVO

           PhCurrency     : TgArr003; // Moeda
           PhRecStatus    : TgArr001; // Status do Pagamento
                                      // PH-ACTIVE                VALUE 'A'.
                                      // PH-PURGED                VALUE 'P'.
           PhPmtHistTable : Array[1..6] Of PhPhtEntry; // 258 POSIÇÕES
           PhFiller       : TgArr100; // Filler

//190	**** RECORD LAYOUT AMSL - INÍCIO NA POSICAO 4079 DO ARQUIVO

           SlTotCurrBalS     : TgArr001; // Sinal de Valor total da fatura em Real
           SlTotCurrBal      : TgArr017; // Valor total da fatura em Real
           SlTotUsPmtDueS    : TgArr001; // Sinal de Valor total da fatura em Dolar
           SlTotUsPmtDue     : TgArr017; // Valor total da fatura em Dolar
           SlTotPmtDueS      : TgArr001; // Sinal do Valor mínimo para pagamento
           SlTotPmtDue       : TgArr017; // Valor mínimo para pagamento
           SlPmtDueDate      : TgArr007; // Data de vencto da fatura
           SlDateCurrStmt    : TgArr007; // Data de geração da fatura
           SlCrLimS          : TgArr001; // Sinal de Limite de crédito da conta no momento do corte
           SlCrLim           : TgArr017; // Limite de crédito da conta no momento do corte
           SlIntStatus       : TgArr001; // Status da conta no momento do corte
           SlBlockCode1      : TgArr001; // Block-code da conta no momento do corte
           SlBlockCode2      : TgArr001; // Block-code da conta no momento do corte
           SlExchRateVarBnpS : TgArr001; // Sinal de Valor do Dolar para conversão no momento do corte
           SlExchRateVarBnp  : TgArr017; // Valor do Dolar para conversão no momento do corte
           SlFiller          : TgArr150; // Filler
           SlQtdOccurs       : TgArr003; // Qtde de ocorrência de transações

//229	**** RECORD LAYOUT TXN - INÍCIO NA POSIÇÃO 4339 DO ARQUIVO

           TxnData           : Array[1..150] Of SlTxn;
           End;

// **********************************
// Registro de extrato (1ª e 2ª vias)
// **********************************

  TCatalogo = record
              catalInsert : tgArr004;
              barCodeCif : tgArr040;
              end;

  TParcelas = record
              installmentNbr : tgArr002;
              installmentAmt : tgArr007;
              installmentDate : tgArr005;
              end;

  TPmtTable = record
              IPmtDueDate : tgArr005;
              IPmtAmt : tgArr007;
              IPmtFlag : tgArr001;
                         // PMT NOT DUE = 0;
                         // PMT DUE = 1;
                         // PMT DUE PAST WTH GRACE = 2;
                         // PMT DUE PAST GRACE = 3;
                         // PMT SATISFIED = 4;
              end;

  TfPndng = record
            fPndngBaseRate : tgArr004;
            fPndngIntRate : tgArr004;
            fPndngIntLim : tgArr007;
            end;

  TfRate = Record
           fBaseRate : tgArr004;
           fIntRate : tgArr005;
           fIntLim : tgArr007;
           End;

  TFuture = record
            futureDueDate : tgArr005;
            futureInstallBal : tgArr007;
            futureDefBal : tgArr007;
            end;

  TRegCMSF_Cab = record
                 sRelNbr : tgArr010;
                 sOrg : tgArr002;
                 sLogo : tgArr002;
                 sTipEmis : tgArr002;
                 sAcctNbr : tgArr019;
                 sZipSortCd : tgArr004;
                 sSupStmtInd : tgArr001;
                 sRecType : tgArr001; // Tipo do registro
                                         //S-COMPANY      VALUE '0'.
                                         //S-RELATIONSHIP VALUE '1'.
                                         //S-CUSTOMER     VALUE '2'.
                                         //S-PLAN         VALUE '3'.
                                         //S-DETAIL       VALUE '5'.
                                         //S-AGREEMENT    VALUE '4'.
                                         //S-DEFERRED     VALUE '6'.
                 sPriorImp : tgArr002;
                 sForm : tgArr003;
                 sDueDate : tgArr005;
                 sRecSeq : tgArr006;
                 sLoteImp : tgArr003;
                 sTmtInsert : array[1..5] of tgArr004;
                 sTamanho : tgArr002;
                 end;

  TCMSFCompany = record // Record = 0
                 aNameAddr1 : tgArr040;
                 aNameAddr2 : tgArr040;
                 aNameAddr3 : tgArr040;
                 aNameAddr4 : tgArr040;
                 aNameAddr5 : tgArr040;
                 aZipCode : tgArr010;
                 aCustSvcPhoneNbr : tgArr020;
                 aColcPhoneNbr : tgArr020;
                 aCardType : tgArr001;
                 aDesc : tgArr030;
                 end;

  TCMSFRelationShip = record // Record = 1;
                      gRelNameAddr : tgArr040;
                      end;
 {
07 :CMSF:-9-RPT-LEVEL-1         PIC  X(01).
07 :CMSF:-9-REL-PRIM-ACCT-FLAG  PIC  X(01).
07 :CMSF:-9-DUP-STMT-IND        PIC  X(01).
07 :CMSF:-9-STMT-MESSAGE.
09 :CMSF:-9-STMT-MESSAGE-X   OCCURS 10 TIMES
INDEXED BY
X-:CMSF:-9-MSG.
11  :CMSF:-9-MESSAGE-CODE PIC  X(05).
07 :CMSF:-9-MARCA-OMR           PIC  X(13).
07 :CMSF:-9-STMT-INSERT.
09 :CMSF:-9-STMT-INSERT-X    OCCURS 05 TIMES
INDEXED BY               X-:CMSF:-9-INS.
11  :CMSF:-9-INSERT-CODE  PIC  X(04).
07 :CMSF:-9-FORM                PIC  X(03).
07 :CMSF:-9-TIP-EMIS            PIC  9(02).
05 :CMSF:-DECISAO-IMPRESSAO.
07 :CMSF:-9-PSTL-CODE           PIC  X(10).
07 :CMSF:-9-MKR-SSAN            PIC  X(15).
07 :CMSF:-9-SI-ORG              PIC  X(03).
07 :CMSF:-9-SI-NBR              PIC  9(09) COMP-3.
07 :CMSF:-9-STORE-NAME          PIC  X(25).
07 :CMSF:-9-STORE-CHAIN-ID      PIC  9(09) COMP-3.
07 :CMSF:-9-GOLD-INDICATOR      PIC  9(02).
07 :CMSF:-9-SEXO-CODE           PIC  X(01).
07 :CMSF:-9-RENDA-AMT           PIC  9(05) COMP-3.
07 :CMSF:-9-PROMO-CODE1         PIC  9(05) COMP-3.
07 :CMSF:-9-CRLIM               PIC S9(13) COMP-3.
07 :CMSF:-9-CASH-CRLIM          PIC S9(13) COMP-3.	
07 :CMSF:-9-BLOCK-CODE-1        PIC  X.	
07 :CMSF:-9-BLOCK-CODE-2        PIC  X.	
07 :CMSF:-9-WARNING-CODES.	
09 :CMSF:-9-WARN-CODE-4      PIC  X.	
09 :CMSF:-9-WARN-CODE-5      PIC  X.
09 :CMSF:-9-BLOCK-POSITIVE-X OCCURS 04 TIMES	
INDEXED BY               X-:CMSF:-9-POS.	
11 :CMSF:-9-BLOCK-POSITIVE PIC  X(03).	
07 :CMSF:-9-BILLING-DATE        PIC  9(09) COMP-3.
07 :CMSF:-9-DUE-DATE            PIC  9(09) COMP-3.
07 :CMSF:-9-MAKER-DOB           PIC  9(09) COMP-3.
07 :CMSF:-9-MAKER-AGE           PIC  9(03) COMP-3.
07 :CMSF:-9-MD-DATE-OPEN        PIC  9(09) COMP-3.
07 :CMSF:-9-CFD-DTE-FIRST-PUR   PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-NEXT-STMT      PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-STMT      PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-NEXT-DUE       PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-DUE       PIC  9(09) COMP-3.
07 :CMSF:-9-MD-DATE-LAST-ACT    PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-PURCH     PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-PMT       PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-CASH      PIC  9(09) COMP-3.
07 :CMSF:-9-CARD-NBR            PIC  X(19).
07 :CMSF:-9-ORG                 PIC  9(03) COMP-3.
07 :CMSF:-9-LOGO                PIC  9(03) COMP-3.
07 :CMSF:-9-PRIOR-IMP           PIC  9(02).
07 :CMSF:-9-CYCLE-TIME          PIC  9(02).
07 :CMSF:-9-LOTE-IMP            PIC  9(05) COMP-3.
07 :CMSF:-9-CATEGORY            PIC S9(01) COMP-3.
07 :CMSF:-9-PRT-TYPE            PIC S9(01) COMP-3.
07 :CMSF:-9-FUTURE-BAL          PIC S9(13) COMP-3.
07 :CMSF:-9-CASH-STORE-LIM      PIC S9(13) COMP-3.
07 :CMSF:-9-DATE-LIM-PMT        PIC  9(09) COMP-3.
07 :CMSF:-9-BAR-CODE            PIC  X(44).
07 :CMSF:-9-BAR-CODE-DIGIT      PIC  X(53).
07 :CMSF:-9-CURR-BAL            PIC S9(13) COMP-3.
07 :CMSF:-9-LAST-EXCH-DATE      PIC  9(09) COMP-3.
07 :CMSF:-9-LAST-EXCH-RATE      PIC S9(07) COMP-3.
07 :CMSF:-9-INT-INITIAL-DATE    PIC  9(09) COMP-3.
07 :CMSF:-9-INT-RATE            PIC S9(07) COMP-3.
07 :CMSF:-9-INT-NEXT-RATE       PIC S9(07) COMP-3.
07 :CMSF:-9-INT-CASH-INITIAL-DATE PIC  9(09) COMP-3
07 :CMSF:-9-INT-CASH-RATE       PIC S9(07) COMP-3.
07 :CMSF:-9-INT-CASH-NEXT-RATE  PIC S9(07) COMP-3.
07 :CMSF:-9-INT-TRSF-INITIAL-DATE PIC  9(09) COMP-3
07 :CMSF:-9-INT-TRSF-RATE       PIC S9(07) COMP-3.
07 :CMSF:-9-INT-TRSF-NEXT-RATE  PIC S9(07) COMP-3.
07 :CMSF:-9-MOR-INITIAL-DATE    PIC  9(09) COMP-3.
07 :CMSF:-9-MOR-RATE            PIC S9(07) COMP-3.
07 :CMSF:-9-MOR-NEXT-RATE       PIC S9(07) COMP-3.
07 :CMSF:-9-LFE-INITIAL-DATE    PIC  9(09) COMP-3.
07 :CMSF:-9-LFE-RATE            PIC S9(07) COMP-3.
07 :CMSF:-9-LFE-NEXT-RATE       PIC S9(07) COMP-3.
05 :CMSF:-DADOS-PARA-CIF.
07 :CMSF:-9-COD-DR-POSTAGEM     PIC 9(002).
07 :CMSF:-9-COD-ADM-CONTRATO    PIC 9(008) COMP-3.
07 :CMSF:-9-NUMERO-LOTE         PIC 9(005) COMP-3.
07 :CMSF:-9-NUM-SEQ-OBJETO      PIC 9(011) COMP-3.	
07 :CMSF:-9-COD-DESTINO         PIC 9(001).	
07 :CMSF:-9-COD-RESERVA         PIC 9(001).
07 :CMSF:-9-DATA-POSTAGEM       PIC 9(008) COMP-3.	
07 :CMSF:-9-CDD                 PIC X(050).	
07 :CMSF:-9-PESO-OBJETO         PIC 9(05)V99
COMP-3	
05 :CMSF:-DADOS-PARA-CEPNET.	
07 :CMSF:-9-DIGITO-CONTROLE-CEP PIC 9(001).	
05 :CMSF:-IDENTIFICADORES.	
07 :CMSF:-9-MEIO                PIC X(002).	
07 :CMSF:-9-IND-AUTO-ENVELOP    PIC X(001).
07 :CMSF:-9-CATALOGO.	
09 :CMSF:-9-CATALOGO-X OCCURS 5.	
11 :CMSF:-9-CATAL-INSERT  PIC X(004).	
05 :CMSF:-9-BAR-CODE-CIF           PIC X(040).
*	
*        RESUMO DE TOTAIS DO EXTRATO  = 420	
*	
04 :CMSF:-RESUMO-DATA-X.	
05 :CMSF:-RESUMO-TRANS.	
07 :CMSF:-8-TOT-BEG-BAL           PIC S9(13) COMP-3	
07 :CMSF:-8-CURR-BAL              PIC S9(13) COMP-3
07 :CMSF:-8-MIN-PMT-DUE           PIC S9(13) COMP-3	
07 :CMSF:-8-CRED-BAL              PIC S9(13) COMP-3	
07 :CMSF:-8-DEB-BAL               PIC S9(13) COMP-3	
07 :CMSF:-8-DOMESTIC-BAL          PIC S9(13) COMP-3	
07 :CMSF:-8-ORIG-TXN-BAL          PIC S9(13) COMP-3	
07 :CMSF:-8-ORIG-US-BAL           PIC S9(13) COMP-3	
07 :CMSF:-8-CRED-US-BAL           PIC S9(13) COMP-3	
07 :CMSF:-8-DEB-US-BAL            PIC S9(13) COMP-3
07 :CMSF:-8-TOT-BALANCE.	
09 :CMSF:-8-TOT-BALANCE-X OCCURS 50 TIMES	
INDEXED BY	
X-:CMSF:-8-TOT.
11 :CMSF:-8-BALANCE-AMT     PIC S9(13) COMP-3	
*	
*        CUST DATA LENGTH             = 716
*	
04 :CMSF:-CUST-DATA-X.	
05 :CMSF:-CUST-DATA.	
07 :CMSF:-B-CATEGORY              PIC S9(01) COMP-3	
07 :CMSF:-B-PRT-TYPE              PIC S9(01) COMP-3	
07 :CMSF:-B-NAME-ADDR-1           PIC  X(40).
07 :CMSF:-B-NAME-ADDR-2           PIC  X(40).	
07 :CMSF:-B-NAME-ADDR-3           PIC  X(40).	
07 :CMSF:-B-NAME-ADDR-4           PIC  X(40).	
07 :CMSF:-B-NAME-ADDR-5           PIC  X(40).
07 :CMSF:-B-CITY                  PIC  X(30).	
07 :CMSF:-B-STATE                 PIC  X(03).	
07 :CMSF:-B-PSTL-CODE             PIC  X(10).	
07 :CMSF:-B-STMT-DATE             PIC  9(09) COMP-3	
07 :CMSF:-B-PMT-DATE              PIC  9(09) COMP-3	
07 :CMSF:-B-DATE-NEXT-STMT        PIC  9(09) COMP-3	
07 :CMSF:-B-CURR-BAL              PIC S9(13) COMP-3
07 :CMSF:-B-MIN-PMT-DUE           PIC S9(13) COMP-3	
07 :CMSF:-B-TOT-DUE-AMT           PIC S9(13) COMP-3	
07 :CMSF:-B-MKR-RELATIVE-NAME     PIC  X(40).	
07 :CMSF:-B-MKR-SSAN              PIC  X(15).	
07 :CMSF:-B-MKR-HOME-PHONE        PIC  X(20).	
07 :CMSF:-B-COMKR-NAME            PIC  X(40).	
07 :CMSF:-B-COMKR-HOME-PHONE      PIC  X(20).	
07 :CMSF:-B-COMKR-EMPLOYER        PIC  X(40).
07 :CMSF:-B-REL-NBR               PIC  X(19).	
07 :CMSF:-B-CRLIM                 PIC S9(13) COMP-3	
07 :CMSF:-B-OPEN-TO-BUY           PIC S9(13) COMP-3	
07 :CMSF:-B-TOT-BEG-BAL           PIC S9(13) COMP-3
07 :CMSF:-B-DATE-LAST-STMT        PIC  9(09) COMP-3	
07 :CMSF:-B-STATE-OF-RESID        PIC  X(03).	
07 :CMSF:-B-INT-STATUS            PIC  X(01).
07 :CMSF:-B-BLOCK-CODE-1          PIC  X.	
07 :CMSF:-B-BLOCK-CODE-2          PIC  X.	
07 :CMSF:-B-STORE-ID.	
09 :CMSF:-B-SI-ORG             PIC S9(03) COMP-3	
09 :CMSF:-B-SI-NBR             PIC S9(09) COMP-3	
07 :CMSF:-B-MISC-DATA.
09 :CMSF:-B-MD-DATE-OPEN       PIC  9(09) COMP-3	
09 :CMSF:-B-MD-DATE-LAST-ACT   PIC  9(09) COMP-3	
07 :CMSF:-B-PROMO-1               PIC  X(04).	
07 :CMSF:-B-CASH-CRLIM            PIC S9(13) COMP-3
07 :CMSF:-B-USER-MISC-1           PIC  X(30).	
07 :CMSF:-B-USER-MISC-3           PIC  X(11).	
07 :CMSF:-B-TOT-DEF-BILL-CURR-BAL PIC S9(13) COMP-3	
07 :CMSF:-B-REPRINT-ACCT          PIC  X(19).	
07 :CMSF:-B-FEE-LC-FEE-AND-PERC   OCCURS  9 TIMES	
INDEXED BY X-:CMSF:-LAP.	
09 :CMSF:-B-FEE-LC-PERC        PIC  9(09) COMP-3
07 :CMSF:-B-STMT-MSG-INDIC        PIC  9.	
07 :CMSF:-B-CUST-SEL-PMT-DUE-DATE PIC  9(09) COMP-3	
07 :CMSF:-B-MSG-INDICATOR         PIC  X(55).	
07 FILLER REDEFINES :CMSF:-B-MSG-INDICATOR	
OCCURS 55 TIMES INDEXED BY X-:CMSF:-MSG-IND.	
09 :CMSF:-B-MSG-IND            PIC  X(01).	
88  :CMSF:-B-MSG-REQUIRED        VALUE 'Y'.	
88  :CMSF:-B-MSG-NOT-REQUIRED    VALUE 'N'.
07 :CMSF:-B-STMT-FLAG             PIC  X.	
88  :CMSF:-B-ONLINE-STMT       VALUE 'O'.	
88  :CMSF:-B-HOLD-STMT         VALUE	
'H' '0' '1' '2'
'3' '4' '5' '6'	
'7' '8' '9'.	
88  :CMSF:-B-INTERIM-STMT      VALUE 'I'.
88  :CMSF:-B-CYCLE-STMT        VALUE 'C'.	
07 :CMSF:-B-ACCR-EX-RT-VAR        PIC S9(13) COMP-3	
07 :CMSF:-B-DOTZ-ADESAO           PIC S9(09) COMP-3	
07 :CMSF:-B-DOTZ-ATIVACAO         PIC S9(09) COMP-3	
07 :CMSF:-B-DOTZ-ANIDADE          PIC S9(09) COMP-3	
07 :CMSF:-B-DOTZ-SPENDIG          PIC S9(09) COMP-3
07 :CMSF:-B-DOTZ-TOTAL            PIC S9(09) COMP-3	
07 :CMSF:-B-BAL-DISPUTE-PRV-CYC   PIC S9(13) COMP-3	
07 :CMSF:-B-BAL-DISPUTE-CUR-CYC   PIC S9(13) COMP-3	
*
*        PLAN TOTALS LENGTH           = 98	
*	
04 :CMSF:-PLN-TOT-DATA-X.	
05 :CMSF:-PLAN-TOTAL-DATA.	
07 :CMSF:-H-PLAN-TOT-AVG-BAL      PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-MIN-PMT      PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-CUR-BAL      PIC S9(13) COMP-3
07 :CMSF:-H-PLAN-TOT-FIN-CHG      PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PMT-CR       PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PUR-DB       PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PREV-BAL     PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-AVG-BAL-EURO PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-MIN-PMT-EURO PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-CUR-BAL-EURO PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-FIN-CHG-EURO PIC S9(13) COMP-3
07 :CMSF:-H-PLAN-TOT-PMT-CR-EURO  PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PUR-DB-EURO  PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PREV-BAL-EURO	
PIC S9(13) COMP-3
04 FILLER                               PIC  X(115).	
*	
}
  TCMSFCustomer = record // Record = 2;
                  rptLevel1 : tgArr001;
                  relPrimAcctFlag : tgArr001;
                  dupSTmtInd : tgArr001;
                  stmtMessage : array[1..10] of tgArr005;
                  marcaOmr : tgArr013;
                  stmtInsert : array[1..5] of tgArr004;
                  form : tgArr003;
                  tipEmis : tgArr002;
                  pstlCode : tgArr010;
                  mkrSsan : tgArr015;
                  siOrg : tgArr003;
                  siNbr : tgArr005;
                  storeName : tgArr025;
                  storeChainID : tgArr005;
                  goldIndicato : tgArr002;
                  sexoCode : tgArr001;
                  rendaAmt : tgArr003;
                  promoCode1 : tgArr003;
                  crLim : tgArr007;
                  cashCrLim : tgArr007;
                  blockCode1 : tgArr001;
                  blockCode2 : tgArr001;
                  warnCode4 : tgArr001;
                  warnCode5 : tgArr001;
                  blockPositive : array [1..4] of tgArr003;
                  billingDate : tgArr005;
                  dueDate : tgArr005;
                  makerDob : tgArr005;
                  makerAge : tgArr002;
                  mdDateOpen : tgArr005;
                  cfdDteFirstPur : tgArr005;
                  dateNextStmt : tgArr005;
                  dateLastStmt : tgArr005;
                  dateNextDue : tgArr005;
                  dateLastDue : tgArr005;
                  mdDateLastAct : tgArr005;
                  dateLastPurch : tgArr005;
                  dateLastPmt : tgArr005;
                  dateLastCash : tgArr005;
                  cardNbr : tgArr019;
                  org : tgArr002;
                  logo : tgArr002;
                  priorImp : tgArr002;
                  cycleTime : tgArr002;
                  loteImp : tgArr003;
                  category : tgArr001;
                  prtType : tgArr001;
                  futureBal : tgArr007;
                  cashStoreLim : tgArr007;
                  dateLimPmt : tgArr005;
                  barCode : tgArr044;
                  barCodeDigit : tgArr053;
                  currBal : tgArr007;
                  lastExchDate : tgArr005;
                  lastExchRate : tgArr004;
                  intInitialDate : tgArr004;
                  intRate : tgArr005;
                  intNextRate : tgArr005;
                  intCashInitialDate : tgArr005;
                  intCashRate : tgArr004;
                  intCashNextRate : tgArr004;
                  intTrsfInitialDate : tgArr005;
                  intTrsfRate : tgArr004;
                  intTrsfNextRate : tgArr004;
                  morInitialDate : tgArr005;
                  morRate : tgArr004;
                  morNextRate : tgArr004;
                  lfeInitialDate : tgArr005;
                  lfeRate : tgArr004;
                  lfeNextRate : tgArr007;
                  codDrPostagem : tgArr002;
                  codAdmContrato : tgArr005;
                  numeroLote : tgArr004;
                  numSeqObjeto : tgArr006;
                  codDestino : tgArr001;
                  codReserva : tgArr001;
                  dataPostagem : tgArr005;
                  cdd : tgArr050;
                  pesoObjeto : tgArr003;
                  digitoControleCep : tgArr001;
                  meio : tgArr002;
                  indAutoEnvelop : tgArr001;
                  catalogo : array[1..5] of TCatalogo;
                  totBegBal : tgArr007;
                  currBal2 : tgArr007;
                  minPmtDue : tgArr007;
                  credBal : tgArr007;
                  debBal : tgArr007;
                  domesticBal : tgArr007;
                  origTxnBal : tgArr007;
                  origUsBal : tgArr007;
                  credUsBal : tgArr007;
                  debUsBal : tgArr007;
                  balanceAmt : array[1..50] of tgArr007;
                  bCategory : tgArr001;
                  bPrtType : tgArr001;
                  bNameAddr1 : tgArr040;  // Esta é a linha
                  bNameAddr2 : tgArr040;
                  bNameAddr3 : tgArr040;
                  bNameAddr4 : tgArr040;
                  bNameAddr5 : tgArr040;
                  bCity : tgArr030;
                  bState : tgArr003;
                  bPstlCode : tgArr010;
                  bStmtDate : tgArr005;
                  bPmtDate : tgArr005;
                  bNextStmt : tgArr005;
                  bCurrBal : tgArr007;
                  bMinPmtDue : tgArr007;
                  bTotDueAmt : tgArr007;
                  bMkrRelativeName : tgArr040;
                  bMkrSSan : tgArr015;
                  bMkrHomePhone : tgArr020;
                  bComkrName : tgArr040;
                  bComkrHomePhone : tgArr020;
                  bComkrEmployer : tgArr040;
                  bRelNbr : tgArr019;
                  bCrLim : tgArr007;
                  bOpenToBuy : tgArr007;
                  bTotBegBal : tgArr007;
                  bDateLastStmt : tgArr005;
                  bStateOfResid : tgArr003;
                  bIntStatus : tgArr001;
                  bBlockCode1 : tgArr001;
                  bBlockCode2 : tgArr001;
                  bSiOrg : tgArr002;
                  bSiNbr : tgArr002;
                  bMdDateOpen : tgArr005;
                  bMdDateLastAct : tgArr005;
                  bPromo1 : tgArr004;
                  bCashCrLim : tgArr007;
                  bUserMisc1 : tgArr030;
                  bUserMisc3 : tgArr011;
                  bTotDefBillCurrBal : tgArr007;
                  bReprintAcct : tgArr019;
                  bFeeLcPerc : array[1..9] of tgArr005;
                  bStmtMsgIndic : tgArr001;
                  bCustSelPmtDueDate : tgArr005;
                  bMsgIndicator : tgArr055;
                  bMsgInd : array[1..55] of tgArr001;
                            // 88  :CMSF:-B-MSG-REQUIRED     VALUE 'Y'.
                            // 88  :CMSF:-B-MSG-NOT-REQUIRED VALUE 'N'.
                  bStmtFlag : tgArr001;
                              // 88  :CMSF:-B-ONLINE-STMT  VALUE 'O'.
                              // 88  :CMSF:-B-HOLD-STMT    VALUE 'H' '0' '1' '2' '3' '4' '5' '6' '7' '8' '9'.
                              // 88  :CMSF:-B-INTERIM-STMT VALUE 'I'.
                              // 88  :CMSF:-B-CYCLE-STMT   VALUE 'C'.
                  bAcrExRtVar : tgArr007;
                  bDotzAdesao : tgArr005;
                  bDotzAtivacao : tgArr005;
                  bDotsAnidade : tgArr005;
                  bDotzSpendig : tgArr005;
                  bDotzTotal : tgArr005;
                  bBalDisputePrvCyc : tgArr007;
                  bBalDisputeCurCyc : tgArr007;
                  hPlanTotAvgBal : tgArr007;
                  hPlanTotMinPmt : tgArr007;
                  hPlanTotCurBal : tgArr007;
                  hPlanFinChg : tgArr007;
                  hPlanTotPmtCr : tgArr007;
                  hPlanTotPurDb : tgArr007;
                  hPlanTotPrevBal : tgArr007;
                  hPlanTotAvgBalEuro : tgArr007;
                  hPlanTotMinPmtEuro : tgArr007;
                  hPlanTotCurBalEuro : tgArr007;
                  hPlanTotFinChgEuro : tgArr007;
                  hPlanTotPmtCrEuro : tgArr007;
                  hPlanTotPurDBEuro : tgArr007;
                  hPlanTotPrevBalEuro : tgArr007;
                  end;

  TCMSFPlan = record // Record = 3;
              plan : tgArr003;
              currBal : tgArr007;
              minPmt : tgArr007;
              finChg : tgArr007;
              lastExchRate : tgArr004;
              lastExchDate : tgArr005;
              intInitialDate : tgArr005;
              intRate : tgArr004;
              intAmt : tgArr007;
              intNextRate : tgArr004;
              morInitialDate : tgArr005;
              morRate : tgArr004;
              morAmt : tgArr007;
              morNextRate : tgArr004;
              lfeInitialDate : tgArr005;
              lfeRate : tgArr004;
              lfeAmt : tgArr007;
              lfeNextRate : tgArr004;
              ePlan : tgArr003;
              eCurrBal : tgArr007;
              eMinPmt : tgArr007;
              eFinChg : tgArr007;
              ePlanType : tgArr001;
              eDateBegBilling : tgArr005;
              ePastDue : tgArr007;
              eEffDate : tgArr005;
              eIntRate1 : tgArr004;
              eOrigExchRateNod : tgArr001;
              eOrigExchRate : tgArr004;
              eLastExchRate : tgArr004;
              eMoraRate : tgArr004;
              fPlan : tgArr003;
              fRateType : tgArr001;
              fRate : array[1..9] of TfRate;
              fPndngRateType : tgArr001;
              fEffRateChgDate : tgArr004;
              fPndng : array[1..9] of TfPndng;
              end;

  TCMSFAgreement = record // Record = 4;
                   Iorg : tgArr003;
                   IrecNbr : tgArr003;
                   IDownPmtDate : tgArr005;
                   IDownPmtAmt : tgArr007;
                   IPmtTable : array[1..50] of TPmtTable;
                   IAgrmntDate : tgArr005;
                   IAgrmntLocation : tgArr005;
                   IAbrmntBal : tgArr007;
                   ICurrPmtDueDate : tgArr005;
                   IAgrmntBrokenDate : tgArr005;
                   end;

  TCMSFDetail = record // Record = 5;
                plan1 : tgArr003;
                txnCode1 : tgArr002;
                tramsRefNbr1 : tgArr023;
                currencyType : tgArr002;
                currencySource : tgArr003;
                sourceTxnAmt : tgArr007;
                origUsAmt1 : tgArr007;
                txnAmt1 : tgArr007;
                begInstSeq1 : tgArr002;
                nbrInst1 : tgArr002;
                embossedName1 : tgArr026;
                planType : tgArr001;
                grupo : tgArr002;
                parcelas : array[1..50] of TParcelas;
                effDate : tgArr005;
                postDate : tgArr005;
                desc : tgArr040;
                txnType : tgArr001;
                dbCr : tgArr001;
                cardNbr : tgArr019;
                codigoLoja : tgArr005;
                nomeLoja : tgArr025;
                fieldAcum : tgArr002;
                end;

  TCMSDeferred = record // Record = 6;
                 plan : tgArr003;
                 future : array[1..50] of TFuture;
                 end;

  TRegCMSF_Det = Record
                 Case Byte of
                 0 : (CMSFCompany : TCMSFCompany);
                 1 : (CMSFRelationShip : TCMSFRelationShip);
                 2 : (CMSFCustomer : TCMSFCustomer);
                 3 : (CMSFPlan : TCMSFPlan);
                 4 : (CMSFAgreement : TCMSFAgreement);
                 5 : (CMSFDetail : TCMSFDetail);
                 6 : (CMSDeferred : TCMSDeferred);
                 End;

// *****************************************
// Fim do Registro de extrato (1ª e 2ª vias)
// *****************************************

  TgArrRetornoWS = array of char;

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

{
1	******************************************************************	Descrição
2	*                                                                *
3	*     -------------------- NEAR ARCHIVE --------------------     *
4	*                                                                *
5	*      VAS905 - RECORD LAYOUT SHORT INFORMATIONS
6	*                AMNA    AMBS     AMBI    AMED    AMSL
7	*                AMPH    AMOS                                    *
8	*                                                                *
9	*      LENGTH RECORD   - 4338 - 23838 BYTES
10	*                                                                *
11	******************************************************************
12	*                                                                *
13	01  :VAS905:-RECORD.
14	02  :VAS905:-FIX.
15	03  :VAS905:-KEY.
16	05  :VAS905:-ORG-X.
17	07  :VAS905:-ORG        PIC 999.	Org
18	05  :VAS905:-LOGO-X.
19	07  :VAS905:-LOGO       PIC 999.	Logo
20	05  :VAS905:-ACCT           PIC X(19).	Nº da conta
21	05  :VAS905:-DATE-FILE      PIC 9(07).	Último dia do Mês que o arquivo foi gerado (aaaaddd)
22	*
23	**** RECORD LAYOUT AMNA	
24	*	
25	03  :VAS905:-AMNA-DATA.	
26	*	
27	05  :VAS905:-NA-ORG	Org
28	PIC 9(03).	
29	05  :VAS905:-NA-ACCT	Nº do cliente
30	PIC X(19).
31	05  :VAS905:-NA-SSAN	CPF ou CNPJ
32	PIC X(15).	
33	05  :VAS905:-NA-NAME-EMPLOYER	Nome do cliente ou razão social
34	PIC X(40).	
35	05  :VAS905:-NA-FLAG-TYPE-IND-1	Tipo pessoa
36	PIC 9.	
37	88  :VAS905:-NTI-PERSONAL             VALUE 0.	0 = Pessoa Física
38	88  :VAS905:-NTI-BUSINESS             VALUE 1.	1 = Pessoa Jurídica
39	05  :VAS905:-NA-ADDR-1	Endereço
40	PIC X(40).	
41	05  :VAS905:-NA-ADDR-2	Complemento do endereço
42	PIC X(40).	
43	05  :VAS905:-NA-CITY	Cidade
44	PIC X(30).	
45	05  :VAS905:-NA-STATE	Estado
46	PIC X(03).	
47	05  :VAS905:-NA-PSTL-CD	CEP
48	PIC X(10).	
49	05  :VAS905:-NA-CNTRY-CD	País
50	PIC X(03).	
51	05  :VAS905:-NA-HOME-PHONE	Telefone residencial
52	PIC X(20).	
53	05  :VAS905:-NA-EMP-PHONE	Telefone comercial
54	PIC X(20).	
55	05  :VAS905:-NA-FAX-PHONE	FAX
56	PIC X(20).	
57	05  :VAS905:-NA-MOBILE-PHONE	Telefone celular
58	PIC X(20).	
59	05  :VAS905:-NA-TITLE	Ramo atividade (pessoa jurídica)
60	PIC X(10).
61	05  :VAS905:-NA-DOB	Data de nascimento
62	PIC 9(07).	
63	05  :VAS905:-FILLER	
64	PIC X(150).	
65	*
66	**** RECORD LAYOUT AMBS	
67	*	
68	03  :VAS905:-AMBS-DATA.	
69	*	
70	05  :VAS905:-BS-DATE-OPENED	Data abertura da conta
71	PIC 9(07).	
72	05  :VAS905:-BS-INT-STATUS	Status da conta
73	PIC X.	
74	88  :VAS905:-BS-IS-NEW                VALUE 'N'.	
75	88  :VAS905:-BS-IS-ACTIVE          VALUE 'A' 'F' 'S'.	
76	88  :VAS905:-BS-IS-DORMANT            VALUE 'D'.	
77	88  :VAS905:-BS-IS-ACTIVE-NO-FRAUD    VALUE 'A'.	
78	88  :VAS905:-BS-IS-NORMAL          VALUE 'A' 'D' 'I'	
79	'M' 'N'.	
80	88  :VAS905:-BS-IS-CGOFF-NORMAL       VALUE 'Z'.	
81	88  :VAS905:-BS-IS-FRAUD              VALUE 'F'.	
82	88  :VAS905:-BS-IS-CONV            VALUE 'B' 'C' 'H'	
83	'V' 'X' 'W'.	
84	88  :VAS905:-BS-IS-PRE-CGOFF-CONV     VALUE 'W'.	
85	88  :VAS905:-BS-IS-ACH-VALID       VALUE 'A' 'D' 'Q'	
86	'J' 'M' 'N'	
87	'S'.	
88	88  :VAS905:-BS-CONV-FRAUD            VALUE 'B'.	
89	88  :VAS905:-BS-CONV-TRANSFER         VALUE 'C'.	
90	88  :VAS905:-BS-IS-CLOSED-CONV        VALUE 'H'.
91	88  :VAS905:-BS-IS-REG-CONV           VALUE 'V' 'W'.	
92	88  :VAS905:-BS-IS-CGOFF-CONV         VALUE 'X'.	
93	88  :VAS905:-BS-IS-XFR                VALUE 'T' 'F'	
94	'L' 'U'.	
95	88  :VAS905:-BS-IS-CGOFF              VALUE 'Z' 'X'.
96	88  :VAS905:-BS-IS-XFR-OUT            VALUE 'R' 'K'.	
97	88  :VAS905:-BS-IS-XFR-IN             VALUE 'Q' 'J'.	
98	88  :VAS905:-BS-IS-CLOSED-NORMAL      VALUE '8'.	
99	88  :VAS905:-BS-IS-CLOSED             VALUE '8' 'H'.	
100	88  :VAS905:-BS-IS-TO-BE-PURGED       VALUE '9' 'P'.	
101	88  :VAS905:-BS-IS-PENDING-PURGE      VALUE '9'.	
102	88  :VAS905:-BS-IS-PURGED             VALUE 'P'.	
103	88  :VAS905:-BS-IS-INACTIVE           VALUE 'I'.	
104	88  :VAS905:-BS-IS-REACTIVATE         VALUE 'M' 'J'	
105	'K'.	
106	88  :VAS905:-BS-IS-REACTIVATE-ONLY    VALUE 'M'.	
107	88  :VAS905:-BS-IS-XFR-NO-FRAUD       VALUE 'T'.	
108	88  :VAS905:-BS-IS-QTR-RPT-BLK        VALUE 'B' 'C'	
109	'F' 'H' 'P'	
110	'T' 'X' 'Z'	
111	'8' '9'.	
112	88  :VAS905:-BS-IS-TEMP-STATUS        VALUE 'J' 'K'	
113	'M' 'Q' 'R'.	
114	88  :VAS905:-BS-IS-PRE-CGOFF          VALUE 'S'.	
115	05  :VAS905:-BS-BLOCK-CODE-1	Block-code da conta
116	PIC X.	
117	05  :VAS905:-BS-BLOCK-CODE-2	Block-code da conta
118	PIC X.	
119	05  :VAS905:-BS-PMT-CYCLE-DUE	Código delinquência da conta
120	PIC 9.
121	88  :VAS905:-BS-PMT-CD-CURR           VALUE 0 1.	
122	88  :VAS905:-BS-PMT-CD-PAST-DUE       VALUE 2.	
123	88  :VAS905:-BS-PMT-CD-OVER-30        VALUE 3 THRU 9.	
124	05  :VAS905:-BS-DUE-DAY	Dia do vencimento
125	PIC 9(02).
126	05  :VAS905:-BS-BILLING-CYCLE	Dia do corte
127	PIC 99.	
128	05  :VAS905:-BS-CRLIM-S	Sinal de Limite de crédito ou renda declarada
129	PIC X(01).	
130	05  :VAS905:-BS-CRLIM	Limite de crédito ou renda declarada
131	PIC 9(17).	
132	05  :VAS905:-FILLER	
133	PIC X(150).	
134	*	
135	**** RECORD LAYOUT AMED	
136	*	
137	03  :VAS905:-AMED-DATA.	
138	*	
139	05  :VAS905:-AMED-CARDS	
140	OCCURS 100 TIMES	
141	INDEXED BY	
142	X-:VAS905:-ED-CARD.	
143	07  :VAS905:-ED-CARD-NBR	Número do cartão
144	PIC X(19).	
145	07  :VAS905:-ED-DATE-OPENED	Data abertura do cartão
146	PIC 9(07).	
147	07  :VAS905:-ED-STATUS	Status do cartão
148	PIC X.	
149	88  :VAS905:-ED-ACTIVE            VALUE '0' '1'.	
150	88  :VAS905:-ED-PERMANENT         VALUE '0'.
151	88  :VAS905:-ED-TEMPORARY         VALUE '1'.	
152	88  :VAS905:-ED-CNS-TRANSFER      VALUE 'T'.	
153	88  :VAS905:-ED-PURGED            VALUE 'P'.	
154	07  :VAS905:-ED-BLOCK-CODE	Block-code do cartão
155	PIC X.
156	07  :VAS905:-ED-CARDHOLDER-FLAG	Titular ou Adicional
157	PIC X.	
158	88  :VAS905:-CF-PRIMARY           VALUE '0'.	0 = Titular
159	88  :VAS905:-CF-SECONDADRY        VALUE '1'.	1 = Adicional
160	05  :VAS905:-FILLER	
161	PIC X(150).	
162	*	
163	**** RECORD LAYOUT AMPH	
164	*	
165	03  :VAS905:-AMPH-DATA.	
166	*	
167	05  :VAS905:-PH-CURRENCY	Moeda
168	PIC X(03).	
169	05  :VAS905:-PH-REC-STATUS	Status do Pagamento
170	PIC X.	
171	88  :VAS905:-PH-ACTIVE                VALUE 'A'.	
172	88  :VAS905:-PH-PURGED                VALUE 'P'.	
173	05  :VAS905:-PH-PMT-HIST-TABLE.	
174	07  :VAS905:-PH-PHT-ENTRY        OCCURS 06 TIMES	
175	INDEXED BY	
176	X-:VAS905:-PH-PMT.	
177	09  :VAS905:-PH-PHT-DATE	Data dos 6 últimos pagamentos
178	PIC 9(07).	
179	09  :VAS905:-PH-PHT-PMT-AMT-S	Sinal de Valor dos 6 últimos pagamentos
180	PIC X(01).
181	09  :VAS905:-PH-PHT-PMT-AMT	Valor dos 6 últimos pagamentos
182	PIC 9(17).	
183	09  :VAS905:-PH-PHT-ORIG-PMT-AMT-S	Sinal de Valor do pagamento original
184	PIC X(01).	
185	09  :VAS905:-PH-PHT-ORIG-PMT-AMT	Valor do pagamento original
186	PIC 9(17).	
187	05  :VAS905:-FILLER	
188	PIC X(100).	
189	*	
190	**** RECORD LAYOUT AMSL	
191	*	
192	03  :VAS905:-AMSL-DATA.	
193	*	
194	05  :VAS905:-SL-TOT-CURR-BAL-S	Sinal de Valor total da fatura em Real
195	PIC X(01).	
196	05  :VAS905:-SL-TOT-CURR-BAL	Valor total da fatura em Real
197	PIC 9(17).	
198	05  :VAS905:-SL-TOT-US-PMT-DUE-S	Sinal de Valor total da fatura em Dolar
199	PIC X(01).	
200	05  :VAS905:-SL-TOT-US-PMT-DUE	Valor total da fatura em Dolar
201	PIC 9(17).	
202	05  :VAS905:-SL-TOT-PMT-DUE-S	Sinal do Valor mínimo para pagamento
203	PIC X(01).	
204	05  :VAS905:-SL-TOT-PMT-DUE	Valor mínimo para pagamento
205	PIC 9(17).	
206	05  :VAS905:-SL-PMT-DUE-DATE	Data de vencto da fatura
207	PIC 9(07).	
208	05  :VAS905:-SL-DATE-CURR-STMT	Data de geração da fatura
209	PIC 9(07).	
210	05  :VAS905:-SL-CRLIM-S	Sinal de Limite de crédito da conta no momento do corte
211	PIC X(01).	
212	05  :VAS905:-SL-CRLIM	Limite de crédito da conta no momento do corte
213	PIC 9(17).	
214	05  :VAS905:-SL-INT-STATUS	Status da conta no momento do corte
215	PIC X.
216	05  :VAS905:-SL-BLOCK-CODE-1	Block-code da conta no momento do corte
217	PIC X.	
218	05  :VAS905:-SL-BLOCK-CODE-2	Block-code da conta no momento do corte
219	PIC X.	
220	05  :VAS905:-SL-EXCH-RATE-VAR-BNP-S	Sinal de Valor do Dolar para conversão no momento do corte
221	PIC X(01).	
222	05  :VAS905:-SL-EXCH-RATE-VAR-BNP	Valor do Dolar para conversão no momento do corte
223	PIC 9(17).	
224	05  :VAS905:-FILLER	
225	PIC X(150).	
226	05  :VAS905:-SL-QTD-OCCURS	Qtde de ocorrência de transações
227	PIC 9(03).	
228	*	
229	**** RECORD LAYOUT TXN	
230	*	
231	02  :VAS905:-VAR.	
232	*	
233	03  :VAS905:-TXN-DATA.	
234	*	
235	05  :VAS905:-SL-TXN	
236	OCCURS 0 TO 150 TIMES	
237	DEPENDING ON :VAS905:-SL-QTD-OCCURS	
238	INDEXED BY
239	X-:VAS905:-SL-TXN.	
240	07  :VAS905:-SL-TXN-CODE	Código da transação
241	PIC 9(03).	
242	07  :VAS905:-SL-EFF-DATE	Data da transação
243	PIC 9(07).	
244	07  :VAS905:-SL-TYPE	Tipo da transação (D ou C)
245	PIC X.
246	07  :VAS905:-SL-PLAN	Plano de crédito da transação
247	PIC 9(05).	
248	07  :VAS905:-SL-POSTING-FLAG	Status da transação
249	PIC 9(02).	
250	07  :VAS905:-SL-LOGIC-MOD	Módulo de lógica
251	PIC 9(02).	
252	07  :VAS905:-SL-SOURCE	Origem do lote da transação (loja, Visa, MC, etc)
253	PIC 9(05).	
254	07  :VAS905:-SL-ORIG-US-AMT-S	Sinal de Valor em Dolar
255	PIC X(01).	
256	07  :VAS905:-SL-ORIG-US-AMT	Valor em Dolar
257	PIC 9(17).	
258	07  :VAS905:-SL-US-NOD	Nº de decimais do valor em Dolar
259	PIC  9(01).	
260	07  :VAS905:-SL-ORIG-EXCH-RATE	Valor do Dolar para conversão no momento da transação
261	PIC 9(15).	
262	07  :VAS905:-SL-ORIG-EXCH-RATE-NOD	Nº de decimais do valor do dolar para conversão no momento da transação
263	PIC  9(01).	
264	07  :VAS905:-SL-AMOUNT-S	Sinal de Valor da transação
265	PIC X(01).	
266	07  :VAS905:-SL-AMOUNT	Valor da transação
267	PIC 9(17).
268	07  :VAS905:-SL-MERCHANT-ORG	Estabelecimento
269	PIC 9(03).	
270	07  :VAS905:-SL-MERCHANT-STORE	Loja
271	PIC 9(09).
272	07  :VAS905:-SL-DESC	Descrição da transação - origem
273	PIC X(040).
274	*

*******************************************************************************
** SEGUNDO ARQUIVO --- EXTRATOS (1ª E 2ª VIAS)                               **
*******************************************************************************
* SEQUENCIAL = 2100 BYTES                     PASSW= BWMF
* ************************************************************* *
* *  UTILIZE COPY BOOK REPLACING ==:CMSF:== BY ==????==.       -*
* ***************************************************************
* -                                                           - *
* - CMSFRL - EQUIVALE AO CMSERL GERADO EM 2 ARQ. NO CM0819S   - *
* -        - ESTE BOOK CONTEM OS 2 ARQ. JUNTADOS NO CM0940S   - *
* -        - USADO COMO PADRAO PARA O CSF                     - *
* -                                                           - *
* - DIFERENCAS PARA O CMSE :                       -- CSF --  - *
* -        REG. CMSF 0 = REG. CMSE A               (NIVEL 1)  - *
* -        REG. CMSF 1 = REG. CMSE G               (NIVEL 2)  - *
* -        REG. CMSF 2 = REG. CMSE 9 + 8 + B + H   (NIVEL 3)  - *
* -        REG. CMSF 3 = REG. CMSE 7 + E + F       (NIVEL 4)  - *
* -        REG. CMSF 4 = REG. CMSE I               (NIVEL 4)  - *
* -        REG. CMSF 5 = REG. CMSE 5 (D + 5)       (NIVEL 5)  - *
* -        REG. CMSF 6 = REG. CMSE 6               (NIVEL 4)  - *
* -                                                           - *
* - OBS: DEVE SER REVISTO A CADA REVISAO DO ATSE / CMSE       - *
* ************************************************************* *
*
01  :CMSF:-RECORD.
03 :CMSF:-SORT-KEY.
05 :CMSF:-S-REL-NBR                  PIC  9(18) COMP-3.
05 :CMSF:-S-ORG                      PIC  9(03) COMP-3.
05 :CMSF:-S-LOGO                     PIC  9(03) COMP-3.
05 :CMSF:-S-TIP-EMIS                 PIC  9(02).
05 :CMSF:-S-ACCT-NBR                 PIC  X(19).
05 :CMSF:-S-ZIP-SORT-CD              PIC  9(07) COMP-3.
05 :CMSF:-S-DUP-STMT-IND             PIC  X(01).
05 :CMSF:-S-REC-TYPE                 PIC  X(01).
88 :CMSF:-S-COMPANY               VALUE '0'.
88 :CMSF:-S-RELATIONSHIP          VALUE '1'.
88 :CMSF:-S-CUSTOMER              VALUE '2'.
88 :CMSF:-S-PLAN                  VALUE '3'.
88 :CMSF:-S-DETAIL                VALUE '5'.
88 :CMSF:-S-AGREEMENT             VALUE '4'.
88 :CMSF:-S-DEFERRED              VALUE '6'.
05 :CMSF:-S-PRIOR-IMP                PIC  9(02).
05 :CMSF:-S-FORM                     PIC  X(03).
05 :CMSF:-S-DUE-DATE                 PIC  9(08) COMP-3.
05 :CMSF:-S-REC-SEQ                  PIC S9(11) COMP-3.
05 :CMSF:-S-LOTE-IMP                 PIC  9(04) COMP-3.
05 :CMSF:-S-STMT-INSERT.
07 :CMSF:-S-STMT-INSERT-X   OCCURS 05 TIMES.
09 :CMSF:-S-INSERT-CODE     PIC X(04).
03 :CMSF:-TAMANHO                       PIC S9(04) BINARY.
03 :CMSF:-DATA-AREA                     PIC X(2018).
*
*        REG = 0 - EMPRESA            = 281 BYTES
*
03 :CMSF:-COMPANY-DATA-0 REDEFINES :CMSF:-DATA-AREA.
*
*        CLIENT DATA LENGTH           = 281
*
04 :CMSF:-CLIENT-DATA-X.
05 :CMSF:-CLIENT-DATA.
07 :CMSF:-A-NAME-ADDR-1         PIC  X(40).
07 :CMSF:-A-NAME-ADDR-2         PIC  X(40).
07 :CMSF:-A-NAME-ADDR-3         PIC  X(40).
07 :CMSF:-A-NAME-ADDR-4         PIC  X(40).
07 :CMSF:-A-NAME-ADDR-5         PIC  X(40).
07 :CMSF:-A-ZIP-CODE            PIC  X(10).
07 :CMSF:-A-CUST-SVC-PHONE-NBR  PIC  X(20).
07 :CMSF:-A-COLC-PHONE-NBR      PIC  X(20).
07 :CMSF:-A-CARD-TYPE           PIC  X(01).
07 :CMSF:-A-DESC                PIC  X(30).
04 FILLER                             PIC  X(1737).
*
*        REG = 1 - RELACIONAMENTO     = 40 BYTES
*
03 :CMSF:-RELATION-DATA-1 REDEFINES :CMSF:-DATA-AREA.
*
*        RELATIONSHIP DATA LENGTH     = 40
*
04 :CMSF:-REL-DATA-X.
05 :CMSF:-REL-DATA.
07 :CMSF:-G-REL-NAME-ADDR-1     PIC  X(40).
04 FILLER                             PIC  X(1978).
*
*        REG = 2 - CONTA              = 2018 BYTES
*
03 :CMSF:-CONTAS-DATA-2 REDEFINES :CMSF:-DATA-AREA.
04 :CMSF:-DECISAO-DATA-X.
05 :CMSF:-DECISAO-LANC.
07 :CMSF:-9-RPT-LEVEL-1         PIC  X(01).
07 :CMSF:-9-REL-PRIM-ACCT-FLAG  PIC  X(01).
07 :CMSF:-9-DUP-STMT-IND        PIC  X(01).
07 :CMSF:-9-STMT-MESSAGE.
09 :CMSF:-9-STMT-MESSAGE-X   OCCURS 10 TIMES
INDEXED BY
X-:CMSF:-9-MSG.
11  :CMSF:-9-MESSAGE-CODE PIC  X(05).
07 :CMSF:-9-MARCA-OMR           PIC  X(13).
07 :CMSF:-9-STMT-INSERT.
09 :CMSF:-9-STMT-INSERT-X    OCCURS 05 TIMES
INDEXED BY               X-:CMSF:-9-INS.
11  :CMSF:-9-INSERT-CODE  PIC  X(04).
07 :CMSF:-9-FORM                PIC  X(03).
07 :CMSF:-9-TIP-EMIS            PIC  9(02).
05 :CMSF:-DECISAO-IMPRESSAO.
07 :CMSF:-9-PSTL-CODE           PIC  X(10).
07 :CMSF:-9-MKR-SSAN            PIC  X(15).
07 :CMSF:-9-SI-ORG              PIC  X(03).
07 :CMSF:-9-SI-NBR              PIC  9(09) COMP-3.
07 :CMSF:-9-STORE-NAME          PIC  X(25).
07 :CMSF:-9-STORE-CHAIN-ID      PIC  9(09) COMP-3.
07 :CMSF:-9-GOLD-INDICATOR      PIC  9(02).
07 :CMSF:-9-SEXO-CODE           PIC  X(01).
07 :CMSF:-9-RENDA-AMT           PIC  9(05) COMP-3.
07 :CMSF:-9-PROMO-CODE1         PIC  9(05) COMP-3.
07 :CMSF:-9-CRLIM               PIC S9(13) COMP-3.
07 :CMSF:-9-CASH-CRLIM          PIC S9(13) COMP-3.
07 :CMSF:-9-BLOCK-CODE-1        PIC  X.
07 :CMSF:-9-BLOCK-CODE-2        PIC  X.
07 :CMSF:-9-WARNING-CODES.
09 :CMSF:-9-WARN-CODE-4      PIC  X.
09 :CMSF:-9-WARN-CODE-5      PIC  X.
09 :CMSF:-9-BLOCK-POSITIVE-X OCCURS 04 TIMES
INDEXED BY               X-:CMSF:-9-POS.
11 :CMSF:-9-BLOCK-POSITIVE PIC  X(03).
07 :CMSF:-9-BILLING-DATE        PIC  9(09) COMP-3.
07 :CMSF:-9-DUE-DATE            PIC  9(09) COMP-3.
07 :CMSF:-9-MAKER-DOB           PIC  9(09) COMP-3.
07 :CMSF:-9-MAKER-AGE           PIC  9(03) COMP-3.
07 :CMSF:-9-MD-DATE-OPEN        PIC  9(09) COMP-3.
07 :CMSF:-9-CFD-DTE-FIRST-PUR   PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-NEXT-STMT      PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-STMT      PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-NEXT-DUE       PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-DUE       PIC  9(09) COMP-3.
07 :CMSF:-9-MD-DATE-LAST-ACT    PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-PURCH     PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-PMT       PIC  9(09) COMP-3.
07 :CMSF:-9-DATE-LAST-CASH      PIC  9(09) COMP-3.
07 :CMSF:-9-CARD-NBR            PIC  X(19).
07 :CMSF:-9-ORG                 PIC  9(03) COMP-3.
07 :CMSF:-9-LOGO                PIC  9(03) COMP-3.
07 :CMSF:-9-PRIOR-IMP           PIC  9(02).
07 :CMSF:-9-CYCLE-TIME          PIC  9(02).
07 :CMSF:-9-LOTE-IMP            PIC  9(05) COMP-3.
07 :CMSF:-9-CATEGORY            PIC S9(01) COMP-3.
07 :CMSF:-9-PRT-TYPE            PIC S9(01) COMP-3.
07 :CMSF:-9-FUTURE-BAL          PIC S9(13) COMP-3.
07 :CMSF:-9-CASH-STORE-LIM      PIC S9(13) COMP-3.
07 :CMSF:-9-DATE-LIM-PMT        PIC  9(09) COMP-3.
07 :CMSF:-9-BAR-CODE            PIC  X(44).
07 :CMSF:-9-BAR-CODE-DIGIT      PIC  X(53).
07 :CMSF:-9-CURR-BAL            PIC S9(13) COMP-3.
07 :CMSF:-9-LAST-EXCH-DATE      PIC  9(09) COMP-3.
07 :CMSF:-9-LAST-EXCH-RATE      PIC S9(07) COMP-3.
07 :CMSF:-9-INT-INITIAL-DATE    PIC  9(09) COMP-3.
07 :CMSF:-9-INT-RATE            PIC S9(07) COMP-3.
07 :CMSF:-9-INT-NEXT-RATE       PIC S9(07) COMP-3.
07 :CMSF:-9-INT-CASH-INITIAL-DATE PIC  9(09) COMP-3
07 :CMSF:-9-INT-CASH-RATE       PIC S9(07) COMP-3.
07 :CMSF:-9-INT-CASH-NEXT-RATE  PIC S9(07) COMP-3.
07 :CMSF:-9-INT-TRSF-INITIAL-DATE PIC  9(09) COMP-3	
07 :CMSF:-9-INT-TRSF-RATE       PIC S9(07) COMP-3.	
07 :CMSF:-9-INT-TRSF-NEXT-RATE  PIC S9(07) COMP-3.
07 :CMSF:-9-MOR-INITIAL-DATE    PIC  9(09) COMP-3.	
07 :CMSF:-9-MOR-RATE            PIC S9(07) COMP-3.	
07 :CMSF:-9-MOR-NEXT-RATE       PIC S9(07) COMP-3.	
07 :CMSF:-9-LFE-INITIAL-DATE    PIC  9(09) COMP-3.	
07 :CMSF:-9-LFE-RATE            PIC S9(07) COMP-3.	
07 :CMSF:-9-LFE-NEXT-RATE       PIC S9(07) COMP-3.	
05 :CMSF:-DADOS-PARA-CIF.	
07 :CMSF:-9-COD-DR-POSTAGEM     PIC 9(002).	
07 :CMSF:-9-COD-ADM-CONTRATO    PIC 9(008) COMP-3.	
07 :CMSF:-9-NUMERO-LOTE         PIC 9(005) COMP-3.	
07 :CMSF:-9-NUM-SEQ-OBJETO      PIC 9(011) COMP-3.	
07 :CMSF:-9-COD-DESTINO         PIC 9(001).	
07 :CMSF:-9-COD-RESERVA         PIC 9(001).	
07 :CMSF:-9-DATA-POSTAGEM       PIC 9(008) COMP-3.	
07 :CMSF:-9-CDD                 PIC X(050).	
07 :CMSF:-9-PESO-OBJETO         PIC 9(05)V99	
COMP-3	
05 :CMSF:-DADOS-PARA-CEPNET.	
07 :CMSF:-9-DIGITO-CONTROLE-CEP PIC 9(001).	
05 :CMSF:-IDENTIFICADORES.	
07 :CMSF:-9-MEIO                PIC X(002).	
07 :CMSF:-9-IND-AUTO-ENVELOP    PIC X(001).	
07 :CMSF:-9-CATALOGO.	
09 :CMSF:-9-CATALOGO-X OCCURS 5.	
11 :CMSF:-9-CATAL-INSERT  PIC X(004).	
05 :CMSF:-9-BAR-CODE-CIF           PIC X(040).
*	
*        RESUMO DE TOTAIS DO EXTRATO  = 420	
*	
04 :CMSF:-RESUMO-DATA-X.	
05 :CMSF:-RESUMO-TRANS.	
07 :CMSF:-8-TOT-BEG-BAL           PIC S9(13) COMP-3
07 :CMSF:-8-CURR-BAL              PIC S9(13) COMP-3	
07 :CMSF:-8-MIN-PMT-DUE           PIC S9(13) COMP-3	
07 :CMSF:-8-CRED-BAL              PIC S9(13) COMP-3	
07 :CMSF:-8-DEB-BAL               PIC S9(13) COMP-3	
07 :CMSF:-8-DOMESTIC-BAL          PIC S9(13) COMP-3	
07 :CMSF:-8-ORIG-TXN-BAL          PIC S9(13) COMP-3	
07 :CMSF:-8-ORIG-US-BAL           PIC S9(13) COMP-3	
07 :CMSF:-8-CRED-US-BAL           PIC S9(13) COMP-3	
07 :CMSF:-8-DEB-US-BAL            PIC S9(13) COMP-3	
07 :CMSF:-8-TOT-BALANCE.	
09 :CMSF:-8-TOT-BALANCE-X OCCURS 50 TIMES	
INDEXED BY	
X-:CMSF:-8-TOT.	
11 :CMSF:-8-BALANCE-AMT     PIC S9(13) COMP-3	
*	
*        CUST DATA LENGTH             = 716	
*	
04 :CMSF:-CUST-DATA-X.	
05 :CMSF:-CUST-DATA.	
07 :CMSF:-B-CATEGORY              PIC S9(01) COMP-3	
07 :CMSF:-B-PRT-TYPE              PIC S9(01) COMP-3	
07 :CMSF:-B-NAME-ADDR-1           PIC  X(40).	
07 :CMSF:-B-NAME-ADDR-2           PIC  X(40).	
07 :CMSF:-B-NAME-ADDR-3           PIC  X(40).	
07 :CMSF:-B-NAME-ADDR-4           PIC  X(40).	
07 :CMSF:-B-NAME-ADDR-5           PIC  X(40).
07 :CMSF:-B-CITY                  PIC  X(30).	
07 :CMSF:-B-STATE                 PIC  X(03).	
07 :CMSF:-B-PSTL-CODE             PIC  X(10).	
07 :CMSF:-B-STMT-DATE             PIC  9(09) COMP-3	
07 :CMSF:-B-PMT-DATE              PIC  9(09) COMP-3	
07 :CMSF:-B-DATE-NEXT-STMT        PIC  9(09) COMP-3
07 :CMSF:-B-CURR-BAL              PIC S9(13) COMP-3	
07 :CMSF:-B-MIN-PMT-DUE           PIC S9(13) COMP-3	
07 :CMSF:-B-TOT-DUE-AMT           PIC S9(13) COMP-3	
07 :CMSF:-B-MKR-RELATIVE-NAME     PIC  X(40).	
07 :CMSF:-B-MKR-SSAN              PIC  X(15).	
07 :CMSF:-B-MKR-HOME-PHONE        PIC  X(20).	
07 :CMSF:-B-COMKR-NAME            PIC  X(40).	
07 :CMSF:-B-COMKR-HOME-PHONE      PIC  X(20).	
07 :CMSF:-B-COMKR-EMPLOYER        PIC  X(40).	
07 :CMSF:-B-REL-NBR               PIC  X(19).	
07 :CMSF:-B-CRLIM                 PIC S9(13) COMP-3	
07 :CMSF:-B-OPEN-TO-BUY           PIC S9(13) COMP-3	
07 :CMSF:-B-TOT-BEG-BAL           PIC S9(13) COMP-3	
07 :CMSF:-B-DATE-LAST-STMT        PIC  9(09) COMP-3	
07 :CMSF:-B-STATE-OF-RESID        PIC  X(03).	
07 :CMSF:-B-INT-STATUS            PIC  X(01).	
07 :CMSF:-B-BLOCK-CODE-1          PIC  X.	
07 :CMSF:-B-BLOCK-CODE-2          PIC  X.	
07 :CMSF:-B-STORE-ID.	
09 :CMSF:-B-SI-ORG             PIC S9(03) COMP-3	
09 :CMSF:-B-SI-NBR             PIC S9(09) COMP-3	
07 :CMSF:-B-MISC-DATA.	
09 :CMSF:-B-MD-DATE-OPEN       PIC  9(09) COMP-3	
09 :CMSF:-B-MD-DATE-LAST-ACT   PIC  9(09) COMP-3	
07 :CMSF:-B-PROMO-1               PIC  X(04).	
07 :CMSF:-B-CASH-CRLIM            PIC S9(13) COMP-3
07 :CMSF:-B-USER-MISC-1           PIC  X(30).	
07 :CMSF:-B-USER-MISC-3           PIC  X(11).	
07 :CMSF:-B-TOT-DEF-BILL-CURR-BAL PIC S9(13) COMP-3	
07 :CMSF:-B-REPRINT-ACCT          PIC  X(19).	
07 :CMSF:-B-FEE-LC-FEE-AND-PERC   OCCURS  9 TIMES	
INDEXED BY X-:CMSF:-LAP.
09 :CMSF:-B-FEE-LC-PERC        PIC  9(09) COMP-3	
07 :CMSF:-B-STMT-MSG-INDIC        PIC  9.	
07 :CMSF:-B-CUST-SEL-PMT-DUE-DATE PIC  9(09) COMP-3	
07 :CMSF:-B-MSG-INDICATOR         PIC  X(55).	
07 FILLER REDEFINES :CMSF:-B-MSG-INDICATOR	
OCCURS 55 TIMES INDEXED BY X-:CMSF:-MSG-IND.	
09 :CMSF:-B-MSG-IND            PIC  X(01).	
88  :CMSF:-B-MSG-REQUIRED        VALUE 'Y'.	
88  :CMSF:-B-MSG-NOT-REQUIRED    VALUE 'N'.	
07 :CMSF:-B-STMT-FLAG             PIC  X.	
88  :CMSF:-B-ONLINE-STMT       VALUE 'O'.	
88  :CMSF:-B-HOLD-STMT         VALUE	
'H' '0' '1' '2'	
'3' '4' '5' '6'	
'7' '8' '9'.	
88  :CMSF:-B-INTERIM-STMT      VALUE 'I'.	
88  :CMSF:-B-CYCLE-STMT        VALUE 'C'.	
07 :CMSF:-B-ACCR-EX-RT-VAR        PIC S9(13) COMP-3	
07 :CMSF:-B-DOTZ-ADESAO           PIC S9(09) COMP-3	
07 :CMSF:-B-DOTZ-ATIVACAO         PIC S9(09) COMP-3	
07 :CMSF:-B-DOTZ-ANIDADE          PIC S9(09) COMP-3	
07 :CMSF:-B-DOTZ-SPENDIG          PIC S9(09) COMP-3	
07 :CMSF:-B-DOTZ-TOTAL            PIC S9(09) COMP-3	
07 :CMSF:-B-BAL-DISPUTE-PRV-CYC   PIC S9(13) COMP-3	
07 :CMSF:-B-BAL-DISPUTE-CUR-CYC   PIC S9(13) COMP-3	
*
*        PLAN TOTALS LENGTH           = 98	
*	
04 :CMSF:-PLN-TOT-DATA-X.	
05 :CMSF:-PLAN-TOTAL-DATA.	
07 :CMSF:-H-PLAN-TOT-AVG-BAL      PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-MIN-PMT      PIC S9(13) COMP-3
07 :CMSF:-H-PLAN-TOT-CUR-BAL      PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-FIN-CHG      PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PMT-CR       PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PUR-DB       PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PREV-BAL     PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-AVG-BAL-EURO PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-MIN-PMT-EURO PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-CUR-BAL-EURO PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-FIN-CHG-EURO PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PMT-CR-EURO  PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PUR-DB-EURO  PIC S9(13) COMP-3	
07 :CMSF:-H-PLAN-TOT-PREV-BAL-EURO	
PIC S9(13) COMP-3	
04 FILLER                               PIC  X(115).	
*	
*        REG = 3 - PLANO DE CREDITO   = 432 BYTES
*
03 :CMSF:-TOTPLAN-DATA-3  REDEFINES   :CMSF:-DATA-AREA.
*
*        ENCARGOS DESDOBRADOS         = 93
*
04 :CMSF:-ENCARGO-DATA-X.
05 :CMSF:-ENCARGO-DATA.
07 :CMSF:-7-PLAN                  PIC S9(05) COMP-3
07 :CMSF:-7-CURR-BAL              PIC S9(13) COMP-3
07 :CMSF:-7-MIN-PMT               PIC S9(13) COMP-3
07 :CMSF:-7-FIN-CHG               PIC S9(13) COMP-3
07 :CMSF:-7-LAST-EXCH-RATE        PIC S9(07) COMP-3
07 :CMSF:-7-LAST-EXCH-DATE        PIC  9(09) COMP-3
05 :CMSF:-ENCARGO-INTEREST.
07 :CMSF:-7-INT-INITIAL-DATE      PIC  9(09) COMP-3
07 :CMSF:-7-INT-RATE              PIC S9(07) COMP-3
07 :CMSF:-7-INT-AMT               PIC S9(13) COMP-3
07 :CMSF:-7-INT-NEXT-RATE         PIC S9(07) COMP-3
05 :CMSF:-ENCARGO-MORATORIUM.
07 :CMSF:-7-MOR-INITIAL-DATE      PIC  9(09) COMP-3
07 :CMSF:-7-MOR-RATE              PIC S9(07) COMP-3
07 :CMSF:-7-MOR-AMT               PIC S9(13) COMP-3
07 :CMSF:-7-MOR-NEXT-RATE         PIC S9(07) COMP-3
05 :CMSF:-ENCARGO-LATEFEE.
07 :CMSF:-7-LFE-INITIAL-DATE      PIC  9(09) COMP-3
07 :CMSF:-7-LFE-RATE              PIC S9(07) COMP-3
07 :CMSF:-7-LFE-AMT               PIC S9(13) COMP-3
07 :CMSF:-7-LFE-NEXT-RATE         PIC S9(07) COMP-3
*
*        PLAN AMT DATA LENGTH         = 59
*
04 :CMSF:-PLAN-AMT-DATA-X.
05 :CMSF:-PLAN-AMT-DATA.
07 :CMSF:-E-PLAN                  PIC S9(05) COMP-3
07 :CMSF:-E-CURR-BAL              PIC S9(13) COMP-3
07 :CMSF:-E-MIN-PMT               PIC S9(13) COMP-3
07 :CMSF:-E-FIN-CHG               PIC S9(13) COMP-3
07 :CMSF:-E-PLAN-TYPE             PIC  X(01).
07 :CMSF:-E-DATE-BEG-BILLING      PIC  9(09) COMP-3
07 :CMSF:-E-PAST-DUE              PIC S9(13) COMP-3
07 :CMSF:-E-EFF-DATE              PIC  9(09) COMP-3
07 :CMSF:-E-INT-RATE1             PIC S9(07) COMP-3
07 :CMSF:-E-ORIG-EXCH-RATE-NOD    PIC  9(01).
07 :CMSF:-E-ORIG-EXCH-RATE        PIC S9(07) COMP-3
07 :CMSF:-E-LAST-EXCH-RATE        PIC S9(07) COMP-3
07 :CMSF:-E-MORA-RATE             PIC S9(07) COMP-3
*
*        PLAN RATE DATA LENGTH = 280
*
04 :CMSF:-PLAN-RATE-DATA-X.
05 :CMSF:-PLAN-RATE-DATA.
07 :CMSF:-F-PLAN                  PIC S9(05) COMP-3
07 :CMSF:-F-RATE-TYPE             PIC  X(01).
07 :CMSF:-F-BASE-RATE1            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE1             PIC  9(09) COMP-3
07 :CMSF:-F-INT-LIM1              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE2            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE2             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM2              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE3            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE3             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM3              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE4            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE4             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM4              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE5            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE5             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM5              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE6            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE6             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM6              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE7            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE7             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM7              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE8            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE8             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM8              PIC S9(13) COMP-3
07 :CMSF:-F-BASE-RATE9            PIC S9(07) COMP-3
07 :CMSF:-F-INT-RATE9             PIC S9(07) COMP-3
07 :CMSF:-F-INT-LIM9              PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-RATE-TYPE       PIC X(01).
07 :CMSF:-F-EFF-RATE-CHG-DATE     PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE1      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE1       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM1        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE2      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE2       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM2        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE3      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE3       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM3        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE4      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE4       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM4        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE5      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE5       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM5        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE6      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE6       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM6        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE7      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE7       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM7        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE8      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE8       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM8        PIC S9(13) COMP-3
07 :CMSF:-F-PNDNG-BASE-RATE9      PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-RATE9       PIC S9(07) COMP-3
07 :CMSF:-F-PNDNG-INT-LIM9        PIC S9(13) COMP-3
04 FILLER                               PIC  X(1586).
*
*        REG = 5 - TRANSACOES         = 890 BYTES
*
03 :CMSF:-TRANSACAO-DATA-5  REDEFINES   :CMSF:-DATA-AREA.
*
*        TRANSACOES (ROT + PARC)      = 890
*
04 :CMSF:-TRANSAC-DATA-X.
05 :CMSF:-TRANPARC-DATA.
07 :CMSF:-5-PLAN1                 PIC S9(05) COMP-3
07 :CMSF:-5-TXN-CODE1             PIC S9(03) COMP-3
07 :CMSF:-5-TRAMS-REF-NBR1        PIC X(23).
07 :CMSF:-5-CURRENCY-TYPE         PIC X(02).
07 :CMSF:-5-CURRENCY-SOURCE       PIC X(03).
07 :CMSF:-5-SOURCE-TXN-AMT        PIC S9(13) COMP-3
07 :CMSF:-5-ORIG-US-AMT1          PIC S9(13) COMP-3
07 :CMSF:-5-TXN-AMT1              PIC S9(13) COMP-3
07 :CMSF:-5-BEG-INST-SEQ1         PIC  9(02).
07 :CMSF:-5-NBR-INST1             PIC  9(02).
07 :CMSF:-5-EMBOSSED-NAME-1       PIC X(26).	
07 :CMSF:-5-PLAN-TYPE             PIC X(01).	
07 :CMSF:-5-GRUPO                 PIC  9(02).	
05 :CMSF:-PARCELAS-DATA.	
07 :CMSF:-5-PARCELAS-X            OCCURS 50 TIMES	
INDEXED BY                    X-:CMSF:-5-PAR.	
09 :CMSF:-5-INSTALLMENT-NBR    PIC  9(03) COMP-3	
09 :CMSF:-5-INSTALLMENT-AMT    PIC S9(13) COMP-3	
09 :CMSF:-5-INSTALLMENT-DATE   PIC  9(09) COMP-3
05 :CMSF:-DETAIL-DATA1.	
07 :CMSF:-5-EFF-DATE              PIC  9(09) COMP-3	
07 :CMSF:-5-POST-DATE             PIC  9(09) COMP-3	
07 :CMSF:-5-DESC                  PIC  X(40).	
07 :CMSF:-5-TYPE                  PIC  X(01).	
07 :CMSF:-5-DB-CR                 PIC  X(01).
07 :CMSF:-5-CARD-NBR              PIC  X(19).	
OT6464              07 :CMSF:-5-CODIGO-LOJA           PIC S9(09) COMP-3	
OT6464              07 :CMSF:-5-NOME-LOJA             PIC  X(25).	
OT6464              07 :CMSF:-5-FIELD-ACUM            PIC  9(02).	
04 FILLER                               PIC  X(1128).	
*	
*        REG = 6 - PROJETADAS         = 1000 BYTES	
*	
03 :CMSF:-PROJETADA-DATA-6  REDEFINES   :CMSF:-DATA-AREA.	
*	
*        SALDOS A VENCER              = 1000	
*	
04 :CMSF:-DEFERRED-DATA-X.	
05 :CMSF:-FUTURE-DATA.	
07 :CMSF:-6-PLAN                  PIC S9(05) COMP-3	
05 :CMSF:-FUTURE-BALANCE.	
07 :CMSF:-6-FUTURE-X              OCCURS 50 TIMES	
INDEXED BY                    X-:CMSF:-6-FUT.	
09 :CMSF:-6-FUTURE-DUE-DATE    PIC  9(09) COMP-3	
09 :CMSF:-6-FUTURE-INSTALL-BAL PIC S9(13) COMP-3	
09 :CMSF:-6-FUTURE-DEF-BAL     PIC S9(13) COMP-3	
05 FILLER                            PIC X(47).	
04 FILLER                               PIC X(1018).	
*	
*        REG = 4 - ACORDOS            = 695 BYTES	
*
03 :CMSF:-ACORDO-DATA-4  REDEFINES   :CMSF:-DATA-AREA.	
*	
***   ***BRAZILIANIZATION***	
*	
*        AGREEMENT/PRE-AGREEMENT DATA LENGTH = 695	
*
04 :CMSF:-AGREEMENT-DATA-X.	
05 :CMSF:-AGREEMENT-DATA.	
07 :CMSF:-I-ORG-X.	
09 :CMSF:-I-ORG                PIC  9(03).	
07 :CMSF:-I-REC-NBR               PIC  9(03).	
07 :CMSF:-I-DOWN-PMT-DATE         PIC  9(09) COMP-3	
07 :CMSF:-I-DOWN-PMT-AMT          PIC S9(13) COMP-3	
07 :CMSF:-I-PMT-TABLE OCCURS 50 TIMES	
INDEXED BY X-:CMSF:-I-PMT.	
09 :CMSF:-I-PMT-DUE-DATE       PIC  9(09) COMP-3	
09 :CMSF:-I-PMT-AMT            PIC S9(13) COMP-3	
09 :CMSF:-I-PMT-FLAG           PIC  9(01).	
88  :CMSF:-I-PMT-NOT-DUE   VALUE 0.	
88  :CMSF:-I-PMT-DUE       VALUE 1.	
88  :CMSF:-I-PMT-DUE-PAST-WTH-GRACE	
VALUE 2.	
88  :CMSF:-I-PMT-DUE-PAST-GRACE	
VALUE 3.	
88  :CMSF:-I-PMT-SATISFIED VALUE 4.	
07 :CMSF:-I-AGRMNT-DATE           PIC  9(09) COMP-3	
07 :CMSF:-I-AGRMNT-LOCATION       PIC  9(05).	
07 :CMSF:-I-AGRMNT-BAL            PIC S9(13) COMP-3	
07 :CMSF:-I-CURR-PMT-DUE-DATE     PIC  9(09) COMP-3	
07 :CMSF:-I-AGRMNT-BROKEN-DATE    PIC  9(09) COMP-3	
04 FILLER                               PIC  X(1323).	


}

Implementation

End.
