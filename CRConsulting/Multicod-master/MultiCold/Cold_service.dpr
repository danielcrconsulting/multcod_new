program Cold_service;

uses
  SvcMgr,
  main in 'main.pas' {Cold: TService};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TCold, Cold);
  Application.Run;
end.
