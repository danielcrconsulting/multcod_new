Unit Asort;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sugeral, Index, ExtCtrls;

Type
  TSortMem = Class(TForm)
  Private
    { Private declarations }
  Public
    { Public declarations }
  ArInd : Array Of TgIndiceI64F;
  TamArr : Integer;
  T : TgIndiceI64F;

  TamArrCpfCgc,
  TamArrCartao : Integer;
//  ArIndNumGer : Array Of TgIndiceNumGer;
//  TNumGer : TgIndiceNumGer;

//  ArIndNumCnt : Array Of TgIndiceNumCnt;
//  TamArrNumCnt : Integer;
//  TNumCnt : TgIndiceNumCnt;

  ArIndNome : Array Of TgIndiceNome;
  TamArrNome : Integer;
  TNome : TgIndiceNome;

  Procedure SortEmMemoria;
//  Procedure SortEmMemoriaNumGer;
//  Procedure SortEmMemoriaNumCnt;
  Procedure SortEmMemoriaNome;


  End;

//  TSortMemCeA = Class
//  Private
    { Private declarations }
//  Public
    { Public declarations }
//  End;

Var
  SortMem : TSortMem;
//  SortMemCeA : TSortMemCeA;
  
Implementation

{$R *.dfm}

// Sort em memória...

{ TQuickSort }

Procedure TSortMem.SortEmMemoria;

Var
  CrL, A : Int64;

  Procedure QuickSort(iLo, iHi: Integer);
  Var
    Lo, Hi, K : Integer;
    Mid : TgIndiceI64F;
  Begin

    Inc(CrL);
    If (CrL Mod 100000) = 0 Then
      FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);

    Lo := iLo;
    Hi := iHi;

    //    Mid := ArInd[(Lo + Hi) div 2];

    K := Random(Hi);
    If K < Lo Then
      K := Lo;
    Mid := ArInd[K];

    Repeat
      While (ArInd[Lo].Valor < Mid.Valor) Or
            ((ArInd[Lo].Valor = Mid.Valor) And
             (ArInd[Lo].TipoConta < Mid.TipoConta)) Or
            ((ArInd[Lo].Valor = Mid.Valor) And
             (ArInd[Lo].TipoConta = Mid.TipoConta) And (ArInd[Lo].PosIni < Mid.PosIni)) do
        Inc(Lo);
      Inc(A,Lo-iLo);
      While (ArInd[Hi].Valor > Mid.Valor) Or
            ((ArInd[Hi].Valor = Mid.Valor) And
             (ArInd[Hi].TipoConta > Mid.TipoConta)) Or
            ((ArInd[Hi].Valor = Mid.Valor) And
             (ArInd[Hi].TipoConta = Mid.TipoConta) And (ArInd[Hi].PosIni > Mid.PosIni)) do
        Dec(Hi);
      Inc(A,iHi-Hi);
      If Lo <= Hi then
      Begin
        T := ArInd[Lo];
        ArInd[Lo] := ArInd[Hi];
        ArInd[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      End;
    Until Lo > Hi;
    If Hi > iLo Then QuickSort(iLo, Hi);
    If Lo < iHi Then QuickSort(Lo, iHi);
  End;

Begin
Crl := 0;
A := 0;
Randomize;
QuickSort(Low(ArInd), High(ArInd));
FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);
Application.ProcessMessages;
End;

{Procedure TSortMem.SortEmMemoriaNumGer;
Var
  CrL, A : Int64;

  Procedure QuickSort(iLo, iHi: Integer);
  Var
    Lo, Hi, K : Integer;
    Mid : TgIndiceNumGer;
  Begin

    Inc(CrL);
    If (CrL Mod 100000) = 0 Then
      FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);

    Lo := iLo;
    Hi := iHi;

    //    Mid := ArInd[(Lo + Hi) div 2];

    K := Random(Hi);
    If K < Lo Then
      K := Lo;
    Mid := ArIndNumGer[K];

    Repeat
      While (ArIndNumGer[Lo].Valor < Mid.Valor) Or
            ((ArIndNumGer[Lo].Valor = Mid.Valor) And
             (ArIndNumGer[Lo].Conta < Mid.Conta)) Do
        Inc(Lo);
      Inc(A,Lo-iLo);
      While (ArIndNumGer[Hi].Valor > Mid.Valor) Or
            ((ArIndNumGer[Hi].Valor = Mid.Valor) And
             (ArIndNumGer[Hi].Conta > Mid.Conta)) Do
        Dec(Hi);
      Inc(A,iHi-Hi);
      If Lo <= Hi then
      Begin
        TNumGer := ArIndNumGer[Lo];
        ArIndNumGer[Lo] := ArIndNumGer[Hi];
        ArIndNumGer[Hi] := TNumGer;
        Inc(Lo);
        Dec(Hi);
      End;
    Until Lo > Hi;
    If Hi > iLo Then QuickSort(iLo, Hi);
    If Lo < iHi Then QuickSort(Lo, iHi);
  End;

Begin
Crl := 0;
A := 0;
Randomize;
QuickSort(Low(ArIndNumGer), High(ArIndNumGer));
FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);
Application.ProcessMessages;
End;

Procedure TSortMem.SortEmMemoriaNumCnt;
Var
  CrL, A : Int64;

  Procedure QuickSort(iLo, iHi: Integer);
  Var
    Lo, Hi, K : Integer;
    Mid : TgIndiceNumCnt;
  Begin

    Inc(CrL);
    If (CrL Mod 100000) = 0 Then
      FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);

    Lo := iLo;
    Hi := iHi;

    //    Mid := ArInd[(Lo + Hi) div 2];

    K := Random(Hi);
    If K < Lo Then
      K := Lo;
    Mid := ArIndNumCnt[K];

    Repeat
      While (ArIndNumCnt[Lo].Conta < Mid.Conta) Or
            ((ArIndNumCnt[Lo].Conta = Mid.Conta) And
             (ArIndNumCnt[Lo].Ciclo < Mid.Ciclo)) Do
        Inc(Lo);
      Inc(A,Lo-iLo);
      While (ArIndNumCnt[Hi].Conta > Mid.Conta) Or
            ((ArIndNumCnt[Hi].Conta = Mid.Conta) And
             (ArIndNumCnt[Hi].Ciclo > Mid.Ciclo)) Do
        Dec(Hi);
      Inc(A,iHi-Hi);
      If Lo <= Hi then
      Begin
        TNumCnt := ArIndNumCnt[Lo];
        ArIndNumCnt[Lo] := ArIndNumCnt[Hi];
        ArIndNumCnt[Hi] := TNumCnt;
        Inc(Lo);
        Dec(Hi);
      End;
    Until Lo > Hi;
    If Hi > iLo Then QuickSort(iLo, Hi);
    If Lo < iHi Then QuickSort(Lo, iHi);
  End;

Begin
Crl := 0;
A := 0;
Randomize;
QuickSort(Low(ArIndNumCnt), High(ArIndNumCnt));
FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);
Application.ProcessMessages;
End;      }

Procedure TSortMem.SortEmMemoriaNome;
Var
  CrL, A : Int64;

  Procedure QuickSort(iLo, iHi: Integer);
  Var
    Lo, Hi, K : Integer;
    Mid : TgIndiceNome;
  Begin

    Inc(CrL);
    If (CrL Mod 100000) = 0 Then
      FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);

    Lo := iLo;
    Hi := iHi;

    //    Mid := ArInd[(Lo + Hi) div 2];

    K := Random(Hi);
    If K < Lo Then
      K := Lo;
    Mid := ArIndNome[K];

    Repeat
      While (ArIndNome[Lo].Valor < Mid.Valor) Or
            ((ArIndNome[Lo].Valor = Mid.Valor) And
             (ArIndNome[Lo].Conta < Mid.Conta)) Do
        Inc(Lo);
      Inc(A,Lo-iLo);
      While (ArIndNome[Hi].Valor > Mid.Valor) Or
            ((ArIndNome[Hi].Valor = Mid.Valor) And
             (ArIndNome[Hi].Conta > Mid.Conta)) Do
        Dec(Hi);
      Inc(A,iHi-Hi);
      If Lo <= Hi then
      Begin
        TNome := ArIndNome[Lo];
        ArIndNome[Lo] := ArIndNome[Hi];
        ArIndNome[Hi] := TNome;
        Inc(Lo);
        Dec(Hi);
      End;
    Until Lo > Hi;
    If Hi > iLo Then QuickSort(iLo, Hi);
    If Lo < iHi Then QuickSort(Lo, iHi);
  End;

Begin
Crl := 0;
A := 0;
Randomize;
QuickSort(Low(ArIndNome), High(ArIndNome));
FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := 'Ordenando... '+IntToStr(Crl)+ ' R '+IntToStr(A);
Application.ProcessMessages;
End;

End.
