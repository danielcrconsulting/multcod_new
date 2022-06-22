object Form1: TForm1
  Left = -2
  Top = 103
  Width = 847
  Height = 600
  Caption = 'Contador de Extratos Santander'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 99
    Height = 13
    Caption = 'Diret'#243'rio a pesquisar:'
  end
  object Edit1: TEdit
    Left = 136
    Top = 32
    Width = 649
    Height = 21
    TabOrder = 0
    Text = 'C:\Rom\MasterCold\Destino\BMG\EXTRATO\MOVTO'
  end
  object Memo1: TMemo
    Left = 16
    Top = 104
    Width = 769
    Height = 401
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 16
    Top = 536
    Width = 113
    Height = 25
    Caption = 'Inicia Contagem'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 712
    Top = 536
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 3
    OnClick = Button2Click
  end
end
