Unit MDIEdit;

Interface

Uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Printers,
  Dialogs, Menus, Clipbrd, StdCtrls, GridQue, Grids, Analisador, SuTypGer,
  ExtCtrls, Buttons, SuGeral, DB, DBTables, AvisoI, ZLib,
  RFMImage, RFMRec, ComCtrls, DBClient;

Type
  TEditForm = Class(TForm)
    MemoPopUp: TPopupMenu;
    Copy2: TMenuItem;
    ScrollBox1: TScrollBox;
    DefChave: TStringGrid;
    Query1: TQuery;
    ModoTextoPopUp: TMenuItem;
    CopiarTexto1: TMenuItem;
    Memo1: TRichEdit;
    RFMImage1: TRFMImage;
    Image1: TImage;
    ClientDataSet1: TClientDataSet;
    Function Open(Const AFilename: ShortString; EhRemoto : Boolean) : Boolean;
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormCreate(Sender: TObject);
    Procedure FormActivate(Sender: TObject);
    Procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    Procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure RestauraPosArqPsq;
    Procedure Memo1KeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure Memo1KeyUp(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure Memo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ModoTextoPopUpClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure CopiarTexto1Click(Sender: TObject);
  Public

    RFMHeader : PRFMHeader;
    DefaultRec: RRFMDefaults;
    RFMFrame :  RRFMFrame;
    RFMText  :  RRFMText;

    Lab1,
    Lab2,
    Filename : String;
    Arq,
    ArqSav : File;
    ArqPag32 : File Of Integer;
    ArqPag64 : File Of Int64;
    ArqPsq : TgArqPsq;
    ArqImp : System.Text;
    RegPsq : TgRegPsq;
    ArrBol : TgArrBol;
    Pagina64,
    Report133CC,
    Paleta,
    MarcaAtu,
    RelRemoto : Boolean;
    NextPag64,
    RegPag64 : Int64;
    RegPag32,
    NextPag32,
    Inicio,
    Paginas,
    Scroll1Min,
    Scroll1Max,
    Scroll1Pos,
    Scroll2Min,
    Scroll2Max,
    Scroll2Pos,
    PaginaAtu,
    Ocorre,
    DefaultX,
    DefaultY,
    FatorX,
    FatorY,
    ZoomLevel : Integer;
    Drive : Char;
    Video : TFont;
    pointStart: TPoint;
    pointEnd  : TPoint;
    bLeftDown : boolean;
    JJJ,
    EEE : Integer;
    ArrPag : Array[0..MaxLinhasPorPag] Of TgArrPag;

    Procedure DrawRubberband;
    Procedure InicializaFontes;
    Procedure CarregaImagem(Var Ind : Int64; Marca : Boolean; PagAtu : Integer);
    Procedure GetPaginaDoRel(Pagina : Integer; Var PaginaNormal, PaginaAcertada : String);

  End;

Var
  NomRede : Integer;
  EditForm : TEditForm;
  Buffer : Pointer;
  BufferA : ^TgArr20000 Absolute Buffer;
  BufIn : Pointer;
  PathCfg,
  Direct : ShortString;
  Cor : TColor;

Implementation

{$R *.DFM}

Uses MDIMultiCold, SysUtils, Messages, Scampo, LogInForm, AssisAbre;

Procedure TEditForm.GetPaginaDoRel(Pagina : Integer; Var PaginaNormal, PaginaAcertada : String);
Var
  J,
  Erro,
  Im,
  EEE,
  Ind,
  Inicio32,
  Fim32 : Integer;
  Inicio64,
  Fim64 : Int64;
  Apendix : String;
  RetVal : String;
  varPag : OleVariant;
  V : Variant;
  ComandoDeCarro,
  Teste : Char;
Begin
If RelRemoto Then
  Begin
  With FrameForm Do
    Begin
    RetVal := WebConnection1.AppServer.GetPagina(LogInRemotoForm.UsuEdit.Text,
                                                 LogInRemotoForm.PassEdit.Text,
                                                 ConnectionID,
                                                 Filename,
                                                 Pagina,
                                                 EEE,
                                                 varPag);

    V := VarArrayCreate([1,EEE], varByte);
    V := varPag;

    ReallocMem(BufIn,EEE); { Allocates only the space needed }
    ReallocMem(Buffer,EEE); // Temporariamente para a conversão.....

    For Im := 1 To EEE Do
      Byte(BufferA^[Im]) := V[Im];

    Move(BufferA^,BufIn^,EEE); { Moves only the buffer To decompress }
    ReallocMem(Buffer,0); { DeAllocates }
    DecompressBuf(BufIn,EEE,0,MDIEdit.Buffer,J);
    End;
  End
Else
  Begin
  If Pagina64 Then
    Begin
    Seek(ArqPag64,Pagina-1);
    Read(ArqPag64,Inicio64);
    {$i-}
    Read(ArqPag64,Fim64);
    {$i+}
    If IoResult <> 0 Then
      Fim64 := FileSize(Arq);
    End
  Else
    Begin
    Seek(ArqPag32,Pagina-1); // Usa Inicio32 apenas para o I/O
    Read(ArqPag32,Inicio32);
    Inicio64 := Inicio32;
    {$i-}
    Read(ArqPag32,Fim32);
    {$i+}
    If IoResult <> 0 Then
      Fim64 := FileSize(Arq)
    Else
      Fim64 := Fim32;
    End;

  If Pagina64 Then
    Seek(Arq,Inicio64+1) // Must consider the offset
  Else
    Seek(Arq,Inicio64);

  ReallocMem(BufIn,Fim64-Inicio64); { Allocates only the space needed }

  BlockRead(Arq,BufIn^,Fim64-Inicio64,Erro); { Read only the buffer To decompress }

  ReallocMem(Buffer,0); { DeAllocates }
  DecompressBuf(BufIn,Fim64-Inicio64,0,MDIEdit.Buffer,J);
  End;

PaginaAcertada := '';
PaginaNormal := '';

If Report133CC Then
  Begin
  Apendix := '';
  For Ind := 1 To J Do
    If (Byte(BufferA^[Ind]) And $80) = $80 Then
      Begin
      If Byte(BufferA^[Ind]) = $80 Then
        Teste := #$0
      Else
        Teste := #$80;
      Repeat
        PaginaAcertada := PaginaAcertada + ' ';
        PaginaNormal := PaginaNormal + ' ';      // Backup;
        Dec(BufferA^[Ind]);
      Until BufferA^[Ind] = Teste;
      End
    Else
      Begin
      If Ind = 1 Then
        BufferA^[Ind] := ' '
      Else
      If BufferA^[Ind-1] = #10 Then
        Begin
        PaginaAcertada := PaginaAcertada + Apendix;                    // Se colocou uma linha After
        Apendix := '';
        ComandoDeCarro := BufferA^[Ind];
        BufferA^[Ind] := ' ';
        If ComandoDeCarro = '0' Then
          PaginaAcertada := PaginaAcertada + CrLf
        Else
          If ComandoDeCarro = '-' Then
            Apendix := CrLf;
        End;
      If BufferA^[Ind] <> #0 Then
        Begin
        PaginaAcertada := PaginaAcertada + BufferA^[Ind];
        PaginaNormal := PaginaNormal + BufferA^[Ind];   // Backup sem comando de carro
        End;
      End;
  End
Else
  Begin
  For Ind := 1 To J Do
    If (Byte(BufferA^[Ind]) And $80) = $80 Then
      Begin
      If Byte(BufferA^[Ind]) = $80 Then
        Teste := #$0
      Else
        Teste := #$80;
      Repeat
        PaginaAcertada := PaginaAcertada + ' ';
        Dec(BufferA^[Ind]);
      Until BufferA^[Ind] = Teste;
      End
    Else
      If BufferA^[Ind] <> #0 Then
        PaginaAcertada := PaginaAcertada + BufferA^[Ind];
  End;
End;

Function TEditForm.Open(Const AFilename: ShortString; EhRemoto : Boolean) : Boolean;

Var
  I,
  J : Integer;
  I64 : Int64;
  XCampos : TStringList;
Begin
Screen.Cursor := crHourGlass;
Open := False;
Filename := AFilename;
Caption := ExtractFileName(FileName);

If EhRemoto Then
  Begin
  RelRemoto := True;
  Paginas := QtdPaginas;
  Report133CC := Boolean(Rel133);
  Pagina64 := Boolean(Rel64);

  XCampos := TStringList.Create;
  XCampos.Text := StrCampos;

  DefChave.RowCount := (XCampos.Count div 11) + 1;
  DefChave.ColCount := 12;
  I64 := 0;
  For I := 1 To DefChave.RowCount-1 Do
    For J := 1 To DefChave.ColCount-1 Do
      Begin
      DefChave.Cells[J,I] := XCampos[I64];
      Inc(I64);
      End;

  XCampos.Free;
  End
Else
  Begin
  RelRemoto := False;

  GetDir(0,Direct);

  Screen.Cursor := crHourGlass;

  FileMode := 0;
  AssignFile(Arq,FileName);
  {$i-}
  Reset(Arq,1);
  {$i+}
  I := IoResult;
  If (I <> 0) Then
    Begin
    ShowMessage('Relatório não pode ser aberto: '+FileName+' Falha '+IntToStr(I));
    Screen.Cursor := crDefault;
    Exit;
    End;

  If (Filesize(Arq) = 0) Then
    Begin
    ShowMessage('Relatório não pode ser aberto: '+FileName+' Arquivo Vazio');
    Screen.Cursor := crDefault;
    Exit;
    End;

  If Not DefReport.LeDfn(ChangeFileExt(FileName,'.DFN'),'M') Then
    Begin
    ShowMessage('Arquivo Dfn Inválido...');
    Screen.Cursor := crDefault;
    Exit;
    End;
  If Not DefReport.LeDfn(ChangeFileExt(FileName,'.DFN'),'M') Then     // Le duas vezes para garantir...
    Begin
    ShowMessage('Arquivo Dfn Inválido...');
    Screen.Cursor := crDefault;
    Exit;
    End;

  Report133CC := DefReport.Quebra133.Checked;

  DefChave.RowCount := DefReport.DefChave.RowCount;
  DefChave.ColCount := DefReport.DefChave.ColCount;
  For I := 0 To DefReport.DefChave.RowCount-1 Do
    For J := 0 To DefReport.DefChave.ColCount-1 Do
      DefChave.Cells[J,I] := DefReport.DefChave.Cells[J,I];    // Copia todas as definições lidas Do DFN

  Pagina64 := False;
  AssignFile(ArqPag32,ChangeFileExt(FileName,'.IAP'));
  {$i-}
  Reset(ArqPag32);
  {$i+}
  If (IoResult <> 0) Then
    Begin
    AssignFile(ArqPag64,ChangeFileExt(FileName,'.IAPS'));
    {$i-}
    Reset(ArqPag64);
    {$i+}
    If (IoResult <> 0) Or (Filesize(ArqPag64) = 0) Then
      Begin
      ShowMessage('Índice de página não pode ser aberto 2');
      Screen.Cursor := crDefault;
      Exit;
      End
    Else
      Begin
      Paginas := FileSize(ArqPag64);
      Pagina64 := True;
      End;
    End
  Else
    If (Filesize(ArqPag32) = 0) Then
      Begin
      ShowMessage('Índice de página não pode ser aberto');
      Screen.Cursor := crDefault;
      Exit;
      End
    Else
      Paginas := FileSize(ArqPag32); { número total de páginas Do relatório }
  End;

PaginaAtu := 2;              { a primeira é sempre 2 então força a quebra }

ScrollBox1.VertScrollBar.Position := 0;
ScrollBox1.HorzScrollBar.Position := 0;

Drive := 'C';

Inc(NomRede); // Esta atribuição força a existência de uma única instância Do Programa

AssignFile(ArqPsq,Drive+':\'+IntToStr(NomRede)+'.111');

If FileExists(Drive+':\'+IntToStr(NomRede)+'.111') Then
  Begin
  {$i-}
  Erase(ArqPsq);
  {$i+}
  If IoResult <> 0 Then
    Begin
    ShowMessage('ArqPsq não pode ser aberto, verifique se o programa já está sendo executado nesta máquina...');
    Screen.Cursor := crDefault;
    Exit;
    End;

  End;

{$i-}
ReWrite(ArqPsq);
{$i+}
If IoResult <> 0 Then
  Begin
  ShowMessage('ArqPsq não pode ser aberto');
  Screen.Cursor := crDefault;
  Exit;
  End;

If Not AbriuArqQue Then
  Begin
  QueryDlg.ScrollBar1.Min := 0;
  QueryDlg.ScrollBar1.Max := 0;
  QueryDlg.ScrollBar1.Position := 0;
  QueryDlg.LabelScrollQue.Caption := '0 de 0';

  AssignFile(ArqQue,Drive+':\'+IntToStr(NomRede)+'.555');
  {$i-}
  ReWrite(ArqQue);
  {$i+}
  If IoResult <> 0 Then
    Begin
    ShowMessage('Arquivo de Queries não pode ser aberto');
    Screen.Cursor := crDefault;
    Exit;
    End;
  AbriuArqQue := True;
  End;

AssignFile(ArqSav,Drive+':\'+IntToStr(NomRede)+'.777');
{$i-}
ReWrite(ArqSav,1);
{$i+}
If IoResult <> 0 Then
  Begin
  ShowMessage('Arquivo auxiliar não pode ser criado');
  Screen.Cursor := crDefault;
  Exit;
  End;

AssignFile(ArqImp,Drive + ':\'+IntToStr(NomRede) + '.888');
{$i-}
ReWrite(ArqImp);
{$i+}
If IoResult <> 0 Then
  Begin
  ShowMessage('Arquivo de Impressão não pode ser criado');
  Screen.Cursor := crDefault;
  Exit;
  End;

InicializaFontes;

Paleta := False;

Image1.Visible := False;

If EhRemoto Then
  I64 := 0
Else  
If Pagina64 Then
  Read(ArqPag64,I64)
Else
  Begin
  Read(ArqPag32,I);
  I64 := I;
  End;

CarregaImagem(I64,False,1);

//CarregaImagem(0,False,1);

Ocorre := 0;

Screen.Cursor := crDefault;

FileMode := 2;

Open := True;
End;

Procedure TEditForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin

ReallocMem(Buffer,0);

ReallocMem(BufIn,0);

{$i-}
CloseFile(Arq);
{$i+}
If IoResult = 0 Then;
{$i-}
CloseFile(ArqPag32);
{$i+}
If IoResult = 0 Then;
{$i-}
CloseFile(ArqPag64);
{$i+}
If IoResult = 0 Then;

{$i-}
CloseFile(ArqPsq);             // 111
{$i+}
If IoResult = 0 Then;
{$i-}
Erase(ArqPsq);
{$i+}
If IoResult = 0 Then;

{$i-}
CloseFile(ArqSav);             // 777
{$i+}
If IoResult = 0 Then;
{$i-}
Erase(ArqSav);
{$i+}
If IoResult = 0 Then;

{$i-}
CloseFile(ArqImp);             // 888
{$i+}
If IoResult = 0 Then;
{$i-}
Erase(ArqImp);
{$i+}
If IoResult = 0 Then;

If FrameForm.MDIChildCount = 1 Then // Todos são Nil, não sobrou relatório aberto
  Begin
  With FrameForm Do
    Begin
    ScrollBar1.Position := 0;
    ScrollBar1.Min := 0;
    ScrollBar1.Max := 0;
    ScrollBar2.Position := 0;
    ScrollBar2.Min := 0;
    ScrollBar2.Max := 0;
    Label1.Caption := '';
    Label2.Caption := '';
    EditPes.Text := '';
    EditPag.Text := '';

    Fechar1.Enabled := False;
    ConfigurarImpressora1.Enabled := Fechar1.Enabled;
    ConfigurarFonteDeImpresso1.Enabled := Fechar1.Enabled;
    ImprimirRelatrio1.Enabled := Fechar1.Enabled;
    DescompactarRelatrio1.Enabled := Fechar1.Enabled;
    ExportarRelatrio1.Enabled := Fechar1.Enabled;
    CopiarPgina1.Enabled := Fechar1.Enabled;
    AproximarZoom1.Enabled := Fechar1.Enabled;
    AfastarZoomOut1.Enabled := Fechar1.Enabled;
    Normal1001.Enabled := Fechar1.Enabled;
    ConfigurarFonteDeVdeo1.Enabled := Fechar1.Enabled;
    ConfigurarCorDoFundo1.Enabled := Fechar1.Enabled;
    ModoTexto1.Enabled := Fechar1.Enabled;
    CopiarTextoSelecionado1.Enabled := Fechar1.Enabled;
    MontarQueryFcil1.Enabled := Fechar1.Enabled;
    RepeteLtimaPesquisa1.Enabled := Fechar1.Enabled;
    Prxima1.Enabled := Fechar1.Enabled;
    Anterior1.Enabled := Fechar1.Enabled;
    Prxima2.Enabled := Fechar1.Enabled;
    Anterior2.Enabled := Fechar1.Enabled;
    Tile1.Enabled := Fechar1.Enabled;
    LadoALado1.Enabled := Fechar1.Enabled;
    Cascade1.Enabled := Fechar1.Enabled;
    ArrangeIcons1.Enabled := Fechar1.Enabled;
    End;

  Try
    FormGeral.TableDFN.Open;
    FormGeral.TableDFN.Close;
    If JaAbriu Then
      AssisAbreForm.Show
    Else
      FrameForm.AbrirAssistido1.Click;
  Except
    End; // Try

  End;

Action := caFree;
End;

Procedure TEditForm.InicializaFontes;

Var
  Arq : System.Text;
  ArqTam : File;
  Linha : TgStr255;
  X : Set Of TFontStyle;

Begin
Video := TFont.Create;
Printer.Canvas.Font.Name := 'Courier New'; { Assume valores Default }
Printer.Canvas.Font.Size := 8;
Printer.Canvas.Font.Style := [];
Video.Name := 'Courier New';
Video.Size := 8;
Video.Style := [];
Cor := clWhite;

PathCfg := IncludeTrailingBackSlash(Direct);
If Not FileExists(PathCfg+'Printer.Cfg') Then
  Begin
  PathCfg := Drive+':\COLDCFG\';

  If Not SetouPrivateDir Then
    Begin
    If UpperCase(Session.PrivateDir) <> UpperCase(Drive+':\ColdCfg') Then
      Session.PrivateDir := Drive+':\'; { Arquivos temporarios Do BDE }
    SetouPrivateDir := True;
    End;

  If Not FileExists(PathCfg+'Printer.Cfg') Then
    Begin
    {$i-}
    MkDir(Copy(PathCfg,1,Length(PathCfg)-1)); { Evita a última barra }
    {$i+}
    If IoResult <> 0 Then
      Begin
      End;
    End;
  End;

AssignFile(Arq,PathCfg+'Printer.Cfg');
AssignFile(ArqTam,PathCfg+'Printer.Cfg');

If FileExists(PathCfg+'Printer.Cfg') Then
  Begin
  {$i-}
  Reset(ArqTam,1);
  {$i+}
  If FileSize(ArqTam) = 0 Then
    Begin
    CloseFile(ArqTam);
    Erase(ArqTam);
    End
  Else
    CloseFile(ArqTam);
  End;

If FileExists(PathCfg+'Printer.Cfg') Then
  Begin
  Reset(Arq);
  ReadLn(Arq,Linha);
  Printer.Canvas.Font.Name := Linha;
  ReadLn(Arq,Linha);
  Printer.Canvas.Font.Size := StrToInt(Linha);
  ReadLn(Arq,Linha);
  Move(Linha[1],X,SizeOf(X));
  Printer.Canvas.Font.Style := X;
  CloseFile(Arq);
  End
Else
  Begin
  {$i-}
  Rewrite(Arq);
  {$i+}
  If IoResult = 0 Then
    Begin
    WriteLn(Arq,Printer.Canvas.Font.Name);
    WriteLn(Arq,Printer.Canvas.Font.Size);
    WriteLn(Arq,Chr(0));
    CloseFile(Arq);
    End;
  End;
AssignFile(Arq,PathCfg+'Video.Cfg');
AssignFile(ArqTam,PathCfg+'Video.Cfg');

If FileExists(PathCfg+'Video.Cfg') Then
  Begin
  {$i-}
  Reset(ArqTam,1);
  {$i+}
  If FileSize(ArqTam) = 0 Then
    Begin
    CloseFile(ArqTam);
    Erase(ArqTam);
    End
  Else
    CloseFile(ArqTam);
  End;

If FileExists(PathCfg+'Video.Cfg') Then
  Begin
  Reset(Arq);
  ReadLn(Arq,Linha);
  Video.Name := Linha;
  ReadLn(Arq,Linha);
  Video.Size := StrToInt(Linha);
  ReadLn(Arq,Linha);
  Move(Linha[1],X,SizeOf(X));
  Video.Style := X;
  CloseFile(Arq);
  End
Else
  Begin
  {$i-}
  Rewrite(Arq);
  {$i+}
  If IoResult = 0 Then
    Begin
    WriteLn(Arq,Video.Name);
    WriteLn(Arq,Video.Size);
    WriteLn(Arq,Chr(0));
    CloseFile(Arq);
    End;
  End;

AssignFile(Arq,PathCfg+'Color.Cfg');
AssignFile(ArqTam,PathCfg+'Color.Cfg');

If FileExists(PathCfg+'Color.Cfg') Then
  Begin
  {$i-}
  Reset(ArqTam,1);
  {$i+}
  If FileSize(ArqTam) = 0 Then
    Begin
    CloseFile(ArqTam);
    Erase(ArqTam);
    End
  Else
    CloseFile(ArqTam);
  End;

If FileExists(PathCfg+'Color.Cfg') Then
  Begin
  Reset(Arq);
  ReadLn(Arq,Linha);
  Cor := StrToInt(Linha);
  CloseFile(Arq);
  End
Else
  Begin
  {$i-}
  Rewrite(Arq);
  {$i+}
  If IoResult = 0 Then
    Begin
    WriteLn(Arq,Cor);
    CloseFile(Arq);
    End;
  End;
FrameForm.ColorDialog1.Color := Cor;
End;

Procedure TEditForm.CarregaImagem;

Var
  MaiorLinha,
  MaiorColuna,
  HOri,
  VOri,
  ILinha,
  ILinhaRel,
  PosAtu,
  Posic,
  Linha,
  I,
  TamOri,
  Inicio,
  SimNao : Integer;
  RetVal,
  PulAux,
  LinAux : String;
  Descarga,
  Marcou,
  MostraAlerta,
  EhPrimeiro : Boolean;
  Teste,
  ComandoDeCarro : Char;
  varPag : OleVariant;
  V : Variant;

  Procedure ComFundo;

  Begin
  ArrPag[ILinha].CorDaFonte := clBlack;
  ArrPag[ILinha].CorDeFundo := Cor;
  ArrPag[ILinha].TemPesquisa := False;
  End;

  Procedure SemFundo;

  Begin
  ArrPag[ILinha].CorDaFonte := clBlack;
  ArrPag[ILinha].CorDeFundo := clWhite;
  ArrPag[ILinha].TemPesquisa := False;
  End;

  Procedure ComPesquisa;

  Begin
  ArrPag[ILinha].CorDaFonte := clWhite;
  ArrPag[ILinha].CorDeFundo := clNavy;
  ArrPag[ILinha].TemPesquisa := True;
  End;

  Procedure VerifyBefore;

  Begin
  If Report133CC Then
    Begin
    ComandoDeCarro := ' ';
    If Length(LinAux) = 0 Then
      Exit;
    ComandoDeCarro := LinAux[1];
    LinAux[1] := ' ';
      If ComandoDeCarro = '0' Then
        Begin
        SimNao := SimNao Xor 1;  // Manter a ordem Do zebrado
        If SimNao = 0 Then
          ComFundo
        Else
          SemFundo;
        ArrPag[ILinha].LinhaRel := PulAux;

        WriteLn(ArqImp,PulAux);

        Inc(ILinha);
        End;
    End;
  End;

  Procedure VerifyAfter;

  Begin
  If Length(LinAux) = 0 Then
    Exit;
  If Report133CC Then
    If ComandoDeCarro = '-' Then  { Pula Uma Linha AFTER}
      Begin
      Inc(ILinha);
      SimNao := SimNao Xor 1;  // Manter a ordem Do zebrado
      If SimNao = 0 Then
        ComFundo
      Else
        SemFundo;
      ArrPag[ILinha].LinhaRel := PulAux;
      WriteLn(ArqImp,PulAux);
      End;
  End;

Begin

 { Inicializa variáveis, Memos e imagens }

SetLength(PulAux,133);
FillChar(PulAux[1], 133, ' ');
For ILinha := 0 To MaxLinhasPorPag Do
  Begin
  SemFundo;
  ArrPag[ILinha].TemPesquisa := False;
  ArrPag[ILinha].LinhaRel := '';
  End;
ILinha := 0; // Primeira Linha Do relatório é a 0
ILinhaRel := 0; // Linha Do Relatório armazenado -> não leva em consideração os pulos de carro

If Marca Then
  Begin               // Aqui podemos usar o campo linha em vez deste cálculo de posição relativa Do campo pesquisado
  FillChar(ArrBol,SizeOf(ArrBol),0);
  If RelRemoto Then
    Begin
    If ClientDataSet1.Active Then
      Begin
      ClientDataSet1.First;
      ClientDataSet1.MoveBy(RegPsq.PosQuery-1);
      While ClientDataSet1.Fields[1].AsInteger = PagAtu Do
        Begin
        Posic := 3;
        While Posic <= ClientDataSet1.FieldCount Do
          Begin
          ArrBol[ClientDataSet1.Fields[Posic].AsInteger-1] := True;   // Field = Linha, aqui começa em 0
          Inc(Posic,5);     { Cada Campo de pesquisa gera 5 campos }
          End;
        If ClientDataSet1.EOF Then
          Break;
        ClientDataSet1.Next;
        End;
      End;
    End
  Else
    If Query1.Active Then
      Begin
      Query1.First;
      Query1.MoveBy(RegPsq.PosQuery-1);
      While Query1.Fields[1].AsInteger = PagAtu Do
        Begin
        Posic := 3;
        While Posic <= Query1.FieldCount Do
          Begin
          ArrBol[Query1.Fields[Posic].AsInteger-1] := True;   // Field = Linha, aqui começa em 0
          Inc(Posic,5);     { Cada Campo de pesquisa gera 5 campos }
          End;
        If Query1.EOF Then
          Break;
        Query1.Next;
        End;
      End;
  End;

MarcaAtu := Marca;
If PagAtu <> PaginaAtu Then
  Begin
  PaginaAtu := PagAtu;

  If RelRemoto Then
    Begin
    With FrameForm Do
      Begin
//      DComConnection1.Connected := False;
//      DComConnection1.Connected := True;
      RetVal := WebConnection1.AppServer.GetPagina(LogInRemotoForm.UsuEdit.Text,
                                                   LogInRemotoForm.PassEdit.Text,
                                                   ConnectionID,
                                                   Filename,
                                                   PagAtu,
                                                   EEE,
                                                   varPag);

//      DComConnection1.Connected := False;
      V := VarArrayCreate([1,EEE], varByte);
      V := varPag;

      ReallocMem(BufIn,EEE); { Allocates only the space needed }
      ReallocMem(Buffer,EEE); // Temporariamente para a conversão.....

      For I := 1 to EEE Do
        Byte(BufferA^[I]) := V[I];

      Move(BufferA^,BufIn^,EEE); { Moves only the buffer To decompress }

      ReallocMem(Buffer,0); { DeAllocates }

      DecompressBuf(BufIn,EEE,0,Buffer,JJJ);

      End;
    End
  Else
    Begin
    If Pagina64 Then
      Begin
      PosAtu := FilePos(ArqPag64) - 1;
      Seek(ArqPag64,PagAtu - 1);
      Read(ArqPag64,NextPag64);
      {$i-}
      Read(ArqPag64,NextPag64);
      {$i+}
      If IoResult <> 0 Then
        NextPag64 := FileSize(Arq);
      Seek(ArqPag64,PosAtu);        { Back To the same place }
      End
    Else
      Begin
      PosAtu := FilePos(ArqPag32) - 1;
      Seek(ArqPag32,PagAtu - 1);
      Read(ArqPag32,NextPag32);
      {$i-}
      Read(ArqPag32,NextPag32);
      {$i+}
      If IoResult <> 0 Then
        NextPag64 := FileSize(Arq)
      Else
        NextPag64 := NextPag32;
      Seek(ArqPag32,PosAtu);        { Back To the same place }
      End;

    If Pagina64 Then
      Seek(Arq,Ind + 1) // 1 = OffSet do primeiro byte
    Else
      Seek(Arq,Ind);

    ReallocMem(BufIn,NextPag64-Ind); { Allocates only the space needed }

    BlockRead(Arq,BufIn^,NextPag64-Ind,EEE); { Read only the buffer To decompress }

    ReallocMem(Buffer,0); { DeAllocates }

    DecompressBuf(BufIn,NextPag64-Ind,0,Buffer,JJJ);

    Seek(Arq,Ind);   // Volta o cursor do arquivo para o lugar original
    End;

  ReWrite(ArqSav,1);
  BlockWrite(ArqSav,Buffer^,JJJ,EEE);
  ReWrite(ArqImp);
  Descarga := True;
  End
Else
  Begin
  Reset(ArqSav,1);
  ReallocMem(Buffer,JJJ);   // Ajusta o tamanho Do buffer de memória para a leitura
  BlockRead(ArqSav,Buffer^,JJJ,EEE);
  Descarga := False;
  ReWrite(ArqImp);
  End;

I := 0;
LinAux := '';
Marcou := false;
MostraAlerta := True;
SimNao := 0;
Repeat
  Inc(I);

  If BufferA^[I] = #13 Then
    Begin

    VerifyBefore;

    If Marca Then
      Begin

      If ArrBol[ILinhaRel] Then
        Marcou := True;

      SimNao := SimNao Xor 1;  // Manter a ordem Do zebrado

      If Marcou Then
        ComPesquisa
      Else
        If SimNao = 0 Then
          Begin
          ComFundo;
          If Length(LinAux) < 133 Then
            Begin
            TamOri := Length(LinAux);
            SetLength(LinAux,133);
            FillChar(LinAux[TamOri+1],133-TamOri,' ');
            End;
          End
        Else
          SemFundo;

      ArrPag[ILinha].LinhaRel := LinAux;
      End
    Else
      Begin

      SimNao := SimNao Xor 1;
      If SimNao = 0 Then
        ComFundo
      Else
        SemFundo;

      If Length(LinAux) < 133 Then
        Begin
        TamOri := Length(LinAux);
        SetLength(LinAux,133);
        FillChar(LinAux[TamOri+1],133-TamOri,' ');
        End;

      ArrPag[ILinha].LinhaRel := LinAux;

      End;

    If Marcou Then
      WriteLn(ArqImp,Chr(1)+LinAux)
    Else
      WriteLn(ArqImp,LinAux);

      VerifyAfter;

    LinAux := '';
    Marcou := False;
    End
  Else
    If BufferA^[I] = #10 Then
      Begin
      Inc(ILinha);
      Inc(ILinhaRel);
      If ILinha = MaxLinhasPorPag + 1 Then
        Begin
        If MostraAlerta Then // Dar a mensagem apenas uma vez para o usuário
          Begin
          ShowMessage('Página excedeu o limite de 500 linhas, descartando excesso...');
          MostraAlerta := False;
          End;
        Dec(ILinha);
        Dec(ILinhaRel);
        End;
      End
    Else
      If (Byte(BufferA^[I]) And $80) = $80 Then
        Begin
        If Byte(BufferA^[I]) = $80 Then
          Begin
          Inc(I);
          Teste := #$0;
          End
        Else
          Teste := #$80;
        Repeat
          LinAux := LinAux + ' ';
          Dec(BufferA^[I]);
        Until BufferA^[I] = Teste;
        End
      Else
        If BufferA^[I] <> #0 Then
          LinAux := LinAux + BufferA^[I];

Until I >= (JJJ-1);
If Descarga Then
  CloseFile(ArqImp);

If Not MostraAlerta Then // Estourou as 500 linhas máximas
  Dec(ILinha); // Para não mostrar a última linha que vira a última da página quando há o estouro

If Memo1.Visible Then
  Begin
  Memo1.Clear;
  Memo1.Font := Video;
  Memo1.Visible := False;
  Memo1.Font.Size := Memo1.Font.Size + ZoomLevel;

  Inicio := 1;
  EhPrimeiro := True;
  For I := 0 To ILinha Do
    Begin
    If ArrPag[I].CorDaFonte = clWhite Then
      ArrPag[I].CorDaFonte := clRed;
    Memo1.SelAttributes.Color := ArrPag[I].CorDaFonte;
    Memo1.Lines.Add(ArrPag[I].LinhaRel);
    If EhPrimeiro Then
      Begin
      Inicio := Inicio + Length(Memo1.Lines[I]);
      If ArrPag[I].TemPesquisa Then
        EhPrimeiro := False;
      End;
    End;
  Memo1.Visible := True;
  Memo1.SetFocus;
  If Not EhPrimeiro Then             // Houve um registro de pesquisa marcado
    Memo1.SelStart := Inicio
  Else
    Memo1.SelStart := 0;
  End
Else
  Begin
  HOri := ScrollBox1.HorzScrollBar.Position;
  VOri := ScrollBox1.VertScrollBar.Position;

//  RFMImage1.ClearFields;
  Try
    RFMImage1.Clear;
  Except
    ShowMessage('Impossível executar o método Clear');
    Exit;
    End; //Try

  RFMImage1.PaperSize := rfmA3;

  RFMHeader := PRFMHeader(RFMImage1.RFM.RFMFile[0]);
  RFMHeader.PaperSize := rfmA3;
  RFMHeader.Orientation := rfmPortrait;
  RFMHeader.Width:= RFMPapers[ord(RFMHeader.PaperSize)].Width_Pixels;
  RFMHeader.Height:= RFMPapers[ord(RFMHeader.PaperSize)].Height_Pixels;

  EhPrimeiro := True;
  MaiorLinha := 0;
  MaiorColuna := 0;
  Image1.Canvas.Font := Video;
  Image1.Width := RFMHeader.Width;
  Image1.Height := RFMHeader.Height;

  RFMImage1.BeginUpdate;

  For I := 0 To ILinha Do
    Begin

    FillChar(RFMText, sizeof(RFMText),0);
    RFMText.Color := ArrPag[I].CorDaFonte;
    RFMText.FontName := Video.Name;
    RFMText.FontStyle := Video.Style;
    RFMText.FontSize := Video.Size;
    RFMText.AutoSize := False;
    RFMText.Left := 0;
    RFMText.Top := (Abs(Video.Height))*I;
    RFMText.Width := RFMHeader.Width-4;
    RFMText.Height := Abs(Video.Height);
    RFMText.Text := ArrPag[I].LinhaRel;

    If ArrPag[I].CorDeFundo <> clWhite Then
      Begin
      FillChar(RFMFrame, sizeof(RFMFrame),0);
      RFMFrame.Width := RFMHeader.Width-4;
      RFMFrame.Height := Abs(Video.Height)+2;
      RFMFrame.PStyle := rfmPSolid;                      //DefaultRec.DEFFrame.PStyle;
      RFMFrame.FStyle := rfmFSolid;                      //DefaultRec.DEFFrame.FStyle;
      RFMFrame.FColor := ArrPag[I].CorDeFundo;           //DefaultRec.DEFFrame.FColor;
      RFMFrame.Color := ArrPag[I].CorDeFundo;            //DefaultRec.DEFFrame.Color;
      RFMFrame.Thick := 1;                               //DefaultRec.DEFFrame.Thick;
      RFMFrame.Corner := DefaultRec.DEFFrame.Corner;
      RFMFrame.Left := 0;
      RFMFrame.Top := RFMText.Top;
      RFMImage1.RFM.RFMFile.Frame.Add(RFMFrame);
      End;

    If ArrPag[I].CorDaFonte = clWhite Then        // Linha com pesquisa
      Begin
      FillChar(RFMFrame, sizeof(RFMFrame),0);
      RFMFrame.Width := RFMHeader.Width-4;
      RFMFrame.Height := Abs(Video.Height)+2;
      RFMFrame.PStyle := rfmPSolid;                      //DefaultRec.DEFFrame.PStyle;
      RFMFrame.FStyle := rfmFSolid;                      //DefaultRec.DEFFrame.FStyle;
      RFMFrame.FColor := ArrPag[I].CorDeFundo;           //DefaultRec.DEFFrame.FColor;
      RFMFrame.Color := ArrPag[I].CorDeFundo;            //DefaultRec.DEFFrame.Color;
      RFMFrame.Thick := 1;                               //DefaultRec.DEFFrame.Thick;
      RFMFrame.Corner := DefaultRec.DEFFrame.Corner;
      RFMFrame.Left := 0;
      RFMFrame.Top := RFMText.Top;
      RFMImage1.RFM.RFMFile.Frame.Add(RFMFrame);
      End;

    RFMImage1.RFM.RFMFile.Text.Add(RFMText);

    If Image1.Canvas.TextWidth(ArrPag[I].LinhaRel) > MaiorLinha Then
      MaiorLinha := Image1.Canvas.TextWidth(ArrPag[I].LinhaRel);
    MaiorColuna := RFMText.Top + Abs(Video.Height);

    End;
  RFMImage1.EndUpdate;

  RFMHeader.Width:= MaiorLinha;      // Reconstroi a página Do tamanho exato para acomodar as linhas e colunas
  RFMHeader.Height:= MaiorColuna;

  DefaultX := RFMHeader.Width;
  DefaultY := RFMHeader.Height;
  FatorX := DefaultX div 40;
  FatorY := DefaultY div 40;

  ScrollBox1.HorzScrollBar.Range := DefaultX+FatorX;              // Scroll Horizontal
  ScrollBox1.HorzScrollBar.Increment := FatorX;
  ScrollBox1.HorzScrollBar.Position := HOri;

  ScrollBox1.VertScrollBar.Range := DefaultY+FatorY;
  ScrollBox1.VertScrollBar.Increment := FatorY;
  ScrollBox1.VertScrollBar.Position := VOri;

  RFMImage1.DisplayOptions:= [rfmAutoSize];
  RFMImage1.Refresh;

  If ZoomLevel <> 0 Then
    Begin
    RFMImage1.DisplayOptions:= [rfmScale, rfmCenter];
    RFMImage1.Width := RFMImage1.Width + FatorX*ZoomLevel;
    RFMImage1.Height := RFMImage1.Height + FatorY*ZoomLevel;
    ScrollBox1.HorzScrollBar.Range := RFMImage1.Width+FatorX;
    ScrollBox1.VertScrollBar.Range := RFMImage1.Height+FatorY;
    End;

//  RFMImage1.SaveToFile('c:\RFM133.rfm');

  Linha := 100;  // Para puxar a uma região mais alta
  For I := 0 To ILinha Do
    Begin
    If EhPrimeiro Then
      If ArrPag[I].TemPesquisa Then
        Begin
        ScrollBox1.VertScrollBar.Position := 0;
        If Linha > ScrollBox1.Height Then
          ScrollBox1.VertScrollBar.Position := Linha;
        EhPrimeiro := False;
        End;
    Inc(Linha,Abs(Video.Height));
    End;

  ScrollBox1.HorzScrollBar.Visible:= true;
  ScrollBox1.VertScrollBar.Visible:= true;

  End;
End;

Procedure TEditForm.FormCreate(Sender: TObject);
Begin
WindowState := wsMaximized;
SCrollBox1.Align := alClient;
Memo1.Clear;
Memo1.Align := alClient;
Memo1.Visible := False;
ZoomLevel := 0;
End;

Procedure TEditForm.FormActivate(Sender: TObject);
Var
  I : Integer;
Begin
FrameForm.ScrollBar1.Min := Scroll1Min;
FrameForm.ScrollBar1.Max := Scroll1Max;
FrameForm.ScrollBar1.Position := Scroll1Pos;
FrameForm.Label1.Caption := Lab1;
FrameForm.ScrollBar2.Min := Scroll2Min;
FrameForm.ScrollBar2.Max := Scroll2Max;
FrameForm.ScrollBar2.Position := Scroll2Pos;
FrameForm.Label2.Caption := Lab2;

With SelCampo.Campos Do
  Begin
  For I := 1 To DefChave.RowCount+1 Do
    Begin
    Cells[0,I] := IntToStr(I);
    Cells[1,I] := DefChave.Cells[6,I];
    Cells[2,I] := DefChave.Cells[7,I];
    Cells[3,I] := DefChave.Cells[3,I];
    End;
  Cells[1,0] := 'Campo';
  Cells[2,0] := 'Tipo';
  Cells[3,0] := 'Col';
  End;

End;

Procedure TEditForm.DrawRubberband;
Begin
//SetROP2(Image1.Canvas.handle, R2_NOT);
//Image1.Canvas.moveto(pointStart.x, pointStart.y);
//Image1.Canvas.lineto(pointStart.x, pointEnd.y);
//Image1.Canvas.lineto(pointEnd.x, pointEnd.y);
//Image1.Canvas.lineto(pointEnd.x, pointStart.y);
//Image1.Canvas.lineto(pointStart.x, pointStart.y);
End;

Procedure TEditForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
bLeftDown := false;
If Button = mbLeft Then
  Begin
  bLeftDown := true;
  pointStart.X := X;
  pointStart.Y := Y;
  pointEnd.X := X;
  pointEnd.Y := Y;
  End
Else
If Button = mbRight Then
  Begin
  End;
End;

Procedure TEditForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Begin
If Not bLeftDown Then
  exit;
DrawRubberband;
pointEnd.x := X;
pointEnd.y := Y;
DrawRubberband;
End;

Procedure TEditForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Begin
If Not bLeftDown Then
  exit;

If pointStart.X = X Then
  Begin
  bLeftDown := false;
  Exit;
  End;

DrawRubberband;
bLeftDown := false;
pointEnd.X := X;
pointEnd.Y := Y;

Screen.Cursor := crHourGlass;

Screen.Cursor := crDefault;
End;

Procedure TEditForm.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
If (ssCtrl In Shift) Then
  Case Key Of
    VK_LEFT  : ScrollBox1.HorzScrollBar.Position := 0;
    VK_RIGHT : ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Range;
    VK_UP    : ScrollBox1.VertScrollBar.Position := 0;
    VK_DOWN  : ScrollBox1.VertScrollBar.Position := ScrollBox1.HorzScrollBar.Range;
    End   {Case}
Else
If (ssShift In Shift) Then
  Case Key Of
    VK_RIGHT : ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position +
               (ScrollBox1.HorzScrollBar.Increment*2);
    VK_LEFT  : If (ScrollBox1.HorzScrollBar.Position - (ScrollBox1.HorzScrollBar.Increment*2)) < 0 Then
                 ScrollBox1.HorzScrollBar.Position := 0
               Else
                 ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position -
                                                      (ScrollBox1.HorzScrollBar.Increment*2);
    VK_DOWN  : ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position +
               (ScrollBox1.VertScrollBar.Increment*2);
    VK_UP    : If (ScrollBox1.VertScrollBar.Position - (ScrollBox1.VertScrollBar.Increment*2)) < 0 Then
                 ScrollBox1.VertScrollBar.Position := 0
               Else
                 ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position -
                                                      (ScrollBox1.VertScrollBar.Increment*2);
    End {Case}
Else
  Case Key Of
    VK_RIGHT : ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position +
               ScrollBox1.HorzScrollBar.Increment;
    VK_LEFT  : If (ScrollBox1.HorzScrollBar.Position - ScrollBox1.HorzScrollBar.Increment) < 0 Then
                 ScrollBox1.HorzScrollBar.Position := 0
               Else
                 ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position -
                                                      ScrollBox1.HorzScrollBar.Increment;
    VK_DOWN  : ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position +
               ScrollBox1.VertScrollBar.Increment;
    VK_UP    : If (ScrollBox1.VertScrollBar.Position - ScrollBox1.VertScrollBar.Increment) < 0 Then
                 ScrollBox1.VertScrollBar.Position := 0
               Else
                 ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position -
                                                      ScrollBox1.VertScrollBar.Increment;
    End; {Case}
End;

Procedure TEditForm.RestauraPosArqPsq;
Begin
Seek(ArqPsq,FrameForm.ScrollBar1.Position);
{$i-}
Read(ArqPsq,RegPsq);
{$i+}
If IoResult <> 0 Then
  Begin
  ShowMessage('Erro de Seek Prn');
  Halt;
  End;

If RelRemoto Then
  Begin
  ClientDataSet1.First;
  ClientDataSet1.MoveBy(RegPsq.PosQuery-1);
  End
Else
  Begin
  Query1.First;
  Query1.MoveBy(RegPsq.PosQuery-1);

  If Pagina64 Then
    Begin
    Seek(ArqPag64,Query1.Fields[1].AsInteger - 1);  { inicia de 0 }
    Read(ArqPag64,RegPag64);
    End
  Else
    Begin
    Seek(ArqPag32,Query1.Fields[1].AsInteger - 1);  { inicia de 0 }
    Read(ArqPag32,RegPag32);
    RegPag64 := RegPag32;
    End;
  End;
End;

Procedure TEditForm.Memo1KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : String;
Begin
Posic := Memo1.SelStart;
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
For I := 1 To Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
FrameForm.Label3.Caption := IntToStr(Lin) + ': ' + IntToStr(Col);
End;

Procedure TEditForm.Memo1KeyUp(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : String;
Begin
Posic := Memo1.SelStart;
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
For I := 1 To Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
FrameForm.Label3.Caption := IntToStr(Lin) + ': ' + IntToStr(Col);
End;

Procedure TEditForm.Memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : String;
Begin
Posic := Memo1.SelStart;
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
For I := 1 To Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
FrameForm.Label3.Caption := IntToStr(Lin) + ': ' + IntToStr(Col);
End;

Procedure TEditForm.Memo1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : String;
Begin
Posic := Memo1.SelStart;
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
For I := 1 To Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
FrameForm.Label3.Caption := IntToStr(Lin) + ': ' + IntToStr(Col);
End;

Procedure TEditForm.ModoTextoPopUpClick(Sender: TObject);
Begin
FrameForm.ModoTexto1.Click;
End;

Procedure TEditForm.Copy2Click(Sender: TObject);
Begin
FrameForm.CopiarPgina1.Click;
End;

Procedure TEditForm.CopiarTexto1Click(Sender: TObject);
Begin
FrameForm.CopiarTextoSelecionado1.Click;
End;

End.

