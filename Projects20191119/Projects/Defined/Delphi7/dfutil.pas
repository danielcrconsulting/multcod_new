
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Misc. Routines                                  }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfutil;

interface

{$WEAKPACKAGEUNIT ON}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, Printers, Menus, ActnList, Registry, jpeg, defstream, dfclasses,
  ComCtrls;

const
  PDF_CBUFSIZE = 98304;

type
  EDFImportError = class(Exception);
  EDFExportError = class(Exception);

  TCharset = set of char;

  procedure dfStretchDraw(Canvas: TCanvas; Rect: TRect; Graphic: TGraphic);
  function  dfGetFontHeight(fontsize,fontPPI: integer): integer;
  function  dfGetFontSize(fontheight,fontPPI: integer): integer;
  function  dfCreateObjectRegion(AObject: TDFObject; Scale: double): HRGN;
  function  dfShiftDown : Boolean;
  function  dfCtrlDown : Boolean;
  function  dfPositiveRect(ARect: TRect): TRect;
  function  dfOnlyAlpha(const S: string): string;
  function  dfOnlyNumeric(const S: string): string;
  function  dfOnlyReal(const S: string): string;
  function  dfNameOnly(const S: string): string;
  function  dfInttoStrZ(value, digits: integer): string;
  function  dfGetFilter(const FilterList: string; const FilterIndex: integer): string;
  function  dfFileNameOnly(const Filename: string): string;
  procedure dfGetRFMMetafile(source: pointer; srcsize: integer; dest: TPicture);
  procedure dfGetRFMBitmap(source: pointer; srcsize: integer; dest: TPicture);
  function  dfLoadFile(Path: String; var Data; MaxSize: Longint): longint;
  function  dfCountSpaces(S: String): integer;
  procedure dfMergeMenu(Source: TPopupMenu; Dest: TMenuItem);
  function  dfSortLeft(Item1, Item2: Pointer): Integer;
  function  dfSortTop(Item1, Item2: Pointer): Integer;
  function  dfPosFromPos(Sub, S : string; Index : smallint): smallint;
  function  dfGetPath: string;
  procedure dfWordWrap(Source: string; Dest: TStrings; ACanvas: TCanvas; ARect: TRect);
  function  dfGetDateFormat: string;
  function  dfFormatToMask(AFormat: string): string;
  function  dfStrtoCRLF(S: string): string;
  function  dfCRLFtoStr(S: string): string;
  function  dfCrypt(S: String): string;
//  function  dfStripBraces(S: String): string;
//  function  dfGetBraces(S: String): string;
  function  dfStripQuotes(S: String): string;
  function  dfCheck: integer;
  procedure dfFormatFieldList(Strings: TStrings);
  procedure dfFillTreeView(Dest: TTreeView; FieldList: TStrings);
  function  dfGetParam(Params, Param: string): string;
  function  dfGetCode(Data, Code: string): string;
  function  dfGetDateCode(Data, Code: string): double;
  function  dfSetCode(Data, Code, Value: string): string;
  function  dfSetDateCode(Data, Code: string; Value: double): string;
  procedure dfSemiToStrings(const Source: string; Dest: TStrings);
  function  dfStringsToSemi(Source: TStrings): string;


implementation

////////////////////////////
//     MISC PROCEDURES    //
//     By Dan English     //
////////////////////////////

procedure dfStretchDraw(Canvas: TCanvas; Rect: TRect; Graphic: TGraphic);
var
  DIB: TBitmap;
  Header, Bits: Pointer;
  HeaderSize, BitsSize: Cardinal;
begin
  if Graphic is TMetafile then
    Canvas.StretchDraw(Rect, Graphic)
  else begin
    DIB:= TBitmap.create;
    DIB.Width:= Graphic.Width;
    DIB.Height:= Graphic.Height;
    DIB.Canvas.Draw(0,0,Graphic);
    try
      GetDIBSizes(DIB.Handle, HeaderSize, BitsSize);
      Getmem(Header, Headersize);
      Getmem(Bits, Bitssize);
      try
        GetDIB(DIB.Handle, DIB.Palette, Header^, Bits^);
        StretchDIBits(Canvas.Handle, Rect.Left, Rect.Top,
          Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
          0, 0, DIB.Width, DIB.Height, Bits, TBitmapInfo(Header^),
          DIB_RGB_COLORS, SRCCOPY);
      finally
        FreeMem(Header, HeaderSize);
        FreeMem(Bits, BitsSize);
      end;
    finally
      DIB.free;
    end;
  end;  
end;

function dfGetFontHeight(fontsize,fontPPI: integer): integer;
begin
  Result := trunc(-FontSize * FontPPI / 72);
end;

function dfGetFontSize(fontheight,fontPPI: integer): integer;
begin
  Result := trunc(-FontHeight * 72 / FontPPI);
end;

function dfCreateObjectRegion(AObject: TDFObject; Scale: double): HRGN;
var Points: array[0..3] of TPoint;

  function CreateLineRegion(pt1, pt2: TPoint; Cushion: integer): HRGN;
  var
    tmp : TPoint;
    pts : array[0..7] of TPoint;
    rgnpts : array[0..5] of TPoint;
  begin
    if (pt1.X = pt2.X) then
    begin
      if (pt1.Y > pt2.Y) then
      begin
        tmp:= pt1;
        pt1:= pt2;
        pt2:= tmp;
      end;
    end else begin
      if (pt1.X > pt2.X) then
      begin
        tmp:= pt1;
        pt1:= pt2;
        pt2:= tmp;
      end;
    end;

    // Get ALL points
    pts[0]:= Point(pt1.X - Cushion, pt1.Y - Cushion);
    pts[1]:= Point(pt1.X + Cushion, pt1.Y - Cushion);
    pts[2]:= Point(pt2.X - Cushion, pt2.Y - Cushion);
    pts[3]:= Point(pt2.X + Cushion, pt2.Y - Cushion);
    pts[4]:= Point(pt1.X - Cushion, pt1.Y + Cushion);
    pts[5]:= Point(pt1.X + Cushion, pt1.Y + Cushion);
    pts[6]:= Point(pt2.X - Cushion, pt2.Y + Cushion);
    pts[7]:= Point(pt2.X + Cushion, pt2.Y + Cushion);

    if (pt1.X = pt2.X) then
    begin
      // Vertical Line
      rgnpts[0]:= pts[0];
      rgnpts[1]:= pts[1];
      rgnpts[2]:= pts[7];
      rgnpts[3]:= pts[6];
      Result := CreatePolygonRgn(rgnpts, 4, WINDING);
    end else if (pt1.Y = pt2.Y) then
    begin
      // Horizontal Line
      rgnpts[0]:= pts[0];
      rgnpts[1]:= pts[3];
      rgnpts[2]:= pts[7];
      rgnpts[3]:= pts[4];
      Result := CreatePolygonRgn(rgnpts, 4, WINDING);
    end else if (pt1.Y > pt2.Y) then
    begin
      // Forwardslash
      rgnpts[0]:= pts[0];
      rgnpts[1]:= pts[2];
      rgnpts[2]:= pts[3];
      rgnpts[3]:= pts[7];
      rgnpts[4]:= pts[5];
      rgnpts[5]:= pts[4];
      Result := CreatePolygonRgn(rgnpts, 6, ALTERNATE);
    end else begin
      // Backslash
      rgnpts[0]:= pts[0];
      rgnpts[1]:= pts[1];
      rgnpts[2]:= pts[3];
      rgnpts[3]:= pts[7];
      rgnpts[4]:= pts[6];
      rgnpts[5]:= pts[4];
      Result := CreatePolygonRgn(rgnpts, 6, ALTERNATE);
    end;
  end;

begin
  if AObject is TDFLine then
  begin
    Result:= CreateLineRegion(
      point( trunc(TDFLine(AObject).X1*Scale), trunc(TDFLine(AObject).Y1*Scale)),
      point( trunc(TDFLine(AObject).X2*Scale), trunc(TDFLine(AObject).Y2*Scale)), 4);

  end
  else begin
    Points[0].X:= trunc(TDFAccess(AObject).Left*Scale);
    Points[0].Y:= trunc(TDFAccess(AObject).Top*Scale);
    Points[1].X:= trunc(TDFAccess(AObject).Left*Scale)+trunc(TDFAccess(AObject).Width*Scale);
    Points[1].Y:= trunc(TDFAccess(AObject).Top*Scale);
    Points[2].X:= trunc(TDFAccess(AObject).Left*Scale)+trunc(TDFAccess(AObject).Width*Scale);
    Points[2].Y:= trunc(TDFAccess(AObject).Top*Scale)+trunc(TDFAccess(AObject).Height*Scale);
    Points[3].X:= trunc(TDFAccess(AObject).Left*Scale);
    Points[3].Y:= trunc(TDFAccess(AObject).Top*Scale)+trunc(TDFAccess(AObject).Height*Scale);
    Result:= CreatePolygonRgn(Points,4,WINDING);
  end;
end;

function dfShiftDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128) <> 0);
end;

function dfCtrlDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Control] and 128) <> 0);
end;

function dfPositiveRect(ARect: TRect): TRect;
begin
  result.Left:= ARect.Left;
  result.Right:= ARect.Right;
  result.Top:= ARect.Top;
  result.Bottom:= ARect.Bottom;
  if ARect.Right < ARect.Left then
  begin
    result.Left:= ARect.Right;
    result.Right:= ARect.Left;
  end;
  if ARect.Bottom < ARect.Top then
  begin
    result.Top:= ARect.Bottom;
    result.Bottom:= ARect.Top;
  end;
end;

function dfOnlyAlpha(const S: string): string;
var x: integer;
begin
  result:= '';
  for x:= 1 to length(S) do
    if (S[x] >= 'a') and (S[x] <= 'z') then
      result:= result + S[x];
end;

function dfOnlyNumeric(const S: string): string;
var x: integer;
begin
  result:= '';
  for x:= 1 to length(S) do
    if (S[x] >= '0') and (S[x] <= '9') then
      result:= result + S[x];
end;

function dfOnlyReal(const S: string): string;
var x: integer;
    y : TFormatSettings;
begin
  result:= '';
  for x:= 1 to length(S) do
    if ((S[x] >= '0') and (S[x] <= '9')) or
       (S[X] = '-') or
       (S[X] = y.DecimalSeparator) then
      result:= result + S[x];
end;

function dfNameOnly(const S: string): string;
begin
  result:= S;
  while (length(Result)>0) and (Result[length(Result)]>='0') and (Result[length(Result)]<='9') do
    delete(Result,length(Result),1);
end;

function dfInttoStrZ(value, digits: integer): string;
begin
  result:= inttostr(value);
  while length(result) < digits do result:= '0' + result;
end;

function dfGetFilter(const FilterList: string; const FilterIndex: integer): string;
var x,c: integer;
begin
  result:= '';
  c:= 0;
  for x:= 1 to length(FilterList)-1 do
  begin
    if (FilterList[x] = '|') and (FilterList[x+1] = '*') then inc(c);
    if c = FilterIndex then break;
  end;
  if c = FilterIndex then
  begin
    result:= copy(FilterList,x+2, 4);
  end;
end;

function dfFileNameOnly(const Filename: string): string;
var x: integer;
begin
  result:= '';
  x:= pos('.', filename);
  if x > 0 then
    result:= copy(filename, 1, x-1);
end;

procedure dfGetRFMMetafile(source: pointer; srcsize: integer; dest: TPicture);
var M: TMemoryStream;
begin
  M:= nil;
  try
    M:= TMemoryStream.create;
    M.write(source^, srcsize);
    M.seek(0,0);
    dest.Metafile.loadfromstream(M);
  finally
    M.free;
  end;
end;

procedure dfGetRFMBitmap(source: pointer; srcsize: integer; dest: TPicture);
var M: TMemoryStream;
begin
  M:= nil;
  try
    M:= TMemoryStream.create;
    M.write(source^, srcsize);
    M.seek(0,0);
    dest.Bitmap.loadfromstream(M);
  finally
    M.free;
  end;
end;

function dfLoadFile(Path: String; var Data; MaxSize: Longint): longint;
var
  FS: TFileStream;
  mode: word;
begin
  FS:= NIL;
  mode:= fmOpenRead or fmShareDenyNone;
  try
    FS:= TFileStream.Create( Path, mode );
    if FS.Size < Maxsize then Maxsize:= FS.Size;
    FS.Read(Data, MaxSize);
    result:= FS.size;
  finally
    FS.Free;
  end;
end;

function dfCountSpaces(S: String): integer;
var x: integer;
begin
  Result:= 0;
  for x:= 1 to length(S) do
    if S[x] = #32 then
      result:= result + 1;
end;

procedure dfMergeMenu(Source: TPopupMenu; Dest: TMenuItem);
var
  I: integer;
  Item : TMenuItem;
begin
  while Dest.Count > 0 do
  begin
    Dest[0].Free;
  end;
  for I:= 0 to Source.Items.Count-1 do
  begin
    if Source.Items[I].Visible then
    begin
      Item:= TMenuItem.Create(Dest);
      Item.Caption:= Source.Items[I].Caption;
      Item.OnClick:= Source.Items[I].OnClick;
      Item.Action:= Source.Items[I].Action;
      Item.RadioItem:= Source.Items[I].RadioItem;
      Item.GroupIndex:= Source.Items[I].GroupIndex;
      Item.Default:= Source.Items[I].Default;
      Item.Checked:= Source.Items[I].Checked;      
      Item.Tag:= Source.Items[I].Tag;
      Dest.Add(Item);
    end;
  end;
end;

function dfSortLeft(Item1, Item2: Pointer): Integer;
begin
  result:= 0;
  if TDFAccess(Item1).left > TDFAccess(Item2).left then result:= 1;
  if TDFAccess(Item1).left < TDFAccess(Item2).left then result:= -1;
end;

function dfSortTop(Item1, Item2: Pointer): Integer;
begin
  result:= 0;
  if TDFAccess(Item1).top > TDFAccess(Item2).top then result:= 1;
  if TDFAccess(Item1).top < TDFAccess(Item2).top then result:= -1;
end;

function dfPosFromPos(Sub, S : string; Index : smallint): smallint;
var
  x: smallint;
  tmpstr: string;
begin
  if index < length(S) - length(sub) + 1 then begin
    tmpstr:= copy(S, Index, (length(s) - Index) + 1);
    if length(Sub) < length(tmpstr) then begin
      x:= Pos(Sub, tmpstr);
      if x > 0 then result:= (Index + x) - 1
      else result:= -1;
      end
    else result:= -1;
    end
  else result:= -1;
end;

function dfGetPath: string;
var
  Path: array[0..MAX_PATH - 1] of Char;
  PathStr: string;
begin
  SetString(PathStr, Path, GetModuleFileName(HInstance, Path, SizeOf(Path)));
  result := ExtractFilePath ( PathStr ) ;
end;

procedure dfWordWrap(Source: string; Dest: TStrings; ACanvas: TCanvas; ARect: TRect);
var
  T,W,X,I: integer;
  flag: boolean;
begin
  W:= (ARect.Right - ARect.Left);
  T:= ACanvas.TextWidth(Source);
  if (T < W) or (T = 0) or (W = 0) then
  begin
    Dest.add(Source);
  end
  else begin
    X:= length(Source) div (T div W);
    repeat
      flag:= false;
      Dest.Text:= WrapText(Source, #13#10, ['.',' ',#9,'-',':',';'], X);
      for I:= 0 to Dest.count-1 do
        if ACanvas.TextWidth(Dest[I]) > W then
        begin
          dec(X);
          flag:= true;
          break;
        end;
    until (not flag) or (X < 2);    
  end;
end;

function dfGetDateFormat: string;
var y : TFormatSettings;
begin
  result:= lowercase(y.ShortDateFormat); {m/d/yyyy}
  if length(result) <> 8 then Exit;
  if result[2] <> '/' then Exit;
  if result[4] <> '/' then Exit;
  insert(result[1],result,1); {mm/d/yyyy}
  insert(result[4],result,4); {mm/dd/yyyy}
end;

function dfFormatToMask(AFormat: string): string;
var I: integer;
begin
  result:= AFormat;
  for I:= 1 to length(result) do
    if result[I] in ['a'..'z'] then
      result[I]:= '9';
  result:= result + ';; ';
end;

function dfStrtoCRLF(S: string): string;
begin
  S := AdjustLineBreaks(S);
  S := AnsiQuotedStr(S,'''');
  S := StringReplace(S, #13#10, '''#13#10''', [rfReplaceAll, rfIgnoreCase]);
  result := StringReplace(S, '#10''''#13', '#10#13', [rfReplaceAll, rfIgnoreCase]);
end;

function dfCRLFtoStr(S: string): string;
var P: PChar;
begin
  if pos('''', S)<>1 then
  begin
    Result:= S;
    Exit;
  end;
  S := StringReplace(S, '#10#13', '#10''''#13', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '''#13#10''', #13#10, [rfReplaceAll, rfIgnoreCase]);
  P := PChar(S);
  result:= AnsiExtractQuotedStr(P,'''');
end;

function dfCrypt(S: String): string;
const
  CRYPT_KEY = 47;
var
  tmpstr: string;
  x: integer;
  b: byte;
begin
  tmpstr:= '';
  for x:= 1 to length(S) do
  begin
    b:= byte(S[x]) xor CRYPT_KEY;
    tmpstr:= tmpstr + char(b);
  end;
  result:= tmpstr;
end;

(*
function dfStripBraces(S: String): string;
var X: integer;
begin
  X:= pos('{',S);
  if X > 0 then
    result:= trim(copy(S,1,X-1))
  else
    result:= S;
end;

function dfGetBraces(S: String): string;
var X: integer;
begin
  result:= '';
  X:= pos('{',S);
  if X > 0 then
  begin
    result:= trim( copy(S,X,length(S)) );
    while (length(result) > 0) and (result[1] = '{') do
      delete(result, 1, 1);
    while (length(result) > 0) and (result[length(result)] = '}') do
      delete(result, length(result), 1);
  end;
end;
*)

function dfStripQuotes(S: String): string;
begin
  result:= S;
  while pos('"', result)>0 do
    delete(result, pos('"', result), 1);
end;

function dfCheck: Integer;
var
  R: TRegistry;
  I: integer;
begin
  result:= trunc(DATE);
  R := TRegistry.Create;
  try
    R.RootKey:= HKEY_CURRENT_USER;
    if not R.OpenKey('Software\Defined Systems\Defined Forms\6.0', true) then
      raise Exception.create('Registry failed');
    if R.ValueExists('Check') then
      Result:= R.ReadInteger('Check')
    else
      R.WriteInteger('Check', trunc(DATE));
    R.CloseKey;
  finally
    R.Free;
  end;
  I:= 15 - trunc(DATE - result);
  if I > 0 then
    Messagedlg('This software uses a trial version of Defined Forms.'#13+
               'The trial version will expire in '+inttostr(I)+' day(s).'#13#13+
               'It is a license violation to use Defined Forms trial'#13+
               'beyond the trial period, or for commercial purposes.',
               mtWarning, [mbok],0)
  else begin
    Messagedlg('This software uses a trial version of Defined Forms.'#13+
               'The trial version has expired.'#13#13+
               'Defined Forms must be licensed to continue.',
               mtWarning, [mbok],0);
    Application.terminate;
  end;
end;

procedure dfFormatFieldList(Strings: TStrings);
var
  SL,C1,C2: TStringlist;
  I,J: integer;
  tmpstr: string;
begin
  //Convert to a tab-delimited treeview-compatible list
  SL:= TStringlist.create;
  C1:= TStringlist.create;
  C2:= TStringlist.create;
  try
    for I:= Strings.count-1 downto 0 do
    begin
      //make lines comma-delimited
      tmpstr:= StringReplace(Strings[I], '/', '","', [rfreplaceall]);
      tmpstr:= '"'+StringReplace(tmpstr, '\', '","', [rfreplaceall])+'"';
      C1.commatext:= tmpstr;
      if I > 0 then
      begin
        tmpstr:= StringReplace(Strings[I-1], '/', '","', [rfreplaceall]);
        tmpstr:= '"'+StringReplace(tmpstr, '\', '","', [rfreplaceall])+'"';
        C2.commatext:= tmpstr;
      end else
        C2.clear;

      //add only unique columns
      tmpstr:= '';
      for J:= 0 to C1.count-1 do
        if (J < C2.count) and (C1[J] = C2[J]) then
          tmpstr:= tmpstr + #9
        else begin
          //don't include "name" properties
          if lowercase(C1[J]) <> 'name' then
            tmpstr:= tmpstr + #9 + C1[J];
        end;
      if tmpstr <> '' then
        SL.insert(0,tmpstr);
    end;
    SL.insert(0,'ROOT');
    Strings.assign(SL);
  finally
    SL.free;
    C1.free;
    C2.free;
  end;
end;

procedure dfFillTreeView(Dest: TTreeView; FieldList: TStrings);
var
  SL: TStringlist;
  MS: TMemoryStream;
  I: integer;
begin
  SL:= TStringlist.create;
  MS:= TMemoryStream.create;
  try
    SL.assign(FieldList);
    dfFormatFieldList(SL);
    SL.savetostream(MS);
    MS.seek(0,0);
    Dest.items.BeginUpdate;
    Dest.loadfromstream(MS);
    for I:= 0 to Dest.items.count-1 do
      if Dest.items[I].HasChildren then
      begin
        Dest.items[I].Imageindex:= 0;
        Dest.items[I].Selectedindex:= 0;
      end
      else begin
        Dest.items[I].Imageindex:= 1;
        Dest.items[I].Selectedindex:= 1;
      end;
    Dest.items.EndUpdate;
    Dest.items[0].Expand(false);
  finally
    SL.free;
    MS.free;
  end;
end;

function dfGetParam(Params, Param: string): string;
var I: integer;
begin
  result := '';
  I:= pos( lowercase(Param+'='), lowercase(Params) );
  if I > 0 then
  begin
    result := copy(Params, I+length(Param+'='), length(Params));
    I:= pos(';',result);
    if I > 0 then
      delete(result, I, length(result));
    result := trim(result);
  end;
end;

function dfGetCode(Data, Code: string): string;
var
  SL: TStrings;
  I: integer;
begin
  result:= '';
  SL:= TStringlist.create;
  try
    if pos(';', Data)>0 then
      dfSemiToStrings(Data, SL)
    else
      SL.Text := Data;
    for I := 0 to SL.count-1 do
      if pos(Code+#9, SL[I])=1 then
      begin
        result := trim(copy(SL[I],length(Code+#9),length(SL[I])));
        break;
      end;
  finally
    SL.free;
  end;
end;

function dfGetDateCode(Data, Code: string): double;
var
  SL: TStrings;
  I,C: integer;
begin
  result:= 0;
  SL:= TStringlist.create;
  try
    if pos(';', Data)>0 then
      dfSemiToStrings(Data, SL)
    else
      SL.Text := Data;
    for I := 0 to SL.count-1 do
      if pos(Code+#9, SL[I])=1 then
      begin
        Val(trim(copy(SL[I],length(Code+#9),length(SL[I]))), result, C);
        break;
      end;
  finally
    SL.free;
  end;
end;

function dfSetCode(Data, Code, Value: string): string;
var
  SL: TStrings;
  I: integer;
  flag: boolean;
begin
  result:= '';
  SL:= TStringlist.create;
  try
    flag := false;
    if pos(';', Data)>0 then
      dfSemiToStrings(Data, SL)
    else
      SL.Text := Data;
    for I := 0 to SL.count-1 do
      if pos(Code, SL[I])=1 then
      begin
        flag := true;
        SL[I] := Code+#9+Value;
        break;
      end;
    if not flag then
      SL.Add(Code+#9+Value);
    result := SL.text;
  finally
    SL.free;
  end;
end;

function dfSetDateCode(Data, Code: string; Value: double): string;
var
  SL: TStrings;
  I: integer;
  flag: boolean;
begin
  result:= '';
  SL:= TStringlist.create;
  try
    flag := false;
    if pos(';', Data)>0 then
      dfSemiToStrings(Data, SL)
    else
      SL.Text := Data;
    for I := 0 to SL.count-1 do
      if pos(Code, SL[I])=1 then
      begin
        flag := true;      
        SL[I] := Code+#9+floattostr(Value);
        break;
      end;
    if not flag then
      SL.Add(Code+#9+floattostr(Value));
    result := SL.text;
  finally
    SL.free;
  end;
end;

procedure dfSemiToStrings(const Source: string; Dest: TStrings);
var tmpstr: string;
begin
  tmpstr := Source;
  Dest.text := stringreplace(tmpstr, ';', #13#10, [rfreplaceall]);
end;

function dfStringsToSemi(Source: TStrings): string;
begin
  result := stringreplace(Source.text, #13#10, ';', [rfreplaceall]);
end;

end.
