object ContaExtrForm: TContaExtrForm
  Left = 0
  Top = 103
  Caption = 'Conta Extratos por M'#234's'
  ClientHeight = 441
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 14
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 385
    Height = 425
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object SairButton: TButton
    Left = 416
    Top = 408
    Width = 91
    Height = 25
    Cancel = True
    Caption = '&Sair'
    ModalResult = 2
    TabOrder = 1
    OnClick = SairButtonClick
  end
  object SalvarButton: TButton
    Left = 416
    Top = 368
    Width = 91
    Height = 25
    Caption = 'S&alvar'
    Enabled = False
    TabOrder = 2
    OnClick = SalvarButtonClick
  end
  object ContaButton: TButton
    Left = 416
    Top = 328
    Width = 91
    Height = 25
    Caption = 'Conta'
    TabOrder = 3
    OnClick = ContaButtonClick
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = '*.txt|*.txt'
    Left = 448
    Top = 136
  end
end
