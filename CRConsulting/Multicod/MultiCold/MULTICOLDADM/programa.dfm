object fConfiguracao: TfConfiguracao
  Left = 275
  Top = 176
  Caption = 'Configura'#231#245'es dos programas'
  ClientHeight = 413
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel2: TPanel
    Left = 0
    Top = 372
    Width = 455
    Height = 41
    Align = alBottom
    TabOrder = 0
    object SpeedButton8: TSpeedButton
      Left = 414
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
      OnClick = SpeedButton8Click
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
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 455
    Height = 372
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Programas'
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 97
        Height = 14
        Caption = '&Programa indexador'
        FocusControl = Edit1
      end
      object Label2: TLabel
        Left = 8
        Top = 64
        Width = 86
        Height = 14
        Caption = 'P&rograma filtrador'
        FocusControl = Edit2
      end
      object Label3: TLabel
        Left = 8
        Top = 112
        Width = 174
        Height = 14
        Caption = '&Diret'#243'rio de trabalho (at'#233' ..\ORIGEM)'
        FocusControl = Edit3
      end
      object SpeedButton1: TSpeedButton
        Left = 368
        Top = 128
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton1Click
      end
      object Edit1: TEdit
        Left = 8
        Top = 32
        Width = 201
        Height = 22
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 8
        Top = 80
        Width = 201
        Height = 22
        TabOrder = 1
      end
      object Edit3: TEdit
        Left = 8
        Top = 128
        Width = 361
        Height = 22
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Filtro'
      ImageIndex = 1
      object Label4: TLabel
        Left = 8
        Top = 16
        Width = 95
        Height = 14
        Caption = 'Diret'#243'rio de &entrada'
        FocusControl = Edit4
      end
      object SpeedButton2: TSpeedButton
        Left = 368
        Top = 32
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton2Click
      end
      object Label5: TLabel
        Left = 8
        Top = 64
        Width = 84
        Height = 14
        Caption = 'Diret'#243'rio de &sa'#237'da'
        FocusControl = Edit5
      end
      object SpeedButton3: TSpeedButton
        Left = 368
        Top = 80
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton3Click
      end
      object Edit4: TEdit
        Left = 8
        Top = 32
        Width = 361
        Height = 22
        TabOrder = 0
      end
      object Edit5: TEdit
        Left = 8
        Top = 80
        Width = 361
        Height = 22
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Mapa de caracteres'
      ImageIndex = 2
      object StringGrid1: TStringGrid
        Left = 0
        Top = 0
        Width = 447
        Height = 343
        Align = alClient
        DefaultColWidth = 125
        RowCount = 257
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 0
        OnSelectCell = StringGrid1SelectCell
        OnSetEditText = StringGrid1SetEditText
        ColWidths = (
          12
          64
          71
          77
          64)
        RowHeights = (
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24)
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Processamento'
      ImageIndex = 3
      object Label6: TLabel
        Left = 8
        Top = 32
        Width = 93
        Height = 14
        Caption = 'Diret'#243'rio do b&ackup'
        Enabled = False
        FocusControl = Edit6
      end
      object SpeedButton4: TSpeedButton
        Left = 368
        Top = 48
        Width = 23
        Height = 22
        Caption = '...'
        Enabled = False
        OnClick = SpeedButton4Click
      end
      object Label7: TLabel
        Left = 8
        Top = 128
        Width = 200
        Height = 14
        Caption = '&Intervalo entre as execu'#231#245'es (segundos)'
        Enabled = False
        FocusControl = Edit7
      end
      object Label8: TLabel
        Left = 8
        Top = 200
        Width = 285
        Height = 14
        Caption = '&Formato da extens'#227'o autom'#225'tica (ex.: YYMMDD_HHMMSS)'
        Enabled = False
        FocusControl = Edit8
      end
      object Label9: TLabel
        Left = 8
        Top = 272
        Width = 154
        Height = 14
        Caption = 'Decimal do caractere de &quebra'
        Enabled = False
        FocusControl = Edit9
      end
      object Label10: TLabel
        Left = 192
        Top = 272
        Width = 150
        Height = 14
        Caption = 'Coluna do caractere de q&uebra'
        Enabled = False
        FocusControl = Edit10
      end
      object CheckBox1: TCheckBox
        Left = 8
        Top = 8
        Width = 153
        Height = 17
        Caption = 'Utilizar &backup autom'#225'tico'
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit6: TEdit
        Left = 8
        Top = 48
        Width = 361
        Height = 22
        Enabled = False
        TabOrder = 1
      end
      object CheckBox2: TCheckBox
        Left = 8
        Top = 72
        Width = 97
        Height = 17
        Caption = '&Remover S1'
        Enabled = False
        TabOrder = 2
      end
      object CheckBox3: TCheckBox
        Left = 8
        Top = 104
        Width = 169
        Height = 17
        Caption = 'Utilizar &execu'#231#227'o autom'#225'tica'
        TabOrder = 3
        OnClick = CheckBox3Click
      end
      object Edit7: TEdit
        Left = 8
        Top = 144
        Width = 361
        Height = 22
        Enabled = False
        TabOrder = 4
      end
      object CheckBox4: TCheckBox
        Left = 8
        Top = 176
        Width = 169
        Height = 17
        Caption = 'Utilizar e&xten'#231#227'o autom'#225'tica'
        TabOrder = 5
        OnClick = CheckBox4Click
      end
      object Edit8: TEdit
        Left = 8
        Top = 216
        Width = 361
        Height = 22
        Enabled = False
        TabOrder = 6
      end
      object CheckBox5: TCheckBox
        Left = 8
        Top = 248
        Width = 169
        Height = 17
        Caption = 'Utilizar &separa'#231#227'o autom'#225'tica'
        TabOrder = 7
        OnClick = CheckBox5Click
      end
      object Edit9: TEdit
        Left = 8
        Top = 288
        Width = 177
        Height = 22
        Enabled = False
        TabOrder = 8
      end
      object Edit10: TEdit
        Left = 192
        Top = 288
        Width = 177
        Height = 22
        Enabled = False
        TabOrder = 9
      end
      object CheckBox6: TCheckBox
        Left = 8
        Top = 312
        Width = 265
        Height = 17
        Caption = 'Remover caractere indicador de quebra de p'#225'gina'
        Enabled = False
        TabOrder = 10
        OnClick = CheckBox6Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Nomes'
      ImageIndex = 4
      object Label11: TLabel
        Left = 8
        Top = 64
        Width = 36
        Height = 14
        Caption = '&2'#186' n'#237'vel'
        FocusControl = Edit11
      end
      object Label12: TLabel
        Left = 8
        Top = 112
        Width = 36
        Height = 14
        Caption = '&3'#186' n'#237'vel'
        FocusControl = Edit12
      end
      object Label17: TLabel
        Left = 8
        Top = 16
        Width = 36
        Height = 14
        Caption = '&1'#186' n'#237'vel'
        FocusControl = Edit17
      end
      object Edit11: TEdit
        Left = 8
        Top = 80
        Width = 201
        Height = 22
        TabOrder = 1
      end
      object Edit12: TEdit
        Left = 8
        Top = 128
        Width = 201
        Height = 22
        TabOrder = 2
      end
      object Edit17: TEdit
        Left = 8
        Top = 32
        Width = 201
        Height = 22
        TabOrder = 0
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Limpeza'
      ImageIndex = 5
      object Label13: TLabel
        Left = 8
        Top = 8
        Width = 95
        Height = 14
        Caption = 'Diret'#243'rio de &entrada'
        FocusControl = Edit13
      end
      object SpeedButton5: TSpeedButton
        Left = 376
        Top = 24
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton5Click
      end
      object Label14: TLabel
        Left = 8
        Top = 56
        Width = 84
        Height = 14
        Caption = 'Diret'#243'rio de &sa'#237'da'
        FocusControl = Edit14
      end
      object SpeedButton6: TSpeedButton
        Left = 376
        Top = 72
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton6Click
      end
      object Label16: TLabel
        Left = 8
        Top = 104
        Width = 144
        Height = 14
        Caption = '&Data do corte (DD/MM/AAAA)'
      end
      object Edit13: TEdit
        Left = 8
        Top = 24
        Width = 361
        Height = 22
        TabOrder = 0
      end
      object Edit14: TEdit
        Left = 8
        Top = 72
        Width = 361
        Height = 22
        TabOrder = 1
      end
      object Edit16: TEdit
        Left = 8
        Top = 120
        Width = 121
        Height = 22
        TabOrder = 2
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'CD'
      ImageIndex = 6
      object Label15: TLabel
        Left = 8
        Top = 16
        Width = 104
        Height = 14
        Caption = 'Diret'#243'rio de &grava'#231#227'o'
        FocusControl = Edit15
      end
      object SpeedButton7: TSpeedButton
        Left = 368
        Top = 32
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton7Click
      end
      object Edit15: TEdit
        Left = 8
        Top = 32
        Width = 361
        Height = 22
        TabOrder = 0
      end
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 276
    Top = 264
  end
end
