unit LMain;

interface

uses Windows, Forms, Messages, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxLabel, cxStyles, cxClasses, DB, dxLayoutLookAndFeels, ExtCtrls, Dialogs, ImgList, Controls,
  dxBar, cxBarEditItem, dxLayoutContainer, dxLayoutControl, ButtonGroup, MDIButtonGroup, Classes,
  cxGrid, cxGridCustomView, cxGridCustomTableView, cxCustomData, ODACThreads, SysUtils, Variants,
  cxProgressBar, cxButtons, cxContainer, cxEdit, cxLocalization, cxCheckBox, cxTextEdit;

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$SETPEFLAGS IMAGE_FILE_RELOCS_STRIPPED or IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED or IMAGE_FILE_LOCAL_SYMS_STRIPPED or IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

type
  TfrmMain = class(TForm)
    dxBarManager1: TdxBarManager;
    dxBarDockControl1: TdxBarDockControl;
    dxBarManager1Bar1: TdxBar;
    FileMenu: TdxBarSubItem;
    btnQuitApplication: TdxBarButton;
    serviceMenu: TdxBarSubItem;
    btnChangePassword: TdxBarButton;
    dxBarManager1Bar2: TdxBar;
    cxImageList: TcxImageList;
    btnReinintSession: TdxBarButton;
    ThreadTimer: TTimer;
    btnSaveExecutable: TdxBarButton;
    dxBarManager1Bar3: TdxBar;
    lblStatus: TcxBarEditItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    layoutLookAndFeel: TdxLayoutCxLookAndFeel;
    lcgRoot: TdxLayoutGroup;
    ThreadLayoutControl: TdxLayoutControl;
    MainStyleRepository: TcxStyleRepository;
    cxLookAndFeelController1: TcxLookAndFeelController;
    developerMenu: TdxBarSubItem;
    btnDEVMainMenu: TdxBarButton;
    btnDEVStyles: TdxBarButton;
    btnOpenApplication: TdxBarButton;
    btnDEVIcons: TdxBarButton;
    cxLocalizer1: TcxLocalizer;
    btnXLSwork: TdxBarButton;
    btnXLSUserWork: TdxBarButton;
    stBold: TcxStyle;
    procedure btnQuitApplicationClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnChangePasswordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnReinintSessionClick(Sender: TObject);
    procedure ThreadTimerTimer(Sender: TObject);
    procedure btnSaveExecutableClick(Sender: TObject);
    procedure btnDEVMainMenuClick(Sender: TObject);
    procedure btnDEVStylesClick(Sender: TObject);
    procedure btnOpenApplicationClick(Sender: TObject);
    // procedure MadExceptionHandler1Exception(const exceptIntf: IMEException; var handled: Boolean);
    procedure btnDEVIconsClick(Sender: TObject);
    procedure btnXLSworkClick(Sender: TObject);
    procedure btnXLSUserWorkClick(Sender: TObject);
  private
    procedure ApplicationShortCut(var Msg: TWMKey; var handled: Boolean);
    procedure ThreadStateChanged(const AThread: TODACThread);
    procedure fixDoMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint; var handled: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

procedure fixCXControlMouseWheel(const p_cxControl: TcxControl);

var
  frmMain: TfrmMain;

implementation

uses Graphics, SprApplications, GlobalVars, layoutForm, Utilities, ORARoles,
  ExportSettings, CalcTool, DataModule, ORALayoutCustomize, Ora, ORALayoutVGrid,
  cxDropDownEdit, StrUtils, Clipbrd, cxTL, dxBarCustomCustomizationForm,
  OraSQLEdit, ORAStyles, ORALayoutDropDown, ORALayoutGrid, ORALayoutTreeList, ORALayout,
  ORAMainMenu, PassChange, MemData, typinfo, OraImageListEditor, ORALayoutCard, XLS_work,
  XLS_user_work, ODACLib, ExcelApp
  // , ORALayoutChart
    ;

{$R *.dfm}

type
  TLayoutThreadProgressBar = class(TdxLayoutGroup)
    FODACThread: TODACThread;
    procedure OnClickProc(Sender: TObject);
  private
    procedure setThread(const Value: TODACThread);
  published
  public
    constructor Create(AOwner: TComponent); override;
    procedure updateFromThread;
    property Thread: TODACThread read FODACThread write setThread;
  end;

  TControlAccess = class(TControl);

procedure TfrmMain.fixDoMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var handled: Boolean);
var
  APoint: TPoint;
begin
  with TcxControl(Sender) do begin
    APoint := ScreenToClient(MousePos);
    if not PtInRect(ClientBounds, APoint) then Abort;
  end;
end;

procedure fixCXControlMouseWheel(const p_cxControl: TcxControl);
var
  I: Longint;
  procedure fixGridView(const p_View: TcxCustomGridTableView);
  var
    I: Longint;
  begin
    with p_View do
      for I := 0 to ItemCount - 1 do
        if Items[I].Properties is TcxCustomDropDownEditProperties then
            TcxCustomDropDownEditProperties(Items[I].Properties).UseMouseWheel := False;
  end;

begin
  TControlAccess(p_cxControl).OnMouseWheel := frmMain.fixDoMouseWheel;
  if p_cxControl is TcxGrid then
    with TcxGrid(p_cxControl) do
      for I := 0 to ViewCount - 1 do
        if Views[I] is TcxCustomGridTableView then fixGridView(TcxCustomGridTableView(Views[I]));

end;

type
  TcxGridFindPanelOptionsAccess = class(TcxGridFindPanelOptions);

procedure TfrmMain.ApplicationShortCut(var Msg: TWMKey; var handled: Boolean);
const
  VK_E = byte('E');
  VK_F = byte('F');
  VK_C = byte('C');
  VK_V = byte('V');
  VK_S = byte('S');
  VK_R = byte('R');
var
  gr: TcxCustomGrid;
  tl: TcxCustomTreeList;
  av: TcxCustomGridView;

begin
  if Screen.ActiveForm = nil then exit;

  gr := TcxCustomGrid(getParentByClass(Screen.ActiveForm.ActiveControl, TcxCustomGrid));
  tl := TcxCustomTreeList(getParentByClass(Screen.ActiveForm.ActiveControl, TcxCustomTreeList));
  if (gr = nil) and (tl = nil) then begin
    gr := TcxCustomGrid(getChildByClass(Screen.ActiveForm, TcxCustomGrid));
    if (gr <> nil) then begin
      av := gr.ActiveView;
      if (av <> nil) And (av is TcxCustomGridTableView) And
        (ssCtrl in KeyDataToShiftState(Msg.KeyData)) and (Msg.CharCode = VK_F) then begin
        TcxGridFindPanelOptionsAccess(TcxCustomGridTableView(av).FindPanel).FindPanel.Show;
        handled := True;
        exit;
      end;
    end;
    tl := TcxCustomTreeList(getChildByClass(Screen.ActiveForm, TcxCustomTreeList));
  end;

  if gr = nil then begin
    if tl = nil then exit;
    if (ssAlt in KeyDataToShiftState(Msg.KeyData)) and (Msg.CharCode = VK_E) then begin
      ExportSettingsShow(tl, tl.SelectionCount > 1);
      handled := True;
    end;
  end else begin
    av := gr.ActiveView;
    if av <> nil then begin
      if av is TcxCustomGridTableView then begin
        if (ssAlt in KeyDataToShiftState(Msg.KeyData)) and (Msg.CharCode = VK_C) then begin
          CalcToolShow(TcxCustomGridTableView(av));
          handled := True;
        end
        else if gr.Focused And
          (((KeyDataToShiftState(Msg.KeyData) = [ssShift]) And (Msg.CharCode = VK_INSERT)) or
          ((KeyDataToShiftState(Msg.KeyData) = [ssCtrl]) And (Msg.CharCode = VK_V))) then begin
          if (TcxCustomGridTableView(av).Controller.EditingItem = nil) And
            (not TcxGridFindPanelOptionsAccess(TcxCustomGridTableView(av).FindPanel)
            .FindPanel.Visible) And ((av.DataController.EditOperations * [dceoAppend, dceoInsert])
            <> []) then begin
            pasteToTableView(Clipboard.AsText, TcxCustomGridTableView(av));
            handled := True;
          end
        end;
        if handled then exit;
      end;
      if (ssAlt in KeyDataToShiftState(Msg.KeyData)) and (Msg.CharCode = VK_E) then begin
        ExportSettingsShow(TcxGrid(gr), av.DataController.GetSelectedCount > 1);
        handled := True;
      end;
    end;
  end;
end;

procedure TfrmMain.btnSaveExecutableClick(Sender: TObject);
var
  v: Longint;
  F: TFileStream;
  vExeTable: String;
begin
  vExeTable := DLookUpParam(mainSession,
    'select owner || ''.'' || object_name from all_objects where object_name = ''EXECUTABLE_FILES'' order by case owner when upper(:p_scheme) then 0 else 1 end',
    VarArrayOf(['p_scheme', ftWideString, mainSession.Schema]));

  if vExeTable = 'no data found' then showmessage('������� ����������� ������� �� �������')
  else begin
    if MessageDlg('����������� ���������� ����������� ����������', mtConfirmation, mbYesNo, 0) <>
      mrYes then exit;
    v := 0;
    F := TFileStream.Create(Application.ExeName, fmOpenRead or fmShareDenyNone);
    try
      with stdOracleQuery(self) do
        try
          SQL.Text := 'begin' + #13#10 + '  delete from ' + vExeTable +
            ' f where f.project_name = :project_name || ''_prev'';' + #13#10 + '  update ' +
            vExeTable +
            ' f set f.project_name = :project_name || ''_prev'' where f.project_name = :project_name;'
            + #13#10 + 'end;';
          Params.ParamByName('project_name').AsString := ApplicationName;
          Execute;
          v := -1;
        finally
          if v <> -1 then Session.Rollback;
          Free;
        end;
      with stdOracleQuery(self) do
        try
          SQL.Text := 'select e.project_name, e.exefile, e.rowid from ' + vExeTable +
            ' e where null is not null';
          open;
          Insert;
          FieldByName('project_name').Value := ApplicationName;
          TBlobField(FieldByName('exefile')).LoadFromStream(F);
          Post;
          Session.Commit;
          v := -1;
        finally
          if v <> -1 then Session.Rollback;
          Free;
        end;
    finally
      v := Round(F.Size / 1024);
      F.Free;
    end;
    showmessage('���������� ���������� ���������! (' + IntToStr(v) + '��)');
  end;
end;

procedure TfrmMain.btnXLSUserWorkClick(Sender: TObject);
begin
  showXLSUserWork;
end;

procedure TfrmMain.btnXLSworkClick(Sender: TObject);
begin
  showXLSworkSettings;
end;

procedure TfrmMain.btnReinintSessionClick(Sender: TObject);
begin

  if Sender <> nil then reinit_session;

  loadORARoles;
  loadORAMenuItems(0, dxBarManager1);
  developerMenu.Visible := ivNever;
  if Developer_ORADBRole in userRoles then begin
    developerMenu.Visible := ivAlways;
    if developerMenu.LinkCount = 0 then dxBarManager1Bar1.ItemLinks.add.Item := developerMenu;
  end;
  frmMain.lblStatus.Caption := '������ �� ' + StartVersionApp;
  loadORAImageList(0, cxImageList);
  loadORAStyles(0, HostInterface.LayoutStyleRepository);

  if userRoles = [] then begin
    Caption := '� ������������ ' + mainSession.Username + ' ��� ���� ��� ���������� "' +
      mainSession.Schema + '"';
  end else begin
    Caption := mainCaption + ' [' + mainSession.Username + ': ' + userFIO + ']';
  end;

  if FileMenu.LinkCount = 0 then dxBarManager1Bar1.ItemLinks.add.Item := FileMenu;
  if serviceMenu.LinkCount = 0 then dxBarManager1Bar1.ItemLinks.add.Item := serviceMenu;
  if btnOpenApplication.LinkCount = 0 then FileMenu.ItemLinks.add.Item := btnOpenApplication;

  SetProcessWorkingSetSize(GetCurrentProcess, DWORD(-1), DWORD(-1));
end;

procedure TfrmMain.btnDEVIconsClick(Sender: TObject);
var
  AEditor: TORAImageListEditor;
begin
  AEditor := TORAImageListEditor.Create;
  try
    AEditor.Edit(cxImageList);
  finally
    FreeAndNil(AEditor);
  end;
end;

procedure TfrmMain.btnDEVMainMenuClick(Sender: TObject);
var
  vBarCustomizationFormClass: TdxBarCustomCustomizationFormClass;
begin
  vBarCustomizationFormClass := dxBarCustomizationFormClass;
  try
    dxBarCustomizationFormClass := TORAMainMenuCustomizationForm;
    dxBarManager1.Customizing(True);
    dxBarCustomizationFormClass := TORAMainMenuCustomizationForm;
  finally
    dxBarCustomizationFormClass := vBarCustomizationFormClass;
  end;
end;

procedure TfrmMain.btnQuitApplicationClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmMain.btnChangePasswordClick(Sender: TObject);
begin
  ChangePassword(ODACChangePassword);
end;

procedure TfrmMain.btnDEVStylesClick(Sender: TObject);
begin
  editLayoutStyles;
end;

procedure TfrmMain.btnOpenApplicationClick(Sender: TObject);
var
  vScheme: string;
begin
  vScheme := selectAppSchema;
  if vScheme <> '' then begin
    set_session_scheme(vScheme);
    btnReinintSessionClick(btnReinintSession);
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  timer: TDateTime;
begin
  TODACThread.ThreadList.Terminate;
  timer := Now;
  while ((Now - timer) * 24 * 60 * 60 < 5) and (TODACThread.ThreadList.Count > 0) do
      Application.HandleMessage;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ResStream: TResourceStream;
  vSchema: String;
  vStartCardClass: TCustomFormClass;
  vStartCard: TCustomForm;
begin
  layoutForm.MainFormTabControl := TMDIButtonGroup.Create(self);
  with layoutForm.MainFormTabControl do begin
    ButtonWidth := 150;
    Parent := self;
    Images := cxImageList;
    Align := alBottom;
    HotButtonColor := $00EFD3C6;
    RegularButtonColor := clBtnFace;
    SelectedButtonColor := clHighlightText;
  end;

  HostInterface.MainBarManager := dxBarManager1;
  HostInterface.LayoutStyleRepository := MainStyleRepository;
  HostInterface.LayoutImages := cxImageList;

  TODACThread.ThreadList.OnStateChanged := ThreadStateChanged;
  ThreadLayoutControl.Width := Screen.Width div 6;
  Application.OnShortCut := ApplicationShortCut;

  ResStream := nil;
  try
    ResStream := TResourceStream.Create(HInstance, 'russian', RT_RCDATA);
    with cxLocalizer1 do begin
      LoadFromStream(ResStream);
      Active := True;
      LanguageIndex := 1049;
      Translate;
    end;
    ResStream.Free;
  except
    if Assigned(ResStream) then ResStream.Free;
  end;

  if ParamCount < 1 then begin
    showmessage('� ������ ������� ���������� ������� �����/��� �������' + #13#10 +
      '(������: 192.168.1.113:1521:SID=myBD)');
    self.Close;
    Application.Terminate;
    exit;
  end;

  vStartCardClass := TCustomFormClass(getclass('TfrmStartCard'));
  if vStartCardClass <> nil then begin
    vStartCard := vStartCardClass.Create(self);
    vStartCard.Show;
  end
  else vStartCard := nil;

  if init_session(ParamStr(1)) then begin
    vStartCard.Free;
    if ParamCount > 1 then vSchema := ParamStr(2)
    else vSchema := selectAppSchema;

    if (vSchema <> '') And set_session_scheme(vSchema) then begin
      btnReinintSessionClick(nil);
      SetProcessWorkingSetSize(GetCurrentProcess, DWORD(-1), DWORD(-1));
      exit;
    end;
  end;

  self.Close;
  Application.Terminate;
  exit;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  layoutForm.MainFormTabControl := nil;
  mainSession.Free;
end;

procedure TfrmMain.ThreadStateChanged(const AThread: TODACThread);
var
  vItem: TLayoutThreadProgressBar;
  I: Integer;
  v: TControl;
begin
  if csDestroying in ComponentState then exit;
  vItem := nil;
  with lcgRoot do
    for I := 0 to Count - 1 do
      if Items[I] is TLayoutThreadProgressBar then begin
        if TLayoutThreadProgressBar(Items[I]).Thread = AThread then begin
          vItem := Items[I] as TLayoutThreadProgressBar;
          break;
        end;
      end;
  if AThread.IndexOf <> -1 then begin
    if vItem = nil then begin
      vItem := TLayoutThreadProgressBar(lcgRoot.CreateGroup(TLayoutThreadProgressBar));
      vItem.Thread := AThread;
    end;
    vItem.updateFromThread;
  end else begin
    if vItem <> nil then
      with vItem do begin
        Parent := nil;
        while Count > 0 do begin
          v := TdxLayoutItem(Items[0]).Control;
          TdxLayoutItem(Items[0]).Control := nil;
          Items[0].Free;
          v.Free;
        end;
        Free;
      end;
  end;
  ThreadLayoutControl.Visible := lcgRoot.Count <> 0;
  ThreadTimer.Enabled := ThreadLayoutControl.Visible;
end;

procedure TfrmMain.ThreadTimerTimer(Sender: TObject);
var
  I: Integer;
begin
  with lcgRoot do
    for I := Count - 1 downto 0 do
      if Items[I] is TLayoutThreadProgressBar then
          ThreadStateChanged(TLayoutThreadProgressBar(Items[I]).Thread);
end;

{ TLayoutThreadProgressBar }

constructor TLayoutThreadProgressBar.Create(AOwner: TComponent);
begin
  FODACThread := nil;
  inherited;
  LayoutDirection := ldHorizontal;
  AlignHorz := ahClient;
  ShowBorder := False;
end;

procedure TLayoutThreadProgressBar.OnClickProc(Sender: TObject);
begin
  if FODACThread = nil then begin
    Visible := False;
  end else begin
    if MessageDlg('�� ������ ��������� ��������� �������?', mtConfirmation, mbYesNo, 0) <>
      mrYes then exit;
    if FODACThread.IndexOf <> -1 then FODACThread.Terminate;
  end;
end;

procedure TLayoutThreadProgressBar.setThread(const Value: TODACThread);
const
  cHeight: Integer = 21;
begin
  FODACThread := Value;
  with TcxProgressBar(CreateItemForControl(TcxProgressBar.Create(frmMain)).Control) do begin
    Caption := '';
    Height := cHeight;
    with Properties do begin
      BarStyle := cxbsAnimation;
      BarStyle := cxbsGradient;
      AnimationSpeed := 1;
      BeginColor := $0000D328;
      SolidTextColor := True;
      ShowTextStyle := cxtsText;
      Marquee := True;
      AnimationPath := cxapPingPong;
    end;
  end;
  Items[0].AlignHorz := ahClient;
  with TcxButton(CreateItemForControl(TcxButton.Create(frmMain)).Control) do begin
    Width := cHeight;
    Height := cHeight;
    // LookAndFeel.Kind := lfFlat;
    OnClick := OnClickProc;
    PaintStyle := bpsGlyph;
    with OptionsImage do begin
      Images := frmMain.cxImageList;
      ImageIndex := 79;
    end;
  end;
end;

procedure TLayoutThreadProgressBar.updateFromThread;
begin
  if FODACThread = nil then exit;

  with TcxProgressBar(TdxLayoutItem(Items[0]).Control), TcxProgressBarProperties(Properties) do
  begin
    Max := FODACThread.TotalSteps;
    EditValue := FODACThread.CurrentStep;
    Text := FODACThread.StateText;
    if FODACThread is TODACOracleQueryThread then
      with stdOracleQuery do
        try
          SQL.Text := 'select s.CLIENT_INFO from V$USER_SESSION s where s.sid=:P_ID';
          Params.ParamByName('p_ID').AsString := TODACOracleQueryThread(FODACThread).SessionID;
          try
            Active := True;
          except
          end;
          if not EOF then Text := Text + ';' + FieldByName('CLIENT_INFO').AsString;
        finally
          Free;
        end;
  end;
end;

procedure SetORAProperty(const p_command: String);
var
  vInstance: TObject;
  vComms: TStringList;
  vStrs: TStringList;
  I, II: Integer;
  vPropInfo: PPropInfo;
begin
  if Screen.ActiveForm is TfrmORALayout then begin
    vComms := TStringList.Create;
    try
      vComms.Text := p_command;
      vStrs := TStringList.Create;
      try
        for II := 0 to vComms.Count - 1 do begin
          vStrs.Text := ReplaceStr(ReplaceStr(vComms[II], '.', #13#10), ':=', #13#10);
          vInstance := getChildByName(Screen.ActiveForm, vStrs[0]);
          if vInstance = nil then showmessage('����������� ��������� �: ' + vComms[II])
          else if vStrs.Count < 2 then showmessage('�������� ��������� �: ' + vComms[II])
          else begin
            vPropInfo := nil;
            for I := 1 to vStrs.Count - 2 do begin
              vPropInfo := GetPropInfo(vInstance, vStrs[I]);
              if vPropInfo = nil then begin
                showmessage('����������� ������������� ' + vStrs[I] + ' �: ' + vComms[II]);
                exit;
              end;
              if vPropInfo^.PropType^.Kind = tkClass then
                  vInstance := TObject(GetOrdProp(vInstance, vPropInfo));
            end;
            if vPropInfo <> nil then SetPropValue(vInstance, vPropInfo, vStrs[vStrs.Count - 1]);
          end;
        end;
      finally
        vStrs.Free;
      end;
    finally
      vComms.Free;
    end;
  end;
end;

procedure App_preLayoutButtonClick(const pORALayout: IORALayoutInterface);
begin
  with pORALayout do begin
    Values['SHOW_CLASS_NAME'] := '';
    Values['SHOW_PARAM_IN'] := '';
    Values['SHOW_PARAM_IN2'] := '';
    Values['SHOW_PARAM_IN3'] := '';
    Values['SHOW_PARAM_OUT'] := '';
  end;
end;

procedure App_afterLayoutButtonClick(const pORALayout: IORALayoutInterface;
  const pClickQuery: TOraQuery);
var
  vShowName: String;
  vShowParamIN: String;
  vShowParamIN2: String;
  I: Integer;
  vReportMode: TReportMode;
  vPath: String;
  vRep: TxlsReportThread;
  vXlsWork: TxlsWorkThread;
  v: OleVariant;
const
  cShowClassNames: array [0 .. 8] of String = ('showORAForm', 'XLSReport', 'showORAForm_DEV',
    'askUser', 'paste2DB', 'runQueryThread', 'save_XLS2DB', 'send_DB2XLS', 'SetProperty');
begin
  with pORALayout do begin
    vShowName := Values['SHOW_CLASS_NAME'];
    if vShowName <> '' then begin
      vShowParamIN := Values['SHOW_PARAM_IN'];
      vShowParamIN2 := Values['SHOW_PARAM_IN2'];
      case AnsiIndexStr(vShowName, cShowClassNames) of
        0: if Values['SHOW_PARAM_OUT'] = '' then showORAForm(vShowParamIN, '', vShowParamIN2)
          else Values['SHOW_PARAM_OUT'] := askORAForm(vShowParamIN, vShowParamIN2,
              Values['SHOW_PARAM_OUT']);
        1: if VarIsNumeric(vShowParamIN) then begin
            vReportMode := rmUser;
            vPath := '';
            if vShowParamIN2 = 'SAVE_TEMPLATE' then begin
              save_XLS_report(StrToInt(vShowParamIN));
            end else begin
              if vShowParamIN2 = 'DEVELOPER_MODE' then vReportMode := rmDesigner
              else if vShowParamIN2 = 'TEMPLATE' then vReportMode := rmTemplate
              else if DirectoryExists(vShowParamIN2, False) then vPath := vShowParamIN2;

              vRep := TxlsReportThread.Create(StrToInt(vShowParamIN), vPath, vReportMode);
              if pClickQuery <> nil then
                with pClickQuery do
                  for I := 0 to ParamCount - 1 do
                      vRep.Params.Value[Params[I].Name] := Params[I].AsString;
              vRep.Start;
            end;
          end
          else showmessage('������������ �������� ��������� "SHOW_PARAM_IN" ' + vShowParamIN);
        2: showORAForm(vShowParamIN, Values['SHOW_PARAM_IN3'], vShowParamIN2, True);
        3: Values['SHOW_PARAM_OUT'] := ModalResult2String(MessageDlg(vShowParamIN, mtConfirmation,
            String2ModalButton(vShowParamIN2), 0));
        4: paste2DB(vShowParamIN);
        5: begin
            if (vShowParamIN2 = '') Or (MessageDlg(vShowParamIN2, mtConfirmation, mbYesNo, 0)
              = mrYes) then
              with TODACOracleQueryThread.Create(True) do
                try
                  FreeOnTerminate := True;
                  FetchAllRecords := False;
                  Query := stdOracleQuery(nil, clone_session);
                  Query.SQL.Text := vShowParamIN;
                  doBeforeExecute(Query);
                  Start;
                except
                  on E: Exception do begin
                    Free;
                    MessageDlg(GetLayoutName + '-' + vShowName + ':' + #13#10 + E.Message, mtError,
                      [mbOK], 0);
                  end;
                end;
          end;
        6: save_XLS2DB(vShowParamIN, vShowParamIN2, Values['SHOW_PARAM_IN3']);
        7: if ExcelSemafor.get_cells(vShowParamIN, '1', Values[stdXLSParamNames[spkCELL]], @v) then
          begin
            if ((vShowParamIN2 = '') Or (MessageDlg(vShowParamIN2, mtConfirmation, mbYesNo,
              0) = mrYes)) then begin
              vXlsWork := TxlsWorkThread.Create(vShowParamIN, True);
              if pClickQuery <> nil then
                with pClickQuery do
                  for I := 0 to ParamCount - 1 do
                      vXlsWork.Params.Value[Params[I].Name] := Params[I].AsString;
              vXlsWork.Start;
            end
          end
          else showmessage('������ "' + Values[stdXLSParamNames[spkCELL]] + '" �� ����� "' +
              vShowParamIN + '" �� ��������');
        8: SetORAProperty(ReplaceStr(vShowParamIN, ' ', ''));
      else showmessage('����������� �������� ��������� "SHOW_CLASS_NAME" ' + vShowName);
      end;
    end;
  end;
end;

function getXLSWorksheets(const pScanOptions: byte): string;
begin
  Result := ExcelApp.getXLSWorksheets(TXLSScanOptions(pScanOptions));
end;

initialization

HostInterface.clone_session := GlobalVars.clone_session;
HostInterface.preLayoutButtonClick := App_preLayoutButtonClick;
HostInterface.afterLayoutButtonClick := App_afterLayoutButtonClick;

HostInterface.showORAForm := DataModule.showORAForm;
HostInterface.saveORAForm := DataModule.saveORAForm;
HostInterface.set_ORAForm_notes := DataModule.set_ORAForm_notes;
HostInterface.get_ORAForm_notes := DataModule.get_ORAForm_notes;

HostInterface.loadORAMenuItems := DataModule.loadORAMenuItems;
HostInterface.saveORAMenuItems := DataModule.saveORAMenuItems;

HostInterface.saveORAStyles := DataModule.saveORAStyles;

HostInterface.getXLSWorksheets := getXLSWorksheets;

MemData.StartWaitProc := nil;
MemData.StopWaitProc := nil;

end.
