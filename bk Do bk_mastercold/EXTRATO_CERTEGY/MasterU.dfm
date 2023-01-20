object MasterColdForm: TMasterColdForm
  Left = 178
  Top = 150
  Caption = 'MasterCold V3.2.0.3 27/07/2021'
  ClientHeight = 155
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label4: TLabel
    Left = 344
    Top = 8
    Width = 3
    Height = 14
  end
  object MainMenu1: TMainMenu
    Left = 64
    object Arquivo1: TMenuItem
      Caption = '&Consultas'
      object ConsultaContaCartoCPFNome1: TMenuItem
        Caption = '&Consulta/Conta/Cart'#227'o/CPF/Nome'
        OnClick = ConsultaContaCartoCPFNome1Click
      end
      object ConsultaConta1: TMenuItem
        Caption = 'C&onsulta/Conta'
        OnClick = ConsultaConta1Click
      end
      object ConsultaCarto1: TMenuItem
        Caption = 'Consulta/Cart'#227'o'
        OnClick = ConsultaCarto1Click
      end
      object ConsultaExtr1: TMenuItem
        Caption = 'Consulta/Extrato'
        OnClick = ConsultaExtr1Click
      end
      object ConsultaResumo1: TMenuItem
        Caption = 'Consulta/Resumo Listagem'
        OnClick = ConsultaResumo1Click
      end
      object ContaExtratos1: TMenuItem
        Caption = 'Conta Extratos'
        OnClick = ContaExtratos1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = '&Sair'
        OnClick = Sair1Click
      end
    end
    object Extrato1: TMenuItem
      Caption = '&Extrato'
      object Emissode2viadeExtrato1: TMenuItem
        Caption = '&Emiss'#227'o de 2'#170' via de Extrato'
        OnClick = Emissode2viadeExtrato1Click
      end
    end
    object Empresarial1: TMenuItem
      Caption = 'Empresarial'
      object ExtratoEmpresarial1: TMenuItem
        Caption = 'Extrato Empresarial'
        OnClick = ExtratoEmpresarial1Click
      end
      object Demonstrativo2via1: TMenuItem
        Caption = 'Demonstrativo 2'#170' via'
        OnClick = Demonstrativo2via1Click
      end
      object DadosdeEmpresa1: TMenuItem
        Caption = 'Dados da Empresa'
        OnClick = DadosdeEmpresa1Click
      end
      object PortadoresdeCartes1: TMenuItem
        Caption = 'Portadores de Cart'#245'es'
        OnClick = PortadoresdeCartes1Click
      end
    end
    object Sobre1: TMenuItem
      Caption = 'Sobre'
    end
    object Sair2: TMenuItem
      Caption = '&Sair'
      OnClick = Sair1Click
    end
  end
end
