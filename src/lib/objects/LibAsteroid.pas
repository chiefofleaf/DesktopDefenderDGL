unit LibAsteroid;

interface

uses
  System.Types, Generics.Collections,

  LibDestroyableObject, LibMaterial, LibShared;

type
  TAsteroid = class (TDestroyableObject)
  private
    FEdges: array of TFloatPoint;
  public
    constructor Create(HPMax: Single; CollisionRadius: Single); override;


    procedure GenerateLoot(DestroyableObjects: TObjectList<TDestroyableObject>;
                           PickUpableObjects: TObjectList<TMaterial>); override;
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

procedure TAsteroid.GenerateLoot(
  DestroyableObjects: TObjectList<TDestroyableObject>;
  PickUpableObjects: TObjectList<TMaterial>);
var
  i: Integer;
  babyAstCount: Integer;
  a: TAsteroid;
  m: TMaterial;
  mt: TMaterialType;
begin
  inherited;

  if FHP > 0 then begin


          {
    for i := 0 to Round(Random * 2) do begin

      mt := TMaterialType(Round(Random * Integer(High(TMaterialType))));
      m := TMaterial.Create(mt);
      m.X := FX + Random * 10 - 5;
      m.Y := FY + Random * 10 - 5;

      m.VX := FVX + Random * 2 - 1;
      m.VY := FVY + Random * 2 - 1;

      m.R := Random * 360;
      PickUpableObjects.Add(m)
    end;   }

  end else begin
    //HP < 0

    while Random < 0.1 do begin
      mt := TMaterialType(Round(Random * Integer(High(TMaterialType))));
      m := TMaterial.Create(mt);
      m.X := FX + Random * 10 - 5;
      m.Y := FY + Random * 10 - 5;

      m.VX := FVX + Random * 2 - 1;
      m.VY := FVY + Random * 2 - 1;

      m.R := Random * 360;
      PickUpableObjects.Add(m)
    end;

    babyAstCount := 1;
    //chance to split into smaller asteroids
    while random < GAME_ASTEROID_SPLIT_CHANCE do begin
      babyAstCount := babyAstCount + 1;
    end;

    if  (babyAstCount >= 1)
    //and ((CollisionRadius / babyAstCount) >= GAME_ASTEROID_MINSIZE)
    then begin
      for i := 0 to babyAstCount - 1 do begin
        a := TAsteroid.Create(FHPMax / babyAstCount, FCollisionRadius / babyAstCount);
        a.X := FX + Random * 10 - 5;
        a.Y := FY + Random * 10 - 5;

        a.VX := FVX + Random * 4 - 2;
        a.VY := FVY + Random * 4 - 2;

        a.R := Random * 360;
        DestroyableObjects.Add(a);
      end;
    end;
  end;
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
