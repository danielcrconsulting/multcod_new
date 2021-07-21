Unit MDIEdit;

Interface

Uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Printers,
  Dialogs, Menus, Clipbrd, StdCtrls, GridQue, Grids, Analisador, SuTypGer,
  ExtCtrls, Buttons, SuGeral, DB, AvisoI, Zlib,
  ComCtrls, DBClient, dfcontrols, dfclasses, Variants, OleCtrls, SHDocVw,
  AnotaTextoU, GraphWin, ADODB, dfPdf, SOAPConn, IMulticoldServer1, MIDASLIB, DBTables;
//  adsdata, adsfunc, adstable, adscnnct;

Type
  TEditForm = Class(TForm)
    MemoPopUp: TPopupMenu;
    Copy2: TMenuItem;
    ModoTextoPopUp: TMenuItem;
    CopiarTexto1: TMenuItem;
    ComFormulrio2: TMenuItem;
    PopupMenu1: TPopupMenu;
    ComFormulrio1: TMenuItem;
    DFEngine1: TDFEngine;
    PrintPageBMP1: TMenuItem;
    PrintDialog1: TPrintDialog;
    DefChave: TStringGrid;
    Memo1: TRichEdit;
    ClientDataSet1: TClientDataSet;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Image2: TImage;
    DFActiveDisplay1: TDFActiveDisplay;
    Query1: TQuery;
    qryPolonesa1: TQuery;
    qryPolonesa2: TQuery;
//    AdsConnection1: TAdsConnection;
    Function Open(Const AFilename: AnsiString; EhRemoto : Boolean) : Boolean;
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormCreate(Sender: TObject);
    Procedure FormActivate(Sender: TObject);
    Procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
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
    Procedure ModoTextoPopUpClick(Sender: TObject);
    Procedure Copy2Click(Sender: TObject);
    Procedure CopiarTexto1Click(Sender: TObject);
    Procedure ComFormulrio1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PrintPage(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure PrintPageBMP1Click(Sender: TObject);
    procedure DFActiveDisplay1Click(Sender: TObject);

  Public

    LastScale: TObject;
    Lab1,
    Lab2,
    Filename : AnsiString;
    Arq,
    ArqSav : File;
    ArqPag32 : File Of Integer;
    ArqPag64 : File Of Int64;
    ArqPsq : TgArqPsq;
    ArqImp : System.Text;
    RegPsq : TgRegPsq;
    ArrBol : TgArrBol;
    temPesquisa,
//    Pagina64,
    Report133CC,
    ComprimeBrancos,
    Paleta,
    MarcaAtu,
    RelRemoto,
    TemAnotacaoGrafica,
    TemAnotacaoDeTexto,
    FezAnotacoesGraficas,
    FezAnotacoesDeTexto,
    Drawing : Boolean;
    DrawingTool: TDrawingTool;
    Origin, MovePt,
    pointStart,
    pointEnd  : TPoint;
    NextPag64,
    RegPag64 : Int64;
    RegPag32,
    NextPag32,
    //Inicio,
    Paginas,
    Scroll1Min,
    Scroll1Max,
    Scroll1Pos,
    Scroll2Min,
    Scroll2Max,
    Scroll2Pos,
    PaginaAtu,
    Ocorre,
    ZoomLevel,
    ILinha : Integer;
    PaginaAcertada,
    PaginaNormal : AnsiString; // 17/05/2013
    Drive : String;
    Video : TFont;
    Mascara,
    bLeftDown,
    EhPrimeiro : Boolean;
    JJJ,
    EEE : Integer;
    ArrPag : TgPagMultiCold; // Array[0..MaxLinhasPorPag] Of TgArrPag;
    StrPagina : TStringList;
    ArrBloqCamposDoRel : ArrayOfTgArrBloqCampos;
    Pdf : TDF6toPDFConverter;
    gridQueryFacil : Array of TPesquisa;

    AnotaForm : TAnotaForm;
    AnotaTextoForm : TAnotaTextoForm;

    Procedure InicializaFontes;

    Procedure TrataImage2(Linha, Coluna : Integer);
    Function TrataBloqueio(Entra : AnsiString; Linha : Integer) : AnsiString;
    Procedure FastImageReload;
    Procedure VerificaAnotacao;
    Procedure LoadImage2;

    Procedure CarregaImagem(Marca : Boolean; PagAtu : Integer);

    Procedure Decripta(Var Buffer : Pointer; Report133CC, Orig : Boolean;
                       QtdBytes : Integer);

    Procedure GetPaginaDoRel(Pagina : Integer; Orig : Boolean);

    procedure DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
    procedure PrintPageBMP;

  End;

Var
  NomRede : Integer;
  Buffer : Pointer;
  BufferA : ^TgArr20000 Absolute Buffer;
  auxPag : AnsiString;
  PathCfg,
  Direct : AnsiString;
  Cor : TColor;

Implementation

{$R *.DFM}

Uses MDIMultiCold, SysUtils, Messages, Scampo, LogInForm, AssisAbre, Subrug,
  AssisAbreRemoto;

Procedure TEditForm.Decripta(Var Buffer : Pointer; Report133CC, Orig : Boolean;
                             QtdBytes : Integer);
Var
  I, Ind : Integer;
  BufferA : ^TgArr20000 Absolute Buffer;
  Apendix : AnsiString;
  ComandoDeCarro,
  AuxTemp,
  Teste : AnsiChar;           //17/05/2013
Begin
SetLength(PaginaAcertada,10000);
SetLength(PaginaNormal,10000);
I := 1;

If Report133CC Then
  Begin
  For Ind := 1 To QtdBytes Do
    If ComprimeBrancos Then
      Begin
      If (Byte(BufferA^[Ind]) And $80) = $80 Then
        Begin
        AuxTemp := BufferA^[Ind];
        If Byte(BufferA^[Ind]) = $80 Then
          Teste := #$0
        Else
          Teste := #$80;
        Repeat
          PaginaNormal[I] := ' ';
          Inc(I);
          If I > Length(PaginaNormal) Then
            SetLength(PaginaNormal,Length(PaginaNormal)+10000);
          Dec(AuxTemp);
        Until AuxTemp = Teste;
        End
      Else
        Begin
        PaginaNormal[I] := (BufferA^[Ind]);
        Inc(I);
        If I > Length(PaginaNormal) Then
          SetLength(PaginaNormal,Length(PaginaNormal)+10000);
        End;
      End
    Else
      Begin
      PaginaNormal[I] := (BufferA^[Ind]);
      Inc(I);
      If I > Length(PaginaNormal) Then
        SetLength(PaginaNormal,Length(PaginaNormal)+10000);
      End;
  SetLength(PaginaNormal,I-1); // Ajusta o tamanho certo
  If Orig Then
    PaginaAcertada := PaginaNormal
  Else
    Begin
    Apendix := '';
    PaginaAcertada[1] := ' ';
    I := 2;
    For Ind := 2 To Length(PaginaNormal) Do
//      If PaginaNormal[Ind-1] = #10 Then
      If (PaginaNormal[Ind-1] = #10) And (PaginaNormal[Ind] <> #13) Then // É Comando de carro, vai tratar...
        Begin
        If Apendix <> '' Then
          Begin
          PaginaAcertada[I] := #13;
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          PaginaAcertada[I] := #10;
          Inc(I);                 // := PaginaAcertada + Apendix; // Se colocou uma linha After
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End;
        Apendix := '';
        ComandoDeCarro := PaginaNormal[Ind];
        If ComandoDeCarro = '0' Then
          Begin
          PaginaAcertada[I] := #13;
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          PaginaAcertada[I] := #10;
          Inc(I);                 // Uma Linha Before
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End
        Else
          If ComandoDeCarro = '-' Then
            Apendix := CrLf;
        PaginaAcertada[I] := ' ';
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End
      Else
        Begin
        PaginaAcertada[I] := PaginaNormal[Ind];
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End;
    SetLength(PaginaAcertada,I-1); // Ajusta
    End;
  End
Else
  Begin
  For Ind := 1 To QtdBytes Do
    If ComprimeBrancos Then
      Begin
      If (Byte(BufferA^[Ind]) And $80) = $80 Then
        Begin
        AuxTemp := BufferA^[Ind];
        If Byte(BufferA^[Ind]) = $80 Then
          Teste := #$0
        Else
          Teste := #$80;
        Repeat
          PaginaAcertada[I] := ' ';
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          Dec(AuxTemp);
        Until AuxTemp = Teste;
        End
      Else
        Begin
        PaginaAcertada[I] := BufferA^[Ind];
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End;
      End
    Else
      Begin
      PaginaAcertada[I] := BufferA^[Ind];
      Inc(I);
      If I > Length(PaginaAcertada) Then
        SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
      End;

  SetLength(PaginaAcertada,I-1); // Ajusta o tamanho
  PaginaNormal := PaginaAcertada;
  End;
End;

procedure TEditForm.DFActiveDisplay1Click(Sender: TObject);
begin

end;

//Procedure TEditForm.GetPaginaDoRel(Pagina : Integer; Var PaginaNormal, PaginaAcertada : AnsiString; Orig : Boolean);
Procedure TEditForm.GetPaginaDoRel(Pagina : Integer; Orig : Boolean);
Var
  FileHandle,
  QtdBytesPagRel,
  Erro,
  Im,
  EEE,
  Inicio32,
  Fim32 : Integer;
  Integer64,
  Inicio64,
  Fim64 : Int64;
  RetVal : AnsiString;
  varPag : WideString;
//  varPag : Variant;
  V : Variant;
Begin
If RelRemoto Then
  Begin
  With FrameForm Do
    Begin
    //RetVal := WebConnection1.AppServer.GetPagina(LogInRemotoForm.UsuEdit.Text,
    //                                             LogInRemotoForm.PassEdit.Text,
    //                                             ConnectionID,
    //                                             Filename,
    //                                             Pagina,
    //                                             EEE,
    //                                             varPag);

    //RetVal := (formGeral.HTTPRIO1 as MulticoldServer).GetPagina(ws, ws, i, ws, i, i, v);


    RetVal := (formGeral.HTTPRIO1 as IMulticoldServer).GetPagina(LogInRemotoForm.UsuEdit.Text,
                                                 LogInRemotoForm.PassEdit.Text,
                                                 ConnectionID,
                                                 Filename,
                                                 Pagina,
                                                 EEE,
                                                 varPag);

    ReallocMem(BufI,EEE div 2); { Allocates only the space needed }
    ReallocMem(Buffer,EEE div 2); // Temporariamente para a conversão.....

    auxPag := varPag;
    hexToBin(PAnsiChar(auxPag), PAnsiChar(BufferA), EEE div 2);

    Move(BufferA^,BufI^,EEE div 2); { Moves only the buffer To decompress }

//    V := VarArrayCreate([1,EEE], varByte);
//    V := varPag;

//    For Im := 1 To EEE Do
//      Byte(BufferA^[Im]) := V[Im-1];

//    Move(BufferA^,BufI^,EEE); { Moves only the buffer To decompress }

    ReallocMem(Buffer,0); { DeAllocates }

    Try
      ZDecompress(BufI, EEE, Buffer, QtdBytesPagRel, 0);
    Except
      On E: Exception Do
        Begin
        ShowMessage('Erro de descompressão da página...'+#13#10+e.Message);
        End;
      End; // Try
    End;
  End
Else
  Begin
  Seek(ArqPag64,Pagina-1);
  Read(ArqPag64,Inicio64);
  {$i-}
  Read(ArqPag64,Fim64);
  {$i+}
  If IoResult <> 0 Then
    Fim64 := FileSize(Arq);

  If Inicio64 <= MaxInt Then
    Begin
    Inc(Inicio64);       // Must consider the offset
    Seek(Arq, Inicio64);
    ReallocMem(BufI,Fim64-(Inicio64)); { Allocates only the space needed }
    BlockRead(Arq,BufI^,Fim64-(Inicio64),Erro); { Read only the buffer To decompress }
    ReallocMem(Buffer,0); { DeAllocates }
//    If Not DecompressBuf(BufI,Fim64-Inicio64,0,MDIEdit.Buffer,QtdBytesPagRel) Then
//      ShowMessage('Erro de descompressão da página...');
    Try
      ZDecompress(BufI, Fim64-(Inicio64), Buffer, QtdBytesPagRel, 0);
    Except
      On E: Exception Do
        Begin
        ShowMessage('Erro de descompressão da página...'+e.message);
        End;
      End; // Try
    End
  Else
    Begin
    FileHandle := FileOpen(FileName, fmShareDenyNone);
    FileSeek(FileHandle,0,0);
    Integer64 := Inicio64;
    Inc(Integer64);           // Must consider the offset
    While Integer64 > MaxInt Do
      Begin
      FileSeek(FileHandle,MaxInt,1);
      Dec(Integer64,MaxInt);
      End;
    FileSeek(FileHandle,Integer64,1);
    ReallocMem(BufI,Fim64-Inicio64); { Allocates only the space needed }
    FileRead(FileHandle,BufI^,Fim64-Inicio64);
    ReallocMem(Buffer,0); { DeAllocates }
//    If Not DecompressBuf(BufI,Fim64-Inicio64,0,Buffer,QtdBytesPagRel) Then
//      ShowMessage('Erro de descompressão da página...');
    Try
      ZDecompress(BufI, Fim64-Inicio64, Buffer, QtdBytesPagRel, 0);
    Except
      On E: Exception Do
        Begin
        ShowMessage('Erro de descompressão da página...');
        End;
      End; // Try
    FileClose(FileHandle);
    End;
  End;

//Decripta(Buffer, PaginaAcertada, PaginaNormal, Report133CC, Orig, QtdBytesPagRel);
Decripta(Buffer, Report133CC, Orig, QtdBytesPagRel);

End;

Function TEditForm.Open(Const AFilename: AnsiString; EhRemoto : Boolean) : Boolean;
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
  ComprimeBrancos := Boolean(CmprBrncs);

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
  AssignFile(Arq, FileName);
  {$i-}
  Reset(Arq,1);
  {$i+}
  I := IoResult;
  If (I <> 0) Then
    Begin
    FormGeral.MostraMensagem('Relatório não pode ser aberto: '+FileName+' Falha '+IntToStr(I));
    Screen.Cursor := crDefault;
    Exit;
    End;

  If (Filesize(Arq) = 0) Then
    Begin
    FormGeral.MostraMensagem('Relatório não pode ser aberto: '+FileName+' Arquivo Vazio');
    Screen.Cursor := crDefault;
    Exit;
    End;

  If FileExists(ChangeFileExt(FileName,'.IAP')) Then
    Begin
    AssignFile(ArqPag32,ChangeFileExt(FileName,'.IAP'));
    {$i-}
    Reset(ArqPag32);
    {$i+}
    If (IoResult <> 0) Or (FileSize(ArqPag32)=0) Then
      Begin
      FormGeral.MostraMensagem('Índice de página não pode ser aberto 1');
      Screen.Cursor := crDefault;
      Exit;
      End;
    Paginas := FileSize(ArqPag32); { número total de páginas Do relatório }
    End;

  If FileExists(ChangeFileExt(FileName,'.IAPX')) Then
    Begin
    AssignFile(ArqPag64,ChangeFileExt(FileName,'.IAPX'));
    {$i-}
    Reset(ArqPag64);
    {$i+}
    If (IoResult <> 0) Or (FileSize(ArqPag64)=0) Then
      Begin
      FormGeral.MostraMensagem('Índice de página não pode ser aberto 3');
      Screen.Cursor := crDefault;
      Exit;
      End;
    Paginas := FileSize(ArqPag64);
    End;

  ComprimeBrancos := True; // Por default assume...

  If FileExists(ChangeFileExt(FileName,'.IAPX')) Then   // Carrega os dados pela memória
    Begin
    Report133CC := (RegDFN.TipoQuebra = 1);
    ComprimeBrancos := (RegDFN.COMPRBRANCOS); // Aqui verifica a seleção da flag na DFN
    DefChave.RowCount := 1;
    DefChave.ColCount := 12;
    I := 0;
    While ArrRegIndice[I].TipoReg <> 0 Do
      Begin
      DefChave.RowCount := I+2;
      DefChave.Cells[1,I+1] := IntToStr(ArrRegIndice[I].LinhaI);
      DefChave.Cells[2,I+1] := IntToStr(ArrRegIndice[I].LinhaF);
      DefChave.Cells[3,I+1] := IntToStr(ArrRegIndice[I].Coluna);
      DefChave.Cells[4,I+1] := IntToStr(ArrRegIndice[I].Tamanho);
      DefChave.Cells[5,I+1] := ArrRegIndice[I].Branco;
      DefChave.Cells[6,I+1] := ArrRegIndice[I].NomeCampo;
      DefChave.Cells[7,I+1] := ArrRegIndice[I].TipoCampo;
      DefChave.Cells[8,I+1] := ArrRegIndice[I].CharInc;
      DefChave.Cells[9,I+1] := ArrRegIndice[I].CharExc;
      DefChave.Cells[10,I+1] := ArrRegIndice[I].StrInc;
      DefChave.Cells[11,I+1] := ArrRegIndice[I].StrExc;
      Inc(I);
      End;
    End;
  End;

LastScale := FrameForm.m100;
PaginaAtu := 2;              { a primeira é sempre 2 então força a quebra }

ScrollBox1.VertScrollBar.Position := 0;
ScrollBox1.HorzScrollBar.Position := 0;

//Drive := 'C';
Drive := ColetaDiretorioTemporario;
If Drive = '' Then
  Drive := 'C:';
Drive := IncludeTrailingPathDelimiter(Drive);

Inc(NomRede); // Esta atribuição força a existência de uma única instância Do Programa

//AssignFile(ArqPsq,Drive+':\'+IntToStr(NomRede)+'.111');
AssignFile(ArqPsq,Drive+IntToStr(NomRede)+'.111');

//If FileExists(Drive+':\'+IntToStr(NomRede)+'.111') Then
If FileExists(Drive+IntToStr(NomRede)+'.111') Then
  Begin
  {$i-}
  Erase(ArqPsq);
  {$i+}
  If IoResult <> 0 Then
    Begin
    FormGeral.MostraMensagem('ArqPsq não pode ser aberto, verifique se o programa já está sendo executado nesta máquina...');
    Screen.Cursor := crDefault;
    Exit;
    End;
  End;

{$i-}
ReWrite(ArqPsq);
{$i+}
If IoResult <> 0 Then
  Begin
  FormGeral.MostraMensagem('ArqPsq não pode ser aberto');
  Screen.Cursor := crDefault;
  Exit;
  End;

If Not AbriuArqQue Then
  Begin
  QueryDlg.ScrollBar1.Min := 0;
  QueryDlg.ScrollBar1.Max := 0;
  QueryDlg.ScrollBar1.Position := 0;
  QueryDlg.LabelScrollQue.Caption := '0 de 0';

//  AssignFile(ArqQue,Drive+':\'+IntToStr(NomRede)+'.555');
  AssignFile(ArqQue,Drive+IntToStr(NomRede)+'.555');
  {$i-}
  ReWrite(ArqQue);
  {$i+}
  If IoResult <> 0 Then
    Begin
    FormGeral.MostraMensagem('Arquivo de Queries não pode ser aberto');
    Screen.Cursor := crDefault;
    Exit;
    End;
  AbriuArqQue := True;
  End;

//AssignFile(ArqSav,Drive+':\'+IntToStr(NomRede)+'.777');
AssignFile(ArqSav,Drive+IntToStr(NomRede)+'.777');
{$i-}
ReWrite(ArqSav,1);
{$i+}
If IoResult <> 0 Then
  Begin
  FormGeral.MostraMensagem('Arquivo auxiliar não pode ser criado');
  Screen.Cursor := crDefault;
  Exit;
  End;

//AssignFile(ArqImp,Drive + ':\'+IntToStr(NomRede) + '.888');
AssignFile(ArqImp,Drive + IntToStr(NomRede) + '.888');
{$i-}
ReWrite(ArqImp);
{$i+}
If IoResult <> 0 Then
  Begin
  FormGeral.MostraMensagem('Arquivo de Impressão não pode ser criado');
  Screen.Cursor := crDefault;
  Exit;
  End;

InicializaFontes;

Paleta := False;

If EhRemoto Then
  I64 := 0
Else
Read(ArqPag64,I64);

StrPagina := TStringList.Create;

SetLength(ArrBloqCamposDoRel,0);
If Length(ArrBloqCampos) <> 0 Then
  ArrBloqCamposDoRel := ArrBloqCampos;
  
{
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;

SetLength(ArrBloqCampos,0);

FormGeral.QueryLocal1.Sql.Add('SELECT *');
FormGeral.QueryLocal1.Sql.Add('FROM USUARIOMASCARA A INNER JOIN');
FormGeral.QueryLocal1.Sql.Add('     MASCARACAMPO B ON A.CODREL = B.CODREL AND A.NOMECAMPO = B.NOMECAMPO');
FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND');
FormGeral.QueryLocal1.Sql.Add('(A.CODREL = '''+RegDFN.CODREL+''')');
Try
  FormGeral.QueryLocal1.Open;
  SetLength(ArrBloqCampos, FormGeral.QueryLocal1.RecordCount);
  For I := 0 To FormGeral.QueryLocal1.RecordCount-1 Do
    Begin
    ArrBloqCampos[I].CODREL := FormGeral.QueryLocal1.Fields[0].AsString;
    ArrBloqCampos[I].NOMECAMPO := FormGeral.QueryLocal1.Fields[1].AsString;
    ArrBloqCampos[I].CODUSUARIO := FormGeral.QueryLocal1.Fields[2].AsString;
    ArrBloqCampos[I].CODREL_ := FormGeral.QueryLocal1.Fields[3].AsString;
    ArrBloqCampos[I].NOMECAMPO_ := FormGeral.QueryLocal1.Fields[4].AsString;
    ArrBloqCampos[I].LINHAI := FormGeral.QueryLocal1.Fields[5].AsInteger;
    ArrBloqCampos[I].LINHAF := FormGeral.QueryLocal1.Fields[6].AsInteger;
    ArrBloqCampos[I].COLUNA := FormGeral.QueryLocal1.Fields[7].AsInteger;
    ArrBloqCampos[I].TAMANHO := FormGeral.QueryLocal1.Fields[8].AsInteger;
    FormGeral.QueryLocal1.Next;
    End;
  FormGeral.QueryLocal1.Close;
Except
  ShowMessage('Erro no levantamento das restrições de campos...');
  End; //Try
}

CarregaImagem(False,1);

Ocorre := 0;

Screen.Cursor := crDefault;

FileMode := 2;

Open := True;

End;

Procedure TEditForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin

ReallocMem(Buffer,0);
ReallocMem(BufI,0);
StrPagina.Free;
PaginaNormal := '';
PaginaAcertada := '';

Try
//  Query1.Close;
Except
  End;
Try
  ClientDataSet1.Close;
Except
  End;
Try
CloseFile(Arq);
Except
  End;
Try
CloseFile(ArqPag32);
Except
  End;
Try
CloseFile(ArqPag64);
Except
  End;
Try
CloseFile(ArqPsq);             // 111
Except
  End;
Try
Erase(ArqPsq);
Except
  End;
Try
CloseFile(ArqSav);             // 777
Except
  End;
Try
Erase(ArqSav);
Except
  End;
Try
CloseFile(ArqImp);             // 888
Except
  End;
Try
Erase(ArqImp);
Except
  End;

If FrameForm.MDIChildCount = 1 Then // Todos são Nil, não sobrou relatório aberto
  Begin
  With FrameForm Do
    Begin
    Animate1.Visible := False;
    Animate2.Visible := False;
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
    Localizar1.Enabled := Fechar1.Enabled;
    LocalizarPrxima1.Enabled := Fechar1.Enabled;
    Prxima2.Enabled := Fechar1.Enabled;
    Anterior2.Enabled := Fechar1.Enabled;
    Tile1.Enabled := Fechar1.Enabled;
    LadoALado1.Enabled := Fechar1.Enabled;
    Cascade1.Enabled := Fechar1.Enabled;
    ArrangeIcons1.Enabled := Fechar1.Enabled;
    End;

//  If (Not FaiouAbrAssistido) And ((Length(ArINC) <> 0) Or (Length(ArIncRemoto) <> 0)) Then // Há relatórios associados...
  If ((Length(ArINC) <> 0) Or (Length(ArIncRemoto) <> 0)) Then // Há relatórios associados...
    Try
      If Not FaiouAbrAssistidoLocal Then
        Begin
        FormGeral.TableDFN.Open;
        FormGeral.TableDFN.Close;
        End;
        
      If Tela = '' Then
        FrameForm.AbrirAssistido1.Click
      Else  
      If Tela = 'AssisAbreLocal' Then
        AssisAbreForm.Show
      Else
      If Tela = 'AssisAbreRemoto' Then
        AssisAbreRemotoForm.Show;
        
{      If JaAbriu Then
        Begin
        If Tela = 'AssisAbreLocal' Then
          AssisAbreForm.Show
        Else
          If Tela = 'AssisAbreRemoto' Then
            AssisAbreRemotoForm.Show
        End
      Else
        FrameForm.AbrirAssistido1.Click;}
    Except
      FaiouAbrAssistidoLocal := True;
      End; // Try

  End;

AnotaForm.Free;
AnotaTextoForm.Free;

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

ForceDirectories(Drive+'Bde');
ForceDirectories(Drive+'COLDCFG');
ForceDirectories('C:\COLDCFG');

PathCfg := IncludeTrailingPathDelimiter(Direct);
If Not FileExists(PathCfg+'Printer.Cfg') Then
  Begin

  PathCfg := Drive+'COLDCFG\';

//  If Not FileExists(PathCfg+'Printer.Cfg') Then
//    Begin
//    {$i-}
//    MkDir(Copy(PathCfg,1,Length(PathCfg)-1)); { Evita a última barra }
//    {$i+}
//    If IoResult <> 0 Then
//      Begin
//      End;
//    End;
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

Procedure TEditForm.TrataImage2(Linha, Coluna : Integer);
Var
  OldBrush : TBrushStyle;
Begin
//  Image2.Width := Linha; // Reconstroi a página Do tamanho exato para acomodar as linhas e colunas
//  Image2.Height := Coluna;
  OldBrush := Image2.Canvas.Brush.Style;
  Image2.Picture.Bitmap.Width := Linha; //Image2.Width;
  Image2.Picture.Bitmap.Height := Coluna; //Image2.Height;

  Image2.Canvas.Brush.Color := clWhite;
  Image2.Canvas.FillRect(Rect(0,0,Image2.Width,Image2.Height));
  Image2.Canvas.Brush.Style := OldBrush;
End;

Function TEditForm.TrataBloqueio(Entra : AnsiString; Linha : Integer) : AnsiString;
Var
  I : Integer;
  StrTrab : AnsiString;
Begin
StrTrab := Entra;
For I := 0 To Length(ArrBloqCampos)-1 Do
  If (Linha >= ArrBloqCampos[I].LINHAI) And (Linha <= ArrBloqCampos[I].LINHAF) Then
    Begin
    StrTrab := Copy(StrTrab,1, ArrBloqCampos[I].COLUNA-1) +
               Format('%'+IntToStr(ArrBloqCampos[I].TAMANHO)+'s',[' ']) +
               Copy(StrTrab, ArrBloqCampos[I].COLUNA + ArrBloqCampos[I].TAMANHO, Length(StrTrab));
    End;
Result := StrTrab;
//showMessage('Linha: '+IntToStr(Linha)+#13#10+'Entra: '+Entra+#13#10+'StrTrab: '+StrTrab);
End;

Procedure TEditForm.FastImageReload;
Var
  QtdCarac,
  MaiorLinha,
  MaiorColuna,
  I, IC,
  Inicio,
  InicioH,
  OriVideoSize,
  TamCol,
  TamCar,
  TamCampo : Integer;
Begin
//DFActiveDisplay1.Visible := False;

Mascara := False;
MaiorLinha := 0;
MaiorColuna := 0;
TamCol := 0;
QtdCarac := 0;
OriVideoSize := Video.Size;

If (Video.Size + ZoomLevel) > 0 Then
  Video.Size := Video.Size + ZoomLevel;

Image1.Canvas.Font := Video;

For I := 0 To ILinha Do
  If Image1.Canvas.TextWidth(ArrPag[I].LinhaRel) > MaiorLinha Then
    Begin
    MaiorLinha := Image1.Canvas.TextWidth(ArrPag[I].LinhaRel);
    QtdCarac := Length(ArrPag[I].LinhaRel);
    ArrPag[I].FontSize := Video.Size;
    ArrPag[I].FontHeight := Video.Height;
    ArrPag[I].FontName := Video.Name;
    ArrPag[I].FontStyle := Video.Style;
    End;

Try
  TamCol := Image1.Canvas.TextHeight(ArrPag[0].LinhaRel);
  MaiorColuna := TamCol*(ILinha+1);
Except
  FormGeral.MostraMensagem('Erro ao calcular o tamanho da página...');
  End;

Image1.Width := MaiorLinha; // Reconstroi a página Do tamanho exato para acomodar as linhas e colunas
Image1.Height := MaiorColuna+20;
Image1.Picture.Bitmap.Width := Image1.Width;
Image1.Picture.Bitmap.Height := Image1.Height;

Image1.Canvas.Brush.Color := clWhite;
Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));

If FezAnotacoesGraficas Then
  If Image2.Width = 1 Then
    TrataImage2(MaiorLinha, MaiorColuna+20);

Inicio := 0;
InicioH := 9999;
EhPrimeiro := True;

For I := 0 To ILinha Do
  Begin
  If ArrPag[I].TemPesquisa = False Then
    Begin
    Image1.Canvas.Brush.Color := ArrPag[I].CorDeFundo;
    Image1.Canvas.Font.Color := ArrPag[I].CorDaFonte;
    If Length(ArrBloqCampos) = 0 Then
      Image1.Canvas.TextOut(0, TamCol*I, Format('%-'+IntToStr(QtdCarac)+'s',[ArrPag[I].LinhaRel]))
    Else
      Image1.Canvas.TextOut(0, TamCol*I, Format('%-'+IntToStr(QtdCarac)+'s',[TrataBloqueio(ArrPag[I].LinhaRel, I+1)]));
    End
  Else
    Begin
    Image1.Canvas.Brush.Color := ArrPag[I].CorDeFundo;
    Image1.Canvas.Font.Color := ArrPag[I].CorDaFonte;
    Image1.Canvas.TextOut(0, TamCol*I, Format('%-'+IntToStr(QtdCarac)+'s',[ArrPag[I].LinhaRel]));
    Image1.Canvas.Brush.Color := clNavy;
    Image1.Canvas.Font.Color := clWhite;
    For IC := 1 To 10 Do
      If ArrPag[I].CamposT[IC] Then
        Begin
        TamCar := Image1.Canvas.TextWidth(Copy(ArrPag[I].LinhaRel,1,ListaDeCampos[IC].PosCampo-1));
        Image1.Canvas.TextOut(TamCar, TamCol*I,Copy(ArrPag[I].LinhaRel,ListaDeCampos[IC].PosCampo,
                                                                       ListaDeCampos[IC].TamCampo));
        If EhPrimeiro Then
          Begin
          TamCampo := Image1.Canvas.TextWidth(Copy(ArrPag[I].LinhaRel,ListaDeCampos[IC].PosCampo,
                                                                       ListaDeCampos[IC].TamCampo));
          If (TamCar + TamCampo) < InicioH Then
            InicioH := TamCar + TamCampo;
          End;
        End;

    If EhPrimeiro  Then
      Begin
      EhPrimeiro := False;
      Inicio := TamCol*I;
      End;
    End;
  End;

If EhPrimeiro Then
  Begin
  End
Else
  Begin
  ScrollBox1.VertScrollBar.Position := 0;
  If Inicio > ScrollBox1.Height Then
    If ((Inicio - ScrollBox1.Height) + 200) > ScrollBox1.VertScrollBar.Range Then
      ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Range
    Else
      ScrollBox1.VertScrollBar.Position := (Inicio - ScrollBox1.Height) + 200;

  ScrollBox1.HorzScrollBar.Position := 0;
  If InicioH > ScrollBox1.Width Then
    If (InicioH - (ScrollBox1.Width Div 2)) > ScrollBox1.HorzScrollBar.Range Then
      ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Range
    Else
      ScrollBox1.HorzScrollBar.Position := (InicioH - (ScrollBox1.Width Div 2));
  End;

Video.Size := OriVideoSize;

Application.ProcessMessages;
End;

Procedure TEditForm.LoadImage2;
Var
  b : TStream;
//  zLibT : TDecompressionStream;
  zLibT : TZDecompressionStream;
  QtdBytes : Integer;
  Buffer : Pointer;
Begin
  b := AnotaForm.ADOQuery1.CreateBlobStream(AnotaForm.ADOQuery1.FieldByName('COMENTARIOBIN'),bmRead);
  zLibT := TZDecompressionStream.Create(b);

  GetMem(Buffer, 9000000);
  QtdBytes := zLibT.Read(Buffer^, 9000000);

  b.Free;
  b := TMemoryStream.Create;
  b.Write(Buffer^, QtdBytes);
  b.Position := 0;
  Image2.Picture.Graphic.LoadFromStream(b);

  zLibT.Free;
  b.Free;
  FreeMem(Buffer);

  If AnotaForm.ADOQuery1.FieldByName('FLAGPUBLICO').AsString = 'T' Then
    AnotaForm.PublicaRadioButton.Checked := True
  Else
    AnotaForm.PrivadaRadioButton.Checked := True;
End;

Procedure TEditForm.VerificaAnotacao;
Begin

AnotaForm.Label1.Caption := '0 de 0';
AnotaForm.ScrollBar1.Min := 0;
AnotaForm.ScrollBar1.Position := 0;
AnotaForm.ScrollBar1.Max := 0;
AnotaTextoForm.Label1.Caption := '0 de 0';
AnotaTextoForm.ScrollBar1.Min := 0;
AnotaTextoForm.ScrollBar1.Position := 0;
AnotaTextoForm.ScrollBar1.Max := 0;

AnotaTextoForm.Memo1.Text := '';
FrameForm.Animate1.Visible := False;
FrameForm.Animate2.Visible := False;
TemAnotacaoGrafica := False;
TemAnotacaoDeTexto := False;

AnotaForm.ADOQuery1.Close;
AnotaForm.ADOQuery1.SQL.Clear;
AnotaForm.ADOQuery1.SQL.Add('SELECT * FROM COMENTARIOSBIN WHERE CODREL = '''+RegDFN.CODREL+'''');
AnotaForm.ADOQuery1.SQL.Add('AND PATHREL = '''+ExtractFileName(Filename)+'''');
AnotaForm.ADOQuery1.SQL.Add('AND PAGINA = '+IntToStr(PaginaAtu));
AnotaForm.ADOQuery1.SQL.Add('AND ((CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''')');
AnotaForm.ADOQuery1.SQL.Add('OR   (FLAGPUBLICO = ''T''))');
Try
  AnotaForm.ADOQuery1.Open;
Except
  Exit;
  End;
If AnotaForm.ADOQuery1.RecordCount <> 0 Then
  Begin
  FrameForm.Animate2.Visible := True;
  TemAnotacaoGrafica := True;

  LoadImage2;

  Image2.Visible := False;
  Image2.BringToFront;
  AnotaForm.Label1.Caption := '1 de '+IntToStr(AnotaForm.ADOQuery1.RecordCount);
  AnotaForm.ScrollBar1.Max := AnotaForm.ADOQuery1.RecordCount;
  AnotaForm.ScrollBar1.Position := 1;
  AnotaForm.ScrollBar1.Min := 1;
  End;

AnotaTextoForm.ADOQuery1.Close;
AnotaTextoForm.ADOQuery1.SQL.Clear;
AnotaTextoForm.ADOQuery1.SQL.Add('SELECT * FROM COMENTARIOSTXT WHERE CODREL = '''+RegDFN.CODREL+'''');
AnotaTextoForm.ADOQuery1.SQL.Add('AND PATHREL = '''+ExtractFileName(Filename)+'''');
AnotaTextoForm.ADOQuery1.SQL.Add('AND PAGINA = '+IntToStr(PaginaAtu));
AnotaTextoForm.ADOQuery1.SQL.Add('AND ((CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''')');
AnotaTextoForm.ADOQuery1.SQL.Add('OR   (FLAGPUBLICO = ''T''))');
Try
  AnotaTextoForm.ADOQuery1.Open;
Except
  Exit;
  End;
If AnotaTextoForm.ADOQuery1.RecordCount <> 0 Then
  Begin
  FrameForm.Animate1.Visible := True;
  TemAnotacaoDeTexto := True;
  AnotaTextoForm.Memo1.Text := AnotaTextoForm.ADOQuery1.FieldByName('COMENTARIOTXT').AsString;
  AnotaTextoForm.Label1.Caption := '1 de '+IntToStr(AnotaTextoForm.ADOQuery1.RecordCount);
  AnotaTextoForm.ScrollBar1.Max := AnotaTextoForm.ADOQuery1.RecordCount;
  AnotaTextoForm.ScrollBar1.Position := 1;
  AnotaTextoForm.ScrollBar1.Min := 1;
  If AnotaTextoForm.ADOQuery1.FieldByName('FLAGPUBLICO').AsString = 'T' Then
    AnotaTextoForm.PublicaRadioButton.Checked := True
  Else
    AnotaTextoForm.PrivadaRadioButton.Checked := True;
  End;
//FormGeral.QueryLocal1.Close;

End;

Procedure TEditForm.CarregaImagem;

Var
  OldBrush : TBrushStyle;
  IField,
  IFieldAux : TDFField;
  FileHandle,
  MaiorLinha,
  MaiorColuna,
  HOri,
  VOri,
//  ILinha,
  ILinhaLocal,
  ILinhaRel,
  PosAtu,
  Posic,
  Linha,
  IC,
  I, Ix,
  IndField,
  J,
  ILinAux,
  TamOri,
  Inicio,
  SimNao,
  IIniPag32,
  FTLeft,
  FTTop,
  FTHeight,
  HCor : Integer;
  Integer64,
  IIniPag64 : Int64;
  RetVal,
  PulAux,
  DetAux : AnsiString;
  LinAux : AnsiString; // 17/05/2013
  Descarga,
  Marcou,
  MostraAlerta : Boolean;
  Teste : AnsiChar;
//  ComandoDeCarro : AnsiChar;
  varPag : WideString;
//  varPag : Variant;
  V : Variant;
  PosQuery : INteger;

  Procedure ComFundo;

  Begin
  ArrPag[ILinha].CorDaFonte := clBlack;
  ArrPag[ILinha].CorDeFundo := Cor;
//  ArrPag[ILinha].TemPesquisa := False;
  End;

  Procedure SemFundo;

  Begin
  ArrPag[ILinha].CorDaFonte := clBlack;
  ArrPag[ILinha].CorDeFundo := clWhite;
//  ArrPag[ILinha].TemPesquisa := False;
  End;

  Procedure ComPesquisa(ILinha : Integer);
  Begin
//  ArrPag[ILinha].CorDaFonte := clWhite;
//  ArrPag[ILinha].CorDeFundo := clNavy;
//  ArrPag[ILinha].CorDaFonte := clBlack;
//  ArrPag[ILinha].CorDeFundo := clWhite;
  ArrPag[ILinha].TemPesquisa := True;
  ArrPag[ILinha].CamposT := ArrPag[ILinhaRel].Campos;
  End;

  Procedure VerifyBefore;       // Acrescentará uma linha em branco antes de imprimir a linha

  Begin
  If Report133CC Then
    Begin
    ArrPag[ILinha].ComandoDeCarro := ' ';
    If Length(LinAux) = 0 Then
      Exit;
    ArrPag[ILinha].ComandoDeCarro := LinAux[1];
    LinAux[1] := ' ';
    If ArrPag[ILinha].ComandoDeCarro = '0' Then
      Begin
      SimNao := SimNao Xor 1;  // Manter a ordem Do zebrado
      If SimNao = 0 Then
        ComFundo
      Else
        SemFundo;
      ArrPag[ILinha].LinhaRel := PulAux;
      ArrPag[ILinha].Active := True;

      WriteLn(ArqImp,PulAux);

      Inc(ILinha);
      End;
    End;
  End;

  Procedure VerifyAfter;    // Já imprimiu a linha e acrescentará uma mais em branco...

  Begin
  If Length(LinAux) = 0 Then
    Exit;
  If Report133CC Then
    If ArrPag[ILinha].ComandoDeCarro = '-' Then  { Pula Uma Linha AFTER}
      Begin
      Inc(ILinha);
      SimNao := SimNao Xor 1;  // Manter a ordem Do zebrado
      If SimNao = 0 Then
        ComFundo
      Else
        SemFundo;
      ArrPag[ILinha].LinhaRel := PulAux;
      ArrPag[ILinha].Active := True;
      WriteLn(ArqImp,PulAux);
      End;
  End;

Begin

 { Inicializa variáveis, Memos e imagens }

//SetLength(PulAux,133);
//FillChar(PulAux[1], 133, ' ');
PulAux := StringOfChar(' ', 133);
For ILinhaLocal := 0 To MaxLinhasPorPag Do
  Begin
  ArrPag[ILinhaLocal].Active := False;
  SemFundo;
  ArrPag[ILinhaLocal].TemPesquisa := False;
  ArrPag[ILinhaLocal].LinhaRel := '';
  For IC := 1 To 10 Do
    Begin
    ArrPag[ILinhaLocal].Campos[IC] := False;
    ArrPag[ILinhaLocal].CamposT[IC] := False;
    ArrPag[ILinhaLocal].CamposL[IC] := False;
    End;
  End;
ILinha := 0; // Primeira Linha Do relatório é a 0
ILinhaRel := 0; // Linha Do Relatório armazenado -> não leva em consideração os pulos de carro

If Marca Then
  Begin               // Aqui podemos usar o campo linha em vez deste cálculo de posição relativa Do campo pesquisado
  FillChar(ArrBol,SizeOf(ArrBol),0);

  {
  PosQuery := RegPsq.PosQuery;
  while (PosQuery < high(gridQueryFacil)+1) and (gridQueryFacil[PosQuery,1] = intToStr(PagAtu))  do
    begin
    Posic := 3;
    IC := 1;
    while Posic <= high(gridQueryFacil[0])+1 do
      begin
      ArrBol[strToInt(gridQueryFacil[PosQuery,Posic])-1] := True;   // Field = Linha, aqui começa em 0
      ArrPag[strToInt(gridQueryFacil[PosQuery,Posic])-1].Campos[IC] := True;
      inc(IC);
      Inc(Posic,5);
      end;
    inc(PosQuery);
    end;
  }

  PosQuery := RegPsq.PosQuery;
  while (PosQuery < high(gridQueryFacil)+1) and (gridQueryFacil[PosQuery].Pagina = PagAtu)  do
    begin
    ArrBol[gridQueryFacil[PosQuery].Linha-1] := True; // Field = Linha, aqui começa em 0
    IC := Pos(gridQueryFacil[PosQuery].Campo,'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    ArrPag[gridQueryFacil[PosQuery].Linha-1].Campos[IC] := true;
    ArrPag[gridQueryFacil[PosQuery].Linha-1].CamposL[IC] := true;
    inc(PosQuery);
    end;

  (*
  If RelRemoto Then
    Begin
    If ClientDataSet1.Active Then
      Begin
      ClientDataSet1.First;
      ClientDataSet1.MoveBy(RegPsq.PosQuery-1);
      While ClientDataSet1.Fields[1].AsInteger = PagAtu Do
        Begin
        Posic := 3;
        IC := 1;
        While Posic <= ClientDataSet1.FieldCount Do
          Begin
          ArrBol[ClientDataSet1.Fields[Posic].AsInteger-1] := True;   // Field = Linha, aqui começa em 0
          ArrPag[ClientDataSet1.Fields[Posic].AsInteger-1].Campos[IC] := True;
          Inc(IC);
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
        IC := 1;
        While Posic <= Query1.FieldCount Do
          Begin
          ArrBol[Query1.Fields[Posic].AsInteger-1] := True;   // Field = Linha, aqui começa em 0
          ArrPag[Query1.Fields[Posic].AsInteger-1].Campos[IC] := True;
          Inc(IC);
          Inc(Posic,5);     { Cada Campo de pesquisa gera 5 campos }
          End;
        If Query1.EOF Then
          Break;
        Query1.Next;
        End;
      End;
  *)
  End;


MarcaAtu := Marca;
If PagAtu <> PaginaAtu Then
  Begin
  PaginaAtu := PagAtu;

  If RelRemoto Then
    Begin
    With FrameForm Do
      Begin
      RetVal := (formGeral.HTTPRIO1 as IMulticoldServer).GetPagina(LogInRemotoForm.UsuEdit.Text,
                                                   LogInRemotoForm.PassEdit.Text,
                                                   ConnectionID,
                                                   Filename,
                                                   PagAtu,
                                                   EEE,
                                                   varPag);
      //RetVal := WebConnection1.AppServer.GetPagina(LogInRemotoForm.UsuEdit.Text,
      //                                             LogInRemotoForm.PassEdit.Text,
      //                                             ConnectionID,
      //                                             Filename,
      //                                             PagAtu,
      //                                             EEE,
      //                                             varPag);

{      auxPag := VarPag;             //Do the proper AnsiString convertion...
      JJJ := Length(auxPag);
      GetMem(Buffer, JJJ);
      Move(auxPag[1], Buffer^, JJJ);     }

//      V := VarArrayCreate([1,EEE], varByte);
//      V := varPag;

      ReallocMem(BufI,EEE div 2); { Allocates only the space needed }
      ReallocMem(Buffer,EEE div 2); // Temporariamente para a conversão.....

//      For I := 1 to EEE Do
//        Byte(BufferA^[I]) := V[I-1];

      auxPag := varPag;
      hexToBin(PAnsiChar(auxPag), PAnsiChar(BufferA), EEE div 2);

      Move(BufferA^,BufI^,EEE div 2); { Moves only the buffer To decompress }

      ReallocMem(Buffer,0); { DeAllocates }

      Try
        ZDecompress(BufI, EEE, Buffer, JJJ, 0);
      Except
        On E: Exception Do
          Begin
          ShowMessage('Erro de descompressão da página...');
          End;
        End; // Try

      End;
    End
  Else
    Begin
    PosAtu := FilePos(ArqPag64) - 1;
    If PosAtu < 0 Then
      PosAtu := 0;
    Seek(ArqPag64,PagAtu - 1);
    Read(ArqPag64,IIniPag64);
    {$i-}
    Read(ArqPag64,NextPag64);
    {$i+}
    If IoResult <> 0 Then
      NextPag64 := FileSize(Arq);
    Seek(ArqPag64,PosAtu);        { Back To the same place }

    If IIniPag64 <= MaxInt Then
      Begin
      Inc(IIniPag64, 1); // 1 = OffSet do primeiro byte
      Seek(Arq,IIniPag64);
      ReallocMem(BufI,NextPag64-IIniPag64); { Allocates only the space needed }
      BlockRead(Arq,BufI^,NextPag64-IIniPag64,EEE); { Read only the buffer To decompress }
      ReallocMem(Buffer,0); { DeAllocates }
//      If Not DecompressBuf(BufI,NextPag64-IIniPag64,0,Buffer,JJJ) Then
//        ShowMessage('Erro de descompressão da página...');
      Try
        ZDecompress(BufI, NextPag64-IIniPag64, Buffer, JJJ, 0);
      Except
        On E: Exception Do
          Begin
          ShowMessage('Erro de descompressão da página...');
          End;
        End; // Try
      Seek(Arq,IIniPag64);   // Volta o cursor do arquivo para o lugar original
      End
    Else
      Begin
      FileHandle := FileOpen(FileName, fmShareDenyNone);
      FileSeek(FileHandle,0,0);
      Integer64 := IIniPag64;
      Inc(Integer64);
      While Integer64 > MaxInt Do
        Begin
        FileSeek(FileHandle,MaxInt,1);
        Dec(Integer64,MaxInt);
        End;
      FileSeek(FileHandle,Integer64,1);  
      ReallocMem(BufI,NextPag64-IIniPag64); { Allocates only the space needed }
      FileRead(FileHandle,BufI^,NextPag64-IIniPag64);
      ReallocMem(Buffer,0); { DeAllocates }
//      If Not DecompressBuf(BufI,NextPag64-IIniPag64,0,Buffer,JJJ) Then
//        ShowMessage('Erro de descompressão da página...');
      Try
        ZDecompress(BufI, NextPag64-IIniPag64, Buffer, JJJ, 0);
      Except
        On E: Exception Do
          Begin
          ShowMessage('Erro de descompressão da página...');
          End;
        End; // Try
      FileClose(FileHandle);
      End;

    End;

  ReWrite(ArqSav,1);
  BlockWrite(ArqSav,Buffer^,JJJ,EEE);
  ReWrite(ArqImp);
  Descarga := True;

//  FezAnotacoesGraficas := False;
//  FezAnotacoesDeTexto := False;
//  Image2.Visible := False;
//  TrataImage2(1, 1);

  End
Else
  Begin
  Reset(ArqSav,1);
  ReallocMem(Buffer,JJJ);   // Ajusta o tamanho Do buffer de memória para a leitura
  BlockRead(ArqSav,Buffer^,JJJ,EEE);
  Descarga := False;
  ReWrite(ArqImp);
  End;

FezAnotacoesGraficas := False;
FezAnotacoesDeTexto := False;
Image2.Visible := False;
TrataImage2(1, 1);

I := 0;
SetLength(LinAux,1000);      // := '';
ILinAux := 1;
Marcou := False;
MostraAlerta := True;
SimNao := 0;
Repeat
  Inc(I);

  If BufferA^[I] = #13 Then
    Begin

    SetLength(LinAux,ILinAux-1); // Ajusta

    VerifyBefore;

    If Marca Then
      Begin

      If ArrBol[ILinhaRel] Then
        Marcou := True;

      SimNao := SimNao Xor 1;  // Manter a ordem Do zebrado
      ArrPag[ILinha].TemPesquisa := False;

      If Marcou Then
        ComPesquisa(ILinha);
//      Else

      If SimNao = 0 Then
        Begin
        ComFundo;
        If Length(LinAux) < 133 Then
          Begin
//          TamOri := Length(LinAux);
//          SetLength(LinAux,133);
//          FillChar(LinAux[TamOri+1],133-TamOri,' ');
          LinAux := LinAux + StringOfChar(' ', 133-Length(LinAux));
          End;
        End
      Else
        SemFundo;

      ArrPag[ILinha].LinhaRel := LinAux;
      ArrPag[ILinha].Active := True;
      End
    Else
      Begin

      ArrPag[ILinha].TemPesquisa := False;
      SimNao := SimNao Xor 1;
      If SimNao = 0 Then
        ComFundo
      Else
        SemFundo;

      If Length(LinAux) < 133 Then
        Begin
//        TamOri := Length(LinAux);
//        SetLength(LinAux,133);
//        FillChar(LinAux[TamOri+1],133-TamOri,' ');
        LinAux := LinAux + StringOfChar(' ', 133-Length(LinAux));
        End;

      ArrPag[ILinha].LinhaRel := LinAux;
      ArrPag[ILinha].Active := True;

      End;

    If Marcou Then
      WriteLn(ArqImp,Chr(1)+LinAux)
    Else
      WriteLn(ArqImp,LinAux);

    VerifyAfter;

    SetLength(LinAux,1000); // := '';
    ILinAux := 1;
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
          FormGeral.MostraMensagem('Página excedeu o limite de 500 linhas, descartando excesso...');
          MostraAlerta := False;
          End;
        Dec(ILinha);
        Dec(ILinhaRel);
        End;
      End
    Else
      If (ComprimeBrancos) And ((Byte(BufferA^[I]) And $80) = $80) Then
        Begin
        If Byte(BufferA^[I]) = $80 Then
          Begin
          Inc(I);
          Teste := #$0;
          End
        Else
          Teste := #$80;
        Repeat
          LinAux[ILinAux] := ' ';
          Inc(ILinAux);
          If ILinAux > Length(LinAux) Then
            SetLength(LinAux,Length(LinAux)+1000);
          Dec(BufferA^[I]);
        Until BufferA^[I] = Teste;
        End
      Else
//        If BufferA^[I] <> #0 Then
        Begin
        LinAux[ILinAux] := BufferA^[I];
        Inc(ILinAux);
        If ILinAux > Length(LinAux) Then
          SetLength(LinAux,Length(LinAux)+1000);
        End;
Until I >= (JJJ-1);

LinAux := '';    // Zerar a AnsiString

If Descarga Then
  CloseFile(ArqImp);

If Not MostraAlerta Then // Estourou as 500 linhas máximas
  Dec(ILinha); // Para não mostrar a última linha que vira a última da página quando há o estouro

If Memo1.Visible Then
  Begin
  Image1.Visible := False;
  DFActiveDisplay1.Visible := False;
  Memo1.Enabled := True;
  Memo1.Clear;
  Memo1.Font := Video;
  Memo1.Visible := False;
  Memo1.Font.Size := Memo1.Font.Size + ZoomLevel;

  Inicio := 1;
  EhPrimeiro := True;
  For I := 0 To ILinha Do
    Begin
    If UsouLocalizar Then  
      If I = LinhaLocalizada Then
        Begin
        ComPesquisa(I);
        UsouLocalizar := False;
        End;

//    If ArrPag[I].CorDaFonte = clWhite Then
    If ArrPag[I].TemPesquisa Then
      ArrPag[I].CorDaFonte := clRed;
      
    Memo1.SelAttributes.Color := ArrPag[I].CorDaFonte;
    If Length(ArrBloqCampos) = 0 Then
      Memo1.Lines.Add(ArrPag[I].LinhaRel)
    Else
      Memo1.Lines.Add(TrataBloqueio(ArrPag[I].LinhaRel, I+1));

    If EhPrimeiro Then
      Begin
      Inicio := Inicio + Length(Memo1.Lines[I]);
      If ArrPag[I].TemPesquisa Then
        EhPrimeiro := False;
      End;
    End;
  Memo1.Visible := True;
//  Memo1.BringToFront;
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
  Image1.Visible := False;
  Image2.Visible := False;

  DFEngine1.Clear;
  If TEditForm(FrameForm.ActiveMDIChild).DFEngine1.PageCount <> 0 Then
    TEditForm(FrameForm.ActiveMDIChild).DFEngine1.Pages[0].Delete;
  DFEngine1.BeginUpdate;

  If (FileExists(ChangeFileExt(FileName,'.dfb'))) And
     (ComFormulrio1.Checked) Then
    Begin
    DFActiveDisplay1.Visible := True;
    DFEngine1.LoadFromfile(ChangeFileExt(FileName,'.dfb'));
    ComFormulrio1.Visible := True;
    ComFormulrio2.Enabled := True;
    Mascara := True;
    End
  Else
    Mascara := False;

  If Not Mascara Then
    Begin
    MaiorLinha := 0;
    MaiorColuna := 0;

    For I := 0 To ILinha Do
      If Length(ArrPag[I].LinhaRel)*Video.Size > MaiorLinha Then
        MaiorLinha := Length(ArrPag[I].LinhaRel)*(Video.Size-1);

    Try
      MaiorColuna := (Abs(Video.Height))*(ILinha+1);
    Except
      FormGeral.MostraMensagem('Erro ao calcular o tamanho da página, há mais linhas no relatório que campos na máscara. Arbitrando Tamanho...');
      End;
    If MaiorColuna < ScrollBox1.Height Then
      MaiorColuna := ScrollBox1.Height
    Else
      Inc(MaiorColuna,10);
    If MaiorLinha < ScrollBox1.Width Then
      MaiorLinha := ScrollBox1.Width
    Else
      Inc(MaiorLinha,10);

    DFEngine1.AddPage;
    DFEngine1.Pages[0].PaperSize := dfCustomPaper;
    DFEngine1.Pages[0].Width := MaiorLinha; // Reconstroi a página Do tamanho exato para acomodar as linhas e colunas
    DFEngine1.Pages[0].Height := MaiorColuna;
    End;

  EhPrimeiro := True;
  Inicio := 0;
  IField := nil; // Avoid fucking warning...
  FTTop := 0;
  FTLeft := 0;
  FTHeight := 0;
  HCor := 4;

  IndField := -1;
  For I := 0 To ILinha Do
    Begin
    Inc(IndField);
    If Mascara Then
      Begin              // Para reposicionar as linhas com controle de posicionamento
//      If Report133CC And (ArrPag[I].LinhaRel[1] <> '') And (Not (ArrPag[I].LinhaRel[1] IN ['0','1','-'])) Then
      If Report133CC And (Not (ArrPag[I].ComandoDeCarro IN ['0','1','-',' '])) Then
          For Ix := 1 To 999 Do  // Valor alto para extrapolar os fields da máscara
            Begin
            IField := DFEngine1.FindField('Field'+IntToStr(Ix));
            If IField = nil Then
              Break;
//            If ArrPag[I].LinhaRel[1] = Copy(IField.Hint,1,1) Then
            If ArrPag[I].ComandoDeCarro = Copy(IField.Hint,1,1) Then
              Begin
              IndField := Ix-1;
              Break;
              End;
            End;
//      IField := DFEngine1.FindField('Field'+IntToStr(I+1));
      IField := DFEngine1.FindField('Field'+IntToStr(IndField+1));
      If IField = nil Then
        Begin
        ShowMessage('Linha '+IntToStr(I+1)+' não tem um field correspondente. Pulando...');
        Continue;
        End;

      FTTop := IField.Top;
      FTLeft := IField.Left;
      FTHeight := IField.Height;
      HCor := 4;
      End
    Else
      Begin
      FTTop := (Abs(Video.Height))*I;
      FTLeft := 0;
      FTHeight := Abs(Video.Height);
      HCor := 2;
      End;

//    If ((UsouLocalizar) And (I = LinhaLocalizada)) Then
//      Begin
////      ComPesquisa(I);
//      ArrPag[I].TemPesquisa := True;
//      ArrPag[I].CamposT[1] := True;
//      ListaDeCampos[1].TamCampo := TamLocalizada;
//      ListaDeCampos[1].PosCampo := ColunaLocalizada;
//      UsouLocalizar := False;
//      End;

//      If (ArrPag[I].CorDaFonte = clWhite) Then        // Linha com pesquisa

    If (ArrPag[I].TemPesquisa) Then        // Linha com pesquisa
      If EhPrimeiro  Then
        Begin
        EhPrimeiro := False;
        Inicio := FTTop+2+Abs(Video.Height)+2;
        End;

    If Not Mascara Then
      Begin
      DFEngine1.Pages[0].AddFrame;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Width := DFEngine1.Pages[0].Width-4;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Height := FTHeight-HCor;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].FrameType := dfSquare;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenStyle := psSolid;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenColor := ArrPag[I].CorDeFundo;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenWidth := 1;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushStyle := bsSolid;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushColor := ArrPag[I].CorDeFundo;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Left := FTLeft;
      DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Top := FTTop+2;

      If ((UsouLocalizar) And (I = LinhaLocalizada)) Then
        Begin
        DFEngine1.Pages[0].AddFrame;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Width := (TamLocalizada) * Abs(Video.Size-1);
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Height := FTHeight-HCor;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].FrameType := dfSquare;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenStyle := psSolid;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenColor := clYellow;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenWidth := 1;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushStyle := bsSolid;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushColor := clYellow;
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Left := (ColunaLocalizada-1) * (Abs(Video.Size)-1);
        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Top := FTTop+2;
        UsouLocalizar := False;
        End;

      For IC := 1 To 10 Do
        If ArrPag[I].CamposT[IC] Then
          Begin
          DFEngine1.Pages[0].AddFrame;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Width := (ListaDeCampos[IC].TamCampo) * Abs(Video.Size-1);
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Height := FTHeight-HCor;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].FrameType := dfSquare;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenStyle := psSolid;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenColor := clYellow;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenWidth := 1;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushStyle := bsSolid;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushColor := clYellow;
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Left := (ListaDeCampos[IC].PosCampo-1) * (Abs(Video.Size)-1);
          DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Top := FTTop+2;
          End;

      End;

//      End
//    Else
//      If (ArrPag[I].CorDeFundo <> clWhite) And (Not (Mascara)) Then
//      If (Not (ArrPag[I].TemPesquisa)) And (Not (Mascara)) Then
//        Begin
//        DFEngine1.Pages[0].AddFrame;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Width := DFEngine1.Pages[0].Width-4;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Height := FTHeight-HCor;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].FrameType := dfSquare;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenStyle := psSOlid;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenColor := ArrPag[I].CorDeFundo;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].PenWidth := 1;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushStyle := bsSolid;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].BrushColor := ArrPag[I].CorDeFundo;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Left := FTLeft;
//        DFEngine1.Pages[0].Frames[DFEngine1.Pages[0].FrameCount-1].Top := FTTop+2;
//        End;

    If Mascara Then
      Begin
      If IField.Expression = '' Then
        Begin
        DFEngine1.Pages[0].AddText;
        With DFEngine1.Pages[0].Text[DFEngine1.Pages[0].TextCount-1] Do
          Begin
          Tag := IField.Tag;
          FontColor := IField.FontColor;
          FontName := IField.FontName;
          FontSize := IField.FontSize;
          FontStyle := IField.FontStyle;
          Visible := IField.Visible;
          AutoSize := False;
          Left := FTLeft;
          Top := FTTop;
          Width := DFEngine1.Pages[0].Width-4;
          Height := FTHeight;
          Text := ArrPag[I].LinhaRel;
          End;
        End
      Else
        Begin
        LinAux := IField.Expression;
        If LinAux[1] = '=' Then
          J := StrToInt(Copy(LinAux,2,Length(LinAux)-1))
        Else
//          J := (I+1);
          J := (IndField+1);
        IFieldAux := DFEngine1.FindField('Field'+IntToStr(J));
        LinAux := IFieldAux.Expression;
        If LinAux[Length(LinAux)] <> ',' Then
          LinAux := LinAux + ','; // Facilitar a lógica do loop embaixo
        Posic := Pos(',',LinAux);
        DetAux := ArrPag[I].LinhaRel;
        PosAtu := 0;
        While Posic <> 0 Do
          Begin
          DFEngine1.Pages[0].AddText;
          With DFEngine1.Pages[0].Text[DFEngine1.Pages[0].TextCount-1] Do
            Begin
            Tag := IFieldAux.Tag;
            FontColor := IFieldAux.FontColor;
            FontName := IFieldAux.FontName;
            FontStyle := IFieldAux.FontStyle;
            FontSize := IFieldAux.FontSize;
            Visible := IFieldAux.Visible;
            AutoSize := True;
            Left := FTLeft;
            Top := FTTop;
            Width := DFEngine1.Pages[0].Width-4;
            Height := FTHeight;
            Text := TrimRight(Copy(DetAux,1,StrToInt(Copy(LinAux,1,Posic-1))));
            End;
          Delete(DetAux,1,StrToInt(Copy(LinAux,1,Posic-1)));
          Delete(LinAux,1,Posic);
          Posic := Pos(',',LinAux);
          If Posic <> 0 Then
            Begin
            Inc(PosAtu);
            FTLeft := DFEngine1.FieldByName('Field'+IntToStr(J)+'_'+IntToStr(PosAtu)).Left;
            End;
          End;
        End;
      IField.AsString := '';
      End
    Else
      Begin
      DFEngine1.Pages[0].AddText;
      With DFEngine1.Pages[0].Text[DFEngine1.Pages[0].TextCount-1] Do
        Begin
        Tag := 0;
        FontColor := ArrPag[I].CorDaFonte;
        FontName := Video.Name;
        FontStyle := Video.Style;
        FontSize := Video.Size;
        AutoSize := False;
        Left := FTLeft;
        Top := FTTop;
        Width := DFEngine1.Pages[0].Width-4;
        Height := FTHeight;
        If Length(ArrBloqCampos) = 0 Then
          Text := ArrPag[I].LinhaRel
        Else
          Text := TrataBloqueio(ArrPag[I].LinhaRel, I+1);
        End;
      End;
    End;

    FrameForm.mScreenWidthClick(LastScale);

    DFEngine1.EndUpdate;

    If EhPrimeiro Then
      ScrollBox1.VertScrollBar.Position := 0
    Else
      If Inicio > ScrollBox1.Height Then
        ScrollBox1.VertScrollBar.Position := (Inicio - ScrollBox1.Height) + 200
      Else
        ScrollBox1.VertScrollBar.Position := 0;

//    End
//  Else
//    Begin
//    FastImageReload;
//    End;
  End;

VerificaAnotacao;
End;

Procedure TEditForm.FormCreate(Sender: TObject);
Begin
temPesquisa := false;
//soapConnection1.URL := RemoteDataServer;
Memo1.Align := alClient;
SCrollBox1.Align := alClient;
WindowState := wsMaximized;
Memo1.Clear;
Memo1.Visible := False;
ZoomLevel := 0;
FezAnotacoesGraficas := False;
FezAnotacoesDeTexto := False;
Image2.Canvas.Brush.Style := bsClear;
Image2.Width := 1;
AnotaForm := TAnotaForm.Create(Self);
AnotaTextoForm := TAnotaTextoForm.Create(Self);
DfActiveDisplay1.Left := 0;
DfActiveDisplay1.Top := 0;
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

SelCampo.Campos.RowCount := DefChave.RowCount;
For I := 1 To DefChave.RowCount-1 Do
  Begin
  SelCampo.Campos.Cells[0,I] := IntToStr(I);
  SelCampo.Campos.Cells[1,I] := DefChave.Cells[6,I];
  SelCampo.Campos.Cells[2,I] := DefChave.Cells[7,I];
  SelCampo.Campos.Cells[3,I] := DefChave.Cells[3,I];
  End;
SelCampo.Campos.Cells[1,0] := 'Campo';
SelCampo.Campos.Cells[2,0] := 'Tipo';
SelCampo.Campos.Cells[3,0] := 'Col';

(*
With SelCampo.Campos Do
  Begin
  RowCount := DefChave.RowCount;
  For I := 1 To DefChave.RowCount-1 Do
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
*)

If TemAnotacaoDeTexto Then
  FrameForm.Animate1.Visible := True
Else
  FrameForm.Animate1.Visible := False;

If TemAnotacaoGrafica Then
  FrameForm.Animate2.Visible := True
Else
  FrameForm.Animate2.Visible := False;

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

Procedure TEditForm.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
(*If (ssCtrl In Shift) Then
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
    End; {Case}*)
End;

Procedure TEditForm.RestauraPosArqPsq;
Begin
Seek(ArqPsq,FrameForm.ScrollBar1.Position);
{$i-}
Read(ArqPsq,RegPsq);
{$i+}
If IoResult <> 0 Then
  Begin
  FormGeral.MostraMensagem('Erro de Seek Prn');
  Halt;
  End;

If RelRemoto Then
//  Begin
//  ClientDataSet1.First;
//  ClientDataSet1.MoveBy(RegPsq.PosQuery-1);
//  End
Else
  Begin
//  Query1.First;
//  Query1.MoveBy(RegPsq.PosQuery-1);

  Seek(ArqPag64,gridQueryFacil[RegPsq.PosQuery].Pagina - 1);  { inicia de 0 }
  Read(ArqPag64,RegPag64);
  End;
End;

Procedure TEditForm.Memo1KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
Begin
Posic := Memo1.SelStart + 1;
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
I := 1;
While I < Posic Do
  Begin
  If ((StrAux[I]) = #13) Then
    begin
//    Inc(Posic); // Agora o SelStart não conta mais o CRLF, porém na virada de linha já retorna +1
    Col := 1;
    end
  else
  If ((StrAux[I]) = #10) Then
    Begin
    Inc(Lin);
    Inc(Posic);
    End
  Else
    Inc(Col);
  Inc(I);
  End;
FrameForm.Label3.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
End;

Procedure TEditForm.Memo1KeyUp(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
Begin
Posic := Memo1.SelStart + 1;
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
I := 1;
While I < Posic Do
  Begin
  If ((StrAux[I]) = #13) Then
    begin
//    Inc(Posic); // Agora o SelStart não conta mais o CRLF, porém na virada de linha já retorna +1
    Col := 1;
    end
  else
  If ((StrAux[I]) = #10) Then
    Begin
    Inc(Lin);
    Inc(Posic);
    End
  Else
    Inc(Col);
  Inc(I);
  End;
FrameForm.Label3.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
End;

Procedure TEditForm.Memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
Begin
Posic := Memo1.SelStart + 1;   // SelStart começa relativo a 0
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
I := 1;
While I < Posic Do
  Begin
  If ((StrAux[I]) = #13) Then
    begin
//    Inc(Posic); // Agora o SelStart não conta mais o CRLF, porém na virada de linha já retorna +1
    Col := 1;
    end
  else
  If ((StrAux[I]) = #10) Then
    Begin
    Inc(Posic); // Agora o SelStart não conta mais o CRLF...
    Inc(Lin);
    End
  Else
    Inc(Col);
  Inc(I);
  End;
FrameForm.Label3.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
End;

Procedure TEditForm.Memo1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
Begin
Posic := Memo1.SelStart + 1;
StrAux := Memo1.Text;
Lin := 1;
Col := 1;
I := 1;
While I < Posic Do
  Begin
  If ((StrAux[I]) = #13) Then
    begin
    Col := 1;
//    Inc(Posic); // Agora o SelStart não conta mais o CRLF, porém na virada de linha já retorna +1
    end
  else
  If ((StrAux[I]) = #10) Then
    Begin
    Inc(Lin);
    Inc(Posic);
    End
  Else
    Inc(Col);
  Inc(I);
  End;
FrameForm.Label3.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
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

procedure TEditForm.ComFormulrio1Click(Sender: TObject);
Begin
ComFormulrio1.Checked := ComFormulrio1.Checked XOr True;
ComFormulrio2.Checked := ComFormulrio2.Checked XOr True;
//CarregaImagem(RegPag64,MarcaAtu,PaginaAtu);
CarregaImagem(MarcaAtu,PaginaAtu);
End;

procedure TEditForm.DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
begin
  with Image2.Canvas do
  begin
    Pen.Mode := AMode;
    case DrawingTool of
      dtLine,
      dtFree:
        begin
          Image2.Canvas.MoveTo(TopLeft.X, TopLeft.Y);
          Image2.Canvas.LineTo(BottomRight.X, BottomRight.Y);
        end;
      dtRectangle: Image2.Canvas.Rectangle(TopLeft.X, TopLeft.Y, BottomRight.X,
        BottomRight.Y);
      dtEllipse: Image2.Canvas.Ellipse(Topleft.X, TopLeft.Y, BottomRight.X,
        BottomRight.Y);
      dtRoundRect: Image2.Canvas.RoundRect(TopLeft.X, TopLeft.Y, BottomRight.X,
        BottomRight.Y, (TopLeft.X - BottomRight.X) div 2,
        (TopLeft.Y - BottomRight.Y) div 2);
    end;
  end;
end;

Procedure TEditForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  If FezAnotacoesGraficas Then
    Drawing := True
  Else
    Drawing := False;  
  Image2.Canvas.MoveTo(X, Y);
  Origin := Point(X, Y);
  MovePt := Origin;
//  StatusBar1.Panels[0].Text := Format('Origin: (%d, %d)', [X, Y]);
End;

procedure TEditForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Drawing then
    If DrawingTool = dtFree Then
      Drawing := False
    Else
      begin
        DrawShape(Origin, Point(X, Y), pmCopy);
        Drawing := False;
      end;
end;

procedure TEditForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If Drawing Then
    If DrawingTool = dtFree Then
      Begin
        DrawShape(Origin, Point(X, Y), pmCopy);
        Origin := Point(X, Y);
      End
    Else
      Begin
        DrawShape(Origin, MovePt, pmNotXor);
        MovePt := Point(X, Y);
        DrawShape(Origin, MovePt, pmNotXor);
      End;
//  StatusBar1.Panels[1].Text := Format('Current: (%d, %d)', [X, Y]);
end;

Procedure TEditForm.PrintPageBMP;
Var
  PgPrn : TBitMap;
Begin

If DFActiveDisplay1.Width <> 0 Then
  FrameForm.MoveDFActiveParaImage1;

PgPrn := TBitMap.Create;
PgPrn.Width := Image1.Width;
PgPrn.Height := Image1.Height;
PgPrn.Canvas.CopyMode := cmSrcCopy;
PgPrn.Canvas.Draw(0,0,Image1.Picture.Bitmap);
If Image2.Visible Then
  Begin
  PgPrn.Canvas.CopyMode := cmSrcPaint;
  PgPrn.Canvas.Draw(0,0,Image2.Picture.Bitmap);
  End;

PrintBitMap(PgPrn, 0, 0);

PgPrn.Free;
End;

Procedure TEditForm.PrintPage(Sender: TObject);
Var
  PgPrn : TBitMap;
Begin
If PrintDialog1.Execute Then
  Begin
  If DFActiveDisplay1.Width <> 0 Then
    FrameForm.MoveDFActiveParaImage1;
  PgPrn := TBitMap.Create;
  PgPrn.Width := Image1.Width;
  PgPrn.Height := Image1.Height;
  PgPrn.Canvas.CopyMode := cmSrcCopy;
  PgPrn.Canvas.Draw(0,0,Image1.Picture.Bitmap);
  If Image2.Visible Then
    Begin
    PgPrn.Canvas.CopyMode := cmSrcPaint;
    PgPrn.Canvas.Draw(0,0,Image2.Picture.Bitmap);
    End;
    
  Printer.BeginDoc;
  PrintBitMap(PgPrn, 0, 0);
  Printer.EndDoc;
  PgPrn.Free;
  End;
End;

Procedure TEditForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
Begin
ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position + 10;
End;

Procedure TEditForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
Begin
If ScrollBox1.VertScrollBar.Position <> 0 Then
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - 10;
End;

Procedure TEditForm.PrintPageBMP1Click(Sender: TObject);
Begin
FrameForm.Imprimir.Click;
End;

End.

