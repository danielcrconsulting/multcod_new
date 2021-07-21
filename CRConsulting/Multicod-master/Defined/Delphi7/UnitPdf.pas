unit UnitPdf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, AcroPDFLib_TLB;

type
  TForm2 = class(TForm)
    AcroPDF1: TAcroPDF;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormResize(Sender: TObject);
Var
  xyRect : TRect;
begin
{xyRect := Form2.GetClientRect;
AcroPDF1.Width := xyRect.Right;
AcroPDF1.Height := xyRect.Bottom;
AcroPDF1.setViewRect(AcroPDF1.Left, AcroPDF1.Top, AcroPDF1.Width, AcroPDF1.Height);}
//Acropdf1.printWithDialog;
end;

end.
