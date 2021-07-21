unit UnitRelUsuRel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, frxDBSet, frxExportPDF,
  frxExportCSV, frxExportText, frxExportRTF;

type
  TUsuRelRepForm = class(TForm)
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxCSVExport1: TfrxCSVExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    frxRTFExport1: TfrxRTFExport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UsuRelRepForm: TUsuRelRepForm;

implementation

{$R *.dfm}

end.
