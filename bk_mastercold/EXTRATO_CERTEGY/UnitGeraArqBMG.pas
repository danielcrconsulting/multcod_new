unit UnitGeraArqBMG;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sugeral, FileCtrl, Zlibex, SuTypGer, IBDatabase, DB,
  IBCustomDataSet, IBTable, DBTables, Subrug, Grids;

type

  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    StringGrid1: TStringGrid;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TgRegUltima = Record
                Conta                     : Int64;
                DataVencto                : TgArr008;
                VlrSaldo                  : TgStr014;
                End;

  TgArrSq = Record
            Conta : Int64;
            Ciclo : Byte;
            Sq : TgStr014;
            EstSq : TgStr014;
            End;


var
  Form1: TForm1;
  ArqArrSq : File of TgArrSq;
  RegArrSq : TgArrSq;
  ParamSq,
  ParEsSq : TStringList;
  ArrUltima : Array[1..2000000] of TgRegUltima;
  
  ArrHist : Array[1..10000000] of TgArr039;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  I, J, k, iTeste,
  Ano,
  Mes,
  Lidos : Integer;
  Linha,
  Reports1Str,
  Dirdest : String;
  Reports1Rec : TSearchRec;
  ArqIndiceDetex,
  ArqIndiceExtr : TgArqIndiceContaCartao;
  IndiceDetex,
  IndiceExtr : TgIndiceI64F;
  RegDetex : TgUnsDetex;
  RegUnsrExtr : TgUnsrExtr;
  ArqAnoMesDetex,
  ArqAnoMesExtrato : File;
  FileOut,
  LayoutOut : System.text;
  CrLf : Array[1..2] of Char;
  TotalSq,
  TotEsSq : Currency;
  Acabou,
  Incluir : Boolean;
  ArrInt64 : array[0..99] of int64;

begin
CrLf[1] := #13;
CrLf[2] := #10;

For i := 0 to 99 do
  begin
  StringGrid1.Cells[0,i] := SeTiraBranco(StringGrid1.Cells[0,i]);
  if StringGrid1.Cells[0,i] = '' then
    StringGrid1.Cells[0,i] := '9999999999999999';
  end;

For i := 0 to 99 do
  If (Length(StringGrid1.Cells[0,i]) <> 16) and (Length(StringGrid1.Cells[0,i]) <> 0) then
    begin
    ShowMessage('Conta '+StringGrid1.Cells[0,i]+ ' inválida (Tamanho<>16)');
    Exit;
    end;

For i := 0 to 99 do
  if StringGrid1.Cells[0,i] <> '9999999999999999' then
    for j := 1 to 16 do
      if not (StringGrid1.Cells[0,i][j] in ['0'..'9']) then
        begin
        ShowMessage('Conta '+StringGrid1.Cells[0,i]+ ' inválida (não numérica)');
        Exit;
        end;

For i := 0 to 98 do
  For j := 0 to (98-i) do
    if StringGrid1.Cells[0,j] > StringGrid1.Cells[0,j+1] then
      begin
      Linha := StringGrid1.Cells[0,j];
      StringGrid1.Cells[0,j] := StringGrid1.Cells[0,j+1];
      StringGrid1.Cells[0,j+1] := Linha;
      end;

k:= 0;
For i := 0 to 99 do
  if StringGrid1.Cells[0,i] <> '9999999999999999' then
    begin
    k := i+1;
    ArrInt64[i] := StrToInt64(StringGrid1.Cells[0,i]);
    end
  else
    StringGrid1.Cells[0,i] := '';


AssignFile(FileOut, ExtractFilePath(ParamStr(0))+'Saques.txt');
Reset(FileOut);
While Not Eof(FileOut) Do
  Begin
  Readln(FileOut, Linha);
  ParamSq.Add(Linha);
  End;
CloseFile(FileOut);

AssignFile(FileOut, ExtractFilePath(ParamStr(0))+'SaquesEstornos.txt');
Reset(FileOut);
While Not Eof(FileOut) Do
  Begin
  Readln(FileOut, Linha);
  ParEsSq.Add(Linha);
  End;
CloseFile(FileOut);

//5179730000711008
//5179730000733002
//5179730000759007
//AssignFile(FileOut,ExtractFilePath(ParamStr(0))+'DadosFinanceiros.txt');
AssignFile(FileOut,Edit2.Text);

ReWrite(FileOut);

If CheckBox1.Checked Then
  Begin
  AssignFile(LayoutOut,ChangeFileExt(Edit2.Text, '.Layout'));
  ReWrite(LayoutOut);

  WriteLn(LayoutOut,'Logo                003');
  WriteLn(LayoutOut,'Conta               016');
  WriteLn(LayoutOut,'Corte               006');
  WriteLn(LayoutOut,'Ciclo               002');
  WriteLn(LayoutOut,'Vencimento          008');
  WriteLn(LayoutOut,'Saldo Anterior      014');
  WriteLn(LayoutOut,'Compras             014');
  WriteLn(LayoutOut,'Pagamentos          014');
  WriteLn(LayoutOut,'Ajustes             014');
  WriteLn(LayoutOut,'Taxas Cobradas      014');
  WriteLn(LayoutOut,'Serviços (p seguro) 014');
  WriteLn(LayoutOut,'Saques              014');
  WriteLn(LayoutOut,'Estornos de Saques  014');
  WriteLn(LayoutOut,'Encargos            014');
  WriteLn(LayoutOut,'Saldo Atual         014');
  WriteLn(LayoutOut,'Pagamento Mínimo    014');

  CloseFile(LayoutOut);
  End;

For Ano := 2050 Downto 1990 Do
  For Mes := 12 Downto 1 Do
//For Ano := 1990 to 2050 Do
//  For Mes := 1 to 12 Do
    Begin
    DirDest := Edit1.Text + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]);
    If DirectoryExists(DirDest) Then
      Begin
      Reports1Str := DirDest + '\' + 'UNSREXTRCONTA.IND';

      If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
        begin

        Memo1.Lines.Add('Gerando: '+IntToStr(Ano) + Format('%2.2d',[Mes]));
        Memo1.Lines.Add('Levantando saques...');
        Application.ProcessMessages;

        AssignFile(ArqArrSq, ExtractFilePath(ParamStr(0))+'Saques.tmp');
        Rewrite(ArqArrSq);
        AssignFile(ArqIndiceDetex,DirDest + '\' + 'UNSDETEXCONTA.IND');
        Reset(ArqIndiceDetex);
        AssignFile(ArqAnoMesDetex,DirDest + '\' + 'UNSDETEX.DAT');
        Reset(ArqAnoMesDetex,1);

        Detex.Clear;
        
        Acabou := false;
        Incluir := true;
        iTeste := 0;

        While (Not Eof(ArqIndiceDetex)) and (Not Acabou) Do
          Begin
          Read(ArqIndiceDetex, IndiceDetex);

          if k <> 0 then
            begin
            Incluir := false;
            if IndiceDetex.Valor = ArrInt64[iTeste] Then
              begin
              Incluir := true;
              Inc(iTeste);
              if StringGrid1.Cells[0,iTeste] = '' then
                Acabou := true;
              end
            else
            if IndiceDetex.Valor > ArrInt64[iTeste] Then
              begin
              Inc(iTeste);
              if StringGrid1.Cells[0,iTeste] = '' then
                Acabou := true;
              end;
            // else if <, não precisa fazer nada, loop para testar o próximo registro a ser lido...

            end;

          if Incluir then
            begin
          Seek(ArqAnoMesDetex,IndiceDetex.PosIni);
          ReallocMem(BufCmp,IndiceDetex.Tam);                   { Allocates only the space needed }
          BlockRead(ArqAnoMesDetex,BufCmp^,IndiceDetex.Tam,Lidos);   { Read only the buffer To decompress }
          ReallocMem(BufI,0);                               { DeAllocates }

          Try
            ZDecompress(BufCmp,IndiceDetex.Tam,BufI,Lidos);
          Except
            End;

          If Lidos <> 0 Then
            Begin
            Linha := '';
            SetLength(Linha, Lidos);
            Move(BufI^, Linha[1], Lidos);
            Detex.Text := Linha;

            RegArrSq.Conta := IndiceDetex.Valor;
            TotalSq := 0;
            TotEsSq := 0;

            For I := 1 To Detex.Count do
              Begin
              Linha := Detex[I-1];
              If Length(Linha) >= SizeOf(RegDetex) Then
                Move(Linha[1], RegDetex, Sizeof(RegDetex))
              else
                Begin
                FillChar(RegDetex, SizeOf(RegDetex), ' ');
                Move(Linha[1], RegDetex, Length(Linha));
                End;

              For J := 1 To ParamSq.Count Do
                If Pos(ParamSq[J-1], RegDetex.Historico) <> 0 Then
                  Begin
                  TotalSq := TotalSq + StrToFloat(RegDetex.Valor);
                  RegArrSq.Ciclo := StrToInt(RegDetex.Ciclo);
                  End;

              For J := 1 To ParEsSq.Count Do
                If Pos(ParEsSq[J-1], RegDetex.Historico) <> 0 Then
                  Begin
                  TotEsSq := TotEsSq + StrToFloat(RegDetex.Valor);
                  RegArrSq.Ciclo := StrToInt(RegDetex.Ciclo);
                  End;
              End;


            If (TotalSq <> 0) Or (TotEsSq <> 0) Then
              Begin
              If TotalSq < 0 Then
                RegArrSq.Sq := FormatFloat('#0000000000.00',TotalSq)
              else
                RegArrSq.Sq := FormatFloat('00000000000.00',TotalSq);
              If TotEsSq < 0 Then
                RegArrSq.EstSq := FormatFloat('#0000000000.00',TotEsSq)
              else
                RegArrSq.EstSq := FormatFloat('00000000000.00',TotEsSq);
              Write(ArqArrSq, RegArrSq);
              End;
            End;
            End;  //----> do incluir
          End;

        CloseFile(ArqArrSq);
        CloseFile(ArqIndiceDetex);
        CloseFile(ArqAnoMesDetex);

        Memo1.Lines.Add('Gerando o arquivo...');
        Application.ProcessMessages;

        AssignFile(ArqArrSq, ExtractFilePath(ParamStr(0))+'Saques.tmp');
        Reset(ArqArrSq);

        AssignFile(ArqIndiceExtr,Reports1Str);
        Reset(ArqIndiceExtr);
        AssignFile(ArqAnoMesExtrato,DirDest + '\' + 'UNSREXTR.DAT');
        Reset(ArqAnoMesExtrato,1);
        RegArrSq.Conta := 0;

        Acabou := false;
        Incluir := true;
        iTeste := 0;

        While (Not Eof(ArqIndiceExtr)) and (Not Acabou) Do
          Begin
          Read(ArqIndiceExtr, IndiceExtr);

          if k <> 0 then
            begin
            Incluir := false;
            if IndiceExtr.Valor = ArrInt64[iTeste] Then
              begin
              Incluir := true;
              Inc(iTeste);
              if StringGrid1.Cells[0,iTeste] = '' then
                Acabou := true;
              end
            else
            if IndiceExtr.Valor > ArrInt64[iTeste] Then
              begin
              Inc(iTeste);
              if StringGrid1.Cells[0,iTeste] = '' then
                Acabou := true;
              end;
            // else if <, não precisa fazer nada, loop para testar o próximo registro a ser lido...

            end;

          if Incluir then
            begin

          Seek(ArqAnoMesExtrato,IndiceExtr.PosIni);
          ReallocMem(BufCmp,IndiceExtr.Tam);                   { Allocates only the space needed }
          BlockRead(ArqAnoMesExtrato,BufCmp^,IndiceExtr.Tam,Lidos);   { Read only the buffer To decompress }
          ReallocMem(BufI,0);                               { DeAllocates }

          Try
            ZDecompress(BufCmp,IndiceExtr.Tam,BufI,Lidos);
          Except
            End;

          If Lidos <> 0 Then
            Begin

            If Lidos >= SizeOf(RegUnsrExtr) Then
              Move(BufI^, RegUnsrExtr, SizeOf(RegUnsrExtr))
            Else
              Begin
              FillChar(RegUnsrExtr, SizeOf(RegUnsrExtr), ' ');
              Move(BufI^, RegUnsrExtr, Lidos);
              End;

            While (RegArrSq.Conta < IndiceExtr.Valor) And Not Eof(ArqArrSq) Do  // Whiles separados para clareza do código!!!
              Read(ArqArrSq, RegArrSq);

            While (RegArrSq.Conta = IndiceExtr.Valor) And
                  (RegArrSq.Ciclo <> StrToInt(RegUnsrExtr.Ciclo)) And
                  Not Eof(ArqArrSq) Do
              Read(ArqArrSq, RegArrSq);

            If RegArrSq.Conta = IndiceExtr.Valor Then
{              Begin
              Linha := 'Logo=' + RegUnsrExtr.Logo + 'Conta=' + RegUnsrExtr.Conta + 'Corte=' + RegUnsrExtr.AnoMes + RegUnsrExtr.Ciclo +
                       'Vencimento=' + RegUnsrExtr.DataVencto + 'SldAnt=' + RegUnsrExtr.VlrSaldoExtrAnter + 'Compras=' + RegUnsrExtr.VlrCompras +
                       'Pagamentos=' + RegUnsrExtr.VlrAmortPagtos + 'Ajustes=' + RegUnsrExtr.VlrAjustes1 + 'PFin(nt)' + '00000000000000' +
                       'Taxas cobradas=' + RegUnsrExtr.VlrTaxasAnuid + 'Serviços (p seguro)=' + RegUnsrExtr.VlrPremioSeguro +
                       'Saques(cc)=' + RegArrSq.Sq + 'EstSaques(cc)=' + RegArrSq.EstSq + 'Encargos=' + RegUnsrExtr.VlrEncargos + 'SldAtu=' + RegUnsrExtr.VlrSaldoAtual +
                       'Pgt Min=' + RegUnsrExtr.VlrPagtoMinTotal;
              If RegArrSq.EstSq <> '00000000000.00' Then
                Memo1.Lines.Add('Conta: ' + RegUnsrExtr.Conta + RegUnsrExtr.DataVencto);

              End
            else
              Linha := 'Logo=' + RegUnsrExtr.Logo + 'Conta=' + RegUnsrExtr.Conta + 'Corte=' + RegUnsrExtr.AnoMes + RegUnsrExtr.Ciclo +
                       'Vencimento=' + RegUnsrExtr.DataVencto + 'SldAnt=' + RegUnsrExtr.VlrSaldoExtrAnter + 'Compras=' + RegUnsrExtr.VlrCompras +
                       'Pagamentos=' + RegUnsrExtr.VlrAmortPagtos + 'Ajustes=' + RegUnsrExtr.VlrAjustes1 + 'PFin(nt)' + '00000000000000' +
                       'Taxas cobradas=' + RegUnsrExtr.VlrTaxasAnuid + 'Serviços (p seguro)=' + RegUnsrExtr.VlrPremioSeguro +
                       'Saques(cc)=00000000000.00' + 'EstSaques(cc)=00000000000.00' + 'Encargos=' + RegUnsrExtr.VlrEncargos + 'SldAtu=' + RegUnsrExtr.VlrSaldoAtual +
                       'Pgt Min=' + RegUnsrExtr.VlrPagtoMinTotal;}

              Begin
              Linha := RegUnsrExtr.Logo + RegUnsrExtr.Conta + RegUnsrExtr.AnoMes + RegUnsrExtr.Ciclo +
                       RegUnsrExtr.DataVencto + RegUnsrExtr.VlrSaldoExtrAnter + RegUnsrExtr.VlrCompras +
                       RegUnsrExtr.VlrAmortPagtos + RegUnsrExtr.VlrAjustes1 +
                       RegUnsrExtr.VlrTaxasAnuid + RegUnsrExtr.VlrPremioSeguro +
                       RegArrSq.Sq + RegArrSq.EstSq + RegUnsrExtr.VlrEncargos + RegUnsrExtr.VlrSaldoAtual +
                       RegUnsrExtr.VlrPagtoMinTotal;
//              If RegArrSq.EstSq <> '00000000000.00' Then
//                Memo1.Lines.Add(RegUnsrExtr.Conta + RegUnsrExtr.DataVencto);

              End
            else
              Linha := RegUnsrExtr.Logo + RegUnsrExtr.Conta + RegUnsrExtr.AnoMes + RegUnsrExtr.Ciclo +
                       RegUnsrExtr.DataVencto + RegUnsrExtr.VlrSaldoExtrAnter + RegUnsrExtr.VlrCompras +
                       RegUnsrExtr.VlrAmortPagtos + RegUnsrExtr.VlrAjustes1 +
                       RegUnsrExtr.VlrTaxasAnuid + RegUnsrExtr.VlrPremioSeguro +
                       '00000000000.00' + '00000000000.00' + RegUnsrExtr.VlrEncargos + RegUnsrExtr.VlrSaldoAtual +
                       RegUnsrExtr.VlrPagtoMinTotal;

{              Linha := (*RegUnsrExtr.Logo*) '001' + RegUnsrExtr.Conta + RegUnsrExtr.AnoMes + RegUnsrExtr.Ciclo +
                       RegUnsrExtr.DataVencto + SinalMenosNaPonta(RegUnsrExtr.VlrSaldoExtrAnter) + SinalMenosNaPonta(RegUnsrExtr.VlrCompras) +
                       SinalMenosNaPonta(RegUnsrExtr.VlrAmortPagtos) + SinalMenosNaPonta(RegUnsrExtr.VlrAjustes1) +
                       SinalMenosNaPonta(RegUnsrExtr.VlrTaxasAnuid) + SinalMenosNaPonta(RegUnsrExtr.VlrPremioSeguro) +
                       SinalMenosNaPonta(RegArrSq.Sq) + SinalMenosNaPonta(RegArrSq.EstSq) + SinalMenosNaPonta(RegUnsrExtr.VlrEncargos) + SinalMenosNaPonta(RegUnsrExtr.VlrSaldoAtual) +
                       SinalMenosNaPonta(RegUnsrExtr.VlrPagtoMinTotal)
            else
              Linha := (*RegUnsrExtr.Logo*) '001' + RegUnsrExtr.Conta + RegUnsrExtr.AnoMes + RegUnsrExtr.Ciclo +
                       RegUnsrExtr.DataVencto + SinalMenosNaPonta(RegUnsrExtr.VlrSaldoExtrAnter) + SinalMenosNaPonta(RegUnsrExtr.VlrCompras) +
                       SinalMenosNaPonta(RegUnsrExtr.VlrAmortPagtos) + SinalMenosNaPonta(RegUnsrExtr.VlrAjustes1) +
                       SinalMenosNaPonta(RegUnsrExtr.VlrTaxasAnuid) + SinalMenosNaPonta(RegUnsrExtr.VlrPremioSeguro) +
                       '00000000000.00' + '00000000000.00' + SinalMenosNaPonta(RegUnsrExtr.VlrEncargos) + SinalMenosNaPonta(RegUnsrExtr.VlrSaldoAtual) +
                       SinalMenosNaPonta(RegUnsrExtr.VlrPagtoMinTotal);   }
//            If RegUnsrExtr.Org <> '001' Then  // Escreve tudo, menos FastSolution
//              Begin
//              Writeln(FileOut, TrocaBrancoPorZero(Linha));
              Writeln(FileOut, Linha);
//              End
//            else
//              Linha := Linha;
            End;
          End;  // Incluir
          End;
//        CloseFile(FileOut);
        CloseFile(ArqIndiceExtr);
        CloseFile(ArqAnoMesExtrato);
        CloseFile(ArqArrSq);
        end;
      SysUtils.FindClose(Reports1Rec);
      End;
    End;
CloseFile(FileOut);
ShowMessage('Fim da geração');
end;

procedure TForm1.Edit1DblClick(Sender: TObject);
Var
  Direct : String;
begin
SelectDirectory('Select a directory', '', Direct);
  If Direct <> '' Then
    Edit1.Text := Direct;
end;

procedure QuickSort(iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    Mid, T : TgArr039;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := ArrHist[(Lo + Hi) div 2];
    repeat
      while ArrHist[Lo] < Mid do Inc(Lo);
      while ArrHist[Hi] > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := ArrHist[Lo];
        ArrHist[Lo] := ArrHist[Hi];
        ArrHist[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(iLo, Hi);
    if Lo < iHi then QuickSort(Lo, iHi);
  end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  I, J, K, L : Integer;
  Ano,
  Mes,
  Lidos : Integer;
  Linha,
  Reports1Str,
  Dirdest : String;
  Reports1Rec : TSearchRec;
  ArqIndiceDetex : TgArqIndiceContaCartao;
  IndiceDetex : TgIndiceI64F;
  RegDetex : TgUnsDetex;
  ArqAnoMesDetex : File;
  FileOut : System.text;

  Procedure Encolhe;
  Begin
  If J = 1 Then
    Exit;

  Memo1.Lines.Add('Encolhendo '+IntToStr(J-1) + ' Registros...');
  Application.ProcessMessages;
  QuickSort(1, J-1);
  End;

begin
Fillchar(ArrHist[1], SizeOf(ArrHist), ' ');
Edit1.Text := IncludeTrailingBackSlash(Edit1.Text);
J := 1;
For Ano := 1990 to 2050 Do
  For Mes := 1 to 12 Do
    Begin

    DirDest := Edit1.Text + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]);
    If DirectoryExists(DirDest) Then
      Begin
//      Reports1Str := DirDest + '\' + 'UNSREXTRCONTA.IND';
      Reports1Str := DirDest + '\' + 'UNSDETEXCONTA.IND';

      If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
        begin

        Memo1.Lines.Add('Pesquisando: '+IntToStr(Ano) + Format('%2.2d',[Mes]));
        Memo1.Lines.Add('Levantando históricos... '+IntToStr(J));
        Application.ProcessMessages;

        AssignFile(ArqIndiceDetex,DirDest + '\' + 'UNSDETEXCONTA.IND');
        Reset(ArqIndiceDetex);
        AssignFile(ArqAnoMesDetex,DirDest + '\' + 'UNSDETEX.DAT');
        Reset(ArqAnoMesDetex,1);

        Detex.Clear;

        While Not Eof(ArqIndiceDetex) Do
          Begin
          Read(ArqIndiceDetex, IndiceDetex);

          Seek(ArqAnoMesDetex,IndiceDetex.PosIni);
          ReallocMem(BufCmp,IndiceDetex.Tam);                   { Allocates only the space needed }
          BlockRead(ArqAnoMesDetex,BufCmp^,IndiceDetex.Tam,Lidos);   { Read only the buffer To decompress }
          ReallocMem(BufI,0);                               { DeAllocates }

          Try
            ZDecompress(BufCmp,IndiceDetex.Tam,BufI,Lidos);
          Except
            End;

          If Lidos <> 0 Then
            Begin
            Linha := '';
            SetLength(Linha, Lidos);
            Move(BufI^, Linha[1], Lidos);
            Detex.Text := Linha;

            RegArrSq.Conta := IndiceDetex.Valor;

            For I := 1 To Detex.Count do
              Begin
              Linha := Detex[I-1];
              If Length(Linha) >= SizeOf(RegDetex) Then
                Move(Linha[1], RegDetex, Sizeof(RegDetex))
              else
                Begin
                FillChar(RegDetex, SizeOf(RegDetex), ' ');
                Move(Linha[1], RegDetex, Length(Linha));
                End;
//              If (Pos('HSBC BELAS ARTES', RegDetex.Historico) <> 0) Then
{              If (Pos('PARC', RegDetex.Historico) = 0) And
                 (Pos('ANUID', RegDetex.Historico) = 0) And
                 (Pos('ENCARG', RegDetex.Historico) = 0) And
                 (Pos('AJUSTE', RegDetex.Historico) = 0) And
                 (Pos('BANCO', RegDetex.Historico) = 0) And
                 (Pos('BAR ', RegDetex.Historico) = 0) And
                 (Pos('BBVA', RegDetex.Historico) = 0) And
                 (Pos('BENEFICIO', RegDetex.Historico) = 0) And
                 (Pos('BRADESCO', RegDetex.Historico) = 0) And
                 (Pos('CITIBANK', RegDetex.Historico) = 0) And
                 (Pos('CREDITO', RegDetex.Historico) = 0) And
                 (Pos('DB ', RegDetex.Historico) = 0) And
                 (Pos('DEBITO', RegDetex.Historico) = 0) And
                 (Pos('DISPUTED', RegDetex.Historico) = 0) And
                 (Pos('TARIFA', RegDetex.Historico) = 0) And
                 (Pos('FARMA', RegDetex.Historico) = 0) And
                 (Pos('DROGA', RegDetex.Historico) = 0) And
                 (Pos('EMISSAO', RegDetex.Historico) = 0) And
                 (Pos('HSBC', RegDetex.Historico) = 0) And
                 (Pos('JAMYR', RegDetex.Historico) = 0) And
                 (Pos('MANUTEN', RegDetex.Historico) = 0) And
                 (Pos('PET ', RegDetex.Historico) = 0) And
                 (Pos('PREZUNIC', RegDetex.Historico) = 0) And
                 (Pos('RESTAU', RegDetex.Historico) = 0) And
                 (Pos('REVERS', RegDetex.Historico) = 0) And
                 (Pos('SEGURO', RegDetex.Historico) = 0) And
                 (Pos('TECBAN', RegDetex.Historico) = 0) And
                 (Pos('TELESAQ', RegDetex.Historico) = 0) And
                 (Pos('TRANFERE', RegDetex.Historico) = 0) And
                 (Pos('MERC', RegDetex.Historico) = 0) And
                 (Pos('SUPER', RegDetex.Historico) = 0) And
                 (Pos('POSTO', RegDetex.Historico) = 0) And
                 (RegDetex.Historico[1] IN ['A'..'Z']) And
                 (Pos('PAG', RegDetex.Historico) = 0) Then }   
                Begin
                ArrHist[J] := RegDetex.Historico;
                Inc(J);
                End;
              If J = 10000001 Then
                Begin
                ShowMessage('Estourou capacidade...');
                Halt;
                End;
              End;
            End;
          End;

        CloseFile(ArqIndiceDetex);
        CloseFile(ArqAnoMesDetex);
        End;
      End;
    End;

Encolhe;

AssignFile(FileOut, ExtractFilePath(ParamStr(0))+'Historicos.txt');
Rewrite(FileOut);

RegDetex.Historico := 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
K := 0;
L := 0;

For I := 1 To J Do
  Begin
  If ArrHist[I] <> RegDetex.Historico Then
    Begin
    Inc(K);
    If L <> 0 Then
      Begin
//      Writeln(FileOut, ' #=', L);
      Writeln(FileOut, ' #', L);
      End;
    RegDetex.Historico := ArrHist[I];
    Write(FileOut, ArrHist[I]);
    L := 0;
    End;
  Inc(L);
  End;

If L <> 0 Then
  Begin
  Writeln(FileOut, L);
  End;

CloseFile(FileOut);

ShowMessage('Fim '+IntToStr(K)+' Registros escritos');

end;

procedure TForm1.Button4Click(Sender: TObject);
Var
  I, J,
  Ano,
  Mes,
  Lidos : Integer;
  Linha,
  Reports1Str,
  Dirdest : String;
  Reports1Rec : TSearchRec;
  ArqIndiceConta,
  ArqIndiceExtr : TgArqIndiceContaCartao;
  IndiceConta,
  IndiceExtr : TgIndiceI64F;
  RegUnsrExtr : TgUnsrExtr;
  ArqAnoMesExtrato : File;
  FileOut : System.text;
  CrLf : Array[1..2] of Char;

begin
Edit1.Text := IncludeTrailingBackSlash(Edit1.Text);
CrLf[1] := #13;
CrLf[2] := #10;

FillChar(ArrUltima, SizeOf(ArrUltima), ' ');
For J := 1 to 2000000 Do
  ArrUltima[J].Conta := 0;

J := Pos('MOVTO', Edit1.Text);
DirDest := Edit1.Text;
Delete(DirDest, J, 6);
DirDest := DirDest + 'UNSRCONTCONTA.IND';
AssignFile(ArqIndiceConta, DirDest);
Reset(ArqIndiceConta);
I := 0;
While Not Eof(ArqIndiceConta) Do
  Begin
  Read(ArqIndiceConta, IndiceConta);
  Inc(I);
  ArrUltima[I].Conta := IndiceConta.Valor;
  If I = 2000000 Then
    Begin
    ShowMessage('Estourou capacidade...');
    Halt;
    End;
  End;

CloseFile(ArqIndiceConta);

For Ano := 2050 Downto 1990 Do
  For Mes := 12 Downto 1 Do
//For Ano := 1990 to 2050 Do
//  For Mes := 1 to 12 Do
    Begin
    DirDest := Edit1.Text + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]);
    If DirectoryExists(DirDest) Then
      Begin
      Reports1Str := DirDest + '\' + 'UNSREXTRCONTA.IND';

      If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
        begin

        I := 1; // Pesquisar do início...

        Memo1.Lines.Add('Analisando: '+IntToStr(Ano) + Format('%2.2d',[Mes]));
        Memo1.Lines.Add('Levantando últimas movimentações...');
        Application.ProcessMessages;

        AssignFile(ArqIndiceExtr,Reports1Str);
        Reset(ArqIndiceExtr);
        AssignFile(ArqAnoMesExtrato,DirDest + '\' + 'UNSREXTR.DAT');
        Reset(ArqAnoMesExtrato,1);

        While Not Eof(ArqIndiceExtr) Do
          Begin
          Read(ArqIndiceExtr, IndiceExtr);

          Seek(ArqAnoMesExtrato,IndiceExtr.PosIni);
          ReallocMem(BufCmp,IndiceExtr.Tam);                   { Allocates only the space needed }
          BlockRead(ArqAnoMesExtrato,BufCmp^,IndiceExtr.Tam,Lidos);   { Read only the buffer To decompress }
          ReallocMem(BufI,0);                               { DeAllocates }

          Try
            ZDecompress(BufCmp,IndiceExtr.Tam,BufI,Lidos);
          Except
            End;

          If Lidos <> 0 Then
            Begin

            If Lidos >= SizeOf(RegUnsrExtr) Then
              Move(BufI^, RegUnsrExtr, SizeOf(RegUnsrExtr))
            Else
              Begin
              FillChar(RegUnsrExtr, SizeOf(RegUnsrExtr), ' ');
              Move(BufI^, RegUnsrExtr, Lidos);
              End;

            If RegUnsrExtr.Org = '030' Then
              Continue;

            While (ArrUltima[I].Conta < IndiceExtr.Valor) And                    // Os while foram separados para facilitar o entendimento do código!!!
                  (I < 2000000) Do
              Inc(I);

            If I = 2000000 Then
              begin
              Showmessage('Fundo de escala na conta extr: '+IntToStr(IndiceExtr.Valor));
              Halt;
              end;

            If (ArrUltima[I].Conta = IndiceExtr.Valor) And
               (ArrUltima[I].DataVencto = '        ') Then
              Begin
              ArrUltima[I].DataVencto := RegUnsrExtr.DataVencto;
              Linha := TrocaBrancoPorZero(SinalMenosNaPonta(RegUnsrExtr.VlrSaldoAtual));
              ArrUltima[I].VlrSaldo := Linha;
              End;
            End;
          End;
        CloseFile(ArqIndiceExtr);
        CloseFile(ArqAnoMesExtrato);
        end;
      SysUtils.FindClose(Reports1Rec);
      End;
    End;

AssignFile(FileOut, ExtractFilePath(ParamStr(0))+'Ultimas.txt');
Rewrite(FileOut);

For I := 1 to 2000000  Do
  If ArrUltima[I].DataVencto <> '        ' Then
    Begin
    Writeln(FileOut, ArrUltima[I].Conta, ArrUltima[I].DataVencto, ArrUltima[I].VlrSaldo);
    End;

CloseFile(FileOut);
ShowMessage('Fim da geração');

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
ShortDateFormat := 'yyyymmdd';
LongTimeFormat := 'hhmmss';

Edit1.Text := ExtractFilePath(ParamStr(0))+ 'BMG\EXTRATO\MOVTO\';  //IncludeTrailingBackSlash(Edit1.Text);
Edit2.Text := ExtractFilePath(ParamStr(0)) + 'DadosFin' + DateToStr(now) + TimeToStr(now) +'.txt';
end;

begin
DecimalSeparator := '.';
ParamSq := TStringList.Create;
ParEsSq := TStringList.Create;
end.
