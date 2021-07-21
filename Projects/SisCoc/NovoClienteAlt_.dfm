object NovoClienteAlt: TNovoClienteAlt
  Left = 0
  Top = 0
  Caption = 'SISCOC-Altera Cliente'
  ClientHeight = 299
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Frame1: TGroupBox
    Left = 12
    Top = 36
    Width = 531
    Height = 256
    Caption = 'Dados do Cliente'
    TabOrder = 0
    object Label2: TLabel
      Left = 12
      Top = 113
      Width = 98
      Height = 21
      AutoSize = False
      Caption = 'Nome do Cliente'
      WordWrap = True
    end
    object Label1: TLabel
      Left = 12
      Top = 85
      Width = 90
      Height = 21
      AutoSize = False
      Caption = 'Nome Reduzido:'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 12
      Top = 57
      Width = 106
      Height = 21
      AutoSize = False
      Caption = 'N'#250'mero do Cliente:'
      WordWrap = True
    end
    object Label4: TLabel
      Left = 12
      Top = 142
      Width = 90
      Height = 21
      AutoSize = False
      Caption = 'Bandeira:'
      WordWrap = True
    end
    object Text2: TEdit
      Left = 125
      Top = 113
      Width = 377
      Height = 21
      TabOrder = 2
    end
    object Text1: TEdit
      Left = 125
      Top = 85
      Width = 114
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object Command1: TButton
      Left = 421
      Top = 198
      Width = 82
      Height = 33
      Caption = '&Gravar'
      TabOrder = 3
      OnClick = Command1Click
    end
    object Command2: TButton
      Left = 316
      Top = 198
      Width = 82
      Height = 33
      Caption = '&Sair'
      TabOrder = 5
      OnClick = Command2Click
    end
    object Text3: TEdit
      Left = 125
      Top = 57
      Width = 50
      Height = 21
      TabOrder = 0
      OnExit = Text3Exit
      OnKeyPress = Text3KeyPress
    end
    object Text4: TEdit
      Left = 125
      Top = 142
      Width = 114
      Height = 21
      TabOrder = 4
    end
  end
  object RsDb: TADODataSet
    Connection = gBanco
    Parameters = <>
    Left = 376
    Top = 8
  end
  object gBanco: TADOConnection
    Left = 336
    Top = 8
  end
end
