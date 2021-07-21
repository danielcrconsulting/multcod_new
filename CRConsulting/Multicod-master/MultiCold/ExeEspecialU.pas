Unit ExeEspecialU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SuGeral;

Type
  TExecutarEspecial = Class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    ExportarBut: TButton;
    AbrirBut: TButton;
    ImprimirBut: TButton;
    procedure ExportarButClick(Sender: TObject);
    procedure AbrirButClick(Sender: TObject);
    procedure ImprimirButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public

    { Public declarations }

  End;

Var
  ExecutarEspecial: TExecutarEspecial;

Implementation

{$R *.DFM}

Procedure TExecutarEspecial.ExportarButClick(Sender: TObject);
Begin
If ListBox1.SelCount = 0 Then
  Begin
  ShowMessage('Nenhum período selecionado');
  Exit;
  End;
Abrir := False;
Exportar := True;
Imprimir := False;
Close;
End;

Procedure TExecutarEspecial.AbrirButClick(Sender: TObject);
Begin
If ListBox1.SelCount = 0 Then
  Begin
  ShowMessage('Nenhum período selecionado');
  Exit;
  End;
Abrir := True;  
Exportar := False;
Imprimir := False;
Close;
End;

Procedure TExecutarEspecial.ImprimirButClick(Sender: TObject);
Begin
If ListBox1.SelCount = 0 Then
  Begin
  ShowMessage('Nenhum período selecionado');
  Exit;
  End;
Abrir := False;
Exportar := False;
Imprimir := True;
Close;
End;

Procedure TExecutarEspecial.FormCreate(Sender: TObject);
Begin
ListBox1.Clear;
End;

End.
