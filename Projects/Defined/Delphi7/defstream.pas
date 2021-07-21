
{*******************************************************}
{                                                       }
{       Defined Stream                                  }
{       Object Storage System                           }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit defstream;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TypInfo, Clipbrd;

type
  TDefinedStream = class;

  TDefinedStreamClass = class of TDefinedStream;

  TCompareItemsEvent = procedure(Sender: TObject; AChild1,AChild2: TDefinedStream; var NeedSwap: boolean) of object;

  TReaderType = (rtNotReading, rtDelphi, rtOther);

{ TDefinedStream}

  TDefinedStream = class(TComponent)
  private
    FParent: TDefinedStream;
    FCompareItems: TCompareItemsEvent;
    FPropCount: integer;
    FProps: PPropList;
    FChangeBuffer: TMemoryStream;
    function  _GetChild(Index: integer): TDefinedStream;
    function  _GetFirst: TDefinedStream;
    function  _GetLast: TDefinedStream;
    function  _GetSize: integer;
    function  _GetChildCount: integer;
    function  _GetIndex: integer;
    function  _GetProperty(Index: integer): PPropInfo;
    function  _GetPropCount: integer;
    procedure _ReaderError(Reader: TReader; const Message: string; var Handled: Boolean);
    function GetAsTest: string;
    procedure SetAsText(const Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure Initialize; virtual;
    procedure AssignParent(AParent: TDefinedStream); virtual; //when loading happens after create, otherwise during
    procedure ReadState(Reader: TReader); override;
    function  Root: TDefinedStream;
    function  StoreDesign: boolean; virtual;
  public
    ReadError: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SavetoStream(Stream: TStream); dynamic;
    procedure LoadFromStream(Stream: TStream); dynamic;
    procedure SavetoFile(const Filename: string); dynamic;
    procedure LoadFromFile(const Filename: string); dynamic;
    procedure SavetoStrings(Strings: TStrings); dynamic;
    procedure LoadFromStrings(Strings: TStrings); dynamic;
    procedure SavetoStringsFile(const Filename: string); dynamic;
    procedure LoadFromStringsFile(const Filename: string); dynamic;
    procedure SavetoClipboard; dynamic;
    procedure LoadFromClipboard; dynamic;
    procedure ExportFieldList(Dest: TStrings); overload;
    procedure ExportFieldList(Dest: TStrings; FieldTypes, SkipNameTag: boolean); overload;
    procedure ExportFieldList(AClass: TClass; APath: string; Dest: TStrings;
      FieldTypes, SkipNameTag: boolean); overload;
    function  SaveToBuffer(var Dest; MaxBytes: longint): longint; dynamic;
    function  LoadFromBuffer(const Source; Count: longint): longint; dynamic;
    function  AddChild(AChild: TDefinedStream): TDefinedStream; dynamic;
    function  AddChildCopy(AChild: TDefinedStream): TDefinedStream; dynamic;
    function  AddNewChild(AChildtype: TClass): TDefinedStream; dynamic;
    function  AddNewChildStr(AChildTypeStr: string): TDefinedStream; dynamic;
    function  CountChildren(AChildtype: TClass): integer;
    function  FindChild(AChildtype: TClass; Index: integer): TDefinedStream;
    function  IsDifferent(Source: TDefinedStream): boolean;
    function  IsSameClass(AChild: TDefinedStream): boolean;
    function  IsRoot: boolean;
    function  IsLoading: boolean;
    procedure RefreshProperties; virtual;
    procedure ClearProperties; virtual;
    procedure GroupChildren; virtual;
    procedure SortChildren; virtual;
    procedure ClearChildren; virtual;
    procedure Clear; virtual;
    procedure Delete; virtual;
    procedure DeleteChildren(AClasses: array of const);
    procedure Exchange(DestIndex: integer);
    procedure MoveTo(DestIndex: integer);
    procedure MoveFirst;
    procedure MoveLast;
    procedure MoveUp;
    procedure MoveDown;
    procedure UpdateChangeBuffer;
    procedure AssignChangeBuffer;
    procedure ClearChangeBuffer;
    function  SameChangeBuffer: boolean;
    function  GetPropAsString(const PropName: string): String;
    procedure SetPropAsString(const PropName: string; const Value: String);
    function  GetPropAsInteger(const PropName: string): integer;
    procedure SetPropAsInteger(const PropName: string; const Value: integer);
    function  GetPropAsFloat(const PropName: string): Extended;
    procedure SetPropAsFloat(const PropName: string; const Value: Extended);
    function  GetEnumString(const PropName: string; const Value: integer): string;
    function  FindProperty(proppath: string; var Instance: TDefinedStream;
      var PropInfo: TPropInfo): boolean;
    function  IsStoredProperty(proppath: string; var Instance: TDefinedStream): boolean;
    function  FindPropValue(proppath: string): string;
    procedure UpdatePropValue(proppath, value: string);
    property AsText: string read GetAsTest write SetAsText;
    property Parent: TDefinedStream read FParent;
    property Size: integer read _GetSize;
    property Index: integer read _GetIndex;
    property FirstChild: TDefinedStream read _GetFirst;
    property LastChild: TDefinedStream read _GetLast;
    property ChildCount: integer read _GetChildCount;
    property Children[Index: integer]: TDefinedStream read _GetChild; default;
    property Properties[Index: integer]: PPropinfo read _GetProperty;
    property PropertyCount: integer read _GetPropCount;
  published
    property OnCompareItems: TCompareItemsEvent read FCompareItems write FCompareItems;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Defined', [TDefinedStream]);
end;

{ TDefinedStream }

constructor TDefinedStream.Create(AOwner: TComponent);
begin
//must be set before inherited!
  FParent:= nil;
  FPropCount:= 0;
  FProps:= nil;
  FChangeBuffer:= nil;
  inherited Create(AOwner);
  Initialize;
end;

destructor TDefinedStream.Destroy;
begin
  if FProps <> nil then
    FreeMem(FProps, FPropCount * sizeof(Pointer));
  FProps:= nil;
  ClearChangeBuffer;
  inherited Destroy;
end;

procedure TDefinedStream.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  Component: TComponent;
begin
  for I:= 0 to ComponentCount-1 do
  begin
    Component := Components[I];
    Proc(Component);
  end;
end;

procedure TDefinedStream.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opInsert) and (not (csLoading in ComponentState)) and
     (AComponent is TDefinedStream) and (AComponent.Owner = Self) then
  begin
    TDefinedStream(AComponent).AssignParent(Self);
  end;
end;

procedure TDefinedStream.ReadState(Reader: TReader);
begin
  if (Reader.parent = NIL) or (Reader.parent is TDefinedStream) then
  begin
    Reader.OnError:= _ReaderError;
    if (Reader.parent <> NIL) and (Reader.parent <> Reader.Root) then
    begin
      Reader.Root.RemoveComponent(Self);
      Reader.Parent.InsertComponent(Self);
    end;
    if (Reader.parent <> NIL) then
      AssignParent(Reader.Parent as TDefinedStream);
  end;
  inherited ReadState(Reader);
end;

procedure TDefinedStream._ReaderError(Reader: TReader; const Message: string; var Handled: Boolean);
begin
  if (pos('property', lowercase(Message)) > 0) and (pos('does not exist', lowercase(Message)) > 0) then
  begin
    Handled:= true; //auto ignore invalid properties
    ReadError:= true;
  end;

  if pos('invalid property', lowercase(Message)) > 0 then
  begin
    Handled:= true; //auto ignore invalid property value
    ReadError:= true;
  end;

  if (pos('class', lowercase(Message)) = 1) and (pos('not found', lowercase(Message)) > 0) then
  begin
    Handled:= true; //auto ignore class not found
    ReadError:= true;
  end;
end;

function TDefinedStream._GetChild(Index: integer): TDefinedStream;
begin
  result:= TDefinedStream(Components[Index]);
end;

function TDefinedStream._GetFirst: TDefinedStream;
begin
  result:= TDefinedStream(Components[0]);
end;

function TDefinedStream._GetLast: TDefinedStream;
begin
  result:= TDefinedStream(Components[ComponentCount-1]);
end;

function TDefinedStream._GetIndex: integer;
begin
  Result:= ComponentIndex;
end;

function TDefinedStream._GetSize: integer;
var
  MS1: TMemorystream;
begin
  MS1:= nil;
  try
    MS1:= TMemorystream.create;
    Self.SavetoStream(MS1);
    result:= MS1.size;
  finally
    MS1.free;
  end;
end;

function TDefinedStream._GetChildCount: integer;
begin
  result:= ComponentCount;
end;


procedure TDefinedStream.LoadFromClipboard;
var T: TStringList;
begin
  T:= nil;
  try
    T:= TStringList.create;
    T.Text:= ClipBoard.AsText;
    LoadFromStrings(T);
  finally
    T.free;
  end;
end;

procedure TDefinedStream.LoadFromFile(const Filename: string);
var M: TMemoryStream;
begin
  ClearChildren;
  M:= nil;
  try
    M:= TMemoryStream.create;
    M.loadfromfile(Filename);
    M.seek(0,0);
    LoadFromStream(M);
  finally
    M.free;
  end;
end;

procedure TDefinedStream.LoadFromStream(Stream: TStream);
begin
  ReadError:= false;
  ClearChildren;
  SetDesigning(true);
  if Stream.Position = Stream.Size then Stream.Seek(0,0);
  Stream.readcomponent(Self);

  SetDesigning(false);
end;

procedure TDefinedStream.LoadFromStrings(Strings: TStrings);
var M1,M2: TMemoryStream;
begin
  ClearChildren;
  M1:= nil;
  M2:= nil;
  try
    M1:= TMemoryStream.create;
    M2:= TMemoryStream.create;
    Strings.savetostream(M1);
    M1.seek(0,0);
    ObjectTextToBinary(M1,M2);
    M2.seek(0,0);
    LoadFromStream(M2);
  finally
    M1.free;
    M2.free;
  end;
end;

procedure TDefinedStream.SavetoClipboard;
var T: TStringList;
begin
  T:= nil;
  try
    T:= TStringList.create;
    SaveToStrings(T);
    ClipBoard.AsText:= T.Text;
  finally
    T.free;
  end;
end;

procedure TDefinedStream.SavetoFile(const Filename: string);
var M: TMemoryStream;
begin
  M:= nil;
  try
    M:= TMemoryStream.create;
    SaveToStream(M);
    M.seek(0,0);
    M.savetofile(Filename);
  finally
    M.free;
  end;
end;

procedure TDefinedStream.SavetoStream(Stream: TStream);
var
  tmpname: string;
  tmpinfo: integer;
begin
  //dont write name or top,left to stream
  tmpname:= Name;
  Name:= '';
  tmpinfo:= DesignInfo;
  DesignInfo:= 0;
  Stream.writecomponent(Self);
  Name:= tmpname;
  DesignInfo:= tmpinfo;
end;

procedure TDefinedStream.SavetoStrings(Strings: TStrings);
var M1,M2: TMemoryStream;
begin
  M1:= nil;
  M2:= nil;
  try
    M1:= TMemoryStream.create;
    M2:= TMemoryStream.create;
    SavetoStream(M1);
    M1.seek(0,0);
    ObjectBinaryToText(M1,M2);
    M2.seek(0,0);
    Strings.loadfromstream(M2);
  finally
    M1.free;
    M2.free;
  end;
end;

function TDefinedStream.SaveToBuffer(var Dest; MaxBytes: Integer): longint;
var
  tmpstream: TMemorystream;
begin
  result:= 0;
  tmpstream:= nil;
  try
    tmpstream:= TMemorystream.create;
    SaveToStream(tmpstream);
    tmpstream.seek(0,0);
    if tmpstream.size > MaxBytes then
      raise Exception.create('Destination buffer too small');
    result:= tmpstream.read(Dest, tmpstream.size);
  finally
    tmpstream.free;
  end;
end;

function TDefinedStream.LoadFromBuffer(const Source; Count: Integer): longint;
var
  tmpstream: TMemorystream;
begin
  ClearChildren;
  tmpstream:= nil;
  try
    tmpstream:= TMemorystream.create;
    result:= tmpstream.write(Source, Count);
    tmpstream.seek(0,0);
    LoadfromStream(tmpstream);
  finally
    tmpstream.free;
  end;
end;

procedure TDefinedStream.LoadFromStringsFile(const Filename: string);
var tmpstrings: TStringlist;
begin
  tmpstrings:= TStringlist.create;
  try
    tmpstrings.loadfromfile(Filename);
    LoadFromStrings(tmpstrings);
  finally
    tmpstrings.free;
  end;
end;

procedure TDefinedStream.SavetoStringsFile(const Filename: string);
var tmpstrings: TStringlist;
begin
  tmpstrings:= TStringlist.create;
  try
    SaveToStrings(tmpstrings);
    tmpstrings.savetofile(Filename);
  finally
    tmpstrings.free;
  end;
end;

function TDefinedStream.AddChild(AChild: TDefinedStream): TDefinedStream;
begin
  if AChild = nil then
    raise Exception.create('New child can not be NIL.. Use AddNewChild');
  InsertComponent(AChild);
  result:= Components[ComponentCount-1] as TDefinedStream;
end;

function TDefinedStream.AddNewChild(AChildtype: TClass): TDefinedStream;
begin
  result:= TDefinedStreamClass(AChildtype).create(Self);
end;

function TDefinedStream.AddNewChildStr(AChildTypeStr: string): TDefinedStream;
var MyClass: TPersistentClass;
begin
  MyClass := FindClass( AChildTypeStr );
  result:= AddNewChild( MyClass );
end;

function TDefinedStream.AddChildCopy(AChild: TDefinedStream): TDefinedStream;
begin
  result:= TDefinedStreamClass(AChild.ClassType).create(self);
  result.Assign(AChild);
end;

procedure TDefinedStream.Exchange(DestIndex: integer);
var
  Index1, Index2, i: integer;
  c1,c2: TComponent;
begin
  Index1:= ComponentIndex;
  Index2:= DestIndex;
  if Index1 = Index2 then Exit;
  if Index1 > Index2 then
  begin
    i:= Index1;
    Index1:= Index2;
    Index2:= i;
  end;
  c1:= Owner.Components[Index1];
  c2:= Owner.Components[Index2];
  c1.ComponentIndex:= Index2;
  c2.ComponentIndex:= Index1;
end;

procedure TDefinedStream.MoveTo(DestIndex: integer);
begin
  ComponentIndex:= DestIndex;
end;

procedure TDefinedStream.AssignTo(Dest: TPersistent);
var
  tmpstream: TMemorystream;
begin
  if Dest is TDefinedStream then
  begin
    tmpstream:= TMemorystream.create;
    try
      Self.SavetoStream(tmpstream);
      tmpstream.seek(0,0);
      TDefinedStream(Dest).LoadFromStream(tmpstream);
    finally
      tmpstream.free;
    end;
  end
  else inherited AssignTo(Dest);
end;

function TDefinedStream.IsDifferent(Source: TDefinedStream): boolean;
var
  MS1,MS2: TMemorystream;
begin
  MS1:= nil;
  MS2:= nil;
  try
    MS1:= TMemorystream.create;
    MS2:= TMemorystream.create;
    Self.SavetoStream(MS1);
    Source.SaveToStream(MS2);
    MS1.seek(0,0);
    MS2.seek(0,0);
    if MS1.size = MS2.size then
      result:= not CompareMem(MS1.memory, MS2.memory, MS1.size)
    else begin
      result:= true;
    end;
  finally
    MS1.free;
    MS2.free;
  end;
end;

procedure TDefinedStream.Initialize;
begin
end;

procedure TDefinedStream.Delete;
begin
  Free;
end;

procedure TDefinedStream.MoveFirst;
begin
  ComponentIndex:= 0;
end;

procedure TDefinedStream.MoveLast;
begin
  if ComponentIndex <> Owner.ComponentCount-1 then
    ComponentIndex:= Owner.ComponentCount-1;
end;

procedure TDefinedStream.MoveUp;
var
  I: integer;
  Obj: TDefinedStream;
begin
  Obj:= nil;
  for I:= ComponentIndex downto 0 do
    if (Owner.Components[I] <> Self) and (Owner.Components[I].ClassType = ClassType) then
    begin
      Obj:= Owner.Components[I] as TDefinedStream;
      break;
    end;
  if (Obj <> nil) then
    ComponentIndex:= Obj.ComponentIndex;
end;

procedure TDefinedStream.MoveDown;
var
  I: integer;
  Obj: TDefinedStream;
begin
  Obj:= nil;
  for I:= ComponentIndex to Owner.ComponentCount-1 do
    if (Owner.Components[I] <> Self) and (Owner.Components[I].ClassType = ClassType) then
    begin
      Obj:= Owner.Components[I] as TDefinedStream;
      break;
    end;
  if (Obj <> nil) then
    ComponentIndex:= Obj.ComponentIndex;
end;

function TDefinedStream.IsRoot: boolean;
begin
  result:= (Owner = nil) or (not (Owner is TDefinedStream));
end;

procedure TDefinedStream.ClearChildren;
begin
  while ComponentCount > 0 do
    Components[ComponentCount-1].free;
end;

function TDefinedStream.CountChildren(AChildtype: TClass): integer;
var x: integer;
begin
  result:= 0;
  for x:= 0 to ComponentCount-1 do
    if Components[x] is AChildType then
      inc(result);
end;

function TDefinedStream.FindChild(AChildtype: TClass; Index: integer): TDefinedStream;
var x,C: integer;
begin
  result:= nil;
  C:= index;
  for x:= 0 to ComponentCount-1 do
  begin
    if Components[x] is AChildType then dec(C);
    if C < 0 then
    begin
      result:= TDefinedStream(Components[x]);
      break;
    end;
  end;
  if result = nil then
    raise Exception.create('Index out of bounds: '+Name+'.'+AChildType.classname+' ('+inttostr(Index)+')');
end;

procedure TDefinedStream.GroupChildren;
var
  i,j: integer;
begin
  for i:= 0 to ChildCount-1 do
  begin
    for j:= 0 to ChildCount-2 do
    begin
      if Children[j].ClassName > Children[j+1].ClassName then
        Children[j].Exchange(j+1);
    end;
  end;
end;

function TDefinedStream.IsSameClass(AChild: TDefinedStream): boolean;
begin
  result:= comparetext(classname, AChild.ClassName) = 0;
end;

function TDefinedStream.IsLoading: boolean;
begin
  result:= (csLoading in ComponentState);
end;

procedure TDefinedStream.SortChildren;
var
  i,j: integer;
  NeedSwap: boolean;
begin
  if not assigned(FCompareItems) then Exit;
  GroupChildren;
  for i:= 0 to ChildCount-1 do
  begin
    for j:= 0 to ChildCount-2 do
    begin
      NeedSwap:= false;
      FCompareItems(Self, Children[j], Children[j+1], NeedSwap);
      if NeedSwap then
        Children[j].Exchange(j+1);
    end;
  end;
end;

function TDefinedStream.Root: TDefinedStream;
begin
  Result:= Self;
  while (Result.Owner <> nil) and (Result.Owner is TDefinedStream) do
    Result:= Result.Owner as TDefinedStream;
end;

procedure TDefinedStream.Clear;
begin
  ClearChildren;
  ClearProperties;
end;

procedure TDefinedStream.RefreshProperties;
var
  TypeData : PTypeData;
  I,X: integer;
  tmpPropCount: integer;
  tmpProps: PPropList;

begin
  //free existing buffer
  if FProps <> nil then
    FreeMem(FProps, FPropCount * sizeof(Pointer));
  FProps:= nil;
  //allocate temp buffer
  TypeData := GetTypeData(Self.ClassInfo);
  tmpPropCount:= TypeData.PropCount;
  GetMem(tmpProps, tmpPropCount * sizeof(Pointer));
  try
    //get property list into temp buffer
    GetPropInfos(Self.ClassInfo, tmpProps);
    //get count of filtered properties
    FPropCount:= 0;
    for I := 0 to tmpPropCount-1 do
    begin
      if not IsPublishedProp(Self, tmpProps[I].Name) then continue;
      if tmpProps[I].PropType^.Kind = tkMethod then continue;
      if tmpProps[I].PropType^.Kind = tkClass then continue;
      if (tmpProps[I].Name = 'Name') or
         (tmpProps[I].Name = 'Tag') then continue;
      case tmpProps[I].PropType^.Kind of
        tkInteger, {tkInt64,} tkFloat, tkString, tkLString, tkChar, tkSet, tkEnumeration:
          inc(FPropCount);
      end;
    end;
    //allocate memory for filtered property list
    GetMem(FProps, FPropCount * sizeof(Pointer));
    //fill filtered property list
    X:= 0;
    for I := 0 to tmpPropCount-1 do
    begin
      if not IsPublishedProp(Self, tmpProps[I].Name) then continue;
      if tmpProps[I].PropType^.Kind = tkMethod then continue;
      if tmpProps[I].PropType^.Kind = tkClass then continue;
      if (tmpProps[I].Name = 'Name') or
         (tmpProps[I].Name = 'Tag') then continue;
      case tmpProps[I].PropType^.Kind of
        tkInteger, {tkInt64,} tkFloat, tkString, tkLString, tkChar, tkSet, tkEnumeration:
        //add to list
        begin
          FProps[X]:= tmpProps[I];
          inc(X);
        end;
      end;
    end;
  //free temp buffer
  finally
    FreeMem(tmpProps, tmpPropCount * sizeof(Pointer));
  end;
end;

function TDefinedStream._GetPropCount: integer;
begin
  result:= FPropCount;
end;

function TDefinedStream._GetProperty(Index: integer): PPropInfo;
begin
  if (Index < 0) or (Index > FPropCount-1) then
    raise Exception.create('Property index out of bounds');
  result:= FProps[index];
end;

procedure TDefinedStream.ClearProperties;
var I: integer;
begin
  RefreshProperties;
  for I:= 0 to PropertyCount-1 do
  begin
    case Properties[I].PropType^.Kind of
{      tkInt64: SetInt64Prop(Self, Properties[I], 0);}
      tkFloat: SetFloatProp(Self, Properties[I], 0);
      tkString,
      tkLString: SetStrProp(Self, Properties[I], '');
      tkChar,
      tkSet,
      tkEnumeration,
      tkInteger: SetOrdProp(Self, Properties[I], 0);
    end;
  end;
end;

procedure TDefinedStream.AssignParent(AParent: TDefinedStream);
begin
  FParent:= AParent;
end;

function TDefinedStream.GetPropAsString(const PropName: string): String;
var I: integer;
begin
  result:= '';
  for I:= 0 to PropertyCount-1 do
    if Properties[I].Name = PropName then
      result:= GetStrProp(Self, Properties[I]);
end;

function TDefinedStream.GetPropAsInteger(const PropName: string): integer;
var I: integer;
begin
  result:= 0;
  for I:= 0 to PropertyCount-1 do
    if Properties[I].Name = PropName then
      result:= GetOrdProp(Self, Properties[I]);
end;

function TDefinedStream.GetPropAsFloat(const PropName: string): Extended;
var I: integer;
begin
  result:= 0;
  for I:= 0 to PropertyCount-1 do
    if Properties[I].Name = PropName then
      result:= GetFloatProp(Self, Properties[I]);
end;

function TDefinedStream.GetEnumString(const PropName: string; const Value: integer): string;
var I: integer;
begin
  result:= '';
  for I:= 0 to PropertyCount-1 do
    if Properties[I].Name = PropName then
      result:= GetEnumName(Properties[I].PropType^, Value);
end;

procedure TDefinedStream.SetPropAsString(const PropName, Value: String);
var I: integer;
begin
  for I:= 0 to PropertyCount-1 do
    if Properties[I].Name = PropName then
      SetStrProp(Self, Properties[I], Value);
end;

procedure TDefinedStream.SetPropAsInteger(const PropName: string; const Value: integer);
var I: integer;
begin
  for I:= 0 to PropertyCount-1 do
    if Properties[I].Name = PropName then
      SetOrdProp(Self, Properties[I], Value);
end;

procedure TDefinedStream.SetPropAsFloat(const PropName: string; const Value: Extended);
var I: integer;
begin
  for I:= 0 to PropertyCount-1 do
    if Properties[I].Name = PropName then
      SetFloatProp(Self, Properties[I], Value);
end;

procedure TDefinedStream.DeleteChildren(AClasses: array of const);
var I,J: integer;
begin
  for I:= low(AClasses) to high(AClasses) do
  begin
    J:= 0;
    while J < ComponentCount do
    begin
      if Components[J] is AClasses[I].VClass then
        TDefinedStream(Components[J]).Delete
      else
        inc(j);
    end;
  end;
end;

procedure TDefinedStream.ExportFieldList(Dest: TStrings);
begin
  ExportFieldList(Self.ClassType, '', Dest, False, True);
end;

procedure TDefinedStream.ExportFieldList(Dest: TStrings; FieldTypes,
  SkipNameTag: boolean);
begin
  ExportFieldList(Self.ClassType, '', Dest, FieldTypes, True);
end;

procedure TDefinedStream.ExportFieldList(AClass: TClass; APath: string; Dest: TStrings;
  FieldTypes, SkipNameTag: boolean);
  //* this is a recursive method *
var
  I: integer;
  tmpPropCount: integer;
  tmpProps: PPropList;
  TypeData : PTypeData;
  ftype: string;
begin
  //allocate RTTI buffer
  TypeData := GetTypeData(AClass.ClassInfo);
  tmpPropCount:= TypeData.PropCount;
  GetMem(tmpProps, tmpPropCount * sizeof(Pointer));
  try
    //copy property list into buffer
    GetPropInfos(AClass.ClassInfo, tmpProps);
    //loop thru non-class properties
    for I := 0 to tmpPropCount-1 do
    begin
      if tmpProps[I].PropType^.Kind = tkMethod then continue;
      if tmpProps[I].PropType^.Kind = tkClass then continue;
      if FieldTypes then
      begin
        case tmpProps[I].PropType^.Kind of
          tkInteger, tkInt64:  ftype:= ' {type:integer}';
          tkFloat:             ftype:= ' {type:float}';
          tkString, tkLString: ftype:= ' {type:string}';
          tkChar:              ftype:= ' {type:char}';
          tkSet:               ftype:= ' {type:set}';
          tkEnumeration:       ftype:= ' {type:enum}';
          else                 ftype:= '';
        end;
      end
      else ftype:= '';

      if (not SkipNameTag) or ((tmpProps[I].Name <> 'Name') and (tmpProps[I].Name <> 'Tag')) then
      begin
        if APath = '' then
          Dest.Add(APath+tmpProps[I].Name + ftype)
        else
          Dest.Add(APath+'\'+tmpProps[I].Name + ftype);
      end;
    end;
    //loop thru class properties
    for I := 0 to tmpPropCount-1 do
    begin
      if tmpProps[I].PropType^.Kind <> tkClass then continue;
      if APath = '' then
        ExportFieldList(GetObjectPropClass(nil,tmpProps[I]), APath + tmpProps[I].Name, Dest, FieldTypes, SkipNameTag)
      else
        ExportFieldList(GetObjectPropClass(nil,tmpProps[I]), APath + '\' + tmpProps[I].Name, Dest, FieldTypes, SkipNameTag);
    end;
  //free RTTI buffer
  finally
    FreeMem(tmpProps, tmpPropCount * sizeof(Pointer));
  end;
end;

function TDefinedStream.FindProperty(PropPath: string;
  var Instance: TDefinedStream; var PropInfo: TPropInfo): boolean;
var
  X,I: integer;
  tmpstr: string;
  tmpPropCount: integer;
  tmpProps: PPropList;
  TypeData : PTypeData;
begin
  result:= false;
  fillchar(PropInfo, sizeof(PropInfo), 0);
  //strip params
  if pos('{',PropPath)>0 then
    system.Delete(PropPath, pos('{',PropPath), length(PropPath));
  PropPath := trim(PropPath);
  //loop
  repeat
    //get next token
    X:= pos('\', proppath);
    if X = 0 then X:= pos('/', proppath);
    if X > 0 then
    begin
      tmpstr:= copy(proppath, 1, X-1);
      system.delete(proppath, 1, X);
    end
    else
      tmpstr:= proppath;
    //allocate RTTI buffer
    TypeData := GetTypeData(Instance.ClassInfo);
    tmpPropCount:= TypeData.PropCount;
    GetMem(tmpProps, tmpPropCount * sizeof(Pointer));
    try
      //copy property list into buffer
      GetPropInfos(Instance.ClassInfo, tmpProps);
      for I := 0 to tmpPropCount-1 do
      begin
        //is this the property we're looking for?
        if SameText( tmpProps[I].Name, tmpstr) then
        begin
          //is it a class?
          if tmpProps[I].PropType^.Kind = tkClass then
          begin
            //keep going with new class as next instance
            Instance:= TDefinedStream( GetObjectProp(Instance, tmpProps[I]) );
            if Instance = nil then Exit;
          end
          else begin
            //found it
            result:= true;
            PropInfo:= tmpProps[I]^;
          end;
        end;
      end;
    //free RTTI buffer
    finally
      FreeMem(tmpProps, tmpPropCount * sizeof(Pointer));
    end;
  //repeat until we're at the root
  until X = 0;
end;

function TDefinedStream.IsStoredProperty(proppath: string;
  var Instance: TDefinedStream): boolean;
var
  X,I: integer;
  tmpstr: string;
  tmpPropCount: integer;
  tmpProps: PPropList;
  TypeData: PTypeData;
  PropInfo: TPropInfo;
begin
  result:= false;
  fillchar(PropInfo, sizeof(PropInfo), 0);
  //strip params
  if pos('{',PropPath)>0 then
    system.Delete(PropPath, pos('{',PropPath), length(PropPath));
  PropPath := trim(PropPath);
  //loop
  repeat
    //get next token
    X:= pos('\', proppath);
    if X = 0 then X:= pos('/', proppath);
    if X > 0 then
    begin
      tmpstr:= copy(proppath, 1, X-1);
      system.delete(proppath, 1, X);
    end
    else
      tmpstr:= proppath;
    //allocate RTTI buffer
    TypeData := GetTypeData(Instance.ClassInfo);
    tmpPropCount:= TypeData.PropCount;
    GetMem(tmpProps, tmpPropCount * sizeof(Pointer));
    try
      //copy property list into buffer
      GetPropInfos(Instance.ClassInfo, tmpProps);
      for I := 0 to tmpPropCount-1 do
      begin
        //is this the property we're looking for?
        if SameText( tmpProps[I].Name, tmpstr) then
        begin
          //is it a class?
          if tmpProps[I].PropType^.Kind = tkClass then
          begin
            //keep going with new class as next instance
            Instance:= TDefinedStream( GetObjectProp(Instance, tmpProps[I]) );
            if Instance = nil then Exit;
          end
          else begin
            //found it
            PropInfo:= tmpProps[I]^;
            Result:= IsStoredProp(Instance, @PropInfo);
          end;
        end;
      end;
    //free RTTI buffer
    finally
      FreeMem(tmpProps, tmpPropCount * sizeof(Pointer));
    end;
  //repeat until we're at the root
  until X = 0;
end;

procedure TDefinedStream.UpdateChangeBuffer;
begin
  ClearChangeBuffer;
  FChangeBuffer := TMemoryStream.create;
  SaveToStream(FChangeBuffer);
end;

procedure TDefinedStream.AssignChangeBuffer;
begin
  Clear;
  if FChangeBuffer <> nil then
    LoadFromStream(FChangeBuffer);
end;

procedure TDefinedStream.ClearChangeBuffer;
begin
  if FChangeBuffer <> nil then
  begin
    FChangeBuffer.free;
    FChangeBuffer := nil;
  end;
end;

function TDefinedStream.SameChangeBuffer: boolean;
var MS: TMemoryStream;
begin
  result:= false;
  if FChangeBuffer = nil then Exit;
  MS:= TMemoryStream.create;
  try
    SaveToStream(MS);
    if FChangeBuffer.Size <> MS.Size then result:= false
    else result:= CompareMem(FChangeBuffer.Memory, MS.Memory, MS.Size);
  finally
    MS.free;
  end;
end;

function TDefinedStream.FindPropValue(proppath: string): string;
var
  propinfo: TPropInfo;
  Instance: TDefinedStream;
begin
  result := '';
  Instance:= Self;
  if Instance.FindProperty(proppath, Instance, propinfo) then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: result := GetStrProp(Instance, @propinfo);
      tkInteger,tkChar,tkWChar: result := inttostr(GetOrdProp(Instance, @propinfo));
      tkFloat: result := floattostr(GetFloatProp(Instance, @propinfo));
      tkEnumeration: if GetEnumProp(Instance, @propinfo) = 'True' then
        result := 'True' else result := 'False';
    end;
  end;
end;

procedure TDefinedStream.UpdatePropValue(proppath, value: string);
var
  propinfo: TPropInfo;
  Instance: TDefinedStream;
begin
  Instance:= Self;
  if Instance.FindProperty(proppath, Instance, propinfo) then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: SetStrProp(Instance, @propinfo, value);
      tkInteger: SetOrdProp(Instance, @propinfo, strtointdef(value,0));
      tkChar,tkWChar: SetOrdProp(Instance, @propinfo, strtointdef(value,0));
      tkFloat: SetFloatProp(Instance, @propinfo, strtofloatdef(value,0));
      tkEnumeration: SetEnumProp(Instance, @propinfo, value);
    end;
  end;
end;

function TDefinedStream.StoreDesign: boolean;
begin
  result := (csDesigning in ComponentState);
end;

function TDefinedStream.GetAsTest: string;
var SL: TStringlist;
begin
  SL := TStringlist.Create;
  try
    SaveToStrings(SL);
    result := SL.Text;
  finally
    SL.free;
  end;
end;

procedure TDefinedStream.SetAsText(const Value: string);
var SL: TStringlist;
begin
  SL := TStringlist.Create;
  try
    SL.Text := Value;
    LoadFromStrings(SL);
  finally
    SL.free;
  end;
end;


initialization

  RegisterClass(TDefinedStream);

end.
