Program ExeExtract;

Uses
  Forms,
  TestaDllExtractU in 'TestaDllExtractU.pas' {Form1},
  SuTypGer in '..\Subrug\Sutypger.pas',
  SuBrug in '..\Subrug\Subrug.pas',
  zlib in '..\Subrug\Zlib.pas';

{$R *.res}

Begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Form1.Button1.Click;
//  Application.Run;
End.
