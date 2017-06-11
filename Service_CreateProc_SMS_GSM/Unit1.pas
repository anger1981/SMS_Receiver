unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TRUN_SMS_GSM_ = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  RUN_SMS_GSM_: TRUN_SMS_GSM_;
  h_SMS_GSM: THandle;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  RUN_SMS_GSM_.Controller(CtrlCode);
end;

function TRUN_SMS_GSM_.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TRUN_SMS_GSM_.ServiceStart(Sender: TService; var Started: Boolean);
var
 SI : TStartupInfo;
 PI : TProcessInformation;
begin
ZeroMemory(@si,SizeOf(si));
si.cb := SizeOf(si);
si.dwFlags := STARTF_USESHOWWINDOW;
si.wShowWindow := SW_SHOWNORMAL;
//ShowMessage('Start_Service');
CreateProcess(nil, 'F:\Base\SMS_GSM\bin\SMS_GSM.exe', nil, nil, false,
 CREATE_NEW_CONSOLE, nil, 'F:\Base\SMS_GSM\bin\', SI, PI);
 h_SMS_GSM := PI.hProcess;

end;

procedure TRUN_SMS_GSM_.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  TerminateProcess(h_SMS_GSM, 555);
end;

end.
 