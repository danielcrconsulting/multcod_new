Unit MultiColdServerInterfaceUnit1;

Interface

Uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, MultiColdServer_TLB, StdVcl, DBTables, Db, Provider,
  IBDatabase, IBCustomDataSet, IBQuery, SutypGer, Subrug, SuTypMultiCold,
  ADODB;

Type

  TgRegIndice = Array0_199OfTgRegDFN;

  TMultiColdDataServer = Class(TRemoteDataModule, IMultiColdDataServer)
    DataSetProvider: TDataSetProvider;
    ibQuery1: TADOQuery;
    ibEventosQuery1: TADOQuery;
    DatabaseLocal: TADOConnection;
    DatabaseEventos: TADOConnection;
    QueryPsq: TADOQuery;
    procedure Session1Startup(Sender: TObject);
    procedure RemoteDataModuleCreate(Sender: TObject);
    procedure DatabaseLocalLogin(Database: TDatabase;
      LoginParams: TStrings);
    procedure DatabaseEventosLogin(Database: TDatabase;
      LoginParams: TStrings);
  Private
    { Private declarations }
  Protected
    Class Procedure UpdateRegistry(Register: Boolean; Const ClassID, ProgID: String); Override;
    function GetRelatorio(const Usuario, Senha: WideString;
      ConnectionID: Integer; const ListaCodRel: WideString;
      var FullPaths: WideString): WideString; safecall;
    function GetPagina(const Usuario, Senha: WideString; ConnectionID: Integer;
      const Relatorio: WideString; PagNum: Integer; out QtdBytes: Integer;
      out Pagina: OleVariant): WideString; safecall;
    function LogIn(const Usuario, Senha: WideString;
      out ConnectionID: Integer): WideString; safecall;
    function AbreRelatorio(const Usuario: WideString; const Senha: WideString;
                           ConnectionID: Integer; const FullPath: WideString;
                           out QtdPaginas: Integer; out StrCampos: WideString; out Rel64: Byte;
                           out Rel133: Byte; out CmprBrncs: Byte): Integer; safecall;
  Public
    { Public declarations }
    Function VerificaSeguranca(NomeRel, Usuario : String; Var Rel133CC, CmprBrncs : Boolean;
                               Var ArrRegIndice : TgRegIndice) : Boolean;

    Procedure CriarAliasDatabaseLocal;
    Procedure CriarAliasEventos;

    Procedure InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : String;
                                Grupo, SubGrupo, CodMens : Integer);
  End;

Implementation

Uses MultiColdServerUnit1, Variants;

{$R *.DFM}

Procedure LogaLocal(Const Mens : String);
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

Class Procedure TMultiColdDataServer.UpdateRegistry(Register: Boolean; Const ClassID, ProgID: String);
Begin
try
  If Register Then
  Begin
    Inherited UpdateRegistry(Register, ClassID, ProgID);
//    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  End Else
  Begin
//    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    Inherited UpdateRegistry(Register, ClassID, ProgID);
  End;
except
  on e:exception do
    logaLocal('TMultiColdDataServer.UpdateRegistry '+e.Message);
end;
End;

Procedure TMultiColdDataServer.CriarAliasDatabaseLocal;
//Var
//  MyList: TStringList;
//  ArqCnfg : System.Text;
//  Tipo,
//  Confs : String;
Begin
try
except
  on e:exception do
    logaLocal('TMultiColdDataServer.CriarAliasDatabaseLocal '+e.Message);
end;
//Try
//  Session1.DeleteAlias('MSSQLMultiCold');
//Except
//  End;
//AssignFile(ArqCNFG,ExtractFilePath(ParamStr(0))+'DatabaseLocal.cnfg');
//Reset(ArqCNFG);
//ReadLn(ArqCNFG,Tipo);
//MyList := TStringList.Create;
//Try
//  With MyList Do
//    While Not Eof(ArqCNFG) Do
//      Begin
//      ReadLn(ArqCNFG,Confs);
//      If Pos('USER NAME',Confs) <> 0 Then
//        LogInInfoLocal[1] := Copy(Confs,11,Length(Confs)-10);
//      If Pos('PASSWORD',Confs) <> 0 Then
//        LogInInfoLocal[2] := Copy(Confs,10,Length(Confs)-9);
//      Add(Confs);
//      End;
//  //Try
//  //  Session1.AddAlias('MSSQLMultiCold', Tipo, MyList);
//  //Except
//  //  End;
//Finally
//  MyList.Free;
//  CloseFile(ArqCNFG);
//  End; //Try
//DataBaseLocal.AliasName := 'MSSQLMultiCold';
End;

Procedure TMultiColdDataServer.CriarAliasEventos;
//Var
//  MyList: TStringList;
//  ArqCnfg : System.Text;
//  Tipo,
//  Confs : String;
Begin
try
except
  on e:exception do
    logaLocal('TMultiColdDataServer.CriarAliasEventos '+e.Message);
end;
//Try
//  Session1.DeleteAlias('MSSQLMultiColdEventos');
//Except
//  End;
//AssignFile(ArqCNFG,ExtractFilePath(ParamStr(0))+'DatabaseEventos.cnfg');
//Reset(ArqCNFG);
//ReadLn(ArqCNFG,Tipo);
//MyList := TStringList.Create;
//Try
//  With MyList Do
//    While Not Eof(ArqCNFG) Do
//      Begin
//      ReadLn(ArqCNFG,Confs);
//      If Pos('USER NAME',Confs) <> 0 Then
//        LogInInfoEventos[1] := Copy(Confs,11,Length(Confs)-10);
//      If Pos('PASSWORD',Confs) <> 0 Then
//        LogInInfoEventos[2] := Copy(Confs,10,Length(Confs)-9);
//      Add(Confs);
//      End;
//  //Try
//  //  Session1.AddAlias('MSSQLMultiColdEventos', Tipo, MyList);
//  //Except
//  //  End;
//Finally
//  MyList.Free;
//  CloseFile(ArqCNFG);
//  End; //Try
//DataBaseEventos.AliasName := 'MSSQLMultiColdEventos';
End;

Procedure TMultiColdDataServer.InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : String;
                                                 Grupo, SubGrupo, CodMens : Integer);
Var
  Agora : TDateTime;
Begin
try
  DatabaseEventos.Connected := True;
  If DatabaseEventos.InTransaction Then
    //DatabaseEventos.Commit;
    DatabaseEventos.CommitTrans;
  //DatabaseEventos.StartTransaction;
  DatabaseEventos.BeginTrans;
  Agora := Now;
  IBEventosQuery1.Close;
  IBEventosQuery1.Sql.Clear;
  IBEventosQuery1.Sql.Add('INSERT INTO EVENTOS_VISU VALUES (:a, :b, :c, :d, :e, :f, :g, :h, :i, :j)');
  IBEventosQuery1.Parameters[0].Value := Agora;
  IBEventosQuery1.Parameters[1].Value := Agora;
  IBEventosQuery1.Parameters[2].Value := Arquivo;
  IBEventosQuery1.Parameters[3].Value := Diretorio;
  IBEventosQuery1.Parameters[4].Value := CodRel;
  IBEventosQuery1.Parameters[5].Value := Grupo;
  IBEventosQuery1.Parameters[6].Value := SubGrupo;
  IBEventosQuery1.Parameters[7].Value := CodUsuario;
  IBEventosQuery1.Parameters[8].Value := NomeGrupoUsuario;
  IBEventosQuery1.Parameters[9].Value := CodMens;
  Try
    IBEventosQuery1.ExecSql;
    //DatabaseEventos.Commit;
    DatabaseEventos.CommitTrans;
  Except
    on e:exception do
      logaLocal('TMultiColdDataServer.InsereEventosVisu '+e.Message);
  End; // Try
  DatabaseEventos.Connected := False;
except
  on e:exception do
    logaLocal('TMultiColdDataServer.InsereEventosVisu '+e.Message);
end;
End;

Function TMultiColdDataServer.VerificaSeguranca(NomeRel, Usuario : String; Var Rel133CC, CmprBrncs : Boolean;
                                                Var ArrRegIndice : TgRegIndice) : Boolean;
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
  IBQuery1.Close;
  IBQuery1.Sql.Clear;
  IBQuery1.Sql.Add('SELECT * FROM DFN A');
  IBQuery1.Sql.Add('ORDER BY A.CODREL ');
  Try
    IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  While Not IBQuery1.Eof Do
    IBQuery1.Next;   // Estabelecer o recordcount correto

  SetLength(ArDFN, IBQuery1.RecordCount);
  IBQuery1.Close;
  IBQuery1.Open;
  I := 0;
  While Not IBQuery1.Eof Do
    Begin
    ArDFN[I].CodRel := IBQuery1.FieldByName('CodRel').AsString;
    ArDFN[I].CodSis := IBQuery1.FieldByName('CodSis').AsInteger;
    ArDFN[I].CodGrupo := IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArDFN[I].CodSubGrupo := IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArDFN[I].GrupoAuto := (IBQuery1.FieldByName('CodGrupAuto').AsString = 'T') Or
                          (IBQuery1.FieldByName('SubDirAuto').AsString = 'T');
    Inc(I);
    IBQuery1.Next;
    End;

  Try
    IBQuery1.Close;
    IBQuery1.Sql.Clear;
    IBQuery1.Sql.Add('SELECT * FROM USUREL A');
    IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
    IBQuery1.Sql.Add('      (A.TIPO = ''INC'') ');
    IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not IBQuery1.Eof Do
    IBQuery1.Next;   // Estabelecer o recordcount correto

  SetLength(ArINC, IBQuery1.RecordCount);

  IBQuery1.Close;
  IBQuery1.Open;
  I := 0;
  While Not IBQuery1.Eof Do
    Begin
    ArINC[I].CodUsu := IBQuery1.FieldByName('CodUsuario').AsString;
    ArINC[I].CodSis := IBQuery1.FieldByName('CodSis').AsInteger;
    ArINC[I].CodGrupo := IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArINC[I].CodSubGrupo := IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArINC[I].CodRel := IBQuery1.FieldByName('CodRel').AsString;
    Inc(I);
    IBQuery1.Next;
    End;

  IBQuery1.Close;
  IBQuery1.Sql.Clear;
  IBQuery1.Sql.Add('SELECT * FROM USUREL A');
  IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
  IBQuery1.Sql.Add('      (A.TIPO = ''EXC'') ');
  Try
    IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not IBQuery1.Eof Do
    IBQuery1.Next;   // Estabelecer o recordcount correto

  SetLength(ArEXC, IBQuery1.RecordCount);

  IBQuery1.Close;
  IBQuery1.Open;
  I := 0;
  While Not IBQuery1.Eof Do
    Begin
    ArEXC[I].CodUsu := IBQuery1.FieldByName('CodUsuario').AsString;
    ArEXC[I].CodSis := IBQuery1.FieldByName('CodSis').AsInteger;
    ArEXC[I].CodGrupo := IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArEXC[I].CodSubGrupo := IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArEXC[I].CodRel := IBQuery1.FieldByName('CodRel').AsString;
    Inc(I);
    IBQuery1.Next;
    End;

  IBQuery1.Close;
  IBQuery1.Sql.Clear;
  IBQuery1.Sql.Add('SELECT * FROM SISTEMA A');
  Try
    IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not IBQuery1.Eof Do
    IBQuery1.Next;   // Estabelecer o recordcount correto

  SetLength(ArSis, IBQuery1.RecordCount);

  IBQuery1.Close;
  IBQuery1.Open;
  I := 0;
  While Not IBQuery1.Eof Do
    Begin
    ArSis[I].CodSis := IBQuery1.FieldByName('CodSis').AsInteger;
    ArSis[I].NomeSis := IBQuery1.FieldByName('NomeSis').AsString;
    Inc(I);
    IBQuery1.Next;
    End;

  IBQuery1.Close;
  IBQuery1.Sql.Clear;
  IBQuery1.Sql.Add('SELECT * FROM GRUPOSDFN A');
  Try
    IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not IBQuery1.Eof Do
    IBQuery1.Next;   // Estabelecer o recordcount correto

  SetLength(ArGrupo, IBQuery1.RecordCount);

  IBQuery1.Close;
  IBQuery1.Open;
  I := 0;
  While Not IBQuery1.Eof Do
    Begin
    ArGrupo[I].CodSis := IBQuery1.FieldByName('CodSis').AsInteger;
    ArGrupo[I].CodGrupo := IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArGrupo[I].NomeGrupo := IBQuery1.FieldByName('NomeGrupo').AsString;
    Inc(I);
    IBQuery1.Next;
    End;

  IBQuery1.Close;
  IBQuery1.Sql.Clear;
  IBQuery1.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
  Try
    IBQuery1.Open;
  Except
    on e:exception do
      begin
      logaLocal('CarregaDadosDfnIncExc '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  While Not IBQuery1.Eof Do
    IBQuery1.Next;   // Estabelecer o recordcount correto

  SetLength(ArSubGrupo, IBQuery1.RecordCount);

  IBQuery1.Close;
  IBQuery1.Open;
  I := 0;
  While Not IBQuery1.Eof Do
    Begin
    ArSubGrupo[I].CodSis := IBQuery1.FieldByName('CodSis').AsInteger;
    ArSubGrupo[I].CodGrupo := IBQuery1.FieldByName('CodGrupo').AsInteger;
    ArSubGrupo[I].CodSubGrupo := IBQuery1.FieldByName('CodSubGrupo').AsInteger;
    ArSubGrupo[I].NomeSubGrupo := IBQuery1.FieldByName('NomeSubGrupo').AsString;
    Inc(I);
    IBQuery1.Next;
    End;

  IBQuery1.Close;
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
      IBQuery1.Close;
      IBQuery1.Sql.Clear;
      IBQuery1.Sql.Add('SELECT * FROM USUARIOS A, USUARIOSEGRUPOS B');
      IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') ');
      IBQuery1.Sql.Add('AND (A.CODUSUARIO = B.CODUSUARIO) ');
      Try
        IBQuery1.Open;
      Except
        on e:exception do
          begin
          logaLocal('TMultiColdDataServer.VerificaSeguranca '+e.Message);
          Result := False;
          Exit;
          end;
        End; //Try

      CodRel := UpperCase(RegDFN.CodRel); // Código do relatório em questão
      CodGrupo := IBQuery1.FieldByName('NomeGrupoUsuario').AsString;

      If CodGrupo = 'ADMSIS' Then
        Begin
        IBQuery1.Close;   // Usuario admsis pode ver tudo
        InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                          UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        Exit;
        End;

      IBQuery1.Close;

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
    logaLocal('TMultiColdDataServer.VerificaSeguranca '+e.Message);
end;
End;

function TMultiColdDataServer.GetRelatorio(const Usuario,
  Senha: WideString; ConnectionID: Integer; const ListaCodRel: WideString;
  var FullPaths: WideString): WideString;
Var
  OutroPath,
  CmplPath : String;
  SearchRec : TSearchRec;
  ListBox1,
  ListBox2,
  FullPathsTemp : TStringList;

  Function PegaInfo(Path : String) : String;
  Var
    Arq64 : File Of Int64;
    OldFileMode : Byte;
  Begin
  try
    OldFileMode := FileMode;
    FileMode := 0;
    Result := ExtractFileName(Path);
    If FileExists(ChangeFileExt(Path,'.IAPX')) Then
      Begin
      AssignFile(Arq64,ChangeFileExt(Path,'.IAPX'));
      Reset(Arq64);
      Result := Result + ' -> ' + Format('%7d',[Filesize(Arq64)]) + ' Pgns';
      CloseFile(Arq64);
      End;
    FileMode := OldFileMode;
  except
    on e:exception do
      logaLocal('PegaInfo '+e.Message);
  end;
  End;

Begin
MultiColdServerForm.Memo1.Lines.Add('Requisição de Lista de Relatórios, Usuario = '+Usuario);
try
  Result := '';
  ListBox1 := TStringList.Create;
  ListBox2 := TStringList.Create;
  FullPathsTemp := TStringList.Create;
  ListBox1.Text := ListaCodRel;
  If ListBox1.Count = 0 Then
    Begin
    ListBox1.Free;
    ListBox2.Free;
    FullPathsTemp.Free;
    FullPaths := '';
    Exit;
    End
  Else
    Begin
    ListBox2.Clear;
    IBQuery1.Close;
    IBQuery1.Sql.Clear;
    IBQuery1.Sql.Add('SELECT * FROM DESTINOSDFN A ');
    IBQuery1.Sql.Add('WHERE A.CODREL = '''+ListBox1[0]+'''');
    IBQuery1.Sql.Add('AND A.TIPODESTINO = ''Dir''');
    IBQuery1.Sql.Add('AND A.SEGURANCA = ''S''');
    try
      IBQuery1.Open;
    except
      on e:exception do
        logaLocal('TMultiColdDataServer.GetRelatorio '+e.Message);
    end;
    If IBQuery1.RecordCount <> 0 Then
      Begin
      If UpperCase(IBQuery1.FieldByName('DirExpl').AsString) = 'S' Then
        CmplPath := '\'
      Else
        CmplPath := FullPaths;
      FullPaths := '';
      OutroPath := IncludeTrailingPathDelimiter(UpperCase(IBQuery1.FieldByName('Destino').AsString)) + CmplPath;
      If FindFirst(OutroPath+'*.DAT',faAnyFile,SearchRec) = 0 Then
        Repeat
          FullPathsTemp.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+
                        OutroPath+SearchRec.Name); // Armazena o nome do arquivo (FullPath)
          ListBox2.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+' '+
                             PegaInfo(OutroPath+SearchRec.Name));
        Until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
      End;
    IBQuery1.Close;
    End;
  ListBox1.Free;
  Result := ListBox2.Text;
  ListBox2.Free;
  FullPaths := FullPathsTemp.Text;
  FullPathsTemp.Free;
  If FullPaths = '' Then
    MultiColdServerForm.Memo1.Lines.Add('Nenhum relatório encontrado...')
  Else
    MultiColdServerForm.Memo1.Lines.Add('Lista de Relatórios servida com sucesso...');
  MultiColdServerForm.Memo1.Lines.Add('');
except
  on e:exception do
    logaLocal('TMultiColdDataServer.GetRelatorio '+e.Message);
end;
End;

function TMultiColdDataServer.GetPagina(const Usuario, Senha: WideString;
  ConnectionID: Integer; const Relatorio: WideString; PagNum: Integer;
  out QtdBytes: Integer; out Pagina: OleVariant): WideString;
Var
  Arq : File;
  I,
  ContBytes : Integer;
  Pag64,
  NextPag64 : Int64;
  ArqPag64 : File Of Int64;
  ArrBuf : ^TgArr20000;
  V : Variant;

Begin
MultiColdServerForm.Memo1.Lines.Add('GetPagina - N. '+IntToStr(PagNum)+', Usuario = '+Usuario);
MultiColdServerForm.Memo1.Lines.Add(Relatorio);
Result := '';
AssignFile(Arq,Relatorio);
Try
  Reset(Arq,1);
Except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.GetPagina '+e.Message);
    MultiColdServerForm.Memo1.Lines.Add('Erro de abertura, '+Relatorio);
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
      logaLocal('TMultiColdDataServer.GetPagina '+e.Message);
      MultiColdServerForm.Memo1.Lines.Add('Erro de abertura IAPX, '+Relatorio);
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

V := VarArrayCreate([1,ContBytes],varByte);
For I := 1 To ContBytes Do
  V[I] := Byte(ArrBuf^[I]);

QtdBytes := ContBytes;
Pagina := V;
Result := '0';

Dispose(ArrBuf);
MultiColdServerForm.Memo1.Lines.Add('GetPagina concluida com sucesso');
MultiColdServerForm.Memo1.Lines.Add('');
End;

Function TMultiColdDataServer.LogIn(Const Usuario, Senha: WideString;
  out ConnectionID: Integer): WideString;
Var
  AuxQtd : Integer;
  Resulta : String;
Begin
Result := '';
Resulta := '';
MultiColdServerForm.Memo1.Lines.Add('Requisição de LogIn, Usuario = '+Usuario);

Try
  DatabaseLocal.Open;
Except
  On E: Exception Do
    Begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    ConnectionID := 0;
    Result := 'Erro de conexão ao banco de dados: '+DatabaseLocal.DefaultDatabase + ' Erro: ' + E.Message;
    MultiColdServerForm.Memo1.Lines.Add(Result);
    Exit;
    End;
  End;

IBQuery1.Sql.Clear;                        // efetuar conexões remotas
IBQuery1.Sql.Add('SELECT * FROM USUARIOS A');
IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') ');
If Senha = '' Then
  IBQuery1.Sql.Add('AND   (A.SENHA IS NULL) ')
Else
  IBQuery1.Sql.Add('AND   (A.SENHA = '''+Senha+''') ');
IBQuery1.Sql.Add('AND   (A.REMOTO = ''S'') ');

try
  IBQuery1.Open;
except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    ConnectionID := 0;
    IBQuery1.Close;
    MultiColdServerForm.Memo1.Lines.Add('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado');
    Result := 'LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado';
    Exit;
    end;
end;

If IBQuery1.RecordCount = 0 Then
  Begin
  ConnectionID := 0;
  IBQuery1.Close;
  MultiColdServerForm.Memo1.Lines.Add('LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado');
  Result := 'LogIn negado, Usuario '+Usuario+' não cadastrado ou não autorizado';
  Exit;
  End;

IBQuery1.Close;

// Inicio da carga das informações...

IBQuery1.Sql.Clear;
IBQuery1.Sql.Add('SELECT * FROM DFN A');
IBQuery1.Sql.Add('ORDER BY A.CODREL ');
Try
  IBQuery1.Open;
Except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    MultiColdServerForm.Memo1.Lines.Add('Erro ao tentar carregar dados de DFN ' + Usuario);
    Result := 'Erro ao tentar carregar dados de DFN ' + Usuario;
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

While Not IBQuery1.Eof Do
  IBQuery1.Next;   // Estabelecer o recordcount correto

Resulta := Resulta + IntToStr(IBQuery1.RecordCount) + CrLf; // Quantidade de DFNs

IBQuery1.Close;
IBQuery1.Open;
While Not IBQuery1.Eof Do
  Begin
  Resulta := Resulta + IBQuery1.FieldByName('CodRel').AsString + CrLf +
                     IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                     IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf;
  If (IBQuery1.FieldByName('CodGrupAuto').AsString = 'T') Or (IBQuery1.FieldByName('SubDirAuto').AsString = 'T') Then
    Resulta := Resulta + 'T' + CrLf
  Else
    Resulta := Resulta + 'F' + CrLf;
  IBQuery1.Next;
  End;

IBQuery1.Close;
IBQuery1.Sql.Clear;
IBQuery1.Sql.Add('SELECT * FROM USUREL A');
IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
IBQuery1.Sql.Add('      (A.TIPO = ''INC'') ');
Try
  IBQuery1.Open;
Except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    MultiColdServerForm.Memo1.Lines.Add('Erro ao tentar carregar dados de USUREL INC '+Usuario);
    Result := 'Erro ao tentar carregar dados de USUREL INC ' + Usuario;
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

If IBQuery1.RecordCount = 0 Then
  Begin
  ConnectionID := 0;
  IBQuery1.Close;
  MultiColdServerForm.Memo1.Lines.Add('LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados');
  Result := 'LogIn aceito, porém o Usuario '+Usuario+' não possui relatórios cadastrados';
  Exit;
  End;

While Not IBQuery1.Eof Do
  IBQuery1.Next;   // Estabelecer o recordcount correto

Resulta := Resulta + IntToStr(IBQuery1.RecordCount) + CrLf; // Quantidade de INCs

IBQuery1.Close;
IBQuery1.Open;
While Not IBQuery1.Eof Do
  Begin
  Resulta := Resulta + IBQuery1.FieldByName('CodUsuario').AsString + CrLf +
                     IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                     IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                     IBQuery1.FieldByName('CodRel').AsString + CrLf;
  IBQuery1.Next;
  End;

IBQuery1.Close;
IBQuery1.Sql.Clear;
IBQuery1.Sql.Add('SELECT * FROM USUREL A');
IBQuery1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(Usuario)+''') AND ');
IBQuery1.Sql.Add('      (A.TIPO = ''EXC'') ');
Try
  IBQuery1.Open;
Except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    MultiColdServerForm.Memo1.Lines.Add('Erro ao tentar carregar dados de USUREL EXC '+Usuario);
    ConnectionID := 0;
    Result := 'Erro ao tentar carregar dados de USUREL EXC '+Usuario;
    Exit;
    end;
  End; // Try

While Not IBQuery1.Eof Do
  IBQuery1.Next;   // Estabelecer o recordcount correto

Resulta := Resulta + IntToStr(IBQuery1.RecordCount) + CrLf; // Quantidade de EXCs

IBQuery1.Close;
IBQuery1.Open;
While Not IBQuery1.Eof Do
  Begin
  Resulta := Resulta + IBQuery1.FieldByName('CodUsuario').AsString + CrLf +
                     IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                     IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                     IBQuery1.FieldByName('CodRel').AsString + CrLf;
  IBQuery1.Next;
  End;

IBQuery1.Close;
IBQuery1.Sql.Clear;
IBQuery1.Sql.Add('SELECT * FROM SISTEMA A');
Try
  IBQuery1.Open;
Except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    Result := 'Erro ao tentar carregar dados de SISTEMA para ' + Usuario;
    MultiColdServerForm.Memo1.Lines.Add(Result);
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

While Not IBQuery1.Eof Do
  IBQuery1.Next;   // Estabelecer o recordcount correto

Resulta := Resulta + IntToStr(IBQuery1.RecordCount) + CrLf; // Quantidade de Grupos

IBQuery1.Close;
IBQuery1.Open;
While Not IBQuery1.Eof Do
  Begin
  Resulta := Resulta + IBQuery1.FieldByName('CodSis').AsString + CrLf +
                     IBQuery1.FieldByName('NomeSis').AsString + CrLf;
  IBQuery1.Next;
  End;

IBQuery1.Close;
IBQuery1.Sql.Clear;
IBQuery1.Sql.Add('SELECT * FROM GRUPOSDFN A');
Try
  IBQuery1.Open;
Except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    Result := 'Erro ao tentar carregar dados de GRUPO para ' + Usuario;
    MultiColdServerForm.Memo1.Lines.Add(Result);
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

While Not IBQuery1.Eof Do
  IBQuery1.Next;   // Estabelecer o recordcount correto

Resulta := Resulta + IntToStr(IBQuery1.RecordCount) + CrLf; // Quantidade de Grupos

IBQuery1.Close;
IBQuery1.Open;
While Not IBQuery1.Eof Do
  Begin
  Resulta := Resulta + IBQuery1.FieldByName('CodSis').AsString + CrLf +
                       IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                       IBQuery1.FieldByName('NomeGrupo').AsString + CrLf;
  IBQuery1.Next;
  End;

IBQuery1.Close;
IBQuery1.Sql.Clear;
IBQuery1.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
Try
  IBQuery1.Open;
Except
  on e:exception do
    begin
    logaLocal('TMultiColdDataServer.LogIn '+e.Message);
    MultiColdServerForm.Memo1.Lines.Add('Erro ao tentar carregar dados de SUBGRUPO para '+Usuario);
    ConnectionID := 0;
    Exit;
    end;
  End; // Try

While Not IBQuery1.Eof Do
  IBQuery1.Next;   // Estabelecer o recordcount correto

Resulta := Resulta + IntToStr(IBQuery1.RecordCount) + CrLf; // Quantidade de SubGrupos
AuxQtd := IBQuery1.RecordCount;

IBQuery1.Close;
IBQuery1.Open;
While Not IBQuery1.Eof Do
  Begin
  If AuxQtd = 1 Then
    Resulta := Resulta + IBQuery1.FieldByName('CodSis').AsString + CrLf +
                       IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                       IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                       IBQuery1.FieldByName('NomeSubGrupo').AsString      // O último não tem CrLf
  Else
    Resulta := Resulta + IBQuery1.FieldByName('CodSis').AsString + CrLf +
                       IBQuery1.FieldByName('CodGrupo').AsString + CrLf +
                       IBQuery1.FieldByName('CodSubGrupo').AsString + CrLf +
                       IBQuery1.FieldByName('NomeSubGrupo').AsString + CrLf;
  IBQuery1.Next;
  Dec(AuxQtd);
  End;

IBQuery1.Close;

// Fim da carga de informações...

ConnectionID := 1;
MultiColdServerForm.Memo1.Lines.Add('LogIn realizado com sucesso. ConnectionID = '+IntToStr(ConnectionID) +
                                    ' Config = '+IntToStr(Length(Resulta)));
MultiColdServerForm.Memo1.Lines.Add('');
Result := Resulta;

IBQuery1.Close;
DatabaseLocal.Close;

End;

function TMultiColdDataServer.AbreRelatorio;
Var
  Arq : File;
  I : Integer;
  ArqPag64 : File Of Int64;
  ArrRegIndice : TgRegIndice;
  StrAux : String;

Begin
Result := 99999; // Código para o erro não detectado
try
  MultiColdServerForm.Memo1.Lines.Add('Requisição de abertura de relatório, Usuario = '+Usuario+', Arquivo = '+FullPath);
  MultiColdServerForm.Memo1.Lines.Add('Verificando segurança ');
  If Not VerificaSeguranca(FullPath, Usuario, Boolean(Rel133), Boolean(CmprBrncs), ArrRegIndice) Then
    Begin
    MultiColdServerForm.Memo1.Lines.Add('Acesso ao relatório negado '+FullPath);
    Result := 1;
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
    MultiColdServerForm.Memo1.Lines.Add('Relatório não pode ser aberto: '+FullPath+' Falha '+IntToStr(I));
    Result := 2;
    Exit;
    End;
  If (Filesize(Arq) = 0) Then
    Begin
    MultiColdServerForm.Memo1.Lines.Add('Relatório não pode ser aberto: '+FullPath+' Arquivo Vazio');
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
    MultiColdServerForm.Memo1.Lines.Add('Índice de página não pode ser aberto 2');
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
  MultiColdServerForm.Memo1.Lines.Add('Relatório '+FullPath+' aberto com sucesso');
  MultiColdServerForm.Memo1.Lines.Add('');
except
  on e:exception do
    logaLocal('TMultiColdDataServer.AbreRelatorio '+e.Message);
end;
End;

Procedure TMultiColdDataServer.Session1Startup(Sender: TObject);
//Var
//  Posic : Integer;
//  DirAux : String;
Begin
Exit;
//MultiColdServerForm.Memo1.Lines.Add('Iniciada nova sessão no MultiCold Server '+Session1.SessionName);
//Posic := Pos('ORIGEM\DATABASE\', UpperCase(DirDatabase));
//If Posic <> 0 Then
//  DirAux := Copy(DirDatabase,1,Posic-1)
//Else
//  DirAux := ColetaDiretorioTemporario;
//DirAux := IncludeTrailingPathDelimiter(DirAux);
// Windows XP pediu um tratamento em separado. Fiz de forma a funcionar nos demais, 95, 98, Me, Nt, 2000
//ForceDirectories(DirAux+'NetFileDir');
//Session1.NetFileDir := DirAux+'NetFileDir';
//ForceDirectories(DirAux+'PrivateDir\'+Session1.SessionName);
//Session1.PrivateDir := DirAux+'PrivateDir\'+Session1.SessionName;
//MultiColdServerForm.Memo1.Lines.Add('DirBase '+DirAux);
//MultiColdServerForm.Memo1.Lines.Add('NetFileDir '+Session1.NetFileDir);
//MultiColdServerForm.Memo1.Lines.Add('PrivateDir '+Session1.PrivateDir);
End;

Procedure TMultiColdDataServer.RemoteDataModuleCreate(Sender: TObject);
Begin
try
  logaLocal('TMultiColdDataServer.RemoteDataModuleCreate Início');
except
  on e:exception do
    logaLocal('TMultiColdDataServer.RemoteDataModuleCreate '+e.Message);
end;
//CriarAliasDatabaseLocal;
//CriarAliasEventos;
End;

Procedure TMultiColdDataServer.DatabaseLocalLogin(Database: TDatabase;
  LoginParams: TStrings);
Begin
//LoginParams.Values['USER NAME'] := LogInInfoLocal[1];
//LoginParams.Values['PASSWORD'] := LogInInfoLocal[2];
End;

Procedure TMultiColdDataServer.DatabaseEventosLogin(Database: TDatabase;
  LoginParams: TStrings);
Begin
//LoginParams.Values['USER NAME'] := LogInInfoEventos[1];
//LoginParams.Values['PASSWORD'] := LogInInfoEventos[2];
End;

Initialization
  TComponentFactory.Create(ComServer, TMultiColdDataServer,
    Class_MultiColdDataServer, ciMultiInstance, tmApartment);

End.
