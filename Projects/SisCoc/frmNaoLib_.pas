unit frmNaoLib_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TfrmNaoLib = class(TForm)
    Label1:  TLabel;
    Command1:  TButton;

    procedure Command1Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmNaoLib: TfrmNaoLib;

implementation

{$R *.dfm}

 //=========================================================
procedure TfrmNaoLib.Command1Click(Sender: TObject);
begin
  Close();
end;


end.
