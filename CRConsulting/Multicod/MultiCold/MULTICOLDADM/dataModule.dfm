object repositorioDeDados: TrepositorioDeDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 636
  Width = 686
  object dbMulticold: TADOConnection
    ConnectionString = 'FILE NAME=MultiCold.udl'
    LoginPrompt = False
    Provider = 'MultiCold.udl'
    Left = 24
    Top = 16
  end
  object tMascaraCampo: TADOTable
    Connection = dbMulticold
    TableName = 'MASCARACAMPO'
    Left = 112
    Top = 72
    object tMascaraCampoCODREL: TStringField
      DisplayLabel = 'C'#243'digo do relat'#243'rio'
      DisplayWidth = 25
      FieldName = 'CODREL'
      Size = 15
    end
    object tMascaraCampoNOMECAMPO: TStringField
      DisplayLabel = 'Nome do campo'
      DisplayWidth = 25
      FieldName = 'NOMECAMPO'
    end
    object tMascaraCampoLINHAI: TIntegerField
      DisplayLabel = 'Linha Inicial'
      DisplayWidth = 25
      FieldName = 'LINHAI'
    end
    object tMascaraCampoLINHAF: TIntegerField
      DisplayLabel = 'Linha final'
      DisplayWidth = 25
      FieldName = 'LINHAF'
    end
    object tMascaraCampoCOLUNA: TIntegerField
      DisplayLabel = 'Coluna'
      DisplayWidth = 25
      FieldName = 'COLUNA'
    end
    object tMascaraCampoTAMANHO: TIntegerField
      DisplayLabel = 'Tamanho'
      DisplayWidth = 25
      FieldName = 'TAMANHO'
    end
  end
  object tDfn: TADOTable
    Connection = dbMulticold
    TableName = 'DFN'
    Left = 576
    Top = 312
    object tDfnCODREL: TStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODREL'
      Size = 15
    end
    object tDfnNOMEREL: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOMEREL'
      Size = 60
    end
    object tDfnCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object tDfnCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object tDfnCODSUBGRUPO: TIntegerField
      FieldName = 'CODSUBGRUPO'
      Visible = False
    end
    object tDfnIDCOLUNA1: TIntegerField
      FieldName = 'IDCOLUNA1'
      Visible = False
    end
    object tDfnIDLINHA1: TIntegerField
      FieldName = 'IDLINHA1'
      Visible = False
    end
    object tDfnIDSTRING1: TStringField
      FieldName = 'IDSTRING1'
      Visible = False
      Size = 30
    end
    object tDfnIDCOLUNA2: TIntegerField
      FieldName = 'IDCOLUNA2'
      Visible = False
    end
    object tDfnIDLINHA2: TIntegerField
      FieldName = 'IDLINHA2'
      Visible = False
    end
    object tDfnIDSTRING2: TStringField
      FieldName = 'IDSTRING2'
      Visible = False
      Size = 30
    end
    object tDfnDIRENTRA: TStringField
      FieldName = 'DIRENTRA'
      Visible = False
      Size = 50
    end
    object tDfnTIPOQUEBRA: TStringField
      FieldName = 'TIPOQUEBRA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnCOLQUEBRASTR1: TIntegerField
      FieldName = 'COLQUEBRASTR1'
      Visible = False
    end
    object tDfnSTRQUEBRASTR1: TStringField
      FieldName = 'STRQUEBRASTR1'
      Visible = False
      Size = 30
    end
    object tDfnCOLQUEBRASTR2: TIntegerField
      FieldName = 'COLQUEBRASTR2'
      Visible = False
    end
    object tDfnSTRQUEBRASTR2: TStringField
      FieldName = 'STRQUEBRASTR2'
      Visible = False
      Size = 30
    end
    object tDfnQUEBRAAFTERSTR: TStringField
      FieldName = 'QUEBRAAFTERSTR'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnNLINHASQUEBRALIN: TIntegerField
      FieldName = 'NLINHASQUEBRALIN'
      Visible = False
    end
    object tDfnFILTROCAR: TStringField
      FieldName = 'FILTROCAR'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnCOMPRBRANCOS: TStringField
      FieldName = 'COMPRBRANCOS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnJUNCAOAUTOM: TStringField
      FieldName = 'JUNCAOAUTOM'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnQTDPAGSAPULAR: TIntegerField
      FieldName = 'QTDPAGSAPULAR'
      Visible = False
    end
    object tDfnCODGRUPAUTO: TStringField
      FieldName = 'CODGRUPAUTO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnCOLGRUPAUTO: TIntegerField
      FieldName = 'COLGRUPAUTO'
      Visible = False
    end
    object tDfnLINGRUPAUTO: TIntegerField
      FieldName = 'LINGRUPAUTO'
      Visible = False
    end
    object tDfnTAMGRUPAUTO: TIntegerField
      FieldName = 'TAMGRUPAUTO'
      Visible = False
    end
    object tDfnTIPOGRUPAUTO: TStringField
      FieldName = 'TIPOGRUPAUTO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnBACKUPREL: TStringField
      FieldName = 'BACKUPREL'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnSUBDIRAUTO: TStringField
      FieldName = 'SUBDIRAUTO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnSTATUS: TStringField
      FieldName = 'STATUS'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDfnDTCRIACAO: TDateField
      FieldName = 'DTCRIACAO'
      Visible = False
    end
    object tDfnHRCRIACAO: TTimeField
      FieldName = 'HRCRIACAO'
      Visible = False
    end
    object tDfnDTALTERACAO: TDateField
      FieldName = 'DTALTERACAO'
      Visible = False
    end
    object tDfnHRALTERACAO: TTimeField
      FieldName = 'HRALTERACAO'
      Visible = False
    end
    object tDfnREMOVE: TStringField
      FieldName = 'REMOVE'
      Visible = False
      FixedChar = True
      Size = 1
    end
  end
  object tUsuario: TADOTable
    Connection = dbMulticold
    CursorType = ctStatic
    TableName = 'USUARIOS'
    Left = 576
    Top = 440
    object tUsuarioCODUSUARIO: TStringField
      DisplayLabel = 'C'#243'digo de usu'#225'rio'
      DisplayWidth = 25
      FieldName = 'CODUSUARIO'
    end
    object tUsuarioSENHA: TStringField
      FieldName = 'SENHA'
      Visible = False
      Size = 10
    end
    object tUsuarioREMOTO: TStringField
      DisplayLabel = 'Usu'#225'rio remoto'
      DisplayWidth = 25
      FieldName = 'REMOTO'
      FixedChar = True
      Size = 1
    end
    object tUsuarioNOME: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 35
      FieldName = 'NOME'
      Size = 100
    end
  end
  object tUsuarioMascara: TADOTable
    Connection = dbMulticold
    TableName = 'USUARIOMASCARA'
    Left = 224
    Top = 72
    object tUsuarioMascaraCODREL: TStringField
      DisplayLabel = 'C'#243'digo do relat'#243'rio'
      DisplayWidth = 25
      FieldName = 'CODREL'
      Size = 15
    end
    object tUsuarioMascaraNOMECAMPO: TStringField
      DisplayLabel = 'Nome do campo'
      DisplayWidth = 25
      FieldName = 'NOMECAMPO'
    end
    object tUsuarioMascaraCODUSUARIO: TStringField
      DisplayLabel = 'C'#243'digo do usu'#225'rio'
      DisplayWidth = 25
      FieldName = 'CODUSUARIO'
    end
  end
  object Query01: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 16
    Top = 184
  end
  object Query02: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 16
    Top = 240
  end
  object qMascaraCamposINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param3'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param4'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param5'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'INSERT INTO MASCARACAMPO (CODREL,NOMECAMPO,LINHAI,LINHAF,COLUNA,' +
        'TAMANHO) VALUES (?,?,?,?,?,?)')
    Left = 112
    Top = 128
  end
  object qMascaraCamposUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param3'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param4'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param5'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param7'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param8'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'UPDATE MASCARACAMPO SET CODREL=?,NOMECAMPO=?,LINHAI=?,LINHAF=?,C' +
        'OLUNA=?,TAMANHO=? WHERE CODREL=? AND NOMECAMPO=?')
    Left = 112
    Top = 184
  end
  object qMascaraCamposDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM MASCARACAMPO WHERE CODREL=? AND NOMECAMPO=?')
    Left = 112
    Top = 240
  end
  object qUsuarioMascaraINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'INSERT INTO USUARIOMASCARA(CODREL, NOMECAMPO, CODUSUARIO) VALUES' +
        ' (?,?,?)')
    Left = 224
    Top = 128
  end
  object qUsuarioMascaraDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM USUARIOMASCARA WHERE CODREL=? AND NOMECAMPO=?')
    Left = 224
    Top = 240
  end
  object tMapaDeNomes: TADOTable
    Connection = dbMulticold
    TableName = 'MAPADENOMES'
    Left = 336
    Top = 72
    object tMapaDeNomesNOMEORIGINAL: TStringField
      DisplayLabel = 'Nome original'
      DisplayWidth = 25
      FieldName = 'NOMEORIGINAL'
      Size = 25
    end
    object tMapaDeNomesNOVONOME: TStringField
      DisplayLabel = 'Novo nome'
      DisplayWidth = 25
      FieldName = 'NOVONOME'
      Size = 25
    end
    object tMapaDeNomesNOVODIRSAIDA: TStringField
      DisplayLabel = 'Novo diret'#243'rio de sa'#237'da'
      DisplayWidth = 50
      FieldName = 'NOVODIRSAIDA'
      Size = 50
    end
  end
  object qMapaDeNomesINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param3'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 50
        Size = 50
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'INSERT INTO MAPADENOMES (NOMEORIGINAL, NOVONOME, NOVODIRSAIDA)'
      'VALUES (?,?,?)')
    Left = 336
    Top = 128
  end
  object qMapaDeNomesUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param3'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 50
        Size = 50
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'UPDATE MAPADENOMES'
      'SET NOMEORIGINAL=?, NOVONOME=?,NOVODIRSAIDA=?'
      'WHERE NOMEORIGINAL=?')
    Left = 336
    Top = 184
  end
  object qMapaDeNomesDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM MAPADENOMES '
      'WHERE NOMEORIGINAL=?')
    Left = 336
    Top = 240
  end
  object tExtrator: TADOTable
    Connection = dbMulticold
    TableName = 'EXTRATOR'
    Left = 432
    Top = 72
    object tExtratorCODREL: TStringField
      DisplayLabel = 'C'#243'digo do relat'#243'rio'
      DisplayWidth = 25
      FieldName = 'CODREL'
      Size = 15
    end
    object tExtratorCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object tExtratorCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object tExtratorXTR: TStringField
      DisplayWidth = 35
      FieldName = 'XTR'
      Size = 70
    end
    object tExtratorDESTINO: TStringField
      DisplayLabel = 'Destino'
      DisplayWidth = 35
      FieldName = 'DESTINO'
      Size = 70
    end
    object tExtratorDIREXPL: TStringField
      FieldName = 'DIREXPL'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tExtratorOPERACAO: TStringField
      FieldName = 'OPERACAO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tExtratorSUBDIR: TStringField
      FieldName = 'SUBDIR'
      Visible = False
      Size = 15
    end
    object tExtratorARQUIVO: TStringField
      DisplayLabel = 'Arquivo'
      FieldName = 'ARQUIVO'
      Size = 25
    end
  end
  object qExtratorINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftString
        Precision = 70
        Size = 70
        Value = Null
      end
      item
        Name = 'Param5'
        DataType = ftString
        Precision = 70
        Size = 70
        Value = Null
      end
      item
        Name = 'Param6'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param7'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param8'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param9'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'INSERT INTO EXTRATOR (CODREL,CODSIS,CODGRUPO,XTR,DESTINO,DIREXPL' +
        ',OPERACAO,SUBDIR,ARQUIVO)'
      'VALUES(?,?,?,?,?,?,?,?,?)')
    Left = 432
    Top = 128
  end
  object qExtratorUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftString
        Precision = 70
        Size = 70
        Value = Null
      end
      item
        Name = 'Param5'
        DataType = ftString
        Precision = 70
        Size = 70
        Value = Null
      end
      item
        Name = 'Param6'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param7'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param8'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param9'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param10'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'UPDATE EXTRATOR'
      
        'SET CODREL=?,CODSIS=?,CODGRUPO=?,XTR=?,DESTINO=?,DIREXPL=?,OPERA' +
        'CAO=?,SUBDIR=?,ARQUIVO=?'
      'WHERE CODREL=?')
    Left = 432
    Top = 184
  end
  object qExtratorDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM EXTRATOR'
      'WHERE CODREL=?')
    Left = 432
    Top = 240
  end
  object tDestinosDfn: TADOTable
    Connection = dbMulticold
    TableName = 'DESTINOSDFN'
    Left = 520
    Top = 72
    object tDestinosDfnCODREL: TStringField
      DisplayLabel = 'C'#243'digo do relat'#243'rio'
      DisplayWidth = 25
      FieldName = 'CODREL'
      Size = 15
    end
    object tDestinosDfnDESTINO: TStringField
      DisplayLabel = 'Destino'
      DisplayWidth = 50
      FieldName = 'DESTINO'
      Size = 70
    end
    object tDestinosDfnTIPODESTINO: TStringField
      FieldName = 'TIPODESTINO'
      Visible = False
      Size = 5
    end
    object tDestinosDfnSEGURANCA: TStringField
      FieldName = 'SEGURANCA'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDestinosDfnQTDPERIODOS: TIntegerField
      FieldName = 'QTDPERIODOS'
      Visible = False
    end
    object tDestinosDfnTIPOPERIODO: TStringField
      FieldName = 'TIPOPERIODO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tDestinosDfnUSUARIO: TStringField
      FieldName = 'USUARIO'
      Visible = False
      Size = 25
    end
    object tDestinosDfnSENHA: TStringField
      FieldName = 'SENHA'
      Visible = False
      Size = 25
    end
    object tDestinosDfnDIREXPL: TStringField
      FieldName = 'DIREXPL'
      Visible = False
      FixedChar = True
      Size = 1
    end
  end
  object qDestinosDfnINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 70
        Size = 70
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        Precision = 5
        Size = 5
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param5'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param7'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param8'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param9'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'INSERT INTO DESTINOSDFN (CODREL,DESTINO,TIPODESTINO,SEGURANCA,QT' +
        'DPERIODOS,TIPOPERIODO,USUARIO,SENHA,DIREXPL)'
      'VALUES (?,?,?,?,?,?,?,?,?)')
    Left = 520
    Top = 128
  end
  object qDestinosDfnUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 70
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 5
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'Param5'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'Param7'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 25
        Value = Null
      end
      item
        Name = 'Param8'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 25
        Value = Null
      end
      item
        Name = 'Param9'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 1
        Value = Null
      end
      item
        Name = 'Param10'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'Param11'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 70
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'UPDATE DESTINOSDFN'
      
        'SET CODREL=?,DESTINO=?,TIPODESTINO=?,SEGURANCA=?,QTDPERIODOS=?,T' +
        'IPOPERIODO=?,USUARIO=?,SENHA=?,DIREXPL=?'
      'WHERE CODREL=? AND DESTINO = ?')
    Left = 520
    Top = 184
  end
  object qDestinosDfnDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'A01'
        Size = -1
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM DESTINOSDFN'
      'WHERE CODREL=:A01')
    Left = 520
    Top = 240
  end
  object tIndicesDfn: TADOTable
    Connection = dbMulticold
    TableName = 'INDICESDFN'
    Left = 608
    Top = 72
    object tIndicesDfnCODREL: TStringField
      DisplayLabel = 'C'#243'digo do relat'#243'rio'
      FieldName = 'CODREL'
      Size = 15
    end
    object tIndicesDfnNOMECAMPO: TStringField
      DisplayLabel = 'Nome do campo'
      FieldName = 'NOMECAMPO'
    end
    object tIndicesDfnLINHAI: TIntegerField
      DisplayLabel = 'Linha inicial'
      FieldName = 'LINHAI'
    end
    object tIndicesDfnLINHAF: TIntegerField
      DisplayLabel = 'Linha final'
      FieldName = 'LINHAF'
    end
    object tIndicesDfnCOLUNA: TIntegerField
      DisplayLabel = 'Coluna'
      FieldName = 'COLUNA'
    end
    object tIndicesDfnTAMANHO: TIntegerField
      DisplayLabel = 'Tamanho'
      FieldName = 'TAMANHO'
    end
    object tIndicesDfnBRANCO: TStringField
      FieldName = 'BRANCO'
      Visible = False
      FixedChar = True
      Size = 1
    end
    object tIndicesDfnTIPO: TStringField
      FieldName = 'TIPO'
      Visible = False
      Size = 2
    end
    object tIndicesDfnMASCARA: TStringField
      FieldName = 'MASCARA'
      Visible = False
      Size = 12
    end
    object tIndicesDfnCHARINC: TStringField
      FieldName = 'CHARINC'
      Visible = False
    end
    object tIndicesDfnCHAREXC: TStringField
      FieldName = 'CHAREXC'
      Visible = False
    end
    object tIndicesDfnSTRINC: TStringField
      FieldName = 'STRINC'
      Visible = False
      Size = 25
    end
    object tIndicesDfnSTREXC: TStringField
      FieldName = 'STREXC'
      Visible = False
      Size = 25
    end
    object tIndicesDfnFUSAO: TIntegerField
      FieldName = 'FUSAO'
      Visible = False
    end
  end
  object qIndicesDfnINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param5'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param7'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param8'
        DataType = ftString
        Precision = 2
        Size = 2
        Value = Null
      end
      item
        Name = 'Param9'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 12
        Size = 12
        Value = Null
      end
      item
        Name = 'Param10'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param11'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param12'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param13'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param14'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'INSERT INTO INDICESDFN (CODREL,NOMECAMPO,LINHAI,LINHAF,COLUNA,TA' +
        'MANHO,BRANCO,TIPO,MASCARA,CHARINC,CHAREXC,STRINC,STREXC,FUSAO)'
      'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)')
    Left = 608
    Top = 128
  end
  object qIndicesDfnUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param5'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param7'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param8'
        DataType = ftString
        Precision = 2
        Size = 2
        Value = Null
      end
      item
        Name = 'Param9'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 12
        Size = 12
        Value = Null
      end
      item
        Name = 'Param10'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param11'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end
      item
        Name = 'Param12'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param13'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 25
        Size = 25
        Value = Null
      end
      item
        Name = 'Param14'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param15'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param16'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'UPDATE INDICESDFN'
      
        'SET CODREL=?,NOMECAMPO=?,LINHAI=?,LINHAF=?,COLUNA=?,TAMANHO=?,BR' +
        'ANCO=?,TIPO=?,MASCARA=?,CHARINC=?,CHAREXC=?,STRINC=?,STREXC=?,FU' +
        'SAO=?'
      'WHERE CODREL=? AND NOMECAMPO=?')
    Left = 608
    Top = 184
  end
  object qIndicesDfnDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftString
        Precision = 20
        Size = 20
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM INDICESDFN'
      'WHERE CODREL=? AND NOMECAMPO=?')
    Left = 608
    Top = 240
  end
  object tRelatoCD: TADOTable
    Connection = dbMulticold
    TableName = 'RELATOCD'
    Left = 112
    Top = 304
    object tRelatoCDCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object tRelatoCDCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object tRelatoCDCODREL: TStringField
      DisplayLabel = 'C'#243'digo do relat'#243'rio'
      DisplayWidth = 20
      FieldName = 'CODREL'
      Size = 15
    end
    object tRelatoCDSEGURANCA: TStringField
      DisplayLabel = 'Seguranca'
      DisplayWidth = 20
      FieldName = 'SEGURANCA'
      FixedChar = True
      Size = 1
    end
    object tRelatoCDDIREXPL: TStringField
      DisplayLabel = 'Diret'#243'rio expl'#237'cito'
      DisplayWidth = 20
      FieldName = 'DIREXPL'
      FixedChar = True
      Size = 1
    end
  end
  object qRelatoCDINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param5'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'INSERT INTO RELATOCD (CODSIS,CODGRUPO,CODREL,SEGURANCA,DIREXPL)'
      'VALUES (?,?,?,?,?)')
    Left = 112
    Top = 360
  end
  object qRelatoCDUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param5'
        Attributes = [paNullable]
        DataType = ftString
        Precision = 1
        Size = 1
        Value = Null
      end
      item
        Name = 'Param6'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'UPDATE RELATOCD'
      'SET CODSIS=?,CODGRUPO=?,CODREL=?,SEGURANCA=?,DIREXPL=?'
      'WHERE CODREL=?')
    Left = 112
    Top = 416
  end
  object qRelatoCDDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftString
        Precision = 15
        Size = 15
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM RELATOCD'
      'WHERE CODREL=?')
    Left = 112
    Top = 472
  end
  object qGruposAuxNumDfnINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'INSERT INTO GRUPOSAUXNUMDFN(CODSIS,CODGRUPO,CODAUXGRUPO)'
      'VALUES (?,?,?)')
    Left = 216
    Top = 360
  end
  object qGruposAuxNumDfnUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param5'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'UPDATE GRUPOSAUXNUMDFN'
      'SET CODSIS=?,CODGRUPO=?,CODAUXGRUPO=?'
      'WHERE CODSIS=? AND CODGRUPO=? AND CODAUXGRUPO=?'
      '')
    Left = 216
    Top = 416
  end
  object qGruposAuxNumDfnDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM GRUPOSAUXNUMDFN'
      'WHERE CODSIS=? AND CODGRUPO=? AND CODAUXGRUPO=?')
    Left = 216
    Top = 472
  end
  object qGruposAuxNumDfnSEL: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.CODSIS, A.NOMESIS, B.CODGRUPO, B.NOMEGRUPO, C.CODAUXGRU' +
        'PO'
      'FROM SISTEMA A, GRUPOSDFN B, GRUPOSAUXNUMDFN C'
      
        'WHERE A.CODSIS = C.CODSIS AND B.CODSIS = C.CODSIS AND B.CODGRUPO' +
        ' = C.CODGRUPO'
      'ORDER BY C.CODAUXGRUPO')
    Left = 216
    Top = 304
    object qGruposAuxNumDfnSELCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object qGruposAuxNumDfnSELNOMESIS: TStringField
      DisplayLabel = 'Sistema'
      DisplayWidth = 25
      FieldName = 'NOMESIS'
      Size = 100
    end
    object qGruposAuxNumDfnSELCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object qGruposAuxNumDfnSELNOMEGRUPO: TStringField
      DisplayLabel = 'Grupo'
      DisplayWidth = 25
      FieldName = 'NOMEGRUPO'
      Size = 30
    end
    object qGruposAuxNumDfnSELCODAUXGRUPO: TIntegerField
      DisplayLabel = 'Auxiliar num'#233'rico'
      DisplayWidth = 25
      FieldName = 'CODAUXGRUPO'
    end
  end
  object qGruposAuxAlfaDfnINS: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        Precision = 132
        Size = 132
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'INSERT INTO GRUPOSAUXALFADFN(CODSIS,CODGRUPO,CODAUXGRUPO)'
      'VALUES (?,?,?)')
    Left = 344
    Top = 360
  end
  object qGruposAuxAlfaDfnUPD: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        Precision = 132
        Size = 132
        Value = Null
      end
      item
        Name = 'Param4'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param5'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param6'
        DataType = ftString
        Precision = 132
        Size = 132
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'UPDATE GRUPOSAUXALFADFN'
      'SET CODSIS=?,CODGRUPO=?,CODAUXGRUPO=?'
      'WHERE CODSIS=? AND CODGRUPO=? AND CODAUXGRUPO=?'
      '')
    Left = 344
    Top = 416
  end
  object qGruposAuxAlfaDfnDEL: TADOQuery
    Connection = dbMulticold
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param3'
        DataType = ftString
        Precision = 132
        Size = 132
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      'DELETE FROM GRUPOSAUXALFADFN'
      'WHERE CODSIS=? AND CODGRUPO=? AND CODAUXGRUPO=?')
    Left = 344
    Top = 472
  end
  object qGruposAuxAlfaDfnSEL: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.CODSIS, A.NOMESIS, B.CODGRUPO, B.NOMEGRUPO, C.CODAUXGRU' +
        'PO'
      'FROM SISTEMA A, GRUPOSDFN B, GRUPOSAUXALFADFN C'
      
        'WHERE A.CODSIS = C.CODSIS AND B.CODSIS = C.CODSIS AND B.CODGRUPO' +
        ' = C.CODGRUPO'
      'ORDER BY C.CODAUXGRUPO')
    Left = 344
    Top = 304
    object qGruposAuxAlfaDfnSELCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object qGruposAuxAlfaDfnSELNOMESIS: TStringField
      DisplayLabel = 'Sistema'
      DisplayWidth = 30
      FieldName = 'NOMESIS'
      Size = 100
    end
    object qGruposAuxAlfaDfnSELCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object qGruposAuxAlfaDfnSELNOMEGRUPO: TStringField
      DisplayLabel = 'Grupo'
      FieldName = 'NOMEGRUPO'
      Size = 30
    end
    object qGruposAuxAlfaDfnSELCODAUXGRUPO: TStringField
      DisplayLabel = 'Auxiliar alfanum'#233'rico'
      DisplayWidth = 30
      FieldName = 'CODAUXGRUPO'
      Size = 132
    end
  end
  object qSubGruposDfnSEL: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.CODSIS, A.NOMESIS, B.CODGRUPO, B.NOMEGRUPO, C.CODSUBGRU' +
        'PO, C.NOMESUBGRUPO'
      'FROM SISTEMA A, GRUPOSDFN B, SUBGRUPOSDFN C'
      
        'WHERE A.CODSIS = C.CODSIS AND B.CODSIS = C.CODSIS AND B.CODGRUPO' +
        ' = C.CODGRUPO'
      'ORDER BY C.NOMESUBGRUPO')
    Left = 480
    Top = 440
    object qSubGruposDfnSELCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object qSubGruposDfnSELNOMESIS: TStringField
      DisplayLabel = 'Sistema'
      DisplayWidth = 30
      FieldName = 'NOMESIS'
      Size = 100
    end
    object qSubGruposDfnSELCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object qSubGruposDfnSELNOMEGRUPO: TStringField
      DisplayLabel = 'Grupo'
      FieldName = 'NOMEGRUPO'
      Size = 30
    end
    object qSubGruposDfnSELCODSUBGRUPO: TIntegerField
      FieldName = 'CODSUBGRUPO'
      Visible = False
    end
    object qSubGruposDfnSELNOMESUBGRUPO: TStringField
      DisplayLabel = 'Subgrupo'
      FieldName = 'NOMESUBGRUPO'
      Size = 30
    end
  end
  object qGruposDfnSEL: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    SQL.Strings = (
      
        'SELECT A.CODSIS, A.NOMESIS, B.CODGRUPO, B.CODGRUPOALFA, B.NOMEGR' +
        'UPO'
      'FROM SISTEMA A, GRUPOSDFN B'
      'WHERE A.CODSIS = B.CODSIS'
      'ORDER BY NOMESIS, NOMEGRUPO')
    Left = 480
    Top = 496
    object qGruposDfnSELCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object qGruposDfnSELNOMESIS: TStringField
      DisplayLabel = 'Sistema'
      DisplayWidth = 35
      FieldName = 'NOMESIS'
      Size = 100
    end
    object qGruposDfnSELCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object qGruposDfnSELCODGRUPOALFA: TStringField
      FieldName = 'CODGRUPOALFA'
      Visible = False
      Size = 15
    end
    object qGruposDfnSELNOMEGRUPO: TStringField
      DisplayLabel = 'Grupo'
      DisplayWidth = 35
      FieldName = 'NOMEGRUPO'
      Size = 30
    end
  end
  object tGrupoUsuarios: TADOTable
    Connection = dbMulticold
    TableName = 'GRUPOUSUARIOS'
    Left = 224
    Top = 184
    object tGrupoUsuariosNOMEGRUPOUSUARIO: TStringField
      DisplayLabel = 'Grupo de usu'#225'rios'
      FieldName = 'NOMEGRUPOUSUARIO'
      Size = 30
    end
    object tGrupoUsuariosDESCRGRUPO: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRGRUPO'
      Size = 50
    end
    object tGrupoUsuariosOBSERVACAO: TStringField
      DisplayLabel = 'Observa'#231#227'o'
      FieldName = 'OBSERVACAO'
      Size = 50
    end
  end
  object tUsuariosEGrupos: TADOTable
    Connection = dbMulticold
    TableName = 'USUARIOSEGRUPOS'
    Left = 480
    Top = 384
    object tUsuariosEGruposCODUSUARIO: TStringField
      DisplayLabel = 'C'#243'digo do usu'#225'rio'
      FieldName = 'CODUSUARIO'
    end
    object tUsuariosEGruposNOMEGRUPOUSUARIO: TStringField
      DisplayLabel = 'Grupo de usu'#225'rios'
      FieldName = 'NOMEGRUPOUSUARIO'
      Size = 30
    end
  end
  object qUsuRel: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    SQL.Strings = (
      'SELECT '
      '      A.CODSIS, A.NOMESIS, B.CODGRUPO, B.NOMEGRUPO,'
      '      C.CODSUBGRUPO, C.NOMESUBGRUPO, D.CODREL,'
      '      D.NOMEREL, E.CODUSUARIO'
      'FROM '
      '      SISTEMA A, '
      '      GRUPOSDFN B, '
      '      SUBGRUPOSDFN C, '
      '      DFN D, '
      '      USUREL E'
      'WHERE '
      '      E.CODSIS = A.CODSIS AND'
      '      E.CODSIS = B.CODSIS AND E.CODGRUPO = B.CODGRUPO AND'
      
        '      E.CODSIS = C.CODSIS AND E.CODGRUPO = C.CODGRUPO AND E.CODS' +
        'UBGRUPO = C.CODSUBGRUPO AND'
      '      E.CODREL = D.CODREL'
      'ORDER BY '
      '      E.CODUSUARIO, '
      '      D.NOMEREL'
      '')
    Left = 576
    Top = 384
    object qUsuRelCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object qUsuRelNOMESIS: TStringField
      FieldName = 'NOMESIS'
      Visible = False
      Size = 100
    end
    object qUsuRelCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object qUsuRelNOMEGRUPO: TStringField
      FieldName = 'NOMEGRUPO'
      Visible = False
      Size = 30
    end
    object qUsuRelCODSUBGRUPO: TIntegerField
      FieldName = 'CODSUBGRUPO'
      Visible = False
    end
    object qUsuRelNOMESUBGRUPO: TStringField
      FieldName = 'NOMESUBGRUPO'
      Visible = False
      Size = 30
    end
    object qUsuRelCODREL: TStringField
      FieldName = 'CODREL'
      Visible = False
      Size = 15
    end
    object qUsuRelNOMEREL: TStringField
      DisplayLabel = 'Relat'#243'rio'
      FieldName = 'NOMEREL'
      Size = 60
    end
    object qUsuRelCODUSUARIO: TStringField
      DisplayLabel = 'Usu'#225'rio'
      FieldName = 'CODUSUARIO'
    end
  end
  object qGrupoRel: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    SQL.Strings = (
      'SELECT '
      '      A.CODSIS, A.NOMESIS, B.CODGRUPO, B.NOMEGRUPO,'
      '      C.CODSUBGRUPO, C.NOMESUBGRUPO, D.CODREL,'
      '      D.NOMEREL, E.NOMEGRUPOUSUARIO'
      'FROM '
      '      SISTEMA A, '
      '      GRUPOSDFN B, '
      '      SUBGRUPOSDFN C, '
      '      DFN D, '
      '      GRUPOREL E'
      'WHERE '
      '      E.CODSIS = A.CODSIS AND'
      '      E.CODSIS = B.CODSIS AND E.CODGRUPO = B.CODGRUPO AND'
      
        '      E.CODSIS = C.CODSIS AND E.CODGRUPO = C.CODGRUPO AND E.CODS' +
        'UBGRUPO = C.CODSUBGRUPO AND'
      '      E.CODREL = D.CODREL'
      'ORDER BY '
      '      E.NOMEGRUPOUSUARIO, '
      '      D.NOMEREL')
    Left = 520
    Top = 312
    object qGrupoRelCODSIS: TIntegerField
      FieldName = 'CODSIS'
      Visible = False
    end
    object qGrupoRelNOMESIS: TStringField
      FieldName = 'NOMESIS'
      Visible = False
      Size = 100
    end
    object qGrupoRelCODGRUPO: TIntegerField
      FieldName = 'CODGRUPO'
      Visible = False
    end
    object qGrupoRelNOMEGRUPO: TStringField
      FieldName = 'NOMEGRUPO'
      Visible = False
      Size = 30
    end
    object qGrupoRelCODSUBGRUPO: TIntegerField
      FieldName = 'CODSUBGRUPO'
      Visible = False
    end
    object qGrupoRelNOMESUBGRUPO: TStringField
      FieldName = 'NOMESUBGRUPO'
      Visible = False
      Size = 30
    end
    object qGrupoRelCODREL: TStringField
      FieldName = 'CODREL'
      Visible = False
      Size = 15
    end
    object qGrupoRelNOMEREL: TStringField
      DisplayLabel = 'Relat'#243'rio'
      FieldName = 'NOMEREL'
      Size = 60
    end
    object qGrupoRelNOMEGRUPOUSUARIO: TStringField
      DisplayLabel = 'Grupo de usu'#225'rios'
      FieldName = 'NOMEGRUPOUSUARIO'
    end
  end
  object tSistema: TADOTable
    Connection = dbMulticold
    TableName = 'SISTEMA'
    Left = 464
    Top = 312
    object tSistemaCODSIS: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODSIS'
    end
    object tSistemaNOMESIS: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      DisplayWidth = 30
      FieldName = 'NOMESIS'
      Size = 100
    end
  end
  object dbMulticoldEvento: TADOConnection
    ConnectionString = 'FILE NAME=MultiColdEventos.udl'
    LoginPrompt = False
    Provider = 'MultiColdEventos.udl'
    Left = 112
    Top = 16
  end
  object QueryEvento: TADOQuery
    Connection = dbMulticoldEvento
    Parameters = <>
    Left = 128
    Top = 544
  end
  object QueryEvento2: TADOQuery
    Connection = dbMulticoldEvento
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end>
    SQL.Strings = (
      'DELETE FROM EVENTOS_VISU'
      'WHERE DT < ?')
    Left = 216
    Top = 544
  end
  object QueryEvento3: TADOQuery
    Connection = dbMulticoldEvento
    Parameters = <
      item
        Name = 'Param1'
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'Param2'
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'Param3'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 70
        Value = Null
      end
      item
        Name = 'Param4'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 70
        Value = Null
      end
      item
        Name = 'Param5'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 15
        Value = Null
      end
      item
        Name = 'Param6'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param7'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'Param8'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 20
        Value = Null
      end
      item
        Name = 'Param9'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 30
        Value = Null
      end
      item
        Name = 'Param10'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'INSERT INTO EVENTOS_VISU ('
      
        '                                                       DT,HR,ARQ' +
        'UIVO,DIRETORIO,'
      
        '                                                       CODREL,GR' +
        'UPO,SUBGRUPO,'
      
        '                                                       CODUSUARI' +
        'O,NOMEGRUPOUSUARIO,'
      
        '                                                       CODMENSAG' +
        'EM)'
      'VALUES (?,?,?,?,?,?,?,?,?,?)'
      '                                    ')
    Left = 304
    Top = 544
  end
  object Query03: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 16
    Top = 288
  end
  object Query04: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 16
    Top = 344
  end
  object QueryGrade: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 24
    Top = 80
  end
  object dbMulticoldLog: TADOConnection
    ConnectionString = 'FILE NAME=MultiColdLog.udl'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 208
    Top = 16
  end
  object logQuery: TADOQuery
    Connection = dbMulticoldLog
    Parameters = <>
    Left = 288
    Top = 16
  end
  object Query05: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 16
    Top = 392
  end
  object qGrupoRelNovo: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 368
    Top = 16
  end
  object qAux1: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 520
    Top = 16
  end
  object qRelaRelNovo: TADOQuery
    Connection = dbMulticold
    Parameters = <>
    Left = 448
    Top = 16
  end
end
