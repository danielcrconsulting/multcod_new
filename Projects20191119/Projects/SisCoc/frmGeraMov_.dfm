object frmGeraMov: TfrmGeraMov
  Left = 0
  Top = 0
  Caption = 'SISCOC-Arquivos de Movimento'
  ClientHeight = 432
  ClientWidth = 531
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
    Top = 16
    Width = 163
    Height = 17
    AutoSize = False
    Caption = 'Path para Arquivo de Relat'#243'rios:'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 147
    Height = 17
    AutoSize = False
    Caption = 'Path para Templates:'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 16
    Top = 65
    Width = 147
    Height = 17
    AutoSize = False
    Caption = 'Path para Arquivo de Saida:'
    WordWrap = True
  end
  object Command2: TButton
    Left = 202
    Top = 388
    Width = 82
    Height = 33
    Caption = '&Processar'
    TabOrder = 0
    OnClick = Command2Click
  end
  object Command1: TButton
    Left = 8
    Top = 388
    Width = 82
    Height = 33
    Caption = 'Sair'
    TabOrder = 1
    OnClick = Command1Click
  end
  object Frame1: TGroupBox
    Left = 8
    Top = 105
    Width = 511
    Height = 272
    Caption = 'Arquivos para Movimento'
    TabOrder = 2
    object Command3: TButton
      Left = 12
      Top = 235
      Width = 62
      Height = 21
      Caption = '&Nova'
      TabOrder = 0
      OnClick = Command3Click
    end
    object Command4: TButton
      Left = 105
      Top = 235
      Width = 62
      Height = 21
      Caption = 'Exclui'
      TabOrder = 1
      OnClick = Command4Click
    end
    object Command5: TButton
      Left = 198
      Top = 235
      Width = 62
      Height = 21
      Caption = 'Grava'
      TabOrder = 2
      OnClick = Command5Click
    end
    object grdMovimento: TDBGrid
      Left = 3
      Top = 16
      Width = 505
      Height = 213
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Text1: TEdit
    Left = 178
    Top = 16
    Width = 341
    Height = 21
    TabOrder = 3
    OnDblClick = Text1DblClick
  end
  object Text2: TEdit
    Left = 178
    Top = 40
    Width = 341
    Height = 21
    TabOrder = 4
    OnDblClick = Text2DblClick
  end
  object Text3: TEdit
    Left = 178
    Top = 65
    Width = 341
    Height = 21
    TabOrder = 5
    OnDblClick = Text3DblClick
  end
  object DataSource1: TDataSource
    Left = 328
    Top = 384
  end
end
