unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Generics.Collections, System.Generics.Defaults, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  DebenuPDFLibrary, SutypGer;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    IndexButton: TButton;
    SairButton: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    procedure SairButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IndexButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TgUnsrExtr = Packed Record
             Org                       : TgArr003;  //1  ..
             Logo                      : TgArr003;  //4
             Conta                     : TgArr016;  //7
             AnoMes                    : TgArr006;  //23
             Ciclo                     : TgArr002;  //29
             VlrLimAtu                 : TgArr014;  //31
             VlrLimSaque               : TgArr014;  //45
             DataVencto                : TgArr008;  //59
             VlrSaldoAtu               : TgArr014;  //67  INVERTIDO A PEDIDO DE MACIEL
             VlrSaldoAtuConvert        : TgArr014;  //81
             VlrSaldoExtrAnter         : TgArr014;  //95
             VlrAmortPagtos            : TgArr014;  //109
             VlrEncargos               : TgArr014;  //123
             VlrTaxasAnuid             : TgArr014;  //137
             VlrAjustes1               : TgArr014;  //151
             VlrCompras                : TgArr014;  //165
             VlrParcFixas              : TgArr014;  //179
             VlrPremioSeguro           : TgArr014;  //193
             VlrSaldoAtual             : TgArr014;  //207
             VlrCota                   : TgArr009;
             DataCota                  : TgArr008;
             VlrPagtoMinTotal          : TgArr014;
             VlrTaxaJuros              : TgArr008;
             VlrTaxaJurosAtraso        : TgArr008;
             VlrTaxaJurosProxPer       : TgArr008;
             VlrTaxaJurosProxPerAtraso : TgArr008;
             CrLf                      : TgArr002;
             End;

TgExtrA = Packed Record
             Conta                     : TgArr016;  //7
             AnoMes                    : TgArr006;  //23
             Ciclo                     : TgArr002;  //29
             VlrLimAtu                 : TgArr014;  //31
             VlrLimSaque               : TgArr014;  //45
             DataVencto                : TgArr008;  //59
             VlrSaldoAtu               : TgArr014;  //67  INVERTIDO A PEDIDO DE MACIEL
             VlrSaldoAtuConvert        : TgArr014;  //81
             VlrSaldoExtrAnter         : TgArr014;  //95
             VlrAmortPagtos            : TgArr014;  //109
             VlrEncargos               : TgArr014;  //123
             VlrTaxasAnuid             : TgArr014;  //137
             VlrAjustes1               : TgArr014;  //151
             VlrCompras                : TgArr014;  //165
             VlrParcFixas              : TgArr014;  //179
             VlrPremioSeguro           : TgArr014;  //193
             VlrSaldoAtual             : TgArr014;  //207
             VlrCota                   : TgArr009;
             DataCota                  : TgArr008;
             VlrPagtoMinTotal          : TgArr014;
             VlrTaxaJuros              : TgArr008;
             VlrTaxaJurosAtraso        : TgArr008;
             VlrTaxaJurosProxPer       : TgArr008;
             VlrTaxaJurosProxPerAtraso : TgArr008;
             CrLf                      : TgArr002;
             End;

TgExtrS = Packed Record
             Nome                      : TgArr040;
             Cpf                       : TgArr015;
             Conta                     : TgArr016;  //7
             AnoMes                    : TgArr006;  //23
             Ciclo                     : TgArr002;  //29
             VlrLimAtu                 : TgArr014;  //31
             VlrLimSaque               : TgArr014;  //45
             DataVencto                : TgArr008;  //59
             VlrSaldoAtu               : TgArr014;  //67  INVERTIDO A PEDIDO DE MACIEL
             VlrSaldoAtuConvert        : TgArr014;  //81
             VlrSaldoExtrAnter         : TgArr014;  //95
             VlrAmortPagtos            : TgArr014;  //109
             VlrEncargos               : TgArr014;  //123
             VlrTaxasAnuid             : TgArr014;  //137
             VlrAjustes1               : TgArr014;  //151
             VlrCompras                : TgArr014;  //165
             VlrParcFixas              : TgArr014;  //179
             VlrPremioSeguro           : TgArr014;  //193
             VlrSaldoAtual             : TgArr014;  //207
             VlrCota                   : TgArr009;
             DataCota                  : TgArr008;
             VlrPagtoMinTotal          : TgArr014;
             VlrTaxaJuros              : TgArr008;
             VlrTaxaJurosAtraso        : TgArr008;
             VlrTaxaJurosProxPer       : TgArr008;
             VlrTaxaJurosProxPerAtraso : TgArr008;
             CrLf                      : TgArr002;
             End;

  TgUnsrCont = Record
               Org               : TgArr003;  // 1
               Logo              : TgArr003;  // 4
               Conta             : TgArr016;  // 7 0000000002641178
               ContaEmpres       : TgArr016;  // 23
               CpfCgc            : TgArr015;  // 39
               Status            : TgArr002;  // 54
               NomeExt           : TgArr040;  // 56
               EndResidenc       : TgArr040;  // 96
               EndResidencCompl  : TgArr010;  // 136
               EndResidencBairro : TgArr015;  // 146
               EndResidencCep    : TgArr008;  // 161
               EndResidencCidade : TgArr020;  // 169
               EndResidencUf     : TgArr002;  // 189
               EndResidencDdd    : TgArr004;  // 191
               EndResidencFone   : TgArr008;  // 195
               EndResidencRamal  : TgArr004;  // 203
               Opc               : TgArr001;  // 207
               EndEmpr           : TgArr040;  // 208
               EndEmprCompl      : TgArr010;  // 248
               EndEmprBairro     : TgArr015;  // 258
               EndEmprCep        : TgArr008;  // 273
               EndEmprCidade     : TgArr020;  // 281
               EndEmprUf         : TgArr002;  // 301
               EndEmprDdd        : TgArr004;  // 303
               EndEmprFone       : TgArr008;  // 307
               EndEmprRamal      : TgArr004;  // 315
               TipoConta         : TgArr001;  // 319
               DebitoCC          : TgArr001;  // 320 01 BYTE FLAG DE DEBITO EM CONTA CORRENTE  ( S / N )
               CodBloqueioUm     : TgArr001;  // 321 01 BYTE CODIGO DE BLOQUEIO UM
               DtBloqueioUm      : TgArr008;  // 322 08 BYTES DATA DO CÓDIGO DE BLOQUEIO UM (AAAAMMDD ) ou zeros
               CodBloqueioDois   : TgArr001;  // 330 01 BYTE CODIGO DE BLOQUEIO DOIS
               DtBloqueioDois    : TgArr008;  // 331 08 BYTES DATA DO CÓDIGO DE BLOQUEIO DOIS (AAAAMMDD ) OU ZEROS..
               CrLf              : TgArr002;  // 339
               End;                           // 341

  RegIndiceSort = Packed Record
                  Conta : TgArr016;
                  Data  : TgArr008;
                  Posic : Int64;
                  End;
var
  Form1: TForm1;
  Base : String;
  QtdArqs : Integer;
  ArqIn,
  ArqExtrA,
  ArqCont,
  ArqS : TFileStream;
  RegistroIn : TgExtrA;
  RegistroCont : TgUnsrCont;
  Sortudo : Array Of RegIndiceSort;

  ArqCompa : TFileStream;

implementation

{$R *.dfm}

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
  ArrLinha : String;
  ArqTxt,
  ArqOut : TextFile;
  Linha: AnsiString;
  Caca : packed Array[1..55] of ansichar;
begin
for I := 1 to 55 do
  Caca[I] := ' ';

QtdArqs := 0;
ListBox1.Clear;
If FindFirst(Base+'E*.txt', faAnyFile, F) = 0 Then
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

Total := ListBox1.Count-1;

AssignFile(ArqOut, Base+'0.txt');
Rewrite(ArqOut);

for I := 0 to Total do
  begin
  ArrLinha := ListBox1.Items[I];
  If FindFirst(Base+ArrLinha, faAnyFile, F) = 0 Then
    Begin
    Edit2.Text := F.Name;
    Application.ProcessMessages;
    AssignFile(ArqTxt, Base+F.Name);
    Reset(ArqTxt);
    While not eof(ArqTxt) do
      begin
        Readln(ArqTxt, Linha);
        if Copy(Linha, 12, 2)='00' then
          WriteLn(ArqOut,Copy(Linha,7,Length(Linha) - 6))
        else
        if Copy(Linha, 12, 2)='28' then
          WriteLn(ArqOut,Copy(Linha,7,Length(Linha) - 6))
        else
        if Copy(Linha, 12, 2)='73' then
          WriteLn(ArqOut,Copy(Linha,7,Length(Linha) - 6))
        else
        if Copy(Linha, 7, 6)='525922' then
          WriteLn(ArqOut,Copy(Linha,7,Length(Linha) - 6));
      end;
    CloseFile(ArqTxt);
    End;
  Dec(QtdArqs);
  Edit1.Text := IntToStr(QtdArqs);
  Application.ProcessMessages;
  System.SysUtils.FindClose(F);
  end;

CloseFile(ArqOut);

Edit2.Text := '';
Application.ProcessMessages;

// Vai Iniciar o Sort do índice menor...

ListBox1.Clear;
ListBox1.Items.Add('Iniciando Processamento do índice');
ListBox1.Items.Add('Realizando a carga');
Application.ProcessMessages;

ArqIn := TFileStream.Create(Base+'0.txt', fmOpenRead);

SetLength(Sortudo, ArqIn.Size div SizeOf(RegistroIn));

for I := Low(Sortudo) to High(Sortudo) do
  Begin
  Sortudo[I].Posic := ArqIn.Position;

  ArqIn.Read(RegistroIn, SizeOf(RegistroIn));

  Sortudo[I].Conta := RegistroIn.Conta;
  Sortudo[I].Data := RegistroIn.DataVencto;
  End;

ArqIn.Free;

ListBox1.Items.Add('Organizando...');
Application.ProcessMessages;

TArray.Sort<RegIndiceSort>(Sortudo);

ListBox1.Items.Add('Descarregando...');
Application.ProcessMessages;

ArqCont := TFileStream.Create(Base+'CONTA.txt', fmOpenRead);

RegistroCont.Conta := '0000000000000000';

ArqS := TFileStream.Create(Base+'1.txt', fmCreate);
ArqIn := TFileStream.Create(Base+'0.txt', fmOpenRead);

for I := Low(Sortudo) to High(Sortudo) do
  Begin

  while (ArqCont.Position < ArqCont.Size) and (RegistroCont.Conta < Sortudo[I].Conta) do
    ArqCont.Read(RegistroCont, SizeOf(RegistroCont));

  if RegistroCont.Conta = Sortudo[I].Conta then
    begin
    ArqS.Write(RegistroCont.NomeExt, SizeOf(RegistroCont.NomeExt));
    ArqS.Write(RegistroCont.CpfCgc, SizeOf(RegistroCont.CpfCgc));

    ArqIn.Seek(Sortudo[I].Posic, SoBeginning);
    ArqIn.Read(RegistroIn, SizeOf(RegistroIn));

    ArqS.Write(RegistroIn, SizeOf(RegistroIn));

    end
  else
    begin
    ArqS.Write(Caca, SizeOf(Caca));
    ArqIn.Seek(Sortudo[I].Posic, SoBeginning);
    ArqIn.Read(RegistroIn, SizeOf(RegistroIn));

    ArqS.Write(RegistroIn, SizeOf(RegistroIn));
    end;

  End;

ArqCont.Free;
ArqIn.Free;
ArqS.Free;

ShowMessage('Fim de processamento...');
end;

procedure TForm1.SairButtonClick(Sender: TObject);
begin
Close;
end;

end.
