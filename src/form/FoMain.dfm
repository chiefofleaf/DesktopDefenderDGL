object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'asdf'
  ClientHeight = 752
  ClientWidth = 1209
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = 65793
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object tmFPS: TTimer
    Interval = 400
    OnTimer = tmFPSTimer
    Left = 112
    Top = 136
  end
end
