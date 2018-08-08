unit uDataBase;

interface

type
  TDataBase = class(TObject)
  protected
    FTableName: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function startTrans(): string;
    class function commit(): string;
    //procedure setRow(const S: string);
    function getSql: string;
    //
    function getRow(const c: char=#9; const quoted: boolean=false): string; virtual; abstract;
    class function getColumn(const c: char=#9): string; virtual; abstract;
  end;

implementation

uses SysUtils, classes;

{ TDataBase }

constructor TDataBase.Create;
begin
end;

destructor TDataBase.Destroy;
begin
end;

class function TDataBase.startTrans: string;
begin
  Result := 'start transaction;' + #13#10 +
    '-- truncate table ;'; // + FTableName;
end;

class function TDataBase.commit: string;
begin
  Result := 'commit;';
end;

function TDataBase.getSql: string;
begin
  Result := 'insert into ' + FTableName +
    '(' +
      getColumn(#44) +
    ')' +
    ' value(' +
      getRow(#44, true) +
    ');'
end;

end.

