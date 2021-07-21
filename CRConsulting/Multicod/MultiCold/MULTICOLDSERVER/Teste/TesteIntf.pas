{ Invokable interface ITeste }

unit TesteIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type

  { Invokable interfaces must derive from IInvokable }
  ITeste = interface(IInvokable)
  ['{60D53EE5-D6B4-49B8-AB36-90780D15722E}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }

  function GetRelatorio(const Usuario, Senha: WideString; ConnectionID: Integer; const ListaCodRel: WideString; var FullPaths: WideString): WideString; stdCall;

  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(ITeste));

end.
 