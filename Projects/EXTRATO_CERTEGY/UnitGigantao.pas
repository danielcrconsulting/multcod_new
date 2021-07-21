unit UnitGigantao;

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
    Button1: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PdfBuffer: Pointer;

implementation

uses UnitPdf;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
  Pdf : TFileStream;
  PdfExtr : File;
  Resultado : Integer;
  Seq : Int64;
  Linha : String;
begin
Pdf := TfileStream.Create(Edit1.Text, fmOpenRead Or fmShareDenyNone);

GetMem(PdfBuffer, 116425);

Seq := StrToInt64(Edit3.Text)-1;
Seq := Seq*116425;

Pdf.Seek(Seq , soBeginning);

ShowMessage(IntToStr(Pdf.Position));

Pdf.Read(PdfBuffer^, 116425);

Linha := IncludeTrailingBackSlash(Edit2.Text);

AssignFile(PdfExtr, Linha + 'PdfExtraido.pdf');
Rewrite(PdfExtr, 1);
BlockWrite(PdfExtr, PdfBuffer^, 116425, Resultado);
CloseFile(PdfExtr);

Pdf.Destroy;
FreeMem(PdfBuffer);

Application.ProcessMessages;

Form2.AcroPDF1.src := Linha;
Form2.AcroPDF1.LoadFile(Linha+'PdfExtraido.pdf');
//Form2.AcroPDF1.Show;
Form2.Show;

end;

procedure TForm1.Edit1DblClick(Sender: TObject);
begin
If OpenDialog1.Execute Then
  Edit1.Text := OpenDialog1.FileName;
end;

end.
