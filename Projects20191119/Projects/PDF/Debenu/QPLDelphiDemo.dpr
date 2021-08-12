program QPLDelphiDemo;

uses
  Forms,
  QPLDelphiDemoMainForm in 'QPLDelphiDemoMainForm.pas' {frmDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.Run;
end.
