unit UMulticoldReport;

interface

uses SuTypGer, SuTypMultiCold, Types, SysUtils, System.Classes,
     ZLibEx, Data.Win.ADODB, DBTables, Pilha, Generics.Collections,
     UMulticoldFunctions, UMulticoldMigrate;

  type

    DefinitionsException = class(Exception)
    public
      Constructor Create(message: String);
    end;

    TPesquisa = record
              Index: WideString;
              Campo: WideString;
              Operador: Integer;
              Valor: WideString;
              Conector: Integer;
    End;

    TListaPesquisa = Array of TPesquisa;

    TResultadoPesquisa = Record
               Campo : Char;
               Pagina : Integer;
               Relativo : Integer;
               Linha : Integer;
    end;

    TListaResultadoPesquisa = Array of TResultadoPesquisa;

    TDecriptadorFactory = class;
    TMulticoldDefinicoes = class;
    TMulticoldManager = class;
    TDecriptador = class;

    TTipoBuscaSequencial = ( tbNormal, tbPesquisa );

    TMulticoldReport = Class(TObject)
    strict private
      FFilename: String;
      FQtdePaginas: Integer;
      FQtdeBytesComp: Integer;
      FQtdeBytesDescomp: Integer;
      FPaginaCompactada: WideString;
      FPaginaDescompactada: WideString;
      FIndexPagina: Integer;

      FComprimeBrancos,
      FRel133,
      FRel64,
      FOrig: Boolean;
      FTipoQuebraPagina: Integer;

      function GetPaginaOriginal(): WideString;
    public
      property Filename: String read FFilename;
      property QtdePaginas: Integer read FQtdePaginas;
      property QtdeBytesComp: Integer read FQtdeBytesComp;
      property QtdeBytesDescomp: Integer read FQtdeBytesDescomp;
      property PaginaCompactada: WideString read FPaginaCompactada;
      property PaginaDescompactada: WideString read FPaginaDescompactada;
      property PaginaOriginal: WideString read GetPaginaOriginal;
      property IndexPagina: Integer read FIndexPagina;
      property TipoQuebraPagina: Integer read FTipoQuebraPagina;
      property ComprimeBrancos: Boolean read FComprimeBrancos;
      property Rel133: Boolean read FRel133;
      property Orig: Boolean read FOrig;

      procedure AbrirRelatorio;
      procedure NavegarParaPagina(pIndexPagina: Integer; aForceOriginal: Boolean = false);


      Constructor Create(pFilename: String; Rel133, Rel64, ComprimeBrancos: Boolean; tipoQuebraPagina: Integer; const AOrig: Boolean = false);
      Destructor Destroy; override;
    End;

    TResultadoBuscaSequencial = Class(TObject)
    strict private
      FLocalizou: Boolean;
      FLinhaLocalizada: Integer;
      FColunaLocalizada: Integer;
      FPagina: WideString;
      FIndexPagLoc: Integer;
      FQtdeTotalPag: Integer;
      FIndexPagLocPesq: Integer;
      FQtdeBytesPag: Integer;
    published
      property Localizou: Boolean read FLocalizou write FLocalizou;
      property LinhaLocalizada: Integer read FLinhaLocalizada write FLinhaLocalizada;
      property ColunaLocalizada: Integer read FColunaLocalizada write FColunaLocalizada;
      property Pagina: WideString read FPagina write FPagina;
      property IndexPagLoc: Integer read FIndexPagLoc write FIndexPagLoc;
      property IndexPagLocPesq: Integer read FIndexPagLocPesq write FIndexPagLocPesq;
      property QtdeTotalPag: Integer read FQtdeTotalPag write FQtdeTotalPag;
      property QtdeBytesPag: Integer read FQtdeBytesPag write FQtdeBytesPag;
    End;


    TMulticoldQueryFacil = class(TObject)
    strict private
      FSession: TSession;
      FQuery1: TQuery;
      FQuery2: TQuery;
      FReport: TMulticoldReport;
      FDirSecao: String;
      FPilha: TPilha;
      FReg1,
      FReg2 : TResultadoPesquisa;
      FMaxLin: Integer;
      FrSet : Array[0..4,1..30] of string;
      FArrRegIndice : Array[0..199] Of TgRegDFN;
      FOprnd1,
      FOprnd2 : AnsiString;
      FObjF1,
      FObjF2 : TFileStream;

      procedure DescarregaPilha(strPilha: String; var pResultado: TListaResultadoPesquisa);
      procedure DescarregaAnd;
      procedure DescarregaOr;
      procedure DescarregaSolo(var pResultado: TListaResultadoPesquisa) ;
      procedure FechaArquivoTemp(var Query : TQuery; var Stream : TFileStream; operando : variant);
      procedure AbrirDados(var Query : TQuery; var Stream : TFileStream; objeto : variant);
      function TamanhoDados(var Query : TQuery; var Stream : TFileStream): Int64;
      procedure LeRegistroFileStreamOuQuery(var Query : TQuery; var Stream : TFileStream; var reg : TResultadoPesquisa; var EOF : boolean; campo : String);
      function ConverterOperador(Operador: string) : string;

    public
      Constructor Create(multicoldReport: TMulticoldReport);
      Destructor Destroy; override;

      function ExecutarQueryFacil(pPesquisa: TListaPesquisa; pMensagem: String; var pResultado: TListaResultadoPesquisa): boolean;
    end;

    TZipDescompactador = class(TObject)
    strict private
      FBuffer: Pointer;
      FQtdeBytes: Integer;
    public
      property Buffer: Pointer read FBuffer;
      property QtdeBytes: Integer read FQtdeBytes;
      procedure Descompactar(paginaCompactada: AnsiString; QtdeBytesComp: Integer);
    end;

    TDecriptador = class(TObject)
    strict protected
      FMulticoldReport:  TMulticoldReport;
      FDescompactador: TZipDescompactador;
      FBuffer: Pointer;
      FQtdeBytes: Integer;
      FOrig: Boolean;
    public
      Constructor Create(multicoldReport: TMulticoldReport; const AOrig: Boolean = false); virtual;
      Destructor Destroy; virtual;
      property QtdeBytesDescomp: Integer read FQtdeBytes;
      function Decripta: AnsiString; virtual;
    end;

    TDecriptador133 = class(TDecriptador)
    public
      function Decripta: AnsiString; override;
    end;

    TDecriptadorOutros = class(TDecriptador)
    public
      function Decripta: AnsiString; override;
    end;

    TDecriptadorFactory = class(TObject)
    public
      class function ObterDecriptador(multicoldReport: TMulticoldReport; aForceOriginal: Boolean = false) : TDecriptador;
    end;

    TBuscaSequencial = Class(TObject)
    strict protected
      FMulticoldManager: TMulticoldManager;
      FPagIni,
      FPagFin,
      FLinIni,
      FLinFin,
      FColuna : Integer;
      FValorBusca: WideString;
      FTipoBusca: Integer;
    public
      property PagIni: Integer read FPagIni write FPagIni;
      property PagFin: Integer read FPagFin write FPagFin;
      property LinIni: Integer read FLinIni write FLinIni;
      property LinFin: Integer read FLinFin write FLinFin;
      property Coluna: Integer read FColuna write FColuna;
      property ValorBusca: WideString read FValorBusca write FValorBusca;
      property TipoBusca: Integer read FTipoBusca write FTipoBusca;

      function ExecutarBusca : TResultadoBuscaSequencial; virtual; abstract;
      Constructor Create(MulticoldManager: TMulticoldManager); virtual;
    End;

    TBuscaSequencialPadrao = class(TBuscaSequencial)
    public
      function ExecutarBusca : TResultadoBuscaSequencial; override;
      Constructor Create(MulticoldManager: TMulticoldManager); override;
    end;

    TBuscaSequencialEmPesquisa = class(TBuscaSequencial)
    public
      function ExecutarBusca : TResultadoBuscaSequencial; override;
      Constructor Create(MulticoldManager: TMulticoldManager); override;
    end;

    TBuscaSequencialFactory = class(TObject)
    public
      class function ObterBuscaSequencial(multicoldManager: TMulticoldManager; tipo: integer) : TBuscaSequencial;
    end;

    TMulticoldDefinicoes = class(TObject)
    strict private
      FUsuario: WideString;
      FSenha: WideString;
      FNomeArquivo: WideString;
      FRel133,
      FRel64,
      FComprimeBrancos: Boolean;
      FTipoQuebraPagina: Integer;
      FArrRegIndice : tgRegIndice;

      FDataBaseLocal: TADOConnection;
      FDataBaseEventos: TADOConnection;
      FQueryLocal: TADOQuery;
      FQueryEventos: TADOQuery;

      procedure InsereEventoVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : WideString; Grupo, SubGrupo, CodMens : Integer);
      Function CarregaDadosDefinicoes : Boolean;
    private
      FArDFN : Array Of Record
                 CodRel : String;
                 CodSis,
                 CodGrupo,
                 CodSubGrupo : Integer;
                 GrupoAuto : Boolean;
                 End;
      FArInc : Array Of Record
                       CodUsu : String;
                       CodSis,
                       CodGrupo,
                       CodSubGrupo : Integer;
                       CodRel : String;
                       End;
      FArExc : Array Of Record
                       CodUsu : String;
                       CodSis,
                       CodGrupo,
                       CodSubGrupo : Integer;
                       CodRel : String;
                       End;
      FArSis : Array Of Record
                       CodSis : Integer;
                       NomeSis : String;
                       End;
      FArGrupo : Array Of Record
                         CodSis,
                         CodGrupo : Integer;
                         NomeGrupo : String;
                         End;
      FArSubGrupo : Array Of Record
                            CodSis,
                            CodGrupo,
                            CodSubGrupo : Integer;
                            NomeSubGrupo : String;
                            End;
      FArrSisAux : Array Of Record
                          CodRel : String;
                          CodSis,
                          CodGrupo : Integer;
                          LinI,
                          LinF,
                          Col : Integer;
                          Tipo,
                          CodAux : String;
                          End;

      FArqCNFG : File Of TgRegDFN;
    public
      Constructor Create(usuario, senha, nomeArquivo: WideString);
      Destructor Destroy; override;

      property Rel133: Boolean read FRel133;
      property Rel64: Boolean read FRel64;
      property ComprimeBrancos: Boolean read FComprimeBrancos;
      property NomeArquivo: WideString read FNomeArquivo;
      property TipoQuebraPagina: Integer read FTipoQuebraPagina;

      procedure CarregarDefinicoes;
      procedure CarregarTipoQuebraPagina;
    end;

    TMulticoldManager = class(TObject)
    strict private
      FMulticoldReport: TMulticoldReport;
      FMulticoldDefinicoes: TMulticoldDefinicoes;

      FPesquisa: TListaResultadoPesquisa;
      FPesquisaPagIndedex: Integer;
      FPesquisaAtiva: Boolean;

      function GetIndexPagina: Integer;
      function GetPaginaDescompactada: WideString;
      function GetPaginaCompactada: WideString;
      function GetPaginaOriginal: WideString;
      function GetQtdeBytes: Integer;
      function GetQtdePaginas: Integer;
      function GetFilename: String;
      function GetTipoQuebraPagina: Integer;
      function GetOrig: boolean;
    public
      Constructor Create(Usuario, Senha, NomeArquivo: String; CarregaDefinicoes: Boolean; const AOrig: Boolean = false);
      Destructor Destroy; override;

      property Filename: String read GetFilename;
      property QtdePaginas: Integer read GetQtdePaginas;
      property QtdeBytes: Integer read GetQtdeBytes;
      property PaginaCompactada: WideString read GetPaginaCompactada;
      property PaginaDescompactada: WideString read GetPaginaDescompactada;
      property PaginaOriginal: WideString read GetPaginaOriginal;
      property IndexPagina: Integer read GetIndexPagina;
      property TipoQuebraPagina: Integer read GetTipoQuebraPagina;
      property FormatoOriginal: Boolean read GetOrig;

      property Pesquisa: TListaResultadoPesquisa read FPesquisa;
      property PesquisaAtiva: Boolean read FPesquisaAtiva;
      property PesquisaPagIndedex: Integer read FPesquisaPagIndedex write FPesquisaPagIndedex;

      procedure AbrirRelatorio;
      procedure NavegarParaPagina(pIndexPagina: Integer);
      function  ExecutarBuscaSequencial(pagIni, pagFin, linIni, linFin, coluna: Integer; tipoBusca: Integer; valorBusca: WideString) : TResultadoBuscaSequencial;
      function  ExecutarQueryFacil(pPesquisa: TListaPesquisa; pMensagem: String; var pResultado: TListaResultadoPesquisa): boolean;

      procedure ExecutarExtracaoDados(aTemplate, aOutputFile: String);
    end;

implementation

uses
  UExtratorDados;

{ TMulticoldReport }

procedure TMulticoldReport.AbrirRelatorio;
begin
  NavegarParaPagina(1);
end;

constructor TMulticoldReport.Create(pFilename: String; Rel133, Rel64, ComprimeBrancos: Boolean; tipoQuebraPagina: Integer; const AOrig: Boolean = false);
begin
  inherited Create;
  FFilename := pFilename;
  FComprimeBrancos := ComprimeBrancos;
  FRel133 := Rel133;
  FRel64 := Rel64;
  FTipoQuebraPagina := tipoQuebraPagina;
  FOrig := AOrig;
end;


destructor TMulticoldReport.Destroy;
begin
  inherited;
end;

function TMulticoldReport.GetPaginaOriginal: WideString;
begin
  // Obter a p�gina original de forma for�ada //
  if not Orig then
  begin
    NavegarParaPagina(IndexPagina, true);
    Result := PaginaDescompactada;
    NavegarParaPagina(IndexPagina, false);
  end else
    Result := PaginaDescompactada;
end;

procedure TMulticoldReport.NavegarParaPagina(pIndexPagina: Integer; aForceOriginal: Boolean = false);
Var

  I,
  ContBytes,
  size,
  PagNum,
  Erro,
  QtdBytesPagRel,
  FileHandle : Integer;
  Pag : AnsiString;
  Pagina: WideString;
  ArrBuf : ^TgArr20000;
  ArqPag64 : File Of Int64;
  Arq : File;
  Pag64,
  FimPag64,
  Integer64 : Int64;
  BufI : Pointer;
  Buffer : Pointer;
  decriptador: TDecriptador;
begin
  PagNum := pIndexPagina;
  fileMode := fmShareDenyNone;
  AssignFile(Arq, FFilename);
  Try
    Reset(Arq,1);
  Except
    on e:exception do
    begin
      Exit;
    end;
  End;
  If FileExists(ChangeFileExt(FFilename,'.IAPX')) Then // Novo formato
  Begin
    AssignFile(ArqPag64,ChangeFileExt(FFilename,'.IAPX'));
    Try
      Reset(ArqPag64);
    Except
      on e:exception do
        begin
          //vitX.logaLocal('Erro de abertura IAPX:  '+FFilename+#13#10+e.Message);
          Exit;
        end;
    End; // Try
    Seek(ArqPag64, PagNum - 1);
    Read(ArqPag64, Pag64);
    {$i-}
    Read(ArqPag64, FimPag64);
    {$i+}
    If IoResult <> 0 Then
      FimPag64 := FileSize(Arq);
    FQtdePaginas := FileSize(ArqPag64);
    CloseFile(ArqPag64);
    Seek(Arq, Pag64 + 1); // 1 = OffSet do primeiro byte
  End;
  New(ArrBuf);
  BlockRead(Arq, ArrBuf^, FimPag64 - Pag64, ContBytes); { Read only the buffer To decompress }
  SetLength(Pag, ContBytes*2);
  binToHex(ArrBuf^, PAnsiChar(Pag), ContBytes);
  FQtdeBytesComp := ContBytes*2;
  FPaginaCompactada := Pag;
  FIndexPagina := PagNum;
  decriptador := TDecriptadorFactory.ObterDecriptador(Self, aForceOriginal);
  try
    FPaginaDescompactada := decriptador.Decripta;
    FQtdeBytesDescomp := decriptador.QtdeBytesDescomp;
  finally
    FreeAndNil(decriptador);
  end;
  Dispose(ArrBuf);
end;


{ TBuscaSequencialPadrao }

constructor TBuscaSequencialPadrao.Create(MulticoldManager: TMulticoldManager);
begin
  inherited Create(MulticoldManager);
end;

function TBuscaSequencialPadrao.ExecutarBusca : TResultadoBuscaSequencial;
var
  QtdePaginas: Integer;
  PaginaDescomp, PaginaComp: WideString;
  i, j: Integer;
  QtdeBytes: Integer;
  ListaPagina: TStringList;
  linha: WideString;
  linIni, linFin, L, idx: Integer;

begin
 // @CAMORIM - Aqui ser� implementada a busca sequencial como no cliente. Depois de implementar,
 // ser� necess�rio refatorar para tentar organizar o c�digo da rotina.
 // ***********************************************************************************************
 // 1 - Obter a p�gina de n�mero de acordo com o Objeto "buscaSequencial"
  Result := TResultadoBuscaSequencial.Create();

  QtdePaginas := FMulticoldManager.QtdePaginas;
  QtdeBytes := FMulticoldManager.QtdeBytes;

  ListaPagina := TStringList.Create();
  try
    FMulticoldManager.NavegarParaPagina(1);
    PaginaDescomp := FMulticoldManager.PaginaDescompactada;

    if FPagIni = -1 then
      PagIni := 1
    else
      PagIni := FPagIni;

    if FPagFin = -1 then
      PagFin := FMulticoldManager.QtdePaginas
    else
      PagFin := FPagFin;

    for i := PagIni to PagFin do
    begin
      FMulticoldManager.NavegarParaPagina(i);
      PaginaDescomp := FMulticoldManager.PaginaDescompactada;
      PaginaComp := FMulticoldManager.PaginaCompactada;

      ListaPagina.Clear;
      ListaPagina.Text := PaginaDescomp;

       if (FLinIni = -1) or (FLinIni = 0) then
        linIni := 1
      else
      if (FLinIni <> -1) and (FPagIni = i) then
        linIni := FLinIni
      else
        linIni := 1;

      if linIni > 1 then
        Inc(linIni);
      L := 0;
      idx := 0;
      linha := ListaPagina[idx];
      while Trim(linha) = '' do
      begin
        Inc(L);
        idx := idx + L;
        linha := ListaPagina[idx];
      end;

      linIni := linIni + L;

      if FLinFin = -1 then
        linFin := ListaPagina.Count
      else
        linFin := FLinFin;


      if PagFin > QtdePaginas then
      begin
        // setar uma mensagem de erro e voltar.
        Exit;
      end;

      for j := linIni to linFin do
      begin

        linha := ListaPagina[j-1];

        If Coluna = -1 Then
        Begin
          // BUSCA SEM ESPECIFICA��O DE COLUNA //
          If Pos(ValorBusca, linha) <> 0 Then
          Begin
            Result.Localizou := True;
            Result.LinhaLocalizada := j-1;
            Result.ColunaLocalizada := Pos(ValorBusca, linha);
            Result.Pagina := PaginaComp;
            Result.IndexPagLoc := i;
            Result.QtdeBytesPag := FMulticoldManager.QtdeBytes;
            Result.QtdeTotalPag := FMulticoldManager.QtdePaginas;
            Exit;
          End;
        End Else
        Begin
          // BUSCA COM ESPECIFICA��O DE COLUNA //
          If Copy(linha, Coluna, Length(ValorBusca)) = ValorBusca Then
          Begin
            Result.Localizou := True;
            Result.LinhaLocalizada := j-1;
            Result.ColunaLocalizada := Coluna;
            Result.Pagina := PaginaComp;
            Result.IndexPagLoc := i;
            Result.QtdeBytesPag := FMulticoldManager.QtdeBytes;
            Result.QtdeTotalPag := FMulticoldManager.QtdePaginas;
            Exit;
          End;
        End;


      end;

    end;

  finally
    FreeAndNil(ListaPagina);
  end;

end;

{ TBuscaSequencial }

constructor TBuscaSequencial.Create(MulticoldManager: TMulticoldManager);
begin
  inherited Create;
  FMulticoldManager := MulticoldManager;
end;

{ TMulticoldDefinicoes }

function TMulticoldDefinicoes.CarregaDadosDefinicoes: Boolean;
  Var
    I : Integer;
Begin
  Result := True;

  FQueryLocal.Close;

  FQueryLocal.Sql.Clear;
  FQueryLocal.Sql.Add('SELECT * FROM DFN A');
  FQueryLocal.Sql.Add('ORDER BY A.CODREL ');
  Try
    FQueryLocal.Open;
  Except
    on e:exception do
      begin
//      logaLocal('Erro carregando dados de DFN: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  //While Not dataModule.IBQuery1.Eof Do
  //  dataModule.IBQuery1.Next;   // Estabelecer o recordcount correto
  SetLength(FArDFN, FQueryLocal.RecordCount);
  //dataModule.IBQuery1.Close;
  //dataModule.IBQuery1.Open;
  I := 0;
  While not FQueryLocal.Eof Do
  Begin
    FArDFN[I].CodRel := FQueryLocal.FieldByName('CodRel').AsString;
    FArDFN[I].CodSis := FQueryLocal.FieldByName('CodSis').AsInteger;
    FArDFN[I].CodGrupo := FQueryLocal.FieldByName('CodGrupo').AsInteger;
    FArDFN[I].CodSubGrupo := FQueryLocal.FieldByName('CodSubGrupo').AsInteger;
    FArDFN[I].GrupoAuto := (FQueryLocal.FieldByName('CodGrupAuto').AsString = 'T') Or
                          (FQueryLocal.FieldByName('SubDirAuto').AsString = 'T');
    Inc(I);
    FQueryLocal.Next;
  End;

  FQueryLocal.Close;

  FQueryLocal.Sql.Clear;
  FQueryLocal.Sql.Add('SELECT * FROM USUREL A');
  FQueryLocal.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(FUsuario)+''') AND ');
  FQueryLocal.Sql.Add('      (A.TIPO = ''INC'') ');
  Try
    FQueryLocal.Open;
  Except
    on e:exception do
      begin
//      logaLocal('Erro carregando dados de permiss�o de acesso a relat�rios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  SetLength(FArINC, FQueryLocal.RecordCount);

  I := 0;
  While Not FQueryLocal.Eof Do
  Begin
    FArINC[I].CodUsu := FQueryLocal.FieldByName('CodUsuario').AsString;
    FArINC[I].CodSis := FQueryLocal.FieldByName('CodSis').AsInteger;
    FArINC[I].CodGrupo := FQueryLocal.FieldByName('CodGrupo').AsInteger;
    FArINC[I].CodSubGrupo := FQueryLocal.FieldByName('CodSubGrupo').AsInteger;
    FArINC[I].CodRel := FQueryLocal.FieldByName('CodRel').AsString;
    Inc(I);
    FQueryLocal.Next;
  End;
  FQueryLocal.Close;

  FQueryLocal.Sql.Clear;
  FQueryLocal.Sql.Add('SELECT * FROM USUREL A');
  FQueryLocal.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(FUsuario)+''') AND ');
  FQueryLocal.Sql.Add('      (A.TIPO = ''EXC'') ');
  Try
    FQueryLocal.Open;
  Except
    on e:exception do
      begin
//      logaLocal('Erro carregando dados de nega��o de acesso a relat�rios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  SetLength(FArEXC, FQueryLocal.RecordCount);

  I := 0;
  While not FQueryLocal.Eof Do
  Begin
    FArEXC[I].CodUsu := FQueryLocal.FieldByName('CodUsuario').AsString;
    FArEXC[I].CodSis := FQueryLocal.FieldByName('CodSis').AsInteger;
    FArEXC[I].CodGrupo := FQueryLocal.FieldByName('CodGrupo').AsInteger;
    FArEXC[I].CodSubGrupo := FQueryLocal.FieldByName('CodSubGrupo').AsInteger;
    FArEXC[I].CodRel := FQueryLocal.FieldByName('CodRel').AsString;
    Inc(I);

    FQueryLocal.Next;
  End;
  FQueryLocal.Close;

  FQueryLocal.Sql.Clear;
  FQueryLocal.Sql.Add('SELECT * FROM SISTEMA A');
  Try
    FQueryLocal.Open;
  Except
    on e:exception do
      begin
//      logaLocal('Erro carregando dados de sistema: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  SetLength(FArSis, FQueryLocal.RecordCount);

  I := 0;
  While not FQueryLocal.Eof Do
  Begin
    FArSis[I].CodSis := FQueryLocal.FieldByName('CodSis').AsInteger;
    FArSis[I].NomeSis := FQueryLocal.FieldByName('NomeSis').AsString;
    Inc(I);

    FQueryLocal.Next;
  End;
  FQueryLocal.Close;

  FQueryLocal.Sql.Clear;
  FQueryLocal.Sql.Add('SELECT * FROM GRUPOSDFN A');
  Try
    FQueryLocal.Open;
  Except
    on e:exception do
      begin
//      logaLocal('Erro carregando dados de grupos de relat�rios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  SetLength(FArGrupo, FQueryLocal.RecordCount);

  I := 0;
  While not FQueryLocal.Eof Do
  Begin
    FArGrupo[I].CodSis := FQueryLocal.FieldByName('CodSis').AsInteger;
    FArGrupo[I].CodGrupo := FQueryLocal.FieldByName('CodGrupo').AsInteger;
    FArGrupo[I].NomeGrupo := FQueryLocal.FieldByName('NomeGrupo').AsString;
    Inc(I);
    FQueryLocal.Next;
  End;
  FQueryLocal.Close;

  FQueryLocal.Sql.Clear;
  FQueryLocal.Sql.Add('SELECT * FROM SUBGRUPOSDFN A');
  Try
    FQueryLocal.Open;
  Except
    on e:exception do
      begin
//      logaLocal('Erro carregando dados dos subgrupos de relat�rios: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try

  SetLength(FArSubGrupo, FQueryLocal.RecordCount);

  I := 0;
  While not FQueryLocal.Eof Do
  Begin
    FArSubGrupo[I].CodSis := FQueryLocal.FieldByName('CodSis').AsInteger;
    FArSubGrupo[I].CodGrupo := FQueryLocal.FieldByName('CodGrupo').AsInteger;
    FArSubGrupo[I].CodSubGrupo := FQueryLocal.FieldByName('CodSubGrupo').AsInteger;
    FArSubGrupo[I].NomeSubGrupo := FQueryLocal.FieldByName('NomeSubGrupo').AsString;
    Inc(I);

    FQueryLocal.Next;
  End;
  FQueryLocal.Close;

  FQueryLocal.Sql.Clear;
  FQueryLocal.Sql.Add('SELECT * FROM SISAUXDFN');
  FQueryLocal.Sql.Add('ORDER BY CODSIS, CODGRUPO, CODREL');
  Try
    FQueryLocal.Open;
  Except
    on e:exception do
      begin
//      logaLocal('Erro carregando dados dos auxiliares de sistema: '+e.Message);
      Result := False;
      Exit;
      end;
    End; // Try
  SetLength(FArrSisAux, FQueryLocal.RecordCount);

  I := 0;
  While not FQueryLocal.Eof Do
  Begin
    FArrSisAux[I].CodRel := FQueryLocal.FieldByName('CodRel').AsString;
    FArrSisAux[I].CodSis := FQueryLocal.FieldByName('CodSis').AsInteger;
    FArrSisAux[I].CodGrupo := FQueryLocal.FieldByName('CodGrupo').AsInteger;
    FArrSisAux[I].LinI := FQueryLocal.FieldByName('LinI').AsInteger;
    FArrSisAux[I].LinF := FQueryLocal.FieldByName('LinF').AsInteger;
    FArrSisAux[I].Col := FQueryLocal.FieldByName('Col').AsInteger;
    FArrSisAux[I].Tipo := FQueryLocal.FieldByName('Tipo').AsString;
    FArrSisAux[I].CodAux := FQueryLocal.FieldByName('CodAux').AsString;
    FQueryLocal.Next;

    Inc(I);
  End;
  FQueryLocal.Close;

end;

procedure TMulticoldDefinicoes.CarregarDefinicoes;
Var
  PassouGrupoSubGrupoRel : Boolean;
  I,
  CodSisDFNAtu,    // Est� na DFN da base
  CodSisDFNOld,    // Est� na DFN do relat�rio
  CodGrupoDFNAtu,  // Est� na DFN da base
  CodGrupoDFNOld,  // Est� na DFN do relat�rio
  CodGrupoDFNGrp,  // Est� no arquivo GRP
  CodSubGrupoDFNAtu,  // Est� na DFN da base
  CodSubGrupoDFNOld : Integer; // Est� na DFN do relat�rio
  CodRel,
  CodGrupo : String;
  RegSistema,
  CodSeg,
  RegSisAuto,
  RegGrp,
  RegDFN,
  RegDestinoII,
  RegDestino : TgRegDFN;
  TemRegGrp : Boolean;
  NomeRel: String;
  Result: boolean;

  Function LocalizaCodRel(CodRel : String) : Integer;
  Var
    I : Integer;
  Begin
  Result := -1;
  For I := 0 To Length(FArDFN)-1 Do
    If FArDFN[I].CodRel = CodRel Then
      Begin
      Result := I;
      Break;
     End;
  End;

begin
  fileMode := fmShareDenyNone;
  Result := true;
  if not FDatabaseLocal.Connected then
    FDatabaseLocal.Open;
  NomeRel := FNomeArquivo;
  try
    If FileExists(ChangeFileExt(NomeRel,'.IAPX')) Then // Novo formato, candidato a seguran�a
    Begin
      AssignFile(FArqCNFG,ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dfn.Dfn');
      Reset(FArqCNFG);
      Read(FArqCNFG,RegDestinoII); // L� o primeiro Destino, mas n�o checa a seguran�a por ele
      I := 0;
      FillChar(FArrRegIndice, SizeOf(FArrRegIndice),0);
      TemRegGrp := False;
      RegSistema.CODSIS := -999;
      CodSeg.CODSEG := -1; // Inicializar para marcar ...
      While Not Eof(FArqCNFG) Do
      Begin
        Read(FArqCNFG,RegDestinoII);
        Case RegDestinoII.TipoReg Of
          0 : Begin
                RegGrp := RegDestinoII;
                TemRegGrp := True;
              End;
          1 : RegDFN := RegDestinoII;
          2 : Begin
                FArrRegIndice[I] := RegDestinoII;
                Inc(I);
              End;
          3 : RegDestino := RegDestinoII;
          4 : RegSistema := RegDestinoII;
          5 : CodSeg := RegDestinoII;
          6 : RegSisAuto := RegDestinoII;
          End; // Case
      End;
    FRel133 := (RegDFN.TipoQuebra = 1);
    FComprimeBrancos := RegDFN.COMPRBRANCOS;
    If Not TemRegGrp Then  // For�a que reggrp tenha sempre algum conte�do
      RegGrp.Grp := RegDFN.CodGrupo;
    CloseFile(FArqCNFG);
    
    If RegDestino.SEGURANCA Then
      Begin
        FQueryLocal.Close;
        FQueryLocal.Sql.Clear;
        FQueryLocal.Sql.Add('SELECT * FROM USUARIOS A, USUARIOSEGRUPOS B');
        FQueryLocal.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(FUsuario)+''') ');
        FQueryLocal.Sql.Add('AND (A.CODUSUARIO = B.CODUSUARIO) ');
        Try
          FQueryLocal.Open;
        Except
          on e:exception do
            begin
              Result := false;
              raise DefinitionsException.Create('Erro carregando dados de seguran�a: '+e.Message);
            Exit;
            end;
          End; //Try
        CodRel := UpperCase(RegDFN.CodRel); // C�digo do relat�rio em quest�o
        CodGrupo := FQueryLocal.FieldByName('NomeGrupoUsuario').AsString;
        If CodGrupo = 'ADMSIS' Then
        Begin
          FQueryLocal.Close;   // Usuario admsis pode ver tudo
          InsereEventoVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(FUsuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
          Exit;
        End;
        FQueryLocal.Close;
        If Not CarregaDadosDefinicoes Then
        Begin
          Result := false;
          Exit;
        End;
        I := LocalizaCodRel(CodRel);
        If I = -1 Then
        Begin
          Result := false;
          InsereEventoVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(FUsuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 02);
          Exit;
        End;
        CodSisDFNAtu := FArDFN[I].CodSis;    // Banco
        CodSisDFNOld := RegSistema.CODSIS;  // Rel (Pode ser -999 se � a vers�o interbase do relat�rio...
        If CodSisDFNOld = -1 Then
          CodSisDFNOld := RegSisAuto.CODSISREAL; // Pega o C�digo Real que � o da copila��o do relat�rio
        CodGrupoDFNAtu := FArDFN[I].CodGrupo;
        CodSubGrupoDFNAtu := FArDFN[I].CodSubGrupo;
        CodGrupoDFNOld := RegDFN.CODGRUPO;
        CodSubGrupoDFNOld := RegDFN.CODSUBGRUPO;
        If RegDFN.CODGRUPAUTO Or (TemRegGrp And RegDFN.SUBDIRAUTO) Then
          CodGrupoDFNGrp := RegGRP.Grp
        Else
          CodGrupoDFNGrp := RegDFN.CODGRUPO;
        If Length(FArINC) = 0 Then // Nenhuma defini��o de Inclus�o para este usu�rio
        begin
          Result := false;
        end;
        PassouGrupoSubGrupoRel := False;
        For I := 0 To Length(FArINC) - 1 Do
        Begin
          If (FArINC[I].CodSis = -999) Or
             (FArINC[I].CodSis = CodSisDFNAtu) Or
             (FArINC[I].CodSis = CodSisDFNOld) Or
             (RegSistema.CODSIS = -999) Then  // Vers�o Interbase...
          If (FArINC[I].CodGrupo = -999) Or
             (FArINC[I].CodGrupo = CodGrupoDFNAtu) Or
             (FArINC[I].CodGrupo = CodGrupoDFNOld) Or
             (FArINC[I].CodGrupo = CodGrupoDFNGrp) Then
          If (FArINC[I].CodSubGrupo = -999) Or
             (FArINC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
             (FArINC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
          If (FArINC[I].CodRel = '*') Or
             (FArINC[I].CodRel = CodRel) Then
          Begin
            PassouGrupoSubGrupoRel := True;
            Break;
          End;
        End;
        For I := 0 To Length(FArEXC) - 1 Do
        Begin
          If (FArEXC[I].CodSis = -999) Or
             (FArEXC[I].CodSis = CodSisDFNAtu) Or
             (FArEXC[I].CodSis = CodSisDFNOld) Or
             (RegSistema.CODSIS = -999) Then // Vers�o Interbase...
          If (FArEXC[I].CodGrupo = -999) Or
             (FArEXC[I].CodGrupo = CodGrupoDFNAtu) Or
             (FArEXC[I].CodGrupo = CodGrupoDFNOld) Or
             (FArEXC[I].CodGrupo = CodGrupoDFNGrp) Then
          If (FArEXC[I].CodSubGrupo = -999) Or
             (FArEXC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
             (FArEXC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
          If (FArEXC[I].CodRel = '*') Or
             (FArEXC[I].CodRel = CodRel) Then
          Begin
            Result := false;
            Break;
          End;
        End;
        If Result and PassouGrupoSubGrupoRel Then
        Begin
          // Muito Bem, Passou por todos os testes..............
          InsereEventoVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(FUsuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        End
        Else
        Begin
          InsereEventoVisu(ExtractFileName(NomeRel), ExtractFilePath(NomeRel), CodRel,
                            UpperCase(FUsuario), CodGrupo, RegGrp.Grp, RegDFN.CodSubGrupo, 01);
        End;
      End;
    End
  except
    on e:exception do
    begin
      raise DefinitionsException.Create(e.Message);
    end;
  end;
end;

procedure TMulticoldDefinicoes.CarregarTipoQuebraPagina;
Var
  PassouGrupoSubGrupoRel : Boolean;
  I,
  CodSisDFNAtu,    // Est� na DFN da base
  CodSisDFNOld,    // Est� na DFN do relat�rio
  CodGrupoDFNAtu,  // Est� na DFN da base
  CodGrupoDFNOld,  // Est� na DFN do relat�rio
  CodGrupoDFNGrp,  // Est� no arquivo GRP
  CodSubGrupoDFNAtu,  // Est� na DFN da base
  CodSubGrupoDFNOld : Integer; // Est� na DFN do relat�rio
  CodRel,
  CodGrupo : String;
  RegSistema,
  CodSeg,
  RegSisAuto,
  RegGrp,
  RegDFN,
  RegDestinoII,
  RegDestino : TgRegDFN;
  TemRegGrp : Boolean;
  NomeRel: String;
  Result: boolean;

begin
  NomeRel := FNomeArquivo;
  
  try
    If FileExists(ChangeFileExt(NomeRel,'.IAPX')) Then // Novo formato, candidato a seguran�a
    Begin
      AssignFile(FArqCNFG,ExtractFilePath(NomeRel)+SeArquivoSemExt(NomeRel)+'Dfn.Dfn');
      Reset(FArqCNFG);
      Read(FArqCNFG,RegDestinoII); // L� o primeiro Destino, mas n�o checa a seguran�a por ele
      I := 0;
      FillChar(FArrRegIndice, SizeOf(FArrRegIndice),0);
      TemRegGrp := False;
      RegSistema.CODSIS := -999;
      CodSeg.CODSEG := -1; // Inicializar para marcar ...
      While Not Eof(FArqCNFG) Do
      Begin
        Read(FArqCNFG,RegDestinoII);
        Case RegDestinoII.TipoReg Of
          0 : Begin
                RegGrp := RegDestinoII;
                TemRegGrp := True;
              End;
          1 : RegDFN := RegDestinoII;
          2 : Begin
                FArrRegIndice[I] := RegDestinoII;
                Inc(I);
              End;
          3 : RegDestino := RegDestinoII;
          4 : RegSistema := RegDestinoII;
          5 : CodSeg := RegDestinoII;
          6 : RegSisAuto := RegDestinoII;
          End; // Case
      End;
      FRel133 := (RegDFN.TipoQuebra = 1);
      FComprimeBrancos := RegDFN.COMPRBRANCOS;
      FTipoQuebraPagina := RegDFN.TipoQuebra
    End;
  except
    on e:exception do
    begin
      raise DefinitionsException.Create(e.Message);
    end;
  end;
end;

constructor TMulticoldDefinicoes.Create(usuario, senha,
  nomeArquivo: WideString);
begin
  FUsuario := usuario;
  FSenha := senha;
  FNomeArquivo := nomeArquivo;

  FDataBaseLocal := TADOConnection.Create(nil);
  FDataBaseEventos := TADOConnection.Create(nil);

  with FDatabaseLocal do
  begin
    connectionString := 'FILE NAME='+extractFilePath(ParamStr(0))+'Multicold.udl';
    loginPrompt := false;
    commandTimeout := 30;
    connectionTimeout := 15;
    connectOptions := coConnectUnspecified;
    cursorLocation := clUseServer;
    IsolationLevel := ilCursorStability;
    keepConnection := true;
    mode := cmUnknown;
    provider := 'SQLOLEDB.1';
  end;
  with FDatabaseEventos do
  begin
    connectionString := 'FILE NAME='+extractFilePath(ParamStr(0))+'MulticoldEventos.udl';
    loginPrompt := false;
    commandTimeout := 30;
    connectionTimeout := 15;
    connectOptions := coConnectUnspecified;
    cursorLocation := clUseServer;
    IsolationLevel := ilCursorStability;
    keepConnection := true;
    mode := cmUnknown;
    provider := 'SQLOLEDB.1';
  end;

  FQueryLocal:= TADOQuery.Create(FDataBaseLocal);
  with FQueryLocal do
  begin
    Connection:= FDataBaseLocal;
  end;

  FQueryEventos:= TADOQuery.Create(FDataBaseEventos);
  with FQueryEventos do
  begin
    Connection:= FDataBaseEventos;
  end;

end;

destructor TMulticoldDefinicoes.Destroy;
begin
  if FDatabaseLocal.Connected then
    FDatabaseLocal.Close;

  if FDatabaseEventos.Connected then
    FDatabaseLocal.Close;

  FreeAndNil(FDatabaseLocal);
  FreeAndNil(FDatabaseEventos);

  inherited;
end;

procedure TMulticoldDefinicoes.InsereEventoVisu(Arquivo, Diretorio, CodRel, CodUsuario, NomeGrupoUsuario : WideString; Grupo, SubGrupo, CodMens : Integer);
Var
  Agora : TDateTime;
Begin
  fileMode := fmShareDenyNone;
  if not FDatabaseEventos.Connected then
    FDatabaseEventos.Open;
  FDatabaseEventos.Connected := True;
  If FDatabaseEventos.InTransaction Then
    FDatabaseEventos.CommitTrans;
  FDatabaseEventos.BeginTrans;
  Agora := Now;
  FQueryEventos.Close;
  FQueryEventos.Sql.Clear;
  FQueryEventos.Sql.Add('INSERT INTO EVENTOS_VISU (DT, HR, ARQUIVO, DIRETORIO, CODREL, GRUPO, SUBGRUPO, CODUSUARIO, NOMEGRUPOUSUARIO, CODMENSAGEM) ');
  FQueryEventos.Sql.Add('VALUES (:a, :b, :c, :d, :e, :f, :g, :h, :i, :j)');
  FQueryEventos.Parameters[0].Value := Agora;
  FQueryEventos.Parameters[1].Value := Agora;
  FQueryEventos.Parameters[2].Value := Copy(Arquivo,1,70);
  FQueryEventos.Parameters[3].Value := Copy(Diretorio,1,70);
  FQueryEventos.Parameters[4].Value := Copy(CodRel,1,15);
  FQueryEventos.Parameters[5].Value := Grupo;
  FQueryEventos.Parameters[6].Value := SubGrupo;
  FQueryEventos.Parameters[7].Value := Copy(CodUsuario,1,20);
  FQueryEventos.Parameters[8].Value := Copy(NomeGrupoUsuario,1,30);
  FQueryEventos.Parameters[9].Value := CodMens;
    Try
      FQueryEventos.ExecSql;
    Except
      on e:exception do
        begin
        FDatabaseEventos.RollbackTrans;
          // @CAMORIM - Criar Exception!
//        logaLocal('Erro na grava��o de eventos: '+e.Message);
        end;
    End; // Try
    if FDatabaseEventos.InTransaction then
      FDatabaseEventos.CommitTrans;
end;


{ TDefinitionsException }

constructor DefinitionsException.Create(message: String);
begin
  inherited Create(Format('Ocorreu um erro ao carregar as defini�oes! Message: %s', [message]));
end;

{ TMulticoldManager }

procedure TMulticoldManager.AbrirRelatorio;
begin
  FMulticoldReport.AbrirRelatorio;
end;

constructor TMulticoldManager.Create(Usuario, Senha, NomeArquivo: String; CarregaDefinicoes: Boolean; const AOrig: Boolean = false);
begin
  FMulticoldDefinicoes := TMulticoldDefinicoes.Create(Usuario, Senha, NomeArquivo);
  if CarregaDefinicoes then
  begin
    FMulticoldDefinicoes.CarregarDefinicoes;
  end else
  begin
    FMulticoldDefinicoes.CarregarTipoQuebraPagina;
  end;

  FMulticoldReport := TMulticoldReport.Create(NomeArquivo, FMulticoldDefinicoes.Rel133,
            FMulticoldDefinicoes.Rel64, FMulticoldDefinicoes.ComprimeBrancos,
            FMulticoldDefinicoes.TipoQuebraPagina, AOrig);
end;

destructor TMulticoldManager.Destroy;
begin
  FreeAndNil(FMulticoldReport);
  FreeAndNil(FMulticoldDefinicoes);

  inherited;
end;

function TMulticoldManager.ExecutarBuscaSequencial(pagIni, pagFin, linIni, linFin, coluna: Integer; tipoBusca: integer; valorBusca: WideString): TResultadoBuscaSequencial;
var
  buscaSequencial: TBuscaSequencial;
begin
    buscaSequencial := TBuscaSequencialFactory.ObterBuscaSequencial(Self, tipoBusca);
    try
      buscaSequencial.PagIni := pagIni;
      buscaSequencial.PagFin := pagFin;
      buscaSequencial.LinIni := linIni;
      buscaSequencial.LinFin := linFin;
      buscaSequencial.Coluna := coluna;
      buscaSequencial.TipoBusca := tipoBusca;
      buscaSequencial.ValorBusca := valorBusca;

      Result := buscaSequencial.ExecutarBusca;

      if Result.Localizou then
      begin
        NavegarParaPagina(Result.IndexPagLoc);
        FPesquisaPagIndedex := result.IndexPagLocPesq;
      end;
    finally
      FreeAndNil(buscaSequencial);
    end;
end;

procedure TMulticoldManager.ExecutarExtracaoDados(aTemplate,
  aOutputFile: String);
var
  extrator: TExtratorDados;
begin
  extrator := TExtratorDados.Create(aTemplate, FMulticoldReport);
  try
    extrator.Processar(aOutputFile);
  finally
    FreeAndNil(extrator);
  end;
end;

function TMulticoldManager.ExecutarQueryFacil(pPesquisa: TListaPesquisa;
  pMensagem: String; var pResultado: TListaResultadoPesquisa): boolean;
var
  queryFacil: TMulticoldQueryFacil;
begin
  Result := false;
  FPesquisaAtiva := false;
  FPesquisa := nil;

  queryFacil := TMulticoldQueryFacil.Create(FMulticoldReport);
  try
    if queryFacil.ExecutarQueryFacil(pPesquisa, pMensagem, pResultado) then
    begin
      if Length(pResultado) > 0 then
      begin
        Result := true;
        FPesquisa := pResultado;
        FPesquisaAtiva := true;
        NavegarParaPagina(FPesquisa[0].Pagina);
        FPesquisaPagIndedex := 1;
      end;
    end;

  finally
    FreeAndNil(queryFacil);
  end;
end;

function TMulticoldManager.GetFilename: String;
begin
  Result := FMulticoldReport.Filename;
end;

function TMulticoldManager.GetIndexPagina: Integer;
begin
  Result := FMulticoldReport.IndexPagina;
end;

function TMulticoldManager.GetOrig: boolean;
begin
  Result := FMulticoldReport.Orig;
end;

function TMulticoldManager.GetPaginaCompactada: WideString;
begin
  Result := FMulticoldReport.PaginaCompactada;
end;

function TMulticoldManager.GetPaginaDescompactada: WideString;
begin
  Result := FMulticoldReport.PaginaDescompactada;
end;

function TMulticoldManager.GetPaginaOriginal: WideString;
begin
  Result := FMulticoldReport.PaginaOriginal;
end;

function TMulticoldManager.GetQtdeBytes: Integer;
begin
  Result := FMulticoldReport.QtdeBytesComp;
end;

function TMulticoldManager.GetQtdePaginas: Integer;
begin
  Result := FMulticoldReport.QtdePaginas;
end;


function TMulticoldManager.GetTipoQuebraPagina: Integer;
begin
  Result := FMulticoldReport.TipoQuebraPagina;
end;

procedure TMulticoldManager.NavegarParaPagina(pIndexPagina: Integer);
begin
  FMulticoldReport.NavegarParaPagina(pIndexPagina);
end;

{ TBuscaSequencialFactory }

class function TBuscaSequencialFactory.ObterBuscaSequencial(
  multicoldManager: TMulticoldManager; tipo: integer): TBuscaSequencial;
begin
  // Qdo existirem outras formas de busca implementadas, aqui que vou decidir qual
  // a forma de busca que ser� instanciada.
  case tipo of
    0:
      Result := TBuscaSequencialPadrao.Create(multicoldManager);
    1:
      Result := TBuscaSequencialEmPesquisa.Create(multicoldManager);
  end;
end;

{ TMulticoldQueryFacil }

procedure TMulticoldQueryFacil.AbrirDados(var Query: TQuery;
  var Stream: TFileStream; objeto: variant);
 var
    l : word;
    K : Integer;
    fSettings : tFormatSettings;
    Caspa,
    argPesq: AnsiString;
begin
  try
    Stream := nil;
    if pos(objeto,'ABCDEFGHIJKLMNOPQRSTUVQWXYZ') > 0 then
    begin
      for k := 1 to FMaxLin do
      begin
        if FrSet[0, k] = objeto then
        begin
          try
            Query.Close;
          except
          end; // try
          
          Query.DatabaseName := extractFilePath(FReport.Filename);
          Query.SQL.Clear;
          Query.SQL.Add(' SELECT * FROM "'+changeFileExt(extractFileName(FReport.Filename),'')+
                        FrSet[1, k]+'" '+FrSet[1, k]); // Montar SELECT
          for l := 0 to high(FArrRegIndice) do
            if (FArrRegIndice[l].NOMECAMPO = FrSet[1, k]) then
              begin
              argPesq := FrSet[3, k];
              if (upperCase(FArrRegIndice[l].TIPOCAMPO) = 'C') or
                 (upperCase(FArrRegIndice[l].TIPOCAMPO) = 'DT') then
                Caspa := ''''
              else
                Caspa := '';
              if (upperCase(ConverterOperador(FrSet[2, k])) = 'IN') or
                 (upperCase(ConverterOperador(FrSet[2, k])) = 'NOT IN') or
                 (upperCase(ConverterOperador(FrSet[2, k])) = 'BETWEEN') or
                 (upperCase(ConverterOperador(FrSet[2, k])) = 'NOT BETWEEN') then
                Caspa := '';
              if (upperCase(FArrRegIndice[l].TIPOCAMPO) = 'DT') then
                begin
                try
                  fSettings.ShortDateFormat := 'DD/MM/YYYY';
                  ArgPesq := FormatDateTime('MM/DD/YYYY',StrToDate(ArgPesq));
                except
  //                  mensagem := 'Formato da data inv�lida.';
  //                  result := false;
                  exit;
                  end;
                end;
              Query.SQL.Add(' WHERE '+FrSet[1, k] + '.VALOR ' + ConverterOperador(FrSet[2, k]) + ' ' + Caspa + argPesq + Caspa + ' ');
              Break;
              end;
          Query.SQL.Add(' ORDER BY PAGINA, RELATIVO ');
          try
            Query.Open;
          except
            on e:exception do
              begin
                raise;
  //                vitX.LogaLocal('abrirDados:'+e.Message);
  //                vitX.LogaLocal('abrirDados - SQL:'+Query.SQL.Text);
              end;
          end;
          Break; // J� fez? cai fora!
        end;
      end;
    end
  else
    Stream := TFileStream.Create(FDirSecao+objeto+'.Multicold',fmOpenRead);
  except
  on e:exception do
    begin
//      vitX.LogaLocal('abrirDados:'+e.Message);
//      if Query <> nil then
//        vitX.LogaLocal('abrirDados - SQL:'+Query.SQL.Text);
    end;
  end;
end;

function TMulticoldQueryFacil.ConverterOperador(Operador: string): string;
begin
  result := '';

  if operador = '1' then
    result := '='
  else if operador = '2' then
    result := '>'
  else if operador = '3' then
    result := '<'
  else if operador = '4' then
    result := '>='
  else if operador = '5' then
    result := '<='
  else if operador = '6' then
    result := '<>'
  else if operador = '7' then
    result := 'IN'
  else if operador = '8' then
    result := 'IS'
  else if operador = '9' then
    result := 'BETWEEN'
  else if operador = '10' then
    result := 'LIKE'
  else if operador = '11' then
    result := 'NOT ='
  else if operador = '12' then
    result := 'NOT >'
  else if operador = '13' then
    result := 'NOT <'
  else if operador = '14' then
    result := 'NOT >='
  else if operador = '15' then
    result := 'NOT <='
  else if operador = '16' then
    result := 'NOT IN'
  else if operador = '17' then
    result := 'NOT BETWEEN'
  else if operador = '18' then
    result := 'IS NOT'
  else
    result := '';
end;

constructor TMulticoldQueryFacil.Create(multicoldReport: TMulticoldReport);
begin
  FReport := multicoldReport;

  FSession := TSession.Create(nil);
  FSession.AutoSessionName := true;
  
  FQuery1 := TQuery.Create(FSession);
  FQuery1.SessionName := FSession.SessionName;
  
  FQuery2 := TQuery.Create(FSession);
  FQuery2.SessionName := FSession.SessionName;  
end;

procedure TMulticoldQueryFacil.DescarregaAnd;
var
  intArqNum : integer;
  h : TFileStream;
  t: AnsiString;
  ehEOF1,
  ehEOF2,
  primeiraVez: Boolean;
  j,
  pgAux: Integer;
begin
  abrirDados(FQuery1, FObjF1, FOprnd1);
  abrirDados(FQuery2, FObjF2, FOprnd2);
  intArqNum := 0;
  while true do
    begin
    //t := ColetaDiretorioTemporario+intToStr(intArqNum)+'.Multicold';
    t := FDirSecao+intToStr(intArqNum)+'.Multicold';
    if not fileExists(t) then
      break;
    inc(intArqNum);
    end;
  h := TFileStream.Create(t,fmCreate);
  leRegistroFileStreamOuQuery(FQuery1, FObjF1, FReg1, ehEOF1, FOprnd1);
  leRegistroFileStreamOuQuery(FQuery2, FObjF2, FReg2, ehEOF2, FOprnd2);
  if (ehEOF1) or (ehEOF2) then
    begin
    FreeAndNil(h);
    fechaArquivoTemp(FQuery1,FObjF1,FOprnd1);
    fechaArquivoTemp(FQuery2,FObjF2,FOprnd2);
    FPilha.push(j);  // Verificar se essa vari�vel � usada em outro lugar!!!
    exit;
    end;
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if FReg1.Pagina > FReg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(FQuery2,FObjF2,FReg2,ehEOF2,FOprnd2);
      end
    else if FReg1.Pagina < FReg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
      end
    else
      begin
      pgAux := FReg1.Pagina;
      while (FReg1.Pagina = FReg2.Pagina) and (not ehEOF1) do
        begin
        h.write(FReg1,sizeOf(FReg1));
        leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
        end;
      if (pgAux = FReg1.Pagina) then
        h.write(FReg1,sizeOf(FReg1));
      while (pgAux = FReg2.Pagina) and (not ehEOF2) do
        begin
        h.write(FReg2,sizeOf(FReg2));
        leRegistroFileStreamOuQuery(FQuery2,FObjF2,FReg2,ehEOF2,FOprnd2);
        end;
      if (pgAux = FReg2.Pagina) then
        h.write(FReg2,sizeOf(FReg2));
      end
    end;
  primeiraVez := true;
  while (not ehEOF1) do
    begin
    if FReg1.Pagina > FReg2.Pagina then
      begin
      FReg2.Pagina := MAXINT;
      end
    else if FReg1.Pagina < FReg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
      end
    else
      begin
      h.write(FReg1,sizeOf(FReg1));
      if primeiraVez then
        begin
        h.write(FReg2,sizeOf(FReg2));
        primeiraVez := false;
        end;
      leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
      end
    end;
  primeiraVez := true;
  while (not ehEOF2) do
    begin
    if FReg1.Pagina > FReg2.Pagina then
      begin
      leRegistroFileStreamOuQuery(FQuery2,FObjF2,FReg2,ehEOF2,FOprnd2);
      end
    else if FReg1.Pagina < FReg2.Pagina then
      begin
      FReg1.Pagina := MAXINT;
      end
    else
      begin
      if primeiraVez then
        begin
        h.write(FReg1,sizeOf(FReg1));
        primeiraVez := false;
        end;
      h.write(FReg2,sizeOf(FReg2));
      leRegistroFileStreamOuQuery(FQuery2,FObjF2,FReg2,ehEOF2,FOprnd2);
      end
    end;
  if (FReg1.Pagina = FReg2.Pagina) and (FReg1.Pagina <> MAXINT) then
    begin
    h.write(FReg2,sizeOf(FReg2));
    h.write(FReg1,sizeOf(FReg1));
    end;
  FreeAndNil(h);
  fechaArquivoTemp(FQuery1,FObjF1,FOprnd1);
  fechaArquivoTemp(FQuery2,FObjF2,FOprnd2);
  FPilha.push(intArqNum);
end;

procedure TMulticoldQueryFacil.DescarregaOr;
var
  intArqNum : integer;
  h : TFileStream;
  t: AnsiString;
  ehEOF1,
  ehEOF2: Boolean;
begin
  abrirDados(FQuery1, FObjF1, FOprnd1);
  abrirDados(FQuery2, FObjF2, FOprnd2);
  intArqNum := 0;
  while true do
    begin
    //t := ColetaDiretorioTemporario+intToStr(intArqNum)+'.Multicold';
    t := FDirSecao+intToStr(intArqNum)+'.Multicold';
    if not fileExists(t) then
      break;
    inc(intArqNum);
    end;
  h := TFileStream.Create(t, fmCreate);
  leRegistroFileStreamOuQuery(FQuery1, FObjF1, FReg1, ehEOF1, FOprnd1);
  leRegistroFileStreamOuQuery(FQuery2, FObjF2, FReg2, ehEOF2, FOprnd2);
  while (not ehEOF1) and (not ehEOF2) do
    begin
    if FReg1.Pagina > FReg2.Pagina then
      begin
      h.write(FReg2,sizeOf(FReg2));
      leRegistroFileStreamOuQuery(FQuery2,FObjF2,FReg2,ehEOF2,FOprnd2);
      end
    else if FReg1.Pagina < FReg2.Pagina then
      begin
      h.write(FReg1,sizeOf(FReg1));
      leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
      end
    else
      begin
      h.write(FReg1,sizeOf(FReg1));
      h.write(FReg2,sizeOf(FReg2));
      leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
      leRegistroFileStreamOuQuery(FQuery2,FObjF2,FReg2,ehEOF2,FOprnd2);
      end
    end;
  while (not ehEOF1) do
    begin
    if FReg1.Pagina > FReg2.Pagina then
      begin
      h.write(FReg2,sizeOf(FReg2));
      FReg2.Pagina := MAXINT;
      end
    else if FReg1.Pagina < FReg2.Pagina then
      begin
      h.write(FReg1,sizeOf(FReg1));
      leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
      end
    else
      begin
      h.write(FReg1,sizeOf(FReg1));
      h.write(FReg2,sizeOf(FReg2));
      leRegistroFileStreamOuQuery(FQuery1,FObjF1,FReg1,ehEOF1,FOprnd1);
      FReg2.Pagina := MAXINT;
      end
    end;
  while (not ehEOF2) do
    begin
    if FReg1.Pagina > FReg2.Pagina then
      begin
      h.write(FReg2,sizeOf(FReg2));
      leRegistroFileStreamOuQuery(FQuery2, FObjF2, FReg2, ehEOF2, FOprnd2);
      end
    else if FReg1.Pagina < FReg2.Pagina then
      begin
      h.write(FReg1,sizeOf(FReg1));
      FReg1.Pagina := MAXINT;
      end
    else
      begin
      h.write(FReg1,sizeOf(FReg1));
      h.write(FReg2,sizeOf(FReg2));
      leRegistroFileStreamOuQuery(FQuery2,FObjF2,FReg2,ehEOF2,FOprnd2);
      FReg1.Pagina := MAXINT;
      end
    end;
  if FReg1.Pagina > FReg2.Pagina then
    begin
    if FReg2.Pagina <> MAXINT then
      h.write(FReg2,sizeOf(FReg2));
    if FReg1.Pagina <> MAXINT then
      h.write(FReg1,sizeOf(FReg1));
    end
  else
    begin
    if FReg1.Pagina <> MAXINT then
      h.write(FReg1,sizeOf(FReg1));
    if FReg2.Pagina <> MAXINT then
      h.write(FReg2,sizeOf(FReg2));
    end;
  FreeAndNil(h);
    fechaArquivoTemp(FQuery1,FObjF1,FOprnd1);
  fechaArquivoTemp(FQuery2,FObjF2,FOprnd2);
  FPilha.push(intArqNum);
end;

procedure TMulticoldQueryFacil.DescarregaPilha(strPilha: String; 
  var pResultado: TListaResultadoPesquisa);
var
  intPilha : integer;
  tam,
  i,
  j,
  pgAux,
  MaxLin : integer;
  Caspa,
  ArgPesq,
  t,
  oprdr,
  Tt : AnsiString;
  function ehOperador(caractere : String) : boolean;
  begin
    result := (pos(caractere, '+-/*^') > 0);
  end;
begin
  // Processa querys
  FPilha.clear;
  for intPilha := length(strPilha) downto 1 do
    begin
    if (strPilha[intPilha] = '(') or (strPilha[intPilha] = ')') then
      continue;
    if ehOperador(strPilha[intPilha]) then
      FPilha.push(strPilha[intPilha])
    else //if not ehOperador(strPilha[intPilha]) then
      begin
        if ehOperador(FPilha.peek) then
          FPilha.push(strPilha[intPilha])
        else
        begin
          FPilha.push(strPilha[intPilha]);
          while true do
          begin
            FOprnd1 := FPilha.pop;
            FOprnd2 := FPilha.pop;
            oprdr := FPilha.pop;
            if (not ehOperador(FOprnd1)) and (not ehOperador(FOprnd2)) and (ehOperador(oprdr)) then
            begin
              if oprdr = '*' then // AND
                descarregaAnd
              else if oprdr = '-' then // OR
                descarregaOr
            end
            else
            begin
              FPilha.push(oprdr);
              FPilha.push(FOprnd2);
              FPilha.push(FOprnd1);
              break;
            end;
          end;
        end
      end;
    end;
    
  strPilha := FPilha.pop; // Pega o �ltimo
  DescarregaSolo(pResultado);
end;

procedure TMulticoldQueryFacil.DescarregaSolo(var pResultado: TListaResultadoPesquisa);
var
    ehEOF1,
    ehEOF2: Boolean;
    i: Integer;
begin
  
  abrirDados(FQuery1, FObjF1, FOprnd1);
  leRegistroFileStreamOuQuery(FQuery1, FObjF1, FReg1, ehEOF1, FOprnd1);
  if FReg1.Pagina = MAXINT then // EOF mesmo
  begin  
//    setLength(pResultado, 1);
//    pResultado[0].Campo := IntToStr(MAXINT);
//    pResultado[0].Pagina := IntToStr(MAXINT);
//    pResultado[0].Relativo := IntToStr(MAXINT);
//    pResultado[0].Linha := IntToStr(MAXINT);
    exit;
  end 
  else
  begin
    setLength(pResultado, 1);
    pResultado[0].Campo := FReg1.Campo;
    pResultado[0].Pagina := FReg1.Pagina;
    pResultado[0].Relativo := FReg1.Relativo;
    pResultado[0].Linha := FReg1.Linha;
  end;
  
  i := 1;
  while not ehEOF1 do
  begin
    leRegistroFileStreamOuQuery(FQuery1, FObjF1, FReg1, ehEOF1, FOprnd1);
    if FReg1.Pagina <> MAXINT then
    begin
      setLength(pResultado, i + 1);
      pResultado[i].Campo := FReg1.Campo;
      pResultado[i].Pagina := FReg1.Pagina;
      pResultado[i].Relativo := FReg1.Relativo;
      pResultado[i].Linha := FReg1.Linha;
    end;
    inc(i);
  end;
  fechaArquivoTemp(FQuery1, FObjF1, FOprnd1);
end;

destructor TMulticoldQueryFacil.Destroy;
begin
  if FQuery1.Active then
    FQuery1.Active := false;

  if FQuery2.Active then
    FQuery2.Active := false;

  if FSession.Active then
    FSession.Active := false;
  FreeAndNil(FQuery1);
  FreeAndNil(FQuery2);
  FreeAndNil(FSession);
  inherited;
end;

function TMulticoldQueryFacil.ExecutarQueryFacil(pPesquisa: TListaPesquisa; pMensagem: String; var pResultado: TListaResultadoPesquisa): boolean;
var
  ArqCNFG : FileOfTgRegDFN;
  RegDestinoII : TgRegDFN;  // Este tb
  i: Integer;
  f : TSearchRec;
  Tt: AnsiString;

begin
  if pPesquisa = nil then
  begin
    result := false;
    exit;
  end;

  fileMode := fmShareDenyNone;
  result := false;
  FDirSecao := ColetaDiretorioTemporario+'Multicold_'+formatDateTime('yyyymmddhhnnsszzzz',now)+'\';
  forceDirectories(FDirSecao);
  FSession.PrivateDir := FDirSecao;
  FSession.NetFileDir := FDirSecao;
  FSession.Active := true;

  If FileExists(ChangeFileExt(FReport.Filename,'.IAPX')) Then // Novo formato, candidato a seguran�a
  Begin
    AssignFile(ArqCNFG,ExtractFilePath(FReport.Filename)+SeArquivoSemExt(FReport.Filename)+'Dfn.Dfn');
    Reset(ArqCNFG);
    Read(ArqCNFG, RegDestinoII); // L� o primeiro Destino, mas n�o checa a seguran�a por ele
    i := 0;
    FillChar(FArrRegIndice,SizeOf(FArrRegIndice),0);
    While Not Eof(ArqCNFG) Do
      Begin
      Read(ArqCNFG,RegDestinoII);
      Case RegDestinoII.TipoReg Of
        2 : Begin
            FArrRegIndice[i] := RegDestinoII;
            Inc(i);
            End;
        End; // Case
      End;
    closeFile(ArqCNFG);
  end;
  FPilha := TPilha.create(nil);
  try
    try

    FMaxLin := 0;
    for I := 0 to length(pPesquisa)-1 do
    begin
      Inc(FMaxLin);
      FrSet[0, FMaxLin] := pPesquisa[i].Index;
      FrSet[1, FMaxLin] := pPesquisa[i].Campo;
      FrSet[2, FMaxLin] := IntToStr(pPesquisa[i].Operador);
      FrSet[3, FMaxLin] := pPesquisa[i].Valor;
      if pPesquisa[i].Conector = -1 then
        FrSet[4, FMaxLin] := ''    
      else
        FrSet[4, FMaxLin] := IntToStr(pPesquisa[i].Conector);    
    end;
    except
      on e:exception do
        begin
//        vitX.LogaLocal('Erro na execu��o da query f�cil remota: '+e.Message);
//        vitX.LogaLocal(gridXML);
        exit;
        end;
    end;
    DescarregaPilha(pMensagem, pResultado);    // mensagem vem com a posfixa do grid da query f�cil
    result := true;
  finally
    FSession.Active := false;
    if findFirst(FDirSecao+'*.*',faAnyFile,f) = 0 then
      repeat
        if (f.Name <> '.') and (f.Name <> '.') then
          deleteFile(FDirSecao+f.Name);
      until findNext(f) <> 0;
    findClose(f);
    removeDir(FDirSecao);
    FreeAndNil(FPilha);
  end;

end;

procedure TMulticoldQueryFacil.FechaArquivoTemp(var Query: TQuery;
  var Stream: TFileStream; operando: variant);
begin
  try
    if (Stream <> nil) then
      begin
        FreeAndNil(Stream);
        deleteFile(FDirSecao + operando + '.Multicold');
      end
    else
      Query.Close;
  except
  on e:exception do
//    vitX.LogaLocal('fechaArquivoTemp:'+e.Message);
  end;
end;

procedure TMulticoldQueryFacil.LeRegistroFileStreamOuQuery(var Query: TQuery;
  var Stream: TFileStream; var reg: TResultadoPesquisa; var EOF: boolean; campo: String);
begin
  try
    If Stream <> nil Then
      Begin
      if Stream.Position < Stream.Size then
        Stream.Read(reg,sizeOf(reg))
      else if Stream.Size = 0 then
        reg.Pagina := MAXINT;
      eof := Stream.Position = Stream.Size;
      End
    Else
      Begin
      eof := Query.Eof;
      if not eof then
        begin
        reg.Campo := campo[1];
        reg.Pagina := Query.Fields[1].AsInteger;
        reg.Relativo := Query.Fields[2].AsInteger;
        reg.Linha := Query.Fields[3].AsInteger;
        Query.Next;
        end
      else
        reg.Pagina := MAXINT;
        End;
  except
    on e:exception do
      begin
//      vitX.LogaLocal('leRegistroFileStreamOuQuery:'+e.Message);
      end;
    end;
end;

function TMulticoldQueryFacil.TamanhoDados(var Query: TQuery;
  var Stream: TFileStream): Int64;
begin
  result := 0;
  try
    if Stream = nil then
      result := Query.recordCount
    else
      result := Stream.Size div sizeOf(FReg1);
  except
  on e:exception do
//      vitX.LogaLocal('tamanhoDados:'+e.Message);
  end;
end;

{ TBuscaSequencialPesquisa }

constructor TBuscaSequencialEmPesquisa.Create(MulticoldManager: TMulticoldManager);
begin
  inherited Create(MulticoldManager);
end;

function TBuscaSequencialEmPesquisa.ExecutarBusca: TResultadoBuscaSequencial;
var
  QtdePaginas: Integer;
  PaginaDescomp, PaginaComp: WideString;
  i, j: Integer;
  QtdeBytes: Integer;
  ListaPagina: TStringList;
  linha: WideString;
  linIni, linFin: Integer;
  PagIndexlist: TList<Integer>;
  IdxPaginaReal, L, idx: Integer;

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

  PagIndexlist := TList<Integer>.Create;
  try
    GetPageList(FMulticoldManager.Pesquisa);

    Result := TResultadoBuscaSequencial.Create();

    QtdePaginas := PagIndexlist.Count;
    QtdeBytes := FMulticoldManager.QtdeBytes;

    ListaPagina := TStringList.Create();
    try
      FMulticoldManager.NavegarParaPagina(FMulticoldManager.PesquisaPagIndedex);
      PaginaDescomp := FMulticoldManager.PaginaDescompactada;
        PaginaComp := FMulticoldManager.PaginaCompactada;

      if FPagIni = -1 then
        PagIni := 1
      else
        PagIni := FPagIni;

      if FPagFin = -1 then
        PagFin := FMulticoldManager.QtdePaginas
      else
        PagFin := FPagFin;

      for i := PagIni to PagIndexlist.Count do
      begin

        IdxPaginaReal := PagIndexlist[i-1];
        FMulticoldManager.NavegarParaPagina(IdxPaginaReal);
        PaginaDescomp := FMulticoldManager.PaginaDescompactada;
        PaginaComp := FMulticoldManager.PaginaCompactada;

        ListaPagina.Clear;
        ListaPagina.Text := PaginaDescomp;

        if (FLinIni = -1) or (FLinIni = 0) then
          linIni := 1
        else
        if (FLinIni <> -1) and (PagIni = i) then
          linIni := FLinIni
        else
          linIni := 1;

        L := 0;
        idx := 0;
        linha := ListaPagina[idx];
        while Trim(linha) = '' do
        begin
          Inc(L);
          idx := idx + L;
          linha := ListaPagina[idx];
        end;

        linIni := linIni + L;

        if (linIni > 1) and (L=0) then
          Inc(linIni);


        if FLinFin = -1 then
          linFin := ListaPagina.Count
        else
          linFin := FLinFin;

  //      if PagFin > QtdePaginas then
  //      begin
  //        // setar uma mensagem de erro e voltar.
  //        Exit;
  //      end;

        for j := linIni to linFin do
        begin

          linha := ListaPagina[j-1];

          If Coluna = -1 Then
          Begin
            // BUSCA SEM ESPECIFICA��O DE COLUNA //
            If Pos(ValorBusca, linha) <> 0 Then
            Begin
              Result.Localizou := True;
              Result.LinhaLocalizada := j-1;
              Result.ColunaLocalizada := Pos(ValorBusca, linha);
              Result.Pagina := PaginaComp;
              Result.IndexPagLoc := IdxPaginaReal;
              Result.IndexPagLocPesq := i;
              Result.QtdeBytesPag := FMulticoldManager.QtdeBytes;
              Result.QtdeTotalPag := FMulticoldManager.QtdePaginas;
              Exit;
            End;
          End Else
          Begin
            // BUSCA COM ESPECIFICA��O DE COLUNA //
            If Copy(linha, Coluna, Length(ValorBusca)) = ValorBusca Then
            Begin
              Result.Localizou := True;
              Result.LinhaLocalizada := j-1;
              Result.ColunaLocalizada := Coluna;
              Result.Pagina := PaginaComp;
              Result.IndexPagLoc := IdxPaginaReal;
              Result.IndexPagLocPesq := i;
              Result.QtdeBytesPag := FMulticoldManager.QtdeBytes;
              Result.QtdeTotalPag := FMulticoldManager.QtdePaginas;

              Exit;
            End;
          End;


        end;

        //**********************************************************************************************
      end;

    finally
      FreeAndNil(ListaPagina);
    end;

  finally
    FreeAndNil(PagIndexlist);
  end;


end;

{ TDecriptador }

constructor TDecriptador.Create(multicoldReport: TMulticoldReport; const AOrig: Boolean = false);
begin
  inherited Create;
  FMulticoldReport := multicoldReport;
  FDescompactador := TZipDescompactador.Create;
  FOrig := AOrig;
end;

function TDecriptador.Decripta: AnsiString;
begin
  FDescompactador.Descompactar(FMulticoldReport.PaginaCompactada, FMulticoldReport.QtdeBytesComp);
  FBuffer := FDescompactador.Buffer;
  FQtdeBytes := FDescompactador.QtdeBytes;
end;

destructor TDecriptador.Destroy;
begin
  FreeAndNil(FDescompactador);
  inherited;
end;

{ TDecriptador133 }

function TDecriptador133.Decripta: AnsiString;
Var
  I, Ind : Integer;
  Buffer: Pointer;
  BufferA : ^TgArr20000 Absolute Buffer;
  Apendix : AnsiString;
  ComandoDeCarro,
  AuxTemp,
  Teste : AnsiChar;
  PaginaNormal,
  PaginaAcertada: AnsiString;

begin
  inherited;
  Buffer := FBuffer;
  SetLength(PaginaNormal,10000);
  SetLength(PaginaAcertada,10000);
  I := 1;
  for Ind := 1 To FDescompactador.QtdeBytes Do
  begin
    if FMulticoldReport.ComprimeBrancos then
    begin
      If (Byte(BufferA^[Ind]) And $80) = $80 Then
      begin
        AuxTemp := BufferA^[Ind];
        If Byte(BufferA^[Ind]) = $80 Then
          Teste := #$0
        Else
          Teste := #$80;
        repeat
          PaginaNormal[I] := ' ';
          Inc(I);
          If I > Length(PaginaNormal) Then
            SetLength(PaginaNormal,Length(PaginaNormal)+10000);
          Dec(AuxTemp);
        until AuxTemp = Teste;
      end else
      begin
        PaginaNormal[I] := (BufferA^[Ind]);
        Inc(I);
        If I > Length(PaginaNormal) Then
          SetLength(PaginaNormal,Length(PaginaNormal)+10000);
      end;
    end else
    begin // Se n�o comprime brancos
      PaginaNormal[I] := (BufferA^[Ind]);
      Inc(I);
      If I > Length(PaginaNormal) Then
        SetLength(PaginaNormal,Length(PaginaNormal)+10000);
    end;
  end;
  SetLength(PaginaNormal,I-1); // Ajusta o tamanho certo
  Apendix := '';
  PaginaAcertada[1] := ' ';
  I := 2;
  For Ind := 2 To Length(PaginaNormal) Do
    If (PaginaNormal[Ind-1] = #10) And (PaginaNormal[Ind] <> #13) Then // � Comando de carro, vai tratar...
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
    End Else
    Begin
      PaginaAcertada[I] := PaginaNormal[Ind];
      Inc(I);
      If I > Length(PaginaAcertada) Then
        SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
    End;
    SetLength(PaginaAcertada,I-1); // Ajusta
    PaginaNormal := PaginaAcertada;
    Result := PaginaNormal;
end;

{ TDecriptadorOutros }

function TDecriptadorOutros.Decripta: AnsiString;
Var
  I, Ind : Integer;
  Buffer: Pointer;
  BufferA : ^TgArr20000 Absolute Buffer;
  Apendix : AnsiString;
  ComandoDeCarro,
  AuxTemp,
  Teste : AnsiChar;
  PaginaNormal,
  PaginaAcertada: AnsiString;

begin
  inherited;
  Buffer := FBuffer;
  SetLength(PaginaNormal,10000);
  SetLength(PaginaAcertada,10000);
  I := 1;
  for Ind := 1 To FDescompactador.QtdeBytes do
  begin
    If FMulticoldReport.ComprimeBrancos Then
    Begin
      if (Byte(BufferA^[Ind]) And $80) = $80 Then
      begin
        AuxTemp := BufferA^[Ind];
        If Byte(BufferA^[Ind]) = $80 Then
          Teste := #$0
        Else
          Teste := #$80;
        repeat
          PaginaAcertada[I] := ' ';
          Inc(I);
          If I > Length(PaginaAcertada) Then
            SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
          Dec(AuxTemp);
        Until AuxTemp = Teste;
      end else
      begin
        PaginaAcertada[I] := BufferA^[Ind];
        Inc(I);
        If I > Length(PaginaAcertada) Then
          SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
      end;
    end else
    begin
      PaginaAcertada[I] := BufferA^[Ind];
      Inc(I);
      If I > Length(PaginaAcertada) Then
        SetLength(PaginaAcertada,Length(PaginaAcertada)+10000);
    end;
  end;
  SetLength(PaginaAcertada,I-1); // Ajusta o tamanho
  PaginaNormal := PaginaAcertada;

  Result := PaginaNormal;
end;


{ TDecriptadorFactory }

class function TDecriptadorFactory.ObterDecriptador(
  multicoldReport: TMulticoldReport; aForceOriginal: Boolean = false): TDecriptador;
begin
  if (multicoldReport.Rel133) and Not(multicoldReport.Orig) and Not (aForceOriginal) then
    Result := TDecriptador133.Create(multicoldReport)
  else
    Result := TDecriptadorOutros.Create(multicoldReport);
end;

{ TDescompactador }

procedure TZipDescompactador.Descompactar(paginaCompactada: AnsiString;
  QtdeBytesComp: Integer);
Var
  QtdBytesPagRel,
  varPag : WideString;
  Buffer, BufI : Pointer;
  BufferA : ^TgArr20000 Absolute Buffer;
  V : Variant;
  auxPag: AnsiString;
  QtPagRel: Integer;
begin
    auxPag := paginaCompactada;
    QtPagRel := QtdeBytesComp;

    GetMem(BufI, QtPagRel div 2);

    GetMem(Buffer, QtPagRel div 2);
    hexToBin(PAnsiChar(auxPag), PAnsiChar(BufferA), QtPagRel div 2);
    Move(BufferA^, BufI^, QtPagRel div 2);
    ReallocMem(Buffer,0);
    try
      ZDecompress(BufI, QtdeBytesComp, Buffer, QtPagRel, 0);
    except
      on e: Exception do
      begin
        // Logar o Erro!!!
      end;
    end;

    FBuffer := Buffer;
    FQtdeBytes := QtPagRel;
end;


end.