Unit JaConfU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

Type
  TJaConf = Class(TForm)
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  JaConf: TJaConf;

Implementation

{$R *.DFM}

Uses
  SuGeral;

Procedure TJaConf.Button1Click(Sender: TObject);
Begin
Close;
End;

Procedure TJaConf.FormCreate(Sender: TObject);
Begin
FormGeral.LerIni;
Edit1.Text := viLimpEntra;
Edit2.Text := viLimpSai;
End;

End.
