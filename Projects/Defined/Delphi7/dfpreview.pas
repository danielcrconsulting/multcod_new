
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Print Preview                                   }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfpreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, Buttons, ComCtrls, ToolWin, ImgList, ActnList, ShellAPI,
  dfclasses, dfcontrols, dfconvert, dfutil;

type
  TdlDFPreview = class(TForm)
    CoolBarMain: TCoolBar;
    ToolbarMenu: TToolBar;
    ToolbarMain: TToolBar;
    btnClear: TToolButton;
    btnOpen: TToolButton;
    btnExport: TToolButton;
    btnPrint: TToolButton;
    bmFile: TToolButton;
    bmView: TToolButton;
    bmZoom: TToolButton;
    bmHelp: TToolButton;
    btnRefresh: TToolButton;
    ImageList1: TImageList;
    Tabs: TTabControl;
    ScrollBox: TScrollBox;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    fmFile: TMenuItem;
    fmClear: TMenuItem;
    fmOpen: TMenuItem;
    fmExport: TMenuItem;
    S0: TMenuItem;
    fmPrint: TMenuItem;
    S1: TMenuItem;
    fmClose: TMenuItem;
    vmView: TMenuItem;
    vmMainToolbar: TMenuItem;
    vmRefresh: TMenuItem;
    zmZoom: TMenuItem;
    zmPW: TMenuItem;
    zmPH: TMenuItem;
    zm200: TMenuItem;
    zm150: TMenuItem;
    zm100: TMenuItem;
    zm75: TMenuItem;
    zm50: TMenuItem;
    hmHelp: TMenuItem;
    hmAbout: TMenuItem;
    PopMain: TPopupMenu;
    S6: TMenuItem;
    vmButtonCaptions: TMenuItem;
    btnZoom: TToolButton;
    PopZoom: TPopupMenu;
    faClear: TAction;
    faOpen: TAction;
    faExport: TAction;
    faPrint: TAction;
    faClose: TAction;
    vaMainToolbar: TAction;
    vaButtonCaptions: TAction;
    vaRefresh: TAction;
    zaPW: TAction;
    zaPH: TAction;
    za200: TAction;
    za150: TAction;
    za100: TAction;
    za75: TAction;
    za50: TAction;
    haAbout: TAction;
    vaBottomTabs: TAction;
    vmBottomTabs: TMenuItem;
    N3: TMenuItem;
    ActiveDisplay: TDFActiveDisplay;
    pmPage: TMenuItem;
    pmFirst: TMenuItem;
    pmNext: TMenuItem;
    pmPrior: TMenuItem;
    pmLast: TMenuItem;
    bmPage: TToolButton;
    btnFirst: TToolButton;
    btnNext: TToolButton;
    btnPrior: TToolButton;
    btnLast: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    vmPageTabs: TMenuItem;
    ChangePage1: TMenuItem;
    FirstPage2: TMenuItem;
    NextPage2: TMenuItem;
    PriorPage2: TMenuItem;
    LastPage2: TMenuItem;
    N1: TMenuItem;
    New1: TMenuItem;
    SaveAs1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    vaPageTabs: TAction;
    paFirst: TAction;
    paNext: TAction;
    paPrior: TAction;
    paLast: TAction;
    Engine: TDFEngine;
    btnExit: TToolButton;
    ToolButton1: TToolButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    btnSave: TToolButton;
    fmSave: TMenuItem;
    faSave: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FileActionExecute(Sender: TObject);
    procedure ViewActionExecute(Sender: TObject);
    procedure PageActionExecute(Sender: TObject);
    procedure ZoomActionExecute(Sender: TObject);
    procedure HelpActionExecute(Sender: TObject);
    procedure TabsChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Initialized: boolean;
    FPreviewCaption: string;
    FPreviewZoom: string;
    FPreviewOptions: TdfPreviewOptions;
    FVirtualPage : Integer;
    FPreviewFilename: string;
    procedure UpdateTabs;
    procedure UpdateStatus;
    function GetPageCount: integer;
    function GetPageIndex: integer;
    procedure SetPageIndex(const Index: integer);
  public
    function Execute(Source: TDFEngine; const Show: boolean): boolean;
    property PreviewCaption: string read FPreviewCaption write FPreviewCaption;
    property PreviewFilename: string read FPreviewFilename write FPreviewFilename;
    property PreviewZoom: string read FPreviewZoom write FPreviewZoom;
    property PreviewOptions: TdfPreviewOptions read FPreviewOptions write FPreviewOptions;
  end;

var
  dlDFPreview: TdlDFPreview;
  PreviewMaximized: boolean = false;

implementation

{$R *.DFM}


{*********************}
{  Events & Actions   }
{*********************}

procedure TdlDFPreview.FormCreate(Sender: TObject);
begin
  { default settings }
  FVirtualPage:= 0;
  PreviewCaption:= 'Print Preview';
  PreviewZoom:= 'PW';
  PreviewOptions := [dfToolbar, dfButtonCaptions, dfPageTabs, dfBottomTabs,
                     dfMaximized, dfAllowClear, dfAllowOpen, dfAllowExport,
                     dfAllowPrint];
  Initialized:= false;
  Width := 640;
  Height := 480;

  Engine.Clear;
  Tabs.TabIndex:= -1;
end;

function TdlDFPreview.Execute(Source: TDFEngine; const Show: boolean): boolean;
begin
  Caption := PreviewCaption;

  OpenDialog1.Filter:= PREVTYPES_OPEN;
  if (dfOnlyMultiPageExports in FPreviewOptions) then
    SaveDialog1.Filter:= PREVTYPES_MULTISAVE
 else
    SaveDialog1.Filter:= PREVTYPES_SAVE;

  if FPreviewFilename <> '' then
    SaveDialog1.Filename := FPreviewFilename;

  { apply settings }
  if (dfMaximized in FPreviewOptions) or (Screen.Width = 640) then WindowState := wsMaximized;
  if (not(dfToolbar in FPreviewOptions)) then vaMainToolbar.Execute;
  if (not(dfButtonCaptions in FPreviewOptions)) then vaButtonCaptions.Execute;
  if (not(dfPageTabs in FPreviewOptions)) then vaPageTabs.Execute;
  if (not(dfBottomTabs in FPreviewOptions)) then vaBottomTabs.Execute;
  if (not(dfAllowClear in FPreviewOptions)) then faClear.Enabled:= false;
  if (not(dfAllowOpen in FPreviewOptions)) then faOpen.Enabled:= false;
  if (not(dfAllowExport in FPreviewOptions)) then faExport.Enabled:= false;
  if (not(dfAllowPrint in FPreviewOptions)) then faPrint.Enabled:= false;
  if (not(dfSaveButton in FPreviewOptions)) then faSave.visible:= false;  

  if (PreviewZoom = 'PW') then zaPW.Execute;
  if (PreviewZoom = 'PH') then zaPH.Execute;
  if (PreviewZoom = '200') then za200.Execute;
  if (PreviewZoom = '150') then za150.Execute;
  if (PreviewZoom = '100') then za100.Execute;
  if (PreviewZoom = '75') then za75.Execute;
  if (PreviewZoom = '50') then za50.Execute;

  { create dynamic sub-menus }
  dfMergeMenu(PopZoom, zmZoom);

  { assign form-data }
  if Source <> nil then
    Engine.Assign(Source);

  { update }
  UpdateStatus;
  UpdateTabs;
  Tabs.TabIndex:= 0;

  if (GetPageCount < 2) or (GetPageIndex < 0) then
  begin
    paFirst.Enabled:= false;
    paLast.Enabled:= false;
    paPrior.Enabled:= false;
    paNext.Enabled:= false;
  end;

  { init status }
  Initialized:= true;

  { show form }
  if Show then
  begin
    result:= ShowModal = mrOK;
    //save data
    if result and (Source <> nil) then
      Source.Assign(Engine);
  end
  else
    result:= false;

  { update settings }

  if (WindowState = wsMaximized) and (screen.width > 640) then
    PreviewMaximized:= true
  else
    PreviewMaximized:= false;

  if (WindowState = wsMaximized) and (screen.width > 640) then
    PreviewOptions:= PreviewOptions + [dfMaximized]
  else
    PreviewOptions:= PreviewOptions - [dfMaximized];

  if vaMainToolbar.checked then
    PreviewOptions:= PreviewOptions + [dfToolbar]
  else
    PreviewOptions:= PreviewOptions - [dfToolbar];

  if vaButtonCaptions.checked then
    PreviewOptions:= PreviewOptions + [dfButtonCaptions]
  else
    PreviewOptions:= PreviewOptions - [dfButtonCaptions];

  if vaPageTabs.checked then
    PreviewOptions:= PreviewOptions + [dfPageTabs]
  else
    PreviewOptions:= PreviewOptions - [dfPageTabs];

  if vaBottomTabs.checked then
    PreviewOptions:= PreviewOptions + [dfBottomTabs]
  else
    PreviewOptions:= PreviewOptions - [dfBottomTabs];

  if zaPW.checked then PreviewZoom := 'PW';
  if zaPH.checked then PreviewZoom := 'PH';
  if za200.checked then PreviewZoom := '200';
  if za150.checked then PreviewZoom := '150';
  if za100.checked then PreviewZoom := '100';
  if za75.checked then PreviewZoom := '75';
  if za50.checked then PreviewZoom := '50';

  Screen.Cursor:= crDefault;
end;

procedure TdlDFPreview.FileActionExecute(Sender: TObject);
var I: integer;
    tmpstr: string;
    currpage: integer;
begin
  { Clear }
  if Sender = faClear then
  begin
    if MessageDlg('Clear all field data?',mtWarning,[mbyes,mbno],0)=mrYes then
      Engine.ClearFields;
  end;

  { Open }
  if Sender = faOpen then
  begin
    if OpenDialog1.Execute then
    begin
      dfOpenFile(Engine, OpenDialog1.FileName);
    end;
    ZoomActionExecute(nil);
    UpdateStatus;
    UpdateTabs;
  end;

  { SaveAs }
  if Sender = faExport then
  begin
    if SaveDialog1.Execute then
    begin
      tmpstr:= SaveDialog1.FileName;
      if extractfileext(tmpstr) = '' then
        tmpstr:= tmpstr + dfGetFilter(SaveDialog1.Filter, SaveDialog1.FilterIndex);
      dfSaveFile(Engine, tmpstr);
      UpdateStatus;
    end;
  end;

  { Print }
  if Sender = faPrint then
  begin
    if Assigned(Engine.OnPreviewPageShow) then
    begin
      currpage := GetPageIndex;
      ActiveDisplay.FormEngine := nil;
      Engine.PrintDialog(1, Tabs.Tabs.Count);
      ActiveDisplay.FormEngine := Engine;
      SetPageIndex(currpage);
    end
    else
      Engine.PrintDialog(1, Tabs.Tabs.Count);
  end;

  { Save }
  if (Sender = faSave) then
  begin
    if dfEnforceRequired in Engine.PreviewOptions then
    begin
      tmpstr := '';
      for I := 0 to Engine.FieldCount-1 do
        if Engine.Fields[I].Required and (Engine.Fields[I].Data = '') then
        begin
          if tmpstr <> '' then tmpstr := tmpstr + ' / ';
          tmpstr := tmpstr + lowercase(Engine.Fields[I].Fieldname);
        end;
      if tmpstr <> '' then
      begin
        tmpstr := 'Required fields are missing! ('+tmpstr+')';
        raise Exception.create(tmpstr);
      end;
    end;
    Modalresult:= mrOK;
  end;

  { Close }
  if (Sender = faClose) then
  begin
    if (faSave.visible) and (ActiveDisplay.DataChanged) then
      case messagedlg('Save changes?',mtWarning,[mbYes,mbNo,mbCancel],0) of
        mrCancel: Exit;
        mrYes: begin
          faSave.execute;
          Exit;
        end;
      end;
    Modalresult:= mrCancel;
  end;
end;

procedure TdlDFPreview.PageActionExecute(Sender: TObject);
begin
  if Sender = paFirst then Tabs.TabIndex:= 0;
  if Sender = paPrior then
    if Tabs.TabIndex > 0 then
      Tabs.TabIndex:= Tabs.TabIndex - 1;
  if Sender = paNext then
    if Tabs.TabIndex < Tabs.Tabs.count-1 then
      Tabs.TabIndex:= Tabs.TabIndex + 1;
  if Sender = paLast then Tabs.TabIndex:= Tabs.Tabs.count-1;
  TabsChange(nil);
end;

procedure TdlDFPreview.HelpActionExecute(Sender: TObject);
begin
  { About }
  if Sender = haAbout then
  begin
    MessageDlg(PreviewCaption, mtInformation, [mbOK],0);
  end;
end;

procedure TdlDFPreview.ViewActionExecute(Sender: TObject);
begin
  { checkmark view options }
  if (Sender as TAction).Tag = 1 then
    (Sender as TAction).Checked := not (Sender as TAction).Checked;

  {show/hide}
  if Sender = vaButtonCaptions then
  begin
    ToolbarMain.ShowCaptions := vaButtonCaptions.checked;
    ToolbarMain.ButtonHeight := 0;
    ToolbarMain.ButtonWidth := 0;
  end;

  if Sender = vaPageTabs then
  begin
    if not vaPageTabs.checked then
    begin
      Tabs.RemoveControl(ScrollBox);
      Tabs.Visible:= false;
      InsertControl(ScrollBox);
    end
    else begin
      RemoveControl(ScrollBox);
      Tabs.InsertControl(ScrollBox);
      Tabs.Visible:= true;
    end;
  end;

  if Sender = vaBottomTabs then
  begin
    if vaBottomTabs.checked then
      Tabs.TabPosition:= tpBottom
    else
      Tabs.TabPosition:= tpTop;
  end;

  if Sender = vaMainToolbar then
  begin
    ToolbarMain.visible:= vaMainToolbar.checked;
  end;

  { refresh }
  if Sender = vaRefresh then
  begin
    ActiveDisplay.RefreshForm;
  end;
end;

procedure TdlDFPreview.ZoomActionExecute(Sender: TObject);

  procedure CheckZoom(Action: TAction);
  var I: integer;
  begin
    for I:= 0 to ActionList1.ActionCount-1 do
      if ActionList1.Actions[I].Category = (Sender as TAction).Category then
        TAction(ActionList1.Actions[I]).Checked:= false;
    Action.Checked:= true;
  end;

begin
  { checkmark view options }
  if Sender <> nil then
    if (Sender as TAction).Tag = 2 then
      CheckZoom(Sender as TAction);

  { zoom options }
  if zaPW.checked then ActiveDisplay.AlignToScrollBox(Scrollbox, 'PW');
  if zaPH.checked then ActiveDisplay.AlignToScrollBox(Scrollbox, 'PH');
  if za200.checked then ActiveDisplay.AlignToScrollBox(Scrollbox, 200);
  if za150.checked then ActiveDisplay.AlignToScrollBox(Scrollbox, 150);
  if za100.checked then ActiveDisplay.AlignToScrollBox(Scrollbox, 100);
  if za75.checked then ActiveDisplay.AlignToScrollBox(Scrollbox, 75);
  if za50.checked then ActiveDisplay.AlignToScrollBox(Scrollbox, 50);
end;

procedure TdlDFPreview.UpdateTabs;
var
  I: integer;
begin
  while Tabs.Tabs.Count < GetPageCount do
    Tabs.Tabs.add('NEW');
  while Tabs.Tabs.Count > GetPageCount do
    Tabs.Tabs.Delete(0);
  for I:= 0 to GetPageCount-1 do
  begin
    //If it is virtual use a standard naming scheme based on the page number--
    if Assigned(Engine.OnPreviewPageShow) then
      Tabs.Tabs[i]:= 'Page ' + IntToStr(i+1)
    else
      Tabs.Tabs[i]:= Engine.Pages[i].PageName;
  end;
  if (Tabs.Tabindex = -1) or Assigned(Engine.OnPreviewPageShow) then
  begin
    Tabs.Tabindex:= 0;
    SetPageIndex(0);
  end;
end;

procedure TdlDFPreview.UpdateStatus;
begin
  Caption:= PreviewCaption + ' - Page ' + IntToStr(GetPageIndex + 1) +
    ' of ' + IntToStr(GetPageCount);
end;

procedure TdlDFPreview.TabsChange(Sender: TObject);
begin
  SetPageIndex(Tabs.TabIndex);
  UpdateStatus;
end;

procedure TdlDFPreview.FormResize(Sender: TObject);
begin
  ZoomActionExecute(nil);
end;

function TdlDFPreview.GetPageCount: integer;
var c : Integer;
begin
  c:= Engine.PageCount;
  if (Assigned(Engine.OnPreviewPageCount)) then
    Engine.OnPreviewPageCount(Engine, c);
  Result:= c;
end;

function TdlDFPreview.GetPageIndex: integer;
begin
  if (Assigned(Engine.OnPreviewPageShow)) then
    Result := FVirtualPage
  else
    Result := ActiveDisplay.pageindex;
end;

procedure TdlDFPreview.SetPageIndex(const Index: integer);
var Actual : Integer;
begin
  if (Assigned(Engine.OnPreviewPageShow)) then
  begin
    Actual:= 0;
    // If it is virtual it is only allowed to use one page - 0
    Engine.OnPreviewPageShow(Engine, Index, Actual);
    // This would be cool to set in the event so that there can be multiple virtual pages (later!)
    ActiveDisplay.pageindex := Actual;
    // Store this virtual page number
    FVirtualPage:= Index;
  end else
    ActiveDisplay.pageindex := Index;
end;

procedure TdlDFPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  Action := caNone;
//  faClose.Execute;
end;

end.
