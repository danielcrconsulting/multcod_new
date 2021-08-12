unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, DBXpress, FMTBcd, SqlExpr;

type
  TForm1 = class(TForm)
    ADOConnectio1: TADOConnection;
    ADOQuer1: TADOQuery;
    ADOTabl1: TADOTable;
    ADOTabl1IDPAGINA: TAutoIncField;
    ADOTabl1PAGATUAL: TIntegerField;
    ADOTabl1PAGTOTAL: TIntegerField;
    ADOTabl1ERROSISOP: TStringField;
    ADOTabl1ERROMULTICOLD: TStringField;
    ADOTabl1TEXTO: TMemoField;
    ADOTabl1TEXTOCORRIGIDO: TMemoField;
    ADOConnection1: TSQLConnection;
    ADOQuery1: TSQLQuery;
    ADOTable1: TSQLTable;
    ADOTable1IDPAGINA: TIntegerField;
    ADOTable1PAGATUAL: TIntegerField;
    ADOTable1PAGTOTAL: TIntegerField;
    ADOTable1ERROSISOP: TStringField;
    ADOTable1ERROMULTICOLD: TStringField;
    ADOTable1TEXTO: TMemoField;
    ADOTable1TEXTOCORRIGIDO: TMemoField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
