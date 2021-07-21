object Especial: TEspecial
  Left = 244
  Top = 179
  Width = 717
  Height = 511
  Caption = 'Montar Pesquisa Especial'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 304
    Top = 408
    Width = 37
    Height = 13
    Caption = #205'ndices:'
  end
  object Label2: TLabel
    Left = 304
    Top = 432
    Width = 44
    Height = 13
    Caption = 'Arquivos:'
  end
  object Label3: TLabel
    Left = 8
    Top = 392
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object AbrBut: TButton
    Left = 96
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 1
    OnClick = AbrButClick
  end
  object SalvarBut: TButton
    Left = 184
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = SalvarButClick
  end
  object LimparBut: TButton
    Left = 8
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Limpar'
    TabOrder = 0
    OnClick = LimparButClick
  end
  object FecharBut: TButton
    Left = 600
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Fechar'
    ModalResult = 2
    TabOrder = 6
    OnClick = FecharButClick
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 665
    Height = 377
    ColCount = 4
    DefaultColWidth = 80
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowMoving, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 8
    OnDblClick = StringGrid1DblClick
  end
  object IndicesEdit: TEdit
    Left = 360
    Top = 400
    Width = 73
    Height = 21
    TabOrder = 3
  end
  object ArquivosEdit: TEdit
    Left = 360
    Top = 424
    Width = 73
    Height = 21
    TabOrder = 4
  end
  object DimensionarBut: TButton
    Left = 448
    Top = 420
    Width = 75
    Height = 25
    Caption = 'Dimensionar'
    Default = True
    TabOrder = 5
    OnClick = DimensionarButClick
  end
  object ExeBut: TButton
    Left = 8
    Top = 448
    Width = 75
    Height = 25
    Caption = 'Executar'
    TabOrder = 7
    OnClick = ExeButClick
  end
  object OpenDialog1: TOpenDialog
    Left = 536
    Top = 392
  end
  object SaveDialog1: TSaveDialog
    Left = 560
    Top = 392
  end
  object OpenDialog2: TOpenDialog
    Left = 536
    Top = 416
  end
end
