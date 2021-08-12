object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'SISCOC-Login'
  ClientHeight = 107
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblLabels_0: TLabel
    Left = 7
    Top = 10
    Width = 73
    Height = 17
    AutoSize = False
    Caption = '&Usu'#225'rio:'
    WordWrap = True
  end
  object lblLabels_1: TLabel
    Left = 7
    Top = 36
    Width = 73
    Height = 17
    AutoSize = False
    Caption = '&Senha:'
    WordWrap = True
  end
  object txtUserName: TEdit
    Left = 88
    Top = 9
    Width = 157
    Height = 21
    TabOrder = 0
    OnEnter = txtUserNameEnter
  end
  object txtPassword: TEdit
    Left = 88
    Top = 35
    Width = 157
    Height = 21
    TabOrder = 1
  end
  object cmdOK: TButton
    Left = 33
    Top = 69
    Width = 77
    Height = 24
    Caption = 'OK'
    TabOrder = 3
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 142
    Top = 69
    Width = 77
    Height = 24
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Left = 56
    Top = 8
  end
  object RsDb: TADODataSet
    Connection = ADOConnection1
    Parameters = <>
    Left = 224
    Top = 64
  end
end
