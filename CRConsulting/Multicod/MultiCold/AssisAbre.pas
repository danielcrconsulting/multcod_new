Unit AssisAbre;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, ComCtrls, UMetodosServer,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.FireDACJSONReflect,
  Vcl.ExtCtrls;

Type
  TAssisAbreForm = Class(TForm)
    Table1: TTable;
    Panel1: TPanel;
    Panel2: TPanel;
    FiltradoCheckBox: TCheckBox;
    Button1: TButton;
    TreeView1: TTreeView;
    Panel3: TPanel;
    ListBox2: TListBox;
    Panel4: TPanel;
    Button2: TButton;
    Button3: TButton;
    Memtb: TFDMemTable;
    Procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FiltradoCheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  Private
    { Private declarations }
    OMetodosServer : clsMetodosServer;
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
  SisStr,
  GrupoStr,
  EstePath,
  OutroPath : String;
  ErrorCode,
  I,
  Sistema,
  Grupo,
  SubGrupo,
  OldFileMode : Integer;
  SearchRec : TSearchRec;

  strlst : TStringlist;
  strPar : TFDParams;
  Param  : TFDParam;

  Function PegaInfo(Path : String) : String;

  Var
    Arq32 : File Of Integer;
    Arq64 : File Of Int64;

  Begin
  OldFileMode := FileMode;
  FileMode := 0;
  Result := ExtractFileName(Path);
  If FileExists(ChangeFileExt(Path,'.IAP')) Then
    Begin
    AssignFile(Arq32,ChangeFileExt(Path,'.IAP'));
    Reset(Arq32);
    Result := Result + ' -> ' + Format('%7d',[Filesize(Arq32)]) + ' Pgns';
    CloseFile(Arq32);
    End
//  Else
//  If FileExists(ChangeFileExt(Path,'.IAPS')) Then
//    Begin
//    AssignFile(Arq64,ChangeFileExt(Path,'.IAPS'));
//    Reset(Arq64);
//    Result := Result + ' -> ' + Format('%7d',[Filesize(Arq64)]) + ' Pgns';
//    CloseFile(Arq64);
//    If Not AdcPassWord Then
//      Begin
//      Session.AddPassword(Senha);
//      AdcPassWord := True;
//      End;
//    Table1.TableName := ChangeFileExt(Path,'Dfn.db');
//    Table1.Open;
//    Result := Result + '  "' + Table1.FieldByName('NomeRel').AsString+'"';
//    Table1.Close;
 //   End
  Else If FileExists(ChangeFileExt(Path,'.IAPX')) Then
    Begin
    AssignFile(Arq64,ChangeFileExt(Path,'.IAPX'));
    Reset(Arq64);
    Result := Result + ' -> ' + Format('%7d',[Filesize(Arq64)]) + ' Pgns';
    CloseFile(Arq64);
    End
  Else
    Result := Result + ' -> ' + Format('%7d',[1]) + ' Pgns';
    
  FileMode := OldFileMode;
  End;

  Function RetNomeSis(Sistema : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArSis)-1 Do  // Achar o nome do grupo
    If (ArSis[I].CodSis = Sistema) Then
      Begin
      Result := ArSis[I].NomeSis + '\';
      Break;
      End;
  End;

  Function RetCodSis(Sistema : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := -1;
  For I := 0 To Length(ArSis)-1 Do  // Achar o nome do grupo
    If (ArSis[I].NomeSis = Sistema) Then
      Begin
      Result := ArSis[I].CodSis;
      Break;
      End;
  End;

  Function RetNomeGrupo(Sistema, Grupo : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArGrupo)-1 Do  // Achar o nome do grupo
    If (ArGrupo[I].CodSis = Sistema) And (ArGrupo[I].CodGrupo = Grupo) Then
      Begin
      Result := ArGrupo[I].NomeGrupo+'\';
      Break;
      End;
  End;

  Function RetNomeSubGrupo(Sistema, Grupo, SubGrupo : Integer) : String;
  Var
    I : Integer;
  Begin
  Result := '';
  For I := 0 To Length(ArSubGrupo)-1 Do  // Achar o nome do subgrupo
    If ArSubGrupo[I].CodSis = Sistema Then
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
If TreeView1.Selected = Nil Then
  Begin
  Avisop.Label1.Caption := 'Nenhum código de relatório selecionado!';
  Avisop.Show;
  End
Else
If TreeView1.Selected.HasChildren Then
  Begin
  Avisop.Label1.Caption := 'Selecione um Grupo abaixo do relatório desejado...';
  Avisop.Show;
  End
Else
If (Length(TreeView1.Selected.Text) > 1) And (Copy(TreeView1.Selected.Text,1,2)='  ') Then
  Begin
  Avisop.Label1.Caption := 'Módulo do Relatório...';
  Avisop.Show;
  End
Else
  Begin
//  EstePath := UpperCase(ExtractFilePath(viDirTrabApl));
  EstePath := UpperCase(ExtractFilePath(ParamStr(0)));
//  EstePath := Copy(EstePath,1,Pos('ORIGEM',EstePath)-1);

  ListBox2.Clear;
  ListBox2.MultiSelect := True;
  ListBox2.Sorted := False;

  FullPaths.Clear;

    strPar := TFDParams.Create;
    strLst := TStringList.Create;
    strlst.Add('SELECT * FROM DESTINOSDFN A ');
    strlst.Add('WHERE A.CODREL = '''+TreeView1.Selected.Parent.Text+'''');
    strlst.Add('AND A.TIPODESTINO = ''Dir''');
    strlst.Add('AND A.SEGURANCA = ''S''');

    FormGeral.ImportarDados(strLst.Text, nil);
  {
  FormGeral.QueryLocal1.Close;
  FormGeral.QueryLocal1.Sql.Clear;
  FormGeral.QueryLocal1.Sql.Add('SELECT * FROM DESTINOSDFN A ');
  FormGeral.QueryLocal1.Sql.Add('WHERE A.CODREL = '''+TreeView1.Selected.Parent.Text+'''');
  FormGeral.QueryLocal1.Sql.Add('AND A.TIPODESTINO = ''Dir''');
  FormGeral.QueryLocal1.Sql.Add('AND A.SEGURANCA = ''S''');

  FormGeral.QueryLocal1.Open;
  }

  FormGeral.Memtb.Open;
  If FormGeral.Memtb.RecordCount <> 0 Then
    Begin

    Sistema := 0;
    Grupo := 0;
    SubGrupo := 0;
    For I := 0 To Length(ArDFN)-1 Do // Achar o código do sistema
      If ArDFN[I].CodRel = TreeView1.Selected.Parent.Text Then
        Begin
        Sistema := ArDFN[I].CodSis;
        Grupo := ArDFN[I].CodGrupo;
        SubGrupo := ArDFN[I].CodSubGrupo;
        Break;
        End;

    SisStr := intToStr(Sistema);
    if Sistema = -1 then
      Begin
      SisStr := TreeView1.Selected.Parent.getFirstChild.Text;
      SisStr := Copy(SisStr,3,Length(SisStr));
      SisStr := Copy(SisStr,Pos(' ',SisStr)+1,Length(SisStr));
      SisStr := intToStr(RetCodSis(SisStr));
      End;

    GrupoStr := Copy(TreeView1.Selected.Text,2,Length(TreeView1.Selected.Text)-1);
    GrupoStr := Copy(GrupoStr,1,Pos('-',GrupoStr)-2);

    OutroPath := EstePath +
                 RetNomeSis(strToInt(SisStr)) +
                 RetNomeGrupo(strToInt(SisStr), strToInt(GrupoStr)) +
                 RetNomeSubGrupo(Sistema, Grupo, SubGrupo) +
                 TreeView1.Selected.Parent.Text+'\';
    Avisop.Label2.Caption := OutroPath;

    (*
    OutroPath := EstePath + //IncludeTrailingPathDelimiter(Copy(OutroPath,Pos('DESTINO',OutroPath),Length(OutroPath)))+
                 RetNomeSis(Sistema) + RetNomeGrupo(Sistema, StrToInt(GrupoStr))+
                 RetNomeSubGrupo(Sistema, RetGrupo(TreeView1.Selected.Parent.Text),
                                 RetSubGrupo(TreeView1.Selected.Parent.Text))+
                 TreeView1.Selected.Parent.Text+'\';
     *)

    ErrorCode := FindFirst(OutroPath+'*.DAT',faAnyFile,SearchRec);
    If  ErrorCode = 0 Then
      Repeat
        FullPaths.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+
                      OutroPath+SearchRec.Name); // Armazena o nome do arquivo (FullPath)
        ListBox2.Items.Add(FormatDateTime('YYYY/MM/DD, HH:NN:SS',FileDateToDateTime(SearchRec.Time))+' '+
                           PegaInfo(OutroPath+SearchRec.Name));
      Until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);

    End;
  If ListBox2.Items.Count = 0 Then
    Begin
    Avisop.Label1.Caption := 'Nenhum relatório encontrado...';
    Avisop.Show;
//    ShowMessage(OutroPath);
    End
  Else
    Begin
    StrSrt.Text := ListBox2.Items.Text;   // Ordena Ascii e descendente......
    StrSrt.CustomSort(SortCompareDesc);
    ListBox2.Items.Text := StrSrt.Text;
    FullPaths.CustomSort(SortCompareDesc); // Coloca os nomes de arquivo no mesma ordem
    End;
  //FormGeral.QueryLocal1.Close;
    FormGeral.Memtb.Close;
  End;
End;

Procedure TAssisAbreForm.Button2Click(Sender: TObject);
Var
  I : Integer;
Begin
If ListBox2.SelCount = 0 Then
  Begin
  Avisop.Label1.Caption := 'Nenhum relatório selecionado para abertura';
  Avisop.Show;
  End
Else
  Begin
  Avisop.Close;
  For I := 0 To ListBox2.Items.Count-1 Do
    If ListBox2.Selected[I] Then
      Begin
      If FrameForm.VerificaSeguranca(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)) Then
        FrameForm.AbreRel(Copy(FullPaths[I], 21,Length(FullPaths[I])-20), False)
      Else
        ShowMessage('Usuário '+UpperCase(GetCurrentUserName)+' não autorizado a abrir este relatório: '+
                     ExtractFileName(Copy(FullPaths[I], 21,Length(FullPaths[I])-20)));
      End;
  Avisop.Close;
  End;
End;

Procedure TAssisAbreForm.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  Avisop.Close;
  FreeAndNil(OMetodosServer);
End;

Procedure TAssisAbreForm.FormCreate(Sender: TObject);
Begin
  AssisAbreFlg := False;
  OMetodosServer := clsMetodosServer.Create(Self);
  OMetodosServer.Configurar;
End;

Procedure TAssisAbreForm.FiltradoCheckBoxClick(Sender: TObject);
Begin
// Remontar o grid de abertura assistida...
Tela := '';
FrameForm.AbrirAssistido1.Click;
End;

procedure TAssisAbreForm.FormShow(Sender: TObject);
begin
Self.Width := FrameForm.Width - 20;
Self.Left := FrameForm.Left + 10;
Self.Top := FrameForm.Height - Self.Height - 20;
end;

Begin
FullPaths := TStringList.Create;

End.
