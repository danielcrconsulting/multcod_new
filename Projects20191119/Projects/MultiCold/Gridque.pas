Unit Gridque;

Interface

Uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, SysUtils, SCampo, Opera, Conec, Dialogs, SuGeral, SuTypGer;

Type
  TQueryDlg = Class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GridPesq: TStringGrid;
    ScrollBar1: TScrollBar;
    LabelScrollQue: TLabel;
    LimparBitBtn: TBitBtn;
    Salvar: TBitBtn;
    Ler: TBitBtn;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ProcurNaMesma: TCheckBox;
    ProcurSeq: TCheckBox;
    OkEspBtn: TBitBtn;
    Procedure FormCreate(Sender: TObject);
    Procedure GridPesqDblClick(Sender: TObject);
    Procedure OKBtnClick(Sender: TObject);
    Procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      Var ScrollPos: Integer);
    Procedure LimparBitBtnClick(Sender: TObject);
    Procedure SalvarClick(Sender: TObject);
    Procedure LerClick(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure GridPesqKeyUp(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

  TFooClass = Class(TControl);  {needed to get at protected font property }

Var
  QueryDlg: TQueryDlg;

Implementation

uses ExeEspecialU, EspecialU;

{$R *.DFM}

Procedure TQueryDlg.FormCreate(Sender: TObject);
Var
  I : Integer;
Begin

For I := 1 to 26 Do
  GridPesq.Cells[0,I] := Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZ',I,1);
GridPesq.Cells[1,0] := 'Campo';
GridPesq.Cells[2,0] := 'Operador';
GridPesq.Cells[3,0] := 'Valor';
GridPesq.Cells[4,0] := 'Conector';
ScrollBar1.Min := 0;
ScrollBar1.Max := 0;
ScrollBar1.Position := 0;
LabelScrollQue.Caption := '0 de 0';

Exit;  // Não Reformata a tela pela resolução de vídeo atual ...

If (Screen.Width > ScreenWidth) Then
  Begin
  scaled := true;
  height := longint(height) * longint(screen.height) Div ScreenHeight;
  width := longint(width) * longint(screen.width) Div ScreenWidth;
  scaleBy(Screen.Width, ScreenWidth);
  For I := ControlCount - 1 Downto 0 Do
    TFooClass(Controls[I]).Font .Size := (Width Div ScreenWidth) *
                                         TFooClass(Controls[i]).Font.Size;
  End;
End;

Procedure TQueryDlg.GridPesqDblClick(Sender: TObject);
Begin
Case GridPesq.Col Of
  1 : Begin
      SelCampo.ShowModal;
      If CampoSel = 0 Then
        Exit;
      GridPesq.Cells[GridPesq.Col,GridPesq.Row] := SelCampo.Campos.Cells[1,CampoSel];
      End;
  2 : Begin
      FormOpera.ShowModal;
      If CampoOperaSel = 0 Then
        Exit;
      GridPesq.Cells[GridPesq.Col,GridPesq.Row] := FormOpera.GridOpera.Cells[1,CampoOperaSel];
      End;
  4 : Begin
      FormConec.ShowModal;
      If CampoConecSel = 0 Then
        Exit;
      GridPesq.Cells[GridPesq.Col,GridPesq.Row] := FormConec.GridConec.Cells[1,CampoConecSel];
      End;
  End; {Case}
End;

Procedure TQueryDlg.OKBtnClick(Sender: TObject);
Var
  I,J : Integer;
  Linha : TgStr255;
  Old : Byte;
  Prima : Boolean;
Begin

If Sender = OkEspBtn Then         // Uma forma de permitir a repetição da especial a partir daqui sem ir ao EspecialU
  PesquisaEspecial := True;

Old := FileMode;
FileMode := 2;
Reset(ArqQue);
Seek(ArqQue,FileSize(ArqQue));
If FilePos(ArqQue) <> 0 Then
  ScrollBar1.Max := ScrollBar1.Max + 1;
Prima := True;
//For I := 1 To 1000 Do
For I := 1 To 26 Do
  If GridPesq.Cells[1,I] <> '' Then
    For J := 1 to 4 Do
      Begin
      If Prima Then
        Begin
        Prima := False;
        Linha := 'INICIO DE QUERY';
        Write(ArqQue,Linha);
        End;
      Linha := GridPesq.Cells[J,I];
      Write(ArqQue,Linha);
      End
  Else
    Break;
LabelScrollQue.Caption := IntToStr(ScrollBar1.Max+1)+' de '+IntToStr(ScrollBar1.Max+1);
ScrollBar1.Position := ScrollBar1.Max;
FileMode := Old;
If PesquisaEspecial Then
  If ExecutarEspecial.ListBox1.Count = 0 Then
    Begin
//    ExecutarEspecial.ListBox1.Clear;
    For I := 1 To Especial.StringGrid1.RowCount-1 Do
      ExecutarEspecial.ListBox1.Items.Add(Especial.StringGrid1.Cells[1,I]);
    ExecutarEspecial.ShowModal;
    End;
End;

Procedure TQueryDlg.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; Var ScrollPos: Integer);
Var
  Cont,I,J : Integer;
  Linha : TgStr255;
Begin
If ScrollCode <> scEndScroll Then
  Exit;
If ScrollBar1.Max <= 0 Then
  Exit;
Cont := 0;
Seek(ArqQue,0);
If Not Eof(ArqQue) Then
  Read(ArqQue,Linha);
While (Cont <> Scrollpos) And (Not Eof(ArqQue)) Do
  Begin
  Read(ArqQue,Linha);
  If Linha = 'INICIO DE QUERY' Then
    Inc(Cont);
  End;

For I := 1 to 1000 Do
  If GridPesq.Cells[1,I] <> '' Then
    For J := 1 to 4 Do
      GridPesq.Cells[J,I] := ''
  Else
    Break;

Linha := '';
Cont := 1;
If Not Eof(ArqQue) Then
  Read(ArqQue,Linha);
While (Linha <> 'INICIO DE QUERY') And (Not Eof(ArqQue)) Do
  Begin
  If Linha <> 'INICIO DE QUERY' Then
    Begin
    For J := 1 To 4 Do
      Begin
      GridPesq.Cells[J,Cont] := Linha;
      If Not Eof(ArqQue) Then
        Read(ArqQue,Linha);
      End;
    End;
  Inc(Cont);
  End;
LabelScrollQue.Caption := IntToStr(ScrollPos+1)+' de '+IntToStr(ScrollBar1.Max+1);
End;

Procedure TQueryDlg.LimparBitBtnClick(Sender: TObject);
Var
  I,J : Integer;
Begin
For I := 1 To 100 Do
  For J := 1 To 4 Do
    GridPesq.Cells[J,I] := '';
ProcurNaMesma.Checked := False;
ProcurSeq.Checked := False;
End;

Procedure TQueryDlg.SalvarClick(Sender: TObject);
Var
  I,J : Integer;
  Arq : System.Text;
Begin
SaveDialog1.InitialDir := 'C:\ColdCfg';
If SaveDialog1.Execute Then
  Begin
  If Pos('.SQL',UpperCase(SaveDialog1.FileName)) <> 0 Then
    AssignFile(Arq,SaveDialog1.FileName)
  Else
    AssignFile(Arq,SaveDialog1.FileName+'.sql');
  ReWrite(Arq);
  For I := 1 To 1000 Do
    If GridPesq.Cells[1,I] <> '' Then
      For J := 1 To 4 Do
        WriteLn(Arq,GridPesq.Cells[J,I])
    Else
      Break;
  If ProcurNaMesma.Checked Then
    WriteLn(Arq,'Procur Na Mesma =True')
  Else
    WriteLn(Arq,'Procur Na Mesma =False');
  If ProcurSeq.Checked Then
    WriteLn(Arq,'Procur Seq =True')
  Else
    WriteLn(Arq,'Procur Seq =False');
  CloseFile(Arq);
  End;
End;

Procedure TQueryDlg.LerClick(Sender: TObject);
Var
  I,J : Integer;
  Arq : System.Text;
  Linha : TgStr255;
Begin
OpenDialog1.InitialDir := 'C:\ColdCfg';
If OpenDialog1.Execute Then
  Begin
  LimparBitBtn.Click;
  AssignFile(Arq,OpenDialog1.FileName);
  Reset(Arq);
  I := 1;
  ProcurNaMesma.Checked := False;
  ProcurSeq.Checked := False;
  While Not Eof(Arq) Do
    Begin
    For J := 1 To 4 Do
      If Not Eof(Arq) Then
        Begin
        ReadLn(Arq,Linha);
        If Copy(Linha,1,17) = 'Procur Na Mesma =' Then
          Begin
          If Copy(Linha,18,4) = 'True' Then
            ProcurNaMesma.Checked := True;
          End
        Else
        If Copy(Linha,1,12) = 'Procur Seq =' Then
          Begin
          If Copy(Linha,13,4) = 'True' Then
            Begin
            ProcurSeq.Checked := True;
            Break;
            End;
          End
        Else
          GridPesq.Cells[J,I] := Linha;
        End;
    Inc(I);
    End;
  CloseFile(Arq);
  End;
End;

Procedure TQueryDlg.FormShow(Sender: TObject);
Begin
OkBtn.SetFocus;
End;

Procedure TQueryDlg.GridPesqKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Begin
If Key = 13 Then
  OkBtn.Click;  
End;

End.
