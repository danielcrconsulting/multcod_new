unit mapaDeNomes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, Buttons, System.UITypes, Subrug;

type
  TfMapaDeNomes = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    FileOpenDialog1: TFileOpenDialog;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
    function getTabela:TDataSet;
    procedure setTabela(valor:TDataSet);
  public
    { Public declarations }
  published
    property tabela: TDataSet read getTabela write setTabela;
  end;

var
  fMapaDeNomes: TfMapaDeNomes;
  tTabela : TDataSet;
  nomeOriginal : String;

implementation

uses dataModule, mascaraUsuarios;

{$R *.dfm}

function TfMapaDeNomes.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfMapaDeNomes.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfMapaDeNomes.Button3Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o novo diretório de saída';
    if FileOpenDialog1.Execute then
      Edit3.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit3.Text := UpperCase(X);
  end;
end;

procedure TfMapaDeNomes.Button1Click(Sender: TObject);
begin
OpenDialog1.Title := 'Nome original';
if edit3.Text <> '' then
  OpenDialog1.InitialDir := edit3.text;
if OpenDialog1.Execute then
  edit1.text := extractFileName(OpenDialog1.FileName);
end;

procedure TfMapaDeNomes.Button2Click(Sender: TObject);
begin
OpenDialog1.Title := 'Novo nome';
if edit3.Text <> '' then
  OpenDialog1.InitialDir := edit3.text;
if OpenDialog1.Execute then
  edit2.text := extractFileName(OpenDialog1.FileName);
end;

procedure TfMapaDeNomes.FormShow(Sender: TObject);
begin
BitBtn2.Click;
end;

procedure TfMapaDeNomes.SpeedButton2Click(Sender: TObject);
begin
fMapaDeNomes.Close;
end;

procedure TfMapaDeNomes.BitBtn2Click(Sender: TObject);
begin
if (fMapaDeNomes.Tag = 0) then
  begin
  Edit1.Text := tTabela.Fields[0].AsString;
  Edit2.Text := tTabela.Fields[1].AsString;
  Edit3.Text := tTabela.Fields[2].AsString;
  end
else
  begin
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  end;
nomeOriginal := Edit1.Text;
end;

procedure TfMapaDeNomes.BitBtn1Click(Sender: TObject);
var
  nomeOriginal2,
  novoNome,
  novoDirSaida: String;
begin

nomeOriginal2 := upperCase(Edit1.Text);
if trim(Edit1.Text)='' then
  begin
  messageDlg('É necessário informar o nome original do arquivo.',mtInformation,[mbOk],0);
  Edit1.Text;
  exit;
  end;

novoNome := upperCase(Edit2.Text);
if (trim(novoNome)='') or (upperCase(nomeOriginal2)=upperCase(novoNome)) then
  begin
  messageDlg('É necessário informar o novo nome do arquivo. O novo nome não pode ser igual a nome original do arquivo.',mtInformation,[mbOk],0);
  Edit2.Text;
  exit;
  end;

novoDirSaida := upperCase(Edit3.Text);
if trim(novoDirSaida)='' then
  begin
  messageDlg('É necessário informar novo diretório de saída para o arquivo.',mtInformation,[mbOk],0);
  Edit3.Text;
  exit;
  end;

screen.Cursor := crHourGlass;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT * FROM MAPADENOMES WHERE NOMEORIGINAL=:A01');
    Query01.Parameters[0].Value := nomeOriginal;
    Query01.Open;
    if not Query01.Eof then
      begin            
      Query02.SQL.Clear;
      Query02.SQL.Add('UPDATE MAPADENOMES SET NOMEORIGINAL=:A, NOVONOME=:B, NOVODIRSAIDA=:C WHERE NOMEORIGINAL=:D ');
      Query02.Parameters[0].Value := nomeOriginal2;
      Query02.Parameters[1].Value := novoNome;
      Query02.Parameters[2].Value := novoDirSaida;
      Query02.Parameters[3].Value := nomeOriginal;
      Query02.ExecSQL;
      end
    else
      begin
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO MAPADENOMES (NOMEORIGINAL, NOVONOME, NOVODIRSAIDA) VALUES (:A,:B,:C) ');
      Query02.Parameters[0].Value := nomeOriginal2;
      Query02.Parameters[1].Value := novoNome;
      Query02.Parameters[2].Value := novoDirSaida;
      Query02.ExecSQL;
      end;
    Query01.Close;
  except
    on e:exception do
      begin
      screen.Cursor := crDefault;
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
screen.Cursor := crDefault;
Close;
end;

procedure TfMapaDeNomes.BitBtn3Click(Sender: TObject);
begin
screen.Cursor := crHourGlass;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    qMapaDeNomesDEL.Parameters[0].Value := Edit1.Text;
    qMapaDeNomesDEL.ExecSQL;
  except
    on e:exception do
      begin
      screen.Cursor := crDefault;
      dbMulticold.RollbackTrans;
      messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
screen.Cursor := crDefault;
Close;
end;

end.
