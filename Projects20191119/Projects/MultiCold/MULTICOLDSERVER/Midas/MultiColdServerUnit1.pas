Unit MultiColdServerUnit1;

{
  R3 - 13/07/2001
  Acerto da sessão para AutoSessionName = true permitindo mais de um usuario remoto ao mesmo tempo
}

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, Db, IBDatabase;

Type
  TMultiColdServerForm = Class(TForm)
    Memo1: TMemo;
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  MultiColdServerForm: TMultiColdServerForm;
  DirDatabase,
  Servidor : String;
  LogInInfoLocal,
  LogInInfoEventos : Array[1..2] Of String;


Implementation

Uses MultiColdServerInterfaceUnit1;

{$R *.DFM}

Procedure LogaLocal(Const Mens : String);
Var
  Arq : TextFile;
Begin
AssignFile(Arq,extractFilePath(ParamStr(0))+'multicoldServer.log');
If FileExists(extractFilePath(ParamStr(0))+'multicoldServer.log') Then
  Append(Arq)
Else
  ReWrite(Arq);
WriteLn(Arq, formatDateTime('dd/mm/yyyy - hh:nn:ss ',now)+Mens);
CloseFile(Arq);
End;

Procedure TMultiColdServerForm.FormCreate(Sender: TObject);
Begin
Memo1.Clear;
Memo1.Align := alClient;
logaLocal('Servidor iniciado...');
//Grupo := f.ReadString('Nomes','Grupo','');
//SubGrupo := f.ReadString('Nomes','SubGrupo','');
//DirDataBase := IncludeTrailingPathDelimiter(f.ReadString('Cold','PathLocal',''));
//Servidor := f.ReadString('Cold','ServLocal','');
Memo1.Lines.Add('Inicializando servidor...');
Memo1.Lines.Add('');
Memo1.Lines.Add('Aguardando conexões remotas...');
Memo1.Lines.Add('');
End;

end.
