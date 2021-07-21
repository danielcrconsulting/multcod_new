object fGrupoRelNovo: TfGrupoRelNovo
  Left = 343
  Top = 219
  Caption = 'Relacionamento de grupo de usu'#225'rios por relat'#243'rios'
  ClientHeight = 459
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton2: TSpeedButton
    Left = 571
    Top = 424
    Width = 23
    Height = 25
    Hint = 'Sair'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
      03333377777777777F333301BBBBBBBB033333773F3333337F3333011BBBBBBB
      0333337F73F333337F33330111BBBBBB0333337F373F33337F333301110BBBBB
      0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
      0333337F337F33337F333301110BBBBB0333337F337F33337F333301110BBBBB
      0333337F337F33337F333301110BBBBB0333337F337FF3337F33330111B0BBBB
      0333337F337733337F333301110BBBBB0333337F337F33337F333301110BBBBB
      0333337F3F7F33337F333301E10BBBBB0333337F7F7F33337F333301EE0BBBBB
      0333337F777FFFFF7F3333000000000003333377777777777333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton2Click
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 16
    Width = 577
    Height = 193
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 16
    Top = 224
    Width = 230
    Height = 25
    DataSource = DataSource1
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 256
    Width = 345
    Height = 193
    Caption = 'Filtros'
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 89
      Height = 13
      Caption = 'Grupo de relat'#243'rios'
    end
    object Label2: TLabel
      Left = 16
      Top = 80
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label3: TLabel
      Left = 16
      Top = 128
      Width = 32
      Height = 13
      Caption = 'Label3'
    end
    object Label4: TLabel
      Left = 176
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Label4'
    end
    object Label5: TLabel
      Left = 176
      Top = 80
      Width = 44
      Height = 13
      Caption = 'CODREL'
    end
    object Label6: TLabel
      Left = 176
      Top = 128
      Width = 25
      Height = 13
      Caption = 'TIPO'
    end
    object ComboBox1: TComboBox
      Left = 16
      Top = 48
      Width = 145
      Height = 21
      TabOrder = 0
      Text = 'ComboBox1'
      OnChange = ComboBox1Change
    end
    object ComboBox2: TComboBox
      Left = 16
      Top = 96
      Width = 145
      Height = 21
      TabOrder = 1
      Text = 'ComboBox2'
      OnChange = ComboBox1Change
    end
    object ComboBox3: TComboBox
      Left = 16
      Top = 144
      Width = 145
      Height = 21
      TabOrder = 2
      Text = 'ComboBox3'
      OnChange = ComboBox1Change
    end
    object ComboBox4: TComboBox
      Left = 176
      Top = 48
      Width = 145
      Height = 21
      TabOrder = 3
      Text = 'ComboBox4'
      OnChange = ComboBox1Change
    end
    object ComboBox5: TComboBox
      Left = 176
      Top = 96
      Width = 145
      Height = 21
      TabOrder = 4
      Text = 'ComboBox5'
      OnChange = ComboBox1Change
    end
    object ComboBox6: TComboBox
      Left = 176
      Top = 144
      Width = 145
      Height = 21
      TabOrder = 5
      Text = 'ComboBox6'
      OnChange = ComboBox1Change
    end
  end
  object ListBox1: TListBox
    Left = 376
    Top = 216
    Width = 145
    Height = 17
    ItemHeight = 13
    TabOrder = 3
    Visible = False
  end
  object GroupBox2: TGroupBox
    Left = 304
    Top = 216
    Width = 65
    Height = 25
    Caption = 'Relat'#243'rios'
    TabOrder = 4
    Visible = False
    object Label7: TLabel
      Left = 16
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Label7'
    end
    object Label8: TLabel
      Left = 16
      Top = 72
      Width = 32
      Height = 13
      Caption = 'Label8'
    end
    object Label9: TLabel
      Left = 16
      Top = 120
      Width = 32
      Height = 13
      Caption = 'Label9'
    end
    object ComboBox7: TComboBox
      Left = 16
      Top = 40
      Width = 145
      Height = 21
      TabOrder = 0
      Text = 'ComboBox7'
      OnChange = ComboBox7Change
    end
    object ComboBox8: TComboBox
      Left = 16
      Top = 88
      Width = 145
      Height = 21
      TabOrder = 1
      Text = 'ComboBox8'
      OnChange = ComboBox7Change
    end
    object ComboBox9: TComboBox
      Left = 16
      Top = 136
      Width = 145
      Height = 21
      TabOrder = 2
      Text = 'ComboBox9'
      OnChange = ComboBox7Change
    end
  end
  object DataSource1: TDataSource
    DataSet = repositorioDeDados.qGrupoRelNovo
    Left = 264
    Top = 224
  end
end
