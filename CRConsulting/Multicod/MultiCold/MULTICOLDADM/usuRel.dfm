object fUsuRel: TfUsuRel
  Left = 186
  Top = 136
  BorderStyle = bsDialog
  Caption = 'Relacionamento de usu'#225'rios por relat'#243'rios'
  ClientHeight = 431
  ClientWidth = 694
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 694
    Height = 390
    Align = alClient
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 37
      Height = 13
      Caption = 'Sistema'
    end
    object Label1: TLabel
      Left = 8
      Top = 56
      Width = 89
      Height = 13
      Caption = 'Grupo de relat'#243'rios'
    end
    object Label3: TLabel
      Left = 8
      Top = 104
      Width = 111
      Height = 13
      Caption = 'Subgrupos de relat'#243'rios'
    end
    object Label5: TLabel
      Left = 8
      Top = 152
      Width = 97
      Height = 13
      Caption = 'Relat'#243'rios permitidos'
    end
    object SpeedButton1: TSpeedButton
      Left = 218
      Top = 216
      Width = 23
      Height = 22
      Caption = '>'
      OnClick = SpeedButton1Click
    end
    object SpeedButton3: TSpeedButton
      Left = 218
      Top = 248
      Width = 23
      Height = 22
      Caption = '>>'
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 218
      Top = 280
      Width = 23
      Height = 22
      Caption = '<'
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 218
      Top = 312
      Width = 23
      Height = 22
      Caption = '<<'
      OnClick = SpeedButton5Click
    end
    object Label6: TLabel
      Left = 248
      Top = 152
      Width = 104
      Height = 13
      Caption = 'Relat'#243'rios dispon'#237'veis'
    end
    object Label4: TLabel
      Left = 304
      Top = 8
      Width = 85
      Height = 13
      Caption = 'C'#243'digo do usu'#225'rio'
    end
    object Label8: TLabel
      Left = 480
      Top = 152
      Width = 91
      Height = 13
      Caption = 'Relat'#243'rios negados'
    end
    object SpeedButton6: TSpeedButton
      Left = 450
      Top = 216
      Width = 23
      Height = 22
      Caption = '>'
      OnClick = SpeedButton6Click
    end
    object SpeedButton7: TSpeedButton
      Left = 450
      Top = 248
      Width = 23
      Height = 22
      Caption = '>>'
      OnClick = SpeedButton7Click
    end
    object SpeedButton8: TSpeedButton
      Left = 450
      Top = 280
      Width = 23
      Height = 22
      Caption = '<'
      OnClick = SpeedButton8Click
    end
    object SpeedButton9: TSpeedButton
      Left = 450
      Top = 312
      Width = 23
      Height = 22
      Caption = '<<'
      OnClick = SpeedButton9Click
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 24
      Width = 289
      Height = 21
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object ComboBox3: TComboBox
      Left = 8
      Top = 120
      Width = 289
      Height = 21
      TabOrder = 2
      OnChange = ComboBox3Change
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 72
      Width = 289
      Height = 21
      TabOrder = 1
      OnChange = ComboBox2Change
    end
    object ListBox1: TListBox
      Left = 8
      Top = 168
      Width = 200
      Height = 209
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 4
    end
    object ListBox2: TListBox
      Left = 246
      Top = 168
      Width = 200
      Height = 209
      ItemHeight = 13
      MultiSelect = True
      Sorted = True
      TabOrder = 5
    end
    object ListBox3: TListBox
      Left = 303
      Top = 25
      Width = 377
      Height = 121
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 3
      OnClick = ListBox3Click
    end
    object ListBox4: TListBox
      Left = 480
      Top = 168
      Width = 200
      Height = 209
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 6
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 390
    Width = 694
    Height = 41
    Align = alBottom
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 657
      Top = 7
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
    object BitBtn1: TBitBtn
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Salvar'
      Default = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 168
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Avan'#231'ado'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003FF0000000F0
        000033F77777773777773FFF0CCC0FF09990333F73F37337F33733FFF0C0FFF0
        99903333F7373337F337333FFF0FFFF0999033333F73FFF7FFF73333FFF000F0
        0000333333F77737777733333F07B70FFFFF3333337F337F33333333330BBB0F
        FFFF3FFFFF7F337F333300000307B70FFFFF77777F73FF733F330EEE033000FF
        0FFF7F337FF777337FF30EEE00033FF000FF7F33777F333777FF0EEE0E033300
        000F7FFF7F7FFF77777F00000E00000000007777737773777777330EEE0E0330
        00FF337FFF7F7F3777F33300000E033000FF337777737F3777F333330EEE0330
        00FF33337FFF7FF77733333300000000033F3333777777777333}
      NumGlyphs = 2
      TabOrder = 2
      Visible = False
      OnClick = BitBtn3Click
    end
  end
end
