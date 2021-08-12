object TipoCon: TTipoCon
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'SISCOC-Incluir Tipo de Concilia'#231#227'o'
  ClientHeight = 568
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 303
    Top = 16
    Width = 33
    Height = 25
    AutoSize = False
    Caption = 'Grupo'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 380
    Top = 16
    Width = 86
    Height = 21
    AutoSize = False
    Caption = 'Nome do Grupo'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 48
    Top = 40
    Width = 82
    Height = 21
    AutoSize = False
    Caption = 'Conta '
    WordWrap = True
  end
  object Label4: TLabel
    Left = 303
    Top = 73
    Width = 82
    Height = 13
    AutoSize = False
    Caption = 'Conta Emissor'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 493
    Top = 73
    Width = 86
    Height = 17
    AutoSize = False
    Caption = 'Centro de Custo'
    WordWrap = True
  end
  object Label13: TLabel
    Left = 49
    Top = 125
    Width = 114
    Height = 17
    AutoSize = False
    Caption = 'Natureza da Conta'
    WordWrap = True
  end
  object Label12: TLabel
    Left = 303
    Top = 49
    Width = 130
    Height = 21
    AutoSize = False
    Caption = 'Nome da Concilia'#231#227'o'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 49
    Top = 93
    Width = 82
    Height = 21
    AutoSize = False
    Caption = 'Padr'#227'o da Conta'
    WordWrap = True
  end
  object Label7: TLabel
    Left = 49
    Top = 69
    Width = 106
    Height = 17
    AutoSize = False
    Caption = 'Limite para Varia'#231#227'o'
    WordWrap = True
  end
  object Label8: TLabel
    Left = 48
    Top = 16
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Cliente'
    WordWrap = True
  end
  object Line1: TShape
    Left = 8
    Top = 169
    Width = 781
    Height = 3
    Brush.Color = clWindowText
    Pen.Color = clWindowText
  end
  object Label9: TLabel
    Left = 303
    Top = 93
    Width = 102
    Height = 21
    AutoSize = False
    Caption = 'Agendamento (S/N)'
    WordWrap = True
  end
  object Label10: TLabel
    Left = 453
    Top = 93
    Width = 114
    Height = 21
    AutoSize = False
    Caption = 'Atualiza'#231#227'o Geral (S/N)'
    WordWrap = True
  end
  object Label11: TLabel
    Left = 303
    Top = 146
    Width = 94
    Height = 17
    AutoSize = False
    Caption = 'For'#231'ar Moeda'
    WordWrap = True
  end
  object Label14: TLabel
    Left = 303
    Top = 117
    Width = 102
    Height = 21
    AutoSize = False
    Caption = 'Eliminar Duplicado'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 449
    Top = 117
    Width = 130
    Height = 21
    AutoSize = False
    Caption = 'Limpeza Autom'#225'tica (dias)'
    WordWrap = True
  end
  object Label16: TLabel
    Left = 680
    Top = 77
    Width = 58
    Height = 13
    AutoSize = False
    Caption = 'Gerar Excel (S/N)'
    WordWrap = True
  end
  object Text1: TEdit
    Left = 348
    Top = 16
    Width = 21
    Height = 21
    TabOrder = 1
    OnExit = Text1Exit
  end
  object Text2: TEdit
    Left = 477
    Top = 16
    Width = 292
    Height = 21
    TabOrder = 2
  end
  object Command1: TButton
    Left = 639
    Top = 538
    Width = 70
    Height = 29
    Caption = '&Gravar'
    TabOrder = 14
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 720
    Top = 538
    Width = 70
    Height = 29
    Caption = '&Sair'
    TabOrder = 16
    OnClick = Command2Click
  end
  object Text3: TEdit
    Left = 154
    Top = 44
    Width = 94
    Height = 21
    TabOrder = 3
    OnExit = Text3Exit
  end
  object Text4: TEdit
    Left = 409
    Top = 69
    Width = 74
    Height = 21
    TabOrder = 6
  end
  object Text5: TEdit
    Left = 578
    Top = 69
    Width = 37
    Height = 21
    TabOrder = 7
  end
  object Text14: TEdit
    Left = 222
    Top = 125
    Width = 25
    Height = 21
    TabOrder = 8
    OnExit = Text14Exit
  end
  object Text37: TEdit
    Left = 465
    Top = 40
    Width = 304
    Height = 21
    TabOrder = 4
  end
  object Text6: TEdit
    Left = 170
    Top = 97
    Width = 78
    Height = 21
    TabOrder = 9
  end
  object Frame1: TGroupBox
    Left = 8
    Top = 178
    Width = 782
    Height = 167
    Caption = 'Contas de D'#233'bito'
    TabOrder = 13
    object Command3: TButton
      Left = 708
      Top = 138
      Width = 62
      Height = 21
      Caption = '&Nova'
      TabOrder = 0
      OnClick = Command3Click
    end
    object Command4: TButton
      Left = 627
      Top = 138
      Width = 62
      Height = 21
      Caption = 'Exclui'
      TabOrder = 1
      OnClick = Command4Click
    end
    object grdDebito: TDBGrid
      Left = 12
      Top = 12
      Width = 758
      Height = 120
      DataSource = DataSourceDeb
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Frame2: TGroupBox
    Left = 8
    Top = 356
    Width = 782
    Height = 167
    Caption = 'Contas de Cr'#233'dito'
    TabOrder = 15
    object Command7: TButton
      Left = 627
      Top = 138
      Width = 62
      Height = 21
      Caption = 'Exclui'
      TabOrder = 0
      OnClick = Command7Click
    end
    object Command8: TButton
      Left = 708
      Top = 138
      Width = 62
      Height = 21
      Caption = '&Nova'
      TabOrder = 1
      OnClick = Command8Click
    end
    object grdCredito: TDBGrid
      Left = 12
      Top = 16
      Width = 758
      Height = 120
      DataSource = DataSourceCred
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Text7: TEdit
    Left = 154
    Top = 69
    Width = 94
    Height = 21
    TabOrder = 5
  end
  object Check1: TCheckBox
    Left = 409
    Top = 146
    Width = 58
    Height = 17
    Caption = 'Real'
    TabOrder = 11
    OnClick = Check1Click
  end
  object Check2: TCheckBox
    Left = 481
    Top = 146
    Width = 54
    Height = 21
    Caption = 'Dolar'
    TabOrder = 12
    OnClick = Check2Click
  end
  object Text8: TEdit
    Left = 154
    Top = 20
    Width = 94
    Height = 21
    TabOrder = 0
    OnExit = Text8Exit
  end
  object Text9: TEdit
    Left = 409
    Top = 93
    Width = 25
    Height = 21
    TabOrder = 10
  end
  object Text10: TEdit
    Left = 591
    Top = 93
    Width = 25
    Height = 21
    TabOrder = 17
  end
  object Text11: TEdit
    Left = 409
    Top = 117
    Width = 25
    Height = 21
    TabOrder = 18
  end
  object Text12: TEdit
    Left = 591
    Top = 117
    Width = 25
    Height = 21
    TabOrder = 19
  end
  object Text13: TEdit
    Left = 744
    Top = 73
    Width = 25
    Height = 21
    TabOrder = 20
  end
  object gBanco: TADOConnection
    Left = 32
    Top = 528
  end
  object RsDb: TADOQuery
    Connection = gBanco
    LockType = ltBatchOptimistic
    Parameters = <>
    Left = 80
    Top = 528
  end
  object DataSourceDeb: TDataSource
    Left = 200
    Top = 528
  end
  object DataSourceCred: TDataSource
    Left = 392
    Top = 528
  end
end
