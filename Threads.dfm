object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 388
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 492
    Height = 53
    Align = alTop
    Color = 16642254
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 6
      Width = 79
      Height = 13
      Caption = 'N'#186' de Threads'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 105
      Top = 6
      Width = 59
      Height = 13
      Caption = 'Tempo ms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 80
      Height = 21
      AutoSelect = False
      TabOrder = 0
      Text = '10'
    end
    object Edit2: TEdit
      Left = 104
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 1
      Text = '2000'
    end
    object Button1: TButton
      Left = 397
      Top = 12
      Width = 87
      Height = 34
      Caption = 'Processar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = Button1Click
    end
    object BtAbort: TButton
      Left = 316
      Top = 12
      Width = 75
      Height = 34
      Caption = 'Abortar'
      Enabled = False
      TabOrder = 3
      OnClick = BtAbortClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 53
    Width = 492
    Height = 335
    Align = alClient
    TabOrder = 1
    ExplicitTop = 58
    ExplicitHeight = 330
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 490
      Height = 311
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitHeight = 306
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 312
      Width = 490
      Height = 22
      Align = alBottom
      TabOrder = 1
      ExplicitTop = 307
    end
  end
end
