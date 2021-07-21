object ExecutarEspecial: TExecutarEspecial
  Left = 409
  Top = 284
  Caption = 'Executar Pesquisa Especial'
  ClientHeight = 290
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 99
    Height = 13
    Caption = 'Selecione o per'#237'odo:'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 24
    Width = 321
    Height = 233
    ItemHeight = 13
    Items.Strings = (
      'Lixo Proposital')
    MultiSelect = True
    TabOrder = 0
  end
  object ExportarBut: TButton
    Left = 256
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Exportar'
    TabOrder = 3
    OnClick = ExportarButClick
  end
  object AbrirBut: TButton
    Left = 176
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 2
    OnClick = AbrirButClick
  end
  object ImprimirBut: TButton
    Left = 96
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Imprimir'
    TabOrder = 1
    OnClick = ImprimirButClick
  end
end
