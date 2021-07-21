unit frmMes_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TfrmMes = class(TForm)
    Label1:  TLabel;
    Label3:  TLabel;
    Label2:  TLabel;
    Label4:  TLabel;
    Command2:  TButton;
    Text1:  TEdit;
    Command1:  TButton;
    Text2:  TEdit;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmMes: TfrmMes;

implementation

uses Module1;

{$R *.dfm}

 //=========================================================
procedure TfrmMes.Command1Click(Sender: TObject);
begin
  gData1 := Text1.Text;
  gData2 := Text2.Text;
  Close();
end;
procedure TfrmMes.Command2Click(Sender: TObject);
begin
  Text1.Text := '';
  Text2.Text := '';
  Close();
end;


end.
