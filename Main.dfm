object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'OpenGL_VCL'
  ClientHeight = 578
  ClientWidth = 758
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 738
    Height = 558
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = TabSheetV
    Align = alClient
    TabOrder = 0
    object TabSheetV: TTabSheet
      Caption = 'View'
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 310
        Height = 520
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 5
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        inline GLViewer1: TGLViewer
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 300
          Height = 300
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          DoubleBuffered = False
          Color = clGray
          Ctl3D = True
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          ParentDoubleBuffered = False
          TabOrder = 0
          OnDblClick = GLViewer1DblClick
          ExplicitLeft = 5
          ExplicitTop = 5
          ExplicitWidth = 300
        end
        inline GLViewer2: TGLViewer
          AlignWithMargins = True
          Left = 5
          Top = 315
          Width = 300
          Height = 200
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          DoubleBuffered = False
          Color = clGray
          Ctl3D = True
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          ParentDoubleBuffered = False
          TabOrder = 1
          OnDblClick = GLViewer2DblClick
          ExplicitLeft = 5
          ExplicitTop = 315
          ExplicitWidth = 300
          ExplicitHeight = 200
        end
      end
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 315
        Top = 5
        Width = 410
        Height = 520
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        inline GLViewer3: TGLViewer
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 400
          Height = 200
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alTop
          DoubleBuffered = False
          Color = clGray
          Ctl3D = True
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          ParentDoubleBuffered = False
          TabOrder = 0
          OnDblClick = GLViewer3DblClick
          ExplicitLeft = 5
          ExplicitTop = 5
          ExplicitHeight = 200
        end
        inline GLViewer4: TGLViewer
          AlignWithMargins = True
          Left = 5
          Top = 215
          Width = 400
          Height = 300
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          DoubleBuffered = False
          Color = clGray
          Ctl3D = True
          ParentBackground = False
          ParentColor = False
          ParentCtl3D = False
          ParentDoubleBuffered = False
          TabOrder = 1
          OnDblClick = GLViewer4DblClick
          OnMouseDown = GLViewer4MouseDown
          OnMouseMove = GLViewer4MouseMove
          OnMouseUp = GLViewer4MouseUp
          ExplicitLeft = 5
          ExplicitTop = 215
        end
      end
    end
    object TabSheetS: TTabSheet
      Caption = 'Shader'
      ImageIndex = 2
      object PageControlS: TPageControl
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 710
        Height = 510
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        ActivePage = TabSheetSV
        Align = alClient
        TabOrder = 0
        object TabSheetSV: TTabSheet
          Caption = 'Vertex'
          object SplitterSV: TSplitter
            Left = 0
            Top = 362
            Width = 702
            Height = 10
            Cursor = crVSplit
            Align = alBottom
            Color = clWhite
            MinSize = 50
            ParentColor = False
            ResizeStyle = rsUpdate
            ExplicitTop = 359
          end
          object MemoSVE: TMemo
            AlignWithMargins = True
            Left = 10
            Top = 372
            Width = 682
            Height = 100
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alBottom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
          end
          object MemoSVS: TMemo
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 682
            Height = 352
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
            OnChange = MemoSVSChange
          end
        end
        object TabSheetSG: TTabSheet
          Caption = 'Geometry'
          ImageIndex = 2
          object SplitterSG: TSplitter
            Left = 0
            Top = 362
            Width = 702
            Height = 10
            Cursor = crVSplit
            Align = alBottom
            Color = clWhite
            MinSize = 50
            ParentColor = False
            ResizeStyle = rsUpdate
            ExplicitTop = 360
          end
          object MemoSGE: TMemo
            AlignWithMargins = True
            Left = 10
            Top = 372
            Width = 682
            Height = 100
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alBottom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
          end
          object MemoSGS: TMemo
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 682
            Height = 352
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
            OnChange = MemoSGSChange
          end
        end
        object TabSheetSF: TTabSheet
          Caption = 'Fragment'
          ImageIndex = 1
          object SplitterSF: TSplitter
            Left = 0
            Top = 362
            Width = 702
            Height = 10
            Cursor = crVSplit
            Align = alBottom
            Color = clWhite
            MinSize = 50
            ParentColor = False
            ResizeStyle = rsUpdate
            ExplicitTop = 300
          end
          object MemoSFE: TMemo
            AlignWithMargins = True
            Left = 10
            Top = 372
            Width = 682
            Height = 100
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alBottom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
          end
          object MemoSFS: TMemo
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 682
            Height = 352
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #65325#65331' '#12468#12471#12483#12463
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
            OnChange = MemoSFSChange
          end
        end
      end
    end
    object TabSheetP: TTabSheet
      Caption = 'Program'
      ImageIndex = 1
      object MemoP: TMemo
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 710
        Height = 510
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#12468#12471#12483#12463
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
end
