inherited frmSprApplications: TfrmSprApplications
  Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1082#1088#1099#1090#1080#1103
  ExplicitWidth = 753
  ExplicitHeight = 490
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    object cxGrid1: TcxGrid [0]
      Left = 3
      Top = 3
      Width = 250
      Height = 200
      TabOrder = 0
      object cxGrid1DBTableView1: TcxGridDBTableView
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
        OnCellDblClick = cxGrid1DBTableView1CellDblClick
        DataController.DataSource = dsApplications
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Editing = False
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object cxGrid1DBTableView1ICON: TcxGridDBColumn
          DataBinding.FieldName = 'ICON'
          PropertiesClassName = 'TcxImageProperties'
          Properties.GraphicClassName = 'TIcon'
          Width = 34
        end
        object cxGrid1DBTableView1OWNER: TcxGridDBColumn
          Caption = #1057#1093#1077#1084#1072
          DataBinding.FieldName = 'OWNER'
          Width = 96
        end
        object cxGrid1DBTableView1APP_NAME: TcxGridDBColumn
          Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077
          DataBinding.FieldName = 'APP_NAME'
          Width = 607
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
    object btnOK: TcxButton [1]
      Left = 3
      Top = 428
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancel: TcxButton [2]
      Left = 81
      Top = 428
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 2
    end
    inherited dxLayoutControl1Group_Root: TdxLayoutGroup
      Index = -1
    end
    object dxLayoutControl1Item1: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      AlignVert = avClient
      CaptionOptions.Text = 'cxGrid1'
      CaptionOptions.Visible = False
      Control = cxGrid1
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item2: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Group1: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item3: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
  object oqApplications: TOraQuery
    SQL.Strings = (
      'declare'
      '  cMenuTable constant varchar2(50) := '#39'FRM_MENUS'#39';'
      '  vSQL varchar2(4000);'
      'begin'
      
        '  for cc in (select distinct p.owner from all_objects p where p.' +
        'object_name = cMenuTable) loop'
      '    if vSQL is not null then'
      '      vSQL := vSQL || '#39
      '  union all'
      '  '#39';'
      '    end if;'
      
        '    vSQL := vSQL || '#39'select '#39#39#39' || cc.owner || '#39#39#39' as owner, m.n' +
        'ame as app_name, m.icon from '#39' || cc.owner || '#39'.'#39' ||'
      '            cMenuTable || '#39' m where m.id = 0'#39';'
      '  end loop;'
      '  if vSQL is null then'
      
        '    vSQL := '#39'select null as owner, null as app_name, null as ico' +
        'n from dual where 1=2'#39';'
      '  end if;'
      '  open :res_cursor for vSQL;'
      'end;')
    Left = 160
    Top = 152
    ParamData = <
      item
        DataType = ftCursor
        Name = 'res_cursor'
        Value = 'Object'
      end>
  end
  object dsApplications: TDataSource
    DataSet = oqApplications
    Left = 184
    Top = 152
  end
end
