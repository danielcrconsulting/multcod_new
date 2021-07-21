object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 415
  ClientWidth = 795
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBarPrincipal: TScrollBar
    Left = 40
    Top = 57
    Width = 121
    Height = 17
    PageSize = 0
    TabOrder = 0
    OnScroll = ScrollBarPrincipalScroll
  end
  object Button1: TButton
    Left = 232
    Top = 32
    Width = 89
    Height = 25
    Caption = 'Abrir Relat'#243'rio'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 327
    Top = 32
    Width = 98
    Height = 25
    Caption = 'Fechar Relat'#243'rio'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 576
    Top = 34
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object Button3: TButton
    Left = 703
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Localizar'
    TabOrder = 4
    OnClick = Button3Click
  end
  object EdtQueryFacil: TEdit
    Left = 576
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object Button4: TButton
    Left = 703
    Top = 8
    Width = 75
    Height = 25
    Caption = 'QueryFacil'
    TabOrder = 6
    OnClick = Button4Click
  end
  object ScrollBarPesquisa: TScrollBar
    Left = 40
    Top = 22
    Width = 121
    Height = 17
    Enabled = False
    PageSize = 0
    TabOrder = 7
    OnScroll = ScrollBarPesquisaScroll
  end
  object Memo1: TRichEdit
    Left = 0
    Top = 96
    Width = 795
    Height = 319
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    Zoom = 100
  end
end
