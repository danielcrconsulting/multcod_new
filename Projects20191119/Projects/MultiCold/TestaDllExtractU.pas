Unit TestaDllExtractU;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MextrUnit1;

Type
  TForm1 = Class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    Edit4: TEdit;
    Procedure Edit1DblClick(Sender: TObject);
    Procedure Edit2DblClick(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

{$R *.dfm}

Procedure TForm1.Edit1DblClick(Sender: TObject);
Begin
OpenDialog1.Filter := '*.xtr|*.xtr';
If OpenDialog1.Execute Then
  Begin
  Edit1.Text := OpenDialog1.FileName;
  End;
End;

Procedure TForm1.Edit2DblClick(Sender: TObject);
Begin
OpenDialog1.Filter := '*.dat|*.dat';
If OpenDialog1.Execute Then
  Begin
  Edit2.Text := OpenDialog1.FileName;
  End;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Var
  Semaforo : System.Text;
Begin  
//Edit1.Text := ParamStr(1);
//Edit2.Text := ParamStr(2);
//Edit3.Text := ParamStr(3);
//Edit4.Text := ParamStr(4);
Application.ProcessMessages;
MultiExtract(PChar(Edit2.Text),PChar(Edit1.Text),PChar(Edit3.Text));
//AssignFile(Semaforo, Edit4.Text);
//ReWrite(Semaforo);
//WriteLn(Semaforo,Edit1.Text);
//WriteLn(Semaforo,Edit2.Text);
//WriteLn(Semaforo,Edit3.Text);
//WriteLn(Semaforo,Edit4.Text);
//WriteLn(Semaforo,'Extração Concluída...');
ShowMessage('Fim...');
//CloseFile(Semaforo);
End;

End.
