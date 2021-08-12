unit LogInForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, OleCtrls, XceedZipLib_TLB;

type
  TLogInRemotoForm = class(TForm)
    UsuEdit: TEdit;
    PassEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OkButton: TButton;
    CancelButton: TButton;
    Label3: TLabel;
    Label4: TLabel;
    URLEdit: TComboBox;
    procedure OkButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UsuEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogInRemotoForm: TLogInRemotoForm;

implementation

{$R *.DFM}

procedure TLogInRemotoForm.OkButtonClick(Sender: TObject);
begin
ModalResult := mrOK;
end;

procedure TLogInRemotoForm.CancelButtonClick(Sender: TObject);
begin
ModalResult := mrCancel;
end;

procedure TLogInRemotoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if ModalResult <> mrOK then
  ModalResult := mrCancel;
end;

procedure TLogInRemotoForm.UsuEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Case Key of
  13,
  40 : SelectNext(ActiveControl,True,True);
  38 : SelectNext(ActiveControl,False,True);
End; // Case  
end;

end.
