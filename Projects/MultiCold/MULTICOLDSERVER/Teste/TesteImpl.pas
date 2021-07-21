{ Invokable implementation File for TTeste which implements ITeste }

unit TesteImpl;

interface

uses InvokeRegistry, Types, XSBuiltIns, TesteIntf;

type

  { TTeste }
  TTeste = class(TInvokableClass, ITeste)
  public

//  function deSobra : boolean;

  function GetRelatorio(const Usuario, Senha: WideString; ConnectionID: Integer; const ListaCodRel: WideString; var FullPaths: WideString): WideString; stdCall;

  end;

implementation

//function TTeste.deSobra;
//begin
//Result := True;
//end;

function TTeste.GetRelatorio;
begin
Result := Usuario+Senha;
end;

initialization
  { Invokable classes must be registered }
  InvRegistry.RegisterInvokableClass(TTeste);

end.
 