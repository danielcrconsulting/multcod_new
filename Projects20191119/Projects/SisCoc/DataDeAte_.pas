unit DataDeAte_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TDataDeAte = class(TForm)
    Label3:  TLabel;
    Label1:  TLabel;
    Label2:  TLabel;
    Label4:  TLabel;
    Command1:  TButton;
    Text1:  TEdit;
    Command2:  TButton;
    Text2:  TEdit;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  DataDeAte: TDataDeAte;

implementation

uses  Dialogs, Module1, SysUtils;

{$R *.dfm}

 //=========================================================
procedure TDataDeAte.Command1Click(Sender: TObject);
begin
  gDataRelatorio := StrToDate(Text1.Text);
  gDataJuncaoAte := Text2.Text;
  if (Length(Text1.Text)<>8) then begin
    ShowMessage('Data De Inválida...');
    Exit;
  end;

  if  not isDataValida(Text1.Text) then begin
    ShowMessage('Data De Inválida...');
    Exit;
  end;

  if (Length(Text2.Text)<>8) then begin
    ShowMessage('Data De Inválida...');
    Exit;
  end;

  if  not isDataValida(Text2.Text) then begin
    ShowMessage('Data De Inválida...');
    Exit;
  end;

  if gDataRelatorio < StrToDate(gDataJuncaoAte) then begin
    ShowMessage('Data Até não pode ser menor que Data De...');
    Exit;
  end;

  if JuncaoDeJuntado(gDataRelatorio, gDataJuncaoAte) then begin
    ShowMessage('Erro na Junção de Juntado');
  end;

  Close();

end;

procedure TDataDeAte.Command2Click(Sender: TObject);
begin
  Self.Text1.Text := '';
  gDataRelatorio := StrToDate(Self.Text1.Text);
  Close();
end;

procedure TDataDeAte.FormShow(Sender: TObject);
begin
//  if IsDate(gDataRelatorio) then
  if gDataRelatorio <> 0 then
    Self.Text1.Text := FormatDateTime('dd/mm/yyyy', gDataRelatorio);

end;



end.
