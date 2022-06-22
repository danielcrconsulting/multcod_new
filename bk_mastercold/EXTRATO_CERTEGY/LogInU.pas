Unit LogInU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db{, DBTables};

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

    Org : Array Of Integer;
    NomeOrg : Array Of String;
    QtdTent : Integer;
    Grupo : String;

  End;

Var
  LogInForm: TLogInForm;

Implementation

Uses SuGeral;

{$R *.DFM}

Procedure TLogInForm.Button2Click(Sender: TObject);
Begin
Application.Terminate;
End;

Procedure TLogInForm.Button1Click(Sender: TObject);
Var
  I : Integer;
Begin
If QtdTent = 3 Then
  Begin
  Application.Terminate;
  Exit;
  End;
Inc(QtdTent);

FormGeral.IBAdmRemotoDatabase.Open;

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuarios.TableName+'" A ');
FormGeral.QueryAux1.Sql.Add('WHERE (A."CODUSUARIO" = '''+UsuEdit.Text+''') ');
FormGeral.QueryAux1.Sql.Add('AND   (A."SENHA" = '''+SenhaEdit.Text+''')' );
FormGeral.QueryAux1.Open;

Grupo := '';
If FormGeral.QueryAux1.RecordCount = 0 Then
  ShowMessage('Usuario ou Senha inválida...')
Else
  Grupo := FormGeral.QueryAux1.Fields[1].AsString;
FormGeral.QueryAux1.Close;

If (UpperCase(ParamStr(0))='MASTERCOLD.EXE') And (Grupo <> '') Then
  Begin
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuRel.TableName+'" A, ');
  FormGeral.QueryAux1.Sql.Add(              '"'+FormGeral.TableGruposDFN.TableName+'" B ');
  FormGeral.QueryAux1.Sql.Add('WHERE (A."CODUSUARIO" = '''+UsuEdit.Text+''') ');
  FormGeral.QueryAux1.Sql.Add('AND   (A."CODGRUPO" = B."CODGRUPO") ');
  FormGeral.QueryAux1.Open;
  If FormGeral.QueryAux1.RecordCount = 0 Then
    ShowMessage('Nenhuma Organização associada a seu usuário...')
  Else
    Begin
    While Not FormGeral.QueryAux1.Eof Do
      FormGeral.QueryAux1.Next;
    SetLength(Org,FormGeral.QueryAux1.RecordCount);
    SetLength(NomeOrg,FormGeral.QueryAux1.RecordCount);
    FormGeral.QueryAux1.Close;
    FormGeral.QueryAux1.Open;
    I := 0;
    While Not FormGeral.QueryAux1.Eof Do
      Begin
      Org[I] := FormGeral.QueryAux1.Fields[1].AsInteger;
      NomeOrg[I] := FormGeral.QueryAux1.Fields[6].AsString;
      Inc(I);
      FormGeral.QueryAux1.Next;
      End;
    End;
  FormGeral.QueryAux1.Close;
  End;
Close;  
End;

Procedure TLogInForm.FormCreate(Sender: TObject);
Begin
QtdTent := 0;
End;

End.
