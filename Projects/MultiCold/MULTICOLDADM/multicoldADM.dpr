program multicoldADM;

uses
  Forms,
  principal in 'principal.pas' {fPrincipal},
  mascaraCampos in 'mascaraCampos.pas' {fMascaraCampos},
  dataModule in 'dataModule.pas' {repositorioDeDados: TDataModule},
  mascaraUsuarios in 'mascaraUsuarios.pas' {fMascaraUsuarios},
  formGrade in 'formGrade.pas' {fGrade},
  mapaDeNomes in 'mapaDeNomes.pas' {fMapaDeNomes},
  extrator in 'extrator.pas' {fExtrator},
  destinosDfn in 'destinosDfn.pas' {fDestinosDfn},
  indicesDfn in 'indicesDfn.pas' {fIndicesDfn},
  movtoCD in 'movtoCD.pas' {fMovtoCD},
  gruposAuxAlfaDfn in 'gruposAuxAlfaDfn.pas' {fGruposAuxAlfaDfn},
  gruposAuxNumDfn in 'gruposAuxNumDfn.pas' {fGruposAuxNumDfn},
  subGruposDfn in 'subGruposDfn.pas' {fSubGruposDfn},
  gruposDfn in 'gruposDfn.pas' {fGruposDfn},
  usuarios in 'usuarios.pas' {fUsuarios},
  grupoUsuarios in 'grupoUsuarios.pas' {fGrupoUsuarios},
  usuariosEGrupos in 'usuariosEGrupos.pas' {fUsuariosEGrupos},
  grupoRel in 'grupoRel.pas' {fGrupoRel},
  usuRel in 'usuRel.pas' {fUsuRel},
  sistema in 'sistema.pas' {fSistema},
  dfn in 'dfn.pas' {fDfn},
  fProtocolo in 'fProtocolo.pas' {fProtocol},
  login in 'login.pas' {fLogin},
  programa in 'programa.pas' {fConfiguracao},
  editor in 'editor.pas' {fEditor},
  sisAuto in 'sisAuto.pas' {fSisAuxDfn},
  about in 'about.pas' {AboutBox},
  fEvento_Visu in 'fEvento_Visu.pas' {fEventosVisu},
  relUsuario in 'relUsuario.pas' {fRelUsuario},
  usuRelAdv in 'usuRelAdv.pas' {fUsuRelAdv},
  heranca in 'heranca.pas' {fHeranca},
  limpeza in 'limpeza.pas' {fLimpeza},
  grupoRelNovo in 'grupoRelNovo.pas' {fGrupoRelNovo},
  DfnComProbU in 'DfnComProbU.pas' {Form1},
  Subrug in '..\..\Subrug\Subrug.pas',
  SuTypGer in '..\..\Subrug\SuTypGer.pas',
  Pilha in '..\..\CR CONSULTING\Pilha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Multicold Administrador';
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.CreateForm(TfMascaraCampos, fMascaraCampos);
  Application.CreateForm(TfMascaraUsuarios, fMascaraUsuarios);
  Application.CreateForm(TfGrade, fGrade);
  Application.CreateForm(TfMapaDeNomes, fMapaDeNomes);
  Application.CreateForm(TfExtrator, fExtrator);
  Application.CreateForm(TfDestinosDfn, fDestinosDfn);
  Application.CreateForm(TfIndicesDfn, fIndicesDfn);
  Application.CreateForm(TfMovtoCD, fMovtoCD);
  Application.CreateForm(TfGruposAuxAlfaDfn, fGruposAuxAlfaDfn);
  Application.CreateForm(TfGruposAuxNumDfn, fGruposAuxNumDfn);
  Application.CreateForm(TfSubGruposDfn, fSubGruposDfn);
  Application.CreateForm(TfGruposDfn, fGruposDfn);
  Application.CreateForm(TfUsuarios, fUsuarios);
  Application.CreateForm(TfGrupoUsuarios, fGrupoUsuarios);
  Application.CreateForm(TfUsuariosEGrupos, fUsuariosEGrupos);
  Application.CreateForm(TfGrupoRel, fGrupoRel);
  Application.CreateForm(TfUsuRel, fUsuRel);
  Application.CreateForm(TfSistema, fSistema);
  Application.CreateForm(TfDfn, fDfn);
  Application.CreateForm(TfProtocol, fProtocol);
  Application.CreateForm(TfConfiguracao, fConfiguracao);
  Application.CreateForm(TfEditor, fEditor);
  Application.CreateForm(TfSisAuxDfn, fSisAuxDfn);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfEventosVisu, fEventosVisu);
  Application.CreateForm(TfRelUsuario, fRelUsuario);
  Application.CreateForm(TfUsuRelAdv, fUsuRelAdv);
  Application.CreateForm(TfHeranca, fHeranca);
  Application.CreateForm(TfLimpeza, fLimpeza);
  Application.CreateForm(TfGrupoRelNovo, fGrupoRelNovo);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
