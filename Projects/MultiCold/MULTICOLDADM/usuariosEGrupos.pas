unit usuariosEGrupos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, AdoDB, System.UITypes;

type
  TfUsuariosEGrupos = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    ListBox1: TListBox;
    Label4: TLabel;
    ListBox2: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
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
  fUsuariosEGrupos: TfUsuariosEGrupos;
  tTabela : TDataSet;

implementation

uses dataModule;

{$R *.dfm}

function TfUsuariosEGrupos.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfUsuariosEGrupos.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfUsuariosEGrupos.FormShow(Sender: TObject);
begin
ComboBox1.Text;
ComboBox1.Items.Clear;
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODUSUARIO FROM USUARIOS ORDER BY CODUSUARIO');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;
  end;
{
if Self.Tag=0 then
  begin
  ComboBox1.Text := tTabela.Fields[0].AsString;
  ComboBox1Change(Sender);
  end
else
}
  ComboBox1.Text := '';
end;

procedure TfUsuariosEGrupos.ComboBox1Change(Sender: TObject);
begin
ListBox1.Items.Clear;
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT NOMEGRUPOUSUARIO FROM USUARIOSEGRUPOS WHERE CODUSUARIO=:A01 ORDER BY NOMEGRUPOUSUARIO');
  Query01.Parameters[0].Value := ComboBox1.Text;
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox1.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;
  Query01.SQL.Clear;
  {
  Query01.SQL.Add(' SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS WHERE NOMEGRUPOUSUARIO NOT IN ');
  Query01.SQL.Add(' (SELECT NOMEGRUPOUSUARIO FROM USUARIOSEGRUPOS WHERE CODUSUARIO = ?) ');
  Query01.SQL.Add(' ORDER BY NOMEGRUPOUSUARIO ');
  Query01.Parameters[0].Value := COmbobox1.Text;
  }
  Query01.SQL.Add(' SELECT NOMEGRUPOUSUARIO ');
  Query01.SQL.Add(' FROM GRUPOUSUARIOS ');
  Query01.SQL.Add(' WHERE NOMEGRUPOUSUARIO NOT IN ( ');
  Query01.SQL.Add(' 	SELECT NOMEGRUPOUSUARIO ');
  Query01.SQL.Add(' 	FROM USUARIOSEGRUPOS ');
  Query01.SQL.Add(' 	WHERE CODUSUARIO = '''+COmbobox1.Text+'''');
  Query01.SQL.Add(' 	) ');
  Query01.SQL.Add(' ORDER BY NOMEGRUPOUSUARIO ');
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox2.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfUsuariosEGrupos.SpeedButton1Click(Sender: TObject);
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

procedure TfUsuariosEGrupos.SpeedButton3Click(Sender: TObject);
begin
while ListBox1.Items.Count > 0 do
  begin
  ListBox2.Items.Add(ListBox1.Items.Strings[0]);
  ListBox1.Items.Delete(0);
  end;
end;

procedure TfUsuariosEGrupos.SpeedButton4Click(Sender: TObject);
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

procedure TfUsuariosEGrupos.SpeedButton5Click(Sender: TObject);
begin
while ListBox2.Items.Count > 0 do
  begin
  ListBox1.Items.Add(ListBox2.Items.Strings[0]);
  ListBox2.Items.Delete(0);
  end;
end;

procedure TfUsuariosEGrupos.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfUsuariosEGrupos.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfUsuariosEGrupos.BitBtn1Click(Sender: TObject);
var
  codUsuario: String;
  i: Integer;
begin
codUsuario := upperCase(trim(ComboBox1.Text));
if codUsuario='' then
  begin
  messageDlg('É necessário informar o código do usuário!',mtInformation,[mbOk],0);
  exit;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOSEGRUPOS WHERE CODUSUARIO=:A01');
    Query01.Parameters[0].Value := codUsuario;
    Query01.ExecSQL;

    Query01.SQL.Clear;
    Query01.SQL.Add('INSERT INTO USUARIOSEGRUPOS (CODUSUARIO, NOMEGRUPOUSUARIO) VALUES (:A01,:A02)');
    Query01.Prepared := true;

    Query02.SQL.Clear;
//    Query02.SQL.Add('DELETE FROM USUREL WHERE CODUSUARIO=:A01 AND CODREL IN (SELECT CODREL FROM GRUPOREL WHERE NOMEGRUPOUSUARIO = :B)');
//    Query02.SQL.Add('DELETE FROM USUREL WHERE CODUSUARIO=:A01 AND CODSIS=:A02 AND CODGRUPO=:A03 AND CODSUBGRUPO=:A04 AND CODREL=:A05 AND TIPO=:A06');

    Query02.SQL.Add('DELETE FROM USUREL WHERE CODUSUARIO=:A01');
    Query02.Parameters[0].Value := codUsuario;
    Query02.ExecSQL;

    Query03.SQL.Clear;
    Query03.SQL.Add('INSERT INTO USUREL (CODUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO) ');
    Query03.SQL.Add('SELECT '''+codUsuario+''' AS CODUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO ');
    Query03.SQL.Add('FROM GRUPOREL ');
    Query03.SQL.Add('WHERE NOMEGRUPOUSUARIO = :A ');
    Query03.Prepared := true;

{    Query04.SQL.Clear;
    Query04.SQL.Add('SELECT CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO FROM GRUPOREL WHERE NOMEGRUPOUSUARIO = :A');
    Query04.Prepared := true;

    for i:=0 to ListBox2.Items.Count-1 do
      begin
      Query04.Parameters[0].Value := ListBox2.Items.Strings[i];
      Query04.Open;
      While Not Query04.Eof do
        begin

        Query02.Parameters[0].Value := codUsuario;

        Query02.Parameters[1].Value := Query04.Fields[0].Value;
        Query02.Parameters[2].Value := Query04.Fields[1].Value;
        Query02.Parameters[3].Value := Query04.Fields[2].Value;
        Query02.Parameters[4].Value := Query04.Fields[3].Value;
        Query02.Parameters[4].Value := Query04.Fields[3].Value;

        Query02.ExecSQL;

        Query04.Next;
        end;
      Query04.Close;
      end;                 }

    for i:=0 to ListBox1.Items.Count-1 do
      begin
      Query01.Parameters[0].Value := codUsuario;
      Query01.Parameters[1].Value := ListBox1.Items.Strings[i];
      Query01.ExecSQL;

//      Query02.Parameters[0].Value := codUsuario;
//      Query02.Parameters[1].Value := ListBox1.Items.Strings[i];
//      Query02.ExecSQL;

{      Query04.Parameters[0].Value := ListBox1.Items.Strings[i];
      Query04.Open;
      While Not Query04.Eof do
        begin
        Query02.Parameters[0].Value := codUsuario;
        Query02.Parameters[1].Value := Query04.Fields[0].Value;
        Query02.Parameters[2].Value := Query04.Fields[1].Value;
        Query02.Parameters[3].Value := Query04.Fields[2].Value;
        Query02.Parameters[4].Value := Query04.Fields[3].Value;
        Query02.Parameters[5].Value := Query04.Fields[4].Value;
        Query02.ExecSQL;
        Query04.Next;
        end;
      Query04.Close;            }

      Query03.Parameters[0].Value := ListBox1.Items.Strings[i];
      Try
        Query03.ExecSQL;
      Except
        end; //Try  
      end;
    Query01.Prepared := false;
//    Query02.Prepared := false;
    Query03.Prepared := false;
//    Query04.Prepared := false;
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
    ShowMessage('Fim da atualização...');
    end;
  end;
//Self.Close;
FormShow(Sender);
end;

end.
