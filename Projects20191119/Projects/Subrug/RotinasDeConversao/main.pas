unit main;

interface

uses
    Sysutils, Classes, zlibex, PesquisaMastercold;

  function BinarioParaHexa(binBuff: pChar): pChar; stdCall;
  function HexaParaBinario(hexaBuff, fileName: pChar): pChar; stdCall;

implementation

function BinarioParaHexa(binBuff: pChar): pChar; stdCall;
var
  aBinBuff : array [0..5000] of char;
  aHexaBuff : array [0..5000] of char;
  strAux : String;
begin
fillChar(aBinBuff,sizeOf(aBinBuff),0);
fillChar(aHexaBuff,sizeOf(aHexaBuff),0);
move(binBuff^,aBinBuff,length(aBinBuff));
binToHex(aBinBuff,aHexaBuff,length(binBuff));
setLength(strAux, sizeOf(aHexaBuff));
strAux := aHexaBuff;
BinarioParaHexa := pChar(strAux);
end;

function HexaParaBinario(hexaBuff, fileName: pChar): pChar; stdCall;
var
  strAux : String;
  f:system.text;
  o:TPesquisaMastercold;
begin
try
  // Cria objeto e descomprime o extrato
  o := TPesquisaMastercold.Create(nil);
  strAux := o.descomprimeExtrato(hexaBuff);
  o.Free;
  // Escreve o buffer descomprimido num arquivo temporário
  assignFile(f,fileName);
  rewrite(f);
  writeLn(f,strAux);
  closefile(f);
  // Formata o retorno da função
  setLength(strAux,2);
  strAux := 'ok';
  result := pChar(strAux);
except
  on e:exception do
    begin
    assignFile(f,'c:\evisnet.log');
    if not fileExists('c:\evisnet.log') then
      rewrite(f);
    append(f);
    writeLn(f,formatDateTime('dd/mm/yyyy hh:nn:ss',now)+' [HexaParaBinario] - '+e.message);
    closefile(f);
    setLength(strAux,3);
    strAux := 'nok';
    result := pChar(strAux);
    end;
end;
end;

end.
