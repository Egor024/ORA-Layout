object frmMain: TfrmMain
  Left = 0
  Top = 0
  ClientHeight = 294
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object tiMain: TTrayIcon
    BalloonHint = 'I am here!'
    BalloonTitle = 'I am here!'
    BalloonFlags = bfInfo
    Visible = True
    OnClick = tiMainClick
    Left = 136
    Top = 48
  end
end
