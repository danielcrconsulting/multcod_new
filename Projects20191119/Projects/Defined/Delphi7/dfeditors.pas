
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Designer Property Editors                       }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfeditors;

interface

{$WEAKPACKAGEUNIT ON}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, Buttons, ComCtrls, defstream, dfclasses,
  dfcontrols, dfutil, ImgList;

const
  TABS_FILL_TABORDER = 0;
  TABS_FILL_TOP = 1;
  TABS_FILL_SELECTED = 2;
  TABS_FILL_READONLY = 3;

type
  TdlDFEditors = class(TForm)
    Strings_OpenDialog: TOpenDialog;
    Pages: TPageControl;
    Strings_Page: TTabSheet;
    Strings_Bevel: TBevel;
    Strings_Text: TMemo;
    Strings_Apply: TButton;
    Strings_Load: TButton;
    Strings_OK: TButton;
    Strings_Cancel: TButton;
    Tabs_Page: TTabSheet;
    Tabs_Bevel: TBevel;
    Tabs_OK: TButton;
    Tabs_Cancel: TButton;
    Tabs_List: TListBox;
    Tabs_Up: TButton;
    Tabs_SortPos: TButton;
    Tabs_SortSel: TButton;
    Tabs_Down: TButton;
    Picture_OpenDialog: TOpenPictureDialog;
    Picture_SaveDialog: TSavePictureDialog;
    Picture_Page: TTabSheet;
    Picture_Bevel: TBevel;
    Picture_OK: TButton;
    Picture_Cancel: TButton;
    Picture_Panel: TPanel;
    Picture_Load: TButton;
    Picture_Save: TButton;
    Picture_Clear: TButton;
    Picture_Image: TImage;
    Field_Page: TTabSheet;
    Field_Bevel: TBevel;
    Field_List: TListBox;
    Field_OK: TButton;
    Field_Cancel: TButton;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    Strings_SaveDialog: TSaveDialog;
    Strings_Save: TButton;
    Field_Load: TButton;
    Field_Find: TButton;
    Field_OpenDialog: TOpenDialog;
    Tabs_ReadOnly: TButton;
    Links_Page: TTabSheet;
    Links_OK: TButton;
    Links_Cancel: TButton;
    Links_Tree: TTreeView;
    Label1: TLabel;
    Links_Load: TButton;
    Links_Images: TImageList;
    Links_Link: TEdit;
    Links_Search: TButton;
    procedure PictureClick(Sender: TObject);
    procedure StringsClick(Sender: TObject);
    procedure FieldClick(Sender: TObject);
    procedure TabsClick(Sender: TObject);
    procedure LinksClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Links_LinkChange(Sender: TObject);
    procedure Links_TreeClick(Sender: TObject);
    procedure Links_TreeDblClick(Sender: TObject);
  private
  public
    PropName, PropType: string;
    Tabs_Design: TDFDesigner;
    Links_List: TStringList;
    procedure Tabs_Fill(Sort: integer);
    procedure Update_Tabs;
    procedure Update_Links(const selection: string);
  end;

var
  dlDFEditors: TdlDFEditors;

implementation

{$R *.DFM}

uses dfinspect;

procedure TdlDFEditors.PictureClick(Sender: TObject);
begin
  if Sender = Picture_Load then
  begin
    if Picture_OpenDialog.Execute then
      Picture_Image.Picture.LoadFromFile(Picture_OpenDialog.Filename);
  end;

  if Sender = Picture_Save then
  begin
    if Picture_SaveDialog.Execute then
      Picture_Image.Picture.SaveToFile(Picture_SaveDialog.Filename);
  end;

  if Sender = Picture_Clear then
  begin
    Picture_Image.Picture.Graphic:= nil;
    Picture_Image.Invalidate;
  end;
end;

procedure TdlDFEditors.StringsClick(Sender: TObject);
var x: integer;
begin
  if Sender = Strings_Load then
  begin
    if Strings_OpenDialog.Execute then
      Strings_Text.lines.LoadFromFile(Strings_OpenDialog.Filename);
  end;

  if Sender = Strings_Save then
  begin
    if Strings_SaveDialog.Execute then
      Strings_Text.lines.SaveToFile(Strings_SaveDialog.Filename);
  end;

  if Sender = Strings_Apply then
  begin
    for x:= 0 to dlDFInspector.ObjectInspector.ObjectList.count-1 do
      TDefinedStream(dlDFInspector.ObjectInspector.ObjectList[x]).SetPropAsString(PropName, Strings_Text.lines.text);
  end;
end;

procedure TdlDFEditors.FieldClick(Sender: TObject);
begin
  if Sender = Field_Load then
  begin
    if Field_OpenDialog.Execute then
      Field_List.items.LoadFromFile(Field_OpenDialog.Filename);
  end;

  if Sender = Field_List then Modalresult:= mrOK;
end;

procedure TdlDFEditors.Tabs_Fill(Sort: integer);
var
  tmpstr: string;
  I,J: integer;

  function getfielditem(index: integer): string;
  begin
    result:= Tabs_List.items[index];
    if pos(' (inactive)', result)>0 then
      result:= copy(result,1,pos(' (inactive)', result)-1);
  end;

begin
  case Sort of
    TABS_FILL_TABORDER:
    begin
      Tabs_List.clear;
      for I:= 0 to Tabs_Design.Page.FieldCount-1 do
      begin
        tmpstr:= Tabs_Design.Page.Fields[I].FieldName;
        if not Tabs_Design.Page.Fields[I].Active then
          tmpstr:= tmpstr + ' (inactive)';
        Tabs_List.items.Add(tmpstr);
      end;
      for J:= 0 to Tabs_List.items.count-1 do
        for I:= 0 to Tabs_List.items.count-2 do
          if Tabs_Design.FormEngine.FieldByName(getfielditem(I)).TabOrder >
            Tabs_Design.FormEngine.FieldByName(getfielditem(I+1)).TabOrder then
            Tabs_List.items.Exchange(I,I+1);
    end;

    TABS_FILL_TOP:
    begin
      for J:= 0 to Tabs_List.items.count-1 do
        for I:= 0 to Tabs_List.items.count-2 do
          if (Tabs_Design.FormEngine.FieldByName(getfielditem(I  )).Top*10000)+
              Tabs_Design.FormEngine.FieldByName(getfielditem(I)).Left >
             (Tabs_Design.FormEngine.FieldByName(getfielditem(I+1)).Top*10000)+
              Tabs_Design.FormEngine.FieldByName(getfielditem(I+1)).Left then
            Tabs_List.items.Exchange(I,I+1);
    end;

    TABS_FILL_SELECTED:
    begin
      for I:= Tabs_Design.Selections.Count-1 downto 0 do
        if TDFObject(Tabs_Design.Selections[I]) is TDFField then
          for J:= 0 to Tabs_List.items.count-1 do
            if TDFField(Tabs_Design.Selections[I]).FieldName = getfielditem(J) then
            begin
              Tabs_List.items.Move(J,0);
              break;
            end;
    end;

    TABS_FILL_READONLY:
    begin
      for J:= 0 to Tabs_List.items.count-1 do
        for I:= 0 to Tabs_List.items.count-2 do
          if (pos('(inactive)',Tabs_List.items[I])>0) and (pos('(inactive)',Tabs_List.items[I+1])=0) then
            Tabs_List.items.Exchange(I,I+1);
    end;
  end;
end;

procedure TdlDFEditors.Update_Tabs;
var
  I: integer;

  function getfielditem(index: integer): string;
  begin
    result:= Tabs_List.items[index];
    if pos(' (inactive)', result)>0 then
      result:= copy(result,1,pos(' (inactive)', result)-1);
  end;

begin
  for I:= 0 to Tabs_List.items.count-1 do
    TDFFieldAccess(Tabs_Design.FormEngine.FieldByName(getfielditem(I))).SetTabOrder(I);
end;

procedure TdlDFEditors.TabsClick(Sender: TObject);
begin
  if Sender = Tabs_SortSel then Tabs_Fill(TABS_FILL_SELECTED);
  if Sender = Tabs_SortPos then Tabs_Fill(TABS_FILL_TOP);
  if Sender = Tabs_ReadOnly then Tabs_Fill(TABS_FILL_READONLY);
  if Sender = Tabs_Up then
    if (Tabs_List.itemindex > 0) then
      Tabs_List.items.Exchange(Tabs_List.itemindex, Tabs_List.itemindex-1);
  if Sender = Tabs_Down then
    if (Tabs_List.itemindex < Tabs_List.items.count-1) and (Tabs_List.itemindex > -1) then
      Tabs_List.items.Exchange(Tabs_List.itemindex, Tabs_List.itemindex+1);
end;

procedure TdlDFEditors.FormShow(Sender: TObject);
begin
  if Pages.ActivePage = Strings_Page then
  begin
    Caption:= 'Defined Strings Editor';
    ActiveControl:= Strings_Text;
  end;

  if Pages.ActivePage = Tabs_Page then
  begin
    Caption:= 'Defined TabOrder Editor';
    ActiveControl:= Tabs_List;
  end;

  if Pages.ActivePage = Picture_Page then
  begin
    Caption:= 'Defined Picture Editor';
    ActiveControl:= Picture_Load;
  end;

  if Pages.ActivePage = Field_Page then
  begin
    Caption:= 'Defined FieldLink Editor';
    ActiveControl:= Field_List;
  end;

  if Pages.ActivePage = Links_Page then
  begin
    Caption:= 'Defined FieldLink Editor';
    ActiveControl:= Links_Link;
  end;
end;

procedure TdlDFEditors.FormCreate(Sender: TObject);
begin
  Links_List:= TStringList.create;
end;

procedure TdlDFEditors.FormDestroy(Sender: TObject);
begin
  Links_List.free;
end;

procedure TdlDFEditors.Update_Links(const selection: string);
var X: integer;
begin
  dfFillTreeView(Links_Tree, Links_List);
  if selection <> '' then
  begin
    for x:= 0 to dlDFEditors.Links_List.count-1 do
      if sametext(dlDFEditors.Links_List[x], selection) then
        dlDFEditors.Links_Tree.Selected:= dlDFEditors.Links_Tree.Items[x{+1}];
    dlDFEditors.Links_Link.text:= selection
  end
  else
    dlDFEditors.Links_Link.text:= '';
end;

procedure TdlDFEditors.Links_LinkChange(Sender: TObject);
var X: integer;
begin
  for x:= 0 to dlDFEditors.Links_List.count-1 do
    if sametext(dlDFEditors.Links_List[x], Links_Link.text) then
      dlDFEditors.Links_Tree.Selected:= dlDFEditors.Links_Tree.Items[x{+1}];
end;

procedure TdlDFEditors.LinksClick(Sender: TObject);
var
  tmpstr: string;
  X: integer;
begin
  if Sender = Links_Load then
  begin
    if Field_OpenDialog.Execute then
    begin
      Links_List.LoadFromFile(Field_OpenDialog.Filename);
      Update_Links(Links_Link.text);
    end;
  end;

  if Sender = Links_Search then
  begin
    tmpstr:= '';
    if dlDFEditors.Links_Tree.Selected <> nil then
    begin
      if messagedlg('Start from beginning?',mtConfirmation,[mbYes,mbNo],0)= mrYes then
        dlDFEditors.Links_Tree.Selected:= dlDFEditors.Links_Tree.items[0]
    end
    else
      dlDFEditors.Links_Tree.Selected:= dlDFEditors.Links_Tree.items[1];

    if inputquery('Search for Field Link', 'Enter Text...', tmpstr) then
      for X:= Links_Tree.selected.absoluteindex to Links_List.count-1 do
        if pos( lowercase(tmpstr), lowercase(Links_List[x]) ) > 0 then
        begin
          dlDFEditors.Links_Tree.Selected:= dlDFEditors.Links_Tree.Items[x{+1}];
          break;
        end;
  end;
end;

procedure TdlDFEditors.Links_TreeClick(Sender: TObject);
begin
  if Links_Tree.selected = nil then Exit;
  if Links_Tree.selected = Links_Tree.items[0] then Exit;
  Links_Link.text:= Links_List[Links_Tree.selected.absoluteindex{-1}];
end;

procedure TdlDFEditors.Links_TreeDblClick(Sender: TObject);
begin
  Modalresult:= mrOK;
end;

end.
