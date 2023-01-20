Program MasterColdIndexa;

uses
  SysUtils,
  Forms,
  Index in 'Index.pas' {FormIndex},
  Analisador in 'Analisador.pas' {DefReport},
  QHelpU in 'QHelpU.pas' {QHelp},
  Avisoi in 'Avisoi.pas' {AvisoP},
  MapaFilU in 'MapaFilU.pas' {MapaFil},
  ConfigProc in 'ConfigProc.pas' {Config},
  Sugeral in 'Sugeral.pas' {FormGeral},
  Asort in 'Asort.pas' {SortMem},
  Pilha in '..\..\Projects\CR CONSULTING\Pilha.pas',
  SuTypGer in '..\..\Projects\Subrug\SuTypGer.pas',
  Subrug in '..\..\Projects\Subrug\Subrug.pas',
  Ssort in '..\..\Projects\Subrug\Ssort.pas';

{$R *.RES}
{$M 16384, 268435456}

Begin
  Application.Initialize;
  Application.CreateForm(TFormIndex, FormIndex);
  Application.CreateForm(TDefReport, DefReport);
  Application.CreateForm(TQHelp, QHelp);
  Application.CreateForm(TAvisoP, AvisoP);
  Application.CreateForm(TMapaFil, MapaFil);
  Application.CreateForm(TConfig, Config);
  Application.CreateForm(TFormGeral, FormGeral);
  Application.CreateForm(TSortMem, SortMem);
  FormIndex.Timer1.Enabled := False;
  If Config.ExecAutoEdit.Text = 'S' Then
    Begin
    FormIndex.Edit1.Text := 'Aguardando Início da Execução Automática';
    FormIndex.Timer1.Interval := StrToInt(Trim(Config.Edit2.Text))*1000;
    FormIndex.Timer1.Enabled := True;
    End
  Else
    FormIndex.Edit1.Text := 'Aguardando Instrução de Início de Processamento';

  FormIndex.DetSeq; // Determina os sequenciais para logproc e protocolo

  Application.Run;
End.
