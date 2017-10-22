// -----------------------------------------------------------------------------
// ”¼“§–¾
//
// Copyright (c) Kuro. All Rights Reserved.
// e-mail: info@haijin-boys.com
// www:    https://www.haijin-boys.com/
// -----------------------------------------------------------------------------

unit mAlphaBlend;

interface

uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.Messages, System.SysUtils,
{$ELSE}
  Windows, Messages, SysUtils,
{$IFEND}
  mCommon, mFrame, mPlugin;

resourcestring
  SName = '”¼“§–¾';
  SVersion = '2.3.1';

type
  TAlphaBlendFrame = class(TFrame)
  private
    { Private éŒ¾ }
    FOpenStartup: Boolean;
    FAlphaBlend: Integer;
    FEnableShortCut: Boolean;
    function QueryProperties: Boolean;
    function SetProperties: Boolean;
    function PreTranslateMessage(hwnd: HWND; var Msg: tagMSG): Boolean;
    procedure SetAlphaBlend(const Value: Boolean);
  protected
    { Protected éŒ¾ }
  public
    { Public éŒ¾ }
    procedure OnCommand(hwnd: HWND); override;
    function QueryStatus(hwnd: HWND; pbChecked: PBOOL): BOOL; override;
    procedure OnEvents(hwnd: HWND; nEvent: Cardinal; lParam: LPARAM); override;
    function PluginProc(hwnd: HWND; nMsg: Cardinal; wParam: WPARAM; lParam: LPARAM): LRESULT; override;
  end;

implementation

uses
{$IF CompilerVersion > 22.9}
  System.IniFiles,
{$ELSE}
  IniFiles,
{$IFEND}
  mProp;

{ TAlphaBlendFrame }

function TAlphaBlendFrame.QueryProperties: Boolean;
begin
  Result := True;
end;

function TAlphaBlendFrame.SetProperties: Boolean;
begin
  Result := False;
  if Prop(Handle, FAlphaBlend, FEnableShortCut) then
  begin
    SetAlphaBlend(FOpenStartup);
    Result := True;
  end;
end;

function TAlphaBlendFrame.PreTranslateMessage(hwnd: HWND; var Msg: tagMSG): Boolean;
var
  Ctrl: Boolean;
  LAlphaBlend: Cardinal;
begin
  Result := False;
  if not FEnableShortCut then
    Exit;
  if FOpenStartup and IsChild(hwnd, GetFocus) then
  begin
    Ctrl := GetKeyState(VK_SHIFT) < 0;
    if Ctrl and (Msg.message = WM_MOUSEWHEEL) then
    begin
      LAlphaBlend := Round(FAlphaBlend * 100 / 255);
      if ShortInt(HIWORD(Msg.wParam)) > 0 then
        Inc(LAlphaBlend, 4)
      else
        Dec(LAlphaBlend, 4);
      if LAlphaBlend > 100 then
        LAlphaBlend := 100;
      if LAlphaBlend < 1 then
        LAlphaBlend := 1;
      FAlphaBlend := Round(LAlphaBlend * 255 / 100);
      SetAlphaBlend(FOpenStartup);
      Result := True;
    end;
  end;
end;

procedure TAlphaBlendFrame.SetAlphaBlend(const Value: Boolean);
const
  cUseAlpha: array [Boolean] of Integer = (0, LWA_ALPHA);
var
  Style: Integer;
begin
  Style := GetWindowLong(Handle, GWL_EXSTYLE);
  if Value then
  begin
    if (Style and WS_EX_LAYERED) = 0 then
      SetWindowLong(Handle, GWL_EXSTYLE, Style or WS_EX_LAYERED);
    SetLayeredWindowAttributes(Handle, 0, FAlphaBlend, cUseAlpha[FOpenStartup]);
  end
  else
  begin
    SetWindowLong(Handle, GWL_EXSTYLE, Style and not WS_EX_LAYERED);
    RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
  end;
end;

procedure TAlphaBlendFrame.OnCommand(hwnd: HWND);
begin
  FOpenStartup := not FOpenStartup;
  SetAlphaBlend(FOpenStartup);
end;

function TAlphaBlendFrame.QueryStatus(hwnd: HWND; pbChecked: PBOOL): BOOL;
begin
  pbChecked^ := FOpenStartup;
  Result := True;
end;

procedure TAlphaBlendFrame.OnEvents(hwnd: HWND; nEvent: Cardinal; lParam: LPARAM);
var
  S: string;
begin
  if (nEvent and EVENT_CREATE_FRAME) <> 0 then
  begin
    if not GetIniFileName(S) then
      Exit;
    with TMemIniFile.Create(S, TEncoding.UTF8) do
      try
        FOpenStartup := ReadBool('AlphaBlend', 'OpenStartup', False);
        FAlphaBlend := ReadInteger('AlphaBlend', 'AlphaBlend', 192);
        FEnableShortCut := ReadBool('AlphaBlend', 'EnableShortCut', True);
      finally
        Free;
      end;
    if FOpenStartup then
      SetAlphaBlend(FOpenStartup);
  end;
  if (nEvent and EVENT_CLOSE_FRAME) <> 0 then
  begin
    if FIniFailed or (not GetIniFileName(S)) then
      Exit;
    try
      with TMemIniFile.Create(S, TEncoding.UTF8) do
        try
          WriteBool('AlphaBlend', 'OpenStartup', FOpenStartup);
          WriteInteger('AlphaBlend', 'AlphaBlend', FAlphaBlend);
          WriteBool('AlphaBlend', 'EnableShortCut', FEnableShortCut);
          UpdateFile;
        finally
          Free;
        end;
    except
      FIniFailed := True;
    end;
  end;
end;

function TAlphaBlendFrame.PluginProc(hwnd: HWND; nMsg: Cardinal; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case nMsg of
    MP_QUERY_PROPERTIES:
      Result := LRESULT(QueryProperties);
    MP_SET_PROPERTIES:
      Result := LRESULT(SetProperties);
    MP_PRE_TRANSLATE_MSG:
      Result := LRESULT(PreTranslateMessage(hwnd, PMsg(lParam)^));
  end;
end;

end.
