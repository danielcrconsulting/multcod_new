Unit ConfigProc;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, Inifiles;

Type
  TConfig = Class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OkToSave: TButton;
    Edit2: TMaskEdit;
    Label4: TLabel;
    BackAutoEdit: TEdit;
    Label5: TLabel;
    ExecAutoEdit: TEdit;
    Procedure FormCreate(Sender: TObject);
    Procedure OkToSaveClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Config: TConfig;
  ArqConfig : System.Text;
  LinConf1,
  LinConf2,
  LinConf3 : String;

Implementation

{$R *.DFM}

Uses
  SuGeral;

Procedure TConfig.FormCreate(Sender: TObject);
Begin
BackAutoEdit.Text := viBackAutoSN;
Edit1.Text := viDirBackAuto;
ExecAutoEdit.Text := viExecAutoSN;
Edit2.Text := viInterExec;
End;

Procedure TConfig.OkToSaveClick(Sender: TObject);
Begin
Close;
End;

End.
