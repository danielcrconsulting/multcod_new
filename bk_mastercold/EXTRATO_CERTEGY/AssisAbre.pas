Unit AssisAbre;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, ComCtrls;

Type
  TAssisAbreForm = Class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    ListBox2: TListBox;
    Button2: TButton;
    Button3: TButton;
    Table1: TTable;
    TreeView1: TTreeView;
    Procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  AssisAbreForm: TAssisAbreForm;
  FullPaths : TStringList;

Implementation

Uses MdiMultiCold, Subrug, LogInForm, Sugeral, Avisoi;

{$R *.DFM}

Procedure TAssisAbreForm.Button3Click(Sender: TObject);
Begin
Close;
End;

Procedure TAssisAbreForm.Button1Click(Sender: TObject);
Var
  GrupoStr,
  EstePath,
  OutroPath : String;
  I : Integer;
  SearchRec : TSearchRec;
  Lista : TStringList;
  FullPathsTemp : WideString;

  Function PegaInfo(Path : String) : String;

  Var
    Arq32 : File Of Integer;
    Arq64 : File Of Int64;

  Begin
  Result := ExtractFileName(Path);
  If FileExists(ChangeFileExt(Path,'.IAP')) Then
    Begin
    AssignFile(Arq32,ChangeFileExt(Path,'.IAP'));
    Reset(Arq32);
    Result := Result + ' -> ' + Format('%7d',[Filesize(Arq32)]) + ' Pgns';
    CloseFile(Arq32);
    End
  Else
    Begin
    AssignFile(Arq64,ChangeFileExt(Path,'.IAPS'));
    Reset(Arq64);
    Result := Result + ' -> ' + Format('%7d',[Filesize(Arq64)]) + ' Pgns';
    CloseFile(Arq64);
    End;

  Table1.TableName := ChangeFileExt(Path,'Dfn.db');
  Table1.Open;

  Result := Result + '  "' + Table1.FieldByName('NomeRel').AsString+'"';

  Table1.Close;
  End;

  Function RetNomeGrupo(Grupo : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArGrupo)-1 Do  // Achar o nome do grupo
    If ArGrupo[I].CodGrupo = Grupo Then
      Begin
      Result := ArGrupo[I].NomeGrupo+'\';
      Break;
      End;
  End;

  Function RetNomeSubGrupo(Grupo, SubGrupo : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArSubGrupo)-1 Do  // Achar o nome do subgrupo
    If ArSubGrupo[I].CodGrupo = Grupo Then
      If ArSubGrupo[I].CodSubGrupo = SubGrupo Then
        Begin
        Result := ArSubGrupo[I].NomeSubGrupo+'\';
        Break;
        End;
  End;

  Function RetSubGrupo(CodRel : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := 0;
  For I := 0 To Length(ArDFN)-1 Do  // Achar o nome do grupo
    If ArDFN[I].CodRel = CodRel Then
      Begin
      Result := ArDFN[I].CodSubGrupo;
      Break;
      End;
  End;
                            // Retorna o grupo original da dfn
  Function RetGrupo(CodRel : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := 0;
  For I := 0 To Length(ArDFN)-1 Do  // Achar o nome do grupo
    If ArDFN[I].CodRel = CodRel Then
      Begin
      Result := ArDFN[I].CodGrupo;
      Break;
      End;
  End;

Begin
If auxEhRemoto Then
  Begin
  ListBox2.Clear;
  ListBox2.MultiSelect := True;
  ListBox2.Sorted := False;

  Lista := TStringList.Create;
  For I := 0 To ListBox1.Items.Count-1 Do
    If ListBox1.Selected[I] Then
      Lista.Add(ListBox1.Items[I]);

  FullPaths.Clear;
  With FrameForm Do
    Begin
    Screen.Cursor := crHourGlass;
    Try
      ListBox2.Items.Text := WebConnection1.AppServer.GetRelatorio(LogInRemotoForm.UsuEdit.Text,
                                               LogInRemotoForm.PassEdit.Text, ConnectionID, Lista.Text, FullPathsTemp);
    Finally
      Screen.Cursor := crDefault;
      End; // Try

    FullPaths.Text := FullPathsTemp;

    If FullPaths.Text = '' Then
      Begin
      ConectouRemoto := False;
      Avisop.Label1.Caption := 'Nenhum relatório encontrado...';
      Avisop.Show;
//      ShowMessage('Nenhum relatório encontrado...');
      Lista.Free;
      Exit;
      End;

    End;

  Lista.Free;
  End
Else
If TreeView1.Selected = Nil Then
  Begin
  Avisop.Label1.Caption := 'Nenhum código de relatório selecionado!';
  Avisop.Show;
  End
//  ShowMessage('Nenhum código de relatório selecionado!')
Else
If TreeView1.Selected.HasChildren Then
  Begin
  Avisop.Label1.Caption := 'Selecione um Grupo abaixo do relatório desejado...';
  Avisop.Show;
  End
//  ShowMessage('Selecione um Grupo abaixo do relatório desejado...')
Else
  Begin
  EstePath := UpperCase(ExtractFilePath(viDirTrabApl));
  EstePath := Copy(EstePath,1,Pos('ORIGEM',EstePath)-1);

  ListBox2.Clear;
  ListBox2.MultiSelect := True;
  ListBox2.Sorted := False;

  FullPaths.Clear;

  FormGeral.QueryLocal1.Close;
  FormGeral.QueryLocal1.Sql.Clear;
  FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableDestinosDFN.TableName+'" A ');
  FormGeral.QueryLocal1.Sql.Add('WHERE A.CODREL = '''+TreeView1.Selected.Parent.Text+'''');
  FormGeral.QueryLocal1.Sql.Add('AND A.TIPODESTINO = ''Dir''');
  FormGeral.QueryLocal1.Sql.Add('AND A.SEGURANCA = ''S''');

  FormGeral.QueryLocal1.Open;
  If FormGeral.QueryLocal1.RecordCount <> 0 Then
    Begin

    GrupoStr := Copy(TreeView1.Selected.Text,2,Length(TreeView1.Selected.Text)-1);
    GrupoStr := Copy(GrupoStr,1,Pos('-',GrupoStr)-2);

    OutroPath := UpperCase(FormGeral.QueryLocal1.FieldByName('Destino').AsString);
    OutroPath := EstePath+IncludeTrailingBackSlash(Copy(OutroPath,Pos('DESTINO',OutroPath),Length(OutroPath)))+
                 RetNomeGrupo(StrToInt(GrupoStr))+
                 RetNomeSubGrupo(RetGrupo(TreeView1.Selected.Parent.Text),
                                 RetSubGrupo(TreeView1.Selected.Parent.Text))+
                 TreeView1.Selected.Parent.Text+'\';
    If FindFirst(OutroPath+'*.DAT',faArchive,SearchRec) = 0 Then
      Repeat
        FullPaths.Add(OutroPath+SearchRec.Name); // Armazena o nome do arquivo (FullPath)
        ListBox2.Items.Add(PegaInfo(OutroPath+SearchRec.Name));
      Until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);

    End;
  If ListBox2.Items.Count = 0 Then
    Begin
    Avisop.Label1.Caption := 'Nenhum relatório encontrado...';
    Avisop.Show;
    End
  Else
    ListBox2.Sorted := True;  // Há Itens, ordena.....
//    ShowMessage('Nenhum relatório encontrado...');  
  FormGeral.QueryLocal1.Close;
  End;
End;

Procedure TAssisAbreForm.Button2Click(Sender: TObject);
Var
  I,
  RetVal : Integer;
Begin
If ListBox2.SelCount = 0 Then
  Begin
  Avisop.Label1.Caption := 'Nenhum relatório selecionado para abertura';
  Avisop.Show;
  End
//  ShowMessage('Nenhum relatório selecionado para abertura')
Else
  Begin
  Avisop.Close; 
  For I := 0 To ListBox2.Items.Count-1 Do
    If ListBox2.Selected[I] Then
      Begin
      If auxEhRemoto Then
        Begin
        With FrameForm Do
          Begin
          Screen.Cursor := crHourGlass;
          
          Try
            RetVal := WebConnection1.AppServer.AbreRelatorio(LogInRemotoForm.UsuEdit.Text,
                                                             LogInRemotoForm.PassEdit.Text,
                                                             ConnectionID,
                                                             FullPaths[I],
                                                             QtdPaginas,
                                                             StrCampos,
                                                             Rel64,
                                                             Rel133);
          Finally
            Screen.Cursor := crDefault;
            End; // Try
            
          Case RetVal Of
            0 : AbreRel(FullPaths[I], True);
            1 : ShowMessage('Usuário '+LogInRemotoForm.UsuEdit.Text+' não autorizado a abrir este relatório: '+
                            ExtractFileName(FullPaths[I]));
            2 : ShowMessage('Falha de I/O '+ExtractFileName(FullPaths[I]));
            3 : ShowMessage('Relatório vazio '+ExtractFileName(FullPaths[I]));
            4 : ShowMessage('DFN inválida '+ExtractFileName(FullPaths[I]));
            5 : ShowMessage('ArqPag 2 '+ExtractFileName(FullPaths[I]));
            6 : ShowMessage('ArqPag 1 '+ExtractFileName(FullPaths[I]));
        99999 : ShowMessage('Erro não detectado '+ExtractFileName(FullPaths[I]));
            End; //Case
          End;
        End
      Else
      If FrameForm.VerificaSeguranca(FullPaths[I]) Then
        FrameForm.AbreRel(FullPaths[I], False)
      Else
        ShowMessage('Usuário '+UpperCase(GetCurrentUserName)+' não autorizado a abrir este relatório: '+
                     ExtractFileName(FullPaths[I]));
      End;
//  AssisAbreForm.FormStyle := fsNormal;
  Avisop.Close;
  End;
End;

Procedure TAssisAbreForm.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
Avisop.Close;
End;

Begin
FullPaths := TStringList.Create;
End.
