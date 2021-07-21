unit usuRelAdv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Grids, DBGrids, DBCtrls, DB;

type
  TfUsuRelAdv = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    SpeedButton2: TSpeedButton;
    BitBtn3: TBitBtn;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ComboBox1: TComboBox;
    Label5: TLabel;
    ListBox1: TListBox;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fUsuRelAdv: TfUsuRelAdv;

implementation

uses dataModule;

{$R *.dfm}

procedure TfUsuRelAdv.FormShow(Sender: TObject);
begin
with repositorioDeDados do
  begin
  ComboBox1.Items.Clear;
  Query01.SQL.Clear;
  Query01.SQL.Add('select codSis, nomeSis from sistema order by nomeSis');
  Query01.Open;
  while not Query01.eof do
    begin
    ComboBox1.Items.Add(Query01.Fields[0].AsString+' : '+Query01.Fields[1].AsString);
    Query01.Next;
    end;
  Query01.Close;

  ListBox4.Items.Clear;
  Query01.Sql.Clear;
  Query01.SQL.Add('select codusuario from usuarios order by codusuario');
  Query01.Open;
  while not Query01.eof do
    begin
    ListBox4.Items.Add(Query01.Fields[0].AsString);
    Query01.Next;
    end;
  Query01.Close;

  end;
end;

procedure TfUsuRelAdv.ComboBox1Change(Sender: TObject);
begin
ListBox2.Items.Clear;
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('select codgrupo, nomegrupo from gruposdfn');
  Query01.SQL.Add('where codsis = :a');
  Query01.SQL.Add('order by codGrupo');
  Query01.Parameters[0].Value := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox2.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

procedure TfUsuRelAdv.ListBox2Click(Sender: TObject);
var
  i : integer;
  s : string;
begin
ListBox3.Items.Clear;
s := '';
for i := 0 to ListBox2.Items.Count-1 do
  if ListBox2.Selected[i] then
    s := s + trim(Copy(ListBox2.Items.Strings[i],1,Pos(' : ',ListBox2.Items.Strings[i])))+',';
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('select distinct codsubgrupo, nomesubgrupo from subgruposdfn');
  Query01.SQL.Add('where codsis = :a and codgrupo in (:b)');
  Query01.Parameters[0].Value := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
  Query01.Parameters[1].Value := Copy(s,1,Length(s)-1);
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox3.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  end;
end;

procedure TfUsuRelAdv.ListBox3Click(Sender: TObject);
var
  i : integer;
  codGrupo,
  codSubGrupo : string;
begin
ListBox1.Items.Clear;
codGrupo := '';
for i := 0 to ListBox2.Items.Count-1 do
  if ListBox2.Selected[i] then
    codGrupo := codGrupo + trim(Copy(ListBox2.Items.Strings[i],1,Pos(' : ',ListBox2.Items.Strings[i])))+',';
codSubGrupo := '';
for i := 0 to ListBox3.Items.Count-1 do
  if ListBox3.Selected[i] then
    codSubGrupo := codSubGrupo + trim(Copy(ListBox3.Items.Strings[i],1,Pos(' : ',ListBox3.Items.Strings[i])))+',';
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('select codrel, nomerel from dfn');
  Query01.SQL.Add('where codsis =:a and codgrupo in (:b) and codsubgrupo in (:c)');
  Query01.SQL.Add('order by codrel');
  Query01.Parameters[0].Value := 'null';
  Query01.Parameters[1].Value := 'null';
  Query01.Parameters[2].Value := 'null';
  //Query01.Parameters[0].Value := strToInt(trim(Copy(ComboBox1.Text,1,Pos(' : ',ComboBox1.Text))));
  //Query01.Parameters[1].Value := Copy(codGrupo,1,Length(codGrupo)-1);
  //Query01.Parameters[2].Value := Copy(codSubGrupo,1,Length(codSubGrupo)-1);
  Query01.Open;
  while not Query01.Eof do
    begin
    ListBox1.Items.Add(Query01.Fields[0].asString + ' : ' + Query01.Fields[1].asString);
    Query01.Next;
    end;
  Query01.Close;
  end;
end;

end.
