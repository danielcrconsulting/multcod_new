unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Grid, FMX.Edit;

type
  TForm1 = class(TForm)
    StringGrid3: TStringGrid;
    ButtonAnal: TButton;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    StringColumn8: TStringColumn;
    StringColumn9: TStringColumn;
    StringColumn10: TStringColumn;
    Sair: TButton;
    Label1: TLabel;
    EditArqIn: TEdit;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Limpar: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid4: TStringGrid;
    SaveDialog1: TSaveDialog;
    StringColumn11: TStringColumn;
    StringColumn12: TStringColumn;
    StringColumn13: TStringColumn;
    StringColumn14: TStringColumn;
    StringColumn15: TStringColumn;
    StringColumn16: TStringColumn;
    StringColumn17: TStringColumn;
    StringColumn18: TStringColumn;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    Edit1: TEdit;
    CornerButton1: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure SairClick(Sender: TObject);
    procedure EditArqInDblClick(Sender: TObject);
    procedure ButtonAnalClick(Sender: TObject);
    procedure LimparClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  procedure AutoSizeCol(Grid: TStringColumn; Coluna : Integer);
  Procedure LeScript(FileName : String);
  procedure Ajusta;
  end;

var
  Form1: TForm1;
  Campos : array[0..999] of integer;

implementation

{$R *.fmx}

procedure TForm1.Ajusta;
begin
  AutoSizeCol(StringColumn1, 0);
  AutoSizeCol(StringColumn2, 1);
  AutoSizeCol(StringColumn3, 2);
  AutoSizeCol(StringColumn4, 3);
  AutoSizeCol(StringColumn5, 4);
  AutoSizeCol(StringColumn6, 5);
  AutoSizeCol(StringColumn7, 6);
  AutoSizeCol(StringColumn8, 7);
  AutoSizeCol(StringColumn9, 8);
  AutoSizeCol(StringColumn10, 9);
end;

procedure TForm1.AutoSizeCol(Grid: TStringColumn; Coluna : Integer);
var
  i : integer;
  W,
  WMax : Extended;
begin
  WMax := Grid.Canvas.TextWidth(Grid.Header);
  for I := 0 to StringGrid1.RowCount do
    begin
    W := Grid.Canvas.TextWidth(StringGrid3.Cells[Coluna, i]);
    if W > WMax then
      WMax := W;
    end;
  Grid.Width := WMax + 10;
end;

procedure TForm1.ButtonAnalClick(Sender: TObject);
Var
  ArqTam : TFileStream;
  Arq : System.Text;
  Linha,
  LinhaAux : String;
  I, J,
  totCampos : Integer;
  auxTipo : Char;
begin
if EditArqIn.Text = '' then
  begin
    ShowMessage('Informe o nome do arquivo...');
    Exit;
  end;

for I  := 1 to Linha.CountChar(';') do
  Campos[I] := 0;

ArqTam := TFileStream.Create(EditArqIn.Text, fmOpenRead, fmShareExclusive);
ProgressBar1.Max := ArqTam.Size;
ProgressBar1.Value := 0;
ArqTam.Free;

AssignFile(Arq, EditArqIn.Text);
Reset(Arq);

ReadLn(Arq, Linha);
ProgressBar1.Value := ProgressBar1.Value + Linha.Length + 2;
Application.ProcessMessages;

if Linha.CountChar(';') <> 0 then
  auxTipo := ';'                        //'Ponto e Vírgula'
else
if Linha.CountChar(chr(09)) <> 0 then
  auxTipo :=  chr(09)                  //'TAB'
else
  begin
    ShowMessage('Separador não pode ser identificado...');
    Exit;
  end;

totCampos := 0;

for I  := 1 to Linha.CountChar(auxTipo) do
  begin
    StringGrid3.Cells[0,I-1] := Linha.Substring(0, Linha.IndexOf(auxTipo));
    Linha := Linha.Remove(0, Linha.IndexOf(auxTipo)+1);
    inc(totCampos);

    StringGrid3.Cells[2,I-1] := '*';
    StringGrid3.Cells[4,I-1] := '0';
    StringGrid3.Cells[5,I-1] := '3';
    StringGrid3.Cells[6,I-1] := 'N';
    StringGrid3.Cells[7,I-1] := 'C';
  end;

J := 0;

while not Eof(Arq) do
  begin
    ReadLn(Arq, Linha);

    ProgressBar1.Value := ProgressBar1.Value + Linha.Length + 2;
    Inc(J);
    if (J mod 1000) = 0 then
      Application.ProcessMessages;

    for I := 0 to totCampos-1 do
      begin
        LinhaAux := Linha.Substring(0, Linha.IndexOf(auxTipo));
        Linha := Linha.Remove(0, Linha.IndexOf(auxTipo)+1);

        if LinhaAux.Length+1 > Campos[I] then           // +1 para liberar um espaço entre os campos!!!
          Campos[I] := LinhaAux.Length+1;
      end;
  end;

J := 1;
for I := 0 to totCampos-1 do
  begin
    StringGrid3.Cells[1,I] := IntToStr(J);
    StringGrid3.Cells[3,I] := IntToStr(Campos[I]);
    Inc(J, Campos[I]);
  end;

CloseFile(Arq);

Ajusta;
end;

Procedure TForm1.LeScript(FileName : String);
Var
  Arq : System.Text;
  I,J : Integer;
  Linha : String;
Begin
LimparClick(Self);

AssignFile(Arq,FileName);
Reset(Arq);

ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq,Linha);
ReadLn(Arq, Linha);

For I := 0 To 99 Do
  Begin
  For J := 0 To 1 Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid1.Cells[J,I] := Linha;
    End;
  For J := 0 To 2 Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid2.Cells[J,I] := Linha;
    End;
  For J := 0 To 9 Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid3.Cells[J,I] := Linha;
    End;
  For J := 0 To 2 Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid4.Cells[J,I] := Linha;
    End;
  End;
CloseFile(Arq);

Ajusta;
End;

procedure TForm1.Button2Click(Sender: TObject);
begin
OpenDialog1.InitialDir := 'C:\ColdCfg';
If OpenDialog1.Execute Then
  LeScript(OpenDialog1.FileName);
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  Arq : System.Text;
  I,J : Integer;

Begin
SaveDialog1.InitialDir := 'C:\ColdCfg\';

If SaveDialog1.Execute Then
  Begin
  AssignFile(Arq,SaveDialog1.FileName);
  ReWrite(Arq);
  WriteLn(Arq,'XTRFILEV4');
  WriteLn(Arq,'AUTOXTR'); // Descrição...
  WriteLn(Arq,'N');           //V3
  WriteLn(Arq,'N');           // V3
  WriteLn(Arq,'');    // V3
  WriteLn(Arq,'1');
  WriteLn(Arq,'*');
  WriteLn(Arq,'1');
  WriteLn(Arq,'60');
  WriteLn(Arq,'N');        //V4
  For I := 0 To 99 Do
    Begin
    For J := 0 To 1 Do
      WriteLn(Arq,Trim(StringGrid1.Cells[J,I]));
    For J := 0 To 2 Do
      WriteLn(Arq,Trim(StringGrid2.Cells[J,I]));
    For J := 0 To 9 Do
      WriteLn(Arq,Trim(StringGrid3.Cells[J,I]));
    For J := 0 To 2 Do
      WriteLn(Arq,Trim(StringGrid4.Cells[J,I]));
    End;
  CloseFile(Arq);
  End;end;

procedure TForm1.CornerButton1Click(Sender: TObject);
Var
  ArqTam : TFileStream;
  ArqIn,
  ArqOut : System.Text;
  I,J,
  totCampos : Integer;
  Linha,
  LinhaAux,
  LinhaOut : String;
  auxTipo : Char;

Begin

If Edit1.Text = '' then
  begin
    ShowMessage('Informe o nome do arquivo a gerar...');
    Exit;
  end;

ArqTam := TFileStream.Create(EditArqIn.Text, fmOpenRead, fmShareExclusive);
ProgressBar1.Max := ArqTam.Size;
ProgressBar1.Value := 0;
ArqTam.Free;

AssignFile(ArqIn, EditArqIn.Text);
AssignFile(ArqOut,Edit1.Text);

Reset(ArqIn);
ReWrite(ArqOut);

ReadLn(Arqin, Linha); //Pula o cabeçalho e carrega os dados para a identificação do separador

if Linha.CountChar(';') <> 0 then
  auxTipo := ';'                        //'Ponto e Vírgula'
else
if Linha.CountChar(chr(09)) <> 0 then
  auxTipo :=  chr(09)                  //'TAB'
else
  begin
    ShowMessage('Separador não pode ser identificado...');
    Exit;
  end;

totCampos := 0;
while StringGrid3.Cells[3,totCampos+1] <> '' do
  begin
    Campos[totCampos] := StrToInt(StringGrid3.Cells[3,totCampos+1]);
    Inc(totCampos);
  end;

{CloseFile(ArqIn);  // Just to include the first line
AssignFile(ArqIn, EditArqIn.Text);
Reset(ArqIn);}

J := 0;
while not Eof(ArqIn) do
  begin
    ReadLn(ArqIn, Linha);

    ProgressBar1.Value := ProgressBar1.Value + Linha.Length + 2;
    Inc(J);
    if (J mod 1000) = 0 then
      Application.ProcessMessages;

    LinhaOut := '';

    for I := 0 to totCampos-1 do
      begin
        LinhaAux := Linha.Substring(0, Linha.IndexOf(auxTipo));
        Linha := Linha.Remove(0, Linha.IndexOf(auxTipo)+1);

        while LinhaAux.Length < Campos[I] do
          LinhaAux := LinhaAux + ' ';

        LinhaOut := LinhaOut + LinhaAux;
      end;
    WriteLn(ArqOut, LinhaOut);
  end;


CloseFile(ArqIn);
CloseFile(ArqOut);

ShowMessage('Feito...');

end;

procedure TForm1.EditArqInDblClick(Sender: TObject);
begin
if OpenDialog1.Execute then
  EditArqIn.Text := OpenDialog1.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
StringColumn1.Header := 'Nome';
StringColumn2.Header := 'Coluna';
StringColumn3.Header := 'Linha';
StringColumn4.Header := 'Tamanho';
StringColumn5.Header := 'Relativo';
StringColumn6.Header := 'Brancos';
StringColumn7.Header := 'Obrigatorio';
StringColumn8.Header := 'Tipo do Campo';
StringColumn9.Header := 'Formatação de entrada';
StringColumn10.Header := 'Formatação de saída';
end;

procedure TForm1.LimparClick(Sender: TObject);
var
  I , J : Integer;
begin
for I := 0 to StringGrid3.ColumnCount-1 do
  for J := 0 to StringGrid3.RowCount-1 do
    StringGrid3.Cells[I, J] := '';
ProgressBar1.Value := 0;
end;

procedure TForm1.SairClick(Sender: TObject);
begin
Close;
end;

end.
