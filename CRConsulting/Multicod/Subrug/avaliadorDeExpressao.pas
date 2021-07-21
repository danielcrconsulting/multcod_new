unit avaliadorDeExpressao;

interface

  function avaliaExpressao(expressao : string) : string;
  function demonstraResultado(expressao : string) : string;

implementation

var
  arrPilha : array of string;

// Obtém a prioridade do elemento na expressão
function obtemPrioridade(caractere : string) : Integer;
begin
result := 0;
if caractere = '(' then
  result := 1
else if caractere[1] in ['+','-'] then
  result := 2
else if caractere[1] in ['*','/'] then
  result := 3
else if caractere[1] in ['^'] then
  result := 4;
end;

// Testa se o caractere é um operando
function ehOperando(caractere : string) : boolean;
begin
result := (pos(caractere, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') > 0);
end;

// Testa se o caractere é um operador
function ehOperador(caractere : string) : boolean;
begin
result := (pos(caractere, '+-/*^') > 0);
end;

// Limpa pilha
procedure clearStack;
begin
setLength(arrPilha,0);
end;

// Retorna ítem no topo da pilha
function peek : string;
begin
result := arrPilha[high(arrPilha)];
end;

// Retorna ítem no topo da pilha e remove da pilha
function pop : string;
begin
result := arrPilha[length(arrPilha)-1];
SetLength(arrPilha,length(arrPilha)-1);
end;

// Adciona ítem a pilha
procedure push(valor:string);
begin
SetLength(arrPilha,length(arrPilha)+1);
arrPilha[length(arrPilha)-1] := valor;
end;

// Indica se um elemento está na pilha
function contains(valor:string) : boolean;
var
  j : integer;
begin
result := false;
for j := 0 to high(arrPilha) do
  if arrPilha[j] = valor then
    begin
    result := true;
    break;
    end;
end;

// retorna o número de ítens na pilha
function count: integer;
begin
result := length(arrPilha);
end;

// Analisa expressão infixa e retona expressão pós-fixa
function avaliaExpressao(expressao : string) : string;
var
  i,
  prioridade : integer;
  item : string;
begin
result := '';
clearStack;
for i := 1 to length(expressao) do
  begin
  if ehOperando(expressao[i]) then
    result := result + expressao[i]
  else if ehOperador(expressao[i]) then
    begin
    prioridade := obtemPrioridade(expressao[i]);
    while (count > 0) and (obtemPrioridade(peek) > prioridade) do
      result := result + pop;
    push(expressao[i]);
    end
  else if expressao[i] = '(' then
    push(expressao[i])
  else if expressao[i] = ')' then
    begin
    item := pop;
    while (item <> '(') do
      begin
      result := result + item;
      item := pop;
      end;
    end;
  end;
while (count > 0) do
  result := result + pop;
end;

function demonstraResultado(expressao : string) : string;
var
  i,
  j : integer;
  operando1,
  operando2,
  operador : string;
begin
result := '';
clearStack;
j := 0; // Número de operandos empilhados desde o último operador
for i := length(expressao) downto 1 do
  begin
  if ehOperador(expressao[i]) then
    begin
    push(expressao[i]);
    j := 0;
    end
  else if (ehOperando(expressao[i])) then
    begin
    push(expressao[i]);
    inc(j);
    end;
  while (j = 2) do
    begin
    if ehOperando(peek) then
      operando1 := pop;
    if ehOperando(peek) then
      operando2 := pop
    else
      begin
      push(operando1);
      j := 1;
      continue;
      end;
    if ehOperador(peek) then
      operador := pop
    else
      begin
      push(operando2);
      push(operando1);
      j := 1;
      continue;
      end;
    result := result + 'X = ' + operando1 + ' ' + operador + ' ' + operando2 + #13#10;
    if count = 0 then
      j := 0;
    push('X');
    end;
  end;
end;

end.
