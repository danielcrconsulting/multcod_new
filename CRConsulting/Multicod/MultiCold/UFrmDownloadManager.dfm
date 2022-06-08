object FrmDownloadManager: TFrmDownloadManager
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Downloads em Andamento'
  ClientHeight = 466
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LbDownloads: TListBox
    Left = 0
    Top = 0
    Width = 298
    Height = 409
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnClick = LbDownloadsClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 409
    Width = 537
    Height = 57
    Align = alBottom
    TabOrder = 1
    object Btnfechar: TButton
      Left = 430
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = BtnfecharClick
    end
  end
  object Panel2: TPanel
    Left = 298
    Top = 0
    Width = 239
    Height = 409
    Align = alRight
    TabOrder = 2
    object Label1: TLabel
      Left = 88
      Top = 16
      Width = 60
      Height = 19
      Caption = 'Detalhes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 6
      Top = 64
      Width = 105
      Height = 13
      Caption = 'Path Destino Arquivo:'
    end
    object MemoPath: TMemo
      Left = 6
      Top = 83
      Width = 227
      Height = 89
      Enabled = False
      TabOrder = 0
    end
    object PanelDownload: TPanel
      Left = 6
      Top = 264
      Width = 225
      Height = 89
      BevelKind = bkFlat
      BevelOuter = bvLowered
      TabOrder = 1
      object Label3: TLabel
        Left = 14
        Top = 11
        Width = 102
        Height = 13
        Caption = 'Progresso Download:'
      end
      object BtnCancelar: TButton
        Left = 48
        Top = 53
        Width = 129
        Height = 25
        Caption = 'Cancelar Download'
        TabOrder = 0
        OnClick = BtnCancelarClick
      end
      object ProgressBarDownload: TProgressBar
        Left = 16
        Top = 30
        Width = 193
        Height = 17
        TabOrder = 1
      end
    end
  end
end
