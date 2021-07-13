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
  end;

implementation

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

end.
