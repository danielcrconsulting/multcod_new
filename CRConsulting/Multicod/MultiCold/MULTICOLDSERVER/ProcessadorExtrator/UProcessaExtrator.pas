unit UProcessaExtrator;

interface

uses
  SysUtils, ADODB, UDM, ActiveX, System.Classes, ZLib, UMulticoldReport;

  type

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

begin
  FDMMain.QryPendentes.Open;
  baseOutput := FConfigPath;
  processou := false;

  while not FDMMain.QryPendentes.Eof do
  begin
    TUtils.ColocarEmAndamento(FDMMain, FDMMain.QryPendentes.FieldByName('Id').AsString);
    Writeln(FDMMain.QryPendentes.FieldByName('PathRelatorio').AsString);

    if CreateGUID(MyGuid) = 0 then
      outputFile := baseOutput + StringReplace(StringReplace(GUIDToString(MyGuid),'{','', [rfReplaceAll]),'}','', [rfReplaceAll]) + '.txt';

    if FDMMain.QryPendentes.FieldByName('TipoProcessamento').AsInteger = 1 then
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
      TUtils.RegistrarSucesso(FDMMain, FDMMain.QryPendentes.FieldByName('Id').AsString, outputFile);

    FDMMain.QryPendentes.Next;
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
  template: String;
  multicoldManager: TMulticoldmanager;

begin
    Result := false;

    try
      multicoldManager := TMulticoldManager.Create(FDMMain.QryPendentes.FieldByName('CODUSUARIO').AsString,
            FDMMain.QryPendentes.FieldByName('SENHA').AsString,
            FDMMain.QryPendentes.FieldByName('PathRelatorio').AsString,
            false);

      template := DescompactarTemplate(FDMMain.QryPendentes.FieldByName('ArquivoTemplateComp').AsString);

      try
        multicoldManager.ExecutarExtracaoDados(template, FOutputPath);
        Result := true;
      finally
        FreeAndNil(multicoldManager);
      end;

    except on E: Exception do
      TUtils.RegistrarErro(FDMMain, FDMMain.QryPendentes.FieldByName('Id').AsString, E.Message);
    end;
end;

{ TUtils }

class procedure TUtils.ColocarEmAndamento(ADMMain: TDMMain;
  idProcessamento: string);
var
  s: String;
begin
  s := 'E';
  ADMMain.CmdUpdate.CommandText := 'update ProcessadorExtracao set StatusProcessamento = '
                                    + QuotedStr(s) + ' where id = ' + idProcessamento;
  ADMMain.CmdUpdate.Execute;
end;

class procedure TUtils.RegistrarErro(ADMMain: TDMMain; idProcessamento,
  msgErro: String);
var
  s: String;
begin
  s := 'R';
  ADMMain.CmdUpdate.CommandText := 'update ProcessadorExtracao set StatusProcessamento = '
                                    + QuotedStr(s) + ', MensagemDetalheErro = ' + QuotedStr(msgErro)
                                    + ' where id = ' + idProcessamento;
  ADMMain.CmdUpdate.Execute;
end;

class procedure TUtils.RegistrarSucesso(ADMMain: TDMMain; idProcessamento,
  outPutPath: string);
var
  s: String;
begin
  s := 'S';
  ADMMain.CmdUpdate.CommandText := 'update ProcessadorExtracao set StatusProcessamento = '
                                    + QuotedStr(s) + ', PathArquivoExportacao = ' + QuotedStr(outPutPath)
                                    + ' where id = ' + idProcessamento;
  ADMMain.CmdUpdate.Execute;
end;

{ TProcessadorDescompactador }

procedure TProcessadorDescompactador.ObterDescompactador(AId: Integer);
begin
  FDMMain.ADOQryDescomp.Close;
  FDMMain.ADOQryDescomp.Parameters.ParamValues['Id'] :=  AId;
  FDMMain.ADOQryDescomp.Open;
end;

procedure TProcessadorDescompactador.ObterPesquisa(AIdParametroDescompactador: Integer);
begin
  FDMMain.ADOQryPesq.Close;
  FDMMain.ADOQryPesq.Parameters.ParamValues['IdParametroDescompactador'] :=  AIdParametroDescompactador;
  FDMMain.ADOQryPesq.Open;
end;

function TProcessadorDescompactador.Processar: Boolean;
var
  template: String;
  multicoldManager: TMulticoldmanager;
  outputFile: String;
  opcoes : TDescompactadorOptions;
  query: TListaPesquisa;
  len: Integer;
  resultadoQuerFacil: TListaResultadoPesquisa;
  descompactador: TDescompactador;

begin
    Result := false;
    ObterDescompactador(FDMMain.QryPendentes.FieldByName('IdReferencia').AsInteger);

    opcoes := TDescompactadorOptions.Create;
    try

      case FDMMain.ADOQryDescomp.FieldByName('TipoDescompactacao').AsInteger of
        1:
        begin
          opcoes.TipoDescompactacao := tdPaginaAtual;
          opcoes.IndexPaginaAtual := FDMMain.ADOQryDescomp.FieldByName('IndexPaginaAtual').AsInteger;
        end;
        2:
        begin
          opcoes.TipoDescompactacao := tdPesquisa;

          opcoes.ApenasLinhasPesquisa := FDMMain.ADOQryDescomp.FieldByName('ApenasLinhasPesquisa').AsBoolean;
        end;
        3:
        begin
          opcoes.TipoDescompactacao := tdIntervalo;

          opcoes.IntervaloIni := FDMMain.ADOQryDescomp.FieldByName('IntervaloIni').AsInteger;
          opcoes.IntervaloFin := FDMMain.ADOQryDescomp.FieldByName('IntervaloFin').AsInteger;
        end;
        4:
        begin
          opcoes.TipoDescompactacao := tdFull;
        end;
      end;

      opcoes.RemoverBrancos := FDMMain.ADOQryDescomp.FieldByName('RemoverBrancos').AsBoolean;


      try
        multicoldManager := TMulticoldManager.Create(FDMMain.QryPendentes.FieldByName('CODUSUARIO').AsString,
              FDMMain.QryPendentes.FieldByName('SENHA').AsString,
              FDMMain.QryPendentes.FieldByName('PathRelatorio').AsString,
              false,
              FDMMain.ADOQryDescomp.FieldByName('Orig').AsBoolean);


        if opcoes.TipoDescompactacao = tdPesquisa then
        begin
          // Rodar QueryFacil //
          ObterPesquisa(FDMMain.QryPendentes.FieldByName('idReferencia').AsInteger);

          len := 0;
          while not FDMMain.ADOQryPesq.Eof do
          begin
            Inc(len);
            SetLength(query, len);

            query[len-1].Index := FDMMain.ADOQryPesq.FieldByName('IndexPesq').AsString;
            query[len-1].Campo := FDMMain.ADOQryPesq.FieldByName('CAMPO').AsString;
            query[len-1].Operador := FDMMain.ADOQryPesq.FieldByName('Operador').AsInteger;
            query[len-1].Valor := FDMMain.ADOQryPesq.FieldByName('Valor').AsString;
            query[len-1].Conector := FDMMain.ADOQryPesq.FieldByName('Conector').AsInteger;

            FDMMain.ADOQryPesq.Next;
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
        TUtils.RegistrarErro(FDMMain, FDMMain.QryPendentes.FieldByName('Id').AsString, E.Message);
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
