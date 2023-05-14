﻿; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "WingetUI"
#define MyAppVersion "2.0.0-beta"
#define MyAppPublisher "Martí Climent"
#define MyAppURL "https://github.com/marticliment/WingetUI"
#define MyAppExeName "WingetUI.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
UninstallDisplayName="WingetUI"
AppId={{889610CC-4337-4BDB-AC3B-4F21806C0BDD}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
VersionInfoVersion=2.0.0.0
DefaultDirName="{autopf}\WingetUI"
DisableProgramGroupPage=yes
DisableDirPage=no
CloseApplications=no
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=lowest
OutputBaseFilename=WingetUI Installer
OutputDir=.     
MinVersion=10.0
SetupIconFile=wingetui\resources\icon.ico
UninstallDisplayIcon={app}\WingetUI.exe
Compression=lzma
SolidCompression=yes
WizardStyle=classic
WizardImageFile=INSTALLER.BMP
WizardSmallImageFile=wingetui\resources\icon.bmp
DisableWelcomePage=no
UsePreviousTasks=yes
ChangesEnvironment=yes
RestartIfNeededByRun=no


[Languages]
Name: "English"; MessagesFile: "compiler:Default.isl"
Name: "Armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "BrazilianPortuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "Catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "Corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "Czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "Danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "Dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "Finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "French"; MessagesFile: "compiler:Languages\French.isl"
Name: "German"; MessagesFile: "compiler:Languages\German.isl"
Name: "Hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "Icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "Italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "Japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "Norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "Polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "Portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "Russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "Slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "Spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "Turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "Ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl" 
Name: "Korean"; MessagesFile: "compiler:Languages\Korean.isl"

[InstallDelete]
Type: filesandordirs; Name: "{autopf}\WingetUI\*.pyc"; BeforeInstall: TripleKill('WingetUI.exe', 'winget.exe', 'choco.exe');  
Type: filesandordirs; Name: "{autopf}\WingetUI\PySide6\*"; BeforeInstall: TripleKill('WingetUI.exe', 'winget.exe', 'choco.exe');  
Type: filesandordirs; Name: "{autopf}\WingetUI\pip-23.0.dist-info";
Type: filesandordirs; Name: "{autopf}\WingetUI\pip-23.1.2.dist-info";
Type: filesandordirs; Name: "{autopf}\WingetUI\setuptools-65.5.0.dist-info";   
Type: filesandordirs; Name: "{autopf}\WingetUI\sudo";
Type: filesandordirs; Name: "{autopf}\WingetUI\*.pyc";

[UninstallDelete]
Type: filesandordirs; Name: "{autopf}\WingetUI\*"; BeforeInstall: TripleKill('WingetUI.exe', 'winget.exe', 'choco.exe');

[Code]
procedure InitializeWizard;
begin
  WizardForm.Bevel.Visible := False;
  WizardForm.Bevel1.Visible := True;
end;

procedure TaskKill(FileName: String);
var
  ResultCode: Integer;
begin
    Exec('taskkill.exe', '/f /im ' + '"' + FileName + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

procedure TripleKill(FileName1: String; FileName2: String; FileName3: String);
var
  ResultCode: Integer;
begin
    Exec('taskkill.exe', '/f /im ' + '"' + FileName1 + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
    Exec('taskkill.exe', '/f /im ' + '"' + FileName2 + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);     
    Exec('taskkill.exe', '/f /im ' + '"' + FileName3 + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

function VCRedistNeedsInstall: Boolean;
var 
  status: Cardinal;
begin
  if RegQueryDwordValue(HKEY_LOCAL_MACHINE,
       'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64', 'Installed',
       status) then
  begin
    // Is the installed version at least 14.14 ? 
    Log('VC Redist check');
    Log(IntToStr(status));
    Result := (status<=0);
  end
  else 
  begin
    // Not even an old version installed
    Result := True;
  end;
  if (Result) then
  begin
    ExtractTemporaryFile('vcredist.exe');
  end;
end;
function CmdLineParamExists(const Value: string): Boolean;
var
  I: Integer;  
begin
  Result := False;
  for I := 1 to ParamCount do
    if CompareText(ParamStr(I), Value) = 0 then
    begin
      Result := True;
      Exit;
    end;
end;


[Tasks]
Name: "startmenuicon"; Description: "Create a shortcut on the start menu"; GroupDescription: "Shortcuts";
Name: "desktopicon"; Description: "Create a shortcut on the desktop"; GroupDescription: "Shortcuts"; Flags: unchecked
;Name: "disablescoop"; Description: "Do not install Scoop (recommended for most users)"; GroupDescription: "Scoop Package Manager"; Flags: exclusive
;Name: "installscoop"; Description: "Enable and install Scoop (for advanced users)"; GroupDescription: "Scoop Package Manager"; Flags: exclusive unchecked

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "WingetUI"; ValueData: """{app}\WingetUI.exe"" --daemon"; Flags: uninsdeletevalue

[Files]
Source: "Y:\WinGetUI-Store\wingetuiBin\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; BeforeInstall: TripleKill('WingetUI.exe', 'winget.exe', 'choco.exe');
Source: "Y:\WinGetUI-Store\wingetuiBin\*"; DestDir: "{app}"; Flags: createallsubdirs ignoreversion recursesubdirs;
; MSVC++ redistributable runtime. Extracted by VC2017RedistNeedsInstall(), if needed.
Source: "Y:\WinGetUI-Store\vcredist.exe"; DestDir: {tmp}; Flags: dontcopy
Source: "Y:\WinGetUI-Store\SegUIVar.ttf"; DestDir: "{autofonts}"; FontInstall: "Segoe UI Variable"; Flags: onlyifdoesntexist uninsneveruninstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
;Name: "{autostartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--daemon"
Name: "{autostartmenu}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: startmenuicon
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{tmp}\vcredist.exe"; Flags: runhidden; Parameters: "/install /norestart /passive"; StatusMsg: "Installing Microsoft Visual C++ Redistributables (x64)"; Check: VCRedistNeedsInstall;
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: runasoriginaluser nowait postinstall; Check: not CmdLineParamExists('/NoAutoStart');


[UninstallRun]
Filename: {sys}\taskkill.exe; Parameters: "/f /im WingetUI.exe"; Flags: skipifdoesntexist runhidden;
