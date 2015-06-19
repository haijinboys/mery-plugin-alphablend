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
  TPropForm = class(TScaledForm)
    AlphaBlendLabel: TLabel;
    AlphaBlendSpinEdit: TSpinEditEx;
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

function Prop(AOwner: TComponent; var AAlphaBlend: NativeInt): Boolean;

var
  PropForm: TPropForm;
  FFont: TFont;

implementation

{$R *.dfm}


uses
{$IF CompilerVersion > 22.9}
  System.Math, System.IniFiles,
{$ELSE}
  Math, IniFiles,
{$IFEND}
  mCommon;

function Prop(AOwner: TComponent; var AAlphaBlend: NativeInt): Boolean;
begin
  with TPropForm.Create(AOwner) do
    try
      AlphaBlendSpinEdit.Value := Round(AAlphaBlend * 100 / 255);
      Result := ShowModal = mrOk;
      if Result then
        AAlphaBlend := Round(AlphaBlendSpinEdit.Value * 255 / 100);
    finally
      Release;
    end;
end;

procedure TPropForm.FormCreate(Sender: TObject);
begin
  if Win32MajorVersion < 6 then
    with Font do
    begin
      Name := 'Tahoma';
      Size := 8;
    end;
  FFont.Assign(Font);
  ReadIni;
  with Font do
  begin
    ChangeScale(FFont.Size, Size);
    Name := FFont.Name;
    Size := FFont.Size;
  end;
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
      with FFont do
        if ValueExists('MainForm', 'FontName') then
        begin
          Name := ReadString('MainForm', 'FontName', Name);
          Size := ReadInteger('MainForm', 'FontSize', Size);
          Height := MulDiv(Height, 96, Screen.PixelsPerInch);
        end
        else if (Win32MajorVersion > 6) or ((Win32MajorVersion = 6) and (Win32MinorVersion >= 2)) then
        begin
          Assign(Screen.IconFont);
          Height := MulDiv(Height, 96, Screen.PixelsPerInch);
        end;
    finally
      Free;
    end;
end;

initialization

FFont := TFont.Create;

finalization

if Assigned(FFont) then
  FreeAndNil(FFont);

end.
