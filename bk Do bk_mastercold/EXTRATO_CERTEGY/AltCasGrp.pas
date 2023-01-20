Unit AltCasGrp;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, {DBTables,} Db;

Type
  TAltCasGrupForm = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Procedure FormShow(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  AltCasGrupForm: TAltCasGrupForm;

Implementation

Uses
  Sugeral, Analisador;

{$R *.DFM}

Procedure TAltCasGrupForm.FormShow(Sender: TObject);
Begin
Caption := 'Alteração de Código em Cascata - '+viGrupo;

FormGeral.TableTemp.TableName := FormGeral.TableGruposDFN.TableName;
ComboBox1.Sorted := True;
ComboBox1.Items.Clear;

FormGeral.TableTemp.Open;

While Not FormGeral.TableTemp.Eof Do
  Begin
  ComboBox1.Items.Add(FormGeral.TableTemp.Fields[0].asString);
  FormGeral.TableTemp.Next;
  End;

FormGeral.TableTemp.Close;
End;

Procedure TAltCasGrupForm.Button2Click(Sender: TObject);
Begin
Close;
End;

Procedure TAltCasGrupForm.Button1Click(Sender: TObject);
Var
  CodAlfaAnt,
  DescrAnt : String;

Begin
If ComboBox1.Text = '' Then
  Begin
  ShowMessage('Informe o código anterior');
  Exit;
  End;
If Edit2.Text = '' Then
  Begin
  ShowMessage('Informe o novo código');
  Exit;
  End;

Screen.Cursor := crHourglass;

DefReport.GuardaStatusEPosicoes;

If FormGeral.IBLogRemotoTransaction.InTransaction Then
  FormGeral.IBLogRemotoTransaction.Commit;

FormGeral.IBLogRemotoTransaction.StartTransaction;

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('SELECT * FROM "'+FormGeral.TableGruposDFN.TableName+'" A WHERE A."CODGRUPO" = '+ComboBox1.Text);
Try
  FormGeral.QueryAux1.Open;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro de query, Código anterior não encontrado');
  Exit;
  End; // Try

If FormGeral.QueryAux1.Eof Then
  Begin
  FormGeral.QueryAux1.Close;
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Código anterior não encontrado');
  Exit;
  End;

CodAlfaAnt := FormGeral.QueryAux1.Fields[1].AsString;
DescrAnt := FormGeral.QueryAux1.Fields[2].AsString;
FormGeral.QueryAux1.Close;

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('INSERT INTO "'+FormGeral.TableGruposDFN.TableName+'" VALUES ('+Edit2.Text+','''+CodAlfaAnt+''','''+
                DescrAnt+''')');
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Novo Código inválido');
  Exit;
  End; // Try

FormGeral.QueryAux2.Sql.Clear;
FormGeral.QueryAux2.Sql.Add('SELECT * FROM "' + FormGeral.TableSubGruposDFN.TableName + '" A WHERE A.CODGRUPO = '+ComboBox1.Text);

Try
  FormGeral.QueryAux2.Open;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro no levantamento dos SubGrupos, operação cancelada!');
  Exit;
  End; // Try

While Not FormGeral.QueryAux2.Eof Do
  Begin
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('INSERT INTO "'+FormGeral.TableSubGruposDFN.TableName+'" VALUES ('+Edit2.Text+',' +
                  FormGeral.QueryAux2.Fields[1].asString + ',''' + FormGeral.QueryAux2.Fields[2].asString+''')');
  Try
    FormGeral.QueryAux1.ExecSql;
  Except
    Screen.Cursor := crDefault;
    FormGeral.IBLogRemotoTransaction.Rollback;
    DefReport.RefreshTabelas(True);
    ShowMessage('Erro na inserção do novo código na tabela SubGrupos, operação cancelada!');
    End; // Try
  FormGeral.QueryAux2.Next;
  End;

FormGeral.QueryAux2.Close;

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('UPDATE "'+FormGeral.TableUsuRel.TableName + '" A ');
FormGeral.QueryAux1.Sql.Add('SET A."CODGRUPO" = '+Edit2.Text);
FormGeral.QueryAux1.Sql.Add('WHERE A."CODGRUPO" = '+ComboBox1.Text);
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro no UPDATE de UsuRel, operação cancelada!');
  Exit;
  End; // Try

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('UPDATE "'+FormGeral.TableDFN.TableName + '" A ');
FormGeral.QueryAux1.Sql.Add('SET A."CODGRUPO" = '+Edit2.Text);
FormGeral.QueryAux1.Sql.Add('WHERE A."CODGRUPO" = '+ComboBox1.Text);
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro no UPDATE de DFN, operação cancelada!');
  Exit;
  End; // Try

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('DELETE FROM "'+FormGeral.TableSubGruposDFN.TableName + '" A ');
FormGeral.QueryAux1.Sql.Add('WHERE A."CODGRUPO" = '+ComboBox1.Text);
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro no DELETE de SubGrupos, operação cancelada!');
  Exit;
  End; // Try

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('DELETE FROM "'+FormGeral.TableGruposDFN.TableName + '" A ');
FormGeral.QueryAux1.Sql.Add('WHERE A."CODGRUPO" = '+ComboBox1.Text);
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro no DELETE de Grupos, operação cancelada!');
  Exit;
  End; // Try

FormGeral.IBLogRemotoTransaction.Commit;
DefReport.RefreshTabelas(True);

Screen.Cursor := crDefault;
ShowMessage('Ok!');

End;

End.
