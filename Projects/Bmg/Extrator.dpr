program Extrator;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  DebenuPDFLibrary in 'C:\Program Files (x86)\Debenu\PDF Library\Delphi\DebenuPDFLibrary1115DelphiXE4Win64\DebenuPDFLibrary.pas',
  SuTypGer in '..\Subrug\SuTypGer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
