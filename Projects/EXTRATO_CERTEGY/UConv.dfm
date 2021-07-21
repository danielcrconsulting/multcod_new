object Form1: TForm1
  Left = 215
  Top = 106
  Caption = 'Conversor de arquivos - V 2.0 03/11/2015'
  ClientHeight = 441
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
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
    Left = 79
    Top = 330
    Width = 61
    Height = 13
    Caption = 'Troca String:'
  end
  object Label3: TLabel
    Left = 79
    Top = 360
    Width = 41
    Height = 13
    Caption = 'Posi'#231#227'o:'
  end
  object Label4: TLabel
    Left = 79
    Top = 387
    Width = 59
    Height = 13
    Caption = 'Nova String:'
  end
  object Label5: TLabel
    Left = 424
    Top = 394
    Width = 32
    Height = 13
    Caption = 'Label5'
    Visible = False
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
    Top = 187
    Width = 116
    Height = 25
    Caption = 'Converte HP p/ Fast'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 144
    Top = 384
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object Button2: TButton
    Left = 271
    Top = 382
    Width = 75
    Height = 25
    Caption = 'Troca String'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 144
    Top = 357
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object Button3: TButton
    Left = 600
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 5
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Left = 360
    Top = 48
  end
end
