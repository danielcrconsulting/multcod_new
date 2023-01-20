{

 Unit Principal do programa de filtragem - Sistema MasterCold

}

Unit CtrlFiltro;

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, SuTypGer, 
  Buttons, DB, DBTables, ExtCtrls, Menus,
  OleCtrls, ComCtrls;

Type
  TFormCtrlFiltro = Class(TForm)
    SairSpeedButton: TSpeedButton;
    ProcessarSpeedButton: TSpeedButton;
    FiltrarSpeedButton: TSpeedButton;
    ConfigProcSpeedButton: TSpeedButton;
    Label2: TLabel;
    Edit1: TEdit;
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
    Label1: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure SairSpeedButtonClick(Sender: TObject);
    Procedure ProcessarSpeedButtonClick(Sender: TObject);
    Procedure FiltrodeArquivos1Click(Sender: TObject);
    Procedure Processamento1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FormCtrlFiltro: TFormCtrlFiltro;

Implementation

Uses ConfigProc, IniFiles, Analisador, SuGeral, Subrug,
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
  If Config.ExecAutoEdit.Text = 'S' Then
    Edit1.Text := 'Aguardando In�cio da Execu��o Autom�tica'
  Else
    Edit1.Text := 'Aguardando Instru��o de In�cio de Processamento';
  Application.ProcessMessages;
  End;

Begin
Timer1.Enabled := False;

Agora := Now;  // Determina o Espa�o tempo necess�rio...

Processou := False;

Screen.Cursor := crHourGlass;
Edit1.Text := 'Filtrando Relat�rios...';
Application.ProcessMessages;

//DefReport.TableLogProc.Open;

FormFiltro.BorderIcons := [];
Semaforo := False;
FormFiltro.Show;
FormFiltro.Button1.Click;
While Not Semaforo Do;
FormFiltro.Close;
FormFiltro.BorderIcons := [biSystemMenu, biMinimize, biMaximize];

//DefReport.TableLogProc.Close;

Screen.Cursor := crDefault;

If Config.ExecAutoEdit.Text = 'S' Then
  Begin
  If Processou Then    // Significa que algum relat�rio foi processado, volta para processar mais;
    Timer1.Interval := 1000
  Else
    Timer1.Interval := StrToInt(Trim(Config.Edit2.Text))*1000;
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
Edit1.Text := 'Aguardando fechamento da janela de Configura��es do Filtro';
Application.ProcessMessages;
FormFiltro.ShowModal;
If Config.ExecAutoEdit.Text = 'S' Then
  Begin
  Edit1.Text := 'Aguardando In�cio da Execu��o Autom�tica';
  Timer1.Enabled := True;
  End
Else
  Edit1.Text := 'Aguardando Instru��o de In�cio de Processamento';
Application.ProcessMessages;
End;

Procedure TFormCtrlFiltro.Processamento1Click(Sender: TObject);
Begin
Timer1.Enabled := False;
Edit1.Text := 'Aguardando fechamento da janela de Configura��es de Processamento';
Application.ProcessMessages;
Config.ShowModal;
If Config.ExecAutoEdit.Text = 'S' Then
  Begin
  Edit1.Text := 'Aguardando In�cio da Execu��o Autom�tica';
  Timer1.Enabled := True;
  End
Else
  Edit1.Text := 'Aguardando Instru��o de In�cio de Processamento';
Application.ProcessMessages;
End;

End.
