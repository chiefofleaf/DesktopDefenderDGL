unit LibPlayer;

interface

uses
  LibRenderableObject;

type
  TThrusterType = (ttMain, ttSpinL, ttSpinR);

  TPlayer = class(TWorldObject)
  public
    procedure Thrust(ThrusterType: TThrusterType; DT: Single);

    procedure Render; override;

  end;

implementation

uses
  DGLOpenGL,

  LibShared;

{ TPlayer }

procedure TPlayer.Thrust(ThrusterType: TThrusterType; DT: Single);
begin
  case ThrusterType of
    ttMain: begin
      FVX := FVX + GAME_PLAYER_THRUST * Cos(FR) * DT;
      FVY := FVY + GAME_PLAYER_THRUST * Sin(FR) * DT;
    end;
    ttSpinL: FVR := FVR + GAME_PLAYER_THRUST_ROT * DT;
    ttSpinR: FVR := FVR - GAME_PLAYER_THRUST_ROT * DT;
  end;
end;

procedure TPlayer.Render;
begin
  inherited;

  glBegin(GL_LINE_LOOP);
    glColor3f(1, 0, 0); glVertex3f( 0,  3, 0);
    glColor3f(0, 1, 0); glVertex3f( 2, -3, 0);
    glColor3f(0, 0.5, 0.5); glVertex3f( 0, -1, 0);
    glColor3f(0, 0, 1); glVertex3f(-2, -3, 0);
  glEnd;

end;

end.

