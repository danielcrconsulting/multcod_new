library MultiColdServer;

uses
  ActiveX,
  ComObj,
  WebBroker,
  ISAPIThreadPool,
  ISAPIApp,
  main in 'main.pas' {WebModule1: TWebModule},
  MulticoldServerImpl in 'MulticoldServerImpl.pas',
  MulticoldServerIntf in 'MulticoldServerIntf.pas',
  SuTypGer in '..\..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\..\Subrug\SuTypMultiCold.pas',
  SuBrug in '..\..\..\Subrug\Subrug.pas',
  Pilha in '..\..\..\CR CONSULTING\Pilha.pas',
  ZLibEx in '..\..\..\Subrug\DelphiZLib\ZLIBEX.PAS',
  dm in 'dm.pas' {DataModule1: TDataModule};

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.CreateForm(TWebModule1, WebModule1);
  Application.Run;
end.
