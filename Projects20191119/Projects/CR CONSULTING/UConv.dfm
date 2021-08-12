object Form1: TForm1
  Left = 215
  Top = 106
  Caption = 'CC Insert - V 1.0 08/01/2016'
  ClientHeight = 441
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 152
    Width = 51
    Height = 13
    Caption = 'Arquivo In:'
  end
  object Label2: TLabel
    Left = 80
    Top = 210
    Width = 85
    Height = 13
    Caption = 'Inserir o caractere'
  end
  object Label4: TLabel
    Left = 223
    Top = 210
    Width = 115
    Height = 13
    Caption = 'na linha que tem a string'
  end
  object Label6: TLabel
    Left = 432
    Top = 237
    Width = 52
    Height = 13
    Caption = 'na posi'#231#227'o'
  end
  object Label5: TLabel
    Left = 80
    Top = 328
    Width = 529
    Height = 13
    Caption = 'Label5'
  end
  object Edit1: TEdit
    Left = 144
    Top = 144
    Width = 465
    Height = 21
    TabOrder = 0
    OnDblClick = Edit1DblClick
  end
  object Button1: TButton
    Left = 493
    Top = 275
    Width = 116
    Height = 25
    Caption = 'Inserir'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 172
    Top = 202
    Width = 29
    Height = 21
    TabOrder = 2
  end
  object Button3: TButton
    Left = 600
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Edit4: TEdit
    Left = 344
    Top = 202
    Width = 265
    Height = 21
    TabOrder = 4
  end
  object Edit5: TEdit
    Left = 493
    Top = 229
    Width = 116
    Height = 21
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    Left = 360
    Top = 48
  end
end
