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

procedure TWorldObject.Update(DT: Double);
begin
  FX := FX + FVX;
  FY := FY + FVY;
  FZ := FZ + FVZ;
  FR := FR + FVR;
end;

end.
