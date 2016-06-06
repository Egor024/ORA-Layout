program OraFormsTest;



uses
  Forms,
  LMain in 'LMain.pas' {frmMain},
  GlobalVars in 'GlobalVars.pas',
  DataModule in 'DataModule.pas',
  SprApplications in 'SprApplications.pas' {frmSprApplications},
  layoutForm in 'CustomLayout\layoutForm.pas' {frmLayout},
  PassChange in 'PassChange.pas' {frmPassChange},
  dxLayoutCustomizeForm in 'CustomLayout\dxLayoutCustomizeForm.pas' {dxLayoutControlCustomizeForm},
  XLS_work in 'XLS_work.pas' {frmXLSwork},
  ShowProgress in 'ShowProgress.pas' {frmProgress},
  XLS_user_work in 'XLS_user_work.pas' {frmXLSUserWork},
  TestStartCard in 'TestStartCard.pas' {frmStartCard};

{$R *.RES}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  frmMain.WindowState:=wsMaximized;
  Application.Run;
end.
