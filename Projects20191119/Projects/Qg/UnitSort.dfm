object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Teste de capacidade - CR Consulting'
  ClientHeight = 441
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 232
    Top = 24
    Width = 87
    Height = 13
    Caption = 'In'#237'cio do Inicializar'
  end
  object Label2: TLabel
    Left = 232
    Top = 48
    Width = 63
    Height = 13
    Caption = 'In'#237'cio do Sort'
  end
  object Label3: TLabel
    Left = 232
    Top = 75
    Width = 54
    Height = 13
    Caption = 'Fim do Sort'
  end
  object Button1: TButton
    Left = 544
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 336
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Alocar'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 94
    Width = 603
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 384
    Top = 16
    Width = 235
    Height = 21
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 384
    Top = 40
    Width = 235
    Height = 21
    TabOrder = 4
  end
  object Edit4: TEdit
    Left = 384
    Top = 67
    Width = 235
    Height = 21
    TabOrder = 5
  end
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 121
    Width = 303
    Height = 296
    Caption = 'Quantidade de elementos (milh'#245'es)'
    Items.Strings = (
      '200'
      '150'
      '100'
      '90'
      '80'
      '70'
      '60'
      '50'
      '40'
      '30'
      '20'
      '10')
    TabOrder = 6
  end
end
