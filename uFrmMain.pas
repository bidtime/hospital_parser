unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.ToolWin, uNetHttpClt,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TfrmMain = class(TForm)
    Splitter4: TSplitter;
    ToolBar1: TToolBar;
    ToolButton10: TToolButton;
    cbxURL: TComboBox;
    ToolButton5: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton1: TToolButton;
    ToolButton8: TToolButton;
    cbxStop: TCheckBox;
    ToolButton12: TToolButton;
    cbxBrand: TCheckBox;
    cbxSerie: TCheckBox;
    ToolButton4: TToolButton;
    Label1: TLabel;
    spedTimeout: TSpinEdit;
    memoCtx: TMemo;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Splitter8: TSplitter;
    memoLog: TMemo;
    memoHospital: TMemo;
    memoProvinces: TMemo;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    nGoto: TMenuItem;
    nBrand: TMenuItem;
    setting1: TMenuItem;
    N3: TMenuItem;
    carTypeSql1: TMenuItem;
    carUpdateSql1: TMenuItem;
    cfgSql1: TMenuItem;
    N2: TMenuItem;
    nExit: TMenuItem;
    H1: TMenuItem;
    A1: TMenuItem;
    NetHTTPClient1: TNetHTTPClient;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure ToolButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
  private
    { Private declarations }
    FHttpClt: TNetHttpClt;
    procedure doUrlEvent(const S: string);
    procedure addLog(const S: string);
    procedure addLogMod(const S: string; const nmod: integer);
    procedure setStatus(const S: string; const setCap: boolean=false;
      const tmSleep: integer=0);
    function get(const url: String; encode: TEncoding;
      const cb: TGetStrProc): String;
    function getRaw(netHttp: TNetHttpClient; const url: String;
      encode: TEncoding; const cb: TGetStrProc): String;
    procedure addCtx(const S: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uHospitalListParser, uHospitalParser, uHospitalDtlParser, uCharSplit, uCharUtils, uNetUtils;

{$R *.dfm}

procedure TfrmMain.setStatus(const S: string; const setCap: boolean; const tmSleep: integer);
begin
  StatusBar1.Tag := StatusBar1.Tag + 1;
  StatusBar1.Panels[0].Text := S;
  if setCap then begin
    caption := S;
  end;
  sleep(tmSleep);
  if (StatusBar1.Tag mod 10 = 0) then begin
    Application.ProcessMessages;
  end;
end;

procedure TfrmMain.addLogMod(const S: string; const nmod: integer);
begin
  memoLog.Lines.Add(IntToStr(memoLog.lines.count) + '.' + '  ' + s);
  self.setStatus(IntToStr(memoLog.Tag)+'/'+s);
end;

procedure TfrmMain.addCtx(const S: string);
begin
  memoCtx.Lines.Add(s);
end;

procedure TfrmMain.addLog(const S: string);
begin
  addLogMod(s, 0);
end;

procedure TfrmMain.doUrlEvent(const S: string);
begin
  addLog(S);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FHttpClt := TNetHttpClt.Create(TEncoding.GetEncoding(936));
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FHttpClt.Free;
end;

function TfrmMain.getRaw(netHttp: TNetHttpClient; const url: String;
  encode: TEncoding; const cb: TGetStrProc): String;
var ss: TStringStream;
begin
  ss := TStringStream.Create('', encode);
  try
    if Assigned(cb) then begin
      cb('get' + #9 + url);
    end;
    try
      netHttp.Get(url, ss);
      Result := ss.DataString;
    except
      on e: Exception do begin
        raise e;
      end;
    end;
  finally
    ss.Free;
  end;
end;

function TfrmMain.get(const url: String;
  encode: TEncoding; const cb: TGetStrProc): String;
begin
  Result := getRaw(self.NetHTTPClient1, url, encode, cb);
end;

procedure TfrmMain.ToolButton1Click(Sender: TObject);

  procedure doRequest(const prov: string; const url: string; strs: TStrings);
  var html: string;
  begin
    html := get(url, TEncoding.GetEncoding(936),doUrlEvent);
    //
    THospitalParser.parserIt(prov, html, strs, doUrlEvent);
    //exit;
  end;

  procedure doIt(const S: string; strs: TStrings);
  var name, url: string;
  begin
    name := TCharSplit.getSplitFirst(S, #9);
    url := TCharSplit.getSplitLast(S, #9);
    //
    doRequest(name, url, strs);
  end;

var i: integer;
  S: string;
begin
  memoHospital.Clear;
  memoHospital.Lines.Add('省市' + #9 + '区县' + #9 +'医院名称' + #9 +	'URL');
  //memoHospital.Lines.Add('省市' + #9 + '区县' + #9 +'医院名称' + #9 +	'URL'
  //  + #9 + '级别' + '性质' + #9 + '简介' + #9 + '地址' + #9 + '路线' + #9 + '电话');
  for I := 1 to memoProvinces.Lines.Count - 1 do begin
    S := memoProvinces.Lines[I];
    //
    doIt(S, memoHospital.Lines);
    //exit;
  end;
end;

procedure TfrmMain.ToolButton2Click(Sender: TObject);
var html: string;
begin
  html := FHttpClt.get(self.cbxURL.Text, doUrlEvent);
  self.memoProvinces.Clear;
  memoProvinces.Lines.Add('省市' + #9 +	'URL');
  THospitalListParser.parserIt(html, memoProvinces.Lines, nil);
end;

procedure TfrmMain.ToolButton7Click(Sender: TObject);
  function doRequest(const prov: string; const url: string): string;
  var html: string;
  begin
    try
      html := get(url, TEncoding.GetEncoding(936),doUrlEvent);
    Except on e: Exception do begin
        addLog('invalid: ' + url);
      end;
    end;
    Result := THospitalDtlParser.parserIt(html, doUrlEvent);
  end;

  function doIt(const S: string): string;
  var url: string;
  begin
    url := TCharSplit.getSplitIdx(S, #9, 3).trim;
    if url='' then begin
      addLog('error:' + S);
    end else begin
      Result := doRequest(name, url);
    end;
  end;
var i: integer;
  S, str: string;
begin
  memoCtx.Clear;
  addCtx('省市' + #9 + '区县' + #9 +'医院名称' + #9 +	'URL'
    + #9 + '级别' + '性质' + #9 + '简介' + #9 + '地址' + #9 + '路线' + #9 + '电话');
  for I := 1 to memoHospital.Lines.Count - 1 do begin
    S := memoHospital.Lines[I];
    str := doIt(S);
    addCtx( S + #9 + str );
  end;
end;

end.
