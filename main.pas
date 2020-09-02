unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus,
  Registry, IniFiles, TlHelp32, dwmApi, UxTheme, ShlObj,
  OTLParallel, OTLTaskControl, taskbar, madExceptVcl, UCL.TUCaptionBar,
  UCL.TUThemeManager, UCL.TUForm, UCL.TUButton, UCL.TUSymbolButton, UCL.TUPanel,
  UCL.IntAnimation, UCL.IntAnimation.Helpers ,UCL.TUScrollBox, Vcl.ComCtrls,
  UCL.TUHyperLink, Vcl.StdCtrls, UCL.TUText, UCL.TUCheckBox,
  System.Net.HttpClient, System.Types,
  frmIcons, UCL.TUProgressBar, frmSkins, GDIPAPI, GDIPOBJ, ES.BaseControls,
  ES.Switch, ES.Labels;

type

  TMARGINS = record
    leftWidth: integer;
    rightWidth: integer;
    topHeight: integer;
    bottomHeight: integer;
  end;

  TForm1 = class(TUForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    mnuPinnedIcons: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    tmrUpdateTBinfo: TTimer;
    tmrOptions: TTimer;
    tmrThreadWaiter: TTimer;
    tmrCenter: TTimer;
    mnuStart: TMenuItem;
    mnuTray: TMenuItem;
    mnuFull: TMenuItem;
    mnuCenter: TMenuItem;
    mnuTransparent: TMenuItem;
    N2: TMenuItem;
    mnuAbout: TMenuItem;
    N3: TMenuItem;
    mnuStartwithWindows: TMenuItem;
    MadExceptionHandler1: TMadExceptionHandler;
    UCaptionBar1: TUCaptionBar;
    UThemeManager1: TUThemeManager;
    UButton1: TUButton;
    UButton2: TUButton;
    UButton3: TUButton;
    UButton4: TUButton;
    UPanel1: TUPanel;
    USymbolButton1: TUSymbolButton;
    UScrollBox1: TUScrollBox;
    USymbolButton2: TUSymbolButton;
    mnuCenterRelative: TMenuItem;
    PageControl1: TPageControl;
    tbsSettings: TTabSheet;
    tbsAbout: TTabSheet;
    headingAbout: TUText;
    btnCheckUpdate: TUButton;
    desAppVersion: TUText;
    desFlashVersion: TUText;
    desChromiumVersion: TUText;
    linkEmbarcadero: TUHyperLink;
    USymbolButton3: TUSymbolButton;
    USymbolButton4: TUSymbolButton;
    USymbolButton5: TUSymbolButton;
    UText1: TUText;
    tbsDocks: TTabSheet;
    UText2: TUText;
    tbsPinnedIcons: TTabSheet;
    frameIcons1: TframeIcons;
    pbDownload: TUProgressBar;
    USymbolButton6: TUSymbolButton;
    tbsMore: TTabSheet;
    USymbolButton7: TUSymbolButton;
    tbsSkins: TTabSheet;
    frmSkin1: TfrmSkin;
    ListBox1: TListBox;
    Button1: TButton;
    mnuSmall: TMenuItem;
    chkStart: TEsSwitch;
    chkTray: TEsSwitch;
    chkTransparent: TEsSwitch;
    chkCenter: TEsSwitch;
    chkCenterRelative: TEsSwitch;
    chkAutoStart: TEsSwitch;
    chkSkinEnabled: TEsSwitch;
    chkSmall: TEsSwitch;
    chkAnimation: TEsSwitch;
    mnuTaskbarSettings: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrUpdateTBinfoTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrThreadWaiterTimer(Sender: TObject);
    procedure tmrCenterTimer(Sender: TObject);
    procedure tmrOptionsTimer(Sender: TObject);
    procedure mnuStartClick(Sender: TObject);
    procedure mnuTrayClick(Sender: TObject);
    procedure mnuFullClick(Sender: TObject);
    procedure mnuCenterClick(Sender: TObject);
    procedure mnuTransparentClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuStartwithWindowsClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure UButton1Click(Sender: TObject);
    procedure USymbolButton1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure mnuCenterRelativeClick(Sender: TObject);
    procedure USymbolButton2Click(Sender: TObject);
    procedure USymbolButton3Click(Sender: TObject);
    procedure UButton2Click(Sender: TObject);
    procedure UButton3Click(Sender: TObject);
    procedure USymbolButton5Click(Sender: TObject);
    procedure USymbolButton4Click(Sender: TObject);
    procedure btnCheckUpdateClick(Sender: TObject);
    procedure frameIcons1UButton5Click(Sender: TObject);
    procedure frameIcons1UButton2Click(Sender: TObject);
    procedure USymbolButton7Click(Sender: TObject);
    procedure frameIcons1UButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mnuSmallClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure chkStartClick(Sender: TObject);
    procedure chkTrayClick(Sender: TObject);
    procedure chkTransparentClick(Sender: TObject);
    procedure chkCenterClick(Sender: TObject);
    procedure chkCenterRelativeClick(Sender: TObject);
    procedure chkAutoStartClick(Sender: TObject);
    procedure chkSmallClick(Sender: TObject);
    procedure chkAnimationClick(Sender: TObject);
    procedure tbsSettingsShow(Sender: TObject);
    procedure mnuTaskbarSettingsClick(Sender: TObject);
  private
    { Private declarations }
    ms: TPoint;
    FClient: THTTPClient;
    FGlobalStart: Cardinal;
    FAsyncResult: IAsyncResult;
    FDownloadStream: TStream;
    LSize: Int64;

    function FindWindowRecursive(hParent: HWND; szClass: PWideChar; szCaption:PWideChar): HWND;
    procedure GetTaskbarWindows;
    procedure Init;
    procedure AutoStartState;
    procedure SetAutoStart(runwithwindows: Boolean = True);
    procedure LoadINI;
    procedure SaveINI;
    function InjectDLL(const dwPID: DWORD; DLLPATH: PChar): Integer;
    function GetProcessIdByName(s: String): DWORD;
    procedure SyncSettingsPage;

    // IconChanger
    function ListLnkFiles: Integer;

    // System functions
    function SystemUsesLightTheme: Boolean;
<<<<<<< HEAD


=======
>>>>>>> parent of f26eef2... Fix refresh of taskbars on explorer restart
  public
    { Public declarations }
    AppPath, AppFolder, AppExe: String;
    Taskbars: TTaskbars;
    function ForceForeground(hwnd: HWND): Boolean;
    procedure CheckUpdate;
    procedure ReceiveDataEvent(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean);
    procedure DoEndDownload(const AsyncResult: IAsyncResult);
  protected
    procedure WndProc(var Msg: TMessage); override;
    procedure CreateParams(var Params: TCreateParams); override;
    //procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
  end;

  //Requires setversion.cmd to be run prior to build for release
  {$include RELEASENUMBER.inc}
  {$include VERSION.inc}

var
  Form1: TForm1;
  // Global variables
  AppIsRunning: Boolean = False;
  ThreadIsRunning: Boolean = False;
  CloseApp: Boolean = False;
  fwm_TaskbarRestart: Cardinal;

  prevForegroundWindow: THandle;
  startmenuVisible: Boolean;

  ShellHook: HHOOK;

//  procedure RunHook; cdecl; external 'TaskbarDll.dll' name 'RunHook';
//  procedure KillHook; cdecl; external 'TaskbarDll.dll' name 'KillHook';

implementation

{$R *.dfm}

uses skinform, functions, settings;

var
  skinFrm: TForm2;


procedure TForm1.mnuAboutClick(Sender: TObject);
begin
  MessageDlg('TaskbarDock v'+VERSION+RELEASENUMBER+
  #13'Author: vhanla'+
  #13'MIT License'+
  #13#13'https://github.com/vhanla/taskbardock',mtInformation, [mbOK], 0);
end;

procedure TForm1.mnuTaskbarSettingsClick(Sender: TObject);
begin
  WinExec(PAnsiChar('rundll32.exe shell32.dll, Options_RunDLL 1'), SW_SHOWNORMAL);
end;

procedure TForm1.AutoStartState;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
    if reg.ValueExists('TaskbarDock') then
      if reg.ReadString('TaskbarDock')<>'' then
        mnuStartwithWindows.Checked := True;
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

procedure TForm1.mnuCenterClick(Sender: TObject);
begin
  mnuCenter.Checked := not mnuCenter.Checked;
  tmrCenter.Enabled := mnuCenter.Checked;

  Taskbars.CenterAppsButtons(mnuCenter.Checked, mnuCenterRelative.Checked);
  chkCenter.Checked := mnuCenter.Checked;
end;

<<<<<<< HEAD


=======
>>>>>>> parent of f26eef2... Fix refresh of taskbars on explorer restart
procedure TForm1.CreateParams(var Params: TCreateParams);
var
  AeroEnabled: LongBool;
begin
  inherited;

  AeroEnabled := False;
  if (Win32MajorVersion >= 6) then
  begin
    DwmIsCompositionEnabled(AeroEnabled);
  end;

  Params.WinClassName := 'TaskbarDocks';
end;

procedure TForm1.DoEndDownload(const AsyncResult: IAsyncResult);
var
  Response: IHTTPResponse;
  str: TStrings;
begin
  try
    Response := THTTPClient.EndAsyncHTTP(AsyncResult);
    TThread.Synchronize(nil,
      procedure
      begin
        if Response.StatusCode = 200 then
        begin
          str := TStringList.Create;
          try
            str.LoadFromStream(FDownloadStream);
            MessageDlg('Version available: '+str.Text, mtInformation, [mbOK], 0);
          finally
            str.Free;
          end;
        end;
      end);
  finally
    Response := nil;
    FreeAndNil(FDownloadStream);
    btnCheckUpdate.Enabled := True;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  CloseApp := True;
  Close;
end;

procedure TForm1.Exit2Click(Sender: TObject);
begin
  CloseApp := True;
  Close;
end;

function TForm1.FindWindowRecursive(hParent: HWND; szClass,
  szCaption: PWideChar): HWND;
begin

end;

function TForm1.ForceForeground(hwnd: HWND): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);
//  if not IsWindowVisible(hwnd) then
//    ShowWindow(hwnd, SW_SHOWNOACTIVATE);

  if GetForegroundWindow = hwnd then
    Result := True
  else
  begin
    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd);
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
        BringWindowToTop(hWnd);
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end else
    begin
      BringWindowToTop(hWnd);
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
   end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  AppIsRunning := False;
  CanClose := False;
  if CloseApp then
  begin
    tmrOptions.Enabled := False;
    Taskbars.RestoreAllStarts();
    Taskbars.NotifyAreaVisible();

    if not ThreadIsRunning then
    begin
      SaveINI;
      Taskbars.CenterAppsButtons(False);
      PostMessage(handle,WM_SYSCOMMAND,SC_TASKLIST,0);
      CanClose := True
    end
    else
      tmrThreadWaiter.Enabled := True;
  end
  else
  begin
    Hide;
  end;
end;

function ShellProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  if nCode = HSHELL_WINDOWCREATED then
  begin
    ShowMessage('Window created');
  end;
  Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AppPath := ParamStr(0);
  AppFolder := ExtractFilePath(AppPath);
  AppExe := ExtractFileName(AppPath);

  Self.ThemeManager := ThemeManager;
  AutoStartState;
<<<<<<< HEAD
  //CreateDB;
  ResetDB;
=======
>>>>>>> parent of f26eef2... Fix refresh of taskbars on explorer restart
  Init;
  tmrUpdateTBinfo.Enabled := True;
  LoadINI;
  FClient := THTTPClient.Create;
  FClient.OnReceiveData := ReceiveDataEvent;

  ShellHook := SetWindowsHookEx(WH_SHELL, @ShellProc, 0, 0);
//  RunHook;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  KillHook;
  Taskbars.RestoreOpacity(Handle);

  FDownloadStream.Free;
  FClient.Free;
  Taskbars.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  SyncSettingsPage;
end;

procedure TForm1.frameIcons1UButton1Click(Sender: TObject);
begin
  frameIcons1.UButton1Click(Sender);

end;

procedure TForm1.frameIcons1UButton2Click(Sender: TObject);
begin
  frameIcons1.UButton2Click(Sender);

end;

procedure TForm1.frameIcons1UButton5Click(Sender: TObject);
begin
  frameIcons1.UButton5Click(Sender);
end;

procedure TForm1.mnuFullClick(Sender: TObject);
var
  ex: PWideChar;
begin
//  mnuFull.Checked := not mnuFull.Checked;
  //GetModuleFileName(GetWindowThreadProcessId(FindWindow('Shell_TrayWnd', nil)),ex,2048);

  InjectDLL(GetProcessIdByName('explorer.exe'),PChar(AppFolder+'TaskbarDll.dll'));
end;

function TForm1.GetProcessIdByName(s: String): DWORD;
var
  Proc: TProcessEntry32;
  hSnap: HWND;
  Looper: BOOL;
begin
  Result := 0;
  Proc.dwSize := SizeOf(Proc);
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  Looper := Process32First(hSnap, Proc);
  while Integer(Looper) <> 0 do
  begin
    if Proc.szExeFile = s then
    begin
      Result := Proc.th32ProcessID;
      Break;
    end;
    Looper := Process32Next(hSnap, Proc);
  end;
  CloseHandle(hSnap);
end;

procedure TForm1.GetTaskbarWindows;
begin

end;

procedure TForm1.Init;
begin
  tmrCenter.Interval := 50;
  tmrUpdateTBinfo.Interval := 750;
  tmrThreadWaiter.Interval := 10;

  Taskbars := TTaskbars.Create;
  Taskbars.Refresh;
  Taskbars.UpdateTaskbarInfo;

  AppIsRunning := True;
  ThreadIsRunning := True;
  Parallel.Async(
    procedure
    begin
      while AppIsRunning do
      begin
        // hide tasklistthumbnailwindows
{          var taskthumbwnd: HWND;
          taskthumbwnd := FindWindow('TaskListThumbnailWnd',nil);
          if taskthumbwnd <> 0 then
          begin
            SetWindowLong(taskthumbwnd, GWL_EXSTYLE, GetWindowLong(taskthumbwnd, GWL_EXSTYLE) and not WS_EX_LAYERED and not WS_EX_TRANSPARENT);
            SetLayeredWindowAttributes(taskthumbwnd, 0, 255, LWA_ALPHA);
            //ShowWindow(taskthumbwnd, SW_HIDE);
          end;}
        if Form1.mnuTransparent.Checked then
        begin
          //SetWindowLong(Form1.Taskbar.Handle, GWL_EXSTYLE, GetWindowLong(Form1.Taskbar.Handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
          //SetLayeredWindowAttributes(Form1.Taskbar.Handle, 0, 155, LWA_ALPHA);
          //UpdateLayeredWindow(Form1.Taskbar.Handle,0, )
          Form1.Taskbars.Transparent;
        end;
        Sleep(10);
      end
    end,
    Parallel.TaskConfig.OnTerminated(
      procedure
      begin
        ThreadIsRunning := False;
      end
    )
  );

  fwm_TaskbarRestart := RegisterWindowMessage('TaskbarCreated');
end;

function TForm1.InjectDLL(const dwPID: DWORD; DLLPATH: PChar): Integer;
const
  Kernel32 = 'kernel32.dll';
var
  dwThreadID: Cardinal;
  hProc, hThread, hKernel: THandle;
  BytesToWrite, BytesWritten: SIZE_T;
  pRemoteBuffer, pLoadLibrary: Pointer;
begin
  hProc := OpenProcess(PROCESS_CREATE_THREAD or PROCESS_QUERY_INFORMATION or
    PROCESS_VM_OPERATION or PROCESS_VM_WRITE or PROCESS_VM_READ, False, dwPID);
  if hProc = 0 then
    Exit(0);
  try
    BytesToWrite := SizeOf(WideChar) * (Length(DLLPATH) + 1);
    pRemoteBuffer := VirtualAllocEx(hProc, nil, BytesToWrite, MEM_COMMIT,
      PAGE_READWRITE);
    if pRemoteBuffer = nil then
      Exit(0);
    try
      if not WriteProcessMemory(hProc, pRemoteBuffer, DLLPATH, BytesToWrite,
        BytesWritten) then
        Exit(0);

      hKernel := GetModuleHandle(Kernel32);
      pLoadLibrary := GetProcAddress(hKernel, 'LoadLibraryW');

      hThread := CreateRemoteThread(hProc, nil, 0, pLoadLibrary, pRemoteBuffer,
        0, dwThreadID);
      try
        WaitForSingleObject(hThread, INFINITE);
      finally
        CloseHandle(hThread);
      end;
    finally
      VirtualFreeEx(hProc, pRemoteBuffer, 0, MEM_RELEASE);
    end;
  finally
    CloseHandle(hProc);
  end;
  Exit(1);
end;

function TForm1.ListLnkFiles: Integer;
begin
end;

procedure TForm1.LoadINI;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(AppFolder+'settings.ini');
  try
    mnuStart.Checked := ini.ReadBool('TaskbarDock','ShowStartButton', True);
    mnuTray.Checked := ini.ReadBool('TaskbarDock','ShowTrayArea', True);
    mnuFull.Checked := ini.ReadBool('TaskbarDock','AbsoluteWidth', False);
    mnuCenter.Checked := ini.ReadBool('TaskbarDock','CenterIcons', False);
    mnuCenterRelative.Checked := ini.ReadBool('TaskbarDock','CenterRelative', False);
    tmrCenter.Enabled := mnuCenter.Checked;
    mnuTransparent.Checked := ini.ReadBool('TaskbarDock','Transparent', False);

    chkSkinEnabled.Checked := ini.ReadBool('Skin', 'Enabled', False);

  finally
    ini.Free;
  end;
end;

procedure TForm1.SaveINI;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(AppFolder+'settings.ini');
  try
    ini.WriteBool('TaskbarDock','ShowStartButton', mnuStart.Checked);
    ini.WriteBool('TaskbarDock','ShowTrayArea', mnuTray.Checked);
    ini.WriteBool('TaskbarDock','AbsoluteWidth', mnuFull.Checked);
    ini.WriteBool('TaskbarDock','CenterIcons', mnuCenter.Checked);
    ini.WriteBool('TaskbarDock','CenterRelative', mnuCenter.Checked);
    ini.WriteBool('TaskbarDock','Transparent', mnuTransparent.Checked);

    ini.WriteBool('Skin', 'Enabled', chkSkinEnabled.Checked);
  finally
    ini.Free;
  end;
end;

procedure TForm1.mnuTransparentClick(Sender: TObject);
begin

  mnuTransparent.Checked := not mnuTransparent.Checked;
  if not mnuTransparent.Checked then
    Taskbars.RestoreOpacity(Handle);

end;

procedure TForm1.mnuTrayClick(Sender: TObject);
begin
  mnuTray.Checked := not mnuTray.Checked;
  chkTray.Checked := mnuTray.Checked;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  mnuSmall.Checked := Taskbars.SmallIcons;
end;

procedure TForm1.ReceiveDataEvent(const Sender: TObject; AContentLength,
  AReadCount: Int64; var Abort: Boolean);
var
  LTime: Cardinal;
  LSpeed: Integer;
begin
  LTime := TThread.GetTickCount - FGlobalStart;
  LSpeed := (AReadCount * 1000) div LTime;
  TThread.Queue(nil,
    procedure
    begin
      pbDownload.Value := 100 div LSize * AReadCount;
    end);
end;

procedure TForm1.mnuCenterRelativeClick(Sender: TObject);
begin
  mnuCenterRelative.Checked := not mnuCenterRelative.Checked;
  chkCenterRelative.Checked := mnuCenterRelative.Checked;
end;

procedure TForm1.SetAutoStart(runwithwindows: Boolean);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
    if runwithwindows then
      reg.WriteString('TaskbarDock', AppPath)
    else
      if reg.ValueExists('TaskbarDock') then
        reg.DeleteValue('TaskbarDock');
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

procedure TForm1.mnuSmallClick(Sender: TObject);
begin
  Taskbars.SmallIcons := not mnuSmall.Checked;
  mnuSmall.Checked := Taskbars.SmallIcons;
  Taskbars.Refresh;
  chkSmall.Checked := mnuSmall.Checked;
end;

// syncs check statuses from popupmenu to settings page
procedure TForm1.SyncSettingsPage;
begin
  chkStart.Checked := mnuStart.Checked;
  chkTray.Checked := mnuTray.Checked;
  chkTransparent.Checked := mnuTransparent.Checked;
  chkCenter.Checked:= mnuCenter.Checked;
  chkCenterRelative.Checked := mnuCenterRelative.Checked;
  chkAutoStart.Checked := mnuStartwithWindows.Checked;
end;

function TForm1.SystemUsesLightTheme: Boolean;
var
  Reg: TRegistry;
begin
  Result := False;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') then
    begin
      if Reg.ValueExists('SystemUsesLightTheme') then
        if (Reg.ReadInteger('SystemUsesLightTheme') = 1) then
          Result := True;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TForm1.mnuStartClick(Sender: TObject);
begin
  mnuStart.Checked := not mnuStart.Checked;
  chkStart.Checked := mnuStart.Checked;
end;

procedure TForm1.mnuStartwithWindowsClick(Sender: TObject);
begin
  mnuStartwithWindows.Checked := not mnuStartwithWindows.Checked;
  SetAutoStart(mnuStartwithWindows.Checked);
  chkAutoStart.Checked := mnuStartwithWindows.Checked;
end;

procedure TForm1.tbsSettingsShow(Sender: TObject);
begin
  chkAnimation.Checked := Taskbars.TaskbarAnimation;
end;

procedure TForm1.tmrCenterTimer(Sender: TObject);
var
  fgwnd: THandle;
  dc: HDC;
  MainTaskbar: PTaskbar;
begin
  MainTaskbar := nil;

  if Taskbars.Count = 0 then Exit;

  if Taskbars.IsStartMenuVisible then
    frmSkin1.UText3.Caption := 'Start Menu Visible'
  else
    frmSkin1.UText3.Caption := '';
  if tmrUpdateTBinfo.Enabled then
  begin
    Taskbars.CenterAppsButtons(mnuCenter.Checked, mnuCenterRelative.Checked);

    if chkSkinEnabled.Checked then
    begin
      if skinFrm = nil then
        skinFrm := TForm2.CreateNew(Self,Taskbars.MainTaskbar.Handle);

      if not IsWindowVisible(skinFrm.Handle) then
        skinFrm.Show;

      MainTaskbar := Taskbars.MainTaskbar;

      if MainTaskbar <> nil then
      begin
        if MainTaskbar.MSTaskRect.Left <> Taskbars.MainTaskbar.MSTaskListWClass.Rect.Left then
        begin
          skinFrm.Width := MainTaskbar.MSTaskListWClass.Rect.Width; //Taskbar.MSTaskListRect.Width;
          skinFrm.Height := MainTaskbar.MSTaskListWClass.Rect.Height;
          skinFrm.Top := MainTaskbar.MSTaskListWClass.Rect.Top;
          skinFrm.Left := MainTaskbar.MSTaskListWClass.Rect.Left;
        end;
      end;

      // Windows 10 mode  = 0
      if frmSkin1.ComboBox1.ItemIndex = 0 then
      begin

      end;

      fgwnd := GetForegroundWindow;
      if (fgwnd <> prevForegroundWindow) then
      begin
        prevForegroundWindow := fgwnd;
        startmenuVisible := False;
        //if (fgwnd = Taskbar.Handle)
        //then
        //begin
        //  ForceForeground(Form2.Handle);
        //  ForceForeground(Taskbar.Handle);
        //end;
      end;
      // let's show the skin when start menu open while
      // fullscreen on some windows
(*      if (Taskbar.IsStartMenuVisible) and (startmenuVisible = False) then
      begin
        startmenuVisible := True;
        ForceForeground(Form2.Handle);
        ForceForeground(Taskbar.Handle);
        PostMessage(Handle, WM_SYSCOMMAND, SC_TASKLIST, 0);
      end*)
      //if Taskbar.IsStartMenuVisible then
      //begin
      //  SetWindowPos(Form2.Handle, HWND_TOP, 0, 0, 0, 0,
      //    SWP_NOMOVE or
      //    SWP_NOSENDCHANGING or
      //    SWP_NOSIZE or
      //    SWP_NOACTIVATE or
      //    SWP_ASYNCWINDOWPOS
      //  );
      //  SetWindowPos(Taskbar.Handle, HWND_TOP, 0, 0, 0, 0,
      //    SWP_NOMOVE or
      //    SWP_NOSENDCHANGING or
      //    SWP_NOSIZE or
      //    SWP_NOACTIVATE or
      //    SWP_ASYNCWINDOWPOS
      //  );
        {dc := GetDC(Taskbar.Handle);
        try
          if PtVisible(dc, Taskbar.Rect.Width div 2, Taskbar.Rect.Height div 2) then
          begin
            ForceForeground(Form2.Handle);
            ForceForeground(Taskbar.Handle);
          end;
        finally
          ReleaseDC(Taskbar.Handle, dc);
        end;}
      //end;

      // hide skin on fullscreen windows
      (*if IsFullScreenWindow(fgwnd)
      then
      begin
        {SetWindowPos(Form2.Handle, HWND_BOTTOM, 0, 0, 0, 0,
          SWP_NOMOVE or
          SWP_NOSENDCHANGING or
          SWP_NOSIZE or
          SWP_NOACTIVATE or
          SWP_ASYNCWINDOWPOS
        );}

        ShowWindow(Form2.Handle, SW_HIDE);
      end
      else
        if not IsWindowVisible(Form2.Handle) then
          ShowWindow(Form2.Handle, SW_SHOWNOACTIVATE);*)
    end
    else
    begin
      if IsWindowVisible(skinFrm.Handle) then
        skinFrm.Hide;
    end;
  end;
end;

procedure TForm1.tmrOptionsTimer(Sender: TObject);
var
  sm: THandle;
  smr: TRect;
  I: Integer;
begin
  try
    ms := Mouse.CursorPos;
  except
  end;

  if mnuStart.Checked or Taskbars.IsStartMenuVisible then
  begin
    for I := 0 to Taskbars.Count - 1 do
      ShowWindow(Taskbars.Items[I].StartButton.Handle, SW_SHOWNOACTIVATE);
  end
  else
  begin
    for I := 0 to Taskbars.Count - 1 do
      if (ms.X >= Taskbars.Items[I].StartRect.Left)
      and (ms.X <= Taskbars.Items[I].StartRect.Right)
      and (ms.Y >= Taskbars.Items[I].StartRect.Top)
      and (ms.Y <= Taskbars.Items[I].StartRect.Bottom)
      then
        ShowWindow(Taskbars.Items[I].StartButton.Handle, SW_SHOWNOACTIVATE)
      else
        ShowWindow(Taskbars.Items[I].StartButton.Handle, SW_HIDE);
  end;

  if mnuTray.Checked then
  begin
    Taskbars.NotifyAreaVisible();
  end
  else
  begin
    //Taskbars.NotifyAreaVisible(False);
    for I := 0 to Taskbars.Count - 1 do
      if (ms.X >= Taskbars.Items[I].TrayRect.Left)
      and (ms.X <= Taskbars.Items[I].TrayRect.Right)
      and (ms.Y >= Taskbars.Items[I].TrayRect.Top)
      and (ms.Y <= Taskbars.Items[I].TrayRect.Bottom)
      then
        ShowWindow(Taskbars.Items[I].TrayWnd.Handle, SW_SHOWNOACTIVATE)
      else
        ShowWindow(Taskbars.Items[I].TrayWnd.Handle, SW_HIDE);
  end;

  if mnuFull.Checked then
  begin
    //Taskbar2.FullTaskBar;
    //Taskbar.FullTaskBar;
    //for I := 0 to Taskbars.Count - 1 do
      //Taskbars.Items[0].FullTaskBar;
  end;

end;

procedure TForm1.tmrThreadWaiterTimer(Sender: TObject);
begin
  if not ThreadIsRunning then
    Close
end;

procedure TForm1.tmrUpdateTBinfoTimer(Sender: TObject);
begin
  Taskbars.UpdateTaskbarInfo;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  if IsWindowVisible(Self.Handle) then
    Hide
  else
    Show;
end;

procedure TForm1.UButton1Click(Sender: TObject);
begin
//  CloseApp := True;
  Hide
end;

procedure TForm1.UButton2Click(Sender: TObject);
begin
  if WindowState <> wsMaximized then
    WindowState := wsMaximized
  else
    WindowState := wsNormal;
end;

procedure TForm1.UButton3Click(Sender: TObject);
begin
  WindowState := wsMinimized;
end;


procedure TForm1.btnCheckUpdateClick(Sender: TObject);
begin
  btnCheckUpdate.Enabled := False;
  CheckUpdate;
end;

procedure PremultiplyBitmap(Bitmap: TBitmap);
var
  Row, Col: integer;
  p: PRGBQuad;
  PreMult: array[byte, byte] of byte;
begin
  // precalculate all possible values of a*b
  for Row := 0 to 255 do
    for Col := Row to 255 do
    begin
      PreMult[Row, Col] := Row*Col div 255;
      if (Row <> Col) then
        PreMult[Col, Row] := PreMult[Row, Col]; // a*b = b*a
    end;

  for Row := 0 to Bitmap.Height-1 do
  begin
    Col := Bitmap.Width;
    p := Bitmap.ScanLine[Row];
    while (Col > 0) do
    begin
      p.rgbBlue := PreMult[p.rgbReserved, p.rgbBlue];
      p.rgbGreen := PreMult[p.rgbReserved, p.rgbGreen];
      p.rgbRed := PreMult[p.rgbReserved, p.rgbRed];
      inc(p);
      dec(Col);
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  BlendFunc: TBlendFunction;
  BmpPos, BmpOffest: TPoint;
  BmpSize: TSize;
  Bitmap: TBitmap;
  PNGBitmap: TGPBitmap;
  BitmapHandle: HBITMAP;
begin
  Taskbars.PinTaskbar(PChar(AppPath), false);

  Exit;
//  ListBox1.Items := Taskbars.ListMainTaskbarElements;

  SetWindowLong( Taskbars.MainTaskbar.MSTaskListWClass.Handle,GWL_EXSTYLE ,
  getwindowlong( Taskbars.MainTaskbar.MSTaskListWClass.Handle, GWL_EXSTYLE) or WS_EX_LAYERED );
  SetLayeredWindowAttributes(Taskbars.MainTaskbar.MSTaskListWClass.Handle, 0, 195, LWA_ALPHA);

  SetWindowLong( Taskbars.MainTaskbar.StartButton.Handle,GWL_EXSTYLE ,
  getwindowlong( Taskbars.MainTaskbar.StartButton.Handle, GWL_EXSTYLE) or WS_EX_LAYERED );
  SetLayeredWindowAttributes(Taskbars.MainTaskbar.StartButton.Handle, 0, 180, LWA_ALPHA);

  SetWindowLong( Taskbars.MainTaskbar.TrayWnd.Handle,GWL_EXSTYLE ,
  getwindowlong( Taskbars.MainTaskbar.TrayWnd.Handle, GWL_EXSTYLE) or WS_EX_LAYERED );
  SetLayeredWindowAttributes(Taskbars.MainTaskbar.TrayWnd.Handle, 0, 180, LWA_ALPHA);

  BmpPos := Point(0,
                  0);
  BmpOffest := Point(Taskbars.MainTaskbar.MSTaskListWClass.Rect.Left,
                    Taskbars.MainTaskbar.Rect.Top);


  BlendFunc.BlendOp := AC_SRC_OVER;
  BlendFunc.BlendFlags := 0;
  BlendFunc.SourceConstantAlpha := 255;
  BlendFunc.AlphaFormat := 0;


  Bitmap := TBitmap.Create;
  try

  PNGBitmap := TGPBitmap.Create('L:\Proyectos\TaskbarDock\Win32\Debug\skins\Sierra\bigdemo.png');
  PNGBitmap.GetHBITMAP($00000000, BitmapHandle);
  Bitmap.Handle := BitmapHandle;

  PremultiplyBitmap(Bitmap);

  BmpSize.cx := Bitmap.Width;
  BmpSize.cy := Bitmap.Height;


  SetWindowLong( Taskbars.MainTaskbar.Handle,GWL_EXSTYLE ,
  getwindowlong( Taskbars.MainTaskbar.Handle, GWL_EXSTYLE) and not WS_EX_LAYERED );
  UpdateLayeredWindow(Taskbars.MainTaskbar.Handle,
    0, nil, @BmpSize, Bitmap.Canvas.Handle,@BmpPos, 0, @BlendFunc, ULW_ALPHA);
  finally
    Bitmap.Free;

  end;

end;

procedure TForm1.CheckUpdate;
var
  URL: String;
  LResponse: IHTTPResponse;
//  LFileName: String;
begin
//  LFileName := ExtractFilePath(ParamStr(0)) + 'TAG';
  try
    URL := 'https://raw.githubusercontent.com/vhanla/taskbardock/master/TAG';

    LResponse := FClient.Head(URL);
    LSize := LResponse.ContentLength;
    LResponse := nil;

    pbDownload.Value := 0;

    //FDownloadStream := TFileStream.Create(LFileName, fmCreate);
    FDownloadStream := TMemoryStream.Create;
    FDownloadStream.Position := 0;

    FGlobalStart := TThread.GetTickCount;

    FAsyncResult := FClient.BeginGet(DoEndDownload, URL, FDownloadStream);
  finally
    btnCheckUpdate.Enabled := FAsyncResult = nil;
  end;
end;

procedure TForm1.chkAnimationClick(Sender: TObject);
begin
  Taskbars.TaskbarAnimation := chkAnimation.Checked;
end;

procedure TForm1.chkAutoStartClick(Sender: TObject);
begin
  mnuStartwithWindows.Checked := chkAutoStart.Checked;
  SetAutoStart(mnuStartwithWindows.Checked);
end;

procedure TForm1.chkCenterClick(Sender: TObject);
begin
  mnuCenter.Checked := chkCenter.Checked;
  Taskbars.CenterAppsButtons(mnuCenter.Checked, mnuCenterRelative.Checked);
end;

procedure TForm1.chkCenterRelativeClick(Sender: TObject);
begin
  mnuCenterRelative.Checked := chkCenterRelative.Checked;
end;

procedure TForm1.chkSmallClick(Sender: TObject);
begin
  mnuSmall.Checked := chkSmall.Checked;
  Taskbars.SmallIcons := mnuSmall.Checked;
  mnuSmall.Checked := Taskbars.SmallIcons;
  Taskbars.Refresh;
end;

procedure TForm1.chkStartClick(Sender: TObject);
begin
  mnuStart.Checked := chkStart.Checked;
end;

procedure TForm1.chkTransparentClick(Sender: TObject);
begin
  mnuTransparent.Checked := chkTransparent.Checked;
  if not mnuTransparent.Checked then
    Taskbars.RestoreOpacity(Handle);
end;

procedure TForm1.chkTrayClick(Sender: TObject);
begin
  mnuTray.Checked := chkTray.Checked;
end;

procedure TForm1.USymbolButton1Click(Sender: TObject);
var
  DPI: Single;
  AniWidth: Integer;
begin
  DPI := PPI / 96;
  AniWidth := Round((220 - 45 ) * DPI);
  if UPanel1.Width <> Round(45 * DPI) then
    AniWidth := - AniWidth;

  UPanel1.AnimationFromCurrent(apWidth, AniWidth, 20, 200, akOut, afkQuartic, nil);
end;

procedure TForm1.USymbolButton2Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  chkSmall.Checked := Taskbars.SmallIcons;
end;

procedure TForm1.USymbolButton3Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
end;

procedure TForm1.USymbolButton4Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 3;
  frameIcons1.ListLnkFiles;
end;

procedure TForm1.USymbolButton5Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 2;
end;

procedure TForm1.USymbolButton7Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 5;
end;

(*procedure TForm1.WMCopyData(var Msg: TMessage);
var
  FMsg: PCopyDataStruct;
  Data: PMouseHookStruct;
begin
  Msg.Result := 0;
  FMsg := PCopyDataStruct(Msg.LParam);
  if FMsg = nil then
    Exit;

  Data := PMouseHookStruct(FMsg.lpData);
//  Str := String(UTF8String(PAnsiChar(FMsg^.lpData)));
//  MsgID := FMsg^.dwData;
//  case MsgID of
//    WM_MOUSE_COORDS:
//    begin
//
//    end;
//  end;

  UCaptionBar1.Caption := IntToStr(Data^.pt.X);
//  ms := Data^.pt;
  Inc(Data^.pt.X);
  Inc(Data^.pt.Y);
  //HotSpotAction(Data^.pt);

  Msg.Result := 1;

//  tmrOptionsTimer(Self);
end;*)

procedure TForm1.WndProc(var Msg: TMessage);
var
  margins: _MARGINS;
  v: Integer;
begin
  if Msg.Msg = fwm_TaskbarRestart then
  begin
    Taskbars.UpdateTaskbarInfo;
  end
  else
  begin
    case (Msg.Msg) of
    WM_NCPAINT:
      begin
      {  v := 2;
        DwmSetWindowAttribute(Self.Handle, 2, @v, 4);
        DwmExtendFrameIntoClientArea(Self.Handle, margins);}
      end;
    WM_DWMCOLORIZATIONCOLORCHANGED:
      begin
        // add or remove taskbars
      end;
    WM_DISPLAYCHANGE:
      begin
        // monitor settings changed
        // added or duplicated
        Taskbars.Refresh;
      end;
    WM_SETTINGCHANGE:
      begin
        // when taskbar is allowed to be shown on multiple monitors
        // this event is sent, but it is also sent when taskbar is resized or moved
        // and if its set to hidden or visible in desktop mode
        if msg.WParam = SPI_SETWORKAREA then
          Taskbars.Refresh;
      end;
    end;

  end;

  inherited WndProc(Msg);
end;

end.
