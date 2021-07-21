object Form1: TForm1
  Left = 268
  Top = 137
  Width = 708
  Height = 269
  Caption = 'Multiplicador de arquivos'
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
    Left = 40
    Top = 32
    Width = 27
    Height = 13
    Caption = 'PDF: '
  end
  object Label2: TLabel
    Left = 40
    Top = 64
    Width = 103
    Height = 13
    Caption = 'Qtd a gerar (x 10000):'
  end
  object Label3: TLabel
    Left = 40
    Top = 104
    Width = 78
    Height = 13
    Caption = 'Diret'#243'rio a gerar:'
  end
  object Label4: TLabel
    Left = 208
    Top = 160
    Width = 46
    Height = 13
    Caption = 'Gerados: '
  end
  object Edit1: TEdit
    Left = 72
    Top = 24
    Width = 585
    Height = 21
    TabOrder = 0
    OnDblClick = Edit1DblClick
  end
  object Edit2: TEdit
    Left = 152
    Top = 56
    Width = 225
    Height = 21
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 128
    Top = 96
    Width = 529
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 40
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Gerar'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Edit4: TEdit
    Left = 272
    Top = 152
    Width = 201
    Height = 21
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Left = 576
    Top = 176
  end
end
