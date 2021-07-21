Unit MExtract;

//Revisado SQLServer...

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ComCtrls, Mdiedit, MdiMultiCold, Subrug, SuGeral, SuTypGer, Qhelpu,
  SOAPConn, IMulticoldServer, Variants, ZLibEx;


Type
  TFrmExtract = Class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    StringGrid2: TStringGrid;
    Label7: TLabel;
    StringGrid3: TStringGrid;
    Label8: TLabel;
    StringGrid4: TStringGrid;
    AbrirButton: TButton;
    SalvarButton: TButton;
    LimparButton: TButton;
    ExecutarButton: TButton;
    SairButton: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    StrPagina: TMemo;
    Label9: TLabel;
    Edit5: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit6: TEdit;
    CheckBox3: TCheckBox;
    ProgressBar1: TProgressBar;
    Procedure SairButtonClick(Sender: TObject);
    procedure SalvarButtonClick(Sender: TObject);
    procedure AbrirButtonClick(Sender: TObject);
    procedure LimparButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExecutarButtonClick(Sender: TObject);
    procedure Edit5DblClick(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure Edit2DblClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure Edit3DblClick(Sender: TObject);
    procedure Edit4DblClick(Sender: TObject);
    procedure StringGrid3DblClick(Sender: TObject);
    procedure StringGrid4DblClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  OrigemDeExecucao : Char;

  Cln,
  Lin,
  Tam,
  IChrInc,
  IStrInc,
  IChrExc,
  IStrExc,
  LinIni,
  LinFin,
  LinFinal,
  PgIni,
  PgFin : Integer;
  ArqTxt : System.Text;
  NomeArqTxt,
//  PagNormal,
//  PagAcertada,
  Linha,
  Apendix,
  StrTam : String;
  ValCampos : Array[1..99] Of String;
  Filtro : TFiltro;
  ChrIncFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : SetOfChar;
                              End;
  StrIncFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : TgStrStr;
                              End;
  ChrExcFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : SetOfChar;
                              End;
  StrExcFil : Array[1..99] Of Record
                              ICampo : Integer;
                              Filtro : TgStrStr;
                              End;

  // variáveis usadas pelo indexador
  OperacaoExtract,
  DirDestinoExtract : String;

  Procedure LeScript(FileName : String);
  //Procedure TrabalhaADescompactacao(I : Integer);
  Procedure TrabalhaADescompactacao(I : Int64);
  End;

Var
  FrmExtract: TFrmExtract;
  IndexFrmExtract : Array[1..1000] Of TFrmExtract;
  Xyz : Integer;

Implementation

uses Index, LogInForm;

{$R *.DFM}

Procedure TFrmExtract.SairButtonClick(Sender: TObject);
Begin
Close;
End;

Procedure TFrmExtract.SalvarButtonClick(Sender: TObject);
Var
  Arq : System.Text;
  I,J : Integer;
Begin
SaveDialog1.InitialDir := 'C:\ColdCfg\';

If SaveDialog1.Execute Then
  Begin
  AssignFile(Arq,SaveDialog1.FileName);
  ReWrite(Arq);
  WriteLn(Arq,'XTRFILEV4');
  WriteLn(Arq,Edit5.Text); // Descrição...
  If CheckBox1.Checked Then   // V3
    WriteLn(Arq,'S')
  Else
    WriteLn(Arq,'N');
  If CheckBox2.Checked Then   // V3
    WriteLn(Arq,'S')
  Else
    WriteLn(Arq,'N');
  WriteLn(Arq,Edit6.Text);    // V3
  WriteLn(Arq,Edit1.Text);
  WriteLn(Arq,Edit2.Text);
  WriteLn(Arq,Edit3.Text);
  WriteLn(Arq,Edit4.Text);
  if CheckBox3.Checked then // V4
    WriteLn(Arq,'S')
  Else
    WriteLn(Arq,'N');
  For I := 1 To 99 Do
    Begin
    For J := 0 To 1 Do
      WriteLn(Arq,Trim(StringGrid1.Cells[J,I]));
    For J := 0 To 2 Do
      WriteLn(Arq,Trim(StringGrid2.Cells[J,I]));
    For J := 1 To 10 Do
      WriteLn(Arq,Trim(StringGrid3.Cells[J,I]));
    For J := 1 To 3 Do
      WriteLn(Arq,Trim(StringGrid4.Cells[J,I]));
    End;
  CloseFile(Arq);
  End;
End;

Procedure TFrmExtract.LeScript(FileName : String);
Var
  Arq : System.Text;
  I,J,
  NCol : Integer;
  Versao,
  Linha : String;
Begin
LimparButton.Click; // Limpar
AssignFile(Arq,FileName);
Reset(Arq);
ReadLn(Arq,Linha);
Versao := Linha;
If (Versao = 'XTRFILEV2') Or (Versao = 'XTRFILEV3') or (Versao = 'XTRFILEV4') Then
  Begin
  ReadLn(Arq,Linha);
  NCol := 10;
  End
Else
  NCol := 7;

Edit5.Text := Linha;
ReadLn(Arq,Linha);

If (Versao = 'XTRFILEV3') or (Versao = 'XTRFILEV4') Then
  Begin
  If UpperCase(Linha) = 'S' Then
    CheckBox1.Checked := True
  Else
    CheckBox1.Checked := False;
  ReadLn(Arq,Linha);
  If UpperCase(Linha) = 'S' Then
    CheckBox2.Checked := True
  Else
    CheckBox2.Checked := False;
  ReadLn(Arq,Linha);
  Edit6.Text := Linha;
  ReadLn(Arq,Linha);
  End
Else
  Begin
  CheckBox1.Checked := True;
  CheckBox2.Checked := False;
  Edit6.Text := '';
  End;

Edit1.Text := Linha;
ReadLn(Arq,Linha);
Edit2.Text := Linha;
ReadLn(Arq,Linha);
Edit3.Text := Linha;
ReadLn(Arq,Linha);
Edit4.Text := Linha;

if (Versao = 'XTRFILEV4') then
  begin
  ReadLn(Arq, Linha);
  if upperCase(Linha) = 'S' then
    CheckBox3.Checked := true;
  end;

For I := 1 To 99 Do
  Begin
  For J := 0 To 1 Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid1.Cells[J,I] := Linha;
    End;
  For J := 0 To 2 Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid2.Cells[J,I] := Linha;
    End;
  For J := 1 To NCol Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid3.Cells[J,I] := Linha;
    End;
  For J := 1 To 3 Do
    Begin
    ReadLn(Arq,Linha);
    StringGrid4.Cells[J,I] := Linha;
    End;
  End;
CloseFile(Arq);
End;

Procedure TFrmExtract.AbrirButtonClick(Sender: TObject);
Begin
OpenDialog1.InitialDir := 'C:\ColdCfg';
If OpenDialog1.Execute Then
  LeScript(OpenDialog1.FileName);
End;

Procedure TFrmExtract.LimparButtonClick(Sender: TObject);
Var
  I,J : Integer;
Begin
CheckBox1.Checked := False;
CheckBox2.Checked := False;
CheckBox3.Checked := False;
Edit1.Text := '';
Edit2.Text := '';
Edit3.Text := '';
Edit4.Text := '';
Edit5.Text := '';
Edit6.Text := '';
For I := 1 To 99 Do
  Begin
  For J := 0 To 1 Do
    StringGrid1.Cells[J,I] := '';
  For J := 0 To 2 Do
    StringGrid2.Cells[J,I] := '';
  For J := 1 To 10 Do
    StringGrid3.Cells[J,I] := '';
  For J := 1 To 3 Do
    StringGrid4.Cells[J,I] := '';
  End;
End;

Procedure TFrmExtract.FormCreate(Sender: TObject);
Begin
OrigemDeExecucao := ' ';
StringGrid1.Cells[0,0] := 'Tipo';
StringGrid1.Cells[1,0] := 'Definição';
StringGrid2.Cells[0,0] := 'Definição';
StringGrid2.Cells[1,0] := 'Linha Inicial';
StringGrid2.Cells[2,0] := 'Linha Final';
StringGrid3.Cells[1,0] := 'Nome';
StringGrid3.Cells[2,0] := 'Coluna';
StringGrid3.Cells[3,0] := 'Linha';
StringGrid3.Cells[4,0] := 'Tamanho';
StringGrid3.Cells[5,0] := 'Relativo';
StringGrid3.Cells[6,0] := 'Brancos';
StringGrid3.Cells[7,0] := 'Obrigatorio';
StringGrid3.Cells[8,0] := 'Tipo do Campo';
StringGrid3.Cells[9,0] := 'Formatação de entrada';
StringGrid3.Cells[10,0] := 'Formatação de saída';
StringGrid4.Cells[1,0] := 'Nome';
StringGrid4.Cells[2,0] := 'Tipo';
StringGrid4.Cells[3,0] := 'Definição';
End;

//Procedure TFrmExtract.TrabalhaADescompactacao(I : Integer);
Procedure TFrmExtract.TrabalhaADescompactacao(I : Int64);

Var
  ILinha : Integer;
{  Filename,
  PaginaAcertada,
  PaginaNormal : String;
  ComprimeBrancos,
  RelRemoto,
  Report133CC,
  Pagina64 : Boolean;
  ArqPag32 : File Of Integer;
  ArqPag64 : File Of Int64;
  Arq : File;}

  Function TestaFiltro(I : Integer) : Boolean;
  Var
    J, K: Integer;
    Preserva,
    Testou : Boolean;
  Begin
  For J := 1 To 99 Do
    With ChrIncFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          For K := 1 To Length(ValCampos[I]) Do
            If Not (ValCampos[I][K] In Filtro) Then
              Begin
              ValCampos[I] := '';
              Break;
              End;
          Break; // Parar assim que realizar a primeira checagem
          End;

  Preserva := False;
  Testou := False;
  For J := 1 To 99 Do
    With StrIncFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          Testou := True;
          If ValCampos[I] <> '' Then
            With Filtro Do
              If Col <> 0 Then
                If Copy(StrPagina.Lines[Lin],Col,Tam) <> FilStr Then      // Simulando um OR
                  Begin
//                    ValCampos[I] := '';    { Conteudo difere da linha a ser incluida }
                  End
                Else
                  Preserva := True;
//            Break; // Parar assim que realizar a primeira checagem
          End;
          
  If Testou Then
    If Not Preserva Then  // Algum campo salvou o conteúdo ............
        ValCampos[I] := '';    { Conteudo difere da linha a ser incluida }

  For J := 1 To 99 Do
    With ChrExcFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          For K := 1 To Length(ValCampos[I]) Do
            If (ValCampos[I][K] In Filtro) Then
              Begin
              ValCampos[I] := '';
              Break;
              End;
//            Break; // Parar assim que realizar a primeira checagem
          End;

  For J := 1 To 99 Do
    With StrExcFil[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          If ValCampos[I] <> '' Then
            With Filtro Do
              If Col <> 0 Then
                If Copy(StrPagina.Lines[Lin],Col,Tam) = FilStr Then
                  ValCampos[I] := '';    { Conteúdo igual a linha a ser excluida }
//            Break; // Parar assim que realizar a primeira checagem
          End;

  If ValCampos[I] = '' Then
    Result := False
  Else
    Result := True;
  End;

  Procedure RodaScript;
  Var
    I,
    Ky,
    Posic : Integer;
    Day,
    Month,
    Year : Word;
    Ori,
    RegAux,
    AuxStr : String;
    AuxData : TDateTime;

    Function FormataCX(ParEntra : String) : String;
    Var
      Ix : Integer;
    Begin
    Result := ParEntra;
    With StringGrid3 Do
      Begin
      Cells[9,I] := UpperCase(Cells[9,I]);
      RegAux := Cells[9,I];
      If RegAux = '' Then
        Exit;
      If (Pos('C',RegAux) = 0) And (Pos('X',RegAux) = 0) Then
        Exit;
      Result := '';
      For Ix := 1 To Length(RegAux) Do
        Begin
        If Ix > Length(ParEntra) Then
          Break;
        If RegAux[Ix] = 'C' Then
          Result := Result + ParEntra[Ix];
        End;
      End;
    End;

    Procedure AndaNoFormatoAndObtemUmNumero;
    Begin
    With StringGrid3 Do
      Begin
      If Ky > Length(Cells[9,I]) Then
        Exit;
      Ori := Cells[9,I][Ky];
      RegAux := '';
      While (Length(Cells[9,I]) >= Ky) And (Cells[9,I][Ky] = Ori) Do
        Begin
        RegAux := RegAux + ValCampos[I][Ky];
        Inc(Ky);
        End;
      Case Ori[1] Of
        'D' : Day := StrToInt(RegAux);
        'M' : Month := StrToInt(RegAux);
        'Y' : Begin
              Year := StrToInt(RegAux);
              If Length(RegAux) = 2 Then
                If Year <= 50 Then
                  Year := Year + 2000
                Else
                  Year := Year + 1900;
              End;
        End; // Case
      If Ky < Length(Cells[9,I]) Then
        If Not (Cells[9,I][Ky] In ['D','M','Y']) Then
          Inc(Ky);   // Pula o separador
      End;
    End;

    Function FormataData : String;
    Begin
    Result := ValCampos[I];
    With StringGrid3 Do
      If Not ((Cells[9,I] <> '') And (Cells[10,I] <> '') And (ValCampos[I] <> '')) Then // Não há formatação especificada ou o campo está vazio...
        Exit;

    Result := '';
    With StringGrid3 Do
      Begin
      RegAux := Cells[9,I];
      While Pos('A',RegAux) <> 0 Do
        RegAux[Pos('A',RegAux)] := 'Y';
      While Pos('a',RegAux) <> 0 Do
        RegAux[Pos('a',RegAux)] := 'Y';
      Cells[9,I] := RegAux;

      RegAux := Cells[10,I];
      While Pos('A',RegAux) <> 0 Do
        RegAux[Pos('A',RegAux)] := 'Y';
      While Pos('a',RegAux) <> 0 Do
        RegAux[Pos('a',RegAux)] := 'Y';
      Cells[10,I] := RegAux;

      Day := 0;
      Month := 0;
      Year := 0;

      Ky := 1;

      AndaNoFormatoAndObtemUmNumero;
      AndaNoFormatoAndObtemUmNumero;
      AndaNoFormatoAndObtemUmNumero;

      Try
        AuxData := EncodeDate(Year,Month,Day);
        Result := FormatDateTime(Cells[10,I],AuxData);
      Except
        ShowMessage('Erro na conversão da data...');
        End;
      End;
    End;

  Begin

  If OrigemDeExecucao = ' ' Then
    Begin
//    FrameForm.Timer10.Enabled := False; // Refresh Timer
//    FrameForm.Timer10.Enabled := True;
    End;
//    FillChar(ValCampos,SizeOf(ValCampos),0); Fode tudo!
  Linha := '';
  For I := 1 to 99 Do
    With StringGrid3 Do
      If Cells[1,I] <> '' Then
        Begin
        Cln := StrToInt(Cells[2,I]);
        If Cells[3,I][1] = '*' Then
          Lin := ILinha-1+StrToInt(Cells[5,I]) // Soma o relativo para pegar a linha certa
        Else
          Lin := StrToInt(Cells[3,I])-1+StrToInt(Cells[5,I]);
//          Lin := ILinha;                             // Merda do Gabriel
        Tam := StrToInt(Cells[4,I]);

        ValCampos[I] := '';
        If Lin < StrPagina.Lines.Count Then
          ValCampos[I] := Copy(StrPagina.Lines[Lin],Cln,Tam);

        If Cells[9,I] <> '' Then
          ValCampos[I] := FormataCX(Copy(StrPagina.Lines[Lin],Cln,Tam));

        Case Cells[6,I][1] Of    { Tratamento de Brancos }
          '0' : ValCampos[I] := SeTiraBranco(ValCampos[I]);
          '1' : ValCampos[I] := TrimRight(ValCampos[I]);
          '2' : ValCampos[I] := TrimLeft(ValCampos[I]);
          '3' : Begin
                End; // Sem Tratamento de Brancos
          '4' : ValCampos[I] := Trim(ValCampos[I]);
          End; // Else

        TestaFiltro(I);
        If (Cells[7,I] = 'S') And (ValCampos[I] = '') Then  // Campo obrigatório está vazio, aborta
            Exit;

        If (Cells[9,I] <> '') And ((Cells[10,I] <> '')) Then
          ValCampos[I] := FormataData;

        If Length(Cells[9,I]) = 0 Then
          If Length(Cells[10,I]) = 1 Then
            Begin
            DecimalSeparator := '.';
            If Cells[8,I] = 'F' Then
              Begin
              RegAux := '';
              For Ky := 1 To Length(ValCampos[I]) Do
                If (ValCampos[I][Ky] In ['0'..'9','+','-',',']) Then
                  RegAux := RegAux + ValCampos[I][Ky];

              Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
              If Posic = 0 Then
                Posic := Pos('-',RegAux);

              If Posic <> 0 Then
                Begin
                AuxStr := RegAux[Posic];
                Delete(RegAux,Posic,1);
                RegAux := AuxStr + RegAux;
                End;

              ValCampos[I] := RegAux;

              If Pos(',',ValCampos[I]) <> 0 Then
                ValCampos[I][Pos(',',ValCampos[I])] := '.';

              End
            Else
            If Cells[8,I] = 'D' Then
              Begin
              RegAux := '';
              For Ky := 1 To Length(ValCampos[I]) Do
                If (ValCampos[I][Ky] In ['0'..'9','+','-','.']) Then
                  RegAux := RegAux + ValCampos[I][Ky];
              Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
              If Posic = 0 Then
                Posic := Pos('-',RegAux);

              If Posic <> 0 Then
                Begin
                AuxStr := RegAux[Posic];
                Delete(RegAux,Posic,1);
                RegAux := AuxStr + RegAux;
                End;

              ValCampos[I] := RegAux;
              End
            Else
            If Cells[8,I] = 'N' Then
              Begin
              RegAux := '';
              For Ky := 1 To Length(ValCampos[I]) Do
                If (ValCampos[I][Ky] In ['0'..'9','+','-']) Then
                  RegAux := RegAux + ValCampos[I][Ky];
              Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
              If Posic = 0 Then
                Posic := Pos('-',RegAux);

              If Posic <> 0 Then
                Begin
                AuxStr := RegAux[Posic];
                Delete(RegAux,Posic,1);
                RegAux := AuxStr + RegAux;
                End;

              ValCampos[I] := RegAux;
              End;

            If Cells[10,I] = 'F' Then    // Formata a Saida como desejado...
              If Pos('.',ValCampos[I]) <> 0 Then
                ValCampos[I][Pos('.',ValCampos[I])] := ',';

            If (ValCampos[I] <> '') And (ValCampos[I][1] In ['+','-']) Then
              Ky := 2
            Else
              Ky := 1;

            While Length(ValCampos[I]) < StrToInt(Cells[4,I]) Do    // Preenche com zeros à esquerda
              Insert('0',ValCampos[I],Ky);

            End;

        if (CheckBox3.Checked) and (trim(Format('%-'+Cells[4,I]+'s',[ValCampos[I]])) <> '')then
          Linha := Linha + Format('%-'+Cells[4,I]+'s',[ValCampos[I]]) + Edit6.Text  // Separador de campos...
        else if not (CheckBox3.Checked) then
          Linha := Linha + Format('%-'+Cells[4,I]+'s',[ValCampos[I]]) + Edit6.Text;
        End
      Else
        Break;

  if (CheckBox3.Checked) then
    begin
    if trim(Linha) <> '' then
      Write(ArqTxt, Linha);
    end
  else
    WriteLn(ArqTxt,Linha);
  End;

(*  Procedure Decripta(Var Buffer : Pointer; Report133CC, Orig : Boolean;
                             QtdBytes : Integer);
  Var
    I, Ind : Integer;
    BufferA : ^TgArr20000 Absolute Buffer;
    Apendix : String;
    ComandoDeCarro,
    AuxTemp,
    Teste : Char;
  Begin
  SetLength(PaginaAcertada,10000);
  SetLength(PaginaNormal,10000);
  I := 1;
  If Report133CC Then
    Begin
    For Ind := 1 To QtdBytes Do
      If ComprimeBrancos Then
        Begin
        If (Byte(BufferA^[Ind]) And $80) = $80 Then
          Begin
          AuxTemp := BufferA^[Ind];
          If Byte(BufferA^[Ind]) = $80 Then
            Teste := #$0
          Else
            Teste := #$80;
          Repeat
            PaginaNormal[I] := ' ';
            Inc(I);
            If I > Length(PaginaNormal) Then
              SetLength(PaginaNormal,Length(PaginaNormal)+10000);
            Dec(AuxTemp);
          Until AuxTemp = Teste;
          End
        Else
          Begin
          PaginaNormal[I] := BufferA^[Ind];
          Inc(I);
          If I > Length(PaginaNormal) Then
            SetLength(PaginaNormal,Length(PaginaNormal)+10000);
          End;
        End
      Else
        Begin
        PaginaNormal[I] := BufferA^[Ind];
        Inc(I);
        If I > Length(PaginaNormal) Then
          SetLength(PaginaNormal,Length(PaginaNormal)+10000);
        End;
    SetLength(PaginaNormal,I-1); // Ajusta o tamanho certo
    If Orig Then
      PaginaAcertada := PaginaNormal
    Else
      Begin
      Apendix := '';
      PaginaAcertada[1] := ' ';
      I := 2;
      For Ind := 2 To Length(PaginaNormal) Do
//      If PaginaNormal[Ind-1] = #10 Then
        If (PaginaNormal[Ind-1] = #10) And (PaginaNormal[Ind] <> #13) Then // É Comando de carro, vai tratar...
          Begin
          If Apendix <> '' Then
            Begin
            PaginaAcertada[I] := #13;
            Inc(I);
            If I > Length(PaginaAcertada) Then
              SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
            PaginaAcertada[I] := #10;
            Inc(I);                 // := PaginaAcertada + Apendix; // Se colocou uma linha After
            If I > Length(PaginaAcertada) Then
              SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
            End;
          Apendix := '';
          ComandoDeCarro := PaginaNormal[Ind];
          If ComandoDeCarro = '0' Then
            Begin
            PaginaAcertada[I] := #13;
            Inc(I);
            If I > Length(PaginaAcertada) Then
              SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
            PaginaAcertada[I] := #10;
            Inc(I);                 // Uma Linha Before
            If I > Length(PaginaAcertada) Then
              SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
            End
          Else
            If ComandoDeCarro = '-' Then
              Apendix := CrLf;
          PaginaAcertada[I] := ' ';
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End
        Else
          Begin
          PaginaAcertada[I] := PaginaNormal[Ind];
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End;
      SetLength(PaginaAcertada,I-1); // Ajusta
      End;
    End
  Else
    Begin
    For Ind := 1 To QtdBytes Do
      If ComprimeBrancos Then
        Begin
        If (Byte(BufferA^[Ind]) And $80) = $80 Then
          Begin
          AuxTemp := BufferA^[Ind];
          If Byte(BufferA^[Ind]) = $80 Then
            Teste := #$0
          Else
            Teste := #$80;
          Repeat
            PaginaAcertada[I] := ' ';
            Inc(I);
            If I > Length(PaginaAcertada) Then
              SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
            Dec(AuxTemp);
          Until AuxTemp = Teste;
          End
        Else
          Begin
          PaginaAcertada[I] := BufferA^[Ind];
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          End;
        End
      Else
        Begin
        PaginaAcertada[I] := BufferA^[Ind];
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
        End;
    SetLength(PaginaAcertada,I-1); // Ajusta o tamanho
    PaginaNormal := PaginaAcertada;
    End;
  End;    *)

(*Procedure GetPaginaDoRel(Pagina : Integer; Orig : Boolean);
Var
  FileHandle,
  QtdBytesPagRel,
  Erro,
  Im,
  EEE,
  Inicio32,
  Fim32 : Integer;
  Integer64,
  Inicio64,
  Fim64 : Int64;
  RetVal : String;
  //varPag : OleVariant;
  varPag : Variant;
  V : Variant;
Begin
If RelRemoto Then
  Begin
  With FrameForm Do
    Begin
    //RetVal := WebConnection1.AppServer.GetPagina(LogInRemotoForm.UsuEdit.Text,
    //                                             LogInRemotoForm.PassEdit.Text,
    //                                             ConnectionID,
    //                                             Filename,
    //                                             Pagina,
    //                                             EEE,
    //                                             varPag);

    //RetVal := (formGeral.HTTPRIO1 as MulticoldServer).GetPagina(ws, ws, i, ws, i, i, v);


    RetVal := (formGeral.HTTPRIO1 as MulticoldServer).GetPagina(LogInRemotoForm.UsuEdit.Text,
                                                 LogInRemotoForm.PassEdit.Text,
                                                 ConnectionID,
                                                 Filename,
                                                 Pagina,
                                                 EEE,
                                                 varPag);


    V := VarArrayCreate([1,EEE], varByte);
    V := varPag;

    ReallocMem(BufI,EEE); { Allocates only the space needed }
    ReallocMem(Buffer,EEE); // Temporariamente para a conversão.....

    For Im := 1 To EEE Do
      Byte(BufferA^[Im]) := V[Im-1];

    Move(BufferA^,BufI^,EEE); { Moves only the buffer To decompress }
    ReallocMem(Buffer,0); { DeAllocates }
//    If Not DecompressBuf(BufI,EEE,0,MDIEdit.Buffer,QtdBytesPagRel) Then
//      ShowMessage('Erro de descompressão da página...');
    Try
      ZDecompress(BufI, EEE, MDIEdit.Buffer, QtdBytesPagRel, 0);
    Except
      On E: Exception Do
        Begin
        ShowMessage('Erro de descompressão da página...'+#13#10+e.Message);
        End;
      End; // Try
    End;
  End
Else
  Begin
  If Pagina64 Then
    Begin
    Seek(ArqPag64,Pagina-1);
    Read(ArqPag64,Inicio64);
    {$i-}
    Read(ArqPag64,Fim64);
    {$i+}
    If IoResult <> 0 Then
      Fim64 := FileSize(Arq);
    End
  Else
    Begin
    Seek(ArqPag32,Pagina-1); // Usa Inicio32 apenas para o I/O
    Read(ArqPag32,Inicio32);
    Inicio64 := Inicio32;
    {$i-}
    Read(ArqPag32,Fim32);
    {$i+}
    If IoResult <> 0 Then
      Fim64 := FileSize(Arq)
    Else
      Fim64 := Fim32;
    End;

  If Inicio64 <= MaxInt Then
    Begin
    If Pagina64 Then
      Seek(Arq,Inicio64+1) // Must consider the offset
    Else
      Seek(Arq,Inicio64);
    ReallocMem(BufI,Fim64-Inicio64); { Allocates only the space needed }
    BlockRead(Arq,BufI^,Fim64-Inicio64,Erro); { Read only the buffer To decompress }
    ReallocMem(Buffer,0); { DeAllocates }
//    If Not DecompressBuf(BufI,Fim64-Inicio64,0,MDIEdit.Buffer,QtdBytesPagRel) Then
//      ShowMessage('Erro de descompressão da página...');
    Try
      ZDecompress(BufI, Fim64-Inicio64, MDIEdit.Buffer, QtdBytesPagRel, 0);
    Except
      On E: Exception Do
        Begin
        ShowMessage('Erro de descompressão da página...'+e.message);
        End;
      End; // Try
    End
  Else
    Begin
    FileHandle := FileOpen(FileName, fmShareDenyNone);
    FileSeek(FileHandle,0,0);
    Integer64 := Inicio64;
    If Pagina64 Then
      Inc(Integer64);
    While Integer64 > MaxInt Do
      Begin
      FileSeek(FileHandle,MaxInt,1);
      Dec(Integer64,MaxInt);
      End;
    FileSeek(FileHandle,Integer64,1);
    ReallocMem(BufI,Fim64-Inicio64); { Allocates only the space needed }
    FileRead(FileHandle,BufI^,Fim64-Inicio64);
    ReallocMem(Buffer,0); { DeAllocates }
//    If Not DecompressBuf(BufI,Fim64-Inicio64,0,Buffer,QtdBytesPagRel) Then
//      ShowMessage('Erro de descompressão da página...');
    Try
      ZDecompress(BufI, Fim64-Inicio64, Buffer, QtdBytesPagRel, 0);
    Except
      On E: Exception Do
        Begin
        ShowMessage('Erro de descompressão da página...');
        End;
      End; // Try
    FileClose(FileHandle);
    End;
  End;

//Decripta(Buffer, PaginaAcertada, PaginaNormal, Report133CC, Orig, QtdBytesPagRel);
Decripta(Buffer, Report133CC, Orig, QtdBytesPagRel);

End;     *)

Begin
If (OrigemDeExecucao = 'I') Then
//  Decripta(BufI, PagAcertada, PagNormal, (TipoQuebra=1), False,Length(Pagina))
  TEditForm(FrameForm.ActiveMDIChild).Decripta(BufI, (TipoQuebra=1), False,Length(Pagina))
//  Decripta(BufI, (TipoQuebra=1), False,Length(Pagina))
Else
//  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, PagNormal, PagAcertada, False);
  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, False);
//  GetPaginaDoRel(I, False);

StrPagina.Lines.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada;
//StrPagina.Lines.Text := PaginaAcertada;

If LinFin <= (StrPagina.Lines.Count) Then
  LinFinal := LinFin
Else
  LinFinal := StrPagina.Lines.Count;

For ILinha := LinIni To LinFinal Do
  RodaScript;

if (CheckBox3.Checked) then // Força quebra de linha
  Write(ArqTxt,#13#10);

End;

Procedure TFrmExtract.ExecutarButtonClick(Sender: TObject);

Var
  I : Integer;

  Procedure Inicializa;
  Var
    I, J : Integer;
    opcaoAux : Word;
    
  Begin

  For I := 1 To 99 Do
    Begin
    For J := 0 To 1 Do
      StringGrid1.Cells[J,I] := Trim(StringGrid1.Cells[J,I]);
    For J := 0 To 2 Do
      StringGrid2.Cells[J,I] := Trim(StringGrid2.Cells[J,I]);
    For J := 1 To 10 Do
      StringGrid3.Cells[J,I] := Trim(StringGrid3.Cells[J,I]);
    For J := 1 To 3 Do
      StringGrid4.Cells[J,I] := Trim(StringGrid4.Cells[J,I]);
    End;

  AssignFile(ArqTxt,SaveDialog2.FileName);

  If (OrigemDeExecucao <> 'I') And FileExists(SaveDialog2.FileName) Then
    //If MessageDlg('Arquivo já Existe, Continua?', mtWarning,[mbYes,mbNo],0) In [mrCancel, mrNo] Then
    //  Exit;
    begin
    opcaoAux := MessageDlg('O arquivo informado já existe. Deseja substituir o arquivo atual com os dados desta descompactação ? '+#13#10+
                           'Clique: [Yes] para substituir; [No] para adcionar novos dados ao arquivo existente; [Cancel] para cancelar a operação.', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    if opcaoAux = mrYes then
      begin
      deleteFile(SaveDialog2.FileName);
      reWrite(ArqTxt);
      end
    else if opcaoAux = mrNo then
      append(ArqTxt)
    else
      exit
    end
  else
    reWrite(ArqTxt);

  PgIni := StrToInt(Edit1.Text);
  If Copy(Edit2.Text,1,1) = '*' Then
    If OrigemDeExecucao = 'I' Then
      PgFin := MaxInt
    Else
      PgFin := TEditForm(FrameForm.ActiveMDIChild).Paginas
  Else
    PgFin := StrToInt(Edit2.Text);

  LinIni := StrToInt(Edit3.Text);
  If Copy(Edit4.Text,1,1) = '*' Then
    LinFin := 99999
  Else
    LinFin := StrToInt(Edit4.Text);

  Filtro := TFiltro.Create;
  FillChar(ChrIncFil,SizeOf(ChrIncFil),0);
  FillChar(StrIncFil,SizeOf(StrIncFil),0);
  FillChar(ChrExcFil,SizeOf(ChrExcFil),0);
  FillChar(StrExcFil,SizeOf(StrExcFil),0);
  IChrInc := 1;
  IStrInc := 1;
  IChrExc := 1;
  IStrExc := 1;

  For I := 1 To 99 Do
    If StringGrid4.Cells[1,I] = '' Then
      Break
    Else
      Begin
      For J := 1 To 99 Do
        If StringGrid3.Cells[1,J] = '' Then
          Break
        Else
          If StringGrid3.Cells[1,J] = StringGrid4.Cells[1,I] Then  // Achou o campo
            If StringGrid4.Cells[2,I] = 'CHARINC' Then
              Begin
              ChrIncFil[IChrInc].ICampo := J;
              Filtro.EncheFiltro(StringGrid4.Cells[3,I],StringGrid4.Cells[1,I],ChrIncFil[IChrInc].Filtro,J);
              Inc(IChrInc);
              Break;
              End
            Else
            If StringGrid4.Cells[2,I] = 'STRINC' Then
              Begin
              StrIncFil[IStrInc].ICampo := J;
              Filtro.EncheStr(StringGrid4.Cells[3,I],StringGrid4.Cells[1,I],StrIncFil[IStrInc].Filtro,J);
              Inc(IStrInc);
              Break;
              End
            Else
            If StringGrid4.Cells[2,I] = 'CHAREXC' Then
              Begin
              ChrExcFil[IChrExc].ICampo := J;
              Filtro.EncheFiltro(StringGrid4.Cells[3,I],StringGrid4.Cells[1,I],ChrExcFil[IChrExc].Filtro,J);
              Inc(IChrExc);
              Break;
              End
            Else
            If StringGrid4.Cells[2,I] = 'STREXC' Then
              Begin
              StrExcFil[IStrExc].ICampo := J;
              Filtro.EncheStr(StringGrid4.Cells[3,I],StringGrid4.Cells[1,I],StrExcFil[IStrExc].Filtro,J);
              Inc(IStrExc);
              Break;
              End;
      End;

  Filtro.Free;

  //ReWrite(ArqTxt);
  ProgressBar1.Max := PgFin;
  ProgressBar1.Min := PgIni;

  Apendix := '';               // Obtem e grava o nome dos campos no primeiro registro do arquivo
  For I := 1 To 99 Do
    With StringGrid3 Do
      If Cells[1,I] <> '' Then
        Begin
        StrTam := Cells[4,I];
        If Length(Cells[10,I]) <> 0 Then
          If Length(Cells[10,I]) <> 1 Then
            If Length(Cells[10,I]) > Length(Cells[9,I]) Then
              If Length(Cells[10,I]) > StrToInt(Cells[4,I]) Then
                If Length(Cells[10,I]) > StrToInt(StrTam) Then // Se a reformatação é maior, dá mais espaço...
                  StrTam := IntToStr(Length(Cells[10,I]));
        If CheckBox2.Checked Then                             // Incluir o tamanho do separador...
          StrTam := IntToStr(StrToInt(StrTam) + Length(Edit6.Text));
        Apendix := Apendix + Format('%-'+StrTam+'s',[Copy(Cells[1,I],1,StrToInt(Cells[4,I]))]);
        End
      Else
        Break;

  If CheckBox1.Checked Then     // Soltar linha de cabeçalho
    WriteLn(ArqTxt,Apendix);

  End;

Begin
If OrigemDeExecucao = 'I' Then
  Begin
  Inicializa;
  Exit;
  End;

If Length(TEditForm(FrameForm.ActiveMDIChild).ArrBloqCamposDoRel) <> 0 Then
  Begin
  ShowMessage('Você tem bloqueio de campos neste relatório, não poderá extrair dados...');
  Exit;
  End;

If SaveDialog2.Execute Then
  Begin
  Inicializa;
  For I := PgIni To PgFin Do
    Begin
    TrabalhaADescompactacao(I);
    ProgressBar1.Position := I;
    End;
  try
    CloseFile(ArqTxt);
  except
  end;

                      { Back To the original place }
  If Not TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
    If TEditForm(FrameForm.ActiveMDIChild).Pagina64 Then
      Begin
      Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag64,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
      Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag64);
      End
    Else
      Begin
      Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag32,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
      Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag32);
      End;

  ProgressBar1.Position := PgIni;
  Application.ProcessMessages;

  ShowMessage('Fim de extração');

  End;
End;

Procedure TFrmExtract.Edit5DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
QHelp.Label1.Caption := 'Descrição do script';
QHelp.Label2.Caption := 'Para melhor o caracterizar e identificar';
QHelp.ShowModal;
End;

Procedure TFrmExtract.Edit1DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
QHelp.Label1.Caption := 'Página onde o processo de extração de dados deve se iniciar';
QHelp.ShowModal;
End;

Procedure TFrmExtract.Edit2DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
QHelp.Label1.Caption := 'Página final do processo de extração de dados';
QHelp.Label2.Caption := 'Use "*" para indicar a última página do relatório';
QHelp.ShowModal;
End;

Procedure TFrmExtract.StringGrid1DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
QHelp.Label1.Caption := 'Sem função';
QHelp.ShowModal;
End;

Procedure TFrmExtract.StringGrid2DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
QHelp.Label1.Caption := 'Sem função';
QHelp.ShowModal;
End;

Procedure TFrmExtract.Edit3DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
QHelp.Label1.Caption := 'Linha do relatório onde o processo de extração de dados deve se iniciar';
QHelp.ShowModal;
End;

Procedure TFrmExtract.Edit4DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
QHelp.Label1.Caption := 'Linha final do processo de extração de dados';
QHelp.Label2.Caption := 'Use "*" para indicar a última linha da página do relatório';
QHelp.ShowModal;
End;

procedure TFrmExtract.StringGrid3DblClick(Sender: TObject);
Begin
QHelp.CleanTheMess;
Case StringGrid3.Col of
  1 : Begin
      QHelp.Label1.Caption := 'Nome do Campo';
      QHelp.ShowModal;
      End;
  2 : Begin
      QHelp.Label1.Caption := 'Coluna no relatório onde o campos se inicia';
      QHelp.ShowModal;
      End;
  3 : Begin
      QHelp.Label1.Caption := 'Linha onde se encontra o campo';
      QHelp.Label2.Caption := 'Se o campo está em mais de uma linha do relatório, use "*"';
      QHelp.Label3.Caption := 'dessa forma os dados serão extraídos de acordo com a informação';
      QHelp.Label4.Caption := 'do range de linhas acima';
      QHelp.ShowModal;
      End;
  4 : Begin
      QHelp.Label1.Caption := 'Tamanho do campo, número de caracteres a serem extraídos';
      QHelp.ShowModal;
      End;
  5 : Begin
      QHelp.Label1.Caption := 'Deslocamento em relação à linha corrente';
      QHelp.Label2.Caption := 'Desta maneira é possível extrair os dados de uma linha acima ou abaixo da linha corrente';
      QHelp.ShowModal;
      End;
  6 : Begin
      QHelp.Label1.Caption := 'Tratamento dos Brancos do Campo a ser Exportado';
      QHelp.Label2.Caption := '0 - Retira Todos os Brancos do Campo';
      QHelp.Label3.Caption := '1 - Retira os Brancos do Final do Campo';
      QHelp.Label4.Caption := '2 - Retira os Brancos do Início do Campo';
      QHelp.Label5.Caption := '3 - Nenhum Tratamento de Brancos';
      QHelp.Label6.Caption := '4 - Retira os Brancos do Início e do Final do Campo';
      QHelp.ShowModal;
      End;
  7 : Begin
      QHelp.Label1.Caption := 'Use "S" quando o campo for obrigatório e "N" quando não for obrigatório';
      QHelp.Label2.Caption := 'Quando o campo é obrigatório e, por alguma razão, seu conteúdo for vazio';
      QHelp.Label3.Caption := 'a linha do registro resultante da extração será desprezada';
      QHelp.ShowModal;
      End;
  8 : Begin
      QHelp.Label1.Caption := 'Tipo do Campo a ser Trabalhado';
      QHelp.Label2.Caption := 'C - Caracter';
      QHelp.Label3.Caption := 'N - Numérico';
      QHelp.Label4.Caption := 'F - Ponto Flutuante -> Numérico com Decimais ( , -> Real )';
      QHelp.Label5.Caption := 'D - Ponto Flutuante -> Numérico com Decimais ( . -> Dollar )';
      QHelp.ShowModal;
      End;
  9 : Begin
      QHelp.Label1.Caption := 'Máscara do campo como está representada no relatório ( Data e/ou Hora )';
      QHelp.Label2.Caption := 'AAAA = Ano com 4 dígitos, AA = ano com 2 dígitos, MM = mês e DD = dia';
      QHelp.Label3.Caption := 'HH = hora, NN = minuto e SS = segundo ';
      QHelp.Label4.Caption := 'Ex.: DD/MM/AA, DD/MM/AAAA, HH:NN:SS ';
      QHelp.Label5.Caption := 'Use o tipo de campo = C, juntamente com a máscara de entrada';
      QHelp.ShowModal;
      QHelp.Label1.Caption := 'Máscara do campo como está representada no relatório ( Geral )';
      QHelp.Label2.Caption := 'C = Caracter desejado; X = Caracter a ser rejeitado';
      QHelp.Label3.Caption := 'Ex.: CCCCXCCCCXCCCCXCCCC ';
      QHelp.Label4.Caption := '';
      QHelp.Label5.Caption := '';
      QHelp.ShowModal;
      End;
 10 : Begin
      QHelp.Label1.Caption := 'Máscara do campo do relatório como deverá ser exportado ( Data e/ou Hora )';
      QHelp.Label2.Caption := 'AAAA = Ano com 4 dígitos, AA = ano com 2 dígitos, MM = mês e DD = dia';
      QHelp.Label3.Caption := 'HH = hora, NN = minuto e SS = segundo ';
      QHelp.Label4.Caption := 'Ex.: DD/MM/AA, DD/MM/AAAA, HH:NN:SS ';
      QHelp.Label5.Caption := 'Se o campo de entrada for F ou D, coloque aqui o tipo de saída: F ou D ';
      QHelp.Label6.Caption := 'caso deseje eliminar a formatação e/ou alterar o ponto flutuante gerado';
      QHelp.ShowModal;
      End;
  End; // Case
End;

procedure TFrmExtract.StringGrid4DblClick(Sender: TObject);
begin
QHelp.CleanTheMess;
Case StringGrid4.Col of
  1 : Begin
      QHelp.Label1.Caption := 'Nome do Campo';
      QHelp.ShowModal;
      End;
  2 : Begin
      QHelp.Label1.Caption := 'Tipo da Regra de Filtragem do Campo:';
      QHelp.Label2.Caption := 'CHARINC - Únicos Caracteres Aceitos no Campo';
      QHelp.Label3.Caption := 'STRINC - String existente na linha a ser indexada';
      QHelp.Label4.Caption := 'CHAREXC - Caracteres NÃO Aceitos no Campo';
      QHelp.Label5.Caption := 'STREXC - String existente na linha a ser rejeitada';
      QHelp.ShowModal;
      End;
  3 : Begin
      QHelp.Label1.Caption := 'Detalhamento da regra de filtragem especificada no campo anterior';
      QHelp.ShowModal;
      End;
  End; // Case
End;

procedure TFrmExtract.CheckBox2Click(Sender: TObject);
begin
Edit6.Visible := CheckBox2.Checked;
end;

End.
