unit dfRegister;

interface

{$R dfRegister.dcr}

uses Classes;

procedure Register;

implementation

uses
  dfclasses, dfcontrols, dflistview, dfproducer;

procedure Register;
begin
  RegisterComponents('Defined', [TDFEngine, TDFDisplay, TDFActiveDisplay,
    TDFDesigner, TDFContentProducer, TdfListViewPrinter]);
end;

end.
