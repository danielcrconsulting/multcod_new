program MultiColdLimpa;

uses
  Dialogs,
  Forms,
  UnitLimpa in 'UnitLimpa.pas' {Form1},
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
  Application.CreateForm(TLogInForm, LogInForm);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TJaConf, JaConf);
  if (ParamStr(1) = 'Multicold') then
    begin
    // Se passou parâmetros de login e senha automático, preenche os campos e força o click do botão direto
    autoLogin := true;
    LogInForm.UsuEdit.Text := ParamStr(1);
    LogInForm.SenhaEdit.Text := ParamStr(2);
    if (LogInForm.UsuEdit.Text = 'Multicold') and (LogInForm.SenhaEdit.Text = 'masterPWD') then
      LogInForm.Button1.Click;
    end
  else
    LogInForm.ShowModal;

  Form1.init;
  Form1.Show;

  If Not (Grupo = 'ADMSIS') Then
    Begin
    FormGeral.InsereEventos('MultiColdLimpa',Grupo,LogInForm.UsuEdit.Text,6,'');
    ShowMessage('Usuário não administrador, acesso negado');
    Application.Terminate;
    End
  Else
    FormGeral.InsereEventos('MultiColdLimpa',Grupo,LogInForm.UsuEdit.Text,8,'');

  if (autoLogin) then
    begin
    Form1.Button1.Click;
    Application.Terminate;
    end;


  Application.Run;
end.
