Unit FiltroProc;

//Revisado SQLServer...

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, IniFiles, ExtCtrls, Vcl.FileCtrl;

Type
  TFormFiltro = Class(TForm)
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    DispararButton: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EntradaEdit: TEdit;
    SaidaEdit: TEdit;
    FileListBox1: TFileListBox;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label3: TLabel;
    Edit1: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit2: TEdit;
    Procedure DispararButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormFiltro: TFormFiltro;

Implementation

Uses
  SuGeral, Subrug, CtrlFiltro;

Const
//  TamBuf = 655360;
//  TamBuf = 1024*1024*(512); // 0,5 Giga de buffer
  TamBuf = 1024*1024*(400); // 0,5 Giga de buffer

Type
  X = Array[1..TamBuf] Of Byte;
  Buff = X;

Var
  Linha : Buff;

{$R *.DFM}

{procedure InicializaLog;
Var
  Arq: System.Text;
begin
  AssignFile(Arq, 'C:\TEMP\FiltroLog.txt');
  Rewrite(Arq);
  CloseFile(Arq);
end;

procedure InsereLog(Msg : String);
Var
  Arq: System.Text;
begin
  AssignFile(Arq, 'C:\TEMP\FiltroLog.txt');
  Append(Arq);

  WriteLn(Arq, Msg);

  CloseFile(Arq);
end;}

Procedure TFormFiltro.DispararButtonClick(Sender: TObject);
Var
  ArqIn{,
  ArqOut} : TFileStream;
  Seq,
  I : Integer;
  auxPos    : Int64;
  aLer : Int64;
  RecProc : TSearchRec;
  TestFile : TFileStream;
  AcessoExclusivo,
  Modificou : Boolean;
  NomeGrava,
  PathGrava,
  PNome,
  PExt,
  Linha1 : String;

  TamBufLeitura : Int64;

  Procedure PesquisaBaseDeNomes;
  Var
    NomeArq : String;
    Posic   : Integer;
    Passou : Boolean;

    Procedure NomeGravaComAsterisco;
    Begin
    NomeGrava := FormGeral.QueryAux1.FieldByName('NOVONOME').AsString;
    Posic := Pos('*',NomeGrava);
    If Posic = 1 Then
      Begin
      Delete(NomeGrava,1,1);
      Posic := 0;
      End;
    If Posic = 0 Then
      NomeGrava := ChangeFileExt(RecProc.Name,NomeGrava)
    Else
      NomeGrava := Copy(NomeGrava,1,Posic-1)+SeArquivoSemExt(RecProc.Name)+Copy(NomeGrava,Posic+1,Length(NomeGrava)-Posic);
    End;

  Begin

  // tenta o nome do arquivo direto
  FormGeral.QueryAux1.Close;
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM MAPADENOMES');
  FormGeral.QueryAux1.Sql.Add('WHERE NOMEORIGINAL = '''+UpperCase(RecProc.Name)+'''');
  FormGeral.QueryAux1.Open;
  If FormGeral.QueryAux1.RecordCount <> 0 Then // Achou, vai mudar o nome
    Begin
    NomeGrava := FormGeral.QueryAux1.FieldByName('NOVONOME').AsString;
    If FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString <> '' Then
      PathGrava := IncludeTrailingPathDelimiter(FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString);
    FormGeral.QueryAux1.Close;
    Exit;
    End;
  FormGeral.QueryAux1.Close;

  // Tenta achar um match com * no meio do nomeoriginal
  FormGeral.QueryAux1.Close;
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM MAPADENOMES');
  FormGeral.QueryAux1.Sql.Add('WHERE NOMEORIGINAL LIKE '''+UpperCase('%*%')+'''');
  FormGeral.QueryAux1.Open;
  If FormGeral.QueryAux1.RecordCount <> 0 Then // Achou, vai mudar ver se matchs e se o * aparece no meio...
    Begin
    While Not FormGeral.QueryAux1.Eof Do
      Begin
      NomeGrava := FormGeral.QueryAux1.FieldByName('NOMEORIGINAL').AsString;
      If (NomeGrava <> '') And (NomeGrava[1] <> '*') Then  // * fora da primeira posição
        Begin
        Posic := Pos('*',NomeGrava);
        Passou := Copy(NomeGrava,1,Posic-1) = Copy(RecProc.Name,1,Posic-1);
        If Passou And (Posic <> Length(NomeGrava)) Then
          Passou := Copy(NomeGrava,Posic+1,Length(NomeGrava)-Posic) =
                    Copy(RecProc.Name,Length(RecProc.Name)-(Length(NomeGrava)-Posic)+1,Length(NomeGrava)-Posic);

        If Passou Then // Matchs...
          Begin
          NomeGravaComAsterisco;
          If FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString <> '' Then
            PathGrava := IncludeTrailingPathDelimiter(FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString);
          Exit;
          End;
        End;
      FormGeral.QueryAux1.Next;
      End;
    End;

  FormGeral.QueryAux1.Close;

  // se não achou tenta extraindo o prefixo (menos as seis últimas posições do nome, se numéricas)
  NomeArq := SeArquivoSemExt(RecProc.Name);
  If Length(NomeArq) > 6 Then
    Begin
    If SeNumeric(Copy(NomeArq,Length(NomeArq)-6+1,6),['0'..'9']) Then
      Begin
      NomeArq := Copy(NomeArq,1,Length(NomeArq)-6) + ExtractFileExt(RecProc.Name);
      FormGeral.QueryAux1.Sql.Clear;
      FormGeral.QueryAux1.Sql.Add('SELECT * FROM MAPADENOMES');
      FormGeral.QueryAux1.Sql.Add('WHERE NOMEORIGINAL = '''+UpperCase(NomeArq)+'''');
      FormGeral.QueryAux1.Open;
      If FormGeral.QueryAux1.RecordCount <> 0 Then // Achou, vai mudar o nome
        Begin
        NomeGrava := FormGeral.QueryAux1.FieldByName('NOVONOME').AsString;
        If FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString <> '' Then
          PathGrava := IncludeTrailingPathDelimiter(FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString);
        FormGeral.QueryAux1.Close;
        Exit;
        End;
      FormGeral.QueryAux1.Close;
      End;
    End;

  // Tenta ver se há o pedido de conversão de extenção

  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM MAPADENOMES');
  FormGeral.QueryAux1.Sql.Add('WHERE NOMEORIGINAL = '''+UpperCase('*.TXT')+'''');
  FormGeral.QueryAux1.Open;
  If (FormGeral.QueryAux1.RecordCount <> 0) And (UpperCase(ExtractFileExt(RecProc.Name))='.TXT') Then // Achou, vai mudar a extenção
    Begin
    NomeGravaComAsterisco;
    If FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString <> '' Then
      PathGrava := IncludeTrailingPathDelimiter(FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString);
    FormGeral.QueryAux1.Close;
    Exit;
    End;
  FormGeral.QueryAux1.Close;

  // Se não achou nada até aqui, varre todo o mapaDeNomes tentando encontrar o form
  NomeArq := SeArquivoSemExt(RecProc.Name);
  FormGeral.QueryAux1.SQL.Clear;
  FormGeral.QueryAux1.SQL.Add('SELECT * FROM MAPADENOMES ');
  FormGeral.QueryAux1.SQL.Add('ORDER BY NOMEORIGINAL ');
  FormGeral.QueryAux1.Open;
  while not FormGeral.QueryAux1.Eof do
    begin
    Posic := Pos('.',FormGeral.QueryAux1.FieldByName('NOMEORIGINAL').asString)-1;
    if (Posic>0) and
       (Copy(NomeArq,1,Posic) = Copy(FormGeral.QueryAux1.FieldByName('NOMEORIGINAL').asString,1,Posic)) then
      begin
      NomeGrava := FormGeral.QueryAux1.FieldByName('NOVONOME').AsString;
      If FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString <> '' Then
        PathGrava := IncludeTrailingPathDelimiter(FormGeral.QueryAux1.FieldByName('NOVODIRSAIDA').AsString);
      FormGeral.QueryAux1.Close;
      Exit;
      end;
    FormGeral.QueryAux1.Next;
    end;
  FormGeral.QueryAux1.Close;
  End;

Begin
If ControleFiltro = ' ' Then
  Exit;

EntradaEdit.Text := viDirEntraFil;
SaidaEdit.Text := viDirSaiFil;
FileListBox1.Mask := viDirEntraFil+'*.*';
FileListBox1.Update;
Application.ProcessMessages;

If (viDirEntraFil) = (viDirSaiFil) Then // Deve filtrar para lugares diferentes...
  Begin
  FormGeral.InsereLog('Filtro','Dir Entrada = Dir Saida, filtragem abortada');
  Application.Terminate;
  Exit;
  End;

//InsereLog('Lendo Mapa');
FormGeral.LerMapa;

If FindFirst(viDirEntraFil+'*.*', faAnyFile, RecProc) = 0 Then

  Repeat
//  InsereLog('Filtrando: '+RecProc.Name);
//  InsereLog('Atualizando FileListBox');

  FileListBox1.Mask := viDirEntraFil+'*.*';
  FileListBox1.Update;
  Application.ProcessMessages;

//  InsereLog('Testando acesso exclusivo');
  AcessoExclusivo := False;
  if (RecProc.Name <> '.') and (RecProc.Name <> '..') then
    Begin
    AcessoExclusivo := True;
    TestFile := Nil;
    Try
      TestFile := TFileStream.Create(viDirEntraFil+RecProc.Name,fmOpenRead or fmShareExclusive);
      Except
        AcessoExclusivo := False
      End; // Try
    If TestFile <> Nil Then
      TestFile.Free;
    End;

  If AcessoExclusivo Then
    Begin
    NomeGrava := RecProc.Name;
    PathGrava := viDirSaiFil;

//    InsereLog('Acesso exclusivo ok, obtendo nome de gravação');
    PesquisaBaseDeNomes;

//    InsereLog('Renomeando para processar');
    RenameFile(viDirEntraFil+RecProc.Name,viDirEntraFil+'FiltragemEmProcesso'+RecProc.Name);
//    InsereLog('Abrindo para leitura');
//    ArqIn := TFileStream.Create(viDirEntraFil+'FiltragemEmProcesso'+RecProc.Name, fmOpenRead or fmShareDenyNone);
    ArqIn := TFileStream.Create(viDirEntraFil+'FiltragemEmProcesso'+RecProc.Name, fmOpenReadWrite or fmShareExclusive);

    Edit1.Text := RecProc.Name;
    Application.ProcessMessages;

//    InsereLog('Obtendo nome único para gravação');
    If FileExists(PathGrava+NomeGrava) Then
      Begin
      PNome := SeArquivoSemExt(ExtractFileName(NomeGrava));
      PExt := ExtractFileExt(NomeGrava);
      Seq := 0;
      Repeat
        Inc(Seq);
      Until Not FileExists(PathGrava+PNome+'_'+IntToStr(Seq)+PExt);
      NomeGrava := PNome+'_'+IntToStr(Seq)+PExt;
      End;

    SysUtils.ForceDirectories(PathGrava); // Criar o diretório de destino...

//    InsereLog('Abrindo para escrita');
{    if fileExists(PathGrava+NomeGrava) then
      begin
      ArqOut := TFileStream.Create(PathGrava+NomeGrava, fmOpenWrite or fmShareExclusive);
      ArqOut.Seek(ArqOut.Size, soBeginning);
      end
    else
      ArqOut := TFileStream.Create(PathGrava+NomeGrava, fmCreate or fmShareExclusive);}

    aLer := ArqIn.Size;
    Edit5.Text := FormatFloat('###,###,###,###,###,###',aLer);
    Application.ProcessMessages;

//    InsereLog('Processando');
    Linha1 := '';
    While ArqIn.Position < ArqIn.Size do
      Begin
      auxPos := ArqIn.Position;
      if TamBuf > (ArqIn.Size-ArqIn.Position) then
         TamBufLeitura := (ArqIn.Size-ArqIn.Position)
      else
        TamBufLeitura := TamBuf;

      ArqIn.ReadBuffer(Linha, TamBufLeitura);

      Edit3.Text := FormatFloat('###,###,###,###,###,###',ArqIn.Position);
      Application.ProcessMessages;

      Modificou := False;
      For I := 1 To TamBufLeitura Do
        Begin
        if Byte(Linha[I]) <> RegMapa[Byte(Linha[I])] then
          begin
            Byte(Linha[I]) := RegMapa[Byte(Linha[I])];
            Modificou := True;
          end;

        End;
      Edit2.Text := Edit3.Text;
      Application.ProcessMessages;

//      InsereLog('Gravando buffer');
      if Modificou then
        begin
        ArqIn.Seek(auxPos, soBeginning);
        ArqIn.WriteBuffer(Linha[1], TamBufLeitura);
        end;

      Edit4.Text := FormatFloat('###,###,###,###,###,###',ArqIn.Position);
      Application.ProcessMessages;
      End;

//    Dispose(Linha);
    Edit3.Text := FormatFloat('###,###,###,###,###,###',ArqIn.Position);
//    Edit4.Text := FormatFloat('###,###,###,###,###,###',ArqOut.Position);
    Edit4.Text := FormatFloat('###,###,###,###,###,###',ArqIn.Position);
    Application.ProcessMessages;
//    InsereLog('Fechando arquivos');
    ArqIn.Free;
//    ArqOut.Free;
//    InsereLog('Apagando o processado de entrada');
//    DeleteFile(pChar(viDirEntraFil+'FiltragemEmProcesso'+RecProc.Name));

    Edit1.Text := 'Movendo... '+RecProc.Name;
    Application.ProcessMessages;

    if not MoveFile(Pchar(String(viDirEntraFil)+'FiltragemEmProcesso'+RecProc.Name), Pchar(PathGrava+NomeGrava)) then
      begin
      Edit1.Text := 'Copiando... '+RecProc.Name;
      Application.ProcessMessages;
      CopyFile(Pchar(String(viDirEntraFil)+'FiltragemEmProcesso'+RecProc.Name), Pchar(PathGrava+NomeGrava), True); //Overwrite=true
      DeleteFile(pChar(String(viDirEntraFil)+'FiltragemEmProcesso'+RecProc.Name));
      end;
    End;
  Until FindNext(RecProc) <> 0;
SysUtils.FindClose(RecProc);

//InsereLog('Atualizando lista');
FileListBox1.Mask := viDirEntraFil+'*.*';
FileListBox1.Update;
Edit3.Text := '';
Edit4.Text := '';
Application.ProcessMessages;
//Semaforo := True;
//InsereLog('Saindo... até a próxima!');
End;

procedure TFormFiltro.FormCreate(Sender: TObject);
begin

//InicializaLog;
end;

End.
