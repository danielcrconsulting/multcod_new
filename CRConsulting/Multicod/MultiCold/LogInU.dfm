object LogInForm: TLogInForm
  Left = 387
  Top = 222
  Width = 287
  Height = 217
  BorderIcons = []
  Caption = 'Log In'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 36
    Height = 13
    Caption = 'Usu'#225'rio'
  end
  object Label2: TLabel
    Left = 24
    Top = 88
    Width = 31
    Height = 13
    Caption = 'Senha'
  end
  object Button1: TButton
    Left = 16
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancela'
    TabOrder = 3
    OnClick = Button2Click
  end
  object UsuEdit: TEdit
    Left = 80
    Top = 40
    Width = 169
    Height = 21
    TabOrder = 0
  end
  object SenhaEdit: TEdit
    Left = 80
    Top = 80
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
end
