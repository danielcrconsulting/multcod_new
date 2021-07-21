unit mascaraCampos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, DBCtrls, StdCtrls, DB, Mask, System.UITypes;

type
  TfMascaraCampos = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton2: TSpeedButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
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
  fMascaraCampos: TfMascaraCampos;
  tTabela : TDataSet;
  codRel,
  nomeCampo: String;

implementation

uses dataModule;

{$R *.dfm}

function TfMascaraCampos.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfMascaraCampos.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfMascaraCampos.FormShow(Sender: TObject);
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
    if (fMascaraCampos.Tag = 0) and (tTabela.Fields[0].AsString=Query01.Fields[0].AsString) then
      ComboBox1.Text := Query01.Fields[0].AsString+' : '+Query01.Fields[1].AsString;
    Query01.Next;
    end;
  Query01.Close;
  end;
if (fMascaraCampos.Tag = 0) then
  begin
  Edit1.Text := tTabela.Fields[1].AsString;
  Edit2.Text := tTabela.Fields[2].AsString;
  Edit3.Text := tTabela.Fields[3].AsString;
  Edit4.Text := tTabela.Fields[4].AsString;
  Edit5.Text := tTabela.Fields[5].AsString;
  end
else
  begin
  ComboBox1.Text := '';
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  end;
codRel := trim(upperCase(Copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text))));
nomeCampo := Edit1.Text;
end;

procedure TfMascaraCampos.SpeedButton2Click(Sender: TObject);
begin
Close;
end;

procedure TfMascaraCampos.BitBtn2Click(Sender: TObject);
begin
ComboBox1.Text := tTabela.Fields[0].AsString;
Edit1.Text := tTabela.Fields[1].AsString;
Edit2.Text := tTabela.Fields[2].AsString;
Edit3.Text := tTabela.Fields[3].AsString;
Edit4.Text := tTabela.Fields[4].AsString;
Edit5.Text := tTabela.Fields[5].AsString;
end;

procedure TfMascaraCampos.BitBtn1Click(Sender: TObject);
var
  codRel2,
  nomeCampo2,
  tmpNomeCampo,
  linhaI,
  linhaF,
  coluna,
  tamanho: variant;
begin
codRel2 := trim(upperCase(Copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text))));
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
  linhaF := strToInt(Edit3.Text);
  coluna := strToInt(Edit4.Text);
  tamanho := strToInt(Edit5.Text);
except
  on e:exception do
    begin
    messageDlg('As informações referentes a linha inicial e final, coluna e tamanho do campo devem ser todas numéricas.',mtInformation,[mbOk],0);
    Edit2.SetFocus;
    exit;
    end;
  end;

screen.Cursor := crHourGlass;
tmpNomeCampo := 'tmp' + formatDateTime('hhnnss',Now);
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT COUNT(1) FROM MASCARACAMPO WHERE CODREL = '''+codRel+''' AND NOMECAMPO = '''+nomeCampo+'''');
    Query01.Open;
    if Query01.Fields[0].AsInteger < 1 then
      begin
      // Se não achou o registro insere um novo direto
      qMascaraCamposINS.Parameters[0].Value := codRel2;
      qMascaraCamposINS.Parameters[1].Value := nomeCampo2;
      qMascaraCamposINS.Parameters[2].Value := linhaI;
      qMascaraCamposINS.Parameters[3].Value := linhaF;
      qMascaraCamposINS.Parameters[4].Value := coluna;
      qMascaraCamposINS.Parameters[5].Value := tamanho;
      qMascaraCamposINS.ExecSql;
      end
    else
      begin
      // Se já existe um registro precisa fazer o update em cascata para evitar violação de integridade
      qMascaraCamposINS.Parameters[0].Value := codRel2;
      qMascaraCamposINS.Parameters[1].Value := tmpNomeCampo;
      qMascaraCamposINS.Parameters[2].Value := '0';
      qMascaraCamposINS.Parameters[3].Value := '0';
      qMascaraCamposINS.Parameters[4].Value := '0';
      qMascaraCamposINS.Parameters[5].Value := '0';
      qMascaraCamposINS.ExecSql;
      // Update nas tabelas filhas (chaves originais -> chaves temporárias)
      Query02.SQL.Clear;
      Query02.SQL.Add('UPDATE USUARIOMASCARA SET NOMECAMPO=:A01 WHERE CODREL=:A02 AND NOMECAMPO=:A03');
      Query02.Parameters[0].Value := tmpNomeCampo;
      Query02.Parameters[1].Value := codRel;
      Query02.Parameters[2].Value := nomeCampo;
      Query02.ExecSQL;
      // Update na tabela Pai
      qMascaraCamposUPD.Parameters[0].Value := codRel2;
      qMascaraCamposUPD.Parameters[1].Value := nomeCampo2;
      qMascaraCamposUPD.Parameters[2].Value := linhaI;
      qMascaraCamposUPD.Parameters[3].Value := linhaF;
      qMascaraCamposUPD.Parameters[4].Value := coluna;
      qMascaraCamposUPD.Parameters[5].Value := tamanho;
      qMascaraCamposUPD.Parameters[6].Value := codRel;
      qMascaraCamposUPD.Parameters[7].Value := nomeCampo;
      qMascaraCamposUPD.ExecSQL;
      // Update nas tabelas filhas (chaves temporárias -> chaves originais)
      Query02.SQL.Clear;
      Query02.SQL.Add('UPDATE USUARIOMASCARA SET NOMECAMPO=:A01 WHERE CODREL=:A02 AND NOMECAMPO=:A03');
      Query02.Parameters[0].Value := nomeCampo2;
      Query02.Parameters[1].Value := codRel2;
      Query02.Parameters[2].Value := tmpNomeCampo;
      Query02.ExecSQL;
      // Apaga registro temporário
      qMascaraCamposDEL.Parameters[0].Value := codRel2;
      qMascaraCamposDEL.Parameters[1].Value := tmpNomeCampo;
      qMascaraCamposDEL.ExecSql;
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
screen.Cursor := crDefault;
Close;
end;

procedure TfMascaraCampos.BitBtn3Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    //Query01.SQL.Clear;
    //Query01.SQL.Add('SELECT COUNT(1) FROM MASCARACAMPO WHERE CODREL = '''+ComboBox1.Text+''' AND NOMECAMPO = '''+Edit1.Text+'''');
    //Query01.Open;
    //if Query01.Fields[0].AsInteger < 1 then
    //  begin // Apaga registros filhos
      qUsuarioMascaraDEL.Parameters[0].Value := trim(upperCase(Copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text))));
      qUsuarioMascaraDEL.Parameters[1].Value := Edit1.Text;
      qUsuarioMascaraDEL.ExecSQL;
    //  end;
      // Apaga registro principal
      qMascaraCamposDEL.Parameters[0].Value := trim(upperCase(Copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text))));
      qMascaraCamposDEL.Parameters[1].Value := Edit1.Text;
      qMascaraCamposDEL.ExecSQL;
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
Close;
end;

end.
