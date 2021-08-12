Unit Analisador;

//Revisado SQLServer...

Interface

Uses
  Forms, StdCtrls, Controls, Classes;

Type
  TDefReport = Class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    AtuButton: TButton;
    Button2: TButton;
    procedure AtuButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }

  End;

Var
  DefReport: TDefReport;

Implementation

uses MdiMultiCold, Dialogs, Sugeral, SysUtils;

{$R *.DFM}

Procedure TDefReport.AtuButtonClick(Sender: TObject);
Var
  I,
  J : Integer;

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

  Procedure ProcuraDats(PathRel : String; I,J, CodSis : Integer);
  Var
    SearchRec : TSearchRec;
    Cont : Integer;
  Begin
  Cont := 0;

  If FindFirst(PathRel+'*.DAT',faAnyFile,SearchRec) = 0 Then
    Repeat
      Inc(Cont);
    Until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);

  If Cont = 0 Then
    Exit;

  FormGeral.InsereAtualizaCompila('S', ArDFN[I].CodRel, CodSis, J, ArDFN[I].CodSubGrupo, Cont);
  End;

Begin
If Not FrameForm.CarregaDadosDfnIncExc Then
  Begin
  ShowMessage('Erro na carga dos dados...');
  Exit;
  End;

if not FormGeral.DatabaseMultiCold.Connected then
  FormGeral.DatabaseMultiCold.Open;
FormGeral.QueryLocal1.SQL.Clear;
FormGeral.QueryLocal1.SQL.Add(' DELETE FROM USUREL WHERE TIPO=''EXC''');
FormGeral.QueryLocal1.ExecSQL;

FormGeral.DatabaseEventos.Open;

FormGeral.EventosQuery1.SQL.Clear;
FormGeral.EventosQuery1.SQL.Add(' DELETE FROM COMPILA ');
FormGeral.EventosQuery1.ExecSQL;

For I := 0 To Length(ArDFN)-1 Do
  Begin
  If ArDFN[I].CodRel = '*' Then
    Continue;
  FormGeral.QueryLocal1.Close;
  FormGeral.QueryLocal1.Sql.Clear;
  FormGeral.QueryLocal1.Sql.Add('SELECT * FROM DESTINOSDFN A ');
  FormGeral.QueryLocal1.Sql.Add('WHERE A.CODREL = '''+ArDFN[I].CodRel+'''');
  FormGeral.QueryLocal1.Sql.Add('AND A.TIPODESTINO = ''Dir''');
  FormGeral.QueryLocal1.Sql.Add('AND A.SEGURANCA = ''S''');
  FormGeral.QueryLocal1.Open;
  If FormGeral.QueryLocal1.RecordCount = 0 Then
    Begin
    FormGeral.QueryLocal1.Close;
    Continue;
    End;
  // Sistema Automático
  If ArDFN[I].CodSis = -1 then
    for J := 0 to Length(ArrSisAux) do
      begin
      if ArrSisAux[J].CodSis < 0 then
        continue;
      if FormGeral.QueryLocal1.FieldByName('DirExpl').AsString = 'S' Then
        Edit1.Text := IncludeTrailingPathDelimiter(FormGeral.QueryLocal1.FieldByName('Destino').AsString)
      else
        Edit1.Text := IncludeTrailingPathDelimiter(FormGeral.QueryLocal1.FieldByName('Destino').AsString)+
                      RetNomeSis(ArrSisAux[J].CodSis) +
                      RetNomeGrupo(ArrSisAux[J].CodSis, ArrSisAux[J].CodGrupo)+
                      RetNomeSubGrupo(ArrSisAux[J].CodSis, ArrSisAux[J].CodGrupo, ArDFN[I].CodSubGrupo)+
                      ArDFN[I].CodRel+'\';
      Application.ProcessMessages;
      ProcuraDats(Edit1.Text,I,ArrSisAux[J].CodGrupo, ArrSisAux[J].CodSis);
      end
  Else
  // Grupo Automático
  If ArDFN[I].CodGrupo = -1 Then
    For J := 0 To Length(ArGrupo) -1 Do
      Begin
      If ArGrupo[J].CodGrupo < 0 Then
        Continue;
      If FormGeral.QueryLocal1.FieldByName('DirExpl').AsString = 'S' Then
        Edit1.Text := IncludeTrailingPathDelimiter(FormGeral.QueryLocal1.FieldByName('Destino').AsString)
      Else
        Edit1.Text := IncludeTrailingPathDelimiter(FormGeral.QueryLocal1.FieldByName('Destino').AsString)+
                      RetNomeSis(ArDFN[I].CodSis) +
                      RetNomeGrupo(ArDFN[I].CodSis, ArGrupo[J].CodGrupo)+
                      RetNomeSubGrupo(ArDFN[I].CodSis, -1, ArDFN[I].CodSubGrupo)+
                      ArDFN[I].CodRel+'\';
      Application.ProcessMessages;
      ProcuraDats(Edit1.Text,I,ArGrupo[J].CodGrupo, ArDFN[I].CodSis);
      End
  Else
    // Dfn normalzinha sem graça de tudo
    Edit1.Text := IncludeTrailingPathDelimiter(FormGeral.QueryLocal1.FieldByName('Destino').AsString)+
               RetNomeSis(ArDFN[I].CodSis) + RetNomeGrupo(ArDFN[I].CodSis, ArDFN[I].CodGrupo)+
               RetNomeSubGrupo(ArDFN[I].CodSis, ArDFN[I].CodGrupo, ArDFN[I].CodSubGrupo)+
               ArDFN[I].CodRel+'\';
    Application.ProcessMessages;
    ProcuraDats(Edit1.Text,I,ArDFN[I].CodGrupo, ArDFN[I].CodSis);
  End;
FormGeral.DatabaseMultiCold.Close;
FormGeral.DatabaseEventos.Close;
ShowMessage('Fim de atualização...');
End;

Procedure TDefReport.Button2Click(Sender: TObject);
Begin
Close;
End;

End.

