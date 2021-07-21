object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Gnbat Apurador V 1.0 16/02/2018'
  ClientHeight = 444
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
  object Label3: TLabel
    Left = 32
    Top = 24
    Width = 47
    Height = 13
    Caption = 'Arquivo : '
  end
  object Label1: TLabel
    Left = 32
    Top = 80
    Width = 43
    Height = 13
    Caption = 'Campo1:'
  end
  object Label2: TLabel
    Left = 248
    Top = 80
    Width = 8
    Height = 13
    Caption = '='
  end
  object Label4: TLabel
    Left = 32
    Top = 120
    Width = 43
    Height = 13
    Caption = 'Campo2:'
  end
  object Label5: TLabel
    Left = 248
    Top = 120
    Width = 8
    Height = 13
    Caption = '='
  end
  object Label6: TLabel
    Left = 32
    Top = 160
    Width = 43
    Height = 13
    Caption = 'Campo3:'
  end
  object Label7: TLabel
    Left = 248
    Top = 160
    Width = 8
    Height = 13
    Caption = '='
  end
  object Label9: TLabel
    Left = 32
    Top = 288
    Width = 35
    Height = 13
    Caption = 'D'#233'bito:'
  end
  object Label10: TLabel
    Left = 32
    Top = 328
    Width = 39
    Height = 13
    Caption = 'Cr'#233'dito:'
  end
  object Label8: TLabel
    Left = 280
    Top = 288
    Width = 24
    Height = 13
    Caption = 'Total'
  end
  object Label11: TLabel
    Left = 280
    Top = 331
    Width = 24
    Height = 13
    Caption = 'Total'
  end
  object Label12: TLabel
    Left = 280
    Top = 371
    Width = 16
    Height = 13
    Caption = '<>'
  end
  object ButtonJuntar: TButton
    Left = 32
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Somar'
    TabOrder = 0
    OnClick = ButtonJuntarClick
  end
  object Button2: TButton
    Left = 534
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 1
    OnClick = Button2Click
  end
  object EditNomeArq: TEdit
    Left = 85
    Top = 21
    Width = 524
    Height = 21
    TabOrder = 2
    OnDblClick = EditNomeArqDblClick
  end
  object ComboBox1: TComboBox
    Left = 85
    Top = 77
    Width = 145
    Height = 21
    TabOrder = 3
    OnSelect = ComboBox1Select
  end
  object ComboBox2: TComboBox
    Left = 272
    Top = 77
    Width = 145
    Height = 21
    TabOrder = 4
  end
  object ComboBox3: TComboBox
    Left = 85
    Top = 117
    Width = 145
    Height = 21
    TabOrder = 5
    OnSelect = ComboBox3Select
  end
  object ComboBox4: TComboBox
    Left = 272
    Top = 117
    Width = 145
    Height = 21
    TabOrder = 6
  end
  object ComboBox5: TComboBox
    Left = 85
    Top = 157
    Width = 145
    Height = 21
    TabOrder = 7
    OnSelect = ComboBox5Select
  end
  object ComboBox6: TComboBox
    Left = 85
    Top = 184
    Width = 145
    Height = 21
    TabOrder = 8
    Visible = False
  end
  object ListBox1: TListBox
    Left = 272
    Top = 157
    Width = 337
    Height = 101
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 9
  end
  object ComboBox7: TComboBox
    Left = 85
    Top = 285
    Width = 145
    Height = 21
    TabOrder = 10
  end
  object ComboBox8: TComboBox
    Left = 85
    Top = 325
    Width = 145
    Height = 21
    TabOrder = 11
  end
  object Edit1: TEdit
    Left = 328
    Top = 285
    Width = 281
    Height = 21
    TabOrder = 12
  end
  object Edit2: TEdit
    Left = 328
    Top = 328
    Width = 281
    Height = 21
    TabOrder = 13
  end
  object Edit3: TEdit
    Left = 328
    Top = 368
    Width = 281
    Height = 21
    TabOrder = 14
  end
  object OpenDialog1: TOpenDialog
    Left = 576
    Top = 56
  end
end
