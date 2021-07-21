unit usuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DB, System.UITypes;

type
  TfUsuarios = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Label4: TLabel;
    Edit4: TEdit;
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
  fUsuarios: TfUsuarios;
  tTabela : TDataSet;

implementation

uses dataModule;

{$R *.dfm}

function TfUsuarios.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfUsuarios.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfUsuarios.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfUsuarios.FormShow(Sender: TObject);
begin
if Self.Tag = 0 then
  begin
  Edit1.Text := tTabela.Fields[0].AsString;
  Edit2.Text := tTabela.Fields[1].AsString;
  CheckBox1.Checked := (tTabela.Fields[2].AsString='S');
  Edit4.Text := tTabela.Fields[3].asString;
  end
else
  begin
  Edit1.Text := '';
  Edit2.Text := '';
  CheckBox1.Checked := false;
  Edit4.Text := '';
  end;
Edit3.Text := '';
end;

procedure TfUsuarios.BitBtn2Click(Sender: TObject);
begin
Self.FormShow(Sender);
end;

procedure TfUsuarios.BitBtn3Click(Sender: TObject);
var
  codUsu : String;
begin
codUsu := upperCase(Edit1.Text);
if (codUsu='ADMSIS') or (codUsu='ADMSEG') or (codUsu='ADMDFN') then
  begin
  messageDlg('Você não pode apagar os administradores do sistema',mtWarning,[mbOk],0);
  edit1.SetFocus;
  exit;
  end;
with repositorioDeDados do
  begin
  {
  Gabriel - 08/09/2004
  Query02.SQL.Clear;
  Query02.SQL.Add('SELECT COUNT(CODUSUARIO) FROM USUARIOSEGRUPOS WHERE NOMEGRUPOUSUARIO IN (''ADMSIS'',''ADMDFN'',''ADMSEG'') AND CODUSUARIO=:A01');
  Query02.Parameters[0].Value := tTabela.Fields[0].AsString;
  Query02.Open;
  if Query02.Fields[0].AsInteger > 0 then
    begin
    Query02.Close;
    messageDlg('Você não pode excluir os administradores do sistema.',mtWarning,[mbOk],0);
    exit;
    end;
  Query02.Close;
  }
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOMASCARA WHERE CODUSUARIO=:A02');
    Query01.Parameters[0].Value := codUsu;
    Query01.ExecSQL;
    
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUREL WHERE CODUSUARIO=:A02');
    Query01.Parameters[0].Value := codUsu;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSBIN WHERE CODUSUARIO=:A01');
    Query01.Parameters[0].Value := codUsu;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSTXT WHERE CODUSUARIO=:A01');
    Query01.Parameters[0].Value := codUsu;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOSEGRUPOS WHERE CODUSUARIO=:A01');
    Query01.Parameters[0].Value := codUsu;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOS WHERE CODUSUARIO=:A01');
    Query01.Parameters[0].Value := codUsu;
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

procedure TfUsuarios.BitBtn1Click(Sender: TObject);
var
  codUsu,
  pwd1,
  pwd2,
  remoto,
  nome:variant;
begin
codUsu := upperCase(Edit1.Text);
pwd1 := trim(Edit2.Text);
pwd2 := trim(Edit3.Text);
if ((tTabela.Fields[0].AsString='ADMSIS') or (tTabela.Fields[0].AsString='ADMDFN') or (tTabela.Fields[0].AsString='ADMSEG')) and (codUsu<>tTabela.Fields[0].AsString) then
  begin
  messageDlg('Você não pode alterar o nome de acesso dos administradores do sistema.',mtWarning,[mbOk],0);
  BitBtn2.Click;
  exit;
  end;
if pwd1<>pwd2 then
  begin
  messageDlg('O campo senha e confirmação de senha estão diferentes.',mtInformation,[mbOk],0);
  exit;
  end;
if pwd1='' then
  pwd1 := null;
if CheckBox1.Checked then
  remoto := 'S'
else
  remoto := 'N';
nome := Edit4.Text;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODUSUARIO FROM USUARIOS WHERE CODUSUARIO=:A01');
    Query01.Parameters[0].Value := codUsu;
    Query01.Open;
    if (Self.Tag=1) and (Query01.Eof) then
      begin
      // Novo registro
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO USUARIOS (CODUSUARIO, SENHA, REMOTO, NOME) VALUES (:A01,:A02,:A03,:A04)');
      Query02.Parameters[0].Value := codUSu;
      Query02.Parameters[1].Value := pwd1;
      Query02.Parameters[2].Value := remoto;
      Query02.Parameters[3].Value := nome;
      Query02.ExecSQL;
      end
    else
      begin
      if (tTabela.Fields[0].Value=codUsu) then
        begin
        // Update sem troca de chave
        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUARIOS SET SENHA=:A01, REMOTO=:A02, NOME=:A03 WHERE CODUSUARIO=:A04');
        Query02.Parameters[0].Value := pwd1;
        Query02.Parameters[1].Value := remoto;
        Query02.Parameters[2].Value := nome;
        Query02.Parameters[3].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;
        end
      else
        begin
        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO USUARIOS (CODUSUARIO, SENHA, REMOTO, NOME) VALUES (:A01,:A02,:A03,:A04)');
        Query02.Parameters[0].Value := codUsu;
        QUery02.Parameters[1].Value := pwd1;
        Query02.Parameters[2].Value := remoto;
        Query02.Parameters[3].Value := nome;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUARIOMASCARA SET CODUSUARIO=:A01 WHERE CODUSUARIO=:A02');
        Query02.Parameters[0].Value := codUsu;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUARIOSEGRUPOS SET CODUSUARIO=:A01 WHERE CODUSUARIO=:A02');
        Query02.Parameters[0].Value := codUsu;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE COMENTARIOSBIN SET CODUSUARIO=:A01 WHERE CODUSUARIO=:A02');
        Query02.Parameters[0].Value := codUsu;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE COMENTARIOSTXT SET CODUSUARIO=:A01 WHERE CODUSUARIO=:A02');
        Query02.Parameters[0].Value := codUsu;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUREL SET CODUSUARIO=:A01 WHERE CODUSUARIO=:A02');
        Query02.Parameters[0].Value := codUsu;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM USUARIOS WHERE CODUSUARIO=:A01');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;
        end;
      end;
    Query01.Close;
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

end.
