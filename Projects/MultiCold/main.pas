unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IniFiles;

type
  TCold = class(TService)
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Cold: TCold;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Cold.Controller(CtrlCode);
end;

function TCold.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TCold.ServiceCreate(Sender: TObject);
var f : TIniFile;
begin
f := TIniFile.Create('Cold_Service.Ini');
WinExec(pChar(f.ReadString('Cold','FiltroName','')+' Minimized'),SW_SHOWMINNOACTIVE);
WinExec(pChar(f.ReadString('Cold','AppName','')+' Minimized'),SW_SHOWMINNOACTIVE);
f.Free;
end;

end.
