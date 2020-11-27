unit LibShared;

interface

const
  DISPLAY_CLIPPING_NEAR = 1;
  DISPLAY_CLIPPING_FAR  = 10000;

  DISPLAY_TRANSPARENT = FALSE;
  DISPLAY_TRANSPARENT_COLOR = $00010101;

  CAMERA_MOVE_SPEED = 5;//0: no move; 0<x<1: limited camera speed; 1: instant camera positioning

  GAME_BACKGROUND_STARCOUNT = 1000;

  GAME_SHOT_LIFESPAN = 1.5; //After this many seconds, a shot shot will be destroyed
  GAME_SHOT_SPEED = 65;
  GAME_SHOT_INACCURACY = 3.5; //5°: Shots will be shot randomly between +2.5° and -2.5° of player angle

  GAME_PLAYER_THRUST = 50;
  GAME_PLAYER_THRUST_ROT = -400;
  GAME_PLAYER_COOLDOWN = 0.1; //Weapon cooldown time in seconds

function DegToRad(Deg: Single): Single;

implementation

function DegToRad(Deg: Single): Single;
begin
  Result := Deg / 180 * Pi;
end;

end.
