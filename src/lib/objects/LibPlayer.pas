unit LibPlayer;

interface

uses
  LibRenderableObject, LibShot;

type
  TThrusterType = (ttMain, ttSpinL, ttSpinR);

  TPlayer = class(TWorldObject)
  private
    FCooldown: Single;
  public
    procedure Thrust(ThrusterType: TThrusterType; DT: Single);
    function Shoot: TShot;

    procedure Render; override;
    procedure Update(DT: Double); override;

  end;

implementation

uses
  DGLOpenGL,

  LibShared;

{ TPlayer }

function TPlayer.Shoot: TShot;
var
  shotAngle: Single;
begin
  Result := nil;
  if FCooldown <= 0 then begin
    shotAngle := FR + Random * GAME_SHOT_INACCURACY - GAME_SHOT_INACCURACY / 2;
    Result := TShot.Create(FX, FY,
                           shotAngle,
                           FVX + GAME_SHOT_SPEED * Cos(DegTorad(shotAngle)),
                           FVY + GAME_SHOT_SPEED * Sin(DegTorad(shotAngle)),
                           10);

    FCooldown := GAME_PLAYER_COOLDOWN;
  end;
end;

procedure TPlayer.Thrust(ThrusterType: TThrusterType; DT: Single);
begin
  case ThrusterType of
    ttMain: begin
      FVX := FVX + GAME_PLAYER_THRUST * Cos(DegToRad(FR)) * DT;
      FVY := FVY + GAME_PLAYER_THRUST * Sin(DegToRad(FR)) * DT;
    end;
    ttSpinL: FVR := FVR + GAME_PLAYER_THRUST_ROT * DT;
    ttSpinR: FVR := FVR - GAME_PLAYER_THRUST_ROT * DT;
  end;
end;

procedure TPlayer.Update(DT: Double);
begin
  inherited;

  FCooldown := FCooldown - DT;
end;

procedure TPlayer.Render;
begin
  inherited;

  glBegin(GL_POLYGON);
    glColor3f(0, 0, 0); glVertex3f( 3,  0, 0);
    glColor3f(0, 0, 0); glVertex3f(-1,  2, 0);
    glColor3f(0, 0, 0); glVertex3f( 0,  0, 0);
    glColor3f(0, 0, 0); glVertex3f(-1, -2, 0);
  glEnd;

  glTranslatef(0, 0, 0.1);

  glBegin(GL_LINE_LOOP);
    glColor3f(1, 0, 0);     glVertex3f( 3,  0, 0);
    glColor3f(0, 1, 0);     glVertex3f(-1,  2, 0);
    glColor3f(0, 0.5, 0.5); glVertex3f( 0,  0, 0);
    glColor3f(0, 0, 1);     glVertex3f(-1, -2, 0);
  glEnd;

end;

end.

