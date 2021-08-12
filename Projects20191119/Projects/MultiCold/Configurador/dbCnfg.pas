unit dbCnfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls;

type
  TfrmDbCnfg = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDbCnfg: TfrmDbCnfg;

implementation

uses main;

{$R *.dfm}

procedure TfrmDbCnfg.Button1Click(Sender: TObject);
begin
Edit4.Text := IncludeTrailingPathDelimiter(Edit4.Text);
with frmPrincipal do
  begin
  //Provider=SQLOLEDB.1;Password=ayrtonsenna;Persist Security Info=True;User ID=sa;Initial Catalog=master;Data Source=DANIEL-CASA
  adoConnection1.ConnectionString := 'Provider=SQLOLEDB.1;'+
                                     'Password='+Edit3.Text+';'+
                                     'Persist Security Info=False;'+
                                     'User ID='+Edit2.Text+';'+
                                     'Initial Catalog=master;'+
                                     'Data Source='+Edit1.Text+';';
  adoConnection1.KeepConnection := true;
  adoConnection1.LoginPrompt := false;
  try
    adoConnection1.Open;
  except
    on e:exception do
      begin
      messageDlg('Erro conectando ao banco de dados.'+#13#10+'Detalhes do erro: '+e.Message, mtError, [mbOk], 0);
      exit;
      end;
  end; //try
  end; // with
self.Close;
end;

procedure TfrmDbCnfg.Button2Click(Sender: TObject);
begin
self.Close;
end;

end.
