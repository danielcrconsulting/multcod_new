unit dfn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, StdCtrls, Buttons, System.UITypes, Subrug;

type
  TfDfn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    ComboBox3: TComboBox;
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Label7: TLabel;
    Edit4: TEdit;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    Edit6: TEdit;
    Label10: TLabel;
    Edit7: TEdit;
    Label11: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Edit10: TEdit;
    CheckBox1: TCheckBox;
    SpeedButton1: TSpeedButton;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    RadioGroup1: TRadioGroup;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    CheckBox7: TCheckBox;
    Panel3: TPanel;
    Label15: TLabel;
    Edit12: TEdit;
    Edit15: TEdit;
    Label16: TLabel;
    Edit13: TEdit;
    Edit16: TEdit;
    Panel4: TPanel;
    Label17: TLabel;
    Edit17: TEdit;
    Panel5: TPanel;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    RadioGroup2: TRadioGroup;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    BitBtn4: TBitBtn;
    FileOpenDialog1: TFileOpenDialog;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
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
  fDfn: TfDfn;
  tTabela : TDataSet;
  ehSalvarComo : boolean;

implementation

uses dataModule, principal, formGrade;

{$R *.dfm}

function TfDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfDfn.SpeedButton2Click(Sender: TObject);
begin
Self.Close;
end;

procedure TfDfn.FormShow(Sender: TObject);
begin
ehSalvarComo := false;
label1.Caption := vpNomeDoSistema;
checkBox10.Caption := vpNomeDoSistema+' automático';
label2.Caption := vpNomeDoGrupo;
checkBox6.Caption := vpNomeDoGrupo+' automático';
label3.Caption := vpNomeDoSubGrupo;
ComboBox1.Items.Clear;
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
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
Edit12.Text := '';
Edit13.Text := '';
Edit15.Text := '';
Edit16.Text := '';
Edit17.Text := '';
Edit18.Text := '';
Edit19.Text := '';
Edit20.Text := '';
CheckBox1.Checked := false;
CheckBox2.Checked := false;
CheckBox3.Checked := false;
CheckBox4.Checked := false;
CheckBox5.Checked := false;
CheckBox6.Checked := false;
CheckBox7.Checked := false;
CheckBox8.Checked := false;
CheckBox9.Checked := false;
CheckBox10.Checked := false;
RadioGroup1.ItemIndex := -1;
RadioGroup2.ItemIndex := -1;
Label19.Caption := '';
Label21.Caption := '';
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODSIS, NOMESIS FROM SISTEMA ORDER BY CODSIS');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    if (Self.Tag=0) and (trim(Query01.Fields[0].Value)=trim(tTabela.Fields[2].Value)) then
      ComboBox1.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;
if Self.Tag=0 then
  begin
  ComboBox1Change(Sender);
  ComboBox2Change(Sender);
  Edit1.Text := tTabela.Fields[0].AsString;
  Edit2.Text := tTabela.Fields[1].AsString;
  Edit3.Text := tTabela.Fields[5].AsString;
  Edit4.Text := tTabela.Fields[6].AsString;
  Edit5.Text := tTabela.Fields[7].AsString;
  Edit6.Text := tTabela.Fields[8].AsString;
  Edit7.Text := tTabela.Fields[9].AsString;
  Edit8.Text := tTabela.Fields[10].AsString;
  Edit9.Text := tTabela.Fields[11].AsString;
  Edit10.Text := tTabela.Fields[22].AsString;
  Edit12.Text := tTabela.Fields[13].AsString;
  Edit13.Text := tTabela.Fields[14].AsString;
  Edit15.Text := tTabela.Fields[15].AsString;
  Edit16.Text := tTabela.Fields[16].AsString;
  Edit17.Text := tTabela.Fields[18].AsString;
  Edit18.Text := tTabela.Fields[24].AsString;
  Edit19.Text := tTabela.Fields[25].AsString;
  Edit20.Text := tTabela.Fields[26].AsString;
  CheckBox1.Checked := (tTabela.Fields[30].AsString='A');
  CheckBox2.Checked := (tTabela.Fields[19].AsString='T');
  CheckBox3.Checked := (tTabela.Fields[20].AsString='T');
  CheckBox4.Checked := (tTabela.Fields[21].AsString='T');
  CheckBox5.Checked := (tTabela.Fields[29].AsString='T');
  CheckBox6.Checked := (tTabela.Fields[23].AsString='T');
  CheckBox7.Checked := (tTabela.Fields[35].AsString='T');
  CheckBox8.Checked := (tTabela.Fields[17].AsString='T');
  CheckBox9.Checked := (tTabela.Fields[28].AsString='T');
  CheckBox10.Checked := (tTabela.Fields[36].AsString='T');
  RadioGroup1.ItemIndex := tTabela.Fields[12].AsInteger-1;
  if tTabela.Fields[27].AsString='A' then
    RadioGroup2.ItemIndex := 0
  else if tTabela.Fields[27].AsString='N' then 
    RadioGroup2.ItemIndex := 1;
  Label19.Caption := FormatDateTime('dd/mm/yyyy - hh:nn:ss',tTabela.Fields[31].AsDateTime);
  Label21.Caption := FormatDateTime('dd/mm/yyyy - hh:nn:ss',tTabela.Fields[33].AsDateTime);
  end;
end;

procedure TfDfn.RadioGroup1Click(Sender: TObject);
begin
with RadioGroup1 do
  begin
  case itemIndex of
    3:begin
      with Panel3 do
        begin
        left := 180;
        top := 316;
        color := clBtnFace;
        visible := true;
        end;
      panel4.Visible := false;
      end;
    2:begin
      with Panel4 do
        begin
        left := 180;
        top := 316;
        color := clBtnFace;
        visible := true;
        end;
      panel3.Visible := false;
      end;
    else
      begin
      Panel3.Visible := false;
      Panel4.Visible := false;
      end;
    end;
  end;
end;

procedure TfDfn.ComboBox1Change(Sender: TObject);
var
  codSis: Integer;
begin
ComboBox2.Items.Clear;
ComboBox3.Items.Clear;
ComboBox2.Text := '';
ComboBox3.Text := '';
codSis := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT DISTINCT CODGRUPO, NOMEGRUPO FROM GRUPOSDFN ');
  if codSis > 0 then
    Query01.SQL.Add('WHERE CODSIS=:A');
  Query01.SQL.Add('ORDER BY CODGRUPO');
  if codSis > 0 then
    Query01.Parameters[0].Value := codSis;
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox2.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    if (Self.Tag=0) and (Query01.Fields[0].AsString=tTabela.Fields[3].AsString) then
      ComboBox2.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfDfn.ComboBox2Change(Sender: TObject);
var
  i,
  codSis,
  codGrupo: Integer;
begin
ComboBox3.Items.Clear;
ComboBox3.Text := '';
codSis := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
codGrupo := strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
i := -1;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add(' SELECT DISTINCT CODSUBGRUPO, NOMESUBGRUPO FROM SUBGRUPOSDFN WHERE 1=1 ');
  if codSis  > 0 then
    begin
    inc(i);
    Query01.SQL.Add(' AND CODSIS=:A ');
    Query01.Parameters[i].Value := codSis;
    end;
  if codGrupo > 0 then
    begin
    inc(i);
    Query01.SQL.Add(' AND CODGRUPO=:B ');
    Query01.Parameters[i].Value := codGrupo;
    end;
  Query01.SQL.Add(' ORDER BY CODSUBGRUPO ');
  Query01.Open;
  while not Query01.Eof do
    begin
    ComboBox3.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    if (Self.Tag=0) and (Query01.Fields[0].AsString=tTabela.Fields[4].AsString) then
      ComboBox3.Text := Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString;
    Query01.Next;
    end;
  Query01.Close;
  end;

end;

procedure TfDfn.CheckBox6Click(Sender: TObject);
begin
if CheckBox6.Checked then
  with Panel5 do
    begin
    left := 180;
    top := 270;
    color := clBtnFace;
    visible := true;
    end
else
  Panel5.Visible := false;
end;

procedure TfDfn.SpeedButton1Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));

if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o diretório de entrada';
    if FileOpenDialog1.Execute then
      Edit9.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit9.Text := UpperCase(X);
  end;
end;

procedure TfDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfDfn.BitBtn3Click(Sender: TObject);
var
  codRel: String;
begin
codRel := upperCase(trim(Edit1.Text));
if codRel='*' then
  begin
  messageDlg('Este relatório não pode ser excluído.',mtError,[mbOk],0);
  Exit;
  end;
if codRel='' then
  begin
  messageDlg('O código do relatório é obrigatório para esta operação.',mtWarning,[mbOk],0);
  Edit1.SetFocus;
  Exit;
  end;
if messageDlg('Ao excluir um relatório informações dependentes serão excluídas automaticamente. Tem certeza de que deseja prosseguir ?',mtConfirmation,[mbOk,mbCancel],0)=mrCancel then
  Exit;
try
  screen.Cursor := crHourGlass;
  with repositorioDeDados do
    begin
    dbMulticold.BeginTrans;
    try
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM USUREL WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM GRUPOREL WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM USUARIOMASCARA WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM MASCARACAMPO WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM INDICESDFN WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM DESTINOSDFN WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM EXTRATOR WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM RELATOCD WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM SISAUXDFN WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
      Query01.ExecSQL;

      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM DFN WHERE CODREL=:A');
      Query01.Parameters[0].Value := codRel;
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
finally
  screen.Cursor := crDefault;
  end;
Self.Close;
//fGrade.CarregaGrid;         // Romero 23/07/2013
end;

procedure TfDfn.BitBtn1Click(Sender: TObject);
var
  codRel,
  nomeRel,
  codSis,
  codGrupo,
  codSubGrupo,
  idColuna1,
  idLinha1,
  idString1,
  idColuna2,
  idLinha2,
  idString2,
  dirEntra,
  tipoQuebra,
  colQuebraStr1,
  strQuebraStr1,
  colQuebraStr2,
  strQuebraStr2,
  quebraAfterStr,
  nLinhasQuebraLin,
  filtroCar,
  comprBrancos,
  juncaoAutom,
  qtdPagsAPular,
  codGrupAuto,
  colGrupAuto,
  linGrupAuto,
  tamGrupAuto,
  tipoGrupAuto,
  backupRel,
  subDirAuto,
  status,
  dtCriacao,
  hrCriacao,
  dtAlteracao,
  hrAlteracao,
  remove,
  sisAuto: Variant;
begin
// *****************************
// Consistência dos dados de DFN
// *****************************
codRel := upperCase(trim(Edit1.Text));
if (codRel='') then
  begin
  messageDlg('O código do relatório deve ser preenchido corretamente.',mtWarning,[mbOK],0);
  Edit1.SetFocus;
  Exit;
  end;
if (codRel='*') then
  begin
  messageDlg('Você não pode alterar este relatório.',mtWarning,[mbOK],0);
  Edit1.SetFocus;
  Exit;
  end;
nomeRel := upperCase(trim(Edit2.Text));
if (nomeRel='') then
  begin
  messageDlg('O nome do relatório é obrigatório',mtWarning,[mbOK],0);
  Edit2.SetFocus;
  Exit;
  end;
if trim(ComboBox1.Text)='' then
  begin
  messageDlg('Selecione o sistema gerador deste relatório.',mtWarning,[mbOK],0);
  ComboBox1.SetFocus;
  Exit;
  end;
if trim(ComboBox2.Text)='' then
  begin
  messageDlg('Selecione o grupo a quem este relatório pertence.',mtWarning,[mbOK],0);
  ComboBox2.SetFocus;
  Exit;
  end;
if trim(ComboBox3.Text)='' then
  begin
  messageDlg('Selecione o subgrupo a quem este relatório pertence.',mtWarning,[mbOK],0);
  ComboBox3.SetFocus;
  Exit;
  end;

codSis := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
codGrupo := strToInt(trim(Copy(ComboBox2.Text,1,Pos(' : ',ComboBox2.Text))));
codSubGrupo := strToInt(trim(Copy(ComboBox3.Text,1,Pos(' : ',ComboBox3.Text))));

//if (codSis = -1) and (codGrupo <> -1) then               // What, the PORRA, was that???????????????????????????
//  codGrupo := -1;

try
  idColuna1 := strToInt(Edit3.Text);
except
  begin
  messageDlg('O campo ID Coluna espera somente valores numéricos.',mtWarning,[mbOk],0);
  Edit3.SetFocus;
  Exit;
  end;
end;
try
  idLinha1 := strToInt(Edit4.Text);
except
  begin
  messageDlg('O campo ID Linha espera somente valores numéricos.',mtWarning,[mbOk],0);
  Edit4.SetFocus;
  Exit;
  end;
end;
idString1 := upperCase(trim(Edit5.Text));
if (idString1='') then
  begin
  messageDlg('É necessário informar a string de identificação do relatório.',mtWarning,[mbOk],0);
  Edit5.SetFocus;
  Exit;
  end;
if trim(Edit6.Text)='' then
  idColuna2 := Null
else
  try
    idColuna2 := strToInt(Edit6.Text);
  except
    begin
    messageDlg('O campo ID Coluna 2 espera somente valores numéricos.',mtWarning,[mbOk],0);
    Edit6.SetFocus;
    Exit;
    end;
  end;
if trim(Edit7.Text)='' then
  idLinha2 := Null
else
  try
    idLinha2 := strToInt(Edit7.Text);
  except
    begin
    messageDlg('O campo ID Linha 2 espera somente valores numéricos.',mtWarning,[mbOk],0);
    Edit7.SetFocus;
    Exit;
    end;
  end;
//if (trim(Edit8.Text)='') and (idColuna2=Null) and (idLinha2=Null) then
if (Edit8.Text='') and (idColuna2=Null) and (idLinha2=Null) then
  idString2 := Null
//else if (trim(Edit8.Text)<>'') and (idColuna2<>Null) and (idLinha2<>Null) then
else if (idColuna2<>Null) and (idLinha2<>Null) then
  idString2 := upperCase(Edit8.Text)
else
  begin
  messageDlg('É necessário informar a segunda string de identificação do relatório.',mtWarning,[mbOk],0);
  Edit8.SetFocus;
  Exit;
  end;
dirEntra := upperCase(trim(Edit9.Text));
if dirEntra='' then
  begin
  messageDlg('É necessário informar o diretório de entrada para o arquivo do relatório.',mtWarning,[mbOk],0);
  Edit9.SetFocus;
  Exit;
  end;
tipoQuebra := RadioGroup1.ItemIndex+1;
if tipoQuebra <= 0 then
  begin
  messageDlg('É necessário informar o tipo de quebra de página utilizado no relatório.',mtWarning,[mbOk],0);
  RadioGroup1.SetFocus;
  Exit;
  end;
colQuebraStr1 := Null;
strQuebraStr1 := Null;
colQuebraStr2 := Null;
strQuebraStr2 := Null;
quebraAfterStr := '';
if tipoQuebra = 4 then
  begin
  if CheckBox8.Checked then
    quebraAfterStr := 'T'
  else
    quebraAfterStr := 'F';
  try
    colQuebraStr1 := strToInt(Edit12.Text);
  except
    begin
    messageDlg('O campo coluna da quebra por string só permite valore do tipo numérico.',mtWarning,[mbOk],0);
    Edit12.SetFocus;
    Exit;
    end;
  end;
  strQuebraStr1 := upperCase(trim(Edit13.Text));
  if strQuebraStr1='' then
    begin
    messageDlg('É necessário informar a string de identificação da quebra de página do relatório.',mtWarning,[mbOk],0);
    Edit13.SetFocus;
    Exit;
    end;
  if trim(Edit15.Text)<>'' then
    begin
    try
      colQuebraStr2 := strToInt(Edit15.Text);
    except
      begin
      messageDlg('O campo coluna da quebra por string só permite valores do tipo numérico.',mtWarning,[mbOk],0);
      Edit15.SetFocus;
      Exit;
      end;
    end;
    end;
  if trim(Edit16.Text)<>'' then
    strQuebraStr2 := upperCase(trim(Edit16.Text));
  end;
nLinhasQuebraLin := Null;
if tipoQuebra=3 then
  begin
  try
    nLinhasQuebraLin := strToInt(Edit17.Text);
  except
    begin
    messageDlg('O campo numero de linhas para quebra só permite valores do tipo numérico.',mtWarning,[mbOk],0);
    Edit17.SetFocus;
    Exit;
    end;
  end;
  end;
if CheckBox2.Checked then
  filtroCar := 'T'
else
  filtroCar := 'F';
if CheckBox3.Checked then
  comprBrancos := 'T'
else
  comprBrancos := 'F';
if CheckBox4.Checked then
  juncaoAutom := 'T'
else
  juncaoAutom := 'F';
try
  qtdPagsAPular := strToInt(Edit10.Text);
except
  begin
  messageDlg('O campo número de páginas a pular permite apenas valores do tipo numérico.',mtWarning,[mbOk],0);
  Edit10.SetFocus;
  Exit;
  end;
end;
if CheckBox6.Checked then
  begin
  codGrupAuto := 'T';
  try
    colGrupAuto := strToInt(Edit18.Text);
  except
    begin
    messageDlg('O campo coluna para o código do grupo automático deve conter apenas números.',mtWarning,[mbOk],0);
    Edit18.SetFocus;
    Exit;
    end
  end;
  try
    linGrupAuto := strToInt(Edit19.Text);
  except
    begin
    messageDlg('O campo linha para o código do grupo automático deve conter apenas números.',mtWarning,[mbOk],0);
    Edit19.SetFocus;
    Exit;
    end
  end;
  try
    tamGrupAuto := strToInt(Edit20.Text);
  except
    begin
    messageDlg('O campo tamanho para o código do grupo automático deve conter apenas números.',mtWarning,[mbOk],0);
    Edit19.SetFocus;
    Exit;
    end
  end;
  if RadioGroup2.ItemIndex = -1 then
    begin
    messageDlg('É necessário informar o tipo de código para o Grupo Automático.',mtWarning,[mbOk],0);
    RadioGroup2.SetFocus;
    Exit;
    end
  else if RadioGroup2.ItemIndex = 0 then
    tipoGrupAuto := 'A'
  else
    tipoGrupAuto := 'N';
  end
else
  begin
  codGrupAuto := 'F';
  colGrupAuto := Null;
  linGrupAuto := Null;
  tamGrupAuto := Null;
  tipoGrupAuto := Null;
  end;
if CheckBox9.Checked then
  backupRel := 'T'
else
  backupRel := 'F';
if CheckBox5.Checked then
  subDirAuto := 'T'
else
  subDirAuto := 'F';
if CheckBox1.Checked then
  status := 'A'
else
  status := 'I';
if (Self.Tag=1) then
  begin
  dtCriacao := Now;
  hrCriacao := Now;
  end;
dtAlteracao := Now;
hrAlteracao := Now;
if CheckBox7.Checked then
  remove := 'T'
else
  remove := 'F';
if CheckBox10.Checked then
  sisAuto := 'T'
else
  sisAuto := 'F';
if ((codSis = -1) and (sisAuto='F')) or
   ((codSis <> -1) and (sisAuto='T')) then
  begin
  messageDlg('Para utilizar a funcionalidade de sistema automático, é necessário selecionar o sistema AUTOMÁTICO(-1) e a opção de sistema automático',mtWarning,[mbOk],0);
  comboBox1.SetFocus;
  exit;
  end;
if ((codGrupo = -1) and (codGrupAuto='F') and (subDirAuto='F') and (sisAuto='F')) or
   ((codGrupAuto='T') and (subDirAuto='T')) or
   ((codGrupo <> -1) and ((codGrupAuto='T') or (subDirAuto='T'))) then
  begin
  messageDlg('Para utilizar a funcionalidade de '+vpNomeDoGrupo+ ' automático, é necessário selecionar o '+vpNomeDoGrupo+ ' AUTOMÁTICO(-1) e a opção de '+vpNomeDoGrupo+' automático'+ ' ou Subdiretório Automático',mtWarning,[mbOk],0);
  comboBox2.SetFocus;
  exit;
  end;

//   LIBERADO em 21/02/2014
//if (codGrupAuto = 'T') and (sisAuto = 'T') then
//  begin
//  messageDlg('Não é permitido configurar um mesmo relatório para utilizar código de grupo e sistema automáticos. Resolva o conflito.',mtWarning,[mbOk],0);
//  CheckBox6.SetFocus;
//  exit;
//  end;

// **********************************
// Começa a gravação dos dados de DFN
// **********************************
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODREL FROM DFN WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.Open;
    if (Self.Tag = 1) and (Query01.Eof) then // Verifica se grava por insert ou update
      begin
      // insert (novo registro)
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO DFN (CODREL, NOMEREL, CODSIS, CODGRUPO, CODSUBGRUPO, ');
      Query02.SQL.Add('                 IDCOLUNA1, IDLINHA1, IDSTRING1, IDCOLUNA2, ');
      Query02.SQL.Add('                 IDLINHA2, IDSTRING2, DIRENTRA, TIPOQUEBRA, ');
      Query02.SQL.Add('                 COLQUEBRASTR1, STRQUEBRASTR1, COLQUEBRASTR2, ');
      Query02.SQL.Add('                 STRQUEBRASTR2, QUEBRAAFTERSTR, NLINHASQUEBRALIN, ');
      Query02.SQL.Add('                 FILTROCAR, COMPRBRANCOS, JUNCAOAUTOM, QTDPAGSAPULAR, ');
      Query02.SQL.Add('                 CODGRUPAUTO, COLGRUPAUTO, LINGRUPAUTO, TAMGRUPAUTO, ');
      Query02.SQL.Add('                 TIPOGRUPAUTO, BACKUPREL, SUBDIRAUTO, STATUS, DTCRIACAO, ');
      Query02.SQL.Add('                 HRCRIACAO, DTALTERACAO, HRALTERACAO, REMOVE, SISAUTO) ');
      Query02.SQL.Add('VALUES(:A01,:A02,:A03,:A04,:A05,:A06,:A07,:A08,:A09,:A10,:A11,:A12,:A13,:A14,:A15,:A16,:A17,:A18,:A19,:A20,:A21,:A22,:A23,:A24,:A25,:A26,:A27,:A28,:A29,:A30,:A31,:A32,:A33,:A34,:A35,:A36,:A37)');
      Query02.Parameters[00].Value := codRel;
      Query02.Parameters[01].Value := nomeRel;
      Query02.Parameters[02].Value := codSis;
      Query02.Parameters[03].Value := codGrupo;
      Query02.Parameters[04].Value := codSubGrupo;
      Query02.Parameters[05].Value := idColuna1;
      Query02.Parameters[06].Value := idLinha1;
      Query02.Parameters[07].Value := idString1;
      Query02.Parameters[08].Value := idColuna2;
      Query02.Parameters[09].Value := idLinha2;
      Query02.Parameters[10].Value := idString2;
      Query02.Parameters[11].Value := dirEntra;
      Query02.Parameters[12].Value := tipoQuebra;
      Query02.Parameters[13].Value := colQuebraStr1;
      Query02.Parameters[14].Value := strQuebraStr1;
      Query02.Parameters[15].Value := colQuebraStr2;
      Query02.Parameters[16].Value := strQuebraStr2;
      Query02.Parameters[17].Value := quebraAfterStr;
      Query02.Parameters[18].Value := nLinhasQuebraLin;
      Query02.Parameters[19].Value := filtroCar;
      Query02.Parameters[20].Value := comprBrancos;
      Query02.Parameters[21].Value := juncaoAutom;
      Query02.Parameters[22].Value := qtdPagsAPular;
      Query02.Parameters[23].Value := codGrupAuto;
      Query02.Parameters[24].Value := colGrupAuto;
      Query02.Parameters[25].Value := linGrupAuto;
      Query02.Parameters[26].Value := tamGrupAuto;
      Query02.Parameters[27].Value := tipoGrupAuto;
      Query02.Parameters[28].Value := backupRel;
      Query02.Parameters[29].Value := subDirAuto;
      Query02.Parameters[30].Value := status;
      Query02.Parameters[31].Value := dtCriacao;
      Query02.Parameters[32].Value := hrCriacao;
      Query02.Parameters[33].Value := dtAlteracao;
      Query02.Parameters[34].Value := hrAlteracao;
      Query02.Parameters[35].Value := remove;
      Query02.Parameters[36].Value := sisAuto;
      Query02.ExecSQL;
      end
    else
      if (tTabela.Fields[0].Value=codRel) then
        begin
        // update sem mudança de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add(' UPDATE DFN ');
        Query02.SQL.Add(' SET NOMEREL=:A01, CODSIS=:A02, CODGRUPO=:A03, CODSUBGRUPO=:A04, IDCOLUNA1=:A05, IDLINHA1=:A06, ');
        Query02.SQL.Add('     IDSTRING1=:A07, IDCOLUNA2=:A08, IDLINHA2=:A09, IDSTRING2=:A10, DIRENTRA=:A11, TIPOQUEBRA=:A12, ');
        Query02.SQL.Add('     COLQUEBRASTR1=:A13, STRQUEBRASTR1=:A14, COLQUEBRASTR2=:A15, STRQUEBRASTR2=:A16, ');
        Query02.SQL.Add('     QUEBRAAFTERSTR=:A17, NLINHASQUEBRALIN=:A18, FILTROCAR=:A19, COMPRBRANCOS=:A20, ');
        Query02.SQL.Add('     JUNCAOAUTOM=:A21, QTDPAGSAPULAR=:A22, CODGRUPAUTO=:A23, COLGRUPAUTO=:A24, LINGRUPAUTO=:A25, ');
        Query02.SQL.Add('     TAMGRUPAUTO=:A26, TIPOGRUPAUTO=:A27, BACKUPREL=:A28, SUBDIRAUTO=:A29, STATUS=:A30, ');
        Query02.SQL.Add('     DTALTERACAO=:A33, HRALTERACAO=:A34, [REMOVE]=:A35, SISAUTO=:A36 ');
        Query02.SQL.Add(' WHERE CODREL=:A38 ');
        Query02.Parameters[00].Value := nomeRel;
        Query02.Parameters[01].Value := codSis;
        Query02.Parameters[02].Value := codGrupo;
        Query02.Parameters[03].Value := codSubGrupo;
        Query02.Parameters[04].Value := idColuna1;
        Query02.Parameters[05].Value := idLinha1;
        Query02.Parameters[06].Value := idString1;
        Query02.Parameters[07].Value := idColuna2;
        Query02.Parameters[08].Value := idLinha2;
        Query02.Parameters[09].Value := idString2;
        Query02.Parameters[10].Value := dirEntra;
        Query02.Parameters[11].Value := tipoQuebra;
        Query02.Parameters[12].Value := colQuebraStr1;
        Query02.Parameters[13].Value := strQuebraStr1;
        Query02.Parameters[14].Value := colQuebraStr2;
        Query02.Parameters[15].Value := strQuebraStr2;
        Query02.Parameters[16].Value := quebraAfterStr;
        Query02.Parameters[17].Value := nLinhasQuebraLin;
        Query02.Parameters[18].Value := filtroCar;
        Query02.Parameters[19].Value := comprBrancos;
        Query02.Parameters[20].Value := juncaoAutom;
        Query02.Parameters[21].Value := qtdPagsAPular;
        Query02.Parameters[22].Value := codGrupAuto;
        Query02.Parameters[23].Value := colGrupAuto;
        Query02.Parameters[24].Value := linGrupAuto;
        Query02.Parameters[25].Value := tamGrupAuto;
        Query02.Parameters[26].Value := tipoGrupAuto;
        Query02.Parameters[27].Value := backupRel;
        Query02.Parameters[28].Value := subDirAuto;
        Query02.Parameters[29].Value := status;
        Query02.Parameters[30].Value := dtAlteracao;
        Query02.Parameters[31].Value := hrAlteracao;
        Query02.Parameters[32].Value := remove;
        Query02.Parameters[33].Value := sisAuto;
        Query02.Parameters[34].Value := codRel;
        Query02.ExecSQL;
        end
      else
        begin
        Query02.SQL.Clear;
        Query02.SQL.Add('SELECT DTCRIACAO, HRCRIACAO FROM DFN WHERE CODREL=:A');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.Open;
        dtCriacao := Query02.Fields[0].Value;
        hrCriacao := Query02.Fields[1].Value;
        Query02.Close;
        // update com mudança de chaves
        Query02.SQL.Clear;
        Query02.SQL.Add(' INSERT INTO DFN (CODREL, NOMEREL, CODSIS, CODGRUPO, CODSUBGRUPO, ');
        Query02.SQL.Add(' IDCOLUNA1, IDLINHA1, IDSTRING1, IDCOLUNA2, ');
        Query02.SQL.Add(' IDLINHA2, IDSTRING2, DIRENTRA, TIPOQUEBRA, ');
        Query02.SQL.Add(' COLQUEBRASTR1, STRQUEBRASTR1, COLQUEBRASTR2, ');
        Query02.SQL.Add(' STRQUEBRASTR2, QUEBRAAFTERSTR, NLINHASQUEBRALIN, ');
        Query02.SQL.Add(' FILTROCAR, COMPRBRANCOS, JUNCAOAUTOM, QTDPAGSAPULAR, ');
        Query02.SQL.Add(' CODGRUPAUTO, COLGRUPAUTO, LINGRUPAUTO, TAMGRUPAUTO, ');
        Query02.SQL.Add(' TIPOGRUPAUTO, BACKUPREL, SUBDIRAUTO, STATUS, ');
        Query02.SQL.Add(' DTCRIACAO, HRCRIACAO, DTALTERACAO, HRALTERACAO, [REMOVE], SISAUTO) ');
        Query02.SQL.Add(' VALUES (:A01, :A02, :A03, :A04, :A05, ');
        Query02.SQL.Add(' :A06, :A07, :A08, :A09, ');
        Query02.SQL.Add(' :A10, :A11, :A12, :A13, ');
        Query02.SQL.Add(' :A14, :A15, :A16, ');
        Query02.SQL.Add(' :A17, :A18, :A19, ');
        Query02.SQL.Add(' :A20, :A21, :A22, :A23, ');
        Query02.SQL.Add(' :A24, :A25, :A26, :A27, ');
        Query02.SQL.Add(' :A28, :A29, :A30, :A31, ');
        Query02.SQL.Add(' :A32, :A33, :A34, :A35, :A36, :A37) ');
        Query02.Parameters[00].Value := codRel;
        Query02.Parameters[01].Value := nomeRel;
        Query02.Parameters[02].Value := codSis;
        Query02.Parameters[03].Value := codGrupo;
        Query02.Parameters[04].Value := codSubGrupo;
        Query02.Parameters[05].Value := idColuna1;
        Query02.Parameters[06].Value := idLinha1;
        Query02.Parameters[07].Value := idString1;
        Query02.Parameters[08].Value := idColuna2;
        Query02.Parameters[09].Value := idLinha2;
        Query02.Parameters[10].Value := idString2;
        Query02.Parameters[11].Value := dirEntra;
        Query02.Parameters[12].Value := tipoQuebra;
        Query02.Parameters[13].Value := colQuebraStr1;
        Query02.Parameters[14].Value := strQuebraStr1;
        Query02.Parameters[15].Value := colQuebraStr2;
        Query02.Parameters[16].Value := strQuebraStr2;
        Query02.Parameters[17].Value := quebraAfterStr;
        Query02.Parameters[18].Value := nLinhasQuebraLin;
        Query02.Parameters[19].Value := filtroCar;
        Query02.Parameters[20].Value := comprBrancos;
        Query02.Parameters[21].Value := juncaoAutom;
        Query02.Parameters[22].Value := qtdPagsAPular;
        Query02.Parameters[23].Value := codGrupAuto;
        Query02.Parameters[24].Value := colGrupAuto;
        Query02.Parameters[25].Value := linGrupAuto;
        Query02.Parameters[26].Value := tamGrupAuto;
        Query02.Parameters[27].Value := tipoGrupAuto;
        Query02.Parameters[28].Value := backupRel;
        Query02.Parameters[29].Value := subDirAuto;
        Query02.Parameters[30].Value := status;
        Query02.Parameters[31].Value := dtCriacao;
        Query02.Parameters[32].Value := hrCriacao;
        Query02.Parameters[33].Value := dtAlteracao;
        Query02.Parameters[34].Value := hrAlteracao;
        Query02.Parameters[35].Value := remove;
        Query02.Parameters[36].Value := sisAuto;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUREL SET CODSIS=:A01, CODGRUPO=:A02, CODSUBGRUPO=:A03, CODREL=:A04 WHERE CODSIS=:A05 AND CODGRUPO=:A06 AND CODSUBGRUPO=:A07 AND CODREL=:A08 ');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codSubGrupo;
        Query02.Parameters[3].Value := codRel;
        Query02.Parameters[4].Value := tTabela.Fields[2].Value;
        Query02.Parameters[5].Value := tTabela.Fields[3].Value;
        Query02.Parameters[6].Value := tTabela.Fields[4].Value;
        Query02.Parameters[7].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE GRUPOREL SET CODSIS=:A01, CODGRUPO=:A02, CODSUBGRUPO=:A03, CODREL=:A04 WHERE CODSIS=:A05 AND CODGRUPO=:A06 AND CODSUBGRUPO=:A07 AND CODREL=:A08 ');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codSubGrupo;
        Query02.Parameters[3].Value := codRel;
        Query02.Parameters[4].Value := tTabela.Fields[2].Value;
        Query02.Parameters[5].Value := tTabela.Fields[3].Value;
        Query02.Parameters[6].Value := tTabela.Fields[4].Value;
        Query02.Parameters[7].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE EXTRATOR SET CODSIS=:A01, CODGRUPO=:A02, CODREL=:A03 WHERE CODSIS=:A04 AND CODGRUPO=:A05 AND CODREL=:A06 ');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codRel;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.Parameters[4].Value := tTabela.Fields[3].Value;
        Query02.Parameters[5].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE RELATOCD SET CODSIS=:A01, CODGRUPO=:A02, CODREL=:A03 WHERE CODSIS=:A04 AND CODGRUPO=:A05 AND CODREL=:A06 ');
        Query02.Parameters[0].Value := codSis;
        Query02.Parameters[1].Value := codGrupo;
        Query02.Parameters[2].Value := codRel;
        Query02.Parameters[3].Value := tTabela.Fields[2].Value;
        Query02.Parameters[4].Value := tTabela.Fields[3].Value;
        Query02.Parameters[5].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE DESTINOSDFN SET CODREL=:A01 WHERE CODREL=:A02 ');
        Query02.Parameters[0].Value := codRel;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE INDICESDFN SET CODREL=:A01 WHERE CODREL=:A02 ');
        Query02.Parameters[0].Value := codRel;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE COMENTARIOSBIN SET CODREL=:A01 WHERE CODREL=:A02 ');
        Query02.Parameters[0].Value := codRel;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE COMENTARIOSTXT SET CODREL=:A01 WHERE CODREL=:A02 ');
        Query02.Parameters[0].Value := codRel;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE USUARIOMASCARA SET CODREL=:A01 WHERE CODREL=:A02 ');
        Query02.Parameters[0].Value := codRel;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE MASCARACAMPO SET CODREL=:A01 WHERE CODREL=:A02 ');
        Query02.Parameters[0].Value := codRel;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('UPDATE SISAUXDFN SET CODREL=:A01 WHERE CODREL=:A02 ');
        Query02.Parameters[0].Value := codRel;
        Query02.Parameters[1].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;

        Query02.SQL.Clear;
        Query02.SQL.Add('DELETE FROM DFN WHERE CODREL=:A01');
        Query02.Parameters[0].Value := tTabela.Fields[0].Value;
        Query02.ExecSQL;
        end;
    Query01.Close;
    if ehSalvarComo then
      begin
      ehSalvarComo := false;
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO DESTINOSDFN (CODREL,DESTINO,TIPODESTINO,SEGURANCA,QTDPERIODOS,TIPOPERIODO,USUARIO,SENHA,DIREXPL)');
      Query02.SQL.Add('SELECT '''+Edit1.Text+''' as CODREL,DESTINO,TIPODESTINO,SEGURANCA,QTDPERIODOS,TIPOPERIODO,USUARIO,SENHA,DIREXPL');
      Query02.SQL.Add('FROM DESTINOSDFN WHERE CODREL=:A');
      Query02.Parameters[0].Value := tTabela.Fields[0].Value;
      Query02.ExecSQL;
      Query02.SQL.Clear;
      Query02.SQL.Add('INSERT INTO INDICESDFN (CODREL, NOMECAMPO, LINHAI, LINHAF, COLUNA,');
      Query02.SQL.Add('       TAMANHO, BRANCO, TIPO, MASCARA, CHARINC, CHAREXC,');
      Query02.SQL.Add('       STRINC, STREXC, FUSAO)');
      Query02.SQL.Add('SELECT '''+Edit1.Text+''' as CODREL, NOMECAMPO, LINHAI, LINHAF, COLUNA,');
      Query02.SQL.Add('       TAMANHO, BRANCO, TIPO, MASCARA, CHARINC, CHAREXC,');
      Query02.SQL.Add('       STRINC, STREXC, FUSAO');
      Query02.SQL.Add('FROM INDICESDFN');
      Query02.SQL.Add('WHERE CODREL = :A');
      Query02.Parameters[0].Value := tTabela.Fields[0].Value;
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
    begin
    dbMulticold.CommitTrans;
    Self.Close;
    end;
  end;

//fGrade.CarregaGrid;         // Romero 23/07/2013
end;

procedure TfDfn.BitBtn4Click(Sender: TObject);
var
  novaDfn : string;
  dfnExiste : boolean;
begin
dfnExiste := false;
novaDfn := edit1.Text;
if not inputQuery('Salvar DFN como','Entre com o novo código para esta DFN',novaDfn) then
  begin
  messageDlg('Não é possível gravar uma nova DFN a menos que seja fornecido um novo código válido.',mtWarning,[mbOk],0);
  exit;
  end;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT * FROM DFN WHERE CODREL=:A');
  Query01.Parameters[0].Value := novaDfn;
  Query01.Open;
  if (not Query01.Eof) or (Query01.Fields[0].AsString = novaDfn) then
    dfnExiste := true;
  Query01.Close;
  if dfnExiste then
    begin
    messageDlg('O código informado já existe! Informe um código novo para a DFN',mtError,[mbOk],0);
    exit;
    end;
  end;
ehSalvarComo := true;
Edit1.Text := novaDfn;
Self.Tag := 1;
BitBtn1.Click;
end;

end.
