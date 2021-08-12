Unit Opera;

Interface

Uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, SysUtils, SuGeral;

Type
  TFormOpera = Class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GridOpera: TStringGrid;
    Procedure FormCreate(Sender: TObject);
    Procedure GridOperaSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    Procedure FormShow(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

  TFooClass = Class(TControl);  {needed to get at protected font property }

Var
  FormOpera: TFormOpera;
  CampoOperaSel : Byte;

Implementation

{$R *.DFM}

Procedure TFormOpera.FormCreate(Sender: TObject);
Var
  I : Integer;
Begin
For I := 1 To 17 Do
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
GridOpera.Cells[1,8] := 'IS';
GridOpera.Cells[2,8] := 'É';
GridOpera.Cells[1,9] := 'BETWEEN';
GridOpera.Cells[2,9] := 'Entre';
GridOpera.Cells[1,10] := 'LIKE';
GridOpera.Cells[2,10] := 'Parece';
GridOpera.Cells[1,11] := 'NOT =';
GridOpera.Cells[2,11] := 'Não igual';
GridOpera.Cells[1,12] := 'NOT >';
GridOpera.Cells[2,12] := 'Não maior';
GridOpera.Cells[1,13] := 'NOT <';
GridOpera.Cells[2,13] := 'Não menor';
GridOpera.Cells[1,14] := 'NOT >=';
GridOpera.Cells[2,14] := 'Não maior ou igual, menor';
GridOpera.Cells[1,15] := 'NOT <=';
GridOpera.Cells[2,15] := 'Não menor ou igual, maior';
GridOpera.Cells[1,16] := 'NOT IN';
GridOpera.Cells[2,16] := 'Não pertence';
GridOpera.Cells[1,17] := 'NOT BETWEEN';
GridOpera.Cells[2,17] := 'Não está entre';
GridOpera.Cells[1,18] := 'NOT LIKE';
GridOpera.Cells[2,18] := 'Não parece';
GridOpera.Cells[1,18] := 'IS NOT';
GridOpera.Cells[2,18] := 'Não é';
CampoOperaSel := 0;

Exit;

If (Screen.Width > ScreenWidth) Then
  Begin
  scaled := true;
  height := longint(height) * longint(screen.height) Div ScreenHeight;
  width := longint(width) * longint(screen.width) Div ScreenWidth;
  scaleBy(Screen.Width, ScreenWidth);
  For I := ControlCount - 1 Downto 0 Do
    TFooClass(Controls[I]).Font .Size := (Width Div ScreenWidth) *
                                         TFooClass(Controls[i]).Font.Size;
  End;
End;

Procedure TFormOpera.GridOperaSelectCell(Sender: TObject; Col,
  Row: Longint; Var CanSelect: Boolean);
Begin
CampoOperaSel := Row;
Close;
End;

Procedure TFormOpera.FormShow(Sender: TObject);
Begin
CampoOperaSel := 0;
End;

End.
