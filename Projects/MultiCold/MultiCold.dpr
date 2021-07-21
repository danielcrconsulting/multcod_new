Program MultiCold;

uses
  Forms,
  MdiMultiCold in 'MdiMultiCold.pas' {FrameForm},
  Sutypger in '..\Subrug\Sutypger.pas',
  Subrug in '..\Subrug\Subrug.pas',
  AssisAbreRemoto in 'AssisAbreRemoto.pas' {AssisAbreRemotoForm},
  Avisoi in 'Avisoi.pas' {AvisoP},
  Sobre in 'Sobre.pas' {SobreForm},
  Conec in 'Conec.pas' {FormConec},
  Opera in 'Opera.pas' {FormOpera},
  QHelpU in 'QHelpU.pas' {QHelp},
  LogInForm in 'LogInForm.pas' {LogInRemotoForm},
  Mdiedit in 'Mdiedit.pas' {EditForm},
  Descom in 'Descom.pas' {FrmDescom},
  Gridque in 'Gridque.pas' {QueryDlg},
  Imprim in 'Imprim.pas' {FrmImprim},
  Scampo in 'Scampo.pas' {SelCampo},
  Template in 'Template.pas' {FrmTemplate},
  Sugeral in 'Sugeral.pas' {FormGeral},
  MExtract in 'MExtract.pas' {FrmExtract},
  AssisAbre in 'AssisAbre.pas' {AssisAbreForm},
  EspecialU in 'EspecialU.pas' {Especial},
  ExeEspecialU in 'ExeEspecialU.pas' {ExecutarEspecial},
  LocalizarU in 'LocalizarU.pas' {Localizar},
  StatusU in 'StatusU.pas' {StatusForm},
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  GraphWin in '..\Subrug\Anotation\GraphWin.pas' {AnotaForm},
  AnotaTextoU in 'AnotaTextoU.pas' {AnotaTextoForm},
  IMulticoldServer1 in 'IMulticoldServer1.pas',
  dfpdf in '..\Defined\Delphi7\dfpdf.pas',
  Pilha in '..\CR CONSULTING\Pilha.pas';

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TFrameForm, FrameForm);
  Application.CreateForm(TAssisAbreRemotoForm, AssisAbreRemotoForm);
  Application.CreateForm(TAvisoP, AvisoP);
  Application.CreateForm(TSobreForm, SobreForm);
  Application.CreateForm(TFormConec, FormConec);
  Application.CreateForm(TFormOpera, FormOpera);
  Application.CreateForm(TQHelp, QHelp);
  Application.CreateForm(TLogInRemotoForm, LogInRemotoForm);
  Application.CreateForm(TFrmDescom, FrmDescom);
  Application.CreateForm(TQueryDlg, QueryDlg);
  Application.CreateForm(TFrmImprim, FrmImprim);
  Application.CreateForm(TSelCampo, SelCampo);
  Application.CreateForm(TFrmTemplate, FrmTemplate);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TFrmExtract, FrmExtract);
  Application.CreateForm(TAssisAbreForm, AssisAbreForm);
  Application.CreateForm(TEspecial, Especial);
  Application.CreateForm(TExecutarEspecial, ExecutarEspecial);
  Application.CreateForm(TLocalizar, Localizar);
  Application.CreateForm(TStatusForm, StatusForm);
  //  Application.CreateForm(TAnotaForm, AnotaForm);
//  Application.CreateForm(TAnotaTextoForm, AnotaTextoForm);
  FrameForm.Inicializa;

//  FormGeral.CriarAliasDatabaseLocal;
//  FormGeral.CriarAliasEventos;
//  FormGeral.CriarAliasLog;

  Application.Run;
End.
