unit LibRenderableObject;

interface

uses
  DGLOpenGL;

type
  TRenderableObject = class abstract
  public
    procedure Update(DT: Double); virtual; abstract;
    procedure Render; virtual; abstract;
  end;

  TWorldObject = class abstract (TRenderableObject)
  protected
    FX,  FY,  FZ,  FR: Single;
    FVX, FVY, FVZ, FVR: Single;
  public
    property X: Single read FX write FX;
    property Y: Single read FY write FY;
    property Z: Single read FZ write FZ;
    property R: Single read FR write FR;

    function test: Double;

    procedure Reset;

    procedure Update(DT: Double); override;
    procedure Render; override;
  end;

  TRenderableArray = array of TRenderableObject;

implementation

{ TWorldObject }

procedure TWorldObject.Render;
begin
  glTranslatef(FX, FY, FZ);
  glRotatef(FR, 0, 0, 1);
end;

procedure TWorldObject.Reset;
begin
  FX := 0;
  FY := 0;
  FZ := 0;
  FR := 0;
  FVX := 0;
  FVY := 0;
  FVZ := 0;
  FVR := 0;
end;

function TWorldObject.test: Double;
begin
  Result := Sqrt(FVX * FVX + FVY * FVY);
end;

procedure TWorldObject.Update(DT: Double);
begin
  FX := FX + FVX * DT;
  FY := FY + FVY * DT;
  FZ := FZ + FVZ * DT;
  FR := FR + FVR * DT;
end;

end.
