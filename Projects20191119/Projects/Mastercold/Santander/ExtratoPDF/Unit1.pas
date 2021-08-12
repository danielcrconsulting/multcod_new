unit Unit1;

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
    Salvar: TButton;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure PesquisarClick(Sender: TObject);
    procedure SairClick(Sender: TObject);
    procedure ConsultaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SalvarClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  RegIndiceCmpl = Packed Record
                  Cartao : Int64;
                  Data: Integer;
                  PosPDF: Integer;
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
  Sortudo : Array Of RegIndiceSmpl;
  ArqCompa : TFileStream; //File Of RegIndiceSmpl;

  RegistroCmpl : RegIndiceCmpl;
  RegistroCompa : RegIndiceCompa;
  RegistroSmpl : RegIndiceSmpl;
  Pos5,
  QtdExtr : Integer;

  ArrRegCmpl : Array[1..1000] of RegIndiceCmpl;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
  I, Cnt : Integer;
  Cart : Int64;
begin
Cart := 0;
Cnt := 0;
ArqCompa := TFileStream.Create(Base+'Icompa.dat', fmopenread or fmsharedenynone);

while ArqCompa.Position < ArqCompa.Size do
  Begin
  ArqCompa.Read(RegistroCompa, SizeOf(RegistroCompa));
  Inc(Cnt);
  if (Cnt mod 1000) = 0 then
    begin
      Edit3.Text := IntToStr(Cnt);
      Application.ProcessMessages;
    end;
  if RegistroCompa.Cartao <  Cart then
    begin
      ShowMessage('Assincronia...');
      Break;
    end;
  End;

Edit3.Text := IntToStr(Cnt);
Application.ProcessMessages;
ShowMessage('Fim de verificação...');

ArqCompa.Free;

end;

procedure TForm1.Button2Click(Sender: TObject);
Var
  I, Cnt : Integer;
  Cart,
  Cartao : Int64;
begin
Cart := 0;
Cnt := 0;
Cartao := StrToInt64(Edit1.Text);
CheckListBox1.Clear;

ArqSmpl := TFileStream.Create(Base+'Ismpl.dat', fmopenread or fmsharedenynone);

while ArqSmpl.Position < ArqSmpl.Size do
  Begin
  ArqSmpl.Read(RegistroSmpl, SizeOf(RegistroSmpl));

  Inc(Cnt);
  if (Cnt mod 1000) = 0 then
    begin
      Edit3.Text := IntToStr(Cnt);
      Application.ProcessMessages;
    end;

  if RegistroSmpl.Cartao <  Cart then
    begin
      ShowMessage('Assincronia...');
      Break;
    end;
  if RegistroSmpl.Cartao =  Cartao then
    CheckListBox1.Items.Add(IntToStr(RegistroSmpl.Cartao));
  End;

Edit3.Text := IntToStr(Cnt);
Application.ProcessMessages;

ShowMessage('Fim de verificação...');

ArqSmpl.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  I, Cnt : Integer;
  Cart,
  Cartao : Int64;
begin
Cart := 0;
Cnt := 0;
Cartao := StrToInt64(Edit1.Text);
CheckListBox1.Clear;

ArqCmpl := TFileStream.Create(Base+'Icmpl.dat', fmopenread or fmsharedenynone);

while ArqCmpl.Position < ArqCmpl.Size do
  Begin
  ArqCmpl.Read(RegistroCmpl, SizeOf(RegistroCmpl));

  Inc(Cnt);
  if (Cnt mod 1000) = 0 then
    begin
      Edit3.Text := IntToStr(Cnt);
      Application.ProcessMessages;
    end;

  if RegistroCmpl.Cartao =  Cartao then
    CheckListBox1.Items.Add(IntToStr(RegistroCmpl.Data));
  End;

Edit3.Text := IntToStr(Cnt);
Application.ProcessMessages;

ShowMessage('Fim de verificação...');

ArqCmpl.Free;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked then
  CheckListBox1.CheckAll(cbChecked, false, true)
else
  CheckListBox1.CheckAll(cbUnchecked, true, false);
end;

procedure TForm1.ConsultaClick(Sender: TObject);
Var
  I, UnlockResult: Integer;
  PDFLibrary: TDebenuPDFLibrary;
  F: TSearchRec;
begin

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

If FindFirst('C:\Temp\MasterCold\*.pdf', faAnyFile, F) = 0 Then     // Limpa as consultas prévias...
  Repeat
    DeleteFile('C:\Temp\MasterCold\'+F.Name);
  Until FindNext(F) <> 0;

for I := 1 to QtdExtr do
  if CheckListBox1.Checked[I-1] then
    begin

      PDFLibrary.ExtractFilePages(Base+ArrRegCmpl[I].NomePDF, '',
                                  'C:\Temp\MasterCold\'+IntToStr(ArrRegCmpl[I].Cartao) + '-' + IntToStr(ArrRegCmpl[I].Data)+'.pdf',
                                  IntToStr(ArrRegCmpl[I].PosPDF+1) +
                                  '-' + IntToStr(ArrRegCmpl[I].PosPDF+ArrRegCmpl[I].QtdPaginas));
      ShellExecute(0, Nil, PChar('C:\Temp\MasterCold\'+IntToStr(ArrRegCmpl[I].Cartao) + '-' + IntToStr(ArrRegCmpl[I].Data) +
                                 '.pdf'), nil, nil, 3 {SW_SHOWNORMAL});
    end;

PDFLibrary.Free;

end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  I:Integer;
begin
Edit2.Text := 'Carregando dados, aguarde...';
Application.ProcessMessages;

DirSel := '';
System.GetDir(0, Base);
Base := Base + '\Extratos\';

Pos5 := -1;

ArqCompa := TFileStream.Create(Base+'Icompa.dat', fmopenread or fmsharedenynone);
SetLength(Sortudo, ArqCompa.Size div SizeOf(RegistroCompa));
for I := Low(Sortudo) to High(Sortudo) do
  Begin
  ArqCompa.Read(RegistroCompa, SizeOf(RegistroCompa));
  Sortudo[I].Cartao := RegistroCompa.Cartao;
  Sortudo[I].PosInd := RegistroCompa.PosInd;
  if (Pos5 = -1) and (Sortudo[I].Cartao >= 5000000000000000) then
    Pos5 := I;
  End;

ArqCompa.Free;

Edit2.Text := '';
Application.ProcessMessages;

end;

procedure TForm1.PesquisarClick(Sender: TObject);
Var
  I, IFix: Integer;
  Achou : Boolean;
  Cartao : Int64;
  Comeco,
  Fim : Integer;

begin
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

  ArqSmpl.Seek(Sortudo[IFix].PosInd, SoFromBeginning);
  ArqSmpl.Read(RegistroSmpl, SizeOf(RegistroSmpl));

  while ArqSmpl.Position < ArqSmpl.Size do
    begin
      ArqCmpl.Seek(RegistroSmpl.PosInd, SoFromBeginning);
      ArqCmpl.Read(RegistroCmpl, SizeOf(RegistroCmpl));
      CheckListBox1.Items.Add(IntToStr(RegistroCmpl.Data));
      Inc(QtdExtr);

      ArrRegCmpl[QtdExtr] := RegistroCmpl; // Guarda o registro na memória para recuperar depois

      ArqSmpl.Read(RegistroSmpl, SizeOf(RegistroSmpl));
      if RegistroSmpl.Cartao <> Sortudo[IFix].Cartao then
        Break;
    end;

  Edit2.Text := IntToStr(QtdExtr) + ' Extrato(s) encontrado(s)';
  ArqSmpl.Free;
  ArqCmpl.Free;
  end
else
  Edit2.Text := 'Nenhum extrato encontrado...';

Application.ProcessMessages;

end;

procedure TForm1.SairClick(Sender: TObject);
Var
  F: TSearchRec;
begin
If FindFirst('C:\Temp\MasterCold\*.pdf', faAnyFile, F) = 0 Then     // Limpa as consultas prévias...
  Repeat
    DeleteFile('C:\Temp\MasterCold\'+F.Name);
  Until FindNext(F) <> 0;
Close;
end;

procedure TForm1.SalvarClick(Sender: TObject);
const
  SELDIRHELP = 1000;
var
  I,
  Co: Integer;
begin
Co := 0;
If SelectDirectory(DirSel, [sdAllowCreate, sdPerformCreate, sdPrompt], SELDIRHELP) then
  begin

  Caminho := Base;
  for I := 1 to Length(Edit1.Text) do
    Caminho := Caminho + Edit1.Text[I] + '\';

  for I := 0 to CheckListBox1.Count-1 do
    if CheckListBox1.Checked[I] then
       Begin
       CopyFile(pChar(Caminho + Edit1.Text + '\' + ListBox2.Items[I]), pChar(DirSel + '\' + ListBox2.Items[I]), false);
       Inc(Co);
       End;
  end;
Edit3.Text := IntToStr(Co) + ' arquivos copiados';

end;

end.
