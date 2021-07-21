unit Pilha;

interface

uses
  SysUtils, Classes;

type
  TPilha = class(TComponent)
  private
    { Private declarations }
    arrPilha : array of variant;
  protected
    { Protected declarations }
    function fpeek : variant;                    // Retorna o objeto que está no topo da pilha, mas não remove-o
    function fpop : variant;                     // Retorna o objeto que está no topo da pilha e o remove.
    function fcount : Int64;                     // Retorna o número de ítens na pilha
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure clear;                             // Remove todos os objetos da pilha
    procedure push(valor : variant);             // Insere um objeto no topo da pilha
    function contains(valor : variant): boolean; // Indica se um elemento está na pilha.
  published
    { Published declarations }
    property count : int64 read fcount;
    property peek : variant read fpeek;
    property pop : variant read fpop;
  end;


procedure Register;

implementation

constructor TPilha.create;
begin
inherited create(AOwner);
clear;
end;

destructor TPilha.destroy;
begin
clear;
inherited destroy;
end;

procedure TPilha.clear;
begin
setLength(arrPilha,0); // Inicializa pilha
end;

function TPilha.fPeek;
begin
result := 0;
if arrPilha <> nil then
  try
    result := arrPilha[length(arrPilha)-1];
  except
  end;
end;

function TPilha.fpop;
begin
result := 0;
if arrPilha <> nil then
  try
    result := arrPilha[length(arrPilha)-1];
    setLength(arrPilha, length(arrPilha)-1);
  except
  end;
end;

procedure TPilha.push;
begin
if arrPilha = nil then
  clear;
setLength(arrPilha,length(arrPilha)+1);
arrPilha[length(arrPilha)-1] := valor;
end;

function TPilha.fCount;
begin
  result := 0;
if arrPilha = nil then
  clear
else
  try
    result := length(arrPilha);
  except
  end;
end;

function TPilha.contains;
var
  i : integer;
begin
result := false;
if arrPilha = nil then
  clear
else
  for i := 0 to count-1 do
    if arrPilha[i] = valor then
      begin
      result := true;
      break;
      end;
end;

procedure Register;
begin
  RegisterComponents('CR Consulting', [TPilha]);
end;

end.
 