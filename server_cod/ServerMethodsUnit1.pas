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
  System.Zip, System.Variants, SutypGer, Subrug, SuTypMultiCold;

type
  TServerMethods1 = class(TDSServerModule)
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDCon: TFDConnection;
    FDQry: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDConE: TFDConnection;
    FDQryE: TFDQuery;
    procedure DSServerModuleDestroy(Sender: TObject);
    procedure DSServerModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Fmemo : TStringList;
    procedure ConectarBanco;
    procedure DesconectarBanco;
    procedure ConectarBanco_eve;
    procedure DesconectarBanco_eve;
    function RetornaRegistros(query:String): String;
    function ConverterArquivoParaJSON(pDirArquivo : string) : TJSONArray;
    function RetornarCaminhoArq : String;
    procedure Comprimir(ArquivoCompacto: TFileName; Arquivos: array of TFileName);
    Procedure LogaLocal(Const Mens : String);
    Function VerificaSeguranca(NomeRel, Usuario : String; Var Rel133CC, CmprBrncs : Boolean;
                               Var ArrRegIndice : TgRegIndice) : Boolean;
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function RetornarParametrosConn(var servidor : String; var driverservidor: String;
                                    var porta : String ; var banco : String;
                                    var usuario : String ; var senha : String;
                                    var NomeEstacao : String ) : Boolean;
    function RetornarDadosBanco(SQL : String) : String;
    procedure PersistirBanco(SQL : String);
    function BaixarArquivo( arq : String) : TJSONArray;
    function AbreRelatorio(Usuario: WideString; Senha: WideString;
                           ConnectionID: Integer; FullPath: WideString;
                           QtdPaginas: Integer; StrCampos: WideString; Rel64: Byte;
                           Rel133: Byte; CmprBrncs: Byte): String;
    Procedure InsereEventosVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : String;
                                Grupo, SubGrupo, CodMens : Integer);
    procedure fazerumteste;
    function GetPagina(Usuario, Senha: WideString; ConnectionID: Integer;
       Relatorio: WideString; PagNum: Integer; QtdBytes: Integer; Pagina : WideString) : String;
    function LogIn(Usuario, Senha: WideString;
      ConnectionID: Integer): String;
    function GetRelatorio(Usuario, Senha: WideString;
                          ConnectionID: Integer; ListaCodRel: WideString;
                          FullPaths: WideString; tipo : Integer): String;

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
  exit;
  Agora := Now;
  ConectarBanco_eve;
  FDQryE.Close;
  FDQryE.Sql.Clear;
  FDQryE.Sql.Add('INSERT INTO EVENTOS_VISU VALUES (:a, :b, :c, :d, :e, :f, :g, :h, :i, :j)');
  FDQryE.Params[0].Value := Agora;
  FDQryE.Params[1].Value := Agora;
  FDQryE.Params[2].Value := Arquivo;
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
  StrCampos: WideString; Rel64, Rel133, CmprBrncs: Byte): String;
Var
  Arq : File;
  I : Integer;
  ArqPag64 : File Of Int64;
  ArrRegIndice : TgRegIndice;
  StrAux : String;

Begin
Result := '99999'; // C�digo para o erro n�o detectado
try
  Fmemo.Add('Requisi��o de abertura de relat�rio, Usuario = '+Usuario+', Arquivo = '+FullPath);
  Fmemo.Add('Verificando seguran�a ');
  If Not VerificaSeguranca(FullPath, Usuario, Boolean(Rel133), Boolean(CmprBrncs), ArrRegIndice) Then
    Begin
    Fmemo.Add('Acesso ao relat�rio negado '+FullPath);
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
    Fmemo.Add('Relat�rio n�o pode ser aberto: '+FullPath+' Falha '+IntToStr(I));
    Result := '2';
    Exit;
    End;
  If (Filesize(Arq) = 0) Then
    Begin
    Fmemo.Add('Relat�rio n�o pode ser aberto: '+FullPath+' Arquivo Vazio');
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
    Fmemo.Add('�ndice de p�gina n�o pode ser aberto 2');
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
  Fmemo.Add('Relat�rio '+FullPath+' aberto com sucesso');
  Fmemo.Add('');

  result := result + '|' + IntToStr(QtdPaginas);
  result := result + '|' + StrCampos;
  result := result + '|' + IntToStr(Rel64);
  result := result + '|' + IntToStr(Rel133);
  result := result + '|' + IntToStr(CmprBrncs);
except
  on e:exception do
    logaLocal('TMultiColdDataServer.AbreRelatorio '+e.Message);
end;
End;

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
    oArquivoJSON := ConverterArquivoParaJSON( RetornarCaminhoArq + 'arq.zip');
    DeleteFile(RetornarCaminhoArq + 'arq.zip');
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


procedure TServerMethods1.ConectarBanco;
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
  FdCon.Params.Values['Database'] := banco;
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
  sBytesArquivo, sNomeArquivo: string;
  oSSArquivoStream: TStringStream;
  iTamanhoArquivo, iCont: Integer;
begin
  try
    Result := TJSONArray.Create; // Instanciando o objeto JSON que conter� o arquivo serializado

    oSSArquivoStream := TStringStream.Create; // Instanciando o objeto stream que carregar� o arquivo para memoria
    oSSArquivoStream.LoadFromFile(pDirArquivo);  // Carregando o arquivo para memoria
    iTamanhoArquivo := oSSArquivoStream.Size; // pegando o tamanho do arquivo

    sBytesArquivo := '';

    // Fazendo um lan�o no arquivo que est� na memoria para pegar os bytes do mesmo
    for iCont := 0 to iTamanhoArquivo - 1 do
    begin
      // A medida que est� fazendo o la�o para pegar os bytes, os mesmos s�o jogados para
      // uma vari�vel do tipo string separado por ","
      sBytesArquivo := sBytesArquivo + IntToStr(oSSArquivoStream.Bytes[iCont]) + ', ';
    end;

    // Como � colocado uma v�rgula ap�s o byte, fica sempre sobrando uma v�gugula, que � deletada
    Delete(sBytesArquivo, Length(sBytesArquivo)-1, 2);

    // Adiciona a string que cont�m os bytes para o array JSON
    Result.Add(sBytesArquivo);

    // Adiciona para o array JSON o tamanho do arquivo
    Result.AddElement(TJSONNumber.Create(iTamanhoArquivo));

    // Extrai o nome do arquivo
	  sNomeArquivo := ExtractFileName(pDirArquivo);

    // Adiciona na terceira posi��o do array JSON o nome do arquivo
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
  Fmemo := TStringList.Create;
end;

procedure TServerMethods1.DSServerModuleDestroy(Sender: TObject);
begin
  DesconectarBanco;
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
logaLocal('GetPagina - N. '+IntToStr(PagNum)+', Usuario = '+Usuario);
logaLocal(Relatorio);
fileMode := fmShareDenyNone;
Result := '';
AssignFile(Arq,Relatorio);
Try
  Reset(Arq,1);
Except
  on e:exception do
    begin
    logaLocal('Erro de abertura do relat�rio:  '+Relatorio+#13#10+e.Message);
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
logaLocal(Pagina);
Retorno := '0' + '|' + Pagina;

//Result := '0';
Retorno := Retorno  + '|' + IntToStr(QtdBytes);

Dispose(ArrBuf);
logaLocal('GetPagina concluida com sucesso');
//LogaTempoExecucao('GetPagina',dtLog);
result := Retorno;
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
      logaLocal('Erro verificando dados de �ndice: '+e.Message);
  end;
  End;

Begin
//dtLog := now;
//logaLocal('Requisi��o de Lista de Relat�rios, Usuario = '+Usuario);
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
        logaLocal('Erro carregando dados de destino de relat�rios: '+e.Message);
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
      LogaLocal('Procurando relat�rios em: '+OutroPath);
      errorCode := FindFirst(OutroPath+'*.DAT',faAnyFile,SearchRec);
      If errorCode = 0 Then
        Repeat
          FullPathsTemp.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+
                            OutroPath+SearchRec.Name); // Armazena o nome do arquivo (FullPath)
          ListBox2.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+' '+
                       PegaInfo(OutroPath+SearchRec.Name));
          // Macaquinho para Daniel - 12/11/2007
          LogaLocal('Relat�rio encontrado '+OutroPath+SearchRec.Name);
        Until FindNext(SearchRec) <> 0
      else
        begin
        logaLocal('Relat�rio n�o encontrado. Motivo: '+IntToStr(ErrorCode));
        logaLocal('Motivo: '+SysErrorMessage(ErrorCode));
        GetLastError;
        end;
      FindClose(SearchRec);
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
    logaLocal('Erro carregando dados de relat�rio: '+e.Message);
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
logaLocal('Requisi��o de LogIn, Usuario = '+Usuario);
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
  LogaLocal('LogIn negado, Usuario '+Usuario+' n�o cadastrado ou n�o autorizado');
  Result := compressStringReturnHex('LogIn negado, Usuario '+Usuario+' n�o cadastrado ou n�o autorizado');
//  Result := (('LogIn negado, Usuario '+Usuario+' n�o cadastrado ou n�o autorizado'));
  result := result + '|' + IntToStr(ConnectionID);
  Exit;
  End;
FDQry.Close;

//LogaLocal('Aqui 1');

// Inicio da carga das informa��es...
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
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress N�O GOSTA!!!
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
    LogaLocal('Erro carregando permiss�es de acesso a relat�rios: '+e.Message);
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
  LogaLocal('LogIn aceito, por�m o Usuario '+Usuario+' n�o possui relat�rios cadastrados');
  Result := compressStringReturnHex('LogIn aceito, por�m o Usuario '+Usuario+' n�o possui relat�rios cadastrados');
//  Result := (('LogIn aceito, por�m o Usuario '+Usuario+' n�o possui relat�rios cadastrados'));
  result := result + '|' + IntToStr(ConnectionID);
  Exit;
  End;

AuxQTd := 0;
While Not FDQry.Eof Do
  begin
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress N�O GOSTA!!!
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
    LogaLocal('Erro carregando dados de nega��o de acesso a relat�rios: '+e.Message);
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
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress N�O GOSTA!!!
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
  FDQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress N�O GOSTA!!!
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
  FdQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress N�O GOSTA!!!
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
  FdQry.Next;   // Estabelecer o recordcount correto nesta query que o dbExpress N�O GOSTA!!!
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
  FdQry.Next;   // Estabelecer o recordcount correto nesta query que tem DISTINCT e o dbExpress N�O GOSTA!!!
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
                       FdQry.FieldByName('CodGrupo').AsString) // O �ltimo n�o tem CrLf
  Else
    Resulta := (Resulta + FdQry.FieldByName('CodRel').AsString + CrLf +
                       FdQry.FieldByName('CodSis').AsString + CrLf +
                       FdQry.FieldByName('CodGrupo').AsString + CrLf);
  FdQry.Next;
  Dec(AuxQtd);
  end;
FdQry.Close;

//LogaLocal('Aqui 11');

// Fim da carga de informa��es...
// Compress�o do retorno para reduzir o tempo de execu��o -> Deixou de funcionar com Delphi Xe4
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


procedure TServerMethods1.PersistirBanco(SQL : String);
begin
  try
    try
      ConectarBanco;
      FdQry.SQL.Text := SQL;
      FdQry.SQL.SaveToFile('c:\rom\sql.sql');
      //if not Assigned(StrParam) then
      //  FdQry.Params := StrParam;
      FdQry.ExecSQL;
    except
      on e:exception do
      begin
        raise Exception.Create('Erro na persist�ncia de Dados');
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

function TServerMethods1.VerificaSeguranca(NomeRel, Usuario: String;
  var Rel133CC, CmprBrncs: Boolean; var ArrRegIndice: TgRegIndice): Boolean;
Var
  PassouGrupoSubGrupoRel : Boolean;
  I,
  CodSisDFNAtu,    // Est� na DFN da base
  CodSisDFNOld,    // Est� na DFN do relat�rio
  CodGrupoDFNAtu,  // Est� na DFN da base
  CodGrupoDFNOld,  // Est� na DFN do relat�rio
  CodGrupoDFNGrp,  // Est� no arquivo GRP
  CodSubGrupoDFNAtu,  // Est� na DFN da base
  CodSubGrupoDFNOld : Integer; // Est� na DFN do relat�rio
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
  If FileExists(ChangeFileExt(NomeRel,'.IAPX')) Then // Novo formato, candidato a seguran�a
    Begin
    AssignFile(ArqCNFG,ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dfn.Dfn');
    OldFileMode := FileMode;
    FileMode := 0;
    Reset(ArqCNFG);
    FileMode := OldFileMode;
    Read(ArqCNFG,RegDestinoII); // L� o primeiro Destino, mas n�o checa a seguran�a por ele
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

    If Not TemRegGrp Then  // For�a que reggrp tenha sempre algum conte�do
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

      CodRel := UpperCase(RegDFN.CodRel); // C�digo do relat�rio em quest�o
      CodGrupo := FdQry.FieldByName('NomeGrupoUsuario').AsString;

      If CodGrupo = 'ADMSIS' Then
        Begin
        FdQry.Close;   // Usuario admsis pode ver tudo
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
        InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                          UpperCase(Usuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 02);
        Exit;
        End;

      CodSisDFNAtu := ArDFN[I].CodSis;    // Banco
      CodSisDFNOld := RegSistema.CODSIS;  // Rel (Pode ser -999 se � a vers�o interbase do relat�rio...
      CodGrupoDFNAtu := ArDFN[I].CodGrupo;
      CodSubGrupoDFNAtu := ArDFN[I].CodSubGrupo;
      CodGrupoDFNOld := RegDFN.CODGRUPO;
      CodSubGrupoDFNOld := RegDFN.CODSUBGRUPO;
      If RegDFN.CODGRUPAUTO Or (TemRegGrp And RegDFN.SUBDIRAUTO) Then
        CodGrupoDFNGrp := RegGRP.Grp
      Else
        CodGrupoDFNGrp := RegDFN.CODGRUPO;

      If Length(ArINC) = 0 Then // Nenhuma defini��o de Inclus�o para este usu�rio
          Result := False;

      PassouGrupoSubGrupoRel := False;

      For I := 0 To Length(ArINC) - 1 Do
        Begin
        If (ArINC[I].CodSis = -999) Or
           (ArINC[I].CodSis = CodSisDFNAtu) Or
           (ArINC[I].CodSis = CodSisDFNOld) Or
           (RegSistema.CODSIS = -999) Then  // Vers�o Interbase...
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
           (RegSistema.CODSIS = -999) Then // Vers�o Interbase...
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

function TServerMethods1.RetornarDadosBanco(SQL: String): String;
begin
  try
    try
      ConectarBanco;
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

function TServerMethods1.RetornarCaminhoArq : String;
var arqIni : TiniFile;
begin
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  result         := arqIni.ReadString('configuracoes', 'caminho',    '');
end;


end.

