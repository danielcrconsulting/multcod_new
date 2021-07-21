object frmAgenda: TfrmAgenda
  Left = 0
  Top = 0
  Caption = 'SISCOC-Agendamento'
  ClientHeight = 161
  ClientWidth = 487
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
  object Label4: TLabel
    Left = 355
    Top = 24
    Width = 114
    Height = 17
    AutoSize = False
    Caption = '(DD/MM/AAAA)'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 268
    Top = 40
    Width = 86
    Height = 29
    AutoSize = False
    Caption = 'CH Emitido Agendado'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 105
    Top = 24
    Width = 114
    Height = 17
    AutoSize = False
    Caption = '(DD/MM/AAAA)'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 24
    Top = 40
    Width = 82
    Height = 29
    AutoSize = False
    Caption = 'CH Emitido para Agendamento'
    WordWrap = True
  end
  object Line1: TShape
    Left = 16
    Top = 84
    Width = 453
    Height = 3
    Brush.Color = clWindowText
    Pen.Color = clWindowText
  end
  object Text2: TEdit
    Left = 355
    Top = 40
    Width = 114
    Height = 21
    TabOrder = 1
  end
  object Command1: TButton
    Left = 387
    Top = 105
    Width = 82
    Height = 33
    Caption = 'Ok'
    TabOrder = 3
    OnClick = Command1Click
  end
  object Text1: TEdit
    Left = 105
    Top = 40
    Width = 114
    Height = 21
    TabOrder = 0
  end
  object Command2: TButton
    Left = 271
    Top = 105
    Width = 82
    Height = 33
    Caption = '&Cancela'
    TabOrder = 2
    OnClick = Command2Click
  end
end
