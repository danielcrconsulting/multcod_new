Program MultiColdServer;

uses
  Forms,
  MultiColdServerUnit1 in 'MultiColdServerUnit1.pas' {MultiColdServerForm},
  MultiColdServer_TLB in 'MultiColdServer_TLB.pas',
  MultiColdServerInterfaceUnit1 in 'MultiColdServerInterfaceUnit1.pas' {MultiColdDataServer: TRemoteDataModule},
  SuBrug in '..\..\Subrug\Subrug.pas',
  SuTypGer in '..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\Subrug\SuTypMultiCold.pas',
  ZLibEx in '..\..\Subrug\DelphiZLib\ZLIBEX.PAS';

{$R *.TLB}

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TMultiColdServerForm, MultiColdServerForm);
  Application.Run;
End.
