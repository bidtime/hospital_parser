unit uHttpParserBase;

interface

uses SysUtils, classes, uMyTextFile, Generics.Collections, uCommonEvents;

type
  THttpParserBase = class(TObject)
  private
  protected
    FFileName: string;
    FFileText: TMyTextFile;
    FStopFunc: TBooleanFunc;
    FDataSubDir: string;
    FForceDownload: boolean;
    function isStop(): boolean;
    procedure SetDataSubDir(const subdir: string);
  public
    constructor Create();
    destructor Destroy; override;
    class procedure loadStand(strs: TStrings; Dic: TDictionary<String, String>;
      const c: char=#9); static;
    //
    //procedure Rewrite_(const bWrite: boolean; const S: string);
    procedure CreateFile(const bWrite: boolean; const ctx: string);
    procedure CloseFile(const S: string);

    function getSubDataDir(const s: string): string;
    function get(const url, fname: string;
      const encode: TEncoding; const force: boolean=false;
        const cb: TGetStrProc=nil): String;
    function getGBK(const url, fname: string;
      const cb: TGetStrProc=nil): String;
  public
    property StopFunc: TBooleanFunc write FStopFunc;
    property DataSubDir: string write SetDataSubDir;
    property ForceDownload: boolean write FForceDownload;
  end;

implementation

uses uCharSplit, uNetHttpClt;

{ THttpParserBase }

constructor THttpParserBase.Create();
begin
  inherited create;
  // force download
  FForceDownload := true;
  FFileText := TMyTextFile.Create();
end;

procedure THttpParserBase.CreateFile(const bWrite: boolean; const ctx: string);
begin
  FFileText.createFile(getSubDataDir(FFileName), bWrite);
  FFileText.writeline(ctx);
end;

destructor THttpParserBase.Destroy;
begin
  if Assigned(FFileText) then begin
    FFileText.free;
  end;
end;

function THttpParserBase.get(const url, fname: string; const encode: TEncoding;
  const force: boolean; const cb: TGetStrProc): String;
begin
  Result := g_NetHttpClt.get(url, fname, encode, force, cb);
end;

function THttpParserBase.getGBK(const url, fname: string;
  const cb: TGetStrProc): String;
begin
  Result := get(url, fname, TEncoding.GetEncoding(936), FForceDownload, cb);
end;

{function THttpParserBase.getGBK(const url, fname: string; const force: boolean;
  const cb: TGetStrProc): String;
begin
  Result := get(url, fname, TEncoding.GetEncoding(936), force, cb);
end;}

function THttpParserBase.getSubDataDir(const s: string): string;
begin
  Result := FDataSubDir + '\' + S;
end;

procedure THttpParserBase.SetDataSubDir(const subdir: string);
begin
  FDataSubDir := subdir;
end;

function THttpParserBase.isStop: boolean;
begin
  if Assigned(FStopFunc) then begin
    Result := FStopFunc;
  end else begin
    Result := false;
  end;
end;

class procedure THttpParserBase.loadStand(strs: TStrings;
    Dic: TDictionary<String, String>; const c: char);
var i: integer;
  S, k, v: string;
begin
  for I := 1 to strs.Count - 1 do begin
    S := strs[I];
    k := TCharSplit.getSplitFirst(S, c);
    v := TCharSplit.getSplitIdx(S, c, 1);
    Dic.Add(k, v);
  end;
end;

{procedure THttpParserBase.Rewrite_(const bWrite: boolean; const S: string);
begin
  FFileText.Rewrite_(true);
  FFileText.WriteLn_(S);
end;}

procedure THttpParserBase.CloseFile(const S: string);
begin
  FFileText.writeLine(S);
  FFileText.CloseFile;
end;

{  function get(httpClt: TNetHttpClient): string;
  var ss: TStringStream;
  begin
    ss := TStringStream.Create('', encode);
    try
      if Assigned(cb) then begin
        cb('get' + #9 + url);
      end;
      try
        httpClt.Get(url, ss);
        Result := ss.DataString;
        //
        //ss.SaveToFile(fname);
        //WriteToFile(Result, fname, TEncoding.UTF8);
      except
        on e: Exception do begin
          //WriteToFile(e.Message, 'c:/1.log', TEncoding.UTF8);
          Result := '';
        end;
      end;
    finally
      ss.Free;
    end;
  end;

var httpClt: TNetHttpClient;
begin
  httpClt := TNetHttpClient.Create(nil);
  try
    Result := get(httpClt);
  finally
    httpClt.Free;
  end;
end;}

end.

