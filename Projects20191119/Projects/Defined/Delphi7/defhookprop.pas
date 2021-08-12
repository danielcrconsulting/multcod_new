
{*******************************************************}
{                                                       }
{       Defined Hook                                    }
{       Property Editor                                 }
{                                                       }
{       Copyright (c) 2000 Defined Systems Inc.         }
{                                                       }
{*******************************************************}

unit defhookprop;

interface

{$I DEFINEDSTREAM.INC}

uses
  Windows, Classes, Graphics, Forms, Controls, Dialogs, Buttons,
  StdCtrls, ExtCtrls, ExtDlgs, SysUtils, ComCtrls, Menus, ImgList,
  typinfo, clipbrd {$IFDEF D6_PLUS},DesignIntf,DesignEditors{$ELSE},DsgnIntf{$ENDIF};

const
  Supported_Controls =
    'TEdit,TdsEdit,TMemo,TdsMemo,TCombobox,TdsComboBox,'+
    'TCheckbox,TdsCheckbox,TRadiobutton,'+
    'TListview,TdsListview';

type

{ TdlgDefHook }

  TdlgDefHook = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    Fields: TTreeView;
    Map: TListView;
    Label3: TLabel;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    Label1: TLabel;
    btnProp: TSpeedButton;
    PopupMenu1: TPopupMenu;
    pAdd: TMenuItem;
    pDelete: TMenuItem;
    pProp: TMenuItem;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    N1: TMenuItem;
    pMoveUp: TMenuItem;
    pMoveDown: TMenuItem;
    ImageList1: TImageList;
    ImageList2: TImageList;
    btnAuto: TSpeedButton;
    pAuto: TMenuItem;
    btnClear: TSpeedButton;
    pClear: TMenuItem;
    procedure ButtonClick(Sender: TObject);
    procedure FieldsEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure MapEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure MapDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure MapDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure MapColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FieldsDblClick(Sender: TObject);
  private
    procedure AddClass(aclass: TClass);
    function CheckFieldPath(path: string): boolean;
  public
    Root: TClass;
    Form: TCustomForm;
    Strings: TStringlist;
    function Execute: boolean;
  end;

{ TObjHookComponentEditor }

  TObjHookComponentEditor = class(TDefaultEditor)
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer) : string; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;
    procedure GenerateClass;
    procedure DoCreateClass(CName: string; Src, Dest: TStrings);
  end;

procedure Register;

implementation

uses defstream, defhook;

procedure Register;
begin
  RegisterComponentEditor(TDefinedHook, TObjHookComponentEditor);
end;

{$R *.DFM}

{ TDFComponentEditor }

function TObjHookComponentEditor.GetVerbCount : Integer;
begin
  Result := 2;
end;

function TObjHookComponentEditor.GetVerb( Index : Integer ) : string;
begin
  case Index of
    0: Result := 'Hook Editor';
    1: Result := 'Generate Class to Clipboard';
  end;
end;

procedure TObjHookComponentEditor.ExecuteVerb( Index : Integer );
begin
  case Index of
    0: Edit;
    1: GenerateClass;
  end;
end;

procedure TObjHookComponentEditor.Edit;
var Dialog: TdlgDefHook;
begin
  if Component is TDefinedHook then
  begin
    Dialog:= TdlgDefHook.create(Application);
    try
      if TDefinedHook(Component).Owner = nil then Exit;
      if TDefinedHook(Component).DataClass = '' then Exit;
      //get root class
      Dialog.Root:= FindClass(TDefinedHook(Component).DataClass);
      //get form
      Dialog.Form:= TCustomForm(TDefinedHook(Component).Owner);
      //get existing hooks
      Dialog.Strings.Assign(TDefinedHook(Component).Data);
      if Dialog.Execute then
      begin
        TDefinedHook(Component).Data.assign(Dialog.Strings);
        Designer.Modified;
      end;
    finally
      Dialog.Free;
    end;
  end;
end;

procedure TObjHookComponentEditor.GenerateClass;
var
  tmpstr: string;
  Form: TCustomForm;
  Stream1, Stream2: TMemoryStream;
  Strings1, Strings2: TStringlist;
begin
  Form := TDefinedHook(Component).Owner as TCustomForm;
  if Form = nil then Exit;
  tmpstr := Form.ClassName+'_Class';
  if not inputquery('Generate New Class', 'Enter Class Name:', tmpstr) then Exit;
  Stream1:= TMemoryStream.create;
  Stream2:= TMemoryStream.create;
  Strings1:= TStringlist.create;
  Strings2:= TStringlist.create;
  try
    Stream1.WriteComponent(Form);
    Stream1.seek(0,0);
    ObjectBinaryToText(Stream1, Stream2);
    Stream2.seek(0,0);
    Strings1.loadfromstream(Stream2);
    DoCreateClass(tmpstr, Strings1, Strings2);
    Clipboard.astext := Strings2.text;
  finally
    Stream1.free;
    Stream2.free;
    Strings1.free;
    Strings2.free;
  end;
end;

procedure TObjHookComponentEditor.DoCreateClass(CName: string; Src, Dest: TStrings);
var
  SL: TStringList;
  I,J,K: integer;
  tmpstr, format: string;

  function nameonly(S: string): string;
  var x: integer;
  begin
    x:= pos (':',S);
    if X = 0 then
      result:= S
    else
      result:= system.copy(S,1,x-1);
  end;

  function typeonly(S: string): string;
  var x: integer;
  begin
    x:= pos (':',S);
    if X = 0 then
      result:= S
    else
      result:= system.copy(S,x+2,255);
  end;

  function CasePos(Sub, S : string): smallint;
  begin
    Sub:= Lowercase(Sub);
    S:= Lowercase(S);
    Result:= Pos(Sub,S);
  end;

begin
  SL := TStringList.create;
  try
    for I:= 0 to Src.count-1 do
    begin
      J:= pos('object ', Src[I]);
      if J > 0 then
      begin
        tmpstr:= system.copy(Src[I],J+7,255);
        if (casepos('dsedit', tmpstr)>0) then
        begin
          format:= '';
          for K:= I to Src.count-1 do
          begin
            J:= casepos('format =', Src[K]);
            if J > 0 then
              format:= lowercase(system.copy(Src[K],J+9,255));
            if casepos('taborder =', Src[K]) > 0 then break;
          end;
          if format = 'fointeger' then
            tmpstr:= stringreplace(tmpstr, ': TdsEdit', ': integer', [rfreplaceall, rfIgnoreCase])
          else if (format = 'foreal') or (format = 'fodollar') or (format = 'fopercent') or (format = 'fopctNS') then
            tmpstr:= stringreplace(tmpstr, ': TdsEdit', ': double', [rfreplaceall, rfIgnoreCase])
          else if (format = 'fodate') or (format = 'fofulldate') or (format = 'foshortdate') or (format = 'foshort4date') then
            tmpstr:= stringreplace(tmpstr, ': TdsEdit', ': TDatetime', [rfreplaceall, rfIgnoreCase])
          else
            tmpstr:= stringreplace(tmpstr, ': TdsEdit', ': string', [rfreplaceall, rfIgnoreCase]);

          SL.add( tmpstr );
        end

        else if (casepos('tedit', tmpstr)>0) or
           (casepos('combo', tmpstr)>0) or
           (casepos('check', tmpstr)>0) or
           (casepos('radio', tmpstr)>0) or
           (casepos('memo', tmpstr)>0) then
        begin
          tmpstr:= stringreplace(tmpstr, ': TEdit', ': string', [rfreplaceall, rfIgnoreCase]);
          tmpstr:= stringreplace(tmpstr, ': TComboBox', ': string', [rfreplaceall, rfIgnoreCase]);
          tmpstr:= stringreplace(tmpstr, ': TdsComboBox', ': string', [rfreplaceall, rfIgnoreCase]);
          tmpstr:= stringreplace(tmpstr, ': TMemo', ': string', [rfreplaceall, rfIgnoreCase]);
          tmpstr:= stringreplace(tmpstr, ': TdsMemo', ': string', [rfreplaceall, rfIgnoreCase]);
          tmpstr:= stringreplace(tmpstr, ': TCheckbox', ': boolean', [rfreplaceall, rfIgnoreCase]);
          tmpstr:= stringreplace(tmpstr, ': TdsCheckbox', ': boolean', [rfreplaceall, rfIgnoreCase]);
          tmpstr:= stringreplace(tmpstr, ': TRadioButton', ': boolean', [rfreplaceall, rfIgnoreCase]);
          SL.add( tmpstr );
        end;
      end;
    end;

    SL.Sort;

    Dest.Clear;
    Dest.add('type');
    Dest.add('');
    Dest.add('  '+CName+' = class;');
    Dest.add('');
    Dest.add('  '+CName+' = class(TDefinedStream)');
    Dest.add('  private');
    for I:= 0 to SL.count-1 do
      Dest.add('    F'+SL[I]+';');
    Dest.add('  published');
    for I:= 0 to SL.count-1 do
      Dest.add('    property '+SL[I]+' read F'+nameonly(SL[I])+' write F'+nameonly(SL[I])+';');
    Dest.add('  end;');
    Dest.add('');
    Dest.add('initialization');
    Dest.add('');
    Dest.add('  RegisterClass('+CName+');');

(*
    Dest.add('');
    Dest.add('procedure GetData;');
    Dest.add('begin');
    for I:= 0 to SL.count-1 do
    begin
      Dest.add(cpadr('  '+nameonly(SL[I])+'.'+typeonly(SL[I]),30)+' := AObject.'+nameonly(SL[I])+';');
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.string    ', '.text      ', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.boolean   ', '.checked   ', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.integer   ', '.asinteger ', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.tdatetime ', '.asdatetime', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.double    ', '.asdouble  ', Dest[Dest.count-1], false);
    end;
    Dest.add('end;');

    Dest.add('');
    Dest.add('procedure PutData;');
    Dest.add('begin');
    for I:= 0 to SL.count-1 do
    begin
      Dest.add(cpadr('  AObject.'+nameonly(SL[I]),30)+' := '+nameonly(SL[I])+'.'+typeonly(SL[I])+';');
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.string', '.text', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.boolean', '.checked', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.integer', '.asinteger', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.tdatetime', '.asdatetime', Dest[Dest.count-1], false);
      Dest[Dest.count-1]:= stringreplace(tmpstr, '.double', '.asdouble', Dest[Dest.count-1], false);
    end;
    Dest.add('end;');
*)
  finally
    SL.free;
  end;
end;




{ TdlgDefHook }

procedure TdlgDefHook.FormCreate(Sender: TObject);
begin
  Strings:= TStringlist.create;
end;

procedure TdlgDefHook.FormDestroy(Sender: TObject);
begin
  Strings.free;
end;

function TdlgDefHook.Execute: boolean;
var I,J: integer;
    Comp: TComponent;
begin
  //fill field tree, recursively
  Fields.Items.beginupdate;
  AddClass(Root);
  Fields.Items.endupdate;
//  Fields.savetofile('C:\Fields.txt');
  if Fields.Items.count > 1 then
  begin
    Fields.selected:= Fields.items[1];
    Fields.Items[0].Expand(false);
  end;  
  //fill components listview
  for I:= 0 to Form.ComponentCount-1 do
  begin
    Comp:= Form.Components[I];
    if pos( lowercase(Comp.Classname), lowercase(Supported_Controls))>0 then
    begin
      Map.items.add;
      Map.items[Map.items.count-1].Caption:= Comp.Name;
      Map.items[Map.items.count-1].Data:= Comp;
      if lowercase(Comp.Classname) = 'tedit' then
        Map.items[Map.items.count-1].imageindex:= 0;
      if lowercase(Comp.Classname) = 'Tdsedit' then
        Map.items[Map.items.count-1].imageindex:= 1;
      if lowercase(Comp.Classname) = 'tcombobox' then
        Map.items[Map.items.count-1].imageindex:= 2;
      if lowercase(Comp.Classname) = 'Tdscombobox' then
        Map.items[Map.items.count-1].imageindex:= 3;
      if lowercase(Comp.Classname) = 'tmemo' then
        Map.items[Map.items.count-1].imageindex:= 4;
      if lowercase(Comp.Classname) = 'Tdsmemo' then
        Map.items[Map.items.count-1].imageindex:= 5;
      if lowercase(Comp.Classname) = 'tcheckbox' then
        Map.items[Map.items.count-1].imageindex:= 6;
      if lowercase(Comp.Classname) = 'Tdscheckbox' then
        Map.items[Map.items.count-1].imageindex:= 7;
      if lowercase(Comp.Classname) = 'tradiobutton' then
        Map.items[Map.items.count-1].imageindex:= 8;
      if lowercase(Comp.Classname) = 'tlistview' then
        Map.items[Map.items.count-1].imageindex:= 9;
      if lowercase(Comp.Classname) = 'Tdslistview' then
        Map.items[Map.items.count-1].imageindex:= 10;
    end;
  end;
  //get existing string data
  for J:= 0 to Strings.count-1 do
    for I:= 0 to Map.Items.count-1 do
      if sametext( Map.Items[I].Caption, ExtractComponent(Strings[J]) ) then
      begin
        Map.Items[I].subitems.clear;
        if ExtractField(Strings[J]) <> '' then
          if CheckFieldPath(ExtractField(Strings[J])) then
            Map.Items[I].subitems.add( ExtractField(Strings[J]) );
      end;

  //show the form
  result:= showmodal = mrOK;
  if result then
  begin
    //make new string data
    Strings.clear;
    for I:= 0 to Map.Items.count-1 do
      if Map.Items[I].subitems.count > 0 then
        Strings.add(Map.Items[I].Caption+#9+Map.Items[I].subitems[0]);
  end;      
end;

procedure TdlgDefHook.AddClass(aclass: TClass);
var
  I: integer;
  tmpPropCount: integer;
  tmpProps: PPropList;
  TypeData : PTypeData;
  Node, N: TTreeNode;
begin
  //* this is a recursive method *
  //add root?
  if Fields.Items.count = 0 then
    Fields.Items.Add(nil, AClass.Classname);
  Node:= Fields.Items[Fields.Items.count-1];
  //allocate RTTI buffer
  TypeData := GetTypeData(AClass.ClassInfo);
  tmpPropCount:= TypeData.PropCount;
  GetMem(tmpProps, tmpPropCount * sizeof(Pointer));
  try
    //copy property list into buffer
    GetPropInfos(AClass.ClassInfo, tmpProps);
    //loop thru properties
    for I := 0 to tmpPropCount-1 do
    begin
      if tmpProps[I].PropType^.Kind = tkMethod then continue;
      N:= Fields.Items.AddChild(Node, tmpProps[I].Name);
      case tmpProps[I].PropType^.Kind of
        tkClass :
        begin
          {Fields.Items[Fields.Items.count-1].Text:= Fields.Items[Fields.Items.count-1].Text +' ('+GetObjectPropClass(nil,tmpProps[I]).classname+')';}
          AddClass(GetObjectPropClass(nil,tmpProps[I]));
        end;
        tkChar,tkWChar,tkString,tkWString,tkLString :
        begin
          N.Imageindex:= 1;
          N.Selectedindex:= 1;
        end;
        else begin
          N.Imageindex:= 2;
          N.Selectedindex:= 2;
        end;
      end;
    end;
  //free RTTI buffer
  finally
    FreeMem(tmpProps, tmpPropCount * sizeof(Pointer));
  end;
end;

function GetFieldPath(node: TTreeNode): string;
begin
  result:= '';
  while node.parent <> nil do
  begin
    result:= node.text+'/'+result;
    node:= node.parent;
  end;
  if (length(result)>0) and (result[length(result)] = '/') then
    delete(result, length(result), 1);
end;

procedure TdlgDefHook.ButtonClick(Sender: TObject);
var
  I,J: integer;
begin
  if (Sender = nil) or (Sender = btnAdd) or (Sender = pAdd) then
  begin
    if (Map.selected = nil) and (Map.Items.count > 0) then
      Map.Selected:= Map.Items[0];
    if Map.selected = nil then
      raise Exception.create('Please select a component');
    if Fields.selected = nil then
      raise Exception.create('Please select a field');
    if Fields.selected.imageindex = 0 then
      raise Exception.create('Please select a field, not a class');
    Map.Selected.subitems.clear;
    Map.Selected.subitems.add(GetFieldPath(Fields.selected));
    if Sender <> nil then
    begin
      repeat
        if (Fields.selected.AbsoluteIndex < (Fields.Items.count-1)) then
          Fields.selected:= Fields.Items[Fields.selected.AbsoluteIndex+1]
        else
          break;
      until (Fields.selected.imageindex > 0);
      if Map.selected.Index < (Map.Items.count-1) then
        Map.selected:= Map.Items[Map.selected.Index+1];
      Map.ItemFocused:= Map.Selected;
    end;
  end;

  if (Sender = btnDelete) or (Sender = pDelete) then
  begin
    if Map.selected = nil then
      raise Exception.create('Please select a component');
    Map.Selected.subitems.clear;
    Map.Refresh;
  end;

  if (Sender = btnUp) or (Sender = pMoveUp) then
  begin
    if Map.selected = nil then
      raise Exception.create('Please select a component');
    I:= Map.selected.Index;
    if I > 0 then
    begin
      Form.FindComponent(TComponent(Map.Selected.Data).Name).ComponentIndex:=
        Form.FindComponent(TComponent(Map.items[Map.Selected.Index-1].data).Name).ComponentIndex;
      Map.items.Insert(I-1);
      Map.items[I-1].assign(Map.items[I+1]);
      Map.items[I+1].delete;
      Map.Selected:= Map.items[I-1];
      Map.ItemFocused:= Map.Selected;
    end;
  end;

  if (Sender = btnDown) or (Sender = pMoveDown) then
  begin
    if Map.selected = nil then
      raise Exception.create('Please select a component');
    I:= Map.selected.Index;
    if I < (Map.Items.count-1) then
    begin
      Form.FindComponent(TComponent(Map.Selected.Data).Name).ComponentIndex:=
        Form.FindComponent(TComponent(Map.items[Map.Selected.Index+1].data).Name).ComponentIndex;
      Map.items.Insert(I+2);
      Map.items[I+2].assign(Map.items[I]);
      Map.items[I].delete;
      Map.Selected:= Map.items[I+1];
      Map.ItemFocused:= Map.Selected;
    end;
  end;

  if (Sender = btnAuto) or (Sender = pAuto) then
  begin
    for I:= 0 to Map.items.count-1 do
      for J:= 0 to Fields.items.count-1 do
        if sametext(Map.items[I].caption, Fields.items[J].text) then
          if Map.items[I].subitems.count = 0 then
            Map.items[I].subitems.add(GetFieldPath(Fields.items[J]));
  end;

  if (Sender = btnClear) or (Sender = pClear) then
  begin
    for I:= 0 to Map.items.count-1 do
      Map.items[I].subitems.clear;
  end;
end;

procedure TdlgDefHook.FieldsEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  AllowEdit:= false;
end;

procedure TdlgDefHook.MapEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit:= false;
end;

procedure TdlgDefHook.MapDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if (Source = Fields) then
    Accept:= true
  else
    Accept:= false;
end;

procedure TdlgDefHook.MapDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  Map.Selected:= Map.DropTarget;
  Map.ItemFocused:= Map.Selected;
  ButtonClick(nil);
end;

procedure TdlgDefHook.MapColumnClick(Sender: TObject; Column: TListColumn);
var I: integer;
begin
  Map.AlphaSort;
  for I:= 0 to Map.items.count-1 do
    Form.FindComponent(TComponent(Map.Items[I].Data).Name).ComponentIndex:= I;
end;

procedure TdlgDefHook.FieldsDblClick(Sender: TObject);
begin
  btnAdd.click;
end;

function TdlgDefHook.CheckFieldPath(path: string): boolean;
var
  X,I: integer;
  tmpstr: string;
begin
  repeat
    //get next token
    X:= pos('/', path);
    if X > 0 then
    begin
      tmpstr:= copy(path, 1, X-1);
      delete(path, 1, X);
    end
    else
      tmpstr:= path;
    //find matching tree item -- this should be better, checking the order
    result:= false;
    for I:= 0 to Fields.Items.count-1 do
      if sametext(tmpstr, Fields.Items[I].text) then
        result:= true;
  //repeat until we're at the root
  until (X = 0) or (not result);
end;


end.
