object JaConf: TJaConf
  Left = 215
  Top = 106
  Width = 661
  Height = 236
  BorderIcons = [biSystemMenu]
  Caption = 'Diret'#243'rios'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 24
    Top = 104
    Width = 86
    Height = 13
    Caption = 'Diret'#243'rio de Sa'#237'da'
  end
  object Label1: TLabel
    Left = 24
    Top = 40
    Width = 94
    Height = 13
    Caption = 'Diret'#243'rio de Entrada'
  end
  object Edit2: TEdit
    Left = 136
    Top = 96
    Width = 489
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = 'Edit2'
  end
  object Button1: TButton
    Left = 24
    Top = 168
    Width = 75
    Height = 25
    Caption = '&Ok'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 136
    Top = 32
    Width = 489
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = 'Edit1'
  end
end
