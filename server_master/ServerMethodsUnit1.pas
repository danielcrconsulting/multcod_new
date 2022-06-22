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
  Bde.DBTables, dm, UclsAux, UMulticoldReport, Windows, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef;

type
  TPesquisa = Record
             Campo : Char;
             Pagina : Integer;
             Relativo : Integer;
             Linha : Integer;
  end;

  TServerMethods1 = class(TDSServerModule)
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDQry: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQryE: TFDQuery;
    Query1: TQuery;
    Query2: TQuery;
    Database1: TDatabase;
    Session1: TSession;
    FDConLog: TFDConnection;
    FDCon: TFDConnection;
    procedure DSServerModuleDestroy(Sender: TObject);
    procedure DSServerModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Fmemo : TStringList;
    dataModule : TDataModule1;
    procedure ConectarBanco(bd : integer = 0);
    procedure DesconectarBanco;
    function RetornaRegistros(query:String): String;
    function ConverterArquivoParaJSON(pDirArquivo : string) : TJSONArray;
    function RetornarCaminhoArq : String;
    procedure Comprimir(ArquivoCompacto: TFileName; Arquivos: array of TFileName);
    Procedure LogaLocal(Const Mens : String);
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function RetornarParametrosConn(var servidor : String; var driverservidor: String;
                                    var porta : String ; var banco : String;
                                    var usuario : String ; var senha : String;
                                    var NomeEstacao : String ) : Boolean;
    function RetornarParametroAD : String;
    procedure GravarLOGAD(usuario,status : String);
    function RetornarDadosBanco(SQL : String ; bd : Integer = 0) : String;
    procedure PersistirBanco(SQL : String; bd : Integer = 0);
    function BaixarArquivo( arq : String) : TJSONArray;
    procedure fazerumteste;
    procedure LimpaMemoria;
    function ValidarAD(pUsuario, pSenha: String): Boolean;

  end;

implementation


{$R *.dfm}


uses System.StrUtils;

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
  senha, NomeEstacao, caminhoMaster, caminhoLog : String;
  iniF : TIniFile;
begin

  iniF := TIniFile.Create(GetCurrentDir + 'conf.ini');
  caminhoMaster := iniF.ReadString('BANCO','MASTER','');
  caminhoLog := iniF.ReadString('BANCO','LOG','');

  FDCon.Params.Database    := caminhoMaster;
  FDConLog.Params.Database := caminhoLog;
  if bd = 0 then
    FdCon.Open
  else
    FDConLog.Open;
end;

function TServerMethods1.ConverterArquivoParaJSON(
  pDirArquivo: string): TJSONArray;
var
  sBytesArquivo, sNomeArquivo: AnsiString;
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


procedure TServerMethods1.PersistirBanco(SQL : String ; bd : Integer = 0);
begin
  try
    try
      ConectarBanco(bd);
      FdQry.SQL.Text := SQL;
      //FdQry.SQL.SaveToFile('c:\rom\sql.sql');
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
      //Passa o Dominio, usu�rio e senha do LDAP na string de conex�o...
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

procedure TServerMethods1.GravarLOGAD(usuario,status : String);
var arqIni : TiniFile;
    caminho, data : String;
    strarq : TStringList;
begin
  data := FormatDateTime('YYYYMMDD', now);
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  caminho        := arqIni.ReadString('AD', 'log',    '');
  strarq := TStringList.Create;
  if FileExists(caminho + '_' + data + '.csv') then
  begin
    strarq.LoadFromFile(caminho + '_' + data + '.csv');
  end;
  strarq.Add(FormatDateTime('YYYYMMDDhhnnss', now)+';'+usuario+';'+status);
  strarq.SaveToFile(caminho + '_' + data + '.csv');
  FreeAndNil(strarq);
end;

function TServerMethods1.RetornarCaminhoArq : String;
var arqIni : TiniFile;
begin
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  result         := arqIni.ReadString('configuracoes', 'caminho',    '');
end;

end.

