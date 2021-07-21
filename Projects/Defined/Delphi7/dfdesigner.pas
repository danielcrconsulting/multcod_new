
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Designer Implementation                         }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfdesigner;

interface

{$I DEFINEDFORMS.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, Buttons, ComCtrls, ToolWin, ImgList, ActnList, ShellAPI,
  Clipbrd, StdCtrls, Registry, dfclasses, dfcontrols, dfconvert, dfutil,
  dfinspect, dfeditors, dfpreview, dflinkedit, defstream, System.Actions, System.UITypes;

type
  TfmDFDesigner = class(TForm)
    CoolBarMain: TCoolBar;
    ToolbarMenu: TToolBar;
    ToolbarMain: TToolBar;
    btnNew: TToolButton;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    btnPrint: TToolButton;
    btnPreview: TToolButton;
    btnProperties: TToolButton;
    bmFile: TToolButton;
    bmEdit: TToolButton;
    bmView: TToolButton;
    bmZoom: TToolButton;
    bmObject: TToolButton;
    bmHelp: TToolButton;
    btnExit: TToolButton;
    btnDelete: TToolButton;
    ImageList1: TImageList;
    btnHelp: TToolButton;
    Status: TStatusBar;
    Tabs: TTabControl;
    ScrollBox: TScrollBox;
    Design: TDFDesigner;
    CoolbarLeft: TCoolBar;
    ToolbarAdd: TToolBar;
    btnArrow: TToolButton;
    btnPage: TToolButton;
    btnLine: TToolButton;
    btnFrame: TToolButton;
    btnLogo: TToolButton;
    btnButton: TToolButton;
    btnText: TToolButton;
    btnField: TToolButton;
    CoolbarRight: TCoolBar;
    ToolbarAlign: TToolBar;
    btnAlignLeft: TToolButton;
    btnAlignRight: TToolButton;
    btnAlignTop: TToolButton;
    btnAlignBottom: TToolButton;
    btnSpaceHoriz: TToolButton;
    btnSpaceVert: TToolButton;
    btnSendBack: TToolButton;
    btnBringFront: TToolButton;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    fmFile: TMenuItem;
    fmNew: TMenuItem;
    fmOpen: TMenuItem;
    fmReopen: TMenuItem;
    fmSave: TMenuItem;
    fmSaveAs: TMenuItem;
    S0: TMenuItem;
    fmPrint: TMenuItem;
    fmPrintPreview: TMenuItem;
    S1: TMenuItem;
    fmExit: TMenuItem;
    emEdit: TMenuItem;
    emCut: TMenuItem;
    emCopy: TMenuItem;
    emPaste: TMenuItem;
    emDelete: TMenuItem;
    emUndelete: TMenuItem;
    S2: TMenuItem;
    S4: TMenuItem;
    emSelectAll: TMenuItem;
    emSelectAllText: TMenuItem;
    emSelectAllFields: TMenuItem;
    vmView: TMenuItem;
    vmMainToolbar: TMenuItem;
    vmObjectToolbar: TMenuItem;
    vmAlignToolbar: TMenuItem;
    vmStatusBar: TMenuItem;
    S5: TMenuItem;
    vmRulers: TMenuItem;
    vmFields: TMenuItem;
    vmForm: TMenuItem;
    vmMargins: TMenuItem;
    vmRefresh: TMenuItem;
    vmProperties: TMenuItem;
    zmZoom: TMenuItem;
    zmPW: TMenuItem;
    zmPH: TMenuItem;
    zm200: TMenuItem;
    zm150: TMenuItem;
    zm100: TMenuItem;
    zm75: TMenuItem;
    zm50: TMenuItem;
    tmTools: TMenuItem;
    S7: TMenuItem;
    tmScale: TMenuItem;
    tmOptimize: TMenuItem;
    S8: TMenuItem;
    tmTaborder: TMenuItem;
    hmHelp: TMenuItem;
    hmContents: TMenuItem;
    hmHomePage: TMenuItem;
    S9: TMenuItem;
    hmAbout: TMenuItem;
    PopMain: TPopupMenu;
    pmAlign: TMenuItem;
    pmAdd: TMenuItem;
    pmTabOrder: TMenuItem;
    PopHistory: TPopupMenu;
    pmHistory1: TMenuItem;
    pmHistory2: TMenuItem;
    pmHistory3: TMenuItem;
    pmHistory4: TMenuItem;
    pmHistory5: TMenuItem;
    pmHistory6: TMenuItem;
    pmHistory7: TMenuItem;
    pmHistory8: TMenuItem;
    PopProp: TPopupMenu;
    pmPageProperties: TMenuItem;
    pmFormProperties: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SB1: TToolButton;
    S11: TMenuItem;
    emCopySpecial: TMenuItem;
    emPasteSpecial: TMenuItem;
    emCopyPage: TMenuItem;
    emCopyForm: TMenuItem;
    emEntirePage: TMenuItem;
    emEntireForm: TMenuItem;
    S3: TMenuItem;
    emPasteWord: TMenuItem;
    PopNew: TPopupMenu;
    pmAddPage: TMenuItem;
    pmAddLine: TMenuItem;
    pmAddFrame: TMenuItem;
    pmAddLogo: TMenuItem;
    pmAddButton: TMenuItem;
    pmAddText: TMenuItem;
    pmAddField: TMenuItem;
    tmAdd: TMenuItem;
    vmCoordinates: TMenuItem;
    vmChangePPI: TMenuItem;
    S6: TMenuItem;
    vmInches: TMenuItem;
    vmCM: TMenuItem;
    vmPixels: TMenuItem;
    vmGuides: TMenuItem;
    tmInvert: TMenuItem;
    tmAlign: TMenuItem;
    PopAlign: TPopupMenu;
    pmAlignLeftEdges: TMenuItem;
    pmAlignRightEdges: TMenuItem;
    pmAlignTopEdges: TMenuItem;
    pmAlignBottomEdges: TMenuItem;
    pmAlignHorz: TMenuItem;
    pmAlignVert: TMenuItem;
    S12: TMenuItem;
    pmSnaptogrid: TMenuItem;
    pmBringtoFront: TMenuItem;
    pmSendtoback: TMenuItem;
    S13: TMenuItem;
    pmCenterHoriz: TMenuItem;
    pmCenterVert: TMenuItem;
    pmAligntopage: TMenuItem;
    pmCut: TMenuItem;
    pmCopy: TMenuItem;
    pmPaste: TMenuItem;
    pmDelete: TMenuItem;
    S10: TMenuItem;
    PopKey: TPopupMenu;
    kmToggle: TMenuItem;
    kmCtrlLeft: TMenuItem;
    kmCtrlRight: TMenuItem;
    kmCtrlUp: TMenuItem;
    kmCtrlDown: TMenuItem;
    kmShiftLeft: TMenuItem;
    kmShiftRight: TMenuItem;
    kmShiftUp: TMenuItem;
    kmShiftDown: TMenuItem;
    kmShiftCtrlLeft: TMenuItem;
    kmShiftCtrlRight: TMenuItem;
    kmShiftCtrlUp: TMenuItem;
    kmShiftCtrlDown: TMenuItem;
    kmLeft: TMenuItem;
    kmRight: TMenuItem;
    kmUp: TMenuItem;
    kmDown: TMenuItem;
    kmEscape: TMenuItem;
    kmAdd: TMenuItem;
    vmButtonCaptions: TMenuItem;
    S14: TMenuItem;
    fmClearHistory: TMenuItem;
    Engine: TDFEngine;
    vmCentered: TMenuItem;
    SB2: TToolButton;
    N1: TMenuItem;
    btnZoom: TToolButton;
    PopZoom: TPopupMenu;
    SB3: TToolButton;
    faNew: TAction;
    faOpen: TAction;
    faReopen: TAction;
    faSaveAs: TAction;
    faPrint: TAction;
    faPreview: TAction;
    faExit: TAction;
    faSave: TAction;
    faClearHistory: TAction;
    eaCut: TAction;
    eaCopy: TAction;
    eaPaste: TAction;
    eaDelete: TAction;
    eaUndelete: TAction;
    eaCopyForm: TAction;
    eaPasteForm: TAction;
    eaSelectAll: TAction;
    eaSelectAllText: TAction;
    eaSelectAllFields: TAction;
    eaCopyPage: TAction;
    eaPastePage: TAction;
    eaPasteWord: TAction;
    vaMainToolbar: TAction;
    vaObjectToolbar: TAction;
    vaAlignToolbar: TAction;
    vaStatusbar: TAction;
    vaButtonCaptions: TAction;
    vaRulers: TAction;
    vaMargins: TAction;
    vaForm: TAction;
    vaFields: TAction;
    vaInches: TAction;
    vaCM: TAction;
    vaPixels: TAction;
    vaChangePPI: TAction;
    vaRefresh: TAction;
    vaProperties: TAction;
    vaPageProp: TAction;
    vaFormProp: TAction;
    vaCentered: TAction;
    zaPW: TAction;
    zaPH: TAction;
    za200: TAction;
    za150: TAction;
    za100: TAction;
    za75: TAction;
    za50: TAction;
    adaAddPage: TAction;
    adaAddLine: TAction;
    adaAddFrame: TAction;
    adaAddLogo: TAction;
    adaAddButton: TAction;
    adaAddText: TAction;
    adaAddField: TAction;
    adaCancelAdd: TAction;
    taScale: TAction;
    taOptimize: TAction;
    taTabOrder: TAction;
    taInvert: TAction;
    haHelpContents: TAction;
    haHomePage: TAction;
    haAbout: TAction;
    aaLeftEdges: TAction;
    aaRightEdges: TAction;
    aaTopEdges: TAction;
    aaBottomEdges: TAction;
    aaSpaceHoriz: TAction;
    aaSpaceVert: TAction;
    aaSnapGrid: TAction;
    aaBringFront: TAction;
    aaSendBack: TAction;
    aaAlignPage: TAction;
    aaCenterHoriz: TAction;
    aaCenterVert: TAction;
    kaEscape: TAction;
    kaToggle: TAction;
    kaCtrlLeft: TAction;
    kaCtrlRight: TAction;
    kaCtrlUp: TAction;
    kaCtrlDown: TAction;
    kaShiftLeft: TAction;
    kaShiftRight: TAction;
    kaShiftUp: TAction;
    kaShiftDown: TAction;
    kaShiftCtrlLeft: TAction;
    kaShiftCtrlRight: TAction;
    kaShiftCtrlUp: TAction;
    kaShiftCtrlDown: TAction;
    kaLeft: TAction;
    kaRight: TAction;
    kaUp: TAction;
    kaDown: TAction;
    kaAdd: TAction;
    vmSideToolbars: TMenuItem;
    vaSideToolbars: TAction;
    vaBottomTabs: TAction;
    vmBottomTabs: TMenuItem;
    vmBackgrounds: TMenuItem;
    vaBackgrounds: TAction;
    vmLayout: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    tmDefaults: TMenuItem;
    tmDefaultLine: TMenuItem;
    tmDefaultFrame: TMenuItem;
    tmDefaultLogo: TMenuItem;
    tmDefaultButton: TMenuItem;
    tmDefaultText: TMenuItem;
    tmDefaultField: TMenuItem;
    taDefaultLine: TAction;
    taDefaultFrame: TAction;
    taDefaultLogo: TAction;
    taDefaultButton: TAction;
    taDefaultText: TAction;
    taDefaultField: TAction;
    N7: TMenuItem;
    pmDefaultLine: TMenuItem;
    pmDefaultFrame: TMenuItem;
    pmDefaultLogo: TMenuItem;
    pmDefaultButton: TMenuItem;
    pmDefaultText: TMenuItem;
    pmDefaultField: TMenuItem;
    emSelectTag: TMenuItem;
    eaSelectTag: TAction;
    N8: TMenuItem;
    pmProperties1: TMenuItem;
    Enter1: TMenuItem;
    kaEnter: TAction;
    mPrintDesign: TMenuItem;
    faPrintDesign: TAction;
    ClearFieldData1: TMenuItem;
    taClearFields: TAction;
    N9: TMenuItem;
    SavePermanentDefaults1: TMenuItem;
    taSavePermDefaults: TAction;
    taResetStorage: TAction;
    ResetFieldStorage1: TMenuItem;
    N10: TMenuItem;
    emCopyLinks: TMenuItem;
    N11: TMenuItem;
    emPasteLinks: TMenuItem;
    eaCopyLinks: TAction;
    eaPasteLinks: TAction;
    pmLinkEditor: TMenuItem;
    taLinkEditor: TAction;
    FieldLinkEditor1: TMenuItem;
    emCopyFieldList: TMenuItem;
    eaCopyFieldList: TAction;
    N12: TMenuItem;
    emFind: TMenuItem;
    eaFind: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FileActionExecute(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
    procedure ViewActionExecute(Sender: TObject);
    procedure ZoomActionExecute(Sender: TObject);
    procedure ToolsActionExecute(Sender: TObject);
    procedure HelpActionExecute(Sender: TObject);
    procedure KeyActionExecute(Sender: TObject);
    procedure AddActionExecute(Sender: TObject);
    procedure AlignActionExecute(Sender: TObject);
    procedure HistoryClick(Sender: TObject);
    procedure TabsChange(Sender: TObject);
    procedure XYChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DesignAfterAdd(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DesignSelectionChange(Sender: TObject);
    procedure DesignAfterDelPage(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure DesignDblClickObject(Sender: TObject; AObject: TDFObject);
    procedure EngineChange(Sender: TObject; AObject: TDFStream;
      const IsLoading: Boolean);
    procedure EngineDimChange(Sender: TObject; AObject: TDFStream;
      const IsLoading: Boolean);
  private
    OpenFile: String;
    Initialized, IDEmode: boolean;
    procedure UpdateHistory(const Filename: String);
    procedure UpdateTabs;
    procedure UpdateStatus;
    procedure RegisterExtensions;
    procedure ProcessCommandLine;
    procedure LoadPermDefaults(const Filename: AnsiString);
    procedure SavePermDefaults(const Filename: AnsiString);
  public
    DesignVars: TStrings;
    function Execute(FormData: TDFEngine; const Show: boolean): boolean;
  end;

var
  fmDFDesigner: TfmDFDesigner;

implementation

{$R *.DFM}


{*********************}
{  Events & Actions   }
{*********************}

procedure TfmDFDesigner.FormCreate(Sender: TObject);
var
  I: integer;
begin
  { objects }
  DesignVars:= TStringList.create;
  DesignVars.LoadFromFile(dfGetPath+'designer.dat');
  { default settings }
  if (DesignVars.Values['register'] <> 'N') then RegisterExtensions;
  Initialized:= false;
  IDEmode:= false;
  Width := 640;
  Height := 480;
  Caption := DesignVars.Values['designer_name'] + ' ' + inttostr(DF_MAJOR_VER);
  haHomePage.Caption := DesignVars.Values['company_name'] + ' &Home Page';
  haAbout.Caption := 'About ' + DesignVars.Values['designer_name'];
  Engine.IsDesigner:= true;
  Design.Center:= true;
  OpenDialog1.Filter:= FILETYPES_OPEN;
  SaveDialog1.Filter:= FILETYPES_SAVE;

  { create object inspector form }
  dlDFInspector:= TdlDFInspector.create(self);
  dlDFEditors:= TdlDFEditors.create(self);

  dlDFInspector.left:= 0;
  dlDFInspector.top:= 0;

  { default new form }
  faNew.Execute;

  {init printer to get default margins}
  Engine.PrintInit(Design.Page);

  { load settings }
  if (DesignVars.Values['maximize'] = 'Y') or (Screen.Width = 640) then WindowState := wsMaximized;
  if (DesignVars.Values['maintoolbar'] = 'N') then vaMainToolbar.Execute;
  if (DesignVars.Values['objecttoolbar'] = 'N') then vaObjectToolbar.Execute;
  if (DesignVars.Values['aligntoolbar'] = 'N') then vaAlignToolbar.Execute;
  if (DesignVars.Values['statusbar'] = 'N') then vaStatusBar.Execute;
  if (DesignVars.Values['buttoncaptions'] = 'N') then vaButtonCaptions.Execute;
  if (DesignVars.Values['sidetoolbars'] = 'N') then vaSideToolbars.Execute;
  if (DesignVars.Values['bottomtabs'] = 'N') then vaBottomTabs.Execute;
  if (DesignVars.Values['centered'] = 'N') then vaCentered.Execute;
  if (DesignVars.Values['rulers'] = 'N') then vaRulers.Execute;
  if (DesignVars.Values['margins'] = 'N') then vaMargins.Execute;
  if (DesignVars.Values['form'] = 'N') then vaForm.Execute;
  if (DesignVars.Values['fields'] = 'N') then vaFields.Execute;
  if (DesignVars.Values['background'] = 'N') then vaBackgrounds.Execute;
  if (DesignVars.Values['units'] = 'IN') then vaInches.Execute;
  if (DesignVars.Values['units'] = 'CM') then vaCM.Execute;
  if (DesignVars.Values['units'] = 'PX') then vaPixels.Execute;
  if (DesignVars.Values['zoom'] = 'PW') then zaPW.Execute;
  if (DesignVars.Values['zoom'] = 'PH') then zaPH.Execute;
  if (DesignVars.Values['zoom'] = '200') then za200.Execute;
  if (DesignVars.Values['zoom'] = '150') then za150.Execute;
  if (DesignVars.Values['zoom'] = '100') then za100.Execute;
  if (DesignVars.Values['zoom'] = '75') then za75.Execute;
  if (DesignVars.Values['zoom'] = '50') then za50.Execute;

  for I := 0 to 7 do
    PopHistory.Items[I].caption := DesignVars.Values['history'+inttostr(I)];

  { create dynamic sub-menus }
  UpdateHistory('REFRESH');
  dfMergeMenu(PopNew, tmAdd);
  dfMergeMenu(PopNew, pmAdd);
  dfMergeMenu(PopAlign, tmAlign);
  dfMergeMenu(PopAlign, pmAlign);
  dfMergeMenu(PopZoom, zmZoom);

  { update }
  UpdateStatus;
  UpdateTabs;

  Initialized:= true;

  { command line }
  ProcessCommandLine;
end;

function TfmDFDesigner.Execute(FormData: TDFEngine; const Show: boolean): boolean;
begin
  { assign form-data }
  if FormData <> nil then
    Engine.Assign(FormData);
  { show form }
  if Show then
  begin
    IDEMode:= true;
    btnExit.Caption:= 'Close';
    UpdateStatus;
    UpdateTabs;
    result:= ShowModal = mrOK;
    FormData.Assign(Engine);
  end
  else result:= false;
end;

procedure TfmDFDesigner.FormDestroy(Sender: TObject);
var
  I: integer;
begin
  { save custom settings }
  if (WindowState = wsMaximized) and (screen.width > 640) then
    DesignVars.Values['maximize']:= 'Y'
  else
    DesignVars.Values['maximize']:= 'N';

  if vaMainToolbar.Checked then
    DesignVars.Values['maintoolbar']:= 'Y'
  else
    DesignVars.Values['maintoolbar']:= 'N';

  if vaObjectToolbar.Checked then
    DesignVars.Values['objecttoolbar']:= 'Y'
  else
    DesignVars.Values['objecttoolbar']:= 'N';

  if vaAlignToolbar.Checked then
    DesignVars.Values['aligntoolbar']:= 'Y'
  else
    DesignVars.Values['aligntoolbar']:= 'N';

  if vaStatusbar.Checked then
    DesignVars.Values['statusbar']:= 'Y'
  else
    DesignVars.Values['statusbar']:= 'N';

  if vaButtonCaptions.Checked then
    DesignVars.Values['buttoncaptions']:= 'Y'
  else
    DesignVars.Values['buttoncaptions']:= 'N';

  if vaSidetoolbars.Checked then
    DesignVars.Values['sidetoolbars']:= 'Y'
  else
    DesignVars.Values['sidetoolbars']:= 'N';

  if vaBottomtabs.Checked then
    DesignVars.Values['bottomtabs']:= 'Y'
  else
    DesignVars.Values['bottomtabs']:= 'N';

  if vaCentered.Checked then
    DesignVars.Values['centered']:= 'Y'
  else
    DesignVars.Values['centered']:= 'N';

  if vaMainToolbar.Checked then
    DesignVars.Values['maintoolbar']:= 'Y'
  else
    DesignVars.Values['maintoolbar']:= 'N';

  if vaRulers.Checked then
    DesignVars.Values['rulers']:= 'Y'
  else
    DesignVars.Values['rulers']:= 'N';

  if vaMargins.Checked then
    DesignVars.Values['margins']:= 'Y'
  else
    DesignVars.Values['margins']:= 'N';

  if vaForm.Checked then
    DesignVars.Values['form']:= 'Y'
  else
    DesignVars.Values['form']:= 'N';

  if vaFields.Checked then
    DesignVars.Values['fields']:= 'Y'
  else
    DesignVars.Values['fields']:= 'N';

  if vaBackgrounds.Checked then
    DesignVars.Values['backgrounds']:= 'Y'
  else
    DesignVars.Values['backgrounds']:= 'N';


  if vaInches.checked then DesignVars.Values['units']:= 'IN';
  if vaCM.checked then DesignVars.Values['units']:= 'CM';
  if vaPixels.checked then  DesignVars.Values['units']:= 'PX';


  if zaPW.checked then DesignVars.Values['zoom']:= 'PW';
  if zaPH.checked then DesignVars.Values['zoom']:= 'PH';
  if za200.checked then DesignVars.Values['zoom']:= '200';
  if za150.checked then DesignVars.Values['zoom']:= '150';
  if za100.checked then DesignVars.Values['zoom']:= '100';
  if za75.checked then DesignVars.Values['zoom']:= '75';
  if za50.checked then DesignVars.Values['zoom']:= '50';

  for I := 0 to 7 do
    DesignVars.Values['history'+inttostr(I)]:= PopHistory.Items[I].caption;

  { objects }
  DesignVars.SaveToFile(dfGetPath+'designer.dat');
  DesignVars.free;
end;

procedure TfmDFDesigner.FormClose(Sender: TObject; var Action: TCloseAction);
var
  tmpstr: String;
begin
  if IDEMode then Exit;
  if Design.HasChanged then
  begin
    tmpstr:= extractfilename(OpenFile);
    if tmpstr = '' then
      tmpstr:= 'untitled';
    case Messagedlg('Do you want to save changes to "'+tmpstr+'"?', mtConfirmation, [mbYes,mbNo,mbCancel],0) of
      mrYes:
        faSave.Execute;
      mrCancel:
        Action:= caNone;
    end;
  end;
end;

procedure TfmDFDesigner.FormActivate(Sender: TObject);
begin
  kaEscape.enabled:= true;
  kaEnter.enabled:= true;
  kaLeft.enabled:= true;
  kaRight.enabled:= true;
  kaUp.enabled:= true;
  kaDown.enabled:= true;
  eaCut.enabled:= true;
  eaCopy.enabled:= true;
  eaPaste.enabled:= true;
  eaDelete.enabled:= true;
  eaUndelete.enabled:= true;
  eaSelectAll.enabled:= true;
end;

procedure TfmDFDesigner.FormDeactivate(Sender: TObject);
begin
  kaEscape.enabled:= false;
  kaEnter.enabled:= false;  
  kaLeft.enabled:= false;
  kaRight.enabled:= false;
  kaUp.enabled:= false;
  kaDown.enabled:= false;
  eaCut.enabled:= false;
  eaCopy.enabled:= false;
  eaPaste.enabled:= false;
  eaDelete.enabled:= false;
  eaUndelete.enabled:= false;
  eaSelectAll.enabled:= false;
end;

procedure TfmDFDesigner.FileActionExecute(Sender: TObject);
var
  tmpstr: String;
begin
  { Open }
  if Sender = faOpen then
  begin
    if OpenDialog1.Execute then
    begin
      if (Design.PageCount > 1) or (Design.Page.ObjectCount > 0) then faNew.Execute;
      if Design.Page.ObjectCount > 0 then Exit;
      if dfOpenFile(Engine, OpenDialog1.FileName, true) = 0 then
      begin
        UpdateHistory(lowercase(OpenDialog1.FileName));
        Design.UpdateChangeBuffer;
      end else
        raise Exception.Create('Error opening file: '+OpenDialog1.FileName);
    end;
    ZoomActionExecute(nil);
    UpdateStatus;
    UpdateTabs;
  end;

  { New }
  if Sender = faNew then
  begin
    if Design.HasChanged then
    begin
      tmpstr:= extractfilename(OpenFile);
      if tmpstr = '' then
        tmpstr:= 'untitled';
      case Messagedlg('Do you want to save changes to "'+tmpstr+'"?', mtConfirmation, [mbYes,mbNo,mbCancel],0) of
        mrYes:
          begin
            faSave.Execute;
            Exit;
          end;
        mrCancel:
          Exit;
      end;
    end;
    Tabs.TabIndex:= -1;
    Design.ClearSelection;
    Engine.Clear;
    if fileexists(dfGetPath+'defaults.dat') then
      LoadPermDefaults(dfGetPath+'defaults.dat');
    Design.UpdateChangeBuffer;
    UpdateStatus;
    UpdateTabs;
    ZoomActionExecute(nil);
  end;

  { Save }
  if Sender = faSave then
  begin
    if pos('.df', OpenFile) = 0 then
      faSaveAs.Execute
    else begin
      dfSaveFile(Engine, OpenFile);
      Design.UpdateChangeBuffer;
      UpdateStatus;
    end;
  end;

  { SaveAs }
  if Sender = faSaveAs then
  begin
    SaveDialog1.Filename:= dfFilenameOnly(OpenFile);
    if SaveDialog1.Execute then
    begin
      tmpstr:= SaveDialog1.FileName;
      if extractfileext(tmpstr) = '' then
        tmpstr:= tmpstr + dfGetFilter(SaveDialog1.Filter, SaveDialog1.FilterIndex);
      dfSaveFile(Engine, tmpstr);
      Design.UpdateChangeBuffer;
      if pos('.df', tmpstr) <> 0 then
        UpdateHistory(lowercase(tmpstr));
      UpdateStatus;
    end;
  end;

  { Clear History }
  if Sender = faClearHistory then
  begin
    UpdateHistory('CLEAR');
  end;

  { Print }
  if Sender = faPrint then
  begin
    Engine.PrintDesigner:= false;
    Engine.PrintJob:= DesignVars.Values['designer_name'];
    Engine.PrintDialog(Tabs.TabIndex+1, Tabs.TabIndex+1);
  end;

  { Print Designers }
  if Sender = faPrintDesign then
  begin
    Engine.PrintDesigner:= true;
    Engine.PrintJob:= DesignVars.Values['designer_name'];
    Engine.PrintDialog(Tabs.TabIndex+1, Tabs.TabIndex+1);
    Engine.PrintDesigner:= false;
  end;

  { Print Preview }
  if Sender = faPreview then
  begin
    { load preview settings }
    if (DesignVars.Values['pvmaximize'] = 'Y') then
      Engine.PreviewOptions:= Engine.PreviewOptions + [dfMaximized]
    else
      Engine.PreviewOptions:= Engine.PreviewOptions - [dfMaximized];
    if (DesignVars.Values['pvToolbar'] = 'N') then
      Engine.PreviewOptions:= Engine.PreviewOptions - [dfToolbar]
    else
      Engine.PreviewOptions:= Engine.PreviewOptions + [dfToolbar];
    if (DesignVars.Values['pvButtonCaptions'] = 'N') then
      Engine.PreviewOptions:= Engine.PreviewOptions - [dfButtonCaptions]
    else
      Engine.PreviewOptions:= Engine.PreviewOptions + [dfButtonCaptions];
    if (DesignVars.Values['pvPageTabs'] = 'N') then
      Engine.PreviewOptions:= Engine.PreviewOptions - [dfPageTabs]
    else
      Engine.PreviewOptions:= Engine.PreviewOptions + [dfPageTabs];
    if (DesignVars.Values['pvBottomTabs'] = 'N') then
      Engine.PreviewOptions:= Engine.PreviewOptions - [dfBottomTabs]
    else
      Engine.PreviewOptions:= Engine.PreviewOptions + [dfBottomTabs];
    if DesignVars.Values['pvZoom'] <> '' then
      Engine.PreviewZoom:= DesignVars.Values['pvZoom'];

    {show preview}
    Engine.PrintPreview;

    { save preview settings }
    if PreviewMaximized then
      DesignVars.Values['pvmaximize']:= 'Y'
    else
      DesignVars.Values['pvmaximize']:= 'N';
    if dfToolbar in Engine.PreviewOptions then
      DesignVars.Values['pvToolbar']:= 'Y'
    else
      DesignVars.Values['pvToolbar']:= 'N';
    if dfButtonCaptions in Engine.PreviewOptions then
      DesignVars.Values['pvButtonCaptions']:= 'Y'
    else
      DesignVars.Values['pvButtonCaptions']:= 'N';
    if dfPageTabs in Engine.PreviewOptions then
      DesignVars.Values['pvPageTabs']:= 'Y'
    else
      DesignVars.Values['pvPageTabs']:= 'N';
    if dfBottomTabs in Engine.PreviewOptions then
      DesignVars.Values['pvBottomTabs']:= 'Y'
    else
      DesignVars.Values['pvBottomTabs']:= 'N';
    DesignVars.Values['pvZoom'] := Engine.PreviewZoom;
  end;

  { Exit }
  if Sender = faExit then Close;
end;

procedure TfmDFDesigner.EditActionExecute(Sender: TObject);
var
  tmpstr: String;
  MF: TMetafile;
  MS: TMemoryStream;
  SL: TStringList;
  I: integer;
begin
  if (Sender = eaCut) then Design.Cut;
  if (Sender = eaCopy) then Design.Copy;
  if (Sender = eaPaste) then Design.Paste;
  if (Sender = eaDelete) then Design.Delete;
  if (Sender = eaUndelete) then Design.UnDelete;
  if (Sender = eaSelectAll) then Design.SelectAll;
  if Sender = eaSelectAllText then Design.SelectAllText;
  if Sender = eaSelectAllFields then Design.SelectAllFields;
  if Sender = eaSelectTag then
  begin
    tmpstr:= '';
    if Inputquery('Select by Tag Property', 'Enter Tag value', tmpstr) then
    Design.SelectByTag(strtointdef(tmpstr,-1));
  end;
  if Sender = eaCopyForm then Engine.SaveToClipBoard;
  if Sender = eaPasteForm then
  begin
    if (Design.PageCount > 1) or (Design.Page.ObjectCount > 0) then faNew.Execute;
    if Design.Page.ObjectCount > 0 then Exit;
    Engine.LoadFromClipBoard;
    ZoomActionExecute(nil);
    UpdateStatus;
    UpdateTabs;
    Design.RefreshForm;
    Design.UpdateChangeBuffer;
  end;
  if Sender = eaCopyPage then Design.Page.SaveToClipBoard;
  if Sender = eaPastePage then
  begin
    adaAddPage.Execute;
    Design.Page.LoadFromClipBoard;
    Design.RefreshForm;
    ZoomActionExecute(nil);
  end;

  if (Sender = eaCopyLinks) then Design.CopyLinks;
  if (Sender = eaPastelinks) then Design.PasteLinks;

  if Sender = eaPasteWord then
  begin
    MF:= TMetafile.create;
    MS:= TMemoryStream.create;
    try
      Clipboard.Open;
      MF.LoadFromClipboardFormat(CF_METAFILEPICT, Clipboard.GetAsHandle(CF_METAFILEPICT), 0);
      Clipboard.Close;
      MF.savetostream(MS);
      MS.seek(0,0);
      dfImportEMF(Engine, MS, -1);
    finally
      MS.free;
      MF.free;
    end;
  end;

  if (Sender = eaCopyFieldList) then
  begin
    SL:= TStringList.create;
    try
      for I:= 0 to Engine.FieldCount-1 do
        SL.add(Engine.Fields[I].fieldname);
      Clipboard.AsText:= SL.Text;
    finally
      SL.free;
    end;
  end;

  if (Sender = eaFind) then
  begin
    tmpstr:= '';
    if inputquery('Find fields or text...', 'Enter Search Text', tmpstr) then
    begin
      Design.ClearSelection;
      for I:= 0 to Design.Page.FieldCount-1 do
        if pos(lowercase(tmpstr), lowercase(Design.Page.Fields[I].fieldname))>0 then
          Design.AddSelection(Engine.Fields[I]);
      for I:= 0 to Design.Page.TextCount-1 do
        if pos(lowercase(tmpstr), lowercase(Design.Page.Text[I].text))>0 then
          Design.AddSelection(Design.Page.Text[I]);
    end;
  end;
end;

procedure TfmDFDesigner.ViewActionExecute(Sender: TObject);
var
  tmpstr: String;
begin
  { checkmark view options }
  if (Sender as TAction).Tag = 1 then
    (Sender as TAction).Checked := not (Sender as TAction).Checked;

  { uncheck radio-items }
  vaInches.checked:= false;
  vaCM.checked:= false;
  vaPixels.checked:= false;

  if (Sender as TAction).Tag = 2 then
    (Sender as TAction).Checked := true;

  if Sender = vaButtonCaptions then
  begin
    ToolbarMain.ShowCaptions := vaButtonCaptions.checked;
    ToolbarMain.ButtonHeight := 0;
    ToolbarMain.ButtonWidth := 0;
  end;

  if Sender = vaSideToolbars then
  begin
    if vaSideToolbars.checked then
    begin
      CoolBarMain.RemoveControl(ToolbarAdd);
      CoolBarLeft.InsertControl(ToolbarAdd);
      CoolBarMain.RemoveControl(ToolbarAlign);
      CoolBarRight.InsertControl(ToolbarAlign);
      ToolbarAdd.Align := alLeft;
      ToolbarAlign.Align := alRight;
      CoolBarLeft.Visible := vaObjectToolbar.checked;
      CoolBarRight.Visible := vaAlignToolbar.checked;
    end
    else begin
      CoolBarLeft.Visible := false;
      CoolBarRight.Visible := false;
      CoolBarLeft.RemoveControl(ToolbarAdd);
      CoolBarMain.InsertControl(ToolbarAdd);
      CoolBarRight.RemoveControl(ToolbarAlign);
      CoolBarMain.InsertControl(ToolbarAlign);
      ToolbarAdd.Align := alTop;
      ToolbarAlign.Align := alTop;
      vaObjectToolbar.checked:= true;
      vaAlignToolbar.checked:= true;
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

  if Sender = vaObjectToolbar then
  begin
    ToolbarAdd.visible:= vaObjectToolbar.checked;
    CoolBarLeft.visible:= vaObjectToolbar.checked;
  end;

  if Sender = vaAlignToolbar then
  begin
    ToolbarAlign.visible:= vaObjectToolbar.checked;
    CoolBarRight.visible:= vaObjectToolbar.checked;
  end;

  if Sender = vaStatusbar then
  begin
    Status.visible:= vaStatusbar.checked;
  end;


  { guides }
  if Sender = vaCentered then
  begin
    Design.Center:= vaCentered.checked;
  end;

  if Sender = vaRulers then
  begin
    if vaRulers.checked then
      Engine.PaintOptions:= Engine.PaintOptions + [dfShowRulers]
    else
      Engine.PaintOptions:= Engine.PaintOptions - [dfShowRulers];
    Design.RefreshForm;
  end;

  if Sender = vaMargins then
  begin
    if vaMargins.checked then
      Engine.PaintOptions:= Engine.PaintOptions + [dfShowMargins]
    else
      Engine.PaintOptions:= Engine.PaintOptions - [dfShowMargins];
    Design.RefreshForm;
  end;

  if Sender = vaForm then
  begin
    if vaForm.checked then
      Engine.PaintOptions:= Engine.PaintOptions + [dfShowForm]
    else
      Engine.PaintOptions:= Engine.PaintOptions - [dfShowForm];
    Design.RefreshForm;
  end;

  if Sender = vaFields then
  begin
    if vaFields.checked then
      Engine.PaintOptions:= Engine.PaintOptions + [dfShowFields]
    else
      Engine.PaintOptions:= Engine.PaintOptions - [dfShowFields];
    Design.RefreshForm;
  end;

  if Sender = vaBackgrounds then
  begin
    if vaBackgrounds.checked then
      Engine.PaintOptions:= Engine.PaintOptions + [dfShowBackground]
    else
      Engine.PaintOptions:= Engine.PaintOptions - [dfShowBackground];
    Design.RefreshForm;
  end;

  { ruler units }
  if Sender = vaInches then
  begin
    Engine.RulerUnits:= dfInches;
    Design.RefreshForm;
    UpdateStatus;
  end;

  if Sender = vaCM then
  begin
    Engine.RulerUnits:= dfCentimeters;
    Design.RefreshForm;
    UpdateStatus;
  end;

  if Sender = vaPixels then
  begin
    Engine.RulerUnits:= dfPixels;
    Design.RefreshForm;
    UpdateStatus;
  end;


  { pixels per inch }
  if Sender = vaChangePPI then
  begin
    tmpstr:= inttostr(Engine.Form.PixelsPerInch);
    if Inputquery('Change PixelsPerInch', 'Enter new value', tmpstr) then
      Engine.Form.PixelsPerInch:= strtointdef(tmpstr,Engine.Form.PixelsPerInch);
    Design.RefreshForm;
  end;


  { refresh }
  if Sender = vaRefresh then
  begin
    Design.RefreshForm;
  end;

  { properties }
  if Sender = vaProperties then
  begin
    if dlDFInspector.left = 0 then
    begin
      dlDFInspector.left:= Scrollbox.ClientOrigin.X;
      dlDFInspector.top:= Scrollbox.ClientOrigin.Y;
      dlDFInspector.height:= ScrollBox.Height - (GetSystemMetrics(SM_CXHSCROLL) + 4);
      dlDFInspector.width:= 200;
    end;
    if dlDFInspector.Visible then
    begin
      dlDFInspector.hide;
      FormActivate(nil);
    end
    else begin
      if Design.Selections.count = 0 then
        if Design.Page <> nil then
          Design.SelectPage;
      dlDFInspector.show;
      FormDeactivate(nil);      
    end;
  end;

  if Sender = vaPageProp then
  begin
    Design.SelectPage;
  end;

  if Sender = vaFormProp then
  begin
    Design.SelectForm;
  end;
end;

procedure TfmDFDesigner.ZoomActionExecute(Sender: TObject);

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
  if zaPW.checked then Design.AlignToScrollBox(Scrollbox, 'PW');
  if zaPH.checked then Design.AlignToScrollBox(Scrollbox, 'PH');
  if za200.checked then Design.AlignToScrollBox(Scrollbox, 200);
  if za150.checked then Design.AlignToScrollBox(Scrollbox, 150);
  if za100.checked then Design.AlignToScrollBox(Scrollbox, 100);
  if za75.checked then Design.AlignToScrollBox(Scrollbox, 75);
  if za50.checked then Design.AlignToScrollBox(Scrollbox, 50);
end;

procedure TfmDFDesigner.ToolsActionExecute(Sender: TObject);
var
  tmpstr: String;
  Flag: boolean;
begin
  if Sender = taScale then
  begin
    tmpstr:= '100';
    if Inputquery('Scale Selection', 'Enter percentage', tmpstr) then
      Design.ScaleSelection(strtofloat(tmpstr));
  end;
  if Sender = taInvert then
  begin
    Design.InvertSelection;
  end;
  if Sender = taOptimize then
  begin
    Design.Optimize;
    MessageDlg('Form has been optimized.', mtInformation, [mbOK],0);
  end;
  if Sender = taResetStorage then
  begin
    Engine.ResetFieldStore;
    MessageDlg('Field store properties reset.  Only active fields will be stored.', mtInformation, [mbOK],0);
  end;
  if Sender = taClearFields then
  begin
    Engine.ClearFields;
    MessageDlg('Field data has been cleared.', mtInformation, [mbOK],0);
  end;

  if Sender = taSavePermDefaults then
  begin
    SavePermDefaults(dfGetPath+'defaults.dat');
    MessageDlg('Defaults have been saved.', mtInformation, [mbOK],0);
  end;

  if (Sender as TAction).tag = 5 then
    if not dlDFInspector.visible then
      vaProperties.Execute;

  if Sender = taDefaultLine then   Design.SelectDefaultObject(TDFDefaultLine);
  if Sender = taDefaultFrame then  Design.SelectDefaultObject(TDFDefaultFrame);
  if Sender = taDefaultLogo then   Design.SelectDefaultObject(TDFDefaultLogo);
  if Sender = taDefaultButton then Design.SelectDefaultObject(TDFDefaultButton);
  if Sender = taDefaultText then   Design.SelectDefaultObject(TDFDefaultText);
  if Sender = taDefaultField then  Design.SelectDefaultObject(TDFDefaultField);

  if Sender = taTabOrder then
  begin
    dlDFEditors.Pages.ActivePage:= dlDFEditors.Tabs_Page;
    dlDFEditors.Tabs_Design:= Design;
    dlDFEditors.Tabs_Fill(TABS_FILL_TABORDER);
    if dlDFEditors.Showmodal = mrOK then
      dlDFEditors.Update_Tabs;
  end;

  if Sender = taLinkEditor then
  begin
    if (Design.Selections.count > 0) and (TObject(Design.Selections[0]) is TDFField) then
    begin
      //single link editor
      Flag:= false;
      dldfInspector.ObjectInspectorInvokeCustomEditor(dldfInspector.ObjectInspector,
        'FieldLink', 'AnsiString', Design.Selections, Flag);
    end
    else begin
      //multi link editor
      dlLinkEditor:= TdlLinkEditor.create(self);
      try
        dlLinkEditor.Execute;
      finally
        dlLinkEditor.free;
      end;
    end;
  end;
end;

procedure TfmDFDesigner.AddActionExecute(Sender: TObject);
begin
  if Sender = adaAddPage then
  begin
    Engine.AddPage;
    UpdateStatus;
    UpdateTabs;
    Tabs.TabIndex:= Tabs.Tabs.Count-1;
    TabsChange(nil);
    ZoomActionExecute(nil);
  end;

  if Sender = adaCancelAdd then
  begin
    Design.Cursor:= crDefault;
    Design.AddClass:= nil;
  end;

  if Sender = adaAddLine then
  begin
    Design.Cursor:= crDrag;
    Design.AddClass:= TDFLine;
  end;

  if Sender = adaAddFrame then
  begin
    Design.Cursor:= crDrag;
    Design.AddClass:= TDFFrame;
  end;

  if Sender = adaAddLogo then
  begin
    Design.Cursor:= crDrag;
    Design.AddClass:= TDFLogo;
  end;

  if Sender = adaAddButton then
  begin
    Design.Cursor:= crDrag;
    Design.AddClass:= TDFButton;
  end;

  if Sender = adaAddText then
  begin
    Design.Cursor:= crDrag;
    Design.AddClass:= TDFText;
  end;

  if Sender = adaAddField then
  begin
    Design.Cursor:= crDrag;
    Design.AddClass:= TDFField;
  end;
end;

procedure TfmDFDesigner.AlignActionExecute(Sender: TObject);
begin
  if Sender = aaLeftEdges then     Design.AlignLeftEdges;
  if Sender = aaRightEdges then    Design.AlignRightEdges;
  if Sender = aaTopEdges then      Design.AlignTopEdges;
  if Sender = aaBottomEdges then   Design.AlignBottomEdges;
  if Sender = aaSpaceHoriz then    Design.AlignSpaceHoriz;
  if Sender = aaSpaceVert then     Design.AlignSpaceVert;
  if Sender = aaSnapGrid then      Design.AlignSnapGrid;
  if Sender = aaBringFront then    Design.AlignBringFront;
  if Sender = aaSendBack then      Design.AlignSendBack;
  if Sender = aaAlignPage then     Design.AlignToPage;
  if Sender = aaCenterHoriz then   Design.AlignCenterHoriz;
  if Sender = aaCenterVert then    Design.AlignCenterVert;
end;

procedure TfmDFDesigner.HelpActionExecute(Sender: TObject);
var
  tmpstr: String;
begin
  { Help Contents }
  if Sender = haHelpContents then
  begin
    Application.HelpFile := dfGetPath+'designer.hlp';
    Application.HelpJump('');
  end;

  { Home Page }
  if Sender = haHomePage then
  begin
    ShellExecute(0, 'open', PChar(DesignVars.Values['company_www']), nil, nil, SW_SHOW);
  end;

  { About }
  if Sender = haAbout then
  begin
    { ***** DO NOT MODIFY THIS AREA ***** }
    tmpstr := DesignVars.Values['designer_name']+#13#13+'Version: '+DF_STRING_VER;
    if DesignVars.Values['designer_name'] <> 'Defined Forms' then
      tmpstr := tmpstr + #13#13 + 'Licensed to '+DesignVars.Values['company_name'];
    tmpstr := tmpstr +#13#13+'Copyright 1997-2001 Defined Systems'+#13+'www.defined.net';
    MessageDlg(tmpstr, mtInformation, [mbOK],0);
  end;
end;

procedure TfmDFDesigner.KeyActionExecute(Sender: TObject);
begin
  if Sender = kaCtrlLeft then Design.MoveSelection(-1,0);
  if Sender = kaCtrlRight then Design.MoveSelection(1,0);
  if Sender = kaCtrlUp then Design.MoveSelection(0,-1);
  if Sender = kaCtrlDown then Design.MoveSelection(0,1);
  if Sender = kaShiftLeft then Design.SizeSelection(-1,0);
  if Sender = kaShiftRight then Design.SizeSelection(1,0);
  if Sender = kaShiftUp then Design.SizeSelection(0,-1);
  if Sender = kaShiftDown then Design.SizeSelection(0,1);
  if Sender = kaShiftCtrlLeft then Design.MoveSelection(-8,0);
  if Sender = kaShiftCtrlRight then Design.MoveSelection(8,0);
  if Sender = kaShiftCtrlUp then Design.MoveSelection(0,-8);
  if Sender = kaShiftCtrlDown then Design.MoveSelection(0,8);

  if (Sender = kaLeft) then Design.SelectPrior;
  if (Sender = kaRight) then Design.SelectNext;
  if (Sender = kaUp) then Design.SelectPrior;
  if (Sender = kaDown) then Design.SelectNext;

  if (Sender = kaToggle) then
  begin
    if not dlDFInspector.visible then
     btnProperties.click
    else begin
      if dlDFInspector.Focused then
        fmDFDesigner.setfocus
      else
        dlDFInspector.setfocus;
    end;
  end;
  if (Sender = kaEnter) then
  begin
    if not dlDFInspector.Visible then
      vaProperties.Execute;
    dlDFInspector.ObjectInspector.SetFocus;
    dlDFInspector.ObjectInspector.ActivateCurrent;
  end;
  if Sender = kaAdd then PopNew.popup(Scrollbox.ClientOrigin.X, Scrollbox.ClientOrigin.Y);
  if (Sender = kaEscape) then
  begin
    if Design.IsObjectSelected then
      Design.SelectPage
    else
      Design.SelectForm;
  end;
end;

procedure TfmDFDesigner.HistoryClick(Sender: TObject);
begin
  if (Design.PageCount > 1) or (Design.Page.ObjectCount > 0) then faNew.Execute;
  if Design.Page.ObjectCount > 0 then Exit;
  dfOpenFile( Engine, (Sender as TMenuItem).Caption, true );
  UpdateHistory( (Sender as TMenuItem).Caption );
  Design.UpdateChangeBuffer;
  ZoomActionExecute(nil);
  UpdateStatus;
  UpdateTabs;
end;

procedure TfmDFDesigner.TabsChange(Sender: TObject);
begin
  Design.PageIndex:= Tabs.TabIndex;
  UpdateStatus;
end;

procedure TfmDFDesigner.XYChange(Sender: TObject);
var
  x,y: double;
begin
  { inches }
  if Engine.RulerUnits = dfInches then
  begin
    x:= Design.mouseX / Engine.Form.PixelsPerInch;
    y:= Design.mouseY / Engine.Form.PixelsPerInch;
    Status.Panels[4].Text:= floattostrf(X, ffFixed,8,2)+', '+floattostrf(Y, ffFixed,8,2)+' IN';
  end;

  { centimeters }
  if Engine.RulerUnits = dfCentimeters then
  begin
    x:= Design.mouseX / (Engine.Form.PixelsPerInch * 0.397);
    y:= Design.mouseY / (Engine.Form.PixelsPerInch * 0.397);
    Status.Panels[4].Text:= floattostrf(X, ffFixed,8,2)+', '+floattostrf(Y, ffFixed,8,2)+' CM';
  end;

  { pixels }
  if Engine.RulerUnits = dfPixels then
  begin
    Status.Panels[4].Text:= inttostr(Design.mouseX)+', '+inttostr(Design.mouseY)+' PX';
  end;
end;

procedure TfmDFDesigner.FormResize(Sender: TObject);
begin
  ZoomActionExecute(nil);
end;

procedure TfmDFDesigner.DesignAfterAdd(Sender: TObject);
begin
  if Design.AddClass = nil then
    btnArrow.down:= true;
  DesignSelectionChange(nil);
end;

procedure TfmDFDesigner.DesignAfterDelPage(Sender: TObject);
begin
  UpdateStatus;
  UpdateTabs;
  Tabs.TabIndex:= 0;
  TabsChange(nil);
end;

procedure TfmDFDesigner.DesignSelectionChange(Sender: TObject);
begin
  if not Initialized then Exit;
  dlDFInspector.ObjPan.caption:= '';
  dlDFInspector.ObjectInspector.ObjectList.Clear;
  Design.AssignSelection(dlDFInspector.ObjectInspector.ObjectList);
  if dlDFInspector.ObjectInspector.ObjectList.count = 1 then
    dlDFInspector.ObjPan.caption:= TObject(dlDFInspector.ObjectInspector.ObjectList[0]).Classname;
  if dlDFInspector.ObjectInspector.ObjectList.count > 1 then
    dlDFInspector.ObjPan.caption:= '(multiple selections)';
  dlDFInspector.ObjectInspector.RefreshProperties;
  UpdateStatus;
end;

procedure TfmDFDesigner.DesignDblClickObject(Sender: TObject; AObject: TDFObject);
var
  selsame: boolean;
  x: integer;
begin
  if Design.Selections.count = 0 then Exit;
  selsame:= true;
  for x:= 0 to Design.Selections.count-1 do
    if TObject(Design.Selections[x]).classname <> TObject(Design.Selections[0]).classname then
      selsame:= false;
  if not selsame then Exit;

  if TObject(Design.Selections[0]) is TDFLogo then
    dlDFInspector.ObjectInspector.InvokeEditor('Picture');

  if TObject(Design.Selections[0]) is TDFText then
    dlDFInspector.ObjectInspector.InvokeEditor('Text');

  if TObject(Design.Selections[0]) is TDFField then
    dlDFInspector.ObjectInspector.InvokeEditor('Fieldname');

  PostMessage(Design.handle, WM_ABORTDRAG, 0, 0);
end;

procedure TfmDFDesigner.EngineChange(Sender: TObject; AObject: TDFStream; const IsLoading: Boolean);
begin
  if IsLoading then Exit;
  if Design.Selections.count = 0 then Exit;
  dlDFInspector.ObjectInspector.UpdateProperties;
end;

procedure TfmDFDesigner.EngineDimChange(Sender: TObject;
  AObject: TDFStream; const IsLoading: Boolean);
begin
  if IsLoading then Exit;
  ZoomActionExecute(nil);
end;

{*********************}
{  Support Functions  }
{*********************}

procedure TfmDFDesigner.UpdateHistory(const Filename: String);
var
  I: integer;
  flag: boolean;
begin
  { Add filename to history list if new }
  if Filename = 'CLEAR' then
  begin
    for I := 0 to 7 do
      PopHistory.Items[I].caption := '';
  end
  else if Filename <> 'REFRESH' then
  begin
    OpenFile:= Filename;
    flag := false;
    for I := 0 to 7 do
      if PopHistory.Items[I].caption = Filename then
      begin
        flag := true;
        break;
      end;
    if flag then
      PopHistory.Items[I].MenuIndex := 0
    else begin
      PopHistory.Items[7].MenuIndex := 0;
      PopHistory.Items[0].Caption := Filename;
    end;
  end;

  { Update all history menus }
  for I := 0 to 7 do
  begin
    if not fileexists(PopHistory.Items[I].caption) then
      PopHistory.Items[I].caption := '';
    if PopHistory.Items[I].caption <> '' then
      PopHistory.Items[I].visible := true
    else
      PopHistory.Items[I].visible := false;
  end;

  dfMergeMenu(PopHistory, fmReOpen);
end;

procedure TfmDFDesigner.UpdateTabs;
var
  I: integer;
begin
  while Tabs.Tabs.Count < Engine.PageCount do
    Tabs.Tabs.add('NEW');
  while Tabs.Tabs.Count > Engine.PageCount do
    Tabs.Tabs.Delete(0);
  for I:= 0 to Engine.PageCount-1 do
    Tabs.Tabs[i]:= Engine.Pages[I].PageName;
  if Tabs.Tabindex = -1 then
  begin
    Tabs.Tabindex:= 0;
    Design.PageIndex:= 0;
  end;
end;

procedure TfmDFDesigner.UpdateStatus;
begin
  Status.Panels[0].Text:= Openfile;
  if Design.Page <> nil then
    Status.Panels[1].Text:= inttostr(Design.Page.ComponentCount)+' objects'
  else
    Status.Panels[1].Text:= '';
  Status.Panels[2].Text:= inttostr(Design.Selections.count)+' selected';
  if (Design.Page = nil) or ((Design.PageCount = 1) and (Design.Page.ObjectCount = 0)) then
    Status.Panels[3].Text:= '0 bytes'
  else
    Status.Panels[3].Text:= inttostr(Design.BufferSize)+' bytes';
  XYChange(nil);
end;

procedure TfmDFDesigner.RegisterExtensions;
var Reg1: TRegistry;
begin
  Reg1:= nil;
  try
    Reg1:= TRegistry.Create;

    {HKEY_CLASSES_ROOT}
    Reg1.RootKey:= HKEY_CLASSES_ROOT;
    Reg1.OpenKey('.dfb', true);
    Reg1.WriteString('','dfb_auto_file');
    Reg1.CloseKey;
    Reg1.RootKey:= HKEY_CLASSES_ROOT;
    Reg1.OpenKey('dfb_auto_file', true);
    Reg1.WriteString('','Defined Form Binary');
    Reg1.OpenKey('shell', true);
    Reg1.OpenKey('open', true);
    Reg1.WriteString('','');
    Reg1.OpenKey('command', true);
    Reg1.WriteString('',paramstr(0)+' "%1"');
    Reg1.CloseKey;

    Reg1.RootKey:= HKEY_CLASSES_ROOT;
    Reg1.OpenKey('.dft', true);
    Reg1.WriteString('','dft_auto_file');
    Reg1.CloseKey;
    Reg1.RootKey:= HKEY_CLASSES_ROOT;
    Reg1.OpenKey('dft_auto_file', true);
    Reg1.WriteString('','Defined Form Text');
    Reg1.OpenKey('shell', true);
    Reg1.OpenKey('open', true);
    Reg1.WriteString('','');
    Reg1.OpenKey('command', true);
    Reg1.WriteString('',paramstr(0)+' "%1"');
    Reg1.CloseKey;

    Reg1.RootKey:= HKEY_CLASSES_ROOT;
    Reg1.OpenKey('.dfx', true);
    Reg1.WriteString('','dft_auto_file');
    Reg1.CloseKey;
    Reg1.RootKey:= HKEY_CLASSES_ROOT;
    Reg1.OpenKey('dft_auto_file', true);
    Reg1.WriteString('','Defined Form XML');
    Reg1.OpenKey('shell', true);
    Reg1.OpenKey('open', true);
    Reg1.WriteString('','');
    Reg1.OpenKey('command', true);
    Reg1.WriteString('',paramstr(0)+' "%1"');
    Reg1.CloseKey;

    {HKEY_LOCAL_MACHINE}
    Reg1.RootKey:= HKEY_LOCAL_MACHINE;
    Reg1.OpenKey('Software', true);
    Reg1.OpenKey('Classes', true);
    Reg1.OpenKey('.dfb', true);
    Reg1.WriteString('','dfb_auto_file');
    Reg1.CloseKey;
    Reg1.RootKey:= HKEY_LOCAL_MACHINE;
    Reg1.OpenKey('Software', true);
    Reg1.OpenKey('Classes', true);
    Reg1.OpenKey('dfb_auto_file', true);
    Reg1.WriteString('','Defined Form Binary');
    Reg1.OpenKey('shell', true);
    Reg1.OpenKey('open', true);
    Reg1.WriteString('','');
    Reg1.OpenKey('command', true);
    Reg1.WriteString('',paramstr(0)+' "%1"');
    Reg1.CloseKey;

    Reg1.RootKey:= HKEY_LOCAL_MACHINE;
    Reg1.OpenKey('Software', true);
    Reg1.OpenKey('Classes', true);
    Reg1.OpenKey('.dft', true);
    Reg1.WriteString('','dft_auto_file');
    Reg1.CloseKey;
    Reg1.RootKey:= HKEY_LOCAL_MACHINE;
    Reg1.OpenKey('Software', true);
    Reg1.OpenKey('Classes', true);
    Reg1.OpenKey('dft_auto_file', true);
    Reg1.WriteString('','Defined Form Text');
    Reg1.OpenKey('shell', true);
    Reg1.OpenKey('open', true);
    Reg1.WriteString('','');
    Reg1.OpenKey('command', true);
    Reg1.WriteString('',paramstr(0)+' "%1"');
    Reg1.CloseKey;

    Reg1.RootKey:= HKEY_LOCAL_MACHINE;
    Reg1.OpenKey('Software', true);
    Reg1.OpenKey('Classes', true);
    Reg1.OpenKey('.dfx', true);
    Reg1.WriteString('','dft_auto_file');
    Reg1.CloseKey;
    Reg1.RootKey:= HKEY_LOCAL_MACHINE;
    Reg1.OpenKey('Software', true);
    Reg1.OpenKey('Classes', true);
    Reg1.OpenKey('dft_auto_file', true);
    Reg1.WriteString('','Defined Form XML');
    Reg1.OpenKey('shell', true);
    Reg1.OpenKey('open', true);
    Reg1.WriteString('','');
    Reg1.OpenKey('command', true);
    Reg1.WriteString('',paramstr(0)+' "%1"');
    Reg1.CloseKey;

  finally
    Reg1.free;
  end;
end;

procedure TfmDFDesigner.ProcessCommandLine;
begin
  if ParamCount > 0 then
  begin
    if dfOpenFile(Engine, ParamStr(1), true) = 0 then
    begin
      UpdateHistory(lowercase(ParamStr(1)));
      Design.UpdateChangeBuffer;
    end else
      raise Exception.Create('Error opening command-line file: '+ParamStr(1));
    ZoomActionExecute(nil);
    UpdateStatus;
    UpdateTabs;
  end;
end;

procedure TfmDFDesigner.SavePermDefaults(const Filename: AnsiString);
var
  SL1,SL2: TStringList;
begin
  SL1:= TStringList.create;
  SL2:= TStringList.create;
  try
    Engine.Form.DefaultLine.savetostrings(SL1);
    SL2.AddStrings(SL1);
    Engine.Form.DefaultFrame.savetostrings(SL1);
    SL2.AddStrings(SL1);
    Engine.Form.DefaultLogo.savetostrings(SL1);
    SL2.AddStrings(SL1);
    Engine.Form.DefaultButton.savetostrings(SL1);
    SL2.AddStrings(SL1);
    Engine.Form.DefaultText.savetostrings(SL1);
    SL2.AddStrings(SL1);
    Engine.Form.DefaultField.savetostrings(SL1);
    SL2.AddStrings(SL1);
    SL2.savetofile(Filename);
  finally
    SL1.free;
    SL2.free;
  end;
end;

procedure TfmDFDesigner.LoadPermDefaults(const Filename: AnsiString);
var
  SL1,SL2: TStringList;
  I,J: integer;
begin
  SL1:= TStringList.create;
  SL2:= TStringList.create;
  try
    SL1.loadfromfile(Filename);
    for I:= 0 to SL1.count-1 do
    begin
      SL2.clear;
      if pos('TDFDefaultLine', SL1[I])>0 then
      begin
        for J:= I to SL1.count-1 do
        begin
          SL2.Add(SL1[J]);
          if SL1[J] = 'end' then
          begin
            Engine.Form.DefaultLine.loadfromstrings(SL2);
            break;
          end;
        end;
      end;

      if pos('TDFDefaultFrame', SL1[I])>0 then
      begin
        for J:= I to SL1.count-1 do
        begin
          SL2.Add(SL1[J]);
          if SL1[J] = 'end' then
          begin
            Engine.Form.DefaultFrame.loadfromstrings(SL2);
            break;
          end;
        end;
      end;

      if pos('TDFDefaultLogo', SL1[I])>0 then
      begin
        for J:= I to SL1.count-1 do
        begin
          SL2.Add(SL1[J]);
          if SL1[J] = 'end' then
          begin
            Engine.Form.DefaultLogo.loadfromstrings(SL2);
            break;
          end;
        end;
      end;

      if pos('TDFDefaultButton', SL1[I])>0 then
      begin
        for J:= I to SL1.count-1 do
        begin
          SL2.Add(SL1[J]);
          if SL1[J] = 'end' then
          begin
            Engine.Form.DefaultButton.loadfromstrings(SL2);
            break;
          end;
        end;
      end;

      if pos('TDFDefaultText', SL1[I])>0 then
      begin
        for J:= I to SL1.count-1 do
        begin
          SL2.Add(SL1[J]);
          if SL1[J] = 'end' then
          begin
            Engine.Form.DefaultText.loadfromstrings(SL2);
            break;
          end;
        end;
      end;

      if pos('TDFDefaultField', SL1[I])>0 then
      begin
        for J:= I to SL1.count-1 do
        begin
          SL2.Add(SL1[J]);
          if SL1[J] = 'end' then
          begin
            Engine.Form.DefaultField.loadfromstrings(SL2);
            break;
          end;
        end;
      end;
    end;

  finally
    SL1.free;
    SL2.free;
  end;
end;

end.
