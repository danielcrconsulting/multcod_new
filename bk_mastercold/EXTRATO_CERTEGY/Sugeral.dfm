object FormGeral: TFormGeral
  Left = 236
  Top = 408
  Caption = 'FormGeral'
  ClientHeight = 457
  ClientWidth = 977
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object TableLogProc: TIBTable
    Database = IBLogRemotoDatabase
    Transaction = IBLogRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'LOGPROC'
    PrecommittedReads = False
    UniDirectional = False
    Left = 752
    Top = 152
  end
  object TableProtocolo: TIBTable
    Database = IBLogRemotoDatabase
    Transaction = IBProtocoloTransaction
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'PROTOCOLO'
    PrecommittedReads = False
    UniDirectional = False
    Left = 496
    Top = 56
  end
  object TableUsuRel: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'USUREL'
    PrecommittedReads = False
    UniDirectional = False
    Left = 56
    Top = 368
  end
  object TableDFN: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    AfterInsert = TableDFNAfterInsert
    AfterScroll = TableDFNAfterScroll
    BeforePost = TableDFNBeforePost
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'DFN'
    PrecommittedReads = False
    UniDirectional = False
    Left = 56
    Top = 320
  end
  object TableGUsuarios: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    AfterPost = TableGUsuariosAfterPost
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'GRUPOUSUARIOS'
    PrecommittedReads = False
    UniDirectional = False
    Left = 56
    Top = 272
  end
  object TableUsuarios: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'USUARIOS'
    PrecommittedReads = False
    UniDirectional = False
    Left = 56
    Top = 224
  end
  object TableSubGruposDFN: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'SUBGRUPOSDFN'
    PrecommittedReads = False
    UniDirectional = False
    Left = 56
    Top = 176
  end
  object TableGruposDFN: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    AfterPost = TableGruposDFNAfterPost
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'GRUPOSDFN'
    PrecommittedReads = False
    UniDirectional = False
    Left = 56
    Top = 128
  end
  object TableTemp: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    StoreDefs = True
    TableName = 'TEMP'
    PrecommittedReads = False
    UniDirectional = False
    Left = 160
    Top = 176
  end
  object IBSQLAux1: TIBSQL
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    Left = 232
    Top = 184
  end
  object TableProd: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    PrecommittedReads = False
    UniDirectional = False
    Left = 232
    Top = 128
  end
  object TableAux2: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    PrecommittedReads = False
    UniDirectional = False
    Left = 160
    Top = 128
  end
  object TableAux1: TIBTable
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    PrecommittedReads = False
    UniDirectional = False
    Left = 160
    Top = 80
  end
  object IBAdmRemotoTransaction: TIBTransaction
    DefaultDatabase = IBAdmRemotoDatabase
    Left = 56
    Top = 24
  end
  object IBAdmRemotoDatabase: TIBDatabase
    Params.Strings = (
      'user_name=SYSDBA'
      'password=ghqp4908')
    LoginPrompt = False
    DefaultTransaction = IBAdmRemotoTransaction
    ServerType = 'IBServer'
    Left = 56
    Top = 80
  end
  object IBLogRemotoTransaction: TIBTransaction
    DefaultDatabase = IBLogRemotoDatabase
    Left = 624
    Top = 8
  end
  object IBLogRemotoDatabase: TIBDatabase
    Params.Strings = (
      'user_name=SYSDBA'
      'password=ghqp4908'
      '')
    LoginPrompt = False
    DefaultTransaction = IBLogRemotoTransaction
    ServerType = 'IBServer'
    Left = 752
    Top = 8
  end
  object QueryLocal2: TIBQuery
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = True
    PrecommittedReads = False
    Left = 160
    Top = 368
  end
  object QueryLocal1: TIBQuery
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = True
    PrecommittedReads = False
    Left = 160
    Top = 320
  end
  object QueryProd: TIBQuery
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 224
    Top = 80
  end
  object QueryAux2: TIBQuery
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = True
    PrecommittedReads = False
    Left = 160
    Top = 272
  end
  object QueryAux1: TIBQuery
    Database = IBAdmRemotoDatabase
    Transaction = IBAdmRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    UniDirectional = True
    PrecommittedReads = False
    Left = 160
    Top = 224
  end
  object IBQueryAuxL1: TIBQuery
    Database = IBLogRemotoDatabase
    Transaction = IBLogRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 752
    Top = 104
  end
  object IBQueryInsertProtocolo: TIBQuery
    Database = IBLogRemotoDatabase
    Transaction = IBLogRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'INSERT INTO PROTOCOLO VALUES'
      '('
      ':A,'
      ':B,'
      ':C,'
      ':D,'
      ':E,'
      ':F,'
      ':G,'
      ':H,'
      ':I,'
      ':J,'
      ':K,'
      ':L,'
      ':M,'
      ':N,'
      ':O,'
      ':P'
      ')')
    PrecommittedReads = False
    Left = 496
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'A'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'B'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'C'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'D'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'E'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'F'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'G'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'H'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'I'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'J'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'K'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'L'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'M'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'N'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'O'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'P'
        ParamType = ptUnknown
      end>
  end
  object IBQueryInsertLogProc: TIBQuery
    Database = IBLogRemotoDatabase
    Transaction = IBLogRemotoTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'INSERT INTO LOGPROC VALUES'
      '('
      ':A,'
      ':B,'
      ':C,'
      ':D,'
      ':E,'
      ':F,'
      ':G'
      ')')
    PrecommittedReads = False
    Left = 752
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'A'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'B'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'C'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'D'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'E'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'F'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'G'
        ParamType = ptUnknown
      end>
  end
  object IBProtocoloTransaction: TIBTransaction
    DefaultDatabase = IBLogRemotoDatabase
    Left = 496
    Top = 8
  end
end
