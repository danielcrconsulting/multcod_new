object SimulaMenu: TSimulaMenu
  Left = 0
  Top = 0
  Caption = 'SISCOC-OPC'#199#213'ES'
  ClientHeight = 398
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Frame1: TGroupBox
    Left = 16
    Top = 12
    Width = 361
    Height = 333
    Caption = 'Sele'#231#227'o de Op'#231#245'es'
    TabOrder = 0
    object Text1: TEdit
      Left = 8
      Top = 24
      Width = 345
      Height = 21
      TabOrder = 1
    end
    object List1: TListBox
      Left = 8
      Top = 44
      Width = 345
      Height = 280
      ItemHeight = 13
      TabOrder = 0
      OnClick = List1Click
    end
  end
  object Command1: TButton
    Left = 295
    Top = 356
    Width = 82
    Height = 33
    Caption = '&Ok'
    TabOrder = 1
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 16
    Top = 356
    Width = 82
    Height = 33
    Caption = '&Cancelar'
    TabOrder = 2
    OnClick = Command2Click
  end
end
