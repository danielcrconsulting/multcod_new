unit frmRelease_;

interface

uses  Forms, Classes, Controls, StdCtrls, Vcl.ExtCtrls;


type
  TfrmRelease = class(TForm)
    cmdOk:  TButton;
    Check1:  TCheckBox;
    RichTextBox1: TMemo;

    procedure cmdOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);

  private
    { Private declarations }

    //procedure cmdImprime_Click();

  public
    { Public declarations }
  end;

var
  frmRelease: TfrmRelease;

implementation

uses  SysUtils, RotGerais, VBto_Converter, FileHandles;

{$R *.dfm}

 //=========================================================
//{$DEFINE defUse_cmdImprime_Click}
{$IF Defined(defUse_cmdImprime_Click)}
procedure TfrmRelease.cmdImprime_Click();
begin
 //empty ;-)
end;
{$IFEND} // defUse_cmdImprime_Click

procedure TfrmRelease.cmdOkClick(Sender: TObject);
Var
  Caminho : String;
  Arq : File;
begin
  if Self.Check1.State=cbChecked then
    begin
    Caminho := ExtractFileDir(Application.ExeName);
    if FileExists(Caminho+'\release.txt') then
      begin
      AssignFile(Arq, Caminho+'\release.txt');
      Rename(Arq, Caminho+'\release.ttt');
      end;
    end;
  Close;
end;

procedure TfrmRelease.FormShow(Sender: TObject);
var
  Arq: System.Text;
  NomeArq, Buffer: String;
begin
  CenterForm(Self);
  NomeArq := '';
  if FileExists(ExtractFileDir(Application.ExeName)+'\release.txt') then
    NomeArq := ExtractFileDir(Application.ExeName)+'\release.txt';

  if FileExists(ExtractFileDir(Application.ExeName)+'\release.ttt') then
    NomeArq := ExtractFileDir(Application.ExeName)+'\release.ttt';

  if Length(NomeArq)=0 then
    begin
    Self.RichTextBox1.Text := String(Self.RichTextBox1.Text)+'Notas de Liberação não disponível';
    Exit;
    end
  else
    begin
    AssignFile(Arq, NomeArq);
    Reset(Arq);
    while  not Eof(Arq) do
      begin
      ReadLn(Arq, Buffer);
      Self.RichTextBox1.Text := String(Self.RichTextBox1.Text)+Buffer+#13#10;
      end;
    CloseFile(Arq);
    end;
end;

procedure TfrmRelease.FormResize(Sender: TObject);
begin
  Self.RichTextBox1.Width := Self.Width-630;
  Self.RichTextBox1.Height := Self.Height-1400;

  Self.cmdOk.Top := Self.Height-990;
  Self.cmdOk.Left := Self.Width-1425;

  Self.Check1.Top := Self.Height-930;
  Self.Check1.Left := Self.Width-5245;

end;


end.
