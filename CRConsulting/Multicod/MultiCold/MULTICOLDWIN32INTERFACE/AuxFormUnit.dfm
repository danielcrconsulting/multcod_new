object AuxForm: TAuxForm
  Left = 215
  Top = 110
  Width = 696
  Height = 480
  Caption = 'AuxForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GridPesq: TStringGrid
    Left = 56
    Top = 80
    Width = 433
    Height = 120
    RowCount = 102
    TabOrder = 0
    ColWidths = (
      64
      64
      64
      64
      64)
  end
  object Memo1: TMemo
    Left = 64
    Top = 232
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ProcurNaMesma: TCheckBox
    Left = 344
    Top = 296
    Width = 97
    Height = 17
    Caption = 'ProcurNaMesma'
    TabOrder = 2
  end
  object ProcurSeq: TCheckBox
    Left = 344
    Top = 328
    Width = 97
    Height = 17
    Caption = 'ProcurSeq'
    TabOrder = 3
  end
end
