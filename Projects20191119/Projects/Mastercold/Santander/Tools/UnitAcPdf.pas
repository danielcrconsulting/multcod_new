unit UnitAcPdf;

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
Var
  ArqIn,
  ArqOut,
  ArqPdf : TextFile;
  Linha : AnsiString;
  InMem : Array[1..10000] of AnsiString;
  I, J : Integer;
begin
AssignFile(ArqPdf, 'C:\Rom\REAL_MASTERCOLD\Problema\ABN.216.fatemail.txt');
Reset(ArqPdf);
for I := Low(InMem) to High(InMem) do
  InMem[I] := '';

I := 1;
while Not Eof(ArqPdf) do
  begin
    ReadLn(ArqPdf, Linha);
    if (Length(Linha) > 1) and (Linha[1] = '1') and (Linha[2] = 'F') then
      begin
        InMem[I] := Linha;
        Inc(I);
      end;
  end;
//Dec(I); // Número exato de itens no array...
CloseFile(ArqPdf);

AssignFile(ArqIn, 'C:\Rom\REAL_MASTERCOLD\Problema\ABN.216.DOCS2.ComProblema');
AssignFile(ArqOut, 'C:\Rom\REAL_MASTERCOLD\Problema\ABN.216.DOCS2.txt');

Reset(ArqIn);
Rewrite(ArqOut);

ReadLn(ArqIn, Linha);
WriteLn(ArqOut, Linha);
I := 1;
while Not Eof(ArqIn) do
  begin
    ReadLn(ArqIn, Linha);
    J := 0;
//    ShowMessage(Copy(Linha, 39, 16)+'/'+Copy(InMem[I], 24, 16));
    While Copy(Linha, 39, 16) = Copy(InMem[I], 24, 16) do
      begin
        Inc(I);
        Inc(J);
      end;
    WriteLn(ArqOut, Copy(Linha, 1, Length(Linha)-1), J);
  end;

CloseFile(ArqIn);
CloseFile(ArqOut);

ShowMessage('Fim...');

end;

end.
