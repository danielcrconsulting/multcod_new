unit UnitDeTesteDaDll;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBTables, DB, Main;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Database1: TDatabase;
    Query1: TQuery;
    Session1: TSession;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  Function ListaPagina(NomeDoRelatorio, NomeDoArquivo : PChar;
                       NumeroDaPagina,
                       CodConsulta : Integer) : Integer; StdCall; External 'McW32Ifc.dll';

  Function ListaCampos(CodUsuario, NomeDoRelatorio : PChar) : Integer; StdCall; External 'McW32Ifc.dll';

{  Function GeraQueryFacil(CodConsulta : Integer;
                          Var
                            NumeroDePaginas,
                            Primeira,
                            Proxima,
                            Ultima : Integer) : Integer; StdCall; External 'McW32Ifc.dll';

}
Implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
  Atu,
  Tot,
  ID : Integer;
  Err1,
  Err2,
  Pagina,
  PagNor : String;
begin
Try
  ID := ListaPagina('C:\Rom\MultiCold\Destino\Multicold\Conta Corrente\Diário de conta corrente\DEMO\DemoII20031124_163833.DAT',
        'c:\Teste',1,-1);
Except
  On E: Exception Do
    Begin
    ShowMessage(E.Message);
    Exit;
    End;
End; //
ShowMessage('Ok...');
Exit;
DataBase1.Open;

Query1.SQL.Clear;
Query1.SQL.Add('SELECT * FROM paginaRelatorio WHERE IDPAGINA = '+IntToStr(ID));
Query1.Open;
Atu := Query1.Fields[1].AsInteger;
Tot := Query1.Fields[2].AsInteger;
Err1 := Query1.Fields[3].AsString;
Err2 := Query1.Fields[4].AsString;
PagNor := Query1.Fields[5].AsString;
Pagina := Query1.Fields[6].AsString;
Query1.Close;

DataBase1.Close;

ShowMessage(IntToStr(ID));
ShowMessage(IntToStr(Atu));
ShowMessage(IntToStr(Tot));
ShowMessage(Err1);
ShowMessage(Err2);
ShowMessage(Copy(PagNor,1,100));
ShowMessage(Copy(Pagina,1,100));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Try
  ListaCampos('TESTE','C:\Rom\MultiCold\Destino\Bac100\bac100bz-20010814.DAT');
Except
  On E: Exception Do
    Begin
    ShowMessage(E.Message);
    Exit;
    End;
End; //
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  N,P,Pr,U : Integer;
begin
//C:\Rom\MultiCold\Destino\CEF\SICOB_SEM_SEG\SICOB\COBR220\COBR22020010304_1502.DAT
GeraQueryFacil(9,N,P,Pr,U);
ShowMessage(IntToStr(N));
ShowMessage(IntToStr(P));
ShowMessage(IntToStr(Pr));
ShowMessage(IntToStr(U));
If N <> 0 Then
  ListaPagina('C:\Rom\MultiCold\Destino\CEF\SICOB\COBR002\cobr00220010326_1744.DAT','C:\Teste',1,9);
end;

end.
