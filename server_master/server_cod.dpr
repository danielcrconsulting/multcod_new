program server_cod;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'FormUnit1.pas' {Form1},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas' {ServerMethods1: TDSServerModule},
  ServerContainerUnit1 in 'ServerContainerUnit1.pas' {ServerContainer1: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule1: TDataModule},
  ClientClassesUnit2 in 'ClientClassesUnit2.pas',
  UMetodosServer in 'UMetodosServer.pas',
  SuTypGer in '..\CRConsulting\Multicod\Subrug\SuTypGer.pas',
  Subrug in '..\CRConsulting\Multicod\Subrug\Subrug.pas',
  SuTypMultiCold in '..\CRConsulting\Multicod\Subrug\SuTypMultiCold.pas',
  Pilha in '..\CRConsulting\Multicod\CR CONSULTING\Pilha.pas',
  dm in '..\CRConsulting\Multicod\MultiCold\MULTICOLDSERVER\SOAP\dm.pas' {DataModule1: TDataModule},
  UMulticoldReport in 'UMulticoldReport.pas',
  UMulticoldFunctions in 'UMulticoldFunctions.pas',
  UMulticoldMigrate in 'UMulticoldMigrate.pas',
  UExtratorDados in 'UExtratorDados.pas',
  ZLIBEX in '..\CRConsulting\Multicod\Subrug\DelphiZLib\ZLIBEX.PAS';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TClientModule1, ClientModule1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.