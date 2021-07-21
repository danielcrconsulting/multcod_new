unit principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Menus, ComCtrls, StdCtrls;

type
  TfPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    N4: TMenuItem;
    Relatrios2: TMenuItem;
    Logdeacesso1: TMenuItem;
    N1: TMenuItem;
    Configuraes1: TMenuItem;
    Protocolo1: TMenuItem;
    Usurios3: TMenuItem;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Sair1Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;
  vpNomeDoSistema,
  vpNomeDoGrupo,
  vpNomeDoSubgrupo : String;
  arrNomeColuna : array of String;
  arrMostraColuna : array of String;
  nomeDoUsuarioDaSessao : string;

implementation

uses dataModule;

{$R *.dfm}

type
  tUsuario = Record
             codUsuario : String;
             end;

  taUsuario = Array of tUsuario;

  tGrupo = record
           Codsis,
           CodGrupo : Integer;
           end;
  taGrupo = Array of tGrupo;

var
  tPesquisa : TAdoQuery;
  aUsuario : taUsuario;
  aGrupo : taGrupo;
  dirEntra,
  dirDestino,
  Linha : string;
  arrRel: Array[1..10000] of string;

procedure deloutros(Memo1: TMemo);
begin
try
  screen.Cursor := crHourGlass;
  with repositorioDeDados do
    begin
    dbMulticold.BeginTrans;

    try

      Memo1.Lines.Add('CAMPOCONSULTA');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM CAMPOCONSULTA');
      Query01.ExecSQL;

      Memo1.Lines.Add('CAMPORELATORIO');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM CAMPORELATORIO');
      Query01.ExecSQL;

      Memo1.Lines.Add('CONECTOR');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM CONECTOR');
      Query01.ExecSQL;

      Memo1.Lines.Add('CONSULTA');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM CONSULTA');
      Query01.ExecSQL;

      Memo1.Lines.Add('MAPACARACTERE');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM MAPACARACTERE');
      Query01.ExecSQL;

      Memo1.Lines.Add('MAPADENOMES');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM MAPADENOMES');
      Query01.ExecSQL;

      Memo1.Lines.Add('OPERADOR');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM OPERADOR');
      Query01.ExecSQL;

      Memo1.Lines.Add('PAGINARELATORIO');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM PAGINARELATORIO');
      Query01.ExecSQL;

      Memo1.Lines.Add('RELATORIO');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM RELATORIO');
      Query01.ExecSQL;

      Memo1.Lines.Add('TIPOCAMPO');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM CONFIGURACAO');
      Query01.ExecSQL;

      Memo1.Lines.Add('NOMECAMPO');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM NOMECAMPO');
      Query01.ExecSQL;

      Memo1.Lines.Add('CONFIGURACAO');
      Query01.SQL.Clear;
      Query01.SQL.Add('DELETE FROM TIPOCAMPO');
      Query01.ExecSQL;

    except
      on e:exception do
        begin
        dbMulticold.RollbackTrans;
        Memo1.Lines.Add('Rolling back fase 1');
        messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
        end;
      end;
    if dbMulticold.InTransaction then
      begin
      Memo1.Lines.Add('Committing fase 1');
      dbMulticold.CommitTrans;
      Memo1.Lines.Add('Fase 1 committed');
      end;
    end;
finally
  screen.Cursor := crDefault;
  end;
end;

procedure delrel(codRel : string);
begin
with repositorioDeDados do
  begin
  try
    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSTXT WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;


    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM COMENTARIOSBIN WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUREL WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM GRUPOREL WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM USUARIOMASCARA WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM MASCARACAMPO WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM INDICESDFN WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DESTINOSDFN WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM EXTRATOR WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM RELATOCD WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM SISAUXDFN WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

    dbMulticold.BeginTrans;
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM DFN WHERE CODREL=:A');
    Query01.Parameters[0].Value := codRel;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

  except
    on e:exception do
      begin
      messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      ShowMessage('Repita a operação de limpeza após o final desta');
      end;
    end;
  end;
end;

procedure delUsu(codUsu, Tabela : string; var Retorno: boolean);
begin
Retorno := True;
with repositorioDeDados do
  begin
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM '+Tabela+' WHERE CODUSUARIO=:A');
    Query01.Parameters[0].DataType := ftString;
//    Query01.Parameters[0].Value := Trim(codUsu);
    Query01.Parameters[0].Value := codUsu;
    Query01.ExecSQL;

  except
    on e:exception do
      begin
      messageDlg('Erro apagando dados.'+#10#13+'Detalhes do erro:'+#10#13+e.Message,mtError,[mbOk],0);
      ShowMessage('Repita a operação de limpeza após o final desta');
      Retorno := False;
      end;
    end;
  end;   // Try
end;  // Procedure

procedure killTheBastards(Tabela : string; i : integer; Memo1: TMemo);
var
  Retorno,
  manterUsu : boolean;
  j : integer;
begin

tPesquisa.SQL.Clear;
tPesquisa.SQL.Add('SELECT DISTINCT CODUSUARIO COLLATE Latin1_General_bin AS CODUSUARIO ');
tPesquisa.SQL.Add('FROM '+Tabela);
tPesquisa.SQL.Add('ORDER BY CODUSUARIO ');

tPesquisa.open;
Retorno := True;

While (Not tPesquisa.Eof) and (Retorno) Do
  begin
  manterUsu := false;
  for j := 0 to i do
    begin
    if Trim(tPesquisa.Fields[0].AsString) = Trim(aUsuario[j].codUsuario) then
      Begin
      manterUsu := true;
      break
      end;
    end;
  if not manterUsu then
    begin
    repositorioDeDados.dbMulticold.BeginTrans;
    Memo1.Lines.Add('Removendo: '+tPesquisa.Fields[0].asString);
    delUsu(tPesquisa.Fields[0].asString, Tabela, Retorno);
    if repositorioDeDados.dbMulticold.InTransaction then
      repositorioDeDados.dbMulticold.CommitTrans;
    end
  else
    Memo1.Lines.Add('Mantendo: '+tPesquisa.Fields[0].asString);

    tPesquisa.Next;
  end;

tPesquisa.Close;
Memo1.Lines.Add('Fim da fase 3');
end;

procedure delGruGru(codSis, codGru : integer; Tabela : string);
begin
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.Clear;
    Query01.SQL.Add('DELETE FROM '+Tabela+' WHERE CODSIS=:A AND CODGRUPO=:B');
    Query01.Parameters[0].Value := codSis;
    Query01.Parameters[1].Value := codGru;
    Query01.ExecSQL;
    if dbMulticold.InTransaction then
      dbMulticold.CommitTrans;

  except
    on e:exception do
      if dbMulticold.InTransaction then
        dbMulticold.CommitTrans;
    end;
  end;
end;

procedure killTheGroups(Tabela : string; i : integer; Memo1: TMemo);
var
  manterDados : boolean;
  j : integer;
begin
tPesquisa.SQL.Clear;
tPesquisa.SQL.Add('SELECT DISTINCT CODSIS, CODGRUPO ');
tPesquisa.SQL.Add('FROM '+Tabela);
tPesquisa.SQL.Add('ORDER BY CODSIS, CODGRUPO ');

tPesquisa.open;

While (Not tPesquisa.Eof) Do
  begin
  manterDados := false;
  for j := 0 to i-1 do
    begin
    if (tPesquisa.Fields[0].AsInteger = aGrupo[j].Codsis) and
       (tPesquisa.Fields[1].AsInteger = aGrupo[j].CodGrupo) then
      Begin
      manterDados := true;
      break
      end;
    end;
{  if not manterDados then                   FAÇAMOS O USUÁRIO INCLUIR NA LISTA...
    begin
    If (tPesquisa.Fields[0].AsInteger = aGrupo[j].Codsis) and
       (tPesquisa.Fields[1].AsInteger = -999) then
      manterDados := true
    else
    If (tPesquisa.Fields[0].AsInteger = -999) and
       (tPesquisa.Fields[1].AsInteger = aGrupo[j].CodGrupo) then
      manterDados := true;
    end;  }
  if not manterDados then
    begin
    Memo1.Lines.Add('Removendo: '+tPesquisa.Fields[0].asString+' '+tPesquisa.Fields[1].asString);
    delGruGru(tPesquisa.Fields[0].asInteger, tPesquisa.Fields[1].asInteger, Tabela);
    end
  else
    Memo1.Lines.Add('Mantendo: '+tPesquisa.Fields[0].asString+' '+tPesquisa.Fields[1].asString);

    tPesquisa.Next;
  end;

tPesquisa.Close;
end;

procedure TfPrincipal.Configuraes1Click(Sender: TObject);
var
  i, j, X, Reps : integer;
  arqRel : System.text;
  manterRel : Boolean;

begin

tPesquisa := TAdoQuery.Create(Self);
tPesquisa.Connection := repositorioDeDados.dbMulticold;

Memo1.Lines.Add('');
Memo1.Lines.Add('Lendo lista de Relatórios a manter na base');

for i := 1 to 10000 do
  arrRel[i] := '';

If OpenDialog1.execute Then
  begin
  AssignFile(arqRel, Opendialog1.FileName);
  reset(arqRel);

  readLn(arqRel, Linha);

  X := strToInt(Linha);

  SetLength(aGrupo, X);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Grupos');
  for i := 0 to strToInt(Linha)-1 do
    Begin
    readLn(arqRel, Linha);

    aGrupo[i].Codsis := strToInt(copy(Linha, 1, pos(' ',Linha)-1));
    delete(Linha, 1, pos(' ', Linha));
    aGrupo[i].CodGrupo := strToInt(Linha);
    Memo1.Lines.Add(intToStr(aGrupo[i].Codsis)+' '+intToStr(aGrupo[i].CodGrupo));
    End;

  readLn(arqRel, dirEntra);
  readLn(arqRel, dirDestino);

  arrRel[1] := '*';                // vamos deixar o rel * por causa dos usuários com definição coringa na usurel
  i := 1;

  while not eof(arqRel) do
    begin
    inc(i);

    readln(arqRel, arrRel[i]);
    Memo1.Lines.Add(arrRel[i]);
    end;

  closefile(arqRel);

  if messageDlg(' Tem certeza que deseja prosseguir com a limpeza? ',mtConfirmation,[mbOk,mbCancel],0)=mrOk then
    begin

    Memo1.Lines.Add('');
    Memo1.Lines.Add(TimeToStr(Now));
    Memo1.Lines.Add('Inicio da limpeza');
    Memo1.Lines.Add('Fase 1 - Tabelas gerais');
    Memo1.Lines.Add('');

    delOutros(Memo1);

    // i contém o número de relatórios na lista...

    screen.Cursor := crHourGlass;

    Reps := 0;

    Repeat

    Memo1.Lines.Add('');
    Memo1.Lines.Add('Fase 2 - DFN e afins');
    Memo1.Lines.Add('');

    tPesquisa.SQL.Clear;
    tPesquisa.SQL.Add('SELECT CODREL FROM DFN ');
    tPesquisa.SQL.Add('ORDER BY CODREL ');
    tPesquisa.SQL.Add('COLLATE Latin1_General_bin ');
    tPesquisa.open;

    While (Not tPesquisa.Eof) Do
      begin
      manterRel := false;
      for j := 1 to i do
        begin
        if tPesquisa.Fields[0].AsString = arrRel[j] then
          begin
          manterRel := true;
          break;
          end;
        end;
      if not manterRel then
        begin
        Memo1.Lines.Add('Removendo: '+tPesquisa.Fields[0].asString);
        delrel(tPesquisa.Fields[0].asString);
        end
      else
        Memo1.Lines.Add('Mantendo: '+tPesquisa.Fields[0].asString);

      tPesquisa.Next;
      end;

    tPesquisa.Close;
    Memo1.Lines.Add('Final de fase 2');

    // Limpeza dos usuários...
    // A tabela mestre será a USUREL, já limpa na fase anterior. Os usuários que estão nesta tabela ficarão nas demais...

    Memo1.Lines.Add('');
    Memo1.Lines.Add('Fase 3 - Usuários');
    Memo1.Lines.Add('');

    tPesquisa.SQL.Clear;
    tPesquisa.SQL.Add('SELECT DISTINCT CODUSUARIO COLLATE Latin1_General_bin AS CODUSUARIO ');
    tPesquisa.SQL.Add('FROM USUREL ');
    tPesquisa.SQL.Add('ORDER BY CODUSUARIO ');

    tPesquisa.open;

    SetLength(aUsuario, tPesquisa.RecordCount);
    i := -1;

    Memo1.Lines.Add('Usuários ativos');
    While Not tPesquisa.Eof Do
      Begin
      Inc(i);
      aUsuario[i].codUsuario := tPesquisa.Fields[0].AsString;
      Memo1.Lines.Add(tPesquisa.Fields[0].asString);
      tPesquisa.Next;
      End;

    tPesquisa.Close;

    Memo1.Lines.Add('Limpando GRUPOUSUARIOS');

    tPesquisa.SQL.Clear;
    tPesquisa.SQL.Add('SELECT NOMEGRUPOUSUARIO FROM GRUPOUSUARIOS ');
    tPesquisa.SQL.Add('ORDER BY NOMEGRUPOUSUARIO ');
    tPesquisa.SQL.Add('COLLATE Latin1_General_bin');
    tPesquisa.open;

    While not tPesquisa.Eof do
      begin
      With repositorioDeDados do
        begin
          try
          dbMulticold.BeginTrans;
          Query01.SQL.Clear;
          Query01.SQL.Add('DELETE FROM GRUPOUSUARIOS WHERE NOMEGRUPOUSUARIO=:A');
          Query01.Parameters[0].Value := tPesquisa.Fields[0].AsString;
          Query01.ExecSQL;
          dbMulticold.CommitTrans;

          except
            on e:exception do
              if dbmulticold.InTransaction then
                dbMulticold.CommitTrans;
          end;
        end;
      tPesquisa.Next;
      end;

    tPesquisa.Close;

    killTheBastards('COMENTARIOSBIN',i, Memo1);
    killTheBastards('COMENTARIOSTXT',i, Memo1);
    killTheBastards('USUARIOMASCARA',i, Memo1);
    killTheBastards('USUARIOSEGRUPOS',i, Memo1);
    killTheBastards('USUARIOS',i, Memo1);

    Memo1.Lines.Add('');
    Memo1.Lines.Add('Fase 4 - Sistemas e Orgs');
    Memo1.Lines.Add('');

    KillTheGroups('GRUPOSAUXALFADFN', X, Memo1);
    KillTheGroups('GRUPOSAUXNUMDFN', X, Memo1);
    KillTheGroups('USUREL', X, Memo1);
    KillTheGroups('SUBGRUPOSDFN', X, Memo1);
    KillTheGroups('GRUPOSDFN', X, Memo1);
    KillTheGroups('GRUPOREL', X, Memo1);
    KillTheGroups('EXTRATOR', X, Memo1);
    KillTheGroups('GRUPOREL', X, Memo1);
    KillTheGroups('RELATOCD', X, Memo1);
    KillTheGroups('SISAUXDFN', X, Memo1);
    KillTheGroups('DFN', X, Memo1);

    With repositorioDeDados do
      begin

      dbMulticold.BeginTrans;
      if dirEntra <> '' then
        try
          Query01.SQL.Clear;
          Query01.SQL.Add('UPDATE DFN SET DIRENTRA=:A');
          Query01.Parameters[0].Value := dirEntra;
          Query01.ExecSQL;

          except
            on e:exception do begin end;
          end;  // Try
      dbMulticold.CommitTrans;

      dbMulticold.BeginTrans;
      if dirDestino <> '' then
        try
          Query01.SQL.Clear;
          Query01.SQL.Add('UPDATE DESTINOSDFN SET DESTINO=:A');
          Query01.Parameters[0].Value := dirDestino;
          Query01.ExecSQL;

          except
            on e:exception do begin end;
          end; // Try
        dbMulticold.CommitTrans;
        
      end; // With

    Memo1.Lines.Add('Limpando SISTEMA');

    tPesquisa.SQL.Clear;
    tPesquisa.SQL.Add('SELECT DISTINCT CODSIS FROM SISTEMA ');
    tPesquisa.SQL.Add('ORDER BY CODSIS ');
    tPesquisa.open;

    While not tPesquisa.Eof do
      begin
      With repositorioDeDados do
        begin
          try
          dbMulticold.BeginTrans;
          Query01.SQL.Clear;
          Query01.SQL.Add('DELETE FROM SISTEMA WHERE CODSIS=:A');
          Query01.Parameters[0].Value := tPesquisa.Fields[0].AsString;
          Query01.ExecSQL;
          dbMulticold.CommitTrans;

          except
            on e:exception do
              if dbmulticold.InTransaction then
                dbMulticold.CommitTrans;
          end;
        end;
      tPesquisa.Next;
      end;

    tPesquisa.Close;

    Inc(Reps);
    Until Reps = 6;

    end; // If

  end;

screen.Cursor := crDefault;
Memo1.Lines.Add('');
Memo1.Lines.Add(TimeToStr(Now));
ShowMessage('Fim de limpeza...');
tPesquisa.Free;

end;

procedure TfPrincipal.Sair1Click(Sender: TObject);
begin
fPrincipal.Close;
end;

end.
