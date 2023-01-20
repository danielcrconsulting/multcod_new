object Form1: TForm1
  Left = 271
  Top = 114
  Caption = 'Configurar Server V1.0.7 20/01/2023'
  ClientHeight = 235
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 100
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object Label2: TLabel
    Left = 120
    Top = 8
    Width = 169
    Height = 25
    Caption = 'Server Multicold'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ButtonStart: TButton
    Left = 24
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 105
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object EditPort: TEdit
    Left = 24
    Top = 119
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 2
    Text = '8080'
  end
  object ButtonOpenBrowser: TButton
    Left = 24
    Top = 164
    Width = 107
    Height = 25
    Caption = 'Open Browser'
    TabOrder = 3
    Visible = False
    OnClick = ButtonOpenBrowserClick
  end
  object Button1: TButton
    Left = 224
    Top = 156
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    Visible = False
    OnClick = Button1Click
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 288
    Top = 24
  end
  object FDQuery1: TFDQuery
    Left = 344
    Top = 80
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 384
    Top = 152
  end
  object fdcon: TFDConnection
    Left = 208
    Top = 104
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 320
    Top = 184
  end
end
