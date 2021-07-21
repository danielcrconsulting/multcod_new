Unit GraphWin;
Interface

Uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, ComCtrls, Menus, Sugeral, DBCtrls, DB, Zlib,
  ADODB;

Type
  TAnotaForm = Class(TForm)
    Panel1: TPanel;
    LineButton: TSpeedButton;
    RectangleButton: TSpeedButton;
    EllipseButton: TSpeedButton;
    RoundRectButton: TSpeedButton;
    PenBar: TPanel;
    BrushBar: TPanel;
    SolidPen: TSpeedButton;
    DashPen: TSpeedButton;
    DotPen: TSpeedButton;
    DashDotPen: TSpeedButton;
    DashDotDotPen: TSpeedButton;
    ClearPen: TSpeedButton;
    PenWidth: TUpDown;
    PenSize: TEdit;
    SolidBrush: TSpeedButton;
    ClearBrush: TSpeedButton;
    HorizontalBrush: TSpeedButton;
    VerticalBrush: TSpeedButton;
    FDiagonalBrush: TSpeedButton;
    BDiagonalBrush: TSpeedButton;
    CrossBrush: TSpeedButton;
    DiagCrossBrush: TSpeedButton;
    PenColor: TSpeedButton;
    BrushColor: TSpeedButton;
    ColorDialog1: TColorDialog;
    FreeButton: TSpeedButton;
    SairBut: TButton;
    OkButton: TButton;
    Panel2: TPanel;
    PublicaRadioButton: TRadioButton;
    PrivadaRadioButton: TRadioButton;
    SalvarButton: TButton;
    ExcluirButton: TButton;
    Label5: TLabel;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    ADOQuery1: TADOQuery;
    OcultarButton: TButton;
    procedure LineButtonClick(Sender: TObject);
    procedure RectangleButtonClick(Sender: TObject);
    procedure EllipseButtonClick(Sender: TObject);
    procedure RoundRectButtonClick(Sender: TObject);
    procedure SetPenStyle(Sender: TObject);
    procedure PenSizeChange(Sender: TObject);
    procedure SetBrushStyle(Sender: TObject);
    procedure PenColorClick(Sender: TObject);
    procedure BrushColorClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FreeButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure SalvarButtonClick(Sender: TObject);
    procedure ExcluirButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure OcultarButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DrawingToolAux : TDrawingTool;
    BrushStyle: TBrushStyle;
    PenStyle: TPenStyle;
    PenWide: Integer;
    procedure SaveStyles;
    procedure RestoreStyles;
  end;

implementation

{$R *.dfm}

Uses MDIEdit, MdiMultiCold, Subrug;

procedure TAnotaForm.FreeButtonClick(Sender: TObject);
begin
  TEditForm(FrameForm.ActiveMdiChild).DrawingTool := dtFree;
end;

procedure TAnotaForm.LineButtonClick(Sender: TObject);
begin
  TEditForm(FrameForm.ActiveMdiChild).DrawingTool := dtLine;
end;

procedure TAnotaForm.RectangleButtonClick(Sender: TObject);
begin
  TEditForm(FrameForm.ActiveMdiChild).DrawingTool := dtRectangle;
end;

procedure TAnotaForm.EllipseButtonClick(Sender: TObject);
begin
  TEditForm(FrameForm.ActiveMdiChild).DrawingTool := dtEllipse;
end;

procedure TAnotaForm.RoundRectButtonClick(Sender: TObject);
begin
  TEditForm(FrameForm.ActiveMdiChild).DrawingTool := dtRoundRect;
end;

procedure TAnotaForm.SetPenStyle(Sender: TObject);
begin
  with TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen do
  begin
    if Sender = SolidPen then Style := psSolid
    else if Sender = DashPen then Style := psDash
    else if Sender = DotPen then Style := psDot
    else if Sender = DashDotPen then Style := psDashDot
    else if Sender = DashDotDotPen then Style := psDashDotDot
    else if Sender = ClearPen then Style := psClear;
  end;
end;

procedure TAnotaForm.PenSizeChange(Sender: TObject);
begin
  TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen.Width := PenWidth.Position;
end;

procedure TAnotaForm.SetBrushStyle(Sender: TObject);
begin
  with TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Brush do
  begin
    if Sender = SolidBrush then Style := bsSolid
    else if Sender = ClearBrush then Style := bsClear
    else if Sender = HorizontalBrush then Style := bsHorizontal
    else if Sender = VerticalBrush then Style := bsVertical
    else if Sender = FDiagonalBrush then Style := bsFDiagonal
    else if Sender = BDiagonalBrush then Style := bsBDiagonal
    else if Sender = CrossBrush then Style := bsCross
    else if Sender = DiagCrossBrush then Style := bsDiagCross;
  end;
end;

procedure TAnotaForm.PenColorClick(Sender: TObject);
begin
  ColorDialog1.Color := TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen.Color;
  if ColorDialog1.Execute then
    TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen.Color := ColorDialog1.Color;
end;

procedure TAnotaForm.BrushColorClick(Sender: TObject);
begin
  ColorDialog1.Color := TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Brush.Color;
  if ColorDialog1.Execute then
    TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Brush.Color := ColorDialog1.Color;
end;

procedure TAnotaForm.Exit1Click(Sender: TObject);
begin
  RestoreStyles;
  Close;
end;

procedure TAnotaForm.SaveStyles;
begin
    BrushStyle := TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Brush.Style;
    PenStyle := TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen.Style;
    PenWide := TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen.Width;
    If FreeButton.Down Then
      DrawingToolAux := dtFree;
    If LineButton.Down Then
      DrawingToolAux := dtLine;
    If RectangleButton.Down Then
      DrawingToolAux := dtRectangle;
    If EllipseButton.Down Then
      DrawingToolAux := dtEllipse;
    If RoundRectButton.Down Then
      DrawingToolAux := dtRoundRect;
end;

procedure TAnotaForm.RestoreStyles;
begin
    TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Brush.Style := BrushStyle;
    TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen.Style := PenStyle;
    TEditForm(FrameForm.ActiveMdiChild).Image2.Canvas.Pen.Width := PenWide;

    PenWidth.Position := PenWide;
    Case PenStyle Of
      psSolid : SolidPen.Down := True;
      psDash : DashPen.Down := True;
      psDot : DotPen.Down := True;
      psDashDot : DashDotPen.Down := True;
      psDashDotDot : DashDotDotPen.Down := True;
      psClear : ClearPen.Down := True;
      End;

    Case BrushStyle Of
      bsSolid : SolidBrush.Down := True;
      bsClear : ClearBrush.Down := True;
      bsHorizontal : HorizontalBrush.Down := True;
      bsVertical : VerticalBrush.Down := True;
      bsFDiagonal : FDiagonalBrush.Down := True;
      bsBDiagonal : BDiagonalBrush.Down := True;
      bsCross : CrossBrush.Down := True;
      bsDiagCross : DiagCrossBrush.Down := True;
      End;

    Case DrawingToolAux Of
      dtFree : FreeButton.Down := True;
      dtLine : LineButton.Down := True;
      dtRectangle : RectangleButton.Down := True;
      dtEllipse : EllipseButton.Down := True;
      dtRoundRect : RoundRectButton.Down := True;
      End;

end;

Procedure TAnotaForm.OkButtonClick(Sender: TObject);
Begin
  Close;
End;

Procedure TAnotaForm.SalvarButtonClick(Sender: TObject);

Var
  b, c : TStream;
  zLibT : TCompressionStream;
  Buf1,
  Buf2 : AnsiString;
  Igual : Boolean;
  Posic : Integer;

Begin

  FormGeral.QueryInsAnotGraph.Close;
  FormGeral.QueryInsAnotGraph.Parameters[0].Value := UpperCase(GetCurrentUserName);
  FormGeral.QueryInsAnotGraph.Parameters[1].Value := RegDFN.CODREL;
  FormGeral.QueryInsAnotGraph.Parameters[2].Value := ExtractFileName(TEditForm(FrameForm.ActiveMDIChild).Filename);
  If PublicaRadioButton.Checked Then
    FormGeral.QueryInsAnotGraph.Parameters[3].Value := 'T'
  Else
    FormGeral.QueryInsAnotGraph.Parameters[3].Value := 'F';
  FormGeral.QueryInsAnotGraph.Parameters[4].Value := TEditForm(FrameForm.ActiveMDIChild).PaginaAtu;

  b := TMemoryStream.Create;
  zLibT := TCompressionStream.Create(clMax, b);

  TEditForm(FrameForm.ActiveMdiChild).Image2.Picture.Graphic.SaveToStream(zLibT);
  zLibT.Free;
  FormGeral.QueryInsAnotGraph.Parameters[5].LoadFromStream(b, ftBlob);
  c := ADOQuery1.CreateBlobStream(ADOQuery1.FieldByName('COMENTARIOBIN'),bmRead);
  Igual := False;

  If b.Size = c.Size Then
    Begin
    SetLength(Buf1, b.Size);
    SetLength(Buf2, b.Size);
    b.Position := 0;
    c.Position := 0;
    b.Read(Buf1[1],b.Size);
    c.Read(Buf2[1],b.Size);
    If Buf1 = Buf2 Then
      Igual := True;
    End;

  b.Free;
  c.Free;

  If Not Igual Then
    Try
      FormGeral.QueryInsAnotGraph.ExecSQL;
      Posic := ScrollBar1.Position;
      TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, TEditForm(FrameForm.ActiveMDIChild).PaginaAtu);
      If Sender = SalvarButton Then
        Begin
        While ADOQuery1.RecNo <> Posic+1 Do
          ADOQuery1.Next;
        ScrollBar1.Position := Posic + 1;  
        TEditForm(FrameForm.ActiveMdiChild).LoadImage2;  
        TEditForm(FrameForm.ActiveMdiChild).Image2.Visible := True;
        End;
      ShowMessage('Anotação gráfica salva com sucesso...');
    Except
      ShowMessage('Erro ao tentar salvar a anotação...');
      End;

End;

Procedure TAnotaForm.ExcluirButtonClick(Sender: TObject);
Begin
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.SQL.Clear;
FormGeral.QueryLocal1.SQL.Add('DELETE FROM COMENTARIOSBIN WHERE COMENTARIOID = '+ADOQuery1.Fields[0].AsString);
{FormGeral.QueryLocal1.SQL.Add('DELETE FROM COMENTARIOSBIN WHERE CODREL = '''+RegDFN.CODREL+'''');
FormGeral.QueryLocal1.SQL.Add('AND PATHREL = '''+ExtractFileName(TEditForm(FrameForm.ActiveMDIChild).Filename)+'''');
FormGeral.QueryLocal1.SQL.Add('AND PAGINA = '+IntToStr(TEditForm(FrameForm.ActiveMDIChild).PaginaAtu));
FormGeral.QueryLocal1.SQL.Add('AND ((CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''')');
FormGeral.QueryLocal1.SQL.Add('OR   (FLAGPUBLICO = ''T''))');}
Try
  ADOQuery1.Close;
  FormGeral.QueryLocal1.ExecSQL;
  TEditForm(FrameForm.ActiveMDIChild).CarregaImagem(True, TEditForm(FrameForm.ActiveMDIChild).PaginaAtu);
  If ScrollBar1.Max <> 0 Then
    TEditForm(FrameForm.ActiveMdiChild).Image2.Visible := True;
//  TEditForm(FrameForm.ActiveMdiChild).TrataImage2(1, 1);
//  FrameForm.Animate2.Visible := False;
  ShowMessage('Anotação gráfica excluída com sucesso...');
Except
  ShowMessage('Erro ao tentar excluir a anotação gráfica...');
  End;
End;

Procedure TAnotaForm.FormCreate(Sender: TObject);
Begin
Label1.Caption := '0 de 0';
End;

Procedure TAnotaForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
Begin
If ScrollCode <> scEndScroll Then
  Exit;
If ADOQuery1.RecNo = ScrollPos Then
  Exit;
If ADOQuery1.RecNo < ScrollPos Then
  ADOQuery1.Next
Else
  ADOQuery1.Prior;
TEditForm(FrameForm.ActiveMdiChild).LoadImage2;
If ADOQuery1.FieldByName('FLAGPUBLICO').AsString = 'T' Then
  PublicaRadioButton.Checked := True
Else
  PrivadaRadioButton.Checked := True;
Label1.Caption := IntToStr(ScrollPos)+' de '+IntToStr(ScrollBar1.Max);
End;

Procedure TAnotaForm.OcultarButtonClick(Sender: TObject);
Begin
TEditForm(FrameForm.ActiveMDIChild).Image2.Visible := False;
End;

End.
