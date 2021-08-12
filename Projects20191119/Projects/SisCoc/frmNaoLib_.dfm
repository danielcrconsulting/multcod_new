
object frmNaoLib: TfrmNaoLib
  Left = 0
  Top = 0
  ClientWidth = 354
  ClientHeight = 215
  Caption = 'Funcionalidade não Liberada para uso'
  Font.Color = clBackground
  Position = poScreenCenter
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 321
    Height = 130
    Caption = 'Funcionalidade ainda não disponível para uso'
    Font.Color = clActiveCaption
    AutoSize = False
    WordWrap = True
    Font.Charset = ANSI_CHARSET
    Font.Style = [fsBold, fsItalic]
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    ParentFont = False
  end
  object Command1: TButton
    Left = 255
    Top = 162
    Width = 82
    Height = 33
    Caption = '&Sair'
    TabOrder = 0
    OnClick = Command1Click
  end
end