object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Capa Tab'
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
    Left = 24
    Top = 91
    Width = 37
    Height = 13
    Caption = 'Arquivo'
  end
  object Edit1: TEdit
    Left = 96
    Top = 88
    Width = 523
    Height = 21
    TabOrder = 0
    OnDblClick = Edit1DblClick
  end
  object Button1: TButton
    Left = 544
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Processar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 96
    Top = 152
    Width = 523
    Height = 21
    TabOrder = 3
    Text = 'Edit2'
  end
  object Button3: TButton
    Left = 96
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Testar'
    TabOrder = 4
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Left = 272
    Top = 232
  end
end
