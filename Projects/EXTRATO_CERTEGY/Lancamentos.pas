Unit Lancamentos;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, jpeg, ExtCtrls;

Type
  TLancamentosForm = Class(TForm)
    Image1: TImage;
    Label4: TLabel;
    Label6: TLabel;
    Label29: TLabel;
    EditOrg: TEdit;
    Label5: TLabel;
    EditLogo: TEdit;
    EditConta: TEdit;
    EditNome: TEdit;
    StringGrid1: TStringGrid;
    SairButton: TButton;
    NovaConsultaButton: TButton;
    Image2: TImage;
    Procedure NovaConsultaButtonClick(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  LancamentosForm: TLancamentosForm;

Implementation

Uses FExtr, SelCont;

{$R *.DFM}

Procedure TLancamentosForm.NovaConsultaButtonClick(Sender: TObject);
Begin
ExtrForm.Show;
Close;
End;

Procedure TLancamentosForm.SairButtonClick(Sender: TObject);
Begin
ExtrForm.Close;
Selecons.Close;
Close;
End;

Procedure TLancamentosForm.FormCreate(Sender: TObject);
Begin
StringGrid1.Cells[0,0] := 'Org';
StringGrid1.Cells[1,0] := 'Logo';
StringGrid1.Cells[2,0] := 'Conta';
StringGrid1.Cells[3,0] := 'AnoMes';
StringGrid1.Cells[4,0] := 'Ciclo';
StringGrid1.Cells[5,0] := 'Cartao';
StringGrid1.Cells[6,0] := 'DataTrans';
StringGrid1.Cells[7,0] := 'Seq';
StringGrid1.Cells[8,0] := 'Cartao2';
StringGrid1.Cells[9,0] := 'Historico';
StringGrid1.Cells[10,0] := 'Moeda';
StringGrid1.Cells[11,0] := 'MoedaOrig';
StringGrid1.Cells[12,0] := 'Valor';
StringGrid1.Cells[13,0] := 'NumRef';
StringGrid1.Width := Screen.Width-20;
End;

End.
