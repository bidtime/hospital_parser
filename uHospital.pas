unit uHospital;

interface

uses uDataBase;

type
  THospital = class(TDataBase)
  private
    class var FMaxId: Int64;
  public
    hospitalName: string;
    province: string;
    city: string;
    //
    level: string;
    kindType: string;
    info: string;
    addr: string;
    bus: string;
    tel: string;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //procedure setRow(const S: string);
    //
    procedure setRawId(const n: string);
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
  public
    //property ShortCode: string read short_code write short_code;
  end;

implementation

uses SysUtils, classes;

{ THospital }

class constructor THospital.Create;
begin
  FMaxId := 1;
end;

constructor THospital.Create;
begin
  inherited Create;
end;

destructor THospital.Destroy;
begin
end;

procedure THospital.setRawId(const n: string);
begin
  //raw_id := n;
  //car_brand_id := IntToStr(FMaxId + StrToInt(n));
end;

class function THospital.getColumn(const c: char): string;
begin
  Result :=
    'hospitalName' + c +
    'province' + c +
    'city' + c +
    //
    'level' + c +
    'kindType' + c +
    'info' + c +
    'addr' + c +
    'bus' + c +
    'tel'
    ;
end;

function THospital.getRow(const c: char; const quoted: boolean): string;
begin
  if quoted then begin
    Result :=
      QuotedStr(hospitalName) + c +
      QuotedStr(province) + c +
      QuotedStr(city) + c +
      //
      QuotedStr(level) + c +
      QuotedStr(kindType) + c +
      QuotedStr(info) + c +
      QuotedStr(addr) + c +
      QuotedStr(bus) + c +
      QuotedStr(tel)
      ;
  end;
end;

{procedure THospital.setRow(const S: string);
  procedure strsToItems(strs: TStrings);
  var i: integer;
    str: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      str := strs[I];
      case I of
        0: car_brand_id := str;
        1: car_brand_code := str;
        2: car_brand_name := str;
        3: description := str;
        4: state := str;
        5: sort_no := str;
        6: create_time := str;
        7: modify_time := str;
        8: creator_id := str;
        9: modifier_id := str;
        10: letter := str;
        11: short_code := str;
        12: logo_url := str;
        13: blood_enum := str;
        14: raw_id := str;
      end;
    end;
  end;

var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := #9;
    strs.DelimitedText := S;
    strsToItems(strs);
  finally
    if Assigned(strs) then strs.Free;
  end;
end;}

end.

