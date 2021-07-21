program MulticoldServer;

{$APPTYPE CONSOLE}

uses
  WebBroker,
  CGIApp,
  main in 'main.pas' {WebModule1: TWebModule},
  MulticoldServerImpl in 'MulticoldServerImpl.pas',
  MulticoldServerIntf in 'MulticoldServerIntf.pas',
  SuTypGer in '..\..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\..\Subrug\SuTypMultiCold.pas',
  Subrug in '..\..\..\Subrug\Subrug.pas',
  Pilha in '..\..\..\CR CONSULTING\Pilha.pas',
  ZLIBEX in '..\..\..\Subrug\DelphiZLib\ZLIBEX.PAS',
  dm in 'dm.pas' {DataModule1: TDataModule},
  UBuscaSequencial in 'UBuscaSequencial.pas',
  UMulticoldReport in 'UMulticoldReport.pas',
  UMulticoldFunctions in 'UMulticoldFunctions.pas',
  UExtratorDados in 'UExtratorDados.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TWebModule1, WebModule1);
  Application.Run;
end.
