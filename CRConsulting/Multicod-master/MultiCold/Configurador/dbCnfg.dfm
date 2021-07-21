object frmDbCnfg: TfrmDbCnfg
  Left = 406
  Top = 237
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Configurar acesso ao SQL Server'
  ClientHeight = 225
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 83
    Height = 13
    Caption = '&Nome do servidor'
    FocusControl = Edit1
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 216
    Height = 13
    Caption = 'Nome de &usu'#225'rio (permiss'#227'o de administrador)'
    FocusControl = Edit2
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 31
    Height = 13
    Caption = '&Senha'
    FocusControl = Edit3
  end
  object Label4: TLabel
    Left = 8
    Top = 152
    Width = 292
    Height = 13
    Caption = '&Diret'#243'rio do servidor onde os arquivos do banco ser'#227'o criados'
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 297
    Height = 21
    TabOrder = 0
    Text = 'CRCSVR0001'
  end
  object Edit2: TEdit
    Left = 8
    Top = 72
    Width = 297
    Height = 21
    TabOrder = 1
    Text = 'sa'
  end
  object Button1: TButton
    Left = 153
    Top = 197
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 233
    Top = 197
    Width = 75
    Height = 25
    Caption = '&Cancelar'
    ModalResult = 2
    TabOrder = 5
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 8
    Top = 120
    Width = 297
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    Text = 'ayrtonsenna'
  end
  object Edit4: TEdit
    Left = 8
    Top = 168
    Width = 297
    Height = 21
    TabOrder = 3
    Text = 'c:\Arquivos de programas\Microsoft SQL Server\MSSQL\Data'
  end
end
