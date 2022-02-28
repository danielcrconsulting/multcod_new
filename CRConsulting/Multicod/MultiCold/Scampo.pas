Unit Scampo;

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, SuGeral;

Type
  TSelCampo = Class(TForm)
    Campos: TStringGrid;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Procedure FormShow(Sender: TObject);
    Procedure CamposSelectCell(Sender: TObject; Col, Row: Longint;
      Var CanSelect: Boolean);
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

  TFooClass = Class(TControl);  {needed to get at protected font property }

Var
   SelCampo: TSelCampo;
  CampoSel : Byte;

Implementation

{$R *.DFM}

Uses
  MDIEdit, MDIMultiCold;

Procedure TSelCampo.FormShow(Sender: TObject);

Var
  I : Byte;
Begin
With Campos Do
  Begin
//  RowCount := TEditForm(FrameForm.ActiveMdiChild).DefChave.RowCount+1;
  RowCount := TEditForm(FrameForm.ActiveMdiChild).DefChave.RowCount;
  If RowCount > 1 Then
    FixedRows := 1;
  For I := 1 To RowCount-1 Do
    Begin
    Cells[0,I] := IntToStr(I);
    Cells[1,I] := TEditForm(FrameForm.ActiveMdiChild).DefChave.Cells[6,I];
    Cells[2,I] := TEditForm(FrameForm.ActiveMdiChild).DefChave.Cells[7,I];
    Cells[3,I] := TEditForm(FrameForm.ActiveMdiChild).DefChave.Cells[3,I];
    Cells[4,I] := TEditForm(FrameForm.ActiveMdiChild).DefChave.Cells[4,I];
    End;

  Cells[1,0] := 'Campo';
  Cells[2,0] := 'Tipo';
  Cells[3,0] := 'Col';
  Cells[4,0] := 'Tam';
  End;
CampoSel := 0;
End;

Procedure TSelCampo.CamposSelectCell(Sender: TObject; Col, Row: Longint;
  Var CanSelect: Boolean);
Begin
CampoSel := Row;
Close;
End;

Procedure TSelCampo.FormCreate(Sender: TObject);
Var
  I : Integer;
Begin
Exit;
If (Screen.Width > ScreenWidth) Then
  Begin
  scaled := true;
  height := longint(height) * longint(screen.height) Div ScreenHeight;
  width := longint(width) * longint(screen.width) Div ScreenWidth;
  scaleBy(Screen.Width, ScreenWidth);
  for I := ControlCount - 1 Downto 0 Do
    TFooClass(Controls[I]).Font .Size := (Width Div ScreenWidth) *
                                         TFooClass(Controls[i]).Font.Size;
  End;
End;

End.
