unit LibShared;

interface

const
  DISPLAY_CLIPPING_NEAR = 1;
  DISPLAY_CLIPPING_FAR  = 10000;

  DISPLAY_TRANSPARENT = FALSE;
  DISPLAY_TRANSPARENT_COLOR = $00010101;

  CAMERA_MOVE_SPEED = 0.1;//0: no move; 0<x<1: limited camera speed; 1: instant camera positioning

  GAME_BACKGROUND_STARCOUNT = 500;

  GAME_PLAYER_THRUST = 1;
  GAME_PLAYER_THRUST_ROT = -10;

function DegToRad(Deg: Single): Single;

implementation

function DegToRad(Deg: Single): Single;
begin
  Result := Deg / 180 * Pi;
end;

end.
