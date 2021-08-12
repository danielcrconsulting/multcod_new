Unit SuTypMultiCold;

Interface

Uses
  SuTypGer;

Const
  MaxLinhasPorPag = 512;  
  
Type
TgRegDFN = record
           Case TipoReg : Integer Of
           0 : (
               Grp : Integer;
               );
           1 : (
               CODREL : TgStr015;
               NOMEREL : TgStr060;
               CODGRUPO : INTEGER;
               CODSUBGRUPO : INTEGER;
               IDCOLUNA1 : INTEGER;
               IDLINHA1 : INTEGER;
               IDSTRING1 : TgStr030;
               IDCOLUNA2 : INTEGER;
               IDLINHA2 : INTEGER;
               IDSTRING2 : TgStr030;
               DIRENTRA : TgStr050;
               TIPOQUEBRA : INTEGER;
               COLQUEBRASTR1 : INTEGER;
               STRQUEBRASTR1 : TgStr030;
               COLQUEBRASTR2 : INTEGER;
               STRQUEBRASTR2 : TgStr030;
               QUEBRAAFTERSTR : Boolean;
               NLINHASQUEBRALIN : INTEGER;
               FILTROCAR : Boolean;
               COMPRBRANCOS : Boolean;
               JUNCAOAUTOM : Boolean;
               QTDPAGSAPULAR : INTEGER;
               CODGRUPAUTO : Boolean;
               COLGRUPAUTO : INTEGER;
               LINGRUPAUTO : INTEGER;
               TAMGRUPAUTO : INTEGER;
               TIPOGRUPAUTO : TgStr001;
               BACKUP : Boolean;
               SUBDIRAUTO : Boolean
               );
           2 : (
               CODREL_ : TgStr015;
               NOMECAMPO : TgStr020;
               LINHAI : INTEGER;
               LINHAF : INTEGER;
               COLUNA : INTEGER;
               TAMANHO : INTEGER;
               BRANCO : TgStr001;
               TIPOCAMPO : TgStr002;
               MASCARA : TgStr012;
               CHARINC : TgStr020;
               CHAREXC : TgStr020;
               STRINC : TgStr025;
               STREXC : TgStr025
               );
           3 : (
               CODREL_0 : TgStr015;
               DESTINO : TgStr070;
               TIPODESTINO : TgStr005;
               DIREXPL : Boolean;
               SEGURANCA : Boolean;
               QTDPERIODOS : INTEGER;
               TIPOPERIODO : TgStr001;
               USUARIO : TgStr025;
               SENHA : TgStr025;
               );
           4 : (
               CODSIS : Integer;
               );
           5 : (
               CODSEG : Integer;
               );
           6 : (
               SISAUTO : Boolean;
               CODSISREAL : Integer;
               CODGRUPOREAL : Integer;
               );
           End;

FileOfTgRegDFN = File Of TgRegDFN;

TgRegPsq = Record
           Pagina   : Integer;
           PosQuery : Integer;
           End;
TgArqPsq = File Of TgRegPsq;

TgArrBol = Array[0..MaxLinhasPorPag] of Boolean;     // MultiEdit, verifique o início em 0...

tgRegIndice = array[0..199] of TgRegDFN;

Implementation

End.
