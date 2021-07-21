{ Invokable implementation File for TMulticoldServer which implements IMulticoldServer }

// 30/05/2013 - Versão 2.0.0.2
//            - Alterada a rotina de autenticação de usuários conforme novo modelo Fidelity
//            - Retirado o teste de senha do usuário

unit MulticoldServerImpl;

interface

uses InvokeRegistry, Types, XSBuiltIns, MulticoldServerIntf,
     SuTypGer, SuTypMultiCold, SuBrug, SysUtils, ADODB,
     Classes, Variants, DBTables, DB, DBClient, Pilha,
     dm, ZLibEx, UBuscaSequencial, UMulticoldReport;

type

  TPesquisa = Record
             Campo : Char;
             Pagina : Integer;
             Relativo : Integer;
             Linha : Integer;
  end;

  itX = Class
  public
    procedure log(Const nomeArq, Msg : WideString);
    procedure LogaLocal(Const Mens : WideString);
    procedure LogaTempoExecucao(NomeProc : WideString; DtInicio : TDateTime);
    Procedure InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : WideString; Grupo, SubGrupo, CodMens : Integer);
    function VerificaSeguranca(NomeRel, Usuario : WideString; Var Rel133CC, CmprBrncs : Boolean; Var ArrRegIndice : tgRegIndice) : Boolean; stdCall;
  end;

  { TMulticoldServer }
  TMulticoldServer = class(TInvokableClass, IMulticoldServer)
  public
    function LogIn(Const Usuario, Senha: WideString; out ConnectionID: Integer): WideString; stdCall;

    function GetRelatorio(const Usuario, Senha: WideString; ConnectionID: Integer; const ListaCodRel: WideString; var FullPaths: WideString): WideString; stdCall;
//    function GetPagina(const Usuario, Senha: WideString; ConnectionID: Integer; const Relatorio: WideString; PagNum: Integer; out QtdBytes: Integer; out Pagina: OleVariant): WideString; stdCall;
    function GetPagina(const Usuario, Senha: WideString; ConnectionID: Integer; const Relatorio: WideString; PagNum: Integer; out QtdBytes: Integer; out Pagina: WideString): WideString; stdCall;
    function AbreRelatorio(const Usuario: WideString; const Senha: WideString; ConnectionID: Integer; const FullPath: WideString; out QtdPaginas: Integer; out StrCampos: WideString; out Rel64: Byte; out Rel133: Byte; out CmprBrncs: Byte): Integer; stdCall;
    function ExecutaQueryFacil(const comandoSql: WideString; const PathDB: WideString; const eBDE: Boolean):wideString; stdCall;
    function ExecutaNovaQueryFacil(const gridXML, fileName, usuario : WideString; var mensagem, xmlData : WideString): boolean; stdCall;

    function BuscaSequencial(const Usuario, Senha: WideString; ConnectionID: Integer; const Relatorio: WideString; buscaSequencial: TBuscaSequencialDTO): TResultadoBuscaSequencialDTO; stdCall;
    function teste(p1: WideString; p2: Integer): WideString; stdcall;
  end;

  function convOperador(operador: Integer) : string;

var
  dataModule : TDataModule1;
  vitX : itX;

implementation

uses StdCtrls;

function convOperador(operador: Integer) : string;
begin
  result := '';
  if operador = 1 then
    result := '='
  else if operador = 2 then
    result := '>'
  else if operador = 3 then
    result := '<'
  else if operador = 4 then
    result := '>='
  else if operador = 5 then
    result := '<='
  else if operador = 6 then
    result := '<>'
  else if operador = 7 then
    result := 'IN'
  else if operador = 8 then
    result := 'IS'
  else if operador = 9 then
    result := 'BETWEEN'
  else if operador = 10 then
    result := 'LIKE'
  else if operador = 11 then
    result := 'NOT ='
  else if operador = 12 then
    result := 'NOT >'
  else if operador = 13 then
    result := 'NOT <'
  else if operador = 14 then
    result := 'NOT >='
  else if operador = 15 then
    result := 'NOT <='
  else if operador = 16 then
    result := 'NOT IN'
  else if operador = 17 then
    result := 'NOT BETWEEN'
  else if operador = 18 then
    result := 'IS NOT'
  else
    result := '';
end;


procedure itX.log;
Var
  Arq : System.TextFile;
begin
  try

    forceDirectories(extractFilePath(nomeArq));
    AssignFile(Arq,nomeArq);
    If FileExists(nomeArq) Then
      Append(Arq)
    Else
      ReWrite(Arq);
    WriteLn(Arq, formatDateTime('dd/mm/yyyy - hh:nn:ss ',now)+Msg);
    CloseFile(Arq);

  except
  end;      //Try

end;

procedure itX.LogaLocal;
var
  nomeArquivo : String;
Begin
nomeArquivo := extractFilePath(ParamStr(0))+'LogMultiCold\MulticoldServerLog.'+formatDateTime('yyyymmdd',now)+'.txt';
log(nomeArquivo,Mens);
End;

procedure itX.LogaTempoExecucao;
Var
  nomeArquivo : String;
begin
nomeArquivo := extractFilePath(ParamStr(0))+'PerfMon\MulticoldServerPF.'+formatDateTime('yyyymmdd',now)+'.txt';
log(nomeArquivo,NomeProc + ': '+formatDateTime('dd/mm/yyyy - hh:nn:ss',now)+' '+formatDateTime('hh:nn:ss:zzzz',now-dtInicio));
end;


Procedure itX.InsereEventosVisu;
Var
//  dtLog,
  Agora : TDateTime;
Begin
fileMode := fmShareDenyNone;
//dtLog := now;

if dataModule = nil then
  dataModule := TDataModule1.Create(nil);

if not dataModule.DatabaseEventos.Connected then
  dataModule.DatabaseEventos.Open;

dataModule.DatabaseEventos.Connected := True;
If dataModule.DatabaseEventos.InTransaction Then
  dataModule.DatabaseEventos.CommitTrans;
dataModule.DatabaseEventos.BeginTrans;

Agora := Now;
dataModule.IBEventosQuery1.Close;
dataModule.IBEventosQuery1.Sql.Clear;
dataModule.IBEventosQuery1.Sql.Add('INSERT INTO EVENTOS_VISU (DT, HR, ARQUIVO, DIRETORIO, CODREL, GRUPO, SUBGRUPO, CODUSUARIO, NOMEGRUPOUSUARIO, CODMENSAGEM) ');
dataModule.IBEventosQuery1.Sql.Add('VALUES (:a, :b, :c, :d, :e, :f, :g, :h, :i, :j)');
dataModule.IBEventosQuery1.Parameters[0].Value := Agora;
dataModule.IBEventosQuery1.Parameters[1].Value := Agora;
dataModule.IBEventosQuery1.Parameters[2].Value := Copy(Arquivo,1,70);
dataModule.IBEventosQuery1.Parameters[3].Value := Copy(Diretorio,1,70);
dataModule.IBEventosQuery1.Parameters[4].Value := Copy(CodRel,1,15);
dataModule.IBEventosQuery1.Parameters[5].Value := Grupo;
dataModule.IBEventosQuery1.Parameters[6].Value := SubGrupo;
dataModule.IBEventosQuery1.Parameters[7].Value := Copy(CodUsuario,1,20);
dataModule.IBEventosQuery1.Parameters[8].Value := Copy(NomeGrupoUsuario,1,30);
dataModule.IBEventosQuery1.Parameters[9].Value := CodMens;

  Try
    dataModule.IBEventosQuery1.ExecSql;
  Except
    on e:exception do
      begin
      dataModule.DatabaseEventos.RollbackTrans;
      logaLocal('Erro na gravação de eventos: '+e.Message);
      end;
  End; // Try
  if dataModule.DatabaseEventos.InTransaction then
    dataModule.DatabaseEventos.CommitTrans;

//LogaTempoExecucao('InsereEventosVisu',dtLog);
End;

function itX.VerificaSeguranca;
Var

//  dtLog : TDateTime; // Tirei da raiz!!!!

  //ibQuery1 : TADOQuery;
  //DatabaseLocal : TADOConnection;
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
  //OldFileMode : Integer;
  ArqCNFG : File Of TgRegDFN;
  RegSistema,
  CodSeg,
  RegSisAuto,
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
  ArrSisAux : Array Of Record
                      CodRel : String;
                      CodSis,
                      CodGrupo : Integer;
                      LinI,
                      LinF,
                      Col : Integer;
                      Tipo,
                      CodAux : String;
                      End;
  //ArrRegIndice : Array of TgRegDFN;

  Function CarregaDadosDfnIncExc : Boolean;
  Var
    I : Integer;
  Begin
  Result := True;

  dataModule.IBQuery1.Close;

  dataModule.IBQuery1.Sql.Clear;
  dataModule.IBQuery1.Sql.Add('SELECT * FROM DFN A');
  dataModule.IBQuery1.Sql.Add('ORDER BY A.CODREL ');
  Try
    dataModule.IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('Erro carregando dados de DFN: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  //While Not dataModule.IBQuery1.Eof Do
  //  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto
  SetLength(ArDFN, dataModule.IBQuery1.RecordCount);
  //dataModule.IBQuery1.Close;
  //dataModule.IBQuery1.Open;
  I := 0;
  While Not dataModule.IBQuery1.Eof Do
    Begin
    ArDFN[I].CodRel := dataModule.IBQuery1.FieldByName('CodRel').AsString;
    ArDFN[I].CodSis := dataModule.IBQuery1.FieldByName('CodSis').AsInteger;
    ArDFN[I].CodGrupo := dataModule.IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArDFN[I].CodSubGrupo := dataModule.IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArDFN[I].GrupoAuto := (dataModule.IBQuery1.FieldByName('CodGrupAuto').AsString = 'T') Or
                          (dataModule.IBQuery1.FieldByName('SubDirAuto').AsString = 'T');
    Inc(I);
    dataModule.IBQuery1.Next;
    End;
  dataModule.IBQuery1.Close;

  dataModule.IBQuery1.Sql.Clear;
  dataModule.IBQuery1.Sql.Add('SELECT * FROM USUREL A');
  dataModule.IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
  dataModule.IBQuery1.Sql.Add('      (A.TIPO = ''INC'') ');
  Try
    dataModule.IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('Erro carregando dados de permissão de acesso a relatórios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  //While Not dataModule.IBQuery1.Eof Do
  //  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto
  SetLength(ArINC, dataModule.IBQuery1.RecordCount);
  //dataModule.IBQuery1.Close;
  //dataModule.IBQuery1.Open;
  I := 0;
  While Not dataModule.IBQuery1.Eof Do
    Begin
    ArINC[I].CodUsu := dataModule.IBQuery1.FieldByName('CodUsuario').AsString;
    ArINC[I].CodSis := dataModule.IBQuery1.FieldByName('CodSis').AsInteger;
    ArINC[I].CodGrupo := dataModule.IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArINC[I].CodSubGrupo := dataModule.IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArINC[I].CodRel := dataModule.IBQuery1.FieldByName('CodRel').AsString;
    Inc(I);
    dataModule.IBQuery1.Next;
    End;
  dataModule.IBQuery1.Close;

  dataModule.IBQuery1.Sql.Clear;
  dataModule.IBQuery1.Sql.Add('SELECT * FROM USUREL A');
  dataModule.IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
  dataModule.IBQuery1.Sql.Add('      (A.TIPO = ''EXC'') ');
  Try
    dataModule.IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('Erro carregando dados de negação de acesso a relatórios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  //While Not IBQuery1.Eof Do
  //  IBQuery1.Next;   // Estabelecer o recordcount correto
  SetLength(ArEXC, dataModule.IBQuery1.RecordCount);
  //dataModule.IBQuery1.Close;
  //dataModule.IBQuery1.Open;
  I := 0;
  While Not dataModule.IBQuery1.Eof Do
    Begin
    ArEXC[I].CodUsu := dataModule.IBQuery1.FieldByName('CodUsuario').AsString;
    ArEXC[I].CodSis := dataModule.IBQuery1.FieldByName('CodSis').AsInteger;
    ArEXC[I].CodGrupo := dataModule.IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArEXC[I].CodSubGrupo := dataModule.IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArEXC[I].CodRel := dataModule.IBQuery1.FieldByName('CodRel').AsString;
    Inc(I);
    dataModule.IBQuery1.Next;
    End;
  dataModule.IBQuery1.Close;

  dataModule.IBQuery1.Sql.Clear;
  dataModule.IBQuery1.Sql.Add('SELECT * FROM SISTEMA A');
  Try
    dataModule.IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('Erro carregando dados de sistema: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  //While Not IBQuery1.Eof Do
  //  IBQuery1.Next;   // Estabelecer o recordcount correto
  SetLength(ArSis, dataModule.IBQuery1.RecordCount);
  //dataModule.IBQuery1.Close;
  //dataModule.IBQuery1.Open;
  I := 0;
  While Not dataModule.IBQuery1.Eof Do
    Begin
    ArSis[I].CodSis := dataModule.IBQuery1.FieldByName('CodSis').AsInteger;
    ArSis[I].NomeSis := dataModule.IBQuery1.FieldByName('NomeSis').AsString;
    Inc(I);
    dataModule.IBQuery1.Next;
    End;
  dataModule.IBQuery1.Close;

  dataModule.IBQuery1.Sql.Clear;
  dataModule.IBQuery1.Sql.Add('SELECT * FROM GRUPOSDFN A');
  Try
    dataModule.IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('Erro carregando dados de grupos de relatórios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  //While Not IBQuery1.Eof Do
  //  IBQuery1.Next;   // Estabelecer o recordcount correto
  SetLength(ArGrupo, dataModule.IBQuery1.RecordCount);
  //IBQuery1.Close;
  //IBQuery1.Open;
  I := 0;
  While Not dataModule.IBQuery1.Eof Do
    Begin
    ArGrupo[I].CodSis := dataModule.IBQuery1.FieldByName('CodSis').AsInteger;
    ArGrupo[I].CodGrupo := dataModule.IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArGrupo[I].NomeGrupo := dataModule.IBQuery1.FieldByName('NomeGrupo').AsString;
    Inc(I);
    dataModule.IBQuery1.Next;
    End;
  dataModule.IBQuery1.Close;

  dataModule.IBQuery1.Sql.Clear;
  dataModule.IBQuery1.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
  Try
    dataModule.IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('Erro carregando dados dos subgrupos de relatórios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  //While Not IBQuery1.Eof Do
  //  IBQuery1.Next;   // Estabelecer o recordcount correto
  SetLength(ArSubGrupo, dataModule.IBQuery1.RecordCount);
  //IBQuery1.Close;
  //IBQuery1.Open;
  I := 0;
  While Not dataModule.IBQuery1.Eof Do
    Begin
    ArSubGrupo[I].CodSis := dataModule.IBQuery1.FieldByName('CodSis').AsInteger;
    ArSubGrupo[I].CodGrupo := dataModule.IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArSubGrupo[I].CodSubGrupo := dataModule.IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArSubGrupo[I].NomeSubGrupo := dataModule.IBQuery1.FieldByName('NomeSubGrupo').AsString;
    Inc(I);
    dataModule.IBQuery1.Next;
    End;
  dataModule.IBQuery1.Close;

  dataModule.IBQuery1.Sql.Clear;
  dataModule.IBQuery1.Sql.Add('SELECT * FROM SISAUXDFN');
  dataModule.IBQuery1.Sql.Add('ORDER BY CODSIS, CODGRUPO, CODREL');
  Try
    dataModule.IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('Erro carregando dados dos auxiliares de sistema: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  SetLength(ArrSisAux, dataModule.IBQuery1.RecordCount);

  I := 0;
  While Not dataModule.IBQuery1.Eof Do
    Begin
    ArrSisAux[I].CodRel := dataModule.IBQuery1.FieldByName('CodRel').AsString;
    ArrSisAux[I].CodSis := dataModule.IBQuery1.FieldByName('CodSis').AsInteger;
    ArrSisAux[I].CodGrupo := dataModule.IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArrSisAux[I].LinI := dataModule.IBQuery1.FieldByName('LinI').AsInteger;
    ArrSisAux[I].LinF := dataModule.IBQuery1.FieldByName('LinF').AsInteger;
    ArrSisAux[I].Col := dataModule.IBQuery1.FieldByName('Col').AsInteger;
    ArrSisAux[I].Tipo := dataModule.IBQuery1.FieldByName('Tipo').AsString;
    ArrSisAux[I].CodAux := dataModule.IBQuery1.FieldByName('CodAux').AsString;
    dataModule.IBQuery1.Next;
    Inc(I);
    End;
  dataModule.IBQuery1.Close;

  End; // Function CarregaDadosDfnIncExc : Boolean;

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
fileMode := fmShareDenyNone;
//dtLog := now;
Result := True;

if dataModule = nil then
  dataModule := TDataModule1.Create(nil);

if not dataModule.DatabaseLocal.Connected then
  dataModule.DatabaseLocal.Open;

try
  If FileExists(ChangeFileExt(NomeRel,'.IAPX')) Then // Novo formato, candidato a segurança
    Begin
    AssignFile(ArqCNFG,ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dfn.Dfn');
    //OldFileMode := FileMode;
    //FileMode := fmShareDenyWrite;
    Reset(ArqCNFG);
    //FileMode := OldFileMode;
    Read(ArqCNFG,RegDestinoII); // Lê o primeiro Destino, mas não checa a segurança por ele
    I := 0;
    FillChar(ArrRegIndice,SizeOf(ArrRegIndice),0);
    TemRegGrp := False;
    RegSistema.CODSIS := -999;
    CodSeg.CODSEG := -1; // Inicializar para marcar ...
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
        5 : CodSeg := RegDestinoII;
        6 : RegSisAuto := RegDestinoII;
        End; // Case
      End;

    Rel133CC := (RegDFN.TipoQuebra = 1);
    CmprBrncs := RegDFN.COMPRBRANCOS;

    If Not TemRegGrp Then  // Força que reggrp tenha sempre algum conteúdo
      RegGrp.Grp := RegDFN.CodGrupo;

    CloseFile(ArqCNFG);
    If RegDestino.SEGURANCA Then
      Begin
      dataModule.IBQuery1.Close;
      dataModule.IBQuery1.Sql.Clear;
      dataModule.IBQuery1.Sql.Add('SELECT * FROM USUARIOS A, USUARIOSEGRUPOS B');
      dataModule.IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') ');
      dataModule.IBQuery1.Sql.Add('AND (A.CODUSUARIO = B.CODUSUARIO) ');
      Try
        dataModule.IBQuery1.Open;
      Except
        on e:exception do
          begin
          logaLocal('Erro carregando dados de segurança: '+e.Message);
          Result := False;
          Exit;
          end;
        End; //Try
      CodRel := UpperCase(RegDFN.CodRel); // Código do relatório em questão
      CodGrupo := dataModule.IBQuery1.FieldByName('NomeGrupoUsuario').AsString;
      If CodGrupo = 'ADMSIS' Then
        Begin
        dataModule.IBQuery1.Close;   // Usuario admsis pode ver tudo
        InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                          UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        Exit;
        End;
      dataModule.IBQuery1.Close;

      If Not CarregaDadosDfnIncExc Then
        Begin
        Result := False;
        Exit;
        End;

      I := LocalizaCodRel(CodRel);

      If I = -1 Then
        Begin
        Result := False;
        InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                          UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 02);
        Exit;
        End;

      CodSisDFNAtu := ArDFN[I].CodSis;    // Banco
      CodSisDFNOld := RegSistema.CODSIS;  // Rel (Pode ser -999 se é a versão interbase do relatório...
      If CodSisDFNOld = -1 Then
        CodSisDFNOld := RegSisAuto.CODSISREAL; // Pega o Còdigo Real que é o da copilação do relatório
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
        InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                          UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        End
      Else
        Begin
        Result := False;
        InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                          UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        End;
      End;
    End
except
  on e:exception do
    logaLocal('Erro carregando dados de segurança: '+e.Message);
end;
//LogaTempoExecucao('VerificaSeguranca',dtLog);
End;

function TMulticoldServer.GetRelatorio;
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
      vitX.logaLocal('Erro verificando dados de índice: '+e.Message);
  end;
  End;

Begin
//dtLog := now;
//logaLocal('Requisição de Lista de Relatórios, Usuario = '+Usuario);
fileMode := fmShareDenyNone;

if dataModule = nil then
  dataModule := TDataModule1.Create(nil);

if not dataModule.DatabaseLocal.Connected then
  dataModule.DatabaseLocal.Open;

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
    dataModule.IBQuery1.Close;
    dataModule.IBQuery1.Sql.Clear;
    dataModule.IBQuery1.Sql.Add('SELECT * FROM DESTINOSDFN A ');
    dataModule.IBQuery1.Sql.Add('WHERE A.CODREL = '''+ListBox1[0]+'''');
    dataModule.IBQuery1.Sql.Add('AND A.TIPODESTINO = ''Dir''');
    dataModule.IBQuery1.Sql.Add('AND A.SEGURANCA = ''S''');
    try
      dataModule.IBQuery1.Open;
    except
      on e:exception do
        vitX.logaLocal('Erro carregando dados de destino de relatórios: '+e.Message);
    end;
    If dataModule.IBQuery1.RecordCount <> 0 Then
      Begin
      If UpperCase(dataModule.IBQuery1.FieldByName('DirExpl').AsString) = 'S' Then
        CmplPath := '\'
      Else
        CmplPath := FullPaths;
      FullPaths := '';
      OutroPath := IncludeTrailingPathDelimiter(UpperCase(dataModule.IBQuery1.FieldByName('Destino').AsString)) + CmplPath;
      // Macaquinho para Daniel - 12/11/2007
      vitX.LogaLocal('Procurando relatórios em: '+OutroPath);
      errorCode := FindFirst(OutroPath+'*.DAT',faAnyFile,SearchRec);
      If errorCode = 0 Then
        Repeat
          FullPathsTemp.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+
                            OutroPath+SearchRec.Name); // Armazena o nome do arquivo (FullPath)
          ListBox2.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+' '+
                       PegaInfo(OutroPath+SearchRec.Name));
          // Macaquinho para Daniel - 12/11/2007
          vitX.LogaLocal('Relatório encontrado '+OutroPath+SearchRec.Name);
        Until FindNext(SearchRec) <> 0
      else
        begin
        vitX.logaLocal('Relatório não encontrado. Motivo: '+IntToStr(ErrorCode));
        vitX.logaLocal('Motivo: '+SysErrorMessage(ErrorCode));
        GetLastError;
        end;
      FindClose(SearchRec);
      End;
    dataModule.IBQuery1.Close;
    End;
  ListBox1.Free;
  //Result := ListBox2.Text;
  try
//    vitX.logaLocal('getRelatorio: '+FullPathsTemp.Text);
//    vitX.logaLocal('getRelatorio: '+ListBox2.Text);
//    auxStr := FullPathsTemp.Text;
    FullPaths := compressStringReturnHex(FullPathsTemp.Text);
//    auxStr := ListBox2.Text;
    result := compressStringReturnHex(ListBox2.Text);
    vitX.logaLocal('getRelatorio: '+FullPaths);
    vitX.logaLocal('getRelatorio: '+result);
//    FullPaths := FullPathsTemp.Text;
//    result := ListBox2.Text;

  except
    on e:exception do
      vitX.logaLocal('getRelatorio: '+e.Message);
  end;
  ListBox2.Free;
  FullPathsTemp.Free;
except
  on e:exception do
    vitX.logaLocal('Erro carregando dados de relatório: '+e.Message);
end;
//LogaTempoExecucao('GetRelatorio',dtLog);
End;

function TMulticoldServer.GetPagina;
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

Begin
//dtLog := now;
vitX.logaLocal('GetPagina - N. '+IntToStr(PagNum)+', Usuario = '+Usuario);
vitX.logaLocal(Relatorio);
fileMode := fmShareDenyNone;
Result := '';
AssignFile(Arq,Relatorio);
Try
  Reset(Arq,1);
Except
  on e:exception do
    begin
    vitX.logaLocal('Erro de abertura do relatório:  '+Relatorio+#13#10+e.Message);
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
      vitX.logaLocal('Erro de abertura IAPX:  '+Relatorio+#13#10+e.Message);
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
vitX.logaLocal(Pagina);

Result := '0';

Dispose(ArrBuf);
vitX.logaLocal('GetPagina concluida com sucesso');
//LogaTempoExecucao('GetPagina',dtLog);
End;

function TMulticoldServer.BuscaSequencial(const Usuario, Senha: WideString;
  ConnectionID: Integer; const Relatorio: WideString;
  buscaSequencial: TBuscaSequencialDTO): TResultadoBuscaSequencialDTO;
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
      tbNormal:
      begin
        resultadoBusca := multicoldManager.ExecutarBuscaSequencial(buscaSequencial.PagIni,
                                                 buscaSequencial.PagFin,
                                                 buscaSequencial.LinIni,
                                                 buscaSequencial.LinFin,
                                                 buscaSequencial.Coluna,
                                                 buscaSequencial.TipoBusca,
                                                 buscaSequencial.ValorBusca);

      end;
      tbPesquisa:
      begin

        if buscaSequencial.QueryFacil = nil then
          exit;

        SetLength(pesquisa, Length(buscaSequencial.QueryFacil));

        for I := 0 to Length(buscaSequencial.QueryFacil)-1 do
        begin
          pesquisa[I].Index := BuscaSequencial.QueryFacil[I].Index;
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

Function TMulticoldServer.LogIn;
Var

//  dtLog : TDateTime; // Tirei da raiz!!!!

  AuxQtd : Integer;
  Linha,
  Resulta : String;
Begin
//vitX.logaLocal('Entrou em LogIn '+Usuario);
//vitX.logaLocal(ParamStr(0));

fileMode := fmShareDenyNone;
//dtLog := now;

if dataModule = nil then
  begin
//  vitX.logaLocal('dataModule é nil ');
  dataModule := TDataModule1.Create(nil);
//  vitX.logaLocal('Criou o datamodule, vai abrir o BD ');
  end;
//vitX.logaLocal('Vai testar se o BD está conectado ');
if not dataModule.DatabaseLocal.Connected then
  begin
//  vitX.logaLocal('Vai tentar conectar ');
  try
    dataModule.DatabaseLocal.Open;
  except
    on e:exception do
      begin
      vitX.logaLocal(e.Message);
      exit;
      end;
  end; //Try
  end;
//vitX.logaLocal('Abriu o BD ');

Result := '';
Resulta := '';
vitX.logaLocal('Requisição de LogIn, Usuario = '+Usuario);
dataModule.IBQuery1.Sql.Clear;
dataModule.IBQuery1.Sql.Add('SELECT * FROM USUARIOS A');
dataModule.IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') ');
{If Senha = '' Then
  dataModule.IBQuery1.Sql.Add('AND   (A.SENHA IS NULL) ')
Else
  dataModule.IBQuery1.Sql.Add('AND   (A.SENHA = '''+Senha+''') ');   }
dataModule.IBQuery1.Sql.Add('AND   (A.REMOTO = ''S'') ');
try
//  vitX.logaLocal('Montou o sql, vai dar open na query ');
//  vitX.logaLocal(dataModule.IBQuery1.SQL.Text);
  dataModule.IBQuery1.Open;
//  vitX.logaLocal('Query is open');
except
  on e:exception do
    begin
    vitX.LogaLocal('Open query deu erro: '+e.Message);
    ConnectionID := 0;
    dataModule.IBQuery1.Close;
    Result := compressStringReturnHex('Erro no acesso ao banco de dados - query ');
//    Result := ('Erro no acesso ao banco de dados - query ');
    Exit;
    end;
end;
If dataModule.IBQuery1.RecordCount = 0 Then
  Begin
  ConnectionID := 0;
  dataModule.IBQuery1.Close;
  vitX.LogaLocal('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado');
  Result := compressStringReturnHex('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado');
//  Result := (('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado'));
  Exit;
  End;
dataModule.IBQuery1.Close;

//vitX.LogaLocal('Aqui 1');

// Inicio da carga das informações...
dataModule.IBQuery1.Sql.Clear;
dataModule.IBQuery1.Sql.Add('SELECT * FROM DFN A');
dataModule.IBQuery1.Sql.Add('ORDER BY A.CODREL ');
Try
  dataModule.IBQuery1.Open;
Except
  on e:exception do
    begin
    vitX.LogaLocal('Erro ao tentar carregar dados de DFN: '+e.Message);
    //LogaLocal('Erro ao tentar carregar dados de DFN ' + Usuario);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de DFN ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de DFN ' + Usuario));
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

AuxQTd := 0;
While Not dataModule.IBQuery1.Eof Do
  begin
  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
dataModule.IBQuery1.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de DFNs

//vitX.LogaLocal('Aqui 2');

While Not dataModule.IBQuery1.Eof Do
  Begin
  Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodRel').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf);

  If (dataModule.IBQuery1.FieldByName('CodGrupAuto').AsString = 'T') Or
     (dataModule.IBQuery1.FieldByName('SubDirAuto').AsString = 'T') Then
    Resulta := (Resulta + 'T' + CrLf)
  Else
    Resulta := (Resulta + 'F' + CrLf);

  If (dataModule.IBQuery1.FieldByName('SisAuto').AsString = 'T') Then
    Resulta := (Resulta + 'T' + CrLf)
  Else
    Resulta := (Resulta + 'F' + CrLf);

  dataModule.IBQuery1.Next;
  End;
dataModule.IBQuery1.Close;

//vitX.LogaLocal('Aqui 3');

dataModule.IBQuery1.Sql.Clear;
dataModule.IBQuery1.Sql.Add('SELECT * FROM USUREL A');
dataModule.IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
dataModule.IBQuery1.Sql.Add('      (A.TIPO = ''INC'') ');
Try
  dataModule.IBQuery1.Open;
Except
  on e:exception do
    begin
    vitX.LogaLocal('Erro carregando permissões de acesso a relatórios: '+e.Message);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de USUREL INC ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de USUREL INC ' + Usuario));
    ConnectionID := 0;
    Exit;
    end;
  End; // Try
If dataModule.IBQuery1.RecordCount = 0 Then
  Begin
  ConnectionID := 0;
  dataModule.IBQuery1.Close;
  vitX.LogaLocal('LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados');
  Result := compressStringReturnHex('LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados');
//  Result := (('LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados'));
  Exit;
  End;

AuxQTd := 0;
While Not dataModule.IBQuery1.Eof Do
  begin
  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
dataModule.IBQuery1.First;

//vitX.LogaLocal(IntToStr(AuxQTd));
Resulta := (Resulta + IntToStr(AuxQTd) + CrLf); // Quantidade de INCs

//vitX.LogaLocal('Aqui 4');

Linha := '';
While Not dataModule.IBQuery1.Eof Do
  Begin
  Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodUsuario').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodRel').AsString + CrLf);
  Linha := (Linha + dataModule.IBQuery1.FieldByName('CodUsuario').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodRel').AsString + CrLf);
  dataModule.IBQuery1.Next;
  End;
dataModule.IBQuery1.Close;

//vitX.LogaLocal(Linha);

dataModule.IBQuery1.Sql.Clear;
dataModule.IBQuery1.Sql.Add('SELECT * FROM USUREL A');
dataModule.IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
dataModule.IBQuery1.Sql.Add('      (A.TIPO = ''EXC'') ');
Try
  dataModule.IBQuery1.Open;
Except
  on e:exception do
    begin
    vitX.LogaLocal('Erro carregando dados de negação de acesso a relatórios: '+e.Message);
    ConnectionID := 0;
    Result := compressStringReturnHex('Erro ao tentar carregar dados de USUREL EXC '+Usuario);
//    Result := (('Erro ao tentar carregar dados de USUREL EXC '+Usuario));
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not dataModule.IBQuery1.Eof Do
  begin
  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
dataModule.IBQuery1.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de EXCs

//vitX.LogaLocal('Aqui 5');

While Not dataModule.IBQuery1.Eof Do
  Begin
  Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodUsuario').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('CodRel').AsString + CrLf);
  dataModule.IBQuery1.Next;
  End;
dataModule.IBQuery1.Close;

dataModule.IBQuery1.Sql.Clear;
dataModule.IBQuery1.Sql.Add('SELECT * FROM SISTEMA A');
Try
  dataModule.IBQuery1.Open;
Except
  on e:exception do
    begin
    vitX.LogaLocal('Erro ao tentar carregar dados de SISTEMA para '+Usuario+': '+e.Message);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de SISTEMA para ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de SISTEMA para ' + Usuario));
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not dataModule.IBQuery1.Eof Do
  begin
  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
dataModule.IBQuery1.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de Grupos

//vitX.LogaLocal('Aqui 6');

While Not dataModule.IBQuery1.Eof Do
  Begin
  Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     dataModule.IBQuery1.FieldByName('NomeSis').AsString + CrLf);
  dataModule.IBQuery1.Next;
  End;
dataModule.IBQuery1.Close;

dataModule.IBQuery1.Sql.Clear;
dataModule.IBQuery1.Sql.Add('SELECT * FROM GRUPOSDFN A');
Try
  dataModule.IBQuery1.Open;
Except
  on e:exception do
    begin
    vitX.LogaLocal('Erro ao tentar carregar dados de GRUPO para '+Usuario+': '+e.Message);
    Result := compressStringReturnHex('Erro ao tentar carregar dados de GRUPO para ' + Usuario);
//    Result := (('Erro ao tentar carregar dados de GRUPO para ' + Usuario));
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not dataModule.IBQuery1.Eof Do
  begin
  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
dataModule.IBQuery1.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de Grupos

//vitX.LogaLocal('Aqui 7');

While Not dataModule.IBQuery1.Eof Do
  Begin
  Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('NomeGrupo').AsString + CrLf);
  dataModule.IBQuery1.Next;
  End;
dataModule.IBQuery1.Close;

dataModule.IBQuery1.Sql.Clear;
dataModule.IBQuery1.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
Try
  dataModule.IBQuery1.Open;
Except
  on e:exception do
    begin
    vitX.LogaLocal('Erro ao tentar carregar dados de SUBGRUPO para '+Usuario+': '+e.Message);
    result := compressStringReturnHex('Erro ao tentar carregar dados de SUBGRUPO para '+Usuario+': '+e.Message);
//    result := (('Erro ao tentar carregar dados de SUBGRUPO para '+Usuario+': '+e.Message));
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

AuxQtd := 0;
While Not dataModule.IBQuery1.Eof Do
  begin
  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
dataModule.IBQuery1.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de SubGrupos

//vitX.LogaLocal('Aqui 8');

While Not dataModule.IBQuery1.Eof Do
  Begin
    Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('NomeSubGrupo').AsString + CrLf);
  dataModule.IBQuery1.Next;
  End;
dataModule.IBQuery1.Close;

//vitX.LogaLocal('Aqui 9');

dataModule.IBQuery1.Sql.Clear;
//vitX.LogaLocal('Aqui 91');
dataModule.IBQuery1.Sql.Add('SELECT DISTINCT CODREL, CODSIS, CODGRUPO FROM SISAUXDFN');
//vitX.LogaLocal('Aqui 92');
try
  dataModule.IBQuery1.Open;
//  vitX.LogaLocal('Aqui 93');
except
  on e:exception do
    begin
    vitX.LogaLocal('Erro ao tentar carregar dados de SISAUXDFN para '+Usuario+': '+e.Message);
    result := compressStringReturnHex('Erro ao tentar carregar dados de SISAUXDFN para '+Usuario+': '+e.Message);
//    result := (('Erro ao tentar carregar dados de SISAUXDFN para '+Usuario+': '+e.Message));
    ConnectionID := 0;
    Exit;
    end;
end;

//vitX.LogaLocal('Aqui 94');
//vitX.LogaLocal('Aqui 95');
AuxQTd := 0;
While Not dataModule.IBQuery1.Eof Do
  begin
  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto nesta query que tem DISTINCT e o dbExpress NÃO GOSTA!!!
  Inc(AuxQtd);
  end;
dataModule.IBQuery1.First;

Resulta := (Resulta + IntToStr(AuxQtd) + CrLf); // Quantidade de SisAuxDfn

//vitX.LogaLocal('Aqui 10');

while not dataModule.IBQuery1.Eof do
  begin
  If AuxQtd = 1 Then
    Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodRel').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('CodGrupo').AsString) // O último não tem CrLf
  Else
    Resulta := (Resulta + dataModule.IBQuery1.FieldByName('CodRel').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('CodSis').AsString + CrLf +
                       dataModule.IBQuery1.FieldByName('CodGrupo').AsString + CrLf);
  dataModule.IBQuery1.Next;
  Dec(AuxQtd);
  end;
dataModule.IBQuery1.Close;

//vitX.LogaLocal('Aqui 11');

// Fim da carga de informações...
// Compressão do retorno para reduzir o tempo de execução -> Deixou de funcionar com Delphi Xe4
try
  result := compressStringReturnHex(resulta);
//  result := resulta;
except
  on e:exception do
    vitX.logaLocal('login: '+e.Message);
end;
dataModule.IBQuery1.Close;

ConnectionID := 1;

//vitX.logaLocal(Result);
//vitX.logaLocal('Aqui no final');
//LogaTempoExecucao('LogIn',dtLog);
End;


function TMulticoldServer.teste(p1: WideString; p2: Integer): WideString;
begin
  result := 'Hellow';
end;

function TMulticoldServer.AbreRelatorio;
Var

//  dtLog : TDateTime; // Tirei da raiz!!!!

  Arq : File;
  I : Integer;
  ArqPag64 : File Of Int64;
  ArrRegIndice : TgRegIndice;
  StrAux : String;

Begin
//dtLog := now;
fileMode := fmShareDenyNone;
Result := 99999; // Código para o erro não detectado
try
  //LogaLocal('Requisição de abertura de relatório, Usuario = '+Usuario+', Arquivo = '+FullPath);
  //LogaLocal('Verificando segurança ');
  If Not vitX.VerificaSeguranca(FullPath, Usuario, Boolean(Rel133), Boolean(CmprBrncs), ArrRegIndice) Then
    Begin
    //LogaLocal('Acesso ao relatório negado '+FullPath);
    Result := 1;
    Exit;
    End;
  //FileMode := fmShareDenyWrite;
  AssignFile(Arq,FullPath);
  {$i-}
  Reset(Arq,1);
  {$i+}
  I := IoResult;
  If (I <> 0) Then
    Begin
    vitX.LogaLocal('Relatório não pode ser aberto: '+FullPath+' Falha '+IntToStr(I));
    Result := 2;
    Exit;
    End;
  If (Filesize(Arq) = 0) Then
    Begin
    vitX.LogaLocal('Relatório não pode ser aberto: '+FullPath+' Arquivo Vazio');
    Result := 3;
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
    vitX.LogaLocal('Índice de página não pode ser aberto 2');
    Result := 5;
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
  Result := 0;
  //vitX.LogaLocal('Relatório '+FullPath+' aberto com sucesso');
except
  on e:exception do
    vitX.LogaLocal('AbreRelatorio '+e.Message);
end;
//LogaTempoExecucao('AbreRelatorio',dtLog);
End;

function TMulticoldServer.ExecutaQueryFacil;
var

//  dtLog : TDateTime; // Tirei da raiz!!!!

  qryDBF : TDataSet;
begin
fileMode := fmShareDenyNone;
//dtLog := now;
if eBDE then
  begin
  qryDBF := TQuery.Create(Nil);
  (qryDBF as TQuery).DatabaseName := PathDB;
  (qryDBF as TQuery).SQL.Clear;
  (qryDBF as TQuery).SQL.Add(comandoSql);
  end
else
  begin
  qryDBF := TAdoQuery.Create(Nil);
  (qryDBF as TAdoQuery).ConnectionString := 'Provider=MSDASQL.1;'+
                                            'Persist Security Info=False;'+
                                            'Extended Properties="CollatingSequence=ASCII;'+
                                                                 'DefaultDir='+PathDB+';'+
                                                                 'Deleted=1;'+
                                                                 'Driver={Driver do Microsoft dBase (*.dbf)};'+ // Driver em português
                                                                 'DriverId=21;'+
                                                                 'FIL=dBase III;'+
                                                                 'FILEDSN='+extractFilePath(ParamStr(0))+'Multicold.dsn;'+
                                                                 'MaxBufferSize=2048;'+
                                                                 'MaxScanRows=8;'+
                                                                 'PageTimeout=600;'+
                                                                 'SafeTransactions=0;'+
                                                                 'Statistics=0;'+
                                                                 'Threads=3;'+
                                                                 'UID=admin;'+
                                                                 'UserCommitSync=Yes;"';
  (qryDBF as TAdoQuery).SQL.Clear;
  (qryDBF as TAdoQuery).SQL.Add(comandoSql);
  end;
try
  qryDBF.Open;
  result := dataSetToXML(qryDBF, 1000);
  qryDBF.Close;
except
  on e:exception do
    begin
    vitX.LogaLocal('**********');
    vitX.LogaLocal('ExecutaQueryFacil - Erro:'+e.Message);
    vitX.LogaLocal('ExecutaQueryFacil - Path:'+PathDB);
    vitX.LogaLocal('ExecutaQueryFacil - SQL: '+comandoSql);
    vitX.LogaLocal('**********');
    end;
end;
qryDBF.free;
//LogaTempoExecucao('ExecutaQueryFacil',dtLog);
end;


function TMulticoldServer.ExecutaNovaQueryFacil;
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
      vitX.LogaLocal('leRegistroFileStreamOuQuery:'+e.Message);
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
      vitX.LogaLocal('tamanhoDados:'+e.Message);
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
                  result := false;
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
              vitX.LogaLocal('abrirDados:'+e.Message);
              vitX.LogaLocal('abrirDados - SQL:'+Query.SQL.Text);
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
      vitX.LogaLocal('abrirDados:'+e.Message);
      if Query <> nil then
        vitX.LogaLocal('abrirDados - SQL:'+Query.SQL.Text);
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
      deleteFile(dirSecao+operando+'.Multicold');
      end
    else
      Query.Close;
  except
    on e:exception do
      vitX.LogaLocal('fechaArquivoTemp:'+e.Message);
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

  abrirDados(dataModule.Query1, objF1, oprnd1);
  leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);

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
    leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
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
  vitX.LogaLocal('Query: '+xmlData);
//  xmlData := s;

  fechaArquivoTemp(dataModule.Query1,objF1,oprnd1);
  end;

  procedure descarregaOR();
  var
    intArqNum : integer;
  begin
  abrirDados(dataModule.Query1, objF1, oprnd1);
  abrirDados(dataModule.Query2, objF2, oprnd2);
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
  leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
  leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      h.write(reg1,sizeOf(reg1));
      leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
      leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
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
      leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
      reg2.Pagina := MAXINT;
      end
    end;
  while (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
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
      leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
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
  fechaArquivoTemp(dataModule.Query1,objF1,oprnd1);
  fechaArquivoTemp(dataModule.Query2,objF2,oprnd2);
  pilhaExecucao.push(intArqNum);
  end;

  procedure descarregaAND;
  var
    intArqNum : integer;
  begin
  abrirDados(dataModule.Query1, objF1, oprnd1);
  abrirDados(dataModule.Query2, objF2, oprnd2);
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
  leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
  leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
  if (ehEOF1) or (ehEOF2) then
    begin
    h.Free;
    fechaArquivoTemp(dataModule.Query1,objF1,oprnd1);
    fechaArquivoTemp(dataModule.Query2,objF2,oprnd2);
    pilhaExecucao.push(j);
    exit;
    end;
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      pgAux := reg1.Pagina;
      while (reg1.Pagina = reg2.Pagina) and (not ehEOF1) do
        begin
        h.write(reg1,sizeOf(reg1));
        leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
        end;
      if (pgAux = reg1.Pagina) then
        h.write(reg1,sizeOf(reg1));
      while (pgAux = reg2.Pagina) and (not ehEOF2) do
        begin
        h.write(reg2,sizeOf(reg2));
        leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
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
      leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      if primeiraVez then
        begin
        h.write(reg2,sizeOf(reg2));
        primeiraVez := false;
        end;
      leRegistroFileStreamOuQuery(dataModule.Query1,objF1,reg1,ehEOF1,oprnd1);
      end
    end;
  primeiraVez := true;
  while (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
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
      leRegistroFileStreamOuQuery(dataModule.Query2,objF2,reg2,ehEOF2,oprnd2);
      end
    end;
  if (reg1.Pagina = reg2.Pagina) and (reg1.Pagina <> MAXINT) then
    begin
    h.write(reg2,sizeOf(reg2));
    h.write(reg1,sizeOf(reg1));
    end;
  h.Free;
  fechaArquivoTemp(dataModule.Query1,objF1,oprnd1);
  fechaArquivoTemp(dataModule.Query2,objF2,oprnd2);
  pilhaExecucao.push(intArqNum);
  end;

  procedure descarregaPilha(strPilha : string);
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
result := false;

dirSecao := ColetaDiretorioTemporario+'Multicold_'+formatDateTime('yyyymmddhhnnsszzzz',now)+'\';
forceDirectories(dirSecao);

if dataModule = nil then
  dataModule := TDataModule1.Create(nil);

dataModule.Session1.PrivateDir := dirSecao;
dataModule.Session1.NetFileDir := dirSecao;
dataModule.Session1.Active := true;

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
      vitX.LogaLocal('Erro na execução da query fácil remota: '+e.Message);
      vitX.LogaLocal(gridXML);
      exit;
      end;
  end;

//  if dataModule = nil then
//    dataModule := TDataModule1.Create(nil);
//  vitX.LogaLocal('Processar pilha: '+mensagem);
  descarregaPilha(mensagem);    // mensagem vem com a posfixa do grid da query fácil
//  vitX.LogaLocal('Processou pilha: '+xmlData);

  result := true;
finally

  dataModule.Session1.Active := false;

  if findFirst(dirSecao+'*.*',faAnyFile,f) = 0 then
    repeat
      if (f.Name <> '.') and (f.Name <> '.') then
        deleteFile(dirSecao+f.Name);
    until findNext(f) <> 0;
  findClose(f);

  removeDir(dirSecao);
  //Query1.Free;
  //Query2.Free;
  //rSet.Free;
  pilhaExecucao.Free;
end;
//LogaTempoExecucao('ExecutaNovaQueryFacil',dtLog);
end;

initialization
  { Invokable classes must be registered }
  InvRegistry.RegisterInvokableClass(TMulticoldServer);

end.
