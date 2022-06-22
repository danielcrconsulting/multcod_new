Unit LogInCliU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, jpeg, ExtCtrls;

Type
  TLogInCliForm = Class(TForm)
    Label1: TLabel;
    LogInOkBut: TButton;
    CancelaButton: TButton;
    UsuEdit: TEdit;
    Label3: TLabel;
    ComboBox1: TComboBox;
    SeleOrgBut: TButton;
    Image2: TImage;
    Procedure CancelaButtonClick(Sender: TObject);
    Procedure LogInOkButClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    procedure SeleOrgButClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }

    Org : Array Of Integer;
    NomeOrg : Array Of AnsiString;
    QtdTent : Integer;
    Grupo : AnsiString;
    Reports1Str : AnsiString;
    Reports1Rec : TSearchRec;

    Procedure AjustaImagem(Image1, Image2 : TImage; Button1 : TButton);
    Function VerificaSemSeg : Boolean;
  End;

Var
  LogInCliForm: TLogInCliForm;
  ArqDscOrg,
  ArqServ : System.Text;

Implementation

Uses SuGeral, MasterU, SelCont, FRange, Fconta, FExtr, Fcartao, PortaCartU,
  EditTest, Lancamentos, RelResumoU;

{$R *.DFM}

Var
  EntrouSemSeg,
  SelecionouOrg : Boolean;
  RegDir : Array[1..4] of Array[1..1000] of Char;

Function TLogInCliForm.VerificaSemSeg : Boolean;
Var
  ArqDir : File;
  I, J,
  Err : Integer;
  SearchRec : TSearchRec;
  Associou : Boolean;
Begin
Result := False;     
Associou := False;   
If FindFirst(ExtractFilePath(ParamStr(0))+'*.dat', faAnyFile, SearchRec) = 0 Then
  Begin
  Repeat
  If UpperCase(SearchRec.Name) <> 'REMOTE.DAT' Then
    Begin
    AssignFile(ArqDir, ExtractFilePath(ParamStr(0))+SearchRec.Name);
    Associou := True;  
    End;
  Until FindNext(SearchRec) <> 0;
  End
Else
  Begin
  SysUtils.FindClose(SearchRec);
  Exit; // Sai com Result = False e vai verificar BD  
  End;
SysUtils.FindClose(SearchRec);
If Not Associou Then
  Exit; // Sai com Result = False e vai verificar BD  

   // Le o arquivo de script
Reset(ArqDir,1);
For I := 1 To 4 Do
  Begin
  BlockRead(ArqDir,RegDir[I],1000,Err);
  For J := 1 To 1000 Do
    Inc(RegDir[I][J],32); 
  End;  
CloseFile(ArqDir);

SetLength(NomeOrg,1);
SetLength(Org,1);
NomeOrg[0] := '';
Try
  Org[0] := StrToInt(Copy(RegDir[1],100,3));
  Except  
    ShowMessage('Erro na conversão do código da organização');
    Exit;
  End; // Try  
I := 1;
While RegDir[1][I] <> #255 Do
  Begin
  NomeOrg[0] := NomeOrg[0] + RegDir[1][I];
  Inc(I);
  End;
ComboBox1.Clear;
ComboBox1.Items.Add(Format('%3.3d',[Org[0]]) + '-' + NomeOrg[0]);
ComboBox1.Text := ComboBox1.Items[0];
EntrouSemSeg := True;
Result := True;
End;  

Procedure TLogInCliForm.CancelaButtonClick(Sender: TObject);
Begin
Application.Terminate;
End;

Procedure TLogInCliForm.LogInOkButClick(Sender: TObject);
Var
  I : Integer;
Begin
If QtdTent = 3 Then
  Begin
  Application.Terminate;
  Exit;
  End;
Inc(QtdTent);

FormGeral.IBAdmRemotoDatabase.Open;

FormGeral.QueryAux1.Sql.Clear;
FormGeral.QueryAux1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuarios.TableName+'" A ');
FormGeral.QueryAux1.Sql.Add('WHERE (A."CODUSUARIO" = '''+UsuEdit.Text+''') ');
//FormGeral.QueryAux1.Sql.Add('AND   (A."SENHA" = '''+SenhaEdit.Text+''')' );
FormGeral.QueryAux1.Open;

Grupo := '';
If FormGeral.QueryAux1.RecordCount = 0 Then
  Begin
  FormGeral.QueryAux1.Close;
  ShowMessage('Usuario ou Senha inválida: '+UsuEdit.Text);
  Exit;
  End
Else
  Grupo := FormGeral.QueryAux1.Fields[1].AsString;
FormGeral.QueryAux1.Close;

If ((ExtractFileName(UpperCase(ParamStr(0)))='MASTERCOLD.EXE') Or
    (ExtractFileName(UpperCase(ParamStr(0)))='EDSEXTRATO.EXE') Or
    (ExtractFileName(UpperCase(ParamStr(0)))='MASTERCOLDEXTRATO.EXE')) And (Grupo <> '') Then
  Begin
  FormGeral.QueryAux1.Sql.Clear;
  FormGeral.QueryAux1.Sql.Add('SELECT * FROM "'+FormGeral.TableUsuRel.TableName+'" A, ');
  FormGeral.QueryAux1.Sql.Add(              '"'+FormGeral.TableGruposDFN.TableName+'" B ');
  FormGeral.QueryAux1.Sql.Add('WHERE (A."CODUSUARIO" = '''+UsuEdit.Text+''') ');
  FormGeral.QueryAux1.Sql.Add('AND   (A."CODGRUPO" = B."CODGRUPO") ');
  FormGeral.QueryAux1.Open;
  If FormGeral.QueryAux1.RecordCount = 0 Then
    ShowMessage('Nenhuma Organização associada a seu usuário: '+UsuEdit.Text)
  Else
    Begin
    While Not FormGeral.QueryAux1.Eof Do
      FormGeral.QueryAux1.Next;
    SetLength(Org,FormGeral.QueryAux1.RecordCount);
    SetLength(NomeOrg,FormGeral.QueryAux1.RecordCount);
    FormGeral.QueryAux1.Close;
    FormGeral.QueryAux1.Open;
    I := 0;
    While Not FormGeral.QueryAux1.Eof Do
      Begin
      Org[I] := FormGeral.QueryAux1.Fields[1].AsInteger;
      NomeOrg[I] := FormGeral.QueryAux1.Fields[6].AsString;
      Inc(I);
      FormGeral.QueryAux1.Next;
      End;
    End;
  FormGeral.QueryAux1.Close;
  End;

For I := 0 To Length(Org)-1 Do
  ComboBox1.Items.Add(Format('%3.3d',[Org[I]]) + '-' + NomeOrg[I]);
If Length(Org) = 1 Then
  ComboBox1.Text := ComboBox1.Items[0];
LogInOkBut.Default := False;
SeleOrgBut.Default := True;
End;

Procedure TLogInCliForm.FormCreate(Sender: TObject);
Begin
QtdTent := 0;
SelecionouOrg := False;
EntrouSemSeg := False;
End;

Procedure TLogInCliForm.AjustaImagem(Image1, Image2 : TImage; Button1 : TButton);
Begin
Image1.Picture.LoadFromFile(PathLogo);
If (Image1.Left + Image1.Width) > (Button1.Left + Button1.Width) Then
  Image1.Left := Image1.Left -
               ((Image1.Left + Image1.Width) - (Button1.Left + Button1.Width))
Else
  If (Image1.Left + Image1.Width) > (Button1.Left + Button1.Width) Then
    Image1.Left := Image1.Left +
                 ((Image1.Left + Image1.Width) - (Button1.Left + Button1.Width));
End;

Procedure TLogInCliForm.SeleOrgButClick(Sender: TObject);
Var
  Linha,
  PathDados,
  DirDest : AnsiString;
  Ano,
  Mes : Integer;

{  AuxFile : TgArqIndiceContaCartao;
  AuxReg,
  AuxRegAnt : TgIndiceI64F;
  Achou : Boolean;}

  Function PegaNomeArquivo(TipoReg : Integer) : AnsiString;
  Var
    I : Integer;
  Begin
  Result := '';
  I := 500;
  While RegDir[TipoReg][I] <> #255 Do
    Begin
    Result := Result + RegDir[TipoReg][I];
    Inc(I);
    End;
  I := Pos('\',Result);
  Result := Copy(Result,I+1,Length(Result)-I);
  End;

Begin
If ComboBox1.Text <> '' Then
  Begin
  CodOrgSelecionada := Copy(ComboBox1.Text,1,3);
  PathLogo := ExtractFilePath(TheFileName)+
              Copy(ComboBox1.Text,5,Length(ComboBox1.Text)-5+1)+'\'+
              CodOrgSelecionada+'.bmp';
  // Carga das máscaras e determinação da capacidade de linhas de detalhe de cada uma...
  With DlgTest Do
    Begin
    DFEngineEmpr1.LoadFromFile(ExtractFilePath(PathLogo)+'EMPRESARIAL.DFB');
    ILctEmpr1 := LevantarNumeroDeLancamentosDetex(DFEngineEmpr1);
    DFEngineEmpr2.LoadFromfile(ExtractFilePath(PathLogo)+'EMPRESARIAL2+.DFB');
    ILctEmpr2 := LevantarNumeroDeLancamentosDetex(DFEngineEmpr2);

    DFEngineFis1.LoadFromFile(ExtractFilePath(PathLogo)+'EXTRATO.DFB');
    ILctFis1 := LevantarNumeroDeLancamentosDetex(DFEngineFis1);
    DFEngineFis2.LoadFromfile(ExtractFilePath(PathLogo)+'EXTRATO2+.DFB');
    ILctFis2 := LevantarNumeroDeLancamentosDetex(DFEngineFis2);
    End;

  RelResumo.DFEngine1.LoadFromFile(ExtractFilePath(PathLogo)+'CAPINHABMG.DFB');
  ICntExtRes := RelResumo.LevantarNumeroDeExtratos(RelResumo.DfEngine1);

  AssignFile(ArqDscOrg,ExtractFilePath(PathLogo)+'DscOrg.Txt');
  Try
    Reset(ArqDscOrg);
    ReadLn(ArqDscOrg,Linha);
    CloseFile(ArqDscOrg);
  Except
    ShowMessage('Falta o arquivo de descrição da Org');
    End;

  AssignFile(ArqServ,ExtractFilePath(PathLogo)+'ServiçosaClientes.txt');
  Try
    Reset(ArqServ);
    ReadLn(ArqServ,LinCli1);
    ReadLn(ArqServ,LinCli2);
    CloseFile(ArqServ);
  Except
    ShowMessage('Falta o arquivo .txt de Serviços a Clientes');
    End;  //Try

  AjustaImagem(Selecons.Image1,Selecons.Image2,Selecons.LimparGridButton);
  AjustaImagem(RangeForm.Image1,RangeForm.Image2,RangeForm.NovaConsultaButton);
  AjustaImagem(ContaForm.Image1,ContaForm.Image2,ContaForm.SairButton);
  AjustaImagem(ExtrForm.Image1,ExtrForm.Image2,ExtrForm.SairButton);
  AjustaImagem(CartaoForm.Image1,CartaoForm.Image2,CartaoForm.NovaConsultaButton);
  AjustaImagem(PortaForm.Image1,PortaForm.Image2,PortaForm.SairButton);
  AjustaImagem(LancamentosForm.Image1,LancamentosForm.Image2,LancamentosForm.SairButton);

  NArqCart := '';
  NArqCont := '';
  NArqDetex.Clear;
  NArqExtr.Clear;

  If EntrouSemSeg Then // Vai fazer a mantagem da árvore de arquivos a partir dos dados do .dat
    Begin

    NArqCont := ExtractFilePath(PathLogo) + PegaNomeArquivo(1);
    NArqCart := ExtractFilePath(PathLogo) + PegaNomeArquivo(2);

    For Ano := 1990 to 2050 Do
      For Mes := 1 to 12 Do
        Begin
        DirDest := ExtractFilePath(PathLogo) + ExtractFilePath(PegaNomeArquivo(3)) + IntToStr(Ano) + '\' + IntToStr(Ano) +
                   Format('%2.2d',[Mes]) + '\' + ExtractFileName(PegaNomeArquivo(3));
        If FileExists(DirDest) Then
          NArqExtr.Add(DirDest);

        End;

    For Ano := 1990 to 2050 Do
      For Mes := 1 to 12 Do
        Begin
        DirDest := ExtractFilePath(PathLogo) + ExtractFilePath(PegaNomeArquivo(4)) + IntToStr(Ano) + '\' + IntToStr(Ano) +
                   Format('%2.2d',[Mes]) + '\' + ExtractFileName(PegaNomeArquivo(4));
        If FileExists(DirDest) Then
          NArqDetex.Add(DirDest);
        End;

    SelecionouOrg := True;
    Close;
    Exit;
    End;

  FormGeral.TableDFN.Open;
  If FormGeral.TableDFN.FieldByName('CodRel').AsString = '*' Then
    FormGeral.TableDFN.Next;
  While Not FormGeral.TableDFN.Eof Do
    Begin
    FormGeral.QueryAux1.Sql.Clear;
    FormGeral.QueryAux1.Sql.Add('SELECT NOMESUBGRUPO FROM '+FormGeral.TableSubGruposDFN.TableName);
    FormGeral.QueryAux1.Sql.Add('WHERE CODGRUPO = '+FormGeral.TableDFN.FieldByName('CODGRUPO').AsString);
    FormGeral.QueryAux1.Sql.Add('AND CODSUBGRUPO = '+FormGeral.TableDFN.FieldByName('CODSUBGRUPO').AsString);
    FormGeral.QueryAux1.Open;
    PathDados := ExtractFilePath(PathLogo)+FormGeral.QueryAux1.Fields[0].AsString+'\';

    If (FormGeral.TableDFN.FieldByName('CodRel').AsString = 'UNSRCART') or
       (FormGeral.TableDFN.FieldByName('CodRel').AsString = 'UNSRCARTVP') Then
      Begin
      Reports1Str := PathDados + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString+'*.DAT';
      If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
        PathDados := PathDados + Reports1Rec.Name;
      SysUtils.FindClose(Reports1Rec);
      NArqCart := PathDados;
      End
    Else
    If (FormGeral.TableDFN.FieldByName('CodRel').AsString = 'UNSRCONT') or
       (FormGeral.TableDFN.FieldByName('CodRel').AsString = 'UNSRCONTVP') Then
      Begin
      Reports1Str := PathDados + FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString+'*.DAT';
      If (FindFirst(Reports1Str,FaAnyFile,Reports1Rec) = 0) Then
        PathDados := PathDados + Reports1Rec.Name;
      SysUtils.FindClose(Reports1Rec);
      NArqCont := PathDados;
      End
    Else
    If (FormGeral.TableDFN.FieldByName('CodRel').AsString = 'UNSDETEX') Then
      Begin
      For Ano := 1990 to 2050 Do
        For Mes := 1 to 12 Do
          Begin
          DirDest := PathDados + 'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\' +
                     FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTA.IND';
          If FileExists(DirDest) Then
            NArqDetex.Add(PathDados + 'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\' +
                          FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT');
          End;
      if NArqDetex.Count < 1 then
        if messageDlg('Erro recuperando arquivos de detalhe a partir do diretório: '+#13#10+PathDados+#13#10+'Cancelar carga do MasterCold ?',mtError,[mbYes,mbNo],0) = mrYes then
          application.Terminate;
      End
    Else
    If (FormGeral.TableDFN.FieldByName('CodRel').AsString = 'UNSREXTR') or
       (FormGeral.TableDFN.FieldByName('CodRel').AsString = 'UNSREXTRPR') Then
      Begin
//      Achou := False;
      For Ano := 1990 to 2050 Do
        For Mes := 1 to 12 Do
          Begin
          DirDest := PathDados + 'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\' +
                     FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + 'CONTA.IND';
          If FileExists(DirDest) Then
            Begin
            NArqExtr.Add(PathDados + 'MOVTO\' + IntToStr(Ano) + '\' + IntToStr(Ano)+Format('%2.2d',[Mes]) + '\' +
                         FormGeral.TableDFN.FieldByName('NomeArqSaida').AsString + '.DAT');


{            If Not Achou Then
              Begin
              AssignFile(AuxFile,DirDest);
              Reset(AuxFile);
              AuxRegAnt.Valor := 0;
              While Not Eof(AuxFile) Do
                Begin
                Read(AuxFile,AuxReg);
                If AuxReg.Valor = AuxRegAnt.Valor Then
                  Begin
                  ShowMessage(IntToStr(AuxReg.Valor));
                  Achou := True;
                  End;
                End;
              CloseFile(AuxFile);
              End;}

            End;
          End;
        if NArqExtr.Count < 1 then
          if messageDlg('Erro recuperando arquivos de cabeçalho a partir do diretório: '+#13#10+PathDados+#13#10+'Cancelar carga do MasterCold ?',mtError,[mbYes,mbNo],0) = mrYes then
            application.Terminate;
      End;
    FormGeral.QueryAux1.Close;
    FormGeral.TableDFN.Next;
    End;

  FormGeral.TableDFN.Close;

  SelecionouOrg := True;
  Close;
  End
Else
  ShowMessage('Selecione uma Org');
End;

Procedure TLogInCliForm.ComboBox1Change(Sender: TObject);
Begin
ComboBox1.Text := '';
End;

End.
