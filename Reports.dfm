inherited frmXLSReports: TfrmXLSReports
  Caption = #1054#1090#1095#1077#1090#1099
  ClientHeight = 476
  ClientWidth = 1200
  FormStyle = fsMDIChild
  Visible = True
  ExplicitWidth = 1208
  ExplicitHeight = 510
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    Width = 1200
    Height = 476
    ExplicitWidth = 1200
    ExplicitHeight = 476
    object cxGrid1: TcxGrid [0]
      Left = 3
      Top = 35
      Width = 1194
      Height = 438
      TabOrder = 1
      object tvReports: TcxGridDBTableView
        Navigator.Buttons.ConfirmDelete = True
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = False
        Navigator.Buttons.PriorPage.Visible = False
        Navigator.Buttons.Prior.Visible = False
        Navigator.Buttons.Next.Visible = False
        Navigator.Buttons.NextPage.Visible = False
        Navigator.Buttons.Last.Visible = False
        Navigator.Buttons.Edit.Visible = False
        Navigator.Buttons.SaveBookmark.Visible = False
        Navigator.Buttons.GotoBookmark.Visible = False
        Navigator.Buttons.Filter.Visible = False
        Navigator.Visible = True
        DataController.DataSource = dsReports
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.CellAutoHeight = True
        OptionsView.GroupByBox = False
        object tvReportsID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          HeaderAlignmentHorz = taCenter
          Width = 25
        end
        object tvReportsREPORT_NAME: TcxGridDBColumn
          Caption = #1054#1090#1095#1077#1090
          DataBinding.FieldName = 'REPORT_NAME'
          HeaderAlignmentHorz = taCenter
          Options.ShowEditButtons = isebAlways
          Width = 150
        end
        object tvReportsDESCRIPTION: TcxGridDBColumn
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077
          DataBinding.FieldName = 'DESCRIPTION'
          PropertiesClassName = 'TcxMemoProperties'
          HeaderAlignmentHorz = taCenter
          Width = 400
        end
        object tvReportsFILE_NAME: TcxGridDBColumn
          Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072
          DataBinding.FieldName = 'FILE_NAME'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = #1042#1099#1075#1088'.'
              Default = True
              Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1073#1072#1079#1099' '#1074' '#1092#1072#1081#1083' '#1080' '#1086#1090#1082#1088#1099#1090#1100
              Kind = bkText
            end
            item
              Caption = #1047#1072#1075#1088'.'
              Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072' '#1074' '#1073#1072#1079#1091
              Kind = bkText
            end>
          Properties.OnButtonClick = fileButtonClick
          HeaderAlignmentHorz = taCenter
          Options.ShowEditButtons = isebAlways
          Width = 510
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = tvReports
      end
    end
    object bePathForReports: TcxShellComboBox [1]
      Left = 114
      Top = 3
      Properties.DropDownWidth = 500
      Properties.Root.BrowseFolder = bfCustomPath
      Properties.Root.CustomPath = 'c:\delphi'
      Properties.ShowFullPath = sfpAlways
      Properties.OnEditValueChanged = bePathForReportsPropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 0
      Width = 1083
    end
    inherited dxLayoutControl1Group_Root: TdxLayoutGroup
      Index = -1
    end
    object dxLayoutControl1Item2: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxGrid1
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Group1: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item1: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = #1050#1072#1090#1072#1083#1086#1075' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1086#1074
      Control = bePathForReports
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Group2: TdxLayoutGroup
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Group4: TdxLayoutGroup
      Parent = dxLayoutControl1Group2
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
  end
  object odReports: TOraQuery
    Left = 80
    Top = 216
  end
  object dsReports: TOraDataSource
    DataSet = odReports
    Left = 104
    Top = 216
  end
end
