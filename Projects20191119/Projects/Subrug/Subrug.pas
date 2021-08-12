{$v-}

Unit SuBrug;

Interface

Uses
  SysUtils,
  SuTypGer,
  Vcl.Forms,
  StdCtrls,
  Windows,
  Dialogs,
  Graphics,
  Consts,
  Controls,
  Printers,
  DB,
  Classes,
  Pilha,
  zLib,
  ShlObj, System.Variants,
  Vcl.Grids;

Const
  BufSize = 1024*1024*400;
  BufCmpSize = 1024*1024*1;

Type
//  typBuffer = Array[1..BufCmpSize] Of Char;

  xArq = Class
         Leitura,
         Aberto : Boolean;
         Arq : TFileStream;
         I,
         IndPos,
         IndLer,
         TamBufLeitura : Integer;
         Buf : Packed Array[1..BufSize] of Ansichar;
         Nome : String;
         CrLf : AnsiString;
         Private
         { Private declarations }
           Procedure Lebuffer;

         Public
         { Public declarations }
           Constructor Create;
           Procedure xAssignFile(xNome : String);
           Function xReset : Boolean;
           Function xAppend : Boolean;
           Function xReWrite : Boolean;
           Procedure xReadLn(Var xLinha : AnsiString);
           Procedure xWriteLn(Var xLinha : AnsiString);
           Function xEof : Boolean;
           Procedure xCloseFile;
         End;

Function SortCompare(List : TStringList; Index1, Index2 : Integer) : Integer;

Function SortCompareDesc(List : TStringList; Index1, Index2 : Integer) : Integer;

Function ObtemCodNum(Item : String) : String;

Function LimpaNomArq(NomeArq : String) : String;

Function TrocaExt(StrIn,Ext : String) : String;

Procedure TrocaVPP(Var Buf; Tam : byte);

Function ConvStrNull(StrIn : String) : PChar;

Function SeDiretorio(Nome : String) : String;

Function SeArquivoComExt(Nome : String) : String;

Function SeArquivoSemExt(Nome : String) : String;

function formataFloatVirgulaVirgula(mascara,valor : String) : String;
function formataFloatVirgulaPonto(mascara,valor : String) : String;
function formataFloatPontoVirgula(mascara,valor : String) : String;
function formataFloatPontoPonto(mascara,valor : String) : String;
function formataFloatVirgula(mascara : String; valor : Extended) : String;
function formataFloatPonto(mascara : String; valor : Extended) : String;

(*****************************************************************************)
(* Imprime campo inteiro ou AnsiString formatando A direita ou esquerda          *)
(*****************************************************************************)

Function SeImpRel(PiParImp : String;
                  PiTipAli : Char;
                  PiTamImp : integer) : String;

Function SeEdiCgc(PiParImp : String) : String;

{-----------------------------------------------------------------------------;
;      SeEdiInt                                                               ;
;-----------------------------------------------------------------------------;
;                                                                             ;
;    DESCRICAO:   funcao que edita valores inteiros                           ;
;                                                                             ;
;      PARAMETROS: PiTipEdi = 1 alinha A direita justificando com Brancos     ;
;                  = 2 alinha A esquerda justificando com Brancos             ;
;                  = 3 alinha A direita justif. com Brancos separando com .   ;
;                  = 4 alinha A esquerda justif. com Brancos separan com .    ;
;                  = 5 alinha A direita justificando com Zeros                ;                                          ;
;                                                                             ;
;      RETORNA:   AnsiString com o Valor editado                                  ;
;                                                                             ;
;-----------------------------------------------------------------------------}

Function SeEdiInt(PiTipEdi : Integer;
                  PiTamEdi : Integer;
                  PiValEdi : Integer) : String;


{ Devolve uma AnsiString de tamanho Pitam com PiChar caracteres }

//Function StrChar(PiChar : AnsiChar;          usar StringOfChar
  //               PiTam  : integer) : TgStr080;

Function SeTiraBranco(PiStr : String) : String;

Function SeTiraPonto(PiStr : String) : String;

Function SeTiraZeroDoInicio(PiStr : String) : String;

Function SeNumeric(PiStr : String; PiCompare : TSysCharSet) : Boolean;

Procedure CheckMem(BytesAlloc : Integer);

Function DecrementaAno(Ano : String) : String;

Procedure MoveString(StrToMove : AnsiString; Var Destino; Tam : Integer);

Function TrocaBrancoPorZero(StrToMove : String) : String;

Function InputPassQuery(Const ACaption, APrompt: String; Var Value: String): Boolean;

Function InputPassBox(Const ACaption, APrompt, ADefault: String): String;

Procedure PrintBitmap(Bitmap: TBitmap; X, Y: Integer);

Function GetCurrentUserName : String;

Function GetCurrentComputerName : String;

Procedure ListBoxDelDuplicados(Var ListBox : TListBox);

Procedure ListBoxCopyMove(Const Modo : String; Var ListBoxDe, ListBoxPara : TListBox; Todos : Boolean);

Procedure ListBoxDelete(Var ListBox : TListBox);

Function ColetaDiretorioTemporario : String;

// Funções para conversão de expressões in-fixas para pós-fixas (notação polonesa reversa)
function obtemPrioridade(caractere : String) : Integer;
function ehOperando(caractere : String) : boolean;
function ehOperador(caractere : String) : boolean;
function avaliaExpressao(expressao : String) : String; // Gera polonesa

// XML
function dataSetToXML(var dataSet : TDataset; limite : integer): String; // O inverso não é necessário basta utilizar ClientDataSet.XMLData := XML

// Comprime e descomprime conteúdo de AnsiString e retorna Hexa ao invés de binário
function compressStringReturnHex(str : AnsiString): AnsiString; // Passa AnsiString retorna hexa
function deCompressHexReturnString(str : AnsiString): AnsiString; // Passa hexa retorna AnsiString

// Conversão de valores
function stringParaInteiro(valor : String) : integer;

// Executa um processo e aguarda seu término antes de retornar o controle para o programa
function ExecAndWait(AProgram : String) : BOOLEAN;

function BrowseForFolder(szCurrent : String; Handle : HWND) : String;

procedure SendKeys(const S: Byte);

Type
  TFileList = Class(TObject)
              Mask : String;
              Count,
              FileType : Integer;
              Items : TStringList;
              Procedure Init;
              Procedure Update;
              End;

Implementation

Constructor xArq.Create;
Begin
Inherited Create;
Aberto := False;
End;

Procedure xArq.xAssignFile(xNome : String);
Begin
Nome := xNome;
IndPos := 1;
IndLer := 1;
CrLf := #13#10;
End;

Function xArq.xReset : Boolean;
Begin
Result := True;
Leitura := True;
Try
  Arq := TFileStream.Create(Nome, fmOpenRead or fmShareExclusive);
  Aberto := True;
Except
  Result := False;
  End;
End;

Function xArq.xAppend : Boolean;
Begin
Result := True;
Leitura := False;
Try
  Arq := TFileStream.Create(Nome, fmOpenWrite or fmShareExclusive);
  Arq.Seek(Arq.Size, soBeginning);
  Aberto := True;
Except
  Result := False;
  End;
End;

Function xArq.xReWrite : Boolean;
Begin
Result := True;
Leitura := False;
Try
  Arq := TFileStream.Create(Nome, fmCreate or fmShareExclusive);
  Aberto := True;
Except
  Result := False;
  End;
End;

Procedure xArq.Lebuffer;
begin

FillChar(Buf, SizeOf(Buf), #0);

if BufSize > (Arq.Size-Arq.Position) then
  TamBufLeitura := (Arq.Size-Arq.Position)
else
  TamBufLeitura := BufSize;

Arq.ReadBuffer(Buf, TamBufLeitura);

IndPos := TamBufLeitura;
end;

Procedure xArq.xReadLn(Var xLinha : AnsiString);

Begin
if IndPos = 1 Then
  LeBuffer;

I := IndLer;

While I <= TamBufLeitura do
  begin
//  If Buf[I] <> #13 Then       // I Think This Is Not Necessary...
  If Buf[I] <> #10 Then // Posiciona o cursor no fim da linha ou do pedaço
  else
    Break;
  Inc(I);
  end;

xLinha := '';
If Buf[I] = #10 Then
  SetLength(xLinha, (I-2)-IndLer+1)    // Linha perfeita, volta 2  -> Quando sai pelo lf não soma 1 ao I
else
If Buf[I] = #13 Then
  SetLength(xLinha, (I-1)-IndLer)    // Última linha só com o cr, volta 1
else
  SetLength(xLinha, I-IndLer);       // Última linha sem crlf, não precisa voltar

Move(Buf[IndLer], xLinha[1], Length(xLinha));
IndLer := I+1;

If I >= TamBufLeitura then
  begin

  If Arq.Position >= Arq.Size Then   // Coincidiu o fim do buffer com o fim do arquivo, última linha montada é a última, volta
    Exit
  else
    begin
    If Buf[I-1] = #10 Then            // Tem mais para ler, mas coincidiu o fim do buffer com o fim de uma linha;
      begin
      LeBuffer;
      IndLer := 1;
      Exit;
      end
    else
    If Buf[I-1] = #13 Then
      begin
      LeBuffer;                     // Tem uma linha válida no buffer, mas o lf ficou para ser lido e pode ser o último caractere do arquivo a ser lido ou não...
      IndLer := 2;
      end
    else
      begin
      LeBuffer;
      IndLer := 1;
      I := 1;
      While I <= TamBufLeitura do
        begin
        If Buf[I] <> #13 Then
          If Buf[I] <> #10 Then
            xLinha := xLinha + Buf[I]
          else
            Break;   // Fim da nova primeira linha do buffer
        Inc(I);
        end;
      IndLer := I+1;
      end;
    end;
  end;
End;

Procedure xArq.xWriteLn(Var xLinha : AnsiString);
Begin
If (IndPos + Length(xLinha) + 2) > BufSize Then
  Begin
  Arq.WriteBuffer(Buf, IndPos-1);
  FillChar(Buf, SizeOf(Buf), #0);
  IndPos := 1;
  End;
Move(xLinha[1],Buf[IndPos],Length(xLinha));
Inc(IndPos,Length(xLinha));
Move(CrLf[1],Buf[IndPos], 2);
Inc(IndPos, 2);
End;

Function xArq.xEof : Boolean;
Begin
Result := False;
if (Arq.Position >= Arq.Size) and (I >= TamBufLeitura) Then
  Result := True;
End;

Procedure xArq.xCloseFile;
Begin
If Not Leitura Then             // Não abriu para leitura, descarrega o último buffer...
  If IndPos > 1 Then
    Begin
    Arq.WriteBuffer(Buf, IndPos-1);
    IndPos := 1;
    End;
Arq.Free;
Aberto := False;
End;

Procedure TFileList.Init;
Begin
Mask := '';
Count := 0;
FileType := 0;
Items := TStringList.Create;
End;

Procedure TFileList.Update;
Var
  SearchRec : TSearchRec;
Begin
Items.Sorted := False;
Count := 0;
If FindFirst(Mask, FileType, SearchRec) = 0 Then
  Repeat
    Inc(Count);
    Items.Add(SearchRec.Name);
  Until FindNext(SearchRec) <> 0;
SysUtils.FindClose(SearchRec);  
Items.Sorted := True;
End;

function BrowseDialogCallBack
  (Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM):
  integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
		if (lpData <> Null) then
      SendMessage(Wnd, BFFM_SETSELECTION, 1, lpData);

  Result := 0;
end; (*BrowseDialogCallBack*)

function BrowseForFolder(szCurrent : String; Handle : HWND) : String;
var
  BrowseInfo : TBrowseInfo; {browse info structure for the API function call}
  PIDL : PItemIDList; {a PIDL, the storage method for paths used by Shell}
  SelectedPath : array[0..MAX_PATH] of Char; {the buffer where the result will be returned}

begin
  Result := '';
   { initialize TBrowseInfo structure to nulls (0) }
  FillChar(BrowseInfo,SizeOf(BrowseInfo),#0);
  BrowseInfo.hwndOwner := Handle; {Form1.Handle, the default}
  BrowseInfo.pszDisplayName := @SelectedPath[0]; {buffer address for API to store result}
  BrowseInfo.lpszTitle := 'Selecione um diretório';
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS; {only file system folders}
  BrowseInfo.lpfn := BrowseDialogCallBack;
  BrowseInfo.lParam := LPARAM(szCurrent);

   { show the folder browser and return the result to the PIDL itemlist }
  PIDL := SHBrowseForFolder(BrowseInfo);

   { get selected directory from the itemlist and include the full path}
  if Assigned(PIDL) then
    begin
    if SHGetPathFromIDList(PIDL, SelectedPath) then;
    GlobalFreePtr(PIDL);
    end;
  Result := (SelectedPath);
end;

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

Function SortCompare(List : TStringList; Index1, Index2 : Integer) : Integer;
Begin
If List[Index1] < List[Index2] Then
  Result := (-1)
Else
If List[Index1] > List[Index2] Then
  Result := (1)
Else
  Result := (0);
End;

Function SortCompareDesc(List : TStringList; Index1, Index2 : Integer) : Integer;
Begin
If List[Index1] > List[Index2] Then
  Result := (-1)
Else
If List[Index1] < List[Index2] Then
  Result := (1)
Else
  Result := (0);
End;

Function ObtemCodNum(Item : String) : String;
Var
  I : Integer;
Begin
Result := '';
If Item <> '' Then
  Begin
  Result := Item.Chars[0];
  For I := 1 to Length(Item)-1 Do
    If CharInSet(Item[I], ['0'..'9']) Then
      Result := Result + Item[I];
  End;
End;

Function LimpaNomArq;

Begin
While Pos('*',NomeArq) <> 0 Do
  NomeArq[Pos('*',NomeArq)] := '_';
While Pos('/',NomeArq) <> 0 Do
  NomeArq[Pos('/',NomeArq)] := '_';
While Pos('\',NomeArq) <> 0 Do
  NomeArq[Pos('\',NomeArq)] := '_';
While Pos(':',NomeArq) <> 0 Do
  NomeArq[Pos(':',NomeArq)] := '_';
While Pos('?',NomeArq) <> 0 Do
  NomeArq[Pos('?',NomeArq)] := '_';
While Pos('"',NomeArq) <> 0 Do
  NomeArq[Pos('"',NomeArq)] := '_';
While Pos('>',NomeArq) <> 0 Do
  NomeArq[Pos('>',NomeArq)] := '_';
While Pos('<',NomeArq) <> 0 Do
  NomeArq[Pos('<',NomeArq)] := '_';
While Pos('|',NomeArq) <> 0 Do
  NomeArq[Pos('|',NomeArq)] := '_';
While Pos('.',NomeArq) <> 0 Do      // Ponto é válido, porém estamos limitando a presença de um único . para a extensão
  NomeArq[Pos('.',NomeArq)] := '_';
Result := NomeArq;
End;

Function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

Function TrocaExt(StrIn,Ext : String) : String;

var
  I : byte;

begin
I := StrIn.LastIndexOf('.');
if I <> 0 then
  TrocaExt := StrIn.Substring(0,I+1) + Ext
else
  TrocaExt := StrIn + '.' + Ext;
end;

Procedure TrocaVPP;

Var
  Buff : TgArr1020 Absolute Buf;
  I : integer;

Begin
For I := 1 To Tam Do
  If Buff[I] = ',' Then
    Buff[I] := '.';
End;

function ConvStrNull(StrIn : String) : PChar;

var
  Destino : Array[0..1000] of Char;

begin
StrPCopy(Destino,StrIn);
ConvStrNull := Destino;
end;

function SeDiretorio;

var
  StrAux : String;

begin
StrAux := Nome;
While (StrAux[Length(StrAux)] <> '\') and (Length(StrAux) > 0) do
  begin
  Delete(StrAux,Length(StrAux),1);
  Nome[1] := Nome[1];
  end;
SeDiretorio := StrAux;
end;

function SeArquivoComExt;

var
  StrAux : String;
begin
StrAux := Nome;
while Pos('\',StrAux) <> 0 do
  Delete(StrAux,1,1);
SeArquivoComExt := StrAux;
end;

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

function SeImpRel;

begin
if Length(PiParImp) > PiTamImp then
  begin
  SeImpRel := StringOfChar('*', PiTamImp);
  Exit
  end;
if UpCase(PiTipAli) = 'D' then
  SeImpRel := StringOfChar(' ', PiTamImp - Length(PiParImp)) + PiParImp
else
  SeImpRel := PiParImp + StringOfChar(' ', PiTamImp - Length(PiParImp));
end;

function SeEdiCgc;

var
  Posic : Byte;
begin
Posic := Pos('.',PiParImp);
While Posic <> 0 do
  begin
  Delete(PiParImp,Posic,1);
  Posic := Pos('.',PiParImp);
  end;
Posic := Pos(' ',PiParImp);
While Posic <> 0 do
  begin
  Delete(PiParImp,Posic,1);
  Posic := Pos(' ',PiParImp);
  end;
While Length(PiParImp) < 11 do
  PiParImp := ' ' + PiParImp;
PiParImp := Copy(PiParImp,1,3) + '.' + Copy(PiParImp,4,3) + '.' + Copy(PiParImp,7,3) + '/' +
            Copy(PiParImp,10,2);
While CharInSet(PiParImp[1], ['0','.']) do
  Delete(PiParImp,1,1);
SeEdiCgc := PiParImp;
end;

function SeEdiInt;

var
  VwStr013 : String;
  VwGurPos,
  VwVa1Aux : Integer;

begin
//Str(PiValEdi:10, VwStr013);
VwStr013 := IntToStr(PiValEdi);
VwStr013 := VwStr013 + StringOfChar(' ', 10-Length(VwStr013));
if PiTipEdi in [1,2,5] then
  VwStr013 := '   ' + VwStr013
else
  begin
  VwStr013 := Copy(VwStr013,1,1) + '.' + Copy(VwStr013,2,3) +
              '.' + Copy(VwStr013,5,3) + '.' + Copy(VwStr013,8,3);
  VwVa1Aux := 1;
  while (((VwStr013[VwVa1Aux] = ' ')  or
          (VwStr013[VwVa1Aux] = '.')) and
          (VwVa1Aux <> 10))           do
    begin
    VwStr013[VwVa1Aux] := ' ';
    Inc(VwVa1Aux);
    end;
  SetLength(VwStr013, 13); //[0] := #13;
  end;
VwGurPos := Pos(' ',VwStr013);
while VwGurPos <> 0 do
  begin
  Delete(VwStr013,VwGurPos,1);
  VwGurPos := Pos(' ',VwStr013)
  end;
if Length(VwStr013) > PiTamEdi then
  SeEdiInt := StringOfChar('*',PiTamEdi)
else
  if PiTipEdi = 5 then
    if PiValEdi < 0 then
      SeEdiInt := '-' + StringOfChar('0',PiTamEdi - Length(VwStr013) -1) +
                  Copy(VwStr013,2,Length(VwStr013)-1)
    else
      SeEdiInt := StringOfChar('0',PiTamEdi - Length(VwStr013)) + VwStr013
  else
    if PiTipEdi in [1,3] then
      SeEdiInt := StringOfChar(' ',PiTamEdi - Length(VwStr013)) + VwStr013
    else
      SeEdiInt := VwStr013 + StringOfChar(' ',PiTamEdi - Length(VwStr013));
end;

{function StrChar;

var
  StrAux : TgStr080;

begin
FillChar(StrAux[1], PiTam, PiChar);
//StrAux[0] := Chr(PiTam);
SetLength(StrAux, PiTam);
StrChar := StrAux;
end;}

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

Function SeTiraPonto;
Var
  Posic : Integer;
Begin
Posic := Pos('.',PiStr);
While Posic <> 0 Do
  Begin
  Delete(PiStr,Posic,1);
  Posic := Pos('.',PiStr);
  End;
SeTiraPonto := PiStr;
End;

function SeTiraZeroDoInicio(PiStr : String) : String;
begin
While (PiStr.Chars[0] = '0') and (Length(PiStr) <> 0) do
  PiStr := PiStr.Remove(0,1);
SeTiraZeroDoInicio := PiStr;
end;

Function SeNumeric;
Var
  I : byte;
Begin
SeNumeric := true;
For I := 0 To Length(PiStr)-1 Do
  If Not CharInSet(PiStr.Chars[I], PiCompare) Then //['0'..'9','.',',']) then
    Begin
    SeNumeric := false;
    Exit;
    End;
End;

Procedure CheckMem(BytesAlloc : LongInt);
var
  Teste : Pointer;
begin
Teste := nil;
try
  GetMem(Teste,BytesAlloc);
Except
  on EOutOfMemory do
    begin
    ShowMessage('Sem Memória!');
    Application.Terminate;
    end;
  end; {try}
FreeMem(Teste);
end;

Function DecrementaAno;

Begin
if Ano = '00' then
  Ano := '99'
else
  Ano := IntToStr(StrToInt(Ano)-1);

if Length(Ano) = 1 then
  DecrementaAno := '0' + Ano
else
  DecrementaAno := Ano;
End;

Procedure MoveString;

begin
Move(StrToMove[1],Destino,Tam);
end;

Function TrocaBrancoPorZero;
var
  I : Integer;
begin
Result := StrToMove;
For I := 1 to Length(Result) do
  if Result[I] = ' ' then
    Result[I] := '0';
end;

Function InputPassQuery(const ACaption, APrompt: String; var Value: String): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      ClientHeight := MulDiv(63, DialogUnits.Y, 8);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        AutoSize := True;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Caption := APrompt;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := MulDiv(19, DialogUnits.Y, 8);
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        PassWordChar := '*';  // Esta é a única diferença em relação ao original ....
        SelectAll;
      end;
      ButtonTop := MulDiv(41, DialogUnits.Y, 8);
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgCancel;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function InputPassBox(const ACaption, APrompt, ADefault: String): String;
begin
  Result := ADefault;
  InputPassQuery(ACaption, APrompt, Result);
end;

Procedure PrintBitmap(Bitmap: TBitmap; X, Y: Integer);
Var
  Info: PBitmapInfo;
  Image: Pointer;
  InfoSize,
  ImageSize : Cardinal;
  ResoX,
  ResoY : Integer;
  AcertoY : Integer;
Begin
//Info := Nil;
//Image := Nil;
//If (Info = Nil) Then
//  If Image = Nil Then;

With Bitmap Do
  Begin
    GetDIBSizes(Handle, InfoSize, ImageSize);
{    Info := MemAlloc(InfoSize); }
    GetMem(Info,InfoSize);
    Try
{      Image := MemAlloc(ImageSize); }
      GetMem(Image,ImageSize);
      Try
        GetDIB(Handle, Palette, Info^, Image^);

        With Info^.bmiHeader Do
          Begin
          ResoX := Printer.Canvas.ClipRect.Right;
          ResoY := Printer.Canvas.ClipRect.Bottom;
          If ResoX > Width Then
            Begin
//            Width := ResoX;
//            Height := ResoY;
            AcertoY := 220 - ((Width * 100) Div ResoX); // O certo seria 200, mas para compensar perdas + 10%
            ResoY := ((Height * AcertoY) Div 100);
            End;

          StretchDIBits(Printer.Canvas.Handle, X, Y, ResoX, ResoY, 0, 0, Width, Height,
                        Image, Info^, DIB_RGB_COLORS, SRCCOPY);
          End; // Width
      Finally
//        If Image <> Nil Then
        FreeMem(Image, ImageSize);
      End;
    Finally
//      If Info <> Nil Then
      FreeMem(Info, InfoSize);
    End;
  End;
End;

Function GetCurrentUserName : String;
Var
  Len : Cardinal;
Begin
Len := 255;  { arbitrary length to allocate for username AnsiString, plus one for null terminator }
SetLength(Result, Len - 1); { set the length }
If GetUserName(PChar(Result), Len) Then  { get the username }
  SetLength(Result, Len - 1) { set the exact length if it succeeded } // no tamanho o null está incluído
Else
  RaiseLastOSError; { raise exception if it failed }
End;

Function GetCurrentComputerName : String;
Var
  Len : Cardinal;
Begin
Len := 255;  { arbitrary length to allocate computername AnsiString, plus one for null terminator }
SetLength(Result, Len - 1); { set the length }
If GetComputerName(PChar(Result), Len) Then  { get the computername }
  SetLength(Result, Len) { set the exact length if it succeeded }    // no tamanho o null NÃO está incluído
Else
  RaiseLastOSError; { raise exception if it failed }
End;

Procedure ListBoxDelDuplicados;
Var
  I, Tot : Integer;
Begin
//ListBox.Sorted := False;
I := 0;
Tot := ListBox.Items.Count - 2;
While I <= Tot Do
  If ListBox.Items[I] = ListBox.Items[I+1] Then
    Begin
    ListBox.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);
ListBox.Sorted := True;
ListBox.MultiSelect := True;
ListBox.ExtendedSelect := True;
End;

Procedure ListBoxCopyMove(Const Modo : String; Var ListBoxDe, ListBoxPara : TListBox; Todos : Boolean);
Var
  I, Tot : Integer;
Begin
I := 0;
Tot := ListBoxDe.Items.Count - 1;
//ListBoxPara.Sorted := False;
While I <= Tot Do
  Begin                       // Neste botão todos os usuários são adicionados
  If (ListBoxDe.Selected[I]) Or (Todos) Then
    Begin
    ListBoxPara.Items.Add(ListBoxDe.Items[I]);
    If Modo = 'Move' Then
      ListBoxDe.Items.Delete(I)
    Else
      Begin // Nenhuma ação necessária se o modo é copiar
      End;
    Dec(Tot);
    End
  Else
    Inc(I);
  End;
ListBoxPara.Sorted := True;
End;

Procedure ListBoxDelete(Var ListBox : TListBox);
Var
  I, Tot : Integer;
Begin
//ListBox.Sorted := False;
I := 0;
Tot := ListBox.Items.Count - 1;
While I <= Tot Do
  If ListBox.Selected[I] Then
    Begin
    ListBox.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);
ListBox.Sorted := True;
End;

// Obtém a prioridade do elemento na expressão
function obtemPrioridade(caractere : String) : Integer;
begin
result := 0;
if caractere = '(' then
  result := 1
else if (caractere[1] = '+') or (caractere[1] = '-') then
  result := 2
else if (caractere[1] = '*') or (caractere[1] = '/') then
  result := 3
else if caractere[1] = '^' then
  result := 4;
end;

// Testa se o caractere é um operando
function ehOperando(caractere : String) : boolean;
begin
result := (pos(caractere, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') > 0);
end;

// Testa se o caractere é um operador
function ehOperador(caractere : String) : boolean;
begin
result := (pos(caractere, '+-/*^') > 0);
end;

// Analisa expressão infixa e retona expressão pós-fixa
function avaliaExpressao(expressao : String) : String;
var
  i,
  prioridade : integer;
  item : String;
  pilha : TPilha;
begin
result := '';
pilha := TPilha.Create(nil);
pilha.clear;
for i := 1 to length(expressao) do
  begin
  if ehOperando(expressao[i]) then
    result := result + expressao[i]
  else if ehOperador(expressao[i]) then
    begin
    prioridade := obtemPrioridade(expressao[i]);
    while (pilha.count > 0) and (obtemPrioridade(pilha.peek) > prioridade) do
      result := result + pilha.pop;
    pilha.push(expressao[i]);
    end
  else if expressao[i] = '(' then
    pilha.push(expressao[i])
  else if expressao[i] = ')' then
    begin
    item := pilha.pop;
    while (item <> '(') do
      begin
      result := result + item;
      item := pilha.pop;
      end;
    end;
  end;
while (pilha.count > 0) do
  result := result + pilha.pop;
pilha.Free;
end;

function formataFloatVirgulaVirgula(mascara,valor : String) : String;
var
  vlr : Extended;
  fSettings : tFormatSettings;
begin
fSettings.decimalSeparator := ',';
vlr := strToFloat(trim(valor));
result := formatFloat(mascara,vlr);
end;

function formataFloatVirgulaPonto(mascara,valor : String) : String;
var
  vlr : Extended;
  fSettings : tFormatSettings;
begin
fSettings.decimalSeparator := ',';
vlr := strToFloat(trim(valor));
fSettings.decimalSeparator := '.';
result := formatFloat(mascara,vlr);
end;

function formataFloatPontoVirgula(mascara,valor : String) : String;
var
  vlr : Extended;
  fSettings : tFormatSettings;
begin
fSettings.decimalSeparator := '.';
vlr := strToFloat(trim(valor));
fSettings.decimalSeparator := ',';
result := formatFloat(mascara,vlr);
end;

function formataFloatPontoPonto(mascara,valor : String) : String;
var
  vlr : Extended;
  fSettings : tFormatSettings;
begin
fSettings.decimalSeparator := '.';
vlr := strToFloat(trim(valor));
result := formatFloat(mascara,vlr);
end;

function formataFloatVirgula(mascara : String; valor : Extended) : String;
var
  fSettings : tFormatSettings;
begin
fSettings.decimalSeparator := ',';
result := formatFloat(mascara,valor);
end;

function formataFloatPonto(mascara : String; valor : Extended) : String;
var
  fSettings : tFormatSettings;
begin
fSettings.decimalSeparator := '.';
result := formatFloat(mascara,valor);
end;

function dataSetToXML;
var
  i,j : integer;
begin
j := 0;
// GERAÇÃO DO XML COMPATÍVEL COM O CLIENTDATASET
try
  result := '<?xml version="1.0" ?><DATAPACKET Version="2.0"><METADATA><FIELDS>';
  for i := 0 to dataSet.FieldCount-1 do
    result := result + '<FIELD attrname="'+lowerCase(dataSet.Fields[i].FieldName)+'" fieldtype="AnsiString" WIDTH="5" />';
  result := result + '</FIELDS><PARAMS /></METADATA><ROWDATA>';
  while not dataSet.Eof do
    begin
    result := result + '<ROW ';
    for i := 0 to dataSet.FieldCount-1 do
      result := result + lowerCase(dataSet.Fields[i].FieldName) + '="' +
                dataSet.Fields[i].AsString + '" ';
    result := result + '/>';
    dataSet.Next;
    inc(j);
    if (limite > 0) and (j > limite) then
      break;
    end;
  result := result + '</ROWDATA><METADATA><FIELDS>';
  for i := 0 to dataSet.FieldCount-1 do
    result := result + '<FIELD attrname="'+lowerCase(dataSet.Fields[i].FieldName)+'" fieldtype="AnsiString" WIDTH="5" />';
  result := result + '</FIELDS><PARAMS /></METADATA><ROWDATA /></DATAPACKET>';
except
  result := '<?xml version="1.0" ?><DATAPACKET Version="2.0"><METADATA /></DATAPACKET>';
end;
end;

//Var HexBuf : Ansistring;

function compressStringReturnHex(str : AnsiString): AnsiString;
var
  outBuffer : Pointer;
  outSize : Integer;
begin
ZCompress(PAnsiChar(str), Length(str), outBuffer, outSize, zcMax);
SetLength(Result, outSize*2);
binToHex(outBuffer, PAnsiChar(Result), outSize); // Converte pra hexa
end;

function deCompressHexReturnString(str : AnsiString): AnsiString;
var
  I, Tam : Integer;
  Buffer : Pointer;
  outBuffer : Pointer;
  outSize : Integer;
begin
try
  Tam := Length(str) div 2;
  GetMem(Buffer, Tam);

  for I := 0 to Length(str) do
    if (str[I] >= 'A') and (str[I] <= 'Z') then
      Inc(str[I], 32);

  hexToBin(PAnsiChar(str), Buffer, Tam); // Converte pra bin

  zDecompress(Buffer, Tam, outBuffer, outSize); // Descomprime e devolve a AnsiString

  Setlength(Result, outSize);
  Move(outBuffer^, Result[1], outSize);
  FreeMem(Buffer);
  Freemem(outBuffer);
except
end;
end;

function stringParaInteiro;
begin
try
  result := strToInt(valor);
except
  result := 0;
end;

end;

function ExecAndWait (AProgram : String) : BOOLEAN;
var
  StartupInfo : TStartupInfo;
  ProcessInfo : TProcessInformation;
begin
FillChar (StartupInfo, SizeOf(StartupInfo), 0);
StartupInfo.cb := SizeOf(StartupInfo);
Result := CreateProcess(nil, PChar(AProgram), nil, nil, FALSE, 0,
                        nil, nil, StartupInfo, ProcessInfo);
if Result then
  begin
  WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
  CloseHandle(ProcessInfo.hProcess);
  CloseHandle(ProcessInfo.hThread);
  end;
end;

procedure SendKeys(const S: Byte);
begin
    keybd_event(S, MapVirtualKey(S, 0),0, 0);
    keybd_event(S, MapVirtualKey(S, 0), KEYEVENTF_KEYUP, 0);
end;

(*  Para UNICODE
{$POINTERMATH ON}
procedure SendKeys(const S: String);
var
  InputEvents: PInput;
  I, J: Integer;
begin
  if S = '' then Exit;
  GetMem(InputEvents, SizeOf(TInput) * (Length(S) * 2));
  try
    J := 0;
    for I := 1 to Length(S) do
    begin
      InputEvents[J].Itype := INPUT_KEYBOARD;
      InputEvents[J].ki.wVk := 0;
      InputEvents[J].ki.wScan := Ord(S[I]);
      InputEvents[J].ki.dwFlags := KEYEVENTF_UNICODE;
      InputEvents[J].ki.time := 0;
      InputEvents[J].ki.dwExtraInfo := 0;
      Inc(J);
      InputEvents[J].Itype := INPUT_KEYBOARD;
      InputEvents[J].ki.wVk := 0;
      InputEvents[J].ki.wScan := Ord(S[I]);
      InputEvents[J].ki.dwFlags := KEYEVENTF_UNICODE or KEYEVENTF_KEYUP;
      InputEvents[J].ki.time := 0;
      InputEvents[J].ki.dwExtraInfo := 0;
      Inc(J);
    end;
    SendInput(J, InputEvents[0], SizeOf(TInput));
  finally
    FreeMem(InputEvents);
  end;
end;*)


End.
