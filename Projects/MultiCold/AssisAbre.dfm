object AssisAbreForm: TAssisAbreForm
  Left = 248
  Top = 165
  BorderIcons = [biSystemMenu]
  Caption = 'Assistente de abertura de relat'#243'rios'
  ClientHeight = 381
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowMenu = FrameForm.AbrirRemoto1
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 381
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 340
      Width = 215
      Height = 40
      Align = alBottom
      TabOrder = 0
      object FiltradoCheckBox: TCheckBox
        Left = 8
        Top = 10
        Width = 97
        Height = 17
        Caption = 'Filtrado'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = FiltradoCheckBoxClick
      end
      object Button1: TButton
        Left = 128
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Relat'#243'rios'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TreeView1: TTreeView
      Left = 1
      Top = 1
      Width = 215
      Height = 339
      Align = alClient
      HideSelection = False
      Indent = 19
      TabOrder = 1
      OnDblClick = Button1Click
    end
  end
  object Panel3: TPanel
    Left = 217
    Top = 0
    Width = 295
    Height = 381
    Align = alClient
    AutoSize = True
    Caption = 'Panel3'
    TabOrder = 1
    object ListBox2: TListBox
      Left = 1
      Top = 1
      Width = 293
      Height = 339
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDblClick = Button2Click
    end
    object Panel4: TPanel
      Left = 1
      Top = 340
      Width = 293
      Height = 40
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        293
        40)
      object Button2: TButton
        Left = 132
        Top = 7
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Abrir'
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 212
        Top = 7
        Width = 76
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Sair'
        TabOrder = 1
        OnClick = Button3Click
      end
    end
  end
  object Table1: TTable
    Left = 64
    Top = 360
  end
end
