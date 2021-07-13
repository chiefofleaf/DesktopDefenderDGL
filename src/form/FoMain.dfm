object fmMain: TfmMain
  Left = 1400
  Top = 700
  Caption = 'asdf'
  ClientHeight = 611
  ClientWidth = 988
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = 65793
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 988
    Height = 611
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 408
    ExplicitTop = 184
    ExplicitWidth = 185
    ExplicitHeight = 41
    object pnGUI: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 609
      Align = alLeft
      TabOrder = 0
      Visible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 611
      object Button1: TButton
        Left = 48
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
      end
      object Button2: TButton
        Left = 48
        Top = 136
        Width = 75
        Height = 25
        Caption = 'Button2'
        TabOrder = 1
      end
      object CheckBox1: TCheckBox
        Left = 48
        Top = 248
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 2
      end
    end
  end
  object tmFPS: TTimer
    Interval = 400
    OnTimer = tmFPSTimer
    Left = 16
    Top = 552
  end
end
