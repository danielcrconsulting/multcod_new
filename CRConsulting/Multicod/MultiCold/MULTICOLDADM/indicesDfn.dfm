object fIndicesDfn: TfIndicesDfn
  Left = 1061
  Top = 317
  Caption = #205'ndices DFN'
  ClientHeight = 336
  ClientWidth = 356
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
    Width = 356
    Height = 296
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 42
      Height = 13
      Caption = 'Relat'#243'rio'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 78
      Height = 13
      Caption = 'Nome do campo'
    end
    object Label3: TLabel
      Left = 8
      Top = 104
      Width = 55
      Height = 13
      Caption = 'Linha inicial'
    end
    object Label4: TLabel
      Left = 88
      Top = 104
      Width = 48
      Height = 13
      Caption = 'Linha final'
    end
    object Label5: TLabel
      Left = 168
      Top = 104
      Width = 33
      Height = 13
      Caption = 'Coluna'
    end
    object Label6: TLabel
      Left = 248
      Top = 104
      Width = 45
      Height = 13
      Caption = 'Tamanho'
    end
    object Label7: TLabel
      Left = 8
      Top = 152
      Width = 110
      Height = 13
      Caption = 'Tratamento de brancos'
    end
    object Label8: TLabel
      Left = 160
      Top = 152
      Width = 71
      Height = 13
      Caption = 'Tipo de campo'
    end
    object Label9: TLabel
      Left = 8
      Top = 200
      Width = 41
      Height = 13
      Caption = 'M'#225'scara'
    end
    object Label10: TLabel
      Left = 120
      Top = 200
      Width = 103
      Height = 13
      Caption = 'Caractere de inclus'#227'o'
    end
    object Label11: TLabel
      Left = 232
      Top = 200
      Width = 106
      Height = 13
      Caption = 'Caractere de exclus'#227'o'
    end
    object Label12: TLabel
      Left = 8
      Top = 248
      Width = 84
      Height = 13
      Caption = 'String de inclus'#227'o'
    end
    object Label13: TLabel
      Left = 120
      Top = 248
      Width = 87
      Height = 13
      Caption = 'String de exclus'#227'o'
    end
    object Label14: TLabel
      Left = 232
      Top = 248
      Width = 29
      Height = 13
      Caption = 'Fus'#227'o'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 24
      Width = 329
      Height = 21
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 8
      Top = 72
      Width = 329
      Height = 21
      TabOrder = 1
    end
    object Edit2: TEdit
      Left = 8
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 2
    end
    object Edit3: TEdit
      Left = 88
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 3
    end
    object Edit4: TEdit
      Left = 168
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 4
    end
    object Edit5: TEdit
      Left = 248
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 5
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 168
      Width = 145
      Height = 21
      TabOrder = 6
      Items.Strings = (
        'Retira todos os brancos'
        'Retira brancos do fim'
        'Retira brancos do in'#237'cio'
        'Nenhum tratamento'
        'Retira brancos do in'#237'cio e do fim')
    end
    object ComboBox3: TComboBox
      Left = 160
      Top = 168
      Width = 145
      Height = 21
      TabOrder = 7
      Items.Strings = (
        'Caractere'
        'Data'
        'Decimal, com separador "."'
        'Decimal, com separador ","'
        'Num'#233'rico')
    end
    object Edit6: TEdit
      Left = 8
      Top = 216
      Width = 105
      Height = 21
      TabOrder = 8
    end
    object Edit7: TEdit
      Left = 120
      Top = 216
      Width = 105
      Height = 21
      TabOrder = 9
    end
    object Edit8: TEdit
      Left = 232
      Top = 216
      Width = 105
      Height = 21
      TabOrder = 10
    end
    object Edit10: TEdit
      Left = 120
      Top = 264
      Width = 105
      Height = 21
      TabOrder = 11
    end
    object Edit11: TEdit
      Left = 232
      Top = 264
      Width = 105
      Height = 21
      TabOrder = 12
    end
    object Edit9: TEdit
      Left = 8
      Top = 264
      Width = 105
      Height = 21
      TabOrder = 13
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 296
    Width = 356
    Height = 40
    Align = alBottom
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 318
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
      Left = 88
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
      Left = 168
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
  end
end
