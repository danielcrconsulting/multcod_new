object frmDemo: TfrmDemo
  Left = 192
  Top = 114
  Caption = 'Quick PDF Library Demo - Version 2'
  ClientHeight = 355
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    509
    355)
  PixelsPerInch = 96
  TextHeight = 13
  object pcTabs: TPageControl
    Left = 12
    Top = 12
    Width = 493
    Height = 332
    ActivePage = tsGeneral
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TLabel
        Left = 8
        Top = 4
        Width = 415
        Height = 13
        Caption = 
          'Remember to add the Quick PDF Library path to your project searc' +
          'h path.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblLibVersion: TLabel
        Left = 128
        Top = 100
        Width = 4
        Height = 13
        Caption = '-'
      end
      object lblLicense: TLabel
        Left = 128
        Top = 116
        Width = 4
        Height = 13
        Caption = '-'
      end
      object TLabel
        Left = 8
        Top = 20
        Width = 303
        Height = 13
        Caption = 
          '(Project | Options | Directories and Conditionals | Search Path ' +
          ')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object TLabel
        Left = 8
        Top = 52
        Width = 59
        Height = 13
        Caption = 'License key:'
      end
      object btnLibraryVersion: TButton
        Left = 8
        Top = 100
        Width = 105
        Height = 25
        Caption = 'Library Version'
        TabOrder = 0
        OnClick = btnLibraryVersionClick
      end
      object edtLicenseKey: TEdit
        Left = 3
        Top = 71
        Width = 241
        Height = 21
        TabOrder = 1
        Text = 'insert license key here'
      end
    end
    object tsShapes: TTabSheet
      Caption = 'Lines and Shapes'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TLabel
        Left = 96
        Top = 12
        Width = 256
        Height = 13
        Caption = 'Draws a grid of boxes filled with different color circles'
      end
      object TLabel
        Left = 96
        Top = 52
        Width = 167
        Height = 13
        Caption = 'Draw a few random curved shapes'
      end
      object btnGrid: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Grid'
        TabOrder = 0
        OnClick = btnGridClick
      end
      object btnCurves: TButton
        Left = 8
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Curves'
        TabOrder = 1
        OnClick = btnCurvesClick
      end
    end
    object tsImages: TTabSheet
      Caption = 'Images'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TLabel
        Left = 96
        Top = 12
        Width = 202
        Height = 13
        Caption = 'Draws a logo onto all pages in a document'
      end
      object TLabel
        Left = 96
        Top = 52
        Width = 226
        Height = 13
        Caption = 'Draws an image and adds a transparency mask'
      end
      object btnLogo: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Logo'
        TabOrder = 0
        OnClick = btnLogoClick
      end
      object btnMask: TButton
        Left = 8
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Mask'
        TabOrder = 1
        OnClick = btnMaskClick
      end
    end
    object tsFormFields: TTabSheet
      Caption = 'Form Fields'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TLabel
        Left = 8
        Top = 40
        Width = 27
        Height = 13
        Caption = 'Name'
      end
      object TLabel
        Left = 144
        Top = 40
        Width = 42
        Height = 13
        Caption = 'Surname'
      end
      object TLabel
        Left = 8
        Top = 8
        Width = 296
        Height = 13
        Caption = 
          'Fill in the following values which will be saved into a PDF form' +
          ':'
      end
      object edtName: TEdit
        Left = 8
        Top = 56
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edtSurname: TEdit
        Left = 144
        Top = 56
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object btnMakeForm: TButton
        Left = 12
        Top = 100
        Width = 75
        Height = 25
        Caption = 'Make Form'
        TabOrder = 2
        OnClick = btnMakeFormClick
      end
    end
    object tsText: TTabSheet
      Caption = 'Text'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TLabel
        Left = 96
        Top = 12
        Width = 179
        Height = 13
        Caption = 'Draws rotated text in different colors'
      end
      object btnRotatedText: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Rotated'
        TabOrder = 0
        OnClick = btnRotatedTextClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'View/Print'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        485
        304)
      object btnViewPrintLoadPDF: TButton
        Left = 11
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Load'
        TabOrder = 0
        OnClick = btnViewPrintLoadPDFClick
      end
      object btnViewPrintClose: TButton
        Left = 92
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Close'
        TabOrder = 1
        OnClick = btnViewPrintCloseClick
      end
      object PreviewScrollBox: TScrollBox
        Left = 8
        Top = 44
        Width = 465
        Height = 249
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        object imgPreview: TImage
          Left = 0
          Top = 0
          Width = 105
          Height = 105
        end
      end
      object cmbZoom: TComboBox
        Left = 268
        Top = 12
        Width = 97
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        OnChange = cmbZoomChange
        Items.Strings = (
          '25%'
          '50%'
          '75%'
          '100%')
      end
      object btnViewPrintPrevPage: TButton
        Left = 376
        Top = 8
        Width = 29
        Height = 25
        Caption = '<'
        TabOrder = 4
        OnClick = btnViewPrintPrevPageClick
      end
      object btnViewPrintNextPage: TButton
        Left = 408
        Top = 8
        Width = 29
        Height = 25
        Caption = '>'
        TabOrder = 5
        OnClick = btnViewPrintNextPageClick
      end
      object btnPrint: TButton
        Left = 176
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Print'
        TabOrder = 6
        OnClick = btnPrintClick
      end
    end
  end
  object dlgSave: TSaveDialog
    Filter = 'Adobe PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 448
    Top = 244
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'pdf'
    Filter = 'Adobe PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open PDF'
    Left = 448
    Top = 284
  end
  object dlgPrint: TPrintDialog
    Options = [poPageNums, poDisablePrintToFile]
    PrintRange = prPageNums
    Left = 448
    Top = 204
  end
end
