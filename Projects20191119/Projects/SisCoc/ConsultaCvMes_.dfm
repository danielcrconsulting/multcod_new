object ConsultaCvMes: TConsultaCvMes
  Left = 0
  Top = 0
  Caption = 'SISCOC-Consulta Item'
  ClientHeight = 378
  ClientWidth = 695
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 276
    Height = 21
    AutoSize = False
    WordWrap = True
  end
  object Command1: TButton
    Left = 595
    Top = 332
    Width = 82
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = Command1Click
  end
  object grdDataGrid: TDBGrid
    Left = 16
    Top = 48
    Width = 661
    Height = 278
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 16
    Top = 332
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 2
  end
  object cnAdoConect: TADOConnection
    ConnectionString = 'FILE NAME=C:\Rom\SisCoc\Admin.udl;'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 360
    Top = 8
  end
  object RsAdoDb: TADODataSet
    Connection = cnAdoConect
    CursorType = ctStatic
    BeforePost = RsAdoDbBeforePost
    CommandText = 'select * from tbConvMes order by Relatorio'
    Parameters = <>
    Left = 448
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = RsAdoDb
    Left = 536
    Top = 8
  end
end
