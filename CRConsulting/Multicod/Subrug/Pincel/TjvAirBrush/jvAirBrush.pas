unit jvAirBrush;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TAirBrushShape=(absRound,absSquare,absLeftSlash,absRightSlash,absHorizontal,absVertical);
  TjvAirBrush = class(TComponent)
  private
    Bitmap: TBitmap;
    FIntensity: Integer;
    FSize: Integer;
    FColor: TColor;
    FShape: TAirBrushShape;
    procedure SetColor(const Value: TColor);
    procedure SetIntensity(const Value: Integer);
    procedure SetSize(const Value: Integer);
    procedure MakeBrush;
    procedure Blend(src1, src2, dst: tbitmap; amount: extended);
    procedure SetShape(const Value: TAirBrushShape);

    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor destroy;override;
    procedure Draw(ACanvas: TCanvas; x, y: integer);
  published
    { Published declarations }
    property Size:Integer read FSize write SetSize;
    property Color:TColor read FColor write SetColor;
    property Intensity:Integer read FIntensity write SetIntensity;
    property Shape: TAirBrushShape read FShape write SetShape;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Jans 2', [TjvAirBrush]);
end;

{ TjvAirBrush }

constructor TjvAirBrush.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSize:=40;
  FIntensity:=10;
  FColor:=clBlack;
  Bitmap:=TBitmap.create;
  FShape:=absRound;
end;

destructor TjvAirBrush.destroy;
begin
  Bitmap.free;
  inherited;
end;

procedure TjvAirBrush.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TjvAirBrush.SetIntensity(const Value: Integer);
begin
  if value<>FIntensity then begin
   if ((value>=1)and (value<=100)) then
     FIntensity := Value;
   end;
end;

procedure TjvAirBrush.SetSize(const Value: Integer);
begin
  if value<>FSize then begin
   if ((value>=10)and (value<=200)) then
    FSize := Value;
   end;
end;

procedure TjvAirBrush.MakeBrush;
var pts: array[0..3] of Tpoint;
begin
 with Bitmap do begin
  width:=FSize;
  height:=FSize;
  canvas.brush.color:=clwhite;
  canvas.fillrect(rect(0,0,width,height));
  canvas.pen.style:=psclear;
  canvas.brush.color:=FColor;
  case FShape of
   absRound:canvas.Ellipse (0,0,width,height);
   absSquare: canvas.Rectangle (0,0,width,height);
   absRightSlash:
    begin
    pts[0]:=point(0,height-1);
    pts[1]:=point(width div 4,height-1);
    pts[2]:=point(width-1,0);
    pts[3]:=point(width-1 - (width div 4),0);
    canvas.Polygon (pts);
    end;
   absLeftSlash:
    begin
    pts[0]:=point(0,0);
    pts[1]:=point(width div 4,0);
    pts[2]:=point(width-1,height-1);
    pts[3]:=point(width-1 - (width div 4),height-1);
    canvas.Polygon (pts);
    end;
   absHorizontal: canvas.rectangle(0,height div 4,width-1,height-1-(height div 4));
   absVertical: canvas.rectangle(width div 4,0,width-1-(width div 4),height-1);
   end;
  transparentcolor:=clwhite;
  transparent:=true;
  end;
end;

procedure TjvAirBrush.Draw(ACanvas:TCanvas;x,y:integer);
var bm,dst:TBitmap;
    Rpaint,Rt:Trect;
    CLeft,Ctop:integer;
begin
  MakeBrush;
  CLeft:=x-(FSize div 2);
  CTop:=y-(FSize div 2);
  Rpaint:=rect(CLeft,CTop,CLeft+FSize,CTop+FSize);
  bm:=Tbitmap.create;
  bm.width:=Bitmap.width;
  bm.height:=bitmap.height;
  dst:=Tbitmap.create;
  dst.width:=bitmap.width;
  dst.height:=bitmap.height;
  try
  Rt:=rect(0,0,bm.width,bm.height);
  bm.canvas.CopyRect (Rt,ACanvas,Rpaint);
  bm.PixelFormat :=pf24bit;
  bitmap.PixelFormat :=pf24bit;
  dst.PixelFormat :=pf24bit;
  Blend(bm,bitmap,dst,FIntensity/100);
  dst.TransparentColor :=clwhite;
  dst.transparent:=true;
  ACanvas.draw(CLeft,CTop,dst);
  finally
   bm.free;
   dst.free;
   end;

end;

procedure TjvAirBrush.Blend(src1, src2, dst: tbitmap; amount: extended);
var w,h,x,y:integer;
    ps1,ps2,pd:pbytearray;
begin
w:=src1.Width ;
h:=src1.Height;
dst.Width :=w;
dst.Height :=h;
src1.PixelFormat :=pf24bit;
src2.PixelFormat:=pf24bit;
dst.PixelFormat :=pf24bit;
for y:=0 to h-1 do begin
 ps1:=src1.ScanLine [y];
 ps2:=src2.ScanLine [y];
 pd:=dst.ScanLine [y];
 for x:=0 to w-1 do begin
  if ((ps2[x*3]=$FF) and (ps2[x*3+1]=$FF) and (ps2[x*3+2]=$FF)) then begin
    pd[x*3]:=$FF;
    pd[x*3+2]:=$FF;
    pd[x*3+2]:=$FF;
   end
   else begin
    pd[x*3]:=round((1-amount)*ps1[x*3]+amount*ps2[x*3]);
    pd[x*3+1]:=round((1-amount)*ps1[x*3+1]+amount*ps2[x*3+1]);
    pd[x*3+2]:=round((1-amount)*ps1[x*3+2]+amount*ps2[x*3+2]);
    end;
  end;
 end;
end;



procedure TjvAirBrush.SetShape(const Value: TAirBrushShape);
begin
  FShape := Value;
end;

end.
