object ServerMethods1: TServerMethods1
  OnDestroy = DSServerModuleDestroy
  Height = 216
  Width = 316
  PixelsPerInch = 96
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 128
    Top = 144
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 56
    Top = 16
  end
  object FDCon: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL')
    Left = 24
    Top = 80
  end
  object FDQry: TFDQuery
    Connection = FDCon
    Left = 144
    Top = 72
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 192
    Top = 16
  end
end
