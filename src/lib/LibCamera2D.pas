unit LibCamera2D;

interface

type
  TCamera2D = class
  private
    CurX, CurY: Single;
  public
    constructor Create;
    procedure SetCamera(X, Y: Single);
  end;

implementation

uses
  DGLOpenGL,

  LibShared;

{ TCamera2D }

constructor TCamera2D.Create;
begin
  CurX := 0;
  CurY := 0;
end;

procedure TCamera2D.SetCamera(X, Y: Single);
begin
  CurX := CurX + CAMERA_MOVE_SPEED * (X - CurX);
  CurY := CurY + CAMERA_MOVE_SPEED * (Y - CurY);

  glTranslatef(-CurX, -CurY, -5);
end;

end.
