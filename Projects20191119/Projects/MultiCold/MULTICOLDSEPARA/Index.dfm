object FormIndex: TFormIndex
  Left = 227
  Top = 135
  Caption = 
    'MultiCold - Separador de Relat'#243'rios V2.0.2.3 19/11/2019 - Sql Se' +
    'rver'
  ClientHeight = 298
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    716
    298)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 32
    Width = 86
    Height = 13
    Caption = 'Log de Atividade :'
  end
  object Label1: TLabel
    Left = 346
    Top = 29
    Width = 96
    Height = 13
    Caption = 'Bytes Processados: '
  end
  object RichEdit1: TRichEdit
    Left = 8
    Top = 48
    Width = 709
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 279
    Width = 716
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 500
      end>
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 716
    Height = 29
    ButtonHeight = 23
    Caption = 'ToolBar1'
    Images = ImageList1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object ProcessarSpeedButton: TToolButton
      Left = 0
      Top = 0
      Hint = 'Iniciar separador'
      Caption = 'Separar'
      ImageIndex = 6
      MenuItem = Indexar1
      OnClick = ProcessarSpeedButtonClick
    end
    object ConfigProcSpeedButton: TToolButton
      Left = 23
      Top = 0
      Hint = 'Configura'#231#245'es de processamento'
      Caption = 'Processamento'
      ImageIndex = 4
      MenuItem = Processamento1
    end
    object SairSpeedButton: TToolButton
      Left = 46
      Top = 0
      Hint = 'Encerrar execu'#231#227'o do separador'
      Caption = 'Sair'
      ImageIndex = 0
      MenuItem = Sair1
      OnClick = SairSpeedButtonClick
    end
  end
  object BExecutar: TButton
    Left = 100
    Top = 17
    Width = 75
    Height = 25
    Caption = 'Executar'
    TabOrder = 3
    Visible = False
    OnClick = BExecutarClick
  end
  object Edit1: TEdit
    Left = 448
    Top = 21
    Width = 257
    Height = 21
    TabOrder = 4
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    Left = 184
    Top = 8
    object Arquivo1: TMenuItem
      Caption = 'Arquivo'
      object Indexar1: TMenuItem
        Caption = 'Separar'
        Hint = 'Iniciar separador'
        ImageIndex = 6
        OnClick = ProcessarSpeedButtonClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = 'Sair'
        Hint = 'Encerrar execu'#231#227'o do separador'
        ImageIndex = 0
        OnClick = SairSpeedButtonClick
      end
    end
    object Configuraes1: TMenuItem
      Caption = 'Configura'#231#245'es'
      object Processamento1: TMenuItem
        Caption = 'Processamento'
        Hint = 'Configura'#231#245'es de processamento'
        ImageIndex = 4
        OnClick = Processamento1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = ProcessarSpeedButtonClick
    Left = 232
    Top = 8
  end
  object ImageList1: TImageList
    Left = 280
    Top = 8
    Bitmap = {
      494C0101080009007C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000FFFF
      FF0000000000000000000000000000000000000000007B7B7B00000000007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000FFFFFF007B7B7B00FFFFFF000000000000000000000000000000
      000000000000FFFFFF00000000007B7B7B0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF007B7B7B00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00BDBDBD007B7B7B00000000007B7B
      7B00000000000000000000000000000000000000000000000000000000007B7B
      7B00000000007B7B7B00000000000000000000000000FFFFFF007B7B7B000000
      00007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      00007B7B7B0000000000FFFFFF007B7B7B0000000000FFFFFF00FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00000000007B7B7B007B7B7B0000000000000000007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B007B7B7B00000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000007B7B
      7B00000000007B7B7B007B7B7B007B7B7B0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000FFFF00007B7B7B00FFFFFF0000000000FFFF
      FF000000000000000000000000007B7B7B00FFFFFF00FFFFFF00FFFFFF000000
      0000000000007B7B7B007B7B7B007B7B7B00BDBDBD00BDBDBD007B7B7B000000
      0000000000007B7B7B0000000000000000000000000000000000000000007B7B
      7B0000000000000000007B7B7B007B7B7B000000000000000000FFFFFF007B7B
      7B007B7B7B0000000000FFFFFF00000000000000000000000000000000000000
      00007B7B7B007B7B7B00000000000000000000000000FFFFFF0000000000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000FFFF00007B7B7B00FFFFFF007B7B7B000000
      0000FFFFFF00FFFFFF00000000007B7B7B007B7B7B007B7B7B00000000000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B0000000000000000007B7B7B007B7B7B007B7B
      7B00000000007B7B7B000000000000000000000000000000000000000000FFFF
      FF007B7B7B00FFFFFF00000000007B7B7B0000000000FFFFFF00FFFFFF000000
      000000000000FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000000000FFFF00007B7B7B00FFFFFF00000000007B7B
      7B007B7B7B00000000007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000007B7B
      7B00000000007B7B7B0000000000000000000000000000000000000000000000
      000000000000BDBDBD00000000007B7B7B00000000007B7B7B00FFFFFF000000
      00007B7B7B0000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B00000000007B7B7B00FFFFFF0000000000FFFFFF00FFFF00000000
      000000FFFF000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000FFFF00007B7B7B00FFFFFF00000000007B7B
      7B00000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000
      000000000000000000007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B00BDBDBD0000000000BDBDBD007B7B7B007B7B7B00000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000000000007B7B7B00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000000000FFFF00007B7B7B00FFFFFF00000000000000
      00007B7B7B0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD00000000007B7B7B0000000000FFFFFF00000000007B7B
      7B007B7B7B007B7B7B00FFFFFF000000000000000000FFFFFF007B7B7B007B7B
      7B007B7B7B00FFFFFF007B7B7B000000000000000000FFFFFF00FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF0000000000FFFF00007B7B7B00FFFFFF00000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B0000000000000000007B7B7B007B7B7B00000000007B7B7B00000000000000
      00007B7B7B0000000000000000007B7B7B00000000007B7B7B00000000000000
      0000000000007B7B7B00BDBDBD00000000007B7B7B0000000000FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF00FFFFFF007B7B7B0000000000FFFFFF000000
      00007B7B7B00FFFFFF00FFFFFF007B7B7B0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000FFFF00000000000000000000FFFF00FFFF
      FF0000FFFF000000000000000000000000007B7B7B00FFFFFF00000000000000
      000000000000000000007B7B7B00000000007B7B7B007B7B7B00FFFFFF00FFFF
      FF00FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B0000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000007B7B
      7B0000000000000000007B7B7B00BDBDBD00000000007B7B7B007B7B7B007B7B
      7B00000000007B7B7B007B7B7B007B7B7B00FFFFFF007B7B7B00000000000000
      00007B7B7B007B7B7B00FFFFFF00FFFFFF0000000000FFFFFF00FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00000000000000
      00000000000000000000000000007B7B7B00000000007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B0000000000000000007B7B7B00000000000000
      00007B7B7B000000000000000000000000007B7B7B007B7B7B00000000000000
      0000FFFFFF00FFFFFF00FFFFFF007B7B7B007B7B7B00FFFFFF00000000007B7B
      7B00000000007B7B7B007B7B7B007B7B7B0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF00000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000007B7B7B00000000007B7B7B000000
      0000FFFFFF00000000000000000000000000000000007B7B7B007B7B7B000000
      000000000000000000007B7B7B007B7B7B000000000000000000000000007B7B
      7B00000000007B7B7B0000000000000000007B7B7B00FFFFFF00000000007B7B
      7B007B7B7B007B7B7B0000000000FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF007B7B7B0000000000000000007B7B7B000000000000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF000000000000FFFF000000
      0000000000000000000000000000000000007B7B7B007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B
      7B0000000000FFFFFF00000000000000000000000000BDBDBD00000000007B7B
      7B007B7B7B007B7B7B00000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00000000007B7B7B00FFFF
      FF0000000000FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B00FFFF
      FF000000000000000000000000007B7B7B0000000000000000007B7B7B000000
      00007B7B7B00000000007B7B7B00000000007B7B7B00000000000000000000FF
      FF0000000000000000000000000000000000000000007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B000000
      00007B7B7B00FFFFFF00FFFFFF00000000007B7B7B00BDBDBD0000000000BDBD
      BD00000000007B7B7B00000000007B7B7B007B7B7B007B7B7B00000000000000
      00000000000000000000000000000000000000000000FFFFFF007B7B7B00FFFF
      FF007B7B7B00000000007B7B7B00FFFFFF0000000000FFFFFF007B7B7B00FFFF
      FF000000000000000000000000000000000000000000000000007B7B7B000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      00000000FF00000000000000000000000000000000007B7B7B00000000007B7B
      7B00000000007B7B7B00000000007B7B7B00000000007B7B7B00000000007B7B
      7B007B7B7B007B7B7B00000000000000000000000000BDBDBD00000000007B7B
      7B00BDBDBD007B7B7B00000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B000000
      0000FFFFFF00FFFFFF007B7B7B00000000007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00000000007B7B7B000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      00007B7B7B00000000000000000000000000000000007B7B7B00BDBDBD000000
      000000000000000000007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000007B7B
      7B007B7B7B007B7B7B0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF00000084000000FF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF007B7B7B0000000000FFFFFF007B7B7B0000000000000000007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B000000000000000000000000000000
      840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B0000000000FFFFFF0000000000000000000000000000000000000000000000
      00007B7B7B00FFFFFF000000000000000000000000007B7B7B00000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      FF00000084000000FF00000000000084840000000000000000007B7B7B007B7B
      7B007B7B7B0000000000FFFFFF007B7B7B000000000000000000000000007B7B
      7B00FFFFFF007B7B7B007B7B7B00000000000000000000000000000000000000
      84000000840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF007B7B7B0000000000FFFFFF00000000000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000007B7B7B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF00000084000000FF000084840000848400000000007B7B7B0000000000FFFF
      FF00FFFFFF00000000007B7B7B00FFFFFF000000000000000000000000007B7B
      7B00FFFFFF007B7B7B00FFFFFF00FFFFFF000000000000000000000000000000
      8400000084000000840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF00000000007B7B7B0000000000FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF00000084000000FF0000848400008484007B7B7B00FFFFFF007B7B7B007B7B
      7B0000000000FFFFFF007B7B7B00FFFFFF000000000000000000000000007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      FF00000084000000FF0000848400000000007B7B7B007B7B7B00000000000000
      00007B7B7B00FFFFFF007B7B7B00FFFFFF000000000000000000FFFFFF007B7B
      7B00000000007B7B7B007B7B7B00FFFFFF000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF000000000000000000000000007B7B7B00000000000000
      000000000000FFFFFF00000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000007B7B7B0000000000000000000000
      00007B7B7B00000000007B7B7B000000000000000000FFFFFF007B7B7B00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF00000000000000000000000000000000007B7B7B000000
      0000FFFFFF00000000007B7B7B00000000000000000000000000000084000000
      8400000084000000840000008400000000000000000000000000000000007B7B
      7B00FFFFFF007B7B7B000000000000000000FFFFFF007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000848400008484000084
      84000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B000000000000000000FFFFFF007B7B7B0000000000FFFFFF007B7B
      7B007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF007B7B7B0000000000FFFFFF007B7B7B000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B00FFFFFF00FFFFFF0000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000008484000084840000848400000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B00FFFFFF00FFFFFF007B7B7B0000000000FFFFFF007B7B7B00000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      8400000084000000840000FFFF000000000000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B007B7B7B000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00000000007B7B
      7B00FFFFFF007B7B7B0000000000FFFFFF007B7B7B0000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000000000007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000084840000848400008484000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B007B7B
      7B007B7B7B00FFFFFF00FFFFFF007B7B7B000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      840000008400000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF0000000000FFFFFF007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000848400000000000000000000000000000000007B7B
      7B00000000007B7B7B0000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      8400FFFF0000000084000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF000000000000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000007B7B7B00000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF0000000000000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      8400FFFF0000FFFF00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF0000000000000000000000000000000000008484000000
      00000000000000000000000000007B7B7B000000000000000000000000007B7B
      7B00000000007B7B7B00000000000000000000000000000000007B7B7B00FFFF
      FF007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B00000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000803F802F81FEC8FA001F3F8201E291F4
      00043F0407E033E800002E1803E0C5F30000123C03F08BE20000241C23C097C4
      0000283C3FC031C000003404E3C0A1810000380C2230405000003D0000208830
      00073E8700203028001F155700622206000F000B001E480E80078011001F848F
      8023AAA3001F111F55775577007F637FC007C003F862E260C007CBF380E0C4E1
      C007C5F301E0A4E0C007CAF301E008E0C007CCF331E130C8C007CCF331C17580
      C007CCF3C181E301C007CCF3C307C643C007CCF3FE17E493C007CC73CC37C133
      C007CCF3A877A273C007CCF340F700F3C007C8F301E300F3C007C0F3C1E3C073
      C007C003C0E3C017C007C007C83FC83F00000000000000000000000000000000
      000000000000}
  end
end