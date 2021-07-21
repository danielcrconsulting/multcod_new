object DataLimite: TDataLimite
  Left = 0
  Top = 0
  Caption = 'SISCOC-Data do Saldo'
  ClientHeight = 141
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 146
    Top = 24
    Width = 114
    Height = 17
    AutoSize = False
    Caption = '(DD/MM/AAAA'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 12
    Top = 44
    Width = 126
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Data do Saldo:'
    WordWrap = True
  end
  object Command1: TButton
    Left = 178
    Top = 81
    Width = 82
    Height = 33
    Caption = 'Ok'
    TabOrder = 1
    OnClick = Command1Click
  end
  object Text1: TEdit
    Left = 146
    Top = 40
    Width = 114
    Height = 29
    TabOrder = 0
  end
  object Command2: TButton
    Left = 69
    Top = 81
    Width = 82
    Height = 33
    Caption = '&Cancela'
    TabOrder = 2
    OnClick = Command2Click
  end
end
