unit gruposAuxAlfaDfn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, System.UITypes;

type
  TfGruposAuxAlfaDfn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    Edit1: TEdit;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
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
  fGruposAuxAlfaDfn: TfGruposAuxAlfaDfn;
  tTabela : TDataSet;
  codSis,
  codGrupo: Integer;
  codAuxGrupo: String;

implementation

uses dataModule,principal;

{$R *.dfm}

function TfGruposAuxAlfaDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfGruposAuxAlfaDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfGruposAuxAlfaDfn.SpeedButton2Click(Sender: TObject);
begin
fgruposAuxAlfaDfn.Close;
end;

procedure TfGruposAuxAlfaDfn.FormShow(Sender: TObject);
begin
Label1.Caption := vpNomeDoSistema;
Label2.Caption := vpNomeDoGrupo;
ComboBox1.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString);
    if tTabela.Fields[0].AsInteger = Query01.Fields[0].AsInteger then
      comboBox1.Text := Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
if fgruposAuxAlfaDfn.Tag = 0 then
  begin
  ComboBox1Change(Sender);
  with repositorioDeDados do
    begin
    Query01.SQL.clear;
    Query01.SQL.Add('SELECT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN WHERE CODSIS=? AND CODGRUPO=?');
    Query01.Parameters[0].Value := tTabela.Fields[0].AsInteger;
    Query01.Parameters[1].Value := tTabela.Fields[1].AsInteger;
    Query01.Open;
    if not Query01.Eof then
      ComboBox2.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].AsString;
    Query01.Close;
    end;
  Edit1.Text := tTabela.Fields[2].AsString;
  codSis := strToInt(trim(copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
  codGrupo := strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
  end
else
  begin
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  Edit1.Text := '';
  codSis := -1;
  codGrupo := -1;
  end;
codAuxGrupo := Edit1.Text;
end;

procedure TfGruposAuxAlfaDfn.ComboBox1Change(Sender: TObject);
begin
ComboBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN WHERE CODSIS=? ');
  Query01.Parameters[0].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text));
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].AsString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfGruposAuxAlfaDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfGruposAuxAlfaDfn.BitBtn3Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add(' DELETE FROM GRUPOSAUXALFADFN WHERE CODSIS=:A AND CODGRUPO=:B AND CODAUXGRUPO=:C'); 
    Query01.Parameters[0].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text));
    Query01.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text));
    Query01.Parameters[2].Value := Edit1.Text;
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

procedure TfGruposAuxAlfaDfn.BitBtn1Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODAUXGRUPO FROM gruposAuxAlfaDfn WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODAUXGRUPO=:A03');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codAuxGrupo;
    Query01.Open;
    if Query01.Eof then
      begin
      Query02.SQL.Clear;
      Query02.SQL.Add(' INSERT INTO GRUPOSAUXALFADFN (CODSIS, CODGRUPO, CODAUXGRUPO) VALUES (:A,:B,:C) ');
      Query02.Parameters[0].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text));
      Query02.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text));
      Query02.Parameters[2].Value := Edit1.Text;
      Query02.ExecSQL;
      end
    else
      begin
      Query02.SQL.Clear;
      Query02.SQL.Add(' UPDATE GRUPOSAUXALFADFN SET CODSIS=:A, CODGRUPO=:B, CODAUXGRUPO=:C ');
      Query02.SQL.Add(' WHERE CODSIS=:D AND CODGRUPO=:E AND CODAUXGRUPO=:F ');
      Query02.Parameters[0].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text));
      Query02.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text));
      Query02.Parameters[2].Value := Edit1.Text;
      Query02.Parameters[3].Value := codSis;
      Query02.Parameters[4].Value := codGrupo;
      Query02.Parameters[5].Value := codAuxGrupo;
      Query02.ExecSQL;
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
Self.Close;
end;

end.
