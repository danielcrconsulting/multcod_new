unit dataModule;

interface

uses
  SysUtils, Classes, DB, ADODB, Forms;

type
  TrepositorioDeDados = class(TDataModule)
    dbMulticold: TADOConnection;
    tMascaraCampo: TADOTable;
    tDfn: TADOTable;
    tUsuario: TADOTable;
    tUsuarioMascara: TADOTable;
    Query01: TADOQuery;
    Query02: TADOQuery;
    qMascaraCamposINS: TADOQuery;
    qMascaraCamposUPD: TADOQuery;
    qMascaraCamposDEL: TADOQuery;
    qUsuarioMascaraINS: TADOQuery;
    qUsuarioMascaraDEL: TADOQuery;
    tMascaraCampoCODREL: TStringField;
    tMascaraCampoNOMECAMPO: TStringField;
    tMascaraCampoLINHAI: TIntegerField;
    tMascaraCampoLINHAF: TIntegerField;
    tMascaraCampoCOLUNA: TIntegerField;
    tMascaraCampoTAMANHO: TIntegerField;
    tUsuarioMascaraCODREL: TStringField;
    tUsuarioMascaraNOMECAMPO: TStringField;
    tUsuarioMascaraCODUSUARIO: TStringField;
    tMapaDeNomes: TADOTable;
    qMapaDeNomesINS: TADOQuery;
    qMapaDeNomesUPD: TADOQuery;
    qMapaDeNomesDEL: TADOQuery;
    tMapaDeNomesNOMEORIGINAL: TStringField;
    tMapaDeNomesNOVONOME: TStringField;
    tMapaDeNomesNOVODIRSAIDA: TStringField;
    tExtrator: TADOTable;
    qExtratorINS: TADOQuery;
    qExtratorUPD: TADOQuery;
    qExtratorDEL: TADOQuery;
    tExtratorCODREL: TStringField;
    tExtratorCODSIS: TIntegerField;
    tExtratorCODGRUPO: TIntegerField;
    tExtratorXTR: TStringField;
    tExtratorDESTINO: TStringField;
    tExtratorDIREXPL: TStringField;
    tExtratorOPERACAO: TStringField;
    tExtratorSUBDIR: TStringField;
    tExtratorARQUIVO: TStringField;
    tDestinosDfn: TADOTable;
    qDestinosDfnINS: TADOQuery;
    qDestinosDfnUPD: TADOQuery;
    qDestinosDfnDEL: TADOQuery;
    tDestinosDfnCODREL: TStringField;
    tDestinosDfnDESTINO: TStringField;
    tDestinosDfnTIPODESTINO: TStringField;
    tDestinosDfnSEGURANCA: TStringField;
    tDestinosDfnQTDPERIODOS: TIntegerField;
    tDestinosDfnTIPOPERIODO: TStringField;
    tDestinosDfnUSUARIO: TStringField;
    tDestinosDfnSENHA: TStringField;
    tDestinosDfnDIREXPL: TStringField;
    tIndicesDfn: TADOTable;
    qIndicesDfnINS: TADOQuery;
    qIndicesDfnUPD: TADOQuery;
    qIndicesDfnDEL: TADOQuery;
    tIndicesDfnCODREL: TStringField;
    tIndicesDfnNOMECAMPO: TStringField;
    tIndicesDfnLINHAI: TIntegerField;
    tIndicesDfnLINHAF: TIntegerField;
    tIndicesDfnCOLUNA: TIntegerField;
    tIndicesDfnTAMANHO: TIntegerField;
    tIndicesDfnBRANCO: TStringField;
    tIndicesDfnTIPO: TStringField;
    tIndicesDfnMASCARA: TStringField;
    tIndicesDfnCHARINC: TStringField;
    tIndicesDfnCHAREXC: TStringField;
    tIndicesDfnSTRINC: TStringField;
    tIndicesDfnSTREXC: TStringField;
    tIndicesDfnFUSAO: TIntegerField;
    tRelatoCD: TADOTable;
    qRelatoCDINS: TADOQuery;
    qRelatoCDUPD: TADOQuery;
    qRelatoCDDEL: TADOQuery;
    tRelatoCDCODSIS: TIntegerField;
    tRelatoCDCODGRUPO: TIntegerField;
    tRelatoCDCODREL: TStringField;
    tRelatoCDSEGURANCA: TStringField;
    tRelatoCDDIREXPL: TStringField;
    qGruposAuxNumDfnINS: TADOQuery;
    qGruposAuxNumDfnUPD: TADOQuery;
    qGruposAuxNumDfnDEL: TADOQuery;
    qGruposAuxNumDfnSEL: TADOQuery;
    qGruposAuxNumDfnSELCODSIS: TIntegerField;
    qGruposAuxNumDfnSELNOMESIS: TStringField;
    qGruposAuxNumDfnSELCODGRUPO: TIntegerField;
    qGruposAuxNumDfnSELNOMEGRUPO: TStringField;
    qGruposAuxNumDfnSELCODAUXGRUPO: TIntegerField;
    qGruposAuxAlfaDfnINS: TADOQuery;
    qGruposAuxAlfaDfnUPD: TADOQuery;
    qGruposAuxAlfaDfnDEL: TADOQuery;
    qGruposAuxAlfaDfnSEL: TADOQuery;
    qGruposAuxAlfaDfnSELCODSIS: TIntegerField;
    qGruposAuxAlfaDfnSELNOMESIS: TStringField;
    qGruposAuxAlfaDfnSELCODGRUPO: TIntegerField;
    qGruposAuxAlfaDfnSELNOMEGRUPO: TStringField;
    qGruposAuxAlfaDfnSELCODAUXGRUPO: TStringField;
    qSubGruposDfnSEL: TADOQuery;
    qSubGruposDfnSELCODSIS: TIntegerField;
    qSubGruposDfnSELNOMESIS: TStringField;
    qSubGruposDfnSELCODGRUPO: TIntegerField;
    qSubGruposDfnSELNOMEGRUPO: TStringField;
    qSubGruposDfnSELCODSUBGRUPO: TIntegerField;
    qSubGruposDfnSELNOMESUBGRUPO: TStringField;
    qGruposDfnSEL: TADOQuery;
    qGruposDfnSELCODSIS: TIntegerField;
    qGruposDfnSELNOMESIS: TStringField;
    qGruposDfnSELCODGRUPO: TIntegerField;
    qGruposDfnSELCODGRUPOALFA: TStringField;
    qGruposDfnSELNOMEGRUPO: TStringField;
    tUsuarioCODUSUARIO: TStringField;
    tUsuarioSENHA: TStringField;
    tUsuarioREMOTO: TStringField;
    tGrupoUsuarios: TADOTable;
    tGrupoUsuariosNOMEGRUPOUSUARIO: TStringField;
    tGrupoUsuariosDESCRGRUPO: TStringField;
    tGrupoUsuariosOBSERVACAO: TStringField;
    tUsuariosEGrupos: TADOTable;
    tUsuariosEGruposCODUSUARIO: TStringField;
    tUsuariosEGruposNOMEGRUPOUSUARIO: TStringField;
    qUsuRel: TADOQuery;
    qUsuRelCODSIS: TIntegerField;
    qUsuRelNOMESIS: TStringField;
    qUsuRelCODGRUPO: TIntegerField;
    qUsuRelNOMEGRUPO: TStringField;
    qUsuRelCODSUBGRUPO: TIntegerField;
    qUsuRelNOMESUBGRUPO: TStringField;
    qUsuRelCODREL: TStringField;
    qUsuRelNOMEREL: TStringField;
    qUsuRelCODUSUARIO: TStringField;
    qGrupoRel: TADOQuery;
    qGrupoRelCODSIS: TIntegerField;
    qGrupoRelNOMESIS: TStringField;
    qGrupoRelCODGRUPO: TIntegerField;
    qGrupoRelNOMEGRUPO: TStringField;
    qGrupoRelCODSUBGRUPO: TIntegerField;
    qGrupoRelNOMESUBGRUPO: TStringField;
    qGrupoRelCODREL: TStringField;
    qGrupoRelNOMEREL: TStringField;
    qGrupoRelNOMEGRUPOUSUARIO: TStringField;
    tSistema: TADOTable;
    tSistemaCODSIS: TIntegerField;
    tSistemaNOMESIS: TStringField;
    tDfnCODREL: TStringField;
    tDfnNOMEREL: TStringField;
    tDfnCODSIS: TIntegerField;
    tDfnCODGRUPO: TIntegerField;
    tDfnCODSUBGRUPO: TIntegerField;
    tDfnIDCOLUNA1: TIntegerField;
    tDfnIDLINHA1: TIntegerField;
    tDfnIDSTRING1: TStringField;
    tDfnIDCOLUNA2: TIntegerField;
    tDfnIDLINHA2: TIntegerField;
    tDfnIDSTRING2: TStringField;
    tDfnDIRENTRA: TStringField;
    tDfnTIPOQUEBRA: TStringField;
    tDfnCOLQUEBRASTR1: TIntegerField;
    tDfnSTRQUEBRASTR1: TStringField;
    tDfnCOLQUEBRASTR2: TIntegerField;
    tDfnSTRQUEBRASTR2: TStringField;
    tDfnQUEBRAAFTERSTR: TStringField;
    tDfnNLINHASQUEBRALIN: TIntegerField;
    tDfnFILTROCAR: TStringField;
    tDfnCOMPRBRANCOS: TStringField;
    tDfnJUNCAOAUTOM: TStringField;
    tDfnQTDPAGSAPULAR: TIntegerField;
    tDfnCODGRUPAUTO: TStringField;
    tDfnCOLGRUPAUTO: TIntegerField;
    tDfnLINGRUPAUTO: TIntegerField;
    tDfnTAMGRUPAUTO: TIntegerField;
    tDfnTIPOGRUPAUTO: TStringField;
    tDfnBACKUPREL: TStringField;
    tDfnSUBDIRAUTO: TStringField;
    tDfnSTATUS: TStringField;
    tDfnDTCRIACAO: TDateField;
    tDfnHRCRIACAO: TTimeField;
    tDfnDTALTERACAO: TDateField;
    tDfnHRALTERACAO: TTimeField;
    tDfnREMOVE: TStringField;
    QueryEvento: TADOQuery;
    QueryEvento2: TADOQuery;
    QueryEvento3: TADOQuery;
    tUsuarioNOME: TStringField;
    Query03: TADOQuery;
    Query04: TADOQuery;
    QueryGrade: TADOQuery;
    logQuery: TADOQuery;
    Query05: TADOQuery;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function extraiCodigo(str: String): String;
  end;

var
  repositorioDeDados: TrepositorioDeDados;

implementation

uses criaConStr;

{$R *.dfm}

function TRepositorioDeDados.extraiCodigo(str: String): String;
begin
result := trim(Copy(str,1,Pos(' : ',str)));
end;

procedure TrepositorioDeDados.DataModuleDestroy(Sender: TObject);
begin
dbMulticold.Close;
end;

procedure TrepositorioDeDados.DataModuleCreate(Sender: TObject);
begin
dbMulticold.Open;
end;

end.
