object AltCasGrupForm: TAltCasGrupForm
  Left = 236
  Top = 251
  Caption = 'Altera'#231#227'o de c'#243'digo em Cascata - Grupo'
  ClientHeight = 183
  ClientWidth = 323
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
    Top = 56
    Width = 72
    Height = 13
    Caption = 'C'#243'digo Anterior'
  end
  object Label2: TLabel
    Left = 24
    Top = 96
    Width = 62
    Height = 13
    Caption = 'Novo C'#243'digo'
  end
  object Edit2: TEdit
    Left = 120
    Top = 88
    Width = 177
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 120
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Alterar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 3
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
