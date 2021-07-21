unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, ADODB;

type
  TfrmPrincipal = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    ADOConnection1: TADOConnection;
    ADOCommand1: TADOCommand;
    ADOQuery1: TADOQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses dbCnfg;

{$R *.dfm}

procedure TfrmPrincipal.Button1Click(Sender: TObject);
var
  strSql : string;
  errNo : integer;

  function rodaSql:boolean;
  begin
  result := true;
  inc(errNo);
  AdoCommand1.CommandText := strSql;
  try
    AdoCommand1.Execute;
  except
    on e:exception do
      begin
      messageDlg('Erro executando comando de banco de dados.'+'Detalhes: '+e.Message, mtError, [mbOk], 0);
      memo1.lines.Add('Erro no banco de dados nº '+formatFloat('000',errNo));
      adoConnection1.RollbackTrans;
      result := false;
      end;
  end; // try
  end;

  function rodaQuery:boolean;
  begin
  result := true;
  inc(errNo);
  try
    adoQuery1.ExecSQL;
  except
    on e:exception do
      begin
      memo1.lines.Add('Erro no banco de dados nº '+formatFloat('000',errNo));
      messageDlg('Erro gravando no banco de dados.'+'Detalhes: '+e.Message, mtError, [mbOk], 0);
      adoConnection1.RollbackTrans;
      result := false;
      end;
  end; // try
  end;
begin

memo1.Lines.Clear;
Button1.Enabled := false;
Button2.Enabled := false;

try
  frmDbCnfg.ShowModal;
  if not adoConnection1.Connected then
    begin
    memo1.lines.add('Erro na conexão com o banco de dados... configuração cancelada.');
    exit;
    end;
  memo1.lines.Add('Iniciando configuração...');
  memo1.lines.Add('');
  memo1.lines.Add('Criando banco de dados...');
  memo1.lines.Add('');
  memo1.lines.Add('Gerando DB Multicold...');
  memo1.lines.Add('');
  AdoConnection1.BeginTrans;
  errNo := 0;
  strSql := 'IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N''Multicold'')'+
            '	 DROP DATABASE [Multicold]';
  if not rodaSql then
    exit;
  strSql := 'CREATE DATABASE [Multicold] ON (NAME = N''multicold_Data'', FILENAME = N'''+frmDbCnfg.Edit4.Text+'Multicold_Data.MDF'', SIZE = 10, FILEGROWTH = 10%) '+
            'LOG ON (NAME = N''Multicold_Log'', FILENAME = N'''+frmDbCnfg.Edit4.Text+'Multicold_Log.LDF'' , SIZE = 10, FILEGROWTH = 10%) ';
  if not rodaSql then
    exit;
  memo1.lines.Add('Salvando alterações');
  memo1.lines.Add('');
  if AdoConnection1.InTransaction then
    AdoConnection1.CommitTrans;
  memo1.lines.Add('Gerando DB Multicold_Evento...');
  memo1.lines.Add('');
  AdoConnection1.BeginTrans;
  strSql := 'IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N''Multicold_Evento'')'+
            '	 DROP DATABASE [Multicold_Evento]';
  if not rodaSql then
    exit;
  strSql := 'CREATE DATABASE [Multicold_Evento] ON (NAME = N''multicold_Evento_Data'', FILENAME = N'''+frmDbCnfg.Edit4.Text+'Multicold_Evento_Data.MDF'', SIZE = 10, FILEGROWTH = 10%) '+
            'LOG ON (NAME = N''Multicold_Evento_Log'', FILENAME = N'''+frmDbCnfg.Edit4.Text+'Multicold_Evento_Log.LDF'' , SIZE = 10, FILEGROWTH = 10%) ';
  if not rodaSql then
    exit;
  memo1.lines.Add('Salvando alterações');
  memo1.lines.Add('');
  if AdoConnection1.InTransaction then
    AdoConnection1.CommitTrans;
  memo1.lines.Add('Gerando DB Multicold_Log...');
  memo1.lines.Add('');
  AdoConnection1.BeginTrans;
  strSql := 'IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N''Multicold_Log'')'+
            '	 DROP DATABASE [Multicold_Log]';
  if not rodaSql then
    exit;
  strSql := 'CREATE DATABASE [Multicold_Log] ON (NAME = N''multicold_Log_Data'', FILENAME = N'''+frmDbCnfg.Edit4.Text+'Multicold_Log_Data.MDF'', SIZE = 10, FILEGROWTH = 10%) '+
            'LOG ON (NAME = N''Multicold_Log_Log'', FILENAME = N'''+frmDbCnfg.Edit4.Text+'Multicold_Log_Log.LDF'' , SIZE = 10, FILEGROWTH = 10%) ';
  if not rodaSql then
    exit;
  memo1.lines.Add('Salvando alterações');
  memo1.lines.Add('');
  if AdoConnection1.InTransaction then
    AdoConnection1.CommitTrans;
  AdoConnection1.Close;
  memo1.lines.Add('Conectando ao banco de dados do Multicold');
  memo1.lines.Add('');
  adoConnection1.ConnectionString := 'Provider=SQLOLEDB.1;'+
                                     'Password='+frmDbCnfg.Edit3.Text+';'+
                                     'Persist Security Info=False;'+
                                     'User ID='+frmDbCnfg.Edit2.Text+';'+
                                     'Initial Catalog=Multicold;'+
                                     'Data Source='+frmDbCnfg.Edit1.Text+';';
  try
    AdoConnection1.Open;
  except
    on e:exception do
      begin
      messageDlg('Erro conectando ao banco de dados.'+'Detalhes do erro: '+e.Message, mtError, [mbOk], 0);
      exit;
      end;
  end;
  AdoConnection1.BeginTrans;
  memo1.lines.Add('Criando objetos do banco de dados do Multicold');
  memo1.lines.Add('');
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__COMENTARI__CODRE__3D5E1FD2]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[COMENTARIOSBIN] DROP CONSTRAINT FK__COMENTARI__CODRE__3D5E1FD2';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__COMENTARI__CODRE__3F466844]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[COMENTARIOSTXT] DROP CONSTRAINT FK__COMENTARI__CODRE__3F466844';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__DESTINOSD__CODRE__4222D4EF]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[DESTINOSDFN] DROP CONSTRAINT FK__DESTINOSD__CODRE__4222D4EF';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__EXTRATOR__CODREL__45F365D3]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[EXTRATOR] DROP CONSTRAINT FK__EXTRATOR__CODREL__45F365D3';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__GRUPOREL__CODREL__48CFD27E]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[GRUPOREL] DROP CONSTRAINT FK__GRUPOREL__CODREL__48CFD27E';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__INDICESDF__CODRE__4CA06362]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[INDICESDFN] DROP CONSTRAINT FK__INDICESDF__CODRE__4CA06362';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__MASCARACA__CODRE__4D94879B]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[MASCARACAMPO] DROP CONSTRAINT FK__MASCARACA__CODRE__4D94879B';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__RELATOCD__CODREL__5070F446]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[RELATOCD] DROP CONSTRAINT FK__RELATOCD__CODREL__5070F446';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUARIOMA__CODRE__52593CB8]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUARIOMASCARA] DROP CONSTRAINT FK__USUARIOMA__CODRE__52593CB8';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUREL__CODREL__59063A47]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUREL] DROP CONSTRAINT FK__USUREL__CODREL__59063A47';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__EXTRATOR__46E78A0C]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[EXTRATOR] DROP CONSTRAINT FK__EXTRATOR__46E78A0C';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__GRUPOSAUXALFADFN__49C3F6B7]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[GRUPOSAUXALFADFN] DROP CONSTRAINT FK__GRUPOSAUXALFADFN__49C3F6B7';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__GRUPOSAUXNUMDFN__4AB81AF0]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[GRUPOSAUXNUMDFN] DROP CONSTRAINT FK__GRUPOSAUXNUMDFN__4AB81AF0';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__RELATOCD__4F7CD00D]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[RELATOCD] DROP CONSTRAINT FK__RELATOCD__4F7CD00D';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__SUBGRUPOSDFN__5165187F]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[SUBGRUPOSDFN] DROP CONSTRAINT FK__SUBGRUPOSDFN__5165187F';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUARIOSE__NOMEG__5441852A]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUARIOSEGRUPOS] DROP CONSTRAINT FK__USUARIOSE__NOMEG__5441852A';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__DFN__CODSIS__4316F928]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[DFN] DROP CONSTRAINT FK__DFN__CODSIS__4316F928';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__EXTRATOR__CODSIS__44FF419A]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[EXTRATOR] DROP CONSTRAINT FK__EXTRATOR__CODSIS__44FF419A';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__GRUPOREL__CODSIS__47DBAE45]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[GRUPOREL] DROP CONSTRAINT FK__GRUPOREL__CODSIS__47DBAE45';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__GRUPOSDFN__CODSI__4BAC3F29]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[GRUPOSDFN] DROP CONSTRAINT FK__GRUPOSDFN__CODSI__4BAC3F29';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUREL__CODSIS__5629CD9C]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUREL] DROP CONSTRAINT FK__USUREL__CODSIS__5629CD9C';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__DFN__440B1D61]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[DFN] DROP CONSTRAINT FK__DFN__440B1D61';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUREL__5812160E]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUREL] DROP CONSTRAINT FK__USUREL__5812160E';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__COMENTARI__CODUS__3E52440B]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[COMENTARIOSBIN] DROP CONSTRAINT FK__COMENTARI__CODUS__3E52440B';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__COMENTARI__CODUS__403A8C7D]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[COMENTARIOSTXT] DROP CONSTRAINT FK__COMENTARI__CODUS__403A8C7D';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUARIOMA__CODUS__534D60F1]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUARIOMASCARA] DROP CONSTRAINT FK__USUARIOMA__CODUS__534D60F1';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUARIOSE__CODUS__5535A963]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUARIOSEGRUPOS] DROP CONSTRAINT FK__USUARIOSE__CODUS__5535A963';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__USUREL__CODUSUAR__571DF1D5]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[USUREL] DROP CONSTRAINT FK__USUREL__CODUSUAR__571DF1D5';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[CAMPOCONSULTA]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[CAMPOCONSULTA]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[CAMPORELATORIO]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[CAMPORELATORIO]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[COMENTARIOSBIN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[COMENTARIOSBIN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[COMENTARIOSTXT]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[COMENTARIOSTXT]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[CONECTOR]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[CONECTOR]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[CONFIGURACAO]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[CONFIGURACAO]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[CONSULTA]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[CONSULTA]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[DESTINOSDFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[DESTINOSDFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[DFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[DFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[EXTRATOR]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[EXTRATOR]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[GRUPOREL]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[GRUPOREL]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[GRUPOSAUXALFADFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[GRUPOSAUXALFADFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[GRUPOSAUXNUMDFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[GRUPOSAUXNUMDFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[GRUPOSDFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[GRUPOSDFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[GRUPOUSUARIOS]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[GRUPOUSUARIOS]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[INDICESDFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[INDICESDFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[MAPACARACTERE]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[MAPACARACTERE]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[MAPADENOMES]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[MAPADENOMES]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[MASCARACAMPO]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[MASCARACAMPO]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[NOMECAMPO]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[NOMECAMPO]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[OPERADOR]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[OPERADOR]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[PAGINARELATORIO]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[PAGINARELATORIO]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[RELATOCD]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[RELATOCD]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[RELATORIO]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[RELATORIO]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[SISAUXDFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[SISAUXDFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[SISTEMA]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[SISTEMA]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[SUBGRUPOSDFN]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[SUBGRUPOSDFN]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[TIPOCAMPO]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[TIPOCAMPO]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[USUARIOMASCARA]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[USUARIOMASCARA]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[USUARIOS]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[USUARIOS]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[USUARIOSEGRUPOS]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[USUARIOSEGRUPOS]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[USUREL]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[USUREL]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[CAMPOCONSULTA] ( '+
  	        '  [CODCAMPOCONSULTA] [int] NOT NULL , '+
  	        '  [CODCONSULTA] [int] NOT NULL , '+
  	        '  [CAMPO] [varchar] (50), '+
  	        '  [OPERADOR] [varchar] (20), '+
  	        '  [VALOR] [varchar] (512), '+
  	        '  [CONECTOR] [varchar] (5) '+
  	        '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[CAMPORELATORIO] ( '+
  	        '  [CODUSUARIO] [varchar] (20) NOT NULL , '+
  	        '  [CAMPO] [varchar] (100) NOT NULL , '+
  	        '  [TIPO] [varchar] (10) NULL , '+
  	        '  [TAMANHO] [int] NULL , '+
  	        '  [COLUNA] [int] NULL '+
  	        '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[COMENTARIOSBIN] ( '+
  	        '  [COMENTARIOID] [int] IDENTITY (1, 1) NOT NULL , '+
  	        '  [CODUSUARIO] [varchar] (20) NULL , '+
  	        '  [CODREL] [varchar] (15) NULL , '+
  	        '  [PATHREL] [char] (255) NULL , '+
  	        '  [FLAGPUBLICO] [char] (1) NULL , '+
  	        '  [PAGINA] [int] NULL , '+
  	        '  [COMENTARIOBIN] [image] NULL '+
  	        '  ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[COMENTARIOSTXT] ( '+
  	        '  [COMENTARIOID] [int] IDENTITY (1, 1) NOT NULL , '+
  	        '  [CODUSUARIO] [varchar] (20) NOT NULL , '+
  	        '  [CODREL] [varchar] (15) NOT NULL , '+
  	        '  [PATHREL] [varchar] (255) NULL , '+
  	        '  [FLAGPUBLICO] [char] (1) NULL , '+
  	        '  [PAGINA] [int] NULL , '+
  	        '  [COMENTARIOTXT] [text] NULL '+
  	        '  ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[CONECTOR] ( '+
            '  [ID] [int] IDENTITY (1, 1) NOT NULL , '+
            '  [CODIGO] [varchar] (50) NULL , '+
            '  [DESCRICAO] [varchar] (50) NULL '+
            '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[CONFIGURACAO] ( '+
            '  [CODUSUARIO] [varchar] (20) NOT NULL , '+
            '  [CAMPOID] [int] NOT NULL , '+
            '  [VALORCAMPO] [varchar] (512) NOT NULL '+
            '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[CONSULTA] ( '+
            '  [CODCONSULTA] [int] IDENTITY (1, 1) NOT NULL , '+
            '  [CODUSUARIO] [varchar] (20) NOT NULL , '+
            '  [DESCRICAO] [varchar] (100) NULL , '+
            '  [PATHRELATORIO] [varchar] (512) NOT NULL , '+
            '  [DATA] [datetime] NOT NULL , '+
            '  [HORA] [datetime] NOT NULL , '+
            '  [SQL] [binary] (1) NULL '+
            '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[DESTINOSDFN] ( '+
            '  [CODREL] [varchar] (15) NOT NULL , '+
            '  [DESTINO] [varchar] (70) NOT NULL , '+
            '  [TIPODESTINO] [varchar] (5) NOT NULL , '+
            '  [SEGURANCA] [char] (1) NOT NULL , '+
            '  [QTDPERIODOS] [int] NULL , '+
            '  [TIPOPERIODO] [char] (1) NULL , '+
            '  [USUARIO] [varchar] (25) NULL , '+
            '  [SENHA] [varchar] (25) NULL , '+
            '  [DIREXPL] [char] (1) NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[DFN] ( '+
            '  [CODREL] [varchar] (15) NOT NULL , '+
            '  [NOMEREL] [varchar] (60) NOT NULL , '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODSUBGRUPO] [int] NOT NULL , '+
            '  [IDCOLUNA1] [int] NOT NULL , '+
            '  [IDLINHA1] [int] NOT NULL , '+
            '  [IDSTRING1] [varchar] (30) NOT NULL , '+
            '  [IDCOLUNA2] [int] NULL , '+
            '  [IDLINHA2] [int] NULL , '+
            '  [IDSTRING2] [varchar] (30)  NULL , '+
            '  [DIRENTRA] [varchar] (50)  NOT NULL , '+
            '  [TIPOQUEBRA] [char] (1)  NOT NULL , '+
            '  [COLQUEBRASTR1] [int] NULL , '+
            '  [STRQUEBRASTR1] [varchar] (30)  NULL , '+
            '  [COLQUEBRASTR2] [int] NULL , '+
            '  [STRQUEBRASTR2] [varchar] (30)  NULL , '+
            '  [QUEBRAAFTERSTR] [char] (1)  NULL , '+
            '  [NLINHASQUEBRALIN] [int] NULL , '+
            '  [FILTROCAR] [char] (1)  NOT NULL , '+
            '  [COMPRBRANCOS] [char] (1)  NOT NULL , '+
            '  [JUNCAOAUTOM] [char] (1)  NOT NULL , '+
            '  [QTDPAGSAPULAR] [int] NOT NULL , '+
            '  [CODGRUPAUTO] [char] (1)  NOT NULL , '+
            '  [COLGRUPAUTO] [int] NULL , '+
            '  [LINGRUPAUTO] [int] NULL , '+
            '  [TAMGRUPAUTO] [int] NULL , '+
            '  [TIPOGRUPAUTO] [char] (1)  NULL , '+
            '  [BACKUPREL] [char] (1)  NULL , '+
            '  [SUBDIRAUTO] [char] (1)  NULL , '+
            '  [STATUS] [char] (1)  NOT NULL , '+
            '  [DTCRIACAO] [datetime] NOT NULL , '+
            '  [HRCRIACAO] [datetime] NOT NULL , '+
            '  [DTALTERACAO] [datetime] NULL , '+
            '  [HRALTERACAO] [datetime] NULL , '+
            '  [REMOVE] [char] (1)  NULL , '+
            '  [SISAUTO] [char] (1)  NULL , '+
            '  [DTULTPROC] [datetime] NULL '+
            '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[EXTRATOR] ( '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [XTR] [varchar] (70)  NOT NULL , '+
            '  [DESTINO] [varchar] (70)  NOT NULL , '+
            '  [DIREXPL] [char] (1)  NOT NULL , '+
            '  [OPERACAO] [char] (1)  NOT NULL , '+
            '  [SUBDIR] [varchar] (15)  NULL , '+
            '  [ARQUIVO] [varchar] (25)  NULL '+
            '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[GRUPOREL] ( '+
            '  [NOMEGRUPOUSUARIO] [varchar] (20)  NOT NULL , '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODSUBGRUPO] [int] NOT NULL , '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [TIPO] [varchar] (3)  NOT NULL '+
            '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[GRUPOSAUXALFADFN] ( '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODAUXGRUPO] [varchar] (132)  NOT NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[GRUPOSAUXNUMDFN] ( '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODAUXGRUPO] [int] NOT NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[GRUPOSDFN] ( '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODGRUPOALFA] [varchar] (15)  NULL , '+
            '  [NOMEGRUPO] [varchar] (30)  NOT NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[GRUPOUSUARIOS] ( '+
            '  [NOMEGRUPOUSUARIO] [varchar] (30)  NOT NULL , '+
            '  [DESCRGRUPO] [varchar] (50)  NULL , '+
            '  [OBSERVACAO] [varchar] (50)  NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[INDICESDFN] ( '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [NOMECAMPO] [varchar] (20)  NOT NULL , '+
            '  [LINHAI] [int] NOT NULL , '+
            '  [LINHAF] [int] NOT NULL , '+
            '  [COLUNA] [int] NOT NULL , '+
            '  [TAMANHO] [int] NOT NULL , '+
            '  [BRANCO] [char] (1)  NOT NULL , '+
            '  [TIPO] [varchar] (2)  NOT NULL , '+
            '  [MASCARA] [varchar] (12)  NULL , '+
            '  [CHARINC] [varchar] (20)  NULL , '+
            '  [CHAREXC] [varchar] (20)  NULL , '+
            '  [STRINC] [varchar] (25)  NULL , '+
            '  [STREXC] [varchar] (25)  NULL , '+
            '  [FUSAO] [int] NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[MAPACARACTERE] ( '+
            '  [CODUSUARIO] [varchar] (20)  NOT NULL , '+
            '  [CODCARACTEREENTRA] [smallint] NOT NULL , '+
            '  [CODCARACTERESAI] [smallint] NULL , '+
            '  [CARACTERESAIDA] [char] (10)  NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[MAPADENOMES] ( '+
            '  [NOMEORIGINAL] [varchar] (25)  NOT NULL , '+
            '  [NOVONOME] [varchar] (25)  NOT NULL , '+
            '  [NOVODIRSAIDA] [varchar] (80)  NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[MASCARACAMPO] ( '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [NOMECAMPO] [varchar] (20)  NOT NULL , '+
            '  [LINHAI] [int] NULL , '+
            '  [LINHAF] [int] NULL , '+
            '  [COLUNA] [int] NULL , '+
            '  [TAMANHO] [int] NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[NOMECAMPO] ( '+
            '  	[CAMPOID] [int] IDENTITY (1, 1) NOT NULL , '+
            '  	[TIPOCAMPOID] [int] NULL , '+
            '  	[NOMECAMPO] [varchar] (512)  NOT NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[OPERADOR] ( '+
            '  	[ID] [int] IDENTITY (1, 1) NOT NULL , '+
            '  	[OPERADOR] [varchar] (20)  NULL , '+
            '  	[DESCRICAO] [varchar] (50)  NULL '+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[PAGINARELATORIO] ( '+
            '  [IDPAGINA] [int] IDENTITY (1, 1) NOT NULL , '+
            '  [PAGATUAL] [int] NOT NULL , '+
            '  [PAGTOTAL] [int] NOT NULL , '+
            '  [ERROSISOP] [varchar] (512)  NULL , '+
            '  [ERROMULTICOLD] [varchar] (512)  NULL , '+
            '  [TEXTO] [binary] (1) NULL , '+
            '  [TEXTOCORRIGIDO] [binary] (1) NULL '+
            '  ) ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[RELATOCD] ( '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [SEGURANCA] [char] (1)  NOT NULL , '+
            '  [DIREXPL] [char] (1)  NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[RELATORIO] ( '+
            '  [CODUSUARIO] [varchar] (20)  NOT NULL , '+
            '  [NOMERELATORIO] [varchar] (100)  NOT NULL , '+
            '  [PATHRELATORIO] [varchar] (512)  NULL , '+
            '  [DATRELATORIO] [datetime] NOT NULL , '+
            '  [HORRELATORIO] [datetime] NOT NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[SISAUXDFN] ( '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [LINI] [int] NOT NULL , '+
            '  [LINF] [int] NOT NULL , '+
            '  [COL] [int] NOT NULL , '+
            '  [TIPO] [char] (1)  NOT NULL , '+
            '  [CODAUX] [varchar] (50)  NOT NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[SISTEMA] ( '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [NOMESIS] [varchar] (100)  NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[SUBGRUPOSDFN] ( '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODSUBGRUPO] [int] NOT NULL , '+
            '  [NOMESUBGRUPO] [varchar] (30)  NOT NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[TIPOCAMPO] ( '+
            '  [TIPOCAMPOID] [int] IDENTITY (1, 1) NOT NULL , '+
            '  [DESCRICAO] [varchar] (20)  NOT NULL , '+
            '  [FORMATACAO] [varchar] (20)  NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[USUARIOMASCARA] ( '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [NOMECAMPO] [varchar] (20)  NOT NULL , '+
            '  [CODUSUARIO] [varchar] (20)  NOT NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[USUARIOS] ( '+
            '  [CODUSUARIO] [varchar] (20)  NOT NULL , '+
            '  [SENHA] [varchar] (10)  NULL , '+
            '  [REMOTO] [char] (1)  NOT NULL , '+
            '  [NOME] [varchar] (100)  NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[USUARIOSEGRUPOS] ( '+
            '  [CODUSUARIO] [varchar] (20)  NOT NULL , '+
            '  [NOMEGRUPOUSUARIO] [varchar] (30)  NOT NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[USUREL] ( '+
            '  [CODUSUARIO] [varchar] (20)  NOT NULL , '+
            '  [CODSIS] [int] NOT NULL , '+
            '  [CODGRUPO] [int] NOT NULL , '+
            '  [CODSUBGRUPO] [int] NOT NULL , '+
            '  [CODREL] [varchar] (15)  NOT NULL , '+
            '  [TIPO] [varchar] (3)  NOT NULL '+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[CONFIGURACAO] WITH NOCHECK ADD '+
            '   PRIMARY KEY  CLUSTERED '+
            '  ( '+
            '    [CODUSUARIO], '+
            '    [CAMPOID] '+
            '  )  ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[NOMECAMPO] WITH NOCHECK ADD '+
            '   PRIMARY KEY  CLUSTERED '+
            '  ( '+
            '    [CAMPOID] '+
            '  )  ON [PRIMARY] ';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[SISAUXDFN] WITH NOCHECK ADD '+
            '  CONSTRAINT [PK_SisAuxDfn] PRIMARY KEY  CLUSTERED '+
            '  ( '+
            '    [CODREL], '+
            '    [CODSIS], '+
            '    [CODGRUPO], '+
            '    [LINI], '+
            '    [LINF], '+
            '    [COL], '+
            '    [TIPO], '+
            '    [CODAUX] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[CAMPOCONSULTA] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [CODCAMPOCONSULTA], '+
            '    [CODCONSULTA] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[CAMPORELATORIO] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [CODUSUARIO], '+
            '    [CAMPO] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[COMENTARIOSBIN] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [COMENTARIOID] '+
            '  )  ON [PRIMARY] , '+
            '   CHECK ([FLAGPUBLICO] = ''T'' or [FLAGPUBLICO] = ''F'' or [FLAGPUBLICO] = '''') ';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[COMENTARIOSTXT] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [COMENTARIOID] '+
            '  )  ON [PRIMARY] , '+
            '   CHECK ([FLAGPUBLICO] = ''T'' or [FLAGPUBLICO] = ''F'' or [FLAGPUBLICO] = '''') ';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[CONECTOR] WITH NOCHECK ADD '+
            '  CONSTRAINT [PK__CONECTOR__00551192] PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [ID] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[CONSULTA] WITH NOCHECK ADD '+
            '  CONSTRAINT [PK__CONSULTA__0425A276] PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [CODCONSULTA] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[DESTINOSDFN] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [CODREL], '+
            '    [DESTINO] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[DFN] WITH NOCHECK ADD '+
            '  CONSTRAINT [DF__DFN__SISAUTO__2A164134] DEFAULT (''F'') FOR [SISAUTO], '+
            '  CONSTRAINT [DF__DFN__DTULTPROC__2B0A656D] DEFAULT (getdate()) FOR [DTULTPROC], '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [CODREL] '+
            '  )  ON [PRIMARY] , '+
            '   CHECK ([BACKUPREL] = ''F'' or [BACKUPREL] = ''T'' or [BACKUPREL] = ''''), '+
            '   CHECK ([CODGRUPAUTO] = ''F'' or [CODGRUPAUTO] = ''T'' or [CODGRUPAUTO] = ''''), '+
            '   CHECK ([COMPRBRANCOS] = ''F'' or [COMPRBRANCOS] = ''T'' or [COMPRBRANCOS] = ''''), '+
            '   CHECK ([FILTROCAR] = ''F'' or [FILTROCAR] = ''T'' or [FILTROCAR] = ''''), '+
            '   CHECK ([JUNCAOAUTOM] = ''F'' or [JUNCAOAUTOM] = ''T'' or [JUNCAOAUTOM] = ''''), '+
            '   CHECK ([QTDPAGSAPULAR] >= 0), '+
            '   CHECK ([QUEBRAAFTERSTR] = ''F'' or [QUEBRAAFTERSTR] = ''T'' or [QUEBRAAFTERSTR] = '''' or [QUEBRAAFTERSTR] = null), '+
            '   CHECK ([REMOVE] = ''F'' or [REMOVE] = ''T'' or [REMOVE] = ''''), '+
            '   CHECK ([STATUS] = ''A'' or [STATUS] = ''I''), '+
            '   CHECK ([SUBDIRAUTO] = ''F'' or [SUBDIRAUTO] = ''T'' or [SUBDIRAUTO] = '''') ';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[EXTRATOR] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [CODREL], '+
            '    [CODSIS], '+
            '    [CODGRUPO], '+
            '    [XTR] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOREL] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [NOMEGRUPOUSUARIO], '+
            '    [CODSIS], '+
            '    [CODGRUPO], '+
            '    [CODSUBGRUPO], '+
            '    [CODREL] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOSAUXALFADFN] WITH NOCHECK ADD '+
            '   PRIMARY KEY  NONCLUSTERED '+
            '  ( '+
            '    [CODSIS], '+
            '    [CODGRUPO], '+
            '    [CODAUXGRUPO] '+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOSAUXNUMDFN] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODAUXGRUPO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOSDFN] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOUSUARIOS] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [NOMEGRUPOUSUARIO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[INDICESDFN] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODREL],'+
            '    [NOMECAMPO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[MAPACARACTERE] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODUSUARIO],'+
            '    [CODCARACTEREENTRA]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[MAPADENOMES] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [NOMEORIGINAL]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[MASCARACAMPO] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODREL],'+
            '    [NOMECAMPO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[OPERADOR] WITH NOCHECK ADD'+
            '  CONSTRAINT [PK__OPERADOR__286302EC] PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [ID]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[PAGINARELATORIO] WITH NOCHECK ADD'+
            '  CONSTRAINT [PK__PAGINARELATORIO__2A4B4B5E] PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [IDPAGINA]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[RELATOCD] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODREL]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[RELATORIO] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODUSUARIO],'+
            '    [NOMERELATORIO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[SISTEMA] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODSIS]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[SUBGRUPOSDFN] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODSUBGRUPO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[TIPOCAMPO] WITH NOCHECK ADD'+
            '  CONSTRAINT [PK__TIPOCAMPO__33D4B598] PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [TIPOCAMPOID]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[USUARIOMASCARA] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODREL],'+
            '    [NOMECAMPO],'+
            '    [CODUSUARIO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[USUARIOS] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODUSUARIO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[USUARIOSEGRUPOS] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODUSUARIO],'+
            '    [NOMEGRUPOUSUARIO]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[USUREL] WITH NOCHECK ADD'+
            '   PRIMARY KEY  NONCLUSTERED'+
            '  ('+
            '    [CODUSUARIO],'+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODSUBGRUPO],'+
            '    [CODREL]'+
            '  )  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_COMENTARIOSBIN_DFN] ON [dbo].[COMENTARIOSBIN]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_COMENTARIOSBIN_USUARIOS] ON [dbo].[COMENTARIOSBIN]([CODUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_COMENTARIOS_DFN] ON [dbo].[COMENTARIOSTXT]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_COMENTARIOS_USUARIOS] ON [dbo].[COMENTARIOSTXT]([CODUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_DESTINOSDFN_DFN] ON [dbo].[DESTINOSDFN]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_DESTINOSDFN_01] ON [dbo].[DESTINOSDFN]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_DFN_SISTEMA] ON [dbo].[DFN]([CODSIS]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_DFN_SUBGRUPOSDFN] ON [dbo].[DFN]([CODSIS], [CODGRUPO], [CODSUBGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_DFN_01] ON [dbo].[DFN]([CODSIS], [CODGRUPO], [CODSUBGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_EXTRATOR_DFN] ON [dbo].[EXTRATOR]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_EXTRATOR_GRUPOSDNF] ON [dbo].[EXTRATOR]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_EXTRATOR_SISTEMA] ON [dbo].[EXTRATOR]([CODSIS]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_EXTRATOR_01] ON [dbo].[EXTRATOR]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_EXTRATOR_02] ON [dbo].[EXTRATOR]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_GRUPOREL_DFN] ON [dbo].[GRUPOREL]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_GRUPOREL_SISTEMA] ON [dbo].[GRUPOREL]([CODSIS]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_GRUPOREL_01] ON [dbo].[GRUPOREL]([NOMEGRUPOUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_GRUPOREL_02] ON [dbo].[GRUPOREL]([CODSIS], [CODGRUPO], [CODSUBGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_GRUPOREL_03] ON [dbo].[GRUPOREL]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_GRUPOAUXALFADFN_GRUPOSDFN] ON [dbo].[GRUPOSAUXALFADFN]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_GRUPOAUXALFADFN_01] ON [dbo].[GRUPOSAUXALFADFN]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_GRUPOSAUXNUMDFN_GRUPOSDFN] ON [dbo].[GRUPOSAUXNUMDFN]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_GRUPOAUXNUMDFN_01] ON [dbo].[GRUPOSAUXNUMDFN]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_GRUPOSDFN_SISTEMA] ON [dbo].[GRUPOSDFN]([CODSIS]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_INDICESDFN_DFN] ON [dbo].[INDICESDFN]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_INDICESDFN_01] ON [dbo].[INDICESDFN]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_MASCARACAMPO_DFN] ON [dbo].[MASCARACAMPO]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_RELATOCD_DFN] ON [dbo].[RELATOCD]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_RELATOCD_GRUPOSDFN] ON [dbo].[RELATOCD]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_RELATOCD_01] ON [dbo].[RELATOCD]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_RELATOCD_02] ON [dbo].[RELATOCD]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_SUBGRUPOSDFN_GRUPOSDFN] ON [dbo].[SUBGRUPOSDFN]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_SUBGRUPOSDFN_01] ON [dbo].[SUBGRUPOSDFN]([CODSIS], [CODGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUARIOMASCARA_DFN] ON [dbo].[USUARIOMASCARA]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUARIOMASCARA_USUARIOS] ON [dbo].[USUARIOMASCARA]([CODUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUARIOSEGRUPOS_GRUPOUSU] ON [dbo].[USUARIOSEGRUPOS]([NOMEGRUPOUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUARIOSEGRUPOS_USUARIOS] ON [dbo].[USUARIOSEGRUPOS]([CODUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_USUARIOSEGRUPOS_01] ON [dbo].[USUARIOSEGRUPOS]([CODUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_USUARIOSEGRUPOS_02] ON [dbo].[USUARIOSEGRUPOS]([NOMEGRUPOUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUREL_DFN] ON [dbo].[USUREL]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUREL_SISTEMA] ON [dbo].[USUREL]([CODSIS]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUREL_SUBGRUPOSDFN] ON [dbo].[USUREL]([CODSIS], [CODGRUPO], [CODSUBGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [FK_USUREL_USUARIOS] ON [dbo].[USUREL]([CODUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_USUREL_01] ON [dbo].[USUREL]([CODUSUARIO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_USUREL_02] ON [dbo].[USUREL]([CODSIS], [CODGRUPO], [CODSUBGRUPO]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE  INDEX [IX_USUREL_03] ON [dbo].[USUREL]([CODREL]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[COMENTARIOSBIN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODUSUARIO]'+
            '  ) REFERENCES [dbo].[USUARIOS] ('+
            '    [CODUSUARIO]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[COMENTARIOSTXT] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODUSUARIO]'+
            '  ) REFERENCES [dbo].[USUARIOS] ('+
            '    [CODUSUARIO]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[DESTINOSDFN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[DFN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODSUBGRUPO]'+
            '  ) REFERENCES [dbo].[SUBGRUPOSDFN] ('+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODSUBGRUPO]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS]'+
            '  ) REFERENCES [dbo].[SISTEMA] ('+
            '    [CODSIS]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[EXTRATOR] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  ) REFERENCES [dbo].[GRUPOSDFN] ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS]'+
            '  ) REFERENCES [dbo].[SISTEMA] ('+
            '    [CODSIS]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOREL] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS]'+
            '  ) REFERENCES [dbo].[SISTEMA] ('+
            '    [CODSIS]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOSAUXALFADFN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  ) REFERENCES [dbo].[GRUPOSDFN] ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOSAUXNUMDFN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  ) REFERENCES [dbo].[GRUPOSDFN] ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[GRUPOSDFN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS]'+
            '  ) REFERENCES [dbo].[SISTEMA] ('+
            '    [CODSIS]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[INDICESDFN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[MASCARACAMPO] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[RELATOCD] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  ) REFERENCES [dbo].[GRUPOSDFN] ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[SUBGRUPOSDFN] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  ) REFERENCES [dbo].[GRUPOSDFN] ('+
            '    [CODSIS],'+
            '    [CODGRUPO]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[USUARIOMASCARA] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODUSUARIO]'+
            '  ) REFERENCES [dbo].[USUARIOS] ('+
            '    [CODUSUARIO]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[USUARIOSEGRUPOS] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODUSUARIO]'+
            '  ) REFERENCES [dbo].[USUARIOS] ('+
            '    [CODUSUARIO]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [NOMEGRUPOUSUARIO]'+
            '  ) REFERENCES [dbo].[GRUPOUSUARIOS] ('+
            '    [NOMEGRUPOUSUARIO]'+
            '  )';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[USUREL] ADD'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODSUBGRUPO]'+
            '  ) REFERENCES [dbo].[SUBGRUPOSDFN] ('+
            '    [CODSIS],'+
            '    [CODGRUPO],'+
            '    [CODSUBGRUPO]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODREL]'+
            '  ) REFERENCES [dbo].[DFN] ('+
            '    [CODREL]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODSIS]'+
            '  ) REFERENCES [dbo].[SISTEMA] ('+
            '    [CODSIS]'+
            '  ),'+
            '   FOREIGN KEY'+
            '  ('+
            '    [CODUSUARIO]'+
            '  ) REFERENCES [dbo].[USUARIOS] ('+
            '    [CODUSUARIO]'+
            '  )';
  if not rodaSql then
    exit;
  memo1.lines.Add('Salvando alterações');
  memo1.lines.Add('');
  if AdoConnection1.InTransaction then
    AdoConnection1.CommitTrans;
  memo1.lines.Add('Atualizando dados no banco de dados do Multicold');
  memo1.lines.Add('');
  AdoConnection1.BeginTrans;
  adoQuery1.SQL.clear;
  adoQuery1.SQL.Add('INSERT INTO SISTEMA (CODSIS, NOMESIS) VALUES (:a, :b)');
  adoQuery1.Parameters[0].Value := -999;
  adoQuery1.Parameters[1].Value := 'TODOS';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := -1;
  adoQuery1.Parameters[1].Value := 'AUTOMÁTICO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 1;
  adoQuery1.Parameters[1].Value := 'DEMO';
  if not rodaQuery then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO GRUPOSDFN (CODSIS, CODGRUPO, NOMEGRUPO) VALUES(:a, :b, :c)');
  adoQuery1.Parameters[0].Value := -999;
  adoQuery1.Parameters[1].Value := -999;
  adoQuery1.Parameters[2].Value := 'TODOS';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := -1;
  adoQuery1.Parameters[1].Value := -1;
  adoQuery1.Parameters[2].Value := 'AUTOMÁTICO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 1;
  adoQuery1.Parameters[1].Value := 1;
  adoQuery1.Parameters[2].Value := 'DEMO';
  if not rodaQuery then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO SUBGRUPOSDFN (CODSIS, CODGRUPO, CODSUBGRUPO, NOMESUBGRUPO) VALUES(:a, :b, :c, :d)');
  adoQuery1.Parameters[0].Value := -999;
  adoQuery1.Parameters[1].Value := -999;
  adoQuery1.Parameters[2].Value := -999;
  adoQuery1.Parameters[3].Value := 'TODOS';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 1;
  adoQuery1.Parameters[1].Value := 1;
  adoQuery1.Parameters[2].Value := 1;
  adoQuery1.Parameters[3].Value := 'DEMO';
  if not rodaQuery then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO DFN (');
  adoQuery1.SQL.Add('                 CODREL, NOMEREL, CODSIS, CODGRUPO, CODSUBGRUPO, IDCOLUNA1, IDLINHA1,');
  adoQuery1.SQL.Add('                 IDSTRING1, IDCOLUNA2, IDLINHA2, IDSTRING2, DIRENTRA, TIPOQUEBRA,');
  adoQuery1.SQL.Add('                 COLQUEBRASTR1, STRQUEBRASTR1, COLQUEBRASTR2, STRQUEBRASTR2,');
  adoQuery1.SQL.Add('                 QUEBRAAFTERSTR, NLINHASQUEBRALIN, FILTROCAR, COMPRBRANCOS,');
  adoQuery1.SQL.Add('                 JUNCAOAUTOM, QTDPAGSAPULAR, CODGRUPAUTO, COLGRUPAUTO,');
  adoQuery1.SQL.Add('                 LINGRUPAUTO, TAMGRUPAUTO, TIPOGRUPAUTO, BACKUPREL, SUBDIRAUTO,');
  adoQuery1.SQL.Add('                 STATUS, DTCRIACAO, HRCRIACAO, DTALTERACAO, HRALTERACAO,');
  adoQuery1.SQL.Add('                 [REMOVE], SISAUTO, DTULTPROC)');
  adoQuery1.SQL.Add('VALUES (:a1, :a2, :a3, :a4, :a5, :a6, :a7, :a8, :a9, :a10, :a11, :a12, :a13, :a14, :a15,');
  adoQuery1.SQL.Add('        :a16, :a17, :a18, :a19, :a20, :a21, :a22, :a23, :a24, :a25, :a26, :a27, :a28,');
  adoQuery1.SQL.Add('        :a29, :a30, :a31, :a32, :a33, :a34, :a35, :a36, :a37, :a38)');
  adoQuery1.Parameters[0].Value := '*';
  adoQuery1.Parameters[1].Value := 'TODOS';
  adoQuery1.Parameters[2].Value := -999;
  adoQuery1.Parameters[3].Value := -999;
  adoQuery1.Parameters[4].Value := -999;
  adoQuery1.Parameters[5].Value := 0;
  adoQuery1.Parameters[6].Value := 0;
  adoQuery1.Parameters[7].Value := '0';
  adoQuery1.Parameters[8].Value := 0;
  adoQuery1.Parameters[9].Value := 0;
  adoQuery1.Parameters[10].Value := '0';
  adoQuery1.Parameters[11].Value := 'C:\';
  adoQuery1.Parameters[12].Value := 0;
  adoQuery1.Parameters[13].Value := 0;
  adoQuery1.Parameters[14].Value := 0;
  adoQuery1.Parameters[15].Value := 0;
  adoQuery1.Parameters[16].Value := 0;
  adoQuery1.Parameters[17].Value := 'F';
  adoQuery1.Parameters[18].Value := 0;
  adoQuery1.Parameters[19].Value := 'F';
  adoQuery1.Parameters[20].Value := 'F';
  adoQuery1.Parameters[21].Value := 'F';
  adoQuery1.Parameters[22].Value := 0;
  adoQuery1.Parameters[23].Value := 'F';
  adoQuery1.Parameters[24].Value := 0;
  adoQuery1.Parameters[25].Value := 0;
  adoQuery1.Parameters[26].Value := 0;
  adoQuery1.Parameters[27].Value := 0;
  adoQuery1.Parameters[28].Value := 'F';
  adoQuery1.Parameters[29].Value := 'F';
  adoQuery1.Parameters[30].Value := 'A';
  adoQuery1.Parameters[31].Value := Now;
  adoQuery1.Parameters[32].Value := Now;
  adoQuery1.Parameters[33].Value := Now;
  adoQuery1.Parameters[34].Value := Now;
  adoQuery1.Parameters[35].Value := 'F';
  adoQuery1.Parameters[36].Value := 'F';
  adoQuery1.Parameters[37].Value := Now;
  if not rodaQuery then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO USUARIOS (CODUSUARIO, SENHA, REMOTO, NOME) VALUES (:a, :b, :c, :d) ');
  adoQuery1.Parameters[0].Value := 'ADM';
  adoQuery1.Parameters[1].Value := 'MASTER';
  adoQuery1.Parameters[2].Value := 'S';
  adoQuery1.Parameters[3].Value := 'ADMINISTRADOR DO SISTEMA';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMSEG';
  adoQuery1.Parameters[1].Value := 'ADMSEG';
  adoQuery1.Parameters[2].Value := 'S';
  adoQuery1.Parameters[3].Value := 'ADMINISTRADOR DE SEGURANÇA';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMDFN';
  adoQuery1.Parameters[1].Value := 'ADMDFN';
  adoQuery1.Parameters[2].Value := 'S';
  adoQuery1.Parameters[3].Value := 'ADMINISTRADOR DE RELATÓRIOS';
  if not rodaQuery then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO GRUPOUSUARIOS (NOMEGRUPOUSUARIO, DESCRGRUPO, OBSERVACAO) VALUES (:a, :b, :c)');
  adoQuery1.Parameters[0].Value := 'ADMSIS';
  adoQuery1.Parameters[1].Value := 'ADMINISTRADORES';
  adoQuery1.Parameters[2].Value := '';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMSEG';
  adoQuery1.Parameters[1].Value := 'ADMINISTRADORES DE SEGURANÇA';
  adoQuery1.Parameters[2].Value := '';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMDFN';
  adoQuery1.Parameters[1].Value := 'ADMINISTRADORES DE RELATÓRIOS';
  adoQuery1.Parameters[2].Value := '';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'USUARIOS';
  adoQuery1.Parameters[1].Value := 'USUÁRIOS';
  adoQuery1.Parameters[2].Value := '';
  if not rodaQuery then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO USUARIOSEGRUPOS (CODUSUARIO, NOMEGRUPOUSUARIO) VALUES (:a, :b)');
  adoQuery1.Parameters[0].Value := 'ADM';
  adoQuery1.Parameters[1].Value := 'ADMSIS';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMSEG';
  adoQuery1.Parameters[1].Value := 'ADMSEG';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMDFN';
  adoQuery1.Parameters[1].Value := 'ADMDFN';
  if not rodaQuery then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO USUREL (CODUSUARIO, CODSIS, CODGRUPO, CODSUBGRUPO, CODREL, TIPO) VALUES (:a, :b, :c, :d, :e, :f)');
  adoQuery1.Parameters[0].Value := 'ADM';
  adoQuery1.Parameters[1].Value := -999;
  adoQuery1.Parameters[2].Value := -999;
  adoQuery1.Parameters[3].Value := -999;
  adoQuery1.Parameters[4].Value := '*';
  adoQuery1.Parameters[5].Value := 'INC';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMDFN';
  adoQuery1.Parameters[1].Value := -999;
  adoQuery1.Parameters[2].Value := -999;
  adoQuery1.Parameters[3].Value := -999;
  adoQuery1.Parameters[4].Value := '*';
  adoQuery1.Parameters[5].Value := 'INC';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 'ADMSEG';
  adoQuery1.Parameters[1].Value := -999;
  adoQuery1.Parameters[2].Value := -999;
  adoQuery1.Parameters[3].Value := -999;
  adoQuery1.Parameters[4].Value := '*';
  adoQuery1.Parameters[5].Value := 'INC';
  if not rodaQuery then
    exit;
  memo1.lines.Add('Salvando alterações');
  memo1.lines.Add('');
  if AdoConnection1.InTransaction then
    AdoConnection1.CommitTrans;
  AdoConnection1.Close;
  memo1.lines.Add('Conectando ao banco de dados do Multicold_Evento');
  memo1.lines.Add('');
  adoConnection1.ConnectionString := 'Provider=SQLOLEDB.1;'+
                                     'Password='+frmDbCnfg.Edit3.Text+';'+
                                     'Persist Security Info=False;'+
                                     'User ID='+frmDbCnfg.Edit2.Text+';'+
                                     'Initial Catalog=Multicold_Evento;'+
                                     'Data Source='+frmDbCnfg.Edit1.Text+';';
  try
    AdoConnection1.Open;
  except
    on e:exception do
      begin
      messageDlg('Erro conectando ao banco de dados.'+'Detalhes do erro: '+e.Message, mtError, [mbOk], 0);
      exit;
      end;
  end;
  AdoConnection1.BeginTrans;
  memo1.lines.Add('Criando objetos do banco de dados do Multicold_Evento');
  memo1.lines.Add('');
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__EVENTOS__CODMENS__7F60ED59]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1) '+
            '  ALTER TABLE [dbo].[EVENTOS] DROP CONSTRAINT FK__EVENTOS__CODMENS__7F60ED59';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[FK__EVENTOS_V__CODME__00551192]'') and OBJECTPROPERTY(id, N''IsForeignKey'') = 1)'+
            '  ALTER TABLE [dbo].[EVENTOS_VISU] DROP CONSTRAINT FK__EVENTOS_V__CODME__00551192';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[COMPILA]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[COMPILA]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[EVENTOS]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[EVENTOS]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[EVENTOS_VISU]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[EVENTOS_VISU]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[MENSAGENS]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[MENSAGENS]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[REGISTROS]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[REGISTROS]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[COMPILA] ('+
            '  	[CODREL] [varchar] (15) NOT NULL ,'+
            '  	[CODSIS] [int] NOT NULL ,'+
            '  	[CODGRUPO] [int] NOT NULL ,'+
            '  	[CODSUBGRUPO] [int] NOT NULL ,'+
            '  	[QTDCOMPIL] [int] NULL'+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[EVENTOS] ('+
            '  	[DT] [datetime] NOT NULL ,'+
            '  	[HR] [datetime] NOT NULL ,'+
            '  	[OBJETO] [varchar] (60) NULL ,'+
            '  	[ITEM] [varchar] (60) NULL ,'+
            '  	[CODUSUARIO] [varchar] (20) NULL ,'+
            '  	[CODMENSAGEM] [int] NULL'+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[EVENTOS_VISU] ('+
            '  	[DT] [datetime] NOT NULL ,'+
            '  	[HR] [datetime] NOT NULL ,'+
            '  	[ARQUIVO] [varchar] (70) NULL ,'+
            '  	[DIRETORIO] [varchar] (70) NULL ,'+
            '  	[CODREL] [varchar] (15) NULL ,'+
            '  	[GRUPO] [int] NULL ,'+
            '  	[SUBGRUPO] [int] NULL ,'+
            '  	[CODUSUARIO] [varchar] (20) NULL ,'+
            '  	[NOMEGRUPOUSUARIO] [varchar] (30) NULL ,'+
            '  	[CODMENSAGEM] [int] NULL'+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[MENSAGENS] ('+
            '  	[CODMENSAGEM] [int] NOT NULL ,'+
            '  	[MENSAGEM] [varchar] (255) NULL'+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[REGISTROS] ('+
            '  	[DT] [datetime] NOT NULL ,'+
            '  	[HR] [datetime] NOT NULL ,'+
            '  	[CONTEUDO] [varchar] (2550) NULL'+
            '  ) ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[COMPILA] WITH NOCHECK ADD'+
            '  	 PRIMARY KEY  NONCLUSTERED'+
            '  	('+
            '  		[CODREL]'+
            '  	)  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[EVENTOS] WITH NOCHECK ADD'+
            '  	 PRIMARY KEY  NONCLUSTERED'+
            '  	('+
            '  		[DT],'+
            '  		[HR]'+
            '  	)  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[EVENTOS_VISU] WITH NOCHECK ADD'+
            '  	 PRIMARY KEY  NONCLUSTERED'+
            '  	('+
            '  		[DT],'+
            '  		[HR]'+
            '  	)  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[MENSAGENS] WITH NOCHECK ADD'+
            '  	 PRIMARY KEY  NONCLUSTERED'+
            '  	('+
            '  		[CODMENSAGEM]'+
            '  	)  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[REGISTROS] WITH NOCHECK ADD'+
            '  	 PRIMARY KEY  NONCLUSTERED'+
            '  	('+
            '  		[DT],'+
            '  		[HR]'+
            '  	)  ON [PRIMARY]';
  if not rodaSql then
    exit;
  adoQuery1.SQL.Clear;
  adoQuery1.SQL.Add('INSERT INTO MENSAGENS (CODMENSAGEM, MENSAGEM) VALUES (:a, :b) ');
  adoQuery1.Parameters[0].Value := 1;
  adoQuery1.Parameters[1].Value := 'ABERTURA DE RELATORIO COM SUCESSO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 2;
  adoQuery1.Parameters[1].Value := 'ERRO DE SEEK CODREL';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 3;
  adoQuery1.Parameters[1].Value := 'TENTATIVA DE ABERTURA, ACESSO NEGADO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 4;
  adoQuery1.Parameters[1].Value := 'ABERTURA DE RELATORIO SEM SEGURANCA';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 5;
  adoQuery1.Parameters[1].Value := 'ERRO DE LOGIN';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 6;
  adoQuery1.Parameters[1].Value := 'GRUPO NAO ADMINISTRADOR, LOGIN NEGADO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 7;
  adoQuery1.Parameters[1].Value := 'INICIO DE LIMPEZA';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 8;
  adoQuery1.Parameters[1].Value := 'LOGIN COM SUCESSO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 9;
  adoQuery1.Parameters[1].Value := 'OPERACAO EM TABELA';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 10;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 11;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 12;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 13;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 14;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 15;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 16;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 17;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 18;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 19;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  adoQuery1.Parameters[0].Value := 20;
  adoQuery1.Parameters[1].Value := 'OPERACAO SEM DESCRICAO';
  if not rodaQuery then
    exit;
  memo1.lines.Add('Salvando alterações');
  memo1.lines.Add('');
  if AdoConnection1.InTransaction then
    AdoConnection1.CommitTrans;
  AdoConnection1.Close;
  memo1.lines.Add('Conectando ao banco de dados do Multicold_Log');
  memo1.lines.Add('');
  adoConnection1.ConnectionString := 'Provider=SQLOLEDB.1;'+
                                     'Password='+frmDbCnfg.Edit3.Text+';'+
                                     'Persist Security Info=False;'+
                                     'User ID='+frmDbCnfg.Edit2.Text+';'+
                                     'Initial Catalog=Multicold_Log;'+
                                     'Data Source='+frmDbCnfg.Edit1.Text+';';
  try
    AdoConnection1.Open;
  except
    on e:exception do
      begin
      messageDlg('Erro conectando ao banco de dados.'+'Detalhes do erro: '+e.Message, mtError, [mbOk], 0);
      exit;
      end;
  end;
  AdoConnection1.BeginTrans;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[EVENTOS]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[EVENTOS]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[LOGPROC]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[LOGPROC]';
  if not rodaSql then
    exit;
  strSql := 'if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[protocolo]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)'+
            '  drop table [dbo].[PROTOCOLO]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[EVENTOS] ('+
            '	[SEQUENCIAL] [int] NOT NULL ,'+
            '	[OBJETO] [varchar] (60) NULL ,'+
            '	[ITEM] [varchar] (60) NULL ,'+
            '	[MENSAGEM] [varchar] (255) NULL ,'+
            '	[CODUSUARIO] [varchar] (20) NULL ,'+
            '	[DT] [datetime] NULL ,'+
            '	[HR] [datetime] NULL'+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[LOGPROC] ('+
            '	[SEQUENCIAL] [int] IDENTITY (1, 1) NOT NULL ,'+
            '	[DTLOTE] [datetime] NULL ,'+
            '	[HRLOTE] [datetime] NULL ,'+
            '	[DTPROC] [datetime] NULL ,'+
            '	[HRPROC] [datetime] NULL ,'+
            '	[ARQUIVO] [varchar] (255) NULL ,'+
            '	[MENSAGEM] [varchar] (512) NULL'+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'CREATE TABLE [dbo].[PROTOCOLO] ('+
            '	[SEQUENCIAL] [int] IDENTITY (1, 1) NOT NULL ,'+
            '	[CODREL] [varchar] (15) NULL ,'+
            '	[NOMEREL] [varchar] (60) NULL ,'+
            '	[CODSIS] [int] NULL ,'+
            '	[CODGRUPO] [int] NULL ,'+
            '	[CODSUBGRUPO] [int] NULL ,'+
            '	[CODGRUPOAUTO] [int] NULL ,'+
            '	[ARQUIVO] [varchar] (40) NULL ,'+
            '	[EXTENSAO] [varchar] (25) NULL ,'+
            '	[INDICE] [varchar] (40) NULL ,'+
            '	[DTFIMPROC] [datetime] NULL ,'+
            '	[HRFIMPROC] [datetime] NULL ,'+
            '	[PAGINAS] [int] NULL ,'+
            '	[TAMORI] [int] NULL ,'+
            '	[TAMCMP] [int] NULL ,'+
            '	[TAMIND] [int] NULL ,'+
            '	[TAMEXT] [int] NULL ,'+
            '	[TAMTOT] [int] NULL'+
            ') ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[protocolo] WITH NOCHECK ADD'+
            '	 PRIMARY KEY  CLUSTERED'+
            '	('+
            '		[SEQUENCIAL]'+
            '	)  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[LOGPROC] WITH NOCHECK ADD'+
            '	CONSTRAINT [PK__LOGPROC__78B3EFCA] PRIMARY KEY  NONCLUSTERED'+
            '	('+
            '		[SEQUENCIAL]'+
            '	)  ON [PRIMARY]';
  if not rodaSql then
    exit;
  strSql := 'ALTER TABLE [dbo].[protocolo] WITH NOCHECK ADD'+
            '	CONSTRAINT [DF__protocolo__DTFIM__35BCFE0A] DEFAULT (getdate()) FOR [DTFIMPROC],'+
            '	CONSTRAINT [DF__protocolo__HRFIM__36B12243] DEFAULT (getdate()) FOR [HRFIMPROC]';
  if not rodaSql then
    exit;
  strSql := ' CREATE  INDEX [protocolo_dtfimproc_ix] ON [dbo].[protocolo]([DTFIMPROC]) ON [PRIMARY]';
  if not rodaSql then
    exit;
  memo1.lines.Add('Salvando alterações');
  memo1.lines.Add('');
  if AdoConnection1.InTransaction then
    AdoConnection1.CommitTrans;
  AdoConnection1.Close;
  memo1.lines.Add('Fim da configuração dos bancos de dados');
  memo1.Lines.Add('Criando diretórios da aplicação');
  ForceDirectories(extractFilePath(ParamStr(0))+'Backup');
  ForceDirectories(extractFilePath(ParamStr(0))+'Cd');
  ForceDirectories(extractFilePath(ParamStr(0))+'Mainframe');
  ForceDirectories(extractFilePath(ParamStr(0))+'Origem\Database');
  ForceDirectories(extractFilePath(ParamStr(0))+'Origem\NaoIdentificados');
  ForceDirectories(extractFilePath(ParamStr(0))+'Origem\NaoSeparados');
  ForceDirectories(extractFilePath(ParamStr(0))+'Origem\Temp');
  messageDlg('Fim da configuração.',mtInformation,[mbOk],0);
finally
  Button1.Enabled := true;
  Button2.Enabled := true;
end; // try
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
self.close;
end;

end.
