unit uHospitalDtlParser;

interface

uses SysUtils, classes, uHttpParserBase, uCommonEvents, uHospital;

type
  THospitalDtlParser = class(THttpParserBase)
  private
    class function parserLevel(const html: string; const cb: TGetStrProc): string;
    class function parserInfo(const html: string; const cb: TGetStrProc): string;
  public
    constructor Create();
    destructor Destroy; override;
    //
    class function parserIt(const html: string; const cb: TGetStrProc): string;
  end;

implementation

uses HtmlParser_XE3UP, uCharSplit, uMyTextFile;

{ THospitalDtlParser }

constructor THospitalDtlParser.Create();
begin
  inherited create();
  FFileName := 'car-brand-all.txt';
end;

destructor THospitalDtlParser.Destroy;
begin
end;

  function rm_fmt(const S: string): string;
  begin
    //Result := S.Replace(' ', '');
    Result := S.Replace(#9, '');
    Result := Result.Replace(#10, '');
    Result := Result.Replace(#13, '');
  end;

class function THospitalDtlParser.parserLevel(const html: string; const cb: TGetStrProc): string;

  procedure do_ct(eleP: IHtmlElement; strs: TStrings);
  var i: integer;
    ele: IHtmlElement;
    clzName, str: string;
  begin
    try
      for I := 0 to eleP.ChildrenCount - 1 do begin
        ele := eleP[I];
        cb(ele.InnerHtml);
        //
        clzName := ele.Attributes['class'];
        if SameText(clzName, 'hospital-label-item') then begin
          //strs.Add(ele.InnerText);
          str := ele.InnerText;
          str := rm_fmt(str.Trim);
          strs.Add(str);
        end;
      end;
    finally
    end;
  end;

  function lists_ct(eleP: IHtmlElementList): string;
  var i: integer;
    ele: IHtmlElement;
    strs: TStrings;
  begin
    strs := TStringList.Create;
    try
      for I := 0 to eleP.Count - 1 do begin
        ele := eleP[I];
        cb(ele.InnerHtml);
        do_ct(ele, strs);
      end;
      Result := TCharSplit.GetStrOfSplit(strs, ' ');
    finally
      strs.Free;
    end;
  end;

var
  ele: IHtmlElement;
  ls: IHtmlElementList;
begin
  ele := parserHtml(html);
  ls := ele.SimpleCSSSelector('#gray > div.hospital-info > div > div.h-i-c-top.clearfix > div.hospital-detail > div.h-d-title');
  Result := lists_ct(ls);
end;

class function THospitalDtlParser.parserInfo(const html: string; const cb: TGetStrProc): string;

  procedure do_h_d_c_item_text(eleP: IHtmlElement; strs: TStrings);
  var i: integer;
    ele: IHtmlElement;
    clzName, str: string;
  begin
    try
      for I := 0 to eleP.ChildrenCount - 1 do begin
        ele := eleP[I];
        cb(ele.InnerHtml);
        //
        clzName := ele.Attributes['class'];
        if clzName.Contains('h-d-c-item-text') then begin
        //if SameText(clzName, 'h-d-c-item-text') then begin
          str := ele.InnerText;
          str := rm_fmt(str.Trim);
          strs.Add(str);
        end;
      end;
    finally
    end;
  end;

  procedure do_h_d_c_item(eleP: IHtmlElement; strs: TStrings);
  var i: integer;
    ele: IHtmlElement;
    clzName: string;
  begin
    try
      for I := 0 to eleP.ChildrenCount - 1 do begin
        ele := eleP[I];
        cb(ele.InnerHtml);
        //
        clzName := ele.Attributes['class'];
        if clzName.Contains('h-d-c-item') then begin
          do_h_d_c_item_text(ele, strs);
        end;
      end;
    finally
    end;
  end;

  function lists_ct(eleP: IHtmlElementList): string;
  var i: integer;
    ele: IHtmlElement;
    strs: TStrings;
  begin
    strs := TStringList.Create;
    try
      for I := 0 to eleP.Count - 1 do begin
        ele := eleP[I];
        cb(ele.InnerHtml);
        do_h_d_c_item(ele, strs);
      end;
      Result := TCharSplit.GetStrOfSplit(strs, #9);
    finally
      strs.Free;
    end;
  end;

var
  ele: IHtmlElement;
  ls: IHtmlElementList;
begin
  ele := parserHtml(html);
  ls := ele.SimpleCSSSelector('#gray > div.hospital-info > div > div.h-i-c-top.clearfix > div.hospital-detail > div.h-d-content');
  Result := lists_ct(ls);
end;

class function THospitalDtlParser.parserIt(const html: string; const cb: TGetStrProc): string;

var level, info: string;
begin
  level := parserLevel(html, cb);
  info := parserInfo(html, cb);
  Result := level + #9 + info;
end;

end.

