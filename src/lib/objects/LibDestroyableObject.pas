unit LibDestroyableObject;

interface

uses
  Generics.Collections,

  LibRenderableObject, LibMaterial;

type
  TDestroyableObject = class abstract (TWorldObject)
  protected
    FHP, FHPMax: Single;
    FCollisionRadius: Single;
  public
    property HP: Single read FHP write FHP;
    property HPMax: Single read FHPMax write FHPMax;

    property CollisionRadius: Single read FCollisionRadius write FCollisionRadius;

    //Decreases FHP by Dmg and returns whether object has <= 0 HP
    function Damage(Dmg: Single): Boolean; virtual;
    //adds dropped things to passed lists
    procedure GenerateLoot(DestroyableObjects: TObjectList<TDestroyableObject>;
                           PickUpableObjects: TObjectList<TMaterial>); virtual; abstract;

    constructor Create(HPMax: Single; CollisionRadius: Single); virtual;

    procedure Render; override;
  end;

implementation

uses
  LibShared, DGLOpenGL;

{ TDestroyableObject }

constructor TDestroyableObject.Create(HPMax, CollisionRadius: Single);
begin
  FHPMax := HPMax;
  FHP := FHPMax;
  FCollisionRadius := CollisionRadius;
end;

function TDestroyableObject.Damage(Dmg: Single): Boolean;
begin
  FHP := FHP - Dmg;
  Result := FHP <= 0;
end;

procedure TDestroyableObject.Render;
var
  i: Integer;
  a: Single;
const
  CIRCLE_POINTS = 10;
begin
  inherited;

  if DebugMode then begin

    glBegin(GL_LINE_LOOP);
    glColor3f(0, 1, 0);
    for i := 0 to CIRCLE_POINTS - 1 do begin
      a := i / CIRCLE_POINTS * 2*Pi;
      glVertex2f(FCollisionRadius * Cos(a), FCollisionRadius * Sin(a));
    end;
    glEnd;
  end;
end;

end.
