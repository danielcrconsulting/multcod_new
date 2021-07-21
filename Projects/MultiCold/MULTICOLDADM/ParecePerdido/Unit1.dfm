object Form1: TForm1
  Left = 582
  Top = 359
  Caption = 'DFN'#39's com problema de cadastro'
  ClientHeight = 459
  ClientWidth = 703
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object ListBox1: TListBox
    Left = 10
    Top = 10
    Width = 671
    Height = 385
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 17
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 10
    Top = 414
    Width = 92
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Gerar lista'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 591
    Top = 414
    Width = 92
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Sair'
    TabOrder = 2
    OnClick = Button2Click
  end
end
