object DMMain: TDMMain
  OnCreate = DataModuleCreate
  Height = 251
  Width = 486
  PixelsPerInch = 96
  object ConnW: TADOConnection
    ConnectionString = 'FILE NAME=Multicold.udl'
    Provider = 'Multicold.udl'
    Left = 40
    Top = 16
  end
  object QryPendentes: TADOQuery
    Connection = ConnW
    Parameters = <>
    SQL.Strings = (
      'select'
      #9'Id,'
      #9'TipoProcessamento,'
      #9'IdReferencia,'
      #9'PathRelatorio,'
      #9'StatusProcessamento,'
      #9'ArquivoTemplateComp,'
      #9'CODUSUARIO,'
      #9'SENHA,'
      '    DataCriacao'
      'from ConsultaProcessadorExtrator'
      'order by CODUSUARIO, DataCriacao')
    Left = 120
    Top = 16
  end
  object CmdUpdate: TADOCommand
    Connection = ConnW
    Parameters = <>
    Left = 120
    Top = 80
  end
  object ADOQryDescomp: TADOQuery
    Connection = ConnW
    Parameters = <
      item
        Name = 'Id'
        DataType = ftInteger
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select '
      #9'Id,'
      #9'TipoDescompactacao,'
      #9'RemoverBrancos,'
      #9'Orig,'
      #9'IntervaloIni,'
      #9'IntervaloFin,'
      #9'IndexPaginaAtual,'
      #9'ApenasLinhasPesquisa,'
      #9'PesquisaMensagem'
      'from ParametroDescompactador '
      'where Id = :Id')
    Left = 248
    Top = 16
  end
  object ADOQryPesq: TADOQuery
    Connection = ConnW
    Parameters = <
      item
        Name = 'IdParametroDescompactador'
        DataType = ftInteger
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select '
      #9'Id,'
      #9'IdParametroDescompactador,'
      #9'IndexPesq,'
      #9'Campo,'
      #9'Operador,'
      #9'Valor,'
      #9'Conector'#9
      'from ParametroPesquisa'
      'where IdParametroDescompactador = :IdParametroDescompactador')
    Left = 376
    Top = 16
  end
  object FDQuery1: TFDQuery
    Left = 344
    Top = 112
  end
  object MemPen: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 152
    Top = 176
  end
  object MemDes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 224
    Top = 176
  end
  object MemPesq: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 296
    Top = 176
  end
end
