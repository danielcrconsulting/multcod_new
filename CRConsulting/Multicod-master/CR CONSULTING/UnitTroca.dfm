object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 
    'Troca + e -; Acerta Totais e Tira Rabicho EXTR;  Altera Moeda e ' +
    'Troca Rabicho DETEX - V 4.0'
  ClientHeight = 299
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
    Left = 8
    Top = 67
    Width = 126
    Height = 13
    Caption = 'Arquivo a ser processado:'
  end
  object Label2: TLabel
    Left = 8
    Top = 115
    Width = 48
    Height = 13
    Caption = 'Progresso'
  end
  object Button1: TButton
    Left = 552
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Trocar + -'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 169
    Top = 64
    Width = 458
    Height = 21
    TabOrder = 2
    OnDblClick = Edit1DblClick
  end
  object Edit2: TEdit
    Left = 169
    Top = 112
    Width = 224
    Height = 21
    TabOrder = 3
  end
  object Button3: TButton
    Left = 89
    Top = 264
    Width = 128
    Height = 25
    Caption = 'Tira Rabicho EXTR'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 223
    Top = 264
    Width = 130
    Height = 25
    Caption = 'Acerta TotCmpExt EXTR'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 359
    Top = 264
    Width = 122
    Height = 25
    Caption = 'Acerta Moeda DETEX'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 89
    Top = 224
    Width = 128
    Height = 25
    Caption = 'Tira Rabicho DETEX'
    TabOrder = 7
    OnClick = Button6Click
  end
  object OpenDialog1: TOpenDialog
    Left = 560
    Top = 24
  end
end
