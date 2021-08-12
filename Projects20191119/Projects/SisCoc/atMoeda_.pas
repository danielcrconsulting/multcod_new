unit atMoeda_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows;


type
  TatMoeda = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Text1:  TEdit;
    Text2:  TEdit;
    cmdOk:  TButton;
    cmdCancel:  TButton;

    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Text1Exit(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  atMoeda: TatMoeda;

implementation

uses  SysUtils, Module1, RotGerais, VBto_Converter, AdoDB;

{$R *.dfm}

 //=========================================================
procedure TatMoeda.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TatMoeda.cmdOkClick(Sender: TObject);
var
  S,
  sSql: String;
  xS : Extended;
  gBanco: TADOConnection;
  RsDb: TADODataSet;
begin
  if  not (isDataValida(Text1.Text)) then
    begin
    Application.MessageBox('Data inválida. Redigite...', PCHAR(Self.Caption), MB_ICONSTOP);
    Exit;
    end;

  S := Text2.Text;
  if Length(Text1.Text)=0 then
    begin
    Close;
    Exit;
    end;

  if (1+Pos('.', PChar(S)+1)) > 0 then
    begin
//    SetToMid(S, (1+Pos('.', PChar(S)+1)), ',', 1);
    S.Insert((1+Pos('.', PChar(S)+1)), ',');
    end;

  if Length(S)>0 then
    begin
    if (Not TryStrToFloat(S, xS)) or (xS=0) then
      begin
      Application.MessageBox('Digite o Valor da Moeda...', 'Moeda do Dia', MB_ICONSTOP);
      Exit;
      end;
    end
  else
    begin
    Application.MessageBox('Digite o Valor da Moeda...', 'Moeda do Dia', MB_ICONSTOP);
    Exit;
    end;

    // Valdir usava variáveis globais para acesso ao banco o que estou tirando
    // Então eu coloquei isso aqui, essa abertura, por não saber qual o banco será alterado por este form
    // Rever

  if AnsiUpperCase(gOpcao)='ADM' then
    Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl')
  else
    Conecta(gBanco, gDataPath + gDataFile + '.udl');

//  sSql := 'select * from tb_moeda where str(data) = '#39'' + String(CDate(Text1.Text))+''#39'';
  sSql := 'select * from tb_moeda where str(data) = '#39'' + Text1.Text+''#39'';

   RsDb := TADODataSet.Create(nil);
  RsDb.Connection := gBanco;
  RsDb.CommandText := sSql;

//  RsDb := gBanco.OpenRecordset(sSql);
//  with RsDb do
//    begin
  if not RsDb.EOF then
    begin
    RsDb.Edit;
    VBtoADOFieldSet(RsDb, 'valor', StrToFloat(S));
    end
  else
    begin
    RsDb.Insert;
    VBtoADOFieldSet(RsDb, 'data', Text1.Text);
    VBtoADOFieldSet(RsDb, 'codigo', '840');
    VBtoADOFieldSet(RsDb, 'valor', StrToFloat(S));
    end;

  RsDb.UpdateRecord;
//    end;

  Text1.Text := '';
  Text2.Text := '';

  gBanco.Close;
  RsDb.Close;
  gBanco.Free;
  RsDb.Free;

  Close;
end;

procedure TatMoeda.FormActivate(Sender: TObject);
begin
  Text1.SetFocus;
end;

procedure TatMoeda.FormShow(Sender: TObject);
var
  xData : TDateTime;
begin
  CenterForm(Self);
  if TryStrToDate(gData2, xData) then
    begin
    Text1.Text := gData2;
    end
  else
    begin
    Text1.Text := FormatVB(GetDay(Now()),'00')+'/'+FormatVB(GetMonth(Now()),'00')+'/'+FormatVB(GetYear(Now()),'0000');
    end;
  Text1.SelStart := 0;
  Text1.SelLength := Length(Text1.Text);
end;

procedure TatMoeda.Text1Exit(Sender: TObject);
Var
  gBanco: TADOConnection;
  RsDb: TADODataSet;

begin

    // Valdir usava variáveis globais para acesso ao banco o que estou tirando
    // Então eu coloquei isso aqui, essa abertura, por não saber qual o banco será alterado por este form
    // Rever

  if AnsiUpperCase(gOpcao)='ADM' then
    Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl')
  else
    Conecta(gBanco, gDataPath + gDataFile + '.udl');


  sSql := 'select * from tb_moeda where str(data) = '#39''+((Text1.Text))+''#39'';

   RsDb := TADODataSet.Create(nil);
  RsDb.Connection := gBanco;
  RsDb.CommandText := sSql;
  RsDb.Open;

//  RsDb := gBanco.OpenRecordset(sSql);

  if  not RsDb.EOF then
    Text2.Text := FormatVB(RsDb.FieldByName('valor').AsString,'###0.0000');

  gBanco.Close;
  RsDb.Close;
  gBanco.Free;
  RsDb.Free;

end;


end.
