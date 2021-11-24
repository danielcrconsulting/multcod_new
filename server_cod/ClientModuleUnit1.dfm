object ClientModule1: TClientModule1
  Height = 251
  Width = 486
  PixelsPerInch = 120
  object SQLConnection1: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'Port=8080'
      'CommunicationProtocol=http'
      'DatasnapContext=datasnap/')
    Left = 48
    Top = 40
  end
  object DSRestConnection1: TDSRestConnection
    Host = 'localhost'
    Port = 8080
    UserName = 'multicoldserver'
    Password = 'server@#2021'
    LoginPrompt = False
    Left = 248
    Top = 104
    UniqueId = '{2624C1CB-9199-4B05-AC12-9D19F08B7453}'
  end
end
