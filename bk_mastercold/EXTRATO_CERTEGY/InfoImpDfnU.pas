Unit InfoImpDfnU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db{, DBTables};

Type
  TGetInfoImpDFNForm = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Procedure FormShow(Sender: TObject);
    Procedure ComboBox2Enter(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  GetInfoImpDFNForm: TGetInfoImpDFNForm;

Implementation

Uses SuGeral;

{$R *.DFM}

Procedure TGetInfoImpDFNForm.FormShow(Sender: TObject);
Begin

Label2.Caption := viGrupo;
Label3.Caption := viSubGrupo;

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

Procedure TGetInfoImpDFNForm.ComboBox2Enter(Sender: TObject);
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

Procedure TGetInfoImpDFNForm.FormCreate(Sender: TObject);
Begin
Edit1.MaxLength := TamCodRel;
End;

Procedure TGetInfoImpDFNForm.Button1Click(Sender: TObject);
Begin
If (Edit1.Text = '') Or
   (ComboBox1.Text = '') Or
   (ComboBox2.Text = '') Then
  Begin
  ModalResult := mrNone;
  ShowMessage('Preencha os três campos obrigatoriamente');
  End
Else
  ModalResult := mrOk;
End;

Procedure TGetInfoImpDFNForm.Button2Click(Sender: TObject);
Begin
Screen.Cursor := crDefault;
End;

End.
