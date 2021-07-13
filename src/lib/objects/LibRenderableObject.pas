unit LibRenderableObject;

interface

uses
  LibShared;

type
  TRenderableObject = class abstract
  public
    procedure Update(DT: Double); virtual; abstract;
    procedure Render; virtual; abstract;
  end;

  TRenderableArray = array of TRenderableObject;

  TWorldObject = class abstract (TRenderableObject)
  protected
    FX,  FY,  FZ,  FR: Single;
    FVX, FVY, FVZ, FVR: Single;

    FColor: TColor;
  public
    property X: Single read FX write FX;
    property Y: Single read FY write FY;
    property Z: Single read FZ write FZ;
    property R: Single read FR write FR;

    property VX: Single read FVX write FVX;
    property VY: Single read FVY write FVY;

    procedure Reset; virtual;

    procedure Update(DT: Double); override;
    procedure Render; override;
  end;

implementation

uses
  DGLOpenGL;

{ TWorldObject }

procedure TWorldObject.Render;
begin
  glTranslatef(FX, FY, FZ);
  glRotatef(FR, 0, 0, 1);

  if DebugMode then begin
    glBegin(GL_POINTS);
    glColor3f(1, 1, 1);
    glVertex3f(0, 0, 1);
    glEnd;
  end;
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

procedure TWorldObject.Update(DT: Double);
begin
  FX := FX + FVX * DT;
  FY := FY + FVY * DT;
  FZ := FZ + FVZ * DT;
  FR := FR + FVR * DT;
end;

end.
