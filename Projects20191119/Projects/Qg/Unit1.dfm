object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Teste de tempo de grava'#231#227'o de PDFs'
  ClientHeight = 299
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
    Left = 32
    Top = 59
    Width = 53
    Height = 13
    Caption = 'Hora Inicial'
  end
  object Label2: TLabel
    Left = 32
    Top = 96
    Width = 96
    Height = 13
    Caption = 'Tempo a Cada 1000'
  end
  object Label3: TLabel
    Left = 32
    Top = 136
    Width = 59
    Height = 13
    Caption = 'Tempo Total'
  end
  object Label4: TLabel
    Left = 32
    Top = 171
    Width = 70
    Height = 13
    Caption = 'Pdfs Gravados'
  end
  object Label5: TLabel
    Left = 32
    Top = 16
    Width = 140
    Height = 13
    Caption = 'Quantidade de Pdfs a Gravar'
  end
  object Label6: TLabel
    Left = 32
    Top = 216
    Width = 28
    Height = 13
    Caption = 'M'#233'dia'
  end
  object Sair: TButton
    Left = 544
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 0
    OnClick = SairClick
  end
  object Ok: TButton
    Left = 32
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = OkClick
  end
  object Edit1: TEdit
    Left = 144
    Top = 168
    Width = 465
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 144
    Top = 93
    Width = 465
    Height = 21
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 144
    Top = 56
    Width = 465
    Height = 21
    TabOrder = 4
  end
  object Edit4: TEdit
    Left = 144
    Top = 133
    Width = 465
    Height = 21
    TabOrder = 5
  end
  object Edit5: TEdit
    Left = 216
    Top = 8
    Width = 393
    Height = 21
    TabOrder = 6
  end
  object Edit6: TEdit
    Left = 144
    Top = 213
    Width = 465
    Height = 21
    TabOrder = 7
  end
end
