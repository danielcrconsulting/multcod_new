unit Template;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons, ComCtrls;

type
  TFrmTemplate = class(TForm)
    CancelarBtn: TBitBtn;
    LimparBtn: TBitBtn;
    LerBtn: TBitBtn;
    SalvarBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GridTmpl: TStringGrid;
    NovoCampoBtn: TBitBtn;
    DelCampoBtn: TBitBtn;
    ImpCampoBtn: TBitBtn;
    auxStringGrid: TStringGrid;
    procedure LimparBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridTmplDblClick(Sender: TObject);
    procedure LerBtnClick(Sender: TObject);
    procedure SalvarBtnClick(Sender: TObject);
    procedure NovoCampoBtnClick(Sender: TObject);
    procedure DelCampoBtnClick(Sender: TObject);
    procedure ImpCampoBtnClick(Sender: TObject);
    procedure CancelarBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Temp : TComponent;
    Procedure LeTemplate(NomArq : String);
  end;

var
  FrmTemplate: TFrmTemplate;
  IndCampo : Integer;

implementation

uses Qhelpu, ComObj, Mdiedit, MdiMultiCold, Scampo;

{$R *.DFM}

Procedure TFrmTemplate.LimparBtnClick(Sender: TObject);
Var
  I : Integer;
Begin
While IndCampo > 2 Do
  DelCampoBtn.Click;
For I := 1 to 15 Do
  Try
    TStringGrid(PageControl1.Pages[0].Components[0]).Cells[1,I] := '';
  Except
    GridTmpl.Cells[1,I] := '';
    End; // Try
End;

Procedure TFrmTemplate.FormCreate(Sender: TObject);
Var
  I : Integer;
Begin

GridTmpl.Cells[0,1] := 'Linha Inicial';
GridTmpl.Cells[0,2] := 'Linha Final';
GridTmpl.Cells[0,3] := 'Coluna';
GridTmpl.Cells[0,4] := 'Tamanho';
GridTmpl.Cells[0,5] := 'Brancos';
GridTmpl.Cells[0,6] := 'Nome';
GridTmpl.Cells[0,7] := 'Tipo';
GridTmpl.Cells[0,8] := 'CharInc';
GridTmpl.Cells[0,9] := 'CharExc';
GridTmpl.Cells[0,10] := 'StrInc';
GridTmpl.Cells[0,11] := 'StrExc';
GridTmpl.Cells[0,12] := 'Máscara no Relatório';
GridTmpl.Cells[0,13] := 'Máscara a Exportar';
GridTmpl.Cells[0,14] := '';
GridTmpl.Cells[0,15] := 'Comentário';
IndCampo := 2;

// Fazer o backup deste componente pois ele pode deixar de existir...

With auxStringGrid Do
  Begin
  Top := GridTmpl.Top;
  Left := GridTmpl.Left;
  Width := GridTmpl.Width;
  RowCount := GridTmpl.RowCount;
  ColCount := GridTmpl.ColCount;
  DefaultColWidth := GridTmpl.DefaultColWidth;
  Height := GridTmpl.Height;
  Options := GridTmpl.Options;
  For I := 1 to 15 Do
    Cells[0,I] := GridTmpl.Cells[0,I];
  End;

GridTmpl.Parent := TabSheet1; // Amarrar os endereços de referência

end;

procedure TFrmTemplate.GridTmplDblClick(Sender: TObject);
Var
  auxComp : TStringGrid;
begin
QHelp.CleanTheMess;

Try
  auxComp := TStringGrid(PageControl1.Pages[PageControl1.ActivePageIndex].Components[0]);
Except
  auxComp := GridTmpl;
  End; // Try
//Case GridTmpl.Row of
Case auxComp.Row of
  1 : Begin
      QHelp.Label1.Caption := 'Linha Inicial do Relatório onde se encontra o Campo a ser Exportado';
      QHelp.ShowModal;
      End;
  2 : Begin
      QHelp.Label1.Caption := 'Linha Final do Relatório onde se encontra o Campo a ser Exportado';
      QHelp.ShowModal;
      End;
  3 : Begin
      QHelp.Label1.Caption := 'Coluna do Relatório onde Começa o Campo a ser Exportado';
      QHelp.ShowModal;
      End;
  4 : Begin
      QHelp.Label1.Caption := 'Tamanho do Campo a ser Exportado';
      QHelp.ShowModal;
      End;
  5 : Begin
      QHelp.Label1.Caption := 'Tratamento dos Brancos do Campo a ser Exportado';
      QHelp.Label2.Caption := '0 - Retira Todos os Brancos do Campo';
      QHelp.Label3.Caption := '1 - Retira os Brancos do Final do Campo';
      QHelp.Label4.Caption := '2 - Retira os Brancos do Início do Campo';
      QHelp.Label5.Caption := '3 - Nenhum Tratamento de Brancos';
      QHelp.Label6.Caption := '4 - Retira os Brancos do Início e do Final do Campo';
      QHelp.ShowModal;
      End;
  6 : Begin
      QHelp.Label1.Caption := 'Nome do Campo a ser Exportado';
      QHelp.ShowModal;
      End;
  7 : Begin
      QHelp.Label1.Caption := 'Tipo do Campo a ser Exportado';
      QHelp.Label2.Caption := 'C - Caracter';
      QHelp.Label3.Caption := 'N - Numérico';
      QHelp.Label4.Caption := 'F - Float -> Numérico com Decimais ( , -> Real )';
      QHelp.Label5.Caption := 'D - Float -> Numérico com Decimais ( . -> Dollar )';
      QHelp.ShowModal;
      End;
  8 : Begin
      QHelp.Label1.Caption := 'Filtro - Únicos Caracteres Aceitos no Campo';
      QHelp.Label2.Caption := '  Antes de Exportar o Campo, o Programa Verifica se há caracteres';
      QHelp.Label3.Caption := '  diferentes dos relacionados. Se sim, rejeita o campo ';
      QHelp.Label4.Caption := 'Ex.: ''A..Z'' -> só aceita caracteres entre ''A'' e ''Z'' maiúsculos';
      QHelp.Label5.Caption := '     ''0..9'',''.'','','' -> só numéricos, ponto e vírgula';
      QHelp.ShowModal;
      End;
  9 : Begin
      QHelp.Label1.Caption := 'Filtro - Caracteres NÃO Aceitos no Campo';
      QHelp.Label2.Caption := '  Antes de Exportar o Campo, o Programa Verifica se há caracteres';
      QHelp.Label3.Caption := '  iguais aos relacionados. Se sim, rejeita o campo ';
      QHelp.Label4.Caption := 'Ex.: ''/'' -> rejeita se o Campo tem o caracter ''/''';
      QHelp.Label5.Caption := '     ''a..z'' -> rejeita se o campo tem minúsculas';
      QHelp.ShowModal;
      End;
 10 : Begin
      QHelp.Label1.Caption := 'Filtro - String existente na linha a ser indexada';
      QHelp.Label2.Caption := '  Antes de Exportar o Campo, o Programa Verifica se há caracteres iguais';
      QHelp.Label3.Caption := '  aos relacionados na coluna especificada. Se não, rejeita o campo ';
      QHelp.Label4.Caption := 'Ex.: 13,3=''MOV'' -> seleciona se a Linha contém o String ''MOV'' na coluna 13';
      QHelp.Label5.Caption := ' coluna,tamanho -> Coluna = 13 ; Tamanho = 3';
      QHelp.ShowModal;
      End;
 11 : Begin
      QHelp.Label1.Caption := 'Filtro - String existente na linha a ser rejeitada';
      QHelp.Label2.Caption := '  Antes de Exportar o Campo, o Programa Verifica se há caracteres iguais';
      QHelp.Label3.Caption := '  aos relacionados na coluna especificada. Se sim, rejeita o campo ';
      QHelp.Label4.Caption := 'Ex.: 13,5=''TOTAL'' -> rejeita se a Linha contém o String ''TOTAL'' na coluna 13';
      QHelp.Label5.Caption := ' coluna,tamanho -> Coluna = 13 ; Tamanho = 5';
      QHelp.ShowModal;
      End;
 12 : Begin
      QHelp.Label1.Caption := 'Máscara do campo como está representada no relatório ( Data e/ou Hora )';
      QHelp.Label2.Caption := 'AAAA = Ano com 4 dígitos, AA = ano com 2 dígitos, MM = mês e DD = dia';
      QHelp.Label3.Caption := 'HH = hora, NN = minuto e SS = segundo ';
      QHelp.Label4.Caption := 'Ex.: DD/MM/AA, DD/MM/AAAA, HH:NN:SS ';
      QHelp.ShowModal;
      QHelp.Label1.Caption := 'Máscara do campo como está representada no relatório ( Geral )';
      QHelp.Label2.Caption := 'C = Caracter desejado; X = Caracter a ser rejeitado';
      QHelp.Label3.Caption := 'Ex.: CCCCXCCCCXCCCCXCCCC ';
      QHelp.Label4.Caption := '';
      QHelp.ShowModal;
      End;
 13 : Begin
      QHelp.Label1.Caption := 'Máscara do campo do relatório como deverá ser exportado ( Data e/ou Hora )';
      QHelp.Label2.Caption := 'AAAA = Ano com 4 dígitos, AA = ano com 2 dígitos, MM = mês e DD = dia';
      QHelp.Label3.Caption := 'HH = hora, NN = minuto e SS = segundo ';
      QHelp.Label4.Caption := 'Ex.: DD/MM/AA, DD/MM/AAAA, HH:NN:SS ';
      QHelp.ShowModal;
      End;
 14 : Begin
      QHelp.Label1.Caption := 'Campo sem função';
      QHelp.ShowModal;
      End;
 15 : Begin
      QHelp.Label1.Caption := 'Livre ';
      QHelp.ShowModal;
      End;
  end; {Case}
end;

Procedure TFrmTemplate.LeTemplate(NomArq : String);
Var
  I : Integer;
  Arq : System.Text;
  Linha : String;
Begin
LimparBtn.Click;
AssignFile(Arq,NomArq);
Reset(Arq);
I := 1;
Try
  Temp := TStringGrid(PageControl1.Pages[0].Components[0]);
Except
  Temp := GridTmpl;
  End; // Try
While Not Eof(Arq) Do
  Begin
  If Not Eof(Arq) Then
    Begin
    ReadLn(Arq,Linha);
{    If Linha = '//CnfgPagina' Then
      Begin
      ReadLn(Arq,Linha);
      GridPag.Cells[1,1] := Linha;
      ReadLn(Arq,Linha);
      GridPag.Cells[1,2] := Linha;
      ReadLn(Arq,Linha);
      GridPag.Cells[1,3] := Linha;
      ReadLn(Arq,Linha);
      GridPag.Cells[1,4] := Linha;
      PageControl1.ActivePageIndex := PageControl1.PageCount-1;
      DelCampoBtn.Click;
      Break;
      End;    }
    TStringGrid(Temp).Cells[1,I] := Linha;
    End;
  Inc(I);
  If I = 16 Then
    If Not Eof(Arq) Then
      Begin
      I := 1;
      NovoCampoBtn.Click;
      End;
  End;
CloseFile(Arq);
End;

procedure TFrmTemplate.LerBtnClick(Sender: TObject);
begin
OpenDialog1.InitialDir := 'C:\ColdCfg';
If OpenDialog1.Execute Then
  LeTemplate(OpenDialog1.FileName);
end;

Procedure TFrmTemplate.SalvarBtnClick(Sender: TObject);
Var
  Arq : System.Text;
  I,J : Integer;
Begin
SaveDialog1.InitialDir := 'C:\ColdCfg';
If SaveDialog1.Execute Then
  Begin
  AssignFile(Arq,SaveDialog1.FileName);
  ReWrite(Arq);

  For J := 1 To PageControl1.PageCount Do
    Begin
    Try
      Temp := PageControl1.Pages[J-1].Components[0];
    Except
      Temp := GridTmpl;
      End;// Try
    For I := 1 to 15 do
      WriteLn(Arq,TStringGrid(Temp).Cells[1,I]);
    End;

{  WriteLn(Arq,'//CnfgPagina');
  WriteLn(Arq,GridPag.Cells[1,1]);
  WriteLn(Arq,GridPag.Cells[1,2]);
  WriteLn(Arq,GridPag.Cells[1,3]);
  WriteLn(Arq,GridPag.Cells[1,4]); }

  CloseFile(Arq);
  end;
Application.ProcessMessages;
end;

procedure TFrmTemplate.NovoCampoBtnClick(Sender: TObject);
Var
  I : Integer;
  auxTabSheet : TTabSheet;
begin
auxTabSheet := TTabSheet.Create(PageControl1);
With auxTabSheet do
  Begin
  PageControl := PageControl1;
  Name := 'TabSheet' + IntToStr(IndCampo);
  Caption := 'Campo' + IntToStr(IndCampo);
  Inc(IndCampo);
  End;

Temp := TStringGrid.Create(auxTabSheet); // Vamos guardar o endereço deste componente para usar na leitura do template
With TStringGrid(Temp) Do
  Begin
//  Parent := PageControl1.Pages[IndCampo-2];
  Parent := auxTabSheet;
  Name := 'GridTmp'+IntToStr(IndCampo);
  Top := auxStringGrid.Top;
  Left := auxStringGrid.Left;
  Width := auxStringGrid.Width;
  RowCount := auxStringGrid.RowCount;
  ColCount := auxStringGrid.ColCount;
  DefaultColWidth := auxStringGrid.DefaultColWidth;
  Height := auxStringGrid.Height;           //185;
  Options := auxStringGrid.Options;
  For I := 1 to 15 Do
    Cells[0,I] := auxStringGrid.Cells[0,I];
  OnDblClick := GridTmplDblClick;
  End;

end;

procedure TFrmTemplate.DelCampoBtnClick(Sender: TObject);
Var
  I : Integer;
begin
If IndCampo > 2 Then
  Begin
  PageControl1.Pages[PageControl1.ActivePageIndex].Free;
  For I := PageControl1.ActivePageIndex To PageControl1.PageCount-1 Do
    Begin
//    PageControl1.Pages[I].Assign(PageControl1.Pages[I+1]);
    PageControl1.Pages[I].Name := 'TabSheet' + IntToStr(I+1);
    PageControl1.Pages[I].Caption := 'Campo' + IntToStr(I+1);
    End;
//  PageControl1.Pages[IndCampo-2].Free;
  Dec(IndCampo);
  End;
end;

Procedure TFrmTemplate.ImpCampoBtnClick(Sender: TObject);
Var
  I, J : Integer;
  Temp : TComponent;
Begin
SelCampo.ShowModal;
If CampoSel = 0 then
  Exit;

//With EditForm[FrameForm.JanAtu] Do
With TEditForm(FrameForm.ActiveMDIChild) Do
  For I := 1 To DefChave.RowCount Do
    If DefChave.Cells[6,I] = SelCampo.Campos.Cells[1,CampoSel] Then
      Begin

      Try
        Temp := TStringGrid(PageControl1.Pages[PageControl1.ActivePageIndex].Components[0]);
      Except
        Temp := GridTmpl;
        End; // Try

//    For K := 0 To ComponentCount - 1 do
//      Begin
//      Temp := Components[K];
//      If (Temp is TStringGrid) Then
//        If TStringGrid(Temp).Parent = PageControl1.Pages[PageControl1.ActivePage.TabIndex] Then
        For J := 1 to DefChave.ColCount Do
          TStringGrid(Temp).Cells[1,J] := DefChave.Cells[J,I];
//      End;
//    Break;
      End;
End;

procedure TFrmTemplate.CancelarBtnClick(Sender: TObject);
begin
Close;
end;

end.
