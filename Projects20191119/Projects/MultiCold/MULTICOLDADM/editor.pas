unit editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, RichEdit, ExtCtrls, Menus, System.UITypes;

type
  TfEditor = class(TForm)
    StatusBar1: TStatusBar;
    RichEdit1: TRichEdit;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Abrir1: TMenuItem;
    Sair1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure RichEdit1SelectionChange(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateCursorPos;
  public
    { Public declarations }
  end;

var
  fEditor: TfEditor;

implementation

{$R *.dfm}

resourcestring
  sColRowInfo = 'Linha: %3d   Coluna: %3d';

procedure TfEditor.UpdateCursorPos;
var
  CharPos: TPoint;
begin
  CharPos.Y := SendMessage(RichEdit1.Handle, EM_EXLINEFROMCHAR, 0,
    RichEdit1.SelStart);
  CharPos.X := (RichEdit1.SelStart -
    SendMessage(RichEdit1.Handle, EM_LINEINDEX, CharPos.Y, 0));
  Inc(CharPos.Y);
  Inc(CharPos.X);
  StatusBar1.Panels[0].Text := Format(sColRowInfo, [CharPos.Y, CharPos.X]);
end;

procedure TfEditor.FormShow(Sender: TObject);
begin
  UpdateCursorPos;
end;

procedure TfEditor.RichEdit1SelectionChange(Sender: TObject);
begin
  UpdateCursorPos;
end;

procedure TfEditor.Abrir1Click(Sender: TObject);
var
  s,
  sNumLin : string;
  nNumLin : integer;
  f : System.text;
begin
RichEdit1.Lines.Clear;
StatusBar1.Panels[1].Text := '';
if not openDialog1.Execute then
  begin
  messageDlg('Selecione um arquivo de relatórios para editá-lo.',mtWarning,[mbOk],0);
  exit;
  end;
sNumLin := '100';
sNumLin := inputBox('Abertura de relatórios','Número de linhas a recuperar:',sNumLin);
try
  nNumLin := strToInt(sNumLin)
except
  on e:exception do
    begin
    messageDlg('Informe apenas valores numéricos.',mtError,[mbOk],0);
    exit;
    end;
end;
if nNumLin < 1 then
  begin
  messageDlg('Informe apenas valores numéricos positivos e maiores que zero.',mtError,[mbOk],0);
  exit;
  end;
assignFile(f,openDialog1.FileName);
try
  reset(f);
  StatusBar1.Panels[2].Text := extractFileName(openDialog1.FileName);
except
  on e:exception do
    begin
    closeFile(f);
    messageDlg('Erro ao abrir o arquivo: '+openDialog1.FileName,mtError,[mbOk],0);
    exit;
    end;
end;
StatusBar1.Panels[1].Text := 'Carregando...';
application.ProcessMessages;
screen.Cursor := crHourGlass;
while (RichEdit1.Lines.Count+1<nNumLin) and (not eof(f)) do
  begin
  readLn(f,s);
  RichEdit1.Lines.Add(s);
  if (RichEdit1.Lines.Count mod 100) = 0 then
     application.ProcessMessages;
  end;
closeFile(f);
StatusBar1.Panels[1].Text := 'Pronto';
screen.Cursor := crDefault;
application.ProcessMessages;
end;

end.
