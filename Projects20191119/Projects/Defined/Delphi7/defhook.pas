
{*******************************************************}
{                                                       }
{       Defined Hook                                    }
{       Main Component                                  }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit defhook;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Stdctrls, typinfo, comctrls, defstream, mask;

type
  TDefinedHook = class(TComponent)
  private
    FData: TStrings;
    FDataLink: TDefinedStream;
    FDataClass: string;
    FAutomatic: boolean;
    procedure SetData(const Value: TStrings);
    procedure SetDataLink(const Value: TDefinedStream);
    procedure SetDataClass(const Value: string);
  protected
    procedure GetData(control: TControl; propinfo: TPropInfo; instance: TDefinedStream); virtual;
    procedure PutData(control: TControl; propinfo: TPropInfo; instance: TDefinedStream); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Get; virtual;
    procedure Put; virtual;
  published
    property Data: TStrings read FData write SetData;
    property DataClass: string read FDataClass write SetDataClass;
    property DataLink: TDefinedStream read FDataLink write SetDataLink;
    property Automatic: boolean read FAutomatic write FAutomatic;
  end;

function ExtractComponent(const data: string): string;
function ExtractField(const data: string): string;
procedure StringToListview(Listview: TListview; const Value: string);
function ListviewToString(Listview: TListview): string;
procedure StringtoCombo(ComboBox: TComboBox; const Value: string);

implementation

function ExtractComponent(const data: string): string;
begin
  if pos(#9, data) > 0 then
    result:= copy(data, 1, pos(#9, data)-1)
  else
    result:= '';
end;

function ExtractField(const data: string): string;
begin
  if pos(#9, data) > 0 then
    result:= copy(data, pos(#9, data)+1, length(data))
  else
    result:= '';
end;

(*
procedure FindProperty(proppath: string; var Instance: TDefinedStream; var PropInfo: TPropInfo);
var
  X,I: integer;
  tmpstr: string;

  tmpPropCount: integer;
  tmpProps: PPropList;
  TypeData : PTypeData;

begin
  fillchar(PropInfo, sizeof(PropInfo), 0);
  repeat
    //get next token
    X:= pos('/', proppath);
    if X > 0 then
    begin
      tmpstr:= copy(proppath, 1, X-1);
      delete(proppath, 1, X);
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
          end
            else PropInfo:= tmpProps[I]^;
        end;
      end;
    //free RTTI buffer
    finally
      FreeMem(tmpProps, tmpPropCount * sizeof(Pointer));
    end;
  //repeat until we're at the root
  until X = 0;
end;
*)

procedure StringtoListview(Listview: TListview; const Value: string);
var I: integer;
begin
  for I:= 0 to Listview.items.count-1 do
  begin
    Listview.items[I].checked:= false;
    if length(Value) >= I+1 then
      if Value[I+1] = 'X' then
        Listview.items[I].checked := true;
  end;
end;

function ListviewToString(Listview: TListview): string;
var I: integer;
begin
  result:= '';
  for I:= 0 to Listview.items.count-1 do
  begin
    if Listview.items[I].checked then
      result:= result + 'X'
    else
      result:= result + ' ';
  end;
end;

procedure StringtoCombo(ComboBox: TComboBox; const Value: string);
var I: integer;
begin
  for I:= 0 to ComboBox.items.count-1 do
    if sametext(ComboBox.items[I], Value) then
      ComboBox.itemindex:= I;
end;

constructor TDefinedHook.Create(AOwner: TComponent);
begin
  inherited;
  FDataClass:= 'TDefinedStream';
  FData:= TStringlist.create;
end;

destructor TDefinedHook.Destroy;
begin
//  if FAutomatic then Put;
  FData.free;
  inherited;
end;

procedure TDefinedHook.Loaded;
begin
  inherited;
//  if FAutomatic then Get;
end;

procedure TDefinedHook.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataLink) then
    DataLink:= nil;
end;

procedure TDefinedHook.SetData(const Value: TStrings);
begin
  FData.assign(Value);
end;

procedure TDefinedHook.SetDataClass(const Value: string);
begin
  if (FDataLink = nil) or (FDataLink.Classname = Value) then
    FDataClass := Value;
end;

procedure TDefinedHook.SetDataLink(const Value: TDefinedStream);
begin
  FDataLink := Value;
  if Value <> nil then
    FDataClass:= Value.ClassName;
end;

procedure TDefinedHook.Get;
var
  I: integer;
  control: TControl;
  propinfo: TPropInfo;
  instance: TDefinedStream;
begin
  if (FDataLink = nil) then
    raise Exception.create('DataLink is nil');
  if (not (FDataLink is TDefinedStream)) then
    raise Exception.create('DataLink is not a TDefinedStream class');

  //loop thru all data links
  for I:= 0 to Data.count-1 do
  begin
    //find control by name
    control:= TControl( Owner.FindComponent( ExtractComponent(Data[I]) ));
    if control <> nil then
    begin
      //find property and class instance
      Instance:= FDataLink;
      Instance.FindProperty( ExtractField(Data[I]), instance, propinfo );
      //assign to control --- order matters here!
      if (instance <> nil) and (propinfo.Name <> '') then
        GetData(control, propinfo, instance);
    end;
  end;
end;

procedure TDefinedHook.Put;
var
  I: integer;
  control: TControl;
  propinfo: TPropInfo;
  instance: TDefinedStream;
begin
  if (FDataLink = nil) then
    raise Exception.create('DataLink is nil');
  if (not (FDataLink is TDefinedStream)) then
    raise Exception.create('DataLink is not a TDefinedStream class');

  //loop thru all data links
  for I:= 0 to Data.count-1 do
  begin
    //find control by name
    control:= TControl( Owner.FindComponent( ExtractComponent(Data[I]) ));
    if control <> nil then
    begin
      //find property and class instance
      Instance:= FDataLink;
      Instance.FindProperty( ExtractField(Data[I]), instance, propinfo );
      //assign to control --- order matters here!
      if (instance <> nil) and (propinfo.Name <> '') then
        PutData(control, propinfo, instance);
    end;
  end;
end;

procedure TDefinedHook.GetData(control: TControl; propinfo: TPropInfo; instance: TDefinedStream);
begin
  //TEdit
  if Control is TCustomEdit then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: TCustomEdit(Control).text:= GetStrProp(instance, @propinfo);
      tkInteger,tkChar,tkWChar: TCustomEdit(Control).text:= inttostr(GetOrdProp(instance, @propinfo));
      tkFloat: TCustomEdit(Control).text:= floattostr(GetFloatProp(instance, @propinfo));
    end;
  end;

  //TComboBox
  if Control is TComboBox then
  begin
    if TComboBox(Control).Style = csDropDownList then
    begin
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString: StringToCombo(TComboBox(Control), GetStrProp(instance, @propinfo));
        tkInteger,tkChar,tkWChar: ;
        tkFloat: ;
      end;
    end
    else begin
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString: TComboBox(Control).text:= GetStrProp(instance, @propinfo);
        tkInteger,tkChar,tkWChar: TComboBox(Control).text:= inttostr(GetOrdProp(instance, @propinfo));
        tkFloat: TComboBox(Control).text:= floattostr(GetFloatProp(instance, @propinfo));
      end;
    end;
  end;

  //TCheckBox
  if Control is TCheckBox then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: TCheckBox(Control).checked:= GetStrProp(instance, @propinfo) <> '';
      tkInteger,tkChar,tkWChar: TCheckBox(Control).checked:= GetOrdProp(instance, @propinfo) <> 0;
      tkEnumeration: TCheckbox(Control).checked:= GetEnumProp(instance, @propinfo) = 'True';
    end;
  end;

  //TRadioButton
  if Control is TRadioButton then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: TRadioButton(Control).checked:= GetStrProp(instance, @propinfo) <> '';
      tkInteger,tkChar,tkWChar: TRadioButton(Control).checked:= GetOrdProp(instance, @propinfo) <> 0;
      tkEnumeration: TRadioButton(Control).checked:= GetEnumProp(instance, @propinfo) = 'True';
    end;
  end;

  //TListView
  if Control is TListView then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: StringToListview(TListView(Control), GetStrProp(instance, @propinfo));
      tkInteger,tkChar,tkWChar: ;
      tkFloat: ;
    end;
  end;
end;

procedure TDefinedHook.PutData(control: TControl; propinfo: TPropInfo; instance: TDefinedStream);
begin
  //TEdit
  if Control is TCustomEdit then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: SetStrProp(instance, @propinfo, TCustomEdit(Control).text);
      tkInteger,tkChar,tkWChar: SetOrdProp(instance, @propinfo, strtointdef(TCustomEdit(Control).text,0));
      tkFloat: SetFloatProp(instance, @propinfo, strtofloat(TCustomEdit(Control).text));
    end;
  end;

  //TComboBox
  if Control is TComboBox then
  begin
    if TComboBox(Control).Style = csDropDownList then
    begin
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString: SetStrProp(instance, @propinfo, TComboBox(Control).text);
        tkInteger,tkChar,tkWChar: ;
        tkFloat: ;
      end;
    end
    else begin
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString: SetStrProp(instance, @propinfo, TComboBox(Control).text);
        tkInteger,tkChar,tkWChar: SetOrdProp(instance, @propinfo, strtointdef(TComboBox(Control).text,0));
        tkFloat: SetFloatProp(instance, @propinfo, strtofloat(TComboBox(Control).text));
      end;
    end;
  end;

  //TCheckBox
  if Control is TCheckBox then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: if TCheckBox(Control).checked then SetStrProp(instance, @propinfo, 'X') else SetStrProp(instance, @propinfo, '');
      tkInteger,tkChar,tkWChar: if TCheckBox(Control).checked then SetOrdProp(instance, @propinfo, byte(true)) else SetOrdProp(instance, @propinfo, 0);
      tkEnumeration: if TCheckbox(Control).checked then SetEnumProp(instance, @propinfo, 'True') else SetEnumProp(instance, @propinfo, 'False');
    end;
  end;

  //TRadioButton
  if Control is TRadioButton then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: if TRadioButton(Control).checked then SetStrProp(instance, @propinfo, 'X') else SetStrProp(instance, @propinfo, '');
      tkInteger,tkChar,tkWChar: if TRadioButton(Control).checked then SetOrdProp(instance, @propinfo, byte(true)) else SetOrdProp(instance, @propinfo, 0);
      tkEnumeration: if TRadioButton(Control).checked then SetEnumProp(instance, @propinfo, 'True') else SetEnumProp(instance, @propinfo, 'False');
    end;
  end;

  //TListView
  if Control is TListView then
  begin
    case propinfo.PropType^.Kind of
      tkString,tkLString,tkWString: SetStrProp(instance, @propinfo, ListviewToString(TListView(Control)));
      tkInteger,tkChar,tkWChar: ;
      tkFloat: ;
    end;
  end;
end;

end.
