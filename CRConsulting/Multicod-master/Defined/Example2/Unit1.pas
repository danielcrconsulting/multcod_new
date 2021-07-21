unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, HTTPApp, dfproducer, dfclasses,
  DSProd, jpeg, graphics;

type
  TWebModule1 = class(TWebModule)
    PageProducer1: TPageProducer;
    DFContentProducer1: TDFContentProducer;
    DFEngine1: TDFEngine;
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModule1WebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1WebActionItem2Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure PageProducer1HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: String; TagParams: TStrings;
      var ReplaceText: String);
    procedure DFContentProducer1PrepareForm(Sender: TObject);
  private
    ScriptName: String;
  public
  end;

var
  WebModule1: TWebModule1;

implementation

{$R *.DFM}

procedure TWebModule1.WebModuleCreate(Sender: TObject);
var
  FN: array[0..MAX_PATH-1] of char;
begin
  SetString(ScriptName, FN, GetModuleFileName(hInstance, FN, SizeOf(FN)));
  ScriptName := '../cgi-bin/'+ExtractFileName(ScriptName);
end;

procedure TWebModule1.WebModule1WebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := PageProducer1.Content;
  Handled:= True;
end;

procedure TWebModule1.WebModule1WebActionItem2Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := DFContentProducer1.Content;
end;

procedure TWebModule1.PageProducer1HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: String; TagParams: TStrings; var ReplaceText: String);
begin
  if TagString = 'Form' then
  begin
    Replacetext:= '<IMG SRC="'+ScriptName+'/getform'+
      '?page='+TagParams.values['Page']+
      '&scale='+TagParams.values['Scale']+
      '" Border=0">';
  end;
end;

procedure TWebModule1.DFContentProducer1PrepareForm(Sender: TObject);
begin
  DFEngine1.FieldByName('billto1').asstring:= 'Dynamic data here!';
end;

end.
