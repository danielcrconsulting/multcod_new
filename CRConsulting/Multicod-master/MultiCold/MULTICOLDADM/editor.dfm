object fEditor: TfEditor
  Left = 194
  Top = 184
  Caption = 'Editor de relat'#243'rios do Multicold'
  ClientHeight = 521
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 502
    Width = 622
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end
      item
        Width = 50
      end>
    SizeGrip = False
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 622
    Height = 502
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
    OnSelectionChange = RichEdit1SelectionChange
  end
  object OpenDialog1: TOpenDialog
    FilterIndex = 0
    Title = 'Abrir relat'#243'rio'
    Left = 216
    Top = 24
  end
  object MainMenu1: TMainMenu
    Left = 136
    Top = 24
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object Abrir1: TMenuItem
        Caption = 'A&brir ...'
        OnClick = Abrir1Click
      end
      object Sair1: TMenuItem
        Caption = '&Sair'
      end
    end
  end
end
