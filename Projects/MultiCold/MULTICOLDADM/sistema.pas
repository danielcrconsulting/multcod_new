unit sistema;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DB, System.UITypes;

type
  TfSistema = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
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
  fSistema: TfSistema;
  tTabela : TDataSet;

implementation

uses dataModule, gruposDfn, principal;

{$R *.dfm}

function TfSistema.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfSistema.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfSistema.FormShow(Sender: TObject);
begin
fSistema.Caption := vpNomeDoSistema;
Edit1.Text := '';
Edit2.Text := '';
if Self.Tag=0 then
  begin
  Edit1.Text := tTabela.Fields[0].AsString;
  Edit2.Text := tTabela.Fields[1].AsString;
  end;
end;

procedure TfSistema.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfSistema.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfSistema.BitBtn3Click(Sender: TObject);
var
  codSis: Integer;
begin
try
  codSis := strToInt(Edit1.Text);
except
  on e:exception do
    begin
    messageDlg('Você deve informar um valor numérico para o código do sistema.',mtWarning,[mbOk],0);
    Edit1.SetFocus;
    exit;
    end;
  end;
if messageDlg('Ao excluir um sistema você apagará todas as informações relacionadas a ele.',mtConfirmation,[mbOk,mbCancel],0)=mrCancel then
  exit;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Screen.Cursor := crHourGlass;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUREL WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOREL WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM EXTRATOR WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM RELATOCD WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOMASCARA WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A)');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM MASCARACAMPO WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A)');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSBIN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A)');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSTXT WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A)');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM INDICESDFN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A)');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DESTINOSDFN WHERE CODREL IN (SELECT CODREL FROM DFN WHERE CODSIS=:A)');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DFN WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM SUBGRUPOSDFN WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOSAUXALFADFN WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOSAUXNUMDFN WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOSDFN WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM SISTEMA WHERE CODSIS=:A');
    Query01.Parameters[0].Value := codSis;
    Query01.ExecSQL;

    Screen.Cursor := crDefault;
  except
    on e:exception do
      begin
      Screen.Cursor := crDefault;
      dbMulticold.RollbackTrans;
      messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro.'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
Self.Close;
end;

procedure TfSistema.BitBtn1Click(Sender: TObject);
var
  codSis: Integer;
  nomeSis: String;
begin
try
  codSis := strToInt(Edit1.Text);
except
  on e:exception do
    begin
    messageDlg('Você deve informar um valor numérico para o código do sistema.',mtWarning,[mbOk],0);
    Edit1.SetFocus;
    exit;
    end;
  end;
nomeSis := upperCase(trim(Edit2.Text));
if nomeSis='' then
  begin
  messageDlg('Você deve informar um valor para o nome do sistema.',mtWarning,[mbOk],0);
  Edit2.SetFocus;
  exit;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Screen.Cursor := crHourGlass;

    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODSIS FROM SISTEMA WHERE CODSIS=?');
    Query01.Parameters[0].Value := codSis;
    Query01.Open;
    if (Self.Tag = 1) and (Query01.Eof) then // Verifica se grava por insert ou update
      begin
      // insert (novo registro)
      Query02.SQL.Clear;
      QUery02.SQL.Add('INSERT INTO SISTEMA (CODSIS,NOMESIS) VALUES(?,?)');
      QUery02.Parameters[0].Value := codSis;
      QUery02.Parameters[1].Value := nomeSis;
      Query02.ExecSQL;
      end
    else
      begin
      // Update
      if(tTabela.Fields[0].Value=codSis) then // Verifica se há mudança na chave (otimização gambirra)
        begin
        // Update sem mudança de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE SISTEMA SET NOMESIS=? WHERE CODSIS=?');
        Query02.Parameters[0].Value := nomeSis;
        QUery02.Parameters[1].Value := codSis;
        QUery02.ExecSQL;
        end
      else
        begin
        // Update com mudança de chaves
        Query02.SQL.Clear;
        QUery02.SQL.Add('INSERT INTO SISTEMA (CODSIS,NOMESIS) VALUES(?,?)');
        QUery02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := nomeSis;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO GRUPOSDFN (CODSIS, CODGRUPO, CODGRUPOALFA, NOMEGRUPO) ');
        Query02.SQL.Add('SELECT :A, CODGRUPO, CODGRUPOALFA, NOMEGRUPO FROM GRUPOSDFN WHERE CODSIS=:B');
        QUery02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO GRUPOSAUXNUMDFN (CODSIS, CODGRUPO, CODAUXGRUPO)');
        Query02.SQL.Add('SELECT :A, CODGRUPO, CODAUXGRUPO FROM GRUPOSAUXNUMDFN WHERE CODSIS = :B');
        Query02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO GRUPOSAUXALFADFN (CODSIS, CODGRUPO, CODAUXGRUPO)');
        Query02.SQL.Add('SELECT :A, CODGRUPO, CODAUXGRUPO FROM GRUPOSAUXALFADFN WHERE CODSIS = :B');
        Query02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO SUBGRUPOSDFN (CODSIS, CODGRUPO, CODSUBGRUPO, NOMESUBGRUPO)');
        Query02.SQL.Add('SELECT :A, CODGRUPO, CODSUBGRUPO, NOMESUBGRUPO FROM SUBGRUPOSDFN WHERE CODSIS = :B');
        Query02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO USUREL (CODUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO) ');
        Query02.SQL.Add('SELECT CODUSUARIO, :A, CODGRUPO, CODSUBGRUPO, CODREL, TIPO FROM USUREL WHERE CODSIS=:B');
        QUery02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO GRUPOREL (NOMEGRUPOUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO) ');
        Query02.SQL.Add('SELECT NOMEGRUPOUSUARIO, :A, CODGRUPO, CODSUBGRUPO, CODREL, TIPO FROM GRUPOREL WHERE CODSIS=:B');
        QUery02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO EXTRATOR (CODREL, CODSIS, CODGRUPO, XTR, DESTINO, DIREXPL, OPERACAO, SUBDIR, ARQUIVO) ');
        Query02.SQL.Add('SELECT CODREL, :A, CODGRUPO, XTR, DESTINO, DIREXPL, OPERACAO, SUBDIR, ARQUIVO FROM EXTRATOR WHERE CODSIS = :B ');
        Query02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO RELATOCD (CODSIS, CODGRUPO, CODREL, SEGURANCA, DIREXPL) ');
        Query02.SQL.Add('SELECT :A, CODGRUPO, CODREL, SEGURANCA, DIREXPL FROM RELATOCD WHERE CODSIS = :B');
        Query02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE DFN SET CODSIS=? WHERE CODSIS=?');
        Query02.Parameters[0].Value := codSis;
        QUery02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM USUREL WHERE CODSIS=? ');
        QUery02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM GRUPOREL WHERE CODSIS=? ');
        QUery02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM RELATOCD WHERE CODSIS=? ');
        QUery02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM EXTRATOR WHERE CODSIS=? ');
        QUery02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM GRUPOSAUXALFADFN WHERE CODSIS=? ');
        QUery02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM GRUPOSAUXNUMDFN WHERE CODSIS=? ');
        QUery02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM SUBGRUPOSDFN WHERE CODSIS=? ');
        QUery02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM GRUPOSDFN WHERE CODSIS=?');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM SISTEMA WHERE CODSIS=?');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;
        end;
      end;
    Query01.Close;

    Screen.Cursor := crDefault;
  except
    on e:exception do
      begin
      Screen.Cursor := crDefault;
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados.'+#10#13+'Detalhes do erro.'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
Self.Close;
end;

end.
