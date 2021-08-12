unit UnitContaExtratosSantander;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sugeral;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
Label
  fim;
Var
  Ano,
  Mes : Integer;
  Reports1Str,
  Dirdest : String;
  Reports1Rec : TSearchRec;
  ArqIndiceContaCartao : TgArqIndiceContaCartao;
begin
Edit1.Text := IncludeTrailingBackSlash(Edit1.Text);
For Ano := 1990 to 2050 Do
  For Mes := 1 to 12 Do
    Begin
    DirDest := Edit1.Text + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]);
    If DirectoryExists(DirDest) Then
      Begin
      Reports1Str := DirDest + '\' + '*.IND';

      If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
        begin
          repeat
            If Pos('EXTRCONTA', Reports1Rec.Name) <> 0 Then
              Begin
              AssignFile(ArqIndiceContaCartao,DirDest+'\'+Reports1Rec.Name);
              Reset(ArqIndiceContaCartao);
              Memo1.Lines.Add(IntToStr(Ano) + Format('%2.2d',[Mes]) + '= ' + Format('%8.8d',[FileSize(ArqIndiceContaCartao)]));
              Application.ProcessMessages;
              CloseFile(ArqIndiceContaCartao);
              End;
          until FindNext(Reports1Rec) <> 0;
        SysUtils.FindClose(Reports1Rec);
        end;
      End;
    End;
fim:
ShowMessage('Fim da contagem');
end;

end.
