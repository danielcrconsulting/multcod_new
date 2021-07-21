object fRelUsuario: TfRelUsuario
  Left = 288
  Top = 225
  Caption = 'Relat'#243'rios de seguran'#231'a'
  ClientHeight = 387
  ClientWidth = 673
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 336
    Width = 673
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 236
    ExplicitWidth = 524
    object SpeedButton2: TSpeedButton
      Left = 620
      Top = 10
      Width = 29
      Height = 31
      Hint = 'Sair'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
    object BitBtn1: TBitBtn
      Left = 10
      Top = 10
      Width = 92
      Height = 31
      Hint = 'Exportar para Excel'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Exportar'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
        333333333333337FF3333333333333903333333333333377FF33333333333399
        03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
        99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
        99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
        03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
        33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
        33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
        3333777777333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 108
      Top = 10
      Width = 93
      Height = 31
      Hint = 'Imprimir relat'#243'rio'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Imprimir'
      Enabled = False
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
        8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
        8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
        8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 673
    Height = 336
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 524
    ExplicitHeight = 236
    object Label3: TLabel
      Left = 10
      Top = 79
      Width = 39
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Filtro 1'
    end
    object Label4: TLabel
      Left = 10
      Top = 98
      Width = 44
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Campo'
    end
    object Bevel1: TBevel
      Left = 10
      Top = 69
      Width = 640
      Height = 4
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object Label5: TLabel
      Left = 246
      Top = 98
      Width = 61
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Opera'#231#227'o'
    end
    object Label6: TLabel
      Left = 374
      Top = 98
      Width = 32
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Valor'
    end
    object Bevel3: TBevel
      Left = 7
      Top = 148
      Width = 640
      Height = 3
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object Label7: TLabel
      Left = 10
      Top = 158
      Width = 39
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Filtro 2'
    end
    object Label8: TLabel
      Left = 10
      Top = 177
      Width = 44
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Campo'
    end
    object Label9: TLabel
      Left = 246
      Top = 177
      Width = 61
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Opera'#231#227'o'
    end
    object Label10: TLabel
      Left = 374
      Top = 177
      Width = 32
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Valor'
    end
    object Bevel5: TBevel
      Left = 7
      Top = 226
      Width = 640
      Height = 4
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object Label11: TLabel
      Left = 10
      Top = 236
      Width = 39
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Filtro 3'
    end
    object Label12: TLabel
      Left = 10
      Top = 256
      Width = 44
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Campo'
    end
    object Label13: TLabel
      Left = 246
      Top = 256
      Width = 61
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Opera'#231#227'o'
    end
    object Label14: TLabel
      Left = 374
      Top = 256
      Width = 32
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Valor'
    end
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 174
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Tipos de relat'#243'rios poss'#237'veis'
    end
    object ComboBox3: TComboBox
      Left = 10
      Top = 118
      Width = 228
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 0
    end
    object ComboBox4: TComboBox
      Left = 246
      Top = 118
      Width = 120
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 1
      Items.Strings = (
        '='
        '<>'
        '>'
        '<'
        'IN'
        'NOT IN'
        'BETWEEN'
        'NOT BETWEEN'
        'LIKE'
        'NOT LIKE')
    end
    object Edit1: TEdit
      Left = 374
      Top = 118
      Width = 267
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 2
    end
    object ComboBox5: TComboBox
      Left = 10
      Top = 197
      Width = 228
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 3
    end
    object ComboBox6: TComboBox
      Left = 246
      Top = 197
      Width = 120
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 4
      Items.Strings = (
        '='
        '<>'
        '>'
        '<'
        'IN'
        'NOT IN'
        'BETWEEN'
        'NOT BETWEEN'
        'LIKE'
        'NOT LIKE')
    end
    object Edit2: TEdit
      Left = 374
      Top = 197
      Width = 267
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 5
    end
    object ComboBox7: TComboBox
      Left = 10
      Top = 276
      Width = 228
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 6
    end
    object ComboBox8: TComboBox
      Left = 246
      Top = 276
      Width = 120
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 7
      Items.Strings = (
        '='
        '<>'
        '>'
        '<'
        'IN'
        'NOT IN'
        'BETWEEN'
        'NOT BETWEEN'
        'LIKE'
        'NOT LIKE')
    end
    object Edit3: TEdit
      Left = 374
      Top = 276
      Width = 267
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      TabOrder = 8
    end
    object ComboBox1: TComboBox
      Left = 10
      Top = 30
      Width = 631
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 9
      OnChange = ComboBox1Change
      Items.Strings = (
        'Grupos de usu'#225'rios por relat'#243'rios'
        'Grupos de usu'#225'rios'
        'Usu'#225'rios'
        'Usu'#225'rios por relat'#243'rios')
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    FileName = '*.csv'
    Filter = '*.csv|Arquivos para o Excel'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Exportar par Excel'
    Left = 424
    Top = 8
  end
end
