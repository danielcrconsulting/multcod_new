program Troca;

uses
  Vcl.Forms,
  UnitTroca in 'UnitTroca.pas' {Form1},
  SuTypGer in '..\Subrug\SuTypGer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
