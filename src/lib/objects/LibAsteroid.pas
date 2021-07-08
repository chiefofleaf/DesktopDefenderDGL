unit LibAsteroid;

interface

uses
  System.Types,

  LibDestroyableObject, LibElement, LibShared;

type
  TAsteroid = class (TDestroyableObject)
  private
    FEdges: array of TFloatPoint;
  public
    constructor Create(HPMax: Single; CollisionRadius: Single); override;

    function GenerateLoot: TElementArray; override;
    procedure Render; override;
  end;

implementation

uses
  DGLOpenGL;

{ TAsteroid }

constructor TAsteroid.Create(HPMax: Single; CollisionRadius: Single);
var
  i: Integer;
  a: Single;
begin
  inherited;

  FColor := IntToCol($00ffffff);
  FVR := Random * GAME_ASTEROID_SPIN - GAME_ASTEROID_SPIN / 2;

  SetLength(FEdges, GAME_ASTEROID_EDGES);
  for i := 0 to GAME_ASTEROID_EDGES - 1 do begin
    a := 360 / GAME_ASTEROID_EDGES * i;
    FEdges[i].X := (0.5 + Random) * FCollisionRadius * Cos(DegToRad(a));
    FEdges[i].Y := (0.5 + Random) * FCollisionRadius * Sin(DegToRad(a));
  end;
end;

function TAsteroid.GenerateLoot: TElementArray;
begin
  //NYI
end;

procedure TAsteroid.Render;
var
  i: Integer;
begin
  inherited;

  glLineWidth(2);

  glBegin(GL_TRIANGLE_FAN);
    glColor3ub(0, 0, 0);
    for i := 0 to GAME_ASTEROID_EDGES - 1 do begin
      glVertex3f(FEdges[i].X, FEdges[i].Y, 0);
    end;
  glEnd;

  glTranslatef(0, 0, 0.1);

  glBegin(GL_LINE_LOOP);
    glColor3ub(FColor.R, FColor.G, FColor.B);
    for i := 0 to GAME_ASTEROID_EDGES - 1 do begin
      glVertex3f(FEdges[i].X, FEdges[i].Y, 0);
    end;
  glEnd;
end;

end.