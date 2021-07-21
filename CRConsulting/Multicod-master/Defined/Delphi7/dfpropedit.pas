
{*******************************************************}
{                                                       }
{       Defined Forms                                   }
{       Open/Save/Clear Dialog                          }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit dfpropedit;

interface

{$I DEFINEDFORMS.INC}

uses
  Windows, Classes, Graphics, Forms, Controls, Dialogs, Buttons,
  StdCtrls, ExtCtrls, ExtDlgs, dfcontrols, dfclasses, dfutil, dfconvert
  {$IFDEF D6_PLUS},DesignIntf,DesignEditors{$ELSE},DsgnIntf{$ENDIF};

type

{ TDFOpenDialog }

  TDFOpenDialog = class(TForm)
    OKButton: TButton;
    CancelButton: TButton;
    HelpButton: TButton;
    GroupBox1: TGroupBox;
    ImagePanel: TPanel;
    Load: TButton;
    Save: TButton;
    Clear: TButton;
    DFDisplay: TDFDisplay;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    DFEngine: TDFEngine;
    procedure ButtonClick(Sender: TObject);
    function Execute: boolean;
  end;

{ TDFComponentEditor }

  TDFComponentEditor = class(TDefaultEditor)
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer) : string; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;
    procedure OpenEditor;
  end;

{ TDFPropertyEditor }

  TDFPropertyEditor = class(TPropertyEditor)
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
    function GetValue : string; override;
  end;

procedure Register;

implementation

uses dfdesigner;

procedure Register;
begin
  RegisterComponentEditor(TDFEngine, TDFComponentEditor);
  RegisterPropertyEditor(typeinfo(TDFForm), nil, 'Form', TDFPropertyEditor);
end;

{$R *.DFM}

{ TDFOpenDialog }

procedure TDFOpenDialog.ButtonClick(Sender: TObject);
begin
  if Sender = Load then
    if OpenDialog1.Execute then
      dfOpenFile(DFEngine, OpenDialog1.Filename);

  if Sender = Save then
    if SaveDialog1.Execute then
      dfSaveFile(DFEngine, SaveDialog1.Filename);

  if Sender = Clear then
    DFEngine.Clear;
end;

function TDFOpenDialog.Execute: boolean;
begin
  result:= showmodal = mrOK;
end;

{ TDFComponentEditor }

function TDFComponentEditor.GetVerbCount : Integer;
begin
  Result := 7;
end;

function TDFComponentEditor.GetVerb( Index : Integer ) : string;
begin
  case Index of
    0: Result := 'Open/Save/Clear';
    1: Result := 'Edit';
    2: Result := 'Preview';
    3: Result := 'Print';
    4: Result := 'Print Layout';
    5: Result := 'Write to clipboard';
    6: Result := 'Read from clipboard';
    end;
end;

procedure TDFComponentEditor.ExecuteVerb( Index : Integer );
begin
  case Index of
    0: Edit;
    1: OpenEditor;
    2: (Component as TDFEngine).PrintPreview;
    3: begin
         (Component as TDFEngine).PrintDesigner:= false;
         (Component as TDFEngine).Print;
       end;
    4: begin
         (Component as TDFEngine).PrintDesigner:= true;
         (Component as TDFEngine).Print;
         (Component as TDFEngine).PrintDesigner:= false;
       end;
    5: (Component as TDFEngine).SaveToClipBoard;
    6: (Component as TDFEngine).LoadfromClipBoard;
  end;
end;

procedure TDFComponentEditor.Edit;
var Dialog: TDFOpenDialog;
begin
  if Component is TDFEngine then
  begin
    Dialog:= TDFOpenDialog.create(Application);
    try
      Dialog.OpenDialog1.Filter:= FILETYPES_OPEN;
      Dialog.SaveDialog1.Filter:= FILETYPES_SAVE;
      Dialog.DFEngine.Assign( TDFEngine(component) );
      if Dialog.Execute then
      begin
        TDFEngine(component).Assign( Dialog.DFEngine );
        Designer.Modified;
      end;
    finally
      Dialog.Free;
    end;
  end;
end;

procedure TDFComponentEditor.OpenEditor;
begin
  fmDFDesigner:= TfmDFDesigner.create(nil);
  try
    if fmDFDesigner.Execute(TDFEngine(component), true) then
    begin
      Designer.Modified;
    end;
  finally
    fmDFDesigner.free;
  end;
end;

{ TDFPropertyEditor }

function TDFPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TDFPropertyEditor.GetValue: string;
begin
  Result := '(DefinedForm)';
end;

procedure TDFPropertyEditor.Edit;
var Dialog: TDFOpenDialog;
begin
  if (GetOrdValue <> 0) and (TDFForm(GetOrdValue).Engine <> nil) then
  begin
    Dialog:= TDFOpenDialog.create(Application);
    try
      Dialog.OpenDialog1.Filter:= FILETYPES_OPEN;
      Dialog.SaveDialog1.Filter:= FILETYPES_SAVE;
      Dialog.DFEngine.Assign(TDFForm(GetOrdValue).Engine);
      if Dialog.Execute then
      begin
        TDFForm(GetOrdValue).Engine.Assign(Dialog.DFEngine);
        Designer.Modified;
      end;
    finally
      Dialog.Free;
    end;
  end;
end;

end.
