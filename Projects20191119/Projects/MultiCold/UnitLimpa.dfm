object Form1: TForm1
  Left = 257
  Top = 144
  BorderStyle = bsSingle
  Caption = 
    'MultiCold - Utilit'#225'rio de Limpeza de Relat'#243'rios - V1.3.0.0 01/10' +
    '/2014'
  ClientHeight = 426
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnClose = FormClose
  DesignSize = (
    632
    426)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 363
    Width = 100
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Data limite para corte'
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 8
    Width = 618
    Height = 345
    Anchors = [akLeft, akTop, akRight, akBottom]
    Indent = 19
    TabOrder = 0
  end
  object MaskEdit1: TMaskEdit
    Left = 121
    Top = 359
    Width = 120
    Height = 21
    Anchors = [akLeft, akBottom]
    EditMask = '!99/99/0000;0;_'
    MaxLength = 10
    TabOrder = 1
    Text = ''
  end
  object Button1: TButton
    Left = 304
    Top = 392
    Width = 161
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = 'Grava'#231#227'o e Limpeza'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 464
    Top = 392
    Width = 161
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = 'Sair'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 245
    Top = 359
    Width = 381
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ReadOnly = True
    TabOrder = 4
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 16
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object GravaoeLimpeza1: TMenuItem
        Caption = '&Grava'#231#227'o e Limpeza'
        OnClick = Button1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
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
