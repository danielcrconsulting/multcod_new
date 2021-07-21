unit dfHTML;

interface

uses
   SysUtils,
   dfclasses,
   graphics,
   classes,
   dfGifImage,
   dfutil          
   ;

type
   TStyle = class
   private
      FStyleName: String;
      FFontFamily: String;
      FFontSize: Integer;
      FColor: TColor;
      FBackColor: TColor;
      FTextDecoration: TFontStyles;
      FBorderColor: TColor;
      FBorderWidth: Integer;
      FBorderStyle: TPenStyle;
      FAlignment: TdfAlignment;
   public
      constructor Create(NewStyleName: String);
   published
      property StyleName: String read FStyleName write FStyleName;
      property FontFamily: String read FFontFamily write FFontFamily;
      property FontSize: Integer read FFontSize write FFontSize;
      property Color: TColor read FColor write FColor;
      property BackColor: TColor read FBackColor write FBackColor;
      property TextDecoration: TFontStyles read FTextDecoration write FTextDecoration;
      property BorderColor: TColor read FBorderColor write FBorderColor;
      property BorderWidth: Integer read FBorderWidth write FBorderWidth;
      property BorderStyle: TPenStyle read FBorderStyle write FBorderStyle;
      property Alignment: TdfAlignment read FAlignment write FAlignment;
   end;

procedure DefinedFormToHTML(DFBSource: TdfEngine; const HTMLDest: string; CreateCSSFile: Boolean; Scale: Double);

implementation

constructor TStyle.Create(NewStyleName: String);
begin
   inherited Create;
   FStyleName := NewStyleName
end;

function Color2String(Color: TColor): String;
begin
   Result := '#' + Format('%.6x', [Color])
end;

function String2HTMLString(S: String): String;
var
   i: Integer;
begin
   Result := '';
   if Length(S) = 0 then
      Exit;
   for i := 1 to Length(S) do
       case S[i] of
          '"': Result := Result + '&#34;';
          '#': Result := Result + '&#35;';
          '$': Result := Result + '&#36;';
          else
               Result := Result + S[i];
       end
end;

function LookupStyle(StyleList: TList; AObject: TDFObject; var StName: String): Integer;
var
   i: Integer;
   Style: TStyle;
begin
   Result := -1;
   StName := '';
   if StyleList.Count > 0 then
      if (AObject is TDFText) then
         for i := 0 to StyleList.Count - 1 do begin
             Style := TStyle(StyleList[i]);
             with Style do
                if (FontFamily = TDFAccess(AObject).FontName) and (FontSize = TDFAccess(AObject).FontSize) and
                   (Color = TDFAccess(AObject).FontColor) and (TextDecoration = TDFAccess(AObject).FontStyle) and
                   (BackColor = TDFAccess(AObject).BrushColor) then begin
                   Result := i;
                   StName := StyleName;
                   Break
                end //if
         end //for
      else if (AObject is TDFField) then begin
         if TDFField(AObject).Format = dfText then
            for i := 0 to StyleList.Count - 1 do begin
                Style := TStyle(StyleList[i]);
                with Style do
                 if (FontFamily = TDFAccess(AObject).FontName) and (FontSize = TDFAccess(AObject).FontSize) and
                    (Color = TDFAccess(AObject).FontColor) and (TextDecoration = TDFAccess(AObject).FontStyle) and
                    (BackColor = TDFAccess(AObject).BrushColor) and (Alignment = TDFField(AObject).Alignment) then begin
                    Result := i;
                    StName := StyleName;
                    Break
                 end //if
            end //for
      end else if (AObject is TDFFrame) then
         for i := 0 to StyleList.Count - 1 do begin
             Style := TStyle(StyleList[i]);
             with Style do
                if (Pos('DFFrame', StyleName) > 0) and (BackColor = TDFFrame(AObject).BrushColor) and
                   (BorderColor = TDFFrame(AObject).PenColor)  and (BorderStyle = TDFFrame(AObject).PenStyle) and
                   (BorderWidth = TDFFrame(AObject).PenWidth) then begin
                   Result := i;
                   StName := StyleName;
                   Break
                end //if
         end //for
      else if (AObject is TDFLine) then
         for i := 0 to StyleList.Count - 1 do begin
             Style := TStyle(StyleList[i]);
             with Style do
                if (Pos('DFLine', StyleName) > 0) and (BorderColor = TDFFrame(AObject).PenColor)  and
                   (BorderStyle = TDFFrame(AObject).PenStyle) and (BorderWidth = TDFFrame(AObject).PenWidth) then begin
                   Result := i;
                   StName := StyleName;
                   Break
                end //if
         end //for
end;

procedure CreateCSS(Engine: TDFEngine; const CSSName: String; StyleList: TList);
var
   cf: TextFile;
   i: Integer;
   Style: TStyle;
   Dummy: String;
begin
   AssignFile(cf, CSSName);
   ReWrite(cf);
   if StyleList.Count > 0 then
      for i := 0 to StyleList.Count - 1 do
          TStyle(StyleList[i]).Free;
   StyleList.Clear;
   with Engine do try

      if ObjectCount = 0 then
         raise Exception.Create('No objects found.');

      //Write checkbox box style first
      WriteLn(cf, '.TDFFieldCheckbox {');
      WriteLn(cf, ' font-name: Times New Roman;');
      WriteLn(cf, ' font-size: 5pt;');
      WriteLn(cf, ' font-weight: bolder;');
      WriteLn(cf, ' position: absolute;');
      Writeln(cf, ' border-style: solid solid solid solid;');
      WriteLn(cf, ' border-width: 2px;');
      WriteLn(cf, ' border-color: black;');
      WriteLn(cf, '}');
      WriteLn(cf);


      for i := 0 to ObjectCount - 1 do
         if (Objects[i] is TDFText)  then begin
            if LookupStyle(StyleList, Objects[i], Dummy) = -1 then begin

               //add style to the file
               WriteLn(cf, '.TDFText' + IntToStr(i) + ' {');
               WriteLn(cf, ' font-family: ' + TDFAccess(Objects[i]).FontName + ';');
               WriteLn(cf, ' font-size: ' + IntToStr(TDFAccess(Objects[i]).FontSize) + 'pt;');

               if fsBold in TDFAccess(Objects[i]).FontStyle then
                  WriteLn(cf, ' font-weight: bold;')
               else
                  WriteLn(cf, ' font-weight: normal;');

               if fsItalic in TDFAccess(Objects[i]).FontStyle then
                  WriteLn(cf, ' font-style: italic;')
               else
                  WriteLn(cf, ' font-style: normal;');

               Dummy := '';
               if fsStrikeOut in TDFAccess(Objects[i]).FontStyle then begin
                  Dummy := 'line-through';
                  if fsUnderline in TDFAccess(Objects[i]).FontStyle then
                     Dummy := Dummy + ' underline'
                  else
                     Dummy := Dummy + ';';
               end else
                  if fsUnderline in TDFAccess(Objects[i]).FontStyle then
                     Dummy := 'underline;';

               if Dummy = '' then
                  Dummy := 'none;';

               WriteLn(cf, ' text-decoration: ' + Dummy);

               if TDFText(Objects[i]).Alignment = dfLeft then
                  WriteLn(cf, ' text-align: left;')
               else if TDFText(Objects[i]).Alignment = dfRight then
                  WriteLn(cf, ' text-align: right;')
               else if TDFText(Objects[i]).Alignment = dfCentered then
                  WriteLn(cf, ' text-align: center;')
               else
                  WriteLn(cf, ' text-align: justify;');

               WriteLn(cf, ' color: ' + Color2String(TDFAccess(Objects[i]).FontColor) + ';');
               //WriteLn(cf, ' background-color: ' + Color2String(TDFAccess(Objects[i]).BrushColor) + ';');
               WriteLn(cf, ' white-space: nowrap;');
               WriteLn(cf, ' position: absolute;');
               WriteLn(cf, '}');
               WriteLn(cf);

               Style :=  TStyle.Create('TDFText' + IntToStr(i));
               with Style do begin
                  FontFamily := TDFAccess(Objects[i]).FontName;
                  FontSize := TDFAccess(Objects[i]).FontSize;
                  TextDecoration := TDFAccess(Objects[i]).FontStyle;
                  Color := TDFAccess(Objects[i]).FontColor;
                  BackColor := TDFAccess(Objects[i]).BrushColor;
               end;
               StyleList.Add(Style)
            end //if LookupStyle
         end else if (Objects[i] is TDFField) then begin
            if TDFField(Objects[i]).Format = dfText then begin
               if LookupStyle(StyleList, Objects[i], Dummy) = -1 then begin

                  //add style to the file
                  WriteLn(cf, '.TDFField' + IntToStr(i) + ' {');
                  WriteLn(cf, ' font-family: ' + TDFAccess(Objects[i]).FontName + ';');
                  WriteLn(cf, ' font-size: ' + IntToStr(TDFAccess(Objects[i]).FontSize) + 'pt;');

                  if fsBold in TDFAccess(Objects[i]).FontStyle then
                     WriteLn(cf, ' font-weight: bold;')
                  else
                     WriteLn(cf, ' font-weight: normal;');

                  if fsItalic in TDFAccess(Objects[i]).FontStyle then
                     WriteLn(cf, ' font-style: italic;')
                  else
                     WriteLn(cf, ' font-style: normal;');

                  Dummy := '';
                  if fsStrikeOut in TDFAccess(Objects[i]).FontStyle then begin
                     Dummy := 'line-through';
                     if fsUnderline in TDFAccess(Objects[i]).FontStyle then
                        Dummy := Dummy + ' underline'
                     else
                        Dummy := Dummy + ';';
                  end else
                     if fsUnderline in TDFAccess(Objects[i]).FontStyle then
                        Dummy := 'underline;';

                  if Dummy = '' then
                     Dummy := 'none;';

                  WriteLn(cf, ' text-decoration: ' + Dummy);

                  if TDFField(Objects[i]).Alignment = dfLeft then
                     WriteLn(cf, ' text-align: left;')
                  else if TDFField(Objects[i]).Alignment = dfRight then
                     WriteLn(cf, ' text-align: right;')
                  else if TDFField(Objects[i]).Alignment = dfCentered then
                     WriteLn(cf, ' text-align: center;')
                  else
                     WriteLn(cf, ' text-align: justify;');


                  WriteLn(cf, ' color: ' + Color2String(TDFAccess(Objects[i]).FontColor) + ';');
                  //WriteLn(cf, ' background-color: ' + Color2String(TDFAccess(Objects[i]).BrushColor) + ';');
                  WriteLn(cf, ' white-space: nowrap;');
                  WriteLn(cf, ' position: absolute;');
                  WriteLn(cf, '}');
                  WriteLn(cf);

                  Style :=  TStyle.Create('TDFField' + IntToStr(i));
                  with Style do begin
                     FontFamily := TDFAccess(Objects[i]).FontName;
                     FontSize := TDFAccess(Objects[i]).FontSize;
                     TextDecoration := TDFAccess(Objects[i]).FontStyle;
                     Color := TDFAccess(Objects[i]).FontColor;
                     BackColor := TDFAccess(Objects[i]).BrushColor;
                     Alignment := TDFField(Objects[i]).Alignment;
                  end;
                  StyleList.Add(Style)
               end //if LookupStyle
            end else if TDFField(Objects[i]).Format = dfCheckbox then begin
               ;
            end
         end else if (Objects[i] is TDFFrame) then begin
            if LookupStyle(StyleList, Objects[i], Dummy) = -1 then begin
               WriteLn(cf, '.TDFFrame' + IntToStr(i) + ' {');
               WriteLn(cf, ' font-name: Arial;');
               WriteLn(cf, ' font-size: 5pt;');
               WriteLn(cf, ' background-color: ' + Color2String(TDFFrame(Objects[i]).BrushColor) + ';');
               WriteLn(cf, ' border-color: ' + Color2String(TDFFrame(Objects[i]).PenColor) + ';');
               if (TDFFrame(Objects[i]).PenStyle = psDash) or (TDFFrame(Objects[i]).PenStyle = psDashDot) then
                  WriteLn(cf, ' border-style: dashed;')
               else if (TDFFrame(Objects[i]).PenStyle = psDot) or (TDFFrame(Objects[i]).PenStyle = psDashDotDot) then
                  WriteLn(cf, ' border-style: dotted;')
               else if TDFFrame(Objects[i]).PenStyle = psClear then
                  WriteLn(cf, ' border-style: none;')
               else if TDFFrame(Objects[i]).PenStyle = psInsideFrame then
                  WriteLn(cf, ' border-style: inset;')
               else
                  WriteLn(cf, ' border-style: solid;');
               WriteLn(cf, ' border-width: ' + IntToStr(TDFFrame(Objects[i]).PenWidth) + 'px;');
               WriteLn(cf, ' position: absolute;');
               WriteLn(cf, '}');
               WriteLn(cf);

               Style := TStyle.Create('TDFFrame' + IntToStr(i));
               with Style do begin
                  FontFamily := '';
                  FontSize := 0;
                  TextDecoration := [];
                  Color := 0;
                  BackColor := TDFFrame(Objects[i]).BrushColor;
                  BorderColor := TDFFrame(Objects[i]).PenColor;
                  BorderStyle := TDFFrame(Objects[i]).PenStyle;
                  BorderWidth := TDFFrame(Objects[i]).PenWidth;
               end;
               StyleList.Add(Style);
            end
         end else if (Objects[i] is TDFLine) then begin
            if LookupStyle(StyleList, Objects[i], Dummy) = -1 then begin
               WriteLn(cf, '.TDFLine' + IntToStr(i) + ' {');
               WriteLn(cf, ' background: none;');
               Dummy := ' border-top:' + IntToStr(TDFLine(Objects[i]).PenWidth) + 'px ';
               if (TDFLine(Objects[i]).PenStyle = psDash) or (TDFLine(Objects[i]).PenStyle = psDashDot) then
                  Dummy := Dummy + 'dashed '
               else if (TDFLine(Objects[i]).PenStyle = psDot) or (TDFLine(Objects[i]).PenStyle = psDashDotDot) then
                  Dummy := Dummy + 'dotted '
               else if TDFLine(Objects[i]).PenStyle = psClear then
                  Dummy := Dummy + 'none '
               else if TDFLine(Objects[i]).PenStyle = psInsideFrame then
                  Dummy := Dummy + 'inset '
               else
                  Dummy := Dummy + 'solid ';
               Dummy := Dummy + Color2String(TDFLine(Objects[i]).PenColor) + ';';
               WriteLn(cf, Dummy);
               System.Delete(Dummy, 1, 12);
               Dummy := ' border-left:' + Dummy;
               WriteLn(cf, Dummy);
               WriteLn(cf, ' position: absolute;');
               WriteLn(cf, '}');
               WriteLn(cf);

               Style := TStyle.Create('TDFLine' + IntToStr(i));
               with Style do begin
                  BorderColor := TDFLine(Objects[i]).PenColor;
                  BorderStyle := TDFLine(Objects[i]).PenStyle;
                  BorderWidth := TDFLine(Objects[i]).PenWidth;
               end;
               StyleList.Add(Style);
            end //if Lookup
         end else if (Objects[i] is TDFLogo) then
            ;
   finally
      CloseFile(cf)
   end
end;

procedure DefinedFormToHTML(DFBSource: TdfEngine; const HTMLDest: string; CreateCSSFile: Boolean; Scale: Double);
const
   HTML_401_TransitionalDTD = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">';

var
   hf, cf: TextFile;
   CSSFileName, LogoFileName, StName, S: String;
   Styles: TList;
   i, CurrentPage, CurrentObject, fHeight: Integer;
   dHeight: Double;
//   AField: TDFField;
//   AText: TDFText;
   GF: TGIFImage;
   BM: TBitmap;
begin
   fHeight := 0; //added
   I := 0; //added
   Styles := TList.Create;
   with DFBSource do
      try
        if PageCount = 0 then
           raise Exception.Create('No pages in form.');

        if Scale <> 1 then
          for CurrentPage := 0 to PageCount - 1 do
            with Pages[CurrentPage] do
              if ObjectCount > 0 then
                for CurrentObject := 0 to ObjectCount - 1 do begin
                  if Objects[CurrentObject] is TDFText then
                     fHeight := TDFText(Objects[CurrentObject]).FontHeight
                  else if Objects[CurrentObject] is TDFField then
                     fHeight := TDFField(Objects[CurrentObject]).FontHeight;
                  with TDFAccess(Objects[CurrentObject]) do begin
                    dHeight := fHeight*(-72)*Scale;
                    FontSize := Round(dHeight/Form.PixelsPerInch);
                    Left := Round(Left*Scale);
                    Top := Round(Top*Scale);
                    Width := Round(Width*Scale);
                    Height := Round(Height*Scale)
                  end;
                end;

        CSSFileName := ExtractFilePath(HTMLDest) + Copy(ExtractFileName(HTMLDest), 1, Pos('.', ExtractFileName(HTMLDest)) - 1) + '.css';

        //Create cascade style sheets file
        CreateCSS(DFBSource, CSSFileName, Styles);

        //iterate through the form pages
        for CurrentPage := 0 to PageCount - 1 do begin

           AssignFile(hf, ExtractFilePath(HTMLDest) + Copy(ExtractFileName(HTMLDest), 1, Pos('.', ExtractFileName(HTMLDest)) - 1) + '_' + IntToStr(CurrentPage + 1) + '.html');
           ReWrite(hf);
           with Pages[CurrentPage] do try
              //Write DTD
              WriteLn(hf, HTML_401_TransitionalDTD);

              //Write header
              WriteLn(hf, '<html>');
              WriteLn(hf, '<head>');
              WriteLn(hf, '<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">');

              //Write title of the document
              WriteLn(hf, '<title>' + Form.FormName + '</title>');

              if CreateCSSFile then
                 //Write link to css
                 WriteLn(hf, '<LINK REL=STYLESHEET TYPE="text/css" HREF="' + CSSFileName + '">')
              else begin
                 WriteLn(hf, '<style>');
                 //Copy CSS file into HTML
                 AssignFile(cf, CSSFileName);
                 Reset(cf);
                 while not Eof(cf) do begin
                    ReadLn(cf, S);
                    WriteLn(hf, S)
                 end;
                 DeleteFile(CSSFileName)
              end;
              WriteLn(hf, '</style>');
              WriteLn(hf, '</head>');

              //Write the body

              //use the backgound color of the page
              WriteLn(hf, '<body bgcolor="' + Color2String(Color) + '">');

              if ObjectCount > 0 then
                 for CurrentObject := 0 to ObjectCount - 1 do
                     if Objects[CurrentObject] is TDFText then begin
                        if not TDFAccess(Objects[CurrentObject]).Visible then
                           Continue;
                        //process text
                        LookupStyle(Styles, Objects[CurrentObject], StName);
                        S := '<DIV class="';
                        S := S + StName + '"';
                        S := S + ' style="';
                        S := S + 'left:' + IntToStr(TDFAccess(Objects[CurrentObject]).Left) + 'px;';
                        S := S + 'top:' + IntToStr(TDFAccess(Objects[CurrentObject]).Top) + 'px;';
                        S := S + 'width:' + IntToStr(TDFAccess(Objects[CurrentObject]).Width) + 'px;';
                        S := S + 'height:' + IntToStr(TDFAccess(Objects[CurrentObject]).Height) + 'px;">';
                        S := S + String2HTMLString(TDFText(Objects[CurrentObject]).Text) + '</DIV>';
                        WriteLn(hf, S);
                     end else if Objects[CurrentObject] is TDFField then begin
                        //process field
                        if TDFField(Objects[CurrentObject]).Format = dfCheckbox then begin
                           S := '<DIV class="TDFFieldCheckBox" ';
                           S := S + ' style="';
                           S := S + 'left:' + IntToStr(TDFAccess(Objects[CurrentObject]).Left + 1) + 'px;';
                           S := S + 'top:' + IntToStr(TDFAccess(Objects[CurrentObject]).Top + 2) + 'px;';
                           S := S + 'width: 3mm;';
                           S := S + 'Height: 3mm">';
                           if TDFField(Objects[CurrentObject]).AsBoolean then
                              S := S + 'X</DIV>'
                           else
                              S := S + '</DIV>';
                           WriteLn(hf, S)
                        end else if TDFField(Objects[CurrentObject]).Format = dfText then begin
                          LookupStyle(Styles, Objects[CurrentObject], StName);
                          S := '<DIV class="';
                          S := S + StName + '"';
                          S := S + ' style="';
                          S := S + 'left:' + IntToStr(TDFAccess(Objects[CurrentObject]).Left) + 'px;';
                          S := S + 'top:' + IntToStr(TDFAccess(Objects[CurrentObject]).Top) + 'px;';
                          S := S + 'width:' + IntToStr(TDFAccess(Objects[CurrentObject]).Width) + 'px;';
                          S := S + 'height:' + IntToStr(TDFAccess(Objects[CurrentObject]).Height) + 'px;">';
                          S := S + String2HTMLString(TDFField(Objects[CurrentObject]).AsString) + '</DIV>';
                          WriteLn(hf, S);
                        end
                     end else if Objects[CurrentObject] is TDFFrame then begin
                        //process frame
                        LookupStyle(Styles, Objects[CurrentObject], StName);
                        S := '<DIV class="';
                        S := S + StName + '"';
                        S := S + ' style="';
                        S := S + 'left:' + IntToStr(TDFAccess(Objects[CurrentObject]).Left) + 'px;';
                        S := S + 'top:' + IntToStr(TDFAccess(Objects[CurrentObject]).Top) + 'px;';
                        S := S + 'width:' + IntToStr(TDFAccess(Objects[CurrentObject]).Width) + 'px;';
                        S := S + 'height:' + IntToStr(TDFAccess(Objects[CurrentObject]).Height) + 'px;">';
                        S := S + '</DIV>';
                        WriteLn(hf, S);
                     end else if Objects[CurrentObject] is TDFLine then begin
                        //process line
                        if TDFLine(Objects[CurrentObject]).X1 = TDFLine(Objects[CurrentObject]).X2 then begin
                           //vertical line
                           LookupStyle(Styles, Objects[CurrentObject], StName);
                           S := '<DIV class="';
                           S := S + StName + '"';
                           S := S + ' style="border-top:none;';
                           S := S + 'left:' + IntToStr(TDFLine(Objects[CurrentObject]).X1) + ';';
                           S := S + 'width:1;';
                           S := S + 'top:' + IntToStr(TDFLine(Objects[CurrentObject]).Y1) + ';';
                           S := S + 'height:' + IntToStr(TDFLine(Objects[CurrentObject]).Y2 - TDFLine(Objects[CurrentObject]).Y1) + ';"></DIV>';
                           WriteLn(hf, S)
                        end else if TDFLine(Objects[CurrentObject]).Y1 = TDFLine(Objects[CurrentObject]).Y2 then begin
                          //hosizontal line
                           LookupStyle(Styles, Objects[CurrentObject], StName);
                           S := '<DIV class="';
                           S := S + StName + '"';
                           S := S + ' style="border-left:none;';
                           S := S + 'left:' + IntToStr(TDFLine(Objects[CurrentObject]).X1) + ';';
                           S := S + 'top:' + IntToStr(TDFLine(Objects[CurrentObject]).Y1) + ';';
                           S := S + 'height:1;';
                           S := S + 'width:' + IntToStr(TDFLine(Objects[CurrentObject]).X2 - TDFLine(Objects[CurrentObject]).X1) + ';"></DIV>';
                           WriteLn(hf, S)
                        end
                     end else if Objects[CurrentObject] is TDFLogo then begin
                        //process logo
                        LogoFileName := ExtractFilePath(HTMLDest) + 'Logo' + IntToStr(i) + '.gif';
                        GF := TGIFImage.Create;
                        BM := TBitmap.Create;
                        with TDFLogo(Objects[CurrentObject]) do try
                           BM.Height:= Height;
                           BM.Width:= Width;
                           if (Picture.Graphic <> nil) and (not Picture.Graphic.Empty) then
                              dfStretchDraw(BM.Canvas, Rect(0, 0, Width, Height), Picture.Graphic);
                           GF.Assign(BM);
                           GF.SaveToFile(LogoFileName);
                        finally
                           GF.Free;
                           BM.Free
                        end;
                        S := '<img src="' + LogoFileName + '" ';
                        S := S + 'width="' + IntToStr(TDFLogo(Objects[CurrentObject]).Width) + '" ';
                        S := S + 'height="' + IntToStr(TDFLogo(Objects[CurrentObject]).Height) + '" ';
                        S := S + 'hspace="' + IntToStr(TDFLogo(Objects[CurrentObject]).Left) + '" ';
                        S := S + 'vspace="' + IntToStr(TDFLogo(Objects[CurrentObject]).Top) + '" ';
                        S := S + 'border="0" alt="">';
                        WriteLn(hf, S)
                     end;
              WriteLn(hf, '</body>');
              WriteLn(hf, '</html>')
           finally
              CloseFile(hf)
           end
        end //for pages
      finally
        if Styles.Count > 0 then
           for i := 0 to Styles.Count - 1 do
               TStyle(Styles[i]).Free;
        Styles.Free;
      end
end;

end.
