unit UnitPdfao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Sair: TButton;
    Ok: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    procedure SairClick(Sender: TObject);
    procedure OkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Buf : Pointer;

implementation

{$R *.dfm}

procedure TForm1.OkClick(Sender: TObject);
Var
  ArqIn,
  ArqOut : TFileStream;
  L : Integer;
  Tam : Int64;
  Tempo0,
  Tempo1,
  Tempo2 : Ttime;

begin
Edit2.Text := '0';
Tempo0 := Now;
Tempo1 := Tempo0;

Edit3.Text := TimeToStr(Tempo1);
ArqIn := TFileStream.Create('c:\temp\0.pdf', fmOpenRead, fmShareExclusive);
Tam := ArqIn.Size;
GetMem(Buf, Tam);
ArqIn.Read(Buf^, Tam);
ArqIn.Free;
ArqOut := TFileStream.Create('c:\temp\'+'1.pdf', fmCreate, fmShareExclusive);
For L := 1 to StrToInt(Edit5.Text) do
  Begin
  ArqOut.Write(Buf^, Tam);
  if (L mod 1000) = 0 then
    Begin
      Tempo2 := now;
      Edit1.Text := IntToStr(L);
      Edit2.Text := FormatDateTime('hh:nn:ss.zzz', Tempo2-Tempo1);
      Edit4.Text := FormatDateTime('hh:nn:ss.zzz', Tempo2-Tempo0);

      Try
        Edit6.Text := FormatDateTime('hh:nn:ss.zzz', (Tempo2-Tempo0) / (L / 1000));
        Application.ProcessMessages;
        Except
        End; {Try}

      Application.ProcessMessages;
      Tempo1 := Tempo2;
    End;
  End;
ArqOut.Free;
FreeMem(Buf);
ShowMessage('Fim...');
end;

procedure TForm1.SairClick(Sender: TObject);
begin
Close;
end;

end.
