unit ConversorUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    procedure Edit1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  BufferIn : Array[1..1000000] of AnsiChar;
  BufferOut : Array[1..2000000] of AnsiChar;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
  ArqIn,
  ArqOut : File;
  Lidos,
  Escritos,
  I, J : Integer;
begin
AssignFile(Arqin, Edit1.Text);
AssignFile(Arqout, Edit1.Text+'.Convertido');
Reset(ArqIn, 1);
Rewrite(ArqOut, 1);

while Not Eof(ArqIn) do
  begin
  BlockRead(ArqIn, BufferIn, 1000000, Lidos);
  J := 1;
  for I := 1 to lidos do
    begin
    if BufferIn[I] = #12 then
      BufferOut[J] := ' '
    else
    if BufferIn[I] = #10 then
      begin
      BufferOut[J] := #13;
      Inc(J);
      BufferOut[J] := BufferIn[I];
      end
    else
      BufferOut[J] := BufferIn[I];
    Inc(J);
    end;
  BlockWrite(ArqOut, BufferOut, J, Escritos);
  end;

CloseFile(ArqIn);
CloseFile(ArqOut);

ShowMessage('Fim de conversão');

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Edit1DblClick(Sender: TObject);
begin
if OpenDialog1.Execute then
  edit1.Text := OpenDialog1.FileName;
end;

end.
