{**************************************}
{     Defined Forms XML interface      }
{**************************************}

unit dfxml;

interface

{$WEAKPACKAGEUNIT ON}
{$I DEFINEDFORMS.INC}

uses Classes, SysUtils, TypInfo, defstream, xmlproc, objectxml;

procedure LoadFromXML(Dest: TDefinedStream; const Filename: string);
procedure SavetoXML(Source: TDefinedStream; const Filename: string); overload;
procedure SavetoXML(Source: TDefinedStream; const Filename: string; const StyleSheet : String); overload;
procedure ReadXML(Dest: TDefinedStream; const Filename: string);
procedure WriteXML(Source: TDefinedStream; const Filename: string);

implementation

procedure LoadFromXML(Dest: TDefinedStream; const Filename: string);
var
  tmpstream1,tmpstream2: TMemoryStream;
  S : TStrings;
begin
  tmpstream1:= TMemoryStream.create;
  tmpstream2:= TMemoryStream.create;
  S:= TStringList.Create;
  try
    S.LoadFromFile(FileName);
    //Rip off the style sheet
    if (S.Count > 1) then
    begin
      if (Pos('<?xml-stylesheet', S[1]) > 0) then S.Delete(1);
    end;
    //Save it to a stream
    S.SaveToStream(tmpstream1);
    tmpstream1.seek(0,0);
    ObjectXMLtoBinary(tmpstream1, tmpstream2);
    Dest.LoadFromStream(tmpstream2);
  finally
    S.Free;
    tmpstream1.free;
    tmpstream2.free;
  end;
end;

procedure SavetoXML(Source: TDefinedStream; const Filename: string); overload;
begin
  SaveToXml(Source, Filename, '');
end;

procedure SavetoXML(Source: TDefinedStream; const Filename: string; const StyleSheet : String); overload;
var
  tmpstream1,tmpstream2: TMemoryStream;
  S : TStrings;
begin
  tmpstream1:= TMemoryStream.create;
  tmpstream2:= TMemoryStream.create;
  S:= TStringList.Create;
  try
    Source.SaveToStream(tmpstream1);
    tmpstream1.seek(0,0);
    ObjectBinarytoXML(tmpstream1, tmpstream2);
    tmpstream2.seek(0,0);
    S.LoadFromStream(tmpstream2);
    if (StyleSheet <> '') then
      S.Insert(1, '<?xml-stylesheet alternate="yes" type="text/xsl" href="' + StyleSheet + '"?>');
    S.SaveToFile(Filename);
  finally
    S.Free;
    tmpstream1.free;
    tmpstream2.free;
  end;
end;

procedure ReadXML(Dest: TDefinedStream; const Filename: string);
begin
  ReadObjectFromXml(Dest, FileName);
end;

procedure WriteXML(Source: TDefinedStream; const Filename: string);
begin
  WriteObjectToXml(Source, FileName);
end;

end.



