unit UElimina_linha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Samples.Gauges;

type
  TfrmPrincipal = class(TForm)
    btnAbrir: TButton;
    OpenDialog1: TOpenDialog;
    gb: TGroupBox;
    Label1: TLabel;
    edpos: TEdit;
    Label2: TLabel;
    edtam: TEdit;
    Label3: TLabel;
    edCont: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edlinha: TEdit;
    Button2: TButton;
    lblmsg: TLabel;
    memtb: TFDMemTable;
    memtbident: TStringField;
    memtbcartao: TStringField;
    memtbconta: TStringField;
    memtbstatus: TStringField;
    memtbcnpj: TStringField;
    memtbnome: TStringField;
    memtbtitular: TStringField;
    memtbtipo: TStringField;
    memtbcodbloq: TStringField;
    memtbdtbloq: TStringField;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    StrArq  : TStringList;
    nomearq : String;
    tArq, tArqCop : TextFile;
    procedure OrdenarArq;
    procedure Separar;

  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnAbrirClick(Sender: TObject);
var
  est : String;
begin
  if OpenDialog1.Execute() then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      //StrArq.LoadFromFile(OpenDialog1.FileName);
      AssignFile(tArq, OpenDialog1.FileName);
      nomearq := OpenDialog1.FileName;

      est    := Copy(nomearq,pos('.',nomearq),4);
      AssignFile(tArqcop, Copy(nomearq,1,pos('.',nomearq)-1) + '_new' + est);
      if FileExists(Copy(nomearq,1,pos('.',nomearq)-1) + '_new' + est) then
        DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_new' + est);

      Rewrite(tarqcop);

      btnAbrir.Enabled := False;
      gb.Enabled := True;
      ShowMessage('Arquivo Aberto');
    end;
  end;
end;

procedure TfrmPrincipal.btnFecharClick(Sender: TObject);
begin
  StrArq.Clear;
  btnAbrir.Enabled := True;
  gb.Enabled := False;
end;

procedure TfrmPrincipal.btnSalvarClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      StrArq.SaveToFile(OpenDialog1.FileName);
      ShowMessage('Arquivo Salvo');
    end;
  end;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
var i, qtd, qtdlin : Integer;
  linha : String;
begin
  if edpos.Text = '' then
  begin
    ShowMessage('Posi��o inv�lida');
    exit;
  end;
  if edtam.Text = '' then
  begin
    ShowMessage('Tamanho inv�lida');
    exit;
  end;
  if edCont.Text = '' then
  begin
    ShowMessage('Conte�do inv�lida');
    exit;
  end;
  lblmsg.Visible := True;
  Application.ProcessMessages;
  qtdlin := 0;
  qtd := StrArq.Count - 1;

  Reset(tarq);
  //Reset(tarqCop);
  while (not Eof(tarq)) do
  begin
    Readln(tarq, linha);
    if copy(linha, StrToInt(edPos.text), StrToInt(edTam.Text)) <>
       trim(edCont.Text) then
    begin
      Writeln(tarqcop,linha);
    end;
  end;
  CloseFile(tarq);
  CloseFile(tarqcop);

  {
  for i := 0 to StrArq.Count - 1 do
  begin
    if i+qtdlin > qtd then
      break;
    if copy(strArq.Strings[i], StrToInt(edPos.text), StrToInt(edTam.Text)) =
       trim(edCont.Text) then
    begin
      StrArq.Delete(i);
      inc(qtdlin);
    end;
  end;
  }
  gb.Enabled := False;
  edpos.Clear;
  edtam.Clear;
  edCont.Clear;
  lblmsg.Visible := False;
  ShowMessage('Linhas Eliminadas');
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      Separar;
    end
    ).Start;
end;

procedure TfrmPrincipal.Separar;
var i, arq, count, linhaint : Integer;
    linha, est : String;
    arq1, arq2, arq3, arq4, arq5, arq6, arq7, arq8, arq9, arq10 : TextFile;
begin
  if edlinha.Text = '' then
  begin
    ShowMessage('Linha inv�lida');
    exit;
  end;
  lblmsg.Visible := True;
  Application.ProcessMessages;
  est    := Copy(nomearq,pos('.',nomearq),4);
  linhaint  := StrToInt(edlinha.Text);

  arq    := 1;
  count  := 0;

  AssignFile(arq1, Copy(nomearq,1,pos('.',nomearq)-1) + '_1' + est);
  Rewrite(arq1);

  AssignFile(arq2, Copy(nomearq,1,pos('.',nomearq)-1) + '_2' + est);
  Rewrite(arq2);

  AssignFile(arq3, Copy(nomearq,1,pos('.',nomearq)-1) + '_3' + est);
  Rewrite(arq3);

  AssignFile(arq4, Copy(nomearq,1,pos('.',nomearq)-1) + '_4' + est);
  Rewrite(arq4);

  AssignFile(arq5, Copy(nomearq,1,pos('.',nomearq)-1) + '_5' + est);
  Rewrite(arq5);

  AssignFile(arq6, Copy(nomearq,1,pos('.',nomearq)-1) + '_6' + est);
  Rewrite(arq6);

  AssignFile(arq7, Copy(nomearq,1,pos('.',nomearq)-1) + '_7' + est);
  Rewrite(arq7);

  AssignFile(arq8, Copy(nomearq,1,pos('.',nomearq)-1) + '_8' + est);
  Rewrite(arq8);

  AssignFile(arq9, Copy(nomearq,1,pos('.',nomearq)-1) + '_9' + est);
  Rewrite(arq9);

  AssignFile(arq10, Copy(nomearq,1,pos('.',nomearq)-1) + '_10' + est);
  Rewrite(arq10);

  Reset(tarq);
  while (not Eof(tarq)) do
  begin
    Readln(tarq, linha);
    if arq = 1 then
      Writeln(arq1,linha);
    if arq = 2 then
      Writeln(arq2,linha);
    if arq = 3 then
      Writeln(arq3,linha);
    if arq = 4 then
      Writeln(arq4,linha);
    if arq = 5 then
      Writeln(arq5,linha);
    if arq = 6 then
      Writeln(arq6,linha);
    if arq = 7 then
      Writeln(arq7,linha);
    if arq = 8 then
      Writeln(arq8,linha);
    if arq = 9 then
      Writeln(arq9,linha);
    if arq = 10 then
      Writeln(arq10,linha);
    if count = (linhaint - 1) then
    begin
      count := 0;
      inc(arq);
      Continue;
    end;
    inc(count);
  end;

  CloseFile(arq1);
  CloseFile(arq2);
  CloseFile(arq3);
  CloseFile(arq4);
  CloseFile(arq5);
  CloseFile(arq6);
  CloseFile(arq7);
  CloseFile(arq8);
  CloseFile(arq9);
  CloseFile(arq10);
  if arq < 2 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_2' + est);
  if arq < 3 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_3' + est);
  if arq < 4 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_4' + est);
  if arq < 5 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_5' + est);
  if arq < 6 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_6' + est);
  if arq < 7 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_7' + est);
  if arq < 8 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_8' + est);
  if arq < 9 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_9' + est);
  if arq < 10 then
    DeleteFile(Copy(nomearq,1,pos('.',nomearq)-1) + '_10' + est);
  lblmsg.Visible := False;
  ShowMessage('Arquivos gerados');
end;


procedure TfrmPrincipal.Button3Click(Sender: TObject);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      OrdenarArq;
    end
    ).Start;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(StrArq);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  StrArq := TStringList.Create;
end;

procedure TfrmPrincipal.OrdenarArq;
var linha, est : String;
  arq1 : Textfile;
  nLinhas, count : Integer;
begin
  lblmsg.Visible := True;
  count := 0;

  est    := Copy(nomearq,pos('.',nomearq),4);
  Application.ProcessMessages;
  memtb.CreateDataSet;
  Reset(tarq);
  while (not Eof(tarq)) do
  begin
    Readln(tarq, linha);
    memtb.Append;
    memtb.FieldByName('ident').AsString   := copy(linha,1,6);
    memtb.FieldByName('cartao').AsString  := copy(linha,7,22);
    memtb.FieldByName('conta').AsString   := copy(linha,23,16);
    memtb.FieldByName('status').AsString  := copy(linha,39,26);
    memtb.FieldByName('cnpj').AsString    := copy(linha,41,15);
    memtb.FieldByName('nome').AsString    := copy(linha,56,19);
    memtb.FieldByName('titular').AsString := copy(linha,72,1);
    memtb.FieldByName('tipo').AsString    := copy(linha,73,1);
    memtb.FieldByName('codbloq').AsString := copy(linha,74,2);
    memtb.FieldByName('dtbloq').AsString  := copy(linha,76,8);
    inc(count);
    //gauge1.Progress := count;
    //lblmsg.Caption  := ' Processamento ->' + IntToStr(count);
    //Application.ProcessMessages;
    //gauge1.MaxValue := count;
    memTb.Post;
  end;
  AssignFile(arq1, Copy(nomearq,1,pos('.',nomearq)-1) + '_ord' + est);
  Rewrite(arq1);

  memtb.First;
  count := 0;
  while not memtb.Eof do
  begin
    linha := memtb.FieldByName('ident').AsString  +
             memtb.FieldByName('cartao').AsString +
             memtb.FieldByName('conta').AsString  +
             memtb.FieldByName('status').AsString +
             memtb.FieldByName('cnpj').AsString   +
             memtb.FieldByName('nome').AsString   +
             memtb.FieldByName('titular').AsString +
             memtb.FieldByName('tipo').AsString    +
             memtb.FieldByName('codbloq').AsString +
             memtb.FieldByName('dtbloq').AsString;
    Writeln(arq1,linha);
    inc(count);
    memtb.Next;
  end;
  closefile(tarq);
  closefile(arq1);
  memtb.Close;

  ShowMessage('Arquivo ordenado com sucesso');
end;

end.