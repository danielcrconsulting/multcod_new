program TestaDllExtract;

uses
  Forms,
  TestaDllExtractU in 'TestaDllExtractU.pas' {Form1},
  Subrug in '..\Subrug\Subrug.pas',
  ZLIBEX in '..\Subrug\DelphiZLib\ZLIBEX.PAS',
  SuTypGer in '..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  Pilha in '..\CR CONSULTING\Pilha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
