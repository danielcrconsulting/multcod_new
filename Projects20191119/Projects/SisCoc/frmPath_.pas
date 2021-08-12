unit frmPath_;

interface

uses  Forms, Classes, Controls, StdCtrls, Data.DB, Data.Win.ADODB;


type
  TfrmPath = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Label4:  TLabel;
    txtArqEntrada:  TEdit;
    txtArqTemplate:  TEdit;
    txtArqSaida:  TEdit;
    cmdGravar:  TButton;
    cmdCancelar:  TButton;
    txtArqExcel:  TEdit;
    ADOConnection1: TADOConnection;
    RsDb: TADOTable;

    procedure cmdCancelarClick(Sender: TObject);
    procedure cmdGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmPath: TfrmPath;

implementation

uses  Dialogs, Module1, RotGerais, VBto_Converter, SysUtils;

{$R *.dfm}

 //=========================================================
procedure TfrmPath.cmdCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPath.cmdGravarClick(Sender: TObject);
//Var
//  ClienteAdoConnection : TAdoConnection;
//  RsDb : TAdoDataSet;

begin

  try  // On Error GoTo Erro

  if not Conecta(AdoConnection1, gDataPath + gDataFile + '.udl') then
    Exit;

  RsDb.TableName := 'Path';
  RsDb.Open;

  If RsDb.Eof then
    Begin
    RsDb.Append;
    RsDb.FieldByName('Ind').AsInteger := 1;
    End
  else
    RsDb.Edit;

  if Self.txtArqEntrada.Text <> '' then
    VBtoADOFieldSet(RsDb, 'PathArquivoEntrada', Self.txtArqEntrada.Text);
  if Self.txtArqTemplate.Text <> '' then
    VBtoADOFieldSet(RsDb, 'PathTemplate', Self.txtArqTemplate.Text);
  if Self.txtArqSaida.Text <> '' then
    VBtoADOFieldSet(RsDb, 'PathArquivoSaida', Self.txtArqSaida.Text);
  if Self.txtArqExcel.Text <> '' then
    VBtoADOFieldSet(RsDb, 'PathArquivoExcel', Self.txtArqExcel.Text);

  RsDb.Post;

  ShowMessage('Paths Alterados com Sucesso!');

  AdoConnection1.Close;
  RsDb.Close;

  except On E:exception do
    ShowMessage(E.Message);
  end;
end;

procedure TfrmPath.FormShow(Sender: TObject);
begin
  CenterForm(Self);

  if not Conecta(AdoConnection1, gDataPath + gDataFile + '.udl') then
    Exit;

  txtArqEntrada.Text := '';
  txtArqTemplate.Text := '';
  txtArqSaida.Text := '';
  txtArqExcel.Text := '';
  txtArqEntrada.SetFocus;
  Application.ProcessMessages;

  RsDb.TableName := 'Path';
  RsDb.Open;

  txtArqEntrada.Text := RsDb.FieldByName('PathArquivoEntrada').AsString;
  txtArqTemplate.Text := RsDb.FieldByName('PathTemplate').AsString;
  txtArqSaida.Text := RsDb.FieldByName('PathArquivoSaida').AsString;
  txtArqExcel.Text := RsDb.FieldByName('PathArquivoExcel').AsString;

  if gOpcao='consulta' then
    begin
    txtArqEntrada.ReadOnly := True;
    txtArqTemplate.ReadOnly := True;
    txtArqSaida.ReadOnly := True;
    txtArqExcel.ReadOnly := True;

    // Mostra botao cancelar a direita

    cmdCancelar.Left := cmdGravar.Left;
    cmdGravar.Visible := false;
    end
  else
    begin
    txtArqEntrada.ReadOnly := False;
    txtArqTemplate.ReadOnly := False;
    txtArqSaida.ReadOnly := False;
    txtArqExcel.ReadOnly := False;

    // Mostra botao cancelar em sua posição original

    cmdCancelar.Left := 465;
    cmdGravar.Visible := True;
    end;

  AdoConnection1.Close;
  RsDb.Close;

end;

end.
