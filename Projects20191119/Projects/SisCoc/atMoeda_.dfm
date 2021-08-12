object atMoeda: TatMoeda
  Left = 0
  Top = 0
  Caption = 'SISCOC-Atualiza valor da Moeda'
  ClientHeight = 215
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 49
    Width = 106
    Height = 33
    AutoSize = False
    Caption = 'Data(DD/MM/AAAA)'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 32
    Top = 85
    Width = 106
    Height = 33
    AutoSize = False
    Caption = 'Valor (R$)'
    WordWrap = True
  end
  object Text1: TEdit
    Left = 142
    Top = 49
    Width = 98
    Height = 21
    TabOrder = 1
    OnExit = Text1Exit
  end
  object Text2: TEdit
    Left = 142
    Top = 85
    Width = 98
    Height = 21
    TabOrder = 3
  end
  object cmdOk: TButton
    Left = 158
    Top = 154
    Width = 82
    Height = 33
    Caption = 'Ok'
    TabOrder = 0
    OnClick = cmdOkClick
  end
  object cmdCancel: TButton
    Left = 28
    Top = 154
    Width = 82
    Height = 33
    Caption = 'Cancela'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
end
