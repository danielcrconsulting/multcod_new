program MultiColdLimpaII;

uses
  Dialogs,
  Forms,
  UnitLimpaII in 'UnitLimpaII.pas' {Form1},
  Sugeral in 'Sugeral.pas' {FormGeral},
  JaConfU in 'JaConfU.pas' {JaConf},
  Sutypger in '..\Subrug\Sutypger.pas',
  Subrug in '..\Subrug\Subrug.pas',
  LogInU in 'LogInU.pas' {LogInForm},
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  ZLIBEX in '..\Subrug\DelphiZLib\ZLIBEX.PAS',
  Pilha in '..\CR CONSULTING\Pilha.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TJaConf, JaConf);
  Application.CreateForm(TLogInForm, LogInForm);
  //  FormGeral.CriarAliasDatabaseLocal;
//  FormGeral.CriarAliasEventos;
//  FormGeral.CriarAliasLog;

  LogInForm.ShowModal;

  If Not (Grupo = 'ADMSIS') Then
    Begin
    FormGeral.InsereEventos('MultiColdLimpa',Grupo,LogInForm.UsuEdit.Text,6,'');
    ShowMessage('Usuário não administrador, acesso negado');
    Application.Terminate;
    End
  Else
    FormGeral.InsereEventos('MultiColdLimpa',Grupo,LogInForm.UsuEdit.Text,8,'');
  
  Application.Run;
end.
