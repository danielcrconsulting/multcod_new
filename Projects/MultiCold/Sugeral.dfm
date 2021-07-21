object FormGeral: TFormGeral
  Left = 290
  Top = 166
  Caption = 'FormGeral'
  ClientHeight = 386
  ClientWidth = 531
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DatabaseMultiCold: TADOConnection
    ConnectionString = 'FILE NAME=Multicold.udl'
    LoginPrompt = False
    Provider = 'Multicold.udl'
    Left = 40
    Top = 8
  end
  object TableDFN: TADOTable
    Connection = DatabaseMultiCold
    CursorType = ctStatic
    TableName = 'DFN'
    Left = 160
    Top = 8
  end
  object QueryLocal1: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <>
    Left = 160
    Top = 152
  end
  object QueryInsAnotGraph: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <
      item
        Name = 'A'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 20
        Value = Null
      end
      item
        Name = 'B'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'C'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 255
        Value = Null
      end
      item
        Name = 'D'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'E'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'F'
        Attributes = [paNullable, paLong]
        DataType = ftVarBytes
        NumericScale = 255
        Precision = 255
        Size = 2147483647
        Value = Null
      end>
    SQL.Strings = (
      'INSERT INTO COMENTARIOSBIN'
      ' (CODUSUARIO, CODREL, PATHREL, FLAGPUBLICO, PAGINA, '
      '  COMENTARIOBIN)'
      'VALUES (:A,  :B,  :C,  :D, :E, :F)')
    Left = 368
    Top = 152
  end
  object QueryIndicesDFN: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <
      item
        Name = 'a'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end>
    SQL.Strings = (
      'SELECT * FROM INDICESDFN WHERE (CODREL = :a)')
    Left = 160
    Top = 56
  end
  object QueryIndicesDFNII: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <
      item
        Name = 'a'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'b'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 20
        Value = Null
      end>
    SQL.Strings = (
      'SELECT * FROM INDICESDFN WHERE (CODREL = :a) '
      
        '                                                         AND (NO' +
        'MECAMPO = :b)')
    Left = 264
    Top = 56
  end
  object QueryDestinosDFN: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <
      item
        Name = 'a'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end>
    SQL.Strings = (
      'SELECT     *'
      'FROM         DESTINOSDFN'
      'WHERE     (CODREL = :a)'
      'AND TIPODESTINO = '#39'Dir'#39)
    Left = 368
    Top = 56
  end
  object QueryAux1: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <>
    Left = 160
    Top = 104
  end
  object QueryAux2: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <>
    Left = 264
    Top = 104
  end
  object QueryInsAnotText: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <
      item
        Name = 'A'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 20
        Value = Null
      end
      item
        Name = 'B'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'C'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 255
        Value = Null
      end
      item
        Name = 'D'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'E'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'F'
        Attributes = [paNullable, paLong]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 2147483647
        Value = Null
      end>
    SQL.Strings = (
      'INSERT INTO COMENTARIOSTXT'
      
        ' (CODUSUARIO, CODREL, PATHREL, FLAGPUBLICO, PAGINA, COMENTARIOTX' +
        'T)'
      'VALUES (:A,  :B,  :C,  :D, :E, :F)')
    Left = 264
    Top = 152
  end
  object DatabaseEventos: TADOConnection
    ConnectionString = 'FILE NAME=MulticoldEventos.udl'
    LoginPrompt = False
    Provider = 'MulticoldEventos.udl'
    Left = 40
    Top = 56
  end
  object EventosQuery1: TADOQuery
    Connection = DatabaseEventos
    Parameters = <>
    Left = 160
    Top = 200
  end
  object UpdateCompilaQuery: TADOQuery
    Connection = DatabaseEventos
    Parameters = <
      item
        Name = 'a'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'b'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'c'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'd'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'e'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'UPDATE COMPILA '
      'SET QTDCOMPIL = :a'
      'WHERE'
      'CODREL = :b AND'
      'CODSIS = :c AND'
      'CODGRUPO = :d AND'
      'CODSUBGRUPO = :e')
    Left = 264
    Top = 200
  end
  object InsereCompilaQuery: TADOQuery
    Connection = DatabaseEventos
    Parameters = <
      item
        Name = 'a'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'b'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'c'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'd'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'e'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      
        'INSERT INTO COMPILA (CODREL, CODSIS, CODGRUPO, CODSUBGRUPO, QTDC' +
        'OMPIL)'
      'VALUES (:a,:b,:c,:d,:e)')
    Left = 368
    Top = 200
  end
  object SelectCompilaQuery: TADOQuery
    Connection = DatabaseEventos
    Parameters = <
      item
        Name = 'a'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'b'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'c'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'd'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT QTDCOMPIL FROM COMPILA WHERE'
      'CODREL = :a AND'
      'CODSIS = :b AND'
      'CODGRUPO = :c AND'
      'CODSUBGRUPO = :d')
    Left = 160
    Top = 248
  end
  object DatabaseLog: TADOConnection
    ConnectionString = 'FILE NAME=MulticoldLog.udl'
    LoginPrompt = False
    Provider = 'MulticoldLog.udl'
    Left = 40
    Top = 104
  end
  object A: TADOQuery
    Connection = DatabaseLog
    Parameters = <
      item
        Name = 'Param1'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 16
        Value = '0'
      end>
    SQL.Strings = (
      'INSERT INTO PROTOCOLO VALUES'
      '('
      '?'
      ')')
    Left = 264
    Top = 248
  end
  object QueryInsertLogProc: TADOQuery
    Connection = DatabaseLog
    CursorLocation = clUseServer
    Parameters = <
      item
        Name = 'A'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'B'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'C'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'D'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'E'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 255
        Value = Null
      end
      item
        Name = 'F'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 512
        Value = Null
      end>
    SQL.Strings = (
      
        'INSERT INTO LOGPROC (DTLOTE, HRLOTE, DTPROC, HRPROC, ARQUIVO, ME' +
        'NSAGEM)'
      'VALUES (:A, :B, :C, :D, :E, :F)')
    Left = 368
    Top = 248
  end
  object TableTemp: TADOTable
    Connection = DatabaseMultiCold
    CursorType = ctStatic
    Left = 264
    Top = 8
  end
  object TableGruposDFN: TADOTable
    Connection = DatabaseMultiCold
    CursorType = ctStatic
    Left = 368
    Top = 8
  end
  object HTTPRIO1: THTTPRIO
    WSDLLocation = 
      'http://192.168.0.103/multicold/MulticoldServer.exe/wsdl/IMultico' +
      'ldServer'
    Service = 'IMulticoldServerservice'
    Port = 'IMulticoldServerPort'
    HTTPWebNode.Agent = 'Borland SOAP 1.2'
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 552
    Top = 8
  end
  object QueryInsertProtocolo: TADOQuery
    Connection = DatabaseLog
    Parameters = <>
    SQL.Strings = (
      'INSERT INTO PROTOCOLO VALUES'
      '('
      '?'
      ')')
    Left = 160
    Top = 296
  end
  object QueryAux3: TADOQuery
    Connection = DatabaseMultiCold
    Parameters = <>
    Left = 368
    Top = 104
  end
end
