Unit EspecialU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

Type
  TEspecial = Class(TForm)
    AbrBut: TButton;
    SalvarBut: TButton;
    LimparBut: TButton;
    FecharBut: TButton;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    IndicesEdit: TEdit;
    ArquivosEdit: TEdit;
    DimensionarBut: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    ExeBut: TButton;
    OpenDialog2: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure DimensionarButClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure SalvarButClick(Sender: TObject);
    procedure AbrButClick(Sender: TObject);
    procedure LimparButClick(Sender: TObject);
    procedure ExeButClick(Sender: TObject);
    procedure FecharButClick(Sender: TObject);
  Private
    { Private declarations }
  Public

    { Public declarations }

    Procedure AbreEspecial;
    Procedure FechaEspecial;
  End;

Var
  Especial: TEspecial;

Implementation

Uses MdiMultiCold, Subrug, Sugeral, Descom, Imprim, Gridque, ExeEspecialU;

{$R *.DFM}

Procedure TEspecial.AbreEspecial;
Begin
ExecutarEspecial.ListBox1.Clear;
PesquisaEspecial := True;
QueryDlg.OkEspBtn.Enabled := True;
FrmDescom.RadioPagAtu.Enabled := False;
FrmDescom.RadioPag.Enabled := False;
FrmDescom.RadioTudo.Enabled := False;
FrmDescom.RadioPesq.Checked := True;
FrmDescom.Edit1.Enabled := False;
FrmDescom.Edit2.Enabled := False;
FrmImprim.ImpriAtuRdBut.Enabled := False;
FrmImprim.ImpriRangeRdBut.Enabled := False;
FrmImprim.ImpriTudoRdBut.Enabled := False;
FrmImprim.ImpriPesqRdBut.Checked := True;
FrmImprim.Edit1.Enabled := False;
FrmImprim.Edit2.Enabled := False;
End;

Procedure TEspecial.FechaEspecial;
Begin
PesquisaEspecial := False;
FrmDescom.RadioPagAtu.Enabled := True;
FrmDescom.RadioPag.Enabled := True;
FrmDescom.RadioTudo.Enabled := True;
FrmDescom.RadioPesq.Checked := False;
FrmDescom.Edit1.Enabled := True;
FrmDescom.Edit2.Enabled := True;
FrmImprim.ImpriAtuRdBut.Enabled := True;
FrmImprim.ImpriRangeRdBut.Enabled := True;
FrmImprim.ImpriTudoRdBut.Enabled := True;
FrmImprim.ImpriPesqRdBut.Checked := False;
FrmImprim.Edit1.Enabled := True;
FrmImprim.Edit2.Enabled := True;
End;

Procedure TEspecial.DimensionarButClick(Sender: TObject);
Var
  I : Integer;
Begin
Try
  I := StrToInt(IndicesEdit.Text);
Except
  IndicesEdit.Text := '1';
  I := 1;
End;
If (I < 1) Or (I > 99) Then
  Begin
  IndicesEdit.Text := '1';
  I := 1;
  End;
StringGrid1.ColCount := I+3;

Try
  I := StrToInt(ArquivosEdit.Text);
Except
  ArquivosEdit.Text := '1';
  I := 1;
End;
If (I < 1) Or (I > 9999) Then
  Begin
  ArquivosEdit.Text := '1';
  I := 1;
  End;
StringGrid1.RowCount := I+1;

StringGrid1.Cells[1,0] := 'Apelido';
StringGrid1.Cells[2,0] := 'Dat';
For I := 1 To StrToInt(IndicesEdit.Text) Do
  StringGrid1.Cells[2+I,0] := 'Índice '+
           Format('%'+IntToStr(Length(IndicesEdit.Text))+'.'+IntToStr(Length(IndicesEdit.Text))+'d',[I]);
For I := 1 To StrToInt(ArquivosEdit.Text) Do
  StringGrid1.Cells[0,I] := 'Relatório '+
           Format('%'+IntToStr(Length(ArquivosEdit.Text))+'.'+IntToStr(Length(ArquivosEdit.Text))+'d',[I]);
End;

Procedure TEspecial.FormCreate(Sender: TObject);
Begin
IndicesEdit.Text := '1';
ArquivosEdit.Text := '4';
DimensionarBut.Click;
Label3.Caption := '';
End;

Procedure TEspecial.StringGrid1DblClick(Sender: TObject);
Begin
If OpenDialog2.FileName <> '' Then
  OpenDialog2.InitialDir := ExtractFilePath(OpenDialog2.FileName)
Else
  OpenDialog2.InitialDir := FrameForm.OpenReportDialog.InitialDir;
If (StringGrid1.Col = 2) And (StringGrid1.Row > 0) Then
  Begin
  OpenDialog2.Filter := '*.dat|*.dat';
  If OpenDialog2.Execute Then
    StringGrid1.Cells[StringGrid1.Col,StringGrid1.Row] := OpenDialog2.FileName;
  End;
If (StringGrid1.Col > 2) And (StringGrid1.Row > 0) Then
  Begin
  OpenDialog2.Filter := '*.dbf|*.dbf';
  If OpenDialog2.Execute Then
    StringGrid1.Cells[StringGrid1.Col,StringGrid1.Row] := OpenDialog2.FileName;
  End;
End;

Procedure TEspecial.SalvarButClick(Sender: TObject);
Var
  Arq : System.Text;
  I, J,
  UCol : Integer;
  Linha : String;
  Ok : Boolean;
Begin
SaveDialog1.InitialDir := 'C:\ColdCfg';
SaveDialog1.DefaultExt := 'pes';
SaveDialog1.Filter := '*.pes|*.pes';
If SaveDialog1.Execute Then
  Begin
  Label3.Caption := ExtractFileName(SaveDialog1.FileName);
  I := StringGrid1.RowCount-1;
  While (StringGrid1.Cells[1,I] = '') And (I > 0) Do
    Dec(I);
  If I = 0 Then
    I := 1;
  ArquivosEdit.Text := IntToStr(I);

  Ucol := StringGrid1.ColCount-1;
  Ok := False;
  For J := StringGrid1.ColCount-1 DownTo 4 Do
    Begin
    For I := 1 To StringGrid1.RowCount-1 Do
      If StringGrid1.Cells[J,I] <> '' Then
        Begin
        Ok := True;
        UCol := J;
        Break;
        End;
    If Ok Then
      Break;
    UCol := J-1;
    End;
  IndicesEdit.Text := IntToStr(UCol-2);

  DimensionarBut.Click;

  AssignFile(Arq,SaveDialog1.FileName);
  ReWrite(Arq);
  For I := 1 To StringGrid1.RowCount-1 Do
    Begin
    Linha := '';
    For J := 1 To StringGrid1.ColCount-1 Do
      Begin
      Linha := Linha + StringGrid1.Cells[J,I] + ^I; // Tab Separado Char=#9
      End;
    WriteLn(Arq,Linha);
    End;
  CloseFile(Arq);
  End;
End;

Procedure TEspecial.AbrButClick(Sender: TObject);
Var
  Arq : System.Text;
  Linha : String;
  I, J : Integer;
Begin
OpenDialog1.InitialDir := 'C:\ColdCfg';
OpenDialog1.DefaultExt := 'pes';
OpenDialog1.Filter := '*.pes|*.pes';
If OpenDialog1.Execute Then
  Begin
  LimparBut.Click;
  Label3.Caption := ExtractFileName(OpenDialog1.FileName);
  AssignFile(Arq,OpenDialog1.FileName);
  Reset(Arq);
  I := 1;
  J := 0;
  While Not Eof(Arq) Do
    Begin
    ReadLn(Arq,Linha);
    If I = 1 Then
      Begin
      For I := 1 To Length(Linha) Do
        If Linha[I] = ^I Then
          Inc(J);
      StringGrid1.ColCount := J+1;
      IndicesEdit.Text := IntToStr(J-2);

      I := 1;
      End;
    Inc(I);
    StringGrid1.RowCount := I;
    J := 1;
    While Pos(^I, Linha) <> 0 Do
      Begin
      StringGrid1.Cells[J,I-1] := Copy(Linha,1,Pos(^I, Linha)-1);
      Inc(J);
      Delete(Linha,1,Pos(^I, Linha));
      End;
    End;
  ArquivosEdit.Text := IntToStr(I-1);
  DimensionarBut.Click;
  CloseFile(Arq);
  End;
End;

Procedure TEspecial.LimparButClick(Sender: TObject);
Var
  I, J : Integer;
Begin
IndicesEdit.Text := '1';
ArquivosEdit.Text := '4';
DimensionarBut.Click;
Label3.Caption := '';
For I := 1 To 3 Do
  For J := 1 To 3 Do
    StringGrid1.Cells[I,J] := '';
End;

Procedure TEspecial.ExeButClick(Sender: TObject);
Var
  I : Integer;
Begin
AbreEspecial;
If StringGrid1.Cells[2,1] = '' Then
  Begin
  ShowMessage('Nenhum script de pesquisa especial carregado...');
  Exit;
  End;
For I := 0 To FrameForm.MDIChildCount - 1 Do
  Try
    FrameForm.MDIChildren[I].Close;
  Except
  End; // Try;
If FrameForm.VerificaSeguranca(StringGrid1.Cells[2,1]) Then
  Begin
  FrameForm.AbreRel(StringGrid1.Cells[2,1], False);
  FrameForm.AbreQueryFacil.Click;
  Close;
  End
Else
  ShowMessage('Usuário '+UpperCase(GetCurrentUserName)+' não autorizado a abrir o relatório '+StringGrid1.Cells[2,1]);
End;

Procedure TEspecial.FecharButClick(Sender: TObject);
Begin
Close;
End;

End.
