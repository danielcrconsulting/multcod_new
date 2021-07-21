
(****************************************************************)
(*                     DATABASE TOOLBOX 5.0                     *)
(*     Copyright (c) 1984, 87 by Borland International, Inc.    *)
(*     Copyright (c) 1996 by CR Consulting S/C Ltda.            *)
(*                                                              *)
(*                    TURBO SORT UNIT                           *)
(*                                                              *)
(*  Purpose: Toolbox of routines to implement a general         *)
(*           purpose QuickSort for up to 2GB data items.        *)
(*                                                              *)
(****************************************************************)

Unit SSort;

Interface

Type

  SuperSort = Class (TObject)
          Function TurboSort(ItemLength : word; NBuffers : Integer) : Byte;

{ ItemLength is the size of the item to be sorted (in bytes).
  Use SizeOf(MyRec) to calculate this value. }

          Procedure SortRelease(Var ReleaseRecord);

{ Called by the user's input routine to pass a record in to be
  sorted. }

          Procedure SortReturn(Var ReturnRecord);

{ Called by the user's output routine to retrieve the next
  record from the sort. }

          Function SortEOS : boolean;

{ Called by the user's output routine, SortEOS returns true if all
  of the sorted records have been returned. }


          Procedure InputSort; Virtual;

          Procedure OutputSort; Virtual;

          Function Less(Var x, y) : boolean; Virtual;

{ Estas Funções deverão ser redefinidas pelo usuário }

          End;

Implementation

{$I-}

Type
   SortPointer = ^Byte;

Var
   PageSize : Integer;         { No of bytes pr page            }

   SortRecord : Record  { Global variables used by all routines }
                        { variables concerning paging }
                N           : Integer; { no of records to be sorted      }
                B           : Integer; { no of records pr page           }
//                Pages       : 0..40;   { No of pages in memory           }
                Pages       : Integer;   { No of pages in memory           }
//                SecPrPage,             { no of sectors pr page           }
                RegsPrPage,             { no of sectors pr page           }
                NDivB,
                NModB       : Integer; { = N Div B, N Mod B respectively }

//                Buf         : Array[0..40] Of SortPointer;
                Buf         : Array Of SortPointer;
                                          { Addresses of buffers            }
//                Page        : Array[0..40] Of LongInt;
                Page        : Array Of Integer;
                                          { Nos of pages in workarea        }
//                W           : Array[0..40] Of Boolean;
                W           : Array Of Boolean;
                                          { dirty-bits : is page changed ?  }

                Udix        : Integer; { Udix points to the next record
                                             to be returned }

                F           : File;    { File used for external sorting  }

                FileCreated : Boolean; { Is external file used           }

                Error       : Integer; { Has an i/o error occurred       }

                ItemLength  : Word; { Length of record                }
                End;

   Procedure SortPut(Addr : SortPointer; PageNo : Integer);
      { Write page PageNo on file, address of page in memory is Addr }
   Var
     BW : Integer;
   Begin
   If SortRecord.Error=0 Then
     Begin  { No i/o error }
//     Seek(SortRecord.F, PageNo*SortRecord.SecPrPage);
//     BlockWrite(SortRecord.F, Addr^, SortRecord.SecPrPage, BW);
//     Seek(SortRecord.F, PageNo*SortRecord.RegsPrPage);
//     BlockWrite(SortRecord.F, Addr^, SortRecord.RegsPrPage, BW);
     Seek(SortRecord.F, PageNo);
     BlockWrite(SortRecord.F, Addr^, 1, BW);
     If BW = 0 Then
       SortRecord.Error:=10  { write error }
     End
   End;

   Procedure SortFetchAddr( Ix: Integer; Var Adr: SortPointer);
      { Find address in memory for record no Ix. It is assumed
        that record Ix is in memory }

   Var IxPage, // : LongInt;
       I,     //  : 0..40;
       EndInt : Integer;
       PSoma : Pointer Absolute EndInt;

   Begin
   IxPage:= Ix Div SortRecord.B;
   I:= 0;
   While SortRecord.Page[I] <> IxPage Do
     Inc(I);
      { IxPage = SortRecord.Page [I] }
{   Adr:=Ptr(Seg(SortRecord.Buf[I]^),
            Ofs(SortRecord.Buf[I]^) +
            (Ix Mod SortRecord.B)* SortRecord.ItemLength);}
   PSoma := @SortRecord.Buf[I]^;
   Adr := Ptr(EndInt + ((Ix Mod SortRecord.B)* SortRecord.ItemLength));
   End;

   Procedure SortFetchPage( Ix, U1, U2: Integer);
      { After call of SortFetchPage the record Ix is in memory.
        If records U1 and U2 are in memory before call, then
        they are not overwritten since we soon will need them   }

   Var U1Page,
       U2Page,
       IxPage, // : LongInt;
       Victim : Integer; // : 0..40;   { The chosen page to be written to file }

     Procedure SOget(Addr: SortPointer; Pageno: Integer);
         { Read page PageNo into memory at address Addr }
     Var
       BR : Integer;
     Begin
     If SortRecord.Error = 0 Then
       Begin
//       Seek(SortRecord.F, Pageno*SortRecord.SecPrPage);
//       BlockRead(SortRecord.F, Addr^, SortRecord.SecPrPage, BR);
//       Seek(SortRecord.F, Pageno*SortRecord.RegsPrPage);
//       BlockRead(SortRecord.F, Addr^, SortRecord.RegsPrPage, BR);
       Seek(SortRecord.F, Pageno);
       BlockRead(SortRecord.F, Addr^, 1, BR);
       If BR = 0 Then
         SortRecord.Error := 11  { read error }
       End;
     End;

     Function InMem( Ix: Integer): Boolean;
         { InMem returns true if record ix is in memory }
     Var I,IxPage : Integer;
         Flag     : Boolean;
     Begin
     IxPage:= Ix Div SortRecord.B;
     Flag:=False;
     For I:=0 To SortRecord.Pages-1 Do
       If Ixpage=SortRecord.Page[I] Then
         Flag:=True;
     InMem:=Flag
     End;

   Begin   { SortFetchPage }
   If (Not InMem(Ix)) Then
     Begin
         { Record Ix not in memory }
     IxPage:= Ix Div SortRecord.B;
     Victim:=0;
     U1Page:=U1 Div SortRecord.B;
     U2Page:=U2 Div SortRecord.B;
     While ((SortRecord.Page[Victim]=U1Page) Or
           (SortRecord.Page[Victim]=U2Page)) Do
       Inc(Victim);
         { SortRecord.Page[Victim] not in U }
     If SortRecord.W[Victim] Then     { Dirty bit set }
       SortPut(SortRecord.Buf[Victim],SortRecord.Page[Victim]);
     SoGet(SortRecord.Buf[Victim],IxPage);
     SortRecord.Page[Victim]:= IxPage;
     SortRecord.W[Victim]:= False;
     End
   End;

Function SuperSort.TurboSort(ItemLength : Word; NBuffers : Integer) : Byte;

   { Function TurboSort returns an byte specifying the result of the sort
     TurboSort=0  : Sorted
     TurboSort=3  : Workarea too small
     TurboSort=8  : Illegal itemlength
     TurboSort=9  : More than maxint records
     TurboSort=10 : Write error during sorting ( disk full )
     TurboSort=11 : Read error during sorting
     TurboSort=12 : Impossible to create new file ( directory full ) }

//   Const
//      SecSize = 128;      Sector Size não está mais limitado a 128 como antigamente

   Var
      SaveZ,
      SwopPost : SortPointer;
      I,
      WorkArea : Integer;      { No of bytes internal memory    }

//      PageSize : Word;         { No of bytes pr page            }

   Procedure QuickSort;
      { Non-recursive version of quicksort algorithm as given
        in Nicklaus Wirth : Algorithms + Data Structures = Programs }

      Procedure Exchange(I, J : Integer);
         { Change records I and J }
      Var
        P,R,S,          //   : LongInt;
        K,L  : Integer; //     : 0..40;
        IAddr,
        JAddr   : SortPointer;
        AuxPointer : Pointer;
        AuxInt : Integer Absolute AuxPointer;
      Begin
      P := I Div SortRecord.B;
      K := 0;
      While SortRecord.Page[k] <> P Do
        Inc(K);
      P := J Div SortRecord.B;
      L := 0;
      While SortRecord.Page[L] <> P Do
        Inc(L);
      R := I Mod SortRecord.B;
      S := J Mod SortRecord.B;
{      IAddr:= Ptr(Seg(SortRecord.Buf[K]^),
                  Ofs(SortRecord.Buf[K]^) + R*ItemLength); }
      AuxPointer := @SortRecord.Buf[K]^;
      IAddr := Ptr(AuxInt + (R*ItemLength));
{      JAddr:= Ptr(Seg(SortRecord.Buf[L]^),
                  Ofs(SortRecord.Buf[L]^) + S*ItemLength);}
      AuxPointer := @SortRecord.Buf[L]^;
      JAddr := Ptr(AuxInt + (S*ItemLength));

      Move(IAddr^, SwopPost^, ItemLength);
      Move(JAddr^, IAddr^, ItemLength);
      Move(Swoppost^, JAddr^, ItemLength);
      SortRecord.W[K] := True;
      SortRecord.W[L] := True;
      End;

      Const
         MaxStack = 32; { Log2(N) = MaxStack, i. e. for MaxStack = 32
                         it is possible to sort up to MaxLongInt records    }
      Var
         { The stacks }
        LStack : Array[1..MaxStack] Of Integer; { Stack of left  index }
        RStack : Array[1..MaxStack] Of Integer; { Stack of right index }
        Sp     : Integer;                          { Stack SortPointer    }

        M,L,R,I,J         : Integer;
        XAddr,YAddr,ZAddr : SortPointer;

   Begin
      { The quicksort algorithm }
   If SortRecord.N>0 Then
     Begin
     LStack[1]:=0;
     RStack[1]:=SortRecord.N-1;
     Sp:=1
     End
   Else
     Sp:=0;

   While Sp>0 do
     Begin
         { Pop(L,R) }
     L:=LStack[Sp];
     R:=RStack[Sp];
     Dec(Sp);
     Repeat
       I:=L;
       J:=R;
       M:=(I+J) Shr 1;
       SortFetchPage(M,I,J);       { get M, hold I and J }
            { record M in memory}
       If SortRecord.Error<>0 Then
         Exit; { End program }
       SortFetchAddr(M,ZAddr);
       Move(ZAddr^,SaveZ^,ItemLength);
       Repeat
         SortFetchPage(I,J,M);    { get I, hold J and M }
               { I and M in memory }
         If SortRecord.Error<>0 Then
           Exit; { End program }
         SortFetchAddr(I,XAddr);
         While Less(XAddr^,SaveZ^) Do
           Begin
           Inc(I);
           SortFetchPage(I,J,M);
           SortFetchAddr(I,XAddr);
           If SortRecord.Error<>0 Then
             Exit; { End program }
           End;
               { I and M in memory }
         SortFetchPage(J,I,M);     { Get J, hold I and M }
               { I, J and M in memory }
         If SortRecord.Error<>0 Then
           Exit;  { End program }
         SortFetchAddr(J,YAddr);
         While Less(SaveZ^,YAddr^) Do
           Begin
           Dec(J);
           SortFetchPage(J,I,M);
           SortFetchAddr(J,YAddr);
           If SortRecord.Error<>0 Then
             Exit;  { End program }
           End;
               { I, J and M in memory }
         If I<=J Then
           Begin
           If I<>J Then
             Exchange(I,J);
           Inc(I);
           Dec(J);
           End;
       Until I>J;
            { Push longest interval on stack }
       If J-L < R-I Then
         Begin
         If I<R Then
           Begin
                  { Push(I,R) }
           Inc(Sp);
           LStack[Sp]:=I;
           RStack[Sp]:=R;
           End;
         R:=J
         End
       Else
         Begin
         If L<J Then
           Begin
                  { Push(L,J) }
           Inc(Sp);
           LStack[Sp]:=L;
           RStack[Sp]:=J;
           End;
         L:=I
         End;

     Until L>=R
   End;
End  { QuickSort };

Begin { TurboSort }
If ItemLength > 1 Then
  Begin
  SortRecord.ItemLength := ItemLength;

{  WorkArea:= (MaxAvail div 2);                 { Voltar a testar em 32 bits }
{  if WorkArea > 8355840 then
    WorkArea := 8355840; { Barreira dos 64k }

 { SortRecord.Pages := WorkArea div (2*MaxInt) + 1; }

//  WorkArea := 2048 * 1024;     { 2 megas de buffer }
  WorkArea := 1024 * 1024 * 10;  { 10 megas de buffer }

//  SortRecord.Pages := 40;
//  SortRecord.Pages := 3;     // 30 megas em memória
//  SortRecord.Pages := 6;     // 60 megas em memória

  SortRecord.Pages := NBuffers;
      { No of pages to be kept in memory }

  If SortRecord.Pages < 3 Then                   { Must be at least 3 }
    SortRecord.Pages:=3;

  SetLength(SortRecord.Buf,SortRecord.Pages);
  SetLength(SortRecord.Page,SortRecord.Pages);
  SetLength(SortRecord.W,SortRecord.Pages);

//  SortRecord.SecPrPage := (WorkArea div SecSize) Div SortRecord.Pages;
  SortRecord.RegsPrPage := (WorkArea Div ItemLength);
//  If SortRecord.SecPrPage > 20 Then
//    SortRecord.SecPrPage:=4*(SortRecord.SecPrPage div 4);

//  PageSize := SortRecord.SecPrPage * SecSize; { May be negative or 0 }
  PageSize := SortRecord.RegsPrPage * ItemLength;

  SortRecord.B:= PageSize Div ItemLength;

  If SortRecord.B > 0 Then
    Begin { Enough memory }
    GetMem(SwopPost, ItemLength);
    GetMem(SaveZ, ItemLength);
    For I := 0 To SortRecord.Pages - 1 Do
      GetMem(SortRecord.Buf[I], PageSize);

    Result := 0;

    If Result = 0 Then; // Parar com a warning...

    SortRecord.Error := 0;
    SortRecord.FileCreated := False;
    SortRecord.N := 0;
    SortRecord.NModB := 0;
    SortRecord.NDivB := 0;
    For I := 0 To SortRecord.Pages - 1 Do
      SortRecord.Page[I] := I;

    InputSort;   { call user defined input procedure }
                 { all records are read }

    If SortRecord.Error = 0 Then
      Begin
            { No errors while reading records }
            { Initialize virtual system }
      For I := 0 To SortRecord.Pages - 1 Do
        SortRecord.W[I] := True;

      If SortRecord.Error = 0 Then
        Quicksort;

            { End sort, return all records }
      SortRecord.Udix := 0;
      If SortRecord.Error = 0 Then
        OutPutSort;  { call user defined output procedure }
      End;

    If SortRecord.FileCreated Then
      Begin
      Close(SortRecord.F);
      Erase(SortRecord.F)
      End;

         { Release allocated memory }
    For I:=SortRecord.Pages-1 DownTo 0 Do
      FreeMem(SortRecord.Buf[I],PageSize);
    FreeMem(SaveZ,ItemLength);
    FreeMem(SwopPost,ItemLength);

    End
  Else
    SortRecord.Error := 3; { Too little memory  }
  End
Else
  SortRecord.Error := 8;    { Illegal itemlength }
Result := SortRecord.Error;
End; { TurboSort }

{ Procedures used by user routines }

 Procedure SuperSort.SortRelease(Var ReleaseRecord);
     { Accept record from user }
 Var
//   I,BufNo : Word;
   I,BufNo : Integer;
   Point : SortPointer;
 Begin
 If SortRecord.Error=0 Then
   Begin
   If SortRecord.N=MaxLongInt Then  { Only possible to sort MaxLongInt records }
     begin
     SortRecord.Error:=9;
     Exit;
     end;
   If ((SortRecord.NModB=0) And (SortRecord.NDivB >= SortRecord.Pages)) Then
     Begin
          { Write out last read page }
     If SortRecord.NDivB = SortRecord.Pages Then
       Begin
             { create user file }
       AssignFile(SortRecord.F, 'SOWRK.$$$');
       Rewrite(SortRecord.F,PageSize);
       If IOResult <> 0 Then
         SortRecord.Error := 12
       Else
         SortRecord.FileCreated := True;
             { Fill page 0 to Pages-2 }
       For I:=0 To SortRecord.Pages-2 Do
{         SortPut(Ptr(DSeg,0), I); }
//         SortPut(Addr(I), I);
         SortPut(SortRecord.Buf[SortRecord.Pages-1], I);
       End;
          { Write user record in last page }
     SortPut(SortRecord.Buf[SortRecord.Pages-1], SortRecord.Page[SortRecord.Pages-1]);
     Inc(SortRecord.Page[SortRecord.Pages-1]);
     End;

   If SortRecord.NDivB>=SortRecord.Pages Then
     BufNo:=SortRecord.Pages-1
   Else
     BufNo:=SortRecord.NDivB;
   Point := @SortRecord.Buf[BufNo]^;
   Inc(Point, SortRecord.NModB*SortRecord.ItemLength);
   {Point:= Ptr(Seg(SortRecord.Buf[BufNo]^),
               Ofs(SortRecord.Buf[BufNo]^) +
               SortRecord.NModB*SortRecord.ItemLength);}
   Move(ReleaseRecord,Point^,SortRecord.ItemLength);
   Inc(SortRecord.N);
   Inc(SortRecord.NModB);
   If SortRecord.NModB=SortRecord.B Then
     Begin
     SortRecord.NModB:=0;
     Inc(SortRecord.NDivB)
     End;
   End;
End   { SortRelease };

Procedure SuperSort.SortReturn(Var ReturnRecord);
      { Return record to user }
   Var AuxAddr : SortPointer;
Begin
If SortRecord.Error=0 Then
  Begin
  SortFetchPage(SortRecord.Udix,SortRecord.N-1,-SortRecord.B);
  SortFetchAddr(SortRecord.Udix,AuxAddr);
  Move(AuxAddr^,ReturnRecord,SortRecord.ItemLength);
  Inc(SortRecord.Udix)
  End
End   { SortReturn };

Function SuperSort.SortEOS : Boolean;
    { Returns True if all records are returned }
Begin
SortEOS:= (SortRecord.Udix >= SortRecord.N) Or (SortRecord.Error<>0);
End;

Procedure SuperSort.InputSort;
Begin
End;

Procedure SuperSort.OutputSort;
Begin
End;

Function SuperSort.Less;
Begin
Less := False;
End;

End.

