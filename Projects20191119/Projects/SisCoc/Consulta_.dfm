object Consulta: TConsulta
  Left = 0
  Top = 0
  Caption = 'SISCOC-Consulta Item'
  ClientHeight = 275
  ClientWidth = 694
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
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
    Left = 599
    Top = 222
    Width = 82
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = Command1Click
  end
  object grdDataGrid: TDBGrid
    Left = 8
    Top = 39
    Width = 673
    Height = 169
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = grdDataGridDblClick
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 225
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 2
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 400
    Top = 8
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 'FILE NAME=C:\Rom\SisCoc\Admin.udl;'
    LoginPrompt = False
    Provider = 'SQLNCLI11'
    Left = 488
    Top = 8
  end
  object ADODataSet1: TADODataSet
    Connection = ADOConnection1
    CursorType = ctStatic
    CommandText = 'select * from usuarios'
    FieldDefs = <
      item
        Name = 'cd_grupo_usu'
        Attributes = [faFixed]
        DataType = ftSmallint
      end
      item
        Name = 'Id_Usuario'
        DataType = ftWideString
        Size = 20
      end
      item
        Name = 'Nome_Usuario'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'Senha'
        DataType = ftWideString
        Size = 20
      end>
    Parameters = <>
    StoreDefs = True
    Left = 576
    Top = 8
    object ADODataSet1cd_grupo_usu: TSmallintField
      FieldName = 'cd_grupo_usu'
    end
    object ADODataSet1Id_Usuario: TWideStringField
      FieldName = 'Id_Usuario'
    end
    object ADODataSet1Nome_Usuario: TWideStringField
      FieldName = 'Nome_Usuario'
      Size = 50
    end
    object ADODataSet1Senha: TWideStringField
      FieldName = 'Senha'
      OnGetText = ADODataSet1SenhaGetText
    end
  end
end
