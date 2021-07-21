Unit Descom;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ComObj;

Type
  TFrmDescom = Class(TForm)
    RadioPagAtu: TRadioButton;
    RadioPag: TRadioButton;
    RadioTudo: TRadioButton;
    ButtonArquivo: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    ProgressBar1: TProgressBar;
    Edit3: TEdit;
    RadioPesq: TRadioButton;
    CheckPesq: TCheckBox;
    StrPagina: TMemo;
    ButtonClipBoard: TButton;
    ButtonWord: TButton;
    Label2: TLabel;
    ButtonExcel: TButton;
    Label3: TLabel;
    ArqTempl: TEdit;
    OpenDialog1: TOpenDialog;
    RemLinBran: TCheckBox;
    Procedure FormCreate(Sender: TObject);
    Procedure ButtonArquivoClick(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure Edit1Change(Sender: TObject);
    Procedure RadioTudoClick(Sender: TObject);
    Procedure CheckPesqClick(Sender: TObject);
    Procedure ArqTemplDblClick(Sender: TObject);
    Procedure RadioPesqClick(Sender: TObject);
    Procedure RadioPagClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FrmDescom: TFrmDescom;
  WordApp : OleVariant;
  TemWord : Boolean;
  ExcelApp : OleVariant;
  TemExcel : Boolean;
//  Lcid : Integer;

Implementation

Uses Mdiedit, MdiMultiCold, SuTypGer, ZLib, Template, Grids, Subrug, SuGeral,
  LogInForm;

{$R *.DFM}

Const
  xlWBatWorkSheet = -4167;
Var
  Filtros : TFiltro;

Procedure TFrmDescom.FormCreate(Sender: TObject);
Begin
Filtros := TFiltro.Create;
RadioPagAtu.Checked := True;
OpenDialog1.InitialDir := 'C:\ColdCfg';
End;

Procedure TFrmDescom.ButtonArquivoClick(Sender: TObject);

Var
  I, J, K,
  L : Integer;
  ArqDsc : File;
//  PagStrIncExc,
  LinAux,
  Linha,
  Linha133 : String;
  Posic,
  PgIni,
  PgFin,
  Erro : Integer;
//  LPag,
//  CPag : Integer;
  LinPrese : Set Of Byte;
  ListaDeGrids : Array[0..1000] Of TComponent;
  Year,
  Month,
  Day : Word;
  AuxData : TDateTime;

  Procedure TrabalhaADescompactacao(I : Integer);

  Var
    Ind,
    ILinha : Integer;
    Apendix,
    AuxStr,
    RegAux,
    RegInd : String;
    AllBranco : Boolean;

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
        If Copy(StrPagina.Lines[Ind],Filtros.StrInc[I].Col,Filtros.StrInc[I].Tam) <> Filtros.StrInc[I].FilStr Then
          RegInd := '';    { Conteudo difere da linha a ser incluida }

    If RegInd <> '' Then
      If Filtros.StrExc[I].Col <> 0 Then
        If Copy(StrPagina.Lines[Ind],Filtros.StrExc[I].Col,Filtros.StrExc[I].Tam) = Filtros.StrExc[I].FilStr Then
          RegInd := '';    { Conteudo igual a da linha a ser excluida }
    If RegInd = '' Then
      TestaFiltro := False
    Else
      TestaFiltro := True;
    End;

    Procedure RodaTemplate;
    Var
      ILinha,
      Kx,
      Ky : Integer;

      Procedure SetaVariavelDeData;

      Begin
      With TStringGrid(ListaDeGrids[ILinha]) Do
        Begin
        If Ky > Length(Cells[1,12]) Then
          Exit;
        If Upcase(Cells[1,12][Ky]) = 'D' Then
          Day := StrToInt(RegAux)
        Else
        If Upcase(Cells[1,12][Ky]) = 'M' Then
          Month := StrToInt(RegAux)
        Else
        If Upcase(Cells[1,12][Ky]) = 'Y' Then
          Begin
          Year := StrToInt(RegAux);
          If Length(RegAux) = 2 Then
            If Year <= 50 Then
              Year := Year + 2000
            Else
              Year := Year + 1900;
          End;
        End;
      End;

      Procedure ObtemUmNumero;

      Begin
      RegAux := '';
      While (Length(RegInd) >= Kx) And (RegInd[Kx] In ['0'..'9']) Do
        Begin
        RegAux := RegAux + RegInd[Kx];
        Inc(Kx);
        End;
      Inc(Kx); // Pular o separador
      End;

      Procedure AndaNoFormato;

      Begin
      With TStringGrid(ListaDeGrids[ILinha]) Do
        While (Length(Cells[1,12]) >= Ky) And (Cells[1,12][Ky] In ['D','M','Y','d','m','y']) Do
          Inc(Ky);
      Inc(Ky);   // Pula o separador
      End;


      Function FormataData : String;

      Begin
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

        Kx := 1;
        ObtemUmNumero;

        Day := 0;
        Month := 0;
        Year := 0;

        Ky := 1;
        SetaVariavelDeData;
        AndaNoFormato;

        ObtemUmNumero;
        SetaVariavelDeData;
        AndaNoFormato;

        ObtemUmNumero;
        SetaVariavelDeData;

        AuxData := EncodeDate(Year,Month,Day);
        Result := FormatDateTime(Cells[1,13],AuxData);
        End;
      End;

      Function FormataNumero : String;
      Var
        I : Integer;
      Begin
      Result := '';
      RegAux := UpperCase(TStringGrid(ListaDeGrids[ILinha]).Cells[1,12]);
      With TStringGrid(ListaDeGrids[ILinha]) Do
        For I := 1 To Length(RegAux) Do
          Begin
          If I > Length(RegInd) Then
            Break;
          If RegAux[I] = 'C' Then
            Result := Result + RegInd[I];
          End;
      End;

    Begin
    Apendix := '';
    For ILinha := 0 To L Do     // Varre todos os Campos  Era 1
      With TStringGrid(ListaDeGrids[ILinha]) Do
        Begin
        RegInd := Copy(StrPagina.Lines[Ind],StrToInt(Cells[1,3]), StrToInt(Cells[1,4]));  // Linha candidata

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
          If TemExcel Then
            Begin
            Case Cells[1,7][1] Of
            'C' : Begin

                  // Tratamento Do formato de datas e remoção de caracteres indesejados para o Excel
                  If (Cells[1,12] <> '') And (Cells[1,13] <> '') And (RegInd <> '') Then
                    Begin
                    If Pos('B',UpperCase(RegInd)) <> 0 Then
                      RegInd := FormataNumero
                    Else
                      RegInd := FormataData;
                    End
                  Else
                  If (Cells[1,12] <> '') And (RegInd <> '') Then
                      RegInd := FormataNumero;

                  RegAux := '''';
                  For Kx := 1 To  Length(RegInd) Do
                    If Not (RegInd[Kx] In ['0'..'9','.']) Then  // Há caracteres diferentes de número
                      Begin
                      RegAux := '';       // limpa
                      Break;
                      End;

                  RegInd := RegAux + RegInd;

                  End;
            'F' : Begin

                  RegAux := '';
                  For Kx := 1 To Length(RegInd) Do
                    If (RegInd[Kx] In ['0'..'9','+','-',',']) Then
                      RegAux := RegAux + RegInd[Kx];

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
                  For Kx := 1 To Length(RegInd) Do
                    If (RegInd[Kx] In ['0'..'9','+','-','.']) Then
                      RegAux := RegAux + RegInd[Kx];

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
                  For Kx := 1 To Length(RegInd) Do
                    If (RegInd[Kx] In ['0'..'9','+','-']) Then
                      RegAux := RegAux + RegInd[Kx];

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
            ExcelApp.WorkBooks[1].WorkSheets[1].Cells[K,ILinha+1] := RegInd;
            Apendix := Apendix + RegInd;  //
            End
          Else
            Begin

            If (Cells[1,12] <> '') And (Cells[1,13] <> '') And (RegInd <> '') Then // Verifica se precisa converter
              If Pos('B',UpperCase(RegInd)) <> 0 Then
                RegInd := FormataNumero
              Else
                RegInd := FormataData;
            If (Cells[1,12] <> '') And (RegInd <> '') Then
                RegInd := FormataNumero;

            Apendix := Apendix + Format('%-'+Cells[1,4]+'s',[RegInd])+' '; // Branco espaçador
            End;
          End
        Else
          Begin            // Preenche com brancos para manter formatação Do texto
          Apendix := Apendix + Format('%-'+Cells[1,4]+'s',[' '])+' '; // Branco espaçador
          End;
        End;
    AllBranco := False;
    If (RemLinBran.Checked) Then
      Begin
      AllBranco := True;
      For ILinha := 1 To Length(Apendix) Do
        If Apendix[ILinha] <> ' ' Then
          Begin
          AllBranco := False;
          Break;
          End;
      End;
    If (RemLinBran.Checked) And AllBranco Then
      Begin
      End
    Else
    If TemExcel Then
      Inc(K)
    Else
    If TemWord Then
      WordApp.WordBasic.Insert(Apendix+CrLf)
    Else
      Begin
      BlockWrite(ArqDsc,Apendix[1],Length(Apendix),Erro);
      BlockWrite(ArqDsc,CrLf,2,Erro);
      End;
    End;

  Begin

  Linha := '';
  Linha133 := '';

  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, Linha133, Linha);

  If (ArqTempl.Text <> '') And (K=1) Then
    Begin                            // Dar o nome dos campos à primeira linha da exportação
    Apendix := '';
    For ILinha := 0 To L Do   // Era 1
      With TStringGrid(ListaDeGrids[ILinha]) Do
        Begin                                                              // Trunca o nome
        Apendix := Apendix + Format('%-'+Cells[1,4]+'s',[Copy(Cells[1,6],1,StrToInt(Cells[1,4])-1)])+' ';
        If TemExcel Then
          Begin
//          ExcelWorksheet1.Cells.Item[K, ILinha+1].Value := Cells[1,6];
          ExcelApp.WorkBooks[1].WorkSheets[1].Cells[K,ILinha+1] := Cells[1,6];
          End;
        End;
    If TemExcel Then
      Inc(K)  // Avança ponteiro
    Else
      Begin
      Inc(K);             // Força a alteração Do valor para não entrar de novo
      If TemWord Then
        WordApp.WordBasic.Insert(Apendix+CrLf)
      Else
        Begin
        BlockWrite(ArqDsc,Apendix[1],Length(Apendix),Erro);
        BlockWrite(ArqDsc,CrLf,2,Erro);
        End;
      End;
    End;

  If RadioPesq.Checked And CheckPesq.Checked Then
    Begin
    If TEditForm(FrameForm.ActiveMDIChild).Report133CC Then
      StrPagina.Lines.Text := Linha133                        // Usa o não acertado
    Else
      StrPagina.Lines.Text := Linha;
    LinPrese := [];

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

    For Ind := 0 To StrPagina.Lines.Count - 1 Do
      If Ind+1 In LinPrese Then
        Begin
        If ArqTempl.Text <> '' Then // Aplicar o Template
          RodaTemplate
        Else
        If TemWord Then
          WordApp.WordBasic.Insert(StrPagina.Lines[Ind]+CrLf)
        Else
        If TemExcel Then
          Begin
//          ExcelWorksheet1.Cells.Item[K, 1].Value := StrPagina.Lines[Ind];
          ExcelApp.WorkBooks[1].WorkSheets[1].Cells[K,1] := StrPagina.Lines[Ind];
          Inc(K);
          End
        Else
          Begin
          BlockWrite(ArqDsc,StrPagina.Lines[Ind][1],Length(StrPagina.Lines[Ind]),Erro);
          BlockWrite(ArqDsc,CrLf,2,Erro);
          End;
        End;
    End
  Else
    Begin
    If ArqTempl.Text <> '' Then // Aplicar o Template
      Begin
      StrPagina.Lines.Text := Linha;
      LinAux := '';
{      PagStrIncExc := 'Ok';
      If (FrmTemplate.GridPag.Cells[1,3] <> '') Then
        Begin
        LinAux := FrmTemplate.GridPag.Cells[1,3];
        PagStrIncExc := 'StrInc';
        End
      Else
      If (FrmTemplate.GridPag.Cells[1,4] <> '') Then
        Begin
        LinAux := FrmTemplate.GridPag.Cells[1,4];
        PagStrIncExc := 'StrExc';
        End;
      If PagStrIncExc <> 'Ok' Then
        Begin
        LPag := StrToInt(FrmTemplate.GridPag.Cells[1,1]);
        CPag := StrToInt(FrmTemplate.GridPag.Cells[1,2]);
        Try
          If PagStrIncExc = 'StrInc' Then
            Begin
//            ShowMessage(Copy(StrPagina.Lines[LPag-1],CPag,Length(LinAux))+'-'+LinAux);
            If Copy(StrPagina.Lines[LPag-1],CPag,Length(LinAux)) = LinAux Then
              PagStrIncExc := 'Ok';
            End
          Else
            If Copy(StrPagina.Lines[LPag-1],CPag,Length(LinAux)) <> LinAux Then
              PagStrIncExc := 'Ok';
        Except
          End; // Try
        End;
      If PagStrIncExc = 'Ok' Then }
      For Ind := 0 To StrPagina.Lines.Count - 1 Do
        RodaTEmplate;
      End
    Else
      Begin
      If TemWord Then
        WordApp.WordBasic.Insert(Linha+CrLf)
      Else
      If TemExcel Then
        Begin
        StrPagina.Lines.Text := Linha;
        For Ind := 0 To StrPagina.Lines.Count - 1 Do
          Begin
//          ExcelWorksheet1.Cells.Item[K, 1].Value := StrPagina.Lines[Ind];
          ExcelApp.WorkBooks[1].WorkSheets[1].Cells[K,1] := StrPagina.Lines[Ind];
          Inc(K);
          End;
        End
      Else
        BlockWrite(ArqDsc,Linha[1],Length(Linha),Erro);
      End;
    End;
  If Not RadioPesq.Checked Then
    ProgressBar1.Position := I;
  Edit3.Text := IntToStr(I);
  Application.ProcessMessages;
  End;

Function SlonSaveDialog1 : Boolean;
Begin
If Sender = ButtonArquivo Then
  SlonSaveDialog1 := SaveDialog1.Execute
Else
  Begin
  SaveDialog1.FileName := PathCfg+'Temp.txt';
  SlonSaveDialog1 := True;
  End;
End;

Begin
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
              Exit;

          SetLength(Filtros.FiltroOut,J+1);
          Filtros.FiltroOut[L] := [];
          If Cells[1,9] <> '' Then
            If Not Filtros.EncheFiltro(Cells[1,9],Cells[1,6],Filtros.FiltroOut[L],L) Then
              Exit;

          SetLength(Filtros.StrInc,J+1);
          Filtros.StrInc[L].Col := 0;
          Filtros.StrInc[L].Tam := 0;
          Filtros.StrInc[L].FilStr := '';
          If Cells[1,10] <> '' Then
            If Not Filtros.EncheStr(Cells[1,10],Cells[1,6],Filtros.StrInc[L],L) Then
              Exit;

          SetLength(Filtros.StrExc,J+1);
          Filtros.StrExc[L].Col := 0;
          Filtros.StrExc[L].Tam := 0;
          Filtros.StrExc[L].FilStr := '';
          If Cells[1,11] <> '' Then
            If Not Filtros.EncheStr(Cells[1,11],Cells[1,6],Filtros.StrExc[L],L) Then
              Exit;

          // Faz verificações nos campos Do template

          Try
            StrToInt(Cells[1,1]);  // Testa os valores
          Except
            ShowMessage('Linha Inicial Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
            Exit;
            End; // Try

          Try
            StrToInt(Cells[1,2]);  // Testa os valores
          Except
            ShowMessage('Linha Final Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
            Exit;
            End; // Try

          Try
            StrToInt(Cells[1,3]);
          Except
            ShowMessage('Coluna Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" inválida');
            Exit;
            End; // Try

          Try
            StrToInt(Cells[1,4]);
          Except
            ShowMessage('Tamanho Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" inválido');
            Exit;
            End; // Try

          If Length(Cells[1,5]) <> 1 Then     { Tratamento de Brancos }
            Begin
            ShowMessage('Número de Caracteres Do Tratamento de Brancos Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
            Exit;
            End;

          If Not (Cells[1,5][1] In ['0','1','2','3','4']) Then
            Begin
            ShowMessage('Tratamento de Brancos Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
            Exit;
            End;

          Cells[1,7] := Uppercase(Cells[1,7]);

          If Length(Cells[1,7]) <> 1 Then
            Begin
            ShowMessage('Número de Caracteres Do Tipo Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
            Exit;
            End;

          If Not (Cells[1,7][1] In ['C','F','D','N']) Then
            Begin
            ShowMessage('Tipo Do Campo'+IntToStr(L)+' "'+Cells[1,6]+'" está inválido, verifique...');
            Exit;
            End;

          End;
        Inc(L);
//        Break;
        End;
  Dec(L);  // L Passa a ser o número exato de Campos

  End;

If (Sender = ButtonClipBoard) Or
   (Sender = ButtonWord) Or
   (Sender = ButtonExcel) Then
  Begin
  AssignFile(ArqDsc,PathCfg+'Temp.txt');
  Try
    Erase(ArqDsc);
    Except
    End; // Try
  End;

TemWord:= False;
If (Sender = ButtonWord) Then
  Begin
  TemWord := True;
  Try
    WordApp := CreateOleObject('Word.Application');
  Except
      TemWord := False;
      ShowMessage('MS Word não está instalado neste computador...');
      Exit;
    End; // Try

  If TemWord Then
    Begin
    WordApp.Documents.Add;                          //Cria um paginão
    WordApp.Documents.Item(1).PageSetup.PageWidth := WordApp.Documents.Item(1).PageSetup.PageWidth +
                                                     (WordApp.Documents.Item(1).PageSetup.PageWidth Div 2);
    WordApp.Documents.Item(1).PageSetup.PageHeight := WordApp.Documents.Item(1).PageSetup.PageHeight +
                                                      (WordApp.Documents.Item(1).PageSetup.PageHeight Div 2);
    WordApp.Documents.Item(1).Range.Font.Name := TEditForm(FrameForm.ActiveMDIChild).Video.Name;
    WordApp.Documents.Item(1).Range.Font.Size := TEditForm(FrameForm.ActiveMDIChild).Video.Size;
    End;

  Linha := '';
  End;

TemExcel := False;
K := 1;
If Sender = ButtonExcel Then
  Begin
  TemExcel := True;

//  Try
//    ExcelApplication1.Disconnect;
//  Except
//    End; // Try

  Try
    ExcelApp := CreateOleObject('Excel.Application');
//    ExcelApplication1.Connect;
  Except
      TemExcel := False;
      ShowMessage('Excel não está instalado neste computador...');
      Exit;
    End;

  If TemExcel Then
    Begin
//    Lcid := GetUserDefaultLCID;
//    ExcelApplication1.Workbooks.Add(EmptyParam,Lcid);
//    ExcelWorkbook1.ConnectTo(ExcelApplication1.ActiveWorkbook);
//    ExcelWorksheet1.ConnectTo(ExcelApplication1.ActiveSheet as _Worksheet);
//    ExcelWorksheet1.Cells.Font.Name := TEditForm(FrameForm.ActiveMDIChild).Video.Name;
//    ExcelWorksheet1.Cells.Font.Size := TEditForm(FrameForm.ActiveMDIChild).Video.Size;

    ExcelApp.WorkBooks.Add(xlWBatWorkSheet);
    ExcelApp.WorkBooks[1].WorkSheets[1].Name := 'DADOS MultiCold';
    ExcelApp.WorkBooks[1].WorkSheets[1].Cells.Font.Name := TEditForm(FrameForm.ActiveMDIChild).Video.Name;
    ExcelApp.WorkBooks[1].WorkSheets[1].Cells.Font.Size := TEditForm(FrameForm.ActiveMDIChild).Video.Size;

    End;
  End;

If RadioPagAtu.Checked Then
  Begin
  If SlonSaveDialog1 Then
    Begin
    AssignFile(ArqDsc,SaveDialog1.FileName);
    If FileExists(SaveDialog1.FileName) Then
      If MessageDlg('Arquivo já Existe, Continua?', mtWarning,[mbYes,mbNo],0) In [mrCancel, mrNo] Then
        Exit;
    ReWrite(ArqDsc,1);

    ProgressBar1.Min := 0;     // Para não dar erro !
    ProgressBar1.Max := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;
    ProgressBar1.Min := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;

    TrabalhaADescompactacao(TEditForm(FrameForm.ActiveMDIChild).PaginaAtu);

    CloseFile(ArqDsc);

    End
  Else
    Exit;
  End
Else
If RadioPesq.Checked Then
  Begin

  If TEditForm(FrameForm.ActiveMDIChild).Ocorre = 0 Then
    Begin
    ShowMessage('Nenhuma pesquisa realizada???');
    Exit;
    End;

  If SlonSaveDialog1 Then
    Begin
    AssignFile(ArqDsc,SaveDialog1.FileName);
    If FileExists(SaveDialog1.FileName) Then
      If MessageDlg('Arquivo já Existe, Continua?', mtWarning,[mbYes,mbNo],0) In [mrCancel, mrNo] Then
        Exit;
    ReWrite(ArqDsc,1);

    ProgressBar1.Min := 0;
    ProgressBar1.Max := FileSize(TEditForm(FrameForm.ActiveMDIChild).ArqPsq);

    For I := 1 To TEditForm(FrameForm.ActiveMDIChild).Ocorre Do
      Begin
      Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,I-1);
      {$i-}
      Read(TEditForm(FrameForm.ActiveMDIChild).ArqPsq,TEditForm(FrameForm.ActiveMDIChild).RegPsq);
      {$i+}
      If IoResult <> 0 Then
        Begin
        ShowMessage('Erro de Seek Prn');
        Halt;
        End;

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

      ProgressBar1.Position := I;

      End;
    CloseFile(ArqDsc);
    TEditForm(FrameForm.ActiveMDIChild).RestauraPosArqPsq;
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
      ShowMessage('Valor Inicial Inválido ');
      Exit;
      End;
    Val(Edit2.Text,PgFin,Erro);
    If (Erro <> 0) Or (PgIni > PgFin) Or (PgFin > TEditForm(FrameForm.ActiveMDIChild).Paginas) Then
      Begin
      ShowMessage('Valor Final Inválido ');
      Exit;
      End;
    End
  Else
    Begin
    PgIni := 1;
    PgFin := TEditForm(FrameForm.ActiveMDIChild).Paginas;
    End;

  If SlonSaveDialog1 Then
    Begin
    AssignFile(ArqDsc,SaveDialog1.FileName);
    If FileExists(SaveDialog1.FileName) Then
      If MessageDlg('Arquivo já Existe, Continua?', mtWarning,[mbYes,mbNo],0) In [mrCancel, mrNo] Then
        Exit;
    ReWrite(ArqDsc,1);

    ProgressBar1.Max := PgFin;
    ProgressBar1.Min := PgIni;

    For I := PgIni To PgFin Do
      Begin
      TrabalhaADescompactacao(I);
      End;

    CloseFile(ArqDsc);

                      { Back To the original place }

    If Not TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
      If TEditForm(FrameForm.ActiveMDIChild).Pagina64 Then
        Begin
        Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag64,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
        Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag64);
        End
      Else
        Begin
        Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag32,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
        Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag32);
        End;

    Edit3.Text := '';
    ProgressBar1.Position := PgIni;
    Application.ProcessMessages;

    End
  Else
    Exit;
  End;

If Sender = ButtonClipBoard Then
  Begin
  Reset(ArqDsc,1);
  StrPagina.Lines.Clear;
  SetLength(Linha,FileSize(ArqDsc));
  BlockRead(ArqDsc,Linha[1],FileSize(ArqDsc));
  CloseFile(ArqDsc);
  StrPagina.Lines.Text := Linha;
  Linha := '';
  StrPagina.SelectAll;
  StrPagina.CopyToClipboard;
  StrPagina.Lines.Clear;
  End;

If ArqTempl.Text <> '' Then
  FrmTemplate.LimparBtn.Click;

ShowMessage('Fim da Descompactação!');

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

Procedure TFrmDescom.Button2Click(Sender: TObject);
Begin
Close;
End;

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
