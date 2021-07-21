unit usuRel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, Buttons, StdCtrls, System.UITypes;

type
  TfUsuRel = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox3: TComboBox;
    Label3: TLabel;
    ComboBox2: TComboBox;
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
    ListBox3: TListBox;
    Label4: TLabel;
    Label8: TLabel;
    ListBox4: TListBox;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
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

type tDfn=record
  codRel:String;
  nomeRel:String;
  end;

var
  fUsuRel: TfUsuRel;
  tTabela: TDataSet;

implementation

uses dataModule,principal, usuRelAdv;

{$R *.dfm}

function TfUsuRel.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfUsuRel.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

function TfUsuRel.localizaRelatorio(nomeRel:String):String;
var i : integer;
begin
i := pos(' : ',nomeRel);
result := trim(copy(nomeRel,1,i));
{
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

procedure TfUsuRel.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfUsuRel.FormShow(Sender: TObject);
begin
Label1.Caption := vpNomeDoGrupo;
Label2.Caption := vpNomeDoSistema;
Label3.Caption := vpNomeDoSubGrupo;
ComboBox1.Items.Clear;
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
//ComboBox4.Items.Clear;
ComboBox1.Text := '';
ComboBox2.Text := '';
ComboBox3.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
ListBox3.Items.Clear;
ListBox4.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfUsuRel.ComboBox1Change(Sender: TObject);
begin
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
//ComboBox4.Items.Clear;
ComboBox2.Text := '';
ComboBox3.Text := '';
//ComboBox4.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
ListBox3.Items.Clear;
with repositorioDeDados do
  begin
  Query01.Sql.Clear;
  Query01.Sql.Add(' SELECT DISTINCT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN ');
  Query01.SQL.Add(' WHERE 1=1 ');
  if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))))<>-999 then
    begin
    Query01.SQL.Add(' AND CODSIS=:A ');
    Query01.Parameters[0].Value := trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)));
    end;
  Query01.Sql.Add('ORDER BY CODGRUPO');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfUsuRel.ComboBox2Change(Sender: TObject);
var
  pCount:Integer;
begin
ComboBox3.Items.Clear;
//ComboBox4.Items.Clear;
ComboBox3.Text := '';
//ComboBox4.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
ListBox3.Items.Clear;
pCount := -1;
with repositorioDeDados do
  begin
  Query01.Sql.Clear;
  Query01.Sql.Add(' SELECT DISTINCT CODSUBGRUPO, NOMESUBGRUPO FROM SUBGRUPOSDFN ');
  Query01.SQL.Add(' WHERE 1=1 ');
  if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))))<>-999 then
    begin
    inc(pCount);
    Query01.Sql.Add(' AND CODSIS=:A ');
    Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
    end;
  if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
    begin
    inc(pCount);
    Query01.Sql.Add(' AND CODGRUPO=:B ');
    Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
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

procedure TfUsuRel.ComboBox3Change(Sender: TObject);
begin
//ComboBox4.Items.Clear;
//ComboBox4.Text := '';
ListBox1.Items.Clear;
ListBox2.Items.Clear;
ListBox3.Items.Clear;
with repositorioDeDados do
  begin
  Query01.Sql.Clear;
  Query01.Sql.Add('SELECT DISTINCT CODUSUARIO FROM USUARIOS ORDER BY CODUSUARIO');
  Query01.Open;
  while not Query01.Eof do
    begin
    //ComboBox4.Items.Add(Query01.Fields[0].asString);
    ListBox3.Items.Add(Query01.Fields[0].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfUsuRel.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfUsuRel.BitBtn1Click(Sender: TObject);
var
  i,
  j,
  pCount,
  codSis,
  codGrupo,
  codSubGrupo:Integer;
  //codUsu: String;
  arrUsu : array of string;
begin
//if (trim(upperCase(Copy(ComboBox4.Text,1,3))) <> 'INC') and
//   (trim(upperCase(Copy(ComboBox4.Text,1,3))) <> 'EXC') then
//  begin
//  messageDlg('É necessário selecionar o tipo de permissão!',mtWarning,[mbOk],0);
//  ComboBox4.SetFocus;
//  exit;
//  end;

if (ComboBox1.Text = '') or (ComboBox2.Text = '') or (ComboBox3.Text = '') then
  begin
  ShowMessage('Dados de inserção no banco inválidos, reveja');
  Exit;
  end;

codSis := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
codGrupo := strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
codSubGrupo := strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))));
setLength(arrUsu,ListBox3.SelCount);

j := 0;
for i := 0 to ListBox3.Items.Count-1 do
  if listBox3.Selected[i] then
    begin
    arrUsu[j] := ListBox3.Items.Strings[i];
    inc(j);
    end;
//codUsu := upperCase(trim(ComboBox4.Text));
//if codUsu='' then
if j = 0 then
  begin
  messageDlg('Selecione um usuário',mtWarning,[mbOk],0);
  //ComboBox4.SetFocus;
  ListBox3.SetFocus;
  exit;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    for i := 0 to j-1 do
      begin
      Query01.Sql.Clear;
      Query01.SQL.Add('SELECT CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, CODUSUARIO, TIPO');
      Query01.SQL.Add('FROM USUREL ');
      Query01.SQL.Add('WHERE 1=1');
      if codSis<>-999 then
        Query01.Sql.Add('AND CODSIS='+IntToStr(codSis)+' ');
      if codGrupo<>-999 then
        Query01.Sql.Add('AND CODGRUPO='+IntToStr(codGrupo)+' ');
      if codSubGrupo<>-999 then
        Query01.SQL.Add('AND CODSUBGRUPO='+IntToStr(codSubGrupo)+' ');
      Query01.SQL.Add('AND CODUSUARIO='''+arrUsu[i]+''' ');
      //QUery01.SQL.Add('AND TIPO='''+upperCase(Copy(ComboBox4.Text,1,3))+''' ');
      Query02.SQL.Clear;
      Query02.SQL.Add('DELETE FROM USUREL WHERE CODSIS=:A AND CODGRUPO=:B AND CODSUBGRUPO=:C AND CODREL=:D AND CODUSUARIO=:E'); // AND TIPO=:F');
      Query02.Prepared := true;
      Query01.Open;
      While not Query01.Eof do
        begin
        Query02.Parameters[0].Value := Query01.Fields[0].Value;
        Query02.Parameters[1].Value := Query01.Fields[1].Value;
        Query02.Parameters[2].Value := Query01.Fields[2].Value;
        Query02.Parameters[3].Value := Query01.Fields[3].Value;
        Query02.Parameters[4].Value := Query01.Fields[4].Value;
        //Query02.Parameters[5].Value := Query01.Fields[5].Value;
        Query02.ExecSQL;
        Query01.Next;
        end;
      Query01.Close;
      Query02.Prepared := false;

      if (codGrupo = -1) and ((ListBox1.Items.Count <> 0) or (ListBox4.Items.Count <> 0)) then
        begin
          if dbMulticold.InTransaction then
            dbMulticold.CommitTrans;
          ShowMessage('Código de '+ vpNomeDoGrupo + ' -1 só permitido para limpeza...');
          Exit;
        end;

      Query01.SQL.Clear;
      Query01.SQL.Add('INSERT INTO USUREL (CODSIS,CODGRUPO,CODSUBGRUPO,CODREL,CODUSUARIO,TIPO) VALUES (:A,:B,:C,:D,:E,:F)');
      Query01.Prepared := true;
      for pCount:=0 to ListBox1.Items.Count-1 do
        begin
        Query01.Parameters[0].Value := codSis;
        Query01.Parameters[1].Value := codGrupo;
        QUery01.Parameters[2].Value := codSubGrupo;
        Query01.Parameters[3].Value := localizaRelatorio(ListBox1.Items.Strings[pCount]);
        Query01.Parameters[4].Value := arrUsu[i];
        Query01.Parameters[5].Value := 'INC';
        Query01.ExecSQL;
        end;
      for pCount:=0 to ListBox4.Items.Count-1 do
        begin
        Query01.Parameters[0].Value := codSis;
        Query01.Parameters[1].Value := codGrupo;
        QUery01.Parameters[2].Value := codSubGrupo;
        Query01.Parameters[3].Value := localizaRelatorio(ListBox4.Items.Strings[pCount]);
        Query01.Parameters[4].Value := arrUsu[i];
        Query01.Parameters[5].Value := 'EXC';
        Query01.ExecSQL;
        end;
      Query01.Prepared := false;
      end;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
//Self.Close;
FormShow(Sender);
end;

procedure TfUsuRel.SpeedButton1Click(Sender: TObject);
var
  i : integer;
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

procedure TfUsuRel.SpeedButton3Click(Sender: TObject);
begin
while ListBox1.Items.Count > 0 do
  begin
  ListBox2.Items.Add(ListBox1.Items.Strings[0]);
  ListBox1.Items.Delete(0);
  end;
end;

procedure TfUsuRel.SpeedButton4Click(Sender: TObject);
var
  i : integer;
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

procedure TfUsuRel.SpeedButton5Click(Sender: TObject);
begin
while ListBox2.Items.Count > 0 do
  begin
  ListBox1.Items.Add(ListBox2.Items.Strings[0]);
  ListBox2.Items.Delete(0);
  end;
end;

procedure TfUsuRel.BitBtn3Click(Sender: TObject);
begin
self.Close;
fUsuRelAdv.showModal;
end;

procedure TfUsuRel.ListBox3Click(Sender: TObject);
var
  i : Integer;
  codUsu : string;
begin
ListBox1.Items.Clear;
ListBox2.Items.Clear;
ListBox4.Items.Clear;
codUsu := '';
for i := 0 to listBox3.Items.Count-1 do
  if listBox3.Selected[i] then
    codUsu := codUsu + '''' + listBox3.Items.Strings[i] + ''',';
codUsu := Copy(codUsu,1,length(codUsu)-1);

with repositorioDeDados do
  begin
  //pCount := 0;
  //Query01.Sql.Clear;
  //Query01.Sql.Add('SELECT DISTINCT CODREL, NOMEREL FROM DFN WHERE CODREL IN (SELECT CODREL FROM USUREL WHERE CODUSUARIO IN ('+codUsu+')) ');
  //Query01.Parameters[pCount].Value := codUsu;
  //if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))))<>-999 then
  //  begin
  //  //inc(pCount);
  //  //Query01.Sql.Add('AND (CODSIS=:B OR SISAUTO=''T'')');
  //  //Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
  //  Query01.Sql.Add('AND (CODSIS='+trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)))+' OR SISAUTO=''T'')');
  //  end;
  //if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
  //  begin
  //  //inc(pCount);
  //  //Query01.SQL.Add('AND (CODGRUPO=:C OR (CODGRUPAUTO=''T'' AND SISAUTO=''F'') OR (CODGRUPAUTO=''F'' AND SISAUTO=''T''))');
  //  //Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
  //  Query01.SQL.Add('AND (CODGRUPO='+trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)))+' OR (CODGRUPAUTO=''T'' AND SISAUTO=''F'') OR (CODGRUPAUTO=''F'' AND SISAUTO=''T''))');
  //  end;
  //if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
  //  begin
  //  //inc(pCount);
  //  //Query01.SQL.Add('AND CODSUBGRUPO=:D ');
  //  //Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))));
  //  Query01.SQL.Add('AND CODSUBGRUPO='+trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)))+' ');
  //  end;
  //Query01.Sql.Add(' ORDER BY CODREL');
  Query01.Sql.Clear;
//  Query01.Sql.Add('select a.codrel, a.nomerel, a.tipo ');
//  Query01.Sql.Add('from ');
//  Query01.Sql.Add('	( ');
//  Query01.Sql.Add('	select distinct a.codrel, a.nomerel, b.tipo ');
//  Query01.Sql.Add('	from dfn a join usurel b on a.codrel = b.codrel ');
//  Query01.Sql.Add('	where b.codusuario = '+codUsu+' ');
//  if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))))<>-999 then
//    Query01.SQL.Add(' and ((a.codsis = -1) or (a.codsis = ' + trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))) + ')) ');
//  if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
//    Query01.SQL.Add(' and ((a.codgrupo = ' + trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))) + ')) ');
//  if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
//    Query01.SQL.Add(' and ((a.codsubgrupo = ' + trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))) + ')) ');
//  Query01.Sql.Add('	union ');
//  Query01.Sql.Add('	select a.codrel, a.nomerel, '''' as tipo ');
//  Query01.Sql.Add('	from dfn a ');
//  Query01.Sql.Add('	where a.codrel not in (select codrel from usurel c where (c.codusuario = '+codUsu+') ');
//  if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))))<>-999 then
//    Query01.SQL.Add(' and ((a.codsis = ' + trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))) + ')) ');
//  if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
//    Query01.SQL.Add(' and ((a.codgrupo = ' + trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))) + ')) ');
//  if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
//    Query01.SQL.Add(' and ((a.codsubgrupo = ' + trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))) + ')) ');
//  Query01.Sql.Add('	) ');
//  Query01.Sql.Add('order by 1, 3 ');

Query01.Sql.Add('select a.codrel, a.nomerel, a.tipo ');
Query01.Sql.Add(' from ( ');
Query01.Sql.Add('      select distinct e.codrel, e.nomerel, b.tipo ');
Query01.Sql.Add('      from dfn e, usurel b ');
Query01.Sql.Add('      where e.codrel = b.codrel and b.codusuario = '+codUsu+' ');
if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)))) <> -999 then
  Query01.Sql.Add('      and (b.codsis = ' + trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))) + ') ');
if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
  Query01.Sql.Add('      and (b.codgrupo = ' + trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))) + ') ');
if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
  Query01.Sql.Add('      and (b.codsubgrupo = ' + trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))) + ') ');

Query01.Sql.Add(' union ');

Query01.Sql.Add(' select c.codrel, c.nomerel, '''' as tipo ');
Query01.Sql.Add(' from dfn c ');
Query01.Sql.Add(' where c.codrel not in ');
Query01.Sql.Add(' (select codrel from usurel d where (d.codusuario = '+codUsu+') ');

if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)))) <> -999 then
  Query01.Sql.Add('      and (d.codsis = ' + trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))) + ') ');
if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
  Query01.Sql.Add('      and (d.codgrupo = ' + trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))) + ') ');
if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
  Query01.Sql.Add('      and (d.codsubgrupo = ' + trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))) + ')) ');

if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)))) <> -999 then
  Query01.Sql.Add('      and (c.codsis = ' + trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))) + ') ');
if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
  Query01.Sql.Add('      and (c.codgrupo = ' + trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))) + ') ');
if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
  Query01.Sql.Add('      and (c.codsubgrupo = ' + trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))) + ') ');

Query01.Sql.Add(' union ');

Query01.Sql.Add(' select f.codrel, f.nomerel, '''' as tipo ');
Query01.Sql.Add(' from dfn f ');
Query01.Sql.Add(' where 1=1 ');

if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)))) <> -999 then
  Query01.Sql.Add('      and (f.codsis = ' + trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))) + ') ');

Query01.Sql.Add('      and (f.codgrupo = -1 )');

if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
  Query01.Sql.Add('      and (f.codsubgrupo = ' + trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))) + ') ');

Query01.Sql.Add(' ) a order by 1, 3 ');

//ListBox3.Items.Text := Query01.SQL.Text;

//ShowMessage('A');

  Query01.Open;
  while not Query01.Eof do
    begin
    if Query01.Fields[2].AsString = 'INC' then
      ListBox1.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString)
    else if Query01.Fields[2].AsString = 'EXC' then
      ListBox4.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString)
    else
      ListBox2.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString);
    Query01.Next;
    end;
  Query01.Close;
  ////pCount := 0;
  //Query01.Sql.Clear;
  //Query01.Sql.Add(' SELECT DISTINCT CODREL, NOMEREL FROM DFN WHERE CODREL NOT IN (SELECT CODREL FROM USUREL WHERE CODUSUARIO IN('+codUsu+')) ');
  ////Query01.Parameters[pCount].Value := codUsu;
  //if strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))))<>-999 then
  //  begin
  //  //inc(pCount);
  //  //Query01.Sql.Add(' AND (CODSIS=:B OR SISAUTO=''T'') ');
  //  //Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
  //  Query01.Sql.Add(' AND (CODSIS='+trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)))+' OR SISAUTO=''T'') ');
  //  end;
  //if strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))))<>-999 then
  //  begin
  //  //inc(pCount);
  //  //Query01.SQL.Add('AND (CODGRUPO=:C OR (CODGRUPAUTO=''T'' AND SISAUTO=''F'') OR (CODGRUPAUTO=''F'' AND SISAUTO=''T''))');
  //  //Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
  //  Query01.SQL.Add('AND (CODGRUPO='+trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)))+' OR (CODGRUPAUTO=''T'' AND SISAUTO=''F'') OR (CODGRUPAUTO=''F'' AND SISAUTO=''T''))');
  //  end;
  //if strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))))<>-999 then
  //  begin
  //  //inc(pCount);
  //  //Query01.SQL.Add(' AND CODSUBGRUPO=:D ');
  //  //Query01.Parameters[pCount].Value := strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))));
  //  Query01.SQL.Add(' AND CODSUBGRUPO='+trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)))+' ');
  //  end;
  //Query01.SQL.Add(' ORDER BY CODREL ');
  //Query01.Open;
  //while not Query01.Eof do
  //  begin
  //  ListBox2.Items.Add(Query01.Fields[0].AsString + ' : ' + QUery01.Fields[1].AsString);
  //  Query01.Next;
  //  end;
  //Query01.Close;
  end;
end;

procedure TfUsuRel.SpeedButton6Click(Sender: TObject);
var
  i : integer;
begin
i := 0;
while i <= ListBox2.Items.Count-1 do
  begin
  if ListBox2.Selected[i] then
    begin
    ListBox4.Items.Add(ListBox2.Items.Strings[i]);
    ListBox2.Items.Delete(i);
    end
  else
    Inc(i);
  end;
end;

procedure TfUsuRel.SpeedButton7Click(Sender: TObject);
begin
while ListBox2.Items.Count > 0 do
  begin
  ListBox4.Items.Add(ListBox2.Items.Strings[0]);
  ListBox2.Items.Delete(0);
  end;
end;

procedure TfUsuRel.SpeedButton8Click(Sender: TObject);
var
  i : integer;
begin
i := 0;
while i <= ListBox4.Items.Count-1 do
  begin
  if ListBox4.Selected[i] then
    begin
    ListBox2.Items.Add(ListBox4.Items.Strings[i]);
    ListBox4.Items.Delete(i);
    end
  else
    Inc(i);
  end;
end;

procedure TfUsuRel.SpeedButton9Click(Sender: TObject);
begin
while ListBox4.Items.Count > 0 do
  begin
  ListBox2.Items.Add(ListBox4.Items.Strings[0]);
  ListBox4.Items.Delete(0);
  end;
end;

end.
