Program MasterColdAdm;

uses
  Dialogs,
  Forms,
  Qhelpu in 'QHelpU.pas' {QHelp},
  Analisador in 'Analisador.pas' {DefReport},
  AltCasGrp in 'AltCasGrp.pas' {AltCasGrupForm},
  AltCasSGrp in 'AltCasSGrp.pas' {AltCasSGForm},
  LogInU in 'LogInU.pas' {LogInForm},
  InfoImpDfnU in 'InfoImpDfnU.pas' {GetInfoImpDFNForm},
  MapaFilU in 'MapaFilU.pas' {MapaFil},
  Sugeral in 'Sugeral.pas' {FormGeral},
  SuTypGer in '..\Subrug\SuTypGer.pas',
  SuBrug in '..\Subrug\Subrug.pas',
  ZLibEx in '..\Subrug\DelphiZLib\ZLIBEX.PAS',
  RelatoUnit in 'RelatoUnit.pas' {RelatoForm};

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TDefReport, DefReport);
  Application.CreateForm(TQHelp, QHelp);
  Application.CreateForm(TAltCasGrupForm, AltCasGrupForm);
  Application.CreateForm(TAltCasSGForm, AltCasSGForm);
  Application.CreateForm(TLogInForm, LogInForm);
  Application.CreateForm(TGetInfoImpDFNForm, GetInfoImpDFNForm);
  Application.CreateForm(TMapaFil, MapaFil);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TRelatoForm, RelatoForm);
  LogInForm.ShowModal;
  If Not (LogInForm.Grupo = 'ADMSIS') Then
    Begin
    ShowMessage('Usuário não administrador, acesso negado');
    Application.Terminate;
    End;

  Application.Run;
End.
