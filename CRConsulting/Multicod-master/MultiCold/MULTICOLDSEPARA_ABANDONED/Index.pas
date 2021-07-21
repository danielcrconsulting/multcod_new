{
1.0.0.2 - Tirei o form separ deixando o controle aqui mesmo
        - havia uma briga, um loop, quando o indexador está separando o promeiro arquivo...
}

Unit Index;

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, SuTypGer, Buttons, DB, AvisoI, ExtCtrls,
  Menus, OleCtrls, ComCtrls, Variants, ToolWin, ImgList, Pilha;

Type
  TFormIndex = Class(TForm)
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
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ProcessarSpeedButton: TToolButton;
    ConfigProcSpeedButton: TToolButton;
    SairSpeedButton: TToolButton;
    ImageList1: TImageList;
    BExecutar: TButton;
    Procedure FormCreate(Sender: TObject);
    Procedure SairSpeedButtonClick(Sender: TObject);
    Procedure ProcessarSpeedButtonClick(Sender: TObject);
    Procedure Processamento1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BExecutarClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
    Procedure AtuEst;
  End;

Var
  FormIndex: TFormIndex;

Implementation

Uses IniFiles, SuGeral, Subrug, ConfigProc;

{$R *.DFM}

Var
  FiltroObj : TFiltro;
  BufIn,
  BufOut : Array[1..BufSize] Of AnsiChar;
  IndO,
  Err1 : Integer;
  ArqOut : File;
  PosAtu : Int64;
  Reports1Str : String;
  DirIn : String;
  Reports1Rec : TSearchRec;

Procedure TFormIndex.FormCreate(Sender: TObject);

Begin
FiltroObj := TFiltro.Create;
End;

Procedure TFormIndex.AtuEst;
Begin
End;

Procedure MoveDelete(Origem, Destino : String);
Begin
DeleteFile(PChar(Destino));
If Not MoveFile(PChar(Origem), PChar(Destino)) Then
  FormGeral.InsereLog(Origem,'Erro na Função MoveFile, arquivo não movido, verifique.');
End;

Procedure MoveRename(Origem, Destino : String);
Begin
while fileExists(Destino) do
  Destino := ExtractFilePath(Destino) + SeArquivoSemExt(Destino) + FormatDateTime('_hhnnsszzz',Now) + ExtractFileExt(Destino);
If Not MoveFile(PChar(Origem), PChar(Destino)) Then
  FormGeral.InsereLog(Origem,'Erro na Função MoveFile, arquivo não movido, verifique.');
End;

Procedure TFormIndex.SairSpeedButtonClick(Sender: TObject);
Begin
Close;
End;

Procedure TFormIndex.ProcessarSpeedButtonClick(Sender: TObject);
Var
  Ano : String;

  Procedure LimpaMensagens;
  Begin
  If viExecAutoSN = 'S' Then
    Begin
    StatusBar1.Panels[0].Text := '';           // Limpa a extensão no processamento automático, preservando-a no manual
    StatusBar1.Panels[1].Text := 'Aguardando Início da Execução Automática'
    End
  Else
    StatusBar1.Panels[1].Text := 'Aguardando Instrução de Início de Processamento';
  Application.ProcessMessages;
  End;

Begin
Timer1.Enabled := False;

if not FormGeral.DatabaseMultiCold.Connected then
  FormGeral.DatabaseMultiCold.Open;
if not FormGeral.DatabaseEventos.Connected then
  FormGeral.DatabaseEventos.Open;
if not FormGeral.DatabaseLog.Connected then
  FormGeral.DatabaseLog.Open;

Agora := Now;  // Determina o Espaço tempo necessário...

StatusBar1.Panels[1].Text := 'Preparando para separar relatórios...';

Application.ProcessMessages;

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

Try

  SetLength(ArrRel, 0);  // forçar o refresh dos dados na memória na rotina de separação...
  SetLength(ArrStrAuxAlfa, 0);
  SetLength(ArrStrAlfa, 0);
  ForceDirectories(IncludeTrailingPathDelimiter(viDirTrabApl) + 'NaoIdentificados\');
  Screen.Cursor := crHourGlass;
  StatusBar1.Panels[1].Text := 'Separando relatórios...';
  Application.ProcessMessages;

  Repeat
    Separou := False;

    BExecutarClick(Self);

  Until Not Separou;

  StatusBar1.Panels[1].Text := 'Finalizando...';
  Application.ProcessMessages;

  // Parte 4
  //
  // Limpa os arquivos lixo que estiverem na raiz principal de processamento
  DirIn := IncludeTrailingPathDelimiter(viDirTrabApl);
  Reports1Str := DirIn + '*.*';
  If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
    Repeat
      If FileExists(Reports1Rec.Name) Then // Deixar os diretórios quietos
        If (ExtractFileExt(Reports1Rec.Name) = '.1') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.S1')  Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.EXE') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.UDL') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.DAT') Or
           (UpperCase(ExtractFileExt(Reports1Rec.Name)) = '.DLL') Then
          Begin
          // Deixa estes arquivos na raiz....
          End
        Else
          MoveRename(DirIn + Reports1Rec.Name, DirIn + 'NaoIdentificados\' + Reports1Rec.Name);
    Until FindNext(Reports1Rec) <> 0;
  SysUtils.FindCLose(Reports1Rec);

finally
  Application.ProcessMessages;

  If viExecAutoSN = 'S' Then
    Begin
    Timer1.Interval := StrToInt(Trim(viInterExecSeg))*1000;
    LimpaMensagens;
    Timer1.Enabled := True;
    End
  Else
    Begin
    ShowMessage('Fim de Separação');
    LimpaMensagens;
    End;
  end; // try

End;

Procedure TFormIndex.Processamento1Click(Sender: TObject);
Begin
Timer1.Enabled := False;
StatusBar1.Panels[1].Text := 'Aguardando fechamento da janela de Configurações de Processamento';
Application.ProcessMessages;
Config.ShowModal;
If viExecAutoSN = 'S' Then
  Begin
  StatusBar1.Panels[1].Text := 'Aguardando Início da Execução Automática';
  Timer1.Interval := StrToInt(Trim(viInterExecSeg))*1000;
  Timer1.Enabled := True;
  End
Else
  StatusBar1.Panels[1].Text := 'Aguardando Instrução de Início de Processamento';
Application.ProcessMessages;
End;

procedure TFormIndex.BExecutarClick(Sender: TObject);
Var
//  SearchRec,
  ReportRec,
  Reports1Rec : TSearchRec;
  QuebraRel3,               // Cod Grupo
  NomeArq,
//  SearchStr,
  ReportStr,
  Reports1Str : String;
  ArqIn,
  ArqOut : System.Text;

  Arq : xArq;

  //ArqIn,
  //ArqOut : TFileStream;
  ColQuebra,
  SeqNomRel,
  I : Integer;
  AcessoExclusivo,
  QuebrouRel,
  PrimeiraPagina,
  Fechado,
  IdTeste,
  IdTesteSis,
  Pare : Boolean;
  DtHrProc : TDateTime;
  TestFile : TFileStream;
  ChrQuebra : AnsiChar;

  Procedure SeparaArquivo(NomArq : AnsiString); // Separação Automática SuGeral Reference starts here

  Var
    I,
    IRel,
    ISisAuxGeral,
    ISisAuxEspecifico,
    ISisAuxLinha : Integer;
    FlgCarregaPagina : Boolean;

//    Function PesquisaCodGrupoPelaString(StrPsq : String) : String;
    Function PesquisaCodSisGrupoPelaString(StrPsq : AnsiString; Var CodGrupo : Integer) : Integer;
    Var
      I : Integer;
    Begin
    Result := -1;
    For I := 0 To Length(ArrStrAuxAlfa)-1 Do
      Begin
      If (upperCase(StrPsq) = upperCase(ArrStrAuxAlfa[I].StrPsq)) then
        begin
          if (ArrRel[IRel].CodSis = ArrStrAuxAlfa[I].CodSis) Then
          Begin
//        Result := IntToStr(ArrStrAuxAlfa[I].CodGrupo); Aqui retornava o grupo, como vai precisar do sistema,
          Result := 0;                                  // retornará 0 se achou
          CodGrupo := ArrStrAuxAlfa[I].CodGrupo;
//        While Length(Result) < 3 Do
//          Result := '0'+Result;
          Break;
          End
        end
      Else          // Otimiza...
      If upperCase(StrPsq) < upperCase(ArrStrAuxAlfa[I].StrPsq) Then
        Break;
      End;
//    If Result <> '-1' Then
    If Result <> -1 Then
      Exit;
    For I := 0 To Length(ArrStrAlfa)-1 Do
      Begin
      If (StrPsq = ArrStrAlfa[I].StrPsq) And (ArrRel[IRel].CodSis = ArrStrAlfa[I].CodSis) Then
        Begin
//        Result := IntToStr(ArrStr2[I].CodGrupo);
        Result := 0;                                  // retornará 0 se achou
        CodGrupo := ArrStrAlfa[I].CodGrupo;
//        While Length(Result) < 3 Do
//          Result := '0'+Result;
        Break;
        End
      Else          // Otimiza...
      If StrPsq < ArrStrAlfa[I].StrPsq Then
        Break;
      End;
    End;

    Procedure AchaDFN;
    Var
      K, L : Integer;
      CodGrupo : Integer;
    Begin
    IRel := 0;
    For K := 0 To Length(ArrRel) - 1 Do
      Begin
      IRel := K;
      IdTeste := False;
      Try
        IdTeste := Copy(arPagina[ArrRel[K].Lin1],ArrRel[K].Col1,Length(ArrRel[K].StrId1)) = ArrRel[K].StrId1; // Access violation ???
        If ArrRel[K].StrId2 <> '' Then
          IdTeste := IdTeste And
                     (Copy(arPagina[ArrRel[K].Lin2],ArrRel[K].Col2,Length(ArrRel[K].StrId2)) = ArrRel[K].StrId2);
      Except
        ShowMessage('Buuummm');
        End; // Try
      If IdTeste Then
        Break;
      End;
    If IdTeste Then
      Begin
      //NomeArq := LimpaNomArq(ArrRel[IRel].CodRel);
      NomeArq := ChangeFileExt(ExtractFileName(NomArq),'')+'_'+LimpaNomArq(ArrRel[IRel].CodRel);
      If ArrRel[IRel].Col3 <> 0 Then // Grupos automáticos acrescenta o nome....
        Begin
        If ArrRel[IRel].Tipo3 = 'N' Then
          NomeArq := NomeArq + Format('%3.3d',[ArrRel[IRel].CodSis]) + LimpaNomArq(Copy(arPagina[ArrRel[IRel].Lin3],
                                                                                   ArrRel[IRel].Col3,ArrRel[IRel].Tam3))
        Else
          Begin
          If PesquisaCodSisGrupoPelaString(TrimRight(Copy(arPagina[ArrRel[IRel].Lin3],ArrRel[IRel].Col3,ArrRel[IRel].Tam3)),
                                           CodGrupo) = 0 Then
            NomeArq := NomeArq + Format('%3.3d',[ArrRel[IRel].CodSis]) + Format('%3.3d',[CodGrupo])
          Else
            IdTeste := False;
          End;
        QuebraRel3 := Copy(arPagina[ArrRel[IRel].Lin3],ArrRel[IRel].Col3,ArrRel[IRel].Tam3);
        End;

      ISisAuxGeral := -1; // Não há registros no ArrSisAux para o relatório em questão...
      ISisAuxEspecifico := -1;
      ISisAuxLinha := -1;
      IdTesteSis := False;

      If ArrRel[IRel].SisAuto = 'T' Then // Vai posicionar o ISisAux
        Begin
        For K := 0 To Length(ArrSisAux) - 1 Do
          If ArrRel[IRel].CodRel = ArrSisAux[K].CodRel Then
            Begin
            ISisAuxGeral := K; // Achou, guarda o índice inicial...
            Break;
            End;

        For K := ISisAuxGeral To Length(ArrSisAux) - 1 Do
          Begin
          If ArrRel[IRel].CodRel = ArrSisAux[K].CodRel Then // Ainda é uma entrada do relatório em análise...
            If ArrSisAux[K].Tipo = 'A' Then // Tipo alfa, testa os caracteres de acordo com o tamanho digitado
              For L := ArrSisAux[K].LinI To ArrSisAux[K].LinF Do  // Pode informar ranges de linhas
                Begin
                Try
                  IdTesteSis := Copy(arPagina[L],ArrSisAux[K].Col,Length(ArrSisAux[K].CodAux)) = ArrSisAux[K].CodAux;
                Except
                End; // Try
                If IdTesteSis Then
                  Begin
                  ISisAuxEspecifico := K;
                  ISisAuxLinha := L;
                  Break;
                  End;
                End
            Else
              For L := ArrSisAux[K].LinI To ArrSisAux[K].LinF Do  // Pode informar ranges de linhas
                Begin
                Try
                  IdTesteSis := StrToInt64(Trim(Copy(arPagina[L],ArrSisAux[K].Col,Length(ArrSisAux[K].CodAux)))) = StrToInt64(Trim(ArrSisAux[K].CodAux));
                Except
                End; // Try
                If IdTesteSis Then
                  Begin
                  ISisAuxEspecifico := K;
                  ISisAuxLinha := L;
                  Break;
                  End;
                End
          Else
            Break;
         If IdTesteSis Then  // Neste caso, uma entrada positiva foi encontrada, não necessitando continuar a procura...
           Break;
          End;
        If Not IdTesteSis Then // É sistema automático e não achou a identificação, invalida o teste inicial forçando a reentrada nesta rotina de teste à cada página do relatório em processo de separação...
          IdTeste := False
        Else                 // Achou, seta o nome do arquivo apropriadamente...
          NomeArq := NomeArq + Format('%3.3d',[ArrSisAux[ISisAuxEspecifico].CodSis]) +
                               Format('%3.3d',[ArrSisAux[ISisAuxEspecifico].CodGrupo])

        End;
      End;

    If Not IdTeste Then
      Begin
      NomeArq := viDirTrabApl + 'NaoSeparados\' +
                 SeArquivoSemExt(NomArq) + '_';
                              // Esta variável é NomArq -> Tem o nome do arquivo sendo processado
      End;
    End;

    Function CarregaPagina : Boolean;

    Begin
    Result := True;
    While (Not Eof(ArqIn)) Do
    //While ArqIn.Position < ArqIn.Size do
      Begin
      Inc(I);

      // Esta solução é péssima, mas depois a gente melhora....
      //repeat
      //  ArqIn.ReadBuffer(charLeitura, 1);
      //  arPagina[i] := arPagina[I] + charLeitura;
      //until (ArqIn.Position >= ArqIn.Size) or (charLeitura = #13#10);
      Readln(ArqIn,arPagina[I]);

      If arPagina[I] <> '' Then // Certifica-se que há conteúdo na linha lida...
        If arPagina[I][ColQuebra] = ChrQuebra Then  //  QuebrouPagina := True;
          Begin
          If viLimpaAutoSN = 'S' Then  // Limpa Indicador de Quebra
            arPagina[I][ColQuebra] := ' ';
          If PrimeiraPagina Then
            Begin
            PrimeiraPagina := False;
            If I = 1 Then // Se quebra de cara, despreza para encher a página toda...
              Continue;
            End;
          Exit;
          End;

      If I = 501 Then
        Begin
//        CloseFile(ArqIn);
        NomeArq := viDirTrabApl + 'NaoSeparados\' + SeArquivoSemExt(ReportRec.Name);
        FormGeral.InsereLog('Separação ',ReportRec.Name + ' + de 500 linhas em uma página');
        Result := False;
        Exit;
        End;

      End;
    End;

  Procedure DescarregaPagina;
  Var
    Faiou : Boolean;
    SeqInt,
    J : Integer;
    Nome,
    Extensao : String;
    xxArq : xArq;
  Begin
  Faiou := False;
  SeqInt := 0;

  NomeArq := 'C:\Temp\x.1';
  xxArq := xxArq;
  //Arq.Arq := TFileStream.Create(NomeArq, fmCreate or fmShareExclusive);
  //Arq.Arq.Free;
  
  If Fechado Then
    Begin
    If RichEdit1.Lines.Count = 10000 Then
      RichEdit1.Clear;
    Fechado := False;
    If IdTeste Then
      Begin
//      SeqInt := 1;
//      If FileExists(NomeArq + '.'+IntToStr(SeqInt)) Then
//        Repeat
//          Inc(SeqInt);
//        Until Not FileExists(NomeArq + '.'+IntToStr(SeqInt));
//      AssignFile(ArqOut, NomeArq + '.'+IntToStr(SeqInt));
      Nome := NomeArq;
      Extensao := '.1';
//      AssignFile(ArqOut, NomeArq + '.1');
      AssignFile(ArqOut, Nome + Extensao);
      //if not fileExists(NomeArq) then
      //  ArqOut := TFileStream.Create(NomeArq, fmCreate or fmShareExclusive)
      //else
      //  begin
      //  ArqOut := TFileStream.Create(NomeArq, fmOpenWrite or fmShareExclusive);
      //  ArqOut.Seek(ArqOut.Size, soBeginning);
      //  end;
//      RichEdit1.Lines.Add('Gerando: ' + NomeArq + '.'+IntToStr(SeqInt));
      RichEdit1.Lines.Add('Gerando: ' + NomeArq + '.1');
      Application.ProcessMessages;
      End
    Else
      Begin
      Try
        ForceDirectories(ExtractFilePath(NomeArq));
      Except
        End; // Try
//      If FileExists(NomeArq + '.S1') Then
//        Begin
//        Dec(SeqNomRel);  // Manter a ordem do sequencial apesar do loop seguinte
//        Repeat
//          Inc(SeqNomRel);
//        Until Not FileExists(NomeArq + IntToStr(SeqNomRel) + '.S1');
//        NomeArq := NomeArq + IntToStr(SeqNomRel);
//        End;

      // Inclusão da informação da extensão no nome do arquivo não separado

      Nome := NomeArq + FormIndex.StatusBar1.Panels[0].Text;
      Extensao := '.S1';

//      AssignFile(ArqOut, NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1');
      AssignFile(ArqOut, Nome + Extensao);
      //if not fileExists(NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1') then
      //  ArqOut := TFileStream.Create(NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1', fmCreate or fmShareExclusive)
      //else
      //  begin
      //  ArqOut := TFileStream.Create(NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1', fmOpenWrite or fmShareExclusive);
      //  ArqOut.Seek(ArqOut.Size, soBeginning);
      //  end;
      RichEdit1.Lines.Add('Gerando: ' + NomeArq + FormIndex.StatusBar1.Panels[1].Text + '.S1');
      Application.ProcessMessages;
      End;

    Try
      Append(ArqOut);
    Except
//      ReWrite(ArqOut);
      Faiou := True;
      End; // Try
    End;

  If Faiou Then
    Repeat
      Try
        ReWrite(ArqOut);
        Faiou := False;
      Except
        Inc(SeqInt);
        AssignFile(ArqOut, Nome + '_' + IntToStr(SeqInt) + Extensao);
      End;
    Until Not Faiou;

  If Not IdTeste Then
    Try
      arPagina[1][ColQuebra] := ChrQuebra; // Coloca o caractere de quebra novamente na página inicial do arquivo _.S1
    Except
      End;

  For J := 1 to I-1 Do    // Preservar a linha que provocou a quebra...
    WriteLn(ArqOut,arPagina[J]);
    //ArqOut.WriteBuffer(arPagina[J][1], length(arPagina[J]));
  arPagina[1] := arPagina[I]; // Vira a primeira linha da próxima página a ser montada
  I := 1;                 // Inicializa com 1 para salvar a primeira linha...
  End;

  Procedure VerificaSeQuebrouRel;
  Begin
  QuebrouRel := ArrRel[IRel].StrId1 <> Copy(arPagina[ArrRel[IRel].Lin1],ArrRel[IRel].Col1,Length(ArrRel[IRel].StrId1));
  If ArrRel[IRel].StrId2 <> '' Then
    QuebrouRel := QuebrouRel Or
                  (ArrRel[IRel].StrId2 <> Copy(arPagina[ArrRel[IRel].Lin2],ArrRel[IRel].Col2,Length(ArrRel[IRel].StrId2)));

  If ArrRel[IRel].Col3 <> 0 Then // Grupos automáticos ....
    Begin
    QuebrouRel := QuebrouRel Or
                  (QuebraRel3 <> Copy(arPagina[ArrRel[IRel].Lin3],ArrRel[IRel].Col3,ArrRel[IRel].Tam3));
    End;

  If (not QuebrouRel) and (ArrRel[IRel].SisAuto = 'T') Then // Sistema automático
    If ArrSisAux[ISisAuxEspecifico].Tipo = 'A' Then // Tipo alfa, testa os caracteres de acordo com o tamanho digitado
      QuebrouRel := Copy(arPagina[ISisAuxLinha],ArrSisAux[ISisAuxEspecifico].Col,Length(ArrSisAux[ISisAuxEspecifico].CodAux)) <>
                    ArrSisAux[ISisAuxEspecifico].CodAux
    Else
      Try
        QuebrouRel := StrToInt(Trim(Copy(arPagina[ISisAuxLinha],ArrSisAux[ISisAuxEspecifico].Col,Length(ArrSisAux[ISisAuxEspecifico].CodAux)))) <>
                      StrToInt(Trim(ArrSisAux[ISisAuxEspecifico].CodAux))
      Except
      QuebrouRel := True; // Ao dar erro de conversão assume que houve quebra do relatório...
      End; // Try
  End;

  Begin
  DtHrProc := Now;  // Marca a data e hora do início deste processamento para descarregar os relatórios não identificados
  SeqNomRel := 1;   // Sequencial

  ColQuebra := StrToInt(viColDoCarac);       // Configurações da quebra de página default
  ChrQuebra := AnsiChar(StrToInt(viDecDoCarac));

  AssignFile(ArqIn,NomArq); {Abre *.S1}
  Reset(ArqIn);
  //ArqIn := TFileStream.Create(NomArq, fmOpenRead or fmShareExclusive);

  Fechado := True;
  PrimeiraPagina := True;
  IdTeste := False;
  FlgCarregaPagina := False;

  I := 0;
  While Not Eof(ArqIn) Do
  //while ArqIn.Size > ArqIn.Position do
    Begin
    FlgCarregaPagina := CarregaPagina;
    if FlgCarregaPagina then
      If (Not IdTeste) Then
        Begin
        AchaDFN;
        If IdTeste Then
          Begin
          Try
            CloseFile(ArqOut);
            //ArqOut.Free;
            Except
            End; // Try
          Fechado := True;
          End
        End
      Else
        Begin
        VerificaSeQuebrouRel;
        If QuebrouRel Then
          Begin
          AchaDFN;
          Try
            CloseFile(ArqOut);
            //ArqOut.Free;
            Except
            End; // Try
          Fechado := True;
          End;
        End;
    DescarregaPagina;
    If Not FlgCarregaPagina Then // Página estourou, vai descarregar até a próxima
      Begin
      While Not Eof(ArqIn) Do
      //while ArqIn.Size > ArqIn.Position do
        Begin
        WriteLn(ArqOut,arPagina[1]);
        //ArqOut.WriteBuffer(arPagina[1][1], length(arPagina[1]));
        arPagina[1] := '';
        ReadLn(ArqIn,arPagina[1]);
        //repeat
        //  ArqIn.ReadBuffer(charLeitura, 1);
        //  arPagina[1] := arPagina[1] + charLeitura;
        //until (ArqIn.Size < ArqIn.Position) or (charLeitura <> #13#10);
        If arPagina[1] <> '' Then // Certifica-se que há conteúdo na linha lida...
          If arPagina[1][ColQuebra] = ChrQuebra Then  //  QuebrouPagina := True;
            Begin
            If viLimpaAutoSN = 'S' Then  // Limpa Indicador de Quebra
              arPagina[1][ColQuebra] := ' ';
            I := 1;
            Break;
            End;
        End;
      if Eof(ArqIn) then
      //if ArqIn.Size = ArqIn.Position then
        WriteLn(ArqOut,arPagina[1]); // Descarrega última linha do arquivo quando não pôde identificar a quebra
        //ArqOut.WriteBuffer(arPagina[1][1], length(arPagina[1]));
      End;
    End;
//    End;
  If FlgCarregaPagina Then
    Begin
    Inc(I); // Para forçar a descarga da página inteira......
    DescarregaPagina;  // Descarrega a última página carregada...
    End;

  Try
    CloseFile(ArqOut);     // se o .s1 estiver zerado não vai haver nenhum ArqOut para fechar...
  Except
    End;
  CloseFile(ArqIn);

  //ArqOut.Free;
  //ArqIn.Free;

  SeqNomRel := 1;   // Sequencial
  Repeat
    Try
      Rename(ArqIn, ChangeFileExt(NomArq,'.PS'+IntToStr(SeqNomRel)));
      //renameFile(NomArq, ChangeFileExt(NomArq,'.PS'+IntToStr(SeqNomRel)));
      Pare := True;
    Except
      Pare := False;
      End; // Try
    Inc(SeqNomRel);
  Until Pare;

  Dec(SeqNomRel);

  If viRemoveS1SN = 'S' Then
    DeleteFile(PChar(ChangeFileExt(NomArq,'.PS'+IntToStr(SeqNomRel))));

  If viBackAutoSN = 'S' Then
    Begin
    DirBack := viDirBackAuto + FormatDateTime('YYYY',Agora) + '\' + FormatDateTime('MM',Agora) + '\' +
                                   FormatDateTime('DD',Agora) + '\' + FormatDateTime('HH',Agora) + '\' +
                                   FormatDateTime('YYYYMMDD_HHNNSS',Agora);
    ForceDirectories(DirBack);
    MoveFile(PChar(ChangeFileExt(NomArq,'.PS'+IntToStr(SeqNomRel))),
             PChar(DirBack + '\' + ExtractFileName(ChangeFileExt(NomArq,'.PS'+IntToStr(SeqNomRel)))));
    End;

  End;

Begin

RichEdit1.Lines.Clear;
Application.ProcessMessages;
Screen.Cursor := crHourGlass;

If viSeparacaoAutoSN = 'S' Then
  Begin
  RichEdit1.Lines.Add('');
  RichEdit1.Lines.Add('Iniciando o processo de separação automática ');

  RichEdit1.Lines.Add('Carregando informações dos relatórios na memória ');

  FormGeral.QueryAux1.Close;
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM DFN WHERE (STATUS = ''A'') AND (SUBDIRAUTO = ''F'') ORDER BY CODREL');
  FormGeral.QueryAux1.Open;              // RecordCount só é setado após a varrida integral da tabela em alguns gdbs;

  SetLength(ArrRel, FormGeral.QueryAux1.RecordCount);

  I := 0;
  While Not FormGeral.QueryAux1.Eof Do
    Begin
    ArrRel[I].CodRel := FormGeral.QueryAux1.FieldByName('CodRel').AsString;
    ArrRel[I].CodSis := FormGeral.QueryAux1.FieldByName('CodSis').AsInteger;
    ArrRel[I].Col1 := FormGeral.QueryAux1.FieldByName('IDColuna1').AsInteger;
    ArrRel[I].Lin1 := FormGeral.QueryAux1.FieldByName('IDLinha1').AsInteger;
    ArrRel[I].StrId1 := FormGeral.QueryAux1.FieldByName('IDString1').AsString;
    If FormGeral.QueryAux1.FieldByName('IDString2').AsString <> '' Then
      Begin
      ArrRel[I].Col2 := FormGeral.QueryAux1.FieldByName('IDColuna2').AsInteger;
      ArrRel[I].Lin2 := FormGeral.QueryAux1.FieldByName('IDLinha2').AsInteger;
      ArrRel[I].StrId2 := FormGeral.QueryAux1.FieldByName('IDString2').AsString;
      End
    Else
      Begin
      ArrRel[I].Col2 := 0;
      ArrRel[I].Lin2 := 0;
      ArrRel[I].StrId2 := '';
      End;
    If FormGeral.QueryAux1.FieldByName('CodGrupAuto').AsBoolean Then
      Begin
      ArrRel[I].Col3 := FormGeral.QueryAux1.FieldByName('ColGrupAuto').AsInteger;
      ArrRel[I].Lin3 := FormGeral.QueryAux1.FieldByName('LinGrupAuto').AsInteger;
      ArrRel[I].Tam3 := FormGeral.QueryAux1.FieldByName('TamGrupAuto').AsInteger;
      ArrRel[I].Tipo3 := FormGeral.QueryAux1.FieldByName('TipoGrupAuto').AsString;
      End
    Else
      Begin
      ArrRel[I].Col3 := 0; // Indica a não existência de grupos automáticos
      ArrRel[I].Lin3 := 0;
      ArrRel[I].Tam3 := 0;
      End;
    ArrRel[I].SisAuto := FormGeral.QueryAux1.FieldByName('SisAuto').AsString;
    FormGeral.QueryAux1.Next;
    Inc(I);
    End;
  FormGeral.QueryAux1.Close;

  RichEdit1.Lines.Add('Carregando informações de strings auxiliares na memória ');
  FormGeral.QueryAux2.Close;
  FormGeral.QueryAux2.Sql.Clear;
  FormGeral.QueryAux2.Sql.Add('SELECT * FROM GRUPOSAUXALFADFN');
  FormGeral.QueryAux2.Sql.Add('ORDER BY CODAUXGRUPO, CODGRUPO');

  FormGeral.QueryAux2.Open;              // RecordCount só é setado após a varrida integral da tabela;

  SetLength(ArrStrAuxAlfa, FormGeral.QueryAux2.RecordCount);

  I := 0;
  While Not FormGeral.QueryAux2.Eof Do
    Begin
    ArrStrAuxAlfa[I].CodSis := FormGeral.QueryAux2.FieldByName('CodSis').AsInteger;
    ArrStrAuxAlfa[I].CodGrupo := FormGeral.QueryAux2.FieldByName('CodGrupo').AsInteger;
    ArrStrAuxAlfa[I].StrPsq := FormGeral.QueryAux2.FieldByName('CodAuxGrupo').AsString;
    FormGeral.QueryAux2.Next;
    Inc(I);
    End;

  FormGeral.QueryAux2.Close;

  FormGeral.QueryAux2.Sql.Clear;
  FormGeral.QueryAux2.Sql.Add('SELECT * FROM GRUPOSDFN');
  FormGeral.QueryAux2.Sql.Add('WHERE CODGRUPOALFA IS NOT NULL ');
  FormGeral.QueryAux2.Sql.Add('ORDER BY CODGRUPOALFA, CODGRUPO, CODSIS');

  FormGeral.QueryAux2.Open;              // RecordCount só é setado após a varrida integral da tabela;

  SetLength(ArrStrAlfa, FormGeral.QueryAux2.RecordCount);

  I := 0;
  While Not FormGeral.QueryAux2.Eof Do
    Begin
    ArrStrAlfa[I].CodSis := FormGeral.QueryAux2.FieldByName('CodSis').AsInteger;
    ArrStrAlfa[I].CodGrupo := FormGeral.QueryAux2.FieldByName('CodGrupo').AsInteger;
    ArrStrAlfa[I].StrPsq := FormGeral.QueryAux2.FieldByName('CodGrupoAlfa').AsString;
    FormGeral.QueryAux2.Next;
    Inc(I);
    End;
  FormGeral.QueryAux2.Close;

  RichEdit1.Lines.Add('Carregando informações de códigos auxiliares para SisAuto na memória ');
  FormGeral.QueryAux2.Sql.Clear;
  FormGeral.QueryAux2.Sql.Add('SELECT * FROM SISAUXDFN');
  FormGeral.QueryAux2.Sql.Add('ORDER BY CODREL');

  FormGeral.QueryAux2.Open;              // RecordCount só é setado após a varrida integral da tabela;

  SetLength(ArrSisAux, FormGeral.QueryAux2.RecordCount);

  I := 0;
  While Not FormGeral.QueryAux2.Eof Do
    Begin
    ArrSisAux[I].CodRel := FormGeral.QueryAux2.FieldByName('CodRel').AsString;
    ArrSisAux[I].CodSis := FormGeral.QueryAux2.FieldByName('CodSis').AsInteger;
    ArrSisAux[I].CodGrupo := FormGeral.QueryAux2.FieldByName('CodGrupo').AsInteger;
    ArrSisAux[I].LinI := FormGeral.QueryAux2.FieldByName('LinI').AsInteger;
    ArrSisAux[I].LinF := FormGeral.QueryAux2.FieldByName('LinF').AsInteger;
    ArrSisAux[I].Col := FormGeral.QueryAux2.FieldByName('Col').AsInteger;
    ArrSisAux[I].Tipo := FormGeral.QueryAux2.FieldByName('Tipo').AsString;
    ArrSisAux[I].CodAux := FormGeral.QueryAux2.FieldByName('CodAux').AsString;
    FormGeral.QueryAux2.Next;
    Inc(I);
    End;
  FormGeral.QueryAux2.Close;

  RichEdit1.Lines.Add('Procurando por arquivos de relatórios "*.S1" ');

  Reports1Str := viDirTrabApl + '*.S1';
                              {Procura *.S1}
  If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
    Repeat
      RichEdit1.Lines.Add('Analisando '+Reports1Rec.Name);
      Application.ProcessMessages;

      ReportStr := Reports1Str;
      ReportRec := Reports1Rec;
      AcessoExclusivo := True;

      TestFile := nil;
      Try
        TestFile := TFileStream.Create(viDirTrabApl + Reports1Rec.Name, fmOpenRead or fmShareExclusive);
      Except
        AcessoExclusivo := False
        End; // Try
      If TestFile <> nil Then
        TestFile.Free;

      If AcessoExclusivo Then
        Begin
        SeparaArquivo(viDirTrabApl + Reports1Rec.Name);
        Separou := True;
        End
      Else
        RichEdit1.Lines.Add('Arquivo '+Reports1Rec.Name+' em uso, pulando...');

    Until FindNext(Reports1Rec) <> 0;

  Sysutils.FindClose(Reports1Rec);

  End;

Screen.Cursor := crDefault;

end;

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
