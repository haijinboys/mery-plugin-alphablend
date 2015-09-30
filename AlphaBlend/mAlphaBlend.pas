// -----------------------------------------------------------------------------
// ������
//
// Copyright (c) Kuro. All Rights Reserved.
// e-mail: info@haijin-boys.com
// www:    http://www.haijin-boys.com/
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
  SName = '������';
  SVersion = '3.0.0';

type
  TAlphaBlendFrame = class(TFrame)
  private
    { Private �錾 }
    FOpenStartup: Boolean;
    FAlphaBlend: NativeInt;
    function QueryProperties: Boolean;
    function SetProperties: Boolean;
    function PreTranslateMessage(hwnd: HWND; var Msg: tagMSG): Boolean;
    procedure SetAlphaBlend(const Value: Boolean);
  protected
    { Protected �錾 }
  public
    { Public �錾 }
    procedure OnCommand(hwnd: HWND); override;
    function QueryStatus(hwnd: HWND; pbChecked: PBOOL): BOOL; override;
    procedure OnEvents(hwnd: HWND; nEvent: NativeInt; lParam: LPARAM); override;
    function PluginProc(hwnd: HWND; nMsg: NativeInt; wParam: WPARAM; lParam: LPARAM): LRESULT; override;
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
  if Prop(nil, FAlphaBlend) then
  begin
    SetAlphaBlend(FOpenStartup);
    Result := True;
  end;
end;

function TAlphaBlendFrame.PreTranslateMessage(hwnd: HWND; var Msg: tagMSG): Boolean;
var
  Ctrl: Boolean;
  AAlphaBlend: NativeInt;
begin
  Result := False;
  if FOpenStartup and IsChild(hwnd, GetFocus) then
  begin
    Ctrl := GetKeyState(VK_SHIFT) < 0;
    if Ctrl and (Msg.message = WM_MOUSEWHEEL) then
    begin
      AAlphaBlend := Round(FAlphaBlend * 100 / 255);
      if ShortInt(HIWORD(Msg.wParam)) > 0 then
        Inc(AAlphaBlend, 4)
      else
        Dec(AAlphaBlend, 4);
      if AAlphaBlend > 100 then
        AAlphaBlend := 100;
      if AAlphaBlend < 1 then
        AAlphaBlend := 1;
      FAlphaBlend := Round(AAlphaBlend * 255 / 100);
      SetAlphaBlend(FOpenStartup);
      Result := True;
    end;
  end;
end;

procedure TAlphaBlendFrame.SetAlphaBlend(const Value: Boolean);
const
  cUseAlpha: array [Boolean] of NativeInt = (0, LWA_ALPHA);
var
  Style: NativeInt;
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

procedure TAlphaBlendFrame.OnEvents(hwnd: HWND; nEvent: NativeInt; lParam: LPARAM);
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
          UpdateFile;
        finally
          Free;
        end;
    except
      FIniFailed := True;
    end;
  end;
end;

function TAlphaBlendFrame.PluginProc(hwnd: HWND; nMsg: NativeInt; wParam: WPARAM; lParam: LPARAM): LRESULT;
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
