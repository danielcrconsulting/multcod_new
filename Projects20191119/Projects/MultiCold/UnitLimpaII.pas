Unit UnitLimpaII;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Mask, ComCtrls;

Type
  TForm1 = Class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    Configuraes1: TMenuItem;
    Diretrios1: TMenuItem;
    MaskEdit1: TMaskEdit;
    Label1: TLabel;
    Button1: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Procedure Sair1Click(Sender: TObject);
    procedure Diretrios1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

Uses JaConfU, SuGeral, SuBrug, LogInU;

{$R *.DFM}

Procedure TForm1.Sair1Click(Sender: TObject);
Begin
Close;
End;

Procedure TForm1.Diretrios1Click(Sender: TObject);
Begin
JaConf.Label1.Visible := False;
JaConf.Edit1.Visible := False;
JaConf.ShowModal;
End;

Procedure TForm1.Button3Click(Sender: TObject);
Begin
Termina := True;
Close;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Var
  Dia,
  Mes,
  Ano : Word;
  DefaultData,
  DfnData : TDateTime;
  IGrupo,
  I : Integer;

  Procedure VarreDir;
  Var
    NavDat,
    NavAll : TSearchRec;
    DirName,
    NomArq,
    NomeIn,
    NomeOut : String;
    SoData : TDate;
    Cont,
    RepCount : Integer;
  Begin

  If FormGeral.QueryLocal1.FieldByName('CODSIS').AsInteger = ArGrupo[IGrupo].CodSis Then
    Begin

    If UpperCase(FormGeral.QueryLocal1.FieldByName('DIREXPL').AsString) = 'S' Then
      Begin
      DirName := IncludeTrailingPathDelimiter(UpperCase(FormGeral.QueryLocal1.FieldByName('DESTINO').AsString));
      End
    Else
      Begin
      If FormGeral.QueryLocal1.FieldByName('CODGRUPO').AsInteger <> -1 Then
        Begin
        While ArGrupo[IGrupo].CodGrupo <> FormGeral.QueryLocal1.FieldByName('CODGRUPO').AsInteger Do
          Begin
          Inc(IGrupo);
          If IGrupo >= Length(ArGrupo) Then
            Begin
            ShowMessage('Grupo em DFN não existe em GRUPOSDFN??? '+FormGeral.QueryLocal1.FieldByName('CODGRUPO').AsString);
            Application.Terminate;
            While True Do Application.ProcessMessages;
            End;
          End;
        End;
      DirName := IncludeTrailingPathDelimiter(UpperCase(FormGeral.QueryLocal1.FieldByName('DESTINO').AsString)) +
                 IncludeTrailingPathDelimiter(UpperCase(FormGeral.QueryLocal1.FieldByName('NOMESIS').AsString)) +
                 IncludeTrailingPathDelimiter(ArGrupo[IGrupo].NomeGrupo) +
                 IncludeTrailingPathDelimiter(UpperCase(FormGeral.QueryLocal1.FieldByName('NOMESUBGRUPO').AsString)) +
                 IncludeTrailingPathDelimiter(UpperCase(FormGeral.QueryLocal1.FieldByName('CODREL').AsString));
      End;

    If Termina Then
      Begin
      ShowMessage('Cancelado...');
      Application.Terminate;
      While True Do Application.ProcessMessages;
      End;

      RepCount := 0;
//  ShowMessage('Indo atrás dos dats');
    If FindFirst(DirName+'*.dat',faAnyFile,NavDat) = 0 Then
      Repeat

      If RepCount = 0 Then
        Memo1.Lines.Add(DirName);
      Inc(RepCount);

      If Termina Then
        Begin
        ShowMessage('Cancelado...');
        Application.Terminate;
        While True Do Application.ProcessMessages;
        End;

      SoData := FileDateToDateTime(NavDat.Time);

      If FormGeral.QueryLocal1.FieldByName('TIPOPERIODO').AsString = '' Then
        DfnData := DefaultData
      Else
        Begin
        DfnData := Now;
        Try
          FormGeral.QueryLocal1.FieldByName('QTDPERIODOS').AsInteger;
        Except
          ShowMessage('QTDPERIODOS Inválido em '+FormGeral.QueryLocal1.FieldByName('CODREL').AsString);
          Exit;
          End; // Try
        If UpperCase(FormGeral.QueryLocal1.FieldByName('TIPOPERIODO').AsString) = 'D' Then
          SoData := SoData + FormGeral.QueryLocal1.FieldByName('QTDPERIODOS').AsInteger
        Else
          Begin
          DecodeDate(Sodata,Ano,Mes,Dia);
          If UpperCase(FormGeral.QueryLocal1.FieldByName('TIPOPERIODO').AsString) = 'M' Then
            Begin
            Inc(Mes,FormGeral.QueryLocal1.FieldByName('QTDPERIODOS').AsInteger);
            While Mes > 12 Do
              Begin
              Inc(Ano);
              Dec(Mes,12);
              End;
            If (Mes In [4,6,9,11]) Then
              Begin
              If Dia = 31 Then
                Dia := 30;
              End
            Else
              If Mes = 2 Then
                If IsLeapYear(Ano) Then
                  Begin
                  If Dia >= 30 Then
                    Dia := 29;
                  End
                Else
                  If Dia >= 29 Then
                    Dia := 28;
            End
          Else
            If UpperCase(FormGeral.QueryLocal1.FieldByName('TIPOPERIODO').AsString) = 'A' Then
              Begin
              Inc(Ano,FormGeral.QueryLocal1.FieldByName('QTDPERIODOS').AsInteger);
              If Mes = 2 Then
                If IsLeapYear(Ano) Then
                  Begin
                  If Dia >= 30 Then
                    Dia := 29;
                  End
                Else
                  If Dia >= 29 Then
                    Dia := 28;
              End;
          SoData := EncodeDate(Ano, Mes, Dia);
          End;
        End;

      If (FileExists(DirName + NavDat.Name)) And
         (Sodata < DfnData) Then  // Mover os arquivos
        Begin
        NomArq := DirName + SeArquivoSemExt(NavDat.Name) + '*.*';
        If FindFirst(NomArq,faAnyFile,NavAll) = 0 Then
          Repeat
            If Not (FileExists(DirName + NavAll.Name)) Then
              Continue;

            If Termina Then
              Begin
              ShowMessage('Cancelado...');
              Application.Terminate;
              While True Do Application.ProcessMessages;
              End;

            NomeIn := ExtractFilePath(NomArq)+NavAll.Name;
            NomeOut := JaConf.Edit2.Text +
                       Copy(NomeIn, Length(JaConf.Edit1.Text),
                            Length(NomeIn)-Length(JaConf.Edit1.Text)+1);

            Edit1.Text := NomeIn;
            Application.ProcessMessages;

            ForceDirectories(ExtractFilePath(NomeOut));

            // Mover o arquivo

            If Not MoveFile(Pchar(NomeIn), Pchar(NomeOut)) Then
              Begin
              CopyFile(Pchar(NomeIn), Pchar(NomeOut), False); // OverWrite If Exists
              DeleteFile(NomeIn);
              End; //   Deixar a deleção desligada para testes...

          Until FindNext(NavAll) <> 0;

        RemoveDir(ExcludeTrailingPathDelimiter(ExtractFilePath(NomArq))); // Tenta remover o diretório original
        FindClose(NavAll);

        End;
        Application.ProcessMessages;
      Until FindNext(NavDat) <> 0;
    FindClose(NavDat);

    If RepCount <> 0 Then // Há dat's no diretório...
      Begin
      Cont := 0;
      If FindFirst(DirName+'*.dat',faAnyFile,NavDat) = 0 Then
        Repeat
          Inc(Cont);
        Until FindNext(NavDat) <> 0;
      FindClose(NavDat);

      FormGeral.InsereAtualizaCompila('S',FormGeral.QueryLocal1.FieldByName('CODREL').AsString,
                                          FormGeral.QueryLocal1.FieldByName('CODSIS').AsInteger,
                                          ArGrupo[IGrupo].CodGrupo,
                                          FormGeral.QueryLocal1.FieldByName('CODSUBGRUPO').AsInteger,
                                          Cont);
      End;
    End;  //  If FormGeral.QueryLocal1.FieldByName('CODSIS').AsInteger = ArGrupo[IGrupo].CodSis Then

  // No caso do automático, chama recursivamente para todos os grupos disponíveis na instalação...
  
  If FormGeral.QueryLocal1.FieldByName('CODGRUPO').AsInteger = -1 Then
    If IGrupo < Length(ArGrupo)-1 Then
      Begin
      Inc(IGrupo);
      VarreDir;
      End;

  End;

Begin
Memo1.Clear;
Memo1.Lines.Add('Inicializando, aguarde.....');
Termina := False;
If MaskEdit1.Text = '' Then
  Begin
  ShowMessage('Informe a data limite para a limpeza');
  Exit;
  End;
Try
  Ano := StrToInt(Trim(Copy(MaskEdit1.Text,5,4)));
Except
  ShowMessage('Erro ao converter o ano');
  Exit;
  End; // Try
Try
  Mes := StrToInt(Trim(Copy(MaskEdit1.Text,3,2)));
Except
  ShowMessage('Erro ao converter o mês');
  Exit;
  End; // Try
Try
  Dia := StrToInt(Trim(Copy(MaskEdit1.Text,1,2)));
Except
  ShowMessage('Erro ao converter o dia');
  Exit;
  End; // Try
Try
  DefaultData := EncodeDate(Ano,Mes,Dia);
Except
  ShowMessage('Data informada inválida');
  Exit;
  End; // Try

// Carrega os dados da tabela de grupos
// Quando uma DFN tiver o grupo = -1 (automático) a montagem dos diretórios de destino será feita com os 
// nomes dos grupos definidos nesta tabela

FormGeral.DatabaseEventos.Connected := True;
FormGeral.DatabaseMultiCold.Connected := True;
FormGeral.DatabaseLog.Connected := True;

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM GRUPOSDFN A');
FormGeral.QueryLocal1.Sql.Add('ORDER BY A.CODGRUPO ');
Try
  FormGeral.QueryLocal1.Open;
Except
  ShowMessage('Erro ao tentar carregar dados de '+viGrupo);
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArGrupo, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArGrupo[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArGrupo[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArGrupo[I].NomeGrupo := FormGeral.QueryLocal1.FieldByName('NomeGrupo').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;

FormGeral.QueryLocal1.Close;  

FormGeral.InsereEventos(MaskEdit1.Text,JaConf.Edit2.Text,LogInForm.UsuEdit.Text,7,'');

JaConf.Edit2.Text := ExcludeTrailingPathDelimiter(JaConf.Edit2.Text); // Fica sem...
JaConf.Edit1.Text := IncludeTrailingPathDelimiter(JaConf.Edit1.Text);

FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM DESTINOSDFN A, DFN B, GRUPOSDFN C, SUBGRUPOSDFN D, SISTEMA E ');
FormGeral.QueryLocal1.Sql.Add('WHERE (B.CODSIS = E.CODSIS) AND ');
FormGeral.QueryLocal1.Sql.Add('      (A.CODREL = B.CODREL) AND ');
FormGeral.QueryLocal1.Sql.Add('      (B.CODSIS = C.CODSIS) AND ');
FormGeral.QueryLocal1.Sql.Add('      (B.CODGRUPO = C.CODGRUPO) AND ');
FormGeral.QueryLocal1.Sql.Add('      ((B.CODSIS = D.CODSIS) AND ');
FormGeral.QueryLocal1.Sql.Add('       (B.CODGRUPO = D.CODGRUPO) AND ');
FormGeral.QueryLocal1.Sql.Add('       (B.CODSUBGRUPO = D.CODSUBGRUPO)) ');
FormGeral.QueryLocal1.Sql.Add('ORDER BY A.CODREL ');
Try
  FormGeral.QueryLocal1.Open;
Except
  ShowMessage('Erro ao tentar carregar dados dos diretórios de destino ');
  Exit;
  End; // Try

Memo1.Lines.Add('Procurando .DATs para limpeza em...');
Memo1.Lines.Add('');

While Not FormGeral.QueryLocal1.Eof Do
  Begin
  IGrupo := 0;
  VarreDir;
  FormGeral.QueryLocal1.Next;   // Loop to next record
  End;
  
FormGeral.QueryLocal1.Close;  

Edit1.Text := '';
Application.ProcessMessages;

ShowMessage('Fim de limpeza...');

End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
Edit1.Text := 'Andamento da limpeza...';

If viNDiasPerm = '' Then
  viNDiasPerm := '60'; // Assumindo o default
  
Try
  StrToInt(viNDiasPerm);
Except
  ShowMessage('Número de dias de permanência nas configurações inválido, considerando 60...');
  viNDiasPerm := '60';
  End; // Try
MaskEdit1.Text := FormatDateTime('DDMMYYYY',Now-StrToInt(viNDiasPerm));
End;

Procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
Begin
FormGeral.DatabaseEventos.Connected := False;
FormGeral.DatabaseMultiCold.Connected := False;
FormGeral.DatabaseLog.Connected := False;
End;

End.
