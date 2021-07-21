object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 334
  Width = 446
  object ibEventosQuery1: TADOQuery
    Connection = DataBaseEventos
    Parameters = <>
    Left = 152
    Top = 72
  end
  object Query1: TQuery
    SessionName = 'Session1_1'
    Left = 384
    Top = 64
  end
  object Query2: TQuery
    SessionName = 'Session1_1'
    Left = 384
    Top = 128
  end
  object Session1: TSession
    AutoSessionName = True
    Left = 384
    Top = 8
  end
  object DataBaseLocal: TADOConnection
    LoginPrompt = False
    Left = 40
    Top = 8
  end
  object IBQuery1: TADOQuery
    Connection = DataBaseLocal
    Parameters = <>
    Left = 152
    Top = 8
  end
  object DataBaseEventos: TADOConnection
    Left = 40
    Top = 72
  end
end
