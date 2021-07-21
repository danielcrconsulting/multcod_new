Program MultiColdAtualizaCompila;

uses
  Forms,
  MdiMultiCold in 'MdiMultiCold.pas' {FrameForm},
  Analisador in 'Analisador.pas' {DefReport},
  SuTypGer in '..\Subrug\Sutypger.pas',
  SuBrug in '..\Subrug\Subrug.pas',
  Avisoi in 'Avisoi.pas' {AvisoP},
  MDIEdit in 'Mdiedit.pas' {EditForm},
  Sugeral in 'Sugeral.pas' {FormGeral},
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  ZLibEx in '..\Subrug\DelphiZLib\ZLIBEX.PAS',
  GraphWin in '..\Subrug\Anotation\GraphWin.pas' {AnotaForm},
  MulticoldServerIntf in '..\MULTICOLDSERVER\SOAP\MulticoldServerIntf.pas';

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TDefReport, DefReport);
  Application.CreateForm(TFrameForm, FrameForm);
  Application.CreateForm(TAvisoP, AvisoP);
  Application.CreateForm(TFormGeral, FormGeral);
  FrameForm.Inicializa;

//  FormGeral.CriarAliasDatabaseLocal;
 // FormGeral.CriarAliasEventos;
//  FormGeral.CriarAliasLog;

  Application.Run;
End.
