object DataDeAte: TDataDeAte
  Left = 0
  Top = 0
  Caption = 'SISCOC-Data da Jun'#231#227'o de Arquivos '
  ClientHeight = 187
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 121
    Top = 12
    Width = 114
    Height = 17
    AutoSize = False
    Caption = '(DD/MM/AA)'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 102
    Height = 21
    AutoSize = False
    Caption = 'Data de:'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 97
    Width = 102
    Height = 21
    AutoSize = False
    Caption = 'Data At'#233':'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 121
    Top = 77
    Width = 114
    Height = 17
    AutoSize = False
    Caption = '(DD/MM/AA)'
    WordWrap = True
  end
  object Command1: TButton
    Left = 158
    Top = 138
    Width = 82
    Height = 33
    Caption = 'Ok'
    TabOrder = 2
    OnClick = Command1Click
  end
  object Text1: TEdit
    Left = 121
    Top = 28
    Width = 114
    Height = 21
    TabOrder = 0
  end
  object Command2: TButton
    Left = 20
    Top = 138
    Width = 82
    Height = 33
    Caption = '&Sair'
    TabOrder = 3
    OnClick = Command2Click
  end
  object Text2: TEdit
    Left = 121
    Top = 93
    Width = 114
    Height = 21
    TabOrder = 1
  end
end
