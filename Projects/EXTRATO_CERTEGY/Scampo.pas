unit Scampo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, SuGeral;

type
  TSelCampo = class(TForm)
    Campos: TStringGrid;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure CamposSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TFooClass = class(TControl);  {needed to get at protected font property }

var
  SelCampo: TSelCampo;
  CampoSel : Byte;

implementation

{$R *.DFM}

uses
  MDIEdit, MDIMultiCold;

procedure TSelCampo.FormShow(Sender: TObject);

Var
  I : Byte;
begin
With Campos do
  begin

  For I := 1 to TEditForm(FrameForm.ActiveMdiChild).DefChave.RowCount+1 do
    begin
    Cells[0,I] := IntToStr(I);
    Cells[1,I] := TEditForm(FrameForm.ActiveMdiChild).DefChave.Cells[6,I];
    Cells[2,I] := TEditForm(FrameForm.ActiveMdiChild).DefChave.Cells[7,I];
    Cells[3,I] := TEditForm(FrameForm.ActiveMdiChild).DefChave.Cells[3,I];
    end;

  Cells[1,0] := 'Campo';
  Cells[2,0] := 'Tipo';
  Cells[3,0] := 'Col';
  end;
CampoSel := 0;
end;

procedure TSelCampo.CamposSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
CampoSel := Row;
Close;
end;

procedure TSelCampo.FormCreate(Sender: TObject);

var
  I : Integer;
begin
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

end.
