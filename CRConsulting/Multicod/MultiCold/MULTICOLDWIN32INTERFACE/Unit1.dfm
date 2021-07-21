object Form1: TForm1
  Left = 215
  Top = 110
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ADOConnectio1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=ayrtonsenna;Persist Security Info=T' +
      'rue;User ID=sa;Initial Catalog=multicold;Data Source=CRCSVR0001'
    CursorLocation = clUseServer
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 48
    Top = 16
  end
  object ADOQuer1: TADOQuery
    CursorType = ctOpenForwardOnly
    Parameters = <>
    Left = 128
    Top = 16
  end
  object ADOTabl1: TADOTable
    CursorType = ctStatic
    TableName = 'paginaRelatorio'
    Left = 208
    Top = 16
    object ADOTabl1IDPAGINA: TAutoIncField
      FieldName = 'IDPAGINA'
      ReadOnly = True
    end
    object ADOTabl1PAGATUAL: TIntegerField
      FieldName = 'PAGATUAL'
    end
    object ADOTabl1PAGTOTAL: TIntegerField
      FieldName = 'PAGTOTAL'
    end
    object ADOTabl1ERROSISOP: TStringField
      FieldName = 'ERROSISOP'
      Size = 512
    end
    object ADOTabl1ERROMULTICOLD: TStringField
      FieldName = 'ERROMULTICOLD'
      Size = 512
    end
    object ADOTabl1TEXTO: TMemoField
      FieldName = 'TEXTO'
      BlobType = ftMemo
    end
    object ADOTabl1TEXTOCORRIGIDO: TMemoField
      FieldName = 'TEXTOCORRIGIDO'
      BlobType = ftMemo
    end
  end
  object ADOConnection1: TSQLConnection
    ConnectionName = 'MSSQLConnection'
    DriverName = 'MSSQL'
    GetDriverFunc = 'getSQLDriverMSSQL'
    LibraryName = 'dbexpmss.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MSSQL'
      'HostName=CRCSVR0001'
      'DataBase=MultiCold'
      'User_Name=sa'
      'Password=ayrtonsenna'
      'BlobSize=-1'
      'LocaleCode=0000'
      'MSSQL TransIsolation=ReadCommited'
      'OS Authentication=False')
    VendorLib = 'oledb'
    Left = 56
    Top = 96
  end
  object ADOQuery1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    Left = 144
    Top = 96
  end
  object ADOTable1: TSQLTable
    MaxBlobSize = -1
    TableName = 'paginaRelatorio'
    Left = 216
    Top = 96
    object ADOTable1IDPAGINA: TIntegerField
      FieldName = 'IDPAGINA'
      Required = True
    end
    object ADOTable1PAGATUAL: TIntegerField
      FieldName = 'PAGATUAL'
      Required = True
    end
    object ADOTable1PAGTOTAL: TIntegerField
      FieldName = 'PAGTOTAL'
      Required = True
    end
    object ADOTable1ERROSISOP: TStringField
      FieldName = 'ERROSISOP'
      FixedChar = True
      Size = 512
    end
    object ADOTable1ERROMULTICOLD: TStringField
      FieldName = 'ERROMULTICOLD'
      FixedChar = True
      Size = 512
    end
    object ADOTable1TEXTO: TMemoField
      FieldName = 'TEXTO'
      BlobType = ftMemo
      Size = 1
    end
    object ADOTable1TEXTOCORRIGIDO: TMemoField
      FieldName = 'TEXTOCORRIGIDO'
      BlobType = ftMemo
      Size = 1
    end
  end
end
