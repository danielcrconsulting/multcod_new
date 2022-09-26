unit UFrmConsultaExportacoesRemoto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Datasnap.Provider, Vcl.StdCtrls, Vcl.Menus, Vcl.ExtCtrls, ADODB,
  Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdSSLOpenSSL, System.Json, System.Zlib, System.Zip, System.Threading, System.IniFiles;

type
  TFrmConsultaExportacoesRemoto = class(TForm)
    DSProcessadorTemplate: TDataSource;
    DBGridConsultaExportacao: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    BtnFechar: TButton;
    PopupMenuGrid: TPopupMenu;
    BaixarArquivo1: TMenuItem;
    AbrirTemplate1: TMenuItem;
    Label1: TLabel;
    Bevel1: TBevel;
    BtnDownload: TButton;
    Label2: TLabel;
    LblNomeUsuario: TLabel;
    BtnAbrirTemplate: TButton;
    Label3: TLabel;
    ComboBoxStatus: TComboBox;
    BtnPesquisar: TButton;
    Panel3: TPanel;
    Label4: TLabel;
    DateTimePickerIni: TDateTimePicker;
    DateTimePickerFin: TDateTimePicker;
    CheckBoxData: TCheckBox;
    SaveDialog1: TSaveDialog;
    LblStatus: TLabel;
    ProgressBar1: TProgressBar;
    btnexcluir: TButton;
    procedure BtnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure BtnAbrirTemplateClick(Sender: TObject);
    procedure BtnDownloadClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnexcluirClick(Sender: TObject);
  strict private
    { Private declarations }
    FCodUsuario: String;
    FUrlBase, urldow: String;
    ArquivoINI : TIniFile;

    wfilename, waFileName : String;
    procedure DownloadFile(aFileName: String);
    procedure BaixarArquivo;
  public
    { Public declarations }
    procedure SetParameters(codUsuario, urlBase: String);
    procedure DimensionarGrid(dbg: TDBGrid);
    procedure Descomprimir(ArquivoZip: TFileName; DiretorioDestino: string);

    procedure ConverterJSONParaArquivo(pArquivoJSON: TJSONArray; pDir: string);
  end;

  TMyThreadPathResultEvent = procedure(const APath: string; AResult: Boolean; AStream: TStream) of object;
  TMyThreadStatusEvent = procedure(const APath, AStr: string) of object;

  TMyThreadWorkBeginEvent = procedure(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64) of object;
  TMyThreadWorkEvent = procedure(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64) of object;
  TMyThreadWorkEndEvent = procedure(ASender: TObject; AWorkMode: TWorkMode) of object;


  TMyThread = class(TThread)
  strict private
    FStream: TFileStream;
    FUrl, FLocalFile: string;
    FHTTP: TIdHTTP;
    FdSSL: TIdSSLIOHandlerSocketOpenSSL;

    fOnPathResult: TMyThreadPathResultEvent;
    fOnStatus: TMyThreadStatusEvent;
    FOnWorkBegin: TMyThreadWorkBeginEvent;
    FOnWork: TMyThreadWorkEvent;
    FOnWorkEnd: TMyThreadWorkEndEvent;

    procedure PathResult(AResult: Boolean);
    procedure ShowStatus(const Str: string);
  protected
    procedure Execute; override;
  public
    constructor Create(const AUrl, ALocalFile: string); reintroduce;
    Destructor Destroy; override;
    property OnPathResult: TMyThreadPathResultEvent read fOnPathResult write fOnPathResult;
    property OnStatus: TMyThreadStatusEvent read fOnStatus write fOnStatus;

    property OnWork: TMyThreadWorkEvent read FOnWork write FOnWork;
    property OnWorkBegin: TMyThreadWorkBeginEvent read FOnWorkBegin write FOnWorkBegin;
    property OnWorkEnd: TMyThreadWorkEndEvent read FOnWorkEnd write FOnWorkEnd;

    procedure CancelarDownload;

  end;

var
  FrmConsultaExportacoesRemoto: TFrmConsultaExportacoesRemoto;

implementation

{$R *.dfm}

uses Sugeral, MExtract, UFrmDownloadManager;


procedure TFrmConsultaExportacoesRemoto.BtnAbrirTemplateClick(Sender: TObject);
var
  sql: String;
  templateCompactado: AnsiString;
begin
  if DSProcessadorTemplate.DataSet.FieldByName('TipoProcessamento').AsInteger = 2 then
  begin
    MessageDlg('Só é possível abrir o template para processamento de Extrações.', TMsgDlgType.mtInformation, [mbOk], 0);
    exit;
  end;
  if DSProcessadorTemplate.DataSet.RecordCount = 0 then
  begin
    MessageDlg('Só é possível abrir o template com arquivo aberto.', TMsgDlgType.mtInformation, [mbOk], 0);
    exit;
  end;

  //FormGeral.ADOQueryTemplate.Close;
  //FormGeral.ADOQueryTemplate.SQL.Clear;

  sql := 'select 	ArquivoTemplateComp from TemplateExportacao ' +
    //' where Id = :Id' ;
         ' where Id = ' + TClientDataSet(DSProcessadorTemplate.DataSet).FieldByName('IdReferencia').AsString;
  //FormGeral.ADOQueryTemplate.SQL.Clear;
  //FormGeral.ADOQueryTemplate.SQL.Add(sql);

  //FormGeral.ADOQueryTemplate.Parameters.ParamValues['Id'] := TClientDataSet(DSProcessadorTemplate.DataSet).FieldByName('IdReferencia').AsInteger;

  //FormGeral.ADOQueryTemplate.Open;
  //templateCompactado := FormGeral.ADOQueryTemplate.FieldByName('ArquivoTemplateComp').AsString;
  //FormGeral.ADOQueryTemplate.Close;
  //FormGeral.ImportarDados(sql,nil);
  //templateCompactado := FormGeral.memtb.FieldByName('ArquivoTemplateComp').AsString;

  templateCompactado := formgeral.RetornarArqTemplate(TClientDataSet(DSProcessadorTemplate.DataSet).FieldByName('IdReferencia').AsInteger);

  FrmExtract.AbrirTemplateCompactado(templateCompactado);
  FrmExtract.Show;

  Self.Close;
end;

procedure TFrmConsultaExportacoesRemoto.BtnDownloadClick(Sender: TObject);
var
  fullFileName,
  fileName: String;
begin
  if TClientDataSet(DSProcessadorTemplate.DataSet).FieldByName('StatusProcessamento').AsString = 'S' then
  begin
    fullFileName := TClientDataSet(DSProcessadorTemplate.DataSet).FieldByName('PathArquivoExportacao').AsString;
    fullFileName := StringReplace(fullFileName, '/', '\', [rfIgnoreCase, rfReplaceAll]);
    fileName := ExtractFileName(fullFileName);
    DownloadFile(fileName);
  end else
    MessageDlg('Só é possível baixar o arquivo quando o processamento estiver finalizado.', TMsgDlgType.mtInformation, [mbOk], 0);

end;

procedure TFrmConsultaExportacoesRemoto.btnexcluirClick(Sender: TObject);
var
  idx : Integer;
  strid : String;
begin
  strid := '';
  if DBGridConsultaExportacao.SelectedRows.Count > 0 then
  begin
    if MessageDlg('Você tem certeza que deseja excluir estes arquivos ?',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      for idx := 0 to DBGridConsultaExportacao.SelectedRows.Count -1 do
      begin
        DBGridConsultaExportacao.DataSource.DataSet.GotoBookmark((DBGridConsultaExportacao.SelectedRows.Items[idx]));
        strid := strid + DBGridConsultaExportacao.DataSource.DataSet.FieldByName('id').Value + ',';
      end;
      delete(strid,length(strid),1)
    end;
    if formGeral.ExcluirArquivos(strid) then
      ShowMessage('Arquivos excluídos com sucesso !')
    else
      ShowMessage('Falha na exclusão dos arquivos !');
    BtnPesquisar.Click;
  end
  else
    ShowMessage('Atenção nenhum arquivo selecionado !');
end;

procedure TFrmConsultaExportacoesRemoto.BtnFecharClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmConsultaExportacoesRemoto.BtnPesquisarClick(Sender: TObject);
var
  sql, strstatus: String;
  dataFinal: TDatetime;
begin
  DSProcessadorTemplate.DataSet.Close;
  case ComboBoxStatus.ItemIndex of
    0: strstatus := 'P';
    1: strstatus := 'E';
    2: strstatus := 'S';
    3: strstatus := 'R';
  end;
  if CheckBoxData.Checked then
  begin
    dataFinal :=  DateTimePickerFin.Date;
    ReplaceTime(dataFinal, EncodeTime(23, 59, 59, 0));
    sql := 'select top 100 Id,	IdReferencia, replace(PathArquivoExportacao,' + quotedStr('\') + ',' + QuotedStr('/') + ') PathArquivoExportacao, TipoProcessamento, NomeTemplate, DataCriacao, StatusProcessamento, ' +
      '	CODUSUARIO from ConsultaProcessamento ' +
      //' where CODUSUARIO = :CODUSUARIO and StatusProcessamento = :STATUS ' +
      ' where CODUSUARIO = ' + QuotedStr(FCodUsuario) + ' and StatusProcessamento = ' + QuotedStr(strstatus) +
      ' and DataCriacao between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTimePickerIni.Date)) + ' and ' +
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', dataFinal))+
      ' order by 1 desc ';
      FormGeral.ImportarDados(sql,nil);
      //FormGeral.ADOQueryProcessadorTemplate.SQL.Clear;
      //FormGeral.ADOQueryProcessadorTemplate.SQL.Add(sql);
  end else
  begin
    sql := 'select top 100 Id,	IdReferencia, replace(PathArquivoExportacao,' + quotedStr('\') + ',' + QuotedStr('/') + ') PathArquivoExportacao, TipoProcessamento, NomeTemplate, DataCriacao, StatusProcessamento, ' +
      '	CODUSUARIO from ConsultaProcessamento ' +
      //' where CODUSUARIO = ' + QuotedStr(FCodUsuario) + ' and StatusProcessamento = :STATUS ' +
      ' where CODUSUARIO = ' + QuotedStr(FCodUsuario) + ' and StatusProcessamento = ' + QuotedStr(strstatus) +
      ' order by 1 desc ';
      FormGeral.ImportarDados(sql,nil);
      //FormGeral.ADOQueryProcessadorTemplate.SQL.Clear;
      //FormGeral.ADOQueryProcessadorTemplate.SQL.Add(sql);
  end;

  {
  TClientDataSet(DSProcessadorTemplate.DataSet).ParamByName('CODUSUARIO').AsString := FCodUsuario;

  case ComboBoxStatus.ItemIndex of
    0: TClientDataSet(DSProcessadorTemplate.DataSet).ParamByName('STATUS').AsString := 'P';
    1: TClientDataSet(DSProcessadorTemplate.DataSet).ParamByName('STATUS').AsString := 'E';
    2: TClientDataSet(DSProcessadorTemplate.DataSet).ParamByName('STATUS').AsString := 'S';
    3: TClientDataSet(DSProcessadorTemplate.DataSet).ParamByName('STATUS').AsString := 'R';
  end;
  }
  if FormGeral.Memtb.Active then
  begin
    DSProcessadorTemplate.DataSet.Open;
    DimensionarGrid(DBGridConsultaExportacao);
    BtnAbrirTemplate.Enabled := True;
  end
  else
    BtnAbrirTemplate.Enabled := False;

  if ComboBoxStatus.Text = 'Sucesso' then
    btnexcluir.Visible := True
  else
    btnexcluir.Visible := False;
end;


procedure TFrmConsultaExportacoesRemoto.DimensionarGrid(dbg: TDBGrid);
type
  TArray = Array of Integer;
  procedure AjustarColumns(Swidth, TSize: Integer; Asize: TArray);
  var
    idx: Integer;
  begin
    if TSize = 0 then
    begin
      TSize := dbg.Columns.count;
      for idx := 0 to dbg.Columns.count - 1 do
        dbg.Columns[idx].Width := (dbg.Width - dbg.Canvas.TextWidth('AAAAAA')
          ) div TSize
    end
    else
      for idx := 0 to dbg.Columns.count - 1 do
        dbg.Columns[idx].Width := dbg.Columns[idx].Width +
          (Swidth * Asize[idx] div TSize);
  end;

var
  idx, Twidth, TSize, Swidth: Integer;
  AWidth: TArray;
  Asize: TArray;
  NomeColuna: String;
begin
  SetLength(AWidth, dbg.Columns.count);
  SetLength(Asize, dbg.Columns.count);
  Twidth := 0;
  TSize := 0;
  for idx := 0 to dbg.Columns.count - 1 do
  begin
    NomeColuna := dbg.Columns[idx].Title.Caption;
    dbg.Columns[idx].Width := dbg.Canvas.TextWidth
      (dbg.Columns[idx].Title.Caption + 'A');
    AWidth[idx] := dbg.Columns[idx].Width;
    Twidth := Twidth + AWidth[idx];

    if Assigned(dbg.Columns[idx].Field) then
      Asize[idx] := dbg.Columns[idx].Field.Size
    else
      Asize[idx] := 1;

    TSize := TSize + Asize[idx];
  end;
  if TDBGridOption.dgColLines in dbg.Options then
    Twidth := Twidth + dbg.Columns.count;

  // adiciona a largura da coluna indicada do cursor
  if TDBGridOption.dgIndicator in dbg.Options then
    Twidth := Twidth + IndicatorWidth;

  Swidth := dbg.ClientWidth - Twidth;
  AjustarColumns(Swidth, TSize, Asize);
end;

procedure TFrmConsultaExportacoesRemoto.ConverterJSONParaArquivo(pArquivoJSON: TJSONArray;
  pDir: string);
var
  SSArquivoStream: TStringStream;
  sArquivoString, sNomeArquivo, sDir: String;
  iTamanhoArquivo, iCont: Integer;
  SLArrayStringsArquivo: TStringList;
  byArquivoBytes: Tbytes;
begin
  try
    sArquivoString := pArquivoJSON.Get(0).ToString;  // Pega a posição 0 do array que contem os bytes do arquivo
    Delete(sArquivoString, Length(sArquivoString), 1); // Deleta a última aspas da string
    Delete(sArquivoString, 1, 1); // Deleta a primeira aspas da string

    //sNomeArquivo := pArquivoJSON.Get(2).ToString;  // Pega o nome do arquivo que está na posição 2
    sNomeArquivo := ExtractFileName(pdir);
    //Delete(sNomeArquivo, Length(sNomeArquivo), 1); // Deleta a última aspas da string
    //Delete(sNomeArquivo, 1, 1); // Deleta a primeira aspas da string

    iTamanhoArquivo := TJSONNumber(pArquivoJSON.Get(1)).AsInt; // Pega na posição 1 o tamanho do arquivo

    SLArrayStringsArquivo := TStringList.Create; // Cria um obje do tipo TStringList para emparelhar os bytes
    ExtractStrings([','], [' '], PChar(sArquivoString), SLArrayStringsArquivo); // Coloca cada byte em uma linha no objeto TStringList

    SetLength(byArquivoBytes, iTamanhoArquivo); // Seta o tamanho do array de bytes igual ao tamanho do arquivo

    // Faz um laço para pegar os bytes do objeto TStringList
    for iCont := 0 to iTamanhoArquivo - 1 do
    begin
      //Pega os bytes do TStringList e adiciona no array de bytes
      byArquivoBytes[iCont] := StrToInt(SLArrayStringsArquivo[iCont]);
    end;
    SSArquivoStream := TStringStream.Create(byArquivoBytes); // Instancia o objeto TStringStream para salvar o arquivo

    // Verifica se o diretório passado por parâmetro não existe
    sDir := ExtractFileDir(pDir);
    if not DirectoryExists(sDir) then
      ForceDirectories(sDir); // Se não existir o diretório vai ser criado

    SSArquivoStream.SaveToFile(sDir + '/' + sNomeArquivo); // Salvar o arquivo no hd
  finally
    SSArquivoStream.Free;
    SLArrayStringsArquivo.Free;
  end;
end;

procedure TFrmConsultaExportacoesRemoto.Descomprimir(ArquivoZip: TFileName; DiretorioDestino: string);
var
  NomeSaida: string;
  FileEntrada, FileOut: TFileStream;
  Descompressor: TDecompressionStream;
  NumArq, I, Len, Size: Integer;
  Fim: Byte;
begin
  FileEntrada := TFileStream.Create(ArquivoZip, fmOpenRead and fmShareExclusive);
  Descompressor := TDecompressionStream.Create(FileEntrada);
  Descompressor.Read(NumArq, SizeOf(Integer));
  try
    I := 0;
    while I < NumArq do begin
      Descompressor.Read(Len, SizeOf(Integer));
      SetLength(NomeSaida, Len);
      Descompressor.Read(NomeSaida[1], Len);
      Descompressor.Read(Size, SizeOf(Integer));
      FileOut := TFileStream.Create(
        IncludeTrailingBackslash(DiretorioDestino) + NomeSaida,
        fmCreate or fmShareExclusive);
      try
        FileOut.CopyFrom(Descompressor, Size);
      finally
        FileOut.Free;
      end;
      Descompressor.Read(Fim, SizeOf(Byte));
      Inc(I);
    end;
  finally
    FreeAndNil(Descompressor);
    FreeAndNil(FileEntrada);
  end;
end;


procedure TFrmConsultaExportacoesRemoto.BaixarArquivo;
var
  oArquivoJSON : TJSONArray;
  ZipFile: TZipFile;
begin
  oArquivoJSON := FormGeral.BaixarArquivo(wFilename);
  ZipFile := TZipFile.Create;
  ZipFile.Open(ExtractFileDir(SaveDialog1.FileName) + '\arq.zip', zmReadWrite);
  ZipFile.ExtractAll(ExtractFileDir(SaveDialog1.FileName));
  RenameFile(ExtractFileDir(SaveDialog1.FileName) + '\' + waFileName, SaveDialog1.FileName);
  FreeAndNil(ZipFile);
  DeleteFile(ExtractFileDir(SaveDialog1.FileName) + '\arq.zip');
end;

procedure TFrmConsultaExportacoesRemoto.DownloadFile(aFileName: String);
var
  IdHTTP1: TIdHTTP;
  Stream: TMemoryStream;
  Url, FileName: String;
  i: Integer;
  Thread: TMyThread;
  download: TDownload;
  oArquivoJSON : TJSONArray;
  ZipFile: TZipFile;
  Tasks: array [0..0] of ITask;
  strArq : TStringList;
  vArquivo: TFileStream;
begin
  //Url := FUrlBase + aFileName;
  ProgressBar1.Visible := True;
  ProgressBar1.Max := 3;
  Url := 'C:\ROM\MULTICOLD\Destino\Extracoes\' + aFileName;
  Filename := aFileName;
  SaveDialog1.FileName := fileName;
  ProgressBar1.Position := 1;

  Application.ProcessMessages;
  if not SaveDialog1.Execute then
  begin
    ProgressBar1.Visible := False;
    exit;
  end;

  vArquivo := TFileStream.Create(SaveDialog1.FileName,fmCreate);

  Try
    IdHTTP1 := TIdHTTP.Create;
    Try
      idHTTP1.Request.Username := 'multicoldserver';
      idHTTP1.Request.Password := 'server@#2021';
      ProgressBar1.Position := 2;
      idHTTP1.Get(urldow + '/' + aFileName ,vArquivo);
      ProgressBar1.Position := 3;
      ShowMessage('Download OK !');
    Except
      ShowMessage('Não foi possivel baixar o arquivo !');
    End;
  Finally
    FreeAndNil(vArquivo);
    FreeAndNil(IdHTTP1);
    ProgressBar1.Visible := False;
  End;
  exit;


  wfilename  := filename;
  waFileName := aFileName;

  //Tasks[0] := TTask.Create(BaixarArquivo);
  //Tasks[0].Start;
  //exit;

  //oArquivoJSON := FormGeral.BaixarArquivo(Filename);

  //ConverterJSONParaArquivo(oArquivoJSON, ExtractFileDir(SaveDialog1.FileName) + '\arq.zip');
  //ProgressBar1.Position := 2;
  //ShowMessage('Baixou o arquivo como zip');
  //ZipFile := TZipFile.Create;
  //ZipFile.Open(ExtractFileDir(SaveDialog1.FileName) + '\arq.zip', zmReadWrite);
  //ZipFile.ExtractAll(ExtractFileDir(SaveDialog1.FileName));
  //RenameFile(ExtractFileDir(SaveDialog1.FileName) + '\' + aFileName, SaveDialog1.FileName);

  //FreeAndNil(ZipFile);
  //DeleteFile(ExtractFileDir(SaveDialog1.FileName) + '\arq.zip');

  //ProgressBar1.Position := 3;
  //Descomprimir('arq.zip', ExtractFileDir(SaveDialog1.FileName) );

  // DEBUG => Para Testes.
  // ShowMessage(Url);

  SaveDialog1.FileName := fileName;
  Cursor := crHourGlass;
  try
    if SaveDialog1.Execute then
    begin
        try
          Thread := TMyThread.Create(Url, SaveDialog1.Filename);
          download := TDownload.Create(Url, SaveDialog1.Filename, Thread);

          Thread.OnPathResult := download.PathResult;
          Thread.OnStatus := download.ShowStatus;
          Thread.OnWorkBegin := download.UpdateProgressBegin;
          Thread.OnWork := download.UpdateProgress;
          Thread.OnWorkEnd := download.UpdateProgressEnd;

          FrmDownloadManager.Downloads.Add(download);

          Thread.Start;
        except on E: Exception do
          messageDlg('Não foi possível encontrar o relatório no servidor!', mtInformation, [mbOK],0);
        end;
    end;
  finally
    Cursor := crDefault;
  end;

  //ShowMessage('Arquivo baixado com sucesso...');
  //ProgressBar1.Visible := False;
  //Close;
  FrmDownloadManager.Show;
  FrmDownloadManager.RefreshList;
end;

procedure TFrmConsultaExportacoesRemoto.FormActivate(Sender: TObject);
begin
  LblNomeUsuario.Caption := FCodUsuario;

  BtnPesquisarClick(Self);
end;

procedure TFrmConsultaExportacoesRemoto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DSProcessadorTemplate.DataSet.Close;
end;

procedure TFrmConsultaExportacoesRemoto.FormCreate(Sender: TObject);
begin
  DateTimePickerIni.DateTime := Now;
  DateTimePickerFin.DateTime := Now;
  ArquivoINI := TIniFile.Create(GetCurrentDir + '/conf.ini');
  urldow := 'http://' + ArquivoINI.ReadString('configuracoes', 'server',    '') + ':' +
                     ArquivoINI.ReadString('configuracoes', 'port',      '');
end;

procedure TFrmConsultaExportacoesRemoto.SetParameters(codUsuario,
  urlBase: String);
begin
  FCodUsuario := codUsuario;
  FUrlBase := urlBase;
end;

{ TMyThread }


procedure TMyThread.CancelarDownload;
begin
  FHTTP.Disconnect;
end;

constructor TMyThread.Create(const AUrl, ALocalFile: string);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FUrl := AUrl;
  FLocalFile := ALocalFile;
  FStream := TFileStream.Create(ALocalFile, fmCreate);
end;

destructor TMyThread.Destroy;
begin
  FStream.Free;
  inherited;
end;

procedure TMyThread.Execute;
begin
  ShowStatus('Iniciando download...');

  FHTTP := TIdHTTP.Create(nil);
  try
    FHTTP.ReadTimeout := 30000;
    FHTTP.HandleRedirects := True;

    FdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(FHTTP);
    FdSSL.SSLOptions.Method := sslvTLSv1;
    FdSSL.SSLOptions.Mode := sslmClient;
    FHTTP.IOHandler := FdSSL;
    FHTTP.OnWorkBegin := FOnWorkBegin;
    FHTTP.OnWork := FOnWork;
    FHTTP.OnWorkEnd := FOnWorkEnd;

    ShowStatus('Download em andamento...');

    try
      FHTTP.Get(FUrl, FStream);
    except
      on E: EIdHTTPProtocolException do
      begin
        if E.ErrorCode = 404 then
          PathResult(False)
        else
          raise;
      end;
    end;
  finally
    FHttp.Free;
  end;

  PathResult(True);
end;

procedure TMyThread.PathResult(AResult: Boolean);
begin
  if Assigned(fOnPathResult) then
  begin
    TThread.Synchronize(Self,
      procedure
      begin
        if Assigned(fOnPathResult) then
          fOnPathResult(FLocalFile, AResult, FStream);
      end
    );
  end;
end;

procedure TMyThread.ShowStatus(const Str: string);
begin
 if Assigned(fOnStatus) then
  begin
    TThread.Synchronize(Self,
      procedure
      begin
        if Assigned(fOnStatus) then
          fOnStatus(FLocalFile, Str);
      end
    );
  end;
end;

end.
