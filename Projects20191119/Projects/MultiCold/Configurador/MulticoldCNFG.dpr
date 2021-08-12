program MulticoldCNFG;

uses
  Forms,
  main in 'main.pas' {frmPrincipal},
  dbCnfg in 'dbCnfg.pas' {frmDbCnfg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmDbCnfg, frmDbCnfg);
  Application.Run;
end.
