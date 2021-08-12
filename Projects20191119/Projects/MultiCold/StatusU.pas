unit StatusU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TStatusForm = class(TForm)
    ListBox1: TListBox;
    SairBut: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StatusForm: TStatusForm;

implementation

{$R *.DFM}

end.
