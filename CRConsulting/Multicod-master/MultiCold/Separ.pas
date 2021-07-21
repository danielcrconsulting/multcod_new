Unit Separ;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ADOdb, ExtCtrls;

Type
  TFormSepar = Class(TForm)
    Panel1: TPanel;
    ButtonExecutar: TButton;
    Panel2: TPanel;
    Memo1: TMemo;
    Procedure ButtonExecutarClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormSepar: TFormSepar;

Implementation

Uses
  {Analisador, } ConfigProc, Subrug, FiltroProc, SuGeral, SuTypGer, Index;

{$R *.DFM}

Procedure TFormSepar.ButtonExecutarClick(Sender: TObject);
Var
//  SearchRec,
  ReportRec,
  Reports1Rec : TSearchRec;
  QuebraRel3,               // Cod Grupo
  NomeArq,
//  SearchStr,
  ReportStr,
  Reports1Str : AnsiString;
  ArqIn,
  ArqOut : System.Text;
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

  charLeitura : AnsiChar;

  Procedure SeparaArquivo(NomArq : AnsiString); // Separação Automática SuGeral Reference starts here

  Var
    I,
    IRel,
    ISisAuxGeral,
    ISisAuxEspecifico,
    ISisAuxLinha : Integer;
    FlgCarregaPagina : Boolean;

//    Function PesquisaCodGrupoPelaString(StrPsq : AnsiString) : AnsiString;
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
//    SeqInt,
    J : Integer;
  Begin
  If Fechado Then
    Begin
    If Memo1.Lines.Count = 10000 Then
      Memo1.Clear;
    Fechado := False;
    If IdTeste Then
      Begin
//      SeqInt := 1;
//      If FileExists(NomeArq + '.'+IntToStr(SeqInt)) Then
//        Repeat
//          Inc(SeqInt);
//        Until Not FileExists(NomeArq + '.'+IntToStr(SeqInt));
//      AssignFile(ArqOut, NomeArq + '.'+IntToStr(SeqInt));
      AssignFile(ArqOut, NomeArq + '.1');
      //if not fileExists(NomeArq) then
      //  ArqOut := TFileStream.Create(NomeArq, fmCreate or fmShareExclusive)
      //else
      //  begin
      //  ArqOut := TFileStream.Create(NomeArq, fmOpenWrite or fmShareExclusive);
      //  ArqOut.Seek(ArqOut.Size, soBeginning);
      //  end;
//      Memo1.Lines.Add('Gerando: ' + NomeArq + '.'+IntToStr(SeqInt));
      Memo1.Lines.Add('Gerando: ' + NomeArq + '.1');
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

      AssignFile(ArqOut, NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1');
      //if not fileExists(NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1') then
      //  ArqOut := TFileStream.Create(NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1', fmCreate or fmShareExclusive)
      //else
      //  begin
      //  ArqOut := TFileStream.Create(NomeArq + FormIndex.StatusBar1.Panels[0].Text + '.S1', fmOpenWrite or fmShareExclusive);
      //  ArqOut.Seek(ArqOut.Size, soBeginning);
      //  end;
      Memo1.Lines.Add('Gerando: ' + NomeArq + FormIndex.StatusBar1.Panels[1].Text + '.S1');

      End;

    Try
      Append(ArqOut);
    Except
      ReWrite(ArqOut);
      End; // Try
    End;

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
    DeleteFile(ChangeFileExt(NomArq,'.PS'+IntToStr(SeqNomRel)));

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
Memo1.Lines.Clear;
Application.ProcessMessages;
Screen.Cursor := crHourGlass;

If viSeparacaoAutoSN = 'S' Then
  Begin
  Memo1.Lines.Add('');
  Memo1.Lines.Add('Iniciando o processo de separação automática ');

//  If Length(ArrRel) = 0 Then  //Carregar sempre a tabela... Get the updates...
//    Begin

  Memo1.Lines.Add('Carregando informações dos relatórios na memória ');

  FormGeral.QueryAux1.Close;
  FormGeral.QueryAux1.CursorLocation := clUseClient; // Retorna número correto de registros 
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM DFN WHERE (STATUS = ''A'') AND (SUBDIRAUTO = ''F'') ORDER BY CODREL');
  FormGeral.QueryAux1.Open;              // RecordCount só é setado após a varrida integral da tabela em alguns gdbs;
  //While Not FormGeral.QueryAux1.Eof Do
  //  FormGeral.QueryAux1.Next;
  SetLength(ArrRel, FormGeral.QueryAux1.RecordCount);
  //FormGeral.QueryAux1.First;            // Retorna ao início para fazer o loop certo

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

  Memo1.Lines.Add('Carregando informações de strings auxiliares na memória ');
  FormGeral.QueryAux2.Close;
  FormGeral.QueryAux2.CursorLocation := clUseClient; // Retorna o número correto de registros para recordCount
  FormGeral.QueryAux2.Sql.Clear;
  FormGeral.QueryAux2.Sql.Add('SELECT * FROM GRUPOSAUXALFADFN');
  FormGeral.QueryAux2.Sql.Add('ORDER BY CODAUXGRUPO, CODGRUPO');

  FormGeral.QueryAux2.Open;              // RecordCount só é setado após a varrida integral da tabela;
  //While Not FormGeral.QueryAux2.Eof Do
  //  FormGeral.QueryAux2.Next;
  SetLength(ArrStrAuxAlfa, FormGeral.QueryAux2.RecordCount);
  //FormGeral.QueryAux2.Close;            // Retorna ao início para fazer o loop certo
  //FormGeral.QueryAux2.Open;

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

  FormGeral.QueryAux2.CursorLocation := clUseClient; // Retorna o número correto de registros para recordCount
  FormGeral.QueryAux2.Sql.Clear;
  FormGeral.QueryAux2.Sql.Add('SELECT * FROM GRUPOSDFN');
  FormGeral.QueryAux2.Sql.Add('WHERE CODGRUPOALFA IS NOT NULL ');
  FormGeral.QueryAux2.Sql.Add('ORDER BY CODGRUPOALFA, CODGRUPO, CODSIS');

  FormGeral.QueryAux2.Open;              // RecordCount só é setado após a varrida integral da tabela;
  //While Not FormGeral.QueryAux2.Eof Do
  //  FormGeral.QueryAux2.Next;
  SetLength(ArrStrAlfa, FormGeral.QueryAux2.RecordCount);
  //FormGeral.QueryAux2.Close;            // Retorna ao início para fazer o loop certo
  //FormGeral.QueryAux2.Open;

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

  Memo1.Lines.Add('Carregando informações de códigos auxiliares para SisAuto na memória ');
  FormGeral.QueryAux2.CursorLocation := clUseClient; // Retorna o número correto de registros para recordCount
  FormGeral.QueryAux2.Sql.Clear;
  FormGeral.QueryAux2.Sql.Add('SELECT * FROM SISAUXDFN');
  FormGeral.QueryAux2.Sql.Add('ORDER BY CODREL');

  FormGeral.QueryAux2.Open;              // RecordCount só é setado após a varrida integral da tabela;
  //While Not FormGeral.QueryAux2.Eof Do
  //  FormGeral.QueryAux2.Next;
  SetLength(ArrSisAux, FormGeral.QueryAux2.RecordCount);
  //FormGeral.QueryAux2.Close;            // Retorna ao início para fazer o loop certo
  //FormGeral.QueryAux2.Open;

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

  Memo1.Lines.Add('Procurando por arquivos de relatórios "*.S1" ');

  Reports1Str := viDirTrabApl + '*.S1';
                              {Procura *.S1}
  If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
    Repeat
      Memo1.Lines.Add('Analisando '+Reports1Rec.Name);
      Application.ProcessMessages;

      Separou := True;
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
        SeparaArquivo(viDirTrabApl + Reports1Rec.Name)
      Else
        Memo1.Lines.Add('Arquivo '+Reports1Rec.Name+' em processo de cópia, pulando');

      Processou := True;
      Break;  // Alterar a rotina de processamento para separar e indexar arquivo por arquivo

    Until FindNext(Reports1Rec) <> 0;

  FindClose(Reports1Rec);

  End;

Screen.Cursor := crDefault;
//Semaforo := True;
End;

End.
