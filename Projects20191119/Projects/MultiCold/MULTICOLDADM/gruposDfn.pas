unit gruposDfn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, Buttons, StdCtrls, System.UITypes;

type
  TfGruposDfn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
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
  fGruposDfn: TfGruposDfn;
  tTabela : TDataSet;

implementation

uses dataModule,principal;

{$R *.dfm}

function TfGruposDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfGruposDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfGruposDfn.FormShow(Sender: TObject);
begin
label1.Caption := vpNomeDoSistema;
fGruposDfn.Caption := vpNomeDoGrupo;
ComboBox1.Items.Clear;
ComboBox1.Text := '';
Edit1.Text := '';
Edit2.Text := '';
Edit3.Text := '';
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].asString+' : '+Query01.Fields[1].asString);
    if (fGruposDfn.Tag = 0) and (tTabela.Fields[0].asInteger = Query01.Fields[0].asInteger) then
      ComboBox1.Text := Query01.Fields[0].asString+' : '+Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;
if fGruposDfn.Tag = 0 then
  begin
  Edit1.Text := tTabela.Fields[1].AsString;
  Edit2.Text := tTabela.Fields[2].AsString;
  Edit3.Text := tTabela.Fields[3].AsString;
  end;
end;

procedure TfGruposDfn.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfGruposDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfGruposDfn.BitBtn3Click(Sender: TObject);
var
  codSis,
  codGrupo: Integer;
begin
if trim(comboBox1.Text)='' then
  begin
  messageDlg('É necessário informar o sistema.',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;
codSis := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
try
codGrupo := strToInt(Edit1.Text);
except
  on e:exception do
    begin
    messageDlg('É necessário informar o código do grupo.',mtInformation,[mbOk],0);
    Edit1.SetFocus;
    exit;
    end;
  end;

if messageDlg('Ao excluir um grupo você apagará todas as informações relacionadas a ele.',mtConfirmation,[mbOk,mbCancel],0)=mrCancel then
  exit;

with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUREL WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOREL WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM RELATOCD WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM EXTRATOR WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOMASCARA WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM MASCARACAMPO WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSBIN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSTXT WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM INDICESDFN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DESTINOSDFN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02)');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DFN WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM SUBGRUPOSDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOSAUXNUMDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOSAUXALFADFN WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOSDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.ExecSQL;

  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
Self.Close;
end;

procedure TfGruposDfn.BitBtn1Click(Sender: TObject);
var
  codSis,
  codGrupo:Integer;
  codGrupoAlfa,
  nomeGrupo: Variant;
begin
if trim(comboBox1.Text)='' then
  begin
  messageDlg('É necessário informar o sistema.',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;
codSis := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
try
  codGrupo := strToInt(Edit1.Text);
except
  on e:exception do
    begin
    messageDlg('É necessário informar o código do grupo.',mtInformation,[mbOk],0);
    Edit1.SetFocus;
    exit;
    end;
  end;
codGrupoAlfa := upperCase(trim(Edit2.Text));
nomeGrupo := upperCase(trim(Edit3.Text));
if nomeGrupo='' then
  begin
  messageDlg('É necessário informar o nome do grupo.',mtInformation,[mbOk],0);
  Edit3.SetFocus;
  exit;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODSIS FROM GRUPOSDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Open;
    if (fGruposDfn.Tag = 1) and (Query01.Eof) then // Verifica se grava por insert ou update
      begin
      // insert (novo registro)
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO GRUPOSDFN (CODSIS,CODGRUPO,CODGRUPOALFA,NOMEGRUPO) VALUES (:A01,:A02,:A03,:A04)');
      Query02.Parameters[0].Value := codSis;
      Query02.Parameters[1].Value := codGrupo;
      Query02.Parameters[2].Value := codGrupoAlfa;
      Query02.Parameters[3].Value := nomeGrupo;
      Query02.ExecSQL;
      end
    else
      begin
      // Update
      if(tTabela.Fields[0].Value=codSis) and (tTabela.Fields[1].Value=codGrupo) then // Verifica se há mudança na chave (otimização gambirra)
        begin
        // Update sem mudança de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOSDFN SET CODGRUPOALFA=:A01,NOMEGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codGrupoAlfa;
        Query02.Parameters[1].Value := nomeGrupo;
        Query02.Parameters[2].Value := codSis;
        Query02.Parameters[3].Value := codGrupo;
        Query02.ExecSQL;
        end
      else
        begin
        // Update com mudança de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO GRUPOSDFN (CODSIS,CODGRUPO,CODGRUPOALFA,NOMEGRUPO) VALUES (:A01,:A02,:A03,:A04)');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codGrupoAlfa;
        Query02.Parameters[3].Value := nomeGrupo;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOREL SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUREL SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE EXTRATOR SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE RELATOCD SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE DFN SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOSAUXNUMDFN SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOSAUXALFADFN SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE SUBGRUPOSDFN SET CODSIS=:A01,CODGRUPO=:A02 WHERE CODSIS=:A03 AND CODGRUPO=:A04');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := tTabela.Fields[0].Value;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM GRUPOSDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.Parameters[1].Value := tTabela.Fields[2].Value;
        Query02.ExecSQL;
        end;
      end; // if fGruposDfn.Tag = 0 then
    Query01.Close;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      exit;
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
Self.Close;
end;

end.
