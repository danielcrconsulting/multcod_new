unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Generics.Collections, System.Generics.Defaults, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  DebenuPDFLibrary;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    IndexButton: TButton;
    SairButton: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    AtuDataButton: TButton;
    Button1: TButton;
    procedure SairButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IndexButtonClick(Sender: TObject);
    procedure AtuDataButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

  RegIndiceSmpl = Packed Record
                  Cartao : Int64;
                  PosInd : Int64;
                  End;

  RegIndiceCompa = Packed Record
                   Cartao : Int64;
                   PosInd : Integer;
                   End;

  RegIndiceSort = Packed Record
                  Cartao : Array[1..8] of AnsiChar;
                  PosInd : Int64;
                  End;

var
  Form1: TForm1;
  Base : String;
  QtdArqs : Integer;
  ArqCmpl : TFileStream; //File Of RegIndiceCmpl;
  ArqSmpl : TFileStream; //File Of RegIndiceSmpl;
  Sortudo : Array Of RegIndiceSort;

  ArqCompa : TFileStream; //File Of RegIndiceSmpl;

implementation

{$R *.dfm}

procedure TForm1.AtuDataButtonClick(Sender: TObject);
Var
  RegistroCmpl : RegIndiceCmpl;
  PDFLibrary: TDebenuPDFLibrary;
  UnlockResult,
  Hand,
  PageHand,
  Tb, J : Integer;
  Bcti : TStringList;
  ArrLinha : TArray<String>;
  PDFTrab: AnsiString;
  Data : String;
  ArqCmplA : TFileStream; //File Of RegIndiceCmpl;

begin
ListBox1.Clear;
PDFTrab := '';
Tb := 0;

ArqCmpl := TFileStream.Create(Base+'Icmpl2.dat', fmOpenRead);
ArqCmplA := TFileStream.Create(Base+'IcmplA.dat', fmCreate);

PDFLibrary := TDebenuPDFLibrary.Create;
Bcti := TStringList.Create;

try
  UnlockResult := PDFLibrary.UnlockKey('jm6ws5c65dn5ex3de6h96337y');
  if UnlockResult = 1 then
    begin
    end
else
    begin
      ShowMessage('Invalid license key');
      PDFLibrary.Free;
      Bcti.Free;
      Exit;
    end;
  finally;
  end;

Hand := 0;

While ArqCmpl.Position < ArqCmpl.Size do
  begin

  ArqCmpl.Read(RegistroCmpl, SizeOf(RegistroCmpl));
  If PDFTrab <> RegistroCmpl.NomePDF Then
    begin
    if PDFTrab <> '' then
      PDFLibrary.DACloseFile(Hand);

    PDFTrab := RegistroCmpl.NomePDF;

    Hand := PDFLibrary.DAOpenFile(Base + RegistroCmpl.NomePDF,'');
    end;

  Inc(Tb);

  If ((Tb Mod 100) = 0) Then
    Begin
    Edit1.Text := IntToStr(Tb);
    Edit2.Text := RegistroCmpl.NomePDF;
    Application.ProcessMessages;
    End;

  PageHand :=  PDFLibrary.DAFindPage(Hand, RegistroCmpl.PosPDF+1);

  Bcti.Text := PDFLibrary.DAExtractPageText(Hand, PageHand, 0);

  for J := 0 to Bcti.Count-1 do
    begin
    ArrLinha := Bcti.Strings[J].Split([','], 99999);
    Try
      if (Trim(ArrLinha[0]).Length = 10) and (ArrLinha[0][3] = '/') and (ArrLinha[0][6] = '/') then
        begin
        Data := ArrLinha[0].Substring(6,4) + ArrLinha[0].Substring(3,2) + ArrLinha[0].Substring(0,2);
        RegistroCmpl.Data := StrToInt(Data);
        Break; // Só a primeira data interessa...
        end;
      Except;
      End;   // Try
    end;

  ArqCmplA.Write(RegistroCmpl, SizeOf(RegistroCmpl)); // Grava atualizado ou não, caso não ache uma data
  end;

Edit1.Text := IntToStr(Tb);
Application.ProcessMessages;

PDFLibrary.DACloseFile(Hand);
PDFLibrary.Free;
Bcti.Free;

ShowMessage('Fim...');

ArqCmpl.Free;
ArqCmplA.Free;

end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  Arq : TFileStream;
  I : Integer;
  J : Int64;
begin
Arq := TFileStream.Create(Base+'Teste.dat', fmCreate);
for I := 1 to 1000000 do
  begin
  J := I;
  Arq.Write(I, SizeOf(I));
  Arq.Write(J, SizeOf(J));
  end;

Arq.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
System.GetDir(0, Base);
Base := Base + '\Extratos\';
end;

procedure TForm1.IndexButtonClick(Sender: TObject);
Var
  F : TSearchRec;
  I,
  Total: Integer;
  ArrLinha : TArray<String>;
  ArqTxt : TextFile;
  Linha,
  Cartao,
  Data : String;
  PPdf,
  PosPDF : Integer;
  QtdPaginas: String;
  Pessoa: String;
  PessoaA, NomePDF : AnsiString;
  RegistroCmpl : RegIndiceCmpl;
  RegistroSmpl : RegIndiceSmpl;
  RegistroCompa : RegIndiceCompa;
  NumCar : Array[1..8] of AnsiChar;
  Menor : Int64;
begin
//ShowMessage(IntToStr(SIzeOf(RegistroSmpl)));
//ShowMessage(IntToStr(SIzeOf(RegistroCmpl)));
QtdArqs := 0;
ListBox1.Clear;
If FindFirst(Base+'*.pdf', faAnyFile, F) = 0 Then
  Repeat
    Inc(QtdArqs);
    ListBox1.Items.Add(F.Name);
    if Length(F.Name) > 50 then
      begin
        ShowMessage('O arquivo '+F.Name+' tem nome com mais de 50 posições...)');
        Application.Terminate;
      end;
  Until FindNext(F) <> 0;
System.SysUtils.FindClose(F);

Edit1.Text := IntToStr(QtdArqs);
Application.ProcessMessages;

ArqCmpl := TFileStream.Create(Base+'Icmpl.dat', fmCreate);
ArqSmpl := TFileStream.Create(Base+'Ismpl.dat', fmCreate);

Total := ListBox1.Count-1;
for I := 0 to Total do
  begin
  ArrLinha := ListBox1.Items[I].Split(['.'], 99999);
  If FindFirst(Base+ArrLinha[0]+'.'+ArrLinha[1]+'.*.txt', faAnyFile, F) = 0 Then
    Begin
    Edit2.Text := F.Name;
    Application.ProcessMessages;
    AssignFile(ArqTxt, Base+F.Name);
    Reset(ArqTxt);
    PPdf := 0;
    While not eof(ArqTxt) do
      begin
        Readln(ArqTxt, Linha);
        ArrLinha := Linha.Split([#9], 99999);
        if Trim(ArrLinha[0]) = '10' then
          begin
          Cartao := ArrLinha[2].Substring(23, 16);
          Data := ArrLinha[2].Substring(39, 8);
          PosPDF := PPdf;
          QtdPaginas := ArrLinha[5];
          PPdf := PPdf + StrToInt(QtdPaginas);
          Pessoa := ArrLinha[2].Substring(12, 2);
          PessoaA := Pessoa;
          NomePDF := ListBox1.Items[I];

          if Cartao = '5486481130327012' then
            begin
              Cartao := Cartao;
            end;

          RegistroCmpl.Cartao := StrToInt64(Cartao);
          RegistroCmpl.Data := StrToInt(Data);
          RegistroCmpl.PosPDF := PosPDF;
          RegistroCmpl.QtdPaginas := StrToInt(QtdPaginas);
          Move(PessoaA[1], RegistroCmpl.Pessoa, 2);
          FillChar(RegistroCmpl.NomePDF, 50, ' ');
          Move(NomePDF[1], RegistroCmpl.NomePDF, Length(NomePDF));

          RegistroSmpl.Cartao := RegistroCmpl.Cartao;
          RegistroSmpl.PosInd := ArqCmpl.Position; // FilePos(ArqCmpl);

          ArqCmpl.Write(RegistroCmpl, SizeOf(RegistroCmpl));
          ArqSmpl.Write(RegistroSmpl, SizeOf(RegistroSmpl));

          end;
      end;
    CloseFile(ArqTxt);
    End;
  Dec(QtdArqs);
  Edit1.Text := IntToStr(QtdArqs);
  Application.ProcessMessages;
  System.SysUtils.FindClose(F);
  end;

ArqCmpl.Free;
ArqSmpl.Free;

Edit2.Text := '';
Application.ProcessMessages;

// Vai Iniciar o Sort do índice menor...

ListBox1.Clear;
ListBox1.Items.Add('Iniciando Processamento do índice');
ListBox1.Items.Add('Realizando a carga');
Application.ProcessMessages;

ArqSmpl := TFileStream.Create(Base+'Ismpl.dat', fmOpenRead);

SetLength(Sortudo, ArqSmpl.Size div SizeOf(RegistroSmpl));

for I := Low(Sortudo) to High(Sortudo) do
  Begin
  ArqSmpl.Read(RegistroSmpl, SizeOf(RegistroSmpl));

  Move(RegistroSmpl.Cartao, NumCar, 8);      // Inverte o número para dar certo o sort
  Sortudo[I].Cartao[1] := NumCar[8];
  Sortudo[I].Cartao[2] := NumCar[7];
  Sortudo[I].Cartao[3] := NumCar[6];
  Sortudo[I].Cartao[4] := NumCar[5];
  Sortudo[I].Cartao[5] := NumCar[4];
  Sortudo[I].Cartao[6] := NumCar[3];
  Sortudo[I].Cartao[7] := NumCar[2];
  Sortudo[I].Cartao[8] := NumCar[1];

  Sortudo[I].PosInd := RegistroSmpl.PosInd;

  End;

ArqSmpl.Free;

ListBox1.Items.Add('Organizando...');
Application.ProcessMessages;

TArray.Sort<RegIndiceSort>(Sortudo);

ListBox1.Items.Add('Descarregando...');
Application.ProcessMessages;

ArqSmpl := TFileStream.Create(Base+'Ismpl.dat', fmCreate);
ArqCompa := TFileStream.Create(Base+'Icompa.dat', fmCreate);

Menor := 0;
for I := Low(Sortudo) to High(Sortudo) do
  Begin
  NumCar[8] := Sortudo[I].Cartao[1];
  NumCar[7] := Sortudo[I].Cartao[2];
  NumCar[6] := Sortudo[I].Cartao[3];
  NumCar[5] := Sortudo[I].Cartao[4];
  NumCar[4] := Sortudo[I].Cartao[5];
  NumCar[3] := Sortudo[I].Cartao[6];
  NumCar[2] := Sortudo[I].Cartao[7];
  NumCar[1] := Sortudo[I].Cartao[8];
  Move(NumCar, RegistroSmpl.Cartao, 8);

  RegistroSmpl.PosInd := Sortudo[I].PosInd;

  if RegistroSmpl.Cartao < Menor then
    Begin
      ShowMessage('Assincronia, abortando...');
      Application.Terminate;
    End
  else
    if RegistroSmpl.Cartao <> Menor then
      begin
      RegistroCompa.Cartao := RegistroSmpl.Cartao;
      RegistroCompa.PosInd := ArqSmpl.Position;
      ArqCompa.Write(RegistroCompa, SizeOf(RegistroCompa));
      end;

  Menor := RegistroSmpl.Cartao;

  ArqSmpl.Write(RegistroSmpl, SizeOf(RegistroSmpl));
  End;

ArqSmpl.Free;
ArqCompa.Free;

ShowMessage('Fim de processamento...');
end;

procedure TForm1.SairButtonClick(Sender: TObject);
begin
Close;
end;

end.
