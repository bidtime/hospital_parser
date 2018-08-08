unit uHospitalParser;

interface

uses SysUtils, classes, uHttpParserBase, uCommonEvents, uHospital;

type
  THospitalParser = class(THttpParserBase)
  private
  public
    constructor Create();
    destructor Destroy; override;
    //
    class function parserIt(const province: string; const html: string;
      strs: TStrings; const cb: TGetStrProc): string;
  end;

implementation

uses HtmlParser_XE3UP, uCharSplit, uMyTextFile;

{ THospitalParser }

constructor THospitalParser.Create();
begin
  inherited create();
  FFileName := 'car-brand-all.txt';
end;

destructor THospitalParser.Destroy;
begin
end;

class function THospitalParser.parserIt(const province: string; const html: string;
  strs: TStrings; const cb: TGetStrProc): string;

  procedure eleCss_m_title_green(eleP: IHtmlElement; var distrinct: string);
  var i: integer;
    ele: IHtmlElement;
  begin
    for I := 0 to eleP.ChildrenCount - 1 do begin
      ele := eleP[I];
      distrinct := ele.InnerText;
    end;
  end;

  procedure eleCss_m_ctt_green(eleP: IHtmlElement; const distrinct: string);

    procedure eleCss_li(eleP: IHtmlElement);
    var i: integer;
      ele: IHtmlElement;
      url: string;
    begin
      for I := 0 to eleP.ChildrenCount - 1 do begin
        ele := eleP[I];
        if ele.TagName='A' then begin
          url := 'https://www.haodf.com' + ele.Attributes['href'];
          //strs.Add(ele.InnerHtml);
          strs.Add(province + #9 + distrinct + #9 + ele.InnerText + #9
             + url + #9);
        end;
      end;
    end;

    procedure eleCss_ul(eleP: IHtmlElement);
    var i: integer;
      ele: IHtmlElement;
    begin
      for I := 0 to eleP.ChildrenCount - 1 do begin
        ele := eleP[I];
        eleCss_li(ele);
      end;
    end;

  var i: integer;
    ele: IHtmlElement;
  begin
    for I := 0 to eleP.ChildrenCount - 1 do begin
      ele := eleP[I];
      if SameText(ele.TagName, 'ul') then begin
        eleCss_ul(ele);
      end;
    end;
  end;

  procedure do_ct(eleP: IHtmlElement);
  var i: integer;
    ele: IHtmlElement;
    distrinct, clzName: string;
  begin
    for I := 0 to eleP.ChildrenCount - 1 do begin
      ele := eleP[I];
      //
      clzName := ele.Attributes['class'];
      if clzName='m_title_green' then begin
        eleCss_m_title_green(ele, distrinct);
      end else if clzName='m_ctt_green' then begin
        eleCss_m_ctt_green(ele, distrinct);
      end;
    end;
  end;

  procedure lists_ct(eleP: IHtmlElementList);
  var i: integer;
    ele: IHtmlElement;
  begin
    for I := 0 to eleP.Count - 1 do begin
      ele := eleP[I];
      do_ct(ele);
    end;
  end;

var
  ele: IHtmlElement;
  ls: IHtmlElementList;
begin
  ele := parserHtml(html);
  ls := ele.SimpleCSSSelector('#el_result_content > div > div.bxmd > div.ct');
  lists_ct(ls);
end;

end.

