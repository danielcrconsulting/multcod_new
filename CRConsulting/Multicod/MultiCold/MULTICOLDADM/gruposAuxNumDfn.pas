unit gruposAuxNumDfn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, System.UITypes;

type
  TfGruposAuxNumDfn = class(TForm)
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
  fGruposAuxNumDfn: TfGruposAuxNumDfn;
  tTabela : TDataSet;
  codSis,
  codGrupo,
  codAuxGrupo: Integer;

implementation

uses dataModule,principal;

{$R *.dfm}

function TfGruposAuxNumDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfGruposAuxNumDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfGruposAuxNumDfn.SpeedButton2Click(Sender: TObject);
begin
fGruposAuxNumDfn.Close;
end;

procedure TfGruposAuxNumDfn.FormShow(Sender: TObject);
begin
label1.Caption := vpNomeDoSistema;
label2.Caption := vpNomeDoGrupo;
ComboBox1.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    if (fGruposAuxNumDfn.Tag = 0) and (Query01.Fields[0].AsInteger = tTabela.Fields[0].AsInteger) then
      ComboBox1.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;
if fGruposAuxNumDfn.Tag = 0 then
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
  codSis := tTabela.Fields[0].AsInteger;
  codGrupo := tTabela.Fields[1].AsInteger;
  end
else
  begin
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  Edit1.Text := '';
  codSis := -1;
  codGrupo := -1;
  end;
try
  codAuxGrupo := strToInt(Edit1.Text);
except
  codAuxGrupo := 0;
end;
end;

procedure TfGruposAuxNumDfn.ComboBox1Change(Sender: TObject);
begin
ComboBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN WHERE CODSIS=:A');
  Query01.Parameters[0].Value := trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)));
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfGruposAuxNumDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfGruposAuxNumDfn.BitBtn3Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOSAUXNUMDFN WHERE CODSIS=:A AND CODGRUPO=:B AND CODAUXGRUPO=:C'); 
    Query01.Parameters[0].Value := trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)));
    Query01.Parameters[1].Value := trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)));
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

procedure TfGruposAuxNumDfn.BitBtn1Click(Sender: TObject);
var
  codAuxGrupo2 : Integer;
begin
try
  codAuxGrupo2 := strToInt(Edit1.Text);
except
    on e:exception do
      begin
      messageDlg('O valor do código auxiliar deve ser numérico.',mtInformation,[mbOk],0);
      Edit1.SetFocus;
      exit;
      end;
  end;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODAUXGRUPO FROM GRUPOSAUXNUMDFN WHERE CODSIS=:A01 AND CODGRUPO=:A02 AND CODAUXGRUPO=:A03');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGrupo;
    Query01.Parameters[2].Value := codAuxGrupo;
    Query01.Open;
    if Query01.Eof then
      begin
      qGruposAuxNumDfnINS.Parameters[0].Value := trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)));
      qGruposAuxNumDfnINS.Parameters[1].Value := trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)));
      qGruposAuxNumDfnINS.Parameters[2].Value := codAuxGrupo2;
      qGruposAuxNumDfnINS.ExecSQL;
      end
    else
      begin
      qGruposAuxNumDfnUPD.Parameters[0].Value := trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)));
      qGruposAuxNumDfnUPD.Parameters[1].Value := trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)));
      qGruposAuxNumDfnUPD.Parameters[2].Value := codAuxGrupo2;
      qGruposAuxNumDfnUPD.Parameters[3].Value := codSis;
      qGruposAuxNumDfnUPD.Parameters[4].Value := codGrupo;
      qGruposAuxNumDfnUPD.Parameters[5].Value := codAuxGrupo;
      qGruposAuxNumDfnUPD.ExecSQL;
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
