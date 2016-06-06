unit SprApplications;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, layoutForm, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutContainer, dxLayoutControl, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, DB, cxDBData, DBAccess, Ora,
  MemDS, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, dxLayoutControlAdapters, Menus, StdCtrls, cxButtons, cxImage;

type
  TfrmSprApplications = class(TfrmLayout)
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    dxLayoutControl1Item1: TdxLayoutItem;
    oqApplications: TOraQuery;
    cxGrid1DBTableView1OWNER: TcxGridDBColumn;
    cxGrid1DBTableView1APP_NAME: TcxGridDBColumn;
    btnOK: TcxButton;
    dxLayoutControl1Item2: TdxLayoutItem;
    cxGrid1DBTableView1ICON: TcxGridDBColumn;
    dsApplications: TDataSource;
    dxLayoutControl1Group1: TdxLayoutGroup;
    btnCancel: TcxButton;
    dxLayoutControl1Item3: TdxLayoutItem;
    procedure cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState;
      var AHandled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function selectAppSchema: String;

implementation

uses GlobalVars;
{$R *.dfm}

function selectAppSchema: String;
var
  f: TfrmSprApplications;
begin
  Result := '';
  f := TfrmSprApplications.Create(Application);
  with f do
    try
      oqApplications.Session := mainSession;
      oqApplications.Open;
      if ShowModal = mrOk then Result := oqApplications.FieldByName('OWNER').AsString;
    finally
      Free;
    end;
end;

procedure TfrmSprApplications.cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState;
  var AHandled: Boolean);
begin
  inherited;
  ModalResult := mrOk;
end;

end.
