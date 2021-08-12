unit frmGeraMov_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows, ADODB, Vcl.Grids, Vcl.DBGrids,
  Data.DB;


type
  TfrmGeraMov = class(TForm)
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Command2:  TButton;
    Command1:  TButton;
    Frame1:  TGroupBox;
    Command3:  TButton;
    Command4:  TButton;
    Command5:  TButton;
    Text1:  TEdit;
    Text2:  TEdit;
    Text3:  TEdit;
    grdMovimento: TDBGrid;
    DataSource1: TDataSource;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure Command3Click(Sender: TObject);
    procedure Command4Click(Sender: TObject);
    procedure Command5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AtualizaGrid();
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Text1DblClick(Sender: TObject);
    procedure Text2DblClick(Sender: TObject);
    procedure Text3DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    cnAdoConect: TADOConnection;
    RsAdoPath, RsAdoMovimento: TADODataSet;

    procedure Form_Unload(var Cancel: Smallint);

  public
    { Public declarations }
  end;

var
  frmGeraMov: TfrmGeraMov;

implementation

uses  Dialogs, SysUtils, Module1, RotGerais, frmLog_, VBto_Converter, System.Types, IOUtils;

{$R *.dfm}

 //=========================================================
procedure TfrmGeraMov.Command1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmGeraMov.Command2Click(Sender: TObject);
const
  curOnErrorGoToLabel_Erro = 1;
var
  vOnErrorGoToLabel: Integer;
var
  PathEntrada, PathTemplate, PathSaida, ArqEntrada, ArqTemplate, ArqSaida,
  sData, I, sNomeArq, sSql: String;
  Ret,
  J: Integer;
  Inicio: TDateTime;
  Arquivo: TStringList;
  Template: TStringList;
  gBanco: TADOConnection;
  RsDb: TADODataSet;
  DynArray: TStringDynArray;
begin
  Arquivo := TStringList.Create;

  vOnErrorGoToLabel := 0;
  try
    // Vai gerar todas as datas
    // DataMov.Show vbModal
    // If Not isDataValida(gDataRelatorio) Then
    // Exit Sub
    // End If
    // sData = Format$(gDataRelatorio, "YYYYMMDD")

    If not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
      Exit;

    sSql := 'select * from path';
//    RsDb := gBanco.OpenRecordset(sSql);

     RsDb := TADODataSet.Create(nil);
    RsDb.Connection := gBanco;
    RsDb.CommandText := sSql;
    RsDb.Open;

    if RsDb.EOF then
      begin
      ShowMessage('Path não cadastrada');
      Arquivo.Free;
      Exit;
      end;

    PathEntrada := RsDb.FieldByName('PathArquivoEntrada').Value;
    PathTemplate := String(RsDb.FieldByName('PathTemplate').Value)+'\';
    PathSaida := String(RsDb.FieldByName('PathArquivoSaida').Value)+'\';

    sSql := 'select * from movimento order by template';
    RsDb.Close;     //  := gBanco.OpenRecordset(sSql);
    RsDb.CommandText := sSql;
    RsDb.Open;

    if RsDb.EOF then
      begin
      ShowMessage('Movimento não cadastrado');
      Arquivo.Free;
      gBanco.Close;
      RsDb.Close;
      gBanco.Free;
      RsDb.Free;
      Exit;
      end;

    Self.Hide;

    gArquivo11 := '';
    frmLog.Show;
    Inicio := Now;
    frmLog.RichTextBox1.Text := frmLog.RichTextBox1.Text + 'Data do Movimento: ' + DateToStr(gDataRelatorio) +#10#10;

    I := IntToStr(0); // Indica primeira vez no loop
    with RsDb do begin
      while not RsDb.EOF do
        begin
        // Original
        // ArqEntrada = PathEntrada & sData & "\" & .Fields("SufixoEntrada") & "\" & .Fields("ArquivoEntrada") & sData & ".DAT"
        ArqEntrada := PathEntrada+'\'+'\'+String(FieldByName('ArquivoEntrada').Value)+'*.DAT';
        // Teste com servidor mapeado
        // NAO TEM MAIS A DATA
        // sNomeArq = Dir$(PathEntrada & sData & "\*.DAT")
        // ArqEntrada = PathEntrada & sData & "\" & sNomeArq
        if Round(StrToFloat(I))=0 then
          begin
          sSql := FieldByName('ArquivoEntrada').Value;

//          sNomeArq := Dir(PathEntrada+'\'+sSql+'*.DAT');
          DynArray := TDirectory.GetFiles(PathEntrada+'\'+sSql, '*.DAT', TSearchOption.soTopDirectoryOnly);
          If Length(DynArray) > 0 then
            sNomeArq := DynArray[0]
          else
            sNomeArq := '';

          ArqTemplate := PathTemplate+String(FieldByName('Template').Value)+'.XTR';

          //sSql := Dir(PathEntrada+'\'+sSql+'*.DAT');

          for J := Low(DynArray) to High(DynArray) do
            begin
            I := FloatToStr(StrToFloat(I)+1);
//            Arquivo.Add(Round(StrToFloat(I)+1));
            Arquivo.Add(IntToStr(Round(StrToFloat(I)+1)));
            end;

          {if sSql<>'' then
            begin
            while sSql<>'' do
              begin
              I := FloatToStr(StrToFloat(I)+1);
              ReDimPreserve(Arquivo, Round(StrToFloat(I+1)));
              Arquivo[Round(StrToFloat(I))] := sSql;
              sSql := Dir();
              end;
            end
          else
            begin
            I := IntToStr(-1);
            end; }

          end
        else
          begin
          sNomeArq := Arquivo[Round(StrToFloat(I))];
          I := FloatToStr(StrToFloat(I)-1);
          end;

        if Round(StrToFloat(I))<>-1 then
          begin
          ArqEntrada := PathEntrada+'\'+sNomeArq;
          sData := getDataFronNomeArq(sNomeArq);
          ArqSaida := PathSaida+String(FieldByName('ArquivoSaida').Value)+'_'+sData+'_'+Trim(mStr(I))+'.TXT';
          gArquivo11 := frmLog.RichTextBox1.Text;

          frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Gerando Arquivo '+ArqSaida+'...';
          frmLog.RichTextBox1.SelStart := 0;
          frmLog.RichTextBox1.SelLength := Length(gArquivo11);
          frmLog.RichTextBox1.Font.Name := 'Courier New';
          frmLog.RichTextBox1.SelLength := 0;

          // Chama rotina da DLL Delphi
          frmLog.RichTextBox1.Visible := true;
          Application.ProcessMessages;
          frmLog.RichTextBox1.Visible := false;
          Screen.Cursor := crHourGlass;

//          if (Dir(ArqEntrada)<>'') and (Dir(ArqTemplate)<>'') then
          if (FileExists(ArqEntrada)) and (FileExists(ArqTemplate)) then
            begin
            vOnErrorGoToLabel := curOnErrorGoToLabel_Erro; { On Error GoTo Erro }
            Ret := MultiExtract(ArqEntrada, ArqTemplate, ArqSaida);
            // Ret = 0
            if Ret=0 then
              begin
              // Move arquivo para Bkp_Rel_ComTemplate
              // Nao moveu o IAPX depois que rodou o template
              // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx            moveRelMulticold (ArqEntrada)
              end;
            // Debug
            // Ret = 0
            // Debug.Print ArqEntrada
            end
          else
            begin
            Ret := -2;
            end;

          Screen.Cursor := crDefault;

          case Ret of
            -1: begin
                frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Arquivo '+ArqTemplate+' Versão Inválida!'+#10;
                end;
             0: begin
                frmLog.RichTextBox1.Text := gArquivo11+'Arquivo '+TruncaPath(ArqSaida, 60)+' Gerado '+FormatVB(Now()-Inicio,'hh:mm:ss')+#10;
                Inicio := Now;
                end;
            else
              begin
              frmLog.RichTextBox1.Text := gArquivo11+'Erro: Arquivo '+TruncaPath(ArqSaida, 60)+' Não foi Gerado'+#10;
//              if Dir(ArqEntrada)='' then
              if Not FileExists(ArqEntrada) then
                frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Arquivo '+TruncaPath(ArqEntrada, 60)+' Não foi Localizado'+#10;
//              if Dir(ArqTemplate)='' then
              if Not FileExists(ArqTemplate) then
                frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+'Arquivo '+TruncaPath(ArqTemplate, 60)+' Não foi Localizado'+#10;
              end;
            end;

          frmLog.RichTextBox1.SelStart := 0;
          frmLog.RichTextBox1.SelLength := Length(gArquivo11);
          frmLog.RichTextBox1.Font.Name := 'Courier New';
          frmLog.RichTextBox1.SelLength := 0;
          end;
        if Round(StrToFloat(I))=1 then
          I := IntToStr(0);
        if Round(StrToFloat(I))<1 then
          Next;
        Application.ProcessMessages;
      end;
    end;

    frmLog.RichTextBox1.Text := String(frmLog.RichTextBox1.Text)+#10+'Fim da Geração do Movimento. '+DateTimeToStr(Now())+#10;
    gArquivo11 := frmLog.RichTextBox1.Text;
    frmLog.Close;
    frmLog.Show;
    Application.MessageBox('Movimento Gerado...!', '', MB_ICONEXCLAMATION);
    frmLog.Hide;

    frmLog.ShowModal;

    Arquivo.Free;
    gBanco.Close;
    RsDb.Close;
    gBanco.Free;
    RsDb.Free;
    frmLog.Close;
    Close;

  except
    case vOnErrorGoToLabel of
      curOnErrorGoToLabel_Erro:  begin
                                ShowMessage(PChar('Err.Description'));
                                end;
      else begin
        // ...
           end;
    end;
  end;
end;

procedure TfrmGeraMov.Command3Click(Sender: TObject);
begin
  try  // On Error GoTo Erro

    if  not Autoriza(cADM) then
      Exit;

    if  not RsAdoMovimento.EOF then
      begin
//      Self.grdMovimento.Col := 1;
{      if Self.grdMovimento.Text='' then   }        //Rever
        begin
        ShowMessage('Digite o nome do Arquivo');
        Exit;
        end;
      RsAdoMovimento.Last;
      end;

    RsAdoMovimento.Insert;
    Self.grdMovimento.Refresh;

//    Self.grdMovimento.Col := 1;
    Self.grdMovimento.SetFocus;
    Exit;
  except  // Erro:
    ShowMessage('Template Duplicado');
//    Err.Clear;
  end;
end;

procedure TfrmGeraMov.Command4Click(Sender: TObject);
begin
  try  // On Error GoTo Erro
    if  not Autoriza(cADM) then begin
      Exit;
    end;
//    Self.grdMovimento.Col := 2;
{    if Self.grdMovimento.Text='' then }    //Rever
      begin
      ShowMessage('Digite o nome do Template');
      Self.grdMovimento.SetFocus;
      Exit;
      end;
    with RsAdoMovimento do begin
      if  not EOF then Delete;
      // If Not .EOF Then .MoveLast
    end;
    Exit;
  except  // Erro:
    ShowMessage('Template Duplicado');
//    Err.Clear();
  end;
end;

procedure TfrmGeraMov.Command5Click(Sender: TObject);
label
  Erro;
begin
  try  // On Error GoTo Erro
    if  not Autoriza(cADM) then begin
      Exit;
    end;
    RsAdoMovimento.UpdateRecord;
    with RsAdoPath do begin
      if EOF then begin
        Insert;
      end;
      VBtoADOFieldSet(RsAdoPath, 1, Self.Text1.Text);
      VBtoADOFieldSet(RsAdoPath, 2, Self.Text2.Text);
      VBtoADOFieldSet(RsAdoPath, 3, Self.Text3.Text);
      // .Fields(PathArquivoEntrada) = Me.Text1.Text
      // .Fields(PathTemplate) = Me.Text2.Text
      // .Fields(PathArquivoSaida) = Me.Text3.Text
      UpdateRecord;
    end;
    Exit;
  except  // Erro:
//    if Err.Number=-2147217864 then { Resume Next }
    ShowMessage('Template Duplicado');
//    Err.Clear();
  end;
end;

procedure TfrmGeraMov.FormShow(Sender: TObject);
begin
  CenterForm(Self);
  // strQ = "provider=Microsoft.Jet.OLEDB.3.51;data source=" & gDataPath & gDataFile
  //strq := 'provider=Microsoft.Jet.OLEDB.3.51;data source='+gAdmPath+'\admin.mdb';

  If not Conecta(cnAdoConect, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

  cnAdoConect.CursorLocation := clUseClient;
      // Isso aqui está me cheirando muito mal
//  VBtoADOConnection_Open(cnAdoConect, strq);

  RsAdoPath := TADODataSet.Create(nil);
  RsAdoMovimento := TADODataSet.Create(nil);

  try  // On Error GoTo Erro
    if gNivel<cADM then begin
      Self.grdMovimento.Enabled := false;
      Self.Text1.Enabled := false;
      Self.Text2.Enabled := false;
      Self.Text3.Enabled := false;
    end;
    AtualizaGrid;
    Exit;
  except  // Erro:
//    Err.Clear();
    { Resume Next }
  end;
end;

procedure TfrmGeraMov.AtualizaGrid;
label
  Erro;
begin

  try  // On Error GoTo Erro

    sSql := 'select * from path';
    RsAdoPath.Close;
//    VBtoADODataSet_Open(RsAdoPath, sSql, cnAdoConect, ctKeyset, ltOptimistic);

    RsAdoPath.Connection := cnAdoConect;
    RsAdoPath.CommandText := sSql;
    RsAdoPath.Open;

    Self.Text1.Text := RsAdoPath.FieldByName('PathArquivoEntrada').Value;
    Self.Text2.Text := RsAdoPath.FieldByName('PathTemplate').Value;
    Self.Text3.Text := RsAdoPath.FieldByName('PathArquivoSaida').Value;

    // sSql = "select Flag,ArquivoEntrada,Template,ArquivoSaida from movimento order by arquivoentrada,template,arquivosaida"
    // sSql = "select * from movimento order by arquivoentrada,template,arquivosaida"
    sSql := 'select * from movimento order by template';
    RsAdoMovimento.Close;

    DataSource1.DataSet := RsAdoMovimento;
    Self.grdMovimento.DataSource := DataSource1;

    //    VBtoADODataSet_Open(RsAdoMovimento, sSql, cnAdoConect, ctKeyset, ltOptimistic);
    RsAdoMovimento.Connection := cnAdoConect;
    RsAdoMovimento.CommandText := sSql;
    RsAdoMovimento.Open;


{    Self.grdMovimento.Columns(0).Visible := false;

    Self.grdMovimento.Columns(1).Width := 1300;
    Self.grdMovimento.Columns(2).Width := 1600;
    Self.grdMovimento.Columns(3).Width := 1600;
    Self.grdMovimento.Columns(4).Width := 1300;}
    Exit;
  except  // Erro:
    //Err.Clear();
    { Resume Next }
  end;
end;

procedure TfrmGeraMov.Form_Unload(var Cancel: Smallint);
label
  Erro;
begin
  try  // On Error GoTo Erro
//    Self.grdMovimento.DataSource := nil;

    RsAdoPath.Close;
    RsAdoMovimento.Close;
    cnAdoConect.Close;
    cnAdoConect.Free;
    RsAdoPath.Free;
    RsAdoMovimento.Free;

  except  on E:Exception do// Erro:
    ShowMessage(E.Message);
    { Resume Next }
  end;
end;

procedure TfrmGeraMov.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

procedure TfrmGeraMov.Text1DblClick(Sender: TObject);
Var
  xX : String;
begin
  GetDir(0, xX);
  Self.Text1.Text := xX;
end;

procedure TfrmGeraMov.Text2DblClick(Sender: TObject);
Var
  xX : String;
begin
  GetDir(0, xX);
  Self.Text2.Text := xX;
end;

procedure TfrmGeraMov.Text3DblClick(Sender: TObject);
Var
  xX : String;
begin
  GetDir(0, xX);
  Self.Text3.Text := xX;
end;

procedure TfrmGeraMov.FormCreate(Sender: TObject);
begin
  cnAdoConect := TADOConnection.Create(nil);
end;

end.
