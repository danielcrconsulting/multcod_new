program MultiColdSeparador;

uses
  Forms,
  SysUtils,
  Sugeral in '..\Sugeral.pas' {FormGeral},
  SuTypGer in '..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\Subrug\SuTypMultiCold.pas',
  Subrug in '..\..\Subrug\Subrug.pas',
  Pilha in '..\..\CR CONSULTING\Pilha.pas',
  Avisoi in '..\Avisoi.pas' {AvisoP},
  ConfigProc in '..\ConfigProc.pas' {Config},
  CtrlFiltro in '..\CtrlFiltro.pas' {FormCtrlFiltro},
  FiltroProc in '..\FiltroProc.pas' {FormFiltro},
  Separex in 'Separex.pas' {FormIndex};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TAvisoP, AvisoP);
  Application.CreateForm(TConfig, Config);
  Application.CreateForm(TFormIndex, FormIndex);
  //  Application.CreateForm(TFormCtrlFiltro, FormCtrlFiltro);
//  Application.CreateForm(TFormFiltro, FormFiltro);
  FormGeral.LerIni;
  Config.CarregaDados;

  If viExecAutoSN = 'S' Then
    Begin
    FormIndex.StatusBar1.Panels[1].Text := 'Aguardando Início da Execução Automática';
    FormIndex.Timer1.Interval := 1*1000; // No arranque aguarda 1 segundo apenas... fast start
    FormIndex.Timer1.Enabled := True;
    End
  Else
    FormIndex.StatusBar1.Panels[1].Text := 'Aguardando Instrução de Início de Processamento';

  Application.Run;
end.