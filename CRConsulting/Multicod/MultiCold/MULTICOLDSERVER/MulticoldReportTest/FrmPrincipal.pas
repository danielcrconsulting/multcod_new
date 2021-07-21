unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UMulticoldReport, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TForm2 = class(TForm)
    ScrollBarPrincipal: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Button3: TButton;
    EdtQueryFacil: TEdit;
    Button4: TButton;
    ScrollBarPesquisa: TScrollBar;
    Memo1: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBarPrincipalScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ScrollBarPesquisaScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  private
    FMulticoldManager: TMulticoldManager;

    procedure RefreshPage;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  FMulticoldManager := TMulticoldManager.Create('carlo','123','C:\ROM\MULTICOLD\DESTINO\BANCO MULTICOLD\FINANCEIRO\CONTABIL\BCO MULTICOLD\BANCO MULTICOLD_20180218_161032.DAT', true);

  FMulticoldManager.AbrirRelatorio;
  RefreshPage;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  ScrollBarPrincipal.PageSize := 0;

  if FMulticoldManager <> nil then
    FreeAndNil(FMulticoldManager);
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  buscaSequencial: TBuscaSequencial;
  resultado: TResultadoBuscaSequencial;
  tipo: TTipoBuscaSequencial;
begin
  if FMulticoldManager = nil then
    Exit;

    tipo := tbNormal;
    if FMulticoldManager.PesquisaAtiva then
      tipo := tbPesquisa;

    resultado := FMulticoldManager.ExecutarBuscaSequencial(-1,-1,-1,-1,-1, tipo, Edit1.Text);

    if resultado.Localizou then
        RefreshPage;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  query: TListaPesquisa;
  resultado: TListaResultadoPesquisa;
begin
  if FMulticoldManager = nil then
    Exit;

  ScrollBarPesquisa.Enabled := false;

  SetLength(query, 1);

  query[0].Index := 'A';
  query[0].Campo := 'CONTA';
  query[0].Operador := 1;
  query[0].Valor := EdtQueryFacil.Text;
  query[0].Conector := -1;

  if FMulticoldManager.ExecutarQueryFacil(query, '(A)', resultado) then
  begin
    ScrollBarPesquisa.Enabled := true;
    RefreshPage;
  end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Memo1.Lines.Clear;
  ScrollBarPrincipal.PageSize := 0;

  if FMulticoldManager <> nil then
    FreeAndNil(FMulticoldManager);
end;

procedure TForm2.RefreshPage;
begin
  ScrollBarPrincipal.Min := 1;
  ScrollBarPrincipal.Max := FMulticoldManager.QtdePaginas;
  ScrollBarPrincipal.Position := FMulticoldManager.IndexPagina -1;
  Memo1.Lines.Clear;

  if FMulticoldManager.PesquisaAtiva then
  begin
    ScrollBarPesquisa.Max := Length(FMulticoldManager.Pesquisa);
    ScrollBarPesquisa.min := 0;
    ScrollBarPesquisa.Position := FMulticoldManager.PesquisaPagIndedex;
  end;

  Memo1.Lines.Text := FMulticoldManager.PaginaDescompactada;
end;

procedure TForm2.ScrollBarPesquisaScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then
    exit;

  if FMulticoldManager = nil then
    exit;

  FMulticoldManager.NavegarParaPagina(FMulticoldManager.Pesquisa[ScrollPos].Pagina);
  FMulticoldManager.PesquisaPagIndedex := ScrollPos;

  RefreshPage;
end;

procedure TForm2.ScrollBarPrincipalScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  if ScrollCode = scEndScroll then
    exit;

  if FMulticoldManager = nil then
    exit;

  FMulticoldManager.NavegarParaPagina(ScrollPos + 1);
  RefreshPage;
end;

end.
