unit dfPDF;

interface

{$WEAKPACKAGEUNIT ON}

uses Windows, classes, sysutils, graphics,
     dfClasses, dfUtil, zlib;

// Known issues:
//      1) Logos don't work right.  Bitmap issues.
//      2) Fields mostly work.  Iron out specifics.


//   Notes on use:
//      0) Create with no parameters, and Free when done (like in the typical event-handler scenario).
//      1) Add desired comments using the Comments property (TStrings).  ** Do this
//         before adding pages! **  If comments are added during creation, it could
//         possibly cause problems.  If not, the changes won't show up.
//      2) Set properties like Author, Creator, Producer, Title, etc. [Optional]
//      3) Use the ConvertToPDF() method when ready.  Specify the DFEngine with all of the current info.
//      4) Use one of the SaveToXXX() methods to save the PDF after it is done converting.
//      5) Before re-using a conversion object, call the .Clear method.

//      6) For page-at-a-time creation, use AddDFPage() method only!  Don't mix
//         with ConvertToPDF!

const
  CBUF_SIZE = 98304; // 96K.  64K is sometimes too close to call!

type
  TDF6toPDFConverter = Class(TObject)
  private
    FDFE :           TDFEngine;           // for all-at-once creation only!
    FDFPage :        TDFPage;             // for page-at-a-time creation only!
    FPageWidth :     integer;
    FPageHeight :    integer;
    FPageTop :       integer;
    FPixelsPerInch : integer;
    FPageNum :       integer;
    FMaxPages :      integer;
    FCurrObjNum :    integer;
    FImageCount :    integer;             // Cumulative total images.
    FConverting :    boolean;
    FDone :          boolean;
    FScaleFactor :   Double;
    FObjectPosList : Array of integer;
    FPageStartList : Array of integer;
    FPageImgCounts : Array of integer;
    FPDFStream :     TMemoryStream;
    FCompBuffer :    Pointer;
    FCompStream :    TMemoryStream;
    FCreator:        AnsiString;
    FProducer:       AnsiString;
    FTitle:          AnsiString;
    FAuthor:         AnsiString;
    FSubject:        AnsiString;
    FCreationDate:   TDateTime;
    FTZinfo:         TIME_ZONE_INFORMATION;
    FGMTBiasStr:     AnsiString;
    FComments:       TStrings;
    function    Float3Str(num : double) : AnsiString;
    procedure   AddPDFTextLine(str : AnsiString);
    procedure   AddPDFObject(str : AnsiString);
    function    AddXREFTable : integer;
    function    ColorToPDFstr(color : integer; whichtype : AnsiString) : AnsiString;
    function    ConvertText(oldtext : AnsiString) : AnsiString;
    function    ConvertDateTime(OldDT : TDateTime) : AnsiString;
    function    AddRFMFrameToPDF(DFFrame: TDFFrame) : AnsiString;
    function    AddRFMLineToPDF(DFLine, DFOldLine: TDFLine) : AnsiString;
    function    AddRFMLogoToPDF(DFLogo: TDFLogo; var w, h : Word) : AnsiString;
    function    AddRFMLogoXObjectExec(DFLogo : TDFLogo; imagenum : Integer) : AnsiString;
    function    AddRFMTextToPDF(DFText: TDFText) : AnsiString;
//    function    AddMltTextToPDF(MltText : TgArrPag) : AnsiString;
    function    AddRFMFieldsToPDF(DFField: TDFField) : AnsiString;
    procedure   SetDimensions;
    procedure   StartPDF;  // Adds header PDF objects, etc.
    procedure   FinishPDF; // Adds the trailing PDF ojects, etc.
    procedure   UpdatePageParentRefs(ParentObjNum : integer);
    procedure   SetMemStreamFromString(str: AnsiString; ms : TMemoryStream);
    function    GetStringFromMemStream(ms : TMemoryStream) : AnsiString;
    function    GetGMTBiasString(TZInfoResult : Integer) : AnsiString;
    procedure   SetComments(const Value: TStrings);
  protected
    procedure   CompressMemStream(InStream, CompressedStream : TMemoryStream);
  public
    property    CreationDate : TDateTime read FCreationDate write FCreationDate;
    constructor Create; virtual;
    destructor  Destroy; override;
    procedure   Clear;                               // Use it to start over.
    procedure   ConvertToPDF(FormEngine : TDFEngine); // Use only to convert an entire form (all pages) at once!
    procedure   AddDFPage(Page : TDFPage);           // Use only for page-at-a-time creation!
//    procedure   AddMltPage(Page : TgPagMultiCold);           // Use only for page-at-a-time creation!
    procedure   SaveToFile(Location : AnsiString);       // Save PDF to a file.
    procedure   SaveToStream(stream : TStream);   // Save PDF to a stream.
  published
    property    MaxPages : Integer read FMaxPages write FMaxPages;
    property    Author : AnsiString    read FAuthor   write FAuthor;
    property    Creator : AnsiString   read FCreator  write FCreator;
    property    Producer : AnsiString  read FProducer write FProducer;
    property    Title : AnsiString     read FTitle    write FTitle;
    property    Subject : AnsiString   read FSubject  write FSubject;
    property    Comments : TStrings read FComments write SetComments;
  end;

implementation

{ TDF6toPDFConverter }

// Object methods.

constructor TDF6toPDFConverter.Create;
begin
  FDFE           := nil; // Just a reference.
  FDFPage        := nil;
  FPixelsPerInch := 96;
  FPageWidth     := 612;
  FPageHeight    := 792;
  FPageTop       := FPageHeight - 1;
  FPageNum       := 0;
  FMaxPages      := 0;
  FImageCount    := 0;
  FCurrObjNum    := 1;
  FScaleFactor   := 72 / FPixelsPerInch;
  FConverting    := False;
  FDone          := False;
  Author         := '';
  CreationDate   := 0;
  Creator        := 'Defined Systems';
  Producer       := 'Defined Systems';
  Title          := '';
  Subject        := '';
  FGMTBiasStr    := GetGMTBiasString(GetTimeZoneInformation(FTZinfo));
  SetLength(FObjectPosList, 0);
  SetLength(FPageStartList, 0);
  SetLength(FPageImgCounts, 0);
  FPDFStream     := TMemoryStream.Create;
  FCompStream    := TMemoryStream.Create;
  FComments      := TStringList.Create;
  GetMem(FCompBuffer, CBUF_SIZE);

  inherited Create;
end;

destructor TDF6toPDFConverter.Destroy;
begin
  inherited;

  FreeMem(FCompBuffer, CBUF_SIZE);
  FObjectPosList := nil; // Free the dynamic array.
  FPageStartList := nil; // Free the dynamic array.
  FPageImgCounts := nil; // Free the dynamic array.
  FCompStream.Free;
  FPDFStream.Free;
  FComments.Free;
end;

procedure TDF6toPDFConverter.Clear;
begin
  FConverting    := false;
  FDone          := false;
  FPageNum       := 0;
  FMaxPages      := 0;
  FCurrObjNum    := 1;
  FImageCount    := 0;
  FScaleFactor   := 72 / 96;
  FDFE           := nil; //** Hope this is OK.. We just want to clear the reference, not the object!
  FDFPage        := nil; //** Hope this is OK.. We just want to clear the reference, not the object!
  FPDFStream.Clear;
  FComments.Clear;
  SetLength(FPageStartList, 0);
  SetLength(FObjectPosList, 0);
  SetLength(FPageImgCounts, 0);
end;

procedure TDF6toPDFConverter.SaveToFile(Location: AnsiString);
begin
  // Safety hurdles.
  if not FConverting then Exit;
  if (FDFE = nil) and (FDFPage = nil) then Exit;
  if FPDFStream = nil then Exit;
  // OK, we're done.  Now, finish off the PDF.
  FinishPDF;
  // Save the PDF to a file.
  FPDFStream.SaveToFile(Location);
end;

procedure TDF6toPDFConverter.SaveToStream(stream: TStream);
begin
  // Safety hurdles.
  if not FConverting then Exit;
  if (FDFE = nil) and (FDFPage = nil) then Exit;
  if FPDFStream = nil then Exit;
  // OK, we're done.  Now, finish off the PDF.
  FinishPDF;
  // Save the PDF to stream.
  FPDFStream.SaveToStream(stream);
end;

procedure TDF6toPDFConverter.SetComments(const Value: TStrings);
begin
  // Don't allow changes once conversion to PDF has started.
  if not FConverting then
    FComments.Assign(Value);
end;

procedure TDF6toPDFConverter.SetDimensions;
var
  pg : TDFPage;
begin
  FPixelsPerInch := 96; //*&*

  if FDFE <> nil then
    pg := FDFE.Pages[FPageNum]
  else
    pg := FDFPage;

  If Pg.Orientation = dfLandscape Then
  case pg.PaperSize of
    dfLegal  : begin
                 FPageWidth  := Trunc(14 * FPixelsPerInch);
                 FPageHeight := Trunc(8.5 * FPixelsPerInch);
               end;
    dfLetter : begin
                 FPageWidth  := Trunc(11 * FPixelsPerInch);
                 FPageHeight := Trunc(8.5 * FPixelsPerInch);
               end;
    dfA3     : begin //??
                 FPageWidth  := Trunc(16.5 * FPixelsPerInch);
                 FPageHeight := Trunc(11.6 * FPixelsPerInch);
               end;
    dfA4     : begin //??
                 FPageWidth  := Trunc(11 * FPixelsPerInch);
                 FPageHeight := Trunc(8.5 * FPixelsPerInch);
               end;
    dfA5     : begin //??
                 FPageWidth  := Trunc(11 * FPixelsPerInch);
                 FPageHeight := Trunc(8.5 * FPixelsPerInch);
               end;
    else begin
      FPageWidth  := Trunc(14 * FPixelsPerInch);
      FPageHeight := Trunc(8.5 * FPixelsPerInch);
    end;
  end
  Else
  case pg.PaperSize of
    dfLegal  : begin
                 FPageWidth  := Trunc(8.5 * FPixelsPerInch);
                 FPageHeight := Trunc(14 * FPixelsPerInch);
               end;
    dfLetter : begin
                 FPageWidth  := Trunc(8.5 * FPixelsPerInch);
                 FPageHeight := Trunc(11 * FPixelsPerInch);
               end;
    dfA3     : begin //??
                 FPageWidth  := Trunc(11.6 * FPixelsPerInch);
                 FPageHeight := Trunc(16.5 * FPixelsPerInch);
               end;
    dfA4     : begin //??
                 FPageWidth  := Trunc(8.5 * FPixelsPerInch);
                 FPageHeight := Trunc(11 * FPixelsPerInch);
               end;
    dfA5     : begin //??
                 FPageWidth  := Trunc(8.5 * FPixelsPerInch);
                 FPageHeight := Trunc(11 * FPixelsPerInch);
               end;
    else begin
      FPageWidth  := Trunc(8.5 * FPixelsPerInch);
      FPageHeight := Trunc(14 * FPixelsPerInch);
    end;
  end;
  FPageTop := FPageHeight - 1;
  FScaleFactor := 72 / FPixelsPerInch;
end;

function TDF6toPDFConverter.Float3Str(num: double): AnsiString;
var y : TFormatSettings;
begin
  result := '0';
  try
    y := y.Create;
    result := FloatToStrF(num, ffFixed, 15, 3);
    // This is necessary because PDF only accepts '.' as the decimal separator
    // and Delphi formatting functions always use the global DecimalSeparator.
    // Before this fix, PDFs generated in countries that don't use a '.' as the
    // decimal separator would be invalid.
    result := StringReplace(result, y.DecimalSeparator, '.', [rfReplaceAll]);
  except
    result := '0';
  end;
end;

procedure TDF6toPDFConverter.SetMemStreamFromString(str: AnsiString; ms : TMemoryStream);
begin
  ms.Clear;
  ms.Write(PAnsiChar(str)^, Length(str));
//  ms.Write(str[1], Length(str));
end;

function TDF6toPDFConverter.GetStringFromMemStream(ms: TMemoryStream): AnsiString;
begin
  SetLength(result, ms.Size);
  move(ms.Memory^, PAnsiChar(result)^, ms.Size);
//  move(ms.Memory^, result[1], ms.Size);
end;

var buffer : tbytes;
    tam, est : integer;
    X : Tbytes;
    Sstr : string;
    Sxtr : AnsiString;
procedure TDF6toPDFConverter.CompressMemStream(InStream, CompressedStream : TMemoryStream);
var
  CompStream : TCompressionStream;
  bytecount : integer;
begin
  CompStream := nil;
  CompressedStream.Clear;
  // Compresses from InStream.  Compressed data is in CompressedStream.
  try
    CompStream := TCompressionStream.Create(clMax, CompressedStream);
    InStream.Seek(0, soFromBeginning);
    repeat
      // Read AnsiString data from InStream and write it to the buffer.
      bytecount  := InStream.Read(FCompBuffer^, CBUF_SIZE);
      // Write buffered data to compression stream.
      CompStream.Write(FCompBuffer^, bytecount);
    until (bytecount < CBUF_SIZE);
  finally
    CompStream.Free;

{    CompressedStream.Seek(0, soFromBeginning);
    setlength(X, CompressedStream.Size);
    CompressedStream.Read(X, CompressedStream.Size);

    zDecompress(X, buffer, 0);
    tam := length(buffer);
    SetLength(Sxtr, tam);
    move(Buffer[1], Sxtr[1], tam);}

  end;
end;

function TDF6toPDFConverter.GetGMTBiasString(TZInfoResult : Integer) : AnsiString;
var
  hbias, mbias : integer;
begin
  result := '';
  // If Time-Zone info. isn't available, then don't specify.  PDF allows this.
  if (TZInfoResult = -1) or (TZInfoResult = TIME_ZONE_ID_UNKNOWN) then Exit;
  // Figure out GMT bias.
  if FTZinfo.Bias = 0 then
  begin
    // GMT.  We're done.
    result := result + 'z';
  end else begin
    // Now, add bias indicator.  Sign is opposite of TZ bias.
    if      FTZinfo.Bias < 0 then result := result + '+'
    else if FTZinfo.Bias > 0 then result := result + '-';
    //** This might not be right!  Seems to work, though.
    hbias := abs(FTZinfo.Bias div 60);
    mbias := abs(FTZinfo.Bias mod 60);
    // Finally, add bias AnsiString.
    result := result + Format('%.2d''%.2d''', [hbias, mbias]);
  end;
end;


// RFM 5 Objects -> PDF conversion methods.


procedure TDF6toPDFConverter.AddPDFObject(str: AnsiString);
begin
  SetLength(FObjectPosList, Length(FObjectPosList) + 1);
  FObjectPosList[High(FObjectPosList)] := FPDFStream.Position;
  AddPDFTextLine(str);
  // Increment current object number.
  inc(FCurrObjNum);
end;

procedure TDF6toPDFConverter.AddPDFTextLine(str: AnsiString);
begin
//  FPDFStream.Write(str[1], Length(str));
  FPDFStream.Write(PAnsiChar(str)^, Length(str));
end;

function TDF6toPDFConverter.AddRFMFrameToPDF(DFFrame: TDFFrame) : AnsiString;
var
  ulx, uly, lrx, lry, hw, hh : integer;
  hc : integer;
begin
  result := '';
  // color
  result := result + colortoPDFstr(DFFrame.PenColor, 'RG');
  // fill style
  case DFFrame.BrushStyle of
    bsClear:     ;
    bsSolid:     result := result + colortoPDFstr(DFFrame.BrushColor, 'rg');
    bsFDiagonal: ; //?? requires pattern?
    bsDiagCross: ; //?? requires pattern?
  end;
  // style - width
  result := result + IntToStr(DFFrame.PenWidth) + ' w' + #13#10;
  // style - line pattern
  case DFFrame.PenStyle of
    psSolid:    result := result + '[] 0 d' + #13#10;
    psDashDot:  result := result + '[24 8] 0 d' + #13#10;
//    psDotted:   result := result + '[4 4] 0 d' + #13#10;
    psClear:    ;
  end;
  // Now, what we do all depends on the Frame Type.
  case DFFrame.FrameType of
    dfSquare  : begin
        ulx := DFFrame.Left;
        lry := FPageTop - DFFrame.Top - DFFrame.Height;
        result := result + IntToStr(ulx) + ' ' + IntToStr(lry) + ' ' +
                           IntToStr(DFFrame.Width) + ' ' + IntToStr(DFFrame.Height) + ' re' + #13#10;
        // Fill rect.
        if DFFrame.BrushStyle <> bsClear then
          result := result + 'B' + #13#10
        else
          result := result + 'S' + #13#10;
      end;
    dfRound   : begin
        // Draw rounded-rect.
        with DFFrame do
        begin
          ulx := Left;
          uly := FPageTop - Top;
          lrx := Left + Width;
          lry := FPageTop - Top - Height;
          hc := corner div 2;
          result := result + IntToStr(ulx) + ' ' + IntToStr(uly - hc) + ' m'#13#10 +
                             IntToStr(ulx) + ' ' + IntToStr(uly) + ' ' + IntToStr(ulx + hc) + ' ' + IntToStr(uly) + ' v' + #13#10 +
                             IntToStr(lrx - hc) + ' ' + IntToStr(uly) + ' l'#13#10 +
                             IntToStr(lrx) + ' ' + IntToStr(uly) + ' ' + IntToStr(lrx) + ' ' + IntToStr(uly - hc) + ' v' + #13#10 +
                             IntToStr(lrx) + ' ' + IntToStr(lry + hc) + ' l'#13#10 +
                             IntToStr(lrx) + ' ' + IntToStr(lry) + ' ' + IntToStr(lrx - hc) + ' ' + IntToStr(lry) + ' v' + #13#10 +
                             IntToStr(ulx + hc) + ' ' + IntToStr(lry) + ' l'#13#10 +
                             IntToStr(ulx) + ' ' + IntToStr(lry) + ' ' + IntToStr(ulx) + ' ' + IntToStr(lry + hc) + ' v' + #13#10;
          // close rounded-rect and fill.
          if DFFrame.BrushStyle <> bsClear then
            result := result + 'b' + #13#10
          else
            result := result + 's' + #13#10;
        end;
      end;
    dfEllipse : begin
        // Draw ellipse.
        with DFFrame do
        begin
          ulx := Left;
          uly := FPageTop - Top;
          lrx := Left + Width;
          lry := FPageTop - Top - Height;
          hw := ulx + (Width div 2);
          hh := uly - (Height div 2);
          result := result + IntToStr(ulx) + ' ' + IntToStr(hh) + ' m'#13#10 +
                             IntToStr(ulx) + ' ' + IntToStr(uly) + ' ' + IntToStr(hw) + ' ' + IntToStr(uly) + ' v' + #13#10 +
                             IntToStr(lrx) + ' ' + IntToStr(uly) + ' ' + IntToStr(lrx) + ' ' + IntToStr(hh) + ' v' + #13#10 +
                             IntToStr(lrx) + ' ' + IntToStr(lry) + ' ' + IntToStr(hw) + ' ' + IntToStr(lry) + ' v' + #13#10 +
                             IntToStr(ulx) + ' ' + IntToStr(lry) + ' ' + IntToStr(ulx) + ' ' + IntToStr(hh) + ' v' + #13#10;
          // close rounded-rect and fill.
          if DFFrame.BrushStyle <> bsClear then
            result := result + 'b' + #13#10
          else
            result := result + 's' + #13#10;
        end;
      end;
  end;
end;

function TDF6toPDFConverter.AddRFMLineToPDF(DFLine, DFOldLine: TDFLine) : AnsiString;
var phase: integer;
    newstyle, nilptr : boolean;
begin
  result := '';
  nilptr := (DFOldLine = nil);
  newstyle := nilptr or
              ((DFOldLine <> nil) and ((DFOldLine.PenColor <> DFLine.PenColor) or
                                       (DFOldLine.PenWidth <> DFLine.PenWidth) or
                                       (DFOldLine.PenStyle <> DFLine.PenStyle)));
  // check newstyle.  Close previous path and stroke, if necessary.
  if (not nilptr) and (newstyle) then
    result := result + 's' + #13#10;
  // color
  if nilptr or ((not nilptr) and (DFOldLine.PenColor <> DFLine.PenColor)) then
    result := result + colortoPDFstr(DFLine.PenColor, 'RG');
  // style - width
  if nilptr or ((not nilptr) and (DFOldLine.PenWidth <> DFLine.PenWidth)) then
    result := result + IntToStr(DFLine.PenWidth) + ' w' + #13#10;
  // style - line pattern
  if nilptr or ((not nilptr) and (DFOldLine.PenStyle <> DFLine.PenStyle)) then
  begin
    phase := DFLine.X1 mod 32;
    case DFLine.PenStyle of
      psSolid:    result := result + '[] ' + IntToStr(phase) + ' d' + #13#10;
      psDashDot:   result := result + '[24 8] ' + IntToStr(phase) + ' d' + #13#10;
//      psDotted:   result := result + '[4 4] ' + IntToStr(phase) + ' d' + #13#10;
    end;
  end;
  // moveto, lineto
  with DFLine do
  begin
    result := result + IntToStr(X1) + ' ' + IntToStr(FPageTop - Y1) + ' m' + #13#10;
    result := result + IntToStr(X2) + ' ' + IntToStr(FPageTop - Y2) + ' l' + #13#10;
  end;
end;

//** Won't work properly unless desktop is set to 24(?) or 32-bit color?
function TDF6toPDFConverter.AddRFMLogoToPDF(DFLogo: TDFLogo; var w, h : Word) : AnsiString;
var
  ptr : Pointer;
  imgsize, datastart : integer;
  MF : TMetafile;
  BMP : TBitmap;
  tmpms : TMemoryStream;

  function  Get24bitRGB(imgdata : Pointer; const imgsize : Integer) : AnsiString;
  var
    tmpbyte : Byte;
    i, loops, ctr : integer;
    ptr, ptr2, ptr3 : pointer;
  begin
    result := '';
    ptr    := imgdata;
    ptr2   := Pointer(Cardinal(ptr) + 1);
    ptr3   := Pointer(Cardinal(ptr) + 2);
    loops  := imgsize div 4;
    ctr := 1;
    SetLength(result, loops * 3);
    for i := 1 to loops do
    begin
      // Need to flip RGB order (BGR -> RGB)
      tmpbyte     := Byte(ptr^);
      Byte(ptr^)  := Byte(ptr3^);
      Byte(ptr3^) := tmpbyte;
      // Add binary values to AnsiString.
      result[ctr]     := AnsiChar(ptr^);
      result[ctr + 1] := AnsiChar(ptr2^);
      result[ctr + 2] := AnsiChar(ptr3^);
      inc(ctr, 3);
      inc(Cardinal(ptr), 4);
      inc(Cardinal(ptr2), 4);
      inc(Cardinal(ptr3), 4);
    end;
  end;

  // reverses order of scanlines.
  procedure fixImage(buffer : pointer; const w, h : integer);
  var
    i, j, {x, val,} rowsize : integer;
    buf : Pointer;
    ptr1, ptr2 : Pointer;
  begin
    i := 0;
    j := h - 1;
    rowsize := w shl 2; // (*4) 32 bpp = 4 bytes-per-pixel
    buf := nil;
    try
      GetMem(buf, w * 4);
      ptr1 := buffer;
      ptr2 := Pointer(Cardinal(buffer) + Cardinal(rowsize * (j - 1)));
      while i < j do
      begin
        move(ptr1^, buf^, rowsize);
        move(ptr2^, ptr1^, rowsize);
        move(buf^, ptr2^, rowsize);
        inc(Cardinal(ptr1), rowsize);
        dec(Cardinal(ptr2), rowsize);
        inc(i);
        dec(j);
      end;
    finally
      FreeMem(buf, w * 4);
    end;
  end;

  // use GetDIB() to fill the memory stream with a DIB.
  function  SetStreamToBits(tmpms : TMemoryStream; tmpBMP : TBitmap; var w, h : Word) : integer;
  var
    infohdrsize, size : Cardinal;
    ptr1, ptr2 : Pointer;
  begin
    GetDIBSizes(tmpBMP.Handle, infohdrsize, size);
    tmpms.Clear;
    tmpms.SetSize(infohdrsize + size);
    result := infohdrsize;
    ptr1 := tmpms.Memory;
    ptr2 := Pointer(Cardinal(ptr1) + infohdrsize);
    if not GetDIB(tmpBMP.Handle, tmpBMP.Palette, TBitmapInfoHeader(ptr1^), ptr2^) then
      MessageBeep(MB_ICONERROR);
    w := Word(TBitmapInfoHeader(ptr1^).biWidth);
    h := Word(TBitmapInfoHeader(ptr1^).biHeight);
  end;

begin
  result := '';
  tmpms := nil;
  MF := nil;
  BMP := nil;
{  datastart := 0;}
  try
    tmpms := TMemoryStream.Create;
    MF := TMetafile.Create;
    BMP := TBitmap.Create;
    with DFLogo do
    begin
      w := DFLogo.Width;
      h := DFLogo.Height;
      BMP.Height := h;
      BMP.Width := w;
      if (Picture.Graphic = nil) then Exit; // probably won't happen.
      // Convert any image type to bitmap for PDF rendering.
      BMP.Transparent := (Picture.Graphic.Transparent);
      BMP.Canvas.StretchDraw(BMP.Canvas.ClipRect, Picture.Graphic);
      // Normalize bitmap pixel data to 32-bit RGBA
      BMP.HandleType := bmDDB;
      BMP.PixelFormat := pf32bit;
      // Get the DIB image data into the memory stream.
      datastart := SetStreamToBits(tmpms, BMP, w, h);
      // Now set a pointer to the beginning of data and reset the image size.
      ptr := Pointer(Cardinal(tmpms.Memory) + Cardinal(datastart));
      // Note:  This function only works on 32-bpp data; assumes 4 Bytes/Pixel.
      fixImage(ptr, w, h);
      // Calculate the offset of the image data.
      imgsize := tmpms.Size - datastart;
      if imgsize < 0 then imgsize := 0;
      // convert Bitmap to binary AnsiString.
      result := Get24bitRGB(ptr, imgsize);
    end;
  finally
    if tmpms <> nil then tmpms.Free;
    if MF <> nil then MF.Free;
    if BMP <> nil then BMP.Free;
  end;
end;

function TDF6toPDFConverter.AddRFMLogoXObjectExec(DFLogo : TDFLogo; imagenum : Integer) : AnsiString;
{var
  l, t, w, h : integer;}
begin
  // Calculate dimensions.
  with DFLogo do
  begin
    // Add Bitmap Image.
    result :=          'q' + #13#10;
    result := result + IntToStr(Width) + ' 0 0 ' + IntToStr(Height) + ' ' +
                       IntToStr(Left) + ' ' + IntToStr(FPageTop - Top - Height) + ' cm' + #13#10;
    result := result + '/Im' + IntToStr(imagenum) + ' Do' + #13#10;
    result := result + 'Q' + #13#10;
  end;
end;

function TDF6toPDFConverter.AddRFMTextToPDF(DFText: TDFText) : AnsiString;
var
  fsize : integer;
  fname, textline : AnsiString;

  function RotationMatrixStr(Angle : Integer) : AnsiString;
  var
    sine, cosine : Double;
  begin
    sine   := Sin(Angle * PI / 180);
    cosine := Cos(Angle * PI / 180);

    result := Float3Str(cosine) + ' ' +
              Float3Str(sine  ) + ' ' +
              Float3Str(-sine ) + ' ' +
              Float3Str(cosine) + ' ';
  end;

begin
  result := 'BT' + #13#10;
  with DFText do
  begin
    // color
    result := result + colortoPDFstr(DFText.FontColor, 'rg');
    // font size

    fsize := (DFText.FontSize) + DFText.Tag;

    // crude font name :-}
    if      pos('COURIER', Uppercase(FontName)) > 0 then
      fname := '/F1'
    else if pos('ARIAL', Uppercase(FontName)) > 0   then fname := '/F2'
    else if pos('TIMES', Uppercase(FontName)) > 0   then fname := '/F3'
    else fname := '/F2';
    // font style
//    if (TFontStyle(DFText.FontStyle) = fsBold) then fname := fname + '1';
    If (fsBold In DFText.FontStyle) Then
      fname := fname + '1';
    // This isn't in the above block, because there is only native support for regular Symbol.
    if pos('SYMBOL', Uppercase(FontName)) > 0   then fname := '/F4';
    // text
    Angle :=0;
    if Angle = 0 then
    begin
      result := result + fname + ' ' + IntToStr(fsize) + ' Tf' + #13#10;
      result := result + '1 0 0 1 ' + IntToStr(Left) + ' ' +
                         IntToStr(FPageTop - Top + FontHeight) + ' Tm' + #13#10;
    end else begin
      result := result + fname + ' ' + IntToStr(fsize) + ' Tf' + #13#10;
      result := result + RotationMatrixStr(Angle) + IntToStr(Left) + ' ' +
                         IntToStr(FPageTop - Top + FontHeight) + ' Tm' + #13#10;
    end;
    TextLine := DFText.Text;
  end;
  result := result + ConvertText(textline) + ' Tj'#13#10;
  result := result + 'ET' + #13#10;
end;

//*&* Right now, it's just a copy of Text code, but isn't actually called.  Needs to be done!
function TDF6toPDFConverter.AddRFMFieldsToPDF(DFField: TDFField) : AnsiString;
var
  fname, textline{, tmpln} : AnsiString;
  TW, x, y : integer;
  invscale : Double;
  tmplist : TStringList;
//  ACanvas : TCanvas;
  ACanvas : TBitMap;

  function  AddPDFClipRect(l, t, w, h : integer) : AnsiString;
  var
    ulx, lry, tmpw : integer;
  begin
    // Get bottom-left corner.
    ulx := l;
    lry := FPageTop - 1 - (t + h);
//    if not DFField.Autosize then
      tmpw := w;
//    else            // Romero ... No need to simulate pois the width vem certo......
      // simulate autosize by extending width to the page boundary.
//      tmpw := (FPageWidth - 1) - w;

    If DFField.Autosize Then // Romero ... Em alguns casos faltou um pouco no fim e truncou a metade da letra.....
      Inc(TmpW,2);

    // Add the rectangle command.
    result := IntToStr(ulx) + ' ' + IntToStr(lry) + ' ' +
              IntToStr(tmpw) + ' ' + IntToStr(h) + ' re' + #13#10;
    // Add Path to Clipping Path.
    result := result + 'W*' + #13#10;
    // End Path WITHOUT filling it or stroking it.
    result := result + 'n' + #13#10;
  end;

Begin
  If DFField.Data = '' Then // Romero -> Campo vazio, nada para fazer......
    Exit;

  if DFField.FieldName = 'Fieldsan1' then
    begin
    result := result;
    end;

  If DFField.Visible = False Then // Romero -> Campo invisível, nada para fazer......
    Exit;

  result := 'q'#13#10; // Save graphics state (push onto stack).
  result := result + AddPDFClipRect(DFField.Left, DFField.Top, DFField.Width, DFField.Height);

  result := result + 'BT' + #13#10; // Begin Text.
  // color
  result := result + colortoPDFstr(DFField.FontColor, 'rg');
  // crude font name :-}
  if      pos('COURIER', Uppercase(DFField.FontName)) > 0 then
    fname := '/F1'
  else if pos('ARIAL', Uppercase(DFField.FontName)) > 0   then fname := '/F2'
  else if pos('TIMES', Uppercase(DFField.FontName)) > 0   then fname := '/F3'
  else fname := '/F2';
  // font style
//  if (TFontStyle(DFField.FontStyle) <> fsBold) then
//    fname := fname + '1';
  If (fsBold in DFField.FontStyle) then
    fname := fname + '1';
  // This isn't in the above block, because there is only native support for regular Symbol.
  if pos('SYMBOL', Uppercase(DFField.FontName)) > 0   then fname := '/F4';
  // text
  result := result + fname + ' ' + IntToStr(DFField.FontSize) + ' Tf' + #13#10;
  invscale := FPixelsPerInch / 72;
  // Memo fields should be handled differently.
  if DFField.Format = dfMemo then
  begin
    {memo format}
    tmplist := nil;
    try
      tmplist := TStringList.Create;
      tmplist.Text := DFField.Data;
      // Field.Data
      for x := 0 to tmplist.Count-1 do
      begin
        y := FPageTop - DFField.Top - 1 + (DFField.FontHeight * (x + 1));
        result := result + Float3Str(invscale) + ' 0 0 ' + Float3Str(invscale) +  ' ' +
                           IntToStr(DFField.Left) + ' ' + IntToStr(y) + ' Tm' + #13#10;
        result := result + ConvertText(tmplist[x]) + ' Tj'#13#10;

{        tw:= ACanvas.TextWidth( TRFMLabel(Field).AsStringList[x] );
        if TRFMLabel(Field).Alignment = taCenter then
          ARect.Left:= ARect.Left + trunc(((Field.Width * Scale) - tw) / 2);
        if TRFMLabel(Field).Alignment = taRightJustify then
          ARect.Left:= ARect.Right - tw;
        ACanvas.TextRect(ARect, ARect.Left, ARect.Top, TRFMLabel(Field).AsStringList[x]);
        if (TRFMLabel(Field).MemoSpacing > 0) then
          ARect.top:= ARect.top + trunc(TRFMLabel(Field).MemoSpacing * Scale)
        else
          ARect.top:= ARect.top + ACanvas.textheight('X');}
      end;
    finally
      tmplist.Free;
    end;
  end else begin
    {regular format}

{    tw:= ACanvas.TextWidth( TRFMLabel(Field).caption );
    if TRFMLabel(Field).Alignment = taCenter then
      ARect.Left:= ARect.Left + trunc(((Field.Width * Scale) - tw) / 2);

    if TRFMLabel(Field).Alignment = taRightJustify then
      ARect.Left:= ARect.Right - tw;

    if Scale <> 1.0 then
      ARect.Right:= trunc(ARect.Right * 1.1); {fix print clipping}

{    ACanvas.TextRect(ARect, ARect.Left, ARect.Top, TRFMLabel(Field).caption);}
    If DFField.Alignment = dfRight Then
      Begin
      ACanvas := TBitMap.Create;
      ACanvas.Canvas.Brush.Style:= bsClear;
      ACanvas.Canvas.Font.Charset:= DFField.FontCharset;
      ACanvas.Canvas.Font.Color:= DFField.FontColor;
      ACanvas.Canvas.Font.Style:= DFField.FontStyle;
      ACanvas.Canvas.Font.Name:= DFField.FontName;
      ACanvas.Canvas.Font.Height:= DFField.FontHeight;
      TW := ACanvas.Canvas.TextWidth(DFField.Data);
//      TW := DFField.Width - ACanvas.Canvas.TextWidth(DFField.Data) - 6;
      TW := DFField.Width - ACanvas.Canvas.TextWidth(DFField.Data) - 6;       // Romero
      If TW < 0 Then
        TW := 0;
      ACanvas.Free;
      End
    Else
      TW := 0;
    textline := ConvertText(DFField.Data) + ' Tj'#13#10;
    result := result + Float3Str(invscale) + ' 0 0 ' + Float3Str(invscale) +  ' ' +
                       IntToStr(DFField.Left + TW) + ' ' +    // Romero ... Tentativa de alinhar o field à direita
                       IntToStr(FPageTop - DFField.Top + DFField.FontHeight) + ' Tm' + #13#10;
    result := result + textline;
  end;
  result := result + 'ET' + #13#10; // End Text.
  result := result + 'Q' + #13#10; // Restore graphics state (pop from stack).
end;

procedure TDF6toPDFConverter.ConvertToPDF(FormEngine : TDFEngine);
var
  startobj, imgstart, imgcount, pg, i, cnt : integer;
  w, h : Word;
{  scalefactor : Double;}
  objstr, pagedesc, imagestr : AnsiString;
  tmpstream : TMemoryStream;
begin
  tmpstream := nil;
  try
    tmpstream := TMemoryStream.Create;
    FConverting := True;
    FDone := False;
    // Refer to original.
    FDFE := FormEngine;
    FDFPage := nil;
    FMaxPages := FDFE.PageCount;
    for pg := 0 to FMaxPages - 1 do
    begin
      FPageNum := pg;
      // Add PDF header objects on first time.
      if pg = 0 then StartPDF;
      // Set the variables based on the page's dimensions.
      SetDimensions;

      // For a typical page, we will add the following PDF objects:
      //   Layout Description, (XObjects, XObj Lengths), Page Resources.
      // Set variables, etc.
      startobj := FCurrObjNum;
      SetLength(FPageStartList, Length(FPageStartList) + 1);
      FPageStartList[High(FPageStartList)] := startobj;
      // Preamble: Set up the page's scale info.
      pagedesc := 'q' + #13#10;
      pagedesc := pagedesc + Float3Str(FScaleFactor) + ' 0 0 ' +
                             Float3Str(FScaleFactor) + ' 0 0 cm' + #13#10;

      // First, the Page-Layout descriptions (draw RFM objects onto PDF "canvas").
      //   Add Frames. (Ellipses are now part of frames)
      cnt := FDFE.Pages[pg].FrameCount;
      for i := 0 to cnt - 1 do
      begin
        with FDFE.Pages[pg] do
        begin
          pagedesc := pagedesc + AddRFMFrameToPDF(Frames[i]);
        end;
      end;
      //   Add Lines.
      cnt := FDFE.Pages[pg].LineCount;
      for i := 0 to cnt - 1 do
      begin
        with FDFE.Pages[pg] do
        begin
          if i > 0 then
            pagedesc := pagedesc + AddRFMLineToPDF(Lines[i], Lines[i-1])
          else
            pagedesc := pagedesc + AddRFMLineToPDF(Lines[i], nil);
        end;
      end;
      pagedesc := pagedesc + 'S' + #13#10;
      //   Add Logo References.  Actual Logo image-data will be added later.
      cnt := FDFE.Pages[pg].LogoCount;
      if cnt > 0 then
        for i := 0 to cnt - 1 do
        begin
          with FDFE.Pages[pg] do
          begin
            pagedesc := pagedesc + AddRFMLogoXObjectExec(Logos[i], FImageCount + i + 1);
          end;
        end;
      //   Add Text.
      cnt := FDFE.Pages[pg].TextCount;
      for i := 0 to cnt - 1 do
      begin
        with FDFE.Pages[pg] do
        begin
          pagedesc := pagedesc + AddRFMTextToPDF(Text[i]);
        end;
      end;
      //   Lastly, add Fields.
      cnt := FDFE.Pages[pg].FieldCount;
      for i := 0 to cnt - 1 do
      begin
        with FDFE.Pages[pg] do
        begin
          pagedesc := pagedesc + AddRFMFieldsToPDF(Fields[i]);
        end;
      end;
      pagedesc := pagedesc + 'Q'#13#10;
      // Don't forget last CR/LF!
      // Compress page mark-up data.
      SetMemStreamFromString(pagedesc, tmpstream);
 //     tmpstream.SaveToFile('c:\COLDCFG\' + inttostr(pg + 1) + '.txt'); //!!
//tmpstream.SaveToFile('d:\my documents\df6pdf\' + inttostr(pg + 1) + '.txt'); //!!
      CompressMemStream(tmpstream, FCompStream);
      objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<< /Length ' + IntToStr(FCompStream.Size) +
                ' /Filter /FlateDecode >>'#13#10'stream'#13#10;
      objstr := objstr + GetStringFromMemStream(FCompStream) + #13#10'endstream'#13#10'endobj'#13#10#13#10;
      AddPDFObject(objstr);

      // Second, the Image XObjects.
      imgcount := FDFE.Pages[pg].LogoCount;
      SetLength(FPageImgCounts, Length(FPageImgCounts) + 1);
      FPageImgCounts[High(FPageImgCounts)] := imgcount;
      imgstart := FCurrObjNum;
      // Add Image XObjects (picture data).
      if imgcount > 0 then
        for i := 0 to imgcount - 1 do
        begin
          inc(FImageCount);
          with FDFE.Pages[pg] do
          begin
            // Dynamic objects - XObjects Image data: dictionary + stream.
            // Add picture data here.
            imagestr := AddRFMLogoToPDF(Logos[i], w, h);
            // Compress image data.
            SetMemStreamFromString(imagestr, tmpstream);
            CompressMemStream(tmpstream, FCompStream);

            objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10 +
                    '<<' + #13#10 +
                    '/Type /XObject' + #13#10 +
                    '/Subtype /Image' + #13#10 +
                    '/Name /Im' + IntToStr(FImageCount) + #13#10 +
                    '/Width ' + IntToStr(w) + #13#10 +
                    '/Height ' + IntToStr(h) + #13#10 +
                    '/BitsPerComponent 8' + #13#10 +
                    '/ColorSpace /DeviceRGB' + #13#10 +
                    '/Filter /FlateDecode' + #13#10 +
  //                  '/Filter /ASCIIHexDecode' + #13#10 +
                    '/Length ' + IntToStr(FCompStream.Size) + #13#10 +
                    '>>' + #13#10 +
                    'stream'#13#10 +
  //                  imagestr + '>' + #13#10 + // The '>' is for ASCIIHexDecode only!
                    GetStringFromMemStream(FCompStream) + #13#10 +
                    'endstream' + #13#10 +
                    'endobj' + #13#10#13#10;
            AddPDFObject(objstr);
          end;
        end;

      // Finally, add the Page's resource-object.
        // Page settings.
      objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10'/Type /Page'#13#10 +
              '/Parent ' + '0000' {Placeholder!} + ' 0 R'#13#10;
      pagedesc := '/Resources <<'#13#10; {Generated (XObjects, Fonts, ProcSet)}
      if imgcount > 0 then
      begin
        // Add Procset to Resources dictionary.
        pagedesc := pagedesc + '  /ProcSet [/PDF /Text /ImageC]'#13#10;
        // Add XObjects to Resources dictionary.
        pagedesc := pagedesc + '  /XObject << ';
        for i := 0 to imgcount - 1 do
          pagedesc := pagedesc + '/Im' + IntToStr(FImageCount - imgcount + i + 1) + ' ' +
                      IntToStr(imgstart + i) + ' 0 R ';
        pagedesc := pagedesc + '>>'#13#10;
      end else
        pagedesc := pagedesc + '  /ProcSet [/PDF /Text]'#13#10; // Add Procset to Resources dictionary.
      // Add Fonts to Resources dictionary.
      pagedesc := pagedesc + '  /Font << /F1 1 0 R /F2 2 0 R /F3 3 0 R /F4 4 0 R ' +
                             '/F11 5 0 R /F21 6 0 R /F31 7 0 R >>'#13#10;
      objstr := objstr + pagedesc  + '>>'#13#10 +
              '/MediaBox [ 0 0 ' + IntToStr(Trunc(FPageWidth * FScaleFactor)) + ' ' +
              IntToStr(Trunc(FPageHeight * FScaleFactor)) + ' ]'#13#10 +
              '/Contents ' + IntToStr(startobj) + ' 0 R'#13#10'>>'#13#10 +
              'endobj'#13#10#13#10;
      AddPDFObject(objstr);
    end;
  finally
    tmpstream.Free;
  end;
end;

procedure TDF6toPDFConverter.AddDFPage(Page: TDFPage);
var
  startobj, imgstart, imgcount, i, cnt : integer;
  w, h : Word;
{  scalefactor : Double;}
  objstr, pagedesc, imagestr : AnsiString;
  tmpstream : TMemoryStream;
begin
  tmpstream := nil;
  try
    tmpstream := TMemoryStream.Create;
    FConverting := True;
    FDone := False;
    // Safety hurdles.
    if FPageNum + 1 > FMaxPages then Exit;
    Inc(FPageNum);
    // Refer to original.
    FDFPage := Page;
    FDFE := nil;
    // Set the variables based on the page's dimensions.
    SetDimensions;
    // If it's the first page, then add the opening PDF lines.
    if FPageNum = 1 then StartPDF;

    // For a typical page, we will add the following PDF objects:
    //   Layout Description, (XObjects, XObj Lengths), Page Resources.
    // Set variables, etc.
    startobj := FCurrObjNum;
    SetLength(FPageStartList, Length(FPageStartList) + 1);
    FPageStartList[High(FPageStartList)] := startobj;
    // Preamble: Set up the page's scale info.
    pagedesc := 'q' + #13#10;
    pagedesc := pagedesc + Float3Str(FScaleFactor) + ' 0 0 ' +
                           Float3Str(FScaleFactor) + ' 0 0 cm' + #13#10;

    // First, the Page-Layout descriptions (draw RFM objects onto PDF "canvas").
    //   Add Frames.  Ellipses are now under the "frames" category.
    cnt := FDFPage.FrameCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
        pagedesc := pagedesc + AddRFMFrameToPDF(Frames[i]);
      end;
    end;
    //   Add Lines.
    cnt := FDFPage.LineCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
        if i > 0 then
          pagedesc := pagedesc + AddRFMLineToPDF(Lines[i], Lines[i-1])
        else
          pagedesc := pagedesc + AddRFMLineToPDF(Lines[i], nil);
      end;
    end;
    pagedesc := pagedesc + 'S' + #13#10;
    //   Add Logo References.  Actual Logo image-data will be added later.
    cnt := FDFPage.LogoCount;
    if cnt > 0 then
      for i := 0 to cnt - 1 do
      begin
        with FDFPage do
        begin
          pagedesc := pagedesc + AddRFMLogoXObjectExec(Logos[i], FImageCount + i + 1);
        end;
      end;
    //   Add Text.
    cnt := FDFPage.TextCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
        pagedesc := pagedesc + AddRFMTextToPDF(Text[i]);
      end;
    end;
    //   Lastly, add Fields.
    cnt := FDFPage.FieldCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
//        if Fields[i].FieldName = 'Fieldsan1' then
//          begin
//          Fields[i].FieldName := 'Fieldsan1';
//          end;
        pagedesc := pagedesc + AddRFMFieldsToPDF(Fields[i]);
      end;
    end;
    pagedesc := pagedesc + 'Q'#13#10;
    // Don't forget last CR/LF!
    // Compress page mark-up data.
    SetMemStreamFromString(pagedesc, tmpstream);
    //tmpstream.SaveToFile('c:\COLDCFG\' + inttostr(1) + '.txt');
    CompressMemStream(tmpstream, FCompStream);
    objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<< /Length ' + IntToStr(FCompStream.Size) +
              ' /Filter /FlateDecode >>'#13#10'stream'#13#10;
    objstr := objstr + GetStringFromMemStream(FCompStream) + #13#10'endstream'#13#10'endobj'#13#10#13#10;
    AddPDFObject(objstr);


    // Second, the Image XObjects.
    imgcount := FDFPage.LogoCount;
    SetLength(FPageImgCounts, Length(FPageImgCounts) + 1);
    FPageImgCounts[High(FPageImgCounts)] := imgcount;
    imgstart := FCurrObjNum;
    // Add Image XObjects (picture data).
    if imgcount > 0 then
      for i := 0 to imgcount - 1 do
      begin
        inc(FImageCount);
        with FDFPage do
        begin
          // Dynamic objects - XObjects Image data: dictionary + stream.
          // Add picture data here.
          imagestr := AddRFMLogoToPDF(Logos[i], w, h);
          // Compress image data.
          SetMemStreamFromString(imagestr, tmpstream);
          CompressMemStream(tmpstream, FCompStream);

          objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10 +
                  '<<' + #13#10 +
                  '/Type /XObject' + #13#10 +
                  '/Subtype /Image' + #13#10 +
                  '/Name /Im' + IntToStr(FImageCount) + #13#10 +
                  '/Width ' + IntToStr(w) + #13#10 +
                  '/Height ' + IntToStr(h) + #13#10 +
                  '/BitsPerComponent 8' + #13#10 +
                  '/ColorSpace /DeviceRGB' + #13#10 +
                  '/Filter /FlateDecode' + #13#10 +
                  '/Length ' + IntToStr(FCompStream.Size) + #13#10 +
                  '>>' + #13#10 +
                  'stream'#13#10 +
                  GetStringFromMemStream(FCompStream) + #13#10 +
                  'endstream' + #13#10 +
                  'endobj' + #13#10#13#10;
          AddPDFObject(objstr);
        end;
      end;

    // Finally, add the Page's resource-object.
      // Page settings.
    objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10'/Type /Page'#13#10 +
            '/Parent ' + '0000' {Placeholder!} + ' 0 R'#13#10;
    pagedesc := '/Resources <<'#13#10; {Generated (XObjects, Fonts, ProcSet)}
    if imgcount > 0 then
    begin
      // Add Procset to Resources dictionary.
      pagedesc := pagedesc + '  /ProcSet [/PDF /Text /ImageC]'#13#10;
      // Add XObjects to Resources dictionary.
      pagedesc := pagedesc + '  /XObject << ';
      for i := 0 to imgcount - 1 do
        pagedesc := pagedesc + '/Im' + IntToStr(FImageCount - imgcount + i + 1) + ' ' +
                    IntToStr(imgstart + i) + ' 0 R ';
      pagedesc := pagedesc + '>>'#13#10;
    end else
      pagedesc := pagedesc + '  /ProcSet [/PDF /Text]'#13#10; // Add Procset to Resources dictionary.
    // Add Fonts to Resources dictionary.
    pagedesc := pagedesc + '  /Font << /F1 1 0 R /F2 2 0 R /F3 3 0 R /F4 4 0 R ' +
                           '/F11 5 0 R /F21 6 0 R /F31 7 0 R >>'#13#10;
    objstr := objstr + pagedesc  + '>>'#13#10 +
            '/MediaBox [ 0 0 ' + IntToStr(Trunc(FPageWidth * FScaleFactor)) + ' ' +
            IntToStr(Trunc(FPageHeight * FScaleFactor)) + ' ]'#13#10 +
            '/Contents ' + IntToStr(startobj) + ' 0 R'#13#10'>>'#13#10 +
            'endobj'#13#10#13#10;
    AddPDFObject(objstr);
  finally
    tmpstream.Free;
  end;
end;

function TDF6toPDFConverter.AddXREFTable: integer;
var
  i, lastobjnum : integer;
  line : AnsiString;
begin
  result := FPDFStream.Position;
  lastobjnum := High(FObjectPosList);
  line := 'xref'#13#10'0 ' + IntToStr(Length(FObjectPosList) + 1) + #13#10;
  line := line + '0000000000 65535 f'#13#10;
  AddPDFTextLine(line);
  // Add the individual cross-reference entries.
  for i := 0 to lastobjnum do
  begin
    line := Format('%.10d 00000 n'#13#10, [FObjectPosList[i]]);
    AddPDFTextLine(line);
  end;
end;

function TDF6toPDFConverter.ColorToPDFstr(color: integer; whichtype: AnsiString): AnsiString;
var
  r, g, b : integer;
  upper : boolean;
begin
  r := color and $000000FF;
  g := (color and $0000FF00) shr 8;
  b := (color and $00FF0000) shr 16;
  upper := ((whichtype[1] >= 'A') and (whichtype[1] <= 'Z'));
  if (r = g) and (r = b) then
  begin
    if upper then
      result := Float3Str(r / 255) + ' G' + #13#10
    else
      result := Float3Str(r / 255) + ' g' + #13#10;
  end else
    result := Float3Str(r / 255) + ' ' +
              Float3Str(g / 255) + ' ' +
              Float3Str(b / 255) + ' ' + whichtype + #13#10;
end;

function TDF6toPDFConverter.ConvertText(oldtext : AnsiString) : AnsiString;
var
  tmpstr: AnsiString;

  function adjuststring(oldstr, search, replace : AnsiString) : AnsiString;
  var
    i, len : integer;
  begin
    result := oldstr;
    len := Length(replace);
    i := dfPosFromPos(search, result, 1);
    while i >= 0 do
    begin
      Delete(result, i, Length(search));
      Insert(replace, result, i);
      i := dfPosFromPos(search, result, i + len);
    end;
  end;

begin
  tmpstr := oldtext;
  tmpstr := adjuststring(tmpstr, '\', '\\');
  tmpstr := adjuststring(tmpstr, '(', '\(');
  tmpstr := adjuststring(tmpstr, ')', '\)');
  tmpstr := adjuststring(tmpstr, #13, '\n');
  tmpstr := adjuststring(tmpstr, #10, '\r');
  tmpstr := adjuststring(tmpstr,  #9, '\t');
  result := '(' + tmpstr + ')';
end;

function  TDF6toPDFConverter.ConvertDateTime(OldDT : TDateTime) : AnsiString;
var
  dtstr : AnsiString;
begin
  result := '';
  // Get date and time
  dtstr := FormatDateTime('yyyymmddhhnnss', oldDT);
  result := '(D:' + dtstr;
  // Now, Add time zone (GMT) info.
  result := result + FGMTBiasStr;
  // Close it out.
  result := result + ')';
end;

procedure TDF6toPDFConverter.StartPDF;
var
  line : AnsiString;
  i : integer;
begin
  // Initialize PDF with some hard-coded objects.
  if FMaxPages < 1 then raise Exception.Create('Maximum pages not set!');
  // Header
  AddPDFTextLine('%PDF-1.2'#13#10);
  // Some PDFs have binary stuff like this.  Why?
//  AddPDFTextLine('%'#226#227#207#211 + #13#10#13#10);

  // Add custom user comments here.
  if FComments.Count > 0 then
  begin
    for i := 0 to FComments.Count - 1 do
    begin
      AddPDFTextLine('%' + FComments[i] + #13#10);
    end;
  end;
  // Add separator between comments and the start of actual objects.
  AddPDFTextLine(#13#10);

  // Fonts:
  // Object #1 - Courier Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F1 /BaseFont /Courier'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #2 - Helvetica (Arial?) Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F2 /BaseFont /Helvetica'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #3 - Times Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F3 /BaseFont /Times-Roman'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #4 - Symbol Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F4 /BaseFont /Symbol'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #5 - Courier-Bold Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F11 /BaseFont /Courier-Bold'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #6 - Helvetica-Bold Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F21 /BaseFont /Helvetica-Bold'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #7 - Times-Bold Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F31 /BaseFont /Times-Bold'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);
end;

procedure TDF6toPDFConverter.FinishPDF;
var
  i, startxref : integer;
  line, kidsstr : AnsiString;
begin
  // Finish PDF conversion by adding the final objects/tables/trailers/footers.
  // First, Create and add the Pages-Tree Object
  UpdatePageParentRefs(FCurrObjNum);
  // Fill in the '/Parent 0000' placeholders for each object.
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10'/Type /Pages'#13#10 +
          '/Count ' + IntToStr(Length(FPageStartList)) + #13#10;
  kidsstr := '/Kids [ ';
  //   Add individual Page-Object references
  for i := 0 to High(FPageImgCounts) do
    kidsstr := kidsstr + IntToStr(FPageStartList[i] + FPageImgCounts[i] + 1) + ' 0 R ';
  kidsstr := kidsstr + ']'#13#10;
  line := line + kidsstr;
  line := line + '>>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);
  // Second, add Catalog Object..
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10'/Type /Catalog'#13#10'/Pages ' +
          IntToStr(FCurrObjNum - 1) + ' 0 R'#13#10 +
          {'/Outlines 2 0 R'#13#10'}'>>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Third, the Info object.
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10;
  //   Author.
  if FAuthor <> '' then     line := line + '/Author ' + ConvertText(FAuthor) + #13#10;
  //   Creation Date.
  line := line + '/CreationDate ';
  if FCreationDate = 0 then line := line + ConvertDateTime(Now) + #13#10
  else                      line := line + ConvertDateTime(FCreationDate) + #13#10;
  //   Creator.
  if FCreator <> '' then    line := line + '/Creator ' + ConvertText(FCreator) + #13#10;
  //   Producer.
  if FProducer <> '' then   line := line + '/Producer ' + ConvertText(FProducer) + #13#10;
  //   Title.
  if FTitle <> '' then      line := line + '/Title ' + ConvertText(FTitle) + #13#10;
  //   Subject.
  if FSubject <> '' then    line := line + '/Subject ' + ConvertText(FSubject) + #13#10;
  line := line + '>>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Next, add the Cross-Reference table.
  startxref := AddXREFTable;

  // Now, add the Trailer section.
  line := 'trailer'#13#10'<<'#13#10'/Size ' + IntToStr(Length(FObjectPosList) + 1) + #13#10 +
          '/Root ' + IntToStr(FCurrObjNum - 2) + ' 0 R'#13#10 +
          '/Info ' + IntToStr(FCurrObjNum - 1) + ' 0 R'#13#10'>>'#13#10;
  AddPDFTextLine(line);

  // Second-to-last is the starting position of XREF Table.
  line := 'startxref'#13#10 + IntToStr(startxref) + #13#10;
  AddPDFTextLine(line);

  // Finally, Complete the PDF.
  line := '%%EOF';
  AddPDFTextLine(line);

  // Indicate that we're done.
  FConverting := False;
  FDone := True;
end;

procedure TDF6toPDFConverter.UpdatePageParentRefs(ParentObjNum: integer);
var
  I, objnum, objstart, parentpos : integer;
  tmpstr : AnsiString;
  strptr : PAnsiChar;
begin
  try
    // Go to each page's information object (not mark-up) and fill in placeholder.
    for I := 0 to High(FPageStartList) do
    begin
      // Calculate page object number.
      objnum := FPageStartList[I] + FPageImgCounts[I];
      // Find out where it is in the stream.
      objstart := FObjectPosList[objnum];
      // Get the part of the object with the placeholder in it.
      strptr := Pointer(Cardinal(FPDFStream.Memory) + Cardinal(objstart));
      tmpstr := Copy(StrPas(PAnsiChar(strptr)), 20, 30);
      // If '/Parent' not found, then just skip to the next object.  PDF won't work, of course!
      parentpos := pos('/Parent', tmpstr);
      if parentpos = 0 then continue;
      inc(parentpos, 26); // 20 for AnsiString offset, 6 to position it directly to the placeholder.
      // Position stream to start of placeholder.
      tmpstr := Format('%.4d', [ParentObjNum]);
      FPDFStream.Seek(objstart + parentpos, soFromBeginning);
      // Write out the new object number.  Should always be 4 characters.
      FPDFStream.Write(PAnsiChar(tmpstr)^, 4);
    end;
  finally
    FPDFStream.Seek(0, soFromEnd);
  end;
end;

end.

// PDF-generated layout.
// Header
//   PDF Signature.

// Pages... (Object order)
//   ( Page Base = n (page #1 = 2); # of Images = k. [n, k, numbers = Object #] )
//   Page-Layout      = n
//   Image XObjects:
//     Image 1        = n + 1
//     Image 2        = n + 2
//     ...
//   Page-Resources   = n + k + 1

// Finalizing objects:
//   ( Final base = f )
//   Pages Tree  = f + 1
//   Catalog     = f + 2
//   Fonts       = f + 3 ...
//   Optional Creation Info. Object. = f + 3

// Final:
//   XREF Table
//   Start XREF.
//   EOF Signature.
