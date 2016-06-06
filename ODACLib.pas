unit ODACLib;

interface

uses
  SysUtils, Classes, DB, Variants, DBTables, Ora;

function DLookUp(vSession: TOraSession; p_sql: String): variant;
function DLookUpParam(vSession: TOraSession; p_sql: String; p_params: variant): variant;

function get_session_context(const vSession: TOraSession; const p_ctx: String): String;
procedure set_session_module(const pSession: TOraSession; const p_module, p_action: String);
procedure SET_CLIENT_INFO(const vSession: TOraSession; const value: string);

procedure StoreDataSetToCSV(const p_DataSet: TOraQuery; const p_stream: TStream;
  const p_separator: AnsiString = ';');

implementation

function get_session_context(const vSession: TOraSession; const p_ctx: String): String;
begin
  Result := DLookUp(vSession, 'select sys_context(''USERENV'', ''' + p_ctx + ''') from dual');
end;

procedure SET_CLIENT_INFO(const vSession: TOraSession; const value: string);
begin
  if Assigned(vSession) And vSession.Connected then
    with TOraQuery.Create(nil) do
      try
        Session := vSession;
        SQL.Text := 'begin sys.dbms_application_info.SET_CLIENT_INFO(:client_info); end;';
        ParamByName('client_info').AsString := value;
        Execute;
        Close;
      finally
        Free;
      end;
end;

procedure StoreDataSetToCSV(const p_DataSet: TOraQuery; const p_stream: TStream;
  const p_separator: AnsiString = ';');
const
  cCrLf: AnsiString = #13#10;
var
  I: Longint;
  vStr: String;
  vAStr: AnsiString;
begin
  if (p_stream = nil) or (p_DataSet = nil) then exit;
  if not p_DataSet.Active then p_DataSet.Active := True;

  with p_DataSet, p_stream do begin
    for I := 0 to FieldCount - 1 do begin
      vAStr := AnsiString(FieldList[I].FieldName);
      WriteBuffer(vAStr[1], length(vAStr));
      if I < FieldCount - 1 then WriteBuffer(p_separator[1], length(p_separator));
    end;
    WriteBuffer(cCrLf[1], 2);
    while not EOF do begin
      for I := 0 to FieldCount - 1 do begin
        vStr := StringReplace(StringReplace(FieldList[I].AsString, #13, ' ', [rfReplaceAll]), #10,
          ' ', [rfReplaceAll]);
        if (vStr <> '') And (FieldList[I].DataType in [ftWideString, ftString]) then
            vStr := AnsiQuotedStr(vStr, '"');
        vAStr := AnsiString(vStr);
        WriteBuffer(vAStr[1], length(vAStr));
        if I < FieldCount - 1 then WriteBuffer(p_separator[1], length(p_separator));
      end;
      WriteBuffer(cCrLf[1], 2);
      Next;
    end;
  end;
end;

procedure set_session_module(const pSession: TOraSession; const p_module, p_action: String);
begin
  with TOraQuery.Create(pSession) do
    try
      Session := pSession;
      SQL.Text := 'begin sys.dbms_application_info.set_module(:p_module_name,:p_action_name); end;';
      ParamByName('p_module_name').AsString := p_module;
      ParamByName('p_action_name').AsString := p_action;
      Execute;
      Close;
    finally
      Free;
    end;
end;

function DLookUp(vSession: TOraSession; p_sql: String): variant;
var
  I: integer;
begin
  with TOraQuery.Create(nil) do
    try
      // debug:= true;
      Session := vSession;
      SQL.Text := p_sql;
      try
        Execute;
      except
        on E: Exception do begin
          Result := 'Error: ' + E.message;
          exit;
        end;
      end;
      if EOF then begin
        Result := 'no data found';
        exit;
      end;
      try
        if FieldCount = 1 then Result := Fields[0].value
        else begin
          Result := VarArrayCreate([0, FieldCount - 1], varVariant);
          for I := 0 to FieldCount - 1 do Result[I] := Fields[I].value;
        end;
        Close;
      except
        on E: Exception do begin
          Result := 'Error: ' + E.message;
        end;
      end;
    finally
      Free;
    end;
end;

function DLookUpParam(vSession: TOraSession; p_sql: String; p_params: variant): variant;
var
  I, j, k: integer;
  s, s1, s2: variant;
  TORAQ: TOraQuery;
  param_: TParam;
begin
  if not VarIsArray(p_params) then
      raise Exception.Create('Function FED_DLookUpParam. Parameter:p_params must be Array');
  I := VarArrayDimCount(p_params);
  if not I > 2 then
      raise Exception.Create
      ('Function FED_DLookUpParam. Parameter:p_params must have no more 1 dimention');
  TORAQ := TOraQuery.Create(nil);
  try
    with TORAQ do begin
      Session := vSession;
      ParamCheck := False;
      SQL.Add(p_sql);
      if not VarIsArray(p_params[0]) then begin
        s := p_params[0];
        s1 := p_params[1];
        s2 := p_params[2];
        param_ := Params.AddParameter;
        param_.Name := String(s);
        param_.DataType := TFieldType(s1);
        param_.value := s2;
      end else begin
        j := VarArrayLowBound(p_params, 1);
        k := VarArrayHighBound(p_params, 1);
        for I := j to k do begin
          param_ := Params.AddParameter;
          param_.Name := String(p_params[I][0]);
          param_.DataType := TFieldType(p_params[I][1]);
          param_.value := p_params[I][2];
        end;
      end;
      try
        Execute;
      except
        on E: Exception do begin
          Result := 'Error: ' + E.message;
          exit;
        end;
      end;
      If RecordCount = 0 then begin
        Result := 'no data found';
        exit;
      end;
      try
        if FieldCount = 1 then Result := Fields.Fields[0].value
        else begin
          Result := VarArrayCreate([0, FieldCount - 1], varVariant);
          for I := 0 to FieldCount - 1 do Result[I] := Fields.Fields[I].value;
        end;
      except
        on E: Exception do begin
          Result := 'Error: ' + E.message;
        end;
      end;
    end;
  finally
    TORAQ.Free;
  end;
end;

end.
