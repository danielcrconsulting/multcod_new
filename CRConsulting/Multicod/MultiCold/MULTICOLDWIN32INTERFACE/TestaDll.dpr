program TestaDll;

uses
  Forms,
  UnitDeTesteDaDll in 'UnitDeTesteDaDll.pas' {Form1},
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  SuTypGer in '..\Subrug\SuTypGer.pas',
  ZLibEx in '..\Subrug\DelphiZLib\ZLIBEX.PAS',
  zlib in '..\Subrug\Zlib.pas',
  SuBrug in '..\Subrug\Subrug.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
