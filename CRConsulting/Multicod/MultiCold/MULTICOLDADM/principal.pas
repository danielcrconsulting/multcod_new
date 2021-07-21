unit principal;

// Versão 3.0.0.5 - Adicionado um esquema de coleta de diretório para o XP e outro para Vista e acima
//                - Retirei a reiniciaização da query do grid para manter o foco na ultima linha selecionada
//                - Modifiquei o funcionamento do VertScroll bar do grig para fazer tracking

// Versão 3.0.1.0 - Correção da deleção na tabela DestinosDFN
//                - Correção da carga inicial de dados para Destinos
//                - Atualização dos dados da tabela pai após deleção ou atualização dos dados de DestinosDFN
//                - Atualização dos dados da tabela pai após deleção ou atualização dos dados de IndicesDFN
// Versão 3.0.2.0 - Edição na DFN -> não zera os campos ao dar erro
//                  Descrição do relatório agora tem 120 posições -> necessita alterar o BD
//                  Ao salvar os Dados novos aparecem imediatamente do grig principal
// Versão 3.1.0.0 - Coloquei o carrega grid no onShow do fGrade!!!
//                - Correção de erro de Update do SubGrupo
//                - Log de Acesso e Protocolo com seleção de range de datas
//                - Grid de Log e protocolo com Alinhamento alClient
//                - Para usar a tabela dfn do banco multicold, o programa pega o nome do banco da propriedade
//                - defaultDatabase tornando possivel que o cliente use nomes próprios internos
// Versão 3.1.0.1 - Uso do nome do banco pela propriedade
//                - defaultDatabase tornando possivel que o cliente use nomes próprios internos -
//                - Alteração para os bancos de Evonto e Log
// Versão 3.1.0.2 - Ops! Reabrir a tPesquisa resseta o Grid e as colunas visible=false voltam a visible=true
//                - Então as senhas de usuário votaram a ser mostradas indevidamente
// Versão 3.1.0.3 - Na inserção dos dados de um extrator, a rotina fazia uma limpeza no "possível" registro
//                - anterior existente. Comentei este código porque acabava ficando só um registro na tabela
// Versão 3.1.0.4 - Melhorias na inserção, update e deleção dos dados de um extrator, o diretório explícito
//                - estava invertido
// Versão 3.1.0.5 - Correção dos atributos de montagem do grid
//                - Havia problemas no 'True' para o show em mapa de nomes e auxiliar numérico
// Versão 3.1.0.6 - Correção do MAPA DE CARACTERES. Faltava o caractere 255 no BD. Criei a coluna CARACTEREENTRADA
//                - Acertei a gravação dos dados
// Versão 3.1.0.7 - Liberação das DFNs com sistema e grupo automáticos
//                - Acertei o posicionamento no grid principal, mantendo-o no registro escolhido para edição
// Versão 3.1.0.8 - Em FormGrade tPesquisa.Refresh estava gerando uma mensagem de erro. Troquei por .CLose e .Open e resolveu
// Versão 3.1.0.9 - Liberei salvar Org = -1 sem marcar a opção OrgAutomático, desde que sistema automático esteja selecionado

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, System.UITypes;

type
  TfPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    Arquivo1: TMenuItem;
    Mscaradecampos1: TMenuItem;
    Sair1: TMenuItem;
    Relacionamentos1: TMenuItem;
    MscaradecamposxUsurios1: TMenuItem;
    Mapadenomes1: TMenuItem;
    Extrator1: TMenuItem;
    DestinosDFN1: TMenuItem;
    Relatrios1: TMenuItem;
    ndicesDFN1: TMenuItem;
    MovimentoparaCD1: TMenuItem;
    N4: TMenuItem;
    Hierarquia1: TMenuItem;
    Auxiliarnumrico1: TMenuItem;
    Auxiliaralfanumrico1: TMenuItem;
    GruposDFN1: TMenuItem;
    SubgruposDFN1: TMenuItem;
    N5: TMenuItem;
    Usurios1: TMenuItem;
    Gruposdeusurios1: TMenuItem;
    Usurios2: TMenuItem;
    Usuriosporgruposdeusurios1: TMenuItem;
    Usuriosporrelatrios1: TMenuItem;
    Gruposdeusuriosporrelatrios1: TMenuItem;
    Sistema1: TMenuItem;
    DFN1: TMenuItem;
    Relatrios2: TMenuItem;
    Logdeacesso1: TMenuItem;
    N1: TMenuItem;
    Configuraes1: TMenuItem;
    N2: TMenuItem;
    Editor1: TMenuItem;
    Auxiliardesistemaautomtico1: TMenuItem;
    Protocolo1: TMenuItem;
    Usurios3: TMenuItem;
    Heranadepermisso1: TMenuItem;
    N3: TMenuItem;
    Auxilires1: TMenuItem;
    N6: TMenuItem;
    Limpeza1: TMenuItem;
    GruposdeusuriosporrelatriosII1: TMenuItem;
    DFNscomproblema1: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure Mscaradecampos1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MscaradecamposxUsurios1Click(Sender: TObject);
    procedure Mapadenomes1Click(Sender: TObject);
    procedure Extrator1Click(Sender: TObject);
    procedure DestinosDFN1Click(Sender: TObject);
    procedure ndicesDFN1Click(Sender: TObject);
    procedure MovimentoparaCD1Click(Sender: TObject);
    procedure Auxiliarnumrico1Click(Sender: TObject);
    procedure Auxiliaralfanumrico1Click(Sender: TObject);
    procedure SubgruposDFN1Click(Sender: TObject);
    procedure GruposDFN1Click(Sender: TObject);
    procedure Usurios2Click(Sender: TObject);
    procedure Gruposdeusurios1Click(Sender: TObject);
    procedure Usuriosporgruposdeusurios1Click(Sender: TObject);
    procedure Usuriosporrelatrios1Click(Sender: TObject);
    procedure Gruposdeusuriosporrelatrios1Click(Sender: TObject);
    procedure Sistema1Click(Sender: TObject);
    procedure DFN1Click(Sender: TObject);
    procedure Logdeacesso1Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure Editor1Click(Sender: TObject);
    procedure Auxiliardesistemaautomtico1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Protocolo1Click(Sender: TObject);
    procedure Usurios3Click(Sender: TObject);
    procedure Heranadepermisso1Click(Sender: TObject);
    procedure Limpeza1Click(Sender: TObject);
    procedure GruposdeusuriosporrelatriosII1Click(Sender: TObject);
    procedure DFNscomproblema1Click(Sender: TObject);
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
  nomeDoUsuarioDaSessao,
  DataI,
  DataF : string;
  tDataI,
  tDataF : TDateTime;
  DataIp,
  DataFp : string;
  tDataIp,
  tDataFp : TDateTime;

implementation

uses mascaraCampos, dataModule, mascaraUsuarios, formGrade, mapaDeNomes,
  extrator, destinosDfn, indicesDfn, movtoCD, gruposAuxNumDfn,
  gruposAuxAlfaDfn, subGruposDfn, gruposDfn, usuarios, grupoUsuarios,
  usuariosEGrupos, usurel, grupoRel, grupoRelNovo, sistema, dfn, fEvento_Visu, programa,
  editor, sisAuto, about, login, fProtocolo, relUsuario, heranca, limpeza, DfnComProbU;

{$R *.dfm}

procedure TfPrincipal.Sair1Click(Sender: TObject);
begin
fPrincipal.Close;
end;

procedure TfPrincipal.Mscaradecampos1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,6);
setLength(arrMostraColuna,6);
arrNomeColuna[0] := 'Código do relatório';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Nome do campo';
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Linha inicial da máscara';
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Linha final da máscara';
arrMostraColuna[3] := 'true';
arrNomeColuna[4] := 'Coluna inicial da máscara';
arrMostraColuna[4] := 'true';
arrNomeColuna[5] := 'Tamanho da máscara';
arrMostraColuna[5] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODREL,NOMECAMPO,LINHAI,LINHAF,COLUNA,TAMANHO FROM MASCARACAMPO ';
fGrade.titulo := 'Máscaras de campos';
fGrade.tabela := repositorioDeDados.QueryGrade;
fMascaraCampos.tabela := fGrade.tabela;
fGrade.formulario := fMascaraCampos;
//fGrade.CarregaGrid;             // 18/09/2013 - Coloquei o carrega grid no onShow do fGrade!!!
fGrade.ShowModal;
end;

procedure TfPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
repositorioDeDados.dbMulticold.Close;
repositorioDeDados.dbMulticoldEvento.Close;
application.Terminate;
end;

procedure TfPrincipal.MscaradecamposxUsurios1Click(Sender: TObject);
begin
//fGrade.titulo := 'Relacionamento entre usuários e máscaras';
//fGrade.tabela := repositorioDeDados.tUsuarioMascara;
//fMascaraUsuarios.tabela := fGrade.tabela;
//fGrade.formulario := fMascaraUsuarios;
//fGrade.ShowModal;
//repositorioDeDados.tUsuarioMascara.Close;
fMascaraUsuarios.ShowModal;
end;

procedure TfPrincipal.Mapadenomes1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,3);
setLength(arrMostraColuna,3);
arrNomeColuna[0] := 'Nome original';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Novo nome';
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Novo diretório de saída';
arrMostraColuna[2] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT NOMEORIGINAL,NOVONOME,NOVODIRSAIDA FROM MAPADENOMES ';
fGrade.titulo := 'Mapa de nomes';
fGrade.tabela := repositorioDeDados.QueryGrade;
fMapaDeNomes.tabela := fGrade.tabela;
fGrade.formulario := fMapaDeNomes;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.Extrator1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,9);
setLength(arrMostraColuna,9);
arrNomeColuna[0] := 'Código do relatório';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'XTR';
arrMostraColuna[3] := 'true';
arrNomeColuna[4] := 'Destino';
arrMostraColuna[4] := 'true';
arrNomeColuna[5] := 'Diretório explícito';
arrMostraColuna[5] := 'true';
arrNomeColuna[6] := 'Operação';
arrMostraColuna[6] := 'true';
arrNomeColuna[7] := 'Sub diretório';
arrMostraColuna[7] := 'true';
arrNomeColuna[8] := 'Arquivo';
arrMostraColuna[8] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODREL,CODSIS,CODGRUPO,XTR,DESTINO,DIREXPL,OPERACAO,SUBDIR,ARQUIVO FROM EXTRATOR ';
fGrade.titulo := 'Extrator';
fGrade.tabela := repositorioDeDados.QueryGrade;
fExtrator.tabela := fGrade.tabela;
fGrade.formulario := fExtrator;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.DestinosDFN1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,9);
setLength(arrMostraColuna,9);
arrNomeColuna[0] := 'Código do relatório';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Destino do relatório';
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Tipo do destino';
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Segurança';
arrMostraColuna[3] := 'true';
arrNomeColuna[4] := 'Quantidade de períodos';
arrMostraColuna[4] := 'true';
arrNomeColuna[5] := 'Tipo de período';
arrMostraColuna[5] := 'true';
arrNomeColuna[6] := 'Usuário';
arrMostraColuna[6] := 'true';
arrNomeColuna[7] := 'Senha';
arrMostraColuna[7] := 'true';
arrNomeColuna[8] := 'Diretório explícito';
arrMostraColuna[8] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODREL,DESTINO,TIPODESTINO,SEGURANCA,QTDPERIODOS,TIPOPERIODO,USUARIO,SENHA,DIREXPL FROM DESTINOSDFN ';
fGrade.titulo := 'Destinos DFN';
fGrade.tabela := repositorioDeDados.queryGrade;
fDestinosDfn.tabela := fGrade.tabela;
fGrade.formulario := fDestinosDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.ndicesDFN1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,14);
setLength(arrMostraColuna,14);
arrNomeColuna[0] := 'Código do relatório';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Nome do campo';
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Linha inicial';
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Linha final';
arrMostraColuna[3] := 'true';
arrNomeColuna[4] := 'Coluna';
arrMostraColuna[4] := 'true';
arrNomeColuna[5] := 'Tamanho';
arrMostraColuna[5] := 'true';
arrNomeColuna[6] := 'Tratamento de brancos';
arrMostraColuna[6] := 'true';
arrNomeColuna[7] := 'Tipo de dado';
arrMostraColuna[7] := 'true';
arrNomeColuna[8] := 'Máscara';
arrMostraColuna[8] := 'true';
arrNomeColuna[9] := 'Caracteres de inclusão';
arrMostraColuna[9] := 'true';
arrNomeColuna[10] := 'Caracteres de exclusão';
arrMostraColuna[10] := 'true';
arrNomeColuna[11] := 'String de inclusão';
arrMostraColuna[11] := 'true';
arrNomeColuna[12] := 'String de exclusão';
arrMostraColuna[12] := 'true';
arrNomeColuna[13] := 'Fusão';
arrMostraColuna[13] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODREL,NOMECAMPO,LINHAI,LINHAF,COLUNA,TAMANHO,BRANCO,TIPO,MASCARA,CHARINC,CHAREXC,STRINC,STREXC,FUSAO FROM INDICESDFN ';
fGrade.titulo := 'Índices DFN';
fGrade.tabela := repositorioDeDados.QueryGrade;
fIndicesDfn.tabela := fGrade.tabela;
fGrade.formulario := fIndicesDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
// repositorioDeDados.tIndicesDfn.Close;                   Romero 18/07/2013
end;

procedure TfPrincipal.MovimentoparaCD1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,5);
setLength(arrMostraColuna,5);
arrNomeColuna[0] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código do reatório';
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Segurança';
arrMostraColuna[3] := 'true';
arrNomeColuna[4] := 'Diretório explicito';
arrMostraColuna[4] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODSIS,CODGRUPO,CODREL,SEGURANCA,DIREXPL FROM RELATOCD ';
fGrade.titulo := 'Movimento para CD';
fGrade.tabela := repositorioDeDados.QueryGrade;
fMovtoCD.tabela := fGrade.tabela;
fGrade.formulario := fMovtoCD;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.Auxiliarnumrico1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,3);
setLength(arrMostraColuna,3);
arrNomeColuna[0] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código auxiliar do '+vpNomeDoGrupo;
arrMostraColuna[2] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODSIS,CODGRUPO,CODAUXGRUPO FROM GRUPOSAUXNUMDFN ';
fGrade.titulo := 'Auxiliares numéricos';
fGrade.tabela := repositorioDeDados.QueryGrade;
fGruposAuxNumDfn.tabela := fGrade.tabela;
fGrade.formulario := fGruposAuxNumDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.Auxiliaralfanumrico1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,3);
setLength(arrMostraColuna,3);
arrNomeColuna[0] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código auxiliar do '+vpNomeDoGrupo;
arrMostraColuna[2] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODSIS,CODGRUPO,CODAUXGRUPO FROM GRUPOSAUXALFADFN ';
fGrade.titulo := 'Auxiliares alfanuméricos';
fGrade.tabela := repositorioDeDados.QueryGrade;
fGruposAuxAlfaDfn.tabela := fGrade.tabela;
fGrade.formulario := fGruposAuxAlfaDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.SubgruposDFN1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,4);
setLength(arrMostraColuna,4);
arrNomeColuna[0] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código do '+vpNomeDoSubGrupo;
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Nome do '+vpNomeDoSubGrupo;
arrMostraColuna[3] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODSIS,CODGRUPO,CODSUBGRUPO,NOMESUBGRUPO FROM SUBGRUPOSDFN ';
fGrade.titulo := vpNomeDoSubGrupo;
fGrade.tabela := repositorioDeDados.QueryGrade;
fSubgruposDfn.tabela := fGrade.tabela;
fGrade.formulario := fSubgruposDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.GruposDFN1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,4);
setLength(arrMostraColuna,4);
arrNomeColuna[0] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código alfa do '+vpNomeDoGrupo;
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Nome do '+vpNomeDoGrupo;
arrMostraColuna[3] := 'true';
fGrade.nomeColuna  := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODSIS,CODGRUPO,CODGRUPOALFA,NOMEGRUPO FROM GRUPOSDFN ';
fGrade.titulo := vpNomeDoGrupo;
fGrade.tabela := repositorioDeDados.QueryGrade;
fGruposDfn.tabela := fGrade.tabela;
fGrade.formulario := fGruposDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.Usurios2Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,4);
setLength(arrMostraColuna,4);
arrNomeColuna[0] := 'Código do usuário';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Senha';
arrMostraColuna[1] := 'false';
arrNomeColuna[2] := 'Remoto';
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Nome';
arrMostraColuna[3] := 'true';
fGrade.nomeColuna  := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODUSUARIO,SENHA,REMOTO,NOME FROM USUARIOS ';
//fGrade.sql := ' SELECT CODUSUARIO,REMOTO,NOME FROM USUARIOS ';
fGrade.titulo := 'Usuários';
fGrade.tabela := repositorioDeDados.QueryGrade;
fUsuarios.tabela := fGrade.tabela;
fGrade.formulario := fUsuarios;
//fGrade.CarregaGrid;
fGrade.ShowModal;
repositorioDeDados.tUsuario.Close;
end;

procedure TfPrincipal.Gruposdeusurios1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,3);
setLength(arrMostraColuna,3);
arrNomeColuna[0] := 'Nome do grupo de usuários';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Descrição do grupo';
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Observação';
arrMostraColuna[2] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT NOMEGRUPOUSUARIO,DESCRGRUPO,OBSERVACAO FROM GRUPOUSUARIOS ';
fGrade.titulo := 'Grupo de usuários';
fGrade.tabela := repositorioDeDados.QueryGrade;
fGrupoUsuarios.tabela := fGrade.tabela;
fGrade.formulario := fGrupoUsuarios;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.Usuriosporgruposdeusurios1Click(Sender: TObject);
begin
//fGrade.titulo := 'Relacionamento de usuários por grupos';
//fGrade.tabela := repositorioDeDados.tUsuariosEGrupos;
//fUsuariosEGrupos.tabela := fGrade.tabela;
//fGrade.formulario := fUsuariosEGrupos;
//fGrade.ShowModal;
//repositorioDeDados.tUsuariosEGrupos.Close;
fUsuariosEGrupos.ShowModal;
end;

procedure TfPrincipal.Usuriosporrelatrios1Click(Sender: TObject);
begin
//fGrade.titulo := 'Relacionamento de relatórios por usuários';
//fGrade.tabela := repositorioDeDados.qUsuRel;
//fUsuRel.tabela := fGrade.tabela;
//fGrade.formulario := fUsuRel;
//fGrade.ShowModal;
//repositorioDeDados.qUsuRel.Close;
fUsuRel.ShowModal;
end;

procedure TfPrincipal.Gruposdeusuriosporrelatrios1Click(Sender: TObject);
begin
//fGrade.titulo := 'Relacionamento de relatórios por grupos de usuários';
//fGrade.tabela := repositorioDeDados.qGrupoRel;
//fGrupoRel.tabela := fGrade.tabela;
//fGrade.formulario := fGrupoRel;
//fGrade.ShowModal;
//repositorioDeDados.qGrupoRel.Close;
fGrupoRel.ShowModal;
end;

procedure TfPrincipal.Sistema1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,2);
setLength(arrMostraColuna,2);
arrNomeColuna[0] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Nome do '+vpNomeDoSistema;
arrMostraColuna[1] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODSIS, NOMESIS FROM SISTEMA ';
fGrade.titulo := vpNomeDoSistema;
fGrade.tabela := repositorioDeDados.QueryGrade;
fSistema.tabela := fGrade.tabela;
fGrade.formulario := fSistema;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.DFN1Click(Sender: TObject);
var
  strSql : String;
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,37);
setLength(arrMostraColuna,37);
arrNomeColuna[0] := 'Código do relatório';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Nome do relatório';
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[3] := 'true';
arrNomeColuna[4] := 'Código do '+vpNomeDoSubGrupo;
arrMostraColuna[4] := 'true';
arrNomeColuna[5] := 'ID Coluna 1';
arrMostraColuna[5] := 'true';
arrNomeColuna[6] := 'ID Linha 1';
arrMostraColuna[6] := 'true';
arrNomeColuna[7] := 'ID String 1';
arrMostraColuna[7] := 'true';
arrNomeColuna[8] := 'ID Coluna 2';
arrMostraColuna[8] := 'true';
arrNomeColuna[9] := 'ID Linha 2';
arrMostraColuna[9] := 'true';
arrNomeColuna[10] := 'ID String 2';
arrMostraColuna[10] := 'true';
arrNomeColuna[11] := 'Diretório de entrada';
arrMostraColuna[11] := 'true';
arrNomeColuna[12] := 'Tipo de quebra';
arrMostraColuna[12] := 'true';
arrNomeColuna[13] := 'Coluna da string de quebra 1';
arrMostraColuna[13] := 'true';
arrNomeColuna[14] := 'String da quebra por string 1';
arrMostraColuna[14] := 'true';
arrNomeColuna[15] := 'Coluna da string de quebra 2';
arrMostraColuna[15] := 'true';
arrNomeColuna[16] := 'String da quebra por string 2';
arrMostraColuna[16] := 'true';
arrNomeColuna[17] := 'Quebra após string';
arrMostraColuna[17] := 'true';
arrNomeColuna[18] := 'Número de linhas para quebra';
arrMostraColuna[18] := 'true';
arrNomeColuna[19] := 'Filtro de caractere';
arrMostraColuna[19] := 'true';
arrNomeColuna[20] := 'Comprime brancos';
arrMostraColuna[20] := 'true';
arrNomeColuna[21] := 'Junção automática';
arrMostraColuna[21] := 'true';
arrNomeColuna[22] := 'Quantidade de páginas a pular';
arrMostraColuna[22] := 'true';
arrNomeColuna[23] := 'Código de grupo automático';
arrMostraColuna[23] := 'true';
arrNomeColuna[24] := 'Coluna do grupo automático';
arrMostraColuna[24] := 'true';
arrNomeColuna[25] := 'Linha do grupo automático';
arrMostraColuna[25] := 'true';
arrNomeColuna[26] := 'Tamanho do grupo automático';
arrMostraColuna[26] := 'true';
arrNomeColuna[27] := 'Tipo do grupo automático';
arrMostraColuna[27] := 'true';
arrNomeColuna[28] := 'Bakup do relatório';
arrMostraColuna[28] := 'true';
arrNomeColuna[29] := 'Subdir automático';
arrMostraColuna[29] := 'true';
arrNomeColuna[30] := 'Status';
arrMostraColuna[30] := 'true';
arrNomeColuna[31] := 'Data de criação';
arrMostraColuna[31] := 'true';
arrNomeColuna[32] := 'Hora da criação';
arrMostraColuna[32] := 'true';
arrNomeColuna[33] := 'Data de alteração';
arrMostraColuna[33] := 'true';
arrNomeColuna[34] := 'Hora da alteração';
arrMostraColuna[34] := 'true';
arrNomeColuna[35] := 'Remover S1';
arrMostraColuna[35] := 'true';
arrNomeColuna[36] := vpNomeDoSistema+' automático';
arrMostraColuna[36] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
strSql := ' SELECT CODREL,NOMEREL,CODSIS,CODGRUPO,CODSUBGRUPO,'+
          ' IDCOLUNA1,IDLINHA1,IDSTRING1,IDCOLUNA2,IDLINHA2,'+
          ' IDSTRING2,DIRENTRA,TIPOQUEBRA,COLQUEBRASTR1,STRQUEBRASTR1,'+
          ' COLQUEBRASTR2,STRQUEBRASTR2,QUEBRAAFTERSTR,'+
          ' NLINHASQUEBRALIN,FILTROCAR,COMPRBRANCOS,JUNCAOAUTOM,'+
          ' QTDPAGSAPULAR,CODGRUPAUTO,COLGRUPAUTO,LINGRUPAUTO,'+
          ' TAMGRUPAUTO,TIPOGRUPAUTO,BACKUPREL,SUBDIRAUTO,STATUS,'+
          ' DTCRIACAO,HRCRIACAO,DTALTERACAO,HRALTERACAO,[REMOVE],'+
          ' SISAUTO FROM DFN ';
fGrade.sql := strSql;
fGrade.titulo := 'DFN';
fGrade.tabela := repositorioDeDados.QueryGrade;
fDfn.tabela := fGrade.tabela;
fGrade.formulario := fDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.Logdeacesso1Click(Sender: TObject);
begin
if not inputQuery('Data inicial no log','Informe a data inicial para seleção (dd/mm/aaaa)',DataI) then
  exit;
if not inputQuery('Data final no log','Informe a data final para seleção (dd/mm/aaaa)',DataF) then
  exit;
fEventosVisu.ComboBox1Change(Sender);
fEventosVisu.ShowModal();
end;

procedure TfPrincipal.Configuraes1Click(Sender: TObject);
begin
fConfiguracao.ShowModal;
end;

procedure TfPrincipal.Editor1Click(Sender: TObject);
begin
fEditor.showModal;
end;

procedure TfPrincipal.Auxiliardesistemaautomtico1Click(Sender: TObject);
begin
if repositorioDeDados.QueryGrade.Active then
  repositorioDeDados.QueryGrade.Close;
repositorioDeDados.QueryGrade.Filtered := false;
repositorioDeDados.QueryGrade.Filter := '';
setLength(arrNomeColuna,8);
setLength(arrMostraColuna,8);
arrNomeColuna[0] := 'Código do relatório';
arrMostraColuna[0] := 'true';
arrNomeColuna[1] := 'Código do '+vpNomeDoSistema;
arrMostraColuna[1] := 'true';
arrNomeColuna[2] := 'Código do '+vpNomeDoGrupo;
arrMostraColuna[2] := 'true';
arrNomeColuna[3] := 'Linha inicial';
arrMostraColuna[3] := 'true';
arrNomeColuna[4] := 'Linha final';
arrMostraColuna[4] := 'true';
arrNomeColuna[5] := 'Coluna';
arrMostraColuna[5] := 'true';
arrNomeColuna[6] := 'Tipo';
arrMostraColuna[6] := 'true';
arrNomeColuna[7] := 'Código auxiliar';
arrMostraColuna[7] := 'true';
fGrade.nomeColuna := arrNomeColuna;
fGrade.mostraColuna := arrMostraColuna;
fGrade.sql := ' SELECT CODREL,CODSIS,CODGRUPO,LINI,LINF,COL,TIPO,CODAUX FROM SISAUXDFN ';
fGrade.titulo := vpNomeDoSistema+'(s) auxiliares para relatórios';
fGrade.tabela := repositorioDeDados.QueryGrade;
fSisAuxDfn.tabela := fGrade.tabela;
fGrade.formulario := fSisAuxDfn;
//fGrade.CarregaGrid;
fGrade.ShowModal;
end;

procedure TfPrincipal.Sobre1Click(Sender: TObject);
begin
aboutBox.showModal;
end;

procedure TfPrincipal.FormShow(Sender: TObject);
begin
GruposDFN1.Caption := vpNomeDoGrupo+' ...';
SubGruposDFN1.Caption := vpNomeDoSubGrupo+' ...';
Sistema1.Caption := vpNomeDoSistema+' ...';
Auxiliardesistemaautomtico1.Caption := 'Auxiliares de '+vpNomeDoSistema+' automáticos ...';
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  try
    Application.CreateForm(TrepositorioDeDados, repositorioDeDados);
  finally

  end;
  Application.CreateForm(TfLogin, fLogin);
  fLogin.showModal;
  fLogin.Free;
end;

procedure TfPrincipal.Protocolo1Click(Sender: TObject);
begin

if not inputQuery('Data inicial no protocolo','Informe a data inicial para seleção (dd/mm/aaaa)',DataIp) then
  exit;
if not inputQuery('Data final no protocolo','Informe a data final para seleção (dd/mm/aaaa)',DataFp) then
  exit;

if DataIp = '' then
   begin
   messageDlg('Falta informar a data inicial. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
   exit;
   end;
try
  tDataIp := EncodeDate(strToInt(copy(DataIp,7,4)), strToInt(copy(DataIp,4,2)), strToInt(copy(DataIp,1,2)));
except
  on e:exception do
    begin
    messageDlg('A data inicial informada não é uma data válida. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
    exit;
    end;
end;

if DataFp = '' then
   begin
   messageDlg('Falta informar a data final. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
   exit;
   end;
try
  tDataFp := EncodeDate(strToInt(copy(DataFp,7,4)), strToInt(copy(DataFp,4,2)), strToInt(copy(DataFp,1,2)));
except
  on e:exception do
    begin
    messageDlg('A data final informada não é uma data válida. Entre uma data válida e tente novamente.',mtError,[mbOk],0);
    exit;
    end;
end;

repositorioDeDados.logQuery.SQL.Clear;
repositorioDeDados.logQuery.SQL.Add(' SELECT * FROM PROTOCOLO ');
repositorioDeDados.logQuery.SQL.Add(' WHERE DTFIMPROC >= :A01 ');
repositorioDeDados.logQuery.SQL.Add(' AND DTFIMPROC <= :A02 ');
repositorioDeDados.logQuery.SQL.Add(' ORDER BY 1 ');

repositorioDeDados.logQuery.Parameters[0].Value := tDataIp;
repositorioDeDados.logQuery.Parameters[1].Value := tDataFp;

repositorioDeDados.logQuery.Open;
fProtocol.ShowModal();
repositorioDeDados.logQuery.Close;
end;

procedure TfPrincipal.Usurios3Click(Sender: TObject);
begin
fRelUsuario.showModal;
end;

procedure TfPrincipal.Heranadepermisso1Click(Sender: TObject);
begin
fHeranca.ShowModal;
end;

procedure TfPrincipal.Limpeza1Click(Sender: TObject);
begin
fLimpeza.showModal;
end;

procedure TfPrincipal.GruposdeusuriosporrelatriosII1Click(Sender: TObject);
begin
fGrupoRelNovo.ShowModal;
end;

procedure TfPrincipal.DFNscomproblema1Click(Sender: TObject);
begin
Form1.ShowModal;
end;

Begin
DataI := '';
DataF := '';
DataIp := '';
DataFp := '';
end.

