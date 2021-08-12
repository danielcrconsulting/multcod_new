Unit MExtrUnit1;

Interface

Function MultiExtract(PathNomeRel, PathNomeXtg, PathNomeArquivo : PAnsiChar) : Integer; StdCall;

Implementation

Uses
  SysUtils,
  Classes,
  SuTypGer,
  SuBrug,
  Sugeral,
  zlibEx;

Var
  Report133CC,
  Pagina64 : Boolean;
  Embara : Array Of Byte;
  Saida,
  Direct,
  StrTam,
  PaginaAcertada,
  PaginaNormal,
  Versao : AnsiString;
  ArqDfn,
  ArqRel : File;
  ArqPag32 : File Of Integer;
  ArqPag64 : File Of Int64;
  Buffer : Pointer;
  BufferA : ^TgArr20000 Absolute Buffer;
  BufIn : Pointer;
  StringGrid1,
  StringGrid2,
  StringGrid3,
  StringGrid4 : Array[0..100,0..100] Of AnsiString;
  Paginas : Int64;

Function Le(Texto : Boolean; Var ArqTxt : System.Text; Var Linha : AnsiString) : Boolean;
Var
  J : Integer;
Begin

Le := False;
Linha := '';

If Texto Then
  Begin
  Try
    ReadLn(ArqTxt,Linha);
  Except
    Exit;
    End; // Try
  End
Else
  Begin

  If Length(Saida) = 0 Then
    Exit;

  J := Pos(X,Saida);
  If J <> 0 Then
    Begin
    Linha := Copy(Saida,1,J-1);
    Delete(Saida,1,J+4);
    End
  Else
    Exit;

  End;

Le := True;

End;

Function LeDfn(NomDfn : TgStr255) : Boolean;

Var
  Linha : AnsiString;
  I,J,
  Versao : Integer;
  ArqTxt : System.Text;
  Texto : Boolean;

begin
LeDfn := False;
Texto := False;

AssignFile(ArqDfn,NomDfn);
Reset(ArqDfn,1);

  Begin
  SetLength(Linha, 15);
  BlockRead(ArqDfn,Linha[1],15,J);
//  Linha[0] := #15;
  if Linha = 'DFNFILEVERSION2' then
    Begin
    Texto := True;
    CloseFile(ArqDfn);
    AssignFile(ArqTxt,NomDfn);
    Reset(ArqTxt);
    End
  End;

If Not Texto Then
  Begin
  Seek(ArqDfn,0); // Volta ao Início do Arquivo
  Texto := False;
  SetLength(Embara,FileSize(ArqDfn)+1);
  SetLength(Saida,FileSize(ArqDfn)+1);

  For I := 1 to FileSize(ArqDfn) do
    BlockRead(ArqDfn,Embara[I],SizeOf(Embara[I]),J);

  CloseFile(ArqDfn);
  For I := 1 to Length(Embara) do
    Saida[I] := AnsiChar(Embara[I]-1000);

  SetLength(Embara,0);
  End;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;
if Linha = 'DFNFILEVERSION2' then
  Begin
  Versao := 2;
  If Not Le(Texto, ArqTxt, Linha) Then
    Exit;
  End
else
  Versao := 1;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;
//EditNomeInt.Text := Linha;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;
//EditIDCol.Text := Linha;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;
//EditIDLin.Text := Linha;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;
//EditIDStr.Text := Linha;

if Versao = 2 then
  Begin
  If Not Le(Texto, ArqTxt, Linha) Then
    Exit;
//  EditIDCol2.Text := Linha;

  If Not Le(Texto, ArqTxt, Linha) Then
    Exit;
//  EditIDLin2.Text := Linha;

  If Not Le(Texto, ArqTxt, Linha) Then
    Exit;
//  EditIDStr2.Text := Linha;
  End;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;
//EditIn.Text := Linha;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;
//EditOut.Text := Linha;

If Not Le(Texto, ArqTxt, Linha) Then
  Exit;

If Linha[1] = '1' Then
  Report133CC := True
Else
  Report133CC := False;

If Texto then
  CloseFile(ArqTxt);
LeDfn := True;
End;

Function Open(Const Filename: String) : Boolean;
Var
  OldFileMode : Byte;
  I : Integer;
  TemRegGrp : Boolean;
Begin
Open := False;

GetDir(0,Direct);

FileMode := 0;
AssignFile(ArqRel, FileName);
Try
  Reset(ArqRel,1);
Except
  Exit;
  End; // Try

If (Filesize(ArqRel) = 0) Then
  Begin
  CloseFile(ArqRel);
  Exit;
  End;

Pagina64 := False;

If FileExists(ChangeFileExt(FileName,'.IAP')) Then
  Begin
  AssignFile(ArqPag32,ChangeFileExt(FileName,'.IAP'));
  {$i-}
  Reset(ArqPag32);
  {$i+}
  If (IoResult <> 0) Or (FileSize(ArqPag32)=0) Then
    Exit;
  Paginas := FileSize(ArqPag32); { número total de páginas Do relatório }
  End;

If FileExists(ChangeFileExt(FileName,'.IAPS')) Then
  Begin
  AssignFile(ArqPag64,ChangeFileExt(FileName,'.IAPS'));
  {$i-}
  Reset(ArqPag64);
  {$i+}
  If (IoResult <> 0) Or (FileSize(ArqPag64)=0) Then
    Exit;
  Paginas := FileSize(ArqPag64);
  Pagina64 := True;
  End;

If FileExists(ChangeFileExt(FileName,'.IAPX')) Then
  Begin
  AssignFile(ArqPag64,ChangeFileExt(FileName,'.IAPX'));
  {$i-}
  Reset(ArqPag64);
  {$i+}
  If (IoResult <> 0) Or (FileSize(ArqPag64)=0) Then
    Exit;
  Paginas := FileSize(ArqPag64);
  Pagina64 := True;
  End;

If FileExists(ChangeFileExt(FileName,'.IAPX')) Then   // Carrega os dados pela memória
  Begin
  AssignFile(ArqCNFG,ExtractFilePath(FileName)+SeArquivoSemExt(FileName)+'Dfn.Dfn');
  OldFileMode := FileMode;
  FileMode := 0;
  Reset(ArqCNFG);
  FileMode := OldFileMode;
  Read(ArqCNFG,RegDestinoII); // Lê o primeiro Destino, mas não checa a segurança por ele
  I := 0;
  FillChar(ArrRegIndice,SizeOf(ArrRegIndice),0);
  TemRegGrp := False;
  While Not Eof(ArqCNFG) Do
    Begin
    Read(ArqCNFG,RegDestinoII);
    Case RegDestinoII.TipoReg Of
      0 : Begin
          RegGrp := RegDestinoII;
          TemRegGrp := True;
          End;
      1 : RegDFN := RegDestinoII;
      2 : Begin
          ArrRegIndice[I] := RegDestinoII;
          Inc(I);
          End;
      3 : RegDestino := RegDestinoII;
      End; // Case
    End;

  If Not TemRegGrp Then  // Força que reggrp tenha sempre algum conteúdo
    RegGrp.Grp := RegDFN.CodGrupo;

  CloseFile(ArqCNFG);

  Report133CC := (RegDFN.TipoQuebra = 1);
  End
Else
If FileExists(ChangeFileExt(FileName,'.IAPS')) Then   // Carrega os dados pela tabela
  Begin
//  FormGeral.DbTableDfn.Close;
//  FormGeral.DbTableDfn.DatabaseName := '';
//  FormGeral.DbTableDfn.TableName := ExtractFilePath(FileName)+SeArquivoSemExt(FileName)+'Dfn.db';
//  FormGeral.DbTableDfn.Open;
//  Report133CC := (FormGeral.DbTableDfn.FieldByName('TipoQuebra').AsString = '1');
//  FormGeral.DbTableDfn.Close;
  End
Else
  Begin
  If Not LeDfn(ChangeFileExt(FileName,'.DFN')) Then
    Exit;
  If Not LeDfn(ChangeFileExt(FileName,'.DFN')) Then     // Le duas vezes para garantir...
    Exit;
  End;

FileMode := 2;
Open := True;
End;

//Procedure GetPaginaDoRel(Pagina : Integer; Var PaginaNormal, PaginaAcertada : String);
Procedure GetPaginaDoRel(Pagina : Integer);
Var
  J,
  Erro,
  Ind,
  Inicio32,
  Fim32 : Integer;
  Inicio64,
  Fim64 : Int64;
  Apendix : AnsiString;
  ComandoDeCarro,
  Teste : AnsiChar;
Begin
If Pagina64 Then
  Begin
  Seek(ArqPag64,Pagina-1);
  Read(ArqPag64,Inicio64);
  {$i-}
  Read(ArqPag64,Fim64);
  {$i+}
  If IoResult <> 0 Then
    Fim64 := FileSize(ArqRel);
  End
Else
  Begin
  Seek(ArqPag32,Pagina-1); // Usa Inicio32 apenas para o I/O
  Read(ArqPag32,Inicio32);
  Inicio64 := Inicio32;
  {$i-}
  Read(ArqPag32,Fim32);
  {$i+}
  If IoResult <> 0 Then
    Fim64 := FileSize(ArqRel)
  Else
    Fim64 := Fim32;
  End;

If Pagina64 Then
  Seek(ArqRel,Inicio64+1) // Must consider the offset
Else
  Seek(ArqRel,Inicio64);

ReallocMem(BufIn,Fim64-Inicio64); { Allocates only the space needed }

BlockRead(ArqRel,BufIn^,Fim64-Inicio64,Erro); { Read only the buffer To decompress }

ReallocMem(Buffer, 0); { DeAllocates }
//DecompressBuf(BufIn, Fim64-Inicio64, 0, Buffer, J);
ZDecompress(BufIn, Fim64-Inicio64, Buffer, J, 0);

PaginaAcertada := '';
PaginaNormal := '';

If Report133CC Then
  Begin
  Apendix := '';
  For Ind := 1 To J Do
    If (Byte(BufferA^[Ind]) And $80) = $80 Then
      Begin
      If Byte(BufferA^[Ind]) = $80 Then
        Teste := #$0
      Else
        Teste := #$80;
      Repeat
        PaginaAcertada := PaginaAcertada + ' ';
        PaginaNormal := PaginaNormal + ' ';      // Backup;
        Dec(BufferA^[Ind]);
      Until BufferA^[Ind] = Teste;
      End
    Else
      Begin
      If Ind = 1 Then
        BufferA^[Ind] := ' '
      Else
      If BufferA^[Ind-1] = #10 Then
        Begin
        PaginaAcertada := PaginaAcertada + Apendix;                    // Se colocou uma linha After
        Apendix := '';
        ComandoDeCarro := BufferA^[Ind];
        BufferA^[Ind] := ' ';
        If ComandoDeCarro = '0' Then
          PaginaAcertada := PaginaAcertada + CrLf
        Else
          If ComandoDeCarro = '-' Then
            Apendix := CrLf;
        End;
      If BufferA^[Ind] <> #0 Then
        Begin
        PaginaAcertada := PaginaAcertada + BufferA^[Ind];
        PaginaNormal := PaginaNormal + BufferA^[Ind];   // Backup sem comando de carro
        End;
      End;
  End
Else
  Begin
  For Ind := 1 To J Do
    If (Byte(BufferA^[Ind]) And $80) = $80 Then
      Begin
      If Byte(BufferA^[Ind]) = $80 Then
        Teste := #$0
      Else
        Teste := #$80;
      Repeat
        PaginaAcertada := PaginaAcertada + ' ';
        Dec(BufferA^[Ind]);
      Until BufferA^[Ind] = Teste;
      End
    Else
      If BufferA^[Ind] <> #0 Then
        PaginaAcertada := PaginaAcertada + BufferA^[Ind];
  End;
End;

Function MultiExtract(PathNomeRel, PathNomeXtg, PathNomeArquivo : PAnsiChar) : Integer; StdCall;

Var
  Dia, Mes, Ano : Word;
  I1,
  I2,
  NCol,
  Cln,
  Lin,
  Tam,
  I, J,
  IChrInc,
  IStrInc,
  IChrExc,
  IStrExc,
  IStrInCampo,
  IStrTroca,
  LinIni,
  LinFin,
  LinFinal,
  PgIni,
  PgFin,
  PosSep : Integer;
  ArqTxt : System.Text;
//  PagNormal,
//  PagAcertada,
  Linha,
  LinhaAux,
  Apendix,
  Edit1,
  Edit2,
  Edit3,
  Edit4,
  Edit5,
  Edit6 : AnsiString;
  CheckBox1,
  CheckBox2,
  CheckBox3 : Boolean;
  ValCampos : Array[1..99] Of AnsiString;
  ValMemoria : Array[1..99] Of AnsiString;
  Filtro : TFiltro;
  ChrIncFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : SetOfChar;
                              End;
  StrIncFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : TgStrStr;
                              End;
  ChrExcFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : SetOfChar;
                              End;
  StrExcFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : TgStrStr;
                              End;
  StrInCampo : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : TgStrStr;
                              End;
  StrTroca  : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : TgStrStr;
                              End;
  StrPagina : TStringList;

  ArqXtg : System.Text;

Procedure TrabalhaADescompactacao(I : Integer);

Var
  ILinha : Integer;

  Function TestaFiltro(I : Integer) : Boolean;
  Var
    J, K: Integer;
    Preserva,
    Testou : Boolean;
  Begin
  For J := 1 To 99 Do
    With ChrIncFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          For K := 1 To Length(ValCampos[I]) Do
            If Not (ValCampos[I][K] In Filtro) Then
              Begin
              ValCampos[I] := '';
              Break;
              End;
          Break; // Parar assim que realizar a primeira checagem
          End;

  Preserva := False;
  Testou := False;
  For J := 1 To 99 Do
    With StrIncFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          Testou := True;
          If ValCampos[I] <> '' Then
            With Filtro Do
              If Col <> 0 Then
                If Copy(StrPagina[Lin],Col,Tam) <> FilStr Then      // Simulando um OR
                  Begin
//                    ValCampos[I] := '';    { Conteudo difere da linha a ser incluida }
                  End
                Else
                  Preserva := True;
//            Break; // Parar assim que realizar a primeira checagem
          End;
          
  If Testou Then
    If Not Preserva Then  // Algum campo salvou o conteúdo ............
        ValCampos[I] := '';    { Conteudo difere da linha a ser incluida }

  For J := 1 To 99 Do
    With ChrExcFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          For K := 1 To Length(ValCampos[I]) Do
            If (ValCampos[I][K] In Filtro) Then
              Begin
              ValCampos[I] := '';
              Break;
              End;
//            Break; // Parar assim que realizar a primeira checagem
          End;

  For J := 1 To 99 Do
    With StrExcFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          If ValCampos[I] <> '' Then
            With Filtro Do
              If Col <> 0 Then
                If Copy(StrPagina[Lin],Col,Tam) = FilStr Then
                  ValCampos[I] := '';    { Conteúdo igual a linha a ser excluida }
//            Break; // Parar assim que realizar a primeira checagem
          End;

  For J := 1 To 99 Do
    With StrInCampo[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          If ValCampos[I] <> '' Then
            With Filtro Do
              If Col <> 0 Then
//                ValCampos[I].Insert(Col-1, FilStr);
                ValCampos[I] := Copy(ValCampos[I],1, Col-1) + FilStr + Copy(ValCampos[I], Col+Length(FilStr),
                                           Length(ValCampos[I]) - (Col+Length(FilStr)+1));
          End;

  If ValCampos[I] = '' Then
    Result := False
  Else
    Result := True;
  End;

  Procedure RodaScript;
  Var
    I,
    Ky,
    Posic : Integer;
    Day,
    Month,
    Year : Word;
    Ori,
    RegAux,
    AuxStr,
    TamSaida : String;
    AuxData : TDateTime;
    y : TFormatSettings;

    Function FormataCX(ParEntra : AnsiString) : AnsiString;
    Var
      Ix : Integer;
    Begin
    Result := ParEntra;
    StringGrid3[9,I] := UpperCase(StringGrid3[9,I]);
    RegAux := StringGrid3[9,I];
    If RegAux = '' Then
      Exit;
    If (Pos('C',RegAux) = 0) And (Pos('X',RegAux) = 0) Then
      Exit;
    Result := '';
    For Ix := 1 To Length(RegAux) Do
      Begin
      If Ix > Length(ParEntra) Then
        Break;
      If RegAux[Ix] = 'C' Then
        Result := Result + ParEntra[Ix];
      End;
    End;

    Procedure AndaNoFormatoAndObtemUmNumero;
    Var
      cmpAux : AnsiString;
    Begin
    If Ky > Length(StringGrid3[9,I]) Then
      Exit;
    Ori := StringGrid3[9,I][Ky];
    RegAux := '';
    While (Length(StringGrid3[9,I]) >= Ky) And (StringGrid3[9,I][Ky] = Ori) Do
      Begin
      RegAux := RegAux + ValCampos[I][Ky];
      Inc(Ky);
      End;
    Case Ori[1] Of
      'D' : Day := StrToInt(RegAux);
//      'M' : Month := StrToInt(RegAux);
      'M' : if RegAux.Length = 3 then
              begin
              cmpAux := RegAux.ToUpper;
              if cmpAux = 'JAN' then Month := 1
              else
              if (cmpAux = 'FEV') or
                 (cmpAux = 'FEB') then Month := 2
              else
              if cmpAux = 'MAR' then Month := 3
              else
              if (cmpAux = 'ABR') or
                 (cmpAux = 'APR') then Month := 4
              else
              if (cmpAux = 'MAI') or
                 (cmpAux = 'MAY') then Month := 5
              else
              if cmpAux = 'JUN' then Month := 6
              else
              if cmpAux = 'JUL' then Month := 7
              else
              if (cmpAux = 'AGO') or
                 (cmpAux = 'AUG') then Month := 8
              else
              if (cmpAux = 'SET') or
                 (cmpAux = 'SEP') then Month := 9
              else
              if (cmpAux = 'OUT') or
                 (cmpAux = 'OCT') then Month := 10
              else
              if cmpAux = 'NOV' then Month := 11
              else
              if (cmpAux = 'DEZ') or
                 (cmpAux = 'DEC') then Month := 12
              else
                Month := StrToInt(RegAux);
              end
            else
              Month := StrToInt(RegAux);
      'Y' : Begin
            Year := StrToInt(RegAux);
            If Length(RegAux) = 2 Then
              If Year <= 50 Then
                Year := Year + 2000
              Else
                Year := Year + 1900;
            End;
      End; // Case
    If Ky < Length(StringGrid3[9,I]) Then
      If Not (StringGrid3[9,I][Ky] In ['D','M','Y']) Then
        Inc(Ky);   // Pula o separador
    End;

    Function FormataData : AnsiString;
    Begin
    Result := ValCampos[I];
    If Not ((StringGrid3[9,I] <> '') And (StringGrid3[10,I] <> '') And (ValCampos[I] <> '')) Then // Não há formatação especificada ou o campo está vazio...
      Exit;

    Result := '';
    RegAux := StringGrid3[9,I];
    While Pos('A',RegAux) <> 0 Do
      RegAux[Pos('A',RegAux)] := 'Y';
    While Pos('a',RegAux) <> 0 Do
      RegAux[Pos('a',RegAux)] := 'Y';
    StringGrid3[9,I] := RegAux;

    RegAux := StringGrid3[10,I];
    While Pos('A',RegAux) <> 0 Do
      RegAux[Pos('A',RegAux)] := 'Y';
    While Pos('a',RegAux) <> 0 Do
      RegAux[Pos('a',RegAux)] := 'Y';
    StringGrid3[10,I] := RegAux;

    Day := 0;
    Month := 0;
    Year := 0;

    Ky := 1;

    AndaNoFormatoAndObtemUmNumero;
    AndaNoFormatoAndObtemUmNumero;
    AndaNoFormatoAndObtemUmNumero;

    Try
      AuxData := EncodeDate(Year,Month,Day);
      Result := FormatDateTime(StringGrid3[10,I],AuxData);
    Except
//      ShowMessage('Erro na conversão da data...');
      End;
    End;

  Begin

//    FillChar(ValCampos,SizeOf(ValCampos),0); Fode tudo!

  Linha := '';
  For I := 1 to 99 Do
    If StringGrid3[1,I] <> '' Then
      Begin
      Cln := StrToInt(StringGrid3[2,I]);
      If StringGrid3[3,I][1] = '*' Then
        Lin := ILinha-1+StrToInt(StringGrid3[5,I]) // Soma o relativo para pegar a linha certa
      Else
        Lin := StrToInt(StringGrid3[3,I])-1+StrToInt(StringGrid3[5,I]);
      Tam := StrToInt(StringGrid3[4,I]);

      ValCampos[I] := '';
      If Lin < StrPagina.Count Then
        ValCampos[I] := Copy(StrPagina[Lin],Cln,Tam);

      If StringGrid3[9,I] <> '' Then
        ValCampos[I] := FormataCX(Copy(StrPagina[Lin],Cln,Tam));

      Case StringGrid3[6,I][1] Of    { Tratamento de Brancos }
        '0' : ValCampos[I] := SeTiraBranco(ValCampos[I]);
        '1' : ValCampos[I] := TrimRight(ValCampos[I]);
        '2' : ValCampos[I] := TrimLeft(ValCampos[I]);
        '3' : Begin
              End; // Sem Tratamento de Brancos
        '4' : ValCampos[I] := Trim(ValCampos[I]);
        End; // Else

      TestaFiltro(I);

      If (StringGrid3[7,I] = 'C') Then  // Campo de carga, guarda na memória
        if ValCampos[I] <> '' then
          ValMemoria[I] := ValCampos[I]
        else                                  // ou carrega da memória
          ValCampos[I] := ValMemoria[I];

      If (StringGrid3[7,I] = 'S') And (ValCampos[I] = '') Then  // Campo obrigatório está vazio, aborta
          Exit;

      If (StringGrid3[9,I] <> '') And ((StringGrid3[10,I] <> '')) Then
        ValCampos[I] := FormataData;

      If Length(StringGrid3[9,I]) = 0 Then
        If Length(StringGrid3[10,I]) = 1 Then
          Begin
          y.DecimalSeparator := '.';
          If StringGrid3[8,I] = 'F' Then
            Begin
            RegAux := '';
            For Ky := 1 To Length(ValCampos[I]) Do
              If (ValCampos[I][Ky] In ['0'..'9','+','-',',']) Then
                RegAux := RegAux + ValCampos[I][Ky];

            Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
            If Posic = 0 Then
              Posic := Pos('-',RegAux);

            If Posic <> 0 Then
              Begin
              AuxStr := RegAux[Posic];
              Delete(RegAux,Posic,1);
              RegAux := AuxStr + RegAux;
              End;

            ValCampos[I] := RegAux;

            If Pos(',',ValCampos[I]) <> 0 Then
              ValCampos[I][Pos(',',ValCampos[I])] := '.';

            End
          Else
          If StringGrid3[8,I] = 'D' Then
            Begin
            RegAux := '';
            For Ky := 1 To Length(ValCampos[I]) Do
              If (ValCampos[I][Ky] In ['0'..'9','+','-','.']) Then
                RegAux := RegAux + ValCampos[I][Ky];
            Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
            If Posic = 0 Then
              Posic := Pos('-',RegAux);

            If Posic <> 0 Then
              Begin
              AuxStr := RegAux[Posic];
              Delete(RegAux,Posic,1);
              RegAux := AuxStr + RegAux;
              End;

            ValCampos[I] := RegAux;
            End
          Else
          If StringGrid3[8,I] = 'N' Then
            Begin
            RegAux := '';
            For Ky := 1 To Length(ValCampos[I]) Do
              If (ValCampos[I][Ky] In ['0'..'9','+','-']) Then
                RegAux := RegAux + ValCampos[I][Ky];
            Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
            If Posic = 0 Then
              Posic := Pos('-',RegAux);

            If Posic <> 0 Then
              Begin
              AuxStr := RegAux[Posic];
              Delete(RegAux,Posic,1);
              RegAux := AuxStr + RegAux;
              End;

            ValCampos[I] := RegAux;
            End;

          If StringGrid3[10,I] = 'F' Then    // Formata a Saida como desejado...
            If Pos('.',ValCampos[I]) <> 0 Then
              ValCampos[I][Pos('.',ValCampos[I])] := ',';

          If (ValCampos[I] <> '') And (ValCampos[I][1] In ['+','-']) Then
            Ky := 2
          Else
            Ky := 1;

          While Length(ValCampos[I]) < StrToInt(StringGrid3[4,I]) Do    // Preenche com zeros à esquerda
            Insert('0',ValCampos[I],Ky);

          End;

      TamSaida :=  StringGrid3[4,I];
      if Length(Edit6) <> 0 then
        TamSaida := IntToStr(Length(ValCampos[I]));
                                                                    // Separador de campos...
      Linha := Linha + Format('%-'+TamSaida+'s',[ValCampos[I]]) + Edit6;
      End
    Else
      Break;

  LinhaAux := Linha;                       //Safe copy
  PosSep := Pos(Edit6, LinhaAux);
  While (Length(LinhaAux) <> 0) and (PosSep <> 0) do
    Begin
    Delete(LinhaAux, PosSep, Length(Edit6));
    PosSep := Pos(Edit6, LinhaAux);
    End;
  LinhaAux := Trim(LinhaAux);
  if LinhaAux <> '' then   // Romero em 28/03/2013
    WriteLn(ArqTxt,Linha);

//  WriteLn(ArqTxt,Linha);
  End;

Begin

GetPaginaDoRel(I);

StrPagina.Text := PaginaAcertada;
                                                   
If LinFin <= (StrPagina.Count) Then
  LinFinal := LinFin
Else
  LinFinal := StrPagina.Count;

For ILinha := LinIni To LinFinal Do
  RodaScript;

End;

Begin

DecodeDate(Now, Ano, Mes, Dia);
if Ano >= 2015 then
  Exit;

Result := 0;
StrPagina := TStringList.Create;

// Abrir o relatório

If Not Open(PathNomeRel) Then
  Begin
  Result := 1;
  Exit;
  End;

// Ler o Xtg

AssignFile(ArqXtg,PathNomeXtg);
Reset(ArqXtg);
ReadLn(ArqXtg,Linha);
Versao := Linha;
//If (Versao = 'XTRFILEV2') Or (Versao = 'XTRFILEV3') Then
If (Versao = 'XTRFILEV2') Or (Versao = 'XTRFILEV3') or (Versao = 'XTRFILEV4') Then
  Begin
  ReadLn(ArqXtg,Linha);
  NCol := 10;
  End
Else
  NCol := 7;

Edit5 := Linha;
ReadLn(ArqXtg,Linha);

//If Versao = 'XTRFILEV3' Then
If (Versao = 'XTRFILEV3') or (Versao = 'XTRFILEV4') Then
  Begin
  If UpperCase(Linha) = 'S' Then
    CheckBox1 := True
  Else
    CheckBox1 := False;
  ReadLn(ArqXtg,Linha);
  If UpperCase(Linha) = 'S' Then
    CheckBox2 := True
  Else
    CheckBox2 := False;
  ReadLn(ArqXtg,Linha);
  Edit6 := Linha;
  ReadLn(ArqXtg,Linha);
  End
Else
  Begin
  CheckBox1 := True;
  CheckBox2 := False;
  Edit6 := '';
  End;

Edit1 := Linha;
ReadLn(ArqXtg,Linha);
Edit2 := Linha;
ReadLn(ArqXtg,Linha);
Edit3 := Linha;
ReadLn(ArqXtg,Linha);
Edit4 := Linha;

if (Versao = 'XTRFILEV4') then
  begin
  ReadLn(ArqXtg, Linha);
  if upperCase(Linha) = 'S' then
    CheckBox3 := true;
  end;

For I := 1 To 99 Do
  Begin
  For J := 0 To 1 Do
    Begin
    ReadLn(ArqXtg,Linha);
    StringGrid1[J,I] := Linha;
    End;
  For J := 0 To 2 Do
    Begin
    ReadLn(ArqXtg,Linha);
    StringGrid2[J,I] := Linha;
    End;
  For J := 1 To NCol Do
    Begin
    ReadLn(ArqXtg,Linha);
    StringGrid3[J,I] := Linha;
    End;
  For J := 1 To 3 Do
    Begin
    ReadLn(ArqXtg,Linha);
    StringGrid4[J,I] := Linha;
    End;
  End;
CloseFile(ArqXtg);

PgIni := StrToInt(Edit1);
If Copy(Edit2,1,1) = '*' Then
  PgFin := Paginas
Else
  PgFin := StrToInt(Edit2);

LinIni := StrToInt(Edit3);
If Copy(Edit4,1,1) = '*' Then
  LinFin := 99999
Else
  LinFin := StrToInt(Edit4);

Filtro := TFiltro.Create;
FillChar(ChrIncFil,SizeOf(ChrIncFil),0);
FillChar(StrIncFil,SizeOf(StrIncFil),0);
FillChar(ChrExcFil,SizeOf(ChrExcFil),0);
FillChar(StrExcFil,SizeOf(StrExcFil),0);
FillChar(StrTroca,SizeOf(StrTroca),0);
FillChar(StrInCampo,SizeOf(StrInCampo),0);
IChrInc := 1;
IStrInc := 1;
IChrExc := 1;
IStrExc := 1;
IStrInCampo := 1;
IStrTroca := 1;

For I := 1 To 99 Do
  If StringGrid4[1,I] = '' Then
    Break
  Else
    Begin
    For J := 1 To 99 Do
      If StringGrid3[1,J] = '' Then
        Break
      Else
        If StringGrid3[1,J] = StringGrid4[1,I] Then  // Achou o campo
          If StringGrid4[2,I] = 'CHARINC' Then
            Begin
            ChrIncFil[IChrInc].ICampo := J;
            Filtro.EncheFiltro(StringGrid4[3,I],StringGrid4[1,I],ChrIncFil[IChrInc].Filtro,J);
            Inc(IChrInc);
            Break;
            End
          Else
          If StringGrid4[2,I] = 'STRINC' Then
            Begin
            StrIncFil[IStrInc].ICampo := J;
            Filtro.EncheStr(StringGrid4[3,I],StringGrid4[1,I],StrIncFil[IStrInc].Filtro,J);
            Inc(IStrInc);
            Break;
            End
          Else
          If StringGrid4[2,I] = 'CHAREXC' Then
            Begin
            ChrExcFil[IChrExc].ICampo := J;
            Filtro.EncheFiltro(StringGrid4[3,I],StringGrid4[1,I],ChrExcFil[IChrExc].Filtro,J);
            Inc(IChrExc);
            Break;
            End
          Else
          If StringGrid4[2,I] = 'STREXC' Then
            Begin
            StrExcFil[IStrExc].ICampo := J;
            Filtro.EncheStr(StringGrid4[3,I],StringGrid4[1,I],StrExcFil[IStrExc].Filtro,J);
            Inc(IStrExc);
            Break;
            End
          Else
          If StringGrid4[2,I] = 'STRTROCA' Then
            Begin
            StrTroca[IStrTroca].ICampo := J;
            Filtro.EncheStr(StringGrid4[3,I],StringGrid4[1,I],StrTroca[IStrTroca].Filtro,J);
            Inc(IStrTroca);
            Break;
            End
          Else
          If StringGrid4[2,I] = 'STRINCAMPO' Then
            Begin
            StrInCampo[IStrInCampo].ICampo := J;
            Filtro.EncheStr(StringGrid4[3,I],StringGrid4[1,I],StrInCampo[IStrInCampo].Filtro,J);
            Inc(IStrInCampo);
            Break;
            End;
    End;

Filtro.Free;

// Criar o arquivo de destino
AssignFile(ArqTxt,PathNomeArquivo);
ReWrite(ArqTxt);

Apendix := '';               // Obtem e grava o nome dos campos no primeiro registro do arquivo
For I := 1 To 99 Do
  If StringGrid3[1,I] <> '' Then
    Begin
    StrTam := StringGrid3[4,I];
    If Length(StringGrid3[10,I]) <> 0 Then
      If Length(StringGrid3[10,I]) <> 1 Then
        If Length(StringGrid3[10,I]) > Length(StringGrid3[9,I]) Then
          If Length(StringGrid3[10,I]) > StrToInt(StringGrid3[4,I]) Then
            If Length(StringGrid3[10,I]) > StrToInt(StrTam) Then // Se a reformatação é maior, dá mais espaço...
              StrTam := IntToStr(Length(StringGrid3[10,I]));
    If CheckBox2 Then                             // Incluir o tamanho do separador...
//      StrTam := IntToStr(StrToInt(StrTam) + Length(Edit6));                    // -----------------> Agora vamos incluir o separador de campos no cabeçalho
      Apendix := Apendix + StringGrid3[1,I] + Edit6
    else
      begin
      Edit6 := '';   // Safe procedure if CheckBox2 is false;
      Apendix := Apendix + Format('%-'+StrTam+'s',[Copy(StringGrid3[1,I],1,StrToInt(StringGrid3[4,I]))]);
      end;
    End
  Else
    Break;

If CheckBox1 Then     // Soltar linha de cabeçalho
  WriteLn(ArqTxt,Apendix);

{Apendix := '';               // Obtem e grava o nome dos campos no primeiro registro do arquivo
For I := 1 To 99 Do
  If StringGrid3[1,I] <> '' Then
    Begin                                                              // Trunca o nome
    Apendix := Apendix + Format('%-'+StringGrid3[4,I]+'s',[Copy(StringGrid3[1,I],1,StrToInt(StringGrid3[4,I]))]);
    End
  Else
    Break;

WriteLn(ArqTxt,Apendix);}

For I := PgIni To PgFin Do
  TrabalhaADescompactacao(I);

CloseFile(ArqTxt);

CloseFile(ArqRel);

Try
  CloseFile(ArqPag64);
Except
  end;

Try
  CloseFile(ArqPag32);
Except
  end;

StrPagina.Free;
ReallocMem(BufIn,0); { DeAllocates }
ReallocMem(Buffer,0); { DeAllocates }
For I1 := 0 To 100 Do
  For I2 := 0 To 100 Do
    Begin
    StringGrid1[I1,I2] := '';
    StringGrid2[I1,I2] := '';
    StringGrid3[I1,I2] := '';
    StringGrid4[I1,I2] := '';
    End;
Direct := '';
End;

End.
