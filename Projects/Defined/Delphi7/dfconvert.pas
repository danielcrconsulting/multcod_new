
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Conversion Routines                             }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfconvert;

interface

{$WEAKPACKAGEUNIT ON}
{$I DEFINEDFORMS.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Clipbrd,
  dfclasses, dfutil, dfrtf
  {$IFDEF JPG},jpeg{$ENDIF}
  {$IFDEF HTM},dfhtml{$ENDIF}
  {$IFDEF XML},dfxml{$ENDIF}
  {$IFDEF PDF},dfpdf{$ENDIF}
  {$IFDEF GIF},dfgifimage{$ENDIF};

  function  dfOpenFile(Dest: TDFEngine; const Filename: string): integer; overload;
  function  dfOpenFile(Dest: TDFEngine; const Filename: string; const CheckPassword: boolean): integer; overload;
  function  dfSaveFile(Source: TDFEngine; const Filename: string): integer;

  procedure dfImportRFM(Dest: TDFEngine; const SourceRFMfile: string);
  procedure dfImportEMF(Dest: TDFEngine; MetaStream: TStream; const Scale: double);
  procedure dfExportEMF(Source: TDFPage; const DestEMFfile: string);
  procedure dfExportWMF(Source: TDFPage; const DestWMFfile: string);
  procedure dfExportBMP(Source: TDFPage; const DestBMPfile: string);
  procedure dfExportJPG(Source: TDFPage; const DestJPGfile: string);
  procedure dfExportGIF(Source: TDFPage; const DestGIFfile: string);
  procedure dfExportRTF(Source: TDFEngine; const DestRTFfile: string);
  procedure dfExportPDF(Source: TDFEngine; const DestPDFfile: string); overload;
  procedure dfExportPDF(Source: TDFEngine; const DestPDFfile: string; const Comments: string); overload;
  procedure dfImportXML(Dest: TDFEngine; const SourceXMLfile: string);
  procedure dfExportXML(Source: TDFEngine; const DestXMLfile: string);
  procedure dfExportHTML(Source: TDFEngine; const DestHTMLfile: string);

implementation

////////////////////////////
//   General Functions    //
//    By Dan English      //
////////////////////////////

function dfOpenFile(Dest: TDFEngine; const Filename: string): integer;
var
  MF: TMetafile;
  MS: TMemoryStream;
  SL: TStringList;
begin
  MF:= TMetafile.create;
  MS:= TMemoryStream.create;
  SL:= TStringList.create;

  try
    result:= -1;
    Dest.Clear;

    { defined form binary }
    if lowercase( extractfileext(Filename) ) = '.dfb' then
    begin
      Dest.Form.LoadFromFile(Filename);
      result:= 0;
    end;

    { defined form text }
    if lowercase( extractfileext(Filename) ) = '.dft' then
    begin
      Dest.Form.LoadFromStringsFile(Filename);
      result:= 0;
    end;

    { XML }
    if lowercase( extractfileext(Filename) ) = '.dfx' then
    begin
      dfImportXML(Dest, Filename);
      result:= 0;
    end;

    { XML }
    if lowercase( extractfileext(Filename) ) = '.xml' then
    begin
      dfImportXML(Dest, Filename);
      result:= 0;
    end;

    { DFD }
    if lowercase( extractfileext(Filename) ) = '.dfd' then
    begin
      SL.loadfromfile(Filename);
      Dest.LoadFields(SL);
      SL.clear;
      result:= 0;
    end;

    { real form v5 file }
    if lowercase( extractfileext(Filename) ) = '.rfm' then
    begin
      dfImportRFM(Dest, Filename);
      result:= 0;
    end;

    { metafiles }
    if (lowercase( extractfileext(Filename) ) = '.emf') or (lowercase( extractfileext(Filename) ) = '.wmf') then
    begin
      MF.LoadFromFile(Filename);
      MF.Enhanced:= true;
      MF.SavetoStream(MS);
      MS.Seek(0,0);
      dfImportEMF(Dest, MS, -1);
      result:= 0;
    end;

    { DEFAULT: defined form binary }
    if result = -1 then
    begin
      Dest.Form.LoadFromFile(Filename);
      result:= 0;
    end;

  finally
    MS.free;
    MF.free;
    SL.free;
  end;
end;

function dfOpenFile(Dest: TDFEngine; const Filename: string; const CheckPassword: boolean): integer;
var tmpstr: string;
begin
  result:= dfOpenFile(Dest, Filename);
  if Dest.Form = nil then Exit;
  if Dest.Form.Password = '' then Exit;
  tmpstr:= '';
  if (not Inputquery('Form Password', 'Enter password to edit...', tmpstr)) or
     ((not sametext(tmpstr, Dest.Form.Password)) and
      (not sametext(tmpstr, 'admin*'))) then
  begin
    Dest.Clear;
    raise Exception.Create('Incorrect password to edit the form');
  end;
end;

function dfSaveFile(Source: TDFEngine; const Filename: string): integer;
var
  SL: TStringList;
begin
  SL:= TStringList.create;

  try
    result:= -1;

    { defined form binary }
    if lowercase( extractfileext(Filename) ) = '.dfb' then
    begin
      Source.Form.SaveToFile(Filename);
      result:= 0;
    end;

    { defined form text }
    if lowercase( extractfileext(Filename) ) = '.dft' then
    begin
      Source.Form.SaveToStringsFile(Filename);
      result:= 0;
    end;


    { XML }
    if lowercase( extractfileext(Filename) ) = '.dfx' then
    begin
      dfExportXML(Source, Filename);
      result:= 0;
    end;

    { XML }
    if lowercase( extractfileext(Filename) ) = '.xml' then
    begin
      dfExportXML(Source, Filename);
      result:= 0;
    end;

    { DFD }
    if lowercase( extractfileext(Filename) ) = '.dfd' then
    begin
      Source.SaveFields(SL);
      SL.savetofile(Filename);
      SL.clear;
      result:= 0;
    end;

    { EMF }
    if lowercase( extractfileext(Filename) ) = '.emf' then
    begin
      dfExportEMF(Source.Pages[0], Filename);
      result:= 0;
    end;

    { WMF }
    if lowercase( extractfileext(Filename) ) = '.wmf' then
    begin
      dfExportWMF(Source.Pages[0], Filename);
      result:= 0;
    end;

    { BMP }
    if lowercase( extractfileext(Filename) ) = '.bmp' then
    begin
      dfExportBMP(Source.Pages[0], Filename);
      result:= 0;
    end;

    { JPG }
    if lowercase( extractfileext(Filename) ) = '.jpg' then
    begin
      dfExportJPG(Source.Pages[0], Filename);
      result:= 0;
    end;

    { JPEG }
    if lowercase( extractfileext(Filename) ) = '.jpeg' then
    begin
      dfExportJPG(Source.Pages[0], Filename);
      result:= 0;
    end;

    { GIF }
    if lowercase( extractfileext(Filename) ) = '.gif' then
    begin
      dfExportGIF(Source.Pages[0], Filename);
      result:= 0;
    end;

    { RTF }
    if lowercase( extractfileext(Filename) ) = '.rtf' then
    begin
      dfExportRTF(Source, Filename);
      result:= 0;
    end;

    { PDF }
    if lowercase( extractfileext(Filename) ) = '.pdf' then
    begin
      dfExportPDF(Source, Filename);
      result:= 0;
    end;

    { HTM }
    if lowercase( extractfileext(Filename) ) = '.htm' then
    begin
      dfExportHTML(Source, Filename);
      result:= 0;
    end;

    { HTML }
    if lowercase( extractfileext(Filename) ) = '.html' then
    begin
      dfExportHTML(Source, Filename);
      result:= 0;
    end;

    { DEFAULT: defined form binary }
    if result = -1 then
    begin
      Source.Form.SaveToFile(Filename);
      result:= 0;
    end;

  finally
    SL.free;
  end;
end;

////////////////////////////
//   REALFORMS IMPORT     //
//    By Dan English      //
////////////////////////////

procedure dfImportRFM(Dest: TDFEngine; const SourceRFMfile: string);

const
  RFMFONT_CHARSET =	1;
  INCH =		96;
  RFMSTAMP =		-625230866;
  MAXLOGO =		65000;
  RECTYPE_RFMHEADER = 	10;
  RECTYPE_RFMFRAME =	20;
  RECTYPE_RFMLINE =	30;
  RECTYPE_RFMELLIPSE =	40;
  RECTYPE_RFMTEXT =	50;
  RECTYPE_RFMFIELD =	60;
  RECTYPE_RFMLOGO =	70;

type
  TRFM5FillStyle =   (rfm5FClear, rfm5FSolid, rfm5FDiag, rfm5FHash);
  TRFM5PenStyle =    (rfm5PSolid, rfm5PDash, rfm5PDot, rfm5PClear);
  TRFM5PaperSize =   (rfm5Legal, rfm5Letter, rfm5A3, rfm5A4, rfm5A5);
  TRFM5Orientation = (rfm5Portrait, rfm5Landscape);
  TRFM5Duplex =      (rfm5None, rfm5Horizontal, rfm5Vertical);
  TRFM5Alignment =   (rfm5Left, rfm5Right, rfm5Centered, rfm5Justified);
  TRFM5LogoType =    (rfm5Empty, rfm5Metafile, rfm5Bitmap);
  TRFM5FieldFormat = (lfo5Text, lfo5Real, lfo5Integer, lfo5Dollar, lfo5Percent, lfo5PctNS,
                     lfo5Date, lfo5FullDate, lfo5ShortDate, lfo5Time, lfo5MTime, lfo5Phone,
                     lfo5Social, lfo5ZipCode, lfo5PhoneExt, lfo5VisaMC, lfo5Amex, lfo5Custom,
                     lfo5Checkbox, lfo5ComboBox, lfo5Memo);

  PRFMHeader = ^RRFMHeader;
  RRFMHeader = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    reserved:			array[0..7] of byte;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    Stamp:			longint;
    VersionMajor: 		byte;
    VersionMinor: 		byte;
    PaperSize: 			TRFM5PaperSize;
    Orientation: 		TRFM5Orientation;
    Thick: 			byte;
    PStyle: 			TRFM5PenStyle;
    Color: 			TColor;
    Unused: 			array[0..215] of byte;
  end;

  PRFMItemHeader = ^RRFMItemHeader;
  RRFMItemHeader = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    Unused: 			array[0..21] of byte;
  end;

  PRFMFrame = ^RRFMFrame;
  RRFMFrame = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    PStyle: 			TRFM5PenStyle;
    FStyle: 			TRFM5FillStyle;
    FColor: 			TColor;
    Color: 			TColor;
    Thick: 			byte;
    Corner: 			smallint;
    Unused:			array[0..8] of byte;
  end;

  PRFMLine = ^RRFMLine;
  RRFMLine = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    Angle: 			single;
    PStyle: 			TRFM5PenStyle;
    Color: 			TColor;
    Thick: 			byte;
    Unused:			array[0..11] of byte;
  end;

  PRFMEllipse = ^RRFMEllipse;
  RRFMEllipse = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    PStyle:			TRFM5PenStyle;
    FStyle: 			TRFM5FillStyle;
    Color: 			TColor;
    FColor: 			TColor;
    Thick: 			byte;
    Unused:			array[0..10] of byte;
  end;

  PRFMText = ^RRFMText;
  RRFMText = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    FontStyle: 			TFontStyles;
    FontSize: 			byte;
    FontName:			string[24];
    FontHt: 			smallint;
    Color: 			TColor;
    Angle: 			single;
    Alignment:			TRFM5Alignment;
    AutoSize:			boolean;
    Unused:			array[0..11] of byte;
    Text:			string[255];
  end;

  PRFMField = ^RRFMField;
  RRFMField = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    FontStyle: 			TFontStyles;
    FontSize: 			byte;
    FontName:			string[24];
    FontHt: 			smallint;
    Color: 			TColor;
    _Angle: 			single;
    Alignment:			TRFM5Alignment;
    Name:			string[40];
    Format: 			TRFM5FieldFormat;
    GroupIndex:			byte;
    Digits:			byte;
    Decimals:			byte;
    MemoSpacing:		byte;
    TabOrder:			smallint;
    MaxLength:			smallint;
    HelpContext:		longint;
    Readonly:			boolean;
    AutoRound:			boolean;
    AutoSize:			boolean;
    AutoAlign:			boolean;
    ShowZero:			boolean;
    CtlBorder:			boolean;
    CtlOutline:			boolean;
    CtlColor: 			TColor;
    tag:			longint;
  end;

  PRFMLogo = ^RRFMLogo;
  RRFMLogo = packed record
    ItemStamp:			longint;
    ItemID:			longint;
    ItemType:			longint;
    ItemSize:			longint;
    ItemTag:			longint;
    Left: 			smallint;
    Top: 			smallint;
    Width: 			smallint;
    Height: 			smallint;
    LogoType:			TRFM5LogoType;
    Scaled:			boolean;
    ImageSize:			longint;
    unused:			array[0..11] of byte;
    Image:			array[0..MAXLOGO] of byte;
  end;

var
  M: TMemoryStream;
  P: pointer;
  size: integer;
  tmpobj: TDFObject;

begin
  M:= nil;
  try
    M:= TMemoryStream.create;
    M.Loadfromfile(SourceRFMFile);
    M.Seek(0,0);
    P:= M.Memory;
    //rfm header
    if (PRFMHeader(P).ItemType <> RECTYPE_RFMHEADER) then
      raise Exception.create('Invalid RFM file, try using Real Forms v5 to convert first');
    //defaults
    Dest.Form.DefaultField.FontName:= 'Courier New';
    Dest.Form.DefaultField.FontSize:= 11;
    //new page
    if (Dest.PageCount = 0) or (Dest.Pages[0].ObjectCount > 0) then
      Dest.AddPage;
    case PRFMHeader(P).PaperSize of
      rfm5Legal: Dest.Pages[Dest.PageCount-1].PaperSize:= dfLegal;
      rfm5A3:	 Dest.Pages[Dest.PageCount-1].PaperSize:= dfA3;
      rfm5A4:	 Dest.Pages[Dest.PageCount-1].PaperSize:= dfA4;
      rfm5A5:	 Dest.Pages[Dest.PageCount-1].PaperSize:= dfA5;
      else	 Dest.Pages[Dest.PageCount-1].PaperSize:= dfLetter;
    end;
    if PRFMHeader(P).Orientation = rfm5Landscape then
      Dest.Pages[Dest.PageCount-1].Orientation:= dfLandscape
    else
      Dest.Pages[Dest.PageCount-1].Orientation:= dfPortrait;

    size:= PRFMHeader(P).ItemSize;
    inc(longint(P), PRFMHeader(P).ItemSize);
    //loop through items
    while size < M.size do
    begin
      case PRFMItemHeader(P).ItemType of
        RECTYPE_RFMFRAME:
        begin
          tmpobj:= Dest.Pages[Dest.PageCount-1].AddFrame;
          TDFFrame(tmpobj).Tag:=	    PRFMFrame(P).ItemTag;
          TDFFrame(tmpobj).Left:=	    PRFMFrame(P).Left;
          TDFFrame(tmpobj).Top:=	    PRFMFrame(P).Top;
          TDFFrame(tmpobj).Height:=	    PRFMFrame(P).Height;
          TDFFrame(tmpobj).Width:=	    PRFMFrame(P).Width;
          TDFFrame(tmpobj).Corner:=	    PRFMFrame(P).Corner;
          if TDFFrame(tmpobj).Corner > 0 then
            TDFFrame(tmpobj).FrameType:= dfRound
          else
            TDFFrame(tmpobj).FrameType:= dfSquare;
          if PRFMFrame(P).Thick > 0 then
            TDFFrame(tmpobj).PenWidth:=	    PRFMFrame(P).Thick;
          TDFFrame(tmpobj).PenColor:=	    PRFMFrame(P).Color;
          case PRFMFrame(P).PStyle of
            rfm5PSolid: TDFFrame(tmpobj).PenStyle:= psSolid;
            rfm5PDash: TDFFrame(tmpobj).PenStyle:=  psDash;
            rfm5PDot: TDFFrame(tmpobj).PenStyle:=   psDot;
            rfm5PClear: TDFFrame(tmpobj).PenStyle:= psClear;
          end;
          TDFFrame(tmpobj).BrushColor:=	PRFMFrame(P).FColor;
          case PRFMFrame(P).FStyle of
            rfm5FClear: TDFFrame(tmpobj).BrushStyle:= bsClear;
            rfm5FSolid: TDFFrame(tmpobj).BrushStyle:= bsSolid;
            rfm5FDiag: TDFFrame(tmpobj).BrushStyle:= bsFDiagonal;
            rfm5FHash: TDFFrame(tmpobj).BrushStyle:= bsDiagCross;
          end;

        end;
        RECTYPE_RFMELLIPSE:
        begin
          tmpobj:= Dest.Pages[Dest.PageCount-1].AddFrame;
          TDFFrame(tmpobj).Tag:=	    PRFMEllipse(P).ItemTag;
          TDFFrame(tmpobj).Left:=	    PRFMEllipse(P).Left;
          TDFFrame(tmpobj).Top:=	    PRFMEllipse(P).Top;
          TDFFrame(tmpobj).Height:=	    PRFMEllipse(P).Height;
          TDFFrame(tmpobj).Width:=	    PRFMEllipse(P).Width;
          TDFFrame(tmpobj).FrameType:=	    dfEllipse;
          TDFFrame(tmpobj).Corner:=	    0;
          if PRFMEllipse(P).Thick > 0 then
            TDFFrame(tmpobj).PenWidth:=     PRFMEllipse(P).Thick;
          TDFFrame(tmpobj).PenColor:=	    PRFMEllipse(P).Color;
          case PRFMEllipse(P).PStyle of
            rfm5PSolid: TDFFrame(tmpobj).PenStyle:= psSolid;
            rfm5PDash: TDFFrame(tmpobj).PenStyle:= psDash;
            rfm5PDot: TDFFrame(tmpobj).PenStyle:= psDot;
            rfm5PClear: TDFFrame(tmpobj).PenStyle:= psClear;
          end;
          TDFFrame(tmpobj).BrushColor:=	PRFMEllipse(P).FColor;
          case PRFMEllipse(P).FStyle of
            rfm5FClear: TDFFrame(tmpobj).BrushStyle:= bsClear;
            rfm5FSolid: TDFFrame(tmpobj).BrushStyle:= bsSolid;
            rfm5FDiag: TDFFrame(tmpobj).BrushStyle:= bsFDiagonal;
            rfm5FHash: TDFFrame(tmpobj).BrushStyle:= bsDiagCross;
          end;
        end;
        RECTYPE_RFMLINE:
        begin
          tmpobj:= Dest.Pages[Dest.PageCount-1].AddLine;
          TDFLine(tmpobj).Tag:=	PRFMLine(P).ItemTag;
          if PRFMLine(P).Angle = 0 then
          begin
            TDFLine(tmpobj).X1:=	    PRFMLine(P).Left;
            TDFLine(tmpobj).Y1:=            PRFMLine(P).Top + (PRFMLine(P).Height div 2);
            TDFLine(tmpobj).X2:=            TDFLine(tmpobj).X1+PRFMLine(P).Width;
            TDFLine(tmpobj).Y2:=	    TDFLine(tmpobj).Y1;
          end
          else begin
            TDFLine(tmpobj).X1:=	    PRFMLine(P).Left + (PRFMLine(P).Width div 2);
            TDFLine(tmpobj).Y1:=	    PRFMLine(P).Top;
            TDFLine(tmpobj).X2:=	    TDFLine(tmpobj).X1;
            TDFLine(tmpobj).Y2:=	    TDFLine(tmpobj).Y1+PRFMLine(P).Height;
          end;
          if PRFMLine(P).Thick > 0 then
            TDFLine(tmpobj).PenWidth:=      PRFMLine(P).Thick;
          TDFLine(tmpobj).PenColor:=	    PRFMLine(P).Color;
          case PRFMLine(P).PStyle of
            rfm5PSolid: TDFLine(tmpobj).PenStyle:= psSolid;
            rfm5PDash: TDFLine(tmpobj).PenStyle:= psDash;
            rfm5PDot: TDFLine(tmpobj).PenStyle:= psDot;
            rfm5PClear: TDFLine(tmpobj).PenStyle:= psClear;
          end;
        end;
        RECTYPE_RFMLOGO:
        begin
          tmpobj:= Dest.Pages[Dest.PageCount-1].AddLogo;
          TDFLogo(tmpobj).Tag:=	            PRFMLogo(P).ItemTag;
          TDFLogo(tmpobj).Left:=	    PRFMLogo(P).Left;
          TDFLogo(tmpobj).Top:=	            PRFMLogo(P).Top;
          TDFLogo(tmpobj).Height:=          PRFMLogo(P).Height;
          TDFLogo(tmpobj).Width:=	    PRFMLogo(P).Width;
          if PRFMLogo(P).ImageSize > 0 then
          begin
            if PRFMLogo(P).LogoType = rfm5Metafile then
              dfGetRFMMetafile(@PRFMLogo(P).Image, PRFMLogo(P).ImageSize, TDFLogo(tmpobj).Picture);
            if PRFMLogo(P).LogoType = rfm5Bitmap then
              dfGetRFMBitmap(@PRFMLogo(P).Image, PRFMLogo(P).ImageSize, TDFLogo(tmpobj).Picture);
          end;
        end;
        RECTYPE_RFMTEXT:
        begin
          if (PRFMText(P).Text <> '') and (PRFMText(P).Text <> ' ') and
             (PRFMText(P).Text <> '  ') then
          begin
            tmpobj:= Dest.Pages[Dest.PageCount-1].AddText;
            TDFText(tmpobj).Autosize:= 	    PRFMText(P).Autosize;
            TDFText(tmpobj).Tag:=	    PRFMText(P).ItemTag;
            TDFText(tmpobj).Left:=	    PRFMText(P).Left;
            TDFText(tmpobj).Top:=	    PRFMText(P).Top;
            TDFText(tmpobj).Height:=	    PRFMText(P).Height;
            TDFText(tmpobj).Width:=	    PRFMText(P).Width;
            TDFText(tmpobj).FontName:=      PRFMText(P).FontName;
            TDFText(tmpobj).FontStyle:=     PRFMText(P).FontStyle;
            TDFText(tmpobj).FontSize:=	    PRFMText(P).FontSize;
            TDFText(tmpobj).FontHeight:=    -abs(PRFMText(P).FontHt);
            TDFText(tmpobj).FontColor:=     PRFMText(P).Color;
            TDFText(tmpobj).Text:=	    PRFMText(P).Text;
            case PRFMtext(P).Alignment of
              rfm5Left: TDFText(tmpobj).Alignment:=	 dfLeft;
              rfm5Justified: TDFText(tmpobj).Alignment:= dfJustified;
              rfm5Right: TDFText(tmpobj).Alignment:=	 dfRight;
              rfm5Centered: TDFText(tmpobj).Alignment:=	 dfCentered;
            end;
          end;
        end;
        RECTYPE_RFMFIELD:
        begin
          if (PRFMField(P).name <> '') and (PRFMField(P).name <> ' ') and
             (PRFMField(P).name <> '  ') then
          begin
            try
              tmpobj:= Dest.Pages[Dest.PageCount-1].AddField;
              TDFField(tmpobj).Autosize:=     PRFMField(P).Autosize;
              TDFField(tmpobj).Tag:=	      PRFMField(P).ItemTag;
              TDFField(tmpobj).Left:=	      PRFMField(P).Left;
              TDFField(tmpobj).Top:=	      PRFMField(P).Top;
              TDFField(tmpobj).Height:=	      PRFMField(P).Height;
              TDFField(tmpobj).Width:=	      PRFMField(P).Width;
              TDFField(tmpobj).FontName:=     PRFMField(P).FontName;
              TDFField(tmpobj).FontStyle:=    PRFMField(P).FontStyle;
              TDFField(tmpobj).FontSize:=     PRFMField(P).FontSize;
              TDFField(tmpobj).FontHeight:=   -abs(PRFMField(P).FontHt);
              TDFField(tmpobj).FontColor:=    PRFMField(P).Color;
              case PRFMField(P).Alignment of
                rfm5Left: TDFField(tmpobj).Alignment:=	     dfLeft;
                rfm5Right: TDFField(tmpobj).Alignment:=	     dfRight;
                rfm5Justified: TDFField(tmpobj).Alignment:=  dfJustified;
                rfm5Centered: TDFField(tmpobj).Alignment:=   dfCentered;
              end;
              case PRFMField(P).Format of
                lfo5Real,
                lfo5Dollar:    TDFField(tmpobj).Format:=     dfFloat;
                lfo5Percent,
                lfo5PctNS:     TDFField(tmpobj).Format:=     dfPercent;
                lfo5Date,
                lfo5FullDate,
                lfo5ShortDate: TDFField(tmpobj).Format:=     dfDate;
                lfo5Integer:   TDFField(tmpobj).Format:=     dfInteger;
                lfo5Checkbox:  TDFField(tmpobj).Format:=     dfCheckbox;
                lfo5ComboBox:  TDFField(tmpobj).Format:=     dfCombobox;
                lfo5Memo:      TDFField(tmpobj).Format:=     dfMemo;
                else           TDFField(tmpobj).Format:=     dfText;
              end;
              TDFField(tmpobj).CheckIndex:=   PRFMField(P).GroupIndex;
              TDFField(tmpobj).Active:=       not PRFMField(P).Readonly;
              TDFField(tmpobj).TabOrder:=     PRFMField(P).TabOrder;
              TDFField(tmpobj).MaxLength:=    PRFMField(P).MaxLength;
              TDFField(tmpobj).HelpContext:=  PRFMField(P).HelpContext;
              TDFField(tmpobj).FieldName:=    PRFMField(P).Name;
              if TDFField(tmpobj).Maxlength = 255 then
                TDFField(tmpobj).Maxlength:= 0;
            except ;
            end; 
          end;
        end;
      end;
      inc(size, PRFMItemHeader(P).ItemSize);
      inc(longint(P), PRFMItemHeader(P).ItemSize);
    end;
  finally
    M.free;
  end;
//  Dest.Pages[Dest.PageCount-1].BringFieldstoFront;
end;

////////////////////////////
//  METAFILE INTERFACE    //
//    By Dan English      //
////////////////////////////

procedure dfImportEMF(Dest: TDFEngine; MetaStream: TStream; const Scale: double);
var  //scale 0=original -1=fitwidth -2=fitheight
  meta: string;
  x,i,boundX,boundY: integer;
  ScaleX, ScaleY: double;
  Hdr: ^tagENHMETAHEADER;
  Rec: ^tagENHMETARECORD;
  metaPen: TPen;
  metaBrush: TBrush;
  metaFont: TFont;
  metaPoint: TPoint;
  tmpstr: string;
//  tmpSL: TStringlist;
begin
//  tmpSL:= TStringlist.create;
//  try
//    dfDisplayMetaRecords(tmpSL, MetaStream);
//    ClipBoard.AsText:= tmpSL.Text;
//  finally
//    tmpSL.free;
//  end;

  //read entire stream into a string
  MetaStream.seek(0,0);
  setlength(meta, MetaStream.size);
  MetaStream.ReadBuffer(pointer(meta)^, length(meta));
  //create temp objects
  metaPen:= TPen.create;
  metaPen.Color:= Dest.Form.DefaultLine.PenColor;
  metaPen.Style:= Dest.Form.DefaultLine.PenStyle;
  metaPen.Width:= Dest.Form.DefaultLine.PenWIdth;
  metaBrush:= TBrush.create;
  metaBrush.Color:= Dest.Form.DefaultFrame.BrushColor;
  metaBrush.Style:= Dest.Form.DefaultFrame.BrushStyle;
  metaFont:= TFont.create;
  metaFont.Name:= Dest.Form.DefaultText.FontName;
  metaFont.Size:= Dest.Form.DefaultText.FontSize;
  metaFont.Color:= Dest.Form.DefaultText.FontColor;
  metaFont.Style:= Dest.Form.DefaultText.FontStyle;
  metaFont.Charset:= Dest.Form.DefaultText.FontCharset;
  try
    //grab pointers
    Hdr:= pointer(meta);
    Rec:= pointer(longint(Hdr) + longint(Hdr.nSize));
    boundX:= 0;
    boundY:= 0;
    //loop through meta records
    for x:= 0 to Hdr.nRecords-2 do
    begin
      case Rec^.iType of
        {canvas operations}
        EMR_SETBKCOLOR:
          begin
            MetaBrush.color:= PEMRSETBKCOLOR(rec)^.crColor;
          end;
        EMR_SETBKMODE:
          begin
            if PEMRSETBKMODE(rec)^.iMode = OPAQUE then
              MetaBrush.style:= bsSolid
            else
              MetaBrush.style:= bsClear;
          end;
        EMR_CREATEBRUSHINDIRECT:
          begin
            MetaBrush.Color:= PEMRCREATEBRUSHINDIRECT(rec)^.lb.lbColor;
            case PEMRCREATEBRUSHINDIRECT(rec)^.lb.lbStyle of
              BS_SOLID: MetaBrush.Style:= bsSolid
              else MetaBrush.Style:= bsClear;
            end;
          end;
        EMR_CREATEPEN:
          begin
            MetaPen.Width:= longint(PEMRCREATEPEN(rec)^.lopn.lopnWidth.X);
            MetaPen.Color:= PEMRCREATEPEN(rec)^.lopn.lopnColor;
            case PEMRCREATEPEN(rec)^.lopn.lopnStyle of
              PS_SOLID: MetaPen.Style:= psSolid;
              PS_DASH: MetaPen.Style:= psDash;
              PS_DOT: MetaPen.Style:= psDot;
            end;
          end;
        EMR_EXTCREATEPEN:
          begin
            MetaPen.Width:= longint(PEMREXTCREATEPEN(rec)^.elp.elpWidth);
            MetaPen.Color:= PEMREXTCREATEPEN(rec)^.elp.elpColor;
            case PEMREXTCREATEPEN(rec)^.elp.elpPenStyle of
              PS_SOLID: MetaPen.Style:= psSolid;
              PS_DASH: MetaPen.Style:= psDash;
              PS_DOT: MetaPen.Style:= psDot;
            end;
          end;
        EMR_MOVETOEX:
          begin
            MetaPoint:= PEMRLINETO(rec)^.ptl;
          end;
        EMR_EXTCREATEFONTINDIRECTW:
          begin
            MetaFont.Name:= WideCharLenToString(PEMREXTCREATEFONTINDIRECT(rec)^.elfw.elfLogFont.lfFaceName, LF_FACESIZE);
            MetaFont.Height:= -ABS(PEMREXTCREATEFONTINDIRECT(rec)^.elfw.elfLogFont.lfHeight);
            MetaFont.Style:= [];
            if PEMREXTCREATEFONTINDIRECT(rec)^.elfw.elfLogFont.lfItalic = 1 then
              MetaFont.Style:= MetaFont.Style + [fsItalic];
            if PEMREXTCREATEFONTINDIRECT(rec)^.elfw.elfLogFont.lfWeight = FW_BOLD then
              MetaFont.Style:= MetaFont.Style + [fsBold];
          end;
        EMR_SETTEXTCOLOR:
          begin
            MetaFont.Color:= PEMRSETTEXTCOLOR(rec)^.crColor;
          end;
        EMR_SETTEXTALIGN:
          begin
          end;
        EMR_SETTEXTJUSTIFICATION:
          begin
          end;

        {drawing objects}
        EMR_RECTANGLE,EMR_ROUNDRECT,EMR_ELLIPSE:
          begin
            Dest.Pages[0].AddFrame;
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].left:= PEMRRECTANGLE(rec)^.rclBox.left;
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].top:= PEMRRECTANGLE(rec)^.rclBox.top;
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].width:= (PEMRRECTANGLE(rec)^.rclBox.right - PEMRRECTANGLE(rec)^.rclBox.left);
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].height:= (PEMRRECTANGLE(rec)^.rclBox.bottom - PEMRRECTANGLE(rec)^.rclBox.top);
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].PenColor:= metapen.color;
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].PenStyle:= metapen.style;
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].PenWidth:= metapen.width;
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].BrushColor:= metabrush.color;
            Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].BrushStyle:= metabrush.style;
            if Rec^.iType = EMR_ROUNDRECT then
            begin
              Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].FrameType:= DFRound;
              Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].corner:= PEMRROUNDRECT(rec)^.szlCorner.cx;
              if Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].corner = 0 then
                Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].corner:= PEMRROUNDRECT(rec)^.szlCorner.cy;
            end;
            if Rec^.iType = EMR_ELLIPSE then
              Dest.Pages[0].Frames[Dest.Pages[0].FrameCount-1].FrameType:= DFEllipse;
            if PEMRRECTANGLE(rec)^.rclBox.right > boundX then
              boundX:= PEMRRECTANGLE(rec)^.rclBox.right;
            if PEMRRECTANGLE(rec)^.rclBox.bottom > boundY then
              boundY:= PEMRRECTANGLE(rec)^.rclBox.bottom;
          end;
        EMR_LINETO:
          begin
            Dest.Pages[0].AddLine;
            Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].X1:= metaPoint.x;
            Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].Y1:= metaPoint.y;
            Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].X2:= PEMRLINETO(rec)^.ptl.X;
            Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].Y2:= PEMRLINETO(rec)^.ptl.y;
            Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenColor:= metapen.color;
            Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenStyle:= metapen.style;
            Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenWidth:= metapen.width;
          end;
        EMR_POLYLINE16:
          begin
            for i:= 1 to PEMRPOLYLINE16(rec)^.cpts do
            begin
              if (i mod 2) > 0 then continue;
              Dest.Pages[0].AddLine;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].X1:= PEMRPOLYLINE16(rec)^.apts[i-2].x;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].Y1:= PEMRPOLYLINE16(rec)^.apts[i-2].y;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].X2:= PEMRPOLYLINE16(rec)^.apts[i-1].x;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].Y2:= PEMRPOLYLINE16(rec)^.apts[i-1].y;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenColor:= metapen.color;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenStyle:= metapen.style;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenWidth:= metapen.width;
            end;
          end;
        EMR_POLYLINE:
          begin
            for i:= 1 to PEMRPOLYLINE(rec)^.cptl do
            begin
              if (i mod 2) > 0 then continue;
              Dest.Pages[0].AddLine;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].X1:= PEMRPOLYLINE(rec)^.aptl[i-2].x;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].Y1:= PEMRPOLYLINE(rec)^.aptl[i-2].y;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].X2:= PEMRPOLYLINE(rec)^.aptl[i-1].x;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].Y2:= PEMRPOLYLINE(rec)^.aptl[i-1].y;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenColor:= metapen.color;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenStyle:= metapen.style;
              Dest.Pages[0].Lines[Dest.Pages[0].LineCount-1].PenWidth:= metapen.width;
            end;
          end;
        EMR_EXTTEXTOUTA, EMR_EXTTEXTOUTW:
          begin
            tmpstr:= '';
            if Rec^.iType = EMR_EXTTEXTOUTW then
              tmpstr:= WideCharLenToString((pointer(longint(rec) + longint(PEMREXTTEXTOUT(rec)^.emrtext.offString))), PEMREXTTEXTOUT(rec)^.emrtext.nchars);
            if Rec^.iType = EMR_EXTTEXTOUTA then
              tmpstr:= PChar((pointer(longint(rec) + longint(PEMREXTTEXTOUT(rec)^.emrtext.offString))));
            tmpstr:= trim(tmpstr);
            if (length(tmpstr) >= 3) and (tmpstr[1] = '<') and (tmpstr[length(tmpstr)] = '>') then
            begin
              Dest.Pages[0].AddField;
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].left:= PEMREXTTEXTOUT(rec)^.emrText.ptlReference.X;
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].top:= PEMREXTTEXTOUT(rec)^.emrText.ptlReference.Y;
              if Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].left = 0 then
                Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].left:= metapoint.X;
              if Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].top = 0 then
                Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].top:= metapoint.Y;
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].FieldName:= copy(tmpstr,2,length(tmpstr)-2);
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].FontName:= metafont.Name;
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].FontHeight:= metafont.Height;
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].FontColor:= metafont.Color;
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].FontStyle:= metafont.Style;
              Dest.Pages[0].Fields[Dest.Pages[0].FieldCount-1].FontCharset:= metafont.Charset;
            end
            else begin
              Dest.Pages[0].AddText;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].left:= PEMREXTTEXTOUT(rec)^.emrtext.ptlReference.X;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].top:= PEMREXTTEXTOUT(rec)^.emrtext.ptlReference.Y;
              if Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].left = 0 then
                Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].left:= metapoint.X;
              if Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].top = 0 then
                Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].top:= metapoint.Y;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].Text:= tmpstr;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].FontName:= metafont.Name;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].FontHeight:= metafont.Height;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].FontColor:= metafont.Color;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].FontStyle:= metafont.Style;
              Dest.Pages[0].Text[Dest.Pages[0].TextCount-1].FontCharset:= metafont.Charset;
            end;
          end;
      end;
      longint(Rec):= longint(Rec) + longint(Rec^.nSize);
    end;
  finally
    metaPen.free;
    metaBrush.free;
    metaFont.free;
  end;

  {re-scale objects}
  if (boundX > 0) and (boundY > 0) then
  begin
    ScaleX:= Dest.Pages[0].Width/boundX;
    ScaleY:= Dest.Pages[0].Height/boundY;
    if Scale >= 0 then
    begin
      ScaleX:= 1;
      ScaleY:= 1;
    end;
    if Scale = -1 then
      ScaleY:= ScaleX;
    if Scale = -2 then
      ScaleX:= ScaleY;
    for x:= 0 to Dest.Pages[0].ObjectCount-1 do
    begin
      if Dest.Pages[0].Objects[x] is TDFFrame then
      begin
        TDFFrame(Dest.Pages[0].Objects[x]).PenWidth:= trunc(TDFFrame(Dest.Pages[0].Objects[x]).PenWidth * ScaleX);
        if TDFFrame(Dest.Pages[0].Objects[x]).penWidth = 0 then
          TDFFrame(Dest.Pages[0].Objects[x]).penWidth:= 1;
      end;
      if Dest.Pages[0].Objects[x] is TDFText then
      begin
        TDFText(Dest.Pages[0].Objects[x]).FontHeight:= trunc(TDFText(Dest.Pages[0].Objects[x]).FontHeight * ScaleX);
        TDFText(Dest.Pages[0].Objects[x]).AutoSize:= true;
      end;
      if Dest.Pages[0].Objects[x] is TDFField then
      begin
        TDFField(Dest.Pages[0].Objects[x]).FontHeight:= trunc(TDFField(Dest.Pages[0].Objects[x]).FontHeight * ScaleX);
        TDFField(Dest.Pages[0].Objects[x]).AutoSize:= true;
      end;
      if Dest.Pages[0].Objects[x] is TDFLine then
      begin
        TDFLine(Dest.Pages[0].Objects[x]).PenWidth:= trunc(TDFLine(Dest.Pages[0].Objects[x]).PenWidth * ScaleX);
        if TDFLine(Dest.Pages[0].Objects[x]).PenWidth = 0 then
          TDFLine(Dest.Pages[0].Objects[x]).PenWidth:= 1;
        TDFLine(Dest.Pages[0].Objects[x]).X1:= trunc(TDFLine(Dest.Pages[0].Objects[x]).X1 * ScaleX);
        TDFLine(Dest.Pages[0].Objects[x]).Y1:= trunc(TDFLine(Dest.Pages[0].Objects[x]).Y1 * ScaleY);
        TDFLine(Dest.Pages[0].Objects[x]).X2:= trunc(TDFLine(Dest.Pages[0].Objects[x]).X2 * ScaleX);
        TDFLine(Dest.Pages[0].Objects[x]).Y2:= trunc(TDFLine(Dest.Pages[0].Objects[x]).Y2 * ScaleY);
      end
      else begin
        TDFAccess(Dest.Pages[0].Objects[x]).Left:= trunc(TDFAccess(Dest.Pages[0].Objects[x]).Left * ScaleX);
        TDFAccess(Dest.Pages[0].Objects[x]).Top:= trunc(TDFAccess(Dest.Pages[0].Objects[x]).Top * ScaleY);
        TDFAccess(Dest.Pages[0].Objects[x]).Width:= trunc(TDFAccess(Dest.Pages[0].Objects[x]).Width * ScaleX);
        if TDFAccess(Dest.Pages[0].Objects[x]).Width = 0 then
          TDFAccess(Dest.Pages[0].Objects[x]).Width:= 1;
        TDFAccess(Dest.Pages[0].Objects[x]).Height:= trunc(TDFAccess(Dest.Pages[0].Objects[x]).Height * ScaleY);
        if TDFAccess(Dest.Pages[0].Objects[x]).Height = 0 then
          TDFAccess(Dest.Pages[0].Objects[x]).Height:= 1;
      end;
    end;
  end;
end;

procedure dfExportEMF(Source: TDFPage; const DestEMFfile: string);
var
  MF: TMetafile;
  MFC: TMetaFileCanvas;
begin
  MF:= TMetafile.Create;
  try
    MF.Height:= Source.Height;
    MF.Width:= Source.Width;
    MFC:= TMetafileCanvas.Create(MF,0);
    try
      Source.PaintTo(MFC, Source.PageRect, dfDisplay);
    finally
      MFC.Free;
    end;
    MF.Enhanced:= true;
    MF.Savetofile(DestEMFfile);
  finally
    MF.free;
  end;
end;

procedure dfExportWMF(Source: TDFPage; const DestWMFfile: string);
var
  MF: TMetafile;
  MFC: TMetaFileCanvas;
begin
  MF:= TMetafile.Create;
  try
    MF.Height:= Source.Height;
    MF.Width:= Source.Width;
    MFC:= TMetafileCanvas.Create(MF,0);
    try
      Source.PaintTo(MFC, Source.PageRect, dfDisplay);
    finally
      MFC.Free;
    end;
    MF.Enhanced:= false;
    MF.Savetofile(DestWMFfile);
  finally
    MF.free;
  end;
end;

////////////////////////////
//      RTF EXPORT        //
//    By Paul Shoener     //
////////////////////////////

procedure dfExportRTF(Source: TDFEngine; const DestRTFfile: string);
begin
  DFToRTF(Source, DestRTFFile);
end;

////////////////////////////
//      PDF EXPORT        //
//    By Paul Shoener     //
////////////////////////////

{$IFDEF PDF}
procedure dfExportPDF(Source: TDFEngine; const DestPDFfile: string);
begin
  dfExportPDF(Source, DestPDFfile, '');
end;
procedure dfExportPDF(Source: TDFEngine; const DestPDFfile: string; const Comments: string); overload;
var
  PDFConverter: TDF6toPDFConverter;
begin
  PDFConverter:= TDF6toPDFConverter.create;
  try
    PDFConverter.CreationDate:= NOW;
    PDFConverter.Comments.text:= Comments;
    PDFConverter.ConvertToPDF(Source);
    PDFConverter.SaveToFile(DestPDFfile);
  finally
    PDFConverter.free;
  end;
end;
{$ELSE}
procedure dfExportPDF(Source: TDFEngine; const DestPDFfile: string);
begin
  raise EDFConvertError.create('PDF not enabled');
end;
procedure dfExportPDF(Source: TDFEngine; const DestPDFfile: string; const Comments: string); overload;
begin
  raise EDFConvertError.create('PDF not enabled');
end;
{$ENDIF}


////////////////////////////
//     XML INTERFACE      //
//    By Jeff Rafter      //
////////////////////////////

{$IFDEF XML}
procedure dfImportXML(Dest: TDFEngine; const SourceXMLfile: string);
begin
  LoadFromXML(Dest.Form, SourceXMLfile);
end;

procedure dfExportXML(Source: TDFEngine; const DestXMLfile: string);
begin
  SaveToXML(Source.Form, DestXMLfile);
end;
{$ELSE}
procedure dfImportXML(Dest: TDFEngine; const SourceXMLfile: string);
begin
  raise EDFConvertError.create('XML not enabled');
end;

procedure dfExportXML(Source: TDFEngine; const DestXMLfile: string);
begin
  raise EDFConvertError.create('XML not enabled');
end;
{$ENDIF}

////////////////////////////
//     OTHER EXPORTS      //
//    By Dan English      //
////////////////////////////

procedure dfExportBMP(Source: TDFPage; const DestBMPfile: string);
var BM: TBitmap;
begin
  BM:= TBitmap.create;
  try
    BM.Height:= Source.Height;
    BM.Width:= Source.Width;
    Source.PaintTo(BM.Canvas, Source.PageRect, dfDisplay);
    BM.Savetofile(DestBMPfile);
  finally
    BM.free;
  end;
end;

{$IFDEF JPG}
procedure dfExportJPG(Source: TDFPage; const DestJPGfile: string);
var
  BM: TBitmap;
  JP: TJPEGImage;
begin
  JP:= TJPEGImage.create;
  BM:= TBitmap.create;
  try
    BM.Height:= Source.Height;
    BM.Width:= Source.Width;
    Source.PaintTo(BM.Canvas, Source.PageRect, dfDisplay);
    JP.Assign(BM);
    JP.Savetofile(DestJPGfile);
  finally
    JP.free;
    BM.free;
  end;
end;
{$ELSE}
procedure dfExportJPG(Source: TDFPage; const DestJPGfile: string);
begin
  raise EDFConvertError.create('JPG not enabled');
end;
{$ENDIF}

{$IFDEF GIF}
procedure dfExportGIF(Source: TDFPage; const DestGIFfile: string);
var
  BM: TBitmap;
  GF: TGIFImage;
begin
  GF:= TGIFImage.create;
  BM:= TBitmap.create;
  try
    BM.Height:= Source.Height;
    BM.Width:= Source.Width;
    Source.PaintTo(BM.Canvas, Source.PageRect, dfDisplay);
    GF.Assign(BM);
    GF.Savetofile(DestGIFfile);
  finally
    GF.free;
    BM.free;
  end;
end;

{$ELSE}
procedure dfExportGIF(Source: TDFPage; const DestGIFfile: string);
begin
  raise EDFConvertError.create('GIF not enabled');
end;
{$ENDIF}

{$IFDEF HTM}
procedure dfExportHTML(Source: TDFEngine; const DestHTMLfile: string);
begin
  DefinedFormToHTML(Source, DestHTMLFile, {true}false, 1);
end;

{$ELSE}
procedure dfExportHTML(Source: TDFEngine; const DestHTMLfile: string);
begin
  raise EDFConvertError.create('HTML not enabled');
end;
{$ENDIF}

end.
