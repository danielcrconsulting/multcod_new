unit Opera;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, SysUtils, SuGeral;

type
  TFormOpera = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GridOpera: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure GridOperaSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TFooClass = class(TControl);  {needed to get at protected font property }

var
  FormOpera: TFormOpera;
  CampoOperaSel : Byte;

implementation

{$R *.DFM}

procedure TFormOpera.FormCreate(Sender: TObject);
Var
  I : Integer;
begin
For I := 1 to 17 do
  GridOpera.Cells[0,I] := IntToStr(I);
GridOpera.Cells[1,1] := '=';
GridOpera.Cells[2,1] := 'Igual';
GridOpera.Cells[1,2] := '>';
GridOpera.Cells[2,2] := 'Maior';
GridOpera.Cells[1,3] := '<';
GridOpera.Cells[2,3] := 'Menor';
GridOpera.Cells[1,4] := '>=';
GridOpera.Cells[2,4] := 'Maior ou igual';
GridOpera.Cells[1,5] := '<=';
GridOpera.Cells[2,5] := 'Menor ou igual';
GridOpera.Cells[1,6] := '<>';
GridOpera.Cells[2,6] := 'Diferente';
GridOpera.Cells[1,7] := 'IN';
GridOpera.Cells[2,7] := 'Pertence';
GridOpera.Cells[1,8] := 'BETWEEN';
GridOpera.Cells[2,8] := 'Entre';
GridOpera.Cells[1,9] := 'LIKE';
GridOpera.Cells[2,9] := 'Parece';
GridOpera.Cells[1,10] := 'NOT =';
GridOpera.Cells[2,10] := 'Não igual';
GridOpera.Cells[1,11] := 'NOT >';
GridOpera.Cells[2,11] := 'Não maior';
GridOpera.Cells[1,12] := 'NOT <';
GridOpera.Cells[2,12] := 'Não menor';
GridOpera.Cells[1,13] := 'NOT >=';
GridOpera.Cells[2,13] := 'Não maior ou igual, menor';
GridOpera.Cells[1,14] := 'NOT <=';
GridOpera.Cells[2,14] := 'Não menor ou igual, maior';
GridOpera.Cells[1,15] := 'NOT IN';
GridOpera.Cells[2,15] := 'Não pertence';
GridOpera.Cells[1,16] := 'NOT BETWEEN';
GridOpera.Cells[2,16] := 'Não está entre';
GridOpera.Cells[1,17] := 'NOT LIKE';
GridOpera.Cells[2,17] := 'Não parece';
CampoOperaSel := 0;

Exit;

if (Screen.Width > ScreenWidth) then
  begin
  scaled := true;
  height := longint(height) * longint(screen.height) div ScreenHeight;
  width := longint(width) * longint(screen.width) div ScreenWidth;
  scaleBy(Screen.Width, ScreenWidth);
  for I := ControlCount - 1 downto 0 do
    TFooClass(Controls[I]).Font .Size := (Width div ScreenWidth) *
                                         TFooClass(Controls[i]).Font.Size;
  end;
end;

procedure TFormOpera.GridOperaSelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
CampoOperaSel := Row;
Close;
end;

procedure TFormOpera.FormShow(Sender: TObject);
begin
CampoOperaSel := 0;
end;

end.
