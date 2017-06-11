program RUN_SMS_GSM;

uses
  SvcMgr,
  Unit1 in 'Unit1.pas' {RUN_SMS_GSM_: TService};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TRUN_SMS_GSM_, RUN_SMS_GSM_);
  Application.Run;
end.
