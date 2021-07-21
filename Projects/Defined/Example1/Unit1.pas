unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dfcontrols, dfclasses;

type
  TForm1 = class(TForm)
    DFEngine1: TDFEngine;
    DFActiveDisplay1: TDFActiveDisplay;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
