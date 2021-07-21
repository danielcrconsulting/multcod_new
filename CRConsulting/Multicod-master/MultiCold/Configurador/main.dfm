object frmPrincipal: TfrmPrincipal
  Left = 234
  Top = 110
  Width = 696
  Height = 475
  Caption = 'Multicold Config v. 1.0 - 17/02/2006'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    688
    441)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 120
    Height = 13
    Caption = 'Configurador do Multicold'
  end
  object Memo1: TMemo
    Left = 8
    Top = 32
    Width = 673
    Height = 354
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object Button1: TButton
    Left = 528
    Top = 409
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Iniciar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 608
    Top = 409
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Sair'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 392
    Width = 673
    Height = 15
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
  end
  object ADOConnection1: TADOConnection
    Left = 48
    Top = 48
  end
  object ADOCommand1: TADOCommand
    Connection = ADOConnection1
    Parameters = <>
    Left = 48
    Top = 104
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 48
    Top = 160
  end
end
