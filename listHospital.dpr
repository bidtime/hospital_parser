program listHospital;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {frmMain},
  HtmlParser_XE3UP in '..\delphiutils\src\utils\HtmlParser_XE3UP.pas',
  uCharSplit in '..\delphiutils\src\utils\uCharSplit.pas',
  uCharUtils in '..\delphiutils\src\utils\uCharUtils.pas',
  uNetHttpClt in '..\delphiutils\src\utils\uNetHttpClt.pas',
  uNetUtils in '..\delphiutils\src\utils\uNetUtils.pas',
  uParserUtils in '..\delphiutils\src\utils\uParserUtils.pas',
  uStrUtils in '..\delphiutils\src\utils\uStrUtils.pas',
  uFileUtils in '..\delphiutils\src\utils\uFileUtils.pas',
  uHospital in 'uHospital.pas',
  uDataBase in 'uDataBase.pas',
  uHttpParserBase in 'uHttpParserBase.pas',
  uCommonEvents in 'uCommonEvents.pas',
  uHospitalListParser in 'uHospitalListParser.pas',
  uMyTextFile in '..\delphiutils\src\utils\uMyTextFile.pas',
  uHospitalParser in 'uHospitalParser.pas',
  uHospitalDtlParser in 'uHospitalDtlParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
