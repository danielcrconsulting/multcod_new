
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Form Engine and Support Classes                 }
{                                                       }
{       Copyright (c) 2001 Defined Systems Inc.         }
{                                                       }
{       Version 6                                       }
{                                                       }
{*******************************************************}

{ 11/11/2002 V6.2.0 Added Delphi 7 Support              }

unit dfclasses;

interface

{$I DEFINEDFORMS.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Clipbrd, Printers, jpeg, db, typinfo, defstream
  {$IFDEF EXPRESSIONS},dfparser{$ENDIF};

const
  DF_MAJOR_VER = 6;
  DF_MINOR_VER = 2.0;
  DF_STRING_VER = '6.2.0';
  DEFAULT_PPI = 96;
  LINE_THRESH = 0.249;

  FILETYPES_OPEN =  'All Form Files|*.dfb;*.dft;*.dfx;*.xml;*.rfm;*.emf;*.wmf|'+
                    'Defined Form Binary (*.dfb)|*.dfb|'+
                    'Defined Form Text (*.dft)|*.dft|'+
                    'Defined Form XML  (*.dfx)|*.dfx|'+
                    'Defined Form Data (*.dfd)|*.dfd|'+
                    'Real Form Legacy (*.rfm)|*.rfm|'+
                    'Enhanced Metafile (*.emf)|*.emf|'+
                    'Windows Metafile (*.wmf)|*.wmf|'+
                    'XML (*.xml)|*.xml|'+
                    'All Files (*.*)|*.*';

  FILETYPES_SAVE =  'Defined Form Binary (*.dfb)|*.dfb|'+
                    'Defined Form Text (*.dft)|*.dft|'+
                    'Defined Form XML  (*.dfx)|*.dfx|'+
                    'Defined Form Data (*.dfd)|*.dfd|'+
                    'Enhanced Metafile (*.emf)|*.emf|'+
                    'Windows Metafile (*.wmf)|*.wmf|'+
                    'Rich Text (*.rtf)|*.rtf|'+
                    'HTML (*.html)|*.html|'+
                    'XML (*.xml)|*.xml|'+
                    'BMP (*.bmp)|*.bmp|'+
                    'JPG (*.jpg)|*.jpg|'+
                    'GIF (*.gif)|*.gif|'+
                    'PDF (*.pdf)|*.pdf|'+
                    'All Files (*.*)|*.*';

  PREVTYPES_OPEN =  'All Form Files|*.dfb;*.dft;*.dfx;*.xml;*.rfm;*.emf;*.wmf|'+
                    'Defined Form Binary (*.dfb)|*.dfb|'+
                    'Defined Form Text (*.dft)|*.dft|'+
                    'Defined Form XML  (*.dfx)|*.dfx|'+
                    'Defined Form Data (*.dfd)|*.dfd|'+
                    'Real Form Legacy (*.rfm)|*.rfm|'+
                    'Enhanced Metafile (*.emf)|*.emf|'+
                    'Windows Metafile (*.wmf)|*.wmf|'+
                    'XML (*.xml)|*.xml|'+
                    'All Files (*.*)|*.*';

  PREVTYPES_SAVE =
                    'Rich Text (*.rtf)|*.rtf|'+
                    'Enhanced Metafile (*.emf)|*.emf|'+
                    'Windows Metafile (*.wmf)|*.wmf|'+
                    'Defined Form Binary (*.dfb)|*.dfb|'+
                    'Defined Form Text (*.dft)|*.dft|'+
                    'Defined Form XML  (*.dfx)|*.dfx|'+
                    'Defined Form Data (*.dfd)|*.dfd|'+
                    'XML (*.xml)|*.xml|'+
                    'BMP (*.bmp)|*.bmp|'+
                    'JPG (*.jpg)|*.jpg|'+
                    'GIF (*.gif)|*.gif|'+
                    'PDF (*.pdf)|*.pdf|'+
                    'All Files (*.*)|*.*';

  PREVTYPES_MULTISAVE =
                    'Rich Text (*.rtf)|*.rtf|'+
                    'PDF (*.pdf)|*.pdf|'+
                    'All Files (*.*)|*.*';

type
  TdfFrameType =       (dfSquare,dfRound,dfEllipse);
  TdfAlignment =       (dfLeft,dfRight,dfCentered,dfJustified);
  TdfFieldformat =     (dfText,dfInteger,dfFloat,dfPercent,dfDate,dfCheckbox,
                        dfCombobox,dfCombolist,dfMemo);
  TdfPaperSize =       (dfLetter,dfLegal,dfA3,dfA4,dfA5,dfCustomPaper);
  TdfOrientation =     (dfPortrait,dfLandscape);
  TdfBackgroundAlign = (dfNormal, dfTile, dfStretch);
  TdfRulerUnits =      (dfInches, dfCentimeters, dfPixels);
  TdfCanvasType =      (dfDisplay, dfDesigner, dfActive, dfPrinter, dfDesignPrinter);
  TdfPaintOption =     (dfShowRulers, dfShowMargins, dfShowForm, dfShowFields,
                        dfShowBackground, dfShowActiveBorder, dfPrintShading,
                        dfPrintBackground);
  TdfPaintOptions =    set of TdfPaintOption;
  TdfPreviewOption =   (dfToolbar, dfButtonCaptions, dfPageTabs, dfBottomTabs, dfMaximized,
                        dfAllowClear, dfAllowOpen, dfAllowExport, dfAllowPrint, dfSaveButton,
                        dfEnforceRequired, dfOnlyMultiPageExports);
  TdfPreviewOptions =  set of TdfPreviewOption;

  TdfMergeOption =     (dfWantExceptions, dfOnlyStore, dfOnlyActive);
  TdfMergeOptions =    set of TdfMergeOption;

  EDFError =           class(Exception);
  EDFConvertError =    class(EDFError);
  EDFDatasetError =    class(EDFError);
  EDFFieldError =      class(EDFError);
  EDFInstanceError =   class(EDFError);
  EDFExpressionError = class(EDFError);
  TDFStream =          class(TDefinedStream);
  TDFClass =           class of TDFObject;
  TDFForm =            class;
  TDFPage =            class;
  TDFObject =          class;
  TDFLine =            class;
  TDFFrame =           class;
  TDFLogo =            class;
  TDFButton =          class;
  TDFText =            class;
  TDFField =           class;
  TDFDefaultLine =     class;
  TDFDefaultFrame =    class;
  TDFDefaultLogo =     class;
  TDFDefaultButton =   class;
  TDFDefaultText =     class;
  TDFDefaultField =    class;

  TdfChangeEvent =     procedure(Sender: TObject; AObject: TDFStream; const IsLoading: boolean) of object;
  TdfControlEvent =    procedure(Sender: TObject; AField: TDFField; AControl: TWinControl) of object;
  TDFPageCountEvent =  procedure(Sender: TObject; var Count: integer) of object;
  TDFPageShowEvent =   procedure(Sender: TObject; const VirtualPage: integer; var ActualPage: integer) of object;


{ TDFEngine }

  TDFEngine = class(TComponent)
  private
    FForm: TDFForm;
    FIsDesigner: boolean;
    FPrintDesigner: boolean;
    FChangeEvent: TdfChangeEvent;
    FChangeHook: TdfChangeEvent;
    FOnDimChange: TdfChangeEvent;
    FRulerUnits: TdfRulerUnits;
    FPaintOptions: TdfPaintOptions;
    FPreviewCaption: string;
    FPreviewZoom: string;
    FPreviewOptions: TdfPreviewOptions;
    FPrintJob: string;
    FWantExceptions: boolean;
    FStoreAllFields: boolean;
    FCreateControl: TDFControlEvent;
    FDestroyControl: TDFControlEvent;
    FPreviewEngine: TDFEngine;
    FPageCountEvent: TDFPageCountEvent;
    FPageShowEvent: TDFPageShowEvent;
    FPreviewFilename: string;
    function  _GetPageCount: integer;
    function  _GetPage(Index: integer): TDFPage;
    function  _GetVirtualPageCount: integer;
    function  _GetVirtualPage(Index: integer): TDFPage;
    function  _GetFieldCount: integer;
    function  _GetField(Index: integer): TDFField;
    procedure _SetForm(const Value: TDFForm);
    function  _GetObject(Index: integer): TDFObject;
    function  _GetObjectCount: integer;
    procedure _SetPaintOptions(const Value: TdfPaintOptions);
    procedure _SetRulerUnits(const Value: TdfRulerUnits);
    function GetVersion: string;
    procedure SetVersion(const Value: string);
    procedure ParseError(Sender: TObject; ParseError: Integer);
    procedure PVCreateCtl(Sender: TObject; AField: TDFField; AControl: TWinControl);
    procedure PVDestroyCtl(Sender: TObject; AField: TDFField; AControl: TWinControl);    
  protected
    Updating, Changed: boolean;
    procedure DefineProperties(Filer: TFiler); override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure DoChange(AObject: TDFStream; const ALoading: boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Clear; virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure SavetoFile(const Filename: string);
    procedure LoadFromFile(const Filename: string);
    procedure SavetoStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure SavetoClipboard;
    procedure LoadFromClipboard;
    procedure SaveFields(Dest: TStrings);
    procedure LoadFields(Source: TStrings);
    procedure MergeToDataset(Dest: TDataset; Options: TdfMergeOptions);
    procedure MergeFromDataset(Source: TDataset; Options: TdfMergeOptions);
    procedure MergeToDefinedStream(Dest: TDefinedStream; Options: TdfMergeOptions);
    procedure MergeFromDefinedStream(Source: TDefinedStream; Options: TdfMergeOptions);
    procedure ClearFields;
    procedure ResetFieldStore;
    function  FindField(const FieldName: string): TDFField;
    function  FieldByName(const FieldName: string): TDFField;
    function  FindFieldLink(const FieldLink: string): TDFField;
    function  FindObjectTag(tag: integer): TDFObject;
    function  AddPage: TDFPage;
    function  AddPageCopy(APage: TDFPage): TDFPage;
    function  PrintPreview: boolean;
    procedure Print; overload;
    procedure Print(frompage,topage: integer); overload;
    function  PrintDialog: boolean; overload;
    function  PrintDialog(defaultfrom,defaultto: integer): boolean; overload;
    procedure PrintPage(Page: TDFPage; const IsFirstPage, IsLastPage: boolean);
    function  PrintInit(Page: TDFPage): boolean;
    function  PrintNew(Page: TDFPage): boolean;
    procedure CalcExpressions;
    function  CheckRequiredFields: boolean;
    property Pages [Index:integer]: TDFPage read _GetPage;
    property PageCount: integer read _GetPageCount;
    property FieldCount: integer read _GetFieldCount;
    property Fields [Index:integer]: TDFField read _GetField;
    property ObjectCount: integer read _GetObjectCount;
    property Objects [Index:integer]: TDFObject read _GetObject;
    property IsDesigner: boolean read FIsDesigner write FIsDesigner;
    property PrintDesigner: boolean read FPrintDesigner write FPrintDesigner;
    property ChangeHook: TdfChangeEvent read FChangeHook write FChangeHook;
    property PreviewEngine: TDFEngine read FPreviewEngine write FPreviewEngine;
  published
    property Form: TDFForm read FForm write _SetForm stored False;
    property RulerUnits: TdfRulerUnits read FRulerUnits write _SetRulerUnits default dfInches;
    property PaintOptions: TdfPaintOptions read FPaintOptions write _SetPaintOptions
             default [dfShowForm, dfPrintShading, dfShowFields, dfShowBackground];
    property PreviewOptions: TdfPreviewOptions read FPreviewOptions write FPreviewOptions
             default [dfToolbar, dfButtonCaptions, dfPageTabs, dfBottomTabs,
                      dfAllowClear, dfAllowOpen, dfAllowExport, dfAllowPrint];
    property PreviewCaption: string read FPreviewCaption write FPreviewCaption;
    property PreviewFilename: string read FPreviewFilename write FPreviewFilename;
    property PrintJob: string read FPrintJob write FPrintJob;
    property PreviewZoom: string read FPreviewZoom write FPreviewZoom;
    property WantExceptions: boolean read FWantExceptions write FWantExceptions;
    property StoreAllFields: boolean read FStoreAllFields write FStoreAllFields;
    property Version: string read GetVersion write SetVersion;
    property OnChange: TdfChangeEvent read FChangeEvent write FChangeEvent;
    property OnDimChange: TdfChangeEvent read FOnDimChange write FOnDimChange;
    property OnPreviewCreateControl: TDFControlEvent read FCreateControl write FCreateControl;
    property OnPreviewDestroyControl: TDFControlEvent read FDestroyControl write FDestroyControl;
    property OnPreviewPageCount: TDFPageCountEvent read FPageCountEvent write FPageCountEvent;
    property OnPreviewPageShow: TDFPageShowEvent read FPageShowEvent write FPageShowEvent;
  end;

{ TDFForm }

  TDFForm = class(TDFStream)
  private
    FFormName: string;
    FComment: string;
    FPassword: string;
    FPixelsPerInch: integer;
    FActivePenWidth: integer;
    FActiveBrushStyle: TBrushStyle;
    FActivePenColor: TColor;
    FActiveBrushColor: TColor;
    FActiveColor: TColor;
    FActivePenStyle: TPenStyle;
    FActiveCheckboxBorder: boolean;
    procedure _SetPPI(const Value: integer);
    procedure _SetFormName(const Value: string);
    function _GetDefaultButton: TDFDefaultButton;
    function _GetDefaultField: TDFDefaultField;
    function _GetDefaultFrame: TDFDefaultFrame;
    function _GetDefaultLine: TDFDefaultLine;
    function _GetDefaultLogo: TDFDefaultLogo;
    function _GetDefaultText: TDFDefaultText;
    function GetPassword: string;
    procedure SetPassword(const Value: string);
  protected
    procedure DoChange(AObject: TDFStream; const ALoading: boolean); virtual;
  public
    Engine: TDFEngine;
    TempBMP: TBitmap;
    TempSL: TStringList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function NextFieldName: string;
    property DefaultLine: TDFDefaultLine read _GetDefaultLine;
    property DefaultFrame: TDFDefaultFrame read _GetDefaultFrame;
    property DefaultLogo: TDFDefaultLogo read _GetDefaultLogo;
    property DefaultButton: TDFDefaultButton read _GetDefaultButton;
    property DefaultText: TDFDefaultText read _GetDefaultText;
    property DefaultField: TDFDefaultField read _GetDefaultField;
  published
    property FormName: string read FFormName write _SetFormName;
    property Comment: string read FComment write FComment;
    property Password: string read GetPassword write SetPassword;
    property PixelsPerInch: integer read FPixelsPerInch write _SetPPI;
    property ActiveColor: TColor read FActiveColor write FActiveColor;
    property ActivePenColor: TColor read FActivePenColor write FActivePenColor;
    property ActivePenStyle: TPenStyle read FActivePenStyle write FActivePenStyle;
    property ActivePenWidth: integer read FActivePenWidth write FActivePenWidth;
    property ActiveBrushColor: TColor read FActiveBrushColor write FActiveBrushColor;
    property ActiveBrushStyle: TBrushStyle read FActiveBrushStyle write FActiveBrushStyle;
    property ActiveCheckboxBorder: boolean read FActiveCheckboxBorder write FActiveCheckboxBorder;
  end;

{ TDFPage }

  TDFPage = class(TDFStream)
  private
    FPageName: string;
    FPaperSize: TDFPaperSize;
    FOrientation: TDFOrientation;
    FHeight: integer;
    FWidth: integer;
    FColor: TColor;
    FPrinterDuplex: boolean;
    FPrinterStretch: boolean;
    FPrinterColor: boolean;
    FBackground: TPicture;
    FBackgroundAlign: TDFBackgroundAlign;
    FPrinterOffsetY: integer;
    FPrinterOffsetX: integer;
    FVisible: boolean;
    procedure _SetOrientation(const Value: TDFOrientation);
    procedure _SetPaperSize(const Value: TDFPaperSize);
    procedure _SetWidth(const Value: integer);
    procedure _SetHeight(const Value: integer);
    procedure _SetBackgroundAlign(const Value: TDFBackgroundAlign);
    procedure _SetColor(const Value: TColor);
    procedure _SetPageName(const Value: string);
    procedure _SetPrinterColor(const Value: boolean);
    procedure _SetPrinterDuplex(const Value: boolean);
    procedure _SetPrinterStretch(const Value: boolean);
    procedure _SetPrinterOffsetX(const Value: integer);
    procedure _SetPrinterOffsetY(const Value: integer);
    function _StoreWH: Boolean;
    function _GetObjectCount: integer;
    function _GetObject(Index: integer): TDFObject;
    function _GetLine(Index: integer): TDFLine;
    function _GetLineCount: integer;
    function _GetFrame(Index: integer): TDFFrame;
    function _GetFrameCount: integer;
    function _GetLogo(Index: integer): TDFLogo;
    function _GetLogoCount: integer;
    function _GetButton(Index: integer): TDFButton;
    function _GetButtonCount: integer;
    function _GetText(Index: integer): TDFText;
    function _GetTextCount: integer;
    function _GetField(Index: integer): TDFField;
    function _GetFieldCount: integer;
    procedure _SetBackground(const Value: TPicture);
  protected
    procedure AssignParent(AParent: TDefinedStream); override;
    procedure DoChange(AObject: TDFStream; const ALoading: boolean); virtual;
    procedure BackgroundChange(Sender: TObject);
    procedure SetVisible(const Value: boolean); virtual;
  public
    Form: TDFForm;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Delete; override;
    procedure PaintTo(ACanvas: TCanvas; const ARect: TRect; const CanvasType: TDFCanvasType); overload; virtual;
    procedure PaintTo(ACanvas: TCanvas; const ARect: TRect); overload;
    procedure ClearBackground;
    function PageRect: TRect;
    function FindFieldTab(const Taborder: integer): TDFField;
    function FindFieldFirstTab(const Taborder: integer): TDFField;
    function FindFieldLastTab(const Taborder: integer): TDFField;
    function FindFieldNextTab(const Taborder: integer): TDFField;
    function FindFieldPrevTab(const Taborder: integer): TDFField;
    function AddLine: TDFLine;
    function AddFrame: TDFFrame;
    function AddLogo: TDFLogo;
    function AddButton: TDFButton;
    function AddText: TDFText;
    function AddField: TDFField;
    function AddObject(AObjectType: TDFClass): TDFObject;
    function FindField(const FieldName: string): TDFField;
    property ObjectCount: integer read _GetObjectCount;
    property Objects [Index:integer]: TDFObject read _GetObject;
    property LineCount: integer read _GetLineCount;
    property Lines [Index:integer]: TDFLine read _GetLine;
    property FrameCount: integer read _GetFrameCount;
    property Frames [Index:integer]: TDFFrame read _GetFrame;
    property LogoCount: integer read _GetLogoCount;
    property Logos [Index:integer]: TDFLogo read _GetLogo;
    property ButtonCount: integer read _GetButtonCount;
    property Buttons [Index:integer]: TDFButton read _GetButton;
    property TextCount: integer read _GetTextCount;
    property Text [Index:integer]: TDFText read _GetText;
    property FieldCount: integer read _GetFieldCount;
    property Fields [Index:integer]: TDFField read _GetField;
  published
    property PageName: string read FPageName write _SetPageName;
    property PaperSize:	TDFPaperSize read FPaperSize write _SetPaperSize default DFLetter;
    property Orientation: TDFOrientation read FOrientation write _SetOrientation default DFPortrait;
    property Width: integer read FWidth write _SetWidth stored _StoreWH;
    property Height: integer read FHeight write _SetHeight stored _StoreWH;
    property PrinterOffsetX: integer read FPrinterOffsetX write _SetPrinterOffsetX;
    property PrinterOffsetY: integer read FPrinterOffsetY write _SetPrinterOffsetY;
    property Color: TColor read FColor write _SetColor default clWhite;
    property PrinterStretch: boolean read FPrinterStretch write _SetPrinterStretch default true;
    property PrinterDuplex: boolean read FPrinterDuplex write _SetPrinterDuplex default false;
    property PrinterColor: boolean read FPrinterColor write _SetPrinterColor default true;
    property Background: TPicture read FBackground write _SetBackground;
    property BackgroundAlign: TDFBackgroundAlign read FBackgroundAlign write _SetBackgroundAlign default DFStretch;
    property Visible: boolean read FVisible write SetVisible default true;
  end;

{ TDFObject }

  TDFObject = class(TDFStream)
  private
    FForceStore: boolean;
    FLeft: integer;
    FTop: integer;
    FWidth: integer;
    FHeight: integer;
    FVisible: boolean;
    FPrints: boolean;
    FAutosize: boolean;
    FAlignment: TDFAlignment;
    FPenColor: TColor;
    FPenStyle: TPenStyle;
    FPenWidth: integer;
    FBrushColor: TColor;
    FBrushStyle: TBrushStyle;
    FFontCharset: TFontCharset;
    FFontColor: TColor;
    FFontName: string;
    FFontStyle: TFontStyles;
    FFontHeight: integer;
    procedure _SetAutosize(const Value: boolean);
    procedure _SetAlignment(const Value: TDFAlignment);
    procedure _SetPenColor(const Value: TColor);
    procedure _SetPenStyle(const Value: TPenStyle);
    procedure _SetPenWidth(const Value: integer);
    procedure _SetBrushColor(const Value: TColor);
    procedure _SetBrushStyle(const Value: TBrushStyle);
    procedure _SetFontCharset(const Value: TFontCharset);
    procedure _SetFontColor(const Value: TColor);
    procedure _SetFontName(const Value: string);
    procedure _SetFontStyle(const Value: TFontStyles);
    procedure _SetFontHeight(const Value: integer);
    procedure _SetFontSize(const Value: integer);
    function _GetFontSize: integer;
    function _StorePenColor: boolean;
    function _StorePenStyle: boolean;
    function _StorePenWidth: boolean;
    function _StoreBrushColor: boolean;
    function _StoreBrushStyle: boolean;
    function _StoreFontCharset: boolean;
    function _StoreFontColor: boolean;
    function _StoreFontName: boolean;
    function _StoreFontStyle: boolean;
    function _StoreFontHeight: Boolean;
    function _StoreHW: boolean;
    function _StoreAutosize: Boolean;
    function _StoreAlignment: Boolean;
  protected
    procedure AssignParent(AParent: TDefinedStream); override;
    function GetLeft: integer; virtual;
    function GetTop: integer; virtual;
    function GetWidth: integer; virtual;
    function GetHeight: integer; virtual;
    procedure SetLeft(const Value: integer); virtual;
    procedure SetTop(const Value: integer); virtual;
    procedure SetWidth(const Value: integer); virtual;
    procedure SetHeight(const Value: integer); virtual;
    procedure SetVisible(const Value: boolean); virtual;
    procedure SetPrints(const Value: boolean); virtual;
    procedure PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType); virtual;
    procedure DoChange(AObject: TDFStream; const ALoading: boolean); virtual;
    property ForceStore: boolean read FForceStore write FForceStore;
    property Visible: boolean read FVisible write SetVisible default true;
    property Prints: boolean read FPrints write SetPrints default true;
    property Left: integer read GetLeft write SetLeft default 0;
    property Top: integer read GetTop write SetTop default 0;
    property Width: integer read GetWidth write SetWidth stored _StoreHW;
    property Height: integer read GetHeight write SetHeight stored _StoreHW;
    property Autosize: boolean read FAutosize write _SetAutosize stored _StoreAutosize;
    property Alignment: TDFAlignment read FAlignment write _SetAlignment stored _StoreAlignment;
    property PenColor: TColor read FPenColor write _SetPenColor stored _StorePenColor;
    property PenStyle: TPenStyle read FPenStyle write _SetPenStyle stored _StorePenStyle;
    property PenWidth: integer read FPenWidth write _SetPenWidth stored _StorePenWidth;
    property BrushColor: TColor read FBrushColor write _SetBrushColor stored _StoreBrushColor;
    property BrushStyle: TBrushStyle read FBrushStyle write _SetBrushStyle stored _StoreBrushStyle;
    property FontName: string read FFontName write _SetFontName stored _StoreFontName;
    property FontSize: integer read _GetFontSize write _SetFontSize stored false;
    property FontHeight: integer read FFontHeight write _SetFontHeight stored _StoreFontHeight;
    property FontColor: TColor read FFontColor write _SetFontColor stored _StoreFontColor;
    property FontStyle: TFontStyles read FFontStyle write _SetFontStyle stored _StoreFontStyle;
    property FontCharset: TFontCharset read FFontCharset write _SetFontCharset stored _StoreFontCharset;
  public
    Page: TDFPage;
    DefaultObject: TDFObject;
    constructor Create(AOwner: TComponent); override;
    procedure Delete; override;
  published
    property Tag default 0;
  end;

{ TDFLine }

  TDFLine = class(TDFObject)
  private
    FX1: integer;
    FY2: integer;
    FX2: integer;
    FY1: integer;
    procedure _SetX1(const Value: integer);
    procedure _SetX2(const Value: integer);
    procedure _SetY1(const Value: integer);
    procedure _SetY2(const Value: integer);
  protected
    function GetLeft: integer; override;
    function GetTop: integer; override;
    function GetWidth: integer; override;
    function GetHeight: integer; override;
    procedure SetLeft(const Value: integer); override;
    procedure SetTop(const Value: integer); override;
    procedure SetWidth(const Value: integer); override;
    procedure SetHeight(const Value: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType); override;
    property Left: integer read GetLeft write SetLeft;
    property Top: integer read GetTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
  published
    property X1: integer read FX1 write _SetX1;
    property Y1: integer read FY1 write _SetY1;
    property X2: integer read FX2 write _SetX2;
    property Y2: integer read FY2 write _SetY2;
    property Visible;
    property PenColor;
    property PenStyle;
    property PenWidth;
    property Prints;
  end;

{ TDFFrame }

  TDFFrame = class(TDFObject)
  private
    FFrameType: TDFFrameType;
    FCorner: integer;
    procedure _SetCorner(const Value: integer);
    procedure _SetFrameType(const Value: TDFFrameType);
    function _StoreCorner: Boolean;
    function _StoreFrameType: Boolean;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType); override;
  published
    property FrameType: TDFFrameType read FFrameType write _SetFrameType stored _StoreFrameType;
    property Corner: integer read FCorner write _SetCorner stored _StoreCorner;
    property Left;
    property Top;
    property Width;
    property Height;
    property Visible;
    property PenColor;
    property PenStyle;
    property PenWidth;
    property BrushColor;
    property BrushStyle;
    property Prints;
  end;

{ TDFLogo }

  TDFLogo = class(TDFObject)
  private
    FPicture: TPicture;
    FTransparent: boolean;
    FStretch: boolean;
    procedure _SetPicture(const Value: TPicture);
    procedure _SetStretch(const Value: boolean);
    procedure _SetTransparent(const Value: boolean);
    procedure _PictureChange(Sender: TObject);
    function _StoreStretch: Boolean;
    function _StoreTransparent: Boolean;
  protected
    function GetWidth: integer; override;
    function GetHeight: integer; override;
    property Transparent: boolean read FTransparent write _SetTransparent stored _StoreTransparent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType); override;
  published
    property Picture: TPicture read FPicture write _SetPicture;
    property Stretch: boolean read FStretch write _SetStretch stored _StoreStretch;
    property Left;
    property Top;
    property Width;
    property Height;
    property Visible;
    property Autosize;
    property PenColor;
    property PenStyle;
    property PenWidth;
    property BrushColor;
    property BrushStyle;
    property Prints;
  end;

{ TDFButton }

  TDFButton = class(TDFObject)
  private
    FCaption: string;
    procedure _SetCaption(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType); override;
  published
    property Caption: string read FCaption write _SetCaption;
    property Left;
    property Top;
    property Width;
    property Height;
    property Visible;
    property Prints default false;
    property PenColor;
    property PenStyle;
    property PenWidth;
    property BrushColor;
    property BrushStyle;
    property FontName;
    property FontSize;
    property FontHeight;
    property FontColor;
    property FontStyle;
    property FontCharset;
  end;

{ TDFText }

  TDFText = class(TDFObject)
  private
    FText: string;
    FAngle: integer;
    FLineSpacing: integer;
    FWordwrap: boolean;
    procedure _SetAngle(const Value: integer);
    procedure _SetLineSpacing(const Value: integer);
    function _StoreAngle: Boolean;
    function _StoreLineSpacing: Boolean;
    procedure _SetText(const Value: string);
    procedure _SetWordwrap(const Value: boolean);
    function _StoreWordwrap: Boolean;
  protected
    function GetWidth: integer; override;
    function GetHeight: integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType); override;
  published
    property Text: string read FText write _SetText;
    property Angle: integer read FAngle write _SetAngle stored _StoreAngle;
    property LineSpacing: integer read FLineSpacing write _SetLineSpacing stored _StoreLineSpacing;
    property Wordwrap: boolean read FWordwrap write _SetWordwrap stored _StoreWordwrap;
    property Left;
    property Top;
    property Width;
    property Height;
    property Visible;
    property Autosize;
    property Alignment;
    property PenColor;
    property PenStyle;
    property PenWidth;
    property BrushColor;
    property BrushStyle;
    property FontName;
    property FontSize;
    property FontHeight;
    property FontColor;
    property FontStyle;
    property FontCharset;
    property Prints;
  end;

{ TDFField }

  TDFField = class(TDFObject)
  private
    FFieldname: string;
    FFormat: TDFFieldFormat;
    FCheckIndex: integer;
    FMaxLength: integer;
    FHelpContext: integer;
    FTabOrder: integer;
    FEditMask: string;
    FExpression: string;
    FData: string;
    FHint: string;
    FLineSpacing: integer;
    FActive: boolean;
    FComboItems: string;
    FStore: boolean;
    FFieldlink: string;
    FActiveMinWidth: integer;
    FDisplayFormat: string;
    FShowZero: boolean;
    FWordwrap: boolean;
    FFieldParams: string;
    FRequired: boolean;
    procedure _SetFieldname(const Value: string);
    procedure _SetCheckIndex(const Value: integer);
    procedure _SetTabOrder(const Value: integer);
    procedure _SetEditMask(const Value: string);
    procedure _SetData(const Value: string);
    procedure _SetExpression(const Value: string);
    procedure _SetFormat(const Value: TDFFieldFormat);
    procedure _SetHelpContext(const Value: integer);
    procedure _SetHint(const Value: string);
    procedure _SetLineSpacing(const Value: integer);
    procedure _SetMaxLength(const Value: integer);
    procedure _SetComboItems(const Value: string);
    procedure _SetActive(const Value: boolean);
    procedure _SetFieldlink(const Value: string);
    procedure _SetStore(const Value: boolean);
    procedure _SetAsBoolean(const Value: boolean);
    procedure _SetAsDateTime(const Value: TDatetime);
    procedure _SetAsFloat(const Value: double);
    procedure _SetAsInteger(const Value: integer);
    procedure _SetAsString(const Value: string);
    procedure _SetActiveMinWidth(const Value: integer);
    procedure _SetDisplayFormat(const Value: string);
    procedure _SetShowZero(const Value: boolean);
    procedure _SetWordwrap(const Value: boolean);
    procedure _SetFieldParams(const Value: string);
    function _StoreCheckIndex: Boolean;
    function _StoreFormat: Boolean;
    function _StoreHelpContext: Boolean;
    function _StoreLineSpacing: Boolean;
    function _StoreMaxLength: Boolean;
    function _StoreActive: Boolean;
    function _StoreStore: Boolean;
    function _StoreActiveMinWidth: Boolean;
    function _StoreShowZero: Boolean;
    function _StoreWordwrap: Boolean;
    function _GetAsBoolean: boolean;
    function _GetAsDateTime: TDatetime;
    function _GetAsFloat: double;
    function _GetAsInteger: integer;
    function _GetAsString: string;
    procedure DrawCheckmark(ACanvas: TCanvas; ARect: TRect);
    procedure _SetRequired(const Value: boolean);
    function _StoreRequired: Boolean;
  protected
    procedure SetTabOrder(const AValue: integer); dynamic;
    procedure SetFieldName(const AValue: string); dynamic;
    function GetWidth: integer; override;
    function GetHeight: integer; override;
    function GetFieldname: string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType); override;
    property AsString: string read _GetAsString write _SetAsString;
    property AsInteger: integer read _GetAsInteger write _SetAsInteger;
    property AsFloat: double read _GetAsFloat write _SetAsFloat;
    property AsDateTime: TDatetime read _GetAsDateTime write _SetAsDateTime;
    property AsBoolean: boolean read _GetAsBoolean write _SetAsBoolean;
  published
    property FieldName: string read FFieldname write _SetFieldname;
    property FieldLink: string read FFieldlink write _SetFieldlink;
    property FieldParams: string read FFieldParams write _SetFieldParams;
    property Format: TDFFieldFormat read FFormat write _SetFormat stored _StoreFormat;
    property TabOrder: integer read FTabOrder write _SetTabOrder;
    property Active: boolean read FActive write _SetActive stored _StoreActive;
    property Store: boolean read FStore write _SetStore stored _StoreStore;
    property ShowZero: boolean read FShowZero write _SetShowZero stored _StoreShowZero;
    property Maxlength:	integer read FMaxLength write _SetMaxLength stored _StoreMaxLength;
    property ActiveMinWidth: integer read FActiveMinWidth write _SetActiveMinWidth stored _StoreActiveMinWidth;
    property HelpContext: integer read FHelpContext write _SetHelpContext stored _StoreHelpContext;
    property Hint: string read FHint write _SetHint;
    property Data: string read FData write _SetData;
    property ComboItems: string read FComboItems write _SetComboItems;
    property CheckIndex: integer read FCheckIndex write _SetCheckIndex stored _StoreCheckIndex;
    property LineSpacing: integer read FLineSpacing write _SetLineSpacing stored _StoreLineSpacing;
    property DisplayFormat: string read FDisplayFormat write _SetDisplayFormat;
    property EditMask: string read FEditMask write _SetEditMask;
    property Wordwrap: boolean read FWordwrap write _SetWordwrap stored _StoreWordwrap;
    property Required: boolean read FRequired write _SetRequired stored _StoreRequired;    
    property Expression: string read FExpression write _SetExpression;
    property Autosize;
    property Alignment;
    property Left;
    property Top;
    property Width;
    property Height;
    property Visible;
    property PenColor;
    property PenStyle;
    property PenWidth;
    property BrushColor;
    property BrushStyle;
    property FontName;
    property FontSize;
    property FontHeight;
    property FontColor;
    property FontStyle;
    property FontCharset;
    property Prints;
  end;

{ Default Classes }

TDFDefaultLine =     class(TDFLine);
TDFDefaultFrame =    class(TDFFrame);
TDFDefaultLogo =     class(TDFLogo);
TDFDefaultButton =   class(TDFButton);
TDFDefaultText =     class(TDFText);
TDFDefaultField =    class(TDFField);

{ TDFAccess }

  TDFAccess = class(TDFObject)
  published
    property ForceStore;
    property Left;
    property Top;
    property Width;
    property Height;
    property Visible;
    property Autosize;
    property Alignment;
    property PenColor;
    property PenStyle;
    property PenWidth;
    property BrushColor;
    property BrushStyle;
    property FontName;
    property FontSize;
    property FontColor;
    property FontStyle;
    property FontCharset;
  end;

  TDFFieldAccess = class(TDFField)
  public
    procedure SetTabOrder(const AValue: integer); override;
    procedure SetFieldName(const AValue: string); override;
  end;

var
  Checked: boolean = False;
  PrinterXdpi: integer = 0;
  PrinterYdpi: integer = 0;
  PrinterXmargin: integer = 0;
  PrinterYmargin: integer = 0;
  PrinterCanReset: boolean = false;
  PrinterPageNum: integer = 0;
  PrinterScale: integer = 0;
  PrinterXGutter: integer = 0;
  PrinterYGutter: integer = 0;
  PrinterName: string;
  ExpError: integer = 0;

implementation

uses
  dfutil, dfconvert, dfpreview, dfcontrols;

{ TDFEngine }

constructor TDFEngine.Create(AOwner: TComponent);
var I: Integer;
begin
  inherited;
  FForm:= nil;
  FChangeEvent:= nil;
  FChangeHook:= nil;
  FPreviewEngine:= nil;
  FIsDesigner:= false;
  FPrintDesigner:= false;
  Updating:= false;
  Changed:= false;
  FWantExceptions:= true;
  FStoreAllFields:= false;
  FRulerUnits:= dfInches;
  FPaintOptions := [dfShowForm, dfPrintShading, dfShowFields, dfShowBackground];
  FPreviewOptions := [dfToolbar, dfButtonCaptions, dfPageTabs, dfBottomTabs,
                      dfAllowClear, dfAllowOpen, dfAllowExport, dfAllowPrint];
  FPreviewCaption:= 'Defined Forms Preview';
  FPrintJob:= 'Defined Forms Printer';
  FPreviewZoom:= '100';
  Clear;
  if Owner <> nil then
    for I:= 0 to Owner.ComponentCount-1 do
      if Owner.Components[I] is TDFDisplay then
        if (Owner.Components[I] as TDFDisplay).FormEngine = nil then
          (Owner.Components[I] as TDFDisplay).FormEngine:= Self;
end;

destructor TDFEngine.Destroy;
begin
  inherited;
end;

procedure TDFEngine.Loaded;
begin
  inherited Loaded;
  {$IFDEF DEMO}
  if (not Checked) and not(csDesigning in ComponentState) then dfCheck;
  Checked:= true;
  {$ENDIF}
end;

procedure TDFEngine.Clear;
begin
  if FForm <> nil then FForm.free;
  FForm:= TDFForm.create(Self);
  AddPage;
  DoChange(Form, false);
end;

procedure TDFEngine.DefineProperties(Filer: TFiler);
var HasData: boolean;
begin
  inherited;
  HasData:= PageCount > 0;
  Filer.DefineBinaryProperty('FormData', LoadFromStream, SaveToStream, HasData);
end;

procedure TDFEngine.DoChange(AObject: TDFStream; const ALoading: boolean);
begin
  if not Updating then
  begin
    if Assigned(FChangeEvent) then FChangeEvent(Self, AObject, ALoading);
    if Assigned(FChangeHook) then FChangeHook(Self, AObject, ALoading);
  end
  else
    Changed:= true;
end;

procedure TDFEngine.BeginUpdate;
begin
  DoChange(Form, false);
  Updating:= true;
  Changed:= false;
end;

procedure TDFEngine.EndUpdate;
begin
  Updating:= false;
  if Changed then
    DoChange(Form, false);
end;

function TDFEngine.AddPage: TDFPage;
begin
  result:= FForm.AddNewChild(TDFPage) as TDFPage;
  Pages[PageCount-1].PageName:= 'Page '+inttostr(PageCount);
  if Pages[0].PageName = 'Untitled Page' then Pages[0].PageName:= 'Page 1';
end;

procedure TDFEngine.LoadFromClipboard;
begin
  Clear;
  FForm.LoadFromClipboard;
end;

procedure TDFEngine.LoadFromFile(const Filename: string);
begin
  Clear;
  dfOpenFile(Self, Filename);
end;

procedure TDFEngine.LoadFromStream(Stream: TStream);
begin
  Clear;
  if Stream.Size > 0 then
    FForm.LoadFromStream(Stream);
end;

procedure TDFEngine.SavetoClipboard;
begin
  FForm.SavetoClipboard;
end;

procedure TDFEngine.SavetoFile(const Filename: string);
begin
  dfSaveFile(Self, Filename);
end;

procedure TDFEngine.SavetoStream(Stream: TStream);
begin
  if (PageCount > 0) and (Pages[0].ObjectCount > 0) then
    FForm.SavetoStream(Stream);
end;

procedure TDFEngine.AssignTo(Dest: TPersistent);
var
  tmpstream: TMemorystream;
begin
  if Dest is TDFEngine then
  begin
    tmpstream:= TMemorystream.create;
    try
      Form.SavetoStream(tmpstream);
      tmpstream.seek(0,0);
      TDFEngine(Dest).Form.Clear;
      TDFEngine(Dest).Form.LoadFromStream(tmpstream);
      TDFEngine(Dest).DoChange(nil, false);
    finally
      tmpstream.free;
    end;
  end
  else inherited;
end;

function TDFEngine._GetPage(Index: integer): TDFPage;
begin
  result:= FForm.FindChild(TDFPage,Index) as TDFPage;
end;

function TDFEngine._GetPageCount: integer;
begin
  result:= FForm.CountChildren(TDFPage);
end;

function TDFEngine._GetVirtualPage(Index: integer): TDFPage;
var Actual : Integer;
begin
  if Assigned(FPageShowEvent) then
  begin
    Actual:= 0;
    FPageShowEvent(Self, Index, Actual);
    Result := Pages[Actual];
  end else
    result := Pages[Index];
end;

function TDFEngine._GetVirtualPageCount: integer;
var C: integer;
begin
  C:= PageCount;
  if Assigned(FPageCountEvent) then
    FPageCountEvent(Self, C);
  Result := C;
end;

function TDFEngine._GetField(Index: integer): TDFField;
var i,j,c: integer;
begin
  result:= nil;
  c:= 0;
  for i:= 0 to PageCount-1 do
    for j:= 0 to Pages[i].FieldCount-1 do
    begin
      if c = Index then
      begin
        result:= Pages[i].Fields[j];
        Exit;
      end
      else
        inc(c);
    end;
end;

function TDFEngine._GetFieldCount: integer;
var i: integer;
begin
  result:= 0;
  for i:= 0 to PageCount-1 do
    result:= result + Pages[i].FieldCount;
end;

function TDFEngine._GetObject(Index: integer): TDFObject;
var i,j,c: integer;
begin
  result:= nil;
  c:= 0;
  for i:= 0 to PageCount-1 do
    for j:= 0 to Pages[i].ObjectCount-1 do
    begin
      if c = Index then
      begin
        result:= Pages[i].Objects[j];
        Exit;
      end
      else
        inc(c);
    end;
end;

function TDFEngine._GetObjectCount: integer;
var i: integer;
begin
  result:= 0;
  for i:= 0 to PageCount-1 do
    result:= result + Pages[i].ObjectCount;
end;

procedure TDFEngine._SetForm(const Value: TDFForm);
begin
  FForm.Assign(Value);
end;

procedure TDFEngine._SetPaintOptions(const Value: TdfPaintOptions);
begin
  FPaintOptions := Value;
  DoChange(nil, false);
end;

procedure TDFEngine._SetRulerUnits(const Value: TdfRulerUnits);
begin
  FRulerUnits := Value;
  DoChange(nil, false);
end;

function TDFEngine.PrintPreview: boolean;
begin
  dlDFPreview:= TdlDFPreview.create(nil);
  try
    dlDFPreview.PreviewCaption:= PreviewCaption;
    dlDFPreview.PreviewFilename:= PreviewFilename;
    dlDFPreview.PreviewZoom:= PreviewZoom;
    dlDFPreview.PreviewOptions:= PreviewOptions;
    dlDFPreview.ActiveDisplay.OnCreateControl := PVCreateCtl;
    dlDFPreview.ActiveDisplay.OnDestroyControl := PVDestroyCtl;
    dlDFPreview.Engine.OnPreviewPageCount := FPageCountEvent;
    dlDFPreview.Engine.OnPreviewPageShow := FPageShowEvent;
    dlDFPreview.Engine.PaintOptions := PaintOptions;
    FPreviewEngine:= dlDFPreview.Engine;
    result:= dlDFPreview.Execute(Self, true);
    FPreviewEngine:= nil;
    PreviewZoom:= dlDFPreview.PreviewZoom;
    PreviewOptions:= dlDFPreview.PreviewOptions;
  finally
    dlDFPreview.free;
  end
end;

procedure TDFEngine.Print(frompage, topage: integer);
var x: integer;
begin
  if frompage <= 0 then frompage:= 1;
  if topage <= 0 then topage:= _GetVirtualPageCount;
  if (frompage < 1) or (topage > _GetVirtualPageCount) or (topage < frompage) then
    raise EDFError.create('Printing page range out of bounds');
  for x:= frompage-1 to topage-1 do
  begin
    if (x = frompage-1) and (x = topage-1) then PrintPage(_GetVirtualPage(x), true,true);
    if (x = frompage-1) and (x < topage-1) then PrintPage(_GetVirtualPage(x), true,false);
    if (x > frompage-1) and (x < topage-1) then PrintPage(_GetVirtualPage(x), false,false);
    if (x > frompage-1) and (x = topage-1) then PrintPage(_GetVirtualPage(x), false,true);
  end;
end;

procedure TDFEngine.Print;
begin
  Print(1, _GetVirtualPageCount);
end;

function TDFEngine.PrintDialog(defaultfrom,defaultto: integer): boolean;
var PrintDialog: TPrintDialog;
begin
  PrintDialog:= TPrintDialog.create(nil);
  try
    PrintDialog.Options := [poPageNums, poWarning];
    PrintDialog.MinPage:= 1;
    PrintDialog.MaxPage:= _GetVirtualPageCount;
    if (defaultfrom > 0) and (defaultto > 0) then
    begin
      PrintDialog.PrintRange := prPageNums;
      PrintDialog.FromPage:= defaultfrom;
      PrintDialog.ToPage:= defaultto;
    end
    else begin
      PrintDialog.PrintRange := prAllPages;
      PrintDialog.FromPage:= PrintDialog.MinPage;
      PrintDialog.ToPage:= PrintDialog.MaxPage;
    end;
    result:= PrintDialog.Execute;
    if result then
    begin
      if PrintDialog.PrintRange = prAllPages then
      begin
        PrintDialog.FromPage:= PrintDialog.MinPage;
        PrintDialog.ToPage:= PrintDialog.MaxPage;
      end;
      Print(PrintDialog.FromPage,PrintDialog.ToPage);
    end;
  finally
    PrintDialog.free;
  end;
end;

function TDFEngine.PrintDialog: boolean;
begin
  result:= PrintDialog(1, _GetVirtualPageCount);
end;

procedure TDFEngine.PrintPage(Page: TDFPage; const IsFirstPage, IsLastPage: boolean);
var R: TRect;
begin
  try
    if IsFirstPage then
    begin
      PrinterPageNum:= 1;
      if not PrintInit(Page) then
        raise EDFError.create('Unable to initialize printer');
      Printer.Title:= FPrintJob;
      Printer.BeginDoc;
    end;

    if (not IsFirstPage) then
      if not PrintNew(Page) then ;

    R:= Rect(0,0,Printer.PageWidth, Printer.PageHeight);

    if PrinterScale > 0 then //scaling override
    begin
      R.Right :=  trunc(R.Right * (PrinterScale / 100));
      R.Bottom := trunc(R.Bottom * (PrinterScale / 100));
    end;

    if (not Page.PrinterStretch) and (PrinterXMargin > 0) and (PrinterYMargin > 0) and
       (PrinterXdpi > 0) and (PrinterYdpi > 0) then
    begin
      R.left:= -PrinterXMargin;
      R.top:= -PrinterYMargin;
      R.Right:= R.left + trunc( Page.Width * (PrinterXdpi / Form.PixelsPerInch) );
      R.Bottom:= R.right + trunc( Page.Height * (PrinterYdpi / Form.PixelsPerInch) );
    end;

    if PrinterXGutter > 0 then //gutter override
      R.Left := R.Left + PrinterXGutter;
    if PrinterYGutter > 0 then //gutter override
      R.Top := R.Top + PrinterYGutter;

    if not PrintDesigner then
      Page.PaintTo(Printer.Canvas, R, dfPrinter)
    else
      Page.PaintTo(Printer.Canvas, R, dfDesignPrinter);

    if IsLastPage then
    begin
      Printer.EndDoc;
      PrinterPageNum:= 0;
    end;
  except
    raise Exception.create('Error printing page');
  end;
end;

function TDFEngine.PrintInit(Page: TDFPage): boolean;
var
  Device: array[1..cchDeviceName] of char;
  Driver: array[1..MAX_PATH] of char;
  Port: array[0..32] of char;
  hDMode,PrnHandle: THandle;
  PDMode: PDEVMODE;
  Paper,Orient,Duplex,Color: integer;
begin
  result := false;

  try
    if Printer.PrinterIndex > -1 then
      PrinterName:= Printer.Printers[Printer.PrinterIndex];

    case Page.PaperSize of
      dfLegal: Paper:= DMPAPER_LEGAL;
      //dfA3:    Paper:= DMPAPER_A3;
      dfA3:    Paper:= DMPAPER_A4;
      dfA4:    Paper:= DMPAPER_A4;
      dfA5:    Paper:= DMPAPER_A5;
      else     Paper:= DMPAPER_LETTER;
    end;

    if Page.Orientation = dfLandscape then
      Orient:= DMORIENT_LANDSCAPE
    else
      Orient:= DMORIENT_PORTRAIT;

    if Page.PrinterDuplex then
      Duplex:= DMDUP_VERTICAL
    else
      Duplex:= DMDUP_SIMPLEX;

    if Page.PrinterColor then
      Color:= DMCOLOR_COLOR
    else
      Color:= DMCOLOR_MONOCHROME;

    Printer.GetPrinter(@Device, @Driver, @Port, hDMode);
    if hDMode <> 0 then
    begin
      pDMode := GlobalLock(hDMode);
      if pDMode <> nil then
      begin
        pDMode^.dmPaperSize:= Paper;
        pDMode^.dmOrientation:= Orient;
        pDMode^.dmCopies:= 1;
        pDMode^.dmDuplex:= Duplex;
        pDMode^.dmColor:= Color;
        pDMode^.dmFields:=
          pDMode^.dmFields or DM_PAPERSIZE or DM_ORIENTATION or DM_COPIES or DM_DUPLEX or DM_COLOR;

        PrinterXdpi:= GetDeviceCaps(Printer.handle, LOGPIXELSX);
        PrinterYdpi:= GetDeviceCaps(Printer.handle, LOGPIXELSY);
        PrinterXmargin:= GetDeviceCaps(Printer.handle, PHYSICALOFFSETX);
        PrinterYmargin:= GetDeviceCaps(Printer.handle, PHYSICALOFFSETY);

        if Printer.Printing then
          PrnHandle := Printer.Canvas.Handle
         else
          PrnHandle := Printer.Handle;
        if ResetDc(PrnHandle, pDMode^) <> 0 then
          PrinterCanReset := true
        else
          PrinterCanReset := false;
        Result := true;
        GlobalUnlock(hDMode);
      end;
    end;
  except
    raise Exception.create('Error initializing printer');
  end;
end;

function TDFEngine.PrintNew(Page: TDFPage): boolean;
begin
  Result := true;
  try
    if PrinterCanReset then
      EndPage(Printer.Canvas.Handle)
    else
      Printer.EndDoc;
    Inc(PrinterPageNum);
    if PrintInit(Page) then
    begin
      if PrinterCanReset then
      begin
        StartPage(Printer.Canvas.Handle);
        Printer.Canvas.Refresh;
      end else
        Printer.BeginDoc;
    end else
    begin
      if PrinterCanReset then
      begin
        StartPage(Printer.Canvas.Handle);
        Printer.Abort;
      end;
      Result := false;
    end;
  except
    raise Exception.create('Error re-initializing printer');
  end;
end;

function TDFEngine.FindField(const FieldName: string): TDFField;
var i,j: integer;
begin
  result:= nil;
  for i:= 0 to PageCount-1 do
    for j:= 0 to Pages[i].FieldCount-1 do
    begin
      if sametext(Pages[i].Fields[j].FieldName, FieldName) then
      begin
        result:= Pages[i].Fields[j];
        Exit;
      end;
    end;
end;

function TDFEngine.FieldByName(const FieldName: string): TDFField;
begin
  result:= FindField(FieldName);
  if result = nil then
    raise EDFError.create('Field "'+FieldName+'" was not found');
end;

function TDFEngine.FindFieldLink(const FieldLink: string): TDFField;
var i,j: integer;
begin
  result:= nil;
  for i:= 0 to PageCount-1 do
    for j:= 0 to Pages[i].FieldCount-1 do
    begin
      if sametext(Pages[i].Fields[j].FieldLink, FieldLink) then
      begin
        result:= Pages[i].Fields[j];
        Exit;
      end;
    end;
end;

procedure TDFEngine.ClearFields;
var i,j: integer;
begin
  BeginUpdate;
  for i:= 0 to PageCount-1 do
    for j:= 0 to Pages[i].FieldCount-1 do
      Pages[i].Fields[j].Data:= '';
  EndUpdate;
end;

procedure TDFEngine.ResetFieldStore;
var i,j: integer;
begin
  BeginUpdate;
  for i:= 0 to PageCount-1 do
    for j:= 0 to Pages[i].FieldCount-1 do
      Pages[i].Fields[j].Store:= Pages[i].Fields[j].Active;
  EndUpdate;
end;

function TDFEngine.FindObjectTag(tag: integer): TDFObject;
var i: integer;
begin
  result:= nil;
  for i:= 0 to ObjectCount-1 do
    if Objects[i].Tag = tag then
    begin
      result:= Objects[i];
      break;
    end;
end;

function TDFEngine.AddPageCopy(APage: TDFPage): TDFPage;
begin
  result:= Form.AddChildCopy(APage) as TDFPage;
  if Pages[PageCount-1].PageName = 'Page 1' then
    Pages[PageCount-1].PageName:= 'Page '+inttostr(PageCount);
end;

procedure TDFEngine.LoadFields(Source: TStrings);
var I: integer;
begin
  BeginUpdate;
  for I:= 0 to FieldCount-1 do
    Fields[I].Data:= dfCRLFtoStr(Source.Values[Fields[I].FieldName]);
  EndUpdate;
end;

procedure TDFEngine.SaveFields(Dest: TStrings);
var I: integer;
begin
  Dest.clear;
  for I:= 0 to FieldCount-1 do
    if StoreAllFields or Fields[I].Store then
      Dest.Values[Fields[I].FieldName]:= dfStrtoCRLF(Fields[I].Data);
end;

procedure TDFEngine.MergeFromDataset(Source: TDataset;
  Options: TdfMergeOptions);
var I: integer;
    Link: string;
begin
  for I:= 0 to FieldCount-1 do
  begin
    Link := Fields[I].FieldLink;
    if Link = '' then
      Link := Fields[I].FieldName;
    if Link = '' then continue;
    if Source.FindField(Link) <> nil then
      Fields[I].AsString:= Source.FieldByName(Link).AsString
    else begin
      if dfWantExceptions in Options then
        raise EDFDatasetError.create('Dataset field "'+Link+'" was not found');
    end;
  end;
end;

procedure TDFEngine.MergeToDataset(Dest: TDataset;
  Options: TdfMergeOptions);
var I: integer;
begin
  for I:= 0 to FieldCount-1 do
  begin
    if Fields[I].FieldLink = '' then continue;
    if Dest.FindField(Fields[I].FieldLink) <> nil then
      Dest.FieldByName(Fields[I].FieldLink).AsString:= Fields[I].Data
    else begin
      if dfWantExceptions in Options then
        raise EDFDatasetError.create('Dataset field "'+Fields[I].FieldLink+'" was not found');
    end;
  end;
end;

procedure TDFEngine.MergeFromDefinedStream(Source: TDefinedStream;
  Options: TdfMergeOptions);
var
  I: integer;
  AField: TDFField;
  propinfo: TPropInfo;
  Instance: TDefinedStream;
begin
  if Source = nil then
    raise EDFError.create('Data source is nil');
  //loop through all fields
  for I:= 0 to FieldCount-1 do
  begin
    AField:= Fields[I];
    //if no data link, continue
    if AField.FieldLink = '' then continue;
    //find propinfo for this link
    Instance:= Source;
    if not Instance.FindProperty(AField.FieldLink, Instance, propinfo) then
    begin
      if dfWantExceptions in Options then
      begin
        if Instance = nil then
        begin
//          raise EDFInstanceError.create('Field instance not found: '+AField.FieldLink);
        end else
          raise EDFFieldError.create('Field link not found: '+AField.FieldLink);
      end;
      continue;
    end;
    //get data
    if AField.Format <> dfDate then
    begin
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString:
        begin
          if (AField.FieldParams = '') or (dfGetParam(AField.FieldParams,'code')='') then
            AField.AsString := GetStrProp(Instance, @propinfo)
          else
            AField.AsString := dfGetCode(GetStrProp(Instance, @propinfo),
                                         dfGetParam(AField.FieldParams,'code'));
        end;
        tkInteger,tkChar,tkWChar: AField.AsInteger := GetOrdProp(Instance, @propinfo);
        tkFloat: AField.AsFloat := GetFloatProp(Instance, @propinfo);
        tkEnumeration: AField.AsBoolean:= sametext(GetEnumProp(Instance, @propinfo), 'true');
      end;
    end
    else begin
      //date format
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString:
        begin
          if (AField.FieldParams = '') or (dfGetParam(AField.FieldParams,'code')='') then
            AField.AsString := GetStrProp(Instance, @propinfo)
          else
            AField.AsDateTime := dfGetDateCode(GetStrProp(Instance, @propinfo),
                                            dfGetParam(AField.FieldParams,'code'));
        end;
        tkInteger,tkChar,tkWChar: AField.AsDateTime := GetOrdProp(Instance, @propinfo);
        tkFloat: AField.AsDateTime := GetFloatProp(Instance, @propinfo);
      end;
    end;
  end;
end;

procedure TDFEngine.MergeToDefinedStream(Dest: TDefinedStream;
  Options: TdfMergeOptions);
var
  I: integer;
  AField: TDFField;
  propinfo: TPropInfo;
  Instance: TDefinedStream;
begin
  //loop through all fields
  for I:= 0 to FieldCount-1 do
  begin
    AField:= Fields[I];
    //if no data link, continue
    if AField.FieldLink = '' then continue;
    //if filtered then continue
    if (dfOnlyActive in Options) and (not AField.Active) then continue;
    if (dfOnlyStore in Options) and (not AField.Store) then continue;
    //find propinfo for this link
    Instance:= Dest;
    if not Instance.FindProperty(AField.FieldLink, Instance, propinfo) then
    begin
      if dfWantExceptions in Options then
        raise EDFFieldError.create('Field link not found: '+AField.FieldLink);
      continue;
    end;
    //make sure property is not read-only or write-only or non-stored
    if propinfo.GetProc = nil then continue;
    if propinfo.SetProc = nil then continue;
    if not IsStoredProp(Instance, @propinfo) then continue;

    //put data
    if AField.Format <> dfDate then
    begin
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString:
        begin
          if (AField.FieldParams = '') or (dfGetParam(AField.FieldParams,'code')='') then
            SetStrProp(Instance, @propinfo, AField.AsString)
          else
            SetStrProp(Instance, @propinfo, dfSetCode(GetStrProp(Instance, @propinfo),
                                                      dfGetParam(AField.FieldParams,'code'),
                                                      AField.AsString))
        end;
        tkInteger,tkChar,tkWChar: SetOrdProp(Instance, @propinfo, AField.AsInteger);
        tkFloat: SetFloatProp(Instance, @propinfo, AField.AsFloat);
        tkEnumeration: if AField.AsBoolean then SetEnumProp(Instance, @propinfo, 'True')
                       else SetEnumProp(Instance, @propinfo, 'False');
      end;
    end
    else begin
      //date format
      case propinfo.PropType^.Kind of
        tkString,tkLString,tkWString:
        begin
          if (AField.FieldParams = '') or (dfGetParam(AField.FieldParams,'code')='') then
            SetStrProp(Instance, @propinfo, AField.AsString)
          else
            SetStrProp(Instance, @propinfo, dfSetDateCode(GetStrProp(Instance, @propinfo),
                                                          dfGetParam(AField.FieldParams,'code'),
                                                          AField.AsFloat));
        end;
        tkInteger,tkChar,tkWChar: SetOrdProp(Instance, @propinfo, trunc(AField.AsDateTime));
        tkFloat: SetFloatProp(Instance, @propinfo, AField.AsDateTime);
      end;
    end;
  end;
end;

function TDFEngine.GetVersion: string;
begin
  result:= DF_STRING_VER;
end;

procedure TDFEngine.SetVersion(const Value: string);
begin
end;

procedure TDFEngine.CalcExpressions;
{$IFDEF EXPRESSIONS}
var
  I,J: Integer;
  tmpstr, tmpval: string;
  SL: TStringlist;
  hasexpr: boolean;
  P: TMathParser;
{$ENDIF}

begin
  {$IFDEF EXPRESSIONS}
  SL:= TStringlist.create;
  P:= TMathParser.create(nil);
  try
    hasexpr:= false;
    for I:= 0 to FieldCount-1 do
    begin
      SL.add(lowercase(Fields[I].Fieldname));
      if (not hasexpr) and (Fields[I].Expression <> '') then hasexpr:= true;
    end;
    if not hasexpr then Exit
    else BeginUpdate;
    for I:= 0 to FieldCount-1 do
    begin
      tmpstr:= lowercase(Fields[I].Expression);
      if tmpstr = '' then continue;
      for J:= 0 to SL.count-1 do
        if pos( '<'+SL[J]+'>', tmpstr) > 0 then
        begin
          if FieldByName(SL[J]).data <> '' then
            tmpval:= floattostr(FieldByName(SL[J]).asFloat)
          else
            tmpval:= '0';
          tmpstr:= stringreplace(tmpstr, '<'+SL[J]+'>', tmpval, [rfreplaceall]);
        end;
      ExpError:= 0;
      P.OnParseError:= ParseError;
      P.ParseString:= tmpstr;
      P.Parse;
      if not P.ParseError then
        Fields[I].AsFloat:= P.ParseValue
      else begin
        if (ExpError < 7) and (ExpError > 0) then
          raise EDFExpressionError.create('Expression error '+inttostr(ExpError)+' in "'+Fields[I].Fieldname+'" '+Fields[I].Expression);
      end;
    end;
    EndUpdate;
  finally
    P.free;
    SL.free;
  end;
  {$ELSE}
  raise EDFExpressionError.create('Expressions not enabled');
  {$ENDIF}
end;

procedure TDFEngine.ParseError(Sender : TObject; ParseError : Integer);
begin
  ExpError:= ParseError;
end;

procedure TDFEngine.PVCreateCtl(Sender: TObject; AField: TDFField;
  AControl: TWinControl);
begin
  if Assigned(OnPreviewCreateControl) then
    OnPreviewCreateControl(Sender, AField, AControl);
end;

procedure TDFEngine.PVDestroyCtl(Sender: TObject; AField: TDFField;
  AControl: TWinControl);
begin
  if Assigned(OnPreviewDestroyControl) then
    OnPreviewDestroyControl(Sender, AField, AControl);
end;

function TDFEngine.CheckRequiredFields: boolean;
var
  I: integer;
  AField: TDFField;
begin
  Result := true;
  if not (dfEnforceRequired in PreviewOptions) then Exit;

  //loop through all fields
  for I:= 0 to FieldCount-1 do
  begin
    AField:= Fields[I];
    if AField.Required and (AField.FFormat = dfText) and (AField.FData = '') then
    begin
      Result := false;
      Exit;
    end;
  end;
end;


{ TDFForm }

constructor TDFForm.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TDFEngine then Engine:= AOwner as TDFEngine
  else Engine:= nil;
  TempBMP:= TBitmap.create;
  TempSL:= TStringList.create;
  AddNewChild(TDFDefaultLine);
  AddNewChild(TDFDefaultFrame);
  AddNewChild(TDFDefaultLogo);
  AddNewChild(TDFDefaultButton);
  AddNewChild(TDFDefaultText);
  AddNewChild(TDFDefaultField);
  FFormName:= 'Untitled Form';
  FPixelsPerInch:= DEFAULT_PPI;
  FActivePenColor:= clBlack;
  FActivePenStyle:= psClear;
  FActivePenWidth:= 1;
  FActiveColor:= $0080FFFF;
  FActiveBrushColor:= $0080FFFF;
  FActiveBrushStyle:= bsSolid;
  FActiveCheckboxBorder:= true;
end;

destructor TDFForm.Destroy;
begin
  TempBMP.free;
  TempSL.free;
  inherited;
end;

procedure TDFForm.DoChange(AObject: TDFStream; const ALoading: boolean);
begin
  if Engine <> nil then
    Engine.DoChange(AObject, ALoading);
end;

function TDFForm.NextFieldName: string;
var
  i,j,tmpint: integer;
begin
  tmpint:= 1;
  for i:= 0 to Engine.FieldCount-1 do
    if dfonlyalpha(lowercase(Engine.Fields[i].FieldName)) = 'field' then
    begin
      j:= strtointdef(dfonlynumeric(Engine.Fields[i].FieldName),0);
      if tmpint < j+1 then tmpint:= j+1;
    end;
  result:= 'Field'+inttostr(tmpint);
end;

procedure TDFForm._SetPPI(const Value: integer);
var
  i,j,oldPPI: integer;
  DeltaScale: double;
  Page: TDFPage;
  Obj: TDFObject;
begin
  if Value = 0 then Exit;
  OldPPI := FPixelsperInch;
  FPixelsperInch:= Value;
  if IsLoading then Exit;
  DeltaScale:= Value / OldPPI;
  for i:= 0 to Engine.PageCount-1 do
  begin
    Page:= Engine.Pages[i];
    Page.Width:= trunc(Page.Width * DeltaScale);
    Page.Height:= trunc(Page.Height * DeltaScale);
    Page.PaperSize:= Page.PaperSize;
    for j:= 0 to Page.ObjectCount-1 do
    begin
      Obj:= Engine.Pages[i].Objects[j];
      Obj.Left:= trunc(Obj.Left*DeltaScale);
      Obj.Top:= trunc(Obj.Top*DeltaScale);
      Obj.Height:= trunc(Obj.Height*DeltaScale);
      Obj.Width:= trunc(Obj.Width*DeltaScale);
      if Obj is TDFFrame then
      begin
        TDFFrame(Obj).Corner:= trunc(TDFFrame(Obj).Corner*DeltaScale);
      end;
      if Obj is TDFText then
      begin
        TDFText(Obj).FontHeight:= trunc(TDFText(Obj).FontHeight*DeltaScale);
      end;
      if Obj is TDFField then
      begin
        TDFField(Obj).FontHeight:= trunc(TDFField(Obj).FontHeight*DeltaScale);        
      end;
    end;
  end;
  DoChange(Self, IsLoading);
end;

procedure TDFForm._SetFormName(const Value: string);
begin
  FFormName := Value;
  DoChange(Self, IsLoading);
end;

function TDFForm._GetDefaultButton: TDFDefaultButton;
begin
  result:= FindChild(TDFDefaultButton,0) as TDFDefaultButton;
end;

function TDFForm._GetDefaultField: TDFDefaultField;
begin
  result:= FindChild(TDFDefaultField,0) as TDFDefaultField;
end;

function TDFForm._GetDefaultFrame: TDFDefaultFrame;
begin
  result:= FindChild(TDFDefaultFrame,0) as TDFDefaultFrame;
end;

function TDFForm._GetDefaultLine: TDFDefaultLine;
begin
  result:= FindChild(TDFDefaultLine,0) as TDFDefaultLine;
end;

function TDFForm._GetDefaultLogo: TDFDefaultLogo;
begin
  result:= FindChild(TDFDefaultLogo,0) as TDFDefaultLogo;
end;

function TDFForm._GetDefaultText: TDFDefaultText;
begin
  result:= FindChild(TDFDefaultText,0) as TDFDefaultText;
end;


function TDFForm.GetPassword: string;
begin
  if csWriting in ComponentState then result:= FPassword
  else result:= dfCrypt(FPassword);
end;

procedure TDFForm.SetPassword(const Value: string);
begin
  if csReading in ComponentState then FPassword:= Value
  else FPassword:= dfCrypt(Value);
end;

{ TDFPage }

constructor TDFPage.Create(AOwner: TComponent);
begin
  Form:= nil;
  FBackground:= nil;
  inherited;
  FPageName:= 'Untitled Page';
  FPaperSize:= DFLetter;
  FOrientation:= DFPortrait;
  FWidth:= trunc(DEFAULT_PPI * 8.5);
  FHeight:= trunc(DEFAULT_PPI * 11);
  FPrinterOffsetX:= 0;
  FPrinterOffsetY:= 0;
  FColor:= clWhite;
  FPrinterStretch:= true;
  FPrinterDuplex:= false;
  FPrinterColor:= true;
  FBackgroundAlign:= DFStretch;
  FVisible:= true;
  ClearBackground;
end;

destructor TDFPage.Destroy;
begin
  FBackground.free;
  inherited;
end;

procedure TDFPage.AssignParent(AParent: TDefinedStream);
begin
  inherited;
  if AParent is TDFForm then Form:= (AParent as TDFForm);
  DoChange(Self, IsLoading);
end;

procedure TDFPage.DoChange(AObject: TDFStream; const ALoading: boolean);
begin
  if (Form <> nil) and (Form.Engine <> nil) then
    Form.Engine.DoChange(AObject, ALoading);
end;

procedure TDFPage.ClearBackground;
begin
  if FBackground <> nil then FBackground.free;
  FBackground:= TPicture.Create;
  FBackground.OnChange:= BackgroundChange;
  DoChange(Self, IsLoading);
end;

procedure TDFPage.BackgroundChange(Sender: TObject);
begin
  DoChange(Self, IsLoading);
end;

function TDFPage.PageRect: TRect;
begin
  result:= Rect(0,0,Width,Height);
end;

function TDFPage.AddButton: TDFButton;
begin
  result:= AddNewChild(TDFButton) as TDFButton;
end;

function TDFPage.AddField: TDFField;
begin
  result:= AddNewChild(TDFField) as TDFField;
end;

function TDFPage.AddFrame: TDFFrame;
begin
  result:= AddNewChild(TDFFrame) as TDFFrame;
end;

function TDFPage.AddLine: TDFLine;
begin
  result:= AddNewChild(TDFLine) as TDFLine;
end;

function TDFPage.AddLogo: TDFLogo;
begin
  result:= AddNewChild(TDFLogo) as TDFLogo;
end;

function TDFPage.AddText: TDFText;
begin
  result:= AddNewChild(TDFText) as TDFText;
end;

function TDFPage.AddObject(AObjectType: TDFClass): TDFObject;
begin
  result:= TDFObject(AddNewChild(AObjectType));
end;

procedure TDFPage.Delete;
begin
  DoChange(Self, IsLoading);
  inherited;
end;

procedure TDFPage.PaintTo(ACanvas: TCanvas; const ARect: TRect; const CanvasType: TDFCanvasType);
var
  AScale: double;
  i,j, H,W: integer;
  rflag1, rflag2: boolean;
  runit: integer;
begin
  //calculate scale
  if Width = 0 then
    raise EDFError.create('Page width is zero');
  AScale:= (ARect.Right - ARect.Left) / Width;

  //fill page
  if (Background.Graphic = nil) or (Background.Graphic.Empty) or (BackgroundAlign = DFNormal) then
  begin
    ACanvas.Brush.Style:= bsSolid;
    ACanvas.Brush.Color:= Color;
    ACanvas.FillRect(Rect(ARect.Left,ARect.Top,ARect.Left+trunc(Width * AScale),ARect.Top+trunc(Height * AScale)));
  end;

  //draw background
  if (Background.Graphic <> nil) and (not Background.Graphic.Empty) and
     (((CanvasType <> DFPrinter) and (dfShowBackground in Form.Engine.PaintOptions)) or
      ((CanvasType <> DFPrinter) or ((CanvasType = DFPrinter) and (dfPrintBackground in Form.Engine.PaintOptions)))) then
  begin
    if BackgroundAlign = DFNormal then
    begin
      dfStretchDraw( ACanvas, rect(ARect.left,ARect.top,trunc(Background.Graphic.width*AScale),trunc(Background.Graphic.height*AScale) ), Background.Graphic );
    end
    else if BackgroundAlign = DFStretch then
    begin
      dfStretchDraw( ACanvas, ARect, Background.Graphic );
    end
    else if BackgroundAlign = DFTile then
    begin
      H:= trunc(Background.Graphic.height*AScale);
      W:= trunc(Background.Graphic.width*AScale);
      for i:= 0 to (ARect.Right - ARect.Left) div W do
        for j:= 0 to (ARect.Bottom - ARect.Top) div H do
          dfStretchDraw( ACanvas, rect(ARect.left + (i*W),
                                       ARect.top + (j*H),
                                       ARect.left + (i*W) + W,
                                       ARect.top + (j*H) + H),
                       Background.Graphic );
    end;

  end;
  ACanvas.Brush.Style:= bsClear;

  //draw rulers
  if ((CanvasType = DFDesigner) or (CanvasType = DFDesignPrinter)) and (dfShowRulers in Form.Engine.PaintOptions) then
  begin
    ACanvas.Pen.Color:= clSilver;
    ACanvas.Pen.Width:= 1;
    ACanvas.Font.Name:= 'Arial Narrow';
    ACanvas.Font.Style:= [];
    ACanvas.Font.Size:= 8;
    ACanvas.Font.Color:= clSilver;
    for i:= 1 to Width do
    begin
      rflag1:= false;
      rflag2:= false;
      runit:= 0;
      //inches
      if Form.Engine.RulerUnits = DFInches then
      begin
        rflag1:= i mod Form.PixelsPerInch = 0;
        rflag2:= i mod (Form.PixelsPerInch div 2) = 0;
        runit:= i div Form.PixelsPerInch;
      end;
      //centimeters
      if Form.Engine.RulerUnits = DFCentimeters then
      begin
        rflag1:= i mod (trunc(Form.PixelsPerInch * 0.397)) = 0;
        runit:= i div (trunc(Form.PixelsPerInch * 0.397))
      end;
      //pixels
      if Form.Engine.RulerUnits = DFPixels then
      begin
        rflag1:= i mod 100 = 0;
        rflag2:= i mod (100 div 2) = 0;
        runit:= i;
      end;
      //draw?
      if rflag1 then
      begin
        ACanvas.Pen.Style:= psSolid;
        ACanvas.MoveTo(ARect.Left+trunc(i*AScale),ARect.Top);
        ACanvas.LineTo(ARect.Left+trunc(i*AScale),ARect.Bottom);
        ACanvas.TextOut((ARect.Left+trunc(i*AScale))+2,ARect.Top, inttostr(runit));
      end
      else if rflag2 then
      begin
        ACanvas.Pen.Style:= psDot;
        ACanvas.MoveTo(ARect.Left+trunc(i*AScale),ARect.Top);
        ACanvas.LineTo(ARect.Left+trunc(i*AScale),ARect.Bottom);
      end;
    end;
    for i:= 1 to Height do
    begin
      rflag1:= false;
      rflag2:= false;
      runit:= 0;
      //inches
      if Form.Engine.RulerUnits = DFInches then
      begin
        rflag1:= i mod Form.PixelsPerInch = 0;
        rflag2:= i mod (Form.PixelsPerInch div 2) = 0;
        runit:= i div Form.PixelsPerInch;
      end;
      //centimeters
      if Form.Engine.RulerUnits = DFCentimeters then
      begin
        rflag1:= i mod (trunc(Form.PixelsPerInch * 0.397)) = 0;
        runit:= i div (trunc(Form.PixelsPerInch * 0.397))
      end;
      //pixels
      if Form.Engine.RulerUnits = DFPixels then
      begin
        rflag1:= i mod 100 = 0;
        rflag2:= i mod (100 div 2) = 0;
        runit:= i;
      end;
      //draw?
      if rflag1 then
      begin
        ACanvas.Pen.Style:= psSolid;
        ACanvas.MoveTo(ARect.Left,ARect.Top+trunc(i*AScale));
        ACanvas.LineTo(ARect.Right,ARect.Top+trunc(i*AScale));
        ACanvas.TextOut(ARect.Left,(ARect.Top+trunc(i*AScale))-2, inttostr(runit));
      end
      else if rflag2 then
      begin
        ACanvas.Pen.Style:= psDot;
        ACanvas.MoveTo(ARect.Left,ARect.Top+trunc(i*AScale));
        ACanvas.LineTo(ARect.Right,ARect.Top+trunc(i*AScale));
      end;
    end;
  end;

  //draw margins
  if ((CanvasType = DFDesigner) or (CanvasType = DFDesignPrinter)) and (dfShowMargins in Form.Engine.PaintOptions) and (not PrinterStretch) and
     (PrinterXmargin > 0) and (PrinterYmargin > 0) and (PrinterXDPI > 0) and (PrinterYDPI > 0) then
  begin
    ACanvas.Pen.Color:= clTeal;
    ACanvas.Pen.Style:= psDot;
    ACanvas.Pen.Width:= 1;
    ACanvas.Brush.Style:= bsClear;
    ACanvas.Font.Name:= 'Arial Narrow';
    ACanvas.Font.Style:= [fsItalic];
    ACanvas.Font.Size:= 8;
    ACanvas.Font.Color:= clTeal;
    ACanvas.Rectangle(  Rect( trunc((PrinterXmargin/(PrinterXdpi / Form.PixelsPerInch))*AScale),
                              trunc((PrinterYmargin/(PrinterYdpi / Form.PixelsPerInch))*AScale),
                              trunc((Width-(PrinterXmargin/(PrinterXdpi / Form.PixelsPerInch)))*AScale),
                              trunc((Height-(PrinterYmargin/(PrinterYdpi / Form.PixelsPerInch)))*AScale)) );
    ACanvas.TextOut( trunc((PrinterXmargin/(PrinterXdpi / Form.PixelsPerInch))*AScale)+4,
                     trunc((PrinterYmargin/(PrinterYdpi / Form.PixelsPerInch))*AScale), PrinterName );
  end;

  //draw objects
  for i:= 0 to ObjectCount-1 do
    if (Objects[i].visible or ((CanvasType = DFDesigner) or (CanvasType = DFDesignPrinter))) and
       (Objects[i].prints or ((CanvasType = DFDesigner) or (CanvasType = DFDisplay) or (CanvasType = DFActive))) then
    begin
      if (not (dfShowFields in Form.Engine.PaintOptions)) and (Objects[i] is TDFField) then continue;
      if (not (dfShowForm in Form.Engine.PaintOptions)) and (not(Objects[i] is TDFField)) then continue;
      Objects[i].PaintTo(ACanvas, AScale, ARect, CanvasType);
    end;
end;

procedure TDFPage.PaintTo(ACanvas: TCanvas; const ARect: TRect);
begin
  PaintTo(ACanvas, ARect, DFDisplay);
end;

procedure TDFPage._SetPaperSize(const Value: TDFPaperSize);
var tmpint: integer;
begin
  FPaperSize := Value;
  if Form <> nil then
  begin
    case PaperSize of
      DFLetter:
      begin
        FWidth:= trunc(Form.PixelsPerInch * 8.5);
        FHeight:= trunc(Form.PixelsPerInch * 11);
      end;
      DFLegal:
      begin
        FWidth:= trunc(Form.PixelsPerInch * 8.5);
        FHeight:= trunc(Form.PixelsPerInch * 14);
      end;
      DFA3:
      begin
        FWidth:= trunc(Form.PixelsPerInch * 11.69);
        FHeight:= trunc(Form.PixelsPerInch * 16.54);
      end;
      DFA4:
      begin
        FWidth:= trunc(Form.PixelsPerInch * 8.25);
        FHeight:= trunc(Form.PixelsPerInch * 11.69);
      end;
      DFA5:
      begin
        FWidth:= trunc(Form.PixelsPerInch * 5.83);
        FHeight:= trunc(Form.PixelsPerInch * 8.25);
      end;
    end;

    if (Orientation = DFLandscape) and (Papersize <> DFCustomPaper) then
    begin
      tmpint:= FWidth;
      FWidth:= FHeight;
      FHeight:= tmpint;
    end;
  end;
  DoChange(Self, IsLoading);

  if (Form <> nil) and (Form.Engine <> nil) and assigned(Form.Engine.OnDimChange) then
    Form.Engine.OnDimChange(Form.Engine, Self, IsLoading);
end;

procedure TDFPage._SetOrientation(const Value: TDFOrientation);
begin
  FOrientation := Value;
  PaperSize:= PaperSize;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetHeight(const Value: integer);
begin
  FHeight := Value;
  if not IsLoading then
    PaperSize:= PaperSize;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetWidth(const Value: integer);
begin
  FWidth := Value;
  if not IsLoading then
    PaperSize:= PaperSize;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetBackgroundAlign(const Value: TDFBackgroundAlign);
begin
  FBackgroundAlign := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetColor(const Value: TColor);
begin
  FColor := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetPageName(const Value: string);
begin
  FPageName := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetPrinterColor(const Value: boolean);
begin
  FPrinterColor := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetPrinterDuplex(const Value: boolean);
begin
  FPrinterDuplex := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetPrinterStretch(const Value: boolean);
begin
  FPrinterStretch := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetPrinterOffsetX(const Value: integer);
begin
  FPrinterOffsetX := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetPrinterOffsetY(const Value: integer);
begin
  FPrinterOffsetY := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage.SetVisible(const Value: boolean);
begin
  FVisible:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFPage._SetBackground(const Value: TPicture);
begin
  FBackground.Assign(Value);
  DoChange(Self, IsLoading);
end;

function TDFPage._GetObject(Index: integer): TDFObject;
begin
  result:= Components[index] as TDFObject;
end;

function TDFPage._GetObjectCount: integer;
begin
  result:= ComponentCount;
end;

function TDFPage._GetButton(Index: integer): TDFButton;
begin
  result:= FindChild(TDFButton,Index) as TDFButton;
end;

function TDFPage._GetButtonCount: integer;
begin
  result:= CountChildren(TDFButton);
end;

function TDFPage._GetField(Index: integer): TDFField;
begin
  result:= FindChild(TDFField,Index) as TDFField;
end;

function TDFPage._GetFieldCount: integer;
begin
  result:= CountChildren(TDFField);
end;

function TDFPage._GetFrame(Index: integer): TDFFrame;
begin
  result:= FindChild(TDFFrame,Index) as TDFFrame;
end;

function TDFPage._GetFrameCount: integer;
begin
  result:= CountChildren(TDFFrame);
end;

function TDFPage._GetLine(Index: integer): TDFLine;
begin
  result:= FindChild(TDFLine,Index) as TDFLine;
end;

function TDFPage._GetLineCount: integer;
begin
  result:= CountChildren(TDFLine);
end;

function TDFPage._GetLogo(Index: integer): TDFLogo;
begin
  result:= FindChild(TDFLogo,Index) as TDFLogo;
end;

function TDFPage._GetLogoCount: integer;
begin
  result:= CountChildren(TDFLogo);
end;

function TDFPage._GetText(Index: integer): TDFText;
begin
  result:= FindChild(TDFText,Index) as TDFText;
end;

function TDFPage._GetTextCount: integer;
begin
  result:= CountChildren(TDFText);
end;

function TDFPage._StoreWH: Boolean;
begin
  result:= (Papersize = DFCustomPaper) or (Form = nil) or (Form.PixelsPerInch <> DEFAULT_PPI);
end;

function TDFPage.FindFieldTab(const Taborder: integer): TDFField;
var I: integer;
begin
  result:= nil;
  for I:= 0 to FieldCount-1 do
    if Fields[I].taborder = taborder then
    begin
      result:= Fields[I];
      break;
    end;
end;

function TDFPage.FindFieldFirstTab(const Taborder: integer): TDFField;
var
  x,tmpint: integer;
begin
  tmpint:= 32767;
  for x:= 0 to FieldCount-1 do
    if (Fields[x].visible) and (Fields[x].Active) then
      if Fields[x].TabOrder < tmpint then
        tmpint:= Fields[x].TabOrder;
  if tmpint > -1 then
    result:= FindFieldTab(tmpint)
  else
    result:= nil;
end;

function TDFPage.FindFieldLastTab(const Taborder: integer): TDFField;
var
  x,tmpint: integer;
begin
  tmpint:= -1;
  for x:= 0 to FieldCount-1 do
    if (Fields[x].visible) and (Fields[x].Active) then
      if Fields[x].TabOrder > tmpint then
        tmpint:= Fields[x].TabOrder;
  if tmpint > -1 then
    result:= FindFieldTab(tmpint)
  else
    result:= nil;
end;

function TDFPage.FindFieldNextTab(const Taborder: integer): TDFField;
var x, lowtab, neartab: integer;
    lowest, nearest: TDFField;

  procedure CheckCtl(ctl: TDFField);
  begin
    if ctl.taborder = taborder then Exit;
    if not ctl.Visible then Exit;
    if not ctl.Active then Exit;
    if ctl.taborder < 0 then Exit;
    {is it lowest?}
    if ctl.TabOrder < lowtab then
    begin
      lowest:= ctl;
      lowtab:= ctl.TabOrder;
    end;
    {is it nearest?}
    if (ctl.TabOrder < neartab) and
       (ctl.TabOrder > TabOrder) then
    begin
      nearest:= ctl;
      neartab:= ctl.TabOrder;
    end;
  end;
begin
  result:= nil;
  if TabOrder < 0 then Exit;
  {defaults}
  lowtab:= 32767;
  neartab:= 32767;
  lowest:= nil;
  nearest:= nil;
  {look thru all controls}
  for x:= 0 to FieldCount-1 do
  begin
    CheckCtl(Fields[x]); {compare taborder}
    if neartab = TabOrder+1 then break; {break if next}
  end;
  {activate}
  if neartab < 32767 then result:= nearest
  else if lowtab < 32767 then result:= lowest;
end;

function TDFPage.FindFieldPrevTab(const Taborder: integer): TDFField;
var x, hightab, neartab: integer;
    highest, nearest: TDFField;

  procedure CheckCtl(ctl: TDFField);
  begin
    if ctl.taborder = taborder then Exit;
    if not ctl.Visible then Exit;
    if not ctl.Active then Exit;
    if ctl.taborder < 0 then Exit;
    {is it highest?}
    if ctl.TabOrder > hightab then
    begin
      highest:= ctl;
      hightab:= ctl.TabOrder;
    end;
    {is it nearest?}
    if (ctl.TabOrder > neartab) and
       (ctl.TabOrder < TabOrder) then
    begin
      nearest:= ctl;
      neartab:= ctl.TabOrder;
    end;
  end;

begin
  result:= nil;
  if TabOrder < 0 then Exit;
  {defaults}
  hightab:= -32767;
  neartab:= -32767;
  highest:= nil;
  nearest:= nil;
  {look thru all controls}
  for x:= 0 to FieldCount-1 do
  begin
    CheckCtl(Fields[x]); {compare taborder}
    if neartab = TabOrder-1 then break; {break if prev}
  end;
  {activate}
  if neartab > -32767 then result:= nearest
  else if hightab > -32767 then result:= highest;
end;

function TDFPage.FindField(const FieldName: string): TDFField;
var j: integer;
begin
  result:= nil;
  for j:= 0 to FieldCount-1 do
  begin
    if sametext(Fields[j].FieldName, FieldName) then
    begin
      result:= Fields[j];
      Exit;
    end;
  end;
end;

{ TDFObject }

constructor TDFObject.Create(AOwner: TComponent);
begin
  Page:= nil;
  DefaultObject:= nil;
  FForceStore:= false;
  inherited;
  FLeft:= 0;
  FTop:= 0;
  FWidth:= 0;
  FHeight:= 0;
  FVisible:= true;
  FPrints:= true;
  FAutosize:= false;
  FAlignment:= DFLeft;
  FPenColor:= clBlack;
  FPenStyle:= psClear;
  FPenWidth:= 1;
  FBrushColor:= clWhite;
  FBrushStyle:= bsClear;
  FFontName:= 'Arial';
  FFontHeight:= -11;
  FFontColor:= clBlack;
  FFontStyle:= [];
  FFontCharset:= ANSI_CHARSET;
end;

function TDFObject.GetLeft: integer;
begin
  result:= FLeft;
end;

function TDFObject.GetTop: integer;
begin
  result:= FTop;
end;

function TDFObject.GetWidth: integer;
begin
  result:= FWidth;
end;

function TDFObject.GetHeight: integer;
begin
  result:= FHeight;
end;

procedure TDFObject.SetLeft(const Value: integer);
begin
  FLeft:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject.SetTop(const Value: integer);
begin
  FTop:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject.SetWidth(const Value: integer);
begin
  FWidth:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject.SetHeight(const Value: integer);
begin
  FHeight:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject.SetVisible(const Value: boolean);
begin
  FVisible:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject.SetPrints(const Value: boolean);
begin
  FPrints:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject.Delete;
begin
  DoChange(Self, IsLoading);
  inherited;
end;

procedure TDFObject.DoChange(AObject: TDFStream; const ALoading: boolean);
begin
  if (Page <> nil) and (Page.Form <> nil) and (Page.Form.Engine <> nil) then
    Page.Form.Engine.DoChange(AObject, ALoading);
end;

procedure TDFObject.AssignParent(AParent: TDefinedStream);
begin
  inherited;
  DoChange(Self, IsLoading);
  if (AParent is TDFPage) and ((AParent as TDFPage).Form <> nil) then
  begin
    Page:= (AParent as TDFPage);
    if (Self is TDFLine) then DefaultObject:= Page.Form.DefaultLine;
    if (Self is TDFFrame) then DefaultObject:= Page.Form.DefaultFrame;
    if (Self is TDFLogo) then DefaultObject:= Page.Form.DefaultLogo;
    if (Self is TDFButton) then DefaultObject:= Page.Form.DefaultButton;
    if (Self is TDFText) then DefaultObject:= Page.Form.DefaultText;
    if (Self is TDFField) then DefaultObject:= Page.Form.DefaultField;
    if IsLoading and (DefaultObject <> nil) then
      Assign(DefaultObject);
  end;
end;

procedure TDFObject.PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType);
begin
  //setup brush
  ACanvas.Brush.Color:= BrushColor;
  if (dfPrintShading in Page.Form.Engine.PaintOptions) then ACanvas.Brush.Style:= BrushStyle
  else ACanvas.Brush.Style:= bsClear;
  //setup pen
  ACanvas.Pen.Width:= 1;
  ACanvas.Pen.Color:= PenColor;
  ACanvas.Pen.Style:= PenStyle;
  if (ACanvas.Pen.Color = ACanvas.Brush.Color) and (ACanvas.Brush.Style <> bsClear) then
    ACanvas.Pen.Style:= psClear;
end;

procedure TDFObject._SetAlignment(const Value: TDFAlignment);
begin
  FAlignment:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetAutosize(const Value: boolean);
begin
  FAutosize:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetBrushColor(const Value: TColor);
begin
  FBrushColor:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetBrushStyle(const Value: TBrushStyle);
begin
  FBrushStyle:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetFontCharset(const Value: TFontCharset);
begin
  FFontCharset:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetFontColor(const Value: TColor);
begin
  FFontColor:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetFontName(const Value: string);
begin
  FFontName:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetFontStyle(const Value: TFontStyles);
begin
  FFontStyle:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetPenColor(const Value: TColor);
begin
  FPenColor:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetPenStyle(const Value: TPenStyle);
begin
  FPenStyle:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetPenWidth(const Value: integer);
begin
  FPenWidth:= Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetFontHeight(const Value: integer);
begin
  FFontHeight := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFObject._SetFontSize(const Value: integer);
begin
  if (Page <> nil) and (Value > 0) and (Page.Form.PixelsPerInch > 0) then
    FFontHeight := -MulDiv(Value, Page.Form.PixelsPerInch, 72)
  else
    FFontHeight := -MulDiv(Value, DEFAULT_PPI, 72);
  DoChange(Self, IsLoading);
end;

function TDFObject._GetFontSize: integer;
begin
  if (Page <> nil) and (Page.Form.PixelsPerInch > 0) then
    result := -MulDiv(FontHeight, 72, Page.Form.PixelsPerInch)
  else
    result := -MulDiv(FontHeight, 72, DEFAULT_PPI);
end;

function TDFObject._StoreHW: boolean;
begin
  result:= ForceStore or (not FAutoSize);
end;

function TDFObject._StoreBrushColor: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.BrushColor <> BrushColor);
end;

function TDFObject._StoreBrushStyle: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.BrushStyle <> BrushStyle);
end;

function TDFObject._StoreFontCharset: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.FontCharset <> FontCharset);
end;

function TDFObject._StoreFontColor: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.FontColor <> FontColor);
end;

function TDFObject._StoreFontName: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.FontName <> FontName);
end;

function TDFObject._StoreFontStyle: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.FontStyle <> FontStyle);
end;

function TDFObject._StoreFontHeight: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.FontHeight <> FontHeight);
end;

function TDFObject._StorePenColor: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.PenColor <> PenColor);
end;

function TDFObject._StorePenStyle: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.PenStyle <> PenStyle);
end;

function TDFObject._StorePenWidth: boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.PenWidth <> PenWidth);
end;

function TDFObject._StoreAutosize: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.AutoSize <> AutoSize);
end;

function TDFObject._StoreAlignment: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or (DefaultObject.Alignment <> Alignment);
end;


{ TDFLine }

constructor TDFLine.Create(AOwner: TComponent);
begin
  inherited;
  FX1:= 0;
  FY1:= 0;
  FX2:= 100;
  FY2:= 100;
  FPenColor:= clBlack;
  FPenStyle:= psSolid;
  if (not IsLoading) and (DefaultObject <> nil) then
    Assign(DefaultObject);
end;

procedure TDFLine.PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType);
begin
  inherited;
  ACanvas.Brush.Style:= bsClear;
  ACanvas.Pen.Width:= trunc(PenWidth * AScale);
  if (ACanvas.Pen.Width = 0) and ((PenWidth * AScale) > LINE_THRESH) then ACanvas.Pen.Width:= 1;
  ACanvas.moveto(ARect.Left+(trunc(X1 * AScale)), ARect.Top+(trunc(Y1 * AScale)));
  ACanvas.lineto(ARect.Left+(trunc(X2 * AScale)), ARect.Top+(trunc(Y2 * AScale)));
end;

function TDFLine.GetLeft: integer;
begin
  if X1 < X2 then
    result:= X1
  else
    result:= X2;
end;

function TDFLine.GetTop: integer;
begin
  if Y1 < Y2 then
    result:= Y1
  else
    result:= Y2;
end;

function TDFLine.GetWidth: integer;
begin
  if X1 < X2 then
    result:= X2 - X1
  else
    result:= X1 - X2;
end;

function TDFLine.GetHeight: integer;
begin
  if Y1 < Y2 then
    result:= Y2 - Y1
  else
    result:= Y1 - Y2;
end;

procedure TDFLine.SetLeft(const Value: integer);
begin
  if X1 < X2 then
  begin
    X2:= Value + (X2-X1);
    X1:= Value;
  end
  else begin
    X1:= Value + (X1-X2);
    X2:= Value;
  end;
  DoChange(Self, IsLoading);
end;

procedure TDFLine.SetTop(const Value: integer);
begin
  if Y1 < Y2 then
  begin
    Y2:= Value + (Y2-Y1);
    Y1:= Value;
  end
  else begin
    Y1:= Value + (Y1-Y2);
    Y2:= Value;
  end;
  DoChange(Self, IsLoading);
end;

procedure TDFLine.SetWidth(const Value: integer);
begin
  if X1 < X2 then
    X2:= X1 + Value
  else
    X1:= X2 + Value;
  DoChange(Self, IsLoading);
end;

procedure TDFLine.SetHeight(const Value: integer);
begin
  if Y1 < Y2 then
    Y2:= Y1 + Value
  else
    Y1:= Y2 + Value;
  DoChange(Self, IsLoading);
end;

procedure TDFLine._SetX1(const Value: integer);
begin
  FX1 := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFLine._SetX2(const Value: integer);
begin
  FX2 := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFLine._SetY1(const Value: integer);
begin
  FY1 := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFLine._SetY2(const Value: integer);
begin
  FY2 := Value;
  DoChange(Self, IsLoading);
end;

{ TDFFrame }

constructor TDFFrame.Create(AOwner: TComponent);
begin
  inherited;
  FFrameType:= DFSquare;
  FCorner:= 0;
  FWidth:= 100;
  FHeight:= 100;
  FPenColor:= clBlack;
  FPenStyle:= psSolid;
  FBrushColor:= clWhite;
  FBrushStyle:= bsClear;
  if (not IsLoading) and (DefaultObject <> nil) then
    Assign(DefaultObject);
end;

procedure TDFFrame.PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType);
var
  R: TRect;
  PW: integer;
begin
  inherited;
  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );
  PW:= trunc(PenWidth * AScale);
  if (PW = 0) and ((PenWidth * AScale) > LINE_THRESH) then PW:= 1;
  while PW > 0 do
  begin
    case FFrameType of
      DFSquare: ACanvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
      DFRound: ACanvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,
        trunc(FCorner * AScale), trunc(FCorner * AScale));
      DFEllipse: ACanvas.Ellipse(R.Left,R.Top,R.Right,R.Bottom);
    end;
    InflateRect(R,-1,-1);
    dec(PW);
  end;
end;

procedure TDFFrame._SetCorner(const Value: integer);
begin
  FCorner := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFFrame._SetFrameType(const Value: TDFFrameType);
begin
  FFrameType := Value;
  DoChange(Self, IsLoading);
end;

function TDFFrame._StoreCorner: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFFrame).Corner <> Corner);
end;

function TDFFrame._StoreFrameType: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFFrame).FrameType <> FrameType);
end;

{ TDFLogo }

constructor TDFLogo.Create(AOwner: TComponent);
begin
  inherited;
  FPicture:= TPicture.Create;
  FPicture.OnChange:= _PictureChange;
  FTransparent:= true;
  FStretch:= false;
  FAutosize:= false;
  FWidth:= 100;
  FHeight:= 100;
  if (not IsLoading) and (DefaultObject <> nil) then
    Assign(DefaultObject);
end;

destructor TDFLogo.Destroy;
begin
  FPicture.free;
  inherited;
end;

procedure TDFLogo.PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType);
var R: TRect;
begin
  inherited;
  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );
  ACanvas.Brush.Style:= bsClear;
  ACanvas.Pen.Color:= clTeal;
  ACanvas.Pen.Style:= psDash;
  if (Picture.Graphic <> nil) and (not Picture.Graphic.Empty) then
  begin
    Picture.Graphic.Transparent:= Transparent;
    if Stretch then
    begin
      dfStretchDraw(ACanvas, R, Picture.Graphic);
    end
    else begin
      R.Right:= R.Left + trunc(Picture.Graphic.Width * AScale);
      R.Bottom:= R.Top + trunc(Picture.Graphic.Height * AScale);
      dfStretchDraw(ACanvas, R, Picture.Graphic);
    end;
  end
  else begin
    if CanvasType in [dfDesigner, dfDesignPrinter] then
      ACanvas.Rectangle(R);
  end;
end;

function TDFLogo.GetHeight: integer;
begin
  if (not Autosize) or (Picture.Graphic = nil) or (Picture.Graphic.Empty) then result:= inherited GetHeight
  else result:= Picture.Graphic.Height;
end;

function TDFLogo.GetWidth: integer;
begin
  if (not Autosize) or (Picture.Graphic = nil) or (Picture.Graphic.Empty) then result:= inherited GetWidth
  else result:= Picture.Graphic.Width;
end;

procedure TDFLogo._SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
  DoChange(Self, IsLoading);
end;

procedure TDFLogo._SetStretch(const Value: boolean);
begin
  FStretch := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFLogo._SetTransparent(const Value: boolean);
begin
  FTransparent := Value;
  DoChange(Self, IsLoading);
end;

function TDFLogo._StoreStretch: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFLogo).Stretch <> Stretch);
end;

function TDFLogo._StoreTransparent: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFLogo).Transparent <> Transparent);
end;

procedure TDFLogo._PictureChange(Sender: TObject);
begin
  DoChange(Self, IsLoading);
end;

{ TDFButton }

constructor TDFButton.Create(AOwner: TComponent);
begin
  inherited;
  FCaption:= 'Button';
  FPrints:= false;
  FHeight:= 25;
  FWidth:= 75;
  FPenColor:= clBlack;
  FPenStyle:= psSolid;
  FBrushColor:= clSilver;
  FBrushStyle:= bsSolid;
  FFontStyle:= [fsBold];
  if (not IsLoading) and (DefaultObject <> nil) then
    Assign(DefaultObject);
end;

procedure TDFButton.PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType);
var
  R: TRect;
  PW,TW,TH: integer;
begin
  inherited;
  //borrowed from frame paint
  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );
  PW:= trunc(PenWidth * AScale);
  if (PW = 0) and ((PenWidth * AScale) > LINE_THRESH) then PW:= 1;
  while PW > 0 do
  begin
    ACanvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
    InflateRect(R,-1,-1);
    dec(PW);
  end;

  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );

  ACanvas.Brush.Style:= bsClear;
  ACanvas.Font.Charset:= FontCharset;
  ACanvas.Font.Color:= FontColor;
  ACanvas.Font.Style:= FontStyle;
  ACanvas.Font.Name:= FontName;
  ACanvas.Font.Height:= trunc(FontHeight * AScale);
  TW:= ACanvas.TextWidth(Caption)+2;
  TH:= ACanvas.TextHeight('Xy')+2;
  ACanvas.TextRect(R, R.Left+(((R.Right-R.Left)-TW) div 2), R.Top+(((R.Bottom-R.Top)-TH) div 2), Caption);
end;

procedure TDFButton._SetCaption(const Value: string);
begin
  FCaption := Value;
  DoChange(Self, IsLoading);
end;

{ TDFText }

constructor TDFText.Create(AOwner: TComponent);
begin
  inherited;
  FAutosize:= true;
  FText:= 'Text';
  FAngle:= 0;
  FLineSpacing:= 0;
  if (not IsLoading) and (DefaultObject <> nil) then
    Assign(DefaultObject);
end;

procedure TDFText.PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType);
var
  R: TRect;
  PW,TW,TH, offX,offY,
  countS, Just, X: integer;
  NewHFont,
  OldHFont: HFont;
  LogFont: TLogFont;
begin
  inherited;

  //Borders
  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );
  PW:= trunc(PenWidth * AScale);
  if (PW = 0) and ((PenWidth * AScale) > LINE_THRESH) then PW:= 1;
  while PW > 0 do
  begin
    ACanvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
    InflateRect(R,-1,-1);
    dec(PW);
  end;
  ACanvas.Brush.Style:= bsClear;

  //Font
  ACanvas.Font.Charset:= FontCharset;
  ACanvas.Font.Color:= FontColor;
  ACanvas.Font.Style:= FontStyle;
  ACanvas.Font.Name:= FontName;
  ACanvas.Font.Height:= trunc(FontHeight * AScale);

  TH:= ACanvas.TextHeight('Xy')+2;
  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );
  InflateRect(R,1,1);

  //text
  if (pos(#13, Text) > 0) then
    Page.Form.TempSL.Text:= Text
  else
    Page.Form.TempSL.clear;

  //wordwrap
  if Wordwrap then
  begin
    Page.Form.TempSL.clear;
    dfWordWrap(Text, Page.Form.TempSL, ACanvas, R);
  end;

  //Single line Text
  if (Page.Form.TempSL.count = 0) then
  begin
    TW:= ACanvas.TextWidth(Text)+2;
    if Angle = 0 then //normal text
    begin
      //right & center justify
      offX:= 1;
      if Alignment = DFRight then
        offX:= (R.Right-R.Left) - TW;
      if Alignment = DFCentered then
        offX:= ((R.Right-R.Left) - TW) div 2;
      if offX < 1 then offX:= 1;
      //fully justified
      Just:= 0;
      if Alignment = DFJustified then
      begin
        countS:= dfCountSpaces(FText);
        if (R.Right-R.Left) > TW then
          Just:= (R.Right-R.Left) - TW;
        if (countS > 0) and (Just > 0) then
          SetTextJustification(ACanvas.Handle, Just, CountS);
      end;
      //draw text
      if AutoSize then
        ACanvas.TextOut(R.Left+offX,R.Top, FText)
      else
        ACanvas.TextRect(R, R.Left+offX,R.Top, FText);
      //un-justify
      if Just > 0 then
        SetTextJustification(ACanvas.handle, 0, 0);
    end
    else begin
      //angled text
      GetObject (ACanvas.Font.Handle, sizeof(TLogFont), @LogFont);
      LogFont.lfEscapement := Angle * 10;
      NewHFont:= CreateFontIndirect (LogFont);
      OldHFont:= SelectObject (ACanvas.Handle, NewHFont);
      ACanvas.TextOut(R.Left,R.Top, FText);
      NewHFont:= SelectObject(ACanvas.Handle, OldHFont);
      DeleteObject (NewHFont);
    end;
  end

  //Multiline Text
  else begin
    offY:= 0;
    //draw it
    for x:= 0 to Page.Form.TempSL.count-1 do
    begin
      TW:= ACanvas.TextWidth(Page.Form.TempSL[x])+2;
      //right & center justify
      offX:= 1;
      if Alignment = DFRight then
        offX:= (R.Right-R.Left) - TW;
      if Alignment = DFCentered then
        offX:= ((R.Right-R.Left) - TW) div 2;
      if offX < 1 then offX:= 1;
      //fully justified
      Just:= 0;
      if (Alignment = DFJustified) and (X < Page.Form.TempSL.count-1) then
      begin
        countS:= dfCountSpaces(Page.Form.TempSL[x]);
        if (R.Right-R.Left) > TW then
          Just:= (R.Right-R.Left) - TW;
        if (countS > 0) and (Just > 0) then
          SetTextJustification(ACanvas.Handle, Just, CountS);
      end;
      //draw text
      if AutoSize then
        ACanvas.TextOut(R.Left+offX, R.Top+offY, Page.Form.TempSL[x])
      else
        ACanvas.TextRect(R, R.Left+offX,R.Top+offY, Page.Form.TempSL[x]);
      //un-justify
      if Just > 0 then
        SetTextJustification(ACanvas.handle, 0, 0);
      //line spacing
      if LineSpacing > 0 then
        inc(offY, trunc(LineSpacing * Ascale))
      else
        inc(offY, TH);
    end;
  end;
  Page.Form.TempSL.clear;
end;

function TDFText.GetHeight: integer;
begin
  if (Page = nil) or (not Autosize) then result:= inherited GetHeight
  else begin
    Page.Form.TempBMP.Canvas.Font.Charset:= FontCharset;
    Page.Form.TempBMP.Canvas.Font.Color:= FontColor;
    Page.Form.TempBMP.Canvas.Font.Name:= FontName;
    Page.Form.TempBMP.Canvas.Font.Style:= FontStyle;
    Page.Form.TempBMP.Canvas.Font.Height:= FontHeight;

    if (Text <> '') and (pos(#13, Text) > 0) then
    begin
      Page.Form.TempSL.Text:= Text;
      if LineSpacing > 0 then
        result:= LineSpacing * Page.Form.TempSL.count
      else
        result:= (Page.Form.TempBMP.Canvas.textheight('Xy')+2)*Page.Form.TempSL.count;
      Page.Form.TempSL.clear;
    end
    else
      result:= Page.Form.TempBMP.Canvas.textheight('Xy')+2;
    FHeight:= result;
  end;
end;

function TDFText.GetWidth: integer;
var
  x: integer;
begin
  if (Page = nil) or (not Autosize) then result:= inherited GetWidth
  else begin
    Page.Form.TempBMP.Canvas.Font.Charset:= FontCharset;
    Page.Form.TempBMP.Canvas.Font.Color:= FontColor;
    Page.Form.TempBMP.Canvas.Font.Name:= FontName;
    Page.Form.TempBMP.Canvas.Font.Style:= FontStyle;
    Page.Form.TempBMP.Canvas.Font.Height:= FontHeight;
    if (Text <> '') and (pos(#13, Text) > 0) then
    begin
      Page.Form.TempSL.Text:= Text;
      result:= 0;
      for x:= 0 to Page.Form.TempSL.count-1 do
        if Page.Form.TempBMP.Canvas.textwidth(Page.Form.TempSL[x])+2 > result then
          result:= Page.Form.TempBMP.Canvas.textwidth(Page.Form.TempSL[x])+2;
      Page.Form.TempSL.clear;
    end
    else begin
      if Text = '' then
        result:= Page.Form.TempBMP.Canvas.textwidth('X')+2
      else
        result:= Page.Form.TempBMP.Canvas.textwidth(Text)+2;
    end;
    FWidth:= result;
  end;
end;

procedure TDFText._SetAngle(const Value: integer);
begin
  FAngle := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFText._SetLineSpacing(const Value: integer);
begin
  FLineSpacing := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFText._SetText(const Value: string);
begin
  FText := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFText._SetWordwrap(const Value: boolean);
begin
  FWordwrap := Value;
  DoChange(Self, IsLoading);
end;

function TDFText._StoreAngle: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFText).Angle <> Angle);
end;

function TDFText._StoreLineSpacing: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFText).LineSpacing <> LineSpacing);
end;

function TDFText._StoreWordwrap: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFText).Wordwrap <> Wordwrap);
end;

{ TDFField }

constructor TDFField.Create(AOwner: TComponent);
begin
  inherited;
  FAutosize:= true;
  FFormat:= DFText;
  FCheckIndex:= 0;
  FMaxLength:= 0;
  FActiveMinWidth:= 80;
  FHelpContext:= 0;
  FLineSpacing:= 0;
  FHeight:= 16;
  FWidth:= 100;
  FFieldName:= 'Field';
  FTabOrder:= -1;
  FActive:= false;
  FStore:= true;
  FShowZero:= false;
  if (not IsLoading) and (DefaultObject <> nil) then
  begin
    Assign(DefaultObject);
    SetFieldname(Page.Form.NextFieldName); //assign next name to new field
    TabOrder:= Page.FieldCount-1; //assign next tab order
  end;
end;

procedure TDFField.PaintTo(ACanvas: TCanvas; const AScale: double; const ARect: TRect; const CanvasType: TDFCanvasType);
var
  R: TRect;
  PW,TW,TH, offX,offY,
  countS, Just, x: integer;
  Text: string;
begin
  inherited;

  //Borders
  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );

  //active canvas
  if Active and ((CanvasType = DFActive) or (CanvasType = DFDesigner)) then
  begin
{    if PenStyle <> psDotted then
    begin}
      ACanvas.Brush.Color:= Page.Form.ActiveBrushColor;
      ACanvas.Brush.Style:= Page.Form.ActiveBrushStyle;
      if not (dfPrintShading in Page.Form.Engine.PaintOptions) then
        ACanvas.Brush.Style:= bsClear;
      if (Format = dfCheckbox) and (Page.Form.ActiveCheckboxBorder) then
      begin
        ACanvas.Pen.Style:= psSolid;
        ACanvas.Pen.Width:= 2;
      end
      else begin
        ACanvas.Pen.Style:= Page.Form.ActivePenStyle;
        ACanvas.Pen.Width:= 1;
      end;
      if (ACanvas.Pen.Color = ACanvas.Brush.Color) and (ACanvas.Brush.Style <> bsClear) then
        ACanvas.Pen.Style:= psClear;
      PW:= trunc(Page.Form.ActivePenWidth * AScale);
      if (PW = 0) and ((PenWidth * AScale) > LINE_THRESH) then PW:= 1;
      while PW > 0 do
      begin
        ACanvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
        InflateRect(R,-1,-1);
        dec(PW);
      end;
{    end
    else begin
      //microdot
      ACanvas.Brush.Style:= bsSolid;
      ACanvas.Brush.Color:= Page.Form.ActivePenColor;
      ACanvas.DrawFocusRect(R);
      ACanvas.Brush.Color:= Page.Color;
      ACanvas.DrawFocusRect(R);
    end;}
  end
  else begin
    //nonactive or printing canvas
    ACanvas.Brush.Color:= BrushColor;
    ACanvas.Brush.Style:= BrushStyle;
    if not (dfPrintShading in Page.Form.Engine.PaintOptions) then
      ACanvas.Brush.Style:= bsClear;
    ACanvas.Pen.Style:= PenStyle;
    ACanvas.Pen.Width:= 1;
    if (ACanvas.Pen.Color = ACanvas.Brush.Color) and (ACanvas.Brush.Style <> bsClear) then
      ACanvas.Pen.Style:= psClear;
    PW:= trunc(PenWidth * AScale);
    if (PW = 0) and ((PenWidth * AScale) > LINE_THRESH) then PW:= 1;
    while PW > 0 do
    begin
      ACanvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
      InflateRect(R,-1,-1);
      dec(PW);
    end;
  end;
  ACanvas.Brush.Style:= bsClear;

  //Font
  ACanvas.Font.Charset:= FontCharset;
  ACanvas.Font.Color:= FontColor;
  ACanvas.Font.Name:= FontName;
  ACanvas.Font.Height:= trunc(FontHeight * AScale);
  ACanvas.Font.Style:= FontStyle;
  TH:= ACanvas.TextHeight('Xy')+2;
  R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
            ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );
  InflateRect(R,1,1);

  //get data
  if (CanvasType = DFDesigner) or (CanvasType = DFDesignPrinter) then
    Text:= GetFieldName
  else
    Text:= Data;

  //get memo data
  if (Format = DFMemo) then
  begin
    if (CanvasType = DFDesigner) or (CanvasType = DFDesignPrinter) then
    begin
      Page.Form.TempSL.Text:= GetFieldName;
    end
    else begin
      //wordwrap
      if Wordwrap then
      begin
        Page.Form.TempSL.clear;
        dfWordWrap(Data, Page.Form.TempSL, ACanvas, R);
      end
      else
        Page.Form.TempSL.Text:= Data;
    end;
  end
  else
    Page.Form.TempSL.clear;

  //checkbox
  if (Format = dfCheckbox) then
  begin
    if (CanvasType <> DFDesigner) and (CanvasType <> DFDesignPrinter) then
    begin
      //checkmark
      R:= Rect( ARect.Left+trunc(left*AScale), ARect.Top+trunc(top*AScale),
                ARect.Left+trunc((left+width)*AScale), ARect.Top+trunc((top+height)*AScale) );
      ACanvas.Pen.Color:= PenColor;
      ACanvas.Pen.Style:= PenStyle;
      ACanvas.Pen.Width := 1;
      if AScale > 1 then
        ACanvas.Pen.Width := trunc(ACanvas.Pen.Width * AScale);
      if AsBoolean then DrawCheckmark(ACanvas,R);
      Exit;
    end;
  end;

  //non-memo
  if Page.Form.TempSL.count = 0 then
  begin
    TW:= ACanvas.TextWidth(Text)+2;
    //right & center justify
    offX:= 1;
    if Alignment = DFRight then
      offX:= (R.Right-R.Left) - TW;
    if Alignment = DFCentered then
      offX:= ((R.Right-R.Left) - TW) div 2;
    if offX < 1 then offX:= 1;
    //fully justified
    Just:= 0;
    if Alignment = DFJustified then
    begin
      countS:= dfCountSpaces(Text);
      if (R.Right-R.Left) > TW then
        Just:= (R.Right-R.Left) - TW;
      if (countS > 0) and (Just > 0) then
        SetTextJustification(ACanvas.Handle, Just, CountS);
    end;
    //draw text
    if AutoSize then
      ACanvas.TextOut(R.Left+offX, R.Top, Text)
    else
      ACanvas.TextRect(R, R.Left+offX,R.Top, Text);
    //un-justify
    if Just > 0 then
      SetTextJustification(ACanvas.handle, 0, 0);
  end

  //Multiline Text
  else begin
    offY:= 0;
    for x:= 0 to Page.Form.TempSL.count-1 do
    begin
      TW:= ACanvas.TextWidth(Page.Form.TempSL[x])+2;
      //right & center justify
      offX:= 1;
      if Alignment = DFRight then
        offX:= (R.Right-R.Left) - TW;
      if Alignment = DFCentered then
        offX:= ((R.Right-R.Left) - TW) div 2;
      if offX < 1 then offX:= 1;
      //fully justified
      Just:= 0;
      if Alignment = DFJustified then
      begin
        countS:= dfCountSpaces(Page.Form.TempSL[x]);
        if (R.Right-R.Left) > TW then
          Just:= (R.Right-R.Left) - TW;
        if (countS > 0) and (Just > 0) then
          SetTextJustification(ACanvas.Handle, Just, CountS);
      end;
      //draw text
      if AutoSize then
        ACanvas.TextOut(R.Left+offX, R.Top+offY, Page.Form.TempSL[x])
      else
        ACanvas.TextRect(R, R.Left+offX,R.Top+offY, Page.Form.TempSL[x]);
      //un-justify
      if Just > 0 then
        SetTextJustification(ACanvas.handle, 0, 0);
      //line spacing
      if LineSpacing > 0 then
        inc(offY, trunc(LineSpacing * Ascale))
      else
        inc(offY, TH);
    end;
  end;
  Page.Form.TempSL.clear;
end;

function TDFField.GetHeight: integer;
var
  Text: string;
begin
  if (Page = nil) or (not Autosize) then result:= inherited GetHeight
  else begin
    if Format = DFCheckbox then
    begin
      result:= 13;
      Exit;
    end;

    if (Page.Form.Engine <> nil) and (Page.Form.Engine.IsDesigner) then
      Text:= GetFieldName
    else
      Text:= Data;

    Page.Form.TempBMP.Canvas.Font.Charset:= FontCharset;
    Page.Form.TempBMP.Canvas.Font.Color:= FontColor;
    Page.Form.TempBMP.Canvas.Font.Name:= FontName;
    Page.Form.TempBMP.Canvas.Font.Style:= FontStyle;
    Page.Form.TempBMP.Canvas.Font.Height:= FontHeight;
    if (Text <> '') and (pos(#13, Text) > 0) then
    begin
      Page.Form.TempSL.Text:= Text;
      if LineSpacing > 0 then
        result:= LineSpacing * Page.Form.TempSL.count
      else
        result:= (Page.Form.TempBMP.Canvas.textheight('Xy')+2)*Page.Form.TempSL.count;
      Page.Form.TempSL.clear;
    end
    else
      result:= Page.Form.TempBMP.Canvas.textheight('Xy')+2;
    FHeight:= result;
  end;
end;

function TDFField.GetWidth: integer;
var
  x: integer;
  Text: string;
begin
  if (Page = nil) or (not Autosize) then result:= inherited GetWidth
  else begin
    if Format = DFCheckbox then
    begin
      result:= 13;
      Exit;
    end;

    if (Page.Form.Engine <> nil) and (Page.Form.Engine.IsDesigner) then
      Text:= GetFieldName
    else
      Text:= Data;

    Page.Form.TempBMP.Canvas.Font.Charset:= FontCharset;
    Page.Form.TempBMP.Canvas.Font.Color:= FontColor;
    Page.Form.TempBMP.Canvas.Font.Name:= FontName;
    Page.Form.TempBMP.Canvas.Font.Style:= FontStyle;
    Page.Form.TempBMP.Canvas.Font.Height:= FontHeight;
    if (Text <> '') and (pos(#13, Text) > 0) then
    begin
      Page.Form.TempSL.Text:= Text;
      result:= 0;
      for x:= 0 to Page.Form.TempSL.count-1 do
        if Page.Form.TempBMP.Canvas.textwidth(Page.Form.TempSL[x])+2 > result then
          result:= Page.Form.TempBMP.Canvas.textwidth(Page.Form.TempSL[x])+2;
      Page.Form.TempSL.clear;
    end
    else begin
      if Text = '' then
        result:= Page.Form.TempBMP.Canvas.textwidth('X')+2
      else
        result:= Page.Form.TempBMP.Canvas.textwidth(Text)+2;
    end;

    if Active and (not ((Page.Form.Engine <> nil) and (Page.Form.Engine.IsDesigner))) then
    begin
      if (Format = dfCheckbox) then result:= Height
      else if (result < FActiveMinWidth) then
        result:= FActiveMinWidth;
    end;
    FWidth:= result;
  end;
end;

procedure TDFField.DrawCheckmark(ACanvas: TCanvas; ARect: TRect);
begin
  with ACanvas do
  begin
    InflateRect(ARect,-1,-1);
    MoveTo( ARect.left ,    ARect.Top );
    LineTo( ARect.right ,   ARect.bottom );
    MoveTo( ARect.left ,    ARect.bottom-1 );
    LineTo( ARect.right ,   ARect.top-1 );
    MoveTo( ARect.left+1 ,  ARect.Top );
    LineTo( ARect.right ,   ARect.bottom-1 );
    MoveTo( ARect.left ,    ARect.Top+1 );
    LineTo( ARect.right-1 , ARect.bottom );
    MoveTo( ARect.left ,    ARect.bottom-2 );
    LineTo( ARect.right-1 , ARect.top-1 );
    MoveTo( ARect.left+1 ,  ARect.bottom-1 );
    LineTo( ARect.right ,   ARect.top );
  end;
end;

function TDFField.GetFieldName: string;
begin
  result:= '<'+FieldName+'>';
end;

procedure TDFField.SetFieldName(const AValue: string);
begin
  FFieldName:= AValue;
  DoChange(Self, IsLoading);
end;

procedure TDFField.SetTabOrder(const AValue: integer);
begin
  FTabOrder:= AValue;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetFieldname(const Value: string);
begin
  if IsLoading or (Page = nil) or (Page.Form.Engine = nil) then
    FFieldname := Value
  else begin
    if Page.Form.Engine.FindField(value) <> nil then
      if Page.Form.Engine.WantExceptions then
        raise EDFError.create('Fieldname already used: '+Value);
    FFieldname := Value
  end;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetTabOrder(const Value: integer);
begin
  FTabOrder := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetCheckIndex(const Value: integer);
begin
  FCheckIndex := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetEditMask(const Value: string);
begin
  FEditMask := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetData(const Value: string);
begin
  FData := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetExpression(const Value: string);
begin
  FExpression := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetFormat(const Value: TDFFieldFormat);
var y : TFormatSettings;
begin
  FFormat := Value;
  if not IsLoading then
    case Value of
      DFfloat:
      begin
        FDisplayFormat:= '#'+y.DecimalSeparator+'00';
      end;
      DFpercent:
      begin
        FDisplayFormat:= '#'+y.DecimalSeparator+'00';
      end;
      DFdate:
      begin
        FDisplayFormat:= dfGetDateFormat;
        FEditMask:= dfFormatToMask(FDisplayFormat);
      end;
      DFcheckbox:
      begin
        FDisplayFormat:= '';
        FEditMask:= '';
        FPenStyle:= psSolid;
        FPenWidth:= 2;
        FAutoSize:= true;
      end;
      else
        FDisplayFormat:= '';
    end;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetHelpContext(const Value: integer);
begin
  FHelpContext := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetHint(const Value: string);
begin
  FHint := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetLineSpacing(const Value: integer);
begin
  FLineSpacing := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetMaxLength(const Value: integer);
begin
  FMaxLength := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetActiveMinWidth(const Value: integer);
begin
  FActiveMinWidth := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetComboItems(const Value: string);
begin
  FComboItems := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetActive(const Value: boolean);
begin
  FActive := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetFieldlink(const Value: string);
begin
  FFieldlink := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetFieldParams(const Value: string);
begin
  FFieldParams := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetStore(const Value: boolean);
begin
  FStore := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetDisplayFormat(const Value: string);
begin
  FDisplayFormat := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetShowZero(const Value: boolean);
begin
  FShowZero := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetWordwrap(const Value: boolean);
begin
  FWordwrap := Value;
  DoChange(Self, IsLoading);
end;

procedure TDFField._SetRequired(const Value: boolean);
begin
  FRequired := Value;
  DoChange(Self, IsLoading);
end;

function TDFField._StoreRequired: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).Required <> Required);
end;

function TDFField._StoreWordwrap: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).Wordwrap <> Wordwrap);
end;

function TDFField._StoreCheckIndex: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).CheckIndex <> CheckIndex);
end;

function TDFField._StoreFormat: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).Format <> Format);
end;

function TDFField._StoreHelpContext: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).HelpContext <> HelpContext);
end;

function TDFField._StoreLineSpacing: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).LineSpacing <> LineSpacing);
end;

function TDFField._StoreMaxLength: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).MaxLength <> MaxLength);
end;

function TDFField._StoreActiveMinWidth: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).ActiveMinWidth <> ActiveMinWidth);
end;

function TDFField._StoreActive: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).Active <> Active);
end;

function TDFField._StoreStore: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).Store <> Store);
end;

function TDFField._StoreShowZero: Boolean;
begin
  result:= ForceStore or (DefaultObject = nil) or ((DefaultObject as TDFField).ShowZero <> ShowZero);
end;

function TDFField._GetAsBoolean: boolean;
begin
  result:= sametext(FData, 'true');
end;

function TDFField._GetAsDateTime: TDatetime;
begin
  try
    result:= strtodatetime(FData);
  except
    result:= 0;
  end;  
end;

function TDFField._GetAsFloat: double;
begin
  try
    if (Format = DFpercent) and (strtofloat(dfOnlyReal(FData))>0) then
      result:= strtofloat(dfOnlyReal(FData))/100
    else
      result:= strtofloat(dfOnlyReal(FData));
  except
    result:= 0;
  end;
end;

function TDFField._GetAsInteger: integer;
begin
  result:= strtointdef(FData,0);
end;

function TDFField._GetAsString: string;
begin
  result:= FData;
end;

procedure TDFField._SetAsBoolean(const Value: boolean);
var I: integer;
begin
  if Value then
  begin
    if (not IsLoading) and (Page <> nil) then
      for I:= 0 to Page.FieldCount-1 do
        if Page.Fields[I].CheckIndex > 0 then
          if Page.Fields[I].CheckIndex = CheckIndex then
            Page.Fields[I].AsBoolean:= false;
    Data:= 'True'
  end
  else
    Data:= 'False';
end;

procedure TDFField._SetAsDateTime(const Value: TDatetime);
begin
  if (Value <> 0) then
    Data:= FormatDateTime(FDisplayFormat, Value)
  else
    Data:= '';
end;

procedure TDFField._SetAsFloat(const Value: double);
begin
  if (Value <> 0) or FShowZero then
  begin
    if Format = DFpercent then
      Data:= FormatFloat(FDisplayFormat, Value*100)
    else
      Data:= FormatFloat(FDisplayFormat, Value);
  end
  else
    Data:= '';
end;

procedure TDFField._SetAsInteger(const Value: integer);
begin
  if (Value <> 0) or FShowZero then
    Data:= inttostr(Value)
  else
    Data:= '';
end;

procedure TDFField._SetAsString(const Value: string);
begin
  case Format of
    dfInteger: AsInteger:= strtointdef(Value,0);
    dfFloat: try AsFloat:= strtofloat(Value); except ; end;
    dfPercent: try AsFloat:= strtofloat(Value); except ; end;
    dfDate:
      begin
        try
          if pos('/',Value)>0 then
           AsDateTime := strtodatetime(Value)
          else
           AsDateTime := strtofloat(Value);
        except ;
        end;
      end;
    else Data:= Value;
  end;
end;


{ TDFFieldAccess }

procedure TDFFieldAccess.SetFieldName(const AValue: string);
begin
  inherited;
end;

procedure TDFFieldAccess.SetTabOrder(const AValue: integer);
begin
  inherited;
end;

initialization

  PrinterXdpi:= 0;
  PrinterYdpi:= 0;
  PrinterXmargin:= 0;
  PrinterYmargin:= 0;
  PrinterCanReset:= true;
  PrinterPageNum:= 0;

  RegisterClass(TDFForm);
  RegisterClass(TDFPage);
  RegisterClass(TDFObject);
  RegisterClass(TDFLine);
  RegisterClass(TDFFrame);
  RegisterClass(TDFLogo);
  RegisterClass(TDFButton);
  RegisterClass(TDFText);
  RegisterClass(TDFField);
  RegisterClass(TDFDefaultLine);
  RegisterClass(TDFDefaultFrame);
  RegisterClass(TDFDefaultLogo);
  RegisterClass(TDFDefaultButton);
  RegisterClass(TDFDefaultText);
  RegisterClass(TDFDefaultField);

end.
