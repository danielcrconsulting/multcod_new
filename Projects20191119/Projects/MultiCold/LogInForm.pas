Unit LogInForm;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OleCtrls, Subrug, Sugeral;

Type
  TLogInRemotoForm = Class(TForm)
    UsuEdit: TEdit;
    PassEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    URLEdit: TComboBox;
    OkButton: TButton;
    CancelButton: TButton;
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure UsuEditKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  LogInRemotoForm: TLogInRemotoForm;

Implementation

{$R *.DFM}

Procedure TLogInRemotoForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
If ModalResult <> mrOK Then
  ModalResult := mrCancel;
End;

Procedure TLogInRemotoForm.UsuEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
Case Key Of
  13,
  40 : SelectNext(ActiveControl,True,True);
  38 : SelectNext(ActiveControl,False,True);
  End; // Case
End;

Procedure TLogInRemotoForm.FormShow(Sender: TObject);
Begin
//URLEdit.Text := URLEdit.Items[0];
URLEdit.Items.Clear;
URLEdit.Items.Add(urlRemoteServer);
URLEdit.Text := urlRemoteServer;
if trim(RemoteUser) <> '' then
  begin
  UsuEdit.Text := Copy(RemoteUser,1,Pos('/',RemoteUser)-1);
  PassEdit.Text := Copy(RemoteUser,Pos('/',RemoteUser)+1,length(RemoteUser));
  end
else
  begin
  UsuEdit.Text := UpperCase(GetCurrentUserName);
  PassEdit.Text := '';
  end;
//PassEdit.SetFocus;
//OkButton.Click;
End;

End.
