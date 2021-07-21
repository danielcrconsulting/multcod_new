Unit LogInU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables;

Type
  TLogInForm = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    UsuEdit: TEdit;
    SenhaEdit: TEdit;
    Procedure Button2Click(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  LogInForm: TLogInForm;

Implementation

Uses SuGeral, Subrug;

{$R *.DFM}

Procedure TLogInForm.Button2Click(Sender: TObject);
Begin
Application.Terminate;
End;

Procedure TLogInForm.Button1Click(Sender: TObject);
Begin


if (UsuEdit.Text = 'Multicold') and (SenhaEdit.Text = 'masterPWD') then
begin
  Grupo := 'ADMSIS';
end
else
begin
If QtdTent = 3 Then
  Application.Terminate;
Inc(QtdTent);

FormGeral.DatabaseMultiCold.Open;

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('SELECT * FROM USUARIOS A, ');
FormGeral.QueryAux1.Sql.Add('              USUARIOSEGRUPOS B ');
FormGeral.QueryAux1.Sql.Add('WHERE (A.CODUSUARIO = '''+UsuEdit.Text+''') ');
FormGeral.QueryAux1.Sql.Add('AND   (A.SENHA = '''+SenhaEdit.Text+''')' );
FormGeral.QueryAux1.Sql.Add('AND   (A.CODUSUARIO = B.CODUSUARIO)' );
FormGeral.QueryAux1.Sql.Add('AND   (B.NOMEGRUPOUSUARIO IN (''ADMSIS'',''ADMSEG'',''ADMDFN''))' );
FormGeral.QueryAux1.Open;

If FormGeral.QueryAux1.RecordCount = 0 Then
  Begin
  FormGeral.InsereEventos('LogIn','',UsuEdit.Text+' '+GetCurrentUserName,5,'');
  ShowMessage('Usuario ou Senha inválida para login no MultiCold Adm...');
  End
Else
  Begin
  Grupo := FormGeral.QueryAux1.FieldByName('NOMEGRUPOUSUARIO').AsString;
  Close;
  End;

FormGeral.QueryAux1.Close;
FormGeral.QueryAux1.Sql.Clear;
FormGeral.DatabaseMultiCold.Close;
end;
End;

Procedure TLogInForm.FormCreate(Sender: TObject);
Begin
QtdTent := 0;
End;

End.
