Unit MapaFilU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls;

Type
  TMapaFil = Class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  MapaFil: TMapaFil;

Implementation

Uses
  SuGeral;

{$R *.DFM}

Procedure TMapaFil.Button1Click(Sender: TObject);
Var
  I : Integer;
Begin
For I := 0 To 255 Do
  Try
    RegMapa[I] := StrToInt(StringGrid1.Cells[1,I+1]);
  Except
    ShowMessage('Decimal inválido no mapa, reveja');
    Exit;
    End; // Try
AssignFile(ArqMapa,viDirTrabApl+'\'+'MapaFiltro.Dat');
ReWrite(ArqMapa);
Write(ArqMapa,RegMapa);
CloseFile(ArqMapa);
Close;
End;

Procedure TMapaFil.Button2Click(Sender: TObject);
Begin
Close;
End;

Procedure TMapaFil.FormShow(Sender: TObject);
Var
  I : Integer;
Begin
AssignFile(ArqMapa,viDirTrabApl+'\'+'MapaFiltro.Dat');
Try
  Reset(ArqMapa);
Except
  For I := 0 To 255 Do
    If Chr(I) In [#10,#13,' '..'}'] Then
      RegMapa[I] := I
    Else
      RegMapa[I] := Ord(' ');
  ReWrite(ArqMapa);
  Write(ArqMapa, RegMapa);
  Reset(ArqMapa);       
  End; // Try


StringGrid1.Cells[0,0] := 'Decimal de Entrada';
StringGrid1.Cells[1,0] := 'Decimal de Saida';
StringGrid1.Cells[2,0] := 'Caracter de Saida';

Read(ArqMapa,RegMapa);

For I := 0 To 255 Do
  Begin
  StringGrid1.Cells[0,I+1] := Format('%3.3d',[I]);
  StringGrid1.Cells[1,I+1] := Format('%3.3d',[RegMapa[I]]);
  StringGrid1.Cells[2,I+1] := '''' + Chr(RegMapa[I]) + '''';
  End;

CloseFile(ArqMapa);
End;

Procedure TMapaFil.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; Const Value: String);
Begin
//ShowMessage('Este é o texto: '+Value+' '+IntToStr(ACol)+' '+IntToStr(ARow));
If ARow = 0 Then
  Exit;
If ACol = 1 Then
  Try
    StringGrid1.Cells[ACol+1,ARow] := '''' + Chr(StrToInt(Value)) + '''';
  Except
  End // Try
Else
  Try
    StringGrid1.Cells[ACol-1,ARow] := Format('%3.3d',[Ord(Value[2])]);
  Except
  End // Try

End;

End.
