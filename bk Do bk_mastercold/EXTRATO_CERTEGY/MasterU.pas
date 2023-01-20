Unit MasterU;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, SuTypGer, SuGeral,
  Menus, StdCtrls, Db, DBTables, Grids, Mask, ExtCtrls, ComCtrls, jpeg;

Type
  TMasterColdForm = Class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Label4: TLabel;
    ConsultaContaCartoCPFNome1: TMenuItem;
    Extrato1: TMenuItem;
    Emissode2viadeExtrato1: TMenuItem;
    Sobre1: TMenuItem;
    Sair2: TMenuItem;
    ConsultaConta1: TMenuItem;
    ConsultaCarto1: TMenuItem;
    ConsultaExtr1: TMenuItem;
    Empresarial1: TMenuItem;
    ExtratoEmpresarial1: TMenuItem;
    DadosdeEmpresa1: TMenuItem;
    PortadoresdeCartes1: TMenuItem;
    Demonstrativo2via1: TMenuItem;
    ContaExtratos1: TMenuItem;
    ConsultaResumo1: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ConsultaContaCartoCPFNome1Click(Sender: TObject);
    procedure ConsultaConta1Click(Sender: TObject);
    procedure ConsultaCarto1Click(Sender: TObject);
    procedure ConsultaExtr1Click(Sender: TObject);
    procedure Emissode2viadeExtrato1Click(Sender: TObject);
    procedure ExtratoEmpresarial1Click(Sender: TObject);
    procedure DadosdeEmpresa1Click(Sender: TObject);
    procedure PortadoresdeCartes1Click(Sender: TObject);
    procedure Demonstrativo2via1Click(Sender: TObject);
    procedure ContaExtratos1Click(Sender: TObject);
    procedure ConsultaResumo1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }

  End;

Var
  MasterColdForm: TMasterColdForm;

Implementation

Uses
  Subrug, EditTest, SelCont, ContaExtrU;

{$R *.DFM}

Procedure TMasterColdForm.Sair1Click(Sender: TObject);
Begin
Close;
End;

Procedure TMasterColdForm.FormCreate(Sender: TObject);
Var
  ArqExtra : System.Text;
Begin
BufI := Nil;
BufCmp := Nil;
If FileExists(ExtractFilePath(TheFileName)+'REMOTE.DAT') Then
  Begin
  AssignFile(ArqExtra,ExtractFilePath(TheFileName)+'REMOTE.DAT');
  Reset(ArqExtra);
  ReadLn(ArqExtra,RemoteServer);
  ReadLn(ArqExtra,PathServer);
  PathServer := IncludeTrailingPathDelimiter(PathServer);
  CloseFile(ArqExtra);
  End
Else
  Begin
  RemoteServer := '';
  PathServer := viPathBaseLocal;
  End;
End;

Procedure TMasterColdForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
Begin
ReallocMem(BufI,0);
ReallocMem(BufCmp,0);
FormGeral.IBAdmRemotoDatabase.Close;
End;

Procedure TMasterColdForm.ConsultaContaCartoCPFNome1Click(Sender: TObject);
Begin
SubForm := '';
Selecons.Show;
End;

Procedure TMasterColdForm.ConsultaConta1Click(Sender: TObject);
Begin
SubForm := 'CONTA';
Selecons.Show;
End;

Procedure TMasterColdForm.ConsultaCarto1Click(Sender: TObject);
Begin
SubForm := 'CARTAO';
Selecons.Show;
End;

Procedure TMasterColdForm.ConsultaExtr1Click(Sender: TObject);
Begin
SubForm := 'EXTR1';
Selecons.Show;
End;

Procedure TMasterColdForm.Emissode2viadeExtrato1Click(Sender: TObject);
Begin
SubForm := 'EXTR2';
Selecons.Show;
End;

Procedure TMasterColdForm.ExtratoEmpresarial1Click(Sender: TObject);
Begin
SubForm := 'EMPRESARIAL1';
Selecons.Show;
End;

procedure TMasterColdForm.DadosdeEmpresa1Click(Sender: TObject);
Begin
SubForm := 'EMPRESARIAL2';
Selecons.Show;
End;

Procedure TMasterColdForm.PortadoresdeCartes1Click(Sender: TObject);
Begin
SubForm := 'EMPRESARIAL3';
Selecons.Show;
End;

Procedure TMasterColdForm.Demonstrativo2via1Click(Sender: TObject);
Begin
SubForm := 'EMPRESARIAL4';
Selecons.Show;
End;

procedure TMasterColdForm.ContaExtratos1Click(Sender: TObject);
begin
ContaExtrForm.Memo1.Clear;
ContaExtrForm.SalvarButton.Enabled := False;
ContaExtrForm.ShowModal;
end;

procedure TMasterColdForm.ConsultaResumo1Click(Sender: TObject);
begin
SubForm := 'EXTR3';
Selecons.Show;
end;

End.
