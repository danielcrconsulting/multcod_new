{**************************************}
{    Defined Stream XML interface      }
{**************************************}

unit defxml;

interface

{$WEAKPACKAGEUNIT ON}

uses
  Classes, SysUtils, TypInfo, Dialogs, Clipbrd, DefStream, DefSAXSerializer,
  SAXAElfred2;


type
  TDSFormat = (dsfBinary, dsfText, dsfXML);

  procedure LoadXMLfromStream(Src: TStream; Dest: TDefinedStream);
  procedure SaveXMLtoStream(Src: TDefinedStream; Dest: TStream);
  procedure LoadXMLfromFile(const Filename: string; Dest: TDefinedStream);
  procedure SaveXMLtoFile(Src: TDefinedStream; const Filename: string);

  procedure SaveToFileFormat(Source: TDefinedStream; Format: TDSFormat; const Filename: string);
  procedure LoadFromFileFormat(const Filename: string; Dest: TDefinedStream);

  // Not working yet...
  procedure SaveXMLSchematoStream(SrcClass: TClass; Dest: TStream);
  procedure SaveXMLSchematoFile(SrcClass: TClass; const Filename: string);

implementation

{ TDefinedStreamXMLReader }

procedure LoadXMLfromStream(Src: TStream; Dest: TDefinedStream);
begin
  Dest.Clear;
  DefReadObjectFromXML(Dest, Src, soOwned, SAX_VENDOR_AELFRED2);
end;

procedure SaveXMLtoStream(Src: TDefinedStream; Dest: TStream);
begin
  DefWriteObjectToXML(Src, Dest);
end;

procedure LoadXMLfromFile(const Filename: string; Dest: TDefinedStream);
begin
  Dest.Clear;
  DefReadObjectFromXML(Dest, FileName, SAX_VENDOR_AELFRED2);
end;

procedure SaveXMLtoFile(Src: TDefinedStream; const Filename: string);
begin
  DefWriteObjectToXML(Src, FileName);
end;

procedure SaveToFileFormat(Source: TDefinedStream; Format: TDSFormat; const Filename: string);
begin
  case Format of
    dsfBinary: Source.savetofile(Filename);
    dsfText: Source.savetostringsfile(Filename);
    dsfXML: SaveXMLtoFile(Source, Filename);
  end;
end;

procedure LoadFromFileFormat(const Filename: string; Dest: TDefinedStream);
var MS: TMemoryStream;
    SL: TStringlist;
    tmpstr: string;
    p: pointer;
    i: integer;
begin
  MS := TMemoryStream.create;
  SL := TStringlist.create;
  try
    MS.loadfromfile(Filename);
    MS.seek(0,0);
    p := MS.Memory;
    for I := 0 to MS.Size-1 do
      if I < 8 then
      begin
        tmpstr := tmpstr + Char(P^);
        inc(cardinal(P));
      end
      else
        break;
    //object binary
    if pos('TPF0', tmpstr)>0 then
    begin
      Dest.loadfromstream(MS);
    end
    //object text
    else if pos('object', tmpstr)>0 then
    begin
      SL.LoadFromStream(MS);
      Dest.loadfromstrings(SL);
    end
    //object xml
    else if pos('xml', tmpstr)>0 then
    begin
      LoadXMLfromStream(MS, Dest);
    end
    else
      raise Exception.create('Unrecognized file format');
  finally
    MS.free;
    SL.free;
  end;
end;

procedure SaveXMLSchematoStream(SrcClass: TClass; Dest: TStream);
begin
  { not working }
end;

procedure SaveXMLSchematoFile(SrcClass: TClass; const Filename: string);
begin
  { not working }
end;

end.


