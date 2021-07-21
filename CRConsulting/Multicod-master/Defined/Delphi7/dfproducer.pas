
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Page Producer for Web Integration               }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfproducer;

interface

{$I DEFINEDFORMS.INC}

{$IFDEF GIF}
{.$DEFINE CONTENT_GIF}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  httpapp, jpeg, dfclasses {$IFDEF CONTENT_GIF},dfgif{$ENDIF};

type
  TDFContentProducer = class(TCustomContentProducer)
  private
    FEngine: TDFEngine;
    FPageIndex: integer;
    FScale: extended;
    FPrepareForm: TNotifyEvent;
    function  GetPage: TDFPage;
    function  GetPageCount: integer;
    procedure SetPageIndex(const Value: integer); virtual;
  protected
    procedure SetEngine(const Value: TDFEngine); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Content: string; override;
    constructor Create(AOwner: TComponent); override;
    procedure SetQueryFields;
    function CalcImageSize: TPoint;
    property Page: TDFPage read GetPage;
    property PageCount: integer read GetPageCount;
    property PageIndex: integer read FPageIndex write SetPageIndex default -1;
    property Scale: extended read FScale write FScale;
  published
    property FormEngine: TDFEngine read FEngine write SetEngine;
    property OnPrepareForm: TNotifyEvent read FPrepareForm write FPrepareForm;
  end;

implementation

constructor TDFContentProducer.Create(AOwner: TComponent);
var I: integer;
begin
  inherited;
  FPageIndex := -1;
  FScale:= 100;
  FEngine:= nil;
  for I:= 0 to Owner.ComponentCount-1 do
    if Owner.Components[I] is TDFEngine then
    begin
      FormEngine:= Owner.Components[I] as TDFEngine;
      break;
    end;
end;

procedure TDFContentProducer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FEngine) then
    FormEngine:= nil;
  if (Operation = opInsert) and (AComponent is TDFEngine) and (FEngine = nil) then
    FormEngine:= (AComponent as TDFEngine);
end;

procedure TDFContentProducer.SetEngine(const Value: TDFEngine);
begin
  FEngine:= Value;
  if (FEngine <> nil) then
    if Pageindex = -1 then
      PageIndex:= 0;
end;

function TDFContentProducer.GetPage: TDFPage;
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

function TDFContentProducer.GetPageCount: integer;
begin
  if FormEngine = nil then
    result:= 0
  else
    result := FormEngine.PageCount;
end;

procedure TDFContentProducer.SetPageIndex(const Value: integer);
begin
  if (csLoading in ComponentState) or
     ((Value < FormEngine.PageCount) and (Value > -2)) then
    FPageIndex := Value
  else
    FPageIndex := -1;
end;

procedure TDFContentProducer.SetQueryFields;
begin
  if Assigned(FPrepareForm) then FPrepareForm(Self);
  PageIndex:= strtointdef(Dispatcher.Request.QueryFields.Values['Page'],1)-1;
  Scale:= strtointdef(Dispatcher.Request.QueryFields.Values['Scale'],100);
end;

function TDFContentProducer.CalcImageSize: TPoint;
begin
  SetQueryFields;
  Result.X:= trunc(Page.Width * (Scale/100));
  Result.Y:= trunc(Page.Height * (Scale/100));
end;

{$IFNDEF CONTENT_GIF}
function TDFContentProducer.Content: string;
var
  BM: TBitmap;
  JP: TJPEGImage;
  MS: TMemoryStream;
begin
  result:= inherited Content;
  SetQueryFields;
  JP:= TJPEGImage.create;
  BM:= TBitmap.create;
  try
    BM.Width:= trunc(Page.Width * (Scale/100));
    BM.Height:= trunc(Page.Height * (Scale/100));
    Page.PaintTo(BM.Canvas, Rect(0,0,BM.Width,BM.Height), dfDisplay);
    JP.Assign(BM);
    MS:= TMemoryStream.create;
    JP.SavetoStream(MS);
    MS.seek(0,0);
    Dispatcher.Response.ContentType:= 'image/jpeg';
    Dispatcher.Response.ContentStream:= MS;
    //dispatcher will free MS
  finally
    JP.free;
    BM.free;
  end;
end;
{$ELSE}
function TDFContentProducer.Content: string;
var
  BM: TBitmap;
  GF: TGIFImage;
  MS: TMemoryStream;
begin
  result:= inherited Content;
  SetQueryFields;
  GF:= TGIFImage.create;
  BM:= TBitmap.create;
  try
    BM.Height:= trunc(Page.Height * (Scale/100));
    BM.Width:= trunc(Page.Width * (Scale/100));
    Page.PaintTo(BM.Canvas, Rect(0,0,BM.Width,BM.Height), dfDisplay);
    GF.Assign(BM);
    MS:= TMemoryStream.create;
    GF.SavetoStream(MS);
    MS.seek(0,0);
    Dispatcher.Response.ContentType:= 'image/gif';
    Dispatcher.Response.ContentStream:= MS;
    //dispatcher will free MS
  finally
    GF.free;
    BM.free;
  end;
end;
{$ENDIF}


end.
