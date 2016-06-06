unit DataModule;

interface

uses
  Windows, Forms, Classes, SysUtils, Ora, Variants, GlobalVars, XMLDoc, XMLIntf, cxStyles, Graphics,
  cxCustomData, cxGraphics, cxGridDBTableView, DB, dxmdaset, ORALayout, Controls, dxBar, ORARoles;

function showORAForm(const p_name: String; const p_version: String = '';
  const p_initPLSQL: String = ''; p_DeveloperMode: Boolean = False): TfrmORALayout;
function askORAForm(const p_name: String; const p_initPLSQL: String;
  p_ResultControl: String): String;
procedure saveORAForm(const p_form: TfrmORALayout);
procedure set_ORAForm_notes(const p_form_name: string; const p_notes: String);
function get_ORAForm_notes(const p_form_name: string): String;

function get_user_param(const p_form_name: String; p_param_name: String): String;
procedure set_user_param(const p_form_name: String; const p_param_name: String;
  const p_value: String);
procedure get_user_bparam(const pStream: TStream; const p_form_name: String; p_param_name: String);
procedure set_user_bparam(const p_form_name: String; const p_param_name: String;
  const pStream: TStream);
procedure clear_user_params(const p_form_name: String);

procedure loadORARoles;
procedure loadORAMenuItems(const p_menu_ID: Longint; const pBarManager: TdxBarManager);
procedure saveORAMenuItems(const p_menu_ID: Longint; const pBarManager: TdxBarManager);

procedure loadORAStyles(const pStyleRepositoryID: Longint;
  const pStyleRepository: TcxStyleRepository);
procedure saveORAStyles(const pStyleRepositoryID: Longint;
  const pStyleRepository: TcxStyleRepository);

procedure loadORAImageList(const pImageListID: Longint; const pImageList: TcxImageList);
procedure saveORAImageList(const pImageListID: Longint; const pImageList: TcxImageList);

function compMask(const cStr, cMask: string; pCaseSensitive: Boolean = False): Boolean;

procedure save_XLS2DB(const p_def: String; const p_xls_file: String; const p_sheet: String);

procedure paste2DB(const p_def1: string; const p_delimiter: String = #9);

implementation

Uses cxDBData, OraClasses, Masks, Dialogs, Clipbrd, cxClasses, TypInfo, LMain,
  ORALayoutCustomize, layoutForm, MemData, ExcelApp, ComObj, Ole2, ShowProgress;

type
  TcxDBDataFieldAccess = class(TcxDBDataField);

procedure paste2DB(const p_def1: string; const p_delimiter: String = #9);
begin
  if not Clipboard.HasFormat(CF_TEXT) then exit;
  with stdOracleQuery do
    try
      SQL.Text := 'begin ' + mainSession.Schema +
        '.clipboard2tmptable(:p_def1,:p_clpbrd,:p_delimiter); end;';
      Params.ParamByName('p_def1').AsString := p_def1;
      Params.ParamByName('p_delimiter').AsString := p_delimiter;
      with Params.ParamByName('p_clpbrd') do begin
        ParamType := ptInput;
        DataType := ftOraBlob;
        with AsOraBlob do begin
          OCISvcCtx := Session.OCISvcCtx;
          CreateTemporary(ltBlob);
          AsWideString := Clipboard.AsText + #13#10;
          WriteLob;
        end;
      end;
      execute;
    finally
      Free;
    end;
end;

procedure loadORARoles;
begin
  allOraDBRoles.Clear;
  allOraDBRoles.Add(TORADBRole.Create(Developer_ORADBRole, 'dev', 'Разработчик'));
  with stdOracleQuery do
    try
      SQL.Text := 'select id, brief, name from ' + mainSession.Schema +
        '.V_SPR_ROLES t where id <> 0 order by id';
      try
        open;
      except
      end;
      while not EOF do begin
        allOraDBRoles.Add(TORADBRole.Create(FieldByName('id').AsInteger,
          FieldByName('brief').AsString, FieldByName('name').AsString));
        next;
      end;
    finally
      Free;
    end;
end;

function compMask(const cStr, cMask: string; pCaseSensitive: Boolean): Boolean;
begin
  if pCaseSensitive then Result := MatchesMask(cStr, cMask)
  else Result := MatchesMask(AnsiLowerCase(cStr), AnsiLowerCase(cMask));
end;

type
  TReaderAccess = class(TReader);

procedure loadORAStyles(const pStyleRepositoryID: Longint;
  const pStyleRepository: TcxStyleRepository);
var
  aStream: TStream;
begin
  if mainSession.Schema = '' then exit;
  with stdOracleQuery do
    try
      SQL.Text := 'select t.* from ' + mainSession.Schema + '.FRM_STYLES t where t.id = :ID';
      Params.ParamByName('ID').AsInteger := pStyleRepositoryID;
      try
        open;
      except
      end;
      if not EOF then begin
        aStream := CreateBlobStream(FieldByName('style'), bmRead);
        try
          if aStream.Size > 0 then
            with TReader.Create(aStream, 2048) do
              try
                pStyleRepository.Clear;
                ReadRootComponent(pStyleRepository);
              finally
                Free;
              end;
        finally
          aStream.Free;
        end;
      end;
      Close;
    finally
      Free;
    end;
end;

procedure saveORAStyles(const pStyleRepositoryID: Longint;
  const pStyleRepository: TcxStyleRepository);
var
  aStream: TStream;
begin
  with stdOracleQuery do
    try
      SQL.Text := 'select t.*, t.rowid from ' + mainSession.Schema +
        '.FRM_STYLES t where t.id = :ID';
      Params.ParamByName('ID').AsInteger := pStyleRepositoryID;
      open;
      if EOF then Insert
      else Edit;
      FieldByName('ID').AsInteger := pStyleRepositoryID;
      aStream := CreateBlobStream(FieldByName('style'), bmWrite);
      try
        with TWriter.Create(aStream, 2048) do
          try
            WriteRootComponent(pStyleRepository);
          finally
            Free;
          end;
      finally
        aStream.Free;
      end;
      Post;
      Close;
      Session.Commit;
    finally
      Free;
    end;
end;

procedure loadORAImageList(const pImageListID: Longint; const pImageList: TcxImageList);
var
  vImageList: TComponent;
begin
  if mainSession.Schema = '' then exit;
  with stdOracleQuery do
    try
      SQL.Text := 'select t.images from ' + mainSession.Schema + '.FRM_MENUS t where t.id = :ID';
      Params.ParamByName('ID').AsInteger := pImageListID;
      try
        open;
      except
      end;
      if not EOF then begin
        with CreateBlobStream(FieldByName('images'), bmRead) do
          try
            if Size <> 0 then begin
              vImageList := ReadComponent(nil);
              try
                pImageList.Clear;
                pImageList.Assign(vImageList);
              finally
                vImageList.Free;
              end;
            end;
          finally
            Free;
          end;
      end;
      Close;
    finally
      Free;
    end;
end;

procedure saveORAImageList(const pImageListID: Longint; const pImageList: TcxImageList);
begin
  with stdOracleQuery do
    try
      SQL.Text := 'select t.ID, t.images, t.rowid from ' + mainSession.Schema +
        '.FRM_MENUS t where t.id = :ID';
      Params.ParamByName('ID').AsInteger := pImageListID;
      open;
      if EOF then Insert
      else Edit;
      FieldByName('ID').AsInteger := pImageListID;
      with CreateBlobStream(FieldByName('images'), bmWrite) do
        try
          WriteComponent(pImageList);
        finally
          Free;
        end;
      Post;
      Close;
      Session.Commit;
    finally
      Free;
    end;
end;

procedure loadORAMenuItems(const p_menu_ID: Longint; const pBarManager: TdxBarManager);
var
  aClass: TPersistentClass;
  aItem, aOldItem: TComponent;
  aStream: TStream;
  iLinksOwner: IdxBarLinksOwner;
  I: Longint;
  chk: Boolean;
  function get_item_by_name(const pName: String): TComponent;
  begin
    with pBarManager do begin
      Result := GetItemByName(pName);
      if Result = nil then Result := BarByComponentName(pName);
    end;
  end;
  procedure read_links(const pStream: TStream; const pItemLinks: TdxBarItemLinks);
  var
    aItemName: String;
    aLink: TdxBarItemLink;
    aItem: TdxBarItem;
  begin
    aLink := nil;
    with pItemLinks do
      while Count > 0 do items[0].Free;

    with TReaderAccess(TReader.Create(pStream, 2048)) do
      try
        ReadListBegin;
        while not EndOfList do
          with pItemLinks do begin
            aItemName := ReadString;
            if pItemLinks = nil then aItem := nil
            else aItem := pBarManager.GetItemByName(aItemName);
            if aItem <> nil then aLink := Add(aItem);
            ReadListBegin;
            while not EndOfList do
              if aItem <> nil then ReadProperty(aLink)
              else SkipProperty;
            ReadListEnd;
          end;
        ReadListEnd;
      finally
        Free;
      end;
  end;

begin
  with pBarManager do
    repeat
      chk := False;
      for I := 0 to itemCount - 1 do begin
        chk := (items[I].ClassName <> 'TdxBarButton') And (items[I].ClassName <> 'TdxBarSubItem')
          and (items[I].ClassName <> 'TcxBarEditItem');
        if chk then begin
          items[I].Free;
          break;
        end;
      end;
    until not chk;

    if mainSession.Schema = '' then exit;
  with stdOracleQuery do
    try
      SQL.Text := 'select m.name, m.icon from ' + mainSession.Schema + '.FRM_MENUS m' + #13#10 +
        ' where m.id = :menu_id';
      Params.ParamByName('menu_id').AsInteger := p_menu_ID;
      try
        open;
        mainCaption := FieldByName('name').AsString;
        aStream := CreateBlobStream(FieldByName('icon'), bmRead);
        try
          if aStream.Size > 0 then Application.Icon.LoadFromStream(aStream);
        finally
          aStream.Free;
        end;
      except
        on E: Exception do begin
          // ShowMessage(E.Message);
          exit;
        end;
      end;
      if Developer_ORADBRole in userRoles then
          SQL.Text := 'select mi.type_name, mi.name, mi.properties' + #13#10 + '  from ' +
          mainSession.Schema + '.FRM_MENU_ITEMS mi' + #13#10 + ' where mi.menu_id = :menu_id'
      else begin
        SQL.Text := 'select mi.type_name, mi.name, mi.properties' + #13#10 + '  from ' +
          mainSession.Schema + '.FRM_MENU_ITEMS mi' + #13#10 + ' where mi.menu_id = :menu_id' +
          #13#10 + '   and (mi.type_name=''TdxBar'' or bitand(mi.db_roles, :u_db_roles) <> 0)';
        Params.ParamByName('u_db_roles').AsInteger := Integer(userRoles);
      end;
      Params.ParamByName('menu_id').AsInteger := p_menu_ID;
      try
        open;
      except
        on E: Exception do begin
          ShowMessage(E.Message);
          exit;
        end;
      end;
      while not EOF do begin
        aClass := GetClass(FieldByName('type_name').AsString);
        if (aClass <> nil) And (aClass.InheritsFrom(TcxCustomComponent)) then begin
          aOldItem := get_item_by_name(FieldByName('name').AsString);
          if (aOldItem <> nil) { And (aOldItem.ClassType = aClass) } then
              aItem := TdxBarItem(aOldItem)
          else begin
            aOldItem.Free;
            if aClass = TdxBar then aItem := pBarManager.Bars.Add
            else aItem := pBarManager.AddItem(TdxBarItemClass(aClass));
            aItem.Name := FieldByName('name').AsString;
          end;
          aStream := CreateBlobStream(FieldByName('properties'), bmRead);
          try
            with TReader.Create(aStream, 2048) do
              try;
                try;
                  ReadRootComponent(aItem);
                except
                  on E: Exception do
                      ShowMessage('loadORAMenuItems (' + aItem.Name + '):' + E.Message);
                end;
              finally
                Free;
              end;
          finally
            aStream.Free;
          end;
        end;
        next;
      end;
      Close;
      SQL.Text := 'select mi.name, mi.links' + #13#10 + '  from ' + mainSession.Schema +
        '.FRM_MENU_ITEMS mi' + #13#10 + ' where mi.menu_id = :menu_id' + #13#10 +
        '   and mi.links is not null';
      open;
      while not EOF do begin
        aItem := get_item_by_name(FieldByName('name').AsString);
        if (aItem <> nil) and aItem.GetInterface(IdxBarLinksOwner, iLinksOwner) And
          (iLinksOwner.GetItemLinks <> nil) then begin
          aStream := CreateBlobStream(FieldByName('links'), bmRead);
          try
            read_links(aStream, iLinksOwner.GetItemLinks);
          finally
            aStream.Free;
          end;
        end;
        next;
      end;
    finally
      Free;
    end;
end;

procedure saveORAMenuItems(const p_menu_ID: Longint; const pBarManager: TdxBarManager);
var
  I: Longint;
  PropInfo: PPropInfo;
  aStream: TStream;
  procedure write_links(const pStream: TStream; const pItemLinks: TdxBarItemLinks);
  var
    II: Longint;
  begin
    with TWriter.Create(pStream, 2048) do
      try
        with pItemLinks do begin
          WriteListBegin;
          for II := 0 to Count - 1 do
            if items[II].Item <> nil then begin
              WriteString(items[II].Item.Name);
              WriteListBegin;
              WriteProperties(items[II]);
              WriteListEnd;
            end;
          WriteListEnd;
        end;
      finally
        Free;
      end;
  end;
  procedure write_item(const pFields: TFields; const pComponent: TcxCustomComponent);
  var
    iLinksOwner: IdxBarLinksOwner;
  begin
    with TOraDataSet(pFields.DataSet) do begin
      with pComponent do
        if Name <> '' then begin
          Params.ParamByName('name').AsString := Name;
          // SetVariable('name', Name);
          open;
          if EOF then Insert
          else Edit;
          FieldByName('menu_id').AsInteger := p_menu_ID;
          FieldByName('type_name').AsString := ClassName;
          FieldByName('name').AsString := Name;
          PropInfo := GetPropInfo(pComponent, 'DB_Roles');
          if PropInfo <> nil then
              FieldByName('DB_ROLES').AsInteger := GetOrdProp(pComponent, PropInfo)
          else FieldByName('DB_ROLES').AsVariant := Null;
          aStream := CreateBlobStream(FieldByName('properties'), bmWrite);
          try
            with TWriter.Create(aStream, 2048) do
              try
                WriteRootComponent(pComponent);
              finally
                Free;
              end;
          finally
            aStream.Free;
          end;
          if pComponent.GetInterface(IdxBarLinksOwner, iLinksOwner) And
            (iLinksOwner.GetItemLinks <> nil) and (iLinksOwner.GetItemLinks.Count <> 0) then begin
            aStream := CreateBlobStream(FieldByName('links'), bmWrite);
            try
              write_links(aStream, iLinksOwner.GetItemLinks);
            finally
              aStream.Free;
            end;
          end
          else FieldByName('links').AsVariant := Null;
          Post;
          Close;
        end;
    end;
  end;

begin
  try
    with stdOracleQuery do
      try
        SQL.Text := 'update ' + mainSession.Schema +
          '.FRM_MENU_ITEMS mi set mi.type_name = ''updating...'' where mi.menu_id = :menu_id';
        Params.ParamByName('menu_id').AsInteger := p_menu_ID;
        // DeclareAndSet('menu_id', otFloat, p_menu_ID);
        execute;
      finally
        Free;
      end;
    with stdOracleQuery do
      try
        LocalConstraints := False;
        Options.TemporaryLobUpdate := True;
        // OracleDictionary.RequiredFields := False;
        SQL.Text := 'select mi.*, mi.rowid' + #13#10 + '  from ' + mainSession.Schema +
          '.FRM_MENU_ITEMS mi' + #13#10 + ' where mi.menu_id = :menu_id' + #13#10 +
          '   And upper(mi.name) = upper(:name)';
        Params.ParamByName('menu_id').AsInteger := p_menu_ID;
        // Params.ParamByName('name');
        // DeclareAndSet('menu_id', otFloat, p_menu_ID);
        // DeclareVariable('name', otString);
        with pBarManager do begin
          for I := 0 to itemCount - 1 do write_item(Fields, items[I]);
          for I := 0 to Bars.Count - 1 do write_item(Fields, Bars[I]);
        end;
      finally
        Free;
      end;
    with stdOracleQuery do
      try
        SQL.Text := 'delete from ' + mainSession.Schema +
          '.FRM_MENU_ITEMS mi where mi.type_name = ''updating...'' And mi.menu_id = :menu_id';
        Params.ParamByName('menu_id').AsInteger := p_menu_ID;
        // DeclareAndSet('menu_id', otFloat, p_menu_ID);
        execute;
        Session.Commit;
      finally
        Free;
      end;
  except
    on E: Exception do begin
      mainSession.Rollback;
      raise Exception.Create(E.Message);
    end;
  end;
end;

function loadORAForm(const p_name: String; const p_version: String; const p_initPLSQL: String;
  const p_DeveloperMode: Boolean = False): TfrmORALayout;
var
  vStream: TMemoryStream;
  vVersion: String;
  vName: String;
begin
  Result := nil;
  if mainSession.Schema = '' then exit;
  vVersion := p_version;
  vName := p_name;
  vStream := TMemoryStream.Create();
  try
    with stdOracleQuery do
      try
        SQL.Text := 'begin ' + mainSession.Schema +
          '.pkg_forms.get_layout(:pr_name, :pr_code, :r_layout); end;';
        Params.ParamByName('pr_name').AsString := p_name;
        Params.ParamByName('pr_code').AsString := vVersion;
        with Params.ParamByName('r_layout') do begin
          ParamType := ptOutput;
          DataType := ftOraBlob;
        end;
        // DeclareAndSet('p_name', otString, p_name);
        // DeclareAndSet('pr_code', otString, vVersion);
        // DeclareVariable('r_layout', otBLOB);
        // SetComplexVariable('r_layout', vLob);
        execute;
        vVersion := Params.ParamByName('pr_code').AsString;
        vName := Params.ParamByName('pr_name').AsString;
        Params.ParamByName('r_layout').AsOraBlob.SaveToStream(vStream);
        // vVersion := VarToStr(GetVariable('pr_code'));
      finally
        Free;
      end;
    if vVersion <> '' then begin
      Result := TfrmORALayout.Create(Application);
      vStream.Position := 0;
      with Result do
        try
          teName.EditValue := vName;
          teCode.EditValue := vVersion;
          with Controller do begin
            RestoreFromStream(vStream);
            initControls(p_initPLSQL);
          end;
        finally
          DeveloperMode := p_DeveloperMode;
        end;
    end;
  finally
    vStream.Free;
  end;
end;

function askORAForm(const p_name: String; const p_initPLSQL: String;
  p_ResultControl: String): String;
var
  vFrm: TfrmORALayout;
begin
  vFrm := loadORAForm(p_name, '', p_initPLSQL);
  Result := 'Unassigned';
  if vFrm = nil then exit;
  with vFrm do
    try
      if ModalResult = mrNone then ShowModal;
      case ModalResult of
        mrOk, mrYes, mrYesToAll: Result := Controller.ControlCollection.Values[p_ResultControl];
        mrAbort: Result := 'mrAbort';
        mrCancel: Result := 'mrCancel';
      end;
    finally
      Free;
    end;
end;

function showORAForm(const p_name: String; const p_version: String = '';
  const p_initPLSQL: String = ''; p_DeveloperMode: Boolean = False): TfrmORALayout;
begin
  Result := loadORAForm(p_name, p_version, p_initPLSQL, p_DeveloperMode);
  if Result <> nil then
    with Result do begin
      FormStyle := fsMDIChild;
      OnCreate(nil);
//      layoutForm.MainFormTabControl.AddButton(Result, IconIndex, Caption);
      with Controller do State := State - [ocsLayoutModified];
    end;
end;

procedure saveORAForm(const p_form: TfrmORALayout);
var
  vStream: TMemoryStream;
begin
  vStream := TMemoryStream.Create();
  try
    p_form.Controller.StoreToStream(vStream);
    vStream.Position := 0;
    with stdOracleQuery do
      try
        SQL.Text := 'begin ' + mainSession.Schema +
          '.pkg_forms.upsert_layout(:p_name,:p_code,:p_layout); commit; end;';
        Params.ParamByName('p_name').AsString := p_form.teName.EditValue;
        Params.ParamByName('p_code').AsString := p_form.teCode.EditValue;
        with Params.ParamByName('p_layout') do begin
          ParamType := ptInput;
          DataType := ftOraBlob;
          with AsOraBlob do begin
            OCISvcCtx := Session.OCISvcCtx;
            CreateTemporary(ltBlob);
            LoadFromStream(vStream);
            WriteLob;
          end;
        end;
        // DeclareAndSet('p_name', otString, p_form.teName.EditValue);
        // DeclareAndSet('p_code', otString, p_form.teCode.EditValue);
        // DeclareVariable('p_layout', otBLOB);
        // SetComplexVariable('p_layout', vLob);
        execute;
      finally
        Free;
      end;
  finally
    vStream.Free;
  end;
end;

procedure set_ORAForm_notes(const p_form_name: string; const p_notes: String);
begin
  with stdOracleQuery do
    try
      SQL.Text := 'begin ' + mainSession.Schema +
        '.pkg_forms.set_notes(:p_name,:p_notes); commit; end;';
      Params.ParamByName('p_name').AsString := p_form_name;
      Params.ParamByName('p_notes').AsString := p_notes;
      execute;
    finally
      Free;
    end;
end;

function get_ORAForm_notes(const p_form_name: string): String;
begin
  with stdOracleQuery do
    try
      SQL.Text := 'begin :vNotes := ' + mainSession.Schema + '.pkg_forms.get_notes(:p_name); end;';
      Params.ParamByName('vNotes').AsString := '';
      Params.ParamByName('p_name').AsString := p_form_name;
      execute;
      Result := Params.ParamByName('vNotes').AsString;
    finally
      Free;
    end;
end;

procedure save_XLS2DB(const p_def: String; const p_xls_file: String; const p_sheet: String);
var
  vWS: OleVariant;
  vData: Variant;
  II, I: Integer;
begin
  vWS := getXLSWorksheet(p_xls_file, p_sheet, True);
  vData := vWS.UsedRange.Value;
  if not VarIsEmpty(vData) then
    with TfrmProgress.Create(Application) do
      try
        Progress.Properties.Min := VarArrayLowBound(vData, 1);
        Progress.Properties.Max := VarArrayHighBound(vData, 1);
        Show;
        with stdOracleQuery do
          try
            SQL.Text := 'select t.*, rowid from tmp_xls_import t';
            CachedUpdates := True;
            open;
            for I := VarArrayLowBound(vData, 1) to VarArrayHighBound(vData, 1) do begin
              Progress.Position := I;
              Progress.Properties.Text := IntToStr(I) + '/' + IntToStr(VarArrayHighBound(vData, 1));
              Progress.Repaint;
              Append;
              Fields[0].AsString := p_def;
              Fields[1].AsInteger := I;
              for II := 1 to Fields.Count - 3 do begin
                if (II >= VarArrayLowBound(vData, 2)) And (II <= VarArrayHighBound(vData, 2)) then
                    Fields[1 + II].AsString := VarToStr(vData[I, II])
              end;
              Post;
              if I mod 100 = 0 then CommitUpdates;
            end;
            CommitUpdates;
            Session.Commit;
          finally
            Free;
          end;
      finally
        Free;
      end;
  if not vWS.Application.Visible then vWS.Application.Quit;

end;

function get_user_param(const p_form_name: String; p_param_name: String): String;
begin
  with stdOracleQuery() do
    try
      SQL.Text := 'begin :result := ' + Session.Schema +
        '.pkg_common.get_user_param(:p_form_name, :p_param_name); end;';
      with Params do begin
        ParamByName('result').AsString := '';
        ParamByName('p_form_name').AsString := p_form_name;
        ParamByName('p_param_name').AsString := p_param_name;
        execute;
        Result := ParamByName('result').AsString;
      end;
    finally
      Free;
    end;
end;

procedure set_user_param(const p_form_name: String; const p_param_name: String;
  const p_value: String);
begin
  with stdOracleQuery() do
    try
      SQL.Text := 'begin ' + Session.Schema +
        '.pkg_common.set_user_param(:p_form_name, :p_param_name, :p_value); end;';
      with Params do begin
        ParamByName('p_form_name').AsString := p_form_name;
        ParamByName('p_param_name').AsString := p_param_name;
        ParamByName('p_value').AsString := p_value;
        execute;
      end;
    finally
      Free;
    end;
end;

procedure clear_user_params(const p_form_name: String);
begin
  with stdOracleQuery() do
    try
      SQL.Text := 'begin ' + Session.Schema + '.pkg_common.clear_user_params(:p_form_name); end;';
      Params.ParamByName('p_form_name').AsString := p_form_name;
      execute;
    finally
      Free;
    end;
end;

procedure get_user_bparam(const pStream: TStream; const p_form_name: String; p_param_name: String);
begin
  with stdOracleQuery() do
    try
      SQL.Text := 'begin :result := ' + Session.Schema +
        '.pkg_common.get_user_bparam(:p_form_name, :p_param_name); end;';
      with Params do begin
        ParamByName('p_form_name').AsString := p_form_name;
        ParamByName('p_param_name').AsString := p_param_name;
        with ParamByName('result') do begin
          ParamType := ptOutput;
          DataType := ftOraBlob;
          with AsOraBlob do begin
            OCISvcCtx := Session.OCISvcCtx;
            CreateTemporary(ltBlob);
            execute;
            SaveToStream(pStream);
          end;
        end;
      end;
    finally
      Free;
    end;
end;

procedure set_user_bparam(const p_form_name: String; const p_param_name: String;
  const pStream: TStream);
begin
  with stdOracleQuery() do
    try
      SQL.Text := 'begin ' + Session.Schema +
        '.pkg_common.set_user_bparam(:p_form_name, :p_param_name, :p_value); end;';
      with Params do begin
        ParamByName('p_form_name').AsString := p_form_name;
        ParamByName('p_param_name').AsString := p_param_name;
        with ParamByName('p_value') do begin
          ParamType := ptInput;
          DataType := ftOraBlob;
          with AsOraBlob do begin
            OCISvcCtx := Session.OCISvcCtx;
            CreateTemporary(ltBlob);
            LoadFromStream(pStream);
            WriteLob;
          end;
        end;
        execute;
      end;
    finally
      Free;
    end;
end;

initialization

RegisterClass(TcxImageList);

finalization

UnRegisterClass(TcxImageList);

end.
