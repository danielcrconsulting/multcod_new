object Incluir: TIncluir
  Left = 0
  Top = 0
  Caption = 'SISCOC-Incluir Registro'
  ClientHeight = 464
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 158
    Top = 49
    Width = 86
    Height = 29
    AutoSize = False
    Caption = 'Data D'#233'bito (DD/MM/AAAA)'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 243
    Top = 49
    Width = 82
    Height = 33
    AutoSize = False
    Caption = 'Data Cr'#233'dito (DD/MM/AAAA)'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 344
    Top = 61
    Width = 118
    Height = 25
    AutoSize = False
    Caption = 'Cart'#227'o'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 437
    Top = 117
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'D'#233'bito Real'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 437
    Top = 162
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Cr'#233'dito Real'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 44
    Top = 117
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'D'#233'bito Dolar'
    WordWrap = True
  end
  object Label7: TLabel
    Left = 44
    Top = 162
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Taxa D'#233'bito'
    WordWrap = True
  end
  object Label8: TLabel
    Left = 279
    Top = 117
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Credito Dolar'
    WordWrap = True
  end
  object Label9: TLabel
    Left = 279
    Top = 162
    Width = 62
    Height = 25
    AutoSize = False
    Caption = 'Taxa Cr'#233'dito'
    WordWrap = True
  end
  object Label10: TLabel
    Left = 44
    Top = 324
    Width = 106
    Height = 25
    AutoSize = False
    Caption = 'Observa'#231#227'o D'#233'bito'
    WordWrap = True
  end
  object Label11: TLabel
    Left = 40
    Top = 352
    Width = 106
    Height = 25
    AutoSize = False
    Caption = 'Observa'#231#227'o Cr'#233'dito'
    WordWrap = True
  end
  object Label18: TLabel
    Left = 433
    Top = 267
    Width = 90
    Height = 25
    AutoSize = False
    Caption = 'Depto Cr'#233'dito'
    WordWrap = True
  end
  object Label17: TLabel
    Left = 433
    Top = 222
    Width = 94
    Height = 25
    AutoSize = False
    Caption = 'Depto D'#233'bito'
    WordWrap = True
  end
  object Label16: TLabel
    Left = 44
    Top = 218
    Width = 74
    Height = 25
    AutoSize = False
    Caption = 'C'#243'digo D'#233'bito'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 44
    Top = 263
    Width = 74
    Height = 25
    AutoSize = False
    Caption = 'C'#243'digo Cr'#233'dito'
    WordWrap = True
  end
  object Label14: TLabel
    Left = 267
    Top = 218
    Width = 94
    Height = 25
    AutoSize = False
    Caption = 'Relat'#243'rio D'#233'bito'
    WordWrap = True
  end
  object Label13: TLabel
    Left = 267
    Top = 263
    Width = 90
    Height = 25
    AutoSize = False
    Caption = 'Relat'#243'rio  Cr'#233'dito'
    WordWrap = True
  end
  object txtDtDebito: TEdit
    Left = 158
    Top = 81
    Width = 82
    Height = 21
    TabOrder = 0
  end
  object txtDtCredito: TEdit
    Left = 239
    Top = 81
    Width = 82
    Height = 21
    TabOrder = 1
  end
  object txtNroCartao: TEdit
    Left = 320
    Top = 81
    Width = 147
    Height = 21
    TabOrder = 2
  end
  object txtVlDebito: TEdit
    Left = 502
    Top = 117
    Width = 74
    Height = 21
    TabOrder = 3
  end
  object txtVlCredito: TEdit
    Left = 502
    Top = 162
    Width = 74
    Height = 21
    TabOrder = 4
  end
  object cmdGravar: TButton
    Left = 392
    Top = 404
    Width = 82
    Height = 33
    Caption = '&Gravar'
    TabOrder = 13
    OnClick = cmdGravarClick
  end
  object cmdCancel: TButton
    Left = 498
    Top = 404
    Width = 82
    Height = 33
    Caption = '&Cancelar'
    TabOrder = 14
    OnClick = cmdCancelClick
  end
  object txtDD_0: TEdit
    Left = 109
    Top = 117
    Width = 74
    Height = 21
    TabOrder = 15
  end
  object txtTD_0: TEdit
    Left = 109
    Top = 162
    Width = 74
    Height = 21
    TabOrder = 17
  end
  object txtCD: TEdit
    Left = 344
    Top = 117
    Width = 74
    Height = 21
    TabOrder = 16
  end
  object txtTD_1: TEdit
    Left = 344
    Top = 162
    Width = 74
    Height = 21
    TabOrder = 18
  end
  object txtObsDeb: TEdit
    Left = 154
    Top = 324
    Width = 422
    Height = 21
    TabOrder = 11
  end
  object txtObsCred: TEdit
    Left = 154
    Top = 352
    Width = 422
    Height = 21
    TabOrder = 12
  end
  object txtDeptCred_0: TEdit
    Left = 510
    Top = 267
    Width = 66
    Height = 21
    TabOrder = 10
  end
  object txtDeptDeb_0: TEdit
    Left = 510
    Top = 222
    Width = 66
    Height = 21
    TabOrder = 7
  end
  object txtCodDeb_3: TEdit
    Left = 125
    Top = 218
    Width = 134
    Height = 21
    TabOrder = 5
  end
  object txtCodCred_3: TEdit
    Left = 125
    Top = 263
    Width = 134
    Height = 21
    TabOrder = 8
  end
  object txtRelDeb_1: TEdit
    Left = 352
    Top = 218
    Width = 66
    Height = 21
    TabOrder = 6
  end
  object txtRelCred_2: TEdit
    Left = 352
    Top = 263
    Width = 66
    Height = 21
    TabOrder = 9
  end
end
