unit frmLogin_;

interface

uses  Forms, Classes, Controls, StdCtrls, AdoDB, Data.DB;


type
  TfrmLogin = class(TForm)
    lblLabels_0:  TLabel;
    lblLabels_1:  TLabel;
    txtUserName:  TEdit;
    txtPassword:  TEdit;
    cmdOK:  TButton;
    cmdCancel:  TButton;
    ADOConnection1: TADOConnection;
    RsDb: TADODataSet;

    procedure FormShow(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure txtUserNameEnter(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

    OK: Boolean;
//    lblLabels:  array[0..1] of TLabel;  // Control array

  end;

var
  frmLogin: TfrmLogin;

implementation

uses  Dialogs, Windows, SysUtils, StrUtils, Module1, TelaInicial_, RotGerais, Subrug, Consulta_;

{$R *.dfm}

 //=========================================================
procedure TfrmLogin.FormShow(Sender: TObject);
begin
  TelaInicial.Command1.Visible := false;
  txtUserName.Text := GetCurrentUserName;
  gOperador := GetCurrentUserName;
end;

procedure TfrmLogin.cmdCancelClick(Sender: TObject);
begin
  OK := false;
  Self.Hide;
  Application.Terminate;
  Close;
end;

procedure TfrmLogin.cmdOKClick(Sender: TObject);
var
  sSql : String;
begin

  // Verifica usuário e senha
if  Conecta(AdoConnection1, ExtractFileDir(Application.ExeName) + '\admin.udl') then
  begin

  sSql := 'Select * from [Usuarios]';
  sSql := sSql+' where Id_Usuario = '#39 + txtUserName.Text + #39;
  sSql := sSql+' and Senha = '#39 + txtPassword.Text + #39;
  RsDb.CommandText := sSql;
  RsDb.Open;

  OK := false;
  while not RsDb.EOF and (OK=false) do
    begin
    if (RsDb.FieldByName('Id_Usuario').AsString = txtUserName.Text) and
       (RsDb.FieldByName('Senha').AsString = txtPassword.Text) then
      begin
      gNivel := RsDb.FieldByName('cd_grupo_usu').Value;
      gNomeUsuario := RsDb.FieldByName('Nome_Usuario').Value;
      gOperador := txtUserName.Text;
      OK := true;
      end;
    RsDb.Next;
    end;

  if OK then
    begin
    Self.Hide;
    if txtPassword.Text='usuario' then
      begin
//      frmAltUsuario.Text1.Text := txtUserName.Text;
//      SendKeys(9);
//      gArquivo11 := 'usuario';
//      frmAltUsuario.ShowModal;
//      txtPassword.Text := '';

      Consulta.Caption := 'Altere sua senha...';
      Consulta.sSqlConsulta := 'select Id_usuario, Nome_usuario, cd_grupo_usu, senha from usuarios' +
                               ' where Id_Usuario = '#39 + txtUserName.Text + #39;
      gOpcao := 'adm';
      Consulta.ShowModal;

      Close;
      Exit;

      end;

    if txtPassword.Text='usuario' then
      begin
      ShowMessage('Você tem que alterar sua senha..');
      OK := false;
      Exit;
      end;
    end
  else
    // Verifica senha Master
    if (AnsiUpperCase(txtPassword.Text)='MULTICOLD') and (AnsiUpperCase(txtUserName.Text)='CONCILIACAO') then
      begin
      Self.Hide;
      gOperador := 'Conciliacao';
      gNivel := cADM;
      OK := true;
      end
    else
      begin
      Application.MessageBox('Usuário ou Senha Inválida!', 'Login', MB_OK);
      txtPassword.SetFocus;
      txtPassword.SelStart := 0;
      txtPassword.SelLength := Length(txtPassword.Text);
      end;

  RsDb.Close;
  AdoConnection1.Close;
  Close;
  End;
end;

procedure TfrmLogin.txtUserNameEnter(Sender: TObject);
begin
  if Length(Self.txtUserName.Text)>0 then
    begin
    Self.txtUserName.SelStart := 0;
    Self.txtUserName.SelLength := Length(Self.txtUserName.Text);
    end;
end;

end.
