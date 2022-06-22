unit UMulticoldMigrate;

interface

uses
  SuTypGer, SysUtils, System.Classes;

  type
    TgFilIn = Array Of SetOfChar;

    TgStrStr = Record
    public
      Col,
      Tam : Integer;
      FilStr : TgStr255;
    End;

    TgStrInc = Array Of TgStrStr;

    TFiltro = Class
    strict private
      FFiltroIn : TgFilIn;
      FFiltroOut : TgFilIn;
      FStrInc : TgStrInc;
      FStrExc : TgStrInc;
      FMensagens: TStringList;
    public
      Constructor Create(var aMensagens: TStringList);
      Function EncheFiltro(Celula, Nome : AnsiString; Var Filtro : SetOfChar; Ind : Integer) : Boolean;
      Function EncheStr(Celula, Nome : TgStr255; Var StrFil : TgStrStr; Ind : Integer) : Boolean;
    End;

implementation

{ TFiltro }

constructor TFiltro.Create(var aMensagens: TStringList);
begin
  FMensagens := aMensagens;
end;

function TFiltro.EncheFiltro(Celula, Nome: AnsiString; var Filtro: SetOfChar;
  Ind: Integer): Boolean;
Var
  M : Integer;
  CharFiltro : TgStr255;

Begin
  EncheFiltro := True;
  M := 1;
  Repeat
    CharFiltro := '';
    While (Length(CharFiltro) <> 3) And
          (M <= Length(Celula)) Do
      Begin
      CharFiltro := CharFiltro + Celula[M];
      Inc(M);
      End;
    If CharFiltro[3] = '.' Then
      While (Length(CharFiltro) <> 6) And
            (M <= Length(Celula)) Do
        Begin
        CharFiltro := CharFiltro + Celula[M];
        Inc(M);
        End;
  Inc(M,1); { Para fugir da vírgula}
  If Length(CharFiltro) = 3 Then
    Begin
    If (CharFiltro[1] <> CharFiltro[3]) Or (CharFIltro[1] <> '''') Then
      Begin
      FMensagens.Add('Filtro Inválido: Campo'+IntToStr(Ind)+' "' + Nome + '"');
      EncheFiltro := False;
      Exit;
      End;
    Filtro := Filtro + [CharFiltro[2]];
    End
  Else
    Begin
    If (CharFiltro[1] <> CharFiltro[6]) Or (CharFIltro[1] <> '''') Then
      Begin
      FMensagens.Add('Filtro Inválido: Campo'+IntToStr(Ind)+' "'+Nome+'"');
      EncheFiltro := False;
      Exit;
      End;
    Filtro := Filtro + [CharFiltro[2]..CharFiltro[5]];
    End;
  Until M >= Length(Celula);
end;

function TFiltro.EncheStr(Celula, Nome: TgStr255; var StrFil: TgStrStr;
  Ind: Integer): Boolean;
Var
  Err : Integer;
  N : Integer;
  CharFiltro : TgStr255;

Begin
  EncheStr := True;   // Assume tudo ok
  N := 1;
  CharFiltro := '';
  While (Celula[N] <> ',') And
        (N <= Length(Celula)) Do
    Begin
    CharFiltro := CharFiltro + Celula[N];
    Inc(N);
    End;
  Inc(N); { Fugir da Vírgula }
  Val(CharFiltro,StrFil.Col,Err);
  If (Err <> 0) Or (CharFiltro = '') Then
      Begin
      FMensagens.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
      EncheStr := False;
      Exit;
      End;

  CharFiltro := '';
  While (Celula[N] <> '=') And
        (N <= Length(Celula)) Do
    Begin
    CharFiltro := CharFiltro + Celula[N];
    Inc(N);
    End;
  Inc(N); { Fugir do igual }
  Val(CharFiltro,StrFil.Tam,Err);
  If (Err <> 0) Or (CharFiltro = '') Then
      Begin
      FMensagens.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
      EncheStr := False;
      Exit;
      End;

  CharFiltro := '';
  While (N <= Length(Celula)) Do
    Begin
    CharFiltro := CharFiltro + Celula[N];
    Inc(N);
    End;
  If (CharFiltro[1] <> CharFiltro[Length(CharFiltro)]) Or
     (CharFiltro[1] <> '''') Then
    Begin
    FMensagens.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
    EncheStr := False;
    Exit;
    End;
  If (StrFil.Tam <> Length(CharFiltro)-2) Then
    Begin
    FMensagens.Add('Str Inválida: Campo'+IntToStr(Ind)+' "'+Nome+'"');
    EncheStr := False;
    Exit;
    End;
  StrFil.FilStr := Copy(CharFiltro,2,Length(CharFiltro)-2);
end;

end.
