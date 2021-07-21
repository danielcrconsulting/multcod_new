unit DataMov_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TDataMov = class(TForm)
    Label3:  TLabel;
    Label1:  TLabel;
    Command1:  TButton;
    Text1:  TEdit;
    Command2:  TButton;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  DataMov: TDataMov;

implementation

uses  Dialogs, Module1, SysUtils;

{$R *.dfm}

 //=========================================================
procedure TDataMov.Command1Click(Sender: TObject);
begin
  gDataRelatorio := StrToDate(Text1.Text);
  if (Length(Text1.Text)<>8) then begin
    ShowMessage('Data Inválida...');
    Exit;
  end;

  if  not isDataValida(Text1.Text) then begin
    ShowMessage('Data Inválida...');
    Exit;
  end;
  Close();

end;
procedure TDataMov.Command2Click(Sender: TObject);
begin
  Self.Text1.Text := '';
  gDataRelatorio := StrToDate(Self.Text1.Text);
  Close;
end;

procedure TDataMov.FormShow(Sender: TObject);
begin
  Self.Text1.Text := DateToStr(gDataRelatorio);
end;


end.
