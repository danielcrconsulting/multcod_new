unit UFrmDownloadManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections, IdComponent, UFrmConsultaExportacoesRemoto;

type

  TDownload = class (TObject)
  strict private
    FUrl: String;
    FPath: String;  private
    FThread: TMyThread;
    FCancelou: Boolean;
  private
    FMaxValue,
    FCurrentValue: Int64;
  public
    property Url: String read FUrl;
    property Path: String read FPath;

    procedure CancelarDownload;

    Constructor Create(AUrl, APath: String; AThread: TMyThread); overload;
    Destructor Destroy; override;

    procedure ShowStatus(const APath, AStr: String);
    procedure PathResult(const APath: String; AResult: Boolean; AStream: TStream);

    procedure UpdateProgressBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure UpdateProgress(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure UpdateProgressEnd(ASender: TObject; AWorkMode: TWorkMode);
  end;

  TFrmDownloadManager = class(TForm)
    LbDownloads: TListBox;
    Panel1: TPanel;
    Btnfechar: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    MemoPath: TMemo;
    PanelDownload: TPanel;
    BtnCancelar: TButton;
    ProgressBarDownload: TProgressBar;
    Label3: TLabel;
    procedure BtnfecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LbDownloadsClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
  private
    FCurrentDownload: TDownload;
    FDownloads: TList<TDownload>;
    procedure CancelAll;
    { Private declarations }
  public
    procedure UpdateProgress;
    procedure RefreshList;
    property Downloads: TList<TDownload> read FDownloads write FDownloads;
  end;


var
  FrmDownloadManager: TFrmDownloadManager;

implementation

{$R *.dfm}

procedure TFrmDownloadManager.BtnCancelarClick(Sender: TObject);
begin
  if FCurrentDownload <> nil then
  begin
    FCurrentDownload.CancelarDownload;
  end;
end;

procedure TFrmDownloadManager.BtnfecharClick(Sender: TObject);
begin
  Close;
end;


procedure TFrmDownloadManager.CancelAll;
var
  I: Integer;
begin
  for I := 0 to FDownloads.Count-1 do
  begin
    FDownloads[i].CancelarDownload;
  end;
end;

procedure TDownload.CancelarDownload;
begin
  FCancelou := true;
  FThread.CancelarDownload;
end;

constructor TDownload.Create(AUrl, APath: String; AThread: TMyThread);
begin
  FCancelou := false;
  FUrl := AUrl;
  FPath := APath;
  FThread := AThread;
end;

destructor TDownload.Destroy;
begin
  FrmDownloadManager.Downloads.Remove(Self);
  FrmDownloadManager.RefreshList;
  inherited;
end;

procedure TDownload.PathResult(const APath: String; AResult: Boolean;
  AStream: TStream);
var
  idx: Integer;
begin
  FrmDownloadManager.Show;
  idx := FrmDownloadManager.Downloads.IndexOf(Self);
  FrmDownloadManager.LbDownloads.ItemIndex := idx;

  if not FCancelou then
  begin
    if AResult then
    begin
       MessageDlg('Download concluído com sucesso!', mtInformation, [mbOK], 0);
    end else
    begin
       MessageDlg('Arquivo não encontrado para donwload!', mtError, [mbOK], 0);
    end;
  end;

  Self.Free;
end;


procedure TDownload.ShowStatus(const APath, AStr: String);
begin
  Application.ProcessMessages;
end;

procedure TDownload.UpdateProgress(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  FCurrentValue := AWorkCount;

  FrmDownloadManager.UpdateProgress;
end;

procedure TDownload.UpdateProgressBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  FMaxValue := AWorkCountMax;
  FCurrentValue := 0;

  FrmDownloadManager.UpdateProgress;
end;

procedure TDownload.UpdateProgressEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  FCurrentValue := FMaxValue;

  FrmDownloadManager.UpdateProgress;
end;

procedure TFrmDownloadManager.FormCreate(Sender: TObject);
begin
  FDownloads := TList<TDownload>.Create;
end;

procedure TFrmDownloadManager.FormDestroy(Sender: TObject);
begin
  CancelAll;
  FreeAndNil(FDownloads);
end;

procedure TFrmDownloadManager.FormShow(Sender: TObject);
begin
  RefreshList;
end;

procedure TFrmDownloadManager.LbDownloadsClick(Sender: TObject);
begin
  if LbDownloads.Items[LbDownloads.ItemIndex]<> MemoPath.Text then
  begin
    MemoPath.Text := LbDownloads.Items[LbDownloads.ItemIndex];
    FCurrentDownload := Downloads[LbDownloads.ItemIndex];
  end;
end;

procedure TFrmDownloadManager.RefreshList;
var
  I: Integer;
begin
  LbDownloads.Clear;

  for I := 0 to Downloads.Count-1 do
  begin
    LbDownloads.AddItem(Downloads[i].Path, Downloads[i]);
  end;

  if LbDownloads.Count = 0 then
  begin
    FCurrentDownload := nil;
    MemoPath.Clear;
    ProgressBarDownload.Min := 0;
    PanelDownload.Visible := false;
  end
  else
  begin
    PanelDownload.Visible := true;
    LbDownloads.ItemIndex := 0;
    LbDownloadsClick(nil);
    ProgressBarDownload.Position := 0;
  end;
end;

procedure TFrmDownloadManager.UpdateProgress;
begin
  if FCurrentDownload <> nil then
  begin
    ProgressBarDownload.Max := FCurrentDownload.FMaxValue;
    ProgressBarDownload.Position := FCurrentDownload.FCurrentValue;

    Application.ProcessMessages;
  end;
end;

end.
