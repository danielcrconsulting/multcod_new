unit grupoRel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, Buttons, StdCtrls, GrupoRelNovo, System.UITypes;

type
  TfGrupoRel = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox3: TComboBox;
    Label3: TLabel;
    ComboBox2: TComboBox;
    Label4: TLabel;
    ComboBox4: TComboBox;
    Label5: TLabel;
    ListBox1: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Label6: TLabel;
    ListBox2: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    BitBtn3: TBitBtn;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
    function getTabela:TDataSet;
    procedure setTabela(valor:TDataSet);
    function localizaRelatorio(nomeRel:String):String;
  public
    { Public declarations }
  published
    property tabela: TDataSet read getTabela write setTabela;
  end;

var
  fGrupoRel: TfGrupoRel;
  tTabela: TDataSet;

implementation

uses dataModule, principal;

{$R *.dfm}

function TfGrupoRel.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfGrupoRel.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

function TfGrupoRel.localizaRelatorio(nomeRel:String):String;
var i : integer;
begin
result := '';
i := pos(' : ',nomeRel);
result := trim(copy(nomeRel,1,i));
{ - Nome do relatório não é chave única
for i:=0 to high(arrDfn) do
  begin
  if arrDfn[i].nomeRel = nomeRel then
    begin
    result:= arrDfn[i].codRel;
    break;
    end;
  end;
}
end;

procedure TfGrupoRel.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfGrupoRel.FormShow(Sender: TObject);
begin
Label2.Caption := vpNomeDoSistema;
Label1.Caption := vpNomeDoGrupo;
Label3.Caption := vpNomeDoSubGrupo;
ComboBox1.Items.Clear;
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
ComboBox4.Items.Clear;
ComboBox1.Text := '';
ComboBox2.Text := '';
ComboBox3.Text := '';
ComboBox4.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
{
if Self.Tag=0 then
  begin
  ComboBox1.Text := tTabela.Fields[1].AsString;
  ComboBox1Change(Sender);
  ComboBox2.Text := tTabela.Fields[3].AsString;
  ComboBox2Change(Sender);
  ComboBox3.Text := tTabela.Fields[5].AsString;
  ComboBox3Change(Sender);
  ComboBox4.Text := tTabela.Fields[8].AsString;
  ComboBox4Change(Sender);
  end
}
end;

procedure TfGrupoRel.ComboBox1Change(Sender: TObject);
begin
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
ComboBox4.Items.Clear;
ComboBox2.Text := '';
ComboBox3.Text := '';
ComboBox4.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.Sql.Clear;
  Query01.Sql.Add('SELECT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN ');
  if strToInt(extraiCodigo(ComboBox1.Text))<>-999 then
    begin
    Query01.SQL.Add('WHERE CODSIS=:A01 ');
    Query01.Parameters[0].Value := extraiCodigo(ComboBox1.Text);
    end;
  Query01.Sql.Add('ORDER BY CODGRUPO');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfGrupoRel.ComboBox2Change(Sender: TObject);
var
  pCount:Integer;
begin
ComboBox3.Items.Clear;
ComboBox4.Items.Clear;
ComboBox3.Text := '';
ComboBox4.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
pCount := -1;
with repositorioDeDados do
  begin
  Query01.Sql.Clear;
  Query01.Sql.Add(' SELECT CODSUBGRUPO, NOMESUBGRUPO FROM SUBGRUPOSDFN ');
  Query01.SQL.Add(' WHERE 1=1 ');
  if strToInt(extraiCodigo(ComboBox1.Text))<>-999 then
    begin
    inc(pCount);
    Query01.Sql.Add(' AND CODSIS=:A01 ');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox1.Text);
    end;
  if strToInt(extraiCodigo(ComboBox2.Text))<>-999 then
    begin
    inc(pCount);
    Query01.Sql.Add(' AND CODGRUPO=:A02 ');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox2.Text);
    end;
  Query01.SQL.Add(' ORDER BY CODSUBGRUPO ');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox3.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfGrupoRel.ComboBox3Change(Sender: TObject);
begin
ComboBox4.Items.Clear;
ComboBox4.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.Sql.Clear;
  Query01.Sql.Add('SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS ORDER BY NOMEGRUPOUSUARIO');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox4.Items.Add(Query01.Fields[0].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfGrupoRel.ComboBox4Change(Sender: TObject);
var
  pCount:Integer;
  SqlAux : String;
begin
ListBox1.Items.Clear;
ListBox2.Items.Clear;

with repositorioDeDados do
  begin

  Query01.SQL.Clear;
  Query01.SQL.Add(' SELECT B.CODREL, A.NOMEREL, B.CODSIS, B.CODGRUPO, B.CODSUBGRUPO, B.TIPO ');
  Query01.SQL.Add(' FROM DFN A, GRUPOREL B ');
  Query01.SQL.Add(' WHERE (B.CODREL = A.CODREL) AND (B.NOMEGRUPOUSUARIO = :A) ');
  Query01.Parameters[0].Value := ComboBox4.Text;

  pCount := 0;

  if strToInt(extraiCodigo(ComboBox1.Text))<>-999 then
    begin
    inc(pCount);
    Query01.Sql.Add('AND (B.CODSIS=:A02)');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox1.Text);
    end;
  if strToInt(extraiCodigo(ComboBox2.Text))<>-999 then
    begin
    inc(pCount);
    Query01.SQL.Add('AND (B.CODGRUPO=:A03)');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox2.Text);
    end;
  if strToInt(extraiCodigo(ComboBox3.Text))<>-999 then
    begin
    inc(pCount);
    Query01.SQL.Add('AND B.CODSUBGRUPO=:A04 ');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox3.Text);
    end;
  Query01.Sql.Add(' ORDER BY B.CODREL');

  Query01.Open;

  while not Query01.Eof do
    begin
    ListBox1.Items.Add(Query01.Fields[0].asString + ' : ' + ' ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;

{
  pCount := 0;
  Query01.Sql.Clear;
  Query01.Sql.Add('SELECT DISTINCT CODREL, NOMEREL FROM DFN WHERE CODREL IN (SELECT CODREL FROM GRUPOREL WHERE NOMEGRUPOUSUARIO=:A01) ');
  Query01.Parameters[pCount].Value := ComboBox4.Text;
  if strToInt(extraiCodigo(ComboBox1.Text))<>-999 then
    begin
    inc(pCount);
    Query01.Sql.Add('AND (CODSIS=:A02 OR SISAUTO=''T'')');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox1.Text);
    end;
  if strToInt(extraiCodigo(ComboBox2.Text))<>-999 then
    begin
    inc(pCount);
    Query01.SQL.Add('AND (CODGRUPO=:A03 OR (CODGRUPAUTO=''T'' AND SISAUTO=''F'') OR (CODGRUPAUTO=''F'' AND SISAUTO=''T''))');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox2.Text);
    end;
  if strToInt(extraiCodigo(ComboBox3.Text))<>-999 then
    begin
    inc(pCount);
    Query01.SQL.Add('AND CODSUBGRUPO=:A04 ');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox3.Text);
    end;
  Query01.Sql.Add(' ORDER BY CODREL');
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox1.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
}

  pCount := -1;
  Query01.Close;
  Query01.Sql.Clear;
  SqlAux := '(';
  SqlAux := SqlAux + 'SELECT CODREL FROM GRUPOREL WHERE (NOMEGRUPOUSUARIO=';
  SqlAux := SqlAux + '''' + ComboBox4.Text + ''')' ;
  if strToInt(extraiCodigo(ComboBox1.Text))<>-999 then
    begin
    SqlAux := SqlAux + ' AND (CODSIS=';
    SqlAux := SqlAux + extraiCodigo(ComboBox1.Text) + ')';
    end;
  if strToInt(extraiCodigo(ComboBox2.Text))<>-999 then
    begin
    SqlAux := SqlAux + ' AND (CODGRUPO=';
    SqlAux := SqlAux + extraiCodigo(ComboBox2.Text) + ')';
    end;
  if strToInt(extraiCodigo(ComboBox3.Text))<>-999 then
    begin
    SqlAux := SqlAux + ' AND (CODSUBGRUPO=';
    SqlAux := SqlAux + extraiCodigo(ComboBox3.Text) + ')';
    end;
  SqlAux := SqlAux + ')';

  Query01.Sql.Add('SELECT DISTINCT CODREL, NOMEREL FROM DFN WHERE (CODREL NOT IN ' + SqlAux + ') ');

  if strToInt(extraiCodigo(ComboBox1.Text))<>-999 then
    begin
    inc(pCount);
    Query01.Sql.Add('AND (CODSIS=:A01 OR SISAUTO=''T'')');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox1.Text);
    end;

  if strToInt(extraiCodigo(ComboBox2.Text))<>-999 then
    begin
    inc(pCount);
    Query01.SQL.Add('AND (CODGRUPO=:A02 OR (CODGRUPAUTO=''T'' AND SISAUTO=''F'') OR (CODGRUPAUTO=''F'' AND SISAUTO=''T''))');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox2.Text);
    end;

  if strToInt(extraiCodigo(ComboBox3.Text))<>-999 then
    begin
    inc(pCount);
    Query01.SQL.Add('AND CODSUBGRUPO=:A03 ');
    Query01.Parameters[pCount].Value := extraiCodigo(ComboBox3.Text);
    end;

  Query01.Sql.Add(' ORDER BY CODREL');
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox2.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfGrupoRel.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfGrupoRel.BitBtn1Click(Sender: TObject);
var
  pCount,
  codSis,
  codGrupo,
  codSubGrupo:Integer;
  codUsu: String;
begin
codSis := strToInt(repositorioDeDados.extraiCodigo(ComboBox1.Text));
codGrupo := strToInt(repositorioDeDados.extraiCodigo(ComboBox2.Text));
codSubGrupo := strToInt(repositorioDeDados.extraiCodigo(ComboBox3.Text));
codUsu := upperCase(trim(ComboBox4.Text));
if codUsu='' then
  begin
  messageDlg('Selecione um grupo de usuários',mtWarning,[mbOk],0);
  ComboBox4.SetFocus;
  exit;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try

    (* -- Grupo não deve sobrepor as permissões individuais de cada usuário
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUREL WHERE CODUSUARIO IN (SELECT CODUSUARIO FROM GRUPOREL WHERE NOMEGRUPOUSUARIO=:A01) ');
    Query01.Parameters[pCount].Value := codUsu;
    if codSis<>-999 then
      begin
      inc(pCount);
      Query01.Sql.Add('AND CODSIS=:A02');
      Query01.Parameters[pCount].Value := codSis;
      end;
    if codGrupo<>-999 then
      begin
      inc(pCount);
      Query01.Sql.Add('AND CODGRUPO=:A03');
      Query01.Parameters[pCount].Value := codGrupo;
      end;
    if codSubGrupo<>-999 then
      begin
      inc(pCount);
      Query01.SQL.Add('AND CODSUBGRUPO=:A04');
      Query01.Parameters[pCount].Value := codSubGrupo;
      end;
    Query01.ExecSQL;
    *)

    Query01.SQL.Clear;
    Query01.SQL.Add(' SELECT A.CODUSUARIO, B.CODSIS, B.CODGRUPO, B.CODSUBGRUPO, B.CODREL, B.TIPO ');
    Query01.SQL.Add(' FROM USUARIOSEGRUPOS A, GRUPOREL B ');
    Query01.SQL.Add(' WHERE A.NOMEGRUPOUSUARIO = B.NOMEGRUPOUSUARIO ');
    Query01.SQL.Add(' AND A.NOMEGRUPOUSUARIO = :A ');
    Query01.Parameters[0].Value := codUsu;
    Query01.Open;
    Query02.SQL.Clear;
    Query02.SQL.Add(' DELETE FROM USUREL WHERE CODUSUARIO = :A AND CODSIS = :B AND CODGRUPO = :C AND CODSUBGRUPO = :D AND CODREL = :E ');
    Query02.Prepared := true;
    while not Query01.Eof do
      begin
      Query02.Parameters[0].Value := Query01.Fields[0].Value;
      Query02.Parameters[1].Value := Query01.Fields[1].Value;
      Query02.Parameters[2].Value := Query01.Fields[2].Value;
      Query02.Parameters[3].Value := Query01.Fields[3].Value;
      Query02.Parameters[4].Value := Query01.Fields[4].Value;
      Query02.ExecSQL;
      Query01.Next;
      end;
    Query01.Close;
    Query02.Prepared := false;

    pCount:=0;
    Query02.Sql.Clear;
    Query02.Sql.Add('DELETE FROM GRUPOREL WHERE NOMEGRUPOUSUARIO=:A01');
    Query02.Parameters[pCount].Value := codUsu;
    if codSis<>-999 then
      begin
      inc(pCount);
      Query02.Sql.Add('AND CODSIS=:A02');
      Query02.Parameters[pCount].Value := codSis;
      end;
    if codGrupo<>-999 then
      begin
      inc(pCount);
      Query02.Sql.Add('AND CODGRUPO=:A03');
      Query02.Parameters[pCount].Value := codGrupo;
      end;
    if codSubGrupo<>-999 then
      begin
      inc(pCount);
      Query02.SQL.Add('AND CODSUBGRUPO=:A04');
      Query02.Parameters[pCount].Value := codSubGrupo;
      end;
    Query02.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('INSERT INTO GRUPOREL (CODSIS,CODGRUPO,CODSUBGRUPO,CODREL,NOMEGRUPOUSUARIO,TIPO) VALUES (:A01,:A02,:A03,:A04,:A05,:A06)');
    Query01.Prepared := true;
    for pCount:=0 to ListBox1.Items.Count-1 do
      begin
      Query01.Parameters[0].Value := codSis;
      Query01.Parameters[1].Value := codGrupo;
      QUery01.Parameters[2].Value := codSubGrupo;
      Query01.Parameters[3].Value := localizaRelatorio(ListBox1.Items.Strings[pCount]);
      Query01.Parameters[4].Value := codUsu;
      Query01.Parameters[5].Value := 'INC';
      try
        Query01.ExecSQL;
      except
      end; // try
      end;
    Query01.Prepared := false;

    // Limpa usurel para evitar duplicidades
    Query01.SQL.Clear;
    Query01.SQL.Add(' SELECT A.CODUSUARIO, B.CODSIS, B.CODGRUPO, B.CODSUBGRUPO, B.CODREL, B.TIPO ');
    Query01.SQL.Add(' FROM USUARIOSEGRUPOS A, GRUPOREL B ');
    Query01.SQL.Add(' WHERE A.NOMEGRUPOUSUARIO = B.NOMEGRUPOUSUARIO ');
    Query01.SQL.Add(' AND B.NOMEGRUPOUSUARIO = :A ');
    Query01.Parameters[0].Value := codUsu;
    Query01.Open;
    Query02.SQL.Clear;
    Query02.SQL.Add('DELETE FROM USUREL WHERE CODUSUARIO=:A AND CODSIS=:B AND CODGRUPO=:C AND CODSUBGRUPO=:D AND CODREL=:E');
    Query02.Prepared := true;
    while not Query01.Eof do
      begin
      Query02.Parameters[0].Value := Query01.Fields[0].Value;
      Query02.Parameters[1].Value := Query01.Fields[1].Value;
      Query02.Parameters[2].Value := Query01.Fields[2].Value;
      Query02.Parameters[3].Value := Query01.Fields[3].Value;
      Query02.Parameters[4].Value := Query01.Fields[4].Value;
      Query02.ExecSQL;
      Query01.Next;
      end;
    Query02.Prepared := false;
    Query01.Close;

    // Aplica as permissões em USUREL pq o sistema de autenticação só verifica uma tabela
    Query01.SQL.Clear;
    Query01.SQL.Add(' INSERT INTO USUREL (CODUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO) ');
    Query01.SQL.Add(' SELECT A.CODUSUARIO, B.CODSIS, B.CODGRUPO, B.CODSUBGRUPO, B.CODREL, B.TIPO ');
    Query01.SQL.Add(' FROM USUARIOSEGRUPOS A, GRUPOREL B ');
    Query01.SQL.Add(' WHERE A.NOMEGRUPOUSUARIO = B.NOMEGRUPOUSUARIO ');
    Query01.SQL.Add(' AND B.NOMEGRUPOUSUARIO = :A ');
    Query01.Parameters[0].Value := codUsu;
    Query01.ExecSQL;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    begin
    dbMulticold.CommitTrans;
    end;
  end;
//Self.Close;
FormShow(Sender);
end;

procedure TfGrupoRel.SpeedButton1Click(Sender: TObject);
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

procedure TfGrupoRel.SpeedButton3Click(Sender: TObject);
begin
while ListBox1.Items.Count > 0 do
  begin
  ListBox2.Items.Add(ListBox1.Items.Strings[0]);
  ListBox1.Items.Delete(0);
  end;
end;

procedure TfGrupoRel.SpeedButton4Click(Sender: TObject);
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

procedure TfGrupoRel.SpeedButton5Click(Sender: TObject);
begin
while ListBox2.Items.Count > 0 do
  begin
  ListBox1.Items.Add(ListBox2.Items.Strings[0]);
  ListBox2.Items.Delete(0);
  end;
end;

procedure TfGrupoRel.BitBtn3Click(Sender: TObject);
begin
fGrupoRelNovo.ShowModal;
end;

end.
