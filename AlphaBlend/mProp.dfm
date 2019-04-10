object PropForm: TPropForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21322#36879#26126
  ClientHeight = 113
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
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
    Top = 72
    Width = 257
    Height = 9
    Shape = bsTopLine
  end
  object OKButton: TButton
    Left = 80
    Top = 80
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 168
    Top = 80
    Width = 81
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 1
  end
  object AlphaBlendSpinEdit: TSpinEditEx
    Left = 80
    Top = 8
    Width = 65
    Height = 22
    MaxLength = 3
    MaxValue = 100
    MinValue = 1
    NumbersOnly = True
    TabOrder = 2
    Value = 1
  end
  object EnableShortCutCheckBox: TCheckBox
    Left = 8
    Top = 40
    Width = 241
    Height = 17
    Caption = 'Shift '#12461#12540#12392#12507#12452#12540#12523#12391#19981#36879#26126#24230#12434#22793#26356'(&E)'
    TabOrder = 3
  end
end
