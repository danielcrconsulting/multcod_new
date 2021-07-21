object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 454
  Top = 245
  Height = 323
  Width = 490
  object Query1: TQuery
    DatabaseName = 'MultiCold'
    SessionName = 'Session1_2'
    Left = 104
    Top = 16
  end
  object Database1: TDatabase
    AliasName = 'MSSQLMultiCold'
    DatabaseName = 'MultiCold'
    SessionName = 'Session1_2'
    OnLogin = Database1Login
    Left = 40
    Top = 16
  end
  object Session1: TSession
    AutoSessionName = True
    OnStartup = Session1Startup
    Left = 176
    Top = 72
  end
  object QueryPaginaRel: TQuery
    DatabaseName = 'MultiCold'
    SessionName = 'Session1_2'
    SQL.Strings = (
      'INSERT INTO paginaRelatorio values (:a, :b, :c, :d, :e, :f)')
    Left = 104
    Top = 72
    ParamData = <
      item
        DataType = ftInteger
        Name = 'a'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'b'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'c'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'd'
        ParamType = ptUnknown
      end
      item
        DataType = ftMemo
        Name = 'e'
        ParamType = ptUnknown
      end
      item
        DataType = ftMemo
        Name = 'f'
        ParamType = ptUnknown
      end>
  end
  object QueryCampos: TQuery
    DatabaseName = 'MultiCold'
    SessionName = 'Session1_2'
    SQL.Strings = (
      'INSERT INTO campoRelatorio values (:a, :b, :c, :d, :e)')
    Left = 104
    Top = 128
    ParamData = <
      item
        DataType = ftString
        Name = 'a'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'b'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'c'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'd'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'e'
        ParamType = ptUnknown
      end>
  end
  object QueryUpdateConsulta: TQuery
    DatabaseName = 'MultiCold'
    SessionName = 'Session1_2'
    SQL.Strings = (
      'UPDATE consulta SET sql = :a'
      'WHERE codconsulta = :b')
    Left = 104
    Top = 184
    ParamData = <
      item
        DataType = ftMemo
        Name = 'a'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'b'
        ParamType = ptUnknown
      end>
  end
  object QueryDbf: TQuery
    SessionName = 'Session1_2'
    Left = 176
    Top = 16
  end
end
