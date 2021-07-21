object DMMain: TDMMain
  OldCreateOrder = False
  Height = 275
  Width = 650
  object Conn: TADOConnection
    ConnectionString = 'FILE NAME=Multicold.udl'
    Provider = 'Multicold.udl'
    Left = 40
    Top = 16
  end
  object QryPendentes: TADOQuery
    Connection = Conn
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
    Connection = Conn
    Parameters = <>
    Left = 120
    Top = 80
  end
  object ADOQryDescomp: TADOQuery
    Connection = Conn
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
    Left = 208
    Top = 16
  end
  object ADOQryPesq: TADOQuery
    Connection = Conn
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
    Left = 288
    Top = 16
  end
end
