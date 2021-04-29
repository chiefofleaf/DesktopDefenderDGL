unit LibShared;

interface

const
  DISPLAY_CLIPPING_NEAR = 1;
  DISPLAY_CLIPPING_FAR  = 10000;

  DISPLAY_TRANSPARENT = FALSE;
  DISPLAY_TRANSPARENT_COLOR = $00010101;

  CAMERA_MOVE_SPEED = 5;//0: no move; 0<x<1: limited camera speed; 1: instant camera positioning
  CAMERA_ZOOM_SPEED = 1;
  CAMERA_DISTANCE = 150;

  GAME_BACKGROUND_STARCOUNT = 12000;

  GAME_SHOT_LIFESPAN = 1.5; //After this many seconds, a shot shot will be destroyed
  GAME_SHOT_SPEED = 65;
  GAME_SHOT_INACCURACY = 3.5; //5°: Shots will be shot randomly between +2.5° and -2.5° of player angle

  GAME_ASTEROID_SPIN = 20;
  GAME_ASTEROID_EDGES = 10;

  GAME_PLAYER_THRUST = 50;
  GAME_PLAYER_THRUST_ROT = -400;
  GAME_PLAYER_COOLDOWN = 0.1; //Weapon cooldown time in seconds

type
  TColor = record
    R, G, B, A: Byte;
  end;

  TFloatPoint = record
    X, Y: Single;
  end;

function KeyIsPressed(VKCode: Cardinal): Boolean;

function IntToCol(Color: Integer): TColor;

function DegToRad(Deg: Single): Single;

implementation

uses
  Winapi.Windows;

function KeyIsPressed(VKCode: Cardinal): Boolean;
begin
  Result := (GetKeyState(VKCode) AND $80) <> 0;
end;

function IntToCol(Color: Integer): TColor;
begin
  Result.R := Color AND $000000ff;
  Result.G := Color AND $0000ff00 shr 8;
  Result.B := Color AND $00ff0000 shr 16;
  Result.A := COlor And $ff000000 shr 24;
end;

function DegToRad(Deg: Single): Single;
begin
  Result := Deg / 180 * Pi;
end;

end.
