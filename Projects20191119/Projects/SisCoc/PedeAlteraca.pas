unit PedeAlteraca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Module1;

type
  TPedeAlteracao = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PedeAlteracao: TPedeAlteracao;

implementation

{$R *.dfm}

procedure TPedeAlteracao.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TPedeAlteracao.Button2Click(Sender: TObject);
begin
gOpcao := Self.Edit1.Text;
Close;
end;

end.
