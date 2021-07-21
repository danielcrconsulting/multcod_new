
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Debug Routines                                  }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfdebug;

interface

{$WEAKPACKAGEUNIT ON}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

  procedure dfDisplayMetaRecords(Dest: TStrings; MetaStream: TStream);

implementation

procedure dfDisplayMetaRecords(Dest: TStrings; MetaStream: TStream);
var
  meta: string;
  x: integer;
  Hdr: ^tagENHMETAHEADER;
  Rec: ^tagENHMETARECORD;
begin
  Dest.clear;
  //read entire stream into a string
  MetaStream.seek(0,0);
  setlength(meta, MetaStream.size);
  MetaStream.ReadBuffer(pointer(meta)^, length(meta));
  //grab pointers
  Hdr:= pointer(meta);
  Rec:= pointer(longint(Hdr) + longint(Hdr.nSize));
  //loop through meta records
  for x:= 0 to Hdr.nRecords-2 do
  begin
    case Rec^.iType of
      EMR_ABORTPATH                  : Dest.Add('EMR_ABORTPATH');
      EMR_ANGLEARC                   : Dest.Add('EMR_ANGLEARC');
      EMR_ARC                        : Dest.Add('EMR_ARC');
      EMR_ARCTO                      : Dest.Add('EMR_ARCTO');
      EMR_BEGINPATH                  : Dest.Add('EMR_BEGINPATH');
      EMR_BITBLT                     : Dest.Add('EMR_BITBLT');
      EMR_CHORD                      : Dest.Add('EMR_CHORD');
      EMR_CLOSEFIGURE                : Dest.Add('EMR_CLOSEFIGURE');
      EMR_CREATEBRUSHINDIRECT        : Dest.Add('EMR_CREATEBRUSHINDIRECT');
      EMR_CREATEDIBPATTERNBRUSHPT    : Dest.Add('EMR_CREATEDIBPATTERNBRUSHPT');
      EMR_CREATEMONOBRUSH            : Dest.Add('EMR_CREATEMONOBRUSH');
      EMR_CREATEPALETTE              : Dest.Add('EMR_CREATEPALETTE');
      EMR_CREATEPEN                  : Dest.Add('EMR_CREATEPEN');
      EMR_DELETEOBJECT               : Dest.Add('EMR_DELETEOBJECT');
      EMR_ELLIPSE                    : Dest.Add('EMR_ELLIPSE');
      EMR_ENDPATH                    : Dest.Add('EMR_ENDPATH');
      EMR_EOF                        : Dest.Add('EMR_EOF');
      EMR_EXCLUDECLIPRECT            : Dest.Add('EMR_EXCLUDECLIPRECT');
      EMR_EXTCREATEFONTINDIRECTW     : Dest.Add('EMR_EXTCREATEFONTINDIRECTW');
      EMR_EXTCREATEPEN               : Dest.Add('EMR_EXTCREATEPEN');
      EMR_EXTFLOODFILL               : Dest.Add('EMR_EXTFLOODFILL');
      EMR_EXTSELECTCLIPRGN           : Dest.Add('EMR_EXTSELECTCLIPRGN');
      EMR_EXTTEXTOUTA                : Dest.Add('EMR_EXTTEXTOUTA');
      EMR_EXTTEXTOUTW                : Dest.Add('EMR_EXTTEXTOUTW');
      EMR_FILLPATH                   : Dest.Add('EMR_FILLPATH');
      EMR_FILLRGN                    : Dest.Add('EMR_FILLRGN');
      EMR_FLATTENPATH                : Dest.Add('EMR_FLATTENPATH');
      EMR_FRAMERGN                   : Dest.Add('EMR_FRAMERGN');
      EMR_GDICOMMENT                 : Dest.Add('EMR_GDICOMMENT');
      EMR_HEADER                     : Dest.Add('EMR_HEADER');
      EMR_INTERSECTCLIPRECT          : Dest.Add('EMR_INTERSECTCLIPRECT');
      EMR_INVERTRGN                  : Dest.Add('EMR_INVERTRGN');
      EMR_LINETO                     : Dest.Add('EMR_LINETO');
      EMR_MASKBLT                    : Dest.Add('EMR_MASKBLT');
      EMR_MODIFYWORLDTRANSFORM       : Dest.Add('EMR_MODIFYWORLDTRANSFORM');
      EMR_MOVETOEX                   : Dest.Add('EMR_MOVETOEX');
      EMR_OFFSETCLIPRGN              : Dest.Add('EMR_OFFSETCLIPRGN');
      EMR_PAINTRGN                   : Dest.Add('EMR_PAINTRGN');
      EMR_PIE                        : Dest.Add('EMR_PIE');
      EMR_PLGBLT                     : Dest.Add('EMR_PLGBLT');
      EMR_POLYBEZIER16               : Dest.Add('EMR_POLYBEZIER16');
      EMR_POLYBEZIERTO16             : Dest.Add('EMR_POLYBEZIERTO16');
      EMR_POLYDRAW                   : Dest.Add('EMR_POLYDRAW');
      EMR_POLYDRAW16                 : Dest.Add('EMR_POLYDRAW16');
      EMR_POLYGON                    : Dest.Add('EMR_POLYGON');
      EMR_POLYGON16                  : Dest.Add('EMR_POLYGON16');
      EMR_POLYLINE                   : Dest.Add('EMR_POLYLINE');
      EMR_POLYLINE16                 : Dest.Add('EMR_POLYLINE16');
      EMR_POLYLINETO                 : Dest.Add('EMR_POLYLINETO');
      EMR_POLYLINETO16               : Dest.Add('EMR_POLYLINETO16');
      EMR_POLYPOLYGON                : Dest.Add('EMR_POLYPOLYGON');
      EMR_POLYPOLYGON16              : Dest.Add('EMR_POLYPOLYGON16');
      EMR_POLYPOLYLINE               : Dest.Add('EMR_POLYPOLYLINE');
      EMR_POLYPOLYLINE16             : Dest.Add('EMR_POLYPOLYLINE16');
      EMR_POLYTEXTOUTA               : Dest.Add('EMR_POLYTEXTOUTA');
      EMR_POLYTEXTOUTW               : Dest.Add('EMR_POLYTEXTOUTW');
      EMR_REALIZEPALETTE             : Dest.Add('EMR_REALIZEPALETTE');
      EMR_RECTANGLE                  : Dest.Add('EMR_RECTANGLE');
      EMR_RESIZEPALETTE              : Dest.Add('EMR_RESIZEPALETTE');
      EMR_RESTOREDC                  : Dest.Add('EMR_RESTOREDC');
      EMR_ROUNDRECT                  : Dest.Add('EMR_ROUNDRECT');
      EMR_SAVEDC                     : Dest.Add('EMR_SAVEDC');
      EMR_SCALEVIEWPORTEXTEX         : Dest.Add('EMR_SCALEVIEWPORTEXTEX');
      EMR_SCALEWINDOWEXTEX           : Dest.Add('EMR_SCALEWINDOWEXTEX');
      EMR_SELECTCLIPPATH             : Dest.Add('EMR_SELECTCLIPPATH');
      EMR_SELECTOBJECT               : Dest.Add('EMR SELECTOBJECT');
      EMR_SELECTPALETTE              : Dest.Add('EMR_SELECTPALETTE');
      EMR_SETBKCOLOR                 : Dest.Add('EMR_SETBKCOLOR');
      EMR_SETBKMODE                  : Dest.Add('EMR_SETBKMODE');
      EMR_SETBRUSHORGEX              : Dest.Add('EMR_SETBRUSHORGEX');
      EMR_SETCOLORADJUSTMENT         : Dest.Add('EMR_SETCOLORADJUSTMENT');
      EMR_SETDIBITSTODEVICE          : Dest.Add('EMR_SETDIBITSTODEVICE');
      EMR_SETMAPMODE                 : Dest.Add('EMR_SETMAPMODE');
      EMR_SETMAPPERFLAGS             : Dest.Add('EMR_SETMAPPERFLAGS');
      EMR_SETMETARGN                 : Dest.Add('EMR_SETMETARGN');
      EMR_SETMITERLIMIT              : Dest.Add('EMR_SETMITERLIMIT');
      EMR_SETPALETTEENTRIES          : Dest.Add('EMR_SETPALETTEENTRIES');
      EMR_SETPIXELV                  : Dest.Add('EMR_SETPIXELV');
      EMR_SETPOLYFILLMODE            : Dest.Add('EMR_SETPOLYFILLMODE');
      EMR_SETROP2                    : Dest.Add('EMR_SETROP2');
      EMR_SETSTRETCHBLTMODE          : Dest.Add('EMR_SETSTRETCHBLTMODE');
      EMR_SETTEXTALIGN               : Dest.Add('EMR_SETTEXTALIGN');
      EMR_SETTEXTCOLOR               : Dest.Add('EMR_SETTEXTCOLOR');
      EMR_SETVIEWPORTEXTEX           : Dest.Add('EMR_SETVIEWPORTEXTEX');
      EMR_SETWINDOWEXTEX             : Dest.Add('EMR_SETWINDOWEXTEX');
      EMR_SETWINDOWORGEX             : Dest.Add('EMR_SETWINDOWORGEX');
      EMR_STRETCHBLT                 : Dest.Add('EMR_STRETCHBLT');
      EMR_STRETCHDIBITS              : Dest.Add('EMR_STRETCHDIBITS');
      EMR_STROKEANDFILLPATH          : Dest.Add('EMR_STROKEANDFILLPATH');
      EMR_STROKEPATH                 : Dest.Add('EMR_STROKEPATH');
      EMR_WIDENPATH                  : Dest.Add('EMR_WIDENPATH');
      else                             Dest.Add('<UNKNOWN>');
    end;
    longint(Rec):= longint(Rec) + longint(Rec^.nSize);
  end;
end;

end.
