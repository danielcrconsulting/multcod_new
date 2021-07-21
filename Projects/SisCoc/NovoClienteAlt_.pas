unit NovoClienteAlt_;

interface

uses  Forms, Classes, Controls, StdCtrls, Windows, Data.DB, Data.Win.ADODB;


type
  TNovoClienteAlt = class(TForm)
    Frame1:  TGroupBox;
    Label2:  TLabel;
    Label1:  TLabel;
    Label3:  TLabel;
    Label4:  TLabel;
    Text2:  TEdit;
    Text1:  TEdit;
    Command1:  TButton;
    Command2:  TButton;
    Text3:  TEdit;
    Text4:  TEdit;
    RsDb: TADODataSet;
    gBanco: TADOConnection;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure Text3KeyPress(Sender: TObject; var Key: char);
    procedure Text3Exit(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  NovoClienteAlt: TNovoClienteAlt;

implementation

uses  Dialogs, SysUtils, Module1, RotGerais, frmMain_, VBto_Converter, Subrug;

{$R *.dfm}

 //=========================================================
procedure TNovoClienteAlt.Command1Click(Sender: TObject);
label
  Erro;
var
  sDestino: String;
  controle: Smallint;
begin
  Controle := 1;
  if Length(Text3.Text)=0 then begin
    Application.MessageBox('Digite o Número do Cliente', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text3.SetFocus();
    Exit;
  end;
  if Length(Text2.Text)=0 then begin
    Application.MessageBox('Digite o Nome do Cliente', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text2.SetFocus();
    Exit;
  end;
  if Length(Text1.Text)>20 then begin
    Application.MessageBox('Nome maior que o permitido. Redigite', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text1.SetFocus();
    Exit;
  end;
  if Length(Text4.Text)=0 then begin
    Application.MessageBox('Digite a Bandeira', 'Dados do Novo Cliente', MB_ICONSTOP);
    Text4.SetFocus();
    Exit;
  end;
  try  // On Error GoTo Erro

    // Grava Tabela Id no banco Admin
    controle := 2;

//    Desconecta();
  RsDb.Close;
//    if  not Conecta('adm') then Exit;
  Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl');

    sSql := 'Select * from [Clientes]';
    sSql := sSql+' where codigo_cliente = '#39''+Text3.Text+''#39'';
//    RsDb := gBanco.OpenRecordset(sSql);
  RsDb.CommandText := sSql;
  RsDb.Open;

    if  not RsDb.EOF then
      begin
      RsDb.Edit;
      VBtoADOFieldSet(RsDb, 'Nome_Cliente', Text2.Text);
      VBtoADOFieldSet(RsDb, 'Bandeira', Text4.Text);
      RsDb.UpdateRecord;
      end;

    sSql := 'Select * from [id]';
 //    RsDb := gBanco.OpenRecordset(sSql);

  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

      if RsDb.EOF then
        RsDb.Insert
      else
        RsDb.Edit;
      VBtoADOFieldSet(RsDb, 'Nome_Cliente', Text2.Text);
      RsDb.UpdateRecord;

    controle := 3;
    gBanco.Close;

//    gDataPath := GetPath()+'\';
    gDataPath := ExtractFileDir(Application.ExeName) + '\';
    gDataPath := String(gDataPath)+Text1.Text;
    gDataPath := gDataPath;
//    sDestino := String(gDataPath)+'\'+Text1.Text+'.MDB';
    sDestino := String(gDataPath)+'\'+Text1.Text+'.udl';

//    gBanco := gWork.OpenDatabase(sDestino);
    Conecta(gbanco, sDestino);

    bConectado := true;
    sSql := 'Select * from [Id]';
//    RsDb := gBanco.OpenRecordset(sSql);
  RsDb.Close;
  RsDb.CommandText := sSql;
  RsDb.Open;

      if RsDb.EOF then
        RsDb.Insert
      else
        RsDb.Edit;

      VBtoADOFieldSet(RsDb, 'Nome_Cliente', Text2.Text);
      RsDb.UpdateRecord;

    //Desconecta();
    RsDb.Close;
    gBanco.Close;

    fMainForm.MontaMenus;

    fMainForm.mnuClientes.Enabled := true;

    Application.MessageBox('Cliente Alterado...', 'Novo Cliente', MB_ICONINFORMATION);

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
    //Desconecta();
    RsDb.Close;
    gBanco.Close;
    //Close;

  end;
end;

procedure TNovoClienteAlt.Command2Click(Sender: TObject);
begin
  Close;
end;

procedure TNovoClienteAlt.Text3KeyPress(Sender: TObject; var Key: char);
begin
//  if KeyAscii=13 then begin
//    SendKeys(#9);
  if Key = Char(13) then
    begin
    SendKeys(9);
    end;
end;

procedure TNovoClienteAlt.Text3Exit(Sender: TObject);
begin

//  if  not Conecta('adm') then Exit;
  Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl');

  if Length(Trim(Text3.Text))=0 then
    Exit;
  sSql := 'Select * from [clientes]';
  sSql := sSql+' where codigo_cliente = '#39''+Text3.Text+''#39'';
//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.CommandText := sSql;
  RsDb.Open;

  if RsDb.EOF then
    begin
    ShowMessage('Cliente não Cadastrado.');
    Text3.SetFocus();
    Exit;
    end;
  Text1.Text := RsDb.FieldByName('Nome_Reduzido').Value;
  Text2.Text := RsDb.FieldByName('nome_cliente').Value;
  Text4.Text := RsDb.FieldByName('Bandeira').Value;
  Text3.Enabled := false;
//  Desconecta();
  RsDb.Close;
  gBanco.Close;
end;


end.
