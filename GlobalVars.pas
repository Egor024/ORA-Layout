unit GlobalVars;

interface

Uses SYSUtils, Ora, Classes, Windows, ORARoles, DBAccess;

const

  ApplicationName: String = 'ORAForms';
  defaultFilePath: String = 'C:\delphi\';

type
  TTOraSession = class(TOraSession)
  private
    procedure ConnectionErrorEvent(Sender: TObject; E: EDAError; var Fail: boolean);
  end;

var
  mainCaption: string = '';
  mainSession: TTOraSession = nil;
  userRoles: TORADBRoles = [];
  userFIO: String;
  mainSessionSID: String = '';
  StartVersionApp: string;
  LCID: Integer;

function init_session(const p_server: String): boolean;
function reinit_session: boolean;
function clone_session: TOraSession;
procedure ODACChangePassword(const pOldPassword: String; const pNewPassword: String);
function stdOracleQuery(AOwner: TComponent = nil; p_Session: TOraSession = nil): TOraQuery;
function set_session_scheme(const p_scheme: String) : Boolean;

function ReadStringFromRegistry(AppName, RegName: String;
  pRootKey: HKEY = HKEY_CURRENT_USER): String;
procedure LoadStringIntoRegistry(const AppName, RegName, RegString: String);

implementation

uses Dialogs, Utilities, ORALayout, ODACLib, Variants, DB, LMain, Registry, IniFiles, PassChange;

function stdOracleQuery(AOwner: TComponent = nil; p_Session: TOraSession = nil): TOraQuery;
var
  vOwner: TComponent;
  vSession: TOraSession;
begin
  if p_Session = nil then vSession := mainSession
  else vSession := p_Session;
  if AOwner = nil then vOwner := vSession
  else vOwner := AOwner;
  Result := TOraQuery.Create(vOwner);
  Result.Session := vSession;
  Result.AutoCommit := False;
end;

function set_session_scheme(const p_scheme: String) : Boolean;
var
  vRoles: Variant;
begin
  userRoles := [];
  userFIO := '';

  Result := mainSession.Connected;
  if not Result then mainSessionSID := ''
  else begin
    mainSessionSID := get_session_context(mainSession, 'SID');
    try
      mainSession.Schema := p_scheme;
    except
      on E: Exception do begin
        showmessage(E.Message);
        mainSession.Schema := mainSession.Username;
        Result := False;
      end;
    end;
    if Result And (mainSession.Schema <> '') then begin
      vRoles := DLookUp(mainSession, 'select u.APP_ROLES, u.FIO from ' + mainSession.Schema +
        '.v_spr_users u where login = user');
      if VarIsArray(vRoles) then begin
        if Utilities.VarIsNumeric(vRoles[0]) then userRoles := TORADBRoles(Integer(vRoles[0]));
        userFIO := VarToStr(vRoles[1]);
      end;
      if AnsiCompareText(mainSession.Schema, mainSession.Username) = 0 then
          Include(userRoles, Developer_ORADBRole);
    end;
  end;
end;

function init_session(const p_server: String): boolean;
begin
  userRoles := [];
  if mainSession <> nil then begin
    FreeAndNil(mainSession);
    HostInterface.mainSession := nil;
  end;

  mainSession := TTOraSession.Create(nil);
  with mainSession do begin
    AutoCommit := True;
    Options.DateLanguage := 'RUSSIAN';
    Options.Direct := True;
    LoginPrompt := True;
    Schema := '';
    Server := p_server;
    OnError := mainSession.ConnectionErrorEvent;
    try
      Connect;
    except
    end;
    Result := Connected;
    set_session_scheme('');
    HostInterface.mainSession := mainSession;
  end;
end;

procedure LoadStringIntoRegistry(const AppName, RegName, RegString: String);
var
  TN: TRegistry;
begin
  TN := TRegistry.Create;
  try
    with TN do begin
      RootKey := HKEY_CURRENT_USER;
      if not OpenKey(AppName, True) then begin
        CloseKey;
        exit;
      end;
      WriteString(RegName, RegString);
      CloseKey;
    end;
  finally
    TN.Free;
  end;
end;

function ReadStringFromRegistry(AppName, RegName: String;
  pRootKey: HKEY = HKEY_CURRENT_USER): String;
var
  TN: TRegistry;
begin
  TN := TRegistry.Create;
  try
    with TN do begin
      RootKey := pRootKey;
      if not OpenKey(AppName, False) then begin
        CloseKey;
        exit;
      end;
      Result := ReadString(RegName);
      CloseKey;
    end;
  finally
    TN.Free;
  end;
end;

procedure ODACChangePassword(const pOldPassword: String; const pNewPassword: String);
begin
  if pOldPassword <> mainSession.Password then raise Exception.Create('Неверен действующий пароль');
  mainSession.ChangePassword(pNewPassword);
end;

function reinit_session: boolean;
begin
  userRoles := [];
  if not mainSession.Connected then begin
    Result := init_session(ParamStr(1));
    exit;
  end
  else
    with mainSession do begin
      Connected := False;
      LoginPrompt := False;
      Connected := True;
      Result := Connected;
      set_session_scheme(Schema);
    end;
end;

function clone_session: TOraSession;
begin
  Result := nil;
  if not mainSession.Connected then
    if not init_session(mainSession.Server) then exit;
  Result := TOraSession.Create(mainSession);
  with Result do begin
    AutoCommit := mainSession.AutoCommit;
    Options.Direct := True;
    Server := mainSession.Server;
    Schema := mainSession.Schema;
    Username := mainSession.Username;
    Password := mainSession.Password;
    LoginPrompt := False;
    Connected := True;
  end;
end;

{ TTOraSession }

procedure TTOraSession.ConnectionErrorEvent(Sender: TObject; E: EDAError; var Fail: boolean);
begin
  if E.ErrorCode = 28001 then Fail := not PassChange.ChangePassword(ODACChangePassword);
end;

initialization

LCID := GetUserDefaultLCID;
StartVersionApp := FormatDateTime('DD.MM hh:mm', GetBuildTime);

finalization

end.
