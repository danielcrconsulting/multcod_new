unit Module1;

interface

uses  Classes, Controls, Windows, Variants, ComObj, DB, ADODB, frmMain_, RotGerais, System.Math, IdGlobalProtocols;

const
  cADM = 3;
  cATUALIZA = 2;
  cCONSULTA = 1;
  GERAL = 0;
  PENDENCIA = 1;

// ###############################################################################################
// 
// Histórico

// ====================================================================================
// 21/11/2008 - Alteracoes:

// SCC - Sistema de Conciliação de Contas'
// 
// Criação da opção "Conciliação > Atualizar Conciliação > Junção de Juntados"
// 
// Esta opção foi criada para permitir que se processe na Segunda feira os movimento de Sábado, Domingo e Segunda feira de uma só vez.
// 
// Modo de operação:
// 
// Gerar os movimentos de Sábado, Domingo e Segunda feira
// 
// Juntar os movimentos de Sábado, Domingo e Segunda feira
// 
// Utilizar a opção Junção de Juntados para juntar os 3 movimentos em um único arquivo para ser processado de um só vez.
// 
// O arquivo gerado pela opção Junção de Juntados conterá a última data de movimento, que deve ser a da Segunda feira.

// ====================================================================================
// 18/10/2008 - Alteracoes:
// Criada a funçao para trocar data literal (OUT) por (/10)
// pois alguns relatorios possui este tipo de data

// Alteração das datas para geração de relatórios da dado do dia para
// a data da última alteração

// ====================================================================================
// 16/10/2008 - Alteracoes:
// Criada a tabela para cadastrar os relatorios com data literal (OUT)
// e as respectivas relas de Inclusão, Alteração, Exclusão e Consulta

// ====================================================================================
// 27/09/2008 - Alteracoes:
// Alterada a estrutura tbTipoCon para guardar um
// indice, cd_grupo_con e nm_grupo sem repetir grupos com mesmo nome
// Indice é utilizado para montar o menu
// Para pegar as opções, foi alterado o select para pegar os vários
// códigos com o mesmo nome.

// ====================================================================================
// 07/09/2008 - Alteracoes:
// Campo conta_contabil de 10 para 20 em Atualizacao
// Campo conta_contabil de 6 para 14 na CONCILIACOES
// Campo nome_cliente novo tam=20 na CONCILIACOES

// ====================================================================================
// 07/09/2008 - Alteracoes:
// Criação do cmbOrdena, para ordenar coluna do grid

// ====================================================================================
// 06/09/2008 - Alteracoes:
// Campo Grupo de 2 para 10 e conta_contabil de 6 para 14 em tb_opcao
// Campo cd_grupo MUDOU PARA cd_grupo_con na tb_grupocon
// Campo cd_grupo_con de 2 para 10 na tb_grupocon
// Campo cd_grupo MUDOU PARA cd_grupo_con na tb_tipo_con
// Campo cd_grupo_con de 2 para 10 na tb_tipo_con
// Campo conta_contabil de 6 para 14 na tb_tipo_con
// Campo nome_cliente novo tam=20 na tbContasAdm
// Campo conta_contabil de 6 para 14 na tbContasAdm
// Campo conta_contabil de 6 para 14 em LANCAMENTOS

// ====================================================================================
// 04/09/2008 - Alteracoes:
// Alterações na Atualização Manual (Baixa Banco)
// Alteração nos relatório para maximizar a tela
// Alteração na rotina Monta_Interface para pegar codigo_para apartir
// da conta_contabil

// ====================================================================================
// 03/09/2008 - Alteracoes:
// Bloqueio das opções de menu que o nivel de usuario não
// permite acesso

// ====================================================================================
// 02/09/2008 - Alteracoes:
// Criação do campo PF_PJ na tabela BIN. Sera utilizado para
// gravar no arquivo Interface

// Foi criada a Tabela Interface.
// Foram criadas as rotinas
// Monta_Interface = Monta um array das interfaces cadastradas
// GerarInterface que gera o arquivo txt

// 30/08/2008 - Alteracoes:
// Alterados os relatórios Com Mensagem.
// O campo Mensagem foi substituido pelos campos
// Obs_Deb e Obs_Cred

// ====================================================================================
// 17/08/2008 - Alteracoes:
// Function ContaValida - nao tem ref
// Param.xxx - posicao no arquivo. Testado e aprovado

// Alterações visando a implementação da CONTABILIDADE
// nao tem no banco
// Volta codigo depois
// RsDb.Fields("Cod_Deb") = ctDebito(Indice).conta & "-" & ctDebito(Indice).Ref
// RsDb.Fields("Rel_Deb") = Mid$(Buffer, Param.Relatorio.Posicao, Param.Relatorio.Tamanho)
// RsDb.Fields("Dept_Deb") = Mid$(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho)
// RsDb.Fields("Depto_Deb") = Mid$(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho)
// RsDb.Fields("Moeda_Deb") = Mid$(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho)

// RsDb.Fields("Cod_Cred") = ctCredito(Indice).conta & "-" & ctCredito(Indice).Ref
// RsDb.Fields("Rel_Cred") = Mid$(Buffer, Param.Relatorio.Posicao, Param.Relatorio.Tamanho)
// RsDb.Fields("Dept_Cred") = Mid$(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho)
// RsDb.Fields("Depto_Cred") = Mid$(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho)

// 09/08/2008 - Inicio das alterações para a Fidelity

// Alterar tbContasAdm
// Alterar Coluna Codigo de 4 para 30
// Criar Coluna Codigo_Para (20)

// Criação da tabela Interface, semelhante a Lançamentos

// 09/08/2008 - Inicio das alterações para a Fidelity
// ###############################################################################################
// 
// 14/08/2003 - Inicio das alterações para geração do balancete contábil
// 
// TAREFAS

// 1. Na tabela adm.tbcontasadm criar as colunas Conc e Bal para indicar
// quais código/ref fazem parte da conciliação e quais fazem parte do
// balancete contábil.

// 2. Criar Tela para gerar saldos das contas (GeraMovSaldo) com o objetivo de
// alterar relatório de saldo contábil acrescentando as colunas Saldo Relatório
// Diferenca entre as colunas.

// Obs. Para algumas contas será utilizado o saldo da conciliação pois nem
// todas as contas possuem relatórios de saldo

// 3. Alterar a data do relatório de saldo contábil para a data da
// última atualização. (como no saldo do dia)

// 4. Criar Opções Saldo Atual e Saldo Período (?) no menu Saldo
// Balacente

// 18/08/2002 - Criei a função TestaTemplate para testar a versão do
// template utilizado. Se chamar a DLL MultiExtract para versão
// errada, o programa capota

// 12/08/2002 - Alteração na rotina MontaTabela. Estava destruindo conteúdo
// de variáveis globais. (trocava de cliente...)

// 24/06/2002 - Alteração na opção Novo Cliente para incluir os novos diretório
// Bx_Banco_Cred e Bx_Banco_Deb e o banco Hist_ (Nome do Banco). mdb
// Atualizei o Layout do Empty.mdb .Devia estar desatualizado.
// Coloquei no Make 1.3.1, estava 1.1.0

// 11/06/2002 - ContaCreditoComp e ContaDebitoComp para matar Lancamentos
// em dolar com mesmo valor no mesmo dia - Só fazia para Real

// 20/05/2002 - Criei a função DataDoSistema
// 
// 02/04/2001 - Separação dos Bancos de Dados. Será criado um Banco de Dados Históricos com
// nome Hist_BBBBB onde BBBBB é o nome do Banco de Dados de Produção.
// O Backup do Banco, passara a se chamar Backup Diário e será criado o Backup Mensal onde
// será feita a separação dos banco. Para o Banco Histórico irão todos os lancamentos com
// Saldo Zerado e o banco de Produção manterá os lançamentos em aberto.

// 14/01/2001 - Alteração no Backup do Banco, para deletar os arquivos que contém a data do
// movimento no Nome. Verificar a data de atualização não funcionou em algumas máquinas

// 12/01/2001 - Alteração nas opções de Lançamento Manual: Inclusão - tirei o exit sub após a
// mensagem de que não há dados e Exclusão - testar se eof sair fora

// 06/01/2001 - Alteração Pendente
// Para não baixar lançamentos com * na primeira posição do campo Observação, inserir na string
// de consulta "and instr(1,observacao,'*') <> 1" nas rotinas ContaDebito e ContaCredito.

// 02/01/2001 - Alteração na opção Consulta Banco de Dados para gerar um Banco temporário no
// diretório c:\temp\CC_Temp.bdb para consulta. O motivo desta alteração foi que com a tabela
// original aberta, mesmo para consulta, não era possível fazer BackUp.

// 30/01/2001 - Alteração na Baixa Banco para criar baixas a débito e a crédito. Para isso foram
// criados os sub-diretótios Bx_Banco_Cred e Bx_Banco_Deb, onde deve ficar os arquivos texto com
// os dados para atualização do banco de dados.
// 
// Os arquivos txt gerados são BaixaManualDeb e BaixaManualCred.

// 22/01/2001 - Criação da opção para consulta do Banco de Dados por usuários do nível 1.
// Foi utilizada a tela de Alteração de Lançamento com os botões desabilitados.

// 16/01/2001 - Criação da opção para gerar arquivos EXCELL.
// 
// 09/01/2001 - Criação da tabela Conciliacao no Admin para consultar e gerar relatórios das
// conciliações cadastradas assim com seus templates, códigos e reference numbers.
// Existem duas opções: Geral e por Cliente. A consulta e os Relatórios podem ser Classificados
// por Cliente,Conta Contabil, Código, Relatório Origem, Templates e Observações
// 
// 08/01/2001 - Modificação na rotina isdatavalida para barrar datas futuras.
// 
// 05/01/2001 - A função formatavalor apresentou um problema com valores maiores que 9.999,99,
// cortava a última casa decimal. Eu substitui a função por Cdbl e aparentemente esta tudo bem.
// Por via das dúvidas, os pontos alterados estão com a data da alteração em comentário.
// 
// Alterei o programa para aceitar ref number = "00"
// 
// Nos relatórios de pendência, não usa mais a data da última atualização.
// Usa sempre a data do sistema como data limite
// ---------------------------------------------------------------------------------------------
// 
// 04/01/2001 - Alteração nas chamadas do Crystal, limpando a propriedade SortFields pois ela
// mantem o valor anterior, e no caso do LOG deu erro de Campo Inválido.
// 
// 18/12/2000 - Usuários de nível 3 (administrador) paasa a poder editar qualquer lançamento.
// Com a inclusão da conta 11.05.18 no Santander, foi inserida a característica de "Eliminar
// Movimento Duplicado", ou seja, na geração do arquivo temporário para processamento da conta,
// se no seu cadastro estiver marcado para eliminar movimento duplicado, toda linha igual à
// linha anterior, será desprezada.
// 
// Em função da mesma conta foi criado o conceito de forçar a moeda, deste modo, se no cadastro
// da conta estiver setado para forçar moeda real, na geração do arquivo temporário a moeda será
// forçada Real independente do que foi gerado no template. Vale também para US Dolar.
// 
// ----------------------------------------------------------------------------------------------
// 15/12/2000 - Apesar de não existir mais o campo Arq_Entrada, ele esta sendo utilizado para
// o arquivo 'juntado' e o arquivo .tmp. A partir de agora, o arquivo gerado pela junção sera
// 0 'JUNTADO_AAAAMMDD.TXT' e o tmp tera como nome o número da conta contábil e a tabela de
// concliliação será reestruturada com a eliminação desta coluna e tambem da coluna layout que
// também não é mais utilizada.
// 
// ----------------------------------------------------------------------------------------------
// 13/12/2000 - Alteração na opção Atualização GERAL de modo a omitir o processamento de algumas
// contas quando necessário. No cadastro das contas foi colocao o campo AtualizaGeral de deve ser
// SIM' para processar a conta.
// 
// ----------------------------------------------------------------------------------------------
// 12/12/2000 - Alteração geral de LOG. Criação da tabela log nos bancos Admin e dos clientes.
// Esta tabela vai substituir a Log. Criação do relatório log.rpt com o novo formato.
// 
// ----------------------------------------------------------------------------------------------
// 12/12/2000 - Alteração no Geratemp para corrigir datas onde aparece o caracter " ", substituindo
// os por "0".
// Alteração no Balancete por ordem de data. Estava omitindo dados. foi alterada a strin SQL e
// a gravação das datas de Debito/Credito na tabela 'relatório'
// 
// ----------------------------------------------------------------------------------------------
// 06/12/2000 - Verificação da utilização de Layout e ArqEntrada dentro do programa, visto que
// estes dados não são mais necessários. Falta remover tais colunas no Banco de dados Admin.
// 
// ----------------------------------------------------------------------------------------------
// 30/11/2000 - Liberação da nova versão(1.2) com as devidas alterações nos bancos de dados
// admin e dos clientes. Esta versão contém o módulo de segurança e a nova interface com
// o usuário que apresenta novas opções e novas posições para opções ja existentes.
// Criação dos relatórios de Variação Cambial ( Geral=Todas as variações ja efetivadas na
// conta contabil, Ref_Mes = As varições contabilizadas no Mes especificado e Pendente = as
// que ainda não foram contabilizadas).
// Criação da Atualização Complementar, que permitirá a atualização em uma data que já foi
// atualizada. A única restrição é que se houver mais que um lançamento com o mesmo cartão
// e mesmo valor, o sistema manterá o primeiro lançamento e descartará os seguintes.
// 
// ----------------------------------------------------------------------------------------------
// 29/11/2000 - Alteração no código de grupo de conciliação de 1 para 2 dígitos. Foram alteradas
// as tabelas tb_GrupoCon e tb_tipo_con do banco Admin e a tabela tb_opcao do banco do cliente.
// Houve também alterações no programa.
// 
// Unificação das opções de pesquisa por valor. Agora só existe uma opção que pesquisa o mesmo
// valor nos débitos e nos créditos em reais e em dolares.
// 
// Alteração na tabela tbcontas que ficou da seguinte maneira:
// 
// conta_contabil    C  6
// conta             C  4
// natureza          C  1
// ref               C  2
// relatorio_origem  C  8
// template          C  20
// Arquivo_saida     C  20
// Observacao        C  50
// 
// ----------------------------------------------------------------------------------------------
// 28/11/2000 - Alteração na BaixaBanco. Passa a pedir ao usuário somente a Moeda e Data da baixa.
// O nome dos arquivos de entrada passa a ser CCCCCC_AAAAMMDD.PRN, onde CCCCCC=ContaContabil.
// O codigo do Banco vem do cadastro do cliente, o codigo será os 4 últimos digitos da contacontabil,
// a referência será sempre "99" e o relatório sera a contacontabil.
// Obs. Os arquivos de entrada estarão no diretorio Baixa_Banco de cada cliente.
// 
// ----------------------------------------------------------------------------------------------
// 27/11/2000 - Alteração no módulo para alterar manualmente os registros. Não alterava o número
// do cartão devido a definições anteriores. Agora pode alterar (pedido do Jonas)
// Alterção no mesmo módulo para localizar os lançamento também pelo valor em US$.
// Alteração na rotina de Variação cambial. Estava pegando Débitos e Créditos do mês independente
// de ser o primeiro ou o segundo lançamento.
// 
// ----------------------------------------------------------------------------------------------
// 24/11/2000 - Criação da Opção "Gera Baixa Banco". Esta opção pede ao operador o código do banco,
// o nome do relatório (padrão=Banco), a moeda (padrão=986), o código, a referência e a data
// da baixa e le um arquivo .txt com as colunas cartao e valor. Com estes dados, gera um arqquivo
// de nome BaixaManual_AAAAMMDD.txt que deverá ser juntado com os outros arquivos gerados pelo
// Multicold para atualização da Conciliação. Os dados digitados pelo usuário seão armazenados
// e restaurados na próxima execução
// 
// Estudar a forma de pegar os dados diretamente da planilha XLS
// 
// ----------------------------------------------------------------------------------------------
// 21/11/2000 - Alteração da Tabela tb_contas no banco dos clientes. Foi retirado o Campo Ref2,
// ou seja, passa a existir somente uma referência(Ref1). Foram incluidos os campos Cpart5 para
// armazenar a quinta conta de contrapartida, o campo Relatório que indica a origem dos dados
// desta conta, o campo template que indica o template do multicold que é utilizado, o campo
// Arq_Saida que indica o nome do arquivo gerado e o campo Observacao para uso geral.
// Alteração na tabela tb_tipo_con no banco de Administração. Foi criado o campo LimiteVariacao
// que irá armazenar o valor percentual para interpretação de possíveis Variações Cambiais.
// Baseado neste valor, um lançamento em real pode "matar" um lançamento em dolar, desde que
// a Variação Cambial esteja dentro deste limite.
// 
// ----------------------------------------------------------------------------------------------
// 16/11/2000 - Inclusão dos valores de Débito e Crédito contábeis no agendamento com o objetivo
// de apurar a diferença entre o valor informado e o calculado e fazer, automaticamente um
// lançamento de variação cambial
// 
// Alteração na rotina Gera_Temp para manter a Moeda anterior caso esta venha em branco nas
// contas 0960 e 1063. Se ocorrer a necessidade deste artifício em outras contas, criar uma
// tabela com estas contas
// 
// ----------------------------------------------------------------------------------------------
// 09/11/2000 - Unificação das telas de Inclusão, Exclusão e Alteração. Inclusão da seleção de
// lançamentos por valor além do nro do cartão
// 
// ----------------------------------------------------------------------------------------------
// 08/11/2000 - Alterada a geração de Variação Cambial de forma que só será feita a variação se
// houver débito OU crédit em dolar. Foi verificada a existencia de lançamentos com débito e
// crédito em real com saldo diferente de ZERO
// Foi alterado o módulo de Alteração Manual que não estava gravando datas nulas, ou seja, se
// o usuário excluisse uma data de débito ou crédito, ela não estava sendo atualizada no Banco.
// A Versão do Programa passou de 1.0 para 1.1
// Criação de uma lista com todos os débitos e créditos durante a atualização manual para
// utilização com debug

// ----------------------------------------------------------------------------------------------
// 07/11/2000 - Revisão geral dos relatórios e das chamadas. Modificação da data que reflete a
// Posição da conta para a data da última Atualização Geral.
// Os relatórios gerais não pedem mais a data e os períodos pedem sempre a data limite. não existe
// mais nenhum relatório pos intervalo de datas.
// 
// ----------------------------------------------------------------------------------------------
// 04/11/2000 - Alteração na tabela tb_contas, o campo conta passou a se chamar código.
// Internamente as variáveis que manipulam este campo ainda continua como conta.
// Correção de vários itens como nome de opções, verificações para evitar uso indevido do
// sistema
// 
// ###############################################################################################

// Código do Clinte para montar Relatório
// Database definitions
// Temporary directoy
// Nome do banco de dados
// Path do banco de dados
// Path para os arquivos Excel

// Public gRpt1File As String     ' Nome do Relatório do Crystall
// Public gRpt3File As String     ' Nome do Relatório do Crystall
// Public gRpt4File As String     ' Nome do Relatório do Crystall

// Public gRpt1sFile As String    ' Nome do Relatório do Crystall
// Public gRpt2sFile As String    ' Nome do Relatório do Crystall
// Public gRpt3sFile As String    ' Nome do Relatório do Crystall
// Public gRpt4sFile As String    ' Nome do Relatório do Crystall

// 1=Data, 2=Cartão

type tDataInfo = record
  Posicao: Integer;
  Linha: Integer;
  Tamanho: Integer;
end;

type tLancamento = record
  Data_Debito: TDateTime;
  Data_Credito: TDateTime;
  Cartao: String;
  Vl_DebitoDolar: Extended;
  Taxa_Debito: Extended;
  Vl_CreditoDolar: Extended;
  Taxa_Credito: Extended;
  Vl_DebitoReal: Extended;
  Vl_CreditoReal: Extended;
  Variacao: Extended;
  Vl_Saldo: Extended;
  Cod_Deb: String;
  Cod_Cred: String;
  Rel_Deb: String;
  Rel_Cred: String;
  Obs_Deb: String;
  Obs_Cred: String;
  // Observacao As String
end;

type tArqEntrada = record
  Data: tDataInfo;
  Moeda: tDataInfo;
  Cartao: tDataInfo;
  Conta: tDataInfo;
  Valor: tDataInfo;
  Ref: tDataInfo;
  BIN: tDataInfo;
  Relatorio: tDataInfo;
  Dept: tDataInfo;
end;

type tRegistroRelatorio = record
  IdCliente: array  of char;
//  IdRelatorio: array  of char;
  IdRelatorio: String;
  CdCliente: Integer;
  ContaContabil: array  of char;
  NomePadrao: array  of char;
end;

type tRegistroConciliacao = record
//  ContaContabil: array[1..16]  of char;
//  ContaEmissor: array[1..16]  of char;
//  nome: array[1..50]  of char;
  ContaContabil,
  ContaEmissor,
  nome,
  Natureza: String;
end;

type tRegistroConta = record
//  Conta: array[1..16]  of char; // 4
  Conta: String; // 4
  nRef: Integer;
  Ref: array  of char;
//  conta_para: array[1..16]  of char;
  conta_para: String;
end;

type TtRegistroConta = array of tRegistroConta;

type tContas = record
//  Conta: array  of char; // 4
//  Ref: array  of char;
  Conta: array [1..4] of char; // 4
  Ref: array  of char;
end;

//type DePara = record
//  Conta_contabil: array  of char;
  //Conta_contabil: String;
//  Codigo: array  of char;
  //Codigo: String;
  //mInterface: Boolean;
//end;

//type TDePara = array of DePara;

//type Saci = record
//  Codigo: array  of char;
//  TemPerna: Boolean;
//end;

//type TSaci = array of Saci;

//type PF_PJ = record
//  BIN : array  of char;
//end;

//type TPF_PJ = array of PF_PJ;

type xTipoCon = record
                Indice: Integer;
                Cd_Grupo_Con : String;
                NmGrupo : String;
//  Cd_Grupo_Con : array  of char;
//  NmGrupo : array  of char;
               end;

// Interface - Fidelity
// 2008-08-24
// Para checar durante a geração da interface
// Lay out do arquivo para Interface - Mainframe

type tArqInterface = record
  Ind_Rota: tDataInfo;
  Nro_Corp: tDataInfo;
  BIN: tDataInfo;
  Cod_Origem: tDataInfo;
  Sequencia: tDataInfo;
  Cod_Tran: tDataInfo;
  Cod_Razao: tDataInfo;
  Indic_Db_Cr: tDataInfo;
  Ind_Rej: tDataInfo;
  Ind_Reversao: tDataInfo;
  Tipo_Cart: tDataInfo;
  Ind_Destino: tDataInfo;
  Tipo_Prod: tDataInfo;
  Tipo_Emprest: tDataInfo;
  Ind_Plan_Fin: tDataInfo;
  Cod_Moeda: tDataInfo;
  Cod_Charge_Off: tDataInfo;
  Ind_Dt_Corte: tDataInfo;
  Valor: tDataInfo; // PIC 9(11)V99
  Nro_Cartao: tDataInfo;
  Dia_Corte: tDataInfo;
  Data_Tran: tDataInfo;
  Filler: tDataInfo;
end;

// lay out do codigo para
type tColunaCodigo = record
  // TCRC TPC REJ D/C SRC REV DEST TPP T/E MOE CHO BIL
  // 6   1   1   1   3   1   3    2   1   3   1   1
  // 1   7   8   9   10  13  14   17  19  20  23  24
  TCRC: tDataInfo;
  TPC: tDataInfo;
  REJ: tDataInfo;
  D_C: tDataInfo;
  // CLASSE     As tDataInfo
  SRC: tDataInfo;
  REV: tDataInfo;
  DEST: tDataInfo;
  Ind_Rej: tDataInfo;
  TPP: tDataInfo;
  T_E: tDataInfo;
  MOE: tDataInfo;
  CHO: tDataInfo;
  BIL: tDataInfo;
  Filler: tDataInfo;
end;

 function GetComputerName(lpBuffer: String; var nSize: Integer): Integer; stdcall; external kernel32 name 'GetComputerNameA';
 procedure Main;
 procedure initGlobalVar;
// function PoePonto(STR: String): String;
 function FormataValorX(Valor: String): Extended;
 function FormataValor2(Valor: String): String;
 function FormataValor3(Valor: String): String;
 function FormataCC(Valor: String): String;
 function TiraPontos(Cartao: String; Tipo: String): String;
 function Tiravirgula(sValor: String): String;
 function ContaCredito(Indice: Integer; Moeda, NomeArquivo : String): Boolean;
 function ContaDebito(Indice: Integer; Moeda, NomeArquivo : String): Boolean;
 function Get_Texto(Tipo: Integer; Var NomeArquivo : String): Boolean;
 function Get_Texto1: OleVariant;
// function ExtractFileName(nome: String): String;
 function limpaString(st: String): String;
 function IsStringNum(st: String): Boolean;
 function IsCharAlfa(ch: Char): Boolean;
 function IsCharNum(ch: Char): Boolean;

 function isDataValida(sData: String): Boolean; OverLoad;
 function isDataValida(sData: TDateTime): Boolean; OverLoad;

 function isValorValido(sValor: String): Boolean;
// function isDataMenorIgual(sData1: TDateTime; sData2: TDateTime): Boolean;
// function isDataMenor(sData1: TDateTime; sData2: TDateTime): Boolean;
// procedure MontaMenus;
 procedure ReCalcula(dData: TDateTime);
 procedure MontaRelatorio(Data1: TDateTime; Data2: TDateTime; Com: Boolean);
 procedure MontaRelatorioSaldo(Data1 : TDateTime; Com: Boolean);
 procedure MontaRelPendencias(Data1: TDateTime; Com: Boolean);
 procedure MontaRelatorioSaci(Data1: TDateTime; Saci: Boolean);
 procedure MontaRelatorioInterface(Data1: TDateTime; Saci: Boolean);
 procedure MontaRelExcell(var Data1: TDateTime; Com: Boolean; Msg: Boolean);
 function ChecaModelo: Boolean;
 function ChecaTempDb: Boolean;
 function IsOk(d1: TDateTime; d2: TDateTime): Boolean;
 function IsOk2(d1: TDateTime): Boolean;
 function IsOk3(d1: TDateTime): Boolean;
 function GetDataBaseName(Id: Integer): String;
 procedure Gravalog(RsExc: TADODataSet; sOperacao: String);
 procedure GravaLog3(RsExc: TADODataSet; sOperacao: String);
 procedure GravaLog4(RsExc: TADODataSet; sOperacao: String);
 function PegaColunas(NomeArquivo : String): Boolean;
 function GetCampo(sBuffer: String; var iPonteiro : Integer): String;
 function TiraExt(nome: String): String;
// function Limpa(Dado: String): String;
 function FormataTexto(Path: String; NArq: String; Tipo: String): Boolean;
// function PegaString(buff: String; var STR: OleVariant; Pos: Integer): Integer;
 function PegaString(buff: String; var STR: String; Pos: Integer): Integer;
 function PegaPar: Integer;
 function PegaParInterface: Integer;
 function PegaParCodigo: Integer;
// procedure LimpaFlags(var Flags: OleVariant);
 procedure LimpaFlags(var Flags: Array of Boolean);
 function ContaValida(Buf: String; Ind: Integer; Nat: String; Flag: Boolean; Moeda: String): Boolean;
 function GeraTemp(Var NomeSaida, NomeArquivo: String): Boolean;
 function GeraTemp2(Var NomeSaida, NomeArquivo: String): Boolean;
 procedure BackupBanco;
 procedure BackupGeral;
 function QuebraBanco: Boolean;
 function LimpaConta(sConta: String; iDias: Integer): Boolean;
 function ValidaDatas(DataM: TDateTime; RsDb : TAdoDataSet): Boolean;
 function GeraTempDb: Boolean;
// function CopiaTabela( { DbOrigem: Database }  { ; DbDestino: Database } Tabela: String): Boolean;
 function copiaAte_18(STR1: String; STR2: String; cnt: Integer): String;
 function copiaAte(STR1: String; STR2: String; var cnt: Integer): String;
// function GetPath: String;
(* procedure MontaTexto;
 procedure MontaLinhaTxt(ArqSaida: Integer);
 function FormataFixo(Valor: Extended; Tam: Integer): String;  *)
 function TrataValor(buff: String): String;
// procedure AtualizaTotal;
 //procedure SimulaNovaCon;
(* function MaxData(Conta: String): TDateTime;*)
 function MaxDataDolar(Conexão : TAdoConnection): TDateTime;
 Procedure LastAtualiza;
 function GetTotDebito(Conexão : TAdoConnection): Extended;
 function GetTotCredito(Conexão : TAdoConnection): Extended;
 function GetSaldo: Extended;
 function GetLimite(N_Cliente: String; C_Contabil: String): Integer;
 function pegaNomeRel(fullName: String): String;
 function Autoriza(Nivel: Integer): Boolean;
(* function ContaCreditoComp(Indice: Integer; Moeda: String): Boolean; *)
// function ContaDebitoComp(Indice: Integer; Moeda, NomeArquivo: String): Boolean;
 procedure GravaHeaderRel(DbLoc: TAdoConnection; RsLoc: TADOTable; Tipo: Integer);
// procedure AbreMenu(Menu: Integer);
 procedure BarraStatus;
 procedure LimpaBackUp(nBackup: Integer); (*
 function Gera_Resumo: Boolean;
 function Gera_Resumo_2: Boolean;*)
(* function Monta_Interface: OleVariant;
 function Monta_SACI: OleVariant;
 function Monta_SACI_OLD: OleVariant; *)
(*// function Monta_PFPJ: OleVariant;
 function TipoDePessoa(BIN: String): String;
 function GerarInterface(Cod: String): Boolean;
 function pegaSaci(Cod: String; DecCred: String): Boolean;*)
 //function Get_Codigo_Para(Conta: String): String;
 (*
 function Gera_Interface: Boolean;
 
 function Zeros_2(cnt: Integer): String;
 function Zeros(var cnt: Integer): String;
 function dataOito(Dt: String): String;
 function dataDezBarra(Dt: String): String;
 function dataOitoBarra(Dt: String): String;
 function tipoCartao(cart: String): String;  *)
 function MontaTabela: Boolean;              (*
 function MontaTabela_BAK: Boolean;
 procedure ShowFileAccessInfo(filespec: OleVariant);
 function LastModifica(sFile: String): TDateTime;
 function LastBackup(sDir: OleVariant): String; *)
// procedure DoLogin;
 (*
 function MeuComputador: String;     *)
 function TruncaPath(Path: String; Tam: Integer): String;
// procedure MontaBinGeralx;
 function DiaUtil(Dt: TDateTime): Boolean;
// function openLog: Boolean;
// function renLogFile(logPath: OleVariant): Boolean;
// function getLogLevel: Integer;
(* function openFile(fName: String; mode: String): Integer;
 function testeOpenFile: Boolean;
// function testeOpenFileActivex: Boolean;       *)
 function JuncaoDeJuntado(dataDe: TDateTime; dataAte: String): Boolean;

var
  gTDebReal, gTCredReal, iCountReg, gNroReg, gTotDebito, gTotCredito: Extended;
  //fMainForm: TForm;
  gConciliacao, gArquivo, gArquivo1, gArquivo2, gArquivo3, gArquivo4, gArquivo5,
  gArquivo6, gArquivo7, gArquivo8, gArquivo9, gArquivo10, gArquivo11, gOperador,
  gNomeUsuario, gNomeComputador, gRelatorio, sSql, gTempDir, gDataMov, gOrdemGrid,
  gOpcao, gCliente, gBandeira, gCodigoCliente, gDataJuncaoAte,
  gDataGeracaoArquivo, gObsDeb, gObsCred,{ NomeArquivo,} gData1, gData2, gAdmPath,
  gTaxa, gSaldo: String;
  gLimiteVariacao, gLimpAuto, gColuna1, gColuna2, gColuna3, gColuna4, gColuna5,
  gColuna6, gColuna7, gColuna8, gColuna9, gColuna10, gColuna11, gColuna12,
  gColuna13, gTamData, gNivel, gOrdem, gAlteraLanc, gConsulta, LinhaAtual,
 (*  iPonteiro, *)gTipo_Rec, gLogLevel, gMaxCon: Integer;
  gAtualizacao,
  gDataSistema,
  gDataRelatorio: TDateTime;
  gAtualizaGeral, gEliminaDuplicacao, gForcaReal, gForcaDolar, bConectado,
  gNegativo, gDtMovInvalida, gDEBUG, gLOCAL, gTESTE, gAutomatico: Boolean;
  gCodigo, gNReg: Integer;
//  gWork: Workspace;
//  gBanco, DbTemp: Database;
//  RsDb, RsDb2, RsTemp: TADODataSet;
  gDataFile: String;
//  gDataPath, gExcelPath: OleVariant;
  gDataPath, gExcelPath: String;
  gSalva: tLancamento;
  gBIN, gBinGeral, (*gArqEntrada,*) gArrConcil, gArrConcil2, gArrConcil3: TStringList;
  gContas: array of tContas;
  ctDebito, ctCredito: TtRegistroConta;
  ncDebito, ncCredito: Integer;
  Concil: tRegistroConciliacao;
  Relatorio: tRegistroRelatorio;
  Entrada, Param: tArqEntrada;
  Param_Inter: tArqInterface;
  Param_Codigo: tColunaCodigo;
  Result: Integer;
  DataSis: SYSTEMTIME;
  tbTipoCon: array of xTipoCon;
//  mInterface: TDePara;
//  creditoSACI, debitoSACI: TSaci;
//  TipoPessoa: TPF_PJ;

implementation

uses  Forms, Dialogs, Graphics, SysUtils, StrUtils, System.Types, IOUtils, frmLogin_, TelaInicial_,
      frmRelease_, frmLog_, PBar_, DataMov_, VBto_Converter, FileHandles, Subrug, PedeAlteraca;

var
  pData1, pData2: TDateTime;

//==============================================================

procedure Main;
//var
//  xRes, yRes: Integer;
begin
  // renLogFile ""

// Romero - inicializações que não combinam com o estilo Delphi...

(*
  if App.PrevInstance then begin
    ShowMessage('Já existe uma cópia da Conciliação rodando...');
    Application.Terminate;
  end;

  // Inicializa variaveis globais
  initGlobalVar;

  fMainForm := frmMain.Create;
  Load(fMainForm);
  TelaInicial.ShowModal;

  if gOperador='' then Application.Terminate;

  // 720x1024 (17, 0)
  xRes := GetSystemMetrics(0);
  if xRes=1024 then begin
    fMainForm.Picture.LoadFromFile(LoadPicture(ExtractFileDir(Application.ExeName)+'\cr1024.bmp'));
  end;

  fMainForm.Show;
  TelaInicial.Close;
  if Dir(ExtractFileDir(Application.ExeName)+'\release.txt')<>'' then begin
    frmRelease.ShowModal;
  end; *)
end;

procedure initGlobalVar;
begin
  gTESTE := false;
  gTESTE := true;

  gLOCAL := false;
  // gLOCAL = True  ' Debug no diretorio de producao

  gDEBUG := false;
  // Teste em outro path ou máquina
  // gDEBUG = True

  gAdmPath := ExtractFileDir(Application.ExeName);

  // Substituir todos os now por gdatadosistema

  gDataSistema := DataDoSistema;
  gTempDir := 'c:\temp\';
end;

// VBto upgrade warning: 'Return' As OleVariant --> As String
(*function PoePonto(STR: String): String;
var
  I: Integer;
begin

  STR.Replace(',', '.');    // Will be using this instead

  I := STR.IndexOf(','); // (1+Pos(',', PChar(STR)+1));
  if I<>0 then begin
    SetToMid(STR, I, '.', 1);
  end;

  Result := STR;
end;*)

// VBto upgrade warning: Valor As String  OnWrite(String, Extended, TField, VB.TextBox)
function FormataValorX(Valor: String): Extended;
var
  Buffer: String;
  I, J: Integer;
begin
  Result := 0;
  I := Valor.IndexOf('.');;
  J := Valor.IndexOf(',');;
  if I > J then
    begin
    // Troca pontos por vígulas e vice versa
    I := 0;
    J := 0;
    Buffer := '';
    while I <= (Length(Valor)-1) do
      begin
      if (Valor.Substring( J, 1) <> ',') and (Valor.Substring( J, 1) <> '.') then
        begin
        Buffer := Buffer + Valor.Substring( J, 1);
        Inc(I);
        end;
      if Valor.Substring( J, 1) = '.' then
        begin
        Buffer := Buffer + ',';
        Inc(I);
        end;
      Inc(J);
      end;
    Valor := Buffer;
    end;

  if Length(Valor) > 0 then
    Result := RoundTo(StrToFloat(Valor), -2);

  Exit;
                     // Se tem esse exit aqui, pra frente nada vale!!!
(*  Posicao := 1;
  Buffer := '';
  I := (1+Pos('.', PChar(Valor)+1));
  if I>Length(Valor)-2 then begin
    Buffer := Valor.Substring( 1, I+2);
    Valor := Buffer;
  end;

  I := (1+Pos(',', PChar(Valor)+1));
  if (I>0) and (I<Length(Valor)-2) then begin
    Buffer := Valor.Substring( 1, I+2);
    Valor := Buffer;
  end;

  Buffer := '';
  Valor := Trim(Valor);
  if ((1+Pos('.', PChar(Valor)+1))=0) and ((1+Pos('.', PChar(Valor)+1))=0) and ((1+Pos(',', PChar(Valor)+1))=0) and ((1+Pos(',', PChar(Valor)+1))=0) then begin
    Valor := Valor+'.';
  end;

  if 0<>(1+Pos('.', PChar(Valor)+1)) then begin
    if (1+Pos('.', PChar(Valor)+1))<(Length(Valor)-2) then begin

      Valor := Valor.Substring( 1, Length(Valor)-(1 +  Pos('.', PChar(Valor)+1))+2);
    end;
    if (1+Pos('.', PChar(Valor)+1))>(Length(Valor)-2) then begin
      while (1+Pos('.', PChar(Valor)+1))<>Length(Valor)-2 do begin
        Valor := Valor+'0';
      end;
    end;
  end;

  if 0<>(1+Pos(',', PChar(Valor)+1)) then begin
    if (1+Pos(',', PChar(Valor)+1))<(Length(Valor)-2) then begin
      Valor := Copy(Valor, 1, Length(Valor)-(1+Pos(',', PChar(Valor)+1))+2);
    end;
    if (1+Pos(',', PChar(Valor)+1))>(Length(Valor)-2) then begin
      while (1+Pos(',', PChar(Valor)+1))<>Length(Valor)-2 do begin
        Valor := Valor+'0';
      end;
    end;
  end;
  if 0<>(1+Pos(',', PChar(Valor)+1)) then begin
    I := 2;
    if Copy(Valor, 1, 1)='(' then begin
      I := 3;
    end;
    while (1+Pos(',', PChar(Valor)+1))<>Length(Valor)-I do begin
      Valor := Valor+'0';
    end;
  end;

  // Valor = Format$((Valor) / 100, "######0,00")

  while Posicao<=Length(Valor) do begin
    if (Copy(Valor, Posicao, 1)<>' ') and (Copy(Valor, Posicao, 1)<>',') and (Copy(Valor, Posicao, 1)<>'.') then begin
      if (Copy(Valor, Posicao, 1)<>'(') and (Copy(Valor, Posicao, 1)<>')') then begin
        Buffer := Buffer+Copy(Valor, Posicao, 1);
       end  else  begin
        gNegativo := true;
      end;
    end;
    Posicao := Posicao+1;
    if (Copy(Valor, Posicao, 1)=')') then begin
      gNegativo := true;
    end;
  end;
  if Buffer<>'' then begin
    Result := CDbl(Buffer)/100;
   end  else  begin
    Result := CDbl(0)/100;
  end;
  if gNegativo then begin
    Result := -1*Result;
  end;
  gNegativo := false; *)
end;

function FormataValor2(Valor: String): String;
var
//  Buffer: String;
//  Posicao: Integer;
  FormatSettings : TFormatSettings;
begin
  // duas casas decimais com "."
  // FormataValor2 = Valor

//  FormatSettings := TFormatSettings.Create(GetThreadLocale); Testar se precisa

  FormatSettings.DecimalSeparator := '.';
  Result := FormatFloat('0.00', StrToFloat(Valor), FormatSettings);

(*  Buffer := FloatToStr(FormataValor(Valor));

  Posicao := (1+Pos(',', PChar(Buffer)+1) {?, vbTextCompare} );
  if Posicao<>0 then begin
    Result := Copy(Buffer, 1, Posicao-1)+'.'+Copy(Buffer, Posicao+1, 2);
    if Length(Buffer)-Posicao=1 then begin
      Result := Result+'0';
    end;
   end  else  begin
    Result := Buffer+'.00';
  end;    *)
end;

// VBto upgrade warning: Valor As String  OnWrite(TField)
function FormataValor3(Valor: String): String;
var
//  Buffer: String;
//  Posicao: Integer;
  FormatSettings : TFormatSettings;

begin
  // duas casa decimais com ","

//  FormatSettings := TFormatSettings.Create(GetThreadLocale); Será preciso isso?

  FormatSettings.DecimalSeparator := ',';
  Result := FormatFloat('0,00', StrToFloat(Valor), FormatSettings);

(*  Result := Valor;

  Buffer := FloatToStr(FormataValor(Valor));

  Posicao := (1+Pos(',', PChar(Buffer)+1) {?, vbTextCompare} );
  if Posicao<>0 then begin
    if Length(Buffer)-Posicao=1 then begin
      Result := Buffer+'0';
    end;
   end  else  begin
    Result := Buffer+',00';
  end; *)
end;

function FormataCC(Valor: String): String;
begin
  Result := '';
  if Length(Valor)<>6 then begin
    Exit;
  end;
  Result := Copy(Valor, 1, 2)+'.'+Copy(Valor, 3, 2)+'.'+Copy(Valor, 5, 2);
end;

// VBto upgrade warning: Cartao As String  OnWrite(String, FixedString, VB.TextBox)
// VBto upgrade warning: Tipo As String  OnWrite(Integer)
// VBto upgrade warning: 'Return' As OleVariant --> As String
function TiraPontos(Cartao: String; Tipo: String): String;
var
  Buffer: String;
  Posicao: Integer;
begin
  Posicao := 1;
  Buffer := '';
  while Posicao<=Length(Cartao) do begin
    if (Copy(Cartao, Posicao, 1)<>' ') and (Copy(Cartao, Posicao, 1)<>'.') then begin
      Buffer := Buffer+Copy(Cartao, Posicao, 1);
    end;
    Posicao := Posicao+1;
  end;

  Result := Buffer;
  if (Tipo='13') and (Length(Buffer)>13) then begin
    Result := Copy(Buffer, 1, 13);
  end;

end;
function Tiravirgula(sValor: String): String;
var
  Buffer: String;
  Posicao: Integer;
begin
  // Tira a virgula do campo Valor para gravar o arquivo Interface
  Posicao := 1;
  Buffer := '';
  while Posicao<=Length(sValor) do begin
    if (Copy(sValor, Posicao, 1)<>' ') and (Copy(sValor, Posicao, 1)<>',') then begin
      Buffer := Buffer+Copy(sValor, Posicao, 1);
    end;
    Posicao := Posicao+1;
  end;

  Result := Buffer;
end;

function ContaCredito(Indice: Integer; Moeda, NomeArquivo : String): Boolean;

var
  ArqEntrada: System.Text;
  Buffer, sCartao, sValor, sMoeda: String;
  iPosicao, Posição: Integer;
  iFileLen : Int64;
  lTotDebito, lTotCredito, Variacao: Extended;
  I: Integer;
  Pula: Boolean;
  DataLocal,
  DataAux: TDateTime;
  ClienteAdoConnection : TAdoConnection;
  RsDb : TAdoDataSet;

begin
  iPosicao := 0;

  // Abre o arquivo de entrada
  if FileExists(NomeArquivo) then
    begin
    AssignFile(ArqEntrada, NomeArquivo);
    Reset(ArqEntrada);
    end
  else
    begin
    Result := false;
    Exit;
    end;

  ReadLn(ArqEntrada, Buffer);
//  if (Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho) <> gDataRelatorio) then
  if StrToDate(Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho)) <> gDataRelatorio then
    begin
    if gAutomatico then
      begin
      frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Data do Movimento Inválida...'+#10;
      Application.ProcessMessages;
      end
    else
      begin
      Application.MessageBox('Data do Movimento Inválida...', 'Atualização de Arquivo', MB_ICONSTOP);
      end;
    Result := false;
    CloseFile(ArqEntrada);
    Exit;
    end;

  Result := true;

  CloseFile(ArqEntrada);
  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);

//  if  not Conecta('') then Exit;

  if not Conecta(ClienteAdoConnection, gDataPath + gDataFile + '.udl') then
    Exit;

  RsDb := TAdoDataSet.Create(nil);
  RsDb.Connection := ClienteAdoConnection;

  // Pega totais antes de processar
  lTotDebito := GetTotDebito(RsDb.Connection);
  lTotCredito := GetTotCredito(RsDb.Connection);

  sSql := 'select * from lancamentos where conta_contabil='#39'';
  sSql := sSql+Trim(Concil.ContaContabil)+''#39'';

  RsDb.CommandText := sSql;
  RsDb.Active := True;

  // If Not gAutomatico Then
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Atualizando Banco... '+String(Concil.ContaContabil);
  iFileLen := FileSizeByName(NomeArquivo);
  // End If
  while  not Eof(ArqEntrada) do begin
    ReadLn(ArqEntrada, Buffer);
    // If Not gAutomatico Then
    iPosicao := iPosicao+Length(Buffer)+2;
    if iPosicao/iFileLen<=1 then begin
      PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100);
     end  else  begin
      PBar.ProgressBar1.Position := 100;
    end;
    // End If
    Application.ProcessMessages;

    if ContaValida(Buffer, Indice, 'C', true, Moeda) then
      begin
      iCountReg := iCountReg+1;
      gNroReg := gNroReg+1;
      sCartao := Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho);
      sValor := Trim(Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
      sMoeda := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);

      // If sMoeda = "840" Then
      // MsgBox "ACHEIIIIIIIIIIIIIII"
      // End If

      // MsgBox sValor
      // Gerar registro
      sSql := '';
      sSql := 'Select * from [Lancamentos]';
      sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
      sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
      Pula := false;

      if (sMoeda='986') or (sMoeda='000') then
        begin
        sSql := sSql+' and Vl_DebitoReal = '+FormataValor2(sValor);
        sSql := sSql+' and Vl_CreditoReal = '+FormataValor2('0');
         RsDb.CommandText := sSql;
        RsDb.Active := True;
        end
      else
        if sMoeda='840' then
          begin
          sSql := sSql+' and Vl_DebitoDolar = '+FormataValor2(sValor);
          sSql := sSql+' and Vl_CreditoDolar = '+FormataValor2('0');
          sSql := sSql+' and Vl_CreditoReal = '+FormataValor2('0');
          RsDb.CommandText := sSql;
          RsDb.Active := True;
          end
        else
          Pula := true;

      if not Pula then
        begin // Moeda inválida
        if RsDb.EOF then
          begin
          // Antes de criar novo registro, verificar se não é uma variação
          // 1-Verificar se existe Deb ou Cred em US$
          // 2-Se houver, verificar se o valor esta dentro do limite cadatrado
          // para conta
          // 3-Se tiver, matar lançamento

          // 28/02/01 - Antes de "matar" o lançamento, verificar se
          // não existe lançamento em dolar no mesmo valor.
          // Se existir não "matar"
          if (sMoeda='986') or (sMoeda='000') then
            begin
            sSql := '';
            sSql := 'Select * from [Lancamentos]';
            sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
            sSql := sSql+' and Vl_DebitoReal = '+FormataValor2(sValor);
            sSql := sSql+' and Vl_CreditoDolar = '+FormataValor2(sValor);
            RsDb.CommandText := sSql;
            RsDb.Active := True;
            if RsDb.EOF then
              begin
              sSql := '';
              sSql := 'Select * from [Lancamentos]';
              sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
              sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
              sSql := sSql+' and Vl_CreditoReal = 0 ';
              sSql := sSql+' and Vl_DebitoDolar > 0 ';

              RsDb.CommandText := sSql;
              RsDb.Active := True;
              // Verifica variação
              if not RsDb.EOF then
                begin
                while not RsDb.EOF do
                  begin
                  Variacao := Abs(StrToFloat(sValor) - RsDb.FieldByName('Vl_DebitoReal').AsExtended);
                  if (Variacao / RsDb.FieldByName('Vl_DebitoReal').AsExtended) <= Extended(gLimiteVariacao / 100) then
                    begin
                    RsDb.Edit;
                    break;
                    end;
                  RsDb.Next;
                  end;
                if RsDb.EOF then
                  RsDb.Insert;
                end
              else
                RsDb.Insert
              end
            else
              // Tem valor em Dolar = Valor em Real, deve ser ERRO
              RsDb.Insert
            end
          else
            RsDb.Insert
          end
        else
          begin
          // se tiver + de um lançamento, matar o mais antigo (3/11/00)
          RsDb.Last;
          if RsDb.RecordCount > 1 then
            begin
            RsDb.First;
            DataLocal := Now;
            while not RsDb.EOF do
              begin
              if (TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataAux)) then
                if DataAux < DataLocal then
                  DataLocal := DataAux;
              if (TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataAux)) then
                begin
                if DataAux < DataLocal then
                  DataLocal := DataAux;
                end;
              RsDb.Next;
              end;

            RsDb.First;
            while not RsDb.EOF do
              begin
              if (TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataAux)) then
                if DataAux = DataLocal then
                  break;
              if (TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataAux)) then
                if DataAux = DataLocal then
                  break;
              RsDb.Next;
              end;
            end;
          RsDb.Edit;
          end;


        RsDb.FieldByName('cliente').AsString := gCliente;
        RsDb.FieldByName('Data_Credito').AsDateTime := gDataRelatorio;

        RsDb.FieldByName('Cartao').AsString := TiraPontos(sCartao, IntToStr(16));
        RsDb.FieldByName('Cartao1').AsString := TiraPontos(sCartao, IntToStr(13));

        if (sMoeda='986') or (sMoeda='000') then
//          RsDb.FieldByName('Vl_CreditoReal').AsCurrency := FormataValor(sValor)
          RsDb.FieldByName('Vl_CreditoReal').AsCurrency := StrToFloat(sValor)
        else
          begin
          RsDb.FieldByName('Vl_CreditoDolar').AsCurrency := StrToFloat(sValor);
          RsDb.FieldByName('Taxa_Credito').AsString := gTaxa;
//          FieldByName('Vl_CreditoReal').AsCurrency := FormataValor(FloatToStr(RoundTo(CDbl(sValor)*CDbl(gTaxa), -2)));
          RsDb.FieldByName('Vl_CreditoReal').AsCurrency := StrToFloat(sValor) * StrToFloat(gTaxa);
          end;

        RsDb.FieldByName('Vl_Saldo').AsCurrency := RsDb.FieldByName('Vl_DebitoReal').AsCurrency -
                                                   RsDb.FieldByName('Vl_CreditoReal').AsCurrency;
        RsDb.FieldByName('conta_contabil').AsString := Trim(Concil.ContaContabil);

        // Alterações visando a implementação da CONTABILIDADE
        RsDb.FieldByName('Cod_Cred').AsString := ctCredito[Indice].conta_para;
        RsDb.FieldByName('Rel_Cred').AsString := Copy(Buffer, Param.Relatorio.Posicao, Param.Relatorio.Tamanho);
        // RsDb.Fields("Dept_Cred") = Mid$(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho)
        RsDb.FieldByName('Depto_Cred').AsString := Copy(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho);
        RsDb.FieldByName('Moeda_Cred').AsString := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);

        // Contabilidade
        // If Len(gObsDeb) > 0 Then
        // RsDb.Fields("Obs_Deb") = gObsDeb
        // End If
        if Length(gObsCred) > 0 then
          RsDb.FieldByName('Obs_Cred').AsString := gObsCred;

        // If gDEBUG Then
        // If CDbl(RsDb.Fields("Vl_CreditoReal")) > 0 Then
        // Buffer = Format$(RsDb.Fields("Vl_CreditoReal"), "###,##0.00")
        // frmLog.RichTextBox1.Text = frmLog.RichTextBox1.Text &
        // Space(24 - Len(Buffer)) & Buffer & Chr(10)
        // End If
        // End If

        RsDb.UpdateRecord;

      end;
    end;

  end;
  // Pega totais antes de processar
  gTotDebito := gTotDebito + GetTotDebito(RsDb.Connection) - lTotDebito;
  gTotCredito := gTotCredito + GetTotCredito(RsDb.Connection) - lTotCredito;

  CloseFile(ArqEntrada);
  RsDb.Close;
  PBar.Close;
  ClienteAdoConnection.Close;
  RsDb.Free;
  ClienteAdoConnection.Free;
end;

function ContaDebito(Indice: Integer; Moeda, NomeArquivo: String): Boolean;
label
  Saida;
var
  ArqEntrada: System.Text;
  Buffer, sCartao, sValor, sMoeda: String;
  iPosicao, Posicao: Integer;
  iFileLen, lTotDebito, lTotCredito, Variacao: Extended;
  I: Integer;
  Pula: Boolean;
  DataLocal,
  DataAux : TDateTime;
  ClienteAdoConnection : TAdoConnection;
  RsDb : TAdoDataSet;

begin
  iPosicao := 0;

  // Abre o arquivo de entrada
  if FileExists(NomeArquivo)  then
    begin
    AssignFile(ArqEntrada, NomeArquivo); Reset(ArqEntrada);
    end
  else
    begin
    Result := false;
    ShowMessage('Arquivo: '+NomeArquivo+' não encontrado');
    CloseFile(ArqEntrada);
    Exit;
    end;

  ReadLn(ArqEntrada, Buffer);
//  if (Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho) <> gDataRelatorio) then
  if StrToDate(Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho)) <> gDataRelatorio then
    begin
    if gAutomatico then
      frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Data do Movimento Inválida...'+#10
    else
      Application.MessageBox('Data do Movimento Inválida...', 'Atualização de Arquivo', MB_ICONSTOP);

    Result := false;
    CloseFile(ArqEntrada);
    Exit;
    end;

  Result := true;

  CloseFile(ArqEntrada);
  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);

//  if  not Conecta('') then
//    Exit;

  if not Conecta(ClienteAdoConnection, gDataPath + gDataFile + '.udl') then
    Exit;

  RsDb := TAdoDataSet.Create(nil);
  RsDb.Connection := ClienteAdoConnection;

(*  sSql := 'select * from lancamentos where conta_contabil='#39'';
  sSql := sSql+Trim(Concil.ContaContabil)+''#39'';

  DataModuleForm.RsDb.CommandText := sSql;
  DataModuleForm.RsDb.Active := True;  *)    // Parece um pedaço de código sem função

  // Pega totais antes de processar
  lTotDebito := GetTotDebito(RsDb.Connection);
  lTotCredito := GetTotCredito(RsDb.Connection);
//  RsDb := gBanco.OpenRecordset(sSql);

  // If Not gAutomatico Then
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Atualizando Banco... '+String(Concil.ContaContabil);
  iFileLen := FileSizeByName(NomeArquivo);
  // End If
  while  not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    iPosicao := iPosicao+Length(Buffer)+2;
    // If Not gAutomatico Then
    if iPosicao/iFileLen <= 1 then
      PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
    else
      PBar.ProgressBar1.Position := 100;

    Application.ProcessMessages;

    if ContaValida(Buffer, Indice, 'D', true, Moeda) then
      begin
      iCountReg := iCountReg+1;
      gNroReg := gNroReg+1;
//      sCartao := Copy(Buffer, Param.Cartao.Posicao, Param.Cartao.Tamanho);
      sCartao := Buffer.Substring(Param.Cartao.Posicao-1, Param.Cartao.Tamanho);
      sValor := Trim(Copy(Buffer, Param.Valor.Posicao, Param.Valor.Tamanho));
      sMoeda := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);

      // If sMoeda = "840" Then
      // MsgBox "ACHEIIIIIIIIIIIIIII"
      // End If

      // Gerar registro
      // If CLng(sValor) > 10000 Then
      // MsgBox "Parei"
      // End If

      sSql := 'Select * from [Lancamentos]';
      sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
      sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
      Pula := false;

      if (sMoeda='986') or (sMoeda='000') then
        begin
        sSql := sSql+' and Vl_CreditoReal = '+FormataValor2(sValor);
        sSql := sSql+' and Vl_DebitoReal = '+FormataValor2('0');
        RsDb.CommandText := sSql;
        RsDb.Active := True;
        end
      else
      if sMoeda='840' then
        begin
        sSql := sSql+' and Vl_CreditoDolar = '+FormataValor2(sValor);
        sSql := sSql+' and Vl_DebitoDolar = '+FormataValor2('0');
        sSql := sSql+' and Vl_DebitoReal = '+FormataValor2('0');
        RsDb.CommandText := sSql;
        RsDb.Active := True;
        end
      else
        Pula := true;

      if not Pula then
        begin
        if RsDb.EOF then
          begin
          // Antes de criar novo registro, verificar se não é uma variação
          // 1-Verificar se existe Deb ou Cred em US$
          // 2-Se houver, verificar se o valor esta dentro do limite cadatrado para conta
          // 3-Se tiver, matar lançamento
          RsDb.Active := False;
          if (sMoeda='986') or (sMoeda='000') then
            begin
            sSql := 'Select * from [Lancamentos]';
            sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
            sSql := sSql+' and Vl_CreditoReal = '+FormataValor2(sValor);
            sSql := sSql+' and Vl_DebitoDolar = '+FormataValor2(sValor);
            RsDb.CommandText := sSql;
            RsDb.Active := True;
            if RsDb.EOF then
              begin
              RsDb.Active := False;
              sSql := '';
              sSql := 'Select * from [Lancamentos]';
              sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
              sSql := sSql+' and Cartao1 = '#39''+Copy(sCartao, 1, 13)+''#39'';
              sSql := sSql+' and Vl_DebitoReal = 0 ';
              sSql := sSql+' and Vl_CreditoDolar > 0 ';
              RsDb.CommandText := sSql;
              RsDb.Active := True;
              // Verifica variação
              if not RsDb.EOF then
                begin
                while not RsDb.EOF do
                  begin
                  Variacao := Abs(StrToFloat(sValor)-RsDb.FieldByName('Vl_CreditoReal').AsExtended);
                  if Variacao/RsDb.FieldByName('Vl_CreditoReal').AsExtended <= Extended(gLimiteVariacao/100) then
                    begin
                    RsDb.Edit;
                    break;
                    end;
                  RsDb.Next;
                  end;
                if RsDb.EOF then
                  RsDb.Insert;
                end
              else
                RsDb.Insert;
              end
            else
              RsDb.Insert;
             end
          else
            RsDb.Insert;
          end
        else
          begin
          // se tiver + de um lançamento, matar o mais antigo (3/11/00)
          RsDb.Last;
          if RsDb.RecordCount > 1 then
            begin
            RsDb.First;
            DataLocal := Now;
            while not RsDb.EOF do
              begin
              if (TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataAux)) then
                if DataAux < DataLocal then
                  begin
                  DataLocal := DataAux;
                  end;
              if (TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataAux)) then
                if DataAux < DataLocal then
                  begin
                  DataLocal := DataAux;
                  end;
              RsDb.Next;
              end;

            RsDb.First;
            while not RsDb.EOF do
              begin
              if (TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataAux)) then
                if DataAux = DataLocal then
                  break;
              if (TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataAux)) then
                if DataAux = DataLocal then
                  break;
              RsDb.Next;
              end;
            end;
            RsDb.Edit;
          end;

        Begin
        RsDb.FieldByName('cliente').AsString := gCliente;

        RsDb.FieldByName('Data_Debito').AsDateTime := gDataRelatorio;
        RsDb.FieldByName('Cartao').AsString := TiraPontos(sCartao, IntToStr(16));
        RsDb.FieldByName('Cartao1').AsString := TiraPontos(sCartao, IntToStr(13));
        if (sMoeda='986') or (sMoeda='000') then
//          RsDb.FieldByName('Vl_DebitoReal').AsCurrency := FormataValor(sValor)
          RsDb.FieldByName('Vl_DebitoReal').AsCurrency := StrToFloat(sValor)
        else
          begin
          RsDb.FieldByName('Vl_DebitoDolar').AsCurrency := StrToFloat(sValor);
          RsDb.FieldByName('Vl_DebitoDolar').AsCurrency := StrToFloat(sValor);
          RsDb.FieldByName('Taxa_Debito').AsCurrency := StrToFloat(gTaxa);
          RsDb.FieldByName('Vl_DebitoReal').AsCurrency := RsDb.FieldByName('Vl_DebitoDolar').AsCurrency *
                                                          RsDb.FieldByName('Taxa_Debito').AsCurrency
//                       FormataValor(FloatToStr(RoundTo(FieldByName('Vl_DebitoDolar').AsCurrency *
//                         FieldByName('Taxa_Debito').AsCurrency, -2)));
          end;
        RsDb.FieldByName('Vl_Saldo').AsCurrency := RsDb.FieldByName('Vl_DebitoReal').AsCurrency -
                                                   RsDb.FieldByName('Vl_CreditoReal').AsCurrency;
        RsDb.FieldByName('conta_contabil').AsString := Trim(Concil.ContaContabil);

        // Alterações visando a implementação da CONTABILIDADE
        RsDb.FieldByName('Cod_Deb').AsString := ctDebito[Indice].conta_para;
                  //                       Copy(Buffer, Param.Relatorio.Posicao, Param.Relatorio.Tamanho);
        RsDb.FieldByName('Rel_Deb').AsString := Buffer.Substring(Param.Relatorio.Posicao-1, Param.Relatorio.Tamanho);
        // RsDb.Fields("Dept_Deb") = Mid$(Buffer, Param.Dept.Posicao, Param.Dept.Tamanho)
        RsDb.FieldByName('Depto_Deb').AsString := Buffer.Substring(Param.Dept.Posicao-1, Param.Dept.Tamanho);
        RsDb.FieldByName('Moeda_Deb').AsString := Buffer.Substring(Param.Moeda.Posicao-1, Param.Moeda.Tamanho);

        // Alterações visando a implementação da CONTABILIDADE
        if Length(gObsDeb)>0 then
          RsDb.FieldByName('Obs_Deb').AsString := gObsDeb;
        // If Len(gObsCred) > 0 Then
        // RsDb.Fields("Obs_Cred") = gObsCred
        // End If


        // If gDEBUG Then
        // If CDbl(RsDb.Fields("Vl_DebitoReal")) > 0 Then
        // Buffer = Format$(RsDb.Fields("Vl_DebitoReal"), "###,##0.00")
        // frmLog.RichTextBox1.Text = frmLog.RichTextBox1.Text &
        // Space(12 - Len(Buffer)) & Buffer & Chr(10)
        // End If
        // End If

        RsDb.UpdateRecord;

        if (iPosicao mod 8700) = 69 then
          begin
          RsDb.Active := False;
          //RsDb := nil;
          sSql := 'select * from lancamentos where conta_contabil='#39'';
          sSql := sSql+'999999'+''#39'';
          RsDb.CommandText := sSql;
          RsDb.Active := True;
          end;
        End;  // With
      end;
    end;

  end;
  // Calcula totais depois de processar
  gTotDebito := gTotDebito + GetTotDebito(RsDb.Connection) - lTotDebito;
  gTotCredito := gTotCredito + GetTotCredito(RsDb.Connection) - lTotCredito;

  CloseFile(ArqEntrada);
  RsDb.Close;
  PBar.Close;
  ClienteAdoConnection.Close;
  RsDb.Free;
  ClienteAdoConnection.Free;
end;

function Get_Texto(Tipo: Integer; Var NomeArquivo : String): Boolean;
begin

  Result := false;
  with fMainForm.dlgCommonDialog do begin
    Filter := 'PRN (*.prn)|*.prn|Text (*.txt)|*.txt';
    Title := 'Abrir Arquivo para Atualizar';

    InitialDir := ExtractFileDir(Application.ExeName);
    FileName := '';
    Execute;
    if FileName<>'' then begin
      if Tipo=1 then begin
        NomeArquivo := FileName;
        Result := true;
       end  else  begin
        if ExtractFileName(FileName)=gArquivo then begin
          NomeArquivo := FileName;
          Result := true;
         end  else  begin
          Application.MessageBox('Arquivo não é deste cliente', 'Seleção de Arquivo', MB_ICONSTOP);
        end;
      end;
    end;
  end;
end;

function Get_Texto1: OleVariant;
var
  sPath, sData: String;
begin
              // Esta já está ZERO Compliant
  PedeAlteracao.Caption := 'Data do Movimento';
  PedeAlteracao.Label1.Caption := 'Data (DD/MM/AA)';
  gOpcao := '';
  PedeAlteracao.ShowModal;
  if gOpcao<>'' then begin
    gDataMov := gOpcao;
//    sData := '20'+Copy(gOpcao, 7, 2)+Copy(gOpcao, 4, 2)+Copy(gOpcao, 1, 2);
    sData := '20'+gOpcao.Substring(6, 2)+gOpcao.Substring( 3, 2)+gOpcao.Substring( 0, 2);
    sPath := gAdmPath+'\'+'entrada\';
    // If Dir$(sPath & "*" & sData & ".txt") = "" Then
    // MsgBox "Arquivo Inexistente"
    // Exit Function
    // End If
    // NomeArquivo = Dir$(sPath & "*" & sData & ".txt")
  end;
end;

(*function ExtractFileName(nome: String): String;
var
  I, J: Integer;
begin
  Result := '';
  I := (1+Pos('.', PChar(nome)+1));

  if I<8 then begin
    Exit;
  end;
  sSql := '';
  J := I;
  while (Copy(nome, J, 1)<>'\') do begin
    if (J=1) then begin
      Exit;
    end;
    J := J-1;
  end;
  if J=1 then begin
    Exit;
  end;
  Result := AnsiUpperCase(Copy(nome, J+1, I-J-1));

end;*)

// VBto upgrade warning: st As String  OnWrite(String, TField)
function limpaString(st: String): String;
var
  carac : Char;
  Posição : Integer;
begin
              // Esta já está ZERO Compliant
  Result := '';
  For Posição := 0 to Length(st)-1 do
    begin
    carac := st[Posição];
    if (IsCharNum(carac) or IsCharAlfa(carac)) then
      Result := Result + carac
    else
      Result := Result+' ';
    end;
  Result := Trim(Result);
end;

function IsStringNum(st: String): Boolean;
var
  Posicao: Integer;
begin
              // Esta já está ZERO Compliant
  Result := true;
  Posicao := 0;
  while Posicao <= (Length(st)-1) do begin
    if  not IsCharNum(st[Posicao]) then begin
      Result := false;
      Exit;
    end;
    Posicao := Posicao+1;
  end;
end;

// VBto upgrade warning: ch As String  OnWrite(FixedString)
function IsCharAlfa(ch: Char): Boolean;
begin

  Result := true;

  if (ch>='A') and (ch<='z') then begin
    Exit;
  end;

  if (ch=' ') then begin
    Exit;
  end;

  Result := false;
end;

// VBto upgrade warning: ch As String  OnWrite(FixedString, String)
function IsCharNum(ch : Char): Boolean;
begin

  Result := true;

  if (ch=' ') then begin
    Exit;

  if (ch>='0') and (ch<='9') then begin
    Exit;
  end;

  end;

  Result := false;
end;

// VBto upgrade warning: sData As String  OnWrite(String, VB.TextBox)
function isDataValida(sData: String): Boolean;  OverLoad;
Var
  DataAux : TDateTime;
begin
  // Verifica se uma data é válida e não é futura.

  Result := TryStrToDateTime(sData, DataAux);

  if Result then
    if DataAux > Now then
      Result := false;

  Exit;
end;

function isDataValida(sData: TDateTime): Boolean; OverLoad;
begin
  // Verifica se uma data não é futura.
Result := True;

  if sData > Now then
    Result := false;

end;

function isValorValido(sValor: String): Boolean;
var
  AuxVal : Extended;
begin

AuxVal := 0;

  if TryStrToFloat(sValor, AuxVal) and (AuxVal <> 0) then
    Result := True
  else
    Result := False;

end;

// VBto upgrade warning: sData1 As String  OnWrite(TField, String, TDateTime)
// VBto upgrade warning: sData2 As String  OnWrite(TField, String)
(*function isDataMenorIgual(sData1: TDateTime; sData2: TDateTime): Boolean;
var
  Data1, Data2 : TDateTime;
  FormatSettings : TFormatSettings;
begin
  // Retorna True se Data2 < Data1 (DD/MM/AA ou DD/MM/AAAA)

  Result := true;

  FormatSettings := TFormatSettings.Create(GetThreadLocale);

  if Length(sData1)=8 then
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YY';
    Data1 := StrToDate(sData1, FormatSettings);
    end
  else
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YYYY';
    Data1 := StrToDate(sData1, FormatSettings);
    end;

  if Length(sData2)=8 then
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YY';
    Data2 := StrToDate(sData2, FormatSettings);
    end
  else
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YYYY';
    Data2 := StrToDate(sData2, FormatSettings);
    end;

  Result := Data2 <= Data1;
end;                  *)

// VBto upgrade warning: sData1 As String  OnWrite(TField, TDateTime, String)
(*function isDataMenor(sData1: String; sData2: String): Boolean;
var
  Data1, Data2 : TDateTime;
  FormatSettings : TFormatSettings;
begin
  // Retorna True se Data2 < Data1 (DD/MM/AA ou DD/MM/AAAA)

  FormatSettings := TFormatSettings.Create(GetThreadLocale);

  if Length(sData1)=8 then
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YY';
    Data1 := StrToDate(sData1, FormatSettings);
    end
  else
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YYYY';
    Data1 := StrToDate(sData1, FormatSettings);
    end;

  if Length(sData2)=8 then
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YY';
    Data2 := StrToDate(sData2, FormatSettings);
    end
  else
    begin
    FormatSettings.ShortTimeFormat := 'DD/MM/YYYY';
    Data2 := StrToDate(sData2, FormatSettings);
    end;

  Result := Data2 < Data1;
end;            *)

procedure ReCalcula(dData: TDateTime);
var
  sToday,
  DataDebito,
  DataCredito: TDateTime;
  ClienteADOConnection : TAdoConnection;
  RsDb : TAdoDataSet;
begin
//  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);

  if not Conecta(ClienteADOConnection, gDataPath+gDataFile + '.udl') then
    Exit;

  RsDb := TAdoDataSet.Create(nil);
  RsDb.Connection := ClienteADOConnection;

  sSql := 'Select * from [Lancamentos]';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  RsDb.CommandText := sSql;
  RsDb.Active := True;

  sToday := 0; // Avoid compiler warning

  if not RsDb.EOF then
    begin
    sToday := Date;
    if dData <> 0 then
      begin
      sToday := dData;
      end;
    end;

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Recalculando Dias de Pendências';

    begin
    if  not RsDb.EOF then
      begin
      RsDb.Last;
      RsDb.First;
      end;

      while  not EOF do
        begin
        PBar.ProgressBar1.Position := RsDb.RecordCount div RsDb.RecNo;
        Application.ProcessMessages;

        RsDb.Edit;

      if Concil.Natureza='D' then
        begin
        if TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataDebito) then
          begin
          if TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataCredito) then
            begin
            // .Fields("Dias_Pendentes") = .Fields("Data_Credito") - .Fields("Data_Debito")
            RsDb.FieldByName('Dias_Pendentes').AsInteger := 0;
            end
          else
            begin
            RsDb.FieldByName('Dias_Pendentes').AsExtended := Abs(sToday - RsDb.FieldByName('Data_Debito').AsDateTime);
            end;
          end
        else
          begin
          RsDb.FieldByName('Dias_Pendentes').AsExtended := Abs(sToday-RsDb.FieldByName('Data_Credito').AsDateTime);
          end;

        // Recalcula o saldo
        // .Fields("Vl_Saldo") = .Fields("Vl_DebitoReal") - .Fields("Vl_CreditoReal")
        end
      else
        begin
        if TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataCredito) then
          begin
          if TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataDebito) then
            begin
            RsDb.FieldByName('Dias_Pendentes').AsExtended := Abs(RsDb.FieldByName('Data_Debito').AsDateTime -
                                                                 RsDb.FieldByName('Data_Credito').AsDateTime);
            end
          else
            begin
            RsDb.FieldByName('Dias_Pendentes').AsExtended := Abs(sToday-RsDb.FieldByName('Data_Credito').AsDateTime);
            end;
          end
        else
          begin
          RsDb.FieldByName('Dias_Pendentes').AsExtended := Abs(sToday-RsDb.FieldByName('Data_Debito').AsDateTime);
          end;

        // Recalcula o saldo
        // .Fields("Vl_Saldo") = .Fields("Vl_DebitoReal") - .Fields("Vl_CreditoReal")
      end;
      RsDb.UpdateRecord;
      RsDb.Next;
    end;
  end;

  PBar.Close;
  ClienteADOConnection.Close;
  RsDb.Close;
  ClienteADOConnection.Free;
  RsDb.Free;

end;

procedure MontaRelatorio(Data1: TDateTime; Data2: TDateTime; Com: Boolean);
var
  RsLocal: TAdoTable;
  Rsdb: TADODataSet;
  gBanco,
  DbLocal: TAdoConnection; // Database;
begin
  if Length(Trim(gConciliacao))=0 then begin
    ShowMessage('Selecione Conciliação');
    Exit;
  end;
  if Com then begin
    ReCalcula(gAtualizacao);
  end;

  RsLocal := TAdoTable.Create(nil);
  Rsdb := TADODataSet.Create(nil);

  if not Conecta(gBanco, gDataPath+gDataFile + '.udl') then
    Exit;
  if not Conecta(DbLocal, gAdmPath+'\admin' + '.udl') then
    Exit;

  // Deleta Dados de Relatorio
  // sSql = "delete from Relatorio"
  // DbLocal.Execute sSql
  // Grava Período na tabela
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // If RsLocal.EOF Then
  // RsLocal.AddNew
  // Else
  // RsLocal.Edit
  // End If
  // If Len(Data1) = 0 Then
  // RsLocal.Fields("De") = Null
  // RsLocal.Fields("Ate") = Null
  // Else
  // RsLocal.Fields("De") = CDate(Data1)
  // RsLocal.Fields("Ate") = CDate(Data1)
  // End If
  // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
  // RsLocal.Fields("Nome_Reduzido") = gCliente
  //
  // RsLocal.Fields("nm_conciliacao") = gConciliacao
  // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  // RsLocal.Update

  // Faz tudo comentado acima



  GravaHeaderRel(DbLocal, RsLocal, 1);

//  sSql := '';
//  sSql := sSql+'Select * from [Relatorio] ';
  sSql := '';
  RsLocal.Connection := DbLocal;
  RsLocal.TableName := 'Relatorio';
  RsLocal.Open;

  sSql := '';
  sSql := sSql+'Select * from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  RsDb.Connection := gBanco;
  RsDb.CommandText := sSql;
  RsDb.Active := True;

  if RsDb.EOF then
    begin
    Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
    Exit;
    end;

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Gerando Relatório';

  begin
    if  not RsDb.EOF then
    begin
      RsDb.Last;
      RsDb.First;
    end;
    while  not RsDb.EOF do
    begin
      PBar.ProgressBar1.Position := RsDb.RecordCount div RsDb.RecNo;
      Application.ProcessMessages;
      if IsOk(Data1, Data2) then
      begin
        RsLocal.Insert;
        RsLocal.FieldByName('Data_Debito').Value := RsDb.FieldByName('Data_Debito').Value;
        RsLocal.FieldByName('Data_Credito').Value := RsDb.FieldByName('Data_Credito').Value;

        if Length(RsLocal.FieldByName('Data_Debito').AsString)=0 then
          RsLocal.FieldByName('Data_Ordem').Value := RsLocal.FieldByName('Data_Credito').Value
        else
          if Length(RsLocal.FieldByName('Data_Credito').AsString)=0 then
            RsLocal.FieldByName('Data_Ordem').Value := RsLocal.FieldByName('Data_Debito').Value;

        if Concil.Natureza='D' then
          if Length(RsLocal.FieldByName('Data_Debito').AsString) <> 0 then
            RsLocal.FieldByName('Data_Ordem').Value := RsLocal.FieldByName('Data_Debito').Value
          else
            RsLocal.FieldByName('Data_Ordem').Value := RsLocal.FieldByName('Data_Credito').Value
        else
          if Length(RsLocal.FieldByName('Data_Credito').AsString) <>0 then
            RsLocal.FieldByName('Data_Ordem').Value := RsLocal.FieldByName('Data_Credito').Value
          else
            RsLocal.FieldByName('Data_Ordem').Value := RsLocal.FieldByName('Data_Debito').Value;

        if (RightStr(RsDb.FieldByName('Cartao').Value, 8) <> '99999999') and
           (RightStr(RsDb.FieldByName('Cartao').Value, 8) <> '99999999') then
          begin
           RsLocal.FieldByName('Cartao').Value := RsDb.FieldByName('Cartao').Value;
          RsLocal.FieldByName('Cartao1').Value := RsDb.FieldByName('Cartao1').Value;
           end
        else
          RsLocal.FieldByName('Cartao').Value := 'Variação Cambial';

        RsLocal.FieldByName('Vl_DebitoDolar').Value := RsDb.FieldByName('Vl_DebitoDolar').Value;
        RsLocal.FieldByName('Taxa_Debito').Value := RsDb.FieldByName('Taxa_Debito').Value;
        RsLocal.FieldByName('Vl_CreditoDolar').Value := RsDb.FieldByName('Vl_CreditoDolar').Value;
        RsLocal.FieldByName('Taxa_Credito').Value := RsDb.FieldByName('Taxa_Credito').Value;
        RsLocal.FieldByName('Vl_DebitoReal').Value := RsDb.FieldByName('Vl_DebitoReal').Value;
        RsLocal.FieldByName('Vl_CreditoReal').Value := RsDb.FieldByName('Vl_CreditoReal').Value;
        RsLocal.FieldByName('Variacao').Value := RsDb.FieldByName('Variacao').Value;
        RsLocal.FieldByName('Vl_Saldo').Value := RsDb.FieldByName('Vl_Saldo').Value;
        RsLocal.FieldByName('Dias_Pendentes').Value := RsDb.FieldByName('Dias_Pendentes').Value;

        if  RsDb.FieldByName('Cod_Deb').AsString <> '' then
          RsLocal.FieldByName('Obs_Deb').Value := Rsdb.FieldByName('Cod_Deb').AsString.Substring(0, 6);

        if  RsDb.FieldByName('Cod_Cred').AsString <> '' then
          RsLocal.FieldByName('Obs_Cred').Value := RsDb.FieldByName('Cod_Cred').AsString.Substring(0, 6);

        RsLocal.UpdateRecord;
      end;
      RsDb.Next;
    end;
  end;

  RsLocal.Close;
  RsDb.Close;
  DbLocal.Close;
  gBanco.Close;

  PBar.Hide;
  Application.ProcessMessages;

  RsLocal.Free;
  RsDb.Free;
  DbLocal.Free;
  gBanco.Free;

  (*  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';       Aqui o relatório era montado...
  if Length(Data1)=0 then begin
    if Com then begin
      fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\ba_ge_co.rpt';
     end  else  begin
      fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\rcontge0.rpt';
    end;
   end  else  begin
    if Com then begin
      fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\ba_ge_co.rpt';
     end  else  begin
      fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\rcontge0.rpt';
    end;
  end;
  if gOrdem=1 then begin
    fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
   end  else  begin
    fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Cartao}';
  end;
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;*)

end;

procedure MontaRelatorioSaldo(Data1: TDateTime; Com: Boolean);
label
  Erro;
var
  RsLocal : TAdoTable;
  Rsdb: TADODataSet;
  gBanco,
  DbLocal,
  DbHist: TAdoConnection; // Database;

  DataAux, myData: TDateTime;
  TemDebito, TemCredito, Primeiro: Boolean;
begin
  try  // On Error GoTo Erro

    if Length(Trim(gConciliacao))=0 then
    begin
      ShowMessage('Selecione Conciliação');
      Exit;
    end;

    if Com then
      ReCalcula(gAtualizacao);

    if not Conecta(gBanco, gDataPath+gDataFile + '.udl') then
      Exit;
    if not Conecta(DbLocal, gAdmPath+'\admin' + '.udl') then
      Exit;
    if not Conecta(DbHist, gDataPath+'Hist_'+gDataFile + '.udl') then
      Exit;

    RsLocal := TAdoTable.Create(Nil);
    Rsdb := TADODataSet.Create(nil);

    // Deleta Dados de Relatorio
    // sSql = "delete from Relatorio"
    // DbLocal.Execute sSql
    //
    // Grava Período na tabela
    // sSql = ""
    // sSql = sSql & "Select * from [id] "
    // Set RsLocal = DbLocal.OpenRecordset(sSql)
    // If RsLocal.EOF Then
    // RsLocal.AddNew
    // Else
    // RsLocal.Edit
    // End If
    // If Len(Data1) = 0 Then
    // RsLocal.Fields("De") = Null
    // RsLocal.Fields("Ate") = Null
    // Else
    // RsLocal.Fields("Ate") = CDate(Data1)
    //
    // End If
    // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
    //
    // RsLocal.Fields("nm_conciliacao") = gConciliacao
    // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
    // Mid$(Concil.ContaContabil, 3, 2) & "." &
    // Mid$(Concil.ContaContabil, 5, 2)
    // RsLocal.Update

    // Faz tudo comentado acima

    GravaHeaderRel(DbLocal, RsLocal, 1);

    sSql := '';
    sSql := sSql+'Select * from [Relatorio] ';
    RsLocal.Connection := DbLocal;
    RsLocal.TableName := 'Relatorio';
//    RsLocal.CommandText := sSql;
    RsLocal.Open;

    sSql := '';
    sSql := sSql+'Select * from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    // sSql = sSql & " and ((Data_Debito <= CDate('" & Data1 & "')"
    // sSql = sSql & " or Data_Debito = Null)"
    // sSql = sSql & " and (Data_Credito <= CDate('" & Data1 & "')"
    // sSql = sSql & " or Data_Credito = Null))"

    RsDb.Connection := gBanco;
    RsDb.CommandText := sSql;
    RsDb.Active := True;

    if RsDb.EOF then begin
      Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
      Exit;
    end;

    PBar.Show;
    PBar.Label1.Visible := true;
    PBar.ProgressBar1.Visible := true;
    PBar.Label1.Caption := 'Gerando Relatório';
    with RsLocal do
    begin
      if  not RsDb.EOF then
      begin
        RsDb.Last;
        RsDb.First;
      end;
      Primeiro := true;
      while  not RsDb.EOF do
      begin
        PBar.ProgressBar1.Position := RsDb.RecordCount div RsDb.RecNo;
        Application.ProcessMessages;
        // If RsDb.Fields("vl_saldo") <> 0 Then
        // MsgBox "|||||||||||"
        // End If

        if IsOk3(Data1) then begin
          Insert;
          if TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataAux) then
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Debito').Value)
          else
            if TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataAux) then
              // pega data menor
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);

          if (TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataAux)) and
             (TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataAux)) then
            if RsDb.FieldByName('Data_Debito').AsDateTime <= RsDb.FieldByName('Data_Credito').AsDateTime then
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);

          if (RightStr(RsDb.FieldByName('Cartao').AsString, 8) <> '99999999') and
             (RightStr(RsDb.FieldByName('Cartao').AsString, 8) <> '99999999') then
          begin
            VBtoADOFieldSet(RsLocal, 'Cartao', RsDb.FieldByName('Cartao').Value);
            VBtoADOFieldSet(RsLocal, 'Cartao1', RsDb.FieldByName('Cartao1').Value);
          end
          else
            VBtoADOFieldSet(RsLocal, 'Cartao', 'Variação Cambial');

          TemDebito := false;
          TemCredito := false;

          // Se o Débito for menor ou igual a data pedida entra no relatório
          if TryStrToDateTime(RsDb.FieldByName('Data_Debito').AsString, DataAux) then begin
            if Data1 <= RsDb.FieldByName('Data_Debito').AsDateTime then begin
              VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', RsDb.FieldByName('Vl_DebitoDolar').Value);
              VBtoADOFieldSet(RsLocal, 'Taxa_Debito', RsDb.FieldByName('Taxa_Debito').Value);
              VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal', RsDb.FieldByName('Vl_DebitoReal').Value);
              VBtoADOFieldSet(RsLocal, 'Data_Debito', RsDb.FieldByName('Data_Debito').Value);
             end  else  begin
              TemDebito := true;
            end;
          end;
          // Se o Crédito for menor ou igual a data pedida entra no relatório
          if TryStrToDateTime(RsDb.FieldByName('Data_Credito').AsString, DataAux) then begin
            if Data1 <= RsDb.FieldByName('Data_Credito').AsDateTime then begin
              VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', RsDb.FieldByName('Vl_CreditoDolar').Value);
              VBtoADOFieldSet(RsLocal, 'Taxa_Credito', RsDb.FieldByName('Taxa_Credito').Value);
              VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal', RsDb.FieldByName('Vl_CreditoReal').Value);
              VBtoADOFieldSet(RsLocal, 'Data_Credito', RsDb.FieldByName('Data_Credito').Value);
             end  else  begin
              TemCredito := true;
            end;
          end;
          if TemDebito or TemCredito then begin
            VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_DebitoReal').AsCurrency -
                                                 FieldByName('Vl_CreditoReal').AsCurrency);
           end  else  begin
            VBtoADOFieldSet(RsLocal, 'Vl_Saldo', RsDb.FieldByName('Vl_Saldo').Value);
          end;

          // Se a Variação for maior que a data pedida entra no relatório
          if TryStrToDateTime(RsDb.FieldByName('Data_Variacao').AsString, DataAux) then
            begin
            if Data1 <= RsDb.FieldByName('Data_Variacao').AsDateTime then
              VBtoADOFieldSet(RsLocal, 'Variacao', RsDb.FieldByName('Variacao').Value)
            else
              begin
              VBtoADOFieldSet(RsLocal, 'Vl_Saldo', RsDb.FieldByName('Variacao').Value);
              VBtoADOFieldSet(RsLocal, 'Variacao', 0);
              end;
            end;

          VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', RsDb.FieldByName('Dias_Pendentes').Value);
          if  not String.IsNullOrEmpty(RsDb.FieldByName('Cod_Deb').AsString) then begin
            VBtoADOFieldSet(RsLocal, 'Obs_Deb', Copy(RsDb.FieldByName('Cod_Deb').Value, 1, 6));
          end;
          if  not String.IsNullOrEmpty(RsDb.FieldByName('Cod_Cred').AsString) then begin
            VBtoADOFieldSet(RsLocal, 'Obs_Cred', Copy(RsDb.FieldByName('Cod_Cred').Value, 1, 6));
          end;

          UpdateRecord;
        end;
        RsDb.Next;
        if RsDb.EOF and Primeiro then begin
          if (GetMonth(Data1) <> GetMonth(Now)) or (GetYear(Data1)<>GetYear(Now)) then begin
            ShowMessage('Verifica Histórico');
            sSql := '';
            sSql := sSql+'Select * from [Lancamentos] ';
            sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
            //RsDb := DbHist.OpenRecordset(sSql);

            RsDb.Connection := DbHist;
            RsDb.CommandText := sSql;
            RsDb.Active := True;

            if  not RsDb.EOF then begin
              RsDb.Last;
              RsDb.First;
            end;
            PBar.Label1.Caption := 'Gerando Relatório - Verificando Histórico';
          end;
          Primeiro := false;
        end;
      end;
    end;

    sSql := '';
    sSql := sSql+'Select * from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDb.Connection := DbHist;
    RsDb.CommandText := sSql;
    RsDb.Active := True;

    LastAtualiza;
    myData := gAtualizacao;
    if TryStrToDateTime(gData1, DataAux) then begin
      if DataAux <> Now then begin
        if gAtualizacao <= DataAux then begin
          myData := DataAux;
        end;
      end;
    end;

//    sSql := '';
//    sSql := sSql+'Select * from [id] ';
//    RsLocal := DbLocal.OpenRecordset(sSql);
    RsLocal.Connection := DbLocal;
    RsLocal.TableName := 'id';
    RsLocal.Open;
    RsLocal.Edit;

    VBtoADOFieldSet(RsLocal, 'De', myData);
    RsLocal.UpdateRecord;

    RsLocal.Close;
    DbLocal.Close;
    DbHist.Close;
    Rsdb.Close;
    gBanco.Close;

    RsLocal.Free;
    DbLocal.Free;
    DbHist.Free;
    Rsdb.Free;
    gBanco.Free;

    PBar.Hide;
    Application.ProcessMessages;

(*    fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
    if Length(Data1)=0 then begin
      if Com then begin
        fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\ba_ge_co.rpt';
       end  else  begin
        fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\rcontge0.rpt';
      end;
     end  else  begin
      if Com then begin
        fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\ba_ge_co.rpt';
       end  else  begin
        fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\rcontge0.rpt';
      end;
    end;
    if gOrdem=1 then begin
      fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
     end  else  begin
      fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Cartao}';
    end;

    fMainForm.CrystalReport1.WindowState := crptMaximized;
    fMainForm.CrystalReport1.WindowState := crptMaximized;
    Result := fMainForm.CrystalReport1.PrintReport;
    if Result<>0 then begin
      ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
    end;
    // fMainForm.CrystalReport1.Action = 1
    Exit;                          *)

  except  On E:exception do
    ShowMessage(E.Message);
    { Resume Next }
  end;
end;

procedure MontaRelPendencias(Data1: TDateTime; Com: Boolean);
(*var
  RsLocal: TADODataSet;
  DbLocal: Database;
  myData: TDateTime;
  Count: Integer;
  TemDebito, TemCredito, TemVariacao: Boolean;*)
begin         (*
  if Length(Trim(gConciliacao))=0 then begin
    ShowMessage('Selecione Conciliação');
    Exit;
  end;

  if Com then begin
    ReCalcula(gAtualizacao);
  end;

  gWork := DBEngine.Workspaces(0);
  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Deleta Dados de Relatorio
  // sSql = "delete from Relatorio"
  // DbLocal.Execute sSql
  // Grava Período na tabela
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // RsLocal.Edit
  // If Not IsDate(gData1) Then
  // RsLocal.Fields("De") = Null
  // RsLocal.Fields("Ate") = Null
  // Else
  // If IsDate(gData1) Then RsLocal.Fields("De") = CDate(Data1)
  // If IsDate(gData2) Then RsLocal.Fields("Ate") = CDate(gData2)
  // End If
  // RsLocal.Fields("Nome_Cliente") = Relatorio.IdRelatorio
  // RsLocal.Fields("nm_conciliacao") = gConciliacao
  // RsLocal.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  // RsLocal.Update

  // Faz tudo comentado acima
  GravaHeaderRel(DbLocal, RsLocal, 2);

  sSql := '';
  sSql := sSql+'Select * from [Relatorio] ';
  RsLocal := DbLocal.OpenRecordset(sSql);

  sSql := '';
  sSql := sSql+'Select * from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  RsDb := gBanco.OpenRecordset(sSql);

  if RsDb.EOF then begin
    Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
    Exit;
  end;

  Count := 0;
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Gerando Relatório';
  with RsLocal do begin
    while  not RsDb.EOF do begin
      PBar.ProgressBar1.Position := RsDb.RecordCount div RsDb.RecNo;
      // If (RsDb.Fields("Vl_Saldo") <> 0) Then
      // MsgBox "!"
      // End If
      Application.ProcessMessages;
      // If IsOk(Data1, Data2) And (RsDb.Fields("Vl_Saldo") <> 0) Then
      // .AddNew
      // .Fields("Data_Debito") = RsDb.Fields("Data_Debito")
      // .Fields("Data_Credito") = RsDb.Fields("Data_Credito")
      // 
      // If IsDate(.Fields("Data_Debito")) Then
      // .Fields("Data_Ordem") = .Fields("Data_Debito")
      // Else
      // If IsDate(.Fields("Data_Credito")) Then
      // .Fields("Data_Ordem") = .Fields("Data_Credito")
      // End If
      // End If
      // If (IsDate(.Fields("Data_Debito"))) And (IsDate(.Fields("Data_Credito"))) Then
      // se data_credito menor que data_debito pega data_credito
      // If isDataMenorIgual(.Fields("Data_Debito"), .Fields("Data_Credito")) Then
      // .Fields("Data_Ordem") = RsDb.Fields("Data_Credito")
      // End If
      // End If
      // 
      // 
      // If (Right(RsDb.Fields("Cartao"), 8) <> "99999999") And (Right(RsDb.Fields("Cartao"), 8) <> "99999999") Then
      // .Fields("Cartao") = RsDb.Fields("Cartao")
      // .Fields("Cartao1") = RsDb.Fields("Cartao1")
      // Else
      // .Fields("Cartao") = "Variação Cambial"
      // 
      // End If
      // .Fields("Vl_DebitoDolar") = RsDb.Fields("Vl_DebitoDolar")
      // .Fields("Taxa_Debito") = RsDb.Fields("Taxa_Debito")
      // .Fields("Vl_CreditoDolar") = RsDb.Fields("Vl_CreditoDolar")
      // .Fields("Taxa_Credito") = RsDb.Fields("Taxa_Credito")
      // .Fields("Vl_DebitoReal") = RsDb.Fields("Vl_DebitoReal")
      // .Fields("Vl_CreditoReal") = RsDb.Fields("Vl_CreditoReal")
      // .Fields("Variacao") = RsDb.Fields("Variacao")
      // .Fields("Vl_Saldo") = RsDb.Fields("Vl_Saldo")
      // .Fields("Dias_Pendentes") = RsDb.Fields("Dias_Pendentes")
      // If Not IsNull(RsDb.Fields("Observacao")) Then
      // .Fields("Observacao") = RsDb.Fields("Observacao")
      // End If
      // .Update
      // Count = Count + 1
      // End If

      // O trecho acima do programa esta sendo substituido pelo trecho do Balancete
      // de modo que a única diferença entre os dois relatórios é que na pendência
      // não aparecem os lançamentos com saldo zero

      if IsOk3(Data1) then begin
        Insert;
        if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
          VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Debito').Value);
         end  else  begin
          if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
            // pega data menor
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
          end;
        end;
        if (TryStrToDateTime(RsDb.FieldByName('Data_Debito'))) and (TryStrToDateTime(RsDb.FieldByName('Data_Credito'))) then begin
          if isDataMenorIgual(String(RsDb.FieldByName('Data_Debito').Value), String(RsDb.FieldByName('Data_Credito').Value)) then begin
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
          end;
        end;

        if (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') then begin
          VBtoADOFieldSet(RsLocal, 'Cartao', RsDb.FieldByName('Cartao').Value);
          VBtoADOFieldSet(RsLocal, 'Cartao1', RsDb.FieldByName('Cartao1').Value);
         end  else  begin
          VBtoADOFieldSet(RsLocal, 'Cartao', 'Variação Cambial');
        end;
        TemDebito := false;
        TemCredito := false;
        TemVariacao := true;

        // Se o Débito for menor ou igual a data pedida entra no relatório
        if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
          if isDataMenorIgual(Data1, String(RsDb.FieldByName('Data_Debito').Value)) then begin
            VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', RsDb.FieldByName('Vl_DebitoDolar').Value);
            VBtoADOFieldSet(RsLocal, 'Taxa_Debito', RsDb.FieldByName('Taxa_Debito').Value);
            VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal', RsDb.FieldByName('Vl_DebitoReal').Value);
            VBtoADOFieldSet(RsLocal, 'Data_Debito', RsDb.FieldByName('Data_Debito').Value);
           end  else  begin
            TemDebito := true;
          end;
        end;
        // Se o Crédito for menor ou igual a data pedida entra no relatório
        if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
          if isDataMenorIgual(Data1, String(RsDb.FieldByName('Data_Credito').Value)) then begin
            VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', RsDb.FieldByName('Vl_CreditoDolar').Value);
            VBtoADOFieldSet(RsLocal, 'Taxa_Credito', RsDb.FieldByName('Taxa_Credito').Value);
            VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal', RsDb.FieldByName('Vl_CreditoReal').Value);
            VBtoADOFieldSet(RsLocal, 'Data_Credito', RsDb.FieldByName('Data_Credito').Value);
           end  else  begin
            TemCredito := true;
          end;
        end;
        if TemDebito or TemCredito then begin
          VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_DebitoReal')-FieldByName('Vl_CreditoReal'));
         end  else  begin
          VBtoADOFieldSet(RsLocal, 'Vl_Saldo', RsDb.FieldByName('Vl_Saldo').Value);
        end;

        // Se a Variação for maior que a data pedida entra no relatório
        if TryStrToDateTime(RsDb.FieldByName('Data_Variacao')) then begin
          if isDataMenorIgual(Data1, String(RsDb.FieldByName('Data_Variacao').Value)) then begin
            VBtoADOFieldSet(RsLocal, 'Variacao', RsDb.FieldByName('Variacao').Value);
            TemVariacao := false;
           end  else  begin
            VBtoADOFieldSet(RsLocal, 'Vl_Saldo', RsDb.FieldByName('Variacao').Value);
            VBtoADOFieldSet(RsLocal, 'Variacao', CDbl(0));
          end;
        end;

        VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', RsDb.FieldByName('Dias_Pendentes').Value);
        if  not IsNull(RsDb.FieldByName('Cod_Deb')) then begin
          VBtoADOFieldSet(RsLocal, 'Obs_Deb', Copy(RsDb.FieldByName('Cod_Deb').Value, 1, 6));
        end;
        if  not IsNull(RsDb.FieldByName('Cod_Cred')) then begin
          VBtoADOFieldSet(RsLocal, 'Obs_Cred', Copy(RsDb.FieldByName('Cod_Cred').Value, 1, 6));
        end;
        UpdateRecord;
        Count := Count+1;
      end;

      RsDb.Next;
    end;
  end;

  if Count=0 then begin
    Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
    RsLocal.Close;
    DbLocal.Close;
    RsLocal := nil;
    DbLocal := nil;
    Desconecta;
    PBar.Hide;
    Exit;
  end;

  sSql := '';
  sSql := sSql+'Select * from [Lancamentos] ';
  sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
  RsDb := gBanco.OpenRecordset(sSql);

  sSql := 'delete from Relatorio';
  sSql := sSql+' where vl_saldo = 0';
  DbLocal.Execute(sSql);

  sSql := '';
  sSql := sSql+'Select * from [Relatorio] ';
  RsLocal := DbLocal.OpenRecordset(sSql);
  // Cria um registro para enganar o Crystal Report
  if RsLocal.EOF then begin
    RsLocal.Insert;
    VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', 1);
    RsLocal.UpdateRecord;
    // Else
    // RsLocal.Edit
    // RsLocal.Fields("Dias_Pendentes") = 1
    // RsLocal.Update
  end;


  // LastAtualiza
  // myData = gAtualizacao
  // If IsDate(gData1) Then
  // If CDate(gData1) <> Now Then
  // If isDataMenorIgual(gAtualizacao, gData1) Then
  // myData = gData1
  // End If
  // End If
  // End If
  // 
  // sSql = ""
  // sSql = sSql & "Select * from [id] "
  // Set RsLocal = DbLocal.OpenRecordset(sSql)
  // RsLocal.Edit
  // RsLocal.Fields("De") = myData
  // RsLocal.Update

  RsLocal.Close;
  DbLocal.Close;
  RsLocal := nil;
  DbLocal := nil;
  Desconecta;

  PBar.Hide;
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  if Com then begin
    fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\pe_ge_co.rpt';
   end  else  begin
    fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\rcontpe0.rpt';
  end;
  if gOrdem=1 then begin
    fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Data_Ordem}';
   end  else  begin
    fMainForm.CrystalReport1.SortFields(0) := '+{Relatorio.Cartao}';
  end;
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;
  // fMainForm.CrystalReport1.Action = 1   *)
end;

procedure MontaRelatorioSaci(Data1: TDateTime; Saci: Boolean);
(*var
  RsLocal: TADODataSet;
  DbLocal: Database;
  myData: TDateTime;
  Count: Integer;
  NomeSaci, Buffer: String;
  ArqEntrada: Integer;*)
begin
(*  sSql := '20'+Copy(gDataRelatorio, 7, 2)+Copy(gDataRelatorio, 4, 2)+Copy(gDataRelatorio, 1, 2);
  NomeSaci := ExtractFileDir(Application.ExeName)+'\'+gCliente+'\Interface\Saci_'+sSql+'.txt';
  if Dir(NomeSaci)='' then begin
    ShowMessage(PChar('Arquivo: '+NomeSaci+' não localizado!!!'));
    Exit;
  end;

  ArqEntrada := 1{indifferently};
  AssignFile(FileHandle_ArqEntrada, NomeSaci); Reset(FileHandle_ArqEntrada);
  // ArqSaci = FreeFile
  // Open NomeSaci For Output As #ArqSaci

  Count := 0;

  gWork := DBEngine.Workspaces(0);
  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Faz tudo comentado acima
  GravaHeaderRel(DbLocal, RsLocal, 2);


  sSql := '';
  sSql := sSql+'Select * from [relInterface] ';
  RsLocal := DbLocal.OpenRecordset(sSql);

  Count := 0;
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Gerando Relatório';
  with RsLocal do begin

    while  not Eof(FileHandle_ArqEntrada) do begin
      // PBar.ProgressBar1.Value = RsDb.PercentPosition
      ReadLn(FileHandle_ArqEntrada, Buffer);
      // Do While Not Len(Buffer) = 0 And Not EOF(ArqEntrada)
      // Line Input #ArqEntrada, Buffer
      // Loop
      Count := Count+1;
      if Length(Buffer)>0 then begin
        Insert;
        VBtoADOFieldSet(RsLocal, 'RegInterface', Buffer);
        UpdateRecord;
      end;
    end;
  end;

  if Count=0 then begin
    Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
    RsLocal.Close;
    DbLocal.Close;
    RsLocal := nil;
    DbLocal := nil;
    Desconecta;
    PBar.Hide;
    Exit;
  end;


  RsLocal.Close;
  DbLocal.Close;
  RsLocal := nil;
  DbLocal := nil;
  Desconecta;

  PBar.Hide;
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  if Saci then begin
    fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\relInterf.rpt';
   end  else  begin
    fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\relInterf.rpt';
  end;
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;    *)
end;

procedure MontaRelatorioInterface(Data1: TDateTime; Saci: Boolean);
(*var
  RsLocal: TADODataSet;
  DbLocal: Database;
  myData: TDateTime;
  Count: Integer;
  NomeInterface, Buffer: String;
  ArqEntrada: Integer;    *)
begin          (*
  sSql := '20'+Copy(gDataRelatorio, 7, 2)+Copy(gDataRelatorio, 4, 2)+Copy(gDataRelatorio, 1, 2);
  NomeInterface := ExtractFileDir(Application.ExeName)+'\'+gCliente+'\Interface\Interface_'+sSql+'.txt';
  if Dir(NomeInterface)='' then begin
    ShowMessage(PChar('Arquivo: '+NomeInterface+' não localizado!!!'));
    Exit;
  end;

  ArqEntrada := 1{indifferently};
  AssignFile(FileHandle_ArqEntrada, NomeInterface); Reset(FileHandle_ArqEntrada);
  // ArqSaci = FreeFile
  // Open NomeSaci For Output As #ArqSaci

  Count := 0;

  gWork := DBEngine.Workspaces(0);
  gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // Faz tudo comentado acima
  GravaHeaderRel(DbLocal, RsLocal, 2);


  sSql := '';
  sSql := sSql+'Select * from [relInterface] ';
  RsLocal := DbLocal.OpenRecordset(sSql);

  Count := 0;
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Gerando Relatório';
  with RsLocal do begin

    while  not Eof(FileHandle_ArqEntrada) do begin
      // PBar.ProgressBar1.Value = RsDb.PercentPosition
      ReadLn(FileHandle_ArqEntrada, Buffer);
      // Do While Not Len(Buffer) = 0 And Not EOF(ArqEntrada)
      // Line Input #ArqEntrada, Buffer
      // Loop
      Count := Count+1;
      if Length(Buffer)>0 then begin
        Insert;
        VBtoADOFieldSet(RsLocal, 'RegInterface', Buffer);
        UpdateRecord;
      end;
    end;
  end;

  if Count=0 then begin
    Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
    RsLocal.Close;
    DbLocal.Close;
    RsLocal := nil;
    DbLocal := nil;
    Desconecta;
    PBar.Hide;
    Exit;
  end;


  RsLocal.Close;
  DbLocal.Close;
  RsLocal := nil;
  DbLocal := nil;
  Desconecta;

  PBar.Hide;
  fMainForm.CrystalReport1.DataFiles(0) := gAdmPath+'\admin.mdb';
  if Saci then begin
    fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\relInterf.rpt';
   end  else  begin
    fMainForm.CrystalReport1.ReportFileName := gAdmPath+'\relInterf.rpt';
  end;
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  fMainForm.CrystalReport1.WindowState := crptMaximized;
  Result := fMainForm.CrystalReport1.PrintReport;
  if Result<>0 then begin
    ShowMessage(PChar('Erro '+IntToStr(Result)+' no Relatório'));
  end;            *)
end;

procedure MontaRelExcell(var Data1: TDateTime; Com: Boolean; Msg: Boolean);
(*label
  Erro, Saida, Saida2;
const
  TamObs = 20;
var
  RsLocal: TADODataSet;
  DbLocal: Database;
  myData: TDateTime;
  Count: Integer;
  TemDebito, TemCredito, TemVariacao: Boolean;
  I: Integer;
  Linha, Linha2, fName: String;
  xlBook: Variant;
  xlSheet: Variant;
  xlApp: TObject;        *)
begin
  // Tamanho do Campo Observação

   (*
  if  not ChecaModelo then begin
    ShowMessage('Modelo de Planilha não Encontrado!');
    Exit;
  end;
  try  // On Error GoTo Erro

    // Declare variable to hold the reference.

    if Length(Trim(gConciliacao))=0 then begin
      ShowMessage('Selecione Conciliação');
      Exit;
    end;


    // If IsDate(gAtualizacao) Then
    // gData1 = gAtualizacao
    // Else
    // gData1 = Format$(Now, "DD/MM/YYYY")
    // End If

    if  not TryStrToDateTime(Data1) then begin
      Data1 := FormatVB(Now,'DD/MM/YYYY');
    end;


    gWork := DBEngine.Workspaces(0);
    gBanco := gWork.OpenDatabase(gDataPath+gDataFile);
    DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

    sSql := '';
    sSql := sSql+'Select * from [Relatorio] ';
    RsLocal := DbLocal.OpenRecordset(sSql);

    sSql := '';
    sSql := sSql+'Select * from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    RsDb := gBanco.OpenRecordset(sSql);

    if RsDb.EOF then begin
      Desconecta;
      Exit;
    end;

    if Com then begin
      ReCalcula(gAtualizacao);
    end;

    xlApp := CreateOleObject('excel.application');

    if Com then begin
      // Set xlBook = GetObject(gAdmPath & "\modelo1.xls")
      xlBook := GetObject(gTempDir+'modelo1A.xls');
      xlSheet := xlBook.Sheets(1);
     end  else  begin
      // Set xlBook = GetObject(gAdmPath & "\modelo2.xls")
      xlBook := GetObject(gTempDir+'modelo2.xls');
      xlSheet := xlBook.Sheets(1);
    end;

    if String(gExcelPath)='' then begin
      repeat
        fName := xlApp.GetSaveAsFilename;
        fName := Application.GetSaveAsFilename;
      until fName<>'';
    end;

    if (1+Pos('*', PChar(gConciliacao)+1))>0 then begin
      sSql := Trim(Copy(gConciliacao, 3, Length(gConciliacao)-2));
     end  else  begin
      sSql := Trim(gConciliacao);
    end;

    if RightStr(gExcelPath, 1)<>'\' then begin
      fName := String(gExcelPath)+'\'+sSql+'.xls';
     end  else  begin
      fName := String(gExcelPath)+sSql+'.xls';
    end;

    if Length(fName)=0 then begin
      goto Saida2;
    end;
    if (1+Pos('.', PChar(fName)+1))=Length(fName) then begin
      fName := fName+'xls';
    end;
    sSql := 'delete from Relatorio';
    DbLocal.Execute(sSql);

    // Grava Período na tabela
    sSql := '';
    sSql := sSql+'Select * from [id] ';
    RsLocal := DbLocal.OpenRecordset(sSql);

    // Grava dados do Header do Relatório
    xlSheet.Range['A2'].Value := Relatorio.IdRelatorio;

    xlSheet.Range['B3'].Value := '  ';
    if Length(Trim(gConciliacao))>0 then xlSheet.Range['A3'].Value := 'ANALÍTICO - '+gConciliacao;

    xlSheet.Range['B4'].Value := Copy(Concil.ContaContabil, 1, 2)+'.'+Copy(Concil.ContaContabil, 3, 2)+'.'+Copy(Concil.ContaContabil, 5, 2);
    if Com then begin
      xlSheet.Range['G4'].Value := ''#39''+String(CDate(gData1));
      xlSheet.Range['M4'].Value := ''#39''+FormatVB(Now,'DD/MM/YY');
     end  else  begin
      xlSheet.Range['F4'].Value := ''#39''+String(CDate(gData1));
      xlSheet.Range['J4'].Value := ''#39''+FormatVB(Now,'DD/MM/YY');
    end;
    sSql := '';
    sSql := sSql+'Select * from [Relatorio] ';
    RsLocal := DbLocal.OpenRecordset(sSql);

    sSql := '';
    sSql := sSql+'Select * from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    RsDb := gBanco.OpenRecordset(sSql);

    if RsDb.EOF then begin
      if Msg then Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);

      if Dir(fName)<>'' then DeleteFile(fName);
      // xlBook.SaveAs FileName:=fName
      // If Dir$(fName) <> "" Then Kill fName
      // Set xlSheet = Nothing
      // xlBook.Close
      xlBook := Unassigned;

      // xlApp.Quit   ' When you finish, use the Quit method to close
      xlApp := nil; // the application, then release the reference.

      Exit;
    end;
    RsDb.Last;
    RsDb.First;

    Count := 0;
    PBar.Show;
    PBar.Label1.Visible := true;
    PBar.ProgressBar1.Visible := true;
    PBar.Label1.Caption := 'Gerando Arquivo Excell';
    with RsLocal do begin
      while  not RsDb.EOF do begin
        PBar.ProgressBar1.Position := RsDb.RecordCount div RsDb.RecNo;
        Application.ProcessMessages;

        if IsOk3(Data1) then begin
          Insert;
          if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
            VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Debito').Value);
           end  else  begin
            if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
              // pega data menor
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
            end;
          end;
          if (TryStrToDateTime(RsDb.FieldByName('Data_Debito'))) and (TryStrToDateTime(RsDb.FieldByName('Data_Credito'))) then begin
            if isDataMenorIgual(String(RsDb.FieldByName('Data_Debito').Value), String(RsDb.FieldByName('Data_Credito').Value)) then begin
              VBtoADOFieldSet(RsLocal, 'Data_Ordem', RsDb.FieldByName('Data_Credito').Value);
            end;
          end;

          if (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') and (RightStr(RsDb.FieldByName('Cartao').Value, 8)<>'99999999') then begin
            VBtoADOFieldSet(RsLocal, 'Cartao', RsDb.FieldByName('Cartao').Value);
            VBtoADOFieldSet(RsLocal, 'Cartao1', RsDb.FieldByName('Cartao1').Value);
           end  else  begin
            VBtoADOFieldSet(RsLocal, 'Cartao', 'Variação Cambial');
          end;
          TemDebito := false;
          TemCredito := false;
          TemVariacao := true;

          // Se o Débito for menor ou igual a data pedida entra no relatório
          if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
            if isDataMenorIgual(Data1, String(RsDb.FieldByName('Data_Debito').Value)) then begin
              VBtoADOFieldSet(RsLocal, 'Vl_DebitoDolar', RsDb.FieldByName('Vl_DebitoDolar').Value);
              VBtoADOFieldSet(RsLocal, 'Taxa_Debito', RsDb.FieldByName('Taxa_Debito').Value);
              VBtoADOFieldSet(RsLocal, 'Vl_DebitoReal', RsDb.FieldByName('Vl_DebitoReal').Value);
              VBtoADOFieldSet(RsLocal, 'Data_Debito', RsDb.FieldByName('Data_Debito').Value);
             end  else  begin
              TemDebito := true;
            end;
          end;
          // Se o Crédito for menor ou igual a data pedida entra no relatório
          if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
            if isDataMenorIgual(Data1, String(RsDb.FieldByName('Data_Credito').Value)) then begin
              VBtoADOFieldSet(RsLocal, 'Vl_CreditoDolar', RsDb.FieldByName('Vl_CreditoDolar').Value);
              VBtoADOFieldSet(RsLocal, 'Taxa_Credito', RsDb.FieldByName('Taxa_Credito').Value);
              VBtoADOFieldSet(RsLocal, 'Vl_CreditoReal', RsDb.FieldByName('Vl_CreditoReal').Value);
              VBtoADOFieldSet(RsLocal, 'Data_Credito', RsDb.FieldByName('Data_Credito').Value);
             end  else  begin
              TemCredito := true;
            end;
          end;
          if TemDebito or TemCredito then begin
            VBtoADOFieldSet(RsLocal, 'Vl_Saldo', FieldByName('Vl_DebitoReal')-FieldByName('Vl_CreditoReal'));
           end  else  begin
            VBtoADOFieldSet(RsLocal, 'Vl_Saldo', RsDb.FieldByName('Vl_Saldo').Value);
          end;

          // Se a Variação for maior que a data pedida entra no relatório
          if TryStrToDateTime(RsDb.FieldByName('Data_Variacao')) then begin
            if isDataMenorIgual(Data1, String(RsDb.FieldByName('Data_Variacao').Value)) then begin
              VBtoADOFieldSet(RsLocal, 'Variacao', RsDb.FieldByName('Variacao').Value);
              TemVariacao := false;
             end  else  begin
              VBtoADOFieldSet(RsLocal, 'Vl_Saldo', RsDb.FieldByName('Variacao').Value);
              VBtoADOFieldSet(RsLocal, 'Variacao', CDbl(0));
            end;
          end;

          VBtoADOFieldSet(RsLocal, 'Dias_Pendentes', RsDb.FieldByName('Dias_Pendentes').Value);
          if  not IsNull(RsDb.FieldByName('Cod_Deb')) then begin
            VBtoADOFieldSet(RsLocal, 'Obs_Deb', Copy(RsDb.FieldByName('Cod_Deb').Value, 1, 6));
          end;
          if  not IsNull(RsDb.FieldByName('Cod_Cred')) then begin
            VBtoADOFieldSet(RsLocal, 'Obs_Cred', Copy(RsDb.FieldByName('Cod_Cred').Value, 1, 6));
          end;
          UpdateRecord;
          Count := Count+1;
        end;

        RsDb.Next;
      end;
    end;
    PBar.ProgressBar1.Position := 100;

    if Count=0 then begin
      Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
      goto Saida;
    end;

    sSql := '';
    sSql := sSql+'Select * from [Lancamentos] ';
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    RsDb := gBanco.OpenRecordset(sSql);

    sSql := 'delete from Relatorio';
    sSql := sSql+' where vl_saldo = 0';
    DbLocal.Execute(sSql);

    RsLocal.Requery;

    if RsLocal.EOF then begin
      if Msg then Application.MessageBox('Relatório vazio.', '', MB_ICONSTOP);
      goto Saida;
    end;

    sSql := 'select * from Relatorio order by Data_Ordem';
    RsDb := DbLocal.OpenRecordset(sSql);

    // Cria os registros de Dados no Excell
    I := 9;

    RsDb.Last;
    RsDb.First;
    with RsDb do begin
      while  not EOF do begin
        PBar.ProgressBar1.Position := RsDb.RecordCount div RsDb.RecNo;
        Application.ProcessMessages;


        Linha := 'A'+Trim(mStr(I));
        xlSheet.Range[Linha].Value := FieldByName('Data_Debito').Value;
        Linha := 'B'+Trim(mStr(I));
        xlSheet.Range[Linha].Value := FieldByName('Data_Credito').Value;

        Linha := 'C'+Trim(mStr(I));
        xlSheet.Range[Linha].Value := FieldByName('Cartao').Value;

        Linha := 'D'+Trim(mStr(I));
        if CDbl(FieldByName('Vl_DebitoDolar').Value)<>0 then xlSheet.Range[Linha].Value := FieldByName('Vl_DebitoDolar').Value;
        Linha := 'E'+Trim(mStr(I));
        if CDbl(FieldByName('Taxa_Debito').Value)<>0 then xlSheet.Range[Linha].Value := FieldByName('Taxa_Debito').Value;
        Linha := 'F'+Trim(mStr(I));
        if CDbl(FieldByName('Vl_CreditoDolar').Value)<>0 then xlSheet.Range[Linha].Value := FieldByName('Vl_CreditoDolar').Value;
        Linha := 'G'+Trim(mStr(I));
        if CDbl(FieldByName('Taxa_Credito').Value)<>0 then xlSheet.Range[Linha].Value := FieldByName('Taxa_Credito').Value;
        Linha := 'H'+Trim(mStr(I));
        if CDbl(FieldByName('Vl_DebitoReal').Value)<>0 then xlSheet.Range[Linha].Value := FieldByName('Vl_DebitoReal').Value;
        Linha := 'I'+Trim(mStr(I));
        if CDbl(FieldByName('Vl_CreditoReal').Value)<>0 then xlSheet.Range[Linha].Value := FieldByName('Vl_CreditoReal').Value;

        Linha := 'J'+Trim(mStr(I));
        if CDbl(FieldByName('Variacao').Value)<>0 then xlSheet.Range[Linha].Value := FieldByName('Variacao').Value;
        Linha := 'K'+Trim(mStr(I));
        xlSheet.Range[Linha].Value := FieldByName('Vl_Saldo').Value;
        if Com then begin
          Linha := 'L'+Trim(mStr(I));
          xlSheet.Range[Linha].Value := FieldByName('Dias_Pendentes').Value;

          // Alterações visando a implementação da CONTABILIDADE
          Linha := 'M'+Trim(mStr(I));
          xlSheet.Range[Linha].Value := FieldByName('Obs_Deb').Value;

          Linha := 'N'+Trim(mStr(I));
          xlSheet.Range[Linha].Value := FieldByName('Obs_Cred').Value;
        end;
        I := I+1;
        Next;
      end;
    end;

    I := I+1;
    Linha := 'J'+Trim(mStr(I));
    xlSheet.Range[Linha].Value := 'SALDO';
    Linha := 'K'+Trim(mStr(I));
    Linha2 := '=SUM(K9:K'+Trim(mStr(I-1))+')';
    xlSheet.Range[Linha].Value := Linha2;
    if Com then begin
      Linha2 := '$A$1:$N$'+Trim(mStr(I));
      xlSheet.PageSetup.PrintArea := Linha2;
     end  else  begin
      Linha2 := '$A$1:$K$'+Trim(mStr(I));
      xlSheet.PageSetup.PrintArea := Linha2;
    end;
    // xlBook.Windows("Modelo.xls").Visible = True
    xlBook.Windows(1).Visible := true;

    PBar.ProgressBar1.Position := 100;

    // Se o arquivo existir, delete
    // Grava arquivo de Saida
    if Dir(fName)<>'' then DeleteFile(fName);
    xlBook.SaveAs(fName);
    xlSheet := Unassigned;
    // xlBook.Close
    xlBook := Unassigned;

    xlApp.Quit; // When you finish, use the Quit method to close
    xlApp := nil; // the application, then release the reference.

    RsLocal.Close;
    DbLocal.Close;
    RsLocal := nil;
    DbLocal := nil;
    Desconecta;

    PBar.Hide;
    Screen.Cursor := crDefault;
    if Msg then Application.MessageBox(PCHAR('Arquivo '+fName+' Gerado!'), '', MB_ICONEXCLAMATION);
    Exit;
  except  // Erro:
    if Err.Number=-2146960888 then { Resume Next }
    if Err.Number=-2147022979 then { Resume Next }
    if Err.Number=-2146960268 then { Resume Next }
    ShowMessage(PChar('Err.Description'));
    // Resume Next
    // On Error Resume Next
  Saida:
    PBar.Hide;
    // Resume Next
    RsLocal.Close;
    RsLocal := nil;
    DbLocal.Close;
    DbLocal := nil;
  Saida2:

    Desconecta;
    xlSheet := Unassigned;
    xlBook := Unassigned;
    if xlApp<>'' then begin
      xlSheet := Unassigned;
      xlBook := Unassigned;
      xlApp.Quit; // When you finish, use the Quit method to close
      // Set xlApp = Nothing   ' the application, then release the reference.
    end;
    Screen.Cursor := crDefault;
  end;              *)
end;

function ChecaModelo: Boolean;

begin

Result := false;

  try  // On Error GoTo Erro

    Result := false;
    if Not DirectoryExists(gTempDir) then
      CreateDir(gTempDir);

    if FileExists(gTempDir+'modelo1A.xls') then
      DeleteFile(gTempDir+'modelo1A.xls');

    CopyFile(PChar(gAdmPath+'\modelo1A.xls'), PChar(gTempDir+'modelo1A.xls'), false);

    if FileExists(gTempDir+'modelo2.xls') then
      DeleteFile(gTempDir+'modelo2.xls');

    CopyFile(PChar(gAdmPath+'\modelo2.xls'), PChar(gTempDir+'modelo2.xls'), false);

    Result := true;
    Exit;
  except on e : exception do
//    if Err.Number=75 then { Resume Next }
     showmessage('Ocorreu o seguinte erro: '+ e.message);
  end;
end;

function ChecaTempDb: Boolean;
var
  DbTemp: TAdoConnection;
  RsTemp: TAdoDataSet;
  sSql : String;
begin
Result := false;
(*  try  // On Error GoTo Erro

    Result := false;
    if Not DirectoryExists(gTempDir) then
      CreateDir(gTempDir);

    if FileExists(gTempDir+'CC_TempVisa.mdb') then
      DeleteFile(gTempDir+'CC_TempVisa.mdb');

    CopyFile(PChar(gAdmPath+'\CC_TempVisa.mdb'), PChar(gTempDir+'CC_TempVisa.mdb'), false);

    Result := true;
    Exit;
  except  on e : exception do
//    if Err.Number=75 then { Resume Next }
     showmessage('Ocorreu o seguinte erro: '+ e.message);
  end; *)

If Not Conecta(DbTemp, ExtractFileDir(Application.ExeName) + '\TempVisa.udl') Then
  Exit;

RsTemp := TAdoDataSet.Create(nil);
RsTemp.Connection := DbTemp;

sSql := 'SELECT TABLE_NAME FROM [SISCOC_TempVisa].INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = ''BASE TABLE''';
RsTemp.CommandText := sSql;
RsTemp.Open;

while not RsTemp.EOF do
  Begin
  sSql := 'TRUNCATE TABLE [SISCOC_TempVisa].[dbo].[' + RsTemp.Fields[0].AsString + '] ';
  DbTemp.Execute(sSql);
  RsTemp.Next;
  End;

DbTemp.Close;
RsTemp.Close;
DbTemp.Free;
RsTemp.Free;

Result := True;

end;

function IsOk(d1: TDateTime; d2: TDateTime): Boolean;
begin
  // Verifica se a data do lançameto esta no intervalo
  // entre d1 e d2
  Result := true;

(*  PRECISAMOS ENTENDER MELHOR O QUE SIGNIFICA EXISTIR d1 e d2

  // se não existe d1, testa só d2
  if  not TryStrToDateTime(d1) and TryStrToDateTime(d2) then begin
    if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
      Ok1 := RsDb.FieldByName('Data_Debito')<=CDate(d2);
      if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
        Ok2 := RsDb.FieldByName('Data_Credito')<=CDate(d2);
      end;
    end else if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
      Ok2 := RsDb.FieldByName('Data_Credito')<=CDate(d2);
    end;
    Result := Ok1 and Ok2;
    Exit;
  end;

  // se não existe d2, testa só d1
  if  not TryStrToDateTime(d1) and TryStrToDateTime(d2) then begin
    if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
      Ok1 := RsDb.FieldByName('Data_Debito')<=CDate(d2);
      if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
        Ok2 := RsDb.FieldByName('Data_Credito')>CDate(d2);
      end;
    end else if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
      Ok2 := RsDb.FieldByName('Data_Credito')>CDate(d2);
    end;
    Result := Ok1 and Ok2;
    Exit;
  end;

  // existem d1 e d2, testa o intervalo
  if TryStrToDateTime(d1) and TryStrToDateTime(d2) then begin
    if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
      Ok1 := (CDate(d2)<=RsDb.FieldByName('Data_Debito')) and (RsDb.FieldByName('Data_Debito')<=CDate(d2));
    end;
    if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
      Ok2 := (CDate(d2)<=RsDb.FieldByName('Data_Credito')) and (RsDb.FieldByName('Data_Credito')<=CDate(d2));
    end;
    Result := Ok1 and Ok2;
    Exit;
  end;
*)
end;

function IsOk2(d1: TDateTime): Boolean;
begin

  Result := true;
  if d1 = 0 then
    Exit;
        // Entender melhor para revisar
(*  if sizeof(RsDb.FieldByName('Data_Debito').Value)>0 then begin
    if isDataMenor(String(RsDb.FieldByName('Data_Debito').Value), d1) and isDataMenor(String(RsDb.FieldByName('Data_Debito').Value), d1) then begin
      Result := false;
      Exit;
    end;
  end;
  if sizeof(RsDb.FieldByName('Data_Credito').Value)>0 then begin
    if isDataMenor(String(RsDb.FieldByName('Data_Credito').Value), d1) then begin
      if isDataMenor(String(RsDb.FieldByName('Data_Credito').Value), d1) then begin
        Result := false;
        Exit;
      end;
    end;
  end;*)

end;

function IsOk3(d1: TDateTime): Boolean;
begin

  Result := true;
  if d1 = 0 then
    Exit;
          // Entender melhor para Revisar
(*  if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) and TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
    if isDataMenor(String(RsDb.FieldByName('Data_Debito').Value), d1) and isDataMenor(String(RsDb.FieldByName('Data_Credito').Value), d1) then begin
      Result := false;
      Exit;
    end;
   end  else  begin
    if TryStrToDateTime(RsDb.FieldByName('Data_Credito')) then begin
      if isDataMenor(String(RsDb.FieldByName('Data_Credito').Value), d1) then begin
        Result := false;
        Exit;
      end;
    end;
    if TryStrToDateTime(RsDb.FieldByName('Data_Debito')) then begin
      if isDataMenor(String(RsDb.FieldByName('Data_Debito').Value), d1) then begin
        Result := false;
        Exit;
      end;
    end;
  end;  *)
end;

function GetDataBaseName(Id: Integer): String;
var
  DbName: String;
  AdminADOConnection,
  ClienteADOConnection : TAdoConnection;
  RsDB : TAdoDataSet;
begin

  if  not Conecta(AdminADOConnection, gAdmPath + '\admin.udl') then
    Exit;

  RsDb := TAdoDataSet.Create(nil);
  RsDb.Connection := AdminADOConnection;

  DbName := fMainForm.mnuClientes[Id-1].Caption;

  sSql := 'Select * from [Clientes] WHERE Nome_Reduzido = ';
  sSql := sSql + #39 + DbName.SubString(1,Length(DbName)-1) + #39;
  RsDb.CommandText := sSql;
  RsDb.Open;

    // Procura cliente correspondente à opção do menu
//  while not RsDb.EOF do
    begin
//    if RsDb.RecNo = Id-1 then
      begin
        DbName := RsDb.FieldByName('Nome_Reduzido').Value;
        gCliente := RsDb.FieldByName('Nome_Reduzido').Value;
        gBandeira := RsDb.FieldByName('BANDEIRA').Value;
        gDataPath := gAdmPath+'\'+gCliente+'\';
        Relatorio.IdRelatorio := RsDb.FieldByName('Nome_Cliente').Value;
        Relatorio.CdCliente := RsDb.FieldByName('Codigo').Value;
        gCodigoCliente := RsDb.FieldByName('codigo_cliente').Value;
      end;
//    RsDb.Next;
    end;

  Result := DbName;

  sSql := 'Select * from [Atualizacao]';

  gDataFile := Result;
  if  not Conecta(ClienteADOConnection, gDataPath+gDataFile + '.udl') then
    Exit;

  RsDb.Close;
  RsDb.Connection := ClienteADOConnection;
  RsDb.CommandText := sSql;
  RsDb.Open;

  if not RsDb.EOF then
    begin
    RsDb.Close;
    sSql := 'select max(atualizacao) from atualizacao';
    RsDb.CommandText := sSql;
    RsDb.Active := True;
    gAtualizacao := RsDb.Fields[0].Value;  // This is a not null field
    end;

  AdminADOConnection.Close;
  ClienteADOConnection.Close;
  RsDB.Close;
  AdminADOConnection.Free;
  ClienteADOConnection.Free;
  RsDB.Free;

end;

// VBto upgrade warning: RsExc As TADODataSet  OnWrite(TADODataSet, Recordset)
procedure Gravalog(RsExc: TADODataSet; sOperacao: String);
var
  MyRs: TADODataSet;
  gBanco : TAdoConnection;
begin
Try
  if not Conecta(gBanco, gDataPath+gDataFile + '.udl') then
    raise Exception.Create('Log não gravado');

  sSql := 'Select * from [log2]';

  MyRs := TADODataSet.Create(nil);
  MyRs.Connection := gBanco;
  MyRs.CommandText := sSql;
  MyRs.Active := True;

  with MyRs do begin
    Insert;
    VBtoADOFieldSet(MyRs, 'Operacao', sOperacao);
    VBtoADOFieldSet(MyRs, 'Operador', gNomeUsuario);
    VBtoADOFieldSet(MyRs, 'Conta_Contabil', Trim(Concil.ContaContabil));

    VBtoADOFieldSet(MyRs, 'Data_Debito_A', RsExc.FieldByName('Data_Debito').Value);
    VBtoADOFieldSet(MyRs, 'Data_Credito_A', RsExc.FieldByName('Data_Credito').Value);
    VBtoADOFieldSet(MyRs, 'Cartao_A', RsExc.FieldByName('Cartao').Value);
    VBtoADOFieldSet(MyRs, 'Vl_DebitoDolar_A', RsExc.FieldByName('Vl_DebitoDolar').Value);
    VBtoADOFieldSet(MyRs, 'Taxa_Debito_A', RsExc.FieldByName('Taxa_Debito').Value);
    VBtoADOFieldSet(MyRs, 'Vl_CreditoDolar_A', RsExc.FieldByName('Vl_CreditoDolar').Value);
    VBtoADOFieldSet(MyRs, 'Taxa_Credito_A', RsExc.FieldByName('Taxa_Credito').Value);
    VBtoADOFieldSet(MyRs, 'Vl_DebitoReal_A', RsExc.FieldByName('Vl_DebitoReal').Value);
    VBtoADOFieldSet(MyRs, 'Vl_CreditoReal_A', RsExc.FieldByName('Vl_CreditoReal').Value);
    VBtoADOFieldSet(MyRs, 'Variacao_A', RsExc.FieldByName('Variacao').Value);
    VBtoADOFieldSet(MyRs, 'Vl_Saldo_A', RsExc.FieldByName('Vl_Saldo').Value);
    // Alterações visando a implementação da CONTABILIDADE
    VBtoADOFieldSet(MyRs, 'Obs_Deb_A', RsExc.FieldByName('Obs_Deb').Value);
    VBtoADOFieldSet(MyRs, 'Obs_Cred_A', RsExc.FieldByName('Obs_Cred').Value);
    UpdateRecord;
  end;

  MyRs.Close;
  gBanco.Close;
  MyRs.Free;
  gBanco.Free;

Except On E:Exception do
  ShowMessage(E.Message);
  End;  // Try

end;

procedure GravaLog3(RsExc: TADODataSet; sOperacao: String);
var
  MyRs: TADODataSet;
  gBanco : TAdoConnection;
begin
Try
  sSql := 'Select * from [log2]';
  MyRs := TADODataSet.Create(nil);
  MyRs.Connection := gBanco;
  MyRs.CommandText := sSql;

  if sOperacao='Inclusão' then
    begin
    if not Conecta(gBanco, gDataPath+gDataFile + '.udl') then
      raise Exception.Create('Log não gravado');

    MyRs.Active := True;

    with MyRs do
      begin
      Insert;
      VBtoADOFieldSet(MyRs, 'Operacao', sOperacao);
      VBtoADOFieldSet(MyRs, 'Operador', gNomeUsuario);
      VBtoADOFieldSet(MyRs, 'Conta_Contabil', Trim(Concil.ContaContabil));

      VBtoADOFieldSet(MyRs, 'Data_Debito_D', RsExc.FieldByName('Data_Debito').Value);
      VBtoADOFieldSet(MyRs, 'Data_Credito_D', RsExc.FieldByName('Data_Credito').Value);
      VBtoADOFieldSet(MyRs, 'Cartao_D', RsExc.FieldByName('Cartao').Value);
      VBtoADOFieldSet(MyRs, 'Vl_DebitoDolar_D', RsExc.FieldByName('Vl_DebitoDolar').Value);
      VBtoADOFieldSet(MyRs, 'Taxa_Debito_D', RsExc.FieldByName('Taxa_Debito').Value);
      VBtoADOFieldSet(MyRs, 'Vl_CreditoDolar_D', RsExc.FieldByName('Vl_CreditoDolar').Value);
      VBtoADOFieldSet(MyRs, 'Taxa_Credito_D', RsExc.FieldByName('Taxa_Credito').Value);
      VBtoADOFieldSet(MyRs, 'Vl_DebitoReal_D', RsExc.FieldByName('Vl_DebitoReal').Value);
      VBtoADOFieldSet(MyRs, 'Vl_CreditoReal_D', RsExc.FieldByName('Vl_CreditoReal').Value);
      VBtoADOFieldSet(MyRs, 'Variacao_D', RsExc.FieldByName('Variacao').Value);
      VBtoADOFieldSet(MyRs, 'Vl_Saldo_D', RsExc.FieldByName('Vl_Saldo').Value);
      // Alterações visando a implementação da CONTABILIDADE
      VBtoADOFieldSet(MyRs, 'Obs_Deb_D', RsExc.FieldByName('Obs_Deb').Value);
      VBtoADOFieldSet(MyRs, 'Obs_Cred_D', RsExc.FieldByName('Obs_Cred').Value);

      VBtoADOFieldSet(MyRs, 'Cod_Deb_D', RsExc.FieldByName('Cod_Deb').Value);
      VBtoADOFieldSet(MyRs, 'Cod_Cred_D', RsExc.FieldByName('Cod_Cred').Value);

      VBtoADOFieldSet(MyRs, 'Rel_Deb_D', RsExc.FieldByName('Rel_Deb').Value);
      VBtoADOFieldSet(MyRs, 'Rel_Cred_D', RsExc.FieldByName('Rel_Cred').Value);
      UpdateRecord;
      end;
    end
  else
    begin
    MyRs.Active := True;
    with MyRs do
      begin
      Insert;
      VBtoADOFieldSet(MyRs, 'Operacao', sOperacao);
      VBtoADOFieldSet(MyRs, 'Operador', gNomeUsuario);
      VBtoADOFieldSet(MyRs, 'Conta_Contabil', Trim(Concil.ContaContabil));

      VBtoADOFieldSet(MyRs, 'Data_Debito_D', RsExc.FieldByName('Data_Debito').Value);
      VBtoADOFieldSet(MyRs, 'Data_Credito_D', RsExc.FieldByName('Data_Credito').Value);
      VBtoADOFieldSet(MyRs, 'Cartao_D', RsExc.FieldByName('Cartao').Value);
      VBtoADOFieldSet(MyRs, 'Vl_DebitoDolar_D', RsExc.FieldByName('Vl_DebitoDolar').Value);
      VBtoADOFieldSet(MyRs, 'Taxa_Debito_D', RsExc.FieldByName('Taxa_Debito').Value);
      VBtoADOFieldSet(MyRs, 'Vl_CreditoDolar_D', RsExc.FieldByName('Vl_CreditoDolar').Value);
      VBtoADOFieldSet(MyRs, 'Taxa_Credito_D', RsExc.FieldByName('Taxa_Credito').Value);
      VBtoADOFieldSet(MyRs, 'Vl_DebitoReal_D', RsExc.FieldByName('Vl_DebitoReal').Value);
      VBtoADOFieldSet(MyRs, 'Vl_CreditoReal_D', RsExc.FieldByName('Vl_CreditoReal').Value);
      VBtoADOFieldSet(MyRs, 'Variacao_D', RsExc.FieldByName('Variacao').Value);
      VBtoADOFieldSet(MyRs, 'Vl_Saldo_D', RsExc.FieldByName('Vl_Saldo').Value);
      // Alterações visando a implementação da CONTABILIDADE
      VBtoADOFieldSet(MyRs, 'Obs_Deb_D', RsExc.FieldByName('Obs_Deb').Value);
      VBtoADOFieldSet(MyRs, 'Obs_Cred_D', RsExc.FieldByName('Obs_Cred').Value);

      VBtoADOFieldSet(MyRs, 'Cod_Deb_D', RsExc.FieldByName('Cod_Deb').Value);
      VBtoADOFieldSet(MyRs, 'Cod_Cred_D', RsExc.FieldByName('Cod_Cred').Value);

      VBtoADOFieldSet(MyRs, 'Rel_Deb_D', RsExc.FieldByName('Rel_Deb').Value);
      VBtoADOFieldSet(MyRs, 'Rel_Cred_D', RsExc.FieldByName('Rel_Cred').Value);
      UpdateRecord;
      end;
    end;

  MyRs.Close;
  gBanco.Close;
  MyRs.Free;
  gBanco.Free;

Except On E:Exception do
  ShowMessage(E.Message);
  End;  // Try

end;

// VBto upgrade warning: RsExc As TADODataSet  OnWrite(Recordset)
procedure GravaLog4(RsExc: TADODataSet; sOperacao: String);
var
  MyRs: TADODataSet;
  gBanco : TAdoConnection;
begin
Try

  Conecta(gBanco, gDataPath + gDataFile + '.udl');

  sSql := 'Select * from [log2]';
  MyRs := TADODataSet.Create(nil);
  MyRs.Connection := gBanco;
  MyRs.CommandText := sSql;
  with MyRs do begin
    Insert;
    VBtoADOFieldSet(MyRs, 'Operacao', sOperacao);
    VBtoADOFieldSet(MyRs, 'Operador', gNomeUsuario);
    VBtoADOFieldSet(MyRs, 'Conta_Contabil', Trim(Concil.ContaContabil));

    VBtoADOFieldSet(MyRs, 'Data_Debito_A', NULL);
    VBtoADOFieldSet(MyRs, 'Data_Credito_A', NULL);

//    if gSalva.Data_Debito<>'00:00:00' then
//    if gSalva.Data_Credito<>'00:00:00' then

    if gSalva.Data_Debito <> 0 then
      VBtoADOFieldSet(MyRs, 'Data_Debito_A', gSalva.Data_Debito);
    if gSalva.Data_Credito <> 0 then
      VBtoADOFieldSet(MyRs, 'Data_Credito_A', gSalva.Data_Credito);
    VBtoADOFieldSet(MyRs, 'Cartao_A', gSalva.Cartao);
    VBtoADOFieldSet(MyRs, 'Vl_DebitoDolar_A', gSalva.Vl_DebitoDolar);
    VBtoADOFieldSet(MyRs, 'Taxa_Debito_A', gSalva.Taxa_Debito);
    VBtoADOFieldSet(MyRs, 'Vl_CreditoDolar_A', gSalva.Vl_CreditoDolar);
    VBtoADOFieldSet(MyRs, 'Taxa_Credito_A', gSalva.Taxa_Credito);
    VBtoADOFieldSet(MyRs, 'Vl_DebitoReal_A', gSalva.Vl_DebitoReal);
    VBtoADOFieldSet(MyRs, 'Vl_CreditoReal_A', gSalva.Vl_CreditoReal);
    VBtoADOFieldSet(MyRs, 'Variacao_A', gSalva.Variacao);
    VBtoADOFieldSet(MyRs, 'Vl_Saldo_A', gSalva.Vl_Saldo);
    VBtoADOFieldSet(MyRs, 'Obs_Deb_A', gSalva.Obs_Deb);
    VBtoADOFieldSet(MyRs, 'Obs_Cred_A', gSalva.Obs_Cred);
    VBtoADOFieldSet(MyRs, 'Cod_Deb_A', gSalva.Obs_Deb);
    VBtoADOFieldSet(MyRs, 'Cod_Cred_A', gSalva.Obs_Cred);
    VBtoADOFieldSet(MyRs, 'Rel_Deb_A', gSalva.Obs_Deb);
    VBtoADOFieldSet(MyRs, 'Rel_Cred_A', gSalva.Obs_Cred);

    VBtoADOFieldSet(MyRs, 'Data_Debito_D', RsExc.FieldByName('Data_Debito').Value);
    VBtoADOFieldSet(MyRs, 'Data_Credito_D', RsExc.FieldByName('Data_Credito').Value);
    VBtoADOFieldSet(MyRs, 'Cartao_D', RsExc.FieldByName('Cartao').Value);
    VBtoADOFieldSet(MyRs, 'Vl_DebitoDolar_D', RsExc.FieldByName('Vl_DebitoDolar').Value);
    VBtoADOFieldSet(MyRs, 'Taxa_Debito_D', RsExc.FieldByName('Taxa_Debito').Value);
    VBtoADOFieldSet(MyRs, 'Vl_CreditoDolar_D', RsExc.FieldByName('Vl_CreditoDolar').Value);
    VBtoADOFieldSet(MyRs, 'Taxa_Credito_D', RsExc.FieldByName('Taxa_Credito').Value);
    VBtoADOFieldSet(MyRs, 'Vl_DebitoReal_D', RsExc.FieldByName('Vl_DebitoReal').Value);
    VBtoADOFieldSet(MyRs, 'Vl_CreditoReal_D', RsExc.FieldByName('Vl_CreditoReal').Value);
    VBtoADOFieldSet(MyRs, 'Variacao_D', RsExc.FieldByName('Variacao').Value);
    VBtoADOFieldSet(MyRs, 'Vl_Saldo_D', RsExc.FieldByName('Vl_Saldo').Value);
    VBtoADOFieldSet(MyRs, 'Obs_Deb_D', RsExc.FieldByName('Obs_Deb').Value);
    VBtoADOFieldSet(MyRs, 'Obs_Cred_D', RsExc.FieldByName('Obs_Cred').Value);
    VBtoADOFieldSet(MyRs, 'Cod_Deb_D', gSalva.Cod_Deb);
    VBtoADOFieldSet(MyRs, 'Cod_Cred_D', gSalva.Cod_Cred);
    VBtoADOFieldSet(MyRs, 'Rel_Deb_D', gSalva.Rel_Deb);
    VBtoADOFieldSet(MyRs, 'Rel_Cred_D', gSalva.Rel_Cred);
    UpdateRecord;
  end;
  MyRs.Close;
  MyRs := nil;

  MyRs.Close;
  gBanco.Close;
  MyRs.Free;
  gBanco.Free;

Except On E:Exception do
  ShowMessage(E.Message);
  End;  // Try
end;

function PegaColunas(NomeArquivo : String): Boolean;
label
  Saida;
var
  I: Integer;
  ArqEntrada: System.Text;
  Buffer: String;
begin
  try  // On Error GoTo Saida
    // Abre o arquivo de entrada
    if FileExists(NomeArquivo) then
      begin
      AssignFile(ArqEntrada, NomeArquivo);
      Reset(ArqEntrada);
      end
    else
      begin
      Result := false;
      Exit;
      end;

    gColuna1 := 0;
    gColuna2 := 0;
    gColuna3 := 0;
    gColuna4 := 0;
    gColuna5 := 0;
    gColuna6 := 0;
    gColuna7 := 0;
    gColuna8 := 0;
    gColuna9 := 0;
    gColuna10 := 0;
    gColuna11 := 0;
    gColuna12 := 0;
    gColuna13 := 0;
    gTamData := 10;

//    while Pos('CTA', Buffer)=0 do
//    while (Pos('9     ', Buffer)=0) or (Pos('9', Buffer)>5) do
    Repeat
      ReadLn(ArqEntrada, Buffer);
    Until Buffer.Contains('CTA');

    while (Buffer.IndexOf('9') > 4) or (Buffer.IndexOf('9     ') = -1) do
      ReadLn(ArqEntrada, Buffer);

    gColuna1 := Buffer.IndexOf('9');
    I := gColuna1+1;   // Não testa mais o primeiro

//    while (Copy(Buffer, I, 1)<>'9') do I := I+1;

    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna2 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna3 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna4 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna5 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna6 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna7 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna8 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna9 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna10 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna11 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna12 := I;
    Inc(I);
    while (I <= Buffer.Length) and (Buffer.Chars[I] <> '9') do
      Inc(I);

    gColuna13 := I;
    if (gColuna1 <> 0) and (gColuna2 <> 0) then begin
      Result := true;
      CloseFile(ArqEntrada);
      Exit;
    end;

    Result := false;
    CloseFile(ArqEntrada);
    Exit;
  except  // Saida:
    ShowMessage('Erro na Importação do Arquivo. Verifique!!!');
    Result := false;
    CloseFile(ArqEntrada);
  end;
end;

function GetCampo(sBuffer: String; var iPonteiro : Integer): String;
var
  Limite: Integer;
  Retorno: String;
begin
  Limite := Length(sBuffer);
  Result := '';

  // localiza inicio do campo
  while (Copy(sBuffer, iPonteiro, 1) = ' ') and (iPonteiro < Limite) do
    Inc(iPonteiro);
  // pega o campo

  while (Copy(sBuffer, iPonteiro, 1) <> ' ') and (iPonteiro <= Limite) do
    begin
    if (Copy(sBuffer, iPonteiro, 1) <> '(') and (Copy(sBuffer, iPonteiro, 1) <> ')') then
      Retorno := Retorno+Copy(sBuffer, iPonteiro, 1)
    else
      gNegativo := true;
    Inc(iPonteiro);
    end;

  // If iPonteiro > gColuna13 - 5 Then
  if iPonteiro > gColuna13 then
    begin
    while (iPonteiro<=Limite) do
      begin
      Retorno := Retorno+Copy(sBuffer, iPonteiro, 1);
      Inc(iPonteiro);
      end;
    end;

Result := Retorno;
end;

function TiraExt(nome: String): String;
var
  I: Integer;
begin
  Result := '';
  I := (1+Pos('.', PChar(nome)+1));
  if I>0 then begin
    Result := Copy(nome, 1, I-1);
  end;

end;

(*function Limpa(Dado: String): String;
begin
  if Length(Trim(Dado))=0 then
    Result := ''
  else
    Result := Trim(Dado);
end; *)

function FormataTexto(Path: String; NArq: String; Tipo: String): Boolean;
const
  fCartao = 1;
  fConta = 2;
  fMoeda = 3;
  fData = 4;
  fValor = 5;
  fRef = 6;
  fRef2 = 7;
  fRef3 = 8;
  fRef4 = 9;
var
  ArqIn, ArqOut: System.Text;
  NomeArqSaida, Buffer, BufSai, sString: String;
  Flags: array[1..9] of Boolean;
  iPosic: Integer;
  iFileLen,
  iPosicao: Extended;
begin
Try
  iPosicao := 0;

  NomeArqSaida := TrocaExt(NArq, 'Txt');

//  NomeArqSaida := Copy(Arq, 1, iPosic-1)+'saida\'+ExtractFileName(Arq)+'.txt';

  // Abre o arquivo de entrada
  if FileExists(NArq) then
    begin
    AssignFile(ArqIn, NArq);
    Reset(ArqIn);
    end
  else
    begin
    result := false;
    exit;
    end;
  iFileLen := FileSizeByName(NArq);

  // Abre o arquivo de saida
  AssignFile(ArqOut, NomeArqSaida);
  Rewrite(ArqOut);

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Formatando Arquivo...';

  //nPar = PegaPar(tipo)
  //nPar := PegaPar;
  PegaPar;
  for iPosic:=Low(Flags) to High(Flags) do
    Flags[iPosic] := false;

  BufSai := StringOfChar(' ', 250);

  ReadLn(ArqIn, Buffer);
  while not Eof(ArqIn) do
    begin
    ReadLn(ArqIn, Buffer);
    iPosic := 0;
    iPosic := PegaString(Buffer, sString, iPosic);
    iPosicao := iPosicao+Length(Buffer)+2;
    if iPosicao/iFileLen<=1 then
      PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
    else
      PBar.ProgressBar1.Position := 100;

    Application.ProcessMessages;

    while iPosic<>0 do
      begin
      if iPosic = Param.Cartao.Posicao then
        begin
        if Length(sString)=Param.Cartao.Tamanho then
          begin
          if Flags[fCartao] then
            begin
            WriteLn(ArqOut, Trim(BufSai));
            LimpaFlags(Flags);
            end;
//          SetToMid(BufSai, iPosic, Copy(sString, 1, Param.Cartao.Tamanho), Param.Cartao.Tamanho);
          BufSai.Insert(iPosic-1, sString.Substring(0,Param.Cartao.Tamanho));
          Flags[fCartao] := true;
          end;
        end;

      if iPosic = Param.Conta.Posicao then
        begin
        if Length(sString)=Param.Conta.Tamanho then
          begin
          if Flags[fConta] then
            begin
            WriteLn(ArqOut, Trim(BufSai));
            LimpaFlags(Flags);
            end;
//          SetToMid(BufSai, iPosic, Copy(sString, 1, Param.Conta.Tamanho), Param.Conta.Tamanho);
          BufSai.Insert(iPosic-1, sString.Substring(0, Param.Conta.Tamanho));
          Flags[fConta] := true;
          end;
        end;

      if iPosic = Param.Data.Posicao then
        begin
        if Length(sString)=Param.Data.Tamanho then
          begin
          if Flags[fData] then
            begin
            WriteLn(ArqOut, Trim(BufSai));
            LimpaFlags(Flags);
            end;
//            SetToMid(BufSai, iPosic, Copy(sString, 1, Param.Data.Tamanho), Param.Data.Tamanho);
          BufSai.Insert(iPosic-1, sString.Substring(0, Param.Data.Tamanho));
          Flags[fData] := true;
          end;
        end;

      if iPosic = Param.Moeda.Posicao then
        begin
        if Length(sString)=Param.Moeda.Tamanho then
          begin
          if Flags[fMoeda] then
            begin
            WriteLn(ArqOut, Trim(BufSai));
            LimpaFlags(Flags);
            end;
//            SetToMid(BufSai, iPosic, Copy(sString, 1, Param.Moeda.Tamanho), Param.Moeda.Tamanho);
          BufSai.Insert(iPosic-1, sString.Substring(0, Param.Moeda.Tamanho));
          Flags[fMoeda] := true;
          end;
       end;

      if iPosic = Param.Valor.Posicao then
        begin
        if Flags[fValor] then
          begin
          WriteLn(ArqOut, Trim(BufSai));
          LimpaFlags(Flags);
          end;
//          SetToMid(BufSai, Param.Valor.Posicao, StringOfChar(' ', Param.Valor.Tamanho), Param.Valor.Tamanho);
//          SetToMid(BufSai, iPosic, Copy(sString, 1, Length(sString)), Param.Valor.Tamanho);
        BufSai.Insert(Param.Valor.Posicao-1, StringOfChar(' ', Param.Valor.Tamanho));
        BufSai.Insert(iPosic-1, sString.Substring(0, Param.Valor.Tamanho));
        Flags[fValor] := true;
        end;

      if iPosic = Param.Ref.Posicao then
        begin
        if Length(sString) = Param.Ref.Tamanho then
          begin
          if Flags[fRef] then
            begin
            WriteLn(ArqOut, Trim(BufSai));
            LimpaFlags(Flags);
            end;
//            SetToMid(BufSai, iPosic, Copy(sString, 1, Param.Ref.Tamanho), Param.Ref.Tamanho);
          BufSai.Insert(iPosic-1, sString.Substring(0, Param.Ref.Tamanho));
          Flags[fRef] := true;
          end;
        end;
      end;
    end;

  WriteLn(ArqOut, Trim(BufSai)); // Grava último registro
  Result := true;
Finally
  CloseFile(ArqIn);
  CloseFile(ArqOut);
  PBar.Close;
  End;  // Try
end;

// VBto upgrade warning: buff As OleVariant --> As String
// VBto upgrade warning: STR As OleVariant  OnWrite(String)
// VBto upgrade warning: Pos As OleVariant --> As Integer
function PegaString(buff: String; var STR: String; Pos: Integer): Integer;
var
  I: Integer;
begin
  I := Pos;
//  if Pos>0 then
  if Pos>=0 then
//    while (Copy(buff, I, 1) <> ' ') and (I < Length(buff)) do
    while (Buff.Chars[I] <> ' ') and (I < Length(buff)) do
      Inc(I);
//  if I=0 then
//    I := 1;
  while (Buff.Chars[I] = ' ') and (I < Length(buff)) do
    Inc(I);

  if I=Length(buff)-1 then
    Result := 0
  else
    Result := I;

  STR := '';
  while (Buff.Chars[I] <> ' ') and (I < Length(buff)) do
    begin
    STR := STR + Buff.Chars[I];
    Inc(I);
    end;

end;

function PegaPar: Integer;
begin
  // Popula extrutura com Posição e Tamanho dos campos no
  // Arquivo JUNTADO / TMP

  Param.Relatorio.Posicao := 4;
  Param.Relatorio.Tamanho := 8;
  Param.Moeda.Posicao := 14; // 12
  Param.Moeda.Tamanho := 3;

  Param.Cartao.Posicao := 17; // 15
  Param.Cartao.Tamanho := 16;
  Param.BIN.Posicao := 17; // 15
  Param.BIN.Tamanho := 6;

  Param.Conta.Posicao := 33; // 31
  Param.Conta.Tamanho := 30; // 4
  Param.Dept.Posicao := 59;
  Param.Dept.Tamanho := 3;
  Param.Valor.Posicao := 63; // 35
  Param.Valor.Tamanho := 14;
  Param.Data.Posicao := 79; // 51
  Param.Data.Tamanho := 8;
  // Param.Ref.Posicao = 49
  // Param.Ref.Tamanho = 2
  Result := 6;
end;

function PegaParInterface: Integer;

begin
  // Popula extrutura com Posição e Tamanho dos campos no
  // Arquivo Interface.txt

  Param_Inter.Ind_Rota.Tamanho := 1;
  Param_Inter.Nro_Corp.Tamanho := 2;
  Param_Inter.BIN.Tamanho := 9;
  Param_Inter.Cod_Origem.Tamanho := 3;
  Param_Inter.Sequencia.Tamanho := 2;
  Param_Inter.Cod_Tran.Tamanho := 2;
  Param_Inter.Cod_Razao.Tamanho := 4;
  Param_Inter.Indic_Db_Cr.Tamanho := 1;
  Param_Inter.Ind_Rej.Tamanho := 1;
  Param_Inter.Ind_Reversao.Linha := 1;
  Param_Inter.Tipo_Cart.Tamanho := 1;
  Param_Inter.Ind_Destino.Tamanho := 3;
  Param_Inter.Tipo_Prod.Tamanho := 2;
  Param_Inter.Tipo_Emprest.Tamanho := 1;
  Param_Inter.Ind_Plan_Fin.Tamanho := 6;
  Param_Inter.Cod_Moeda.Tamanho := 3;
  Param_Inter.Cod_Charge_Off.Tamanho := 1;
  Param_Inter.Ind_Dt_Corte.Tamanho := 1;
  Param_Inter.Valor.Tamanho := 13;
  Param_Inter.Nro_Cartao.Tamanho := 16;
  Param_Inter.Dia_Corte.Tamanho := 2;
  Param_Inter.Data_Tran.Tamanho := 8;
  Param_Inter.Filler.Tamanho := 17;

  Param_Inter.Ind_Rota.Posicao := 1;
  Param_Inter.Nro_Corp.Posicao := 2;
  Param_Inter.BIN.Posicao := 4;
  Param_Inter.Cod_Origem.Posicao := 13;
  Param_Inter.Sequencia.Posicao := 16;
  Param_Inter.Cod_Tran.Posicao := 18;
  Param_Inter.Cod_Razao.Posicao := 20;
  Param_Inter.Indic_Db_Cr.Posicao := 24;
  Param_Inter.Ind_Rej.Posicao := 25;
  Param_Inter.Ind_Reversao.Posicao := 26;
  Param_Inter.Tipo_Cart.Posicao := 27;
  Param_Inter.Ind_Destino.Posicao := 28;
  Param_Inter.Tipo_Prod.Posicao := 31;
  Param_Inter.Tipo_Emprest.Posicao := 33;
  Param_Inter.Ind_Plan_Fin.Posicao := 34;
  Param_Inter.Cod_Moeda.Posicao := 40;
  Param_Inter.Cod_Charge_Off.Posicao := 43;
  Param_Inter.Ind_Dt_Corte.Posicao := 44;
  Param_Inter.Valor.Posicao := 45;
  Param_Inter.Nro_Cartao.Posicao := 58;
  Param_Inter.Dia_Corte.Posicao := 74;
  Param_Inter.Data_Tran.Posicao := 76;
  Param_Inter.Filler.Posicao := 84;
  Result := 6;
end;

function PegaParCodigo: Integer;

begin
  // Popula extrutura com Posição e Tamanho dos sub campos do
  // Codigo / Codigo_Para

  // TCRC TPC REJ D/C SRC REV DEST TPP T/E MOE CHO BIL
  // 6   1   1   1   3   1   3    2   1   3   1   1
  // 1   7   8   9   10  13  14   17  19  20  23  24

  Param_Codigo.TCRC.Posicao := 1;
  Param_Codigo.TCRC.Tamanho := 6;

  Param_Codigo.TPC.Posicao := 7;
  Param_Codigo.TPC.Tamanho := 1;

  Param_Codigo.REJ.Posicao := 8;
  Param_Codigo.REJ.Tamanho := 1;

  Param_Codigo.D_C.Posicao := 9;
  Param_Codigo.D_C.Tamanho := 1;

  Param_Codigo.SRC.Posicao := 10;
  Param_Codigo.SRC.Tamanho := 3;

  Param_Codigo.REV.Posicao := 13;
  Param_Codigo.REV.Tamanho := 1;

  Param_Codigo.DEST.Posicao := 14;
  Param_Codigo.DEST.Tamanho := 3;

  Param_Codigo.TPP.Posicao := 17;
  Param_Codigo.TPP.Tamanho := 2;

  Param_Codigo.T_E.Posicao := 19;
  Param_Codigo.T_E.Tamanho := 1;

  Param_Codigo.MOE.Posicao := 20;
  Param_Codigo.MOE.Tamanho := 3;

  Param_Codigo.CHO.Posicao := 23;
  Param_Codigo.CHO.Tamanho := 1;

  Param_Codigo.BIL.Posicao := 24;
  Param_Codigo.BIL.Tamanho := 1;

  Param_Codigo.Filler.Posicao := 25;
  Param_Codigo.Filler.Tamanho := 6;

  Result := 6;
end;

// VBto upgrade warning: Flags As OleVariant  OnWrite(Boolean)
procedure LimpaFlags(var Flags: Array of Boolean);
var
  I: Integer;
begin
  for I:=1 to 9 do begin
    Flags[I] := false;
  end;
end;

function ContaValida(Buf: String; Ind: Integer; Nat: String; Flag: Boolean; Moeda: String): Boolean;
var
  Conta: String;
//  sMoeda: array[0..3+1] of Char;
  sMoeda: String;
begin
  Result := false;
  Conta := Trim(Copy(Buf, Param.Conta.Posicao, Param.Conta.Tamanho));
  Conta := limpaString(Conta);
  sMoeda := Copy(Buf, Param.Moeda.Posicao, Param.Moeda.Tamanho);

  if (Length(Moeda)>0) then begin
    if (sMoeda='840') and (sMoeda<>Moeda) then begin
      Exit;
    end;
    if (Moeda='840') and (sMoeda<>Moeda) then begin
      Exit;
    end;
  end;
  if Nat='D' then begin
    if Flag and (RightStr(Buf, 1)<>'D') then begin
      Exit;
    end;
    // Conta de Débito
    // Select Case ctDebito(Ind).nRef
    // Case 1
    // Fidelity 2008-08-23
    // Ref01 = Mid$(Buf, Param.Ref.Posicao, Param.Ref.Tamanho)
    // Ref03 = ctDebito(Ind).Conta
    // Ref04 = Mid$(Ref03, 1, 15)
    // Debug.Print conta + " - " + Ref04 + "."
    if (Conta=Trim(ctDebito[Ind].Conta)) then begin
      // If (conta = ctDebito(Ind).conta)
      // And (Ref01 = ctDebito(Ind).Ref) Then
      Result := true;
    end;

    // End Select
   end  else  begin
    // Conta de Crédito
    if Flag and (RightStr(Buf, 1)<>'C') then begin
      Exit;
    end;
    // Select Case ctCredito(Ind).nRef
    // Case 1
    // Fidelity 2008-08-23
    // Ref03 = ctCredito(Ind).Conta
    // Ref04 = Mid$(Ref03, 1, 15)
    if (Conta=Trim(ctCredito[Ind].Conta)) then begin
      // Fidelity 2008-08-23
      // If (conta = ctCredito(Ind).conta)
      // And (Ref01 = ctCredito(Ind).Ref) Then
      Result := true;
    end;
    // End Select
  end;
end;

function GeraTemp(Var NomeSaida, NomeArquivo: String): Boolean;
label
  Saida;
var
  ArqEntrada, ArqSaida: System.Text;
  I: Integer;
  Buffer, BuffAntes, sData: String;
  iPosicao: Integer;
  iFileLen: Extended;
begin
  iPosicao := 0;

  // Abre o arquivo de entrada
  if FileExists(NomeArquivo) then
    begin
    AssignFile(ArqEntrada, NomeArquivo);
    Reset(ArqEntrada);
    ReadLn(ArqEntrada, Buffer);
    end
  else
    begin
    Result := false;
    if  not gAutomatico then
      ShowMessage('Arquivo: '+NomeArquivo+' não encontrado');
//    Desconecta;
    PBar.Close;
    Exit;
    end;

  AssignFile(ArqSaida, NomeSaida);
  Rewrite(ArqSaida);

  if FileSizeByName(NomeArquivo)=0 then
    begin
    Result := false;
    goto Saida;
    end;

  // ========================================================
  // 11/04/2002
  // Juntado foi gerado sem a linha inicial e só tinha uma linha
  // de movimento, deu erro input past the end of file
  // Não sei porque......

  if Copy(Buffer, 1, 9)='CLICODREL' then
    ReadLn(ArqEntrada, Buffer);
  // If Mid$(Buffer, 1, 9) = "INSRELATO" Then Line Input #ArqEntrada, Buffer

  if StrToDate(Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho)) <> gDataRelatorio then
    begin
    Application.MessageBox('Data do Movimento Inválida...', 'Atualização de Arquivo', MB_ICONSTOP);
    Result := false;
    gDtMovInvalida := true;
    goto Saida;
    end;

  Result := true;

  CloseFile(ArqEntrada);
  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);

  // If Not gAutomatico Then
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Preparando Arquivo de Entrada...';
  iFileLen := FileSizeByName(NomeArquivo);
  // End If

  // Moeda Padrão
  // sMoedaAntes = "986"

  while not Eof(ArqEntrada) do
    begin
    ReadLn(ArqEntrada, Buffer);
    // If Not gAutomatico Then
    iPosicao := iPosicao+Length(Buffer)+2;
    if iPosicao/iFileLen<=1 then
      PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
    else
      PBar.ProgressBar1.Position := 100;

    // End If
    Application.ProcessMessages;

    // sMoeda = Mid$(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho)
    // sConta = Mid$(Buffer, Param.Conta.Posicao, Param.Conta.Tamanho)
    // sData = Mid$(Buffer, Param.Data.Posicao, Param.Data.Tamanho)
    // If Len(Trim(sMoeda)) <> 0 Then
    // sMoedaAntes = sMoeda
    // End If

    // If (sConta = "1063") And (Len(Trim(sMoeda)) = 0) Then
    // Mid$(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho) = Mid$(sMoedaAntes, 1, Len(sMoedaAntes))
    // End If
    // If (sConta = "0960") And (Len(Trim(sMoeda)) = 0) Then
    // Mid$(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho) = Mid$(sMoedaAntes, 1, Len(sMoedaAntes))
    // End If
    // Não tem Moeda no Relatório
    // If (sConta = "5133") And (Len(Trim(sMoeda)) = 0) Then
    // Mid$(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho) = Mid$(sMoedaAntes, 1, Len(sMoedaAntes))
    // End If

    // Forçar Moeda
    if gForcaReal then
//      SetToMid(Buffer, Param.Moeda.Posicao, '986', Param.Moeda.Tamanho);
      Buffer.Insert(Param.Moeda.Posicao-1, '986');

    if gForcaDolar then
//      SetToMid(Buffer, Param.Moeda.Posicao, '840', Param.Moeda.Tamanho);
      Buffer.Insert(Param.Moeda.Posicao-1, '840');

    I:=0;
    while (I <= ncDebito-1) { for I:=0 to ncDebito-1 } do
      begin
      if ContaValida(Buffer, I, 'D', false, '') then
        begin
        // Se tiver Brancos na data, substitui por Zeros
        if 0<>(1+Pos(' ', PChar(sData)+1)) then
          begin
          I := 1;
          while I<Length(sData) do
            begin
            if Copy(sData, 1, I)=' ' then
//              SetToMid(sData, 1, '0', I);
              sData.Insert(1, '0');
            I := I+1;
            end;
//          SetToMid(Buffer, Param.Data.Posicao, Copy(sData, 1, Param.Data.Tamanho), Param.Data.Tamanho);
          Buffer.Insert(Param.Data.Posicao-1, sData.Substring(0, Param.Data.Tamanho));
          end;

        if gEliminaDuplicacao then
          begin
          if Buffer<>BuffAntes then
            begin
            WriteLn(ArqSaida, TrataValor(Buffer)+'D');
            BuffAntes := Buffer;
            end;
          end
        else
          begin
          WriteLn(ArqSaida, TrataValor(Buffer)+'D');
          BuffAntes := Buffer;
          end;
        end;
      I :=  I + 1;
      end; // I

      I:=0;
      while (I <= ncCredito-1) { for I:=0 to ncCredito-1 } do
        begin
        if ContaValida(Buffer, I, 'C', false, '') then
          begin
        // Se tiver Brancos na data, substitui por Zeros

//        sData.Replace(' ', '0');      vai subprostituir tudo abaixo...

          if 0<>(1+Pos(' ', PChar(sData)+1)) then
            begin
            I := 1;
            while I<Length(sData) do
              begin
              if Copy(sData, 1, I)=' ' then begin
                //SetToMid(sData, 1, '0', I);
                sData.Insert(1, '0');
              end;
            I := I+1;
            end;
          //SetToMid(Buffer, Param.Data.Posicao, Copy(sData, 1, Param.Data.Tamanho), Param.Data.Tamanho);
          Buffer.Insert(Param.Data.Posicao-1, sData.Substring(0, Param.Data.Tamanho));
          end;

        if gEliminaDuplicacao then
          begin
          if Buffer<>BuffAntes then
            begin
            WriteLn(ArqSaida, TrataValor(Buffer)+'C');
            BuffAntes := Buffer;
            end;
          end
        else
          begin
          WriteLn(ArqSaida, TrataValor(Buffer)+'C');
          BuffAntes := Buffer;
          end;
        end;
      I :=  I + 1;
      end; // I
  end;

Saida:
  CloseFile(ArqEntrada);
  CloseFile(ArqSaida);
  if FileSizeByName(NomeSaida)=0 then
    begin
    Result := false;
    if  not gAutomatico and  not gDtMovInvalida then
      begin
      Application.MessageBox('Não há movimento...', 'Gera Arquivo Temporário', MB_ICONSTOP);
      end;
    end;
//  Desconecta;
  // If Not gAutomatico Then
  PBar.Close;
  // endif
  // fMainForm.sbStatusBar.Panels(1).Text = "Cliente: " & gCliente
  BarraStatus;
end;

function GeraTemp2(Var NomeSaida, NomeArquivo: String): Boolean;
label
  Saida;
var
  ArqEntrada, ArqSaida: System.Text;
  I: Integer;
  Buffer, BuffAntes, sCartao, sValor, sData, sConta, sMoeda, sMoedaAntes: String;
  iPosicao(*, iPonteiro*): Integer;
  iFileLen: Extended;
begin
  iPosicao := 0;

  // Dim NomeSaida As String

  // Não leu arquivo
  if gNReg=0 then
    begin
    if FileExists(NomeArquivo) then
      begin
      AssignFile(ArqEntrada, NomeArquivo);
      Reset(ArqEntrada);
      ReadLn(ArqEntrada, Buffer);
      end
    else
      begin
      Result := false;
      ShowMessage(PChar('Arquivo: '+NomeArquivo+' não encontrado'));
//      Desconecta;
      PBar.Close;
      Exit;
      end;

    ReadLn(ArqEntrada, Buffer);
    if StrToDate(Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho)) <> gDataRelatorio then
      begin
      Application.MessageBox('Data do Movimento Inválida...', 'Atualização de Arquivo', MB_ICONSTOP);
      Result := false;
      CloseFile(ArqEntrada);
      goto Saida;
      end;

    // Le o arquivo e guarda na memória

    CloseFile(ArqEntrada);

    AssignFile(ArqEntrada, NomeArquivo);
    Reset(ArqEntrada);
    PBar.Show;
    PBar.Label1.Visible := true;
    PBar.ProgressBar1.Visible := true;
    PBar.Label1.Caption := 'Lendo Arquivo de Entrada...';
    iFileLen := FileSizeByName(NomeArquivo);

    while not Eof(ArqEntrada) do
      begin
      ReadLn(ArqEntrada, Buffer);
      iPosicao := iPosicao+Length(Buffer)+2;
      if iPosicao/iFileLen<=1 then
        PBar.ProgressBar1.Position := Round((iPosicao/iFileLen)*100)
      else
        PBar.ProgressBar1.Position := 100;

      Application.ProcessMessages;

//      gNReg := gNReg+1;
//      ReDimPreserve(gArqEntrada, gNReg+1);
//      gArqEntrada[gNReg] := Buffer;
      end;

    CloseFile(ArqEntrada);
    end;

//  if Dir(NomeSaida)<>'' then begin
//    DeleteFile(NomeSaida);
//  end;

  AssignFile(ArqSaida, NomeSaida);
  Rewrite(ArqSaida);

//  iPonteiro := 2; // Verifica Data
  // Line Input #ArqEntrada, Buffer
  AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);
  ReadLn(ArqEntrada, Buffer);
  ReadLn(ArqEntrada, Buffer);
  CloseFile(ArqEntrada);
//  Buffer := gArqEntrada[iPonteiro];
  if StrToDate(Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho)) <> gDataRelatorio then
    begin
    Application.MessageBox('Data do Movimento Inválida...', 'Atualização de Arquivo', MB_ICONSTOP);
    Result := false;
    goto Saida;
    end;

  Result := true;

  // If Not gAutomatico Then
  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Preparando Arquivo de Entrada...';
  // End If

  // Moeda Padrão
  sMoedaAntes := '986';

//  iPonteiro := 2; // Aponta para o primeiro registro
   AssignFile(ArqEntrada, NomeArquivo);
  Reset(ArqEntrada);
  ReadLn(ArqEntrada, Buffer);

//  while iPonteiro<=gNReg do begin
  while not eof(ArqEntrada) do
    begin
    // Line Input #ArqEntrada, Buffer
    ReadLn(ArqEntrada, Buffer);
//    Buffer := gArqEntrada[iPonteiro];
    // If Not gAutomatico Then
    iPosicao := iPosicao+Length(Buffer)+2;
(*    if iPonteiro/gNReg<=1 then
      begin
      PBar.ProgressBar1.Position := Round((iPonteiro/gNReg)*100);
      end
    else
      begin  *)
      PBar.ProgressBar1.Position := 100;
//      end;
    // End If
    Application.ProcessMessages;

    sMoeda := Copy(Buffer, Param.Moeda.Posicao, Param.Moeda.Tamanho);
    sConta := Copy(Buffer, Param.Conta.Posicao, Param.Conta.Tamanho);
    sData := Copy(Buffer, Param.Data.Posicao, Param.Data.Tamanho);
    if Length(Trim(sMoeda))<>0 then
      sMoedaAntes := sMoeda;

    if (sConta='1063') and (Length(Trim(sMoeda))=0) then
//      SetToMid(Buffer, Param.Moeda.Posicao, Copy(sMoedaAntes, 1, Length(sMoedaAntes)), Param.Moeda.Tamanho);
      Buffer.Insert(Param.Moeda.Posicao-1, sMoedaAntes);

    if (sConta='0960') and (Length(Trim(sMoeda))=0) then
//      SetToMid(Buffer, Param.Moeda.Posicao, Copy(sMoedaAntes, 1, Length(sMoedaAntes)), Param.Moeda.Tamanho);
      Buffer.Insert(Param.Moeda.Posicao-1, sMoedaAntes);

    // Não tem Moeda no Relatório
    if (sConta='5133') and (Length(Trim(sMoeda))=0) then
//      SetToMid(Buffer, Param.Moeda.Posicao, Copy(sMoedaAntes, 1, Length(sMoedaAntes)), Param.Moeda.Tamanho);
      Buffer.Insert(Param.Moeda.Posicao-1, sMoedaAntes);

    // Forçar Moeda
    if gForcaReal then
//      SetToMid(Buffer, Param.Moeda.Posicao, '986', Param.Moeda.Tamanho);
      Buffer.Insert(Param.Moeda.Posicao-1, '986');

    if gForcaDolar then
//      SetToMid(Buffer, Param.Moeda.Posicao, '840', Param.Moeda.Tamanho);
      Buffer.Insert(Param.Moeda.Posicao-1, '840');

    I:=0;
    while (I <= ncDebito-1) { for I:=0 to ncDebito-1 } do
      begin
      if ContaValida(Buffer, I, 'D', false, '') then
        begin
        // Se tiver Brancos na data, substitui por Zeros

//        sData.Replace(' ', '0');      vai subprostituir tudo abaixo...

        if 0<>(1+Pos(' ', PChar(sData)+1)) then
          begin
          I := 1;
          while I<Length(sData) do
            begin
            if Copy(sData, 1, I)=' ' then
              begin
//              SetToMid(sData, 1, '0', I);
              sData.Insert(1,'0');
              end;
            I := I+1;
          end;
//          SetToMid(Buffer, Param.Data.Posicao, Copy(sData, 1, Param.Data.Tamanho), Param.Data.Tamanho);
        Buffer.Insert(Param.Data.Posicao-1, sData.Substring(0, Param.Data.Tamanho))
        end;

        if gEliminaDuplicacao then
          begin
          if Buffer<>BuffAntes then
            begin
            WriteLn(ArqSaida, TrataValor(Buffer)+'D');
            BuffAntes := Buffer;
            end;
          end
        else
          begin
          WriteLn(ArqSaida, TrataValor(Buffer)+'D');
          BuffAntes := Buffer;
          end;
       end;
       I :=  I + 1;
     end; // I

     I:=0;
     while (I <= ncCredito-1) { for I:=0 to ncCredito-1 } do
       begin
       if ContaValida(Buffer, I, 'C', false, '') then
         begin
        // Se tiver Brancos na data, substitui por Zeros
         if 0<>(1+Pos(' ', PChar(sData)+1)) then
           begin
           I := 1;
           while I<Length(sData) do
             begin
             if Copy(sData, 1, I)=' ' then
               begin
               //SetToMid(sData, 1, '0', I);
               sData.Insert(1,'0');
               end;
             I := I+1;
            end;
//          SetToMid(Buffer, Param.Data.Posicao, Copy(sData, 1, Param.Data.Tamanho), Param.Data.Tamanho);
          Buffer.Insert(Param.Data.Posicao-1, sData.Substring(0, Param.Data.Tamanho))
          end;

        if gEliminaDuplicacao then
          begin
          if Buffer<>BuffAntes then
            begin
            WriteLn(ArqSaida, TrataValor(Buffer)+'C');
            BuffAntes := Buffer;
            end;
          end
        else
          begin
          WriteLn(ArqSaida, TrataValor(Buffer)+'C');
          BuffAntes := Buffer;
          end;
        end;
      I :=  I + 1;
      end; // I
//    iPonteiro := iPonteiro+1;
  end;

Saida:
  CloseFile(ArqSaida);
  if FileSizeByName(NomeSaida)=0 then begin
    Result := false;
    if  not gAutomatico then begin
      Application.MessageBox('Não há movimento...', 'Gera Arquivo Temporário', MB_ICONSTOP);
    end;
  end;
//  Desconecta;
  // If Not gAutomatico Then
  PBar.Close;
  // endif
  // fMainForm.sbStatusBar.Panels(1).Text = "Cliente: " & gCliente
  BarraStatus;
end;

procedure BackupBanco;
begin

  ShowMessage('BackupBanco - Entender para converter');

 (*  // BackUp Temporário do Banco de Dados

  Desconecta;

  NomeArquivo := gAdmPath+'\';
  NomeArquivo := NomeArquivo+gCliente+'\Backup_temp\';
  NomeArquivo := NomeArquivo+FormatVB(Now,'YYYYMMDD')+'_';
  NomeArquivo := NomeArquivo+FormatVB(Now,'HHMMSS')+'_';
  NomeArquivo := NomeArquivo+gCliente+'_';
  NomeArquivo := NomeArquivo+String(Concil.ContaContabil)+'.mdb';

   {? On Error Resume Next  }
  CopyFile(PChar(String(gDataPath)+gDataFile), PChar(NomeArquivo), false);    *)
end;

procedure BackupGeral;
(*label
  Erro;
var
  nome, sData: String;*)
begin

  ShowMessage('BackupGeral - Entender para converter');

  (*// BackUp do Banco de Dados

  Screen.Cursor := crHourGlass;
  LimpaBackUp(10); // Desconecta
  NomeArquivo := gAdmPath+'\';
  NomeArquivo := NomeArquivo+gCliente+'\Backup\';
  NomeArquivo := NomeArquivo+FormatVB(Now,'YYYYMMDD')+'_';
  NomeArquivo := NomeArquivo+FormatVB(Now,'HHMMSS')+'_';
  NomeArquivo := NomeArquivo+gCliente+'_';
  NomeArquivo := NomeArquivo+'Geral'+'.mdb';

  try  // On Error GoTo Erro

    CopyFile(PChar(String(gDataPath)+gDataFile), PChar(NomeArquivo), false);

    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\Backup_temp\';
    nome := Dir(NomeArquivo+'*.mdb');
    while Dir(NomeArquivo+'*.mdb')<>'' do begin
      if (1+Pos('Geral', PChar(nome)+1))=0 then begin
        DeleteFile(NomeArquivo+nome);
      end;
      nome := Dir(NomeArquivo+'*.mdb');
    end;

    // Deleta arquivos antigos

    NomeArquivo := gAdmPath+'\';
    NomeArquivo := NomeArquivo+gCliente+'\entrada\';
    nome := Dir(NomeArquivo+'*.*');
    if Length(Trim(gDataRelatorio))=0 then begin
      sData := FormatVB(Now-1,'YYYYMMDD');
     end  else  begin
      sData := FormatVB(CDate(gDataRelatorio),'YYYYMMDD');
    end;
    while nome<>'' do begin
      if (1+Pos(sData, PChar(nome)+1))=0 then begin
        DeleteFile(NomeArquivo+nome);
        nome := Dir(NomeArquivo+'*.*');
       end  else  begin
        nome := Dir;
      end;
    end;

    Screen.Cursor := crDefault;
    ShowMessage('BackUp Diário Efetuado.');
    Exit;
  except  // Erro:
    Screen.Cursor := crDefault;
    ShowMessage(PChar('Erro no BackUp.'+#10+'Err.Description'));
    Err.Clear;
    { Resume Next }
  end;                  *)
end;

function QuebraBanco: Boolean;
(*label
  Erro;
var
  DbHist: Database;
  RsHist: TADODataSet;
  lPosic, lNroReg: Integer;
  LastData: TDateTime;
  I: Integer;
  tdfTabela: TableDef;
  fldLoop: TField;
var  IteratorForEach: Integer;*)
begin
QuebraBanco := False;
ShowMessage('QuebraBanco - Entender para converter');

 (*  lPosic := 0;
  lNroReg := 0;

  // *****************************************************************
  // Gera Arquivo Hist_BANCO com o movimento zerado do BANCO
  // no diretório de trabalho e deleta os registros do BANCO
  // *****************************************************************

  if  not Conecta('') then begin
    Exit;
  end;
  if  not TryStrToDateTime(gDataMov) then begin
    gDataMov := FormatVB(Now,'DD/MM/YYYY');
    // gDataMov = Format$(Now - 3, "DD/MM/YYYY")
  end;
  LastData := StrToDateTime(gDataMov);
  I := GetMonth(LastData);
  while GetMonth(LastData)=I do begin
    LastData := LastData-1;
  end;
  LastData := LastData+1;

  DbHist := gWork.OpenDatabase(gDataPath+'Hist_'+gDataFile);

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Separando Bancos...';

  // Gera Recordset VAZIO
  sSql := 'select * from lancamentos where vl_saldo > 0';
  RsHist := DbHist.OpenRecordset(sSql);

  sSql := 'select * from lancamentos';
  RsDb := gBanco.OpenRecordset(sSql);

  // sSql = "select * from lancamentos where vl_saldo > 0"
  // Set RsHist = DbHist.OpenRecordset(sSql)

  with RsDb do begin
    if  not EOF then begin
      Last;
      lNroReg := RecordCount;
      lPosic := 0;
      First;
    end;
    while  not EOF do begin
      PBar.ProgressBar1.Position := Round((lPosic/lNroReg)*100);
      Application.ProcessMessages;
      if FieldByName('vl_saldo')=0 then begin
        if ValidaDatas(LastData) then begin
          tdfTabela := gBanco.TableDefs.Lancamentos;

          RsHist.Insert;
          // Enumerate the Fields collection to show the new fields.
          // For Each fldLoop In tdfTabela.Fields
          For IteratorForEach:=0 To tdfTabela.Fields.Count-1 Do begin
            fldLoop := tdfTabela.Fields[IteratorForEach];
            if AnsiUpperCase(fldLoop.DisplayName)<>'REGISTRO' then begin
              VBtoADOFieldSet(RsHist, fldLoop.DisplayName, RsDb.FieldByName(fldLoop.DisplayName).Value);
            end;
          End;
          RsHist.UpdateRecord;

          Delete;
        end;
      end;
      Next;
      lPosic := lPosic+1;
    end;
  end;

  RsHist.Close;
  RsHist := nil;
  DbHist.Close;
  DbHist := nil;
  PBar.Close;
  Result := true;
  Exit;
Erro:
  Result := false;  *)
end;

// Function LimpaConta(sConta As String, sData As String, iDias As Integer) As Boolean
// VBto upgrade warning: sConta As String  OnWrite(FixedString)
function LimpaConta(sConta: String; iDias: Integer): Boolean;
var
  lPosic, lNroReg: Integer;
  LastData: TDateTime;
  I: Integer;
  ClienteAdoConnection : TAdoConnection;
  RsDb : TAdoDataSet;
begin
Result := False;
Try
  lPosic := 0;
  lNroReg := 0;


  // *****************************************************************
  // Limpa do banco os lançamento da conta sConta mais antigos que iDias
  // 
  // *****************************************************************

//  if  not Conecta('') then
//    Exit;

  if not Conecta(ClienteAdoConnection, gDataPath + gDataFile + '.udl') then
    Exit;

  RsDb := TAdoDataSet.Create(nil);
  RsDb.Connection := ClienteAdoConnection;

  LastData := gDataRelatorio;
  I := iDias;

  while I>0 do
    begin
    while not DiaUtil(LastData) do
      LastData := LastData-1;
    LastData := LastData-1;
    I := I-1;
    end;

  LastData := LastData+1;

  PBar.Show;
  PBar.Label1.Visible := true;
  PBar.ProgressBar1.Visible := true;
  PBar.Label1.Caption := 'Limpando Banco ...';

  // Gera Recordset VAZIO
  sSql := 'select * from lancamentos where conta_contabil = '#39''+sConta+''#39'';
  RsDb.CommandText := sSql;
  RsDb.Active := True;

//  with RsDb do begin
  if  not RsDb.EOF then
    begin
    RsDb.Last;
    lNroReg := RsDb.RecordCount;
    lPosic := 0;
    RsDb.First;
    end;

  while not RsDb.EOF do
    begin
    PBar.ProgressBar1.Position := Round((lPosic/lNroReg)*100);
    Application.ProcessMessages;
    if ValidaDatas(LastData, RsDb) then
      RsDb.Delete;

    RsDb.Next;
    lPosic := lPosic+1;
    end;

  PBar.Close;

  ClienteAdoConnection.Close;
  ClienteAdoConnection.Free;
  RsDb.Close;
  RsDb.Free;

  Result := true;

  Except
    Result := false;
    End;  // Try
end;

function ValidaDatas(DataM: TDateTime; RsDb : TAdoDataSet): Boolean;
begin
  Result := false;

//  if IsNull(RsDb.FieldByName('Data_Debito')) then begin
  if String.IsNullOrEmpty(RsDb.FieldByName('Data_Debito').AsString) then
    Exit;

//  if IsNull(RsDb.FieldByName('Data_Credito')) then begin
  if String.IsNullOrEmpty(RsDb.FieldByName('Data_Credito').AsString) then
    Exit;

  if (RsDb.FieldByName('Data_Debito').AsDateTime < DataM) and (RsDb.FieldByName('Data_Credito').AsDateTime < DataM) then
    begin
    Result := true;
    Exit;
    end;
end;

Function GeraTempDb: Boolean;
var
  DbTemp: TAdoConnection;
  sSql : String;
begin

//  DbTemp := gWork.OpenDatabase(gTempDir+'CC_TempVisa.mdb');
//  Result := CopiaTabela(gBanco, DbTemp, 'lancamentos');
//  DbTemp.Close;
//  DbTemp := nil;

Result := False;

If Not Conecta(DbTemp, ExtractFileDir(Application.ExeName) + '\admin.udl') Then
  Exit;

sSql := 'TRUNCATE TABLE [SISCOC_TempVisa].[dbo].[Lancamentos] ';
DbTemp.Execute(sSql);

sSql := 'INSERT INTO [SISCOC_TempVisa].[dbo].[Lancamentos] ';
sSql := sSql + 'SELECT * FROM [' + gDataFile +'].[dbo].[Lancamentos] ';    // SISCOC_CC_ClienteTeste
sSql := sSql+' where [conta_contabil] = '#39''+Trim(Concil.ContaContabil)+''#39'';
DbTemp.Execute(sSql);

DbTemp.Close;
DbTemp.Free;

Result := True;

end;

(*function CopiaTabela( { DbOrigem: Database }  { ; DbDestino: Database } Tabela: String): Boolean;
label
  Erro;
var
  RsOrigem, RsDestino: TADODataSet;
  tdfTabela: TableDef;
  fldLoop: TField;
  Inicio, final: String;
var  IteratorForEach: Integer;
begin

  try  // On Error GoTo Erro

    PBar.Show;
    PBar.Label1.Visible := true;
    PBar.ProgressBar1.Visible := true;
    PBar.Label1.Caption := 'Preparando consulta...';

    sSql := 'delete * from '+Tabela;
    DbDestino.Execute(sSql);

    sSql := 'select * from '+Tabela;
    sSql := sSql+' where conta_contabil = '#39''+Trim(Concil.ContaContabil)+''#39'';
    RsOrigem := DbOrigem.OpenRecordset(sSql);

    RsDestino := DbDestino.OpenRecordset(sSql);

    sSql := 'DbOrigem.TableDefs!'+Tabela;
    tdfTabela := DbOrigem.TableDefs.Lancamentos;

    if  not RsOrigem.EOF then RsOrigem.Last;
    RsOrigem.First;

    Inicio := DateTimeToStr(Time);
    with RsOrigem do begin
      while not EOF do begin
        PBar.ProgressBar1.Position := (RsOrigem.RecordCount div RsDb.RecNo);
        RsDestino.Insert;
        // Enumerate the Fields collection to show the new fields.
        // For Each fldLoop In tdfTabela.Fields
        For IteratorForEach:=0 To tdfTabela.Fields.Count-1 Do begin
          fldLoop := tdfTabela.Fields[IteratorForEach];
          if AnsiUpperCase(fldLoop.DisplayName)<>'REGISTRO' then begin
            VBtoADOFieldSet(RsDestino, fldLoop.DisplayName, FieldByName(fldLoop.DisplayName).Value);
          end;
        End;
        RsDestino.UpdateRecord;

        Next;
        Application.ProcessMessages;
      end;
    end;
    final := DateTimeToStr(Time);
    PBar.Close;
    RsOrigem.Close;
    RsDestino.Close;
    RsOrigem := nil;
    RsDestino := nil;
    Result := true;
    Exit;
  except  // Erro:
    if Err.Number=3021 then { Resume Next }
    ShowMessage(PChar('Err.Description'));
    { Resume Next }
    Result := false;
    PBar.Close;
    RsOrigem.Close;
    RsDestino.Close;
    RsOrigem := nil;
    RsDestino := nil;
  end;
end;         *)

function copiaAte_18(STR1: String; STR2: String; cnt: Integer): String;
begin
Result := copiaAte(STR1, STR2, cnt);
end;

function copiaAte(STR1: String; STR2: String; var cnt: Integer): String;
var
  I: Integer;
  J: Integer;
  S: String;
begin
  I := 1;
  J := Length(STR1);
  Result := '';
  while I<J do begin
    S := Copy(STR1, I, 1);
    Result := Result+S;
    if S=STR2 then cnt := cnt-1;
    if cnt=0 then break;
    I := I+1;
  end;
end;
        (*
procedure MontaTexto;
var
  NomeArquivo, NomeSaida: String;
  ArqSaida: System.Text;
begin
  NomeSaida := gAdmPath+'\'+gCliente+'\'+gCliente;
  NomeSaida := NomeSaida+'_'+gConciliacao;

  NomeArquivo := '_20'+Copy(gDataRelatorio, 7, 2);
  NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 4, 2);
  NomeArquivo := NomeArquivo+Copy(gDataRelatorio, 1, 2);
  NomeSaida := NomeSaida+NomeArquivo+'.txt';
  ArqSaida := 1{indifferently};
  AssignFile(ArqSaida, NomeSaida); Rewrite(FileHandle_ArqSaida);
  RsDb.First;
  while not RsDb.EOF do
    begin
    MontaLinhaTxt(ArqSaida);
    RsDb.Next;
    end;
  CloseFile(ArqSaida);
end;

procedure MontaLinhaTxt(ArqSaida: Integer);
var
  Buffer: String;
begin

  with RsDb do begin
    Buffer := '';

    if TryStrToDateTime(FieldByName('Data_Debito'))>0 then begin
      Buffer := Buffer+String(FieldByName('Data_Debito').Value);
     end  else  begin
      Buffer := Buffer+StringOfChar(' ', 10);
    end;
    Buffer := Buffer+StringOfChar(' ', 3);

    if sizeof(FieldByName('Data_credito').Value)>0 then begin
      Buffer := Buffer+String(FieldByName('Data_Credito').Value);
     end  else  begin
      Buffer := Buffer+StringOfChar(' ', 10);
    end;

    Buffer := Buffer+StringOfChar(' ', 3);

    Buffer := Buffer+String(FieldByName('Cartao').Value);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Vl_DebitoDolar').Value, 10);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Taxa_Debito').Value, 8);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Vl_CreditoDolar').Value, 10);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Taxa_Credito').Value, 8);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Vl_DebitoReal').Value, 10);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Vl_CreditoReal').Value, 10);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Variacao').Value, 8);
    Buffer := Buffer+StringOfChar(' ', 3);
    Buffer := Buffer+FormataFixo(FieldByName('Vl_Saldo').Value, 10);
    WriteLn(FileHandle_ArqSaida, Buffer);

  end;
end;

// VBto upgrade warning: Valor As Extended  OnWrite(TField)
function FormataFixo(Valor: Extended; Tam: Integer): String;
var
  STR: String;
begin
  STR := FormatVB(Valor,'###,##0.00');
  if Length(STR)<Tam then begin
    Result := StringOfChar(' ', Tam-Length(STR))+STR;
   end  else  begin
    Result := Copy(STR, 1, Tam);
  end;
end;*)

function TrataValor(buff: String): String;
var
  Valor: String;
  I, J: Integer;
begin
  Result := buff;

//  Valor := Copy(buff, Param.Valor.Posicao, Param.Valor.Tamanho);
  Valor := buff.Substring(Param.Valor.Posicao, Param.Valor.Tamanho); //

  I := Valor.IndexOf(',');   // (1+Pos(',', PChar(Valor)+1));
  if I <> 0 then
    Exit;

  I := Valor.IndexOf('.');
  if I <> 0 then
    Result.Replace('.',',')   // Result  :=   Copy(buff, 1, I)+','+Copy(buff, I+1, Length(buff)-I)
  else
    begin
    // insere virgula num valor que não a tem
    // supoe valor alinhado a direita(Relatório AA)

    // 29/01/04 - O valor esta alinhado a esquerda
    // vou ajeitar

    if Length(Trim(Valor)) < Param.Valor.Tamanho then
      begin
      I := Param.Valor.Tamanho - Length(Trim(Valor));
//      SetToMid(buff, Param.Valor.Posicao+I, Trim(Valor), Length(Trim(Valor)));
      Buff.Insert(Param.Valor.Posicao+I, Trim(Valor));
      end;

    I := Param.Valor.Posicao;
    J := Param.Ref.Posicao-I-3;
//    SetToMid(buff, I, Copy(buff, I+1, J), J);
//    SetToMid(buff, I+J, ',', 1);
    Buff.Insert(I, buff.Substring(I, J));
    Buff.Insert(I+J, ',');
  end;

Result := buff;
end;

     (*


// VBto upgrade warning: Conta As String  OnWrite(TField)
// VBto upgrade warning: 'Return' As TDateTime  OnWrite(String)
function MaxData(Conta: String): TDateTime;
var
  RsLocal: TADODataSet;
begin

  // Retorna a data do lançamento mais recente

  gData1 := '';
  gData2 := '';
  sSql := 'select max( data_debito) from lancamentos where conta_contabil='#39'';
  sSql := sSql+Conta+''#39'';
  RsLocal := gBanco.OpenRecordset(sSql);
  if TryStrToDateTime(RsLocal.Fields[0]) then
    gData1 := RsLocal.Fields[0].Value;

  sSql := 'select max( data_credito) from lancamentos where conta_contabil='#39'';
  sSql := sSql+Conta+''#39'';
  RsLocal := gBanco.OpenRecordset(sSql);
  if TryStrToDateTime(RsLocal.Fields[0]) then
    gData2 := RsLocal.Fields[0].Value;


  if  not TryStrToDateTime(gData1) and TryStrToDateTime(gData2) then Result := StrToDateTime(gData2);
  if  not TryStrToDateTime(gData2) and TryStrToDateTime(gData1) then Result := StrToDateTime(gData1);
  if  not TryStrToDateTime(Result) then Result := StrToDateTime(StringOfChar(' ', 10));

  if TryStrToDateTime(gData1) and TryStrToDateTime(gData2) then begin
    if StrToDateTime(gData1) > StrToDateTime(gData2) then begin
      Result := StrToDateTime(gData1);
     end  else  begin
      Result := StrToDateTime(gData2);
    end;
  end;
end;              *)
// VBto upgrade warning: 'Return' As TDateTime  OnWrite(String)

function MaxDataDolar(Conexão : TAdoConnection): TDateTime;
var
  RsLocal: TADODataSet;
  sSql : String;

begin

  // Retorna a data do lançamento mais recente

  gData1 := '';
  gData2 := '';

  sSql := 'select max( data ) from tb_moeda'#39'';

  RsLocal := TADODataSet.Create(nil);
//  RsLocal.Connection := DataModuleForm.AdminADOConnection;
  RsLocal.Connection := Conexão;
  RsLocal.CommandText := sSql;
  RsLocal.Active := True;

  if TryStrToDateTime(RsLocal.Fields[0].AsString, Result) then
    gData1 := RsLocal.Fields[0].Value;

  if Not TryStrToDateTime(gData1, Result) then
    Result := StrToDate('01/01/01');

  RsLocal.Active := False;
  RsLocal.Free;

end;

Procedure LastAtualiza;
var
  ClienteAdoConnection : TAdoConnection;
  RsLocal: TADODataSet;
  sSql : String; //Aqui
  DataAux : TDateTime;
begin
  sSql := 'Select * from [Atualizacao]';

  // If Not Conecta("") Then Exit Function
  if not Conecta(ClienteAdoConnection, gDataPath + gDataFile + '.udl') then
    Exit;

  RsLocal := TAdoDataSet.Create(nil);
  RsLocal.Connection := ClienteAdoConnection;

  RsLocal.CommandText := sSql;
  RsLocal.Active := True;

  if not RsLocal.EOF then
    begin

    RsLocal.Active := False;
    sSql := 'select max(atualizacao) from atualizacao ';
    RsLocal.CommandText := sSql;
    RsLocal.Active := True;

    if TryStrToDateTime(RsLocal.Fields[0].AsString, DataAux) then
      gAtualizacao := DataAux;
    end
  else
    gAtualizacao := 0;

  RsLocal.Active := False;
  RsLocal.Free;
end;

function GetTotDebito(Conexão : TAdoConnection): Extended;
var
  RsLocal: TADODataSet;
  sSql : String; //Aqui
begin
  sSql := 'select sum( vl_debitoreal) from lancamentos where conta_contabil='#39'';
  sSql := sSql+Trim(Concil.ContaContabil)+''#39'';

  RsLocal := TADODataSet.Create(nil);
  RsLocal.Connection := Conexão;
  RsLocal.CommandText := sSql;
   {? On Error Resume Next  }

  RsLocal.Active := True;

  Result := RsLocal.Fields[0].Value;

  RsLocal.Active := False;
  RsLocal.Free;

end;

function GetTotCredito(Conexão : TAdoConnection): Extended;
var
  RsLocal: TADODataSet;
begin
  sSql := 'select sum( vl_creditoreal) from lancamentos where conta_contabil='#39'';
  sSql := sSql+Trim(Concil.ContaContabil)+''#39'';

  RsLocal := TADODataSet.Create(nil);
  RsLocal.Connection := Conexão;
  RsLocal.CommandText := sSql;

  Result := RsLocal.Fields[0].Value;

  RsLocal.Active := False;
  RsLocal.Free;
end;

function GetSaldo: Extended;
var
  gBanco : TAdoConnection;
  RsLocal: TADODataSet;
  sSql : String;
begin
//  if  not Conecta('') then Result := 0;
  if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
    begin
    Result := 0;
    Exit;
    end;

  RsLocal := TAdoDataSet.Create(nil);
  RsLocal.Connection := gBanco;

  sSql := 'select sum( vl_saldo) from lancamentos where conta_contabil='#39'';
  sSql := sSql+Trim(Concil.ContaContabil)+''#39'';
//  RsLocal := gBanco.OpenRecordset(sSql);
  RsLocal.CommandText := sSql;

   {? On Error Resume Next  }
  Result := RsLocal.Fields[0].Value;
  //Desconecta;
  RsLocal.Close;
  RsLocal.Free;
  gBanco.Close;
  gBanco.Free;
end;

// VBto upgrade warning: C_Contabil As String  OnWrite(String, FixedString)
function GetLimite(N_Cliente: String; C_Contabil: String): Integer;
var
  RsLocal: TADODataSet;
  DbLocal: TAdoConnection;
  sSql : String;
begin
  Result := 0;
  sSql := 'Select * from [tb_tipo_con]';
  sSql := sSql+' where cliente = '#39''+N_Cliente+''#39'';
  sSql := sSql+' and conta_contabil = '#39''+C_Contabil+''#39'';
//  DbLocal := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  Conecta(DbLocal, gAdmPath+'\admin.udl');

// RsLocal := DbLocal.OpenRecordset(sSql);
  RsLocal := TAdoDataSet.Create(nil);
  RsLocal.Connection := DbLocal;
  RsLocal.CommandText := sSql;
  RsLocal.Open;

  if not RsLocal.EOF then
    Result := RsLocal.FieldByName('LimiteVariacao').Value;

  RsLocal.Close;
  RsLocal.Free;
  DbLocal.Close;
  DbLocal.Free;
end;

function pegaNomeRel(fullName: String): String;
var
  I: Integer;
  S: String;
begin
  Result := '';
  if Length(fullName)<20 then Exit;
  I := Length(fullName)-4;
  S := Copy(fullName, I, 1);
  while S<>'\' do begin
    I := I-1;
    S := Copy(fullName, I, 1);
  end;
  I := I+1;
  S := Copy(fullName, I, 1);

  while S<>'_' do begin
    Result := Result+S;
    I := I+1;
    S := Copy(fullName, I, 1);
  end;

end;

// VBto upgrade warning: Nivel As OleVariant --> As Integer
function Autoriza(Nivel: Integer): Boolean;
begin
  Result := true;
  if gNivel<Nivel then begin
    Result := false;
    Application.MessageBox('Usuario não autorizado', 'Autorização', MB_ICONSTOP);
  end;
end;

procedure GravaHeaderRel(DbLoc: TAdoConnection; RsLoc: TADOTable; Tipo: Integer);
Var
  DataAux : TDateTime;
begin
  // Deleta Dados de Relatorio
//  sSql := 'delete from Relatorio';
  sSql := 'Truncate Table Relatorio';
  DbLoc.Execute(sSql);
//  sSql := 'delete from relInterface';
  sSql := 'Truncate Table relInterface';
  DbLoc.Execute(sSql);

  // Grava Período na tabela
//  sSql := 'Select * from [id] ';
//  RsLoc.Connection := DbLoc;
  RsLoc.TableName := 'id';
  RsLoc.Open;

  if RsLoc.EOF then
    RsLoc.Insert
  else
    RsLoc.Edit;

  RsLoc.FieldByName('De').Value:= NULL;
  RsLoc.FieldByName('Ate').Value:= NULL;

  if TryStrToDateTime(gData1, DataAux) then
    RsLoc.FieldByName('De').Value:= DataAux;

  if Tipo=2 then
    if TryStrToDateTime(gData2, DataAux) then
      RsLoc.FieldByName('Ate').Value := DataAux;

  RsLoc.FieldByName('Nome_Cliente').Value := Relatorio.IdRelatorio;
  RsLoc.FieldByName('Nome_Reduzido').Value := gCliente;
  RsLoc.FieldByName('nm_conciliacao').Value := '  ';

  if Length(Trim(gConciliacao)) > 0 then
    RsLoc.FieldByName('nm_conciliacao').Value := gConciliacao;

  RsLoc.FieldByName('MesVariacao').Value := '  ';

  if TryStrToDateTime(gData1, DataAux) then
    RsLoc.FieldByName('MesVariacao').Value := NomeDoMes(IntToStr(GetMonth(StrToDateTime(gData1))));
  // Retira pontos da Conta Contabil
  // RsLoc.Fields("conta_contabil") = Mid$(Concil.ContaContabil, 1, 2) & "." &
  // Mid$(Concil.ContaContabil, 3, 2) & "." &
  // Mid$(Concil.ContaContabil, 5, 2)
  RsLoc.FieldByName('conta_contabil').AsString := Concil.ContaContabil;
  // Insere campo Conta_Emissor
  RsLoc.FieldByName('conta_emissor').AsString := Concil.ContaEmissor;
  RsLoc.UpdateRecord;
end;

procedure BarraStatus;
begin
  fMainForm.sbStatusBar.Panels.Items[1-1].Text := 'Cliente: '+gCliente+'    |    Conciliação:   '+String(Concil.ContaContabil)+' - '+gConciliacao+'   |';
end;

// Deleta arquivos backup para manter apenas os últimos
procedure LimpaBackUp(nBackup: Integer);
var
  NomeArq: String;
  I: Integer;
  ClienteAdoConnection : TAdoCOnnection;
  RsDb : TAdoDataSet;
  DynArray: TStringDynArray;
begin

//  if  not Conecta('') then Exit;

  if not Conecta(ClienteAdoConnection, gDataPath + gDataFile + '.udl') then
    Exit;

  RsDb := TAdoDataSet.Create(nil);
  RsDb.Connection := ClienteAdoConnection;
  sSql := 'select * from BackUp';
  RsDb.CommandText := sSql;
  RsDb.Active := True;

  if not RsDb.EOF then
    begin
    sSql := 'delete from BackUp';
    ClienteAdoConnection.Execute(sSql);
    end;

  NomeArq := gAdmPath+'\';
  NomeArq := NomeArq+gCliente+'\Backup\';
//  NomeBack := Dir(NomeArq+'*.mdb');
  DynArray := TDirectory.GetFiles(NomeArq, '*.mdb', TSearchOption.soTopDirectoryOnly);

  for I := Low(DynArray) to High(DynArray) do
    Begin
//    NomeBack := Dir;
    RsDb.Insert;
    RsDb.FieldByName('arquivo').AsString := DynArray[I];
    RsDb.UpdateRecord;
    End;

  RsDb.Close;
  sSql := 'select * from BackUp order by arquivo';
  RsDb.CommandText := sSql;
  RsDb.Active := True;

  if not RsDb.EOF then
    begin
    RsDb.Last;
    I := RsDb.RecordCount;
    if I > nBackup-1 then
      begin
      for I:=1 to nBackup-1 do
        if  not RsDb.BOF then
          RsDb.Prior;
      while not RsDb.BOF do
        begin
//        DeleteFile(NomeArq+String(RsDb.FieldByName('arquivo').Value));
        DeleteFile(String(RsDb.FieldByName('arquivo').Value));
        RsDb.Prior;
        end;
      end;
    end;

  RsDb.Active := False;
  sSql := 'select * from BackUp';
  RsDb.CommandText := sSql;
  RsDb.Active := True;
  if not RsDb.EOF then
    begin
    sSql := 'delete from BackUp';
    ClienteAdoConnection.Execute(sSql);
    end;

  NomeArq := gAdmPath+'\';
  NomeArq := NomeArq+gCliente+'\BackupMensal\';
//  NomeBack := Dir(NomeArq+'*.mdb');
  DynArray := TDirectory.GetFiles(NomeArq, '*.mdb', TSearchOption.soTopDirectoryOnly);

  for I  := Low(DynArray) to High(DynArray) do
    begin
    RsDb.Insert;
    RsDb.FieldByName('arquivo').AsString := DynArray[I];
    RsDb.UpdateRecord;
    end;

(*  while NomeBack<>'' do begin
    RsDb.Insert;
    VBtoADOFieldSet(RsDb, 'arquivo', NomeBack);
    RsDb.UpdateRecord;
    NomeBack := Dir;
  end;*)

  RsDb.Close;
  sSql := 'select * from BackUp order by arquivo';
  RsDb.CommandText := sSql;
  RsDb.Active := True;

  if not RsDb.EOF then
    begin
    RsDb.Last;
    I := RsDb.RecordCount;
    if I > (nBackup div 2) then
      begin
      for I:=1 to (nBackup div 2) do
        if not RsDb.BOF then
          RsDb.Prior;
      while not RsDb.BOF do
        begin
//        DeleteFile(NomeArq+String(RsDb.FieldByName('arquivo').Value));
        DeleteFile(RsDb.FieldByName('arquivo').AsString);
        RsDb.Prior;
        end;
      end;
    end;

//  Desconecta;
  RsDb.Close;
  RsDb.Free;
  ClienteAdoConnection.Close;
  ClienteAdoConnection.Free;
end;                       (*

function Gera_Resumo: Boolean;
var
  DbAdm, DbConsulta: Database;
  RsAdm, RsDb2, RsConsulta: TADODataSet;
begin
  // Le dados das tabelas adm.clientes, cliente.tb_opcao e cliente.tbcontas
  // e atualiza a tabela consulta.
  DbAdm := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
  DbConsulta := gWork.OpenDatabase(gAdmPath+'\contabil.mdb');

  sSql := '';
  sSql := sSql+'delete from [conta_contabil] ';
  DbAdm.Execute(sSql);

  sSql := '';
  sSql := sSql+'select * from [conta_contabil] ';
  RsConsulta := DbAdm.OpenRecordset(sSql);

  sSql := '';
  sSql := sSql+'Select * from [clientes] ';
  RsAdm := DbAdm.OpenRecordset(sSql);

  while  not RsAdm.EOF do begin // Clientes
    // Obtem o nome do banco de dados e o diretorio de trabalho
    gDataFile := String(RsAdm.FieldByName('Nome_Reduzido').Value)+'.mdb';
    gCliente := RsAdm.FieldByName('Nome_Reduzido').Value;
    gDataPath := gAdmPath+'\'+gCliente+'\';


    if  not Conecta('') then begin
      ShowMessage(PChar('Erro na Abertura do banco: '+gDataFile));
      Exit;
    end;
    sSql := '';
    sSql := sSql+'Select * from [tb_opcao] ';
    sSql := sSql+'where cliente = '#39''+String(RsAdm.FieldByName('Nome_Reduzido').Value)+''#39'';
    RsDb := gBanco.OpenRecordset(sSql);
    while  not RsDb.EOF do begin // tb_opcao
      sSql := '';
      sSql := sSql+'Select * from [tbContas] ';
      sSql := sSql+'where conta_contabil = '#39''+String(RsDb.FieldByName('conta_contabil').Value)+''#39'';
      RsDb2 := gBanco.OpenRecordset(sSql);
      while  not RsDb2.EOF do begin // tbContas
        with RsConsulta do begin
          Insert;

          VBtoADOFieldSet(RsConsulta, 'grupo', RsDb.FieldByName('grupo').Value);
          VBtoADOFieldSet(RsConsulta, 'cliente', RsAdm.FieldByName('Nome_Reduzido').Value);
          VBtoADOFieldSet(RsConsulta, 'Nome_conta_contabil', RsDb.FieldByName('opcao').Value);
          VBtoADOFieldSet(RsConsulta, 'conta_contabil', RsDb.FieldByName('conta_contabil').Value);
          VBtoADOFieldSet(RsConsulta, 'conta', RsDb2.FieldByName('codigo').Value);
          VBtoADOFieldSet(RsConsulta, 'natureza', RsDb2.FieldByName('natureza').Value);
          VBtoADOFieldSet(RsConsulta, 'ref', RsDb2.FieldByName('ref').Value);
          VBtoADOFieldSet(RsConsulta, 'Rel_Origem_Primario', RsDb2.FieldByName('Relatorio_Origem').Value);
          VBtoADOFieldSet(RsConsulta, 'Rel_Origem_Secundario', ' ');
          VBtoADOFieldSet(RsConsulta, 'Template', RsDb2.FieldByName('template').Value);
          VBtoADOFieldSet(RsConsulta, 'Obs_Deb', RsDb2.FieldByName('Obs_Deb').Value);
          VBtoADOFieldSet(RsConsulta, 'Obs_Cred', RsDb2.FieldByName('Obs_Cred').Value);

          UpdateRecord;
        end;
        RsDb2.Next; // Próxima Conta
      end;
      RsDb.Next; // Próxima Conta Contabil
    end;
    RsAdm.Next; // Próximo cliente
  end;
  RsAdm.Close;
  RsDb2.Close;
  DbAdm.Close;
  RsAdm := nil;
  RsDb2 := nil;
  DbAdm := nil;
  Desconecta;
end;
 *)

     (*
function Monta_SACI_OLD: OleVariant;
var
  DbLocal: Database;
  I, J, K: Integer;
  ArqInterface: Integer;
  NomeInterface, Buffer: String;
begin
  // Popula um array para verificação de contas de uma perna SO'
  // Primero gera Débitos e Créditos
  // Marca os SACIs e guarda para NAO GERAR INTERFACE
  // Gerar arquivo de SACIs

  DbLocal := gWork.OpenDatabase(gDataPath+gDataFile);

  sSql := 'select * from Lancamentos';
  sSql := sSql+' where str(Data_Credito) = '#39''+String(CDate(gDataRelatorio))+''#39'';
  sSql := sSql+' or str(Data_Debito) = '#39''+String(CDate(gDataRelatorio))+''#39'';
  RsDb := DbLocal.OpenRecordset(sSql);
  I := 1;
  J := 1;
  with RsDb do begin
    while  not EOF do begin
      if  not IsNull(FieldByName('Data_Debito')) then begin
        if GerarInterface(String(FieldByName('cod_deb').Value)) then begin
          // Gera Debito
          // Procura antes paranao duplicar
          K := I-1;
          while K>0 do begin
            if debitoSACI[K].Codigo=FieldByName('cod_deb') then K := 0;
            K := K-1;
          end;
          if K<>-1 then begin
            SetLength(debitoSACI, I+1);
            debitoSACI[I].Codigo := FieldByName('cod_deb').Value;
            debitoSACI[I].TemPerna := false;
            // Debug.Print .Fields("cod_deb") + "D"
            I := I+1;
          end;
        end;
      end;

      if  not IsNull(FieldByName('Data_Credito')) then begin
        if GerarInterface(String(FieldByName('Cod_cred').Value)) then begin
          // guarda
          // Procura antes para nao duplicar
          K := J-1;
          while K>0 do begin
            if creditoSACI[K].Codigo=FieldByName('cod_cred') then K := 0;
            K := K-1;
          end;
          if K<>-1 then begin
            SetLength(creditoSACI, J+1);
            creditoSACI[J].Codigo := FieldByName('cod_cred').Value;
            creditoSACI[J].TemPerna := false;
            // Debug.Print .Fields("cod_cred") + "C"
            J := J+1;
          end;
        end;
      end;
      Next;
    end;

    SetLength(debitoSACI, I+1);
    debitoSACI[I].Codigo := '999999';
    SetLength(creditoSACI, J+1);
    creditoSACI[J].Codigo := '999999';

    if I>J then begin
      // Tem mais crédito que Débito
      I := 1;
      while Trim(debitoSACI[I].Codigo)<>'999999' do begin
        while J>0 do begin
          // Procura débitos para matar créditos
          K := J-1;
          while K>0 do begin
            if debitoSACI[I].Codigo=creditoSACI[K].Codigo then begin
              debitoSACI[I].TemPerna := true;
              creditoSACI[K].TemPerna := true;
              K := 0;
            end;
            K := K-1;
          end;

          J := J-1;
        end;
        I := I+1;
      end;
     end  else  begin
      // Tem mais Débito que Crédito
      J := 1;
      while Trim(creditoSACI[J].Codigo)<>'999999' do begin
        while I>0 do begin
          // Procura créditos para matar débitos
          K := I-1;
          while K>0 do begin
            if creditoSACI[J].Codigo=debitoSACI[K].Codigo then begin
              creditoSACI[J].TemPerna := true;
              debitoSACI[K].TemPerna := true;
              K := 0;
            end;
            K := K-1;
          end;

          I := I-1;
        end;
        J := J+1;
      end;
    end;
  end;

  ArqInterface := 1{indifferently};
  // Monta data sem barras
  Buffer := '20'+Copy(gDataRelatorio, 7, 2)+Copy(gDataRelatorio, 4, 2)+Copy(gDataRelatorio, 1, 2);
  NomeInterface := ExtractFileDir(Application.ExeName)+'\'+gCliente+'\Interface\SACI_'+Buffer+'.txt';
  if Dir(NomeInterface)<>'' then begin
    DeleteFile(NomeInterface);
  end;

  AssignFile(FileHandle_ArqInterface, NomeInterface); Rewrite(FileHandle_ArqInterface);

  sSql := 'Créditos sem Perna (SACI)'+#10+#10;
  WriteLn(FileHandle_ArqInterface, sSql);
  I := 1;
  J := 1;
  while Trim(creditoSACI[I].Codigo)<>'999999' do begin
    if creditoSACI[I].TemPerna=false then begin
      sSql := sSql+StringOfChar(' ', 8)+String(creditoSACI[I].Codigo)+#10;
      WriteLn(FileHandle_ArqInterface, StringOfChar(' ', 8)+String(creditoSACI[I].Codigo)+#10);
    end;
    I := I+1;
  end;
  sSql := sSql+#10+#10;
  WriteLn(FileHandle_ArqInterface, '');

  sSql := sSql+'Débitos sem Perna (SACI)'+#10+#10;
  WriteLn(FileHandle_ArqInterface, 'Débitos sem Perna (SACI)'+#10+#10);

  while Trim(debitoSACI[J].Codigo)<>'999999' do begin
    if debitoSACI[J].TemPerna=false then begin
      sSql := sSql+StringOfChar(' ', 8)+String(debitoSACI[J].Codigo)+#10;
      WriteLn(FileHandle_ArqInterface, StringOfChar(' ', 8)+String(debitoSACI[J].Codigo)+#10);
    end;
    J := J+1;
  end;
  // MsgBox sSql
  CloseFile(FileHandle_ArqInterface);
  DbLocal.Close;
  DbLocal := nil;
  RsDb := nil;
end;                       *)

 (*
function TipoDePessoa(BIN: String): String;
var
  I: Integer;
begin
  // Se tem no aaray é PJ, supoe-se que tem menos, troca se for contrario
  Result := 'PF';
  I := 1;
  while Trim(TipoPessoa[I].BIN)<>'999999' do begin
    if TipoPessoa[I].BIN=BIN then begin
      Result := 'PJ';
      break;
    end;
    I := I+1;
  end;

end;
// VBto upgrade warning: Cod As String  OnWrite(TField, String)

*)
// VBto upgrade warning: 'Return' As String  OnWrite(String, FixedString)
{function Get_Codigo_Para(Conta: String): String;
var
  I: Integer;
begin
  // 2008/09/04
  // Pega codigo_para na atualização manual, conta tipo 110506

  Result := '';
  I := 1;
  while Trim(mInterface[I].Codigo)<>'999999' do begin
    if Trim(mInterface[I].Conta_contabil)=Conta then begin
      Result := mInterface[I].Codigo;
      break;
    end;
    I := I+1;
  end;
end;    }
(*
// VBto upgrade warning: cnt As Integer  OnWrite(Integer)
function Module1.Zeros_2(cnt: Integer): String; begin Result := Zeros(cnt); end;
function Zeros(var cnt: Integer): String;
begin
  // Gera uma string com zeros para colocar à esquerda do campo
  // Valor no arquivo Interface
  Result := '';
  while cnt>0 do begin
    Result := Result+'0';
    cnt := cnt-1;
  end;
end;

function dataOito(Dt: String): String;
begin
  Result := '20'+Copy(Dt, 7, 2)+Copy(Dt, 4, 2)+Copy(Dt, 1, 2);
end;

function dataDezBarra(Dt: String): String;
begin
  Result := FormatVB(Dt,'YYYY/MM/DD');
  // dataDezBarra = "20" + Mid$(gDataRelatorio, 7, 2) + Mid$(gDataRelatorio, 4, 2) + Mid$(gDataRelatorio, 1, 2)
end;

function dataOitoBarra(Dt: String): String;
begin
  Result := FormatVB(Dt,'YY/MM/DD');
end;

// VBto upgrade warning: cart As String  OnWrite(TField)
function tipoCartao(cart: String): String;
begin
  // Retorna A, V ou M se o nro do cartão for de Amex, Visa ou Master
  Result := ' ';
  
  if Copy(cart, 1, 1)='3' then begin
    Result := 'A';
  end
  else if Copy(cart, 1, 1)='4' then begin
    Result := 'V';
  end
  else if Copy(cart, 1, 1)='5' then begin
    Result := 'M';
  end;
end;
*)
function MontaTabela: Boolean;
label
  ProxCliente;
var
  DbAdm,
  gBanco: TAdoConnection;
  RsAdm{, RsDb2,
  RsDb}: TADODataSet;
//  myCliente, myDataPath, myDataFile: String;
begin
  Result := false;

//  DbAdm := gWork.OpenDatabase(gAdmPath+'\admin.mdb');
  Conecta(DbAdm, ExtractFileDir(Application.ExeName) + '\admin.udl');

  sSql := '';
  sSql := sSql+'TRUNCATE TABLE conciliacoes ';
  DbAdm.Execute(sSql);

//  RsDb := TAdoDataSet.Create(nil);
//  RsDb.Connection := DbAdm;

//  sSql := '';
//  sSql := sSql+'Select * from [conciliacoes] ';
//  RsDb := DbAdm.OpenRecordset(sSql);
//  RsDb.CommandText := sSql;
//  RsDb.Open;

  RsAdm := TAdoDataSet.Create(nil);
  RsAdm.Connection := DbAdm;
//  RsDb2 := TAdoDataSet.Create(nil);
//  RsDb2.Connection := DbAdm;

  sSql := '';
  sSql := sSql+'Select * from [clientes] ';
//  RsAdm := DbAdm.OpenRecordset(sSql);
  RsAdm.CommandText := sSql;
  RsAdm.Open;

  // Salva variáveis globais
//  myCliente := gCliente;
//  myDataFile := gDataFile;
//  myDataPath := gDataPath;
  while  not RsAdm.EOF do
    begin // Clientes
    // Obtem o nome do banco de dados e o diretorio de trabalho
    gDataFile := RsAdm.FieldByName('Nome_Reduzido').AsString;
    gCliente := RsAdm.FieldByName('Nome_Reduzido').AsString;
    gDataPath := gAdmPath+'\'+gCliente+'\';

//    if  not Conecta('') then                               Acho que essa porra aqui é só um teste!!!
    if not Conecta(gBanco, gDataPath + gDataFile + '.udl') then
      begin
      ShowMessage('Erro na Abertura do banco: '+gDataFile);

      RsAdm.Close;
      DbAdm.Close;
      RsAdm.Free;
      DbAdm.Free;

      Exit;
      end;

    gBanco.Close;

    if (gArquivo11 <> 'Geral') and (AnsiUpperCase(gArquivo11) <> AnsiUpperCase(gCliente)) then
      goto ProxCliente;

{    sSql := '';
    sSql := sSql+'Select * from [tbcontasAdm] ';
    sSql := sSql+'where nome_cliente = '#39''+gCliente+''#39'';
//    RsDb2 := DbAdm.OpenRecordset(sSql);
    RsDb2.CommandText := sSql;
    RsDb2.Open;}

    sSql := '';
    sSql := sSql + 'INSERT INTO conciliacoes SELECT [nome_cliente], [conta_contabil], [Codigo], [Codigo_Para] ';
    sSql := sSql + ', [Natureza], [Hist R$], [Hist US$], [Bandeira], [Relatorio_Origem], [Template], [Arquivo_Saida] ';
    sSql := sSql + ', [Observacao], [Junta], [Interface], [Junta2], [Interface2] ';
    sSql := sSql + 'FROM [SISCOC_Admin].[dbo].[tbContasAdm]';
    sSql := sSql + 'where nome_cliente = '#39''+gCliente+''#39'';

    DbAdm.Execute(sSql);

(*    while not RsDb2.EOF do
      begin // tbcontas
      with RsDb do
        begin
        Insert;
        VBtoADOFieldSet(RsDb, 'nome_cliente', RsDb2.FieldByName('nome_cliente').Value);
        VBtoADOFieldSet(RsDb, 'conta_contabil', RsDb2.FieldByName('conta_contabil').Value);
        VBtoADOFieldSet(RsDb, 'codigo', RsDb2.FieldByName('codigo').Value);
        VBtoADOFieldSet(RsDb, 'codigo_para', RsDb2.FieldByName('codigo_para').Value);
        VBtoADOFieldSet(RsDb, 'natureza', RsDb2.FieldByName('natureza').Value);
        VBtoADOFieldSet(RsDb, 'Hist R$', RsDb2.FieldByName('Hist R$').Value);
        VBtoADOFieldSet(RsDb, 'Hist US$', RsDb2.FieldByName('Hist US$').Value);
        VBtoADOFieldSet(RsDb, 'Bandeira', RsDb2.FieldByName('Bandeira').Value);

        VBtoADOFieldSet(RsDb, 'Relatorio_Origem', RsDb2.FieldByName('Relatorio_Origem').Value);
        VBtoADOFieldSet(RsDb, 'Arquivo_Saida', RsDb2.FieldByName('Arquivo_Saida').Value);
        VBtoADOFieldSet(RsDb, 'Template', RsDb2.FieldByName('template').Value);
        VBtoADOFieldSet(RsDb, 'Observacao', RsDb2.FieldByName('Observacao').Value);
        VBtoADOFieldSet(RsDb, 'junta2', RsDb2.FieldByName('junta2').Value);
        VBtoADOFieldSet(RsDb, 'interface2', RsDb2.FieldByName('interface2').Value);
        UpdateRecord;
        end;
      RsDb2.Next; // Próxima Conta
      end;*)

  ProxCliente:
    RsAdm.Next; // Próximo cliente
  end;
  // Restaura variáveis globais
//  gCliente := myCliente;
 // gDataFile := myDataFile;
 // gDataPath := myDataPath;

  RsAdm.Close;
//  RsDb2.Close;
  DbAdm.Close;
//  RsDb.Close;
  RsAdm.Free;
//  RsDb2.Free;
  DbAdm.Free;
//  RsDb.Free;
//  Desconecta;
//  gBanco.Close;
  gBanco.Free;
  Result := true;
end;

(*
function MontaTabela_BAK: Boolean;
label
  ProxCliente;
var
  DbAdm: Database;
  RsAdm, RsDb2: TADODataSet;
  myCliente, myDataPath, myDataFile: String;
begin
  Result := false;

  gWork := DBEngine.Workspaces(0);
  DbAdm := gWork.OpenDatabase(gAdmPath+'\admin.mdb');

  // sSql = ""
  // sSql = sSql & "delete from conciliacoes "
  // DbAdm.Execute sSql
  // 
  // sSql = ""
  // sSql = sSql & "Select * from [conciliacoes] "
  // Set RsDb = DbAdm.OpenRecordset(sSql)

  sSql := '';
  sSql := sSql+'Select * from [clientes] ';
  RsAdm := DbAdm.OpenRecordset(sSql);

  // Salva variáveis globais
  myCliente := gCliente;
  myDataFile := gDataFile;
  myDataPath := gDataPath;
  while  not RsAdm.EOF do begin // Clientes
    // Obtem o nome do banco de dados e o diretorio de trabalho
    gDataFile := String(RsAdm.FieldByName('Nome_Reduzido').Value)+'.mdb';
    gCliente := RsAdm.FieldByName('Nome_Reduzido').Value;
    gDataPath := gAdmPath+'\'+gCliente+'\';

    if  not Conecta('') then begin
      ShowMessage(PChar('Erro na Abertura do banco: '+gDataFile));
      Exit;
    end;

    if (gArquivo11<>'Geral') and (AnsiUpperCase(gArquivo11)<>AnsiUpperCase(gCliente)) then begin
      goto ProxCliente;
    end;
    sSql := '';
    // sSql = sSql & "Select * from [tbcontas] "
    sSql := sSql+'Select * from [tbcontasAdm] ';
    RsDb2 := DbAdm.OpenRecordset(sSql);
    while  not RsDb2.EOF do begin // tbcontas
      with RsDb do begin
        Insert;
        VBtoADOFieldSet(RsDb, 'Cliente', gCliente);
        VBtoADOFieldSet(RsDb, 'conta_contabil', RsDb2.FieldByName('conta_contabil').Value);
        VBtoADOFieldSet(RsDb, 'codigo', RsDb2.FieldByName('codigo').Value);
        VBtoADOFieldSet(RsDb, 'natureza', RsDb2.FieldByName('natureza').Value);
        VBtoADOFieldSet(RsDb, 'ref', RsDb2.FieldByName('ref').Value);
        VBtoADOFieldSet(RsDb, 'Relatorio_Origem', RsDb2.FieldByName('Relatorio_Origem').Value);
        VBtoADOFieldSet(RsDb, 'Arquivo_Saida', RsDb2.FieldByName('Arquivo_Saida').Value);
        VBtoADOFieldSet(RsDb, 'Template', RsDb2.FieldByName('template').Value);
        VBtoADOFieldSet(RsDb, 'Observacao', RsDb2.FieldByName('Observacao').Value);
        UpdateRecord;
      end;
      RsDb2.Next; // Próxima Conta
    end;
  ProxCliente:
    RsAdm.Next; // Próximo cliente
  end;
  // Restaura variáveis globais
  gCliente := myCliente;
  gDataFile := myDataFile;
  gDataPath := myDataPath;

  RsAdm.Close;
  RsDb2.Close;
  DbAdm.Close;
  RsAdm := nil;
  RsDb2 := nil;
  DbAdm := nil;
  Desconecta;
  Result := true;
end;

procedure ShowFileAccessInfo(filespec: OleVariant);
var
  fs: ???;
  f: ???;
  S: String;
begin
  fs := CreateOleObject('Scripting.FileSystemObject');
  f := fs.GetFile(filespec);
  S := AnsiUpperCase(filespec)+#13#10;
  S := S+'Created: '+String(f.DateCreated)+#13#10;
  S := S+'Last Accessed: '+String(f.DateLastAccessed)+#13#10;
  S := S+'Last Modified: '+String(f.DateLastModified);
  Application.MessageBox(PCHAR(S), 'File Access Info', vbApplicationModal);
end;

// VBto upgrade warning: sFile As OleVariant --> As String
// VBto upgrade warning: 'Return' As TDateTime  OnWrite(String)
function LastModifica(sFile: String): TDateTime;
label
  Erro;
var
  fs: ???;
  f: ???;
  S: OleVariant;
begin
  try  // On Error GoTo Erro
    fs := CreateOleObject('Scripting.FileSystemObject');
    f := fs.GetFile(sFile);
    Result := CDate(f.DateLastModified);
    Exit;
  except  // Erro:
    ShowMessage(PChar('Err.Description'));
    Err.Clear;
    Result := '';
  end;
end;

function LastBackup(sDir: OleVariant): String;
var
  LastData, Arquivo: String;
begin
  Arquivo := Dir(String(sDir)+'*.mdb');
  Result := Arquivo;

  while Arquivo<>'' do begin
    if LastModifica(String(sDir)+Result)<LastModifica(String(sDir)+Arquivo) then begin
      Result := Arquivo;
    end;
    Arquivo := Dir;
  end;
end;
*)

(*procedure DoLogin;
var
  fLogin: Form;
begin
  fLogin := TfrmLogin.Create(nil);

  gNomeComputador := MeuComputador;
  if (gNomeComputador='CR-SCC') or (gNomeComputador='CR-SHRMQOV7U4H1') or (gNomeComputador='vrocha-vm') then begin

    gNivel := cADM;
    gNomeUsuario := '0';
    gOperador := '0';
   end  else  begin
    fLogin.ShowModal;
    if  not fLogin.OK then begin
      ShowMessage('Usuário não autorizado!');
      Application.Terminate;
    end;
    fLogin.Close;
    fLogin := nil;
  end;
end;*)

(*
function MeuComputador: String;
var
  sBuffer, Name: String;
  lSize: Integer;
begin

  sBuffer := StringOfChar(' ', 255);
  lSize := Length(sBuffer);
  GetComputerName(sBuffer, lSize);
  if lSize>0 then begin
    Result := LeftStr(sBuffer, lSize);
   end  else  begin
    Result := '';
  end;

end;                   *)

// VBto upgrade warning: 'Return' As OleVariant --> As String
function TruncaPath(Path: String; Tam: Integer): String;
begin
  Result := Path;
  if Length(Path)>Tam then begin
    Result := Copy(Path, 1, 10)+'...'+RightStr(Path, Tam-13);
  end;
end;

function DiaUtil(Dt: TDateTime): Boolean;
begin
  Result := true;
  if (DayOfWeek(Dt)=1) or (DayOfWeek(Dt)=7) then begin
    Result := false;
  end;
  // Verificar Feriados
end;

(*function openLog: Boolean;
var
  A: Integer;
begin
  gLogLevel := getLogLevel;
  if gLogLevel>0 then;
end;

function renLogFile(logPath: OleVariant): Boolean;
var
  pathLog, logFile, NameFrom, NameTo: String;
  I: Integer;
begin
  // Renomeia arquivos antigos e
  // Cria arquivo novo: sccLog
  if pathLog='' then pathLog := ExtractFileDir(Application.ExeName)+'\'+gCliente+'SCC_LOG\';
  logFile := Dir(pathLog+'sccLog*.log');
  if logFile<>'' then begin
    // Renomeia arquivos antigos para criar o novo
    I := 1;
    while logFile='' do begin
      NameFrom := 'sccLog'+FormatVB(I,'99');
      I := I+1;
    end;

    while I>0 do begin
      NameFrom := 'sccLog'+FormatVB(I,'99');
      NameTo := 'sccLog'+FormatVB(I-1,'99');
      // Name NameFrom As NameTo
    end;
  end;
end;

function getLogLevel: Integer;
var
  EnvString: OleVariant;
  Indx: Integer;
  PathLen: Integer;
begin
  // Procura SCC_Log_Level nas variaveis de ambiente
  // Nivel de detalhe do arquivo de LOG
  // 0 = sem log
  // 1 a 5 nivel de detalhe
  // nome do arquivos = sccLog.log
  // sccLog01.log
  // sccLog02.log
  // ...

  // Declare variables.
  Indx := 1; // Initialize index to 1.
  Result := 0;
  repeat
    EnvString := Environ(Indx); // Get environment
    if LeftStr(EnvString, 13)='SCC_Log_Level' then begin // Check Log Level entry.
      PathLen := Length(Environ('SCC_Log_Level')); // Get length.
      Result := Environ('SCC_Log_Level');
      break;
     end  else  begin
      Indx := Indx+1; // Not PATH entry,
    end; // so increment.
  until EnvString='';
end;
                       (*
// VBto upgrade warning: 'Return' As Integer  OnWrite(Integer)
function openFile(fName: String; mode: String): Integer;
var
  Arquivo: Integer;
begin
  Arquivo := 1{indifferently};
  
  if mode='Input' then begin
    AssignFile(FileHandle_Arquivo, fName); Reset(FileHandle_Arquivo);
  end;
  Result := Arquivo;
end;

function testeOpenFile: Boolean;
var
  I: Integer;
  Buffer: String;
begin
  I := openFile('C:\caisslog.txt', 'Input');
  ReadLn(FileHandle_I, Buffer);
  CloseFile(FileHandle_1);
  Result := true;
end;

(*function testeOpenFileActivex: Boolean;
var
  I: Integer;
  Buffer: String;
  myActivex: ???;
begin
  myActivex := CreateOleObject('sccFile.clsFile');
  myActivex.openFile('C:\caisslog.txt', 'Input'); // OK
  while  not myActivex.endoffile do begin
    Buffer := myActivex.line_input;
    OutputDebugString(Buffer);
  end;
  myActivex.closefile;
end; *)

// VBto upgrade warning: dataDe As OleVariant --> As String
// VBto upgrade warning: dataAte As OleVariant --> As String  OnRead(TDateTime)
function JuncaoDeJuntado(dataDe: TDateTime; dataAte: String): Boolean;
label
  Saida;
var
  dataJuncao, pathJuntado, tmpStr: String;
  ArqSaida, ArqEntrada: System.Text;
  DataJuntado: TDateTime;
begin
  // Junta arquivos Juntado da data De ate a data Ate
  Result := True;

  gArquivo11 := '';
  tmpStr := 'Junção de arquivos juntados '+#10+#10;

  pathJuntado := ExtractFileDir(Application.ExeName)+'\';
  pathJuntado := pathJuntado+gCliente+'\entrada\'+'JUNTADO_20';
  dataJuncao := Copy(dataAte, 7, 2)+Copy(dataAte, 4, 2)+Copy(dataAte, 1, 2);

 if FileExists(pathJuntado+dataJuncao+'.jto') then
    begin
    DeleteFile(pathJuntado+dataJuncao+'.jto');
    end;
  if Not FileExists(pathJuntado+dataJuncao+'.txt') then
    begin
    tmpStr := tmpStr+pathJuntado+dataJuncao+'.txt Não Localizado'+#10+#10;
    Result := False;
    goto Saida;
    end;

  CopyFile(PChar(pathJuntado+dataJuncao+'.txt'), PChar(pathJuntado+dataJuncao+'.jto'), false);
  tmpStr := tmpStr+pathJuntado+dataJuncao+'.jto juntado!!!'+#10;

  AssignFileAsAppend(ArqSaida, pathJuntado+dataJuncao+'.txt');

  DataJuntado := StrToDateTime(dataAte);
  DataJuntado := DataJuntado-1;
  while DataJuntado >= dataDe do
    begin
    if Length(Copy(DateTimeToStr(DataJuntado), 9, 2)) > 0 then
      dataJuncao := Copy(DateTimeToStr(DataJuntado), 9, 2) + Copy(DateTimeToStr(DataJuntado), 4, 2) +
                    Copy(DateTimeToStr(DataJuntado), 1, 2)
    else
      dataJuncao := Copy(DateTimeToStr(DataJuntado), 7, 2) + Copy(DateTimeToStr(DataJuntado), 4, 2) +
                    Copy(DateTimeToStr(DataJuntado), 1, 2);

    if FileExists(pathJuntado+dataJuncao+'.txt') then
      begin
      AssignFile(ArqEntrada, pathJuntado+dataJuncao+'.txt');
      Reset(ArqEntrada);
      // Append arquivo
      while not Eof(ArqEntrada) do
        begin
        ReadLn(ArqEntrada, sSql);
        WriteLn(ArqSaida, sSql);
        end;
      CloseFile(ArqEntrada);
      if FileExists(pathJuntado+dataJuncao+'.jto') then
        DeleteFile(pathJuntado+dataJuncao+'.jto');

      RenameFile(pathJuntado+dataJuncao+'.txt', pathJuntado+dataJuncao+'.jto');
      tmpStr := tmpStr+pathJuntado+dataJuncao+'.jto juntado!!!'+#10;
      end
    else
      tmpStr := tmpStr+pathJuntado+dataJuncao+'.txt Não Localizado'+#10;

    DataJuntado := DataJuntado-1;
    end;
  CloseFile(ArqSaida);
  // zzzzzzzzzzzzzzzzzzzzzzzzzzzz

  // Mostra a configuração da conciliação
Saida:
  frmLog.RichTextBox1.Text := tmpStr+#13#10;

  gArquivo11 := frmLog.RichTextBox1.Text;
  frmLog.Close;
  frmLog.Show;
  ShowMessage('Junção de arquivos juntados OK');
  frmLog.Close;
  frmLog.ShowModal;

end;

initialization

  gLimiteVariacao := 0;
  gAtualizaGeral := false;
  gEliminaDuplicacao := false;
  gForcaReal := false;
  gForcaDolar := false;
  gLimpAuto := 0;
  gColuna13 := 0;
  gNivel := 0;
  bConectado := false;
  gOrdem := 0;
  gAlteraLanc := 0;
  LinhaAtual := 0;
  iCountReg := 0;
//  iPonteiro := 0;
  gNegativo := false;
  gTipo_Rec := 0;
  gDtMovInvalida := false;
  gBIN := nil;
  gBinGeral := nil;
  ncDebito := 0;
  ncCredito := 0;
  gDEBUG := false;
  gLOCAL := false;
  gTESTE := false;
  gNroReg := 0;
  gAutomatico := false;
  gTotDebito := 0;
  gTotCredito := 0;
//  gArqEntrada := nil;
  gNReg := 0;
  gArrConcil := nil;
  gArrConcil2 := nil;
  gArrConcil3 := nil;
  gMaxCon := 0;

end.
