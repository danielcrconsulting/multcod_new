unit UDM;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Data.DB, uMetodosServer,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Data.FireDACJSONReflect, System.JSON, REST.Response.Adapter;

type
  TDMMain = class(TDataModule)
    ConnW: TADOConnection;
    QryPendentes: TADOQuery;
    CmdUpdate: TADOCommand;
    ADOQryDescomp: TADOQuery;
    ADOQryPesq: TADOQuery;
    FDQuery1: TFDQuery;
    MemPen: TFDMemTable;
    MemDes: TFDMemTable;
    MemPesq: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    OMetodosServer : clsMetodosServer;
    procedure JsonToDataset(aDataset : TDataSet; aJSON : string);
  public
    { Public declarations }
    procedure ImportarDados( StrSql : String; strPar : TFDParams; MTB: String);
    procedure Persistir( StrSql : String; StgParam : TFDParams);
  end;

var
  DMMain: TDMMain;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDMMain.DataModuleCreate(Sender: TObject);
begin
  OMetodosServer := clsMetodosServer.Create(nil);
  OmetodosServer.Configurar;
end;

procedure TDMMain.JsonToDataset(aDataset : TDataSet; aJSON : string);
var
  JObj: TJSONArray;
  vConv : TCustomJSONDataSetAdapter;
begin
  if (aJSON = EmptyStr) then
  begin
    Exit;
  end;

  JObj := TJSONObject.ParseJSONValue(aJSON) as TJSONArray;
  vConv := TCustomJSONDataSetAdapter.Create(Nil);

  try
    vConv.Dataset := aDataset;
    vConv.UpdateDataSet(JObj);
  finally
    vConv.Free;
    JObj.Free;
  end;
end;

procedure TDMMain.ImportarDados( StrSql : String; strPar : TFDParams; MTB: String);
var
  LDataSetList: TFDJSONDataSets;
  json : String;
begin
  if MTB = 'P' then
  begin
    MemPen.Close;
    json := OMetodosServer.ServerMethodsPrincipalClient.RetornarDadosBanco(StrSql);
    json := StringReplace(json,'\','/',[rfIgnoreCase, rfReplaceAll]);
    if json = ']' then
      json := '[]';
    JsonToDataset(MemPen, json);

    if json <> '[]' then
      MemPen.Open;
  end;
  if MTB = 'D' then
  begin
    MemDes.Close;
    json := OMetodosServer.ServerMethodsPrincipalClient.RetornarDadosBanco(StrSql);
    if json = ']' then
      json := '[]';
    JsonToDataset(MemDes, json);

    if json <> '[]' then
      MemDes.Open;
  end;
  if MTB = 'PQ' then
  begin
    MemPesq.Close;
    json := OMetodosServer.ServerMethodsPrincipalClient.RetornarDadosBanco(StrSql);
    if json = ']' then
      json := '[]';
    JsonToDataset(MemPesq, json);

    if json <> '[]' then
      MemPesq.Open;
  end;
end;

procedure TDMMain.Persistir( StrSql : String; StgParam : TFDParams);
begin
  OMetodosServer.ServerMethodsPrincipalClient.PersistirBanco(StrSql);
end;

end.
