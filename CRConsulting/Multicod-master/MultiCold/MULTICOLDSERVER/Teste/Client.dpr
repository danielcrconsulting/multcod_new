program Client;

uses
  Forms,
  ClientUnit1 in 'ClientUnit1.pas' {Form1},
  ITeste1 in 'ITeste1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
