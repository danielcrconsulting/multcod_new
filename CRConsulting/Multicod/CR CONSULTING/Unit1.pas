unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBXpress, StdCtrls, DB, SqlExpr;

type
  TForm1 = class(TForm)
    SQLConnection1: TSQLConnection;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
SQLConnection1.ConnectionName := 'MSSQLConnection';
SQLConnection1.LoadParamsFromIniFile('C:\ColdCfg\dbxconnections.ini');
SQLConnection1.params.values['database'] := 'MultiCold';
SQLConnection1.Connected := True;
end;

end.
