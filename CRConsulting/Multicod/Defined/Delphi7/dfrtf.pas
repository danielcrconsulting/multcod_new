unit dfRTF;

interface

{$WEAKPACKAGEUNIT ON}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dfClasses;

  procedure DFToRTF(FormEngine: TDFEngine; const DestRTFFile: string);

//function BinToHex(const Buffer : PChar; len, linelen: integer): String;
  function BinToHex(const Buffer : PAnsiChar; len, linelen: integer): String;
  function MetafileToRTF(Metafile : TMetaFile; Scale : integer; IncludeEMF : boolean) : string;
  function MakeRTFfromMetafile(Metafile: TMetaFile; Scale: integer;
    IncludeEMF, Append: boolean; RTF : string): string;

implementation

// RTF FUNCTIONS by Paul Shoener

function BinToHex(const Buffer : PAnsiChar; len, linelen: integer): String;
const
  HexTable : array[0..15] of Char =
    ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
  tmpptr : PAnsiChar;
  tmpbyte : Byte;
  i, ctr : integer;
begin
  result := '';
  tmpptr := Buffer;
  ctr := 0;
  linelen := linelen div 2;

  for i := 1 to len do
  begin
    tmpbyte := Byte(tmpptr^);
    result := result + HexTable[(tmpbyte and $F0) shr 4];
    result := result + HexTable[(tmpbyte and $0F)];
    inc(ctr);
    inc(Cardinal(tmpptr));
    if ctr < linelen then continue;
    result := result + #13#10;
    ctr := 0;
  end;
end;

function  MetafileToRTF(Metafile : TMetaFile; Scale : integer; IncludeEMF : boolean) : string;
var
  WMFonly : boolean;
  datasize : integer;
  hexdatastr : string;
  MStream : TMemoryStream;
  tmpMeta : TMetaFile;

  function  AddEMFTags : String;
  begin
    result := '{\*\shppict' +
              '{\pict' +
              '\picscalex' + inttostr(Scale) +
              '\picscaley' + inttostr(Scale) +
              '\picw' + inttostr(tmpMeta.MMWidth) +
              '\pich' + inttostr(tmpMeta.MMHeight) +
              '\emfblip'#13#10;
  end;

  function  GetWMFUnitsPerInch : integer;
  begin
    result := PSmallint((Cardinal(MStream.Memory) + 14))^;
  end;

  function  AddWMFOnlyTags : String;
  var
    DPI : integer;
  begin
    DPI := GetWMFUnitsPerInch;
    result := '{\pict' +
              '\picscalex' + inttostr(Scale) +
              '\picscaley' + inttostr(Scale) +
              '\picw' + inttostr(tmpMeta.MMWidth) +
              '\pich' + inttostr(tmpMeta.MMHeight) +
              '\picwgoal' + inttostr(Trunc(tmpMeta.Width / DPI * 1440)) +
              '\pichgoal' + inttostr(Trunc(tmpMeta.Height / DPI * 1440)) +
              '\wmetafile8'#13#10;
  end;

  function  AddWMFTags : String;
  var
    DPI : integer;
  begin
    DPI := GetWMFUnitsPerInch;
    result := '{\nonshppict' +
              '{\pict' +
              '\picscalex' + inttostr(Scale) +
              '\picscaley' + inttostr(Scale) +
              '\picw' + inttostr(tmpMeta.MMWidth) +
              '\pich' + inttostr(tmpMeta.MMHeight) +
              '\picwgoal' + inttostr(Trunc(tmpMeta.Width / DPI * 1440)) +
              '\pichgoal' + inttostr(Trunc(tmpMeta.Height / DPI * 1440)) +
              '\wmetafile8'#13#10;
  end;

{  procedure formatHexString(var HexStr : string);
  var
    chunks, i : integer;
  begin
    chunks := (datasize * 2) div 128;
    for i := 1 to chunks do
    begin
      insert(#13#10, HexStr, (130 * i) - 1);
      if i mod 32 = 0 then
        Application.ProcessMessages;
    end;
  end;}

begin
  // Initialize variables.
  result := '';
  MStream := nil;
  tmpMeta := nil;
  if Scale = 0 then Scale := 70;
  try
    tmpMeta := TMetafile.Create;
    MStream := TMemoryStream.Create;
    // Make working copy of metafile.
    tmpMeta.Assign(Metafile);
    // Add EMF info if selected (and possible).
    WMFonly := not (IncludeEMF and Metafile.Enhanced);
    if not WMFonly then // Just making sure. :)
    begin
      tmpMeta.SaveToStream(MStream);
      datasize := MStream.Size;
      // Create RTF header.
      result := result + AddEMFTags;
      // Create WMF data hexadecimal string.
      SetLength(hexdatastr, datasize * 2);
      // Add CR/LF pairs every 128 characters.
      hexdatastr := BinToHex(MStream.Memory, datasize, 128);
      // Get rid of last CR/LF pair if it's the last part of the string.
      if hexdatastr[Length(hexdatastr) - 1] = #13 then
        Delete(hexdatastr, Length(hexdatastr) - 1, 2);
      // Add the hex data to our RTF string.
      result := result + hexdatastr;
      // Add closing braces for EMF.
      result := result + '}}'#13#10;
      // Clear for WMF data.
      MStream.Clear;
    end;
    // Now, save WMF data into working Metafile.
    tmpMeta.Enhanced := false;
    tmpMeta.SaveToStream(MStream);
    datasize := MStream.Size;
    hexdatastr := '';
    // Adjust for WMF header.
    dec(datasize, 22);
    // Add WMF picture tag to RTF header.
    if not WMFonly then
      result := result + AddWMFTags
    else
      result := result + AddWMFOnlyTags;
    // Create WMF data hexadecimal string.
    SetLength(hexdatastr, datasize * 2);
    // Be sure to skip the 22-byte WMF header and add CR/LF pairs every 128
    // characters.
    hexdatastr := BinToHex(Pointer((Cardinal(MStream.Memory) + 22)), datasize, 128);
    // Get rid of last CR/LF pair if it's the last part of the string.
    if hexdatastr[Length(hexdatastr) - 1] = #13 then
      Delete(hexdatastr, Length(hexdatastr) - 1, 2);
    // Add the hex data to our RTF string.
    result := result + hexdatastr;
    // Finally, add closing braces.  The CR/LF here is purely stylistic.
    if not WMFonly then // Just making sure. :)
      result := result + '}}'#13#10
    else
      result := result + '}'#13#10;
  finally
    MStream.Free;
    tmpMeta.Free;
  end;
end;

function MakeRTFfromMetafile(Metafile: TMetaFile; Scale: integer;
  IncludeEMF, Append: boolean; RTF : string): string;

  function  MakeRTFHeader :String;
  begin
    result := '{\rtf1\ansi'#13#10;
  end;

begin
  result := RTF;
  // Check for append modifications.
  if length(RTF) < 6 then Append := false
  else begin
    if Pos('{\rtf1', lowercase(Copy(RTF, 1, 6))) < 1 then Append := false;
  end;

  if Append then
  begin
    // Clip-off the closing brace.
    while (length(result) > 0) and
      ((result[length(result)] = #13) or (result[length(result)] = #10)) do
      delete(result, length(result),1);
    delete(result, length(result),1);
    result := result + '\page'#13#10;
    // Add the new metafile data to the RTF string.
    result := result + MetafileToRTF(Metafile, Scale, IncludeEMF);
    // Add-back the closing brace to the RTF.
    result := result + '}';
  end else begin
    // Make really basic header. =)
    result := MakeRTFHeader;
    // Add the metafile data to the RTF string.
    result := result + MetafileToRTF(Metafile, Scale, IncludeEMF);
    // Add the closing brace to the RTF.
    result := result + '}';
  end;
end;


//PUBLIC ACCESS FUNCTIONS

procedure DFToRTF(FormEngine: TDFEngine; const DestRTFFile: string);
var
  MF: TMetafile;
  MFC: TMetaFileCanvas;
  SL: TStringList;
  I,PageCount,ActualPage : Integer;
  Page: TDFPage;
begin
  MF:= nil;
  SL:= nil;
  MFC:= nil;
  try
    MF:= TMetafile.Create;
    SL:= TStringList.create;

    //get page count -- virtual or actual
    PageCount := FormEngine.PageCount;
    if (Assigned(FormEngine.OnPreviewPageCount)) then
      FormEngine.OnPreviewPageCount(FormEngine, PageCount);

    //export each page
    for I := 0 to PageCount - 1 do
    begin
      //get page -- virtual or actual
      if (Assigned(FormEngine.OnPreviewPageShow)) then
      begin
        ActualPage := 0;
        FormEngine.OnPreviewPageShow(FormEngine, I, ActualPage);
        Page := FormEngine.Pages[ActualPage];
      end else
        Page := FormEngine.Pages[I];

      // Clear the Metafile for each page.
      MF.Clear;
      MF.Height:= Page.Height;
      MF.Width:= Page.Width;
      // I'm handling the canvas this way, since there is no .Clear method.
      try
        MFC:= TMetafileCanvas.Create(MF,0);
        Page.PaintTo(MFC, Page.PageRect, dfDisplay);
      finally
        MFC.Free;
      end;
      MF.Enhanced:= true;
      SL.Text:= MakeRTFfromMetafile(MF, 0, true, true, SL.Text);
    end;
    SL.savetofile(DestRTFFile);
  finally
    MF.free;
    SL.free;
  end;
end;

end.
