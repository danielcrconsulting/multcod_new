
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Active Edit Controls                            }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfedit;

interface

{$I DEFINEDFORMS.INC}
{$WEAKPACKAGEUNIT ON}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Mask;

type
  TDFEdit = class(TMaskEdit);
  TDFMemo = class(TMemo);

  TDFListbox = class(TListbox) //used only by DFCombobox
  private
    FClickItem: TNotifyEvent;
    FSelectItem: TNotifyEvent;
    FDeactivate: TNotifyEvent;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    property OnClickItem: TNotifyEvent read FClickItem write FClickItem;
    property OnSelectItem: TNotifyEvent read FSelectItem write FSelectItem;
    property OnDeactivate: TNotifyEvent read FDeactivate write FDeactivate;
  end;

  TDFCombobox = class(TEdit)
  private
    FButton: TSpeedButton;
    FListBox: TDFListbox;
    FDropDownCount: integer;
    FIsDropped: boolean;
    function  GetItems: TStrings;
    function  GetItemindex: integer;
    procedure SetItems(const Value: TStrings);
    procedure SetItemindex(const Value: integer);
    procedure ButtonClick(Sender: TObject);
    procedure ListClickItem(Sender: TObject);
    procedure ListSelectItem(Sender: TObject);
    procedure ListKey(Sender: TObject; var Key: Char);
    procedure ListDeactivate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DblClick; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    property IsDropped: boolean read FIsDropped write FIsDropped;
  published
    property Items: TStrings read GetItems write SetItems;
    property Itemindex: integer read GetItemindex write SetItemindex;
    property DropDownCount: integer read FDropDownCount write FDropDownCount;
  end;

  TDFCheckbox = class(TCustomControl)
  private
    FChecked: boolean;
    FShowFocus: boolean;
    FOnChange: TNotifyEvent;
    procedure SetChecked(const Value: boolean);
    procedure SetShowFocus(const Value: boolean);
  protected
    procedure KeyPress(var Key: Char); override;
    procedure Click; override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    procedure DoEnter; override;
    procedure DoExit; override;
  published
    property Checked: boolean read FChecked write SetChecked;
    property ShowFocus: boolean read FShowFocus write SetShowFocus;
    property Color;
    property Ctl3D;
    property Left;
    property Top;
    property Height;
    property Width;
    property TabStop;
    property TabOrder;
    property Enabled;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;
implementation

{ TDFListbox }

constructor TDFListbox.Create(AOwner: TComponent);
begin
  inherited;
  BorderStyle:= bsNone;
  Ctl3D:= false;
end;

procedure TDFListbox.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style xor WS_CHILD or WS_POPUP or WS_BORDER;
end;

procedure TDFListbox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if Assigned(FSelectItem) then FSelectItem(Self);
    if Assigned(FClickItem) then FClickItem(Self);
  end;
end;

procedure TDFListbox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ItemAtPos(Point(X,Y), true) > -1 then
    Itemindex:= ItemAtPos(Point(X,Y), true);
end;

procedure TDFListbox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key in [VK_DOWN,VK_UP,VK_NEXT,VK_PRIOR] then
    if Assigned(FSelectItem) then FSelectItem(Self);
end;

procedure TDFListbox.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if Message.Active = WA_INACTIVE then
    if Assigned(FDeactivate) then FDeactivate(Self);
end;

{ TDFCombobox }

constructor TDFCombobox.Create(AOwner: TComponent);
begin
  inherited;
  {defaults}
  Width:= 145;
  FDropDownCount:= 8;
  FIsDropped:= false;
  {create button}
  FButton:= TSpeedButton.create(Self);
  FButton.Align:= alRight;
  FButton.Width:= Height - (Height div 4);
  FButton.Cursor:= crArrow;
  FButton.Parent:= Self;
  FButton.ParentFont:= false;
  FButton.Font.name:= 'Marlett';
  FButton.Font.size:= 9;
  FButton.Font.style:= [];
  FButton.Font.charset:= DEFAULT_CHARSET;
  FButton.Caption:= 'u';
  FButton.GroupIndex:= 255;
  FButton.AllowAllUp:= true;
  FButton.Layout:= blGlyphTop;
  FButton.Margin:= 0;
  FButton.OnClick:= ButtonClick;
  {create listbox}
  FListBox:= TDFListbox.create(Self);
  FListbox.Left:= -32767;
  FListbox.Top:= -32767;
  FListbox.Visible:= false;
  FListbox.Parent:= Self;
  FListbox.OnDeactivate:= ListDeactivate;
  FListbox.OnClickItem:= ListClickItem;
  FListbox.OnSelectItem:= ListSelectItem;
  FListbox.OnKeyPress:= ListKey;
end;

procedure TDFCombobox.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TDFCombobox.CreateWnd;
var R: TRect;
begin
  inherited;
  SetRect(R, 2, 1, (Width-FButton.Width)-2, Height);
  Perform(EM_SETRECTNP, 0, longint(@R));
end;

procedure TDFCombobox.WMSize(var Message: TWMSize);
var R: TRect;
begin
  inherited;
  FButton.Width:= Height - (Height div 4);
  FButton.Font.Size:= trunc(9 * (Font.Size/8));
  SetRect(R, 2, 1, (Width-FButton.Width)-2, Height);
  Perform(EM_SETRECTNP, 0, longint(@R));
end;

procedure TDFCombobox.DoEnter;
begin
  inherited;
  SelectAll;
end;

procedure TDFCombobox.DoExit;
begin
  inherited;
end;

function TDFCombobox.GetItems: TStrings;
begin
  result:= FListbox.items;
end;

function TDFCombobox.GetItemindex: integer;
begin
  result:= FListbox.Itemindex;
end;

procedure TDFCombobox.SetItems(const Value: TStrings);
begin
  FListbox.items.assign(Value);
end;

procedure TDFCombobox.SetItemindex(const Value: integer);
begin
  FListbox.Itemindex:= Value;
end;

procedure TDFCombobox.KeyDown(var Key: Word; Shift: TShiftState);
var I: integer;
begin
  if (Key = VK_DOWN) and (ssAlt in Shift) then
  begin
    FButton.down:= true;
    ButtonClick(nil);
  end;

  if (Key = VK_DOWN) and (Shift = []) and (FListBox.items.count > 0) then
  begin
    if Itemindex = -1 then
      for I:= 0 to FListbox.items.count-1 do
        if FListbox.items[I] = Text then
        begin
          Itemindex:= I;
          break;
        end;
    if Itemindex < Items.Count - 1 then
      Itemindex := Itemindex + 1
    else
      Itemindex := Items.Count - 1;
    ListSelectItem(nil);
  end;

  if (Key = VK_UP) and (Shift = []) and (FListBox.items.count > 0) then
  begin
    if Itemindex = -1 then
      for I:= 0 to FListbox.items.count-1 do
        if FListbox.items[I] = Text then
        begin
          Itemindex:= I;
          break;
        end;
    if Itemindex > 0 then
      Itemindex := Itemindex - 1
    else
      Itemindex := 0;
    ListSelectItem(nil);
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TDFCombobox.DblClick;
var Key: WORD;
begin
  Key:= VK_DOWN;
  KeyDown(Key, []);
end;

procedure TDFCombobox.ButtonClick(Sender: TObject);
var I, margin: integer;
begin
  if not FIsDropped then
  begin
    FIsDropped:= true;
    FButton.down:= true;
    if Ctl3D then margin:= 2
    else margin:= 0;
    FListbox.Left:= ClientOrigin.X-margin;
    FListbox.Top:= ClientOrigin.Y+(Height-margin);
    FListbox.Width:= Width;
//    FListBox.Color:= Color;
    FListBox.Font.Assign(Font);
    if FListBox.items.count < DropDownCount then I:= FListBox.items.count
    else I:= DropDownCount;
    if I = 0 then I:= 1;
    FListbox.Height:= (I * (FListBox.itemheight)) + 2;
    if FListbox.Top + FListbox.Height > Screen.Height then
      FListbox.Top:= ClientOrigin.Y - (FListbox.Height+1);
    Itemindex:= -1;
    for I:= 0 to FListbox.items.count-1 do
      if FListbox.items[I] = Text then
      begin
        Itemindex:= I;
        break;
      end;
//    SelectAll;
    FListbox.show;
    if FListbox.canfocus then FListbox.setfocus;
    GetParentForm(Self).Perform(WM_NCACTIVATE, 1, 0);
    if ClientOrigin.X-margin <> FListbox.Left then
      FListbox.Left:= ClientOrigin.X-margin;
    if ClientOrigin.Y+(Height-margin) <> FListbox.Top then
      FListbox.Top:= ClientOrigin.Y+(Height-margin);
  end
  else begin
    FButton.down:= false;
    FListbox.hide;
    if CanFocus then SetFocus;
    SelectAll;
    FIsDropped:= false;
  end;
end;

procedure TDFCombobox.ListClickItem(Sender: TObject);
begin
  ListDeactivate(nil);
end;

procedure TDFCombobox.ListSelectItem(Sender: TObject);
begin
  if Itemindex > -1 then
    Text:= FListBox.items[Itemindex];
//  SelectAll;
end;

procedure TDFCombobox.ListKey(Sender: TObject; var Key: Char);
begin
  if Key = #13 then ListClickItem(nil);
  if Key = #27 then ListDeactivate(nil);
end;

procedure TDFCombobox.ListDeactivate(Sender: TObject);
begin
  if FButton.Down then FButton.Click;
end;

{ TDFCheckbox }

constructor TDFCheckbox.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csClickEvents, csCaptureMouse, csSetCaption];
  FChecked:= false;
  FShowFocus:= true;
  ParentColor:= false;
  Color:= clWindow;
  Height:= 13;
  Width:= 13;
  TabStop:= true;
end;

procedure TDFCheckbox.SetChecked(const Value: boolean);
begin
  FChecked := Value;
  Invalidate;
end;

procedure TDFCheckbox.SetShowFocus(const Value: boolean);
begin
  FShowFocus := Value;
  Invalidate;
end;

procedure TDFCheckbox.Click;
begin
  inherited;
  Checked:= not Checked;
  if CanFocus then SetFocus;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDFCheckbox.KeyPress(var Key: Char);
begin
  inherited;
  if (Key = #32) then Click;
end;

procedure TDFCheckbox.Paint;
var R: TRect;
begin
  inherited;
  R:= ClientRect;
  with Canvas do
  begin
    Brush.color:= Color;
    Brush.style:= bsSolid;
    Pen.Style:= psSolid;
    FillRect(R);
    if Ctl3D then
    begin
      {outer bevel}
      Pen.Width:= 1;
      Pen.Color:= clBtnShadow;
      MoveTo(R.Left,  R.Bottom-1  );
      LineTo(R.Left,  R.Top       );
      MoveTo(R.Left,  R.Top       );
      LineTo(R.Right-1, R.Top     );
      Pen.Color:= clBtnHighlight;
      MoveTo(R.Right-1, R.Top     );
      LineTo(R.Right-1, R.Bottom-1);
      MoveTo(R.Right-1, R.Bottom-1);
      LineTo(R.Left,  R.Bottom-1  );
      {inner bevel}
      InflateRect(R,-1,-1);
      Pen.Color:= clBlack;
      MoveTo(R.Left,  R.Bottom-1  );
      LineTo(R.Left,  R.Top       );
      MoveTo(R.Left,  R.Top       );
      LineTo(R.Right-1, R.Top     );
      Pen.Color:= clBtnFace;
      MoveTo(R.Right-1, R.Top     );
      LineTo(R.Right-1, R.Bottom-1);
      MoveTo(R.Right-1, R.Bottom-1);
      LineTo(R.Left,  R.Bottom-1 );
    end;
    {draw checkmark}
    if Checked then
    begin
      InflateRect(R,-1,-1);
      Pen.Color:= clBlack;
      Pen.Width:= 1;
      MoveTo( R.left , R.Top );
      LineTo( R.right , R.bottom );
      MoveTo( R.left , R.bottom-1 );
      LineTo( R.right , R.top-1 );
      MoveTo( R.left+1 , R.Top );
      LineTo( R.right , R.bottom-1 );
      MoveTo( R.left , R.Top+1 );
      LineTo( R.right-1 , R.bottom );
      MoveTo( R.left , R.bottom-2 );
      LineTo( R.right-1 , R.top-1 );
      MoveTo( R.left+1 , R.bottom-1 );
      LineTo( R.right , R.top );
    end;
    {draw focus rect}
    if Focused and FShowFocus then
    begin
      R:= ClientRect;
      InflateRect(R,-1,-1);
      DrawFocusRect(R);
    end;
  end;
end;

procedure TDFCheckbox.DoEnter;
begin
  inherited;
  Invalidate;
end;

procedure TDFCheckbox.DoExit;
begin
  inherited;
  Invalidate;
end;

procedure TDFCheckbox.WMSize(var Message: TWMSize);
begin
  inherited;
  Width:= Height;
end;


end.
