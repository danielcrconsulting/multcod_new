{ Invokable implementation File for TMultiColdServer which implements IMultiColdServer }

unit MultiColdServerImpl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, MultiColdServerIntf;

type

  { TMultiColdServer }
  TMultiColdServer = class(TInvokableClass, IMultiColdServer)
  public
    function echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function echoDouble(const Value: Double): Double; stdcall;
  end;

implementation

function TMultiColdServer.echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
begin
  { TODO : Implement method echoEnum }
  Result := Value;
end;

function TMultiColdServer.echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
begin
  { TODO : Implement method echoDoubleArray }
  Result := Value;
end;

function TMultiColdServer.echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
begin
  { TODO : Implement method echoMyEmployee }
  Result := TMyEmployee.Create;
end;

function TMultiColdServer.echoDouble(const Value: Double): Double; stdcall;
begin
  { TODO : Implement method echoDouble }
  Result := Value;
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TMultiColdServer);
end.

