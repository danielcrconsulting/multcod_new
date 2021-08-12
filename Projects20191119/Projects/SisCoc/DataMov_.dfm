object DataMov: TDataMov
  Left = 0
  Top = 0
  Caption = 'SISCOC-Data de Gera'#231#227'o do Arquivo '
  ClientHeight = 152
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
    Left = 125
    Top = 28
    Width = 114
    Height = 17
    AutoSize = False
    Caption = '(DD/MM/AA)'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 20
    Top = 49
    Width = 102
    Height = 21
    AutoSize = False
    Caption = 'Data do Movimento'
    WordWrap = True
  end
  object Command1: TButton
    Left = 158
    Top = 93
    Width = 82
    Height = 33
    Caption = 'Ok'
    TabOrder = 1
    OnClick = Command1Click
  end
  object Text1: TEdit
    Left = 125
    Top = 44
    Width = 114
    Height = 29
    TabOrder = 0
  end
  object Command2: TButton
    Left = 20
    Top = 93
    Width = 82
    Height = 33
    Caption = '&Sair'
    TabOrder = 2
    OnClick = Command2Click
  end
end
