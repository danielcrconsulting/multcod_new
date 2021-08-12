unit frmBaixaBanco_;

interface

uses  Forms, Classes, Controls, StdCtrls, Data.DB, Data.Win.ADODB;


type
  TfrmBaixaBanco = class(TForm)
    Label1:  TLabel;
    Label4:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    cmdProcessa:  TButton;
    cmdCancela:  TButton;
    Text3:  TEdit;
    Text6:  TEdit;
    txtObsDeb:  TEdit;
    txtObsCred:  TEdit;
    gBancoAdm: TADOConnection;
    RsDbAdm: TADODataSet;
    gBancoCli: TADOConnection;
    RsDbCli: TADODataSet;

    procedure cmdCancelaClick(Sender: TObject);
    procedure cmdProcessaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }

    function GeraBaixaBanco(Moeda: String; NomeArquivo: String; var Banco: String; NomeSaida: String; Ref: String): Boolean;
    procedure JuntaBaixaManual;
    procedure Atualiza_Baixa_Manual;

  public
    { Public declarations }
  end;

var
  frmBaixaBanco: TfrmBaixaBanco;

implementation

uses  Dialogs, SysUtils, Module1, RotGerais, System.Types, IOUtils, VBto_Converter, pBar_, IdGlobalProtocols,
  frmLog_, DataModuleFormUnit;

{$R *.dfm}

 //=========================================================
procedure TfrmBaixaBanco.cmdCancelaClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBaixaBanco.cmdProcessaClick(Sender: TObject);
var
  Codigo_Cliente, PathBaixa, NomeSaida, DataMov: String;
 //  ArrArquivo: TStringList;
  I: Smallint;
  TemCredito: Boolean;
  ArrArquivo: TStringDynArray;

begin
  ArrArquivo := nil;

  if Length(Text3.Text)<>3 then
    begin
    ShowMessage('Código da Moeda Inválido');
    Text3.SetFocus();
    Exit;
    end;

  if  not isDataValida(Text6.Text) then
    begin
    ShowMessage('Data Inválida');
    Text6.SetFocus();
    Exit;
    end;

  if Length(Self.txtObsDeb.Text)>40 then
    begin
    ShowMessage('Observação não pode ser maior que 40 caracteres');
    Self.txtObsDeb.SetFocus();
    Exit;
    end;

  if Length(Self.txtObsCred.Text)>40 then
    begin
    ShowMessage('Observação não pode ser maior que 40 caracteres');
    Self.txtObsCred.SetFocus();
    Exit;
    end;

  gObsDeb := Self.txtObsDeb.Text;
  gObsCred := Self.txtObsCred.Text;

  if Length(Trim(gConciliacao))=0 then begin
    ShowMessage('Selecione Conciliação');
    Exit;
  end;

  gDataRelatorio := StrToDate(Trim(Text6.Text));
  // Salva dados
//  if Conecta('') then begin
  if Conecta(gBancoCli, gDataPath + gDataFile + '.udl') then
    begin

    // Tirado em 18/03/04 a pedido do Jonas

    if MaxDataDolar(gBancoCli) < gDataRelatorio then
      begin
      ShowMessage('Movimento AINDA não foi atuallizado');
      Close;
      Exit;
      end;

    if MaxDataDolar(gBancoCli) > gDataRelatorio then
      begin
      ShowMessage('Movimento Anterior NÃO pode ser atuallizado');
      Close;
      Exit;
      end;

    sSql := 'select * from baixabanco';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDbCli.CommandText := sSql;
    RsDbCli.Open;

    if RsDbCli.EOF then
      RsDbCli.Insert
    else
      RsDbCli.Edit;
    VBtoADOFieldSet(RsDbCli, 'banco', gCodigoCliente);
    VBtoADOFieldSet(RsDbCli, 'relatorio', 'Banco');
    VBtoADOFieldSet(RsDbCli, 'moeda', Text3.Text);
    RsDbCli.UpdateRecord;
    end;

  Codigo_Cliente := RsDbCli.FieldByName('banco').Value;

//  Desconecta();
  RsDbCli.Close;
  gBancoCli.Close;

  if Length(Codigo_Cliente) <> 3 then
    begin
//    Conecta('adm');
    Conecta(gBancoAdm, ExtractFileDir(Application.ExeName) + '\admin.udl');
    sSql := 'Select * from [clientes]';
    sSql := sSql+' where nome_reduzido = '#39''+gCliente+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDbAdm.CommandText := sSql;
    RsDbAdm.Open;

    if not RsDbAdm.EOF then
      Codigo_Cliente := RsDbAdm.FieldByName('codigo_cliente').Value;
   //  Desconecta();
    RsDbAdm.Close;
    gBancoAdm.Close;

    // Salva dados
 //    if Conecta('') then
//    if Conecta(gBanco, gDataPath + gDataFile + '.udl') then
//      begin
      sSql := 'select * from baixabanco';
//      RsDb := gBanco.OpenRecordset(sSql);
      RsDbCli.CommandText := sSql;
      RsDbCli.Open;

      if RsDbCli.EOF then
        RsDbCli.Insert
      else
        RsDbCli.Edit;
      VBtoADOFieldSet(RsDbCli, 'banco', Codigo_Cliente);
      RsDbCli.UpdateRecord;
 //      end;
    end;

  DataMov := '_20' + Copy(DateToStr(gDataRelatorio), 7, 2);
  DataMov := DataMov + Copy(DateToStr(gDataRelatorio), 4, 2);
  DataMov := DataMov + Copy(DateToStr(gDataRelatorio), 1, 2);

  // Gera Baixa Manual de Credito
//  NomeSaida := GetPath()+'\';
  NomeSaida := ExtractFileDir(Application.ExeName) + '\';
  NomeSaida := NomeSaida+gCliente+'\entrada\';
  NomeSaida := NomeSaida+'BaixaManualCred'+DataMov;
  NomeSaida := NomeSaida+'.txt';

//  if Dir(NomeSaida)<>'' then begin
  if FileExists(NomeSaida) then
    DeleteFile(NomeSaida);

  PathBaixa := ExtractFileDir(Application.ExeName)+'\';
  PathBaixa := PathBaixa+gCliente+'\Bx_Banco_Cred\';

//  NomeArquivo := Dir(PathBaixa+Trim(Concil.ContaContabil)+'*'+DataMov+'.prn');
  ArrArquivo := TDirectory.GetFiles(PathBaixa, Trim(Concil.ContaContabil)+'*'+DataMov+'.prn', TSearchOption.soTopDirectoryOnly);

  TemCredito := false;
{  I := 0;
  while NomeArquivo<>'' do
    begin
    I := I+1;
    ReDimPreserve(ArrArquivo, I+1);
    ArrArquivo[I] := NomeArquivo;
    NomeArquivo := Dir();
    end;
  if I <> 0 then
    begin
    TemCredito := true;
    I := I+1;
    ReDimPreserve(ArrArquivo, I+1);
    ArrArquivo[I] := '';
    I := 1;
    PegaPar();
    while ArrArquivo[I]<>'' do
      begin
      if GeraBaixaBanco(Text3.Text, PathBaixa+ArrArquivo[I], Codigo_Cliente, NomeSaida, '99') then
        begin
        // MsgBox "Arquivo Gerado!!!"
        end
      else
        begin
        ShowMessage('Erro na Geração do Arquivo???');
        Exit;
        end;
      I := I+1;
      end;
    end;        }

  for I := Low(ArrArquivo) to High(ArrArquivo) do
    if GeraBaixaBanco(Text3.Text, PathBaixa+ArrArquivo[I], Codigo_Cliente, NomeSaida, '99') then
      begin
        // MsgBox "Arquivo Gerado!!!"
      end
    else
      begin
      ShowMessage('Erro na Geração do Arquivo???');
      Exit;
      end;

  // Gera Baixa Manual de Débito
  NomeSaida := ExtractFileDir(Application.ExeName)+'\';
  NomeSaida := NomeSaida+gCliente+'\entrada\';
  NomeSaida := NomeSaida+'BaixaManualDeb'+DataMov;
  NomeSaida := NomeSaida+'.txt';

  if FileExists(NomeSaida) then
    DeleteFile(NomeSaida);

  PathBaixa := ExtractFileDir(Application.ExeName)+'\';
  PathBaixa := PathBaixa+gCliente+'\Bx_Banco_Deb\';

//  NomeArquivo := Dir(PathBaixa+Trim(Concil.ContaContabil)+'*'+DataMov+'.prn');
  ArrArquivo := TDirectory.GetFiles(PathBaixa, Trim(Concil.ContaContabil)+'*'+DataMov+'.prn', TSearchOption.soTopDirectoryOnly);

{  I := 0;
  while NomeArquivo<>'' do begin
    I := I+1;
    ReDimPreserve(ArrArquivo, I+1);
    ArrArquivo[I] := NomeArquivo;
    NomeArquivo := Dir();
  end; }

  if (Length(ArrArquivo)=0) and  not TemCredito then
    begin
    ShowMessage('Nenhum arquivo encontrado');
    Close;
//    ReDim(ArrArquivo, 0+1);
    Exit;
    end;

{  I := I+1;
  ReDimPreserve(ArrArquivo, I+1);
  ArrArquivo[I] := '';
  I := 1; }

  PegaPar;

{  while ArrArquivo[I]<>'' do begin
    if  not GeraBaixaBanco(Text3.Text, PathBaixa+ArrArquivo[I], Codigo_Cliente, NomeSaida, '98') then begin
      ShowMessage('Erro na Geração do Arquivo???');
    end;
    I := I+1;
  end; }

  for I := Low(ArrArquivo) to High(ArrArquivo) do
    if GeraBaixaBanco(Text3.Text, PathBaixa+ArrArquivo[I], Codigo_Cliente, NomeSaida, '98') then
      begin
        // MsgBox "Arquivo Gerado!!!"
      end
    else
      begin
      ShowMessage('Erro na Geração do Arquivo???');
      Exit;
      end;

  JuntaBaixaManual;

  Atualiza_Baixa_Manual;

//  ReDim(ArrArquivo, 0+1);
  Close;
end;

procedure TfrmBaixaBanco.FormShow(Sender: TObject);
begin
  CenterForm(Self);
  Text6.Text := '';
//  if  not Conecta('') then
  if not Conecta(gBancoCli, gDataPath + gDataFile + '.udl') then
    Text3.Text := '986'
  else
    begin
    sSql := 'select * from baixabanco';
//    RsDb := gBanco.OpenRecordset(sSql);

    RsDbCli.CommandText := sSql;
    RsDbCli.Open;
    if not RsDbCli.EOF then
      Text3.Text := RsDbCli.FieldByName('moeda').Value
    else
      Text3.Text := '986';
  end;
//  Desconecta();
  gBancoCli.CLose;
  RsDbCli.Close;
end;

function TfrmBaixaBanco.GeraBaixaBanco(Moeda: String; NomeArquivo: String; var Banco: String; NomeSaida: String; Ref: String): Boolean;
label
  Saida, Erro;
var
  ArqEntrada, ArqSaida: System.Text;
  Buffer, BufferSai, Cartao, Valor, Relatorio, Codigo, Arquivo: String;
  iPosicao: Integer;
  iFileLen: Extended;
  I: Integer;
begin
  iPosicao := 0;

  Relatorio := pegaNomeRel(NomeArquivo);
  // pesquisar codigo_para
  Codigo := Copy(Relatorio, Length(Relatorio)-3, 4);

  Result := true;

  // Abre o arquivo de entrada
  if FileExists(NomeArquivo) then
    begin
    AssignFile(ArqEntrada, NomeArquivo);
    Reset(ArqEntrada);
    end
  else
    begin
    Result := false;
    goto Saida;
    end;

  AssignFileAsAppend(ArqSaida, NomeSaida);

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Gerando Tabela...';
  iFileLen := FileSizeByName(NomeArquivo);
  if FileSizeByName(NomeSaida)=0 then
    begin
    BufferSai := 'CLICODREL    MOECARTAO          CODIGO                              VALOR     RRDATA_   ';
    WriteLn(ArqSaida, BufferSai);
    end;

  // Monta tabela Interface

  DataModule.ConectaAdm;
  DataModule.Monta_Interface;
  DataModule.DesconectaAdm;

  while not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    if Length(Trim(Buffer))=0 then
      break;

//    iPonteiro := 1;
    iPosicao := iPosicao+Length(Buffer)+2;
    if (iPosicao/iFileLen)*100>100 then
      PBar.ProgressBar1.Position := 100
    else
      PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100);

    // If iCountReg Mod 10 = 0 Then
    // fMainForm.sbStatusBar.Panels(1).Text = "Processando Registro " & Str(iCountReg)
    // End If
    I := 1;
    // Elimina brancos no inicio da linha
    if Copy(Buffer, I, 1)=' ' then begin
      while Copy(Buffer, I, 1)=' ' do begin
        I := I+1;
      end;
    end;
    // Pega Número do Cartão
    Cartao := '';
    while Copy(Buffer, I, 1)<>' ' do begin
      Cartao := Cartao+Copy(Buffer, I, 1);
      I := I+1;
    end;
    if Length(Trim(Cartao))<>16 then goto Erro;
    // Elimina brancos entre os campos
    while Copy(Buffer, I, 1)=' ' do begin
      I := I+1;
    end;
    // Pega Valor da Transação
    Valor := '';
    while Copy(Buffer, I, 1)<>' ' do begin
      Valor := Valor+Copy(Buffer, I, 1);
      I := I+1;
      if I>Length(Buffer) then break;
    end;
    // If Len(Trim(Valor)) > Param.Ref.Posicao - Param.Valor.Posicao Then GoTo Erro
    if Length(Trim(Valor)) > 10 then
      goto Erro;

    Application.ProcessMessages;
    if Length(Banco) < 3 then
      Banco := Banco+StringOfChar(' ', 3-Length(Banco));
    BufferSai := Banco;
    BufferSai := BufferSai + Relatorio+StringOfChar(' ', 10-Length(Trim(Relatorio)));
    BufferSai := BufferSai + Moeda;
    BufferSai := BufferSai + Cartao;
    BufferSai := BufferSai + DataModule.Get_Codigo_Para(Relatorio);
    BufferSai := BufferSai + StringOfChar(' ', Param.Data.Posicao-Param.Valor.Posicao-2-Length(Trim(Valor)))+Valor+StringOfChar(' ', 2);
    // BufferSai = BufferSai & Valor & Space(10 - Len(Trim(Valor)))
    // BufferSai = BufferSai & Ref
    BufferSai := BufferSai + DateToStr(gDataRelatorio);

    WriteLn(ArqSaida, BufferSai);
  end;

Saida:
  // fMainForm.sbStatusBar.Panels(1).Text = "Processando Registro " & Str(iCountReg)
  CloseFile(ArqEntrada);
  CloseFile(ArqSaida);
  PBar.Close;

  BarraStatus;
  // fMainForm.sbStatusBar.Panels(1).Text = "Cliente: " & gCliente
  Exit;

Erro:
  ShowMessage('Cartao ou Valor incorretos no arquivo');
  // Resume Next
  if FileExists(NomeSaida) then
    DeleteFile(NomeSaida);
  Result := false;
  goto Saida;

end;

procedure TfrmBaixaBanco.JuntaBaixaManual;
label
  Saida;
var
  ArqEntrada, ArqSaida: System.Text;
  Buffer, NomeSaida, Path, Arquivo,
  NomeArquivo: String;
  iPosicao: Integer;
  iFileLen, NroReg: Extended;
  Aberto, TemDebito: Boolean;
//  gBanco : TAdoConnection;
begin
  iPosicao := 0;

//  if  not Conecta('') then
//    Exit;
//  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
//    Exit;

  Path := gAdmPath+'\';
  Path := Path+gCliente+'\entrada\';

  NomeSaida := Path+'JUNTADO';

  NomeArquivo := '_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);

  Arquivo := Path+Arquivo+NomeArquivo+'.txt';
  NomeSaida := NomeSaida+NomeArquivo+'.txt';

  if FileExists(NomeSaida) then
    DeleteFile(NomeSaida);
  AssignFile(ArqSaida, NomeSaida);
  Rewrite(ArqSaida);
  Aberto := false;

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Preparando Arquivo de Entrada...';

  Arquivo := Path+'BaixaManualDeb'+NomeArquivo+'.txt';
  gArquivo11 := '';

  // Abre o arquivo de entrada
  TemDebito := false;
  if FileExists(Arquivo) then
    begin
    AssignFile(ArqEntrada, Arquivo);
    Reset(ArqEntrada);
    Aberto := true;
    TemDebito := true;
    end;

  if Aberto then
    begin
    NroReg := 0;
    iFileLen := FileSizeByName(Arquivo);

    while not Eof(ArqEntrada) do
      begin
      ReadLn(ArqEntrada, Buffer);
      WriteLn(ArqSaida, Buffer);
      iPosicao := iPosicao+Length(Buffer)+2;
      if iPosicao/iFileLen<=1 then
        PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
      else
        PBar.ProgressBar1.Position := 100;

      Application.ProcessMessages;
      NroReg := NroReg+1;
    end;
    CloseFile(ArqEntrada);
    Aberto := false;
  end;

  Arquivo := Path+'BaixaManualCred'+NomeArquivo+'.txt';
  gArquivo11 := '';

  // Abre o arquivo de entrada
  if FileExists(Arquivo) then
    begin
    AssignFile(ArqEntrada, Arquivo);
    Reset(ArqEntrada);
    Aberto := true;
    end;

  if Aberto then
    begin
    NroReg := 0;
    iFileLen := FileSizeByName(Arquivo);
    iPosicao := 0;
    if TemDebito then
      ReadLn(ArqEntrada, Buffer);
    while not Eof(ArqEntrada) do
      begin
      ReadLn(ArqEntrada, Buffer);
      WriteLn(ArqSaida, Buffer);
      iPosicao := iPosicao+Length(Buffer)+2;
      if iPosicao/iFileLen<=1 then
        PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
      else
        PBar.ProgressBar1.Position := 100;
      Application.ProcessMessages;
       NroReg := NroReg+1;
      end;
    CloseFile(ArqEntrada);
  end;

Saida:
  CloseFile(ArqEntrada);
  CloseFile(ArqSaida);

  PBar.Close;
end;

procedure TfrmBaixaBanco.Atualiza_Baixa_Manual;
var
  Buffer, Buffer1, buffer2, NomeTmp,
  NomeArquivo: String;
  I: Integer;
begin

  if  not Autoriza(cATUALIZA) then
    Exit;

  if Length(gConciliacao)=0 then
    begin
    ShowMessage('Selecione Conciliação...');
    Exit;
    end;

//  if  not Conecta('') then Exit;

  sSql := 'select * from tb_moeda where str(data) = '#39'' + Copy(DateToStr(gDataRelatorio), 1, 6) + '20' +
          Copy(DateToStr(gDataRelatorio), 7, 2)+''#39'';
  sSql := 'select * from tb_moeda ';
  sSql := sSql+'where str(data) = '#39''+DateToStr(gDataRelatorio)+''#39'';
//  sSql := sSql+' or str(data) = '#39''+dataDezBarra(gDataRelatorio)+''#39'';
  sSql := sSql+' or str(data) = '#39''+DateToStr(gDataRelatorio)+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);

  RsDbCli.CommandText := sSql;

  if RsDbCli.EOF then
    begin
    ShowMessage('Dolar não está cadastrado');
    Exit;
    end;
  gTaxa := RsDbCli.FieldByName('valor').Value;

  //Desconecta;
  RsDbCli.Close;

//  NomeArquivo := GetPath+'\';
  NomeArquivo := ExtractFileDir(Application.ExeName) + '\';
  // NomeArquivo = NomeArquivo & gCliente & "\entrada\" & Trim(Concil.ArqEntrada)
  NomeArquivo := NomeArquivo+gCliente+'\entrada\'+'JUNTADO';
  NomeArquivo := NomeArquivo+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeArquivo := NomeArquivo+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeArquivo := NomeArquivo+'.txt';

  NomeTmp := ExtractFileDir(Application.ExeName) + '\';
  NomeTmp := NomeTmp+gCliente+'\entrada\'+Trim(Concil.ContaContabil);
  NomeTmp := NomeTmp+'_20'+Copy(DateToStr(gDataRelatorio), 7, 2);
  NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 4, 2);
  NomeTmp := NomeTmp+Copy(DateToStr(gDataRelatorio), 1, 2);
  NomeTmp := NomeTmp+'.tmp';

  if GeraTemp(NomeTmp, NomeArquivo) then
    NomeArquivo := NomeTmp
  else
    Exit;

  gArquivo11 := '';

  // Unload frmLog
  // frmLog.Show vbModal
  frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+String(Concil.ContaContabil)+' - '+gConciliacao+#10+'     Débitos    Créditos       Saldo'+#10+#10;
  gAutomatico := false;
  gTotDebito := 0;
  gTotCredito := 0;
  gSaldo := FloatToStr(GetSaldo);
  if Concil.Natureza='D' then begin
    // Processa primeiro Dolar
    for I:=0 to ncDebito-1 do begin
      if  not ContaDebito(I, '840', NomeArquivo) then Exit;
    end; // I
    for I:=0 to ncCredito-1 do begin
      if  not ContaCredito(I, '840', NomeArquivo) then Exit;
    end; // I

    for I:=0 to ncDebito-1 do begin
      if  not ContaDebito(I, '986', NomeArquivo) then Exit;
    end; // I
    for I:=0 to ncCredito-1 do begin
      if  not ContaCredito(I, '986', NomeArquivo) then Exit;
    end; // I
   end  else  begin
    for I:=0 to ncCredito-1 do begin
      if  not ContaCredito(I, '840', NomeArquivo) then Exit;
    end; // I
    for I:=0 to ncDebito-1 do begin
      if  not ContaDebito(I, '840', NomeArquivo) then Exit;
    end; // I

    for I:=0 to ncCredito-1 do begin
      if  not ContaCredito(I, '986', NomeArquivo) then Exit;
    end; // I
    for I:=0 to ncDebito-1 do begin
      if  not ContaDebito(I, '986', NomeArquivo) then Exit;
    end; // I
  end;

  // Faz Backup do banco de dados com as novas movimentações
  BackupBanco;

  // Mostra Débitos e Créditos
  Buffer := FormatVB(gTotDebito,'###,##0.00');
  Buffer1 := FormatVB(gTotCredito,'###,##0.00');
  buffer2 := FormatVB(GetSaldo,'###,##0.00');

  frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+#10+StringOfChar(' ', 15-Length(Buffer))+Buffer+' '+StringOfChar(' ', 15-Length(Buffer1))+Buffer1+' '+StringOfChar(' ', 15-Length(buffer2))+buffer2+#10;

  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close;
  frmLog.ShowModal;
end;

end.
