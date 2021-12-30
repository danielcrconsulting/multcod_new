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
  FireDAC.Phys.MSSQL, FireDAC.Stan.StorageBin, FireDAC.Comp.UI;

type
  TServerMethods1 = class(TDSServerModule)
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDCon: TFDConnection;
    FDQry: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DSServerModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure ConectarBanco;
    procedure DesconectarBanco;
    function RetornaRegistros(query:String): String;
    function ConverterArquivoParaJSON(pDirArquivo : string) : TJSONArray;
    function RetornarCaminhoArq : String;
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

  end;

implementation


{$R *.dfm}


uses System.StrUtils;

function TServerMethods1.BaixarArquivo(arq: String): TJSONArray;
  var oArquivoJSON : TJSONArray;
begin
  try
    // Envia o arquivo em JOSN para o servidor
    oArquivoJSON := ConverterArquivoParaJSON( RetornarCaminhoArq + arq);
    result := oArquivoJSON;
  finally
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

procedure TServerMethods1.DSServerModuleDestroy(Sender: TObject);
begin
  DesconectarBanco;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

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

