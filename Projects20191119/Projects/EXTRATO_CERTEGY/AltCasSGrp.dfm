object AltCasSGForm: TAltCasSGForm
  Left = 211
  Top = 201
  Caption = 'Altera'#231#227'o de c'#243'digo em Cascata - Sub Grupo'
  ClientHeight = 254
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 96
    Width = 72
    Height = 13
    Caption = 'C'#243'digo Anterior'
  end
  object Label2: TLabel
    Left = 24
    Top = 136
    Width = 62
    Height = 13
    Caption = 'Novo C'#243'digo'
  end
  object Label3: TLabel
    Left = 24
    Top = 56
    Width = 65
    Height = 13
    Caption = 'C'#243'digo Grupo'
  end
  object ComboBox2: TComboBox
    Left = 120
    Top = 88
    Width = 177
    Height = 21
    TabOrder = 1
    OnEnter = ComboBox2Click
  end
  object Edit2: TEdit
    Left = 120
    Top = 128
    Width = 177
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 120
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Alterar'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 4
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 120
    Top = 48
    Width = 177
    Height = 21
    TabOrder = 0
  end
end
