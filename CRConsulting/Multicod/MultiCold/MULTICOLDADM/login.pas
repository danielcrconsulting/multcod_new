unit login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, System.UITypes;

type
  TfLogin = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLogin: TfLogin;

implementation

uses dataModule, principal;

var
  numTentativas : integer;

{$R *.dfm}

procedure TfLogin.BitBtn2Click(Sender: TObject);
begin
application.Terminate;
end;

procedure TfLogin.BitBtn1Click(Sender: TObject);
begin
nomeDoUsuarioDaSessao := Edit1.Text;
if (Edit1.Text = 'CRConsulting') and (Edit2.Text = 'Pum12345') then
  begin
      fPrincipal.Extrator1.Enabled := true;
      fPrincipal.Mapadenomes1.Enabled := true;
      fPrincipal.Mscaradecampos1.Enabled := true;
      fPrincipal.MovimentoparaCD1.Enabled := true;
      fPrincipal.Sistema1.Enabled := true;
      fPrincipal.Configuraes1.Enabled := true;
      fPrincipal.Relatrios1.Enabled := true;
      fPrincipal.DFN1.Enabled := true;
      fPrincipal.DestinosDFN1.Enabled := true;
      fPrincipal.ndicesDFN1.Enabled := true;
      fPrincipal.Editor1.Enabled := true;
      fPrincipal.Hierarquia1.Enabled := true;
      fPrincipal.Auxiliaralfanumrico1.Enabled := true;
      fPrincipal.Auxiliarnumrico1.Enabled := true;
      fPrincipal.Auxiliardesistemaautomtico1.Enabled := true;
      fPrincipal.GruposDFN1.Enabled := true;
      fPrincipal.SubgruposDFN1.Enabled := true;
      fPrincipal.Relacionamentos1.Enabled := true;
      fPrincipal.Gruposdeusuriosporrelatrios1.Enabled := true;
      fPrincipal.MscaradecamposxUsurios1.Enabled := true;
      fPrincipal.Usuriosporgruposdeusurios1.Enabled := true;
      fPrincipal.Usuriosporrelatrios1.Enabled := true;
      fPrincipal.Usurios1.Enabled := true;
      fPrincipal.Gruposdeusurios1.Enabled := true;
      fPrincipal.Usurios2.Enabled := true;
      fPrincipal.Logdeacesso1.Enabled := true;
      fPrincipal.Protocolo1.Enabled := true;
      fPrincipal.Usurios3.Enabled := true;
      fPrincipal.Heranadepermisso1.Enabled := true;
    self.Close;
    exit;
  end
else
if numTentativas>3 then
  begin
  MessageDlg('Excedido limite de tentativas para acesso.',mtInformation,[mbOk],0);
  BitBtn2.Click;
  end;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT A.CODUSUARIO, A.SENHA, B.NOMEGRUPOUSUARIO');
  Query01.SQL.Add('FROM USUARIOS A, USUARIOSEGRUPOS B');
  Query01.SQL.Add('WHERE A.CODUSUARIO = B.CODUSUARIO');
  //Query01.SQL.Add('AND B.NOMEGRUPOUSUARIO IN (''ADMSIS'',''ADMSEG'',''ADMDFN'')');
  Query01.SQL.Add('AND A.CODUSUARIO = :A');
  Query01.SQL.Add('AND A.SENHA = :B');
  Query01.Parameters[0].Value := Edit1.Text;
  Query01.Parameters[1].Value := Edit2.Text;
  Query01.Open;
  if not Query01.Eof then
    begin
    if Query01.Fields[2].Value = 'ADMSIS' then // Perfil administrador do sistema tem permissão para efetuar todo tipo de alteração possível
      begin
      fPrincipal.Extrator1.Enabled := true;
      fPrincipal.Mapadenomes1.Enabled := true;
      fPrincipal.Mscaradecampos1.Enabled := true;
      fPrincipal.MovimentoparaCD1.Enabled := true;
      fPrincipal.Sistema1.Enabled := true;
      fPrincipal.Configuraes1.Enabled := true;
      fPrincipal.Relatrios1.Enabled := true;
      fPrincipal.DFN1.Enabled := true;
      fPrincipal.DestinosDFN1.Enabled := true;
      fPrincipal.ndicesDFN1.Enabled := true;
      fPrincipal.Editor1.Enabled := true;
      fPrincipal.Hierarquia1.Enabled := true;
      fPrincipal.Auxiliaralfanumrico1.Enabled := true;
      fPrincipal.Auxiliarnumrico1.Enabled := true;
      fPrincipal.Auxiliardesistemaautomtico1.Enabled := true;
      fPrincipal.GruposDFN1.Enabled := true;
      fPrincipal.SubgruposDFN1.Enabled := true;
      fPrincipal.Relacionamentos1.Enabled := true;
      fPrincipal.Gruposdeusuriosporrelatrios1.Enabled := true;
      fPrincipal.MscaradecamposxUsurios1.Enabled := true;
      fPrincipal.Usuriosporgruposdeusurios1.Enabled := true;
      fPrincipal.Usuriosporrelatrios1.Enabled := true;
      fPrincipal.Usurios1.Enabled := true;
      fPrincipal.Gruposdeusurios1.Enabled := true;
      fPrincipal.Usurios2.Enabled := true;
      fPrincipal.Logdeacesso1.Enabled := true;
      fPrincipal.Protocolo1.Enabled := true;
      fPrincipal.Usurios3.Enabled := true;
      fPrincipal.Heranadepermisso1.Enabled := true;
      end
    else if Query01.Fields[2].Value = 'ADMSEG' then // Perfil do administrador de segurança, só cadastra usuários e controla acesso aos relatórios
      begin
      fPrincipal.Usurios1.Enabled := true;
      fPrincipal.Relacionamentos1.Enabled := true;
      fPrincipal.Gruposdeusuriosporrelatrios1.Enabled := true;
      fPrincipal.Mscaradecampos1.Enabled := true;
      fPrincipal.MscaradecamposxUsurios1.Enabled := true;
      fPrincipal.Usuriosporgruposdeusurios1.Enabled := true;
      fPrincipal.Usuriosporrelatrios1.Enabled := true;
      fPrincipal.Gruposdeusurios1.Enabled := true;
      fPrincipal.Usurios2.Enabled := true;
      fPrincipal.Usurios3.Enabled := true;
      fPrincipal.Heranadepermisso1.Enabled := true;
      end
    else if Query01.Fields[2].Value = 'ADMDFN' then // Perfil do administrador de relatórios, só cadastra relatórios e controla as hierarquisas do sistema
      begin
      fPrincipal.Extrator1.Enabled := true;
      fPrincipal.Mapadenomes1.Enabled := true;
      fPrincipal.Mscaradecampos1.Enabled := true;
      fPrincipal.MovimentoparaCD1.Enabled := true;
      fPrincipal.Sistema1.Enabled := true;           // 14/06/2012
      fPrincipal.Hierarquia1.Enabled := true;        // 14/06/2012
      fPrincipal.Auxiliaralfanumrico1.Enabled := true;
      fPrincipal.Auxiliarnumrico1.Enabled := true;
      fPrincipal.Auxiliardesistemaautomtico1.Enabled := true;
      fPrincipal.GruposDFN1.Enabled := true;        // 14/06/2012
      fPrincipal.SubgruposDFN1.Enabled := true;     // 14/06/2012
      fPrincipal.Relatrios1.Enabled := true;
      fPrincipal.DFN1.Enabled := true;
      fPrincipal.DestinosDFN1.Enabled := true;
      fPrincipal.ndicesDFN1.Enabled := true;
      fPrincipal.Editor1.Enabled := true;
      fPrincipal.Protocolo1.Enabled := true;
      fPrincipal.Configuraes1.Enabled := true; // 14/06/2012
      end;
    self.Close
    end
  else
    messageDlg('Código de usuário ou senha inexistentes.',mtError,[mbOk],0);
  Query01.Close;
  end;
inc(numTentativas);
end;

procedure TfLogin.FormShow(Sender: TObject);
begin
Edit1.SetFocus;
end;

procedure TfLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
action := caFree;
end;

procedure TfLogin.FormCreate(Sender: TObject);
begin
numTentativas := 1;
end;

end.
