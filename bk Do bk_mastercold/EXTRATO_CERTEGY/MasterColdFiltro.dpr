Program MasterColdFiltro;

uses
  SysUtils,
  Forms,
  CtrlFiltro in 'CtrlFiltro.pas' {FormCtrlFiltro},
  Analisador in 'Analisador.pas' {DefReport},
  MapaFilU in 'MapaFilU.pas' {MapaFil},
  ConfigProc in 'ConfigProc.pas' {Config},
  FiltroProc in 'FiltroProc.pas' {FormFiltro},
  Sugeral in 'Sugeral.pas' {FormGeral},
  SuTypGer in '..\Multicold\Subrug\SuTypGer.pas',
  SuBrug in '..\Multicold\Subrug\Subrug.pas',
  ZLibEx in '..\Multicold\Subrug\DelphiZLib\ZLIBEX.PAS';

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TFormCtrlFiltro, FormCtrlFiltro);
  Application.CreateForm(TDefReport, DefReport);
  Application.CreateForm(TMapaFil, MapaFil);
  Application.CreateForm(TConfig, Config);
  Application.CreateForm(TFormFiltro, FormFiltro);
  Application.CreateForm(TFormGeral, FormGeral);
  If Config.ExecAutoEdit.Text = 'S' Then
    Begin
    FormCtrlFiltro.Edit1.Text := 'Aguardando Início da Execução Automática';
    FormCtrlFiltro.Timer1.Interval := StrToInt(Trim(Config.Edit2.Text))*1000;
    FormCtrlFiltro.Timer1.Enabled := True;
    End
  Else
    FormCtrlFiltro.Edit1.Text := 'Aguardando Instrução de Início de Processamento';

  ControleFiltro := 'F';
  
  Application.Run;
End.
