unit UApura;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Subrug;

type
  TForm1 = class(TForm)
    ButtonJuntar: TButton;
    Button2: TButton;
    Label3: TLabel;
    EditNomeArq: TEdit;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label4: TLabel;
    ComboBox3: TComboBox;
    Label5: TLabel;
    ComboBox4: TComboBox;
    Label6: TLabel;
    ComboBox5: TComboBox;
    Label7: TLabel;
    ComboBox6: TComboBox;
    ListBox1: TListBox;
    Label9: TLabel;
    ComboBox7: TComboBox;
    Label10: TLabel;
    ComboBox8: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure ButtonJuntarClick(Sender: TObject);
    procedure EditNomeArqDblClick(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox3Select(Sender: TObject);
    procedure ComboBox5Select(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  Buff1 : Array[1..1024*1024*100] of char;

  Arr1,
  Arr2 : Array of AnsiString;

implementation

{$R *.dfm}

Procedure SortEmMemoria(PosChave, TamChave : Integer);

  Procedure QuickSort(iLo, iHi: Integer);
  Var
    Lo, Hi : Integer;
    Mid, T : AnsiString;
  Begin

    Lo := iLo;
    Hi := iHi;

    Mid := Arr1[(Lo + Hi) div 2];

    Repeat
      While Copy(Arr1[Lo], PosChave, TamChave) < Copy(Mid, PosChave, TamChave) do
        Inc(Lo);

      While Copy(Arr1[Hi], PosChave, TamChave) > Copy(Mid, PosChave, TamChave) do
        Dec(Hi);

      If Lo <= Hi then
      Begin
        T := Arr1[Lo];
        Arr1[Lo] := Arr1[Hi];
        Arr1[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      End;
    Until Lo > Hi;
    If Hi > iLo Then QuickSort(iLo, Hi);
    If Lo < iHi Then QuickSort(Lo, iHi);
  End;

Begin
QuickSort(Low(Arr1), High(Arr1));
Application.ProcessMessages;
End;

procedure TForm1.ButtonJuntarClick(Sender: TObject);
Var
  ArqIn,
  ArqOut : System.Text;

  I,
  Ind1,
  Ind3,
  Ind5,
  Ind7,
  Ind8 : Integer;

  Val1,
  Val2 : Extended;

  Linha : String;
  Conteudo : TArray<String>;

  Cmpl : String;

begin

AssignFile(ArqIn, EditNomeArq.Text);
Reset(ArqIn);

ReadLn(ArqIn, Linha);
ReadLn(ArqIn, Linha);

Val1 := 0;
Val2 := 0;
Ind1 := ComboBox1.ItemIndex;
Ind3:= ComboBox3.ItemIndex;
Ind5:= ComboBox5.ItemIndex;
Ind7 := ComboBox7.ItemIndex;
Ind8 := ComboBox8.ItemIndex;

Cmpl := '';

for I := 0 to ListBox1.Items.Count-1 do
  begin
    If ListBox1.Selected[I] then
      Cmpl := Cmpl + ListBox1.Items[I];
  end;

while Not Eof(ArqIn) do
  begin
    ReadLn(ArqIn, Linha);
    Conteudo := Linha.Split([';']);

    if Conteudo[Ind1] = ComboBox2.Items[ComboBox2.ItemIndex] then
      if Conteudo[Ind3] = ComboBox4.Items[ComboBox4.ItemIndex] then
        if Cmpl.Contains(Trim(Conteudo[Ind5])) then
    begin
    Val1 := Val1 + StrToFloat(Conteudo[Ind7]);
    Val2 := Val2 + StrToFloat(Conteudo[Ind8]);
    end;

  end;

Edit1.Text := Format ('%18.2n', [Val1 / 100]);
Edit2.Text := Format ('%18.2n', [Val2 / 100]) ;
Edit3.Text := Format ('%18.2n', [abs(Val1-Val2) / 100]);


CloseFile(ArqIn);

ShowMessage('Fim de processamento...');

end;

procedure TForm1.ComboBox1Select(Sender: TObject);
Var
  VCampoAnt,
  Linha : String;
  ArqIn : System.Text;
  Conteudo : TArray<String>;
  Ind : Integer;
begin
ComboBox2.Clear;
AssignFile(ArqIn, EditNomeArq.Text);
Reset(ArqIn);

ReadLn(ArqIn, Linha);
ReadLn(ArqIn, Linha);

Ind := ComboBox1.ItemIndex;
VCampoAnt := '';
while Not Eof(ArqIn) do
  begin
    ReadLn(ArqIn, Linha);
    Conteudo := Linha.Split([';']);
    if (Copy(Conteudo[Ind],1, 3) <> '   ') and (Conteudo[Ind] <> VCampoAnt) then
      begin
      ComboBox2.AddItem(Conteudo[Ind], nil);
      VCampoAnt := Conteudo[Ind];
      end;
  end;

CloseFile(ArqIn);
end;

procedure TForm1.ComboBox3Select(Sender: TObject);
Var
  VCampoAnt,
  Linha : String;
  ArqIn : System.Text;
  Conteudo : TArray<String>;
  Ind,
  Ind1 : Integer;
begin
ComboBox4.Clear;
AssignFile(ArqIn, EditNomeArq.Text);
Reset(ArqIn);

ReadLn(ArqIn, Linha);
ReadLn(ArqIn, Linha);

Ind1 := ComboBox1.ItemIndex;
Ind := ComboBox3.ItemIndex;

VCampoAnt := '';
while Not Eof(ArqIn) do
  begin
    ReadLn(ArqIn, Linha);
    Conteudo := Linha.Split([';']);
    if (Copy(Conteudo[Ind],1, 3) <> '   ') and (Conteudo[Ind] <> VCampoAnt) then
      if Conteudo[Ind1] = ComboBox2.Items[ComboBox2.ItemIndex] then
        begin
        ComboBox4.AddItem(Conteudo[Ind], nil);
        VCampoAnt := Conteudo[Ind];
        end;
  end;

CloseFile(ArqIn);
end;

procedure TForm1.ComboBox5Select(Sender: TObject);
Var
  VCampoAnt,
  Linha : String;
  ArqIn : System.Text;
  Conteudo : TArray<String>;
  I,
  Ind,
  Ind1,
  Ind2 : Integer;
begin
ComboBox6.Clear;
ListBox1.Clear;

AssignFile(ArqIn, EditNomeArq.Text);
Reset(ArqIn);

ReadLn(ArqIn, Linha);
ReadLn(ArqIn, Linha);

Ind1 := ComboBox1.ItemIndex;
Ind2:= ComboBox3.ItemIndex;
Ind:= ComboBox5.ItemIndex;

VCampoAnt := '';
while Not Eof(ArqIn) do
  begin
    ReadLn(ArqIn, Linha);
    Conteudo := Linha.Split([';']);
    if (Copy(Conteudo[Ind],1, 3) <> '   ') and (Conteudo[Ind] <> VCampoAnt) then
      if Conteudo[Ind1] = ComboBox2.Items[ComboBox2.ItemIndex] then
        if Conteudo[Ind2] = ComboBox4.Items[ComboBox4.ItemIndex] then
          begin
          ComboBox6.AddItem(Conteudo[Ind], nil);
          VCampoAnt := Conteudo[Ind];
          end;
  end;

Combobox6.Sorted := True;

VCampoAnt := '';
For I := 0 to ComboBox6.Items.Count-1 do
  begin
    if (ComboBox6.Items[I] <> VCampoAnt) then
      begin
      ListBox1.AddItem(ComboBox6.Items[I], nil);
      VCampoAnt := ComboBox6.Items[I];
      end;
  end;

CloseFile(ArqIn);
end;

procedure TForm1.EditNomeArqDblClick(Sender: TObject);
Var
  ArqIn : System.Text;
  Linha,
  Linha1 : String;
  Campos : TArray<String>;
  I : Integer;
begin
If OpenDialog1.Execute Then
  begin
  EditNomeArq.Text := OpenDialog1.FileName;
  Application.ProcessMessages;

  AssignFile(ArqIn, EditNomeArq.Text);
  Reset(ArqIn);

  ReadLn(ArqIn, Linha1);

  ReadLn(ArqIn, Linha);
  I := Linha.LastDelimiter(';');
  Linha := Linha.Remove(I);
  Campos := Linha.Split([';']);

  ComboBox1.DoubleBuffered := true;
  ComboBox1.AutoComplete := true;

  For I := Low(Campos) To High(Campos) do
    ComboBox1.AddItem(Campos[I], nil);

  Closefile(ArqIn);

  ComboBox3.Items := ComboBox1.Items;
  ComboBox5.Items := ComboBox1.Items;
  ComboBox7.Items := ComboBox1.Items;
  ComboBox8.Items := ComboBox1.Items;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

end.
