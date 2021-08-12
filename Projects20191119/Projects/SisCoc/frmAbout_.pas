unit frmAbout_;

interface

uses  Forms, Classes, Controls, StdCtrls, ExtCtrls, Windows, Graphics;


const
  KEY_ALL_ACCESS = $2003F;
//  HKEY_LOCAL_MACHINE = $80000002;
  ERROR_SUCCESS = 0;
  REG_SZ = 1;
  REG_DWORD = 4;
  gREGKEYSYSINFOLOC = 'SOFTWARE\Microsoft\Shared Tools Location';
  gREGVALSYSINFOLOC = 'MSINFO';
  gREGKEYSYSINFO = 'SOFTWARE\Microsoft\Shared Tools\MSINFO';
  gREGVALSYSINFO = 'PATH';

type
  TfrmAbout = class(TForm)
    lblDisclaimer:  TLabel;
    lblVersion:  TLabel;
    Line1_0:  TShape;
    Line1_1:  TShape;
    lblTitle:  TLabel;
    lblDescription:  TLabel;
    cmdOK:  TButton;
    picIcon:  TImage;

    procedure FormShow(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

    Line1:  array[0..1] of TShape;  // Control array

  end;

var
  frmAbout: TfrmAbout;

implementation

uses  SysUtils, StrUtils, VBto_Converter;

{$R *.dfm}

procedure GetBuildInfo(var V1, V2, V3, V4: word);
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize > 0 then
  begin
      GetMem(VerInfo, VerInfoSize);
      try
        if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
        begin
          VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
          with VerValue^ do
          begin
            V1 := dwFileVersionMS shr 16;
            V2 := dwFileVersionMS and $FFFF;
            V3 := dwFileVersionLS shr 16;
            V4 := dwFileVersionLS and $FFFF;
          end;
        end;
      finally
        FreeMem(VerInfo, VerInfoSize);
      end;
  end;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
Var
  V1, V2, V3, V4: word;
begin
//  lblVersion.Caption := 'Version '+String(Application. .Major)+'.'+String(App.Minor)+'.'+String(App.Revision);
  GetBuildInfo(V1, V2, V3, V4);
  lblVersion.Caption := 'Version ' + IntToStr(V1)+'.'+IntToStr(V2)+'.'+IntToStr(V3)+'.'+IntToStr(V4);
  lblTitle.Caption := Application.Title;
end;

procedure TfrmAbout.cmdOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  ZeroMemory(@Line1, SizeOf(Line1));
  Line1[1] := Line1_1;
  Line1[0] := Line1_0;
end;

end.
