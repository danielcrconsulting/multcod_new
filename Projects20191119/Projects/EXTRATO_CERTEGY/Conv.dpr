program Conv;

uses
  Forms,
  UConv in 'UConv.pas' {Form1},
  Sugeral in 'Sugeral.pas' {FormGeral},
  SuTypGer in '..\Subrug\Sutypger.pas',
  SuBrug in '..\Subrug\Subrug.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.Run;
end.
