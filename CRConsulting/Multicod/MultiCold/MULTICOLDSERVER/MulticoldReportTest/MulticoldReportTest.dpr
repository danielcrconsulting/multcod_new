program MulticoldReportTest;

uses
  Vcl.Forms,
  FrmPrincipal in 'FrmPrincipal.pas' {Form2},
  UMulticoldReport in '..\SOAP\UMulticoldReport.pas',
  Pilha in '..\..\..\CR CONSULTING\Pilha.pas',
  SuTypGer in '..\..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\..\Subrug\SuTypMultiCold.pas',
  ZLIBEX in '..\..\..\Subrug\DelphiZLib\ZLIBEX.PAS',
  UMulticoldFunctions in '..\SOAP\UMulticoldFunctions.pas',
  UMulticoldMigrate in '..\SOAP\UMulticoldMigrate.pas',
  UExtratorDados in '..\SOAP\UExtratorDados.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
