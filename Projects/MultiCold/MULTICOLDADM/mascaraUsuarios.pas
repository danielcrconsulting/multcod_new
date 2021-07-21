unit mascaraUsuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, DBCtrls, StdCtrls, DB, System.UITypes;

type
  TfMascaraUsuarios = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    ListBox2: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ListBox1: TListBox;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
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
  fMascaraUsuarios: TfMascaraUsuarios;
  tTabela : TDataSet;

implementation

uses dataModule;

{$R *.dfm}

function TfMascaraUsuarios.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfMascaraUsuarios.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfMascaraUsuarios.ComboBox1Change(Sender: TObject);
begin
ComboBox2.Text := '';
ComboBox2.Items.Clear;
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT NOMECAMPO FROM MASCARACAMPO WHERE CODREL = '''+ComboBox1.Text+''' ORDER BY CODREL');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfMascaraUsuarios.ComboBox2Change(Sender: TObject);
begin
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODUSUARIO FROM USUARIOMASCARA WHERE CODREL = '''+ComboBox1.Text+''' AND NOMECAMPO = '''+ComboBox2.Text+'''');
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox1.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODUSUARIO FROM USUARIOS WHERE CODUSUARIO NOT IN (SELECT CODUSUARIO FROM USUARIOMASCARA WHERE CODREL = '''+ComboBox1.Text+''' AND NOMECAMPO = '''+ComboBox2.Text+''')');
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox2.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfMascaraUsuarios.SpeedButton2Click(Sender: TObject);
begin
fMascaraUsuarios.Close;
end;

procedure TfMascaraUsuarios.BitBtn1Click(Sender: TObject);
var i : integer;
begin

if trim(ComboBox1.Text)='' then
  begin
  messageDlg('É necessário informar o relatório.',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;

if trim(ComboBox2.Text)='' then
  begin
  messageDlg('É necessário informar o usuário.',mtInformation,[mbOk],0);
  ComboBox2.SetFocus;
  exit;
  end;

screen.Cursor := crHourGlass;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOMASCARA WHERE CODREL = :A01 AND NOMECAMPO = :A02');
    Query01.Parameters[0].Value := upperCase(ComboBox1.Text);
    Query01.Parameters[1].Value := upperCase(ComboBox2.Text);
    Query01.ExecSQL;
    Query01.SQL.Clear;
    Query01.SQL.Add('INSERT INTO USUARIOMASCARA (CODREL, NOMECAMPO, CODUSUARIO) VALUES(:A01,:A02,:A03)');
    Query01.Prepared := true;
    for i := 0 to ListBox1.Items.Count-1 do
      begin
      Query01.Parameters[0].Value := upperCase(ComboBox1.Text);
      Query01.Parameters[1].Value := upperCase(ComboBox2.Text);
      Query01.Parameters[2].Value := upperCase(ListBox1.Items.Strings[i]);
      Query01.ExecSQL;
      end;
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
//Self.Close;
FormShow(Sender);
end;

procedure TfMascaraUsuarios.SpeedButton1Click(Sender: TObject);
var i : integer;
begin
i := 0;
while i <= ListBox1.Items.Count-1 do
  begin
  if ListBox1.Selected[i] then
    begin
    ListBox2.Items.Add(ListBox1.Items.Strings[i]);
    ListBox1.Items.Delete(i);
    end
  else
    Inc(i);
  end;
end;

procedure TfMascaraUsuarios.SpeedButton4Click(Sender: TObject);
var i : integer;
begin
i := 0;
while i <= ListBox2.Items.Count-1 do
  begin
  if ListBox2.Selected[i] then
    begin
    ListBox1.Items.Add(ListBox2.Items.Strings[i]);
    ListBox2.Items.Delete(i);
    end
  else
    Inc(i);
  end;
end;

procedure TfMascaraUsuarios.SpeedButton3Click(Sender: TObject);
begin
while ListBox1.Items.Count > 0 do
  begin
  ListBox2.Items.Add(ListBox1.Items.Strings[0]);
  ListBox1.Items.Delete(0);
  end;
end;

procedure TfMascaraUsuarios.SpeedButton5Click(Sender: TObject);
begin
while ListBox2.Items.Count > 0 do
  begin
  ListBox1.Items.Add(ListBox2.Items.Strings[0]);
  ListBox2.Items.Delete(0);
  end;
end;

procedure TfMascaraUsuarios.FormShow(Sender: TObject);
begin
ComboBox1.Text := '';
ComboBox2.Text := '';
ComboBox1.Items.Clear;
ComboBox2.Items.Clear;
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODREL FROM DFN ORDER BY CODREL');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;
  end;
{
if (fMascaraUsuarios.Tag = 0) then
  begin
  ComboBox1.Text := tTabela.Fields[0].AsString;
  ComboBox2.Text := tTabela.Fields[1].AsString;
  ComboBox2Change(Sender);
  end;
}
end;

procedure TfMascaraUsuarios.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

end.
