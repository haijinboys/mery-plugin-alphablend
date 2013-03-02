object PropForm: TPropForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21322#36879#26126
  ClientHeight = 81
  ClientWidth = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AlphaBlendLabel: TLabel
    Left = 8
    Top = 12
    Width = 68
    Height = 13
    Caption = #19981#36879#26126#24230'(&O):'
  end
  object Bevel: TBevel
    Left = 0
    Top = 40
    Width = 185
    Height = 9
    Shape = bsTopLine
  end
  object OKButton: TButton
    Left = 8
    Top = 48
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 96
    Top = 48
    Width = 81
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 1
  end
  object AlphaBlendSpinEdit: TSpinEditEx
    Left = 96
    Top = 8
    Width = 81
    Height = 22
    MaxLength = 3
    MaxValue = 100
    MinValue = 1
    TabOrder = 2
    Value = 1
  end
end
