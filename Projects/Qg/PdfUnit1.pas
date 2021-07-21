unit PdfUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DebenuPDFLibrary;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  PDFLibrary: TDebenuPDFLibrary;
  UnlockResult,
  Hand,
  PageHand,
  I, J,
  Tb : Integer;
  Arq : System.Text;
//  ArrLinhas,
  ArrLinha : TArray<String>;

  Bcti : TStringList;

begin
  PDFLibrary := TDebenuPDFLibrary.Create;
  Bcti := TStringList.Create;
  try
    UnlockResult := PDFLibrary.UnlockKey(Edit1.Text);
    Label1.Caption := PDFLibrary.LicenseInfo;
    if UnlockResult = 1 then
    begin
      //11.3,814.18,#FFFFFF,2,"LVJKFN+Arial-BoldMT","1FP020MCC200PF 00200000548648116972901320080409200808070000"
      //"LVJKFN+Arial-BoldMT",#FFFFFF,2,11.304,813.756,78.238,813.756,78.238,815.632,11.304,815.632,"1FP020MCC200PF 00200000548648116972901320080409200808070000"
      Hand := PDFLibrary.DAOpenFile('C:\Rom\REAL_MASTERCOLD\Teste\ABN.211.recupera.pdf','');

      AssignFile(Arq, 'c:\Temp\Texto.txt');
      Rewrite(Arq);
      Tb := 0;
      For I := 1 To PDFLibrary.DAGetPageCount(Hand) Do
        begin

        Inc(Tb);

        If Tb = 100 Then
          Begin
            Edit2.Text := IntToStr(I);
            Application.ProcessMessages;
            Tb := 0;
          End;

        PageHand :=  PDFLibrary.DAFindPage(Hand, I);

        Bcti.Text := PDFLibrary.DAExtractPageText(Hand, PageHand, 0);

       // ArrLinhas := Linha.Split([#13,#10], 999999);

        for J := 0 to Bcti.Count-1 do
          begin
          ArrLinha := Bcti.Strings[J].Split([','], 99999);
          Try
          if (Trim(ArrLinha[0]).Length = 10) and (ArrLinha[0][3] = '/') and (ArrLinha[0][6] = '/') then
            begin
              WriteLn(Arq, ArrLinha[0]);
              Break; // Só a primeira data interessa...
            end;
          Except;
          End;   // Try
          end;
        end;

      Edit2.Text := IntToStr(PDFLibrary.DAGetPageCount(Hand));
      Application.ProcessMessages;

      PDFLibrary.DACloseFile(Hand);
      CloseFile(Arq);
      ShowMessage('Fim...');
    end else
    begin
      ShowMessage('Invalid license key');
    end;
  finally
    PDFLibrary.Free;
    Bcti.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  PDFLibrary: TDebenuPDFLibrary;
  UnlockResult: Integer;
begin

  PDFLibrary := TDebenuPDFLibrary.Create;
  try
    UnlockResult := PDFLibrary.UnlockKey(Edit1.Text);
    Label1.Caption := PDFLibrary.LicenseInfo;
    if UnlockResult = 1 then begin
      PDFLibrary.ExtractFilePages('C:\Rom\REAL_MASTERCOLD\Teste\ABN.211.recupera.pdf','',
                                  'C:\Temp\Teste.pdf','1,10,900')
     end

     else
    begin
      ShowMessage('Invalid license key');
    end;
  finally
    PDFLibrary.Free;

  end;

end;

end.
