Unit MdiMultiCold;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, ComCtrls, Db, StdCtrls, Buttons, ExtCtrls,
  Menus, DBClient, MConnect, SConnect, ComObj, OleServer, {Word97,}
  IMulticoldServer1, ADODB, SutypGer, InvokeRegistry, System.UITypes,
  Pilha, Vcl.FileCtrl, DBTables, dfcontrols, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;
//  adsdata, adsfunc, adstable;


{
  24/02/2000
  Exclusão de campo do template: Era sempre o último o excluído, agora o ativo é o excluído. Toda a parte de referência
                                 aos componentes StringGrid teve de ser alterada
  A mudança na forma de excluir havia criado um bug na importação de campos - Fixed
  A referência das definições de campos da DFN, quando da importação, estavam no Grid do Form Analisador. O Grid
  auxiliar e de cada relatório foi usado para armazenar estas definições em cada abertura de relatório. A referência
  do template foi alterada para o Grid auxiliar.
  R4 - 11/03/2000
  O form Analisador tinha em seu método CreateForm código para ler do ini cold_service.ini
  A alteração consistiu da identificação do programa sendo executado para não fazer a leitura do ini pelo multedit.exe
  22/03/2000 - Pequenas modificações na geração do SQL a partir do form de Query Fácil
  1) O mesmo campo pode ser referenciado mais de uma vez com And o OR
  2) O Not foi reposicionado, pois verificou-se que o BDE o está aceitando próximo do operador no Select.
  3) Reativação do OR apenas para o mesmo campo e sem estar misturado a And
  23/03/2000 - A impressão de pesquisa com várias linhas em uma página estava com problema.
               Em cada página, apenas a última linha marcada era impressa. O Programa não
               estava verificando a presença de mais de um campo na query de resposta.
               O Not foi recolocado em seu lugar, antes da sentença, pois alguns operadores
               como = não aceitam a construção NOT =, e sim NOT Campo =. O programa retira o
               NOT do campo e o devolve para manter a integridade do operador no Grid.
  24/04/2000 - Outro dia percebi que a variável filemode não estava sendo alterada para
               0 (abrir read only). Ao testar com arquivos vindos de CD o programa não abriu
               os relatórios pois os arquivos conservavam o status read only do CD. Coloquei
               Filemode = 0 na rotina de abertura dos relatórios e no final retorna o valor
               read write, FileMode = 2
  17/05/2000 - Foi realizada a centralização das telas dos forms do programa
  18/05/2000 - O bug do ponteiro buffer estava causando  uma instabilidade enorme ao programa. No form create dos forms
               filhos havia um buffer := nil, sendo o buffer uma variável global para uso de todas as janelas abertas.
               Esta inicialização foi colocada no create form deste form aqui (pai);
               A correção deste problema não ajudou em nada. Na leitura dos dados guardados em disco, quando da mudança
               de janela e de modo (texto/imagem) não havia o redimencionamento do buffer de I/O. Se a janela anterior o
               houvesse setado para um tamanho menor, mudar a janela e mudar o modo provocava uma leitura dos dados em
               disco e consequentemente uma invasão de memória que com o tempo explodia o programa.
  19/05/2000 - Ainda se verificou um abend ao fechar o programa na seguinte situação:
               Várias janelas abertas, manipulações, uma fechada, fechado o programa. Para
               Tentar corrigir no onclose do MDIPai foi colocado um loop fechando todas as
               janelas filhas.
  23/05/2000 - Implementado o esquema de segurança. Esta versão abre os relatórios antigos e os novos seguros ou não.
               O Editor antigo se torna incompatível com os relatórios produzidos a partir de agora. O IAP passou a
               utilizar registro Int64 podendo (teoricamente) gerar arquivos de mais de 2gb de tamanho.
  26/05/2000 - Coloquei um offset maior no cálculo do scroll inicial da página com pesquisa para puxar a imagem da
               página mais para cima no caso dos campos localizados mais em baixo. DESCOBRI QUE O "COINITIALIZE não
               foi chamado" retorna se um componente XCeedZip for colocado em algum form deste projeto???? Instanciar
               o objeto XCeed na hora do uso funciona (no DFN) e não dá problema.
  14/06/2000 - Pesquisas levaram a conclusão que o problema do menu das telas child desta aplicação MDI pode ser resolvido
               com o uso de apenas um menu principal (controlando as opções com enable := true ou false. Há um problema
               no gerenciamento da fusão dos menus principal e filhos (não sei se do Delphi ou do Windows);
  20/06/2000 - Implementação da versão cliente servidor...
  R26 - 04/06/2001
  Melhora do controle da janela de abertura assistida para o caso onde há uma base interbase controlando mas o usuário
  não vai pegar relatórios no servidor e sim direto do cd e portanto não tem relatórios associados. A janela de abertura
  assistida vinha vazia
  R27 - 04/07/2001
  Tratamento da query is null, que no caso de caractere ficava is "null", dando erro.
  R28 - 06/07/2001
  Troca do engine de RealForm para Defined
  R29 - 11/07/2001
  Acerto da visualização da página com máscara que estava truncada se maior que o vídeo
  R30 - 13/07/2001
  Acerto dos arrays para a pesquisa de grupo e subgrupo na montagem dos paths para a abertura remota. A referência
  estava nos arrays locais.
  R31 - 23/07/2001
  Colocação to timer com a procedure idle controlando a execução do programa, mais de 10 minutos de inatividade o programa
  será automaticamente fechado.
  R32 - 30/07/2001
  Mudança da propriedade Default dos botões de acordo com o edit utilizado para o botão v da pesquisa e para o botão v do
  scroller de página. No grid de pesquisa, teclar enter aciona o evento click do botão Ok.
  R33 - 06/08/2001
  Puxar o position da imagem um pouco mais para cima. Pesquisas além do limite mostrável da tela continuavam escondidas.
  Término da implementação da pesquisa especial. Impressão, abertura e exportação das pesquisas.
  r34 17/08/2001
  If do clipboard para exportação especial estava testando o valor 'WORD', causando problemas. A opção de abertura não
  testava o sucesso da pesquisa realizada nos relatórios selecionados, se falhar fecha o relatório...
  r35 23/08/2001
  A exportação especial para o Excel estava com bug. O indexador de linha, K, era uma variável interna de uma procedure.
  Ao ser chamada a primeira vez era inicializada com 1 e incrementada a cada linha exportada. Ao mudar de relatório não
  era inicializada para dar continuidade à exportação para dentro do Excel aberto, porém como era interna ficava com
  valor 0 provocando erro no ole pois não há linha 0 no Excel. A variável foi mudada de nome, IExcel, e colocada na
  SuGeral.
  r36 28/08/2001
  Ao fechar o form do relatório aberto, o programa dá um close nos componentes Query1 e ClientDataSet1. Isto está sendo
  feito para tentar aliviar o uso de recursos do BDE que ficam presos quando o relatório é fechado.
  r37 23/09/2001
  Alteração do salvamento de pdf. O nome do pdf é o mesmo informado, todas as páginas exportadas são reunidas em um único
  pdf e a página A3 do pdf foi aumentada para caber o extrato de 4 da Caixa.
  r38 15/10/2001
  Implementação da localização sem índice...
  r39 23/10/2001
  Revisão da rotina de crioulo doido que não permitia misturar o uso normal do arquivo com o crioulo doido
  r40 29/10/2001
  Revisão da rotina de crioulo doido, erro de abertura de arquivo quando o primeiro relatório da lista da pesquisa=[]
  Havia um pdf.free, que no caso de abertura dos arquivos provocava um erro pois não havia sido inicializado.
  Coloquei um try para evitar o erro.
  Acertei a rotina de impressão para chamar o printdialog controlado pela variável AbriuArqDsc em vez da variável Primeiro
  que fica false mesmo que o primeiro relatório não seja impresso. AbriuArqDsc controla a abertura deste arquivo ou a
  exibição do PrintDialog a primeira vez que for realmente utilizado.
  Criei um formulário com o status resumo da pesquisa especial.
  Na mistura de especial com normal, a opção default de página atual na descompactação e impressão não estava default.
  Forçar o pedido do nome do arquivo quando várias opções de decompactação são usadas, tipo txt e depois pdf sem sair.
  r41 28/11/2001
  Alterada rotina de I/O para ler arquivos de relatórios com mais de 2gb!!
  Alterado o plugin de pdf para manipular as fontes dos relatórios com máscara, text soma .tag no tamanho da fonte e
    pode ser, então, aumentado ou diminuido
  r41 22/12/2001
  No relatório de giro da caixo o programa estava abortando por access violation. Havia um try que foi retirado e então
  o programa passou a mostrar mensagens de erro na máscara. Uma página com mais linhas que fields correspondentes também
  causava erro. O programa está verificando e avisando do problema e evitando os abends...
  r41 27/12/2001
  Implementação da abertura automática da conexão remota através do arquivo urlremote.dat
  r42 30/01/2002
  Passei a usar outro OpenFileDialog no Especial (o 2) para evitar conflitos com o 1 usado par abrir os scripts no
  diretório c:\coldcfg. Dessa forma o dialog fica apontando sempre para os relatórios evitando navegações desnecessárias.
  Coloquei para desligar PesquisaEspecial quando a rotina de queryfacil terminar.
  r43 12/03/2002
  Alterei o programa para usar o diretório temporário do sistema onde está rodando para criar os arquivos temporários.
  Incluí YYYMMDDHHNNSS na sugestão de nome de arquivo para salvar as descompactações......
  r44 25/03/2002
  Coloquei o refresh do timer nas rotinas Descom, Imprim, Localizar, Extract e especial pois extrações longas não
  estavam terminando, o programa saía antes.
  No modo texto o timer fica desligado pois o Memo não chama o evento que refresca o timer.
  Procurei garantir com ForceDirectories a criação dos diretórios bde e coldcfg dentro do temp apontado pelo windows da
  máquina além do coldcfg na raiz do C: (C:\COLDCFG) para o armazenamento dos arquivos de script.
  r44 19/04/2002
  O Extrator acessava Valcampos[1] diretamente, o que, quando ela estava vazia provocava acess violation.
  r44 20/04/2002
  Dei uma geral nos tab orders.
  r44 23/05/2002
  Conversão para Delphi6. Na impressão, coloquei um TrimRight para eliminar os brancos à direita da linha antes de mandar
  para a impressora.
  r44 01/07/2002
  A flag ConectouRemoto não estava sendo alterada para = True, após a conexão com sucesso o que provocava reconexões a
  cada click na AberturaRemota. Na rotina AssisAbreRemoto, colocava = False se não houvesse relatórios para mostrar.
  No último fechado, reabre o assisabre ou assisabreremoto de acordo com a última tela utilizada...
  Coloquei um pequeno help nas regras do extrator de dados.
  Ajustei o cabeçalho do extrator quando há um separador de campos.
  Coloquei a informação de ProcurarNaMesmaLinha e ProcurarEmSequência do QueryFácil para ser salva junto com o arquivo
  dos dados das queries...
  r45 16/03/2003
  Acertado o bug de consumo de memória da extração de dados .xtr
  r45 20/03/2003
  Retirado o Timer de 10 minutos por causar problemas ao abortar o programa no meio de determinadas operações....  
  r45 29/04/2003
  Não havia tratamento para a flag de comprimebrancos ---> implementado
  r45 28/05/2003
  Gerador de página acertada -> Na normal CrLfCrLf saía como CrLf Lf -> Após o Lf o programa queria um controle de carro,
  que neste caso, não era...
  r1 20/05/2004
  Colocado SqlServer como servidor de banco de dados.
  Colocado controle de botão scroll do mouse para rolar a página do relatório ---> não está muito bom não!
  Colocado anotações de texto e gráficas
     10/06/2004
  Bloqueio de campos início de implementação...
     08/08/2004
  Passou a marcar só o campo pesquisado e não mais a linha toda.
  Pesquisa especial turbinada. Repete a programação anterior sem precisar ir para o form de EspecialU
  v7.0
  r1 - Formulário e pdf via o define
  r2 - A query de restrição de campos estava no open do rel então qdo sem seg dava erro, foi para dentro do
       verificaseguranca

  v 8.0.0.5 - 07/06/2013

  Compilado no Delphi XE4
  Alterações para a compatibilidade da nova String de 2 bytes (Unicode)
  Reformatação do form de extração que ficou zuado na importação para o XE4

  v 8.0.0.6 - 12/06/2013

  Coloquei a unit MIDASLIB para evitar/dispensar a carga da Midas.dll no cliente

  v 8.1.0.6 - 23/07/2013

  Subrug com a procura pelo ponto da direita para a esquerda podendo processar corretamente nomes de arquivo com
  vários pontos - SeArquivoSemExt -> Para a Caixa Econômica Federal

  v 8.1.1.6 - 06/08/2013

  Retirados os comentários da logação de abertura de relatórios ara voltar a logar. As strings a serem gravadas no BD
  foram truncadas para o tamanho máximo do campo, pois o SQLServer estava chiando quando maiores.

  v 8.1.2.6 - 12/08/2013

  Quando há separador de campos na extração, o tamanho de saída passa a ser o resutado do campo depois de todas as
  formatações realizadas

  V 8.2.2.6 - 13/08/2013

  Incluí o tipo "C" no campo "obrigatório" que vai carregar o valor deste campo em memória para posterior descarga...

  V 8.3.2.6 - 20/08/2013

  Incluí o filtro STRINCAMPO que vai inserir uma string no campo numa dada coluna.

  V 8.4.2.6 - 06/09/2013

  Na alteração dos formatos de data há conversão de valore numericos que não estavam protegidos. Agora, a conversão
  foi protegida, uma mensagem é mostrada ao usuário e a extração é encerrada.

  V 8.4.2.7 - 21/09/2013

  Estranhamente o ArqDscNew em Descom não estava inicializado para opção <Página Atual>

  V 8.4.2.8 - 05/11/2013

  Minor alterations at dfPDF para torná-la compatível com a nova String do Delphi XE4, unicode

  V 8.4.2.9 - 06/11/2013

  Ainda tinha ficado faltando alterar a procedure UpdatePageParentRefs que não estava grando as informações
  de forma correta por manipuação de Pchar, em vez de PAnsiChar. O interessante é que o PDF gerado podia ser
  aberto no Word (2012), no leitor do W8 e no adobe touch, mas não no adobe reader de nenhuma versão do Windows.

  V 8.4.2.10 - 13/11/2013

  Coloquei o teste da versão do Excel do Automation, abaixo de 13, limite de 65536 linhas e depois, sem teste...

  V 8.4.2.11 - 13/11/2013

  Coloquei o teste de 1.048.576 linhas nas versões do Excel de 13 para cima...

  V 8.4.2.12 - 14/11/2013

  Agora tira os brancos na exportação da página inteira além de quando um template é selecionado

  V 8.4.2.13 - 22/11/2013

  Faz a conversão de data com entrada MMM que significa um mês literal, como NOV

  V 8.4.2.14 - 27/11/2013

  ExcelApp := GetActiveOleObject('Excel.Application');
        // If no instance of Excel is running, try to Create a new Excel Object -> Não funciona a contento, retirado!

  V 8.5.0.0 - 14/02/2014
              BDE is OUT!!!!!!!!!!!!!!!!!
  }

Type
  TFrameForm = Class(TForm)
    PrinterSetupDialog1: TPrinterSetupDialog;
    OpenReportDialog: TOpenDialog;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    MemoAux: TMemo;
    Timer1: TTimer;
    PilhaExecucao: TPilha;
    FileListBox1QuePorraEhIsso: TFileListBox;
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    AbrirAssistido1: TMenuItem;
    AbrirRemoto1: TMenuItem;
    Fechar1: TMenuItem;
    N1: TMenuItem;
    ConfigurarImpressora1: TMenuItem;
    ConfigurarFontedeImpresso1: TMenuItem;
    ImprimirRelatrio1: TMenuItem;
    ExportarRelatrio1: TMenuItem;
    DescompactarRelatrio1: TMenuItem;
    PesquisaemGrupo1: TMenuItem;
    Separator3: TMenuItem;
    Exit1: TMenuItem;
    Editar1: TMenuItem;
    CopiarPgina1: TMenuItem;
    AproximarZoom1: TMenuItem;
    AfastarZoomOut1: TMenuItem;
    Normal1001: TMenuItem;
    ConfigurarFontedeVdeo1: TMenuItem;
    ConfigurarCordoFundo1: TMenuItem;
    ModoTexto1: TMenuItem;
    CopiarTextoSelecionado1: TMenuItem;
    Escala1: TMenuItem;
    mScreenWidth: TMenuItem;
    mScreenHeight: TMenuItem;
    m200: TMenuItem;
    m150: TMenuItem;
    m100: TMenuItem;
    m75: TMenuItem;
    m50: TMenuItem;
    Pesquisar1: TMenuItem;
    MontarQueryFcil1: TMenuItem;
    RepeteltimaPesquisa1: TMenuItem;
    Prxima1: TMenuItem;
    Anterior1: TMenuItem;
    Especial1: TMenuItem;
    Localizar1: TMenuItem;
    LocalizarPrxima1: TMenuItem;
    rEMOTO1: TMenuItem;
    ConsultarStatusProcessamento1: TMenuItem;
    DownloadManager1: TMenuItem;
    Pgina1: TMenuItem;
    Prxima2: TMenuItem;
    Anterior2: TMenuItem;
    Window1: TMenuItem;
    Tile1: TMenuItem;
    LadoaLado1: TMenuItem;
    Cascade1: TMenuItem;
    ArrangeIcons1: TMenuItem;
    Info1: TMenuItem;
    SobreoMultiCold1: TMenuItem;
    He1: TMenuItem;
    Espaco1: TMenuItem;
    SpeedPanel: TPanel;
    PlusZoom: TSpeedButton;
    LessZoom: TSpeedButton;
    NormalZoom: TSpeedButton;
    AbreQueryFacil: TSpeedButton;
    RepetePesquisa: TSpeedButton;
    Label5: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    AbreRelBut: TSpeedButton;
    Imprimir: TSpeedButton;
    Descompactar: TSpeedButton;
    ExportarSpeedButton: TSpeedButton;
    Label3: TLabel;
    ExtrairSpeedButton: TSpeedButton;
    EspecialSpeedButton: TSpeedButton;
    AnotarGraphSpeedButton: TSpeedButton;
    AnotarTextoSpeedButton: TSpeedButton;
    Animate1: TSpeedButton;
    Animate2: TSpeedButton;
    Label2: TLabel;
    EditPes: TEdit;
    VaiPesquisa: TButton;
    EditPag: TEdit;
    VaiPagina: TButton;
    Memo2: TMemo;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    FDQuery1: TFDQuery;
    Procedure AbreRelButClick(Sender: TObject);
    Procedure Exit1Click(Sender: TObject);
    Procedure Tile1Click(Sender: TObject);
    Procedure LadoaLado1Click(Sender: TObject);
    Procedure Cascade1Click(Sender: TObject);
    Procedure ArrangeIcons1Click(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure PlusZoomClick(Sender: TObject);
    Procedure LessZoomClick(Sender: TObject);
    Procedure NormalZoomClick(Sender: TObject);
    Procedure AbreQueryFacilClick(Sender: TObject);
    Procedure RepetePesquisaClick(Sender: TObject);
    Procedure VaiPesquisaClick(Sender: TObject);
    Procedure VaiPaginaClick(Sender: TObject);
    Procedure ImprimirClick(Sender: TObject);
    Procedure PesquisaemGrupo1Click(Sender: TObject);
    Procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      Var ScrollPos: Integer);
    Procedure ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
      Var ScrollPos: Integer);
    Procedure DescompactarClick(Sender: TObject);
    Procedure ExportarSpeedButtonClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure SobreoMultiCold1Click(Sender: TObject);
    Procedure AbrirAssistido1Click(Sender: TObject);
    Procedure Fechar1Click(Sender: TObject);
    Procedure ConfigurarImpressora1Click(Sender: TObject);
    Procedure ConfigurarFontedeImpresso1Click(Sender: TObject);
    Procedure CopiarPgina1Click(Sender: TObject);
    Procedure ConfigurarFontedeVdeo1Click(Sender: TObject);
    Procedure ConfigurarCordoFundo1Click(Sender: TObject);
    Procedure ModoTexto1Click(Sender: TObject);
    Procedure CopiarTextoSelecionado1Click(Sender: TObject);
    Procedure Prxima1Click(Sender: TObject);
    Procedure Anterior1Click(Sender: TObject);
    Procedure Prxima2Click(Sender: TObject);
    Procedure Anterior2Click(Sender: TObject);
    Procedure AbrirRemoto1Click(Sender: TObject);
    Procedure Help1Click(Sender: TObject);
    Procedure ExtrairSpeedButtonClick(Sender: TObject);
    Procedure FormActivate(Sender: TObject);
    Procedure mScreenWidthClick(Sender: TObject);
    Procedure Timer1Timer(Sender: TObject);
    procedure EditPagChange(Sender: TObject);
    procedure EditPesChange(Sender: TObject);
    procedure Especial1Click(Sender: TObject);
    procedure Localizar1Click(Sender: TObject);
    procedure LocalizarPrxima1Click(Sender: TObject);
    procedure AnotarGraphSpeedButtonClick(Sender: TObject);
    procedure AnotarTextoSpeedButtonClick(Sender: TObject);
    procedure Animate1Click(Sender: TObject);
    procedure Animate2Click(Sender: TObject);
    procedure ConsultarStatusProcessamento1Click(Sender: TObject);
    procedure DownloadManager1Click(Sender: TObject);
  Private
    { Private declarations }
//    Procedure IdleEventHandler(Sender: TObject; Var Done: Boolean);

    JaAbriu :Boolean;

  Public
    { Public declarations }
    function ObterUrlBase: String;
    Function VerificaSeguranca(NomeRel : AnsiString) : Boolean;
    Procedure AbreRel(NomeRel : AnsiString; EhRemoto : Boolean);
    Procedure Scrolla1;
    Procedure Scrolla2;
    Function CarregaDadosDfnIncExc : Boolean;
    Function LocalizaCodRel(CodRel : AnsiString) : Integer; // Retorna o ponteiro, se = -1, não achou...
    Procedure Inicializa;
    Procedure MostraAsImagens;
    Procedure MoveDFActiveParaImage1;
    procedure CarregaQueryFacil(query: TDataSet);
  End;

Var
  FrameForm: TFrameForm;
  TemRegGrp : Boolean;

Implementation

Uses Subrug, Scampo, MdiEdit, SuGeral, Gridque,
  Avisoi, Imprim, Descom, Template, Sobre, AssisAbre, Printers, LogInForm,
  MExtract, AssisAbreRemoto, EspecialU, ExeEspecialU, LocalizarU, StatusU, AnotaTextoU,
  GraphWin, SuTypMultiCold, zLib, UFrmConsultaExportacoesRemoto,
  UFrmDownloadManager;

{$R *.DFM}

Var
  Ultima : TDateTime;
//  Arq : System.Text;
//  AssignFile(Arq,'Timer.txt');
//  Try
//    Append(Arq);
//  Except
//    ReWrite(Arq);
//  End;
//  WriteLn(Arq, Cont,' ', DateTimeToStr(Agora), ' ', Teste:10:4);
//  CloseFile(Arq);
//  Inc(Cont);

(*Procedure TFrameForm.IdleEventHandler(Sender: TObject;
  Var Done: Boolean);
Var
  Agora : TDateTime;
  Teste : TTime;
Begin
{
Quando o relatório está aberto com uma pesquisa realizada, o idle é chamado initerruptamente. Para evitar esta situação,
e preservar a funcionalidade desta rotina, só os intervalos de mais de 1 segundo vão fazer o refresh no timer.
}
Agora := Now;
Teste := (Agora-Ultima)*100000;
If Teste > 1 Then
  Begin
  Timer10.Enabled := False; // Refresh Timer
  Timer10.Enabled := True;
  End;
Ultima := Agora;
Done := True;
End;*)

procedure TFrameForm.CarregaQueryFacil(query: TDataSet);
//var i,j,k,l : integer;
begin
(*
i := query.RecordCount;
if iMaxRegQueryFacil > 0 then
  if i > iMaxRegQueryFacil then
    begin
    i := iMaxRegQueryFacil;
    messageDlg('Sua pesquisa retornou muitas ocorrências. Serão exibidas apenas as '+intToStr(iMaxRegQueryFacil)+' primeiras.',mtInformation,[mbOk],0);
    end;
setLength(TEditForm(ActiveMdiChild).gridQueryFacil, i);
l := query.FieldCount;
for j := 0 to i-1 do
  begin
  setLength(TEditForm(ActiveMdiChild).gridQueryFacil[j],l);
  for k := 0 to l-1 do
    TEditForm(ActiveMdiChild).gridQueryFacil[j,k] := query.Fields[k].Value;
  query.Next;
  end;
*)
end;

Procedure TFrameForm.Inicializa;
Begin
viDirTrabApl := ExtractFilePath(ParamStr(0));
pDest := Pos('DESTINO',UpperCase(viDirTrabApl));
If pDest <> 0 Then
  Begin
  viDirTrabApl := Copy(viDirTrabApl,1,pDest-1)+'Origem\';
  End;
End;

Function TFrameForm.CarregaDadosDfnIncExc : Boolean;
Var
  I : Integer;
  strlst : TStringlist;
Begin
Result := True;

If Length(ArDFN) <> 0 Then // Já carregou uma vez, então não repete a carga......
  Exit;

Avisop.Label1.Caption := 'Carregando dados...';
Avisop.Show;
Application.ProcessMessages;

{
if not FormGeral.DatabaseMultiCold.Connected then // Se não conectou tenta mais uma vez
  try
    FormGeral.DatabaseMultiCold.ConnectionTimeout := 15;
    FormGeral.DatabaseMultiCold.Open;
  except
    begin
    FormGeral.DatabaseMultiCold.Close;
    messageDlg('Erro conectando ao banco de dados. Somente a abertura de relatórios sem segurança será permitida.',mtError,[mbOk],0);
    Avisop.Close;
    exit;
    end;
  end;
}

  strlst := TStringlist.Create;
  strlst.Add(' SELECT * FROM DFN A');
  strlst.Add('ORDER BY A.CODREL   ');
  FormGeral.ImportarDados(strlst.Text, nil);

{
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM DFN A');
FormGeral.QueryLocal1.Sql.Add('ORDER BY A.CODREL ');
Try
  FormGeral.QueryLocal1.Open;
Except
  FormGeral.MostraMensagem('Erro ao tentar carregar dados de DFN');
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try
}
  While Not FormGeral.memtb.Eof Do
    FormGeral.memtb.Next;   // Estabelecer o recordcount correto

  SetLength(ArDFN, FormGeral.memtb.RecordCount);

  FormGeral.memtb.First;
  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArDFN[I].CodRel := FormGeral.memtb.FieldByName('CodRel').AsString;
    ArDFN[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArDFN[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;
    ArDFN[I].CodSubGrupo := FormGeral.memtb.FieldByName('CodSubGrupo').AsInteger;
    ArDFN[I].GrupoAuto := (FormGeral.memtb.FieldByName('CodGrupAuto').AsString = 'T') Or
                          (FormGeral.memtb.FieldByName('SubDirAuto').AsString = 'T');
    ArDFN[i].SisAuto := (FormGeral.memtb.FieldByName('SISAUTO').AsString = 'T');
    Inc(I);
    FormGeral.memtb.Next;
  End;

{
While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArDFN, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArDFN[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  ArDFN[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArDFN[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArDFN[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArDFN[I].GrupoAuto := (FormGeral.QueryLocal1.FieldByName('CodGrupAuto').AsString = 'T') Or
                        (FormGeral.QueryLocal1.FieldByName('SubDirAuto').AsString = 'T');
  ArDFN[i].SisAuto := (FormGeral.QueryLocal1.FieldByName('SISAUTO').AsString = 'T');
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;
}

  Try
    strlst.Clear;
    FormGeral.memtb.Close;
    strlst.Add('SELECT * FROM USUREL A');
    strlst.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND ');
    strlst.Add('      (A.TIPO = ''INC'') ');
    FormGeral.ImportarDados(strlst.Text, nil);
    FormGeral.memtb.Open;
  Except
    FormGeral.MostraMensagem('Erro ao tentar carregar dados de USUREL INC');
    Result := False;
    Avisop.Close;
    Exit;
  End; // Try

  While Not FormGeral.memtb.Eof Do
    FormGeral.memtb.Next;   // Estabelecer o recordcount correto

  SetLength(ArINC, FormGeral.memtb.RecordCount);

  FormGeral.memtb.First;
  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArINC[I].CodUsu := FormGeral.memtb.FieldByName('CodUsuario').AsString;
    ArINC[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArINC[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;
    ArINC[I].CodSubGrupo := FormGeral.memtb.FieldByName('CodSubGrupo').AsInteger;
    ArINC[I].CodRel := FormGeral.memtb.FieldByName('CodRel').AsString;
    Inc(I);
    FormGeral.memtb.Next;
  End;

{
Try
  FormGeral.QueryLocal1.Close;
  FormGeral.QueryLocal1.Sql.Clear;
  FormGeral.QueryLocal1.Sql.Add('SELECT * FROM USUREL A');
  FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND ');
  FormGeral.QueryLocal1.Sql.Add('      (A.TIPO = ''INC'') ');
  FormGeral.QueryLocal1.Open;
Except
  FormGeral.MostraMensagem('Erro ao tentar carregar dados de USUREL INC');
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArINC, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArINC[I].CodUsu := FormGeral.QueryLocal1.FieldByName('CodUsuario').AsString;
  ArINC[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArINC[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArINC[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArINC[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;
}

  strlst.Clear;
  FormGeral.memtb.Close;
  strlst.Add('SELECT * FROM USUREL A');
  strlst.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND ');
  strlst.Add('      (A.TIPO = ''EXC'') ');
  FormGeral.ImportarDados(strlst.Text, nil);
  Try
    FormGeral.memtb.Open;
  Except
    FormGeral.MostraMensagem('Erro ao tentar carregar dados de USUREL EXC');
    Result := False;
    Avisop.Close;
    Exit;
  End; // Try

  While Not FormGeral.memtb.Eof Do
    FormGeral.memtb.Next;   // Estabelecer o recordcount correto

  SetLength(ArEXC, FormGeral.memtb.RecordCount);

  FormGeral.memtb.First;
  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArEXC[I].CodUsu := FormGeral.memtb.FieldByName('CodUsuario').AsString;
    ArEXC[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArEXC[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;
    ArEXC[I].CodSubGrupo := FormGeral.memtb.FieldByName('CodSubGrupo').AsInteger;
    ArEXC[I].CodRel := FormGeral.memtb.FieldByName('CodRel').AsString;
    Inc(I);
    FormGeral.memtb.Next;
  End;

{
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM USUREL A');
FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND ');
FormGeral.QueryLocal1.Sql.Add('      (A.TIPO = ''EXC'') ');
Try
  FormGeral.QueryLocal1.Open;
Except
  FormGeral.MostraMensagem('Erro ao tentar carregar dados de USUREL EXC');
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArEXC, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArEXC[I].CodUsu := FormGeral.QueryLocal1.FieldByName('CodUsuario').AsString;
  ArEXC[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArEXC[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArEXC[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArEXC[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;
}

  strlst.Clear;
  strlst.Add('SELECT * FROM SISTEMA ');
  FormGeral.ImportarDados(strlst.Text, nil);
  Try
    FormGeral.memtb.Open;
  Except
    FormGeral.MostraMensagem('Erro ao tentar carregar dados de SISTEMA');
    Result := False;
    Avisop.Close;
    Exit;
  End; // Try

  While Not FormGeral.memtb.Eof Do
    FormGeral.memtb.Next;   // Estabelecer o recordcount correto

  SetLength(ArSis, FormGeral.memtb.RecordCount);

  FormGeral.memtb.First;
  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArSis[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArSis[I].NomeSis := FormGeral.memtb.FieldByName('NomeSis').AsString;
    Inc(I);
    FormGeral.memtb.Next;
  End;

{
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM SISTEMA ');
Try
  FormGeral.QueryLocal1.Open;
Except
  FormGeral.MostraMensagem('Erro ao tentar carregar dados de SISTEMA');
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArSis, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArSis[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArSis[I].NomeSis := FormGeral.QueryLocal1.FieldByName('NomeSis').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;
}

  strlst.Clear;
  strlst.Add('SELECT * FROM COMPILA ');
  FormGeral.ImportarDados(strlst.Text, nil);
  Try
    FormGeral.memtb.Open;
  Except
    On e: Exception Do Begin
      FormGeral.MostraMensagem(e.Message + #13#10 + 'Erro ao tentar carregar dados de COMPILA');
      Result := False;
      Avisop.Close;
      Exit;
    End;
  End;// Try

  While Not FormGeral.memtb.Eof Do
    FormGeral.memtb.Next;   // Estabelecer o recordcount correto

  SetLength(ArCompila, FormGeral.memtb.RecordCount);

  FormGeral.memtb.First;
  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArCompila[I].CodRel := FormGeral.memtb.FieldByName('CodRel').AsString;
    ArCompila[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArCompila[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;
    ArCompila[I].CodSubGrupo := FormGeral.memtb.FieldByName('CodSubGrupo').AsInteger;
    Inc(I);
    FormGeral.memtb.Next;
  End;
  FormGeral.memtb.Close;

{
FormGeral.SelectCompilaQuery.Close;
FormGeral.SelectCompilaQuery.Sql.Clear;
FormGeral.SelectCompilaQuery.Sql.Add('SELECT * FROM COMPILA ');
Try
//  FormGeral.DatabaseEventos.BeginTrans;
  FormGeral.SelectCompilaQuery.Open;
//  FormGeral.DatabaseEventos.CommitTrans;
Except
  On e: Exception Do Begin
  FormGeral.MostraMensagem(e.Message + #13#10 + 'Erro ao tentar carregar dados de COMPILA');
  Result := False;
  Avisop.Close;
  Exit;
  End; End;// Try

While Not FormGeral.SelectCompilaQuery.Eof Do
  FormGeral.SelectCompilaQuery.Next;   // Estabelecer o recordcount correto

SetLength(ArCompila, FormGeral.SelectCompilaQuery.RecordCount);

FormGeral.SelectCompilaQuery.Close;
FormGeral.SelectCompilaQuery.Open;
I := 0;
While Not FormGeral.SelectCompilaQuery.Eof Do
  Begin
  ArCompila[I].CodRel := FormGeral.SelectCompilaQuery.FieldByName('CodRel').AsString;
  ArCompila[I].CodSis := FormGeral.SelectCompilaQuery.FieldByName('CodSis').AsInteger;
  ArCompila[I].CodGrupo := FormGeral.SelectCompilaQuery.FieldByName('CodGrupo').AsInteger;
  ArCompila[I].CodSubGrupo := FormGeral.SelectCompilaQuery.FieldByName('CodSubGrupo').AsInteger;
  Inc(I);
  FormGeral.SelectCompilaQuery.Next;
  End;
FormGeral.SelectCompilaQuery.Close;
}
  strlst.Clear;
  FormGeral.memtb.Close;
  strlst.Add('SELECT * FROM GRUPOSDFN ');
  FormGeral.ImportarDados(strlst.Text, nil);
  Try
    FormGeral.memtb.Open;
  Except
    FormGeral.MostraMensagem('Erro ao tentar carregar dados de '+viGrupo);
    Result := False;
    Avisop.Close;
    Exit;
  End; // Try

  While Not FormGeral.memtb.Eof Do
    FormGeral.memtb.Next;   // Estabelecer o recordcount correto

  SetLength(ArGrupo, FormGeral.memtb.RecordCount);

  FormGeral.memtb.First;
  I := 0;
  While Not FormGeral.QueryLocal1.Eof Do
  Begin
    ArGrupo[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArGrupo[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;
    ArGrupo[I].NomeGrupo := FormGeral.memtb.FieldByName('NomeGrupo').AsString;
    Inc(I);
    FormGeral.QueryLocal1.Next;
  End;
{
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM GRUPOSDFN ');
Try
  FormGeral.QueryLocal1.Open;
Except
  FormGeral.MostraMensagem('Erro ao tentar carregar dados de '+viGrupo);
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArGrupo, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArGrupo[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArGrupo[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArGrupo[I].NomeGrupo := FormGeral.QueryLocal1.FieldByName('NomeGrupo').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;
}
  strlst.Clear;
  strlst.Add('SELECT * FROM SUBGRUPOSDFN A');
  FormGeral.ImportarDados(strlst.Text, nil);
  Try
    FormGeral.memtb.Open;
  Except
    FormGeral.MostraMensagem('Erro ao tentar carregar dados de '+viSubGrupo);
    Result := False;
    Avisop.Close;
    Exit;
  End; // Try

  While Not FormGeral.memtb.Eof Do
    FormGeral.memtb.Next;   // Estabelecer o recordcount correto

  SetLength(ArSubGrupo, FormGeral.memtb.RecordCount);

  FormGeral.memtb.First;
  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArSubGrupo[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArSubGrupo[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;
    ArSubGrupo[I].CodSubGrupo := FormGeral.memtb.FieldByName('CodSubGrupo').AsInteger;
    ArSubGrupo[I].NomeSubGrupo := FormGeral.memtb.FieldByName('NomeSubGrupo').AsString;
    Inc(I);
    FormGeral.memtb.Next;
  End;
{
FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
Try
  FormGeral.QueryLocal1.Open;
Except
  FormGeral.MostraMensagem('Erro ao tentar carregar dados de '+viSubGrupo);
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArSubGrupo, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArSubGrupo[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArSubGrupo[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArSubGrupo[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArSubGrupo[I].NomeSubGrupo := FormGeral.QueryLocal1.FieldByName('NomeSubGrupo').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;
}
  strlst.Clear;
  strlst.Add('SELECT * FROM SISAUXDFN ');
  strlst.Add('ORDER BY CODSIS, CODGRUPO, CODREL ');
  FormGeral.ImportarDados(strlst.Text, nil);
  FormGeral.memtb.Open;              // RecordCount só é setado após a varrida integral da tabela;
  Formgeral.Memtb.FetchAll;
  SetLength(ArrSisAux, FormGeral.memtb.RecordCount);

  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArrSisAux[I].CodRel := FormGeral.memtb.FieldByName('CodRel').AsString;
    ArrSisAux[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArrSisAux[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;
    ArrSisAux[I].LinI := FormGeral.memtb.FieldByName('LinI').AsInteger;
    ArrSisAux[I].LinF := FormGeral.memtb.FieldByName('LinF').AsInteger;
    ArrSisAux[I].Col := FormGeral.memtb.FieldByName('Col').AsInteger;
    ArrSisAux[I].Tipo := FormGeral.memtb.FieldByName('Tipo').AsString;
    ArrSisAux[I].CodAux := FormGeral.memtb.FieldByName('CodAux').AsString;

    FormGeral.memtb.Next;
    Inc(I);
  End;

  strlst.Clear;
  strlst.Add('SELECT DISTINCT CODREL, CODSIS, CODGRUPO FROM SISAUXDFN ');
  strlst.Add('ORDER BY CODSIS, CODGRUPO, CODREL ');
  FormGeral.ImportarDados(strlst.Text, nil);
  FormGeral.memtb.Open;              // RecordCount só é setado após a varrida integral da tabela;
  Formgeral.Memtb.FetchAll;
  SetLength(ArrSisAux2, FormGeral.memtb.RecordCount);
  I := 0;
  While Not FormGeral.memtb.Eof Do
  Begin
    ArrSisAux2[I].CodRel := FormGeral.memtb.FieldByName('CodRel').AsString;
    ArrSisAux2[I].CodSis := FormGeral.memtb.FieldByName('CodSis').AsInteger;
    ArrSisAux2[I].CodGrupo := FormGeral.memtb.FieldByName('CodGrupo').AsInteger;

    FormGeral.memtb.Next;
    Inc(I);
  End;
  FormGeral.memtb.Close;
{
FormGeral.QueryLocal1.Close;

FormGeral.QueryLocal1.CursorLocation := clUseClient; // Retorna o número correto de registros para recordCount
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM SISAUXDFN ');
FormGeral.QueryLocal1.Sql.Add('ORDER BY CODSIS, CODGRUPO, CODREL ');

FormGeral.QueryLocal1.Open;              // RecordCount só é setado após a varrida integral da tabela;
SetLength(ArrSisAux, FormGeral.QueryLocal1.RecordCount);

I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArrSisAux[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  ArrSisAux[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArrSisAux[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArrSisAux[I].LinI := FormGeral.QueryLocal1.FieldByName('LinI').AsInteger;
  ArrSisAux[I].LinF := FormGeral.QueryLocal1.FieldByName('LinF').AsInteger;
  ArrSisAux[I].Col := FormGeral.QueryLocal1.FieldByName('Col').AsInteger;
  ArrSisAux[I].Tipo := FormGeral.QueryLocal1.FieldByName('Tipo').AsString;
  ArrSisAux[I].CodAux := FormGeral.QueryLocal1.FieldByName('CodAux').AsString;

  FormGeral.QueryLocal1.Next;
  Inc(I);
  End;
FormGeral.QueryLocal1.Close;

FormGeral.QueryLocal1.CursorLocation := clUseClient; // Retorna o número correto de registros para recordCount
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT DISTINCT CODREL, CODSIS, CODGRUPO FROM SISAUXDFN ');
FormGeral.QueryLocal1.Sql.Add('ORDER BY CODSIS, CODGRUPO, CODREL ');

FormGeral.QueryLocal1.Open;              // RecordCount só é setado após a varrida integral da tabela;
SetLength(ArrSisAux2, FormGeral.QueryLocal1.RecordCount);
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArrSisAux2[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  ArrSisAux2[I].CodSis := FormGeral.QueryLocal1.FieldByName('CodSis').AsInteger;
  ArrSisAux2[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;

  FormGeral.QueryLocal1.Next;
  Inc(I);
  End;
FormGeral.QueryLocal1.Close;
}

Avisop.Close;

End;

Function TFrameForm.LocalizaCodRel(CodRel : AnsiString) : Integer;
Var
  I : Integer;
Begin
Result := -1;

For I := 0 To Length(ArDFN)-1 Do
  If ArDFN[I].CodRel = CodRel Then
    Begin
    Result := I;
    Break;
    End;
End;

Function TFrameForm.VerificaSeguranca;
Var
//  Teste : Boolean;
//  ArqCodGrupo : File Of Integer;
  PassouGrupoSubGrupoRel : Boolean;
  I, J, K,
  CodSisDFNAtu,    // Está na DFN da base
  CodSisDFNOld,    // Está na DFN do relatório
  CodGrupoDFNAtu,  // Está na DFN da base
  CodGrupoDFNOld,  // Está na DFN do relatório
  CodGrupoDFNGrp,  // Está no arquivo GRP
  CodSubGrupoDFNAtu,  // Está na DFN da base
  CodSubGrupoDFNOld : Integer; // Está na DFN do relatório
  CodRel,
  CodGrupo : AnsiString;
  OldFileMode : Integer;
  strSql : TStringList;
Begin
Result := True;

If FileExists(ChangeFileExt(NomeRel,'.IAPX')) Then // Novo formato, candidato a segurança
  Begin
  Memo1.Clear;
//  for K := 1 To FileListBox1.Items.Count Do
//    Begin

  AssignFile(ArqCNFG,ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dfn.Dfn');
//  AssignFile(ArqCNFG,'C:\Rom\MultiCold\Destino\VISIONPLUS\BRADESCO\TELE-SAQUE\0REL\'+FileListBox1.Items[K-1]);
  OldFileMode := FileMode;
  FileMode := 0;
  Reset(ArqCNFG);
  FileMode := OldFileMode;
  Read(ArqCNFG,RegDestinoII); // Lê o primeiro Destino, mas não checa a segurança por ele
  I := 0;
  FillChar(ArrRegIndice,SizeOf(ArrRegIndice),0);
  TemRegGrp := False;
  RegSistema.CODSIS := -999; // Inicializar para marcar ...
  CodSeg.CODSEG := -1; // Inicializar para marcar ...
  While Not Eof(ArqCNFG) Do
    Begin
    Read(ArqCNFG,RegDestinoII);
    Case RegDestinoII.TipoReg Of
      0 : Begin
          RegGrp := RegDestinoII;
          TemRegGrp := True;
          End;
      1 : RegDFN := RegDestinoII;
      2 : Begin
          ArrRegIndice[I] := RegDestinoII;
          Inc(I);
          End;
      3 : RegDestino := RegDestinoII;
      4 : RegSistema := RegDestinoII;
      5 : CodSeg := RegDestinoII;
      6 : RegSisAuto := RegDestinoII;
      End; // Case
    End;

  If Not TemRegGrp Then  // Força que reggrp tenha sempre algum conteúdo
    begin
//    Memo1.Lines.Add(FileListBox1.Items[K-1]+' - Não tem RegGrp - '+IntToStr(RegDFN.CodGrupo));
    RegGrp.Grp := RegDFN.CodGrupo;
    end
  else
    begin
//    ShowMessage(IntToStr(RegGrp.Grp));
    end;

  CloseFile(ArqCNFG);  // End;
  If RegDestino.SEGURANCA Then
    Begin
    strsql := TStringList.Create;
    //FormGeral.QueryLocal1.Close;
    strsql.Clear;
    strsql.Add('SELECT * FROM USUARIOS A,');
    strsql.Add('              USUARIOSEGRUPOS B');
    strsql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') ');
    strsql.Add('AND (A.CODUSUARIO = B.CODUSUARIO) ');
    Try
      FormGeral.ImportarDados(strsql.Text,nil);
    Except
      FormGeral.MostraMensagem('Base de segurança não encontrada. Impossível autenticar usuário');
      Result := False;
      Exit;
      End; //Try
    if formGeral.Memtb.RecordCount = 0 then
    begin
      FormGeral.MostraMensagem('Base de segurança não encontrada. Impossível autenticar usuário');
      Result := False;
      Exit;
    end;
    CodRel := UpperCase(RegDFN.CodRel); // Código do relatório em questão
    CodGrupo := FormGeral.Memtb.FieldByName('NomeGrupoUsuario').AsString;

    If CodGrupo = 'ADMSIS' Then
      Begin
      FormGeral.Memtb.Close;   // Usuario admsis pode ver tudo
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
      Exit;
      End;

    FormGeral.memtb.Close;

    If Not CarregaDadosDfnIncExc Then
      Begin
      FormGeral.MostraMensagem('Base de segurança não encontrada. Impossível autenticar usuário');
      Result := False;
      Exit;
      End;

    I := LocalizaCodRel(CodRel);

    If I = -1 Then
      Begin
      FormGeral.MostraMensagem('Erro seek CodRel, abortando ...');
      Result := False;
//      FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), CodRel, UpperCase(GetCurrentUserName), 02, '');
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 02);
      Exit;
      End;

  strsql.Clear;
  //FormGeral.QueryLocal1.Close;
  //FormGeral.QueryLocal1.Sql.Clear;

  SetLength(ArrBloqCampos,0);

  strsql.Add('SELECT *');
  strsql.Add('FROM USUARIOMASCARA A INNER JOIN');
  strsql.Add('     MASCARACAMPO B ON A.CODREL = B.CODREL AND A.NOMECAMPO = B.NOMECAMPO');
  strsql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND');
  strsql.Add('(A.CODREL = '''+RegDFN.CODREL+''')');
  Try
    //FormGeral.QueryLocal1.Open;
    FormGeral.ImportarDados(strsql.Text,nil);
    SetLength(ArrBloqCampos, FormGeral.memtb.RecordCount);
    For J := 0 To FormGeral.memtb.RecordCount-1 Do
      Begin
      ArrBloqCampos[J].CODREL := FormGeral.memtb.Fields[0].AsString;
      ArrBloqCampos[J].NOMECAMPO := FormGeral.memtb.Fields[1].AsString;
      ArrBloqCampos[J].CODUSUARIO := FormGeral.memtb.Fields[2].AsString;
      ArrBloqCampos[J].CODREL_ := FormGeral.memtb.Fields[3].AsString;
      ArrBloqCampos[J].NOMECAMPO_ := FormGeral.memtb.Fields[4].AsString;
      ArrBloqCampos[J].LINHAI := FormGeral.memtb.Fields[5].AsInteger;
      ArrBloqCampos[J].LINHAF := FormGeral.memtb.Fields[6].AsInteger;
      ArrBloqCampos[J].COLUNA := FormGeral.memtb.Fields[7].AsInteger;
      ArrBloqCampos[J].TAMANHO := FormGeral.memtb.Fields[8].AsInteger;
      FormGeral.memtb.Next;
      End;
    FormGeral.memtb.Close;

    //*************************
    //showMessage(ArrBloqCampos[0].NOMECAMPO);
    //*************************


  Except
    if RegDestino.SEGURANCA then
      begin
      ShowMessage('Erro no levantamento das restrições de campos...');
      Exit;
      end;
    Result := False;
    End; //Try

    CodSisDFNAtu := ArDFN[I].CodSis;    // Banco
    CodSisDFNOld := RegSistema.CODSIS;  // Rel (Pode ser -999 se é a versão interbase do relatório... Se for -1 pega o sis real que está em RegSisAuto
    If CodSisDFNOld = -1 Then
      CodSisDFNOld := RegSisAuto.CODSISREAL;
    CodGrupoDFNAtu := ArDFN[I].CodGrupo;
    CodSubGrupoDFNAtu := ArDFN[I].CodSubGrupo;
    CodGrupoDFNOld := RegDFN.CODGRUPO;
    CodSubGrupoDFNOld := RegDFN.CODSUBGRUPO;
    If RegDFN.CODGRUPAUTO Or (TemRegGrp And RegDFN.SUBDIRAUTO) Then
      CodGrupoDFNGrp := RegGRP.Grp
    Else
      CodGrupoDFNGrp := RegDFN.CODGRUPO;

    If Length(ArINC) = 0 Then // Nenhuma definição de Inclusão para este usuário
        Result := False;

    PassouGrupoSubGrupoRel := False;

    For I := 0 To Length(ArINC) - 1 Do
      Begin
      If (ArINC[I].CodSis = -999) Or
         (ArINC[I].CodSis = CodSisDFNAtu) Or
         (ArINC[I].CodSis = CodSisDFNOld) Or
         (RegSistema.CODSIS = -999) Then  // Versão Interbase...
      If (ArINC[I].CodGrupo = -999) Or
         (ArINC[I].CodGrupo = CodGrupoDFNAtu) Or
         (ArINC[I].CodGrupo = CodGrupoDFNOld) Or
         (ArINC[I].CodGrupo = CodGrupoDFNGrp) Then
      If (ArINC[I].CodSubGrupo = -999) Or
         (ArINC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
         (ArINC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
      If (ArINC[I].CodRel = '*') Or
         (ArINC[I].CodRel = CodRel) Then
        Begin
        PassouGrupoSubGrupoRel := True;
        Break;
        End;
      End;

    For I := 0 To Length(ArEXC) - 1 Do
      Begin
      If (ArEXC[I].CodSis = -999) Or
         (ArEXC[I].CodSis = CodSisDFNAtu) Or
         (ArEXC[I].CodSis = CodSisDFNOld) Or
         (RegSistema.CODSIS = -999) Then // Versão Interbase...
      If (ArEXC[I].CodGrupo = -999) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNAtu) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNOld) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNGrp) Then
      If (ArEXC[I].CodSubGrupo = -999) Or
         (ArEXC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
         (ArEXC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
      If (ArEXC[I].CodRel = '*') Or
         (ArEXC[I].CodRel = CodRel) Then
        Begin
        Result := False;
        Break;
        End;
      End;

    If Result And PassouGrupoSubGrupoRel Then
      Begin
      // Muito Bem, Passou por todos os testes..............
//      FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), CodRel, UpperCase(GetCurrentUserName), 01, '');
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
      End
    Else
      Begin
      Result := False;
//      FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), CodRel, UpperCase(GetCurrentUserName), 03, '');
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
      End;
    End;
  End;
{Else
If FileExists(ChangeFileExt(NomeRel,'.IAPS')) Then // formato antigo candidato a segurança
  Begin
  If Not AdcPassWord Then
    Begin
    AdcPassWord := True;
    Session.AddPassword(Senha);
    End;
  FormGeral.DbTableDst.Close;
  FormGeral.DbTableDst.DatabaseName := '';
  FormGeral.DbTableDst.TableName := ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dst.db';
  FormGeral.DbTableDst.Open;
  If UpperCase(FormGeral.DbTableDst.FieldByName('Seguranca').AsString) = 'S' Then
    Begin

    FormGeral.QueryLocal1.Close;
    FormGeral.QueryLocal1.Sql.Clear;
    FormGeral.QueryLocal1.Sql.Add('SELECT * FROM USUARIOS A,');
    FormGeral.QueryLocal1.Sql.Add('              USUARIOSEGRUPOS B');
    FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') ');
    FormGeral.QueryLocal1.Sql.Add('AND (A.CODUSUARIO = B.CODUSUARIO) ');
    Try
      FormGeral.QueryLocal1.Open;
    Except
      FormGeral.MostraMensagem('Base de segurança não encontrada. Impossível autenticar usuário');
      Result := False;
      Exit;
      End; //Try

    CodRel := UpperCase(FormGeral.DbTableDst.FieldByName('CodRel').AsString); // Código do relatório em questão
    CodGrupo := FormGeral.QueryLocal1.FieldByName('NomeGrupoUsuario').AsString;

    If CodGrupo = 'ADMSIS' Then
      Begin
      FormGeral.QueryLocal1.Close;   // Usuario admsis pode ver tudo
//      FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), CodRel, UpperCase(GetCurrentUserName), 01, '');
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
      Exit;
      End;

    FormGeral.QueryLocal1.Close;

    If Not CarregaDadosDfnIncExc Then
      Begin
      FormGeral.MostraMensagem('Base de segurança não encontrada. Impossível autenticar usuário');
      Result := False;
      FormGeral.DbTableDst.Close;
      Exit;
      End;

    I := LocalizaCodRel(CodRel);

    If I = -1 Then
      Begin
      FormGeral.MostraMensagem('Erro seek CodRel, abortando ...');
      Result := False;
      FormGeral.DbTableDst.Close;
//      FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), CodRel, UpperCase(GetCurrentUserName), 02, '');
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 02);
      Exit;
      End;

    CodGrupoDFNAtu := ArDFN[I].CodGrupo;
    CodSubGrupoDFNAtu := ArDFN[I].CodSubGrupo;
    CodGrupoDFNOld := CodGrupoDFNAtu;
    CodSubGrupoDFNOld := CodSubGrupoDFNAtu;
    CodGrupoDFNGrp := CodGrupoDFNAtu;

    Try
      FormGeral.DbTableDfn.Close;
      FormGeral.DbTableDfn.DatabaseName := '';
      FormGeral.DbTableDfn.TableName := ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dfn.db';
      FormGeral.DbTableDfn.Open;
      CodGrupoDFNOld := FormGeral.DbTableDfn.FieldByName('CodGrupo').AsInteger;
      CodSubGrupoDFNOld := FormGeral.DbTableDfn.FieldByName('CodSubGrupo').AsInteger;
      Try
        Teste := FormGeral.DbTableDfn.FieldByName('CodGrupAuto').AsBoolean;
      Except
        Teste := False;  // Versão antiga não tem esta informação na dfn
        End; // Try
      If Teste Then
        Begin
        AssignFile(ArqCodGrupo,ChangeFileExt(NomeRel,'.Grp'));
        Reset(ArqCodGrupo);
        Read(ArqCodGrupo,CodGrupoDFNGrp);
        CloseFile(ArqCodGrupo);
        End;
      FormGeral.DbTableDfn.Close;
    Except
      FormGeral.DbTableDfn.Close;
      End; // Try

    If Length(ArINC) = 0 Then // Nenhuma definição de Inclusão para este usuário
        Result := False;

    PassouGrupoSubGrupoRel := False;

    For I := 0 To Length(ArINC) - 1 Do
      Begin
      If (ArINC[I].CodGrupo = -999) Or
         (ArINC[I].CodGrupo = CodGrupoDFNAtu) Or
         (ArINC[I].CodGrupo = CodGrupoDFNOld) Or
         (ArINC[I].CodGrupo = CodGrupoDFNGrp) Then
      If (ArINC[I].CodSubGrupo = -999) Or
         (ArINC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
         (ArINC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
      If (ArINC[I].CodRel = '*') Or
         (ArINC[I].CodRel = CodRel) Then
        Begin
        PassouGrupoSubGrupoRel := True;
        Break;
        End;
      End;

    For I := 0 To Length(ArEXC) - 1 Do
      Begin
      If (ArEXC[I].CodGrupo = -999) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNAtu) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNOld) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNGrp) Then
      If (ArEXC[I].CodSubGrupo = -999) Or
         (ArEXC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
         (ArEXC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
      If (ArEXC[I].CodRel = '*') Or
         (ArEXC[I].CodRel = CodRel) Then
        Begin
        Result := False;
        Break;
        End;
      End;

    If Result And PassouGrupoSubGrupoRel Then
      Begin
      // Muito Bem, Passou por todos os testes..............
//      FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), CodRel, UpperCase(GetCurrentUserName), 01, '');
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
      End
    Else
      Begin
      Result := False;
//      FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), CodRel, UpperCase(GetCurrentUserName), 03, '');
      FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                  UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 03);
      End;
    End
  Else
//    FormGeral.InsereEventos(ExtractFileName(NomeRel)+', '+ExtractFilePath(NomeRel), '', UpperCase(GetCurrentUserName), 04, '');
    FormGeral.InsereEventosVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                                UpperCase(GetCurrentUserName), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 04);
  FormGeral.DbTableDst.Close;
  End;      }
End;

Procedure TFrameForm.AbreRel(NomeRel : AnsiString; EhRemoto : Boolean);
Var
  I : Integer;
Begin
With TEditForm.Create(Application) Do
  Begin
  Caption := ExtractFileName(NomeRel);
  If Open(NomeRel, EhRemoto) Then
    Begin
    If Not EhRemoto Then
      OpenReportDialog.InitialDir := ExtractFilePath(NomeRel);
    ScrollBar1.Position := 0;
    ScrollBar1.Min := 0;
    ScrollBar1.Max := 0;
    Label1.Caption := '1 de 1';

    Scroll1Min := 0;
    Scroll1Max := 0;
    Scroll1Pos := 0;
    Lab1 := Label1.Caption;

    ScrollBar2.Position := 0;
    ScrollBar2.Min := 0;
    ScrollBar2.Max := Paginas-1;
    Label2.Caption := '1 de ' + IntToStr(Paginas);

    Scroll2Min := 0;
    Scroll2Max := Paginas-1;
    Scroll2Pos := 0;
    Lab2 := Label2.Caption;

    With SelCampo.Campos Do
      Begin
//      For I := 1 To DefChave.RowCount+1 Do
      RowCount := DefChave.RowCount;
      For I := 1 To DefChave.RowCount-1 Do
        Begin
        Cells[0,I] := IntToStr(I);
        Cells[1,I] := DefChave.Cells[6,I];
        Cells[2,I] := DefChave.Cells[7,I];
        Cells[3,I] := DefChave.Cells[3,I];
        Cells[4,I] := DefChave.Cells[4,I];
        End;
      Cells[1,0] := 'Campo';
      Cells[2,0] := 'Tipo';
      Cells[3,0] := 'Col';
      Cells[4,0] := 'Tam';
      End;

      Fechar1.Enabled := True;
      ConfigurarImpressora1.Enabled := Fechar1.Enabled;
      ConfigurarFonteDeImpresso1.Enabled := Fechar1.Enabled;
      ImprimirRelatrio1.Enabled := Fechar1.Enabled;
      DescompactarRelatrio1.Enabled := Fechar1.Enabled;
      ExportarRelatrio1.Enabled := Fechar1.Enabled;
      CopiarPgina1.Enabled := Fechar1.Enabled;
      AproximarZoom1.Enabled := Fechar1.Enabled;
      AfastarZoomOut1.Enabled := Fechar1.Enabled;
      Normal1001.Enabled := Fechar1.Enabled;
      ConfigurarFonteDeVdeo1.Enabled := Fechar1.Enabled;
      ConfigurarCorDoFundo1.Enabled := Fechar1.Enabled;
      ModoTexto1.Enabled := Fechar1.Enabled;
      CopiarTextoSelecionado1.Enabled := Fechar1.Enabled;
      MontarQueryFcil1.Enabled := Fechar1.Enabled;
      RepeteLtimaPesquisa1.Enabled := Fechar1.Enabled;
      Prxima1.Enabled := Fechar1.Enabled;
      Anterior1.Enabled := Fechar1.Enabled;
      Localizar1.Enabled := Fechar1.Enabled;
  //    LocalizarPrxima1.Enabled := Fechar1.Enabled;    Deixa o Localizar1 fazer o enable deste item de menu
      Prxima2.Enabled := Fechar1.Enabled;
      Anterior2.Enabled := Fechar1.Enabled;
      Window1.Enabled := Fechar1.Enabled;
      Tile1.Enabled := Fechar1.Enabled;
      LadoALado1.Enabled := Fechar1.Enabled;
      Cascade1.Enabled := Fechar1.Enabled;
      ArrangeIcons1.Enabled := Fechar1.Enabled;
      mScreenWidth.Enabled := Fechar1.Enabled;
      mScreenHeight.Enabled := Fechar1.Enabled;
      m200.Enabled := Fechar1.Enabled;
      m150.Enabled := Fechar1.Enabled;
      m100.Enabled := Fechar1.Enabled;
      m75.Enabled := Fechar1.Enabled;
      m50.Enabled := Fechar1.Enabled;
    End
  Else
    Close;
  End;
End;

Procedure TFrameForm.AbreRelButClick(Sender: TObject);
Var
  J : Integer;
Begin
//ShowMessage('A');
Especial.FechaEspecial;
If (Sender = AbreRelBut) And (Length(ArINC) <> 0) Then // Há relatórios associados...
  Try
    FormGeral.TableDFN.Open;
    FormGeral.TableDFN.Close;
//    If JaAbriu Then
    If Tela <> '' Then 
      AssisAbreForm.Show
    Else
      AbrirAssistido1.Click;
    Exit;
  Except
    FaiouAbrAssistidoLocal := True;
    End; // Try

If OpenReportDialog.Execute Then
  For J := OpenReportDialog.Files.Count-1 DownTo 0 Do
    If VerificaSeguranca(OpenReportDialog.Files[J]) Then
      AbreRel(OpenReportDialog.Files[J], False)
    Else
      FormGeral.MostraMensagem('Usuário '+UpperCase(GetCurrentUserName)+' não autorizado a abrir este relatório');
End;

Procedure TFrameForm.Exit1Click(Sender: TObject);
Begin
Close
End;

Procedure TFrameForm.Tile1Click(Sender: TObject);
Begin
TileMode := tbHorizontal;
Tile;
End;

Procedure TFrameForm.LadoaLado1Click(Sender: TObject);
Begin
TileMode := tbVertical;
Tile;
End;

Procedure TFrameForm.Cascade1Click(Sender: TObject);
Begin
Cascade;
End;

Procedure TFrameForm.ArrangeIcons1Click(Sender: TObject);
Begin
ArrangeIcons;
End;

Procedure TFrameForm.Help1Click(Sender: TObject);
Begin

WinExec(PAnsichar('HH '+ExtractFilePath(ParamStr(0))+'MULTICOLD.CHM'), SW_SHOW);

If MdiChildCount <> 0 Then // Se há relatórios abertos não mostra a tela de assistência
  Exit;

If Tela = 'AssisAbreLocal' Then
  AssisAbreForm.Show
Else
If Tela = 'AssisAbreRemoto' Then
  AssisAbreRemotoForm.Show;

End;

Procedure TFrameForm.FormCreate(Sender: TObject);

Var
  ArqExtra : System.Text;
Begin
Ultima := Now;
//Application.OnIdle := IdleEventHandler;

UsouLocalizar := False;
FaiouAbrAssistidoLocal := False;
//JaAbriu := False;
SetouPrivateDir := False;
ConectouRemoto := False;

MDIEdit.NomRede := -1;
BufI := Nil;
MDIEdit.Buffer := Nil;

AbriuArqQue := False;
ScrollBar1.Position := 0;
ScrollBar1.Min := 0;
ScrollBar1.Max := 0;
ScrollBar2.Position := 0;
ScrollBar2.Min := 0;
ScrollBar2.Max := 0;
Label1.Caption := '';
Label2.Caption := '';
Label3.Caption := '';
GetDir(0,Direct);
ChDir(Direct);
OpenReportDialog.InitialDir := Direct;

If FileExists(ExtractFilePath(ParamStr(0))+'COMANDO.DAT') Then
  Begin
  AssignFile(ArqExtra,ExtractFilePath(ParamStr(0))+'COMANDO.DAT');
  Reset(ArqExtra);
  ReadLn(ArqExtra,CmdExtra);
  CloseFile(ArqExtra);
  MainMenu1.Items[6].Visible := True;
  End
Else
  MainMenu1.Items[6].Visible := False;

If FileExists(ExtractFilePath(ParamStr(0))+'REMOTE.DAT') Then
  Begin
  AssignFile(ArqExtra,ExtractFilePath(ParamStr(0))+'REMOTE.DAT');
  Reset(ArqExtra);
  ReadLn(ArqExtra,RemoteServer);
  ReadLn(ArqExtra,PathServer);
  PathServer := IncludeTrailingPathDelimiter(PathServer);
  CloseFile(ArqExtra);
  End
Else
  Begin
  RemoteServer := '';
//  PathServer := viPathBaseLocal; ALIAS, verificar como vai ficar...
  End;

  {
If FileExists(ExtractFilePath(ParamStr(0))+'URLREMOTE.DAT') Then
  Begin
  AssignFile(ArqExtra,ExtractFilePath(ParamStr(0))+'URLREMOTE.DAT');
  Reset(ArqExtra);
  ReadLn(ArqExtra,UrlRemoteServer);
  ReadLn(ArqExtra,RemoteUser);
  CloseFile(ArqExtra);
  End
Else
}
  UrlRemoteServer := 'abc';

//AdcPassWord := False;
Tela := '';
End;

Procedure TFrameForm.PlusZoomClick(Sender: TObject);
Var
  I : Integer;
Begin
If MdiChildCount = 0 Then
  Exit;

With TEditForm(ActiveMdiChild) Do
  Begin
  For I := 0 To Escala1.Count-1 Do
    If Escala1.Items[I].Checked Then
      Break;
  If I > 0 Then
    mScreenWidthClick(Escala1.Items[I-1]);

  Inc(ZoomLevel);

  If ZoomLevel <> 0 Then
    Image2.Visible := False
  Else
    If FezAnotacoesGraficas Then
      Image2.Visible := True;

  FastImageReload;

  Memo1.SelStart := 0;
  Memo1.SelLength := Length(Memo1.Lines.Text)-1;
  Memo1.Font.Size := Memo1.Font.Size + 1;
  Memo1.SelStart := 0;
  Memo1.SelLength := 0;
  End;
End;

Procedure TFrameForm.LessZoomClick(Sender: TObject);
Var
  I : Integer;
Begin
If MdiChildCount = 0 Then
  Exit;

With TEditForm(ActiveMdiChild) Do
  Begin
  For I := 0 To Escala1.Count-1 Do
    If Escala1.Items[I].Checked Then
      Break;
  If I < Escala1.Count-1 Then
    mScreenWidthClick(Escala1.Items[I+1]);

  Dec(ZoomLevel);

  If ZoomLevel <> 0 Then
    Image2.Visible := False
  Else
    If FezAnotacoesGraficas Then
      Image2.Visible := True;
      
  FastImageReload;

  Memo1.SelStart := 0;
  Memo1.SelLength := Length(Memo1.Lines.Text)-1;
  Memo1.Font.Size := Memo1.Font.Size - 1;
  Memo1.SelStart := 0;
  Memo1.SelLength := 0;
  End;
End;

Procedure TFrameForm.NormalZoomClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;

With TEditForm(ActiveMdiChild) Do
  Begin
  mScreenWidthClick(m100);

{  RFMImage1.DisplayOptions:= [rfmAutoSize];
  RFMImage1.Refresh;
  ScrollBox1.HorzScrollBar.Range := RFMImage1.Width+FatorX;
  ScrollBox1.VertScrollBar.Range := RFMImage1.Height+FatorY;  }

  ZoomLevel := 0;

  If FezAnotacoesGraficas Then
    Image2.Visible := True;

  FastImageReload;

  Memo1.SelStart := 0;
  Memo1.SelLength := Length(Memo1.Lines.Text)-1;
  Memo1.Font.Size := Video.Size;
  Memo1.SelStart := 0;
  Memo1.SelLength := 0;
  End;
End;

function TFrameForm.ObterUrlBase: String;
var
  urlBase: String;
  tamRelativo, posicao: Integer;
begin
    urlBase := LogInRemotoForm.URLEdit.Text;
    urlBase := urlBase.ToLower;
    posicao := Pos('multicoldserver.exe', urlBase);
    tamRelativo := length(urlBase) - posicao + 1;
    Result := urlBase.Substring(0, length(urlBase) - tamRelativo) + 'Extracoes/';
end;

procedure leRegistroFileStreamOuQuery(var Query : TQuery; var Stream : TFileStream; var reg : TPesquisa; var EOF : boolean; campo : AnsiString);
begin
If Stream <> nil Then
  Begin
  if Stream.Position < Stream.Size then
    Stream.Read(reg,sizeOf(reg))
  else if Stream.Size = 0 then
    reg.Pagina := MAXINT;
  eof := Stream.Position = Stream.Size;
  End
Else
  Begin
  eof := Query.Eof;
  if not eof then
    begin
    reg.Campo := campo[1];
    reg.Pagina := Query.Fields[1].AsInteger;
    reg.Relativo := Query.Fields[2].AsInteger;
    reg.Linha := Query.Fields[3].AsInteger;
    Query.Next;
    end
  else
    reg.Pagina := MAXINT;
    End;
end;

{procedure leRegistroQuery(var Query : TQuery; var Stream : TFileStream; var reg : TPesquisa; var EOF : boolean; campo : AnsiString);
begin
eof := Query.Eof;
if not eof then
  begin
  reg.Campo := campo[1];
  reg.Pagina := Query.Fields[1].AsInteger;
  reg.Relativo := Query.Fields[2].AsInteger;
  reg.Linha := Query.Fields[3].AsInteger;
  Query.Next;
  end
else
  reg.Pagina := MAXINT;
end;}

Procedure TFrameForm.AbreQueryFacilClick(Sender: TObject);
var
  PI,
  Linha,
  ICampos,
  i,
  j,
  k,
  pgAux : integer;
  strXMLGrid,
  Caspa,
  ArgPesq,
  t,
  oprnd1,
  oprnd2,
  oprdr,
  auxStr : AnsiString;
  h : TFileStream;
  reg1,
  reg2 : TPesquisa;
  ehEOF1,
  ehEOF2,
  primeiraVez,
  Retorno : boolean;
  objF1,
  objF2 : TFileStream;
  strXML,
  s : wideString;
  strRetorno : String;
  RetornoLst : TStringList;

  Function RepetiuCampo(CampoAtu : Integer) : Boolean;
  Var
    I : Integer;
  Begin
  Result := False;
  For I := 1 To CampoAtu-1 Do
    Begin
    If QueryDlg.GridPesq.Cells[1,I] = QueryDlg.GridPesq.Cells[1,CampoAtu] Then
      Begin
      Result := True;
      Exit;
      End;
    End;
  End;

  function tamanhoDados(var Query : TQuery; var Stream : TFileStream): Int64;
  begin
  if Stream = nil then
    result := Query.recordCount
  else
    result := Stream.Size div sizeOf(reg1);
  end;

  procedure abrirDados(var Query : TQuery; var Stream : TFileStream; objeto : variant; var Ret : boolean);
  var
    k,l : word;
    y : TFormatSettings;
  begin
  Stream := nil;
  Ret := True;

  if pos(objeto,'ABCDEFGHIJKLMNOPQRSTUVQWXYZ') > 0 then
    begin
//    Query := TQuery.Create(FrameForm);
    for k := 1 to QueryDlg.GridPesq.RowCount - 1 do
      if QueryDlg.GridPesq.Cells[0,k] = objeto then
        begin
        try
          Query.Close;
        except
          end; // try
//        TEditForm(ActiveMdiChild).AdsConnection1.Disconnect;
//        TEditForm(ActiveMdiChild).AdsConnection1.ConnectPath := extractFilePath(TEditForm(ActiveMdiChild).FileName);
//        TEditForm(ActiveMdiChild).AdsConnection1.Connect;
        Query.DatabaseName := extractFilePath(TEditForm(ActiveMdiChild).FileName);
        Query.SQL.Clear;
//        Query.SetTableType(ttAdsCDX);
        Query.SQL.Add(' SELECT * FROM "'+changeFileExt(extractFileName(TEditForm(ActiveMdiChild).FileName),'')+
                      QueryDlg.GridPesq.Cells[1,k]+'" '+QueryDlg.GridPesq.Cells[1,k]); // Montar SELECT
        for l := 0 to high(ArrRegIndice) do
          if (ArrRegIndice[l].NOMECAMPO = QueryDlg.GridPesq.Cells[1,k]) then
            begin
//            ShowMessage(ArrRegIndice[l].NOMECAMPO);
            argPesq := QueryDlg.GridPesq.Cells[3,k];
            if (upperCase(ArrRegIndice[l].TIPOCAMPO) = 'C') or
               (upperCase(ArrRegIndice[l].TIPOCAMPO) = 'DT') then
              Caspa := ''''
            else
              Caspa := '';
            if (upperCase(queryDlg.GridPesq.Cells[2,k]) = 'IN') or
               (upperCase(queryDlg.GridPesq.Cells[2,k]) = 'NOT IN') or
               (upperCase(queryDlg.GridPesq.Cells[2,k]) = 'BETWEEN') or
               (upperCase(queryDlg.GridPesq.Cells[2,k]) = 'NOT BETWEEN') then
              Caspa := '';
            if (upperCase(ArrRegIndice[l].TIPOCAMPO) = 'DT') then
              begin
              try
                y.ShortDateFormat := 'DD/MM/YYYY';
                ArgPesq := FormatDateTime('MM/DD/YYYY',StrToDate(ArgPesq));
              except
                formGeral.mostraMensagem('Formato da data informada inválido, verifique');
                exit;
                end;
              end;
            Query.SQL.Add(' WHERE '+QueryDlg.GridPesq.Cells[1,k] + '.VALOR ' + QueryDlg.GridPesq.Cells[2,k] + ' ' + Caspa + argPesq + Caspa + ' ');
            Break;
            end;
        Query.SQL.Add(' ORDER BY PAGINA, RELATIVO ');

        Try
          Query.Open;
        Except
          ShowMessage('Erro, verifique os parâmetros. Use ponto (.) para decimais');
          Ret := false;
          Exit;
        End;
        Break; // Já fez? cai fora!
        end;
//    Stream := nil;
    end
  else
    Stream := TFileStream.Create(ColetaDiretorioTemporario+objeto+'.Multicold',fmOpenRead);
  end;

  procedure fechaArquivoTemp(var Query : TQuery; var Stream : TFileStream; operando : variant);
  begin
  if (Stream <> nil) then
    begin
    Stream.Free;
    deleteFile(ColetaDiretorioTemporario+operando+'.Multicold');
    end
  else
    Query.Close;
  end;

  procedure descarregaSolo(Var Retorno : Boolean);
  var
    z : integer;

  begin
  abrirDados(TEditForm(ActiveMdiChild).qryPolonesa1, objF1, oprnd1, Retorno);

  if Not Retorno then
    Exit;

  setLength(TEditForm(ActiveMdiChild).gridQueryFacil,tamanhoDados(TEditForm(ActiveMdiChild).qryPolonesa1, objF1));

{  if objF1 <> nil then
    procLeitura1 := leRegistroFileStream
  else
    procLeitura1 := leRegistroQuery; }

  leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
  if ehEOF1 then
    begin
    fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,oprnd1);
    exit;
    end;

  z := 0;
  TEditForm(ActiveMdiChild).gridQueryFacil[z].Campo := reg1.Campo;
  TEditForm(ActiveMdiChild).gridQueryFacil[z].Pagina := reg1.Pagina;
  TEditForm(ActiveMdiChild).gridQueryFacil[z].Relativo := reg1.Relativo;
  TEditForm(ActiveMdiChild).gridQueryFacil[z].Linha := reg1.Linha;
//  while (not ehEOF1) do
  For z := 1 To Length(TEditForm(ActiveMdiChild).gridQueryFacil)-1 Do
    begin
//    inc(z);
//    If z >= Length(TEditForm(ActiveMdiChild).gridQueryFacil) Then
//      ShowMessage('Estourou: '+IntToStr(z)+' '+IntToStr(Length(TEditForm(ActiveMdiChild).gridQueryFacil)));
    leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
    TEditForm(ActiveMdiChild).gridQueryFacil[z].Campo := reg1.Campo;
    TEditForm(ActiveMdiChild).gridQueryFacil[z].Pagina := reg1.Pagina;
    TEditForm(ActiveMdiChild).gridQueryFacil[z].Relativo := reg1.Relativo;
    TEditForm(ActiveMdiChild).gridQueryFacil[z].Linha := reg1.Linha;
    end;
  fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,oprnd1);
  end;

  procedure descarregaOR(Var Retorno : Boolean);
  var
    intArqNum : integer;
  begin
//  TEditForm(ActiveMdiChild).qryPolonesa1 := TEditForm(ActiveMdiChild).qryPolonesa1;
//  TEditForm(ActiveMdiChild).qryPolonesa2 := TEditForm(ActiveMdiChild).qryPolonesa2;
  
  abrirDados(TEditForm(ActiveMdiChild).qryPolonesa1, objF1, oprnd1, Retorno);
  If Retorno then
    abrirDados(TEditForm(ActiveMdiChild).qryPolonesa2, objF2, oprnd2, Retorno);

  if not Retorno then
    Exit;

{  if objF1 <> nil then
    procLeitura1 := leRegistroFileStream
  else
    procLeitura1 := leRegistroQuery;

  if objF2 <> nil then
    procLeitura2 := leRegistroFileStream
  else
    procLeitura2 := leRegistroQuery; }

  intArqNum := 0;
  while true do
    begin
    t := ColetaDiretorioTemporario+intToStr(intArqNum)+'.Multicold';
    if not fileExists(t) then
      break;
    inc(intArqNum);
    end;
  h := TFileStream.Create(t,fmCreate);
  leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
  leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      h.write(reg1,sizeOf(reg1));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
      end
    end;
  while (not ehEOF1) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      reg2.Pagina := MAXINT;
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      h.write(reg1,sizeOf(reg1));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
      reg2.Pagina := MAXINT;
      end
    end;
  while (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      h.write(reg1,sizeOf(reg1));
      reg1.Pagina := MAXINT;
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
      reg1.Pagina := MAXINT;
      end
    end;
  if reg1.Pagina > reg2.Pagina then
    begin
    if reg2.Pagina <> MAXINT then
      h.write(reg2,sizeOf(reg2));
    if reg1.Pagina <> MAXINT then
      h.write(reg1,sizeOf(reg1));
    end
  else
    begin
    if reg1.Pagina <> MAXINT then
      h.write(reg1,sizeOf(reg1));
    if reg2.Pagina <> MAXINT then
      h.write(reg2,sizeOf(reg2));
    end;
  h.Free;
  fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,oprnd1);
  fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,oprnd2);
  pilhaExecucao.push(intArqNum);
  end;

  procedure descarregaAND(Var Retorno : Boolean);
  var
    intArqNum : integer;
  begin
//  TEditForm(ActiveMdiChild).qryPolonesa1 := TEditForm(ActiveMdiChild).qryPolonesa1;
//  TEditForm(ActiveMdiChild).qryPolonesa2 := TEditForm(ActiveMdiChild).qryPolonesa2;

  abrirDados(TEditForm(ActiveMdiChild).qryPolonesa1, objF1, oprnd1, Retorno);
  If Retorno Then
    abrirDados(TEditForm(ActiveMdiChild).qryPolonesa2, objF2, oprnd2, Retorno);

  if Not Retorno then
    Exit;

{  if objF1 <> nil then
    procLeitura1 := leRegistroFileStream
  else
    procLeitura1 := leRegistroQuery;

  if objF2 <> nil then
    procLeitura2 := leRegistroFileStream
  else
    procLeitura2 := leRegistroQuery; }

  intArqNum := 0;
  while true do
    begin
    t := ColetaDiretorioTemporario+intToStr(intArqNum)+'.Multicold';
    if not fileExists(t) then
      break;
    inc(intArqNum);
    end;
  h := TFileStream.Create(t,fmCreate);
  leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
  leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
  if (ehEOF1) or (ehEOF2) then
    begin
    h.Free;
    fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,oprnd1);
    fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,oprnd2);
    pilhaExecucao.push(j);
    exit;
    end;
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      pgAux := reg1.Pagina;
      while (reg1.Pagina = reg2.Pagina) and (not ehEOF1) do
        begin
        h.write(reg1,sizeOf(reg1));
        leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
        end;
      if (pgAux = reg1.Pagina) then
        h.write(reg1,sizeOf(reg1));
      while (pgAux = reg2.Pagina) and (not ehEOF2) do
        begin
        h.write(reg2,sizeOf(reg2));
        leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
        end;
      if (pgAux = reg2.Pagina) then
        h.write(reg2,sizeOf(reg2));
      end
    end;
  primeiraVez := true;
  while (not ehEOF1) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      reg2.Pagina := MAXINT;
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
      end
    else
      begin
      h.write(reg1,sizeOf(reg1));
      if primeiraVez then
        begin
        h.write(reg2,sizeOf(reg2));
        primeiraVez := false;
        end;
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,reg1,ehEOF1,oprnd1);
      end
    end;
  primeiraVez := true;
  while (not ehEOF2) do
    begin
    if reg1.Pagina > reg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
      end
    else if reg1.Pagina < reg2.Pagina then
      begin
      reg1.Pagina := MAXINT;
      end
    else
      begin
      if primeiraVez then
        begin
        h.write(reg1,sizeOf(reg1));
        primeiraVez := false;
        end;
      h.write(reg2,sizeOf(reg2));
      leRegistroFileStreamOuQuery(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,reg2,ehEOF2,oprnd2);
      end
    end;
  if (reg1.Pagina = reg2.Pagina) and (reg1.Pagina <> MAXINT) then
    begin
    h.write(reg2,sizeOf(reg2));
    h.write(reg1,sizeOf(reg1));
    end;
  h.Free;
  fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa1,objF1,oprnd1);
  fechaArquivoTemp(TEditForm(ActiveMdiChild).qryPolonesa2,objF2,oprnd2);
  pilhaExecucao.push(intArqNum);
  end;

  procedure descarregaPilha(strPilha:AnsiString; var Retorno: Boolean);
  var
    intPilha : integer;
  begin
  // Processa querys
  pilhaExecucao.clear;
  for intPilha := length(strPilha) downto 1 do
    begin
    if (strPilha[intPilha] = '(') or (strPilha[intPilha] = ')') then
      continue;
    if ehOperador(strPilha[intPilha]) then
      pilhaExecucao.push(strPilha[intPilha])
    else //if not ehOperador(strPilha[intPilha]) then
      begin
      if ehOperador(pilhaExecucao.peek) then
        pilhaExecucao.push(strPilha[intPilha])
      else
        begin
        pilhaExecucao.push(strPilha[intPilha]);
        while true do
          begin
          oprnd1 := pilhaExecucao.pop;
          oprnd2 := pilhaExecucao.pop;
          oprdr := pilhaExecucao.pop;
          if (not ehOperador(oprnd1)) and (not ehOperador(oprnd2)) and (ehOperador(oprdr)) then
            begin
            if oprdr = '*' then // AND
              descarregaAnd(Retorno)
            else if oprdr = '-' then // OR
              descarregaOr(Retorno)
            end
          else
            begin
            pilhaExecucao.push(oprdr);
            pilhaExecucao.push(oprnd2);
            pilhaExecucao.push(oprnd1);
            break;
            end;
          end;
        end
      end;
    end;
  strPilha := pilhaExecucao.pop; // Pega o último
  descarregaSolo(Retorno);
  end;

  function convOperador(operador:AnsiString):AnsiString;
  begin
  result := '';
  if operador = '=' then
    result := '1'
  else if operador = '>' then
    result := '2'
  else if operador = '<' then
    result := '3'
  else if operador = '>=' then
    result := '4'
  else if operador = '<=' then
    result := '5'
  else if operador = '<>' then
    result := '6'
  else if operador = 'IN' then
    result := '7'
  else if operador = 'IS' then
    result := '8'
  else if operador = 'BETWEEN' then
    result := '9'
  else if operador = 'LIKE' then
    result := '10'
  else if operador = 'NOT =' then
    result := '11'
  else if operador = 'NOT >' then
    result := '12'
  else if operador = 'NOT <' then
    result := '13'
  else if operador = 'NOT >=' then
    result := '14'
  else if operador = 'NOT <=' then
    result := '15'
  else if operador = 'NOT IN' then
    result := '16'
  else if operador = 'NOT BETWEEN' then
    result := '17'
  else if operador = 'IS NOT' then
    result := '18'
  else
    result := '';
  end;

Begin

  If MdiChildCount = 0 Then
    Begin
      Especial.FechaEspecial;
      Exit;
    End;
  If QueryDlg.ShowModal = mrCancel Then
    Begin
      Especial.FechaEspecial;
      Exit;
    End;
  If QueryDlg.GridPesq.Cells[1,1] = '' Then
    Begin
      Especial.FechaEspecial; // Tava invertido, desinverti... 09/10/2003
      //Exit;
    End;

  Retorno := True; // Assume tudo bem com as pesquisas

  TEditForm(ActiveMdiChild).temPesquisa := true;

  // Monta expressão infixa
  s := '(';
  for i := 1 to 100 do
    begin
      if trim(QueryDlg.GridPesq.Cells[1,i]) = '' then
        // continue;
        Break; // Passaremos a assumir que o usuário não vai deixar linhas em branco no grid de strings...

      s := s + QueryDlg.GridPesq.Cells[0,i];
      if QueryDlg.GridPesq.Cells[4,i] = 'AND' then
        s := s + '*'
      else
      if QueryDlg.GridPesq.Cells[4,i] = 'OR' then
        s := s + '-';
    end;

  s := s + ')';

  // Monta expressão pos-fixa
  if length(s) > 3 then
    s := avaliaExpressao(s);

  PilhaEspecial := s;

  //if not PesquisaEspecial then
    begin
      AvisoP.Label1.Caption := 'Pesquisando ...';
      AvisoP.Show;
      AvisoP.Repaint;

      if TEditForm(ActiveMdiChild).RelRemoto then
        begin // Manda o grid para o servidor
          strXML := '';
          strXMLGrid := '';

          for i := 1 to queryDlg.GridPesq.RowCount-1 do
            if trim(queryDlg.GridPesq.Cells[1,i]) <> '' then
              begin
              auxStr := convOperador(queryDlg.GridPesq.Cells[2,i]);
              strXMLGrid := strXMLGrid + SeEdiInt(5,3,length(queryDlg.GridPesq.Cells[0,i])) + queryDlg.GridPesq.Cells[0,i] +
                                         SeEdiInt(5,3,length(queryDlg.GridPesq.Cells[1,i])) + queryDlg.GridPesq.Cells[1,i] +
                                         SeEdiInt(5,3,length(auxStr)) + auxStr +
                                         SeEdiInt(5,3,length(queryDlg.GridPesq.Cells[3,i])) + queryDlg.GridPesq.Cells[3,i] +
                                         SeEdiInt(5,3,length(queryDlg.GridPesq.Cells[4,i])) + queryDlg.GridPesq.Cells[4,i];
              end;
          //changeFileExt(extractFileName(TEditForm(ActiveMdiChild).FileName),'')+
          //                      QueryDlg.GridPesq.Cells[1,k]+'" '+QueryDlg.GridPesq.Cells[1,k]);

          {
          if not (formGeral.HTTPRIO1 as IMulticoldServer).ExecutaNovaQueryFacil(strXMLGrid, TEditForm(ActiveMdiChild).FileName, GetCurrentUserName, s, strXML) then
            begin
              AvisoP.Close;
              messageDlg('Relatório remoto temporariamente sem suporte a query fácil. Utilize a função localizar.',mtInformation, [mbOk],0);
              exit;
            end;
          }
          strRetorno := formGeral.ExecutaNovaQueryFacil(strXMLGrid, TEditForm(ActiveMdiChild).FileName, GetCurrentUserName, s, strXML);
          RetornoLst := TStringList.Create;
          RetornoLst.Delimiter := '|';
          RetornoLst.DelimitedText := strRetorno;
          if RetornoLst.Strings[0] = '1' then
          begin
            strXML  := RetornoLst.Strings[1];
          end
          else
            begin
              AvisoP.Close;
              messageDlg('Relatório remoto temporariamente sem suporte a query fácil. Utilize a função localizar.',mtInformation, [mbOk],0);
              exit;
            end;


          TEditForm(ActiveMdiChild).ClientDataSet1.Close;
          TEditForm(ActiveMdiChild).ClientDataSet1.XMLData := deCompressHexReturnString(strXML);
          TEditForm(ActiveMdiChild).ClientDataSet1.Open;
          setLength(TEditForm(ActiveMdiChild).gridQueryFacil, TEditForm(ActiveMdiChild).ClientDataSet1.RecordCount);
          i := 0;

          while not TEditForm(ActiveMdiChild).ClientDataSet1.Eof do
            begin
              strXML := (TEditForm(ActiveMdiChild).ClientDataSet1 as TDataSet).Fields[0].asString;
              TEditForm(ActiveMdiChild).gridQueryFacil[i].Campo := AnsiChar(strXml[1]);
              TEditForm(ActiveMdiChild).gridQueryFacil[i].Pagina := (TEditForm(ActiveMdiChild).ClientDataSet1 as TDataSet).Fields[1].asInteger;
              TEditForm(ActiveMdiChild).gridQueryFacil[i].Relativo := (TEditForm(ActiveMdiChild).ClientDataSet1 as TDataSet).Fields[2].asInteger;
              TEditForm(ActiveMdiChild).gridQueryFacil[i].Linha := (TEditForm(ActiveMdiChild).ClientDataSet1 as TDataSet).Fields[3].asInteger;
              TEditForm(ActiveMdiChild).ClientDataSet1.Next;
              inc(i);
            end;

          TEditForm(ActiveMdiChild).ClientDataSet1.Close;
        end
    else
      if s <> '()' then
        descarregaPilha(s, Retorno); // Descarrega pilha

      AvisoP.Close;
    end;

  if Not Retorno then
    Exit;

  if (length(TEditForm(ActiveMdiChild).gridQueryFacil) = 0) or
     (TEditForm(ActiveMdiChild).gridQueryFacil[0].Pagina = MAXINT) then
    begin
      setLength(TEditForm(ActiveMdiChild).gridQueryFacil, 0);
      messageDlg('Nada encontrado.', mtWarning, [mbOk], 0);
      exit;
    end;

  ICampos := 0;

  //For Linha := 1 To 100 Do
  For Linha := 1 To QueryDlg.GridPesq.RowCount-1 Do
  //  If Not RepetiuCampo(Linha) Then  // Reserva o campo distinto para a montagem Do And de página e/ou linha abaixo   // Como mudou tudo, vamos construir a lista com os campos usados, repetidos ou não
    Begin
      Inc(ICampos);
      ListaDeCampos[ICampos].Campo := QueryDlg.GridPesq.Cells[1,Linha];

      For PI := 1 To SelCampo.Campos.RowCount-1 Do
        If UpperCase(ListaDeCampos[ICampos].Campo) = UpperCase(SelCampo.Campos.Cells[1,PI]) Then
          Begin
            ListaDeCampos[ICampos].PosCampo := StrToInt(SelCampo.Campos.Cells[3,PI]);
            ListaDeCampos[ICampos].TamCampo := StrToInt(SelCampo.Campos.Cells[4,PI]);
          End;
    end;

  If PesquisaEspecial Then
    Begin
      StatusForm.ListBox1.Clear;
      Primeiro := True;
      AbriuArqDsc := False;

      For J := 0 To ExecutarEspecial.ListBox1.Items.Count-1 Do
        If ExecutarEspecial.ListBox1.Selected[J] Then
          Begin

            If (Not Abrir) Or (Primeiro) Then
              For K := 0 To MDIChildCount - 1 Do
                Try
                  MDIChildren[K].Close;
                Except
                End; // Try;

            If VerificaSeguranca(Especial.StringGrid1.Cells[2,J+1]) Then
              AbreRel(Especial.StringGrid1.Cells[2,J+1], False)
            Else
              FormGeral.MostraMensagem('Usuário '+UpperCase(GetCurrentUserName)+' não autorizado a abrir o relatório '+
                          Especial.StringGrid1.Cells[2,J+1]);

            Avisop.Label1.Caption := 'Pesquisando '+Especial.StringGrid1.Cells[1,J+1];
            Avisop.Show;
            Application.ProcessMessages;

            //RepetePesquisa.Click;
            //Memo2.SelStart := Length(Memo2.Lines.Text)-1;
            //Memo2.SelLength := 1;

            s := PilhaEspecial;
            descarregaPilha(s, Retorno);

            if Not Retorno then
              Exit;

            RepetePesquisa.Click;

            Avisop.Close;

            If (TEditForm(FrameForm.ActiveMDIChild).Ocorre = 0) Then
              StatusForm.ListBox1.Items.Add('N  -> '+ExecutarEspecial.ListBox1.Items[J])
            Else
              StatusForm.ListBox1.Items.Add('Ok -> '+ExecutarEspecial.ListBox1.Items[J]);

            If Abrir Then
              Begin
                Primeiro := False;

                If (TEditForm(FrameForm.ActiveMDIChild).Ocorre = 0) Then // Sem pesquisa, fecha o relatório
                  TEditForm(FrameForm.ActiveMDIChild).Close;
                End;

            If Sugeral.Imprimir Then
              Begin
                If Primeiro Then
                  Begin
                    If FrmImprim.ShowModal <> mrOk Then
                      Begin
                        Especial.FechaEspecial;
                        Exit;
                      End;
                    Primeiro := False;
                  End
              Else
                Begin
                  FrmImprim.Show;
                  FrmImprim.ImprBut.Click;
                  FrmImprim.Close;
                End;
              End;

            If SuGeral.Exportar Then
              Begin
                If Primeiro Then
                  Begin
                    If FrmDescom.ShowModal <> mrOk Then
                      Begin
                        Especial.FechaEspecial;
                        Exit;
                      End;

                    Primeiro := False;
                  End
            Else
              Begin
                FrmDescom.Show;   // ButtonArquivo

                If TipoSaida = 'ARQUIVO' Then
                  FrmDescom.ButtonArquivo.Click;

                If TipoSaida = 'PDF' Then
                  FrmDescom.ButtonPdf.Click;

                If TipoSaida = 'WORD' Then
                  FrmDescom.ButtonWord.Click;

                If TipoSaida = 'EXCEL' Then
                  FrmDescom.ButtonExcel.Click;

                If TipoSaida = 'CLIPBOARD' Then
                  FrmDescom.ButtonClipBoard.Click;

                FrmDescom.Close;
              End;
            End;

            AvisoP.Close; // Daniel não gosta da mensagem...
          End;

      If TipoSaida = 'WORD' Then
        Begin
          WordApp.Visible := True;
          Application.Minimize;
        End;

      If TipoSaida = 'EXCEL' Then
        Begin
          ExcelApp.Visible := True;
          Application.Minimize;
        End;

      If AdicionouPaginaPdf Then
        Begin
          If TipoSaida = 'PDF' Then // O arquivo texto é criado de qualquer modo, mas se pdf então é apagado no final...
            Try
              DeleteFile(ExtractFilePath(SaveDialog1FileName)+
                         ChangeFileExt(ExtractFileName(SaveDialog1FileName),'.txt'));
            Except
            End;

          Screen.Cursor := crHourGlass;
          TEditForm(FrameForm.ActiveMDIChild).Pdf.SaveToFile(SaveDialog1FileName);
          Screen.Cursor := crDefault;
          AdicionouPaginaPdf := False;
        End;
      Try
        TEditForm(FrameForm.ActiveMDIChild).Pdf.Free;
      Except
      End;

      StatusForm.ShowModal;
    End
  Else
    RepetePesquisa.Click;

  Especial.FechaEspecial;

End;

Procedure TFrameForm.RepetePesquisaClick(Sender: TObject);

Var
  I, J, Ija,
  RCount,
  NumPag,
  QNumPag    : Integer;
  DeuErro   : Boolean;
//  strSqlConn,
//  strXML : AnsiString;
//  AdoQuery1 : TADOQuery;

Begin

If MdiChildCount = 0 Then
  Exit;

Ija := 0;
For I := 0 To (MdiChildCount - 1) Do
  If MdiChildren[I].Active Then
    Ija := I;

For J := Ija To Ija Do
  If (J = Ija) Or (PesquisaEmGrupo1.Checked) Then
    Begin
    EditPes.Text := '';
    EditPag.Text := '';
    Screen.Cursor := crHourGlass;

    With TEditForm(MdiChildren[J]) Do
      Begin
      If Not PesquisaEspecial Then
        Begin
        AvisoP.Label1.Caption := 'Pesquisando ...';
        AvisoP.Show;
        AvisoP.Repaint;
        End;
      DeuErro := False;

      (*

      If RelRemoto Then
        Begin
        strXML := (formGeral.HTTPRIO1 as IMulticoldServer).ExecutaQueryFacil(Memo2.Text,extractFilePath(FileName),eBDE);
        if trim(strXML) <> '' then
          begin
          ClientDataSet1.XMLData := strXml;
          ClientDataSet1.Open;
          CarregaQueryFacil(ClientDataSet1);
          end;
        ClientDataSet1.Close;
        End
      Else
        Begin
        if eBDE then // Se executa a query via BDE
          Begin
          Query1.Close; { deixa a query inativa }
          Query1.DatabaseName := extractFilePath(FileName);
          Query1.Sql.Clear;
          Query1.Sql := Memo2.Lines;
          Try
            If Length(Query1.Sql.Text) > 6 Then
              Query1.Open
            Else
              DeuErro := True;
          Except
            On E: Exception Do
              If J = Ija Then
                Begin
                Screen.Cursor := crDefault;
                FormGeral.MostraMensagem('Query inválida... '+E.Message);
                AvisoP.Close;
                Exit;
                End
              Else
                DeuErro := True;
            End; {Try..Except}
          if Query1.Active then
            CarregaQueryFacil(Query1);
          Query1.Close;
          end
        else // ou via ADO
          begin
          strSqlConn := 'Provider=MSDASQL.1;'+
                        'Persist Security Info=False;'+
                        'Extended Properties="CollatingSequence=ASCII;'+
                                             'DefaultDir='+extractFilePath(FileName)+';'+
                                             'Deleted=1;'+
                                             'Driver={Driver do Microsoft dBase (*.dbf)};'+ // Driver em português
                                             'DriverId=21;'+
                                             'FIL=dBase III;'+
                                             'FILEDSN='+extractFilePath(ParamStr(0))+'Multicold.dsn;'+
                                             'MaxBufferSize=2048;'+
                                             'MaxScanRows=8;'+
                                             'PageTimeout=600;'+
                                             'SafeTransactions=0;'+
                                             'Statistics=0;'+
                                             'Threads=3;'+
                                             'UID=admin;'+
                                             'UserCommitSync=Yes;"';
          //strSqlConn := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+extractFilePath(FileName)+';Extended Properties=dBase III;Persist Security Info=False';
          AdoQuery1 := TADOQuery.Create(TEditForm(MdiChildren[J]));
          AdoQuery1.CursorLocation := clUseClient;
          AdoQuery1.CursorType := ctOpenForwardOnly;
          AdoQuery1.LockType := ltReadOnly;
          AdoQuery1.ConnectionString := strSqlConn;
          AdoQuery1.Sql.Clear;
          AdoQuery1.Sql := Memo2.Lines;
          Try
            If Length(AdoQuery1.Sql.Text) > 6 Then
              AdoQuery1.Open
            Else
              DeuErro := True;
          Except
            On E: Exception Do
              If J = Ija Then
                Begin
                Screen.Cursor := crDefault;
                FormGeral.MostraMensagem('Query inválida... '+E.Message);
                AvisoP.Close;
                Exit;
                End
              Else
                DeuErro := True;
            End; {Try..Except}
          if AdoQuery1.Active then
            CarregaQueryFacil(AdoQuery1);
          AdoQuery1.Close;
          AdoQUery1.Free;
          end;
        End;

      *)

      If Not PesquisaEspecial Then
        AvisoP.Close;

      RCount := 0;
      Try
        RCount := high(gridQueryFacil)+1;
      //If RelRemoto Then
      //  RCount := ClientDataSet1.RecordCount
      //Else
      //  RCount := Query1.RecordCount;
      Except
        DeuErro := True;
        End; // Try

//      If (Not (DeuErro)) And (Query1.RecordCount <> 0) Then
      If (Not (DeuErro)) And (RCount <> 0) Then
        Begin
        ReWrite(ArqPsq); { Depósito de páginas com pesquisa OK }
        NumPag := -1;
//        For I := 1 To Query1.RecordCount Do
//        For I := 1 To RCount Do
        For I := 0 To RCount-1 Do
          Begin

          //QNumPag := strToInt(gridQueryFacil[I,1]);
          QNumPag := gridQueryFacil[I].Pagina;
          //If RelRemoto Then
          //  QNumPag := ClientDataSet1.Fields[1].AsInteger
          //Else
          //  QNumPag := Query1.Fields[1].AsInteger;

//          If Query1.Fields[1].AsInteger <> NumPag Then
          If QNumPag <> NumPag Then
            Begin
//            NumPag := Query1.Fields[1].AsInteger;
            NumPag := QNumPag;
            RegPsq.Pagina := NumPag;
            RegPsq.PosQuery := I;
            Write(ArqPsq,RegPsq);
            End;
          //If RelRemoto Then
          //  ClientDataSet1.Next
          //Else
          //  Query1.Next;
          End;
        Reset(ArqPsq); { Flush the file as soon as possible }
        Read(ArqPsq,RegPsq);
        Reset(ArqPsq); { Primeira informação }

        //QNumPag := strToInt(gridQueryFacil[0,1]) - 1;
        QNumPag := gridQueryFacil[0].Pagina - 1;
        //If RelRemoto Then
        //  Begin
        //  ClientDataSet1.First;
        //  QNumPag := ClientDataSet1.Fields[1].AsInteger - 1
        //  End
        //Else
        //  Begin
        //  Query1.First;  { Returns To first key found }
        //  QNumPag := Query1.Fields[1].AsInteger - 1
        //  End;

        Ocorre := FileSize(ArqPsq);  { Número de Páginas }

//        ScrollBar2.Position := Query1.Fields[1].AsInteger - 1;
//        Scroll2Pos := Query1.Fields[1].AsInteger - 1;
        ScrollBar2.Position := QNumPag;
        Scroll2Pos := QNumPag;
        Label2.Caption := IntToStr(ScrollBar2.Position+1) + ' de ' + IntToStr(Paginas);
        Lab2 := Label2.Caption;
        //Inicio := 0;                           { Depois de copiar os registros Inicio = 0}

        If FezAnotacoesGraficas Then
          If MessageDlg('Deseja salvar as anotações gráficas realizadas?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
            AnotaForm.SalvarButton.Click;

        If FezAnotacoesDeTexto And (AnotaTextoForm.Memo1.Text <> '') Then
          If MessageDlg('Deseja salvar as anotações de texto realizadas?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
            AnotaTextoForm.SalvarButton.Click;

        If Not RelRemoto Then
          Begin
          Seek(ArqPag64,gridQueryFacil[0].Pagina-1);
          Read(ArqPag64,RegPag64);
          End;

        CarregaImagem(True,QNumPag+1);

        ScrollBar1.Position := 0;
        Scroll1Pos := 0;
        If Ocorre > 1 Then
          Begin
          ScrollBar1.Min := 0;
          ScrollBar1.Max := Ocorre-1;
          Scroll1Min := 0;
          Scroll1Max := Ocorre-1;
          End
        Else
          Begin
          ScrollBar1.Min := 0;       { um só candidato }
          ScrollBar1.Max := 0;
          Scroll1Min := 0;
          Scroll1Max := 0;
          End;

        Label1.Caption := IntToStr(ScrollBar1.Position+1) + ' de ' + IntToStr(Ocorre);
        Lab1 := Label1.Caption;

        End
      Else
        If (not(DeuErro)) Then
          If J = Ija Then
            Begin
            Screen.Cursor := crDefault;
            FormGeral.MostraMensagem('Nada encontrado!');
            Label1.Caption := '0 de 0';
            ScrollBar1.Position := 0;
            ScrollBar1.Min := 0;       { nenhum candidato }
            ScrollBar1.Max := 0;
            Scroll1Min := 0;
            Scroll1Max := 0;
            Scroll1Pos := 0;
            Ocorre := 0;
            End;
    End;
  End; { With }

Screen.Cursor := crDefault;

End;

Procedure TFrameForm.Scrolla1;
Begin
With TEditForm(ActiveMdiChild) Do
  Begin

  If (Ocorre = 0) or (Ocorre = 1) Then
    Exit;

  Screen.Cursor := crHourGlass;

  Scroll1Pos := ScrollBar1.Position;  { Saves location }

  //Seek(ArqPsq,ScrollBar1.Position+Inicio);
  Seek(ArqPsq,ScrollBar1.Position);
  {$i-}
  Read(ArqPsq,RegPsq);
  {$i+}
  If IoResult <> 0 Then
    Begin
    FormGeral.MostraMensagem('Erro de Scrolling Ind');
    Halt;
    End;

  //ScrollBar2.Position := strToInt(gridQueryFacil[RegPsq.PosQuery,1]) - 1;
  ScrollBar2.Position := gridQueryFacil[RegPsq.PosQuery].Pagina - 1;

  //If RelRemoto Then
  //  Begin
  //  ClientDataSet1.First;
  //  ClientDataSet1.MoveBy(RegPsq.PosQuery-1);
  //  ScrollBar2.Position := ClientDataSet1.Fields[1].AsInteger - 1;
  //  End
  //Else
  //  Begin
  //  Query1.First;
  //  Query1.MoveBy(RegPsq.PosQuery-1);
  //  ScrollBar2.Position := Query1.Fields[1].AsInteger - 1;
  //  End;

  Scroll2Pos := ScrollBar2.Position;  { Saves location }

  If RelRemoto Then
//    CarregaImagem(RegPag64,True,ClientDataSet1.Fields[1].AsInteger)
//    CarregaImagem(True,ClientDataSet1.Fields[1].AsInteger)
//    CarregaImagem(True,strToInt(gridQueryFacil[RegPsq.PosQuery,1]))
    CarregaImagem(True,gridQueryFacil[RegPsq.PosQuery].Pagina)
  Else
    Begin
    Seek(ArqPag64,gridQueryFacil[RegPsq.PosQuery].Pagina - 1);  { inicia de 0 }
    Read(ArqPag64,RegPag64);
    CarregaImagem(True,gridQueryFacil[RegPsq.PosQuery].Pagina);
    End;
    
  Label1.Caption := IntToStr(ScrollBar1.Position+1) + ' de ' + IntToStr(Ocorre);
  Label2.Caption := IntToStr(ScrollBar2.Position+1) + ' de ' + IntToStr(Paginas);
  Lab1 := Label1.Caption;
  Lab2 := Label2.Caption;

  Screen.Cursor := crDefault;
  End;
End;

Procedure TFrameForm.Scrolla2;
Begin
With TEditForm(ActiveMdiChild) Do
  Begin
  Scroll2Pos := ScrollBar2.Position;  { Saves location }

  If FezAnotacoesGraficas Then
    If MessageDlg('Deseja salvar as anotações gráficas realizadas?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      AnotaForm.SalvarButton.Click;

  If FezAnotacoesDeTexto And (AnotaTextoForm.Memo1.Text <> '') Then
    If MessageDlg('Deseja salvar as anotações de texto realizadas?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      AnotaTextoForm.SalvarButton.Click;

  Screen.Cursor := crHourGlass;

  ScrollBar2.Position := Scroll2Pos;  { Returns to new location }
  If Not RelRemoto Then
    Begin
    Seek(ArqPag64,ScrollBar2.Position);
    Read(ArqPag64,RegPag64);
    End;

  CarregaImagem(False,ScrollBar2.Position+1);

  Label2.Caption := IntToStr(ScrollBar2.Position+1) + ' de ' + IntToStr(Paginas);
  Lab2 := Label2.Caption;

  Screen.Cursor := crDefault;
  End;
End;

Procedure TFrameForm.VaiPesquisaClick(Sender: TObject);
Var
  Err : Integer;
  Posic : LongInt;
Begin

If MdiChildCount = 0 Then
  Exit;

If EditPes.Text = '' Then
  EditPes.Text := '1';
Val(EditPes.Text,Posic,Err);
If Err <> 0 Then
  Begin
  EditPes.Text := '1';
  Posic := 1;
  End;
If Posic < 1 Then
  Posic := 1;
ScrollBar1.Position := Posic-1;
Scrolla1;
End;

Procedure TFrameForm.VaiPaginaClick(Sender: TObject);
Var
  Err : Integer;
  Posic : LongInt;
Begin

If MdiChildCount = 0 Then
  Exit;
If EditPag.Text = '' Then
  EditPag.Text := '1';
Val(EditPag.Text,Posic,Err);
If Err <> 0 Then
  Begin
  EditPag.Text := '1';
  Posic := 1;
  End;
If Posic < 1 Then
  Posic := 1;
ScrollBar2.Position := Posic-1;
Scrolla2;
End;

Procedure TFrameForm.ImprimirClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
AbriuArqDsc := False; 
Primeiro := True;
Especial.FechaEspecial;
FrmImprim.ImpriAtuRdBut.Checked := True;
FrmImprim.ShowModal;
End;

Procedure TFrameForm.PesquisaemGrupo1Click(Sender: TObject);
Begin
PesquisaEmGrupo1.Checked := Not PesquisaEmGrupo1.Checked;
End;

Procedure TFrameForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; Var ScrollPos: Integer);
Begin
If ScrollCode <> scEndScroll Then
  Exit;
If MdiChildCount = 0 Then
  Exit;
Scrolla1;
End;

Procedure TFrameForm.ScrollBar2Scroll(Sender: TObject;
  ScrollCode: TScrollCode; Var ScrollPos: Integer);
Begin
If ScrollCode <> scEndScroll Then
  Exit;
If MdiChildCount = 0 Then
  Exit;
Scrolla2;
End;

Procedure TFrameForm.DescompactarClick(Sender: TObject);
Begin
  If MdiChildCount = 0 Then
    Exit;

  AbriuArqDsc := False;
  Primeiro := True;
  Especial.FechaEspecial;
  FrmDescom.RadioPagAtu.Checked := True;
  FrmDescom.Show;

  If TipoSaida = 'PDF' Then
    Try
      DeleteFile(ExtractFilePath(SaveDialog1FileName)+
                 ChangeFileExt(ExtractFileName(SaveDialog1FileName),'.txt'));
    Except
      End;
End;

procedure TFrameForm.DownloadManager1Click(Sender: TObject);
begin
  FrmDownloadManager.Show;
end;

procedure TFrameForm.ExportarSpeedButtonClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
AbriuArqDsc := False;
Primeiro := True;
Especial.FechaEspecial;
FrmTemplate.Show;
End;

Procedure TFrameForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Var
  I : Integer;
Begin
  {$i-}                   { ArqQue Belongs To the Session So... }
  CloseFile(ArqQue);
  If IoResult = 0 Then;

  Erase(ArqQue);
  {$i+}
  If IoResult = 0 Then;

  For I := 0 To MDIChildCount - 1 Do
    Try
      MDIChildren[I].Close;
    Except
    End; // Try;

  //WebConnection1.Connected := False;
  FormGeral.DatabaseMultiCold.Connected := False;
  FormGeral.DatabaseLog.Connected := False;
  FormGeral.DatabaseEventos.Connected := False;

  Action := caFree;

End;

Procedure TFrameForm.SobreoMultiCold1Click(Sender: TObject);
Begin
SobreForm.ShowModal;
End;

Procedure TFrameForm.AbrirAssistido1Click(Sender: TObject);
Var
  I, II, III, J, K, SisOld : Integer;
  Prima : Boolean;
  RelRoot : TTreeNode;

  Function PodeIncluir(J, CodSis, CodGrupo : Integer) : Boolean;
  Var
    I : Integer;
  Begin
  Result := False;

  If ArDFN[J].CodRel = '*' Then
    Exit;

  If CodSis < 0 Then
    Exit;

  If CodGrupo < 0 Then
    Exit;

  For I := 0 To Length(ArINC) - 1 Do
    Begin
    If (ArINC[I].CodSis = -999) Or
       (ArINC[I].CodSis = CodSis) Then
    If (ArINC[I].CodGrupo = -999) Or
       (ArINC[I].CodGrupo = CodGrupo) Then
    If (ArINC[I].CodSubGrupo = -999) Or
       (ArINC[I].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
    If (ArINC[I].CodRel = '*') Or
       (ArINC[I].CodRel = ArDFN[J].CodRel) Then
      Begin
      Result := True;
      Break;
      End;
    End;

  If Not Result Then
    Exit;

  For I := 0 To Length(ArEXC) - 1 Do
    Begin
    If (ArEXC[I].CodSis = -999) Or
       (ArEXC[I].CodSis = CodSis) Then
    If (ArEXC[I].CodGrupo = -999) Or
       (ArEXC[I].CodGrupo = CodGrupo) Then
    If (ArEXC[I].CodSubGrupo = -999) Or
       (ArEXC[I].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
    If (ArEXC[I].CodRel = '*') Or
       (ArEXC[I].CodRel = ArDFN[J].CodRel) Then
      Begin
      Result := False;
      Break;
      End;
    End;

  If Result And AssisAbreForm.FiltradoCheckBox.Checked Then
    Begin
    Result := False;
    For I := 0 To Length(ArCompila) - 1 Do
      Begin
      If (ArCompila[I].CodRel = ArDFN[J].CodRel) And
         (ArCompila[I].CodSis = CodSis) And
         (ArCompila[I].CodGrupo = CodGrupo) And
         (ArCompila[I].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
        Begin
        Result := True;
        Break;
        End;
      End;
    End;

  End;

Begin
Especial.FechaEspecial;
If Not CarregaDadosDfnIncExc Then
  Begin
  FormGeral.MostraMensagem('Base de relatórios não encontrada, use a abertura de relatórios não assistida');
  Exit;
  End; // Try

//If JaAbriu Then
ShowMessage('chegou aqui 4....');
If Tela <> '' Then
  Begin
  If Length(ArINC) <> 0 Then // Há relatórios associados...
    AssisAbreForm.Show
  Else
    FormGeral.MostraMensagem('Tente a abertura de relatórios não assistida...');
  Tela := 'AssisAbreLocal';
  Exit;
  End;

Tela := 'AssisAbreLocal';

// Tratamento dos relatórios da lista de inclusão

If Length(ArINC) = 0 Then
  Begin
  FormGeral.MostraMensagem('Nenhum Relatório associado ao seu usuário: '+UpperCase(GetCurrentUserName));
  Exit;
  End;

// Add Items to the new structure used - TreeView

Avisop.Label1.Caption := 'Montando árvore, aguarde...';
Avisop.Show;
Application.ProcessMessages;

AssisAbreForm.TreeView1.Items.Clear;
AssisAbreForm.TreeView1.ReadOnly := True;
AssisAbreForm.TreeView1.SortType := stNone;

RelRoot := Nil; {Prima := True;} SisOld := MaxInt;
For J := 0 To Length(ArDFN) - 1 Do
  Begin

  if ArDFN[j].CodRel = 'EPI' then
    ArDFN[j].CodRel := ArDFN[j].CodRel;

  If ArDFN[J].SisAuto then
    Begin
    Prima := true;
    For I := 0 To Length(ArrSisAux2) - 1 Do
      begin
      if SisOld <> ArrSisAux2[I].CodSis then
        Begin
        Prima := True;
        SisOld := ArrSisAux2[I].CodSis;
        end;

      If (ArrSisAux2[I].CodRel = ArDFN[J].CodRel) And PodeIncluir(J, ArrSisAux2[I].CodSis, ArrSisAux2[I].CodGrupo) Then
        Begin

//        If ArDFN[J].CodRel = 'UAR003R1' Then    macaquinho do problema da inconsistencia
//          Prima := Prima;

        For II := 0 To Length(ArSis)-1 Do  // Achar o nome do Sistema
          If (ArSis[II].CodSis = ArrSisAux2[I].CodSis) Then
            Begin
            Break;
            End;

        For III := 0 To Length(ArGrupo)-1 Do  // Achar o nome do Grupo
          If (ArGrupo[III].CodSis = ArrSisAux2[I].CodSis) And
             (ArGrupo[III].CodGrupo = ArrSisAux2[I].CodGrupo) Then
            Begin
            Break;
            End;

        For K := 0 To Length(ArSubGrupo)-1 Do  // Achar o nome do SubGrupo
          If (ArSubGrupo[K].CodSis = ArDFN[J].CodSis) And
             (ArSubGrupo[K].CodGrupo = ArDFN[J].CodGrupo) And
             (ArSubGrupo[K].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
            Break;

        If Prima Then
          Begin
          RelRoot := AssisAbreForm.TreeView1.Items.Add(RelRoot,ArDFN[J].CodRel);
          AssisAbreForm.TreeView1.Items.AddChild(RelRoot,'  '+ArSubGrupo[K].NomeSubGrupo+' '+ArSis[II].NomeSis);
          Prima := False;
          End;

        With AssisAbreForm.TreeView1.Items Do
          //If ArGrupo[I].CodGrupo < 0 Then
          //  AddChild(RelRoot,Format('%3.3d',[ArGrupo[III].CodGrupo])+' - '+ArGrupo[III].NomeGrupo)
          //Else
            AddChild(RelRoot,' '+Format('%3.3d',[ArGrupo[III].CodGrupo])+' - '+ArGrupo[III].NomeGrupo);
        End
      end;
    End
  else
  If ArDFN[J].GrupoAuto Then
    Begin
    Prima := True;
    For I := 0 To Length(ArGrupo) - 1 Do
      If (ArGrupo[I].CodSis = ArDFN[J].CodSis) And PodeIncluir(J, ArDFN[J].CodSis, ArGrupo[I].CodGrupo) Then
        Begin
        For II := 0 To Length(ArSis)-1 Do  // Achar o nome do Sistema
          If (ArSis[II].CodSis = ArDFN[J].CodSis) Then
            Break;

        For K := 0 To Length(ArSubGrupo)-1 Do  // Achar o nome do SubGrupo
          If (ArSubGrupo[K].CodSis = ArDFN[J].CodSis) And
             (ArSubGrupo[K].CodGrupo = ArDFN[J].CodGrupo) And
             (ArSubGrupo[K].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
            Break;

        If Prima Then
          Begin
          RelRoot := AssisAbreForm.TreeView1.Items.Add(RelRoot,ArDFN[J].CodRel);
          AssisAbreForm.TreeView1.Items.AddChild(RelRoot,'  '+ArSubGrupo[K].NomeSubGrupo+' '+ArSis[II].NomeSis);
          Prima := False;
          End;
        With AssisAbreForm.TreeView1.Items Do
          If ArGrupo[I].CodGrupo < 0 Then
            AddChild(RelRoot,Format('%3.3d',[ArGrupo[I].CodGrupo])+' - '+ArGrupo[I].NomeGrupo)
          Else
            AddChild(RelRoot,' '+Format('%3.3d',[ArGrupo[I].CodGrupo])+' - '+ArGrupo[I].NomeGrupo);
        End
    End
  Else
    If PodeIncluir(J, ArDFN[J].CodSis, ArDFN[J].CodGrupo) Then
      With AssisAbreForm.TreeView1.Items Do
        Begin
        For II := 0 To Length(ArSis)-1 Do  // Achar o nome do Sistema
          If (ArSis[II].CodSis = ArDFN[J].CodSis) Then
            Break;

        For I := 0 To Length(ArGrupo)-1 Do  // Achar o nome do Grupo
          If (ArGrupo[I].CodSis = ArDFN[J].CodSis) And
             (ArGrupo[I].CodGrupo = ArDFN[J].CodGrupo) Then
            Break;

        For K := 0 To Length(ArSubGrupo)-1 Do  // Achar o nome do SubGrupo
          If (ArSubGrupo[K].CodSis = ArDFN[J].CodSis) And
             (ArSubGrupo[K].CodGrupo = ArDFN[J].CodGrupo) And
             (ArSubGrupo[K].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
            Break;

        RelRoot := AssisAbreForm.TreeView1.Items.Add(RelRoot,ArDFN[J].CodRel);
        AddChild(RelRoot,'  '+ArSubGrupo[K].NomeSubGrupo + ' ' + ArSis[II].NomeSis);

        If ArDFN[J].CodGrupo < 0 Then
          AddChild(RelRoot,Format('%3.3d',[ArDFN[J].CodGrupo])+' - '+ArGrupo[I].NomeGrupo)
        Else
          AddChild(RelRoot,' '+Format('%3.3d',[ArDFN[J].CodGrupo])+' - '+ArGrupo[I].NomeGrupo);
        End;
  End;
AssisAbreForm.TreeView1.SortType := stText;

Avisop.Close;

AssisAbreForm.ListBox2.Clear;

If Length(ArINC) <> 0 Then // Há relatórios associados...
  AssisAbreForm.Show;
AssisAbreFlg := True;

End;

Procedure TFrameForm.AbrirRemoto1Click(Sender: TObject);
Var
  Dados : TStringList;
  I, J, K, II, III, SisOld : Integer;
  Prima : Boolean;
  RelRoot : TTreeNode;
  StrAux : AnsiString;
  Retorno : TStringList;

  Function PodeIncluir(J, CodSis, CodGrupo : Integer) : Boolean;
  Var
    I : Integer;
  Begin
  Result := False;

  If ArDFNRemoto[J].CodRel = '*' Then
    Exit;

  If CodGrupo < 0 Then
    Exit;

  If CodSis < 0 Then
    Exit;

  For I := 0 To Length(ArINCRemoto) - 1 Do
    Begin
    If (ArINCRemoto[I].CodSis = -999) Or
       (ArINCRemoto[I].CodSis = CodSis) Then
    If (ArINCRemoto[I].CodGrupo = -999) Or
       (ArINCRemoto[I].CodGrupo = CodGrupo) Then
    If (ArINCRemoto[I].CodSubGrupo = -999) Or
       (ArINCRemoto[I].CodSubGrupo = ArDFNRemoto[J].CodSubGrupo) Then
    If (ArINCRemoto[I].CodRel = '*') Or
       (ArINCRemoto[I].CodRel = ArDFNRemoto[J].CodRel) Then
      Begin
      Result := True;
      Break;
      End;
    End;

  If Not Result Then
    Exit;

  For I := 0 To Length(ArEXCRemoto) - 1 Do
    Begin
      If (ArEXCRemoto[I].CodSis = -999) Or
         (ArEXCRemoto[I].CodSis = CodSis) Then
        If (ArEXCRemoto[I].CodGrupo = -999) Or
           (ArEXCRemoto[I].CodGrupo = CodGrupo) Then
          If (ArEXCRemoto[I].CodSubGrupo = -999) Or
             (ArEXCRemoto[I].CodSubGrupo = ArDFNRemoto[J].CodSubGrupo) Then
            If (ArEXCRemoto[I].CodRel = '*') Or
               (ArEXCRemoto[I].CodRel = ArDFNRemoto[J].CodRel) Then
              Begin
                Result := False;
                Break;
              End;
    End;
  End;

Begin
  Especial.FechaEspecial;

  If Not ConectouRemoto Then
    Begin
      If UrlRemoteServer = '' Then
        Begin
          LogInRemotoForm.ModalResult := mrCancel;
          If LogInRemotoForm.ShowModal = mrOK Then
            Begin
              formGeral.HTTPRIO1.WSDLLocation := LogInRemotoForm.URLEdit.Text;
              formGeral.HTTPRIO1.Service := 'IMulticoldServerservice';
              formGeral.HTTPRIO1.Port := 'IMulticoldServerPort';
              //      InvRegistry.RegisterInterface(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer', '');
              //      InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer#%operationName%');
            End
          Else
            Begin
              Screen.Cursor := crDefault;
              Exit;
            End;
        End
      Else
        Begin
          formGeral.HTTPRIO1.WSDLLocation := urlRemoteServer;
          formGeral.HTTPRIO1.Service := 'IMulticoldServerservice';
          formGeral.HTTPRIO1.Port := 'IMulticoldServerPort';
          //    InvRegistry.RegisterInterface(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer', '');
          //    InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer#%operationName%');
          LogInRemotoForm.Show;
          LogInRemotoForm.Close;
        End;

      AssisAbreRemotoForm.ListBox2.Clear;

      //WebConnection1.Connected := False;
      Screen.Cursor := crHourGlass;
      Dados := TStringList.Create;
      SetLength(ArDFNRemoto,0);
      SetLength(ArIncRemoto,0);
      SetLength(ArExcRemoto,0);
      SetLength(ArSisRemoto,0);
      SetLength(ArGrupoRemoto,0);
      SetLength(ArSubGrupoRemoto,0);

      Try
        //WebConnection1.Connected := True;
        //Dados.Text := WebConnection1.AppServer.LogIn(LogInRemotoForm.UsuEdit.Text, LogInRemotoForm.PassEdit.Text, ConnectionID);
        //    (formGeral.HTTPRIO1 as IMulticoldServer).Teste;
        //    showmessage((formGeral.HTTPRIO1 as IMulticoldServer).LogInX(LogInRemotoForm.UsuEdit.Text, LogInRemotoForm.PassEdit.Text, ConnectionID));
        //    Teste := GetIMulticoldServer;
        //    Teste.LogIn(LogInRemotoForm.UsuEdit.Text, LogInRemotoForm.PassEdit.Text, ConnectionID);
       // StrAux := (formGeral.HTTPRIO1 as IMulticoldServer).LogIn(LogInRemotoForm.UsuEdit.Text,
       //                                                          LogInRemotoForm.PassEdit.Text,
       //                                                          ConnectionID);
        StrAux := formGeral.LogIn(LogInRemotoForm.UsuEdit.Text,
                                  LogInRemotoForm.PassEdit.Text,
                                  ConnectionID);
        Retorno := TStringList.Create;
        Retorno.Delimiter := '|';
        Retorno.DelimitedText := StrAux;
        if Retorno.Count = 1 then
          ConnectionID := StrToInt(Retorno.Strings[0])
        else
          ConnectionID := StrToInt(Retorno.Strings[1]);

        //Dados.Text := deCompressHexReturnString(StrAux);
        Dados.Text := deCompressHexReturnString(Retorno.Strings[0]);
      Except
        on e:exception do
          begin
            messageDlg(e.message,mtError,[mbOk],0);
            Screen.Cursor := crDefault;
            //ConectouRemoto := False;
            ConnectionID := 0;
          end;
      End; // Try

      Screen.Cursor := crDefault;
      If ConnectionID = 0 Then
        Begin
          // ConectouRemoto := False;
          // FormGeral.MostraMensagem('Conexão remota não foi realizada...');

          if trim(Dados.Text) <> '' then
            FormGeral.MostraMensagem(Dados.Text);

          Dados.Free;
          // ConectouRemoto := False;

          Exit;
        end
      else
        begin

          SetLength(ArDFNRemoto, StrToInt(Dados[0]));
          J := 1;

          For I := 0 To Length(ArDFNRemoto)-1 Do
            Begin
              ArDFNRemoto[I].CodRel := Dados[J];
              ArDFNRemoto[I].CodSis := StrToInt(Dados[J+1]);
              ArDFNRemoto[I].CodGrupo := StrToInt(Dados[J+2]);
              ArDFNRemoto[I].CodSubGrupo := StrToInt(Dados[J+3]);
              ArDFNRemoto[I].GrupoAuto := (Dados[J+4]='T');
              ArDFNRemoto[I].SisAuto := (Dados[J+5]='T');
              Inc(J,6);
            End;

          SetLength(ArINCRemoto, StrToInt(Dados[J]));
          Inc(J);

          For I := 0 To Length(ArINCRemoto)-1 Do
            Begin
              ArINCRemoto[I].CodUsu := Dados[J];
              ArINCRemoto[I].CodSis := StrToInt(Dados[J+1]);
              ArINCRemoto[I].CodGrupo := StrToInt(Dados[J+2]);
              ArINCRemoto[I].CodSubGrupo := StrToInt(Dados[J+3]);
              ArINCRemoto[I].CodRel := Dados[J+4];
              Inc(J,5);
            End;

          SetLength(ArEXCRemoto, StrToInt(Dados[J]));
          Inc(J);

          For I := 0 To Length(ArEXCRemoto)-1 Do
            Begin
              ArEXCRemoto[I].CodUsu := Dados[J];
              ArEXCRemoto[I].CodSis := StrToInt(Dados[J+1]);
              ArEXCRemoto[I].CodGrupo := StrToInt(Dados[J+2]);
              ArEXCRemoto[I].CodSubGrupo := StrToInt(Dados[J+3]);
              ArEXCRemoto[I].CodRel := Dados[J+4];
              Inc(J,5);
            End;

          SetLength(ArSisRemoto, StrToInt(Dados[J]));
          Inc(J);

          For I := 0 To Length(ArSisRemoto)-1 Do
            Begin
              ArSisRemoto[I].CodSis := StrToInt(Dados[J]);
              ArSisRemoto[I].NomeSis := Dados[J+1];
              Inc(J,2);
            End;

          SetLength(ArGrupoRemoto, StrToInt(Dados[J]));
          Inc(J);

          For I := 0 To Length(ArGrupoRemoto)-1 Do
            Begin
              ArGrupoRemoto[I].CodSis := StrToInt(Dados[J]);
              ArGrupoRemoto[I].CodGrupo := StrToInt(Dados[J+1]);
              ArGrupoRemoto[I].NomeGrupo := Dados[J+2];
              Inc(J,3);
            End;

          SetLength(ArSubGrupoRemoto, StrToInt(Dados[J]));
          Inc(J);

          For I := 0 To Length(ArSubGrupoRemoto)-1 Do
            Begin
              ArSubGrupoRemoto[I].CodSis := StrToInt(Dados[J]);
              ArSubGrupoRemoto[I].CodGrupo := StrToInt(Dados[J+1]);
              ArSubGrupoRemoto[I].CodSubGrupo := StrToInt(Dados[J+2]);
              ArSubGrupoRemoto[I].NomeSubGrupo := Dados[J+3];
              Inc(J,4);
            End;

          SetLength(ArrSisAuxRemoto, StrToInt(Dados[J]));
          Inc(J);

          For I := 0 To Length(ArrSisAuxRemoto)-1 Do
            Begin
              ArrSisAuxRemoto[I].CodRel := Dados[J];
              ArrSisAuxRemoto[I].CodSis := StrToInt(Dados[J+1]);
              ArrSisAuxRemoto[I].CodGrupo := StrToInt(Dados[J+2]);
              Inc(J,3);
            End;

          Avisop.Label1.Caption := 'Montando árvore de relatórios remotos, aguarde...';
          Avisop.Show;
          Application.ProcessMessages;

          AssisAbreRemotoForm.TreeView1.Items.Clear;
          AssisAbreRemotoForm.TreeView1.ReadOnly := True;
          AssisAbreRemotoForm.TreeView1.SortType := stNone;

          RelRoot := Nil;  {Prima := True;} SisOld := MaxInt;
          For J := 0 To Length(ArDFNRemoto) - 1 Do
            Begin
              If ArDFNRemoto[J].SisAuto then
                Begin
                  Prima := true;

                  For I := 0 To Length(ArrSisAuxRemoto) - 1 Do
                    Begin
                      if ArrSisAuxRemoto[I].CodSis <> SisOld then
                        begin
                          Prima := True;
                          SisOld := ArrSisAuxRemoto[I].CodSis;
                        end;

                      If (ArrSisAuxRemoto[I].CodRel = ArDFNRemoto[J].CodRel) And PodeIncluir(J, ArrSisAuxRemoto[I].CodSis ,ArrSisAuxRemoto[I].CodGrupo) Then
                        Begin
                          For II := 0 To Length(ArSisRemoto)-1 Do  // Achar o nome do Sistema
                             If (ArSisRemoto[II].CodSis = ArrSisAuxRemoto[I].CodSis) Then
                               Break;

                          For III := 0 To Length(ArGrupoRemoto)-1 Do  // Achar o nome do Grupo
                            If (ArGrupoRemoto[III].CodSis = ArrSisAuxRemoto[I].CodSis) And
                               (ArGrupoRemoto[III].CodGrupo = ArrSisAuxRemoto[I].CodGrupo) Then
                              Break;

                          For K := 0 To Length(ArSubGrupoRemoto)-1 Do  // Achar o nome do SubGrupo
                            If (ArSubGrupoRemoto[K].CodSis = ArDFNRemoto[J].CodSis) And
                               (ArSubGrupoRemoto[K].CodGrupo = ArDFNRemoto[J].CodGrupo) And
                               (ArSubGrupoRemoto[K].CodSubGrupo = ArDFNRemoto[J].CodSubGrupo) Then
                              Break;

                          If Prima Then
                            Begin
                              RelRoot := AssisAbreRemotoForm.TreeView1.Items.Add(RelRoot,ArDFNRemoto[J].CodRel);
                              AssisAbreRemotoForm.TreeView1.Items.AddChild(RelRoot,'  '+ArSubGrupoRemoto[K].NomeSubGrupo+' '+ArSisRemoto[II].NomeSis);
                              Prima := False;
                            End;

                          With AssisAbreRemotoForm.TreeView1.Items Do
                          //If ArGrupo[I].CodGrupo < 0 Then
                          //  AddChild(RelRoot,Format('%3.3d',[ArGrupoRemoto[III].CodGrupo])+' - '+ArGrupoRemoto[III].NomeGrupo)
                          //Else
                            AddChild(RelRoot,' '+Format('%3.3d',[ArGrupoRemoto[III].CodGrupo])+' - '+ArGrupoRemoto[III].NomeGrupo);
                        End
                    End;
                End
            else
            If ArDFNRemoto[J].GrupoAuto Then
              Begin
                Prima := True;

                For I := 0 To Length(ArGrupoRemoto) - 1 Do
                  If (ArDFNRemoto[J].CodSis = ArGrupoRemoto[I].CodSis) And PodeIncluir(J, ArDFNRemoto[J].CodSis, ArGrupoRemoto[I].CodGrupo) Then
                    Begin
                      For II := 0 To Length(ArSisRemoto)-1 Do  // Achar o nome do Sistema
                        If (ArSisRemoto[II].CodSis = ArDFNRemoto[J].CodSis) Then
                          Break;

                      For K := 0 To Length(ArSubGrupoRemoto)-1 Do  // Achar o nome do SubGrupo
                        If (ArSubGrupoRemoto[K].CodGrupo = ArDFNRemoto[J].CodGrupo) And
                           (ArSubGrupoRemoto[K].CodSubGrupo = ArDFNRemoto[J].CodSubGrupo) Then
                          Break;

                      If Prima Then
                        Begin
                          RelRoot := AssisAbreRemotoForm.TreeView1.Items.Add(RelRoot,ArDFNRemoto[J].CodRel);
                          AssisAbreRemotoForm.TreeView1.Items.AddChild(RelRoot,'  '+ArSubGrupoRemoto[K].NomeSubGrupo+ ' ' +
                                                                       ArSisRemoto[II].NomeSis);
                          Prima := False;
                        End;

                      With AssisAbreRemotoForm.TreeView1.Items Do
                        If ArGrupoRemoto[I].CodGrupo < 0 Then
                          AddChild(RelRoot,Format('%3.3d',[ArGrupoRemoto[I].CodGrupo])+' - '+ArGrupoRemoto[I].NomeGrupo)
                        Else
                          AddChild(RelRoot,' '+Format('%3.3d',[ArGrupoRemoto[I].CodGrupo])+' - '+ArGrupoRemoto[I].NomeGrupo);
                    End
              End
            Else
              If PodeIncluir(J, ArDFNRemoto[J].CodSis, ArDFNRemoto[J].CodGrupo) Then
                With AssisAbreRemotoForm.TreeView1.Items Do
                  Begin
                    For II := 0 To Length(ArSisRemoto)-1 Do  // Achar o nome do Sistema
                      If (ArSisRemoto[II].CodSis = ArDFNRemoto[J].CodSis) Then
                        Break;

                    For I := 0 To Length(ArGrupoRemoto)-1 Do  // Achar o nome do grupo
                      If ArGrupoRemoto[I].CodGrupo = ArDFNRemoto[J].CodGrupo Then
                        Break;

                    For K := 0 To Length(ArSubGrupoRemoto)-1 Do  // Achar o nome do SubGrupo
                      If (ArSubGrupoRemoto[K].CodGrupo = ArDFNRemoto[J].CodGrupo) And
                         (ArSubGrupoRemoto[K].CodSubGrupo = ArDFNRemoto[J].CodSubGrupo) Then
                        Break;

                    RelRoot := AssisAbreRemotoForm.TreeView1.Items.Add(RelRoot,ArDFNRemoto[J].CodRel);
                    AssisAbreRemotoForm.TreeView1.Items.AddChild(RelRoot,'  ' +
                                                                 ArSubGrupoRemoto[K].NomeSubGrupo + ' ' +
                                                                 ArSisRemoto[II].NomeSis);

                    If ArDFNRemoto[J].CodGrupo < 0 Then
                      AddChild(RelRoot,Format('%3.3d',[ArDFNRemoto[J].CodGrupo]) +
                                                      ' - ' +
                                                      ArGrupoRemoto[I].NomeGrupo)
                    Else
                      AddChild(RelRoot,' '+Format('%3.3d',[ArDFNRemoto[J].CodGrupo]) +
                                                          ' - ' +
                                                          ArGrupoRemoto[I].NomeGrupo);

                  End;
            End;
        end;

      AssisAbreRemotoForm.TreeView1.SortType := stText;
      Avisop.Close;
      AssisAbreRemotoForm.ListBox2.Clear;
      ConectouRemoto := True;

    End;

  If AssisAbreFlg Then
    Begin
      AssisAbreRemotoForm.Align := alNone;
      AssisAbreRemotoForm.Top := AssisAbreForm.Top;
      AssisAbreRemotoForm.Left := AssisAbreForm.Left;
      AssisAbreRemotoForm.Width := AssisAbreForm.Width;
      AssisAbreRemotoForm.Height := AssisAbreForm.Height;
    End;

  Tela := 'AssisAbreRemoto';
  AssisAbreRemotoForm.Show;

End;

Procedure TFrameForm.Fechar1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
TEditForm(ActiveMdiChild).Close;
End;

Procedure TFrameForm.ConfigurarImpressora1Click(Sender: TObject);
Begin
PrinterSetupDialog1.Execute;
End;

procedure TFrameForm.ConsultarStatusProcessamento1Click(Sender: TObject);
begin
  if Trim(LogInRemotoForm.UsuEdit.Text) <> '' then
  begin
    FrmConsultaExportacoesRemoto.SetParameters(LogInRemotoForm.UsuEdit.Text, ObterUrlBase);
    FrmConsultaExportacoesRemoto.Show;
  end else
    MessageDlg('É necessário estar no modo remoto para abrir esse formulário.', mtInformation, [mbOK], 0);
end;

procedure TFrameForm.ConfigurarFontedeImpresso1Click(Sender: TObject);
Var
  ArqX : System.Text;
  Linha : ShortString;
  X : Set Of TFontStyle;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  FontDialog1.Font := Printer.Canvas.Font;
  If FontDialog1.Execute Then
    Begin
    Printer.Canvas.Font := FontDialog1.Font;
    If PathCfg = 'FAIOU' Then
      Exit;
    AssignFile(ArqX,PathCfg+'Printer.Cfg');
    {$i-}
    Rewrite(ArqX);
    {$i+}
    If IoResult = 0 Then
      Begin
      WriteLn(ArqX,Printer.Canvas.Font.Name);
      WriteLn(ArqX,Printer.Canvas.Font.Size);
      X := Printer.Canvas.Font.Style;
      Move(X,Linha[1],SizeOf(X));
      SetLength(Linha,SizeOf(X));
      WriteLn(ArqX,Linha);
      CloseFile(ArqX);
      End;
    End;
  End;
End;

Procedure TFrameForm.CopiarPgina1Click(Sender: TObject);
Var
  Linha : ShortString;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  Reset(ArqImp);
  MemoAux.Lines.Clear;
  While Not Eof(ArqImp) Do
    Begin
    ReadLn(ArqImp,Linha);
    If Linha[1] = AnsiChar(1) Then  { é uma linha marcada }
      Delete(Linha,1,1);
    MemoAux.Lines.Add(Linha);
    End;
  CloseFile(ArqImp);
  MemoAux.SelStart := 0;
  MemoAux.SelLength := Length(MemoAux.Lines.Text)-1;
  MemoAux.CopyToClipBoard;
  End;
End;

Procedure TFrameForm.ConfigurarFontedeVdeo1Click(Sender: TObject);
Var
  ArqX : System.Text;
  Linha : ShortString;
  X : Set Of TFontStyle;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  FontDialog1.Font := Video;
  If FontDialog1.Execute Then
    Begin
    Video := FontDialog1.Font;
    Memo1.Font := FontDialog1.Font;
//    CarregaImagem(RegPag64,MarcaAtu,PaginaAtu);
    CarregaImagem(MarcaAtu,PaginaAtu);
    AssignFile(ArqX,PathCfg+'Video.Cfg');
    {$i-}
    Rewrite(ArqX);
    {$i+}
    If IoResult = 0 Then
      Begin
      WriteLn(ArqX,Video.Name);
      WriteLn(ArqX,Video.Size);
      X := FontDialog1.Font.Style;
      Move(X,Linha[1],SizeOf(X));
      SetLength(Linha,SizeOf(X));
      WriteLn(ArqX,Linha);
      CloseFile(ArqX);
      End;
    End;
  End;  
End;

Procedure TFrameForm.ConfigurarCordoFundo1Click(Sender: TObject);
Var
  ArqX : System.Text;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  If ColorDialog1.Execute Then
    Begin
    Cor := ColorDialog1.Color;
//    CarregaImagem(RegPag64,MarcaAtu,PaginaAtu);
    CarregaImagem(MarcaAtu,PaginaAtu);
    AssignFile(ArqX,PathCfg+'Color.Cfg');
    {$i-}
    Rewrite(ArqX);
    {$i+}
    If IoResult = 0 Then
      Begin
      WriteLn(ArqX,Cor);
      CloseFile(ArqX);
      End;
    End;
  End;
End;

Procedure TFrameForm.ModoTexto1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  If ModoTexto1.Checked Then
    Begin
    Memo1.Visible := False;
    DFActiveDisplay1.Visible := False;  // Have to control visual do com formulário.....
    ScrollBox1.Visible := True;
    Image1.Visible := True;
    ModoTexto1.Checked := False;
    MemoPopUp.Items[2].Checked := False;
    Label3.Caption := '';
    End
  Else
    Begin
    DFActiveDisplay1.Visible := False;
    ScrollBox1.Visible := False;
    Memo1.Visible := True;
    ModoTexto1.Checked := True;
    MemoPopUp.Items[2].Checked := True;
    End;
  Screen.Cursor := crHourGlass;
  CarregaImagem(MarcaAtu,PaginaAtu);
  Screen.Cursor := crDefault;
  End;
End;

Procedure TFrameForm.CopiarTextoSelecionado1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  Memo1.CopyToClipboard;
  End;
End;

Procedure TFrameForm.Prxima1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar1.Position < ScrollBar1.Max Then
  Begin
  ScrollBar1.Position := ScrollBar1.Position + 1;
  Scrolla1;
  End;
End;

Procedure TFrameForm.Anterior1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar1.Position > ScrollBar1.Min Then
  Begin
  ScrollBar1.Position := ScrollBar1.Position - 1;
  Scrolla1;
  End;
End;

Procedure TFrameForm.Prxima2Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar2.Position < ScrollBar2.Max Then
  Begin
  ScrollBar2.Position := ScrollBar2.Position + 1;
  Scrolla2;
  End;
End;

Procedure TFrameForm.Anterior2Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar2.Position > ScrollBar2.Min Then
  Begin
  ScrollBar2.Position := ScrollBar2.Position - 1;
  Scrolla2;
  End;
End;

Procedure TFrameForm.ExtrairSpeedButtonClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
AssisAbreForm.Close;
AssisAbreRemotoForm.Close;
AbriuArqDsc := False;
Primeiro := True;
Especial.FechaEspecial;
FrmExtract.Show;
End;

Procedure TFrameForm.FormActivate(Sender: TObject);
Begin
  if (FormGeral.SemServidor) and (not FormGeral.ModoOff)  then
  begin
    close;
    Application.Terminate;
    exit;
  end;
  if FormGeral.ModoOff then
  begin
    MainMenu1.Items.Items[0].Items[1].Enabled := False;
    MainMenu1.Items.Items[0].Items[2].Enabled := False;
    MainMenu1.Items.Items[3].Enabled := False;
    MainMenu1.Items.Items[4].Enabled := False;
  end;

  If (not JaAbriu) and (not FormGeral.ModoOff) Then
    begin

      if Tela <> '' Then
        Exit;

      FaiouAbrAssistidoLocal := True;
      AbrirRemoto1.Click;
      FaiouAbrAssistidoLocal := false;
      {
      Try
        if FormGeral.DatabaseMultiCold.Connected then
          begin
            FormGeral.TableDFN.Open;
            FormGeral.TableDFN.Close;
            //    AbrirAssistido1.Click;
            AbrirRemoto1.Click;
            //    Tela := 'AssisAbreLocal';
            FaiouAbrAssistidoLocal := false;
          end;
      Except

      End; // Try
      }
    end;

  JaAbriu := True;
End;

Procedure TFrameForm.mScreenWidthClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  LastScale:= Sender;
  If Sender = mScreenHeight Then
    Begin
    mScreenHeight.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,'PH');
    End;
  If Sender = mScreenWidth Then
    Begin
    mScreenWidth.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,'PW');
    End;
  If Sender = m200 Then
    Begin
    m200.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,200);
    End;
  If Sender = m150 Then
    Begin
    m150.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,150);
    End;
  If Sender = m100 Then
    Begin
    m100.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,100);
    End;
  If Sender = m75 Then
    Begin
    m75.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,75);
    End;
  If Sender = m50 Then
    Begin
    m50.checked:= true;
    DFActiveDisplay1.AlignToScrollBox(ScrollBox1,50);
    End;
  End; // With 
End;

Procedure TFrameForm.Timer1Timer(Sender: TObject);
Begin
Exit;  // Estamos desligando o timer de 10 minutos que termina a aplicação...
Application.Terminate;
End;

Procedure TFrameForm.EditPagChange(Sender: TObject);
Begin
VaiPesquisa.Default := False;
VaiPagina.Default := True;
End;

Procedure TFrameForm.EditPesChange(Sender: TObject);
Begin
VaiPagina.Default := False;
VaiPesquisa.Default := True;
End;

Procedure TFrameForm.Especial1Click(Sender: TObject);
Begin
Especial.Show;
End;

Procedure TFrameForm.Localizar1Click(Sender: TObject);
Begin
Localizar.Proximo := false;
Localizar.Show;
End;

Procedure TFrameForm.LocalizarPrxima1Click(Sender: TObject);
Begin
Localizar.Proximo := true;
Localizar.Show;
Localizar.LocProxBut.Click;
End;

Procedure TFrameForm.AnotarGraphSpeedButtonClick(Sender: TObject);
//Var
//  OldBrush : TBrushStyle;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  
  If ZoomLevel <> 0 Then
    Begin
    ShowMessage('Volte ao zoom "normal" para anotar...');
    Exit;
    End;

  If (FezAnotacoesGraficas = False) And (TemAnotacaoGrafica = False) Then
    TrataImage2(Image1.Width, Image1.Height);

  FezAnotacoesGraficas := True;

{    Begin
    OldBrush := Image2.Canvas.Brush.Style;
    Image2.Width := Image1.Width;
    Image2.Height := Image1.Height;
    Image2.Picture.Bitmap.Width := Image2.Width;
    Image2.Picture.Bitmap.Height := Image2.Height;

    Image2.Canvas.Brush.Color := clWhite;
    Image2.Canvas.FillRect(Rect(0, 0, Image2.Width,Image2.Height));
    Image2.Canvas.Brush.Style := OldBrush; 
    End; }

  Image2.Visible := True;
  Image2.BringToFront;

  AnotaForm.SaveStyles;
  AnotaForm.ShowModal;
  End;
End;

Procedure TFrameForm.AnotarTextoSpeedButtonClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  AnotaTextoForm.ShowModal;
  End;
End;

Procedure TFrameForm.Animate1Click(Sender: TObject);
Begin
  TEditForm(ActiveMdiChild).AnotaTextoForm.ShowModal;
End;

Procedure TFrameForm.MoveDFActiveParaImage1;

Begin
  TEditForm(ActiveMdiChild).Image1.Left := 0;
  TEditForm(ActiveMdiChild).Image1.Top := 0;
  TEditForm(ActiveMdiChild).Image1.Width := TEditForm(ActiveMdiChild).DFEngine1.Pages[0].Width;
  TEditForm(ActiveMdiChild).Image1.Height := TEditForm(ActiveMdiChild).DFEngine1.Pages[0].Height;
  TEditForm(ActiveMdiChild).Image1.Picture.Bitmap.Width := TEditForm(ActiveMdiChild).DFEngine1.Pages[0].Width;
  TEditForm(ActiveMdiChild).Image1.Picture.Bitmap.Height := TEditForm(ActiveMdiChild).DFEngine1.Pages[0].Height;

  TEditForm(ActiveMdiChild).DFEngine1.Pages[0].PaintTo(TEditForm(ActiveMdiChild).Image1.Canvas,
                                                       TEditForm(ActiveMdiChild).Image1.Canvas.ClipRect);
End;

Procedure TFrameForm.MostraAsImagens;

Begin

  MoveDFActiveParaImage1;

  TEditForm(ActiveMdiChild).Image2.Height := TEditForm(ActiveMdiChild).Image1.Height;
  TEditForm(ActiveMdiChild).Image2.Picture.Bitmap.Height := TEditForm(ActiveMdiChild).Image1.Height;

  TEditForm(ActiveMdiChild).DFActiveDisplay1.SendToBack;
  TEditForm(ActiveMdiChild).DFActiveDisplay1.Left := 0;
  TEditForm(ActiveMdiChild).DFActiveDisplay1.Top := 0;
  TEditForm(ActiveMdiChild).DFActiveDisplay1.Width := 0;
  TEditForm(ActiveMdiChild).DFActiveDisplay1.Height := 0;

  TEditForm(ActiveMdiChild).Image1.Visible := True;
  TEditForm(ActiveMdiChild).Image1.BringToFront;
  TEditForm(ActiveMdiChild).Image2.Visible := True;
  TEditForm(ActiveMdiChild).Image2.BringToFront;
End;

Procedure TFrameForm.Animate2Click(Sender: TObject);
Begin
If TEditForm(ActiveMdiChild).Image2.Visible Then
  TEditForm(ActiveMdiChild).AnotaForm.ShowModal
Else
  Begin
  MostraAsImagens;
  End;

End;

End.
