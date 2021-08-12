
{*******************************************************}
{                                                       }
{       Defined Object Inspector                        }
{       Generic Class Implementation                    }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit definspect;

interface

{$I DEFINEDSTREAM.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, TypInfo
  {$IFDEF D6_PLUS}, Variants{$ENDIF};

const
  WM_CHANGELINE = WM_USER + $7001;
  WM_SPECIALCLICK = WM_USER + $7002;
  VK_CUSTOMEDITOR = 65535;

type
  TFilterPropertyEvent = procedure(Sender: TObject; const PropName, PropType: string; var Include, MultiInclude, CustomEditor: boolean) of object;
  TCustomEditorEvent = procedure(Sender: TObject; const PropName, PropType: string; ObjectList: TList; var Handled: boolean) of object;
  TValueChangeEvent = procedure(Sender: TObject; const PropName, PropType: string) of object;
  TMakeBoldEvent = procedure(Sender: TObject; const PropName, PropType: string; var MakeBold: boolean) of object;

  TOILine = class;
  TOIEdit = class;

  TDefinedInspector = class(TCustomPanel)
  private
    FScroll: TScrollingWinControl;
    FEdit: TOIEdit;
    FObjects: TList;
    FProps: TList;
    FLines: TList;
    FLineIndex: integer;
    FFilterProperty: TFilterPropertyEvent;
    FCustomEditor: TCustomEditorEvent;
    FValueChange: TValueChangeEvent;
    FMakeBold: TMakeBoldEvent;
    FOnEnterKey: TNotifyEvent;
    function GetProperty(Index: integer): PPropinfo;
    function GetPropCount: integer;
    procedure SetLineIndex(const Value: integer);
    procedure LineClick(Sender: TObject);
    procedure EditSpecialKey(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ApplyChanges;
    procedure CancelChanges;
    function GetStrPropValue(Instance: TObject; const PropName: string): Variant;
    procedure SetStrPropValue(Instance: TObject; const PropName: string; const Value: Variant);
    function GetInDropList: boolean;
  protected
    procedure KeyPress(var Key: Char); override;
    procedure ChangeLine(var Msg: TMessage); message WM_CHANGELINE;
    property LineIndex: integer read FLineIndex write SetLineIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshProperties;
    procedure UpdateProperties;
    procedure Activate;
    procedure ActivateCurrent;
    procedure InvokeEditor(PropName: string);
    procedure Resize; override;
    property Scroller: TScrollingWinControl read FScroll;
    property ObjectList: TList read FObjects;
    property Properties[Index: integer]: PPropinfo read GetProperty;
    property PropertyCount: integer read GetPropCount;
    property InDropList: boolean read GetInDropList;
  published
    property OnFilterProperty: TFilterPropertyEvent read FFilterProperty write FFilterProperty;
    property OnInvokeCustomEditor: TCustomEditorEvent read FCustomEditor write FCustomEditor;
    property OnValueChange: TValueChangeEvent read FValueChange write FValueChange;
    property OnMakeBold: TMakeBoldEvent read FMakeBold write FMakeBold;
    property OnEnterKey: TNotifyEvent read FOnEnterKey write FOnEnterKey;
    property Align;
    property Color;
    property Font;
    property Enabled;
  end;


  TOILine = class(TGraphicControl)
  private
    FPropInfo: PPropInfo;
    FPropName: string;
    FPropValue: string;
    FPropType: string;
    FPickList: TStrings;
    FSpecialEditor: integer;
    FPropIndex: integer;
    FIsActive: boolean;
    FShowBold: boolean;
    procedure SetPickList(const Value: TStrings);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property IsActive: boolean read FIsActive write FIsActive;
    property PropIndex: integer read FPropIndex write FPropIndex;
    property PropInfo: PPropInfo read FPropInfo write FPropInfo;
    property PropName: string read FPropName write FPropName;
    property PropValue: string read FPropValue write FPropValue;
    property PropType: string read FPropType write FPropType;
    property PickList: TStrings read FPickList write SetPickList;
    property SpecialEditor: integer read FSpecialEditor write FSpecialEditor; //0=none 1=picklist 2=combopop 3=onlypop
    property ShowBold: boolean read FShowBold write FShowBold;
  published
  end;


  TOIEdit = class(TEdit)
  private
    FTimer: TTimer;
    FButton: TSpeedButton;
    FListForm: TForm;
    FListBox: TListbox;
    FSpecialKey: TKeyEvent;
    procedure TimerEvent(Sender: TObject);
    procedure ButtonClick1(Sender: TObject);
    procedure ButtonClick2(Sender: TObject);
    procedure ListBoxExit(Sender: TObject);
    procedure ListboxKey(Sender: TObject; var Key: Char);
    procedure ListboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoDblClick;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSpecialClick(var Message: TWMGetDlgCode); message WM_SPECIALCLICK;
    procedure Click; override;
    procedure DblClick; override;
  public
    Ticks: cardinal;
    constructor Create(AOwner: TComponent); override;
    procedure SetMode(Mode: integer);
    property Button: TSpeedButton read FButton;
    property ListForm: TForm read FListForm;
    property ListBox: TListbox read FListBox;
    property OnSpecialKey: TKeyEvent read FSpecialKey write FSpecialKey;
  end;

implementation

{ TDefinedInspector }

constructor TDefinedInspector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF D4_D5}
  DoubleBuffered:= true;
{$ENDIF}
  ControlStyle:= ControlStyle - [csAcceptsControls];
  BevelOuter:= bvLowered;
  Width:= 225;
  Height:= 225;
  Tabstop:= true;
  {create scrolling window}
  FScroll:= TScrollingWinControl.create(Self);
  FScroll.HorzScrollBar.visible:= false;
  FScroll.VertScrollBar.visible:= true;
  FScroll.VertScrollBar.tracking:= true;
  FScroll.VertScrollBar.increment:= 16;
  FScroll.Align:= alClient;
  FScroll.Tabstop:= false;
  FScroll.Parent:= Self;
  {create OIEdit}
  FEdit:= TOIEdit.create(Self);
  FEdit.OnSpecialKey:= EditSpecialKey;
  {init variables}
  FProps:= TList.create;
  FObjects:= TList.create;
  FLines:= TList.create;
  FLineIndex:= -1;
end;

destructor TDefinedInspector.Destroy;
begin
  FLines.free;
  FProps.free;
  FObjects.free;
  inherited Destroy;
end;

function TDefinedInspector.GetPropCount: integer;
begin
  result:= FProps.count;
end;

function TDefinedInspector.GetProperty(Index: integer): PPropinfo;
begin
  result:= PPropInfo(FProps[index]);
end;

procedure TDefinedInspector.Activate;
begin
  LineIndex:= -1;
  if Enabled and (FLines.count > 0) then
    LineIndex:= 0;
end;

procedure TDefinedInspector.ActivateCurrent;
var tmpindex: integer;
begin
  tmpindex:= LineIndex;
  LineIndex:= -1;
  if Enabled and (tmpindex > -1) then
    LineIndex:= tmpindex
  else
    Activate;  
end;

procedure TDefinedInspector.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if Key = #13 then Activate;
end;

function CompareProps(Item1, Item2: Pointer): Integer;
begin
  result:= 0;
  if PPropInfo(Item1).Name > PPropInfo(Item2).Name then
    result:= 1;
  if PPropInfo(Item1).Name < PPropInfo(Item2).Name then
    result:= -1;
end;

procedure TDefinedInspector.RefreshProperties;
var
  i,j,k: integer;
  tmpPropCount: integer;
  tmpProps: PPropList;
  TypeData : PTypeData;
  flag, include, multiinclude, customeditor, makebold: boolean;

begin
  FScroll.VertScrollBar.visible:= false;
  //kill if editing
  LineIndex:= -1;
  //clear exiting props
  FProps.clear;
  FLines.clear;

  //free existing lines
  while FScroll.ControlCount > 0 do
    FScroll.Controls[0].Free;

  //fill property list with all objects
  for i:= 0 to FObjects.count-1 do
  begin
    TypeData := GetTypeData(TObject(FObjects[i]).ClassInfo);
    tmpPropCount:= TypeData.PropCount;
    GetMem(tmpProps, tmpPropCount * sizeof(Pointer));
    GetPropInfos(TObject(FObjects[i]).ClassInfo, tmpProps);
    //Add ALL properties from first obj
    if i = 0 then
      for j:= 0 to tmpPropCount-1 do
        FProps.Add(tmpProps[j]);

    //remove props if not found in next obj
    if i > 0 then
    begin
      j:= 0;
      while j < PropertyCount do
      begin
        flag:= false;
        for k:= 0 to tmpPropCount-1 do
          if comparetext(Properties[j].Name, tmpProps[k].Name) = 0 then
            flag:= true;
        if (not flag) or (Properties[j].Name = 'Name') then
        begin
          FProps.Delete(j);
          dec(j);
        end;
        inc(j);
      end;
    end;
  end;

  //sort property list
  FProps.Sort(CompareProps);

  //create prop lines
  for i:= 0 to PropertyCount-1 do
  begin
    if Properties[i].PropType^.Kind in [tkInteger, tkChar, tkEnumeration, tkFloat,
       tkString, tkSet, tkClass, tkWChar, tkLString, tkWString{$IFDEF D4_D5}, tkInt64{$ENDIF}] then
    begin
      include:= true;
      multiinclude:= true;
      customeditor:= false;
      makebold:= false;
      if Assigned(FFilterProperty) then
        FFilterProperty(Self, Properties[i].Name, Properties[i]^.PropType^.Name, include, multiinclude, customeditor);
      if Assigned(FMakeBold) then
        FMakeBold(Self, Properties[i].Name, Properties[i]^.PropType^.Name, makebold);
      if ((FObjects.count=1) and include) or ((FObjects.count>1) and multiinclude) then
      begin
        with TOILine.create(FScroll) do
        begin
          Top:= FScroll.VertScrollBar.Range+1;
          OnClick:= LineClick;
          PropIndex:= FLines.Count;
          PropInfo:= Properties[i];
          PropName:= Properties[i].Name;
          PropType:= Properties[i]^.PropType^.Name;
          ShowBold:= makebold;
          if CustomEditor then SpecialEditor:= 2;
          if Properties[i].PropType^.Kind in [tkInteger, tkChar, tkEnumeration, tkFloat,
             tkString, tkWChar, tkLString, tkWString{$IFDEF D4_D5}, tkInt64{$ENDIF}] then
          begin
            PropValue:= GetStrPropValue(FObjects[0], Properties[i].Name);
            if Properties[i].PropType^.Name = 'TColor' then
            begin
//              SpecialEditor:= 3;
              PropValue:= ColorToString(strtoint(PropValue));
            end;
            if Properties[i].PropType^.Kind = tkEnumeration then
            begin
              SpecialEditor:= 1;
              TypeData := GetTypeData(Properties[i]^.PropType^);
              for j:= TypeData.MinValue to TypeData.MaxValue do
                PickList.add(GetEnumName(Properties[i].PropType^, j));
            end;
          end
          else begin
            PropValue:= '('+Properties[i]^.PropType^.Name+')';
            if SpecialEditor = 2 then
              SpecialEditor := 3;
          end;
          Parent:= FScroll;
          Invalidate;
          FLines.Add(FScroll.Controls[FScroll.ControlCount-1]);
        end;
      end;
    end;
  end;
  FScroll.VertScrollBar.visible:= true;
end;

procedure TDefinedInspector.UpdateProperties;
var
  i: integer;
  line: TOILine;
begin
  for i:= 0 to FLines.count-1 do
  begin
    line:= TOILine(FLines[i]);
    if (length(line.PropValue) > 0) and (line.PropValue[1] = '(') then Continue;
    line.PropValue:= GetStrPropValue(FObjects[0], line.PropName);
    if line.PropType = 'TColor' then
      line.PropValue:= ColorToString(strtoint(line.PropValue));
  end;
  if (LineIndex > -1) and FEdit.visible then
    FEdit.Text:= TOILine(FLines[LineIndex]).PropValue;
end;

procedure TDefinedInspector.LineClick(Sender: TObject);
var
  Line: TOILine;
begin
  Line:= Sender as TOILine;
  {hide old edit line}
  if (LineIndex > -1) and (LineIndex <> Line.PropIndex) then
  begin
    if FObjects.Count = 1 then ApplyChanges; {only if single obj}
    TOILine(FLines[LineIndex]).IsActive:= false;
    FEdit.Parent:= nil;
  end;
  {display edit field}
  Line.IsActive:= true;
  LineIndex:= Line.PropIndex;
  FEdit.Left:= (Line.Width div 2)+1;
  FEdit.Width:= (Line.Width div 2)-1;
  FEdit.Top:= Line.Top;
  FEdit.Text:= Line.PropValue;
  FEdit.Parent:= FScroll;
  {edit mode}
  FEdit.SetMode(Line.SpecialEditor);
  FEdit.Listbox.items.clear;
  FEdit.Listbox.items.assign(Line.PickList);
  {format and focus}
  if not FEdit.Readonly then
    FEdit.SelectAll;
  if FEdit.Canfocus then
    FEdit.SetFocus;
  FEdit.Ticks:= GETTICKCOUNT;
end;

procedure TDefinedInspector.EditSpecialKey(Sender: TObject; var Key: Word; Shift: TShiftState);
var Handled: boolean;
begin
  if ((Key = VK_UP) and (not(ssAlt in Shift))) or ((Key = VK_TAB) and (ssShift in Shift)) then
  begin
    if FObjects.count = 1 then ApplyChanges;
    if LineIndex > 0 then
      PostMessage(Handle, WM_CHANGELINE, LineIndex - 1, 0);
  end;

  if ((Key = VK_DOWN) and (not(ssAlt in Shift))) or ((Key = VK_TAB) and (not(ssShift in Shift))) then
  begin
    if FObjects.count = 1 then ApplyChanges;
    if LineIndex < FLines.Count-1 then
      PostMessage(Handle, WM_CHANGELINE, LineIndex + 1, 0);
  end;

  if Key = VK_PRIOR then
  begin
    if FObjects.count = 1 then ApplyChanges;
    PostMessage(Handle, WM_CHANGELINE, 0, 0);
  end;

  if Key = VK_NEXT then
  begin
    if FObjects.count = 1 then ApplyChanges;
    PostMessage(Handle, WM_CHANGELINE, FLines.Count-1, 0);
  end;

  if Key = VK_ESCAPE then
  begin
    CancelChanges;
  end;

  if ((Key = VK_DOWN) and (ssAlt in Shift)) or ((Key = VK_RETURN) and (ssCtrl in Shift)) then
  begin
    if (FEdit.Button <> nil) and (FEdit.Button.Caption = 'h') and (FEdit.ListForm = nil) then
      FEdit.Button.click;
    if (FEdit.Button <> nil) and (FEdit.Button.Caption <> 'h') then
      FEdit.Button.click;
  end;

  if Key = VK_RETURN then
  begin
    ApplyChanges;
  end;

  if Key = VK_CUSTOMEDITOR then
  begin
    Handled:= false;
    if Assigned(FCustomEditor) then
      FCustomEditor(Self, TOILine(FLines[FLineIndex]).PropName, TOILine(FLines[FLineIndex]).PropType, FObjects, Handled);
    if not Handled then
      messagedlg('There is no editor for this property', mtWarning,[mbOK],0)
    else begin
      if TOILine(FLines[FLineIndex]).SpecialEditor < 3 then
      begin
        if TOILine(FLines[FLineIndex]).PropType = 'TColor' then
        begin
          TOILine(FLines[FLineIndex]).PropValue:= ColorToString(strtoint(GetStrPropValue(FObjects[0], TOILine(FLines[FLineIndex]).PropName)));
          FEdit.Text:= TOILine(FLines[FLineIndex]).PropValue;
        end
        else begin
          TOILine(FLines[FLineIndex]).PropValue:= GetStrPropValue(FObjects[0], TOILine(FLines[FLineIndex]).PropName);
          FEdit.Text:= TOILine(FLines[FLineIndex]).PropValue;
        end;
      end;
    end;
  end;
end;

procedure TDefinedInspector.SetLineIndex(const Value: integer);
begin
  if Value <> FLineIndex then
  begin
    FLineIndex := Value;
    if FLineIndex = -1 then
    begin
      FEdit.Parent:= nil;
    end
    else begin
      TOILine(FLines[FLineIndex]).Click;
    end;
  end;
end;

procedure TDefinedInspector.ChangeLine(var Msg: TMessage);
begin
  LineIndex:= Msg.WParam;
end;

procedure TDefinedInspector.ApplyChanges;
var x: integer;
begin
  if LineIndex < 0 then
    raise Exception.create('Line index -1 in ApplyChanges');
  if (TOILine(FLines[LineIndex]).PropValue = FEdit.Text) and (FObjects.count < 2) then Exit;
  TOILine(FLines[LineIndex]).PropValue:= FEdit.Text;
  if TOILine(FLines[LineIndex]).PropInfo.PropType^.Kind in [tkInteger, tkChar, tkEnumeration, tkFloat,
     tkString, tkWChar, tkLString, tkWString{$IFDEF D4_D5}, tkInt64{$ENDIF}] then
    for x:= 0 to FObjects.count-1 do
    begin
      if TOILine(FLines[FLineIndex]).PropType = 'TColor' then
        SetStrPropValue(TObject(FObjects[x]), TOILine(FLines[LineIndex]).PropName, StringToColor(TOILine(FLines[LineIndex]).PropValue))
      else
        SetStrPropValue(TObject(FObjects[x]), TOILine(FLines[LineIndex]).PropName, TOILine(FLines[LineIndex]).PropValue);
    end;
  UpdateProperties;
  Invalidate;
  if Assigned(FValueChange) then
    FValueChange(Self, TOILine(FLines[LineIndex]).PropName, TOILine(FLines[LineIndex]).PropType);
end;

procedure TDefinedInspector.CancelChanges;
begin
  FEdit.Text:= TOILine(FLines[LineIndex]).PropValue;
  if not FEdit.Readonly then
    FEdit.SelectAll;
end;

function TDefinedInspector.GetStrPropValue(Instance: TObject; const PropName: string): Variant;
{$IFNDEF D5_PLUS}
var
  x: integer;
  p: ppropinfo;
{$ENDIF}  
begin
{$IFDEF D5_PLUS}
  result:= GetPropValue(Instance, PropName);
{$ELSE}
  result:= 0;
  p:= nil;
  for x:= 0 to PropertyCount-1 do
    if Properties[x].Name = PropName then
      p:= Properties[x];
  if p = nil then Exit;
  case P.PropType^.Kind of
    tkInteger, tkChar, tkWChar, tkClass:
      Result := GetOrdProp(Instance, p);
    tkEnumeration:
      Result := GetEnumName(P.PropType^, GetOrdProp(Instance, p));
    tkFloat:
      Result := GetFloatProp(Instance, p);
    tkMethod:
      Result := p^.PropType^.Name;
    tkString, tkLString, tkWString:
      Result := GetStrProp(Instance, p);
    tkVariant:
      Result := GetVariantProp(Instance, p);
{$IFDEF D4_D5}
    tkInt64:
      Result := GetInt64Prop(Instance, p) + 0.0;
{$ENDIF}
{    tkSet:}
    else
      raise Exception.create('Property not supported: '+PropName);
  end;
{$ENDIF}
end;

procedure TDefinedInspector.SetStrPropValue(Instance: TObject; const PropName: string; const Value: Variant);
{$IFNDEF D5_PLUS}
var
  x: integer;
  p: ppropinfo;
  t: ptypedata;

  function RangedValue(const AMin, AMax: {$IFDEF D4_D5}Int64{$ELSE}Integer{$ENDIF}): {$IFDEF D4_D5}Int64{$ELSE}Integer{$ENDIF};
  begin
    Result := Trunc(Value);
    if Result < AMin then
      Result := AMin;
    if Result > AMax then
      Result := AMax;
  end;
{$ENDIF}
begin
{$IFDEF D5_PLUS}
  SetPropValue(Instance, PropName, Value);
{$ELSE}
  p:= nil;
  for x:= 0 to PropertyCount-1 do
    if Properties[x].Name = PropName then
      p:= Properties[x];
  if p = nil then Exit;
  t:= GetTypeData(P.PropType^);
  case P.PropType^.Kind of
    tkInteger, tkChar, tkWChar:
      SetOrdProp(Instance, P, RangedValue(t^.MinValue, t^.MaxValue));
    tkEnumeration:
      SetOrdProp(Instance, P, RangedValue(t^.MinValue, t^.MaxValue));
{    tkSet:}
    tkFloat:
      SetFloatProp(Instance, P, Value);
    tkString, tkLString, tkWString:
      SetStrProp(Instance, P, VarToStr(Value));
    tkVariant:
      SetVariantProp(Instance, P, Value);
{$IFDEF D4_D5}
    tkInt64:
      SetInt64Prop(Instance, P, RangedValue(t^.MinInt64Value, t^.MaxInt64Value));
{$ENDIF}
    else
      raise Exception.create('Property not supported: '+PropName);
  end;
{$ENDIF}
end;

procedure TDefinedInspector.InvokeEditor(PropName: string);
var
  x: integer;
  handled: boolean;
begin
  if not Assigned(FCustomEditor) then Exit;
  handled:= false;
  for x:= 0 to FLines.count-1 do
    if TOILine(FLines[x]).PropName = PropName then
    begin
      FCustomEditor(Self, TOILine(FLines[x]).PropName, TOILine(FLines[x]).PropType, FObjects, Handled);
      break;
    end;
end;

function TDefinedInspector.GetInDropList: boolean;
begin
  result:= FEdit.Visible and FEdit.ListForm.Visible;
end;

procedure TDefinedInspector.Resize;
begin
  inherited;
  FEdit.Parent:= nil;
  if LineIndex > -1 then
    TOILine(FLines[LineIndex]).IsActive:= false;
end;

{ TOILine }

constructor TOILine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align:= alTop;
  Height:= 16;
  FPickList:= TStringlist.create;
  FPropIndex:= -1;
  FPropInfo:= nil;
  FIsActive:= false;
  FSpecialEditor:= 0;
end;

destructor TOILine.Destroy;
begin
  FPickList.free;
  inherited Destroy;
end;

procedure TOILine.Paint;
var
  R1,R2: TRect;
begin
  inherited Paint;

  R1:= Rect(0,0, (Width div 2)-1, Height);
  R2:= Rect((Width div 2)+2,0, Width, Height);
  with Canvas do
  begin
    Brush.Style:= bsClear;
    Pen.Color:= clBlack;
    Pen.Style:= psSolid;
    //Draw horz lines
    Brush.Style:= bsSolid;
    Brush.Color:= clBtnFace;
    DrawFocusRect(Rect(-1,Height-1,Width+1,Height+1));
    Brush.Color:= clBtnShadow;
    DrawFocusRect(Rect(-1,Height-1,Width+1,Height+1));
    Brush.Color:= clBtnFace;
    Brush.Style:= bsClear;
    //Draw center line
    Pen.Color:= clBtnShadow;
    MoveTo(Width div 2, 0);
    LineTo(Width div 2, Height);
    Pen.Color:= clBtnHighlight;
    MoveTo((Width div 2)+1, 0);
    LineTo((Width div 2)+1, Height);
    //Draw Text
    Font.Assign(Self.Font);
    Font.Color:= clBlack;
    if ShowBold then
      Font.Style:= [fsBold];
    TextRect(R1, 4,1, PropName);
    Font.Style:= [];
    Font.Color:= clNavy;
    TextRect(R2, (Width div 2)+3,1, PropValue);
  end;
end;

procedure TOILine.SetPickList(const Value: TStrings);
begin
  FPickList.Assign(Value);
end;


{ TOIEdit }

constructor TOIEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize:= false;
  BorderStyle:= bsNone;
  Height:= 15;
  FSpecialKey:= nil;
  {create sub-components}
  FTimer:= TTimer.create(self);
  FTimer.interval:= 100;
  FTimer.enabled:= false;
  FTimer.OnTimer:= TimerEvent;
  FButton:= TSpeedButton.create(self);
  FButton.Align:= alRight;
  FButton.Width:= Height;
  FButton.Cursor:= crArrow;
  FListForm:= TForm.create(self);
  FListForm.BorderStyle:= bsNone;
  FListForm.FormStyle:= fsStayOnTop;
  FListBox:= TListbox.create(FListForm);
  FListBox.Parent:= FListForm;
  FListBox.BorderStyle:= bsSingle;
  FListBox.CTL3D:= false;
  FListBox.Align:= alClient;
  FListBox.OnMouseDown:= ListBoxMouseDown;
  FListBox.OnKeyPress:= ListBoxKey;
  FListForm.OnDeactivate:= ListBoxExit;
  FListForm.ActiveControl:= FListBox;
end;

procedure TOIEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TOIEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TOIEdit.SetMode(Mode: integer);
var
  R: TRect;
begin
  if Mode = 0 then
  begin
    Readonly:= false;
    HideSelection:= false;
    FButton.Parent:= nil;
    SetRect(R, 2, 1, Width-2, Height);
    Perform(EM_SETRECTNP, 0, longint(@R));
  end;
  if Mode = 1 then
  begin
    Readonly:= false;
    HideSelection:= true;
    FButton.Parent:= Self;
    FButton.ParentFont:= false;
    FButton.Font.name:= 'Marlett';
    FButton.Font.size:= 9;
    FButton.Font.style:= [];
    FButton.Font.charset:= DEFAULT_CHARSET;
    FButton.Caption:= 'u';
    FButton.OnClick:= ButtonClick1;
    SetRect(R, 2, 1, (Width-FButton.Width)-2, Height);
    Perform(EM_SETRECTNP, 0, longint(@R));
  end;
  if Mode = 2 then
  begin
    Readonly:= false;
    HideSelection:= true;
    FButton.Parent:= Self;
    FButton.ParentFont:= false;
    FButton.Font.name:= 'Marlett';
    FButton.Font.size:= 1;
    FButton.Font.style:= [fsBold];
    FButton.Caption:= 'hhh';
    FButton.Font.charset:= DEFAULT_CHARSET;
    FButton.OnClick:= ButtonClick2;
    SetRect(R, 2, 1, (Width-FButton.Width)-2, Height);
    Perform(EM_SETRECTNP, 0, longint(@R));
  end;
  if Mode = 3 then
  begin
    Readonly:= true;
    HideSelection:= true;
    FButton.Parent:= Self;
    FButton.ParentFont:= false;
    FButton.Font.name:= 'Marlett';
    FButton.Font.size:= 1;
    FButton.Font.style:= [fsBold];
    FButton.Caption:= 'hhh';
    FButton.Font.charset:= DEFAULT_CHARSET;
    FButton.OnClick:= ButtonClick2;
    SetRect(R, 2, 1, (Width-FButton.Width)-2, Height);
    Perform(EM_SETRECTNP, 0, longint(@R));
  end;
end;

procedure TOIEdit.ButtonClick1(Sender: TObject);
var i: integer;
begin
  if FTimer.Enabled then Exit;
  {show pick list}
  FListForm.Top:= ClientOrigin.Y+Height;
  FListForm.Left:= ClientOrigin.X;
  FListForm.Width:= Width;
  if FListBox.items.count < 8 then
    FListForm.Height:= (FListBox.items.count*13)+2
  else
    FListForm.Height:= (8*13)+2;
  if FListForm.Top + FListForm.Height > Screen.Height then
    FListForm.Top:= ClientOrigin.Y - FListForm.Height;
  for i:= 0 to FListBox.items.count-1 do
    if FListBox.items[i] = Text then
      FListBox.itemindex:= i;
  FListForm.Show;
  GetParentForm(Self).Perform(WM_NCACTIVATE, 1, 0);
end;

procedure TOIEdit.ListBoxExit(Sender: TObject);
begin
  FTimer.Enabled:= true;
  FListForm.Hide;
end;

procedure TOIEdit.ButtonClick2(Sender: TObject);
var
  AKey: Word;
  AShift: TShiftState;
begin
  AKey:= VK_CUSTOMEDITOR;
  AShift:= [];
  if Assigned(FSpecialKey) then FSpecialKey(Self, AKey, AShift);
  SetFocus;
end;

procedure TOIEdit.TimerEvent(Sender: TObject);
begin
  FTimer.Enabled:= false;
end;

procedure TOIEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if ord(Key) in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR, VK_ESCAPE, VK_RETURN, VK_TAB] then
    if Assigned(FSpecialKey) then FSpecialKey(Self, Key, Shift);
  if Key = VK_TAB then Key:= 0;
  inherited KeyDown(Key, Shift);
end;

procedure TOIEdit.KeyPress(var Key: Char);
begin
  if Key = #13 then
    if assigned((owner as TDefinedInspector).OnEnterKey) then
      (owner as TDefinedInspector).OnEnterKey(owner);
  if (Key = #9) or (Key = #13) then Key:= #0;
  if (Key = #32) and ReadOnly then DblClick;
  inherited Keypress(Key);
end;

procedure TOIEdit.ListboxKey(Sender: TObject; var Key: Char);
var
  AKey: Word;
  AShift: TShiftState;
begin
  if (ord(Key) = VK_ESCAPE) then
    SetFocus;
  if ord(Key) = VK_RETURN then
  begin
    if FListBox.itemindex > -1 then
    begin
      Text:= FListBox.Items[FListBox.itemindex];
      AKey:= VK_RETURN;
      AShift:= [];
      if Assigned(FSpecialKey) then FSpecialKey(Self, AKey, AShift);
      SetFocus;
    end;
  end;
end;

procedure TOIEdit.ListboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Key: char;
begin
  Key:= char(VK_RETURN);
  ListBoxKey(Sender, Key);
end;

procedure TOIEdit.DblClick;
begin
  inherited DblClick;
  DoDblClick;
end;

procedure TOIEdit.Click;
begin
  inherited Click;
  if ((GETTICKCOUNT - Ticks) > 100) and ((GETTICKCOUNT - Ticks) < 500) then
    PostMessage(Handle, WM_SPECIALCLICK, 0,0);
end;

procedure TOIEdit.DoDblClick;
var
  Key: char;
  i: integer;
begin
  if FButton.visible and (FButton.Caption = 'u') then
  begin
    for i:= 0 to FListBox.items.count-1 do
      if FListBox.items[i] = Text then
        FListBox.itemindex:= i;

    if FListbox.itemindex < FListbox.items.count-1 then
      FListbox.itemindex:= FListbox.itemindex + 1
    else
      FListbox.itemindex:= 0;

    Key:= char(VK_RETURN);
    ListBoxKey(FListBox, Key);
  end;

  if FButton.visible and (FButton.Caption = 'hhh') then
  begin
    FButton.Click;
  end;
end;

procedure TOIEdit.WMSpecialClick(var Message: TWMGetDlgCode);
begin
  inherited;
  Ticks:= 0;
  DoDblClick;
end;

initialization

  RegisterClass(TDefinedInspector);

end.
