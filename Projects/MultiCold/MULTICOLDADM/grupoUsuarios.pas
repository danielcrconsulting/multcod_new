unit grupoUsuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, System.UITypes;

type
  TfGrupoUsuarios = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  fGrupoUsuarios: TfGrupoUsuarios;
  tTabela: tDataSet;
implementation

uses dataModule;

{$R *.dfm}

function TfGrupoUsuarios.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfGrupoUsuarios.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfGrupoUsuarios.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfGrupoUsuarios.FormShow(Sender: TObject);
begin
if Self.Tag=0 then
  begin
  Edit1.TExt := tTabela.Fields[0].AsString;
  Edit2.Text := tTabela.Fields[1].AsString;
  Edit3.TExt := tTabela.Fields[2].AsString;
  end
else
  begin
  Edit1.TExt := '';
  Edit2.Text := '';
  Edit3.TExt := '';
  end;
end;

procedure TfGrupoUsuarios.BitBtn2Click(Sender: TObject);
begin
Self.FormShow(Sender);
end;

procedure TfGrupoUsuarios.BitBtn3Click(Sender: TObject);
var
  nomeGrupoUsuario: String;
begin
nomeGrupoUsuario:= upperCase(trim(Edit1.Text));
if (nomeGrupoUsuario='ADMDFN') or
   (nomeGrupoUsuario='ADMSEG') or
   (nomeGrupoUsuario='ADMSIS') then
  begin
  messageDlg('Você não pode apagar os grupos de administradores do sistema.',mtWarning,[mbOk],0);
  exit;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOSEGRUPOS WHERE NOMEGRUPOUSUARIO=:A01');
    Query01.Parameters[0].Value := nomeGrupoUsuario;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOREL WHERE NOMEGRUPOUSUARIO=:A01');
    Query01.Parameters[0].Value := nomeGrupoUsuario;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOUSUARIOS WHERE NOMEGRUPOUSUARIO=:A01');
    Query01.Parameters[0].Value := nomeGrupoUsuario;
    Query01.ExecSQL;

  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
Self.Close;
end;

procedure TfGrupoUsuarios.BitBtn1Click(Sender: TObject);
var
  nomeGrupoUsuario,
  descrGrupo,
  observacao: String;
begin
nomeGrupoUsuario := upperCase(trim(Edit1.Text));
if nomeGrupoUsuario='' then
  begin
  messageDlg('O nome do grupo de usuários é obrigatório.',mtWarning,[mbOk],0);
  exit;
  end;
descrGrupo := upperCase(trim(Edit2.Text));
observacao := upperCase(trim(Edit3.Text));
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS WHERE NOMEGRUPOUSUARIO=:A01');
    Query01.Parameters[0].Value := nomeGrupoUsuario;
    Query01.Open;
    if (Self.Tag = 1) and (Query01.Eof) then
      begin
      // Insert
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO GRUPOUSUARIOS (NOMEGRUPOUSUARIO, DESCRGRUPO, OBSERVACAO) VALUES (:A01,:A02,:A03)');
      Query02.Parameters[0].Value := nomeGrupoUsuario;
      Query02.Parameters[1].Value := descrGrupo;
      Query02.Parameters[2].Value := observacao;
      Query02.ExecSQL;
      end
    else
      begin
      if (tTabela.Fields[0].Value=nomeGrupoUsuario) then
        begin
        // Update sem alteração de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOUSUARIOS SET DESCRGRUPO=:A01, OBSERVACAO=:A02 WHERE NOMEGRUPOUSUARIO=:A03');
        Query02.Parameters[0].Value := descrGrupo;
        Query02.Parameters[1].Value := observacao;
        Query02.Parameters[2].Value := nomeGrupoUsuario;
        Query02.ExecSQL;
        end
      else
        begin
        // Update com alteração de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO GRUPOUSUARIOS (NOMEGRUPOUSUARIO, DESCRGRUPO, OBSERVACAO) VALUES (:A01,:A02,:A03)');
        Query02.Parameters[0].Value := nomeGrupoUsuario;
        Query02.Parameters[1].Value := descrGrupo;
        Query02.Parameters[2].Value := observacao;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUARIOSEGRUPOS SET NOMEGRUPOUSUARIO=:A01 WHERE NOMEGRUPOUSUARIO=:A02');
        Query02.Parameters[0].Value := nomeGrupoUsuario;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOREL SET NOMEGRUPOUSUARIO=:A01 WHERE NOMEGRUPOUSUARIO=:A02');
        Query02.Parameters[0].Value := nomeGrupoUsuario;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM GRUPOUSUARIOS WHERE NOMEGRUPOUSUARIO=:A01');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;
        end;
      end;
    Query01.Close;
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
Self.Close;
end;

end.
