Unit Sugeral;

//Revisado SQLServer...

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, IniFiles, SuTypGer, StdCtrls, SuTypMultiCold,
  ADODB, InvokeRegistry, Rio, SOAPHTTPClient, System.Net.URLClient,
  Datasnap.Provider, Datasnap.DBClient, IMulticoldServer1, UMetodosServer,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.FireDACJSONReflect,
  REST.Response.Adapter, System.JSON, System.Zip;

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
    ADOQueryProcessadorTemplate: TADOQuery;
    CDSProcessadorTemplate: TClientDataSet;
    DSPProcessadorTemplate: TDataSetProvider;
    CDSProcessadorTemplateDataCriacao: TDateTimeField;
    CDSProcessadorTemplateNomeTemplate: TStringField;
    CDSProcessadorTemplateStatus: TStringField;
    CDSProcessadorTemplateStatusProcessamento: TStringField;
    ADOCmdInsert: TADOCommand;
    ADOCmdInsertExection: TADOCommand;
    ADOQryGetId: TADOQuery;
    ADOQryGetIdId: TIntegerField;
    ADOQueryTemplate: TADOQuery;
    CDSProcessadorTemplatePathArquivoExportacao: TStringField;
    CDSProcessadorTemplateIdReferencia: TIntegerField;
    CDSProcessadorTemplateTipoProcessamento: TIntegerField;
    CDSProcessadorTemplateCODUSUARIO: TStringField;
    CDSProcessadorTemplateTipo: TStringField;
    CDSProcessadorTemplateId: TIntegerField;
    ADOCmdInsertDescomp: TADOCommand;
    ADOCmdInsertPesq: TADOCommand;
    ADOQryGetIdDescomp: TADOQuery;
    ADOCmdInsertExecutionDescomp: TADOCommand;
    Memtb: TFDMemTable;
    Procedure FormCreate(Sender: TObject);
    procedure CDSProcessadorTemplateCalcFields(DataSet: TDataSet);
  Private
    { Private declarations }
    OMetodosServer : clsMetodosServer;

    procedure ConfigurarConnect;

  Public
    FMulticoldServer: IMulticoldServer;
    SemServidor, ModoOff : Boolean;
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
    procedure ImportarDados( StrSql : String; strPar : TFDParams);
    function BaixarArquivo( arq : String) : TJSONArray;
    procedure Persistir( StrSql : String; StgParam : TFDParams);
    procedure JsonToDataset(aDataset : TDataSet; aJSON : string);
    function AbreRelatorio(Usuario: WideString; Senha: WideString; ConnectionID: Integer; FullPath: WideString; QtdPaginas: Integer; StrCampos: WideString;
                            Rel64: Byte; Rel133: Byte; CmprBrncs: Byte): String;
    function GetPagina(Usuario: WideString; Senha: WideString; ConnectionID: Integer; Relatorio: WideString; PagNum: Integer; QtdBytes: Integer;
                         Pagina: WideString): WideString;
    function LogIn(Usuario, Senha: WideString;
      ConnectionID: Integer): String;
    function GetRelatorio(Usuario, Senha: WideString; ConnectionID: Integer; ListaCodRel: WideString; FullPaths: WideString; tipo : Integer): String;

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
var
  strlst : TStringlist;
  strPar : TFDParams;
  Param  : TFDParam;
Begin
 {
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

  }
  strPar := TFDParams.Create;
  strLst := TStringList.Create;
  strlst.Add('insert into logproc (dtLote,  hrLote, dtProc, hrProc, arquivo, mensagem) ');
  strlst.Add('values ( ');
  strlst.Add(QuotedStr(FormatDateTime('YYYY/MM/DD hh:mm:ss',Agora)) + ',');
  strlst.Add(QuotedStr(FormatDateTime('YYYY/MM/DD hh:mm:ss',Agora)) + ',');
  strlst.Add(QuotedStr(FormatDateTime('YYYY/MM/DD hh:mm:ss',Now)) + ',');
  strlst.Add(QuotedStr(FormatDateTime('YYYY/MM/DD hh:mm:ss',Now)) + ',');
  strlst.Add(QuotedStr(copy(Arquivo,1,255)) + ',');
  strlst.Add(QuotedStr(copy(Mensagem,1,512)));

  Persistir(strLst.Text, nil);
  Freeandnil(strlst);
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

procedure TFormGeral.CDSProcessadorTemplateCalcFields(DataSet: TDataSet);
begin
  if DataSet.FieldByName('StatusProcessamento').AsString = 'P' then
    DataSet.FieldByName('Status').AsString := 'Pendente'
  else
  if DataSet.FieldByName('StatusProcessamento').AsString = 'E' then
    DataSet.FieldByName('Status').AsString := 'Em andamento'
  else
  if DataSet.FieldByName('StatusProcessamento').AsString = 'S' then
    DataSet.FieldByName('Status').AsString := 'Finalizado'
  else
    DataSet.FieldByName('Status').AsString := 'Erro';

  if DataSet.FieldByName('TipoProcessamento').AsString = '1' then
    DataSet.FieldByName('Tipo').AsString := 'Extrator'
  else
    DataSet.FieldByName('Tipo').AsString := 'Descompactador';
end;

procedure TFormGeral.ConfigurarConnect;
var
  {OMetodosServer : clsMetodosServer;}
  servidor, driverservidor, porta,
  banco, usuario, senha, NomeEstacao: string;
begin
  try
    {
    OMetodosServer := clsMetodosServer.Create(Self);
    OMetodosServer.Configurar;
    OMetodosServer.ServerMethodsPrincipalClient.RetornarParametrosConn(servidor,
    driverservidor, porta, banco, usuario, senha, NomeEstacao);
    DatabaseMultiCold.ConnectionString := 'Provider='+DriverServidor+';'+
                                          'Persist Security Info=True;'+
                                          'User ID='+usuario+';'+
                                          'Password='+senha+';'+
                                          'Initial Catalog='+banco+';'+
                                          'Data Source='+servidor+';'+
                                          'Auto Translate=True;'+
                                          'Packet Size=4096;'+
                                          'Workstation ID='+NomeEstacao+';'+
                                          'Network Library=DBMSSOCN';
    }
    //DatabaseMultiCold.Connected := True;
    //ShowMessage('Conexão Ativa');
  except
    begin
      ShowMessage('Falha na conexão com o servidor');
      Application.Terminate;
      exit;
    end;
  end;

  FreeAndNil(OMetodosServer);
end;

procedure TFormGeral.FormCreate(Sender: TObject);
Begin
{
  if not fileExists(extractFilePath(ParamStr(0))+'Multicold.udl') then
  begin
    ConfigurarConnect;
    try
      DatabaseMulticold.Open;
    except
      ShowMessage('Falha na conexão com o servidor');
      Application.Terminate;
      exit;
    end;
  end;
}

  OMetodosServer := clsMetodosServer.Create(Self);
  OMetodosServer.Configurar;
  SemServidor := OMetodosServer.SemServidor;
  ModoOff     := OMetodosServer.ModoOff;
  if (SemServidor) and (not ModoOff) then
  begin
    ShowMessage('Servidor Multicold não encontrado');
    Application.Terminate;
    Close;
  end;
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
exit;


if fileExists(extractFilePath(ParamStr(0))+'Multicold.udl') then
  begin
    DataBaseMultiCold.ConnectionString := 'FILE NAME=MultiCold.udl';
    {$IFDEF DEBUG}
    DataBaseMultiCold.ConnectionString := 'FILE NAME=C:\ROM\MULTICOLD\MultiCold.udl';
    {$ENDIF}
    try
      //DatabaseMulticold.Open;
    except
      //application.Terminate;
    end;
  end;

if fileExists(extractFilePath(ParamStr(0))+'MultiColdEventos.udl') then
  begin
    DataBaseEventos.ConnectionString := 'FILE NAME=MultiColdEventos.udl';
    {$IFDEF DEBUG}
    DataBaseEventos.ConnectionString := 'FILE NAME=C:\ROM\MULTICOLD\MultiColdEventos.udl';
    {$ENDIF}
    try
      //DatabaseEventos.Open;
    except
      //application.Terminate;
    end;
  end;

if fileExists(extractFilePath(ParamStr(0))+'MultiColdLog.udl') then
  begin
    DataBaseLog.ConnectionString := 'FILE NAME=MultiColdLog.udl';
    {$IFDEF DEBUG}
    DataBaseLog.ConnectionString := 'FILE NAME=C:\ROM\MULTICOLD\MultiColdLog.udl';
    {$ENDIF}
    try
      //DatabaseLog.Open;
    except
      //application.Terminate;
    end;
  end;

End;

procedure TFormGeral.JsonToDataset(aDataset : TDataSet; aJSON : string);
var
  JObj: TJSONArray;
  vConv : TCustomJSONDataSetAdapter;
begin
  if (aJSON = EmptyStr) then
  begin
    Exit;
  end;

  JObj := TJSONObject.ParseJSONValue(aJSON) as TJSONArray;
  vConv := TCustomJSONDataSetAdapter.Create(Nil);

  try
    vConv.Dataset := aDataset;
    vConv.UpdateDataSet(JObj);
  finally
    vConv.Free;
    JObj.Free;
  end;
end;

function TFormGeral.GetPagina(Usuario: WideString; Senha: WideString; ConnectionID: Integer; Relatorio: WideString; PagNum: Integer; QtdBytes: Integer;
                         Pagina: WideString): WideString;
begin
  result := OMetodosServer.ServerMethodsPrincipalClient.GetPagina(Usuario,Senha,ConnectionID,Relatorio,
                         PagNum,QtdBytes,Pagina);
end;

function TFormGeral.GetRelatorio(Usuario, Senha: WideString;
  ConnectionID: Integer; ListaCodRel, FullPaths: WideString; tipo : Integer): String;
begin
  result := OMetodosServer.ServerMethodsPrincipalClient.GetRelatorio(Usuario, Senha,
  ConnectionID, ListaCodRel, FullPaths, tipo);
end;

function TFormGeral.AbreRelatorio(Usuario, Senha: WideString;
  ConnectionID: Integer; FullPath: WideString; QtdPaginas: Integer;
  StrCampos: WideString; Rel64, Rel133, CmprBrncs: Byte): String;
begin
  result := OMetodosServer.ServerMethodsPrincipalClient.AbreRelatorio(Usuario, Senha,
  ConnectionID, FullPath, QtdPaginas, StrCampos, Rel64, Rel133, CmprBrncs);
end;

function TFormGeral.BaixarArquivo( arq : String) : TJSONArray;
begin
  result := OMetodosServer.ServerMethodsPrincipalClient.BaixarArquivo(arq);
end;

procedure TFormGeral.ImportarDados( StrSql : String; strPar : TFDParams);
var
  LDataSetList: TFDJSONDataSets;
  json : String;
begin
    MemTb.Close;
    //LDataSetList := OMetodosServer.ServerMethodsPrincipalClient.RetornarDadosBanco(StrSql);
    json := OMetodosServer.ServerMethodsPrincipalClient.RetornarDadosBanco(StrSql);
    if json = ']' then
      json := '[]';
    JsonToDataset(MemTb, json);

    //MemTb.AppendData(
    //  TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
    if json <> '[]' then
      MemTb.Open;
end;

procedure TFormGeral.Persistir( StrSql : String; StgParam : TFDParams);
begin
  OMetodosServer.ServerMethodsPrincipalClient.PersistirBanco(StrSql);
end;

Procedure TFormGeral.LerIni;
  var strlst : TStringList;
Begin

  //QueryAux1.SQL.Clear;
  //QueryAux1.SQL.Add('SELECT B.nomeCampo, A.valorCampo, A.campoID, A.codUsuario');
  //QueryAux1.SQL.Add('FROM CONFIGURACAO A INNER JOIN NOMECAMPO B ON A.campoID = B.campoID');
  //QueryAux1.SQL.Add('WHERE (A.codUsuario = ''ADM'') ');
  //QueryAux1.SQL.Add('ORDER BY A.campoID');
  //QueryAux1.Open;

  strlst.Add('SELECT B.nomeCampo, A.valorCampo, A.campoID, A.codUsuario');
  strlst.Add('FROM CONFIGURACAO A INNER JOIN NOMECAMPO B ON A.campoID = B.campoID');
  strlst.Add('WHERE (A.codUsuario = ''ADM'') ');
  strlst.Add('ORDER BY A.campoID');
  ImportarDados(strlst.Text, nil);

  While Not memtb.Eof Do
    Begin
    If memtb.Fields[0].AsString = 'DIASPERMANENCIA' Then
      viNDiasPerm := stringReplace(memtb.Fields[1].AsString, '/', '', [rfReplaceAll])
    Else
    If memtb.Fields[0].AsString = 'DIRETORIOTRABALHO' Then
      viDirTrabApl := IncludeTrailingPathDelimiter(memtb.Fields[1].AsString)
    Else
    If memtb.Fields[0].AsString = 'DIRENTRA' Then
      viDirEntraFil := IncludeTrailingPathDelimiter(memtb.Fields[1].AsString)
    Else
    If memtb.Fields[0].AsString = 'DIRSAI' Then
      viDirSaiFil := IncludeTrailingPathDelimiter(memtb.Fields[1].AsString)
    Else
    If memtb.Fields[0].AsString = 'BACKUPAUTOMATICO' Then
      viBackAutoSN := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'DIRETORIOBACKUP' Then
      viDirBackAuto := IncludeTrailingPathDelimiter(memtb.Fields[1].AsString)
    Else
    If memtb.Fields[0].AsString = 'REMOVERS1' Then
      viRemoveS1SN := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'EXECUCAOAUTOMATICA' Then
      viExecAutoSN := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'INTERVALO' Then
      viInterExecSeg := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'EXTENSAOAUTOMATICA' Then
      viExtAutoSN := memtb.Fields[1].AsString
    Else
    If QueryAux1.Fields[0].AsString = 'FORMATOEXTENSAO' Then
      viFormExtAuto := QueryAux1.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'SEPARACAOAUTOMATICA' Then
      viSeparacaoAutoSN := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'DECIMALCARACTEREQUEBRA' Then
      viDecDoCarac := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'COLUNACARACTEREQUEBRA' Then
      viColDoCarac := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'LIMPEZAAUTOMATICA' Then
      viLimpaAutoSN := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'GRUPO' Then
      viGrupo := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'SUBGRUPO' Then
      viSubGrupo := memtb.Fields[1].AsString
    Else
    If memtb.Fields[0].AsString = 'DIRETORIOENTRADA' Then
      viLimpEntra := IncludeTrailingPathDelimiter(memtb.Fields[1].AsString)
    Else
    If QueryAux1.Fields[0].AsString = 'DIRETORIOSAIDA' Then
      viLimpSai := IncludeTrailingPathDelimiter(memtb.Fields[1].AsString)
    Else
    If memtb.Fields[0].AsString = 'DIRETORIOGRAVACAO' Then
      viDirGravCd := IncludeTrailingPathDelimiter(memtb.Fields[1].AsString);
    memtb.Next;
  End;

  memtb.Close;

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

//FormGeral.DatabaseMulticold.Close;
//FormGeral.DatabaseEventos.Close;
//FormGeral.DatabaseLog.Close;

End;

Procedure TFormGeral.LerMapa;
  var strlst : TStringList;
Begin
//QueryAux1.SQL.Clear;
//QueryAux1.SQL.Add('SELECT * ');
//QueryAux1.SQL.Add('FROM MAPACARACTERE A');
//QueryAux1.SQL.Add('WHERE (A.CODUSUARIO = ''ADM'') ');
//QueryAux1.SQL.Add('ORDER BY A.CODCARACTEREENTRA');
//QueryAux1.Open;

  strlst.Add('SELECT * ');
  strlst.Add('FROM MAPACARACTERE A');
  strlst.Add('WHERE (A.CODUSUARIO = ''ADM'') ');
  strlst.Add('ORDER BY A.CODCARACTEREENTRA');

  ImportarDados(strlst.Text, nil);

  While Not memtb.Eof Do
    Begin
      RegMapa[memtb.Fields[1].AsInteger] := memtb.Fields[2].AsInteger;
      memtb.Next;
    End;

  memtb.Close;
End;

function TFormGeral.LogIn(Usuario, Senha: WideString;
  ConnectionID: Integer): String;
begin
  result := OMetodosServer.ServerMethodsPrincipalClient.LogIn(Usuario,Senha,ConnectionID);
end;

Procedure TFormGeral.InsereAtualizaCompila;
var
  strlst : TStringlist;
  strPar : TFDParams;
  Param  : TFDParam;
Begin
  strPar := TFDParams.Create;
  strLst := TStringList.Create;
  strlst.Add('SELECT QTDCOMPIL FROM COMPILA WHERE ');
  strlst.Add('CODREL = ' + QuotedStr(CodRel) + ' AND ');
  strlst.Add('CODSIS = ' + IntToStr(CodSis) + ' AND  ');
  strlst.Add('CODGRUPO = ' + IntToStr(CodGrupo) + ' AND ');
  strlst.Add('CODSUBGRUPO = ' + IntToStr(CodSubGrupo) );

  If Operacao = '+' Then
    Begin

      ImportarDados(strlst.Text, nil);
      Try
        if Memtb.Active then
          Inc(Cont,Memtb.Fields[0].AsInteger);
      Except
      End; // Try

      Memtb.Close;
    End;
  Param := strPar.Add;
  Param.Name := ':e';
  Param.Value := Cont;

  strlst.Clear;
  strlst.add(' INSERT INTO COMPILA (CODREL, CODSIS, CODGRUPO, CODSUBGRUPO, QTDCOMPIL)  ');
  strlst.add(' VALUES (' );
  strlst.add(QuotedStr(CodRel) + ',');
  strlst.add(IntToStr(CodSis)  + ',');
  strlst.add(IntToStr(CodGrupo) + ',');
  strlst.add(IntToStr(CodSubGrupo)+ ',');
  strlst.add(IntToStr(Cont) + ')');
  Try
    Persistir(strlst.Text, nil);
    Exit;
  Except
  End;

  //UpdateCompilaQuery.Parameters[0].Value := Cont;
  //UpdateCompilaQuery.Parameters[1].Value := CodRel;
  //UpdateCompilaQuery.Parameters[2].Value := CodSis;
  //UpdateCompilaQuery.Parameters[3].Value := CodGrupo;
  //UpdateCompilaQuery.Parameters[4].Value := CodSubGrupo;
  //UpdateCompilaQuery.ExecSQL;
  Freeandnil(strlst);
  Freeandnil(strPar);
  Freeandnil(Param);
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
  strLst : TStringList;
  strPar : TFDParams;
  Param  : TFDParam;
Begin
If UpperCase(ExtractFileName(ParamStr(0))) = 'MULTICOLDINDEXA.EXE' Then
  Exit;

{
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
}

Agora := Now;
Try
  strLst := TStringList.Create;
  strLst.Add('INSERT INTO EVENTOS_VISU (DT, HR, ARQUIVO, DIRETORIO, CODREL, GRUPO, SUBGRUPO, CODUSUARIO, NOMEGRUPOUSUARIO, CODMENSAGEM) ');
  strLst.Add('VALUES (');
  strLst.Add(QuotedStr(FormatDateTime('yyyy/mm/dd hh:mm:ss', agora)) + ',');
  strLst.Add(QuotedStr(FormatDateTime('yyyy/mm/dd hh:mm:ss', agora)) + ',');
  strLst.Add(QuotedStr(Copy(Arquivo, 1, 70)) + ',');
  strLst.Add(QuotedStr(Copy(Diretorio, 1, 70)) + ',');
  strLst.Add(QuotedStr(codrel) + ',');
  strLst.Add(IntToStr(Grupo) + ',');
  strLst.Add(IntToStr(SubGrupo) + ',');
  strLst.Add(QuotedStr(CodUsuario) + ',');
  strLst.Add(QuotedStr(CodUsuario) + ',');
  strLst.Add(IntToStr(CodMens) + ')');

  {
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
  EventosQuery1.Parameters[8].Value := CodUsuario;
  EventosQuery1.Parameters[9].Value := CodMens;
  EventosQuery1.ExecSql;
  DatabaseEventos.CommitTrans;
  }
  Persistir(strLst.Text, nil);
Except
  //DatabaseEventos.RollbackTrans;
  End; // Try

  Freeandnil(strlst);
End;

Procedure TFormGeral.InsereEventos(V1, V2, V3 : AnsiString; V4 : Integer; Const Reg : AnsiString);
Var
  Agora : TDateTime;
  strLst : TStringList;
  strPar : TFDParams;
  Param  : TFDParam;
Begin
If UpperCase(ExtractFileName(ParamStr(0))) = 'MULTICOLDINDEXA.EXE' Then
  Exit;

{
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
}
If Length(V1) > 60 Then
  SetLength(V1,60);
If Length(V2) > 60 Then
  SetLength(V2,60);
If Length(V3) > 20 Then
  SetLength(V3,20);

Agora := Now;

Try
  strLst := TStringList.Create;
  strLst.Add('INSERT INTO EVENTOS (DT, HR, OBJETO, ITEM, CODUSUARIO, CODMENSAGEM) VALUES ( ');
  strLst.Add(QuotedStr(FormatDateTime('yyyy/mm/dd hh:mm:ss', agora)) + ',');
  strLst.Add(QuotedStr(FormatDateTime('yyyy/mm/dd hh:mm:ss', agora)) + ',');
  strLst.Add(QuotedStr(V1) + ',');
  strLst.Add(QuotedStr(V2) + ',');
  strLst.Add(QuotedStr(V3) + ',');
  strLst.Add(IntToStr(V4) + ')');
  Persistir(strLst.Text, nil);

  {
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
  }
  If Reg <> '' Then
    Begin
      strPar.Clear;
      strLst.Clear;
      strLst.Add('INSERT INTO REGISTROS (DT, HR, CONTEUDO) VALUES (');
      strLst.Add(QuotedStr(FormatDateTime('yyyy/mm/dd hh:mm:ss', agora)) + ',');
      strLst.Add(QuotedStr(FormatDateTime('yyyy/mm/dd hh:mm:ss', agora)) + ',');
      strLst.Add(QuotedStr(Reg) + ')');
      Persistir(strLst.Text, nil);
      {
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
      }
    End;
    Except
  //DatabaseEventos.RollbackTrans;
  End; // Try
  Freeandnil(Param);
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


