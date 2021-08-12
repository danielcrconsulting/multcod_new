Unit FiltroProc;

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, IniFiles, FileCtrl;

Type
  TFormFiltro = Class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    FileListBox1: TFileListBox;
    Label4: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Procedure Button1Click(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormFiltro: TFormFiltro;

Implementation

Uses
  MapaFilU, Analisador, SuGeral, Subrug;

Const
  TamBuf = 6553600;

Type
  Buff = Array[1..TamBuf] Of Byte;

Var
  Linha : ^Buff;

{$R *.DFM}

Procedure TFormFiltro.Button1Click(Sender: TObject);
Var
  ArqIn,
  ArqOut : File;
  TamOri,
  Lidos,
  Gravados : Int64;
  Seq,
  I,
  Err,
  ErrII,
  Cont : Integer;
  RecProc : TSearchRec;
  TestFile : TFileStream;
  AcessoExclusivo : Boolean;
  NomeGrava,
  PathGrava,
  PNome,
  PExt : String;

Begin

If ControleFiltro = ' ' Then
  Exit;
If IncludeTrailingPathDelimiter(Edit1.Text) = IncludeTrailingPathDelimiter(Edit2.Text) Then // Deve filtrar para lugares diferentes...
  Begin
  ShowMessage('Filtro - Dir Entrada = Dir Saida, filtragem abortada');
  Application.Terminate;
  Exit;
  End;  

AssignFile(ArqMapa,viDirTrabApl+'MapaFiltro.Dat');
Try
  Reset(ArqMapa);
  CloseFile(ArqMapa);
Except
  ShowMessage('Filtro - Arquivo de conversão não encontrado, filtragem abortada');
  Application.Terminate;
  End; // Try

Reset(ArqMapa);
Read(ArqMapa, RegMapa);
CloseFile(ArqMapa);

If FindFirst(Edit1.Text+'*.*',faAnyFile,RecProc) = 0 Then
  Repeat
  FileListBox1.Mask := Edit1.Text+'*.*';
  FileListBox1.Update;
  Application.ProcessMessages;

  AcessoExclusivo := True;
  TestFile := Nil;
  Try
    TestFile := TFileStream.Create(Edit1.Text+RecProc.Name,fmOpenRead or fmShareExclusive);
    Except
    AcessoExclusivo := False
    End; // Try
  If TestFile <> Nil Then
    TestFile.Free;

  If AcessoExclusivo Then
    Begin
    NomeGrava := RecProc.Name;
    PathGrava := Edit2.Text;

    AssignFile(ArqIn,Edit1.Text+RecProc.Name);

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

    AssignFile(ArqOut,PathGrava+NomeGrava);
    {$i-}
    Reset(ArqIn,1);
    {$i+}
    If IoResult = 0 Then
      Begin
      ForceDirectories(PathGrava); // Criar o diretório de destino...
      ReWrite(ArqOut,1);
      New(Linha);

      TamOri := FileSize(ArqIn);
      Edit5.Text := IntToStr(TamOri);
      Application.ProcessMessages;

      Cont := 0;
//      While Not Eof(ArqIn) Do
      Lidos := 0;
      Gravados := 0;
      While True Do
        Begin
        Try
          BlockRead(ArqIn,Linha^[1],TamBuf,Err);               // Quando der erro, chegou ao fim...
          If Err = 0 Then                                      // Ou se ler 0, para
            Break;
          Inc(Lidos,Err);
          For I := 1 To Err Do
            Linha^[I] := RegMapa[Linha^[I]];
          BlockWrite(ArqOut,Linha^[1],Err,ErrII);
          Inc(Gravados,Err);
        Except
          Break;
          End; // Try
        Inc(Cont);
        If Cont = 10 Then
          Begin
          Cont := 0;
          Edit3.Text := IntToStr(Lidos);
          Edit4.Text := IntToStr(Gravados);
          If Lidos > TamOri Then
            Edit5.Text := IntToStr(Lidos);
          Application.ProcessMessages;
          End;
        End;

      Edit3.Text := IntToStr(Lidos);
      Edit4.Text := IntToStr(Gravados);
      If Lidos > TamOri Then
        Edit5.Text := IntToStr(Lidos);
        
      Dispose(Linha);
//      Edit3.Text := IntToStr(FilePos(ArqIn));
//      Edit4.Text := IntToStr(FilePos(ArqOut));
      Application.ProcessMessages;
      CloseFile(ArqIn);
      CloseFile(ArqOut);
      Erase(ArqIn);
      End;
    End;
  Until FindNext(RecProc) <> 0;
FileListBox1.Mask := Edit1.Text+'*.*';
FileListBox1.Update;
Edit3.Text := '';
Edit4.Text := '';
Application.ProcessMessages;
SysUtils.FindClose(RecProc);
Semaforo := True;
End;

Procedure TFormFiltro.FormCreate(Sender: TObject);
Begin
Edit1.Text := viDirEntraFil;
Edit2.Text := viDirSaiFil;
FileListBox1.Mask := Edit1.Text+'*.*';
FileListBox1.Update;
Application.ProcessMessages;
End;

End.
