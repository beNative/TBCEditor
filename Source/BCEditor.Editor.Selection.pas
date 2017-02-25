unit BCEditor.Editor.Selection;

interface {********************************************************************}

uses
  System.Classes, Vcl.Graphics,
  BCEditor.Types, BCEditor.Consts;

type
  TBCEditorSelection = class(TPersistent)
  type
    PMode = ^TMode;
    TMode = (
      smColumn,
      smNormal
    );
    TOption = (
      soALTSetsColumnMode,
      soExpandRealNumbers,
      soHighlightSimilarTerms,
      soTermsCaseSensitive,
      soToEndOfLine,
      soTripleClickRowSelect
    );
    TOptions = set of TOption;

    TColors = class(TPersistent)
    strict private
      FBackground: TColor;
      FForeground: TColor;
      FOnChange: TNotifyEvent;
      procedure SetBackground(AValue: TColor);
      procedure SetForeground(AValue: TColor);
    public
      constructor Create;
      procedure Assign(ASource: TPersistent); override;
    published
      property Background: TColor read FBackground write SetBackground default clSelectionColor;
      property Foreground: TColor read FForeground write SetForeground default clHighLightText;
      property OnChange: TNotifyEvent read FOnChange write FOnChange;
    end;

  strict private
    FActiveMode: TMode;
    FColors: TBCEditorSelection.TColors;
    FMode: TMode;
    FOnChange: TNotifyEvent;
    FOptions: TOptions;
    FVisible: Boolean;
    procedure DoChange;
    procedure SetActiveMode(const AValue: TMode);
    procedure SetColors(const AValue: TColors);
    procedure SetMode(const AValue: TMode);
    procedure SetOnChange(AValue: TNotifyEvent);
    procedure SetOptions(AValue: TOptions);
    procedure SetVisible(const AValue: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure SetOption(const AOption: TOption; const AEnabled: Boolean);
    property ActiveMode: TMode read FActiveMode write SetActiveMode stored False;
  published
    property Colors: TBCEditorSelection.TColors read FColors write SetColors;
    property Mode: TMode read FMode write SetMode default smNormal;
    property Options: TOptions read FOptions write SetOptions default [soHighlightSimilarTerms, soTermsCaseSensitive];
    property Visible: Boolean read FVisible write SetVisible default True;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
  end;

implementation {***************************************************************}

{ TBCEditorSelection.TColors **************************************************}

constructor TBCEditorSelection.TColors.Create;
begin
  inherited;

  FBackground := clSelectionColor;
  FForeground := clHighLightText;
end;

procedure TBCEditorSelection.TColors.Assign(ASource: TPersistent);
begin
  if Assigned(ASource) and (ASource is TBCEditorSelection.TColors) then
  with ASource as TBCEditorSelection.TColors do
  begin
    Self.FBackground := FBackground;
    Self.FForeground := FForeground;
    if Assigned(Self.FOnChange) then
      Self.FOnChange(Self);
  end
  else
    inherited Assign(ASource);
end;

procedure TBCEditorSelection.TColors.SetBackground(AValue: TColor);
begin
  if FBackground <> AValue then
  begin
    FBackground := AValue;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TBCEditorSelection.TColors.SetForeground(AValue: TColor);
begin
  if FForeground <> AValue then
  begin
    FForeground := AValue;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

{ TBCEditorSelection **********************************************************}

procedure TBCEditorSelection.Assign(ASource: TPersistent);
begin
  if Assigned(ASource) and (ASource is TBCEditorSelection) then
  with ASource as TBCEditorSelection do
  begin
    Self.FColors.Assign(FColors);
    Self.FActiveMode := FActiveMode;
    Self.FMode := FMode;
    Self.FOptions := FOptions;
    Self.FVisible := FVisible;
    if Assigned(Self.FOnChange) then
      Self.FOnChange(Self);
  end
  else
    inherited Assign(ASource);
end;

constructor TBCEditorSelection.Create;
begin
  inherited;

  FColors := TBCEditorSelection.TColors.Create;
  FActiveMode := smNormal;
  FMode := smNormal;
  FOptions := [soHighlightSimilarTerms, soTermsCaseSensitive];
  FVisible := True;
end;

destructor TBCEditorSelection.Destroy;
begin
  FColors.Free;
  inherited Destroy;
end;

procedure TBCEditorSelection.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TBCEditorSelection.SetActiveMode(const AValue: TMode);
begin
  if FActiveMode <> AValue then
  begin
    FActiveMode := AValue;
    DoChange;
  end;
end;

procedure TBCEditorSelection.SetColors(const AValue: TBCEditorSelection.TColors);
begin
  FColors.Assign(AValue);
end;

procedure TBCEditorSelection.SetMode(const AValue: TMode);
begin
  if FMode <> AValue then
  begin
    FMode := AValue;
    ActiveMode := AValue;
    DoChange;
  end;
end;

procedure TBCEditorSelection.SetOnChange(AValue: TNotifyEvent);
begin
  FOnChange := AValue;
  FColors.OnChange := FOnChange;
end;

procedure TBCEditorSelection.SetOption(const AOption: TOption; const AEnabled: Boolean);
begin
   if AEnabled then
    Include(FOptions, AOption)
  else
    Exclude(FOptions, AOption);
end;

procedure TBCEditorSelection.SetOptions(AValue: TOptions);
begin
  if FOptions <> AValue then
  begin
    FOptions := AValue;
    DoChange;
  end;
end;

procedure TBCEditorSelection.SetVisible(const AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    DoChange;
  end;
end;

end.
