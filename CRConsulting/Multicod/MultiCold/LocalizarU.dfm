object Localizar: TLocalizar
  Left = 307
  Top = 195
  Caption = 'Localizar...'
  ClientHeight = 298
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    643
    298)
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 64
    Height = 14
    Caption = 'P'#225'gina Inicial:'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 60
    Height = 14
    Caption = 'P'#225'gina Final:'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 58
    Height = 14
    Caption = 'Linha Inicial:'
  end
  object Label4: TLabel
    Left = 8
    Top = 120
    Width = 54
    Height = 14
    Caption = 'Linha Final:'
  end
  object Label5: TLabel
    Left = 8
    Top = 152
    Width = 33
    Height = 14
    Caption = 'Coluna'
  end
  object Label6: TLabel
    Left = 8
    Top = 184
    Width = 47
    Height = 14
    Caption = 'Localizar:'
  end
  object Label7: TLabel
    Left = 360
    Top = 280
    Width = 62
    Height = 14
    Caption = 'P'#225'gina Atual:'
  end
  object Lblvalidacao: TLabel
    Left = 223
    Top = 35
    Width = 4
    Height = 18
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Gill Sans MT'
    Font.Style = []
    ParentFont = False
  end
  object LocalizarEdit: TEdit
    Left = 96
    Top = 176
    Width = 457
    Height = 22
    TabOrder = 5
    OnChange = PagIniEditChange
  end
  object PagIniEdit: TEdit
    Left = 96
    Top = 16
    Width = 121
    Height = 22
    TabOrder = 0
    OnChange = PagIniEditChange
  end
  object PagFinEdit: TEdit
    Left = 96
    Top = 48
    Width = 121
    Height = 22
    TabOrder = 1
    OnChange = PagIniEditChange
  end
  object LinIniEdit: TEdit
    Left = 96
    Top = 80
    Width = 121
    Height = 22
    TabOrder = 2
    OnChange = PagIniEditChange
  end
  object LinFinEdit: TEdit
    Left = 96
    Top = 112
    Width = 121
    Height = 22
    TabOrder = 3
    OnChange = PagIniEditChange
  end
  object ColunaEdit: TEdit
    Left = 96
    Top = 144
    Width = 121
    Height = 22
    TabOrder = 4
    OnChange = PagIniEditChange
  end
  object LocBut: TButton
    Left = 8
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Localizar'
    TabOrder = 6
    OnClick = LocButClick
  end
  object SairBut: TButton
    Left = 568
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 7
    OnClick = SairButClick
  end
  object PaginaAtuEdit: TEdit
    Left = 432
    Top = 272
    Width = 121
    Height = 22
    TabOrder = 8
  end
  object MemoGidley: TMemo
    Left = 496
    Top = 8
    Width = 145
    Height = 25
    Lines.Strings = (
      'MemoGidley')
    TabOrder = 9
    Visible = False
    WordWrap = False
  end
  object LocProxBut: TButton
    Left = 96
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Pr'#243'xima'
    Enabled = False
    TabOrder = 10
    OnClick = LocButClick
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 208
    Width = 241
    Height = 49
    Caption = 'Localizar em'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Todo o relat'#243'rio'
      'Na pesquisa')
    TabOrder = 11
  end
end
