object AlterarManual: TAlterarManual
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'SISCOC-Alterar Registro'
  ClientHeight = 491
  ClientWidth = 808
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cmdSair: TButton
    Left = 704
    Top = 417
    Width = 82
    Height = 33
    Caption = '&Sair'
    TabOrder = 0
    OnClick = cmdSairClick
  end
  object cmdAlterar: TButton
    Left = 388
    Top = 417
    Width = 82
    Height = 33
    Caption = '&Alterar'
    TabOrder = 1
    OnClick = cmdAlterarClick
  end
  object Data1: TDBNavigator
    Left = 704
    Top = 383
    Width = 80
    Height = 18
    DataSource = Data1_DataSource
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 2
    Visible = False
  end
  object Frame1: TGroupBox
    Left = 154
    Top = 400
    Width = 215
    Height = 50
    Caption = 'Selecione o Cart'#227'o'
    TabOrder = 3
    object txtCartao: TEdit
      Left = 16
      Top = 20
      Width = 183
      Height = 21
      TabOrder = 0
      OnEnter = txtCartaoEnter
      OnExit = txtCartaoExit
      OnKeyPress = txtCartaoKeyPress
    end
  end
  object Frame2: TGroupBox
    Left = 16
    Top = 400
    Width = 126
    Height = 46
    Caption = 'Selecione o Valor'
    TabOrder = 4
    object Text1: TEdit
      Left = 16
      Top = 16
      Width = 94
      Height = 21
      TabOrder = 0
      OnEnter = Text1Enter
      OnKeyPress = Text1KeyPress
    end
  end
  object cmdExcluir: TButton
    Left = 493
    Top = 417
    Width = 82
    Height = 33
    Caption = '&Excluir'
    TabOrder = 5
    OnClick = cmdExcluirClick
  end
  object cmdIncluir: TButton
    Left = 595
    Top = 417
    Width = 82
    Height = 33
    Caption = '&Incluir'
    TabOrder = 6
    OnClick = cmdIncluirClick
  end
  object OrdemDtDeb: TButton
    Left = 44
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Data D'#233'bito'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = OrdemDtDebClick
  end
  object OrdemDtCred: TButton
    Left = 109
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Data Cr'#233'dito'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = OrdemDtCredClick
  end
  object OrdemCartao: TButton
    Left = 186
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Cart'#227'o'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = OrdemCartaoClick
  end
  object cmdOrdemVlDeb: TButton
    Left = 506
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Valor D'#233'bito'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = cmdOrdemVlDebClick
  end
  object cmdOrdemVlCred: TButton
    Left = 570
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Valor Cr'#233'dito'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = cmdOrdemVlCredClick
  end
  object cmdOrdemVlSaldo: TButton
    Left = 692
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Saldo'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = cmdOrdemVlSaldoClick
  end
  object cmdOrdemCredDolar: TButton
    Left = 400
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Cr'#233'dito'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    OnClick = cmdOrdemCredDolarClick
  end
  object cmdOrdemDebDolar: TButton
    Left = 295
    Top = 4
    Width = 29
    Height = 33
    Hint = 'D'#233'bito'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    OnClick = cmdOrdemDebDolarClick
  end
  object cmdOrdemVariac: TButton
    Left = 627
    Top = 4
    Width = 29
    Height = 33
    Hint = 'Varia'#231#227'o'
    Caption = 'v'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
    OnClick = cmdOrdemVariacClick
  end
  object cmdOrdemBanco: TButton
    Left = 8
    Top = 4
    Width = 29
    Height = 33
    Caption = '#'
    TabOrder = 18
    OnClick = cmdOrdemBancoClick
  end
  object Command1: TButton
    Left = 65
    Top = 453
    Width = 29
    Height = 21
    Caption = 'v'
    TabOrder = 15
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 251
    Top = 453
    Width = 29
    Height = 21
    Caption = 'v'
    TabOrder = 17
    OnClick = Command2Click
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 56
    Width = 778
    Height = 321
    DataSource = Data1_DataSource
    TabOrder = 19
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Data1_DataSource: TDataSource
    DataSet = Data1_DataSet
    Left = 232
    Top = 6
  end
  object Data1_DataSet: TADODataSet
    Parameters = <>
    Left = 344
    Top = 8
  end
end
