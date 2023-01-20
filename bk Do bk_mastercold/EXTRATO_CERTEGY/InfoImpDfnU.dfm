object GetInfoImpDFNForm: TGetInfoImpDFNForm
  Left = 217
  Top = 215
  Caption = 'Informa'#231#245'es para a importa'#231#227'o de Arquivo DFN'
  ClientHeight = 225
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 56
    Width = 93
    Height = 13
    Caption = 'C'#243'digo do Relat'#243'rio'
  end
  object Label2: TLabel
    Left = 48
    Top = 88
    Width = 29
    Height = 13
    Caption = 'Grupo'
  end
  object Label3: TLabel
    Left = 48
    Top = 120
    Width = 48
    Height = 13
    Caption = 'SubGrupo'
  end
  object Edit1: TEdit
    Left = 176
    Top = 48
    Width = 201
    Height = 21
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 176
    Top = 80
    Width = 201
    Height = 21
    TabOrder = 1
  end
  object ComboBox2: TComboBox
    Left = 176
    Top = 112
    Width = 201
    Height = 21
    TabOrder = 2
    OnEnter = ComboBox2Enter
  end
  object Button1: TButton
    Left = 48
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 4
    OnClick = Button2Click
  end
end
