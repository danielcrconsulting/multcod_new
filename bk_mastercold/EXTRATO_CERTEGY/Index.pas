Unit Index;

{
     R2 - 16/07/2001 - o sistema n�o processou um arquivo grande de cart�es. Havia um problema na velha rotina de sort.
     Havia a necessidade de criar um arquivo de sort auxiliar e o comando era assign ainda em vez do novo assignfile.
     o ReWrite(File) foi alterado para Rewrite(File,1), pois o default � de 128 registros como usado antes
     Aproveitei para aumentar o buffer de p�gina de 30 para 60 megas. Retirei, tamb�m o �ndice de nome do arquivo de
     contas por n�o estar sendo mais referenciado. Coloca��o do n�mero de buffers no ini file.
     R3 - 21/08/2001 - Inclus�o de um campo de tipo de conta no arquivo de contas
     R8 - 21/12/2001 - Tratamento de ciclo na Extr e no Detex. Verifica��o de reestrutura��o considerando o ciclo
     R11 -14/05/2003 - Go Beyond 4GB for Detex and Extr files
     R12 -23/05/2003 - Com a introdu��o do sort recursivo o stack explodiu, usamos -> $M 16384, 268435456
}

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Sugeral,
  Forms, Dialogs, StdCtrls, Grids, SuTypGer, Zlib, Buttons, DB{, DBTables}, AvisoI, ExtCtrls, Menus,
  OleCtrls, ComCtrls, SSort, Subrug;

Type

  TSort = Class (SuperSort)
          Procedure InPutSort; Override;
          Procedure OutPutSort; Override;
          Function Less(Var X, Y) : Boolean; Override;
          End;

  TSortNomeCartao = Class (SuperSort)
                    Procedure InPutSort; Override;
                    Procedure OutPutSort; Override;
                    Function Less(Var X, Y) : Boolean; Override;
                    End;

  TSortBal = Class
             Procedure InPutSort;
//             Procedure InPutSortNumGer(Const NomeDoIndice : AnsiString);
             Procedure InPutSortNome(Const NomeDoIndice : AnsiString);
//             Procedure InPutSortCnt(Ano, Mes : Integer);
             Procedure OutPutSort;
//             Procedure OutPutSortNumGer(Const NomeDoIndice : AnsiString);
             Procedure OutPutSortNome(Const NomeDoIndice : AnsiString);
//             Procedure OutPutSortCnt(Ano, Mes : Integer);
             End;

  TFormIndex = Class(TForm)
    Label5: TLabel;
    SairSpeedButton: TSpeedButton;
    ProcessarSpeedButton: TSpeedButton;
    ConfigProcSpeedButton: TSpeedButton;
    Label2: TLabel;
    Arquivos: TStringGrid;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Indexar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Configuraes1: TMenuItem;
    Processamento1: TMenuItem;
    Timer1: TTimer;
    RichEdit1: TRichEdit;
    Label3: TLabel;
//    Table1: TTable;
//    Query1: TQuery;
    Label1: TLabel;
    Edit2: TEdit;
    Procedure FormCreate(Sender: TObject);
    Procedure SairSpeedButtonClick(Sender: TObject);
    Procedure ProcessarSpeedButtonClick(Sender: TObject);
    Procedure Processamento1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    { Private declarations }
  Public
    { Public declarations }

    Agora : TDateTime;

    BufOut : Array[1..BufSize] Of AnsiChar;

    ContaAnt : TgArr016;
    AnoMesAnt : TgArr006;
    CicloAnt : TgArr002;

//    IndiceContaDetex : TgIndiceI64F;
    IndiceSortI64,
    IndiceSortI64Aux,
    IndiceConta,
    IndiceContaAntigo,
    IndiceContaEmpresa,
    IndiceContaEmpresaAntigo,
    IndiceCpfCgc,
    IndiceCpfCgcAntigo,
    IndiceCartao,
    IndiceCartaoAntigo : TgIndiceI64F;
    IndiceNomeCartao,
    IndiceNomeCartaoAntigo : TgIndiceNomeCartao;

    ArqIndiceContaDetex : File Of TgIndiceI64F;
    ArqIndiceSortI64,
    ArqIndiceConta,
    ArqIndiceContaAntigo,
    ArqIndiceContaEmpresa,
    ArqIndiceContaEmpresaAntigo,
    ArqIndiceCpfCgc,
    ArqIndiceCpfCgcAntigo,
    ArqIndiceCartao,
    ArqIndiceCartaoAntigo : File Of TgIndiceI64F;
    ArqIndiceNomeCartao,
    ArqIndiceNomeCartaoAntigo : File Of TgIndiceNomeCartao;
    AuxConta : Int64;
//    ArqDatAntigo : File;
    ArqDatAntigo : TFileStream;

    NBytesOut,
    Resultado,
    Posic,
    TamBufOut,
    TotReg,
    TotOut,
    TotTamExt,
    TotTam,
    SeqLog,
    SeqProto,
    QuebraMod : Integer;
    PosArq,
    Divisor : Int64;

    ArqIn  : System.Text;

//    ArqOut : File;
    ArqOut : TFileStream;

//    ReportStr,
    Reports1Str,
    Linha2,
    DirIn,
    Linha : AnsiString;

    SearchRecDistribui,
    SearchRecTxt : TSearchRec;
    TxtRec : TSearchRec;

    BufSaida,
    BufCmp,
    BufDatAntigo,
    BufOutAntigo : Pointer;

//    UnsrExtr,
    UnsrExtrBmg,
//    UnsrExtrRQ,
    UnsDetex,
    UnsDetexBmg,
//    UnsDetexRQ,
    UnsrCont,
    UnsrContVP,
    UnsrContBmg,
    UnsrCart,
    UnsrCartVP,
    UnsrCartBmg,
//    ExtrCeAv0001,
    Fusao    : Boolean;

    CodNum,
    NomeGrupo,
    CodAlfa     : AnsiString;

    IArrUnsDetex : Integer;

    ArrExtrDetexArq : Array[1990..2050, 1..12] Of Record
                                                  ArqOut : File;
                                                  ArqInd : File Of TgIndiceI64F;
                                                  Processou : Boolean;
                                                  End;

    TaSort : TSortBal;
    TsSort : Supersort;

    // CeA

{    EncadeouProc : Boolean;

    FileList : TFileList;

    ArqVas905   : System.Text;
    RegVas905   : Vas905;

    NomeArqIndiceNome : AnsiString;}

    ArqIndiceNome : File Of TgIndiceNome;
    RegIndiceNome : TgIndiceNome;

{    ArqIndiceNumCnt : File Of TgIndiceNumCnt; }
{    RegIndiceNumCnt : TgIndiceNumCnt;

    ArqIndiceNumGer : File Of TgIndiceNumGer;
    RegIndiceNumGer : TgIndiceNumGer;

    ArrArqMovs : Array[1990..2050, 1..12] Of Record
                                             ArqOut : File;
                                             ArqInd : File Of TgIndiceNumCnt;
                                             NomeDoIndice : AnsiString;
                                             Processou : Boolean;
                                             End;   }

//    Function IndiceDesbalanceadoCeA(Ano, Mes : Integer) : Boolean;

//*******************************************************************************

    Function  PreparaInicioDeProcessamento : Boolean;
    Procedure PreparaFusao;
    Function  ProcessaUnsrExtr : Boolean;
    Function  ProcessaUnsDetex : Boolean;
    Function  ProcessaUnsrContVP : Boolean;   // Esta fun��o foi atualizada para +2GB files
    Function  ProcessaUnsrCartVP : Boolean;   // Esta fun��o foi atualizada para +2GB files

    Procedure AtuEst;
    Procedure DetSeq;
    Procedure PosicionaRichEdit;
  published
    property Text;
  End;

Var
  FormIndex: TFormIndex;

Implementation

Uses ConfigProc, IniFiles, Analisador, Asort;

{$R *.DFM}
{$R-}

Procedure TFormIndex.PosicionaRichEdit;
Begin
Try
  RichEdit1.SetFocus;
  RichEdit1.SelStart := Length(RichEdit1.Text)-2;
  RichEdit1.SelLength := 1;
  Application.ProcessMessages;
Except
  End; // Try
If RichEdit1.Lines.Count >= 10000 Then
  RichEdit1.Clear;
End;

{Function TSortBal.Less(Var X, Y) : Boolean;
Var
  Reg1 : TgIndiceI64F Absolute X;
  Reg2 : TgIndiceI64F Absolute Y;
Begin
//Result := (Reg1.Valor < Reg2.Valor) Or
//          ((Reg1.Valor = Reg2.Valor) And (Reg1.PosIni < Reg2.PosIni));
Result := (Reg1.Valor < Reg2.Valor) Or
          ((Reg1.Valor = Reg2.Valor) And (Reg1.TipoConta < Reg2.TipoConta)) Or
          ((Reg1.Valor = Reg2.Valor) And (Reg1.TipoConta = Reg2.TipoConta) And (Reg1.PosIni < Reg2.PosIni));
Inc(Contt);
If Contt = 10000000 Then
  Begin
  Contt := 0;
  Inc(Conttt,10000000);
  FormIndex.RichEdit1.Lines[FormIndex.RichEdit1.Lines.Count-1] := IntToStr(Conttt)+' de loops ... '+IntToStr(Reg1.Valor)+
                                                                  ' '+IntToStr(Reg2.Valor);
  End;
End; }

Procedure TsortBal.InPutSort;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Otimizando Indice '+NomeArqIndice);
  RichEdit1.Lines.Add('Carregados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceSortI64,NomeArqIndice);
  Reset(ArqIndiceSortI64);
  I := 0;
  While Not Eof(ArqIndiceSortI64) Do
    Begin
    Read(ArqIndiceSortI64,IndiceSortI64);
    SortMem.ArInd[I] := IndiceSortI64;
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
    End;
  CloseFile(ArqIndiceSortI64);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
  RichEdit1.Lines.Add('Ordenando... ');
  PosicionaRichEdit;
  End;
End;

Procedure TSortBal.OutPutSort;
Var
  Err, I, J, K : Integer;
  ArqDatIn,
  ArqDatOut : File;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Processados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceSortI64,NomeArqIndice+'_');
  ReWrite(ArqIndiceSortI64);
  AssignFile(ArqDatIn,NomeArqDat);
  AssignFile(ArqDatOut,NomeArqDat+'_');
  Reset(ArqDatIn,1);
  ReWrite(ArqDatOut,1);
  I := 0;
  J := 0;
  K := 0;
  IndiceSortI64Aux := SortMem.ArInd[K];
  Inc(K);
  While Not False Do
    Begin
    If K = Length(SortMem.ArInd) Then
      Break;
    IndiceSortI64 := SortMem.ArInd[k];
    Inc(K);
    If (IndiceSortI64.Valor <> IndiceSortI64Aux.Valor) Or
       (IndiceSortI64.TipoConta <> IndiceSortI64Aux.TipoConta) Then
      Begin
      Seek(ArqDatIn, IndiceSortI64Aux.PosIni);
      ReallocMem(BufCmp, IndiceSortI64Aux.Tam);
      BlockRead(ArqDatIn,BufCmp^,IndiceSortI64Aux.Tam,Err);
      IndiceSortI64Aux.PosIni := FilePos(ArqDatOut);
      BlockWrite(ArqDatOut,BufCmp^,IndiceSortI64Aux.Tam,Err);
      Write(ArqIndiceSortI64,IndiceSortI64Aux);
      Inc(J);
      End;
    IndiceSortI64Aux := IndiceSortI64;

    Inc(I);
    If (I Mod 10000) = 0 Then
      Begin
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(I);
      Application.ProcessMessages;
      End;
    End;
  Seek(ArqDatIn, IndiceSortI64Aux.PosIni);
  ReallocMem(BufCmp, IndiceSortI64Aux.Tam);
  BlockRead(ArqDatIn,BufCmp^,IndiceSortI64Aux.Tam,Err);
  IndiceSortI64Aux.PosIni := FilePos(ArqDatOut);
  BlockWrite(ArqDatOut,BufCmp^,IndiceSortI64Aux.Tam,Err);
  Write(ArqIndiceSortI64,IndiceSortI64Aux); // Escreve o �ltimo...
  Inc(I);
  Inc(J);
  CloseFile(ArqIndiceSortI64);
  CloseFile(ArqDatOut);
  CloseFile(ArqDatIn);
  ReallocMem(BufCmp, 0);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(I);
  RichEdit1.Lines.Add('Descarregados: '+IntToStr(J));
  RichEdit1.Lines.Add('');
  PosicionaRichEdit;
//  DeleteFile(PChar(NomeArqDat));        Windows functions are no longer working
//  DeleteFile(PChar(NomeArqIndice));     Ansi to Wide strings convertion problem?
  System.SysUtils.DeleteFile(NomeArqDat);
  System.SysUtils.DeleteFile(NomeArqIndice);
  RenameFile(NomeArqDat+'_', NomeArqDat);
  RenameFile(NomeArqIndice+'_', NomeArqIndice);
  End;
End;

{Procedure TsortBal.InPutSortNumGer;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Otimizando Indice '+NomeDoIndice);
  RichEdit1.Lines.Add('Carregados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceNumGer,NomeDoIndice);
  Reset(ArqIndiceNumGer);
  I := 0;
  While Not Eof(ArqIndiceNumGer) Do
    Begin
    Read(ArqIndiceNumGer,RegIndiceNumGer);
    SortMem.ArIndNumGer[I] := RegIndiceNumGer;
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
    End;
  CloseFile(ArqIndiceNumGer);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
  RichEdit1.Lines.Add('Ordenando... ');
  PosicionaRichEdit;
  End;
End;

Procedure TSortBal.OutPutSortNumGer;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Processados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceNumGer,NomeDoIndice);
  ReWrite(ArqIndiceNumGer);

  For I := 0 To Length(SortMem.ArIndNumGer)-1 Do
    Begin
    Write(ArqIndiceNumGer, SortMem.ArIndNumGer[I]);

    If (I Mod 10000) = 0 Then
      Begin
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(I);
      Application.ProcessMessages;
      End;
    End;
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(Length(SortMem.ArIndNumGer));
  Application.ProcessMessages;
  CloseFile(ArqIndiceNumGer);
  End;
End;               }

Procedure TsortBal.InPutSortNome;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Otimizando Indice '+NomeDoIndice);
  RichEdit1.Lines.Add('Carregados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceNome,NomeDoIndice);
  Reset(ArqIndiceNome);
  I := 0;
  While Not Eof(ArqIndiceNome) Do
    Begin
    Read(ArqIndiceNome,RegIndiceNome);
    SortMem.ArIndNome[I] := RegIndiceNome;
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
    End;
  CloseFile(ArqIndiceNome);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
  RichEdit1.Lines.Add('Ordenando... ');
  PosicionaRichEdit;
  End;
End;

Procedure TSortBal.OutPutSortNome;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Processados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceNome,NomeDoIndice);
  ReWrite(ArqIndiceNome);

  For I := 0 To Length(SortMem.ArIndNome)-1 Do
    Begin
    Write(ArqIndiceNome, SortMem.ArIndNome[I]);

    If (I Mod 10000) = 0 Then
      Begin
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(I);
      Application.ProcessMessages;
      End;
    End;
  CloseFile(ArqIndiceNome);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(Length(SortMem.ArIndNome));
  Application.ProcessMessages;
  End;
End;

{Procedure TsortBal.InPutSortCnt;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Otimizando Indice '+ArrArqMovs[Ano, Mes].NomeDoIndice);
  RichEdit1.Lines.Add('Carregados: 0');
  PosicionaRichEdit;
  Reset(ArrArqMovs[Ano, Mes].ArqInd);
  I := 0;
  While Not Eof(ArrArqMovs[Ano, Mes].ArqInd) Do
    Begin
    Read(ArrArqMovs[Ano, Mes].ArqInd, RegIndiceNumCnt);
    SortMem.ArIndNumCnt[I] := RegIndiceNumCnt;
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
    End;
  CloseFile(ArrArqMovs[Ano, Mes].ArqInd);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Carregados: '+IntToStr(I);
  RichEdit1.Lines.Add('Ordenando... ');
  PosicionaRichEdit;
  End;
End;

Procedure TSortBal.OutPutSortCnt;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Processados: 0');
  PosicionaRichEdit;
  ReWrite(ArrArqMovs[Ano, Mes].ArqInd);

  For I := 0 To Length(SortMem.ArIndNumCnt)-1 Do
    Begin
    Write(ArrArqMovs[Ano, Mes].ArqInd, SortMem.ArIndNumCnt[I]);

    If (I Mod 10000) = 0 Then
      Begin
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(I);
      Application.ProcessMessages;
      End;
    End;
  CloseFile(ArrArqMovs[Ano, Mes].ArqInd);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := 'Processados: '+IntToStr(Length(SortMem.ArIndNumCnt));
  Application.ProcessMessages;
  End;
End;          }

Procedure TSort.InputSort;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Carregando Indice '+NomeArqIndice);
  RichEdit1.Lines.Add(NomeArqIndice+', carregados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceSortI64,NomeArqIndice);
  Reset(ArqIndiceSortI64);
  I := 0;
  While Not Eof(ArqIndiceSortI64) Do
    Begin
    Read(ArqIndiceSortI64,IndiceSortI64);
    SortRelease(IndiceSortI64);
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', carregados: '+IntToStr(I);
    End;
  CloseFile(ArqIndiceSortI64);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', carregados: '+IntToStr(I);
  RichEdit1.Lines.Add('Ordenando Indice '+NomeArqIndice);
  PosicionaRichEdit;
  End;
End;

Function TSort.Less(Var X, Y) : Boolean;
Var
  Reg1 : TgIndiceI64F Absolute X;
  Reg2 : TgIndiceI64F Absolute Y;
Begin
Result := (Reg1.Valor < Reg2.Valor) Or
          ((Reg1.Valor = Reg2.Valor) And (Reg1.PosIni < Reg2.PosIni));
End;

Procedure TSort.OutPutSort;
Var
  I : Integer;
Begin
If SortEos Then
  Exit;
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Descarregando Indice '+NomeArqIndice);
  RichEdit1.Lines.Add(NomeArqIndice+', descarregados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceSortI64,ChangeFileExt(NomeArqIndice,'.IND')); // Vem .ori sai .ind
  ReWrite(ArqIndiceSortI64);
  I := 0;
  While Not SortEos Do
    Begin
    SortReturn(IndiceSortI64);
    Write(ArqIndiceSortI64,IndiceSortI64);
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', descarregados: '+IntToStr(I);
    End;
  CloseFile(ArqIndiceSortI64);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', descarregados: '+IntToStr(I);
  RichEdit1.Lines.Add('');
  PosicionaRichEdit;
  End;
End;

Procedure TSortNomeCartao.InputSort;
Var
  I : Integer;
Begin
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Carregando Indice '+NomeArqIndice);
  RichEdit1.Lines.Add(NomeArqIndice+', carregados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceNomeCartao,NomeArqIndice);
  Reset(ArqIndiceNomeCartao);
  I := 0;
  While Not Eof(ArqIndiceNomeCartao) Do
    Begin
    Read(ArqIndiceNomeCartao,IndiceNomeCartao);
    SortRelease(IndiceNomeCartao);
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', carregados: '+IntToStr(I);
    End;
  CloseFile(ArqIndiceNomeCartao);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', carregados: '+IntToStr(I);
  RichEdit1.Lines.Add('Ordenando Indice '+NomeArqIndice);
  PosicionaRichEdit;
  End;
End;

Function TSortNomeCartao.Less(Var X, Y) : Boolean;
Var
  Reg1 : TgIndiceNomeCartao Absolute X;
  Reg2 : TgIndiceNomeCartao Absolute Y;
Begin
Result := (Reg1.Valor < Reg2.Valor) Or
          ((Reg1.Valor = Reg2.Valor) And (Reg1.PosIni < Reg2.PosIni));
End;

Procedure TSortNomeCartao.OutPutSort;
Var
  I : Integer;
Begin
If SortEos Then
  Exit;
With FormIndex Do
  Begin
  RichEdit1.Lines.Add('Descarregando Indice '+NomeArqIndice);
  RichEdit1.Lines.Add(NomeArqIndice+', descarregados: 0');
  PosicionaRichEdit;
  AssignFile(ArqIndiceNomeCartao,ChangeFileExt(NomeArqIndice,'.IND'));  // Vem .ori cria .ind
  ReWrite(ArqIndiceNomeCartao);
  I := 0;
  IndiceNomeCartaoAntigo.Valor := 'ESTE NOME N�O DEVE '; //Existir na base...
  While Not SortEos Do
    Begin
    SortReturn(IndiceNomeCartao);
    If (IndiceNomeCartao.Valor <> IndiceNomeCartaoAntigo.Valor) Or
       (IndiceNomeCartao.PosIni <> IndiceNomeCartaoAntigo.PosIni) Then
      Begin
      Write(ArqIndiceNomeCartao,IndiceNomeCartao);
      IndiceNomeCartaoAntigo := IndiceNomeCartao;
      End;
    Inc(I);
    If (I Mod 10000) = 0 Then
      RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', descarregados: '+IntToStr(I);
    End;
  CloseFile(ArqIndiceNomeCartao);
  RichEdit1.Lines[RichEdit1.Lines.Count-1] := NomeArqIndice+', descarregados: '+IntToStr(I);
  RichEdit1.Lines.Add('');
  PosicionaRichEdit;
  End;
End;

Procedure TFormIndex.DetSeq;

Begin
FormGeral.IBAdmRemotoDatabase.Open;
FormGeral.IBLogRemotoDatabase.Open;

FormGeral.IniciaTransacaoLog;
FormGeral.TableProtocolo.Open;
If FormGeral.TableProtocolo.RecordCount = 0 Then
  SeqProto := 1
Else
  Begin
  FormGeral.IBQueryAuxL1.Sql.Clear;
  FormGeral.IBQueryAuxL1.Sql.Add('SELECT MAX(SEQUENCIAL) FROM PROTOCOLO ');
  FormGeral.IBQueryAuxL1.Open;
  SeqProto := FormGeral.IBQueryAuxL1.Fields[0].AsInteger+1;
  FormGeral.IBQueryAuxL1.Close;
  End;
FormGeral.TableProtocolo.Close;
FormGeral.IBLogRemotoTransaction.Commit;

FormGeral.IniciaTransacaoLog;
FormGeral.TableLogProc.Open;
If FormGeral.TableLogProc.RecordCount = 0 Then
  SeqLog := 1
Else
  Begin
  FormGeral.IBQueryAuxL1.Sql.Clear;
  FormGeral.IBQueryAuxL1.Sql.Add('SELECT MAX(SEQUENCIAL) FROM LOGPROC ');
  FormGeral.IBQueryAuxL1.Open;
  SeqLog := FormGeral.IBQueryAuxL1.Fields[0].AsInteger+1;
  FormGeral.IBQueryAuxL1.Close;
  End;
FormGeral.TableLogProc.Close;
FormGeral.IBLogRemotoTransaction.Commit;
End;

Procedure TFormIndex.FormCreate(Sender: TObject);
Begin
If ParamCount <> 0 Then
  FormIndex.WindowState := wsMinimized;
With Arquivos Do
  Begin
  Cells[0,1] := 'Entrada ';
  Cells[0,2] := 'Saida   ';
  Cells[1,0] := 'Nome';
  Cells[2,0] := 'Tamanho';
  Cells[3,0] := 'Registros';
  End;
FormatSettings.DecimalSeparator := ','; // For�a o uso da v�rgula como separador decimal nas opera��es aritm�ticas ...
//Session.AddPassword(Senha);
End;

Procedure TFormIndex.AtuEst;

Var
  Porcento : Real;
  StrReal : TgStr255;
Begin
If Divisor <> 0 Then
  Porcento := (PosArq / Divisor) * 100.0
Else
  Porcento := 100.00;

If Porcento > 100.00 Then
  Porcento := 100.00;

Str(Porcento:5:2,StrReal);
Arquivos.Cells[3,1] := IntToStr(TotReg)+' '+StrReal+'%';
Arquivos.Cells[3,2] := IntToStr(TotReg);
Arquivos.Cells[2,2] := IntToStr(TotOut);

Application.ProcessMessages;
End;

//Procedure MoveDelete(Origem, Destino : AnsiString);
Procedure MoveDelete(Origem, Destino : String);
Var
  Erro : Integer;
Begin
DeleteFile(PChar(Destino));

If Not MoveFile(PChar(Origem), PChar(Destino)) Then
  begin
  Erro := GetLastError;
  FormGeral.InsereLog(Origem,'Erro '+ IntToStr(Erro) + ' na Fun��o MoveFile, arquivo n�o movido, verifique.',FormIndex.SeqLog,FormIndex.Agora);
  end;
End;

Function TFormIndex.PreparaInicioDeProcessamento;
Var
  Erro : Integer;
  Arq : TFileStream;
Begin
Result := False;
With Arquivos Do
  Begin
  Cells[1,1] := DirIn + TxtRec.Name;
  Cells[1,2] := viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT';
  Repaint;

  RichEdit1.Lines.Add('****');
  RichEdit1.Lines.Add('Iniciando o Processamento de :');
  RichEdit1.Lines.Add(Cells[1,1]);
  RichEdit1.Lines.Add('');
  PosicionaRichEdit;

  TotOut := 0;    { Acumula tamanho do arquivo de dados }
  TotReg := 0;
  PosArq := 0;
                         // A segunda parte come�a aqui
  Cells[2,1] := IntToStr(TxtRec.Size);

  Try
    CloseFile(ArqIn);
  Except
    End;

  AssignFile(ArqIn,Cells[1,1]);
  {$i-}
  Reset(ArqIn);
  {$i+}
  Erro := IoResult;

  If Erro <> 0 Then
    Begin
    Try
      CloseFile(ArqIn);
    Except
      End; // Try

    FormGeral.InsereLog(Cells[1,1],'Erro de Abertura. Codigo = '+IntToStr(Erro),SeqLog, Agora);
    MoveDelete(Arquivos.Cells[1,1],viDirTrabApl+'NaoProcessados\'+ExtractFileName(Cells[1,1]));
    Exit;
    End;
  CloseFile(ArqIn);

  Arq := TFileStream.Create(Cells[1,1], fmOpenRead Or fmShareDenyNone);

//  Divisor := TxtRec.Size;
  Divisor := Arq.Size;
  Arq.Free;
  
  If Divisor = 0 Then
    Begin
    Try
      CloseFile(ArqIn);
    Except
      End; // Try

    FormGeral.InsereLog(Cells[1,1],'Arquivo Zerado',SeqLog, Agora);
    MoveDelete(Arquivos.Cells[1,1],viDirTrabApl+'NaoProcessados\'+ExtractFileName(Cells[1,1]));
    Exit;
    End;

  Result := True;
  End;
Application.ProcessMessages;
End;

Procedure TFormIndex.PreparaFusao;
Begin
If FileExists(IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
              FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT') Then
  Begin
  Fusao := True;  // Um arquivo j� foi processado, vai fundir os dados via um balance line
  AssignFile(ArqIndiceContaAntigo, IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
             FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTA.IND');
  Reset(ArqIndiceContaAntigo);
//  AssignFile(ArqDatAntigo,IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
//             FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT');
//  Reset(arqDatAntigo,1);
  ArqDatAntigo := TFileStream.Create(IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
             FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT', fmOpenRead Or fmShareDenyNone);
  End
Else
  Fusao := False;

AssignFile(ArqIndiceConta, viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString +
           'CONTA.IND');
ReWrite(ArqIndiceConta);

BufSaida := Nil;
BufCmp := Nil;
BufDatAntigo := Nil;
BufOutAntigo := Nil;
TamBufOut := 0;
End;

Function IndiceDesbalanceado(Ano, Mes : Integer) : Boolean;
Var
  ContaAnt : TgIndiceI64F;
  Ciclo : SetOfNum;
Begin
Result := False;

Try
  Reset(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd);
Except
  Exit;
  End; //Except;

SortMem.TamArr := FileSize(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd);
ContaAnt.Valor := 0;
Ciclo := [];

FormIndex.RichEdit1.Lines.Add('Verificando Indice '+IntToStr(Ano)+' '+IntToStr(Mes));
FormIndex.PosicionaRichEdit;

While Not Eof(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd) Do
  Begin
  Read(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd, IndiceConta);
  If (IndiceConta.Valor < ContaAnt.Valor) Or
     ((IndiceConta.Valor = ContaAnt.Valor) And (Byte(IndiceConta.TipoConta) In Ciclo)) Then
    Begin
//    ShowMessage('Anterior: '+IntToStr(ContaAnt.Valor));
//    ShowMessage('Atual: '+IntToStr(IndiceConta.Valor));
//    ShowMessage('Ciclo Anterior: '+IntToStr(Byte(ContaAnt.TipoConta)));
//    ShowMessage('Ciclo Atual: '+IntToStr(Byte(IndiceConta.TipoConta)));
//    ShowMessage('Total de Registros no �ndice: '+IntToStr(FileSize(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd)));
//    ShowMessage('Registro Assincr�nico: '+IntToStr(FilePos(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd)));
    Result := True;
    Break;
    End;
  If (IndiceConta.Valor > ContaAnt.Valor) Then
    Ciclo := [];
  Ciclo := Ciclo + [Byte(IndiceConta.TipoConta)];
  ContaAnt := IndiceConta;
  End;
CloseFile(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd);
End;

{Function TFormIndex.IndiceDesbalanceadoCeA(Ano, Mes : Integer) : Boolean;
Var
  ContaAnt : TgIndiceNumCnt;
Begin
Result := False;

Try
  Reset(ArrArqMovs[Ano,Mes].ArqInd);
Except
  Exit;
  End; //Except;

SetLength(SortMem.ArIndNumCnt, FileSize(ArrArqMovs[Ano, Mes].ArqInd));
ContaAnt.Conta := 0;
ContaAnt.Ciclo := 0;

FormIndex.RichEdit1.Lines.Add('Verificando Indice '+IntToStr(Ano)+' '+IntToStr(Mes));
FormIndex.PosicionaRichEdit;

While Not Eof(ArrArqMovs[Ano, Mes].ArqInd) Do
  Begin
  Read(ArrArqMovs[Ano, Mes].ArqInd, RegIndiceNumCnt);
  If (RegIndiceNumCnt.Conta < ContaAnt.Conta) Or
     ((RegIndiceNumCnt.Conta = ContaAnt.Conta) And (RegIndiceNumCnt.Ciclo <= ContaAnt.Ciclo)) Then
    Begin
//    ShowMessage('Anterior: '+IntToStr(ContaAnt.Valor));
//    ShowMessage('Atual: '+IntToStr(IndiceConta.Valor));
//    ShowMessage('Ciclo Anterior: '+IntToStr(Byte(ContaAnt.TipoConta)));
//    ShowMessage('Ciclo Atual: '+IntToStr(Byte(IndiceConta.TipoConta)));
//    ShowMessage('Total de Registros no �ndice: '+IntToStr(FileSize(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd)));
//    ShowMessage('Registro Assincr�nico: '+IntToStr(FilePos(FormIndex.ArrExtrDetexArq[Ano,Mes].ArqInd)));
    Result := True;
    Break;
    End;
  ContaAnt := RegIndiceNumCnt;
  End;
CloseFile(ArrArqMovs[Ano, Mes].ArqInd);
End;     }

Function TFormIndex.ProcessaUnsrExtr;
Var
  Ano,
  Mes,
  TamReg : Integer;
  AuxLer : AnsiString;
  ArqUnsrExtr : System.Text;
  RegUnsrExtr : TgUnsrExtr;

Begin
PreparaInicioDeProcessamento;

Try
//  CloseFile(ArqOut);
  ArqOut.Free;
Except
  End;

AssignFile(ArqUnsrExtr,Arquivos.Cells[1,1]);
Reset(ArqUnsrExtr);

// Era aqui a prepara��o...

Ano := 0; // Inicializadas por causa da warning do compilador...
Mes := 0;
RegUnsrExtr.CrLf := #13#10;
If UnsrExtrBmg Then
  TamReg := (SizeOf(TgUnsrExtrBmg)-2)
Else
  TamReg := (SizeOf(RegUnsrExtr)-2);
While Not Eof(ArqUnsrExtr) Do
  Begin
  ReadLn(ArqUnsrExtr,AuxLer);

  If Length(AuxLer) <> TamReg Then
    Begin
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Tam Reg do Extr inv�lido: '+IntToStr(Length(AuxLer)),SeqLog, Agora);
    Application.Terminate;
    End;

  If UnsrExtrBmg Then
    Begin
    If (Copy(AuxLer,1,3) <> '030') Then
      Begin
      RegUnsrExtr.Org := '103';
      RegUnsrExtr.Logo := '000';
      End
    else
      Begin
      RegUnsrExtr.Org[1] := AuxLer[3];
      RegUnsrExtr.Org[2] := AuxLer[4];
      RegUnsrExtr.Org[3] := AuxLer[5];
      RegUnsrExtr.Logo[1] := AuxLer[9];
      RegUnsrExtr.Logo[2] := AuxLer[10];
      RegUnsrExtr.Logo[3] := AuxLer[11];
      End;
    Move(AuxLer[12],RegUnsrExtr.Conta,SizeOf(RegUnsrExtr)-2-6);   //CrLf+Come�o+Fim
    End
  else
    Move(AuxLer[1],RegUnsrExtr,SizeOf(RegUnsrExtr)-2);

  BufSaida := @RegUnsrExtr;
//  CompressBuf(BufSaida,SizeOf(RegUnsrExtr)-2,BufCmp,NBytesOut);
  ZCompress(BufSaida,SizeOf(RegUnsrExtr)-2,BufCmp,NBytesOut);

  Try
    Ano := StrToInt(Copy(RegUnsrExtr.AnoMes,1,4));
  Except
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Ano do Extr inv�lido: '+Copy(RegUnsrExtr.AnoMes,1,4),SeqLog, Agora);
    Application.Terminate;
    End; // Try
  If (Ano < 1990) Or (Ano > 2050) Then
    Begin
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Ano do Extr Fora do esperado: '+Copy(RegUnsrExtr.AnoMes,1,4),SeqLog, Agora);
    Application.Terminate;
    End;

  Try
    Mes := StrToInt(Copy(RegUnsrExtr.AnoMes,5,2));
  Except
    FormGeral.InsereLog(Arquivos.Cells[1,1],'M�s do Extr inv�lido: '+Copy(RegUnsrExtr.AnoMes,5,2),SeqLog, Agora);
    Application.Terminate;
    End; // Try
  If (Mes < 1) Or (Mes > 12) Then
    Begin
    FormGeral.InsereLog(Arquivos.Cells[1,1],'M�s do Extr Fora do esperado: '+Copy(RegUnsrExtr.AnoMes,5,2),SeqLog, Agora);
    Application.Terminate;
    End;

  IndiceConta.Valor := StrToInt64(Trim(RegUnsrExtr.Conta));
  IndiceConta.TipoConta[1] := AnsiChar(Byte(StrToInt(Trim(RegUnsrExtr.Ciclo))));
  ArrExtrDetexArq[Ano,Mes].Processou := True;

  Try
    IndiceConta.PosIni := FilePos(ArrExtrDetexArq[Ano,Mes].ArqOut);
  Except
    Try

      Reset(ArrExtrDetexArq[Ano,Mes].ArqOut,1);
      Seek(ArrExtrDetexArq[Ano,Mes].ArqOut, FileSize(ArrExtrDetexArq[Ano,Mes].ArqOut));

      IndiceConta.PosIni := FilePos(ArrExtrDetexArq[Ano,Mes].ArqOut);
    Except
      Try
        ForceDirectories(IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
          'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\');  // Cria o diret�rio de destino, se j� n�o existe...
        ReWrite(ArrExtrDetexArq[Ano,Mes].ArqOut,1);
        IndiceConta.PosIni := FilePos(ArrExtrDetexArq[Ano,Mes].ArqOut);
      Except
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Estourou a capacidade de abrir arquivos simult�neos I',SeqLog, Agora);
        Application.Terminate;
        End; // Try
      End; // Try
    End; // Try
  IndiceConta.Tam := NBytesOut;
  Inc(TotOut,NBytesOut);

  BlockWrite(ArrExtrDetexArq[Ano,Mes].ArqOut,BufCmp^,IndiceConta.Tam,Resultado);
  Try
    Write(ArrExtrDetexArq[Ano,Mes].ArqInd, IndiceConta);
  Except
    Try
      Reset(ArrExtrDetexArq[Ano,Mes].ArqInd);
      Seek(ArrExtrDetexArq[Ano,Mes].ArqInd, FileSize(ArrExtrDetexArq[Ano,Mes].ArqInd));
      Write(ArrExtrDetexArq[Ano,Mes].ArqInd, IndiceConta);
    Except
      Try
        ForceDirectories(IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
          'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\');  // Cria o diret�rio de destino, se j� n�o existe...
        ReWrite(ArrExtrDetexArq[Ano,Mes].ArqInd);
        Write(ArrExtrDetexArq[Ano,Mes].ArqInd, IndiceConta);
      Except
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Estourou a capacidade de abrir arquivos simult�neos II',SeqLog, Agora);
        Application.Terminate;
        End; // Try
      End; // Try
    End; // Try
  ReallocMem(BufCmp,0);

  Inc(PosArq,SizeOf(RegUnsrExtr));
  Inc(TotReg);

  If (TotReg Mod QueBraMod) = 0 Then
    Begin
    AtuEst;
    If TotReg > 9000 Then
      QuebraMod := 10000
    Else
    If TotReg > 900 Then
      QuebraMod := 1000
    Else
    If TotReg > 90 Then
      QuebraMod := 100;
    End;

  End;

CloseFile(ArqUnsrExtr);

For Ano := 1990 to 2050 Do
  For Mes := 1 to 12 Do
    Begin
    Try
      CloseFile(ArrExtrDetexArq[Ano,Mes].ArqOut);
    Except
      End; // Try
    Try
      CloseFile(ArrExtrDetexArq[Ano,Mes].ArqInd);
    Except
      End; // Try
    End;

Arquivos.Cells[3,2] := Arquivos.Cells[3,2] + ' 100.00%';
Arquivos.Repaint;

AvisoP.Close;
AtuEst;
Result := True;
End;

Function TFormIndex.ProcessaUnsrContVP;     // +2gb dat files     20/10/2022 By Romero
Var
  ArqUnsrCont : File Of TgUnsrContVP;
  RegUnsrCont : TgUnsrContVP;
  ArqUnsrContBmg : File Of TgUnsrContBmg;
  RegUnsrContBmg : TgUnsrContBmg;
  Retorno : Byte;
  IndAnt : Int64;
  FimDeArquivo,
  SalvarDados : Boolean;

  Procedure MoveRegistroContaAntigo;
  Begin
//  Seek(ArqDatAntigo,IndiceContaAntigo.PosIni);
  ArqDatAntigo.Seek(IndiceContaAntigo.PosIni, soFromBeginning);

  ReallocMem(BufDatAntigo,IndiceContaAntigo.Tam);
//  BlockRead(ArqDatAntigo,BufDatAntigo^,IndiceContaAntigo.Tam,Resultado);
  ArqDatAntigo.Read(BufDatAntigo^,IndiceContaAntigo.Tam);

    // Update new dat position and fire the bomb
//  IndiceContaAntigo.PosIni := FilePos(ArqOut);
  IndiceContaAntigo.PosIni := ArqOut.Position;
  Inc(TotOut,IndiceContaAntigo.Tam);
//  BlockWrite(ArqOut,BufDatAntigo^,IndiceContaAntigo.Tam,Resultado);
  ArqOut.Write(BufDatAntigo^,IndiceContaAntigo.Tam);
  Write(ArqIndiceConta, IndiceContaAntigo);

  IndiceContaEmpresaAntigo.PosIni := IndiceContaAntigo.PosIni;
  Write(ArqIndiceContaEmpresa, IndiceContaEmpresaAntigo);

  IndiceCpfCgcAntigo.PosIni := IndiceContaAntigo.PosIni;
  Write(ArqIndiceCpfCgc, IndiceCpfCgcAntigo);
  End;

  Procedure LeAntigo;
  Begin
  Repeat
    Posic := FilePos(ArqIndiceContaAntigo);
    Read(ArqIndiceContaAntigo,IndiceContaAntigo);
    Read(ArqIndiceContaEmpresaAntigo,IndiceContaEmpresaAntigo);
    Read(ArqIndiceCpfCgcAntigo,IndiceCpfCgcAntigo);
    AuxConta := StrToInt64(Trim(RegUnsrCont.Conta)); // Salva para evitar de converter duas vezes...
    If IndiceContaAntigo.Valor = AuxConta Then  // Neste caso s� h� um registro por conta, ent�o o novo vai substituir este...
      Begin
      If UpperCase(FormGeral.TableDFN.FieldByName('Atualiza').AsString) <> 'S' Then // N�o atualiza os dados
        Begin
        SalvarDados := False;
        Break;
        End;
      End
    Else
    If IndiceContaAntigo.Valor < AuxConta Then // Salva os dados da conta antiga
      Begin
      MoveRegistroContaAntigo;
      End
    Else
      Begin
      Seek(ArqIndiceContaAntigo,Posic);  // Salva a posi��o para compara��o futura...
      Seek(ArqIndiceContaEmpresaAntigo,Posic);  // Salva a posi��o para compara��o futura...
      Seek(ArqIndiceCpfCgcAntigo,Posic);  // Salva a posi��o para compara��o futura...
      Break;
      End;
  Until Eof(ArqIndiceContaAntigo);
  End;

Begin
PreparaInicioDeProcessamento;
PreparaFusao;

Try
//  CloseFile(ArqOut);
  ArqOut.Free;
Except
  End;

AssignFile(ArqIndiceContaEmpresa, viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString +
           'CONTAEMPRESA.ORI');
ReWrite(ArqIndiceContaEmpresa);
AssignFile(ArqIndiceCpfCgc, viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString +
           'CPFCGC.ORI');
ReWrite(ArqIndiceCpfCgc);

If Fusao Then
  Begin
  AssignFile(ArqIndiceContaEmpresaAntigo, IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) +
             CodAlfa + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTAEMPRESA.ORI');
  Reset(ArqIndiceContaEmpresaAntigo);
  AssignFile(ArqIndiceCpfCgcAntigo, IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) +
             CodAlfa + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CPFCGC.ORI');
  Reset(ArqIndiceCpfCgcAntigo);
  End;

//AssignFile(ArqOut,Arquivos.Cells[1,2]);
//ReWrite(ArqOut,1);
ArqOut := TFileStream.Create(Arquivos.Cells[1,2], fmCreate);

AssignFile(ArqUnsrContBmg,Arquivos.Cells[1,1]);
Reset(ArqUnsrContBmg);

IndAnt := 0;
SalvarDados := True;

FimDeArquivo := Eof(ArqUnsrContBmg);

While Not FimDeArquivo Do
  Begin
  Begin
  Read(ArqUnsrContBmg,RegUnsrContBmg);
  FimDeArquivo := Eof(ArqUnsrContBmg);

  If RegUnsrContBmg.Corp <> '001' Then
    Begin
    RegUnsrCont.Org := '103';
    RegUnsrCont.Logo := '000';
    End
  else
    Begin
    RegUnsrCont.Org := RegUnsrContBmg.Corp;
    RegUnsrCont.Logo := RegUnsrContBmg.Produto;
    End;

  Move(RegUnsrContBmg.Conta, RegUnsrCont.Conta, 314);

  RegUnsrCont.CodBloqueioUm[1] := RegUnsrContBmg.CodBloqueioUm[1];
  RegUnsrCont.DtBloqueioUm := RegUnsrContBmg.DtBloqueioUm;
  RegUnsrCont.CodBloqueioDois := RegUnsrContBmg.CodBloqueioDois;
  RegUnsrCont.DtBloqueioDois := RegUnsrContBmg.DtBloqueioDois;
  End;

  BufSaida := @RegUnsrCont;
//  CompressBuf(BufSaida,SizeOf(RegUnsrCont)-2,BufCmp,NBytesOut);
  ZCompress(BufSaida,SizeOf(RegUnsrCont)-2,BufCmp,NBytesOut);

  IndiceConta.Valor := StrToInt64(Trim(RegUnsrCont.Conta));
  If IndiceConta.Valor < IndAnt Then
    Begin
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Assincronia: '+IntToStr(IndiceConta.Valor)+' '+IntToStr(IndAnt),SeqLog, Agora);
    RichEdit1.Lines.Add('Assincronia: '+IntToStr(IndiceConta.Valor)+' '+IntToStr(IndAnt));
    Application.Terminate;
    End;
  IndAnt := IndiceConta.Valor;

  If Fusao And (Not Eof(ArqIndiceContaAntigo)) Then
    LeAntigo;

  IndiceConta.PosIni := ArqOut.Position;
  IndiceConta.TipoConta := RegUnsrCont.TipoConta;
  IndiceConta.Tam := NBytesOut;
  Inc(TotOut,NBytesOut);

  IndiceContaEmpresa.Valor := StrToInt64(Trim(RegUnsrCont.ContaEmpres));
  IndiceContaEmpresa.PosIni := IndiceConta.PosIni;
  IndiceContaEmpresa.TipoConta := RegUnsrCont.TipoConta;
  IndiceContaEmpresa.Tam := IndiceConta.Tam;

  IndiceCpfCgc.Valor := StrToInt64(Trim(RegUnsrCont.CpfCgc));
  IndiceCpfCgc.PosIni := IndiceConta.PosIni;
  IndiceCpfCgc.TipoConta := RegUnsrCont.TipoConta;
  IndiceCpfCgc.Tam := IndiceConta.Tam;

  If SalvarDados Then
    Begin
//    BlockWrite(ArqOut,BufCmp^,IndiceConta.Tam,Resultado);
    ArqOut.Write(BufCmp^,IndiceConta.Tam);
    Write(ArqIndiceConta, IndiceConta);
    Write(ArqIndiceContaEmpresa, IndiceContaEmpresa);
    Write(ArqIndiceCpfCgc, IndiceCpfCgc);
    End;

  SalvarDados := True;

  ReallocMem(BufCmp,0);

  Inc(PosArq,SizeOf(RegUnsrCont));
  Inc(TotReg);
  If (TotReg Mod QueBraMod) = 0 Then
    Begin
    AtuEst;
    If TotReg > 9000 Then
      QuebraMod := 10000
    Else
    If TotReg > 900 Then
      QuebraMod := 1000
    Else
    If TotReg > 90 Then
      QuebraMod := 100;
    End;
  End;

RegUnsrCont.Conta := '9999999999999999'; // For�ar a descarga de eventuais registros antigos que ainda sobraram

If Fusao Then
  Begin
  If (Not Eof(ArqIndiceContaAntigo)) Then
    LeAntigo; // Descarrega eventuais registros antigos ainda restantes...
  CloseFile(ArqIndiceContaAntigo);
//  CloseFile(ArqDatAntigo);
  ArqDatAntigo.Free;

  CloseFile(ArqIndiceContaEmpresaAntigo);
  CloseFile(ArqIndiceCpfCgcAntigo);
  If BufDatAntigo <> Nil Then
    ReallocMem(BufDatAntigo,0);
  If BufOutAntigo <> Nil Then
    ReallocMem(BufOutAntigo,0);
  End;
CloseFile(ArqIndiceConta);
CloseFile(ArqUnsrContBmg);
//CloseFile(ArqOut);
ArqOut.Free;
CloseFile(ArqIndiceContaEmpresa);
CloseFile(ArqIndiceCpfCgc);

AvisoP.Label1.Caption := 'Indexando ContaEmpresa';
AvisoP.Show;
AvisoP.RePaint;
NomeArqIndice := viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTAEMPRESA.ORI';
TsSort := TSort.Create;
Retorno := TsSort.TurboSort(SizeOf(IndiceContaEmpresa),StrToInt(viNBufIO));
If Retorno <> 0 Then
  FormGeral.InsereLog('ContaEmpresa','Erro no sort do �ndice...',SeqLog, Agora);
TsSort.Free;

AvisoP.Label1.Caption := 'Indexando CpfCgc';
AvisoP.Show;
AvisoP.RePaint;
NomeArqIndice := viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CPFCGC.ORI';
TsSort := TSort.Create;
Retorno := TsSort.TurboSort(SizeOf(IndiceCpfCgc),StrToInt(viNBufIO));
If Retorno <> 0 Then
  FormGeral.InsereLog('CgcCpf','Erro no sort do �ndice...',SeqLog, Agora);
TsSort.Free;

Arquivos.Cells[3,2] := Arquivos.Cells[3,2] + ' 100.00%';
Arquivos.Repaint;

AvisoP.Close;
AtuEst;
Result := True;
End;

Function TFormIndex.ProcessaUnsrCartVP;
Var
//  ArqUnsrCart : File Of TgUnsrCartVP;
  ArqUnsrCart : System.Text;
  RegUnsrCart,
  RegAuxUnsrCart : TgUnsrCartVP;
  I,
  ICart : Integer;
  JaTem,
  SalvarDados : Boolean;
  AuxLer,
  CartConta : AnsiString;
  Retorno : Byte;

  Procedure LeAntigo;

    Procedure MoveDadosCartaoAntigo;
    Begin
//      Seek(ArqDatAntigo,IndiceContaAntigo.PosIni);
      ArqDatAntigo.Seek(IndiceContaAntigo.PosIni, soFromBeginning);

      ReallocMem(BufDatAntigo,IndiceContaAntigo.Tam);
//      BlockRead(ArqDatAntigo,BufDatAntigo^,IndiceContaAntigo.Tam,Resultado);
      ArqDatAntigo.Read(BufDatAntigo^,IndiceContaAntigo.Tam);

      IndiceConta.Valor := IndiceContaAntigo.Valor;
//      IndiceConta.PosIni := FilePos(ArqOut);
      IndiceConta.PosIni := ArqOut.Position;

      IndiceConta.Tam := IndiceContaAntigo.Tam;
      IndiceConta.TipoConta := IndiceContaAntigo.TipoConta;
      IndiceCartao.PosIni := IndiceConta.PosIni;
      IndiceCartao.Tam := IndiceConta.Tam;
      IndiceCartao.TipoConta := IndiceConta.TipoConta;
      IndiceNomeCartao.PosIni := IndiceConta.PosIni;
      IndiceNomeCartao.Tam := IndiceConta.Tam;
      IndiceNomeCartao.TipoConta := IndiceConta.TipoConta;
      While (IndiceCartaoAntigo.PosIni < IndiceContaAntigo.PosIni) And
            (Not Eof(ArqIndiceCartaoAntigo)) Do
        Read(ArqIndiceCartaoAntigo, IndiceCartaoAntigo);
      If IndiceCartaoAntigo.PosIni <> IndiceContaAntigo.PosIni Then
        Begin
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Assincronia no �ndice cartao.ori',SeqLog, Agora);
        Application.Terminate;
        End;
      While (IndiceNomeCartaoAntigo.PosIni < IndiceContaAntigo.PosIni) And
            (Not Eof(ArqIndiceNomeCartaoAntigo)) Do
        Read(ArqIndiceNomeCartaoAntigo, IndiceNomeCartaoAntigo);
      If IndiceNomeCartaoAntigo.PosIni <> IndiceContaAntigo.PosIni Then
        Begin
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Assincronia no �ndice nomecartao.ori',SeqLog, Agora);
        Application.Terminate;
        End;
      While (IndiceCartaoAntigo.PosIni = IndiceContaAntigo.PosIni) And
            (Not Eof(ArqIndiceCartaoAntigo)) Do
        Begin
        IndiceCartao.Valor := IndiceCartaoAntigo.Valor;
        Write(ArqIndiceCartao, IndiceCartao);
        Read(ArqIndiceCartaoAntigo, IndiceCartaoAntigo);
        End;
      If (Eof(ArqIndiceCartaoAntigo)) And (IndiceCartaoAntigo.PosIni = IndiceContaAntigo.PosIni) Then
        Begin
        IndiceCartao.Valor := IndiceCartaoAntigo.Valor; // Trata �ltimo registro do arquivo antigo
        Write(ArqIndiceCartao, IndiceCartao);
        End;
      While (IndiceNomeCartaoAntigo.PosIni = IndiceContaAntigo.PosIni) And
            (Not Eof(ArqIndiceNomeCartaoAntigo)) Do
        Begin
        IndiceNomeCartao.Valor := IndiceNomeCartaoAntigo.Valor;
        Write(ArqIndiceNomeCartao, IndiceNomeCartao);
        Read(ArqIndiceNomeCartaoAntigo, IndiceNomeCartaoAntigo);
        End;
      If (Eof(ArqIndiceNomeCartaoAntigo)) And (IndiceNomeCartaoAntigo.PosIni = IndiceContaAntigo.PosIni) Then
        Begin                            // Trata �ltimo registro do arquivo antigo
        IndiceNomeCartao.Valor := IndiceNomeCartaoAntigo.Valor;
        Write(ArqIndiceNomeCartao, IndiceNomeCartao);
        End;
      Inc(TotOut,IndiceContaAntigo.Tam);
//      BlockWrite(ArqOut,BufDatAntigo^,IndiceContaAntigo.Tam,Resultado);
      ArqOut.Write(BufDatAntigo^,IndiceContaAntigo.Tam);

      Write(ArqIndiceConta, IndiceConta);
    End;

  Begin
  Repeat
    Posic := FilePos(ArqIndiceContaAntigo);
    Read(ArqIndiceContaAntigo,IndiceContaAntigo);
    AuxConta := StrToInt64(Trim(RegUnsrCart.Conta)); // Salva para evitar de converter duas vezes...
    If IndiceContaAntigo.Valor = AuxConta Then       // Carrega os valores antigos e continua...
      Begin
      If UpperCase(FormGeral.TableDFN.FieldByName('Atualiza').AsString) <> 'S' Then // N�o atualiza os dados
        Begin
        MoveDadosCartaoAntigo;
        SalvarDados := False;
        End
      Else
        Begin      // Caso contr�rio l� o registro antigo para os novos dados atualizar.
//        Seek(ArqDatAntigo,IndiceContaAntigo.PosIni);
        ArqDatAntigo.Seek(IndiceContaAntigo.PosIni, soFromBeginning);

        ReallocMem(BufDatAntigo,IndiceContaAntigo.Tam);
//        BlockRead(ArqDatAntigo,BufDatAntigo^,IndiceContaAntigo.Tam,Resultado);
        ArqDatAntigo.Read(BufDatAntigo^,IndiceContaAntigo.Tam);

        ReallocMem(BufOutAntigo,0);
//        DecompressBuf(BufDatAntigo,IndiceContaAntigo.Tam,0,BufOutAntigo,NBytesOut);
        ZDecompress(BufDatAntigo,IndiceContaAntigo.Tam,BufOutAntigo,NBytesOut,0);
        Move(BufOutAntigo^,CartConta[1],NBytesOut);
        Inc(ICart,(NBytesOut Div SizeOf(RegUnsrCart)));
        Inc(TamBufOut,NBytesOut);
        End;
      End
    Else
    If IndiceContaAntigo.Valor < AuxConta Then // Salva os dados da conta antiga
      Begin
      MoveDadosCartaoAntigo;
      End
    Else
      Begin
      Seek(ArqIndiceContaAntigo,Posic);  // Salva a posi��o para compara��o futura...
      Break;
      End;
  Until Eof(ArqIndiceContaAntigo);
  End;

  Procedure Descarrega;
  Var
    IAux : Integer;
  Begin       // Procedimentos de descarga...
  If Not SalvarDados Then
    Begin
    SalvarDados := True;
    Exit;
    End;
  BufSaida := @CartConta[1];
//  CompressBuf(BufSaida,TamBufOut,BufCmp,NBytesOut);
  ZCompress(BufSaida,TamBufOut,BufCmp,NBytesOut);

  IndiceConta.Valor := StrToInt64(Trim(ContaAnt));
//  IndiceConta.PosIni := FilePos(ArqOut);
  IndiceConta.PosIni := ArqOut.Position;

  IndiceConta.TipoConta := RegAuxUnsrCart.TipoConta;
  IndiceConta.Tam := NBytesOut;
  IndiceCartao.PosIni := IndiceConta.PosIni;
  IndiceCartao.TipoConta := RegAuxUnsrCart.TipoConta;
  IndiceCartao.Tam := IndiceConta.Tam;
  IndiceNomeCartao.PosIni := IndiceConta.PosIni;
  IndiceNomeCartao.TipoConta := RegAuxUnsrCart.TipoConta;
  IndiceNomeCartao.Tam := IndiceConta.Tam;
  For IAux := 1 To TamBufOut div SizeOf(RegAuxUnsrCart) Do
    Begin                      // Todos os cart�es s�o de uma �nica conta...
    Move(CartConta[(IAux-1)*SizeOf(RegAuxUnsrCart)+1],RegAuxUnsrCart,SizeOf(RegAuxUnsrCart));
    IndiceCartao.Valor := StrToInt64(RegAuxUnsrCart.Cartao);
    Write(ArqIndiceCartao, IndiceCartao);
    IndiceNomeCartao.Valor := RegAuxUnsrCart.NomeCartao;
    Write(ArqIndiceNomeCartao, IndiceNomeCartao);
    End;
  Inc(TotOut,NBytesOut);
//  BlockWrite(ArqOut,BufCmp^,IndiceConta.Tam,Resultado);
  ArqOut.Write(BufCmp^,IndiceConta.Tam);

  Write(ArqIndiceConta, IndiceConta);
  ReallocMem(BufCmp,0);

  TamBufOut := 0;
  ContaAnt := RegUnsrCart.Conta;
  ICart := 0;
  End;

Begin
PreparaInicioDeProcessamento;
PreparaFusao;

Try
//  CloseFile(ArqOut);
  ArqOut.Free;
Except
  End;

//AssignFile(ArqOut,Arquivos.Cells[1,2]);
//ReWrite(ArqOut,1);
ArqOut := TFileStream.Create(Arquivos.Cells[1,2], fmCreate);

AssignFile(ArqUnsrCart,Arquivos.Cells[1,1]);
Reset(ArqUnsrCart);

AssignFile(ArqIndiceCartao, viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString +
           'CARTAO.ORI');
ReWrite(ArqIndiceCartao);
AssignFile(ArqIndiceNomeCartao, viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString +
           'NOMECARTAO.ORI');
ReWrite(ArqIndiceNomeCartao);

If Fusao Then
  Begin
  AssignFile(ArqIndiceCartaoAntigo, IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) +
             CodAlfa + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CARTAO.ORI');
  Reset(ArqIndiceCartaoAntigo);
  AssignFile(ArqIndiceNomeCartaoAntigo, IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) +
             CodAlfa + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'NOMECARTAO.ORI');
  Reset(ArqIndiceNomeCartaoAntigo);
  IndiceCartaoAntigo.PosIni := -1; // Initialize to force the seek reading of the index
  IndiceNomeCartaoAntigo.PosIni := -1;
  End;

//Read(ArqUnsrCart,RegUnsrCart);
ReadLn(ArqUnsrCart,AuxLer);
If UnsrCartBmg Then
  Begin
  If Copy(AuxLer,1,3) <> '030' Then
    Begin
    RegUnsrCart.Org := '103';
    RegUnsrCart.Logo := '000';
    End
  else
    Begin
    RegUnsrCart.Org[1] := AuxLer[3];
    RegUnsrCart.Org[2] := AuxLer[4];
    RegUnsrCart.Org[3] := AuxLer[5];
    RegUnsrCart.Logo[1] := AuxLer[9];
    RegUnsrCart.Logo[2] := AuxLer[10];
    RegUnsrCart.Logo[3] := AuxLer[11];
    End;
  Move(AuxLer[12], RegUnsrCart.Cartao, SizeOf(RegUnsrCart)-2-6-10+1); //CrLf+Come�o+Fim
  RegUnsrCart.CodBloqueio[1] := AuxLer[82];
  Move(AuxLer[84], RegUnsrCart.DtBloqueio, 8);
  RegUnsrCart.CrLf := #13#10;
  End
Else
  Begin
  Move(AuxLer[1], RegUnsrCart, SizeOf(RegUnsrCart)-2);
  End;
ContaAnt := RegUnsrCart.Conta;
CloseFile(ArqUnsrCart);
Reset(ArqUnsrCart);
ICart := 0;
SalvarDados := True;

SetLength(CartConta,10000*SizeOf(TgUnsrCartVP));
If Fusao And (Not Eof(ArqIndiceContaAntigo)) Then
  LeAntigo;

While Not Eof(ArqUnsrCart) Do
  Begin
//  Read(ArqUnsrCart,RegUnsrCart);
  ReadLn(ArqUnsrCart,AuxLer);
  If UnsrCartBmg Then
    Begin
    If Copy(AuxLer,1,3) <> '030' Then
      Begin
      RegUnsrCart.Org := '103';
      RegUnsrCart.Logo := '000';
      End
    else
      Begin
      RegUnsrCart.Org[1] := AuxLer[3];
      RegUnsrCart.Org[2] := AuxLer[4];
      RegUnsrCart.Org[3] := AuxLer[5];
      RegUnsrCart.Logo[1] := AuxLer[9];
      RegUnsrCart.Logo[2] := AuxLer[10];
      RegUnsrCart.Logo[3] := AuxLer[11];
      End;
    Move(AuxLer[12], RegUnsrCart.Cartao, SizeOf(RegUnsrCart)-2-6-10+1); //CrLf+Come�o+Fim
    RegUnsrCart.CodBloqueio[1] := AuxLer[82];
    Move(AuxLer[84], RegUnsrCart.DtBloqueio, 8);
    RegUnsrCart.CrLf := #13#10;
    End
  Else
    Begin
    Move(AuxLer[1], RegUnsrCart, SizeOf(RegUnsrCart)-2);
    End;

  If RegUnsrCart.Conta < ContaAnt Then
    Begin
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Assincronia: '+RegUnsrCart.Conta+' '+ContaAnt,SeqLog, Agora);
    RichEdit1.Lines.Add('Assincronia: '+RegUnsrCart.Conta+' '+ContaAnt);
    Application.Terminate;
    End;

  If RegUnsrCart.Conta <> ContaAnt Then
    Begin
    Descarrega;
    If Fusao And (Not Eof(ArqIndiceContaAntigo)) Then
      LeAntigo;
    End;

  JaTem := False;
  For I := 1 To ICart Do
    Begin
    Move(CartConta[(I-1)*SizeOf(RegAuxUnsrCart)+1],RegAuxUnsrCart,SizeOf(RegAuxUnsrCart));
    If (RegUnsrCart.Org = RegAuxUnsrCart.Org) And
       (RegUnsrCart.Logo = RegAuxUnsrCart.Logo) And
       (RegUnsrCart.Cartao = RegAuxUnsrCart.Cartao) Then
      Begin
      Move(RegUnsrCart,CartConta[(I-1)*SizeOf(RegAuxUnsrCart)+1],SizeOf(RegAuxUnsrCart));
      JaTem := True;
      Break;
      End;
    End;
  If Not JaTem Then
    Begin
    Inc(ICart);
    Move(RegUnsrCart,CartConta[(ICart-1)*SizeOf(RegAuxUnsrCart)+1],SizeOf(RegAuxUnsrCart));
    Inc(TamBufOut,SizeOf(RegUnsrCart));
    End;

  Inc(PosArq,SizeOf(RegUnsrCart));
  Inc(TotReg);

  If (TotReg Mod QueBraMod) = 0 Then
    Begin
    AtuEst;
    If TotReg > 9000 Then
      QuebraMod := 10000
    Else
    If TotReg > 900 Then
      QuebraMod := 1000
    Else
    If TotReg > 90 Then
      QuebraMod := 100;
    End;

  End;

Descarrega; // Grava o �ltimo
RegUnsrCart.Conta := '9999999999999999'; // For�ar a descarga de eventuais registros antigos que ainda sobraram

If Fusao Then
  Begin
  If (Not Eof(ArqIndiceContaAntigo)) Then
    LeAntigo; // Descarrega eventuais registros antigos ainda restantes...
  CloseFile(ArqIndiceContaAntigo);
//  CloseFile(ArqDatAntigo);
  ArqDatAntigo.Free;

  CloseFile(ArqIndiceCartaoAntigo);
  CloseFile(ArqIndiceNomeCartaoAntigo);
  If BufDatAntigo <> Nil Then
    ReallocMem(BufDatAntigo,0);
  If BufOutAntigo <> Nil Then
    ReallocMem(BufOutAntigo,0);
  End;

CloseFile(ArqIndiceConta);
CloseFile(ArqIndiceCartao);
CloseFile(ArqIndiceNomeCartao);
CloseFile(ArqUnsrCart);
//CloseFile(ArqOut);
ArqOut.Free;

SetLength(CartConta,0);  // Alivia a mem�ria alocada para o processamento...

AvisoP.Label1.Caption := 'Indexando Cartao';
AvisoP.Show;
AvisoP.RePaint;
NomeArqIndice := viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CARTAO.ORI';
TsSort := TSort.Create;
Retorno := TsSort.TurboSort(SizeOf(IndiceCartao),StrToInt(viNBufIO));
If Retorno <> 0 Then
  FormGeral.InsereLog('Cartao','Erro no sort do �ndice...',SeqLog, Agora);
TsSort.Free;

AvisoP.Label1.Caption := 'Indexando NomeCartao';
AvisoP.Show;
AvisoP.RePaint;
NomeArqIndice := viDirTrabApl + 'Temp\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'NOMECARTAO.ORI';
TsSort := TSortNomeCartao.Create;
Retorno := TsSort.TurboSort(SizeOf(IndiceNomeCartao),StrToInt(viNBufIO));
If Retorno <> 0 Then
  FormGeral.InsereLog('NomeCartao','Erro no sort do �ndice...',SeqLog, Agora);
TsSort.Free;

Arquivos.Cells[3,2] := Arquivos.Cells[3,2] + ' 100.00%';
Arquivos.Repaint;

AvisoP.Close;
AtuEst;
Result := True;
End;

Function TFormIndex.ProcessaUnsDetex;
Var
  AuxLer,
  DetexConta : AnsiString;
  Ano,
  Mes,
  Largura,
  Cont : Integer;
  ArqUnsDetex : System.Text;
  RegUnsDetex : TgUnsDetex;

  Procedure Descarrega;
  Begin       // Procedimentos de descarga...
  BufSaida := @DetexConta[1];
  ZCompress(BufSaida,TamBufOut,BufCmp,NBytesOut);

  IndiceConta.Valor := StrToInt64(Trim(ContaAnt));
  Ano := StrToInt(Copy(AnoMesAnt,1,4));
  Mes := StrToInt(Copy(AnoMesAnt,5,2));

  ArrExtrDetexArq[Ano,Mes].Processou := True;

  IndiceConta.TipoConta[1] := AnsiChar(Byte(StrToInt(Trim(CicloAnt))));
  Try
    IndiceConta.PosIni := FilePos(ArrExtrDetexArq[Ano,Mes].ArqOut);
  Except
    Try
      Reset(ArrExtrDetexArq[Ano,Mes].ArqOut,1);
      Seek(ArrExtrDetexArq[Ano,Mes].ArqOut, FileSize(ArrExtrDetexArq[Ano,Mes].ArqOut));
      IndiceConta.PosIni := FilePos(ArrExtrDetexArq[Ano,Mes].ArqOut);
    Except
      Try
        ForceDirectories(IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
          'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\');  // Cria o diret�rio de destino, se j� n�o existe...
        ReWrite(ArrExtrDetexArq[Ano,Mes].ArqOut,1);
        IndiceConta.PosIni := FilePos(ArrExtrDetexArq[Ano,Mes].ArqOut);
      Except
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Estourou a capacidade de abrir arquivos simult�neos III',SeqLog, Agora);
        Application.Terminate;
        End; // Try
      End; // Try
    End; // Try
  IndiceConta.Tam := NBytesOut;
  Inc(TotOut,NBytesOut);

  BlockWrite(ArrExtrDetexArq[Ano,Mes].ArqOut,BufCmp^,IndiceConta.Tam,Resultado);
  Try
    Write(ArrExtrDetexArq[Ano,Mes].ArqInd, IndiceConta);
  Except
    Try
      Reset(ArrExtrDetexArq[Ano,Mes].ArqInd);
      Seek(ArrExtrDetexArq[Ano,Mes].ArqInd, FileSize(ArrExtrDetexArq[Ano,Mes].ArqInd));
      Write(ArrExtrDetexArq[Ano,Mes].ArqInd, IndiceConta);
    Except
      Try
        ForceDirectories(IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
          'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\');  // Cria o diret�rio de destino, se j� n�o existe...
        ReWrite(ArrExtrDetexArq[Ano,Mes].ArqInd);
        Write(ArrExtrDetexArq[Ano,Mes].ArqInd, IndiceConta);
      Except
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Estourou a capacidade de abrir arquivos simult�neos IV',SeqLog, Agora);
        Application.Terminate;
        End; // Try
      End; // Try
    End; // Try
  ReallocMem(BufCmp,0);

  TamBufOut := 0;
  ContaAnt := RegUnsDetex.Conta;
  AnoMesAnt := RegUnsDetex.AnoMes;
  CicloAnt := RegUnsDetex.Ciclo;
  IArrUnsDetex := 1;
  End;

Begin
PreparaInicioDeProcessamento;

try
//  closeFile(ArqOut);
  ArqOut.Free;
except
end; // try

AssignFile(ArqUnsDetex,Arquivos.Cells[1,1]);
Reset(ArqUnsDetex);

ReadLn(ArqUnsDetex,AuxLer);
Cont := 1;
If UnsDetexBmg Then
  Begin
  If Length(AuxLer) <> (SizeOf(TgUnsDetexBmg)-2) Then
    Begin
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Tam Reg do Detex inv�lido: '+IntToStr(Length(AuxLer)),SeqLog, Agora);
    Edit2.Text := 'Linha ' + IntToStr(Cont) + ' ' + AuxLer;
    ShowMessage(Edit2.Text);
    ShowMessage('No registro:'+IntToStr(Length(AuxLer))+' Correto:'+IntToStr(SizeOf(TgUnsDetexBmg)-2));
    Application.Terminate;
    End;
  If Copy(AuxLer,1,3) <> '030' Then
    Begin
    RegUnsDetex.Org := '103';
    RegUnsDetex.Logo := '000';
    End
  else
    Begin
    RegUnsDetex.Org[1] := AuxLer[3];
    RegUnsDetex.Org[2] := AuxLer[4];
    RegUnsDetex.Org[3] := AuxLer[5];
    RegUnsDetex.Logo[1] := AuxLer[9];
    RegUnsDetex.Logo[2] := AuxLer[10];
    RegUnsDetex.Logo[3] := AuxLer[11];
    End;
  Move(AuxLer[12], RegUnsDetex.Conta, 145);
  End
Else
  Begin
  If Length(AuxLer) <> (SizeOf(RegUnsDetex)-2) Then
    Begin
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Tam Reg do Detex inv�lido: '+IntToStr(Length(AuxLer)),SeqLog, Agora);
    Edit2.Text := 'Linha ' + IntToStr(Cont) + ' ' + AuxLer;
    ShowMessage(Edit2.Text);
    Application.Terminate;
    End;
  Move(AuxLer[1],RegUnsDetex,SizeOf(RegUnsDetex)-2);
  End;

ContaAnt := RegUnsDetex.Conta;
AnoMesAnt := RegUnsDetex.AnoMes;
CicloAnt := RegUnsDetex.Ciclo;

CloseFile(ArqUnsDetex);
Reset(ArqUnsDetex);
IArrUnsDetex := 1;

Largura := 1000;
SetLength(DetexConta,SizeOf(RegUnsDetex)*Largura);
RegUnsDetex.CrLf := #13#10;

While Not Eof(ArqUnsDetex) Do
  Begin
  ReadLn(ArqUnsDetex,AuxLer);
  Inc(Cont);
  If UnsDetexBmg Then
    Begin
    If Length(AuxLer) <> (SizeOf(TgUnsDetexBmg)-2) Then
      Begin
      FormGeral.InsereLog(Arquivos.Cells[1,1],'Tam Reg do Detex inv�lido: '+IntToStr(Length(AuxLer)),SeqLog, Agora);
      Edit2.Text := 'Linha ' + IntToStr(Cont) + ' ' + AuxLer;
      ShowMessage(Edit2.Text);
      ShowMessage('No registro:'+IntToStr(Length(AuxLer))+' Correto:'+IntToStr(SizeOf(TgUnsDetexBmg)-2));
      Application.Terminate;
      End;
    If Copy(AuxLer,1,3) <> '030' Then
      Begin
      RegUnsDetex.Org := '103';
      RegUnsDetex.Logo := '000';
      End
    else
      Begin
      RegUnsDetex.Org[1] := AuxLer[3];
      RegUnsDetex.Org[2] := AuxLer[4];
      RegUnsDetex.Org[3] := AuxLer[5];
      RegUnsDetex.Logo[1] := AuxLer[9];
      RegUnsDetex.Logo[2] := AuxLer[10];
      RegUnsDetex.Logo[3] := AuxLer[11];
      End;
    Move(AuxLer[12], RegUnsDetex.Conta, 145);
    End
  Else
    Begin
    If Length(AuxLer) <> (SizeOf(RegUnsDetex)-2) Then
      Begin
      FormGeral.InsereLog(Arquivos.Cells[1,1],'Tam Reg do Detex inv�lido: '+IntToStr(Length(AuxLer)),SeqLog, Agora);
      Edit2.Text := 'Linha ' + IntToStr(Cont) + ' ' + AuxLer;
      ShowMessage(Edit2.Text);
      Application.Terminate;
      End;
    Move(AuxLer[1],RegUnsDetex,SizeOf(RegUnsDetex)-2);
    End;

  If (RegUnsDetex.Conta <> ContaAnt) Or (RegUnsDetex.AnoMes <> AnoMesAnt) Or (RegUnsDetex.Ciclo <> CicloAnt) Then
    Begin
//    Edit2.Text := RegUnsDetex.Conta;
//    Application.ProcessMessages;
//    If RegUnsDetex.Conta = '0000008088806079' Then
//      ShowMessage('Cheguei...');
    Descarrega;
    If Largura <> 1000 Then
      Begin
      Largura := 1000;
      SetLength(DetexConta,0);
      SetLength(DetexConta,SizeOf(RegUnsDetex)*Largura);
      End;
    End;

  Move(RegUnsDetex, DetexConta[IArrUnsDetex],SizeOf(RegUnsDetex));
  Inc(IArrUnsDetex,SizeOf(RegUnsDetex));
  If (IarrUnsDetex + SizeOf(RegUnsDetex)) > (SizeOf(RegUnsDetex)*Largura) Then
    Begin
    Largura := Largura + 1000;
    SetLength(DetexConta,SizeOf(RegUnsDetex)*Largura);
    End;

  Inc(TamBufOut,SizeOf(RegUnsDetex));

  Inc(PosArq,SizeOf(RegUnsDetex));
  Inc(TotReg);

  If (TotReg Mod QueBraMod) = 0 Then
    Begin
    AtuEst;
    If TotReg > 9000 Then
      QuebraMod := 10000
    Else
    If TotReg > 900 Then
      QuebraMod := 1000
    Else
    If TotReg > 90 Then
      QuebraMod := 100;
    End;
  End;

Descarrega; // Grava o �ltimo

CloseFile(ArqUnsDetex);
For Ano := 1990 to 2050 Do
  For Mes := 1 to 12 Do
    Begin
    Try
      CloseFile(ArrExtrDetexArq[Ano,Mes].ArqOut);
    Except
      End; // Try
    Try
      CloseFile(ArrExtrDetexArq[Ano,Mes].ArqInd);
    Except
      End; // Try
    End;

// Era aqui a rearruma��o dos �ndices

SetLength(DetexConta,0);   // Desaloca a mem�ria reservada para a vari�vel...
Arquivos.Cells[3,2] := Arquivos.Cells[3,2] + ' 100.00%';
Arquivos.Repaint;

AvisoP.Close;
AtuEst;
Result := True;
End;

Procedure TFormIndex.SairSpeedButtonClick(Sender: TObject);
Begin
Close;
End;

Procedure TFormIndex.ProcessarSpeedButtonClick(Sender: TObject);
Var
  IListaDeArquivos,
  CodGrupo,
  PosLin : Integer;
  AcessoExclusivo,
  GrupoAutomatico,
  Processou : Boolean;
  SubGrupo : AnsiString;
  TestFile : TFileStream;
//  Retorno,
  Ano,
  Mes : Integer;
  DirDest : AnsiString;

  Function TrataPto1(Arquivo : AnsiString; LinRet : Integer; Var Linha : AnsiString) : Boolean;
  Var
    Erro : Integer;
  Begin
  TrataPto1 := False;

  AssignFile(ArqIn,Arquivo); {Abre *.1}
  {$i-}
  Reset(ArqIn);
  {$i+}
  Erro := IoResult;
  If Erro <> 0 Then
    Begin
    Try
      CloseFile(ArqIn);
    Except
      End; // Try

    FormGeral.InsereLog(Arquivo,'Erro de Abertura. Codigo = '+IntToStr(Erro),SeqLog, Agora);
    MoveDelete(Arquivo, viDirTrabApl+'NaoProcessados\'+ExtractFileName(Arquivo));
    Exit;
    End;

  PosLin := 0;
  While PosLin < LinRet Do
    Begin
    {$i-}
    ReadLn(ArqIn,Linha);
    {$i+}
    Erro := IoResult;
    If Erro <> 0 Then
      Begin
      Try
        CloseFile(ArqIn);
      Except
        End; // Try

      FormGeral.InsereLog(Arquivo,'Erro de Leitura. Codigo = '+IntToStr(Erro),SeqLog, Agora);
      MoveDelete(Arquivo, viDirTrabApl+'NaoProcessados\'+ExtractFileName(Arquivo));
      Exit;
      End;
    Inc(PosLin);
    End;

  CloseFile(ArqIn);
  TrataPto1 := True;
  End;

  Procedure Distribui;
  Var
    DatFile,
    DirDest : AnsiString;
    ArqDir : File;
    RegDir : Array[1..4] of Array[1..1000] of AnsiChar;
    I, J,
    Err : Integer;
  Begin
  // Faz a dispensa��o do relat�rio processado
  DirDest := IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa;
  ForceDirectories(DirDest);  // Cria o diret�rio de destino, se j� n�o existe...
  RichEdit1.Lines.Add('Movendo arquivos processados para ' + DirDest);
  TotTamExt := 0;
  TotTam := 0;
  If FindFirst(ChangeFileExt(Arquivos.Cells[1,2],'*.*'), faAnyFile, SearchRecDistribui) = 0 Then
    Repeat
      If (UpperCase(ExtractFileExt(SearchRecDistribui.Name)) = '.DAT') Then
        Begin
        TotOut := SearchRecDistribui.Size;
        DatFile := SearchRecDistribui.Name;
        End
      Else
        TotTamExt := TotTamExt + SearchRecDistribui.Size;
      TotTam := TotTam + SearchRecDistribui.Size;
      DeleteFile(Pchar(DirDest + SearchRecDistribui.Name));
      MoveFile(Pchar(ExtractFilePath(Arquivos.Cells[1,2])+SearchRecDistribui.Name),
               Pchar(DirDest+SearchRecDistribui.Name));
    Until FindNext(SearchRecDistribui) <> 0;
  SysUtils.FindClose(SearchRecDistribui);
  If UpperCase(FormGeral.TableDFN.FieldByName('Seguranca').AsString) = 'N' Then
    Begin
//    If UnsrCont Or UnsrContVP Or UnsrContBmg Or UnsrCart Or UnsrCartVP Or UnsrCartBmg Or UnsrExtr Or UnsrExtrBmg Or UnsDetex Or UnsDetexBmg Then
    If UnsrContBmg Or UnsrCartBmg Or UnsrExtrBmg Or UnsDetexBmg Then
      Begin
      AssignFile(ArqDir, IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + NomeGrupo + '.dat');
      If FileExists(IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + NomeGrupo + '.dat') Then
        Begin
        // Le o arquivo de script
        Reset(ArqDir,1);
        For I := 1 To 4 Do
          Begin
          BlockRead(ArqDir,RegDir[I],1000,Err);
          For J := 1 To 1000 Do
            Inc(RegDir[I][J],32);
          End;
        End
      Else
        Begin
        // N�o existe  ainda o arquivo, ent�o cria vazio...
        ReWrite(ArqDir,1);
        For I := 1 To 4 Do
          Begin
          FillChar(RegDir[I],1000,#255);
          BlockWrite(ArqDir,RegDir[I],1000,Err);
          End;
        End;
      CloseFile(ArqDir);

    // Neste ponto a mem�ria est� carregada com os dados, ou vazios ou do �ltimo processamento...

      If UnsrCont Or UnsrContVP Or UnsrContBmg Then
        Begin
        FillChar(RegDir[1],1000,#255);
        For I := 1 To Length(NomeGrupo) Do
          RegDir[1][I] := NomeGrupo[I];
        For I := 100 To 99+Length(CodNum) Do
          RegDir[1][I] := CodNum[I-99];
        DatFile := CodAlfa + DatFile;
        For I := 500 To 499+Length(DatFile) Do
          RegDir[1][I] := DatFile[I-499];
        End
      Else
{      If UnsrContVP Then
        Begin
        FillChar(RegDir[1],1000,#255);
        For I := 1 To Length(NomeGrupo) Do
          RegDir[1][I] := NomeGrupo[I];
        For I := 100 To 99+Length(CodNum) Do
          RegDir[1][I] := CodNum[I-99];
        DatFile := CodAlfa + DatFile;
        For I := 500 To 499+Length(DatFile) Do
          RegDir[1][I] := DatFile[I-499];
        End
      Else
      If UnsrCart Then
        Begin
        FillChar(RegDir[2],1000,#255);
        For I := 1 To Length(NomeGrupo) Do
          RegDir[2][I] := NomeGrupo[I];
        For I := 100 To 99+Length(CodNum) Do
          RegDir[1][I] := CodNum[I-99];
        DatFile := CodAlfa + DatFile;
        For I := 500 To 499+Length(DatFile) Do
          RegDir[2][I] := DatFile[I-499];
        End
      Else }
      If UnsrCart Or UnsrCartVP Or UnsrCartBmg Then
        Begin
        FillChar(RegDir[2],1000,#255);
        For I := 1 To Length(NomeGrupo) Do
          RegDir[2][I] := NomeGrupo[I];
        For I := 100 To 99+Length(CodNum) Do
          RegDir[1][I] := CodNum[I-99];
        DatFile := CodAlfa + DatFile;
        For I := 500 To 499+Length(DatFile) Do
          RegDir[2][I] := DatFile[I-499];
        End
      Else
      If UnsrExtrBmg Then
        Begin
        FillChar(RegDir[3],1000,#255);
        For I := 1 To Length(NomeGrupo) Do
          RegDir[3][I] := NomeGrupo[I];
        For I := 100 To 99+Length(CodNum) Do
          RegDir[1][I] := CodNum[I-99];
        DatFile := CodAlfa + 'MOVTO\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT';
        For I := 500 To 499+Length(DatFile) Do
          RegDir[3][I] := DatFile[I-499];
        End
      Else
      If UnsDetex Or UnsDetexBmg Then
        Begin
        FillChar(RegDir[4],1000,#255);
        For I := 1 To Length(NomeGrupo) Do
          RegDir[4][I] := NomeGrupo[I];
        For I := 100 To 99+Length(CodNum) Do
          RegDir[1][I] := CodNum[I-99];
        DatFile := CodAlfa + 'MOVTO\' + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT';
        For I := 500 To 499+Length(DatFile) Do
          RegDir[4][I] := DatFile[I-499];
        End;

      AssignFile(ArqDir, IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + NomeGrupo + '.dat');
      Reset(ArqDir,1);
      For I := 1 To 4 Do
        Begin
        For J := 1 To 1000 Do
          Dec(RegDir[I][J],32);
        BlockWrite(ArqDir,RegDir[I],1000,Err);
        End;
      CloseFile(ArqDir);

      End;
    End;
  End;

  Procedure LimpaMensagens;
  Var
    I, J : Integer;
  Begin
  For I := 1 To Arquivos.RowCount-1 Do
    For J := 1 To Arquivos.ColCount-1 Do
      Arquivos.Cells[J,I] := '';
  If Config.ExecAutoEdit.Text = 'S' Then
    Edit1.Text := 'Aguardando In�cio da Execu��o Autom�tica'
  Else
    Edit1.Text := 'Aguardando Instru��o de In�cio de Processamento';
  Edit2.Text := '';  
  Application.ProcessMessages;
  End;

  Function ObtemSubGrupo : Boolean;
  Begin

  Result := False;

  FormGeral.QueryAux1.Close;
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM '+FormGeral.TableSubGruposDFN.TableName+' A ');
  FormGeral.QueryAux1.Sql.Add('WHERE A.CODGRUPO = '+
                         FormGeral.TableDFN.FieldByName('CodGrupo').AsString);
  FormGeral.QueryAux1.Sql.Add('AND A.CODSUBGRUPO = '+
                         FormGeral.TableDFN.FieldByName('CodSubGrupo').AsString);
  Try
    FormGeral.QueryAux1.Open;
    If FormGeral.QueryAux1.RecordCount = 0 Then
      Begin
      FormGeral.InsereLog(TxtRec.Name,'Query Sub Grupo Vazia',SeqLog, Agora);
      MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
      Exit; // 07/09/2000
      End;
    SubGrupo := FormGeral.QueryAux1.FieldByName('NomeSubGrupo').AsString;
    FormGeral.QueryAux1.Close;
  Except
    FormGeral.InsereLog(TxtRec.Name,'Erro de Query Sub Grupo',SeqLog, Agora);
    MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
    Exit; // 07/09/2000
    End; //Try
  Result := True;
  End;

  Function ObtemGrupo : Boolean;

  Begin
  Result := False;
  Try
    FormGeral.QueryAux1.Open;
    If FormGeral.QueryAux1.RecordCount = 0 Then
      Begin
      FormGeral.InsereLog(TxtRec.Name,'Query Grupo Vazia',SeqLog, Agora);
      MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
      Exit;
      End
    Else
      Begin
      NomeGrupo := LimpaNomArq(FormGeral.QueryAux1.FieldByName('NomeGrupo').AsString);
      CodAlfa := LimpaNomArq(FormGeral.QueryAux1.FieldByName('NomeGrupo').AsString)+'\'+
                 LimpaNomArq(SubGrupo) + '\';
      CodGrupo := FormGeral.QueryAux1.FieldByName('CodGrupo').AsInteger;
      End;
    FormGeral.QueryAux1.Close;
  Except
    FormGeral.InsereLog(TxtRec.Name,'Erro de Query Grupo',SeqLog, Agora);
    MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
    Exit; // 31/08/2000
    End;
  Result := True;
  End;

Begin
Timer1.Enabled := False;

//FileMode := fmShareDenyNone;
FileMode := fmOpenReadWrite or fmShareDenyNone;

Agora := Now;  // Determina o Espa�o tempo necess�rio...

Edit1.Text := 'Indexando Arquivos...';
Application.ProcessMessages;

FormGeral.IBAdmRemotoDatabase.Close;  // Refresh na conex�o com o banco de dados
FormGeral.IBLogRemotoDatabase.Close;
FormGeral.IBAdmRemotoDatabase.Open;
FormGeral.IBLogRemotoDatabase.Open;

Processou := False;

Screen.Cursor := crHourGlass;

FormGeral.TableDFN.Open;
If FormGeral.TableDFN.FieldByName('CODREL').AsString = '*' Then  // Pula o coringa
  FormGeral.TableDFN.Next;

FormGeral.IBQueryInsertProtocolo.Prepare;
If FormGeral.IBProtocoloTransaction.InTransaction Then
  FormGeral.IBProtocoloTransaction.Commit;
FormGeral.IBProtocoloTransaction.StartTransaction;

While Not FormGeral.TableDFN.Eof Do
  Begin
  DirIn := IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('DirEntra').AsString);
  Reports1Str := DirIn + FormGeral.TableDFN.FieldByName('NomeArquivo').AsString+'*.TXT';
//  Reports1Str := DirIn + FormGeral.TableDFN.FieldByName('NomeArquivo').AsString+'*.PRC'; // Para facilitar testes CeA

  ListaDeArquivosAProcessar.Clear;
  ListaDeArquivosAProcessar.Sorted := False;
  If (FindFirst(Reports1Str,faAnyFile,SearchRecTxt) = 0) Then
    Repeat
      ListaDeArquivosAProcessar.Add(UpperCase(SearchRecTxt.Name));
    Until FindNext(SearchRecTxt) <> 0;

    SysUtils.FindClose(SearchRecTxt);

  ListaDeArquivosAProcessar.Sorted := True;
  For IListaDeArquivos := 0 To ListaDeArquivosAProcessar.Count-1 Do
    Begin                            // To access all the info of the file
      If (FindFirst(DirIn+ListaDeArquivosAProcessar[IListaDeArquivos],faAnyFile,TxtRec) = 0) Then;

      AcessoExclusivo := True;
      TestFile := nil;
      Try
        TestFile := TFileStream.Create(DirIn+TxtRec.Name,fmOpenRead or fmShareExclusive);
      Except
        AcessoExclusivo := False
        End; // Try
      If TestFile <> nil Then
        TestFile.Free;

      If Not AcessoExclusivo Then
        Continue;   // Pula o arquivo que est� sendo copiado no momento

      CodAlfa := '';
      SubGrupo := '';

      GrupoAutomatico := FormGeral.TableDFN.FieldByName('CodGrupAuto').AsBoolean;

      If (GrupoAutomatico) Then
        Begin       // Montagem do path dos relat�rios autom�ticos
        If Not TrataPto1(DirIn+TxtRec.Name, FormGeral.TableDFN.FieldByName('LinGrupAuto').AsInteger, Linha2) Then
          Continue;

        Try
          CodAlfa := Copy(Linha2,FormGeral.TableDFN.FieldByName('ColGrupAuto').AsInteger,
                                 FormGeral.TableDFN.FieldByName('TamGrupAuto').AsInteger);
        Except
          FormGeral.InsereLog(TxtRec.Name,'CodGrupoAuto N�o pode ser obtido, Erro de Copy',SeqLog, Agora);
          MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
          Continue;  // 31/08/2000
          End; // Try

        Try
          CodAlfa := IntToStr(StrToInt(CodAlfa));
          CodNum := CodAlfa;
          While Length(CodNum) < 3 Do
            CodNum := '0'+CodNum;
        Except
          FormGeral.InsereLog(TxtRec.Name,'Erro de convers�o do grupo para num�rico',SeqLog, Agora);
          MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
          Continue; // 31/08/2000
          End; // Try

        If Not ObtemSubGrupo Then
          Continue;

        FormGeral.QueryAux1.Close;
        FormGeral.QueryAux1.Sql.Clear;
        FormGeral.QueryAux1.Sql.Add('SELECT * FROM '+FormGeral.TableGruposDFN.TableName+' A ');
        FormGeral.QueryAux1.Sql.Add('WHERE A.CODGRUPO = '+CodAlfa);

        If Not ObtemGrupo Then
          Continue;
        End
      Else
        Begin                        // Montagem da �rvore dos relat�rios normais
        If Not ObtemSubGrupo Then
          Continue;

        FormGeral.QueryAux1.Close;
        FormGeral.QueryAux1.Sql.Clear;
        FormGeral.QueryAux1.Sql.Add('SELECT * FROM '+FormGeral.TableGruposDFN.TableName+' A ');
        FormGeral.QueryAux1.Sql.Add('WHERE A.CODGRUPO = '+
                            FormGeral.TableDFN.FieldByName('CODGRUPO').AsString);

        If Not ObtemGrupo Then
          Continue;
        End;

      QuebraMod := 10;

      If IListaDeArquivos = 0 Then // Inicializa apenas uma �nica vez no primeiro arquivo da lista...
        For Ano := 1990 to 2050 Do
          For Mes := 1 to 12 Do
            Begin
            DirDest := IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
                       'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\';
            AssignFile(ArrExtrDetexArq[Ano,Mes].ArqOut, DirDest+FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT');
            AssignFile(ArrExtrDetexArq[Ano,Mes].ArqInd, DirDest+FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTA.IND');
            ArrExtrDetexArq[Ano,Mes].Processou := False;

            //CeA

{            AssignFile(ArrArqMovs[Ano,Mes].ArqOut, DirDest+FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT');
            ArrArqMovs[Ano,Mes].NomeDoIndice := DirDest+FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTA.IND';
            AssignFile(ArrArqMovs[Ano,Mes].ArqInd, ArrArqMovs[Ano,Mes].NomeDoIndice);
//            AssignFile(ArrArqMovs[Ano,Mes].ArqOut, DirDest + 'EMPROC.DAT');
//            ArrArqMovs[Ano,Mes].NomeDoIndice := DirDest + 'EMPROCCONTA.IND';
//            AssignFile(ArrArqMovs[Ano,Mes].ArqInd, ArrArqMovs[Ano,Mes].NomeDoIndice);
            ArrArqMovs[Ano,Mes].Processou := False;         }
            End;

    //  UnsrExtr := False;
      UnsrExtrBmg := False;
    //  UnsrExtrRQ := False;
    //  UnsDetex := False;
      UnsDetexBmg := False;
//      UnsDetexRQ := False;
    //  UnsrCont := False;
   //   UnsrContVP := False;
      UnsrContBmg := False;
//      UnsrCart := False;
//      UnsrCartVP := False;
      UnsrCartBmg := False;
//      ExtrCeAv0001 := False;

      If (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,11) = 'UNSREXTRBMG') or
         (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,13) = 'UNSREXTRCIFRA') Then
        UnsrExtrBmg := True
      Else
      If (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,11) = 'UNSDETEXBMG') or
         (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,13) = 'UNSDETEXCIFRA') Then
        UnsDetexBmg := True
      Else
      If (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,11) = 'UNSRCONTBMG') or
         (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,13) = 'UNSRCONTCIFRA') Then
        UnsrContBmg := True
      Else
      If (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,11) = 'UNSRCARTBMG') or
         (Copy(UpperCase(FormGeral.TableDFN.FieldByName('CODREL').AsString),1,13) = 'UNSRCARTCIFRA') Then
        UnsrCartBmg := True;

      If UnsrExtrBmg Then     // Processamento do arquivo de cadastro de extratos
        Begin
        If Not ProcessaUnsrExtr Then
          Begin
          MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
          Continue;
          End;
        End
      Else
      If UnsrCartBmg Then     // Processamento do arquivo de cadastro de cart�es VP
        Begin
        If Not ProcessaUnsrCartVP Then
          Begin
          MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
          Continue;
          End
        End
      Else
      If UnsrContVP oR UnsrContBmg Then     // Processamento do arquivo de cadastro de contas VP
        Begin
        If Not ProcessaUnsrContVP Then
          Begin
          MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
          Continue;
          End;
        End
      Else
      If UnsDetex Or UnsDetexBmg Then     // Processamento do arquivo de cadastro de detalhes
        Begin
        If Not ProcessaUnsDetex Then
          Begin
          MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
          Continue;
          End;
        End
      Else
        Begin
        MoveDelete(DirIn+TxtRec.Name,viDirTrabApl+'NaoProcessados\'+TxtRec.Name);
        Continue;
        End;

//      MoveDelete(Arquivos.Cells[1,1],ChangeFileExt(Arquivos.Cells[1,1], '.PRC'));
      If not RenameFile(Arquivos.Cells[1,1],ChangeFileExt(Arquivos.Cells[1,1], '.PRC')) then
        begin
        ShowMessage('Arquivo de Entrada n�o pode ser marcado como processado');
//        Unit1.Form1.Edit1.Text := 'Arquivo de Entrada n�o pode ser marcado como processado';
//        Unit1.Form1.ShowModal;
        end;

      If Config.BackAutoEdit.Text = 'S' Then
        Begin
        ForceDirectories(Config.Edit1.Text + FormatDateTime('YYYYMMDD_HHNNSS',Agora));
        MoveDelete(ChangeFileExt(Arquivos.Cells[1,1], '.PRC'),
          Config.Edit1.Text+FormatDateTime('YYYYMMDD_HHNNSS',Agora)+'\'+SeArquivoSemExt(TxtRec.Name)+'.PRC');
        End;

      Distribui; // Distribui o relat�rio indexado e cria a vers�o seguran�a

      Processou := True;

      FormGeral.IBQueryInsertProtocolo.Params[0].AsInteger := SeqProto;
      Inc(SeqProto);
      FormGeral.IBQueryInsertProtocolo.Params[1].AsString := FormGeral.TableDFN.FieldByName('CodRel').AsString;
      FormGeral.IBQueryInsertProtocolo.Params[2].AsString := FormGeral.TableDFN.FieldByName('NomeRel').AsString;
      FormGeral.IBQueryInsertProtocolo.Params[3].AsInteger := FormGeral.TableDFN.FieldByName('CodGrupo').AsInteger;
      FormGeral.IBQueryInsertProtocolo.Params[4].AsInteger := FormGeral.TableDFN.FieldByName('CodSubGrupo').AsInteger;
      FormGeral.IBQueryInsertProtocolo.Params[5].AsInteger := CodGrupo;
      FormGeral.IBQueryInsertProtocolo.Params[6].AsString := ExtractFileName(Arquivos.Cells[1,1]);
      FormGeral.IBQueryInsertProtocolo.Params[7].AsString := '';
      FormGeral.IBQueryInsertProtocolo.Params[8].AsDateTime := Now;
      FormGeral.IBQueryInsertProtocolo.Params[9].AsDateTime := Now;
      FormGeral.IBQueryInsertProtocolo.Params[10].AsInteger := TotReg;
      FormGeral.IBQueryInsertProtocolo.Params[11].AsInteger := Divisor;
      FormGeral.IBQueryInsertProtocolo.Params[12].AsInteger := TotOut;
      FormGeral.IBQueryInsertProtocolo.Params[13].AsInteger := 0;
      FormGeral.IBQueryInsertProtocolo.Params[14].AsInteger := TotTamExt;
      FormGeral.IBQueryInsertProtocolo.Params[15].AsInteger := TotTam;

      Try
        FormGeral.IBQueryInsertProtocolo.ExecSQL;
      Except
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Erro de inser��o de registro de protocolo, Resumo final',SeqLog, Agora);
        End; // Try

      Try
        RichEdit1.SetFocus;
        RichEdit1.SelStart := Length(RichEdit1.Text)-2;
        RichEdit1.SelLength := 1;
      Except
        End; // Try

      Application.ProcessMessages;
    End;

  OkParaReprocessarGeral := False;

  If UpperCase(viOtimGer) = 'S' Then
{    If ExtrCeAv0001 Then
      Begin
      For Ano := 1990 to 2050 Do
        For Mes := 1 to 12 Do
          If (ArrArqMovs[Ano,Mes].Processou) Then
            OkParaReprocessarGeral := True
      End
    Else    }
      For Ano := 1990 to 2050 Do
        For Mes := 1 to 12 Do
          If (ArrExtrDetexArq[Ano,Mes].Processou) Then
            OkParaReprocessarGeral := True;

  For Ano := 1990 to 2050 Do
    For Mes := 1 to 12 Do
      Begin
      If OkParaReprocessarGeral Then
        ArrExtrDetexArq[Ano,Mes].Processou := True;

      If ArrExtrDetexArq[Ano, Mes].Processou And IndiceDesbalanceado(Ano, Mes) Then
        Begin
        AvisoP.Label1.Caption := 'Otimizando '+IntToStr(Ano)+IntToStr(Mes);
        AvisoP.Show;
        AvisoP.RePaint;
        DirDest := IncludeTrailingPathDelimiter(FormGeral.TableDFN.FieldByName('Destino').AsString) + CodAlfa +
                   'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\';
        NomeArqIndice := DirDest+FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTA.IND';
        NomeArqDat := DirDest+FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT';
        TaSort := TSortBal.Create;
        SetLength(SortMem.ArInd,SortMem.TamArr);
        TaSort.InPutSort;
        SortMem.SortEmMemoria;
        TaSort.OutPutSort;
//        Retorno := TsSort.TurboSort(SizeOf(IndiceCartao),StrToInt(viNBufIO));
//        Retorno := TsSort.TurboSort(25,StrToInt(viNBufIO));
//        If Retorno <> 0 Then
//          FormGeral.InsereLog('Otimiza '+IntToStr(Ano)+IntToStr(Mes),'Erro no sort do �ndice...',SeqLog, Agora);
        TaSort.Free;
        AvisoP.Close;
        End;
      ArrExtrDetexArq[Ano,Mes].Processou := False;
      End;

  SetLength(SortMem.ArInd,0);
//  SetLength(SortMem.ArIndNumCnt,0);

  SysUtils.FindClose(SearchRecTxt);

  FormGeral.TableDFN.Next;

  End;

Try
  FormGeral.IBQueryInsertProtocolo.UnPrepare;
  FormGeral.IBProtocoloTransaction.Commit;
Except
  End; // Try

FormGeral.TableDFN.Close;

Screen.Cursor := crDefault;

If Config.ExecAutoEdit.Text = 'S' Then
  Begin
  If Processou Then    // Significa que algum relat�rio foi processado, volta para processar mais;
    Timer1.Interval := 1000
  Else
    Timer1.Interval := StrToInt(Trim(Config.Edit2.Text))*1000;
  LimpaMensagens;
  Timer1.Enabled := True;
  End
Else
  Begin
  ShowMessage('Fim de Indexa��o');
//  Unit1.Form1.Edit1.Text := 'Fim de Indexa��o';
//  Unit1.Form1.ShowModal;
  LimpaMensagens;
  End;
End;

Procedure TFormIndex.Processamento1Click(Sender: TObject);
Begin
Timer1.Enabled := False;
Edit1.Text := 'Aguardando fechamento da janela de Configura��es de Processamento';
Application.ProcessMessages;
Config.ShowModal;
If Config.ExecAutoEdit.Text = 'S' Then
  Begin
  Edit1.Text := 'Aguardando In�cio da Execu��o Autom�tica';
  Timer1.Enabled := True;
  End
Else
  Edit1.Text := 'Aguardando Instru��o de In�cio de Processamento';
Application.ProcessMessages;
End;

Procedure TFormIndex.FormClose(Sender: TObject; var Action: TCloseAction);
Begin
FormGeral.IBAdmRemotoDatabase.Close;
FormGeral.IBLogRemotoDatabase.Close;
End;

End.
