object SQLEditForm: TSQLEditForm
  Left = 721
  Top = 369
  BorderIcons = [biSystemMenu]
  Caption = 'SQL Editor'
  ClientHeight = 611
  ClientWidth = 916
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 593
    Width = 916
    Height = 18
    Panels = <>
    SimplePanel = True
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 916
    Height = 33
    Align = alTop
    TabOrder = 2
    object LogonBtn: TSpeedButton
      Tag = -1
      Left = 3
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Logon'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5000555555555555577755555555555550B0555555555555F7F7555555555550
        00B05555555555577757555555555550B3B05555555555F7F557555555555000
        3B0555555555577755755555555500B3B0555555555577555755555555550B3B
        055555FFFF5F7F5575555700050003B05555577775777557555570BBB00B3B05
        555577555775557555550BBBBBB3B05555557F555555575555550BBBBBBB0555
        55557F55FF557F5555550BB003BB075555557F577F5575F5555577B003BBB055
        555575F7755557F5555550BB33BBB0555555575F555557F555555507BBBB0755
        55555575FFFF7755555555570000755555555557777775555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = LogonBtnClick
    end
    object ExecuteBtn: TSpeedButton
      Tag = -1
      Left = 36
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Execute statement  (Ctrl+R)'
      Flat = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777770000777777877777777777777777F77777777777
        0000777770887777777777777778FF7777777777000077777008877777777777
        777887F7777777770000777770A08877777777777778F87F7777777700007777
        70AA0887777777777778F787F777777700007777707A7088777777777778F778
        7F7777770000777770AAAA08877777777778F77787F777770000777770A7A7A0
        887777777778F777787F77770000777770AAAAAA077777777778F77777877777
        00007777707A7A70777777777778F777787777770000777770AAAA0777777777
        7778F777877777770000777770A7A077777777777778F7787777777700007777
        70AA0777777777777778F787777777770000777770707777777777777778F877
        7777777700007777700777777777777777788777777777770000777770777777
        7777777777787777777777770000777777777777777777777777777777777777
        0000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = ExecuteBtnClick
    end
    object DescribeBtn: TSpeedButton
      Tag = -1
      Left = 88
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Parse select statement  (Ctrl+D)'
      Enabled = False
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555555555555555555555555555555555555555FF55555555555559055555
        55555555577FF5555555555599905555555555557777F5555555555599905555
        555555557777FF5555555559999905555555555777777F555555559999990555
        5555557777777FF5555557990599905555555777757777F55555790555599055
        55557775555777FF5555555555599905555555555557777F5555555555559905
        555555555555777FF5555555555559905555555555555777FF55555555555579
        05555555555555777FF5555555555557905555555555555777FF555555555555
        5990555555555555577755555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = DescribeBtnClick
    end
    object VariablesBtn: TSpeedButton
      Tag = -1
      Left = 120
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Edit variables  (Ctrl+P)'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333FF3333333333333C0C333333333333F777F3333333333CC0F0C3
        333333333777377F33333333C30F0F0C333333337F737377F333333C00FFF0F0
        C33333F7773337377F333CC0FFFFFF0F0C3337773F33337377F3C30F0FFFFFF0
        F0C37F7373F33337377F00FFF0FFFFFF0F0C7733373F333373770FFFFF0FFFFF
        F0F073F33373F333373730FFFFF0FFFFFF03373F33373F333F73330FFFFF0FFF
        00333373F33373FF77333330FFFFF000333333373F333777333333330FFF0333
        3333333373FF7333333333333000333333333333377733333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = VariablesBtnClick
    end
    object PBox: TPaintBox
      Left = 481
      Top = 3
      Width = 6
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object HelpBtn: TSpeedButton
      Tag = -1
      Left = 341
      Top = 3
      Width = 26
      Height = 26
      Hint = 'SQL Help  (F1)'
      Flat = True
      Glyph.Data = {
        56070000424D5607000000000000360400002800000028000000140000000100
        0800000000002003000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303FFFF03030303030303
        030303030303030303030606030303030303030303030303030303030303F8F8
        03FF030303030303030303030303030303060404060303030303030303030303
        0303030303F8FF03F8FF030303030303030303030303030303FE060604030303
        03030303030303030303030303F803FFF8030303030303030303030303030303
        0303FE06060303030303030303030303030303030303F8F80303030303030303
        03030303030303030303030303030303030303030303030303030303030303FF
        FF03030303030303030303030303030303030404060303030303030303030303
        030303030303F8F803FF03030303030303030303030303030306060604030303
        03030303030303030303030303F8FF03F8FF0303030303030303030303030303
        03FE06060403030303030303030303030303030303F8FF03F803FF0303030303
        030303030303030303FE06060604030303030303030303030303030303F803FF
        03F803FF0303030303030303030303030303FE06060604030303030303030303
        030303030303F803FF03F803FF0303030303030303030303030303FE06060604
        030303030303030303030303FFFF03F803FF03F803FF03030303030303030304
        04030303FE0606060403030303030303030303F8F803FF03F803FF03F8FF0303
        03030303030306060604030303FE060604030303030303030303F8FF03F803FF
        FFF80303F8FF0303030303030303FE0606060404040606060403030303030303
        0303F803FF03F8F8F8030303F8FF030303030303030303FE0606060606060606
        0603030303030303030303F803FFFF0303030303F80303030303030303030303
        FEFE060606060606030303030303030303030303F8F803FFFFFFFFF803030303
        03030303030303030303FEFEFEFEFE030303030303030303030303030303F8F8
        F8F8F80303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = HelpBtnClick
    end
    object LoadBtn: TSpeedButton
      Left = 153
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Load file'
      Flat = True
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        333FFFFFFFFFFFFFF3333380000000000000333333888888888888883F333300
        7B7B7B7B7B7B033333883F33333333338F33330F07B7B7B7B7B70333338F8F33
        3333333383F3330B0B7B7B7B7B7B7033338F83F33333333338F3330FB0B7B7B7
        B7B7B033338F38F333333333383F330BF07B7B7B7B7B7B03338F383FFFFF3333
        338F330FBF000007B7B7B703338F33888883FFFFFF83330BFBFBFBF000000033
        338F3333333888888833330FBFBFBFBFBFB03333338F333333333338F333330B
        FBFBFBFBFBF03333338F33333FFFFFF83333330FBFBF0000000333333387FFFF
        8888888333333330000033333333333333388888333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        33333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = LoadBtnClick
    end
    object SaveBtn: TSpeedButton
      Left = 179
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Save file'
      Flat = True
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333FFFFFFFFFFFFFF3333380000000000008333
        333888F8FF888F888F333330CC08CCF770CC0333333888F8FF888F888F333330
        CC08CCF770CC0333333888F888888F888F333330CC07887770CC03333338888F
        FFFFF8888F333330CC60000006CC033333388888888888888F333330CCCCCCCC
        CCCC033333388888888888888F333330C6000000006C03333338888888888888
        8F333330C0FFFFFFFF0C0333333888FFFFFFFF888F333330C0FFFFFFFF0C0333
        333888FFFFFFFF888F333330C0FFFFFFFF0C0333333888FFFFFFFF888F333330
        C0FFFFFFFF0C0333333888FFFFFFFF888F33333000FFFFFFFF000333333888FF
        FFFFFF888F333330C0FFFFFFFF0C0333333888FFFFFFFF888F33333800000000
        0000833333388888888888888333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        33333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SaveBtnClick
    end
    object SetupBtn: TSpeedButton
      Tag = -1
      Left = 257
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Preferences'
      Flat = True
      Glyph.Data = {
        C6060000424DC606000000000000360000002800000015000000140000000100
        200000000000900600000000000000000000000000000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000000000000000000000
        0000000000000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF00FFFF0000FF000000FF000000FF000000FF000000FF0000000000
        000000BFBF0000BFBF0000BFBF0000BFBF0000000000000000000000000000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF0000FF00
        0000BFBF0000FFFF0000FFFF0000FF0000000000000000BFBF0000BFBF0000BF
        BF00000000000000000000000000000000000000000000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF00FFFF0000FF0000000000000000BFBF00FFFF
        0000FF0000000000000000BFBF0000BFBF000000000000000000000000000000
        000000000000000000000000000000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF00FFFF0000FF0000000000000000000000BFBF0000FF0000000000000000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF0000FF000000FF00
        0000FF000000FF000000FF0000000000000000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF00FFFF0000FF000000FF000000FF000000FF000000FF00
        00000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF
        0000FF000000FF000000FF000000FF000000FF0000000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF00FF000000FF000000FF000000FF000000FF00
        0000FF000000FF000000FF0000000000000000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF00FF00
        0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
        0000FF0000000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF00FF000000FF000000FF000000FF000000FF00
        0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
        000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF
        0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
        0000FF000000FF000000FF000000FF000000FF0000000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF0000FF000000FF000000FF00
        0000FF0000000000000000BFBF0000BFBF0000BFBF00FFFF0000FF000000FF00
        0000FF000000FF0000000000000000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF00FFFF0000FF000000FF000000FF0000000000000000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF00FFFF0000FF000000FF000000FF0000000000
        000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF0000FF00
        0000FF000000FF0000000000000000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF00FFFF0000FF000000FF000000FF0000000000000000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF0000FF000000FF0000000000
        000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF00FFFF0000FF000000FF00
        00000000000000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF00FFFF0000FFFF0000BFBF000000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF00FFFF0000FFFF0000BFBF000000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BFBF0000BF
        BF0000BFBF0000BFBF00}
      ParentShowHint = False
      ShowHint = True
      OnClick = SetupBtnClick
    end
    object BreakBtn: TSpeedButton
      Tag = -1
      Left = 62
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Break  (Esc)'
      Enabled = False
      Flat = True
      Glyph.Data = {
        E6000000424DE60000000000000076000000280000000F0000000E0000000100
        0400000000007000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFF0F007FFFFFFFFFFF0F09107FFFFFFFFF0FF099087FFFFFFF0FFF0990087FF
        FFF0FFFF0991008FFFF0FFFFF0999008FFF0FFFFF00999007FF0FFFF00999007
        FFF0FFFFF00999007FF0FFFFFFF0099007F0FFFFFFFFF09900F0FFFFFFFFFF00
        90F0FFFFFFFFFFFF00F0}
      ParentShowHint = False
      ShowHint = True
      OnClick = BreakBtnClick
    end
    object Bevel1: TBevel
      Tag = -1
      Left = 283
      Top = 3
      Width = 4
      Height = 26
      Shape = bsRightLine
    end
    object Bevel2: TBevel
      Tag = -1
      Left = 29
      Top = 3
      Width = 4
      Height = 26
      Shape = bsRightLine
    end
    object Bevel3: TBevel
      Tag = -1
      Left = 114
      Top = 3
      Width = 4
      Height = 26
      Shape = bsRightLine
    end
    object Bevel4: TBevel
      Tag = -1
      Left = 146
      Top = 3
      Width = 4
      Height = 26
      Shape = bsRightLine
    end
    object ExportBtn: TSpeedButton
      Tag = -1
      Left = 315
      Top = 3
      Width = 26
      Height = 26
      Hint = 'Link to PL/SQL Developer'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
        333333333333337FF3333333333333903333333333333377FF33333333333399
        03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
        99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
        99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
        03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
        33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
        33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
        3333777777333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = ExportBtnClick
    end
    object FirstBtn: TSpeedButton
      Left = 371
      Top = 3
      Width = 17
      Height = 17
      Flat = True
      Glyph.Data = {
        46010000424D460100000000000076000000280000001C0000000D0000000100
        040000000000D000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888000088888888888888888888888888880000888888888888
        8888FFF88888FFF80000880788888870888788F888FF88F80000880788887000
        888788F8FF8888F80000880788700000888788FF888888F80000880770000000
        88878888888888F8000088078870000088878887888888F80000880788887000
        888788F8778888F80000880788888870888788F8887788F80000888888888888
        8887778888887788000088888888888888888888888888880000888888888888
        88888888888888880000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = FirstBtnClick
    end
    object PrevBtn: TSpeedButton
      Left = 388
      Top = 3
      Width = 18
      Height = 17
      Flat = True
      Glyph.Data = {
        12010000424D12010000000000007600000028000000140000000D0000000100
        0400000000009C00000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        88888888000088888888888888888888000088888888888888888FFF00008888
        88870888888FF88F00008888870008888FF8888F000088870000088FF888888F
        00008700000008788888888F00008887000008877888888F0000888887000888
        8778888F00008888888708888887788F00008888888888888888877800008888
        88888888888888880000888888888888888888880000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = PrevBtnClick
    end
    object NextBtn: TSpeedButton
      Left = 406
      Top = 3
      Width = 18
      Height = 17
      Flat = True
      Glyph.Data = {
        12010000424D12010000000000007600000028000000140000000D0000000100
        0400000000009C00000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        88888888000088888888888888888888000088888888888FF888888800008078
        888888788FF888880000800078888878888FF888000080000078887888888FF8
        00008000000078788888888F0000800000788878888887780000800078888878
        8887788800008078888888788778888800008888888888777888888800008888
        88888888888888880000888888888888888888880000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = NextBtnClick
    end
    object LastBtn: TSpeedButton
      Left = 424
      Top = 3
      Width = 18
      Height = 17
      Flat = True
      Glyph.Data = {
        46010000424D460100000000000076000000280000001C0000000D0000000100
        040000000000D000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888000088888888888888888888888888880000888888888888
        8888FF888888FFF80000880788888870888788FF888788F80000880007888870
        88878888FF8788F800008800000788708887888888F888F80000880000000770
        88878888888888F8000088000007887088878888887788F80000880007888870
        88878888778788F8000088078888887088878877888788F80000888888888888
        8887778888877788000088888888888888888888888888880000888888888888
        88888888888888880000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = LastBtnClick
    end
    object InsertBtn: TSpeedButton
      Left = 442
      Top = 3
      Width = 18
      Height = 17
      Flat = True
      Glyph.Data = {
        46010000424D460100000000000076000000280000001C0000000D0000000100
        040000000000D000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888888888800008888888888888888888FFFF888880000888880008888
        8888887888F8888800008888800088888888887888F888880000888880008888
        8888FF8888FFFF8800008800000000088887888888888F880000880000000008
        8887888888888F8800008800000000088887888888888F880000888880008888
        888777788887788800008888800088888888887888F888880000888880008888
        8888887888F88888000088888888888888888877778888880000888888888888
        88888888888888880000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = InsertBtnClick
    end
    object DeleteBtn: TSpeedButton
      Left = 460
      Top = 3
      Width = 18
      Height = 17
      Flat = True
      Glyph.Data = {
        46010000424D460100000000000076000000280000001C0000000D0000000100
        040000000000D000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888000088888888888888888888888888880000888888888888
        8888888888888888000088888888888888888888888888880000888888888888
        8887FFFFFFFFFFF8000088000000000088878888888888F80000880000000000
        88878888888888F8000088000000000088878888888888F80000888888888888
        88877777777777F8000088888888888888888888888888880000888888888888
        8888888888888888000088888888888888888888888888880000888888888888
        88888888888888880000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = DeleteBtnClick
    end
    object RightPanel: TPanel
      Left = 854
      Top = 1
      Width = 61
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object ExitBtn: TSpeedButton
        Tag = 2
        Left = 30
        Top = 2
        Width = 26
        Height = 26
        Hint = 'Exit  (Alt-F4)'
        Flat = True
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ExitBtnClick
      end
      object OkayBtn: TSpeedButton
        Tag = 2
        Left = 4
        Top = 2
        Width = 26
        Height = 26
        Hint = 'Accept  (Ctrl+Enter)'
        Flat = True
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = OkayBtnClick
      end
    end
    object ScriptScrollBar: TScrollBar
      Left = 371
      Top = 21
      Width = 107
      Height = 8
      LargeChange = 5
      PageSize = 0
      TabOrder = 1
      TabStop = False
      Visible = False
      OnChange = ScriptScrollBarChange
    end
    object btnTemplate: TcxButton
      Left = 208
      Top = 4
      Width = 25
      Height = 25
      LookAndFeel.Kind = lfUltraFlat
      OptionsImage.ImageIndex = 83
      OptionsImage.Images = frmMain.cxImageList
      PaintStyle = bpsGlyph
      SpeedButtonOptions.Flat = True
      TabOrder = 2
      OnClick = btnTemplateClick
    end
  end
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 33
    Width = 916
    Height = 560
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = dxLayoutStandardLookAndFeel1
    object GridView: TcxGrid
      Left = 0
      Top = 220
      Width = 821
      Height = 250
      TabOrder = 1
      object tvGridView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = False
        Navigator.Buttons.PriorPage.Visible = False
        Navigator.Buttons.Prior.Visible = False
        Navigator.Buttons.Next.Visible = False
        Navigator.Buttons.NextPage.Visible = False
        Navigator.Buttons.Last.Visible = False
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = False
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = False
        Navigator.Buttons.SaveBookmark.Visible = False
        Navigator.Buttons.GotoBookmark.Visible = False
        Navigator.Buttons.Filter.Visible = True
        DataController.DataModeController.GridMode = True
        DataController.DataModeController.SyncMode = False
        DataController.DataSource = SQLEditDataSource
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
      end
      object GridViewLevel1: TcxGridLevel
        GridView = tvGridView
      end
    end
    object SQLEdit: TJvHLEditor
      Left = 2
      Top = 2
      Width = 1277
      Height = 200
      Cursor = crIBeam
      BorderStyle = bsNone
      RightMargin = 150
      Completion.ItemHeight = 13
      Completion.CRLF = '/n'
      Completion.Separator = '='
      TabStops = '3 5'
      BracketHighlighting.StringEscape = #39#39
      OnChange = SQLEditChange
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Highlighter = hlSql
      Colors.Comment.Style = [fsItalic]
      Colors.Comment.ForeColor = clGreen
      Colors.Comment.BackColor = clWindow
      Colors.Number.ForeColor = clNavy
      Colors.Number.BackColor = clWindow
      Colors.Strings.ForeColor = clPurple
      Colors.Strings.BackColor = clWindow
      Colors.Symbol.ForeColor = clBlue
      Colors.Symbol.BackColor = clWindow
      Colors.Reserved.Style = [fsBold]
      Colors.Reserved.ForeColor = clBlue
      Colors.Reserved.BackColor = clWindow
      Colors.Identifier.ForeColor = clWindowText
      Colors.Identifier.BackColor = clWindow
      Colors.Preproc.ForeColor = clGreen
      Colors.Preproc.BackColor = clWindow
      Colors.FunctionCall.ForeColor = clWindowText
      Colors.FunctionCall.BackColor = clWindow
      Colors.Declaration.ForeColor = clWindowText
      Colors.Declaration.BackColor = clWindow
      Colors.Statement.Style = [fsBold]
      Colors.Statement.ForeColor = clWindowText
      Colors.Statement.BackColor = clWindow
      Colors.PlainText.ForeColor = clWindowText
      Colors.PlainText.BackColor = clWindow
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutControl1Item2: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
      CaptionOptions.Layout = clTop
      Control = GridView
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1SplitterItem1: TdxLayoutSplitterItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'Splitter'
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      Index = 1
    end
    object dxLayoutControl1Item3: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      Control = SQLEdit
      Index = 0
    end
  end
  object OpenHelp: TOpenDialog
    DefaultExt = 'hlp'
    FileName = '*.hlp'
    Filter = 'Help files|*.hlp|All files|*.*'
    Options = [ofExtensionDifferent, ofPathMustExist, ofFileMustExist]
    Title = 'Find SQL helpfile'
    Left = 12
    Top = 100
  end
  object OpenSQL: TOpenDialog
    DefaultExt = 'sql'
    Filter = 'SQL files|*.sql|All files|*.*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist]
    Title = 'Open SQL File'
    Left = 40
    Top = 100
  end
  object SaveSQL: TSaveDialog
    DefaultExt = 'sql'
    Filter = 'SQL files|*.sql|All files|*.*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist]
    Title = 'Save SQL File'
    Left = 68
    Top = 100
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 96
    Top = 100
  end
  object SetupPopup: TPopupMenu
    Left = 124
    Top = 100
    object TextFont: TMenuItem
      Caption = 'SQL editor font...'
      OnClick = TextFontClick
    end
    object ListFont: TMenuItem
      Caption = 'Result grid font...'
      OnClick = ListFontClick
    end
  end
  object SQLEditSession: TOraSession
    Options.Direct = True
    Server = '10.2.9.191:1521:fedias'
    ConnectDialog = SQLEditLogon
    LoginPrompt = False
    OnError = SQLEditSessionError
    OnConnectChange = SQLEditSessionConnectChange
    Left = 16
    Top = 240
  end
  object SQLEditQuery: TOraQuery
    Session = SQLEditSession
    NonBlocking = True
    AfterExecute = SQLEditQueryAfterExecute
    AfterFetch = SQLEditQueryAfterFetch
    Left = 64
    Top = 240
  end
  object SQLEditScript: TOraScript
    Session = SQLEditSession
    Left = 88
    Top = 240
  end
  object SQLEditLogon: TConnectDialog
    Caption = 'Connect'
    ConnectButton = 'Connect'
    CancelButton = 'Cancel'
    Server.Caption = 'Server'
    Server.Visible = True
    Server.Order = 1
    UserName.Caption = 'User Name'
    UserName.Visible = True
    UserName.Order = 2
    Password.Caption = 'Password'
    Password.Visible = True
    Password.Order = 3
    Home.Caption = 'Home Name'
    Home.Visible = False
    Home.Order = 0
    Direct.Caption = 'Direct'
    Direct.Visible = False
    Direct.Order = 6
    Schema.Caption = 'Schema'
    Schema.Visible = False
    Schema.Order = 4
    Role.Caption = 'Connect Mode'
    Role.Visible = False
    Role.Order = 5
    Left = 40
    Top = 240
  end
  object SQLEditDataSource: TOraDataSource
    AutoEdit = False
    DataSet = SQLEditQuery
    Left = 64
    Top = 272
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    object dxLayoutStandardLookAndFeel1: TdxLayoutStandardLookAndFeel
      Offsets.ControlOffsetHorz = 0
      Offsets.ControlOffsetVert = 0
      Offsets.ItemOffset = 0
      Offsets.RootItemsAreaOffsetHorz = 0
      Offsets.RootItemsAreaOffsetVert = 0
    end
  end
end
