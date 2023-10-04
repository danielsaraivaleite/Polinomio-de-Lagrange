object Form1: TForm1
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Calculo N'#250'merico - Polin'#244'mio Interpolador de Lagrange'
  ClientHeight = 392
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 368
    Width = 258
    Height = 13
    Caption = 'ALUNA: ILKA BEATRIZ SANTOS SOARES ALMEIDA'
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 649
    Height = 153
    Caption = 'Tabela de Pontos'
    TabOrder = 0
    object gridPontos: TStringGrid
      Left = 16
      Top = 16
      Width = 617
      Height = 120
      RowCount = 3
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ScrollBars = ssHorizontal
      TabOrder = 0
    end
  end
  object radioVariavel: TRadioGroup
    Left = 560
    Top = 184
    Width = 105
    Height = 57
    Caption = 'Usar vari'#225'vel:'
    ItemIndex = 0
    Items.Strings = (
      'x'
      'u')
    TabOrder = 1
  end
  object botaoCalcular: TBitBtn
    Left = 560
    Top = 256
    Width = 105
    Height = 25
    Caption = '&Calcular!'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = botaoCalcularClick
    Kind = bkYes
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 184
    Width = 529
    Height = 177
    Caption = 'Resultado'
    TabOrder = 3
    object memoResultado: TMemo
      Left = 16
      Top = 24
      Width = 497
      Height = 137
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object botaoLimpar: TBitBtn
    Left = 560
    Top = 296
    Width = 105
    Height = 25
    Caption = '&Limpar Pontos'
    TabOrder = 4
    OnClick = botaoLimparClick
    Kind = bkRetry
  end
end
