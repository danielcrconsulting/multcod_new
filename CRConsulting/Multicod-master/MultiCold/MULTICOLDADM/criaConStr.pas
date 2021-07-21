unit criaConStr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, ADODB, System.UITypes;

type
  TfCriaConStr = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    BitBtn1: TBitBtn;
    SpeedButton2: TSpeedButton;
    ADOConnection1: TADOConnection;
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCriaConStr: TfCriaConStr;

implementation

{$R *.dfm}

procedure TfCriaConStr.SpeedButton2Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TfCriaConStr.BitBtn1Click(Sender: TObject);
var
  f: System.Text;
  s, fName: String;
begin
s := 'Provider=SQLOLEDB.1;Password='+Edit3.Text+';Persist Security Info=True;User ID='+Edit2.Text+';Initial Catalog=Multicold;Data Source='+Edit1.Text;
adoConnection1.ConnectionString := s;
try
  adoConnection1.Connected := true;
  adoConnection1.Connected := false;
except
  begin
  messageDlg('Erro tentando conectar ao banco de dados. Verifique as informações digitadas e tente novamente.',mtError,[mbOk],0);
  exit;
  end;
end;
// Cria UDL para o Multicold
fName := ExtractFilePath(ParamStr(0)) + 'MultiCold.udl';
assignFile(f,fName);
rewrite(f);
writeLn(f,'[oledb]');
writeLn(f,'; Everything after this line is an OLE DB initstring');
writeLn(f,s);
closeFile(f);
// Cria UDL para o Multicold_evento
s := 'Provider=SQLOLEDB.1;Password='+Edit3.Text+';Persist Security Info=True;User ID='+Edit2.Text+';Initial Catalog=Multicold_evento;Data Source='+Edit1.Text;
fName := ExtractFilePath(ParamStr(0)) + 'MultiColdEventos.udl';
assignFile(f,fName);
rewrite(f);
writeLn(f,'[oledb]');
writeLn(f,'; Everything after this line is an OLE DB initstring');
writeLn(f,s);
closeFile(f);
// Cria UDL para o Multicold_log
s := 'Provider=SQLOLEDB.1;Password='+Edit3.Text+';Persist Security Info=True;User ID='+Edit2.Text+';Initial Catalog=Multicoldlog;Data Source='+Edit1.Text;
fName := ExtractFilePath(ParamStr(0)) + 'MultiColdLog.udl';
assignFile(f,fName);
rewrite(f);
writeLn(f,'[oledb]');
writeLn(f,'; Everything after this line is an OLE DB initstring');
writeLn(f,s);
closeFile(f);
Self.Close;
end;

end.





