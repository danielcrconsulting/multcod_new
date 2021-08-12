unit TelaInicial_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TTelaInicial = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Command1:  TButton;

    procedure Command1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  TelaInicial: TTelaInicial;

implementation

uses Module1, frmLogin_, Dialogs, frmMain_;

{$R *.dfm}

 //=========================================================
procedure TTelaInicial.Command1Click(Sender: TObject);
begin
  frmLogin.ShowModal;
  if not frmLogin.OK then
    begin
    ShowMessage('Usuário não autorizado!');
    Application.Terminate;
    Close;
    end
  else
    begin
    fMainForm.MontaMenus;
//    Hide;
//    fMainForm.Show;
    fMainForm.MontaBinGeral;
    Hide;
//    fMainForm.Close;
    fMainForm.ShowModal;
    end;
end;

procedure TTelaInicial.FormResize(Sender: TObject);
begin
  Label1.Left := Round((Width-Self.Label1.Width)/2);
  Label2.Left := Round((Width-Self.Label2.Width)/2);
  Label3.Left := Round((Width-Self.Label3.Width)/2);
  Command1.Left := Round((Width-Self.Command1.Width)/2);
end;


end.
