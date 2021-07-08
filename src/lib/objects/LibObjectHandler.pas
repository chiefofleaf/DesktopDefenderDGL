unit LibObjectHandler;

interface

uses
  Generics.Collections,

  LibPlayer, LibRenderableObject, LibShot, LibAsteroid, LibShared;

type
  TBiomeType = (btRocky, btNotAsRocky, btMinerally);

  TBiome = class
  private
    FBiomeType: TBiomeType;
    FSize: Single;
    FPosition: TFloatPoint;

  public
    property BiomeType: TBiomeType read FBiomeType;
    property Size: Single read FSize;
    property Position: TFloatPoint read FPosition;

    constructor Create(ABiomeType: TBiomeType; ASize: Single; APosition: TFloatPoint);
  end;

  TWorldGenerator = class
  private
    FBiomes: TObjectList<TBiome>;

    //Visited Coordinates
    FVisitedBottomLeft, FVisitedTopRight: TFloatPoint;

    //Generated up until
    FGeneratedBottomLeft, FGeneratedTopRight: TFloatPoint;
  public
    property Biomes: TObjectList<TBiome> read FBiomes;
    property BottomLeft: TFloatPoint read FVisitedBottomLeft;
    property TopRight: TFloatPoint read FVisitedTopRight;

    procedure Visit(APosition: TFloatPoint);
    procedure GenerateBiomes(FromBottomLeft, ToTopRight: TFloatPoint; IntoList: TObjectList<TWorldObject>);
  end;

  TObjectHandler = class
  private
    FPlayer: TPlayer;
    FPlayers: TObjectList<TPlayer>;
    FShots: TObjectList<TShot>;
    FAsteroids: TObjectList<TAsteroid>;

    FWorldGenerator: TWorldGenerator;
  private
    function GetObjectList: TRenderableArray;
  public
    property Player: TPlayer read FPlayer;

    constructor Create;
    destructor Destroy; override;

    procedure UpdateAll(DT: Double);
    procedure RenderAll;
  end;

implementation

uses
  Winapi.Windows, DGLOpenGL;

{ TObjectHandler }

constructor TObjectHandler.Create;
var
  a: TAsteroid;
begin
  FPlayers := TObjectList<TPlayer>.Create(True);
  FShots := TObjectList<TShot>.Create(True);
  FAsteroids := TObjectList<TAsteroid>.Create(True);

  FPlayer := TPlayer.Create;
  FPlayers.Add(FPlayer);

  FWorldGenerator := TWorldGenerator.Create;

  a := TAsteroid.Create(100, 10);
  a.X := 20;
  a.Y := 20;

  FAsteroids.Add(a);
end;

destructor TObjectHandler.Destroy;
begin
  FPlayers.Free;
  FShots.Free;
  FAsteroids.Free;
  FWorldGenerator.Free;
end;

function TObjectHandler.GetObjectList: TRenderableArray;
var
  i: Integer;
  players, shots, asteroids{, coins, guicoins}: Integer;
begin
  players := FPlayers.Count;
  shots := FShots.Count;
  asteroids := FAsteroids.Count;
  //coins := FCoins.List.Count;
  //guicoins := Length(FCoins.GUICoins);

  Setlength(Result, players + shots + asteroids{ + coins + guicoins});

  for i := 0 to players - 1 do
    Result[i] := FPlayers[i];
  for i := 0 to shots - 1 do
    Result[players + i] := FShots[i];
  for i := 0 to asteroids - 1 do
    Result[players + shots + i] := FAsteroids[i];

  {
  for i := 0 to coins - 1 do
    Result[players + shots + asteroids + i] := FCoins.List[i];
  for i := 0 to guicoins - 1 do
    Result[players + shots + asteroids + coins + i] := FCoins.GUICoins[i];
  }
end;

procedure TObjectHandler.RenderAll;
var
  i: Integer;
  objs: TRenderableArray;

  procedure RenderRect(BL, TR: TFloatPoint; R, G, B: Single);
  begin
    glBegin(GL_LINE_LOOP);
      glColor3f(R, G, B);
      glVertex2f(BL.X, BL.Y);
      glVertex2f(BL.X, TR.Y);
      glVertex2f(TR.X, TR.Y);
      glVertex2f(TR.X, BL.Y);
    glEnd;
  end;

begin
  objs := GetObjectList;

  for i := 0 to Length(objs) - 1 do begin
    glPushMatrix;
    objs[i].Render;
    glPopMatrix;
  end;

  glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0); glVertex3f(-5,  5, 0);
    glColor3f(0, 1, 0); glVertex3f( 0, -5, 0);
    glColor3f(0, 0, 1); glVertex3f( 5,  5, 0);
  glEnd;

  //Show visited bounds
  RenderRect(FWorldGenerator.FVisitedBottomLeft,
             FWorldGenerator.FVisitedTopRight,
             1, 0, 0);

  //Show generated bounds
  RenderRect(FWorldGenerator.FGeneratedBottomLeft,
             FWorldGenerator.FGeneratedTopRight,
             0, 0, 1);
end;

procedure TObjectHandler.UpdateAll(DT: Double);
var
  i: Integer;
  objs: TRenderableArray;
  shotsToRemove: array of Integer;

  procedure PlayerInput;
  var
    s: TShot;
  begin
    if KeyIsPressed(VK_DOWN) then
      FPlayer.Thrust(ttMain, DT);

    if not KeyIsPressed(VK_CONTROL) then begin
      if KeyIsPressed(VK_LEFT) then
        FPlayer.Thrust(ttSpinL, DT);
      if KeyIsPressed(VK_RIGHT) then
        FPlayer.Thrust(ttSpinR, DT);
    end else begin
      if KeyIsPressed(VK_DOWN) then
        FPlayer.Thrust(tt0, DT);

      if KeyIsPressed(VK_LEFT) then
        FPlayer.Thrust(ttYSpinL, DT);
      if KeyIsPressed(VK_RIGHT) then
        FPlayer.Thrust(ttYSpinR, DT);
    end;

    if KeyIsPressed(VK_UP) then begin
      s := FPlayer.Shoot;
      if s <> nil then
        FShots.Add(s);
    end;

    if KeyIsPressed(VK_SPACE) then begin
      FPlayer.Reset;
    end;
  end;

  procedure DeleteOldShots;
  var
    i: Integer;
    s: TShot;
  begin
    for s in FShots do begin
      if s.LifespanOver then begin
        SetLength(shotsToRemove, Length(shotsToRemove) + 1);
        shotsToRemove[Length(shotsToRemove) - 1] := FShots.IndexOf(s);
      end;
    end;

    for i := 0 to Length(shotsToRemove) - 1 do begin
      FShots.Delete(shotsToRemove[i]);
    end;
  end;

begin
  PlayerInput;
  DeleteOldShots;

  objs := GetObjectList;
  for i := 0 to Length(objs) - 1 do begin
    objs[i].Update(DT);
  end;

  FWorldGenerator.Visit(TFloatPoint.Create(FPlayer.X, FPlayer.Y));
end;

{ TBiome }

constructor TBiome.Create(ABiomeType: TBiomeType; ASize: Single;
  APosition: TFloatPoint);
begin
  FBiomeType := ABiomeType;
  FSize := ASize;
  FPosition := APosition;
end;

{ TWorldGenerator }

procedure TWorldGenerator.GenerateBiomes(FromBottomLeft,
  ToTopRight: TFloatPoint; IntoList: TObjectList<TWorldObject>);
begin

end;

procedure TWorldGenerator.Visit(APosition: TFloatPoint);
const
  BUFFER = GAME_GENERATION_CHUNK * GAME_GENERATION_BUFFER;
begin
  if APosition.X < FVisitedBottomLeft.X then
    FVisitedBottomLeft.X := APosition.X
  else if APosition.X > FVisitedTopRight.X then
    FVisitedTopRight.X := APosition.X;

  if APosition.Y < FVisitedBottomLeft.Y then
    FVisitedBottomLeft.Y := APosition.Y
  else if APosition.Y > FVisitedTopRight.Y then
    FVisitedTopRight.Y := APosition.Y;


  if (APosition.X - BUFFER) < FGeneratedBottomLeft.X then
    FGeneratedBottomLeft.X := (APosition.X - BUFFER - GAME_GENERATION_CHUNK)
  else if (APosition.X + BUFFER) > FGeneratedTopRight.X then
    FGeneratedTopRight.X := (APosition.X + BUFFER + GAME_GENERATION_CHUNK);

  if (APosition.Y - BUFFER) < FGeneratedBottomLeft.Y then
    FGeneratedBottomLeft.Y := (APosition.Y - BUFFER - GAME_GENERATION_CHUNK)
  else if (APosition.Y + BUFFER) > FGeneratedTopRight.Y then
    FGeneratedTopRight.Y := (APosition.Y + BUFFER + GAME_GENERATION_CHUNK);
end;

end.
