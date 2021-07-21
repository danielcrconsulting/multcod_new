unit UnitMultiplicador;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    Edit4: TEdit;
    procedure Edit1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PdfBuffer : Pointer;
  Buf : Array[1..10000] Of Array[1..116425] of char;

implementation

{$R *.dfm}

procedure TForm1.Edit1DblClick(Sender: TObject);
begin
If OpenDialog1.Execute Then
  Edit1.Text := OpenDialog1.FileName;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  Pdf : File;
  Resultado,
  Seq, I,
  TamBuf: Integer;
  Linha : String;
begin
AssignFile(Pdf, Edit1.Text);
Reset(Pdf, 1);
GetMem(PdfBuffer, FIleSize(Pdf));
TamBuf := FileSize(Pdf);
//ShowMessage(IntToStr(TamBuf));
BlockRead(Pdf, PdfBuffer^, FileSize(Pdf), Resultado);
CloseFile(Pdf);
Seq := StrToInt(Edit2.Text);
//Seq := Seq + 100000;
//For I := 100001 To Seq Do
Linha := 'PdfsBloc';
Linha := IncludeTrailingBackSlash(Edit3.Text)+Linha+'.x';
AssignFile(Pdf, Linha);
Rewrite(Pdf, 1);
For I := 1 to 10000 Do
  Move(PdfBuffer^, Buf[I], 116425);
For I := 1 To Seq Do
  Begin
//  Linha := Format('%8.8d', [I]);
//  If (I Mod 2) = 0 Then
//    Linha := IncludeTrailingBackSlash(Edit3.Text)+Linha+'.pdf'
//  Else
//  Linha := 'F:\Pdf_Real\1000000Blocado'+Linha+'.pdf';
//  AssignFile(Pdf, Linha);
//  Rewrite(Pdf, 1);
//  BlockWrite(Pdf, PdfBuffer^, Resultado);
  BlockWrite(Pdf, Buf, 1164250000);
//  CloseFile(Pdf);
  Edit4.Text := IntToStr(I);
  Application.ProcessMessages;
  End;

CloseFile(Pdf);
ShowMessage('Feito');

FreeMem(PdfBuffer);
end;

end.
