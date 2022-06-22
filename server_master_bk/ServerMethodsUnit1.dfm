object ServerMethods1: TServerMethods1
  Height = 201
  Width = 389
  PixelsPerInch = 96
  object FDCon: TFDConnection
    Params.Strings = (
      'Database=C:\CD_BMG\MASTERCOLD\Origem\Database\MASTERCOLD.gdb'
      'User_Name=SYSDBA'
      'Password=ghqp4908'
      'DriverID=FB')
    LoginPrompt = False
    Left = 304
    Top = 40
  end
  object FDConLog: TFDConnection
    Params.Strings = (
      'Database=C:\CD_BMG\MASTERCOLD\Origem\Database\MASTERLOG.GDB'
      'User_Name=SYSDBA'
      'Password=ghqp4908'
      'DriverID=FB')
    LoginPrompt = False
    Left = 304
    Top = 120
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 224
    Top = 32
  end
end
