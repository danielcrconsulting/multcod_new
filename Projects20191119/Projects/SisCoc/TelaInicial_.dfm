object TelaInicial: TTelaInicial
  Left = 0
  Top = 0
  Caption = 'Sistema de Concilia'#231#227'o de Contas'
  ClientHeight = 456
  ClientWidth = 741
  Color = 16744576
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  WindowState = wsMaximized
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 202
    Top = 85
    Width = 381
    Height = 122
    AutoSize = False
    Caption = 'SISCOC'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -96
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 12
    Top = 235
    Width = 761
    Height = 62
    Alignment = taCenter
    AutoSize = False
    Caption = 'Sistema de Concilia'#231#227'o de Contas'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -48
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label3: TLabel
    Left = 307
    Top = 469
    Width = 163
    Height = 46
    AutoSize = False
    Caption = 'CR Consulting '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Command1: TButton
    Left = 324
    Top = 340
    Width = 114
    Height = 41
    Caption = 'Login'
    TabOrder = 0
    OnClick = Command1Click
  end
end
