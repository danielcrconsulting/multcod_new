unit UProcessaExtrator;

interface

uses
  SysUtils, ADODB, UDM, ActiveX, System.Classes, ZLib, UMulticoldReport;

  type
    TByteArr = array of byte;
    TProcessaddor = class (TObject)
    strict private
      FConfigPath: String;
      FDMMain: TDMMain;
      procedure LoadDirBase;
    public
      Constructor Create;
      Destructor Destroy; override;
      procedure ProcessarPendentes;
    end;

    TProcessadorBase = class
    strict protected
      FOutputPath: String;
      FDMMain: TDMMain;
    public
      Constructor Create(ADMMain: TDMMain; AOutputPath: String);
      function Processar: Boolean; virtual; abstract;
    end;

    TProcessadorExtrator = class (TProcessadorBase)
    strict private
      function DescompactarTemplate(s: String): String;
    public
      function Processar: Boolean; override;
    end;

    TProcessadorDescompactador = class (TProcessadorBase)
    strict private
      procedure ObterDescompactador(AId: Integer);
      procedure ObterPesquisa(AIdParametroDescompactador: Integer);
    public
      function Processar: Boolean; override;
    end;

    TUtils = class
    public
      class procedure ColocarEmAndamento(ADMMain: TDMMain; idProcessamento: string);
      class procedure RegistrarSucesso(ADMMain: TDMMain; idProcessamento, outPutPath: string);
      class procedure RegistrarErro(ADMMain: TDMMain; idProcessamento, msgErro: String);
    end;

implementation

uses
  UExtratorDados;

{ TProcessaddorExtrator }


constructor TProcessaddor.Create;
begin
  CoInitialize(nil);
  LoadDirBase;
  FDMMain := TDMMain.Create(nil);
end;


destructor TProcessaddor.Destroy;
begin
  FreeAndNil(FDMMain);
  inherited;
end;

procedure TProcessaddor.LoadDirBase;
var
  filePath, configPath: String;
  Arq : TextFile;

begin
  filePath := GetCurrentDir + '\ConfigProcessador.cpr';

  AssignFile(Arq, filePath);
  Reset(Arq);

  ReadLn(Arq,configPath);

  FConfigPath := configPath;

  CloseFile(Arq);
end;

procedure TProcessaddor.ProcessarPendentes;
var
  template: String;
  multicoldManager: TMulticoldmanager;
  baseOutput,
  outputFile: String;
  MyGuid : TGUID;
  processador: TProcessadorBase;
  processou: boolean;
  pathRel : String;
begin
  //FDMMain.QryPendentes.Open;
  FDMMain.ImportarDados('select ' +
	'Id,' +
	'TipoProcessamento,' +
	'IdReferencia,' +
	'PathRelatorio,' +
	'StatusProcessamento,' +
	'ArquivoTemplateComp,' +
	'CODUSUARIO,' +
	'SENHA,' +
  'DataCriacao ' +
  'from ConsultaProcessadorExtrator ' +
  'order by CODUSUARIO, DataCriacao ',nil,'P');
  FDMMain.MemPen.Open;
  baseOutput := FConfigPath;
  processou := false;

  while not FDMMain.MemPen.Eof do
  begin
    TUtils.ColocarEmAndamento(FDMMain, FDMMain.MemPen.FieldByName('Id').AsString);
    pathrel := stringReplace(FDMMain.MemPen.FieldByName('PathRelatorio').AsString,'/','\',[rfIgnoreCase, rfReplaceAll]);
    Writeln(pathrel);

    if CreateGUID(MyGuid) = 0 then
      outputFile := baseOutput + StringReplace(StringReplace(GUIDToString(MyGuid),'{','', [rfReplaceAll]),'}','', [rfReplaceAll]) + '.txt';

    if FDMMain.MemPen.FieldByName('TipoProcessamento').AsInteger = 1 then
    begin
      processador := TProcessadorExtrator.Create(FDMMain, outputFile);
      try
        processou := processador.Processar;
      finally
        processador.Free;
      end;
    end else
    begin
      processador := TProcessadorDescompactador.Create(FDMMain, outputFile);
      try
        processou := processador.Processar;
      finally
        processador.Free;
      end;
    end;

    if processou then
      TUtils.RegistrarSucesso(FDMMain, FDMMain.MemPen.FieldByName('Id').AsString, outputFile);

    FDMMain.MemPen.Next;
  end;

end;



{ TProcessadorExtrator }

function TProcessadorExtrator.DescompactarTemplate(s: String): String;
var
  strInput,
  strOutput: TStringStream;
  Unzipper: TZDecompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(s);
  strOutput:= TStringStream.Create;
  try
    Unzipper:= TZDecompressionStream.Create(strInput);
    try
      strOutput.CopyFrom(Unzipper, Unzipper.Size);
    finally
      Unzipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

function TProcessadorExtrator.Processar: Boolean;
var
  template, pathrel, arquivo: String;
  multicoldManager: TMulticoldmanager;
  templ : TBytes;
  template_ : AnsiString;
  function bintoAscii(bin: array of byte): AnsiString;
  var i: integer;
  begin
    SetLength(Result, Length(bin));
    for i := 0 to Length(bin)-1 do
      Result[1+i] := AnsiChar(bin[i]);
  end;
begin
    Result := false;

    try
      pathrel := stringReplace(FDMMain.MemPen.FieldByName('PathRelatorio').AsString,'/','\',[rfIgnoreCase, rfReplaceAll]);

      multicoldManager := TMulticoldManager.Create(FDMMain.MemPen.FieldByName('CODUSUARIO').AsString,
            FDMMain.MemPen.FieldByName('SENHA').AsString,
            pathrel,
            false);

      //template := DescompactarTemplate(FDMMain.MemPen.FieldByName('ArquivoTemplateComp').AsString);
      //templ := FDMMain.MemPen.FieldByName('ArquivoTemplateComp').AsBytes;
      template := FDMMain.MemPen.FieldByName('ArquivoTemplateComp').AsString;

      //template_ :=  bintoAscii(templ);

      template := FDMMain.RetornarArqTemplate(FDMMain.MemPen.FieldByName('idreferencia').AsInteger);

      try
        multicoldManager.ExecutarExtracaoDados(template, FOutputPath);
        Result := true;
      finally
        FreeAndNil(multicoldManager);
      end;

    except on E: Exception do
      TUtils.RegistrarErro(FDMMain, FDMMain.MemPen.FieldByName('Id').AsString, E.Message);
    end;
end;

{ TUtils }

class procedure TUtils.ColocarEmAndamento(ADMMain: TDMMain;
  idProcessamento: string);
var
  s: String;
begin
  s := 'E';
  ADMMain.Persistir('update ProcessadorExtracao set StatusProcessamento = '
                                    + QuotedStr(s) + ' where id = ' + idProcessamento,nil);
  //ADMMain.CmdUpdate.Execute;
end;

class procedure TUtils.RegistrarErro(ADMMain: TDMMain; idProcessamento,
  msgErro: String);
var
  s: String;
begin
  s := 'R';
  ADMMain.Persistir('update ProcessadorExtracao set StatusProcessamento = '
                                    + QuotedStr(s) + ', MensagemDetalheErro = ' + QuotedStr(msgErro)
                                    + ' where id = ' + idProcessamento,nil);
  //ADMMain.CmdUpdate.Execute;
end;

class procedure TUtils.RegistrarSucesso(ADMMain: TDMMain; idProcessamento,
  outPutPath: string);
var
  s: String;
begin
  s := 'S';
  ADMMain.Persistir('update ProcessadorExtracao set StatusProcessamento = '
                                    + QuotedStr(s) + ', PathArquivoExportacao = ' + QuotedStr(outPutPath)
                                    + ' where id = ' + idProcessamento,nil);
  //ADMMain.CmdUpdate.Execute;
end;

{ TProcessadorDescompactador }

procedure TProcessadorDescompactador.ObterDescompactador(AId: Integer);
begin
  FDMMain.ImportarDados('select  '+
	'Id,                           '+
	'TipoDescompactacao,           '+
	'RemoverBrancos,               '+
	'Orig,                         '+
	'IntervaloIni,                 '+
	'IntervaloFin,                 '+
	'IndexPaginaAtual,             '+
	'ApenasLinhasPesquisa,         '+
	'PesquisaMensagem              '+
  'from ParametroDescompactador  '+
  'where Id = ' + IntToStr(AId),nil,'D');
  //FDMMain.ADOQryDescomp.Close;
  //FDMMain.ADOQryDescomp.Parameters.ParamValues['Id'] :=  AId;
  //FDMMain.ADOQryDescomp.Open;
end;

procedure TProcessadorDescompactador.ObterPesquisa(AIdParametroDescompactador: Integer);
begin
  FDMMain.ImportarDados(' select  ' +
	'Id,                            ' +
	'IdParametroDescompactador,     ' +
	'IndexPesq,                     ' +
	'Campo,                         ' +
	'Operador,                      ' +
	'Valor,                         ' +
	'Conector                       ' +
  'from ParametroPesquisa         ' +
  'where IdParametroDescompactador = ' + IntToStr(AIdParametroDescompactador),nil,'PQ');

  //FDMMain.ADOQryPesq.Close;
  //FDMMain.ADOQryPesq.Parameters.ParamValues['IdParametroDescompactador'] :=  AIdParametroDescompactador;
  //FDMMain.ADOQryPesq.Open;
end;

function TProcessadorDescompactador.Processar: Boolean;
var
  template, pathrel: String;
  multicoldManager: TMulticoldmanager;
  outputFile: String;
  opcoes : TDescompactadorOptions;
  query: TListaPesquisa;
  len: Integer;
  resultadoQuerFacil: TListaResultadoPesquisa;
  descompactador: TDescompactador;

begin
    Result := false;
    ObterDescompactador(FDMMain.MemPen.FieldByName('IdReferencia').AsInteger);

    opcoes := TDescompactadorOptions.Create;
    try

      case FDMMain.MemDes.FieldByName('TipoDescompactacao').AsInteger of
        1:
        begin
          opcoes.TipoDescompactacao := tdPaginaAtual;
          opcoes.IndexPaginaAtual := FDMMain.MemDes.FieldByName('IndexPaginaAtual').AsInteger;
        end;
        2:
        begin
          opcoes.TipoDescompactacao := tdPesquisa;

          opcoes.ApenasLinhasPesquisa := FDMMain.MemDes.FieldByName('ApenasLinhasPesquisa').AsBoolean;
        end;
        3:
        begin
          opcoes.TipoDescompactacao := tdIntervalo;

          opcoes.IntervaloIni := FDMMain.MemDes.FieldByName('IntervaloIni').AsInteger;
          opcoes.IntervaloFin := FDMMain.MemDes.FieldByName('IntervaloFin').AsInteger;
        end;
        4:
        begin
          opcoes.TipoDescompactacao := tdFull;
        end;
      end;

      opcoes.RemoverBrancos := FDMMain.MemDes.FieldByName('RemoverBrancos').AsBoolean;

      pathrel := stringReplace(FDMMain.MemPen.FieldByName('PathRelatorio').AsString,'/','\',[rfIgnoreCase, rfReplaceAll]);

      try
        multicoldManager := TMulticoldManager.Create(FDMMain.MemPen.FieldByName('CODUSUARIO').AsString,
              FDMMain.MemPen.FieldByName('SENHA').AsString,
              pathrel,
              false,
              FDMMain.MemDes.FieldByName('Orig').AsBoolean);


        if opcoes.TipoDescompactacao = tdPesquisa then
        begin
          // Rodar QueryFacil //
          ObterPesquisa(FDMMain.MemPen.FieldByName('idReferencia').AsInteger);

          len := 0;
          while not FDMMain.MemPesq.Eof do
          begin
            Inc(len);
            SetLength(query, len);

            query[len-1].Index := FDMMain.MemPesq.FieldByName('IndexPesq').AsString;
            query[len-1].Campo := FDMMain.MemPesq.FieldByName('CAMPO').AsString;
            query[len-1].Operador := FDMMain.MemPesq.FieldByName('Operador').AsInteger;
            query[len-1].Valor := FDMMain.MemPesq.FieldByName('Valor').AsString;
            query[len-1].Conector := FDMMain.MemPesq.FieldByName('Conector').AsInteger;

            FDMMain.MemPesq.Next;
          end;

          if not multicoldManager.ExecutarQueryFacil(query, '(A)', resultadoQuerFacil) then
          begin
            raise Exception.Create('Erro ao rodar a Query Facil. Pesquisa retornou false!');
            exit;
          end;
        end;

        descompactador := TDescompactadorFactory.ObterDescompactador(multicoldManager, opcoes);
        try
          descompactador.Processar(FOutputPath);
        finally
          FreeAndNil(descompactador);
        end;

        Result := true;

      except on E: Exception do
        TUtils.RegistrarErro(FDMMain, FDMMain.MemPen.FieldByName('Id').AsString, E.Message);
      end;
    finally
      FreeAndNil(opcoes);
    end;
end;

{ TProcessadorBase }

constructor TProcessadorBase.Create(ADMMain: TDMMain; AOutputPath: String);
begin
  FDMMain := ADMMain;
  FOutputPath := AOutputPath;
end;

end.
