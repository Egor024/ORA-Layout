unit Reports;

interface

uses
  Windows, SysUtils, Variants, Forms, layoutForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters,
  ODACThreads, cxGridCustomView, cxGrid, Classes, Controls, dxLayoutControl, Dialogs, ShlObj,
  cxShellCommon, DBAccess, Ora, MemDS, cxTextEdit, cxMemo, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, DB, cxDBData, cxButtonEdit, ComCtrls, cxContainer,
  dxLayoutContainer, dxLayoutcxEditAdapters, cxMaskEdit, cxDropDownEdit, cxShellComboBox,
  OleServer, ComObj, Ole2, ActiveX,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, ExcelApp, cxClasses;

type
  TfrmXLSReports = class(TfrmLayout)
    tvReports: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    tvReportsID: TcxGridDBColumn;
    tvReportsREPORT_NAME: TcxGridDBColumn;
    tvReportsFILE_NAME: TcxGridDBColumn;
    tvReportsDESCRIPTION: TcxGridDBColumn;
    dxLayoutControl1Item2: TdxLayoutItem;
    dxLayoutControl1Group1: TdxLayoutGroup;
    bePathForReports: TcxShellComboBox;
    dxLayoutControl1Item1: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    odReports: TOraQuery;
    dsReports: TOraDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure bePathForReportsPropertiesEditValueChanged(Sender: TObject);
    procedure fileButtonClick(Sender: TObject; AButtonIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Utilities, GlobalVars, dataModule, LMain, XLS_work;

{$R *.dfm}

const
  cReportPathRegName: String = 'Report path';

var
  frmXLSReports: TfrmXLSReports = nil;

procedure showXLSReportsSettings;
begin
  if frmXLSReports <> nil then frmXLSReports.BringToFront
  else begin
    frmXLSReports := TfrmXLSReports.Create(Application);
    frmXLSReports.Show;
  end;
end;

procedure TfrmXLSReports.bePathForReportsPropertiesEditValueChanged(Sender: TObject);
begin
  inherited;
  bePathForReports.EditValue := TcxShellComboBox(Sender).EditValue;
  LoadStringIntoRegistry(ApplicationName, cReportPathRegName, bePathForReports.EditValue);
end;

procedure TfrmXLSReports.fileButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  V: Variant;
begin
  V := tvReportsID.EditValue;
  if not VarIsNumeric(V) then begin
    showmessage('Не указан ID отчета');
    tvReportsID.Focused := True;
    exit;
  end;
  if AButtonIndex = 0 then begin
      TxlsReportThread.Create(V, '', rmTemplate).Start;
  end
  else
    with tvReports.Controller do
      if (AButtonIndex = 1) and (EditingItem = tvReportsFILE_NAME) then begin
        EditingController.HideEdit(True);
        if odReports.State in [dsInsert, dsEdit] then odReports.Post;
        save_XLS_report(V, tvReportsFILE_NAME.EditValue);
        odReports.RefreshRecord;
      end;
end;

procedure TfrmXLSReports.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmXLSReports := nil;
end;

procedure TfrmXLSReports.FormCreate(Sender: TObject);
begin

  bePathForReports.EditValue := ReadStringFromRegistry(ApplicationName, cReportPathRegName);
  if bePathForReports.EditValue = '' then bePathForReports.EditValue := defaultFilePath;

  IconIndex := 112;
  inherited;
  with odReports do begin
    Session := mainSession;
    SQL.text := 'select x.id, x.report_name, x.file_name, x.rowid, x.description from ' +
      mainSession.Schema + '.V_XLS_REPORTS x order by x.id';
    open;
  end;

end;

end.
