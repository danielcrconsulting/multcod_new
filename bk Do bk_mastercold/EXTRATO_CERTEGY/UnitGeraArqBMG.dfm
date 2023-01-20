object Form1: TForm1
  Left = 447
  Top = 201
  Width = 847
  Height = 600
  Caption = 
    'Gerador de Arquivo de Dados Financeiros Cart'#227'o BMG - 25/07/2012 ' +
    ' V2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 99
    Height = 13
    Caption = 'Diret'#243'rio a pesquisar:'
  end
  object Label2: TLabel
    Left = 16
    Top = 144
    Width = 236
    Height = 13
    Caption = 'Contas a pesquisar (deixar em branco para todas):'
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 77
    Height = 13
    Caption = 'Arquivo a Gerar:'
  end
  object Edit1: TEdit
    Left = 136
    Top = 32
    Width = 649
    Height = 21
    TabOrder = 0
    OnDblClick = Edit1DblClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 336
    Width = 769
    Height = 169
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object Button1: TButton
    Left = 16
    Top = 528
    Width = 137
    Height = 25
    Caption = 'Gera Dados Financeiros'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 760
    Top = 528
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 536
    Top = 528
    Width = 177
    Height = 25
    Caption = 'Gera Lista de Hist'#243'ricos'
    TabOrder = 7
    Visible = False
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 168
    Top = 528
    Width = 169
    Height = 25
    Caption = 'Gerar '#218'ltimos Saldos'
    TabOrder = 8
    Visible = False
    OnClick = Button4Click
  end
  object Edit2: TEdit
    Left = 136
    Top = 64
    Width = 649
    Height = 21
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 136
    Top = 104
    Width = 209
    Height = 17
    Caption = 'Gerar Arquivo Auxiliar com o Layout'
    TabOrder = 2
  end
  object StringGrid1: TStringGrid
    Left = 136
    Top = 168
    Width = 281
    Height = 120
    ColCount = 1
    DefaultColWidth = 256
    FixedCols = 0
    RowCount = 100
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 3
  end
end
