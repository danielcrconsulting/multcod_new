unit Conec;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Grids, SuGeral;

type
  TFormConec = class(TForm)
    GridConec: TStringGrid;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure GridConecSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TFooClass = class(TControl);  {needed to get at protected font property }

var
  FormConec: TFormConec;
  CampoConecSel : Byte;

implementation

{$R *.DFM}

procedure TFormConec.FormCreate(Sender: TObject);
Var
  I : Integer;
begin
For I := 1 to 1 do
  GridConec.Cells[0,I] := IntToStr(I);
GridConec.Cells[1,1] := 'AND';
GridConec.Cells[1,2] := 'OR';
CampoConecSel := 0;
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

procedure TFormConec.GridConecSelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
CampoConecSel := Row;
Close;
end;

procedure TFormConec.FormShow(Sender: TObject);
begin
CampoConecSel := 0;
end;

end.
