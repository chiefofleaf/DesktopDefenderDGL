unit LibDestroyableObject;

interface

uses
  LibRenderableObject, LibElement;

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
    //Returns array of Elements the object dropped
    function GenerateLoot: TElementArray; virtual; abstract;

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
