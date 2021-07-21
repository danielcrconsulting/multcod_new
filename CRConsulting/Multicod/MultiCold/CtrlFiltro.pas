{

 Unit Principal do programa de filtragem - Sistema MultiCold

 r6 20/12/2001 - Renomeia o arquivo a ser filtrado antes de abrir para processar
    26/12/2001 - Procura o arquivo pelo nome original, se não achar, procura pelo prefixo...

 v 6.2.0.1 27/11/2011
 Tirei o ponteiro e a manipulação de endereços, virou array normal

 v 6.2.0.2 09/01/2014
 Antes de novo ciclo de filtragens fecha as conexões com os BDs e as reabre

 v 6.2.0.3 14/01/2014
 Fecha as conexões após os procedimentos iniciais
 Antes de novo ciclo de filtragens reabre as conexões com os BDs e as fecha

  v 6.2.0.4 15/01/2014
 Finalmente percebi que havia um FormCreate dentro da rotina disparada pelo Timer
 o que, depois de um certo tempo, terminava por CRASHar o programa!!!!

 v 6.3.0.0 07/02/2014
 Agora filtra no mesmo arquivo de leitura: lê, então grava se necessário. Ao final move, senão copia.

 }

Unit CtrlFiltro;

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, SuTypGer, Zlib,
  Buttons, DB, ExtCtrls, Menus,
  OleCtrls, ComCtrls, ImgList, ToolWin;

Type
  TFormCtrlFiltro = Class(TForm)
    SairSpeedButton: TSpeedButton;
    ProcessarSpeedButton: TSpeedButton;
    FiltrarSpeedButton: TSpeedButton;
    ConfigProcSpeedButton: TSpeedButton;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Indexar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Configuraes1: TMenuItem;
    FiltrodeArquivos1: TMenuItem;
    Processamento1: TMenuItem;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Procedure FormCreate(Sender: TObject);
    Procedure SairSpeedButtonClick(Sender: TObject);
    Procedure ProcessarSpeedButtonClick(Sender: TObject);
    Procedure FiltrodeArquivos1Click(Sender: TObject);
    Procedure Processamento1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormCtrlFiltro: TFormCtrlFiltro;

Implementation

Uses ConfigProc, FileCtrl, IniFiles, SuGeral, Subrug,
  FiltroProc;

{$R *.DFM}

Procedure TFormCtrlFiltro.FormCreate(Sender: TObject);
Begin
If ParamCount <> 0 Then
  WindowState := wsMinimized;
End;

Procedure TFormCtrlFiltro.SairSpeedButtonClick(Sender: TObject);
Begin
Close;
End;

Procedure TFormCtrlFiltro.ProcessarSpeedButtonClick(Sender: TObject);
Var
  Processou : Boolean;

  Procedure LimpaMensagens;
  Begin
  If viExecAutoSN = 'S' Then
    StatusBar1.SimpleText := 'Aguardando Início da Execução Automática'
  Else
    StatusBar1.SimpleText := 'Aguardando Instrução de Início de Processamento';
  Application.ProcessMessages;
  End;

Begin
Timer1.Enabled := False;

//Application.CreateForm(TFormFiltro, FormFiltro);
//FormFiltro.Show;

Agora := Now;  // Determina o Espaço tempo necessário...

Processou := False;

Screen.Cursor := crHourGlass;
StatusBar1.SimpleText := 'Filtrando Relatórios...';
Application.ProcessMessages;

FormGeral.DatabaseMulticold.Open;
FormGeral.DatabaseEventos.Open;
FormGeral.DatabaseLog.Open;

FormGeral.LerIni; // Carrega os dados para pegar alguma modificação feita no ADM...
Config.CarregaDados;

FormFiltro.Show;
FormFiltro.DispararButton.Click;
FormFiltro.Close;

FormGeral.DatabaseMulticold.Close;
FormGeral.DatabaseEventos.Close;
FormGeral.DatabaseLog.Close;

Screen.Cursor := crDefault;

If viExecAutoSN = 'S' Then
  Begin
  If Processou Then    // Significa que algum relatório foi processado, volta para processar mais;
    Timer1.Interval := 1000
  Else
    Timer1.Interval := StrToInt(Trim(viInterExecSeg))*1000;
  LimpaMensagens;
  Timer1.Enabled := True;
  End
Else
  Begin
  ShowMessage('Fim de Filtragem');
  LimpaMensagens;
  End;

End;

Procedure TFormCtrlFiltro.FiltrodeArquivos1Click(Sender: TObject);
Begin
Timer1.Enabled := False;
StatusBar1.SimpleText := 'Aguardando fechamento da janela de Configurações do Filtro';
ControleFiltro := ' ';
Application.ProcessMessages;
FormFiltro.ShowModal;
If viExecAutoSN = 'S' Then
  Begin
  FormCtrlFiltro.StatusBar1.SimpleText := 'Aguardando Início da Execução Automática';
  FormCtrlFiltro.Timer1.Enabled := True;
  End
Else
  FormCtrlFiltro.StatusBar1.SimpleText := 'Aguardando Instrução de Início de Processamento';
ControleFiltro := 'A';
Application.ProcessMessages;
End;

Procedure TFormCtrlFiltro.Processamento1Click(Sender: TObject);
Begin
Timer1.Enabled := False;
StatusBar1.SimpleText := 'Aguardando fechamento da janela de Configurações de Processamento';
Application.ProcessMessages;
Config.ShowModal;
If viExecAutoSN = 'S' Then
  Begin
  FormCtrlFiltro.StatusBar1.SimpleText := 'Aguardando Início da Execução Automática';
  FormCtrlFiltro.Timer1.Enabled := True;
  End
Else
  FormCtrlFiltro.StatusBar1.SimpleText := 'Aguardando Instrução de Início de Processamento';
Application.ProcessMessages;
End;

Procedure TFormCtrlFiltro.FormClose(Sender: TObject;
  var Action: TCloseAction);
Begin
FormGeral.DatabaseMultiCold.Close;
FormGeral.DatabaseLog.Close;
End;

End.
