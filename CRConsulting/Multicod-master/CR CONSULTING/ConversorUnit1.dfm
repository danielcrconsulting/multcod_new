object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Conversor de arquivos texto UNIX x WINDOWS  V1.0'
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
    Top = 24
    Width = 41
    Height = 13
    Caption = 'Arquivo:'
  end
  object Edit1: TEdit
    Left = 80
    Top = 16
    Width = 521
    Height = 21
    TabOrder = 0
    OnDblClick = Edit1DblClick
  end
  object Button1: TButton
    Left = 80
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Converter'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 526
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 2
    OnClick = Button2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 64
    Top = 208
  end
end
