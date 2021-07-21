unit ClientUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, InvokeRegistry, Rio, SOAPHTTPClient, StdCtrls, ITeste1;

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
  Linha : String;
  Xon : WideString;
begin
Xon := '';
Linha := (HTTPRIO1 as ITeste).GetRelatorio('Romero', 'Cunha', 0, '', Xon);
ShowMessage(Linha);
end;

end.
