object Form1: TForm1
  Left = 629
  Top = 160
  Caption = 'Programa Extrator de Dados'
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
    Left = 40
    Top = 112
    Width = 13
    Height = 13
    Caption = 'Xtr'
  end
  object Label2: TLabel
    Left = 40
    Top = 144
    Width = 42
    Height = 13
    Caption = 'Relat'#243'rio'
  end
  object Label3: TLabel
    Left = 40
    Top = 176
    Width = 27
    Height = 13
    Caption = 'Saida'
  end
  object Label4: TLabel
    Left = 40
    Top = 232
    Width = 48
    Height = 13
    Caption = 'Sem'#225'foro:'
  end
  object Button1: TButton
    Left = 40
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 184
    Top = 104
    Width = 369
    Height = 21
    TabOrder = 1
    Text = 'c:\coldcfg\teste.xtr'
    OnDblClick = Edit1DblClick
  end
  object Edit2: TEdit
    Left = 184
    Top = 136
    Width = 369
    Height = 21
    TabOrder = 2
    Text = 
      'C:\Rom\MultiCold\Destino\SIPCS\CAIXA ECONOMICA FEDERAL\SUP OPERA' +
      'CIONAL\PCSPB672\R141-DES_20130226_155007.dat'
    OnDblClick = Edit2DblClick
  end
  object Edit3: TEdit
    Left = 184
    Top = 168
    Width = 369
    Height = 21
    TabOrder = 3
    Text = 'c:\coldcfg\Teste1.txt'
  end
  object Edit4: TEdit
    Left = 184
    Top = 224
    Width = 369
    Height = 21
    TabOrder = 4
    Text = 'Edit4'
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.*|*.*'
    Left = 184
    Top = 32
  end
end
