unit heranca;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, System.UITypes;

type
  TfHeranca = class(TForm)
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label3: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fHeranca: TfHeranca;

implementation

uses dataModule;

{$R *.dfm}

procedure TfHeranca.ComboBox1Change(Sender: TObject);
begin

//De um grupo de usu�rios para outro grupo de usu�rios
//De um grupo de usu�rios para um usu�rio
//De um usu�rio para um grupo de usu�rios
//De um usu�rio para outro usu�rio

ComboBox2.Text := '';
ComboBox3.Text := '';
ComboBox2.Sorted := false;
ComboBox3.Sorted := false;
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;

with repositorioDeDados do
  begin
  Query01.Sql.Clear;
  Query02.Sql.Clear;
  if ComboBox1.ItemIndex = 0 then
    begin
    Label1.Caption := 'Herdar permiss�es de um grupo de usu�rios:';
    Label3.Caption := 'Para o grupo:';
    Query01.SQL.Add('SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS ORDER BY NOMEGRUPOUSUARIO');
    Query02.SQL.Add('SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS ORDER BY NOMEGRUPOUSUARIO');
    end
  else if ComboBox1.ItemIndex = 1 then
    begin
    Label1.Caption := 'Herdar permiss�es de um grupo de usu�rios:';
    Label3.Caption := 'Para o usu�rio:';
    Query01.SQL.Add('SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS ORDER BY NOMEGRUPOUSUARIO');
    Query02.SQL.Add('SELECT CODUSUARIO FROM USUARIOS ORDER BY CODUSUARIO');
    end
  else if ComboBox1.ItemIndex = 2 then
    begin
    Label1.Caption := 'Herdar permiss�es de um usu�rio';
    Label3.Caption := 'Para um grupo de usu�rios';
    Query01.SQL.Add('SELECT CODUSUARIO FROM USUARIOS ORDER BY CODUSUARIO');
    Query02.SQL.Add('SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS ORDER BY NOMEGRUPOUSUARIO');
    end
  else if ComboBox1.ItemIndex = 3 then
    begin
    Label1.Caption := 'Herdar permiss�es de um usu�rio';
    Label3.Caption := 'Para outro usu�rio';
    Query01.SQL.Add('SELECT CODUSUARIO FROM USUARIOS ORDER BY CODUSUARIO');
    Query02.SQL.Add('SELECT CODUSUARIO FROM USUARIOS ORDER BY CODUSUARIO');
    end;
  if (trim(Query01.SQL.Text) = '') or (trim(Query01.SQL.Text) = '') then
    exit;
  Query01.Open;
  Query02.Open;
  While Not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].asString);
    Query01.Next;
    end;
  While Not Query02.Eof do
    begin
    ComboBox3.Items.Add(Query02.Fields[0].asString);
    Query02.Next;
    end;
  Query02.Close;
  Query01.Close;
  end;
end;

procedure TfHeranca.BitBtn2Click(Sender: TObject);
begin
ComboBox1.Text := '';
ComboBox2.Text := '';
ComboBox3.Text := '';
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
end;

procedure TfHeranca.BitBtn1Click(Sender: TObject);
begin
if ComboBox3.Text = 'ADM' then
  begin
  messageDlg('N�o � permitido sobrepor as permiss�es do administrador do sistema.', mtInformation, [mbOk],0);
  exit;
  end;
if messageDlg('Ao heran�a ir� sobrepor as permiss�es do usu�rio/grupo selecionados. Tem certeza de que deseja prosseguir ?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
  exit;
Screen.Cursor := crHourglass;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    if ComboBox1.ItemIndex = 0 then // Grupo de usu�rios para grupo de usu�rios
      begin
      // Elimina permiss�es de acesso dos usu�rios
      Query01.SQL.Clear;
      Query01.SQL.Add('delete from usurel where codusuario in (select codusuario from usuariosegrupos where nomegrupousuario = :a)');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Elimina de grupo rel as permiss�es do grupo escolhido
      Query01.Sql.Clear;
      Query01.Sql.Add('delete from gruporel where nomegrupousuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Replica permiss�es do grupo
      Query01.SQL.Clear;
      Query01.SQL.Add('insert into gruporel (nomegrupousuario, codsis, codgrupo, codsubgrupo, codrel, tipo)');
      Query01.SQL.Add('select '''+ ComboBox3.Text + ''' as nomegrupousuario, codsis, codgrupo, codsubgrupo, codrel, tipo');
      Query01.SQL.Add('from gruporel');
      Query01.SQL.Add('where nomegrupousuario = :a');
      Query01.Parameters[0].Value := ComboBox2.Text;
      Query01.ExecSQL;
      // Aplica permiss�es aos usu�rios
      Query01.SQL.Clear;
      Query01.SQL.Add('insert into usurel (codusuario, codsis, codgrupo, codsubgrupo, codrel, tipo)');
      Query01.SQL.Add('select b.codusuario, a.codsis, a.codgrupo, a.codsubgrupo, a.codrel, a.tipo');
      Query01.SQL.Add('from gruporel a join usuariosegrupos b on a.nomegrupousuario = b.nomegrupousuario');
      Query01.SQL.Add('where b.nomegrupousuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      end
    else if ComboBox1.ItemIndex = 1 then // Grupo de usu�rios para usu�rios
      begin
      // Elimina permiss�es de acesso dos usu�rios
      Query01.SQL.Clear;
      Query01.SQL.Add('delete from usurel where codusuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Elimina usu�rio dos grupos de usu�rios
      Query01.SQL.Clear;
      Query01.SQL.Add('delete from usuariosegrupos where codusuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Replica permiss�es do grupo
      Query01.SQL.Clear;
      Query01.SQL.Add('insert into usurel (codusuario, codsis, codgrupo, codsubgrupo, codrel, tipo)');
      Query01.SQL.Add('select '''+ ComboBox3.Text + ''' as codusuario, codsis, codgrupo, codsubgrupo, codrel, tipo');
      Query01.SQL.Add('from gruporel');
      Query01.SQL.Add('where nomegrupousuario = :a');
      Query01.Parameters[0].Value := ComboBox2.Text;
      Query01.ExecSQL;
      end
    else if ComboBox1.ItemIndex = 2 then // Usu�rio para grupos de usu�rios
      begin
      // Elimina permiss�es de acesso dos usu�rios
      Query01.SQL.Clear;
      Query01.SQL.Add('delete from usurel where codusuario in (select codusuario from usuariosegrupos where nomegrupousuario = :a)');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Elimina de grupo rel as permiss�es do grupo escolhido
      Query01.Sql.Clear;
      Query01.Sql.Add('delete from gruporel where nomegrupousuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Replica permiss�es do usu�rio para o grupo
      Query01.SQL.Clear;
      Query01.SQL.Add('insert into gruporel (nomegrupousuario, codsis, codgrupo, codsubgrupo, codrel, tipo)');
      Query01.SQL.Add('select '''+ ComboBox3.Text + ''' as nomegrupousuario, codsis, codgrupo, codsubgrupo, codrel, tipo');
      Query01.SQL.Add('from usurel');
      Query01.SQL.Add('where codusuario = :a');
      Query01.Parameters[0].Value := ComboBox2.Text;
      Query01.ExecSQL;
      // Aplica permiss�es aos usu�rios do grupo que recebeu as permiss�es
      Query01.SQL.Clear;
      Query01.SQL.Add('insert into usurel (codusuario, codsis, codgrupo, codsubgrupo, codrel, tipo)');
      Query01.SQL.Add('select b.codusuario, a.codsis, a.codgrupo, a.codsubgrupo, a.codrel, a.tipo');
      Query01.SQL.Add('from gruporel a join usuariosegrupos b on a.nomegrupousuario = b.nomegrupousuario');
      Query01.SQL.Add('where b.nomegrupousuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      end
    else if ComboBox1.ItemIndex = 3 then // Usu�rios para usu�rios
      begin
      // Elimina permiss�es de acesso dos usu�rios
      Query01.SQL.Clear;
      Query01.SQL.Add('delete from usurel where codusuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Elimina usu�rio dos grupos de usu�rios
      Query01.SQL.Clear;
      Query01.SQL.Add('delete from usuariosegrupos where codusuario = :a');
      Query01.Parameters[0].Value := ComboBox3.Text;
      Query01.ExecSQL;
      // Replica permiss�es do grupo
      Query01.SQL.Clear;
      Query01.SQL.Add('insert into usurel (codusuario, codsis, codgrupo, codsubgrupo, codrel, tipo)');
      Query01.SQL.Add('select '''+ ComboBox3.Text + ''' as codusuario, codsis, codgrupo, codsubgrupo, codrel, tipo');
      Query01.SQL.Add('from usurel');
      Query01.SQL.Add('where codusuario = :a');
      Query01.Parameters[0].Value := ComboBox2.Text;
      Query01.ExecSQL;
      end;
    messageDlg('Heran�a aplicada com sucesso.',mtInformation,[mbOk],0);
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      Screen.Cursor := crDefault;
      messageDlg('Erro na opera��o do banco de dados. Detalhes do erro: '+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    begin
    dbMulticold.CommitTrans;
    BitBtn2.Click;
    end;
  end;
Screen.Cursor := crDefault;
end;

end.
