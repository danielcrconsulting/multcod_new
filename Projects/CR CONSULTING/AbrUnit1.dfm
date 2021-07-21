object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Lister'
  ClientHeight = 624
  ClientWidth = 885
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
    Left = 25
    Top = 544
    Width = 41
    Height = 13
    Caption = 'Arquivo:'
  end
  object Label2: TLabel
    Left = 24
    Top = 576
    Width = 40
    Height = 13
    Caption = 'Posi'#231#227'o:'
  end
  object Edit1: TEdit
    Left = 72
    Top = 536
    Width = 801
    Height = 21
    TabOrder = 0
    OnDblClick = Edit1DblClick
  end
  object Edit2: TEdit
    Left = 72
    Top = 568
    Width = 321
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 408
    Top = 563
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 798
    Top = 584
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 25
    Top = 16
    Width = 848
    Height = 514
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Left = 656
    Top = 576
  end
end
