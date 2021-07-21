unit frmAgenda_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls;


type
  TfrmAgenda = class(TForm)
    Label4:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Label1:  TLabel;
    Line1:  TShape;
    Text2:  TEdit;
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
  frmAgenda: TfrmAgenda;

implementation

uses  Dialogs, Module1, RotGerais, SysUtils;

{$R *.dfm}

 //=========================================================
procedure TfrmAgenda.Command1Click(Sender: TObject);
Var
  xData1,
  xData2 : TDateTime;
begin
  if not TryStrToDateTime(Text1.Text, xData1) then
    begin
    ShowMessage('Data Inválida');
    Text1.SetFocus;
    Exit;
    end;
  if not TryStrToDateTime(Text2.Text, xData2) then
    begin
    ShowMessage('Data Inválida');
    Text2.SetFocus;
    Exit;
    end;

  if (xData1 <= xData2) then
    begin
    ShowMessage('Data de Agendamento menor que data a ser Agendada');
    Text1.SetFocus;
    Exit;
    end;

  gData1 := Text1.Text;
  gData2 := Text2.Text;

  Close;
end;
procedure TfrmAgenda.Command2Click(Sender: TObject);
begin
  Text1.Text := '';
  Text2.Text := '';
  Close();
end;

procedure TfrmAgenda.FormShow(Sender: TObject);
begin
  CenterForm(Self);
end;


end.
