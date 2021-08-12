object Alterar1Manual: TAlterar1Manual
  Left = 0
  Top = 0
  Caption = 'SISCOC=Altera'#231#227'o de Registros'
  ClientHeight = 463
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 352
    Top = 154
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Cr'#233'dito Real'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 352
    Top = 109
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'D'#233'bito Real'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 299
    Top = 53
    Width = 118
    Height = 25
    AutoSize = False
    Caption = 'Cart'#227'o'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 198
    Top = 40
    Width = 82
    Height = 33
    AutoSize = False
    Caption = 'Data Cr'#233'dito (DD/MM/AAAA)'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 113
    Top = 40
    Width = 86
    Height = 29
    AutoSize = False
    Caption = 'Data D'#233'bito (DD/MM/AAAA)'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 32
    Top = 109
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'D'#233'bito Dolar'
    WordWrap = True
  end
  object Label7: TLabel
    Left = 32
    Top = 154
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Taxa D'#233'bito'
    WordWrap = True
  end
  object Label8: TLabel
    Left = 194
    Top = 109
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Credito Dolar'
    WordWrap = True
  end
  object Label9: TLabel
    Left = 194
    Top = 154
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Taxa Cr'#233'dito'
    WordWrap = True
  end
  object Label10: TLabel
    Left = 32
    Top = 324
    Width = 114
    Height = 25
    AutoSize = False
    Caption = 'Observa'#231#227'o D'#233'bito'
    WordWrap = True
  end
  object Label11: TLabel
    Left = 352
    Top = 186
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Varia'#231#227'o'
    WordWrap = True
  end
  object Label12: TLabel
    Left = 32
    Top = 352
    Width = 110
    Height = 25
    AutoSize = False
    Caption = 'Observa'#231#227'o Cr'#233'dito'
    WordWrap = True
  end
  object Label13: TLabel
    Left = 182
    Top = 275
    Width = 90
    Height = 25
    AutoSize = False
    Caption = 'Relat'#243'rio  Cr'#233'dito'
    WordWrap = True
  end
  object Label14: TLabel
    Left = 182
    Top = 231
    Width = 94
    Height = 25
    AutoSize = False
    Caption = 'Relat'#243'rio D'#233'bito'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 32
    Top = 275
    Width = 74
    Height = 25
    AutoSize = False
    Caption = 'C'#243'digo Cr'#233'dito'
    WordWrap = True
  end
  object Label16: TLabel
    Left = 32
    Top = 231
    Width = 74
    Height = 25
    AutoSize = False
    Caption = 'C'#243'digo D'#233'bito'
    WordWrap = True
  end
  object Label17: TLabel
    Left = 348
    Top = 235
    Width = 94
    Height = 25
    AutoSize = False
    Caption = 'Depto D'#233'bito'
    WordWrap = True
  end
  object Label18: TLabel
    Left = 348
    Top = 279
    Width = 90
    Height = 25
    AutoSize = False
    Caption = 'Depto Cr'#233'dito'
    WordWrap = True
  end
  object cmdCancel: TButton
    Left = 409
    Top = 404
    Width = 82
    Height = 33
    Caption = '&Cancelar'
    TabOrder = 19
    OnClick = cmdCancelClick
  end
  object cmdGravar: TButton
    Left = 303
    Top = 404
    Width = 82
    Height = 33
    Caption = '&Gravar'
    TabOrder = 18
    OnClick = cmdGravarClick
  end
  object txtVlCredito: TEdit
    Left = 417
    Top = 154
    Width = 74
    Height = 21
    TabOrder = 8
  end
  object txtVlDebito: TEdit
    Left = 417
    Top = 109
    Width = 74
    Height = 21
    TabOrder = 7
  end
  object txtNroCartao: TEdit
    Left = 275
    Top = 73
    Width = 147
    Height = 21
    TabOrder = 2
  end
  object txtDtCredito: TEdit
    Left = 194
    Top = 73
    Width = 82
    Height = 21
    TabOrder = 1
  end
  object txtDtDebito: TEdit
    Left = 113
    Top = 73
    Width = 82
    Height = 21
    TabOrder = 0
  end
  object txtDD_0: TEdit
    Left = 97
    Top = 109
    Width = 74
    Height = 21
    TabOrder = 3
  end
  object txtTD_0: TEdit
    Left = 97
    Top = 154
    Width = 74
    Height = 21
    TabOrder = 4
  end
  object txtDD_2: TEdit
    Left = 259
    Top = 109
    Width = 74
    Height = 21
    TabOrder = 5
  end
  object txtTD_1: TEdit
    Left = 259
    Top = 154
    Width = 74
    Height = 21
    TabOrder = 6
  end
  object txtObsDeb: TEdit
    Left = 154
    Top = 324
    Width = 337
    Height = 21
    TabOrder = 16
    OnKeyDown = txtObsDebKeyDown
  end
  object txtVariacao: TEdit
    Left = 417
    Top = 186
    Width = 74
    Height = 21
    TabOrder = 9
  end
  object txtObsCred: TEdit
    Left = 154
    Top = 352
    Width = 337
    Height = 21
    TabOrder = 17
    OnKeyPress = txtObsCredKeyPress
  end
  object txtRelCred_2: TEdit
    Left = 267
    Top = 275
    Width = 66
    Height = 21
    TabOrder = 14
  end
  object txtRelDeb_1: TEdit
    Left = 267
    Top = 231
    Width = 66
    Height = 21
    TabOrder = 11
  end
  object txtCodCred_3: TEdit
    Left = 113
    Top = 275
    Width = 54
    Height = 21
    TabOrder = 13
  end
  object txtCodDeb_3: TEdit
    Left = 113
    Top = 231
    Width = 54
    Height = 21
    TabOrder = 10
  end
  object txtDeptDeb_0: TEdit
    Left = 425
    Top = 235
    Width = 66
    Height = 21
    TabOrder = 12
  end
  object txtDeptCred_0: TEdit
    Left = 425
    Top = 279
    Width = 66
    Height = 21
    TabOrder = 15
  end
end
