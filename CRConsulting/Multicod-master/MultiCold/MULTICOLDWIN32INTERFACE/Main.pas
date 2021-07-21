Unit Main;

{  If (Report133CC) And (Not Orig) Then
    Begin
    Apendix := '';
    PaginaAcertada[1] := ' ';         // '&nbsp;'
    I := 2;
    For Ind := 2 To Length(PaginaOriginal) Do
      If (PaginaOriginal[Ind-1] = #10) And (Not (PaginaOriginal[Ind] in [#13,'x'])) Then // É Comando de carro, vai tratar...
        Begin
        If Apendix <> '' Then
          Begin
          PaginaAcertada[I] := #13;
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          PaginaAcertada[I] := #10;
          Inc(I);                 // := PaginaAcertada + Apendix; // Se colocou uma linha After
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End;
        Apendix := '';
        ComandoDeCarro := PaginaOriginal[Ind];
        If ComandoDeCarro = '0' Then
          Begin
          PaginaAcertada[I] := #13;
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          PaginaAcertada[I] := #10;
          Inc(I);                 // Uma Linha Before
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End
        Else
          If ComandoDeCarro = '-' Then
            Apendix := CrLf;
        PaginaAcertada[I] := ' ';
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End
      Else
        Begin
        PaginaAcertada[I] := PaginaOriginal[Ind];
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End; }

{
  DefChave[1,I] := IntToStr(ArrRegIndice[I].LinhaI);
  DefChave[2,I] := IntToStr(ArrRegIndice[I].LinhaF);
  DefChave[3,I] := IntToStr(ArrRegIndice[I].Coluna);
  DefChave[4,I] := IntToStr(ArrRegIndice[I].Tamanho);
  DefChave[5,I] := ArrRegIndice[I].Branco;
  DefChave[6,I] := ArrRegIndice[I].NomeCampo;
  DefChave[7,I] := ArrRegIndice[I].TipoCampo;
  DefChave[8,I] := ArrRegIndice[I].CharInc;
  DefChave[9,I] := ArrRegIndice[I].CharExc;
  DefChave[10,I] := ArrRegIndice[I].StrInc;
  DefChave[11,I] := ArrRegIndice[I].StrExc;
}

//OleCheck(CoInitializeEx(nil, 2));
//CoUninitialize;
//  Check(DbiInit(nil));
//  Session1.Active := True;
//  Session1.Active := False;
//  Check(DbiExit);

//With DataModule2 Do
//  Begin

//  Database1.Open;

//  QueryPaginaRel.Params[0].AsInteger := NumeroDaPaginaOuPesquisa;
//  QueryPaginaRel.Params[1].AsInteger := TotalDePaginas;
//  QueryPaginaRel.Params[2].asString := MensagemErroSisOp;
//  QueryPaginaRel.Params[3].asString := MensagemErroMultiCold;
//  QueryPaginaRel.Params[4].AsMemo := StringReplace(StringReplace(PaginaOriginal,' ','&nbsp;',[rfReplaceAll, rfIgnoreCase]),
//                             #13#10,'<br>',[rfReplaceAll, rfIgnoreCase]);
//  QueryPaginaRel.Params[5].AsMemo := StringReplace(
//                                     StringReplace(PaginaAcertada,' ','&nbsp;',[rfReplaceAll, rfIgnoreCase]),
//                                                   #13#10,'<br>',[rfReplaceAll, rfIgnoreCase]);

//  QueryPaginaRel.ExecSQL;

//  Query1.SQL.Clear;
//  Query1.SQL.Add('SELECT @@IDENTITY');
//  Query1.Open;
//  Result := Query1.Fields[0].AsInteger;
//  Query1.Close;

//  DataBase1.Close;

//  Free;
//  End;


Interface

Uses
  ComObj, DB, ADODB, Classes, SysUtils, SuTypMultiCold, ZLibEx, SuTypGer, ExtCtrls,
  DBXpress, FMTBcd, SqlExpr, DBTables, Subrug, BDE;

Type
  TDataModule1 = Class(TDataModule)
    Query1: TQuery;
    Database1: TDatabase;
    Session1: TSession;
    QueryPaginaRel: TQuery;
    QueryCampos: TQuery;
    QueryUpdateConsulta: TQuery;
    QueryDbf: TQuery;
    procedure Session1Startup(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure Database1Login(Database: TDatabase; LoginParams: TStrings);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

  Function ListaPagina(NomeDoRelatorio, NomeDoArquivo : PChar;
                       NumeroDaPaginaOuPesquisa,
                       CodConsulta : Integer) : Integer; StdCall;

  Function ListaCampos(CodUsuario, NomeDoRelatorio : PChar) : Integer; StdCall;

  Function GeraQueryFacil(CodConsulta : Integer;
                          Var
                            NumeroDePaginas,
                            Primeira,
                            Proxima,
                            Ultima : Integer) : Integer; StdCall;

Implementation

uses AuxFormUnit;

{$R *.dfm}

Var
  LogInInfoLocal : Array[1..2] Of String;

Procedure Log(Const Mensagem, NomeArquivo : String);
Var
  Arq : System.Text;
Begin
AssignFile(Arq, NomeArquivo);
ReWrite(Arq);
WriteLn(Arq,Mensagem);
CloseFile(Arq);
End;

Procedure AbreRelatorio(NomeDoRelatorio : String;
                        Var
                          MensagemErroMultiCold,
                          MensagemErroSisOp : String;
                        Var
                          ArqRel : TFileStream;
                        Var
                          ArqPag64 : FileOfInt64;
                        Var
                          ArqCNFG : FileOfTgRegDFN;
                        Var
                          RegDestino,
                          RegDestinoII,
                          RegGrp,
                          RegDFN,
                          RegSistema : TgRegDFN;
                        Var
                          ArrRegIndice : Array0_199OfTgRegDFN;
                        Var
                          TemRegGrp,
                          Report133CC,
                          ComprimeBrancos : Boolean;
                        Var
                          DefChave: Array1_11_1_99OfString);
Var
  I : Integer;
Begin
If Not FileExists(ChangeFileExt(NomeDoRelatorio,'.IAPX')) Then
  Begin
  MensagemErroMultiCold := 'Relatório não pode ser aberto, versão incompatível ';
  Exit;
  End;

Try
  ArqRel := TFileStream.Create(NomeDoRelatorio, fmOpenRead Or fmShareDenyNone);
Except
  On E: Exception Do
    Begin
    MensagemErroMultiCold := 'Relatório não pode ser aberto ';
    MensagemErroSisOp := Pchar(E.Message);
    Exit;
    End;
  End; // Try

If ArqRel.Size = 0 Then
  Begin
  ArqRel.Free;
  MensagemErroMultiCold := 'Arquivo Relatório Vazio ';
  Exit;
  End;

AssignFile(ArqPag64,ChangeFileExt(NomeDoRelatorio,'.IAPX'));
Try
  Reset(ArqPag64);
Except
  On E: Exception Do
    Begin
    ArqRel.Free;
    MensagemErroMultiCold := 'Índice de página não pode ser aberto ';
    MensagemErroSisOp := PChar(E.Message);
    Exit;
    End;
  End; // Try

If FileSize(ArqPag64) = 0 Then
  Begin
  ArqRel.Free;
  CloseFile(ArqPag64);
  MensagemErroMultiCold := 'Arquivo Índice de Página Vazio ';
  Exit;
  End;

AssignFile(ArqCNFG,ChangeFileExt(NomeDoRelatorio,'Dfn.Dfn'));
Try
  Reset(ArqCNFG);
Except
  On E: Exception Do
    Begin
    ArqRel.Free;
    CloseFile(ArqPag64);
    MensagemErroMultiCold := 'Arquivo DFN não pode ser aberto ';
    MensagemErroSisOp := Pchar(E.Message);
    Exit;
    End;
  End; // Try

Read(ArqCNFG,RegDestinoII); // Lê o primeiro Destino, mas não checa a segurança por ele
I := 0;
FillChar(ArrRegIndice,SizeOf(ArrRegIndice),0);
TemRegGrp := False;
RegSistema.CODSIS := -1; // Inicializa com valor não provável pois as compilações interbase não geram o registro...
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
    4 : RegSistema := RegDestinoII;
    End; // Case
  End;
CloseFile(ArqCNFG);

If Not TemRegGrp Then  // Força que reggrp tenha sempre algum conteúdo
  RegGrp.Grp := RegDFN.CodGrupo;

Report133CC := (RegDFN.TipoQuebra = 1);
ComprimeBrancos := (RegDFN.COMPRBRANCOS); // Aqui verifica a seleção da flag na DFN
I := 0;
While ArrRegIndice[I].TipoReg <> 0 Do
  Begin
  DefChave[1,I] := IntToStr(ArrRegIndice[I].LinhaI);
  DefChave[2,I] := IntToStr(ArrRegIndice[I].LinhaF);
  DefChave[3,I] := IntToStr(ArrRegIndice[I].Coluna);
  DefChave[4,I] := IntToStr(ArrRegIndice[I].Tamanho);
  DefChave[5,I] := ArrRegIndice[I].Branco;
  DefChave[6,I] := ArrRegIndice[I].NomeCampo;
  DefChave[7,I] := ArrRegIndice[I].TipoCampo;
  DefChave[8,I] := ArrRegIndice[I].CharInc;
  DefChave[9,I] := ArrRegIndice[I].CharExc;
  DefChave[10,I] := ArrRegIndice[I].StrInc;
  DefChave[11,I] := ArrRegIndice[I].StrExc;
  Inc(I);
  End;
End;

Function ListaPagina;
Var
  ArqRel : TFileStream;
  ArqPag64 : FileOfInt64;
  ArqCNFG : FileOfTgRegDFN;
  RegDestino,
  RegDestinoII,
  RegGrp,
  RegDFN,
  RegSistema : TgRegDFN;
  Posic,
  NumeroDaPagina,
  TotalDePaginas,
  QtdBytesPagRel : Integer;
  ArrRegIndice : Array0_199OfTgRegDFN;
  TemRegGrp,
  Report133CC,
  ComprimeBrancos : Boolean;
  DefChave: Array1_11_1_99OfString;
  Inicio64,
  Fim64  : Int64;
  BufI,
  Buffer : Pointer;
  MensagemErroMultiCold,
  MensagemErroSisOp,
  PaginaAcertada,
  PaginaOriginal : String;
  ArqPsq : TgArqPsq;
  RegPsq : TgRegPsq;
  ArrBol : TgArrBol;
  DataModule2 : TDataModule1;
  Log,
  ArqPagina : System.Text;

  Procedure Decripta(Var Buffer : Pointer; Report133CC, Orig : Boolean; QtdBytes : Integer);
  Var
    I, Ind,
    ILinha : Integer;
    BufferA : ^TgArr20000 Absolute Buffer;
    Apendix : String;
    ComandoDeCarro,
    AuxTemp,
    Teste : Char;
    Marcou : Boolean;

    Procedure InsertHtmlCrLf;        // '<br>'
    Begin
    If I+4 > Length(PaginaAcertada) Then
      SetLength(PaginaAcertada,Length(PaginaAcertada) + 10000);
    PaginaAcertada[I] := '<';
    PaginaAcertada[I+1] := 'b';
    PaginaAcertada[I+2] := 'r';
    PaginaAcertada[I+3] := '>';
    Inc(I,4);
    End;

    Procedure InsertHtmlEspace;        // '&nbsp;'
    Begin
    If I+6 > Length(PaginaAcertada) Then
      SetLength(PaginaAcertada,Length(PaginaAcertada) + 10000);
    PaginaAcertada[I] := '&';
    PaginaAcertada[I+1] := 'n';
    PaginaAcertada[I+2] := 'b';
    PaginaAcertada[I+3] := 's';
    PaginaAcertada[I+4] := 'p';
    PaginaAcertada[I+5] := ';';
    Inc(I,6);
    End;

  Begin
  SetLength(PaginaAcertada,10000);
  SetLength(PaginaOriginal,10000);
  I := 1;
  ILinha := 0;
  Marcou := False;

  For Ind := 1 To QtdBytes Do
    If ComprimeBrancos Then
      Begin
      If (Byte(BufferA^[Ind]) And $80) = $80 Then
        Begin
        AuxTemp := BufferA^[Ind];
        If Byte(BufferA^[Ind]) = $80 Then
          Teste := #$0
        Else
          Teste := #$80;
        Repeat
          PaginaOriginal[I] := ' ';
          Inc(I);
          If I > Length(PaginaOriginal) Then
            SetLength(PaginaOriginal,Length(PaginaOriginal)+10000);
          Dec(AuxTemp);
        Until AuxTemp = Teste;
        End
      Else
        Begin
        PaginaOriginal[I] := BufferA^[Ind];
        Inc(I);
        If I > Length(PaginaOriginal) Then
          SetLength(PaginaOriginal,Length(PaginaOriginal)+10000);

        If (PaginaOriginal[I-1] = #13) Then
          If Marcou Then
            Begin
            If (I+7) > Length(PaginaOriginal) Then
              SetLength(PaginaOriginal,Length(PaginaOriginal)+10000);
            PaginaOriginal[I-1] := 'x'; PaginaOriginal[I] := '/'; PaginaOriginal[I+1] := 'f'; PaginaOriginal[I+2] := 'o';
            PaginaOriginal[I+3] := 'n'; PaginaOriginal[I+4] := 't'; PaginaOriginal[I+5] := 'x'; PaginaOriginal[I+6] := #13;
            Inc(I,7);
            Marcou := False;
            End;

        If (PaginaOriginal[I-1] = #10) Then
          Begin
          Inc(Ilinha);
          If ArrBol[Ilinha] Then
            Begin // Pôr a tag de marcação de linha de pesquisa...
            Marcou := True;
            If (I+20) > Length(PaginaOriginal) Then
              SetLength(PaginaOriginal,Length(PaginaOriginal)+10000);
            PaginaOriginal[I] := 'x'; PaginaOriginal[I+1] := 'f'; PaginaOriginal[I+2] := 'o'; PaginaOriginal[I+3] := 'n';
            PaginaOriginal[I+4] := 't'; PaginaOriginal[I+5] := 'x'; PaginaOriginal[I+6] := 'c'; PaginaOriginal[I+7] := 'l';
            PaginaOriginal[I+8] := 'a'; PaginaOriginal[I+9] := 's'; PaginaOriginal[I+10] := 's'; PaginaOriginal[I+11] := '=';
            PaginaOriginal[I+12] := '"'; PaginaOriginal[I+13] := 'M'; PaginaOriginal[I+14] := 'A'; PaginaOriginal[I+15] := 'R';
            PaginaOriginal[I+16] := 'C'; PaginaOriginal[I+17] := 'A'; PaginaOriginal[I+18] := '"'; PaginaOriginal[I+19] := 'x';
            Inc(I,20);
            End;
          End;
        End;
      End
    Else
      Begin
      PaginaOriginal[I] := BufferA^[Ind];
      Inc(I);
      If I > Length(PaginaOriginal) Then
        SetLength(PaginaOriginal,Length(PaginaOriginal)+10000);
      End;
  SetLength(PaginaOriginal,I-1); // Ajusta o tamanho certo

  If (Report133CC) And (Not Orig) Then
    Begin
    Apendix := '';
//    PaginaAcertada[1] := ' ';
    I := 1;
    InsertHtmlEspace;
    For Ind := 2 To Length(PaginaOriginal) Do
      If (PaginaOriginal[Ind-1] = #10) And (Not (PaginaOriginal[Ind] in [#13,'x'])) Then // É Comando de carro, vai tratar...
        Begin
        If Apendix <> '' Then
          InsertHtmlCrLf;
        Apendix := '';
        ComandoDeCarro := PaginaOriginal[Ind];
        If ComandoDeCarro = '0' Then
          InsertHtmlCrLf
        Else
          If ComandoDeCarro = '-' Then
            Apendix := CrLf;
        InsertHtmlEspace;
        End
      Else
        If (PaginaOriginal[Ind] = #13) Then
          Begin
          End
      Else
        If (PaginaOriginal[Ind] = #10) Then
          Begin
          InsertHtmlCrLf;
          End
      Else
        If (PaginaOriginal[Ind] = ' ') Then
          Begin
          InsertHtmlEspace;
          End
        Else
          Begin
          PaginaAcertada[I] := PaginaOriginal[Ind];
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End;
    SetLength(PaginaAcertada,I-1); // Ajusta
    End
  Else
    PaginaAcertada := PaginaOriginal;
  End;

Begin
AssignFile(Log,'F:\SITES\CRCONSULTING\ROM\LogDLL.txt');
ReWrite(Log);
WriteLn(Log,'Entrada '+FormatDateTime('DDMMYYYY HHNNSSZZZ',Now));
Result := -1;
MensagemErroMultiCold := '';
MensagemErroSisOp := '';
FileMode := 0;  // Abrir arquivos Read Only...

AbreRelatorio(NomeDoRelatorio, MensagemErroMultiCold, MensagemErroSisOp, ArqRel, ArqPag64, ArqCNFG, RegDestino,
              RegDestinoII, RegGrp, RegDFN, RegSistema, ArrRegIndice, TemRegGrp, Report133CC, ComprimeBrancos, DefChave);

WriteLn(Log,'AbreRelatório '+FormatDateTime('DDMMYYYY HHNNSSZZZ',Now));
TotalDePaginas := FileSize(ArqPag64);

FillChar(ArrBol,SizeOf(ArrBol),0);

WriteLn(Log,'CreateDtMdl e Frm '+FormatDateTime('DDMMYYYY HHNNSSZZZ',Now));

If CodConsulta = -1 Then // Pediu página sem ser da lista de consulta realizada previamente
  NumeroDaPagina := NumeroDaPaginaOuPesquisa
Else
  Begin
  AssignFile(ArqPsq,ColetaDiretorioTemporario+'MultiColdWeb\auxFiles\'+IntToStr(CodConsulta)+'.psq');
  Reset(ArqPsq); { Depósito de páginas com pesquisa OK }
  Seek(ArqPsq,NumeroDaPaginaOuPesquisa);
  Read(ArqPsq,RegPsq);
  NumeroDaPagina := RegPsq.Pagina;
  CloseFile(ArqPsq);

  DataModule2 := TDataModule1.Create(nil);
  DataModule2.DataBase1.AliasName := 'MSSQLMultiCold';

  With DataModule2 Do
    Begin

    Database1.Open;

    Query1.SQL.Clear;
    Query1.SQL.Add('SELECT * FROM Consulta WHERE codConsulta = '+IntToStr(CodConsulta));
    Query1.Open;
    QueryDbf.SQL.Clear;
    QueryDbf.SQL.Text := Query1.Fields[5].AsString;
    Query1.Close;

    QueryDbf.Open;

    QueryDbf.MoveBy(RegPsq.PosQuery-1);
    While QueryDbf.Fields[1].AsInteger = NumeroDaPagina Do
      Begin
      Posic := 3;
      While Posic <= QueryDbf.FieldCount Do
        Begin
        If (QueryDbf.Fields[Posic].AsInteger-1) <= MaxLinhasPorPag Then
          ArrBol[QueryDbf.Fields[Posic].AsInteger-1] := True;   // Field = Linha, aqui começa em 0
        Inc(Posic,5);     { Cada Campo de pesquisa gera 5 campos }
        End;
      If QueryDbf.EOF Then
        Break;
      QueryDbf.Next;
      End;

    QueryDbf.Close;

    Database1.Close;
    
    Free;
    End;

  End;

Seek(ArqPag64,NumeroDaPagina - 1);
Read(ArqPag64,Inicio64);
{$i-}
Read(ArqPag64,Fim64);
{$i+}
If IoResult <> 0 Then
  Fim64 := ArqRel.Size;
CloseFile(ArqPag64);

ArqRel.Seek(Inicio64+1,soFromBeginning);
BufI := nil;
Buffer := nil;
ReallocMem(BufI,Fim64-Inicio64); { Allocates only the space needed }
ArqRel.Read(BufI^,Fim64-Inicio64); { Read only the buffer To decompress }
ArqRel.Free;

ReallocMem(Buffer,0); { DeAllocates }

Try
  ZDecompress(BufI, Fim64-Inicio64, Buffer, QtdBytesPagRel, 0);
Except
  On E: Exception Do
    Begin
    ArqRel.Free;
    CloseFile(ArqPag64);
    MensagemErroMultiCold := 'Erro de descompressão da página...';
    MensagemErroSisOp := PChar(E.Message);
    Exit;
    End;
  End; // Try

//                            Orig
Decripta(Buffer, Report133CC, False, QtdBytesPagRel);
ReallocMem(Buffer,0); { DeAllocates }
ReallocMem(BufI,0); { DeAllocates }

WriteLn(Log,'Ler página, Desc e Desc '+FormatDateTime('DDMMYYYY HHNNSSZZZ',Now));

//AssignFile(ArqPagina, NomeDoArquivo+'.Original');
//ReWrite(ArqPagina);
//WriteLn(ArqPagina, PaginaOriginal);
//WriteLn(ArqPagina, StringReplace(StringReplace(PaginaOriginal,' ','&nbsp;',[rfReplaceAll, rfIgnoreCase]),
//                                 #13#10,'<br>',[rfReplaceAll, rfIgnoreCase]));
//CloseFile(ArqPagina);

AssignFile(ArqPagina, NomeDoArquivo+'.Acertada');
ReWrite(ArqPagina);
WriteLn(ArqPagina, PaginaAcertada);
//WriteLn(ArqPagina, StringReplace(StringReplace(PaginaAcertada,' ','&nbsp;',[rfReplaceAll, rfIgnoreCase]),
//                                 #13#10,'<br>',[rfReplaceAll, rfIgnoreCase]));
CloseFile(ArqPagina);

AssignFile(ArqPagina, NomeDoArquivo+'.Info');
ReWrite(ArqPagina);
WriteLn(ArqPagina, NumeroDaPaginaOuPesquisa);
WriteLn(ArqPagina, TotalDePaginas);
WriteLn(ArqPagina, MensagemErroSisOp);
WriteLn(ArqPagina, MensagemErroMultiCold);
CloseFile(ArqPagina);

WriteLn(Log,'Gravar os arquivos e fim '+FormatDateTime('DDMMYYYY HHNNSSZZZ',Now));
CloseFile(Log);
Result := 0;
End;

Function ListaCampos;
Var
  MensagemErroMultiCold,
  MensagemErroSisOp : String;
  ArqRel : TFileStream;
  ArqPag64 : FileOfInt64;
  ArqCNFG : FileOfTgRegDFN;
  RegDestino,
  RegDestinoII,
  RegGrp,
  RegDFN,
  RegSistema : TgRegDFN;
  ArrRegIndice : Array0_199OfTgRegDFN;
  TemRegGrp,
  Report133CC,
  ComprimeBrancos : Boolean;
  DefChave: Array1_11_1_99OfString;
  I : Integer;
  DataModule2 : TDataModule1;

Begin
Result := 0;
MensagemErroMultiCold := '';
MensagemErroSisOp := '';
FileMode := 0;  // Abrir arquivos Read Only...

AbreRelatorio(NomeDoRelatorio, MensagemErroMultiCold, MensagemErroSisOp, ArqRel, ArqPag64, ArqCNFG, RegDestino,
              RegDestinoII, RegGrp, RegDFN, RegSistema, ArrRegIndice, TemRegGrp, Report133CC, ComprimeBrancos, DefChave);
CloseFile(ArqPag64);
ArqRel.Free;

DataModule2 := TDataModule1.Create(nil);
DataModule2.DataBase1.AliasName := 'MSSQLMultiCold';
I := 0;

With DataModule2 Do
  Begin

  Query1.SQL.Clear;
  Query1.SQL.Add('DELETE FROM campoRelatorio WHERE CODUSUARIO = '''+CodUsuario+'''');
  Try
    Query1.ExecSQL;
  Except
    End; // Try

  While ArrRegIndice[I].TipoReg <> 0 Do
    Begin

    Database1.Open;

    QueryCampos.Params[0].asString := CodUsuario;
    QueryCampos.Params[1].asString := ArrRegIndice[I].NomeCampo;
    QueryCampos.Params[2].asString := ArrRegIndice[I].TipoCampo;
    QueryCampos.Params[3].AsInteger := ArrRegIndice[I].Tamanho;
    QueryCampos.Params[4].AsInteger := ArrRegIndice[I].Coluna;

    Try
      QueryCampos.ExecSQL;
    Except
      Result := -1;
      DataBase1.Close;
      Free;
      Exit;
      End; // Try

    Inc(I);

    End;

  DataBase1.Close;

  Free;

  End;

End;

Procedure TDataModule1.Session1Startup(Sender: TObject);
Begin
Session1.NetFileDir := 'C:\Rom\MultiCold\NetFileDir\';
ForceDirectories('C:\Rom\MultiCold\PrivateDir\'+Session1.SessionName);
Session1.PrivateDir := 'C:\Rom\MultiCold\PrivateDir\'+Session1.SessionName;
//Session1.AutoSessionName
End;

Function GeraQueryFacil;
Var
  MensagemErroMultiCold,
  MensagemErroSisOp : String;
  ArqRel : TFileStream;
  ArqPag64 : FileOfInt64;
  ArqCNFG : FileOfTgRegDFN;
  RegDestino,
  RegDestinoII,
  RegGrp,
  RegDFN,
  RegSistema : TgRegDFN;
  ArrRegIndice : Array0_199OfTgRegDFN;
  TemRegGrp,
  Report133CC,
  ComprimeBrancos,
  DeuErro : Boolean;
  DefChave: Array1_11_1_99OfString;
  I,
  RCount,
  NumPag,
  QNumPag : Integer;
  NomeDoRelatorio : String;
  ArqPsq : TgArqPsq;
  RegPsq : TgRegPsq;
  AuxForm : TAuxForm;
  DataModule2 : TDataModule1;

  arqLog : System.Text; // Criado por Gabriel em 08/03/2004 - para verificação de problemas na MetroRED

  Function RepetiuCampo(CampoAtu : Integer) : Boolean;
  Var
    I : Integer;
  Begin
  Result := False;
  For I := 1 To CampoAtu-1 Do
    Begin
    If AuxForm.GridPesq.Cells[1,I] = AuxForm.GridPesq.Cells[1,CampoAtu] Then
      Begin
      Result := True;
      Exit;
      End;
    End;
  End;

  Procedure MontaQuery;
  Var
    TemAnd,
    TemOr : Boolean;
    PAnd,
    J,
    Linha,
    ICampos,
    TotaldeCampos : Integer;
    Parente1,
    NotStr,
    Abre,
    Fecha,
    Parente,
    ArgPesq,
    Caspa,
    StrAux1 : String;
    ListaDeCampos : Array[1..100] Of String;
  Begin
  TemAnd := False;
  TemOr := False;
  ICampos := 0;
  TotaldeCampos := 0;

  With AuxForm Do
    Begin
    Memo1.Clear;
    Memo1.Lines.Add('SELECT * FROM ');

    Try
      For Linha := 1 To 100 Do
        If GridPesq.Cells[1,Linha] <> '' Then
          Begin
          If (Linha > 1) And (Not RepetiuCampo(Linha)) Then
            Memo1.Lines[Memo1.Lines.Count-1] := Memo1.Lines[Memo1.Lines.Count-1] + ',';
          Parente := '';
          While (Length(GridPesq.Cells[1,Linha]) > 0) And   // Retira os parênteses existentes
                (GridPesq.Cells[1,Linha][1] = '(') Do       // Para pegar o nome Do campo limpo logo mais abaixo
            Begin
            Parente := Parente + '(';
            GridPesq.Cells[1,Linha] := Copy(GridPesq.Cells[1,Linha],2,Length(GridPesq.Cells[1,Linha])-1);
            End;
          If Not RepetiuCampo(Linha) Then
            Begin
            Memo1.Lines.Add('"'+ChangeFileExt(NomeDoRelatorio,'')+GridPesq.Cells[1,Linha]+'.DBF'+'"'+' '+
                                              GridPesq.Cells[1,Linha]);
            Inc(TotalDeCampos);
            Inc(ICampos);
            ListaDeCampos[ICampos] := GridPesq.Cells[1,Linha]; // Reserva o campo distinto para a montagem Do And
                                                               // de página e/ou linha abaixo
            End;
          GridPesq.Cells[1,Linha] := Parente + GridPesq.Cells[1,Linha];
          End
        Else
          Break;

      Memo1.Lines.Add('WHERE');

      For Linha := 1 To 100 Do
        If GridPesq.Cells[1,Linha] <> '' Then
          Begin
          If UpperCase(TrimLeft(GridPesq.Cells[2,Linha][1])) = 'N' Then
            Begin
            NotStr := 'NOT ';
            GridPesq.Cells[2,Linha] := Copy(GridPesq.Cells[2,Linha],5, Length(GridPesq.Cells[2,Linha])-4);
            Abre := '(';
            Fecha := ')';
            End
          Else
            Begin
            NotStr := '';
            Abre := '';
            Fecha := '';
            End;

          If Linha = 1 Then
            NotStr := '( ' + NotStr;

          ArgPesq := GridPesq.Cells[3,Linha];

          Caspa := '';
          For J := 1 To 99 Do
            If Uppercase(GridPesq.Cells[1,Linha]) = Uppercase(ArrRegIndice[J].NomeCampo) Then
              Begin
              If (UpperCase(ArrRegIndice[J].TipoCampo) = 'C') Or  // Tratamento automático de campos character
                 (UpperCase(ArrRegIndice[J].TipoCampo) = 'DT') Then // ou data, colocando a caspa
                Caspa := '''';

              If (UpperCase(GridPesq.Cells[2,Linha]) = 'IN') Or
                 (UpperCase(GridPesq.Cells[2,Linha]) = 'IS') Or
                 (UpperCase(GridPesq.Cells[2,Linha]) = 'IS NOT') Then
                Caspa := '';

              If UpperCase(ArrRegIndice[J].TipoCampo) = 'DT' Then
                Try
                  ShortDateFormat := 'DD/MM/YYYY';
                  ArgPesq := FormatDateTime('MM/DD/YYYY',StrToDate(ArgPesq));
                Except
                  Memo1.Clear;
                  Memo1.Lines.Add('Formato da data informada inválido, verifique');
                  Exit;
                  End; // Try
              Break;
              End;

          If Uppercase(GridPesq.Cells[2,Linha]) = 'BETWEEN' Then
            Begin
            PAnd := Pos('AND',Uppercase(ArgPesq));
            Memo1.Lines.Add(NotStr+Abre+GridPesq.Cells[1,Linha] + '.VALOR '+ GridPesq.Cells[2,Linha]+ ' ' + Caspa +
                            Copy(ArgPesq,1,PAnd-2)+Caspa+' AND '+Caspa+Copy(ArgPesq,PAnd+4,Length(ArgPesq)-PAnd-3)+
                            Caspa + Fecha + ' ' +GridPesq.Cells[4,Linha]);

            End
          Else
            Memo1.Lines.Add(NotStr+Abre+GridPesq.Cells[1,Linha] + '.VALOR '+GridPesq.Cells[2,Linha]+ ' ' + Caspa +
                            ArgPesq + Caspa + Fecha + ' ' + GridPesq.Cells[4,Linha]);

          If UpperCase(Trim(GridPesq.Cells[4,Linha])) = 'AND' Then
            TemAnd := True
          Else
            If UpperCase(Trim(GridPesq.Cells[4,Linha])) = 'OR' Then
              TemOr := True;

          If Abre <> '' Then // O Not foi movido e vai ser recolocado
            GridPesq.Cells[2,Linha] := 'NOT ' + GridPesq.Cells[2,Linha];

          End
        Else
          Break;

      Parente := '';
      While (GridPesq.Cells[1,1][1] = '(') And (Length(GridPesq.Cells[1,1]) > 0) Do
        Begin
        Parente := Parente + '(';
        GridPesq.Cells[1,1] := Copy(GridPesq.Cells[1,1],2,Length(GridPesq.Cells[1,1])-1);
        End;

      If TotalDeCampos > 1 Then
        Begin
        For Linha := 2 To 100 Do
          If GridPesq.Cells[1,Linha] <> '' Then
            Begin
            Memo1.Lines[Memo1.Lines.Count-1] := Memo1.Lines[Memo1.Lines.Count-1] + ' AND';

            Parente1 := '';
            While (GridPesq.Cells[1,Linha][1] = '(') And (Length(GridPesq.Cells[1,Linha]) > 0) Do
              Begin
              Parente1 := Parente1 + '(';
              GridPesq.Cells[1,Linha] := Copy(GridPesq.Cells[1,Linha],2,Length(GridPesq.Cells[1,Linha])-1);
              End;

            If ProcurNaMesma.Checked Then
              Memo1.Lines.Add('(('+GridPesq.Cells[1,1]+'.PAGINA = '+GridPesq.Cells[1,Linha]+ '.PAGINA'+') And ('+
                              GridPesq.Cells[1,1]+'.LINHA = '+GridPesq.Cells[1,Linha]+ '.LINHA))')
            Else
              Memo1.Lines.Add(GridPesq.Cells[1,1]+'.PAGINA = '+GridPesq.Cells[1,Linha]+ '.PAGINA');

            GridPesq.Cells[1,Linha] := Parente1 + GridPesq.Cells[1,Linha];

            End;
        End;

      GridPesq.Cells[1,1] := Parente + GridPesq.Cells[1,1];

      Memo1.Lines[Memo1.Lines.Count-1] := Memo1.Lines[Memo1.Lines.Count-1]+')';

      If ProcurSeq.Checked Then
        Begin
        StrAux1 := '';
        For Linha := 1 To 100 Do
          If GridPesq.Cells[1,Linha+1] <> '' Then
            StrAux1 := StrAux1 + 'And (' + GridPesq.Cells[1,Linha]+ '.RELATIVO < ' +
                       GridPesq.Cells[1,Linha+1]+ '.RELATIVO ' + ')';
        Memo1.Lines.Add(StrAux1);

        StrAux1 := '';
        For Linha := 1 To 100 Do
          If GridPesq.Cells[1,Linha] <> '' Then
            StrAux1 := StrAux1 + GridPesq.Cells[1,Linha]+ '.RELATIVO, ';
        Delete(StrAux1,Length(StrAux1)-1,2);

        End;
      Except
        Memo1.Clear;
        Memo1.Lines.Add('Erro na interpretação da Query Fácil, verifique...');
        Exit;
        End; // Try

      If ProcurSeq.Checked Then
        Memo1.Lines.Add('ORDER BY PAGINA, '+StrAux1)
      Else
        Memo1.Lines.Add('ORDER BY PAGINA, RELATIVO');

      If TemAnd And TemOr Then
        Begin
        Memo1.Clear;
        Memo1.Lines.Add('And e OR não podem ser misturados em uma query. Por favor, refaça sua pesquisa')
        End
      Else
      If TemOr And (TotalDeCampos <> 1) Then
        Begin
        Memo1.Clear;
        Memo1.Lines.Add('Campos distintos não podem ser misturados em uma query com OR. Por favor, refaça sua pesquisa')
        End
    End; // With
  End;

Begin

// Alterado por Gabriel em 08/03/2004
assignFile(arqLog,'F:\SITES\CRCONSULTING\ROM\LogDLLConsulta.txt');
rewrite(arqLog);
writeLn(arqLog,'INÍCIO QUERY FÁCIL');

Result := -1;
DataModule2 := TDataModule1.Create(nil);
DataModule2.DataBase1.AliasName := 'MSSQLMultiCold';
AuxForm := TAuxForm.Create(nil);

With DataModule2 Do
  Begin

  NumeroDePaginas := 0;
  Primeira := 0;
  Proxima := 0;
  Ultima := 0;

  Database1.Open;

  writeLn(arqLog,'CONECTOU AO BANCO DE DADOS'); // Alterado por Gabriel em 08/03/2004

  Query1.SQL.Clear;
  Query1.SQL.Add('SELECT * FROM Consulta WHERE codConsulta = '+IntToStr(CodConsulta));
  Try
    Query1.Open;
  Except
    Exit;
    End;
  NomeDoRelatorio := Query1.Fields[3].AsString;
  Query1.Close;

  writeLn(arqLog,'RECUPEROU NOME DO RELATORIO'); // Alterado por Gabriel em 08/03/2004

  AbreRelatorio(NomeDoRelatorio, MensagemErroMultiCold, MensagemErroSisOp, ArqRel, ArqPag64, ArqCNFG, RegDestino,
                RegDestinoII, RegGrp, RegDFN, RegSistema, ArrRegIndice, TemRegGrp, Report133CC, ComprimeBrancos, DefChave);
  CloseFile(ArqPag64);
  ArqRel.Free;

  writeLn(arqLog,'ABRIU RELATORIO'); // Alterado por Gabriel em 08/03/2004

  Query1.SQL.Clear;
  Query1.SQL.Add('SELECT * FROM campoConsulta WHERE codConsulta = '+IntToStr(CodConsulta));
  Query1.Open;

  writeLn(arqLog,'RECUPEROU LISTA DE CAMPOS'); // Alterado por Gabriel em 08/03/2004

  I := 1;
  While Not Query1.Eof Do
    Begin
    AuxForm.GridPesq.Cells[1,I] := Query1.Fields[2].AsString;
    AuxForm.GridPesq.Cells[2,I] := Query1.Fields[3].AsString;
    AuxForm.GridPesq.Cells[3,I] := Query1.Fields[4].AsString;
    AuxForm.GridPesq.Cells[4,I] := Query1.Fields[5].AsString;
    Inc(I);
    Query1.Next;
    End;

  Query1.Close;

  writeLn(arqLog,'CARREGOU LISTA DE CAMPOS'); // Alterado por Gabriel em 08/03/2004

  MontaQuery;

  writeLn(arqLog,'GEROU SQL'); // Alterado por Gabriel em 08/03/2004

  QueryDbf.Close; { deixa a query inativa }
  QueryDbf.Sql.Clear;
  QueryDbf.Sql := AuxForm.Memo1.Lines;

  DeuErro := False;
  Try
    If Length(QueryDbf.Sql.Text) > 6 Then
      QueryDbf.Open
    Else
      DeuErro := True;
  Except
    On E: Exception Do
      Begin
      AuxForm.Memo1.Clear;
      AuxForm.Memo1.Lines.Add('Query inválida... '+E.Message);
      DeuErro := True;
      End
    End; {Try..Except}

  writeLn(arqLog,'TESTOU SQL'); // Alterado por Gabriel em 08/03/2004

  RCount := 0;
  Try
    RCount := QueryDbf.RecordCount;
  Except
    DeuErro := True;
    End; // Try

  writeLn(arqLog,'CONTOU NÚMERO DE REGISTROS'); // Alterado por Gabriel em 08/03/2004

  If (Not (DeuErro)) And (RCount <> 0) Then
    Begin
    ForceDirectories(ColetaDiretorioTemporario+'MultiColdWeb\auxFiles\');

    writeLn(arqLog,'CRIOU DIRETORIO TEMPORARIO'); // Alterado por Gabriel em 08/03/2004

    AssignFile(ArqPsq,ColetaDiretorioTemporario+'MultiColdWeb\auxFiles\'+IntToStr(CodConsulta)+'.psq');
    ReWrite(ArqPsq); { Depósito de páginas com pesquisa OK }

    writeLn(arqLog,'CRIOU ARQUIVO TEMPORARIO'); // Alterado por Gabriel em 08/03/2004

    NumPag := -1;
    For I := 1 To RCount Do
      Begin
      QNumPag := QueryDbf.Fields[1].AsInteger;

      If QNumPag <> NumPag Then
        Begin
        NumPag := QNumPag;
        RegPsq.Pagina := NumPag;
        RegPsq.PosQuery := I;
        Write(ArqPsq,RegPsq);
        End;
        QueryDbf.Next;
      End;
    QueryDbf.Close;

    writeLn(arqLog,'ESCREVEU ARQUIVO TEMPORARIO'); // Alterado por Gabriel em 08/03/2004

    Reset(ArqPsq); { Flush the file as soon as possible }
    Read(ArqPsq,RegPsq);

    writeLn(arqLog,'IDENTIFICA PRIMEIRA E ÚLTIMA PÁGINA DA CONSULTA'); // Alterado por Gabriel em 08/03/2004

    Primeira := RegPsq.Pagina;
    NumeroDePaginas := FileSize(ArqPsq);  { Número de Páginas }
    If NumeroDePaginas = 1 Then
      Begin
      Ultima := Primeira;
      Proxima := Primeira;
      End
    Else
      Begin
      Read(ArqPsq,RegPsq);
      Proxima := RegPsq.Pagina;
      Seek(ArqPsq,NumeroDePaginas-1);
      Read(ArqPsq,RegPsq);
      Ultima := RegPsq.Pagina;
      End;
    CloseFile(ArqPsq);
//    DeleteFile(ColetaDiretorioTemporario + 'MultiColdWeb\auxFiles\' + IntToStr(CodConsulta)+'.psq');
    End;

////////////
  QueryUpdateConsulta.Params[0].AsMemo := AuxForm.Memo1.Text;
  QueryUpdateConsulta.Params[1].AsInteger := CodConsulta;
  QueryUpdateConsulta.ExecSQL;

  Result := 0;

  DataBase1.Close;

  writeLn(arqLog,'ENCERROU CONEXÃO COM O BANCO DE DADOS'); // Alterado por Gabriel em 08/03/2004

  Free;

  End;

AuxForm.Free;

writeLn(arqLog,'TERMINOU'); // Alterado por Gabriel em 08/03/2004
closeFile(arqLog);

End;

Procedure TDataModule1.DataModuleCreate(Sender: TObject);
Var
  MyList : TStringList;           // Variáveis da criação do alias...
  ArqCnfg : System.Text;
  Tipo,
  Confs : String;
Begin
LogInInfoLocal[1] := '';
LogInInfoLocal[2] := '';
If Session1.IsAlias('MSSQLMultiCold') Then
  Session1.DeleteAlias('MSSQLMultiCold');
AssignFile(ArqCNFG,ExtractFilePath(ParamStr(0))+'DatabaseLocal.cnfg');
Reset(ArqCNFG);
ReadLn(ArqCNFG,Tipo);
MyList := TStringList.Create;
Try
  With MyList Do
    While Not Eof(ArqCNFG) Do
      Begin
      ReadLn(ArqCNFG,Confs);
      If Pos('USER NAME',Confs) <> 0 Then
        LogInInfoLocal[1] := Copy(Confs,11,Length(Confs)-10);
      If Pos('PASSWORD',Confs) <> 0 Then
        LogInInfoLocal[2] := Copy(Confs,10,Length(Confs)-9);
      Add(Confs);
      End;
  Session1.AddAlias('MSSQLMultiCold', Tipo, MyList);
Finally
  MyList.Free;
  CloseFile(ArqCNFG);
  End; //Try
End;

Procedure TDataModule1.Database1Login(Database: TDatabase;
  LoginParams: TStrings);
Begin
LoginParams.Values['USER NAME'] := LogInInfoLocal[1];
LoginParams.Values['PASSWORD'] := LogInInfoLocal[2];
End;

End.

