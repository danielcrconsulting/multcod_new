Unit ConfigProc;

//Revisado SQLServer...

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, Inifiles, Sugeral;

Type
  TConfig = Class(TForm)
    CDirBackAutoEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    CFormExtAutoEdit: TEdit;
    Label3: TLabel;
    OkButton: TButton;
    CInterExecSegEdit: TMaskEdit;
    Label4: TLabel;
    CBackAutoSNEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    CExecAutoSNEdit: TEdit;
    CExtAutoSNEdit: TEdit;
    Label7: TLabel;
    CSeparacaoAutoSNEdit: TEdit;
    Label8: TLabel;
    CDecDoCaracEdit: TEdit;
    Label9: TLabel;
    CColDoCaracEdit: TEdit;
    Label10: TLabel;
    CLimpaAutoSNEdit: TEdit;
    Procedure OkButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    { Private declarations }
  Public
    { Public declarations }
  Procedure CarregaDados;

  End;

Var
  Config: TConfig;
  ArqConfig : System.Text;
  LinConf1,
  LinConf2,
  LinConf3 : AnsiString;

Implementation

//uses CtrlFiltro;

{$R *.DFM}

Procedure TConfig.OkButtonClick(Sender: TObject);
Begin
Close;
End;

Procedure TConfig.CarregaDados;
Begin
CBackAutoSNEdit.Text := viBackAutoSN;
CDirBackAutoEdit.Text := viDirBackAuto;
CExecAutoSNEdit.Text := viExecAutoSN;
CInterExecSegEdit.Text := viInterExecSeg;
CExtAutoSNEdit.Text := viExtAutoSN;
CFormExtAutoEdit.Text := viFormExtAuto;
CSeparacaoAutoSNEdit.Text := viSeparacaoAutoSN;
CDecDoCaracEdit.Text := viDecDoCarac;
CColDoCaracEdit.Text := viColDoCarac;
CLimpaAutoSNEdit.Text := viLimpaAutoSN;
End;

procedure TConfig.FormCreate(Sender: TObject);
begin
Config.Visible := false;
end;

procedure TConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Config.Visible := false;
end;

End.
