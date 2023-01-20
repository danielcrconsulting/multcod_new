program MasterColdExtrato;

uses
  SysUtils,
  Dialogs,
  Forms,
  MasterU in 'MasterU.pas' {MasterColdForm},
  Sugeral in 'Sugeral.pas' {FormGeral},
  EditTest in 'EditTest.pas' {dlgTest},
  Analisador in 'Analisador.pas' {DefReport},
  LogInCliU in 'LogInCliU.pas' {LogInCliForm},
  SelCont in 'SelCont.pas' {SeleCons},
  Fconta in 'Fconta.pas' {ContaForm},
  Fcartao in 'Fcartao.pas' {CartaoForm},
  FExtr in 'FExtr.pas' {ExtrForm},
  FRangeResumo in 'FRangeResumo.pas' {RangeFormResumo},
  PortaCartU in 'PortaCartU.pas' {PortaForm},
  Lancamentos in 'Lancamentos.pas' {LancamentosForm},
  ContaExtrU in 'ContaExtrU.pas' {ContaExtrForm},
  FRange in 'FRange.pas' {RangeForm},
  RelResumoU in 'RelResumoU.pas' {RelResumo},
  SuTypGer in '..\..\Projects\Subrug\SuTypGer.pas',
  Subrug in '..\..\Projects\Subrug\Subrug.pas',
  Pilha in '..\..\Projects\CR CONSULTING\Pilha.pas',
  ZLIBEX in '..\..\Projects\Subrug\DelphiZLib\ZLIBEX.PAS';

{$R *.RES}

Begin
  Application.Initialize;
  Application.CreateForm(TMasterColdForm, MasterColdForm);
  Application.CreateForm(TDefReport, DefReport);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TLogInCliForm, LogInCliForm);
  Application.CreateForm(TSeleCons, SeleCons);
  Application.CreateForm(TContaForm, ContaForm);
  Application.CreateForm(TCartaoForm, CartaoForm);
  Application.CreateForm(TExtrForm, ExtrForm);
  Application.CreateForm(TRangeFormResumo, RangeFormResumo);
  Application.CreateForm(TPortaForm, PortaForm);
  Application.CreateForm(TdlgTest, dlgTest);
  Application.CreateForm(TLancamentosForm, LancamentosForm);
  Application.CreateForm(TContaExtrForm, ContaExtrForm);
  Application.CreateForm(TRangeForm, RangeForm);
  Application.CreateForm(TRelResumo, RelResumo);
  If LogInCliForm.VerificaSemSeg Then
    Begin
    LogInCliForm.SeleOrgBut.Click;
    End
  Else  
  Repeat
    Try
      LogInCliForm.UsuEdit.Text := UpperCase(GetCurrentUserName);
      LogInCliForm.LogInOkBut.Click;
      If LogInCliForm.ComboBox1.Items.Count > 1 Then
        LogInCliForm.ShowModal
      Else
        If LogInCliForm.ComboBox1.Items.Count = 1 Then
          LogInCliForm.SeleOrgBut.Click
        Else
          Application.Terminate;
      If Application.Terminated Then
        Break;
    Except
      Application.Terminate;
      End; // Try }
  Until LogInCliForm.Grupo <> '';
  Application.Run;

{
V2.0 R 26 - 22/07/2003
No Vision Plus havia um caso de jurídica só com informações de conta e nenhuma de cartão. Coloquei o programa para verificar
se na falta de dados de cartão, há dados de conta para a pesquisa de info de conta. Neste caso o programa monta um grid
com as informações de conta e continua até mostrar os dados...
}

End.
