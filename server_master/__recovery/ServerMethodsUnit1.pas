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
  FireDAC.Phys.FBDef, ZLibEx;



type
  TPesquisa = Record
             Campo : Char;
             Pagina : Integer;
             Relativo : Integer;
             Linha : Integer;
  end;

type
  TgIndiceI64F = Record
               Valor : Int64;
               TipoConta  : TgArr001;
               PosIni : Int64;
               Tam : Int64;
               End;

type
  TgIndiceNomeCartao = Record
                     Valor : TgArr019;
                     TipoConta : TgArr001;
                     PosIni,
                     Tam : Int64;
                     End;


  TgArqIndiceContaCartao = File Of TgIndiceI64F;
  TgArqIndiceNomeCartao  = File Of TgIndiceNomeCartao;

type
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
type
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
    ArqIndiceContaCartao : TgArqIndiceContaCartao;
    ArqIndiceNomeCartao : TgArqIndiceNomeCartao;
    IndiceConta,
    IndiceCartao : TgIndiceI64F;
    IndiceNomeCartao : TgIndiceNomeCartao;
    BufI,
    BufCmp : Pointer;
    SubForm,
    Sinal,
    Nome,
    CartaoAnt,
    DataTransAux,
    Operacao,
    NomeDescricaoOrg : AnsiString;
    TestarFlag : Boolean;

    DadosDeCartao,
    DadosDeCartaoDePortadores,
    DadosDeConta,
    DadosDeCartaoCpfNome,
    DadosDeContaDePortadores,
    DadosDeExtrato,
    ListaDeArquivosAProcessar : TStringList;

    Fmemo : TStringList;
    dataModule : TDataModule1;
    procedure ConectarBanco(bd : integer = 0);
    procedure DesconectarBanco;
    function RetornaRegistros(query:String): String;
    function ConverterArquivoParaJSON(pDirArquivo : string) : TJSONArray;
    function RetornarCaminhoArq : String;
    procedure Comprimir(ArquivoCompacto: TFileName; Arquivos: array of TFileName);
    Procedure LogaLocal(Const Mens : String);
    Function PesquisaCarregaContaCartao(NConta : Int64; Narq : AnsiString) : AnsiString;
    Function PesquisaContaCartao(NConta : Int64; Var ArqIndiceContaCartao : TgArqIndiceContaCartao; Var Qtd : Integer) : Boolean;
    Function PesquisaCarregaNomeCartao(Nome, SobreNome : AnsiString; Narq : AnsiString) : AnsiString;
    Function PesquisaNomeCartao(Nome : AnsiString; Var ArqIndiceNomeCartao : TgArqIndiceNomeCartao) : Boolean;

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
    Function RetornarContaCartao(arquivo, cartao, NArqCart : String) : String;
    Function RetornarContaCPF(arquivo, cpf : String) : String;
    Function RetornarContaNome(arquivo, NArqCart, nome, sobrenome : String) : String;
    Function RetornarContaAux(arquivo, contaaux : String) : String;
    function RetornarContaEmpresa(arquivo : String; conta : Int64): String;
    function RetornarArquivo(arquivo : String): String;
  end;

implementation


{$R *.dfm}


uses System.StrUtils;

Function TServerMethods1.PesquisaContaCartao(NConta : Int64; Var ArqIndiceContaCartao : TgArqIndiceContaCartao; Var Qtd : Integer) : Boolean;
Var
  L,
  U,
  M,
  Posic : Integer;
Begin
Result := False;
Qtd := 0;
L := 0;
U := (FileSize(ArqIndiceContaCartao)) - 1;
While L <= U Do
  Begin
  M := (L + U) Div 2;
  Seek(ArqIndiceContaCartao,M);
  {$i-}
  Read(ArqIndiceContaCartao, IndiceConta);
  {$i+}
  If (IoResult = 0) Then
    If NConta = IndiceConta.Valor Then
      Begin
      Repeat
        Try
          Seek(ArqIndiceContaCartao,FilePos(ArqIndiceContaCartao)-2);
          Read(ArqIndiceContaCartao,IndiceConta);
        Except
          Seek(ArqIndiceContaCartao,0);
          Break;
        End; // Try
      Until (NConta <> IndiceConta.Valor);
      Posic := FilePos(ArqIndiceContaCartao); // Aponta Para o Primeiro da lista
      Repeat
        Try
          Read(ArqIndiceContaCartao,IndiceConta);
        Except
          Break;
          End; // Try
        If NConta = IndiceConta.Valor Then
          Inc(Qtd);
      Until NConta <> IndiceConta.Valor;
      Seek(ArqIndiceContaCartao,Posic);
      Read(ArqIndiceContaCartao,IndiceConta);
      Result := True;
      Exit
      End
    Else
      If NConta > IndiceConta.Valor Then
        L := M + 1
      Else
        U := M - 1
  Else
    Begin
    {ShowMessage('Erro fatal durante pesquisa IContaCartao');}
    Exit;
    End;
  End;
End;

Function TServerMethods1.PesquisaCarregaContaCartao(NConta : Int64; Narq : AnsiString) : AnsiString;
Var
  ArqContaCartao : File;
  Qtd,
  Lidos : Integer;
  Teste,
  AuxStr : AnsiString;
  Pula : Boolean;
  RegUnsrCartAux : TgUnsrCart;
  RegUnsrContAux : TgUnsrCont;

Begin
Result := '';
If PesquisaContaCartao(NConta, ArqIndiceContaCartao, Qtd) Then
  Begin
  AssignFile(ArqContaCartao,NArq);
  Reset(ArqContaCartao,1);
  Repeat
    Seek(ArqContaCartao,IndiceConta.PosIni);

    ReallocMem(BufCmp,IndiceConta.Tam);                   { Allocates only the space needed }
    BlockRead(ArqContaCartao,BufCmp^,IndiceConta.Tam,Lidos);   { Read only the buffer To decompress }
    ReallocMem(BufI,0);
    Try                         { DeAllocates }
      ZDecompress(BufCmp,IndiceConta.Tam,BufI,Lidos);
//      DecompressBuf(BufCmp,IndiceConta.Tam,0,BufI,Lidos);
    Except
      Result := '';
      Exit;
      End;
    SetLength(AuxStr,Lidos);
    Move(BufI^,AuxStr[1],Lidos);
    Teste := '';
    If Lidos = SizeOf(RegUnsrCartAux) Then
      Begin
      Move(BufI^,RegUnsrCartAux,SizeOf(RegUnsrCartAux));
      Teste := RegUnsrCartAux.TipoConta;
      End
    Else
    If Lidos = SizeOf(RegUnsrContAux)-2 Then
      Begin
      Move(BufI^,RegUnsrContAux,SizeOf(RegUnsrContAux));
      Teste := RegUnsrContAux.TipoConta;
      End;

    Pula := False;
    If Teste <> '' Then
      Begin
      If (SubForm = '') Or (SubForm = 'CONTA') Or (SubForm = 'CARTAO') Or (SubForm = 'EXTR1') Then
        If Teste <> 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL4') Then
        If Teste = 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL2') Or (SubForm = 'EMPRESARIAL3') Then
        If Teste <> 'J' Then
          Pula := True;
      End;

    If Not TestarFlag Then
      Pula := False;

    If Not Pula Then
      If AuxStr[Length(AuxStr)] = #10 Then
        Result := Result + AuxStr
      Else
        Result := Result + AuxStr + #13#10;
    Try
      Read(ArqIndiceContaCartao, IndiceConta);
    Except
      IndiceConta.Valor := NConta-1; // Para dar um valor diferente e sair do loop...
      End; // Try
  Until IndiceConta.Valor <> NConta;
  If Length(Result) <> 0 Then
    Result := Copy(Result,1,Length(Result)-2);
  CloseFile(ArqContaCartao);
  End;
TestarFlag := True;
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

function TServerMethods1.RetornarArquivo(arquivo: String): String;
begin
  AssignFile(ArqIndiceContaCartao,arquivo);
  DadosDeCartao := TStringList.Create;
  DadosDeCartao.Clear;
  Reset(ArqIndiceContaCartao);
  NumConta := StrToInt64(contaaux);
  DadosDeCartao.Text := DadosDeCartao.Text + PesquisaCarregaContaCartao(NumConta, arquivo);
  result := DadosDeCartao.Text;
  FreeAndNil(DadosDeCartao);
end;

function TServerMethods1.RetornarCaminhoArq : String;
var arqIni : TiniFile;
begin
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  result         := arqIni.ReadString('configuracoes', 'caminho',    '');
end;

function TServerMethods1.RetornarContaAux(arquivo, contaaux: String): String;
var
  NumConta : Int64;
begin
  AssignFile(ArqIndiceContaCartao,ExtractFilePath(arquivo)+SeArquivoSemExt(arquivo)+'CONTA.IND');
  DadosDeCartao := TStringList.Create;
  DadosDeCartao.Clear;
  Reset(ArqIndiceContaCartao);
  NumConta := StrToInt64(contaaux);
  DadosDeCartao.Text := DadosDeCartao.Text + PesquisaCarregaContaCartao(NumConta, arquivo);
  result := DadosDeCartao.Text;
  FreeAndNil(DadosDeCartao);
end;

function TServerMethods1.RetornarContaCartao(arquivo, cartao, NArqCart: String): String;
var
  NumCartao : Int64;
begin
  AssignFile(ArqIndiceContaCartao,arquivo);
  DadosDeCartao := TStringList.Create;
  DadosDeCartao.Clear;
  Reset(ArqIndiceContaCartao);
  NumCartao := StrToInt64(cartao);
  DadosDeCartao.Text := PesquisaCarregaContaCartao(NumCartao, NArqCart);
  result := DadosDeCartao.Text;
  FreeAndNil(DadosDeCartao);
end;

function TServerMethods1.RetornarContaCPF(arquivo, cpf: String): String;
var
  NumCpf : Int64;
begin
  AssignFile(ArqIndiceContaCartao,arquivo);
  DadosDeConta := TStringList.Create;
  DadosDeConta.Clear;
  Reset(ArqIndiceContaCartao);
  NumCpf := StrToInt64(cpf);
  DadosDeConta.Text := PesquisaCarregaContaCartao(NumCpf, arquivo);
  result := DadosDeConta.Text;
  FreeAndNil(DadosDeConta);
end;

function TServerMethods1.RetornarContaNome(arquivo, NArqCart, nome, sobrenome: String): String;
begin
  AssignFile(ArqIndiceNomeCartao,arquivo);
  DadosDeCartao := TStringList.Create;
  DadosDeCartao.Clear;
  Reset(ArqIndiceNomeCartao);
  DadosDeCartao.Text := PesquisaCarregaNomeCartao(nome, sobrenome, NArqCart);
  result := DadosDeCartao.Text;
  FreeAndNil(DadosDeCartao);
end;

function TServerMethods1.RetornarContaEmpresa(arquivo : String; conta : Int64): String;
begin
  AssignFile(ArqIndiceContaCartao,arquivo);
  DadosDeContaDePortadores := TStringList.Create;
  DadosDeContaDePortadores.Clear;
  Reset(ArqIndiceContaCartao);
  DadosDeContaDePortadores.Text := PesquisaCarregaContaCartao(conta, arquivo);
  result := DadosDeContaDePortadores.Text;
  FreeAndNil(DadosDeContaDePortadores);
end;

Function TServerMethods1.PesquisaNomeCartao(Nome : AnsiString; Var ArqIndiceNomeCartao : TgArqIndiceNomeCartao) : Boolean;
Var
  L,
  U,
  M,
  Posic,
  Ofs : Integer;
  Ok : Boolean;
Begin
Result := False;
L := 0;
U := (FileSize(ArqIndiceNomeCartao)) - 1;
While L <= U Do
  Begin
  M := (L + U) Div 2;
  Seek(ArqIndiceNomeCartao,M);
  {$i-}
  Read(ArqIndiceNomeCartao, IndiceNomeCartao);
  {$i+}
  If (IoResult = 0) Then
    Begin
    Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
    If Ok Then
      Begin
      Ofs := 2;
      Repeat
        Try
//          Seek(ArqIndiceNomeCartao,FilePos(ArqIndiceNomeCartao)-2);
          Seek(ArqIndiceNomeCartao,FilePos(ArqIndiceNomeCartao)-Ofs); // Pula mais para trás SPEED UP THE SEARCH!
          Read(ArqIndiceNomeCartao,IndiceNomeCartao);
          If Ofs < 1024 Then
            Ofs := Ofs * 2;
        Except
          Seek(ArqIndiceNomeCartao,0);
          Break;
          End; // Try
        Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
      Until Not Ok;

      Repeat                                                       // Sincroniza
        Read(ArqIndiceNomeCartao,IndiceNomeCartao);
        Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
      Until Ok;
      Seek(ArqIndiceNomeCartao,FilePos(ArqIndiceNomeCartao)-1);

      Posic := FilePos(ArqIndiceNomeCartao); // Aponta Para o Primeiro da lista
//      Repeat
//        Try
//          Read(ArqIndiceNomeCartao,IndiceNomeCartao);
//        Except
//          Break;
//          End; // Try
//        Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
//        If Ok Then
//          Inc(Qtd);
//      Until Not Ok;

      Seek(ArqIndiceNomeCartao,Posic);
      Read(ArqIndiceNomeCartao,IndiceNomeCartao);
      Result := True;
      Exit
      End
    Else
      If Nome > Copy(IndiceNomeCartao.Valor,1,Length(Nome)) Then
        L := M + 1
      Else
        U := M - 1
    End
  Else
    Begin
    //ShowMessage('Erro fatal durante pesquisa INome');
    Exit;
    End;
  End;
End;

Function TServerMethods1.PesquisaCarregaNomeCartao(Nome, SobreNome : AnsiString; Narq : AnsiString) : AnsiString;
Var
  ArqNomeExt : File;
  PosDados,
  QtdReal,
  Lidos : Integer;
  RegUnsrCartAux : TgUnsrCart;
  StrAux : AnsiString;
  Pula,
  Ok : Boolean;
Begin
Result := '';
If PesquisaNomeCartao(Nome, ArqIndiceNomeCartao) Then
  Begin
  AssignFile(ArqNomeExt,NArq);
  Reset(ArqNomeExt,1);
  QtdReal := 0;
  PosDados := -1;
  Repeat
    Ok := True;
    If (Sobrenome <> '') Then
      Ok := (Pos(SobreNome,Copy(IndiceNomeCartao.Valor,Length(Nome)+1,Length(IndiceNomeCartao.Valor)-Length(Nome))) <> 0);
    If Ok And (PosDados <> IndiceNomeCartao.PosIni) Then
      Begin
      PosDados := IndiceNomeCartao.PosIni;
      Seek(ArqNomeExt,IndiceNomeCartao.PosIni);
      ReallocMem(BufCmp,IndiceNomeCartao.Tam);                   { Allocates only the space needed }
      BlockRead(ArqNomeExt,BufCmp^,IndiceNomeCartao.Tam,Lidos);   { Read only the buffer To decompress }
      ReallocMem(BufI,0);                               { DeAllocates }
      ZDecompress(BufCmp,IndiceNomeCartao.Tam,BufI,Lidos);
//      DecompressBuf(BufCmp,IndiceNomeCartao.Tam,0,BufI,Lidos);
      SetLength(StrAux,Lidos);
      Move(BufI^,StrAux[1],Lidos);
      Move(BufI^,RegUnsrCartAux,SizeOf(RegUnsrCartAux));
      Pula := False;
      If (SubForm = '') Or (SubForm = 'CONTA') Or (SubForm = 'CARTAO') Or (SubForm = 'EXTR1') Then
        If RegUnsrCartAux.TipoConta <> 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL4') Then
        If RegUnsrCartAux.TipoConta = 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL2') Or (SubForm = 'EMPRESARIAL3') Then // Dados da empresa e portadores
        If RegUnsrCartAux.TipoConta <> 'J' Then
          Pula := True;

      If Not TestarFlag Then
        Pula := False;

      If Not Pula Then
        Begin
        Result := Result + StrAux;
        Inc(QtdReal);
        If QtdReal = 1000 Then
          Begin
          //ShowMessage('Redefina a sua pesquisa. Mais de 1000 registros encontrados, desprezando o restante...');
//        Qtd := 0;
          Break;
          End;
        End;
      End;
    Try
      Read(ArqIndiceNomeCartao,IndiceNomeCartao);      // Muda o registro
    Except
      Break
      End; // Try
//    Dec(Qtd);
//  Until Qtd <= 0;
  Until (Nome <> Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
  CloseFile(ArqNomeExt);
  End;
TestarFlag := True;
End;

end.

