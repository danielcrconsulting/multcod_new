
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Object Inspector Implementation                 }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfinspect;

interface

{$WEAKPACKAGEUNIT ON}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ExtDlgs, defstream, definspect, dfclasses, dfcontrols, dfutil,
  dfeditors;

type
  TdlDFInspector = class(TForm)
    ObjectInspector: TDefinedInspector;
    ObjPan: TPanel;
    MainPan: TPanel;
    procedure ObjectInspectorFilterProperty(Sender: TObject;
      const PropName, PropType: String; var Include, MultiInclude, CustomEditor: Boolean);
    procedure ObjectInspectorInvokeCustomEditor(Sender: TObject;
      const PropName, PropType: String; ObjectList: TList; var Handled: Boolean);
    procedure ObjectInspectorMakeBold(Sender: TObject; const PropName,
      PropType: String; var MakeBold: Boolean);
    procedure ObjectInspectorEnterKey(Sender: TObject);
  private
  public
  end;

var
  dlDFInspector: TdlDFInspector;

implementation

uses dfdesigner;

{$R *.DFM}

procedure TdlDFInspector.ObjectInspectorFilterProperty(Sender: TObject;
  const PropName, PropType: String; var Include, MultiInclude, CustomEditor: Boolean);
begin
  if (PropName = 'Name') or
     (PropName = 'FontCharset') or
     (PropName = 'TabOrder') or     
     (PropName = 'FontHeight') then
    Include:= false;
  if (PropName = 'Name') or
     (PropName = 'FieldName') or
     (PropName = 'TabOrder') or
     (PropName = 'FontCharset') or
     (PropName = 'FontHeight') then
    MultiInclude:= false;

  if (PropType = 'TColor') or
     (PropType = 'TPicture') or
     (PropName = 'FontName') or
     (PropName = 'FontStyle') or
     (PropName = 'Text') or
     (PropName = 'Data') or
     (PropName = 'ComboItems') or     
     (PropName = 'FieldLink') or
     (PropName = 'Expression') then
    CustomEditor:= true;
end;

procedure TdlDFInspector.ObjectInspectorMakeBold(Sender: TObject;
  const PropName, PropType: String; var MakeBold: Boolean);
begin
  if (PropName = 'Active') or
     (PropName = 'Alignment') or
     (PropName = 'Autosize') or
     (PropName = 'Background') or
     (PropName = 'Caption') or
     (PropName = 'Data') or
     (PropName = 'Format') or
     (PropName = 'FontName') or
     (PropName = 'FontSize') or
     (PropName = 'FieldLink') or
     (PropName = 'FieldName') or
     (PropName = 'FormName') or
     (PropName = 'FrameType') or
     (PropName = 'Orientation') or
     (PropName = 'PageName') or
     (PropName = 'PrinterStretch') or
     (PropName = 'TabOrder') or
     (PropName = 'Stretch') or
     (PropName = 'Store') or
     (PropName = 'Text') or
     (PropName = 'Transparent') or
     (PropName = 'X1') or
     (PropName = 'X2') or
     (PropName = 'Y1') or
     (PropName = 'Y2') then
    MakeBold:= true;
end;

procedure TdlDFInspector.ObjectInspectorInvokeCustomEditor(Sender: TObject;
  const PropName, PropType: String; ObjectList: TList; var Handled: Boolean);
var
  x: integer;
  tmpstr: string;
begin
  dlDFEditors.PropName:= PropName;
  dlDFEditors.PropType:= PropType;
  if (PropName = 'FontName') or (PropName = 'FontStyle') then
  begin
    Handled:= true;
    dlDFEditors.FontDialog1.Font.Name:=    TDFAccess(ObjectList[0]).FontName;
    dlDFEditors.FontDialog1.Font.Size:=    TDFAccess(ObjectList[0]).FontSize;
    dlDFEditors.FontDialog1.Font.Color:=   TDFAccess(ObjectList[0]).FontColor;
    dlDFEditors.FontDialog1.Font.Style:=   TDFAccess(ObjectList[0]).FontStyle;
    dlDFEditors.FontDialog1.Font.Charset:= TDFAccess(ObjectList[0]).FontCharset;
    if dlDFEditors.FontDialog1.Execute then
      for x:= 0 to ObjectList.count-1 do
      begin
        TDFAccess(ObjectList[x]).FontName:=    dlDFEditors.FontDialog1.Font.Name;
        TDFAccess(ObjectList[x]).FontSize:=    dlDFEditors.FontDialog1.Font.Size;
        TDFAccess(ObjectList[x]).FontColor:=   dlDFEditors.FontDialog1.Font.Color;
        TDFAccess(ObjectList[x]).FontStyle:=   dlDFEditors.FontDialog1.Font.Style;
        TDFAccess(ObjectList[x]).FontCharset:= dlDFEditors.FontDialog1.Font.Charset;
      end;
  end;

  if (PropType = 'TColor') then
  begin
    Handled:= true;
    for x:= 0 to ObjectList.count-1 do
      TDefinedStream(ObjectList[x]).RefreshProperties;
    dlDFEditors.ColorDialog1.Color:= TDefinedStream(ObjectList[0]).GetPropAsInteger(PropName);
    if dlDFEditors.ColorDialog1.Execute then
      for x:= 0 to ObjectList.count-1 do
        TDefinedStream(ObjectList[x]).SetPropAsInteger(PropName, dlDFEditors.ColorDialog1.Color);
  end;

  if (PropType = 'TPicture') then
  begin
    Handled:= true;
    dlDFEditors.Pages.ActivePage:= dlDFEditors.Picture_Page;
    if (TObject(ObjectList[0]) is TDFPage) then
      dlDFEditors.Picture_Image.picture.assign(TDFPage(ObjectList[0]).Background);
    if (TObject(ObjectList[0]) is TDFLogo) then
      dlDFEditors.Picture_Image.picture.assign(TDFLogo(ObjectList[0]).Picture);
    if dlDFEditors.Showmodal = mrOK then
      for x:= 0 to ObjectList.count-1 do
      begin
        if (TObject(ObjectList[x]) is TDFPage) then
          TDFPage(ObjectList[x]).Background.assign(dlDFEditors.Picture_Image.picture);
        if (TObject(ObjectList[x]) is TDFLogo) then
          TDFLogo(ObjectList[x]).Picture.assign(dlDFEditors.Picture_Image.picture);
      end;
  end;

  if (PropName = 'Text') or (PropName = 'Data') or (PropName = 'ComboItems') or (PropName = 'Expression') then
  begin
    Handled:= true;
    dlDFEditors.Pages.ActivePage:= dlDFEditors.Strings_Page;
    for x:= 0 to ObjectList.count-1 do
      TDefinedStream(ObjectList[x]).RefreshProperties;
    dlDFEditors.Strings_Text.lines.text:= TDefinedStream(ObjectList[0]).GetPropAsString(PropName);
    dlDFEditors.Strings_Text.SelStart:= length(dlDFEditors.Strings_Text.lines.text);
    if dlDFEditors.Showmodal = mrOK then
      for x:= 0 to ObjectList.count-1 do
        TDefinedStream(ObjectList[x]).SetPropAsString(PropName, dlDFEditors.Strings_Text.lines.text);
  end;

  if (PropName = 'FieldLink') and (fmDFDesigner.DesignVars.Values['linktree'] <> 'Y') then
  begin
    Handled:= true;
    dlDFEditors.Pages.ActivePage:= dlDFEditors.Field_Page;
    for x:= 0 to ObjectList.count-1 do
      TDefinedStream(ObjectList[x]).RefreshProperties;
    if fileexists(dfGetPath+'fields.dat') then
      dlDFEditors.Field_List.items.loadfromfile(dfGetPath+'fields.dat');
    tmpstr:= TDefinedStream(ObjectList[0]).GetPropAsString(PropName);
    for x:= 0 to dlDFEditors.Field_List.items.count-1 do
      if sametext(dlDFEditors.Field_List.items[X], tmpstr) then
      begin
        dlDFEditors.Field_List.itemindex:= x;
        break;
      end;
    if dlDFEditors.Showmodal = mrOK then
    begin
      if dlDFEditors.Field_List.itemindex > -1 then
        for x:= 0 to ObjectList.count-1 do
          TDefinedStream(ObjectList[x]).SetPropAsString(PropName,
            dlDFEditors.Field_List.items[dlDFEditors.Field_List.itemindex]);
    end;
  end;

  if (PropName = 'FieldLink') and (fmDFDesigner.DesignVars.Values['linktree'] = 'Y') then
  begin
    Handled:= true;
    dlDFEditors.Pages.ActivePage:= dlDFEditors.Links_Page;
    for x:= 0 to ObjectList.count-1 do
      TDefinedStream(ObjectList[x]).RefreshProperties;
    tmpstr:= TDefinedStream(ObjectList[0]).GetPropAsString(PropName);
    if fileexists(dfGetPath+'fields.dat') then
    begin
      dlDFEditors.Links_List.loadfromfile(dfGetPath+'fields.dat');
      dlDFEditors.Update_Links(tmpstr);
    end;
    if dlDFEditors.Showmodal = mrOK then
    begin
      for x:= 0 to ObjectList.count-1 do
        TDefinedStream(ObjectList[x]).SetPropAsString(PropName, dlDFEditors.Links_Link.text);
    end;
  end;

  ObjectInspector.UpdateProperties;
  ObjectInspector.Invalidate;
end;

procedure TdlDFInspector.ObjectInspectorEnterKey(Sender: TObject);
begin
//  fmDFDesigner.setfocus;
end;

end.
