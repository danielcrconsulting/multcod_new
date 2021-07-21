unit AbrUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
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
  Arq : TFileStream;
  Buffer : Packed array[1..10000] of AnsiChar;
  Linha : String;
  I : Integer;
begin
if Edit1.Text = '' then
  Begin
  ShowMessage('Informe o arquivo a abrir');
  Exit;
  End;
Try
  Edit2.Text := IntToStr(StrToInt64(Edit2.Text));
Except
  ShowMessage('Posição inválida');
  Exit;
End;

Arq := TFileStream.Create(Edit1.Text, fmOpenRead);

Arq.Position := StrToInt64(Edit2.Text);
Arq.Read(Buffer, 10000);

Linha := '';

for I := 1 to 10000 do
  Linha := Linha + Buffer[i];

Memo1.Text := '';
Memo1.Text := Linha;

Arq.Free;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close
end;

procedure TForm1.Edit1DblClick(Sender: TObject);
begin
if OpenDialog1.Execute then
  Edit1.Text := OpenDialog1.FileName;
end;

end.
