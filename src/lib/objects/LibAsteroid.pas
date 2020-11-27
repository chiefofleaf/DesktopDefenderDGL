unit LibAsteroid;

interface

uses
  LibDestroyableObject;

type
  TAsteroid = class (TDestroyableObject)
  public
    constructor Create(HPMax: Single; CollisionRadius: Single); override;

    procedure Render; override;
  end;

implementation

uses
  DGLOpenGL, LibShared;

{ TAsteroid }

constructor TAsteroid.Create(HPMax: Single; CollisionRadius: Single);
begin
  inherited;

  FColor := IntToCol($00ffffff);
  FVR := Random * GAME_ASTEROID_SPIN - GAME_ASTEROID_SPIN / 2;
end;

procedure TAsteroid.Render;
begin
  inherited;

  glBegin(GL_TRIANGLE_FAN);
    glColor3ub(FColor.R, FColor.G, FColor.B);
    glVertex3f(                0,  FCollisionRadius, 0);
    glVertex3f(-FCollisionRadius,                 0, 0);
    glVertex3f(                0, -FCollisionRadius, 0);
    glVertex3f( FCollisionRadius,                 0, 0);
  glEnd;
end;

end.
