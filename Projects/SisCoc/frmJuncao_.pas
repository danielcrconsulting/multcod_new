unit frmJuncao_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows, ADODB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids;


type
  TfrmJuncao = class(TForm)
    Frame1:  TGroupBox;
    cmdGrava:  TButton;
    cmdDelete:  TButton;
    cmdNew:  TButton;
    Command1:  TButton;
    Command2:  TButton;
    GrdJuncao: TMemo;

    procedure cmdDeleteClick(Sender: TObject);
    procedure cmdNewClick(Sender: TObject);
    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure cmdGravaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AtualizaGrid();
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    cnAdoConect: TADOConnection;
    RsAdoJuncao: TADODataSet;

    function Validou(Buf: String): Boolean;
    procedure Form_Unload(var Cancel: Smallint);

  public
    { Public declarations }
  end;

var
  frmJuncao: TfrmJuncao;

implementation

uses  Dialogs, SysUtils, Module1, DataMov_, RotGerais, PBar_, frmLog_, VBto_Converter, FileHandles, System.Types, IOUtils,
      IdGlobalProtocols;

{$R *.dfm}

 //=========================================================
procedure TfrmJuncao.cmdDeleteClick(Sender: TObject);
begin
  try  // On Error GoTo Erro
    if  not Autoriza(cADM) then begin
      Exit;
    end;
    with RsAdoJuncao do
      begin
      if  not RsAdoJuncao.EOF then
        Delete;
      // If Not .EOF Then .MoveLast
      end;
    Exit;
  except  // Erro:
    ShowMessage('Digite o nome do Arquivo');
 //    Err.Clear();
    Self.grdJuncao.SetFocus;
  end;
end;

procedure TfrmJuncao.cmdNewClick(Sender: TObject);
begin
  try  // On Error GoTo Erro
    if  not Autoriza(cADM) then begin
      Exit;
    end;
    if  not RsAdoJuncao.EOF then begin
//      if Self.grdJuncao.Text='' then begin
        ShowMessage('Digite o nome do Arquivo');
        Exit;
  //    end;
      RsAdoJuncao.Last;
    end;
    RsAdoJuncao.Insert;
    Self.grdJuncao.Refresh();
    Self.grdJuncao.SetFocus();
    Exit;
  except  // Erro:
    ShowMessage('Arquivo Duplicado');
  //  Err.Clear();
  end;
end;

procedure TfrmJuncao.Command1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmJuncao.Command2Click(Sender: TObject);
label
  LUP, Saida;
var
  gContas, gBIN, gBinGeral: array of OleVariant;
  pathArqDe: String;
  ArqEntrada, ArqSaida : System.Text;
  I: Integer;
  Buffer, NomeSaida, Path, myAppPath, nArquivo, sConta, sMoeda, sMoedaAntes,
  pathRel, pathRel2, S, Arquivo2,
  NomeArquivo: String;
  iPosicao: Integer;
  iFileLen, NroReg: Extended;
  Flag, Aberto: Boolean;
  DbTemp,
  DbCli,
  DbAdm: TAdoConnection; //Database;
  RsTemp,
  RsDb,
  RsDb2,
  RsAdm: TADODataSet;
  J, K: Integer;
  DynArray: TStringDynArray;
begin
//  ArqEntrada := 0;
  iPosicao := 0;
  iFileLen := 0;

  // gDataRelatorio = ""
  // DataGerArq.Show vbModal
  DataMov.ShowModal;
  if  not isDataValida(gDataRelatorio) then
    Exit;

  // Verifica se tem relatorios gerados com data literal e converte.
  ConverteMes;

//  DbAdm := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
//  if  not Conecta('ADM') then Exit;
//  if  not Conecta('') then Exit;

//  Conecta(DbAdm, gAdmPath+'\admin.mdb');

  if  not ChecaTempDb then         // Checa Temp Db agora zera todas as tabelas
    begin
    ShowMessage('Arquivo CC_TempVisa.udl não encontrado...');
//    Screen.Cursor := crHourGlass;
    // Limpa a tabela
//    sSql := 'delete from BinErrado';
//    DbTemp.Execute(sSql);

//    RsTemp.Close();
//    RsTemp := nil;
//    DbTemp.Close();
//    DbTemp := nil;

//    CloseFile(ArqEntrada);
//    Aberto := false;
//    CloseFile(ArqSaida);
//    SetLength(gContas, 0+1);
//    SetLength(gBIN, 0+1);
//    SetLength(gBinGeral, 0+1);

//    Desconecta();
//    Screen.Cursor := crDefault;
    Exit;
    end;

  //DbTemp := gWork.OpenDatabase(gTempDir+'CC_TempVisa.mdb');

  Conecta(DbTemp, gTempDir+'CC_TempVisa.udl');

  // Limpa a tabela
  //  sSql := 'delete from tempJuncao';
  //  DbTemp.Execute(sSql);
  // Abre o Recordset

  RsTemp := TAdoDataSet .Create(nil);
  RsDb := TAdoDataSet.Create(nil);
  RsDb2 := TAdoDataSet.Create(nil);
  RsAdm := TAdoDataSet.Create(nil);

  sSql := 'select * from tempJuncao';

//  RsTemp := DbTemp.OpenRecordset(sSql);
  RsTemp.Connection := DbTemp;
  RsTemp.CommandText := sSql;
  RsTemp.Open;

  Path := gAdmPath+'\';
  Path := Path+gCliente+'\entrada\';

  Conecta(DbCli, gDataPath + gDataFile + '.udl');

  sSql := 'select * from tb_opcao';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.Connection := DbCli;
  RsDb.CommandText := sSql;
  RsDb.Open;

  Conecta(DbAdm, gAdmPath+'\admin.mdb');
  RsDb2.Connection := DbAdm;
  RsAdm.Connection := DbAdm;

  // Alterado em 09/03/2001 para não juntar as contas das conciliações
  // que não são Atualizadas no Modo Automático
  while not RsDb.EOF do
    begin
    sSql := 'select * from tbContasAdm';
    sSql := sSql + ' where conta_contabil = '#39''+String(RsDb.FieldByName('conta_contabil').Value)+''#39'';
    sSql := sSql + ' and (Bandeira ='#39''+Trim(gBandeira)+''#39'';
    sSql := sSql + ' or Bandeira = '#39'VISA-MC'#39') order by codigo';
//    RsDb2 := DbAdm.OpenRecordset(sSql);

    RsDb2.CommandText := sSql;
    RsDb2.Open;

    while  not RsDb2.EOF do
      begin
      RsDb2.Edit;
      if Concil.ContaContabil=Trim(RsDb.FieldByName('conta_contabil').Value) then
        begin
        VBtoADOFieldSet(RsDb2, 'Junta2', 'S');
        VBtoADOFieldSet(RsDb2, 'Junta', true);
        end
      else
        begin
        // RsDb2.Fields("Junta2") = (RsDb.Fields("AtualizaGeral") <> "NAO")
        if (RsDb.FieldByName('AtualizaGeral').AsString <> 'NAO') then
          begin
          VBtoADOFieldSet(RsDb2, 'Junta', true);
          VBtoADOFieldSet(RsDb2, 'Junta2', 'S');
          end
        else
          begin
          VBtoADOFieldSet(RsDb2, 'Junta', false);
          VBtoADOFieldSet(RsDb2, 'Junta2', 'N');
          end;
      end;
      RsDb2.UpdateRecord;
      RsDb2.Next;
    end;
    RsDb.Next;
    RsDb2.Close;
  end;

  // Guarda as contas e refs a serem juntados
  // sSql = "select * from tbContas"
  sSql := 'select * from tbContasAdm';
//  RsAdm := DbAdm.OpenRecordset(sSql);
  RsAdm.CommandText := sSql;
  RsAdm.Open;

//  I := 1;
  I := 0;
  while  not RsAdm.EOF do
    begin
    SetLength(gContas, I+1);
    gContas[I].Conta := RsAdm.FieldByName('codigo').Value;
    // Debug.Print RsAdm.Fields("codigo")
    if RsAdm.FieldByName('Junta2').AsString <> 'S' then
      // Pula esta conta...
      I := I-1;
    I := I+1;
    RsAdm.Next;
    end;

  SetLength(gContas, I+1);
  gContas[I].Conta := '9999';

  // Guarda os BINs a serem juntados
  sSql := 'select * from tbBIN';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

  I := 0;
  while  not RsDb.EOF do
    begin
    SetLength(gBIN, I+1);
    gBIN[I] := RsDb.FieldByName('bin').Value;
    I := I+1;
    RsDb.Next;
    end;
  SetLength(gBIN, I+1);
  gBIN[I] := '9999';

  // Guarda os outros BINs
  sSql := 'select * from tbBinGeral';
//  RsAdm := DbAdm.OpenRecordset(sSql);
  RsAdm.Close;
  RsAdm.CommandText := sSql;
  RsAdm.Open;

  I := 0;
  while  not RsAdm.EOF do
    begin
    SetLength(gBinGeral, I+1);
    gBinGeral[I] := RsAdm.FieldByName('bin').Value;
    I := I+1;
    RsAdm.Next;
    end;

  SetLength(gBinGeral, I+1);
  gBinGeral[I] := '9999';

  sSql := 'select * from juncao';
  //RsAdm := DbAdm.OpenRecordset(sSql);
  RsAdm.CommandText := sSql;
  RsAdm.Open;

  if RsAdm.EOF then
    begin
    ShowMessage('Junção não cadastrada');
    Exit;
    end;

  // Abre os arquivos, verifica as datas internas, renomeia,
  // move os arquivos que não forem da data
  // pathRel = Left(Path, 12) & "Relatorios_Gerados\"
  pathRel := ExtractFileDir(Application.ExeName) + '\Relatorios_Gerados\';

  J := 0;
  for I:=1 to Length(pathRel) do
    if Copy(pathRel, I, 1)='\' then
      J := J+1;

  pathRel2 := copiaAte_18(pathRel, '\', J-1);
  // ================================================================================
  // Não vai mais olhar data da geração do arquivo
  // Vai mover os arquivos para ...\Bkp_Processados

  // Arquivo = Dir$(pathRel & "*" & Format$(gDataGeracaoArquivo, "YYYYMMDD") & "*.txt")
 //  Arquivo := Dir(pathRel+'*.txt');
  DynArray := TDirectory.GetFiles(pathRel, '*.txt', TSearchOption.soTopDirectoryOnly);

//  while Arquivo <> '' do
  for K := Low(DynArray) to High(DynArray) do
    begin
//    if FileLen(pathRel+Arquivo)<80 then begin
    if FileSizeByName(pathRel + DynArray[K])<80 then
      // Move para ForaDaData
      // FileCopy pathRel & Arquivo, pathRel2 & "\Relatorios_Gerados\Rel_ForaDaData\" & Arquivo
      // Kill pathRel & Arquivo

      // Deleta arquivos zerados
      DeleteFile(pathRel+DynArray[K])
    else
      begin
//      ArqEntrada := 1{indifferently};
      AssignFile(ArqEntrada, pathRel+DynArray[K]);
      Reset(ArqEntrada);
      sSql := sSql+'abriu o arquivo '+#10;
      ReadLn(ArqEntrada, Buffer);
      CloseFile(ArqEntrada);

      S := '';
      if Length(Buffer)>=Param.Data.Posicao+Param.Data.Tamanho-1 then
        S := Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho);

      if isDataValida(S) then
        begin
        // Renomeia arquivo
        // tem que ser fora do IF ?????????
        // Close #ArqEntrada

        J := (1+Pos('.', PChar(DynArray[K])+1))-1; // + Len(Path)
        S := Copy(Buffer, Param.Data.Posicao, 2); // Dia MOVTO
        I := J;

        while Copy(DynArray[K], I, 1) <> '_' do
          I := I-1;

        I := J-I+1;
        // Arquivo2 = Mid$(Arquivo, 1, J - 2)
        // Arquivo2 = Mid$(Arquivo, 1, J - 4)
        // Arquivo2 = Arquivo2 & S & Mid$(Arquivo, J - 1, 2) & ".TXT"

        Arquivo2 := Copy(DynArray[K], 1, J-I-2);
        Arquivo2 := Arquivo2+S+Copy(DynArray[K], J-I+1, I)+'.TXT';

        // Renomeia para data correta
        RenameFile(pathRel+DynArray[K], pathRel+Arquivo2);
        // Move se nao for da data
        S := Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho); // Data
        // Data interna = data do movimentp?
        // =========================================================
        // Não move mais
        // If S <> gDataRelatorio Then
        // sSql = sSql & " vai mover " & Chr(10)
        // Move para ForaDaData
        // FileCopy pathRel & Arquivo2, pathRel2 & "\Relatorios_Gerados\Rel_ForaDaData\" & Arquivo2
        // Kill pathRel & Arquivo2
        // End If
        end
      else
        begin
        // FileCopy pathRel & Arquivo, pathRel2 & "\Relatorios_Gerados\Rel_ForaDaData\" & Arquivo
        // Kill pathRel & Arquivo
        // Deleta arquivos gerados
        if FileSizeByName(pathRel+DynArray[K])<80 then
          DeleteFile(pathRel+DynArray[K]);
      end;
    end;
  //  Arquivo := Dir();
  end;

  S := RsAdm.FieldByName('nome_arquivo').Value;

  NomeSaida := Path+'JUNTADO';

  NomeArquivo := '_'+FormatVB(gDataRelatorio,'YYYYMMDD');

  // Arquivo = Path & Arquivo & NomeArquivo & ".txt"
//  Arquivo := pathRel2+'Relatorios_Gerados\'+S+NomeArquivo+'*.txt';
  DynArray := TDirectory.GetFiles(pathRel2+'Relatorios_Gerados\'+S+NomeArquivo, '*.txt', TSearchOption.soTopDirectoryOnly);

  NomeSaida := NomeSaida+NomeArquivo+'.txt';

  Flag := false;
  I := 0;
  while  not RsAdm.EOF and (Flag=false) do
    begin

    // MsgBox Arquivo
    // sSql = sSql & Arquivo & Chr(10)

//    if Dir(Arquivo)<>'' then
    if DynArray[I] <> '' then
      Flag := true
    else
      if  not RsAdm.EOF then
        begin
        RsAdm.Next;
        // 2003/12/11            If Not RsDb.EOF Then
        if not RsAdm.EOF then
          begin
          nArquivo := RsAdm.FieldByName('nome_arquivo').Value;
          nArquivo := pathRel2 + 'Relatorios_Gerados\' + nArquivo+NomeArquivo + '*.txt';
          end;
        end;
    end;

  if  not Flag then
    begin
    ShowMessage('Não há arquivos para juntar');
    Exit;
    end;

//  ArqSaida := 1{indifferently};
  AssignFile(ArqSaida, NomeSaida);
  Rewrite(ArqSaida);
  Aberto := true;
  RsAdm.First;
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Preparando Arquivo de Entrada...';
  // Flag = False
  RsAdm.First;
  nArquivo := RsAdm.FieldByName('nome_arquivo').Value;
  // Arquivo = Path & Arquivo & NomeArquivo & ".txt"
  nArquivo := pathRel2 + 'Relatorios_Gerados\' + nArquivo+NomeArquivo + '';
  gArquivo11 := '';
  frmLog.Show;
  frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Data do Movimento: ' + DateToStr(gDataRelatorio) + #10;
  K := 0;

  while not RsAdm.EOF do
    begin
    // Abre o arquivo de entrada
//    S := Dir(Arquivo);
    DynArray := TDirectory.GetFiles(nArquivo, '*.txt', TSearchOption.soTopDirectoryOnly);
//    if Dir(Arquivo)<>'' then
    if DynArray[K] <> '' then
      begin
//      ArqEntrada := 1{indifferently};
      S := DynArray[0];
      S := pathRel2+'Relatorios_Gerados\'+S;
      AssignFile(ArqEntrada, S);
      Reset(ArqEntrada);
      Aberto := true;
//      iFileLen := FileLen(S);
      iFileLen := FileSizeByName(S);
      // Arquivos não tem cabeçalho
      // If Flag Then Line Input #ArqEntrada, Buffer
      end
    else
      begin
      if not RsAdm.EOF then
        begin
        RsAdm.Next;
        if not RsAdm.EOF then
          begin
          nArquivo := RsAdm.FieldByName('nome_arquivo').Value;
//          nArquivo := pathRel2+'Relatorios_Gerados\'+nArquivo+NomeArquivo+'*.txt';
          nArquivo := pathRel2+'Relatorios_Gerados\'+nArquivo+NomeArquivo+'';
          iPosicao := 0;
          // Flag = True
          goto LUP;
          end;
        end
      else
        begin
        ShowMessage(PChar('Arquivo: '+NomeArquivo+' não encontrado'));
//        Desconecta();
        DbTemp.Close;
        DbCli.Close;
        DbAdm.Close;
        RsTemp.Close;
        RsDb.Close;
        RsDb2.Close;
        RsAdm.Close;

        DbTemp.Free;
        DbCli.Free;
        DbAdm.Free;
        RsTemp.Free;
        RsDb.Free;
        RsDb2.Free;
        RsAdm.Free;

        PBar.Close;
        CloseFile(ArqSaida);
        CloseFile(ArqEntrada);
        Exit;
      end;
    end;
    if Aberto then
      begin
      frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+S+#10;
      NroReg := 0;
      sMoeda := '   ';
      while not Eof(ArqEntrada) do
        begin
        ReadLn(ArqEntrada, Buffer);
        if Validou(Buffer) then
          begin
          // Print #ArqSaida, Buffer
//          if Copy(Buffer, Param.Data.Posicao+2, 1)='-' then SetToMid(Buffer, 49, '/', 1);
//          if Copy(Buffer, Param.Data.Posicao+5, 1)='-' then SetToMid(Buffer, 52, '/', 1);
//          if Copy(Buffer, Param.Data.Posicao+2, 1)='.' then SetToMid(Buffer, 49, '/', 1);
//          if Copy(Buffer, Param.Data.Posicao+5, 1)='.' then SetToMid(Buffer, 52, '/', 1);
          if Copy(Buffer, Param.Data.Posicao+2, 1)='-' then Buffer.Insert(48, '/');
          if Copy(Buffer, Param.Data.Posicao+5, 1)='-' then Buffer.Insert(51, '/');
          if Copy(Buffer, Param.Data.Posicao+2, 1)='.' then Buffer.Insert(48, '/');
          if Copy(Buffer, Param.Data.Posicao+5, 1)='.' then Buffer.Insert(51, '/');


          // INSERIDO EM 15/10/02 PARA MANTER SEMPRE A MOEDA ANTERIOR
          // QUANDO ESTIVER VAZIA
          sMoeda := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);
          sConta := Copy(Buffer, Param.Conta.Posicao, Param.Conta.Tamanho);
          if Length(Trim(sMoeda)) <> 0 then
            sMoedaAntes := sMoeda;

          if (Length(Trim(sMoeda))=0) then
///            SetToMid(Buffer, Param.Moeda.Posicao, Copy(sMoedaAntes, 1, Length(sMoedaAntes)), Param.Moeda.Tamanho);
            Buffer.Insert(Param.Moeda.Posicao-1, Copy(sMoedaAntes, 1, Length(sMoedaAntes)));

//          with RsTemp do
            RsTemp.Insert;
            VBtoADOFieldSet(RsTemp, 'Moeda', Copy(Buffer, 12, 3));
            VBtoADOFieldSet(RsTemp, 'Linha', Buffer);
            RsTemp.UpdateRecord;
          NroReg := NroReg+1;
          end;
        iPosicao := iPosicao+Length(Buffer)+2;
        if iPosicao/iFileLen<=1 then
          PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
        else
          PBar.ProgressBar1.Position := 100;
        Application.ProcessMessages;
        end;
      // NAO MOVER, COMENTAR E TESTAR

      CloseFile(ArqEntrada);
//       S := Dir(Arquivo);                                Eu fiz isso, testar
//      pathArqDe := pegaPath(Arquivo);
      pathArqDe := pegaPath(S);
       S := ExtractFileName(S);
      if  not moveArquivo(pathArqDe+S, pathArqDe+'Bkp_Processados\'+S) then begin
        ShowMessage('Erro');
      end;

      Aberto := false;
      if NroReg=-1 then
        NroReg := 0;
      frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Número de Registros processados = '+FloatToStr(NroReg)+#10;
      // Ve se tem outro arquivo com o mesmo nome par juntar
      // If Dir$(Arquivo) <> "" Then GoTo LUP
      Inc(K);
//      if Dir() <> '' then
      if K <= High(DynArray[K]) then
        goto LUP;
    end;

    if not RsAdm.EOF then
      begin
      RsAdm.Next;
      if not RsAdm.EOF then
        begin
        nArquivo := RsAdm.FieldByName('nome_arquivo').Value;
//        Arquivo := pathRel2+'Relatorios_Gerados\'+Arquivo+NomeArquivo+'*.txt';
        nArquivo := pathRel2 + 'Relatorios_Gerados\' + nArquivo+NomeArquivo + '';
        iPosicao := 0;
      end;
    end;
  LUP:
  end;

  frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+#10+'Fim da Junção. '+#10+#10;
  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close();
  frmLog.Show();
  Application.MessageBox('Junção Terminada...!', '', MB_ICONEXCLAMATION);
  frmLog.Hide;
  frmLog.ShowModal;

Saida:

  // Close #ArqSaida

  // Copia a tabela para JUNTADO.txt
  sSql := 'select * from tempJuncao where moeda='#39'MOE'#39'';
//  RsTemp := DbTemp.OpenRecordset(sSql);

  RsTemp.Close;
  RsTemp.CommandText := sSql;
  RsTemp.Open;

  while not RsTemp.EOF do
    begin
    WriteLn(ArqSaida, RsTemp.FieldByName('Linha').Value);
    RsTemp.Next;
    end;

  sSql := 'select * from tempJuncao where moeda='#39'840'#39'';
//  RsTemp := DbTemp.OpenRecordset(sSql);

  RsTemp.Close;
  RsTemp.CommandText := sSql;
  RsTemp.Open;

  while not RsTemp.EOF do
    begin
    WriteLn(ArqSaida, RsTemp.FieldByName('Linha').Value);
    RsTemp.Next;
    end;

  sSql := 'select * from tempJuncao where moeda <> '#39'840'#39' and moeda <> '#39'MOE'#39'';
//  RsTemp := DbTemp.OpenRecordset(sSql);

  RsTemp.Close;
  RsTemp.CommandText := sSql;
  RsTemp.Open;

  while not RsTemp.EOF do
    begin
    WriteLn(ArqSaida, RsTemp.FieldByName('Linha').Value);
    RsTemp.Next;
    end;
  // Limpa a tabela
  sSql := 'delete from tempJuncao';
  DbTemp.Execute(sSql);

  // Mostra BIN's não cadastrados
  sSql := 'select * from BinErrado';
//  RsTemp := DbTemp.OpenRecordset(sSql);

  RsTemp.Close;
  RsTemp.CommandText := sSql;
  RsTemp.Open;

  gArquivo11 := 'BIN'#39's não localizados'+#13#10+#13#10;
  if not RsTemp.EOF then
    begin
    RsTemp.Last;
    PBar.ProgressBar1.Max := RsTemp.RecordCount;
    RsTemp.First;

    // Comentado para ganhar tempo durante os teste...
    // Do While Not RsTemp.EOF
    // gArquivo11 = gArquivo11 & RsTemp.Fields("Linha") & vbCrLf
    // RsTemp.MoveNext
    // If RsTemp.AbsolutePosition > 0 Then PBar.ProgressBar1.Value = RsTemp.AbsolutePosition
    // DoEvents
    // Loop

    end;
  PBar.Close;
  frmLog.ShowModal;

  Screen.Cursor := crHourGlass;
  // Limpa a tabela
  sSql := 'delete from BinErrado';
  DbTemp.Execute(sSql);

{  RsTemp.Close;
  RsTemp.Free;
  DbTemp.Close;
  DbTemp.Free;}

  CloseFile(ArqEntrada);
  CloseFile(ArqSaida);
  SetLength(gContas, 0+1);
  SetLength(gBIN, 0+1);
  SetLength(gBinGeral, 0+1);

//  Desconecta();

  DbTemp.Close;
  DbCli.Close;
  DbAdm.Close;
  RsTemp.Close;
  RsDb.Close;
  RsDb2.Close;
  RsAdm.Close;

  DbTemp.Free;
  DbCli.Free;
  DbAdm.Free;
  RsTemp.Free;
  RsDb.Free;
  RsDb2.Free;
  RsAdm.Free;

  Screen.Cursor := crDefault;
  Close;
end;

function TfrmJuncao.Validou(Buf: String): Boolean;
var
  I: Smallint;
  BinOK, BinGeralOk, ContaOK: Boolean;
  DbTemp: TAdoConnection;
begin
  BinGeralOk := false;

  // If (Mid$(Buf, Param.conta.Posicao, Param.conta.Tamanho)) = "V215" Then MsgBox "jkhjkhjkhjkh"

  I := 1;
  ContaOK := false;
  BinOK := false;
  while Trim(gContas[I].Conta)<> '9999' do
    begin
    // Debug.Print Trim(gContas(i).Conta)
    // If gContas(I).conta = "0590" And gContas(I).Ref = "00" Then MsgBox "fjdlçºfj"
    // 2008 09 08
    // If Trim(gContas(I).Conta) = "710002CCCP VPC74N" Then MsgBox "Achei um!!!!!!!!!!"

    // S = Trim(Mid$(Buf, Param.Conta.Posicao, Param.Conta.Tamanho)) & " -+ " & Trim(gContas(i).Conta)
    // Debug.Print S
    if (Trim(Copy(Buf, Param.Conta.Posicao, Param.Conta.Tamanho)))=Trim(gContas[I].Conta) then begin
      // And (Mid$(Buf, Param.Ref.Posicao, Param.Ref.Tamanho) = gContas(I).Ref) Then
      ContaOK := true;
      break;
    end;
    I := I+1;
  end;

  I := 1;
  while gBIN[I]<>'9999' do begin
    if (Copy(Buf, Param.BIN.Posicao, Param.BIN.Tamanho)=gBIN[I]) then begin
      BinOK := true;
      break;
    end;
    I := I+1;
  end;

  I := 1;
  while gBinGeral[I]<>'9999' do begin
    if (Copy(Buf, Param.BIN.Posicao, Param.BIN.Tamanho)=gBinGeral[I]) then begin
      BinGeralOk := true;
      break;
    end;
    I := I+1;
  end;
  // If (Not BinOK) And BinGeralOk Then MsgBox "IUYTUIYUIY"
  if  not BinOK then begin
    // Alterado em 2008/10/14 para juntar registros do VSS que não tem BIN
    if Length(Trim(Copy(Buf, Param.BIN.Posicao, Param.BIN.Tamanho)))>0 then
      begin
      if  not BinGeralOk then
        begin
        sSql := 'insert into BinErrado (Linha) Values ('#39''+Buf+''#39')';
        Conecta(DbTemp, gTempDir+'CC_TempVisa.udl');
        DbTemp.Execute(sSql);
        DbTemp.Close;
        DbTemp.Free;
        end;
      end
    else
      BinOK := true;
  end;
  Result := ContaOK and BinOK;

  if Copy(Buf, 1, 3)='CLI' then Result := true;
end;

procedure TfrmJuncao.cmdGravaClick(Sender: TObject);
begin
  try  // On Error GoTo Erro
    if  not Autoriza(cADM) then begin
      Exit;
    end;
    RsAdoJuncao.UpdateRecord;
    Exit;
  except  // Erro:
    if Self.grdJuncao.Text<>'' then begin
      ShowMessage('Arquivo Duplicado');
     end  else  begin
      ShowMessage('Digite o nome do Arquivo');
    end;
//    Err.Clear();
  end;
end;

procedure TfrmJuncao.FormShow(Sender: TObject);
//var
//  strq: String;
begin
  CenterForm(Self);
  // strq = "provider=Microsoft.Jet.OLEDB.3.51;data source=" & gDataPath & gDataFile
//  strq := 'provider=Microsoft.Jet.OLEDB.3.51;data source='+gAdmPath+'\admin.mdb';
  //VBtoADOConnection_Open(cnAdoConect, strq);

  Conecta(cnAdoConect, gAdmPath+'\admin.mdb');
  cnAdoConect.CursorLocation := clUseClient;

  RsAdoJuncao := TADODataSet.Create(nil);
  RsAdoJuncao.Connection := cnAdoConect;

  if gNivel<cADM then
    Self.grdJuncao.Enabled := false;

  AtualizaGrid;
end;

procedure TfrmJuncao.FormResize(Sender: TObject);
begin
  Self.Frame1.Top := 240;
  Self.Frame1.Left := 360;
  Self.Frame1.Height := Self.Height-240-1500;
  Self.Frame1.Width := Self.Width-900;
  Self.Command2.SetFocus;
end;

procedure TfrmJuncao.Form_Unload(var Cancel: Smallint);
begin
   {? On Error Resume Next  }
  Screen.Cursor := crHourGlass;
//  grdJuncao.DataSource := nil;
  RsAdoJuncao.Close;
  RsAdoJuncao.Free;
  cnAdoConect.Close;
  cnAdoConect.Free;
  Screen.Cursor := crDefault;
end;

procedure TfrmJuncao.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

procedure TfrmJuncao.AtualizaGrid();
label
  Erro;
begin

  try  // On Error GoTo Erro
    sSql := 'select nome_arquivo from juncao order by nome_arquivo';
    RsAdoJuncao.Close;
//    VBtoADODataSet_Open(RsAdoJuncao, sSql, cnAdoConect, ctKeyset, ltOptimistic);
    RsAdoJuncao.CommandText := sSql;
    RsAdoJuncao.Open;

//    Self.grdJuncao.DataSource := RsAdoJuncao;
//    Self.grdJuncao.Columns(0).Width := 2000;

    while Not RsAdoJuncao.Eof do
      Begin
      grdJuncao.Lines.Add(RsAdoJuncao.Fields[0].AsString);
      End;

    Exit;
  except  // Erro:
//    Err.Clear();
    { Resume Next }
  end;
end;

procedure TfrmJuncao.FormCreate(Sender: TObject);
begin
  cnAdoConect := TADOConnection.Create(nil);
end;

end.
