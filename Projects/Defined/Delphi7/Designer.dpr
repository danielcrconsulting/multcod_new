program Designer;

uses
  Forms,
  dfdesigner in 'dfdesigner.pas' {fmDFDesigner};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Defined Forms';
  Application.CreateForm(TfmDFDesigner, fmDFDesigner);
  Application.Run;
end.
