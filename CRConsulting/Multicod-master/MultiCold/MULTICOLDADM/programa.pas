unit programa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Grids, System.UITypes, Subrug;

type
  TfConfiguracao = class(TForm)
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    Edit4: TEdit;
    SpeedButton2: TSpeedButton;
    Label5: TLabel;
    Edit5: TEdit;
    SpeedButton3: TSpeedButton;
    StringGrid1: TStringGrid;
    TabSheet4: TTabSheet;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    Edit6: TEdit;
    SpeedButton4: TSpeedButton;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label7: TLabel;
    Edit7: TEdit;
    CheckBox4: TCheckBox;
    Label8: TLabel;
    Edit8: TEdit;
    CheckBox5: TCheckBox;
    Label9: TLabel;
    Edit9: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    TabSheet5: TTabSheet;
    Label11: TLabel;
    Edit11: TEdit;
    Label12: TLabel;
    Edit12: TEdit;
    TabSheet6: TTabSheet;
    Label13: TLabel;
    Edit13: TEdit;
    SpeedButton5: TSpeedButton;
    Label14: TLabel;
    Edit14: TEdit;
    SpeedButton6: TSpeedButton;
    TabSheet7: TTabSheet;
    Label15: TLabel;
    Edit15: TEdit;
    SpeedButton7: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton8: TSpeedButton;
    Label16: TLabel;
    Edit16: TEdit;
    CheckBox6: TCheckBox;
    Label17: TLabel;
    Edit17: TEdit;
    FileOpenDialog1: TFileOpenDialog;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure CheckBox6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fConfiguracao: TfConfiguracao;
  auxCodCharEnt,
  auxCodCharSai : String;

implementation

uses dataModule, DB, principal;

{$R *.dfm}

procedure TfConfiguracao.SpeedButton1Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Diretório de trabalho (até ..\ORIGEM)';
    if FileOpenDialog1.Execute then
      Edit3.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit3.Text := UpperCase(X);
  end;
end;

procedure TfConfiguracao.SpeedButton2Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o diretório de entrada';
    if FileOpenDialog1.Execute then
      Edit4.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit4.Text := UpperCase(X);
  end;
end;

procedure TfConfiguracao.SpeedButton3Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o diretório de saída';
    if FileOpenDialog1.Execute then
      Edit5.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit5.Text := UpperCase(X);
  end;
end;

procedure TfConfiguracao.FormCreate(Sender: TObject);
var i : integer;
begin
PageControl1.ActivePage := TabSheet1;
stringGrid1.ColWidths[0] := 10;
stringGrid1.ColWidths[1] := 100;
stringGrid1.ColWidths[2] := 100;
stringGrid1.ColWidths[3] := 100;
stringGrid1.ColWidths[4] := 100;
stringGrid1.Cells[1,0] := 'Cod. carac. entrada';
stringGrid1.Cells[2,0] := 'Cod. carac. saída';
stringGrid1.Cells[3,0] := 'Carac. entrada';
stringGrid1.Cells[4,0] := 'Carac. saída';
with repositorioDeDados do
  begin
  Query01.sql.Clear;
  Query01.SQL.Add('SELECT * FROM MAPACARACTERE WHERE CODUSUARIO=''ADM'' ORDER BY CODCARACTEREENTRA');
  Query01.Open;
  for i := 0 to 255 do
    begin
    if (not Query01.Eof) and (Query01.fields[1].value = i) then
      begin
      stringGrid1.Cells[1,i+1] := trim(Query01.Fields[1].Value);
      stringGrid1.Cells[2,i+1] := trim(Query01.Fields[2].Value);
      Query01.Next;
      end
    else
      stringGrid1.Cells[1,i+1] := intToStr(i);

    if trim(stringGrid1.Cells[2,i+1]) = '' then
      begin
      if ((i < 32) or (i > 126)) and
         (i <> 10) and
         (i <> 13) and
         (i <> 164) then
        stringGrid1.Cells[2,i+1] := '32'
      else
        stringGrid1.Cells[2,i+1] := intToStr(i);
      end;

    stringGrid1.Cells[3,i+1] := chr(strToInt(stringGrid1.Cells[1,i+1]));
    stringGrid1.Cells[4,i+1] := chr(strToInt(stringGrid1.Cells[2,i+1]));
    
    end;
  Query01.Close;

  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT A.NOMECAMPO, B.VALORCAMPO FROM NOMECAMPO A JOIN CONFIGURACAO B ON A.CAMPOID = B.CAMPOID WHERE CODUSUARIO=''ADM''');
  Query01.Open;
  While not Query01.eof do
    begin

    if Query01.Fields[0].Value = 'PROGRAMAINDEXADOR' then
      edit1.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'PROGRAMAFILTRAGEM' then
      edit2.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'DIRETORIOTRABALHO' then
      edit3.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'DIRENTRA' then
      edit4.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'DIRSAI' then
      edit5.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'BACKUPAUTOMATICO' then
      begin
      if Query01.Fields[1].Value = 'S' then
        begin
        CheckBox1.Checked := true;
        CheckBox1Click(Sender)
        end;
      end
    else if Query01.Fields[0].Value = 'DIRETORIOBACKUP' then
      edit6.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'REMOVERS1' then
      begin
      if Query01.Fields[1].Value = 'S' then
        CheckBox2.Checked := true;
      end
    else if Query01.Fields[0].Value = 'EXECUCAOAUTOMATICA' then
      begin
      if Query01.Fields[1].Value = 'S' then
        begin
        CheckBox3.Checked := true;
        CheckBox3Click(Sender)
        end;
      end
    else if Query01.Fields[0].Value = 'INTERVALO' then
      edit7.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'EXTENSAOAUTOMATICA' then
      begin
      if Query01.Fields[1].Value = 'S' then
        begin
        CheckBox4.Checked := true;
        CheckBox4Click(Sender)
        end;
      end
    else if Query01.Fields[0].Value = 'FORMATOEXTENSAO' then
      edit8.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'SEPARACAOAUTOMATICA' then
      begin
      if Query01.Fields[1].Value = 'S' then
        begin
        CheckBox5.Checked := true;
        CheckBox5Click(Sender)
        end;
      end
    else if Query01.Fields[0].Value = 'DECIMALCARACTEREQUEBRA' then
      edit9.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'COLUNACARACTEREQUEBRA' then
      edit10.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'LIMPEZAAUTOMATICA' then
      begin
      if Query01.Fields[1].Value = 'S' then
        CheckBox6.Checked := true;
        CheckBox6Click(sender);
      end
    else if Query01.Fields[0].Value = 'GRUPO' then
      begin
      edit11.Text := Query01.Fields[1].Value;
      if trim(edit11.Text)='' then
        edit11.Text := 'NIVEL 2';
      vpNomeDoGrupo := edit11.Text;
      end
    else if Query01.Fields[0].Value = 'SUBGRUPO' then
      begin
      edit12.Text := Query01.Fields[1].Value;
      if trim(edit12.Text) = '' then
        edit12.Text := 'NIVEL 3';
      vpNomeDoSubGrupo := edit12.Text;
      end
    else if Query01.Fields[0].Value = 'SISTEMA' then
      begin
      edit17.Text := Query01.Fields[1].Value;
      if trim(edit17.Text) = '' then
        edit17.Text := 'NIVEL 1';
      vpNomeDoSistema := edit17.Text;
      end
    else if Query01.Fields[0].Value = 'DIRETORIOENTRADA' then
      edit13.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'DIRETORIOSAIDA' then
      edit14.Text := Query01.Fields[1].Value
    else if Query01.Fields[0].Value = 'DIRETORIOGRAVACAO' then
      edit15.Text := Query01.Fields[1].Value
    else if QUery01.Fields[0].Value = 'DIASPERMANENCIA' then
      edit16.Text := Query01.Fields[1].Value; 
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfConfiguracao.SpeedButton4Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o diretório do backup';
    if FileOpenDialog1.Execute then
      Edit6.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit6.Text := UpperCase(X);
  end;
end;

procedure TfConfiguracao.CheckBox1Click(Sender: TObject);
begin
label6.Enabled := checkBox1.Checked;
edit6.Enabled := checkBox1.Checked;
speedButton4.Enabled := checkBox1.Checked;
checkBox2.Enabled := checkBox1.Checked;
end;

procedure TfConfiguracao.CheckBox3Click(Sender: TObject);
begin
label7.Enabled := checkBox3.Checked;
edit7.Enabled := checkBox3.Checked;
end;

procedure TfConfiguracao.CheckBox4Click(Sender: TObject);
begin
label8.Enabled := checkBox4.Checked;
edit8.Enabled := checkBox4.Checked;
end;

procedure TfConfiguracao.CheckBox5Click(Sender: TObject);
begin
label9.Enabled := checkBox5.Checked;
edit9.Enabled := checkBox5.Checked;
label10.Enabled := checkBox5.Checked;
edit10.Enabled := checkBox5.Checked;
checkBox6.Enabled := checkBox5.Checked;
end;

procedure TfConfiguracao.SpeedButton5Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o diretório de entrada';
    if FileOpenDialog1.Execute then
      Edit13.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit13.Text := UpperCase(X);
  end;
end;

procedure TfConfiguracao.SpeedButton6Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o diretório de saída';
    if FileOpenDialog1.Execute then
      Edit14.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit14.Text := UpperCase(X);
  end;
end;

procedure TfConfiguracao.SpeedButton7Click(Sender: TObject);
Var
  X : String;
begin
X := ExtractFilePath(ParamStr(0));
if SysUtils.Win32MajorVersion > 5 then
  begin
    FileOpenDialog1.DefaultFolder := X;
    FileOpenDialog1.Title := 'Selecione o diretório de gravação';
    if FileOpenDialog1.Execute then
      Edit15.Text := UpperCase(FileOpenDialog1.FileName);
  end
else
  begin
    X := BrowseForFolder(X, Handle);
    if X.Length <> 0 then
      Edit15.Text := UpperCase(X);
  end;
end;

procedure TfConfiguracao.BitBtn1Click(Sender: TObject);
var
  aux : string;
  i, J : integer;

  procedure gravaConfig(NomeCampo, ValorCampo:String);
  var
    CampoID : integer;
  begin
  with repositorioDeDados do
    begin
    Query01.Parameters[0].Value := NomeCampo; // Recupera ID do campo para gravação
    Query01.Open;
    if Query01.RecordCount=0 then
      begin
      // Se o campo não existe, grava e pega um novo ID
      Query01.Close;
      Query02.Parameters[0].Value := NomeCampo;
      Query02.ExecSQL;
      Query01.Open;
      end;
    CampoID := Query01.Fields[0].Value;
    Query01.Close;
    // Apaga configuração pré existente
    Query03.Parameters[0].Value := CampoID;
    Query03.ExecSQL;
    // Grava nova configuração
    Query04.Parameters[0].Value := 'ADM';
    Query04.Parameters[1].Value := CampoID;
    Query04.Parameters[2].Value := ValorCampo;
    Query04.ExecSQL;
    end; // with repositorioDeDados do
  end; // function pegaCampoID(NomeCampo:String):Integer;

begin
BitBtn1.Enabled := false;
with repositorioDeDados do
  begin
  Query01.SQL.clear;
  Query01.SQL.Add('SELECT CAMPOID FROM NOMECAMPO WHERE NOMECAMPO = ?');
  Query01.Prepared := true;

  Query02.SQL.Clear;
  Query02.SQL.Add('INSERT INTO NOMECAMPO (NOMECAMPO) VALUES (?)');
  Query02.Prepared := true;

  Query03.SQL.Clear;
  Query03.SQL.Add('DELETE FROM CONFIGURACAO WHERE (CAMPOID = ?)');
  Query03.Prepared := true;

  Query04.sql.clear;
  Query04.SQL.Add('INSERT INTO CONFIGURACAO (CODUSUARIO, CAMPOID, VALORCAMPO) VALUES (?,?,?)');
  Query04.Prepared := true;

  try
    dbMulticold.BeginTrans;
    gravaConfig('PROGRAMAINDEXADOR',upperCase(edit1.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando PROGRAMA INDEXADOR: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('PROGRAMAFILTRAGEM',upperCase(edit2.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando PROGRAMA FILTRADOR: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIRETORIOTRABALHO',upperCase(edit3.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DIRETÓRIO DE TRABALHO: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIRENTRA',upperCase(edit4.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DIRETÓRIO DE ENTRADA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIRSAI',upperCase(edit5.Text));
     dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DIRETÓRIO DE SAIDA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

    if checkBox1.Checked then
      aux := 'S'
    else
      aux := 'N';

  try
    dbMulticold.BeginTrans;
    gravaConfig('BACKUPAUTOMATICO',aux);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando UTILIZAR BACKUP AUTOMÁTICO: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIRETORIOBACKUP',upperCase(edit6.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DIRETÓRIO DE BACKUP: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

    if checkBox2.Checked then
      aux := 'S'
    else
      aux := 'N';

  try
    dbMulticold.BeginTrans;
    gravaConfig('REMOVERS1',aux);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando REMOVER S1: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

    if checkBox3.Checked then
      aux := 'S'
    else
      aux := 'N';

  try
    dbMulticold.BeginTrans;
    gravaConfig('EXECUCAOAUTOMATICA',aux);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando UTILIZAR EXECUÇÃO AUTOMÁTICA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

   try
    dbMulticold.BeginTrans;
    gravaConfig('INTERVALO',edit7.Text);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando INTERVALO ENTRE EXECUÇÕES: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

   if checkBox4.Checked then
      aux := 'S'
    else
      aux := 'N';

  try
    dbMulticold.BeginTrans;
    gravaConfig('EXTENSAOAUTOMATICA',aux);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando UTILIZAR EXTENSÃO AUTOMÁTICA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

   try
    dbMulticold.BeginTrans;
    gravaConfig('FORMATOEXTENSAO',edit8.Text);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando FORMATO DA EXTENSÃO AUTOMÁTICA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

    if checkBox5.Checked then
      aux := 'S'
    else
      aux := 'N';

  try
    dbMulticold.BeginTrans;
    gravaConfig('SEPARACAOAUTOMATICA',aux);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando UTILIZAR SEPARAÇÃO AUTOMÁTICA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DECIMALCARACTEREQUEBRA',edit9.Text);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DECIMAL DO CARACTERE DE QUEBRA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('COLUNACARACTEREQUEBRA',edit10.Text);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando COLUNA DO CARACTERE DE QUEBRA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

    if checkBox6.Checked then
      aux := 'S'
    else
      aux := 'N';

  try
    dbMulticold.BeginTrans;
    gravaConfig('LIMPEZAAUTOMATICA',aux);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando REMOVER CARACTERE INDICADOR: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('SISTEMA',upperCase(edit17.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando 1º NÍVEL: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('GRUPO',upperCase(edit11.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando 2º NÍVEL: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('SUBGRUPO',upperCase(edit12.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando 3º NÍVEL: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIRETORIOENTRADA',upperCase(edit13.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DIRETÓRIO DE ENTRADA DA LIMPEZA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIRETORIOSAIDA',upperCase(edit14.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DIRETÓRIO DE SAÍDA DA LIMPEZA: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIASPERMANENCIA',edit16.Text);
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DATA DE CORTE: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

  try
    dbMulticold.BeginTrans;
    gravaConfig('DIRETORIOGRAVACAO',upperCase(edit15.Text));
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando DIRETÓRIO DE GRAVAÇÃO DE CD: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

    Query01.Prepared := false;
    Query02.Prepared := false;
    Query03.Prepared := false;
    Query04.Prepared := false;

  try
    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM MAPACARACTERE WHERE CODUSUARIO=''ADM''');
    Query01.ExecSQL;
    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro LIMPANDO O MAPA DE CARACTERES: '+e.Message,mtError,[mbOk],0);
      end;
    end; //try

    Query01.SQL.Clear;
    Query01.SQL.Add('INSERT INTO mapacaractere (CODUSUARIO,CODCARACTEREENTRA,CODCARACTERESAI,CARACTEREENTRADA,CARACTERESAIDA) VALUES (?,?,?,?,?)');
    Query01.Prepared := true;
  try
    dbMulticold.BeginTrans;
    for i := 1 to stringGrid1.RowCount-1 do
      begin
      Query01.Parameters[0].Value := 'ADM';
      Query01.Parameters[1].Value := trim(stringGrid1.Cells[1,i]);
      Query01.Parameters[2].Value := trim(stringGrid1.Cells[2,i]);
      Query01.Parameters[3].Value := trim(stringGrid1.Cells[3,i]);
      Query01.Parameters[4].Value := trim(stringGrid1.Cells[4,i]);
      J := i;
      Query01.ExecSQL;
      end;
    Query01.Prepared := false;

    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando MAPA DE CARACTERES('+IntToStr(J)+'): '+e.Message,mtError,[mbOk],0);
      end;
  end;
  end;
BitBtn1.Enabled := true;
end;

procedure TfConfiguracao.SpeedButton8Click(Sender: TObject);
begin
close;
end;

procedure TfConfiguracao.BitBtn2Click(Sender: TObject);
begin
FormCreate(Sender);
end;

procedure TfConfiguracao.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
if ACol <> 2 then
  CanSelect := false;
end;

procedure TfConfiguracao.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  x : integer;
begin
try
  x := strToInt(Value);
  if (x < 1) then
    StringGrid1.Cells[2,ARow] := '1'
  else if (x > 255) then
    StringGrid1.Cells[2,ARow] := '255';
  StringGrid1.Cells[3,ARow] := chr(strToInt(StringGrid1.Cells[1,ARow]));
  StringGrid1.Cells[4,ARow] := chr(strToInt(StringGrid1.Cells[2,ARow]));
except
    //StringGrid1.Cells[2,ARow] := '32'
end;
end;

procedure TfConfiguracao.CheckBox6Click(Sender: TObject);
begin
//speedButton5.Enabled := checkBox6.Checked;
//speedButton6.Enabled := checkBox6.Checked;
//label13.Enabled := checkBox6.Checked;
//edit13.Enabled := checkBox6.Checked;
//label14.Enabled := checkBox6.Checked;
//edit14.Enabled := checkBox6.Checked;
//label16.Enabled := checkbox6.Checked;
//edit16.Enabled := checkBox6.Checked;
end;

end.
