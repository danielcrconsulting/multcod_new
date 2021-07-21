program GetCurUser;

uses
  Vcl.Forms,
  GetCurrUserNameUnit in '..\Qg\GetCurrUserNameUnit.pas' {Form1},
  Subrug in 'Subrug.pas',
  Pilha in '..\CR CONSULTING\Pilha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
