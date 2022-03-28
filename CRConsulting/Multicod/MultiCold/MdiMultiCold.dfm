object FrameForm: TFrameForm
  Left = 246
  Top = 159
  Caption = 'MultiCold - Viewer V10.0.0 - 08/03/2022'
  ClientHeight = 57
  ClientWidth = 144
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -2
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  Scaled = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 2
  object MemoAux: TMemo
    Left = 536
    Top = 56
    Width = 185
    Height = 33
    Lines.Strings = (
      'MemoAux')
    TabOrder = 0
    Visible = False
  end
  object FileListBox1QuePorraEhIsso: TFileListBox
    Left = 560
    Top = 240
    Width = 145
    Height = 97
    ItemHeight = 2
    Mask = 
      'C:\Rom\MultiCold\Destino\VISIONPLUS\BRADESCO\TELE-SAQUE\0REL\*.d' +
      'fn'
    TabOrder = 1
    Visible = False
  end
  object Memo1: TMemo
    Left = 40
    Top = 240
    Width = 449
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
    Visible = False
  end
  object SpeedPanel: TPanel
    Left = 0
    Top = 0
    Width = 144
    Height = 49
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object PlusZoom: TSpeedButton
      Left = 0
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Mais Zoom|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
        3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
        33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
        333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = PlusZoomClick
    end
    object LessZoom: TSpeedButton
      Left = 0
      Top = 24
      Width = 25
      Height = 25
      Hint = 'Menos Zoom|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        333333773337777333333078F8F87033333337F3333337F33333778F8F8F8773
        333337333333373F333307F8F8F8F70333337F33FFFFF37F3333078999998703
        33337F377777337F333307F8F8F8F703333373F3333333733333778F8F8F8773
        333337F3333337F333333078F8F870333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = LessZoomClick
    end
    object NormalZoom: TSpeedButton
      Left = 24
      Top = 24
      Width = 25
      Height = 25
      Hint = 'Normal|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = NormalZoomClick
    end
    object AbreQueryFacil: TSpeedButton
      Left = 48
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Montar Query de Pesquisa|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = AbreQueryFacilClick
    end
    object RepetePesquisa: TSpeedButton
      Left = 72
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Repete Pesquisa|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333FF33333333333330003FF3FFFFF3333777003000003333
        300077F777773F333777E00BFBFB033333337773333F7F33333FE0BFBF000333
        330077F3337773F33377E0FBFBFBF033330077F3333FF7FFF377E0BFBF000000
        333377F3337777773F3FE0FBFBFBFBFB039977F33FFFFFFF7377E0BF00000000
        339977FF777777773377000BFB03333333337773FF733333333F333000333333
        3300333777333333337733333333333333003333333333333377333333333333
        333333333333333333FF33333333333330003333333333333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = RepetePesquisaClick
    end
    object Label5: TLabel
      Left = 224
      Top = 0
      Width = 8
      Height = 2
      Caption = 'Pesquisa:'
    end
    object Label1: TLabel
      Left = 224
      Top = 32
      Width = 5
      Height = 2
      Caption = 'Label1'
      Color = clYellow
      ParentColor = False
    end
    object Label7: TLabel
      Left = 384
      Top = 0
      Width = 8
      Height = 2
      Caption = 'P'#225'gina : '
    end
    object AbreRelBut: TSpeedButton
      Left = 24
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Abrir Relat'#243'rio|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
      OnClick = AbreRelButClick
    end
    object Imprimir: TSpeedButton
      Left = 48
      Top = 24
      Width = 25
      Height = 25
      Hint = 'Imprimir Relat'#243'rio|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
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
      OnClick = ImprimirClick
    end
    object Descompactar: TSpeedButton
      Left = 72
      Top = 24
      Width = 25
      Height = 25
      Hint = 'Descompactar|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330B7FFF
        FFB0333333777F3333773333330B7FFFFFB0333333777F3333773333330B7FFF
        FFB0333333777F3333773333330B7FFFFFB03FFFFF777FFFFF77000000000077
        007077777777777777770FFFFFFFF00077B07F33333337FFFF770FFFFFFFF000
        7BB07F3FF3FFF77FF7770F00F000F00090077F77377737777F770FFFFFFFF039
        99337F3FFFF3F7F777FF0F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      OnClick = DescompactarClick
    end
    object ExportarSpeedButton: TSpeedButton
      Left = 96
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Montar Template de Exporta'#231#227'o|'
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
      OnClick = ExportarSpeedButtonClick
    end
    object Label3: TLabel
      Left = 600
      Top = 32
      Width = 5
      Height = 2
      Caption = 'Label3'
    end
    object ExtrairSpeedButton: TSpeedButton
      Left = 96
      Top = 24
      Width = 25
      Height = 25
      Hint = 'Montar Script de Exporta'#231#227'o|'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333330000000
        00003333377777777777333330FFFFFFFFF03FF3F7FFFF33FFF7003000000FF0
        00F077F7777773F77737E00FBFBFB0FFFFF07773333FF7FF33F7E0FBFB00000F
        F0F077F333777773F737E0BFBFBFBFB0FFF077F3333FFFF733F7E0FBFB00000F
        F0F077F333777773F737E0BFBFBFBFB0FFF077F33FFFFFF733F7E0FB0000000F
        F0F077FF777777733737000FB0FFFFFFFFF07773F7F333333337333000FFFFFF
        FFF0333777F3FFF33FF7333330F000FF0000333337F777337777333330FFFFFF
        0FF0333337FFFFFF7F37333330CCCCCC0F033333377777777F73333330FFFFFF
        0033333337FFFFFF773333333000000003333333377777777333}
      NumGlyphs = 2
      OnClick = ExtrairSpeedButtonClick
    end
    object EspecialSpeedButton: TSpeedButton
      Left = 144
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Pesquisa Especial'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        55555555FFFFFFFF5555555000000005555555577777777FF555550999999900
        55555575555555775F55509999999901055557F55555557F75F5001111111101
        105577FFFFFFFF7FF75F00000000000011057777777777775F755070FFFFFF0F
        01105777F555557F7FF75500FFFFFF0F00105577F555FF7F77575550FF70000F
        0F0055575FF777757F775555000FFFFF0F005555777555FF7F77555550FF7000
        0F055555575FF777757F555555000FFFFF05555555777555FF7F55555550FF70
        0005555555575FF7777555555555000555555555555577755555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      OnClick = Especial1Click
    end
    object AnotarGraphSpeedButton: TSpeedButton
      Left = 120
      Top = 24
      Width = 25
      Height = 25
      Hint = 'Anota'#231#227'o Gr'#225'fica'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00559999999995
        5555557777777775F5555559999999505555555777777757FFF5555555555550
        0955555555555FF7775F55555555995501955555555577557F75555555555555
        01995555555555557F5755555555555501905555555555557F57555555555555
        0F905555555555557FF75555555555500005555555555557777555555555550F
        F05555555555557F57F5555555555008F05555555555F775F755555555570000
        05555555555775577555555555700007555555555F755F775555555570000755
        55555555775F77555555555700075555555555F75F7755555555570007555555
        5555577F77555555555500075555555555557777555555555555}
      NumGlyphs = 2
      OnClick = AnotarGraphSpeedButtonClick
    end
    object AnotarTextoSpeedButton: TSpeedButton
      Left = 120
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Anota'#231#227'o de Texto'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
        000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
        00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
        F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
        0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
        FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
        FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
        0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
        00333377737FFFFF773333303300000003333337337777777333}
      NumGlyphs = 2
      OnClick = AnotarTextoSpeedButtonClick
    end
    object Animate1: TSpeedButton
      Left = 485
      Top = 0
      Width = 25
      Height = 25
      Hint = 'P'#225'gina tem anota'#231#245'es de Texto'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555550555
        555555555555F55555555505555B0555570555F55557F55555F55B50555B0555
        7B55575F5557F555575555B5055B5557B5555575F55755557555555B5550005B
        55555557555FFF575555555555BBB0055555555555777FF5555555555BBBBB00
        55555555577777FF55555000BBBBBBB050005FFF7777777F5FFFBBB5BBBBBBB0
        BBB577757777777F77755555BBBBBBB55555555577777775555555555BBBBB55
        55555555577777555555555705BBB55505555555F5777555F555557B5555055B
        505555575555F5575F5557B5555B0555B50555755557F55575F55B55555B0555
        5B5557555557F55557555555555B555555555555555755555555}
      NumGlyphs = 2
      Visible = False
      OnClick = Animate1Click
    end
    object Animate2: TSpeedButton
      Left = 485
      Top = 24
      Width = 25
      Height = 25
      Hint = 'P'#225'gina tem anota'#231#245'es Gr'#225'ficas'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555550555
        555555555555F55555555505555B0555570555F55557F55555F55B50555B0555
        7B55575F5557F555575555B5055B5557B5555575F55755557555555B5550005B
        55555557555FFF575555555555BBB0055555555555777FF5555555555BBBBB00
        55555555577777FF55555000BBBBBBB050005FFF7777777F5FFFBBB5BBBBBBB0
        BBB577757777777F77755555BBBBBBB55555555577777775555555555BBBBB55
        55555555577777555555555705BBB55505555555F5777555F555557B5555055B
        505555575555F5575F5557B5555B0555B50555755557F55575F55B55555B0555
        5B5557555557F55557555555555B555555555555555755555555}
      NumGlyphs = 2
      Visible = False
      OnClick = Animate2Click
    end
    object Label2: TLabel
      Left = 384
      Top = 32
      Width = 5
      Height = 2
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Label2'
    end
    object EditPes: TEdit
      Left = 176
      Top = 0
      Width = 49
      Height = 10
      TabOrder = 0
      OnChange = EditPesChange
    end
    object VaiPesquisa: TButton
      Left = 176
      Top = 24
      Width = 17
      Height = 17
      Hint = 'Vai Para Pesquisa'
      Caption = 'v'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = VaiPesquisaClick
    end
    object EditPag: TEdit
      Left = 336
      Top = 0
      Width = 49
      Height = 10
      TabOrder = 1
      OnChange = EditPagChange
    end
    object VaiPagina: TButton
      Left = 336
      Top = 24
      Width = 17
      Height = 17
      Hint = 'Vai Para P'#225'gina|'
      Caption = 'v'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = VaiPaginaClick
    end
    object Memo2: TMemo
      Left = 520
      Top = 8
      Width = 209
      Height = 17
      Lines.Strings = (
        '')
      TabOrder = 2
      WordWrap = False
    end
    object ScrollBar1: TScrollBar
      Left = 224
      Top = 16
      Width = 89
      Height = 16
      PageSize = 0
      TabOrder = 3
      OnScroll = ScrollBar1Scroll
    end
    object ScrollBar2: TScrollBar
      Left = 384
      Top = 16
      Width = 89
      Height = 16
      PageSize = 0
      TabOrder = 4
      OnScroll = ScrollBar2Scroll
    end
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 200
    Top = 64
  end
  object OpenReportDialog: TOpenDialog
    Filter = 
      'Arquivos MultiCold (*.dat) | *.dat;*.DAT;*.Dat;*.DAt;*.dAt;*.dAT' +
      ';*.daT '
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 103
    Top = 112
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 200
    Top = 112
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 288
    Top = 64
  end
  object Timer1: TTimer
    Interval = 600000
    OnTimer = Timer1Timer
    Left = 288
    Top = 112
  end
  object PilhaExecucao: TPilha
    Left = 304
    Top = 184
  end
  object MainMenu1: TMainMenu
    Left = 27
    Top = 64
    object File1: TMenuItem
      Caption = 'Arquivo'
      object Open1: TMenuItem
        Caption = '&Abrir...'
        ShortCut = 16449
        OnClick = AbreRelButClick
      end
      object AbrirAssistido1: TMenuItem
        Caption = 'Abrir Assistido...'
        ShortCut = 16450
        OnClick = AbrirAssistido1Click
      end
      object AbrirRemoto1: TMenuItem
        Caption = 'Abrir Remoto...'
        ShortCut = 16452
        OnClick = AbrirRemoto1Click
      end
      object Fechar1: TMenuItem
        Caption = '&Fechar'
        ShortCut = 16454
        OnClick = Fechar1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ConfigurarImpressora1: TMenuItem
        Caption = 'Configurar Impressora...'
        Enabled = False
        OnClick = ConfigurarImpressora1Click
      end
      object ConfigurarFontedeImpresso1: TMenuItem
        Caption = 'Configurar Fonte de Impress'#227'o ...'
        Enabled = False
        OnClick = ConfigurarFontedeImpresso1Click
      end
      object ImprimirRelatrio1: TMenuItem
        Caption = 'Imprimir Relat'#243'rio...'
        Enabled = False
        OnClick = ImprimirClick
      end
      object ExportarRelatrio1: TMenuItem
        Caption = 'Montar Template de Exporta'#231#227'o...'
        Enabled = False
        OnClick = ExportarSpeedButtonClick
      end
      object DescompactarRelatrio1: TMenuItem
        Caption = 'Descompactar Relat'#243'rio...'
        Enabled = False
        OnClick = DescompactarClick
      end
      object PesquisaemGrupo1: TMenuItem
        Caption = '&Pesquisar em Grupo'
        Enabled = False
        ShortCut = 16464
        OnClick = PesquisaemGrupo1Click
      end
      object Separator3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Sair'
        ShortCut = 16467
        OnClick = Exit1Click
      end
    end
    object Editar1: TMenuItem
      Caption = 'Editar'
      object CopiarPgina1: TMenuItem
        Caption = 'Copiar P'#225'gina'
        Enabled = False
        OnClick = CopiarPgina1Click
      end
      object AproximarZoom1: TMenuItem
        Caption = 'Aproximar (Zoom In)'
        Enabled = False
        OnClick = PlusZoomClick
      end
      object AfastarZoomOut1: TMenuItem
        Caption = 'Afastar (Zoom Out)'
        Enabled = False
        OnClick = LessZoomClick
      end
      object Normal1001: TMenuItem
        Caption = 'Normal (100%)'
        Enabled = False
        ShortCut = 16462
        OnClick = NormalZoomClick
      end
      object ConfigurarFontedeVdeo1: TMenuItem
        Caption = 'Configurar Fonte de V'#237'deo ...'
        Enabled = False
        OnClick = ConfigurarFontedeVdeo1Click
      end
      object ConfigurarCordoFundo1: TMenuItem
        Caption = 'Configurar Cor do Fundo ...'
        Enabled = False
        OnClick = ConfigurarCordoFundo1Click
      end
      object ModoTexto1: TMenuItem
        Caption = 'Modo Texto'
        Enabled = False
        OnClick = ModoTexto1Click
      end
      object CopiarTextoSelecionado1: TMenuItem
        Caption = 'Copiar Texto Selecionado'
        Enabled = False
        ShortCut = 16451
        OnClick = CopiarTextoSelecionado1Click
      end
    end
    object Escala1: TMenuItem
      Caption = 'Escala'
      object mScreenWidth: TMenuItem
        Caption = 'Largura da p'#225'gina'
        Checked = True
        Enabled = False
        RadioItem = True
        OnClick = mScreenWidthClick
      end
      object mScreenHeight: TMenuItem
        Caption = 'Altura da p'#225'gina'
        Enabled = False
        RadioItem = True
        OnClick = mScreenWidthClick
      end
      object m200: TMenuItem
        Caption = '200 %'
        Enabled = False
        RadioItem = True
        OnClick = mScreenWidthClick
      end
      object m150: TMenuItem
        Caption = '150 %'
        Enabled = False
        RadioItem = True
        OnClick = mScreenWidthClick
      end
      object m100: TMenuItem
        Caption = '100 %'
        Enabled = False
        RadioItem = True
        OnClick = mScreenWidthClick
      end
      object m75: TMenuItem
        Caption = '75 %'
        Enabled = False
        RadioItem = True
        OnClick = mScreenWidthClick
      end
      object m50: TMenuItem
        Caption = '50 %'
        Enabled = False
        RadioItem = True
        OnClick = mScreenWidthClick
      end
    end
    object Pesquisar1: TMenuItem
      Caption = 'Pesquisar'
      object MontarQueryFcil1: TMenuItem
        Caption = '&Montar Query F'#225'cil'
        Enabled = False
        ShortCut = 16461
        OnClick = AbreQueryFacilClick
      end
      object RepeteltimaPesquisa1: TMenuItem
        Caption = '&Repete '#218'ltima Pesquisa'
        Enabled = False
        ShortCut = 16466
        OnClick = RepetePesquisaClick
      end
      object Prxima1: TMenuItem
        Caption = 'Pr'#243'xima'
        Enabled = False
        ShortCut = 113
        OnClick = Prxima1Click
      end
      object Anterior1: TMenuItem
        Caption = 'Anterior'
        Enabled = False
        ShortCut = 115
        OnClick = Anterior1Click
      end
      object Especial1: TMenuItem
        Caption = 'Especial...'
        OnClick = Especial1Click
      end
      object Localizar1: TMenuItem
        Caption = 'Localizar...'
        Enabled = False
        OnClick = Localizar1Click
      end
      object LocalizarPrxima1: TMenuItem
        Caption = 'Localizar Pr'#243'xima'
        Enabled = False
        ShortCut = 114
        OnClick = LocalizarPrxima1Click
      end
    end
    object rEMOTO1: TMenuItem
      Caption = 'Extra'#231#227'o Remota'
      object ConsultarStatusProcessamento1: TMenuItem
        Caption = 'Consultar Status Processamento'
        OnClick = ConsultarStatusProcessamento1Click
      end
      object DownloadManager1: TMenuItem
        Caption = 'Download Manager'
        OnClick = DownloadManager1Click
      end
    end
    object Pgina1: TMenuItem
      Caption = 'P'#225'gina'
      object Prxima2: TMenuItem
        Caption = 'Pr'#243'xima'
        Enabled = False
        ShortCut = 116
        OnClick = Prxima2Click
      end
      object Anterior2: TMenuItem
        Caption = 'Anterior'
        Enabled = False
        ShortCut = 117
        OnClick = Anterior2Click
      end
    end
    object Espaco1: TMenuItem
      Caption = 'Espaco'
    end
    object Window1: TMenuItem
      Caption = 'Janela'
      object Tile1: TMenuItem
        Caption = '&Emplilhar'
        OnClick = Tile1Click
      end
      object LadoaLado1: TMenuItem
        Caption = 'Lado a Lado'
        OnClick = LadoaLado1Click
      end
      object Cascade1: TMenuItem
        Caption = '&Cascata'
        OnClick = Cascade1Click
      end
      object ArrangeIcons1: TMenuItem
        Caption = '&Rearranja Icons'
        OnClick = ArrangeIcons1Click
      end
    end
    object Info1: TMenuItem
      Caption = 'Info'
      object SobreoMultiCold1: TMenuItem
        Caption = 'Sobre o MultiCold'
        OnClick = SobreoMultiCold1Click
      end
    end
    object He1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
  end
  object FDQuery1: TFDQuery
    Left = 248
    Top = 384
  end
end
