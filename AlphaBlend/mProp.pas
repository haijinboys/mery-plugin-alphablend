unit mProp;

interface

uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
{$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
{$IFEND}
  MeryCtrls, mPerMonitorDpi;

type
  TCenterForm = class(TScaledForm)
  private
    { Private éŒ¾ }
    FWndParent: THandle;
  protected
    { Protected éŒ¾ }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoShow; override;
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent; AParent: THandle); reintroduce;
  end;

  TPropForm = class(TCenterForm)
    AlphaBlendLabel: TLabel;
    AlphaBlendSpinEdit: TSpinEditEx;
    EnableShortCutCheckBox: TCheckBox;
    Bevel: TBevel;
    OKButton: TButton;
    CancelButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private éŒ¾ }
    procedure ReadIni;
  public
    { Public éŒ¾ }
  end;

function Prop(AParent: THandle; var AAlphaBlend: Integer;
  var AEnableShortCut: Boolean): Boolean;

var
  PropForm: TPropForm;

implementation

{$R *.dfm}


uses
{$IF CompilerVersion > 22.9}
  System.Math, System.IniFiles, Winapi.MultiMon,
{$ELSE}
  Math, IniFiles, MultiMon,
{$IFEND}
  mCommon;

function Prop(AParent: THandle; var AAlphaBlend: Integer;
  var AEnableShortCut: Boolean): Boolean;
begin
  with TPropForm.Create(nil, AParent) do
    try
      AlphaBlendSpinEdit.Value := Round(AAlphaBlend * 100 / 255);
      EnableShortCutCheckBox.Checked := AEnableShortCut;
      Result := ShowModal = mrOk;
      if Result then
      begin
        AAlphaBlend := Round(AlphaBlendSpinEdit.Value * 255 / 100);
        AEnableShortCut := EnableShortCutCheckBox.Checked;
      end;
    finally
      Release;
    end;
end;

{ TCenterForm }

constructor TCenterForm.Create(AOwner: TComponent; AParent: THandle);
var
  AppMon, WinMon: HMONITOR;
  I, J: Integer;
  LLeft, LTop: Integer;
begin
  FWndParent := AParent;
  inherited Create(AOwner);
  AppMon := Screen.MonitorFromWindow(GetParent(Handle), mdNearest).Handle;
  WinMon := Monitor.Handle;
  for I := 0 to Screen.MonitorCount - 1 do
    if Screen.Monitors[I].Handle = AppMon then
      if AppMon <> WinMon then
        for J := 0 to Screen.MonitorCount - 1 do
          if Screen.Monitors[J].Handle = WinMon then
          begin
            LLeft := Screen.Monitors[I].Left + Left - Screen.Monitors[J].Left;
            if LLeft + Width > Screen.Monitors[I].Left + Screen.Monitors[I].Width then
              LLeft := Screen.Monitors[I].Left + Screen.Monitors[I].Width - Width;
            LTop := Screen.Monitors[I].Top + Top - Screen.Monitors[J].Top;
            if LTop + Height > Screen.Monitors[I].Top + Screen.Monitors[I].Height then
              LTop := Screen.Monitors[I].Top + Screen.Monitors[I].Height - Height;
            SetBounds(LLeft, LTop, Width, Height);
          end;
end;

procedure TCenterForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := FWndParent;
end;

procedure TCenterForm.DoShow;
var
  H: THandle;
  R1, R2: TRect;
begin
  H := GetParent(Handle);
  if (H = 0) or IsIconic(H) then
    H := GetDesktopWindow;
  if GetWindowRect(H, R1) and GetWindowRect(Handle, R2) then
    SetWindowPos(Handle, 0,
      R1.Left + (((R1.Right - R1.Left) - (R2.Right - R2.Left)) div 2),
      R1.Top + (((R1.Bottom - R1.Top) - (R2.Bottom - R2.Top)) div 2),
      0, 0, SWP_NOSIZE or SWP_NOZORDER or SWP_NOACTIVATE);
  inherited;
end;

{ TPropForm }

procedure TPropForm.FormCreate(Sender: TObject);
begin
  TScaledForm.DefaultFont.Assign(Font);
  ReadIni;
end;

procedure TPropForm.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TPropForm.FormShow(Sender: TObject);
begin
  //
end;

procedure TPropForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
end;

procedure TPropForm.ReadIni;
var
  S: string;
begin
  if not GetIniFileName(S) then
    Exit;
  with TMemIniFile.Create(S, TEncoding.UTF8) do
    try
      with TScaledForm.DefaultFont do
        if ValueExists('MainForm', 'FontName') then
        begin
          Name := ReadString('MainForm', 'FontName', Name);
          Size := ReadInteger('MainForm', 'FontSize', Size);
        end
        else if CheckWin32Version(6, 2) then
          Assign(Screen.IconFont);
    finally
      Free;
    end;
end;

end.
