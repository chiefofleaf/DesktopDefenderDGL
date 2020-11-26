unit LibObjectHandler;

interface

uses
  LibPlayer, LibRenderableObject;

type
  TObjectHandler = class
  private
    FPlayer: TPlayer;
    FObjs: TRenderableArray;
  public
    constructor Create;
    destructor Destroy; override;

    procedure UpdateAll(DT: Double);
    procedure RenderAll;
  end;

implementation

uses
  DGLOpenGL;

{ TObjectHandler }

constructor TObjectHandler.Create;
begin
  FPlayer := TPlayer.Create;
  SetLength(FObjs, 1);
  FObjs[0] := FPlayer;
end;

destructor TObjectHandler.Destroy;
begin
  FPlayer.Free;
end;

procedure TObjectHandler.RenderAll;
var
  i: Integer;
begin
  for i := 0 to Length(FObjs) - 1 do begin
    FObjs[i].Render;
  end;

  glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0); glVertex3f(-1,  1, 0);
    glColor3f(0, 1, 0); glVertex3f( 0, -1, 0);
    glColor3f(0, 0, 1); glVertex3f( 1,  1, 0);
  glEnd;

end;

procedure TObjectHandler.UpdateAll(DT: Double);
var
  i: Integer;
begin
  for i := 0 to Length(FObjs) - 1 do begin
    FObjs[i].Update(DT);
  end;
end;

end.
