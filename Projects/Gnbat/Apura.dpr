program Apura;

uses
  Vcl.Forms,
  UApura in 'UApura.pas' {Form1},
  Subrug in '..\Subrug\Subrug.pas',
  Pilha in '..\CR CONSULTING\Pilha.pas',
  SuTypGer in '..\Subrug\SuTypGer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
