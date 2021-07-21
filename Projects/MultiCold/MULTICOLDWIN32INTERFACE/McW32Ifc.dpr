Library McW32Ifc;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  SuTypGer in '..\Subrug\SuTypGer.pas',
  ZLibEx in '..\Subrug\DelphiZLib\ZLIBEX.PAS',
  Main in 'Main.pas' {DataModule1: TDataModule},
  SuBrug in '..\Subrug\Subrug.pas',
  AuxFormUnit in 'AuxFormUnit.pas' {AuxForm};

Exports
  ListaPagina,
  ListaCampos,
  GeraQueryFacil;

{$R *.res}

Begin
End.
