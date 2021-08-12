Program MultiColdFiltro;

uses
  SysUtils,
  Forms,
  CtrlFiltro in 'CtrlFiltro.pas' {FormCtrlFiltro},
  Sutypger in '..\Subrug\Sutypger.pas',
  Subrug in '..\Subrug\Subrug.pas',
  ConfigProc in 'ConfigProc.pas' {Config},
  FiltroProc in 'FiltroProc.pas' {FormFiltro},
  Sugeral in 'Sugeral.pas' {FormGeral},
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  Pilha in '..\CR CONSULTING\Pilha.pas';

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TFormCtrlFiltro, FormCtrlFiltro);
  Application.CreateForm(TConfig, Config);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TFormFiltro, FormFiltro);
  FormGeral.LerIni;                   // Faz uma carga inicial dos dados...
  Config.CarregaDados;

  If viExecAutoSN = 'S' Then
    Begin
    FormCtrlFiltro.StatusBar1.SimpleText := 'Aguardando Início da Execução Automática';
    FormCtrlFiltro.Timer1.Interval := StrToInt(Trim(viInterExecSeg))*1000;
    FormCtrlFiltro.Timer1.Enabled := True;
    End
  Else
    FormCtrlFiltro.StatusBar1.SimpleText := 'Aguardando Instrução de Início de Processamento';

  ControleFiltro := 'A';

  Application.Run;
End.
