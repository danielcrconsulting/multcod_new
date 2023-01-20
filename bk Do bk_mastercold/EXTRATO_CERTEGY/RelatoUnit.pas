unit RelatoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FormGeral, RpCon, RpConDS, RpConBDE, RpDefine, RpRave, DB;

type
  TRelatoForm = class(TForm)
    RvProject1: TRvProject;
    RvDataSetConnection1: TRvDataSetConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RelatoForm: TRelatoForm;

implementation

{$R *.dfm}

end.
