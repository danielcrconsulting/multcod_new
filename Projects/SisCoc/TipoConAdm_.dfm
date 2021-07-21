object TipoConAdm: TTipoConAdm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'SISCOC-Incluir Tipo de Concilia'#231#227'o'
  ClientHeight = 644
  ClientWidth = 869
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 311
    Top = 13
    Width = 33
    Height = 25
    AutoSize = False
    Caption = 'Grupo'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 473
    Top = 13
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
    Left = 473
    Top = 67
    Width = 82
    Height = 13
    AutoSize = False
    Caption = 'Conta Emissor'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 311
    Top = 67
    Width = 86
    Height = 17
    AutoSize = False
    Caption = 'Centro de Custo'
    WordWrap = True
  end
  object Label13: TLabel
    Left = 49
    Top = 121
    Width = 114
    Height = 17
    AutoSize = False
    Caption = 'Natureza da Conta'
    WordWrap = True
  end
  object Label12: TLabel
    Left = 311
    Top = 40
    Width = 130
    Height = 21
    AutoSize = False
    Caption = 'Nome da Concilia'#231#227'o'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 49
    Top = 94
    Width = 82
    Height = 21
    AutoSize = False
    Caption = 'Padr'#227'o da Conta'
    WordWrap = True
  end
  object Label7: TLabel
    Left = 49
    Top = 67
    Width = 106
    Height = 17
    AutoSize = False
    Caption = 'Limite para Varia'#231#227'o'
    WordWrap = True
  end
  object Label8: TLabel
    Left = 48
    Top = 13
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Cliente'
    WordWrap = True
  end
  object Line1: TShape
    Left = 8
    Top = 216
    Width = 845
    Height = 3
    Brush.Color = clWindowText
    Pen.Color = clWindowText
  end
  object Label9: TLabel
    Left = 311
    Top = 94
    Width = 102
    Height = 21
    AutoSize = False
    Caption = 'Agendamento (S/N)'
    WordWrap = True
  end
  object Label10: TLabel
    Left = 473
    Top = 94
    Width = 114
    Height = 21
    AutoSize = False
    Caption = 'Atualiza'#231#227'o Geral (S/N)'
    WordWrap = True
  end
  object Label14: TLabel
    Left = 311
    Top = 117
    Width = 102
    Height = 21
    AutoSize = False
    Caption = 'Eliminar Duplicado'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 473
    Top = 117
    Width = 130
    Height = 21
    AutoSize = False
    Caption = 'Limpeza Autom'#225'tica (dias)'
    WordWrap = True
  end
  object Label16: TLabel
    Left = 700
    Top = 67
    Width = 90
    Height = 13
    AutoSize = False
    Caption = 'Gerar Excel (S/N)'
    WordWrap = True
  end
  object Label17: TLabel
    Left = 700
    Top = 117
    Width = 58
    Height = 13
    AutoSize = False
    Caption = 'Hist'#243'rico'
    Visible = False
    WordWrap = True
  end
  object Text2: TEdit
    Left = 562
    Top = 13
    Width = 260
    Height = 21
    ReadOnly = True
    TabOrder = 20
  end
  object Command1: TButton
    Left = 700
    Top = 598
    Width = 70
    Height = 29
    Caption = '&Gravar'
    TabOrder = 18
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 781
    Top = 598
    Width = 70
    Height = 29
    Caption = '&Sair'
    TabOrder = 19
    OnClick = Command2Click
  end
  object Text3: TEdit
    Left = 154
    Top = 40
    Width = 94
    Height = 21
    TabOrder = 2
    OnExit = Text3Exit
  end
  object Text4: TEdit
    Left = 546
    Top = 67
    Width = 134
    Height = 21
    TabOrder = 6
  end
  object Text5: TEdit
    Left = 403
    Top = 67
    Width = 39
    Height = 21
    TabOrder = 5
  end
  object Text14: TEdit
    Left = 222
    Top = 121
    Width = 25
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 11
    OnExit = Text14Exit
    OnKeyPress = Text14KeyPress
  end
  object Text37: TEdit
    Left = 432
    Top = 40
    Width = 390
    Height = 21
    TabOrder = 3
  end
  object Text6: TEdit
    Left = 170
    Top = 94
    Width = 78
    Height = 21
    TabOrder = 8
  end
  object Frame1: TGroupBox
    Left = 8
    Top = 238
    Width = 846
    Height = 167
    Caption = 'Contas de D'#233'bito'
    TabOrder = 16
    object Command3: TButton
      Left = 773
      Top = 138
      Width = 62
      Height = 22
      Caption = '&Nova'
      TabOrder = 0
      OnClick = Command3Click
    end
    object Command4: TButton
      Left = 692
      Top = 138
      Width = 62
      Height = 22
      Caption = 'Exclui'
      TabOrder = 1
    end
    object grdDebito: TDBGrid
      Left = 12
      Top = 11
      Width = 831
      Height = 121
      DataSource = DataSource1
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object DBNavigator1: TDBNavigator
      Left = 12
      Top = 138
      Width = 240
      Height = 25
      DataSource = DataSource1
      TabOrder = 3
    end
  end
  object Frame2: TGroupBox
    Left = 8
    Top = 416
    Width = 846
    Height = 167
    Caption = 'Contas de Cr'#233'dito'
    TabOrder = 17
    object Command7: TButton
      Left = 692
      Top = 138
      Width = 62
      Height = 21
      Caption = 'Exclui'
      TabOrder = 0
      OnClick = Command7Click
    end
    object Command8: TButton
      Left = 773
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
      Width = 831
      Height = 120
      DataSource = DataSource2
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object DBNavigator2: TDBNavigator
      Left = 12
      Top = 139
      Width = 240
      Height = 25
      DataSource = DataSource2
      TabOrder = 3
    end
  end
  object Text7: TEdit
    Left = 154
    Top = 67
    Width = 94
    Height = 21
    TabOrder = 4
  end
  object Text8: TEdit
    Left = 154
    Top = 13
    Width = 94
    Height = 21
    ReadOnly = True
    TabOrder = 0
    OnExit = Text8Exit
  end
  object Text9: TEdit
    Left = 419
    Top = 94
    Width = 25
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 9
    OnExit = Text9Exit
    OnKeyPress = Text9KeyPress
  end
  object Text10: TEdit
    Left = 655
    Top = 94
    Width = 25
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 10
    OnExit = Text10Exit
    OnKeyPress = Text10KeyPress
  end
  object Text11: TEdit
    Left = 419
    Top = 117
    Width = 25
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 12
    OnExit = Text11Exit
    OnKeyPress = Text11KeyPress
  end
  object Text12: TEdit
    Left = 655
    Top = 117
    Width = 25
    Height = 21
    MaxLength = 1
    NumbersOnly = True
    TabOrder = 13
  end
  object Text13: TEdit
    Left = 797
    Top = 67
    Width = 25
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 7
    OnExit = Text13Exit
    OnKeyPress = Text13KeyPress
  end
  object txtHistorico: TEdit
    Left = 781
    Top = 117
    Width = 41
    Height = 21
    TabOrder = 14
    Visible = False
  end
  object Forçar: TGroupBox
    Left = 311
    Top = 144
    Width = 162
    Height = 57
    Caption = 'For'#231'ar Moeda'
    TabOrder = 15
    object RadioButtonReal: TRadioButton
      Left = 16
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Real'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButtonDolar: TRadioButton
      Left = 88
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Dolar'
      TabOrder = 1
    end
  end
  object ComboBox1: TComboBox
    Left = 350
    Top = 13
    Width = 91
    Height = 21
    TabOrder = 1
    OnExit = ComboBox1Exit
    OnKeyPress = ComboBox1KeyPress
  end
  object bancoAdm: TADOConnection
    Left = 16
    Top = 588
  end
  object bancoCli: TADOConnection
    Left = 80
    Top = 588
  end
  object RsDb: TADOQuery
    Connection = bancoAdm
    Filtered = True
    Parameters = <>
    Left = 144
    Top = 588
  end
  object AdoTable: TADOTable
    Connection = bancoAdm
    Left = 208
    Top = 588
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 312
    Top = 592
  end
  object DataSource2: TDataSource
    DataSet = ADODataSet2
    Left = 376
    Top = 592
  end
  object ADODataSet1: TADODataSet
    Connection = bancoAdm
    Parameters = <>
    Left = 512
    Top = 592
  end
  object ADODataSet2: TADODataSet
    Connection = bancoAdm
    Parameters = <>
    Left = 584
    Top = 592
  end
end
