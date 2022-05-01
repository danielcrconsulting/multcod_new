Unit Descom;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ComObj, OleServer, uclsAux {IMulticoldServer1},
  UMetodosServer,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.FireDACJSONReflect,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB;

Type
  TFrmDescom = Class(TForm)
    ButtonArquivo: TButton;
    SairBut: TButton;
    SaveDialog1: TSaveDialog;
    ProgressBar1: TProgressBar;
    Edit3: TEdit;
    ButtonClipBoard: TButton;
    ButtonWord: TButton;
    Label2: TLabel;
    ButtonExcel: TButton;
    Label3: TLabel;
    ArqTempl: TEdit;
    OpenDialog1: TOpenDialog;
    RemLinBran: TCheckBox;
    GroupBox1: TGroupBox;
    RadioPagAtu: TRadioButton;
    RadioPesq: TRadioButton;
    RadioPag: TRadioButton;
    RadioTudo: TRadioButton;
    Edit1: TEdit;
    CheckPesq: TCheckBox;
    Label1: TLabel;
    Edit2: TEdit;
    CheckOrig: TCheckBox;
    ButtonPdf: TButton;
    Memo1: TMemo;
    iCRLF: TCheckBox;
    FDQuery1: TFDQuery;
    Procedure FormCreate(Sender: TObject);
    Procedure ButtonArquivoClick(Sender: TObject);
    Procedure SairButClick(Sender: TObject);
    Procedure Edit1Change(Sender: TObject);
    Procedure RadioTudoClick(Sender: TObject);
    Procedure CheckPesqClick(Sender: TObject);
    Procedure ArqTemplDblClick(Sender: TObject);
    Procedure RadioPesqClick(Sender: TObject);
    Procedure RadioPagClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    OMetodosServer : clsMetodosServer;
    function SalvarDescompactacaoNoBanco: Boolean;
  Public
    { Public declarations }
  End;

Var
  FrmDescom: TFrmDescom;
//  Lcid : Integer;

Implementation

Uses Mdiedit, MdiMultiCold, SuTypGer, ZLib, Template, Grids, Subrug, SuGeral,
  LogInForm, Avisoi, dfPDF, LocalizarU, UFrmConsultaExportacoesRemoto;

{$R *.DFM}

Const
  xlWBatWorkSheet = -4167;
Var
  Filtros : TFiltro;

procedure TFrmDescom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Freeandnil(OMetodosServer);
end;

Procedure TFrmDescom.FormCreate(Sender: TObject);
Begin
Filtros := TFiltro.Create;
RadioPagAtu.Checked := True;
OpenDialog1.InitialDir := 'C:\ColdCfg';
  //OMetodosServer := clsMetodosServer.Create(Self);
  //OMetodosServer.Configurar;
End;

procedure TFrmDescom.FormShow(Sender: TObject);
var
  remoto: Boolean;
begin
  remoto := TEditForm(FrameForm.ActiveMDIChild).RelRemoto;
  ButtonClipBoard.Visible := not remoto;
  ButtonWord.Visible := not remoto;
  ButtonExcel.Visible := not remoto;
  ButtonPdf.Visible := not remoto;
  Label3.Visible := not remoto;
  ArqTempl.Visible := not remoto;
  iCRLF.Visible := not remoto;
end;

Procedure TFrmDescom.ButtonArquivoClick(Sender: TObject);

Var
  I, J, K,
  L : Integer;
  LinAux{,
  Linha , Linha133} : String;
  Posic,
  PgIni,
  PgFin,
  PgOri,
  Erro : Integer;
  LinPrese : Set Of Byte;
  ListaDeGrids : Array[0..1000] Of TComponent;
  Year,
  Month,
  Day : Word;
  AuxData : TDateTime;
  PrimeiraVez : Boolean;
  urlBase: String;
  opcaoAux : Word;

  Procedure TrabalhaADescompactacao(I : Integer);

  Var
    Ind,
    ILinha : Integer;
    Apendix,
    Apendix2,
    AuxStr,
    RegAux,
    RegInd : String;
//    AllBranco : Boolean;

    Function TestaFiltro(I : Integer) : Boolean;
    Var
      K: Integer;
    Begin
    If Filtros.FiltroIn[I] <> [] Then
       For K := 1 To Length(RegInd) Do
         If Not (RegInd[K] In Filtros.FiltroIn[I]) Then
           Begin
           RegInd := '';
           Break;
           End;

    If Filtros.FiltroOut[I] <> [] Then
       For K := 1 To Length(RegInd) Do
         If (RegInd[K] In Filtros.FiltroOut[I]) Then
           Begin
           RegInd := '';
           Break;
           End;

    If RegInd <> '' Then
      If Filtros.StrInc[I].Col <> 0 Then
        If Copy(TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind],Filtros.StrInc[I].Col,Filtros.StrInc[I].Tam) <> Filtros.StrInc[I].FilStr Then
          RegInd := '';    { Conteudo difere da linha a ser incluida }

    If RegInd <> '' Then
      If Filtros.StrExc[I].Col <> 0 Then
        If Copy(TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind],Filtros.StrExc[I].Col,Filtros.StrExc[I].Tam) = Filtros.StrExc[I].FilStr Then
          RegInd := '';    { Conteudo igual a da linha a ser excluida }
    If RegInd = '' Then
      TestaFiltro := False
    Else
      TestaFiltro := True;
    End;

    Procedure RodaTemplate;
    Var
      ILinha,
      Ky : Integer;

      Procedure AndaNoFormatoAndObtemUmNumero;
      Var
        Ori : String;
      Begin
      With TStringGrid(ListaDeGrids[ILinha]) Do
        Begin
        If Ky > Length(Cells[1,12]) Then
          Exit;
        Ori := Cells[1,12][Ky];
        RegAux := '';
        While (Length(Cells[1,12]) >= Ky) And (Cells[1,12][Ky] = Ori) Do
          Begin
          RegAux := RegAux + RegInd[Ky];
          Inc(Ky);
          End;
        Case Ori[1] Of
          'D' : Day := StrToInt(RegAux);
          'M' : Month := StrToInt(RegAux);
          'Y' : Begin
                Year := StrToInt(RegAux);
                If Length(RegAux) = 2 Then
                  If Year <= 50 Then
                    Year := Year + 2000
                  Else
                    Year := Year + 1900;
                End;
          End; // Case
        If Ky < Length(Cells[1,12]) Then
          If Not (Cells[1,12][Ky] In ['D','M','Y']) Then
            Inc(Ky);   // Pula o separador
        End;
      End;

      Function FormataData : String;

      Begin
      Result := RegInd;
      With TStringGrid(ListaDeGrids[ILinha]) Do
        If Not ((Cells[1,12] <> '') And (Cells[1,13] <> '') And (RegInd <> '')) Then // Não há formatação especificada ou o campo está vazio...
          Exit;

      Result := '';
      With TStringGrid(ListaDeGrids[ILinha]) Do
        Begin
        RegAux := Cells[1,12];
        While Pos('A',RegAux) <> 0 Do
          RegAux[Pos('A',RegAux)] := 'Y';
        While Pos('a',RegAux) <> 0 Do
          RegAux[Pos('a',RegAux)] := 'Y';
        Cells[1,12] := RegAux;

        RegAux := Cells[1,13];
        While Pos('A',RegAux) <> 0 Do
          RegAux[Pos('A',RegAux)] := 'Y';
        While Pos('a',RegAux) <> 0 Do
          RegAux[Pos('a',RegAux)] := 'Y';
        Cells[1,13] := RegAux;


        Day := 0;
        Month := 0;
        Year := 0;

        Ky := 1;

        AndaNoFormatoAndObtemUmNumero;
        AndaNoFormatoAndObtemUmNumero;
        AndaNoFormatoAndObtemUmNumero;

        Try
          AuxData := EncodeDate(Year,Month,Day);
          Result := FormatDateTime(Cells[1,13],AuxData);
        Except
          FormGeral.MostraMensagem('Erro na conversão da data...');
          End;
        End;
      End;

      Function FormataCX(ParEntra : String) : String;
      Var
        I : Integer;
      Begin
      Result := ParEntra;
      TStringGrid(ListaDeGrids[ILinha]).Cells[1,12] := UpperCase(TStringGrid(ListaDeGrids[ILinha]).Cells[1,12]);
      RegAux := TStringGrid(ListaDeGrids[ILinha]).Cells[1,12];
      If RegAux = '' Then
        Exit;
      If (Pos('C',RegAux) = 0) And (Pos('X',RegAux) = 0) Then
        Exit;
      Result := '';
      With TStringGrid(ListaDeGrids[ILinha]) Do
        For I := 1 To Length(RegAux) Do
          Begin
          If I > Length(ParEntra) Then
            Break;
          If RegAux[I] = 'C' Then
            Result := Result + ParEntra[I];
          End;
      End;

    Begin
    Apendix := '';
    For ILinha := 0 To L Do     // Varre todos os Campos  Era 1
      With TStringGrid(ListaDeGrids[ILinha]) Do
        Begin
        RegInd := Copy(TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind],StrToInt(Cells[1,3]), StrToInt(Cells[1,4]));  // Linha candidata
        If Cells[1,12] <> '' Then
          RegInd := FormataCX(RegInd);
        Case Cells[1,5][1] Of    { Tratamento de Brancos }
          '0' : RegInd := SeTiraBranco(RegInd);
          '1' : RegInd := TrimRight(RegInd);
          '2' : RegInd := TrimLeft(RegInd);
          '3' : Begin
                End; // Sem Tratamento de Brancos
          '4' : RegInd := Trim(RegInd);
          End; // Else

        If (Ind+1 >= StrToInt(Cells[1,1])) And (Ind+1 <= StrToInt(Cells[1,2])) And (RegInd <> '') And
           TestaFiltro(ILinha) Then
          Begin

          RegInd := FormataData; // Depois de filtrado verifica se formata a data...

          If TemExcel Then
            Begin
            Case Cells[1,7][1] Of
            'C' : Begin

                  RegAux := '''';
                  For Ky := 1 To  Length(RegInd) Do
                    If Not (RegInd[Ky] In ['0'..'9','.']) Then  // Há caracteres diferentes de número
                      Begin
                      RegAux := '';       // limpa
                      Break;
                      End;

                  RegInd := RegAux + RegInd;

                  End;
            'F' : Begin

                  RegAux := '';
                  For Ky := 1 To Length(RegInd) Do
                    If (RegInd[Ky] In ['0'..'9','+','-',',']) Then
                      RegAux := RegAux + RegInd[Ky];

                  Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
                  If Posic = 0 Then
                    Posic := Pos('-',RegAux);

                  If Posic <> 0 Then
                    Begin
                    AuxStr := RegAux[Posic];
                    Delete(RegAux,Posic,1);
                    RegAux := AuxStr + RegAux;
                    End;

                  RegInd := RegAux;

                  If Pos(',',RegInd) <> 0 Then
                    RegInd[Pos(',',RegInd)] := '.';

                  End;
            'D' : Begin

                  RegAux := '';
                  For Ky := 1 To Length(RegInd) Do
                    If (RegInd[Ky] In ['0'..'9','+','-','.']) Then
                      RegAux := RegAux + RegInd[Ky];

                  Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
                  If Posic = 0 Then
                    Posic := Pos('-',RegAux);

                  If Posic <> 0 Then
                    Begin
                    AuxStr := RegAux[Posic];
                    Delete(RegAux,Posic,1);
                    RegAux := AuxStr + RegAux;
                    End;

                  RegInd := RegAux;

                  End;
            'N' : Begin
                  RegAux := '';
                  For Ky := 1 To Length(RegInd) Do
                    If (RegInd[Ky] In ['0'..'9','+','-']) Then
                      RegAux := RegAux + RegInd[Ky];

                  Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
                  If Posic = 0 Then
                    Posic := Pos('-',RegAux);

                  If Posic <> 0 Then
                    Begin
                    AuxStr := RegAux[Posic];
                    Delete(RegAux,Posic,1);
                    RegAux := AuxStr + RegAux;
                    End;

                  RegInd := RegAux;

                  End;
              End; //Case
//            ExcelWorksheet1.Cells.Item[K, ILinha+1].Value := RegInd;
            ExcelApp.WorkBooks[1].WorkSheets[1].Cells[IExcel,ILinha+1] := RegInd;
            Apendix := Apendix + RegInd;  //
            End
          Else
            Begin
            Apendix := Apendix + Format('%-'+Cells[1,4]+'s',[RegInd])+' '; // Branco espaçador
            End;
          End
        Else
          Begin            // Preenche com brancos para manter formatação Do texto
          Apendix := Apendix + Format('%-'+Cells[1,4]+'s',[' '])+' '; // Branco espaçador
          End;
        End;
 {   AllBranco := False;
    If (RemLinBran.Checked) Then
      Begin
      AllBranco := True;
      For ILinha := 1 To Length(Apendix) Do
        If Apendix[ILinha] <> ' ' Then
          Begin
          AllBranco := False;
          Break;
          End;
      End;  }
//    If (RemLinBran.Checked) And AllBranco Then
    If (RemLinBran.Checked) And Apendix.IsNullOrWhiteSpace(Apendix) Then
      Begin
      End
    Else
    If TemExcel Then
      Inc(IExcel)
    Else
    If TemWord Then
      WordApp.WordBasic.Insert(Apendix+CrLf)
    Else
      Begin
      //BlockWrite(ArqDsc,Apendix[1],Length(Apendix),Erro);
      //BlockWrite(ArqDsc,CrLf,2,Erro);
      Apendix2 := Apendix+CrLf;
      ArqDscNew.WriteBuffer(Apendix2[1],Length(Apendix2));
      End;
    End;

  Begin

//  FrameForm.Timer10.Enabled := False; // Refresh Timer
//  FrameForm.Timer10.Enabled := True;

  If (TEditForm(FrameForm.ActiveMDIChild).Mascara And (Not TemExcel) And    // Mascara, no excel, no word, no pesq, PDF --> Ok
     (Not TemWord) And (Not CheckPesq.Checked) And (TipoSaida = 'PDF')) Or
     ((Not TEditForm(FrameForm.ActiveMDIChild).Mascara) And (Not CheckPesq.Checked)
       And (TipoSaida = 'PDF')) Then // Só PDF
    With TEditForm(FrameForm.ActiveMDIChild) Do
      Begin
//      DFEngine1.SavetoFile(ExtractFilePath(SaveDialog1.FileName)+
//                           ChangeFileExt(ExtractFileName(FileName),'_'+IntToStr(I)+'.bmp'));

      Screen.Cursor := crHourGlass;
      CarregaImagem(False,I);
      Pdf.MaxPages := Pdf.MaxPages + 1;
      Pdf.AddDFPage(DFEngine1.Pages[0]);
//      Pdf.AddMltPage(ArrPag);
      AdicionouPaginaPdf := True;
      Screen.Cursor := crDefault;

      If Not RadioPesq.Checked Then
        ProgressBar1.Position := I;
      Edit3.Text := IntToStr(I);
      Application.ProcessMessages;
      Exit; // Coloquei agora, só gera o PDF..... 20030211
      End;

//  Linha := '';
//  Linha133 := '';
  TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada := '';
  TEditForm(FrameForm.ActiveMDIChild).PaginaNormal := '';

//  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, Linha133, Linha, CheckOrig.Checked);
  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, CheckOrig.Checked);

  If (ArqTempl.Text <> '') And (IExcel = 1) Then
    Begin                            // Dar o nome dos campos à primeira linha da exportação
    Apendix := '';
    For ILinha := 0 To L Do   // Era 1
      With TStringGrid(ListaDeGrids[ILinha]) Do
        Begin                                                              // Trunca o nome
        Apendix := Apendix + Format('%-'+Cells[1,4]+'s',[Copy(Cells[1,6],1,StrToInt(Cells[1,4])-1)])+' ';
        If TemExcel Then
          Begin
//          ExcelWorksheet1.Cells.Item[K, ILinha+1].Value := Cells[1,6];
          ExcelApp.WorkBooks[1].WorkSheets[1].Cells[IExcel,ILinha+1] := Cells[1,6];
          End;
        End;
    If TemExcel Then
      Inc(IExcel)  // Avança ponteiro
    Else
      Begin
      Inc(IExcel);             // Força a alteração Do valor para não entrar de novo
      If TemWord Then
        WordApp.WordBasic.Insert(Apendix+CrLf)
      Else
        Begin
        //BlockWrite(ArqDsc,Apendix[1],Length(Apendix),Erro);
        //BlockWrite(ArqDsc,CrLf,2,Erro);
        ArqDscNew.WriteBuffer(Apendix[1],Length(Apendix));
        ArqDscNew.WriteBuffer(CrLf,2);
        End;
      End;
    End;

  If RadioPesq.Checked And CheckPesq.Checked Then
    Begin
    If TEditForm(FrameForm.ActiveMDIChild).Report133CC Then
      TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaNormal                        // Usa o não acertado
    Else
      If CheckOrig.Checked Then
        TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaNormal
      Else
        TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada;

    LinPrese := [];

    //k := 0; Variável k é inicializada antes de chamar este procedimento
    //PgIni := strToInt(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k,1]);
    PgIni := TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k].Pagina;
    //while (k <= high(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil)) and
    //      (PgIni = strToInt(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k,1])) do
    while (k <= high(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil)) and
          (PgIni = TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k].Pagina) do
      begin
      //Posic := 3;
      //while (Posic <= high(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[1])+1) do
      //  begin
        LinPrese := LinPrese + [Byte(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k].Linha)];
      //  Inc(Posic,5);     { Cada Campo de pesquisa gera 5 campos na Tabela }
      //  end;
      inc(k);
      end;

    (*
    If TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
      Begin
      PgIni := TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[1].AsInteger;
      while (PgIni = TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[1].AsInteger) and
            (Not TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Eof)  Do
        Begin
        Posic := 3;         // Para Pegar todos os Campos da Query...
        While Posic <= TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.FieldCount Do
          Begin
          LinPrese := LinPrese + [Byte(TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[Posic].AsInteger)];
          Inc(Posic,5);     { Cada Campo de pesquisa gera 5 campos na Tabela }
          End;
        TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Next;
        End;
      End
    Else
      Begin
      PgIni := TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger;
      while (PgIni = TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger) and
            (Not TEditForm(FrameForm.ActiveMDIChild).Query1.Eof)  Do
        Begin
        Posic := 3;         // Para Pegar todos os Campos da Query...
        While Posic <= TEditForm(FrameForm.ActiveMDIChild).Query1.FieldCount Do
          Begin
          LinPrese := LinPrese + [Byte(TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[Posic].AsInteger)];
          Inc(Posic,5);     { Cada Campo de pesquisa gera 5 campos na Tabela }
          End;
        TEditForm(FrameForm.ActiveMDIChild).Query1.Next;
        End;
      End;
    *)

    For Ind := 0 To TEditForm(FrameForm.ActiveMDIChild).StrPagina.Count - 1 Do
      If Ind+1 In LinPrese Then
        Begin
        If ArqTempl.Text <> '' Then // Aplicar o Template
          RodaTemplate
        Else
        if RemLinBran.Checked And TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind].IsNullOrWhiteSpace(
                                            TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind]) then
          begin
          end
        else
        If TemWord Then
          WordApp.WordBasic.Insert(TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind]+CrLf)
        Else
        If TemExcel Then
          Begin
          ExcelApp.WorkBooks[1].WorkSheets[1].Cells[IExcel,1] := TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind];
          Inc(IExcel);
          End
        Else
          Begin
          ArqDscNew.Seek(ArqDscNew.Size, soBeginning);
          ArqDscNew.WriteBuffer(TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind][1],
                     Length(TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind]));
          ArqDscNew.WriteBuffer(CrLf,2);
          End;
        End;
    End
  Else
    Begin
    If ArqTempl.Text <> '' Then // Aplicar o Template
      Begin
      If CheckOrig.Checked Then
        TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaNormal
      Else
        TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada;
      LinAux := '';

      For Ind := 0 To TEditForm(FrameForm.ActiveMDIChild).StrPagina.Count - 1 Do
        RodaTEmplate;
      End
    Else
      Begin

      If CheckOrig.Checked Then
        TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaNormal
      Else
        TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada;

      if RemLinBran.Checked then
        begin
        Ind := 0;
        While Ind <= TEditForm(FrameForm.ActiveMDIChild).StrPagina.Count - 1 Do
          Begin
          if TEditForm(FrameForm.ActiveMDIChild).StrPagina[ind].IsNullOrWhiteSpace(
                       TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind]) then
            TEditForm(FrameForm.ActiveMDIChild).StrPagina.Delete(Ind);
          inc(Ind);
          end;
        end;

      If TemWord Then
        Begin

        If PrimeiraVez Then
          PrimeiraVez := False
        Else
          WordApp.WordBasic.Insert(#12); // Quebra a página
        WordApp.WordBasic.Insert(TEditForm(FrameForm.ActiveMDIChild).StrPagina.Text+CrLf);
        End
      Else
      If TemExcel Then
        Begin

        For Ind := 0 To TEditForm(FrameForm.ActiveMDIChild).StrPagina.Count - 1 Do
          Begin

          ExcelApp.WorkBooks[1].WorkSheets[1].Cells[IExcel,1] := TEditForm(FrameForm.ActiveMDIChild).StrPagina[Ind];
          Inc(IExcel);

          if ExcelApp.Version <= 12 then
            begin
            if IExcel = 65536+1 then
              begin
              messageDlg('Relatório é maior que a capacidade do Excel. Abortando a operação. O relatório será exibido até o limite de 65.536 linhas suportado pelo Excel.',mtWarning,[mbOk],0);
              SairBut.Click;
              exit;
              end;
            end
          else
            begin
            if IExcel = 1048576+1 then
              begin
              messageDlg('Relatório é maior que a capacidade do Excel. Abortando a operação. O relatório será exibido até o limite de 1.048.576 linhas suportado pelo Excel.',mtWarning,[mbOk],0);
              SairBut.Click;
              exit;
              end;
            end;
          End;
        End
      Else
        If CheckOrig.Checked Then
          begin
          //BlockWrite(ArqDsc,TEditForm(FrameForm.ActiveMDIChild).PaginaNormal[1],Length(TEditForm(FrameForm.ActiveMDIChild).PaginaNormal),Erro)
          ArqDscNew.WriteBuffer(TEditForm(FrameForm.ActiveMDIChild).PaginaNormal[1],Length(TEditForm(FrameForm.ActiveMDIChild).PaginaNormal));
          end
        Else
          begin
          //BlockWrite(ArqDsc,TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada[1],Length(TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada),Erro);
          ArqDscNew.WriteBuffer(TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada[1],Length(TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada));
          end;
      End;
    End;
  If Not RadioPesq.Checked Then
    ProgressBar1.Position := I;
  Edit3.Text := IntToStr(I);
  Application.ProcessMessages;
  End;

  Function SlonSaveDialog1 : Boolean;
  Begin
  If (Sender = ButtonArquivo) Or (Sender = ButtonPdf) Then
    Begin
  //  SaveDialog1.FileName := '';
    SaveDialog1.FileName := FormatDateTime('YYYYMMDDHHNNSS',Now);
    SlonSaveDialog1 := SaveDialog1.Execute;
    End
  Else
    Begin
    SaveDialog1.FileName := PathCfg+'Temp.txt';
    SlonSaveDialog1 := True;
    End;
  End;

Begin
  QuerCancelar := False;

  If Length(TEditForm(FrameForm.ActiveMDIChild).ArrBloqCamposDoRel) <> 0 Then
  Begin
    ShowMessage('Você tem bloqueio de campos neste relatório, não poderá exportar dados...');
    Exit;
  End;

  if TEditForm(FrameForm.ActiveMDIChild).RelRemoto then
  begin
    // Se for relatório remoto, inserir no banco de dados e abrir a página de consulta Processamento.
    if SalvarDescompactacaoNoBanco then
    begin
      Close;
      urlBase := FrameForm.ObterUrlBase;

      FrmConsultaExportacoesRemoto.SetParameters(LogInRemotoForm.UsuEdit.Text, urlBase);
      FrmConsultaExportacoesRemoto.ShowModal;

      exit;
    end else
      exit;
  end;

If ArqTempl.Text <> '' Then  // Usuário selecionou um template de exportação
  Begin
  FrmTemplate.LeTemplate(ArqTempl.Text);
  For L := 0 To 1000 Do  // Era 1
    ListaDeGrids[L] := Nil;
  L := 0;       // Era 1
  For J := 0 To FrmTemplate.PageControl1.PageCount-1 Do
    Begin
    Try
      ListaDeGrids[L] := FrmTemplate.PageControl1.Pages[J].Components[0];
    Except
      ListaDeGrids[L] := FrmTemplate.GridTmpl;
      End; // Try

    With TStringGrid(ListaDeGrids[L]) Do
      Begin
      SetLength(Filtros.FiltroIn,J+1);
      Filtros.FiltroIn[L] := [];
      If Cells[1,8] <> '' Then
        If Not Filtros.EncheFiltro(Cells[1,8],Cells[1,6],Filtros.FiltroIn[L],L) Then
          Begin
          FormGeral.MostraMensagem('Erro no template, CharInc inválido...');
          Exit;
          End;

      SetLength(Filtros.FiltroOut,J+1);
      Filtros.FiltroOut[L] := [];
      If Cells[1,9] <> '' Then
        If Not Filtros.EncheFiltro(Cells[1,9],Cells[1,6],Filtros.FiltroOut[L],L) Then
          Begin
          FormGeral.MostraMensagem('Erro no template, CharExc inválido...');
          Exit;
          End;

      SetLength(Filtros.StrInc,J+1);
      Filtros.StrInc[L].Col := 0;
      Filtros.StrInc[L].Tam := 0;
      Filtros.StrInc[L].FilStr := '';
      If Cells[1,10] <> '' Then
        If Not Filtros.EncheStr(Cells[1,10],Cells[1,6],Filtros.StrInc[L],L) Then
          Begin
          FormGeral.MostraMensagem('Erro no template, StrInc inválido...');
          Exit;
          End;

      SetLength(Filtros.StrExc,J+1);
      Filtros.StrExc[L].Col := 0;
      Filtros.StrExc[L].Tam := 0;
      Filtros.StrExc[L].FilStr := '';
      If Cells[1,11] <> '' Then
        If Not Filtros.EncheStr(Cells[1,11],Cells[1,6],Filtros.StrExc[L],L) Then
          Begin
          FormGeral.MostraMensagem('Erro no template, StrExc inválido...');
          Exit;
          End;

          // Faz verificações nos campos Do template

      Try
        StrToInt(Cells[1,1]);  // Testa os valores
      Except
        FormGeral.MostraMensagem('Erro no template, Linha Inicial Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
        Exit;
        End; // Try

      Try
        StrToInt(Cells[1,2]);  // Testa os valores
      Except
        FormGeral.MostraMensagem('Erro no template, Linha Final Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
        Exit;
        End; // Try

      Try
        StrToInt(Cells[1,3]);
      Except
        FormGeral.MostraMensagem('Erro no template, Coluna Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" inválida');
        Exit;
        End; // Try

      Try
        StrToInt(Cells[1,4]);
      Except
        FormGeral.MostraMensagem('Erro no template, Tamanho Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" inválido');
        Exit;
        End; // Try

      If Length(Cells[1,5]) <> 1 Then     { Tratamento de Brancos }
        Begin
        FormGeral.MostraMensagem('Erro no template, Número de Caracteres Do Tratamento de Brancos Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
        Exit;
        End;

      If Not (Cells[1,5][1] In ['0','1','2','3','4']) Then
        Begin
        FormGeral.MostraMensagem('Erro no template, Tratamento de Brancos Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
        Exit;
        End;

      Cells[1,7] := Uppercase(Cells[1,7]);

      If Length(Cells[1,7]) <> 1 Then
        Begin
        FormGeral.MostraMensagem('Erro no template, Número de Caracteres Do Tipo Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
        Exit;
        End;

      If Not (Cells[1,7][1] In ['C','F','D','N']) Then
        Begin
        FormGeral.MostraMensagem('Erro no template, Tipo Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
        Exit;
        End;

      End;
    Inc(L);
    End;
  Dec(L);  // L Passa a ser o número exato de Campos
  End;

Avisop.Label1.Caption := 'Preparando para exportar...';
Avisop.Show;
Application.ProcessMessages;

If Primeiro Then
  Begin
  TEditForm(FrameForm.ActiveMDIChild).Pdf := TDF6toPDFConverter.Create;

  If (Sender = ButtonClipBoard) Or
     (Sender = ButtonWord) Or
     (Sender = ButtonExcel) Then
    Begin
    AssignFile(ArqDsc,PathCfg+'Temp.txt');
    Try
      Erase(ArqDsc);
      Except
      End; // Try
    End
  Else
    If Sender = ButtonArquivo Then
      Begin
      TipoSaida := 'ARQUIVO';
      SaveDialog1.Filter := '*.txt|*.txt';
      SaveDialog1.DefaultExt := 'txt';
      End
    Else
      Begin
      TipoSaida := 'PDF';
      SaveDialog1.Filter := '*.pdf|*.pdf';
      SaveDialog1.DefaultExt := 'pdf';
      End;
  End;

If Primeiro Then
  TemWord:= False;
If (Sender = ButtonWord) Then
  Begin
  TemWord := True;
  If Primeiro Then
    Try
      WordApp := CreateOleObject('Word.Application');
      TipoSaida := 'WORD';
    Except
        TemWord := False;
        FormGeral.MostraMensagem('MS Word não está instalado neste computador...');
        Exit;
      End; // Try

  If Primeiro And TemWord Then
    Begin
    WordApp.Documents.Add;                          //Cria um paginão
    WordApp.Documents.Item(1).PageSetup.PageWidth := WordApp.Documents.Item(1).PageSetup.PageWidth +
                                                     (WordApp.Documents.Item(1).PageSetup.PageWidth Div 2);
    WordApp.Documents.Item(1).PageSetup.PageHeight := WordApp.Documents.Item(1).PageSetup.PageHeight +
                                                      (WordApp.Documents.Item(1).PageSetup.PageHeight Div 2);
    WordApp.Documents.Item(1).Range.Font.Name := TEditForm(FrameForm.ActiveMDIChild).Video.Name;
    WordApp.Documents.Item(1).Range.Font.Size := TEditForm(FrameForm.ActiveMDIChild).Video.Size;
    End;

  TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada := '';
  End;

If Primeiro Then
  Begin
  TemExcel := False;
  IExcel := 1;
  End;
If Sender = ButtonExcel Then
  Begin
  TemExcel := True;

  If Primeiro Then
//    try
//      ExcelApp := GetActiveOleObject('Excel.Application');
//      TipoSaida := 'EXCEL';
//    except
      try
        // If no instance of Excel is running, try to Create a new Excel Object -> Não funciona a contento
      ExcelApp := CreateOleObject('Excel.Application');
      TipoSaida := 'EXCEL';
      except
        TemExcel := False;
        FormGeral.MostraMensagem('Excel não está instalado neste computador?');
        Exit;
      end;
//    end;

  If Primeiro And TemExcel Then
    Begin
    ExcelApp.WorkBooks.Add(xlWBatWorkSheet);
    ExcelApp.WorkBooks[1].WorkSheets[1].Name := 'DADOS MultiCold';
    ExcelApp.WorkBooks[1].WorkSheets[1].Cells.Font.Name := TEditForm(FrameForm.ActiveMDIChild).Video.Name;
    ExcelApp.WorkBooks[1].WorkSheets[1].Cells.Font.Size := TEditForm(FrameForm.ActiveMDIChild).Video.Size;
    End;
  End;

Avisop.Close;
PrimeiraVez := True; // Word #12 Control

If (TipoSaida = 'PDF') Then
  If (TEditForm(FrameForm.ActiveMDIChild).Mascara And (Not TemExcel) And    // Mascara, no excel, no word, no pesq, PDF --> Ok
    (Not TemWord) And (Not CheckPesq.Checked)) Or
   ((Not TEditForm(FrameForm.ActiveMDIChild).Mascara) And (Not CheckPesq.Checked)) Then // Sem mascara e página inteira...
    Begin
    End
  Else
    Begin
    ShowMessage('PDF não pode ser gerado com estes parâmetros...');
    Exit;
    End;

If RadioPagAtu.Checked Then
  Begin
  If SlonSaveDialog1 Then
    Begin
    If FileExists(SaveDialog1.FileName) And (UpperCase(SaveDialog1.FileName) <> 'TEMP.TXT') Then
      begin

      opcaoAux := MessageDlg('O arquivo informado já existe. Deseja substituir o arquivo atual com os dados desta descompactação ? '+#13#10+
                             'Clique: [Yes] para substituir; [No] para adcionar novos dados ao arquivo existente; [Cancel] para cancelar a operação.', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

      if opcaoAux = mrYes then
        begin
        deleteFile(SaveDialog1.FileName);
        ArqDscNew := TFileStream.Create(SaveDialog1.FileName, fmCreate);
        end
      else if opcaoAux = mrNo then
        begin
        ArqDscNew := TFileStream.Create(SaveDialog1.FileName, fmOpenWrite or fmShareExclusive);
        ArqDscNew.Seek(ArqDscNew.Size, soBeginning);
        end
      else
        exit;

      end // If FileExists(SaveDialog1.FileName) And (UpperCase(SaveDialog1.FileName) <> 'TEMP.TXT') Then
    else
      ArqDscNew := TFileStream.Create(SaveDialog1.FileName, fmCreate);     // Romero em 21/09/2013

    ProgressBar1.Min := 0;     // Para não dar erro !
    ProgressBar1.Max := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;
    ProgressBar1.Min := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;

    TrabalhaADescompactacao(TEditForm(FrameForm.ActiveMDIChild).PaginaAtu);

    //CloseFile(ArqDsc);
    ArqDscNew.Free;

    End
  Else
    Exit;
  End
Else
If RadioPesq.Checked Then
  Begin

  If (TEditForm(FrameForm.ActiveMDIChild).Ocorre = 0) Then
    Begin
    FormGeral.MostraMensagem('Nenhuma pesquisa realizada???');
    Exit;
    End;

//  If (Not Primeiro) Or SlonSaveDialog1 Then
  If (AbriuArqDsc) Or SlonSaveDialog1 Then
    Begin

    //AssignFile(ArqDsc,SaveDialog1.FileName);
    If Not AbriuArqDsc Then
      Begin
      SaveDialog1FileName := SaveDialog1.FileName; // Save for further reference at caller
      If FileExists(SaveDialog1.FileName) And (UpperCase(SaveDialog1.FileName) <> 'TEMP.TXT') Then
        begin
        If MessageDlg('Arquivo já Existe, Continua?', mtWarning,[mbYes,mbNo],0) In [mrCancel, mrNo] Then
          Exit
        else
          deleteFile(SaveDialog1.FileName);
        end;
      //ReWrite(ArqDsc,1);
      ArqDscNew := TFileStream.Create(SaveDialog1.FileName, fmCreate);
      AbriuArqDsc := True;
      End
    Else
      Begin
      //Reset(ArqDsc,1);
      //Seek(ArqDsc,FileSize(ArqDsc));
      ArqDscNew := TFileStream.Create(SaveDialog1.FileName, fmOpenReadWrite+fmShareExclusive);
      ArqDscNew.Seek(soFromBeginning,ArqDscNew.Size);
      End;

    ProgressBar1.Min := 0;
    ProgressBar1.Max := TEditForm(FrameForm.ActiveMDIChild).Ocorre;

    For I := 1 To TEditForm(FrameForm.ActiveMDIChild).Ocorre Do
      If Not QuerCancelar Then
        Begin

//        FrameForm.Timer10.Enabled := False; // Refresh Timer
//        FrameForm.Timer10.Enabled := True;

        //if edit3.Text = '535' then
        //  application.ProcessMessages;

        Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,I-1);
        {$i-}
        Read(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,TEditForm(FrameForm.ActiveMDIChild).RegPsq);
        {$i+}
        If IoResult <> 0 Then
          Begin
          FormGeral.MostraMensagem('Erro de Seek Prn');
          ArqDscNew.Free;
          Halt;
          End;

        k := TEditForm(FrameForm.ActiveMDIChild).RegPsq.PosQuery; // k é utilizada para controlar a posição do array: gridQueryFacil - funciona como o moveBy que era utilizado na versão enterior com recordSet
        //TrabalhaADescompactacao(strToInt(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k,1]));
        if TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k].Pagina < MaxInt then
          TrabalhaADescompactacao(TEditForm(FrameForm.ActiveMDIChild).gridQueryFacil[k].Pagina);

        (*
        If TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
          Begin
          TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.First;
          TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.MoveBy(TEditForm(FrameForm.ActiveMDIChild).RegPsq.PosQuery-1);
          TrabalhaADescompactacao(TEditForm(FrameForm.ActiveMDIChild).ClientDataSet1.Fields[1].AsInteger);
          End
        Else
          Begin
          TEditForm(FrameForm.ActiveMDIChild).Query1.First;
          TEditForm(FrameForm.ActiveMDIChild).Query1.MoveBy(TEditForm(FrameForm.ActiveMDIChild).RegPsq.PosQuery-1);
          TrabalhaADescompactacao(TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger);
          End;
        *)

        ProgressBar1.Position := I;

        End;

    If QuerCancelar Then
      FormGeral.MostraMensagem('Cancelado pelo usuário');

    //CloseFile(ArqDsc);
    ArqDscNew.Free;
    TEditForm(FrameForm.ActiveMDIChild).RestauraPosArqPsq;

    If TEditForm(FrameForm.ActiveMDIChild).Mascara Then
      TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True,    // Volta a página anterior
                                                        TEditForm(FrameForm.ActiveMDIChild).Query1.Fields[1].AsInteger);

    Edit3.Text := '';
    ProgressBar1.Position := 0;
    Application.ProcessMessages;
    End
  Else
    Exit;
  End
Else
If RadioPag.Checked Or RadioTudo.Checked Then
  Begin
  If RadioPag.Checked Then
    Begin
    Val(Edit1.Text,PgIni,Erro);
    If (Erro <> 0) Or (PgIni < 1) Then
      Begin
      FormGeral.MostraMensagem('Valor Inicial Inválido ');
      Exit;
      End;
    Val(Edit2.Text,PgFin,Erro);
    If (Erro <> 0) Or (PgIni > PgFin) Or (PgFin > TEditForm(FrameForm.ActiveMDIChild).Paginas) Then
      Begin
      FormGeral.MostraMensagem('Valor Final Inválido ');
      Exit;
      End;
    End
  Else
    Begin
    PgIni := 1;
    PgFin := TEditForm(FrameForm.ActiveMDIChild).Paginas;
    End;

  PgOri := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;

  If SlonSaveDialog1 Then
    Begin

    //AssignFile(ArqDsc,SaveDialog1.FileName);

    If FileExists(SaveDialog1.FileName) And (UpperCase(SaveDialog1.FileName) <> 'TEMP.TXT') Then
      begin
      If MessageDlg('Arquivo já Existe, Continua?', mtWarning,[mbYes,mbNo],0) In [mrCancel, mrNo] Then
        Exit
      else
        deleteFile(saveDialog1.FileName);
      end;

    ArqDscNew := TFileStream.Create(SaveDialog1.FileName,fmCreate);

    //ReWrite(ArqDsc,1);

    ProgressBar1.Min := 0;
    ProgressBar1.Max := PgFin;
    ProgressBar1.Min := PgIni;

    For I := PgIni To PgFin Do
      If Not QuerCancelar Then
        TrabalhaADescompactacao(I);

    If QuerCancelar Then
      FormGeral.MostraMensagem('Cancelado pelo usuário');

    //CloseFile(ArqDsc);
    ArqDscNew.Free;

    { Back To the original place }

    If Not TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
      Begin
      Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag64,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
      Try
        Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag64);
      Except
        TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, PgOri);   // Volta a página anterior
        End; // Try
      End;

    If TEditForm(FrameForm.ActiveMDIChild).Mascara Or (TipoSaida = 'PDF') Then
      TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, PgOri);   // Volta a página anterior

    Edit3.Text := '';
    ProgressBar1.Position := PgIni;
    Application.ProcessMessages;

    End
  Else
    Exit;
  End;

If Sender = ButtonClipBoard Then
  Begin
  If Primeiro Then
    TipoSaida := 'CLIPBOARD';
  Reset(ArqDsc,1);
  Memo1.Clear;
  SetLength(TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada,FileSize(ArqDsc));
  BlockRead(ArqDsc,TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada[1],FileSize(ArqDsc));
  CloseFile(ArqDsc);
  Memo1.Lines.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada;
  TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada := '';
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
  Memo1.Clear;
  End;

If ArqTempl.Text <> '' Then
  FrmTemplate.LimparBtn.Click;

If Not QuerCancelar Then
  FormGeral.MostraMensagem('Fim da Descompactação!');

If Not PesquisaEspecial Then
  Begin
  AbriuArqDsc := False; // Se repetir a exportação sem sair da janela, reinicializa o arquivo dsc...
  If AdicionouPaginaPdf Then
    Begin
    TEditForm(FrameForm.ActiveMDIChild).Pdf.SaveToFile(ExtractFilePath(SaveDialog1.FileName)+
                   ChangeFileExt(ExtractFileName(SaveDialog1.FileName),'.pdf'));
    AdicionouPaginaPdf := False;
    End;
  Try
    TEditForm(FrameForm.ActiveMDIChild).Pdf.Free;
  Except
    End;

  If TemExcel Then
    Begin
    ExcelApp.Visible := True;
    Application.Minimize;
    End;
//  ExcelApplication1.Visible[Lcid] := True;

  If TemWord Then
    Begin
    WordApp.Visible := True;
    Application.Minimize;
    End;
  End;
End;

Procedure TFrmDescom.SairButClick(Sender: TObject);
Begin
QuerCancelar := True;
Close;
End;

function TFrmDescom.SalvarDescompactacaoNoBanco: boolean;
var
  TipoDescompactacao,
  IntervaloIni,
  IntervaloFin,
  IndexPaginaAtual,
  DescompId,
  Erro: Integer;
  RemoverBrancos,
  Orig,
  ApenasLinnhaPesquisa: Boolean;
  PesquisaMensagem: String;
  ArrayPesquisa: QueryFacilArrayDTO;

  procedure Init;
  begin
    Result := true;
    TipoDescompactacao := 0;
    IntervaloIni := -1;
    IntervaloFin := -1;
    IndexPaginaAtual := -1;
    RemoverBrancos := false;
    Orig := False;
    ApenasLinnhaPesquisa := false;
    PesquisaMensagem := '';
  end;

  procedure SaveToDatabase;
  var
    I: Integer;
    strlst : TStringlist;
    strPar : TFDParams;
    Param  : TFDParam;
  begin
    strlst := TStringList.Create;
    strlst.Add(' insert into ParametroDescompactador  ');
    strlst.Add(' (                                    ');
    strlst.Add(' CODUSUARIO,                          ');
    strlst.Add(' TipoDescompactacao,                  ');
    strlst.Add(' RemoverBrancos,                      ');
    strlst.Add(' Orig,                                ');
    strlst.Add(' IntervaloIni,                        ');
    strlst.Add(' IntervaloFin,                        ');
    strlst.Add(' IndexPaginaAtual,                    ');
    strlst.Add(' ApenasLinhasPesquisa,                ');
    strlst.Add(' PesquisaMensagem                     ');
    strlst.Add(' )                                    ');
    strlst.Add(' values                               ');
    strlst.Add(' (                                    ');
    strlst.Add(quotedStr(LogInRemotoForm.UsuEdit.Text) + ','      );
    strlst.Add(IntToStr(TipoDescompactacao) + ','      );
    strlst.Add(BoolToStr(RemoverBrancos)+ ',');
    strlst.Add(BoolToStr(Orig) + ','        );
    strlst.Add(IntToStr(IntervaloIni)     + ','        );
    strlst.Add(IntToStr(IntervaloFin)     + ','        );
    strlst.Add(IntToStr(IndexPaginaAtual) + ','        );
    strlst.Add(BoolToStr(ApenasLinnhaPesquisa) + ','        );
    strlst.Add(quotedStr(PesquisaMensagem)                    );
    strlst.Add(' )                                    ');
    //strPar := TFDParams.Create;
    Try
      FormGeral.Persistir(strlst.Text, nil);
    Except
    End;

    {
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['CODUSUARIO'] := LogInRemotoForm.UsuEdit.Text;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['TipoDescompactacao'] := TipoDescompactacao;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['RemoverBrancos'] := RemoverBrancos;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['Orig'] := Orig;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['IntervaloIni'] := IntervaloIni;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['IntervaloFin'] := IntervaloFin;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['IndexPaginaAtual'] := IndexPaginaAtual;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['ApenasLinhasPesquisa'] := ApenasLinnhaPesquisa;
    FormGeral.ADOCmdInsertDescomp.Parameters.ParamValues['PesquisaMensagem'] := PesquisaMensagem;

    FormGeral.ADOCmdInsertDescomp.Execute;
    }

    strlst.Clear;
    strlst.Add(' select max(Id) Id from ParametroDescompactador ');
    FormGeral.ImportarDados(strlst.Text, nil);
    FormGeral.memtb.Open;
    DescompId := FormGeral.memtb.FieldByName('Id').AsInteger;
    FormGeral.memtb.Close;

    {
    FormGeral.ADOQryGetIdDescomp.Open;
    DescompId := FormGeral.ADOQryGetIdDescomp.FieldByName('Id').AsInteger;
    FormGeral.ADOQryGetIdDescomp.Close;
    }

    if TipoDescompactacao = 2 then
    begin // Se for pesquisa, tem que inserir a pesquisa tb.

      for I := 0 to length(ArrayPesquisa)-1 do
      begin
        strlst.Clear;
        strlst.Add(' insert into ParametroPesquisa    ');
        strlst.Add(' (                                ');
        strlst.Add(' IdParametroDescompactador,       ');
        strlst.Add(' IndexPesq,                       ');
        strlst.Add(' Campo,                           ');
        strlst.Add(' Operador,                        ');
        strlst.Add(' Valor,                           ');
        strlst.Add(' Conector                         ');
        strlst.Add(' )                                ');
        strlst.Add(' values                           ');
        strlst.Add(' (                                ');
        strlst.Add(IntToStr(descompId)                +',');
        strlst.Add(QuotedStr(ArrayPesquisa[I].Index_) +',');
        strlst.Add(QuotedStr(ArrayPesquisa[I].Campo)         +',');
        strlst.Add(IntToStr(ArrayPesquisa[I].Operador)       +',');
        strlst.Add(QuotedStr(ArrayPesquisa[I].Valor)         +',');
        strlst.Add(IntToStr(ArrayPesquisa[I].Conector)           );
        strlst.Add(' )                                ');
        Try
          FormGeral.Persistir(strlst.Text, nil);
        Except
        End;
        {
        FormGeral.ADOCmdInsertPesq.Parameters.ParamValues['IdParametroDescompactador'] := descompId;
        FormGeral.ADOCmdInsertPesq.Parameters.ParamValues['IndexPesq'] := ArrayPesquisa[I].Index_;
        FormGeral.ADOCmdInsertPesq.Parameters.ParamValues['Campo'] := ArrayPesquisa[I].Campo;
        FormGeral.ADOCmdInsertPesq.Parameters.ParamValues['Operador'] := ArrayPesquisa[I].Operador;
        FormGeral.ADOCmdInsertPesq.Parameters.ParamValues['Valor'] := ArrayPesquisa[I].Valor;
        FormGeral.ADOCmdInsertPesq.Parameters.ParamValues['Conector'] := ArrayPesquisa[I].Conector;

        FormGeral.ADOCmdInsertPesq.Execute;
        }
      end;

    end;
    strlst.Clear;
    strlst.Add(' insert into ProcessadorExtracao   ');
    strlst.Add(' (                                 ');
    strlst.Add(' IdParametroDescompactador,        ');
    strlst.Add(' TipoProcessamento,                ');
    strlst.Add(' PathRelatorio                     ');
    strlst.Add(' )                                 ');
    strlst.Add(' values                            ');
    strlst.Add(' (                                 ');
    strlst.Add(IntToStr(descompId)  +                               ',');
    strlst.Add('2,'                                                    );
    strlst.Add(QuotedStr(TEditForm(FrameForm.ActiveMdiChild).Filename) );
    strlst.Add(' )                                 ');
    Try
      FormGeral.Persistir(strlst.Text, nil);
    Except
    End;

    {
    FormGeral.ADOCmdInsertExecutionDescomp.Parameters.ParamValues['IdParametroDescompactador'] := DescompId;
    FormGeral.ADOCmdInsertExecutionDescomp.Parameters.ParamValues['TipoProcessamento'] := 2;
    FormGeral.ADOCmdInsertExecutionDescomp.Parameters.ParamValues['PathRelatorio'] := TEditForm(FrameForm.ActiveMdiChild).Filename;
    FormGeral.ADOCmdInsertExecutionDescomp.Execute;
    }
    Freeandnil(strlst);
    Freeandnil(strPar);
    Freeandnil(Param);
  end;

begin
    Init;

    if RadioPagAtu.Checked then
    begin // Página Atual
      TipoDescompactacao := 1;

      IndexPaginaAtual := FrameForm.ScrollBar2.Position + 1;
    end else
    if RadioPesq.Checked then
    begin // Pesquisa
      TipoDescompactacao := 2;
      ApenasLinnhaPesquisa := CheckPesq.Checked;

      if (not TEditForm(FrameForm.ActiveMdiChild).temPesquisa) then
      begin
        Result := false;
        MessageDlg('Só é possível descompactar pesquisa caso tenha alguma pesquisa ativa.', TMsgDlgType.mtInformation, [mbOk], 0);
        exit;
      end;

      ArrayPesquisa := Localizar.MontarQueryFacil;
      PesquisaMensagem := PilhaEspecial;

    end else
    if RadioPag.Checked then
    begin // intervalo
      TipoDescompactacao := 3;

      Val(Edit1.Text,IntervaloIni,Erro);
      If (Erro <> 0) Or (IntervaloIni < 1) Then
      Begin
        Result := false;
        FormGeral.MostraMensagem('Valor Inicial Inválido ');
        Exit;
      End;

      Val(Edit2.Text,IntervaloFin,Erro);
      If (Erro <> 0) Or (IntervaloIni > IntervaloFin) Or (IntervaloFin > TEditForm(FrameForm.ActiveMDIChild).Paginas) Then
      Begin
        Result := false;
        FormGeral.MostraMensagem('Valor Final Inválido ');
        Exit;
      End;

    end else
    if RadioTudo.Checked then
    begin // Full
      TipoDescompactacao := 4;
    end;

    RemoverBrancos := RemLinBran.Checked;
    Orig := CheckOrig.Checked;

    // 20/06/2021
    SaveToDatabase;


end;

Procedure TFrmDescom.Edit1Change(Sender: TObject);
Begin
If Edit1.Text = '' Then
  Exit;
RadioPag.Checked := True;
Application.ProcessMessages;
End;

Procedure TFrmDescom.RadioTudoClick(Sender: TObject);
Begin
Edit1.Text := '';
Edit2.Text := '';
CheckPesq.Checked := False;
Application.ProcessMessages;
End;

Procedure TFrmDescom.CheckPesqClick(Sender: TObject);
Begin
If CheckPesq.Checked = False Then
  Exit;
Edit1.Text := '';
Edit2.Text := '';
RadioPesq.Checked := True;
Application.ProcessMessages;
End;

Procedure TFrmDescom.ArqTemplDblClick(Sender: TObject);
Begin
If OpenDialog1.Execute Then
  ArqTempl.Text := OpenDialog1.FileName;
End;

Procedure TFrmDescom.RadioPesqClick(Sender: TObject);
Begin
Edit1.Text := '';
Edit2.Text := '';
Application.ProcessMessages;
End;

Procedure TFrmDescom.RadioPagClick(Sender: TObject);
Begin
CheckPesq.Checked := False;
Application.ProcessMessages;
End;

End.
