unit Periodo_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows;


type
  TPeriodo = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Text1:  TEdit;
    Text2:  TEdit;
    Command1:  TButton;
    Command2:  TButton;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Periodo: TPeriodo;

implementation

uses Module1, SysUtils, FMX.Dialogs;

{$R *.dfm}

 //=========================================================
procedure TPeriodo.Command1Click(Sender: TObject);
Var
  xData1,
  xData2 : TDatetime;
begin
  If not TryStrToDate(Text1.Text, xData1) Then
    begin
      ShowMessage('Data Inválida: '+Text1.Text);
      Exit;
    end;
  If not TryStrToDate(Text2.Text, xData2) Then
    begin
      ShowMessage('Data Inválida: '+Text2.Text);
      Exit;
    end;
  if  not (isDataValida(Text1.Text) and isDataValida(Text2.Text) and (xData2 <= xData1)) then
    begin
    Application.MessageBox('Datas inválidas. Redigite...', 'Seleção de Período', MB_ICONSTOP);
    Exit;
    end;
  gData1 := Text1.Text;     // Rever
  gData2 := Text2.Text;
  Close;
end;

procedure TPeriodo.Command2Click(Sender: TObject);
begin
  Close;
end;

end.
