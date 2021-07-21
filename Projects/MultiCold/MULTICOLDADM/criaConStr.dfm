object fCriaConStr: TfCriaConStr
  Left = 240
  Top = 207
  BorderStyle = bsDialog
  Caption = 'Conex'#227'o com o banco de dados'
  ClientHeight = 256
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 308
    Height = 206
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 51
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Servidor'
    end
    object Label2: TLabel
      Left = 10
      Top = 79
      Width = 103
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Nome de usu'#225'rio'
    end
    object Label3: TLabel
      Left = 10
      Top = 148
      Width = 39
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Senha'
    end
    object Edit1: TEdit
      Left = 10
      Top = 30
      Width = 287
      Height = 21
      Hint = 'Endere'#231'o IP ou nome do servidor do banco de dados'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 10
      Top = 98
      Width = 287
      Height = 21
      Hint = 'Nome de usu'#225'rio para acesso ao banco de dados'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 10
      Top = 167
      Width = 287
      Height = 21
      Hint = 'Senha do usu'#225'rio de login ao banco de dados'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 206
    Width = 308
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 266
      Top = 10
      Width = 28
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
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
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
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Left = 88
    Top = 175
  end
end
