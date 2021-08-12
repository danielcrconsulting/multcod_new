Unit Qhelpu;

Interface

Uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

Type
  TQHelp = Class(TForm)
    OKBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    Procedure CleanTheMess;
    { Public declarations }
  End;

  TFooClass = Class(TControl);  {needed to get at protected font property }

var
  QHelp: TQHelp;

Implementation

Uses SuGeral;

{$R *.DFM}

Procedure TQHelp.CleanTheMess;

Begin
QHelp.Label1.Caption := '';
QHelp.Label2.Caption := '';
QHelp.Label3.Caption := '';
QHelp.Label4.Caption := '';
QHelp.Label5.Caption := '';
QHelp.Label6.Caption := '';
End;

Procedure TQHelp.FormCreate(Sender: TObject);
Var
  I : Integer;
Begin
Exit; // Não faz o realinhamento da tela pelo tamanho do desktop do cliente...
If (Screen.Width > ScreenWidth) Then
  Begin
  scaled := true;
  height := longint(height) * longint(screen.height) Div ScreenHeight;
  width := longint(width) * longint(screen.width) Div ScreenWidth;
  scaleBy(Screen.Width, ScreenWidth);
  for I := ControlCount - 1 Downto 0 Do
    TFooClass(Controls[I]).Font.Size := (Width Div ScreenWidth) *
                                         TFooClass(Controls[i]).Font.Size;
  End;
End;

End.
