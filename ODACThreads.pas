unit ODACThreads;

interface

uses Classes, Ora, DB, Dialogs;

type
  TODACThread = class;
  TODACThreadClass = class of TODACThread;
  TOnThreadStateChanged = procedure(const AThread: TODACThread) of object;

  TODACThreadList = class(TList)
  private
    FOnStateChanged: TOnThreadStateChanged;
    function Get(Index: Integer): TODACThread;
    procedure Put(Index: Integer; const Value: TODACThread);
    function get—Count(pClass: TODACThreadClass): Longint;
  public
    procedure Terminate;
    property Items[Index: Integer]: TODACThread read Get write Put; default;
    property OnStateChanged: TOnThreadStateChanged read FOnStateChanged write FOnStateChanged;
    property —Count[pClass: TODACThreadClass]: Longint read get—Count;
  end;

  TODACThread = class(TThread)
  public
    class var ThreadList: TODACThreadList;
  private
    FOnStateChanged: TOnThreadStateChanged;
    FTotalSteps: Longint;
    FCurrentStep: Longint;
    FMessage: String;
    FButtons: TMsgDlgButtons;
    FConfirmResult: Integer;
    procedure synchDoStateChanged;
    procedure synchShowMessage;
    procedure synchConfirmation;
  protected
    FStartTimer: TDateTime;
    procedure DoStateChanged;
    function getStateText: String; virtual;
    procedure showMessage(const pMessage: String);
    function Confirmation(const pMessage: String; pButtons: TMsgDlgButtons): Integer;
  public
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy; override;
    function IndexOf: Integer; inline;
    procedure Terminate; virtual;
    property OnStateChanged: TOnThreadStateChanged read FOnStateChanged write FOnStateChanged;
    property StateText: String read getStateText;
    property TotalSteps: Longint read FTotalSteps write FTotalSteps;
    property CurrentStep: Longint read FCurrentStep write FCurrentStep;
    property StartTimer: TDateTime read FStartTimer write FStartTimer;
    property Terminated;
  end;

  TODACOracleQueryThread = class(TODACThread)
  private
    FState: String;
    FSessionID: String;
    FQuery: TOraQuery;
    FFetchAllRecords: Boolean;
    FSaveSessionOnExit: Boolean;
    FSaveQueryOnExit: Boolean;
    procedure setQuery(const Value: TOraQuery);
    function getSession: TOraSession; inline;
    procedure setSession(const Value: TOraSession); inline;
    procedure setState(const Value: String);
  protected
    procedure Execute; override;
    function getStateText: String; override;
  public
    destructor Destroy; override;
    procedure Terminate; override;
    property Session: TOraSession read getSession write setSession;
    property SessionID: String read FSessionID;
    property State: String read FState write setState;
    property Query: TOraQuery read FQuery write setQuery;
    property FetchAllRecords: Boolean read FFetchAllRecords write FFetchAllRecords;
    property SaveSessionOnExit: Boolean read FSaveSessionOnExit write FSaveSessionOnExit;
    property SaveQueryOnExit: Boolean read FSaveQueryOnExit write FSaveQueryOnExit;
  end;

implementation

uses SysUtils, ODACLib, Controls;
{ TODACThread }

function TODACThread.Confirmation(const pMessage: String; pButtons: TMsgDlgButtons): Integer;
begin
  FMessage := pMessage;
  FButtons := pButtons;
  FConfirmResult := mrNone;
  Synchronize(synchConfirmation);
  Result := FConfirmResult;
end;

constructor TODACThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);

  FStartTimer := Now;
  ThreadList.Add(self);
  DoStateChanged;
end;

procedure TODACThread.showMessage(const pMessage: String);
begin
  FMessage := pMessage;
  Synchronize(synchShowMessage);
end;

procedure TODACThread.synchConfirmation;
begin
  FConfirmResult := Dialogs.MessageDlg(FMessage, mtConfirmation, FButtons, 0);
end;

procedure TODACThread.synchDoStateChanged;
begin
  if Assigned(OnStateChanged) then OnStateChanged(self);
  if Assigned(ThreadList.OnStateChanged) then ThreadList.OnStateChanged(self);
end;

procedure TODACThread.synchShowMessage;
begin
  Raise Exception.Create(FMessage);
end;

procedure TODACThread.Terminate;
begin
  inherited Terminate;
end;

destructor TODACThread.Destroy;
begin
  ThreadList.Extract(self);
  DoStateChanged;
  inherited;
end;

procedure TODACThread.DoStateChanged;
begin
  if Assigned(OnStateChanged) or Assigned(ThreadList.OnStateChanged) then
      Synchronize(synchDoStateChanged);
end;

function TODACThread.getStateText: String;
begin
  if Finished then Result := 'Finished'
  else if Terminated then Result := 'Terminated'
  else if Suspended then Result := 'Suspended'
  else if StartTimer <> 0 then Result := TimeToStr(Now - StartTimer)
  else Result := 'Unknown';
end;

function TODACThread.IndexOf: Integer;
begin
  Result := ThreadList.IndexOf(self);
end;

{ TODACThreadList }

function TODACThreadList.Get(Index: Integer): TODACThread;
begin
  Result := inherited Get(Index);
end;

function TODACThreadList.get—Count(pClass: TODACThreadClass): Longint;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I].InheritsFrom(pClass) then Inc(Result);
end;

procedure TODACThreadList.Put(Index: Integer; const Value: TODACThread);
begin
  inherited Put(Index, Value);
end;

procedure TODACThreadList.Terminate;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do Items[I].Terminate;
end;

{ TODACOracleQueryThread }

procedure TODACOracleQueryThread.Terminate;
begin
  inherited;
  if Query <> nil then Query.BreakExec;
end;

procedure TODACOracleQueryThread.setState(const Value: String);
begin
  FState := Value;
  DoStateChanged;
end;

destructor TODACOracleQueryThread.Destroy;
var
  vQry, vSes: TObject;
begin
  if Query <> nil then Query.BreakExec;
  if FSaveSessionOnExit And not FSaveQueryOnExit then vQry := FQuery
  else vQry := nil;
  vSes := Session;
  if not FSaveSessionOnExit And (vSes <> nil) then begin
    Session := nil;
    vSes.Free;
  end;
  inherited;
  if vQry <> nil then vQry.Free;
end;

procedure TODACOracleQueryThread.Execute;
begin
  with Query do
    try
      if (Query = nil) or (Session = nil) or not Session.Connected then exit;
      self.State := 'Opening';
      Execute;
      if Terminated or not Active then exit;
      if FetchAllRecords And IsQuery then begin
        self.State := 'Fetching';
        while not Terminated And Active And not EOF do next;
        if Terminated or not Active then exit;
        First;
      end;
      self.State := 'Open';
    except
      on E: Exception do begin
        self.State := 'Error:' + E.ClassName;
        if not Terminated then showMessage(E.Message);
      end;
    end;
end;

function TODACOracleQueryThread.getSession: TOraSession;
begin
  Result := nil;
  if Query = nil then exit;
  Result := Query.Session;
end;

function TODACOracleQueryThread.getStateText: String;
begin
  if (State = 'Fetching') And FetchAllRecords then
      Result := 'Fetching: ' + Format('%.n', [0.0 + Query.RowsProcessed]) + ' rows; ' + inherited
  else Result := State + ' ' + inherited;
end;

procedure TODACOracleQueryThread.setQuery(const Value: TOraQuery);
begin
  if FQuery = Value then exit;
  FQuery := Value;
  Session := Session;
  State := 'Init';
end;

procedure TODACOracleQueryThread.setSession(const Value: TOraSession);
begin
  if Value = nil then FSessionID := ''
  else FSessionID := get_session_context(Value, 'SID');
  inherited;
  if Value = nil then
    if FQuery = nil then exit
    else if not FSaveQueryOnExit then freeAndNil(FQuery)
    else FQuery.Session := nil
  else begin
    if FQuery = nil then begin
      FQuery := TOraQuery.Create(Value);
      FSaveQueryOnExit := False;
    end;
    FQuery.Session := Value;
  end;
end;

initialization

TODACThread.ThreadList := TODACThreadList.Create;

Finalization

TODACThread.ThreadList.Free;

end.
