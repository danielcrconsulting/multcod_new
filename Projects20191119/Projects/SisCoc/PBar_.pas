unit PBar_;

interface

uses  Forms, Classes, Controls, StdCtrls, ComCtrls;


type
  TPBar = class(TForm)
    Label1:  TLabel;
    ProgressBar1:  TProgressBar;

    procedure FormShow(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  PBar: TPBar;

implementation

uses Module1, frmMain_;

{$R *.dfm}

 //=========================================================
procedure TPBar.FormShow(Sender: TObject);
begin
  Self.Width := 4800;
  Self.Height := 2000;
  Self.Left := Round((fMainForm.Width-Self.Width)/2);
  Self.Top := Round(((fMainForm.Height-Self.Height)/2)-400);
end;


end.
