unit indicesDfn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DB, System.UITypes;

type
  TfIndicesDfn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    ComboBox2: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox3: TComboBox;
    Label9: TLabel;
    Edit6: TEdit;
    Label10: TLabel;
    Edit7: TEdit;
    Label11: TLabel;
    Edit8: TEdit;
    Label12: TLabel;
    Edit9: TEdit;
    Label13: TLabel;
    Edit10: TEdit;
    Label14: TLabel;
    Edit11: TEdit;
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
  fIndicesDfn: TfIndicesDfn;
  tTabela : TDataSet;
  codRel : String;
  nomeCampo : String;

implementation

uses dataModule, formGrade;

{$R *.dfm}

function TfIndicesDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfIndicesDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfIndicesDfn.FormShow(Sender: TObject);
begin
ComboBox1.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODREL, NOMEREL FROM DFN ORDER BY CODREL');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString+' : '+Query01.Fields[1].AsString);
    if (fIndicesDfn.Tag = 0) and (trim(tTabela.Fields[0].AsString) = trim(Query01.Fields[0].AsString)) then
      begin
      ComboBox1.Text := Query01.Fields[0].AsString+' : '+Query01.Fields[1].AsString;
//      tIndicesDFN.Filter := 'CODREL = ' + '''' + Query01.Fields[0].AsString + '''';         // Romero 18/07/2013
//      tIndicesDFN.Filtered := True;
      end;
    Query01.Next;
    end;
  Query01.Close;
  end;
if fIndicesDfn.Tag = 0 then
  begin
  ComboBox2.ItemIndex := tTabela.Fields[6].Value;
  if tTabela.Fields[7].AsString = 'C' then
    ComboBox3.ItemIndex := 0
  else if tTabela.Fields[7].AsString = 'Dt' then
    ComboBox3.ItemIndex := 1
  else if tTabela.Fields[7].AsString = 'D' then
    ComboBox3.ItemIndex := 2
  else if tTabela.Fields[7].AsString = 'F' then
    ComboBox3.ItemIndex := 3
  else if tTabela.Fields[7].AsString = 'N' then
    ComboBox3.ItemIndex := 4
  else
    ComboBox3.ItemIndex := -1;
  Edit1.Text := tTabela.Fields[1].AsString;
  Edit2.Text := tTabela.Fields[2].AsString;
  Edit3.Text := tTabela.Fields[3].AsString;
  Edit4.Text := tTabela.Fields[4].AsString;
  Edit5.Text := tTabela.Fields[5].AsString;
  Edit6.Text := tTabela.Fields[8].AsString;
  Edit7.Text := tTabela.Fields[9].AsString;
  Edit8.Text := tTabela.Fields[10].AsString;
  Edit9.Text := tTabela.Fields[11].AsString;
  Edit10.Text := tTabela.Fields[12].AsString;
  Edit11.Text := tTabela.Fields[13].AsString;
  end
else
  begin
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  ComboBox3.Text := '';
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  Edit7.Text := '';
  Edit8.Text := '';
  Edit9.Text := '';
  Edit10.Text := '';
  Edit11.Text := '';
  end;
codRel := upperCase(copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text)));
nomeCampo := Edit1.Text;
end;

procedure TfIndicesDfn.SpeedButton2Click(Sender: TObject);
begin
fIndicesDfn.Close;
end;

procedure TfIndicesDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfIndicesDfn.BitBtn3Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    qIndicesDfnDEL.Parameters[0].Value := trim(upperCase(Copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text))));
    qIndicesDfnDEL.Parameters[1].Value := Edit1.Text;
    qIndicesDfnDEL.ExecSQL;
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
//fGrade.CarregaGrid;         // Romero 18/07/2013
end;

procedure TfIndicesDfn.BitBtn1Click(Sender: TObject);
var
  codRel2,
  nomeCampo2,
  tipo,
  mascara,
  charInc,
  charExc,
  strInc,
  strExc,
  linhaI,
  linhaF,
  coluna,
  tamanho,
  branco,
  fusao: variant;
begin

codRel2 := upperCase(copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text)));
if trim(codRel2)='' then
  begin
  messageDlg('É necessário informar o código do relatório.',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;

nomeCampo2 := upperCase(Edit1.Text);
if trim(nomeCampo2)='' then
  begin
  messageDlg('É necessário informar o nome do campo do relatório.',mtInformation,[mbOk],0);
  Edit1.SetFocus;
  exit;
  end;

try
  linhaI := strToInt(Edit2.Text);
except
  on e:exception do
    begin
    messageDlg('É necessário informar um valor numérico para a linha inicial do campo.',mtInformation,[mbOk],0);
    Edit2.SetFocus;
    exit;
    end;
  end;

try
  linhaF := strToInt(Edit3.Text);
except
  on e:exception do
    begin
    messageDlg('É necessário informar um valor numérico para a linha final do campo.',mtInformation,[mbOk],0);
    Edit3.SetFocus;
    exit;
    end;
  end;

try
  coluna := strToInt(Edit4.Text);
except
  on e:exception do
    begin
    messageDlg('É necessário informar um valor numérico para a coluna inicial do campo.',mtInformation,[mbOk],0);
    Edit4.SetFocus;
    exit;
    end;
  end;

try
  tamanho := strToInt(Edit5.Text);
except
  on e:exception do
    begin
    messageDlg('É necessário informar um valor numérico para o tamanho da coluna do campo.',mtInformation,[mbOk],0);
    Edit5.SetFocus;
    exit;
    end;
  end;

branco := ComboBox2.ItemIndex;

if ComboBox3.ItemIndex = 0 then
  tipo := 'C'
else if ComboBox3.ItemIndex = 1 then
  tipo := 'Dt'
else if ComboBox3.ItemIndex = 2 then
  tipo := 'D'
else if ComboBox3.ItemIndex = 3 then
  tipo := 'F'
else if ComboBox3.ItemIndex = 4 then
  tipo := 'N'
else
  tipo := null;

mascara := upperCase(Edit6.Text);
if trim(mascara)='' then
  mascara := null;

charInc := upperCase(Edit7.Text);
if trim(charInc)='' then
  charInc := null;

charExc := upperCase(Edit8.Text);
if trim(charExc)='' then
  charExc := null;

strInc := upperCase(Edit9.Text);
if trim(strInc)='' then
  strInc := null;

strExc := upperCase(Edit10.Text);
if trim(strExc)= '' then
  strExc := null;

try
  fusao := strToInt(Edit11.Text);
except
  on e:exception do
    begin
    fusao := null;
    end;
  end;

with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODREL FROM INDICESDFN WHERE CODREL='''+codRel+''' AND NOMECAMPO='''+nomeCampo+''' ');
    Query01.Open;
    if query01.Eof then
      begin
      qIndicesDfnINS.Parameters[0].Value := codRel2;
      qIndicesDfnINS.Parameters[1].Value := nomeCampo2;
      qIndicesDfnINS.Parameters[2].Value := linhaI;
      qIndicesDfnINS.Parameters[3].Value := linhaF;
      qIndicesDfnINS.Parameters[4].Value := coluna;
      qIndicesDfnINS.Parameters[5].Value := tamanho;
      qIndicesDfnINS.Parameters[6].Value := branco;
      qIndicesDfnINS.Parameters[7].Value := tipo;
      qIndicesDfnINS.Parameters[8].Value := mascara;
      qIndicesDfnINS.Parameters[9].Value := charInc;
      qIndicesDfnINS.Parameters[10].Value := charExc;
      qIndicesDfnINS.Parameters[11].Value := strInc;
      qIndicesDfnINS.Parameters[12].Value := strExc;
      qIndicesDfnINS.Parameters[13].Value := fusao;
      qIndicesDfnINS.ExecSQL;
      end
    else
      begin
      qIndicesDfnUPD.Parameters[0].Value := codRel2;
      qIndicesDfnUPD.Parameters[1].Value := nomeCampo2;
      qIndicesDfnUPD.Parameters[2].Value := linhaI;
      qIndicesDfnUPD.Parameters[3].Value := linhaF;
      qIndicesDfnUPD.Parameters[4].Value := coluna;
      qIndicesDfnUPD.Parameters[5].Value := tamanho;
      qIndicesDfnUPD.Parameters[6].Value := branco;
      qIndicesDfnUPD.Parameters[7].Value := tipo;
      qIndicesDfnUPD.Parameters[8].Value := mascara;
      qIndicesDfnUPD.Parameters[9].Value := charInc;
      qIndicesDfnUPD.Parameters[10].Value := charExc;
      qIndicesDfnUPD.Parameters[11].Value := strInc;
      qIndicesDfnUPD.Parameters[12].Value := strExc;
      qIndicesDfnUPD.Parameters[13].Value := fusao;
      qIndicesDfnUPD.Parameters[14].Value := codRel;
      qIndicesDfnUPD.Parameters[15].Value := nomeCampo;
      qIndicesDfnUPD.ExecSQL;
      end;
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
fIndicesDfn.Close;
//fGrade.CarregaGrid;         // Romero 18/07/2013
end;

end.
