unit MonsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ArqIn,
  ArqOut : TFileStream;
  Buf : Pointer;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin

Edit1.Text := 'Alocando memória';
Application.ProcessMessages;

ArqIn := TFileStream.Create('C:\Rom\MultiCold\Origem\NaoSeparados\Rel.S1', fmOpenRead or fmShareExclusive);
GetMem(Buf, ArqIn.Size);

Edit1.Text := 'Lendo dados';
Application.ProcessMessages;
ArqIn.ReadBuffer(Buf^, ArqIn.Size);

ArqOut := TFileStream.Create('C:\Rom\MultiCold\Origem\NaoSeparados\RelBig.S1', fmCreate or fmShareExclusive);

Edit1.Text := 'Escrevendo 1';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 2';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 3';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 4';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 5';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 6';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 7';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 8';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 9';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

Edit1.Text := 'Escrevendo 10';
Application.ProcessMessages;
ArqOut.WriteBuffer(Buf^, ArqIn.Size);

FreeMem(Buf);

ArqIn.Free;
ArqOut.Free;

ShowMessage('Fim...');

end;

end.
