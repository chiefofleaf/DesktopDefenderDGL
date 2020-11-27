unit LibObjectHandler;

interface

uses
  Generics.Collections,

  LibPlayer, LibRenderableObject, LibShot;

type
  TObjectHandler = class
  private
    FPlayer: TPlayer;
    FPlayers: TObjectList<TPlayer>;
    FShots: TObjectList<TShot>;
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
  DGLOpenGL, Winapi.Windows;

{ TObjectHandler }

constructor TObjectHandler.Create;
begin
  FPlayer := TPlayer.Create;
  FPlayers := TObjectList<TPlayer>.Create(True);
  FShots := TObjectList<TShot>.Create(True);
  FPlayers.Add(FPlayer);
end;

destructor TObjectHandler.Destroy;
begin
  FPlayers.Free;
  FShots.Free;
end;

function TObjectHandler.GetObjectList: TRenderableArray;
var
  i: Integer;
  players, shots{, asteroids, coins, guicoins}: Integer;
begin
  players := FPlayers.Count;
  shots := FShots.Count;
  //asteroids := FAsteroids.Count;
  //coins := FCoins.List.Count;
  //guicoins := Length(FCoins.GUICoins);

  Setlength(Result, players + shots{ + asteroids + coins + guicoins});

  for i := 0 to players - 1 do
    Result[i] := FPlayers[i];
  for i := 0 to shots - 1 do
    Result[players + i] := FShots[i];

  {
  for i := 0 to asteroids - 1 do
    Result[players + shots + i] := FAsteroids[i];
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
    if (GetKeyState(VK_DOWN) AND $80) <> 0 then
      FPlayer.Thrust(ttMain, DT);

    if (GetKeyState(VK_LEFT) AND $80) <> 0 then
      FPlayer.Thrust(ttSpinL, DT);
    if (GetKeyState(VK_RIGHT) AND $80) <> 0 then
      FPlayer.Thrust(ttSpinR, DT);

    if (GetKeyState(VK_UP) AND $80) <> 0 then begin
      s := FPlayer.Shoot;
      if s <> nil then
        FShots.Add(s);
    end;

    if (GetKeyState(VK_SPACE) AND $80) <> 0 then begin
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
