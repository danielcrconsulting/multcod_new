Unit Analisador;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, SuGeral, 
  StdCtrls, Menus, ComCtrls, ExtCtrls, Grids, SuTypGer, Subrug, Spin, 
  Db, {DBTables, DBCtrls, DBGrids,} Mask, Buttons, IBX.IBTable, Pilha, Vcl.DBCtrls,
  Vcl.DBGrids;

Type
  TDefReport = Class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Abrir1: TMenuItem;
    Fechar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ConfiguraesdeLeitura1: TMenuItem;
    NmerodeLinhas1: TMenuItem;
    NmerodeColunas1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label24: TLabel;
    Label25: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    TabSheet6: TTabSheet;
    NHSairButton: TButton;
    DBGrid2: TDBGrid;
    AbrGrupBut: TButton;
    FecGrupBut: TButton;
    DBNavigator2: TDBNavigator;
    DataSourceGruposDFN: TDataSource;
    DataSourceSubGruposDFN: TDataSource;
    DBGrid3: TDBGrid;
    AbrSubGBut: TButton;
    FecSubGBut: TButton;
    DBNavigator3: TDBNavigator;
    DataSourceUsuarios: TDataSource;
    TabSheet7: TTabSheet;
    DuSairBut: TButton;
    DBGrid4: TDBGrid;
    AbrUsuBut: TButton;
    DBNavigator4: TDBNavigator;
    FecUsuBut: TButton;
    DataSourceGUsuarios: TDataSource;
    DBGrid5: TDBGrid;
    AbrGUsuBut: TButton;
    FecGUsuBut: TButton;
    DBNavigator5: TDBNavigator;
    TabSheet8: TTabSheet;
    DataSourceDFN: TDataSource;
    DBGrid6: TDBGrid;
    AbrDfnBut: TButton;
    FecDFNBut: TButton;
    DBNavigator6: TDBNavigator;
    RelSairBut: TButton;
    PopupMenu1: TPopupMenu;
    SelecionarDiretrio1: TMenuItem;
    ListBox1: TListBox;
    AddGrupSelSBut: TSpeedButton;
    ClearUsuSelSBut: TSpeedButton;
    AddGrupAllSBut: TSpeedButton;
    ClearUsuAllSBut: TSpeedButton;
    ListBox2: TListBox;
    AtuLB1But: TButton;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ClearRelAllBut: TSpeedButton;
    AddRelAllBut: TSpeedButton;
    ClearRelSelBut: TSpeedButton;
    AddRelSelBut: TSpeedButton;
    FilGBut: TEdit;
    FilSubGBut: TEdit;
    Label40: TLabel;
    Label41: TLabel;
    AtuLB4But: TButton;
    CombBut: TButton;
    TabSheet10: TTabSheet;
    DataSourceUsuRel: TDataSource;
    DBGrid9: TDBGrid;
    DBNavigator9: TDBNavigator;
    AbrUsuRelBut: TButton;
    FecUsuRelBut: TButton;
    UsuRelSairBut: TButton;
    GroupBox4: TGroupBox;
    Label42: TLabel;
    FilUsuEdit: TEdit;
    FilRelEdit: TEdit;
    Label43: TLabel;
    AplFilBut: TButton;
    AltGrupBut: TButton;
    AltSGrupBut: TButton;
    DataSourceLogProc: TDataSource;
    DataSourceProtocolo: TDataSource;
    PopupMenu3: TPopupMenu;
    Alterarcdigoderelatrio1: TMenuItem;
    TabSheet16: TTabSheet;
    DBGrid10: TDBGrid;
    AbrLogProc: TButton;
    FecharLogProc: TButton;
    DBNavigator10: TDBNavigator;
    LogProcSairBut: TButton;
    DBCheckAuto: TDBCheckBox;
    DBEditColAuto: TDBEdit;
    DBEditLinAuto: TDBEdit;
    DBEditTamAuto: TDBEdit;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    PageControl3: TPageControl;
    TabSheet19: TTabSheet;
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    Label10: TLabel;
    TabSheet20: TTabSheet;
    Memo1: TRichEdit;
    Panel2: TPanel;
    Label32: TLabel;
    FilGDestEdit: TEdit;
    TabSheet2: TTabSheet;
    GroupBox5: TGroupBox;
    PageControl2: TPageControl;
    TabSheet12: TTabSheet;
    Label44: TLabel;
    Label45: TLabel;
    Label60: TLabel;
    Label88: TLabel;
    IndNewEdit: TEdit;
    DirTrabAplEdit: TEdit;
    PgmFiltroEdit: TEdit;
    TabSheet17: TTabSheet;
    Label80: TLabel;
    Label81: TLabel;
    Label90: TLabel;
    DirEntraFilEdit: TEdit;
    DirSaiFilEdit: TEdit;
    Button5: TButton;
    TabSheet18: TTabSheet;
    Label82: TLabel;
    Label83: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    BackAutoSNEdit: TEdit;
    ExecAutoSNEdit: TEdit;
    DirBackAutoEdit: TEdit;
    InterExecSegEdit: TEdit;
    TabSheet13: TTabSheet;
    Label46: TLabel;
    Label47: TLabel;
    GrupoEdit: TEdit;
    SubGrupoEdit: TEdit;
    AbrConfBut: TButton;
    FecConfBut: TButton;
    SlvConfBut: TButton;
    PathBaseLocalEdit: TEdit;
    Label1: TLabel;
    ServProdEdit: TEdit;
    Label2: TLabel;
    NBufIOEdit: TEdit;
    Label3: TLabel;
    OtimGerEdit: TEdit;
    ImprButton: TButton;
    PrintDialog1: TPrintDialog;
    Procedure FormCreate(Sender: TObject);
    Procedure Sair1Click(Sender: TObject);
    Procedure NmerodeLinhas1Click(Sender: TObject);
    Procedure NmerodeColunas1Click(Sender: TObject);
    Procedure Abrir1Click(Sender: TObject);
    Procedure Fechar1Click(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure RichEdit1KeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure RichEdit1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure RichEdit1KeyUp(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure AbrGrupButClick(Sender: TObject);
    Procedure FecGrupButClick(Sender: TObject);
    Procedure AbrSubGButClick(Sender: TObject);
    Procedure FecSubGButClick(Sender: TObject);
    Procedure AbrUsuButClick(Sender: TObject);
    Procedure FecUsuButClick(Sender: TObject);
    Procedure DBGrid4DrawColumnCell(Sender: TObject; Const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    Procedure AbrGUsuButClick(Sender: TObject);
    Procedure FecGUsuButClick(Sender: TObject);
    Procedure AbrDfnButClick(Sender: TObject);
    Procedure FecDFNButClick(Sender: TObject);
    Procedure AltGrupButClick(Sender: TObject);
    Procedure AltSGrupButClick(Sender: TObject);
    Procedure AddGrupSelSButClick(Sender: TObject);
    Procedure ClearUsuAllSButClick(Sender: TObject);
    Procedure ClearUsuSelSButClick(Sender: TObject);
    Procedure ListBox1KeyUp(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure AtuLB1ButClick(Sender: TObject);
    Procedure AtuLB4ButClick(Sender: TObject);
    Procedure AddRelSelButClick(Sender: TObject);
    Procedure ClearRelSelButClick(Sender: TObject);
    Procedure AbrUsuRelButClick(Sender: TObject);
    Procedure FecUsuRelButClick(Sender: TObject);
    Procedure CombButClick(Sender: TObject);
    Procedure AplFilButClick(Sender: TObject);
    Procedure SelecionarDiretrio1Click(Sender: TObject);
    Procedure DBGrid6CellClick(Column: TColumn);
    Procedure DBGrid6KeyUp(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure AbrConfButClick(Sender: TObject);
    Procedure FecConfButClick(Sender: TObject);
    Procedure SlvConfButClick(Sender: TObject);
    Procedure FWTEditChange(Sender: TObject);
    Procedure Alterarcdigoderelatrio1Click(Sender: TObject);
    Procedure AbrProtButClick(Sender: TObject);
    Procedure FecProtButClick(Sender: TObject);
    Procedure AbrLogProcClick(Sender: TObject);
    Procedure FecharLogProcClick(Sender: TObject);
    Procedure DBCheckAutoClick(Sender: TObject);
    Procedure Button5Click(Sender: TObject);
    procedure ImprButtonClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }

    StatusTabelas : TgStatus;
    TLinhas,
    TColunas      : Integer;
    ArqUIn        : File;
    TrabalharCRLF : Boolean;
    Buffer        : Array of Char;

    Function  AbreGUsuarios : Boolean;
    Procedure AtualizaCaptions;
    Procedure DFNShowAuto;
    Procedure DFNEscondeCampos;
    Procedure CarregaIni;
    Procedure GuardaStatusEPosicoes;
    Procedure RefreshTabelas(Reposiciona : Boolean);
    End;

Var
  DefReport: TDefReport;

Implementation

Uses Qhelpu, IniFiles, AltCasGrp, AltCasSGrp, InfoImpDfnU, LogInU, MapaFilU;

{$R *.DFM}

Procedure TDefReport.AtualizaCaptions;
Begin
AbrGrupBut.Caption := 'Abrir '+viGrupo;
FecGrupBut.Caption := 'Fechar '+viGrupo;
AbrSubGBut.Caption := 'Abrir '+viSubGrupo;
FecSubGBut.Caption := 'Fechar '+viSubGrupo;

If FormGeral.TableDFN.Active Then
  Begin
  DBGrid6.Columns[2].Title.Caption := viGrupo;
  DBGrid6.Columns[3].Title.Caption := viSubGrupo;
  End;

If FormGeral.TableGruposDFN.Active Then
  Begin
  DbGrid2.Columns[0].Title.Caption := 'Cod '+viGrupo;
  DbGrid2.Columns[1].Title.Caption := 'Nome '+viGrupo;
  End;

If FormGeral.TableSubGruposDFN.Active Then
  Begin
  DbGrid3.Columns[0].Title.Caption := viGrupo;
  DbGrid3.Columns[1].Title.Caption := viSubGrupo;
  DbGrid3.Columns[2].Title.Caption := 'Nome '+viSubGrupo;
  End;

AltGrupBut.Caption := 'Alterar Códigos de '+viGrupo;
AltSGrupBut.Caption := 'Alterar Códigos de '+viSubGrupo;
Label40.Caption := viGrupo;
Label41.Caption := viSubGrupo;
Label32.Caption := viGrupo+' Autorizada';
DBCheckAuto.Caption := viGrupo+' automático';
End;

Procedure TDefReport.CarregaIni;
Begin
IndNewEdit.Text := viIndNew;
PgmFiltroEdit.Text := viPgmFiltro;
DirTrabAplEdit.Text := viDirTrabApl;

PathBaseLocalEdit.Text := viPathBaseLocal;
ServProdEdit.Text := viServProd;
DirEntraFilEdit.Text := viDirEntraFil;
DirSaiFilEdit.Text := viDirSaiFil;
BackAutoSNEdit.Text := viBackAutoSN;
DirBackAutoEdit.Text := viDirBackAuto;
ExecAutoSNEdit.Text := viExecAutoSN;
InterExecSegEdit.Text := viInterExec;
NBufIOEdit.Text := viNBufIO;
OtimGerEdit.Text := viOtimGer;
GrupoEdit.Text := viGrupo;
SubGrupoEdit.Text := viSubGrupo;

AtualizaCaptions;
End;

Procedure TDefReport.FormCreate(Sender: TObject);
Begin
Label10.Caption := '';
WindowState := wsMaximized;
PageControl1.Align := alClient;
RichEdit1.Align := alClient;
Memo1.Align := alClient;
TLinhas := 120;
TColunas := 150;

OpenDialog1.InitialDir := viDirTrabApl;
SaveDialog1.InitialDir := viDirTrabApl;

ListBox3.Clear;
ListBox3.MultiSelect := True;
ListBox3.ExtendedSelect := True;
ListBox3.Sorted := True;

End;

Procedure TDefReport.Sair1Click(Sender: TObject);
Begin
FormGeral.TableGUsuarios.Close;
FormGeral.TableUsuarios.Close;
FormGeral.TableGruposDFN.Close;
FormGeral.TableSubGruposDFN.Close;
FormGeral.TableDFN.Close;
FormGeral.TableUsuRel.Close;
FormGeral.TableProtocolo.Close;
FormGeral.TableLogProc.Close;
Application.ProcessMessages;
Close;
End;

Procedure TDefReport.NmerodeLinhas1Click(Sender: TObject);
Var
  v1Aux : AnsiString;
  v2Aux,
  Err : Integer;
begin
v1Aux := InputBox('Número de Linhas a ler', 'N. Linhas : ', IntToStr(TLinhas));
Val(v1Aux,v2Aux,Err);
if Err <> 0 then
  ShowMessage('Valor informado inválido: '+v1Aux)
Else
  TLinhas := v2Aux;
end;

Procedure TDefReport.NmerodeColunas1Click(Sender: TObject);
Var
  v1Aux : AnsiString;
  v2Aux,
  Err : Integer;
begin
v1Aux := InputBox('Número de Colunas a ler', 'N. Colunas : ', IntToStr(TColunas));
Val(v1Aux,v2Aux,Err);
if Err <> 0 then
  ShowMessage('Valor informado inválido: '+v1Aux)
Else
  TColunas := v2Aux;

end;

Procedure TDefReport.Abrir1Click(Sender: TObject);

Var
  I, J, Max,
  Ret : Integer;
  Linha,
  Linha2 : AnsiString;
  ArqTxt : System.Text;

begin
TrabalharCRLF := False;
SetLength(Buffer,TColunas*Tlinhas+1);
For I := 1 To Length(Buffer) Do
  Buffer[I] := ' ';

OpenDialog1.Filter := '*.*|*.*';
OpenDialog1.FileName := '';

If Not OpenDialog1.Execute then
  Exit;

OpenDialog1.InitialDir := ExtractFilePath(OpenDialog1.FileName);
TabSheet19.Caption := ExtractFileName(OpenDialog1.FileName);

Try
    CloseFile(ArqUIn);
  Except
  End;

AssignFile(ArqUIn, OpenDialog1.FileName);
Reset(ArqUIn,1);

If (FileSize(ArqUIn) < TColunas*Tlinhas) And (FileSize(ArqUIn) > 0) Then
  Max := FileSize(ArqUIn)
Else
  Max := TColunas*Tlinhas;

{$i-}
BlockRead(ArqUIn,Buffer[1],Max,Ret);
{$i+}
If (IoResult <> 0) or (Ret = 0) Then
  Begin
  ShowMessage('Leitura do arquivo resultou em erro');
  CloseFile(ArqUIn);
  Exit;
  End;
For I := 1 To Ret Do
  If (Buffer[I] = #13) And (Buffer[I+1] = #10) Then
    Begin
    TrabalharCRLF := True;
    Break;
    End;

RichEdit1.Clear;
Memo1.Clear;
CloseFile(ArqUIn);

If TrabalharCRLF then
  Begin
  AssignFile(ArqTxt, OpenDialog1.FileName);
  Reset(ArqTxt);
  J := Length(Buffer);

  While Not Eof(ArqTxt) Do
    Begin
    ReadLn(ArqTxt,Linha);
//    For I := 1 To Length(Linha) Do
//      Linha[I] := AscII[Byte(Linha[I])];
    RichEdit1.Lines.Add(Linha);

    Linha2 := '';
    For I := 1 To Length(Linha) do
      If Linha[I] in [#10,#13,' '..'}'] Then
        Linha2 := Linha2 + Linha[I]
      Else
        Linha2 := Linha2 + '#' + IntToStr(Ord(Linha[I])) + '#';
    Memo1.Lines.Add(Linha2);
    Dec(J,Length(Linha));
    If J <= 0 Then
      Break;
    End;
  CloseFile(ArqTxt);
  End
Else
  For I := 0 to (TLinhas-1) Do
    Begin
    Linha := '';
    For J := ((I*TColunas)+1) To (TColunas*(I+1)) do
      If J <= Max Then
        Linha := Linha + {AScII[Byte(}Buffer[J]{)]};
    RichEdit1.Lines.Add(Linha);
    Linha2 := '';
    For J := 1 To Length(Linha) do
      If Linha[J] in [' '..'}'] Then
        Linha2 := Linha2 + Linha[J]
      Else
        Linha2 := Linha2 + '#' + IntToStr(Ord(Linha[J])) + '#';
    Memo1.Lines.Add(Linha2);
    End;

RichEdit1.SelStart := 0;
RichEdit1.SelLength := 1;
Memo1.SelStart := 0;
Memo1.SelLength := 1;
Application.ProcessMessages;

End;

Procedure TDefReport.Fechar1Click(Sender: TObject);
begin
RichEdit1.Clear;
Memo1.Clear;
Try
  CloseFile(ArqUIn);
  Except
  End; // Try
TabSheet19.Caption := 'Arquivo Normal';
End;

Procedure TDefReport.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
RichEdit1.Clear;
Memo1.Clear;
Try
  CloseFile(ArqUIn);
  Except
  End; // Try
End;

Procedure TDefReport.RichEdit1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
Begin

Posic := RichEdit1.SelStart;
StrAux := RichEdit1.Text;
Lin := 1;
Col := 1;
For I := 1 to Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
Label10.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
end;

Procedure TDefReport.RichEdit1KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
begin
Posic := RichEdit1.SelStart;
StrAux := RichEdit1.Text;
Lin := 1;
Col := 1;
For I := 1 to Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
Label10.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
end;

Procedure TDefReport.RichEdit1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
Begin
Posic := RichEdit1.SelStart;
StrAux := RichEdit1.Text;
Lin := 1;
Col := 1;
For I := 1 to Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
Label10.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
End;

Procedure TDefReport.RichEdit1KeyUp(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Var
  Posic,I, Lin, Col : Integer;
  StrAux : AnsiString;
Begin
Posic := RichEdit1.SelStart;
StrAux := RichEdit1.Text;
Lin := 1;
Col := 1;
For I := 1 to Posic Do
  If (StrAux[I] = #13) Then
    Begin
    Inc(Lin);
    Col := 0;
    End
  Else
    Inc(Col);
Label10.Caption := 'Linha '+IntToStr(Lin) + ': Coluna ' + IntToStr(Col);
End;

Function TDefReport.AbreGUsuarios : Boolean;

Begin
Result := False;
Try
  FormGeral.TableGUsuarios.Open;
Except
  ShowMessage('Tabela de Grupos de Usuários não foi criada...');
  Exit;
  End;// Try
Result := True;
End;

Procedure TDefReport.AbrGrupButClick(Sender: TObject);
Begin
FormGeral.TableGruposDFN.Open;
DbGrid2.Columns[0].Title.Caption := 'Cod '+viGrupo;
DbGrid2.Columns[1].Title.Caption := 'Nome '+viGrupo;
End;

Procedure TDefReport.FecGrupButClick(Sender: TObject);
Begin
FormGeral.TableGruposDFN.Close;
End;

Procedure TDefReport.AbrSubGButClick(Sender: TObject);
Begin

FormGeral.TableSubGruposDFN.Open;
GuardaStatusEPosicoes;

DbGrid3.Columns[0].Title.Caption := viGrupo;
DbGrid3.Columns[1].Title.Caption := viSubGrupo;
DbGrid3.Columns[2].Title.Caption := 'Nome '+viSubGrupo;

DbGrid3.Columns.Items[0].PickList.Clear;

FormGeral.TableGruposDFN.Open;
FormGeral.TableGruposDFN.First;
While Not FormGeral.TableGruposDFN.Eof Do
  Begin
  DbGrid3.Columns.Items[0].PickList.Add(FormGeral.TableGruposDFN.Fields[0].asString);
  FormGeral.TableGruposDFN.Next;
  End;
FormGeral.TableGruposDFN.Close;

RefreshTabelas(True);

If FormGeral.TableGruposDFN.Active Then
  Begin
  DbGrid2.Columns[0].Title.Caption := 'Cod '+viGrupo;
  DbGrid2.Columns[1].Title.Caption := 'Nome '+viGrupo;
  End;

End;

Procedure TDefReport.FecSubGButClick(Sender: TObject);
begin
FormGeral.TableSubGruposDFN.Close;
end;

Procedure TDefReport.AbrUsuButClick(Sender: TObject);
Var
  auxActivity : Boolean;
  RecPos : Integer;
Begin
auxActivity := FormGeral.TableGUsuarios.Active;

If Not AbreGUsuarios Then
  Exit;

FormGeral.TableUsuarios.Open;
DbGrid4.DefaultDrawing := False;

DbGrid4.Columns.Items[3].PickList.Clear;
DbGrid4.Columns.Items[3].PickList.Add('S');
DbGrid4.Columns.Items[3].PickList.Add('N');

DbGrid4.Columns.Items[1].PickList.Clear;
RecPos := FormGeral.TableGUsuarios.RecNo;
FormGeral.TableGUsuarios.First;
While Not FormGeral.TableGUsuarios.Eof Do
  Begin
  DbGrid4.Columns.Items[1].PickList.Add(FormGeral.TableGUsuarios.Fields[0].asString);
  FormGeral.TableGUsuarios.Next;
  End;
FormGeral.TableGUsuarios.RecNo := RecPos;
FormGeral.TableGUsuarios.Active := auxActivity;
end;

Procedure TDefReport.FecUsuButClick(Sender: TObject);
begin
FormGeral.TableUsuarios.Close;
end;

Procedure TDefReport.DBGrid4DrawColumnCell(Sender: TObject;
  Const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
Var
  Posic : Integer;
Begin
If DataCol = 2 Then
  Begin
  Posic := (((Rect.Bottom - Rect.Top) - Abs(DbGrid4.Font.Height)) div 2) - 1;
  DbGrid4.Canvas.TextOut(Rect.Left,Rect.Top + Posic,'****************');
  End
Else
  DbGrid4.DefaultDrawColumnCell(Rect,DataCol,Column,State);
End;

Procedure TDefReport.AbrGUsuButClick(Sender: TObject);
Begin
FormGeral.TableGUsuarios.Open;
ListBox1.Clear;
ListBox1.MultiSelect := True;
ListBox1.ExtendedSelect := True;
ListBox1.Sorted := True;

ListBox2.Clear;
ListBox2.MultiSelect := True;
ListBox2.ExtendedSelect := True;
ListBox2.Sorted := True;

While Not FormGeral.TableGUsuarios.Eof Do
  Begin
  ListBox1.Items.Add(FormGeral.TableGUsuarios.Fields[0].AsString);
  FormGeral.TableGUsuarios.Next;
  End;
FormGeral.TableGUsuarios.First;
End;

Procedure TDefReport.FecGUsuButClick(Sender: TObject);
Begin
FormGeral.TableGUsuarios.Close;
ListBox1.Clear;
ListBox2.Clear;
End;

Procedure TDefReport.AbrDfnButClick(Sender: TObject);
Begin
FormGeral.TableDFN.Open;

GuardaStatusEPosicoes;

DbGrid6.Columns[2].PickList.Clear;
FormGeral.TableGruposDFN.Open;
FormGeral.TableGruposDFN.First;
While Not FormGeral.TableGruposDFN.Eof Do
  Begin
  DbGrid6.Columns[2].PickList.Add(FormGeral.TableGruposDFN.Fields[0].asString);
  FormGeral.TableGruposDFN.Next;
  End;
FormGeral.TableGruposDFN.Close;

RefreshTabelas(True);

End;

Procedure TDefReport.FecDFNButClick(Sender: TObject);
Begin
FormGeral.TableDFN.Close;
DFNEscondeCampos;
End;

Procedure TDefReport.DFNEscondeCampos;
Begin
DbEditColAuto.Visible := False;
DBCheckAuto.Checked := DbEditColAuto.Visible;
DbEditLinAuto.Visible := DbEditColAuto.Visible;
DbEditTamAuto.Visible := DbEditColAuto.Visible;
Label75.Visible := DbEditColAuto.Visible;
Label76.Visible := DbEditColAuto.Visible;
Label77.Visible := DbEditColAuto.Visible;
End;

Procedure TDefReport.AltGrupButClick(Sender: TObject);
Begin
AltCasGrupForm.ShowModal;
End;

Procedure TDefReport.AltSGrupButClick(Sender: TObject);
Begin
AltCasSGForm.ShowModal;
End;

Procedure TDefReport.AddGrupSelSButClick(Sender: TObject);
Var
  I, Tot : Integer;
Begin
For I := 0 To (ListBox1.Items.Count - 1) Do
  Begin                       // Neste botão todos os usuários são adicionados
  If (ListBox1.Selected[I]) or (Sender = AddGrupAllSBut) Then
    Begin
    FormGeral.QueryLocal1.Sql.Clear;
    FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuarios.TableName+'" A ');
    FormGeral.QueryLocal1.Sql.Add('WHERE A.NOMEGRUPOUSUARIO = ''' + ListBox1.Items[I]+'''');
    FormGeral.QueryLocal1.Open;
    While Not FormGeral.QueryLocal1.Eof Do
      Begin
      ListBox2.Items.Add(FormGeral.QueryLocal1.Fields[0].AsString);
      FormGeral.QueryLocal1.Next;
      End;
    FormGeral.QueryLocal1.Close;
    End;
  End;
               // Retira os duplicados da lista
I := 0;
Tot := ListBox2.Items.Count - 2;
While I <= Tot Do
  If ListBox2.Items[I] = ListBox2.Items[I+1] Then
    Begin
    ListBox2.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);

End;

Procedure TDefReport.ClearUsuAllSButClick(Sender: TObject);
begin
ListBox2.Clear;
end;

Procedure TDefReport.ClearUsuSelSButClick(Sender: TObject);
Var
  I, Tot : Integer;
begin
I := 0;
Tot := ListBox2.Items.Count - 1;
While I <= Tot Do
  If ListBox2.Selected[I] Then
    Begin
    ListBox2.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);
end;

Procedure TDefReport.ListBox1KeyUp(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Var
  I, Tot : Integer;
Begin
Case Key Of
  46 : Begin
       I := 0;
       Tot := TListBox(Sender).Items.Count - 1;
       While I <= Tot Do
         If TListBox(Sender).Selected[I] Then
           Begin
           TListBox(Sender).Items.Delete(I);
           Dec(Tot);
           End
         Else
           Inc(I);
       End;
  End; // Case
End;

Procedure TDefReport.AtuLB1ButClick(Sender: TObject);
Var
  RecPos : Integer;
Begin
If Not FormGeral.TableGUsuarios.Active Then
  Exit;

Screen.Cursor := crHourGlass;

ListBox1.Clear;
ListBox1.MultiSelect := True;
ListBox1.ExtendedSelect := True;
ListBox1.Sorted := True;

RecPos := FormGeral.TableGUsuarios.RecNo;  // Salva posição do registro para retornar a ele

FormGeral.TableGUsuarios.First;
While Not FormGeral.TableGUsuarios.Eof Do
  Begin
  ListBox1.Items.Add(FormGeral.TableGUsuarios.Fields[0].AsString);
  FormGeral.TableGUsuarios.Next;
  End;

Screen.Cursor := crDefault;
FormGeral.TableGUsuarios.RecNo := RecPos;        // Reposiciona
End;

Procedure TDefReport.AtuLB4ButClick(Sender: TObject);
Begin

Screen.Cursor := crHourGlass;

ListBox4.Clear;
ListBox4.MultiSelect := True;
ListBox4.ExtendedSelect := True;
ListBox4.Sorted := True;

FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT A.CODREL FROM "'+FormGeral.TableDFN.TableName+'" A ');

If FilGBut.Text = '' Then
  If FilSubGBut.Text = '' Then
    Begin
    // Não há necessidade de acrescentar nada à string do sql começada anteriormente
    End
  Else
    Begin
    FormGeral.QueryLocal1.Sql.Add('WHERE A.CODSUBGRUPO = '+FilSubGBut.Text);
    End
Else
  If FilSubGBut.Text = '' Then
    Begin
    FormGeral.QueryLocal1.Sql.Add('WHERE A.CODGRUPO = '+FilGBut.Text);
    End
  Else
    Begin
    FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODGRUPO = '+FilGBut.Text+') AND ');
    FormGeral.QueryLocal1.Sql.Add('      (A.CODSUBGRUPO = '+FilSubGBut.Text+')');
    End;

FormGeral.QueryLocal1.Open;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ListBox4.Items.Add(FormGeral.QueryLocal1.Fields[0].AsString);
  FormGeral.QueryLocal1.Next;
  End;
FormGeral.QueryLocal1.Close;

Screen.Cursor := crDefault;

End;

Procedure TDefReport.AddRelSelButClick(Sender: TObject);
Var
  I, Tot : Integer;
Begin
I := 0;
Tot := ListBox4.Items.Count - 1;
While I <= Tot Do
  Begin                       // Neste botão todos os usuários são adicionados
  If (ListBox4.Selected[I]) or (Sender = AddRelAllBut) Then
    Begin
    ListBox3.Items.Add(ListBox4.Items[I]);
    ListBox4.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);
  End;
               // Retira os duplicados da lista
I := 0;
Tot := ListBox3.Items.Count - 2;
While I <= Tot Do
  If ListBox3.Items[I] = ListBox3.Items[I+1] Then
    Begin
    ListBox3.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);

End;

Procedure TDefReport.ClearRelSelButClick(Sender: TObject);
Var
  I, Tot : Integer;
Begin
I := 0;
Tot := ListBox3.Items.Count - 1;
While I <= Tot Do
  Begin                       // Neste botão todos os usuários são adicionados
  If (ListBox3.Selected[I]) or (Sender = ClearRelAllBut) Then
    Begin
    ListBox4.Items.Add(ListBox3.Items[I]);
    ListBox3.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);
  End;
               // Retira os duplicados da lista
I := 0;
Tot := ListBox4.Items.Count - 2;
While I <= Tot Do
  If ListBox4.Items[I] = ListBox4.Items[I+1] Then
    Begin
    ListBox4.Items.Delete(I);
    Dec(Tot);
    End
  Else
    Inc(I);
End;

Procedure TDefReport.AbrUsuRelButClick(Sender: TObject);
Begin
FormGeral.TableUsuRel.Open;
DbGrid9.Columns[1].Title.Caption := 'Cod '+viGrupo;
DbGrid9.Columns[2].Title.Caption := 'Cod '+viSubGrupo;
DbGrid9.Columns.Items[4].PickList.Clear;
DbGrid9.Columns.Items[4].PickList.Add('INC');
DbGrid9.Columns.Items[4].PickList.Add('EXC');
End;

Procedure TDefReport.FecUsuRelButClick(Sender: TObject);
Begin
FormGeral.TableUsuRel.Close;
End;

Procedure TDefReport.CombButClick(Sender: TObject);
Var
  I, J : Integer;
  Activity : Boolean;
Begin

Screen.Cursor := crHourglass;
Activity := FormGeral.TableUsuRel.Active;

FormGeral.TableUsuRel.Open;
For I := 0 To (ListBox2.Items.Count - 1) Do
  For J := 0 To (ListBox3.Items.Count - 1) Do
    Begin
    Try
      FormGeral.TableUsuRel.Append;
      FormGeral.TableUsuRel.Fields[0].AsString := ListBox2.Items[I];  // Usuário
      If FilGDestEdit.Text <> '' Then                                 // Org
        FormGeral.TableUsuRel.Fields[1].AsString := FilGDestEdit.Text
      Else
        FormGeral.TableUsuRel.Fields[1].AsString := FilGBut.Text;
      If FilSubGBut.Text <> '' Then                                   // Módulo
        FormGeral.TableUsuRel.Fields[2].AsString := FilSubGBut.Text
      Else
        FormGeral.TableUsuRel.Fields[2].AsString := '-999';             
      FormGeral.TableUsuRel.Fields[3].AsString := ListBox3.Items[J];  // Relatório
      FormGeral.TableUsuRel.Fields[4].AsString := 'INC';              // Tipo
      FormGeral.TableUsuRel.Post;
    Except
      FormGeral.TableUsuRel.Cancel;
      End;// Try
    End;

FormGeral.TableUsuRel.Active := Activity;
Screen.Cursor := crDefault;
End;

Procedure TDefReport.AplFilButClick(Sender: TObject);
Begin

FormGeral.TableUsuRel.Open;

If FilUsuEdit.Text = '' Then
  If FilRelEdit.Text = '' Then
    FormGeral.TableUsuRel.Filtered := False
  Else
    Begin
    FormGeral.TableUsuRel.Filtered := True;
    FormGeral.TableUsuRel.Filter := 'CodRel = '''+FilRelEdit.Text+'''';
    End
Else
  If FilRelEdit.Text = '' Then
    Begin
    FormGeral.TableUsuRel.Filtered := True;
    FormGeral.TableUsuRel.Filter := 'CodUsuario = '''+FilUsuEdit.Text+'''';
    End
  Else
    Begin
    FormGeral.TableUsuRel.Filtered := True;
    FormGeral.TableUsuRel.Filter := 'CodUsuario = '''+FilUsuEdit.Text + ''' AND CodRel = '''+FilRelEdit.Text+'''';
    End;

DbGrid9.Columns[1].Title.Caption := 'Cod '+viGrupo;
DbGrid9.Columns[2].Title.Caption := 'Cod '+viSubGrupo;
DbGrid9.Columns.Items[4].PickList.Clear;
DbGrid9.Columns.Items[4].PickList.Add('INC');
DbGrid9.Columns.Items[4].PickList.Add('EXC');
End;

Procedure TDefReport.SelecionarDiretrio1Click(Sender: TObject);
Begin
If Not FormGeral.TableDFN.Active Then
  Exit;
OpenDialog1.Filter := '*.*|*.*';
OpenDialog1.FileName := '';
If OpenDialog1.Execute Then
  Begin

  IF FormGeral.TableDFN.State <> dsEdit Then
    FormGeral.TableDFN.Edit;

  Try
    DbGrid6.SelectedField.Text := ExtractFilePath(OpenDialog1.FileName);
  Except
    ShowMessage('Tabela não está em modo edição');
    End; // Try
  End;
End;

Procedure TDefReport.DBGrid6CellClick(Column: TColumn);
Begin
If DbGrid6.SelectedIndex = 3 Then
  Begin
  GuardaStatusEPosicoes;

  FormGeral.TableSubGruposDFN.Open;
  DbGrid6.Columns[3].PickList.Clear;
  FormGeral.TableSubGruposDFN.First;
  While Not FormGeral.TableSubGruposDFN.Eof Do
    Begin
    Try
      If FormGeral.TableSubGruposDFN.Fields[0].asString = DbGrid6.Columns[2].Field.AsString Then
        DbGrid6.Columns[3].PickList.Add(FormGeral.TableSubGruposDFN.Fields[1].asString);
    Except
      End; // Try
    FormGeral.TableSubGruposDFN.Next;
    End;
  FormGeral.TableSubGruposDFN.Close;

  RefreshTabelas(False);
  End;
End;

Procedure TDefReport.DBGrid6KeyUp(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
If DbGrid6.SelectedIndex = 3 Then
  Begin
  GuardaStatusEPosicoes;

  FormGeral.TableSubGruposDFN.Open;
  DbGrid6.Columns[3].PickList.Clear;
  FormGeral.TableSubGruposDFN.First;
  While Not FormGeral.TableSubGruposDFN.Eof Do
    Begin
    Try
      If FormGeral.TableSubGruposDFN.Fields[0].asString = DbGrid6.Columns[2].Field.AsString Then
        DbGrid6.Columns[3].PickList.Add(FormGeral.TableSubGruposDFN.Fields[1].asString);
    Except
      End; // Try
    FormGeral.TableSubGruposDFN.Next;
    End;
  FormGeral.TableSubGruposDFN.Close;

  RefreshTabelas(False);
  End;
End;

Procedure TDefReport.AbrConfButClick(Sender: TObject);
Begin
IndNewEdit.Visible := True;
PgmFiltroEdit.Visible := True;
DirTrabAplEdit.Visible := True;
PathBaseLocalEdit.Visible := True;
ServProdEdit.Visible := True;
DirEntraFilEdit.Visible := True;
DirSaiFilEdit.Visible := True;
BackAutoSNEdit.Visible := True;
DirBackAutoEdit.Visible := True;
ExecAutoSNEdit.Visible := True;
InterExecSegEdit.Visible := True;
NBufIOEdit.Visible := True;
OtimGerEdit.Visible := True;
GrupoEdit.Visible := True;
SubGrupoEdit.Visible := True;
End;

Procedure TDefReport.FecConfButClick(Sender: TObject);
Begin
IndNewEdit.Visible := False;
PgmFiltroEdit.Visible := False;
DirTrabAplEdit.Visible := False;
PathBaseLocalEdit.Visible := False;
ServProdEdit.Visible := False;
DirEntraFilEdit.Visible := False;
DirSaiFilEdit.Visible := False;
BackAutoSNEdit.Visible := False;
DirBackAutoEdit.Visible := False;
ExecAutoSNEdit.Visible := False;
InterExecSegEdit.Visible := False;
NBufIOEdit.Visible := False;
OtimGerEdit.Visible := False;
GrupoEdit.Visible := False;
SubGrupoEdit.Visible := False;

SlvConfBut.Enabled := False;
End;

Procedure TDefReport.SlvConfButClick(Sender: TObject);
Var
  f : TIniFile;
Begin

If SlvConfBut.Enabled Then
  Begin

  f := TIniFile.Create('MasterCold.Ini');

  f.WriteString('Cold', 'AppName', IndNewEdit.Text);
  f.WriteString('Cold', 'FiltroName', PgmFiltroEdit.Text);
  f.WriteString('Cold', 'DirBase', DirTrabAplEdit.Text);
  f.WriteString('Cold', 'PathLocal', PathBaseLocalEdit.Text);
  f.WriteString('Cold', 'ServProd', ServProdEdit.Text);
  f.WriteString('Filtro', 'DirEntra', DirEntraFilEdit.Text);
  f.WriteString('Filtro', 'DirSai', DirSaiFilEdit.Text);
  f.WriteString('Processa', 'BackAutoSN', BackAutoSNEdit.Text);
  f.WriteString('Processa', 'DirBackAuto', DirBackAutoEdit.Text);
  f.WriteString('Processa', 'ExecAutoSN', ExecAutoSNEdit.Text);
  f.WriteString('Processa', 'InterExec', InterExecSegEdit.Text);
  f.WriteString('Processa', 'BufIO', NBufIOEdit.Text);
  f.WriteString('Processa', 'OtimGer', OtimGerEdit.Text);
  f.WriteString('Nomes', 'Grupo', GrupoEdit.Text);
  f.WriteString('Nomes', 'SubGrupo', SubGrupoEdit.Text);

  f.Free;

  SlvConfBut.Enabled := False;

  AtualizaCaptions;

  LerIni(TheFileName);

  End;
End;

Procedure TDefReport.FWTEditChange(Sender: TObject);
Begin
SlvConfBut.Enabled := True;
End;

Procedure TDefReport.Alterarcdigoderelatrio1Click(Sender: TObject);
Var
  VNovo,
  VOri : AnsiString;
Begin

If Not FormGeral.TableDFN.Active Then
  Exit;

VNovo := '';
VOri := FormGeral.TableDFN.Fields[0].AsString;

VNovo := InputBox('Alterar código de relatório','De : "'+VOri+'" Para : ', VNovo);
If VNovo = '' Then
  Exit;

  // Alteração em cascata do código do relatório
Screen.Cursor := crHourglass;

GuardaStatusEPosicoes;

If FormGeral.IBLogRemotoTransaction.InTransaction Then
  FormGeral.IBLogRemotoTransaction.Commit;

FormGeral.IBLogRemotoTransaction.StartTransaction;

FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableDFN.TableName+'" A WHERE A.CODREL = '''+VOri+'''');
Try
  FormGeral.QueryLocal1.Open;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Erro de leitura na tabela DFN! Teste de código velho');
  Exit;
  End; // Try

If FormGeral.QueryLocal1.Eof Then
  Begin
  FormGeral.QueryLocal1.Close;
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Código anterior não encontrado!');
  Exit;
  End;

FormGeral.QueryLocal1.Close;

FormGeral.QueryLocal2.Sql.Clear;
FormGeral.QueryLocal2.Sql.Add('SELECT * FROM "'+FormGeral.TableDFN.TableName+'" A WHERE A.CODREL = '''+VNovo+'''');
Try
  FormGeral.QueryLocal2.Open;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Erro de leitura na tabela DFN! Teste de código novo');
  Exit;
  End; // Try
If Not FormGeral.QueryLocal2.Eof Then
  Begin
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Novo código informado já existe, alteração não pode ser feita...');
  Exit;
  End; // Try
FormGeral.QueryLocal2.Close;

                    // não há dependências, pode alterar o registro agora!

FormGeral.IBSQLAux1.Sql.Clear;
FormGeral.IBSQLAux1.Sql.Add('DROP TABLE TEMP ');
Try
  FormGeral.IBSQLAux1.ExecQuery;
Except
// Não testa erros pois a tabela pode não existir
  End;

FormGeral.TableTemp.Close;
FormGeral.TableTemp.TableName := 'TEMP';
FormGeral.TableTemp.FieldDefs := FormGeral.TableDFN.FieldDefs;
FormGeral.TableTemp.CreateTable;
FormGeral.IBLogRemotoTransaction.CommitRetaining;

FormGeral.IBSQLAux1.Sql.Clear;
FormGeral.IBSQLAux1.Sql.Add('INSERT INTO TEMP SELECT * FROM "'+FormGeral.TableDFN.TableName+
                            '" A WHERE A.CODREL = '''+VOri+'''');
Try
  FormGeral.IBSQLAux1.ExecQuery;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Erro de alimentação da tabela temporária para armazenagem do código novo..');
  Exit;
  End; // Try

FormGeral.TableTemp.Open;
FormGeral.TableTemp.Edit;
FormGeral.TableTemp.Fields[0].AsString := VNovo;
Try
  FormGeral.TableTemp.Post;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Erro de post na tabela temporária para criação do código novo..');
  Exit;
  End; // Try
FormGeral.TableTemp.Close;

FormGeral.IBSQLAux1.Sql.Clear;
FormGeral.IBSQLAux1.Sql.Add('INSERT INTO '+FormGeral.TableDFN.TableName+' SELECT * FROM TEMP');
Try
  FormGeral.IBSQLAux1.ExecQuery;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Erro de criação do registro com o novo código..');
  Exit;
  End; // Try

FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('UPDATE '+FormGeral.TableUsuRel.TableName + ' A ');
FormGeral.QueryLocal1.Sql.Add('SET A.CODREL = '''+VNovo+'''');
FormGeral.QueryLocal1.Sql.Add('WHERE A.CODREL = '''+VOri+'''');
Try
  FormGeral.QueryLocal1.ExecSQL;
Except
  // Pode não haver registros
  End; // Try

FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('DELETE FROM '+FormGeral.TableDFN.TableName + ' A ');
FormGeral.QueryLocal1.Sql.Add('WHERE A.CODREL = '''+VOri+'''');
Try
  FormGeral.QueryLocal1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  ShowMessage('Erro de DELETE em DFN. Código antigo...');
  Exit;
  End; // Try

FormGeral.IBSQLAux1.Sql.Clear;
FormGeral.IBSQLAux1.Sql.Add('DROP TABLE TEMP ');
Try
  FormGeral.IBSQLAux1.ExecQuery;
Except
  End;

FormGeral.IBLogRemotoTransaction.Commit;

FormGeral.TableDFN.Open;
FormGeral.TableDFN.Locate('CODREL',VNovo,[]);

Screen.Cursor := crDefault;
ShowMessage('Ok!');
End;

Procedure TDefReport.AbrProtButClick(Sender: TObject);
Begin
FormGeral.TableProtocolo.Open;
End;

Procedure TDefReport.FecProtButClick(Sender: TObject);
Begin
FormGeral.TableProtocolo.Close;
End;

Procedure TDefReport.AbrLogProcClick(Sender: TObject);
Begin
FormGeral.TableLogProc.Open;
End;

Procedure TDefReport.FecharLogProcClick(Sender: TObject);
Begin
FormGeral.TableLogProc.Close;
End;

Procedure TDefReport.DFNShowAuto;
Begin
If DbCheckAuto.Checked Then
  Begin
  DbEditColAuto.Visible := True;
  DbEditLinAuto.Visible := DbEditColAuto.Visible;
  DbEditTamAuto.Visible := DbEditColAuto.Visible;
  Label75.Visible := DbEditColAuto.Visible;
  Label76.Visible := DbEditColAuto.Visible;
  Label77.Visible := DbEditColAuto.Visible;
  End
Else
  Begin
  DbEditColAuto.Visible := False;
  DbEditLinAuto.Visible := DbEditColAuto.Visible;
  DbEditTamAuto.Visible := DbEditColAuto.Visible;
  Label75.Visible := DbEditColAuto.Visible;
  Label76.Visible := DbEditColAuto.Visible;
  Label77.Visible := DbEditColAuto.Visible;
  End;
End;

Procedure TDefReport.DBCheckAutoClick(Sender: TObject);
Begin
DFNShowAuto;
End;

Procedure TDefReport.Button5Click(Sender: TObject);
Begin
MapaFil.ShowModal;
End;

Procedure TDefReport.GuardaStatusEPosicoes;
Var
  I : Integer;
Begin
For I := 1 to 6 Do
  Begin
  StatusTabelas[I].TActive := StatusTabelas[I].Tabela.Active;
  If StatusTabelas[I].TActive Then
    StatusTabelas[I].RecordNo := StatusTabelas[I].Tabela.RecNo
  Else
    StatusTabelas[I].RecordNo := 0;
  End;
End;

Procedure TDefReport.RefreshTabelas;
Var
  I : Integer;
Begin
For I := 1 to 6 Do
  Begin
  StatusTabelas[I].Tabela.Active := StatusTabelas[I].TActive;
  If Reposiciona Then
    If StatusTabelas[I].TActive Then
      StatusTabelas[I].Tabela.RecNo := StatusTabelas[I].RecordNo;
  End;
End;

procedure TDefReport.ImprButtonClick(Sender: TObject);
begin
If PrintDialog1.Execute Then
  Begin
  End;
end;

End.

