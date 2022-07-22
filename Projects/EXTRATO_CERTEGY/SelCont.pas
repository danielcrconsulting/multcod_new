Unit SelCont;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, SuGeral, ExtCtrls, Jpeg;

Type
  TSeleCons = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditConta: TEdit;
    EditCartao: TEdit;
    EditCpf: TEdit;
    EditNome: TEdit;
    EditSobreNome: TEdit;
    StringGrid1: TStringGrid;
    LimparGridButton: TButton;
    Image1: TImage;
    SairButton: TButton;
    Image2: TImage;
    Procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure LimparGridButtonClick(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  Function PesquisaNomeCartao(Nome : AnsiString; Var ArqIndiceNomeCartao : TgArqIndiceNomeCartao) : Boolean;
  Function PesquisaCarregaNomeCartao(Nome, SobreNome : AnsiString; Narq : AnsiString) : AnsiString;
  Function PesquisaContaCartao(NConta : Int64; Var ArqIndiceContaCartao : TgArqIndiceContaCartao; Var Qtd : Integer) : Boolean;
  Function PesquisaCarregaContaCartao(NConta : Int64; NArq : AnsiString) : AnsiString;
  Function PesquisaArqIndiceNConta(NConta : Int64) : Boolean;
  Function PesquisaCarregaAnoMesExtrato(NConta : Int64) : AnsiString;
  Function PesquisaCarregaLancamentos(NConta : Int64) : AnsiString;
  Procedure PreencheCabecalho(Var Org, Logo, Conta, Nome : TEdit; Tab1 : Integer);
  Function PesquisaConta(Conta : Int64) : Boolean;
  Procedure MontaConta(Conta : Int64);
  End;

Var
  SeleCons: TSeleCons;

Implementation

{$R *.DFM}

Uses Zlibex, SuBrug, EditTest, Fconta, Fcartao, FExtr, FRange, PortaCartU,
  Lancamentos, FRangeResumo;

Function TSeleCons.PesquisaNomeCartao(Nome : AnsiString; Var ArqIndiceNomeCartao : TgArqIndiceNomeCartao) : Boolean;
Var
  L,
  U,
  M,
  Posic,
  Ofs : Integer;
  Ok : Boolean;
Begin
Result := False;
L := 0;
U := (FileSize(ArqIndiceNomeCartao)) - 1;
While L <= U Do
  Begin
  M := (L + U) Div 2;
  Seek(ArqIndiceNomeCartao,M);
  {$i-}
  Read(ArqIndiceNomeCartao, IndiceNomeCartao);
  {$i+}
  If (IoResult = 0) Then
    Begin
    Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
    If Ok Then
      Begin
      Ofs := 2;
      Repeat
        Try
//          Seek(ArqIndiceNomeCartao,FilePos(ArqIndiceNomeCartao)-2);
          Seek(ArqIndiceNomeCartao,FilePos(ArqIndiceNomeCartao)-Ofs); // Pula mais para tr�s SPEED UP THE SEARCH!
          Read(ArqIndiceNomeCartao,IndiceNomeCartao);
          If Ofs < 1024 Then
            Ofs := Ofs * 2;
        Except
          Seek(ArqIndiceNomeCartao,0);
          Break;
          End; // Try
        Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
      Until Not Ok;

      Repeat                                                       // Sincroniza
        Read(ArqIndiceNomeCartao,IndiceNomeCartao);
        Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
      Until Ok;
      Seek(ArqIndiceNomeCartao,FilePos(ArqIndiceNomeCartao)-1);

      Posic := FilePos(ArqIndiceNomeCartao); // Aponta Para o Primeiro da lista
//      Repeat
//        Try
//          Read(ArqIndiceNomeCartao,IndiceNomeCartao);
//        Except
//          Break;
//          End; // Try
//        Ok := (Nome = Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
//        If Ok Then
//          Inc(Qtd);
//      Until Not Ok;

      Seek(ArqIndiceNomeCartao,Posic);
      Read(ArqIndiceNomeCartao,IndiceNomeCartao);
      Result := True;
      Exit
      End
    Else
      If Nome > Copy(IndiceNomeCartao.Valor,1,Length(Nome)) Then
        L := M + 1
      Else
        U := M - 1
    End
  Else
    Begin
    ShowMessage('Erro fatal durante pesquisa INome');
    Exit;
    End;
  End;
End;

Function TSeleCons.PesquisaCarregaNomeCartao(Nome, SobreNome : AnsiString; Narq : AnsiString) : AnsiString;
Var
  ArqNomeExt : File;
  PosDados,
  QtdReal,
  Lidos : Integer;
  RegUnsrCartAux : TgUnsrCart;
  StrAux : AnsiString;
  Pula,
  Ok : Boolean;
Begin
Result := '';
If PesquisaNomeCartao(Nome, ArqIndiceNomeCartao) Then
  Begin
  AssignFile(ArqNomeExt,NArq);
  Reset(ArqNomeExt,1);
  QtdReal := 0;
  PosDados := -1;
  Repeat
    Ok := True;
    If (Sobrenome <> '') Then
      Ok := (Pos(SobreNome,Copy(IndiceNomeCartao.Valor,Length(Nome)+1,Length(IndiceNomeCartao.Valor)-Length(Nome))) <> 0);
    If Ok And (PosDados <> IndiceNomeCartao.PosIni) Then
      Begin
      PosDados := IndiceNomeCartao.PosIni;
      Seek(ArqNomeExt,IndiceNomeCartao.PosIni);
      ReallocMem(BufCmp,IndiceNomeCartao.Tam);                   { Allocates only the space needed }
      BlockRead(ArqNomeExt,BufCmp^,IndiceNomeCartao.Tam,Lidos);   { Read only the buffer To decompress }
      ReallocMem(BufI,0);                               { DeAllocates }
      ZDecompress(BufCmp,IndiceNomeCartao.Tam,BufI,Lidos);
//      DecompressBuf(BufCmp,IndiceNomeCartao.Tam,0,BufI,Lidos);
      SetLength(StrAux,Lidos);
      Move(BufI^,StrAux[1],Lidos);
      Move(BufI^,RegUnsrCartAux,SizeOf(RegUnsrCartAux));
      Pula := False;
      If (SubForm = '') Or (SubForm = 'CONTA') Or (SubForm = 'CARTAO') Or (SubForm = 'EXTR1') Then
        If RegUnsrCartAux.TipoConta <> 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL4') Then
        If RegUnsrCartAux.TipoConta = 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL2') Or (SubForm = 'EMPRESARIAL3') Then // Dados da empresa e portadores
        If RegUnsrCartAux.TipoConta <> 'J' Then
          Pula := True;

      If Not TestarFlag Then
        Pula := False;

      If Not Pula Then
        Begin
        Result := Result + StrAux;
        Inc(QtdReal);
        If QtdReal = 1000 Then
          Begin
          ShowMessage('Redefina a sua pesquisa. Mais de 1000 registros encontrados, desprezando o restante...');
//        Qtd := 0;
          Break;
          End;
        End;
      End;
    Try
      Read(ArqIndiceNomeCartao,IndiceNomeCartao);      // Muda o registro
    Except
      Break
      End; // Try
//    Dec(Qtd);
//  Until Qtd <= 0;
  Until (Nome <> Copy(IndiceNomeCartao.Valor,1,Length(Nome)));
  CloseFile(ArqNomeExt);
  End;
TestarFlag := True;  
End;

Function TSeleCons.PesquisaContaCartao(NConta : Int64; Var ArqIndiceContaCartao : TgArqIndiceContaCartao; Var Qtd : Integer) : Boolean;
Var
  L,
  U,
  M,
  Posic : Integer;
Begin
Result := False;
Qtd := 0;
L := 0;
U := (FileSize(ArqIndiceContaCartao)) - 1;
While L <= U Do
  Begin
  M := (L + U) Div 2;
  Seek(ArqIndiceContaCartao,M);
  {$i-}
  Read(ArqIndiceContaCartao, IndiceConta);
  {$i+}
  If (IoResult = 0) Then
    If NConta = IndiceConta.Valor Then
      Begin
      Repeat
        Try
          Seek(ArqIndiceContaCartao,FilePos(ArqIndiceContaCartao)-2);
          Read(ArqIndiceContaCartao,IndiceConta);
        Except
          Seek(ArqIndiceContaCartao,0);
          Break;
        End; // Try
      Until (NConta <> IndiceConta.Valor);
      Posic := FilePos(ArqIndiceContaCartao); // Aponta Para o Primeiro da lista
      Repeat
        Try
          Read(ArqIndiceContaCartao,IndiceConta);
        Except
          Break;
          End; // Try
        If NConta = IndiceConta.Valor Then
          Inc(Qtd);
      Until NConta <> IndiceConta.Valor;
      Seek(ArqIndiceContaCartao,Posic);
      Read(ArqIndiceContaCartao,IndiceConta);
      Result := True;
      Exit
      End
    Else
      If NConta > IndiceConta.Valor Then
        L := M + 1
      Else
        U := M - 1
  Else
    Begin
    ShowMessage('Erro fatal durante pesquisa IContaCartao');
    Exit;
    End;
  End;
End;

Function TSeleCons.PesquisaCarregaContaCartao(NConta : Int64; Narq : AnsiString) : AnsiString;
Var
  ArqContaCartao : File;
  Qtd,
  Lidos : Integer;
  Teste,
  AuxStr : AnsiString;
  Pula : Boolean;
  RegUnsrCartAux : TgUnsrCart;
  RegUnsrContAux : TgUnsrCont;

Begin
Result := '';
If PesquisaContaCartao(NConta, ArqIndiceContaCartao, Qtd) Then
  Begin
  AssignFile(ArqContaCartao,NArq);
  Reset(ArqContaCartao,1);
  Repeat
    Seek(ArqContaCartao,IndiceConta.PosIni);

    ReallocMem(BufCmp,IndiceConta.Tam);                   { Allocates only the space needed }
    BlockRead(ArqContaCartao,BufCmp^,IndiceConta.Tam,Lidos);   { Read only the buffer To decompress }
    ReallocMem(BufI,0);
    Try                         { DeAllocates }
      ZDecompress(BufCmp,IndiceConta.Tam,BufI,Lidos);
//      DecompressBuf(BufCmp,IndiceConta.Tam,0,BufI,Lidos);
    Except
      Result := '';
      Exit;
      End;
    SetLength(AuxStr,Lidos);
    Move(BufI^,AuxStr[1],Lidos);
    Teste := '';
    If Lidos = SizeOf(RegUnsrCartAux) Then
      Begin
      Move(BufI^,RegUnsrCartAux,SizeOf(RegUnsrCartAux));
      Teste := RegUnsrCartAux.TipoConta;
      End
    Else
    If Lidos = SizeOf(RegUnsrContAux)-2 Then
      Begin
      Move(BufI^,RegUnsrContAux,SizeOf(RegUnsrContAux));
      Teste := RegUnsrContAux.TipoConta;
      End;

    Pula := False;
    If Teste <> '' Then
      Begin
      If (SubForm = '') Or (SubForm = 'CONTA') Or (SubForm = 'CARTAO') Or (SubForm = 'EXTR1') Then
        If Teste <> 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL4') Then
        If Teste = 'F' Then
          Pula := True;
      If (SubForm = 'EMPRESARIAL2') Or (SubForm = 'EMPRESARIAL3') Then
        If Teste <> 'J' Then
          Pula := True;
      End;

    If Not TestarFlag Then
      Pula := False;

    If Not Pula Then
      If AuxStr[Length(AuxStr)] = #10 Then
        Result := Result + AuxStr
      Else
        Result := Result + AuxStr + #13#10;
    Try
      Read(ArqIndiceContaCartao, IndiceConta);
    Except
      IndiceConta.Valor := NConta-1; // Para dar um valor diferente e sair do loop...
      End; // Try
  Until IndiceConta.Valor <> NConta;
  If Length(Result) <> 0 Then
    Result := Copy(Result,1,Length(Result)-2);
  CloseFile(ArqContaCartao);
  End;
TestarFlag := True;  
End;

Function TSeleCons.PesquisaArqIndiceNConta(NConta : Int64) : Boolean;
Var
  L,
  U,
  M : Integer;
Begin
Result := False;
L := 0;
U := (FileSize(ArqIndiceContaCartao)) - 1;
While L <= U Do
  Begin
  M := (L + U) Div 2;
  Seek(ArqIndiceContaCartao,M);
  {$i-}
  Read(ArqIndiceContaCartao, IndiceConta);
  {$i+}
  If (IoResult = 0) Then
    If NConta = IndiceConta.Valor Then
      Begin
      Result := True;
      Exit
      End
    Else
      If NConta > IndiceConta.Valor Then
        L := M + 1
      Else
        U := M - 1
  Else
    Begin
    ShowMessage('Erro fatal durante pesquisa NConta');
    Exit;
    End;
  End;
End;

Function TSeleCons.PesquisaCarregaAnoMesExtrato(NConta : Int64) : AnsiString;
Var
  ArqAnoMesExtrato : File;
  Lidos : Integer;
Begin
Result := '';
If PesquisaArqIndiceNConta(NConta) Then
  Begin
  AssignFile(ArqAnoMesExtrato,NArqExtr[0]);
  Reset(ArqAnoMesExtrato,1);
  Seek(ArqAnoMesExtrato,IndiceConta.PosIni);

  ReallocMem(BufCmp,IndiceConta.Tam);                   { Allocates only the space needed }
  BlockRead(ArqAnoMesExtrato,BufCmp^,IndiceConta.Tam,Lidos);   { Read only the buffer To decompress }
  CloseFile(ArqAnoMesExtrato);
  ReallocMem(BufI,0);                               { DeAllocates }
  ZDecompress(BufCmp,IndiceConta.Tam,BufI,Lidos);
//  DecompressBuf(BufCmp,IndiceConta.Tam,0,BufI,Lidos);
  SetLength(Result,Lidos);
  Move(BufI^,Result[1],Lidos);
  End;
End;

Function TSeleCons.PesquisaCarregaLancamentos(NConta : Int64) : AnsiString;
Var
  ArqDetex : File;
  Lidos : Integer;
Begin
Result := '';
If PesquisaArqIndiceNConta(NConta) Then
  Begin
  AssignFile(ArqDetex,ExtractFilePath(NArqDetex[0])+SeArquivoSemExt(NArqDetex[0])+ '.DAT');
  Reset(ArqDetex,1);
  Seek(ArqDetex,IndiceConta.PosIni);
  ReallocMem(BufCmp,IndiceConta.Tam);                   { Allocates only the space needed }
  BlockRead(ArqDetex,BufCmp^,IndiceConta.Tam,Lidos);   { Read only the buffer To decompress }
  CloseFile(ArqDetex);
  ReallocMem(BufI,0);                               { DeAllocates }
  ZDecompress(BufCmp,IndiceConta.Tam,BufI,Lidos);
//  DecompressBuf(BufCmp,IndiceConta.Tam,0,BufI,Lidos);
  SetLength(Result,Lidos);
  Move(BufI^,Result[1],Lidos);
  End;
End;

Procedure TSeleCons.FormCreate(Sender: TObject);
Begin
StringGrid1.Cells[0,0] := 'CONTA';
StringGrid1.Cells[1,0] := 'CART�O';
StringGrid1.Cells[2,0] := 'CPF/CGC';
StringGrid1.Cells[3,0] := 'NOME';
End;

Procedure TSeleCons.FormKeyPress(Sender: TObject; var Key: Char);
Var
  IConta,
  J, K : Integer;
  AuxStr,
  AuxConta : AnsiString;
  Strm: TMemoryStream;
  strFile :TFileStream;
Begin
                   // Verifica o preenchimento do campo do n�mero do cart�o de cr�dito
If Key <> #13 Then
  Exit;

Parcial := False;
J := 0;
If (EditConta.Text <> '') Then
  Inc(J);
If (EditCartao.Text <> '') Then
  Inc(J);
If (EditCpf.Text <> '') Then
  Inc(J);
If (EditNome.Text <> '') Then
  Inc(J);

If J = 0 Then
  Begin
  ShowMessage('Informe algum par�metro para pesquisa...');
  Exit;
  End;

If J > 1 Then
  Begin
  ShowMessage('Informe apenas um par�metro para pesquisa...');
  Exit;
  End;

                  // 4766.0870.0021.8019
                  // 4309.5670.0003.8016

AuxConta := '';
DadosDeConta.Clear;
NumCartao := 0;

If EditConta.Text <> '' Then
  AuxConta := EditConta.Text;

If EditCartao.Text <> '' Then
  Begin
  //showMessage('Path do �ndice cart�es:'+#13#10+ExtractFilePath(NArqCart));
  //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CARTAO.IND');
  DadosDeCartao.Clear;
  //Reset(ArqIndiceContaCartao);
  NumCartao := StrToInt64(EditCartao.Text);
  //DadosDeCartao.Text := PesquisaCarregaContaCartao(NumCartao, NArqCart);
  DadosDeCartao.Text := formGeral.RetornarContaCartao(ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CARTAO.IND', EditCartao.Text, NArqCart);
  //CloseFile(ArqIndiceContaCartao);
  If DadosDeCartao.Count = 0 Then
    Begin
    ShowMessage('Dados deste Cart�o n�o encontrados, verifique...');
    Exit;
    End;
  End;

If EditCpf.Text <> '' Then
  Begin
  //showMessage('Path do �ndice de cpf/cnpj:'+#13#10+ExtractFilePath(NArqCont));
  //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CPFCGC.IND');
  DadosDeConta.Clear;
  //Reset(ArqIndiceContaCartao);
  NumCpf := StrToInt64(EditCpf.Text);
  //DadosDeConta.Text := PesquisaCarregaContaCartao(NumCpf, NArqCont);
  DadosDeConta.Text := formGeral.RetornarContaCPF(ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CPFCGC.IND', EditCpf.Text);
  //CloseFile(ArqIndiceContaCartao);
  If DadosDeConta.Count = 0 Then
    Begin
    ShowMessage('Dados de conta deste Cpf n�o encontrados, verifique...');
    Exit;
    End;
  AuxStr := DadosDeConta[0];
//  Move(AuxStr[1],RgRcb.RegUnsrCont,Length(DadosDeConta[0])); // Verificar Aqui le auxiliar
//  AuxConta := Trim(RgRcb.RegUnsrCont.ContNormal.Conta);
  Move(AuxStr[1],RgRcb.RegUnsrContAux,Length(DadosDeConta[0]));
  AuxConta := Trim(RgRcb.RegUnsrContAux.ContNormal.Conta);
  End;

If EditNome.Text <> '' Then
  Begin
  Screen.Cursor := crHourGlass;
  //showMessage('Path do �ndice de nomes:'+#13#10+ExtractFilePath(NArqCart));
  //AssignFile(ArqIndiceNomeCartao,ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'NOMECARTAO.IND');
//  ShowMessage(ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'NOMECARTAO.IND');
  //DadosDeCartao.Clear;
  //Reset(ArqIndiceNomeCartao);
  //DadosDeCartao.Text := PesquisaCarregaNomeCartao(EditNome.Text, EditSobreNome.Text, NArqCart);
  DadosDeCartao.Text := formGeral.RetornarContaNome(ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'NOMECARTAO.IND', NArqCart , EditNome.Text, EditSobreNome.Text);
  //CloseFile(ArqIndiceNomeCartao);
  Screen.Cursor := crDefault;
  If DadosDeCartao.Count = 0 Then
    Begin
    ShowMessage('Dados deste Nome/Sobrenome n�o encontrados, verifique...');
    Exit;
    End;
  AuxConta := '';
  End;

If AuxConta <> '' Then // Verificar
  Begin
  //showMessage('Path do �ndice de contas:'+#13#10+ExtractFilePath(NArqCart));
  //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND');
  DadosDeCartao.Clear;
  //Reset(ArqIndiceContaCartao);
  IConta := 1;
  Repeat
    NumConta := StrToInt64(AuxConta);
    DadosDeCartao.Text := DadosDeCartao.Text + formGeral.RetornarContaCartao(ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND', AuxConta, NArqCart);
    Inc(IConta);
//    If IConta >= DadosDeConta.Count Then  // O �ltimo ficava de fora.....
    If IConta > DadosDeConta.Count Then
      Break;
    AuxStr := DadosDeConta[IConta-1];
//    Move(AuxStr[1],RgRcb.RegUnsrCont,Length(DadosDeConta[IConta-1])); // Verificar
//    AuxConta := Trim(RgRcb.RegUnsrCont.ContNormal.Conta);
    Move(AuxStr[1],RgRcb.RegUnsrContAux,Length(DadosDeConta[IConta-1]));
    AuxConta := Trim(RgRcb.RegUnsrContAux.ContNormal.Conta);
  Until False;
  //CloseFile(ArqIndiceContaCartao);

  If DadosDeCartao.Count = 0 Then
    Begin

//    Tenta Buscar Info de Conta se ainda n�o pesquisou...
    //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTA.IND');
    If DadosDeConta.Count = 0 Then
      Begin
      DadosDeConta.Clear;
      //Reset(ArqIndiceContaCartao);
      //DadosDeConta.Text := PesquisaCarregaContaCartao(NumConta, NArqCont);
      DadosDeCartao.Text := formGeral.RetornarContaCartao(ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND', AuxConta, NArqCart);
      //CloseFile(ArqIndiceContaCartao);
      End;

    If DadosDeConta.Count = 0 Then
      Begin
      ShowMessage('Dados de cart�o e de conta n�o encontrados, verifique...');
      Exit;
      End;
    Parcial := True;
    ShowMessage('Dados de cart�o desta Conta n�o encontrados. Os dados da conta est�o presentes, montando grid com estas informa��es...');
    End;
  End;

K := 0;
StringGrid1.Visible := False;
For J := 1 To DadosDeCartao.Count Do
  Begin
  AuxStr := DadosDeCartao[J-1];
  Move(AuxStr[1],RgRcb.RegUnsrCart,Length(AuxStr));  // Verificar

  If Length(AuxStr) = (SizeOf(RgRcb.RegUnsrCart.CartNormal) - 2) Then
    RgRcb.CartaoNormal := True
  Else
    RgRcb.CartaoNormal := False;

  If EditNome.Text <> '' Then
    Begin
    If EditNome.Text <> Copy(RgRcb.RegUnsrCart.CartNormal.NomeCartao,1,Length(EditNome.Text)) Then
      Continue;
    If EditSobreNome.Text <> '' Then
      If (Pos(EditSobreNome.Text,Copy(RgRcb.RegUnsrCart.CartNormal.NomeCartao,Length(EditNome.Text)+1,
                              Length(RgRcb.RegUnsrCart.CartNormal.NomeCartao)-Length(EditNome.Text))) = 0) Then
        Continue;
    End;

  Inc(K);
  StringGrid1.RowCount := K+1;
  StringGrid1.Cells[0,K] := RgRcb.RegUnsrCart.CartNormal.Conta;
  StringGrid1.Cells[1,K] := RgRcb.RegUnsrCart.CartNormal.Cartao;
  StringGrid1.Cells[2,K] := RgRcb.RegUnsrCart.CartNormal.CgcCpf;
  StringGrid1.Cells[3,K] := RgRcb.RegUnsrCart.CartNormal.NomeCartao;

  If NumCartao = 0 Then
    If RgRcb.RegUnsrCart.CartNormal.Titular = '0' Then
      NumCartao := StrToInt64(RgRcb.RegUnsrCart.CartNormal.Cartao);
  End;

If Parcial Then // Vai montar um grid parcial...
  For J := 1 To DadosDeConta.Count Do
    Begin
    AuxStr := DadosDeConta[K];
    Move(AuxStr[1],RgRcb.RegUnsrContAux,Length(DadosDeConta[K]));
    Inc(K);
    StringGrid1.RowCount := K+1;
    StringGrid1.Cells[0,K] := RgRcb.RegUnsrContAux.ContNormal.Conta;
    StringGrid1.Cells[1,K] := ' '; // Cart�o???
    StringGrid1.Cells[2,K] := RgRcb.RegUnsrContAux.ContNormal.CpfCgc;
    StringGrid1.Cells[3,K] := RgRcb.RegUnsrContAux.ContNormal.NomeExt;
    End;

StringGrid1.Visible := True;

EditConta.Text := '';
EditCartao.Text := '';
EditCpf.Text := '';
EditNome.Text := '';
EditSobreNome.Text := '';

Application.ProcessMessages;
End;

Procedure TSeleCons.PreencheCabecalho(Var Org, Logo, Conta, Nome : TEdit; Tab1 : Integer);
Var
  I : Integer;
  AuxStr : AnsiString;
//  RegUnsrCart : TgUnsrCart;
Begin
Org.Text := RgRcb.RegUnsrCart.CartNormal.Org;             // Verificar
Logo.Text := RgRcb.RegUnsrCart.CartNormal.Logo;
Conta.Text := Format('%'+IntToStr(Tab1)+'d',[NumConta]);
For I := DadosDeCartao.Count-1 DownTo 0 Do
  Begin
  AuxStr := DadosDeCartao[I];
  Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(AuxStr));
  If RgRcb.RegUnsrCartAux.CartNormal.Titular = '0' Then
    Break;
  End;
Nome.Text := RgRcb.RegUnsrCartAux.CartNormal.NomeCartao
End;

Function TSelecons.PesquisaConta(Conta : Int64) : Boolean;
Var
  AuxStr : AnsiString;
Begin
Result := True;
AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTA.IND');
DadosDeConta.Clear;
Reset(ArqIndiceContaCartao);
DadosDeConta.Text := PesquisaCarregaContaCartao(Conta, NArqCont);
CloseFile(ArqIndiceContaCartao);

If DadosDeConta.Count = 0 Then
  Begin
  Result := False;
  Screen.Cursor := crDefault;
  ShowMessage('Dados de Conta n�o encontrados, verifique. Tipo do cliente?');
  Exit;
  End;

AuxStr := DadosDeConta[0];
Move(AuxStr[1],RgRcb.RegUnsrCont,Length(AuxStr));     // Verificar

If Length(AuxStr) = (SizeOf(RgRcb.RegUnsrCont.ContNormal) - 2) Then
  Begin
  RgRcb.ContaNormal := True;
  ContaForm.TabSheet4.Free;
  End
Else
  RgRcb.ContaNormal := False;

If RgRcb.RegUnsrCont.ContNormal.TipoConta = 'P' Then  // Conta de portador, vai buscar o nome da empresa...
  Begin
  Try
    AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTA.IND');
    Reset(ArqIndiceContaCartao);
    AuxStr := PesquisaCarregaContaCartao(StrToInt64(Trim(RgRcb.RegUnsrCont.ContNormal.ContaEmpres)), NArqCont);
    CloseFile(ArqIndiceContaCartao);
    Move(AuxStr[1],RgRcb.RegUnsrContEmpresaDoPortador,Length(AuxStr));
  Except
    End; // Try  
  End;
End;

Procedure TSelecons.MontaConta(Conta : Int64);
Begin
// Carga dos dados da conta...

ContaForm.PageControl1.ActivePageIndex := 0;

NumConta := Conta;
TestarFlag := False;
If Not PesquisaConta(NumConta) Then
  Exit;

If SubForm = 'EMPRESARIAL2' Then
  Begin
  If RgRcb.RegUnsrCont.ContNormal.TipoConta <> 'J' Then
    Begin
    ShowMessage('Conta de pessoa f�sica, verifique...');
    Exit;
    End;
  End
Else
  If RgRcb.RegUnsrCont.ContNormal.TipoConta = 'J' Then
    Begin
    ShowMessage('Conta de pessoa jur�dica, verifique...');
    Exit;
    End;

With RgRcb.RegUnsrCont.ContNormal Do  // Montagem
  Begin
  ContaForm.Edit4.Text := ContaEmpres;
  ContaForm.Edit5.Text := CpfCgc;
  ContaForm.Edit6.Text := Status;
  ContaForm.Edit7.Text := NomeExt;

  ContaForm.Edit8.Text := EndResidenc;
  ContaForm.Edit9.Text := EndResidencCompl;
  ContaForm.Edit10.Text := EndResidencBairro;
  ContaForm.Edit11.Text := EndResidencCep;
  ContaForm.Edit12.Text := EndResidencCidade;
  ContaForm.Edit13.Text := EndResidencUf;
  ContaForm.Edit14.Text := EndResidencDdd;
  ContaForm.Edit15.Text := EndResidencFone;
  ContaForm.Edit16.Text := EndResidencRamal;

  ContaForm.Edit17.Text := Opc;
  If Opc = '1' Then
    ContaForm.Label1.Caption := 'Residencial'
  Else
  If Opc = '2' Then
    ContaForm.Label1.Caption := 'Comercial'
  Else
    ContaForm.Label1.Caption := '';

  ContaForm.Edit18.Text := EndEmpr;        // Ao Alterar para o mais novo layout colocar o endere�o comercial
  ContaForm.Edit19.Text := EndEmprCompl;
  ContaForm.Edit20.Text := EndEmprBairro;
  ContaForm.Edit21.Text := EndEmprCep;
  ContaForm.Edit22.Text := EndEmprCidade;
  ContaForm.Edit23.Text := EndEmprUf;
  ContaForm.Edit24.Text := EndEmprDdd;
  ContaForm.Edit25.Text := EndEmprFone;
  ContaForm.Edit26.Text := EndEmprRamal;
  End;

If Not RgRcb.ContaNormal Then
  Begin
  ContaForm.TabSheet4.Visible := True;
  ContaForm.Edit28.Text := RgRcb.RegUnsrCont.ContVP.DebitoCC;
  ContaForm.Edit27.Text := RgRcb.RegUnsrCont.ContVP.CodBloqueioUm;
  ContaForm.Edit3.Text := Copy(RgRcb.RegUnsrCont.ContVP.DtBloqueioUm,7,2) + '/' +
                          Copy(RgRcb.RegUnsrCont.ContVP.DtBloqueioUm,5,2) + '/' +
                          Copy(RgRcb.RegUnsrCont.ContVP.DtBloqueioUm,1,4);
  ContaForm.Edit2.Text := RgRcb.RegUnsrCont.ContVP.CodBloqueioDois;
  ContaForm.Edit1.Text := Copy(RgRcb.RegUnsrCont.ContVP.DtBloqueioDois,7,2) + '/' +
                          Copy(RgRcb.RegUnsrCont.ContVP.DtBloqueioDois,5,2) + '/' +
                          Copy(RgRcb.RegUnsrCont.ContVP.DtBloqueioDois,1,4);
  End;
  
ContaForm.Show;
End;

Procedure TSeleCons.StringGrid1DblClick(Sender: TObject);
Var
  I,
  J,
  IConta : Integer;
  NumContaAux : Int64;
//  AuxConta,
  AuxStr : AnsiString;
Begin
Screen.Cursor := crHourGlass;

// Carrega os dados de cart�o conforme a linha do grid selecionada...

//AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND');
DadosDeCartao.Clear;
//Reset(ArqIndiceContaCartao);
NumConta := StrToInt64(Trim(StringGrid1.Cells[0,StringGrid1.Row]));
//DadosDeCartao.Text := PesquisaCarregaContaCartao(NumConta, NArqCart);

DadosDeCartao.Text := formGeral.RetornarContaCartao(ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND', IntToStr(NumConta), NArqCart);


//CloseFile(ArqIndiceContaCartao);

If (DadosDeCartao.Count = 0) And (Parcial = False) Then
  Begin
  Screen.Cursor := crDefault;
  ShowMessage('Dados de Cart�o n�o encontrados. Conta pode ser jur�dica, verifique...');
  Exit;
  End;

For I := 0 To DadosDeCartao.Count-1 Do // Procura o cart�o selecionado no grid anterior
  Begin
  AuxStr := DadosDeCartao[I];
  Move(AuxStr[1],RgRcb.RegUnsrCart,Length(AuxStr));
  If StrToInt64(Trim(StringGrid1.Cells[1,StringGrid1.Row])) =
     StrToInt64(Trim(RgRcb.RegUnsrCart.CartNormal.Cartao)) Then
    Break;
  End;

With RangeForm Do
  PreencheCabecalho(EditOrg, EditLogo, EditConta, EditNome, 19);
With ContaForm Do
  PreencheCabecalho(EditOrg, EditLogo, EditConta, EditNome, 19);
With CartaoForm Do
  PreencheCabecalho(EditOrg, EditLogo, EditConta, EditNome, 19);
With ExtrForm Do
  PreencheCabecalho(EditOrg, EditLogo, EditConta, EditNome, 18);
With PortaForm Do
  PreencheCabecalho(EditOrg, EditLogo, EditConta, EditNome, 19);
With LancamentosForm Do
  PreencheCabecalho(EditOrg, EditLogo, EditConta, EditNome, 19);

If SubForm = 'EMPRESARIAL3' Then
  Begin
  NumConta := StrToInt64(Trim(StringGrid1.Cells[0,StringGrid1.Row]));
  If Not PesquisaConta(NumConta) Then
    Exit;

  If RgRcb.RegUnsrCont.ContNormal.TipoConta <> 'J' Then
    Begin
    Screen.Cursor := crDefault;
      ShowMessage('Conta de pessoa f�sica, verifique...');
    Exit;
    End;

  PortaForm.EditCgc.Text := RgRcb.RegUnsrCont.ContNormal.CpfCgc;

  //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTAEMPRESA.IND');

  DadosDeContaDePortadores.Clear;
  //Reset(ArqIndiceContaCartao);
  TestarFlag := False;
  //DadosDeContaDePortadores.Text := PesquisaCarregaContaCartao(NumConta, NArqCont);

  DadosDeContaDePortadores.Text := formGeral.RetornarContaCartao(ExtractFilePath(NArqCont)+SeArquivoSemExt(NArqCont)+'CONTAEMPRESA.IND', IntToStr(NumConta), NArqCont);

  //CloseFile(ArqIndiceContaCartao);

  If DadosDeContaDePortadores.Count = 0 Then
    Begin
    Screen.Cursor := crDefault;
    ShowMessage('Dados de contas de portadores n�o encontrados, verifique...');
    Exit;
    End;
//  AuxStr := DadosDeContaDePortadores[0];
//  Move(AuxStr[1],RegUnsrContAux,Length(DadosDeContaDePortadores[0]));
//  AuxConta := Trim(RegUnsrContAux.Conta);

  //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND');

  DadosDeCartaoDePortadores.Clear;
  //Reset(ArqIndiceContaCartao);
  IConta := 0;
  Repeat
    AuxStr := DadosDeContaDePortadores[IConta];
    Move(AuxStr[1],RgRcb.RegUnsrContAux,Length(AuxStr));
//    AuxConta := Trim(RegUnsrContAux.Conta);
    NumContaAux := StrToInt64(Trim(RgRcb.RegUnsrContAux.ContNormal.Conta));
    TestarFlag := False;
    //DadosDeCartaoDePortadores.Text := DadosDeCartaoDePortadores.Text + PesquisaCarregaContaCartao(NumContaAux, NArqCart);
    DadosDeCartaoDePortadores.Text := DadosDeCartaoDePortadores.Text + formGeral.RetornarContaCartao(ExtractFilePath(NArqCart)+SeArquivoSemExt(NArqCart)+'CONTA.IND', IntToStr(NumContaAux), NArqCart);

    Inc(IConta);
    If IConta >= DadosDeContaDePortadores.Count Then
      Break;
  Until False;
  CloseFile(ArqIndiceContaCartao);

  If DadosDeCartaoDePortadores.Count = 0 Then
    Begin
    Screen.Cursor := crDefault;
    ShowMessage('Dados de cart�o de portadores n�o encontrados, verifique...');
    Exit;
    End;

  I := 0;

  For IConta := 0 To DadosDeCartaoDePortadores.Count-1 Do
    Begin
    Inc(I);
    PortaForm.StringGrid1.RowCount := I+1;
    AuxStr := DadosDeCartaoDePortadores[IConta];
    Move(AuxStr[1],RgRcb.RegUnsrCartAux,Length(DadosDeCartaoDePortadores[IConta]));
    PortaForm.StringGrid1.Cells[0,I] := RgRcb.RegUnsrCartAux.CartNormal.Conta;
    PortaForm.StringGrid1.Cells[1,I] := RgRcb.RegUnsrCartAux.CartNormal.Cartao;
    PortaForm.StringGrid1.Cells[2,I] := RgRcb.RegUnsrCartAux.CartNormal.NomeCartao;
    PortaForm.StringGrid1.Cells[3,I] := RgRcb.RegUnsrCartAux.CartNormal.Status;
    End;

  PortaForm.Show;
  End;

If (SubForm = 'CONTA') Or (SubForm = 'EMPRESARIAL2') Then
  MontaConta(StrToInt64(Trim(StringGrid1.Cells[0,StringGrid1.Row])));

If SubForm = 'CARTAO' Then
  Begin
  CartaoForm.Edit1.Text := RgRcb.RegUnsrCart.CartNormal.Cartao;
  CartaoForm.Edit5.Text := RgRcb.RegUnsrCart.CartNormal.Status;
  CartaoForm.Edit6.Text := RgRcb.RegUnsrCart.CartNormal.CgcCpf;
  CartaoForm.Edit8.Text := RgRcb.RegUnsrCart.CartNormal.Titular;
  CartaoForm.Edit9.Text := RgRcb.RegUnsrCart.CartNormal.TipoConta;

  If Not RgRcb.CartaoNormal Then // Montagem
    Begin
    CartaoForm.Label4.Visible := True;
    CartaoForm.Label7.Visible := True;
    CartaoForm.Edit2.Visible := True;
    CartaoForm.Edit3.Visible := True;
    CartaoForm.Edit2.Text := RgRcb.RegUnsrCart.CartVP.CodBloqueio;
    CartaoForm.Edit3.Text := Copy(RgRcb.RegUnsrCart.CartVP.DtBloqueio,7,2) + '/' +
                             Copy(RgRcb.RegUnsrCart.CartVP.DtBloqueio,5,2) + '/' +
                             Copy(RgRcb.RegUnsrCart.CartVP.DtBloqueio,1,4);
    End;

  CartaoForm.Show;
  CartaoForm.NovaConsultaButton.SetFocus;
  End;

If (SubForm = 'EXTR1') Or (SubForm = 'EMPRESARIAL1') Then
  Begin
  NumConta := StrToInt64(Trim(StringGrid1.Cells[0,StringGrid1.Row]));
  If Not PesquisaConta(NumConta) Then
    Exit;

  If (SubForm = 'EXTR1') Then
    Begin
    If RgRcb.RegUnsrCont.ContNormal.TipoConta = 'J' Then
      Begin
      Screen.Cursor := crDefault;
      ShowMessage('Conta de pessoa jur�dica, verifique...');
      Exit;
      End;
    End
  Else
    If RgRcb.RegUnsrCont.ContNormal.TipoConta = 'F' Then
      Begin
      Screen.Cursor := crDefault;
      ShowMessage('Conta de pessoa f�sica, verifique...');
      Exit;
      End;

  ExtrForm.ScrollBar1.Position := 0;

  // Carga dos dados de Extrato...

  DadosDeExtrato.Clear;
  For J := 0 To NArqExtr.Count - 1 Do
    Begin
    //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqExtr[J])+SeArquivoSemExt(NArqExtr[J])+'CONTA.IND');
    //Reset(ArqIndiceContaCartao);
//    If J = 73 Then
//      ShowMessage('Esse � o cara!');
    //AuxStr := PesquisaCarregaContaCartao(NumConta, NArqExtr[J]);

    AuxStr := formGeral.RetornarContaCartao(ExtractFilePath(NArqExtr[J])+SeArquivoSemExt(NArqExtr[J])+'CONTA.IND', IntToStr(NumConta), NArqCart);


    If AuxStr <> '' Then
      DadosDeExtrato.Text := DadosDeExtrato.Text + AuxStr;
    //CloseFile(ArqIndiceContaCartao);
    End;

  If DadosDeExtrato.Count = 0 Then
    Begin
    Screen.Cursor := crDefault;
    ShowMessage('Dados de Extrato n�o encontrados, verifique...');
    Exit;
    End;

  ExtrForm.Label8.Caption := '1 de '+IntToStr(DadosDeExtrato.Count);
  ExtrForm.ScrollBar1.Max := DadosDeExtrato.Count;
  ExtrForm.ScrollBar1.Min := 1;

  ExtrForm.Carrega(0);

  ExtrForm.Show;
  ExtrForm.NovaConsultaButton.SetFocus;
  End;

If (SubForm = 'EXTR2') Or (SubForm = 'EXTR3') Or (SubForm = 'EMPRESARIAL4') Then
  Begin
  NumConta := StrToInt64(Trim(StringGrid1.Cells[0,StringGrid1.Row]));
  If Not PesquisaConta(NumConta) Then
    Exit;

  If (SubForm = 'EXTR2') Then
    Begin
    If RgRcb.RegUnsrCont.ContNormal.TipoConta = 'J' Then
      Begin
      Screen.Cursor := crDefault;
      ShowMessage('Conta de pessoa jur�dica, verifique...');
      Exit;
      End;
    End
  Else
    If (SubForm = 'EMPRESARIAL4') Then
      If RgRcb.RegUnsrCont.ContNormal.TipoConta = 'F' Then
        Begin
        Screen.Cursor := crDefault;
        ShowMessage('Conta de pessoa f�sica, verifique...');
        Exit;
        End;

  DadosDeExtrato.Clear;
  For I := 0 To NArqExtr.Count - 1 Do
    Begin
    //AssignFile(ArqIndiceContaCartao,ExtractFilePath(NArqExtr[I])+SeArquivoSemExt(NArqExtr[I])+'CONTA.IND');
    //Reset(ArqIndiceContaCartao);
    //AuxStr := PesquisaCarregaContaCartao(NumConta, NArqExtr[I]);

    AuxStr := formGeral.RetornarContaCartao(ExtractFilePath(NArqExtr[I])+SeArquivoSemExt(NArqExtr[I])+'CONTA.IND', IntToStr(NumConta), NArqExtr[I]);

    If AuxStr <> '' Then
      DadosDeExtrato.Text := DadosDeExtrato.Text + AuxStr;  // Para carregar mais de um m�s, se houver...
//      DadosDeExtrato.Add(AuxStr);
    //CloseFile(ArqIndiceContaCartao);
    End;

  If DadosDeExtrato.Count = 0 Then
    Begin
    Screen.Cursor := crDefault;
    ShowMessage('Dados de Extrato n�o encontrados, verifique...');
    Exit;
    End;
  If (SubForm = 'EXTR3') then
    begin
    RangeFormResumo.ListBox1.Clear;
    For I := 0 To DadosDeExtrato.Count-1 Do
      Begin
      AuxStr := DadosDeExtrato[I];
      Move(AuxStr[1],RgRcb.RegUnsrExtr,SizeOf(RgRcb.RegUnsrExtr));
      RangeFormResumo.ListBox1.Items.Add(RgRcb.RegUnsrExtr.AnoMes);
      End;
    RangeFormResumo.Show;
    end
  else
    begin
    RangeForm.ListBox1.Clear;
    For I := 0 To DadosDeExtrato.Count-1 Do
      Begin
      AuxStr := DadosDeExtrato[I];
      Move(AuxStr[1],RgRcb.RegUnsrExtr,SizeOf(RgRcb.RegUnsrExtr));
      RangeForm.ListBox1.Items.Add(RgRcb.RegUnsrExtr.AnoMes);
      End;
    RangeForm.Show;
    end;
  End;
Screen.Cursor := crDefault;
End;

Procedure TSeleCons.LimparGridButtonClick(Sender: TObject);
Var                 
  I : Integer;
Begin
StringGrid1.RowCount := 2;
For I := 0 To StringGrid1.ColCount-1 Do
  StringGrid1.Cells[I,1] := '';
EditNome.SetFocus;
End;

Procedure TSeleCons.SairButtonClick(Sender: TObject);
Begin
EditNome.SetFocus;
Close;
End;

Procedure TSeleCons.FormShow(Sender: TObject);
Begin
If (SubForm = 'EMPRESARIAL1') Or (SubForm = 'EMPRESARIAL2') Or (SubForm = 'EMPRESARIAL3') Or
   (SubForm = 'EMPRESARIAL4') Then
  Label4.Caption := 'CPF/CGC'
Else
  Label4.Caption := 'CPF';
End;

Begin
FileMode := fmShareDenyNone;
End.
