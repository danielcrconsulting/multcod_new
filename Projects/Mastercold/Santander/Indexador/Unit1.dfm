object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 
    'Indexador de PDFs Santander V1.3 01/12/2015 - CR Consulting Info' +
    'rm'#225'tica'
  ClientHeight = 431
  ClientWidth = 664
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 354
    Width = 65
    Height = 13
    Caption = 'Processando:'
  end
  object Label2: TLabel
    Left = 231
    Top = 354
    Width = 50
    Height = 13
    Caption = 'Arquivo(s)'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 649
    Height = 337
    ItemHeight = 13
    TabOrder = 0
  end
  object IndexButton: TButton
    Left = 8
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Indexar'
    TabOrder = 1
    OnClick = IndexButtonClick
  end
  object SairButton: TButton
    Left = 582
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 2
    OnClick = SairButtonClick
  end
  object Edit1: TEdit
    Left = 79
    Top = 351
    Width = 146
    Height = 21
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 312
    Top = 351
    Width = 345
    Height = 21
    TabOrder = 4
  end
  object AtuDataButton: TButton
    Left = 136
    Top = 392
    Width = 89
    Height = 25
    Caption = 'Atualizar Data'
    TabOrder = 5
    OnClick = AtuDataButtonClick
  end
  object Button1: TButton
    Left = 320
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 6
    Visible = False
    OnClick = Button1Click
  end
end
