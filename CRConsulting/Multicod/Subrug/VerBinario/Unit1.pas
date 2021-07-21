unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

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
Var
  Arq : File;
  Linha : Array[1..4000] of AnsiChar;
  X : Integer;

begin
FillChar(Linha[1], 4000, ' ');
AssignFile(Arq, 'C:\Users\Romero\Downloads\Softwares\Mastercold\ICSRCONTBMG_20170616.txt');
Reset(Arq, 1);
X := FileSize(Arq);
BlockRead(Arq, Linha, X);
CloseFile(Arq);
end;

end.
