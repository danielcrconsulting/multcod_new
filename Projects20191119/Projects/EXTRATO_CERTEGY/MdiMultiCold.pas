Unit MdiMultiCold;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, ComCtrls, XceedZipLib_TLB, Db, DBTables, StdCtrls, Buttons, ExtCtrls,
  Menus, DBClient, MConnect, SConnect, ComObj, OleServer, Word97;

{
  24/02/2000

  Exclusão de campo do template: Era sempre o último o excluído, agora o ativo é o excluído. Toda a parte de referência
                                 aos componentes StringGrid teve de ser alterada
  A mudança na forma de excluir havia criado um bug na importação de campos - Fixed
  A referência das definições de campos da DFN, quando da importação, estavam no Grid do Form Analisador. O Grid
  auxiliar e de cada relatório foi usado para armazenar estas definições em cada abertura de relatório. A referência
  do template foi alterada para o Grid auxiliar.

  R4 - 11/03/2000
  O form Analisador tinha em seu método CreateForm código para ler do ini cold_service.ini
  A alteração consistiu da identificação do programa sendo executado para não fazer a leitura do ini pelo multedit.exe

  22/03/2000 - Pequenas modificações na geração do SQL a partir do form de Query Fácil
  1) O mesmo campo pode ser referenciado mais de uma vez com And o OR
  2) O Not foi reposicionado, pois verificou-se que o BDE o está aceitando próximo do operador no Select.
  3) Reativação do OR apenas para o mesmo campo e sem estar misturado a And

  23/03/2000 - A impressão de pesquisa com várias linhas em uma página estava com problema.
               Em cada página, apenas a última linha marcada era impressa. O Programa não
               estava verificando a presença de mais de um campo na query de resposta.
               O Not foi recolocado em seu lugar, antes da sentença, pois alguns operadores
               como = não aceitam a construção NOT =, e sim NOT Campo =. O programa retira o
               NOT do campo e o devolve para manter a integridade do operador no Grid.
  24/04/2000 - Outro dia percebi que a variável filemode não estava sendo alterada para
               0 (abrir read only). Ao testar com arquivos vindos de CD o programa não abriu
               os relatórios pois os arquivos conservavam o status read only do CD. Coloquei
               Filemode = 0 na rotina de abertura dos relatórios e no final retorna o valor
               read write, FileMode = 2
  17/05/2000 - Foi realizada a centralização das telas dos forms do programa
  18/05/2000 - O bug do ponteiro buffer estava causando  uma instabilidade enorme ao programa. No form create dos forms
               filhos havia um buffer := nil, sendo o buffer uma variável global para uso de todas as janelas abertas.
               Esta inicialização foi colocada no create form deste form aqui (pai);
               A correção deste problema não ajudou em nada. Na leitura dos dados guardados em disco, quando da mudança
               de janela e de modo (texto/imagem) não havia o redimencionamento do buffer de I/O. Se a janela anterior o
               houvesse setado para um tamanho menor, mudar a janela e mudar o modo provocava uma leitura dos dados em
               disco e consequentemente uma invasão de memória que com o tempo explodia o programa.
  19/05/2000 - Ainda se verificou um abend ao fechar o programa na seguinte situação:
               Várias janelas abertas, manipulações, uma fechada, fechado o programa. Para
               Tentar corrigir no onclose do MDIPai foi colocado um loop fechando todas as
               janelas filhas.
  23/05/2000 - Implementado o esquema de segurança. Esta versão abre os relatórios antigos e os novos seguros ou não.
               O Editor antigo se torna incompatível com os relatórios produzidos a partir de agora. O IAP passou a
               utilizar registro Int64 podendo (teoricamente) gerar arquivos de mais de 2gb de tamanho.
  26/05/2000 - Coloquei um offset maior no cálculo do scroll inicial da página com pesquisa para puxar a imagem da
               página mais para cima no caso dos campos localizados mais em baixo. DESCOBRI QUE O "COINITIALIZE não
               foi chamado" retorna se um componente XCeedZip for colocado em algum form deste projeto???? Instanciar
               o objeto XCeed na hora do uso funciona (no DFN) e não dá problema.
  14/06/2000 - Pesquisas levaram a conclusão que o problema do menu das telas child desta aplicação MDI pode ser resolvido
               com o uso de apenas um menu principal (controlando as opções com enable := true ou false. Há um problema
               no gerenciamento da fusão dos menus principal e filhos (não sei se do Delphi ou do Windows);
  20/06/2000 - Implementação da versão cliente servidor...

}

Type
  TFrameForm = Class(TForm)
    TableDst: TTable;
    TableDfn: TTable;
    SpeedPanel: TPanel;
    PlusZoom: TSpeedButton;
    LessZoom: TSpeedButton;
    NormalZoom: TSpeedButton;
    AbreQueryFacil: TSpeedButton;
    RepetePesquisa: TSpeedButton;
    Label5: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    AbreRelBut: TSpeedButton;
    Imprimir: TSpeedButton;
    Descompactar: TSpeedButton;
    Exportar: TSpeedButton;
    Label3: TLabel;
    EditPes: TEdit;
    VaiPesquisa: TButton;
    EditPag: TEdit;
    VaiPagina: TButton;
    Memo2: TMemo;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    PrinterSetupDialog1: TPrinterSetupDialog;
    OpenReportDialog: TOpenDialog;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    AbrirAssistido1: TMenuItem;
    AbrirRemoto1: TMenuItem;
    Fechar1: TMenuItem;
    N1: TMenuItem;
    ConfigurarImpressora1: TMenuItem;
    ConfigurarFontedeImpresso1: TMenuItem;
    ImprimirRelatrio1: TMenuItem;
    DescompactarRelatrio1: TMenuItem;
    ExportarRelatrio1: TMenuItem;
    PesquisaemGrupo1: TMenuItem;
    Separator3: TMenuItem;
    Exit1: TMenuItem;
    Editar1: TMenuItem;
    CopiarPgina1: TMenuItem;
    AproximarZoom1: TMenuItem;
    AfastarZoomOut1: TMenuItem;
    Normal1001: TMenuItem;
    ConfigurarFontedeVdeo1: TMenuItem;
    ConfigurarCordoFundo1: TMenuItem;
    ModoTexto1: TMenuItem;
    CopiarTextoSelecionado1: TMenuItem;
    Pesquisar1: TMenuItem;
    MontarQueryFcil1: TMenuItem;
    RepeteltimaPesquisa1: TMenuItem;
    Prxima1: TMenuItem;
    Anterior1: TMenuItem;
    Pgina1: TMenuItem;
    Prxima2: TMenuItem;
    Anterior2: TMenuItem;
    Window1: TMenuItem;
    Tile1: TMenuItem;
    LadoaLado1: TMenuItem;
    Cascade1: TMenuItem;
    ArrangeIcons1: TMenuItem;
    Info1: TMenuItem;
    SobreoMultiCold1: TMenuItem;
    MemoAux: TMemo;
    WebConnection1: TWebConnection;
    N2: TMenuItem;
    He1: TMenuItem;
    Extrair: TSpeedButton;
    procedure AbreRelButClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure LadoaLado1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure ArrangeIcons1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PlusZoomClick(Sender: TObject);
    procedure LessZoomClick(Sender: TObject);
    procedure NormalZoomClick(Sender: TObject);
    procedure AbreQueryFacilClick(Sender: TObject);
    procedure RepetePesquisaClick(Sender: TObject);
    procedure VaiPesquisaClick(Sender: TObject);
    procedure VaiPaginaClick(Sender: TObject);
    procedure ImprimirClick(Sender: TObject);
    procedure PesquisaemGrupo1Click(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure DescompactarClick(Sender: TObject);
    procedure ExportarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SobreoMultiCold1Click(Sender: TObject);
    procedure AbrirAssistido1Click(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure ConfigurarImpressora1Click(Sender: TObject);
    procedure ConfigurarFontedeImpresso1Click(Sender: TObject);
    procedure CopiarPgina1Click(Sender: TObject);
    procedure ConfigurarFontedeVdeo1Click(Sender: TObject);
    procedure ConfigurarCordoFundo1Click(Sender: TObject);
    procedure ModoTexto1Click(Sender: TObject);
    procedure CopiarTextoSelecionado1Click(Sender: TObject);
    procedure Prxima1Click(Sender: TObject);
    procedure Anterior1Click(Sender: TObject);
    procedure Prxima2Click(Sender: TObject);
    procedure Anterior2Click(Sender: TObject);
    procedure AbrirRemoto1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure ExtrairClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }

    Function VerificaSeguranca(NomeRel : String) : Boolean;
    Procedure AbreRel(NomeRel : String; EhRemoto : Boolean);
    Procedure Scrolla1;
    Procedure Scrolla2;
    Function CarregaDadosDfnIncExc : Boolean;
    Function LocalizaCodRel(CodRel : String) : Integer; // Retorna o ponteiro, se = -1, não achou...

  End;

Var
  FrameForm: TFrameForm;

Implementation

Uses Subrug, Scampo, MdiEdit, SuGeral, RFMImage, Gridque,
  Avisoi, Imprim, Descom, Template, Sobre, AssisAbre, Printers, LogInForm,
  MExtract;

{$R *.DFM}

Function TFrameForm.CarregaDadosDfnIncExc : Boolean;
Var
  I : Integer;
Begin
Result := True;

If Length(ArDFN) <> 0 Then // Já carregou uma vez, então não repete a carga......
  Exit;

Avisop.Label1.Caption := 'Carregando dados...';
Avisop.Show;
Application.ProcessMessages;

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableDFN.TableName+'" A');
FormGeral.QueryLocal1.Sql.Add('ORDER BY A.CODREL ');
Try
  FormGeral.QueryLocal1.Open;
Except
  ShowMessage('Erro ao tentar carregar dados de DFN');
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArDFN, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArDFN[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  ArDFN[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArDFN[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArDFN[I].GrupoAuto := (FormGeral.QueryLocal1.FieldByName('CodGrupAuto').AsString = 'T');
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuRel.TableName+'" A');
FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND ');
FormGeral.QueryLocal1.Sql.Add('      (A.TIPO = ''INC'') ');
Try
  FormGeral.QueryLocal1.Open;
Except
  ShowMessage('Erro ao tentar carregar dados de USUREL INC');
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArINC, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArINC[I].CodUsu := FormGeral.QueryLocal1.FieldByName('CodUsuario').AsString;
  ArINC[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArINC[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArINC[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuRel.TableName+'" A');
FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') AND ');
FormGeral.QueryLocal1.Sql.Add('      (A.TIPO = ''EXC'') ');
Try
  FormGeral.QueryLocal1.Open;
Except
  ShowMessage('Erro ao tentar carregar dados de USUREL EXC');
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArEXC, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArEXC[I].CodUsu := FormGeral.QueryLocal1.FieldByName('CodUsuario').AsString;
  ArEXC[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArEXC[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArEXC[I].CodRel := FormGeral.QueryLocal1.FieldByName('CodRel').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableGruposDFN.TableName+'" A');
//FormGeral.QueryLocal1.Sql.Add('WHERE A.CODGRUPO >= 0 ');
//FormGeral.QueryLocal1.Sql.Add('ORDER BY A.CODGRUPO ');
Try
  FormGeral.QueryLocal1.Open;
Except
  ShowMessage('Erro ao tentar carregar dados de '+viGrupo);
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArGrupo, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArGrupo[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArGrupo[I].NomeGrupo := FormGeral.QueryLocal1.FieldByName('NomeGrupo').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Sql.Clear;
FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableSubGruposDFN.TableName+'" A');
Try
  FormGeral.QueryLocal1.Open;
Except
  ShowMessage('Erro ao tentar carregar dados de '+viSubGrupo);
  Result := False;
  Avisop.Close;
  Exit;
  End; // Try

While Not FormGeral.QueryLocal1.Eof Do
  FormGeral.QueryLocal1.Next;   // Estabelecer o recordcount correto

SetLength(ArSubGrupo, FormGeral.QueryLocal1.RecordCount);

FormGeral.QueryLocal1.Close;
FormGeral.QueryLocal1.Open;
I := 0;
While Not FormGeral.QueryLocal1.Eof Do
  Begin
  ArSubGrupo[I].CodGrupo := FormGeral.QueryLocal1.FieldByName('CodGrupo').AsInteger;
  ArSubGrupo[I].CodSubGrupo := FormGeral.QueryLocal1.FieldByName('CodSubGrupo').AsInteger;
  ArSubGrupo[I].NomeSubGrupo := FormGeral.QueryLocal1.FieldByName('NomeSubGrupo').AsString;
  Inc(I);
  FormGeral.QueryLocal1.Next;
  End;

FormGeral.QueryLocal1.Close;

Avisop.Close;

End;

Function TFrameForm.LocalizaCodRel(CodRel : String) : Integer;
Var
  I : Integer;
Begin
Result := -1;

For I := 0 To Length(ArDFN)-1 Do
  If ArDFN[I].CodRel = CodRel Then
    Begin
    Result := I;
    Break;
    End;
End;

Function TFrameForm.VerificaSeguranca;
Var
  ArqCodGrupo : File Of Integer;
  PassouGrupoSubGrupoRel,
  Teste : Boolean;
  I,
  CodGrupoDFNAtu,  // Está na DFN da base
  CodGrupoDFNOld,  // Está na DFN do relatório
  CodGrupoDFNGrp,  // Está no arquivo GRP
  CodSubGrupoDFNAtu,  // Está na DFN da base
  CodSubGrupoDFNOld : Integer; // Está na DFN do relatório
  CodRel : String;

Begin
Result := True;

If FileExists(ChangeFileExt(NomeRel,'.IAPS')) Then // Novo formato, candidato a segurança
  Begin

  TableDst.Close;
  TableDst.DatabaseName := ExtractFilePath(NomeRel);
  TableDst.TableName := SeArquivoSemExt(NomeRel)+'Dst.db';
  TableDst.Open;
  If UpperCase(TableDst.FieldByName('Seguranca').AsString) = 'S' Then
    Begin

    FormGeral.QueryLocal1.Close;
    FormGeral.QueryLocal1.Sql.Clear;
    FormGeral.QueryLocal1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuarios.TableName+'" A');
    FormGeral.QueryLocal1.Sql.Add('WHERE (A.CODUSUARIO = '''+UpperCase(GetCurrentUserName)+''') ');
    Try
      FormGeral.QueryLocal1.Open;
    Except
      ShowMessage('Base de segurança não encontrada. Impossível autenticar usuário');
      Result := False;
      Exit;
      End; //Try
    If FormGeral.QueryLocal1.FieldByName('NomeGrupoUsuario').AsString = 'ADMSIS' Then
      Begin
      FormGeral.QueryLocal1.Close;   // Usuario admsis pode ver tudo
      Exit;
      End;

    CodRel := UpperCase(TableDst.FieldByName('CodRel').AsString); // Código do relatório em questão

    If Not CarregaDadosDfnIncExc Then
      Begin
      ShowMessage('Base de segurança não encontrada. Impossível autenticar usuário');
      Result := False;
      TableDst.Close;
      Exit;
      End;

    I := LocalizaCodRel(CodRel);

    If I = -1 Then
      Begin
      ShowMessage('Erro seek CodRel, abortando ...');
      Result := False;
      TableDst.Close;
      Exit;
      End;

    CodGrupoDFNAtu := ArDFN[I].CodGrupo;
    CodSubGrupoDFNAtu := ArDFN[I].CodSubGrupo;
    CodGrupoDFNOld := CodGrupoDFNAtu;
    CodSubGrupoDFNOld := CodSubGrupoDFNAtu;
    CodGrupoDFNGrp := CodGrupoDFNAtu;

    Try
      TableDfn.Close;
      TableDfn.DatabaseName := ExtractFilePath(NomeRel);
      TableDfn.TableName := SeArquivoSemExt(NomeRel)+'Dfn.db';
      TableDfn.Open;
      CodGrupoDFNOld := TableDfn.FieldByName('CodGrupo').AsInteger;
      CodSubGrupoDFNOld := TableDfn.FieldByName('CodSubGrupo').AsInteger;
      Try
        Teste := TableDfn.FieldByName('CodGrupAuto').AsBoolean;
      Except
        Teste := False;  // Versão antiga não tem esta informação na dfn
        End; // Try
      If Teste Then
        Begin
        AssignFile(ArqCodGrupo,ChangeFileExt(NomeRel,'.Grp'));
        Reset(ArqCodGrupo);
        Read(ArqCodGrupo,CodGrupoDFNGrp);
        CloseFile(ArqCodGrupo);
        End;
      TableDfn.Close;
    Except
      TableDfn.Close;
      End; // Try

    If Length(ArINC) = 0 Then // Nenhuma definição de Inclusão para este usuário
        Result := False;

    PassouGrupoSubGrupoRel := False;

    For I := 0 To Length(ArINC) - 1 Do
      Begin
      If (ArINC[I].CodGrupo = -999) Or
         (ArINC[I].CodGrupo = CodGrupoDFNAtu) Or
         (ArINC[I].CodGrupo = CodGrupoDFNOld) Or
         (ArINC[I].CodGrupo = CodGrupoDFNGrp) Then
      If (ArINC[I].CodSubGrupo = -999) Or
         (ArINC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
         (ArINC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
      If (ArINC[I].CodRel = '*') Or
         (ArINC[I].CodRel = CodRel) Then
        Begin
        PassouGrupoSubGrupoRel := True;
        Break;
        End;
      End;

    For I := 0 To Length(ArEXC) - 1 Do
      Begin
      If (ArEXC[I].CodGrupo = -999) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNAtu) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNOld) Or
         (ArEXC[I].CodGrupo = CodGrupoDFNGrp) Then
      If (ArEXC[I].CodSubGrupo = -999) Or
         (ArEXC[I].CodSubGrupo = CodSubGrupoDFNAtu) Or
         (ArEXC[I].CodSubGrupo = CodSubGrupoDFNOld) Then
      If (ArEXC[I].CodRel = '*') Or
         (ArEXC[I].CodRel = CodRel) Then
        Begin
        Result := False;
        Break;
        End;
      End;

    If Result And PassouGrupoSubGrupoRel Then
      Begin
      // Muito Bem, Passou por todos os testes..............
      End
    Else
      Result := False;

    FormGeral.QueryLocal1.Close;
    End;
  TableDst.Close;
  End;
End;

Procedure TFrameForm.AbreRel(NomeRel : String; EhRemoto : Boolean);
Var
  I : Integer;
Begin
With TEditForm.Create(Application) Do
  If Open(NomeRel, EhRemoto) Then
    Begin

    If Not EhRemoto Then
      OpenReportDialog.InitialDir := ExtractFilePath(NomeRel);
    ScrollBar1.Position := 0;
    ScrollBar1.Min := 0;
    ScrollBar1.Max := 0;
    Label1.Caption := '1 de 1';

    Scroll1Min := 0;
    Scroll1Max := 0;
    Scroll1Pos := 0;
    Lab1 := Label1.Caption;

    ScrollBar2.Position := 0;
    ScrollBar2.Min := 0;
    ScrollBar2.Max := Paginas-1;
    Label2.Caption := '1 de ' + IntToStr(Paginas);

    Scroll2Min := 0;
    Scroll2Max := Paginas-1;
    Scroll2Pos := 0;
    Lab2 := Label2.Caption;

    With SelCampo.Campos Do
      Begin
      For I := 1 To DefChave.RowCount+1 Do
        Begin
        Cells[0,I] := IntToStr(I);
        Cells[1,I] := DefChave.Cells[6,I];
        Cells[2,I] := DefChave.Cells[7,I];
        Cells[3,I] := DefChave.Cells[3,I];
        End;
      Cells[1,0] := 'Campo';
      Cells[2,0] := 'Tipo';
      Cells[3,0] := 'Col';
      End;

    Fechar1.Enabled := True;
    ConfigurarImpressora1.Enabled := Fechar1.Enabled;
    ConfigurarFonteDeImpresso1.Enabled := Fechar1.Enabled;
    ImprimirRelatrio1.Enabled := Fechar1.Enabled;
    DescompactarRelatrio1.Enabled := Fechar1.Enabled;
    ExportarRelatrio1.Enabled := Fechar1.Enabled;
    CopiarPgina1.Enabled := Fechar1.Enabled;
    AproximarZoom1.Enabled := Fechar1.Enabled;
    AfastarZoomOut1.Enabled := Fechar1.Enabled;
    Normal1001.Enabled := Fechar1.Enabled;
    ConfigurarFonteDeVdeo1.Enabled := Fechar1.Enabled;
    ConfigurarCorDoFundo1.Enabled := Fechar1.Enabled;
    ModoTexto1.Enabled := Fechar1.Enabled;
    CopiarTextoSelecionado1.Enabled := Fechar1.Enabled;
    MontarQueryFcil1.Enabled := Fechar1.Enabled;
    RepeteLtimaPesquisa1.Enabled := Fechar1.Enabled;
    Prxima1.Enabled := Fechar1.Enabled;
    Anterior1.Enabled := Fechar1.Enabled;
    Prxima2.Enabled := Fechar1.Enabled;
    Anterior2.Enabled := Fechar1.Enabled;
    Tile1.Enabled := Fechar1.Enabled;
    LadoALado1.Enabled := Fechar1.Enabled;
    Cascade1.Enabled := Fechar1.Enabled;
    ArrangeIcons1.Enabled := Fechar1.Enabled;
    End
  Else
    Close;
End;

Procedure TFrameForm.AbreRelButClick(Sender: TObject);
Var
  J : Integer;
Begin

If Sender = AbreRelBut Then
  Try
    FormGeral.TableDFN.Open;
    FormGeral.TableDFN.Close;
    If JaAbriu Then
      AssisAbreForm.Show
    Else
      FrameForm.AbrirAssistido1.Click;
    Exit;
  Except
    End; // Try

If OpenReportDialog.Execute Then
  For J := OpenReportDialog.Files.Count-1 DownTo 0 Do
    If VerificaSeguranca(OpenReportDialog.Files[J]) Then
      AbreRel(OpenReportDialog.Files[J], False)
    Else
      ShowMessage('Usuário '+UpperCase(GetCurrentUserName)+' não autorizado a abrir este relatório');
End;

Procedure TFrameForm.Exit1Click(Sender: TObject);
Begin
Close
End;

Procedure TFrameForm.Tile1Click(Sender: TObject);
Begin
TileMode := tbHorizontal;
Tile;
End;

Procedure TFrameForm.LadoaLado1Click(Sender: TObject);
Begin
TileMode := tbVertical;
Tile;
End;

Procedure TFrameForm.Cascade1Click(Sender: TObject);
Begin
Cascade;
End;

Procedure TFrameForm.ArrangeIcons1Click(Sender: TObject);
Begin
ArrangeIcons;
End;

Procedure TFrameForm.Help1Click(Sender: TObject);
Var
  WordApp : OleVariant;
Begin
Try
  WordApp := CreateOleObject('Word.Application');
Except
    ShowMessage('MS Word não está instalado neste computador...');
    Exit;
  End; // Try

WordApp.Documents.Open(ExtractFilePath(TheFileName)+CmdExtra);

WordApp.Visible := True;
End;

Procedure TFrameForm.FormCreate(Sender: TObject);

Var
  ArqExtra : System.Text;
Begin

JaAbriu := False;
SetouPrivateDir := False;
ConectouRemoto := False;

MDIEdit.NomRede := -1;
MDIEdit.BufIn := Nil;
MDIEdit.Buffer := Nil;

AbriuArqQue := False;
ScrollBar1.Position := 0;
ScrollBar1.Min := 0;
ScrollBar1.Max := 0;
ScrollBar2.Position := 0;
ScrollBar2.Min := 0;
ScrollBar2.Max := 0;
Label1.Caption := '';
Label2.Caption := '';
Label3.Caption := '';
GetDir(0,Direct);
ChDir(Direct);
OpenReportDialog.InitialDir := Direct;

If FileExists(ExtractFilePath(TheFileName)+'COMANDO.DAT') Then
  Begin
  AssignFile(ArqExtra,ExtractFilePath(TheFileName)+'COMANDO.DAT');
  Reset(ArqExtra);
  ReadLn(ArqExtra,CmdExtra);
  CloseFile(ArqExtra);
  MainMenu1.Items[6].Visible := True;
  End
Else
  MainMenu1.Items[6].Visible := False;

If FileExists(ExtractFilePath(TheFileName)+'REMOTE.DAT') Then
  Begin
  AssignFile(ArqExtra,ExtractFilePath(TheFileName)+'REMOTE.DAT');
  Reset(ArqExtra);
  ReadLn(ArqExtra,RemoteServer);
  ReadLn(ArqExtra,PathServer);
  PathServer := IncludeTrailingBackSlash(PathServer);
  CloseFile(ArqExtra);
  End
Else
  Begin
  RemoteServer := '';
//  PathServer := viDirDatabase;
  PathServer := viPathBaseLocal;
  End;
  
Session.AddPassword(Senha);

End;

Procedure TFrameForm.PlusZoomClick(Sender: TObject);
Begin

If MdiChildCount = 0 Then
  Exit;

With TEditForm(ActiveMdiChild) Do
  Begin
  If RFMImage1.Width < 12750 Then
    Begin
    RFMImage1.DisplayOptions:= [rfmScale, rfmCenter];
    RFMImage1.Width := RFMImage1.Width + FatorX;
    RFMImage1.Height := RFMImage1.Height + FatorY;

    Inc(ZoomLevel);

    ScrollBox1.HorzScrollBar.Range := RFMImage1.Width+FatorX;
    ScrollBox1.VertScrollBar.Range := RFMImage1.Height+FatorY;
    End;

  Memo1.SelStart := 0;
  Memo1.SelLength := Length(Memo1.Lines.Text)-1;
  Memo1.Font.Size := Memo1.Font.Size + 1;
  Memo1.SelStart := 0;
  Memo1.SelLength := 0;

  End;
End;

Procedure TFrameForm.LessZoomClick(Sender: TObject);
Begin

If MdiChildCount = 0 Then
  Exit;

With TEditForm(ActiveMdiChild) Do
  Begin

  If RFMImage1.Width > 255 Then
    Begin
    RFMImage1.DisplayOptions:= [rfmScale, rfmCenter];
    RFMImage1.Width := RFMImage1.Width - FatorX;
    RFMImage1.Height := RFMImage1.Height - FatorY;

    Dec(ZoomLevel);

    ScrollBox1.HorzScrollBar.Range := RFMImage1.Width+FatorX;
    ScrollBox1.VertScrollBar.Range := RFMImage1.Height+FatorY;

    End;

  Memo1.SelStart := 0;
  Memo1.SelLength := Length(Memo1.Lines.Text)-1;
  Memo1.Font.Size := Memo1.Font.Size - 1;
  Memo1.SelStart := 0;
  Memo1.SelLength := 0;

  End;
End;

Procedure TFrameForm.NormalZoomClick(Sender: TObject);
Begin

If MdiChildCount = 0 Then
  Exit;

With TEditForm(ActiveMdiChild) Do
  Begin
  RFMImage1.DisplayOptions:= [rfmAutoSize];
  RFMImage1.Refresh;

  ZoomLevel := 0;

  ScrollBox1.HorzScrollBar.Range := RFMImage1.Width+FatorX;
  ScrollBox1.VertScrollBar.Range := RFMImage1.Height+FatorY;

  Memo1.SelStart := 0;
  Memo1.SelLength := Length(Memo1.Lines.Text)-1;
  Memo1.Font.Size := Video.Size;
  Memo1.SelStart := 0;
  Memo1.SelLength := 0;

  End;
End;

Procedure TFrameForm.AbreQueryFacilClick(Sender: TObject);
Var
  J, PAnd,
  Linha,
  ICampos,
  TotalDeCampos   : Integer;
  Caspa,
  Parente,
  Parente1,
  Abre,
  Fecha,
  StrAux1,
  NotStr  : String;
  ListaDeCampos : Array[1..100] Of String;
  TemAnd,
  TemOr : Boolean;

  Function RepetiuCampo(CampoAtu : Integer) : Boolean;
  Var
    I : Integer;
  Begin
  Result := False;
  For I := 1 To CampoAtu-1 Do
    Begin
    If QueryDlg.GridPesq.Cells[1,I] = QueryDlg.GridPesq.Cells[1,CampoAtu] Then
      Begin
      Result := True;
      Exit;
      End;
    End;
  End;

Begin

If MdiChildCount = 0 Then
  Exit;

If QueryDlg.ShowModal = mrCancel Then
  Exit;
If QueryDlg.GridPesq.Cells[1,1] = '' Then
  Exit;

TemAnd := False;
TemOr := False;
ICampos := 0;
TotaldeCampos := 0;
Memo2.Clear;
Memo2.Lines.Add('SELECT * FROM ');

For Linha := 1 To 100 Do
  If QueryDlg.GridPesq.Cells[1,Linha] <> '' Then
    Begin
    If (Linha > 1) And (Not RepetiuCampo(Linha)) Then
      Memo2.Lines[Memo2.Lines.Count-1] := Memo2.Lines[Memo2.Lines.Count-1] + ',';
    Parente := '';
    While (Length(QueryDlg.GridPesq.Cells[1,Linha]) > 0) And   // Retira os parênteses existentes
          (QueryDlg.GridPesq.Cells[1,Linha][1] = '(') Do       // Para pegar o nome Do campo limpo logo mais abaixo
      Begin
      Parente := Parente + '(';
      QueryDlg.GridPesq.Cells[1,Linha] := Copy(QueryDlg.GridPesq.Cells[1,Linha],2,
        Length(QueryDlg.GridPesq.Cells[1,Linha])-1);
      End;
    If Not RepetiuCampo(Linha) Then
      Begin
      Memo2.Lines.Add('"'+ChangeFileExt(TEditForm(ActiveMdiChild).FileName,'')+QueryDlg.GridPesq.Cells[1,Linha]+'.DBF'+'"'+' '+QueryDlg.GridPesq.Cells[1,Linha]);
      Inc(TotalDeCampos);
      Inc(ICampos);
      ListaDeCampos[ICampos] := QueryDlg.GridPesq.Cells[1,Linha]; // Reserva o campo distinto para a montagem Do And
                                                                 // de página e/ou linha abaixo
      End;
    QueryDlg.GridPesq.Cells[1,Linha] := Parente + QueryDlg.GridPesq.Cells[1,Linha];
    End
  Else
    Break;

Memo2.Lines.Add('WHERE');
For Linha := 1 To 100 Do
  If QueryDlg.GridPesq.Cells[1,Linha] <> '' Then
    Begin
    If UpperCase(TrimLeft(QueryDlg.GridPesq.Cells[2,Linha][1])) = 'N' Then
      Begin
      NotStr := 'NOT ';
      QueryDlg.GridPesq.Cells[2,Linha] := Copy(QueryDlg.GridPesq.Cells[2,Linha],5,
                Length(QueryDlg.GridPesq.Cells[2,Linha])-4);
      Abre := '(';
      Fecha := ')';
      End
    Else
      Begin
      NotStr := '';
      Abre := '';
      Fecha := '';
      End;

    If Linha = 1 Then
      NotStr := '( ' + NotStr;

//    If Linha = 1 Then
//      Abre := '('
//    Else
//      Abre := '';

    Caspa := '';
    For J := 1 To 99 Do      //Aqui
      If AnsiUppercase(QueryDlg.GridPesq.Cells[1,Linha]) = AnsiUppercase(SelCampo.Campos.Cells[1,J]) Then
        Begin
        If (UpperCase(SelCampo.Campos.Cells[2,J]) = 'C') Or  // Tratamento automático de campos character
           (UpperCase(SelCampo.Campos.Cells[2,J]) = 'DT') Then // ou data, colocando a caspa
          Caspa := '''';

        If AnsiUppercase(QueryDlg.GridPesq.Cells[2,Linha]) = 'IN' Then
          Caspa := '';

        Break;
        End;

    If AnsiUppercase(QueryDlg.GridPesq.Cells[2,Linha]) = 'BETWEEN' Then
      Begin
      PAnd := Pos('AND',AnsiUppercase(QueryDlg.GridPesq.Cells[3,Linha]));
      Memo2.Lines.Add(NotStr+Abre+QueryDlg.GridPesq.Cells[1,Linha] + '.VALOR '+
                      QueryDlg.GridPesq.Cells[2,Linha]+ ' ' + Caspa +
                      Copy(QueryDlg.GridPesq.Cells[3,Linha],1,PAnd-2) + Caspa + ' AND ' +
                      Caspa + Copy(QueryDlg.GridPesq.Cells[3,Linha],PAnd+4,
                                 Length(QueryDlg.GridPesq.Cells[3,Linha])-PAnd-3) +
                      Caspa + Fecha + ' ' +
                      QueryDlg.GridPesq.Cells[4,Linha]);

      End
    Else
      Memo2.Lines.Add(NotStr+Abre+QueryDlg.GridPesq.Cells[1,Linha] + '.VALOR '+
                      QueryDlg.GridPesq.Cells[2,Linha]+ ' ' + Caspa +
                      QueryDlg.GridPesq.Cells[3,Linha] + Caspa + Fecha + ' ' +
                      QueryDlg.GridPesq.Cells[4,Linha]);

    If UpperCase(Trim(QueryDlg.GridPesq.Cells[4,Linha])) = 'AND' Then
      TemAnd := True
    Else
      If UpperCase(Trim(QueryDlg.GridPesq.Cells[4,Linha])) = 'OR' Then
        TemOr := True;

    If Abre <> '' Then // O Not foi movido e vai ser recolocado
      QueryDlg.GridPesq.Cells[2,Linha] := 'NOT ' + QueryDlg.GridPesq.Cells[2,Linha];

    End
  Else
    Break;

Parente := '';
While (QueryDlg.GridPesq.Cells[1,1][1] = '(') And
      (Length(QueryDlg.GridPesq.Cells[1,1]) > 0) Do
  Begin
  Parente := Parente + '(';
  QueryDlg.GridPesq.Cells[1,1] := Copy(QueryDlg.GridPesq.Cells[1,1],2,
    Length(QueryDlg.GridPesq.Cells[1,1])-1);
  End;

If TotalDeCampos > 1 Then
  Begin
  For Linha := 2 To TotalDeCampos Do
    Begin
    Memo2.Lines[Memo2.Lines.Count-1] := Memo2.Lines[Memo2.Lines.Count-1] + ' AND';

    Parente1 := '';
    While (QueryDlg.GridPesq.Cells[1,Linha][1] = '(') And
          (Length(QueryDlg.GridPesq.Cells[1,Linha]) > 0) Do
      Begin
      Parente1 := Parente1 + '(';
      QueryDlg.GridPesq.Cells[1,Linha] := Copy(QueryDlg.GridPesq.Cells[1,Linha],2,
        Length(QueryDlg.GridPesq.Cells[1,Linha])-1);
      End;

    If QueryDlg.ProcurNaMesma.Checked Then
      Memo2.Lines.Add('(('+QueryDlg.GridPesq.Cells[1,1]+'.PAGINA = '+
                      QueryDlg.GridPesq.Cells[1,Linha]+ '.PAGINA'+') And ('+
                      QueryDlg.GridPesq.Cells[1,1]+'.LINHA = '+
                      QueryDlg.GridPesq.Cells[1,Linha]+ '.LINHA))')
    Else
      Memo2.Lines.Add(QueryDlg.GridPesq.Cells[1,1]+'.PAGINA = '+
                      QueryDlg.GridPesq.Cells[1,Linha]+ '.PAGINA');

    QueryDlg.GridPesq.Cells[1,Linha] := Parente1 + QueryDlg.GridPesq.Cells[1,Linha];

    End;
  End;

QueryDlg.GridPesq.Cells[1,1] := Parente + QueryDlg.GridPesq.Cells[1,1];

Memo2.Lines[Memo2.Lines.Count-1] := Memo2.Lines[Memo2.Lines.Count-1]+')';

If QueryDlg.ProcurSeq.Checked Then
  Begin
  StrAux1 := '';
  For Linha := 1 To 100 Do
    If QueryDlg.GridPesq.Cells[1,Linha+1] <> '' Then
      StrAux1 := StrAux1 + 'And (' + QueryDlg.GridPesq.Cells[1,Linha]+ '.RELATIVO < ' +
                                 QueryDlg.GridPesq.Cells[1,Linha+1]+ '.RELATIVO ' + ')';
  Memo2.Lines.Add(StrAux1);

  StrAux1 := '';
  For Linha := 1 To 100 Do
    If QueryDlg.GridPesq.Cells[1,Linha] <> '' Then
      StrAux1 := StrAux1 + QueryDlg.GridPesq.Cells[1,Linha]+ '.RELATIVO, ';
  Delete(StrAux1,Length(StrAux1)-1,2);

  End;

If QueryDlg.ProcurSeq.Checked Then
  Memo2.Lines.Add('ORDER BY PAGINA, '+StrAux1)
Else
  Memo2.Lines.Add('ORDER BY PAGINA, RELATIVO');

//Memo2.SelStart := 0;
//Memo2.SelLength := Length(Memo2.Lines.Text);  // não manda mais para o clipboard
//Memo2.CopyToClipBoard;

If TemAnd And TemOr Then
  ShowMessage('And e OR não podem ser misturados em uma query. Por favor, refaça sua pesquisa')
Else
If TemOr And (TotalDeCampos <> 1) Then
  ShowMessage('Campos distintos não podem ser misturados em uma query com OR. Por favor, refaça sua pesquisa')
Else
  RepetePesquisa.Click;
End;

Procedure TFrameForm.RepetePesquisaClick(Sender: TObject);

Var
  I, J, Ija,
  RCount,
  NumPag,
  QNumPag    : Integer;
  DeuErro   : Boolean;

Begin

If MdiChildCount = 0 Then
  Exit;

Ija := 0;
For I := 0 To (MdiChildCount - 1) Do
  If MdiChildren[I].Active Then
    Ija := I;

For J := Ija To Ija Do
  If (J = Ija) Or (PesquisaEmGrupo1.Checked) Then
    Begin
    EditPes.Text := '';
    EditPag.Text := '';
    Screen.Cursor := crHourGlass;

    With TEditForm(MdiChildren[J]) Do
      Begin
      AvisoP.Label1.Caption := 'Pesquisando ...';
      AvisoP.Show;
      AvisoP.Repaint;
      DeuErro := False;

      If RelRemoto Then
        Begin
        ClientDataSet1.Close;
//        DComConnection1.Connected := False;
//        DComConnection1.Connected := True;
//        WebConnection1.AppServer.SetSql(LogInRemotoForm.UsuEdit.Text,
//                                        LogInRemotoForm.PassEdit.Text,
//                                        ConnectionID,
//                                        Memo2.Text);

        ClientDataSet1.CommandText := Memo2.Text;
        
        Try
          ClientDataSet1.Open;
        Except
         On E:Exception Do
           Begin
           If J = Ija Then
             Begin
             Screen.Cursor := crDefault;
             ShowMessage('Query inválida... '+E.Message);
             AvisoP.Close;
             Exit;
             End
           Else
             DeuErro := True;
           End;
         End; // Try
        End
      Else
        Begin
        Query1.Close; { deixa a query inativa }
        Query1.Sql.Clear;
        Query1.Sql := Memo2.Lines;

        Try
          If Length(Query1.Sql.Text) > 6 Then
            Query1.Open
          Else
            DeuErro := True;

        Except
          On E: Exception Do
            If J = Ija Then
              Begin
              Screen.Cursor := crDefault;
              ShowMessage('Query inválida... '+E.Message);
              AvisoP.Close;
              Exit;
              End
            Else
              DeuErro := True;
        End; {Try..Except}
      End;

      AvisoP.Close;

      If RelRemoto Then
        RCount := ClientDataSet1.RecordCount
      Else
        RCount := Query1.RecordCount;

//      If (Not (DeuErro)) And (Query1.RecordCount <> 0) Then
      If (Not (DeuErro)) And (RCount <> 0) Then
        Begin
        ReWrite(ArqPsq); { Depósito de páginas com pesquisa OK }
        NumPag := -1;
//        For I := 1 To Query1.RecordCount Do
        For I := 1 To RCount Do
          Begin

          If RelRemoto Then
            QNumPag := ClientDataSet1.Fields[1].AsInteger
          Else
            QNumPag := Query1.Fields[1].AsInteger;

//          If Query1.Fields[1].AsInteger <> NumPag Then
          If QNumPag <> NumPag Then
            Begin
//            NumPag := Query1.Fields[1].AsInteger;
            NumPag := QNumPag;
            RegPsq.Pagina := NumPag;
            RegPsq.PosQuery := I;
            Write(ArqPsq,RegPsq);
            End;
          If RelRemoto Then
            ClientDataSet1.Next
          Else
            Query1.Next;
          End;
        Reset(ArqPsq); { Flush the file as soon as possible }
        Read(ArqPsq,RegPsq);
        Reset(ArqPsq); { Primeira informação }

        If RelRemoto Then
          Begin
          ClientDataSet1.First;
          QNumPag := ClientDataSet1.Fields[1].AsInteger - 1
          End
        Else
          Begin
          Query1.First;  { Returns To first key found }
          QNumPag := Query1.Fields[1].AsInteger - 1
          End;

        Ocorre := FileSize(ArqPsq);  { Número de Páginas }

//        ScrollBar2.Position := Query1.Fields[1].AsInteger - 1;
//        Scroll2Pos := Query1.Fields[1].AsInteger - 1;
        ScrollBar2.Position := QNumPag;
        Scroll2Pos := QNumPag;
        Label2.Caption := IntToStr(ScrollBar2.Position+1) + ' de ' + IntToStr(Paginas);
        Lab2 := Label2.Caption;
        Inicio := 0;                           { Depois de copiar os registros Inicio = 0}

        If Not RelRemoto Then
          If Pagina64 Then
            Begin
            Seek(ArqPag64,Query1.Fields[1].AsInteger-1);
            Read(ArqPag64,RegPag64);
            End
          Else
            Begin
            Seek(ArqPag32,Query1.Fields[1].AsInteger-1);
            Read(ArqPag32,RegPag32);
            RegPag64 := RegPag32;
            End;

//        CarregaImagem(RegPag64,True,Query1.Fields[1].AsInteger);
        CarregaImagem(RegPag64,True,QNumPag+1);

        ScrollBar1.Position := 0;
        Scroll1Pos := 0;
        If Ocorre > 1 Then
          Begin
          ScrollBar1.Min := 0;
          ScrollBar1.Max := Ocorre-1;
          Scroll1Min := 0;
          Scroll1Max := Ocorre-1;
          End
        Else
          Begin
          ScrollBar1.Min := 0;       { um só candidato }
          ScrollBar1.Max := 0;
          Scroll1Min := 0;
          Scroll1Max := 0;
          End;

        Label1.Caption := IntToStr(ScrollBar1.Position+1) + ' de ' + IntToStr(Ocorre);
        Lab1 := Label1.Caption;

        End
      Else
        If (not(DeuErro)) Then
          If J = Ija Then
            Begin
            Screen.Cursor := crDefault;
            ShowMessage('Nada encontrado!');
            Label1.Caption := '0 de 0';
            ScrollBar1.Position := 0;
            ScrollBar1.Min := 0;       { nenhum candidato }
            ScrollBar1.Max := 0;
            Scroll1Min := 0;
            Scroll1Max := 0;
            Scroll1Pos := 0;
            Ocorre := 0;
            End;
    End;
  End; { With }

Screen.Cursor := crDefault;

End;

Procedure TFrameForm.Scrolla1;
Begin
With TEditForm(ActiveMdiChild) Do
  Begin

  If (Ocorre = 0) or (Ocorre = 1) Then
    Exit;

  Screen.Cursor := crHourGlass;

  Scroll1Pos := ScrollBar1.Position;  { Saves location }

  Seek(ArqPsq,ScrollBar1.Position+Inicio);
  {$i-}
  Read(ArqPsq,RegPsq);
  {$i+}
  If IoResult <> 0 Then
    Begin
    ShowMessage('Erro de Scrolling Ind');
    Halt;
    End;

  If RelRemoto Then
    Begin
    ClientDataSet1.First;
    ClientDataSet1.MoveBy(RegPsq.PosQuery-1);
    ScrollBar2.Position := ClientDataSet1.Fields[1].AsInteger - 1;
    End
  Else
    Begin
    Query1.First;
    Query1.MoveBy(RegPsq.PosQuery-1);
    ScrollBar2.Position := Query1.Fields[1].AsInteger - 1;
    End;

  Scroll2Pos := ScrollBar2.Position;  { Saves location }

  If RelRemoto Then
    CarregaImagem(RegPag64,True,ClientDataSet1.Fields[1].AsInteger)
  Else
    Begin
    If Pagina64 Then
      Begin
      Seek(ArqPag64,Query1.Fields[1].AsInteger - 1);  { inicia de 0 }
      Read(ArqPag64,RegPag64);
      End
    Else
      Begin
      Seek(ArqPag32,Query1.Fields[1].AsInteger - 1);  { inicia de 0 }
      Read(ArqPag32,RegPag32);
      RegPag64 := RegPag32;
      End;
    CarregaImagem(RegPag64,True,Query1.Fields[1].AsInteger);
    End;
    
  Label1.Caption := IntToStr(ScrollBar1.Position+1) + ' de ' + IntToStr(Ocorre);
  Label2.Caption := IntToStr(ScrollBar2.Position+1) + ' de ' + IntToStr(Paginas);
  Lab1 := Label1.Caption;
  Lab2 := Label2.Caption;

  Screen.Cursor := crDefault;
  End;
End;

Procedure TFrameForm.Scrolla2;
Begin
With TEditForm(ActiveMdiChild) Do
  Begin

  Screen.Cursor := crHourGlass;

  Scroll2Pos := ScrollBar2.Position;  { Saves location }
  If Not RelRemoto Then
    If Pagina64 Then
      Begin
      Seek(ArqPag64,ScrollBar2.Position);
      Read(ArqPag64,RegPag64);
      End
    Else
      Begin
      Seek(ArqPag32,ScrollBar2.Position);
      Read(ArqPag32,RegPag32);
      RegPag64 := RegPag32;
      End;

  CarregaImagem(RegPag64,False,ScrollBar2.Position+1);

  Label2.Caption := IntToStr(ScrollBar2.Position+1) + ' de ' + IntToStr(Paginas);
  Lab2 := Label2.Caption;

  Screen.Cursor := crDefault;
  End;
End;

Procedure TFrameForm.VaiPesquisaClick(Sender: TObject);
Var
  Err : Integer;
  Posic : LongInt;
Begin

If MdiChildCount = 0 Then
  Exit;

If EditPes.Text = '' Then
  EditPes.Text := '1';
Val(EditPes.Text,Posic,Err);
If Err <> 0 Then
  Begin
  EditPes.Text := '1';
  Posic := 1;
  End;
If Posic < 1 Then
  Posic := 1;
ScrollBar1.Position := Posic-1;
Scrolla1;
End;

Procedure TFrameForm.VaiPaginaClick(Sender: TObject);
Var
  Err : Integer;
  Posic : LongInt;
Begin

If MdiChildCount = 0 Then
  Exit;

If EditPag.Text = '' Then
  EditPag.Text := '1';
Val(EditPag.Text,Posic,Err);
If Err <> 0 Then
  Begin
  EditPag.Text := '1';
  Posic := 1;
  End;
If Posic < 1 Then
  Posic := 1;
ScrollBar2.Position := Posic-1;
Scrolla2;
End;

Procedure TFrameForm.ImprimirClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
FrmImprim.ShowModal;
End;

Procedure TFrameForm.PesquisaemGrupo1Click(Sender: TObject);
Begin
PesquisaEmGrupo1.Checked := Not PesquisaEmGrupo1.Checked;
End;

Procedure TFrameForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; Var ScrollPos: Integer);
Begin
If ScrollCode <> scEndScroll Then
  Exit;
If MdiChildCount = 0 Then
  Exit;
Scrolla1;
End;

Procedure TFrameForm.ScrollBar2Scroll(Sender: TObject;
  ScrollCode: TScrollCode; Var ScrollPos: Integer);
Begin
If ScrollCode <> scEndScroll Then
  Exit;
If MdiChildCount = 0 Then
  Exit;
Scrolla2;
End;

Procedure TFrameForm.DescompactarClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
FrmDescom.Show;
End;

Procedure TFrameForm.ExportarClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
FrmTemplate.Show;
End;

Procedure TFrameForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Var
  I : Integer;
Begin
{$i-}                   { ArqQue Belongs To the Session So... }
CloseFile(ArqQue);
If IoResult = 0 Then;

Erase(ArqQue);
{$i+}
If IoResult = 0 Then;

For I := 0 To MDIChildCount - 1 Do
  Try
    MDIChildren[I].Close;
  Except
  End; // Try;

WebConnection1.Connected := False;
Session.RemoveAllPasswords;

Action := caFree;

End;

Procedure TFrameForm.SobreoMultiCold1Click(Sender: TObject);
Begin
SobreForm.ShowModal;
End;

Procedure TFrameForm.AbrirAssistido1Click(Sender: TObject);
Var
  I, J : Integer;
  Prima : Boolean;
  RelRoot : TTreeNode;

  Function PodeIncluir(J, CodGrupo : Integer) : Boolean;
  Var
    I : Integer;
  Begin
  Result := False;

  If ArDFN[J].CodRel = '*' Then
    Exit;

  For I := 0 To Length(ArINC) - 1 Do
    Begin
    If (ArINC[I].CodGrupo = -999) Or
       (ArINC[I].CodGrupo = CodGrupo) Then
    If (ArINC[I].CodSubGrupo = -999) Or
       (ArINC[I].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
    If (ArINC[I].CodRel = '*') Or
       (ArINC[I].CodRel = ArDFN[J].CodRel) Then
      Begin
      Result := True;
      Break;
      End;
    End;

  If Not Result Then
    Exit;

  For I := 0 To Length(ArEXC) - 1 Do
    Begin
    If (ArEXC[I].CodGrupo = -999) Or
       (ArEXC[I].CodGrupo = CodGrupo) Then
    If (ArEXC[I].CodSubGrupo = -999) Or
       (ArEXC[I].CodSubGrupo = ArDFN[J].CodSubGrupo) Then
    If (ArEXC[I].CodRel = '*') Or
       (ArEXC[I].CodRel = ArDFN[J].CodRel) Then
      Begin
      Result := False;
      Break;
      End;
    End;
  End;

Begin
If Not CarregaDadosDfnIncExc Then
  Begin
  ShowMessage('Base de relatórios não encontrada, use a abertura de relatórios não assistida');
  Exit;
  End; // Try

If JaAbriu Then
  Begin
  AssisAbreForm.Show;
  Exit;
  End;

// Tratamento dos relatórios da lista de inclusão

If Length(ArINC) = 0 Then
  Begin
  ShowMessage('Nenhum Relatório associado ao seu usuário: '+UpperCase(GetCurrentUserName));
  Exit;
  End;

// Add Items to the new structure used - TreeView


Avisop.Label1.Caption := 'Montando árvore, aguarde...';
Avisop.Show;
Application.ProcessMessages;

AssisAbreForm.TreeView1.Items.Clear;
AssisAbreForm.TreeView1.ReadOnly := True;
AssisAbreForm.TreeView1.SortType := stNone;

RelRoot := Nil;
For J := 0 To Length(ArDFN) - 1 Do
  Begin
  If ArDFN[J].GrupoAuto Then
    Begin
    Prima := True;
    For I := 0 To Length(ArGrupo) - 1 Do
      If PodeIncluir(J, ArGrupo[I].CodGrupo) Then
        Begin
        If Prima Then
          Begin
          RelRoot := AssisAbreForm.TreeView1.Items.Add(RelRoot,ArDFN[J].CodRel);
          Prima := False;
          End;
        With AssisAbreForm.TreeView1.Items Do
          If ArGrupo[I].CodGrupo < 0 Then
            AddChild(RelRoot,Format('%3.3d',[ArGrupo[I].CodGrupo])+' - '+ArGrupo[I].NomeGrupo)
          Else
            AddChild(RelRoot,' '+Format('%3.3d',[ArGrupo[I].CodGrupo])+' - '+ArGrupo[I].NomeGrupo);
        End
    End
  Else
    If PodeIncluir(J, ArDFN[J].CodGrupo) Then
      With AssisAbreForm.TreeView1.Items Do
        Begin
        For I := 0 To Length(ArGrupo)-1 Do  // Achar o nome do grupo
          If ArGrupo[I].CodGrupo = ArDFN[J].CodGrupo Then
            Break;

        RelRoot := AssisAbreForm.TreeView1.Items.Add(RelRoot,ArDFN[J].CodRel);

        If ArDFN[J].CodGrupo < 0 Then
          AddChild(RelRoot,Format('%3.3d',[ArDFN[J].CodGrupo])+' - '+ArGrupo[I].NomeGrupo)
        Else
          AddChild(RelRoot,' '+Format('%3.3d',[ArDFN[J].CodGrupo])+' - '+ArGrupo[I].NomeGrupo);
        End;
  End;
AssisAbreForm.TreeView1.SortType := stText;

Avisop.Close;

auxEhRemoto := False;
AssisAbreForm.ListBox2.Clear;

AssisAbreForm.Show;

End;

Procedure TFrameForm.AbrirRemoto1Click(Sender: TObject);
Begin
If Not ConectouRemoto Then
  Begin
  LogInRemotoForm.ModalResult := mrCancel;
//  LogInRemotoForm.URLEdit.Text := WebConnection1.URL;
  If LogInRemotoForm.ShowModal = mrOK Then
    Begin
    WebConnection1.URL := LogInRemotoForm.URLEdit.Text;
    ConectouRemoto := True;
    End
  Else
    Begin
    Screen.Cursor := crDefault;
    Exit;
    End;
  End;

AssisAbreForm.ListBox1.Clear;
AssisAbreForm.ListBox2.Clear;
AssisAbreForm.ListBox1.MultiSelect := True;
AssisAbreForm.ListBox1.Sorted := True;

WebConnection1.Connected := False;

Screen.Cursor := crHourGlass;

Try
  WebConnection1.Connected := True;
  AssisAbreForm.ListBox1.Items.Text := WebConnection1.AppServer.LogIn(LogInRemotoForm.UsuEdit.Text,
                                                                      LogInRemotoForm.PassEdit.Text,
                                                                      ConnectionID);
Finally
  Screen.Cursor := crDefault;
  End; // Try

If ConnectionID = 0 Then
  Begin
  ConectouRemoto := False;
  ShowMessage('Conexão remota não foi realizada...');
  Exit;
  End;

auxEhRemoto := True;
AssisAbreForm.ShowModal;

End;

Procedure TFrameForm.Fechar1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Close;
End;

Procedure TFrameForm.ConfigurarImpressora1Click(Sender: TObject);
Begin
PrinterSetupDialog1.Execute;
End;

Procedure TFrameForm.ConfigurarFontedeImpresso1Click(Sender: TObject);
Var
  ArqX : System.Text;
  Linha : ShortString;
  X : Set Of TFontStyle;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  FontDialog1.Font := Printer.Canvas.Font;
  If FontDialog1.Execute Then
    Begin
    Printer.Canvas.Font := FontDialog1.Font;
    If PathCfg = 'FAIOU' Then
      Exit;
    AssignFile(ArqX,PathCfg+'Printer.Cfg');
    {$i-}
    Rewrite(ArqX);
    {$i+}
    If IoResult = 0 Then
      Begin
      WriteLn(ArqX,Printer.Canvas.Font.Name);
      WriteLn(ArqX,Printer.Canvas.Font.Size);
      X := Printer.Canvas.Font.Style;
      Move(X,Linha[1],SizeOf(X));
      SetLength(Linha,SizeOf(X));
      WriteLn(ArqX,Linha);
      CloseFile(ArqX);
      End;
    End;
  End;
End;

Procedure TFrameForm.CopiarPgina1Click(Sender: TObject);
Var
  Linha : ShortString;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  Reset(ArqImp);
  MemoAux.Lines.Clear;
  While Not Eof(ArqImp) Do
    Begin
    ReadLn(ArqImp,Linha);
    If Linha[1] = Chr(1) Then  { é uma linha marcada }
      Delete(Linha,1,1);
    MemoAux.Lines.Add(Linha);
    End;
  CloseFile(ArqImp);
  MemoAux.SelStart := 0;
  MemoAux.SelLength := Length(MemoAux.Lines.Text)-1;
  MemoAux.CopyToClipBoard;
  End;
End;

Procedure TFrameForm.ConfigurarFontedeVdeo1Click(Sender: TObject);
Var
  ArqX : System.Text;
  Linha : ShortString;
  X : Set Of TFontStyle;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  FontDialog1.Font := Video;
  If FontDialog1.Execute Then
    Begin
    Video := FontDialog1.Font;
    Memo1.Font := FontDialog1.Font;
    CarregaImagem(RegPag64,MarcaAtu,PaginaAtu);
    AssignFile(ArqX,PathCfg+'Video.Cfg');
    {$i-}
    Rewrite(ArqX);
    {$i+}
    If IoResult = 0 Then
      Begin
      WriteLn(ArqX,Video.Name);
      WriteLn(ArqX,Video.Size);
      X := FontDialog1.Font.Style;
      Move(X,Linha[1],SizeOf(X));
      SetLength(Linha,SizeOf(X));
      WriteLn(ArqX,Linha);
      CloseFile(ArqX);
      End;
    End;
  End;  
End;

Procedure TFrameForm.ConfigurarCordoFundo1Click(Sender: TObject);
Var
  ArqX : System.Text;
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  If ColorDialog1.Execute Then
    Begin
    Cor := ColorDialog1.Color;
    CarregaImagem(RegPag64,MarcaAtu,PaginaAtu);
    AssignFile(ArqX,PathCfg+'Color.Cfg');
    {$i-}
    Rewrite(ArqX);
    {$i+}
    If IoResult = 0 Then
      Begin
      WriteLn(ArqX,Cor);
      CloseFile(ArqX);
      End;
    End;
  End;
End;

Procedure TFrameForm.ModoTexto1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  If ModoTexto1.Checked Then
    Begin
    RFMImage1.Visible := True;
    ScrollBox1.Visible := True;
    Memo1.Visible := False;
    ModoTexto1.Checked := False;
    MemoPopUp.Items[2].Checked := False;
    FrameForm.Label3.Caption := '';
    End
  Else
    Begin
    RFMImage1.Visible := False;
    ScrollBox1.Visible := False;
    Memo1.Visible := True;
    ModoTexto1.Checked := True;
    MemoPopUp.Items[2].Checked := True;
    End;
  CarregaImagem(RegPag64,MarcaAtu,PaginaAtu);
  End;
End;

Procedure TFrameForm.CopiarTextoSelecionado1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
With TEditForm(ActiveMdiChild) Do
  Begin
  Memo1.CopyToClipboard;
  End;
End;

Procedure TFrameForm.Prxima1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar1.Position < ScrollBar1.Max Then
  Begin
  ScrollBar1.Position := ScrollBar1.Position + 1;
  Scrolla1;
  End;
End;

Procedure TFrameForm.Anterior1Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar1.Position > ScrollBar1.Min Then
  Begin
  ScrollBar1.Position := ScrollBar1.Position - 1;
  Scrolla1;
  End;
End;

Procedure TFrameForm.Prxima2Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar2.Position < ScrollBar2.Max Then
  Begin
  ScrollBar2.Position := ScrollBar2.Position + 1;
  Scrolla2;
  End;
End;

Procedure TFrameForm.Anterior2Click(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
If ScrollBar2.Position > ScrollBar2.Min Then
  Begin
  ScrollBar2.Position := ScrollBar2.Position - 1;
  Scrolla2;
  End;
End;

Procedure TFrameForm.ExtrairClick(Sender: TObject);
Begin
If MdiChildCount = 0 Then
  Exit;
FrmExtract.Show;
End;

Procedure TFrameForm.FormActivate(Sender: TObject);
Begin
If JaAbriu Then
  Exit;

Try
  FormGeral.TableDFN.Open;
  FormGeral.TableDFN.Close;
  FrameForm.AbrirAssistido1.Click;
Except
  End; // Try
  
JaAbriu := True;
End;

End.
