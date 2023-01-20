unit FormUnit1;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, inifiles, adshlp, ActiveDs_TLB,
  Winapi.ActiveX, System.Win.ComObj, Vcl.ExtCtrls, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI;

type
  TForm1 = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    Button1: TButton;
    FDQuery1: TFDQuery;
    Label2: TLabel;
    Timer1: TTimer;
    fdcon: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
    function ValidarADNew(pUsuario, pSenha: String): String;
    procedure LimpaMemoria;
    procedure ConectarBanco(bd : integer = 0);
    function RetornarParametrosConn(var servidor : String; var driverservidor: String;
                                                var porta : String ; var banco : String;
                                                var usuario : String ; var senha : String;
                                                var NomeEstacao : String ) : Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession;


procedure TForm1.LimpaMemoria;
var
   MainHandle : THandle;
begin
 try
   MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
   SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
   CloseHandle(MainHandle);
 except
 end;
end;

function TForm1.RetornarParametrosConn(var servidor : String; var driverservidor: String;
                                                var porta : String ; var banco : String;
                                                var usuario : String ; var senha : String;
                                                var NomeEstacao : String ) : Boolean;
var arqIni : TiniFile;
begin
  arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
  servidor       := arqIni.ReadString('configuracoes', 'servidor',    '');
  driverservidor := arqIni.ReadString('configuracoes', 'driver',      '');
  porta          := arqIni.ReadString('configuracoes', 'port',        '');
  banco          := arqIni.ReadString('configuracoes', 'database',    '');
  usuario        := arqIni.ReadString('configuracoes', 'user',        '');
  senha          := arqIni.ReadString('configuracoes', 'password',    '');
  NomeEstacao    := arqIni.ReadString('configuracoes', 'WorkStation', '');
  result := True;
end;

function TForm1.ValidarADNew(pUsuario, pSenha: String): String;
var
  adObject: IADs;
  host : String;
  retorno : Boolean;
  aut : Integer;

  function RetornarParametroAD : String;
  var arqIni : TiniFile;
      host : String;
  begin
    arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
    host           := arqIni.ReadString('AD', 'host',    '');

    result := host;
  end;
begin
  host := RetornarParametroAD;
  Result := '0';
  CoInitialize(nil);
  try

    aut :=  ADsOpenObject('LDAP://' + host ,
                  LowerCase(pUsuario),
                  pSenha,
                  ADS_SECURE_AUTHENTICATION,
                  IADs,
                  adObject);
    result := '1';
  except
    //on e:exception do
    begin
      //Showmessage('erro ' + e.Message);
      result := '0';
    end;
  end;
  CoUninitialize;
  adObject:= nil;
end;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  //EditPort.Enabled := not FServer.Active;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
FDQuery1.Close;
  FDQuery1.Sql.Clear;
  FDQuery1.Sql.Add('INSERT INTO EVENTOS_VISU (DT, HR, ARQUIVO, DIRETORIO, CODREL, GRUPO, SUBGRUPO, CODUSUARIO, NOMEGRUPOUSUARIO, CODMENSAGEM) ');
  FDQuery1.SQL.Add('VALUES (:a, :b, :c, :d, :e, :f, :g, :h, :i, :j)');
  FDQuery1.Params.Items[0].Value := 1;
  FDQuery1.Params.Items[1].Value := 2;
  FDQuery1.Params.Items[2].Value := 3;
end;

procedure TForm1.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TForm1.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
var arqIni : TiniFile;
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  arqIni         := TIniFile.Create(GetCurrentDir+'/confserver.ini');
  EditPort.Text  := arqIni.ReadString('configuracoes', 'port',        '');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ButtonStart.Click;
end;

procedure TForm1.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  fdQry, fdQry_up : TFDQuery;
  function RetornarParametroAD : String;
  var arqIni : TiniFile;
      host : String;
  begin
    arqIni         := TIniFile.Create(GetCurrentDir+'/conf.ini');
    host           := arqIni.ReadString('AD', 'host',    '');
    result := host;
  end;

begin
  try
    fdQry    := TFDQuery.Create(nil);
    fdQry_up := TFDQuery.Create(nil);
    try
      fdQry    := TFDQuery.Create(nil);
      fdQry_up := TFDQuery.Create(nil);
      ConectarBanco(0);
      fdQry.Connection    := fdcon;
      fdQry_up.Connection := fdcon;
      fdQry.SQL.Text := ' select * from autenticacao_ad where aut = 0 and dominio = ' + QuotedStr(RetornarParametroAD);
      fdqry.Open;
      while not fdQry.eof do
      begin
        if ValidarADNew( fdQry.FieldByName('usuario').AsString , fdQry.FieldByName('SENHA').AsString) = '1' then
        begin
          fdQry_up.SQL.Text := 'update autenticacao_ad set aut = 1 ' +
                               'where dominio = ' + QuotedStr(RetornarParametroAD) + ' and ' +
                               'usuario = ' + QuotedStr(fdQry.FieldByName('usuario').AsString);
          fdQry_up.ExecSQL;
        end;
       fdQry.Next;
      end;
      except
        //on e:exception do
      begin
        //Showmessage('erro ' + e.Message);
      end;

    end;



  finally
    begin
      fdcon.Close;
      FreeAndNil(fdQry);
      FreeAndNil(fdQry_up);
      LimpaMemoria;
    end;
  end;
  
end;


procedure TForm1.ConectarBanco(bd : integer = 0);
var
  servidor, driverservidor, porta, banco, usuario,
  senha, NomeEstacao : String;
begin
  RetornarParametrosConn(servidor, driverservidor, porta, banco, usuario, senha, NomeEstacao);
  {
  FdCon.ConnectionString := 'Provider='+DriverServidor+';'+
                                          'Persist Security Info=True;'+
                                          'User ID='+usuario+';'+
                                          'Password='+senha+';'+
                                          'Initial Catalog='+banco+';'+
                                          'Data Source='+servidor+';'+
                                          'Auto Translate=True;'+
                                          'Packet Size=4096;'+
                                          'Workstation ID='+NomeEstacao+';'+
                                          'Network Library=DBMSSOCN'+';'+
                                          'DriverID=MSSQL';
  }
  FdCon.Params.Clear;
  FdCon.Params.Values['DriverID']  := 'MSSQL';
  FdCon.Params.Values['Server'] := servidor;
  if bd = 0 then
    FdCon.Params.Values['Database'] := banco
  else if bd = 1 then
     FdCon.Params.Values['Database'] := banco + '_log'
  else
     FdCon.Params.Values['Database'] := banco + '_evento';
  FdCon.Params.Values['User_name'] := usuario;
  FdCon.Params.Values['Password'] := senha;
  FdCon.Open;
end;

end.
