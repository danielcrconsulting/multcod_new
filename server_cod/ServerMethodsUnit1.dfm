object ServerMethods1: TServerMethods1
  OnDestroy = DSServerModuleDestroy
  Height = 251
  Width = 486
  PixelsPerInch = 120
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
end
