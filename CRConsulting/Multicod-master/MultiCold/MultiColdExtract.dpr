Library MultiColdExtract;

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
  Sutypger in '..\Subrug\Sutypger.pas',
  Subrug in '..\Subrug\Subrug.pas',
  Sugeral in 'Sugeral.pas' {FormGeral},
  MextrUnit1 in 'MextrUnit1.pas',
  SuTypMultiCold in '..\Subrug\SuTypMultiCold.pas',
  ZLIBEX in '..\Subrug\DelphiZLib\ZLIBEX.PAS',
  Pilha in '..\CR CONSULTING\Pilha.pas';

{$R *.RES}

Exports
  MultiExtract;

Begin
End.
