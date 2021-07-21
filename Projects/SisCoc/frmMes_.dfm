
object frmMes: TfrmMes
  Left = 0
  Top = 0
  ClientWidth = 267
  ClientHeight = 246
  Caption = 'SISCOC-Digite o Mês da Variação'
  Position = poScreenCenter
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  object Label1: TLabel
    Left = 36
    Top = 44
    Width = 78
    Height = 29
    Caption = 'Mês/Ano da Variação'
    AutoSize = False
    WordWrap = True
  end
  object Label3: TLabel
    Left = 113
    Top = 32
    Width = 114
    Height = 17
    Caption = '(MM/AAAA)'
    AutoSize = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 40
    Top = 125
    Width = 78
    Height = 29
    Caption = 'Data do Lançamento'
    AutoSize = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 121
    Top = 113
    Width = 114
    Height = 17
    Caption = '(DD/MM/AAAA)'
    AutoSize = False
    WordWrap = True
  end
  object Command2: TButton
    Left = 40
    Top = 186
    Width = 82
    Height = 33
    Caption = '&Cancela'
    TabOrder = 2
    OnClick = Command2Click
  end
  object Text1: TEdit
    Left = 113
    Top = 49
    Width = 114
    Height = 29
    TabOrder = 0
  end
  object Command1: TButton
    Left = 154
    Top = 186
    Width = 82
    Height = 33
    Caption = 'Ok'
    TabOrder = 3
    OnClick = Command1Click
  end
  object Text2: TEdit
    Left = 117
    Top = 129
    Width = 114
    Height = 29
    TabOrder = 1
  end
end