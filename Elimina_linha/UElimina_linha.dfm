object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Elimina Linha'
  ClientHeight = 452
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object lblmsg: TLabel
    Left = 322
    Top = 391
    Width = 143
    Height = 25
    Caption = 'Aguarde........'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object btnAbrir: TButton
    Left = 144
    Top = 40
    Width = 153
    Height = 41
    Caption = 'Abrir Arquivo'
    TabOrder = 0
    OnClick = btnAbrirClick
  end
  object gb: TGroupBox
    Left = 8
    Top = 128
    Width = 369
    Height = 257
    Caption = 'Configurar Elimina'#231#227'o'
    Enabled = False
    TabOrder = 1
    object Label1: TLabel
      Left = 32
      Top = 40
      Width = 100
      Height = 19
      Caption = 'Posi'#231#227'o Inicial'
    end
    object Label2: TLabel
      Left = 32
      Top = 78
      Width = 67
      Height = 19
      Caption = 'Tamanho'
    end
    object Label3: TLabel
      Left = 32
      Top = 120
      Width = 106
      Height = 19
      Caption = 'Conte'#250'do Pesq'
    end
    object edpos: TEdit
      Left = 151
      Top = 33
      Width = 58
      Height = 27
      TabOrder = 0
    end
    object edtam: TEdit
      Left = 151
      Top = 70
      Width = 58
      Height = 27
      TabOrder = 1
    end
    object edCont: TEdit
      Left = 151
      Top = 112
      Width = 210
      Height = 27
      TabOrder = 2
    end
    object Button1: TButton
      Left = 128
      Top = 176
      Width = 153
      Height = 41
      Caption = 'Eliminar'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 383
    Top = 128
    Width = 357
    Height = 257
    Caption = 'Separa'#231#227'o de Arquivos'
    TabOrder = 2
    object Label4: TLabel
      Left = 16
      Top = 78
      Width = 224
      Height = 19
      Caption = 'Quantidade Linhas por arquivo:'
    end
    object edlinha: TEdit
      Left = 246
      Top = 70
      Width = 89
      Height = 27
      TabOrder = 0
    end
    object Button2: TButton
      Left = 112
      Top = 176
      Width = 153
      Height = 41
      Caption = 'Gerar'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Button3: TButton
    Left = 383
    Top = 40
    Width = 153
    Height = 41
    Caption = 'Ordenar Arquivo'
    TabOrder = 3
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Left = 680
    Top = 8
  end
  object memtb: TFDMemTable
    IndexFieldNames = 'conta;cartao'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 552
    Top = 48
    object memtbident: TStringField
      FieldName = 'ident'
      Size = 6
    end
    object memtbcartao: TStringField
      FieldName = 'cartao'
      Size = 16
    end
    object memtbconta: TStringField
      FieldName = 'conta'
      Size = 16
    end
    object memtbstatus: TStringField
      FieldName = 'status'
      Size = 2
    end
    object memtbcnpj: TStringField
      FieldName = 'cnpj'
      Size = 15
    end
    object memtbnome: TStringField
      FieldName = 'nome'
      Size = 19
    end
    object memtbtitular: TStringField
      FieldName = 'titular'
      Size = 1
    end
    object memtbtipo: TStringField
      FieldName = 'tipo'
      Size = 1
    end
    object memtbcodbloq: TStringField
      FieldName = 'codbloq'
      Size = 2
    end
    object memtbdtbloq: TStringField
      FieldName = 'dtbloq'
      Size = 8
    end
  end
end
