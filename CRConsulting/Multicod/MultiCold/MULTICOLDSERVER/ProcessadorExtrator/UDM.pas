unit UDM;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Data.DB;

type
  TDMMain = class(TDataModule)
    Conn: TADOConnection;
    QryPendentes: TADOQuery;
    CmdUpdate: TADOCommand;
    ADOQryDescomp: TADOQuery;
    ADOQryPesq: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMMain: TDMMain;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
