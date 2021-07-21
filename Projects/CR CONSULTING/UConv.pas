unit UConv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    procedure Edit1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
Var
  ArqIn,
  ArqOut : System.Text;
  LinhaIn,
  LinhaOut : AnsiString;
  Cur,
  Cont : Integer;

begin

if Edit1.Text = '' then
  begin
  ShowMessage('Informe um nome de arquivo...');
  Exit;
  end;

Label5.Caption := '0 Linhas Processadas';
Label5.Visible := True;
Application.ProcessMessages;

Cur := Screen.Cursor;
Screen.Cursor := crHourGlass;

AssignFile(ArqIn, Edit1.Text);
AssignFile(ArqOut,ChangeFileExt(Edit1.Text,'_X.ICC'));
Reset(ArqIn);
ReWrite(ArqOut);

Cont := 0;

While Not Eof(ArqIn) Do
  Begin
  ReadLn(ArqIn, LinhaIn);

  if Copy(LinhaIn, StrToInt(Edit5.Text), Length(Edit4.Text)) = Edit4.Text then
    LinhaOut := Edit2.Text + LinhaIn
  else
    LinhaOut := ' ' + LinhaIn;

  WriteLn(ArqOut,LinhaOut);
  Inc(Cont);
  if (Cont Mod 5000) = 0 then
    begin
      Label5.Caption := IntToStr(Cont) + ' Linhas Processadas';
      Application.ProcessMessages;
    end;
  End;

CloseFile(ArqIn);
CloseFile(ArqOut);

Screen.Cursor := Cur;

Label5.Caption := IntToStr(Cont) + ' Linhas Processadas';
Application.ProcessMessages;

ShowMessage('Fim de conversão...');

Label5.Caption := '';
Application.ProcessMessages;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Edit1DblClick(Sender: TObject);

begin
If OpenDialog1.Execute Then
  Edit1.Text := OpenDialog1.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Label5.Caption := '';
end;

end.
