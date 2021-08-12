Program MultiColdIndexa;

//Revisado SQLServer...

uses
  Dialogs,
  SysUtils,
  Forms,
  Index in 'Index.pas' {FormIndex},
  SuTypGer in '..\Subrug\SuTypGer.pas',
  Subrug in '..\Subrug\Subrug.pas',
  ConfigProc in 'ConfigProc.pas' {Config},
  Sugeral in 'Sugeral.pas' {FormGeral},
  Separ in 'Separ.pas' {FormSepar},
  FiltroProc in 'FiltroProc.pas' {FormFiltro},
  Avisoi in 'Avisoi.pas' {AvisoP},
  MExtract in 'MExtract.pas' {FrmExtract},
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  MulticoldServerIntf in 'MulticoldServer\Soap\MulticoldServerIntf.pas',
  GraphWin in '..\Subrug\Anotation\GraphWin.pas' {AnotaForm},
  Mdiedit in 'Mdiedit.pas' {EditForm},
  MdiMultiCold in 'MdiMultiCold.pas' {FrameForm},
  Pilha in '..\CR CONSULTING\Pilha.pas';

{$R *.RES}

Begin

  Application.Initialize;
  Application.CreateForm(TFormIndex, FormIndex);
  Application.CreateForm(TFormSepar, FormSepar);
  Application.CreateForm(TConfig, Config);
  Application.CreateForm(TFormFiltro, FormFiltro);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TAvisoP, AvisoP);
  Application.CreateForm(TFrmExtract, FrmExtract);
  Application.CreateForm(TFrameForm, FrameForm);
  FormGeral.LerIni;
  Config.CarregaDados;

  If viExecAutoSN = 'S' Then
    Begin
    FormIndex.StatusBar1.Panels[1].Text := 'Aguardando Início da Execução Automática';
    FormIndex.Timer1.Interval := StrToInt(Trim(viInterExecSeg))*1000;
    FormIndex.Timer1.Enabled := True;
    End
  Else
    FormIndex.StatusBar1.Panels[1].Text := 'Aguardando Instrução de Início de Processamento';

  Application.Run;
End.
