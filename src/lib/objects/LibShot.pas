unit LibShot;

interface

uses
  LibRenderableObject;

type
  TShot = class(TWorldObject)
  private
    FDmg: Single;
    FLifespan: Single;
  public
    constructor Create(X, Y, R, VX, VY, Dmg: Single);

    function LifespanOver: Boolean;

    procedure Render; override;
    procedure Update(DT: Double); override;
  end;

implementation

uses
  DGLOpenGL, LibShared;

{ TShot }

constructor TShot.Create(X, Y, R, VX, VY, Dmg: Single);
begin
  FX := X;
  FY := Y;
  FR := R;
  FVX := VX;
  FVY := VY;
  FDmg := Dmg;
  FLifespan := GAME_SHOT_LIFESPAN;
end;

function TShot.LifespanOver: Boolean;
begin
  Result := FLifespan <= 0;
end;

procedure TShot.Render;
begin
  inherited;

  glBegin(GL_LINES);
    glColor3f(1, 1, 1);
    glVertex3f(-1, 0, 0);
    glVertex3f(1, 0, 0);
  glEnd;
end;

procedure TShot.Update(DT: Double);
begin
  inherited;

  FLifespan := FLifespan - DT;
end;

end.
