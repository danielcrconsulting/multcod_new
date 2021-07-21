unit SimulaMenu_;

interface

uses  Forms, Classes, Controls, StdCtrls;


type
  TSimulaMenu = class(TForm)
    Frame1:  TGroupBox;
    Text1:  TEdit;
    List1:  TListBox;
    Command1:  TButton;
    Command2:  TButton;

    procedure Command1Click(Sender: TObject);
    procedure Command2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure List1Click(Sender: TObject);

  private
    { Private declarations }

    procedure Form_Unload(var Cancel: Smallint);

  public
    { Public declarations }

    simulSql : String;

  end;

var
  SimulaMenu: TSimulaMenu;

implementation

uses  SysUtils, Module1, RotGerais, AdoDB;

{$R *.dfm}

 //=========================================================
procedure TSimulaMenu.Command1Click(Sender: TObject);
begin
  Close;
end;

procedure TSimulaMenu.Command2Click(Sender: TObject);
begin
  Self.Text1.Text := '';
  Close;
end;

procedure TSimulaMenu.FormShow(Sender: TObject);
Var
  AdoConnection : TAdoConnection;
  RsDb : TAdoDataSet;
begin
  CenterForm(Self);
  Self.Top := Self.Top-600;
  if Pos('.', gDataFile)=0 then gDataFile := gDataFile+'.udl';

//  if  not Conecta('') then Exit;

  if not Conecta(AdoConnection, gDataPath + gDataFile + '.udl') then
    Exit;

  RsDb := TAdoDataSet.Create(nil);
  RsDb.Connection := AdoConnection;

//  RsDb := gBanco.OpenRecordset(sSql);
  RsDb.CommandText := simulSql;
  RsDb.Open;

    // Me.Text1.Text = Mid$(.Fields("conta_contabil"), 1, 2) & "." &
    // Mid$(.Fields("conta_contabil"), 3, 2) & "." &
    // Mid$(.Fields("conta_contabil"), 5, 2) & " - " &
    // .Fields("Opcao")
  if RsDb.EOF then
    Exit;
    // Tira os pontos em 11.05.04 > 2008/09/03
    // Me.Text1.Text = Mid$(.Fields("conta_contabil"), 1, 2) & "." &
    // Mid$(.Fields("conta_contabil"), 3, 2) & "." &
    // Mid$(.Fields("conta_contabil"), 5, 2) & " - " &
    // .Fields("Opcao")
  Self.Text1.Text := String(RsDb.FieldByName('conta_contabil').Value)+' - '+String(RsDb.FieldByName('Opcao').Value);
  while not RsDb.EOF do
    begin
      // Tira os pontos em 11.05.04  > 2008/09/03
      // Me.List1.AddItem Mid$(.Fields("conta_contabil"), 1, 2) & "." &
      // Mid$(.Fields("conta_contabil"), 3, 2) & "." &
      // Mid$(.Fields("conta_contabil"), 5, 2) & " - " &
      // .Fields ("Opcao")
    Self.List1.AddItem(String(RsDb.FieldByName('conta_contabil').Value)+' - '+String(RsDb.FieldByName('Opcao').Value),nil);
    RsDb.Next;
    end;

  AdoConnection.Close;
  AdoConnection.Free;
  RsDb.Close;

  Self.Caption := Self.Caption+gCliente;
//  if  not Conecta('adm') then Exit;

   if  not Conecta(AdoConnection, ExtractFileDir(Application.ExeName) + '\admin.udl') then
    Exit;

  simulSql := 'Select * from [tb_tipo_con]';
  simulSql := sSql+' where cliente = '#39''+gCliente+''#39'';

//  RsDb := gBanco.OpenRecordset(sSql);

  RsDb.CommandText := simulSql;
  RsDb.Open;

  if  not EOF then
    begin
      // gArquivo = UCase(RsDb.Fields("Arq_Entrada"))
      // Concil.ArqEntrada = .Fields("Arq_Entrada")
    Concil.ContaContabil := Trim(RsDb.FieldByName('conta_contabil').AsString);
    Concil.ContaContabil := Trim(RsDb.FieldByName('cd_cli_banco').Value);
    Concil.Natureza := RsDb.FieldByName('Natureza_conta').Value;
    Concil.nome := Trim(RsDb.FieldByName('nm_conciliacao').Value);
    end;

AdoConnection.Close;
RsDb.Close;
AdoConnection.Free;
RsDb.Free;
end;

procedure TSimulaMenu.FormPaint(Sender: TObject);
begin
  List1.SetFocus();
end;

procedure TSimulaMenu.Form_Unload(var Cancel: Smallint);
var
  I: Smallint;
begin
  I := Pos(' -', Self.Text1.Text);
  if I<>0 then begin
    gOpcao := Copy(Self.Text1.Text, I+3, Length(Self.Text1.Text)-I+3);
   end  else  begin
    gOpcao := Self.Text1.Text;
  end;
end;

procedure TSimulaMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
        Cancel: Smallint;
begin
        Cancel := 0;

        Form_Unload(Cancel);
        If Cancel<>0 Then CanClose := false;
end;

procedure TSimulaMenu.List1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Text1.Text := List1.Items.Strings[List1.ItemIndex];
  Close;
end;

end.
