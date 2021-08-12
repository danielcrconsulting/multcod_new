unit AgrupaContCart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Subrug;

type
  TForm1 = class(TForm)
    ButtonJuntar: TButton;
    Button2: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure ButtonJuntarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  Buff1 : Array[1..1024*1024*100] of char;

  Arr1,
  Arr2 : Array of AnsiString;

implementation

{$R *.dfm}

Procedure SortEmMemoriaCart(PosChave1, TamChave1, PosChave2, TamChave2 : Integer);

  Procedure QuickSort(iLo, iHi: Integer);
  Var
    Lo, Hi : Integer;
    Mid, T : AnsiString;
  Begin

    Lo := iLo;
    Hi := iHi;

    Mid := Arr1[(Lo + Hi) div 2];

    Repeat
      While Copy(Arr1[Lo], PosChave1, TamChave1) + Copy(Arr1[Lo], PosChave2, TamChave2) <
            Copy(Mid, PosChave1, TamChave1) + Copy(Mid, PosChave2, TamChave2) do
        Inc(Lo);

      While Copy(Arr1[Hi], PosChave1, TamChave1) + Copy(Arr1[Hi], PosChave2, TamChave2) >
            Copy(Mid, PosChave1, TamChave1) + Copy(Mid, PosChave2, TamChave2) do
        Dec(Hi);

      If Lo <= Hi then
      Begin
        T := Arr1[Lo];
        Arr1[Lo] := Arr1[Hi];
        Arr1[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      End;
    Until Lo > Hi;
    If Hi > iLo Then QuickSort(iLo, Hi);
    If Lo < iHi Then QuickSort(Lo, iHi);
  End;

Begin
QuickSort(Low(Arr1), High(Arr1));
Application.ProcessMessages;
End;

Procedure SortEmMemoriaCont(PosChave, TamChave : Integer);

  Procedure QuickSort(iLo, iHi: Integer);
  Var
    Lo, Hi : Integer;
    Mid, T : AnsiString;
  Begin

    Lo := iLo;
    Hi := iHi;

    Mid := Arr1[(Lo + Hi) div 2];

    Repeat
      While Copy(Arr1[Lo], PosChave, TamChave) < Copy(Mid, PosChave, TamChave) do
        Inc(Lo);

      While Copy(Arr1[Hi], PosChave, TamChave) > Copy(Mid, PosChave, TamChave) do
        Dec(Hi);

      If Lo <= Hi then
      Begin
        T := Arr1[Lo];
        Arr1[Lo] := Arr1[Hi];
        Arr1[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      End;
    Until Lo > Hi;
    If Hi > iLo Then QuickSort(iLo, Hi);
    If Lo < iHi Then QuickSort(Lo, iHi);
  End;

Begin
QuickSort(Low(Arr1), High(Arr1));
Application.ProcessMessages;
End;

procedure TForm1.ButtonJuntarClick(Sender: TObject);
Var
  NomeArqIn,
  Reports1Str,
  Linha,
  Linha1,
  Anterior : AnsiString;

  SearchRecTxt : TSearchRec;

  ArqIn,
  ArqOut : System.Text;

  Posic,
  TotReg : Integer;
  Val1,
  Val2 : Extended;

  Procedure Vai (Nome : String; PosChave1, TamChave1, PosChave2, TamChave2 : Integer);

  Var
    I : Integer;
  begin

  If (FindFirst(Reports1Str,faAnyFile,SearchRecTxt) = 0) Then
    begin
    Repeat
      if UpperCase(SearchRecTxt.Name) <> Nome + '.TXT' then
        begin
        NomeArqIn := SearchRecTxt.Name;
        Edit3.Text := 'Contando ' + SearchRecTxt.Name;
        Application.ProcessMessages;
        AssignFile(ArqIn, SearchRecTxt.Name);
        System.SetTextBuf(ArqIn, Buff1);
        Reset(ArqIn);

        while Not Eof(ArqIn) do
          begin
            Readln(arqIn, Linha);
            Inc(TotReg);
          end;
        CloseFile(ArqIn);
        end;
    Until FindNext(SearchRecTxt) <> 0;

    FindClose(SearchRecTxt);
    end
  Else
    Exit; // No files found

  SetLength(Arr1, TotReg);

  TotReg := 0;
  AssignFile(ArqIn, NomeArqIn);
  System.SetTextBuf(ArqIn, Buff1);
  Reset(ArqIn);

  If (FindFirst(Reports1Str,faAnyFile,SearchRecTxt) = 0) Then
    Repeat
      if UpperCase(SearchRecTxt.Name) <> Nome + '.TXT' then
        begin
        NomeArqIn := SearchRecTxt.Name;
        Edit3.Text := 'Carregando ' + SearchRecTxt.Name;
        Application.ProcessMessages;
        AssignFile(ArqIn, SearchRecTxt.Name);
        System.SetTextBuf(ArqIn, Buff1);
        Reset(ArqIn);
        while Not Eof(ArqIn) do
          begin
            Readln(arqIn, Arr1[TotReg]);
            Inc(TotReg);
          end;
        CloseFile(ArqIn);
        end;
    Until FindNext(SearchRecTxt) <> 0;

  FindClose(SearchRecTxt);

  Edit3.Text := 'Ordenando...';
  Application.ProcessMessages;

  if TamChave2 <> 0 then
    SortEmMemoriaCart(PosChave1, TamChave1, PosChave2, TamChave2)
  Else
    SortEmMemoriaCont(PosChave1, TamChave1);

  Edit3.Text := 'Descarregando...';
  Application.ProcessMessages;

  AssignFile(ArqOut, Nome+'.TXT');
  System.SetTextBuf(ArqOut, Buff1);
  Rewrite(ArqOut);

  for I := Low(Arr1) to High(Arr1) do
    begin
      WriteLn(ArqOut, Arr1[I]);
    end;

  CloseFile(ArqOut);

  end;


begin

TotReg := 0;
Reports1Str := 'ICSRCARTBMG*.TXT';
Vai('ICSRCARTBMG_', 28, 16, 12, 16);

TotReg := 0;
Reports1Str := 'ICSRCONTBMG*.TXT';
Vai('ICSRCONTBMG_', 12, 16, 0, 0);

ShowMessage('Fim de processamento...');

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

end.
