object AssisAbreForm: TAssisAbreForm
  Left = 92
  Top = 106
  Width = 800
  Height = 486
  Align = alBottom
  BorderIcons = [biSystemMenu]
  Caption = 'Assistente de abertura de relatórios'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 360
    Top = 432
    Width = 193
    Height = 25
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = Button1Click
  end
  object Button1: TButton
    Left = 128
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Relatórios'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ListBox2: TListBox
    Left = 216
    Top = 8
    Width = 569
    Height = 417
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = Button2Click
  end
  object Button2: TButton
    Left = 608
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 712
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 4
    OnClick = Button3Click
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 8
    Width = 193
    Height = 417
    HideSelection = False
    Indent = 19
    TabOrder = 5
    OnDblClick = Button1Click
  end
  object Table1: TTable
    Left = 216
    Top = 432
  end
end
