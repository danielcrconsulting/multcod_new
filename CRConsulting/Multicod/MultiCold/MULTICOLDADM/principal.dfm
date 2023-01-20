object fPrincipal: TfPrincipal
  Left = 388
  Top = 184
  Caption = 'Multicold ADM - Vers'#227'o 3.1.0.15 (25/10/2022)'
  ClientHeight = 431
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object StatusBar1: TStatusBar
    Left = 0
    Top = 412
    Width = 632
    Height = 19
    Panels = <>
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 336
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object Extrator1: TMenuItem
        Caption = '&Extrator ...'
        Enabled = False
        OnClick = Extrator1Click
      end
      object Mapadenomes1: TMenuItem
        Caption = 'M&apa de nomes ...'
        Enabled = False
        OnClick = Mapadenomes1Click
      end
      object Mscaradecampos1: TMenuItem
        Caption = '&M'#225'scara de campos ...'
        Enabled = False
        OnClick = Mscaradecampos1Click
      end
      object MovimentoparaCD1: TMenuItem
        Caption = 'Movimento para &CD ...'
        Enabled = False
        OnClick = MovimentoparaCD1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Configuraes1: TMenuItem
        Caption = 'C&onfigura'#231#245'es ...'
        Enabled = False
        OnClick = Configuraes1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Hierarquia1: TMenuItem
        Caption = '&Hierarquia'
        Enabled = False
        object Sistema1: TMenuItem
          Caption = '&Sistema ...'
          Enabled = False
          OnClick = Sistema1Click
        end
        object GruposDFN1: TMenuItem
          Caption = '&Grupos DFN ...'
          Enabled = False
          OnClick = GruposDFN1Click
        end
        object SubgruposDFN1: TMenuItem
          Caption = '&Subgrupos DFN ...'
          Enabled = False
          OnClick = SubgruposDFN1Click
        end
        object N3: TMenuItem
          Caption = '-'
        end
      end
      object Relatrios1: TMenuItem
        Caption = '&Relat'#243'rios'
        Enabled = False
        object DFN1: TMenuItem
          Caption = '&DFN ...'
          Enabled = False
          OnClick = DFN1Click
        end
        object DestinosDFN1: TMenuItem
          Caption = 'D&estinos DFN ...'
          Enabled = False
          OnClick = DestinosDFN1Click
        end
        object ndicesDFN1: TMenuItem
          Caption = #205'&ndices DFN ...'
          Enabled = False
          OnClick = ndicesDFN1Click
        end
        object Limpeza1: TMenuItem
          Caption = '&Limpeza ...'
          OnClick = Limpeza1Click
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object Auxilires1: TMenuItem
          Caption = 'Auxiliares'
          object Auxiliaralfanumrico1: TMenuItem
            Caption = '&Auxiliar alfanum'#233'rico ...'
            Enabled = False
            OnClick = Auxiliaralfanumrico1Click
          end
          object Auxiliarnumrico1: TMenuItem
            Caption = 'A&uxiliar num'#233'rico ...'
            Enabled = False
            OnClick = Auxiliarnumrico1Click
          end
          object Auxiliardesistemaautomtico1: TMenuItem
            Caption = 'Au&xiliar de sistema autom'#225'tico ...'
            Enabled = False
            OnClick = Auxiliardesistemaautomtico1Click
          end
        end
        object N2: TMenuItem
          Caption = '-'
        end
        object Editor1: TMenuItem
          Caption = 'Ed&itor ...'
          Enabled = False
          OnClick = Editor1Click
        end
        object DFNscomproblema1: TMenuItem
          Caption = 'DFN'#39's com problema...'
          OnClick = DFNscomproblema1Click
        end
      end
      object Relacionamentos1: TMenuItem
        Caption = 'Re&lacionamentos'
        Enabled = False
        object Gruposdeusuriosporrelatrios1: TMenuItem
          Caption = '&Grupos de usu'#225'rios por relat'#243'rios ...'
          Enabled = False
          OnClick = Gruposdeusuriosporrelatrios1Click
        end
        object GruposdeusuriosporrelatriosII1: TMenuItem
          Caption = 'Grupos de usu'#225'rios por relat'#243'rios II ...'
          Visible = False
          OnClick = GruposdeusuriosporrelatriosII1Click
        end
        object Heranadepermisso1: TMenuItem
          Caption = '&Heran'#231'a de permiss'#227'o ...'
          Enabled = False
          OnClick = Heranadepermisso1Click
        end
        object MscaradecamposxUsurios1: TMenuItem
          Caption = '&M'#225'scara de campos por usu'#225'rios ...'
          Enabled = False
          OnClick = MscaradecamposxUsurios1Click
        end
        object Usuriosporgruposdeusurios1: TMenuItem
          Caption = '&Usu'#225'rios por grupos de usu'#225'rios ...'
          Enabled = False
          OnClick = Usuriosporgruposdeusurios1Click
        end
        object Usuriosporrelatrios1: TMenuItem
          Caption = 'U&su'#225'rios por relat'#243'rios ...'
          Enabled = False
          OnClick = Usuriosporrelatrios1Click
        end
      end
      object Usurios1: TMenuItem
        Caption = '&Usu'#225'rios'
        Enabled = False
        object Gruposdeusurios1: TMenuItem
          Caption = '&Grupos de usu'#225'rios ...'
          Enabled = False
          OnClick = Gruposdeusurios1Click
        end
        object Usurios2: TMenuItem
          Caption = 'U&su'#225'rios ...'
          Enabled = False
          OnClick = Usurios2Click
        end
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = 'Sai&r'
        OnClick = Sair1Click
      end
    end
    object Relatrios2: TMenuItem
      Caption = '&Relat'#243'rios'
      object Logdeacesso1: TMenuItem
        Caption = '&Log de acesso ...'
        Enabled = False
        OnClick = Logdeacesso1Click
      end
      object Protocolo1: TMenuItem
        Caption = 'Protocolo ...'
        Enabled = False
        OnClick = Protocolo1Click
      end
      object Usurios3: TMenuItem
        Caption = 'Seguran'#231'a ...'
        Enabled = False
        OnClick = Usurios3Click
      end
    end
  end
end
