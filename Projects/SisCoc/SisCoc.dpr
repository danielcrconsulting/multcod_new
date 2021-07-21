program SisCoc;

{$R *.res}

uses
  VBto_Converter in 'VBto_Converter.pas',
  frmNaoLib_ in 'frmNaoLib_.pas' {frmNaoLib},
  DataDeAte_ in 'DataDeAte_.pas' {DataDeAte},
  ConsultaCvMes_ in 'ConsultaCvMes_.pas' {ConsultaCvMes},
  frmPath_ in 'frmPath_.pas' {frmPath},
  DataGerArq_ in 'DataGerArq_.pas' {DataGerArq},
  frmAbout_ in 'frmAbout_.pas' {frmAbout},
  TipoConAdm_ in 'TipoConAdm_.pas' {TipoConAdm},
  Historico_ in 'Historico_.pas' {Historico},
  Alterar_Consulta_ in 'Alterar_Consulta_.pas' {Alterar_Consulta},
  ConsultaCon_ in 'ConsultaCon_.pas' {ConsultaCon},
  AlterarManual_ in 'AlterarManual_.pas' {AlterarManual},
  frmMes1_ in 'frmMes1_.pas' {frmMes1},
  TipoCon_ in 'TipoCon_.pas' {TipoCon},
  frmRelease_ in 'frmRelease_.pas' {frmRelease},
  frmBaixaBanco_ in 'frmBaixaBanco_.pas' {frmBaixaBanco},
  NovoClienteAlt_ in 'NovoClienteAlt_.pas' {NovoClienteAlt},
  frmAgenda1_ in 'frmAgenda1_.pas' {frmAgenda1},
  frmAgenda_ in 'frmAgenda_.pas' {frmAgenda},
  Alterar1Manual_ in 'Alterar1Manual_.pas' {Alterar1Manual},
  frmGeraMov_ in 'frmGeraMov_.pas' {frmGeraMov},
  frmLog_ in 'frmLog_.pas' {frmLog},
  frmMes_ in 'frmMes_.pas' {frmMes},
  frmJuncao_ in 'frmJuncao_.pas' {frmJuncao},
  DataLimite_ in 'DataLimite_.pas' {DataLimite},
  Consulta_ in 'Consulta_.pas' {Consulta},
  atMoeda_ in 'atMoeda_.pas' {atMoeda},
  RotGerais in 'RotGerais.pas',
  SimulaMenu_ in 'SimulaMenu_.pas' {SimulaMenu},
  DataMov_ in 'DataMov_.pas' {DataMov},
  NovoCliente_ in 'NovoCliente_.pas' {NovoCliente},
  PBar_ in 'PBar_.pas' {PBar},
  Periodo_ in 'Periodo_.pas' {Periodo},
  Incluir_ in 'Incluir_.pas' {Incluir},
  TelaInicial_ in 'TelaInicial_.pas' {TelaInicial},
  frmLogin_ in 'frmLogin_.pas' {frmLogin},
  frmMain_ in 'frmMain_.pas' {fMainForm},
  Module1 in 'Module1.pas',
  Forms,
  DataModuleFormUnit in 'DataModuleFormUnit.pas' {DataModule},
  Subrug in '..\Subrug\Subrug.pas',
  Pilha in '..\CR CONSULTING\Pilha.pas',
  SuTypGer in '..\Subrug\SuTypGer.pas',
  PedeAlteraca in 'PedeAlteraca.pas' {PedeAlteracao};

begin
  Application.Initialize;
  Application.Title := 'Conciliação de Contas';
  Application.CreateForm(TTelaInicial, TelaInicial);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfMainForm, fMainForm);
  Application.CreateForm(TPedeAlteracao, PedeAlteracao);
  Application.CreateForm(TIncluir, Incluir);
  Application.CreateForm(TPeriodo, Periodo);
  Application.CreateForm(TPBar, PBar);
  Application.CreateForm(TNovoCliente, NovoCliente);
  Application.CreateForm(TDataMov, DataMov);
  Application.CreateForm(TSimulaMenu, SimulaMenu);
  Application.CreateForm(TatMoeda, atMoeda);
  Application.CreateForm(TConsulta, Consulta);
  Application.CreateForm(TDataLimite, DataLimite);
  Application.CreateForm(TfrmJuncao, frmJuncao);
  Application.CreateForm(TfrmMes, frmMes);
  Application.CreateForm(TfrmLog, frmLog);
  Application.CreateForm(TfrmGeraMov, frmGeraMov);
  Application.CreateForm(TAlterar1Manual, Alterar1Manual);
  Application.CreateForm(TfrmAgenda, frmAgenda);
  Application.CreateForm(TfrmAgenda1, frmAgenda1);
  Application.CreateForm(TNovoClienteAlt, NovoClienteAlt);
  Application.CreateForm(TfrmBaixaBanco, frmBaixaBanco);
  Application.CreateForm(TfrmRelease, frmRelease);
  Application.CreateForm(TTipoCon, TipoCon);
  Application.CreateForm(TfrmMes1, frmMes1);
  Application.CreateForm(TAlterarManual, AlterarManual);
  Application.CreateForm(TConsultaCon, ConsultaCon);
  Application.CreateForm(TAlterar_Consulta, Alterar_Consulta);
  Application.CreateForm(THistorico, Historico);
  Application.CreateForm(TTipoConAdm, TipoConAdm);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TDataGerArq, DataGerArq);
  Application.CreateForm(TfrmPath, frmPath);
  Application.CreateForm(TConsultaCvMes, ConsultaCvMes);
  Application.CreateForm(TDataDeAte, DataDeAte);
  Application.CreateForm(TfrmNaoLib, frmNaoLib);
  Application.CreateForm(TDataModule, DataModule);
  Application.Run;
end.
