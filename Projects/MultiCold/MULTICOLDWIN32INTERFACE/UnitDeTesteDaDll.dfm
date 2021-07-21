object Form1: TForm1
  Left = 215
  Top = 110
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 72
    Top = 344
    Width = 75
    Height = 25
    Caption = 'PagRel'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 344
    Width = 75
    Height = 25
    Caption = 'ListaCampos'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 272
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Pesquisa'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Database1: TDatabase
    AliasName = 'MSSQLMultiCold'
    DatabaseName = 'MultiCold'
    LoginPrompt = False
    Params.Strings = (
      'DATABASE NAME=MultiCold'
      'SERVER NAME=CRCSVR0001'
      'USER NAME=SA'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'BLOB EDIT LOGGING='
      'LANGDRIVER='
      'SQLQRYMODE='
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'DATE MODE=0'
      'SCHEMA CACHE TIME=-1'
      'MAX QUERY TIME=300'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'HOST NAME='
      'APPLICATION NAME='
      'NATIONAL LANG NAME='
      'ENABLE BCD=FALSE'
      'TDS PACKET SIZE=4096'
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=ayrtonsenna')
    SessionName = 'Session1_9'
    Left = 40
    Top = 16
  end
  object Query1: TQuery
    DatabaseName = 'MultiCold'
    SessionName = 'Session1_9'
    Left = 104
    Top = 16
  end
  object Session1: TSession
    Active = True
    AutoSessionName = True
    Left = 152
    Top = 16
  end
end
