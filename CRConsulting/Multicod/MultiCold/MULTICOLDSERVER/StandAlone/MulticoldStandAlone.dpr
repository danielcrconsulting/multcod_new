program MulticoldStandAlone;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'FormUnit1.pas' {Form1},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  Pilha in '..\..\..\CR CONSULTING\Pilha.pas',
  SuTypGer in '..\..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\..\Subrug\SuTypMultiCold.pas',
  ZLIBEX in '..\..\..\Subrug\DelphiZLib\ZLIBEX.PAS',
  dm in '..\SOAP\dm.pas' {DataModule1: TDataModule},
  UBuscaSequencial in '..\SOAP\UBuscaSequencial.pas',
  MulticoldServerImpl in '..\SOAP\MulticoldServerImpl.pas',
  MulticoldServerIntf in '..\SOAP\MulticoldServerIntf.pas',
  UMulticoldReport in '..\SOAP\UMulticoldReport.pas',
  UMulticoldFunctions in '..\SOAP\UMulticoldFunctions.pas',
  Subrug in '..\..\..\Subrug\Subrug.pas',
  UMulticoldMigrate in '..\SOAP\UMulticoldMigrate.pas',
  UExtratorDados in '..\SOAP\UExtratorDados.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
