unit UMulticoldFunctions;


interface

uses
  Windows, SysUtils;

Function SeArquivoSemExt(Nome: String): String;

Function ColetaDiretorioTemporario : String;

Function SeTiraBranco(PiStr : String) : String;

implementation

Function SeTiraBranco;
Var
  Posic : Integer;
Begin
Posic := Pos(' ',PiStr);
While Posic <> 0 Do
  Begin
  Delete(PiStr,Posic,1);
  Posic := Pos(' ',PiStr);
  End;
SeTiraBranco := PiStr;
End;

Function SeArquivoSemExt;

Var
  StrAux : String;
  Posic : Integer;
Begin
StrAux := Nome;
While Pos('\',StrAux) <> 0 Do
  Delete(StrAux,1,1);
//Posic := Pos('.',StrAux);    // A porra da caixa envia arquivos com múltiplos pontos no nome!!!!
Posic := Length(StrAux);
While (Posic <> 0) and (StrAux[Posic] <> '.') Do
  Dec(Posic);
If Posic <> 0 Then
  Delete(StrAux,Posic,Length(StrAux) + 1 - Posic);
SeArquivoSemExt := StrAux;
End;

Function ColetaDiretorioTemporario : String;
Var
  P : pChar;
  X : String;
Begin
Result := '';

SetLength(X, 1000);
SetLength(X, GetEnvironmentVariable(PChar('TEMP'), PChar(X), Length(X)));
If X = '' Then
  Begin
  SetLength(X, 1000);
  SetLength(X, GetEnvironmentVariable(PChar('TMP'), PChar(X), Length(X)));
  End;

If X <> '' Then
  Result := IncludeTrailingPathDelimiter(X);

Exit;

P := GetEnvironmentStrings;

While P^ <> #0 Do
  Begin
  X := StrPas(p);
  If (UpperCase(Copy(X,1,4)) = 'TMP=') Then
    Begin
    Result := Copy(X,5,Length(X)-4);
    Result := IncludeTrailingPathDelimiter(Result);
    Exit;
    End;
  If (UpperCase(Copy(X,1,5)) = 'TEMP=') Then
    Begin
    Result := Copy(X,6,Length(X)-5);
    Result := IncludeTrailingPathDelimiter(Result);
    Exit;
    End;
  Inc(P, lStrLen(P) + 1);
  End;
FreeEnvironmentStrings(p);

End;



end.
