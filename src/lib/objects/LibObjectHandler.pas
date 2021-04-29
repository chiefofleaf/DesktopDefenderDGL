unit LibObjectHandler;

interface

uses
  Generics.Collections,

  LibPlayer, LibRenderableObject, LibShot, LibAsteroid;

type
  TObjectHandler = class
  private
    FPlayer: TPlayer;
    FPlayers: TObjectList<TPlayer>;
    FShots: TObjectList<TShot>;
    FAsteroids: TObjectList<TAsteroid>;
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
  Winapi.Windows, DGLOpenGL,
  LibShared;

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
end;

end.
