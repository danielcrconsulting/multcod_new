object Form1: TForm1
  Left = 206
  Top = 117
  Caption = 
    'MultiCold - Utilit'#225'rio de Limpeza de Relat'#243'rios - V6.0 22/10/200' +
    '3'
  ClientHeight = 583
  ClientWidth = 817
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 504
    Width = 100
    Height = 13
    Caption = 'Data limite para corte'
  end
  object MaskEdit1: TMaskEdit
    Left = 128
    Top = 496
    Width = 153
    Height = 21
    EditMask = '!99/99/0000;0;_'
    MaxLength = 10
    TabOrder = 0
    Text = ''
  end
  object Button1: TButton
    Left = 16
    Top = 536
    Width = 161
    Height = 25
    Caption = 'Grava'#231#227'o e Limpeza'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 712
    Top = 536
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 312
    Top = 496
    Width = 481
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 785
    Height = 465
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 536
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object Sair1: TMenuItem
        Caption = '&Sair'
        OnClick = Sair1Click
      end
    end
    object Configuraes1: TMenuItem
      Caption = '&Configura'#231#245'es'
      object Diretrios1: TMenuItem
        Caption = '&Diret'#243'rios'
        OnClick = Diretrios1Click
      end
    end
  end
end
