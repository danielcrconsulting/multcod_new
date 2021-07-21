
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Visual Controls                                 }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfcontrols;

interface

{$I DEFINEDFORMS.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, Printers, StdCtrls, Mask, defstream, dfclasses, dfutil, dfedit;

const
  DBLCLICKTHRESH = 400;
  WM_ABORTDRAG = WM_USER + 7001;
  CM_CONVERT = 0.397;

type
  TDFClickObjectEvent = procedure(Sender: TObject; AObject: TDFObject) of object;
  TDFClickButtonEvent =  procedure(Sender: TObject; AButton: TDFButton) of object;

  TNewWinControl = class(TWinControl);

{ TDFDisplay }

  TDFDisplay = class(TCustomControl)
  private
    FEngine: TDFEngine;
    FPageIndex: integer;
    FAutoSize: boolean;
    FCenter: boolean;
    FStretch: boolean;
    FBuffer: TBitmap;
    FLastClick: cardinal;
    FClickObj: TDFClickObjectEvent;
    FDblClickObj: TDFClickObjectEvent;
    FClickButton: TDFClickButtonEvent;
    FScale: extended;
    FDisplayRect: TRect;
    FChangePage: TNotifyEvent;
    procedure _SetCenter(const Value: boolean);
    procedure _SetScale(const Value: extended);
    procedure _SetAutosize(const Value: boolean);
    procedure _SetStretch(const Value: boolean);
    function  _GetPage: TDFPage;
    function  _GetPageCount: integer;
    function  _GetExactScale: extended;
  protected
    NeedRedraw: boolean;
    procedure Paint; override;
    procedure Resize; override;
    function  CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ChangeHook(Sender: TObject; AObject: TDFStream; const ALoading: boolean); virtual;
    procedure SetPageIndex(const Value: integer); virtual;
    procedure SetEngine(const Value: TDFEngine); virtual;
    procedure DoClickObject(AObject: TDFObject); virtual;
    procedure DoDblClickObject(AObject: TDFObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshForm;
    procedure AlignToScrollBox(ScrollBox: TScrollBox; Zoom: integer); overload;
    procedure AlignToScrollBox(ScrollBox: TScrollBox; Zoom: string); overload;
    property Page: TDFPage read _GetPage;
    property PageCount: integer read _GetPageCount;
    property DisplayRect: TRect read FDisplayRect;
    property ExactScale: extended read _GetExactScale;
  published
    property FormEngine: TDFEngine read FEngine write SetEngine;
    property PageIndex: integer read FPageIndex write SetPageIndex default -1;
    property Scale: extended read FScale write _SetScale;
    property Autosize: boolean read FAutosize write _SetAutosize;
    property Center: boolean read FCenter write _SetCenter;
    property Stretch: boolean read FStretch write _SetStretch;
    property OnClickObject: TDFClickObjectEvent read FClickObj write FClickObj;
    property OnDblClickObject: TDFClickObjectEvent read FDblClickObj write FDblClickObj;
    property OnClickButton: TDFClickButtonEvent read FClickButton write FClickButton;
    property OnChangePage: TNotifyEvent read FChangePage write FChangePage;
    property Align;
    property Anchors;
    property Color default clGray;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentColor default false;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

{ TDFActiveDisplay }

  TDFActiveDisplay = class(TDFDisplay)
  private
    FEdit: TDFEdit;
    FCombobox: TDFCombobox;
    FCheckbox: TDFCheckbox;
    FMemo: TDFMemo;
    FActiveField: TDFField;
    FActiveControl: TWinControl;
    FDeactivating: boolean;
    FCreateControl: TDFControlEvent;
    FDestroyControl: TDFControlEvent;
    FDataChanged: boolean;
    procedure ControlExit(Sender: TObject);
    procedure ControlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckChange(Sender: TObject);
    procedure CMChildKey(var Message: TCMChildKey); message CM_CHILDKEY;
  protected
    procedure DoClickObject(AObject: TDFObject); override;
    procedure DoActivateField(const Value: TDFField); virtual;
    procedure DoDeactivateField; virtual;
    procedure Resize; override;
    procedure SetPageIndex(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateFirst;
    property ActiveField: TDFField read FActiveField write DoActivateField;
    property ActiveControl: TWinControl read FActiveControl;
    property DataChanged: boolean read FDataChanged write FDataChanged;
  published
    property OnCreateControl: TDFControlEvent read FCreateControl write FCreateControl;
    property OnDestroyControl: TDFControlEvent read FDestroyControl write FDestroyControl;
    property Enabled;
  end;

{ TDFDesigner }

  TDFDesigner = class(TDFDisplay)
  private
    FSelections: TList;
    FAddClass: TDFClass;
    FMouseX, FMouseY: integer;
    FAfterAdd, FAfterDelPage, FXYChange: TNotifyEvent;
    FSelChange: TNotifyEvent;
    FHotSpots: array[1..8] of TRect;
    FCurrHotSpot: integer;
    FStartRect,FDragRect: TRect;
    FDragX,FDragY: integer;
    FReallyDragging: boolean;
    FChangeBuffer, FTempBuffer: TMemoryStream;
    FCopyBuffer, FDeleteBuffer: TDFPage;
    function ScaleLeft(ALeft: integer): integer;
    function ScaleTop(ATop: integer): integer;
    function ScaleWidth(AWidth: integer): integer;
    function ScaleHeight(AHeight: integer): integer;
    function ScaleXPoint(APoint: integer): integer;
    function ScaleYPoint(APoint: integer): integer;
    function UnScale(Value: integer): integer;
    function GetSelectionRect: TRect;
    function ObjectInRect(Obj: TDFObject; ARect: TRect): boolean;
    procedure DrawDragRect(ARect: TRect);
    procedure DrawSelectionRect(ARect: TRect);
    function _GetBufferSize: integer;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure AbortDrag(var Msg: TMessage); message WM_ABORTDRAG;
    procedure DoClickObject(AObject: TDFObject); override;
    procedure DoDblClickObject(AObject: TDFObject); override;
    procedure DoSelectionChange; virtual;
    procedure SetPageIndex(const Value: integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsSelected(Obj: TDFObject): boolean;
    function IsObjectSelected: boolean;
    function IsPageSelected: boolean;
    function IsFormSelected: boolean;
    function  HasChanged: boolean;
    procedure UpdateChangeBuffer;
    procedure Optimize;
    procedure SelectPage;
    procedure SelectForm;
    procedure SelectDefaultObject(DefaultClass: TDFClass);
    procedure RemoveSelection(Obj: TDFObject);
    procedure AddSelection(AObject: TObject);
    procedure ClearSelection;
    procedure InvertSelection;
    procedure ScaleSelection(Percent: double);
    procedure AssignSelection(Dest: TList);
    procedure SelectAll;
    procedure SelectAllFields;
    procedure SelectAllText;
    procedure SelectByTag(ATag: integer);
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure UnDelete;
    procedure AlignLeftEdges;
    procedure AlignRightEdges;
    procedure AlignTopEdges;
    procedure AlignBottomEdges;
    procedure AlignSpaceHoriz;
    procedure AlignSpaceVert;
    procedure AlignSnapGrid;
    procedure AlignBringFront;
    procedure AlignSendBack;
    procedure AlignToPage;
    procedure AlignCenterHoriz;
    procedure AlignCenterVert;
    procedure MoveSelection(Xamt,Yamt: integer);
    procedure SizeSelection(Xamt,Yamt: integer);
    procedure SelectNext;
    procedure SelectPrior;
    procedure CopyLinks;
    procedure PasteLinks;
    property MouseX: integer read FMouseX write FMouseX;
    property MouseY: integer read FMouseY write FMouseY;
    property AddClass: TDFClass read FAddClass write FAddClass;
    property Selections: TList read FSelections;
    property BufferSize: integer read _GetBufferSize;
  published
    property OnAfterAdd: TNotifyEvent read FAfterAdd write FAfterAdd;
    property OnAfterDelPage: TNotifyEvent read FAfterDelPage write FAfterDelPage;    
    property OnXYChange: TNotifyEvent read FXYChange write FXYChange;
    property OnSelectionChange: TNotifyEvent read FSelChange write FSelChange;
  end;

implementation

{ TDFDisplay }

constructor TDFDisplay.Create(AOwner: TComponent);
var I: integer;
begin
  inherited;
  if (AOwner is TForm) then (AOwner as TForm).Scaled:= false;
  FEngine:= nil;
  FBuffer:= TBitmap.create;
  FScale:= 100;
  FAutoSize:= false;
  FCenter:= false;
  FStretch:= false;
  FPageIndex := -1;
  FLastClick:= 0;
  FClickObj:= nil;
  FDblClickObj:= nil;
  ParentColor:= false;
  Color:= clGray;
  Width:= 100;
  Height:= 100;
  NeedRedraw:= true;
  for I:= 0 to Owner.ComponentCount-1 do
    if Owner.Components[I] is TDFEngine then
    begin
      FormEngine:= Owner.Components[I] as TDFEngine;
      break;
    end;
end;

destructor TDFDisplay.Destroy;
begin
  FBuffer.free;
  inherited;
end;

function TDFDisplay.CanResize(var NewWidth, NewHeight: Integer): Boolean;
begin
  result:= true;
  if Autosize then
  begin
    NewWidth:= trunc(Page.Width * ExactScale);
    NewHeight:= trunc(Page.Height * ExactScale);
  end
end;

procedure TDFDisplay.Resize;
var tmpval1, tmpval2: extended;
begin
  if Stretch then
  begin
    tmpval1:= (Width / Page.Width)*100;
    tmpval2:= (Height / Page.Height)*100;
    if tmpval1 < tmpval2 then
      Scale:= tmpval1
    else
      Scale:= tmpval2;
  end;
  RefreshForm;
end;

procedure TDFDisplay.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TDFDisplay.CMColorChanged(var Message: TMessage);
begin
  inherited;
  RefreshForm;
end;

procedure TDFDisplay.Paint;
begin
  if NeedRedraw then
  begin
    FBuffer.free;
    FBuffer:= TBitmap.create;
    FBuffer.Width:= ClientRect.Right;
    FBuffer.Height:= ClientRect.Bottom;
    if Page <> nil then
    begin
      FDisplayRect:= Rect(0,0,trunc(Page.Width*(ExactScale)),trunc(Page.Height*(ExactScale)));
      if FCenter then
      begin
        if FDisplayRect.Right < Width then
        begin
          FDisplayRect.Left:= (Width-FDisplayRect.Right) div 2;
          FDisplayRect.Right:= FDisplayRect.Right + FDisplayRect.Left;
        end;
        if FDisplayRect.Bottom < Height then
        begin
          FDisplayRect.Top:= (Height-FDisplayRect.Bottom) div 2;
          FDisplayRect.Bottom:= FDisplayRect.Bottom + FDisplayRect.Top;
        end;
      end;
      if (csdesigning in Componentstate) or (Self is TDFDesigner) then
        Page.PaintTo(FBuffer.Canvas, FDisplayRect, DFDesigner)
      else if (Self is TDFActiveDisplay) then
        Page.PaintTo(FBuffer.Canvas, FDisplayRect, DFActive)
      else if (Self is TDFDisplay) then
        Page.PaintTo(FBuffer.Canvas, FDisplayRect, DFDisplay);
      FBuffer.Canvas.Brush.Color:= Color;
      FBuffer.Canvas.Brush.Style:= bsSolid;
      if FDisplayRect.left <> ClientRect.left then
        FBuffer.Canvas.FillRect( Rect(0,0,FDisplayRect.Left,ClientRect.bottom) );
      if FDisplayRect.right <> ClientRect.right then
        FBuffer.Canvas.FillRect( Rect(FDisplayRect.Right,0,ClientRect.right,ClientRect.bottom) );
      if FDisplayRect.Top <> ClientRect.Top then
        FBuffer.Canvas.FillRect( Rect(0,0,ClientRect.right,FDisplayRect.Top) );
      if FDisplayRect.Bottom <> ClientRect.Bottom then
        FBuffer.Canvas.FillRect( Rect(0,FDisplayRect.Bottom,ClientRect.right,ClientRect.bottom) );
    end
    else begin
      FBuffer.Canvas.Brush.Color:= Color;
      FBuffer.Canvas.Brush.Style:= bsSolid;
      FBuffer.Canvas.FillRect(ClientRect);
    end;
    NeedRedraw:= false;
  end;

  inherited Canvas.Draw(0,0,FBuffer);

  if (Page = nil) then
    if csDesigning in ComponentState then
      with inherited Canvas do
      begin
        Brush.Style:= bsClear;
        Pen.Color:= clBlack;
        Pen.Style:= psDash;
        Rectangle(ClientRect.Left,ClientRect.Top,ClientRect.Right,ClientRect.Bottom);
      end;
end;

procedure TDFDisplay.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  tmpobj: TDFObject;
  flag: boolean;
  Region: HRGN;
begin
  inherited;
  if csDesigning in ComponentState then Exit;
  If FEngine = nil then Exit;
  if Button <> mbLeft then Exit;
  if Page = nil then Exit;
  X:= X - FDisplayRect.left;
  Y:= Y - FDisplayRect.top;
  flag:= false;
  tmpobj:= nil;
  for i:= FormEngine.Pages[PageIndex].ObjectCount-1 downto 0 do
  begin
    tmpobj:= TDFAccess(FormEngine.Pages[PageIndex].Objects[i]);
    if (not (dfShowFields in FormEngine.PaintOptions)) and (tmpobj is TDFField) then continue;
    if (not (dfShowForm in FormEngine.PaintOptions)) and (not(tmpobj is TDFField)) then continue;
    if (not(TDFAccess(tmpobj).visible)) and (not (Self is TDFDesigner)) then continue;
    Region:= dfCreateObjectRegion(tmpobj, ExactScale);
    if Region <> 0 then
    begin
      if PtInRegion(Region, X,Y) then
      begin
        flag:= true;
        break;
      end;
      DeleteObject(Region);
    end;
  end;

  if (GetTickCount - FLastClick) < DBLCLICKTHRESH then
  begin
    if flag then
      DoDblClickObject(tmpobj)
    else
      DoDblClickObject(nil);
  end
  else begin
    if flag then
      DoClickObject(tmpobj)
    else
      DoClickObject(nil);
  end;
  FLastClick:= GetTickCount;
end;

procedure TDFDisplay.DoClickObject(AObject: TDFObject);
begin
  if AObject is TDFButton then
  begin
    if assigned(FClickButton) then FClickButton(Self, AObject as TDFButton);
  end
  else
    if assigned(FClickObj) then FClickObj(Self, AObject);
end;

procedure TDFDisplay.DoDblClickObject(AObject: TDFObject);
begin
  if assigned(FDblClickObj) then FDblClickObj(Self, AObject);
end;

procedure TDFDisplay.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FEngine) then
    FormEngine:= nil;
end;

procedure TDFDisplay.ChangeHook(Sender: TObject; AObject: TDFStream; const ALoading: boolean);
begin
  if (not ALoading) and (not (csLoading in ComponentState)) then
    if Pageindex = -1 then
      PageIndex:= 0;
  RefreshForm;
end;

procedure TDFDisplay.SetPageIndex(const Value: integer);
begin
  if (csLoading in ComponentState) or
     ((FEngine <> nil) and (Value < FEngine.PageCount) and (Value > -2)) then
    FPageIndex := Value
  else
    FPageIndex := -1;

  {$IFDEF EXPRESSIONS}
  if not(csLoading in ComponentState) and (FPageIndex > -1) then
    FEngine.CalcExpressions;
  {$ENDIF}

  if Assigned(FChangePage) then FChangePage(Self);

  RefreshForm;
end;

procedure TDFDisplay.SetEngine(const Value: TDFEngine);
begin
  if (Value = nil) and (FEngine <> nil) then
    FEngine.ChangeHook:= nil;
  FEngine:= Value;
  if (FEngine <> nil) then
  begin
    FEngine.ChangeHook:= ChangeHook;
    if Pageindex = -1 then
      PageIndex:= 0;
  end;
  RefreshForm;
end;

procedure TDFDisplay._SetAutosize(const Value: boolean);
begin
  FAutosize := Value;
  if Value then
   FStretch:= false;
  RefreshForm;
end;

procedure TDFDisplay._SetCenter(const Value: boolean);
begin
  FCenter := Value;
  RefreshForm;
end;

procedure TDFDisplay._SetStretch(const Value: boolean);
begin
  FStretch := Value;
  if Value then
   FAutosize:= false;
  RefreshForm;
end;

procedure TDFDisplay._SetScale(const Value: extended);
begin
  if (Value > 0) and (Value < 1001) then
    FScale := trunc(Value * 1000) / 1000
  else
    FScale:= 100;
  RefreshForm;
end;

procedure TDFDisplay.RefreshForm;
begin
  NeedRedraw:= true;
  if (csLoading in ComponentState) then Exit;
  if Autosize and (Page <> nil) then
  begin
    begin
      Width:= trunc(Page.Width * ExactScale);
      Height:= trunc(Page.Height * ExactScale);
    end;
  end;

  Invalidate;
end;

function TDFDisplay._GetPage: TDFPage;
begin
  if FormEngine = nil then
    result:= nil
  else begin
    if (FPageIndex > -1) and (FPageIndex < FormEngine.PageCount) then
      result := FormEngine.Pages[FPageIndex]
    else
      result := NIL;
  end;
end;

function TDFDisplay._GetPageCount: integer;
begin
  if FormEngine = nil then
    result:= 0
  else
    result := FormEngine.PageCount;
end;

function TDFDisplay._GetExactScale: extended;
begin
  result:= FScale / 100;
end;

procedure TDFDisplay.AlignToScrollBox(ScrollBox: TScrollBox; Zoom: integer);
begin
  AlignToScrollBox(ScrollBox, inttostr(Zoom));
end;

procedure TDFDisplay.AlignToScrollBox(ScrollBox: TScrollBox; Zoom: string);
var sb,sv,sh: integer;
begin
  if Page = nil then Exit;
  if Scrollbox = nil then Exit;
  //prepare
  Visible:= false;
  Autosize:= false;
  Stretch:= true;
  //get scrollbox metrics
  if ScrollBox.BorderStyle = bsSingle then sb:= 4 else sb:= 0;
  sv:= GetSystemMetrics( SM_CXVSCROLL );
  sh:= GetSystemMetrics( SM_CXHSCROLL );
  //align to fit width
  if Zoom = 'PW' then
  begin
    Width:= ScrollBox.Width - sb;
    Height:= trunc( Page.Height * (Width / Page.Width) );
    if Height > ScrollBox.Height + sb then
    begin
      Width:= ScrollBox.Width - (sv+sb);
      Height:= trunc( Page.Height * (Width / Page.Width) );
    end;
  end
  //align to fit height
  else if Zoom = 'PH' then
  begin
    Height:= ScrollBox.Height - sb;
    Width:= trunc( Page.Width * (Height / Page.Height) );
    if Width > ScrollBox.Width + sb then
    begin
      Height:= ScrollBox.Height - (sh+sb);
      Width:= trunc( Page.Width * (Height / Page.Height) );
    end;
  end
  //align to percent
  else if strtointdef(Zoom,0)>0 then
  begin
    Autosize:= true;
    Scale:= strtointdef(Zoom,0);
    Autosize:= false;
  end;
  //stretch if possible for centering
  if Height > ScrollBox.Height + sb then
  begin
    if Width < ScrollBox.Width + sb+sv then
      Width:= ScrollBox.Width - (sb+sv);
  end
  else begin
    if Width < ScrollBox.Width + sb then
      Width:= ScrollBox.Width - sb;
  end;
  if Width > ScrollBox.Width + sb then
  begin
    if Height < ScrollBox.Height + sb+sh then
      Height:= ScrollBox.Height - (sb+sh);
  end
  else begin
    if Height < ScrollBox.Height + sb then
      Height:= ScrollBox.Height - sb;
  end;
  //update
  Visible:= true;
end;


{ TDFDesigner }

constructor TDFDesigner.Create(AOwner: TComponent);
begin
  inherited;
  FSelections:= TList.create;
  FChangeBuffer:= TMemoryStream.create;
  FTempBuffer:= TMemoryStream.create;
  FCopyBuffer:= TDFPage.create(nil);
  FDeleteBuffer:= TDFPage.create(nil);
  FReallyDragging:= false;
  fillchar(FHotSpots, sizeof(FHotSpots), 0);
  FCurrHotSpot:= 0;
  DragKind:= dkDrag;
  DragMode:= dmManual;
  Cursor:= crDefault;
end;

destructor TDFDesigner.Destroy;
begin
  inherited;
  while FCopyBuffer.ObjectCount > 0 do FCopyBuffer.Objects[0].delete;
  while FDeleteBuffer.ObjectCount > 0 do FDeleteBuffer.Objects[0].delete;
  FSelections.free;
  FChangeBuffer.free;
  FTempBuffer.free;
  FCopyBuffer.free;
  FDeleteBuffer.free;
end;

procedure TDFDesigner.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMouseX:= X - FDisplayRect.left;
  FMouseY:= Y - FDisplayRect.top;
  if Assigned(FXYChange) then FXYChange(Self);
  if FReallyDragging then Exit;
  If FEngine = nil then Exit;
  if FSelections.count <> 1 then Exit;
  if (not IsObjectSelected) then Exit;
  if (FAddClass <> nil) then Exit;
  if PageIndex < 0 then Exit;
  if Page = nil then Exit;
  {check for mouse Hotspots}
  if (X > FHotspots[1].Left) and (X < FHotspots[1].Right ) and
     (Y > FHotspots[1].Top ) and (Y < FHotspots[1].Bottom) then
  begin
    FCurrHotSpot:= 1;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeNWSE;
  end
  else
  if (X > FHotspots[2].Left) and (X < FHotspots[2].Right ) and
     (Y > FHotspots[2].Top ) and (Y < FHotspots[2].Bottom) then
  begin
    FCurrHotSpot:= 2;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeNS;
  end
  else
  if (X > FHotspots[3].Left) and (X < FHotspots[3].Right ) and
     (Y > FHotspots[3].Top ) and (Y < FHotspots[3].Bottom) then
  begin
    FCurrHotSpot:= 3;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeNESW;
  end
  else
  if (X > FHotspots[4].Left) and (X < FHotspots[4].Right ) and
     (Y > FHotspots[4].Top ) and (Y < FHotspots[4].Bottom) then
  begin
    FCurrHotSpot:= 4;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeWE;
  end
  else
  if (X > FHotspots[5].Left) and (X < FHotspots[5].Right ) and
     (Y > FHotspots[5].Top ) and (Y < FHotspots[5].Bottom) then
  begin
    FCurrHotSpot:= 5;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeNWSE;
  end
  else
  if (X > FHotspots[6].Left) and (X < FHotspots[6].Right ) and
     (Y > FHotspots[6].Top ) and (Y < FHotspots[6].Bottom) then
  begin
    FCurrHotSpot:= 6;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeNS;
  end
  else
  if (X > FHotspots[7].Left) and (X < FHotspots[7].Right ) and
     (Y > FHotspots[7].Top ) and (Y < FHotspots[7].Bottom) then
  begin
    FCurrHotSpot:= 7;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeNESW;
  end
  else
  if (X > FHotspots[8].Left) and (X < FHotspots[8].Right ) and
     (Y > FHotspots[8].Top ) and (Y < FHotspots[8].Bottom) then
  begin
    FCurrHotSpot:= 8;
    if (TObject(Selections[0]) is TDFLine) then
      Cursor:= crSize
    else
      Cursor:= crSizeWE;
  end
  else begin
    FCurrHotSpot:= 0;
    Cursor:= crDefault;
  end;
end;

procedure TDFDesigner.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewObject: TDFAccess;
begin
  inherited;
  If FEngine = nil then Exit;
  if Button <> mbLeft then Exit;
  if Pageindex < 0 then Exit;

  { add object }
  if (Cursor = crDrag) and (FAddClass <> nil) then
  begin
    NewObject:= TDFAccess(FEngine.Pages[PageIndex].AddObject(FAddClass));
    if not dfShiftDown then
    begin
      FAddClass:= nil;
      Cursor:= crDefault;
      ClearSelection;
    end
    else
      if not IsObjectSelected then
        ClearSelection;
    AddSelection(NewObject);
    NewObject.Left:= trunc(FMouseX / ExactScale);
    NewObject.Top:= trunc(FMouseY / ExactScale);
    if Assigned(FAfterAdd) then FAfterAdd(Self);
  end
  { drag object }
  else begin
    if (FSelections.count = 1) and IsObjectSelected then
    begin
      FStartRect:= GetSelectionRect;
      FDragRect:= GetSelectionRect;
      FDragX:= X;
      FDragY:= Y;
      Cursor:= crDefault;
      DragCursor:= crDrag;
      FReallyDragging:= false;
      BeginDrag(false, 5);
    end
    else if (FSelections.count > 1) and IsObjectSelected then
    begin
      FStartRect:= GetSelectionRect;
      FDragRect:= GetSelectionRect;
      FDragX:= X;
      FDragY:= Y;
      Cursor:= crDefault;
      DragCursor:= crMultiDrag;
      FReallyDragging:= false;
      BeginDrag(false, 5);
    end
    else begin
      {draw selection rect}
      FDragRect.Left:= X;
      FDragRect.Top:= Y;
      FDragRect.Right:= X;
      FDragRect.Bottom:= Y;
      FDragX:= X;
      FDragY:= Y;
      Cursor:= crDefault;
      DragCursor:= crHandPoint;
      FReallyDragging:= false;
      BeginDrag(false, 5);
    end;
  end;
end;

procedure TDFDesigner.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
  If FEngine = nil then Exit;
  if PageIndex < 0 then Exit;
  FReallyDragging:= true;
  Accept:= true;
  if DragCursor <> crHandPoint then
  begin
    {erase previous rect}
    DrawDragRect(FDragRect);
    {sizing object}
    if FCurrHotSpot = 1 then
    begin
      if not ((FSelections.count = 1) and (TObject(FSelections[0]) is TDFLine)) then
        FDragRect:= Rect(X, Y, Fdragrect.right, Fdragrect.Bottom)
      else
        FDragRect:= Rect(ScaleXPoint(TDFLine(FSelections[0]).X2), ScaleYPoint(TDFLine(FSelections[0]).Y2), X,Y); //lines
    end
    else if FCurrHotSpot = 2 then
    begin
      if not ((FSelections.count = 1) and (TObject(FSelections[0]) is TDFLine)) then
        FDragRect:= Rect(Fdragrect.left, Y, Fdragrect.right, Fdragrect.Bottom)
      else
        FDragRect:= Rect(ScaleXPoint(TDFLine(FSelections[0]).X1), ScaleYPoint(TDFLine(FSelections[0]).Y1), X,Y); //lines
    end
    else if FCurrHotSpot = 3 then FDragRect:= Rect(Fdragrect.left, Y, X, Fdragrect.Bottom)
    else if FCurrHotSpot = 4 then FDragRect:= Rect(Fdragrect.left, Fdragrect.top, X, Fdragrect.Bottom)
    else if FCurrHotSpot = 5 then FDragRect:= Rect(Fdragrect.left, Fdragrect.top, X, Y)
    else if FCurrHotSpot = 6 then FDragRect:= Rect(Fdragrect.left, Fdragrect.top, Fdragrect.Right, Y)
    else if FCurrHotSpot = 7 then FDragRect:= Rect(X, Fdragrect.top, Fdragrect.right, Y)
    else if FCurrHotSpot = 8 then FDragRect:= Rect(X, Fdragrect.top, Fdragrect.right, Fdragrect.Bottom)
    {moving object}
    else begin
      FDragRect:= Rect( FStartRect.Left + (X - FDragX), FStartRect.Top + (Y - FDragY),
                        FStartRect.Right + (X - FDragX), FStartRect.Bottom + (Y - FDragY) );
    end;
    {draw new rect}
    DrawDragRect(FDragRect);
  end

  else begin
    //draw selection rect
    DrawSelectionRect(FDragRect);
    FDragRect:= Rect(FDragX,FDragY,X,Y);
    DrawSelectionRect(FDragRect);
  end
end;

procedure TDFDesigner.DoEndDrag(Target: TObject; X, Y: Integer);
var
  I: integer;
  tmpobj: TDFObject;
begin
  inherited;
  If FEngine = nil then Exit;
  if PageIndex < 0 then Exit;
  if Page = nil then Exit;
  if not FReallyDragging then Exit;
  FReallyDragging:= false;
  X:= X - FDisplayRect.left;
  Y:= Y - FDisplayRect.top;
  if DragCursor <> crHandPoint then
  begin
    if FSelections.count = 1 then
    begin
      if not (TObject(FSelections[0]) is TDFLine) then
      begin
        TDFAccess(FSelections[0]).Left:= TDFAccess(FSelections[0]).Left + UnScale(Fdragrect.left - Fstartrect.left);
        TDFAccess(FSelections[0]).Top:= TDFAccess(FSelections[0]).Top + UnScale(Fdragrect.top - Fstartrect.top);
        TDFAccess(FSelections[0]).Width:= abs(UnScale(Fdragrect.right - Fdragrect.left));
        TDFAccess(FSelections[0]).Height:= abs(UnScale(Fdragrect.bottom - Fdragrect.top));
      end
      else begin
        if FCurrHotSpot = 1 then
        begin
          TDFLine(FSelections[0]).X1:= UnScale(X);
          TDFLine(FSelections[0]).Y1:= UnScale(Y);
        end
        else if FCurrHotSpot = 2 then
        begin
          TDFLine(FSelections[0]).X2:= UnScale(X);
          TDFLine(FSelections[0]).Y2:= UnScale(Y);
        end
        else begin
          TDFLine(FSelections[0]).X1:= TDFLine(FSelections[0]).X1 + UnScale(Fdragrect.left - Fstartrect.left);
          TDFLine(FSelections[0]).Y1:= TDFLine(FSelections[0]).Y1 + UnScale(Fdragrect.top - Fstartrect.top);
          TDFLine(FSelections[0]).X2:= TDFLine(FSelections[0]).X2 + UnScale(Fdragrect.left - Fstartrect.left);
          TDFLine(FSelections[0]).Y2:= TDFLine(FSelections[0]).Y2 + UnScale(Fdragrect.top - Fstartrect.top);
        end;
      end;
    end
    else begin
      for I:= 0 to FSelections.count-1 do
      begin
        if not (TObject(FSelections[i]) is TDFLine) then
        begin
          TDFAccess(FSelections[i]).Left:= TDFAccess(FSelections[i]).Left + UnScale(Fdragrect.left - Fstartrect.left);
          TDFAccess(FSelections[i]).Top:= TDFAccess(FSelections[i]).Top + UnScale(Fdragrect.top - Fstartrect.top);
        end
        else begin
          TDFLine(FSelections[i]).X1:= TDFLine(FSelections[i]).X1 + UnScale(Fdragrect.left - Fstartrect.left);
          TDFLine(FSelections[i]).Y1:= TDFLine(FSelections[i]).Y1 + UnScale(Fdragrect.top - Fstartrect.top);
          TDFLine(FSelections[i]).X2:= TDFLine(FSelections[i]).X2 + UnScale(Fdragrect.left - Fstartrect.left);
          TDFLine(FSelections[i]).Y2:= TDFLine(FSelections[i]).Y2 + UnScale(Fdragrect.top - Fstartrect.top);
        end;
      end;
    end;
  end
  //selection rect
  else begin
    ClearSelection;
    FDragRect:= dfPositiveRect(FDragRect);
    FDragRect.Left:= FDragRect.Left - FDisplayRect.left;
    FDragRect.Right:= FDragRect.Right - FDisplayRect.left;
    FDragRect.Top:= FDragRect.Top - FDisplayRect.top;
    FDragRect.Bottom:= FDragRect.Bottom - FDisplayRect.top;
    for i:= Page.ObjectCount-1 downto 0 do
    begin
      tmpobj:= TDFAccess(Page.Objects[i]);
      if (not (DFshowfields in FormEngine.PaintOptions)) and (tmpobj is TDFField) then continue;
      if (not (DFshowform in FormEngine.PaintOptions)) and (not(tmpobj is TDFField)) then continue;
      if not (TDFAccess(tmpobj).visible) then continue;
      if ObjectInRect(tmpobj, FDragRect) then
        Selections.Add(tmpobj);
    end;
  end;
  DragCursor:= crDrag;
  RefreshForm;
  DoSelectionChange;
end;

procedure TDFDesigner.AbortDrag(var Msg: TMessage);
begin
  If FEngine = nil then Exit;
  FReallyDragging:= false;
  EndDrag(false);
  Cursor:= crDefault;
  DragCursor:= crDrag;
end;

procedure TDFDesigner.Paint;
var
  I, X1,Y1,X2,Y2: integer;
  R: TRect;
begin
  inherited;
  with inherited Canvas do
  begin
    Brush.Style:= bsSolid;
    if FSelections.count > 1 then
      Brush.Color:= clTeal
    else
      Brush.Color:= clBlue;
    fillchar(FHotSpots, sizeof(FHotSpots), 0);
    if IsObjectSelected then
    begin
      for I:= 0 to FSelections.count-1 do
      begin
        if not (TObject(FSelections[i]) is TDFLine) then
        begin
          {Non-Line}
          X1:= ScaleLeft(TDFAccess(FSelections[i]).Left);
          Y1:= ScaleTop(TDFAccess(FSelections[i]).Top);
          Y2:= Y1+ScaleHeight(TDFAccess(FSelections[i]).Height);
          if (TObject(FSelections[i]) is TDFText) and (TDFText(FSelections[i]).Angle <> 0) then
            X2:= X1 + abs(Y2 - Y1) {angled text}
          else
            X2:= X1+ScaleWidth(TDFAccess(FSelections[i]).Width);
          {UL}
          R:= Rect(X1-3,Y1-3,X1+3,Y1+3);
          FillRect(R);
          Inflaterect(R,1,1);
          if FSelections.count = 1 then FHotSpots[1]:= R;
          {UM}
          if FSelections.count = 1 then
          begin
            R:= Rect(X1+((X2-X1) div 2)-3,Y1-3,X1+((X2-X1) div 2)+3,Y1+3);
            FillRect(R);
            Inflaterect(R,1,1);
            FHotspots[2]:= R;
          end;
          {UR}
          R:= Rect(X2-3,Y1-3,X2+3,Y1+3);
          FillRect(R);
          Inflaterect(R,1,1);
          if FSelections.count = 1 then FHotspots[3]:= R;
          {RM}
          if FSelections.count = 1 then
          begin
            R:= Rect(X2-3,Y1+((Y2-Y1) div 2)-3,X2+3,Y1+((Y2-Y1) div 2)+3);
            FillRect(R);
            Inflaterect(R,1,1);
            FHotspots[4]:= R;
          end;
          {LR}
          R:= Rect(X2-3,Y2-3,X2+3,Y2+3);
          FillRect(R);
          Inflaterect(R,1,1);
          if FSelections.count = 1 then FHotspots[5]:= R;
          {BM}
          if FSelections.count = 1 then
          begin
            R:= Rect(X1+((X2-X1) div 2)-3,Y2-3,X1+((X2-X1) div 2)+3,Y2+3);
            FillRect(R);
            Inflaterect(R,1,1);
            FHotspots[6]:= R;
          end;
          {LL}
          R:= Rect(X1-3,Y2-3,X1+3,Y2+3);
          FillRect(R);
          Inflaterect(R,1,1);
          if FSelections.count = 1 then FHotspots[7]:= R;
          {LM}
          if FSelections.count = 1 then
          begin
            R:= Rect(X1-3,Y1+((Y2-Y1) div 2)-3,X1+3,Y1+((Y2-Y1) div 2)+3);
            FillRect(R);
            Inflaterect(R,1,1);
            FHotspots[8]:= R;
          end;
        end
        else begin
          {Line}
          X1:= ScaleXPoint(TDFLine(FSelections[i]).X1);
          Y1:= ScaleYPoint(TDFLine(FSelections[i]).Y1);
          X2:= ScaleXPoint(TDFLine(FSelections[i]).X2);
          Y2:= ScaleYPoint(TDFLine(FSelections[i]).Y2);

          {Line Point1}
          R:= Rect(X1-3,Y1-3,X1+3,Y1+3);
          FillRect(R);
          Inflaterect(R,1,1);
          if FSelections.count = 1 then FHotspots[1]:= R;
          {Line Point2}
          R:= Rect(X2-3,Y2-3,X2+3,Y2+3);
          FillRect(R);
          Inflaterect(R,1,1);
          if FSelections.count = 1 then FHotspots[2]:= R;
        end;
      end;
    end;
  end; {with}
end;

function TDFDesigner.IsSelected(Obj: TDFObject): boolean;
var x: integer;
begin
  result:= false;
  for x:= 0 to FSelections.count-1 do
    if FSelections[x] = Obj then
    begin
      result:= true;
      break;
    end;
end;

function TDFDesigner.IsObjectSelected: boolean;
begin
  if (Selections.count > 0) and (TObject(Selections[0]) is TDFObject) then
    result:= true
  else
    result:= false;
end;

function TDFDesigner.IsPageSelected: boolean;
begin
  if (Selections.count > 0) and (TObject(Selections[0]) is TDFPage) then
    result:= true
  else
    result:= false;
end;

function TDFDesigner.IsFormSelected: boolean;
begin
  if (Selections.count > 0) and (TObject(Selections[0]) is TDFForm) then
    result:= true
  else
    result:= false;
end;

procedure TDFDesigner.SelectAll;
var x: integer;
begin
  if (Page <> nil) then
  begin
    Selections.clear;
    for x:= 0 to Page.ObjectCount-1 do
      Selections.Add(Page.Objects[x]);
  end;
  DoSelectionChange;
  Invalidate;
end;

procedure TDFDesigner.SelectAllFields;
var x: integer;
begin
  if (Page <> nil) then
  begin
    Selections.clear;
    for x:= 0 to Page.ObjectCount-1 do
      if Page.Objects[x] is TDFField then
        Selections.Add(Page.Objects[x]);
  end;
  DoSelectionChange;
  Invalidate;
end;

procedure TDFDesigner.SelectAllText;
var x: integer;
begin
  if (Page <> nil) then
  begin
    Selections.clear;
    for x:= 0 to Page.ObjectCount-1 do
      if Page.Objects[x] is TDFText then
        Selections.Add(Page.Objects[x]);
  end;
  DoSelectionChange;
  Invalidate;
end;

procedure TDFDesigner.SelectByTag(ATag: integer);
var x: integer;
begin
  if (Page <> nil) then
  begin
    Selections.clear;
    for x:= 0 to Page.ObjectCount-1 do
      if Page.Objects[x].Tag = ATag then
        Selections.Add(Page.Objects[x]);
  end;
  DoSelectionChange;
  Invalidate;
end;


procedure TDFDesigner.DoClickObject(AObject: TDFObject);
begin
  If FEngine = nil then Exit;
  if (Cursor = crSize) or (Cursor = crSizeNWSE) or (Cursor = crSizeNS) or (Cursor = crSizeNESW) or (Cursor = crSizeWE) then Exit;

  if IsSelected(AObject) and dfShiftDown then
  begin
    RemoveSelection(AObject);
  end
  else begin
    if IsSelected(AObject) then Exit;
    if not dfShiftDown then
      ClearSelection;
    if AObject <> nil then
      AddSelection(AObject)
    else if (Page <> nil) and (FSelections.count = 0) then
      SelectPage;
  end;

  Invalidate;
  inherited;
end;

procedure TDFDesigner.DoDblClickObject(AObject: TDFObject);
begin
  inherited;
  PostMessage(Handle, WM_ABORTDRAG, 0, 0);
end;

function TDFDesigner.ScaleLeft(ALeft: integer): integer;
begin
  result:= DisplayRect.Left + trunc(ALeft * ExactScale);
end;

function TDFDesigner.ScaleTop(ATop: integer): integer;
begin
  result:= DisplayRect.Top + trunc(ATop * ExactScale);
end;

function TDFDesigner.ScaleHeight(AHeight: integer): integer;
begin
  result:= trunc(AHeight * ExactScale);
end;

function TDFDesigner.ScaleWidth(AWidth: integer): integer;
begin
  result:= trunc(AWidth * ExactScale);
end;

function TDFDesigner.ScaleXPoint(APoint: integer): integer;
begin
  result:= DisplayRect.Left + trunc(APoint * ExactScale);
end;

function TDFDesigner.ScaleYPoint(APoint: integer): integer;
begin
  result:= DisplayRect.Top + trunc(APoint * ExactScale);
end;

function TDFDesigner.UnScale(Value: integer): integer;
begin
  if ExactScale > 0 then
    result:= trunc(Value / ExactScale)
  else
    result:= Value;
end;

procedure TDFDesigner.DrawDragRect(ARect: TRect);
begin
  {setup XOR mask}
  Canvas.Brush.Style:= bsClear;
  Canvas.Pen.Color:= clWhite;
  Canvas.Pen.Mode:= pmXOR;
  Canvas.Pen.Style:= psDot;
  {draw stretchy rectangle}
  if not ((FSelections.count = 1) and (TObject(FSelections[0]) is TDFLine)) then
    Canvas.Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom)
  else begin
    Canvas.MoveTo(ARect.Left, ARect.Top);
    Canvas.LineTo(ARect.Right, ARect.Bottom);
  end;
  {restore XOR mask}
  Canvas.Pen.Mode:= pmCopy;
  Canvas.Pen.Style:= psSolid;
end;

procedure TDFDesigner.DrawSelectionRect(ARect: TRect);
begin
  {setup XOR mask}
  Canvas.Brush.Style:= bsClear;
  Canvas.Pen.Color:= clWhite;
  Canvas.Pen.Mode:= pmXOR;
  Canvas.Pen.Style:= psDot;
  {draw stretchy rectangle}
  Canvas.Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
  {restore XOR mask}
  Canvas.Pen.Mode:= pmCopy;
  Canvas.Pen.Style:= psSolid;
end;

function TDFDesigner.GetSelectionRect: TRect;
var
  R,R2: TRect;
  x: integer;
begin
  R.left:= 0;
  R.top:= 0;
  R.right:= 0;
  R.bottom:= 0;
  if (FSelections.count = 1) and IsObjectSelected then
  begin
    if not (TObject(FSelections[0]) is TDFLine) then
    begin
      R.Left:= ScaleLeft(TDFAccess(FSelections[0]).Left);
      R.Top:= ScaleTop(TDFAccess(FSelections[0]).Top);
      R.Right:= R.Left + ScaleWidth(TDFAccess(FSelections[0]).Width);
      R.Bottom:= R.Top + ScaleHeight(TDFAccess(FSelections[0]).Height);
    end
    else begin
      R.Left:= ScaleXPoint(TDFLine(FSelections[0]).X1);
      R.Top:= ScaleYPoint(TDFLine(FSelections[0]).Y1);
      R.Right:= ScaleXPoint(TDFLine(FSelections[0]).X2);
      R.Bottom:= ScaleYPoint(TDFLine(FSelections[0]).Y2);
    end;
  end
  else if (FSelections.count > 1) and IsObjectSelected then
  begin
    R.left:= 32767;
    R.top:= 32767;
    R.right:= -1;
    R.bottom:= -1;
    for x:= 0 to FSelections.count-1 do
    begin
      if not (TObject(FSelections[x]) is TDFLine) then
      begin
        if R.Left > ScaleLeft(TDFAccess(FSelections[x]).Left) then
          R.Left:= ScaleLeft(TDFAccess(FSelections[x]).Left);
        if R.Top > ScaleTop(TDFAccess(FSelections[x]).Top) then
          R.Top:= ScaleTop(TDFAccess(FSelections[x]).Top);
        if R.Right < ScaleLeft(TDFAccess(FSelections[x]).Left) + ScaleWidth(TDFAccess(FSelections[x]).Width) then
          R.Right:= ScaleLeft(TDFAccess(FSelections[x]).Left) + ScaleWidth(TDFAccess(FSelections[x]).Width);
        if R.Bottom < ScaleTop(TDFAccess(FSelections[x]).Top) + ScaleHeight(TDFAccess(FSelections[x]).Height) then
          R.Bottom:= ScaleTop(TDFAccess(FSelections[x]).Top) + ScaleHeight(TDFAccess(FSelections[x]).Height);
      end
      else begin
        R2.Left:= ScaleXPoint(TDFLine(FSelections[x]).X1);
        R2.Top:= ScaleYPoint(TDFLine(FSelections[x]).Y1);
        R2.Right:= ScaleXPoint(TDFLine(FSelections[x]).X2);
        R2.Bottom:= ScaleYPoint(TDFLine(FSelections[x]).Y2);
        R2:= dfPositiveRect(R2);
        if R.Left > R2.Left then
          R.Left:= R2.Left;
        if R.Top > R2.Top then
          R.Top:= R2.Top;
        if R.Right < R2.Right then
          R.Right:= R2.Right;
        if R.Bottom < R2.Bottom then
          R.Bottom:= R2.Bottom;
      end;
    end;
  end;
  Result:= R;
end;

function TDFDesigner.ObjectInRect(Obj: TDFObject; ARect: TRect): boolean;
var Region: HRGN;
begin
  Region:= dfCreateObjectRegion(Obj, ExactScale);
  if Region <> 0 then
    result:= RectInRegion(Region, ARect)
  else
    result:= false;
end;

procedure TDFDesigner.SetPageIndex(const Value: integer);
begin
  ClearSelection;
  inherited;
end;

procedure TDFDesigner.UpdateChangeBuffer;
begin
  if FEngine = nil then Exit;
  FChangeBuffer.clear;
  FEngine.SavetoStream(FChangeBuffer);
end;

function TDFDesigner.HasChanged: boolean;
begin
  result:= false;
  if FEngine = nil then Exit;
  FTempBuffer.clear;
  FEngine.SavetoStream(FTempBuffer);
  if (FTempBuffer.Size <> FChangeBuffer.Size) or
     (not(CompareMem(FTempBuffer.Memory, FChangeBuffer.Memory, FTempBuffer.Size))) then
    result:= true;
  FTempBuffer.clear;
end;

function TDFDesigner._GetBufferSize: integer;
begin
  result:= FChangeBuffer.Size;
end;

procedure TDFDesigner.Optimize;
var I: integer;
    L: TList;
begin
  L:= TList.create;
  try
    for I:= 0 to FormEngine.FieldCount-1 do
      L.Add(FormEngine.Fields[I]);
    for I:= 0 to L.Count-1 do
      TDFObject(L[I]).MoveFirst;
  finally
    L.free;
  end;
  //could use more optimization
end;

procedure TDFDesigner.DoSelectionChange;
begin
  Invalidate;
  if Assigned(FSelChange) then FSelChange(Self);
end;

procedure TDFDesigner.SelectPage;
begin
  ClearSelection;
  if Page <> nil then
    Selections.Add(Page);
  DoSelectionChange;
end;

procedure TDFDesigner.SelectForm;
begin
  ClearSelection;
  if Page <> nil then
    Selections.Add(Page.Form);
  DoSelectionChange;
end;

procedure TDFDesigner.SelectDefaultObject(DefaultClass: TDFClass);
var DFObject: TDefinedStream;
begin
  ClearSelection;
  DFObject:= FormEngine.Form.FindChild(DefaultClass,0);
  if DFObject <> nil then
    Selections.Add(DFObject);
  DoSelectionChange;
end;

procedure TDFDesigner.AddSelection(AObject: TObject);
var
  I: integer;
  Flag: boolean;
begin
  Flag:= false;
  if (AObject is TDFPage) or (AObject is TDFForm) then
    ClearSelection
  else
    for I:= 0 to FSelections.count-1 do
      if FSelections[I] = AObject then
        Flag:= true;
  if not Flag then
    FSelections.Add(AObject);
  DoSelectionChange;
end;

procedure TDFDesigner.RemoveSelection(Obj: TDFObject);
var x: integer;
begin
  for x:= 0 to FSelections.Count-1 do
    if FSelections[x] = Obj then
    begin
      FSelections.Delete(x);
      break;
    end;
  DoSelectionChange;
end;

procedure TDFDesigner.ClearSelection;
begin
  FSelections.Clear;
  DoSelectionChange;
end;

procedure TDFDesigner.InvertSelection;
var
  i,j: integer;
  flag: boolean;
  tmpSel: TList;
begin
  if (Page = nil) then Exit;
  if (not IsObjectSelected) then Exit;
  tmpSel:= TList.create;
  try
    for i:= 0 to Page.ObjectCount-1 do
    begin
      flag:= false;
      for j:= 0 to Selections.count-1 do
        if Selections[j] = Page.Objects[i] then
          flag:= true;
      if not flag then
        tmpSel.Add(Page.Objects[i]);
    end;
    Selections.clear;
    for i:= 0 to tmpSel.count-1 do
      Selections.Add(tmpSel[i]);
  finally
    tmpSel.free;
  end;
  DoSelectionChange;
  Invalidate;
end;

procedure TDFDesigner.ScaleSelection(Percent: double);
var
  x: integer;
begin
  if (not IsObjectSelected) then Exit;
  Percent:= Percent / 100;
  for x:= 0 to Selections.count-1 do
  begin
    if TObject(Selections[x]) is TDFLine then
    begin
      TDFLine(Selections[x]).X1:= trunc(TDFLine(Selections[x]).X1 * Percent);
      TDFLine(Selections[x]).X2:= trunc(TDFLine(Selections[x]).X2 * Percent);
      TDFLine(Selections[x]).Y1:= trunc(TDFLine(Selections[x]).Y1 * Percent);
      TDFLine(Selections[x]).Y2:= trunc(TDFLine(Selections[x]).Y2 * Percent);
    end
    else begin
      TDFAccess(Selections[x]).Left:= trunc(TDFAccess(Selections[x]).Left * Percent);
      TDFAccess(Selections[x]).Top:= trunc(TDFAccess(Selections[x]).Top * Percent);
      TDFAccess(Selections[x]).Width:= trunc(TDFAccess(Selections[x]).Width * Percent);
      TDFAccess(Selections[x]).Height:= trunc(TDFAccess(Selections[x]).Height * Percent);
    end;
    if TObject(Selections[x]) is TDFFrame then
      TDFFrame(Selections[x]).Corner:= trunc(TDFFrame(Selections[x]).Corner * Percent);
    if TObject(Selections[x]) is TDFText then
      TDFText(Selections[x]).FontSize:= trunc(TDFText(Selections[x]).FontSize * Percent);
    if TObject(Selections[x]) is TDFField then
      TDFField(Selections[x]).FontSize:= trunc(TDFField(Selections[x]).FontSize * Percent);
  end;
  RefreshForm;
end;

procedure TDFDesigner.AssignSelection(Dest: TList);
var x: integer;
begin
  Dest.Clear;
  for x:= 0 to Selections.count-1 do
    Dest.Add(Selections[x]);
end;

procedure TDFDesigner.Copy;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  FCopyBuffer.clearchildren;
  for x:= 0 to Selections.count-1 do
  begin
    TDFAccess(Selections[x]).ForceStore:= true;
    FCopyBuffer.AddChildCopy(TDFObject(Selections[x]));
    TDFAccess(Selections[x]).ForceStore:= false;
  end;
  FCopyBuffer.SaveToClipBoard;
end;

procedure TDFDesigner.Cut;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  FCopyBuffer.clearchildren;
  for x:= 0 to Selections.count-1 do
  begin
    TDFAccess(Selections[x]).ForceStore:= true;
    FCopyBuffer.AddChildCopy(TDFObject(Selections[x]));
    TDFAccess(Selections[x]).ForceStore:= false;
    TDFObject(Selections[x]).Delete;
  end;
  Selections.clear;
  FCopyBuffer.SaveToClipBoard;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.Paste;
var
  x,i: integer;
  tmpstr: string;
  flag: boolean;
begin
  FCopyBuffer.LoadFromClipBoard;
  if (Page <> nil) and (FCopyBuffer.ObjectCount > 0) then
  begin
    Selections.clear;
    for x:= 0 to FCopyBuffer.ObjectCount-1 do
    begin
      {modify field tab order so it goes to end}
      if FCopyBuffer.Objects[x] is TDFfield then
        TDFfieldaccess(FCopyBuffer.Objects[x]).SetTabOrder(32767);
      {field already exists?}
      Flag:= (FCopyBuffer.Objects[x] is TDFfield) and
             (FormEngine.FindField((FCopyBuffer.Objects[x] as TDFfield).Fieldname) <> nil);
      {add to page}
      Page.AddChildCopy(FCopyBuffer.Objects[x]);
      {offset the X,Y}
//      TDFAccess(Page.Objects[Page.ObjectCount-1]).Left:= TDFAccess(Page.Objects[Page.ObjectCount-1]).Left + 8;
//      TDFAccess(Page.Objects[Page.ObjectCount-1]).Top:= TDFAccess(Page.Objects[Page.ObjectCount-1]).Top + 8;
      {preserve field names}
      if Flag then
      begin
        tmpstr:= dfNameOnly((FCopyBuffer.Objects[x] as TDFfield).Fieldname);
        if tmpstr <> '' then
        begin
          i:= 2;
          while FormEngine.FindField(tmpstr+inttostr(i)) <> nil do
            inc(i);
          TDFField(Page.Objects[Page.ObjectCount-1]).FieldName:= tmpstr+inttostr(i);
        end;
      end;
      {field taborder}
      if (FCopyBuffer.Objects[x] is TDFfield) then
        TDFField(Page.Objects[Page.ObjectCount-1]).TabOrder:= Page.FieldCount-1;
      {select it}
      Selections.Add(Page.Objects[Page.ObjectCount-1]);
    end;
  end;
//  Copy;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.Delete;
var x: integer;
begin
  FormEngine.BeginUpdate;
  if IsObjectSelected then
  begin
    FDeleteBuffer.clearchildren;
    for x:= 0 to Selections.count-1 do
    begin
      TDFAccess(Selections[x]).ForceStore:= true;
      FDeleteBuffer.AddChildCopy(TDFObject(Selections[x]));
      TDFAccess(Selections[x]).ForceStore:= false;
      TDFObject(Selections[x]).Delete;
    end;
  end else if IsPageSelected and (PageCount > 1) then
  begin
    if Messagedlg('Do you want to delete the current PAGE?', mtWarning, [mbYes,mbNo],0) = mrYes then
    begin
      Page.Delete;
      for x:= 0 to PageCount-1 do
        if pos('Page ',FormEngine.Pages[x].PageName)=1 then
          FormEngine.Pages[x].PageName:= 'Page '+inttostr(x+1);
      if Assigned(FAfterDelPage) then FAfterDelPage(Self);
    end;
  end;
  ClearSelection;
  FormEngine.EndUpdate;
end;

procedure TDFDesigner.UnDelete;
var x: integer;
begin
  if (Page <> nil) and (FDeleteBuffer.ObjectCount > 0) then
  begin
    ClearSelection;
    for x:= 0 to FDeleteBuffer.ObjectCount-1 do
    begin
      Page.AddChildCopy(FDeleteBuffer.Objects[x]);
      Selections.Add(Page.Objects[Page.ObjectCount-1]);
    end;
  end;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.AlignLeftEdges;
var x,val: integer;
begin
  if (not IsObjectSelected) then Exit;
  if Selections.count < 2 then Exit;
  val:= TDFAccess(Selections[0]).left;
  for x:= 1 to Selections.count-1 do
    TDFAccess(Selections[x]).left:= val;
  DoSelectionChange;    
  RefreshForm;
end;

procedure TDFDesigner.AlignRightEdges;
var x,val: integer;
begin
  if (not IsObjectSelected) then Exit;
  if Selections.count < 2 then Exit;
  val:= TDFAccess(Selections[0]).left+TDFAccess(Selections[0]).width;
  for x:= 1 to Selections.count-1 do
    TDFAccess(Selections[x]).Left:= val-TDFAccess(Selections[x]).Width;
  DoSelectionChange;    
  RefreshForm;
end;

procedure TDFDesigner.AlignTopEdges;
var x,val: integer;
begin
  if (not IsObjectSelected) then Exit;
  if Selections.count < 2 then Exit;
  val:= TDFAccess(Selections[0]).top;
  for x:= 1 to Selections.count-1 do
    TDFAccess(Selections[x]).top:= val;
  DoSelectionChange;    
  RefreshForm;
end;

procedure TDFDesigner.AlignBottomEdges;
var x,val: integer;
begin
  if Selections.count < 2 then Exit;
  val:= TDFAccess(Selections[0]).top+TDFAccess(Selections[0]).height;
  for x:= 1 to Selections.count-1 do
    TDFAccess(Selections[x]).top:= val-TDFAccess(Selections[x]).height;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.AlignSpaceHoriz;
var x,start,finish,spacing: integer;
begin
  if (not IsObjectSelected) then Exit;
  if Selections.count < 3 then Exit;

  Selections.Sort(dfSortleft);

  start:= TDFAccess(Selections[0]).left;
  finish:= TDFAccess(Selections[Selections.count-1]).left;
  spacing:= (finish - start) div (Selections.count-1);
  if ((finish - start) mod (Selections.count-1)) > 0 then inc(spacing);

  for x:= 0 to Selections.count-1 do
  begin
    TDFAccess(Selections[x]).left:= start;
    inc(start,spacing);
  end;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.AlignSpaceVert;
var x,start,finish,spacing: integer;
begin
  if (not IsObjectSelected) then Exit;
  if Selections.count < 3 then Exit;

  Selections.Sort(dfSortTop);

  start:= TDFAccess(Selections[0]).top;
  finish:= TDFAccess(Selections[Selections.count-1]).top;
  spacing:= (finish - start) div (Selections.count-1);
  if ((finish - start) mod (Selections.count-1)) > 0 then inc(spacing);

  for x:= 0 to Selections.count-1 do
  begin
    TDFAccess(Selections[x]).top:= start;
    inc(start,spacing);
  end;
  DoSelectionChange;  
  RefreshForm;
end;

procedure TDFDesigner.AlignSnapGrid;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.count-1 do
  begin
    //inches
    if FormEngine.RulerUnits = DFInches then
    begin
      TDFAccess(Selections[x]).Left:=
        (TDFAccess(Selections[x]).Left div (FormEngine.Form.PixelsPerInch div 4)) * (FormEngine.Form.PixelsPerInch div 4);
      TDFAccess(Selections[x]).Top:=
        (TDFAccess(Selections[x]).Top div (FormEngine.Form.PixelsPerInch div 4)) * (FormEngine.Form.PixelsPerInch div 4);
    end;
    //centimeters
    if FormEngine.RulerUnits = DFCentimeters then
    begin
      TDFAccess(Selections[x]).Left:=
        (TDFAccess(Selections[x]).Left div (trunc(FormEngine.Form.PixelsPerInch * CM_CONVERT))) * trunc(FormEngine.Form.PixelsPerInch * CM_CONVERT);
      TDFAccess(Selections[x]).Top:=
        (TDFAccess(Selections[x]).Top div (trunc(FormEngine.Form.PixelsPerInch * CM_CONVERT))) * trunc(FormEngine.Form.PixelsPerInch * CM_CONVERT);
    end;
    //pixels
    if FormEngine.RulerUnits = DFPixels then
    begin
      TDFAccess(Selections[x]).Left:=
        (TDFAccess(Selections[x]).Left div 25) * 25;
      TDFAccess(Selections[x]).Top:=
        (TDFAccess(Selections[x]).Top div 25) * 25;
    end;
  end;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.AlignBringFront;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.count-1 do
    TDFObject(Selections[x]).MoveLast;
  RefreshForm;
end;

procedure TDFDesigner.AlignSendBack;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.count-1 do
    TDFObject(Selections[x]).MoveFirst;
  RefreshForm;
end;

procedure TDFDesigner.AlignToPage;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.count-1 do
  begin
    TDFAccess(Selections[x]).Left:= 0;
    TDFAccess(Selections[x]).Top:= 0;
    TDFAccess(Selections[x]).Height:= Page.Height;
    TDFAccess(Selections[x]).Width:= Page.Width;
  end;
  DoSelectionChange;  
  RefreshForm;
end;

procedure TDFDesigner.AlignCenterHoriz;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.count-1 do
    TDFAccess(Selections[x]).Left:= (Page.Width - TDFAccess(Selections[x]).Width) div 2;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.AlignCenterVert;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.count-1 do
    TDFAccess(Selections[x]).Top:= (Page.Width - TDFAccess(Selections[x]).Height) div 2;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.MoveSelection(Xamt, Yamt: integer);
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.Count-1 do
  begin
    TDFAccess(Selections[x]).Left:= TDFAccess(Selections[x]).Left + Xamt;
    TDFAccess(Selections[x]).Top:= TDFAccess(Selections[x]).Top + Yamt;
  end;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.SizeSelection(Xamt, Yamt: integer);
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  for x:= 0 to Selections.Count-1 do
  begin
    if not (TObject(Selections[x]) is TDFLine) then
    begin
      TDFAccess(Selections[x]).Width:= TDFAccess(Selections[x]).Width + Xamt;
      TDFAccess(Selections[x]).Height:= TDFAccess(Selections[x]).Height + Yamt;
    end
    else begin
      TDFLine(Selections[x]).X2:= TDFLine(Selections[x]).X2 + Xamt;
      TDFLine(Selections[x]).Y2:= TDFLine(Selections[x]).Y2 + Yamt;
    end;
  end;
  DoSelectionChange;
  RefreshForm;
end;

procedure TDFDesigner.SelectNext;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  if Selections.count <> 1 then Exit;
  if Page = nil then Exit;
  for x:= 0 to Page.ObjectCount-1 do
    if Selections[0] = Page.Objects[x] then
    begin
      if x < Page.ObjectCount-1 then
        Selections[0]:= Page.Objects[x+1];
      break;
    end;
  DoSelectionChange;
  Invalidate;
end;

procedure TDFDesigner.SelectPrior;
var x: integer;
begin
  if (not IsObjectSelected) then Exit;
  if Selections.count <> 1 then Exit;
  if Page = nil then Exit;
  for x:= 0 to Page.ObjectCount-1 do
    if Selections[0] = Page.Objects[x] then
    begin
      if x > 0 then
        Selections[0]:= Page.Objects[x-1];
      break;
    end;
  DoSelectionChange;
  Invalidate;
end;

procedure TDFDesigner.CopyLinks;
var
  I: integer;
  SL: TStringList;
begin
  SL:= TStringList.create;
  try
    for I:= 0 to FEngine.FieldCount-1 do
      SL.add(FEngine.Fields[I].Fieldname+'='+FEngine.Fields[I].FieldLink);
    ClipBoard.AsText:= SL.Text;
  finally
    SL.free;
  end;
end;

procedure TDFDesigner.PasteLinks;
var
  I: integer;
  SL: TStringList;
begin
  SL:= TStringList.create;
  try
    SL.Text:= ClipBoard.AsText;
    for I:= 0 to FEngine.FieldCount-1 do
      FEngine.Fields[I].FieldLink:= SL.Values[FEngine.Fields[I].Fieldname];
  finally
    SL.free;
  end;
end;

{ TDFActiveDisplay }

constructor TDFActiveDisplay.Create(AOwner: TComponent);
begin
  inherited;
  //init vars
  FActiveField:= nil;
  FActiveControl:= nil;
  FDeactivating:= false;
  FDataChanged:= false;
  //create special edit
  FEdit:= TDFEdit.create(self);
  FEdit.Left:= -32767;
  FEdit.Top:= -32767;
  FEdit.visible:= false;
  FEdit.autosize:= false;
  FEdit.parent:= self;
  //create special combo
  FCombobox:= TDFCombobox.create(self);
  FCombobox.Left:= -32767;
  FCombobox.Top:= -32767;
  FCombobox.visible:= false;
  FCombobox.autosize:= false;
  FCombobox.parent:= self;
  //create special checkbox
  FCheckbox:= TDFCheckbox.create(self);
  FCheckbox.Left:= -32767;
  FCheckbox.Top:= -32767;
  FCheckbox.visible:= false;
  FCheckbox.parent:= self;
  //create special memo
  FMemo:= TDFMemo.create(self);
  FMemo.Left:= -32767;
  FMemo.Top:= -32767;
  FMemo.visible:= false;
  FMemo.parent:= self;
end;

destructor TDFActiveDisplay.Destroy;
begin
  inherited;
end;

procedure TDFActiveDisplay.Resize;
begin
  ActiveField:= nil;
  inherited;
end;

procedure TDFActiveDisplay.SetPageIndex(const Value: integer);
begin
  inherited;
  if ActiveField <> nil then ActiveField := nil;
end;

procedure TDFActiveDisplay.DoClickObject(AObject: TDFObject);
begin
  if FEngine = nil then Exit;
  //activate the field
  if AObject is TDFField then
  begin
    if (AObject as TDFField).Active then
    begin
      ActiveField:= (AObject as TDFField);
      if ActiveField.Format = dfCheckbox then
      begin
        TdfCheckbox(ActiveControl).Checked:= not TdfCheckbox(ActiveControl).Checked;
        ActiveField.AsBoolean:= TdfCheckbox(ActiveControl).Checked;
      end;
    end;
  end
  else
    inherited;
end;

procedure TDFActiveDisplay.DoActivateField(const Value: TDFField);
var offX,offY: integer;
begin
  if not Enabled then Exit;
  //deactivate old control
  DoDeactivateField;
  if Value = nil then Exit;
  offX:= FDisplayRect.left;
  offY:= FDisplayRect.top;

  //assign new activefield
  FActiveField:= Value;
  //assign new activecontrol
  case FActiveField.Format of
    dfText,dfInteger,dfFloat,dfPercent,dfDate: FActiveControl:= FEdit;
    dfMemo: FActiveControl:= FMemo;
    dfCombobox,dfCombolist: FActiveControl:= FCombobox;
    dfCheckbox: FActiveControl:= FCheckbox;
  end;
  //setup common properties
  FActiveControl.Left:= offX + trunc(FActiveField.Left * ExactScale);
  FActiveControl.Top:= offY + trunc(FActiveField.Top * ExactScale);
  FActiveControl.Width:= trunc(FActiveField.Width * ExactScale);
  FActiveControl.Height:= trunc(FActiveField.Height * ExactScale);
  FActiveControl.Hint:= FActiveField.Hint;
  FActiveControl.HelpContext:= FActiveField.HelpContext;
  TNewWinControl(FActiveControl).OnExit:= ControlExit;
  TNewWinControl(FActiveControl).OnKeyDown:= ControlKeyDown;
  //setup specific properties and assign data
  case FActiveField.Format of
    dfText,dfInteger,dfFloat,dfPercent,dfDate:
    begin
      TDFEdit(FActiveControl).Font.Name:= FActiveField.FontName;
      TDFEdit(FActiveControl).Font.Style:= FActiveField.FontStyle;
      TDFEdit(FActiveControl).Font.Height:= trunc(FActiveField.FontHeight * ExactScale);
      TDFEdit(FActiveControl).color:= FormEngine.Form.ActiveColor;
      TDFEdit(FActiveControl).ctl3d:= (dfShowActiveBorder in FormEngine.PaintOptions);
      if (dfShowActiveBorder in FormEngine.PaintOptions) then
        TDFEdit(FActiveControl).Borderstyle:= bsSingle
      else
        TDFEdit(FActiveControl).Borderstyle:= bsNone;
      TDFEdit(FActiveControl).Maxlength:= FActiveField.Maxlength;
      TDFEdit(FActiveControl).EditMask:= FActiveField.EditMask;
      TDFEdit(FActiveControl).Text:= FActiveField.Data;
    end;
    dfMemo:
    begin
      TDFMemo(FActiveControl).Font.Name:= FActiveField.FontName;
      TDFMemo(FActiveControl).Font.Style:= FActiveField.FontStyle;
      TDFMemo(FActiveControl).Font.Height:= trunc(FActiveField.FontHeight * ExactScale);
      TDFMemo(FActiveControl).color:= FormEngine.Form.ActiveColor;
      TDFMemo(FActiveControl).ctl3d:= (dfShowActiveBorder in FormEngine.PaintOptions);
      if (dfShowActiveBorder in FormEngine.PaintOptions) then
        TDFMemo(FActiveControl).Borderstyle:= bsSingle
      else
        TDFMemo(FActiveControl).Borderstyle:= bsNone;
      TDFMemo(FActiveControl).Maxlength:= FActiveField.Maxlength;
      TDFMemo(FActiveControl).Lines.Text:= FActiveField.Data;
    end;
    dfCombobox,dfCombolist:
    begin
      TDFCombobox(FActiveControl).items.clear;
      TDFCombobox(FActiveControl).items.text:= FActiveField.ComboItems;
      TDFCombobox(FActiveControl).Font.Name:= FActiveField.FontName;
      TDFCombobox(FActiveControl).Font.Style:= FActiveField.FontStyle;
      TDFCombobox(FActiveControl).Font.Height:= trunc(FActiveField.FontHeight * ExactScale);
      TDFCombobox(FActiveControl).color:= FormEngine.Form.ActiveColor;
      TDFCombobox(FActiveControl).ctl3d:= (dfShowActiveBorder in FormEngine.PaintOptions);
      if (dfShowActiveBorder in FormEngine.PaintOptions) then
        TDFCombobox(FActiveControl).Borderstyle:= bsSingle
      else
       TDFCombobox(FActiveControl).Borderstyle:= bsNone;
      TDFCombobox(FActiveControl).Maxlength:= FActiveField.Maxlength;
      TDFCombobox(FActiveControl).Text:= FActiveField.Data;
      TDFCombobox(FActiveControl).Visible:= true;
      if FActiveField.Format = dfCombolist then
        TDFCombobox(FActiveControl).ReadOnly:= true
      else
        TDFCombobox(FActiveControl).ReadOnly:= false;
    end;
    dfCheckbox:
    begin
      TDFCheckbox(FActiveControl).Width:= TDFCheckbox(FActiveControl).Height;
      TDFCheckbox(FActiveControl).color:= FormEngine.Form.ActiveColor;
      TDFCheckbox(FActiveControl).ctl3d:= (dfShowActiveBorder in FormEngine.PaintOptions);
      TDFCheckbox(FActiveControl).Checked:= FActiveField.AsBoolean;
      TDFCheckbox(FActiveControl).OnChange:= CheckChange;
    end;
  end;
  //fire event
  if assigned(FCreateControl) then
    FCreateControl(Self, FActiveField, FActiveControl);
  //show and focus control
  FActiveControl.Visible:= true;
  FActiveControl.SetFocus;
  //set flag
  FDataChanged:= true;
end;

procedure TDFActiveDisplay.DoDeactivateField;
var x: integer;
begin
  if FDeactivating or (FActiveField = nil) or (FActiveControl = nil) then Exit;
  FDeactivating:= true;
  try
    //hide control
    FActiveControl.visible:= false;
    //retrieve data
    case FActiveField.Format of
      dfText,dfInteger,dfFloat,dfDate:
      begin
        FActiveField.AsString:= TDFEdit(FActiveControl).Text;
        TDFEdit(FActiveControl).Text:= '';
      end;
      dfPercent:
      begin
        try
          FActiveField.AsFloat:= strtofloat(TDFEdit(FActiveControl).Text)/100;
        except ;
        end;
        TDFEdit(FActiveControl).Text:= '';
      end;
      dfMemo:
      begin
        FActiveField.AsString:= '';
        for x:= 0 to TDFMemo(FActiveControl).Lines.count-1 do
        begin
          if FActiveField.AsString <> '' then
            FActiveField.AsString:= FActiveField.AsString + #13#10;
          FActiveField.AsString:= FActiveField.AsString +
            TDFMemo(FActiveControl).Lines[X];
        end;
        TDFMemo(FActiveControl).Lines.clear;
      end;
      dfCombobox,dfCombolist:
      begin
        FActiveField.AsString:= TDFCombobox(FActiveControl).Text;
        TDFCombobox(FActiveControl).Text:= '';
      end;
      dfCheckbox:
      begin
        FActiveField.AsBoolean:= TDFCheckbox(FActiveControl).checked;
        TDFCheckbox(FActiveControl).checked:= false;
      end;
    end;

    //fire event
    if assigned(FDestroyControl) then
      FDestroyControl(Self, FActiveField, FActiveControl);

    {$IFDEF EXPRESSIONS}
    FEngine.CalcExpressions;
    {$ENDIF}

  finally
    //reset vars
    FActiveField := nil;
    FActiveControl := nil;
    FDeactivating:= false;
  end;
end;

procedure TDFActiveDisplay.ControlExit(Sender: TObject);
begin
  if (ActiveControl is TDFCombobox) then
    if (ActiveControl as TDFCombobox).IsDropped then Exit;
  ActiveField:= nil;
end;

procedure TDFActiveDisplay.ControlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F9) and (Sender is TDFMemo) then
  begin
    //auto date stamp
    TDFMemo(Sender).lines.insert(0, formatdatetime(ActiveField.DisplayFormat, NOW));
    TDFMemo(Sender).selstart:= length(TDFMemo(Sender).lines[0]);
  end;
end;

procedure TDFActiveDisplay.CMChildKey(var Message: TCMChildKey);
begin
  inherited;
  //handle tab
  if (Message.Sender = FActiveControl) and
     ((Message.CharCode = 9) or
     ((Message.CharCode = 13) and (not (Message.Sender is TDFMemo)))) then
  begin
    if dfShiftDown then
      ActiveField:= Page.FindFieldPrevTab(FActiveField.Taborder)
    else
      ActiveField:= Page.FindFieldNextTab(FActiveField.Taborder);
    Message.Result:= 1;
  end;

  //handle escape
  if (Message.Sender = ActiveControl) and (Message.CharCode = 27) then
  begin
    ActiveField:= nil;
    Message.Result:= 1;
  end;
end;

procedure TDFActiveDisplay.CheckChange(Sender: TObject);
begin
  FActiveField.AsBoolean:= TDFCheckbox(FActiveControl).checked;
end;

procedure TDFActiveDisplay.ActivateFirst;
var I: integer;
begin
  if Page = nil then Exit;
  for I := 0 to Page.FieldCount-1 do
    if (Page.Fields[I].TabOrder = 0) and (Page.Fields[I].Active) then
    begin
      DoActivateField(Page.Fields[I]);
      break;
    end;
end;

end.
