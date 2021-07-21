unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DataModule;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
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
begin
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT CODREL, NOMEREL, CODGRUPO, CODGRUPAUTO, DTCRIACAO FROM DFN ORDER BY CODREL');
  Query01.Open;
  ListBox1.Items.Clear;
  while not Query01.Eof do
    begin
    If ((Query01.Fields[2].AsInteger <> -1) and (Query01.Fields[3].AsString = 'T')) then
      begin
      ListBox1.Items.Add(Format('%-15s',[Query01.Fields[0].asString]) + ' : ' + Format('%-5s',[Query01.Fields[2].AsString]) + ' : ' +
        Copy(Query01.Fields[4].AsString, 1, 10) + ' : ' + Query01.Fields[1].asString);
      end;
    Query01.Next;
    end;
  Query01.Close;
  End;
end;

end.
