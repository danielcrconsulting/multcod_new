Unit Avisoi;

//Revisado SQLServer...

Interface

Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

Type
  TAvisoP = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

  TFooClass = Class(TControl);  {needed to get at protected font property }

Const
  ScreenWidth: LongInt = 800;   { I designed my form in 800x600 mode. }
  ScreenHeight: LongInt = 600;

Var
  AvisoP: TAvisoP;

Implementation

{$R *.DFM}

Procedure TAvisoP.FormCreate(Sender: TObject);
Var
  I : Integer;
Begin
Label2.Caption := '';
Exit;
If (Screen.Width <> ScreenWidth) Then
  Begin
  scaled := true;
  height := longint(height) * longint(screen.height) Div ScreenHeight;
  width := longint(width) * longint(screen.width) Div ScreenWidth;
  scaleBy(Screen.Width, ScreenWidth);
  For I := ControlCount - 1 Downto 0 Do
    TFooClass(Controls[I]).Font.Size := (Width Div ScreenWidth) *
                                         TFooClass(Controls[i]).Font.Size;
  End;
End;

Procedure TAvisoP.Button1Click(Sender: TObject);
Begin
Close;
End;

End.
