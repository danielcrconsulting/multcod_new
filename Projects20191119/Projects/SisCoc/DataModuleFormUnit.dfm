object DataModule: TDataModule
  Left = 0
  Top = 0
  Caption = 'DataModule'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gBanco: TADOConnection
    Left = 32
    Top = 24
  end
  object RsDbDs: TADODataSet
    Connection = gBanco
    Parameters = <>
    Left = 32
    Top = 80
  end
  object RsDbTb: TADOTable
    Connection = gBanco
    Left = 32
    Top = 136
  end
  object RsDbQry: TADOQuery
    Connection = gBanco
    Parameters = <>
    Left = 32
    Top = 192
  end
  object gBancoCli: TADOConnection
    Left = 152
    Top = 24
  end
  object RsDbDsCli: TADODataSet
    Connection = gBancoCli
    Parameters = <>
    Left = 152
    Top = 80
  end
  object RsDbTbCli: TADOTable
    Connection = gBancoCli
    Left = 152
    Top = 128
  end
  object RsDbQryCli: TADOQuery
    Connection = gBancoCli
    Parameters = <>
    Left = 152
    Top = 192
  end
end
