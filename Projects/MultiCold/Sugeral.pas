Unit Sugeral;

//Revisado SQLServer...

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, IniFiles, SuTypGer, StdCtrls, SuTypMultiCold,
  ADODB, InvokeRegistry, Rio, SOAPHTTPClient;

Type

  TDrawingTool = (dtFree, dtLine, dtRectangle, dtEllipse, dtRoundRect);

  TFormGeral = Class(TForm)
    DatabaseMultiCold: TADOConnection;
    TableDFN: TADOTable;
    QueryLocal1: TADOQuery;
    QueryInsAnotGraph: TADOQuery;
    QueryIndicesDFN: TADOQuery;
    QueryIndicesDFNII: TADOQuery;
    QueryDestinosDFN: TADOQuery;
    QueryAux1: TADOQuery;
    QueryAux2: TADOQuery;
    QueryInsAnotText: TADOQuery;
    DatabaseEventos: TADOConnection;
    EventosQuery1: TADOQuery;
    UpdateCompilaQuery: TADOQuery;
    InsereCompilaQuery: TADOQuery;
    SelectCompilaQuery: TADOQuery;
    DatabaseLog: TADOConnection;
    A: TADOQuery;
    QueryInsertLogProc: TADOQuery;
    TableTemp: TADOTable;
    TableGruposDFN: TADOTable;
    HTTPRIO1: THTTPRIO;
    QueryInsertProtocolo: TADOQuery;
    QueryAux3: TADOQuery;
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  Procedure InsereLog(Arquivo,Mensagem : AnsiString);
  Procedure InsereEventos(V1, V2, V3 : AnsiString; V4 : Integer;Const Reg : AnsiString);
  Procedure InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : AnsiString;
                              Grupo, SubGrupo, CodMens : Integer);
  Procedure MostraMensagem(Const Mensagem : AnsiString);
  Procedure LerIni;
  Procedure LerMapa;
//  Procedure CriarAliasDatabaseLocal;
//  Procedure CriarAliasEventos;
//  Procedure CriarAliasLog;     //   'S' = substituir; '+' = somar
  Procedure InsereAtualizaCompila(Operacao, CodRel : AnsiString; CodSis, CodGrupo, CodSubGrupo, Cont : Integer);

  End;


Const
// Geral
  ScreenWidth: LongInt = 800;   { I designed my form in 800x600 mode. }
  ScreenHeight: LongInt = 600;
  MaxLinhasPorPag = 512;

// Analisador
  X = '%%%%%';
  TamCodRel = 15;

// Index
  BufSize = 60000000; // *100 no XE4

Type
// Geral

TgFilIn = Array Of SetOfChar;
TgStrStr = Record
           Col,
           Tam : Integer;
           FilStr : TgStr255;
           End;
TgStrInc = Array Of TgStrStr;

TFiltro = Class
  FiltroIn : TgFilIn;
  FiltroOut : TgFilIn;
  StrInc : TgStrInc;
  StrExc : TgStrInc;

   // Celula - AnsiString com o filtro definido pelo usuário
   // Nome - AnsiString com o nome de referência para identificar o filtro que está sendo tratado
   // Filtro - Estrutura de retorno com o filtro compilado
   // Ind - Posição do campo que contém este filtro dentro da estrutura de campos

   Function EncheFiltro(Celula, Nome : AnsiString; Var Filtro : SetOfChar; Ind : Integer) : Boolean;

   // Celula - AnsiString com o filtro definido pelo usuário
   // Nome - AnsiString com o nome de referência para identificar o filtro que está sendo tratado
   // StrFil - Estrutura de retorno com o filtro compilado
   // Ind - Posição do campo que contém este filtro dentro da estrutura de campos

   Function EncheStr(Celula, Nome : TgStr255; Var StrFil : TgStrStr; Ind : Integer) : Boolean;
 End;

// MultiCold Viewer
TgRegPsq = Record
           Pagina   : Integer;
           PosQuery : Integer;
           End;
TgArqPsq = File Of TgRegPsq;
Diretorio = Array[1..37] Of Record
                            NomeArq,
                            NomeInd,
                            NomeInt : TgStr255;
                            End;

TgArrBol = Array[0..MaxLinhasPorPag] of Boolean;     // MultiEdit, verifique o início em 0...
TgArrPag = Record
           Active : Boolean;
           Left,
           Top,
           FontHeight,
           FontSize,
           CorDeFundo,
           CorDaFonte : Integer;
           TemLocaliza : Boolean;
           TemPesquisa : Boolean;
           Campos,
           CamposT,
           CamposL : Array[1..10] of Boolean;
           FontName,
           LinhaRel : AnsiString;
           FontStyle : TFontStyles;
           ComandoDeCarro : AnsiChar; // 17/05/2013
           End;
TgPagMultiCold = Array[0..MaxLinhasPorPag] Of TgArrPag;


TgArrBloqCampos = Record
                  CODREL : AnsiString;
                  NOMECAMPO : AnsiString;
                  CODUSUARIO : AnsiString;
                  CODREL_ : AnsiString;
                  NOMECAMPO_ : AnsiString;
                  LINHAI : Integer;
                  LINHAF : Integer;
                  COLUNA : Integer;
                  TAMANHO : Integer;
                  End;

  ArrayOfTgArrBloqCampos =  Array of TgArrBloqCampos;

//MapaFilU
  TgRegMapa = Array[0..255] of Byte;

//  TInstrucao = Record
//               Tipo : AnsiChar;       // O = Operador; S = Sentença; R = Resultado
//               Campo : AnsiString;    // Guarda o nome do campo ou o operador
//               Operador : AnsiString;
//               Valor : AnsiString;
//               end;

 TPesquisa = Record
             Campo : AnsiChar;
             Pagina : Integer;
             Relativo : Integer;
             Linha : Integer;
             end;

Var

  ListaDeCampos : Array[1..100] Of Record
                                   Campo : AnsiString;
                                   PosCampo,
                                   TamCampo : Integer;
                                   End;

  ArrBloqCampos : ArrayOfTgArrBloqCampos;
// Incluído em 28/03/2008 a pedido do Daniel para tentar minimizar problema na
// Fidelity em que a aplicação trava ao carregar os dados da DFN
  CarregouDfn : Boolean;

// Gerais
  BufI : Pointer;
  MapeouProducao,
  FaiouAbrAssistidoLocal,
  UsouLocalizar : Boolean;
  MensErros,
  StrSrt : TStringList;
//  StatusTabelas : TgStatus;
  ArqCNFG,
  ArqCNFGVJunta : FileOfTgRegDFN;
  RegDestino,
  RegDestinoII,
  RegGrp,
  RegDFN,
  RegSistema,
  RegSisAuto,
  RegIndice,
  CodSeg : TgRegDFN;
  ArrRegIndice : Array[0..199] Of TgRegDFN;
  TipoQuebra,
  pDest,
  LinhaLocalizada,
  ColunaLocalizada,
  TamLocalizada : Integer;
  PaginaAnt : AnsiString;  // XE4
  Pagina : Pointer;  // XE4
  PaPagina : Array[1..133000] of AnsiChar;

  PilhaEspecial, // Guarda a pilha de execução para a pesquisa especial
//  viIndNew,
//  viPgmFiltro,
  viDirTrabApl,
//  viPathProd,
//  viPathBaseLocal,
//  viFlgProd,
//  viPrefDes,
//  viPrefProd,
//  viPrefDesDest,
//  viPrefProdDest,
  viNDiasPerm,
//  viServProd,
  viDirEntraFil,
  viDirSaiFil,
  viBackAutoSN,
  viDirBackAuto,
  viRemoveS1SN,
  viExecAutoSN,
  viInterExecSeg,
  viExtAutoSN,
  viFormExtAuto,
  viSeparacaoAutoSN,
  viDecDoCarac,
  viColDoCarac,
  viLimpaAutoSN,
  viGrupo,
  viSubGrupo,
  viEHost,
  viEUsu,
  viEPort,
  viEFromAd,
  viEFromNm,
  viFWT,
  viFWA,
  viFWP,
  viFWUID,
  viFtpPort,
  viFtpProxy,
  viFtpProxyPort,
  viLimpEntra,
  viLimpSai,
  viDirGravCd,
  RemoteServer,
//  RemoteDataServer,
  RemoteUser,
  PathServer : AnsiString;
//  Senha : AnsiString;      // Guarda a senha geral das tabelas

// MultiCold Limpa
  Termina : Boolean;

// MultiCold Viewer

  WordApp,
  ExcelApp : OleVariant;

  AdicionouPaginaPdf,
  Abrir,
  Exportar,
  Imprimir,
  Primeiro,
  AbriuArqDsc,
  AssisAbreFlg,
  ConectouRemoto,
  PesquisaEspecial,
//  JaAbriu,
  SetouPrivateDir,
  AbriuArqQue,
//  AdcPassWord,
  QuerCancelar,
  TemWord,
  TemExcel : Boolean;
  QtdBytes,
  QtdPaginas,              // Variáveis auxiliares para a abertura remota do relatório...
  ConnectionId,
  CodGrupo,
  IExcel,
  iMaxRegQueryFacil : Integer;
//  Pdf : TDF6toPDFConverter;
  TipoSaida,
  CmdExtra,
  UrlRemoteServer,
  SaveDialog1FileName,
  Tela : AnsiString;
  ArqQue : File of TgStr255; { ShortString; }
  ArqDsc : File;

  ArqDscNew : TFileStream;

  StrCampos : WideString;
  Rel64,
  Rel133,
  CmprBrncs : Byte;
  PaginaCmp : Variant;


  ArDFN : Array Of Record
                   CodRel : AnsiString;
                   CodSis,
                   CodGrupo,
                   CodSubGrupo : Integer;
                   GrupoAuto,
                   SisAuto : Boolean;
                   End;
  ArInc : Array Of Record
                   CodUsu : AnsiString;
                   CodSis,
                   CodGrupo,
                   CodSubGrupo : Integer;
                   CodRel : AnsiString;
                   End;
  ArExc : Array Of Record
                   CodUsu : AnsiString;
                   CodSis,
                   CodGrupo,
                   CodSubGrupo : Integer;
                   CodRel : AnsiString;
                   End;
  ArCompila : Array Of Record
                       CodRel : AnsiString;
                       CodSis,
                       CodGrupo,
                       CodSubGrupo : Integer;
                       End;                 
  ArSis : Array Of Record
                   CodSis : Integer;
                   NomeSis : AnsiString;
                   End;
  ArGrupo : Array Of Record
                     CodSis,
                     CodGrupo : Integer;
                     NomeGrupo : AnsiString;
                     End;
  ArSubGrupo : Array Of Record
                        CodSis,
                        CodGrupo,
                        CodSubGrupo : Integer;
                        NomeSubGrupo : AnsiString;
                        End;

  ArDFNRemoto : Array Of Record
                         CodRel : AnsiString;
                         CodSis,
                         CodGrupo,
                         CodSubGrupo : Integer;
                         GrupoAuto : Boolean;
                         SisAuto : Boolean;
                         End;
  ArIncRemoto : Array Of Record
                         CodUsu : AnsiString;
                         CodSis,
                         CodGrupo,
                         CodSubGrupo : Integer;
                         CodRel : AnsiString;
                         End;
  ArExcRemoto : Array Of Record
                         CodUsu : AnsiString;
                         CodSis,
                         CodGrupo,
                         CodSubGrupo : Integer;
                         CodRel : AnsiString;
                         End;
  ArSisRemoto : Array Of Record
                         CodSis : Integer;
                         NomeSis : AnsiString;
                         End;
  ArGrupoRemoto : Array Of Record
                         CodSis,
                         CodGrupo : Integer;
                         NomeSis,
                         NomeGrupo : AnsiString;
                         End;
  ArSubGrupoRemoto : Array Of Record
                         CodSis,
                         CodGrupo,
                         CodSubGrupo : Integer;
                         NomeSubGrupo : AnsiString;
                         End;
  ArrSisAuxRemoto : Array Of Record
                         CodRel : AnsiString;
                         CodSis,
                         CodGrupo : Integer;
                         LinI,
                         LinF,
                         Col : Integer;
                         Tipo,
                         CodAux : AnsiString;
                         End;


// Indexador
  Agora : TDateTime;
  Separou,
  Processou : Boolean;     // Controla o fechamento das janelas de Separação e Filtro
  DirBack : AnsiString;

// MapaFilU
  RegMapa : TgRegMapa;

// Separ
 arPagina : Array [1..5001] Of AnsiString;
 ArrRel : Array Of Record
                   CodRel : AnsiString;
                   CodSis,
                   Col1,
                   Lin1 : Integer;
                   StrId1 : AnsiString;   // Primeiro identificador do relatório - obrigatório
                   Col2,
                   Lin2 : Integer;
                   StrId2 : AnsiString;   // Segundo identificador do relatório  - opcional
                   Col3,
                   Lin3,
                   Tam3 : Integer;    // Posição da identificação do grupo a que pertence o relatório - opcional
                   Tipo3 : AnsiString;
                   SisAuto : AnsiString;
                   End;

 ArrStrAuxAlfa : Array Of Record
                          CodSis,
                          CodGrupo : Integer;
                          StrPsq : AnsiString;
                          End;

 ArrStrAlfa : Array Of Record
                       CodSis,
                       CodGrupo : Integer;
                       StrPsq : AnsiString;
                       End;

 ArrSisAux : Array Of Record
                      CodRel : AnsiString;
                      CodSis,
                      CodGrupo : Integer;
                      LinI,
                      LinF,
                      Col : Integer;
                      Tipo,
                      CodAux : AnsiString;
                      End;

 ArrSisAux2 : Array Of Record
                      CodRel : AnsiString;
                      CodSis,
                      CodGrupo : Integer;
                      End;

  QtdTent : Integer;
  Grupo : AnsiString;
  DataCorte : AnsiString;


//Filtro
  ControleFiltro : AnsiChar;

  FormGeral: TFormGeral;

Implementation

Uses Subrug, Avisoi;

{$R *.DFM}

Function TFiltro.EncheFiltro(Celula, Nome : AnsiString; Var Filtro : SetOfChar; Ind : Integer) : Boolean;

Var
  M : Integer;
  CharFiltro : TgStr255;

Begin
EncheFiltro := True;
M := 1;
Repeat
  CharFiltro := '';
  While (Length(CharFiltro) <> 3) And
        (M <= Length(Celula)) Do
    Begin
    CharFiltro := CharFiltro + Celula[M];
    Inc(M);
    End;
  If CharFiltro[3] = '.' Then
    While (Length(CharFiltro) <> 6) And
          (M <= Length(Celula)) Do
      Begin
      CharFiltro := CharFiltro + Celula[M];
      Inc(M);
      End;
Inc(M,1); { Para fugir da vírgula}
If Length(CharFiltro) = 3 Then
  Begin
  If (CharFiltro[1] <> CharFiltro[3]) Or (CharFIltro[1] <> '''') Then
    Begin
    MensErros.Add('Filtro Inválido: Campo'+IntToStr(Ind)+' "'+Nome+'"');
    EncheFiltro := False;
    Exit;
    End;
  Filtro := Filtro + [CharFiltro[2]];
  End
Else
  Begin
  If (CharFiltro[1] <> CharFiltro[6]) Or (CharFIltro[1] <> '''') Then
    Begin
    MensErros.Add('Filtro Inválido: Campo'+IntToStr(Ind)+' "'+Nome+'"');
    EncheFiltro := False;
    Exit;
    End;
  Filtro := Filtro + [CharFiltro[2]..CharFiltro[5]];
  End;
Until M >= Length(Celula);
End;

Function TFiltro.EncheStr(Celula, Nome : TgStr255; Var StrFil : TgStrStr; Ind : Integer) : Boolean;

Var
  Err : Integer;
  N : Integer;
  CharFiltro : TgStr255;

Begin
EncheStr := True;   // Assume tudo ok
N := 1;
CharFiltro := '';
While (Celula[N] <> ',') And
      (N <= Length(Celula)) Do
  Begin
  CharFiltro := CharFiltro + Celula[N];
  Inc(N);
  End;
Inc(N); { Fugir da Vírgula }
Val(CharFiltro,StrFil.Col,Err);
If (Err <> 0) Or (CharFiltro = '') Then
    Begin
    MensErros.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
    EncheStr := False;
    Exit;
    End;

CharFiltro := '';
While (Celula[N] <> '=') And
      (N <= Length(Celula)) Do
  Begin
  CharFiltro := CharFiltro + Celula[N];
  Inc(N);
  End;
Inc(N); { Fugir do igual }
Val(CharFiltro,StrFil.Tam,Err);
If (Err <> 0) Or (CharFiltro = '') Then
    Begin
    MensErros.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
    EncheStr := False;
    Exit;
    End;

CharFiltro := '';
While (N <= Length(Celula)) Do
  Begin
  CharFiltro := CharFiltro + Celula[N];
  Inc(N);
  End;
If (CharFiltro[1] <> CharFiltro[Length(CharFiltro)]) Or
   (CharFiltro[1] <> '''') Then
  Begin
  MensErros.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
  EncheStr := False;
  Exit;
  End;
If (StrFil.Tam <> Length(CharFiltro)-2) Then
  Begin
  MensErros.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
  EncheStr := False;
  Exit;
  End;
StrFil.FilStr := Copy(CharFiltro,2,Length(CharFiltro)-2);
End;

Procedure TFormGeral.InsereLog(Arquivo,Mensagem : AnsiString);
Begin

if not DatabaseLog.Connected then
  DatabaseLog.Open;

QueryInsertLogProc.Prepared := false;
QueryInsertLogProc.SQL.Clear;
QueryInsertLogProc.Parameters.Clear;
QueryInsertLogProc.Fields.Clear;
QueryInsertLogProc.SQL.Add('insert into logproc (dtLote,  hrLote, dtProc, hrProc, arquivo, mensagem) ');
QueryInsertLogProc.SQL.Add('values (:a, :b, :c, :d, :e, :f) ');
QueryInsertLogProc.Prepared := true;

QueryInsertLogProc.Parameters[0].Value := Agora;
QueryInsertLogProc.Parameters[1].Value := Agora;
QueryInsertLogProc.Parameters[2].Value := Now;
QueryInsertLogProc.Parameters[3].Value := Now;
QueryInsertLogProc.Parameters[4].Value := copy(Arquivo,1,255);
QueryInsertLogProc.Parameters[5].Value := copy(Mensagem,1,512);

try
  QueryInsertLogProc.ExecSQL;
except
end; // Try

End;

{Procedure TFormGeral.Conecta;

Begin
Screen.Cursor := crSQLWait;

DatabaseLocal.Connected := False;
DatabaseLog.Connected := False;
DatabaseEventos.Connected := False;

Try
  DatabaseLocal.Connected := True;
  DatabaseLog.Connected := True;
Except
  If (UpperCase(ExtractFileName(ParamStr(0))) = 'MULTICOLDADM.EXE') Then
    If (MapeouProducao) Then
      ShowMessage('Servidor remoto inacessível. Operações na produção não serão possíveis')
    Else
      ShowMessage('Servidor interbase local não operacional.......')
  Else
    ShowMessage('Servidor interbase local não operacional.......');
  Exit;
  End; //Try

Try
  DatabaseEventos.Connected := True;
Except
  End; // Try

Screen.Cursor := crDefault;
End;}

Procedure TFormGeral.FormCreate(Sender: TObject);
Begin
FormGeral.Visible := false;
ControleFiltro := ' ';
Exportar := False;
Abrir := False;
Imprimir := False;
Primeiro := True;
AdicionouPaginaPdf := False;
PesquisaEspecial := False;

SetLength(ArDFN,0);  // Inicializa estas variáveis para o MultiCold Viewer... e para o Limpeza...
SetLength(ArInc,0);
SetLength(ArExc,0);

iMaxRegQueryFacil := 1000;

if fileExists(extractFilePath(ParamStr(0))+'Multicold.udl') then
  begin
  DataBaseMultiCold.ConnectionString := 'FILE NAME=MultiCold.udl';
  try
    DatabaseMulticold.Open;
  except
    //application.Terminate;
  end;
  end;

if fileExists(extractFilePath(ParamStr(0))+'MultiColdEventos.udl') then
  begin
  DataBaseEventos.ConnectionString := 'FILE NAME=MultiColdEventos.udl';
  try
    DatabaseEventos.Open;
  except
    //application.Terminate;
  end;
  end;

if fileExists(extractFilePath(ParamStr(0))+'MultiColdLog.udl') then
  begin
  DataBaseLog.ConnectionString := 'FILE NAME=MultiColdLog.udl';
  try
    DatabaseLog.Open;
  except
    //application.Terminate;
  end;
  end;
End;

Procedure TFormGeral.LerIni;
Begin

QueryAux1.SQL.Clear;
QueryAux1.SQL.Add('SELECT B.nomeCampo, A.valorCampo, A.campoID, A.codUsuario');
QueryAux1.SQL.Add('FROM CONFIGURACAO A INNER JOIN NOMECAMPO B ON A.campoID = B.campoID');
QueryAux1.SQL.Add('WHERE (A.codUsuario = ''ADM'') ');
QueryAux1.SQL.Add('ORDER BY A.campoID');
QueryAux1.Open;

While Not QueryAux1.Eof Do
  Begin
  If QueryAux1.Fields[0].AsString = 'DIASPERMANENCIA' Then
    viNDiasPerm := stringReplace(QueryAux1.Fields[1].AsString, '/', '', [rfReplaceAll])
  Else
  If QueryAux1.Fields[0].AsString = 'DIRETORIOTRABALHO' Then
    viDirTrabApl := IncludeTrailingPathDelimiter(QueryAux1.Fields[1].AsString)
  Else
  If QueryAux1.Fields[0].AsString = 'DIRENTRA' Then
    viDirEntraFil := IncludeTrailingPathDelimiter(QueryAux1.Fields[1].AsString)
  Else
  If QueryAux1.Fields[0].AsString = 'DIRSAI' Then
    viDirSaiFil := IncludeTrailingPathDelimiter(QueryAux1.Fields[1].AsString)
  Else
  If QueryAux1.Fields[0].AsString = 'BACKUPAUTOMATICO' Then
    viBackAutoSN := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'DIRETORIOBACKUP' Then
    viDirBackAuto := IncludeTrailingPathDelimiter(QueryAux1.Fields[1].AsString)
  Else
  If QueryAux1.Fields[0].AsString = 'REMOVERS1' Then
    viRemoveS1SN := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'EXECUCAOAUTOMATICA' Then
    viExecAutoSN := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'INTERVALO' Then
    viInterExecSeg := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'EXTENSAOAUTOMATICA' Then
    viExtAutoSN := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'FORMATOEXTENSAO' Then
    viFormExtAuto := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'SEPARACAOAUTOMATICA' Then
    viSeparacaoAutoSN := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'DECIMALCARACTEREQUEBRA' Then
    viDecDoCarac := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'COLUNACARACTEREQUEBRA' Then
    viColDoCarac := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'LIMPEZAAUTOMATICA' Then
    viLimpaAutoSN := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'GRUPO' Then
    viGrupo := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'SUBGRUPO' Then
    viSubGrupo := QueryAux1.Fields[1].AsString
  Else
  If QueryAux1.Fields[0].AsString = 'DIRETORIOENTRADA' Then
    viLimpEntra := IncludeTrailingPathDelimiter(QueryAux1.Fields[1].AsString)
  Else
  If QueryAux1.Fields[0].AsString = 'DIRETORIOSAIDA' Then
    viLimpSai := IncludeTrailingPathDelimiter(QueryAux1.Fields[1].AsString)
  Else
  If QueryAux1.Fields[0].AsString = 'DIRETORIOGRAVACAO' Then
    viDirGravCd := IncludeTrailingPathDelimiter(QueryAux1.Fields[1].AsString);
  QueryAux1.Next;
  End;

QueryAux1.Close;

If (UpperCase(ExtractFileName(ParamStr(0))) = 'MULTICOLDADM.EXE') Or
   (UpperCase(ExtractFileName(ParamStr(0))) = 'MULTICOLDINDEXA.EXE') Then
  Begin
  {$i-}
  ChDir(viDirTrabApl);
  {$i+}
  If IoResult <> 0 Then
    Begin
    ShowMessage('Diretório de Trabalho especificado é inválido, verifique...');
    Application.Terminate;
    End;
  End;

FormGeral.DatabaseMulticold.Close;
FormGeral.DatabaseEventos.Close;
FormGeral.DatabaseLog.Close;

End;

Procedure TFormGeral.LerMapa;
Begin
QueryAux1.SQL.Clear;
QueryAux1.SQL.Add('SELECT * ');
QueryAux1.SQL.Add('FROM MAPACARACTERE A');
QueryAux1.SQL.Add('WHERE (A.CODUSUARIO = ''ADM'') ');
QueryAux1.SQL.Add('ORDER BY A.CODCARACTEREENTRA');
QueryAux1.Open;

While Not QueryAux1.Eof Do
  Begin
  RegMapa[QueryAux1.Fields[1].AsInteger] := QueryAux1.Fields[2].AsInteger;
  QueryAux1.Next;
  End;

QueryAux1.Close;
End;

Procedure TFormGeral.InsereAtualizaCompila;
Begin

If Operacao = '+' Then
  Begin
  SelectCompilaQuery.Parameters[0].Value := CodRel;
  SelectCompilaQuery.Parameters[1].Value := CodSis;
  SelectCompilaQuery.Parameters[2].Value := CodGrupo;
  SelectCompilaQuery.Parameters[3].Value := CodSubGrupo;
  Try
    SelectCompilaQuery.Open;
    Inc(Cont,SelectCompilaQuery.Fields[0].AsInteger);
  Except
    End; // Try
  SelectCompilaQuery.Close;
  End;

InsereCompilaQuery.Parameters[0].Value := CodRel;
InsereCompilaQuery.Parameters[1].Value := CodSis;
InsereCompilaQuery.Parameters[2].Value := CodGrupo;
InsereCompilaQuery.Parameters[3].Value := CodSubGrupo;
InsereCompilaQuery.Parameters[4].Value := Cont;
Try
  InsereCompilaQuery.ExecSQL;
  Exit;
Except
  End;

UpdateCompilaQuery.Parameters[0].Value := Cont;
UpdateCompilaQuery.Parameters[1].Value := CodRel;
UpdateCompilaQuery.Parameters[2].Value := CodSis;
UpdateCompilaQuery.Parameters[3].Value := CodGrupo;
UpdateCompilaQuery.Parameters[4].Value := CodSubGrupo;
UpdateCompilaQuery.ExecSQL;

End;

Procedure Verifica(iI : Integer; Carac : AnsiChar; Lim1, Lim2 : Integer; Mens : AnsiString; Var AuxStr : AnsiString);
Var
  Qtd,
  I : Integer;
Begin
If iI <> 0 Then
  Begin
  Qtd := 0;
  For I := iI To Length(AuxStr) Do
    If AuxStr[I] = Carac Then
      Inc(Qtd)
    Else
      Break;
  If Not (Qtd In [Lim1,Lim2]) Then
    Begin
    ShowMessage(Mens);
    Abort;
    Exit;
    End;
  Delete(AuxStr,iI,Qtd);
  End;
End;

Procedure TFormGeral.InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : AnsiString;
                                       Grupo, SubGrupo, CodMens : Integer);
Var
  Agora : TDateTime;
Begin
If UpperCase(ExtractFileName(ParamStr(0))) = 'MULTICOLDINDEXA.EXE' Then
  Exit;
If DatabaseEventos.Connected = False Then
  Begin
  Try
    DatabaseEventos.Connected := True;
  Except
    Exit
    End;
  End;

If DatabaseEventos.InTransaction Then
  DatabaseEventos.CommitTrans;
DatabaseEventos.BeginTrans;

Agora := Now;
Try
  EventosQuery1.Close;
  EventosQuery1.Sql.Clear;
  EventosQuery1.Sql.Add('INSERT INTO EVENTOS_VISU (DT, HR, ARQUIVO, DIRETORIO, CODREL, GRUPO, SUBGRUPO, CODUSUARIO, NOMEGRUPOUSUARIO, CODMENSAGEM) ');
  EventosQuery1.SQL.Add('VALUES (:a, :b, :c, :d, :e, :f, :g, :h, :i, :j)');
  EventosQuery1.Parameters[0].Value := Agora;
  EventosQuery1.Parameters[1].Value := Agora;
  EventosQuery1.Parameters[2].Value := Copy(Arquivo, 1, 70);
  EventosQuery1.Parameters[3].Value := Copy(Diretorio, 1, 70);
  EventosQuery1.Parameters[4].Value := CodRel;
  EventosQuery1.Parameters[5].Value := Grupo;
  EventosQuery1.Parameters[6].Value := SubGrupo;
  EventosQuery1.Parameters[7].Value := CodUsuario;
  EventosQuery1.Parameters[8].Value := NomeGrupoUsuario;
  EventosQuery1.Parameters[9].Value := CodMens;
  EventosQuery1.ExecSql;
  DatabaseEventos.CommitTrans;
Except
  DatabaseEventos.RollbackTrans;
  End; // Try
End;

Procedure TFormGeral.InsereEventos(V1, V2, V3 : AnsiString; V4 : Integer; Const Reg : AnsiString);
Var
  Agora : TDateTime;
Begin
If UpperCase(ExtractFileName(ParamStr(0))) = 'MULTICOLDINDEXA.EXE' Then
  Exit;
If DatabaseEventos.Connected = False Then
  Begin
  Try
    DatabaseEventos.Connected := True;
  Except
    Exit
    End;
  End;

If DatabaseEventos.InTransaction Then
  DatabaseEventos.CommitTrans;
DatabaseEventos.BeginTrans;

If Length(V1) > 60 Then
  SetLength(V1,60);
If Length(V2) > 60 Then
  SetLength(V2,60);
If Length(V3) > 20 Then
  SetLength(V3,20);

Agora := Now;

Try
  EventosQuery1.Close;
  EventosQuery1.Sql.Clear;
  EventosQuery1.Sql.Add('INSERT INTO EVENTOS (DT, HR, OBJETO, ITEM, CODUSUARIO, CODMENSAGEM) VALUES (:a, :b, :c, :d, :e, :f)');
  EventosQuery1.Parameters[0].Value := Agora;
  EventosQuery1.Parameters[1].Value := Agora;
  EventosQuery1.Parameters[2].Value := V1;
  EventosQuery1.Parameters[3].Value := V2;
  EventosQuery1.Parameters[4].Value := V3;
  EventosQuery1.Parameters[5].Value := V4;
  EventosQuery1.ExecSql;
  DatabaseEventos.CommitTrans;
  If Reg <> '' Then
    Begin
    DatabaseEventos.BeginTrans;
    EventosQuery1.Close;
    EventosQuery1.Sql.Clear;
    EventosQuery1.Sql.Add('INSERT INTO REGISTROS (DT, HR, CONTEUDO) VALUES (:A,:B,:C) ');
    EventosQuery1.Parameters[0].Value := Agora;
    EventosQuery1.Parameters[1].Value := Agora;
    EventosQuery1.Parameters[2].Value := Reg;
    //Gabriel - 30/06/2005
    //EventosQuery1.Sql.Add(''''+FormatDateTime('MM/DD/YYYY',Agora)+''',');
    //EventosQuery1.Sql.Add(''''+FormatDateTime('HH:NN:SS:ZZZ',Agora)+''',');
    //EventosQuery1.Sql.Add(''''+REG+''')');
    Try
      EventosQuery1.ExecSql;
      DatabaseEventos.CommitTrans;
    Except
      DatabaseEventos.RollbackTrans;
      End; // Try
    End;
Except
  DatabaseEventos.RollbackTrans;
  End; // Try
End;

Procedure TFormGeral.MostraMensagem;
Begin
If PesquisaEspecial Then
  Begin
  Avisop.Label1.Caption := Mensagem;
  Avisop.Show;
  End
Else
  ShowMessage(Mensagem);
End;

Begin
MapeouProducao := False;
MensErros := TStringList.Create;
StrSrt := TStringList.Create;
//Senha := 'ghqp4908'; 'c2e0f945';
End.


