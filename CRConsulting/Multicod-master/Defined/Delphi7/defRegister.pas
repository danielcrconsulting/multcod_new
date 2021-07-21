unit defRegister;

interface

{$R defRegister.dcr}

uses Classes;

procedure Register;

implementation

uses
  defhook, definspect;

procedure Register;
begin
  RegisterComponents('Defined', [TDefinedHook, TDefinedInspector]);
end;

end.
