object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'MasterCold Junta Arquivos V 1.0 02/02/2018'
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
  object Label3: TLabel
    Left = 32
    Top = 80
    Width = 47
    Height = 13
    Caption = 'Arquivo : '
  end
  object ButtonJuntar: TButton
    Left = 32
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Juntar'
    TabOrder = 0
    OnClick = ButtonJuntarClick
  end
  object Button2: TButton
    Left = 534
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 85
    Top = 77
    Width = 524
    Height = 21
    TabOrder = 2
  end
end
