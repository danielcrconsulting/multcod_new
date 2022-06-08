Unit MExtract;

//Revisado SQLServer...

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ComCtrls, Mdiedit, MdiMultiCold, Subrug, SuGeral, SuTypGer, Qhelpu,
  ZLib, LogInForm, Data.DB, Datasnap.DBClient, ADODB;


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
    FAbrirTemplateRemoto: Boolean;
    FTemplateFilename: String;
    procedure SalvarExtracaoNoBanco;
    function Compactar(s: String): String;
    function Descompactar(s: String): String;
  Public
    { Public declarations }
    OrigemDeExecucao : AnsiChar;

    Cln,
    Lin,
    Tam,
    IChrInc,
    IStrInc,
    IChrExc,
    IStrExc,
    IStrInCampo,
    IStrTroca,
    LinIni,
    LinFin,
    LinFinal,
    PgIni,
    PgFin,
    PosSep : Integer;
    ArqTxt : System.Text;
    NomeArqTxt,
  //  PagNormal,
  //  PagAcertada,
    Linha,
    LinhaAux,
    Apendix,
    StrTam : AnsiString;
    ValCampos : Array[1..99] Of AnsiString;
    ValMemoria : Array[1..99] Of AnsiString;
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
    StrInCampo : Array[1..99] Of Record
                                ICampo : Integer;
                                Filtro : TgStrStr;
                                End;
    StrTroca  : Array[1..99] Of Record
                                ICampo : Integer;
                                Filtro : TgStrStr;
                                End;

    // variáveis usadas pelo indexador
    OperacaoExtract,
    DirDestinoExtract : AnsiString;

    StrPagina : TStringList;

    Procedure LeScript(FileName : AnsiString);

    Procedure TrabalhaADescompactacao(I : Int64);

    procedure AbrirTemplateCompactado(aTemplateCompactado: AnsiString);

  End;

Var
  FrmExtract: TFrmExtract;
  IndexFrmExtract : Array[1..1000] Of TFrmExtract;
  Xyz : Integer;
  ErroFatal : Boolean;

Implementation

uses
  UFrmConsultaExportacoesRemoto;

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

if Edit2.Text <> '*' Then
  try
    if StrToInt(Edit1.Text) > StrToInt(Edit2.Text) then
      begin
      ShowMessage('Página final menor que a inicial...');
      exit;
      end;
  except
    end; // try

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

procedure TFrmExtract.SalvarExtracaoNoBanco;
var
  arquivo: TStringList;
  I, J: Integer;
  arqComp, sql: String;
  templateId: Integer;

  procedure SaveToDatabase;
  begin
    sql := ' INSERT INTO TemplateExportacao   ' +
           ' (                                ' +
           ' CODUSUARIO,                      ' +
           ' NomeTemplate,                    ' +
           ' ArquivoTemplateComp              ' +
           ' )                                ' +
           ' VALUES                           ' +
           ' (                                ' +
           QuotedStr(LogInRemotoForm.UsuEdit.Text) + ', ' +
           QuotedStr(Edit5.Text) + ', ' +
           QuotedStr(arqComp)           +
           ' )';

    FormGeral.Persistir(sql, nil);
    //FormGeral.ADOCmdInsert.Parameters.ParamValues['CODUSUARIO'] := LogInRemotoForm.UsuEdit.Text;
    //FormGeral.ADOCmdInsert.Parameters.ParamValues['NomeTemplate'] := Edit5.Text;
    //FormGeral.ADOCmdInsert.Parameters.ParamValues['ArquivoTemplateComp'] := arqComp;

    //FormGeral.ADOCmdInsert.Execute;

    sql := 'select max(Id) Id from TemplateExportacao';
    //FormGeral.ADOQryGetId.Open;
    FormGeral.ImportarDados(sql,nil);
    if FormGeral.memtb.Active then
    begin
      templateId := FormGeral.memtb.FieldByName('Id').AsInteger;
      FormGeral.memtb.Close;
    end;
    //templateId := FormGeral.ADOQryGetId.FieldByName('Id').AsInteger;
    //FormGeral.ADOQryGetId.Close;

    sql := ' insert into ProcessadorExtracao  ' +
           ' (                                             ' +
           ' IdTemplateExportacao,                         ' +
           ' TipoProcessamento,                            ' +
           ' PathRelatorio                                 ' +
           ' )                                             ' +
           ' values                                        ' +
           ' (                                             ' +
            IntToStr(templateId)                       + ',' +
           ' 1,'                                             +
           QuotedStr(TEditForm(FrameForm.ActiveMdiChild).Filename) +
           ')' ;
    //FormGeral.ADOCmdInsertExection.Parameters.ParamValues['IdTemplateExportacao'] := templateId;
    //FormGeral.ADOCmdInsertExection.Parameters.ParamValues['TipoProcessamento'] := 1;
    //FormGeral.ADOCmdInsertExection.Parameters.ParamValues['PathRelatorio'] := TEditForm(FrameForm.ActiveMdiChild).Filename;
    //FormGeral.ADOCmdInsertExection.Execute;
    FormGeral.Persistir(sql, nil);
  end;

begin
  arquivo := TStringList.Create;
  try
    arquivo.add('XTRFILEV4');
    arquivo.add(Edit5.Text);
    If CheckBox1.Checked Then   // V3
      arquivo.add('S')
    Else
      arquivo.add('N');
    If CheckBox2.Checked Then   // V3
      arquivo.add('S')
    Else
      arquivo.add('N');

    arquivo.add(Edit6.Text);    // V3
    arquivo.add(Edit1.Text);
    arquivo.add(Edit2.Text);
    arquivo.add(Edit3.Text);
    arquivo.add(Edit4.Text);
    if CheckBox3.Checked then // V4
      arquivo.add('S')
    Else
      arquivo.add('N');

    For I := 1 To 99 Do
      Begin
      For J := 0 To 1 Do
        arquivo.add(Trim(StringGrid1.Cells[J,I]));
      For J := 0 To 2 Do
        arquivo.add(Trim(StringGrid2.Cells[J,I]));
      For J := 1 To 10 Do
        arquivo.add(Trim(StringGrid3.Cells[J,I]));
      For J := 1 To 3 Do
        arquivo.add(Trim(StringGrid4.Cells[J,I]));
      End;

      //arqComp := Compactar(arquivo.Text);
      arqComp := arquivo.Text;
      SaveToDatabase;

  finally
    FreeAndNil(arquivo);
  end;
end;

Procedure TFrmExtract.LeScript(FileName : AnsiString);
Var
  Arq : System.Text;
  I,J,
  NCol : Integer;
  Versao,
  Linha : AnsiString;
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
  if FAbrirTemplateRemoto then
  begin
    LeScript(FTemplateFilename);
    FAbrirTemplateRemoto := false;
    exit;
  end;


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
StrPagina := TStringList.Create;
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

Procedure TFrmExtract.TrabalhaADescompactacao(I : Int64);

Var
  ILinha : Integer;

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
                If Copy(StrPagina[Lin],Col,Tam) <> FilStr Then      // Simulando um OR
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
                If Copy(StrPagina[Lin],Col,Tam) = FilStr Then
                  ValCampos[I] := '';    { Conteúdo igual a linha a ser excluida }
//            Break; // Parar assim que realizar a primeira checagem
          End;

  For J := 1 To 99 Do
    With StrInCampo[J] Do
      If ICampo = 0 Then
        Break
      Else
        If ICampo = I Then
          Begin
          If ValCampos[I] <> '' Then
            With Filtro Do
              If Col <> 0 Then
                Insert(FilStr, ValCampos[I], Col);
//                ValCampos[I].Insert(Col-1, FilStr);
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
    AuxStr,
    TamSaida : AnsiString;
    AuxData : TDateTime;
    y : TFormatSettings;

    Function FormataCX(ParEntra : AnsiString) : AnsiString;
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
    Var
      cmpAux : AnsiString;
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
      Try
      Case Ori[1] Of
        'D' : Day := StrToInt(RegAux);
        'M' : if Length(RegAux) = 3 then
                begin
                cmpAux := UpperCase(RegAux);
                if cmpAux = 'JAN' then Month := 1
                else
                if (cmpAux = 'FEV') or
                   (cmpAux = 'FEB') then Month := 2
                else
                if cmpAux = 'MAR' then Month := 3
                else
                if (cmpAux = 'ABR') or
                   (cmpAux = 'APR') then Month := 4
                else
                if (cmpAux = 'MAI') or
                   (cmpAux = 'MAY') then Month := 5
                else
                if cmpAux = 'JUN' then Month := 6
                else
                if cmpAux = 'JUL' then Month := 7
                else
                if (cmpAux = 'AGO') or
                   (cmpAux = 'AUG') then Month := 8
                else
                if (cmpAux = 'SET') or
                   (cmpAux = 'SEP') then Month := 9
                else
                if (cmpAux = 'OUT') or
                   (cmpAux = 'OCT') then Month := 10
                else
                if cmpAux = 'NOV' then Month := 11
                else
                if (cmpAux = 'DEZ') or
                   (cmpAux = 'DEC') then Month := 12
                else
                  Month := StrToInt(RegAux);
                end
              else
                Month := StrToInt(RegAux);
        'Y' : Begin
              Year := StrToInt(RegAux);
              If Length(RegAux) = 2 Then
                If Year <= 50 Then
                  Year := Year + 2000
                Else
                  Year := Year + 1900;
              End;
        End; // Case
      Except
      End; //Try
      If Ky < Length(Cells[9,I]) Then
        If Not (Cells[9,I][Ky] In ['D','M','Y']) Then
          Inc(Ky);   // Pula o separador
      End;
    End;

    Function FormataData : AnsiString;

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
      Year := 9999;

      Ky := 1;

      AndaNoFormatoAndObtemUmNumero;
      AndaNoFormatoAndObtemUmNumero;
      AndaNoFormatoAndObtemUmNumero;

      if Day = 0 then
        begin
          ShowMessage('Erro na formatação do dia : '+Cells[1,I]);
          Exit;
        end;
      if Month = 0 then
        begin
          ShowMessage('Erro na formatação do mês : '+Cells[1,I]);
          Exit;
        end;
      if Year = 9999 then
        begin
          ShowMessage('Erro na formatação do ano : '+Cells[1,I]);
          Exit;
        end;

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
        Tam := StrToInt(Cells[4,I]);

        ValCampos[I] := '';
        If Lin < StrPagina.Count Then
          ValCampos[I] := Copy(StrPagina[Lin],Cln,Tam);

        If Cells[9,I] <> '' Then
          ValCampos[I] := FormataCX(Copy(StrPagina[Lin],Cln,Tam));

        Case Cells[6,I][1] Of    { Tratamento de Brancos Antes de formatar}
          '0' : ValCampos[I] := SeTiraBranco(ValCampos[I]);
          '1' : ValCampos[I] := TrimRight(ValCampos[I]);
          '2' : ValCampos[I] := TrimLeft(ValCampos[I]);
          '3' : Begin
                End; // Sem Tratamento de Brancos
          '4' : ValCampos[I] := Trim(ValCampos[I]);
          End; // Case

        TestaFiltro(I);

        If (Cells[7,I] = 'C') Then  // Campo de carga, guarda na memória
          if ValCampos[I] <> '' then
            ValMemoria[I] := ValCampos[I]
          else                                  // ou carrega da memória
            ValCampos[I] := ValMemoria[I];

        If (Cells[7,I] = 'S') And (ValCampos[I] = '') Then  // Campo obrigatório está vazio, aborta
            Exit;

        If (Cells[9,I] <> '') And ((Cells[10,I] <> '')) Then
          begin
          ValCampos[I] := FormataData;
          if ValCampos[I] = '' then
            begin
            ErroFatal := True;
            Break;
            end;
          end;

        If Length(Cells[9,I]) = 0 Then
          If Length(Cells[10,I]) = 1 Then
            Begin
            y.DecimalSeparator := '.';
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

        TamSaida :=  Cells[4,I];
        if Length(Edit6.Text) <> 0 then
          TamSaida := IntToStr(Length(ValCampos[I]));

        if (CheckBox3.Checked) and (trim(Format('%-'+Cells[4,I]+'s',[ValCampos[I]])) <> '')then
          Linha := Linha + Format('%-'+TamSaida+'s',[ValCampos[I]]) + Edit6.Text  // Separador de campos...
        else if not (CheckBox3.Checked) then
          Linha := Linha + Format('%-'+TamSaida+'s',[ValCampos[I]]) + Edit6.Text;
        End
      Else
        Break;
  if (CheckBox3.Checked) then
    begin
    if trim(Linha) <> '' then
      Write(ArqTxt, Linha);
    end
  else
    begin
    LinhaAux := Linha;                       //Safe copy
    PosSep := Pos(Edit6.Text, LinhaAux);
    While (Length(LinhaAux) <> 0) and (PosSep <> 0) do
      Begin
      Delete(LinhaAux, PosSep, Length(Edit6.Text));
      PosSep := Pos(Edit6.Text, LinhaAux);
      End;
    LinhaAux := Trim(LinhaAux);
    if LinhaAux <> '' then   // Romero em 28/03/2013
      WriteLn(ArqTxt,Linha);
    end;
  End;

Begin
If (OrigemDeExecucao = 'I') Then
//    Decripta(BufI, PagAcertada, PagNormal, (TipoQuebra=1), False,Length(Pagina))
  TEditForm(FrameForm.ActiveMDIChild).Decripta(BufI, (TipoQuebra=1), False,Length(PaginaAnt))
Else
//    TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, PagNormal, PagAcertada, False);
  TEditForm(FrameForm.ActiveMDIChild).GetPaginaDoRel(I, False,'','','','','', '');

StrPagina.Text := TEditForm(FrameForm.ActiveMDIChild).PaginaAcertada;
                                                   
If LinFin <= (StrPagina.Count) Then
  LinFinal := LinFin
Else
  LinFinal := StrPagina.Count;

For ILinha := LinIni To LinFinal Do
  begin
  RodaScript;
  if ErroFatal then
    Break;
  end;

if (CheckBox3.Checked) then // Força quebra de linha
  Write(ArqTxt,#13#10); 


End;

Procedure TFrmExtract.ExecutarButtonClick(Sender: TObject);

Var
  I : Integer;
  urlBase: String;

  Procedure Inicializa;
  Var
    I, J : Integer;
    opcaoAux : Word;
    
  Begin
  ErroFatal := False;

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
  FillChar(StrTroca,SizeOf(StrTroca),0);
  FillChar(StrInCampo,SizeOf(StrInCampo),0);
  IChrInc := 1;
  IStrInc := 1;
  IChrExc := 1;
  IStrExc := 1;
  IStrInCampo := 1;
  IStrTroca := 1;

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
              End            
            Else
            If StringGrid4.Cells[2,I] = 'STRTROCA' Then
              Begin
              StrTroca[IStrTroca].ICampo := J;
              Filtro.EncheStr(StringGrid4.Cells[3,I],StringGrid4.Cells[1,I],StrTroca[IStrTroca].Filtro,J);
              Inc(IStrTroca);
              Break;
              End            
            Else
            If StringGrid4.Cells[2,I] = 'STRINCAMPO' Then
              Begin
              StrInCampo[IStrInCampo].ICampo := J;
              Filtro.EncheStr(StringGrid4.Cells[3,I],StringGrid4.Cells[1,I],StrInCampo[IStrInCampo].Filtro,J);
              Inc(IStrInCampo);
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
//          StrTam := IntToStr(StrToInt(StrTam) + Length(Edit6.Text));                    // -----------------> Agora vamos incluir o separador de campos no cabeçalho
          Apendix := Apendix + Cells[1,I] + Edit6.Text
        else                 //
          begin
          Edit6.Text := '';  // Romero em 28/03/2013 -> Evitar a inclusão do separador quando CheckBox2 = False, mas Edit6 <> ''
          Apendix := Apendix + Format('%-'+StrTam+'s',[Copy(Cells[1,I],1,StrToInt(Cells[4,I]))]);
          end
        End
      Else
        Break;

  If CheckBox1.Checked Then     // Soltar linha de cabeçalho
    WriteLn(ArqTxt,Apendix);

  End;

Begin
  if TEditForm(FrameForm.ActiveMDIChild).RelRemoto then
  begin
    SalvarExtracaoNoBanco;
    Close;
    urlBase := FrameForm.ObterUrlBase;

    FrmConsultaExportacoesRemoto.SetParameters(LogInRemotoForm.UsuEdit.Text, urlBase);
    FrmConsultaExportacoesRemoto.Show;

    exit;
  end;


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
    if ErroFatal then
      Break;
    End;
  try
    CloseFile(ArqTxt);
  except
  end;

                      { Back To the original place }
  If Not TEditForm(FrameForm.ActiveMDIChild).RelRemoto Then
    Begin
    Seek(TEditForm(FrameForm.ActiveMDIChild).ArqPag64,TEditForm(FrameForm.ActiveMDIChild).PaginaAtu - 1);
    Seek(TEditForm(FrameForm.ActiveMDIChild).Arq,TEditForm(FrameForm.ActiveMDIChild).RegPag64);
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
      QHelp.Label1.Caption := 'Use "S" quando o campo for obrigatório, "N" quando não for obrigatório ou' ;
      QHelp.Label2.Caption := '"C" quando o valor deste campo deverá ser carregado na memória para descarga ' ;
      QHelp.Label3.Caption := 'junto com uma linha posterior' ;
      QHelp.Label4.Caption := 'Quando o campo é obrigatório e, por alguma razão, seu conteúdo for vazio';
      QHelp.Label5.Caption := 'a linha do registro resultante da extração será desprezada';
      QHelp.Label6.Caption := 'IMPORTANTE: TODOS OS CAMPOS "C" DEVEM VIM ANTES DOS TIPO "S"';
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
      QHelp.Label2.Caption := 'AAAA = Ano com 4 dígitos, AA = 2 dígitos, MM = mês, MMM = mês literal e DD = dia';
      QHelp.Label3.Caption := 'HH = hora, NN = minuto e SS = segundo ';
      QHelp.Label4.Caption := 'Ex.: DD/MM/AA, DD/MM/AAAA, HH:NN:SS ';
      QHelp.Label5.Caption := 'Use o tipo de campo = C, juntamente com a máscara de entrada';
      QHelp.ShowModal;
      QHelp.Label1.Caption := 'Máscara do campo como está representada no relatório ( Geral )';
      QHelp.Label2.Caption := 'C = Caracter desejado; X = Caracter a ser rejeitado';
      QHelp.Label3.Caption := 'Ex.: CCCCXCCCCXCCCCXCCCC ';
      QHelp.Label4.Caption := 'Se Usar T, O caracter no relatório será trocado pelo próximo caracter informado';
      QHelp.Label5.Caption := 'Se MMM for usado, significa que o mês é literal. Ex.: NOV';
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
      QHelp.Label3.Caption := 'STRINC - AnsiString existente na linha a ser extraída';
      QHelp.Label4.Caption := 'CHAREXC - Caracteres NÃO Aceitos no Campo';
      QHelp.Label5.Caption := 'STREXC - AnsiString existente na linha a ser rejeitada';
      QHelp.Label6.Caption := 'STRINCAMPO - AnsiString a ser inserida no campo';
      QHelp.ShowModal;
      End;
  3 : Begin
      QHelp.Label1.Caption := 'Detalhamento da regra de filtragem especificada no campo anterior';
      QHelp.Label2.Caption := 'CHARINC - ''a..z'',''0'',''%''';
      QHelp.Label3.Caption := 'STRINC - Col,Tam=''str''';
      QHelp.Label4.Caption := 'CHAREXC - ''a..z'',''0'',''%''';
      QHelp.Label5.Caption := 'STREXC - Col,Tam=''str''';
      QHelp.Label6.Caption := 'STRINCAMPO - Col,Tam=''str''';
      QHelp.ShowModal;
      End;
  End; // Case
End;

procedure TFrmExtract.AbrirTemplateCompactado(aTemplateCompactado: AnsiString);
var
  templateDescompactado: AnsiString;
  Arq : System.Text;
  MyGuid : TGUID;
  outputFile: String;
begin
  LimparButton.Click; // Limpar
  //templateDescompactado := Descompactar(aTemplateCompactado);
  templateDescompactado := aTemplateCompactado;
  if CreateGUID(MyGuid) = 0 then
    outputFile := GetCurrentDir + '\' + StringReplace(StringReplace(GUIDToString(MyGuid),'{','', [rfReplaceAll]),'}','', [rfReplaceAll]) + '.txt';

  AssignFile(Arq, outputFile);
  ReWrite(Arq);

  WriteLn(Arq, templateDescompactado);
  CloseFile(Arq);

  FAbrirTemplateRemoto := true;
  FTemplateFilename := outputFile;

  AbrirButtonClick(self);

  DeleteFile(outputFile);
end;

procedure TFrmExtract.CheckBox2Click(Sender: TObject);
begin
Edit6.Visible := CheckBox2.Checked;
end;

function TFrmExtract.Compactar(s: String): String;
var
  strInput,
  strOutput: TStringStream;
  strInputNew : tmemorystream;
  Zipper: TZCompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(s);
  strInputNew:= Tmemorystream.Create;
  strInputNew.LoadFromStream(strInput);
  strOutput:= TStringStream.Create;
  try
    Zipper:= TZCompressionStream.Create(strOutput);
    try
      Zipper.CopyFrom(strInputNew, strInputNew.Size);
    finally
      Zipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

function TFrmExtract.Descompactar(s: String): String;
var
  strInput,
  strOutput: TStringStream;
  Unzipper: TZDecompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(s);
  strOutput:= TStringStream.Create;
  try
    Unzipper:= TZDecompressionStream.Create(strInput);
    try
      strOutput.CopyFrom(Unzipper, Unzipper.Size);
    finally
      Unzipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

End.
