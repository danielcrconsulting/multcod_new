unit ConsultaCvMes_;

interface

uses  Forms, Classes, Controls, StdCtrls, ADODB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB, Vcl.DBCtrls;


type
  TConsultaCvMes = class(TForm)
    Label1:  TLabel;
    Command1:  TButton;
    grdDataGrid: TDBGrid;
    cnAdoConect: TADOConnection;
    RsAdoDb: TADODataSet;
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;

    procedure Command1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RsAdoDbBeforePost(DataSet: TDataSet);

  private
    { Private declarations }

    //procedure Command2_Click();
    procedure Form_Unload(var Cancel: Smallint);

  public
    { Public declarations }
  end;

var
  ConsultaCvMes: TConsultaCvMes;

implementation

uses  SysUtils, RotGerais, Module1, VBto_Converter, Dialogs;

{$R *.dfm}

 //=========================================================
procedure TConsultaCvMes.Command1Click(Sender: TObject);
begin
  Close;
end;

procedure TConsultaCvMes.FormShow(Sender: TObject);

begin
  CenterForm(Self);

  if AnsiUpperCase(gOpcao)='ADM' then
    Conecta(cnAdoConect, ExtractFileDir(Application.ExeName) + '\admin.udl')
  else
    Conecta(cnAdoConect, gDataPath+gDataFile+ '.udl');

  RsAdoDb.CommandText := sSql;
  RsAdoDb.Open;

end;

procedure TConsultaCvMes.Form_Unload(var Cancel: Smallint);
begin
  RsAdoDb.Close;
  cnAdoConect.Close;
end;

procedure TConsultaCvMes.RsAdoDbBeforePost(DataSet: TDataSet);
begin
if  not Autoriza(cATUALIZA) then
  begin
  ShowMessage('Nível do seu usuário não permite alterações nestes dados');
  Abort;
  end;
end;

procedure TConsultaCvMes.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Cancel: Smallint;
begin
Cancel := 0;

Form_Unload(Cancel);
If Cancel <> 0 Then
  CanClose := false;
end;

end.
