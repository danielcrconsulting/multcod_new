unit NovoCliente_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows, Data.DB, Data.Win.ADODB;


type
  TNovoCliente = class(TForm)
    Frame1:  TGroupBox;
    Label1:  TLabel;
    Label2:  TLabel;
    Label3:  TLabel;
    Label4: TLabel;
    Text1:  TEdit;
    Text2:  TEdit;
    Command1:  TButton;
    Command2:  TButton;
    Text3:  TEdit;
    Text4:  TEdit;
    gBanco: TADOConnection;
    RsDb: TADOTable;
    ADOQuery1: TADOQuery;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  NovoCliente: TNovoCliente;

implementation

uses  Dialogs, Module1, RotGerais, frmMain_, VBto_Converter, SysUtils, Variants;

{$R *.dfm}

 //=========================================================
procedure TNovoCliente.Command1Click(Sender: TObject);
var
  sDestino: String;
  controle: Smallint;
  I: Longint;
begin

Controle := 1;

  if Length(Text3.Text)=0 then begin
    Application.MessageBox('Digite o Número do Cliente', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text3.SetFocus();
    Exit;
  end;
  if Length(Text1.Text)=0 then begin
    Application.MessageBox('Digite o Nome Reduzido do Cliente', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text1.SetFocus();
    Exit;
  end;
  if Length(Text1.Text)>20 then begin
    Application.MessageBox('Nome maior que o permitido. Redigite', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text1.SetFocus();
    Exit;
  end;
  if Length(Text2.Text)=0 then begin
    Application.MessageBox('Digite o Nome do Cliente', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text4.SetFocus();
    Exit;
  end;
  if Length(Text4.Text)=0 then begin
    Application.MessageBox('Digite a Bandeira', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text4.SetFocus();
    Exit;
  end;

Try  // On Error GoTo Erro

    //if  not Conecta('adm') then Exit;

    if  not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
      Exit;

//    sSql := 'Select * from [Clientes]';
//    sSql := sSql+' where codigo_cliente = '#39''+Text3.Text+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);

    RsDb.Filter := 'codigo_cliente = '#39''+Text3.Text+''#39'';
    RsDb.Open;

    if not RsDb.EOF then
      begin
      ShowMessage('Número do Cliente já cadastrado');
      Rsdb.Close;
      Exit;
      end;

//    sSql := 'Select * from [Clientes]';
//    sSql := sSql+' where nome_reduzido = '#39''+Text1.Text+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);

    RsDb.Close;
    RsDb.Filter := 'nome_reduzido = '#39''+Text1.Text+''#39'';
    RsDb.Open;

    if not RsDb.EOF then
      begin
      ShowMessage('Nome Reduzido de Cliente já cadastrado');
      Rsdb.Close;
      Exit;
      end;

ADOQuery1.SQL.Text := 'SET :p1 = DB_ID (N''SISCOC_' + Text1.Text + ''')';
//ADOQuery1.Parameters[0].ParamType := ptInputOutput;
ADOQuery1.Parameters.ParamByName('p1').DataType := ftSmallInt;
ADOQuery1.Open;
if ADOQuery1.Parameters.ParamByName('p1').Value = Null then
  begin
  // Database doesn't exist.
  ShowMessage('Database deste Cliente não existe');
  ADOQuery1.Close;
  Exit;
  end;
  // Database exists.
ADOQuery1.Close;

ADOQuery1.SQL.Text := 'SET :p1 = DB_ID (N''SISCOC_' + Text1.Text + '_Hist'')';
//ADOQuery1.Parameters[0].ParamType := ptInputOutput;
ADOQuery1.Parameters.ParamByName('p1').DataType := ftSmallInt;
ADOQuery1.Open;
if ADOQuery1.Parameters.ParamByName('p1').Value = Null then
  begin
  // Database doesn't exist.
  ShowMessage('Database Histórico deste Cliente não existe');
  ADOQuery1.Close;
  Exit;
  end;
  // Database Hist exists.
  ADOQuery1.Close;

    // Criar o Banco de dados
//    gDataPath := GetPath()+'\';
    gDataPath := ExtractFileDir(Application.ExeName)+'\';

{    if Dir(String(gDataPath)+'*.*')='' then begin
      ShowMessage(PChar('Diretório não encontrado: '+String(gDataPath)));
      Exit;
    end; }

    // Cria diretórios do cliente
    gDataPath := gDataPath + Text1.Text;
{    if Dir(String(gDataPath)+'\*.*')='' then begin
      Dir(gDataPath);
    end;     }
    If Not DirectoryExists(gDataPath) then
      CreateDir(gDataPath);

    sDestino := gDataPath + '\Entrada';
{    if Dir(sDestino+'\*.*')='' then begin
      Dir(sDestino);
    end;}
    If Not DirectoryExists(sDestino) then
      CreateDir(sDestino);

    sDestino := gDataPath + '\Backup';
{    if Dir(sDestino+'\*.*')='' then begin
      Dir(sDestino);
    end;  }
    If Not DirectoryExists(sDestino) then
      CreateDir(sDestino);

    sDestino := gDataPath + '\Backup_temp';
{    if Dir(sDestino+'\*.*')='' then begin
      Dir(sDestino);
    end; }
    If Not DirectoryExists(sDestino) then
      CreateDir(sDestino);

    sDestino := gDataPath + '\BackupMensal';
{    if Dir(sDestino+'\*.*')='' then begin
      Dir(sDestino);
    end;  }
    If Not DirectoryExists(sDestino) then
      CreateDir(sDestino);

    sDestino := gDataPath + '\Bx_Banco_Cred';
{    if Dir(sDestino+'\*.*')='' then begin
      Dir(sDestino);
    end;}
    If Not DirectoryExists(sDestino) then
      CreateDir(sDestino);

    sDestino := gDataPath + '\Bx_Banco_Deb';
{    if Dir(sDestino+'\*.*')='' then begin
      Dir(sDestino);
    end;}
    If Not DirectoryExists(sDestino) then
      CreateDir(sDestino);

    sDestino := gDataPath + '\Interface';
{    if Dir(sDestino+'\*.*')='' then begin
      Dir(sDestino);
    end;  }
    If Not DirectoryExists(sDestino) then
      CreateDir(sDestino);

//    gDataPath := gDataPath;
    controle := 1;
    sDestino := gDataPath+'\'+Text1.Text+'.UDL';
{    sDestino := gDataPath+'\'+Text1.Text+'.MDB';
    sOrigem := GetPath+'\'+'empty.mdb';
    Substitui := false;
    if Dir(sDestino)='' then
      begin
      CopyFile(PChar(sOrigem), PChar(sDestino), false);
      end
    else
      begin
      Application.MessageBox('Cliente ja existe. ', 'Novo Cliente', MB_ICONSTOP);
      Exit;
      end;     }

 //    gDataPath := gDataPath;
{    sDestino := gDataPath+'\Hist_'+Text1.Text+'.MDB';
    sOrigem := GetPath+'\'+'empty.mdb';
    Substitui := false;
    if Dir(sDestino)='' then
      begin
      CopyFile(PChar(sOrigem), PChar(sDestino), false);
      end;                       }

    // Grava Tabela Id no banco Admin
    controle := 2;

//    if  not Conecta('adm') then Exit;
    if not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
      Exit;

//    sSql := 'Select * from [Clientes]';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDb.TableName := 'Clientes';
    RsDb.Open;

//    with RsDb do begin
      RsDb.Insert;
      RsDb.FieldByName('Codigo_Cliente').AsString := Text3.Text;
      RsDb.FieldByName('Nome_Reduzido').AsString := Text1.Text;
      RsDb.FieldByName('Nome_Cliente').AsString := Text2.Text;
      RsDb.FieldByName('Bandeira').AsString := Text4.Text;
      RsDb.UpdateRecord;
      RsDb.Last;
      I := RsDb.FieldByName('Codigo').Value;
//    end;

//    sSql := 'Select * from [id]';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDb.Close;
    RsDb.TableName := 'Id';
    RsDb.Open;

//    with RsDb do begin
//    if RsDb.EOF then
    RsDb.Insert;
//    else
//      RsDb.Edit;
      // .Fields("Codigo_Cliente") = Text3.Text
    RsDb.FieldByName('Nome_Reduzido').AsString := Text1.Text;
    RsDb.FieldByName('Nome_Cliente').AsString := Text2.Text;

    RsDb.UpdateRecord;
    RsDb.Close;

    controle := 3;           // Aqui vamos abrir o db cliente virgem e gravar estes dados
    gBanco.Close;
//    gBanco := gWork.OpenDatabase(sDestino);
    Conecta(gBanco,sDestino);

    bConectado := true;
//    sSql := 'Select * from [Id]';
//    RsDb := gBanco.OpenRecordset(sSql);
    RsDb.Open;
//    with RsDb do begin
      if RsDb.EOF then
        RsDb.Insert
      else
        begin
        RsDb.Edit;

         RsDb.FieldByName('Codigo').AsInteger := I;
         RsDb.FieldByName('Nome_Reduzido').AsString := Text1.Text;
        RsDb.FieldByName('Nome_Cliente').AsString := Text2.Text;

        RsDb.UpdateRecord;
        end;

//    Desconecta();
    RsDb.Close;
    gBanco.Close;

    fMainForm.MontaMenus;

    fMainForm.mnuClientes.Enabled := true;

    Application.MessageBox('Cliente gerado...', 'Novo Cliente', MB_ICONINFORMATION);

    Close;
    Exit;

  except  // Erro:
//    if Err.Number=76 then begin
      { Resume Next }
//    end;
    case controle of
      
      1: begin
        Application.MessageBox('Não foi possivel criar o Banco de Dados...', 'Novo Cliente', MB_ICONSTOP);
      end;
      2: begin
        Application.MessageBox('Não foi possivel gravar Dados do Clientes...', 'Novo Cliente', MB_ICONSTOP);
      end;
      3: begin
        Application.MessageBox('Não foi possivel gravar Dados do Clientes...', 'Novo Cliente', MB_ICONSTOP);
      end;
    end;
//    Desconecta();
//    Close();

  end;
end;

procedure TNovoCliente.Command2Click(Sender: TObject);
begin
  Close;
end;

end.
