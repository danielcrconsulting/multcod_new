program Pdf;

uses
  Vcl.Forms,
  PdfUnit1 in 'PdfUnit1.pas' {Form1},
  DebenuPDFLibrary in '..\Debenu\PDF Library\Delphi\DebenuPDFLibrary1115DelphiXE4Win64\DebenuPDFLibrary.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
