object PBar: TPBar
  Left = 0
  Top = 0
  Caption = 'SISCOC-Progresso da Opera'#231#227'o'
  ClientHeight = 107
  ClientWidth = 316
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
    Left = 8
    Top = 32
    Width = 292
    Height = 17
    AutoSize = False
    Visible = False
    WordWrap = True
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 57
    Width = 296
    Height = 17
    TabOrder = 0
    Visible = False
  end
end
