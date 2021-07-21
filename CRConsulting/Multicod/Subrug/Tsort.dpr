program Tsort;

uses
  Forms,
  Ts in 'TS.PAS' {FormTs},
  SSort in 'SSORT.PAS',
  SuTypGer in 'SUTYPGER.PAS';

{$R *.RES}

begin
  Application.CreateForm(TFormTs, FormTs);
  Application.Run;
end.
