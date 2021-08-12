unit grupoRelNovo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, StdCtrls, Buttons, ExtCtrls, DBCtrls;

type
  TfGrupoRelNovo = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    ComboBox3: TComboBox;
    Label4: TLabel;
    ComboBox4: TComboBox;
    Label5: TLabel;
    ComboBox5: TComboBox;
    Label6: TLabel;
    ComboBox6: TComboBox;
    ListBox1: TListBox;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    ComboBox7: TComboBox;
    Label8: TLabel;
    ComboBox8: TComboBox;
    Label9: TLabel;
    ComboBox9: TComboBox;
    SpeedButton2: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fGrupoRelNovo: TfGrupoRelNovo;

implementation

Uses DataModule, ADOdb, programa;

{$R *.dfm}

procedure TfGrupoRelNovo.FormShow(Sender: TObject);
begin
with repositorioDeDados do
//  if (DataSource1.State = dsInactive) or (not DataSource1.Enabled)	then  // Sempre refaz
    begin
    DataSource1.Enabled := True;
    qGrupoRelNovo.SQL.Text := 'SELECT * FROM GRUPOREL ORDER BY NOMEGRUPOUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO';
    qGrupoRelNovo.Open;

    DbGrid1.Columns[0].Title.Caption := 'Grupo de relatórios';
    DbGrid1.Columns[1].Title.Caption := fConfiguracao.Edit17.Text;
    DbGrid1.Columns[2].Title.Caption := fConfiguracao.Edit11.Text;
    DbGrid1.Columns[3].Title.Caption := fConfiguracao.Edit12.Text;
    DbGrid1.Columns.Items[5].PickList.Clear;
    DbGrid1.Columns.Items[5].PickList.Add('INC');
    DbGrid1.Columns.Items[5].PickList.Add('EXC');

    qAux1.SQL.Text := 'SELECT DISTINCT NOMEGRUPOUSUARIO FROM GRUPOREL ORDER BY 1';
    qAux1.Open;
    ComboBox1.Clear;
    Combobox1.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox1.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;

    qAux1.SQL.Text := 'SELECT DISTINCT CODSIS FROM GRUPOREL ORDER BY 1';
    qAux1.Open;
    ComboBox2.Clear;
    Combobox2.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox2.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;

    qAux1.SQL.Text := 'SELECT DISTINCT CODGRUPO FROM GRUPOREL ORDER BY 1';
    qAux1.Open;
    ComboBox3.Clear;
    Combobox3.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox3.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;

    qAux1.SQL.Text := 'SELECT DISTINCT CODSUBGRUPO FROM GRUPOREL ORDER BY 1';
    qAux1.Open;
    ComboBox4.Clear;
    Combobox4.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox4.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;

    qAux1.SQL.Text := 'SELECT DISTINCT CODREL FROM GRUPOREL ORDER BY 1';
    qAux1.Open;
    ComboBox5.Clear;
    Combobox5.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox5.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;

    qAux1.SQL.Text := 'SELECT DISTINCT TIPO FROM GRUPOREL ORDER BY 1';
    qAux1.Open;
    ComboBox6.Clear;
    Combobox6.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox6.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;

    // Montando os dados iniciais da parte combinatória do form.........

    ListBox1.Clear;
    qRelaRelNovo.SQL.Text := 'SELECT * FROM DFN ORDER BY CODREL';
    qRelaRelNovo.Open;
    while not qRelaRelNovo.Eof do
      begin
      ListBox1.Items.Add(qRelaRelNovo.Fields[0].AsString);
      qRelaRelNovo.Next;
      end;
    qRelaRelNovo.Close;

    qAux1.SQL.Text := 'SELECT DISTINCT CODSIS FROM SUBGRUPOSDFN ORDER BY 1';
    qAux1.Open;
    ComboBox7.Clear;
    ComboBox8.Clear;
    ComboBox9.Clear;
    Combobox7.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox7.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;


    end;
end;

procedure TfGrupoRelNovo.ComboBox1Change(Sender: TObject);
var
  auxWhere : string;
begin
with repositorioDeDados do
  begin
  qGrupoRelNovo.Close;
  if (ComboBox1.Text <> '') or
     (ComboBox2.Text <> '') or
     (ComboBox3.Text <> '') or
     (ComboBox4.Text <> '') or
     (ComboBox5.Text <> '') or
     (ComboBox6.Text <> '') then
    auxWhere := 'WHERE '
  else
    auxWhere := '';

  qGrupoRelNovo.SQL.Clear;
  qGrupoRelNovo.SQL.Add('SELECT * FROM GRUPOREL ');

  if ComboBox1.Text <> '' then
    begin
    qGrupoRelNovo.SQL.Add(auxWhere + 'NOMEGRUPOUSUARIO = ''' + ComboBox1.Text + '''');
    auxWhere := 'AND ';
    end;

  if ComboBox2.Text <> '' then
    begin
    qGrupoRelNovo.SQL.Add(auxWhere + 'CODSIS = ' + ComboBox2.Text);
    auxWhere := 'AND ';
    end;

  if ComboBox3.Text <> '' then
    begin
    qGrupoRelNovo.SQL.Add(auxWhere + 'CODGRUPO = ' + ComboBox3.Text);
    auxWhere := 'AND ';
    end;

  if ComboBox4.Text <> '' then
    begin
    qGrupoRelNovo.SQL.Add(auxWhere + 'CODSUBGRUPO = ' + ComboBox4.Text);
    auxWhere := 'AND ';
    end;

  if ComboBox5.Text <> '' then
    begin
    qGrupoRelNovo.SQL.Add(auxWhere + 'CODREL = ''' + ComboBox5.Text + '''');
    auxWhere := 'AND ';
    end;

  if ComboBox6.Text <> '' then
    begin
    qGrupoRelNovo.SQL.Add(auxWhere + 'TIPO = ''' + ComboBox6.Text + '''');
    auxWhere := 'AND ';
    end;

  qGrupoRelNovo.SQL.Add('ORDER BY NOMEGRUPOUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO');

  qGrupoRelNovo.Open;

  DbGrid1.Columns[0].Title.Caption := 'Grupo de relatórios';
  DbGrid1.Columns[1].Title.Caption := fConfiguracao.Edit17.Text;
  DbGrid1.Columns[2].Title.Caption := fConfiguracao.Edit11.Text;
  DbGrid1.Columns[3].Title.Caption := fConfiguracao.Edit12.Text;
  DbGrid1.Columns.Items[5].PickList.Clear;
  DbGrid1.Columns.Items[5].PickList.Add('INC');
  DbGrid1.Columns.Items[5].PickList.Add('EXC');

  end;
end;

procedure TfGrupoRelNovo.FormCreate(Sender: TObject);
begin
Label2.Caption := fConfiguracao.Edit17.Text;
Label7.Caption := fConfiguracao.Edit17.Text;
Label3.Caption := fConfiguracao.Edit11.Text;
Label8.Caption := fConfiguracao.Edit11.Text;
Label4.Caption := fConfiguracao.Edit12.Text;
Label9.Caption := fConfiguracao.Edit12.Text;
end;

procedure TfGrupoRelNovo.ComboBox7Change(Sender: TObject);
var
  auxWhere : string;
begin
with repositorioDeDados do
  begin
  if (ComboBox7.Text <> '') or
     (ComboBox8.Text <> '') or
     (ComboBox8.Text <> '') or
     (ComboBox8.Text <> '') or
     (ComboBox8.Text <> '') or
     (ComboBox8.Text <> '') then
    auxWhere := 'WHERE '
  else
    auxWhere := '';

  qRelaRelNovo.SQL.Clear;
  qRelaRelNovo.SQL.Add('SELECT * FROM DFN ');

  if (ComboBox7.Text <> '') then
    begin
    if (ComboBox7.Text <> '-999') then
      begin
      qRelaRelNovo.SQL.Add(auxWhere + 'CODSIS = ' + ComboBox7.Text);
      auxWhere := 'AND ';
      end;                               // Preencher o combobox8
    qAux1.SQL.Text := 'SELECT DISTINCT CODGRUPO FROM SUBGRUPOSDFN WHERE CODSIS = ' + ComboBox7.Text +' ORDER BY 1';
    qAux1.Open;
    ComboBox8.Clear;
    Combobox8.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox8.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;
    end;

  if (ComboBox8.Text <> '') then
    begin
    if (ComboBox8.Text <> '-999') then
      begin
      qRelaRelNovo.SQL.Add(auxWhere + 'CODGRUPO = ' + ComboBox8.Text);
      auxWhere := 'AND ';
      end;                                   // Preencher o combobox9
    qAux1.SQL.Text := 'SELECT DISTINCT CODSUBGRUPO FROM SUBGRUPOSDFN WHERE CODSIS = ' + ComboBox7.Text +' AND CODGRUPO = ' + ComboBox8.Text + ' ORDER BY 1';
    qAux1.Open;
    ComboBox9.Clear;
    Combobox9.Items.Add('');
    while not qAux1.Eof do
      begin
      Combobox9.Items.Add(qAux1.Fields[0].AsString);
      qAux1.Next;
      end;
    qAux1.Close;
    end;

  ListBox1.Clear;
  qRelaRelNovo.SQL.Add('ORDER BY CODREL');
  qRelaRelNovo.Open;
  while not qRelaRelNovo.Eof do
    begin
    ListBox1.Items.Add(qRelaRelNovo.Fields[0].AsString);
    qRelaRelNovo.Next;
    end;
  qRelaRelNovo.Close;

  end;
end;

procedure TfGrupoRelNovo.SpeedButton2Click(Sender: TObject);
begin
Close;
end;

end.
