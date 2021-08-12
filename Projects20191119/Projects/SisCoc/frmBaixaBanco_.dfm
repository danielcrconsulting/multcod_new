object frmBaixaBanco: TfrmBaixaBanco
  Left = 0
  Top = 0
  Caption = 'SISCOC-Baixa do Banco'
  ClientHeight = 279
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 118
    Height = 21
    AutoSize = False
    Caption = 'Moeda'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 32
    Top = 57
    Width = 118
    Height = 21
    AutoSize = False
    Caption = 'Data (DD/MM/AA)'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 32
    Top = 93
    Width = 110
    Height = 13
    AutoSize = False
    Caption = 'Observa'#231#227'o D'#233'bito'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 32
    Top = 142
    Width = 110
    Height = 13
    AutoSize = False
    Caption = 'Observa'#231#227'o Cr'#233'dito'
    WordWrap = True
  end
  object cmdProcessa: TButton
    Left = 150
    Top = 218
    Width = 82
    Height = 33
    Caption = '&Processa'
    TabOrder = 4
    OnClick = cmdProcessaClick
  end
  object cmdCancela: TButton
    Left = 24
    Top = 218
    Width = 82
    Height = 33
    Caption = '&Cancela'
    TabOrder = 5
    OnClick = cmdCancelaClick
  end
  object Text3: TEdit
    Left = 154
    Top = 32
    Width = 82
    Height = 21
    TabOrder = 0
  end
  object Text6: TEdit
    Left = 154
    Top = 53
    Width = 82
    Height = 21
    TabOrder = 1
  end
  object txtObsDeb: TEdit
    Left = 32
    Top = 109
    Width = 207
    Height = 21
    TabOrder = 2
  end
  object txtObsCred: TEdit
    Left = 32
    Top = 158
    Width = 207
    Height = 21
    TabOrder = 3
  end
  object gBancoAdm: TADOConnection
    Left = 240
    Top = 8
  end
  object RsDbAdm: TADODataSet
    Connection = gBancoAdm
    Parameters = <>
    Left = 240
    Top = 56
  end
  object gBancoCli: TADOConnection
    Left = 120
    Top = 184
  end
  object RsDbCli: TADODataSet
    Connection = gBancoCli
    Parameters = <>
    Left = 160
    Top = 184
  end
end
