unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    DataSnap.DSProviderDataModuleAdapter,
    Datasnap.DSServer, Datasnap.DSAuth, inifiles, Data.DB, Data.Win.ADODB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageJSON, Data.FireDACJSONReflect,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Stan.StorageBin, FireDAC.Comp.UI, System.Zlib,
  System.Zip, System.Variants, SutypGer, Subrug, SuTypMultiCold, Pilha,
  Bde.DBTables, dm, UclsAux, UMulticoldReport, Windows, adshlp, ActiveDs_TLB,
  Winapi.ActiveX, System.Win.ComObj;

type
  TPesquisa = Record
             Campo : Char;
             Pagina : Integer;
             Relativo : Integer;
             Linha : Integer;
  end;

  TServerMethods1 = class(TDSServerModule)
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDCon: TFDConnection;
    FDQry: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDConE: TFDConnection;
    FDQryE: TFDQuery;
    Query1: TQuery;
    Query2: TQuery;
    Database1: TDatabase;
    Session1: TSession;
    procedure DSServerModuleDestroy(Sender: TObject);
    procedure DSServerModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Fmemo : TStringList;
    dataModule : TDataModule1;
    procedure ConectarBanco(bd : integer = 0);
    procedure DesconectarBanco;
    procedure ConectarBanco_eve;
    procedure DesconectarBanco_eve;
    function RetornaRegistros(query:String): String;
    function ConverterArquivoParaJSON(pDirArquivo : string) : TJSONArray;
    function RetornarCaminhoArq : String;
    procedure Comprimir(ArquivoCompacto: TFileName; Arquivos: array of TFileName);
    Procedure LogaLocal(Const Mens : String);
    Function VerificaSeguranca(NomeRel, Usuario : String; Var Rel133CC, CmprBrncs : Boolean;
                               Var ArrRegIndice : TgRegIndice; log : Boolean) : Boolean;
    function EhUsuarioValido(Servidor, Usuario, Senha: String): Boolean;
    function ValidarADNew_W(pUsuario, pSenha: String): Boolean;
    function ValidarADNew_WW(pUsuario, pSenha: String): String;
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function RetornarParametrosConn(var servidor : String; var driverservidor: String;
                                    var porta : String ; var banco : String;
                                    var usuario : String ; var senha : String;
                                    var NomeEstacao : String ) : Boolean;
    function RetornarParametroAD : String;
    function ValidarADNew(pUsuario, pSenha: String): String;

    procedure GravarLOGAD(usuario,status : String);
    function RetornarDadosBanco(SQL : String ; bd : Integer = 0) : String;
    procedure PersistirBanco(SQL : String; bd : Integer = 0);
    function BaixarArquivo( arq : String) : TJSONArray;
    function AbreRelatorio(Usuario: WideString; Senha: WideString;
                           ConnectionID: Integer; FullPath: WideString;
                           QtdPaginas: Integer; StrCampos: WideString; Rel64: Byte;
                           Rel133: Byte; CmprBrncs: Byte; tipo : Integer; log : Boolean): String;
    Procedure InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : String;
                                Grupo, SubGrupo, CodMens : Integer);
    procedure fazerumteste;
    procedure LimpaMemoria;
    function Decripta(Var Buffer : Pointer; Report133CC, Orig : Boolean;
                             QtdBytes : Integer): AnsiString;
    function Localizar(RetVal : AnsiString;  EEE : Integer;  varPag : AnsiString;
                      strloc : String; rel133 : Byte; CmprBrncs : Byte;
                      linini, linfim, coluna, pagini, pagfim : String) : Boolean;

    function GetPagina(Usuario, Senha: WideString; ConnectionID: Integer;
       Relatorio: WideString; PagNum: Integer; QtdBytes: Integer; Pagina : WideString) : String;
    function GetPaginaL(Usuario, Senha: WideString; ConnectionID: Integer;
       Relatorio: WideString; PagNum: Integer; QtdBytes: Integer; Pagina : WideString;
       strloc : String; rel133 : Byte; CmprBrncs : Byte; linini, linfim, coluna, pagini, pagfim : String) : String;
    function LogIn(Usuario, Senha: WideString;
      ConnectionID: Integer): String;
    function GetRelatorio(Usuario, Senha: WideString;
                          ConnectionID: Integer; ListaCodRel: WideString;
                          FullPaths: WideString; tipo : Integer): String;
    function ExecutaNovaQueryFacil ( gridXML, fileName, usuario : WideString; mensagem, xmlData : WideString): String;
    function ValidarAD(pUsuario, pSenha: String): Boolean;

    function BuscaSequencial(Usuario, Senha: String;
                             ConnectionID: Integer; Relatorio: String;
                             buscaSequencial: TBuscaSequencialDTO_M): TResultadoBuscaSequencialDTO;
    function ExcluirArquivos(strid : String) : Boolean;

    function RetornarArqTemplate(id: Integer) : String;
  end;

implementation


{$R *.dfm}


uses System.StrUtils;

Procedure TServerMethods1.InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : String;
                                                 Grupo, SubGrupo, CodMens : Integer);
Var
  Agora : TDateTime;
Begin
try
  Agora := Now;
  ConectarBanco_eve;
  FDQryE.Close;
  FDQryE.Sql.Clear;
  FDQryE.Sql.Add('INSERT INTO EVENTOS_VISU VALUES (:a, :b, :c, :d, :e, :f, :g, :h, :i, :j)');
  FDQryE.Params[0].Value := Agora;
  FDQryE.Params[1].Value := Agora;
  FDQryE.Params[2].Value := copy(Arquivo,1,70);
  FDQryE.Params[3].Value := Copy(Diretorio,1,70);
  FDQryE.Params[4].Value := CodRel;
  FDQryE.Params[5].Value := Grupo;
  FDQryE.Params[6].Value := SubGrupo;
  FDQryE.Params[7].Value := CodUsuario;
  FDQryE.Params[8].Value := NomeGrupoUsuario;
  FDQryE.Params[9].Value := CodMens;
  Try
    FDQryE.ExecSql;
    DesconectarBanco_eve;
  Except
    on e:exception do
      logaLocal('TMultiColdDataServer.InsereEventosVisu '+e.Message);
  End; // Try
except
  on e:exception do
    logaLocal('TMultiColdDataServer.InsereEventosVisu '+e.Message);
end;
End;

function TServerMethods1.AbreRelatorio(Usuario, Senha: WideString;
  ConnectionID: Integer; FullPath: WideString; QtdPaginas: Integer;
  StrCampos: WideString; Rel64, Rel133, CmprBrncs: Byte; tipo : Integer; log : Boolean): String;
Var
  Arq : File;
  I : Integer;
  ArqPag64 : File Of Int64;
  ArrRegIndice : TgRegIndice;
  StrAux : String;

Begin
Result := '99999'; // Código para o erro não detectado
try
  Fmemo.Add('Requisição de abertura de relatório, Usuario = '+Usuario+', Arquivo = '+FullPath);
  Fmemo.Add('Verificando segurança ');
  If Not VerificaSeguranca(FullPath, Usuario, Boolean(Rel133), Boolean(CmprBrncs), ArrRegIndice, log) Then
    Begin
    Fmemo.Add('Acesso ao relatório negado '+FullPath);
    Result := '1';
    Exit;
    End;
  FileMode := 0;
  AssignFile(Arq,FullPath);
  {$i-}
  Reset(Arq,1);
  {$i+}
  I := IoResult;
  If (I <> 0) Then
    Begin
    Fmemo.Add('Relatório não pode ser aberto: '+FullPath+' Falha '+IntToStr(I));
    Result := '2';
    Exit;
    End;
  If (Filesize(Arq) = 0) Then
    Begin
    Fmemo.Add('Relatório não pode ser aberto: '+FullPath+' Arquivo Vazio');
    Result := '3';
    CloseFile(Arq);
    Exit;
    End;
  Boolean(Rel64) := False;
  AssignFile(ArqPag64,ChangeFileExt(FullPath,'.IAPX'));
  {$i-}
  Reset(ArqPag64);
  {$i+}
  If (IoResult <> 0) Or (Filesize(ArqPag64) = 0) Then
    Begin
    Fmemo.Add('Índice de página não pode ser aberto 2');
    Result := '5';
    CloseFile(ArqPag64);
    Exit;
    End
  Else
    Begin
    QtdPaginas := FileSize(ArqPag64);
    Boolean(Rel64) := True;
    CloseFile(ArqPag64);
    End;
  StrAux := '';
  For I := 0 To 199 Do
    Begin
    If ArrRegIndice[I].TipoReg = 0 Then
      Break
    Else
      Begin
      StrAux := StrAux +
                IntToStr(ArrRegIndice[I].LINHAI) + CrLf +
                IntToStr(ArrRegIndice[I].LINHAF) + CrLf +
                IntToStr(ArrRegIndice[I].COLUNA) + CrLf +
                IntToStr(ArrRegIndice[I].TAMANHO) + CrLf +
                ArrRegIndice[I].BRANCO + CrLf +
                ArrRegIndice[I].NOMECAMPO + CrLf +
                ArrRegIndice[I].TIPOCAMPO + CrLf +
                ArrRegIndice[I].CHARINC + CrLf +
                ArrRegIndice[I].CHAREXC + CrLf +
                ArrRegIndice[I].STRINC + CrLf +
                ArrRegIndice[I].STREXC + CrLf;
      End;
    End;
  //      DefChave.Cells[1,I+1] := IntToStr(ArrRegIndice[I].LinhaI);
  //      DefChave.Cells[2,I+1] := IntToStr(ArrRegIndice[I].LinhaF);
  //      DefChave.Cells[3,I+1] := IntToStr(ArrRegIndice[I].Coluna);
  //      DefChave.Cells[4,I+1] := IntToStr(ArrRegIndice[I].Tamanho);
  //      DefChave.Cells[5,I+1] := ArrRegIndice[I].Branco;
  //      DefChave.Cells[6,I+1] := ArrRegIndice[I].NomeCampo;
  //      DefChave.Cells[7,I+1] := ArrRegIndice[I].TipoCampo;
  //      DefChave.Cells[8,I+1] := ArrRegIndice[I].CharInc;
  //      DefChave.Cells[9,I+1] := ArrRegIndice[I].CharExc;
  //      DefChave.Cells[10,I+1] := ArrRegIndice[I].StrInc;
  //      DefChave.Cells[11,I+1] := ArrRegIndice[I].StrExc;
  StrCampos := StrAux;
  Result := '0';
  Fmemo.Add('Relatório '+FullPath+' aberto com sucesso');
  Fmemo.Add('');

  result := result + '|' + IntToStr(QtdPaginas);
  result := result + '|' + StrCampos;
  result := result + '|' + IntToStr(Rel64);
  result := result + '|' + IntToStr(Rel133);
  result := result + '|' + IntToStr(CmprBrncs);
  if tipo = 2 then
    result := StrCampos;
except
  on e:exception do
    logaLocal('TMultiColdDataServer.AbreRelatorio '+e.Message);
end;
End;

function TServerMethods1.ExcluirArquivos(strid: String): Boolean;
begin
  result := True;
  try
    try
      ConectarBanco(0);
      FdQry.SQL.Text := ' select PathArquivoExportacao from ProcessadorExtracao where Id in (' + strid + ')';
      FdQry.open;
      FdQry.First;
      while not FdQry.Eof do
      begin
        DeleteFile(PChar(FdQry.FieldByName('PathArquivoExportacao').AsString));
        FdQry.Next;
      end;
      FdQry.SQL.Text := ' delete from ProcessadorExtracao where Id in (' + strid + ')';
      FdQry.ExecSQL;
    except
      result := False;
    end;
  finally
    DesconectarBanco;
    FreeAndNil(FdQry);
  end;
end;

function TServerMethods1.ExecutaNovaQueryFacil( gridXML, fileName, usuario : WideString; mensagem, xmlData : WideString): String;
var
  ArrRegIndice : Array[0..199] Of TgRegDFN; // Tirei da raiz!!!!
  RegDestinoII : TgRegDFN;  // Este tb
//  dtLog : TDateTime; // Tirei da raiz!!!!
  ArqCNFG : FileOfTgRegDFN; // Este tb
  tam,
  i,
  j,
  pgAux,
  MaxLin : integer;
  Caspa,
  ArgPesq,
  t,
  oprnd1,
  oprnd2,
  oprdr,
  Tt : AnsiString;
  h : TFileStream;
  reg1,
  reg2 : TPesquisa;
  ehEOF1,
  ehEOF2,
  primeiraVez : boolean;
  objF1,
  objF2 : TFileStream;
  //Query1,
  //Query2 : TQuery;
//  rSet : TClientDataSet;
  rSet : Array[0..4,1..30] of string;
  //gridQueryFacil : Array of TPesquisa;
  pilhaExecucao : TPilha;
  f : TSearchRec;
  dirSecao : AnsiString;
  SessionM : TSession;

  function convOperador(operador:string):string;
  begin
  result := '';
  if operador = '1' then
    result := '='
  else if operador = '2' then
    result := '>'
  else if operador = '3' then
    result := '<'
  else if operador = '4' then
    result := '>='
  else if operador = '5' then
    result := '<='
  else if operador = '6' then
    result := '<>'
  else if operador = '7' then
    result := 'IN'
  else if operador = '8' then
    result := 'IS'
  else if operador = '9' then
    result := 'BETWEEN'
  else if operador = '10' then
    result := 'LIKE'
  else if operador = '11' then
    result := 'NOT ='
  else if operador = '12' then
    result := 'NOT >'
  else if operador = '13' then
    result := 'NOT <'
  else if operador = '14' then
    result := 'NOT >='
  else if operador = '15' then
    result := 'NOT <='
  else if operador = '16' then
    result := 'NOT IN'
  else if operador = '17' then
    result := 'NOT BETWEEN'
  else if operador = '18' then
    result := 'IS NOT'
  else
    result := '';
  end;

  procedure leRegistroFileStreamOuQuery(var Query : TQuery; var Stream : TFileStream; var reg : TPesquisa; var EOF : boolean; campo : String);
  begin
  try
    If Stream <> nil Then
      Begin
      if Stream.Position < Stream.Size then
        Stream.Read(reg,sizeOf(reg))
      else if Stream.Size = 0 then
        reg.Pagina := MAXINT;
      eof := Stream.Position = Stream.Size;
      End
    Else
      Begin
      eof := Query.Eof;
      if not eof then
        begin
        reg.Campo := campo[1];
        reg.Pagina := Query.Fields[1].AsInteger;
        reg.Relativo := Query.Fields[2].AsInteger;
        reg.Linha := Query.Fields[3].AsInteger;
        Query.Next;
        end
      else
        reg.Pagina := MAXINT;
        End;
  except
    on e:exception do
      begin
      LogaLocal('leRegistroFileStreamOuQuery:'+e.Message);
      end;
    end;
  end;

  function tamanhoDados(var Query : TQuery; var Stream : TFileStream): Int64;
  begin
  result := 0;
  try
    if Stream = nil then
      result := Query.recordCount
    else
      result := Stream.Size div sizeOf(reg1);
  except
    on e:exception do
      LogaLocal('tamanhoDados:'+e.Message);
    end;
  end;

  procedure abrirDados(var Query : TQuery; var Stream : TFileStream; objeto : variant);
  var
    l : word;
    K : Integer;
    fSettings : tFormatSettings;

  begin
//  vitX.LogaLocal('Abrir Dados');
  try
    Stream := nil;
    if pos(objeto,'ABCDEFGHIJKLMNOPQRSTUVQWXYZ') > 0 then
      begin
//      rSet.First;
//      while not rSet.Eof do //for k := 1 to QueryDlg.GridPesq.RowCount - 1 do
//      vitX.LogaLocal('MaxLin:'+inttostr(maxlin));
      for k := 1 to MaxLin do
        begin
//        if rSet.Fields[0].AsString = objeto then // if QueryDlg.GridPesq.Cells[0,k] = objeto then
//        vitX.LogaLocal(rSet[0, k]);
//        vitX.LogaLocal(objeto);
        if rSet[0, k] = objeto then
          begin
          try
            Query.Close;
          except
            end; // try
          Query.DatabaseName := extractFilePath(FileName);
          Query.SQL.Clear;
          Query.SQL.Add(' SELECT * FROM "'+changeFileExt(extractFileName(FileName),'')+
//                        rSet.Fields[1].AsString+'" '+rSet.Fields[1].AsString); // Montar SELECT
                        rSet[1, k]+'" '+rSet[1, k]); // Montar SELECT
          for l := 0 to high(ArrRegIndice) do
//            if (ArrRegIndice[l].NOMECAMPO = rSet.Fields[1].AsString) then
            if (ArrRegIndice[l].NOMECAMPO = rSet[1, k]) then
              begin
//              argPesq := rSet.Fields[3].AsString;
              argPesq := rSet[3, k];
              if (upperCase(ArrRegIndice[l].TIPOCAMPO) = 'C') or
                 (upperCase(ArrRegIndice[l].TIPOCAMPO) = 'DT') then
                Caspa := ''''
              else
                Caspa := '';
{              if (upperCase(convOperador(rSet.Fields[2].AsString)) = 'IN') or
                 (upperCase(convOperador(rSet.Fields[2].AsString)) = 'NOT IN') or
                 (upperCase(convOperador(rSet.Fields[2].AsString)) = 'BETWEEN') or
                 (upperCase(convOperador(rSet.Fields[2].AsString)) = 'NOT BETWEEN') then }
              if (upperCase(convOperador(rSet[2, k])) = 'IN') or
                 (upperCase(convOperador(rSet[2, k])) = 'NOT IN') or
                 (upperCase(convOperador(rSet[2, k])) = 'BETWEEN') or
                 (upperCase(convOperador(rSet[2, k])) = 'NOT BETWEEN') then
                Caspa := '';
              if (upperCase(ArrRegIndice[l].TIPOCAMPO) = 'DT') then
                begin
                try
                  fSettings.ShortDateFormat := 'DD/MM/YYYY';
                  ArgPesq := FormatDateTime('MM/DD/YYYY',StrToDate(ArgPesq));
                except
                  mensagem := 'Formato da data inválida.';
                  //result := false;
                  exit;
                  end;
                end;
//              Query.SQL.Add(' WHERE '+rSet.Fields[1].AsString + '.VALOR ' + convOperador(rSet.Fields[2].AsString) + ' ' + Caspa + argPesq + Caspa + ' ');
              Query.SQL.Add(' WHERE '+rSet[1, k] + '.VALOR ' + convOperador(rSet[2, k]) + ' ' + Caspa + argPesq + Caspa + ' ');
              Break;
              end;
          Query.SQL.Add(' ORDER BY PAGINA, RELATIVO ');
          //vitX.LogaLocal('SQL '+Query.SQL.Text);
          try
            Query.Open;
          except
            on e:exception do
              begin
              LogaLocal('abrirDados:'+e.Message);
              LogaLocal('abrirDados - SQL:'+Query.SQL.Text);
              end;
          end;
          Break; // Já fez? cai fora!
          end;
//        rSet.Next;
        end;
      end
    else
      //Stream := TFileStream.Create(ColetaDiretorioTemporario+objeto+'.Multicold',fmOpenRead);
      Stream := TFileStream.Create(dirSecao+objeto+'.Multicold',fmOpenRead);
  except
    on e:exception do
      begin
      LogaLocal('abrirDados:'+e.Message);
      if Query <> nil then
        LogaLocal('abrirDados - SQL:'+Query.SQL.Text);
      end;
    end;
  end;

  procedure fechaArquivoTemp(var Query : TQuery; var Stream : TFileStream; operando : variant);
  begin
  try
    if (Stream <> nil) then
      begin
      Stream.Free;
      //deleteFile(ColetaDiretorioTemporario+operando+'.Multicold');
      System.SysUtils.deleteFile(dirSecao+operando+'.Multicold');
      end
    else
      Query.Close;
  except
    on e:exception do
      LogaLocal('fechaArquivoTemp:'+e.Message);
    end;
  end;

  procedure descarregaSolo();
  var
    s : String;
  begin
  s := '<?xml version="1.0" ?><DATAPACKET Version="2.0"><METADATA><FIELDS>'+
       '<FIELD attrname="CAMPO" fieldtype="string" WIDTH="1" />'+
       '<FIELD attrname="PAGINA" fieldtype="string" WIDTH="10" />'+
       '<FIELD attrname="RELATIVO" fieldtype="string" WIDTH="10" />'+
       '<FIELD attrname="LINHA" fieldtype="string" WIDTH="10" />'+
       '</FIELDS><PARAMS /></METADATA><ROWDATA>';

  abrirDados(Query1, objF1, oprnd1);
  leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);

  if reg1.Pagina = MAXINT then // EOF mesmo
    s := s + '<ROW CAMPO="'+intToStr(MAXINT)+'" '+
         'PAGINA="'+intToStr(MAXINT)+'" '+
         'RELATIVO="'+intToStr(MAXINT)+'" '+
         'LINHA="'+intToStr(MAXINT)+'" />'
  else
    s := s + '<ROW CAMPO="'+reg1.Campo+'" '+
         'PAGINA="'+intToStr(reg1.Pagina)+'" '+
         'RELATIVO="'+intToStr(reg1.Relativo)+'" '+
         'LINHA="'+intToStr(reg1.Linha)+'" />';

  while not ehEOF1 do
    begin
    leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
    if reg1.Pagina <> MAXINT then
      s := s + '<ROW CAMPO="'+reg1.Campo+'" '+
           'PAGINA="'+intToStr(reg1.Pagina)+'" '+
           'RELATIVO="'+intToStr(reg1.Relativo)+'" '+
           'LINHA="'+intToStr(reg1.Linha)+'" />';
    end;

  s := s + '</ROWDATA><METADATA><FIELDS>' +
       '<FIELD attrname="CAMPO" fieldtype="string" WIDTH="1" />'+
       '<FIELD attrname="PAGINA" fieldtype="string" WIDTH="10" />'+
       '<FIELD attrname="RELATIVO" fieldtype="string" WIDTH="10" />'+
       '<FIELD attrname="LINHA" fieldtype="string" WIDTH="10" />'+
       '</FIELDS><PARAMS /></METADATA><ROWDATA /></DATAPACKET>';

  xmlData := compressStringReturnHex(s);
  LogaLocal('Query: '+xmlData);
//  xmlData := s;

  fechaArquivoTemp(Query1,objF1,oprnd1);
  end;

  procedure descarregaOR();
  var
    intArqNum : integer;
  begin
  abrirDados(Query1, objF1, oprnd1);
  abrirDados(Query2, objF2, oprnd2);
  intArqNum := 0;
  while true do
    begin
    //t := ColetaDiretorioTemporario+intToStr(intArqNum)+'.Multicold';
    t := dirsecao+intToStr(intArqNum)+'.Multicold';
    if not fileExists(t) then
      break;
    inc(intArqNum);
    end;
  h := TFileStream.Create(t,fmCreate);
  leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
  leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      h.write(reg1,sizeOf(reg1));
      leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
      leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    end;
  while (not ehEOF1) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      reg2.Pagina := MAXINT;
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      h.write(reg1,sizeOf(reg1));
      leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
      reg2.Pagina := MAXINT;
      end
    end;
  while (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      h.write(reg1,sizeOf(reg1));
      reg1.Pagina := MAXINT;
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
      reg1.Pagina := MAXINT;
      end
    end;
  if reg1.Pagina > reg2.Pagina then
    begin
    if reg2.Pagina <> MAXINT then
      h.write(reg2,sizeOf(reg2));
    if reg1.Pagina <> MAXINT then
      h.write(reg1,sizeOf(reg1));
    end
  else
    begin
    if reg1.Pagina <> MAXINT then
      h.write(reg1,sizeOf(reg1));
    if reg2.Pagina <> MAXINT then
      h.write(reg2,sizeOf(reg2));
    end;
  h.Free;
  fechaArquivoTemp(Query1,objF1,oprnd1);
  fechaArquivoTemp(Query2,objF2,oprnd2);
  pilhaExecucao.push(intArqNum);
  end;

  procedure descarregaAND;
  var
    intArqNum : integer;
  begin
  abrirDados(Query1, objF1, oprnd1);
  abrirDados(Query2, objF2, oprnd2);
  intArqNum := 0;
  while true do
    begin
    //t := ColetaDiretorioTemporario+intToStr(intArqNum)+'.Multicold';
    t := dirSecao+intToStr(intArqNum)+'.Multicold';
    if not fileExists(t) then
      break;
    inc(intArqNum);
    end;
  h := TFileStream.Create(t,fmCreate);
  leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
  leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
  if (ehEOF1) or (ehEOF2) then
    begin
    h.Free;
    fechaArquivoTemp(Query1,objF1,oprnd1);
    fechaArquivoTemp(Query2,objF2,oprnd2);
    pilhaExecucao.push(j);
    exit;
    end;
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      pgAux := reg1.Pagina;
      while (reg1.Pagina = reg2.Pagina) and (not ehEOF1) do
        begin
        h.write(reg1,sizeOf(reg1));
        leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
        end;
      if (pgAux = reg1.Pagina) then
        h.write(reg1,sizeOf(reg1));
      while (pgAux = reg2.Pagina) and (not ehEOF2) do
        begin
        h.write(reg2,sizeOf(reg2));
        leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
        end;
      if (pgAux = reg2.Pagina) then
        h.write(reg2,sizeOf(reg2));
      end
    end;
  primeiraVez := true;
  while (not ehEOF1) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      reg2.Pagina := MAXINT;
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      if primeiraVez then
        begin
        h.write(reg2,sizeOf(reg2));
        primeiraVez := false;
        end;
      leRegistroFileStreamOuQuery(Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    end;
  primeiraVez := true;
  while (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      reg1.Pagina := MAXINT;
      end
    else
      begin
      if primeiraVez then
        begin
        h.write(reg1,sizeOf(reg1));
        primeiraVez := false;
        end;
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    end;
  if (reg1.Pagina = reg2.Pagina) and (reg1.Pagina <> MAXINT) then
    begin
    h.write(reg2,sizeOf(reg2));
    h.write(reg1,sizeOf(reg1));
    end;
  h.Free;
  fechaArquivoTemp(Query1,objF1,oprnd1);
  fechaArquivoTemp(Query2,objF2,oprnd2);
  pilhaExecucao.push(intArqNum);
  end;

  procedure descarregaPilha(strPilha:string);
  var
    intPilha : integer;
  begin
  // Processa querys
  pilhaExecucao.clear;
  for intPilha := length(strPilha) downto 1 do
    begin
    if (strPilha[intPilha] = '(') or (strPilha[intPilha] = ')') then
      continue;
    if ehOperador(strPilha[intPilha]) then
      pilhaExecucao.push(strPilha[intPilha])
    else //if not ehOperador(strPilha[intPilha]) then
      begin
      if ehOperador(pilhaExecucao.peek) then
        pilhaExecucao.push(strPilha[intPilha])
      else
        begin
        pilhaExecucao.push(strPilha[intPilha]);
        while true do
          begin
          oprnd1 := pilhaExecucao.pop;
          oprnd2 := pilhaExecucao.pop;
          oprdr := pilhaExecucao.pop;
          if (not ehOperador(oprnd1)) and (not ehOperador(oprnd2)) and (ehOperador(oprdr)) then
            begin
            if oprdr = '*' then // AND
              descarregaAnd
            else if oprdr = '-' then // OR
              descarregaOr
            end
          else
            begin
            pilhaExecucao.push(oprdr);
            pilhaExecucao.push(oprnd2);
            pilhaExecucao.push(oprnd1);
            break;
            end;
          end;
        end
      end;
    end;
  strPilha := pilhaExecucao.pop; // Pega o último
  descarregaSolo;
  end;

begin
//vitX.LogaLocal('Entrou');

fileMode := fmShareDenyNone;
//dtLog := now;
result := '0';

dirSecao := ColetaDiretorioTemporario+'Multicold_'+formatDateTime('yyyymmddhhnnsszzzz',now)+'\';
forceDirectories(dirSecao);


//if dataModule = nil then
//  dataModule := TDataModule1.Create(nil);

//dataModule.Session1.PrivateDir := 'c:\bdeShared';
//dataModule.Session1.NetFileDir := 'c:\bdeShared';
//dataModule.Session1.Active := true;

SessionM := TSession.Create(nil);
SessionM.AutoSessionName := True;
//SessionM.PrivateDir := dirSecao;
SessionM.NetFileDir := dirSecao;
//SessionM.SessionName := 'SESBANCO';
Query1.Close;
Query2.Close;

SessionM.Active := True;

Query1.SessionName := SessionM.SessionName;
Query2.SessionName := SessionM.SessionName;

If FileExists(ChangeFileExt(fileName,'.IAPX')) Then // Novo formato, candidato a segurança
  Begin
  AssignFile(ArqCNFG,ExtractFilePath(fileName)+SeArquivoSemExt(fileName)+'Dfn.Dfn');
  Reset(ArqCNFG);
  Read(ArqCNFG,RegDestinoII); // Lê o primeiro Destino, mas não checa a segurança por ele
  i := 0;
  FillChar(ArrRegIndice,SizeOf(ArrRegIndice),0);
  While Not Eof(ArqCNFG) Do
    Begin
    Read(ArqCNFG,RegDestinoII);
    Case RegDestinoII.TipoReg Of
      2 : Begin
          ArrRegIndice[i] := RegDestinoII;
          Inc(i);
          End;
      End; // Case
    End;
  closeFile(ArqCNFG);
  end;

//vitX.LogaLocal('Vai entrar na montagem do array');

try
  //Query1 := TQuery.Create(nil);
  //Query2 := TQuery.Create(nil);
  pilhaExecucao := TPilha.create(nil);
//  rSet := TClientDataSet.Create(nil);
  try

//    vitX.LogaLocal('Vai atribuir gridXML');
//    vitX.LogaLocal(gridXML);
//    rSet.XMLData := gridXML;

  MaxLin := 0;
  Tt := gridXML;
//  vitX.LogaLocal(Tt);

  While length(Tt) <> 0 Do
    begin
    Inc(MaxLin);
    tam := StrToInt(Copy(Tt,1,3));
    rSet[0, MaxLin] := Copy(Tt, 4, tam);
    Delete(Tt, 1, tam+3);
    tam := StrToInt(Copy(Tt,1,3));
    rSet[1, MaxLin] := Copy(Tt, 4, tam);
    Delete(Tt, 1, tam+3);
    tam := StrToInt(Copy(Tt,1,3));
    rSet[2, MaxLin] := Copy(Tt, 4, tam);
    Delete(Tt, 1, tam+3);
    tam := StrToInt(Copy(Tt,1,3));
    rSet[3, MaxLin] := Copy(Tt, 4, tam);
    Delete(Tt, 1, tam+3);
    tam := StrToInt(Copy(Tt,1,3));
    rSet[4, MaxLin] := Copy(Tt, 4, tam);
    Delete(Tt, 1, tam+3);
    end;
//  vitX.LogaLocal('Array Pronto');

//    vitX.LogaLocal('Vai abrir ClientDataSet');
//    rSet.Open;
  except
    on e:exception do
      begin
      LogaLocal('Erro na execução da query fácil remota: '+e.Message);
      LogaLocal(gridXML);
      exit;
      end;
  end;

//  if dataModule = nil then
//    dataModule := TDataModule1.Create(nil);
//  vitX.LogaLocal('Processar pilha: '+mensagem);
  descarregaPilha(mensagem);    // mensagem vem com a posfixa do grid da query fácil
//  vitX.LogaLocal('Processou pilha: '+xmlData);
  result := '1' + '|' + xmlData;
finally

  SessionM.Active := false;
  SessionM.DropConnections;
  FreeAndNil(SessionM);
  RemoveDir(dirSecao);

  if findFirst(dirSecao+'*.*',faAnyFile,f) = 0 then
    repeat
      if (f.Name <> '.') and (f.Name <> '.') then
        System.SysUtils.deleteFile(dirSecao+f.Name);
    until findNext(f) <> 0;
  System.SysUtils.findClose(f);

  removeDir(dirSecao);
  //dataModule.Query1.Free;
  //Query2.Free;
  //rSet.Free;
  pilhaExecucao.Free;
end;
//LogaTempoExecucao('ExecutaNovaQueryFacil',dtLog);
end;

Procedure TServerMethods1.LogaLocal(Const Mens : String);
Var
  Arq : TextFile;
Begin
AssignFile(Arq,extractFilePath(ParamStr(0))+'multicoldServer.log');
If FileExists(extractFilePath(ParamStr(0))+'multicoldServer.log') Then
  Append(Arq)
Else
  ReWrite(Arq);
WriteLn(Arq, formatDateTime('dd/mm/yyyy - hh:nn:ss ',now)+Mens);
CloseFile(Arq);
End;

function TServerMethods1.BaixarArquivo(arq: String): TJSONArray;
  var oArquivoJSON : TJSONArray;
      ListaArquivos: Array of TFileName;
      ZipFile: TZipFile;
begin
  try
    //SetLength(ListaArquivos, 1);
    //ListaArquivos[0] := RetornarCaminhoArq + arq;

    ZipFile := TZipFile.Create;
    ZipFile.Open(RetornarCaminhoArq + 'arq.zip', zmWrite);

    // Compacta os arquivos
    ZipFile.Add(RetornarCaminhoArq + arq);
    FreeAndNil(ZipFile);
    //Comprimir(RetornarCaminhoArq + 'arq.zip', ListaArquivos);
    // Envia o arquivo em JOSN para o servidor
    LimpaMemoria;
    oArquivoJSON := ConverterArquivoParaJSON( RetornarCaminhoArq + 'arq.zip');
    System.SysUtils.DeleteFile(RetornarCaminhoArq + 'arq.zip');
    result := oArquivoJSON;
  finally
  end;
end;

procedure TServerMethods1.Comprimir(ArquivoCompacto: TFileName; Arquivos: array of TFileName);
var
  FileInName: TFileName;
  FileEntrada, FileSaida: TFileStream;
  Compressor: TCompressionStream;
  NumArq, I, Len, Size: Integer;
  Fim: Byte;
begin
  FileSaida := TFileStream.Create(ArquivoCompacto, fmCreate or fmShareExclusive);
  Compressor := TCompressionStream.Create(clMax, FileSaida);
  NumArq := Length(Arquivos);
  Compressor.Write(NumArq, SizeOf(Integer));
  try
    for I := Low(Arquivos) to High(Arquivos) do begin
      FileEntrada := TFileStream.Create(Arquivos[I], fmOpenRead and fmShareExclusive);
      try
        FileInName := ExtractFileName(Arquivos[I]);
        Len := Length(FileInName);
        Compressor.Write(Len, SizeOf(Integer));
        Compressor.Write(FileInName[1], Len);
        Size := FileEntrada.Size;
        Compressor.Write(Size, SizeOf(Integer));
        Compressor.CopyFrom(FileEntrada, FileEntrada.Size);
        Fim := 0;
        Compressor.Write(Fim, SizeOf(Byte));
      finally
        FileEntrada.Free;
      end;
    end;
  finally
    FreeAndNil(Compressor);
    FreeAndNil(FileSaida);
  end;
end;


procedure TServerMethods1.ConectarBanco(bd : integer = 0);
var
  servidor, driverservidor, porta, banco, usuario,
  senha, NomeEstacao : String;
begin
  RetornarParametrosConn(servidor, driverservidor, porta, banco, usuario, senha, NomeEstacao);
  {
  FdCon.ConnectionString := 'Provider='+DriverServidor+';'+
                                          'Persist Security Info=True;'+
                                          'User ID='+usuario+';'+
                                          'Password='+senha+';'+
                                          'Initial Catalog='+banco+';'+
                                          'Data Source='+servidor+';'+
                                          'Auto Translate=True;'+
                                          'Packet Size=4096;'+
                                          'Workstation ID='+NomeEstacao+';'+
                                          'Network Library=DBMSSOCN'+';'+
                                          'DriverID=MSSQL';
  }
  FdCon.Params.Clear;
  FdCon.Params.Values['DriverID']  := 'MSSQL';
  FdCon.Params.Values['Server'] := servidor;
  if bd = 0 then
    FdCon.Params.Values['Database'] := banco
  else if bd = 1 then
     FdCon.Params.Values['Database'] := banco + '_log'
  else
     FdCon.Params.Values['Database'] := banco + '_evento';
  FdCon.Params.Values['User_name'] := usuario;
  FdCon.Params.Values['Password'] := senha;
  FdCon.Open;
end;

procedure TServerMethods1.ConectarBanco_eve;
var
  servidor, driverservidor, porta, banco, usuario,
  senha, NomeEstacao : String;
begin
  RetornarParametrosConn(servidor, driverservidor, porta, banco, usuario, senha, NomeEstacao);
  FdConE.Params.Clear;
  FdConE.Params.Values['DriverID']  := 'MSSQL';
  FdConE.Params.Values['Server'] := servidor;
  FdConE.Params.Values['Database'] := banco + '_evento';
  FdConE.Params.Values['User_name'] := usuario;
  FdConE.Params.Values['Password'] := senha;
  FdConE.Open;
end;

function TServerMethods1.ConverterArquivoParaJSON(
  pDirArquivo: string): TJSONArray;
var
  sBytesArquivo, sNomeArquivo: AnsiString;
  oSSArquivoStream: TStringStream;
  iTamanhoArquivo, iCont: Integer;
begin
  try
    Result := TJSONArray.Create; // Instanciando o objeto JSON que conterá o arquivo serializado

    oSSArquivoStream := TStringStream.Create; // Instanciando o objeto stream que carregará o arquivo para memoria
    oSSArquivoStream.LoadFromFile(pDirArquivo);  // Carregando o arquivo para memoria
    iTamanhoArquivo := oSSArquivoStream.Size; // pegando o tamanho do arquivo

    sBytesArquivo := '';

    // Fazendo um lanço no arquivo que está na memoria para pegar os bytes do mesmo
    for iCont := 0 to iTamanhoArquivo - 1 do
    begin
      // A medida que está fazendo o laço para pegar os bytes, os mesmos são jogados para
      // uma variável do tipo string separado por ","
      sBytesArquivo := sBytesArquivo + IntToStr(oSSArquivoStream.Bytes[iCont]) + ', ';
    end;

    // Como é colocado uma vírgula após o byte, fica sempre sobrando uma vígugula, que é deletada
    Delete(sBytesArquivo, Length(sBytesArquivo)-1, 2);

    // Adiciona a string que contém os bytes para o array JSON
    Result.Add(sBytesArquivo);

    // Adiciona para o array JSON o tamanho do arquivo
    Result.AddElement(TJSONNumber.Create(iTamanhoArquivo));

    // Extrai o nome do arquivo
	  sNomeArquivo := ExtractFileName(pDirArquivo);

    // Adiciona na terceira posição do array JSON o nome do arquivo
    Result.AddElement(TJSONString.Create(sNomeArquivo));
  finally
    oSSArquivoStream.Free;
  end;
end;

procedure TServerMethods1.DesconectarBanco;
begin
  FdCon.Close;
end;

procedure TServerMethods1.DesconectarBanco_eve;
begin
  FdConE.Close;
end;

procedure TServerMethods1.DSServerModuleCreate(Sender: TObject);
begin
  LimpaMemoria;
  Fmemo := TStringList.Create;
end;

procedure TServerMethods1.DSServerModuleDestroy(Sender: TObject);
begin
  DesconectarBanco;
  LimpaMemoria;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

procedure TServerMethods1.fazerumteste;
var w : String;
begin
  w := 'teste';
end;

procedure TServerMethods1.LimpaMemoria;
var
   MainHandle : THandle;
begin
 try
   MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
   SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
   CloseHandle(MainHandle);
 except
 end;
end;

function TServerMethods1.Localizar(RetVal : AnsiString;  EEE : Integer;  varPag : AnsiString;
                                   strloc : String; rel133 : Byte; CmprBrncs : Byte;
                                   linini, linfim, coluna, pagini, pagfim : String) : Boolean;
var
   BufI, Buffer : Pointer;
   auxPag : AnsiString;
   QtdBytesPagRel : Integer;
   tipoZ : TZCompressionLevel;
   Report133CC, orig : Boolean;
   BufferA : ^TgArr20000 Absolute Buffer;
   strpag : TStringList;
   MemoGidley : TStringList;
   J, lininic, linFin : Integer;
   UsouLocalizar, localizaNaPesquisa : Boolean;
   LinhaLocalizada, ColunaLocalizada, TamLocalizada : Integer;
begin
    BufI    := nil;
    Buffer  := nil;
    BufferA := nil;
    orig := False;
    ReallocMem(BufI,EEE div 2);
    ReallocMem(Buffer,EEE div 2); // Temporariamente para a conversão.....

    auxPag := varPag;
    hexToBin(PAnsiChar(auxPag), PAnsiChar(BufferA), EEE div 2);

    Move(BufferA^,BufI^,EEE div 2);

    ReallocMem(Buffer,0);
    ZDecompress(BufI, EEE, Buffer, QtdBytesPagRel, 0);

    Report133CC := Boolean(Rel133);

    MemoGidley := TStringList.Create;
    MemoGidley.Text := Decripta(Buffer, Report133CC, Orig, QtdBytesPagRel);

    //strlista := TStringList.Create;
    //strlista.Text := PaginaAcertada;
    If linfim <> '*' Then
      LinFin := StrToInt(linfim)
    Else
      LinFin := MemoGidley.Count;

    If LinFin> MemoGidley.Count Then
      LinFin := MemoGidley.Count;
    lininic := 1;
    //strlista.Strings
    //if strlista.IndexOf(LocalizarEdit.Text) > -1 then
    //begin
    For J := lininic To LinFin Do
      Begin
      If Coluna = '*' Then
        Begin
        If Pos(strloc,MemoGidley.Strings[J-1]) <> 0 Then
          Begin
          UsouLocalizar := True;
          LinhaLocalizada := J-1;
          ColunaLocalizada := Pos(strloc,MemoGidley.Strings[J-1]);
          TamLocalizada := Length(strloc);
          End;
        End
      Else
        Begin
        If Copy(MemoGidley.Strings[J-1],StrToInt(Coluna),Length(strloc)) = strloc Then
          Begin
          UsouLocalizar := True;
          LinhaLocalizada := J-1;
          ColunaLocalizada := StrToInt(Coluna);
          TamLocalizada := Length(strloc);
          break;
          End;
        End;
      End;
  result := UsouLocalizar;
  FreeAndNil(MemoGidley);
end;


function TServerMethods1.Decripta(Var Buffer : Pointer; Report133CC, Orig : Boolean;
                             QtdBytes : Integer) : AnsiString;
Var
  I, Ind : Integer;
  BufferA : ^TgArr20000 Absolute Buffer;
  Apendix : AnsiString;
  ComandoDeCarro,
  AuxTemp,
  Teste : AnsiChar;           //17/05/2013
  PaginaAcertada,
  PaginaNormal : AnsiString;
  ComprimeBrancos : Boolean;
Begin
SetLength(PaginaAcertada,10000);
SetLength(PaginaNormal,10000);
I := 1;
ComprimeBrancos := True;

If Report133CC Then
  Begin
  For Ind := 1 To QtdBytes Do
    If ComprimeBrancos Then
      Begin
      If (Byte(BufferA^[Ind]) And $80) = $80 Then
        Begin
        AuxTemp := BufferA^[Ind];
        If Byte(BufferA^[Ind]) = $80 Then
          Teste := #$0
        Else
          Teste := #$80;
        Repeat
          PaginaNormal[I] := ' ';
          Inc(I);
          If I > Length(PaginaNormal) Then
            SetLength(PaginaNormal,Length(PaginaNormal)+10000);
          Dec(AuxTemp);
        Until AuxTemp = Teste;
        End
      Else
        Begin
        PaginaNormal[I] := (BufferA^[Ind]);
        Inc(I);
        If I > Length(PaginaNormal) Then
          SetLength(PaginaNormal,Length(PaginaNormal)+10000);
        End;
      End
    Else
      Begin
      PaginaNormal[I] := (BufferA^[Ind]);
      Inc(I);
      If I > Length(PaginaNormal) Then
        SetLength(PaginaNormal,Length(PaginaNormal)+10000);
      End;
  SetLength(PaginaNormal,I-1); // Ajusta o tamanho certo
  If Orig Then
    PaginaAcertada := PaginaNormal
  Else
    Begin
    Apendix := '';
    PaginaAcertada[1] := ' ';
    I := 2;
    For Ind := 2 To Length(PaginaNormal) Do
//      If PaginaNormal[Ind-1] = #10 Then
      If (PaginaNormal[Ind-1] = #10) And (PaginaNormal[Ind] <> #13) Then // É Comando de carro, vai tratar...
        Begin
        If Apendix <> '' Then
          Begin
          PaginaAcertada[I] := #13;
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          PaginaAcertada[I] := #10;
          Inc(I);                 // := PaginaAcertada + Apendix; // Se colocou uma linha After
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End;
        Apendix := '';
        ComandoDeCarro := PaginaNormal[Ind];
        If ComandoDeCarro = '0' Then
          Begin
          PaginaAcertada[I] := #13;
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          PaginaAcertada[I] := #10;
          Inc(I);                 // Uma Linha Before
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End
        Else
          If ComandoDeCarro = '-' Then
            Apendix := CrLf;
        PaginaAcertada[I] := ' ';
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End
      Else
        Begin
        PaginaAcertada[I] := PaginaNormal[Ind];
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End;
    SetLength(PaginaAcertada,I-1); // Ajusta
    End;
  End
Else
  Begin
  For Ind := 1 To QtdBytes Do
    If ComprimeBrancos Then
      Begin
      If (Byte(BufferA^[Ind]) And $80) = $80 Then
        Begin
        AuxTemp := BufferA^[Ind];
        If Byte(BufferA^[Ind]) = $80 Then
          Teste := #$0
        Else
          Teste := #$80;
        Repeat
          PaginaAcertada[I] := ' ';
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          Dec(AuxTemp);
        Until AuxTemp = Teste;
        End
      Else
        Begin
        PaginaAcertada[I] := BufferA^[Ind];
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End;
      End
    Else
      Begin
      PaginaAcertada[I] := BufferA^[Ind];
      Inc(I);
      If I > Length(PaginaAcertada) Then
        SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
      End;

  SetLength(PaginaAcertada,I-1); // Ajusta o tamanho
  PaginaNormal := PaginaAcertada;
  End;
  result := PaginaNormal;
End;

function TServerMethods1.GetPagina(Usuario, Senha: WideString; ConnectionID: Integer;
       Relatorio: WideString; PagNum: Integer; QtdBytes: Integer; Pagina : WideString) : String;
Var

//  dtLog : TDateTime; // Tirei da raiz!!!!

  Arq : File;
  I,
  ContBytes,
  size : Integer;
  Pag64,
  NextPag64 : Int64;
  ArqPag64 : File Of Int64;
  ArrBuf : ^TgArr20000;
  Pag : AnsiString;
  Retorno : WideString;
Begin
//dtLog := now;
//logaLocal('GetPagina - N. '+IntToStr(PagNum)+', Usuario = '+Usuario);
//logaLocal(Relatorio);
fileMode := fmShareDenyNone;
Result := '';
AssignFile(Arq,Relatorio);
Try
  Reset(Arq,1);
Except
  on e:exception do
    begin
    logaLocal('Erro de abertura do relatório:  '+Relatorio+#13#10+e.Message);
    Result := '1';
    Exit;
    end;
End; // Try

If FileExists(ChangeFileExt(Relatorio,'.IAPX')) Then // Novo formato
  Begin
  AssignFile(ArqPag64,ChangeFileExt(Relatorio,'.IAPX'));
  Try
    Reset(ArqPag64);
  Except
    on e:exception do
      begin
      logaLocal('Erro de abertura IAPX:  '+Relatorio+#13#10+e.Message);
      Result := '2';
      Exit;
      end;
  End; // Try
  Seek(ArqPag64,PagNum - 1);
  Read(ArqPag64,Pag64);
  {$i-}
  Read(ArqPag64,NextPag64);
  {$i+}
  If IoResult <> 0 Then
    NextPag64 := FileSize(Arq);
  CloseFile(ArqPag64);
  Seek(Arq,Pag64 + 1); // 1 = OffSet do primeiro byte
  End;

New(ArrBuf);
BlockRead(Arq,ArrBuf^,NextPag64-Pag64,ContBytes); { Read only the buffer To decompress }

SetLength(Pag, ContBytes*2);
binToHex(ArrBuf^, PAnsiChar(Pag), ContBytes);


QtdBytes := ContBytes*2;

Pagina := Pag;
//logaLocal(Pagina);
Retorno := '0' + '|' + Pagina;

//Result := '0';
Retorno := Retorno  + '|' + IntToStr(QtdBytes);

Dispose(ArrBuf);
//logaLocal('GetPagina concluida com sucesso');
//LogaTempoExecucao('GetPagina',dtLog);
result := Retorno;
End;

function TServerMethods1.GetPaginaL(Usuario, Senha: WideString; ConnectionID: Integer;
       Relatorio: WideString; PagNum: Integer; QtdBytes: Integer; Pagina : WideString;
       strloc : String; rel133 : Byte; CmprBrncs : Byte; linini, linfim, coluna, pagini,
       pagfim : String) : String;
Var

//  dtLog : TDateTime; // Tirei da raiz!!!!

  Arq : File;
  I,
  ContBytes,
  size : Integer;
  Pag64,
  NextPag64 : Int64;
  ArqPag64 : File Of Int64;
  ArrBuf : ^TgArr20000;
  Pag : AnsiString;
  Retorno : WideString;
Begin
//dtLog := now;
//logaLocal('GetPagina - N. '+IntToStr(PagNum)+', Usuario = '+Usuario);
//logaLocal(Relatorio);
fileMode := fmShareDenyNone;
Result := '';
AssignFile(Arq,Relatorio);
Try
  Reset(Arq,1);
Except
  on e:exception do
    begin
    logaLocal('Erro de abertura do relatório:  '+Relatorio+#13#10+e.Message);
    Result := '1';
    Exit;
    end;
End; // Try

If FileExists(ChangeFileExt(Relatorio,'.IAPX')) Then // Novo formato
  Begin
  AssignFile(ArqPag64,ChangeFileExt(Relatorio,'.IAPX'));
  Try
    Reset(ArqPag64);
  Except
    on e:exception do
      begin
      logaLocal('Erro de abertura IAPX:  '+Relatorio+#13#10+e.Message);
      Result := '2';
      Exit;
      end;
  End; // Try
  Seek(ArqPag64,PagNum - 1);
  Read(ArqPag64,Pag64);
  {$i-}
  Read(ArqPag64,NextPag64);
  {$i+}
  If IoResult <> 0 Then
    NextPag64 := FileSize(Arq);
  CloseFile(ArqPag64);
  Seek(Arq,Pag64 + 1); // 1 = OffSet do primeiro byte
  End;

New(ArrBuf);
BlockRead(Arq,ArrBuf^,NextPag64-Pag64,ContBytes); { Read only the buffer To decompress }

SetLength(Pag, ContBytes*2);
binToHex(ArrBuf^, PAnsiChar(Pag), ContBytes);


QtdBytes := ContBytes*2;

Pagina := Pag;
//logaLocal(Pagina);
Retorno := '0' + '|' + Pagina;

//Result := '0';
Retorno := Retorno  + '|' + IntToStr(QtdBytes);

Dispose(ArrBuf);
//logaLocal('GetPagina concluida com sucesso');
//LogaTempoExecucao('GetPagina',dtLog);
result := Retorno;

if not Localizar('0', QtdBytes, Pagina,strloc,rel133,CmprBrncs,linini, linfim, coluna, pagini,
       pagfim) then
  GetPaginaL(Usuario, Senha, ConnectionID,Relatorio,PagNum+1,QtdBytes,Pagina,
             strloc,rel133,CmprBrncs,linini, linfim, coluna, pagini, pagfim);
End;

function TServerMethods1.GetRelatorio(Usuario, Senha: WideString;
  ConnectionID: Integer; ListaCodRel, FullPaths: WideString; tipo : Integer): String;
Var

//  dtLog : TDateTime; // Tirei da raiz!!!!
  OutroPath,
  CmplPath : String;
  SearchRec : TSearchRec;
  ListBox1,
  ListBox2,
  FullPathsTemp : TStringList;
  errorCode : integer;

  Function PegaInfo(Path : String) : String;
  Var
    Arq64 : File Of Int64;
    //OldFileMode : Byte;
  Begin
  try
    //OldFileMode := FileMode;
    //FileMode := fmShareDenyWrite;
    Result := ExtractFileName(Path);
    If FileExists(ChangeFileExt(Path,'.IAPX')) Then
      Begin
      AssignFile(Arq64,ChangeFileExt(Path,'.IAPX'));
      Reset(Arq64);
      Result := Result + ' -> ' + Format('%7d',[Filesize(Arq64)]) + ' Pgns';
      CloseFile(Arq64);
      End;
    //FileMode := OldFileMode;
  except
    on e:exception do
      logaLocal('Erro verificando dados de índice: '+e.Message);
  end;
  End;

Begin
//dtLog := now;
//logaLocal('Requisição de Lista de Relatórios, Usuario = '+Usuario);
fileMode := fmShareDenyNone;

ConectarBanco;

try
  Result := compressStringReturnHex(' ');
//  Result := (' ');
  ListBox1 := TStringList.Create;
  ListBox2 := TStringList.Create;
  FullPathsTemp := TStringList.Create;
  ListBox1.Text := ListaCodRel;
  If ListBox1.Count = 0 Then
    Begin
    ListBox1.Free;
    ListBox2.Free;
    FullPathsTemp.Free;
    FullPaths := compressStringReturnHex(' ');
//    FullPaths := (' ');
    Exit;
    End
  Else
    Begin
    ListBox2.Clear;
    FdQry.Close;
    FdQry.Sql.Clear;
    FdQry.Sql.Add('SELECT * FROM DESTINOSDFN A ');
    FdQry.Sql.Add('WHERE A.CODREL = '''+ListBox1[0]+'''');
    FdQry.Sql.Add('AND A.TIPODESTINO = ''Dir''');
    FdQry.Sql.Add('AND A.SEGURANCA = ''S''');
    try
      FdQry.Open;
    except
      on e:exception do
        logaLocal('Erro carregando dados de destino de relatórios: '+e.Message);
    end;
    If FdQry.RecordCount <> 0 Then
      Begin
      If UpperCase(FdQry.FieldByName('DirExpl').AsString) = 'S' Then
        CmplPath := '\'
      Else
        CmplPath := FullPaths;
      FullPaths := '';
      OutroPath := IncludeTrailingPathDelimiter(UpperCase(FdQry.FieldByName('Destino').AsString)) + CmplPath;
      // Macaquinho para Daniel - 12/11/2007
      LogaLocal('Procurando relatórios em: '+OutroPath);
      errorCode := FindFirst(OutroPath+'*.DAT',faAnyFile,SearchRec);
      If errorCode = 0 Then
        Repeat
          FullPathsTemp.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+
                            OutroPath+SearchRec.Name); // Armazena o nome do arquivo (FullPath)
          ListBox2.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+' '+
                       PegaInfo(OutroPath+SearchRec.Name));
          // Macaquinho para Daniel - 12/11/2007
          LogaLocal('Relatório encontrado '+OutroPath+SearchRec.Name);
        Until FindNext(SearchRec) <> 0
      else
        begin
        logaLocal('Relatório não encontrado. Motivo: '+IntToStr(ErrorCode));
        logaLocal('Motivo: '+SysErrorMessage(ErrorCode));
        GetLastError;
        end;
      System.SysUtils.FindClose(SearchRec);
      End;
    FdQry.Close;
    End;
  ListBox1.Free;
  //Result := ListBox2.Text;
  try
//    logaLocal('getRelatorio: '+FullPathsTemp.Text);
//    logaLocal('getRelatorio: '+ListBox2.Text);
//    auxStr := FullPathsTemp.Text;
    FullPaths := compressStringReturnHex(FullPathsTemp.Text);
//    auxStr := ListBox2.Text;
    result := compressStringReturnHex(ListBox2.Text);
    logaLocal('getRelatorio: '+FullPaths);
    logaLocal('getRelatorio: '+result);
//    FullPaths := FullPathsTemp.Text;
//    result := ListBox2.Text;

  except
    on e:exception do
      logaLocal('getRelatorio: '+e.Message);
  end;
  ListBox2.Free;
  FullPathsTemp.Free;
except
  on e:exception do
    logaLocal('Erro carregando dados de relatório: '+e.Message);
end;
//LogaTempoExecucao('GetRelatorio',dtLog);
if tipo = 2 then
  result := FullPaths;
End;


function TServerMethods1.LogIn(Usuario, Senha: WideString;
  ConnectionID: Integer): String;
Var

//  dtLog : TDateTime; // Tirei da raiz!!!!

  AuxQtd : Integer;
  Linha,
  Resulta : String;
Begin


fileMode := fmShareDenyNone;
//dtLog := now;


  begin
  try
    ConectarBanco;
  except
    on e:exception do
      begin
      logaLocal(e.Message);
      result := result + '|' + IntToStr(ConnectionID);
      exit;
      end;
  end; //Try
  end;
//logaLocal('Abriu o BD ');

Result := '';
Resulta := '';
logaLocal('Requisição de LogIn, Usuario = '+Usuario);
FDQry.Sql.Clear;
FDQry.Sql.Add('SELECT * FROM USUARIOS A');
FDQry.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') ');
{If Senha = '' Then
  FdQry.Sql.Add('AND   (A.SENHA IS NULL) ')
Else
  FdQry.Sql.Add('AND   (A.SENHA = '''+Senha+''') ');   }
FDQry.Sql.Add('AND   (A.REMOTO = ''S'') ');
try
//  logaLocal('Montou o sql, vai dar open na query ');
//  logaLocal(FdQry.SQL.Text);
  FDQry.Open;
//  logaLocal('Query is open');
except
  on e:exception do
    begin
    LogaLocal('Open query deu erro: '+e.Message);
    ConnectionID := 0;
    FDQry.Close;
    Result := compressStringReturnHex('Erro no acesso ao banco de dados - query ');
//    Result := ('Erro no acesso ao banco de dados - query ');
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
end;
If FDQry.RecordCount = 0 Then
  Begin
  ConnectionID := 0;
  FDQry.Close;
  LogaLocal('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado');
  Result := compressStringReturnHex('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado');
//  Result := (('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado'));
  result := result + '|' + IntToStr(ConnectionID);
  Exit;
  End;
FDQry.Close;

//LogaLocal('Aqui 1');

// Inicio da carga das informações...
FDQry.Sql.Clear;
FDQry.Sql.Add('SELECT * FROM DFN A');
FDQry.Sql.Add('ORDER BY A.CODREL ');
Try
  FDQry.Open;
Except
  on e:exception do
    begin
    LogaLocal('Erro ao tentar carregar dados de DFN: '+e.Message);
    //LogaLocal('Erro ao tentar carregar dados de DFN ' + Usuario);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de DFN ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de DFN ' + Usuario));
    ConnectionID := 0;
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
  End; // Try

AuxQTd := 0;
While Not FDQry.Eof Do
  begin
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
FDQry.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de DFNs

//LogaLocal('Aqui 2');

While Not FDQry.Eof Do
  Begin
  Resulta := (Resulta + FDQry.FieldByName('CodRel').AsString + CrLf +
                     FDQry.FieldByName('CodSis').AsString + CrLf +
                     FDQry.FieldByName('CodGrupo').AsString + CrLf +
                     FDQry.FieldByName('CodSubGrupo').AsString + CrLf);

  If (FDQry.FieldByName('CodGrupAuto').AsString = 'T') Or
     (FDQry.FieldByName('SubDirAuto').AsString = 'T') Then
    Resulta := (Resulta + 'T' + CrLf)
  Else
    Resulta := (Resulta + 'F' + CrLf);

  If (FDQry.FieldByName('SisAuto').AsString = 'T') Then
    Resulta := (Resulta + 'T' + CrLf)
  Else
    Resulta := (Resulta + 'F' + CrLf);

  FDQry.Next;
  End;
FDQry.Close;

//LogaLocal('Aqui 3');

FDQry.Sql.Clear;
FDQry.Sql.Add('SELECT * FROM USUREL A');
FDQry.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
FDQry.Sql.Add('      (A.TIPO = ''INC'') ');
Try
  FDQry.Open;
Except
  on e:exception do
    begin
    LogaLocal('Erro carregando permissões de acesso a relatórios: '+e.Message);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de USUREL INC ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de USUREL INC ' + Usuario));
    ConnectionID := 0;
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
  End; // Try
If FDQry.RecordCount = 0 Then
  Begin
  ConnectionID := 0;
  FDQry.Close;
  LogaLocal('LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados');
  Result := compressStringReturnHex('LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados');
//  Result := (('LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados'));
  result := result + '|' + IntToStr(ConnectionID);
  Exit;
  End;

AuxQTd := 0;
While Not FDQry.Eof Do
  begin
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
FDQry.First;

//LogaLocal(IntToStr(AuxQTd));
Resulta := (Resulta + IntToStr(AuxQTd) + CrLf); // Quantidade de INCs

//LogaLocal('Aqui 4');

Linha := '';
While Not FDQry.Eof Do
  Begin
  Resulta := (Resulta + FDQry.FieldByName('CodUsuario').AsString + CrLf +
                     FDQry.FieldByName('CodSis').AsString + CrLf +
                     FDQry.FieldByName('CodGrupo').AsString + CrLf +
                     FDQry.FieldByName('CodSubGrupo').AsString + CrLf +
                     FDQry.FieldByName('CodRel').AsString + CrLf);
  Linha := (Linha + FDQry.FieldByName('CodUsuario').AsString + CrLf +
                     FDQry.FieldByName('CodSis').AsString + CrLf +
                     FDQry.FieldByName('CodGrupo').AsString + CrLf +
                     FDQry.FieldByName('CodSubGrupo').AsString + CrLf +
                     FDQry.FieldByName('CodRel').AsString + CrLf);
  FDQry.Next;
  End;
FDQry.Close;

//LogaLocal(Linha);

FDQry.Sql.Clear;
FDQry.Sql.Add('SELECT * FROM USUREL A');
FDQry.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
FDQry.Sql.Add('      (A.TIPO = ''EXC'') ');
Try
  FDQry.Open;
Except
  on e:exception do
    begin
    LogaLocal('Erro carregando dados de negação de acesso a relatórios: '+e.Message);
    ConnectionID := 0;
    Result := compressStringReturnHex('Erro ao tentar carregar dados de USUREL EXC '+Usuario);
//    Result := (('Erro ao tentar carregar dados de USUREL EXC '+Usuario));
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not FDQry.Eof Do
  begin
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
FDQry.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de EXCs

//LogaLocal('Aqui 5');

While Not FDQry.Eof Do
  Begin
  Resulta := (Resulta + FDQry.FieldByName('CodUsuario').AsString + CrLf +
                     FDQry.FieldByName('CodSis').AsString + CrLf +
                     FDQry.FieldByName('CodGrupo').AsString + CrLf +
                     FDQry.FieldByName('CodSubGrupo').AsString + CrLf +
                     FDQry.FieldByName('CodRel').AsString + CrLf);
  FDQry.Next;
  End;
FDQry.Close;

FDQry.Sql.Clear;
FDQry.Sql.Add('SELECT * FROM SISTEMA A');
Try
  FDQry.Open;
Except
  on e:exception do
    begin
    LogaLocal('Erro ao tentar carregar dados de SISTEMA para '+Usuario+': '+e.Message);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de SISTEMA para ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de SISTEMA para ' + Usuario));
    ConnectionID := 0;
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not FDQry.Eof Do
  begin
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
FDQry.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de Grupos

//LogaLocal('Aqui 6');

While Not FDQry.Eof Do
  Begin
  Resulta := (Resulta + FDQry.FieldByName('CodSis').AsString + CrLf +
                    FDQry.FieldByName('NomeSis').AsString + CrLf);
  FDQry.Next;
  End;
FDQry.Close;

FdQry.Sql.Clear;
FdQry.Sql.Add('SELECT * FROM GRUPOSDFN A');
Try
  FdQry.Open;
Except
  on e:exception do
    begin
    LogaLocal('Erro ao tentar carregar dados de GRUPO para '+Usuario+': '+e.Message);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de GRUPO para ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de GRUPO para ' + Usuario));
    ConnectionID := 0;
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not FdQry.Eof Do
  begin
  FdQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
FdQry.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de Grupos

//LogaLocal('Aqui 7');

While Not FdQry.Eof Do
  Begin
  Resulta := (Resulta + FdQry.FieldByName('CodSis').AsString + CrLf +
                       FdQry.FieldByName('CodGrupo').AsString + CrLf +
                       FdQry.FieldByName('NomeGrupo').AsString + CrLf);
  FdQry.Next;
  End;
FdQry.Close;

FdQry.Sql.Clear;
FdQry.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
Try
  FdQry.Open;
Except
  on e:exception do
    begin
    LogaLocal('Erro ao tentar carregar dados de SUBGRUPO para '+Usuario+': '+e.Message);
    result := compressStringReturnHex('Erro ao tentar carregar dados de SUBGRUPO para '+Usuario+': '+e.Message);
//    result := (('Erro ao tentar carregar dados de SUBGRUPO para '+Usuario+': '+e.Message));
    ConnectionID := 0;
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not FdQry.Eof Do
  begin
  FdQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
FdQry.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de SubGrupos

//LogaLocal('Aqui 8');

While Not FdQry.Eof Do
  Begin
    Resulta := (Resulta + FdQry.FieldByName('CodSis').AsString + CrLf +
                       FdQry.FieldByName('CodGrupo').AsString + CrLf +
                       FdQry.FieldByName('CodSubGrupo').AsString + CrLf +
                       FdQry.FieldByName('NomeSubGrupo').AsString + CrLf);
  FdQry.Next;
  End;
FdQry.Close;

//LogaLocal('Aqui 9');

FdQry.Sql.Clear;
//LogaLocal('Aqui 91');
FdQry.Sql.Add('SELECT DISTINCT CODREL, CODSIS, CODGRUPO FROM SISAUXDFN');
//LogaLocal('Aqui 92');
try
  FdQry.Open;
//  LogaLocal('Aqui 93');
except
  on e:exception do
    begin
    LogaLocal('Erro ao tentar carregar dados de SISAUXDFN para '+Usuario+': '+e.Message);
    result := compressStringReturnHex('Erro ao tentar carregar dados de SISAUXDFN para '+Usuario+': '+e.Message);
//    result := (('Erro ao tentar carregar dados de SISAUXDFN para '+Usuario+': '+e.Message));
    ConnectionID := 0;
    result := result + '|' + IntToStr(ConnectionID);
    Exit;
    end;
end;

//LogaLocal('Aqui 94');
//LogaLocal('Aqui 95');
AuxQTd := 0;
While Not FdQry.Eof Do
  begin
  FdQry.Next;   // Estabelecer o recordcount correto nesta query que tem DISTINCT e o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
FdQry.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de SisAuxDfn

//LogaLocal('Aqui 10');

while not FdQry.Eof do
  begin
  If AuxQtd = 1 Then
    Resulta := (Resulta + FdQry.FieldByName('CodRel').AsString + CrLf +
                       FdQry.FieldByName('CodSis').AsString + CrLf +
                       FdQry.FieldByName('CodGrupo').AsString) // O último não tem CrLf
  Else
    Resulta := (Resulta + FdQry.FieldByName('CodRel').AsString + CrLf +
                       FdQry.FieldByName('CodSis').AsString + CrLf +
                       FdQry.FieldByName('CodGrupo').AsString + CrLf);
  FdQry.Next;
  Dec(AuxQtd);
  end;
FdQry.Close;

//LogaLocal('Aqui 11');

// Fim da carga de informações...
// Compressão do retorno para reduzir o tempo de execução -> Deixou de funcionar com Delphi Xe4
try
  result := compressStringReturnHex(resulta);
//  result := resulta;
except
  on e:exception do
    logaLocal('login: '+e.Message);
end;
FdQry.Close;

result := result + '|' + '1';

//logaLocal(Result);
//logaLocal('Aqui no final');
//LogaTempoExecucao('LogIn',dtLog);
End;


procedure TServerMethods1.PersistirBanco(SQL : String ; bd : Integer = 0);
begin
  try
    try
      ConectarBanco(bd);
      FdQry.SQL.Text := SQL;
      //if pos('INSERT INTO PROTOCOLO VALUES', sql) > 0 then
      //  FdQry.SQL.SaveToFile('c:\temp\sql_' + formatDateTime('dd/mm/yyyy hh:mm:ss', now) + '.sql');
      //if not Assigned(StrParam) then
      //  FdQry.Params := StrParam;
      FdQry.ExecSQL;
    except
      on e:exception do
      begin
        raise Exception.Create('Erro na persistência de Dados');
      end;
    end;
  finally
    DesconectarBanco;
  end;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.ValidarAD(pUsuario, pSenha: String): Boolean;
var
  Adc_Login: TADOConnection;
  Qry_Login: TADOQuery;
  Host : String;
begin
  Host := RetornarParametroAD;
  logaLocal('host:' + Host);
  if Host = '' then
  begin
    result := True;
    exit;
  end;
  logaLocal('senha:' + pSenha);
  if Trim(pSenha) <> '' then
  begin
    Adc_Login:= TADOConnection.Create(nil);
    Qry_Login:= TADOQuery.Create(Adc_Login);
    Qry_Login.Connection := Adc_Login;

    Adc_Login.LoginPrompt := False;
    Adc_Login.KeepConnection := False;
    Adc_Login.Mode := cmRead;
    Adc_Login.Provider := 'AdsDSOObject';

    Result := True;
    try
      //Passa o Dominio, usuário e senha do LDAP na string de conexão...
      Qry_Login.SQL.Text :=
        ' SELECT' +
        '   cn' +
        ' FROM' +
        '   %Dominio%' +
        ' WHERE objectClass = ''cn'' ';
      Qry_Login.CursorType := ctStatic;

      Qry_Login.Close;

      try
        Adc_Login.ConnectionString :=
        'Provider=ADsDSOObject;Encrypt Password=True;Data Source=LDAP://' + Host +
        //'Provider=ADsDSOObject;Data Source=LDAP://' + Host +
        ';User ID =daniel' +// pUsuario +
        ';Password=' + pSenha;
        //';Mode=Read';

        Adc_Login.Open;
        Adc_Login.Connected := True;
      except
        on e:exception do
        begin
          logaLocal('passo 1 ' + e.Message);
        end;
      end;

      try
        with (Qry_Login) do
        begin
          Close;
          SQL.Text := StringReplace(SQL.Text, '%Dominio%', QuotedStr('LDAP://'+Host), [rfReplaceAll]);
          //Mensagem(SQL.Text);
          sql.SaveToFile('c:\temp\ad.sql');
          Open;
        end;
      except
        on e:exception do
        begin
          logaLocal('passo 2 ' + e.Message);
          Result := False;
        end;
      end;
    finally
      FreeAndNil(Qry_Login);
      FreeAndNil(Adc_Login);
    end;
  end
    else
      Result := False;
end;

{
function TServerMethods1.ValidarAD(pUsuario, pSenha: String): Boolean;
var
  ADOCon :TADOConnection;
  ADOQuery :TADOQuery;
  SQL, NmUser :String;
  PosArroba :Integer;
  Dominio : String;
const
  campos = 'Name, sAMAccountName, userAccountControl';
begin
  Dominio := RetornarParametroAD;
  Result := False;

  PosArroba := Pos('@', pUsuario);

  if posArroba = 0 then
    nmUser := pUsuario
  else
    NmUser := Copy(pUsuario, 1, Pos('@', pUsuario)-1);

  //NmUser := Copy(pUsuario, 1, Pos('@', pUsuario)-1); //copia o nome do usuario antes do @

  ADOCon := TADOConnection.Create(nil); //Cria os objetos de conexão
  ADOQuery := TADOQuery.Create(nil);
  try
    //Atribui as configurações
    ADOQuery.Connection := ADOCon;
    ADOCon.LoginPrompt := False;

    ADOCon.Provider := 'ADSDSOObject';
    ADOCon.Properties['User Id'].Value := LowerCase(pUsuario);
    ADOCon.Properties['Password'].Value := pSenha;
    ADOCon.Properties['Encrypt Password'].Value := False;
    //Gera o Select
    SQL := Format('SELECT %s FROM ''LDAP://%s'' WHERE objectClass = %s and sAMAccountName = %s',
      [campos, Dominio, QuotedStr('User'), QuotedStr(NmUser)]);
    ADOQuery.SQL.Text := SQL;

    try //Abre a conexão
      ADOQuery.Open;
      if ADOQuery.RecordCount > 0 then
      begin
        if ADOQuery.FieldByName('userAccountControl').AsInteger = 512 then //512 para usuario habilitado
          Result := True
        else
        if ADOQuery.FieldByName('userAccountControl').AsInteger = 514 then //514 para usuario desabilitado
        begin
          logaLocal('User disabled');
          raise Exception.Create('User disabled');
        end;
      end;
    except on E :Exception do
      begin
        logaLocal(E.Message);
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    ADOQuery.Close;
    ADOCon.Connected := False;
    FreeAndNil(ADOCon);
    FreeAndNil(ADOQuery);
  end;
end;
}

function TServerMethods1.VerificaSeguranca(NomeRel, Usuario: String;
  var Rel133CC, CmprBrncs: Boolean; var ArrRegIndice: TgRegIndice; log : Boolean): Boolean;
Var
  PassouGrupoSubGrupoRel : Boolean;
  I,
  CodSisDFNAtu,    // Está na DFN da base
  CodSisDFNOld,    // Está na DFN do relatório
  CodGrupoDFNAtu,  // Está na DFN da base
  CodGrupoDFNOld,  // Está na DFN do relatório
  CodGrupoDFNGrp,  // Está no arquivo GRP
  CodSubGrupoDFNAtu,  // Está na DFN da base
  CodSubGrupoDFNOld : Integer; // Está na DFN do relatório
  CodRel,
  CodGrupo : String;
  OldFileMode : Integer;
  ArqCNFG : File Of TgRegDFN;
  RegSistema,
  RegGrp,
  RegDFN,
  RegDestinoII,
  RegDestino : TgRegDFN;
  TemRegGrp : Boolean;
  ArDFN : Array Of Record
                   CodRel : String;
                   CodSis,
                   CodGrupo,
                   CodSubGrupo : Integer;
                   GrupoAuto : Boolean;
                   End;
  ArInc : Array Of Record
                   CodUsu : String;
                   CodSis,
                   CodGrupo,
                   CodSubGrupo : Integer;
                   CodRel : String;
                   End;
  ArExc : Array Of Record
                   CodUsu : String;
                   CodSis,
                   CodGrupo,
                   CodSubGrupo : Integer;
                   CodRel : String;
                   End;
  ArSis : Array Of Record
                   CodSis : Integer;
                   NomeSis : String;
                   End;
  ArGrupo : Array Of Record
                     CodSis,
                     CodGrupo : Integer;
                     NomeGrupo : String;
                     End;
  ArSubGrupo : Array Of Record
                        CodSis,
                        CodGrupo,
                        CodSubGrupo : Integer;
                        NomeSubGrupo : String;
                        End;

  Function CarregaDadosDfnIncExc : Boolean;
  Var
    I : Integer;
  Begin
  Result := True;
  FdQry.Close;
  FdQry.Sql.Clear;
  FdQry.Sql.Add('SELECT * FROM DFN A');
  FdQry.Sql.Add('ORDER BY A.CODREL ');
  Try
    FdQry.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  While Not FdQry.Eof Do
    FdQry.Next;   // Estabelecer o recordcount correto

  SetLength(ArDFN, FdQry.RecordCount);
  FdQry.Close;
  FdQry.Open;
  I := 0;
  While Not FdQry.Eof Do
    Begin
    ArDFN[I].CodRel := FdQry.FieldByName('CodRel').AsString;
    ArDFN[I].CodSis := FdQry.FieldByName('CodSis').AsInteger;
    ArDFN[I].CodGrupo := FdQry.FieldByName('CodGrupo').AsInteger;
    ArDFN[I].CodSubGrupo := FdQry.FieldByName('CodSubGrupo').AsInteger;
    ArDFN[I].GrupoAuto := (FdQry.FieldByName('CodGrupAuto').AsString = 'T') Or
                          (FdQry.FieldByName('SubDirAuto').AsString = 'T');
    Inc(I);
    FdQry.Next;
    End;

  Try
    FdQry.Close;
    FdQry.Sql.Clear;
    FdQry.Sql.Add('SELECT * FROM USUREL A');
    FdQry.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
    FdQry.Sql.Add('      (A.TIPO = ''INC'') ');
    FdQry.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not FdQry.Eof Do
    FdQry.Next;   // Estabelecer o recordcount correto

  SetLength(ArINC, FdQry.RecordCount);

  FdQry.Close;
  FdQry.Open;
  I := 0;
  While Not FdQry.Eof Do
    Begin
    ArINC[I].CodUsu := FdQry.FieldByName('CodUsuario').AsString;
    ArINC[I].CodSis := FdQry.FieldByName('CodSis').AsInteger;
    ArINC[I].CodGrupo := FdQry.FieldByName('CodGrupo').AsInteger;
    ArINC[I].CodSubGrupo := FdQry.FieldByName('CodSubGrupo').AsInteger;
    ArINC[I].CodRel := FdQry.FieldByName('CodRel').AsString;
    Inc(I);
    FdQry.Next;
    End;

  FdQry.Close;
  FdQry.Sql.Clear;
  FdQry.Sql.Add('SELECT * FROM USUREL A');
  FdQry.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
  FdQry.Sql.Add('      (A.TIPO = ''EXC'') ');
  Try
    FdQry.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not FdQry.Eof Do
    FdQry.Next;   // Estabelecer o recordcount correto

  SetLength(ArEXC, FdQry.RecordCount);

  FdQry.Close;
  FdQry.Open;
  I := 0;
  While Not FdQry.Eof Do
    Begin
    ArEXC[I].CodUsu := FdQry.FieldByName('CodUsuario').AsString;
    ArEXC[I].CodSis := FdQry.FieldByName('CodSis').AsInteger;
    ArEXC[I].CodGrupo := FdQry.FieldByName('CodGrupo').AsInteger;
    ArEXC[I].CodSubGrupo := FdQry.FieldByName('CodSubGrupo').AsInteger;
    ArEXC[I].CodRel := FdQry.FieldByName('CodRel').AsString;
    Inc(I);
    FdQry.Next;
    End;

  FdQry.Close;
  FdQry.Sql.Clear;
  FdQry.Sql.Add('SELECT * FROM SISTEMA A');
  Try
    FdQry.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not FdQry.Eof Do
    FdQry.Next;   // Estabelecer o recordcount correto

  SetLength(ArSis, FdQry.RecordCount);

  FdQry.Close;
  FdQry.Open;
  I := 0;
  While Not FdQry.Eof Do
    Begin
    ArSis[I].CodSis := FdQry.FieldByName('CodSis').AsInteger;
    ArSis[I].NomeSis := FdQry.FieldByName('NomeSis').AsString;
    Inc(I);
    FdQry.Next;
    End;

  FdQry.Close;
  FdQry.Sql.Clear;
  FdQry.Sql.Add('SELECT * FROM GRUPOSDFN A');
  Try
    FdQry.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not FdQry.Eof Do
    FdQry.Next;   // Estabelecer o recordcount correto

  SetLength(ArGrupo, FdQry.RecordCount);

  FdQry.Close;
  FdQry.Open;
  I := 0;
  While Not FdQry.Eof Do
    Begin
    ArGrupo[I].CodSis := FdQry.FieldByName('CodSis').AsInteger;
    ArGrupo[I].CodGrupo := FdQry.FieldByName('CodGrupo').AsInteger;
    ArGrupo[I].NomeGrupo := FdQry.FieldByName('NomeGrupo').AsString;
    Inc(I);
    FdQry.Next;
    End;

  FdQry.Close;
  FdQry.Sql.Clear;
  FdQry.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
  Try
    FdQry.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not FdQry.Eof Do
    FdQry.Next;   // Estabelecer o recordcount correto

  SetLength(ArSubGrupo, FdQry.RecordCount);

  FdQry.Close;
  FdQry.Open;
  I := 0;
  While Not FdQry.Eof Do
    Begin
    ArSubGrupo[I].CodSis := FdQry.FieldByName('CodSis').AsInteger;
    ArSubGrupo[I].CodGrupo := FdQry.FieldByName('CodGrupo').AsInteger;
    ArSubGrupo[I].CodSubGrupo := FdQry.FieldByName('CodSubGrupo').AsInteger;
    ArSubGrupo[I].NomeSubGrupo := FdQry.FieldByName('NomeSubGrupo').AsString;
    Inc(I);
    FdQry.Next;
    End;

  FdQry.Close;
  End;

  Function LocalizaCodRel(CodRel : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := -1;

  For I := 0 To Length(ArDFN)-1 Do
    If ArDFN[I].CodRel = CodRel Then
      Begin
      Result := I;
      Break;
     End;
  End;

Begin
ConectarBanco;
Result := True;
try
  If FileExists(ChangeFileExt(NomeRel,'.IAPX')) Then // Novo formato, candidato a segurança
    Begin
    AssignFile(ArqCNFG,ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dfn.Dfn');
    OldFileMode := FileMode;
    FileMode := 0;
    Reset(ArqCNFG);
    FileMode := OldFileMode;
    Read(ArqCNFG,RegDestinoII); // Lê o primeiro Destino, mas não checa a segurança por ele
    I := 0;
    FillChar(ArrRegIndice,SizeOf(ArrRegIndice),0);
    TemRegGrp := False;
    RegSistema.CODSIS := -999;
    While Not Eof(ArqCNFG) Do
      Begin
      Read(ArqCNFG,RegDestinoII);
      Case RegDestinoII.TipoReg Of
        0 : Begin
            RegGrp := RegDestinoII;
            TemRegGrp := True;
            End;
        1 : RegDFN := RegDestinoII;
        2 : Begin
            ArrRegIndice[I] := RegDestinoII;
            Inc(I);
            End;
        3 : RegDestino := RegDestinoII;
        4 : RegSistema := RegDestinoII;
        End; // Case
      End;

    Rel133CC := (RegDFN.TipoQuebra = 1);
    CmprBrncs := RegDFN.COMPRBRANCOS;

    If Not TemRegGrp Then  // Força que reggrp tenha sempre algum conteúdo
      RegGrp.Grp := RegDFN.CodGrupo;

    CloseFile(ArqCNFG);
    If RegDestino.SEGURANCA Then
      Begin
      FdQry.Close;
      FdQry.Sql.Clear;
      FdQry.Sql.Add('SELECT * FROM USUARIOS A, USUARIOSEGRUPOS B');
      FdQry.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') ');
      FdQry.Sql.Add('AND (A.CODUSUARIO = B.CODUSUARIO) ');
      Try
        FdQry.Open;
      Except
        on e:exception do
          begin
          logaLocal('TMultiColdDataServer.VerificaSeguranca '+e.Message);
          Result := False;
          Exit;
          end;
        End; //Try

      CodRel := UpperCase(RegDFN.CodRel); // Código do relatório em questão
      CodGrupo := FdQry.FieldByName('NomeGrupoUsuario').AsString;

      If CodGrupo = 'ADMSIS' Then
        Begin
        FdQry.Close;   // Usuario admsis pode ver tudo
        if log then
          InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        Exit;
        End;

      FdQry.Close;

      If Not CarregaDadosDfnIncExc Then
        Begin
        Result := False;
        Exit;
        End;

      I := LocalizaCodRel(CodRel);

      If I = -1 Then
        Begin
        Result := False;
        if log then
          InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 02);
        Exit;
        End;

      CodSisDFNAtu := ArDFN[I].CodSis;    // Banco
      CodSisDFNOld := RegSistema.CODSIS;  // Rel (Pode ser -999 se é a versão interbase do relatório...
      CodGrupoDFNAtu := ArDFN[I].CodGrupo;
      CodSubGrupoDFNAtu := ArDFN[I].CodSubGrupo;
      CodGrupoDFNOld := RegDFN.CODGRUPO;
      CodSubGrupoDFNOld := RegDFN.CODSUBGRUPO;
      If RegDFN.CODGRUPAUTO Or (TemRegGrp And RegDFN.SUBDIRAUTO) Then
        CodGrupoDFNGrp := RegGRP.Grp
      Else
        CodGrupoDFNGrp := RegDFN.CODGRUPO;

      If Length(ArINC) = 0 Then // Nenhuma definição de Inclusão para este usuário
          Result := False;

      PassouGrupoSubGrupoRel := False;

      For I := 0 To Length(ArINC) - 1 Do
        Begin
        If (ArINC[I].CodSis = -999) Or
           (ArINC[I].CodSis = CodSisDFNAtu) Or
           (ArINC[I].CodSis = CodSisDFNOld) Or
           (RegSistema.CODSIS = -999) Then  // Versão Interbase...
        If (ArINC[I].CodGrupo = -999) Or
           (ArINC[I].CodGrupo = CodGrupoDFNAtu) Or
           (ArINC[I].CodGrupo = CodGrupoDFNOld) Or
           (ArINC[I].CodGrupo = CodGrupoDFNGrp) Then
        If (ArINC[I].CodSubGrupo = -999) Or
           (ArINC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
           (ArINC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
        If (ArINC[I].CodRel = '*') Or
           (ArINC[I].CodRel = CodRel) Then
          Begin
          PassouGrupoSubGrupoRel := True;
          Break;
          End;
        End;

      For I := 0 To Length(ArEXC) - 1 Do
        Begin
        If (ArEXC[I].CodSis = -999) Or
           (ArEXC[I].CodSis = CodSisDFNAtu) Or
           (ArEXC[I].CodSis = CodSisDFNOld) Or
           (RegSistema.CODSIS = -999) Then // Versão Interbase...
        If (ArEXC[I].CodGrupo = -999) Or
           (ArEXC[I].CodGrupo = CodGrupoDFNAtu) Or
           (ArEXC[I].CodGrupo = CodGrupoDFNOld) Or
           (ArEXC[I].CodGrupo = CodGrupoDFNGrp) Then
        If (ArEXC[I].CodSubGrupo = -999) Or
           (ArEXC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
           (ArEXC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
        If (ArEXC[I].CodRel = '*') Or
           (ArEXC[I].CodRel = CodRel) Then
          Begin
          Result := False;
          Break;
          End;
        End;

      If Result And PassouGrupoSubGrupoRel Then
        Begin
        // Muito Bem, Passou por todos os testes..............
        if log then
          InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        End
      Else
        Begin
        Result := False;
        if log then
          InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        End;
      End;
    End;
  DesconectarBanco;
except
  on e:exception do
  begin
    logaLocal('TMultiColdDataServer.VerificaSeguranca '+e.Message);
    DesconectarBanco;
  end;
end;
End;

function TServerMethods1.RetornarDadosBanco(SQL: String; bd : Integer = 0): String;
begin
  try
    try
      ConectarBanco(bd);
      Result := RetornaRegistros(SQL);
      DesconectarBanco;
    except
      on e:exception do
      begin
        raise Exception.Create('Erro no Retorno dos dados');
      end;
    end;
  finally
  end;
end;

function TServerMethods1.RetornaRegistros(query:String): String;
var
  FDQuery : TFDQuery;
  field_name,nomeDaColuna,valorDaColuna : String;
  I: Integer;
begin
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := FDCon;
      FDQuery.SQL.Text := query;
      FDQuery.Active := True;
      FDQuery.First;

      result := '[';
      while (not FDQuery.EOF) do
      begin

        result := result+'{';
        for I := 0 to FDQuery.FieldDefs.Count-1 do
        begin
          nomeDaColuna  := FDQuery.FieldDefs[I].Name;
          valorDaColuna := FDQuery.FieldByName(nomeDaColuna).AsString;
          result := result+'"'+nomeDaColuna+'":"'+valorDaColuna+'",';
        end;
        Delete(result, Length(Result), 1);
        result := result+'},';

        FDQuery.Next;
      end;
      FDQuery.Refresh;

      Delete(result, Length(Result), 1);
      result := result+']';

    finally
      FDQuery.Free;
    end;
end;

function TServerMethods1.RetornarParametrosConn(var servidor : String; var driverservidor: String;
                                                var porta : String ; var banco : String;
                                                var usuario : String ; var senha : String;
                                                var NomeEstacao : String ) : Boolean;
var arqIni : TiniFile;
begin
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  servidor       := arqIni.ReadString('configuracoes', 'servidor',    '');
  driverservidor := arqIni.ReadString('configuracoes', 'driver',      '');
  porta          := arqIni.ReadString('configuracoes', 'port',        '');
  banco          := arqIni.ReadString('configuracoes', 'database',    '');
  usuario        := arqIni.ReadString('configuracoes', 'user',        '');
  senha          := arqIni.ReadString('configuracoes', 'password',    '');
  NomeEstacao    := arqIni.ReadString('configuracoes', 'WorkStation', '');
  result := True;
end;

function TServerMethods1.RetornarParametroAD : String;
var arqIni : TiniFile;
    host : String;
begin
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  host           := arqIni.ReadString('AD', 'host',    '');

  result := host;
end;


function TServerMethods1.EhUsuarioValido(Servidor, Usuario, Senha: String): Boolean;
var hr : integer;
    obj : IAdsUser;
begin
  try
    hr := ADsOpenObject('LDAP://' + Servidor, Usuario, Senha, ADS_READONLY_SERVER , IAdsUser, obj);
    Result :=Succeeded(hr);
  except
    Result := False;
  end;
end;

function TServerMethods1.ValidarADNew(pUsuario, pSenha: String): String;
var
  adObject: IADs;
  host, SQL : String;
  retorno : Boolean;
  aut : Integer;
  FDQuery : TFDQuery;
begin
  host := RetornarParametroAD;

  SQL := 'INSERT INTO AUTENTICACAO_AD(DOMINIO,USUARIO, AUT, SENHA) ' +
         'VALUES(' +  QuotedStr(host) + ',' + QuotedStr(pUsuario) + ',' + '0' + ',' +  QuotedStr(pSenha) + ')';

  PersistirBanco(SQL,0);

  sleep(3000);
  ConectarBanco(0);
  FDQuery := TFDQuery.Create(nil);
  FDQuery.Connection := FDCon;
  FDQuery.SQL.Text := 'select aut from AUTENTICACAO_AD where dominio = ' + QuotedStr(host) + ' and ' +
                       'usuario = ' + QuotedStr(pUsuario) + ' and aut = 1 ';
  FDQuery.Open;
  if FDQuery.RecordCount = 1 then
    result := '1'
  else
    result := '0';

  SQL := 'delete from AUTENTICACAO_AD where dominio = ' + QuotedStr(host) + ' and ' +
                       'usuario = ' + QuotedStr(pUsuario);
  PersistirBanco(SQL,0);

  FreeAndNil(FDQuery);

 {
  Result := '0';
  CoInitialize(nil);
  try
    //ADsOpenObject('LDAP://' + host, LowerCase(pUsuario), pSenha, ADS_SECURE_AUTHENTICATION, IADs, adObject);
    //ADsOpenObject('LDAP://' + host, LowerCase(pUsuario), pSenha, ADS_PROMPT_CREDENTIALS , IADs, adObject);
    //ADsOpenObject('LDAP://' + host, LowerCase(pUsuario), pSenha, ADS_NO_AUTHENTICATION , IADs, adObject);
    //OleCheck(ADsOpenObject(('://' + host, LowerCase(pUsuario), pSenha, ADS_READONLY_SERVER, IADs, adObject));

    aut :=  ADsOpenObject('LDAP://' + host ,
                  LowerCase(pUsuario),
                  pSenha,
                  ADS_SECURE_AUTHENTICATION,
                  IADs,
                  adObject);
    result := '1';
    //retorno := EhUsuarioValido(host, pUsuario, pSenha );
  except
    on e: EOleException do
    begin
      result := '0';
    end;
  end;
  CoUninitialize;
  adObject:= nil;
  //AdsFreeAdsValues(adObject,1);
  }
end;


function TServerMethods1.ValidarADNew_WW(pUsuario, pSenha: String): String;
var
 Container : IADsContainer;
 NewObject : IADs;
 User : IADsUser;
 hr : HREsult;
 host : String;
begin
 host := 'LDAP://' + RetornarParametroAD;
 // COM must be initialized
 CoInitialize(nil);

 // Bind to the container.
 hr := ADsGetObject(host,IADsContainer,Container);
 if Failed(hr) then exit;
 // Create the new Active Directory Service Interfaces  User object.
 NewObject := Container.Create(pUsuario,'ActiveDirectoryUser') as IADs;
 // Get the IADsUser interface from the user object.
 NewObject.QueryInterface(IID_IADsUser, User);
 // Set the password.
 User.SetPassword(psenha);
 // Complete the operation to create the object.
 User.SetInfo;
 // Cleanup.
 Container._Release;
 NewObject._Release;
 User._Release;
 CoUninitialize;
end;

function TServerMethods1.ValidarADNew_W(pUsuario, pSenha: String): Boolean;
var
  Adc_Login: TADOConnection;
  Qry_Login: TADOQuery;
  Host : String;
begin
  Host := RetornarParametroAD;

    Adc_Login:= TADOConnection.Create(nil);
    Qry_Login:= TADOQuery.Create(Adc_Login);
    Qry_Login.Connection := Adc_Login;

    Adc_Login.LoginPrompt := False;
    Adc_Login.KeepConnection := False;
    Adc_Login.Mode := cmRead;
    Adc_Login.Provider := 'AdsDSOObject';

    try
      //Passa o Dominio, usuário e senha do LDAP na string de conexão...
      Qry_Login.SQL.Text :=
        ' SELECT' +
        '   cn' +
        ' FROM' +
        '   %Dominio%' +
        ' WHERE objectClass = ''cn'' ';
      Qry_Login.CursorType := ctStatic;

      Qry_Login.Close;

      try
        Adc_Login.ConnectionString :=
        'Provider=ADsDSOObject;Encrypt Password=True;Data Source=LDAP://' + Host +
        //'Provider=ADsDSOObject;Data Source=LDAP://' + Host +
        ';User ID =' + pUsuario +
        ';Password=' + pSenha +
        ';Mode=Read';

        Adc_Login.Open;
        Adc_Login.Connected := True;
      except
        on e:exception do
        begin
          result := False;
          exit;
        end;
      end;

      try
        with (Qry_Login) do
        begin
          Close;
          SQL.Text := StringReplace(SQL.Text, '%Dominio%', QuotedStr('LDAP://'+Host), [rfReplaceAll]);
          //Mensagem(SQL.Text);
          //sql.SaveToFile('c:\temp\ad.sql');
          Open;
        end;
      except
        on e:exception do
        begin
           result := False;
          exit;
        end;
      end;
    finally
      FreeAndNil(Qry_Login);
      FreeAndNil(Adc_Login);
    end;

  result := True;
end;

procedure TServerMethods1.GravarLOGAD(usuario,status : String);
 function AjustarTamanho(str : String; tam : integer): String;
    begin
      result := str +  StringOfChar(' ', tam - Length(str)) ;
    end;
var arqIni : TiniFile;
    caminho, data : String;
    strarq : TStringList;

begin
  if status = 'SUCESSO' then
    status := 'Sucesso';
  if status = 'FALHA' then
    status := 'Falha';

  data := FormatDateTime('YYYYMMDD', now);
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  caminho        := arqIni.ReadString('AD', 'log',    '');
  strarq := TStringList.Create;
  if FileExists(caminho + '_' + data + '.csv') then
    strarq.LoadFromFile(caminho + '_' + data + '.csv')
  else
    strarq.Add(AnsiToUtf8('SistRot   |UsuarioAlvo                                       |' +
                          'UsuarioResponsável                                |OrigemAcesso        |' +
                          'Data      |Resultado                                                   ' +
                          '                                                                                                                                                                                                                                                |T'));


    //strarq.Add(AnsiToUtf8('SistemaRotina|UsuarioAlvo|UsuarioResponsável|OrigemAcesso|Data|Resultado|TipoDeEvento'));
  strarq.Add(AnsiToUtf8(AjustarTamanho('426_SOX', 10) + '|' + AjustarTamanho(usuario,50) + '|' +
                        AjustarTamanho(' ',50) + '|' +AjustarTamanho('D4253N001',20) + '|' +
                        FormatDateTime('YYYY-MM-DD', now)+'|'+ AjustarTamanho(status,300) + '|1'));
  strarq.SaveToFile(caminho + '_' + data + '.csv');
  FreeAndNil(strarq);
end;

function TServerMethods1.RetornarArqTemplate(id: Integer): String;
var
  fqry : TFDQuery;
  arq : TStringList;
begin
  fqry := TFDQuery.Create(nil);
  fqry.Connection := FDCon;
  ConectarBanco(0);
  fqry.SQL.Text := 'select ArquivoTemplateComp from TemplateExportacao where id = ' + IntToStr(id);
  fqry.Open;
  arq := TStringList.Create;
  arq.Add(fqry.FieldByName('ArquivoTemplateComp').AsString);
  result := arq.Text;

  FDCon.Close;
  FreeAndNil(fqry);
  FreeAndNil(arq);
end;

function TServerMethods1.RetornarCaminhoArq : String;
var arqIni : TiniFile;
begin
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  result         := arqIni.ReadString('configuracoes', 'caminho',    '');
end;

function TServerMethods1.BuscaSequencial(Usuario, Senha: String;
  ConnectionID: Integer; Relatorio: String;
  buscaSequencial: TBuscaSequencialDTO_M): TResultadoBuscaSequencialDTO;
var
  multicoldManager: TMulticoldManager;
  busca: TBuscaSequencial;
  resultadoBusca: TResultadoBuscaSequencial;
  pesquisa: TListaPesquisa;
  resultadoQuery: TListaResultadoPesquisa;

  I: Integer;
begin
  Result := nil;

  multicoldManager := TMulticoldManager.Create(Usuario, Senha, Relatorio, false);
  try
    multicoldManager.AbrirRelatorio;

    case buscaSequencial.TipoBusca of
      0:
      begin
        resultadoBusca := multicoldManager.ExecutarBuscaSequencial(buscaSequencial.PagIni,
                                                 buscaSequencial.PagFin,
                                                 buscaSequencial.LinIni,
                                                 buscaSequencial.LinFin,
                                                 buscaSequencial.Coluna,
                                                 buscaSequencial.TipoBusca,
                                                 buscaSequencial.ValorBusca);

      end;
      1:
      begin

        if buscaSequencial.QueryFacil = nil then
          exit;

        SetLength(pesquisa, Length(buscaSequencial.QueryFacil));

        for I := 0 to Length(buscaSequencial.QueryFacil)-1 do
        begin
          pesquisa[I].Index := BuscaSequencial.QueryFacil[I].Index_;
          pesquisa[I].Campo := BuscaSequencial.QueryFacil[I].Campo;
          pesquisa[I].Operador := BuscaSequencial.QueryFacil[I].Operador;
          pesquisa[I].Valor := BuscaSequencial.QueryFacil[I].Valor;
        end;


        if multicoldManager.ExecutarQueryFacil(pesquisa, buscaSequencial.ConectorQuery, resultadoQuery) then
        begin
          resultadoBusca := multicoldManager.ExecutarBuscaSequencial(buscaSequencial.PagIni,
                                                   buscaSequencial.PagFin,
                                                   buscaSequencial.LinIni,
                                                   buscaSequencial.LinFin,
                                                   buscaSequencial.Coluna,
                                                   buscaSequencial.TipoBusca,
                                                   buscaSequencial.ValorBusca);

        end;
      end;
    end;

    Result := TResultadoBuscaSequencialDTO.Create;

    Result.Localizou := resultadoBusca.Localizou;
    Result.LinhaLocalizada := resultadoBusca.LinhaLocalizada;
    Result.ColunaLocalizada := resultadoBusca.ColunaLocalizada;
    Result.Pagina := resultadoBusca.Pagina;
    Result.IndexPagLoc := resultadoBusca.IndexPagLoc;
    Result.QtdeTotalPag := resultadoBusca.QtdeTotalPag;
    Result.QtdeBytesPag := resultadoBusca.QtdeBytesPag;
    Result.IndexPagLocPesq := resultadoBusca.IndexPagLocPesq;

    resultadoBusca.Free;

  finally
    FreeAndNil(multicoldManager);
  end;
end;


end.

