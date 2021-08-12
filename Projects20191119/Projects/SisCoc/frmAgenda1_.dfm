object frmAgenda1: TfrmAgenda1
  Left = 0
  Top = 0
  Caption = 'SISCOC-Movimentos a Agendar'
  ClientHeight = 278
  ClientWidth = 599
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
    Left = 182
    Top = 28
    Width = 312
    Height = 29
    AutoSize = False
    Caption = 'CHARGEBACK EMITIDO PARA AGENDAMENTO'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 121
    Top = 81
    Width = 94
    Height = 29
    AutoSize = False
    Caption = 'D'#233'bito Dolar'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 344
    Top = 81
    Width = 98
    Height = 33
    AutoSize = False
    Caption = 'Cr'#233'dito Dolar'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 53
    Top = 125
    Width = 66
    Height = 21
    AutoSize = False
    Caption = 'Quantidade'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 53
    Top = 154
    Width = 70
    Height = 25
    AutoSize = False
    Caption = 'Valor'
    WordWrap = True
  end
  object Line1: TShape
    Left = 12
    Top = 201
    Width = 595
    Height = 3
    Brush.Color = clWindowText
    Pen.Color = clWindowText
  end
  object Label6: TLabel
    Left = 227
    Top = 81
    Width = 94
    Height = 29
    AutoSize = False
    Caption = 'D'#233'bito Real'
    WordWrap = True
  end
  object Label7: TLabel
    Left = 453
    Top = 81
    Width = 98
    Height = 33
    AutoSize = False
    Caption = 'Cr'#233'dito Real'
    WordWrap = True
  end
  object Text1: TEdit
    Left = 121
    Top = 121
    Width = 98
    Height = 21
    TabOrder = 0
  end
  object Text2: TEdit
    Left = 121
    Top = 154
    Width = 98
    Height = 21
    TabOrder = 2
  end
  object Text3: TEdit
    Left = 344
    Top = 121
    Width = 102
    Height = 21
    TabOrder = 4
  end
  object Text4: TEdit
    Left = 344
    Top = 154
    Width = 102
    Height = 21
    TabOrder = 6
  end
  object Command1: TButton
    Left = 453
    Top = 227
    Width = 102
    Height = 25
    Caption = 'Agendar'
    TabOrder = 8
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 247
    Top = 227
    Width = 110
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 10
    OnClick = Command2Click
  end
  object Text5: TEdit
    Left = 227
    Top = 154
    Width = 98
    Height = 21
    TabOrder = 1
  end
  object Text6: TEdit
    Left = 227
    Top = 121
    Width = 98
    Height = 21
    TabOrder = 3
  end
  object Text7: TEdit
    Left = 453
    Top = 154
    Width = 102
    Height = 21
    TabOrder = 5
  end
  object Text8: TEdit
    Left = 453
    Top = 121
    Width = 102
    Height = 21
    TabOrder = 7
  end
  object cmdRelat: TButton
    Left = 53
    Top = 227
    Width = 110
    Height = 25
    Caption = 'Relat'#243'rio'
    TabOrder = 9
    OnClick = cmdRelatClick
  end
end
