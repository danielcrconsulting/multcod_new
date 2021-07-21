object ConsultaCon: TConsultaCon
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'SISCOC-Alterar Registro'
  ClientHeight = 479
  ClientWidth = 803
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 21
    Width = 84
    Height = 13
    Caption = 'Filtro de Clientes:'
  end
  object cmdSair: TButton
    Left = 704
    Top = 417
    Width = 82
    Height = 33
    Caption = '&Sair'
    TabOrder = 0
    OnClick = cmdSairClick
  end
  object Data1: TDBNavigator
    Left = 16
    Top = 427
    Width = 230
    Height = 23
    DataSource = Data1_DataSource
    TabOrder = 1
  end
  object cmdRelatorio: TButton
    Left = 595
    Top = 417
    Width = 82
    Height = 33
    Caption = '&Relatorio'
    TabOrder = 2
    Visible = False
  end
  object Frame1: TGroupBox
    Left = 429
    Top = 4
    Width = 357
    Height = 46
    Caption = 'Ordem'
    TabOrder = 3
    object optDecres: TRadioButton
      Left = 125
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Decrescente'
      TabOrder = 0
      OnClick = optDecresClick
    end
    object cmbOrdena: TComboBox
      Left = 214
      Top = 16
      Width = 134
      Height = 21
      TabOrder = 1
      Text = 'Combo1'
      OnClick = cmbOrdenaClick
    end
    object optCres: TRadioButton
      Left = 44
      Top = 12
      Width = 70
      Height = 25
      Caption = 'Crescente'
      TabOrder = 2
      OnClick = optCresClick
    end
  end
  object DbGrid: TDBGrid
    Left = 16
    Top = 48
    Width = 770
    Height = 363
    DataSource = Data1_DataSource
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ComboBox1: TComboBox
    Left = 106
    Top = 21
    Width = 263
    Height = 21
    TabOrder = 5
    OnSelect = ComboBox1Select
  end
  object Data1_DataSource: TDataSource
    DataSet = Data1_DataSet
    Left = 496
    Top = 422
  end
  object Data1_DataSet: TADODataSet
    Connection = gBanco
    CursorType = ctStatic
    Parameters = <>
    Left = 678
    Top = 430
  end
  object gBanco: TADOConnection
    Left = 544
    Top = 424
  end
end
