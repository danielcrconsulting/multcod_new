unit dfPDF;

interface

{$WEAKPACKAGEUNIT ON}
{.$DEFINE ENCRYPTION}

uses Windows, classes, sysutils, graphics, dialogs,
     dfClasses, dfUtil, zlib
     {$IFDEF ENCRYPTION}
     , hash, cipher, cipher1
     {$ENDIF};

const
  PWD_INIT : Array[0..31] of Byte = // See docs.
    ($28, $BF, $4E, $5E, $4E, $75, $8A, $41, $64, $00, $4E, $56, $FF, $FA, $01, $08,
     $2E, $2E, $00, $B6, $D0, $68, $3E, $80, $2F, $0C, $A9, $FE, $64, $53, $69, $7A);
  TEST_ID : Array[0..15] of Byte = ($95, $c1, $d6, $f9, $2b, $5f, $10, $89,
    $4b, $dd, $ca, $b4, $8c, $bf, $df, $66);

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
  FONTSCALE = 0.9;
  MEMOSPACING = 1; // extra spacing between memo lines.

type
  TPDFAccessBits = (pdfPrint, pdfModify, pdfExtract); // using V2 handler, this is all we support.
  TPDFAccessRights = set of TPDFAccessBits;

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
    FEncryptDict:    String;              // Contains Encryption dictionary for use in final processing.
{$IFDEF ENCRYPTION}
    FEncryptKey:     Array[0..4] of byte; // 40-bit RC4 master key.
{$ENDIF}
    FCreator:        String;
    FProducer:       String;
    FTitle:          String;
    FAuthor:         String;
    FSubject:        String;
    FCreationDate:   TDateTime;
    FTZinfo:         TIME_ZONE_INFORMATION;
    FGMTBiasStr:     String;
    FComments:       TStrings;
    FEncrypted:      Boolean;
    FOwnerPassword:  String;
    FUserPassword:   String;
    FDocID:          String;
    FPDFAccessRights:TPDFAccessRights;
    function    Float3Str(num : double) : String;
    procedure   AddPDFTextLine(str : String);
    procedure   AddPDFObject(str : String);
    function    AddXREFTable : integer;
    function    ColorToPDFstr(color : integer; whichtype : string) : String;
    function    ConvertText(oldtext : string) : String;
    function    ConvertDateTime(OldDT : TDateTime) : String;
    function    AddDFFrameToPDF(DFFrame: TDFFrame; const Shading : Boolean) : string;
    function    AddDFLineToPDF(DFLine, DFOldLine: TDFLine) : string;
    function    AddDFLogoToPDF(DFLogo: TDFLogo; var w, h : Word) : string;
    function    AddDFLogoXObjectExec(DFLogo : TDFLogo; imagenum : Integer) : string;
    function    AddDFTextToPDF(DFText: TDFText) : string;
    function    AddDFFieldsToPDF(DFField: TDFField) : string;
    procedure   SetDimensions(pg : TDFPage);
    procedure   StartPDF;  // Adds header PDF objects, etc.
    procedure   FinishPDF; // Adds the trailing PDF ojects, etc.
    procedure   UpdatePageParentRefs(ParentObjNum : integer);
    procedure   SetMemStreamFromString(str: String; ms : TMemoryStream);
    function    GetStringFromMemStream(ms : TMemoryStream) : String;
    function    GetGMTBiasString(TZInfoResult : Integer) : String;
    procedure   SetComments(const Value: TStrings);
  protected
    procedure   CompressMemStream(InStream, CompressedStream : TMemoryStream);
    procedure   MakeEncryptionDictionary;
    function    EncryptString(const Source : String; const Objnum : Integer) : String;
    procedure   EncryptStream(InStream, EncryptedStream: TMemoryStream; const Objnum : Integer);
    procedure   SetIDstring;
    class function GetHexStringFromData(const Data; len : Integer) : String;
  public
    property    CreationDate : TDateTime read FCreationDate write FCreationDate;
    constructor Create; virtual;
    destructor  Destroy; override;
    procedure   Clear;                               // Use it to start over.
    procedure   ConvertToPDF(FormEngine : TDFEngine); // Use only to convert an entire form (all pages) at once!
    procedure   AddDFPage(Page : TDFPage);           // Use only for page-at-a-time creation!
    procedure   SaveToFile(Location : String);       // Save PDF to a file.
    procedure   SaveToStream(stream : TStream);   // Save PDF to a stream.
  published
    property    MaxPages : Integer read FMaxPages write FMaxPages;
    property    Author : String    read FAuthor   write FAuthor;
    property    Creator : String   read FCreator  write FCreator;
    property    Producer : String  read FProducer write FProducer;
    property    Title : String     read FTitle    write FTitle;
    property    Subject : String   read FSubject  write FSubject;
    property    Comments : TStrings read FComments write SetComments;
    property    Encrypted : Boolean read FEncrypted write FEncrypted;
    property    OwnerPassword : String read FOwnerPassword write FOwnerPassword;
    property    UserPassword  : String read FUserPassword  write FUserPassword;
    property    AccessRights  : TPDFAccessRights read FPDFAccessRights write FPDFAccessRights;
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
  FEncrypted     := False;
  FOwnerPassword := '';
  FUserPassword  := '';
  FPDFAccessRights := [pdfPrint];
  FDocID         := '';
  FGMTBiasStr    := GetGMTBiasString(GetTimeZoneInformation(FTZinfo));
  FEncryptDict   := '';

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

procedure TDF6toPDFConverter.SaveToFile(Location: String);
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

procedure TDF6toPDFConverter.SetDimensions(pg : TDFPage);
begin
  FPixelsPerInch := 96; //*&*

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
                 FPageWidth  := Trunc(11.69 * FPixelsPerInch);
                 FPageHeight := Trunc(16.54 * FPixelsPerInch);
               end;
    dfA4     : begin //??
                 FPageWidth  := Trunc(8.25 * FPixelsPerInch);
                 FPageHeight := Trunc(11.69 * FPixelsPerInch);
               end;
    dfA5     : begin //??
                 FPageWidth  := Trunc(5.83 * FPixelsPerInch);
                 FPageHeight := Trunc(8.25 * FPixelsPerInch);
               end;
    else begin
      FPageWidth  := Trunc(8.5 * FPixelsPerInch);
      FPageHeight := Trunc(14 * FPixelsPerInch);
    end;
  end;
  FPageTop := FPageHeight - 1;
  FScaleFactor := 72 / FPixelsPerInch;
end;

function TDF6toPDFConverter.Float3Str(num: double): String;
begin
  result := '0';
  try
    result := FloatToStrF(num, ffFixed, 15, 3);
    // This is necessary because PDF only accepts '.' as the decimal separator
    // and Delphi formatting functions always use the global DecimalSeparator.
    // Before this fix, PDFs generated in countries that don't use a '.' as the
    // decimal separator would be invalid.
    result := StringReplace(result, DecimalSeparator, '.', [rfReplaceAll]);
  except
    result := '0';
  end;
end;

procedure TDF6toPDFConverter.SetMemStreamFromString(str: String; ms : TMemoryStream);
begin
  ms.Clear;
  ms.Write(PChar(str)^, Length(str));
end;

function TDF6toPDFConverter.GetStringFromMemStream(ms: TMemoryStream): String;
begin
  SetLength(result, ms.Size);
  move(ms.Memory^, PChar(result)^, ms.Size);
end;

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
      // Read string data from InStream and write it to the buffer.
      bytecount  := InStream.Read(FCompBuffer^, CBUF_SIZE);
      // Write buffered data to compression stream.
      CompStream.Write(FCompBuffer^, bytecount);
    until (bytecount < CBUF_SIZE);
  finally
    CompStream.Free;
  end;
end;

function TDF6toPDFConverter.GetGMTBiasString(TZInfoResult : Integer) : String;
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
    // Finally, add bias string.
    result := result + Format('%.2d''%.2d''', [hbias, mbias]);
  end;
end;


// DF 5 Objects -> PDF conversion methods.


procedure TDF6toPDFConverter.AddPDFObject(str: String);
begin
  SetLength(FObjectPosList, Length(FObjectPosList) + 1);
  FObjectPosList[High(FObjectPosList)] := FPDFStream.Position;
  AddPDFTextLine(str);
  // Increment current object number.
  inc(FCurrObjNum);
end;

procedure TDF6toPDFConverter.AddPDFTextLine(str: String);
begin
  FPDFStream.Write(PChar(str)^, Length(str));
end;

function TDF6toPDFConverter.AddDFFrameToPDF(DFFrame: TDFFrame; const Shading : Boolean) : string;
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
        if (DFFrame.BrushStyle <> bsClear) and (Shading) then
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
          if (DFFrame.BrushStyle <> bsClear) and (Shading) then
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
          // close ellipse and fill.
          if (DFFrame.BrushStyle <> bsClear) and (Shading) then
            result := result + 'b' + #13#10
          else
            result := result + 's' + #13#10;
        end;
      end;
  end;
end;

function TDF6toPDFConverter.AddDFLineToPDF(DFLine, DFOldLine: TDFLine) : string;
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
function TDF6toPDFConverter.AddDFLogoToPDF(DFLogo: TDFLogo; var w, h : Word) : string;
var
  ptr : Pointer;
  imgsize, datastart : integer;
  MF : TMetafile;
  BMP : TBitmap;
  tmpms : TMemoryStream;

  function  Get24bitRGB(imgdata : Pointer; const imgsize : Integer) : String;
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
      // Add binary values to string.
      result[ctr]     := Char(ptr^);
      result[ctr + 1] := Char(ptr2^);
      result[ctr + 2] := Char(ptr3^);
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
      // convert Bitmap to binary string.
      result := Get24bitRGB(ptr, imgsize);
    end;
  finally
    if tmpms <> nil then tmpms.Free;
    if MF <> nil then MF.Free;
    if BMP <> nil then BMP.Free;
  end;
end;

function TDF6toPDFConverter.AddDFLogoXObjectExec(DFLogo : TDFLogo; imagenum : Integer) : string;
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

function TDF6toPDFConverter.AddDFTextToPDF(DFText: TDFText) : string;
var
  tw, offs : integer;
  fname, textline : string;
  fsize, invscale : Double;

  function RotationMatrixStr(Angle : Integer) : String;
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

  function  GetTextWidth(str, font : string; fontsize : integer) : Integer;
  var
    B : TBitmap;
  begin
    B := nil;
    try
      B := TBitmap.Create;
      B.Canvas.Font.Name := font;
      B.Canvas.Font.Size := fontsize;
      result := B.Canvas.TextWidth(str);
    finally
      B.Free;
    end;
  end;

begin
  result := 'BT' + #13#10;
  invscale := FPixelsPerInch / 72;
  with DFText do
  begin
    // color
    result := result + colortoPDFstr(DFText.FontColor, 'rg');
    // font size
    fsize := (DFText.FontSize) * FONTSCALE;
    // crude font name :-}
    if      pos('COURIER', Uppercase(FontName)) > 0 then fname := '/F1'
    else if pos('ARIAL', Uppercase(FontName)) > 0   then fname := '/F2'
    else if pos('TIMES', Uppercase(FontName)) > 0   then fname := '/F3'
    else fname := '/F2';
    // font style
    if (TFontStyle(FontStyle) = fsBold) then fname := fname + '1';
    // This isn't in the above block, because there is only native support for regular Symbol.
    if pos('SYMBOL', Uppercase(FontName)) > 0   then fname := '/F4';
    // text
    if DFText.Alignment = dfRight then
    begin
      tw := GetTextWidth(DFText.Text, DFText.FontName, DFText.FontSize);
      if tw > DFText.Width then offs := 0
      else offs := DFText.Width - tw;
    end else if DFText.Alignment = dfCentered then
    begin
      tw := GetTextWidth(DFText.Text, DFText.FontName, DFText.FontSize);
      if tw > DFText.Width then offs := 0
      else offs := (DFText.Width - tw) div 2;
    end else
      offs := 0;

    if Angle = 0 then
    begin
      result := result + fname + ' ' + Float3Str(fsize) + ' Tf' + #13#10;
      result := result + Float3Str(invscale) + ' 0 0 ' + Float3Str(invscale) + ' ' +
                         IntToStr(Left + offs) + ' ' +
                         IntToStr(FPageTop - Top + FontHeight) + ' Tm' + #13#10;
//!!      result := result + '1 0 0 1 ' + IntToStr(Left + offs) + ' ' +
//!!                         IntToStr(FPageTop - Top + FontHeight) + ' Tm' + #13#10;
    end else begin
      result := result + fname + ' ' + Float3Str(fsize) + ' Tf' + #13#10;
      result := result + RotationMatrixStr(Angle) + IntToStr(Left + offs) + ' ' +
                         IntToStr(FPageTop - Top + FontHeight) + ' Tm' + #13#10;
    end;
    textline := DFText.Text;
  end;

  if (textline = '(') or (textline = ')') then textline := textline + ' '; //fix?

  result := result + ConvertText(textline) + ' Tj'#13#10;
  result := result + 'ET' + #13#10;
end;

function TDF6toPDFConverter.AddDFFieldsToPDF(DFField: TDFField) : string;
var
  fname, textline{, tmpln} : string;
  x, y, bx, by, tw, offs : integer;
  invscale : Double;
  tmplist : TStringList;

  function  AddPDFClipRect(l, t, w, h : integer) : String;
  var
    ulx, lry, tmpw : integer;
  begin
    // Get bottom-left corner.
    ulx := l;
    lry := FPageTop - 1 - (t + h);
    if not DFField.Autosize then
      tmpw := w
    else
      // simulate autosize by extending width to the page boundary.
      tmpw := (FPageWidth - 1) - w;
    // Add the rectangle command.
    result := IntToStr(ulx) + ' ' + IntToStr(lry) + ' ' +
              IntToStr(tmpw) + ' ' + IntToStr(h) + ' re' + #13#10;
    // Add Path to Clipping Path.
    result := result + 'W*' + #13#10;
    // End Path WITHOUT filling it or stroking it.
    result := result + 'n' + #13#10;
  end;

  function  GetTextWidth(str, font : string; fontsize : integer) : Integer;
  var
    B : TBitmap;
  begin
    B := nil;
    try
      B := TBitmap.Create;
      B.Canvas.Font.Name := font;
      B.Canvas.Font.Size := fontsize;
      result := B.Canvas.TextWidth(str);
    finally
      B.Free;
    end;
  end;

begin
  invscale := FPixelsPerInch / 72;
  if DFField.Format <> dfCheckBox then
  begin
    result := 'q'#13#10; // Save graphics state (push onto stack).
//    result := result + AddPDFClipRect(DFField.Left, DFField.Top, DFField.Width, DFField.Height);
    if DFField.Format = dfMemo then
      result := result + AddPDFClipRect(DFField.Left, DFField.Top, DFField.Width, DFField.Height);
    result := result + 'BT' + #13#10; // Begin Text.
    // color
    result := result + colortoPDFstr(DFField.FontColor, 'rg');
    // crude font name :-}
    if      pos('COURIER', Uppercase(DFField.FontName)) > 0 then fname := '/F1'
    else if pos('ARIAL', Uppercase(DFField.FontName)) > 0   then fname := '/F2'
    else if pos('TIMES', Uppercase(DFField.FontName)) > 0   then fname := '/F3'
    else fname := '/F2';
    // font style
    if (TFontStyle(DFField.FontStyle) = fsBold) then fname := fname + '1';
    // This isn't in the above block, because there is only native support for regular Symbol.
    if pos('SYMBOL', Uppercase(DFField.FontName)) > 0   then fname := '/F4';
    // text
//!!    result := result + fname + ' ' + IntToStr(DFField.FontSize) + ' Tf' + #13#10;
    result := result + fname + ' ' + Float3Str(DFField.FontSize * FONTSCALE) + ' Tf' + #13#10;
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
          // Include memo spacing in calculations.. we subtract because fontheight is negative.
          y := FPageTop - DFField.Top - 1 + ((DFField.FontHeight - MEMOSPACING) * (x + 1));
          result := result + Float3Str(invscale) + ' 0 0 ' + Float3Str(invscale) +  ' ' +
                             IntToStr(DFField.Left) + ' ' + IntToStr(y) + ' Tm' + #13#10;
          result := result + ConvertText(tmplist[x]) + ' Tj'#13#10;

{          tw:= ACanvas.TextWidth( TDFLabel(Field).AsStringList[x] );
          if TDFLabel(Field).Alignment = taCenter then
            ARect.Left:= ARect.Left + trunc(((Field.Width * Scale) - tw) / 2);
          if TDFLabel(Field).Alignment = taRightJustify then
            ARect.Left:= ARect.Right - tw;
          ACanvas.TextRect(ARect, ARect.Left, ARect.Top, TDFLabel(Field).AsStringList[x]);
          if (TDFLabel(Field).MemoSpacing > 0) then
            ARect.top:= ARect.top + trunc(TDFLabel(Field).MemoSpacing * Scale)
          else
            ARect.top:= ARect.top + ACanvas.textheight('X');}
        end;
      finally
        tmplist.Free;
      end;
    end else begin
      {regular format}

{      tw:= ACanvas.TextWidth( TDFLabel(Field).caption );
      if TDFLabel(Field).Alignment = taCenter then
        ARect.Left:= ARect.Left + trunc(((Field.Width * Scale) - tw) / 2);

      if TDFLabel(Field).Alignment = taRightJustify then
        ARect.Left:= ARect.Right - tw;

      if Scale <> 1.0 then
        ARect.Right:= trunc(ARect.Right * 1.1); {fix print clipping}

{      ACanvas.TextRect(ARect, ARect.Left, ARect.Top, TDFLabel(Field).caption);}
      textline := ConvertText(DFField.Data) + ' Tj'#13#10;

      if DFField.Alignment = dfRight then
      begin
        tw := GetTextWidth(DFField.Data, DFField.FontName, DFField.FontSize);
        if tw > DFField.Width then offs := 0
        else offs := DFField.Width - tw;
      end else if DFField.Alignment = dfCentered then
      begin
        tw := GetTextWidth(DFField.Data, DFField.FontName, DFField.FontSize);
        if tw > DFField.Width then offs := 0
        else offs := (DFField.Width - tw) div 2;
      end else
        offs := 0;

      result := result + Float3Str(invscale) + ' 0 0 ' + Float3Str(invscale) +  ' ' +
                         IntToStr(DFField.Left + offs) + ' ' +
                         IntToStr(FPageTop - DFField.Top + DFField.FontHeight) + ' Tm' + #13#10;
      result := result + textline;
    end;
    result := result + 'ET' + #13#10; // End Text.
    // Restore graphics state (pop from stack).
    result := result + 'Q' + #13#10;
  end else begin
    // Special handling for Checkboxes.  Draw checkbox rectangle.
    result := result + colortoPDFstr(DFField.PenColor, 'RG'); // color //?? dffield.pencolor?
    result := result + IntToStr(DFField.PenWidth) + ' w' + #13#10; // style - width
    result := result + '[] 0 d' + #13#10; // Pen style = psSolid
    result := IntToStr(DFField.Left) + ' ' + IntToStr(FPageTop - DFField.Top - DFField.Height) + ' ' +
              IntToStr(DFField.Height) + ' ' + IntToStr(DFField.Height) + ' re' + #13#10;
    result := result + 'S' + #13#10; // Stroke the path (draw it).

    if SameText(DFField.Data, 'true') then
    begin
      // Draw check-mark 'X'
      bx := DFField.Left; // base-x (Left)
      by := FPageTop - DFField.Top; // base-y (Top)
      //   Start at UL corner; draw to LR.  Start at UR corner; draw to LL.
      result := result + IntToStr(bx) + ' ' + IntToStr(by) + ' m' + #13#10;
      result := result + IntToStr(bx + DFField.Width) + ' ' + IntToStr(by - DFField.Height) + ' l' + #13#10;
      result := result + IntToStr(bx + DFField.Width) + ' ' + IntToStr(by) + ' m' + #13#10;
      result := result + IntToStr(bx) + ' ' + IntToStr(by - DFField.Height) + ' l' + #13#10;
    end;
  end;
end;

procedure TDF6toPDFConverter.ConvertToPDF(FormEngine : TDFEngine);
var
  w, h : Word;
  startobj, imgstart, imgcount, goodcount, pg, I, cnt : integer;
  ActualPage : Integer;
  Page: TDFPage;
{  scalefactor : Double;}
  objstr, pagedesc, imagestr : string;
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
    // Get the real number of pages.
    if (Assigned(FDFE.OnPreviewPageCount)) then
      FDFE.OnPreviewPageCount(FDFE, FMaxPages);
    for pg := 0 to FMaxPages - 1 do
    begin
      FPageNum := pg;
      //get page -- virtual or actual
      if (Assigned(FDFE.OnPreviewPageShow)) then
      begin
        ActualPage := 0;
        FDFE.OnPreviewPageShow(FDFE, pg, ActualPage);
        Page := FDFE.Pages[ActualPage];
      end else
        Page := FDFE.Pages[pg];
      // Add PDF header objects on first time.
      if pg = 0 then StartPDF;
      // Set the variables based on the page's dimensions.
      SetDimensions(Page);

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

      // First, the Page-Layout descriptions (draw DF objects onto PDF "canvas").
      //   Add Frames. (Ellipses are now part of frames)
      cnt := Page.FrameCount;
      for i := 0 to cnt - 1 do
      begin
        with Page do
        begin
          pagedesc := pagedesc + AddDFFrameToPDF(Frames[i], (dfPrintShading in FDFE.PaintOptions));
        end;
      end;
      //   Add Lines.
      cnt := Page.LineCount;
      for i := 0 to cnt - 1 do
      begin
        with Page do
        begin
          if i > 0 then
            pagedesc := pagedesc + AddDFLineToPDF(Lines[i], Lines[i-1])
          else
            pagedesc := pagedesc + AddDFLineToPDF(Lines[i], nil);
        end;
      end;
      pagedesc := pagedesc + 'S' + #13#10;
      //   Add Logo References.  Actual Logo image-data will be added later.
      cnt := Page.LogoCount;
      goodcount := 0;
      if cnt > 0 then
        for i := 0 to cnt - 1 do
        begin
          with Page do
          begin
            if (Logos[I].Width = 0) or (Logos[I].Height = 0) then continue;
            if Logos[I].Picture.Graphic = nil then continue;
            if Logos[I].Picture.Graphic.Empty then continue;
            pagedesc := pagedesc + AddDFLogoXObjectExec(Logos[i], FImageCount + goodcount + 1);
            inc(goodcount);
          end;
        end;
      //   Add Text.
      cnt := Page.TextCount;
      for i := 0 to cnt - 1 do
      begin
        with Page do
        begin
          pagedesc := pagedesc + AddDFTextToPDF(Text[i]);
        end;
      end;
      //   Lastly, add Fields.
      cnt := Page.FieldCount;
      for i := 0 to cnt - 1 do
      begin
        with Page do
        begin
          pagedesc := pagedesc + AddDFFieldsToPDF(Fields[i]);
        end;
      end;
      pagedesc := pagedesc + 'Q'#13#10;
      // Don't forget last CR/LF!
      // Compress page mark-up data.
      SetMemStreamFromString(pagedesc, tmpstream);
//tmpstream.SaveToFile('d:\my documents\df6pdf\' + inttostr(pg + 1) + '.txt'); //!!
      CompressMemStream(tmpstream, FCompStream);
      // Encryption hook.  Notes on use:
      //   Encryption dictionary must already exist (needed to calculate master key).
      //   Applicable passwords should be set.
      if FEncrypted then
      begin
        tmpstream.Clear; // remove old contents.
        tmpstream.CopyFrom(FCompStream, 0); // copy entire stream to tmp.
        // Encrypted result in FCompStream.  Encryption doesn't change the size.
        EncryptStream(tmpstream, FCompStream, FCurrObjNum);
      end;
      objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<< /Length ' + IntToStr(FCompStream.Size) +
                ' /Filter /FlateDecode >>'#13#10'stream'#13#10;
      objstr := objstr + GetStringFromMemStream(FCompStream) + #13#10'endstream'#13#10'endobj'#13#10#13#10;
      AddPDFObject(objstr);

      // Second, the Image XObjects.
      imgcount := Page.LogoCount;
      SetLength(FPageImgCounts, Length(FPageImgCounts) + 1);
      FPageImgCounts[High(FPageImgCounts)] := goodcount;
      imgstart := FCurrObjNum;
      // Add Image XObjects (picture data).
      if goodcount > 0 then
        for i := 0 to imgcount - 1 do
        begin
          //.. Skip empty logos.
          if (Page.Logos[I].Width = 0) or (Page.Logos[I].Height = 0) then continue;
          if (Page.Logos[I].Picture.Graphic) = nil then continue;
          if (Page.Logos[I].Picture.Graphic.Empty) then continue;
          // Process image.
          inc(FImageCount);
          with Page do
          begin
            // Dynamic objects - XObjects Image data: dictionary + stream.
            // Add picture data here.
            imagestr := AddDFLogoToPDF(Logos[i], w, h);
            // Compress image data.
            SetMemStreamFromString(imagestr, tmpstream);
            CompressMemStream(tmpstream, FCompStream);
            // Encryption hook.  Notes on use:
            //   Encryption dictionary must already exist (needed to calculate master key).
            //   Applicable passwords should be set.
            if FEncrypted then
            begin
              tmpstream.Clear; // remove old contents.
              tmpstream.CopyFrom(FCompStream, 0); // copy entire stream to tmp.
              // Encrypted result in FCompStream.  Encryption doesn't change the size.
              EncryptStream(tmpstream, FCompStream, FCurrObjNum);
            end;

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
      if goodcount > 0 then
      begin
        // Add Procset to Resources dictionary.
        pagedesc := pagedesc + '  /ProcSet [/PDF /Text /ImageC]'#13#10;
        // Add XObjects to Resources dictionary.
        pagedesc := pagedesc + '  /XObject << ';
        for i := 0 to goodcount - 1 do
        begin
          pagedesc := pagedesc + '/Im' + IntToStr(FImageCount - goodcount + i + 1) + ' ' +
                      IntToStr(imgstart + i) + ' 0 R ';
        end;
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
  startobj, imgstart, imgcount, goodcount, i, cnt : integer;
  w, h : Word;
{  scalefactor : Double;}
  objstr, pagedesc, imagestr : string;
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
    SetDimensions(FDFPage);
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

    // First, the Page-Layout descriptions (draw DF objects onto PDF "canvas").
    //   Add Frames.  Ellipses are now under the "frames" category.
    cnt := FDFPage.FrameCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
        pagedesc := pagedesc + AddDFFrameToPDF(Frames[i],
          (dfPrintShading in ((FDFPage.Owner as TDFForm).Owner as TDFEngine).PaintOptions));
      end;
    end;
    //   Add Lines.
    cnt := FDFPage.LineCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
        if i > 0 then
          pagedesc := pagedesc + AddDFLineToPDF(Lines[i], Lines[i-1])
        else
          pagedesc := pagedesc + AddDFLineToPDF(Lines[i], nil);
      end;
    end;
    pagedesc := pagedesc + 'S' + #13#10;
    //   Add Logo References.  Actual Logo image-data will be added later.
    cnt := FDFPage.LogoCount;
    goodcount := 0;
    if cnt > 0 then
      for i := 0 to cnt - 1 do
      begin
        with FDFPage do
        begin
          if (Logos[I].Width = 0) or (Logos[I].Height = 0) then continue;
          if Logos[I].Picture.Graphic = nil then continue;
          if Logos[I].Picture.Graphic.Empty then continue;
          pagedesc := pagedesc + AddDFLogoXObjectExec(Logos[i], FImageCount + goodcount + 1);
          inc(goodcount);
        end;
      end;
    //   Add Text.
    cnt := FDFPage.TextCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
        pagedesc := pagedesc + AddDFTextToPDF(Text[i]);
      end;
    end;
    //   Lastly, add Fields.
    cnt := FDFPage.FieldCount;
    for i := 0 to cnt - 1 do
    begin
      with FDFPage do
      begin
        pagedesc := pagedesc + AddDFFieldsToPDF(Fields[i]);
      end;
    end;
    pagedesc := pagedesc + 'Q'#13#10;
    // Don't forget last CR/LF!
    // Compress page mark-up data.
    SetMemStreamFromString(pagedesc, tmpstream);
    CompressMemStream(tmpstream, FCompStream);
    // Encryption hook.  Notes on use:
    //   Encryption dictionary must already exist (needed to calculate master key).
    //   Applicable passwords should be set.
    if FEncrypted then
    begin
      tmpstream.Clear; // remove old contents.
      tmpstream.CopyFrom(FCompStream, 0); // copy entire stream to tmp.
      // Encrypted result in FCompStream.  Encryption doesn't change the size.
      EncryptStream(tmpstream, FCompStream, FCurrObjNum);
    end;
    objstr := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<< /Length ' + IntToStr(FCompStream.Size) +
              ' /Filter /FlateDecode >>'#13#10'stream'#13#10;
    objstr := objstr + GetStringFromMemStream(FCompStream) + #13#10'endstream'#13#10'endobj'#13#10#13#10;
    AddPDFObject(objstr);

    // Second, the Image XObjects.
    imgcount := FDFPage.LogoCount;
    SetLength(FPageImgCounts, Length(FPageImgCounts) + 1);
    FPageImgCounts[High(FPageImgCounts)] := goodcount;
    imgstart := FCurrObjNum;
    // Add Image XObjects (picture data).
    if goodcount > 0 then
      for I := 0 to imgcount - 1 do
      begin
        //.. Skip empty logos.
        if (FDFPage.Logos[I].Width = 0) or (FDFPage.Logos[I].Height = 0) then continue;
        if (FDFPage.Logos[I].Picture.Graphic) = nil then continue;
        if (FDFPage.Logos[I].Picture.Graphic.Empty) then continue;
        // Process image.
        inc(FImageCount);
        with FDFPage do
        begin
          // Dynamic objects - XObjects Image data: dictionary + stream.
          // Add picture data here.
          imagestr := AddDFLogoToPDF(Logos[i], w, h);
          // Compress image data.
          SetMemStreamFromString(imagestr, tmpstream);
          CompressMemStream(tmpstream, FCompStream);
          // Encryption hook.  Notes on use:
          //   Encryption dictionary must already exist (needed to calculate master key).
          //   Applicable passwords should be set.
          if FEncrypted then
          begin
            tmpstream.Clear; // remove old contents.
            tmpstream.CopyFrom(FCompStream, 0); // copy entire stream to tmp.
            // Encrypted result in FCompStream.  Encryption doesn't change the size.
            EncryptStream(tmpstream, FCompStream, FCurrObjNum);
          end;

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
    if goodcount > 0 then
    begin
      // Add Procset to Resources dictionary.
      pagedesc := pagedesc + '  /ProcSet [/PDF /Text /ImageC]'#13#10;
      // Add XObjects to Resources dictionary.
      pagedesc := pagedesc + '  /XObject << ';
      for i := 0 to goodcount - 1 do
        pagedesc := pagedesc + '/Im' + IntToStr(FImageCount - goodcount + i + 1) + ' ' +
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
  line : string;
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

function TDF6toPDFConverter.ColorToPDFstr(color: integer; whichtype: string): String;
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

function TDF6toPDFConverter.ConvertText(oldtext : string) : String;
var
  tmpstr: string;

  function adjuststring(oldstr, search, replace : string) : String;
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

function  TDF6toPDFConverter.ConvertDateTime(OldDT : TDateTime) : String;
var
  dtstr : String;
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
  line : string;
  i : integer;
begin
  // Initialize PDF with some hard-coded objects.
  if FMaxPages < 1 then raise Exception.Create('Maximum pages not set!');
  // Header
  AddPDFTextLine('%PDF-1.3'#13#10);
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
          '/Type /Font /Subtype /Trueype /Name /F1 /BaseFont /CourierNew'#13#10 + // /BaseFont /Courier
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #2 - Helvetica (Arial?) Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /TrueType /Name /F2 /BaseFont /Arial'#13#10 + // /BF /Helvetica /Tahoma
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #3 - Times Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /TrueType /Name /F3 /BaseFont /TimesNewRoman'#13#10 + // /BaseFont /Times-Roman /Verdana
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #4 - Symbol Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F4 /BaseFont /Symbol'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #5 - Courier-Bold Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /TrueType /Name /F11 /BaseFont /CourierNew,Bold'#13#10 + // /Courier-Bold
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #6 - Helvetica-Bold Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /TrueType /Name /F21 /BaseFont /Arial,Bold'#13#10 + // /Helvetica-Bold
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Object #7 - Times-Bold Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /Type1 /Name /F31 /BaseFont /Times-Bold'#13#10 + // /Times-Bold
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

//~~
  // Object #8 - Test Font
  line := IntToStr(FCurrObjNum) + ' 0 obj'#13#10'<<'#13#10 +
          '/Type /Font /Subtype /TrueType /Name /F9 /BaseFont /Tahoma'#13#10 +
          '/Encoding /WinAnsiEncoding >>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);
//~~

  // Get a GUID for the PDF document.
  SetIDstring;

  // Finally, make encryption dictionary, if applicable.
  //   This will also create the master key for encrypting individual streams,
  //   so it must be done now... before any streams are created.
  if FEncrypted then
  begin
    MakeEncryptionDictionary;
  end;
end;

procedure TDF6toPDFConverter.FinishPDF;
var
  i, startxref, encryptdictobj : integer;
  line, kidsstr : string;
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
  if FAuthor <> '' then
    if not FEncrypted then  line := line + '/Author ' + ConvertText(FAuthor) + #13#10
    else                    line := line + '/Author ' + EncryptString(FAuthor, FCurrObjNum) + #13#10;
  //   Creation Date.
  line := line + '/CreationDate ';
  if not FEncrypted then
  begin
    if FCreationDate = 0 then line := line + ConvertDateTime(Now) + #13#10
    else                      line := line + ConvertDateTime(FCreationDate) + #13#10;
  end else begin
    if FCreationDate = 0 then line := line + EncryptString(ConvertDateTime(Now), FCurrObjNum) + #13#10
    else                      line := line + EncryptString(ConvertDateTime(FCreationDate), FCurrObjNum) + #13#10;
  end;
  //   Creator.
  if FCreator <> '' then
    if not FEncrypted then  line := line + '/Creator ' + ConvertText(FCreator) + #13#10
    else                    line := line + '/Creator ' + EncryptString(FCreator, FCurrObjNum) + #13#10;
  //   Producer.
  if FProducer <> '' then
    if not FEncrypted then  line := line + '/Producer ' + ConvertText(FProducer) + #13#10
    else                    line := line + '/Producer ' + EncryptString(FProducer, FCurrObjNum) + #13#10;
  //   Title.
  if FTitle <> '' then
    if not FEncrypted then  line := line + '/Title ' + ConvertText(FTitle) + #13#10
    else                    line := line + '/Title ' + EncryptString(FTitle, FCurrObjNum) + #13#10;
  //   Subject.
  if FSubject <> '' then
    if not FEncrypted then  line := line + '/Subject ' + ConvertText(FSubject) + #13#10
    else                    line := line + '/Subject ' + EncryptString(FSubject, FCurrObjNum) + #13#10;
  line := line + '>>'#13#10'endobj'#13#10#13#10;
  AddPDFObject(line);

  // Add encryption dictionary, if necessary.
  if FEncrypted then
  begin
    encryptdictobj := FCurrObjNum;
    line := IntToStr(encryptdictobj) + ' 0 obj'#13#10;
    line := line + FEncryptDict;
    line := line + 'endobj'#13#10#13#10;
    AddPDFObject(line);
  end else
    encryptdictobj := 0; // get rid of warning.

  // Next, add the Cross-Reference table.
  startxref := AddXREFTable;

  // Now, add the Trailer section.
  line := 'trailer'#13#10'<<'#13#10'/Size ' + IntToStr(Length(FObjectPosList) + 1) + #13#10;
  if Encrypted then
  begin
    line := line + '/Root ' + IntToStr(FCurrObjNum - 3) + ' 0 R'#13#10 +
                   '/Info ' + IntToStr(FCurrObjNum - 2) + ' 0 R'#13#10;
  end else begin
    line := line + '/Root ' + IntToStr(FCurrObjNum - 2) + ' 0 R'#13#10 +
                   '/Info ' + IntToStr(FCurrObjNum - 1) + ' 0 R'#13#10;
  end;
  // Add document ID - Just a GUID.
  line := line + '/ID [ <' + FDocID + '><' + FDocID + '> ]'#13#10;
  //   Add encryption dictionary reference, if necessary.
  if FEncrypted then
    line := line + '/Encrypt ' + IntToStr(encryptdictobj) + ' 0 R'#13#10;
  line := line + '>>'#13#10; // close-out trailer.
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
  tmpstr : String;
  strptr : PChar;
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
      tmpstr := Copy(StrPas(PChar(strptr)), 20, 30);
      // If '/Parent' not found, then just skip to the next object.  PDF won't work, of course!
      parentpos := pos('/Parent', tmpstr);
      if parentpos = 0 then continue;
      inc(parentpos, 26); // 20 for string offset, 6 to position it directly to the placeholder.
      // Position stream to start of placeholder.
      tmpstr := Format('%.4d', [ParentObjNum]);
      FPDFStream.Seek(objstart + parentpos, soFromBeginning);
      // Write out the new object number.  Should always be 4 characters.
      FPDFStream.Write(PChar(tmpstr)^, 4);
    end;
  finally
    FPDFStream.Seek(0, soFromEnd);
  end;
end;


function TDF6toPDFConverter.EncryptString(const Source: String; const Objnum: Integer): String;
{$IFDEF ENCRYPTION}
var
  MD5 : THash_MD5;
  RC4 : TCipher_RC4;
  digestbuf : Array[0..15] of Byte;
  ivector : Array[0..31] of Byte;
  ivecptr : Pointer;
{$ENDIF}
begin
{$IFDEF ENCRYPTION}
  // This function will encrypt the source string and convert the encrypted
  //   results to a PDF hexadecimal string.  The object # is required, as is a
  //   valid encryption key.  This should already be available.  The generation # is 0.

  // Initialize IVector for encryption.  Important to use a 0 IVector.
  FillChar(ivector, 32, $00);
  ivecptr := @ivector;

  MD5 := nil;
  RC4 := nil;
  try
    MD5 := THash_MD5.Create(nil);
    RC4 := TCipher_RC4.Create('', nil);
    RC4.Mode := cmECB; // Very important!
    // Copy the master key to our hash buffer.
    move(FEncryptKey, digestbuf, 5);
    // step 2 (alg. 3.1; section 3.5.1 in docs)
    digestbuf[5] := (Objnum and $0000FF);
    digestbuf[6] := (Objnum and $00FF00) shr 8;
    digestbuf[7] := (Objnum and $FF0000) shr 16;
    digestbuf[8] := $00; // Generation # = 0.
    digestbuf[9] := $00; // Generation # = 0.
    // step 3
    MD5.Init;
    MD5.Calc(digestbuf, 10);
    MD5.Done;
    // step 4
    //   It says to use (n + 5), which is 10, so.... Even though that's 80 bits,
    //   The extra 40 are "salt" and don't really add to the complexity, AFAIK.
    RC4.Init(MD5.DigestKey^, 10, ivecptr);
    // Now, encrypt the string and return the result.
    Result := RC4.EncodeString(Source);
    Result := '<' + GetHexStringFromData(PChar(result)^, Length(result)) + '>';
  finally
    MD5.Free;
    RC4.Free;
  end;
{$ELSE}
  Result := Source;
{$ENDIF}
end;


procedure TDF6toPDFConverter.EncryptStream(InStream, EncryptedStream: TMemoryStream; const Objnum : Integer);
{$IFDEF ENCRYPTION}
var
  MD5 : THash_MD5;
  RC4 : TCipher_RC4;
  digestbuf : Array[0..15] of Byte;
  ivector : Array[0..31] of Byte;
  ivecptr : Pointer;
{$ENDIF}
begin
{$IFDEF ENCRYPTION}
  // This function will encrypt the incoming stream and save the results to the
  //   encrypted stream.  The object # is required, as is a valid encryption
  //   key.  This should already be available.  The generation # is 0.

  // Initialize IVector for encryption.  Important to use a 0 IVector.
  FillChar(ivector, 32, $00);
  ivecptr := @ivector;

  MD5 := nil;
  RC4 := nil;
  try
    MD5 := THash_MD5.Create(nil);
    RC4 := TCipher_RC4.Create('', nil);
    RC4.Mode := cmECB; // Very important!
    // Copy the master key to our hash buffer.
    move(FEncryptKey, digestbuf, 5);
    // step 2 (alg. 3.1; section 3.5.1 in docs)
    digestbuf[5] := (Objnum and $0000FF);
    digestbuf[6] := (Objnum and $00FF00) shr 8;
    digestbuf[7] := (Objnum and $FF0000) shr 16;
    digestbuf[8] := $00; // Generation # = 0.
    digestbuf[9] := $00; // Generation # = 0.
    // step 3
    MD5.Init;
    MD5.Calc(digestbuf, 10);
    MD5.Done;
    // step 4
    //   It says to use (n + 5), which is 10, so.... Even though that's 80 bits,
    //   The extra 40 are "salt" and don't really add to the complexity, AFAIK.
    RC4.Init(MD5.DigestKey^, 10, ivecptr);
    //   Don't forget to rewind the streams, first, or else it won't work.
    InStream.Seek(0, soFromBeginning);
    EncryptedStream.Seek(0, soFromBeginning);
    // Now, encrypt the entire stream and write it to the output.
    RC4.EncodeStream(InStream, EncryptedStream, InStream.Size);
  finally
    MD5.Free;
    RC4.Free;
  end;
{$ELSE}
  InStream.Seek(0, soFromBeginning);
  EncryptedStream.Seek(0, soFromBeginning);
  EncryptedStream.CopyFrom(InStream, InStream.Size);
{$ENDIF}
end;

procedure TDF6toPDFConverter.MakeEncryptionDictionary;
{$IFDEF ENCRYPTION}
  function  PadPasswordString(const starting : String) : String;
  var
    I, len : Integer;
  begin
    // Pad/Truncate per docs.
    result := starting;
    len := Length(result);
    if Length(result) <> 32 then SetLength(result, 32);
    if len = 32 then Exit;
    for I := len to 31 do
      result[I + 1] := Char(PWD_INIT[I - len]); // right-pad from beginning of table.
  end;

var
  I : Integer;
  accessRights : Cardinal;
  tmpstr, userpwd, Ostring : String;
  MD5 : THash_MD5;
  RC4 : TCipher_RC4;
  inbuf, outbuf : Array[0..83] of Byte; // max size.
  ivector : Array[0..31] of Byte;
  ivecptr : Pointer;
{$ENDIF}
begin
{$IFDEF ENCRYPTION}
  // Start encryption dictionary.
  FEncryptDict := '<<'#13#10;

  // Initialize IVector for encryption.
  FillChar(ivector, 32, $00);
  ivecptr := @ivector;
  // Create encryption objects and create encrypted owner/user password strings.
  MD5 := nil;
  RC4 := nil;
  try
    MD5 := THash_MD5.Create(nil);
    RC4 := TCipher_RC4.Create('', nil);
    RC4.Mode := cmECB; // Very important!

    FEncryptDict := FEncryptDict +
      '/Filter /Standard'#13#10 + // Standard security handler.
      '/V 1'#13#10 + // Specify encryption alg.  1 = RC4,MD5,40-bits.  See docs.
      '/R 2'#13#10 + // Security handler rev.
      '/Length 40'#13#10; // Key length.

    // Compute access rights value.  See Table 3.15 in spec.
    accessRights := $FFFFFFC0; // base value.  Our values change only the 1st 6 bits. (FFFFF0C0)
    if pdfPrint in FPDFAccessRights then
      accessRights := accessRights or $00000004;
    if pdfModify in FPDFAccessRights then
      accessRights := accessRights or $00000008;
    if pdfExtract in FPDFAccessRights then
      accessRights := accessRights or $00000010;

    // Now, compute the Owner and User encrypted strings.
    // Start with Owner password.
    if FOwnerPassword <> '' then // Step 1; Section 3.5.2; Algorithm 3.3
    begin
      tmpstr  := PadPasswordString(FOwnerPassword);
      userpwd := PadPasswordString(FUserPassword);
    end else begin
      tmpstr  := PadPasswordString(FUserPassword);
      userpwd := tmpstr;
    end;
    //   step 2
    MD5.Init;
    MD5.Calc(PChar(tmpstr)^, 32);
    MD5.Done;
    //   step 4 (step 3 = n/a) (moved RC4.Init call to step 6)
    FillChar(outbuf, 84, 0);
    //   step 5 (pad the user password.  Done above.)
    //   step 6
    RC4.Init(MD5.DigestKey^, 5, ivecptr); // 5 byte key size. *
    RC4.EncodeBuffer(PChar(userpwd)^, outbuf, 32);
    Setlength(Ostring, 32);
    for I := 0 to 31 do Ostring[I + 1] := char(outbuf[I]);
    tmpstr := GetHexStringFromData(PChar(Ostring)^, 32); // Convert to hex string.
    //   step 8 (step 7 = n/a)
    FEncryptDict := FEncryptDict + '/O <' + tmpstr + '>'#13#10;

    // Now, create User password string.
    //   step 1-1
    tmpstr := PadPasswordString(FUserPassword);
    //   step 1-2
    MD5.Init;
    move(PChar(tmpstr)^, inbuf, 32); // accumulate to buffer used in hash.
    //   step 1-3
    move(PChar(Ostring)^, inbuf[32], 32); // accumulate to buffer used in hash.
    //   step 1-4
    inbuf[64] := accessRights and $000000FF;
    inbuf[65] := (accessRights and $0000FF00) shr 8;
    inbuf[66] := (accessRights and $00FF0000) shr 16;
    inbuf[67] := (accessRights and $FF000000) shr 24;
    //   step 1-5
    //   accumulate the document ID to the hash buffer, as bytes.
    for I := 0 to 15 do inbuf[68 + I] := StrToInt('$' + Copy(FDocID, I * 2 + 1, 2));
    MD5.Calc(inbuf, 84);
    MD5.Done;
    //   step 1-7 (step 1-6 = n/a)
    //     This is the base encryption key to be used throughout the PDF
    //     creation process to encrypt streams (and strings if desired).
    move(MD5.DigestKey^, FEncryptKey, 5);
    RC4.Init(FEncryptKey, 5, ivecptr);
    //   step 2
    FillChar(inbuf, 84, 0);
    move(PWD_INIT, inbuf, 32); // copy padding string.
    RC4.EncodeBuffer(inbuf, outbuf, 32);
    //   step 3
    Setlength(userpwd, 32);
    for I := 0 to 31 do userpwd[I + 1] := char(outbuf[I]);
    tmpstr := GetHexStringFromData(PChar(userpwd)^, 32); // Convert to hex string.
    //   step 8 (step 7 = n/a)
    FEncryptDict := FEncryptDict + '/U <' + tmpstr + '>'#13#10;

    // Finally, add access permission info.
    FEncryptDict := FEncryptDict + '/P ' + IntToStr(Integer(accessRights)) + #13#10;
  finally
    MD5.Free;
    RC4.Free;
  end;

  // Close-out encryption dictionary.
  FEncryptDict := FEncryptDict + '>>'#13#10;
{$ENDIF}
end;

procedure TDF6toPDFConverter.SetIDstring;
var
  tmpstr : String;
  guid : TGuid;

  function GetHexStringFromData(const Data; len : Integer) : String;
  var
    I : Integer;
    P : PByte;
  begin
    result := '';
    P := PByte(Longint(@Data) + 1);
    Dec(P);
    for I := 0 to len - 1 do
    begin
      result := result + IntToHex(P^, 2);
      Inc(P);
    end;
  end;

  function GetHexStringFromString(const str : String) : String;
  var
    I : Integer;
  begin
    result := '';
    for I := 1 to Length(str) do result := result + IntToHex(Byte(str[I]), 2);
  end;

begin
  if CreateGUID(guid) = 0 then
    tmpstr := GetHexStringFromData(guid, 16)
  else
    tmpstr := GetHexStringFromString('CouldNotCreateID');

  FDocID := tmpstr; // Set global document ID.  Should only be set once.
end;

class function TDF6toPDFConverter.GetHexStringFromData(const Data; len : Integer) : String;
var
  I : Integer;
  P : PByte;
begin
  result := '';
  P := PByte(Longint(@Data) + 1);
  Dec(P);
  for I := 0 to len - 1 do
  begin
    result := result + IntToHex(P^, 2);
    Inc(P);
  end;
end;

end.

// PDF-generated layout.
// Header
//   PDF Signature.
//   Fonts       = ... (Currently, 6 objects)

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
//   Pages Tree  = f
//   Catalog     = f + 1
//   Encryption  = f + 2 (if present).

// Final:
//   Optional Creation Info. Object.
//   XREF Table
//   Trailer (Includes encryption dictionary, if present)
//   Start XREF.
//   EOF Signature.

