//        file  VBto_Converter.pas
// This is a part of the VBto Converter (www.vbto.net). Copyright (C) 2005-2018 StressSoft Company Ltd. All rights reserved.

unit VBto_Converter;

Interface

uses  Classes, Windows, Graphics, SysUtils, Variants, StrUtils, Math, Printers,
  ADODB, UITypes;

 function FormatVB(v: LongInt; const vbfmt: String): String; overload;
 function FormatVB(v: Double; const vbfmt: String): String; overload;
 function FormatVB(s: String; const vbfmt: String): String; overload;

 function mStr(b: Boolean): String; overload;
 function mStr(d: LongInt): String; overload;
 function mStr(d: Double): String; overload;
 function mStr(s: String): String; overload;
 function mStr(v: Variant): String; overload;
 function mStr(obj: TObject): String; overload;

 function Hex(h: SmallInt): String; overload;
 function Hex(i: LongInt): String; overload;
 function Hex(d: Double): String; overload;

 function Asc(s: String): LongInt;

// function vbVal(d: Double): Integer; overload;
// function vbVal(const s0: String): Double; overload;
// function vbVal(v: Variant): Double; overload;

// function CDbl(s: String): Double; overload;
// function CDbl(d: Double): Double; Overload;

// var VBtoTSearchRec: TSearchRec;
// function Dir(PathName: String; FileAttrs: Integer): String; overload;
// function Dir(PathName: String): String; overload;
// function Dir(): String; overload;

 function GetDay(const dt: TDateTime): Longint;
 function GetMonth(const dt: TDateTime): Longint;
 function GetYear(const dt: TDateTime): Longint;
 procedure OutputDebugString(sMsg: String); overload;

// procedure ReDim(var arr: TStringList; NewLength: Integer); overload;
// procedure ReDimPreserve(var arr: TStringList; NewLength: Integer); overload;

//=========================================================
type
  VBto_Converter_Printer = class

  protected
    IsBeginDoc: Boolean;
    kk: Single;

    procedure StartDoc();
    function BorlandToVB6(B: Integer): Single;
    function VB6ToBorland(V: Single): Integer;

    function GetCurrentX(): Single;
    function GetCurrentY(): Single;
    procedure SetCurrentX(value: Single);
    procedure SetCurrentY(value: Single);

    function GetFontName(): String;
    procedure SetFontName(const value: String);

    function GetFontSize(): Integer;
    procedure SetFontSize(value: Integer);

    function GetFontBold(): Boolean;
    procedure SetFontBold(value: Boolean);

    function GetFontItalic(): Boolean;
    procedure SetFontItalic(value: Boolean);

    function GetDrawWidth(): Integer;
    procedure SetDrawWidth(value: Integer);

    function GetDrawStyle(): Integer;
    procedure SetDrawStyle(value: Integer);

    function GetPageNumber(): Integer;

  public
    { Public declarations }
    FillStyle: Integer;
    FillColor: TColor;

    constructor Create();

    property CurrentX: Single read GetCurrentX write SetCurrentX;
    property CurrentY: Single read GetCurrentY write SetCurrentY;
    property FontName: String read GetFontName write SetFontName;
    property FontSize: Integer read GetFontSize write SetFontSize;
    property FontBold: Boolean read GetFontBold write SetFontBold;
    property FontItalic: Boolean read GetFontItalic write SetFontItalic;
    property PageNumber: Integer read GetPageNumber;
    property DrawWidth: Integer read GetDrawWidth write SetDrawWidth;
    property DrawStyle: Integer read GetDrawStyle write SetDrawStyle;

    procedure Print(const S: String);
    procedure PSet(x, y: Single; col: TColor=clBlack);
    procedure Line(x1, y1, x2, y2: Single; col: TColor=clBlack);
    procedure LineTo(x2, y2: Single; col: TColor=clBlack);
    procedure Rectangle(x1, y1, x2, y2: Single; col: TColor=clBlack);
    procedure Circle(xC, yC, R: Single; col: TColor=clBlack);
    procedure Arc(xC, yC, R, fiStart, fiEnd: Single; col: TColor=clBlack);
    procedure NewPage();
    procedure EndDoc();
  end;
var VBtoPrinter: VBto_Converter_Printer;


// procedure SetToMid(var Source: string; StartPos: Integer; Value: string; Len: Integer); overload;
// procedure SetToMid(var Source: string; StartPos: Integer; Value: string); overload;

// function LoadPicture(FileName: String): TBitmap;

// procedure DbRefresh(var ds: TADODataSet);

// procedure VBtoADOConnection_Open(var con: TADOConnection; conString: string = '');
// procedure VBtoADODataSet_Open(var rs: TADODataSet; SQL: string; con: TADOConnection; cur: TCursorType; lkType: TADOLockType; cmdType: TCommandType); overload;
// procedure VBtoADODataSet_Open(var rs: TADODataSet; SQL: string; con: TADOConnection; cur: TCursorType; lkType: TADOLockType); overload;
// procedure VBtoADODataSet_Open(var rs: TADODataSet; SQL: string; con: TADOConnection); overload;
// procedure VBtoADODataSet_Open(var rs: TADODataSet; cmd: TADOCommand); overload;
// function  VBtoADODataSet_Open(cmd: TADOCommand): TADODataSet; overload;
// function  VBtoADODataSet_Execute(cmd: TADOCommand): TADODataSet;
// function  CommandTextADOtoVCL(CommandText: string): string;

 procedure VBtoADOFieldSet(var rs: TADODataSet; FieldName:  string;  Value: Variant); overload;
 procedure VBtoADOFieldSet(var rs: TADODataSet; FieldIndex: Integer; Value: Variant); overload;
 procedure VBtoADOFieldSet(var rs: TADOTable; FieldName:  string; Value: Variant); overload;
 procedure VBtoADOFieldSet(var rs: TADOQuery; FieldName:  string; Value: Variant); overload;

 procedure AssignFileAsAppend(var F: TextFile; sFileName: string);

// === External Constants: ===
const vbTextCompare  = 1;
const vbApplicationModal  = 0;
const cdlPDReturnDC  = 256;
const cdlPDNoPageNums  = 8;
const cdlPDAllPages  = 0;
const cdlPDSelection  = 1;


Implementation

  //=========================================================
function FormatVB(v: LongInt; const vbfmt: String): String; overload;
begin
  Result := IntToStr(v);
end;
function FormatVB(v: Double; const vbfmt: String): String; overload;
begin
  Result := FloatToStr(v);
end;
function FormatVB(s: String; const vbfmt: String): String; overload;
begin
  Result := s;
end;

function mStr(b: Boolean): String; overload;
begin
  if (b) then Result := ' True'
  else  Result := ' False';
end;
function mStr(d: LongInt): String; overload;
begin
  Result := IntToStr(d);
  if (d>=0) then Result := ' ' + Result;
end;
function mStr(d: Double): String; overload;
var
  buf: string;
  posComma: Integer;
  fs: TFormatSettings;
begin
  buf := FloatToStr(d);
  fs := TFormatSettings.Create();
  posComma := Pos(fs.DecimalSeparator, buf);
  FreeAndNil(fs);
  if posComma>0 Then buf[posComma] := '.';
  Result := buf;
  if (d>=0) then Result := ' ' + Result;
end;
function mStr(s: String): String; overload;
begin
  Result := mStr(StrToFloat(s));
end;
function mStr(v: Variant): String; overload;
var
  vtype: Integer;
  s: string;
begin
  s := '';
  vtype := (VarType(v) and varTypeMask);
  case vtype of
    varBoolean:  s := IfThen(Boolean(v),'True','False');
    varDouble,
    varCurrency:  s := mStr(Double(v));
    varSmallint,
    varShortInt,
    varInt64,
    varInteger:  s := mStr(Integer(v));
    //varString:  s := mStr(String(v));
    else    s := mStr(String(v));
  end;
  Result := s;
end;
function mStr(obj: TObject): String; overload;
begin
  Result := '?';
end;

function Hex(h: SmallInt): String; overload;
begin
  Result := Format('%x', [h]);
  if (Length(Result)=8) And (LeftStr(Result,4)='FFFF') then Result := RightStr(Result,4);
end;
function Hex(i: LongInt): String; overload;
begin
  Result := Format('%x', [i]);
end;
function Hex(d: Double): String; overload;
begin
  Result := Hex(LongInt(Round(d)));
end;

function Asc(s: String): LongInt;
var
  ch: Char;
begin
  ch := s[1];
  Result := LongInt(ch);
end;

{function vbVal(d: Double): Integer; overload;
begin
  //Result := IfThen(d > 0, Floor(d), Ceil(d));
  Result := Trunc(d);
end; }
{function vbVal(const s0: String): Double; overload;
var
  s, sr: String; d: Double;
  i, Code: Integer;
begin
  s := TrimLeft(s0);
  i := 1;
//  while s[i] = ' ' do
//    Inc(i);

  if Length(s)=0 then begin
    Result := 0;
    Exit;
  end;

  if s[i] = '&' then begin
    Inc(i);
    if (s[i] = 'H') or (s[i] = 'h') then begin
      sr := '0x' + MidStr(s, i+1, 33);
      Val(sr, i, Code);
      Result := i;
      Exit;
    end;
    if (s[i] = 'O') or (s[i] = 'o') then begin
      sr := '0x' + MidStr(s, i+1, 33); //???
      Val(sr, i, Code);
      Result := i;
      Exit;
    end;
  end;

  sr := StringReplace(s, '.', ',', []);  //?

  try
    d := StrToFloat(sr);
  except
    d := 0;
  end;

  Result := d;
end;     }

{function vbVal(v: Variant): Double; overload;
var  d: Double;
begin
  d := StrToFloat(v);
  Result := vbVal(d);
end; }

(*function CDbl(s: String): Double; overload;
begin
  Result := StrToFloat(s);
end;
function CDbl(d: Double): Double; overload;
begin
  Result := d;
end;*)

{function Dir(PathName: String; FileAttrs: Integer): String; overload;
begin
  if FindFirst(PathName, FileAttrs, VBtoTSearchRec) = 0 then begin
    Result := VBtoTSearchRec.Name;
    Exit;
  end;
  Result := '';
end;
function Dir(PathName: String): String; overload;
begin
  Result := Dir(PathName, 0);
end;
function Dir(): String; overload;
begin
  if FindNext(VBtoTSearchRec) = 0 then begin
    Result := VBtoTSearchRec.Name;
    Exit;
  end;
  FindClose(VBtoTSearchRec);
  Result := '';
end;   }

function GetDay(const dt: TDateTime): Longint;
var  Year, Month, Day: Word;
begin
  DecodeDate(dt, Year, Month, Day);
  Result := Day;
end;

function GetMonth(const dt: TDateTime): Longint;
var  Year, Month, Day: Word;
begin
  DecodeDate(dt, Year, Month, Day);
  Result := Month;
end;

function GetYear(const dt: TDateTime): Longint;
var  Year, Month, Day: Word;
begin
  DecodeDate(dt, Year, Month, Day);
  Result := Year;
end;

procedure OutputDebugString(sMsg: String); overload;
begin
  Windows.OutputDebugString(PChar(sMsg));
end;

{procedure ReDim(var arr: TStringList; NewLength: Integer); overload;
begin
  if Assigned(arr) then arr.Clear
  else arr := TStringList.Create;
  while arr.Count < NewLength do arr.Append('');
end; }

(*procedure ReDimPreserve(var arr: TStringList; NewLength: Integer); overload;
begin
  if not Assigned(arr) then arr := TStringList.Create;
  while arr.Count > NewLength do arr.Delete(arr.Count - 1);
  while arr.Count < NewLength do arr.Append('');
end;*)


//=========================================================
constructor VBto_Converter_Printer.Create();
begin
        IsBeginDoc := false;
  FillStyle := 1;
  FillColor := clBlack;
end;

procedure VBto_Converter_Printer.StartDoc();
begin
  If Not IsBeginDoc Then begin
    Printer().BeginDoc();
    IsBeginDoc := true;
    kk := Printer().Canvas.Font.PixelsPerInch / 1440.0;
  end;
end;

function VBto_Converter_Printer.BorlandToVB6(B: Integer): Single;
begin
        Result := B / kk;
end;
function VBto_Converter_Printer.VB6ToBorland(V: Single): Integer;
begin
        Result := Round(V * kk);
end;

function VBto_Converter_Printer.GetCurrentX(): Single;
begin
  StartDoc();
        Result := BorlandToVB6(Printer().Canvas.PenPos.x);
end;
function VBto_Converter_Printer.GetCurrentY(): Single;
begin
  StartDoc();
        Result := BorlandToVB6(Printer().Canvas.PenPos.y);
end;

procedure VBto_Converter_Printer.SetCurrentX(value: Single);
var     Canvas: TCanvas;
begin
  StartDoc();
        Canvas := Printer().Canvas;
        Canvas.MoveTo(VB6ToBorland(value), Canvas.PenPos.y);
end;
procedure VBto_Converter_Printer.SetCurrentY(value: Single);
var     Canvas: TCanvas;
begin
  StartDoc();
        Canvas := Printer().Canvas;
        Canvas.MoveTo(Canvas.PenPos.x, VB6ToBorland(value));
end;

function VBto_Converter_Printer.GetFontName(): String;
begin
  Result := Printer().Canvas.Font.Name;
end;
procedure VBto_Converter_Printer.SetFontName(const value: String);
begin
  Printer().Canvas.Font.Name := value;
end;

function VBto_Converter_Printer.GetFontSize(): Integer;
begin
        Result := Printer().Canvas.Font.Size;
end;
procedure VBto_Converter_Printer.SetFontSize(value: Integer);
begin
        Printer().Canvas.Font.Size := value;
end;

function VBto_Converter_Printer.GetFontBold(): Boolean;
begin
        Result := fsBold in Printer().Canvas.Font.Style;
end;
procedure VBto_Converter_Printer.SetFontBold(value: Boolean);
var  font: TFont;
begin
  font := Printer().Canvas.Font;
  if value Then
                font.Style := font.Style + [fsBold]
        else    font.Style := font.Style - [fsBold];
end;

function VBto_Converter_Printer.GetFontItalic(): Boolean;
begin
        Result := fsItalic in Printer().Canvas.Font.Style;
end;
procedure VBto_Converter_Printer.SetFontItalic(value: Boolean);
var  font: TFont;
begin
  font := Printer().Canvas.Font;
  if value Then
                font.Style := font.Style + [fsItalic]
        else    font.Style := font.Style - [fsItalic];
end;

function VBto_Converter_Printer.GetPageNumber(): Integer;
begin
  StartDoc();
  Result := Printer().PageNumber;
end;


function VBto_Converter_Printer.GetDrawWidth(): Integer;
begin
  StartDoc();
  Result := Printer().Canvas.Pen.Width;
end;
procedure VBto_Converter_Printer.SetDrawWidth(value: Integer);
begin
  StartDoc();
  Printer().Canvas.Pen.Width := value;
end;

function VBto_Converter_Printer.GetDrawStyle(): Integer;
begin
  StartDoc();
  Result := Integer(Printer().Canvas.Pen.Style);
end;
procedure VBto_Converter_Printer.SetDrawStyle(value: Integer);
begin
  StartDoc();
        Printer().Canvas.Pen.Style := TPenStyle(value);
end;


procedure VBto_Converter_Printer.Print(const S: String);
var
  Canvas: TCanvas;
        h: Integer;
begin
  StartDoc();
        Canvas := Printer().Canvas;
  Canvas.TextOut(Canvas.PenPos.x,Canvas.PenPos.y, S);
  h := Canvas.Font.Height;
  if h<0 Then h := -h;
  Canvas.MoveTo(0, Round(Canvas.PenPos.y+h*1.03));
end;

procedure VBto_Converter_Printer.PSet(x, y: Single; col: TColor);
var
        ix,iy: Integer;
  Canvas: TCanvas;
begin
  StartDoc();
        ix := VB6ToBorland(x);
        iy := VB6ToBorland(y);
        Canvas := Printer().Canvas;
  Canvas.Pixels[ix,iy] := col;
  Canvas.MoveTo(ix,iy);
end;

procedure VBto_Converter_Printer.Line(x1, y1, x2, y2: Single; col: TColor);
var  Canvas: TCanvas;
begin
  StartDoc();
        Canvas := Printer().Canvas;
  Canvas.Pen.Color := col;
  Canvas.MoveTo(VB6ToBorland(x1),VB6ToBorland(y1));
  Canvas.LineTo(VB6ToBorland(x2),VB6ToBorland(y2));
end;

procedure VBto_Converter_Printer.LineTo(x2, y2: Single; col: TColor);
var  Canvas: TCanvas;
begin
  StartDoc();
        Canvas := Printer().Canvas;
  Canvas.Pen.Color := col;
  Canvas.LineTo(VB6ToBorland(x2),VB6ToBorland(y2));
end;

procedure VBto_Converter_Printer.Rectangle(x1, y1, x2, y2: Single; col: TColor);
var
        ix2,iy2: Integer;
  Canvas: TCanvas;
begin
  StartDoc();
        ix2 := VB6ToBorland(x2);
        iy2 := VB6ToBorland(y2);
        Canvas := Printer().Canvas;
  Canvas.Pen.Color := col;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(VB6ToBorland(x1),VB6ToBorland(y1), ix2,iy2);
  Canvas.MoveTo(ix2,iy2);
end;

procedure VBto_Converter_Printer.Circle(xC, yC, R: Single; col: TColor);
var
        ix1,iy1, ix2,iy2: Integer;
  Canvas: TCanvas;
begin
  StartDoc();
        ix1 := VB6ToBorland(xC-R);  ix2 := VB6ToBorland(xC+R);
        iy1 := VB6ToBorland(yC-R);  iy2 := VB6ToBorland(yC+R);
        Canvas := Printer().Canvas;
  Canvas.Pen.Color := col;
  Canvas.Brush.Color := FillColor;
  if FillStyle=1 then
          Canvas.Brush.Style := bsClear
        else     Canvas.Brush.Style := bsSolid;
  Canvas.Ellipse(ix1,iy1, ix2,iy2);
end;

procedure VBto_Converter_Printer.Arc(xC, yC, R, fiStart, fiEnd: Single; col: TColor);
var
        ix1,iy1, ix2,iy2, ix3,iy3, ix4,iy4, ixC,iyC: Integer;
  Canvas: TCanvas;
begin
  StartDoc();
        ix1 := VB6ToBorland(xC-R);  ix2 := VB6ToBorland(xC+R);
        iy1 := VB6ToBorland(yC-R);  iy2 := VB6ToBorland(yC+R);
        ixC := VB6ToBorland(xC);
        iyC := VB6ToBorland(yC);
        ix3 := Round(ixC+1000*cos(-fiStart));  ix4 := Round(ixC+1000*cos(-fiEnd));
        iy3 := Round(iyC+1000*sin(-fiStart));  iy4 := Round(iyC+1000*sin(-fiEnd));
        Canvas := Printer().Canvas;
  Canvas.Pen.Color := col;
  Canvas.Brush.Style := bsClear;
  Canvas.Arc(ix1,iy1, ix2,iy2, ix3,iy3, ix4,iy4);
end;

procedure VBto_Converter_Printer.NewPage();
begin
  StartDoc();
  Printer().NewPage();
end;

procedure VBto_Converter_Printer.EndDoc();
begin
  If IsBeginDoc Then begin
    Printer().EndDoc();
    IsBeginDoc := false;
  end;
end;

(*procedure SetToMid(var Source: string; StartPos: Integer; Value: string; Len: Integer); overload;
var
  LeftSubStr, RightSubStr: string;
begin
  LeftSubStr := copy(Source, 0, StartPos - 1);
  RightSubStr := copy(Source, StartPos + Len, Length(Source) - (StartPos + Len - 1));
  Source := LeftSubStr + copy(Value, 0, Len) + RightSubStr;
end;

procedure SetToMid(var Source: string; StartPos: Integer; Value: string); overload;
begin
  SetToMid(Source, StartPos, Value, Length(Value));
end;

function LoadPicture(FileName: String): TBitmap;
var Image: TBitmap;
begin
  Image := TBitmap.Create();
  Image.LoadFromFile(FileName);
  Result := Image;
end;

procedure DbRefresh(var ds: TADODataSet);
begin
  if Length(ds.CommandText) = 0 then Exit;
  ds.Close;
  ds.Open;
end;


procedure VBtoADOConnection_Open(var con: TADOConnection; conString: string); overload;
begin
  if (conString<>'') then
    con.ConnectionString := conString;
  con.LoginPrompt := false;
  con.KeepConnection := false;
  con.Open();
end;

procedure VBtoADODataSet_Open(var rs: TADODataSet; SQL: string; con: TADOConnection; cur: TCursorType; lkType: TADOLockType; cmdType: TCommandType); overload;
begin
  with rs do begin
    Connection := con;
    CursorType := cur;
    LockType := lkType;
    CommandType := cmdType;
    CommandText := SQL;
    Open;
  end;
end;

procedure VBtoADODataSet_Open(var rs: TADODataSet; SQL: string; con: TADOConnection; cur: TCursorType; lkType: TADOLockType); overload;
begin
  with rs do begin
    Connection := con;
    CursorType := cur;
    LockType := lkType;
    CommandText := SQL;
    Open;
  end;
end;

procedure VBtoADODataSet_Open(var rs: TADODataSet; SQL: string; con: TADOConnection); overload;
begin
  with rs do begin
    Connection := con;
    CommandText := SQL;
    Open;
  end;
end;

procedure VBtoADODataSet_Open(var rs: TADODataSet; cmd: TADOCommand);
begin
  rs.CommandText := cmd.CommandText;
  rs.Connection := cmd.Connection;
  rs.Parameters := cmd.Parameters;
  rs.Open;
end;

function VBtoADODataSet_Open(cmd: TADOCommand): TADODataSet;
var
  rs: TADODataSet;
begin
  rs := TADODataSet.Create(nil);
  VBtoADODataSet_Open(rs, cmd);
  Result := rs;
end;

function VBtoADODataSet_Execute(cmd: TADOCommand): TADODataSet;
begin
  Result := VBtoADODataSet_Open(cmd);
end;

function CommandTextADOtoVCL(CommandText: string): string;
var
  i: Integer;
begin
  for i := 0 to Length(CommandText) - 1 do
    if CommandText[i] = '@' then CommandText[i] := ':';
  Result := CommandText;
end;   *)

procedure VBtoADOFieldSet(var rs: TADODataSet; FieldName: string; Value: Variant); overload;
begin
//  rs.Edit;
  rs.FieldByName(FieldName).Value := Value;
//  rs.UpdateRecord;
end;
procedure VBtoADOFieldSet(var rs: TADODataSet; FieldIndex: Integer; Value: Variant); overload;
begin
//  rs.Edit;
  rs.Fields[FieldIndex].Value := Value;
//  rs.UpdateRecord;
end;
procedure VBtoADOFieldSet(var rs: TADOTable; FieldName:  string; Value: Variant); overload;
begin
//  rs.Edit;
  rs.FieldByName(FieldName).Value := Value;
//  rs.UpdateRecord;
end;
procedure VBtoADOFieldSet(var rs: TADOQuery; FieldName:  string; Value: Variant); overload;
begin
//  rs.Edit;
  rs.FieldByName(FieldName).Value := Value;
//  rs.UpdateRecord;
end;

procedure AssignFileAsAppend(var F: TextFile; sFileName: string);
begin
  AssignFile(F, sFileName);
  {$I-}
  Append(F);
  if (IOResult<>0) then Rewrite(F);
  {$I+}
end;


Initialization
 //CoInitialize(nil);
 VBtoPrinter := VBto_Converter_Printer.Create();

Finalization
 //CoUninitialize();

end.
