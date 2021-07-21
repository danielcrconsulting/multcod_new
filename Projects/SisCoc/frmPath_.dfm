object frmPath: TfrmPath
  Left = 0
  Top = 0
  Caption = 'SISCOC-Cadastro de Paths'
  ClientHeight = 201
  ClientWidth = 663
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
    Left = 24
    Top = 44
    Width = 122
    Height = 21
    AutoSize = False
    Caption = 'Path Arquivo de Entrada'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 24
    Top = 65
    Width = 126
    Height = 21
    AutoSize = False
    Caption = 'Path Arquivo de Template'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 24
    Top = 89
    Width = 118
    Height = 17
    AutoSize = False
    Caption = 'Path Arquivo de Saida'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 24
    Top = 109
    Width = 118
    Height = 17
    AutoSize = False
    Caption = 'Path Arquivo Excel'
    WordWrap = True
  end
  object txtArqEntrada: TEdit
    Left = 154
    Top = 44
    Width = 486
    Height = 21
    TabOrder = 1
  end
  object txtArqTemplate: TEdit
    Left = 154
    Top = 65
    Width = 486
    Height = 21
    TabOrder = 3
  end
  object txtArqSaida: TEdit
    Left = 154
    Top = 85
    Width = 486
    Height = 21
    TabOrder = 5
  end
  object cmdGravar: TButton
    Left = 558
    Top = 150
    Width = 82
    Height = 33
    Caption = '&Gravar'
    TabOrder = 0
    OnClick = cmdGravarClick
  end
  object cmdCancelar: TButton
    Left = 465
    Top = 150
    Width = 82
    Height = 33
    Caption = '&Cancelar'
    TabOrder = 2
    OnClick = cmdCancelarClick
  end
  object txtArqExcel: TEdit
    Left = 154
    Top = 105
    Width = 486
    Height = 21
    TabOrder = 4
  end
  object ADOConnection1: TADOConnection
    Left = 32
    Top = 144
  end
  object RsDb: TADOTable
    Connection = ADOConnection1
    Left = 112
    Top = 136
  end
end
