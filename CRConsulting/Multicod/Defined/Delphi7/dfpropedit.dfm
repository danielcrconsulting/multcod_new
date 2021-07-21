object DFOpenDialog: TDFOpenDialog
  Left = 334
  Top = 144
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Defined Form Dialog'
  ClientHeight = 306
  ClientWidth = 357
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TButton
    Left = 274
    Top = 12
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 274
    Top = 41
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object HelpButton: TButton
    Left = 274
    Top = 71
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 7
    Width = 255
    Height = 288
    TabOrder = 3
    object ImagePanel: TPanel
      Left = 10
      Top = 16
      Width = 235
      Height = 235
      BevelOuter = bvNone
      BorderWidth = 4
      BorderStyle = bsSingle
      Color = clGray
      TabOrder = 0
      object DFDisplay: TDFDisplay
        Left = 4
        Top = 4
        Width = 223
        Height = 223
        FormEngine = DFEngine
        PageIndex = 0
        Scale = 100
        Autosize = False
        Center = True
        Stretch = True
        Align = alClient
        TabOrder = 0
      end
    end
    object Load: TButton
      Left = 10
      Top = 257
      Width = 75
      Height = 23
      Caption = '&Load...'
      TabOrder = 1
      OnClick = ButtonClick
    end
    object Save: TButton
      Left = 90
      Top = 257
      Width = 75
      Height = 23
      Caption = '&Save...'
      TabOrder = 2
      OnClick = ButtonClick
    end
    object Clear: TButton
      Left = 170
      Top = 257
      Width = 75
      Height = 23
      Caption = '&Clear'
      TabOrder = 3
      OnClick = ButtonClick
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'dfb'
    Title = 'Open Form'
    Left = 86
    Top = 57
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'dfb'
    Title = 'Save Form'
    Left = 118
    Top = 57
  end
  object DFEngine: TDFEngine
    PaintOptions = [dfShowRulers, dfShowMargins, dfShowForm, dfShowFields, dfShowBackground, dfPrintShading, dfPrintBackground]
    PreviewCaption = 'Defined Forms Preview'
    PrintJob = 'Defined Forms Printer'
    PreviewZoom = 'PW'
    WantExceptions = True
    StoreAllFields = False
    Version = '6.0.31'
    Left = 54
    Top = 57
    FormData = {}
  end
end
