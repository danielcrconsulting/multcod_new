{

DICA

So, I found my mistake:

The Problem is the initialization of the query instance. Somehow overhanding of the Source Table Type and the AdsCharType isn't necessary.

FADSQuery.SourceTableType := ttAdsAdt;
FADSQuery.Tableoptions.AdsCharType := GERMAN_VFP_CI_AS_437;
I just removed the above lines and my queries are nearly as fast as the Advantage Data Architect.





 Unit Principal do programa de indexa��o - Sistema MultiCold

 Altera��es:

 17/11/1999 - Integra��o da Rotina Separ, separador de relat�rios. Estabelecimento do novo fluxo de execu��o:
              1) Filtro - FiltroProc
              2) Separador - Separ
              3) Ap�s a separa��o o arquivo original do relat�rio � renomeado para .S1
              4) Caso configurado, faz o backup do arquivo .S1

              Implementa��o da leitura da vari�vel DirBase da se��o DirTrab do Arquivo Cold_Service.ini
              para o estabelecimento do diret�rio de trabalho com ChDir. Isto se tornou necess�rio ap�s
              o teste de launch do programa via servi�o NT.

              Estabelecimento do Separador Decimal , (v�rgula) no create deste form. Mesmo que nas configura��es
              regionais seja colocada a , (v�rgula) como separador decimal esta configura��o n�o estar� dispon�vel
              antes do LogIn no Windows NT. Se o programa � iniciado pelo servi�o Cold esta configura��o estava sendo
              Lida como . (ponto) antes do LogIn e como , (v�rgula) depois.

 20/11/1999 - Implementa��o do teste de aceso exclusivo ao arquivo candidato a filtragem. Se h� sucesso,
              o programa processa o arquivo, caso contr�rio deixa-o sem processar.

 16/02/2000 - Retirada do c�digo de compila��o dos filtros de _String e caracter para a subrug na forma de um objeto
              para possibilitar o seu uso no MultEdit nos templates

 22/03/2000 - Utiliza��o do objeto Halcyon para a indexa��o das tabelas Dbase para melhorar a performance. O BDE estava
              muito lento para indexar as tabelas maiores.
 23/03/2000 - No servidor deu um problema de classe nao registrada. Retirei o objecto XCeedZip
              e a chamada da unit, o que resolveu o problema
              Descobrimos que o BDE indexa num�ricos muito r�pido e caracter muito lento. O
              Halcyon tem problema com indexa��o de n�meros e n�o com caracter e �, neste caso
              muito r�pido. Colocamos, ent�o, o BDE para indexar n�meros e o Halcyon para
              indexar caracteres.
 29/03/2000 - Implementa��o da fun��o de elimina��o de p�ginas em branco.
 04/05/2000 - Reformula��o do processamento para ler a nova base de dados de configura��o
 25/05/2000 - Acerto dos campos de data (circular em 50 para AA). Uso do campo ftDate em vez do ftDateTime (virava
              C 30). Implementa��o do AutoSubDir. For�ar o richedit1 a scrollar para o fim.
 31/05/2000 - Coloca��o do tratamento do segundo par�metro de quebra de relat�rio.
 05/06/2000 - Coloca��o do processamento autom�tico de grupos
 24/08/2000 - Coloca��o do caractere de quebra autom�tica nos arquivos _.S1 para futuro reprocessamento
 30/06/2001 - Altera��o da rotina LimpaNomArq da Subrug para trocar os caracteres inv�lidos para _ em vez de + para
              ficar mais bonitinho. Tamb�m inclu� . na lista, embora n�o seja inv�lido, para limpar este caracter
              da por��o nome do nome ou da exten��o deixando acargo do programador nunca passar o nome inteiro e
              sim as por��es separadas
              Altera��o no separador para n�o gerar mais arquivos sequenciais juntando tudo num s� para turbinar o
              processo de separa��o
              O memo1 da janela de separa��o est� limitado a montar 10000 quando o programa d� um clear
              Protegida a rotina de identifica��o do relat�rio na separa��o que dava access violation em caso de
              linha/coluna altas e referindo-se fora da p�gina.
 10/07/2001 - Altera��o do loop de processamento principal para rodar at� esgotar todos os .1 e .s1 do diret�rio
              de trabalho. A procedure LimpaMensagens n�o limpa mais a extensao.text permitindo o segundo clique
              de processamento sem o repreenchimento da extens�o.
 14/07/2001 - Coloca��o da informa��o da extensao.text na tabela de protocolo
 20/07/2001 - Reformula��o do loop principal de processamento. Carga �nica de informa��es de separa��o por processamento.
              Processamento dos *.1 que estiverem no diret�rio principal de trabalho. Procura e processamento dos *.1
              a partir do diret�rio DIRENTRA da DFN. Separa��o dos relat�rios. Inclus�o da informa��o da extens�o no
              nome do arquivo n�o separado para melhor identificar os jobs de separa��o de cada processamento. Ap�s a
              indexa��o de cada arquivo, se a extens�o autom�tica estiver ligada o agora e a extens�o.text mudam para
              preservar os fontes.
 28/11/2001 - R21 - Fix no abend -> o programa tenta colocar um caracter separador na primeira p�gina n�o identificada
              de um s1, para reprocessar corretamente. Em alguns casos a primeira linha vinha vazia o que provocava o
              acess violantion. Coloquei um Try...
 12/12/2001 - R22 - Fix em outro abend -> .s1 zerado causava erro de I/O 103, pois o programa queria fechar o arquivo
              de sa�da, que neste caso n�o havia sido gerado...
 21/04/2002 - R23 - Implementa��o da extra��o de dados na indexador
 r26 16/03/2003
 Recompila��o para o acerto do bug so consumo de mem�ria na extra��o .xtr
 r7 - 12/09/2005
             Alterada a rotina que cria as tabelas dbf de �ndices. No caso de campos tipo N, passamos a usar
             um CREATE TABLE (query.execsql) para que o campo valor tenha o tamanho exato especificado. Isto n�o s� economiza
             espa�o como evita que, para os campos maiores que 9, seja usado o tipo ftFloat que � transladado
             como um num�rico 20:4 (tabela.CreateTable). Este tipo de campo costuma dar problema com dbfs readonly.
 V6.93 - 23/07/2013
             Altera��es na subrug (SeArquivoSemExt) para buscar a extens�o pelo fim do texto podendo manipular nomes com m�ltiplos pontos.
             Inclu�da a extens�o .dbf no nome das tabelas de �ndice para evitar um crash na halcyon com o nome com m�ltiplos pontos e outro crash
             na rotina que contabilizava o tamanho dos arquivos dbf e mdx
V 7.0.0.0 - 12/02/2014
             Compilado no XE4
             BDE e Halcyon est�o fora...
V 7.0.0.1 - 17/04/2014
            Retirada a rotina de cria��o das tabelas de �ndice por comando pq no Advantage gera tipo ADT e fode...

V 7.0.0.2 - 24/06/2014
            Colocado o teste de sistema autom�tico para carregar o c�digo de org no registro DFN. Isso pq h� casos de relat�rios
            com sistema autom�tico e CodOrg = -1 e orgAutomatico n�o setado. S� que o valor da org espec�fica est� no registro que
            determina o sistema, portanto o valor da org pode ser obtido por ele. Dessa forma permite a libera��o de acesso pela ORG.

            Retirada a chamada para a rotina de separa��o que ficou num programa � parte: MultiColdSeparador - Melhorar performance.

            Buffer de I/O de dados compactados aumentado para 60000000 de bytes...

}

Unit Index;

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, SuTypGer, Zlib,
  Buttons, DB, AvisoI, ExtCtrls, FiltroProc, Menus,
  OleCtrls, ComCtrls, Variants, ToolWin, ImgList, {adsdata, adsfunc, adstable,
  adscnnct,} Bde.DBTables, System.ImageList;

Type
  TFormIndex = Class(TForm)
    Label5: TLabel;
    SairSpeedButton: TSpeedButton;
    ProcessarSpeedButton: TSpeedButton;
    FiltrarSpeedButton: TSpeedButton;
    ConfigProcSpeedButton: TSpeedButton;
    Arquivos: TStringGrid;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Indexar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Configuraes1: TMenuItem;
    FiltrodeArquivos1: TMenuItem;
    Processamento1: TMenuItem;
    Timer1: TTimer;
    RichEdit1: TRichEdit;
    Label3: TLabel;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ImageList1: TImageList;
//    AdsTable1: TTable;
//    AdsConnection1: TAdsConnection;
    Table1: TTable;
    Query1: TQuery;
    Procedure FormCreate(Sender: TObject);
    Procedure SairSpeedButtonClick(Sender: TObject);
    Procedure ProcessarSpeedButtonClick(Sender: TObject);
    Procedure FiltrodeArquivos1Click(Sender: TObject);
    Procedure Processamento1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    { Private declarations }
  Public
    { Public declarations }
    Procedure AtuEst;
    Function ProcessaArquivo : Boolean;
  End;

Var
  FormIndex: TFormIndex;

Implementation

Uses ConfigProc, Separ, IniFiles, SuGeral, Subrug, System.UITypes,
  MExtract;

{$R *.DFM}

// Index

Var
  ArrSubDirAuto : Array[1..10000] Of Record
                                     CodSis,
                                     CodGrupo : AnsiString;
                                     End;
  FiltroObj : TFiltro;
  CodAlfa : AnsiString;
  ExtrairDados,
  BackupFonte,
  JuncaoAutomatica,
  FiltraCar,
  ComprBrancos,
  TemQuePularNaProxima,
  PulaAntes : Boolean;
  LinhasInd : Array[1..MaxLinhasPorPag] Of Boolean;
  BufOut : Array[1..BufSize] Of AnsiChar;
  TabelaBde : Array Of TTable;
  TabelaAds : Array Of TTable;
  Indices : Array Of Integer;
  Mascaras : Array Of Record
                      PosAno,
                      TamAno,
                      PosMes,
                      TamMes,
                      PosDia,
                      TamDia : Integer;
                      End;
  TiposDeCampos,
  NomesDeCampos : Array Of AnsiString;
  Fusao : Array Of Record
                   CodFusao,
                   IndRef   : Integer;
                   IndiceGerado : Boolean
                   End;
  IFrmExtract : Integer;
  NLinhasQuebraLin,
  ColQuebraStr1,
  ColQuebraStr2,
  QtdPgsAPular,
  QuebraMod,
  TamanhoOri,
  TamPagCmp,
  ContLin,
  II,
  //Paginas,
  //TotPag,
  //PosArq,
  //TotOut,
  //Divisor,
  IndO,
  Err,
  Err1,
  Relativo,
  TamInd,
  TotTamInd,
  TotTamExt,
  TotTam,
  IPagina : Integer;
  ArqLog,
  ArqIn  : System.Text;
  ArqTam,
  ArqOut : File;
  ArqPag : File Of Int64; // Maior capacidade de armazenamento...
  PosAtu : Int64;
  RegInd,
  Linha,            // Nova compatibiliza��o para leituras de linhas longas
  Linha2,
  StrQuebraStr1,
  StrQuebraStr2 : AnsiString;  // Por enquanto vamos mantendo a AnsiString de um byte
  ReportStr,
  Reports1Str : AnsiString;
  DirIn,
  NomeDat,
  DirDest : AnsiString;  { Long AnsiString que vai acumular a p�gina inteira }
  BufCmp : Pointer;
  SearchRec,
  ReportRec,
  Reports1Rec, Reports1RecII : TSearchRec;

  PosArq,
  Paginas,
  TotPag,
  TotOut,
  Divisor : Int64;

Procedure TFormIndex.FormCreate(Sender: TObject);

Begin
FiltroObj := TFiltro.Create;
If ParamCount <> 0 Then
  FormIndex.WindowState := wsMinimized;
With Arquivos Do
  Begin
  Cells[0,1] := 'Entrada ';
  Cells[0,2] := 'Saida   ';
  Cells[1,0] := 'Nome';
  Cells[2,0] := 'Tamanho';
  Cells[3,0] := 'P�ginas';
  End;

FormatSettings.DecimalSeparator := ','; // For�a o uso da v�rgula como separador decimal nas opera��es aritm�ticas ...
//AdsConnection1.ConnectPath := viDirTrabApl + 'Temp\';
//AdsConnection1.Connect;
End;

Procedure TFormIndex.AtuEst;

Var
  Porcento : Real;
  StrReal : AnsiString;
Begin
If Divisor <> 0 Then
  Porcento := (PosArq / Divisor) * 100.0
Else
  Porcento := 100.00;

If Porcento > 100.00 Then
  Porcento := 100.00;

Str(Porcento:5:2,StrReal);

Arquivos.Cells[2,2] := formatFloat('###,###,###,###,###',TotOut);
Arquivos.Cells[3,1] := formatFloat('###,###,###,###,###',Paginas)+' '+StrReal+'%';
Arquivos.Cells[3,2] := formatFloat('###,###,###,###,###',TotPag);


Application.ProcessMessages;
End;

Procedure OutWrite(Var ROut : Pointer; Qtd : Integer);

Begin
If (IndO + Qtd) > BufSize Then
  Begin
  BlockWrite(ArqOut,BufOut[1],IndO-1,Err1);
  IndO := 1;
  End;
Move(ROut^,BufOut[IndO+1],Qtd);
BufOut[IndO] := #40;
Inc(Qtd);
Inc(IndO,Qtd);
Inc(PosAtu,Qtd);
End;

Procedure MoveDelete(Origem, Destino : String);  //String para o correto funcionamento do programa
Begin
DeleteFile(PChar(Destino));
If Not MoveFile(PChar(Origem), PChar(Destino)) Then
  FormGeral.InsereLog(Origem,'Erro na Fun��o MoveFile, arquivo n�o movido, verifique.');
End;

Procedure MoveRename(Origem, Destino : String); //String para o correto funcionamento do programa
Begin
while fileExists(Destino) do
  Destino := ExtractFilePath(Destino) + SeArquivoSemExt(Destino) + FormatDateTime('_hhnnsszzz',Now) + ExtractFileExt(Destino);
If Not MoveFile(PChar(Origem), PChar(Destino)) Then
  FormGeral.InsereLog(Origem,'Erro na Fun��o MoveFile, arquivo n�o movido, verifique.');
End;

Function TFormIndex.ProcessaArquivo;

Var
  QuebrouPagina : Boolean;

  Function PaginaEstaVazia : Boolean;
  Var
    I : Integer;
  Begin
  PaginaEstaVazia := True;
//  For I := 1 To Length(Pagina) Do
  For I := 1 To (IPagina-1) Do
    Begin
    If PaPagina[I] In ['!'..'{'] Then
      Begin
      PaginaEstaVazia := False;
      Exit;
      End;
    End;
  End;

  Procedure VerificaQuebradePagina;
  Begin

  // Tratar o destino e mover no final para os destinos programados

  If TemQuePularNaProxima Then
    Begin
    QuebrouPagina := True;
    TemQuePularNaProxima := False;
    Exit;
    End;

  QuebrouPagina := False;
  TemQuePularNaProxima := False;

  If (Length(Linha) > 0) Or (TipoQuebra = 3) Then  // S� verifica se a linha tem algo ....
    Case TipoQuebra Of
      1 : If (Linha[1] = '1') Then  // 133 CC
            QuebrouPagina := True;
      2 : If (Linha[1] = ^L) Then   // Ctrl L
            Begin
            Linha[1] := ' ';
            QuebrouPagina := True;
            End
          Else
          If Linha[Length(Linha)] = ^L Then
            Begin
            Linha[Length(Linha)] := ' ';
            QuebrouPagina := True;
            End;
      3 : If ContLin = NLinhasQuebraLin + 1 Then
            QuebrouPagina := True;
      4 : Begin                        // Str
          If Copy(Linha, ColQuebraStr1,Length(StrQuebraStr1)) = StrQuebraStr1 Then
            QuebrouPagina := True;

          If StrQuebraStr2 <> '' Then
            QuebrouPagina := QuebrouPagina And (Copy(Linha, ColQuebraStr1,Length(StrQuebraStr2)) = StrQuebraStr2);

          If (Not (PulaAntes)) And (QuebrouPagina) Then
            Begin
            QuebrouPagina := False;
            TemQuePularNaProxima := True;
            End;
          End;
      End; // Case

  If QuebrouPagina Then
    If (PaginaEstaVazia) Or (QtdPgsAPular > 0) Then
      Begin
      QuebrouPagina := False;  // Pagina vazia ou deve ser desprezada, Descarta
      Relativo := 0;
      ContLin := 1;
      IPagina := 1;
//      SetLength(Pagina,0);
//      SetLength(Pagina,133000);
      Dec(QtdPgsAPular);
      End;
  End;

  Function PreparaPto1 : Boolean;
  Var
    SearchRec : TSearchRec;
  Begin
  Result := False;
  If Result Then;

  With Arquivos Do
    Begin
    Cells[1,1] := DirIn + ReportRec.Name;

    Cells[1,2] := viDirTrabApl + 'Temp\' + SeArquivoSemExt(Cells[1,1]) +
                  StatusBar1.Panels[0].Text + '.DAT';
    Repaint;
    End;

  If RichEdit1.Lines.Count >= 10000 Then      // Cria um limite...
    RichEdit1.Clear;
    
  RichEdit1.Lines.Add('****');
  RichEdit1.Lines.Add('Iniciando o Processamento de :');
  RichEdit1.Lines.Add(Arquivos.Cells[1,1]);
  RichEdit1.Lines.Add('');

  ContLin := 0;

  TotOut := 0;    { Acumula tamanho do arquivo de dados }
  TotPag := 1;    { Acumula total de Paginas de todos os arquivos }

  IndO := 1; { Indice de buffer Out }

  Try
    CloseFile(ArqOut);
  Except
    End;
  Try
    CloseFile(ArqPag);
  Except
    End;

  AssignFile(ArqOut,Arquivos.Cells[1,2]);
  AssignFile(ArqPag,ChangeFileExt(Arquivos.Cells[1,2],'.IAPX'));

  If JuncaoAutomatica Then
    Begin
    RichEdit1.Lines.Add('Copiando o dat anterior...');
    If FindFirst(DirDest+'*.dat', FaAnyFile, SearchRec) = 0 Then     // Copia o dat
      Begin
      CopyFile(Pchar(DirDest+SearchRec.Name),
               Pchar(Arquivos.Cells[1,2]), False); // OverWrite If Exists
      End;
    SysUtils.FindClose(SearchRec);

    RichEdit1.Lines.Add('Copiando o iapx anterior...');
    If FindFirst(DirDest+'*.iapx', FaAnyFile, SearchRec) = 0 Then     // Copia o iapx
      CopyFile(Pchar(DirDest+SearchRec.Name),
               PChar(ChangeFileExt(Arquivos.Cells[1,2],'.IAPX')), False); // OverWrite If Exists
    SysUtils.FindClose(SearchRec);

    Reset(ArqPag);
    Reset(ArqOut,1);
    Seek(ArqPag,FileSize(ArqPag));
    Seek(ArqOut,FileSize(ArqOut));
    End
  Else
    Begin
    ReWrite(ArqPag);
    ReWrite(ArqOut,1);
    End;

  PosAtu := FilePos(ArqOut);              { Posi��o da Primeira Pagina }

  Result := True;

  End;

  Procedure ComprimeBrancos;
  Var
    I,K,
    Dest,
    Posic,
    Cont   : Integer;
    RegAux : AnsiString;
    AuxStr : AnsiChar;
    Ano,
    Mes,
    Dia : Word;
  Begin
  If LinhasInd[ContLin] Then { a linha em quest�o � indexadora }
    Begin
    For I := 0 To Length(TabelaBde)-1 Do
      Begin
      If Indices[I*5] = -1 Then  // Este �ndice est� desprezado
        Continue;
      If (ContLin >= Indices[I*5]) And
         (ContLin <= Indices[(I*5)+1]) Then
        Begin
        RegInd := Copy(Linha,Indices[(I*5)+2],Indices[(I*5)+3]);

        Case Indices[(I*5)+4] Of    { Tratamento de Brancos }
          0 : RegInd := SeTiraBranco(RegInd);
          1 : RegInd := TrimRight(RegInd);
          2 : RegInd := TrimLeft(RegInd);
          3 : Begin End; // Sem Tratamento de Brancos
          4 : RegInd := Trim(RegInd);
          End; {Case}

        If FiltroObj.FiltroIn[I] <> [] Then
           For K := 1 To Length(RegInd) Do
             If Not (RegInd[K] In FiltroObj.FiltroIn[I]) Then
               Begin
               RegInd := '';
               Break;
               End;

        If FiltroObj.FiltroOut[I] <> [] Then
           For K := 1 To Length(RegInd) Do
             If (RegInd[K] In FiltroObj.FiltroOut[I]) Then
               Begin
               RegInd := '';
               Break;
               End;

        If RegInd <> '' Then
          If FiltroObj.StrInc[I].Col <> 0 Then
            If Copy(Linha,FiltroObj.StrInc[I].Col,FiltroObj.StrInc[I].Tam) <> FiltroObj.StrInc[I].FilStr Then
              Begin            { Conteudo difere da linha a ser incluida }
              RegInd := '';
              End;

        If RegInd <> '' Then
          If FiltroObj.StrExc[I].Col <> 0 Then
            If Copy(Linha,FiltroObj.StrExc[I].Col,FiltroObj.StrExc[I].Tam) = FiltroObj.StrExc[I].FilStr Then
              Begin            { Conte�do igual a da linha a ser excluida }
              RegInd := '';
              End;

        If (RegInd <> '') Then
          Begin

//          Tabela[I].Append;      Refer�ncia anterior era I, direto, agora � relativa pela fus�o
          TabelaBde[Fusao[I].IndRef].Append;
          TabelaBde[Fusao[I].IndRef].Fields[1].AsInteger := FilePos(ArqPag); // Soma a Coluna deste �ndice ao relativo at� a linha anterior
          TabelaBde[Fusao[I].IndRef].Fields[2].AsInteger := Relativo + Indices[(I*5)+2];
          TabelaBde[Fusao[I].IndRef].Fields[3].AsInteger := ContLin;
          TabelaBde[Fusao[I].IndRef].Fields[4].AsAnsiString := 'D';

          If TiposDeCampos[I] = 'C' Then
            Try
              TabelaBde[Fusao[I].IndRef].Fields[0].AsAnsiString := RegInd
            Except
              End // Try
          Else
          If TiposDeCampos[I] = 'F' Then
            Begin
            FormatSettings.DecimalSeparator := ',';    // Separador Decimal

            RegAux := '';
            For K := 1 To Length(RegInd) Do
              If (RegInd[K] In ['0'..'9','+','-',',']) Then
                RegAux := RegAux + RegInd[K];

            Posic := Pos('+',RegAux);              // Inverter a posi��o do Sinal
            If Posic = 0 Then
              Posic := Pos('-',RegAux);

            If Posic <> 0 Then
              Begin
              AuxStr := RegAux[Posic];
              Delete(RegAux,Posic,1);
              RegAux := AuxStr + RegAux;
              End;

            RegInd := RegAux;

            Try
              TabelaBde[Fusao[I].IndRef].Fields[0].AsAnsiString := RegInd;
            Except
              End; // Try
            End
          Else
          If TiposDeCampos[I] = 'D' Then
            Begin
            FormatSettings.DecimalSeparator := ',';                           // Separador Decimal
            RegAux := '';
            For K := 1 To Length(RegInd) Do
              If (RegInd[K] In ['0'..'9','+','-','.']) Then
                RegAux := RegAux + RegInd[K];

            Posic := Pos('+',RegAux);              // Inverter a posi��o do Sinal
            If Posic = 0 Then
              Posic := Pos('-',RegAux);

            If Posic <> 0 Then
              Begin
              AuxStr := RegAux[Posic];
              Delete(RegAux,Posic,1);
              RegAux := AuxStr + RegAux;
              End;

            RegInd := RegAux;

            If Pos('.',RegInd) <> 0 Then            // DecimalSeparator = ,
              RegInd[Pos('.',RegInd)] := ',';

            Try
              TabelaBde[Fusao[I].IndRef].Fields[0].AsAnsiString := RegInd;
            Except
              End;
            End
          Else
          If TiposDeCampos[I] = 'N' Then
            Begin
            RegAux := '';
            
{            For K := 1 To Length(RegInd) Do
              If (RegInd[K] In ['0'..'9','+','-']) Then
                RegAux := RegAux + RegInd[K]; }

            For K := 1 To Length(RegInd) Do
              If (RegInd[K] In ['0'..'9']) Then
                RegAux := RegAux + RegInd[K]
              Else
              If (RegInd[K] = '+') And ((K=1) Or (K=Length(RegInd))) Then
                RegAux := RegAux + RegInd[K]
              Else
              If (RegInd[K] = '-') And ((K=1) Or (K=Length(RegInd))) Then
                RegAux := RegAux + RegInd[K];

            Posic := Pos('+',RegAux);              // Inverter a posi��o do Sinal
            If Posic = 0 Then
              Posic := Pos('-',RegAux);

            If Posic <> 0 Then
              Begin
              AuxStr := RegAux[Posic];
              Delete(RegAux,Posic,1);
              RegAux := AuxStr + RegAux;
              End;

            RegInd := RegAux;
            Try
              TabelaBde[Fusao[I].IndRef].Fields[0].AsAnsiString := RegInd;
            Except
              End;
            End
         Else
           If TiposDeCampos[I] = 'Dt' Then
             Begin
             Ano := StrToInt(Copy(RegInd,Mascaras[I].PosAno,Mascaras[I].TamAno));
             If Ano <= 50 Then     // Ano com 2 d�gitos necessita corre��o
               Ano := 2000 + Ano
             Else
               If Ano <= 99 Then
                 Ano := 1900 + Ano;
             Mes := StrToInt(Copy(RegInd,Mascaras[I].PosMes,Mascaras[I].TamMes));
             Dia := StrToInt(Copy(RegInd,Mascaras[I].PosDia,Mascaras[I].TamDia));
             Try
               TabelaBde[Fusao[I].IndRef].Fields[0].AsDateTime := EncodeDate(Ano, Mes, Dia);
             Except
               End; // Try
             End;

          Try
            TabelaBde[Fusao[I].IndRef].Post;
          Except
            TabelaBde[Fusao[I].IndRef].Cancel;
            End; // Try
          End;
        End;
      End;
    End;

  If Not ComprBrancos Then
    Exit;            { usu�rio n�o deseja comprimir brancos }

  Cont := 0;
  Dest := 1;
  I := 1;

  While I <= Length(Linha) Do
    Begin
    If Linha[I] = ' ' Then
      Inc(Cont)
    Else
      Begin
      If Cont > 0 Then       // Houve compress�o de brancos
        Begin
        If Cont >= $80 Then  // Estourou a capacidade do Byte de 7 bits (bit 8 indica brancos comprimidos)
          If Cont <= $FF Then
            Begin
            Linha[Dest] := AnsiChar($80);  // Indica que o pr�ximo byte tem a quantidade real de brancos
            Inc(Dest);
            End
          Else
            Repeat
              Linha[Dest] := AnsiChar($FF);  // Na verdade armazenou um $7F
              Inc(Dest);
              Dec(Cont,$7F);           // Desconta
            Until Cont < $80;
        If Cont <> 0 Then
          Begin
          Cont := Cont Or $80; { Liga o �ltimo bit para informar }
//          Linha[Dest] := AnsiChar(AnsiChar(Cont));    ????????????????
          Linha[Dest] := AnsiChar(Cont);
          Inc(Dest);
          Cont := 0;
          End;
        End;
      Linha[Dest] := Linha[I];
      Inc(Dest);
      End;
    Inc(I);
    End;

  If Cont > 0 Then
    Begin
    If Cont >= $80 Then
      If Cont <= $FF Then
        Begin
        Linha[Dest] := AnsiChar($80);  // Indica que o pr�ximo byte tem a quantidade real de brancos
        Inc(Dest);
        End
      Else
        Repeat
          Linha[Dest] := AnsiChar($FF);  // Na verdade armazenou um $7F
          Inc(Dest);
          Dec(Cont,$7F);           // Desconta
        Until Cont < $80;
    If Cont <> 0 Then
      Begin
      Cont := Cont Or $80; { Liga o �ltimo bit para informar }
      Linha[Dest] := AnsiChar(AnsiChar(Cont));
      Inc(Dest);
      End;
    End;
  SetLength(Linha, (Dest-1));
  End;

  Procedure Filtra;
  Var
    I : Integer;
  Begin
  For I := 1 To Length(Linha) Do
    If Not (Linha[I] In [' '.. '}',^L]) Then
      Linha[I] := ' ';
  End;

  Function InicProc : Boolean;
  Var
    Erro : Integer;
    f : TFileStream;
    strSql : TStringList;
  Begin
  InicProc := False;

  try
    f := TFileStream.Create(Arquivos.Cells[1,1], fmOpenRead);
    Arquivos.Cells[2,1] := formatFloat('###,###,###,###,###',f.Size);
    Divisor := f.Size;
    f.free;
  except
    begin
    Arquivos.Cells[2,1] := formatFloat('###,###,###,###,###',ReportRec.Size);
    Divisor := ReportRec.Size;
    end;
  end;

  Try
    //CloseFile(ArqIn);
  Except
    End;

  AssignFile(ArqIn,Arquivos.Cells[1,1]);
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

    FormGeral.InsereLog(Arquivos.Cells[1,1],'Erro de Abertura. Codigo = '+IntToStr(Erro));
    MoveDelete(Arquivos.Cells[1,1],viDirTrabApl+'NaoProcessados\'+ExtractFileName(Arquivos.Cells[1,1]));
    Exit;
    End;

  //Divisor := StrToInt64(Arquivos.Cells[2,1]);
  If Divisor = 0 Then
    Begin
    Try
      CloseFile(ArqIn);
    Except
      End; // Try

    FormGeral.InsereLog(Arquivos.Cells[1,1],'Arquivo Zerado');
    MoveDelete(Arquivos.Cells[1,1],viDirTrabApl+'NaoProcessados\'+ExtractFileName(Arquivos.Cells[1,1]));
    Exit;
    End;

  // Extrator de dados.........

  // Verifica se o relat�rio deve ter dados extraidos...

  ExtrairDados := False;
  IFrmExtract := 0;
  strSql := TStringList.Create;
  strSql.Clear;
  //strSql.QueryAux1.Close;
  strSql.Add('SELECT * FROM EXTRATOR A ');
  strSql.Add('WHERE A.CODGRUPO = '+IntToStr(CodGrupo));
  strSql.Add('AND A.CODREL = '''+FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString+'''');
  formgeral.ImportarDados(strsql.Text,nil,1);
  If (FormGeral.MemAux1.RecordCount <> 0) Then
    While Not FormGeral.MemAux1.Eof Do
      Begin
      If (FileExists(FormGeral.MemAux1.FieldByName('XTR').AsAnsiString)) Then
        Begin
        // Prepara o path de destino
        Inc(IFrmExtract);
        IndexFrmExtract[IFrmExtract] := TFrmExtract.Create(Self);
        IndexFrmExtract[IFrmExtract].DirDestinoExtract := IncludeTrailingPathDelimiter(FormGeral.QueryAux1.FieldByName('DESTINO').AsAnsiString);
        If FormGeral.MemAux1.FieldByName('DIREXPL').AsAnsiString = 'N' Then
          IndexFrmExtract[IFrmExtract].DirDestinoExtract := IndexFrmExtract[IFrmExtract].DirDestinoExtract + CodAlfa;
        If Trim(FormGeral.MemAux1.FieldByName('SUBDIR').AsAnsiString) <> '' Then
          IndexFrmExtract[IFrmExtract].DirDestinoExtract := IndexFrmExtract[IFrmExtract].DirDestinoExtract +
                               IncludeTrailingPathDelimiter(LimpaNomArq(FormGeral.QueryAux1.FieldByName('SUBDIR').AsAnsiString));
        IndexFrmExtract[IFrmExtract].OperacaoExtract := FormGeral.MemAux1.FieldByName('OPERACAO').AsAnsiString;
        IndexFrmExtract[IFrmExtract].LimparButton.Click; // Limpar a �rea do script de extra��o
        IndexFrmExtract[IFrmExtract].LeScript(FormGeral.MemAux1.FieldByName('XTR').AsAnsiString);
        IndexFrmExtract[IFrmExtract].OrigemDeExecucao := 'I';
        If Trim(FormGeral.MemAux1.FieldByName('ARQUIVO').AsAnsiString) = '' Then
          IndexFrmExtract[IFrmExtract].NomeArqTxt := ''
        Else
          IndexFrmExtract[IFrmExtract].NomeArqTxt := Trim(FormGeral.MemAux1.FieldByName('ARQUIVO').AsAnsiString);
        IndexFrmExtract[IFrmExtract].SaveDialog2.FileName := ChangeFileExt(Arquivos.Cells[1,2],
                                     SeArquivoSemExt(FormGeral.MemAux1.FieldByName('XTR').AsAnsiString)+'.TXT');
        IndexFrmExtract[IFrmExtract].ExecutarButton.Click;
        ExtrairDados := True;
        End;
      FormGeral.MemAux1.Next;
      End;
  FormGeral.MemAux1.Close;

  Paginas := 1;
  PosArq := 0;
  Write(ArqPag,PosAtu);                   { Atualiza Arquivo de Paginas}

  ReadLn(ArqIn,Linha);                    { Leitura do primeiro registro }

  TamanhoOri := Length(Linha);
  Relativo := 0;

  If FiltraCar Then
    Filtra;              { Filtra a primeira linha do relat�rio, Apenas se o filtro est� ativado }

  Inc(ContLin);

  Inc(PosArq,Length(Linha)+2);
  ComprimeBrancos;
//  SetLength(Pagina,0);
//  SetLength(Pagina,133000);
  IPagina := 1;
//  If (IPagina + Length(Linha) + 2) < Length(Pagina) Then
  If (IPagina + Length(Linha) + 2) < Length(PaPagina) Then
    Begin
    Move(Linha[1],PaPagina[IPagina],Length(Linha));
    Inc(Ipagina,Length(Linha)+2);
    PaPagina[IPagina-2] := #13;
    PaPagina[IPagina-1] := #10;
//    Pagina := Pagina + Linha + #13#10;               { come�a a montar a p�gina }
    End;
  Inc(Relativo,TamanhoOri);

  ReadLn(ArqIn,Linha);                        { Leitura do segundo registro }

  TamanhoOri := Length(Linha);

  If FiltraCar Then
    Filtra;

  Inc(ContLin);

  VerificaQuebraDePagina;

  Inc(PosArq,Length(Linha)+2);

  InicProc := True;
  End;

  Procedure ProcTillTheEnd;
  Var
    I : Integer;
  Begin

  BufI := Nil;

  While Not Eof(ArqIn) Do
    Begin
    If QuebrouPagina Then
      Begin
      Inc(Paginas);
      Inc(TotPag);

      If (Paginas Mod QueBraMod) = 0 Then
        Begin
        AtuEst;
        If Paginas > 900 Then
          QuebraMod := 1000
        Else
          If Paginas > 90 Then
            QuebraMod := 100;
        End;

//      SetLength(Pagina,Ipagina-1); // Ajusta

//      BufI := @Pagina[1];
      BufI := @PaPagina[1];

//      ZCompress(BufI,Length(Pagina),BufCmp,TamPagCmp);
      ZCompress(BufI,Ipagina-1,BufCmp,TamPagCmp);

      OutWrite(BufCmp,TamPagCmp);
      FreeMem(BufCmp);

      Inc(TotOut,TamPagCmp);
      Write(ArqPag,PosAtu);       { Atualiza apontador de P�ginas }
      Relativo := 0;
      ContLin := 1;
      QuebrouPagina := False;
      IPagina := 1;
      If ExtrairDados Then
        For I := 1 To IFrmExtract Do
          if IndexFrmExtract[I] <> nil then
            IndexFrmExtract[I].TrabalhaADescompactacao(Paginas);
//      SetLength(Pagina,0);
//      SetLength(Pagina,133000);
      End;

    ComprimeBrancos;
    If (IPagina + Length(Linha) + 2) < Length(PaPagina) Then
      Begin
      Move(Linha[1],PaPagina[IPagina],Length(Linha));
      Inc(Ipagina,Length(Linha)+2);
      PaPagina[IPagina-2] := #13;
      PaPagina[IPagina-1] := #10;
  //    Pagina := Pagina + Linha + #13#10;
      End;
    Inc(Relativo,TamanhoOri);
    ReadLn(ArqIn,Linha);

    TamanhoOri := Length(Linha);
    If FiltraCar Then
      Filtra;
    Inc(ContLin);

    VerificaQuebraDePagina;

    Inc(PosArq,Length(Linha)+2);

    End;
  End;

  Procedure ProcUltimo;
  Var
    I : Integer;
  Begin
  ComprimeBrancos;
//  SetLength(Pagina,Ipagina-1);
//  Pagina := Pagina + Linha + #13#10;
//  BufI := @Pagina[1];
//  ZCompress(BufI,Length(Pagina),BufCmp,TamPagCmp);

  PaPagina[Ipagina] := #13;
  PaPagina[Ipagina+1] := #10;
  Inc(Ipagina, 1); // Para evitar o -1 adiante, soma s� 1
  BufI := @PaPagina[1];
  ZCompress(BufI,Ipagina,BufCmp,TamPagCmp);

  OutWrite(BufCmp,TamPagCmp);
  Inc(TotOut,TamPagCmp);
  If ExtrairDados Then
    For I := 1 To IFrmExtract Do
      Begin
      IndexFrmExtract[I].TrabalhaADescompactacao(Paginas);
      CloseFile(IndexFrmExtract[I].ArqTxt);
      End;
//  SetLength(Pagina,0); { Desaloca mem�ria }
//  ReallocMem(BufI,0);  { = }

  CloseFile(ArqIn);
  AtuEst;
  End;

  Procedure FinalizaProc;

  Begin
  If IndO <> 1 Then
    BlockWrite(ArqOut,BufOut[1],IndO-1,Err);
  CloseFile(ArqOut);
  CloseFile(ArqPag);
  ReallocMem(BufCmp,0);
  Arquivos.Cells[3,2] := Arquivos.Cells[3,2] + ' 100.00%';
  Arquivos.Repaint;
  AvisoP.Close;
  End;

Begin
ProcessaArquivo := False;

II := 1;

If Not PreparaPto1 Then
  Exit;

Repeat { Vai processar *.1 e procurar por complementos *.2 *.3 ... }
  If II <> 1 Then { Para incluir a primeira dos arquivos complemento }
    Begin
    ContLin := 0;
    Inc(TotPag);
    Arquivos.Cells[1,1] := DirIn + ReportRec.Name;
    End;

  If Not InicProc Then
    Exit;

  ProcTillTheEnd;
  ProcUltimo;

  MoveDelete(ChangeFileExt(Arquivos.Cells[1,1],'.'+IntToStr(II)),ChangeFileExt(Arquivos.Cells[1,1], '.P' + IntToStr(II)));
                     
  If (viBackAutoSN = 'S') And (BackupFonte) Then
    Begin
    DirBack := viDirBackAuto + FormatDateTime('YYYY',Agora) + '\' + FormatDateTime('MM',Agora) + '\' +
                                   FormatDateTime('DD',Agora) + '\' + FormatDateTime('HH',Agora) + '\' +
                                   FormatDateTime('YYYYMMDD_HHNNSS',Agora);
    ForceDirectories(DirBack);
    MoveDelete(ChangeFileExt(Arquivos.Cells[1,1], '.P' + IntToStr(II)),
               DirBack+'\' + ChangeFileExt(ExtractFileName(Arquivos.Cells[1,1]), '.P' + IntToStr(II)));
    End
  Else
    SysUtils.DeleteFile(ChangeFileExt(Arquivos.Cells[1,1], '.P' + IntToStr(II)));

  Inc(II);

  ReportStr := DirIn + SeArquivoSemExt(ReportRec.Name) + '.' + IntToStr(II);

Until (FindFirst(ReportStr,FaAnyFile,ReportRec) <> 0);

FinalizaProc;

ProcessaArquivo := True;

end;

Procedure TFormIndex.SairSpeedButtonClick(Sender: TObject);
Begin
Close;
End;

Procedure TFormIndex.ProcessarSpeedButtonClick(Sender: TObject);
Var
  CodigoDoSistema,
  ISubDirAuto,
//  CodGrupo,
  PosLin : Integer;
//  AcessoExclusivo,
  GrupoAutomatico,
  SubDirAutomatico,
  SistemaAutomatico : Boolean;
//  AutoSubDir,
//  CodAlfa,
  SubGrupo,
  Ano : AnsiString;
  strSql : TStringList;

  Function TrataPto1(Arquivo : AnsiString; LinRet : Integer; Var Linha : AnsiString; TrataErro : Boolean) : Boolean;
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

    FormGeral.InsereLog(Arquivo,'Erro de Abertura. Codigo = '+IntToStr(Erro));
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
      If TrataErro Then
        Begin
        Try
          CloseFile(ArqIn);
        Except
          End; // Try

        FormGeral.InsereLog(Arquivo,'Erro de Leitura. Codigo = '+IntToStr(Erro));
        MoveDelete(Arquivo, viDirTrabApl+'NaoProcessados\'+ExtractFileName(Arquivo));
        Exit;
        End
      Else
        Exit;  
    Inc(PosLin);
    ArPagina[PosLin] := Linha;
    End;

  CloseFile(ArqIn);
  TrataPto1 := True;
  End;

//  Procedure TrataAutoSubDir;
//  Begin
//  AutoSubDir := FormGeral.TableDestinosDFN.FieldByName('AutoSubDir').AsAnsiString;
//  If AutoSubDir <> '' Then
//    Begin
//    While Pos('A',AutoSubDir) <> 0 Do
//      AutoSubDir[Pos('A',AutoSubDir)] := 'Y';
//    AutoSubDir := IncludeTrailingPathDelimiter(FormatDateTime(AutoSubDir,Agora));
//    End;
//  End;

  Function PreparacaoParaJuncao : Integer;
  Var
    I, J, K,
    NumDats : Integer;
    SearchRec : TSearchRec;
    CodRel : AnsiString;
    IFusao : Array Of Integer;
  Begin
  RichEdit1.Lines.Add('');
  RichEdit1.Lines.Add('Preparando para a jun��o autom�tica: '+ReportRec.Name);

  RichEdit1.Lines.Add('Obtendo um diret�rio destino...');
  Result := 0;

//  FormGeral.QueryDestinosDFN.Params[0].AsAnsiString := FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString;
  strSql.Clear;
  strSql.Add(' SELECT     *             ');
  strSql.Add(' FROM         DESTINOSDFN ');
  strSql.Add(' WHERE     (CODREL = ' + FormGeral.Memtb.FieldByName('CodRel').AsAnsiString + ')  ');
  strSql.Add(' AND TIPODESTINO = ' + QuotedStr('Dir') );
  formGeral.ImportarDados(strSql.Text, nil);
  //FormGeral.QueryDestinosDFN.Parameters[0].Value := FormGeral.Memtb.FieldByName('CodRel').AsAnsiString;
  //FormGeral.QueryDestinosDFN.Open;
//  FormGeral.TableDestinosDFN.Filter := 'CODREL = '''+FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString+''''+
//            ' AND TIPODESTINO = ''Dir''';
//  FormGeral.TableDestinosDFN.Filtered := True;
  If FormGeral.Memtb.Eof Then
    Begin
    Result := 1;
    FormGeral.Memtb.Close;     // Sem destino, sai fora...
    Exit;
    End;
//  TrataAutoSubDir;
//  DirDest := IncludeTrailingPathDelimiter(FormGeral.TableDestinosDFN.FieldByName('Destino').AsAnsiString) + CodAlfa + AutoSubDir;
  If FormGeral.Memtb.FieldByName('DirExpl').AsAnsiString = 'S' Then
    DirDest := IncludeTrailingPathDelimiter(FormGeral.Memtb.FieldByName('Destino').AsAnsiString)
  Else
    DirDest := IncludeTrailingPathDelimiter(FormGeral.Memtb.FieldByName('Destino').AsAnsiString) + CodAlfa;
  FormGeral.Memtb.Close;

  RichEdit1.Lines.Add('Verificando o n�mero de dats no destino '+DirDest);
  NumDats := 0;
  If FindFirst(DirDest+'*.dat', FaAnyFile, SearchRec) = 0 Then
    Repeat
      Inc(NumDats);
      NomeDat := SeArquivoSemExt(SearchRec.Name);
    Until FindNext(SearchRec) <> 0;
  SysUtils.FindClose(SearchRec);
  If NumDats = 0 Then
    Begin
    Result := 2;
    Exit;
    End;
  If NumDats > 1 Then
    Begin
    Result := 3;
    Exit;
    End;

  RichEdit1.Lines.Add('Verificando os �ndices...');

  AssignFile(ArqCNFGVJunta,DirDest+ChangeFileExt(SearchRec.Name,'Dfn.Dfn'));
  Reset(ArqCNFGVJunta);
  I := 0;
  While Not Eof(ArqCNFGVJunta) Do
    Begin
    Read(ArqCNFGVJunta,RegIndice);
    If RegIndice.TipoReg = 2 Then
      Begin
      Inc(I);
      CodRel := RegIndice.CODREL_;
      End;
    End;

//  FormGeral.QueryIndicesDFN.Params[0].AsAnsiString := CodRel;
  //FormGeral.QueryIndicesDFN.Parameters[0].Value := CodRel;
  //FormGeral.QueryIndicesDFN.Open;
//  FormGeral.TableIndicesDFN.Filter := 'CODREL = '''+CodRel+'''';
//  FormGeral.TableIndicesDFN.Filtered := True;

  strSql.Clear;
  strSql.Add(' SELECT * FROM INDICESDFN WHERE (CODREL = ' + CodRel + ')');
  FormGeral.ImportarDados(strSql.Text, nil);
  While Not FormGeral.Memtb.Eof Do
    FormGeral.Memtb.Next;

  SetLength(IFusao,FormGeral.Memtb.RecordCount);
  For J := 0 To FormGeral.Memtb.RecordCount-1 Do
    IFusao[J] := MaxInt;

  FormGeral.Memtb.First;
  K := 0;

  While Not FormGeral.Memtb.Eof Do
    Begin
    If (K <> 0) And (Not VarIsNull(FormGeral.Memtb.FieldByName('Fusao').Value)) Then
      For J := 0 To K-1 Do
        If (IFusao[J] = FormGeral.Memtb.FieldByName('Fusao').AsInteger) Then
          Begin
          Inc(I);
          Break;
          End;
        
    If (Not VarIsNull(FormGeral.Memtb.FieldByName('Fusao').Value)) Then
      IFusao[K] := FormGeral.Memtb.FieldByName('Fusao').AsInteger;

    FormGeral.Memtb.Next;
    Inc(K);
    End;

  SetLength(IFusao,0);

  If FormGeral.Memtb.RecordCount <> I Then
    Begin
//    FormGeral.TableIndicesDFN.Filtered := False;
    FormGeral.Memtb.Close;
    CloseFile(ArqCNFGVJunta);
    Result := 4;  // Campo indexador antigo n�o existe mais...
    Exit;
    End;

  Seek(ArqCNFGVJunta,0); // Volta ao in�cio;

  While Not Eof(ArqCNFGVJunta) Do
    Begin
    Read(ArqCNFGVJunta,RegIndice);
    If RegIndice.TipoReg <> 2 Then
      Continue;
//    FormGeral.QueryIndicesDFNII.Params[0].AsAnsiString := RegIndice.CODREL_;
//    FormGeral.QueryIndicesDFNII.Params[1].AsAnsiString := RegIndice.NOMECAMPO;
    strSql.Clear;
    strSql.Add(' SELECT * FROM INDICESDFN WHERE (CODREL = ' + RegIndice.CODREL_ + ')');
    strSql.Add(' AND (NOMECAMPO = ' + RegIndice.NOMECAMPO + ')' );
    FormGeral.ImportarDados(strSql.Text, nil);

    //FormGeral.QueryIndicesDFNII.Parameters[0].Value := RegIndice.CODREL_;
    //FormGeral.QueryIndicesDFNII.Parameters[1].Value := RegIndice.NOMECAMPO;

    FormGeral.Memtb.Open;
//    FormGeral.TableIndicesDFN.Filter := 'CODREL = '''+RegIndice.CODREL_+''''+
//              ' AND NOMECAMPO = '''+RegIndice.NOMECAMPO+'''';
//    FormGeral.TableIndicesDFN.Filtered := True;
    If FormGeral.Memtb.Eof Then
      Begin
//      FormGeral.TableIndicesDFN.Filtered := False;
      FormGeral.Memtb.Close;
      CloseFile(ArqCNFGVJunta);
      Result := 5;  // Campo indexador antigo n�o existe mais...
      Exit;
      End;

    If (RegIndice.LINHAI <> FormGeral.Memtb.FieldByName('LINHAI').AsInteger) Or
       (RegIndice.LINHAF <> FormGeral.Memtb.FieldByName('LINHAF').AsInteger) Or
       (RegIndice.COLUNA <> FormGeral.Memtb.FieldByName('COLUNA').AsInteger) Or
       (RegIndice.TAMANHO <> FormGeral.Memtb.FieldByName('TAMANHO').AsInteger) Or
       (RegIndice.BRANCO <> FormGeral.Memtb.FieldByName('BRANCO').AsAnsiString) Or
       (RegIndice.TIPOCAMPO <> FormGeral.Memtb.FieldByName('TIPO').AsAnsiString) Then
      Begin
//      FormGeral.TableIndicesDFN.Filtered := False;
      FormGeral.Memtb.Close;
      CloseFile(ArqCNFGVJunta);
      Result := 6;  // Defini��o anterior do campo foi modificada...
      Exit;
      End;
//    FormGeral.TableIndicesDFN.Filtered := False;
    FormGeral.Memtb.Close;
    End;

  CloseFile(ArqCNFGVJunta);
  RichEdit1.Lines.Add('Relat�rio ok para a jun��o autom�tica...');
  End;

  Function PreparaColIndex : Boolean;
  Var
    J,K,L : Integer;
    auxStr : AnsiString;
    SearchRec : TSearchRec;
  Begin
  Result := False;
  If Result Then;

  RegDFN.TipoReg := 1;
  RegDFN.CODREL := FormGeral.MemAux2.Fields[00].AsAnsiString;
  RegDFN.NOMEREL := FormGeral.MemAux2.Fields[01].AsAnsiString;

  RegSistema.TipoReg := 4;
  RegSistema.CODSIS := FormGeral.MemAux2.Fields[02].AsInteger;

  RegSisAuto.TipoReg := 6;
  RegSisAuto.SISAUTO := FormGeral.MemAux2.FieldByName('SISAUTO').AsBoolean;
  RegSisAuto.CODSISREAL := CodigodoSistema;

  RegDFN.CODGRUPO := FormGeral.MemAux2.Fields[03].AsInteger;
  RegDFN.CODSUBGRUPO := FormGeral.MemAux2.Fields[04].AsInteger;
  RegDFN.IDCOLUNA1 := FormGeral.MemAux2.Fields[05].AsInteger;
  RegDFN.IDLINHA1 := FormGeral.MemAux2.Fields[06].AsInteger;
  RegDFN.IDSTRING1 := FormGeral.MemAux2.Fields[07].AsAnsiString;
  Try
    RegDFN.IDCOLUNA2 := FormGeral.MemAux2.Fields[08].AsInteger;
    RegDFN.IDLINHA2 := FormGeral.MemAux2.Fields[09].AsInteger;
  Except
    End; // Try
  RegDFN.IDSTRING2 := FormGeral.MemAux2.Fields[10].AsAnsiString;
  RegDFN.DIRENTRA := StringReplace(FormGeral.MemAux2.Fields[11].AsAnsiString,'/','\',[rfReplaceAll, rfIgnoreCase]);
  RegDFN.TIPOQUEBRA := FormGeral.MemAux2.Fields[12].AsInteger;
  Try
    RegDFN.COLQUEBRASTR1 := FormGeral.MemAux2.Fields[13].AsInteger;
  Except
    End; // Try
  RegDFN.STRQUEBRASTR1 := FormGeral.MemAux2.Fields[14].AsAnsiString;
  Try
    RegDFN.COLQUEBRASTR2 := FormGeral.MemAux2.Fields[15].AsInteger;
  Except
    End; // Try
  RegDFN.STRQUEBRASTR2 := FormGeral.MemAux2.Fields[16].AsAnsiString;
  Try
    RegDFN.QUEBRAAFTERSTR := FormGeral.MemAux2.Fields[17].AsBoolean;
  Except
    End;
  Try
    RegDFN.NLINHASQUEBRALIN := FormGeral.MemAux2.Fields[18].AsInteger;
  Except
    End;
  RegDFN.FILTROCAR := FormGeral.MemAux2.Fields[19].AsBoolean;
  RegDFN.COMPRBRANCOS := FormGeral.MemAux2.Fields[20].AsBoolean;
  RegDFN.JUNCAOAUTOM := FormGeral.MemAux2.Fields[21].AsBoolean;
  RegDFN.QTDPAGSAPULAR := FormGeral.MemAux2.Fields[22].AsInteger;
  RegDFN.CODGRUPAUTO := FormGeral.MemAux2.Fields[23].AsBoolean;
  Try
    RegDFN.COLGRUPAUTO := FormGeral.MemAux2.Fields[24].AsInteger;
    RegDFN.LINGRUPAUTO := FormGeral.MemAux2.Fields[25].AsInteger;
    RegDFN.TAMGRUPAUTO := FormGeral.MemAux2.Fields[26].AsInteger;
    RegDFN.TIPOGRUPAUTO := FormGeral.MemAux2.Fields[27].AsAnsiString;
  Except
    End;
  RegDFN.BACKUP := FormGeral.MemAux2.Fields[28].AsBoolean;
  RegDFN.SUBDIRAUTO := FormGeral.MemAux2.Fields[29].AsBoolean;

//  FormGeral.QueryIndicesDFN.Params[0].AsAnsiString := FormGeral.QueryAux2.FieldByName('CODREL').AsAnsiString;
  //FormGeral.QueryIndicesDFN.Parameters[0].Value := FormGeral.QueryAux2.FieldByName('CODREL').AsAnsiString;
  //FormGeral.QueryIndicesDFN.Open;

  strSql.Clear;
  strSql.Add(' SELECT * FROM INDICESDFN WHERE (CODREL = ' + QuotedStr(FormGeral.MemAux2.FieldByName('CODREL').AsAnsiString) + ')');
  FormGeral.ImportarDados(strSql.Text, nil);
//  FormGeral.TableIndicesDFN.Filter := 'CODREL = '''+FormGeral.QueryAux2.FieldByName('CODREL').AsAnsiString+'''';
//  FormGeral.TableIndicesDFN.Filtered := True;
  if FormGeral.Memtb.Active = False then
  begin
    result := True;
    exit;
  end;
  While Not FormGeral.Memtb.Eof Do     //Romero
    FormGeral.Memtb.Next;
  FormGeral.Memtb.First;

  SetLength(TabelaBde, FormGeral.Memtb.RecordCount);  // Come�aremos a base do array em 0, Aten��o!!!
  SetLength(TabelaAds, FormGeral.Memtb.RecordCount);  // Come�aremos a base do array em 0, Aten��o!!!
  SetLength(Indices,( 5 * FormGeral.Memtb.RecordCount )); // H� 5 campos num�ricos nos �ndices
  SetLength(TiposDeCampos, FormGeral.Memtb.RecordCount);
  SetLength(NomesDeCampos, FormGeral.Memtb.RecordCount);
  SetLength(Mascaras, FormGeral.Memtb.RecordCount);
  SetLength(Fusao, FormGeral.Memtb.RecordCount);
  SetLength(FiltroObj.FiltroIn, FormGeral.Memtb.RecordCount);
  SetLength(FiltroObj.FiltroOut, FormGeral.Memtb.RecordCount);
  SetLength(FiltroObj.StrInc, FormGeral.Memtb.RecordCount);
  SetLength(FiltroObj.StrExc, FormGeral.Memtb.RecordCount);

  For J := 0 To Length(Indices)-1 Do
    Indices[J] := 0;

  For J := 1 To MaxLinhasPorPag Do
    LinhasInd[J] := False;

  For J := 0 To Length(Fusao)-1 Do
    Begin
    Fusao[J].CodFusao := MaxInt;
    Fusao[J].IndRef := J; // A refer�ncia � ela mesmo. Se houver fusao, haver� troca da refer�ncia
    Fusao[J].IndiceGerado := True;
    End;

  FillChar(ArrRegIndice,SizeOf(ArrRegIndice),0);

  For K := 0 To FormGeral.Memtb.RecordCount-1 Do
    Begin

    If (K <> 0) and (not FormGeral.Memtb.FieldByName('Fusao').IsNull) and
       (FormGeral.Memtb.FieldByName('Fusao').AsString <> '') then
    //And (Not VarIsNull(FormGeral.Memtb.FieldByName('Fusao').Value)) Then
      For L := 0 To K-1 Do
        If (FormGeral.Memtb.FieldByName('Fusao').AsInteger = Fusao[L].CodFusao) And
           (FormGeral.Memtb.FieldByName('Tipo').AsAnsiString = ArrRegIndice[L].TIPOCAMPO) Then
          Begin
          Fusao[K].IndRef := L;
          Fusao[K].IndiceGerado := False;
          Break;
          End;

    //If (Not VarIsNull(FormGeral.Memtb.FieldByName('Fusao').Value)) Then
    if (not FormGeral.Memtb.FieldByName('Fusao').IsNull) and
       (FormGeral.Memtb.FieldByName('Fusao').AsString <> '') then
      Fusao[K].CodFusao := FormGeral.Memtb.FieldByName('Fusao').AsInteger;

    If K < 200 Then
      Begin
      ArrRegIndice[K].TipoReg := 2;
      ArrRegIndice[K].CODREL_ := FormGeral.Memtb.FieldByName('CodRel').AsAnsiString;
      ArrRegIndice[K].NOMECAMPO := FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString;
      ArrRegIndice[K].LINHAI := FormGeral.Memtb.FieldByName('LinhaI').AsInteger;
      ArrRegIndice[K].LINHAF := FormGeral.Memtb.FieldByName('LinhaF').AsInteger;
      ArrRegIndice[K].COLUNA := FormGeral.Memtb.FieldByName('Coluna').AsInteger;
      ArrRegIndice[K].TAMANHO := FormGeral.Memtb.FieldByName('Tamanho').AsInteger;
      ArrRegIndice[K].BRANCO := FormGeral.Memtb.FieldByName('Branco').AsAnsiString;
      ArrRegIndice[K].TIPOCAMPO := FormGeral.Memtb.FieldByName('Tipo').AsAnsiString;
      ArrRegIndice[K].MASCARA := FormGeral.Memtb.FieldByName('Mascara').AsAnsiString;
      ArrRegIndice[K].CHARINC := FormGeral.Memtb.FieldByName('CharInc').AsAnsiString;
      ArrRegIndice[K].CHAREXC := FormGeral.Memtb.FieldByName('CharExc').AsAnsiString;
      ArrRegIndice[K].STRINC := FormGeral.Memtb.FieldByName('StrInc').AsAnsiString;
      ArrRegIndice[K].STREXC := FormGeral.Memtb.FieldByName('StrExc').AsAnsiString;
      End;

    Indices[K*5] := FormGeral.Memtb.FieldByName('LinhaI').AsInteger;
    Indices[(K*5)+1] := FormGeral.Memtb.FieldByName('LinhaF').AsInteger;
    Indices[(K*5)+2] := FormGeral.Memtb.FieldByName('Coluna').AsInteger;
    Indices[(K*5)+3] := FormGeral.Memtb.FieldByName('Tamanho').AsInteger;
    Indices[(K*5)+4] := FormGeral.Memtb.FieldByName('Branco').AsInteger;

    For J := Indices[K*5] To Indices[(K*5)+1] Do   // Da LinhaI at� a LinhaF
      LinhasInd[J] := True;

    TabelaBde[K] := TTable.Create(FormIndex);
    TabelaAds[K] := TTable.Create(FormIndex);

    TabelaBde[K].Active := False;
    TabelaAds[K].Active := False;

    TabelaBde[K].TableLevel := 4;

    TabelaAds[K].DatabaseName := viDirTrabApl + 'Temp\';
    TabelaBde[K].DatabaseName := viDirTrabApl + 'Temp\';

    TabelaBde[K].TableName := SeArquivoSemExt(ReportRec.Name) + StatusBar1.Panels[0].Text +
                           FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString + '.dbf'; // Romero em 23/07/2013 para evitar os problemsa dos m�ltiplos pontos da Caixa!!!
    TabelaAds[K].TableName := SeArquivoSemExt(ReportRec.Name) + StatusBar1.Panels[0].Text +
                           FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString + '.dbf'; // Romero em 23/07/2013 para evitar os problemsa dos m�ltiplos pontos da Caixa!!!

    TabelaBde[K].TableType := ttDbase;
    TabelaAds[K].TableType := ttDbase;

    TabelaBde[K].FieldDefs.Clear;
    TabelaBde[K].IndexDefs.Clear;
    TabelaAds[K].FieldDefs.Clear;
    TabelaAds[K].IndexDefs.Clear;

    TiposDeCampos[K] := FormGeral.Memtb.FieldByName('Tipo').AsAnsiString;
    NomesDeCampos[K] := FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString;
    If FormGeral.Memtb.FieldByName('Tipo').AsAnsiString = 'C' Then
      Begin
      TabelaBde[K].FieldDefs.Add('VALOR',ftString,Indices[(K*5)+3],False);    // Tamanho do Campo
      TabelaAds[K].FieldDefs.Add('VALOR',ftString,Indices[(K*5)+3],False)    // Tamanho do Campo
      End
    Else
    If (FormGeral.Memtb.FieldByName('Tipo').AsAnsiString = 'F') Or
       (FormGeral.Memtb.FieldByName('Tipo').AsAnsiString = 'D') Then
      Begin
      TabelaBde[K].FieldDefs.Add('VALOR',ftFloat,0,False);
      TabelaAds[K].FieldDefs.Add('VALOR',ftFloat,0,False)
      End
    Else
    If (FormGeral.Memtb.FieldByName('Tipo').AsAnsiString = 'N') Then // L� na frente ser� usado um create table para os casos destes campos num�ricos...
      Begin                                                                // Este c�digo ficar� obsoleto...
      If Indices[(K*5)+3] <= 4 Then                                        // hummmm acho que vamos tirar l� por causa do Advantage!!!
        Begin
        TabelaBde[K].FieldDefs.Add('VALOR',ftSmallint,0,False);
        TabelaAds[K].FieldDefs.Add('VALOR',ftSmallint,0,False)
        End
      Else
        If Indices[(K*5)+3] <= 9 Then
          Begin
          TabelaBde[K].FieldDefs.Add('VALOR',ftInteger,0,False);
          TabelaAds[K].FieldDefs.Add('VALOR',ftInteger,0,False)
          End
        Else
          Begin
          TabelaBde[K].FieldDefs.Add('VALOR',ftFloat,0,False);
          TabelaAds[K].FieldDefs.Add('VALOR',ftFloat,0,False)
          End
      End
    Else
    If FormGeral.Memtb.FieldByName('Tipo').AsAnsiString = 'Dt' Then
      Begin
      auxStr := UpperCase(FormGeral.Memtb.FieldByName('Mascara').AsAnsiString);
      Mascaras[K].PosAno := Pos('A',auxStr);
      Mascaras[K].PosMes := Pos('M',auxStr);
      Mascaras[K].PosDia := Pos('D',auxStr);

      If Mascaras[K].PosAno <> 0 Then
        Begin
        J := Mascaras[K].PosAno;
        While (J <= Length(auxStr)) And (auxStr[J] = 'A') Do
          Inc(J);
        Mascaras[K].TamAno := J - Mascaras[K].PosAno;
        End
      Else
        Mascaras[K].TamAno := 0;

      If Mascaras[K].PosMes <> 0 Then
        Begin
        J := Mascaras[K].PosMes;
        While (J <= Length(auxStr)) And (auxStr[J] = 'M') Do
          Inc(J);
        Mascaras[K].TamMes := J - Mascaras[K].PosMes;
        End
      Else
        Mascaras[K].TamMes := 0;

      If Mascaras[K].PosDia <> 0 Then
        Begin
        J := Mascaras[K].PosDia;
        While (J <= Length(auxStr)) And (auxStr[J] = 'D') Do
          Inc(J);
        Mascaras[K].TamDia := J - Mascaras[K].PosDia;
        End
      Else
        Mascaras[K].TamDia := 0;

      If (Not (Mascaras[K].TamAno In [2,4])) Or
         (Not (Mascaras[K].TamMes In [1,2])) Or
         (Not (Mascaras[K].TamDia In [1,2])) Then
        Begin
        FormGeral.InsereLog(FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString,
                  'M�scara de Campo Dt Inv�lida, �ndice descartado. Valor Original = '+
                  FormGeral.QueryIndicesDFN.FieldByName('Mascara').AsAnsiString);
        Indices[K*5] := -1;  // -1 Indica �ndice descartado;
        FormGeral.Memtb.Next;
        Continue;
        End;

      TabelaBde[K].FieldDefs.Add('VALOR',ftDate,0,False);
      TabelaAds[K].FieldDefs.Add('VALOR',ftDate,0,False);
      End
    Else
      Begin
      FormGeral.InsereLog(FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString,
                'Tipo de Campo Inv�lido, �ndice descartado. Valor Original = '+
                FormGeral.Memtb.FieldByName('Tipo').AsAnsiString);
      Indices[K*5] := -1;  // -1 Indica �ndice descartado;
      FormGeral.Memtb.Next;
      Continue;
      End;

    FiltroObj.FiltroIn[K] := [];
    If FormGeral.Memtb.FieldByName('CharInc').AsAnsiString <> '' then
      If Not FiltroObj.EncheFiltro(FormGeral.Memtb.FieldByName('CharInc').AsAnsiString, ReportRec.Name,
                                   FiltroObj.FiltroIn[K],K) Then
        Begin
        FormGeral.InsereLog(FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString,
                  'CharInc Inv�lido, �ndice descartado. Valor Original = '+
                  FormGeral.Memtb.FieldByName('CharInc').AsAnsiString);
        Indices[K*5] := -1;  // -1 Indica �ndice descartado;
        FormGeral.Memtb.Next;
        Continue;
        End;

    FiltroObj.FiltroOut[K] := [];
    If FormGeral.Memtb.FieldByName('CharExc').AsAnsiString <> '' then
      If Not FiltroObj.EncheFiltro(FormGeral.Memtb.FieldByName('CharExc').AsAnsiString, ReportRec.Name,
                                   FiltroObj.FiltroOut[K],K) Then
        Begin
        FormGeral.InsereLog(FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString,
                  'CharExc Inv�lido, �ndice descartado. Valor Original = '+
                  FormGeral.Memtb.FieldByName('CharExc').AsAnsiString);
        Indices[K*5] := -1;  // -1 Indica �ndice descartado;
        FormGeral.Memtb.Next;
        Continue;
        End;

    FiltroObj.StrInc[K].Col := 0;
    FiltroObj.StrInc[K].Tam := 0;
    FiltroObj.StrInc[K].FilStr := '';
    If FormGeral.Memtb.FieldByName('StrInc').AsAnsiString <> '' then
      If Not FiltroObj.EncheStr(FormGeral.Memtb.FieldByName('StrInc').AsAnsiString, ReportRec.Name,
                                FiltroObj.StrInc[K],K) Then
        Begin
        FormGeral.InsereLog(FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString,
                  'StrInc Inv�lido, �ndice descartado. Valor Original = '+
                  FormGeral.Memtb.FieldByName('StrInc').AsAnsiString);
        Indices[K*5] := -1;  // -1 Indica �ndice descartado;
        FormGeral.Memtb.Next;
        Continue;
        End;

    FiltroObj.StrExc[K].Col := 0;
    FiltroObj.StrExc[K].Tam := 0;
    FiltroObj.StrExc[K].FilStr := '';
    If FormGeral.Memtb.FieldByName('StrExc').AsAnsiString <> '' then
      If Not FiltroObj.EncheStr(FormGeral.Memtb.FieldByName('StrExc').AsAnsiString, ReportRec.Name,
                                FiltroObj.StrExc[K],K) Then
        Begin
        FormGeral.InsereLog(FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString,
                  'StrExc Inv�lido, �ndice descartado. Valor Original = '+
                  FormGeral.Memtb.FieldByName('StrExc').AsAnsiString);
        Indices[K*5] := -1;  // -1 Indica �ndice descartado;
        FormGeral.Memtb.Next;
        Continue;
        End;

    TabelaBde[K].FieldDefs.Add('PAGINA',ftInteger,0,False);
    TabelaBde[K].FieldDefs.Add('RELATIVO',ftWord,0,False);
    TabelaBde[K].FieldDefs.Add('LINHA',ftWord,0,False);
    TabelaBde[K].FieldDefs.Add('DUMMY',ftString,1,False);

    TabelaAds[K].FieldDefs.Add('PAGINA',ftInteger,0,False);
    TabelaAds[K].FieldDefs.Add('RELATIVO',ftWord,0,False);
    TabelaAds[K].FieldDefs.Add('LINHA',ftWord,0,False);
    TabelaAds[K].FieldDefs.Add('DUMMY',ftString,1,False);

    If Fusao[K].IndiceGerado Then // Aqui havia um problema com cria��o dos campos num�ricos inteiros por causa da transla��o do tipo (Small, int e Float)
      Begin                       // Para resolver isso, no caso destes campos, passamos a usar um sql = create table que cria o campo no tamanho exato necess�rio...
{      If (FormGeral.QueryIndicesDFN.FieldByName('Tipo').AsAnsiString = 'N') Then
        Begin
        Query1.Close;
        Query1.SQL.Clear;
        Query1.Sql.Add('CREATE TABLE "' + viDirTrabApl + 'Temp\'+SeArquivoSemExt(ReportRec.Name) + StatusBar1.Panels[0].Text +
                        FormGeral.QueryIndicesDFN.FieldByName('NomeCampo').AsAnsiString+'.dbf"');

        Query1.Sql.Add('(');
        Query1.Sql.Add('VALOR NUMERIC(' + IntToStr(Indices[(K*5)+3]) + ',0), ');
        Query1.Sql.Add('PAGINA NUMERIC(11,0), ');
        Query1.Sql.Add('RELATIVO NUMERIC(6,0), ');
        Query1.Sql.Add('LINHA NUMERIC(6,0), ');
        Query1.Sql.Add('DUMMY AnsiChar(1) ');
        Query1.Sql.Add(')');
        Query1.ExecSQL;

        End
      Else }
        TabelaBde[K].CreateTable;     // S� Criamos a tabela no BDE, pois s� a indexaremos no Ads
      End;

    If JuncaoAutomatica Then      // Vai inserir os registros das tabelas anteriores...
      Begin
      If FindFirst(DirDest+NomeDat+FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString+'*.dbf', FaAnyFile, SearchRec) = 0 Then     // Copia os dbfs
        Begin
        RichEdit1.Lines.Add('Copiando valores do �ndice '+FormGeral.QueryIndicesDFN.FieldByName('NomeCampo').AsAnsiString);

        //Query1.Close;
        //Query1.Sql.Clear;
        strsql.Clear;
        strsql.Add('INSERT INTO "' + viDirTrabApl + 'Temp\'+SeArquivoSemExt(ReportRec.Name) + StatusBar1.Panels[0].Text +
                        FormGeral.Memtb.FieldByName('NomeCampo').AsAnsiString+'"');
        FormGeral.Persistir(strsql.Text,nil);
        //Query1.Sql.Add('INSERT INTO "' + viDirTrabApl + 'Temp\'+SeArquivoSemExt(ReportRec.Name) + StatusBar1.Panels[0].Text +
        //                FormGeral.QueryIndicesDFN.FieldByName('NomeCampo').AsAnsiString+'"');
        //Query1.Sql.Add('SELECT * FROM "'+DirDest+SearchRec.Name+'"');

        //Query1.ExecSQL;
        End;
      SysUtils.FindClose(SearchRec);
      End;

    If Fusao[K].IndiceGerado Then
      TabelaBde[K].Open;

    FormGeral.Memtb.Next;
    End;
  FormGeral.Memtb.Close;

  Result := True;

  End;

  Procedure IndexaCampos;
  Var
    I : Integer;
  Begin

  For I := 0 To Length(TabelaBde)-1 Do
    Try
      TabelaBde[I].Close;
    Except
      End;

  For I := 0 To Length(TabelaBde)-1 Do
    Begin
    If Fusao[I].IndiceGerado Then
      Begin
      AvisoP.Label1.Caption := 'Indexando '+NomesDeCampos[I];
      AvisoP.Show;
      AvisoP.RePaint;
      strsql.Clear;
      strsql.Add(' INSERT INTO PROTOCOLO VALUES (');
      strsql.Add( QuotedStr(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString)  + ',');
      strsql.Add( QuotedStr(FormGeral.MemAux2.FieldByName('NomeRel').AsAnsiString) + ',');
      strsql.Add( FormGeral.MemAux2.FieldByName('CodSis').AsString     + ',');
      strsql.Add( FormGeral.MemAux2.FieldByName('CodGrupo').AsString   + ',');
      strsql.Add( FormGeral.MemAux2.FieldByName('CodSubGrupo').AsString+ ',');
      strsql.Add( IntToStr(CodGrupo) + ',');
      strsql.Add( QuotedStr(ExtractFileName(Arquivos.Cells[1,1])) + ',');
      strsql.Add( QuotedStr(StatusBar1.Panels[0].Text) + ',');
      strsql.Add( QuotedStr(ExtractFileName(TabelaBde[I].TableName)) + ',');
      strsql.Add( QuotedStr(FormatDateTime('dd-mm-yyyy', now)) + ',');
      strsql.Add( QuotedStr(FormatDateTime('dd-mm-yyyy', now)) + ',');


      {
      FormGeral.QueryInsertProtocolo.Parameters[0].Value := FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString;
      FormGeral.QueryInsertProtocolo.Parameters[1].Value := FormGeral.QueryAux2.FieldByName('NomeRel').AsAnsiString;
      FormGeral.QueryInsertProtocolo.Parameters[2].Value := FormGeral.QueryAux2.FieldByName('CodSis').AsInteger;
      FormGeral.QueryInsertProtocolo.Parameters[3].Value := FormGeral.QueryAux2.FieldByName('CodGrupo').AsInteger;
      FormGeral.QueryInsertProtocolo.Parameters[4].Value := FormGeral.QueryAux2.FieldByName('CodSubGrupo').AsInteger;
      FormGeral.QueryInsertProtocolo.Parameters[5].Value := CodGrupo;
      FormGeral.QueryInsertProtocolo.Parameters[6].Value := ExtractFileName(Arquivos.Cells[1,1]);
      FormGeral.QueryInsertProtocolo.Parameters[7].Value := StatusBar1.Panels[0].Text;
      FormGeral.QueryInsertProtocolo.Parameters[8].Value := ExtractFileName(TabelaBde[I].TableName);
      FormGeral.QueryInsertProtocolo.Parameters[9].Value := Now;
      FormGeral.QueryInsertProtocolo.Parameters[10].Value := Now;
      }
{      If TiposDeCampos[I] = 'C' Then
        Begin
        HalcyonDataSet1.DatabaseName := Tabela[I].DatabaseName;
        HalcyonDataSet1.TableName := Tabela[I].TableName;
        HalcyonDataSet1.Exclusive := True;
        HalcyonDataSet1.Open;
        RichEdit1.Lines.Add('Halcyon �ndice '+NomesDeCampos[I]+' '+IntToStr(HalcyonDataSet1.RecordCount)+' Registros Gerados');

        FormGeral.QueryInsertProtocolo.Parameters[11].Value := HalcyonDataSet1.RecordCount;

        HalcyonDataSet1.IndexOn(ChangeFileExt(HalcyonDataSet1.TableName,'.MDX'),'VALOR','VALOR','',Duplicates,Ascending);
        HalcyonDataSet1.Close;
        End
      Else
        Begin }
      TabelaAds[I].Exclusive := True;
      TabelaAds[I].Open;
      RichEdit1.Lines.Add('�ndice '+NomesDeCampos[I]+' '+IntToStr(TabelaAds[I].RecordCount)+' Registros Gerados');

      //FormGeral.QueryInsertProtocolo.Parameters[11].Value := TabelaAds[I].RecordCount;
      strsql.Add(IntToStr(TabelaAds[I].RecordCount) + ',');
      TabelaAds[I].AddIndex('INDVALOR','VALOR',[]); {indexa no final}
      TabelaAds[I].FieldDefs[0].Index := 0;

      TabelaAds[I].Close;
//        End;

      AssignFile(ArqTam,ChangeFileExt(IncludeTrailingPathDelimiter(TabelaBde[I].DatabaseName)+TabelaBde[I].TableName,'.DBF'));
//      AssignFile(ArqTam,ChangeFileExt(IncludeTrailingPathDelimiter(AdsConnection1.GetConnectionPath)+TabelaBde[I].TableName,'.DBF'));

      Reset(ArqTam,1);
      TamInd := FileSize(ArqTam);
      CloseFile(ArqTam);

      AssignFile(ArqTam,ChangeFileExt(IncludeTrailingPathDelimiter(TabelaBde[I].DatabaseName)+TabelaBde[I].TableName,'.MDX'));
//      AssignFile(ArqTam,ChangeFileExt(IncludeTrailingPathDelimiter(AdsConnection1.GetConnectionPath)+TabelaAds[I].TableName,'.CDX'));
      Reset(ArqTam,1);
      TamInd := TamInd + FileSize(ArqTam);
      CloseFile(ArqTam);

      TotTamInd := TotTamInd + TamInd;
      {
      FormGeral.QueryInsertProtocolo.Parameters[12].Value := Null;
      FormGeral.QueryInsertProtocolo.Parameters[13].Value := Null;
      FormGeral.QueryInsertProtocolo.Parameters[14].Value := TamInd;
      FormGeral.QueryInsertProtocolo.Parameters[15].Value := Null;
      FormGeral.QueryInsertProtocolo.Parameters[16].Value := Null;
      }
      strsql.Add(' Null,');
      strsql.Add(' Null,');
      strsql.Add( IntToStr(TamInd) + ',');
      strsql.Add(' Null,');
      strsql.Add(' Null)');

      Try
        //FormGeral.QueryInsertProtocolo.ExecSQL;
        FormGeral.Persistir(strsql.Text, nil, 1);
      Except
        FormGeral.InsereLog(Arquivos.Cells[1,1],'Erro de inser��o de registro de protocolo, �ndices');
        End; // Try

      AvisoP.CLose;
      End;
    TabelaBde[I].Free;
    TabelaAds[I].Free;
    End;
  End;

  Procedure Distribui;
  Var
    I,
    Counter : Integer;
    ArqExtrIn,
    ArqExtrOut : System.Text;
    NArqAux,
    LinExtr : AnsiString;

    Procedure CriaDestino;
    Begin
    FillChar(RegDestino,SizeOf(RegDestino),0);
    RegDestino.TipoReg := 3;
    RegDestino.CODREL_0 := FormGeral.Memtb.FieldByName('CodRel').AsAnsiString;
    RegDestino.DESTINO := FormGeral.Memtb.FieldByName('Destino').AsAnsiString;
    RegDestino.TIPODESTINO := FormGeral.Memtb.FieldByName('TipoDestino').AsAnsiString;
    RegDestino.DIREXPL := FormGeral.Memtb.FieldByName('DirExpl').AsAnsiString = 'S';
    RegDestino.SEGURANCA := FormGeral.Memtb.FieldByName('Seguranca').AsAnsiString = 'S';
    Try
      RegDestino.QTDPERIODOS := FormGeral.Memtb.FieldByName('QtdPeriodos').AsInteger;
    Except
      End;
    RegDestino.TIPOPERIODO := FormGeral.Memtb.FieldByName('TipoPeriodo').AsAnsiString;
    RegDestino.USUARIO := FormGeral.Memtb.FieldByName('Usuario').AsAnsiString;
    RegDestino.SENHA := FormGeral.Memtb.FieldByName('Senha').AsAnsiString;
    End;

    Procedure TrataGrupoAutomatico;

    Begin
    If SistemaAutomatico Or GrupoAutomatico Or SubDirAutomatico Then     // Se est� processando um relat�rio com pesquisa de grupo grava o grupo processado
      Begin
      RegGrp.TipoReg := 0;
      RegGrp.Grp := CodGrupo;
      End;
    End;

    Procedure DescarregaCNFG;
    Var
      I : Integer;
    Begin
    AssignFile(ArqCNFG,ExtractFilePath(Arquivos.Cells[1,2])+SeArquivoSemExt(Arquivos.Cells[1,2])+'Dfn.Dfn');
    ReWrite(ArqCNFG);
    Write(ArqCNFG,RegDestino);
    If SistemaAutomatico Or GrupoAutomatico Or SubDirAutomatico Then
      Write(ArqCNFG,RegGrp);
    Write(ArqCNFG,RegDFN);
    Write(ArqCNFG,RegSistema);
    Write(ArqCNFG,RegSisAuto);
    FillChar(RegDestinoII,SizeOf(RegDestinoII),0);
    RegDestinoII.TipoReg := RegDestino.TipoReg;
    RegDestinoII.SEGURANCA := RegDestino.SEGURANCA;
    Write(ArqCNFG,RegDestinoII);
    For I := 0 To 199 Do
      If (ArrRegIndice[I].TipoReg = 2) Then
        If (Fusao[I].IndiceGerado) Then
          Write(ArqCNFG,ArrRegIndice[I])
        Else
          Begin // N�o descarrega o �ndice
          End
      Else
        Break;
    CloseFile(ArqCNFG);
    End;

  Begin
  // Faz a dispensa��o do relat�rio processado

  If JuncaoAutomatica Then
    Begin
    RichEdit1.Lines.Add('Apagando os arquivos de relat�rio anteriores...');
    If FindFirst(DirDest+'*.*', FaAnyFile, SearchRec) = 0 Then
      Repeat
        SysUtils.DeleteFile(DirDest+SearchRec.Name)
      Until FindNext(SearchRec) <> 0;
    SysUtils.FindClose(SearchRec);
    End;

  If ExtrairDados Then
    For I := 1 To IFrmExtract Do
      With IndexFrmExtract[I] Do
        Begin
        If OperacaoExtract = 'S' Then
          Begin
          RichEdit1.Lines.Add('Apagando os arquivos de extra��o anteriores...');
          If NomeArqTxt = '' Then
            NArqAux := '*.*'
          Else
            NArqAux := NomeArqTxt;
          If FindFirst(DirDestinoExtract+NArqAux, FaAnyFile, SearchRec) = 0 Then
          Repeat
            SysUtils.DeleteFile(DirDestinoExtract+SearchRec.Name)
          Until FindNext(SearchRec) <> 0;
          SysUtils.FindClose(SearchRec);
          End;
        ForceDirectories(DirDestinoExtract);  // Cria o diret�rio de destino, se j� n�o existe...
        If OperacaoExtract = '' Then    // Evitar problemas na compara��o abaixo...
          OperacaoExtract := ' ';
        If OperacaoExtract[1] In ['S','N'] Then
          Begin
          If NomeArqTxt = '' Then
            NArqAux := IndexFrmExtract[I].SaveDialog2.FileName
          Else
            NArqAux := NomeArqTxt;
          DeleteFile(Pchar(DirDestinoExtract + ExtractFileName(NArqAux)));
          MoveFile(Pchar(IndexFrmExtract[I].SaveDialog2.FileName),
                   Pchar(DirDestinoExtract + ExtractFileName(NArqAux)));
          End
        Else
          Begin
          RichEdit1.Lines.Add('Appending ao arquivo de extra��o anterior...');
          If NomeArqTxt = '' Then
            NArqAux := '*.*'
          Else
            NArqAux := NomeArqTxt;
          If FindFirst(DirDestinoExtract+NArqAux, FaAnyFile, SearchRec) = 0 Then
            Begin
            AssignFile(ArqExtrOut,DirDestinoExtract+SearchRec.Name);
            AssignFile(ArqExtrIn,IndexFrmExtract[I].SaveDialog2.FileName);
            Reset(ArqExtrIn);
            Append(ArqExtrOut);
            While Not Eof(ArqExtrIn) Do
              Begin
              ReadLn(ArqExtrIn,LinExtr);
              WriteLn(ArqExtrOut,LinExtr);
              End;
            CloseFile(ArqExtrIn);
            CloseFile(ArqExtrOut);

            DeleteFile(Pchar(IndexFrmExtract[I].SaveDialog2.FileName));
            End
          Else
            Begin
            If NomeArqTxt = '' Then
              NArqAux := IndexFrmExtract[I].SaveDialog2.FileName
            Else
              NArqAux := NomeArqTxt;
            MoveFile(Pchar(IndexFrmExtract[I].SaveDialog2.FileName),
                     Pchar(DirDestinoExtract + ExtractFileName(NArqAux)));
            End;
          SysUtils.FindClose(SearchRec);
          End;
        IndexFrmExtract[I].Free;
        End;

//  FormGeral.QueryDestinosDFN.Params[0].AsAnsiString := FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString;
  //FormGeral.QueryDestinosDFN.Parameters[0].Value := FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString;
  //FormGeral.QueryDestinosDFN.Open;
  strSql.Clear;
  strSql.Add(' SELECT replace(DESTINO,' + quotedStr('\') + ',' + QuotedStr('/') + ') DESTINO, ');
  strSql.Add(' TIPODESTINO, SEGURANCA, QTDPERIODOS, TIPOPERIODO, USUARIO, SENHA, DIREXPL ');
  strSql.Add(' FROM         DESTINOSDFN ');
  strSql.Add(' WHERE     (CODREL = ' + Quotedstr(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString) + ')  ');
  strSql.Add(' AND TIPODESTINO = ' + QuotedStr('Dir') );
  formGeral.ImportarDados(strSql.Text, nil);
//  FormGeral.TableDestinosDFN.Filter := 'CODREL = '''+FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString+''''+
//            ' AND TIPODESTINO = ''Dir''';
//  FormGeral.TableDestinosDFN.Filtered := True;

  //While Not FormGeral.Memtb.Eof do         //Conta
  //  FormGeral.Memtb.Next;

  Counter := FormGeral.Memtb.RecordCount;

  If Counter = 0 Then  // Nenhum destino, sai fora....
    Begin
    FormGeral.Memtb.Close;
    FormGeral.InsereLog(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString,'Relat�rio sem destino');
    Exit;
    End;

  //FormGeral.Memtb.First;                  // Volta ao in�cio

  // Verifica a necessidade de gera��o de uma c�pia no diret�rio de cd...
  strsql.Clear;
  //FormGeral.QueryAux1.Close;
  //FormGeral.QueryAux1.Sql.Clear;
  //FormGeral.QueryAux1.Sql.Add('SELECT * FROM RELATOCD A ');
  //FormGeral.QueryAux1.Sql.Add('WHERE A.CODGRUPO = '+IntToStr(CodGrupo));
  //FormGeral.QueryAux1.Sql.Add('AND A.CODREL = '''+FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString+'''');
  //FormGeral.QueryAux1.Open;

  strsql.Add('SELECT * FROM RELATOCD A ');
  strsql.Add('WHERE A.CODGRUPO = '+IntToStr(CodGrupo));
  strsql.Add('AND A.CODREL = '''+FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString+'''');
  formgeral.ImportarDados(strsql.Text,nil,1);

  If FormGeral.MemAux1.RecordCount <> 0 Then  // Tem que copiar para futura grava��o de CD
    Begin
    If FormGeral.MemAux1.FieldByName('DirExpl').AsAnsiString = 'S' Then
      DirDest := IncludeTrailingPathDelimiter(viDirGravCd)
    Else
      DirDest := IncludeTrailingPathDelimiter(viDirGravCd + CodAlfa);
    ForceDirectories(DirDest);  // Cria o diret�rio de destino, se j� n�o existe...

    TrataGrupoAutomatico;

    RichEdit1.Lines.Add('Copiando arquivos processados para ' + DirDest);


    strSql.Clear;
    strSql.Add(' SELECT CodRel, replace(DESTINO,' + quotedStr('\') + ',' + QuotedStr('/') + ') DESTINO, ');
    strSql.Add(' TIPODESTINO, SEGURANCA, QTDPERIODOS, TIPOPERIODO, USUARIO, SENHA, DIREXPL ');
    strSql.Add(' FROM         DESTINOSDFN ');
    strSql.Add(' WHERE     (CODREL = ' + Quotedstr(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString) + ')  ');
    strSql.Add(' AND TIPODESTINO = ' + QuotedStr('Dir') );
    formGeral.ImportarDados(strSql.Text, nil);
    CriaDestino;
    RegDestino.DESTINO := viDirGravCd;
    RegDestino.SEGURANCA := FormGeral.MemAux1.FieldByName('Seguranca').AsAnsiString = 'S';

    DescarregaCNFG;

    If FindFirst(ChangeFileExt(Arquivos.Cells[1,2],'*.*'), FaAnyFile, SearchRec) = 0 Then
      Repeat
        If UpperCase(ExtractFileExt(SearchRec.Name)) = '.VAL' Then
          SysUtils.DeleteFile(ExtractFilePath(Arquivos.Cells[1,2])+SearchRec.Name)
        Else
        CopyFile(Pchar(ExtractFilePath(Arquivos.Cells[1,2])+SearchRec.Name),
             Pchar(DirDest + SearchRec.Name), False); // OverWrite If Exists
      Until FindNext(SearchRec) <> 0;
    SysUtils.FindClose(SearchRec);
    End;
  FormGeral.MemAux1.Close;
  strSql.Clear;
  strSql.Add(' SELECT codrel, replace(DESTINO,' + quotedStr('\') + ',' + QuotedStr('/') + ') DESTINO, ');
  strSql.Add(' TIPODESTINO, SEGURANCA, QTDPERIODOS, TIPOPERIODO, USUARIO, SENHA, DIREXPL ');
  strSql.Add(' FROM         DESTINOSDFN ');
  strSql.Add(' WHERE     (CODREL = ' + Quotedstr(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString) + ')  ');
  strSql.Add(' AND TIPODESTINO = ' + QuotedStr('Dir') );
  formGeral.ImportarDados(strSql.Text, nil);
  While (Not FormGeral.Memtb.Eof) Do  // Varre todos os destinos = Dir
    Begin
    If FormGeral.Memtb.FieldByName('DirExpl').AsAnsiString = 'S' Then
      DirDest := IncludeTrailingPathDelimiter(stringReplace(FormGeral.Memtb.FieldByName('Destino').AsAnsiString,'/','\',[rfReplaceAll, rfIgnoreCase]))
    Else
      DirDest := IncludeTrailingPathDelimiter(stringReplace(FormGeral.Memtb.FieldByName('Destino').AsAnsiString,'/','\',[rfReplaceAll, rfIgnoreCase])) + CodAlfa;
    ForceDirectories(DirDest);  // Cria o diret�rio de destino, se j� n�o existe...

    TrataGrupoAutomatico;

    If Counter = 1 Then  // � o �ltimo Dir, Move
      Begin
      RichEdit1.Lines.Add('Movendo arquivos processados para ' + DirDest);
      CriaDestino;
      DescarregaCNFG;
      TotTamExt := 0;
      TotTam := 0;
      If FindFirst(ChangeFileExt(Arquivos.Cells[1,2],'*.*'), FaAnyFile, SearchRec) = 0 Then
        Repeat
          If UpperCase(ExtractFileExt(SearchRec.Name)) = '.VAL' Then
            SysUtils.DeleteFile(ExtractFilePath(Arquivos.Cells[1,2])+SearchRec.Name)
          Else
            Begin
            If (UpperCase(ExtractFileExt(SearchRec.Name)) = '.DAT') Then
              TotOut := SearchRec.Size
            Else
            If (UpperCase(ExtractFileExt(SearchRec.Name)) = '.DBF') or
               (UpperCase(ExtractFileExt(SearchRec.Name)) = '.CDX') Then
               Begin  // N�o contabiliza estes arquivos
               End
            Else
              TotTamExt := TotTamExt + SearchRec.Size;

            TotTam := TotTam + SearchRec.Size;

            DeleteFile(Pchar(DirDest + SearchRec.Name));
            if not MoveFile(Pchar(ExtractFilePath(Arquivos.Cells[1,2])+SearchRec.Name), Pchar(DirDest+SearchRec.Name)) then
              FormGeral.InsereLog(SearchRec.Name,'Erro movendo arquivo para: '+DirDest);
            End;
        Until FindNext(SearchRec) <> 0;
      SysUtils.FindClose(SearchRec);
      End
    Else
      Begin                                                                // Vai copiando para os destinos
      RichEdit1.Lines.Add('Copiando arquivos processados para '+DirDest);
      CriaDestino;
      DescarregaCNFG;
      If FindFirst(ChangeFileExt(Arquivos.Cells[1,2],'*.*'), FaAnyFile, SearchRec) = 0 Then
        Repeat
          If UpperCase(ExtractFileExt(SearchRec.Name)) = '.VAL' Then
            SysUtils.DeleteFile(ExtractFilePath(Arquivos.Cells[1,2])+SearchRec.Name)
          Else
            CopyFile(Pchar(ExtractFilePath(Arquivos.Cells[1,2])+SearchRec.Name),
                     Pchar(DirDest + SearchRec.Name), False); // OverWrite If Exists
        Until FindNext(SearchRec) <> 0;
      SysUtils.FindClose(SearchRec);
      End;
    FormGeral.Memtb.Next;
    Dec(Counter);
    End;
  FormGeral.Memtb.Close;
  End;

  Procedure LimpaMensagens;
  Var
    I, J : Integer;
  Begin
  For I := 1 To Arquivos.RowCount-1 Do
    For J := 1 To Arquivos.ColCount-1 Do
      Arquivos.Cells[J,I] := '';
  If viExecAutoSN = 'S' Then
    Begin
    StatusBar1.Panels[0].Text := '';           // Limpa a extens�o no processamento autom�tico, preservando-a no manual
    StatusBar1.Panels[1].Text := 'Aguardando In�cio da Execu��o Autom�tica'
    End
  Else
    StatusBar1.Panels[1].Text := 'Aguardando Instru��o de In�cio de Processamento';
  Application.ProcessMessages;
  End;

  Function ObtemSubGrupo : Boolean;
  Begin

  Result := False;

  //FormGeral.QueryAux1.Close;
  //FormGeral.QueryAux1.Sql.Clear;
  //FormGeral.QueryAux1.Sql.Add('SELECT * FROM SUBGRUPOSDFN A ');
  //FormGeral.QueryAux1.Sql.Add('WHERE A.CODSIS = '+
  //                       FormGeral.QueryAux2.FieldByName('CodSis').AsAnsiString);
  //FormGeral.QueryAux1.Sql.Add('AND A.CODGRUPO = '+
  //                       FormGeral.QueryAux2.FieldByName('CodGrupo').AsAnsiString);
  //FormGeral.QueryAux1.Sql.Add('AND A.CODSUBGRUPO = '+
  //                       FormGeral.QueryAux2.FieldByName('CodSubGrupo').AsAnsiString);
  strsql.Clear;
  strsql.Add('SELECT * FROM SUBGRUPOSDFN A ');
  strsql.Add('WHERE A.CODSIS = '+
                         FormGeral.MemAux2.FieldByName('CodSis').AsAnsiString);
  strsql.Add('AND A.CODGRUPO = '+
                         FormGeral.MemAux2.FieldByName('CodGrupo').AsAnsiString);
  strsql.Add('AND A.CODSUBGRUPO = '+
                         FormGeral.MemAux2.FieldByName('CodSubGrupo').AsAnsiString);
  Try
    //FormGeral.Memtb.Open;
    formgeral.ImportarDados(strsql.Text, nil, 1);
    If FormGeral.MemAux1.RecordCount = 0 Then
      Begin
      FormGeral.MemAux1.Close;
      FormGeral.InsereLog(ReportRec.Name,'Query Sub Grupo Vazia');
      MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
      Exit; // 07/09/2000
      End;
    SubGrupo := FormGeral.MemAux1.FieldByName('NomeSubGrupo').AsAnsiString;
    FormGeral.MemAux1.Close;
  Except
    FormGeral.InsereLog(ReportRec.Name,'Erro de Query Sub Grupo');
    MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
    Exit; // 07/09/2000
    End; //Try
  Result := True;
  End;

  Function ObtemGrupo : Boolean;

  Begin
  Result := False;
  Try
    FormGeral.MemAux1.Open;
    If FormGeral.MemAux1.RecordCount = 0 Then
      Begin
      FormGeral.MemAux1.Close;
      Exit // 07/09/2000
      End
    Else
      Begin
      CodAlfa := LimpaNomArq(FormGeral.MemAux1.FieldByName('NomeSis').AsAnsiString)+'\'+
                 LimpaNomArq(FormGeral.MemAux1.FieldByName('NomeGrupo').AsAnsiString)+'\'+
                 LimpaNomArq(SubGrupo) + '\' + //  07/09/2000
                 LimpaNomArq(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString)+'\';
      CodGrupo := FormGeral.MemAux1.FieldByName('CodGrupo').AsInteger;
      End;
    FormGeral.MemAux1.Close;
  Except
    FormGeral.InsereLog(ReportRec.Name,'Erro de Query Grupo');
    MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
    Exit; // 31/08/2000
    End;
  Result := True;
  End;

  Function ObtemGrupoAux : Boolean;

  Begin
  Result := False;
  Try
    FormGeral.MemAux1.Open;
    If FormGeral.MemAux1.RecordCount = 0 Then
      Begin
      FormGeral.MemAux1.Close;
      FormGeral.InsereLog(ReportRec.Name,'Query Grupo Aux Vazia');
      MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
      Exit;
      End
    Else
      Begin
      CodAlfa := LimpaNomArq(FormGeral.MemAux1.FieldByName('NomeSis').AsAnsiString)+'\'+
                 LimpaNomArq(FormGeral.MemAux1.FieldByName('NomeGrupo').AsAnsiString)+'\'+
                 LimpaNomArq(SubGrupo) + '\' +
                 LimpaNomArq(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString)+'\';
      CodGrupo := FormGeral.MemAux1.FieldByName('CodGrupo').AsInteger;
      End;
    FormGeral.MemAux1.Close;
  Except
    FormGeral.InsereLog(ReportRec.Name,'Erro de Query Grupo Aux');
    MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
    Exit;
    End;
  Result := True;
  End;

  Function TestaAcessoExclusivo(Arquivo : AnsiString) : Boolean;
  Var
    TestFile : TFileStream;
  Begin
  TestaAcessoExclusivo := True;
  TestFile := nil;
  Try
    TestFile := TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive);
  Except
    TestaAcessoExclusivo := False
    End; // Try
  If TestFile <> nil Then
    TestFile.Free;
  End;

  Function IdTeste : Boolean;

  Begin
  Result := False;

  //if FormGeral.QueryAux2.FieldByName('IDString1').AsAnsiString = 'DIARIO' then
  //  application.ProcessMessages;

  If Not TrataPto1(DirIn+ReportRec.Name, FormGeral.MemAux2.FieldByName('IDLinha1').AsInteger, Linha, True) Then
    Exit;

  Result := Copy(Linha, FormGeral.MemAux2.FieldByName('IDColuna1').AsInteger,
            Length(FormGeral.MemAux2.FieldByName('IDString1').AsAnsiString)) =
            FormGeral.MemAux2.FieldByName('IDString1').AsAnsiString;

  If FormGeral.MemAux2.FieldByName('IDColuna2').AsAnsiString <> '' Then
    Begin
    If Not TrataPto1(DirIn+ReportRec.Name, FormGeral.MemAux2.FieldByName('IDLinha2').AsInteger, Linha2, True) Then
      Exit;
    Result := Result And
              (Copy(Linha2,FormGeral.MemAux2.FieldByName('IDColuna2').AsInteger,
              Length(FormGeral.MemAux2.FieldByName('IDString2').AsAnsiString)) =
              FormGeral.MemAux2.FieldByName('IDString2').AsAnsiString);
    End;
  End;

  Procedure ProcessaPrincipal;
  Var
    L : Integer;
    IdTesteSis : Boolean;
  Begin
  TotTamInd := 0;
  CodAlfa := '';
  SubGrupo := '';
  GrupoAutomatico := FormGeral.MemAux2.FieldByName('CodGrupAuto').AsBoolean;
  SubDirAutomatico := FormGeral.MemAux2.FieldByName('SubDirAuto').AsBoolean;
  SistemaAutomatico := FormGeral.MemAux2.FieldByName('SisAuto').AsBoolean;
  If SubDirAutomatico Then
    Begin       // Montagem do path dos relat�rios autom�ticos
    If Not TrataPto1(DirIn+ReportRec.Name, FormGeral.MemAux2.FieldByName('LinGrupAuto').AsInteger, Linha2, True) Then
      Exit;
//    If ISubDirAuto <> -1 Then
//      CodAlfa := ArrSubDirAuto[ISubDirAuto]
//    Else
    If ISubDirAuto = -1 Then
      Begin
      FormGeral.InsereLog(ReportRec.Name,'ISubDirAuto = -1');
      MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
      Exit;
      End;
    Try
      CodAlfa := IntToStr(StrToInt(ArrSubDirAuto[ISubDirAuto].CodSis)) + '\' +
                 IntToStr(StrToInt(ArrSubDirAuto[ISubDirAuto].CodGrupo));
    Except
      FormGeral.InsereLog(ReportRec.Name,'SubDirAutomatico, Erro de convers�o para num�rico');
      MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
      Exit; // 31/08/2000
      End; // Try
    If Not ObtemSubGrupo Then
      Exit;
    //FormGeral.QueryAux1.Close;
    //FormGeral.QueryAux1.Sql.Clear;
//    FormGeral.QueryAux1.Sql.Add('SELECT * GRUPOSDFN A ');
//    FormGeral.QueryAux1.Sql.Add('WHERE A.CODGRUPO = '+CodAlfa);
    strsql.Clear;
    strsql.Add('SELECT * FROM SISTEMA B INNER JOIN GRUPOSDFN A ON B.CODSIS = A.CODSIS');
    strsql.Add('WHERE A.CODSIS = '+ArrSubDirAuto[ISubDirAuto].CodSis + ' AND ');
    strsql.Add('      A.CODGRUPO = ' + ArrSubDirAuto[ISubDirAuto].CodGrupo);
    //strsql.SaveToFile('c:\temp\sqlrel1.sql');
    FormGeral.ImportarDados(strsql.Text,nil,1);
    If Not ObtemGrupo Then
      Begin
      FormGeral.MemAux1.Close;
      FormGeral.InsereLog(ReportRec.Name,'Nao foi possivel obter Grupo, SubDirAutomatico');
      MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
      Exit;
      End;

    CodigoDoSistema := StrToInt(ArrSubDirAuto[ISubDirAuto].CodSis);

    End
  Else If GrupoAutomatico Then
    Begin       // Montagem do path dos relat�rios autom�ticos
    If Not TrataPto1(DirIn+ReportRec.Name, FormGeral.MemAux2.FieldByName('LinGrupAuto').AsInteger, Linha2, True) Then
      Exit;
    Try
      CodAlfa := Copy(Linha2,FormGeral.MemAux2.FieldByName('ColGrupAuto').AsInteger,
                             FormGeral.MemAux2.FieldByName('TamGrupAuto').AsInteger);
    Except
      FormGeral.InsereLog(ReportRec.Name,'CodGrupoAuto N�o pode ser obtido, Erro de Copy');
      MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
      Exit;  // 31/08/2000
      End; // Try
    If FormGeral.MemAux2.FieldByName('TipoGrupAuto').AsAnsiString = 'N' Then
      Try
        CodAlfa := IntToStr(StrToInt(CodAlfa));
      Except
        FormGeral.InsereLog(ReportRec.Name,'TipoGrupAuto=N, Erro de convers�o para num�rico');
        MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
        Exit; // 31/08/2000
        End; // Try
    If Not ObtemSubGrupo Then
      Exit;
    //FormGeral.MemAux1.Close;
    strsql.Clear;
    strsql.Add('SELECT * FROM SISTEMA B INNER JOIN GRUPOSDFN A ON B.CODSIS = A.CODSIS');
    If FormGeral.MemAux2.FieldByName('TipoGrupAuto').AsAnsiString = 'N' Then
      strsql.Add('WHERE A.CODGRUPO = '+CodAlfa)
    Else
      strsql.Add('WHERE A.CODGRUPOALFA = '''+CodAlfa+'''');
    strsql.Add('AND A.CODSIS ='+FormGeral.MemAux2.FieldByName('CodSis').AsAnsiString);
    FormGeral.ImportarDados(strsql.Text,nil,1);
    If Not ObtemGrupo Then
      Begin
      strsql.Clear;
      //FormGeral.QueryAux1.Close;
      //FormGeral.QueryAux1.Sql.Clear;
      If FormGeral.MemAux2.FieldByName('TipoGrupAuto').AsAnsiString = 'N' Then
        strsql.Add('SELECT * FROM GRUPOSAUXNUMDFN A INNER JOIN ')
      Else
        strsql.Add('SELECT * FROM GRUPOSAUXALFADFN A INNER JOIN ');
      strsql.Add('GRUPOSDFN B ON A.CODGRUPO = B.CODGRUPO AND A.CODSIS = B.CODSIS INNER JOIN ');
      strsql.Add('SISTEMA C ON A.CODSIS = C.CODSIS ');
      If FormGeral.MemAux2.FieldByName('TipoGrupAuto').AsAnsiString = 'N' Then
//        Begin
//        FormGeral.QueryAux1.Sql.Add('SELECT * FROM GRUPOSAUXNUMDFN A, GRUPOSDFN B ');
        strsql.Add('WHERE A.CODAUXGRUPO = '+CodAlfa)
//        End
      Else
//        Begin
//        FormGeral.QueryAux1.Sql.Add('SELECT * FROM GRUPOSAUXALFADFN A, GRUPOSDFN B ');
        strsql.Add('WHERE A.CODAUXGRUPO = '''+CodAlfa+'''');
//        End;
//      FormGeral.QueryAux1.Sql.Add('AND A.CODGRUPO = B.CODGRUPO');
      FormGeral.ImportarDados(strsql.Text,nil,1);
      If Not ObtemGrupoAux Then
        Exit;
      End;
    End
  Else
  If SistemaAutomatico THen
    Begin
    If Not TrataPto1(DirIn+ReportRec.Name, 500, Linha2, False) Then
      Exit;

    If Not ObtemSubGrupo Then
      Exit;

    IdTesteSis := False;
    strsql.Clear;
    //FormGeral.QueryAux3.Sql.Clear;
    strsql.Add('SELECT * FROM SISAUXDFN A');
    strsql.Add('WHERE A.CODREL = '''+FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString+'''');
    FormGeral.ImportarDados(strsql.Text,nil,3);

    While (Not (FormGeral.MemAux3.Eof)) Do
      Begin
      If FormGeral.MemAux3.FieldByName('Tipo').AsAnsiString = 'A' Then // Tipo alfa, testa os caracteres de acordo com o tamanho digitado
        For L := FormGeral.MemAux3.FieldByName('LinI').AsInteger To FormGeral.MemAux3.FieldByName('LinF').AsInteger Do  // Pode informar ranges de linhas
          Begin
          Try
            IdTesteSis := Copy(arPagina[L],FormGeral.MemAux3.FieldByName('Col').AsInteger,
                               Length(FormGeral.MemAux3.FieldByName('CodAux').AsAnsiString)) =
                                                 FormGeral.MemAux3.FieldByName('CodAux').AsAnsiString;
          Except
          End; // Try
          If IdTesteSis Then
            Begin
            Break;
            End;
          End
      Else
        For L := FormGeral.MemAux3.FieldByName('LinI').AsInteger To FormGeral.MemAux3.FieldByName('LinF').AsInteger Do  // Pode informar ranges de linhas
          Begin
          Try
            IdTesteSis := StrToInt64(Trim(Copy(arPagina[L],FormGeral.MemAux3.FieldByName('Col').AsInteger,
                            Length(FormGeral.MemAux3.FieldByName('CodAux').AsAnsiString)))) =
                               StrToInt64(Trim(FormGeral.MemAux3.FieldByName('CodAux').AsAnsiString));
          Except
          End; // Try
          If IdTesteSis Then
            Begin
            Break;
            End;
          End;
      If IdTesteSis Then // O teste est� aqui para que a pr�xima instru��o n�o seja executada quando achou Uma SisAux para a dfn
        Break;
      FormGeral.MemAux3.Next;
      End;
    If Not IdTesteSis Then
      Begin
      FormGeral.MemAux3.Close;
      Exit;
      End;
    CodAlfa := FormGeral.MemAux3.FieldByName('CodGrupo').AsAnsiString;
    CodigoDoSistema := FormGeral.MemAux3.FieldByName('CodSis').asInteger;
    //FormGeral.QueryAux1.Close;
    strsql.Clear;
    strsql.Add('SELECT * FROM SISTEMA B INNER JOIN GRUPOSDFN A ON B.CODSIS = A.CODSIS');
    strsql.Add('WHERE A.CODGRUPO = '+CodAlfa);
    strsql.Add('AND A.CODSIS ='+FormGeral.MemAux3.FieldByName('CodSis').AsAnsiString);
    FormGeral.MemAux3.Close;
    FormGeral.ImportarDados(strsql.Text,nil,1);
    If Not ObtemGrupo Then
      Exit;
    End
  Else
    Begin                        // Montagem da �rvore dos relat�rios normais
    If Not ObtemSubGrupo Then
      Exit;
    FormGeral.MemAux1.Close;
    strsql.Clear;
    //FormGeral.QueryAux1.Sql.Clear;
//    FormGeral.QueryAux1.Sql.Add('SELECT * FROM GRUPOSDFN A ');
//    FormGeral.QueryAux1.Sql.Add('WHERE A.CODGRUPO = '+
//                        FormGeral.QueryAux2.FieldByName('CODGRUPO').AsAnsiString);
    strsql.Add('SELECT * FROM SISTEMA B INNER JOIN GRUPOSDFN A ON B.CODSIS = A.CODSIS');
    strsql.Add('WHERE A.CODSIS = ' + FormGeral.MemAux2.FieldByName('CODSIS').AsAnsiString + ' AND ');
    strsql.Add('      A.CODGRUPO = ' + FormGeral.MemAux2.FieldByName('CODGRUPO').AsAnsiString);
    FormGeral.ImportarDados(strsql.Text,nil,1);
    If Not ObtemGrupo Then
      Exit;
    End;
  QuebraMod := 10;
  TipoQuebra := FormGeral.MemAux2.FieldByName('TipoQuebra').AsInteger; // Colocamos estes valores em vari�veis por
                                                                        // motivos de efici�ncia no Loop Principal
  QtdPgsAPular := FormGeral.MemAux2.FieldByName('QtdPagsAPular').AsInteger;
  Case TipoQuebra Of
    1 : Begin End; // 133 CC
    2 : Begin End; // Ctrl L
    3 : NLinhasQuebraLin := FormGeral.MemAux2.FieldByName('NLinhasQuebraLin').AsInteger;
    4 : Begin
        PulaAntes := FormGeral.MemAux2.FieldByName('QuebraAfterStr').AsBoolean;
        ColQuebraStr1 := FormGeral.MemAux2.FieldByName('ColQuebraStr1').AsInteger;
        ColQuebraStr2 := 0;
        Try
          ColQuebraStr2 := FormGeral.MemAux2.FieldByName('ColQuebraStr2').AsInteger;
        Except
          End;
        StrQuebraStr1 := FormGeral.MemAux2.FieldByName('StrQuebraStr1').AsAnsiString;
        StrQuebraStr2 := FormGeral.MemAux2.FieldByName('StrQuebraStr2').AsAnsiString;
        End;
    End; // Case
  ComprBrancos := FormGeral.MemAux2.FieldByName('ComprBrancos').AsBoolean;
  FiltraCar := FormGeral.MemAux2.FieldByName('FiltroCar').AsBoolean;
  JuncaoAutomatica := FormGeral.MemAux2.FieldByName('JuncaoAutom').AsBoolean;
  If FormGeral.MemAux2.FieldByName('BackupRel').AsAnsiString = 'F' Then
    BackupFonte := False
  Else
    BackupFonte := True;  // = 'T' ou = null
  TemQuePularNaProxima := False; // Initialize - Para controlar PulaAntes = False
  If JuncaoAutomatica Then
    Case PreparacaoParaJuncao Of
      00 : Begin
           End;
      01 : Begin
           JuncaoAutomatica := False;
           FormGeral.InsereLog(ReportRec.Name,'Preparacao para a jun��o automatica falhou: sem destino tipo "Dir"');
           End;
      02 : Begin
           JuncaoAutomatica := False; // Primeiro da s�rie, processa normalmente
           End;
      03 : Begin
           JuncaoAutomatica := False;
           FormGeral.InsereLog(ReportRec.Name,'Preparacao para a jun��o automatica falhou: m�ltiplos dats no destino, processando sem juntar');
           End;
      04 : Begin
           JuncaoAutomatica := False;
           FormGeral.InsereLog(ReportRec.Name,'Preparacao para a jun��o automatica falhou: n�mero de �ndices diferente, processando sem juntar');
           End;
      05 : Begin
           JuncaoAutomatica := False;
           FormGeral.InsereLog(ReportRec.Name,'Preparacao para a jun��o automatica falhou: �ndice antigo n�o encontrado, processando sem juntar');
           End;
      06 : Begin
           JuncaoAutomatica := False;
           FormGeral.InsereLog(ReportRec.Name,'Preparacao para a jun��o automatica falhou: �ndice alterado, processando sem juntar');
           End;
      End;  // Case

  If Not PreparaColIndex Then
    Begin
    MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
    Exit;
    End;
  If Not ProcessaArquivo Then
    Begin
    MoveDelete(DirIn+ReportRec.Name,viDirTrabApl+'NaoProcessados\'+ReportRec.Name);
    Exit;
    End;
  IndexaCampos;
  AtuEst;
  Distribui; // Distribui o relat�rio indexado e cria a vers�o seguran�a
  Processou := True;

  strsql.Clear;
  strsql.Add('INSERT INTO PROTOCOLO VALUES (  ');


  strsql.Add(QuotedStr(FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString)  + ',');
  strsql.Add(QuotedStr(FormGeral.MemAux2.FieldByName('NomeRel').AsAnsiString) + ',');
  strsql.Add(FormGeral.MemAux2.FieldByName('CodSis').AsString      + ',');
  strsql.Add(FormGeral.MemAux2.FieldByName('CodGrupo').AsString    + ',');
  strsql.Add(FormGeral.MemAux2.FieldByName('CodSubGrupo').AsString + ',');
  strsql.Add(IntToStr(CodGrupo) + ',');
  strsql.Add(QuotedStr(copy(ExtractFileName(Arquivos.Cells[1,1]),1,40)) + ',');
  strsql.Add(QuotedStr(StatusBar1.Panels[0].Text)+ ',');
  strsql.Add(QuotedStr('')  + ',');
  strsql.Add(QuotedStr(FormatDateTime('dd-mm-yyyy hh:mm:ss',Now)) + ',');
  strsql.Add(QuotedStr(FormatDateTime('dd-mm-yyyy hh:mm:ss',Now)) + ',');
  strsql.Add( IntToStr(Paginas) + ',');
  strsql.Add( IntToStr(Divisor) + ',');
  strsql.Add( IntToStr(TotOut) + ',');
  strsql.Add( IntToStr(TotTamInd) + ',');
  strsql.Add( IntToStr(TotTamExt) + ',');
  strsql.Add( IntToStr(TotTam) + ')');
  strsql.SaveToFile('d:\rom\protocolo.sql');
  Try
    FormGeral.Persistir(strsql.Text, nil,1);
    //FormGeral.QueryInsertProtocolo.ExecSQL;
  Except
    FormGeral.InsereLog(Arquivos.Cells[1,1],'Erro de inser��o de registro de protocolo, Resumo final');
    End; // Try
  try
    if FormGeral.MemAux2.FieldByName('CodSis').AsInteger > 0 then
      CodigoDoSistema := FormGeral.MemAux2.FieldByName('CodSis').AsInteger;

    FormGeral.InsereAtualizaCompila('+',
                                    FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString,
                                    CodigoDoSistema,
                                    CodGrupo,
                                    FormGeral.MemAux2.FieldByName('CodSubGrupo').AsInteger, 1);
  except
    showMessage('Erro em InsereAtualizaCompila');
  end;
  Try
    RichEdit1.SetFocus;
    RichEdit1.SelStart := Length(RichEdit1.Text)-2;
    RichEdit1.SelLength := 1;
  Except
    End; // Try
  If viExtAutoSN = 'S' Then
    Begin
    Agora := Now;  // Muda o Espa�o tempo ...
    StatusBar1.Panels[0].Text := FormatDateTime(Ano,Agora);
    End;
  Application.ProcessMessages;
  End;

Begin
strSql := TStringList.Create;
Timer1.Enabled := False;

{ *** Revers�o da altera��o realizada em 26/12/2007 ***
try
  FormGeral.DatabaseMultiCold.Close;
  FormGeral.DatabaseEventos.Close;
  FormGeral.DatabaseLog.Close;
except
end;
}
  // For�a reconex�o com o banco de dados
  {
  if not FormGeral.DatabaseMultiCold.Connected then
    FormGeral.DatabaseMultiCold.Open;
  if not FormGeral.DatabaseEventos.Connected then
    FormGeral.DatabaseEventos.Open;
  if not FormGeral.DatabaseLog.Connected then
    FormGeral.DatabaseLog.Open;
  }
Agora := Now;  // Determina o Espa�o tempo necess�rio...

StatusBar1.Panels[1].Text := 'Preparando para indexar relat�rios...';
//Edit3.Text := '1';
Application.ProcessMessages;

//FormGeral.QueryInsertProtocolo.Close;
//FormGeral.QueryInsertProtocolo.Sql.Clear;
//FormGeral.QueryInsertProtocolo.Sql.Add('INSERT INTO PROTOCOLO (CODREL,NOMEREL,CODSIS,CODGRUPO,CODSUBGRUPO,CODGRUPOAUTO,ARQUIVO,EXTENSAO,INDICE,DTFIMPROC,HRFIMPROC,PAGINAS,TAMORI,TAMCMP,TAMIND,TAMEXT,TAMTOT)');
//FormGeral.QueryInsertProtocolo.Sql.Add('VALUES (:A, :B, :C, :D, :E, :F, :G, :H, :I, :J, :K, :L, :M, :N, :O, :P, :Q) ');
//FormGeral.QueryInsertProtocolo.Prepared := True

//if not FormGeral.DatabaseMultiCold.Connected then
//  FormGeral.DatabaseMultiCold.Open;
//
//if not FormGeral.DatabaseLog.Connected then
//  FormGeral.DatabaseLog.Open;
//
//if not FormGeral.DatabaseEventos.Connected then
//  FormGeral.DatabaseEventos.Open;

//Edit3.Text := '2';
//Application.ProcessMessages;

If viExtAutoSN = 'S' Then
  Begin
  Ano := viFormExtAuto;
  While Pos('A',Ano) <> 0 Do
    Ano[Pos('A',Ano)] := 'Y';
  While Pos('a',Ano) <> 0 Do
    Ano[Pos('a',Ano)] := 'Y';
  StatusBar1.Panels[0].Text := FormatDateTime(Ano,Agora);
  Application.ProcessMessages;
  End;

//Edit3.Text := '3';
//Application.ProcessMessages;

If viExecAutoSN <> 'S' Then // Verifica o conte�do da extens�o autom�tica
  If StatusBar1.Panels[0].Text = '' Then            // Se o modo de funcionamento est� em manual
    If MessageDlg('Extens�o n�o Preenchida, Continua?',mtConfirmation,[mbYes, mbNo],0) = mrNo Then
     Begin
     LimpaMensagens;
     Exit
     End
    Else
      Application.ProcessMessages;

//Edit3.Text := '4';
//Application.ProcessMessages;

//Gabriel 30/06/2005 - Bug no ADO - A execu��o do prepare v�rias vezes acarreta em Access Violation
//FormGeral.QueryInsertProtocolo.Close;
//FormGeral.QueryInsertProtocolo.Sql.Clear;
//FormGeral.QueryInsertProtocolo.Sql.Add('INSERT INTO PROTOCOLO (CODREL,NOMEREL,CODSIS,CODGRUPO,CODSUBGRUPO,CODGRUPOAUTO,ARQUIVO,EXTENSAO,INDICE,DTFIMPROC,HRFIMPROC,PAGINAS,TAMORI,TAMCMP,TAMIND,TAMEXT,TAMTOT)');
//FormGeral.QueryInsertProtocolo.Sql.Add('VALUES (:A, :B, :C, :D, :E, :F, :G, :H, :I, :J, :K, :L, :M, :N, :O, :P, :Q, :R) ');
//FormGeral.QueryInsertProtocolo.Prepared := True;

//Edit3.Text := '5';
//Application.ProcessMessages;

//If FormGeral.DatabaseLog.InTransaction Then
//  FormGeral.DatabaseLog.CommitTrans;
//
//FormGeral.DatabaseLog.BeginTrans;

//Edit3.Text := '6';
//Application.ProcessMessages;

try
  //FillChar(ArrSubDirAuto,SizeOf(ArrSubDirAuto),#0);
  StatusBar1.Panels[1].Text := 'Carregando par�metros de relat�rios...';
  Application.ProcessMessages;
  For ISubDirAuto := 1 To 10000 Do
    Begin
    ArrSubDirAuto[ISubDirAuto].CodSis := '';
    ArrSubDirAuto[ISubDirAuto].CodGrupo := '';
    End;
  //Edit3.Text := '7';
  //Application.ProcessMessages;
  // ********** Carga de grupos de relat�rios **********
  ISubDirAuto := -1;
  //FormGeral.QueryAux1.Close;
  strsql.Clear;
  //FormGeral.QueryAux1.Sql.Clear;
  strsql.Add('SELECT * FROM GRUPOSDFN A ORDER BY CODGRUPO ');
  Try
    //FormGeral.QueryAux1.Open;
    Formgeral.ImportarDados(strsql.Text,nil,1);
    If FormGeral.MemAux1.RecordCount <> 0 Then
      Begin
      ISubDirAuto := 1;
      While Not FormGeral.MemAux1.Eof Do
        Begin
//      ArrSubDirAuto[ISubDirAuto] := FormGeral.QueryAux1.Fields[0].AsAnsiString;
        ArrSubDirAuto[ISubDirAuto].CodSis := FormGeral.MemAux1.Fields[0].AsAnsiString;
        ArrSubDirAuto[ISubDirAuto].CodGrupo := FormGeral.MemAux1.Fields[1].AsAnsiString;
        Inc(ISubDirAuto);
        FormGeral.MemAux1.Next;
        End;
      FormGeral.MemAux1.Close;
      ISubDirAuto := 0; // aponta para o come�o do array carregado...
      End;
  Except
    ISubDirAuto := -1;
  End; // Try
  //Edit3.Text := '8';
  //Application.ProcessMessages;
  SetLength(ArrRel, 0);  // for�ar o refresh dos dados na mem�ria na rotina de separa��o...
  SetLength(ArrStrAuxAlfa, 0);
  SetLength(ArrStrAlfa, 0);
  //Edit3.Text := '9';
  //Application.ProcessMessages;
  ForceDirectories(IncludeTrailingPathDelimiter(viDirTrabApl) + 'NaoIdentificados\');
  Separou := False;
  Screen.Cursor := crHourGlass;
  // ********** Carga de defini��es de relat�rios **********
  StatusBar1.Panels[1].Text := 'Indexando relat�rios separados...';
  Application.ProcessMessages;
  Repeat
    CodigoDoSistema := 0;
    Processou := False; // marca n�o processado
    // Parte 1
    //
    // Nesta parte do loop, os lrelat�rios *.1 do diret�rio principal s�o processados
    DirIn := IncludeTrailingPathDelimiter(UpperCase(viDirTrabApl)); // Apontar para o diret�rio de trabalho

    //strsql.SaveToFile('c:\temp\sqlrel.sql');
    Reports1Str := DirIn + '*.1';
    If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
      Repeat
        ReportStr := Reports1Str;
        ReportRec := Reports1Rec;
        If Not TestaAcessoExclusivo(DirIn + ReportRec.Name) Then
          Continue;   // Pula o arquivo que est� sendo copiado no momento
        strsql.Clear;
        //FormGeral.QueryAux2.Close;
        //FormGeral.QueryAux2.Sql.Clear;
        strsql.Add('SELECT ' );
        strsql.Add('CODREL ,');
        strsql.Add('NOMEREL,');
        strsql.Add('CODSIS,');
        strsql.Add('CODGRUPO,');
        strsql.Add('CODSUBGRUPO,');
        strsql.Add('IDCOLUNA1,');
        strsql.Add('IDLINHA1,');
        strsql.Add('IDSTRING1,');
        strsql.Add('IDCOLUNA2,');
        strsql.Add('IDLINHA2,');
        strsql.Add('IDSTRING2,');
        strsql.Add('replace(DIRENTRA,' + quotedStr('\') + ',' + QuotedStr('/') + ') DIRENTRA,');
        strsql.Add('TIPOQUEBRA,');
        strsql.Add('COLQUEBRASTR1,');
        strsql.Add('STRQUEBRASTR1,');
        strsql.Add('COLQUEBRASTR2,');
        strsql.Add('STRQUEBRASTR2,');
        strsql.Add('QUEBRAAFTERSTR,');
        strsql.Add('NLINHASQUEBRALIN,');
        strsql.Add('FILTROCAR,');
        strsql.Add('COMPRBRANCOS,');
        strsql.Add('JUNCAOAUTOM,');
        strsql.Add('QTDPAGSAPULAR,');
        strsql.Add('CODGRUPAUTO,');
        strsql.Add('COLGRUPAUTO,');
        strsql.Add('LINGRUPAUTO,');
        strsql.Add('TAMGRUPAUTO,');
        strsql.Add('TIPOGRUPAUTO,');
        strsql.Add('BACKUPREL,');
        strsql.Add('SUBDIRAUTO,');
        strsql.Add('STATUS,');
        strsql.Add('DTCRIACAO,');
        strsql.Add('HRCRIACAO,');
        strsql.Add('DTALTERACAO,');
        strsql.Add('HRALTERACAO,');
        strsql.Add('REMOVE,');
        strsql.Add('SISAUTO,');
        strsql.Add('DTULTPROC FROM DFN ');
        strsql.Add('WHERE (STATUS = ''A'') AND (CODREL <> ''*'') AND ');
        strsql.Add(' (SUBDIRAUTO = ''F'') AND ');
        strsql.Add(' ((UPPER(DIRENTRA) = '''+DirIn+''') OR '); // Pega com barra e sem barra...
        strsql.Add('  (UPPER(DIRENTRA) = '''+Copy(DirIn,1,Length(DirIn)-1)+''')) ');
        strsql.Add('ORDER BY CODREL');
        FormGeral.ImportarDados(strsql.Text,nil,2);
        While Not FormGeral.MemAux2.Eof Do
          Begin
          If IdTeste Then
            Begin
            //ShowMessage('Chegou aqui 2');
            ProcessaPrincipal;
            Break;
            End;
          FormGeral.MemAux2.Next;
          End; // While Not Eof
        FormGeral.MemAux2.Close;
        If FileExists(DirIn + ReportRec.Name) Then // n�o foi processado, sai fora!!!
          //MoveDelete(DirIn + Reports1Rec.Name, DirIn + 'NaoIdentificados\' + Reports1Rec.Name);
          MoveRename(DirIn + Reports1Rec.Name, DirIn + 'NaoIdentificados\' + Reports1Rec.Name);
      Until FindNext(Reports1Rec) <> 0;
    SysUtils.FindClose(Reports1Rec);
    If Not Separou Then
      Begin
      strsql.Clear;
      //FormGeral.QueryAux2.Close;
      //FormGeral.QueryAux2.Sql.Clear;
      strsql.Add('SELECT ' );
      strsql.Add('CODREL ,');
      strsql.Add('NOMEREL,');
      strsql.Add('CODSIS,');
      strsql.Add('CODGRUPO,');
      strsql.Add('CODSUBGRUPO,');
      strsql.Add('IDCOLUNA1,');
      strsql.Add('IDLINHA1,');
      strsql.Add('IDSTRING1,');
      strsql.Add('IDCOLUNA2,');
      strsql.Add('IDLINHA2,');
      strsql.Add('IDSTRING2,');
      strsql.Add('replace(DIRENTRA,' + quotedStr('\') + ',' + QuotedStr('/') + ') DIRENTRA,');
      strsql.Add('TIPOQUEBRA,');
      strsql.Add('COLQUEBRASTR1,');
      strsql.Add('STRQUEBRASTR1,');
      strsql.Add('COLQUEBRASTR2,');
      strsql.Add('STRQUEBRASTR2,');
      strsql.Add('QUEBRAAFTERSTR,');
      strsql.Add('NLINHASQUEBRALIN,');
      strsql.Add('FILTROCAR,');
      strsql.Add('COMPRBRANCOS,');
      strsql.Add('JUNCAOAUTOM,');
      strsql.Add('QTDPAGSAPULAR,');
      strsql.Add('CODGRUPAUTO,');
      strsql.Add('COLGRUPAUTO,');
      strsql.Add('LINGRUPAUTO,');
      strsql.Add('TAMGRUPAUTO,');
      strsql.Add('TIPOGRUPAUTO,');
      strsql.Add('BACKUPREL,');
      strsql.Add('SUBDIRAUTO,');
      strsql.Add('STATUS,');
      strsql.Add('DTCRIACAO,');
      strsql.Add('HRCRIACAO,');
      strsql.Add('DTALTERACAO,');
      strsql.Add('HRALTERACAO,');
      strsql.Add('REMOVE,');
      strsql.Add('SISAUTO,');
      strsql.Add('DTULTPROC');
      strsql.Add('FROM DFN WHERE (STATUS = ''A'') AND (CODREL <> ''*'') ORDER BY CODREL');
      FormGeral.ImportarDados(strsql.Text,nil,2);
      While Not FormGeral.MemAux2.Eof Do
        Begin
        StatusBar1.Panels[1].Text := 'Indexando Relat�rios. DFN '+FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString;
        DirIn := IncludeTrailingPathDelimiter(StringReplace(FormGeral.MemAux2.FieldByName('DirEntra').AsAnsiString,'/','\',[rfReplaceAll, rfIgnoreCase]));
        Reports1Str := DirIn + '*.1';
        If (ISubDirAuto <> -1) And (FormGeral.MemAux2.FieldByName('SubDirAuto').AsBoolean) Then
          Begin
          Inc(IsubDirAuto);
  //      If ArrSubDirAuto[ISubDirAuto] = '' Then // fim do array...
          If ArrSubDirAuto[ISubDirAuto].CodSis = '' Then // fim do array...
            Begin
            FormGeral.MemAux2.Next;
            ISubDirAuto := 0;
            Continue;
            End
          Else       // Se CodSis ou CodGrupo est� fixo, rejeita as posi��es de ArrSubDirAuto que diferem...
            Begin
            If FormGeral.MemAux2.FieldByName('CodSis').AsInteger <> -1 Then
              If ArrSubDirAuto[ISubDirAuto].CodSis <> FormGeral.MemAux2.FieldByName('CodSis').AsAnsiString Then
                Continue;
            If FormGeral.MemAux2.FieldByName('CodGrupo').AsInteger <> -1 Then
              If ArrSubDirAuto[ISubDirAuto].CodGrupo <> FormGeral.MemAux2.FieldByName('CodGrupo').AsAnsiString Then
                Continue;
            // Gabriel 29/06/2005
//            If FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString = 'EPI' then
//              begin
//              DirIn := DirIn;
//              end;
            DirIn := DirIn + {FormGeral.QueryAux2.FieldByName('CodRel').AsAnsiString + '\' +}
                             ArrSubDirAuto[ISubDirAuto].CodGrupo + '\' +
                             ArrSubDirAuto[ISubDirAuto].CodSis + '\';
            Reports1Str := DirIn + '*.1';
            StatusBar1.Panels[1].Text := 'Indexando Relat�rios. DFN '+FormGeral.MemAux2.FieldByName('CodRel').AsAnsiString+' - ' +
                          ArrSubDirAuto[ISubDirAuto].CodSis + '\' + ArrSubDirAuto[ISubDirAuto].CodGrupo;
            End;
          End;
        If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
          Repeat
            ReportStr := Reports1Str;
            ReportRec := Reports1Rec;
            If (TestaAcessoExclusivo(DirIn+ReportRec.Name)) And (IdTeste) Then
              ProcessaPrincipal;
          Until FindNext(Reports1Rec) <> 0;
        SysUtils.FindClose(Reports1Rec);
        If Not FormGeral.MemAux2.FieldByName('SubDirAuto').AsBoolean Then
          FormGeral.MemAux2.Next;
        End; // While Not FormGeral.QueryAux2.Eof Do
      FormGeral.MemAux2.Close;
      Screen.Cursor := crDefault;
      End;
{    StatusBar1.Panels[1].Text := 'Executando separa��o...';
    Application.ProcessMessages;
    Separou := False;
    FormSepar.BorderIcons := [];
    FormSepar.Show;
    FormSepar.ButtonExecutarClick(Self);
    FormSepar.Close;
    FormSepar.BorderIcons := [biSystemMenu, biMinimize, biMaximize]; }
  Until Not Processou;

  StatusBar1.Panels[1].Text := 'Finalizando...';
  Application.ProcessMessages;

  // Parte 4
  //
  // Limpa os arquivos lixo que estiverem na raiz principal de processamento
  DirIn := IncludeTrailingPathDelimiter(viDirTrabApl);
  Reports1Str := DirIn + '*.*';
  If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
    Repeat
      If FileExists(Reports1Rec.Name) Then // Deixar os diret�rios quietos
        If (ExtractFileExt(Reports1Rec.Name) = '.1') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.S1')  Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.EXE') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.UDL') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.DAT') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.INI') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.DLL') Then
          Begin
          // Deixa estes arquivos na raiz....
          End
        Else
          //MoveDelete(DirIn + Reports1Rec.Name, DirIn + 'NaoIdentificados\' + Reports1Rec.Name);
          MoveRename(DirIn + Reports1Rec.Name, DirIn + 'NaoIdentificados\' + Reports1Rec.Name);
    Until FindNext(Reports1Rec) <> 0;
  SysUtils.FindCLose(Reports1Rec);

//Edit3.Text := '13';
//Application.ProcessMessages;

finally
  //Edit2.Text := intToStr(strToInt64(Edit2.Text)+1);
  Application.ProcessMessages;
  //Try
  //  FormGeral.DatabaseLog.CommitTrans;
  //Except
  //  FormGeral.DatabaseLog.RollbackTrans;
  //End; // Try
  //FormGeral.QueryInsertProtocolo.Prepared := False;

//Edit3.Text := '14';
//Application.ProcessMessages;

  //SetLength(ArrRel, 0);  // Aliviar a mem�ria alocada...
  //SetLength(ArrStrAuxAlfa, 0);
  //SetLength(ArrStrAlfa, 0);
  If viExecAutoSN = 'S' Then
    Begin
    Timer1.Interval := StrToInt(Trim(viInterExecSeg))*1000;
    LimpaMensagens;
    Timer1.Enabled := True;
    End
  Else
    Begin
    ShowMessage('Fim de Indexa��o');
    LimpaMensagens;
    End;
  // Refresh na conex�o com o banco de dados
  //FormGeral.DatabaseMultiCold.Close;
  //FormGeral.DatabaseLog.Close;
  //FormGeral.DatabaseEventos.Close;
  end; // try

//Edit3.Text := '15';
//Application.ProcessMessages;

End;

Procedure TFormIndex.FiltrodeArquivos1Click(Sender: TObject);
Begin
Timer1.Enabled := False;
StatusBar1.Panels[1].Text := 'Aguardando fechamento da janela de Configura��es do Filtro';
Application.ProcessMessages;
FormFiltro.ShowModal;
If viExecAutoSN = 'S' Then
  Begin
  StatusBar1.Panels[1].Text := 'Aguardando In�cio da Execu��o Autom�tica';
  Timer1.Enabled := True;
  End
Else
  StatusBar1.Panels[1].Text := 'Aguardando Instru��o de In�cio de Processamento';
Application.ProcessMessages;
End;

Procedure TFormIndex.Processamento1Click(Sender: TObject);
Begin
Timer1.Enabled := False;
StatusBar1.Panels[1].Text := 'Aguardando fechamento da janela de Configura��es de Processamento';
Application.ProcessMessages;
Config.ShowModal;
If viExecAutoSN = 'S' Then
  Begin
  StatusBar1.Panels[1].Text := 'Aguardando In�cio da Execu��o Autom�tica';
  Timer1.Enabled := True;
  End
Else
  StatusBar1.Panels[1].Text := 'Aguardando Instru��o de In�cio de Processamento';
Application.ProcessMessages;
End;

Procedure TFormIndex.FormClose(Sender: TObject; var Action: TCloseAction);
Begin
if FormGeral.DatabaseMultiCold.Connected then
  FormGeral.DatabaseMultiCold.Close;
if FormGeral.DatabaseLog.Connected then
  FormGeral.DatabaseLog.Close;
if FormGeral.DatabaseEventos.Connected then
  FormGeral.DatabaseEventos.Close;
End;

End.
