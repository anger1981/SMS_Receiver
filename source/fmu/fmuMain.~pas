unit fmuMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, untModem, Spin, ExtCtrls, Math, ActiveX, IBDatabase,
  DB, UntBaseCheck, IBSQL, IBCustomDataSet, IBQuery;

type
  TfrmMain = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    seCOM: TSpinEdit;
    seTimeOut: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    Button6: TButton;
    Timer1: TTimer;
    IBSQL_ins_wmval: TIBSQL;
    IBQ_check_account: TIBQuery;
    Button7: TButton;
    ibq_cr_doc: TIBQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seCOMChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    FGsmSms: TGsmSms;
  public
    procedure MemoWrite(AMessage: String);
  end;

var
  frmMain: TfrmMain;

implementation

uses fmuSMS;

{$R *.dfm}

procedure TfrmMain.MemoWrite(AMessage: String);
begin
  Memo1.Lines.Add(AMessage);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  LSMS: TSMSMessage;
begin
  LSMS := frmSMS.GetSMS;
  FGsmSms.SendSMS(LSMS);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  LSMS: TSMSMessage;
begin
  LSMS := FGsmSms.GetSMS(StrToInt(InputBox('Input number of message for read', 'number', '0')));
  frmSMS.ShowSMS(LSMS);
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  FGsmSms.DeleteSMS(StrToInt(InputBox('Input number of message for delete', 'number', '0')));
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  LSMSs: TSMSMessages;
  i: Integer;
begin
  LSMSs := FGsmSms.GetAllSMS;

  for i := 0 to Length(LSMSs) - 1 do
    frmSMS.ShowSMS(LSMSs[i]);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FGsmSms := TGsmSms.Create;
  FGsmSms.OnLog := MemoWrite;
  seCOMChange(Sender);
end;

procedure TfrmMain.seCOMChange(Sender: TObject);
begin
  FGsmSms.PortNum := seCOM.Value;
  FGsmSms.TimeOut := seTimeOut.Value;
end;

{procedure SendSMS(AComPort: integer; AMsg: string; ANumTel: String);
var
  hFile: THandle;

  procedure WriteStr(AStr: String);
  var
    LWrited: Cardinal;
  begin
    //пишем в порт
    WriteFile(hFile, PAnsiChar(AStr)^, Length(AStr), LWrited, nil);
  end;

begin
  hFile := Windows.CreateFile(PChar('\\.\COM' + IntToStr(AComPort)), GENERIC_READ or GENERIC_WRITE, 0, NIL, OPEN_EXISTING, 0, 0); //открываем порт
  if (hFile <> INVALID_HANDLE_VALUE) then
  begin
    try
      //устанавливаем текстовый режим
      WriteStr('AT+CMGF=1' + #$D#$A);
      //вводим номер в формате "+79xxxxxxxxx"
      WriteStr('AT+CMGS="'+ANumTel+'"' + #$D#$A);
      //текст сообщения, только латиница
      WriteStr(AMsg + #$D#$A#$1A);
    finally
      //закрываем порт
      Windows.CloseHandle(hFile);
    end;
  end;
end;}

procedure TfrmMain.Button5Click(Sender: TObject);
var
  LSMSs: TSMSMessages;
  i: Integer;
begin
  LSMSs := FGsmSms.GetAllSMS;

  for i := 0 to Length(LSMSs) - 1 do
    FGsmSms.DeleteSMS(LSMSs[i].ID_Message);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  LSMSs: TSMSMessages;
  str_res: TArrayOfString;
  i, reset, doc, doc_pos: Integer;
  acc_res, fio_res: string;
  sms_DateTime: TDateTime;
  LFormatSettings: TFormatSettings;
begin

  Memo1.Clear;

  LSMSs := FGsmSms.GetAllSMS;

  IBTransaction1.Active := true;

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, LFormatSettings);
  LFormatSettings.ShortDateFormat := 'yy/mm/dd';
  LFormatSettings.LongDateFormat := 'yy/mm/dd';
  LFormatSettings.DateSeparator := '/';

  for i := 0 to Length(LSMSs) - 1 do
  begin

    setLength(str_res, 0);
    str_res := Account_Phone(LSMSs[i].Text);

    if (length(str_res[0]) > 16) or (length(str_res[0]) = 0) then str_res[0] := '-1';

    IBQ_check_account.Active := false;
    IBQ_check_account.ParamByName('account').Value := str_res[0];
    IBQ_check_account.Active := true;
    acc_res :=  IBQ_check_account.FieldValues['code_res'];
    fio_res :=  IBQ_check_account.FieldValues['fio_res'];

    doc := 0;
    doc_pos := 0;

    if (StrToInt(acc_res) = StrToInt(str_res[0])) then
    begin
    ibq_cr_doc.Active := false;
    ibq_cr_doc.ParamByName('account').Value := StrToInt(acc_res);
    ibq_cr_doc.ParamByName('wmvol').Value := str_res[1];
    ibq_cr_doc.ParamByName('phone').Value := LSMSs[i].Number;
    ibq_cr_doc.ParamByName('fio').Value := fio_res;
    ibq_cr_doc.ParamByName('text_sms').Value := LSMSs[i].Text;
    ibq_cr_doc.Active := true;
    doc :=  ibq_cr_doc.FieldValues['doc'];
    doc_pos :=  ibq_cr_doc.FieldValues['doc_pos'];
    end;

       sms_DateTime := StrToDateTime(StringReplace(StringReplace(LSMSs[i].Time, ',', ' ', [rfIgnoreCase]), '+08', '', [rfIgnoreCase]), LFormatSettings);

       if (length(str_res[1]) > 6) or (length(str_res[1]) = 0) then str_res[1] := '-1';

       IBSQL_ins_wmval.ParamByName('ACCOUNT').Value := StrToInt(acc_res);
       IBSQL_ins_wmval.ParamByName('WMVAL').Value := str_res[1];
       IBSQL_ins_wmval.ParamByName('PHONE').Value := LSMSs[i].Number;
       IBSQL_ins_wmval.ParamByName('DATE_SMS').Value := sms_DateTime;
       IBSQL_ins_wmval.ParamByName('TEXT_SMS').Value := LSMSs[i].Text;
       IBSQL_ins_wmval.ParamByName('DOC').Value := doc;
       IBSQL_ins_wmval.ParamByName('DOC_POS').Value := doc_pos;
       IBSQL_ins_wmval.ExecQuery;

    //FGsmSms.DeleteSMS(LSMSs[i].ID_Message);

  end;

  IBTransaction1.Commit;

  FGsmSms.DeleteSMSes(LSMSs);

end;

procedure TfrmMain.Button7Click(Sender: TObject);
var
  LSMS: TSMSMessage;
begin
  LSMS := FGsmSms.GetSMS_Int(StrToInt(InputBox('Input number of message for read', 'number', '0')));
  frmSMS.ShowSMS(LSMS); 
end;

end.
