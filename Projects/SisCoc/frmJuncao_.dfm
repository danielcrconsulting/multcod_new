object frmJuncao: TfrmJuncao
  Left = 0
  Top = 0
  Caption = 'SISCOC-Jun'#231#227'o de Arquivos'
  ClientHeight = 397
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Frame1: TGroupBox
    Left = 24
    Top = 16
    Width = 276
    Height = 296
    Caption = 'Arquivos para Jun'#231#227'o'
    TabOrder = 0
    object cmdGrava: TButton
      Left = 198
      Top = 263
      Width = 62
      Height = 21
      Caption = 'Grava'
      TabOrder = 2
      OnClick = cmdGravaClick
    end
    object cmdDelete: TButton
      Left = 105
      Top = 263
      Width = 62
      Height = 21
      Caption = 'Exclui'
      TabOrder = 0
      OnClick = cmdDeleteClick
    end
    object cmdNew: TButton
      Left = 12
      Top = 263
      Width = 62
      Height = 21
      Caption = '&Nova'
      TabOrder = 1
      OnClick = cmdNewClick
    end
    object GrdJuncao: TMemo
      Left = 12
      Top = 16
      Width = 253
      Height = 241
      TabOrder = 3
    end
  end
  object Command1: TButton
    Left = 24
    Top = 336
    Width = 82
    Height = 33
    Caption = 'Sair'
    TabOrder = 1
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 218
    Top = 336
    Width = 82
    Height = 33
    Caption = '&Processar'
    TabOrder = 2
    OnClick = Command2Click
  end
end
