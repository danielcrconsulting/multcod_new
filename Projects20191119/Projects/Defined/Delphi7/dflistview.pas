unit dflistview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, Printers,
  ComCtrls, Commctrl, dfclasses {$IFDEF XML},dfxml{$ENDIF};

type
  TCreateTextEvent = procedure (Sender: TObject; Item : TListItem;
    Column : TListColumn; Text : TDfText) of object;

  TdfListViewPrinter = class(TComponent)
  private
    FView : TCustomListView;
    FColumnStart : Integer;
    FColumnEnd : Integer;
    FRowStart : Integer;
    FRowEnd : Integer;
    FCurrPage : TDfPage;
    FEngine : TDfEngine;
    FTextHeight : Integer;
    FStartX : Integer;
    FStartY : Integer;
    FX : Integer;
    FY : Integer;
    FWidth : Integer;
    FHeight : Integer;
    FOnCreateText: TCreateTextEvent;
    FTitle: String;
    FMargin: Integer;
    FVert: Integer;
    FHorz: Integer;
    procedure PrintColumns;
    procedure PrintRows;
    procedure SetEngine(const Value: TdfEngine);
    procedure SetView(const Value: TCustomListView);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor create(AOwner : TComponent); override;
    destructor destroy; override;
    function PrintToXml(FileName : String) : Boolean;
    function PrintToForm : Boolean;
    function PrintPreview : Boolean;
    function Print : Boolean;
  published
    property Horizontal : Integer read FHorz write FHorz;
    property Vertical : Integer read FVert write FVert;
    property Margin : Integer read FMargin write FMargin;
    property Title : String read FTitle write FTitle;
    property View : TCustomListView read FView write SetView;
    property Engine : TdfEngine read FEngine write SetEngine;
    property OnCreateText : TCreateTextEvent read FOnCreateText write FOnCreateText;
  end;


  procedure LoadListFromCommaText(const FileName : String; AView : TListView);
  procedure SaveListToCommaText(const FileName : String; AView : TListView);

  procedure PrintListView(AView : TListView; const Title : String;
    const ShowPreviewDialog : Boolean);

implementation

  procedure PrintListView(AView : TListView; const Title : String;
    const ShowPreviewDialog : Boolean);
  var
    P : TdfListViewPrinter;
    E : TdfEngine;
  begin
    P:= TdfListViewPrinter.Create(nil);
    E:= TdfEngine.Create(nil);
    try
      P.Engine:= E;
      P.View:= AView;
      P.Title:= Title;
      if ShowPreviewDialog then
        P.PrintPreview
      else
        P.Print;
    finally
      E.Free;
      P.Free;
    end;
  end;

  function GetPrinterPaper : Integer;
  var
    Device: array[1..cchDeviceName] of char;
    Driver: array[1..MAX_PATH] of char;
    Port: array[0..32] of char;
    hDMode: THandle;
    PDMode: PDEVMODE;
  begin
    Result := 0;
    try
      Printer.GetPrinter(@Device, @Driver, @Port, hDMode);
      if hDMode <> 0 then
      begin
        pDMode := GlobalLock(hDMode);
        if pDMode <> nil then
        begin
          Result:= pDMode^.dmPaperSize;
          GlobalUnlock(hDMode);
        end;
      end;
    except
      raise Exception.create('Error initializing printer');
    end;
  end;
  
{ TdfListViewPrinter }

constructor TdfListViewPrinter.create(AOwner: TComponent);
begin
  inherited;
  FEngine:= nil;
  FView:= nil;
  FOnCreateText:= nil;
  FHorz:= 40;
  FVert:= 40;
  FMargin:= 4;
end;

destructor TdfListViewPrinter.destroy;
begin
  inherited;
end;

procedure TdfListViewPrinter.PrintColumns;
var
  Text : TDfText;
  Line : TDfLine;
  Frame : TDfFrame;
  I : Integer;
begin
  //Loop through to create the page
  for I:= FColumnStart to TListView(FView).Columns.Count-1 do
  begin
    if ((FX + ListView_GetColumnWidth(FView.Handle, I)) <= FWidth) then
    begin
      //Add the text for the column header
      Text:= FCurrPage.AddText;
      Text.Text:= '';
      Text.Autosize:= False;
      Text.Left:= FX;
      Text.Width:= ListView_GetColumnWidth(FView.Handle, I);
      Text.Top:= FY + FMargin;
      Text.Height:= FTextHeight;
      Text.Text:= TListView(FView).Columns[I].Caption;
      case (TListView(FView).Columns[I].Alignment) of
        taLeftJustify : Text.Alignment:= dfLeft;
        taRightJustify : Text.Alignment:= dfRight;
        taCenter : Text.Alignment:= dfCentered;
      end;
      //Fire the event
      if (Assigned(FOnCreateText)) then
        FOnCreateText(Self, nil, TListView(FView).Columns[I], Text);
      //Add the Vertical Line
      if (FView.GridLines) then
      begin
        Line:= FCurrPage.AddLine;
        Line.X1:= FX-FMargin;
        Line.X2:= FX-FMargin;
        Line.Y1:= FY + FTextHeight + FMargin;
        Line.Y2:= FHeight;
      end;
      //Store the Curr variables
      FX:= FX + ListView_GetColumnWidth(FView.Handle, I) + (2 * FMargin);
      //Bump up the current End Column
      FColumnEnd:= I;
    end else
      Break;
  end;

  //Add the last Vertical Line
  if (FView.GridLines) then
  begin
    Line:= FCurrPage.AddLine;
    Line.X1:= (FX-FMargin);
    Line.X2:= (FX-FMargin);
    Line.Y1:= FY + FTextHeight + FMargin;
    Line.Y2:= FHeight;
    //Add the bottom horizontal line
    Line:= FCurrPage.AddLine;
    Line.X1:= FStartX - FMargin;
    Line.X2:= FX-FMargin;
    Line.Y1:= FHeight;
    Line.Y2:= FHeight;
  end;

  //Add the first horizontal frame
  Frame:= FCurrPage.AddFrame;
  Frame.MoveTo(0);
  Frame.BrushStyle:= bsSolid;
  Frame.BrushColor:= $CCCCCC;
  Frame.Left:= FStartX - FMargin;
  Frame.Width:= (FX-Margin) - Frame.Left;
  Frame.Top:= FY;
  Frame.Height:= FTextHeight + Margin;
  //Add the first horizontal line
  Line:= FCurrPage.AddLine;
  Line.X1:= FStartX - FMargin;
  Line.X2:= FX-FMargin;
  Line.Y1:= FY + FTextHeight + FMargin;
  Line.Y2:= FY + FTextHeight + FMargin;
end;

procedure TdfListViewPrinter.PrintRows;
var J, I : Integer;
    Text : TDfText;
    Line : TDfLine;
begin
  for J:= FRowStart to TListView(FView).Items.Count-1 do
  begin
    if ((FY + FTextHeight + FMargin) > FHeight) then
      Break
    else begin
      //Reset X
      FX:= FStartX;
      //Loop through and add all of the text in the columns for this page
      for I:= FColumnStart to FColumnEnd do
      begin
        Text:= FCurrPage.AddText;
        Text.Text:= '';        
        Text.Autosize:= False;
        Text.Left:= FX;
        Text.Width:= ListView_GetColumnWidth(FView.Handle, I);
        Text.Top:= FY;
        Text.Height:= FTextHeight;
        case (TListView(FView).Columns[I].Alignment) of
          taLeftJustify : Text.Alignment:= dfLeft;
          taRightJustify : Text.Alignment:= dfRight;
          taCenter : Text.Alignment:= dfCentered;
        end;
        //Add the text with a leading margin
        if (I = 0) then
        begin
          Text.Text:= TListView(FView).Items[J].Caption;
        end
        else begin
          //Check if there are enough sub-items
          if (TListView(FView).Items[J].SubItems.Count > I-1) then
            Text.Text:= TListView(FView).Items[J].SubItems[I-1]
          else begin
            Text.Delete;
            Break;
          end;
        end;
        //Fire the event
        if (Assigned(FOnCreateText)) then
          FOnCreateText(Self, TListView(FView).Items[J], TListView(FView).Columns[I], Text);

        //Store the Curr variables
        FX:= FX + ListView_GetColumnWidth(FView.Handle, I) + (2 * FMargin);
      end;

      //Add the horizontal line
      if (FView.GridLines) then
      begin
        Line:= FCurrPage.AddLine;
        Line.X1:= FStartX - (FMargin div 2) - 1;
        Line.X2:= FX - (FMargin div 2) - 1;
        Line.Y1:= FY + FTextHeight;
        Line.Y2:= FY + FTextHeight;
      end;

      //Bump the Y and the EndRow
      FY:= FY + FTextHeight + FMargin;
      FRowEnd:= J;
    end;
  end;
end;

function TdfListViewPrinter.PrintToForm : Boolean;
var Text : TDfText;
    CurrVertPage : Integer;
    D : TDateTime;
    PaperSize : TdfPaperSize;
begin
  if (FView = nil) then
    raise EDfError.Create('Cannot print an unsigned list');

  if (FEngine = nil) then
    raise EDfError.Create('Cannot print to an unsigned engine');

  //Setup the Engine
  FEngine.Clear;
  FEngine.Form.FormName:= FTitle;
  //Grab the first page to set up some vars
  FCurrPage:= FEngine.Pages[0];
  //Set up X and Y, W and H
  FStartX:= FHorz;
  FStartY:= FVert;
  //Try to set the paper
  case GetPrinterPaper of
    DMPAPER_LEGAL : PaperSize:= dfLegal;
    DMPAPER_A3 : PaperSize:= dfA3;
    DMPAPER_A4 : PaperSize:= dfA4;
    DMPAPER_A5 : PaperSize:= dfA5;
    else PaperSize:= dfLetter;
  end;

  FCurrPage.PaperSize:= PaperSize;

  //Get the Width and the height
  case Printer.Orientation of
    poPortrait :
      begin
        FCurrPage.Orientation:= dfPortrait;
      end;
    poLandscape :
      begin
        FCurrPage.Orientation:= dfLandscape;
      end;
  end;

  FWidth:= FCurrPage.Width - (2 * FStartX);
  FHeight:= FCurrPage.Height - (2 * FStartY);

  //Assign the Font to get the TextHeight
  FCurrPage.Form.TempBMP.Canvas.Font.Assign(TListView(FView).Font);
  FTextHeight:= FCurrPage.Form.TempBMP.Canvas.TextHeight('Xy') + FMargin;
  //Delete the first page
  FCurrPage.Delete;

  //Init Row Start
  FRowStart:= 0;
  CurrVertPage:= 1;

  //Get the date
  D:= Now;

  //Loop
  while true do
  begin
    //Do we have Anything to print
    if (FRowStart >= TListView(FView).Items.Count) then Break;
    //Init Column start
    FColumnStart:= 0;
    //Loop
    while true do
    begin
      //Add a page
      FCurrPage:= FEngine.AddPage;
      FCurrPage.PaperSize:= PaperSize;

      //Get the Width and the height
      case Printer.Orientation of
        poPortrait :
          begin
            FCurrPage.Orientation:= dfPortrait;
          end;
        poLandscape :
          begin
            FCurrPage.Orientation:= dfLandscape;
          end;
      end;

      FWidth:= FCurrPage.Width - (2 * FStartX);
      FHeight:= FCurrPage.Height - (2 * FStartY);
      //Init X, Y
      FX:= FStartX;
      FY:= FStartY;
      //Print the Columns
      PrintColumns;
      //Init Y Pos
      FY:= FY + FTextHeight + (3 * FMargin);
      //Print the Rows
      PrintRows;
      //Set the page name
      FCurrPage.PageName:= 'Page ' +  IntToStr(CurrVertPage) + ', Columns ' +
        IntToStr(FColumnStart+1) + ' - ' + IntToStr(FColumnEnd+1);
      //Add the Labels
      Text:= FCurrPage.AddText;
      Text.Text:= '';      
      Text.FontStyle:= [fsBold];
      Text.Left:= FStartX;
      Text.Top:= FStartY-Text.Height;
      Text.Text:= Title;
      //Fire the event
      if (Assigned(FOnCreateText)) then
        FOnCreateText(Self, nil, nil, Text);

      FX:= FStartX + Text.Width;

      Text:= FCurrPage.AddText;
      Text.Text:= '';      
      Text.FontColor:= $444444;
      Text.Left:= FX;
      Text.Top:= FStartY-Text.Height;
      Text.Text:= ' - ' + FCurrPage.PageName;
      //Fire the event
      if (Assigned(FOnCreateText)) then
        FOnCreateText(Self, nil, nil, Text);

      Text:= FCurrPage.AddText;
      Text.Text:= '';      
      Text.FontColor:= clSilver;
      Text.Left:= FStartX;
      Text.Top:= FHeight + FMargin;
      Text.Text:= 'Created ' + FormatDateTime('dddddd tttt', D);
      //Fire the event
      if (Assigned(FOnCreateText)) then
        FOnCreateText(Self, nil, nil, Text);

      //Bump the column start
      FColumnStart:= FColumnEnd + 1;
      //Do we have any more columns to print
      if (FColumnStart >= TListView(FView).Columns.Count) then Break;
    end;
    //Bump the Page number
    Inc(CurrVertPage);

    //Bump the row start
    FRowStart:= FRowEnd + 1;
  end;

  //Set the Result
  Result:= True;
end;

function TdfListViewPrinter.Print : Boolean;
begin
  Result:= False;

  if (FEngine = nil) then
    raise EDfError.Create('Cannot print to an unsigned engine');

  if PrintToForm then
  begin
    FEngine.Print;
    Result:= True;
  end;
end;

function TdfListViewPrinter.PrintPreview : Boolean;
begin
  Result:= False;

  if (FEngine = nil) then
    raise EDfError.Create('Cannot print to an unsigned engine');

  if PrintToForm then
  begin
    FEngine.PreviewCaption:= Title;
    FEngine.PreviewOptions:= FEngine.PreviewOptions - [dfPageTabs]; 
    FEngine.PrintPreview;
    Result:= True;
  end;
end;

function TdfListViewPrinter.PrintToXml(FileName : String): Boolean;
begin
  Result:= False;

  if (FEngine = nil) then
    raise EDfError.Create('Cannot print to an unsigned engine');

  if PrintToForm then
  begin
{$IFDEF XML}
    SaveToXml(FEngine.Form, FileName);
{$ENDIF}    
    Result:= True;
  end;
end;

procedure TdfListViewPrinter.SetEngine(const Value: TdfEngine);
begin
  FEngine:= Value;
end;

procedure TdfListViewPrinter.SetView(const Value: TCustomListView);
begin
  FView:= Value;
end;

procedure TdfListViewPrinter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  //Engine
  if (Operation = opRemove) and (AComponent = FEngine) then
    FEngine:= nil;
  //View
  if (Operation = opRemove) and (AComponent = FView) then
    FView:= nil;
end;

  (** List View Comma Functions **)


  procedure LoadListFromCommaText(const FileName : String; AView : TListView);
  var
    Strings : TStringList;
    Line : TStringList;
    I, J : Integer;
    Item : TListItem;
    Column : TListColumn;
  begin
    if (AView.ViewStyle <> vsReport) then Exit;
    //Clear the List
    AView.Items.BeginUpdate;
    AView.Items.Clear;
    //Create the Strings
    Strings:= TStringList.Create;
    Line:= TStringList.Create;
    try
      //Load
      Strings.LoadFromFile(FileName);
      //Are there any items?
      if (Strings.Count = 0) then Exit;
      //Grab the First line-- it is the header
      Line.CommaText:= Strings[0];
      //Check if we need new columns
      if (Line.Count <> AView.Columns.Count) then
      begin
        AView.Columns.Clear;
        //Loop through the line
        for J:= 0 to Line.Count-1 do
        begin
          Column:= AView.Columns.Add;
          Column.Caption:= Line[J];
        end;
      end;
      //Loop through the rest of the lines
      for I:= 1 to Strings.Count-1 do
      begin
        //Grab the First line-- it is the header
        Line.CommaText:= Strings[I];
        //Loop through the line
        Item:= AView.Items.Add;
        for J:= 0 to Line.Count-1 do
        begin
          if (J = 0) then
            Item.Caption:= Line[J]
          else
            Item.SubItems.Add(Line[J]);
        end;
      end;
    finally
      Line.Free;
      Strings.Free;
      AView.Items.EndUpdate;
    end;
  end;

  procedure SaveListToCommaText(const FileName : String; AView : TListView);
  var
    Strings : TStringList;
    Line : TStringList;
    I, J : Integer;
    Item : TListItem;
    Column : TListColumn;
  begin
    if (AView.ViewStyle <> vsReport) then Exit;
    //Create the Strings
    Strings:= TStringList.Create;
    Line:= TStringList.Create;
    try
      //Add the Header
      for I:= 0 to AView.Columns.Count-1 do
      begin
        //Grab the column
        Column:= AView.Columns[I];
        Line.Add(Column.Caption);
      end;

      //Add the header Line to the output
      Strings.Add(Line.CommaText);
      //Clear the Line
      Line.Clear;

      //Add the Items
      for I:= 0 to AView.Items.Count-1 do
      begin
        //Grab the Item
        Item:= AView.Items[I];
        //Get the caption
        Line.Add(Item.Caption);
        //Loop through the Subitems
        for J:= 1 to AView.Columns.Count-1 do
        begin
          //Does this Item have that many columns?
          if (J-1 > Item.SubItems.Count-1) then Break;
          //Grab the text
          Line.Add(Item.SubItems[J-1]);
        end;
        //Add the Line to the output
        Strings.Add(Line.CommaText);
        //Clear the Line
        Line.Clear;
      end;
      //Save the Strings
      Strings.SaveToFile(FileName);
    finally
      Line.Free;
      Strings.Free;
    end;
  end;

end.

