object Periodo: TPeriodo
  Left = 0
  Top = 0
  Caption = 'SISCOC-Per'#237'odo '
  ClientHeight = 191
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 44
    Top = 49
    Width = 66
    Height = 21
    AutoSize = False
    Caption = 'Data Inicial:'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 44
    Top = 73
    Width = 62
    Height = 21
    AutoSize = False
    Caption = 'Data Final:'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 121
    Top = 28
    Width = 114
    Height = 17
    AutoSize = False
    Caption = '(DD/MM/AAAA'
    WordWrap = True
  end
  object Text1: TEdit
    Left = 121
    Top = 44
    Width = 114
    Height = 21
    TabOrder = 0
  end
  object Text2: TEdit
    Left = 121
    Top = 73
    Width = 114
    Height = 21
    TabOrder = 1
  end
  object Command1: TButton
    Left = 154
    Top = 125
    Width = 82
    Height = 33
    Caption = 'Ok'
    TabOrder = 3
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 44
    Top = 125
    Width = 82
    Height = 33
    Caption = '&Cancela'
    TabOrder = 2
    OnClick = Command2Click
  end
end
