unit UnitSort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Generics.Collections, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type
  Registro = Record
             Cartao : Int64;
             PosInd : Integer;
             End;

var
  Form1: TForm1;
  Tudo: Array of Registro;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
  I: Integer;
  V : Int64;
begin
Edit1.Text := 'Inicializando...';
Edit2.Text := FormatDateTime('hh:nn:ss.zzz', Now);
Edit3.Text := '';
Edit4.Text := '';

Application.ProcessMessages;

if RadioGroup1.ItemIndex = 0 then
  V := 200000000
else
if RadioGroup1.ItemIndex = 1 then
  V := 150000000
else
if RadioGroup1.ItemIndex = 2 then
  V := 100000000
else
if RadioGroup1.ItemIndex = 3 then
  V := 90000000
else
if RadioGroup1.ItemIndex = 4 then
  V := 80000000
else
if RadioGroup1.ItemIndex = 5 then
  V := 70000000
else
if RadioGroup1.ItemIndex = 6 then
  V := 60000000
else
if RadioGroup1.ItemIndex = 7 then
  V := 50000000
else
if RadioGroup1.ItemIndex = 8 then
  V := 40000000
else
if RadioGroup1.ItemIndex = 9 then
  V := 30000000
else
if RadioGroup1.ItemIndex = 10 then
  V := 20000000
else
  V := 10000000;

SetLength(Tudo, V);
for I := Low(Tudo) to High(Tudo) do
  Begin
  Tudo[I].Cartao := 70000000 - I;
  Tudo[I].PosInd := 0;
  End;

Edit1.Text := 'Inicio do sort...';
Edit3.Text := FormatDateTime('hh:nn:ss.zzz', Now);
Application.ProcessMessages;

TArray.Sort<Registro>(Tudo);

Edit1.Text := 'Fim do sort...';
Edit4.Text := FormatDateTime('hh:nn:ss.zzz', Now);
Application.ProcessMessages;

SetLength(Tudo, 0);

ShowMessage('Fim do teste...');

end;

end.
