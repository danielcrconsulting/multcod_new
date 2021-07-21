unit TesteUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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
Var i, j : Integer;
    Aa, Bb : Ttime;
begin

Aa := now;

for i := 0 to 100000 do
  for j := i to 100000 do;

Bb := now - Aa;

ShowMessage(TimeToStr(Bb));

end;

end.
