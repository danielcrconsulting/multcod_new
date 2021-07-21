unit frmLog_;

interface

uses  Forms, Classes, Controls, StdCtrls, Dialogs, Vcl.ExtCtrls;


type
  TfrmLog = class(TForm)
    Command1:  TButton;
    Command2:  TButton;
    cmdDialog1_Save:  TSaveDialog;
    cmdDialog1:  TPrintDialog;
    RichTextBox1: TMemo;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmLog: TfrmLog;

implementation

uses  SysUtils, Module1, RotGerais, VBto_Converter;

{$R *.dfm}

 //=========================================================
procedure TfrmLog.Command1Click(Sender: TObject);
begin
  Self.RichTextBox1.Text := '';
  gArquivo11 := '';
  Close();
end;
procedure TfrmLog.Command2Click(Sender: TObject);
label
  Erro;
begin
     // Pedaço todo fudido...
(*  try  // On Error GoTo Erro

    cmdDialog1_Save.Options := [cdlPDReturnDC+cdlPDNoPageNums];
    if Self.RichTextBox1.SelLength=0 then begin
      cmdDialog1_Save.Options := [cmdDialog1_Save.Options+cdlPDAllPages];
     end  else  begin
      cmdDialog1_Save.Options := [cmdDialog1_Save.Options+cdlPDSelection];
    end;
    cmdDialog1.Execute();
    VBtoPrinter.Print('');
    Self.RichTextBox1.SelPrint(cmdDialog1.hDC);
    Exit;
  except  // Erro:
    ShowMessage(PChar('Err.Description'));
    Err.Clear();

  end; *)
end;
procedure TfrmLog.FormShow(Sender: TObject);
begin
  // Me.RichTextBox1.Text = ""
  CenterForm(Self);
  Self.RichTextBox1.Font.Name := 'Courier New';
  if Length(gArquivo11)>0 then begin
    Self.RichTextBox1.Text := gArquivo11;
    Self.RichTextBox1.SelStart := 0;
    Self.RichTextBox1.SelLength := Length(gArquivo11);
    Self.RichTextBox1.Font.Name := 'Courier New';
    Self.RichTextBox1.SelLength := 0;

   end  else  begin
    Self.RichTextBox1.Text := String(Self.RichTextBox1.Text)+DateTimeToStr(Now())+' - '+gCliente+#10+#10;
  end;
end;
procedure TfrmLog.FormResize(Sender: TObject);
begin
  if Self.WindowState<>wsMinimized then begin
    Self.RichTextBox1.Top := 360;
    Self.RichTextBox1.Left := 240;
    Self.RichTextBox1.Width := Self.Width-680;
    Self.RichTextBox1.Height := Self.Height-1830;

    Self.Command1.Top := Self.Height-1125;
    Self.Command1.Left := Self.Width-1680;
    Self.Command2.Top := Self.Height-1125;
    Self.Command2.Left := Self.Width-1680-1560;
  end;
end;


end.
