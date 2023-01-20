program Gigantao;

uses
  Forms,
  UnitGigantao in 'UnitGigantao.pas' {Form1},
  UnitPdf in '..\..\Componentes\Defined\Delphi7\UnitPdf.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
