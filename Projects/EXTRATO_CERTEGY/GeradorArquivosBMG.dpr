program GeradorArquivosBMG;

uses
  Forms,
  UnitGeraArqBMG in 'UnitGeraArqBMG.pas' {Form1},
  SuTypGer in '..\Multicold\Subrug\SuTypGer.pas',
  SuBrug in '..\Multicold\Subrug\Subrug.pas',
  ZLibEx in '..\Multicold\Subrug\DelphiZLib\ZLIBEX.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
