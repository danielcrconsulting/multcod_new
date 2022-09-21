program ProcessadorExtrator;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  UMulticoldReport in '..\SOAP\UMulticoldReport.pas',
  ZLIBEX in '..\..\..\Subrug\DelphiZLib\ZLIBEX.PAS',
  SuTypGer in '..\..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\..\Subrug\SuTypMultiCold.pas',
  Pilha in '..\..\..\CR CONSULTING\Pilha.pas',
  UMulticoldFunctions in '..\SOAP\UMulticoldFunctions.pas',
  UProcessaExtrator in 'UProcessaExtrator.pas',
  UDM in 'UDM.pas' {DMMain: TDataModule},
  UMulticoldMigrate in '..\SOAP\UMulticoldMigrate.pas',
  UExtratorDados in '..\SOAP\UExtratorDados.pas',
  ClientClassesUnit2 in '..\..\..\..\..\server_cod\ClientClassesUnit2.pas',
  UMetodosServer in '..\..\..\..\..\server_cod\UMetodosServer.pas',
  UclsAux in '..\..\..\..\..\server_cod\UclsAux.pas';

var
  processador: TProcessaddor;

begin
  try

    processador := TProcessaddor.Create;
    try
      processador.ProcessarPendentes;

    finally
      FreeAndNil(processador);
    end;
  except
  on E: Exception do
    Writeln(E.ClassName, ': ', E.Message);
  end;
end.
