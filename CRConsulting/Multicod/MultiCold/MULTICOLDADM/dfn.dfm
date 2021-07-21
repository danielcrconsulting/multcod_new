object fDfn: TfDfn
  Left = 386
  Top = 151
  BorderStyle = bsDialog
  Caption = 'DFN'
  ClientHeight = 481
  ClientWidth = 504
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
    Width = 504
    Height = 443
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 37
      Height = 13
      Caption = 'Sistema'
    end
    object Label2: TLabel
      Left = 176
      Top = 8
      Width = 29
      Height = 13
      Caption = 'Grupo'
    end
    object Label3: TLabel
      Left = 344
      Top = 8
      Width = 46
      Height = 13
      Caption = 'Subgrupo'
    end
    object Label4: TLabel
      Left = 8
      Top = 56
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object Label5: TLabel
      Left = 136
      Top = 56
      Width = 48
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object Label6: TLabel
      Left = 8
      Top = 96
      Width = 47
      Height = 13
      Caption = 'ID Coluna'
    end
    object Label7: TLabel
      Left = 72
      Top = 96
      Width = 40
      Height = 13
      Caption = 'ID Linha'
    end
    object Label8: TLabel
      Left = 128
      Top = 96
      Width = 41
      Height = 13
      Caption = 'ID String'
    end
    object Label9: TLabel
      Left = 256
      Top = 96
      Width = 56
      Height = 13
      Caption = 'ID Coluna 2'
    end
    object Label10: TLabel
      Left = 320
      Top = 96
      Width = 49
      Height = 13
      Caption = 'ID Linha 2'
    end
    object Label11: TLabel
      Left = 376
      Top = 96
      Width = 50
      Height = 13
      Caption = 'ID String 2'
    end
    object Label12: TLabel
      Left = 8
      Top = 184
      Width = 93
      Height = 13
      Caption = 'Diret'#243'rio de entrada'
    end
    object Label13: TLabel
      Left = 8
      Top = 136
      Width = 73
      Height = 13
      Caption = 'P'#225'ginas a pular'
    end
    object SpeedButton1: TSpeedButton
      Left = 472
      Top = 200
      Width = 20
      Height = 21
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Label18: TLabel
      Left = 8
      Top = 408
      Width = 39
      Height = 13
      Caption = 'Cria'#231#227'o:'
    end
    object Label19: TLabel
      Left = 64
      Top = 408
      Width = 121
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = '24/07/2004 19:04:00'
    end
    object Label20: TLabel
      Left = 8
      Top = 424
      Width = 48
      Height = 13
      Caption = 'Altera'#231#227'o:'
    end
    object Label21: TLabel
      Left = 64
      Top = 424
      Width = 121
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = '24/07/2004 19:04:00'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 24
      Width = 161
      Height = 21
      TabOrder = 0
      OnChange = ComboBox1Change
    end
    object ComboBox2: TComboBox
      Left = 176
      Top = 24
      Width = 161
      Height = 21
      TabOrder = 1
      OnChange = ComboBox2Change
    end
    object ComboBox3: TComboBox
      Left = 344
      Top = 24
      Width = 153
      Height = 21
      TabOrder = 2
    end
    object Edit1: TEdit
      Left = 8
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object Edit2: TEdit
      Left = 136
      Top = 72
      Width = 361
      Height = 21
      TabOrder = 4
    end
    object Edit3: TEdit
      Left = 8
      Top = 112
      Width = 57
      Height = 21
      TabOrder = 5
    end
    object Edit4: TEdit
      Left = 72
      Top = 112
      Width = 49
      Height = 21
      TabOrder = 6
    end
    object Edit5: TEdit
      Left = 128
      Top = 112
      Width = 121
      Height = 21
      TabOrder = 7
    end
    object Edit6: TEdit
      Left = 256
      Top = 112
      Width = 57
      Height = 21
      TabOrder = 8
    end
    object Edit7: TEdit
      Left = 320
      Top = 112
      Width = 49
      Height = 21
      TabOrder = 9
    end
    object Edit8: TEdit
      Left = 376
      Top = 112
      Width = 121
      Height = 21
      TabOrder = 10
    end
    object Edit9: TEdit
      Left = 8
      Top = 200
      Width = 457
      Height = 21
      TabOrder = 12
    end
    object Edit10: TEdit
      Left = 8
      Top = 152
      Width = 121
      Height = 21
      TabOrder = 11
    end
    object CheckBox1: TCheckBox
      Left = 160
      Top = 256
      Width = 97
      Height = 17
      Caption = 'Ativo'
      TabOrder = 17
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 232
      Width = 150
      Height = 17
      Caption = 'Filtrar caracteres inv'#225'lidos'
      TabOrder = 13
    end
    object CheckBox3: TCheckBox
      Left = 160
      Top = 232
      Width = 150
      Height = 17
      Caption = 'Comprimir brancos'
      TabOrder = 14
    end
    object CheckBox4: TCheckBox
      Left = 312
      Top = 232
      Width = 150
      Height = 17
      Caption = 'Jun'#231#227'o autom'#225'tica'
      TabOrder = 15
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 304
      Width = 169
      Height = 97
      Caption = 'Quebra de p'#225'gina'
      Ctl3D = True
      ItemIndex = 3
      Items.Strings = (
        '133 Colunas com C/C'
        '^L'
        'N'#250'mero de linhas'
        'String')
      ParentCtl3D = False
      TabOrder = 20
      OnClick = RadioGroup1Click
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 256
      Width = 150
      Height = 17
      Caption = 'Subdiret'#243'rio autom'#225'tico'
      TabOrder = 16
    end
    object CheckBox6: TCheckBox
      Left = 8
      Top = 280
      Width = 150
      Height = 17
      Caption = 'Grupo autom'#225'tico'
      TabOrder = 19
      OnClick = CheckBox6Click
    end
    object CheckBox7: TCheckBox
      Left = 296
      Top = 424
      Width = 97
      Height = 17
      Caption = 'Remover fonte'
      TabOrder = 21
    end
    object CheckBox9: TCheckBox
      Left = 392
      Top = 424
      Width = 105
      Height = 17
      Caption = 'Backup do fonte'
      TabOrder = 22
    end
    object CheckBox10: TCheckBox
      Left = 312
      Top = 256
      Width = 121
      Height = 17
      Caption = 'Sistema autom'#225'tico'
      TabOrder = 18
    end
    object Panel4: TPanel
      Left = 180
      Top = 308
      Width = 313
      Height = 89
      BevelOuter = bvNone
      Color = clGreen
      TabOrder = 24
      Visible = False
      object Label17: TLabel
        Left = 8
        Top = 44
        Width = 82
        Height = 13
        Caption = 'N'#250'mero de linhas'
      end
      object Edit17: TEdit
        Left = 8
        Top = 60
        Width = 49
        Height = 21
        TabOrder = 0
      end
    end
    object Panel5: TPanel
      Left = 172
      Top = 302
      Width = 314
      Height = 49
      BevelOuter = bvNone
      Color = clGray
      TabOrder = 25
      Visible = False
      object Label22: TLabel
        Left = 8
        Top = 8
        Width = 33
        Height = 13
        Caption = 'Coluna'
      end
      object Label23: TLabel
        Left = 56
        Top = 8
        Width = 26
        Height = 13
        Caption = 'Linha'
      end
      object Label24: TLabel
        Left = 104
        Top = 8
        Width = 45
        Height = 13
        Caption = 'Tamanho'
      end
      object Edit18: TEdit
        Left = 8
        Top = 20
        Width = 41
        Height = 21
        TabOrder = 0
      end
      object Edit19: TEdit
        Left = 56
        Top = 20
        Width = 41
        Height = 21
        TabOrder = 1
      end
      object Edit20: TEdit
        Left = 104
        Top = 20
        Width = 49
        Height = 21
        TabOrder = 2
      end
      object RadioGroup2: TRadioGroup
        Left = 160
        Top = 8
        Width = 97
        Height = 33
        Caption = 'Tipo'
        Columns = 2
        Items.Strings = (
          'Alfa'
          'Num')
        TabOrder = 3
      end
    end
    object Panel3: TPanel
      Left = 188
      Top = 316
      Width = 313
      Height = 89
      BevelOuter = bvNone
      Color = clOlive
      TabOrder = 23
      Visible = False
      object Label15: TLabel
        Left = 8
        Top = 12
        Width = 33
        Height = 13
        Caption = 'Coluna'
      end
      object Label16: TLabel
        Left = 62
        Top = 12
        Width = 27
        Height = 13
        Caption = 'String'
      end
      object Edit12: TEdit
        Left = 8
        Top = 28
        Width = 49
        Height = 21
        TabOrder = 0
      end
      object Edit15: TEdit
        Left = 8
        Top = 60
        Width = 49
        Height = 21
        TabOrder = 1
      end
      object Edit13: TEdit
        Left = 64
        Top = 28
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object Edit16: TEdit
        Left = 64
        Top = 60
        Width = 121
        Height = 21
        TabOrder = 3
      end
      object CheckBox8: TCheckBox
        Left = 192
        Top = 64
        Width = 97
        Height = 17
        Caption = 'Quebrar ap'#243's'
        TabOrder = 4
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 443
    Width = 504
    Height = 38
    Align = alBottom
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 470
      Top = 8
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
    object BitBtn3: TBitBtn
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Apagar'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333FFFFF333333000033333388888833333333333F888888FFF333
        000033338811111188333333338833FFF388FF33000033381119999111833333
        38F338888F338FF30000339119933331111833338F388333383338F300003391
        13333381111833338F8F3333833F38F3000039118333381119118338F38F3338
        33F8F38F000039183333811193918338F8F333833F838F8F0000391833381119
        33918338F8F33833F8338F8F000039183381119333918338F8F3833F83338F8F
        000039183811193333918338F8F833F83333838F000039118111933339118338
        F3833F83333833830000339111193333391833338F33F8333FF838F300003391
        11833338111833338F338FFFF883F83300003339111888811183333338FF3888
        83FF83330000333399111111993333333388FFFFFF8833330000333333999999
        3333333333338888883333330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BitBtn3Click
    end
    object BitBtn2: TBitBtn
      Left = 272
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
      TabOrder = 2
      OnClick = BitBtn2Click
    end
    object BitBtn4: TBitBtn
      Left = 88
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Sa&lvar como'
      Glyph.Data = {
        F2010000424DF201000000000000760000002800000024000000130000000100
        0400000000007C01000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
        3333333333388F3333333333000033334224333333333333338338F333333333
        0000333422224333333333333833338F33333333000033422222243333333333
        83333338F3333333000034222A22224333333338F33F33338F33333300003222
        A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
        38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
        2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
        0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
        333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
        33333A2224A2233333333338F338F83300003333333333A2224A333333333333
        8F338F33000033333333333A222433333333333338F338F30000333333333333
        A224333333333333338F38F300003333333333333A223333333333333338F8F3
        000033333333333333A3333333333333333383330000}
      NumGlyphs = 2
      TabOrder = 3
      OnClick = BitBtn4Click
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoCreatePrompt]
    Left = 440
    Top = 296
  end
end
