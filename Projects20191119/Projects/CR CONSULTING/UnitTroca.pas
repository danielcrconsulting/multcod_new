unit UnitTroca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SuTypGer;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Edit1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TgUnsrExtrBmg = Record
                Sistema                   : TgArr002;
                Corp                      : TgArr003;
                SubProduto                : TgArr003;
                Produto                   : TgArr003;
                Conta                     : TgArr016;
                AnoMes                    : TgArr006;
                Ciclo                     : TgArr002;
                VlrLimAtu                 : TgArr014;
                VlrLimSaque               : TgArr014;
                DataVencto                : TgArr008;
                VlrSaldoAtu               : TgArr014;
                VlrSaldoAtuConvert        : TgArr014;
                VlrSaldoExtrAnter         : TgArr014;
                VlrAmortPagtos            : TgArr014;
                VlrEncargos               : TgArr014;
                VlrTaxasAnuid             : TgArr014;
                VlrAjustes1               : TgArr014;
                VlrCompras                : TgArr014;
                VlrParcFixas              : TgArr014;
                VlrPremioSeguro           : TgArr014;
                VlrSaldoAtual             : TgArr014;
                VlrCota                   : TgArr009;
                DataCota                  : TgArr008;
                VlrPagtoMinTotal          : TgArr014;
                VlrTaxaJuros              : TgArr008;
                VlrTaxaJurosAtraso        : TgArr008;
                VlrTaxaJurosProxPer       : TgArr008;
                VlrTaxaJurosProxPerAtraso : TgArr008;
                VlrPrevia                 : TgArr014;
                CrLf                      : TgArr002;
                End;

TgUnsDetexBmg = Record
                Sistema    : TgArr002;
                Corp       : TgArr003;
                SubProduto : TgArr003;
                Produto    : TgArr003;
                Conta      : TgArr016;
                AnoMes     : TgArr006;
                Ciclo      : TgArr002;
                Cartao     : TgArr016;
                DataTrans  : TgArr008;
                Seq        : TgArr003;
                Cartao2    : TgArr003;
                Historico  : TgArr039;
                Moeda      : TgArr003;
                MoedaOrig  : TgArr012;
                Valor      : TgArr014;
                NumRef     : TgArr023;
                CrLf       : TgArr002;
                End;

Const

  TamContBmg = 347;
  TamCartBmg = 91;
  TamExtrBmg = 302;
  TamDetexBmg = 156;

var
  Form1: TForm1;

  Buff1,
  Buff2,
  Buff3 : Array[1..1024*1024*100] of char;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
  ArqIn,
  ArqOut : System.Text;

  I,
  Cont : Integer;

  Linha : AnsiString;
begin
  if Edit1.Text = '' then
  begin
    ShowMessage('Informe um arquivo para processar');
    Exit;
  end;

  AssignFile(ArqIn, Edit1.Text);
  AssignFile(ArqOut, ChangeFileExt(Edit1.Text,'_SinalTrocado.Txt'));

  System.SetTextBuf(ArqIn, Buff1);
  System.SetTextBuf(ArqOut, Buff2);

  Reset(ArqIn);
  ReWrite(ArqOut);
  Cont := 0;

  while not eof(ArqIn) do
    begin
      ReadLn(ArqIn, Linha);

      for I := 1 to Length(Linha) do
        if I <> 114 then
          if Linha[I] = '-' then
            Linha [I] := '+'
          else
            if Linha[I] = '+' then
              Linha[I] := '-';

      WriteLn(ArqOut, Linha);

      Inc(Cont);

      if (Cont mod 1000) = 0 then
        begin
        Edit2.Text := IntToStr(Cont);
        Application.ProcessMessages;
        end;
    end;

  CloseFile(ArqIn);
  CloseFile(ArqOut);
  Edit2.Text := IntToStr(Cont);
  Application.ProcessMessages;
  ShowMessage('Fim...');
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  ArqIn,
  ArqOut : System.Text;
  Cont : Integer;
  Linha : AnsiString;
begin
  if Edit1.Text = '' then
  begin
    ShowMessage('Informe um arquivo para processar');
    Exit;
  end;

  AssignFile(ArqIn, Edit1.Text);
  AssignFile(ArqOut, ChangeFileExt(Edit1.Text,'_SemRabichoExtr.Txt'));

  System.SetTextBuf(ArqIn, Buff1);
  System.SetTextBuf(ArqOut, Buff2);

  Reset(ArqIn);
  ReWrite(ArqOut);

  Cont := 0;

  while not eof(ArqIn) do
    begin
      ReadLn(ArqIn, Linha);

      Linha := Copy(Linha,1,302);

      WriteLn(ArqOut, Linha);

      Inc(Cont);

      if (Cont mod 1000) = 0 then
        begin
        Edit2.Text := IntToStr(Cont);
        Application.ProcessMessages;
        end;
    end;

  CloseFile(ArqIn);
  CloseFile(ArqOut);
  Edit2.Text := IntToStr(Cont);
  Application.ProcessMessages;
  ShowMessage('Fim...');

end;

procedure TForm1.Button4Click(Sender: TObject);

Var
  ArqIn,
  ArqOut              : System.Text;
  Cont                : Integer;
  Linha               : AnsiString;
  RegExtr             : TgUnsrExtrBmg;
  xVlrSaldoAtuConvert : Extended;
  xVlrCompras         : Extended;
  xVlrSaldoAtual      : Extended;
  xNovoSaldoStr       : AnsiString;

begin
  if Edit1.Text = '' then
  begin
    ShowMessage('Informe um arquivo para processar');
    Exit;
  end;

  AssignFile(ArqIn, Edit1.Text);
  AssignFile(ArqOut, ChangeFileExt(Edit1.Text,'_AcrtoTotCmprExt.Txt'));

  System.SetTextBuf(ArqIn, Buff1);
  System.SetTextBuf(ArqOut, Buff2);

  Reset(ArqIn);
  ReWrite(ArqOut);

  Cont := 0;

  ReadLn(ArqIn, Linha);
  if Length(Linha) = 302 then
    Begin
    CloseFile(ArqIn);
    Reset(ArqIn);
    FormatSettings.DecimalSeparator := '.';

    while not eof(ArqIn) do
      begin
        ReadLn(ArqIn, Linha);

        Move(Linha[1], RegExtr, 302);

//        xVlrSaldoAtu        := StrToFloat(Trim(RegExtr.VlrSaldoAtu));
        xVlrSaldoAtuConvert := StrToFloat(Trim(RegExtr.VlrSaldoAtuConvert));
//        xVlrSaldoExtrAnter  := StrToFloat(Trim(RegExtr.VlrSaldoExtrAnter));
//        xVlrAmortPagtos     := StrToFloat(Trim(RegExtr.VlrAmortPagtos));
//        xVlrEncargos        := StrToFloat(Trim(RegExtr.VlrEncargos));
 //       xVlrTaxasAnuid      := StrToFloat(Trim(RegExtr.VlrTaxasAnuid));
//        xVlrAjustes1        := StrToFloat(Trim(RegExtr.VlrAjustes1));
//        xVlrParcFixas       := StrToFloat(Trim(RegExtr.VlrParcFixas));
//        xVlrPremioSeguro    := StrToFloat(Trim(RegExtr.VlrPremioSeguro));

        if xVlrSaldoAtuConvert <> 0 then
          begin
          xVlrCompras         := StrToFloat(Trim(RegExtr.VlrCompras));
          xVlrSaldoAtual      := StrToFloat(Trim(RegExtr.VlrSaldoAtual));

//          xConta := xVlrSaldoAtual - (xVlrSaldoAtuConvert + xVlrEncargos + xVlrTaxasAnuid + (xVlrCompras-xVlrSaldoAtuConvert) +
//                                      xVlrParcFixas + xVlrPremioSeguro);
//          if xVlrAjustes1 > 0 then
//            xConta := xConta - xVlrAjustes1;

//          xConta := xConta * 100;  // Prepara para o round, pois resulta inteiro

//          if Round(xConta) >= 0 then  // Os valores do saldo internacional estão somados
//            begin
          xVlrSaldoAtual := xVlrSaldoAtual - xVlrSaldoAtuConvert;
          xVlrCompras := xVlrCompras - xVlrSaldoAtuConvert;

          xNovoSaldoStr := FloatToStr(xVlrSaldoAtual);
          RegExtr.VlrSaldoAtual := '              ';
          Move(xNovoSaldoStr[1], RegExtr.VlrSaldoAtual, Length(xNovoSaldoStr));

          xNovoSaldoStr := FloatToStr(xVlrCompras);
          RegExtr.VlrCompras := '              ';
          Move(xNovoSaldoStr[1], RegExtr.VlrCompras, Length(xNovoSaldoStr));

          Move(RegExtr, Linha[1], 302);

//            end;

          end;

        WriteLn(ArqOut, Linha);

        Inc(Cont);

        if (Cont mod 1000) = 0 then
          begin
          Edit2.Text := IntToStr(Cont);
          Application.ProcessMessages;
          end;
      end;

    end;

  CloseFile(ArqIn);
  CloseFile(ArqOut);
  Edit2.Text := IntToStr(Cont);
  Application.ProcessMessages;
  ShowMessage('Fim...');

end;

procedure TForm1.Button5Click(Sender: TObject);
Var
  ArqIn,
  ArqOut,
  ArqAlterados        : System.Text;
  Cont                : Integer;
  Linha               : AnsiString;
  RegDetex            : TgUnsDetexBmg;

begin

  if Edit1.Text = '' then
  begin
    ShowMessage('Informe um arquivo para processar');
    Exit;
  end;

  AssignFile(ArqIn, Edit1.Text);
  AssignFile(ArqOut, ChangeFileExt(Edit1.Text,'_AcrtoMoedaDetex.Txt'));

  System.SetTextBuf(ArqIn, Buff1);
  System.SetTextBuf(ArqOut, Buff2);

  Reset(ArqIn);
  ReWrite(ArqOut);

  AssignFile(ArqAlterados, ChangeFileExt(Edit1.Text,'_AcrtoMoedaDetexAlterados.Txt'));
  System.SetTextBuf(ArqAlterados, Buff3);

  ReWrite(ArqAlterados);

  Cont := 0;

  ReadLn(ArqIn, Linha);
  if Length(Linha) = 156 then
    Begin
    CloseFile(ArqIn);
    Reset(ArqIn);
    FormatSettings.DecimalSeparator := '.';

    while not eof(ArqIn) do
      begin
        ReadLn(ArqIn, Linha);

        Move(Linha[1], RegDetex, 156);

        If RegDetex.MoedaOrig <> '000000000.00' then
          begin
          RegDetex.Valor := '0             ';
          Writeln(ArqAlterados, Linha);
          Move(RegDetex, Linha[1], 156);
          end;

        WriteLn(ArqOut, Linha);

        Inc(Cont);

        if (Cont mod 1000) = 0 then
          begin
          Edit2.Text := IntToStr(Cont);
          Application.ProcessMessages;
          end;
      end;

    end;

  CloseFile(ArqIn);
  CloseFile(ArqOut);
  CloseFile(ArqAlterados);
  Edit2.Text := IntToStr(Cont);
  Application.ProcessMessages;
  ShowMessage('Fim...');

end;

procedure TForm1.Button6Click(Sender: TObject);
Var
  ArqIn,
  ArqOut : System.Text;
  Cont : Integer;
  Linha : AnsiString;
begin

if Edit1.Text = '' then
  begin
    ShowMessage('Informe um arquivo para processar');
    Exit;
  end;

  AssignFile(ArqIn, Edit1.Text);
  AssignFile(ArqOut, ChangeFileExt(Edit1.Text,'_SemRabichoDetex.Txt'));

  System.SetTextBuf(ArqIn, Buff1);
  System.SetTextBuf(ArqOut, Buff2);

  Reset(ArqIn);
  ReWrite(ArqOut);

  Cont := 0;

  while not eof(ArqIn) do
    begin
      ReadLn(ArqIn, Linha);

      Linha := Copy(Linha, 1, 156);

      WriteLn(ArqOut, Linha);

      Inc(Cont);

      if (Cont mod 1000) = 0 then
        begin
        Edit2.Text := IntToStr(Cont);
        Application.ProcessMessages;
        end;
    end;

  CloseFile(ArqIn);
  CloseFile(ArqOut);
  Edit2.Text := IntToStr(Cont);
  Application.ProcessMessages;
  ShowMessage('Fim...');


end;

procedure TForm1.Edit1DblClick(Sender: TObject);

begin
Edit2.Text := '';
Application.ProcessMessages;

if OpenDialog1.Execute then
  Edit1.Text := OpenDialog1.FileName;

end;

end.
