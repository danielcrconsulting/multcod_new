unit sisAuto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, System.UITypes;

type
  TfSisAuxDfn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label6: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    ComboBox4: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Edit4: TEdit;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
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
  fSisAuxDfn: TfSisAuxDfn;
  tTabela : TDataSet;
  arrSistema : array of integer;
  arrGrupo : array of integer;
  arrDfn : array of string;
  codRel,
  tipo,
  codAux : string;
  codSis,
  codGrupo,
  LinI,
  LinF,
  Coluna : Integer;

implementation

uses dataModule,principal;

{$R *.dfm}

function TfSisAuxDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfSisAuxDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfSisAuxDfn.FormShow(Sender: TObject);
begin
Label1.Caption := vpNomeDoSistema;
Label2.Caption := vpNomeDoGrupo;
ComboBox1.Items.Clear;
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
ComboBox1.Text := '';
ComboBox2.Text := '';
ComboBox3.Text := '';
ComboBox4.Text := '';
Edit1.Text := '';
Edit2.Text := '';
Edit3.Text := '';
Edit4.Text := '';
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODSIS, NOMESIS FROM SISTEMA ORDER BY NOMESIS');
  Query01.Open;
  setLength(arrSistema,Query01.RecordCount+1);
  while not Query01.Eof do
    begin
    arrSistema[ComboBox1.Items.Add(Query01.Fields[1].asString)] := Query01.Fields[0].AsInteger;
    if (Self.Tag=0) and (Query01.Fields[0].AsInteger=tTabela.Fields[1].AsInteger) then
      ComboBox1.Text := Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
if Self.Tag=0 then
  begin
  codRel := tTabela.Fields[0].AsString;
  codSis := tTabela.Fields[1].AsInteger;
  codGrupo := tTabela.Fields[2].AsInteger;
  LinI := tTabela.Fields[3].AsInteger;
  LinF := tTabela.Fields[4].AsInteger;
  Coluna := tTabela.Fields[5].AsInteger;
  tipo := Uppercase(tTabela.Fields[6].AsString);
  codAux := tTabela.Fields[7].AsString;
  ComboBox1Change(Sender);
  ComboBox2Change(Sender);
  Edit1.Text := tTabela.Fields[3].AsString;
  Edit2.Text := tTabela.Fields[4].AsString;
  Edit3.Text := tTabela.Fields[5].AsString;
  Edit4.Text := tTabela.Fields[7].AsString;
  if Uppercase(tTabela.Fields[6].AsString) = 'A' then
    ComboBox4.Text := 'Alfanumérico'
  else
    ComboBox4.Text := 'Numérico';
  end
else
  begin
  codRel := '';
  codSis := 0;
  codGrupo := 0;
  LinI := 0;
  LinF := 0;
  Coluna := 0;
  tipo := '';
  codAux := '';
  end;
end;

procedure TfSisAuxDfn.ComboBox1Change(Sender: TObject);
begin
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN WHERE 1=1 ');
  if arrSistema[ComboBox1.Items.IndexOf(ComboBox1.Text)] > 0 then
    Query01.SQL.Add(' AND CODSIS = ? ');
  Query01.SQL.Add(' ORDER BY NOMEGRUPO');
  if arrSistema[ComboBox1.Items.IndexOf(ComboBox1.Text)] > 0 then
    QUery01.Parameters[0].Value := arrSistema[ComboBox1.Items.IndexOf(ComboBox1.Text)];
  Query01.Open;
  setLength(arrGrupo,Query01.RecordCount+1);
  while not Query01.Eof do
    begin
    arrGrupo[ComboBox2.Items.Add(Query01.Fields[1].asString)] := Query01.Fields[0].AsInteger;
    if (Self.Tag=0) and (trim(Query01.Fields[0].Value)=trim(tTabela.Fields[2].Value)) then
      ComboBox2.Text := Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
ComboBox2Change(sender);
end;

procedure TfSisAuxDfn.ComboBox2Change(Sender: TObject);
begin
ComboBox3.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODREL, NOMEREL FROM DFN WHERE SISAUTO = ? ORDER BY 1');
  Query01.Parameters[0].Value := 'T';
  Query01.Open;
  setLength(arrDfn,Query01.RecordCount+1);
  while not Query01.Eof do
    begin
    arrDfn[ComboBox3.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString)] := Query01.Fields[0].AsString;
    if (Self.Tag=0) and (trim(Query01.Fields[0].Value)=trim(tTabela.Fields[0].Value)) then
      ComboBox3.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfSisAuxDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfSisAuxDfn.BitBtn3Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  if messageDlg('Tem certeza de que deseja prosseguir ?',mtConfirmation,[mbYes,mbNo],0)=mrNo then
    exit;
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM SISAUXDFN WHERE CODREL=:A AND CODSIS=:B AND CODGRUPO=:C AND LINI=:D AND LINF=:E AND COL=:F AND TIPO=:G AND CODAUX=:H');
    Query01.Parameters[0].Value := arrDfn[ComboBox3.Items.IndexOf(ComboBox3.Text)];
    Query01.Parameters[1].Value := arrSistema[ComboBox1.Items.IndexOf(ComboBox1.Text)];
    Query01.Parameters[2].Value := arrGrupo[ComboBox2.Items.IndexOf(ComboBox2.Text)];
    Query01.Parameters[3].Value := Edit1.Text;
    Query01.Parameters[4].Value := Edit2.Text;
    Query01.Parameters[5].Value := Edit3.Text;
    Query01.Parameters[6].Value := Copy(ComboBox4.Text,1,1);
    Query01.Parameters[7].Value := Edit4.Text;
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
self.Close;
end;

procedure TfSisAuxDfn.BitBtn1Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM SISAUXDFN WHERE CODREL=:A AND CODSIS=:B AND CODGRUPO=:C AND LINI=:D AND LINF=:E AND COL=:F AND TIPO=:G AND CODAUX=:H');
    Query01.Parameters[0].Value := codRel;
    Query01.Parameters[1].Value := codSis;
    Query01.Parameters[2].Value := codGrupo;
    Query01.Parameters[3].Value := LinI;
    Query01.Parameters[4].Value := LinF;
    Query01.Parameters[5].Value := Coluna;
    Query01.Parameters[6].Value := tipo;
    Query01.Parameters[7].Value := codAux;
    Query01.ExecSQL;

    Query02.SQL.Clear;
    Query02.SQL.Add('INSERT INTO SISAUXDFN (CODREL,CODSIS,CODGRUPO,LINI,LINF,COL,TIPO,CODAUX) VALUES (?,?,?,?,?,?,?,?)');
    Query02.Parameters[0].Value := arrDfn[ComboBox3.Items.IndexOf(ComboBox3.Text)];
    Query02.Parameters[1].Value := arrSistema[ComboBox1.Items.IndexOf(ComboBox1.Text)];
    Query02.Parameters[2].Value := arrGrupo[ComboBox2.Items.IndexOf(ComboBox2.Text)];
    Query02.Parameters[3].Value := Edit1.Text;
    Query02.Parameters[4].Value := Edit2.Text;
    Query02.Parameters[5].Value := Edit3.Text;
    Query02.Parameters[6].Value := UpperCase(Copy(ComboBox4.Text,1,1));
    Query02.Parameters[7].Value := Edit4.Text;
    Query02.ExecSQL;
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

procedure TfSisAuxDfn.SpeedButton2Click(Sender: TObject);
begin
self.Close;
end;

end.
