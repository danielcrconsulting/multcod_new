unit Ts;

{ Este projeto é um exemplo de como usar a nova rotina de Sort Disponível }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, SSort, StdCtrls, SuTypGer;

type
  TFormTs = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSort = Class (SuperSort)
          Procedure InPutSort; Override;
          procedure OutPutSort; Override;
          Function  Less(var x, y) : boolean; Override;
          end;

var
  FormTs: TFormTs;

implementation

{$R *.DFM}

var
  TsSort : SuperSort;

procedure TSort.InputSort;

var
  a,b,c,d,e : byte;
  Cont : LongInt;
  Regis : TgStr005;
begin
Cont := 0;
for a := Ord('Z') Downto Ord('A') do
  for b := Ord('Z') Downto Ord('A') do
    for c := Ord('Z') Downto Ord('A') do
      for d := Ord('Z') Downto Ord('A') do
        for e := Ord('Z') Downto Ord('A') do
          begin
          Regis := Chr(a) + Chr(b) + Chr(c) + Chr(d) + Chr(e);
          SortRelease(Regis);
          Inc(Cont);
          if Cont = 5000000 then
            exit;
          end;
end;

procedure TSort.OutPutSort;

var
    Regis : TgStr005;
begin
if SortEos then
  Exit;

Repeat
  SortReturn(Regis);
Until SortEos;
end;

function Tsort.Less;

var
  Str1 : TgStr005 absolute X;
  Str2 : TgStr005 absolute Y;

begin
Less := Str1 < Str2;
end;

procedure TFormTs.Button1Click(Sender: TObject);

var
  Retorno : byte;
  Tempo1,
  Tempo2 : TDateTime;
begin
Tempo1 := Now;
TsSort := TSort.Create;
Retorno := TsSort.TurboSort(SizeOf(TgStr005));
Tempo2 := Now;
if Retorno  = 0 then
  ShowMessage('Beleza : '+FormatDateTime('HH:NN:SS',Tempo2-Tempo1))
else
  ShowMessage('Furou '+IntToStr(Retorno)+' : '+FormatDateTime('HH:NN:SS',Tempo2-Tempo1));
TsSort.Destroy;
end;

end.
