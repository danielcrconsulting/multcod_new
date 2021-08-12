Unit AltCasSGrp;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, {DBTables,} Db;

Type
  TAltCasSGForm = Class(TForm)
    Label1: TLabel;
    ComboBox2: TComboBox;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Procedure FormShow(Sender: TObject);
    Procedure ComboBox2Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  AltCasSGForm: TAltCasSGForm;

Implementation

Uses Sugeral, Analisador;

{$R *.DFM}

Procedure TAltCasSGForm.FormShow(Sender: TObject);
Begin
Caption := 'Alteração de Código em Cascata - '+viSubGrupo;
Label3.Caption := 'Código '+viGrupo;

FormGeral.TableAux1.TableName := FormGeral.TableGruposDFN.TableName;
ComboBox1.Sorted := True;
ComboBox1.Items.Clear;

Try
  FormGeral.TableAux1.Open;
Except
  Exit;
  End; // Try;

While Not FormGeral.TableAux1.Eof Do
  Begin
  ComboBox1.Items.Add(FormGeral.TableAux1.Fields[0].asString);
  FormGeral.TableAux1.Next;
  End;

FormGeral.TableAux1.Close;
End;

Procedure TAltCasSGForm.ComboBox2Click(Sender: TObject);

Begin
FormGeral.TableAux2.TableName := FormGeral.TableSubGruposDFN.TableName;

Try
  FormGeral.TableAux2.Open;
Except
  Exit;
  End; // Try;

ComboBox2.Items.Clear;
While Not FormGeral.TableAux2.Eof Do
  Begin
  Try
    If FormGeral.TableAux2.Fields[0].asString = ComboBox1.Text Then
      ComboBox2.Items.Add(FormGeral.TableAux2.Fields[1].asString);
  Except
    End; // Try
  FormGeral.TableAux2.Next;
  End;

FormGeral.TableAux2.Close;
End;

Procedure TAltCasSGForm.Button2Click(Sender: TObject);
Begin
Close;
End;

Procedure TAltCasSGForm.Button1Click(Sender: TObject);
Var
  DescrAnt : String;
Begin
If ComboBox1.Text = '' Then
  Begin
  ShowMessage('Informe o código - '+viGrupo);
  Exit;
  End;
If ComboBox2.Text = '' Then
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
FormGeral.QueryAux1.Sql.Add('SELECT * FROM "'+FormGeral.TableSubGruposDFN.TableName+
                            '" A WHERE A."CODGRUPO" = '+ComboBox1.Text + ' ');
FormGeral.QueryAux1.Sql.Add('AND A."CODSUBGRUPO" = '+ComboBox2.Text);
Try
  FormGeral.QueryAux1.Open;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro de query, códigos ' + viGrupo + ' e anterior não encontrados');
  Exit;
  End; // Try

If FormGeral.QueryAux1.Eof Then
  Begin
  FormGeral.QueryAux1.Close;
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Códigos ' + viGrupo + ' e anterior não encontrados');
  Exit;
  End;

DescrAnt := FormGeral.QueryAux1.FieldByName('NOMESUBGRUPO').AsString;
FormGeral.QueryAux1.Close;

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('INSERT INTO "'+FormGeral.TableSubGruposDFN.TableName+'" VALUES (' + ComboBox1.Text + ',' +
               Edit2.Text + ','''+DescrAnt+''')');
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Novo Código inválido');
  Exit;
  End; // Try

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('UPDATE "'+FormGeral.TableDFN.TableName + '" A ');
FormGeral.QueryAux1.Sql.Add('SET A."CODSUBGRUPO" = ' + Edit2.Text + ' ');
FormGeral.QueryAux1.Sql.Add('WHERE (A."CODGRUPO" = ' + ComboBox1.Text + ') ');
FormGeral.QueryAux1.Sql.Add('AND (A."CODSUBGRUPO" = ''' + ComboBox2.Text+ ''') ');
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro de UPDATE DFN');
  Exit;
  End; // Try

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('DELETE FROM "'+FormGeral.TableSubGruposDFN.TableName + '" A ');
FormGeral.QueryAux1.Sql.Add('WHERE (A."CODGRUPO" = ' + ComboBox1.Text + ') ');
FormGeral.QueryAux1.Sql.Add('AND (A."CODSUBGRUPO" = ' + ComboBox2.Text + ') ');
Try
  FormGeral.QueryAux1.ExecSQL;
Except
  Screen.Cursor := crDefault;
  FormGeral.IBLogRemotoTransaction.Rollback;
  DefReport.RefreshTabelas(True);
  ShowMessage('Erro de DELETE SubGrupos');
  Exit;
  End; // Try

FormGeral.IBLogRemotoTransaction.Commit;
DefReport.RefreshTabelas(True);

Screen.Cursor := crDefault;
ShowMessage('Ok!');

End;

End.
