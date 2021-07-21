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
    Button2: TButton;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Label5: TLabel;
    procedure Edit1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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

  Procedure UnsrCart;
  Begin
  While Not Eof(ArqIn) Do
    Begin
    ReadLn(ArqIn,LinhaIn);
    LinhaOut := Copy(LinhaIn, 1, 2) + Copy(LinhaIn, 5, 3) + Copy(LinhaIn, 12, 3) + Copy(LinhaIn, 15, Length(LinhaIn)-14);
    WriteLn(ArqOut,LinhaOut);
    Inc(Cont);
    if (Cont Mod 5000) = 0 then
      begin
        Label5.Caption := IntToStr(Cont) + ' Linhas Processadas';
        Application.ProcessMessages;
      end;
    End;
  End;

  Procedure UnsrCont;
  Begin
  While Not Eof(ArqIn) Do
    Begin
    ReadLn(ArqIn,LinhaIn);
    LinhaOut := Copy(LinhaIn, 1, 2) + Copy(LinhaIn, 5, 3) + Copy(LinhaIn, 12, 3) + Copy(LinhaIn, 15, Length(LinhaIn)-14);
    LinhaOut := Copy(LinhaOut,1, 208) + Copy(LinhaOut, 210, 112) + Copy(LinhaOut, 323, 28);
    WriteLn(ArqOut,LinhaOut);
    Inc(Cont);
    if (Cont Mod 5000) = 0 then
      begin
        Label5.Caption := IntToStr(Cont) + ' Linhas Processadas';
        Application.ProcessMessages;
      end;
    End;
  End;

  Procedure UnsDetex;
  Begin
  While Not Eof(ArqIn) Do
    Begin
    ReadLn(ArqIn,LinhaIn);
    LinhaOut := Copy(LinhaIn, 1, 2) + Copy(LinhaIn, 5, 3) + Copy(LinhaIn, 12, 3) + Copy(LinhaIn, 15, Length(LinhaIn)-14);
    WriteLn(ArqOut,LinhaOut);
    Inc(Cont);
    if (Cont Mod 5000) = 0 then
      begin
        Label5.Caption := IntToStr(Cont) + ' Linhas Processadas';
        Application.ProcessMessages;
      end;
    End;
  End;

  Procedure UnsExtr;
  Begin
  While Not Eof(ArqIn) Do
    Begin
    ReadLn(ArqIn,LinhaIn);
    LinhaOut := Copy(LinhaIn, 1, 2) + Copy(LinhaIn, 5, 3) + Copy(LinhaIn, 12, 3) + Copy(LinhaIn, 15, Length(LinhaIn)-14);
    WriteLn(ArqOut,LinhaOut);
    Inc(Cont);
    if (Cont Mod 5000) = 0 then
      begin
        Label5.Caption := IntToStr(Cont) + ' Linhas Processadas';
        Application.ProcessMessages;
      end;
    End;
  End;

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
AssignFile(ArqOut,ChangeFileExt(Edit1.Text,'_Cnv.Txt'));
Reset(ArqIn);
ReWrite(ArqOut);

Cont := 0;

If Pos('CART',UpperCase(Edit1.Text)) <> 0 Then
  UnsrCart;

If Pos('CONT',UpperCase(Edit1.Text)) <> 0 Then
  UnsrCont;

If Pos('DETEX',UpperCase(Edit1.Text)) <> 0 Then
  UnsDetex;

If Pos('EXTR',UpperCase(Edit1.Text)) <> 0 Then
  UnsExtr;

CloseFile(ArqIn);
CloseFile(ArqOut);

Screen.Cursor := Cur;

Label5.Caption := IntToStr(Cont) + ' Linhas Processadas';
Application.ProcessMessages;

ShowMessage('Fim de conversão...');

Label5.Caption := '';
Application.ProcessMessages;

end;

procedure TForm1.Button2Click(Sender: TObject);
Var
  ArqIn,
  ArqOut : System.Text;
  LinhaIn,
  LinhaOut : AnsiString;
  Cur,
  Posic,
  Cont : Integer;
begin

if Edit1.Text = '' then
  begin
  ShowMessage('Informe um nome de arquivo...');
  Exit;
  end;

Edit3.Text := IntToStr(StrToInt(Edit3.Text));
Posic := StrToInt(Edit3.Text);

Label5.Caption := '0 Linhas Processadas';
Label5.Visible := True;
Application.ProcessMessages;

Cur := Screen.Cursor;
Screen.Cursor := crHourGlass;

AssignFile(ArqIn, Edit1.Text);
AssignFile(ArqOut,ChangeFileExt(Edit1.Text,'_Cnv.Txt'));
Reset(ArqIn);
ReWrite(ArqOut);
Cont := 0;

While Not Eof(ArqIn) Do
  Begin
  ReadLn(ArqIn,LinhaIn);
  LinhaOut := Copy(LinhaIn, 1, Posic-1) + AnsiString(Edit2.Text) +
             Copy(LinhaIn, Posic+Length(Edit2.Text), Length(LinhaIn) + 1 - Posic - Length(Edit2.Text));
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

ShowMessage('Fim de troca...');

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

end.
