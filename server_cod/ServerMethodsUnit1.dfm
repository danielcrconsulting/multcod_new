object ServerMethods1: TServerMethods1
  OnCreate = DSServerModuleCreate
  OnDestroy = DSServerModuleDestroy
  Height = 251
  Width = 528
  PixelsPerInch = 96
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 128
    Top = 144
  end
  object FDCon: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL')
    Left = 24
    Top = 80
  end
  object FDQry: TFDQuery
    Connection = FDCon
    FormatOptions.AssignedValues = [fvDataSnapCompatibility, fvADOCompatibility]
    FormatOptions.DataSnapCompatibility = True
    FormatOptions.ADOCompatibility = True
    Left = 144
    Top = 72
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 192
    Top = 16
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 48
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 224
    Top = 104
  end
  object FDConE: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL')
    Left = 344
    Top = 96
  end
  object FDQryE: TFDQuery
    Connection = FDConE
    FormatOptions.AssignedValues = [fvDataSnapCompatibility, fvADOCompatibility]
    FormatOptions.DataSnapCompatibility = True
    FormatOptions.ADOCompatibility = True
    Left = 336
    Top = 168
  end
  object Query1: TQuery
    SessionName = 'SESBANCO'
    SQL.Strings = (
      'SELECT * FROM RELATORIO_20220221_205423')
    Left = 328
    Top = 32
  end
  object Query2: TQuery
    SessionName = 'SESBANCO'
    Left = 416
    Top = 40
  end
  object Database1: TDatabase
    SessionName = 'Default'
    Left = 416
    Top = 144
  end
  object Session1: TSession
    NetFileDir = 'C:\TEMP'
    Left = 392
    Top = 8
  end
end
