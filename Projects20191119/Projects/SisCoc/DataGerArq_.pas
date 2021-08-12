unit DataGerArq_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TDataGerArq = class(TForm)
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
  DataGerArq: TDataGerArq;

implementation

uses  Dialogs, Module1, SysUtils;

{$R *.dfm}

 //=========================================================
procedure TDataGerArq.Command1Click(Sender: TObject);
begin
  gDataRelatorio := StrToDate(Text1.Text);
  if (Length(Text1.Text)<>8) then begin
    ShowMessage('Data do Movimento Inválida...');
    Exit;
  end;

  if  not isDataValida(Text1.Text) then begin
    ShowMessage('Data do Movimento Inválida...');
    Exit;
  end;

  gDataGeracaoArquivo := Text2.Text;
  if (Length(Text1.Text)<>8) then begin
    ShowMessage('Data da Geração do Arquivo Inválida...');
    Exit;
  end;

  if  not isDataValida(Text2.Text) then begin
    ShowMessage('Data da Geração do Arquivo Inválida...');
    Exit;
  end;
  Close();

end;
procedure TDataGerArq.Command2Click(Sender: TObject);
begin
  Self.Text1.Text := '';
  gDataRelatorio := StrToDate(Self.Text1.Text);
  Close();
end;
procedure TDataGerArq.FormShow(Sender: TObject);
begin
  if gTESTE then begin
    Self.Text1.Text := '09/09/08';
    Self.Text2.Text := '10/09/08';
  end;
//  if IsDate(gDataRelatorio) then
  if gDataRelatorio <> 0 then
    Self.Text1.Text := FOrmatDateTime('dd/mm/yyyy', gDataRelatorio);
end;

end.
