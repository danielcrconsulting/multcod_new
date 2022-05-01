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
  StdCtrls, MdiEdit, ExtCtrls, IMulticoldServer1, Soap.SOAPHTTPClient, Zlib, uclsAux;
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
    Lblvalidacao: TLabel;
    Procedure SairButClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure LocButClick(Sender: TObject);
    procedure PagIniEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    { Private declarations }
    procedure DecriptaPagina(QtdeBytes: Integer; varPag: WideString);
    function MontarQueryFacil :  QueryFacilArrayDTO;
    function convOperador(operador:AnsiString): Integer;
    function ValidarQtdePaginasSuportadasRemoto: Boolean;
  Public
    { Public declarations }
    Proximo: boolean;
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
Uses MdiMultiCold, SuGeral, LogInForm, Gridque, SuBrug;
{$R *.DFM}
Var
  Cancelar : Boolean;
function TLocalizar.convOperador(operador:AnsiString): Integer;
  begin
    result := -1;
    if operador = '=' then
      result := 1
    else if operador = '>' then
      result := 2
    else if operador = '<' then
      result := 3
    else if operador = '>=' then
      result := 4
    else if operador = '<=' then
      result := 5
    else if operador = '<>' then
      result := 6
    else if operador = 'IN' then
      result := 7
    else if operador = 'IS' then
      result := 8
    else if operador = 'BETWEEN' then
      result := 9
    else if operador = 'LIKE' then
      result := 10
    else if operador = 'NOT =' then
      result := 11
    else if operador = 'NOT >' then
      result := 12
    else if operador = 'NOT <' then
      result := 13
    else if operador = 'NOT >=' then
      result := 14
    else if operador = 'NOT <=' then
      result := 15
    else if operador = 'NOT IN' then
      result := 16
    else if operador = 'NOT BETWEEN' then
      result := 17
    else if operador = 'IS NOT' then
      result := 18
    else
      result := -1;
  end;

Procedure TLocalizar.SairButClick(Sender: TObject);
Begin
Cancelar := True;
Close;
End;
function TLocalizar.ValidarQtdePaginasSuportadasRemoto: Boolean;
begin
  Result := true;
  if (PagFin > PagIni) and (PagFin - PagIni > 15000) then
    Result := false;
end;

procedure TLocalizar.DecriptaPagina(QtdeBytes: Integer; varPag: WideString);
var
  QtdBytesPagRel: Integer;
begin

    ReallocMem(BufI,QtdeBytes div 2); { Allocates only the space needed }
    ReallocMem(Buffer,QtdeBytes div 2); // Temporariamente para a conversão.....
    auxPag := varPag;
    hexToBin(PAnsiChar(auxPag), PAnsiChar(BufferA), QtdeBytes div 2);
    Move(BufferA^,BufI^,QtdeBytes div 2); { Moves only the buffer To decompress }

    ReallocMem(Buffer,0); { DeAllocates }
    Try
      ZDecompress(BufI, QtdeBytes, Buffer, QtdBytesPagRel, 0);
    Except
      On E: Exception Do
        Begin
        ShowMessage('Erro de descompressão da página...'+#13#10+e.Message);
        End;
      End; // Try


    TEditForm(FrameForm.ActiveMdiChild).Decripta(Buffer, true, true, QtdBytesPagRel);
end;

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

procedure TLocalizar.FormShow(Sender: TObject);
begin
  LblValidacao.Caption := '';
  if TEditForm(FrameForm.ActiveMdiChild).RelRemoto then
  begin

    PaginaAtuEdit.Visible := False;
    Label7.Visible := False;
    if not Proximo then
    begin
      PagIniEdit.Text := '1';
      PagFinEdit.Text := '15000';
    end;
  end else
  begin
    PaginaAtuEdit.Visible := true;
    Label7.Visible := true;
  end;
end;


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

function TLocalizar.MontarQueryFacil :  QueryFacilArrayDTO;
var
  i, len: Integer;
  conector,
  auxStr: String;
  campo, index, valor: WideString;

  function ObterConector(conectorStr: String) : integer;
  begin
    if conectorStr = 'AND' then
      Result := 1
    else
      Result := 2;
  end;
begin
  len := 1;
  for i := 1 to queryDlg.GridPesq.RowCount-1 do
  begin
      if trim(queryDlg.GridPesq.Cells[1,i]) <> '' then
        begin
          setLength(Result, len);
          campo := queryDlg.GridPesq.Cells[1,i];
          index := queryDlg.GridPesq.Cells[0,i];
          valor := queryDlg.GridPesq.Cells[3,i];
          conector := queryDlg.GridPesq.Cells[4,i];
          Result[i-1] := TQueryFacilDTO.Create;
          Result[i-1].Operador := convOperador(queryDlg.GridPesq.Cells[2,i]);
          Result[i-1].Campo := campo;
          Result[i-1].Index_ := index;
          Result[i-1].Valor := valor;
          if conector = '' then
            Result[i-1].Conector := -1
          else
            Result[i-1].Conector := ObterConector(conector);
          Inc(len);
        end;
  end;
end;

Procedure TLocalizar.PagIniEditChange(Sender: TObject);
Begin
AlterouValores := True;
FrameForm.LocalizarPrxima1.Enabled := False;
LocProxBut.Enabled := False;
End;
End.
