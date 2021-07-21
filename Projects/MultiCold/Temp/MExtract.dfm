object FrmExtract: TFrmExtract
  Left = 312
  Top = 104
  Width = 800
  Height = 600
  Caption = 'Extrator de Dados'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    792
    573)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 166
    Width = 63
    Height = 13
    Caption = 'P'#225'gina Inicial'
  end
  object Label2: TLabel
    Left = 135
    Top = 166
    Width = 55
    Height = 13
    Caption = 'P'#225'gina final'
  end
  object Label3: TLabel
    Left = 7
    Top = 54
    Width = 84
    Height = 13
    Caption = 'Regras de p'#225'gina'
  end
  object Label4: TLabel
    Left = 399
    Top = 166
    Width = 55
    Height = 13
    Caption = 'Linha inicial'
  end
  object Label5: TLabel
    Left = 527
    Top = 166
    Width = 48
    Height = 13
    Caption = 'Linha final'
  end
  object Label6: TLabel
    Left = 399
    Top = 54
    Width = 74
    Height = 13
    Caption = 'Regras de linha'
  end
  object Label7: TLabel
    Left = 7
    Top = 214
    Width = 38
    Height = 13
    Caption = 'Campos'
  end
  object Label8: TLabel
    Left = 7
    Top = 358
    Width = 89
    Height = 13
    Caption = 'Regras de campos'
  end
  object Label9: TLabel
    Left = 7
    Top = 6
    Width = 48
    Height = 13
    Caption = 'Descri'#231#227'o'
  end
  object Edit1: TEdit
    Left = 7
    Top = 182
    Width = 121
    Height = 21
    TabOrder = 2
    OnDblClick = Edit1DblClick
  end
  object Edit2: TEdit
    Left = 135
    Top = 182
    Width = 121
    Height = 21
    TabOrder = 3
    OnDblClick = Edit2DblClick
  end
  object StringGrid1: TStringGrid
    Left = 7
    Top = 70
    Width = 377
    Height = 89
    ColCount = 2
    FixedCols = 0
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowMoving, goEditing, goTabs, goRowSelect, goThumbTracking]
    TabOrder = 1
    OnDblClick = StringGrid1DblClick
    ColWidths = (
      64
      285)
  end
  object Edit3: TEdit
    Left = 399
    Top = 182
    Width = 121
    Height = 21
    TabOrder = 5
    OnDblClick = Edit3DblClick
  end
  object Edit4: TEdit
    Left = 527
    Top = 182
    Width = 121
    Height = 21
    TabOrder = 6
    OnDblClick = Edit4DblClick
  end
  object StringGrid2: TStringGrid
    Left = 399
    Top = 70
    Width = 386
    Height = 89
    Anchors = [akLeft, akTop, akRight]
    ColCount = 3
    FixedCols = 0
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowMoving, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 4
    OnDblClick = StringGrid2DblClick
    ColWidths = (
      172
      89
      85)
  end
  object StringGrid3: TStringGrid
    Left = 7
    Top = 230
    Width = 778
    Height = 120
    Anchors = [akLeft, akTop, akRight]
    ColCount = 11
    DefaultColWidth = 30
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowMoving, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 7
    OnDblClick = StringGrid3DblClick
    ColWidths = (
      30
      130
      74
      77
      78
      74
      74
      74
      85
      140
      133)
  end
  object StringGrid4: TStringGrid
    Left = 7
    Top = 374
    Width = 778
    Height = 97
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 4
    DefaultColWidth = 30
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowMoving, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 8
    OnDblClick = StringGrid4DblClick
    ColWidths = (
      30
      120
      140
      278)
  end
  object AbrirButton: TButton
    Left = 384
    Top = 535
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Abrir'
    TabOrder = 13
    OnClick = AbrirButtonClick
  end
  object SalvarButton: TButton
    Left = 464
    Top = 535
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Salvar'
    TabOrder = 14
    OnClick = SalvarButtonClick
  end
  object LimparButton: TButton
    Left = 544
    Top = 535
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Limpar'
    TabOrder = 15
    OnClick = LimparButtonClick
  end
  object ExecutarButton: TButton
    Left = 624
    Top = 535
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Executar'
    TabOrder = 16
    OnClick = ExecutarButtonClick
  end
  object SairButton: TButton
    Left = 704
    Top = 535
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Sai&r'
    TabOrder = 17
    OnClick = SairButtonClick
  end
  object StrPagina: TMemo
    Left = 512
    Top = 480
    Width = 89
    Height = 25
    Lines.Strings = (
      'StrPagina')
    ScrollBars = ssBoth
    TabOrder = 18
    Visible = False
  end
  object Edit5: TEdit
    Left = 7
    Top = 22
    Width = 778
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnDblClick = Edit5DblClick
  end
  object CheckBox1: TCheckBox
    Left = 7
    Top = 479
    Width = 73
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Cabe'#231'alho'
    TabOrder = 9
  end
  object CheckBox2: TCheckBox
    Left = 103
    Top = 481
    Width = 129
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Separador de Campos'
    TabOrder = 10
    OnClick = CheckBox2Click
  end
  object Edit6: TEdit
    Left = 119
    Top = 503
    Width = 121
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 11
    Visible = False
  end
  object CheckBox3: TCheckBox
    Left = 247
    Top = 479
    Width = 153
    Height = 17
    Hint = 'Gera um '#250'nico registro com todos os dados extra'#237'dos da p'#225'gina'
    Anchors = [akLeft, akBottom]
    Caption = 'Extrair p'#225'gina para colunas'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
  end
  object ProgressBar1: TProgressBar
    Left = 623
    Top = 479
    Width = 159
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 19
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'xtr'
    Filter = '*.xtr|*.xtr'
    Left = 408
    Top = 472
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'xtr'
    Filter = '*.xtr|*.xtr'
    Left = 448
    Top = 472
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = 'txt'
    Filter = '*.txt|*.txt'
    Left = 488
    Top = 472
  end
end
