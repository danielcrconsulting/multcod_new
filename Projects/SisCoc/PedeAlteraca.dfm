object PedeAlteracao: TPedeAlteracao
  Left = 0
  Top = 0
  Caption = 'PedeAlteracao'
  ClientHeight = 250
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 48
    Width = 86
    Height = 13
    Caption = 'Nome do Arquivo:'
  end
  object Edit1: TEdit
    Left = 160
    Top = 40
    Width = 417
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 48
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 502
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = Button2Click
  end
end
