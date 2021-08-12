unit Gridque;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, SysUtils, SCampo, Opera, Conec, Dialogs, SuGeral, SuTypGer;

type
  TQueryDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GridPesq: TStringGrid;
    ScrollBar1: TScrollBar;
    LabelScrollQue: TLabel;
    BitBtn1: TBitBtn;
    Salvar: TBitBtn;
    Ler: TBitBtn;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ProcurNaMesma: TCheckBox;
    ProcurSeq: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure GridPesqDblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure SalvarClick(Sender: TObject);
    procedure LerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TFooClass = class(TControl);  {needed to get at protected font property }

var
  QueryDlg: TQueryDlg;

implementation

{$R *.DFM}

procedure TQueryDlg.FormCreate(Sender: TObject);
Var
  I : Integer;
begin
For I := 1 to 100 do
  GridPesq.Cells[0,I] := IntToStr(I);
GridPesq.Cells[1,0] := 'Campo';
GridPesq.Cells[2,0] := 'Operador';
GridPesq.Cells[3,0] := 'Valor';
GridPesq.Cells[4,0] := 'Conector';
ScrollBar1.Min := 0;
ScrollBar1.Max := 0;
ScrollBar1.Position := 0;
LabelScrollQue.Caption := '0 de 0';

Exit;  // Não Reformata a tela pela resolução de vídeo atual ...

if (Screen.Width > ScreenWidth) then
  begin
  scaled := true;
  height := longint(height) * longint(screen.height) div ScreenHeight;
  width := longint(width) * longint(screen.width) div ScreenWidth;
  scaleBy(Screen.Width, ScreenWidth);
  for I := ControlCount - 1 downto 0 do
    TFooClass(Controls[I]).Font .Size := (Width div ScreenWidth) *
                                         TFooClass(Controls[i]).Font.Size;
  end;
end;

procedure TQueryDlg.GridPesqDblClick(Sender: TObject);
begin
Case GridPesq.Col of
  1 : begin
      SelCampo.ShowModal;
      if CampoSel = 0 then
        Exit;
      GridPesq.Cells[GridPesq.Col,GridPesq.Row] := SelCampo.Campos.Cells[1,CampoSel];
      end;
  2 : begin
      FormOpera.ShowModal;
      if CampoOperaSel = 0 then
        Exit;
      GridPesq.Cells[GridPesq.Col,GridPesq.Row] := FormOpera.GridOpera.Cells[1,CampoOperaSel];
      end;
  4 : begin
      FormConec.ShowModal;
      if CampoConecSel = 0 then
        Exit;
      GridPesq.Cells[GridPesq.Col,GridPesq.Row] := FormConec.GridConec.Cells[1,CampoConecSel];
      end;
  end; {Case}

end;

procedure TQueryDlg.OKBtnClick(Sender: TObject);

Var
  I,J : Integer;
  Linha : TgStr255;
  Old : Byte;
  Prima : Boolean;
begin
Old := FileMode;
FileMode := 2;
Reset(ArqQue);
Seek(ArqQue,FileSize(ArqQue));
if FilePos(ArqQue) <> 0 then
  ScrollBar1.Max := ScrollBar1.Max + 1;
Prima := True;
For I := 1 to 1000 do
  if GridPesq.Cells[1,I] <> '' then
    For J := 1 to 4 do
      begin
      if Prima then
        begin
        Prima := False;
        Linha := 'INICIO DE QUERY';
        Write(ArqQue,Linha);
        end;
      Linha := GridPesq.Cells[J,I];
      Write(ArqQue,Linha);
      end
  else
    Break;
LabelScrollQue.Caption := IntToStr(ScrollBar1.Max+1)+' de '+IntToStr(ScrollBar1.Max+1);
ScrollBar1.Position := ScrollBar1.Max;
FileMode := Old;
end;

procedure TQueryDlg.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);

Var
  Cont,I,J : Integer;
  Linha : TgStr255;
begin
if ScrollCode <> scEndScroll then
  Exit;
if ScrollBar1.Max <= 0 then
  Exit;
Cont := 0;
Seek(ArqQue,0);
if Not Eof(ArqQue) then
  Read(ArqQue,Linha);
While (Cont <> Scrollpos) and (Not Eof(ArqQue)) do
  begin
  Read(ArqQue,Linha);
  if Linha = 'INICIO DE QUERY' then
    Inc(Cont);
  end;

For I := 1 to 1000 do
  if GridPesq.Cells[1,I] <> '' then
    For J := 1 to 4 do
      GridPesq.Cells[J,I] := ''
  else
    Break;

Linha := '';
Cont := 1;
if Not Eof(ArqQue) then
  Read(ArqQue,Linha);
While (Linha <> 'INICIO DE QUERY') and (Not Eof(ArqQue)) do
  begin
  if Linha <> 'INICIO DE QUERY' then
    begin
    For J := 1 to 4 do
      begin
      GridPesq.Cells[J,Cont] := Linha;
      if Not Eof(ArqQue) then
        Read(ArqQue,Linha);
      end;
    end;
  Inc(Cont);
  end;
LabelScrollQue.Caption := IntToStr(ScrollPos+1)+' de '+IntToStr(ScrollBar1.Max+1);
end;

procedure TQueryDlg.BitBtn1Click(Sender: TObject);
var
  I,J : Integer;
begin
For I := 1 to 100 do
  For J := 1 to 4 do
    GridPesq.Cells[J,I] := '';
ProcurNaMesma.Checked := False;
ProcurSeq.Checked := False;
end;

procedure TQueryDlg.SalvarClick(Sender: TObject);
var
  I,J : Integer;
  Arq : System.Text;
begin
SaveDialog1.InitialDir := 'C:\ColdCfg';
if SaveDialog1.Execute then
  begin
  If Pos('.SQL',UpperCase(SaveDialog1.FileName)) <> 0 Then
    AssignFile(Arq,SaveDialog1.FileName)
  Else
    AssignFile(Arq,SaveDialog1.FileName+'.sql');
  ReWrite(Arq);
  For I := 1 to 1000 do
    if GridPesq.Cells[1,I] <> '' then
      For J := 1 to 4 do
        WriteLn(Arq,GridPesq.Cells[J,I])
    else
      Break;
  CloseFile(Arq);
  end;
end;

procedure TQueryDlg.LerClick(Sender: TObject);
var
  I,J : Integer;
  Arq : System.Text;
  Linha : TgStr255;

begin
OpenDialog1.InitialDir := 'C:\ColdCfg';
if OpenDialog1.Execute then
  begin
  BitBtn1.Click;
  AssignFile(Arq,OpenDialog1.FileName);
  Reset(Arq);
  I := 1;
  While Not Eof(Arq) do
    begin
    For J := 1 to 4 do
      if Not Eof(Arq) then
        begin
        ReadLn(Arq,Linha);
        GridPesq.Cells[J,I] := Linha;
        end;
    Inc(I);
    end;
  CloseFile(Arq);
  end;
end;

procedure TQueryDlg.FormShow(Sender: TObject);
begin
OkBtn.SetFocus;
end;

end.
