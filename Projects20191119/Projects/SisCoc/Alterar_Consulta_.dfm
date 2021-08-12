object Alterar_Consulta: TAlterar_Consulta
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'SISCOC-Consulta Registro'
  ClientHeight = 479
  ClientWidth = 806
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
  object Data1: TDBNavigator
    Left = 554
    Top = 391
    Width = 80
    Height = 23
    DataSource = Data1_DataSource
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 1
    Visible = False
  end
  object Frame1: TGroupBox
    Left = 154
    Top = 400
    Width = 215
    Height = 50
    Caption = 'Selecione o Cart'#227'o'
    TabOrder = 2
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
    TabOrder = 3
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
  object OrdemDtDeb: TButton
    Left = 44
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 4
    OnClick = OrdemDtDebClick
  end
  object OrdemDtCred: TButton
    Left = 109
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 5
    OnClick = OrdemDtCredClick
  end
  object OrdemCartao: TButton
    Left = 186
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 6
    OnClick = OrdemCartaoClick
  end
  object cmdOrdemVlDeb: TButton
    Left = 506
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 7
    OnClick = cmdOrdemVlDebClick
  end
  object cmdOrdemVlCred: TButton
    Left = 570
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 8
    OnClick = cmdOrdemVlCredClick
  end
  object cmdOrdemVlSaldo: TButton
    Left = 692
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 9
    OnClick = cmdOrdemVlSaldoClick
  end
  object cmdOrdemCredDolar: TButton
    Left = 400
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 10
    OnClick = cmdOrdemCredDolarClick
  end
  object cmdOrdemDebDolar: TButton
    Left = 295
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 11
    OnClick = cmdOrdemDebDolarClick
  end
  object cmdOrdemVariac: TButton
    Left = 627
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 12
    OnClick = cmdOrdemVariacClick
  end
  object cmdOrdemObs: TButton
    Left = 748
    Top = 4
    Width = 29
    Height = 33
    Caption = 'v'
    TabOrder = 14
    OnClick = cmdOrdemObsClick
  end
  object cmdOrdemBanco: TButton
    Left = 8
    Top = 4
    Width = 29
    Height = 33
    Caption = '#'
    TabOrder = 16
    OnClick = cmdOrdemBancoClick
  end
  object Command1: TButton
    Left = 65
    Top = 453
    Width = 29
    Height = 21
    Caption = 'v'
    TabOrder = 13
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 251
    Top = 453
    Width = 29
    Height = 21
    Caption = 'v'
    TabOrder = 15
    OnClick = Command2Click
  end
  object DBGrid: TDBGrid
    Left = 8
    Top = 43
    Width = 778
    Height = 342
    DataSource = Data1_DataSource
    TabOrder = 17
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Data1_DataSource: TDataSource
    DataSet = Data1_DataSet
    Left = 400
    Top = 422
  end
  object Data1_DataSet: TADODataSet
    CursorType = ctStatic
    Parameters = <>
    Left = 494
    Top = 422
  end
end
