unit DataLimite_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows;


type
  TDataLimite = class(TForm)
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
  DataLimite: TDataLimite;

implementation

uses  SysUtils, Module1, RotGerais, VBto_Converter;

{$R *.dfm}

 //=========================================================
procedure TDataLimite.Command1Click(Sender: TObject);
begin
  if  not (isDataValida(Text1.Text)) then begin
    Application.MessageBox('Data inválida. Redigite...', PCHAR(Self.Caption), MB_ICONSTOP);
    Exit;
  end;
//  if CDate(Text1.Text)>Now() then begin
//    Application.MessageBox('Data inválida. Redigite...', PCHAR(Self.Caption), MB_ICONSTOP);
//    Exit;
//  end;
  gData1 := Text1.Text;                // Rever
  Close;
end;

procedure TDataLimite.Command2Click(Sender: TObject);
begin
  Close;
end;

procedure TDataLimite.FormShow(Sender: TObject);
Var
  xData : TDateTime;
begin
  CenterForm(Self);
  if TryStrToDate(gData2, xData) then
    Text1.Text := FormatVB(gData2,'DD/MM/YYYY')
  else
    Text1.Text := FormatVB(GetDay(Now()),'00')+'/'+FormatVB(GetMonth(Now()),'00')+'/'+FormatVB(GetYear(Now()),'0000');

  Text1.SelStart := 0;
  Text1.SelLength := Length(Text1.Text);
end;


end.
