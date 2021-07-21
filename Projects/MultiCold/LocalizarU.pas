Unit LocalizarU;

{
 13/03/2003 - Só havia o botão localizar que a primeira vez funcionava como localizar e a partir dai, caso a string de
 pesquisa não fosse alterada, como localizar próxima. Implementei os dois botões, localizar e localizar próxima com
 funções distintas. Sempre que clicar localizar o programa reinicia a localização de acordo com os parâmetros 
 fornecidos.
}

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MdiEdit, ExtCtrls;

Type
  TLocalizar = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LocalizarEdit: TEdit;
    PagIniEdit: TEdit;
    PagFinEdit: TEdit;
    LinIniEdit: TEdit;
    LinFinEdit: TEdit;
    ColunaEdit: TEdit;
    LocBut: TButton;
    SairBut: TButton;
    Label7: TLabel;
    PaginaAtuEdit: TEdit;
    MemoGidley: TMemo;
    LocProxBut: TButton;
    RadioGroup1: TRadioGroup;
    Procedure SairButClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure LocButClick(Sender: TObject);
    procedure PagIniEditChange(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Localizar: TLocalizar;
  PagIni,
  PagFin,
  LinIni,
  LinFin,
  Coluna  : Integer;
  AlterouValores : Boolean;

Implementation

Uses MdiMultiCold, SuGeral;

{$R *.DFM}

Var
  Cancelar : Boolean;

Procedure TLocalizar.SairButClick(Sender: TObject);
Begin
Cancelar := True;
Close;
End;

Procedure TLocalizar.FormCreate(Sender: TObject);
Begin
LocalizarEdit.Text := '';
PagIniEdit.Text := '*';
PagFinEdit.Text := '*';
LinIniEdit.Text := '*';
LinFinEdit.Text := '*';
ColunaEdit.Text := '*';
PagIni := 1;
PagFin := 1;
LinIni := 1;
LinFin := 1;
Coluna := 1;
LinhaLocalizada := -1;
AlterouValores := False;
End;

Procedure TLocalizar.LocButClick(Sender: TObject);
Var
  I,
  J : Integer;
//  Linha133,
//  Linha : String;
  localizaNaPesquisa : boolean;

  Function SetaLinIni : Boolean;
  Begin
  Result := True;
  If LinIniEdit.Text <> '*' Then
    Try
      LinIni := StrToInt(LinIniEdit.Text);
    Except
      ShowMessage('Linha Inicial inválida, verifique...');
      Result := False;
      Exit;
    End
  Else
    LinIni := 1;
  End;

  function paginaDaPesquisa(pagNum:Integer) : boolean;
  var
    z : integer;
  begin
  result := false;
  for z := low(TEditForm(FrameForm.ActiveMdiChild).gridQueryFacil) to high(TEditForm(FrameForm.ActiveMdiChild).gridQueryFacil) do
    if TEditForm(FrameForm.ActiveMdiChild).gridQueryFacil[z].Pagina = pagNum then
      begin
      result := true;
      break;
      end;
  end;

Begin

localizaNaPesquisa := ((TEditForm(FrameForm.ActiveMdiChild).temPesquisa) and (radioGroup1.ItemIndex = 1));
FrameForm.LocalizarPrxima1.Enabled := True;
LocProxBut.Enabled := True;

If (not AlterouValores) and (PagIni > PagFin) then
  begin
  messageDlg('Fim da pesquisa.',mtInformation,[mbOk],0);
  exit;
  end;
  
If (AlterouValores) Or (Sender = LocBut) Then
  Begin

  PagIni := 1;
  PagFin := TEditForm(FrameForm.ActiveMdiChild).Paginas;
  LinIni := 1;
  LinFin := 1;
  Coluna := 1;
  LinhaLocalizada := -1;

  If PagFinEdit.Text <> '*' Then
    Begin
    Try
      PagFin := StrToInt(PagFinEdit.Text);
    Except
      ShowMessage('Página Final inválida, verifique...');
      Exit;
      End; // Try
    If PagFin > TEditForm(FrameForm.ActiveMdiChild).Paginas Then
      PagFin := TEditForm(FrameForm.ActiveMdiChild).Paginas;
    if (localizaNaPesquisa) and (PagFin > FrameForm.ScrollBar1.Max) then
      PagFin := FrameForm.ScrollBar1.Max
    End;

  If PagIniEdit.Text <> '*' Then
    Begin
    Try
      PagIni := StrToInt(PagIniEdit.Text);
    Except
      ShowMessage('Página Inicial inválida, verifique...');
      Exit;
      End; // Try
    If PagIni > PagFin Then
      PagIni := PagFin;
    End;

  If Not SetaLinIni Then
    Exit;

  If LinFinEdit.Text <> '*' Then
    Try
      LinFin := StrToInt(LinFinEdit.Text);
    Except
      ShowMessage('Linha Final inválida, verifique...');
      Exit;
    End;

  If ColunaEdit.Text <> '*' Then
    Try
      Coluna := StrToInt(ColunaEdit.Text);
    Except
      ShowMessage('Coluna inválida, verifique...');
      Exit;
    End;

  AlterouValores := False;
  End;
Cancelar := False;

With TEditForm(FrameForm.ActiveMdiChild) Do
  Begin

  If LinhaLocalizada <> -1 Then  // Começa a procurar na próxima linha depois de achada;
    Begin
    LinIni := LinhaLocalizada+2;
    LinhaLocalizada := -1;
    End
  Else
    If Not SetaLinIni Then
      Exit;

  For I := PagIni To PagFin Do
    Begin

    If I <> PagIni Then // Mudou para outra página no loop do for, seta para pesquisar da linha inicial
      Begin
      If Not SetaLinIni Then
        Exit;
        PagIni := I;
      End;

    PaginaAtuEdit.Text := IntToStr(I);

    if localizaNaPesquisa then
      begin
      Seek(TEditForm(FrameForm.ActiveMdiChild).ArqPsq,I-1);
      {$i-}
      Read(TEditForm(FrameForm.ActiveMdiChild).ArqPsq,TEditForm(FrameForm.ActiveMdiChild).RegPsq);
      {$i+}
      If IoResult <> 0 Then
        Begin
        messageDlg('Fim da pesquisa.',mtInformation,[mbOk],0);
        Exit;
        End;
      GetPaginaDoRel(TEditForm(FrameForm.ActiveMdiChild).RegPsq.Pagina, False)
      end
    else
      GetPaginaDoRel(I, False);

    Application.ProcessMessages;

    MemoGidley.Lines.Text := PaginaAcertada;
    
    If LinFinEdit.Text <> '*' Then
      LinFin := StrToInt(LinFinEdit.Text)
    Else
      LinFin := MemoGidley.Lines.Count;

    If LinFin > MemoGidley.Lines.Count Then
      LinFin := MemoGidley.Lines.Count;

    For J := LinIni To LinFin Do
      Begin
      If ColunaEdit.Text = '*' Then
        Begin
        If Pos(LocalizarEdit.Text,MemoGidley.Lines[J-1]) <> 0 Then
          Begin
          UsouLocalizar := True;
          LinhaLocalizada := J-1;
          ColunaLocalizada := Pos(LocalizarEdit.Text,MemoGidley.Lines[J-1]);
          TamLocalizada := Length(LocalizarEdit.Text);
          if localizaNaPesquisa then
            begin
            Seek(TEditForm(FrameForm.ActiveMdiChild).ArqPsq,I-1);
            {$i-}
            Read(TEditForm(FrameForm.ActiveMdiChild).ArqPsq,TEditForm(FrameForm.ActiveMdiChild).RegPsq);
            {$i+}
            If IoResult <> 0 Then
              Begin
              messageDlg('Fim da pesquisa.',mtInformation,[mbOk],0);
              Exit;
              End;
            FrameForm.ScrollBar1.Position := TEditForm(FrameForm.ActiveMdiChild).RegPsq.PosQuery;
            FrameForm.Scrolla1;
            end
          else
            begin
            FrameForm.ScrollBar2.Position := I-1;
            FrameForm.Scrolla2;
            end;
          Localizar.Close;
//          PagIni := I+1;
          Exit;
          End;
        End
      Else
        Begin
        If Copy(MemoGidley.Lines[J-1],Coluna,Length(LocalizarEdit.Text)) = LocalizarEdit.Text Then
          Begin
          UsouLocalizar := True;
          LinhaLocalizada := J-1;
          ColunaLocalizada := Coluna;
          TamLocalizada := Length(LocalizarEdit.Text);
          if localizaNaPesquisa then
            begin
            Seek(TEditForm(FrameForm.ActiveMdiChild).ArqPsq,I-1);
            {$i-}
            Read(TEditForm(FrameForm.ActiveMdiChild).ArqPsq,TEditForm(FrameForm.ActiveMdiChild).RegPsq);
            {$i+}
            If IoResult <> 0 Then
              Begin
              messageDlg('Fim da pesquisa.',mtInformation,[mbOk],0);
              exit;
              End;
            FrameForm.ScrollBar1.Position := TEditForm(FrameForm.ActiveMdiChild).RegPsq.PosQuery;
            FrameForm.Scrolla1;
            end
          else
            begin
            FrameForm.ScrollBar2.Position := I-1;
            FrameForm.Scrolla2;
            end;
          Localizar.Close;
          Exit;
          End;
        End;
      End;
    If Cancelar Then
      Break;
    End;
  End;
PagIni := I+1;
If PagIni > PagFin Then
  Begin
  ShowMessage('Fim da pesquisa...');
  AlterouValores := True;
  End;
End;

Procedure TLocalizar.PagIniEditChange(Sender: TObject);
Begin
AlterouValores := True;
FrameForm.LocalizarPrxima1.Enabled := False;
LocProxBut.Enabled := False;
End;

End.
