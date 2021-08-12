Unit PortaCartU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, jpeg, ExtCtrls;

Type
  TPortaForm = Class(TForm)
    Label4: TLabel;
    EditOrg: TEdit;
    Label5: TLabel;
    EditLogo: TEdit;
    Label6: TLabel;
    EditConta: TEdit;
    Label29: TLabel;
    EditNome: TEdit;
    Image1: TImage;
    StringGrid1: TStringGrid;
    NovaConsultaButton: TButton;
    SairButton: TButton;
    Label1: TLabel;
    EditCgc: TEdit;
    Image2: TImage;
    Procedure NovaConsultaButtonClick(Sender: TObject);
    Procedure SairButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  PortaForm: TPortaForm;

Implementation

uses SelCont, Fconta;

{$R *.DFM}

Procedure TPortaForm.NovaConsultaButtonClick(Sender: TObject);
Begin
Selecons.Show;
Close;
End;

Procedure TPortaForm.SairButtonClick(Sender: TObject);
Begin
Selecons.Close;
Close;
End;

Procedure TPortaForm.FormCreate(Sender: TObject);
Begin
StringGrid1.Cells[0,0] := 'CONTA';
StringGrid1.Cells[1,0] := 'CARTÃO';
StringGrid1.Cells[2,0] := 'NOME';
StringGrid1.Cells[3,0] := 'STATUS';
End;

Procedure TPortaForm.StringGrid1DblClick(Sender: TObject);
Begin
Selecons.MontaConta(StrToInt64(Trim(StringGrid1.Cells[0,StringGrid1.Row])));
With ContaForm Do
  Selecons.PreencheCabecalho(EditOrg, EditLogo, EditConta, EditNome, 19);
End;

End.
