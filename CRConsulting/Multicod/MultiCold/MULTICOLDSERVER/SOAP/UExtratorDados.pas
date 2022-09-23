unit UExtratorDados;

interface

uses
  UMulticoldReport, UMulticoldFunctions, UMulticoldMigrate, System.Classes,
  SysUtils, SuTypGer, Generics.Collections;

  type
    TTipoDescompactacao = (tdPaginaAtual, tdPesquisa, tdIntervalo, tdFull);

    TDescompactadorOptions = class
    strict private
      FTipoDescompactacao: TTipoDescompactacao;
      FApenasLinhasPesquisa,
      FRemoverBrancos: Boolean;
      FIntervaloIni,
      FIntervaloFin,
      FIndexPaginaAtual: Integer;
    public
      property TipoDescompactacao: TTipoDescompactacao read FTipoDescompactacao write FTipoDescompactacao;
      property ApenasLinhasPesquisa: Boolean read FApenasLinhasPesquisa write FApenasLinhasPesquisa;
      property RemoverBrancos: Boolean read FRemoverBrancos write FRemoverBrancos;
      property IntervaloIni: integer read FIntervaloIni write FIntervaloIni;
      property IntervaloFin: Integer read FIntervaloFin write FIntervaloFin;
      property IndexPaginaAtual: integer read FIndexPaginaAtual write FIndexPaginaAtual;
    end;

    TDescompactador = class (TObject)
    strict protected
      FMulticoldManager: TMulticoldManager;
      FDescompactadorOptions: TDescompactadorOptions;
      FArqTxt : System.Text;

      procedure InitFile(aOutputFile: String);
      procedure EndFile;
      function RemoverBrancos(APagina: WideString): WideString;
      procedure ProcessarPagina(pagIndex: Integer); virtual;
    public
      Constructor Create(aMulticoldManager: TMulticoldManager; aDescompactadorOptions: TDescompactadorOptions);
      procedure Processar(aOutputFile: String); virtual;
    end;

    TDescompactadorPaginaAtual = class(TDescompactador)
      procedure Processar(aOutputFile: String);  override;
    end;

    TDescompactadorPesquisa = class(TDescompactador)
    strict private
      function LinhasDaPesquisa: WideString;
    strict protected
      procedure ProcessarPagina(pagIndex: Integer); override;
    public
      procedure Processar(aOutputFile: String);  override;
    end;

    TDescompactadorIntervalo = class(TDescompactador)
      procedure Processar(aOutputFile: String);  override;
    end;

    TDescompactadorFull = class(TDescompactador)
      procedure Processar(aOutputFile: String);  override;
    end;

    TDescompactadorFactory = class
    public
      class function ObterDescompactador(aMulticoldManager: TMulticoldManager; aDescompactadorOptions: TDescompactadorOptions): TDescompactador;
    end;

    TExtratorDados = class (TObject)
    strict private
      FMulticoldReport: TMulticoldReport;
      FNomeTemplate: String;
      FPagini,
      FPagFin,
      FLinIni,
      FLinFin: String;
      FCabecalho,
      FSeparador,
      FPagParaColuna: Boolean;
      FCharSeparador: String;
      FCells1,
      FCells2,
      FCells3,
      FCells4: array of array of string;
      FFiltro : TFiltro;
      FChrIncFil : Array[1..99] Of Record
                                    ICampo : Integer;
                                    Filtro : SetOfChar;
                                    End;
      FStrIncFil : Array[1..99] Of Record
                                    ICampo : Integer;
                                    Filtro : TgStrStr;
                                    End;
      FChrExcFil : Array[1..99] Of Record
                                    ICampo : Integer;
                                    Filtro : SetOfChar;
                                    End;
      FStrExcFil : Array[1..99] Of Record
                                    ICampo : Integer;
                                    Filtro : TgStrStr;
                                    End;
      FStrInCampo : Array[1..99] Of Record
                                    ICampo : Integer;
                                    Filtro : TgStrStr;
                                    End;
      FStrTroca  : Array[1..99] Of Record
                                    ICampo : Integer;
                                    Filtro : TgStrStr;
                                    End;

      FValCampos : Array[1..99] Of AnsiString;
      FValMemoria : Array[1..99] Of AnsiString;


      FIChrInc,
      FIStrInc,
      FIChrExc,
      FIStrExc,
      FIStrInCampo,
      FIStrTroca: Integer;
      FApendix,
      FStrTam: AnsiString;
      FArqTxt : System.Text;
      FMensagens,
      FPaginaAtual: TStringList;

      function GetPagIni: Integer;
      function GetPagFin: Integer;
      function GetLinIni: Integer;
      function GetLinFin: Integer;

      procedure CarregarTemplate(template: String);
      procedure Inicializa(outputFile: String);
      Procedure RodaScript(ILinha: Integer);
      procedure ProcessarPagina(aPag: Integer);
    public
      Constructor Create(aTemplate: String; aMulticoldReport:  TMulticoldReport);
      Destructor Destroy; override;

      procedure Processar(aOutputFile: String);
    end;

implementation

{ TExtratorDados }

procedure TExtratorDados.CarregarTemplate(template: String);
Var
  Arq : System.Text;
  I,J,
  NCol,
  Idx : Integer;
  Versao,
  Linha : AnsiString;
  listaTemplate: TStringList;

  procedure IncLinha;
  begin
    Inc(Idx);
    if idx < (listaTemplate.Count-1) then
      linha := listaTemplate[Idx];
  end;

Begin
  Idx := 0;
  listaTemplate := TStringList.Create;
  try
    listaTemplate.Text := template;
    linha := listaTemplate[Idx];

    Versao := linha;
    If (Versao = 'XTRFILEV2') Or (Versao = 'XTRFILEV3') or (Versao = 'XTRFILEV4') Then
    Begin
      IncLinha;
      NCol := 10;
    End
    Else
      NCol := 7;

    FNomeTemplate := Linha;
    IncLinha;

    If (Versao = 'XTRFILEV3') or (Versao = 'XTRFILEV4') Then
      Begin
        FCabecalho := UpperCase(Linha) = 'S';

        IncLinha;
        FSeparador :=  UpperCase(Linha) = 'S';

        IncLinha;
        FCharSeparador := Linha;

        IncLinha;
      End
    Else
      Begin
        FCabecalho := True;
        FSeparador := False;
        FCharSeparador := '';
      End;

    FPagIni := Linha;
    IncLinha;
    FPagFin := Linha;
    IncLinha;
    FLinIni := linha;
    IncLinha;
    FLinFin := Linha;

    if (Versao = 'XTRFILEV4') then
      begin
        IncLinha;
        FPagParaColuna := upperCase(Linha) = 'S';
      end;

    SetLength(FCells1,99,2);
    SetLength(FCells2,99,3);
    SetLength(FCells3,99,NCol);
    SetLength(FCells4,99,4);

    For I := 0 To 98 Do
    Begin
      if idx > (listaTemplate.Count-1) then
      begin
        break;
        idx := idx;
      end;
      For J := 0 To 1 Do
        Begin
        IncLinha;
        FCells1[I,J] := Trim(Linha);
        End;
      For J := 0 To 2 Do
        Begin
        IncLinha;
        FCells2[I,J] := Trim(Linha);
        End;
      For J := 0 To NCol-1 Do
        Begin
        IncLinha;
        FCells3[I,J] := Trim(Linha);
        End;
      For J := 0 To 2 Do
        Begin
        IncLinha;
        FCells4[I,J] := Trim(Linha);
        End;
    End;

  finally
    FreeAndNil(listaTemplate);
  end;
end;

constructor TExtratorDados.Create(aTemplate: String; aMulticoldReport:  TMulticoldReport);
begin
  FMulticoldReport := aMulticoldReport;
  CarregarTemplate(aTemplate);
  FMensagens := TStringList.Create();
  FPaginaAtual := TStringList.Create();
end;


destructor TExtratorDados.Destroy;
begin
  FreeAndNil(FPaginaAtual);
  FreeAndNil(FMensagens);
  inherited;
end;

function TExtratorDados.GetLinFin: Integer;
begin
  If Copy(FLinFin,1,1) = '*' Then
    Result := 99999
  Else
    Result := StrToInt(FLinFin);
end;

function TExtratorDados.GetLinIni: Integer;
begin
  Result := StrToInt(FLinIni);
end;

function TExtratorDados.GetPagFin: Integer;
begin
  If Copy(FPagFin,1,1) = '*' Then
    Result := FMulticoldReport.QtdePaginas
  else
    Result := StrToint(FPagFin);
end;

function TExtratorDados.GetPagIni: Integer;
begin
  Result := StrToInt(FPagIni);
end;

Procedure TExtratorDados.Inicializa(outputFile: String);
Var
  I, J : Integer;
  opcaoAux : Word;

Begin
  AssignFile(FArqTxt, outputFile);
  reWrite(FArqTxt);

  FMensagens.Clear;
  FFiltro := TFiltro.Create(FMensagens);
  try

  FillChar(FChrIncFil,SizeOf(FChrIncFil),0);
  FillChar(FStrIncFil,SizeOf(FStrIncFil),0);
  FillChar(FChrExcFil,SizeOf(FChrExcFil),0);
  FillChar(FStrExcFil,SizeOf(FStrExcFil),0);
  FillChar(FStrTroca,SizeOf(FStrTroca),0);
  FillChar(FStrInCampo,SizeOf(FStrInCampo),0);
  FIChrInc := 1;
  FIStrInc := 1;
  FIChrExc := 1;
  FIStrExc := 1;
  FIStrInCampo := 1;
  FIStrTroca := 1;

  For I := 0 To 98 Do
    If FCells4[I,0] = '' Then
      Break
    Else
      Begin
      For J := 0 To 98 Do
        If FCells3[J,0] = '' Then
          Break
        Else
          If FCells3[J,0] = FCells4[I,0] Then  // Achou o campo
            If FCells4[I,1] = 'CHARINC' Then
            Begin
                FChrIncFil[FIChrInc].ICampo := J;
                FFiltro.EncheFiltro(FCells4[I,2],FCells4[I,0],FChrIncFil[FIChrInc].Filtro,J);
                Inc(FIChrInc);
                Break;
            End
            Else If FCells4[I,1] = 'STRINC' Then
            Begin
              FStrIncFil[FIStrInc].ICampo := J;
              FFiltro.EncheStr(FCells4[I,2],FCells4[I,0],FStrIncFil[FIStrInc].Filtro,J);
              Inc(FIStrInc);
              Break;
            End
            Else If FCells4[I,1] = 'CHAREXC' Then
            Begin
              FChrExcFil[FIChrExc].ICampo := J;
              FFiltro.EncheFiltro(FCells4[I,2],FCells4[I,0],FChrExcFil[FIChrExc].Filtro,J);
              Inc(FIChrExc);
              Break;
            End
            Else If FCells4[I,1] = 'STREXC' Then
            Begin
              FStrExcFil[FIStrExc].ICampo := J;
              FFiltro.EncheStr(FCells4[I,2],FCells4[I,0],FStrExcFil[FIStrExc].Filtro,J);
              Inc(FIStrExc);
              Break;
            End
            Else If FCells4[I,1] = 'STRTROCA' Then
            Begin
              FStrTroca[FIStrTroca].ICampo := J;
              FFiltro.EncheStr(FCells4[I,2],FCells4[I,0],FStrTroca[FIStrTroca].Filtro,J);
              Inc(FIStrTroca);
              Break;
            End
            Else If FCells4[I,1] = 'STRINCAMPO' Then
            Begin
              FStrInCampo[FIStrInCampo].ICampo := J;
              FFiltro.EncheStr(FCells4[I,2],FCells4[I,0],FStrInCampo[FIStrInCampo].Filtro,J);
              Inc(FIStrInCampo);
              Break;
            End;
      End;

  finally
    FFiltro.Free;
  end;


  FApendix := '';               // Obtem e grava o nome dos campos no primeiro registro do arquivo
  For I := 0 To 98 Do
  begin
      If FCells3[I,0] <> '' Then
      Begin
        FStrTam := FCells3[I,3];
        If Length(FCells3[I,9]) <> 0 Then
          If Length(FCells3[I,9]) <> 1 Then
            If Length(FCells3[I,9]) > Length(FCells3[I,8]) Then
              If Length(FCells3[I,9]) > StrToInt(FCells3[I,3]) Then
                If Length(FCells3[I,9]) > StrToInt(FStrTam) Then // Se a reformatação é maior, dá mais espaço...
                  FStrTam := IntToStr(Length(FCells3[I,9]));

        If FSeparador Then
          FApendix := FApendix + FCells3[I,0] + FCharSeparador
        else
        begin
          FCharSeparador := '';
          FApendix := FApendix + Format('%-'+FStrTam+'s',[Copy(FCells3[I,0],1,StrToInt(FCells3[I,3]))]);
        end

      End
      Else
        Break;
  end;

  If FCabecalho Then     // Soltar linha de cabeçalho
    WriteLn(FArqTxt, FApendix);

End;

procedure TExtratorDados.Processar(aOutputFile: String);
var
  i,
  pagIni,
  pagFin: Integer;

begin
  Inicializa(aOutputFile);
  FMulticoldReport.NavegarParaPagina(1);

  pagIni := GetpagIni();
  pagFin := getPagFin();

  for I := pagIni to pagFin do
  begin
    ProcessarPagina(i);
  end;

  CloseFile(FArqTxt);
end;

procedure TExtratorDados.ProcessarPagina(aPag: Integer);
var
  linFin,
  linIni,
  ILinha: Integer;

begin
  FMulticoldReport.NavegarParaPagina(aPag);
  FPaginaAtual.Text := FMulticoldReport.PaginaDescompactada;
  linFin := GetLinFin;
  linIni := GetLinIni;

  If LinFin <= (FPaginaAtual.Count) Then
    linFin := LinFin
  Else
    linFin := FPaginaAtual.Count;

  for ILinha := LinIni To linFin Do
  begin
    RodaScript(ILinha);
  end;

  if (FPagParaColuna) then
    Write(FArqTxt, #13#10);
end;

procedure TExtratorDados.RodaScript(ILinha: Integer);
var
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
    Cln,
    Lin,
    Tam,
    PosSep: Integer;
    Linha,
    LinhaAux: AnsiString;

    Function TestaFiltro(I : Integer) : Boolean;
    Var
      J, K: Integer;
      Preserva,
      Testou : Boolean;
    Begin
      For J := 1 To 99 Do
        With FChrIncFil[J] Do
          If (ICampo = 0) Then
            Break
          Else
            If ICampo = I Then
              Begin
              For K := 1 To Length(FValCampos[I]) Do
                If Not (FValCampos[I][K] In Filtro) Then
                  Begin
                  FValCampos[I] := '';
                  Break;
                  End;
              Break; // Parar assim que realizar a primeira checagem
              End;

      Preserva := False;
      Testou := False;
      For J := 1 To 99 Do
        With FStrIncFil[J] Do
          If (ICampo = 0) AND (Filtro.FilStr = '') Then
            Break
          Else
            If ICampo = I Then
              Begin
              Testou := True;
              If FValCampos[I] <> '' Then
                With Filtro Do
                  If Col <> 0 Then
                    If Copy(FPAginaAtual[Lin],Col,Tam) <> FilStr Then      // Simulando um OR
                      Begin
    //                    ValCampos[I] := '';    { Conteudo difere da linha a ser incluida }
                      End
                    Else
                      Preserva := True;
    //            Break; // Parar assim que realizar a primeira checagem
              End;

      If Testou Then
        If Not Preserva Then  // Algum campo salvou o conteúdo ............
            FValCampos[I] := '';    { Conteudo difere da linha a ser incluida }

      For J := 1 To 99 Do
        With FChrExcFil[J] Do
          If ICampo = 0 Then
            Break
          Else
            If ICampo = I Then
              Begin
              For K := 1 To Length(FValCampos[I]) Do
                If (FValCampos[I][K] In Filtro) Then
                Begin
                  FValCampos[I] := '';
                  Break;
                End;
    //            Break; // Parar assim que realizar a primeira checagem
              End;

      For J := 1 To 99 Do
        With FStrExcFil[J] Do
          If ICampo = 0 Then
            Break
          Else
            If ICampo = I Then
              Begin
              If FValCampos[I] <> '' Then
                With Filtro Do
                  If Col <> 0 Then
                    If Copy(FPaginaAtual[Lin],Col,Tam) = FilStr Then
                      FValCampos[I] := '';    { Conteúdo igual a linha a ser excluida }
    //            Break; // Parar assim que realizar a primeira checagem
              End;

      For J := 1 To 99 Do
        With FStrInCampo[J] Do
          If ICampo = 0 Then
            Break
          Else
            If ICampo = I Then
              Begin
              If FValCampos[I] <> '' Then
                With Filtro Do
                  If Col <> 0 Then
                    Insert(FilStr, FValCampos[I], Col);
    //                ValCampos[I].Insert(Col-1, FilStr);
              End;


      If FValCampos[I] = '' Then
        Result := False
      Else
        Result := True;
    End;


    Function FormataCX(ParEntra : AnsiString) : AnsiString;
    Var
      Ix : Integer;
    Begin
    Result := ParEntra;
      FCells3[I,8] := UpperCase(FCells3[I,8]);
      RegAux := FCells3[I,8];
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

    Procedure AndaNoFormatoAndObtemUmNumero;
    Var
      cmpAux : AnsiString;
    Begin
      If Ky > Length(FCells3[I,8]) Then
        Exit;
      Ori := FCells3[I,8][Ky];
      RegAux := '';
      While (Length(FCells3[I,8]) >= Ky) And (FCells3[I,8][Ky] = Ori) Do
        Begin
        RegAux := RegAux + FValCampos[I][Ky];
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
      If Ky < Length(FCells3[I,8]) Then
        If Not (FCells3[I,8][Ky] In ['D','M','Y']) Then
          Inc(Ky);   // Pula o separador
    End;

    Function FormataData : AnsiString;
    Begin
      Result := FValCampos[I];
      If Not ((FCells3[I,8] <> '') And (FCells3[I,9] <> '') And (FValCampos[I] <> '')) Then // Não há formatação especificada ou o campo está vazio...
        Exit;

      Result := '';

      RegAux := FCells3[I,8];
      While Pos('A',RegAux) <> 0 Do
        RegAux[Pos('A',RegAux)] := 'Y';
      While Pos('a',RegAux) <> 0 Do
        RegAux[Pos('a',RegAux)] := 'Y';
      FCells3[I,8] := RegAux;

      RegAux := FCells3[I,9];
      While Pos('A',RegAux) <> 0 Do
        RegAux[Pos('A',RegAux)] := 'Y';
      While Pos('a',RegAux) <> 0 Do
        RegAux[Pos('a',RegAux)] := 'Y';
      FCells3[I,9] := RegAux;

      Day := 0;
      Month := 0;
      Year := 9999;

      Ky := 1;

      AndaNoFormatoAndObtemUmNumero;
      AndaNoFormatoAndObtemUmNumero;
      AndaNoFormatoAndObtemUmNumero;

      if Day = 0 then
        begin
          FMensagens.Add('Erro na formatação do dia : '+FCells3[I,0]);
          Exit;
        end;
      if Month = 0 then
        begin
          FMensagens.Add('Erro na formatação do mês : '+FCells3[I,0]);
          Exit;
        end;
      if Year = 9999 then
        begin
          FMensagens.Add('Erro na formatação do ano : '+FCells3[I,0]);
          Exit;
        end;

      Try
        AuxData := EncodeDate(Year,Month,Day);
        Result := FormatDateTime(FCells3[I,9],AuxData);
      Except
        FMensagens.Add('Erro na conversão da data...');
        End;

    End;

Begin
    Linha := '';
    For I := 0 to 98 Do
    begin
        If FCells3[I,0] <> '' Then
        Begin
          Cln := StrToInt(FCells3[I,1]);

          If FCells3[I,2][1] = '*' Then
          begin
            Lin := ILinha-1+StrToInt(FCells3[I,4]);
          end else
          begin
            Lin := StrToInt(FCells3[I,2])-1+StrToInt(FCells3[I,4]);
          end;
          Tam := StrToInt(FCells3[I,3]);

          FValCampos[I] := '';
          If Lin < FPaginaAtual.Count Then
            FValCampos[I] := Copy(FPaginaAtual[Lin],Cln,Tam);

          If FCells3[I,8] <> '' Then
            FValCampos[I] := FormataCX(Copy(FPaginaAtual[Lin],Cln,Tam));

          Case FCells3[I,5][1] Of    { Tratamento de Brancos Antes de formatar}
            '0' : FValCampos[I] := SeTiraBranco(FValCampos[I]);
            '1' : FValCampos[I] := TrimRight(FValCampos[I]);
            '2' : FValCampos[I] := TrimLeft(FValCampos[I]);
            '3' : Begin
                  End; // Sem Tratamento de Brancos
            '4' : FValCampos[I] := Trim(FValCampos[I]);
          End; // Case

          TestaFiltro(I);

          If (FCells3[I,6] = 'C') Then  // Campo de carga, guarda na memória
            if FValCampos[I] <> '' then
              FValMemoria[I] := FValCampos[I]
            else                                  // ou carrega da memória
              FValCampos[I] := FValMemoria[I];

          If (FCells3[I,6] = 'S') And (FValCampos[I] = '') Then  // Campo obrigatório está vazio, aborta
              Exit;

          If (FCells3[I,8] <> '') And ((FCells3[I,9] <> '')) Then
            begin
            FValCampos[I] := FormataData;
            if FValCampos[I] = '' then
            begin
              //ErroFatal := True; Gerar Exception //
              Break;
            end;
            end;

          If Length(FCells3[I,8]) = 0 Then
            If Length(FCells3[I,9]) = 1 Then
            Begin
              y.DecimalSeparator := '.';
              If FCells3[I,7] = 'F' Then
              Begin
                RegAux := '';
                For Ky := 1 To Length(FValCampos[I]) Do
                  If (FValCampos[I][Ky] In ['0'..'9','+','-',',']) Then
                    RegAux := RegAux + FValCampos[I][Ky];

                Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
                If Posic = 0 Then
                  Posic := Pos('-',RegAux);

                If Posic <> 0 Then
                Begin
                  AuxStr := RegAux[Posic];
                  Delete(RegAux,Posic,1);
                  RegAux := AuxStr + RegAux;
                End;

                FValCampos[I] := RegAux;

                If Pos(',',FValCampos[I]) <> 0 Then
                  FValCampos[I][Pos(',',FValCampos[I])] := '.';

              End
              Else
              If FCells3[I,7] = 'D' Then
              Begin
                RegAux := '';
                For Ky := 1 To Length(FValCampos[I]) Do
                  If (FValCampos[I][Ky] In ['0'..'9','+','-','.']) Then
                    RegAux := RegAux + FValCampos[I][Ky];
                Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
                If Posic = 0 Then
                  Posic := Pos('-',RegAux);

                If Posic <> 0 Then
                Begin
                  AuxStr := RegAux[Posic];
                  Delete(RegAux,Posic,1);
                  RegAux := AuxStr + RegAux;
                End;

                FValCampos[I] := RegAux;

              End
              Else
              If FCells3[I,7] = 'N' Then
              Begin
                RegAux := '';
                For Ky := 1 To Length(FValCampos[I]) Do
                  If (FValCampos[I][Ky] In ['0'..'9','+','-']) Then
                    RegAux := RegAux + FValCampos[I][Ky];
                Posic := Pos('+',RegAux);              // Inverter a posição Do Sinal
                If Posic = 0 Then
                  Posic := Pos('-',RegAux);

                If Posic <> 0 Then
                Begin
                  AuxStr := RegAux[Posic];
                  Delete(RegAux,Posic,1);
                  RegAux := AuxStr + RegAux;
                End;

                FValCampos[I] := RegAux;
              End;

              If FCells3[I,9] = 'F' Then    // Formata a Saida como desejado...
                If Pos('.',FValCampos[I]) <> 0 Then
                  FValCampos[I][Pos('.',FValCampos[I])] := ',';

              If (FValCampos[I] <> '') And (FValCampos[I][1] In ['+','-']) Then
                Ky := 2
              Else
                Ky := 1;

              While Length(FValCampos[I]) < StrToInt(FCells3[I,3]) Do    // Preenche com zeros à esquerda
                Insert('0',FValCampos[I],Ky);

            End;

          TamSaida :=  FCells3[I,3];
          if Length(FCharSeparador) <> 0 then
            TamSaida := IntToStr(Length(FValCampos[I]));

          if (FPagParaColuna) and (trim(Format('%-'+FCells3[I,3]+'s',[FValCampos[I]])) <> '')then
            Linha := Linha + Format('%-'+TamSaida+'s',[FValCampos[I]]) + FCharSeparador  // Separador de campos...
          else if not (FPagParaColuna) then
            Linha := Linha + Format('%-'+TamSaida+'s',[FValCampos[I]]) + FCharSeparador;
        End
        Else
          Break;
    end;

    if (FPagParaColuna) then
    begin
      if trim(Linha) <> '' then
        Write(FArqTxt, Linha);
    end
    else
    begin
      LinhaAux := Linha;                       //Safe copy
      PosSep := Pos(FCharSeparador, LinhaAux);
      While (Length(LinhaAux) <> 0) and (PosSep <> 0) do
      Begin
        Delete(LinhaAux, PosSep, Length(FCharSeparador));
        PosSep := Pos(FCharSeparador, LinhaAux);
      End;

      LinhaAux := Trim(LinhaAux);
      if LinhaAux <> '' then
        WriteLn(FArqTxt,Linha);
    end;
End;

{ TDescompactador }

constructor TDescompactador.Create(aMulticoldManager: TMulticoldManager; aDescompactadorOptions: TDescompactadorOptions);
begin
  FMulticoldManager := aMulticoldManager;
  FDescompactadorOptions := aDescompactadorOptions;
end;

procedure TDescompactador.EndFile;
begin
  CloseFile(FArqTxt);
end;

procedure TDescompactador.InitFile(aOutputFile: String);
begin
  AssignFile(FArqTxt, aOutputFile);
  reWrite(FArqTxt);
end;


procedure TDescompactador.Processar(aOutputFile: String);
begin
  InitFile(aOutputFile);
end;

procedure TDescompactador.ProcessarPagina(pagIndex: Integer);
var
  pagina: WideString;
begin
  FMulticoldManager.NavegarParaPagina(pagIndex);

  pagina := RemoverBrancos(FMulticoldManager.PaginaDescompactada);

  WriteLn(FArqTxt, pagina);
end;

function TDescompactador.RemoverBrancos(APagina: WideString): WideString;
var
  ListaPagina,
  outputList: TStringList;
  linIni,
  linFin,
  j: Integer;
  linha,
  output: WideString;

begin
  Result := APagina;
  if FDescompactadorOptions.RemoverBrancos then
  begin
      ListaPagina := TStringList.Create;
      try
        ListaPagina.Clear;
        ListaPagina.Text := APagina;

        linIni := 1;
        linFin := ListaPagina.Count;

        outputList := TStringList.Create;
        try

          for j := linIni to linFin do
          begin
            linha := ListaPagina[j-1];

            if trim(linha) <> '' then
              outputList.Add(linha);
          end;

          Result := outputList.Text;
        finally
          outputList.Free;
        end;

      finally
        ListaPagina.Free;
      end;
  end;
end;

{ TDescompactadorFactory }

class function TDescompactadorFactory.ObterDescompactador(
  aMulticoldManager: TMulticoldManager;
  aDescompactadorOptions: TDescompactadorOptions): TDescompactador;
begin
  case aDescompactadorOptions.TipoDescompactacao of
    tdPaginaAtual: Result := TDescompactadorPaginaAtual.Create(aMulticoldManager, aDescompactadorOptions);
    tdPesquisa: Result := TDescompactadorPesquisa.Create(aMulticoldManager, aDescompactadorOptions);
    tdIntervalo: Result := TDescompactadorIntervalo.Create(aMulticoldManager, aDescompactadorOptions);
    tdFull: Result := TDescompactadorFull.Create(aMulticoldManager, aDescompactadorOptions);
  end;
end;

{ TDescompactadorFull }

procedure TDescompactadorFull.Processar(aOutputFile: String);
var
  pagIni,
  pagFin,
  I: Integer;

begin
  inherited;
  FMulticoldManager.NavegarParaPagina(1);

  pagIni := 1;
  pagFin := FMulticoldManager.QtdePaginas;

  for I := pagIni to pagFin do
  begin
    ProcessarPagina(i);
  end;

  EndFile;
end;

{ TDescompactadorIntervalo }

procedure TDescompactadorIntervalo.Processar(aOutputFile: String);
var
  pagIni,
  pagFin,
  I: Integer;

  procedure ValidarIntervalos;
  begin
    if pagFin > FMulticoldManager.QtdePaginas then
      pagFin := FMulticoldManager.QtdePaginas;

    if pagIni > pagFin then
      pagIni := 1;
  end;

begin
  inherited;
  FMulticoldManager.NavegarParaPagina(1);

  pagIni := FDescompactadorOptions.IntervaloIni;
  pagFin := FDescompactadorOptions.IntervaloFin;
  ValidarIntervalos;

  for I := pagIni to pagFin do
  begin
    ProcessarPagina(i);
  end;

  EndFile;
end;

{ TDescompactadorPesquisa }

function TDescompactadorPesquisa.LinhasDaPesquisa: WideString;
var
  ListaPagina,
  outputList: TStringList;
  linIni,
  linFin,
  j,
  ICmdCar,
  aPartirDe: Integer;
  linha,
  output: WideString;
  LinhasPaginalist: TList<Integer>;


  procedure GetLinhasPagina(pesquisa: TListaResultadoPesquisa; pagIndex: Integer);
  var
    K: Integer;
  begin
    for K := 0 to Length(pesquisa)-1 do
    begin
      if pesquisa[K].Pagina = pagIndex then
        LinhasPaginalist.Add(pesquisa[K].Linha);
    end;
  end;

  procedure VerificarCmdCar(linhaPesquisa: Integer);
  var
    I: integer;
    linhaAnterior: string;
    ListaPaginaOriginal: TStringList;
  begin
    ListaPaginaOriginal := TStringList.Create;
    try
      ListaPaginaOriginal.Text := FMulticoldManager.PaginaOriginal;
      for I := APartirDe to linhaPesquisa-1 do
      begin
        linhaAnterior := ListaPaginaOriginal[i];
        if (Length(linhaAnterior) > 0) and (linhaAnterior[1] = '0') then
          Inc(ICmdCar);
      end;
    finally
      FreeAndNil(ListaPaginaOriginal);
    end;

  end;


begin
  Result := FMulticoldManager.PaginaDescompactada;
  if FDescompactadorOptions.ApenasLinhasPesquisa then
  begin
    ICmdCar := 0;
    LinhasPaginalist := TList<Integer>.Create;
    try
      GetLinhasPagina(FMulticoldManager.Pesquisa, FMulticoldManager.IndexPagina);
      if (LinhasPaginalist.Count = 0) then
      begin
        Result := '';
        exit;
      end;

      ListaPagina := TStringList.Create;
      try
        ListaPagina.Clear;
        ListaPagina.Text := FMulticoldManager.PaginaDescompactada;

        outputList := TStringList.Create;
        try
          aPartirDe := 0;
          for j := 1 to LinhasPaginalist.Count do
          begin
            // @CAMORIM - Implementado o tratamento da Regra chamada de "Comando de Carro." Atualmente essa regra está implementada no Report  //
            // na subprocedure VerifyBefore; dentro do CarregaImagem no Form MDIEdit. //
            VerificarCmdCar(LinhasPaginalist[j-1] -1);
            aPartirDe := LinhasPaginalist[j-1] -1;

            linha := ListaPagina[LinhasPaginalist[j-1] -1 + ICmdCar];
            outputList.Add(linha);
          end;

          Result := outputList.Text;
        finally
          outputList.Free;
        end;

      finally
        ListaPagina.Free;
      end;

    finally
      FreeAndNil(LinhasPaginalist);
    end;
  end;
end;

procedure TDescompactadorPesquisa.Processar(aOutputFile: String);
var
  pagIni,
  pagFin,
  I,
  IdxPaginaReal: Integer;
  PagIndexlist: TList<Integer>;

  procedure ValidarIntervalos;
  begin
    if pagFin > FMulticoldManager.QtdePaginas then
      pagFin := FMulticoldManager.QtdePaginas;

    if pagIni > pagFin then
      pagIni := 1;
  end;

  procedure GetPageList(pesquisa: TListaResultadoPesquisa);
  var
    K: Integer;
  begin
    for K := 0 to Length(pesquisa)-1 do
    begin
      if not PagIndexlist.Contains(pesquisa[K].Pagina) then
         PagIndexlist.Add(pesquisa[K].Pagina);
    end;
  end;

begin
  if not FMulticoldManager.PesquisaAtiva then
    exit;

  inherited;
  PagIndexlist := TList<Integer>.Create;
  try
    GetPageList(FMulticoldManager.Pesquisa);
    FMulticoldManager.NavegarParaPagina(FMulticoldManager.PesquisaPagIndedex);

    for i := 1 to PagIndexlist.Count do
    begin
      IdxPaginaReal := PagIndexlist[i-1];
      FMulticoldManager.NavegarParaPagina(IdxPaginaReal);

      ProcessarPagina(IdxPaginaReal);
    end;

  finally
    FreeAndNil(PagIndexlist);
  end;

  EndFile;
end;

procedure TDescompactadorPesquisa.ProcessarPagina(pagIndex: Integer);
var
  pagina: WideString;
begin
  FMulticoldManager.NavegarParaPagina(pagIndex);

  pagina := LinhasDaPesquisa;
  pagina := RemoverBrancos(pagina);

  if FDescompactadorOptions.RemoverBrancos then
    Write(FArqTxt, pagina)
  else
    WriteLn(FArqTxt, pagina);
end;

{ TDescompactadorPaginaAtual }

procedure TDescompactadorPaginaAtual.Processar(aOutputFile: String);
var
  pagIni,
  pagFin,
  I: Integer;

begin
  inherited;
  FMulticoldManager.NavegarParaPagina(FDescompactadorOptions.IndexPaginaAtual);

  ProcessarPagina(FDescompactadorOptions.IndexPaginaAtual);

  EndFile;
end;

end.
