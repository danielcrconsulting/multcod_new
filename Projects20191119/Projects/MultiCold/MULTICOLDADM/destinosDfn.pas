unit destinosDfn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, DB, System.UITypes, Subrug;

type
  TfDestinosDfn = class(TForm)
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
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    RadioGroup2: TRadioGroup;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Edit2: TEdit;
    Button3: TButton;
    FileOpenDialog1: TFileOpenDialog;
    procedure Button3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
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

  fDestinosDfn: TfDestinosDfn;
  tTabela : TDataSet;
  codRel : String;

implementation

uses dataModule, formGrade;

{$R *.dfm}

function TfDestinosDfn.getTabela:TDataSet;
begin
result := tTabela;
end;

procedure TfDestinosDfn.setTabela(valor:TDataSet);
begin
tTabela := valor;
end;

procedure TfDestinosDfn.Button3Click(Sender: TObject);
Var
  X : String;
begin
           // Works but is in english!!!

//if SelectDirectory(X, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
//  Edit1.Text := X;

X := ExtractFilePath(ParamStr(0));

if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o local de destino';
    if FileOpenDialog1.Execute then
      Edit1.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit1.Text := UpperCase(X);
  end;

end;

procedure TfDestinosDfn.RadioGroup1Click(Sender: TObject);
begin
if radioGroup1.ItemIndex = 0 then
  button3.Enabled := true
else
  button3.Enabled := false;

if radioGroup1.ItemIndex = 1 then
  begin
  Edit3.Enabled := true;
  Edit4.Enabled := true;
  end
else
  begin
  Edit3.Enabled := false;
  Edit4.Enabled := false;
  end;

end;

procedure TfDestinosDfn.SpeedButton2Click(Sender: TObject);
begin
fDestinosDfn.Close;
end;

procedure TfDestinosDfn.FormShow(Sender: TObject);
var
  s:String;
  i:Integer;
begin
ComboBox1.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODREL, NOMEREL FROM DFN ORDER BY CODREL');
  Query01.Open;
  while not Query01.Eof do
    begin
    s := Query01.Fields[0].AsString + ' : ' + Query01.Fields[1].AsString;
    ComboBox1.Items.Add(s);
    if (fDestinosDfn.Tag = 0) and (trim(Query01.Fields[0].AsString) = trim(tTabela.Fields[0].AsString)) then
      Begin
      ComboBox1.Text := s;
      tDestinosDFN.Filter := 'CODREL = ' + '''' + Query01.Fields[0].AsString + '''';         // Romero 18/07/2013
      tDestinosDFN.Filtered := True;
      End;
    Query01.Next;
    end;
  end;
if fDestinosDfn.Tag = 0 then
  begin
  With repositorioDeDados do
    begin
    tDestinosDFN.Open;                                             // Romero 18/07/2013
    if lowerCase(tDestinosDFN.Fields[2].AsString) = 'ftp' then
      RadioGroup1.ItemIndex := 1
    else if lowerCase(tDestinosDFN.Fields[2].AsString) = 'email' then
      RadioGroup1.ItemIndex := 2
    else
      RadioGroup1.ItemIndex := 0;

    if lowerCase(tDestinosDFN.Fields[5].AsString) = 'a' then
      RadioGroup2.ItemIndex := 0
    else if lowerCase(tDestinosDFN.Fields[5].AsString) = 'm' then
      RadioGroup2.ItemIndex := 1
    else if lowerCase(tDestinosDFN.Fields[5].AsString) = 'd' then
      RadioGroup2.ItemIndex := 2
    else
      RadioGroup2.ItemIndex := -1;

    if lowerCase(tDestinosDFN.Fields[3].AsString) = 's' then
      CheckBox1.Checked := true
    else
      CheckBox1.Checked := false;

    if lowerCase(tDestinosDFN.Fields[8].AsString) = 's' then
      CheckBox2.Checked := true
    else
      CheckBox2.Checked := false;

    Edit1.Text := tDestinosDFN.Fields[1].AsString;
    Edit2.Text := tDestinosDFN.Fields[4].AsString;
    Edit3.Text := tDestinosDFN.Fields[6].AsString;
    Edit4.Text := tDestinosDFN.Fields[7].AsString;
    tDestinosDFN.Close;
    end;
  end
else // Novo registro
  begin
  ComboBox1.Text := '';
  RadioGroup1.ItemIndex := 0;
  RadioGroup2.ItemIndex := 1;
  CheckBox1.Checked := false;
  CheckBox2.Checked := false;
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  end;
codRel := upperCase(ComboBox1.Text);
i := pos(' : ',codRel);
codRel := trim(copy(codRel,1,i));
end;

procedure TfDestinosDfn.BitBtn3Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
//    qDestinosDfnDEL.Parameters[0].Value := ComboBox1.Text;      Romero 18/07/2013

    qDestinosDfnDEL.SQL.Clear;
    qDestinosDfnDEL.SQL.Add('DELETE FROM DESTINOSDFN WHERE CODREL = '+
                             ''''+ trim(upperCase(Copy(ComboBox1.Text,1,pos(' : ',ComboBox1.Text))))+'''');
    qDestinosDfnDEL.SQL.Add('AND DESTINO = '+
                             ''''+ trim(upperCase(Edit1.Text))+'''');

    qDestinosDfnDEL.ExecSQL;
    except
      on e:exception do
        begin
        screen.Cursor := crDefault;
        dbMulticold.RollbackTrans;
        messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
        end;
      end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
fDestinosDfn.Close;
//fGrade.CarregaGrid;         // Romero 18/07/2013
end;

procedure TfDestinosDfn.BitBtn2Click(Sender: TObject);
begin
FormShow(Sender);
end;

procedure TfDestinosDfn.BitBtn1Click(Sender: TObject);
var
  codRel2,
  tipoPeriodo,
  tipoDestino,
  seguranca,
  destino,
  usuario,
  senha,
  dirExpl,
  qtdPeriodos: variant;
  i : integer;
begin

codRel2 := upperCase(ComboBox1.Text);
i := pos(' : ',codRel2);
codRel2 := trim(copy(codRel2,1,i));

if trim(codRel2) = '' then
  begin
  messageDlg('O código do relatório deve ser informado!',mtInformation,[mbOk],0);
  ComboBox1.SetFocus;
  exit;
  end;

tipoDestino := 'DIR';
if RadioGroup1.ItemIndex = 1 then
  tipoDestino := 'FTP'
else if RadioGroup1.ItemIndex = 2 then
  tipoDestino := 'EMAIL';

destino := upperCase(Edit1.Text);
if trim(destino) = '' then
  begin
  messageDlg('O destino do relatório deve ser informado!',mtInformation,[mbOk],0);
  Edit1.SetFocus;
  exit;
  end;

usuario := upperCase(Edit3.Text);
senha := Edit4.Text;
if (tipoDestino='FTP') and ((trim(usuario)='') or (trim(senha)='')) then
  begin
  messageDlg('Para destino em servidor ftp o nome de usuário e senha para acesso devem ser informados.',mtInformation,[mbOk],0);
  Edit3.SetFocus;
  exit;
  end;

tipoPeriodo := 'A';
if RadioGroup2.ItemIndex = 1 then
  tipoPeriodo := 'M'
else if RadioGroup2.ItemIndex = 2 then
  tipoPeriodo := 'D';

seguranca := 'N';
if checkbox1.Checked then
  seguranca := 'S';

dirExpl := 'N';
if checkbox2.Checked then
  dirExpl := 'S';

try
  qtdPeriodos := strToInt(Edit2.Text);
except
  on e:exception do
    qtdPeriodos := null;
  end;

with repositorioDeDados do
  begin
  try
    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('SELECT CODREL FROM DESTINOSDFN WHERE CODREL='''+codRel+'''');
    Query01.Open;
    if Query01.Eof then
      begin
      qDestinosDfnINS.Parameters[0].Value := codRel2;
      qDestinosDfnINS.Parameters[1].Value := destino;
      qDestinosDfnINS.Parameters[2].Value := tipoDestino;
      qDestinosDfnINS.Parameters[3].Value := seguranca;
      qDestinosDfnINS.Parameters[4].Value := qtdPeriodos;
      qDestinosDfnINS.Parameters[5].Value := tipoPeriodo;
      qDestinosDfnINS.Parameters[6].Value := usuario;
      qDestinosDfnINS.Parameters[7].Value := senha;
      qDestinosDfnINS.Parameters[8].Value := dirExpl;
      qDestinosDfnINS.ExecSQL;
      end
    else
      begin
      qDestinosDfnUPD.Parameters[0].Value := codRel2;
      qDestinosDfnUPD.Parameters[1].Value := destino;
      qDestinosDfnUPD.Parameters[2].Value := tipoDestino;
      qDestinosDfnUPD.Parameters[3].Value := seguranca;
      qDestinosDfnUPD.Parameters[4].Value := qtdPeriodos;
      qDestinosDfnUPD.Parameters[5].Value := tipoPeriodo;
      qDestinosDfnUPD.Parameters[6].Value := usuario;
      qDestinosDfnUPD.Parameters[7].Value := senha;
      qDestinosDfnUPD.Parameters[8].Value := dirExpl;
      qDestinosDfnUPD.Parameters[9].Value := codRel;
      qDestinosDfnUPD.ExecSQL;
      end;
    Query01.Close;
  except
    on e:exception do
      begin
      screen.Cursor := crDefault;
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      end;
    end;
  if dbMulticold.InTransaction then
    dbMulticold.CommitTrans;
  end;
fDestinosDfn.Close;
//fGrade.CarregaGrid;
end;

end.
