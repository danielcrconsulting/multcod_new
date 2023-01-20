object FrmConsultaExportacoesRemoto: TFrmConsultaExportacoesRemoto
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Formul'#225'rio de Acompanhamento das Exporta'#231#245'es Remotas'
  ClientHeight = 437
  ClientWidth = 867
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGridConsultaExportacao: TDBGrid
    Left = 0
    Top = 169
    Width = 867
    Height = 207
    Align = alClient
    DataSource = DSProcessadorTemplate
    Options = [dgTitles, dgIndicator, dgColumnResize, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
    PopupMenu = PopupMenuGrid
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 376
    Width = 867
    Height = 61
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      867
      61)
    object LblStatus: TLabel
      Left = 672
      Top = 36
      Width = 66
      Height = 16
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Baixar arq'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BtnFechar: TButton
      Left = 780
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = BtnFecharClick
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 1
      Width = 665
      Height = 59
      Align = alLeft
      TabOrder = 1
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 867
    Height = 169
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      867
      169)
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 867
      Height = 24
      Align = alTop
      Alignment = taCenter
      Caption = 'Consulta das Exporta'#231#245'es Remotas'
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitWidth = 312
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 3
      Top = 27
      Width = 861
      Height = 7
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 0
      ExplicitTop = 30
      ExplicitWidth = 748
    end
    object Label2: TLabel
      Left = 15
      Top = 40
      Width = 65
      Height = 19
      Caption = 'Usu'#225'rio: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LblNomeUsuario: TLabel
      Left = 86
      Top = 42
      Width = 5
      Height = 19
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 15
      Top = 70
      Width = 54
      Height = 19
      Caption = 'Status: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object BtnDownload: TButton
      Left = 734
      Top = 40
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Baixar Arquivo'
      TabOrder = 2
      OnClick = BtnDownloadClick
    end
    object BtnAbrirTemplate: TButton
      Left = 607
      Top = 40
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Abrir Template'
      TabOrder = 1
      OnClick = BtnAbrirTemplateClick
    end
    object ComboBoxStatus: TComboBox
      Left = 86
      Top = 67
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Pendentes'
      Items.Strings = (
        'Pendentes'
        'Em Andamento'
        'Sucesso'
        'Erro Execu'#231#227'o')
    end
    object BtnPesquisar: TButton
      Left = 438
      Top = 111
      Width = 193
      Height = 52
      Anchors = [akTop, akRight]
      Caption = 'Pesquisar'
      Default = True
      TabOrder = 3
      OnClick = BtnPesquisarClick
    end
    object Panel3: TPanel
      Left = 15
      Top = 117
      Width = 410
      Height = 41
      BevelInner = bvRaised
      BevelKind = bkFlat
      BevelOuter = bvLowered
      TabOrder = 4
      object Label4: TLabel
        Left = 10
        Top = 9
        Width = 38
        Height = 19
        Caption = 'Data:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object DateTimePickerIni: TDateTimePicker
        Left = 81
        Top = 7
        Width = 145
        Height = 21
        Date = 43992.000000000000000000
        Time = 0.016717418984626420
        TabOrder = 0
      end
      object DateTimePickerFin: TDateTimePicker
        Left = 249
        Top = 7
        Width = 145
        Height = 21
        Date = 43992.000000000000000000
        Time = 0.016913993058551570
        TabOrder = 1
      end
    end
    object CheckBoxData: TCheckBox
      Left = 15
      Top = 100
      Width = 97
      Height = 17
      Caption = 'Filtrar por Data?'
      TabOrder = 5
    end
    object btnexcluir: TButton
      Left = 662
      Top = 111
      Width = 193
      Height = 52
      Anchors = [akTop, akRight]
      Caption = 'Excluir Arquivos'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Visible = False
      OnClick = btnexcluirClick
    end
  end
  object DSProcessadorTemplate: TDataSource
    DataSet = FormGeral.Memtb
    Left = 48
    Top = 312
  end
  object PopupMenuGrid: TPopupMenu
    Left = 272
    Top = 208
    object AbrirTemplate1: TMenuItem
      Caption = 'Abrir Template'
      OnClick = BtnAbrirTemplateClick
    end
    object BaixarArquivo1: TMenuItem
      Caption = 'Baixar Arquivo'
      OnClick = BtnDownloadClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = '*.txt|*.txt'
    Left = 680
    Top = 192
  end
  object IdHTTP1: TIdHTTP
    OnWork = IdHTTP1Work
    OnWorkBegin = IdHTTP1WorkBegin
    OnWorkEnd = IdHTTP1WorkEnd
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 400
    Top = 56
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 472
    Top = 56
  end
end
