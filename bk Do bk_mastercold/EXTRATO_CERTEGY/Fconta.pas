Unit Fconta;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, jpeg, ExtCtrls;

Type
  TContaForm = Class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit7: TEdit;
    Edit6: TEdit;
    Edit5: TEdit;
    Edit4: TEdit;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    Edit8: TEdit;
    Label9: TLabel;
    Edit9: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    Label11: TLabel;
    Edit11: TEdit;
    Label12: TLabel;
    Edit12: TEdit;
    Label13: TLabel;
    Edit13: TEdit;
    Label14: TLabel;
    Edit14: TEdit;
    Label15: TLabel;
    Edit15: TEdit;
    Label16: TLabel;
    Edit16: TEdit;
    Label17: TLabel;
    Edit17: TEdit;
    TabSheet3: TTabSheet;
    Label18: TLabel;
    Edit26: TEdit;
    Edit25: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Image1: TImage;
    NovaConsultaButton: TButton;
    SairButton: TButton;
    Label27: TLabel;
    EditOrg: TEdit;
    Label28: TLabel;
    EditLogo: TEdit;
    EditConta: TEdit;
    Label29: TLabel;
    Label30: TLabel;
    EditNome: TEdit;
    Label1: TLabel;
    TabSheet4: TTabSheet;
    Label33: TLabel;
    Edit28: TEdit;
    Label32: TLabel;
    Edit27: TEdit;
    Label31: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit1: TEdit;
    Image2: TImage;
    procedure SairButtonClick(Sender: TObject);
    procedure NovaConsultaButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  ContaForm: TContaForm;

Implementation

{$R *.DFM}

Uses SuGeral, Subrug, SelCont, PortaCartU;

Procedure TContaForm.NovaConsultaButtonClick(Sender: TObject);
Begin
Selecons.Show;
If SubForm = 'EMPRESARIAL3' Then
  PortaForm.Show;
Close;
End;

Procedure TContaForm.SairButtonClick(Sender: TObject);
Begin
Selecons.Close;
PortaForm.Close;
Close;
End;

Procedure TContaForm.FormCreate(Sender: TObject);
Begin
Label1.Caption := '';
End;

Procedure TContaForm.FormShow(Sender: TObject);
Begin
If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL2') Or (SubForm = 'EMPRESARIAL2') Then
  Begin
  TabSheet2.Caption := 'Endereço 1';
  TabSheet3.Caption := 'Endereço 2';
  End
Else
  Begin
  TabSheet2.Caption := 'Residencial';
  TabSheet3.Caption := 'Comercial';
  End;
End;

End.
