
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Field Link Editor                               }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dflinkedit;

interface

{$WEAKPACKAGEUNIT ON}

uses
  Windows, Classes, Graphics, Forms, Controls, Dialogs, Buttons,
  StdCtrls, ExtCtrls, ExtDlgs, SysUtils, ComCtrls, Menus, ImgList,
  dfclasses, dfUtil, dfListview, System.UITypes;

type
  TdlLinkEditor = class(TForm)
    Links: TTreeView;
    Mappings: TListView;
    Label3: TLabel;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    pAdd: TMenuItem;
    pDelete: TMenuItem;
    ImageList1: TImageList;
    btnAuto: TSpeedButton;
    pAuto: TMenuItem;
    btnClear: TSpeedButton;
    pClear: TMenuItem;
    pSearch: TMenuItem;
    btnSearch: TSpeedButton;
    btnPrint: TSpeedButton;
    pPrint: TMenuItem;
    procedure DoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LinksDblClick(Sender: TObject);
  private
  public
    Links_List: TStringList;
    procedure Execute;
  end;

var
  dlLinkEditor: TdlLinkEditor;

implementation

uses
  dfdesigner;

{$R *.DFM}

procedure TdlLinkEditor.FormCreate(Sender: TObject);
begin
  Links_List:= TStringList.create;
end;

procedure TdlLinkEditor.FormDestroy(Sender: TObject);
begin
  Links_List.free;
end;

procedure TdlLinkEditor.Execute;
var
  I,J: integer;
  Flag: boolean;
  Field: TdfField;
begin
  Links.items.clear;
  if fileexists(dfGetPath+'fields.dat') then
    Links_List.loadfromfile(dfGetPath+'fields.dat');
  dfFillTreeView(Links, Links_List);
  Mappings.items.clear;
  for I:= 0 to fmDFDesigner.Engine.fieldcount-1 do
  begin
    Field:= fmDFDesigner.Engine.fields[I];
    Mappings.Items.add;
    Mappings.Items[I].caption:= Field.fieldname;
    Mappings.Items[I].SubItems.add(Field.FieldLink);
    if Field.fieldparams <> '' then
      Mappings.Items[I].SubItems.add(Field.fieldparams);

    if (Field.FieldLink <> '') then
    begin
      Flag:= false;
      for J:= 0 to Links_List.count-1 do
        if sametext(Links_List[J], Field.FieldLink ) then
          Flag:= true;
    end
    else
      Flag:= true;

    if (Field.fieldlink = '') and (Field.expression = '') and (not Field.Active) then
      Flag:= False;

    if Flag then
      Mappings.Items[I].imageindex:= 2
    else
      Mappings.Items[I].imageindex:= 3;
  end;
  Showmodal;
end;

procedure TdlLinkEditor.DoClick(Sender: TObject);
var
  I: integer;
  tmpstr: string;
begin
  if (Sender = btnAdd) or (Sender = pAdd) then
  begin
    if Links.selected = nil then Exit;
    if Mappings.selected = nil then Exit;
    Mappings.selected.subitems[0]:=
      Links_List[Links.selected.absoluteindex];
    fmDFDesigner.Engine.fields[Mappings.selected.index].fieldlink:=
      Mappings.selected.subitems[0];
    if Mappings.selected.imageindex = 3 then
      Mappings.selected.imageindex:= 2;
    if (Mappings.Selected <> nil) and (Mappings.Selected.Index < Mappings.Items.count-1) then
      Mappings.Selected := Mappings.Items[Mappings.Selected.Index + 1];
  end;

  if (Sender = btnDelete) or (Sender = pDelete) then
  begin
    if Mappings.selected = nil then Exit;
    Mappings.selected.subitems[0]:= '';
    fmDFDesigner.Engine.fields[Mappings.selected.index].fieldlink:= '';
    Mappings.selected.imageindex := 3;
  end;

  if (Sender = btnClear) or (Sender = pClear) then
  begin
    if messagedlg('Clear all mappings?',mtConfirmation,[mbYes,mbNo],0)= mrNo then Exit;
    for I:= 0 to Mappings.Items.count-1 do
    begin
      Mappings.Items[I].subitems[0]:= '';
      Mappings.Items[I].imageindex:= 3;
      fmDFDesigner.Engine.fields[I].fieldlink:= '';
    end;
  end;

  if (Sender = btnSearch) or (Sender = pSearch) then
  begin
    tmpstr:= '';
    if Links.Selected <> nil then
    begin
      if messagedlg('Start from beginning?',mtConfirmation,[mbYes,mbNo],0)= mrYes then
        Links.Selected:= Links.items[0]
    end
    else
      Links.Selected:= Links.items[1];

    if inputquery('Search for Field Link', 'Enter Text...', tmpstr) then
      for I:= Links.selected.absoluteindex to Links_List.count-1 do
        if pos( lowercase(tmpstr), lowercase(Links_List[I]) ) > 0 then
        begin
          Links.Selected:= Links.Items[I+1];
          break;
        end;
  end;

  if (Sender = btnPrint) or (Sender = pPrint) then
  begin
    PrintListView(Mappings, 'Form Reporter', false);
  end;
end;

procedure TdlLinkEditor.LinksDblClick(Sender: TObject);
begin
  DoClick(btnAdd);
end;

end.
