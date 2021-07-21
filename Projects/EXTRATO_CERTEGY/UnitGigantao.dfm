object Form1: TForm1
  Left = 252
  Top = 236
  Width = 870
  Height = 530
  Align = alBottom
  Caption = 'Consulta Gigant'#227'o'
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
    Top = 192
    Width = 119
    Height = 13
    Caption = 'Informe o pdf a recuperar'
  end
  object Label2: TLabel
    Left = 80
    Top = 80
    Width = 131
    Height = 13
    Caption = 'Informe o Arquivo Blocado: '
  end
  object Label3: TLabel
    Left = 80
    Top = 136
    Width = 172
    Height = 13
    Caption = 'Informe o diret'#243'rio onde extrair o pdf:'
  end
  object Edit1: TEdit
    Left = 224
    Top = 72
    Width = 553
    Height = 21
    TabOrder = 0
    OnDblClick = Edit1DblClick
  end
  object Edit2: TEdit
    Left = 264
    Top = 128
    Width = 513
    Height = 21
    TabOrder = 1
    Text = 'c:\temp'
  end
  object Button1: TButton
    Left = 80
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Consulta'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 224
    Top = 184
    Width = 169
    Height = 21
    TabOrder = 2
    Text = '900000'
  end
  object OpenDialog1: TOpenDialog
    Left = 656
    Top = 176
  end
end
