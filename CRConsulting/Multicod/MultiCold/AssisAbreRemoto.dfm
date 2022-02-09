object AssisAbreRemotoForm: TAssisAbreRemotoForm
  Left = 231
  Top = 102
  BorderIcons = [biSystemMenu]
  Caption = 'Assistente de abertura de relat'#243'rios remotos'
  ClientHeight = 475
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  WindowMenu = FrameForm.Window1
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 475
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object TreeView1: TTreeView
      Left = 1
      Top = 1
      Width = 215
      Height = 432
      Align = alClient
      HideSelection = False
      Indent = 19
      TabOrder = 0
      OnDblClick = Button1Click
    end
    object Panel2: TPanel
      Left = 1
      Top = 433
      Width = 215
      Height = 41
      Align = alBottom
      TabOrder = 1
      object Button1: TButton
        Left = 136
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Relat'#243'rios'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object Panel3: TPanel
    Left = 217
    Top = 0
    Width = 415
    Height = 475
    Align = alClient
    AutoSize = True
    TabOrder = 1
    object ListBox2: TListBox
      Left = 1
      Top = 1
      Width = 413
      Height = 432
      Align = alClient
      ItemHeight = 14
      TabOrder = 0
      OnDblClick = Button2Click
    end
    object Panel4: TPanel
      Left = 1
      Top = 433
      Width = 413
      Height = 41
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        413
        41)
      object Button3: TButton
        Left = 332
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Sair'
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button2: TButton
        Left = 252
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Abrir'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
end
