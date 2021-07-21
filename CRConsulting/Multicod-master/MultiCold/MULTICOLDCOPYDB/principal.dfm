object fPrincipal: TfPrincipal
  Left = 649
  Top = 98
  Width = 796
  Height = 600
  Caption = 'Multicold Apagador de Dados - Vers'#227'o 1.1 (14/03/2012)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 535
    Width = 788
    Height = 19
    Panels = <>
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 769
    Height = 489
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Top = 504
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object N1: TMenuItem
        Caption = '-'
      end
      object Configuraes1: TMenuItem
        Caption = 'Apagar Dados ...'
        OnClick = Configuraes1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = 'Sai&r'
        OnClick = Sair1Click
      end
    end
    object Relatrios2: TMenuItem
      Caption = '&Relat'#243'rios'
      Visible = False
      object Logdeacesso1: TMenuItem
        Caption = '&Log de acesso ...'
        Enabled = False
      end
      object Protocolo1: TMenuItem
        Caption = 'Protocolo ...'
        Enabled = False
      end
      object Usurios3: TMenuItem
        Caption = 'Seguran'#231'a ...'
        Enabled = False
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.txt'
    Filter = 'txt|*.txt'
    InitialDir = '.'
    Left = 40
    Top = 504
  end
end
