Unit Fcartao;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls;

Type
  TCartaoForm = Class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    NovaConsultaButton: TButton;
    SairButton: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label17: TLabel;
    Edit8: TEdit;
    Edit6: TEdit;
    Edit5: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label27: TLabel;
    EditOrg: TEdit;
    Label28: TLabel;
    EditLogo: TEdit;
    EditConta: TEdit;
    EditNome: TEdit;
    Label30: TLabel;
    Label29: TLabel;
    Label2: TLabel;
    Edit9: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Label7: TLabel;
    Edit3: TEdit;
    procedure NovaConsultaButtonClick(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  CartaoForm: TCartaoForm;

Implementation

Uses SelCont, SuGeral, Subrug;

{$R *.DFM}

Procedure TCartaoForm.NovaConsultaButtonClick(Sender: TObject);
Begin
Selecons.Show;
Close;
End;

Procedure TCartaoForm.SairButtonClick(Sender: TObject);
Begin
Selecons.Close;
Close;
End;

End.
