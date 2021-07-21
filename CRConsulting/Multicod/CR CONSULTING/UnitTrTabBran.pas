unit UnitTrTabBran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Types, IOUtils, Subrug;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Edit2: TEdit;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
  Linha,
  Texto : String;
  Arq : System.Text;
  I : Integer;
  DynArray: TStringDynArray;

begin
if Edit1.Text = '' then
  Exit;

Edit2.Text := '';
Application.ProcessMessages;

Linha := ExtractFilePath(Edit1.Text);

DynArray := TDirectory.GetFiles(Linha, '*.pas', TSearchOption.soAllDirectories);

for I := Low(DynArray) to High(DynArray) do
  begin

  Edit2.Text := DynArray[I];
  Application.ProcessMessages;

  AssignFile(Arq, DynArray[I]);
  Reset(Arq);
  Texto := '';
  While not Eof(Arq) do
    begin
    ReadLn(Arq, Linha);
    Texto := Texto + Linha + #13#10;
    end;
  CloseFile(Arq);

  Texto := Texto.Replace(#9, '  ', [rfReplaceAll]);

  AssignFile(Arq, DynArray[I]);
  ReWrite(Arq);
  Write(Arq, Texto);
  CloseFile(Arq);
  end;

ShowMessage('End: ');

end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  x : TFormatSettings;
  Val : Extended;
begin

x.DecimalSeparator := '.';

Val := StrToFloat('1.1', x);

ShowMessage(FloatToStr(Val));

Beep; //( 750, 300 );

if SeNumeric(FloatToStr(Val), ['0'..'9','.',',']) then
  ShowMessage('É numérico');

end;

procedure TForm1.Edit1DblClick(Sender: TObject);
begin
if OpenDialog1.Execute then
  Edit1.Text := OpenDialog1.FileName;
end;

end.
