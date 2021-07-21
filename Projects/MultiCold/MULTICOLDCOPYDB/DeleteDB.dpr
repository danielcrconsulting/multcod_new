program DeleteDB;

uses
  Forms,
  principal in 'principal.pas' {fPrincipal},
  dataModule in 'dataModule.pas' {repositorioDeDados: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Multicold limpa banco';
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.CreateForm(TrepositorioDeDados, repositorioDeDados);
  Application.Run;
end.
