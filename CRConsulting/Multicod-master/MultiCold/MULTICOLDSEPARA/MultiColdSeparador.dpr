program MultiColdSeparador;

uses
  Vcl.Forms,
  SysUtils,
  Index in 'Index.pas' {FormIndex},
  Sugeral in '..\Sugeral.pas' {FormGeral},
  ConfigProc in '..\ConfigProc.pas' {Config},
  SuTypGer in '..\..\Subrug\SuTypGer.pas',
  SuTypMultiCold in '..\..\Subrug\SuTypMultiCold.pas',
  Subrug in '..\..\Subrug\Subrug.pas',
  Pilha in '..\..\CR CONSULTING\Pilha.pas',
  Avisoi in '..\Avisoi.pas' {AvisoP};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormIndex, FormIndex);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TConfig, Config);
  Application.CreateForm(TAvisoP, AvisoP);
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
