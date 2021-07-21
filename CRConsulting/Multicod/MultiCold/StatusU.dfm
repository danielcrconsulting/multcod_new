object StatusForm: TStatusForm
  Left = 103
  Top = 101
  Width = 258
  Height = 480
  Caption = 'Status da pesquisa especial'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 16
    Top = 40
    Width = 121
    Height = 377
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    MultiSelect = True
    ParentFont = False
    TabOrder = 0
  end
  object SairBut: TButton
    Left = 152
    Top = 392
    Width = 75
    Height = 25
    Caption = '&Sair'
    ModalResult = 2
    TabOrder = 1
  end
end
