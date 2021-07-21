Unit AuxFormUnit;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

Type
  TAuxForm = Class(TForm)
    GridPesq: TStringGrid;
    Memo1: TMemo;
    ProcurNaMesma: TCheckBox;
    ProcurSeq: TCheckBox;
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Implementation

{$R *.dfm}

End.
