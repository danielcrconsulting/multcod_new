unit relUsuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ADODB, System.UITypes, Data.DB;

type
  TfRelUsuario = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox3: TComboBox;
    Label3: TLabel;
    ComboBox4: TComboBox;
    Label4: TLabel;
    Bevel1: TBevel;
    Label5: TLabel;
    Edit1: TEdit;
    Label6: TLabel;
    Bevel3: TBevel;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    Label9: TLabel;
    Label10: TLabel;
    Edit2: TEdit;
    Bevel5: TBevel;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    Edit3: TEdit;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    ComboBox1: TComboBox;
    procedure SpeedButton2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fRelUsuario: TfRelUsuario;

implementation

uses dataModule;

{$R *.dfm}

procedure TfRelUsuario.SpeedButton2Click(Sender: TObject);
begin
self.Close;
end;

procedure geraCSV(var rs:TADOQuery);
var
  f : system.Text;
  i : integer;
  s : string;
begin
try
  rs.Open;
except
  begin
  messageDlg('Erro da recuperação dos dados. Verifique suas opções.',mtError,[mbOk],0);
  exit;
  end;
end;
if not fRelUsuario.SaveDialog1.Execute then
  begin
  messageDlg('Geração de arquivo para o Excel foi cancelada.',mtWarning,[mbOk],0);
  exit;
  end;
assignFile(f,fRelUsuario.SaveDialog1.FileName);
rewrite(f);
s := '';
for i := 0 to rs.FieldCount-1 do
  s := s + rs.FieldDefList[i].Name + ';';
writeLn(f,s);
while not rs.eof do
  begin
  s := '';
  for i := 0 to rs.FieldCount-1 do
    s := s + rs.Fields[i].AsString + ';';
  writeLn(f,s);
  rs.Next;
  end;
rs.Close;
closeFile(f);
messageDlg('Fim da exportação.',mtInformation,[mbOk],0);
end;

procedure TfRelUsuario.BitBtn1Click(Sender: TObject);
begin
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  if ComboBox1.ItemIndex = 0 then // Grupos de usuários por relatórios
    begin
    Query01.SQL.Add('SELECT A.NOMEGRUPOUSUARIO, F.CODUSUARIO, A.CODSIS, B.NOMESIS, A.CODGRUPO, ');
    Query01.SQL.Add('       C.NOMEGRUPO, A.CODSUBGRUPO, D.NOMESUBGRUPO, A.CODREL, A.TIPO ');
    Query01.SQL.Add('FROM   GRUPOREL A ');
    Query01.SQL.Add('       JOIN SISTEMA B ');
    Query01.SQL.Add('            ON A.CODSIS = B.CODSIS ');
    Query01.SQL.Add('       JOIN GRUPOSDFN C ');
    Query01.SQL.Add('            ON A.CODSIS = C.CODSIS AND ');
    Query01.SQL.Add('               A.CODGRUPO = C.CODGRUPO ');
    Query01.SQL.Add('       JOIN SUBGRUPOSDFN D ');
    Query01.SQL.Add('            ON A.CODSIS = D.CODSIS AND ');
    Query01.SQL.Add('               A.CODGRUPO = D.CODGRUPO AND ');
    Query01.SQL.Add('               A.CODSUBGRUPO = D.CODSUBGRUPO ');
    Query01.SQL.Add('       JOIN DFN E ');
    Query01.SQL.Add('            ON A.CODREL = E.CODREL ');
    Query01.SQL.Add('       JOIN USUARIOSEGRUPOS F ');
    Query01.SQL.Add('            ON A.NOMEGRUPOUSUARIO = F.NOMEGRUPOUSUARIO ');
    Query01.SQL.Add('WHERE 1=1 ');
    if ComboBox3.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND A.NOMEGRUPOUSUARIO '+ComboBox4.Text+' '''+Edit1.Text+''' ');
      end;
    if ComboBox5.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND F.CODUSUARIO '+ComboBox6.Text+' '''+Edit2.Text+''' ');
      end;
    if ComboBox7.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND E.CODREL '+ComboBox8.Text+' '''+Edit3.Text+''' ');
      end;
    Query01.SQL.Add('ORDER BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10');
    end
  else if ComboBox1.ItemIndex = 1 then // Grupos de usuários
    begin
    Query01.SQL.Add('SELECT A.NOMEGRUPOUSUARIO, F.CODUSUARIO ');
    Query01.SQL.Add('FROM   GRUPOREL A ');
    Query01.SQL.Add('       JOIN USUARIOSEGRUPOS F ');
    Query01.SQL.Add('            ON A.NOMEGRUPOUSUARIO = F.NOMEGRUPOUSUARIO ');
    if ComboBox3.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND A.NOMEGRUPOUSUARIO '+ComboBox4.Text+' '''+Edit1.Text+''' ');
      end;
    if ComboBox5.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND F.CODUSUARIO '+ComboBox6.Text+' '''+Edit2.Text+''' ');
      end;
    Query01.SQL.Add('ORDER BY 1, 2');
    end
  else if ComboBox1.ItemIndex = 2 then // Usuários
    begin
    Query01.SQL.Add('SELECT CODUSUARIO, REMOTO, NOME FROM USUARIOS WHERE 1=1 ');
    if ComboBox3.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND CODUSUARIO '+ComboBox4.Text+' '''+Edit1.Text+''' ');
      end;
    if ComboBox5.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND REMOTO '+ComboBox6.Text+' '''+Edit2.Text+''' ');
      end;
    Query01.SQL.Add('ORDER BY 1, 2');
    end
  else if ComboBox1.ItemIndex = 3 then // Usuários por relatórios
    begin
    Query01.SQL.Add('SELECT A.CODUSUARIO, A.CODSIS, B.NOMESIS, A.CODGRUPO, C.NOMEGRUPO, ');
    Query01.SQL.Add('       A.CODSUBGRUPO, D.NOMESUBGRUPO, A.CODREL, A.TIPO ');
    Query01.SQL.Add('FROM   USUREL A ');
    Query01.SQL.Add('       JOIN SISTEMA B ');
    Query01.SQL.Add('            ON A.CODSIS = B.CODSIS ');
    Query01.SQL.Add('       JOIN GRUPOSDFN C ');
    Query01.SQL.Add('            ON A.CODSIS = C.CODSIS AND ');
    Query01.SQL.Add('               A.CODGRUPO = C.CODGRUPO ');
    Query01.SQL.Add('       JOIN SUBGRUPOSDFN D ');
    Query01.SQL.Add('            ON A.CODSIS = D.CODSIS AND ');
    Query01.SQL.Add('               A.CODGRUPO = D.CODGRUPO AND ');
    Query01.SQL.Add('               A.CODSUBGRUPO = D.CODSUBGRUPO ');
    Query01.SQL.Add('WHERE 1=1 ');
    if ComboBox3.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND A.CODUSUARIO '+ComboBox4.Text+' '''+Edit1.Text+''' ');
      end;
    if ComboBox5.ItemIndex = 0 then
      begin
      Query01.SQL.Add(' AND A.CODREL '+ComboBox6.Text+' '''+Edit2.Text+''' ');
      end;
    Query01.SQL.Add('ORDER BY 1, 2, 3, 4, 5, 6, 7, 8, 9');
    end
  else
    begin
    messageDlg('Selecione o tipo de relatório.',mtWarning,[mbOk],0);
    comboBox1.SetFocus;
    end;

  if Sender = BitBtn1 then
    geraCSV(Query01)
  else
    messageDlg('Relatório indisponível.',mtWarning,[mbOk],0);

  end // with


end;

procedure TfRelUsuario.ComboBox1Change(Sender: TObject);
begin
Edit1.Text := '';
Edit2.Text := '';
Edit3.Text := '';
ComboBox3.Items.Clear;
ComboBox5.Items.Clear;
ComboBox7.Items.Clear;
ComboBox3.Enabled := false;
ComboBox4.Enabled := false;
ComboBox5.Enabled := false;
ComboBox6.Enabled := false;
ComboBox7.Enabled := false;
ComboBox8.Enabled := false;
Edit1.Enabled := false;
Edit2.Enabled := false;
Edit3.Enabled := false;
if ComboBox1.ItemIndex = 0 then // Grupos de usuários por relatórios
  begin
  ComboBox3.Enabled := true;
  ComboBox4.Enabled := true;
  ComboBox5.Enabled := true;
  ComboBox6.Enabled := true;
  ComboBox7.Enabled := true;
  ComboBox8.Enabled := true;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  Edit3.Enabled := true;
  ComboBox3.Items.Add('Nome do grupo de usuário');
  ComboBox5.Items.Add('Código do usuario');
  ComboBox7.Items.Add('Código do relatório');
  end
else if ComboBox1.ItemIndex = 1 then // Grupos de usuários 
  begin
  ComboBox3.Enabled := true;
  ComboBox4.Enabled := true;
  ComboBox5.Enabled := true;
  ComboBox6.Enabled := true;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  ComboBox3.Items.Add('Nome do grupo de usuário');
  ComboBox5.Items.Add('Nome do usuario');
  end
else if ComboBox1.ItemIndex = 2 then // Usuários
  begin
  ComboBox3.Enabled := true;
  ComboBox4.Enabled := true;
  ComboBox5.Enabled := true;
  ComboBox6.Enabled := true;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  ComboBox3.Items.Add('Código do usuario');
  ComboBox5.Items.Add('Usuário remoto');
  end
else if ComboBox1.ItemIndex = 3 then // Usuários por relatórios
  begin
  ComboBox3.Enabled := true;
  ComboBox4.Enabled := true;
  ComboBox5.Enabled := true;
  ComboBox6.Enabled := true;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  ComboBox3.Items.Add('Código do usuario');
  ComboBox5.Items.Add('Código do relatório');
  end;
end;

end.
