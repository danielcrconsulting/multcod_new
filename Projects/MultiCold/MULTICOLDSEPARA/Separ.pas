Unit Separ;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADOdb, ExtCtrls;

Type
  TFormSepar = Class(TForm)
    Panel1: TPanel;
    ButtonExecutar: TButton;
    Panel2: TPanel;
    Memo1: TMemo;
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormSepar: TFormSepar;

Implementation

Uses
  ConfigProc, Subrug, SuGeral, SuTypGer, Index;

{$R *.DFM}

End.
