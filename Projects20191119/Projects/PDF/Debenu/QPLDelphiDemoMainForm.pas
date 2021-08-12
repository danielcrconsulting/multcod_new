unit QPLDelphiDemoMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, DebenuPDFLibrary1115, DebenuPDFLibrary, ExtCtrls,
  Printers;

type
  TfrmDemo = class(TForm)
    pcTabs: TPageControl;
    tsGeneral: TTabSheet;
    tsShapes: TTabSheet;
    tsImages: TTabSheet;
    tsFormFields: TTabSheet;
    btnLibraryVersion: TButton;
    edtLicenseKey: TEdit;
    lblLibVersion: TLabel;
    lblLicense: TLabel;
    btnGrid: TButton;
    dlgSave: TSaveDialog;
    btnCurves: TButton;
    tsText: TTabSheet;
    btnLogo: TButton;
    btnMask: TButton;
    edtName: TEdit;
    edtSurname: TEdit;
    btnMakeForm: TButton;
    btnRotatedText: TButton;
    TabSheet1: TTabSheet;
    btnViewPrintLoadPDF: TButton;
    dlgOpen: TOpenDialog;
    btnViewPrintClose: TButton;
    PreviewScrollBox: TScrollBox;
    imgPreview: TImage;
    cmbZoom: TComboBox;
    btnViewPrintPrevPage: TButton;
    btnViewPrintNextPage: TButton;
    btnPrint: TButton;
    dlgPrint: TPrintDialog;
    procedure btnLibraryVersionClick(Sender: TObject);
    procedure btnGridClick(Sender: TObject);
    procedure btnCurvesClick(Sender: TObject);
    procedure btnLogoClick(Sender: TObject);
    procedure btnMaskClick(Sender: TObject);
    procedure btnMakeFormClick(Sender: TObject);
    procedure btnRotatedTextClick(Sender: TObject);
    procedure btnViewPrintLoadPDFClick(Sender: TObject);
    procedure btnViewPrintCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbZoomChange(Sender: TObject);
    procedure btnViewPrintPrevPageClick(Sender: TObject);
    procedure btnViewPrintNextPageClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    ViewPrintQP: TDebenuPDFLibrary;
    ViewPrintPageNum: Integer;
    procedure RenderPage;
  public
    { Public declarations }
  end;

var
  frmDemo: TfrmDemo;

implementation

{$R *.dfm}

procedure TfrmDemo.btnLibraryVersionClick(Sender: TObject);
var
  QP: TDebenuPDFLibrary;
begin
  QP := TDebenuPDFLibrary.Create;
  try
    lblLibVersion.Caption := QP.LibraryVersion;  
    QP.UnlockKey(edtLicenseKey.Text);
    lblLicense.Caption := QP.LicenseInfo;
  finally
    QP.Free;
  end;
end;

procedure TfrmDemo.btnGridClick(Sender: TObject);
var
  QP: TDebenuPDFLibrary;
  X, Y: Integer;
begin
  Randomize;
  dlgSave.FileName := 'Grid.pdf';
  if dlgSave.Execute then
  begin
    QP := TDebenuPDFLibrary.Create;
    try
      if QP.UnlockKey(edtLicenseKey.Text) = 1 then
      begin
        // Set the paper size
        QP.SetPageSize('A4');

        // Set the origin to the top-left corner
        QP.SetOrigin(1);

        // Set the measurement units to millimetres
        QP.SetMeasurementUnits(1);

        // Set the line color and width
        QP.SetLineColor(1, 0, 0);   // red
        QP.SetLineWidth(0.5);       // 0.5mm

        for X := 0 to 9 do
        begin
          for Y := 0 to 10 do
          begin
            // Last parameter is 0 = only draw outline
            QP.DrawBox(5 + X * 20, 5 + Y * 25, 20, 25, 0);

            // Set the fill color
            QP.SetFillColor(Random, Random * 0.5 + 0.5, Random * 0.5 + 0.5);

            // Draw a circle in the middle of the box
            QP.DrawCircle(15 + X * 20, 17.5 + Y * 25, 8, 1);
          end;
        end;

        // Compress the contents of the file
        QP.CompressContent;

        // Save the file
        QP.SaveToFile(dlgSave.FileName);

      end else
        MessageDlg('The license key is invalid or has expired.', mtError, [mbOK], 0);
    finally
      QP.Free;
    end;
  end;
end;

procedure TfrmDemo.btnCurvesClick(Sender: TObject);
var
  QP: TDebenuPDFLibrary;
  X, Y: Integer;
  XPos: Double;
  YPos: Double;
  C: Integer;
begin
  Randomize;
  dlgSave.FileName := 'Curves.pdf';
  if dlgSave.Execute then
  begin
    QP := TDebenuPDFLibrary.Create;
    try
      if QP.UnlockKey(edtLicenseKey.Text) = 1 then
      begin
        // Set the paper size
        QP.SetPageSize('A4');

        // Set the origin to the top-left corner
        QP.SetOrigin(1);

        // Set the measurement units to millimetres
        QP.SetMeasurementUnits(1);

        // Set the line width
        QP.SetLineWidth(0.5);           // 0.5mm

        for X := 1 to 2 do
        begin
          for Y := 1 to 2 do
          begin
            QP.SetLineColor(Random, 0, Random);
            QP.SetFillColor(Random, 0, Random);
            XPos := (X - 1) * 100 + 55;
            YPos := (Y - 1) * 143.5 + 76.75;
            QP.StartPath(XPos + Random(40) - Random(40), YPos + Random(50) - Random(50));
            for C := 1 to Random(5) + 2 do
            begin
              QP.AddCurveToPath(XPos + Random(40) - Random(40), YPos + Random(50) - Random(50),
                XPos + Random(40) - Random(40), YPos + Random(50) - Random(50),
                XPos + Random(40) - Random(40), YPos + Random(50) - Random(50));
            end;
            QP.ClosePath;
            QP.DrawPath(2);
          end;
        end;

        // Compress the contents of the file
        QP.CompressContent;

        // Save the file
        QP.SaveToFile(dlgSave.FileName);
      end else
        MessageDlg('The license key is invalid or has expired.', mtError, [mbOK], 0);
    finally
      QP.Free;
    end;
  end;
end;

procedure TfrmDemo.btnLogoClick(Sender: TObject);
var
  QP: TDebenuPDFLibrary;
  X: Integer;
  FontID: Integer;
  ImageID: Integer;
begin
  Randomize;
  dlgSave.FileName := 'Logo.pdf';
  if dlgSave.Execute then
  begin
    QP := TDebenuPDFLibrary.Create;
    try
      if QP.UnlockKey(edtLicenseKey.Text) = 1 then
      begin
        // Set the paper size
        QP.SetPageSize('A4');

        // Set the origin to the top-left corner
        QP.SetOrigin(1);

        // Set the measurement units to millimetres
        QP.SetMeasurementUnits(1);

        // Add a standard font
        FontID := QP.AddStandardFont(4);  // Helvetica

        // Add the logo from an image file
        QP.CompressImages(1);
        ImageID := QP.AddImageFromFile(ExtractFilePath(ParamStr(0)) + 'Logo.png', 0);

        // Add 9 pages, so there are a total of 10 pages in the document
        QP.NewPages(9);

        for X := 1 to 10 do
        begin
          QP.SelectPage(X);
          QP.SelectImage(ImageID);
          QP.DrawImage(10, 10, 22.4, 7.5);
          QP.SelectFont(FontID);
          QP.SetTextSize(16);
          QP.SetTextColor(0, 0, 0);
          QP.DrawText(35, 10, 'Page ' + IntToStr(X));
        end;

        // Compress the contents of the file
        QP.CompressContent;

        // Save the file
        QP.SaveToFile(dlgSave.FileName);
      end else
        MessageDlg('The license key is invalid or has expired.', mtError, [mbOK], 0);
    finally
      QP.Free;
    end;
  end;
end;

procedure TfrmDemo.btnMaskClick(Sender: TObject);
var
  QP: TDebenuPDFLibrary;
begin
  Randomize;
  dlgSave.FileName := 'Mask.pdf';
  if dlgSave.Execute then
  begin
    QP := TDebenuPDFLibrary.Create;
    try
      if QP.UnlockKey(edtLicenseKey.Text) = 1 then
      begin
        // Set the paper size
        QP.SetPageSize('A4');

        // Set the origin to the top-left corner
        QP.SetOrigin(1);

        // Set the measurement units to millimetres
        QP.SetMeasurementUnits(1);

        // Add the logo from an image file
        QP.CompressImages(1);
        QP.AddImageFromFile(ExtractFilePath(ParamStr(0)) + 'Logo.png', 0);

        QP.SetFillColor(0, 0, 0.7);
        QP.DrawBox(105, 50, 50, 50, 1);
        QP.SetImageMask(0.95, 0.95, 0.95, 1, 1, 1);  // 95% white - 100% white
        QP.DrawScaledImage(80, 55, 1);

        // Compress the contents of the file
        QP.CompressContent;

        // Save the file
        QP.SaveToFile(dlgSave.FileName);
      end else
        MessageDlg('The license key is invalid or has expired.', mtError, [mbOK], 0);
    finally
      QP.Free;
    end;
  end;
end;

procedure TfrmDemo.btnMakeFormClick(Sender: TObject);
var
  QP: TDebenuPDFLibrary;
  FieldIndex: Integer;
  FontID: Integer;
begin
  dlgSave.FileName := 'Form.pdf';
  if dlgSave.Execute then
  begin
    QP := TDebenuPDFLibrary.Create;
    try
      if QP.UnlockKey(edtLicenseKey.Text) = 1 then
      begin
        // Set the paper size
        QP.SetPageSize('A4');

        // Set the origin to the top-left corner
        QP.SetOrigin(1);

        // Set the measurement units to millimetres
        QP.SetMeasurementUnits(1);

        // Add the heading font
        QP.AddStandardFont(5);   // Helvetica bold
        QP.SetTextSize(10);
        QP.DrawText(10, 28, 'Name:');
        QP.DrawText(10, 48, 'Surname:');        

        // Add the font to use for the form fields
        FontID := QP.AddStandardFont(0);   // Courier

        FieldIndex := QP.NewFormField('Name', 1);
        QP.SetFormFieldBounds(FieldIndex, 10, 30, 50, 10);
        QP.SetNeedAppearances(0);
        QP.AddFormFont(FontID);
        QP.SetFormFieldFont(FieldIndex, QP.GetFormFontCount);
        QP.SetFormFieldTextSize(FieldIndex, 12);
        QP.SetFormFieldBorderColor(FieldIndex, 0.5, 0, 0);
        QP.SetFormFieldBorderStyle(FieldIndex, 1, 0, 0, 0);
        QP.SetFormFieldBackgroundColor(FieldIndex, 0.8, 0.8, 0.5);
        QP.SetFormFieldValue(FieldIndex, edtName.Text);

        FieldIndex := QP.NewFormField('Surname', 1);
        QP.SetFormFieldBounds(FieldIndex, 10, 50, 50, 10);
        QP.SetFormFieldFont(FieldIndex, QP.GetFormFontCount);
        QP.SetFormFieldTextSize(FieldIndex, 12);
        QP.SetFormFieldBorderColor(FieldIndex, 0.5, 0, 0);
        QP.SetFormFieldBorderStyle(FieldIndex, 1, 0, 0, 0);
        QP.SetFormFieldBackgroundColor(FieldIndex, 0.8, 0.8, 0.5);
        QP.SetFormFieldValue(FieldIndex, edtSurname.Text);

        // Compress the contents of the file
        QP.CompressContent;

        // Save the file
        QP.SaveToFile(dlgSave.FileName);
      end else
        MessageDlg('The license key is invalid or has expired.', mtError, [mbOK], 0);
    finally
      QP.Free;
    end;
  end;
end;

procedure TfrmDemo.btnRotatedTextClick(Sender: TObject);
var
  QP: TDebenuPDFLibrary;
  X: Integer;
begin
  dlgSave.FileName := 'Rotated.pdf';
  if dlgSave.Execute then
  begin
    QP := TDebenuPDFLibrary.Create;
    try
      if QP.UnlockKey(edtLicenseKey.Text) = 1 then
      begin
        // Set the paper size
        QP.SetPageSize('A4');

        // Set the origin to the top-left corner
        QP.SetOrigin(1);

        // Set the measurement units to millimetres
        QP.SetMeasurementUnits(1);

        // Add a standard font
        QP.AddStandardFont(11);  // Times Roman Bold Italic
        QP.SetTextSize(12);
        QP.SetTextSize(10);

        for X := 0 to 35 do
        begin
          QP.SetTextColor(X / 35, X / 70 + Random / 2, 1 - X / 35);
          QP.DrawRotatedText(105, 148.5, X * 10, 'Quick PDF Library');
        end;

        // Compress the contents of the file
        QP.CompressContent;

        // Save the file
        QP.SaveToFile(dlgSave.FileName);
      end else
        MessageDlg('The license key is invalid or has expired.', mtError, [mbOK], 0);
    finally
      QP.Free;
    end;
  end;
end;

procedure TfrmDemo.btnViewPrintLoadPDFClick(Sender: TObject);
var
  Password: string;
  R: Integer;
  CanProceed: Boolean;
  BlankBM: TBitmap;
begin
  if Assigned(ViewPrintQP) then
  begin
    ViewPrintQP.Free;
    ViewPrintQP := nil;
  end;
  CanProceed := False;  
  if dlgOpen.Execute then
  begin
    ViewPrintQP := TDebenuPDFLibrary.Create;
    if ViewPrintQP.UnlockKey(edtLicenseKey.Text) = 1 then
    begin
      if ViewPrintQP.LoadFromFile(dlgOpen.FileName, '') = 1 then
      begin
        CanProceed := True;
      end else
        MessageDlg('The PDF could not be opened.', mtError, [mbOK], 0);
    end else
      MessageDlg('The license key is invalid or has expired.', mtError, [mbOK], 0);
  end;
  if CanProceed then
  begin
    ViewPrintPageNum := 1;
    RenderPage;
  end else
  begin
    BlankBM := TBitmap.Create;
    try
      imgPreview.Picture.Assign(BlankBM);
    finally
      BlankBM.Free;
    end;
    ViewPrintQP.Free;
    ViewPrintQP := nil;
  end;
end;

procedure TfrmDemo.RenderPage;
var
  BM: TBitmap;
  MS: TMemoryStream;
  DPI: Integer;
begin
  BM := TBitmap.Create;
  try
    imgPreview.Picture.Assign(BM);
    PreviewScrollBox.HorzScrollBar.Position := 0;
    PreviewScrollBox.VertScrollBar.Position := 0;
    imgPreview.Left := 0;
    imgPreview.Top := 0;
  finally
    BM.Free;
  end;
  if Assigned(ViewPrintQP) then
  begin
    MS := TMemoryStream.Create;
    try
      DPI := ((cmbZoom.ItemIndex + 1) * 25 * 96) div 100;
      ViewPrintQP.RenderPageToStream(DPI, ViewPrintPageNum, 0, MS);
      MS.Seek(0, soFromBeginning);
      BM := TBitmap.Create;
      try
        BM.LoadFromStream(MS);
        imgPreview.AutoSize := True;
        imgPreview.Picture.Assign(BM);
      finally
        BM.Free;
      end;
    finally
      MS.Free;
    end;
  end;
end;

procedure TfrmDemo.btnViewPrintCloseClick(Sender: TObject);
var
  BlankBM: TBitmap;
begin
  BlankBM := TBitmap.Create;
  try
    imgPreview.Picture.Assign(BlankBM);
  finally
    BlankBM.Free;
  end;
  ViewPrintQP.Free;
  ViewPrintQP := nil;
end;

procedure TfrmDemo.FormShow(Sender: TObject);
begin
  cmbZoom.ItemIndex := 1;
end;

procedure TfrmDemo.cmbZoomChange(Sender: TObject);
begin
  RenderPage;
end;

procedure TfrmDemo.btnViewPrintPrevPageClick(Sender: TObject);
begin
  if ViewPrintPageNum > 1 then
  begin
    Dec(ViewPrintPageNum);
    RenderPage;
  end;
end;

procedure TfrmDemo.btnViewPrintNextPageClick(Sender: TObject);
begin
  if Assigned(ViewPrintQP) then
  begin
    if ViewPrintPageNum < ViewPrintQP.PageCount then
    begin
      Inc(ViewPrintPageNum);
      RenderPage;
    end;
  end;
end;

procedure TfrmDemo.btnPrintClick(Sender: TObject);
begin
  if Assigned(ViewPrintQP) then
  begin
    dlgPrint.MinPage := 1;
    dlgPrint.MaxPage := ViewPrintQP.PageCount;
    dlgPrint.FromPage := 1;
    dlgPrint.ToPage := ViewPrintQP.PageCount;
    if dlgPrint.Execute then
    begin
      ViewPrintQP.PrintDocument(Printer.Printers[Printer.PrinterIndex],
        dlgPrint.FromPage, dlgPrint.ToPage, ViewPrintQP.PrintOptions(0, 1, 'Debenu PDF Library Demo'));
    end;
  end;
end;

end.
