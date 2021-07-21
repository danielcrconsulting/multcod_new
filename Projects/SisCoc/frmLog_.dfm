object frmLog: TfrmLog
  Left = 0
  Top = 0
  Caption = 'SISCOC-Resumo das Atividades'
  ClientHeight = 385
  ClientWidth = 611
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
  object Command1: TButton
    Left = 502
    Top = 332
    Width = 82
    Height = 33
    Caption = 'Sair'
    TabOrder = 0
    OnClick = Command1Click
  end
  object Command2: TButton
    Left = 396
    Top = 332
    Width = 82
    Height = 33
    Caption = 'Imprimir'
    TabOrder = 1
    OnClick = Command2Click
  end
  object RichTextBox1: TMemo
    Left = 16
    Top = 16
    Width = 568
    Height = 297
    TabOrder = 2
  end
  object cmdDialog1_Save: TSaveDialog
    Left = 196
    Top = 325
  end
  object cmdDialog1: TPrintDialog
    Left = 279
    Top = 328
  end
end
