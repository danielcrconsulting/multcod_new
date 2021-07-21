object frmRelease: TfrmRelease
  Left = 0
  Top = 0
  Caption = 'SISCOC-Notas de Libera'#231#227'o de Programa'
  ClientHeight = 270
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cmdOk: TButton
    Left = 380
    Top = 231
    Width = 70
    Height = 29
    Caption = '&Ok'
    TabOrder = 0
    OnClick = cmdOkClick
  end
  object Check1: TCheckBox
    Left = 20
    Top = 235
    Width = 171
    Height = 21
    Caption = 'N'#227'o mostrar na pr'#243'xima vez'
    TabOrder = 1
  end
  object RichTextBox1: TMemo
    Left = 20
    Top = 8
    Width = 430
    Height = 209
    TabOrder = 2
  end
end
