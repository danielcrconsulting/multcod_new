unit Consulta_;

interface

uses  Forms, Classes, Controls, StdCtrls, ADODB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB, Vcl.DBCtrls;


type
  TConsulta = class(TForm)
    Label1:  TLabel;
    Command1:  TButton;
    grdDataGrid: TDBGrid;
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
    ADODataSet1: TADODataSet;
    DBNavigator1: TDBNavigator;
    ADODataSet1cd_grupo_usu: TSmallintField;
    ADODataSet1Id_Usuario: TWideStringField;
    ADODataSet1Nome_Usuario: TWideStringField;
    ADODataSet1Senha: TWideStringField;

    procedure Command1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ADODataSet1SenhaGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure grdDataGridDblClick(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

  sSqlConsulta : String;
  end;

var
  Consulta: TConsulta;

implementation

uses  SysUtils, RotGerais, Module1, VBto_Converter, Dialogs;

{$R *.dfm}

 //=========================================================
procedure TConsulta.ADODataSet1SenhaGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
if Sender.IsNull then
  Text := ''
else
  Text := StringOfChar('*', Length(Sender.AsString));
end;

procedure TConsulta.Command1Click(Sender: TObject);
begin
  AdoDataSet1.Close;
  AdoConnection1.Close;
  Close;
end;

procedure TConsulta.FormShow(Sender: TObject);

begin

CenterForm(Self);

if AnsiUpperCase(gOpcao)='ADM' then
  Conecta(AdoConnection1, ExtractFileDir(Application.ExeName) + '\admin.udl')
else
  Conecta(AdoConnection1, gDataPath + gDataFile + '.udl');

AdoDataSet1.CommandText := sSqlConsulta;

AdoDataSet1.Open;

grdDataGrid.DataSource.DataSet.EnableControls;

end;

procedure TConsulta.grdDataGridDblClick(Sender: TObject);
begin
//if String.UpperCase(Column.FieldName) = 'SENHA' then
  ShowMessage('Senha: '+AdoDataSet1.FieldByName('Senha').AsString);
end;

end.
