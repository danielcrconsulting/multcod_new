object AnotaTextoForm: TAnotaTextoForm
  Left = 238
  Top = 165
  Caption = 'Anota'#231#245'es de Texto'
  ClientHeight = 441
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 240
    Top = 384
    Width = 32
    Height = 14
    Caption = 'Label1'
    Color = clYellow
    ParentColor = False
  end
  object Label5: TLabel
    Left = 240
    Top = 352
    Width = 50
    Height = 14
    Caption = 'Anota'#231#227'o:'
  end
  object SairBut: TButton
    Left = 424
    Top = 408
    Width = 99
    Height = 25
    Caption = '&Sair'
    ModalResult = 2
    TabOrder = 0
    OnClick = SairButClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 513
    Height = 329
    TabOrder = 1
    OnChange = Memo1Change
    OnKeyPress = Memo1KeyPress
  end
  object SalvarButton: TButton
    Left = 16
    Top = 408
    Width = 99
    Height = 25
    Caption = 'S&alvar'
    TabOrder = 2
    OnClick = SalvarButtonClick
  end
  object ExcluirButton: TButton
    Left = 128
    Top = 408
    Width = 99
    Height = 25
    Caption = '&Excluir'
    TabOrder = 3
    OnClick = ExcluirButtonClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 352
    Width = 185
    Height = 41
    BevelOuter = bvNone
    TabOrder = 4
    object PublicaRadioButton: TRadioButton
      Left = 8
      Top = 0
      Width = 113
      Height = 17
      Caption = 'P'#250'blica'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object PrivadaRadioButton: TRadioButton
      Left = 8
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Privada'
      TabOrder = 1
    end
  end
  object ScrollBar1: TScrollBar
    Left = 240
    Top = 368
    Width = 89
    Height = 16
    Max = 0
    PageSize = 0
    TabOrder = 5
    OnScroll = ScrollBar1Scroll
  end
  object ADOQuery1: TADOQuery
    Connection = FormGeral.DatabaseMultiCold
    Parameters = <>
    Left = 488
    Top = 352
  end
  object FDQuery1: TFDQuery
    Left = 384
    Top = 360
  end
  object Memtb: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 296
    Top = 400
  end
end
