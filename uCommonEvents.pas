unit uCommonEvents;

interface

//uses u;

type
  TBooleanFunc = function(): boolean of object;
  TGetStrFunc = function(const S: string): String of object;
  TGetObjectProc = function(const brand: TObject):boolean of object;
  {TGetBrandOemProc = function(const brand: TCarBrand;
    const carOem: TCarOem):boolean of object;}
  {TGetBrandSysProc = function(const brand: TCarBrand;
    var carSys: TCarSys):boolean of object;
  TGetBrandSysTypeProc = function(const brand: TCarBrand;
    const carSys: TCarSys; var carType: TCarType):boolean of object;}

implementation

end.

