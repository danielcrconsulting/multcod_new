program TrTabBran;

uses
  Vcl.Forms,
  UnitTrTabBran in 'UnitTrTabBran.pas' {Form1},
  Subrug in '..\Subrug\Subrug.pas',
  SuTypGer in '..\Subrug\SuTypGer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
