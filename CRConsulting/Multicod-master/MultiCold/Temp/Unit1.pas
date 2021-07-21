unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Soap.InvokeRegistry, Soap.Rio,
  Soap.SOAPHTTPClient, Vcl.StdCtrls, IMulticoldServer1;

type
  TForm1 = class(TForm)
    Button1: TButton;
    HTTPRIO1: THTTPRIO;
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
Var
  StrAux : String;
  ConnectionID,
  TamBuf : Integer;
begin
//HTTPRIO1.WSDLLocation := 'http://192.168.0.106/multicold/MulticoldServer.exe/wsdl/IMulticoldServer';
//HTTPRIO1.WSDLLocation := 'http://WIN-R1LTX75OYOY/multicold/MulticoldServer.exe/wsdl/IMulticoldServer';

//InvRegistry.RegisterInterface(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer', '');
//InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IMulticoldServer), 'urn:MulticoldServerIntf-IMulticoldServer#%operationName%');

StrAux := (HTTPRIO1 as IMulticoldServer).LogIn('ROMERO', '', ConnectionID);
ShowMessage(StrAux);
(HTTPRIO1 as IMulticoldServer).GetPagina('ROMERO', '', ConnectionID,
 'c:\Rom\multicold\Destino\SIPCS\CAIXA ECONOMICA FEDERAL\SUP OPERACIONAL\PCSPB670\R120-DES_20130221.DAT', 1, TamBuf, StrAux);
 ShowMessage(StrAux);
end;

end.
