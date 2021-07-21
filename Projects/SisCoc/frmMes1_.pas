unit frmMes1_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TfrmMes1 = class(TForm)
    Label1:  TLabel;
    Label3:  TLabel;
    Command2:  TButton;
    Text1:  TEdit;
    Command1:  TButton;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmMes1: TfrmMes1;

implementation

uses Module1;

{$R *.dfm}

 //=========================================================
procedure TfrmMes1.Command1Click(Sender: TObject);
begin
  gData1 := Text1.Text;
  Close();
end;
procedure TfrmMes1.Command2Click(Sender: TObject);
begin
  Close();
end;



end.
