object MultiColdDataServer: TMultiColdDataServer
  OldCreateOrder = False
  OnCreate = RemoteDataModuleCreate
  Left = 90
  Top = 129
  Height = 480
  Width = 696
  object DataSetProvider: TDataSetProvider
    DataSet = QueryPsq
    Options = [poReadOnly, poDisableInserts, poDisableEdits, poDisableDeletes, poAllowCommandText]
    Left = 152
    Top = 144
  end
  object ibQuery1: TADOQuery
    Parameters = <>
    Left = 152
    Top = 24
  end
  object ibEventosQuery1: TADOQuery
    Parameters = <>
    Left = 152
    Top = 80
  end
  object DatabaseLocal: TADOConnection
    ConnectionString = 
      'FILE NAME=C:\Arquivos de programas\Arquivos comuns\System\OLE DB' +
      '\Data Links\Multicold.udl'
    LoginPrompt = False
    Provider = 
      'C:\Arquivos de programas\Arquivos comuns\System\OLE DB\Data Link' +
      's\Multicold.udl'
    Left = 48
    Top = 24
  end
  object DatabaseEventos: TADOConnection
    ConnectionString = 
      'FILE NAME=C:\Arquivos de programas\Arquivos comuns\System\OLE DB' +
      '\Data Links\MulticoldEventos.udl'
    LoginPrompt = False
    Provider = 
      'C:\Arquivos de programas\Arquivos comuns\System\OLE DB\Data Link' +
      's\MulticoldEventos.udl'
    Left = 48
    Top = 80
  end
  object QueryPsq: TADOQuery
    Parameters = <>
    Left = 152
    Top = 200
  end
end
