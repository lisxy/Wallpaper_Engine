; ������ Inno Setup �ű������ɵĽű���
; �йش��� Inno Setup �ű��ļ�����ϸ��Ϣ����İ����ĵ�

#define MyAppName "Wallpaper Engine ��ֽ������"
#define MyAppVersion "0.2.7"
#define MyAppPublisher "��������"
#define MyIconFileName ".\windows\runner\resources\app_icon.ico"

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Setup]
; ע: AppId��ֵΪΨһ��ʶ��Ӧ�ó���
; ��ҪΪ������װ����ʹ����ͬ��AppIdֵ��
AppId={{e2bcafae-1d28-4d94-8dad-f18a4198a487}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={code:GetDefaultInstallDir}
DefaultGroupName={#MyAppName}
OutputBaseFilename=Wallpaper_Engine
Compression=lzma
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
SetupIconFile={#MyIconFileName}
; �������ԱȨ��
PrivilegesRequired=admin

[Files]
; ����ǰĿ¼�� \build\windows\x64\runner\Release\* �е������ļ����
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\wallpaper_engine_workshop_downloader.exe"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\wallpaper_engine_workshop_downloader.exe"

[Run]
; �Ƴ���װ���Զ����У�����Ȩ������
; Filename: "{app}\wallpaper_engine_workshop_downloader.exe"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent runasoriginaluser

[Code]
// ���·���Ƿ�����ո���ASCII�ַ������������ĵȣ�
function PathContainsInvalidChars(const Path: String): Boolean;
var
  i: Integer;
begin
  // ����Ƿ�����ո�
  if Pos(' ', Path) > 0 then
  begin
    Result := True;
    Exit;
  end;

  // ����Ƿ������ASCII�ַ�������127���ַ������������ĵȣ�
  for i := 1 to Length(Path) do
  begin
    if Ord(Path[i]) > 127 then
    begin
      Result := True;
      Exit;
    end;
  end;

  // ���û�пո�Ҳû�з�ASCII�ַ�����·���ǺϷ�
  Result := False;
end;

// �ڳ�ʼ����װʱ��鲢�ر��������еĳ���
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  // �ȳ��Թر��������еĳ���
  Exec('taskkill.exe', '/F /IM wallpaper_engine_workshop_downloader.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  // �����Ƿ�ɹ��رգ����������У����ʧ�ܣ����ܳ���û����

  // ������װ
  Result := True;
end;

// ���û������һ��ʱ���·��
function NextButtonClick(CurPageID: Integer): Boolean;
var
  SelectedPath: String;
begin
  // ������ڰ�װĿ¼ҳ��
  if CurPageID = wpSelectDir then
  begin
    // ��ȡ�û���ǰѡ��İ�װ·��
    SelectedPath := WizardDirValue();

    // ���·���Ƿ�����Ƿ��ַ����ո�����ĵȣ�
    if PathContainsInvalidChars(SelectedPath) then
    begin
      MsgBox('���󣺰�װ·���в��ܰ����ո�������ַ���' + #13#10 + '��ǰ·��: ' + SelectedPath, mbError, MB_OK);
      Result := False; // ��ֹ����
      Exit;
    end;
  end;

  // ·���Ϸ���������װ
  Result := True;
end;

function GetDefaultInstallDir(Param: String): String;
var
  Drive: String;
begin
  // �ȳ���ʹ�� D: ��
  Drive := 'D:\';
  if DirExists(Drive) then
  begin
    // D: �̴��ڣ�����ʹ��
    Result := Drive + 'wallpaper_engine_workshop_downloader';
  end
  else
  begin
    // D: �����ڻ��ǹ̶��̣�ʹ��Ĭ�ϵ� {autoprograms}
    Result := ExpandConstant('{autoprograms}\wallpaper_engine_workshop_downloader');
  end;
end;