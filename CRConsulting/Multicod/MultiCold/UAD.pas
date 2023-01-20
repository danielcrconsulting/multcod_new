unit UAD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFAd = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edUsuario: TEdit;
    EdSenha: TEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    adusuario, adsenha : String;
    cancelou : Boolean;
  end;

var
  FAd: TFAd;

implementation

{$R *.dfm}

procedure TFAd.BitBtn1Click(Sender: TObject);
begin
  if Trim(edUsuario.Text) = '' then
  begin
    ShowMessage('Usuário inválido !');
    exit;
  end;
  if Trim(EdSenha.Text) = '' then
  begin
    ShowMessage('Senha inválido !');
    exit;
  end;
  adusuario := edUsuario.Text;
  adsenha := EdSenha.Text;
  cancelou := False;
  Close;
end;

procedure TFAd.BitBtn2Click(Sender: TObject);
begin
  edUsuario.Text := '';
  EdSenha.Text := '';
  cancelou := True;
  Close;
end;

procedure TFAd.FormShow(Sender: TObject);
var
  I: DWord;
  user: string;
begin
  I := 255;
  SetLength(user, I);
  GetUserName(PChar(user), I);
  user := string(PChar(user));
  edUsuario.Text := user;
end;

end.
