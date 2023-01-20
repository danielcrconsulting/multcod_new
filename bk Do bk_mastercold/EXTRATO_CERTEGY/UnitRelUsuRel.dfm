object UsuRelRepForm: TUsuRelRepForm
  Left = 0
  Top = 0
  Caption = 'Relat'#243'rio de Usu'#225'rios e permiss'#245'es'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object frxReport1: TfrxReport
    Version = '4.13.2'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42417.373646631900000000
    ReportOptions.LastChange = 42419.553026574070000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 24
    Top = 16
    Datasets = <
      item
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object MasterData1: TfrxMasterData
        Height = 37.795275590000000000
        Top = 170.078850000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        object frxDBDataset1CODUSUARIO: TfrxMemoView
          Left = 3.779530000000000000
          Top = 7.559060000000000000
          Width = 158.740260000000000000
          Height = 18.897637800000000000
          ShowHint = False
          DataField = 'CODUSUARIO'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.UTF8W = (
            '[frxDBDataset1."CODUSUARIO"]')
        end
        object frxDBDataset1CODGRUPO: TfrxMemoView
          Left = 230.551330000000000000
          Top = 7.559060000000000000
          Width = 79.370130000000000000
          Height = 18.897637795275590000
          ShowHint = False
          DataField = 'CODGRUPO'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.UTF8W = (
            '[frxDBDataset1."CODGRUPO"]')
        end
        object frxDBDataset1CODSUBGRUPO: TfrxMemoView
          Left = 332.598640000000000000
          Top = 7.559060000000000000
          Width = 79.370130000000000000
          Height = 18.897637795275590000
          ShowHint = False
          DataField = 'CODSUBGRUPO'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.UTF8W = (
            '[frxDBDataset1."CODSUBGRUPO"]')
        end
        object frxDBDataset1CODREL: TfrxMemoView
          Left = 521.575140000000000000
          Top = 7.559060000000000000
          Width = 120.944960000000000000
          Height = 18.897637795275590000
          ShowHint = False
          DataField = 'CODREL'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.UTF8W = (
            '[frxDBDataset1."CODREL"]')
        end
        object frxDBDataset1TIPO: TfrxMemoView
          Left = 668.976810000000000000
          Top = 7.559060000000000000
          Width = 41.574803150000000000
          Height = 18.897637795275590000
          ShowHint = False
          DataField = 'TIPO'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.UTF8W = (
            '[frxDBDataset1."TIPO"]')
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 90.708720000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo7: TfrxMemoView
          Left = 105.826840000000000000
          Top = 3.779530000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[Time]')
        end
        object Memo8: TfrxMemoView
          Left = 3.779530000000000000
          Top = 3.779530000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[Date]')
        end
        object Memo9: TfrxMemoView
          Left = 238.110390000000000000
          Top = 22.677180000000000000
          Width = 226.771800000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'USU'#193'RIOS VERSUS RELAT'#211'RIOS')
        end
        object Memo10: TfrxMemoView
          Left = 668.976810000000000000
          Top = 22.677180000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[Page]')
        end
        object Memo11: TfrxMemoView
          Left = 230.551183540000000000
          Top = 52.913420000000000000
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'GRUPO')
        end
        object Memo12: TfrxMemoView
          Left = 332.598640000000000000
          Top = 52.913371180000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'SUBGRUPO')
        end
        object Memo13: TfrxMemoView
          Left = 521.575140000000000000
          Top = 52.913420000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'RELAT'#211'RIO')
        end
        object Memo14: TfrxMemoView
          Left = 668.976810000000000000
          Top = 52.913420000000000000
          Width = 75.590551180000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'TIPO')
        end
        object Line3: TfrxLineView
          Top = 41.574830000000000000
          Width = 721.890230000000000000
          ShowHint = False
          Frame.Typ = [ftTop]
        end
        object Memo15: TfrxMemoView
          Left = 3.779530000000000000
          Top = 52.913420000000000000
          Width = 64.252010000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8W = (
            'USU'#193'RIO')
        end
        object Line4: TfrxLineView
          Top = 79.370130000000000000
          Width = 721.890230000000000000
          ShowHint = False
          Frame.Typ = [ftTop]
        end
      end
    end
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    DataSet = FormGeral.TableUsuRel
    BCDToCurrency = False
    Left = 24
    Top = 72
  end
  object frxCSVExport1: TfrxCSVExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = True
    DataOnly = True
    Separator = ';'
    OEMCodepage = False
    NoSysSymbols = True
    ForcedQuotes = False
    Left = 24
    Top = 128
  end
  object frxSimpleTextExport1: TfrxSimpleTextExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = True
    DataOnly = True
    PageBreaks = False
    Frames = False
    EmptyLines = False
    OEMCodepage = False
    DeleteEmptyColumns = True
    Left = 24
    Top = 184
  end
  object frxRTFExport1: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = True
    DataOnly = True
    PictureType = gpPNG
    ExportPageBreaks = False
    ExportPictures = False
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = True
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 144
    Top = 24
  end
end
