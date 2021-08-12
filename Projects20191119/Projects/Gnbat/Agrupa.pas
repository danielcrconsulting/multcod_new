unit Agrupa;

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

  Buf1 : Array[1..2] of Char;
  T1, T2 : String;

implementation

{$R *.dfm}

Procedure SortEmMemoria(PosChave, TamChave : Integer);

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
//A := Length(Arr1[0])-1;
//While (Arr1[1][A] <> ';') And (A > 0) do
//  Dec(A);

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

  Procedure Soma(Var Ant, Atu : AnsiString);
  Var
    A : Integer;
    V1 : AnsiString;
  Begin
  A := Length(Ant)-1;
  While (Ant[A] <> ';') And (A > 0) do
    Dec(A);
  Inc(A);

  FormatSettings.DecimalSeparator := ',';
  V1 := Copy(Ant, A, Length(Ant)-A);
  Val1 := StrToFloat(String(SeTiraPonto(SeTiraBranco(V1))));;

  A := Length(Atu)-1;
  While (Atu[A] <> ';') And (A > 0) do
    Dec(A);
  Inc(A);

  V1 := Copy(Atu, A, Length(Atu)-A);
  Val2 := StrToFloat(String(SeTiraPonto(SeTiraBranco(V1))));

  Ant := Copy(Ant, 1, A) + FloatToStr(Val2+Val1) + ';';
  End;

  Procedure Vai (Nome : String; PosChave, TamChave : Integer);

  Var
    I : Integer;
    Cabec : AnsiString;
  begin

  If (FindFirst(Reports1Str,faAnyFile,SearchRecTxt) = 0) Then
    begin
    Repeat
      NomeArqIn := SearchRecTxt.Name;
      AssignFile(ArqIn, SearchRecTxt.Name);
      System.SetTextBuf(ArqIn, Buff1);
      Reset(ArqIn);

      while Not Eof(ArqIn) do
        begin
          Readln(arqIn, Linha);
          Inc(TotReg);
        end;
      CloseFile(ArqIn);
    Dec(TotReg);
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
        begin
        NomeArqIn := SearchRecTxt.Name;
        AssignFile(ArqIn, SearchRecTxt.Name);
        System.SetTextBuf(ArqIn, Buff1);
        Reset(ArqIn);
        ReadLn(ArqIn, Cabec);
        while Not Eof(ArqIn) do
          begin
            Readln(arqIn, Arr1[TotReg]);
            Inc(TotReg);
          end;
        CloseFile(ArqIn);
        end;
    Until FindNext(SearchRecTxt) <> 0;

  FindClose(SearchRecTxt);

  SortEmMemoria(PosChave, TamChave);

  AssignFile(ArqOut, Nome+'.TXT');
  System.SetTextBuf(ArqOut, Buff1);
  Rewrite(ArqOut);

  WriteLn(ArqOut, Cabec);
  Anterior := Arr1[Low(Arr1)];

  for I := Low(Arr1)+1 to High(Arr1) do
    begin
      Linha := Copy(Arr1[I], PosChave, TamChave);
      Linha1 := Copy(Anterior, PosChave, TamChave);
      if Linha  <> Linha1 then
        begin
        Posic := Pos(';', Anterior);
        Anterior :=  Nome + Copy(Anterior, Posic, Length(Anterior)-Posic+1);
        WriteLn(ArqOut, Anterior);
        Anterior := Arr1[I];
        end
      else
        begin
          Soma(Anterior, Arr1[I]);
        end;
    end;

  CloseFile(ArqOut);

  end;


begin

(*TotReg := 0;
Reports1Str := 'BRH137R*.TXT';
Vai('XBRH137R', 21, 35);

TotReg := 0;
Reports1Str := 'CCFC6020*.TXT';
Vai('XCCFC6020', 23, 35);

ShowMessage('Fim de processamento...'); *)

Buf1[1] := '1';
Buf1[2] := '2';
T1 := StringOfChar('1', 50);
T2 := '';
T2 := String.Create(Buf1, 2, 50);

ShowMessage(T1);
ShowMessage(IntToStr(Length(T2)));
ShowMessage(T2);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

end.
