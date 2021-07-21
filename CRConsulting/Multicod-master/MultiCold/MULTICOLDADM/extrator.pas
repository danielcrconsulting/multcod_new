unit extrator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DB, System.UITypes;

type
  TfExtrator = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    ComboBox1: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
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
  fExtrator: TfExtrator;
  tTabela : TDataSet;
  codSis,
  codGrupo : Integer;
  codRel : String;

implementation

uses dataModule, principal;

{$R *.dfm}

function TfExtrator.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfExtrator.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfExtrator.FormShow(Sender: TObject);
begin
label2.Caption := vpNomeDoSistema;
label3.Caption := vpNomeDoGrupo;
ComboBox4.Items.Clear;
ComboBox5.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  While not Query01.Eof do
    begin
    ComboBox4.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    if (fExtrator.Tag = 0) and (tTabela.Fields[1].AsInteger = Query01.Fields[0].AsInteger) then
      ComboBox4.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;
ComboBox4Change(Sender);
ComboBox5Change(Sender);
if (fExtrator.Tag = 0) then
  begin
  Edit1.Text := tTabela.Fields[3].AsString;
  Edit2.Text := tTabela.Fields[4].AsString;
  Edit5.Text := tTabela.Fields[7].AsString;
  Edit6.Text := tTabela.Fields[8].AsString;
  // Diretório explícito
  if tTabela.Fields[5].Value = 'S' then
    ComboBox2.Text := ComboBox2.Items.Strings[0]
  else if tTabela.Fields[5].Value = 'N' then
    ComboBox2.Text := ComboBox2.Items.Strings[1]
  else
    ComboBox2.Text := '';
  // Operação
  if tTabela.Fields[6].Value = 'A' then
    ComboBox3.Text := ComboBox3.Items.Strings[0]
  else if tTabela.Fields[6].Value = 'N' then
    ComboBox3.Text := ComboBox3.Items.Strings[1]
  else if tTabela.Fields[6].Value = 'S' then
    ComboBox3.Text := ComboBox3.Items.Strings[2]
  else
    ComboBox3.Text := '';
  end
else
  begin
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  ComboBox3.Text := '';
  ComboBox4.Text := '';
  ComboBox5.Text := '';
  Edit1.Text := '';
  Edit2.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  end;
codRel := trim(Copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text)));
Application.ProcessMessages;
end;

procedure TfExtrator.ComboBox1Change(Sender: TObject);
begin
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT A.CODSIS, A.NOMESIS, B.CODGRUPO, B.NOMEGRUPO FROM SISTEMA A, GRUPOSDFN B, DFN C WHERE A.CODSIS=C.CODSIS AND B.CODSIS=C.CODSIS AND B.CODGRUPO=C.CODGRUPO AND C.CODREL='''+trim(copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text)))+'''');
  Query01.Open;
  if not Query01.Eof then
    begin
    codSis := Query01.Fields[0].Value;
    codGrupo := Query01.Fields[2].Value;
    ComboBox4.Text := Query01.Fields[1].AsString;
    ComboBox5.Text := Query01.Fields[3].AsString;
    end;
  Query01.Prepared := false;
  Query01.Close;
  end;
end;

procedure TfExtrator.BitBtn1Click(Sender: TObject);
var
  codRel2,
  codGrupo2,
  codSis2,
  xtr,
  destino,
  subdir,
  arquivo,
  dirExpl,
  operacao : variant;
begin

codSis2 := Copy(ComboBox4.Text,1,Pos(' : ',ComboBox4.Text));
if trim(codSis2)='' then
  begin
  messageDlg('Selecione o sistema.',mtInformation,[mbOk],0);
  ComboBox4.SetFocus;
  exit;
  end;

codGrupo2 := Copy(ComboBox5.Text,1,Pos(' : ',ComboBox5.Text));
if trim(codGrupo2)='' then
  begin
  messageDlg('Selecione o grupo.',mtInformation,[mbOk],0);
  ComboBox5.SetFocus;
  exit;
  end;

codRel2 := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text));
if trim(codRel2)='' then
  begin
  messageDlg('É necessário informar o código do relatório.',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;

xtr := upperCase(Edit1.Text);
if trim(xtr)='' then
  begin
  messageDlg('É necessário informar o XTR.',mtInformation,[mbOk],0);
  Edit1.SetFocus;
  exit;
  end;

destino := upperCase(Edit2.Text);
if trim(destino)='' then
  begin
  messageDlg('É necessário informar o destino.',mtInformation,[mbOk],0);
  Edit2.SetFocus;
  exit;
  end;

if ComboBox2.Items.IndexOf(ComboBox2.Text) = 0 then
  dirExpl := 'S'
else if ComboBox2.Items.IndexOf(ComboBox2.Text) = 1 then
  dirExpl := 'N';

if ComboBox3.Items.IndexOf(ComboBox3.Text) = 0 then
  operacao := 'A'
else if ComboBox3.Items.IndexOf(ComboBox3.Text) = 1 then
  operacao := 'N'
else if ComboBox3.Items.IndexOf(ComboBox3.Text) = 2 then
  operacao := 'S'
else
  begin
  messageDlg('É necessário informar o tipo de operação.', mtInformation, [mbOk], 0);
  comboBox3.SetFocus;
  exit;
  end;

subdir := upperCase(edit5.text);
if trim(subDir)='' then
  subDir := null;

arquivo := upperCase(edit6.Text);
if trim(arquivo)='' then
  arquivo := null;

with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    // Tenta apagar o registro original
    Query02.SQL.Clear;
    Query02.SQL.Add('DELETE FROM EXTRATOR WHERE CODREL = :A AND CODGRUPO = :B AND CODSIS = :C ');
    Query02.SQL.Add('AND XTR = :D AND DESTINO = :E AND DIREXPL = :F ');
    Query02.SQL.Add('AND OPERACAO = :G AND SUBDIR = :H AND ARQUIVO = :I ');
    Query02.Parameters[0].Value := tTabela.Fields[0].AsString;
    Query02.Parameters[1].Value := tTabela.Fields[2].AsInteger;
    Query02.Parameters[2].Value := tTabela.Fields[1].AsInteger;
    Query02.Parameters[3].Value := tTabela.Fields[3].AsString;
    Query02.Parameters[4].Value := tTabela.Fields[4].AsString;
    Query02.Parameters[5].Value := tTabela.Fields[5].AsString;
    Query02.Parameters[6].Value := tTabela.Fields[6].AsString;
    Query02.Parameters[7].Value := tTabela.Fields[7].AsString;
    Query02.Parameters[8].Value := tTabela.Fields[8].AsString;
    Query02.ExecSQL;
    // Tenta apagar o registro modificado
{    Query02.SQL.Clear;
    Query02.SQL.Add('DELETE FROM EXTRATOR WHERE CODREL = :A AND CODGRUPO = :B AND CODSIS = :C');
    Query02.Parameters[0].Value := codRel2;
    Query02.Parameters[1].Value := codGrupo2;
    Query02.Parameters[2].Value := codSis2;
    Query02.ExecSQL;               }
    // Salva o registro novo/modificado
    Query02.SQL.Clear;
    Query02.SQL.Add('INSERT INTO EXTRATOR (CODREL, CODSIS, CODGRUPO, XTR, DESTINO, DIREXPL, OPERACAO, SUBDIR, ARQUIVO) VALUES (:A,:B,:C,:D,:E,:F,:G,:H,:I) ');
    Query02.Parameters[0].Value := codRel2;
    Query02.Parameters[1].Value := codSis2;
    Query02.Parameters[2].Value := codGrupo2;
    Query02.Parameters[3].Value := xtr;
    Query02.Parameters[4].Value := destino;
    Query02.Parameters[5].Value := dirExpl;
    Query02.Parameters[6].Value := operacao;
    Query02.Parameters[7].Value := subdir;
    Query02.Parameters[8].Value := arquivo;
    Query02.ExecSQL;
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
fExtrator.Close;
end;

procedure TfExtrator.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfExtrator.BitBtn3Click(Sender: TObject);
Var
  dirExpl,
  operacao : variant;
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM EXTRATOR WHERE CODSIS = :A AND CODGRUPO = :B AND CODREL = :C ');
    Query01.SQL.Add('AND XTR = :D AND DESTINO = :E AND DIREXPL = :F ');
    Query01.SQL.Add('AND OPERACAO = :G AND SUBDIR = :H AND ARQUIVO = :I ');
    Query01.Parameters[0].Value := Copy(ComboBox4.Text,1,Pos(' : ',ComboBox4.Text));
    Query01.Parameters[1].Value := Copy(ComboBox5.Text,1,Pos(' : ',ComboBox5.Text));
    Query01.Parameters[2].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text));

    if ComboBox2.Items.IndexOf(ComboBox2.Text) = 0 then
      dirExpl := 'S'
    else
    if ComboBox2.Items.IndexOf(ComboBox2.Text) = 1 then
      dirExpl := 'N';

    if ComboBox3.Items.IndexOf(ComboBox3.Text) = 0 then
      operacao := 'A'
    else
    if ComboBox3.Items.IndexOf(ComboBox3.Text) = 1 then
      operacao := 'N'
    else
    if ComboBox3.Items.IndexOf(ComboBox3.Text) = 2 then
      operacao := 'S';

    Query01.Parameters[3].Value := Edit1.Text;
    Query01.Parameters[4].Value := Edit2.Text;
    Query01.Parameters[5].Value := dirExpl;
    Query01.Parameters[6].Value := operacao;
    Query01.Parameters[7].Value := Edit5.Text;
    Query01.Parameters[8].Value := Edit6.Text;

    Query01.ExecSQL;

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
fExtrator.Close;
end;

procedure TfExtrator.SpeedButton2Click(Sender: TObject);
begin
fExtrator.Close;
end;

procedure TfExtrator.ComboBox4Change(Sender: TObject);
var
  codSis2 : string;
begin
ComboBox5.Items.Clear;
with repositorioDeDados do
  begin
  codSis2 := trim(copy(ComboBox4.Text,1,pos(' : ',ComboBox4.Text)-1));
  Query01.SQL.Clear;
  Query01.SQL.Add(' SELECT DISTINCT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN ');
  if (codSis2 <> '') and (codSis2 <> '-999') then
    begin
    Query01.SQL.Add(' WHERE CODSIS = :A ');
    Query01.Parameters[0].Value := codSis2;
    end;
  Query01.SQL.Add(' ORDER BY CODGRUPO ');
  Query01.Open;
  While not Query01.Eof do
    begin
    ComboBox5.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    if (fExtrator.Tag = 0) and (tTabela.Fields[2].AsInteger = Query01.Fields[0].AsInteger) then
      ComboBox5.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfExtrator.ComboBox5Change(Sender: TObject);
var
  codSis2,
  codGrupo2 : string;
//  i : integer;
begin
ComboBox1.Items.Clear;
with repositorioDeDados do
  begin
  codSis2 := Copy(ComboBox4.Text,1,Pos(' : ',ComboBox4.Text)-1);
  codGrupo2 := Copy(ComboBox5.Text,1,Pos(' : ',ComboBox5.Text)-1);

//  i := -1;

  Query01.SQL.Clear;
  Query01.SQL.Add(' SELECT DISTINCT CODREL, NOMEREL FROM DFN WHERE ');
  {
  if (codSis2 <> '') and (codSis2 <> '-999') then
    begin
    inc(i);
    Query01.SQL.Add(' CODSIS = :A AND ');
    Query01.Parameters[i].Value := codSis2;
    end;

  if (codGrupo2 <> '') and (codGrupo2 <> '-999') then
    begin
    inc(i);
    Query01.SQL.Add(' CODGRUPO = :B AND ');
    Query01.Parameters[i].Value := codGrupo2;
    end;
  }
  Query01.SQL.Add(' 1 = 1 ORDER BY CODREL');

  Query01.Open;
  While not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString);
    if (fExtrator.Tag = 0) and (trim(tTabela.Fields[0].AsString) = trim(Query01.Fields[0].AsString)) then
      ComboBox1.Text := Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

end.
