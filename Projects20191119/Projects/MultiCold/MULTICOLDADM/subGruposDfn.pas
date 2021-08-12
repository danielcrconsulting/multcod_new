unit subGruposDfn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, StdCtrls, Buttons, System.UITypes;

type
  TfSubGruposDfn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
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
  fSubGruposDfn: TfSubGruposDfn;
  tTabela : TDataSet;

implementation

uses dataModule,principal;

{$R *.dfm}

function TfSubGruposDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfSubGruposDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfSubGruposDfn.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfSubGruposDfn.FormShow(Sender: TObject);
begin
label1.Caption := vpNomeDoSistema;
fSubGruposDfn.Caption := vpNomeDoSubGrupo;
Label2.Caption := vpNomeDoGrupo;
ComboBox1.Items.Clear;
ComboBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString+' : '+Query01.Fields[1].AsString);
    if (fSubGruposDfn.Tag = 0) and (tTabela.Fields[0].asInteger = Query01.Fields[0].asInteger) then
      ComboBox1.Text := Query01.Fields[0].AsString+' : '+Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
if fSubGruposDfn.Tag = 0 then
  begin
  ComboBox1Change(Sender);
{
  with repositorioDeDados do
    begin
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT NOMEGRUPO FROM GRUPOSDFN WHERE CODSIS = ? AND CODGRUPO = ?');
    Query01.Parameters[0].Value := tTabela.fields[0].asInteger;
    Query01.Parameters[1].Value := tTabela.Fields[1].asInteger;
    Query01.Open;
    if not Query01.Eof then
      ComboBox2.Text := Query01.Fields[0].asString;
    Query01.Close;
    end;
}
  Edit1.Text := tTabela.Fields[2].AsString;
  Edit2.Text := tTabela.Fields[3].AsString;
  end
else
  begin
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  Edit1.Text := '';
  Edit2.Text := '';
  end;

end;

procedure TfSubGruposDfn.ComboBox1Change(Sender: TObject);
begin
ComboBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN WHERE CODSIS=:A01 ORDER BY CODGRUPO');
  Query01.Parameters[0].Value := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].asString+' : '+QUery01.Fields[1].asString);
    if (fSubGruposDfn.Tag = 0) and (tTabela.Fields[1].asInteger = Query01.Fields[0].asInteger) then
      ComboBox2.Text := Query01.Fields[0].AsString+' : '+Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfSubGruposDfn.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//setLength(arrSistema,0);
//setLength(arrGrupo,0);
end;

procedure TfSubGruposDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfSubGruposDfn.BitBtn3Click(Sender: TObject);
var
  codSis,
  codGrupo,
  codSubGrupo: Integer;
begin
try
  codSis := StrToInt(Trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
except
  on e:exception do  //if codSis=-1 then
    begin
    messageDlg('É necessário informar o sistema!',mtInformation,[mbOk],0);
    ComboBox1.SetFocus;
    exit;
    end;
  end; // try

try
  codGrupo := StrToInt(Trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
except
  on e:exception do //if codGrupo=-1 then
    begin
    messageDlg('É necessário informar o grupo!',mtInformation,[mbOk],0);
    ComboBox2.SetFocus;
    exit;
    end;
  end; // try

try
  codSubGrupo := strToInt(Edit1.Text);
except
  on e:exception do
    begin
    messageDlg('O código do subgrupo deve ser um valor numérico.',mtInformation,[mbOk],0);
    Edit1.SetFocus;
    exit;
    end;
  end;

if messageDlg('Ao excluir um subgrupo você apagará todas as informações relacionadas a ele.',mtConfirmation,[mbOk,mbCancel],0)=mrCancel then
  exit;

with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUREL WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOREL WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSBIN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSTXT WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOMASCARA WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM MASCARACAMPO WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM RELATOCD WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM EXTRATOR WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM INDICESDFN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DESTINOSDFN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DFN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM SUBGRUPOSDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.ExecSQL;

  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro apagando dados'+#10#13+'Detalhes do erro:'+#10#13+e.message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
Self.Close;
end;

procedure TfSubGruposDfn.BitBtn1Click(Sender: TObject);
var
  codSis,
  codGrupo,
  codSubGrupo: integer;
  nomeSubGrupo: String;
begin
codSis :=  StrToInt(Trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
codGrupo :=  StrToInt(Trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
{
if codSis=-1 then
  begin
  messageDlg('É necessário informar o sistema!',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;
if codGrupo=-1 then
  begin
  messageDlg('É necessário informar o grupo!',mtInformation,[mbOk],0);
  ComboBox2.SetFocus;
  exit;
  end;
}
try
  codSubGrupo := strToInt(Edit1.Text);
except
  on e:exception do
    begin
    messageDlg('O código do subgrupo deve ser um valor numérico.',mtInformation,[mbOk],0);
    Edit1.SetFocus;
    exit;
    end;
  end;
nomeSubGrupo := upperCase(trim(Edit2.Text));
if nomeSubGrupo='' then
  begin
  messageDlg('É necessário informar um nome para o subgrupo.',mtInformation,[mbOk],0);
  Edit2.SetFocus;
  exit;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODSUBGRUPO FROM SUBGRUPOSDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codSubGrupo;
    Query01.Open;
    if (fSubGruposDfn.Tag=1) and (Query01.Eof) then
      begin
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO SUBGRUPOSDFN (CODSIS,CODGRUPO,CODSUBGRUPO,NOMESUBGRUPO) VALUES(:A01,:A02,:A03,:A03)');
      Query02.Parameters[0].Value := codSis;
      Query02.Parameters[1].Value := codGrupo;
      Query02.Parameters[2].Value := codSubGrupo;
      Query02.Parameters[3].Value := nomeSubGrupo;
      Query02.ExecSQL;
      end
    else
      begin
      // Update
      if (tTabela.Fields[0].Value=codSis) and
         (tTabela.Fields[1].Value=codGrupo) and
         (tTabela.Fields[2].Value=codSubGrupo) then // Verifica se há mudança na chave (otimização gambirra)
        begin
        // Update sem mudança de chave. Dispensa o efeito cascata.
        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE SUBGRUPOSDFN SET NOMESUBGRUPO=:A01 WHERE CODSIS=:A02 AND CODGRUPO=:A03 AND CODSUBGRUPO=:A04');
        Query02.Parameters[0].Value := nomeSubGrupo;
        Query02.Parameters[1].Value := codSis;
        Query02.Parameters[2].Value := codGrupo;
        Query02.Parameters[3].Value := codSubGrupo;
        Query02.ExecSql;
        end
      else
        begin
        // Update com mudança de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO SUBGRUPOSDFN (CODSIS,CODGRUPO,CODSUBGRUPO,NOMESUBGRUPO) VALUES (:A01,:A02,:A03,:A04)');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codSubGrupo;
        Query02.Parameters[3].Value := nomeSubGrupo;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOREL SET CODSIS=:A01,CODGRUPO=:A02,CODSUBGRUPO=:A03 WHERE CODSIS=:A04 AND CODGRUPO=:A05 AND CODSUBGRUPO=:A06');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codSubGrupo;
        Query02.Parameters[3].Value := tTabela.Fields[0].Value;
        Query02.Parameters[4].Value := tTabela.Fields[2].Value;
        Query02.Parameters[5].Value := tTabela.Fields[4].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUREL SET CODSIS=:A01,CODGRUPO=:A02,CODSUBGRUPO=:A03 WHERE CODSIS=:A04 AND CODGRUPO=:A05 AND CODSUBGRUPO=:A06');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codSubGrupo;
        Query02.Parameters[3].Value := tTabela.Fields[0].Value;
        Query02.Parameters[4].Value := tTabela.Fields[2].Value;
        Query02.Parameters[5].Value := tTabela.Fields[4].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE DFN SET CODSIS=:A01,CODGRUPO=:A02,CODSUBGRUPO=:A03 WHERE CODSIS=:A04 AND CODGRUPO=:A05 AND CODSUBGRUPO=:A06');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codSubGrupo;
        Query02.Parameters[3].Value := tTabela.Fields[0].Value;
        Query02.Parameters[4].Value := tTabela.Fields[2].Value;
        Query02.Parameters[5].Value := tTabela.Fields[4].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM SUBGRUPOSDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODSUBGRUPO=:A03');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.Parameters[1].Value := tTabela.Fields[2].Value;
        Query02.Parameters[2].Value := tTabela.Fields[4].Value;
        Query02.ExecSQL;
        end;
      end;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados'+#10#13+'Detalhes do erro:'+#10#13+e.message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
Self.Close;
end;

end.
