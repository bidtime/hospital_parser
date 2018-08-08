unit uHospitalListParser;

interface

uses SysUtils, classes, uHttpParserBase, uCommonEvents;

type
  THospitalListParser = class(THttpParserBase)
  private
  public
    constructor Create();
    destructor Destroy; override;
    //
    class function parserIt(const html: string; strs: TStrings; const cb: TGetStrProc): string;
  end;

implementation

uses HtmlParser_XE3UP, uCharSplit, uMyTextFile;

{ THospitalListParser }

constructor THospitalListParser.Create();
begin
  inherited create();
  FFileName := 'car-brand-all.txt';
end;

destructor THospitalListParser.Destroy;
begin
end;

class function THospitalListParser.parserIt(const html: string; strs: TStrings;
  const cb: TGetStrProc): string;

  procedure ll3(eleP: IHtmlElement);
  var i: integer;
    ele: IHtmlElement;
  begin
    for I := 0 to eleP.ChildrenCount - 1 do begin
      ele := eleP[I];
      if ele.TagName='A' then begin
        //strs.Add(ele.OuterHtml);
        strs.Add(ele.InnerText + #9 + 'https:' + ele.Attributes['href']);
      end;
      //strs.Add(ele.Content + #9 + ele.Attributes['href']);
    end;
  end;

  procedure ll2(eleP: IHtmlElement);
  var i: integer;
    ele: IHtmlElement;
  begin
    for I := 0 to eleP.ChildrenCount - 1 do begin
      ele := eleP[I];
      //strs.Add(ele.OuterHtml);
      //strs.Add(ele.Content + #9 + ele.Attributes['href']);
      ll3(ele);
    end;
  end;

  procedure ll(l: IHtmlElementList);
  var i: integer;
    ele: IHtmlElement;
  begin
    for I := 0 to l.Count - 1 do begin
      ele := l[I];
      //strs.Add(ele.OuterHtml);
      //strs.Add(ele.Content + #9 + ele.Attributes['href']);
      ll2(ele);
    end;
  end;

var
  FNodes: IHtmlElement;
  l: IHtmlElementList;
begin
  FNodes := parserHtml(html);
  //l := FNodes.SimpleCSSSelector('[@id="el_tree_1000000"]');
  l := FNodes.SimpleCSSSelector('#el_tree_1000000');
  ll(l);
end;

end.

