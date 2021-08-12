unit movtoCD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DB, System.UITypes;

type
  TfMovtoCD = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    ComboBox3: TComboBox;
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
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
  fMovtoCD: TfMovtoCD;
  tTabela : TDataSet;

implementation

uses dataModule,principal;

{$R *.dfm}

function TfMovtoCD.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfMovtoCD.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfMovtoCD.SpeedButton2Click(Sender: TObject);
begin
fMovtoCD.Close;
end;

procedure TfMovtoCD.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfMovtoCD.FormShow(Sender: TObject);
begin
Label2.Caption := vpNomeDoGrupo;
label3.Caption := vpNomeDoSistema;
ComboBox1.Items.Clear;
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
ComboBox1.Text := '';
ComboBox2.Text := '';
ComboBox3.Text := '';
checkBox1.Checked := false;
checkBox2.Checked := false;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox3.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString);
    if (Self.Tag=0) and (Query01.Fields[0].AsInteger = tTabela.Fields[0].AsInteger) then
      ComboBox3.Text := Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODREL, NOMEREL FROM DFN ORDER BY CODREL');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString);
    if (Self.Tag=0) and (Query01.Fields[0].AsString = tTabela.Fields[2].AsString) then
      ComboBox1.Text := Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
ComboBox3Change(Sender);
if fMovtoCD.Tag = 0 then
  begin
  if tTabela.Fields[3].Value = 'S' then
    checkBox1.Checked := true;
  if tTabela.Fields[4].Value = 'S' then
    checkBox2.Checked := true;
  end
end;

procedure TfMovtoCD.BitBtn3Click(Sender: TObject);
begin
//if messageDlg('Esta operação pode ser desfeita, continuar ?',mtConfirmation,[mbYes,mbNo],0) = mrNo then               Romero -> comentei em 01/04/2013
//  exit;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
     Query01.SQL.Clear;
     Query01.SQL.Add('DELETE FROM RELATOCD WHERE CODSIS=:A AND CODGRUPO=:B AND CODREL=:C');
     Query01.Parameters[0].Value := Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)-1);
     Query01.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)-1);
     Query01.Parameters[2].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)-1);
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
fMovtoCD.Close;
end;

procedure TfMovtoCD.BitBtn1Click(Sender: TObject);
var
  seguranca,
  dirExpl: Variant;
begin

if trim(ComboBox3.Text)='' then
  begin
  messageDlg('É necessário informar o código do sistema.',mtInformation,[mbOk],0);
  ComboBox3.SetFocus;
  exit;
  end;

if trim(ComboBox2.Text)='' then
  begin
  messageDlg('É necessário informar o código do grupo.',mtInformation,[mbOk],0);
  ComboBox2.SetFocus;
  exit;
  end;

if trim(ComboBox1.Text)='' then
  begin
  messageDlg('É necessário informar o código do relatório.',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;

seguranca := 'N';
if checkBox1.Checked then
  seguranca := 'S';

dirExpl := 'N';
if checkBox2.Checked then
  dirExpl := 'S';

with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    if (self.tag = 0) then
      begin
      Query02.SQL.Clear;
      Query02.SQL.Add('UPDATE RELATOCD SET CODSIS=:A, CODGRUPO=:B, CODREL=:C, SEGURANCA=:D, DIREXPL=:E ');
      Query02.SQL.Add('WHERE CODSIS=:F AND CODGRUPO=:G AND CODREL=:H ');
      Query02.Parameters[0].Value := Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)-1);
      Query02.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)-1);
      Query02.Parameters[2].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)-1);
      Query02.Parameters[3].Value := seguranca;
      Query02.Parameters[4].Value := dirExpl;
      Query02.Parameters[5].Value := tTabela.Fields[0].AsInteger;
      Query02.Parameters[6].Value := tTabela.Fields[1].AsInteger;
      Query02.Parameters[7].Value := tTabela.Fields[2].AsString;
      Query02.ExecSQL;
      end
    else
      begin
      Query01.SQL.Clear;
      Query01.SQL.Add('SELECT CODREL FROM RELATOCD WHERE CODSIS=:A AND CODGRUPO=:B AND CODREL=:C ');
      Query01.Parameters[0].Value := Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)-1);
      Query01.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)-1);
      Query01.Parameters[2].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)-1);
      Query01.Open;
      if Query01.Eof then
        begin
        Query02.SQL.Clear;
        Query02.SQL.Add('INSERT INTO RELATOCD (CODSIS,CODGRUPO,CODREL,SEGURANCA,DIREXPL) ');
        Query02.SQL.Add('VALUES (:A,:B,:C,:D,:E) ');
        Query02.Parameters[0].Value := Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)-1);
        Query02.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)-1);
        Query02.Parameters[2].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)-1);
        Query02.Parameters[3].Value := seguranca;
        Query02.Parameters[4].Value := dirExpl;
        Query02.ExecSQL;
        end
      else
        begin
        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE RELATOCD SET CODSIS=:A, CODGRUPO=:B, CODREL=:C, SEGURANCA=:D, DIREXPL=:E ');
        Query02.SQL.Add('WHERE CODSIS=:F AND CODGRUPO=:G AND CODREL=:H ');
        Query02.Parameters[0].Value := Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)-1);
        Query02.Parameters[1].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)-1);
        Query02.Parameters[2].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)-1);
        Query02.Parameters[3].Value := seguranca;
        Query02.Parameters[4].Value := dirExpl;
        Query02.Parameters[5].Value := Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)-1);
        Query02.Parameters[6].Value := Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text)-1);
        Query02.Parameters[7].Value := Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text)-1);
        Query02.ExecSQL;
        end;
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
fMovtoCD.Close;
end;

procedure TfMovtoCD.ComboBox3Change(Sender: TObject);
begin
ComboBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add(' SELECT DISTINCT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN ');
  if trim(comboBox3.Text) <> '' then
    begin
    Query01.SQL.Add(' WHERE CODSIS=:A ');
    Query01.Parameters[0].Value := Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text)-1);
    end;
  Query01.SQL.Add(' ORDER BY CODGRUPO ');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].AsString + ' : ' +Query01.Fields[1].AsString);
    if (Self.Tag=0) and (Query01.Fields[0].AsInteger = tTabela.Fields[1].AsInteger) then
      ComboBox2.Text := Query01.Fields[0].AsString + ' : ' +Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

end.
