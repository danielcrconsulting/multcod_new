{$v-}

Unit SuBrug;

Interface

Uses
  SysUtils,
  SuTypGer,
  Forms,
  StdCtrls,
  Windows,
  Dialogs,
  Graphics,
  Consts,
  Controls,
  Printers,
  DB,
  DbTables,
  Bde,
  Classes,
  Pilha,
  zLibEx;

Function SortCompare(List : TStringList; Index1, Index2 : Integer) : Integer;

Function SortCompareDesc(List : TStringList; Index1, Index2 : Integer) : Integer;

Function ObtemCodNum(Item : String) : String;

Function LimpaNomArq(NomeArq : String) : String;

Function TrocaExt(StrIn,Ext : TgStr080) : TgStr080;

Procedure TrocaVPP(Var Buf; Tam : byte);

Function ConvStrNull(StrIn : TgStr255) : PChar;

Function SeDiretorio(Nome : TgStr255) : TgStr080;

Function SeArquivoComExt(Nome : TgStr255) : TgStr255;

Function SeArquivoSemExt(Nome : TgStr255) : TgStr255;

function formataFloat(mascara,valor:string):string; overload;

function formataFloat(mascara:string;valor:double):string; overload;


(*****************************************************************************)
(* Imprime campo inteiro ou string formatando A direita ou esquerda          *)
(*****************************************************************************)

Function SeImpRel(PiParImp : TgStr255;
                  PiTipAli : char;
                  PiTamImp : integer) : TgStr255;

Function SeEdiCgc(PiParImp : TgStr255) : TgStr255;

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
;      RETORNA:   String com o Valor editado                                  ;
;                                                                             ;
;-----------------------------------------------------------------------------}

Function SeEdiInt(PiTipEdi : Integer;
                  PiTamEdi : Integer;
                  PiValEdi : Integer) : String;


{ Devolve uma string de tamanho Pitam com PiChar caracteres }

Function StrChar(PiChar : Char;
                 PiTam  : integer) : TgStr080;

Function SeTiraBranco(PiStr : String) : String;

Function SeTiraZeroDoInicio(PiStr : TgStr255) : TgStr255;

Function SeNumeric(PiStr : TgStr255; PiCompare : SetOfChar) : Boolean;

Procedure CheckMem(BytesAlloc : LongInt);

Function DecrementaAno(Ano : TgStr002) : TgStr002;

Procedure MoveString(StrToMove : TgStr255; Var Destino; Tam : Integer);

Function TrocaBrancoPorZero(StrToMove : TgStr255) : TgStr255;

Function InputPassQuery(Const ACaption, APrompt: String;
  Var Value: String): Boolean;
Function InputPassBox(Const ACaption, APrompt, ADefault: String): String;

Procedure PrintBitmap(Bitmap: TBitmap; X, Y: Integer);

// Example 4: Add a master password to a Paradox table.
// This example uses the following input:
// AddMasterPassword(Table1, 'MyNewPassword')
// The function returns false if the password could not be Added

Function AddMasterPassword(Table: TTable; pswd: String) : Boolean;

//Example 4: Add an index to a dBASE for Windows version table.
//
//This example uses the following input:
//
//  fDbiAddIndex4(Table1);
//
//The procedure is defined as:

Function fDbiAddSecIndex(Tbl: TTable; IName : String; Campo : Integer) : Boolean;

//Return and fill a TStringList with information on the referential integrity. This example uses the following input:
//
//  fDbiGetRIntDesc(OrdersTbl, 1, MyList);
//
//The function is:

Function fDbiGetRIntDesc(Table: TTable; SeqNo: Word; RIntList: TStringList): RINTDesc;

//Add referential integrity between two tables
//
// AddReferentialIntegrity(TableSubGruposDFN, TableGruposDFN, 1, 1, 0,0, 'CdGrupoSubGrupoRI') : Boolean;
//
//The function is:

Function AddReferentialIntegrity(TableDependent, TableMaster : TTable; FD1, FM1, FD2, FM2 : Integer;
                                 RIntName : DBIName) : Boolean;

Function GetCurrentUserName : String;

Function GetCurrentComputerName : String;

Procedure ListBoxDelDuplicados(Var ListBox : TListBox);

Procedure ListBoxCopyMove(Const Modo : String; Var ListBoxDe, ListBoxPara : TListBox; Todos : Boolean);

Procedure ListBoxDelete(Var ListBox : TListBox);

Function ColetaDiretorioTemporario : String;

// Funções para conversão de expressões in-fixas para pós-fixas (notação polonesa reversa)
function obtemPrioridade(caractere : string) : Integer;
function ehOperando(caractere : string) : boolean;
function ehOperador(caractere : string) : boolean;
function avaliaExpressao(expressao : string) : string; // Gera polonesa

// XML
function dataSetToXML(var dataSet : TDataset; limite : integer): string; // O inverso não é necessário basta utilizar ClientDataSet.XMLData := XML

// Comprime e descomprime conteúdo de string e retorna Hexa ao invés de binário
function compressStringReturnHex(str:String): String; // Passa string retorna hexa
function deCompressHexReturnString(str:String): String; // Passa hexa retorna string

// Conversão de valores
function stringParaInteiro(valor:string):integer;

// Executa um processo e aguarda seu término antes de retornar o controle para o programa
function ExecAndWait (AProgram : STRING) : BOOLEAN;


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
  Result := Item[1];
  For I := 2 to Length(Item) Do
    If Item[I] In ['0'..'9'] Then
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

function TrocaExt;

var
  I : byte;

begin
I := Pos('.',StrIn);
if I <> 0 then
  TrocaExt := Copy(StrIn,1,I) + Ext
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

function ConvStrNull(StrIn : TgStr255) : PChar;

var
  Destino : Array[0..1000] of char;

begin
StrPCopy(Destino,StrIn);
ConvStrNull := Destino;
end;

function SeDiretorio;

var
  StrAux : TgStr255;

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
  StrAux : TgStr255;
begin
StrAux := Nome;
while Pos('\',StrAux) <> 0 do
  Delete(StrAux,1,1);
SeArquivoComExt := StrAux;
end;

Function SeArquivoSemExt;

Var
  StrAux : TgStr255;
  Posic : byte;
Begin
StrAux := Nome;
While Pos('\',StrAux) <> 0 Do
  Delete(StrAux,1,1);
Posic := Pos('.',StrAux);
If Posic <> 0 Then
  Delete(StrAux,Posic,Length(StrAux) + 1 - Posic);
SeArquivoSemExt := StrAux;
End;

function SeImpRel;

var
  VwStrAux : TgStr255;
  VwVarAux : integer;

begin
FillChar(VwStrAux[1],255,' ');
VwStrAux := PiParImp;
if Length(PiParImp) > PiTamImp then
  begin
  FillChar(VwStrAux[1],PiTamImp,'*');
  VwStrAux[0] := Chr(PiTamImp);
  SeImpRel := VwStrAux;
  Exit
  end;
if UpCase(PiTipAli) = 'D' then
  begin
  for VwVarAux := 1 to (PiTamImp - Length(VwStrAux)) do
    VwStrAux := ' ' + VwStrAux;
  SeImpRel := VwStrAux;
  end
else
  begin
  VwStrAux := PiParImp;
  VwStrAux[0] := Chr(PiTamImp);
  SeImpRel := VwStrAux;
  end;
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
While PiParImp[1] in ['0','.'] do
  Delete(PiParImp,1,1);
SeEdiCgc := PiParImp;
end;

function SeEdiInt;

var
  VwStr013 : TgStr013;
  VwGurPos,
  VwVa1Aux : Integer;

begin
Str(PiValEdi:10,VwStr013);
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
  VwStr013[0] := #13;
  end;
VwGurPos := Pos(' ',VwStr013);
while VwGurPos <> 0 do
  begin
  Delete(VwStr013,VwGurPos,1);
  VwGurPos := Pos(' ',VwStr013)
  end;
if Length(VwStr013) > PiTamEdi then
  SeEdiInt := StrChar('*',PiTamEdi)
else
  if PiTipEdi = 5 then
    if PiValEdi < 0 then
      SeEdiInt := '-' + StrChar('0',PiTamEdi - Length(VwStr013) -1) +
                  Copy(VwStr013,2,Length(VwStr013)-1)
    else
      SeEdiInt := StrChar('0',PiTamEdi - Length(VwStr013)) + VwStr013
  else
    if PiTipEdi in [1,3] then
      SeEdiInt := StrChar(' ',PiTamEdi - Length(VwStr013)) + VwStr013
    else
      SeEdiInt := VwStr013 + StrChar(' ',PiTamEdi - Length(VwStr013));
end;

function StrChar;

var
  StrAux : TgStr080;

begin
FillChar(StrAux[1], PiTam, PiChar);
StrAux[0] := Chr(PiTam);
StrChar := StrAux;
end;

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

function SeTiraZeroDoInicio(PiStr : TgStr255) : TgStr255;

begin
While (PiStr[1] = '0') and (Length(PiStr) <> 0) do
  Delete(PiStr,1,1);
SeTiraZeroDoInicio := PiStr;
end;

Function SeNumeric;
Var
  I : byte;
Begin
SeNumeric := true;
For I := 1 To Length(PiStr) Do
  If Not (PiStr[I] In PiCompare) Then //['0'..'9','.',',']) then
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

Function InputPassQuery(const ACaption, APrompt: string;
  var Value: string): Boolean;
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

function InputPassBox(const ACaption, APrompt, ADefault: string): string;
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

Function AddMasterPassword(Table: TTable; Pswd: String) : Boolean;

Const
  RESTRUCTURE_TRUE = WordBool(1);
Var
  TblDesc : CRTblDesc;
  hDb     : hDBIDb;
  Props   : CURProps;
Begin

Result := False;

  { Make sure that the table is opened and is exclusive }
Table.Exclusive := True;
Try
  Table.Open;
Except
//  MensErros.Add('Table must be opened in exclusive mode to add passwords');
  Exit;
  End; // try

  { Initialize the table descriptor }

FillChar(TblDesc, SizeOf(CRTblDesc), #0);

  // Get the table properties to determine table type...
Check(DbiGetCursorProps(Table.Handle, Props));

With TblDesc Do
  Begin
  { Place the table name in descriptor }
  StrPCopy(szTblName, Table.TableName);
  { Place the table type in descriptor }
//  StrCopy(szTblType, szPARADOX);
  szTblType := Props.szTableType;
  { Master Password, Password }
  StrPCopy(szPassword, pswd);
  { Set bProtected to True }
  bProtected := RESTRUCTURE_TRUE;
  end;
{ Get the database handle from the cursor handle }
Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
{ Close the table }
Table.Close;

{ Add the master password to the Paradox table }
Check(DbiDoRestructure(hDb, 1, @TblDesc, nil, nil, nil, False));

Result := True; // Retorno Positivo da Função...

end;

Function fDbiAddSecIndex(Tbl: TTable; IName : String; Campo : Integer) : Boolean;

Var
  NewIndex: IDXDesc;
Begin
Result := False;


Tbl.Exclusive := True;
Try
  Tbl.Open;
Except
//  MensErros.Add('Tabela não pode ser aberta exclusivamente, verifique: '+Tbl.TableName);
  Exit;
  End; // Try

StrPCopy(NewIndex.szName,Tbl.DatabaseName+'\'+IName);
NewIndex.iIndexId := 0;
NewIndex.bPrimary := False;
NewIndex.bUnique := False;
NewIndex.bDescending := False;
NewIndex.bMaintained := True;
NewIndex.bSubset := False;
NewIndex.bExpIdx := False;
NewIndex.iFldsInKey := 1;
NewIndex.aiKeyFld[0]:= Campo;
NewIndex.bCaseInsensitive := False;

Check(DbiAddIndex(Tbl.dbhandle, Tbl.handle, PChar(Tbl.TableName), szParadox, NewIndex, nil));

Tbl.Close;

Result := True;
End;

Function fDbiGetRIntDesc(Table: TTable; SeqNo: Word; RIntList: TStringList): RINTDesc;

Var
  ThisTable, OtherTable: String;
  Props: CURProps;
  B : Byte;
Begin
  ThisTable := '';
  OtherTable := '';
  FillChar(Result, sizeof(Result), #0);
  Check(DbiGetCursorProps(Table.Handle, Props));
  If (Props.iRefIntChecks = 0) Then
    If (RIntList <> Nil) Then
      Begin
      RIntList.Add('There are no referential integrity checks on this table');
      Exit;
      End
    Else
      Begin
//      MensErros.Add('There are no referential integrity checks on this table');
      Exit;
      End;
  Check(DbiGetRIntDesc(Table.Handle, SeqNo, @Result));
  If (RIntList <> Nil) Then Begin

    With RIntList Do Begin
      Add(Format('NUMBER=%d', [Result.iRintNum]));
      Add(Format('NAME=%s', [Result.szRintName]));
      case Result.eType of
        rintMASTER: Add('TYPE=MASTER');
        rintDEPENDENT: Add('TYPE=DEPENDENT');
      else
        Add('TYPE=UNKNOWN');
      end;
      Add(Format('OTHER TABLE=%s', [Result.szTblName]));
      case Result.eModOp of
        rintRESTRICT: Add('MODIFY=RESTRICT');

        rintCASCADE: Add('MODIFY=CASCADE');
      else
        Add('MODIFY=UNKNOWN');
      end;
      case Result.eDelOp of
        rintRESTRICT: Add('DELETE=RESTRICT');
        rintCASCADE: Add('DELETE=CASCADE');
      else
        Add('DELETE=UNKNOWN');
      end;
      Add(Format('FIELD COUNT=%d', [Result.iFldCount]));
      for B := 0 to DBIMAXFLDSINKEY do begin
        if (Result.aiThisTabFld[B] <> 0) then begin

          if (B <> 0) then
            ThisTable := Format('%s, %d', [ThisTable, Result.aiThisTabFld[B]])
          else
            ThisTable := IntToStr(Result.aiThisTabFld[B]);
        end
        else
          Break;
      end;
      Add('FIELDS=' + ThisTable);
      for B := 0 to DBIMAXFLDSINKEY do begin
        if (Result.aiOthTabFld[B] <> 0) then begin
          if (B <> 0) then

            OtherTable := Format('%s, %d', [OtherTable, Result.aiOthTabFld[B]])
          else
            OtherTable := IntToStr(Result.aiOthTabFld[B]);
        end
        else
          Break;
      end;
      Add('FIELDS OTHER=' + OtherTable);
    end;
  end;
end;

Function AddReferentialIntegrity(TableDependent, TableMaster : TTable; FD1, FM1, FD2, FM2 : Integer;
                                 RIntName : DBIName) : Boolean;
Var
  TblDesc0 : CRTblDesc;
  hDb0     : hDBIDb;
  auxRIntDesc0 : RINTDesc;
  OpType : CROpType;

Begin
Result := False;

  { Make sure that the table is opened and is exclusive }
TableDependent.Exclusive := True;
Try
  TableDependent.Open;
Except
//  MensErros.Add('TableDependent must be opened in exclusive mode to add RI');
  Exit;
  End; // try

// Dependent

FillChar(auxRintDesc0,SizeOf(auxRintDesc0),#0);
auxRintDesc0.iRintNum := 1;
auxRintDesc0.szRintName := RIntName;
auxRintDesc0.eType := rintDEPENDENT;
FillChar(auxRintDesc0.szTblName,SizeOf(auxRintDesc0.szTblName),' ');
StrPCopy(auxRintDesc0.szTblName, TableMaster.DataBaseName+'\'+TableMaster.TableName);
//StrPCopy(auxRintDesc0.szTblName, TableMaster.TableName);
auxRintDesc0.eModOp := rintRESTRICT;
auxRintDesc0.eDelOp := rintRESTRICT;
If FD2 <> 0 Then
  auxRintDesc0.iFldCount := 2
Else
  auxRintDesc0.iFldCount := 1;
auxRintDesc0.aiThisTabFld[0] := FD1;
auxRintDesc0.aiOthTabFld[0] := FM1;
If FD2 <> 0 Then
  Begin
  auxRintDesc0.aiThisTabFld[1] := FD2;
  auxRintDesc0.aiOthTabFld[1] := FM2;
  End;

  { Initialize the table descriptor }

FillChar(TblDesc0, SizeOf(CRTblDesc), #0);  // Preenche o Table Descriptor com informações básicas

With TblDesc0 Do
  Begin
  { Place the table name in descriptor }
  FillChar(szTblName,SizeOf(szTblName),' ');
  StrPCopy(szTblName, TableDependent.TableName);
  { Place the table type in descriptor }
  StrCopy(szTblType, szPARADOX);
  iRIntCount := 1;
  opType := crADD;
  pecrRIntOp := @opType;
  pRIntDesc := @auxRIntDesc0;

  TblDesc0.bProtected := True; // Mantém a password;

  end;

{ Get the database handle from the cursor handle }
Check(DbiGetObjFromObj(hDBIObj(TableDependent.Handle), objDATABASE, hDBIObj(hDb0)));

{ Close the tables }
TableDependent.Close;
TableMaster.Close;

{ Add the RI to the Dependent Paradox table }
Check(DbiDoRestructure(hDb0, 1, @TblDesc0, nil, nil, nil, False));

Result := True; // Retorno Positivo da Função...
End;

Function GetCurrentUserName : String;
Var
  Len : Cardinal;
Begin
Len := 255;  { arbitrary length to allocate for username string, plus one for null terminator }
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
Len := 255;  { arbitrary length to allocate computername string, plus one for null terminator }
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
result := (pos(caractere, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') > 0);
end;

// Testa se o caractere é um operador
function ehOperador(caractere : string) : boolean;
begin
result := (pos(caractere, '+-/*^') > 0);
end;

// Analisa expressão infixa e retona expressão pós-fixa
function avaliaExpressao(expressao : string) : string;
var
  i,
  prioridade : integer;
  item : string;
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

function formataFloat(mascara,valor:string):string;
var
  oldDecimalSeparator : char;
  vlr : double;
begin
oldDecimalSeparator := decimalSeparator;
decimalSeparator := '.';
vlr := strToFloat(trim(valor));
decimalSeparator := ',';
result := formatFloat(mascara,vlr);
decimalSeparator := oldDecimalSeparator;
end;

function formataFloat(mascara:string;valor:double):string;
var
  oldDecimalSeparator : char;
begin
oldDecimalSeparator := decimalSeparator;
decimalSeparator := ',';
result := formatFloat(mascara,valor);
decimalSeparator := oldDecimalSeparator;
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
    result := result + '<FIELD attrname="'+lowerCase(dataSet.Fields[i].FieldName)+'" fieldtype="string" WIDTH="5" />';
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
    result := result + '<FIELD attrname="'+lowerCase(dataSet.Fields[i].FieldName)+'" fieldtype="string" WIDTH="5" />';
  result := result + '</FIELDS><PARAMS /></METADATA><ROWDATA /></DATAPACKET>';
except
  result := '<?xml version="1.0" ?><DATAPACKET Version="2.0"><METADATA /></DATAPACKET>';
end;
end;


function compressStringReturnHex(str:String): String;
var
  HexBuf : Pointer;
  strCmp : string;
  {
  procedure LogaLocal(mens:string);
  Var
    Arq : TextFile;
    nomeArq : String;
  Begin
  fileMode := fmShareDenyNone;
  nomeArq := extractFilePath(ParamStr(0))+'zCompress';
  forceDirectories(nomeArq);
  nomeArq := nomeArq+'\MulticoldServerLog.'+formatDateTime('yyyymmdd',now)+'.txt';
  AssignFile(Arq,nomeArq);
  If FileExists(nomeArq) Then
    Append(Arq)
  Else
    ReWrite(Arq);
  WriteLn(Arq, formatDateTime('hh:nn:ss ',now)+Mens);
  CloseFile(Arq);
  End;
  }
begin
HexBuf := nil;
try
  strCmp := zCompressStr(str,zcMax); // Comprime
  //getMem(HexBuf,(length(strCmp)*2)+1);
  getMem(HexBuf,(length(strCmp)*2));
  binToHex(pAnsiChar(strCmp), HexBuf, length(strCmp)); // Converte pra hexa
  //setLength(result,(length(strCmp)*2)+1);
  setLength(result,(length(strCmp)*2));
  //move(HexBuf^,result[1],(length(strCmp)*2)+1); // Devolve em Hexa
  move(HexBuf^,result[1],(length(strCmp)*2)); // Devolve em Hexa
  //logaLocal(result);
finally
  freeMem(HexBuf);
end;
end;

function deCompressHexReturnString(str:String): String;
var
  HexBuf : Pointer;
begin
HexBuf := nil;
try
  getMem(HexBuf,length(str));
  hexToBin(pAnsiChar(lowerCase(str)),HexBuf,length(str)); // Converte pra hexa
  setLength(str,(length(str) div 2));
  move(HexBuf^,str[1],length(str));
  result := zDecompressStr(str); // Descomprime e devolve a string
finally
  freeMem(HexBuf);
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

function ExecAndWait (AProgram : STRING) : BOOLEAN;
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


End.
