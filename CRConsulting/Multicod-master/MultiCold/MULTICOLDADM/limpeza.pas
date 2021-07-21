unit limpeza;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, System.UITypes;

type
  TfLimpeza = class(TForm)
    Edit16: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label16: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLimpeza: TfLimpeza;

implementation

uses dataModule, programa;

{$R *.dfm}

procedure TfLimpeza.BitBtn1Click(Sender: TObject);
var
  aux : string;

  procedure gravaConfig(NomeCampo, ValorCampo:String);
  var
    CampoID : integer;
  begin
  with repositorioDeDados do
    begin
    Query01.Parameters[0].Value := NomeCampo; // Recupera ID do campo para gravação
    Query01.Open;
    if Query01.RecordCount=0 then
      begin
      // Se o campo não existe, grava e pega um novo ID
      Query01.Close;
      Query02.Parameters[0].Value := NomeCampo;
      Query02.ExecSQL;
      Query01.Open;
      end;
    CampoID := Query01.Fields[0].Value;
    Query01.Close;
    // Apaga configuração pré existente
    Query03.Parameters[0].Value := CampoID;
    Query03.ExecSQL;
    // Grava nova configuração
    Query04.Parameters[0].Value := 'ADM';
    Query04.Parameters[1].Value := CampoID;
    Query04.Parameters[2].Value := ValorCampo;
    Query04.ExecSQL;
    end; // with repositorioDeDados do
  end; // function pegaCampoID(NomeCampo:String):Integer;

begin
BitBtn1.Enabled := false;
with repositorioDeDados do
  begin
  dbMulticold.BeginTrans;
  try
    Query01.SQL.clear;
    Query01.SQL.Add('SELECT CAMPOID FROM NOMECAMPO WHERE NOMECAMPO = ?');
    Query01.Prepared := true;

    Query02.SQL.Clear;
    Query02.SQL.Add('INSERT INTO NOMECAMPO (NOMECAMPO) VALUES (?)');
    Query02.Prepared := true;

    Query03.SQL.Clear;
    Query03.SQL.Add('DELETE FROM CONFIGURACAO WHERE (CAMPOID = ?)');
    Query03.Prepared := true;

    Query04.sql.clear;
    Query04.SQL.Add('INSERT INTO CONFIGURACAO (CODUSUARIO, CAMPOID, VALORCAMPO) VALUES (?,?,?)');
    Query04.Prepared := true;

    gravaConfig('LIMPEZAAUTOMATICA',aux);

    gravaConfig('DIASPERMANENCIA',Edit16.Text);
    fConfiguracao.Edit16.Text := Edit16.Text;

    Query01.Prepared := false;
    Query02.Prepared := false;
    Query03.Prepared := false;
    Query04.Prepared := false;

    dbMulticold.CommitTrans;
  except
    on e:exception do
      begin
      dbMulticold.RollbackTrans;
      messageDlg('Erro gravando dados de configuração: '+e.Message,mtError,[mbOk],0);
      end;
  end;
  end;
BitBtn1.Enabled := true;
end;

procedure TfLimpeza.BitBtn2Click(Sender: TObject);
begin
fLimpeza.Close;
end;

procedure TfLimpeza.FormCreate(Sender: TObject);
begin
with repositorioDeDados do
  begin
  Query01.SQL.Clear;
  Query01.SQL.Add('SELECT A.NOMECAMPO, B.VALORCAMPO FROM NOMECAMPO A JOIN CONFIGURACAO B ON A.CAMPOID = B.CAMPOID WHERE CODUSUARIO=''ADM''');
  Query01.Open;
  While not Query01.eof do
    begin

    if QUery01.Fields[0].Value = 'DIASPERMANENCIA' then
      edit16.Text := Query01.Fields[1].Value;

    Query01.Next;
    end;
  Query01.Close;
  end;
end;

end.
