program MastercoldPDF;

uses
  Vcl.Forms,
  Unit11 in 'Unit11.pas' {Form1},
  DebenuPDFLibrary in 'C:\Program Files (x86)\Debenu\PDF Library\Delphi\DebenuPDFLibrary1115DelphiXE4Win32\DebenuPDFLibrary.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
