unit Unit11;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Shellapi,
  Vcl.Imaging.jpeg, Vcl.CheckLst, Vcl.FileCtrl,
  System.Generics.Collections, System.Generics.Defaults, DebenuPDFLibrary;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Edit1: TEdit;
    Pesquisar: TButton;
    ListBox2: TListBox;
    Sair: TButton;
    Consulta: TButton;
    CheckListBox1: TCheckListBox;
    Edit2: TEdit;
    SalvarJun: TButton;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    SalvarSep: TButton;
    procedure PesquisarClick(Sender: TObject);
    procedure SairClick(Sender: TObject);
    procedure ConsultaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  RegIndiceCmpl = Packed Record
                  Cartao : Int64;
                  Data : Integer;
                  PosPDF : Integer;
                  QtdPaginas : Integer;
                  Pessoa : Array[1..2] of AnsiChar;
                  NomePDF : Array[1..50] of AnsiChar;
                  End;

  RegIndiceCompa = Packed Record
                   Cartao : Int64;
                   PosInd : Integer;
                   End;

  RegIndiceSmpl = Packed Record
                  Cartao : Int64;
                  PosInd : Int64;
                  End;

var
  Form1: TForm1;
  DirSel,
  Base,
  Caminho : String;
  ArqCmpl : TFileStream; //File Of RegIndiceCmpl;
  ArqSmpl : TFileStream; //File Of RegIndiceSmpl;
  Sortudo : Array Of RegIndiceCompa;
  ArqCompa : TFileStream; //File Of RegIndiceSmpl;

  RegistroCmpl : RegIndiceCmpl;
  RegistroCompa : RegIndiceCompa;
  RegistroSmpl : RegIndiceSmpl;
  Pos5,
  QtdExtr : Integer;

  ArrRegCmpl : Array[1..1000] of RegIndiceCmpl;

  PDFLibrary: TDebenuPDFLibrary;
  UnlockResult: Integer;
  Buffer : Pointer;
  BufPed : TMemoryStream;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin

SetLength(Sortudo, 0);

PDFLibrary := TDebenuPDFLibrary.Create;

try
  UnlockResult := PDFLibrary.UnlockKey('jm6ws5c65dn5ex3de6h96337y');
  if UnlockResult = 1 then
    begin
    end
else
    begin
      ShowMessage('Invalid license key');
      PDFLibrary.Free;
      Exit;
    end;
  finally;
  end;

end;

procedure TForm1.FormActivate(Sender: TObject);
Var
  I: Integer;
begin

if Length(Sortudo) <> 0 then
  Exit;

Edit2.Text := 'Carregando dados, aguarde...';
Application.ProcessMessages;

//Sleep(3000);

DirSel := '';
System.GetDir(0, Base);
Base := Base + '\Extratos\';

Pos5 := -1;

ArqCompa := TFileStream.Create(Base+'Icompa.dat', fmopenread or fmsharedenynone);
BufPed := TMemoryStream.Create;

GetMem(Buffer, ArqCompa.Size);
ArqCompa.Read(Buffer^, ArqCompa.Size);
BufPed.Write(Buffer^, ArqCompa.Size);
FreeMem(Buffer);
BufPed.Seek(0,SoBeginning);

SetLength(Sortudo, ArqCompa.Size div SizeOf(RegistroCompa));
for I := Low(Sortudo) to High(Sortudo) do
  Begin
  BufPed.Read(RegistroCompa, SizeOf(RegistroCompa));
//  ArqCompa.Read(RegistroCompa, SizeOf(RegistroCompa));
  Sortudo[I].Cartao := RegistroCompa.Cartao;
  Sortudo[I].PosInd := RegistroCompa.PosInd;
  if (Pos5 = -1) and (Sortudo[I].Cartao >= 5000000000000000) then
    Pos5 := I;
  End;

ArqCompa.Free;
BufPed.Free;

Edit2.Text := '';
Application.ProcessMessages;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked then
  CheckListBox1.CheckAll(cbChecked, false, true)
else
  CheckListBox1.CheckAll(cbUnchecked, true, false);
end;

procedure TForm1.PesquisarClick(Sender: TObject);
Var
  I, IFix: Integer;
  Achou : Boolean;
  Cartao : Int64;
  Comeco,
  Fim,
  Ult : Integer;
  F: TSearchRec;
  RegCmplAux : RegIndiceCmpl;

begin
If FindFirst('C:\Temp\MasterCold\*.pdf', faAnyFile, F) = 0 Then     // Limpa as consultas prévias...
  Repeat
    DeleteFile('C:\Temp\MasterCold\'+F.Name);
  Until FindNext(F) <> 0;

CheckListBox1.Items.Clear;
QtdExtr := 0;

if Edit1.Text = '' then
  begin
  ShowMessage('Informe um cartão para pesquisar...');
  Exit;
  end;

CheckBox1.Checked := False;

Achou := False;

Cartao := StrToInt64(Edit1.Text);

if Cartao >= 5000000000000000 then
  begin
  Comeco := Pos5;
  Fim := High(Sortudo);
  end
else
  Begin
  Comeco := 0;
  Fim := Pos5;
  End;

IFix := 0;

for I := Comeco to Fim do
  begin
  if Sortudo[I].Cartao = Cartao then
    begin
    Edit2.Text := (Format('Element %d was found in the list at index %d!', [Sortudo[I].Cartao, I]));
    Achou := True;
    IFix := I;
    Break;
    end;
  end;

If Achou Then
  begin
  ArqSmpl := TFileStream.Create(Base+'Ismpl.dat', fmopenread or fmsharedenynone);
  ArqCmpl := TFileStream.Create(Base+'Icmpl.dat', fmopenread or fmsharedenynone);

  ArqSmpl.Seek(Sortudo[IFix].PosInd, SoBeginning); // Posiciona no primeiro
//  ArqSmpl.Seek(Sortudo[IFix].PosInd, SoFromBeginning); // Posiciona no primeiro

  while ArqSmpl.Position < ArqSmpl.Size do
    begin

      ArqSmpl.Read(RegistroSmpl, SizeOf(RegistroSmpl));
      if RegistroSmpl.Cartao <> Sortudo[IFix].Cartao then
        Break;

      ArqCmpl.Seek(RegistroSmpl.PosInd, SoBeginning);
//      ArqCmpl.Seek(RegistroSmpl.PosInd, SoFromBeginning);
      ArqCmpl.Read(RegistroCmpl, SizeOf(RegistroCmpl));

      CheckListBox1.Items.Add(IntToStr(RegistroCmpl.Data));
      Inc(QtdExtr);
      ArrRegCmpl[QtdExtr] := RegistroCmpl; // Guarda o registro na memória para recuperar depois

    end;

  if QtdExtr > 1 then                    //CheckList é ordenado, então ordena o array tb
    for Ult := QtdExtr downto 2 do
      for I := 2 to Ult do
        if ArrRegCmpl[I].Data < ArrRegCmpl[I-1].Data then
          begin
          RegCmplAux := ArrRegCmpl[I];
          ArrRegCmpl[I] := ArrRegCmpl[I-1];
          ArrRegCmpl[I-1] := RegCmplAux;
          end;

  Edit2.Text := IntToStr(QtdExtr) + ' Extrato(s) encontrado(s)';
  ArqSmpl.Free;
  ArqCmpl.Free;
  end
else
  Edit2.Text := 'Nenhum extrato encontrado...';

Application.ProcessMessages;

end;

procedure TForm1.ConsultaClick(Sender: TObject);
Var
  F: TSearchRec;
  I,J: Integer;
  PDFList,
  Nome,
  X : String;
begin
Edit2.Text := '0 arquivos obtidos';
Application.ProcessMessages;

If FindFirst('C:\Temp\MasterCold\*.pdf', faAnyFile, F) = 0 Then     // Limpa as consultas prévias...
  Repeat
    DeleteFile('C:\Temp\MasterCold\'+F.Name);
  Until FindNext(F) <> 0;

J := 0;
PDFLibrary.ClearFileList(PDFList);

for I := 1 to QtdExtr do
  if CheckListBox1.Checked[I-1] then
    begin
      Edit3.Text := 'Obtendo PDF ' + IntToStr(ArrRegCmpl[I].Cartao) + '-' + IntToStr(ArrRegCmpl[I].Data);
      Nome := 'C:\Temp\MasterCold\'+IntToStr(ArrRegCmpl[I].Cartao)+'.pdf';
      Inc(J);
      Edit2.Text := IntToStr(J)+' arquivo(s) obtido(s)';
      Application.ProcessMessages;

      PDFLibrary.ExtractFilePages(Base+ArrRegCmpl[I].NomePDF, '',
                                  'C:\Temp\MasterCold\'+IntToStr(ArrRegCmpl[I].Cartao) + '-' + IntToStr(ArrRegCmpl[I].Data)+'.pdf',
                                  IntToStr(ArrRegCmpl[I].PosPDF+1) +
                                  '-' + IntToStr(ArrRegCmpl[I].PosPDF+ArrRegCmpl[I].QtdPaginas));

      PDFLibrary.AddToFileList(PDFList, 'C:\Temp\MasterCold\'+IntToStr(ArrRegCmpl[I].Cartao) + '-' + IntToStr(ArrRegCmpl[I].Data)+'.pdf');

      if Sender = Consulta then
        begin

        Edit3.Text := 'Abrindo PDF ' + IntToStr(ArrRegCmpl[I].Cartao) + '-' + IntToStr(ArrRegCmpl[I].Data);
        Application.ProcessMessages;

        ShellExecute(0, Nil, PChar('C:\Temp\MasterCold\'+IntToStr(ArrRegCmpl[I].Cartao) + '-' + IntToStr(ArrRegCmpl[I].Data) +
                                   '.pdf'), nil, nil, {3} SW_SHOWNORMAL);
        end;
    end;

X := IntToStr(PDFLibrary.FileListCount(PDFList));

if (Sender = SalvarJun) And (PDFLibrary.FileListCount(PDFList) > 1) then
  begin
  PDFLibrary.MergeFileList(PDFList, Nome);
  end;
end;

procedure TForm1.SairClick(Sender: TObject);
Var
  F: TSearchRec;
begin
PDFLibrary.Free;
If FindFirst('C:\Temp\MasterCold\*.pdf', faAnyFile, F) = 0 Then     // Limpa as consultas prévias...
  Repeat
    DeleteFile('C:\Temp\MasterCold\'+F.Name);
  Until FindNext(F) <> 0;
Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
PDFLibrary.MergeFiles(Base+'1.pdf', Base+'2.pdf', Base+'3.pdf');
DeleteFile(Base+'1.pdf');
RenameFile(Base+'3.pdf', Base+'1.pdf');
ShowMessage('Done...');
end;

end.
