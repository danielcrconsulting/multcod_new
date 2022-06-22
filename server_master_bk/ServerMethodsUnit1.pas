unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  IniFiles, FireDAC.Comp.UI;

type
{$METHODINFO ON}
  TServerMethods1 = class(TDataModule)
    FDCon: TFDConnection;
    FDConLog: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    { Private declarations }
    caminhoMaster, caminhoLog : String;
    procedure ConfigurarBanco;
    function RetornaRegistros(query:String): String;
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function validarUsuario( usuario : String) : string;
    function validarGrupo( usuario, grupo : String) : String;
  end;
{$METHODINFO OFF}

implementation


{$R *.dfm}


uses System.StrUtils;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

procedure TServerMethods1.ConfigurarBanco;
var iniF : TIniFile;
begin
  iniF := TIniFile.Create(GetCurrentDir + 'conf.ini');
  caminhoMaster := iniF.ReadString('BANCO','MASTER','');
  caminhoLog := iniF.ReadString('BANCO','LOG','');

  FDCon.Params.Database    := caminhoMaster;
  FDConLog.Params.Database := caminhoLog;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.validarGrupo(usuario, grupo: String): String;
var
  fdqry : TFDQuery;
  field_name,nomeDaColuna,valorDaColuna : String;
  I : Integer;
begin
  try
    fdqry := TFDQuery.Create(nil);
    fdqry.Connection := FDCon;
    try
      fdqry.Sql.Clear;
      fdqry.Sql.Add('SELECT * FROM usurel A, ');
      fdqry.Sql.Add('             GRUPOSDFN B ');
      fdqry.Sql.Add('WHERE (A.CODUSUARIO = '  + QuotedStr(usuario) );
      fdqry.Sql.Add('AND   (A.CODGRUPO = B.CODGRUPO) ');
      fdqry.Open;
      result := '[';
      while (not fdqry.EOF) do
      begin
        result := result+'{';
        for I := 0 to fdqry.FieldDefs.Count-1 do
        begin
          nomeDaColuna  := fdqry.FieldDefs[I].Name;
          valorDaColuna := fdqry.FieldByName(nomeDaColuna).AsString;
          result := result+'"'+nomeDaColuna+'":"'+valorDaColuna+'",';
        end;
        Delete(result, Length(Result), 1);
        result := result+'},';

        fdqry.Next;
      end;
      fdqry.Refresh;

      Delete(result, Length(Result), 1);
      result := result+']';
    except
      on e:exception do begin

      end;
    end;
  finally
    FreeAndNil(fdqry);
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

function TServerMethods1.validarUsuario(usuario: String): string;
var
  fdqry : TFDQuery;
begin
  try
    fdqry := TFDQuery.Create(nil);
    fdqry.Connection := FDCon;
    try
      fdqry.Sql.Clear;
      fdqry.Sql.Add('SELECT * FROM usuarios ');
      fdqry.Sql.Add('WHERE CODUSUARIO = ' + QuotedStr(usuario));
      fdqry.Open;
      If fdqry.RecordCount = 0 Then
        result := fdqry.FieldByName('CODUSUARIO').AsString
      else
        result := '';
    except
      on e:exception do begin

      end;
    end;
  finally
    FreeAndNil(fdqry);
  end;

end;

end.

