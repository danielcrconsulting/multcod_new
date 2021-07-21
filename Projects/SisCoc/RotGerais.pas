unit RotGerais;

interface

uses  Forms, Classes, Windows, ADODB, System.Types, IOUtils;

// *************************************************
// BrowseFolders
// -------------------------------------------------
// Purpose:  Displays a dialog with a tree view of
// file system folders from which a user
// may select a system folder.
// Inputs:   hWndParent  calling form
// sPrompt     instructions to display
// above the tree view
// ulFLags     flags to control the info
// displayed and/or returned
// Outputs:  None
// Returns:  The path of the selected directory
// Notes:    None
// *************************************************

const
  BIF_RETURNONLYFSDIRS = 1;
  BIF_DONTGOBELOWDOMAIN = 2;
//  MAX_PATH = 260;


type SYSTEMTIME = record
  wYear: Smallint;
  wMonth: Smallint;
  wDayOfWeek: Smallint;
  wDay: Smallint;
  wHour: Smallint;
  wMinute: Smallint;
  wSecond: Smallint;
  wMilliseconds: Smallint;

  //constructor Create();
end;
{constructor SYSTEMTIME.Create();
begin
  wYear:=0;  wMonth:=0;  wDayOfWeek:=0;  wDay:=0;  wHour:=0;
  wMinute:=0;  wSecond:=0;  wMilliseconds:=0;
end; }

 function GetPrivateProfileString(lpApplicationName: String; lpKeyName: String; lpDefault: String; lpReturnedString: String; nSize: Longint; lpFileName: String): Longint; stdcall; external kernel32 name 'GetPrivateProfileStringA';
 function MultiExtract(PathNomeRel: String; PathNomeXtg: String; PathNomeArquivo: String): Smallint; stdcall; external 'MultiColdExtract.DLL' name 'MultiExtract';
 function GetUserName(lpBuffer: String; var nSize: Longint): Longint; stdcall; external advapi32 name 'GetUserNameA';
 procedure GetSystemTime(var lpSystemTime: SYSTEMTIME); stdcall; external kernel32 name 'GetSystemTime';
 function GetSystemMetrics(nIndex: Smallint): Smallint; stdcall; external 'User32.DLL' name 'GetSystemMetrics';
// function BrowseFolders(hWndParent: Longint; sPrompt: String; ulFLags: Longint): String;
// function GetDir(myForm: frmGeraMov): String;
// function GetPar(sArquivo: String; sSecao: String; sParametro: String): String;
 procedure CenterTop(f: TForm);
 procedure CenterForm(f: TForm);
 function Conecta(var AdoConnection : TAdoConnection; ConnectionStr : String): Boolean;
// procedure Desconecta();
 function NomeDoMes(Mes: String): String;
 function UserName(): String;
 function DataDoSistema(): TDateTime;
 function MeuComputador(): String;
 function UltimoDiaDoMes(Mes: String): String;
 function TrocaGenerico(S: String; Isso: String; Por: String): String;
 function moveArquivo(arqDe: String; arqPara: String): Boolean;
 function tiraTrailerArq(Arq: String): String;
 function pegaPath(Arq: String): String;
 function pegaNomeArq(Arq: String): String;
 Procedure moveRelMulticold(arqDe: String);
 function getDataFronNomeArq(Arq: String): String;
 function ConverteMes: OleVariant;
 function getNroMes(sMes: String): String;

implementation

uses  Dialogs, SysUtils, StrUtils, Module1, frmMain_, VBto_Converter, FileHandles;
// ***************************************
// * Definição de chamada de DLL Externa *
// ***************************************


// Public Declare Function MultiExtract Lib "MultiColdExtract_sn" (ByVal PathNomeRel As String, ByVal PathNomeXtg As String, ByVal PathNomeArquivo As String) As Integer


// Public Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long


// ==========================================
// Folder Browsing Functions and Constants
// ==========================================
//function SHBrowseForFolder(var lpbi: BrowseInfo): Longint; stdcall; external 'shell32.DLL' name 'SHBrowseForFolder';
//function SHGetPathFromIDList(pidList: Longint; lpBuffer: String): Longint; stdcall; external 'shell32.DLL' name 'SHGetPathFromIDList';
//function lstrcat(lpString1: String; lpString2: String): Longint; stdcall; external kernel32 name 'lstrcatA';

{type BrowseInfo = record
  hWndOwner: Longint;
  pIDLRoot: Longint;
  pszDisplayName: Longint;
  lpszTitle: Longint;
  ulFLags: Longint;
  lpfnCallback: Longint;
  lParam: Longint;
  iImage: Longint;

  //constructor Create();
end;
{constructor BrowseInfo.Create();
begin
  hWndOwner:=0;  pIDLRoot:=0;  pszDisplayName:=0;  lpszTitle:=0;
  ulFLags:=0;  lpfnCallback:=0;  lParam:=0;  iImage:=0;
end; }

//==============================================================

{function BrowseFolders(hWndParent: Longint; sPrompt: String; ulFLags: Longint): String;
var
  lpIDList: Longint;
  sBuffer: String;
  tBrowseInfo: BrowseInfo;
begin
  with tBrowseInfo do begin
    hWndOwner := hWndParent;
    lpszTitle := lstrcat(sPrompt, '');
    ulFLags := ulFLags;
  end;

  lpIDList := SHBrowseForFolder(tBrowseInfo);

  if 0<>(lpIDList) then begin
    sBuffer := StringOfChar(' ', MAX_PATH);
    SHGetPathFromIDList(lpIDList, sBuffer);
    sBuffer := LeftStr(sBuffer, Pos(#0, sBuffer)-1);
    Result := sBuffer;
   end  else  begin
    Result := '';
  end;
end;
}
// VBto upgrade warning: myForm As Form --> As frmGeraMov
{function GetDir(myForm: frmGeraMov): String;
var
  NewFolder: String;
begin
  // On Error GoTo ImageBrowse_Error

  NewFolder := BrowseFolders(handle, 'Selecione o Diretório', BIF_RETURNONLYFSDIRS);

  Result := '';
  if NewFolder<>'' then begin
    Result := NewFolder;
  end;
end;

function GetPar(sArquivo: String; sSecao: String; sParametro: String): String;
var
  sRetorno: String;
  iRetorno: Longint;
begin


  // String de Retorno
  // Retorno da Chamada da Função ( 0 = False, 1 = True )

  sRetorno := StringOfChar(' ', 40);
  iRetorno := GetPrivateProfileString(sSecao, sParametro, '', sRetorno, Length(sRetorno)-1, sArquivo);

  if iRetorno=0 then begin
    // ****************************
    // * Retorno False da Chamada *
    // ****************************
    sRetorno := '';
   end  else  begin
    // ***************************
    // * Retorno True da Chamada *
    // ***************************
    sRetorno := Trim(sRetorno);
    sRetorno := LeftStr(sRetorno, (1+Pos(Char(0), PChar(sRetorno)+1))-1);
  end;

  Result := sRetorno;
end;                  }

procedure CenterTop(f: TForm);
begin
  f.Top := 0;
  f.Left := Round((fMainForm.Width-f.Width)/2);
end;

// VBto upgrade warning: f As Form  OnWrite(SimulaMenu, atMoeda, Consulta, DataLimite, frmJuncao, frmLog, frmGeraMov, Alterar1Manual, frmAgenda, frmAgenda1, frmUsuario, frmAltUsuario, frmBaixaBanco, frmRelease, AlterarManual, ConsultaCon, Alterar_Consulta, Historico, frmBIN, frmPath, ConsultaCvMes)
procedure CenterForm(f: TForm);
begin
  f.Top := Round((fMainForm.Height-f.Height)/2);
  f.Left := Round((fMainForm.Width-f.Width)/2);
end;

function Conecta(var AdoConnection : TAdoConnection; ConnectionStr : String): Boolean;

begin

Result := true;

Try
  If Not Assigned(ADOConnection) Then
    AdoConnection := TAdoConnection.Create(nil);

  if ADOConnection.Connected then
    Exit;

  ADOConnection.ConnectionString := 'FILE NAME=' + ConnectionStr;
  ADOConnection.LoginPrompt := False;
  ADOConnection.Connected := True;
  bConectado := true;
except
    Application.ProcessMessages;
    ShowMessage('Banco de Dados não esta disponível ou Acesso não Permitido');
    ShowMessage('Banco: '+ ConnectionStr);
    Result := false;
  end; // Try
End;

(*procedure Desconecta();
begin
  if  not bConectado then begin
    // Exit Sub
  end;
   {? On Error Resume Next  }
  RsDb.Close();
  RsDb := nil;
  gBanco.Close();
  gBanco := nil;
  gWork.Close();
  // Set gWork = Nothing
  bConectado := false;
end; *)

// VBto upgrade warning: Mes As String  OnWrite(Longint)

function NomeDoMes(Mes: String): String;
begin
  Result := '';
  case StrToInt(Mes) of
    1: begin
      Result := 'Janeiro';
    end;
    2: begin
      Result := 'Fevereiro';
    end;
    3: begin
      Result := 'Março';
    end;
    4: begin
      Result := 'Abril';
    end;
    5: begin
      Result := 'Maio';
    end;
    6: begin
      Result := 'Junho';
    end;
    7: begin
      Result := 'Julho';
    end;
    8: begin
      Result := 'Agosto';
    end;
    9: begin
      Result := 'Setembro';
    end;
    10: begin
      Result := 'Outubro';
    end;
    11: begin
      Result := 'Novembro';
    end;
    12: begin
      Result := 'Dezembro';
    end;
  end;
end;

function UserName(): String;
var
  sBuffer: String;
  lSize: Longint;
begin
  sBuffer := StringOfChar(' ', 255);
  lSize := Length(sBuffer);
  GetUserName(sBuffer, lSize);
  if lSize>0 then begin
    Result := LeftStr(sBuffer, lSize-1);
   end  else  begin
    Result := '';
  end;

end;

// VBto upgrade warning: 'Return' As TDateTime  OnWrite(String)
function DataDoSistema(): TDateTime;
var
  S: String;
begin
  GetSystemTime(DataSis);

  with DataSis do begin
    S := FormatVB(wDay,'0#')+'/'+FormatVB(wMonth,'0#')+'/'+FormatVB(wYear,'000#');
  end;
  Result := StrToDateTime(FormatVB(S,'DD/MM/YYYY'));
end;

function MeuComputador(): String;
var
  sBuffer: String;
  lSize: Longint;
begin

  sBuffer := StringOfChar(' ', 255);
  lSize := Length(sBuffer);
  GetComputerName(sBuffer, lSize);
  if lSize>0 then begin
    Result := LeftStr(sBuffer, lSize);
   end  else  begin
    Result := '';
  end;

end;

function UltimoDiaDoMes(Mes: String): String;
begin
  Result := '';
  case StrToInt(Mes) of
    
    1: begin
      Result := '31';
    end;
    2: begin
      Result := '28';
    end;
    3: begin
      Result := '31';
    end;
    4: begin
      Result := '30';
    end;
    5: begin
      Result := '31';
    end;
    6: begin
      Result := '30';
    end;
    7: begin
      Result := '31';
    end;
    8: begin
      Result := '31';
    end;
    9: begin
      Result := '30';
    end;
    10: begin
      Result := '31';
    end;
    11: begin
      Result := '30';
    end;
    12: begin
      Result := '31';
    end;
  end;
end;

function TrocaGenerico(S: String; Isso: String; Por: String): String;
var
  I: Smallint;
begin
  Result := '';
  I := 1;
  while I<=Length(S) do begin
    if Copy(S, I, 1)=Isso then begin
      Result := Result+Por;
     end  else  begin
      Result := Result+Copy(S, I, 1);
    end;
    I := I+1;
  end;
end;

function moveArquivo(arqDe: String; arqPara: String): Boolean;
label
  Erro;
begin

  Result := false;

  try  // On Error GoTo Erro
    if FileExists(arqDe) then
      begin
      CopyFile(PChar(arqDe), PChar(arqPara), false);
      DeleteFile(arqDe);
      Result := true;
      End
    else
      ShowMessage('Arquivo não encontrado: '+arqDe);
  except on E:Exception do  // Erro:
    ShowMessage(E.Message);
  end;
end;

function tiraTrailerArq(Arq: String): String;
var
  I: Longint;
begin
  Result := '';
  I := (1+Pos('_', PChar(Arq)+1));
  if I>0 then begin
    I := Length(Arq);
    while Copy(Arq, I, 1)<>'_' do begin
      I := I-1;
    end;
    Result := Copy(Arq, 1, I-1);
  end;
end;

function pegaPath(Arq: String): String;
var
  I: Longint;
begin
  Result := '';
  I := (1+Pos('\', PChar(Arq)+1));
  if I>0 then begin
    I := Length(Arq);
    while Copy(Arq, I, 1)<>'\' do begin
      I := I-1;
    end;
    Result := Copy(Arq, 1, I-1)+'\';
  end;

end;

function pegaNomeArq(Arq: String): String;
var
  I: Longint;
begin
  Result := '';
  I := (1+Pos('\', PChar(Arq)+1));
  if I>0 then begin
    I := Length(Arq);
    while Copy(Arq, I, 1)<>'\' do begin
      I := I-1;
    end;
    Result := Copy(Arq, I-1, Length(Arq));
  end;

end;

Procedure moveRelMulticold(arqDe: String);
var
  Arquivo, pathArqDe: String;
  DynArray: TStringDynArray;
  I : Integer;
begin
  try  // On Error GoTo Erro
    // Pega nome arquivo sem trailer(ate ultimo "_"
    if Not FileExists(arqDe) then
      begin
      ShowMessage('Arquivo não encontrado: '+arqDe);
      Exit;
      end;
//    Arquivo := tiraTrailerArq(arqDe)+'*';
    Arquivo := tiraTrailerArq(arqDe);
    pathArqDe := pegaPath(Arquivo);
//    ArquivoMove := Dir(Arquivo);
    DynArray := TDirectory.GetFiles(Arquivo, '*', TSearchOption.soTopDirectoryOnly);
//    while ArquivoMove<>'' do
    for I := Low(DynArray) to High(DynArray) do
      begin
//      if not moveArquivo(pathArqDe+ArquivoMove, pathArqDe+'\Bkp_Rel_ComTemplate\'+ArquivoMove) then
      if not moveArquivo(DynArray[I], pathArqDe+'\Bkp_Rel_ComTemplate\'+ExtractFileName(DynArray[I])) then
        begin
        ShowMessage('Erro');
        Exit;
        end;
//      ArquivoMove := Dir(Arquivo);
      end;
  except  on E:Exception do// Erro:
    ShowMessage('Move Rel Multicold: '+E.Message);
    { Resume Next }
  end;
end;

function getDataFronNomeArq(Arq: String): String;
var
  I: Smallint;
  S: String;
begin
  Result := '';
  I := 1;
  S := Copy(Arq, I, 1);
  while S<>'_' do begin
    I := I+1;
    S := Copy(Arq, I, 1);
  end;
  I := I+1; // Era 2
  S := Copy(Arq, I, 1);

  while S<>'_' do begin
    Result := Result+S;
    I := I+1;
    S := Copy(Arq, I, 1);
  end;

end;

function ConverteMes: OleVariant;
var
  sNomeRel, sNomeMes, sNroMes, pathRel, Arquivo, BufferIn, BufferOut: String;
  ArqEntrada, ArqSaida: System.Text;
  I,
  posData, tamData: Integer;
  gBanco : TAdoConnection;
  RsDb : TAdoDataSet;
  DynArray: TStringDynArray;
begin

if not Conecta(gBanco, ExtractFileDir(Application.ExeName) + '\admin.udl') then
  Exit;

RsDb := TAdoDataSet.Create(nil);
RsDb.Connection := gBanco;

sSql := 'select * from tbConvMes';
//  RsDb := gBanco.OpenRecordset(sSql);

RsDb.CommandText := sSql;
RsDb.Open;

if RsDb.EOF then
  begin
  gBanco.Close;
  RsDb.Close;
  gBanco.Free;
  RsDb.Free;
  Exit;
  end;

sSql := '';
PegaPar;
posData := Param.Data.Posicao;
tamData := Param.Data.Tamanho;

while Not RsDb.Eof do
//  with RsDb do
  begin
//    pathRel := GetPath+'\Relatorios_Gerados\';
  pathRel := ExtractFileDir(Application.ExeName) + '\Relatorios_Gerados\';

  sNomeRel := String(RsDb.FieldByName('Relatorio').Value); //+'*';

    //Arquivo := Dir(pathRel+sNomeRel);
  DynArray := TDirectory.GetFiles(PathRel+sNomeRel, '*', TSearchOption.soTopDirectoryOnly);

{    pRel := 0;
    while Arquivo<>'' do
      begin
      ReDimPreserve(Relat, pRel+1);
      Relat[pRel] := Arquivo;
      pRel := pRel+1;
      Arquivo := Dir();
      end;

    ReDimPreserve(Relat, pRel+1);
    Relat[pRel] := '';              }

//    pRel := 0;
//    Arquivo := Relat[pRel];

  OutputDebugString(DynArray[0]);

//Do While Not .EOF And Arquivo <> ""

  for I := Low(DynArray) to High(DynArray) do
    Begin
    Arquivo := DynArray[I];  // Por questões de compatibilidade adiante
    RenameFile(pathRel+Arquivo, pathRel+Arquivo+'.bak');
    AssignFile(ArqEntrada, pathRel+Arquivo+'.bak');
    Reset(ArqEntrada);
    AssignFile(ArqSaida, pathRel+Arquivo);
    Rewrite(ArqSaida);
    while not Eof(ArqEntrada) do
      begin
      ReadLn(ArqEntrada, BufferIn);
      sNomeMes := Copy(BufferIn, posData+2, 3);
      sNroMes := getNroMes(sNomeMes);
      if sNroMes='  ' then
        BufferOut := BufferIn
      else
        begin
        BufferOut := Copy(BufferIn, 1, posData+1)+'/';
        BufferOut := BufferOut+sNroMes;
        BufferOut := BufferOut+'/'+Copy(BufferIn, posData+tamData-2, Length(BufferIn)-(posData+tamData-2));
        end;
      WriteLn(ArqSaida, BufferOut);
      end;
    CloseFile(ArqEntrada);
    DeleteFile(pathRel+Arquivo+'.bak');
    CloseFile(ArqSaida);
    end;

  RsDb.Next;
  End;

gBanco.Close;
RsDb.Close;
gBanco.Free;
RsDb.Free;

end;

function getNroMes(sMes: String): String;
begin
  Result := '  ';

  
  if AnsiUpperCase(sMes)='JAN' then begin
    Result := '01';
  end
  else if AnsiUpperCase(sMes)='FEB' then begin
    Result := '02';
  end
  else if AnsiUpperCase(sMes)='MAR' then begin
    Result := '03';
  end
  else if AnsiUpperCase(sMes)='APR' then begin
    Result := '04';
  end
  else if AnsiUpperCase(sMes)='MAY' then begin
    Result := '05';
  end
  else if AnsiUpperCase(sMes)='JUN' then begin
    Result := '06';
  end
  else if AnsiUpperCase(sMes)='JUL' then begin
    Result := '07';
  end
  else if AnsiUpperCase(sMes)='AUG' then begin
    Result := '08';
  end
  else if AnsiUpperCase(sMes)='SEP' then begin
    Result := '09';
  end
  else if AnsiUpperCase(sMes)='OCT' then begin
    Result := '10';
  end
  else if AnsiUpperCase(sMes)='NOV' then begin
    Result := '11';
  end
  else if AnsiUpperCase(sMes)='DEC' then begin
    Result := '12';
  end;
end;



end.
