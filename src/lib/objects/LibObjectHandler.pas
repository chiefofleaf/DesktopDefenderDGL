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
    property Player: TPlayer read FPlayer;

    constructor Create;
    destructor Destroy; override;

    procedure UpdateAll(DT: Double);
    procedure RenderAll;
  end;

implementation

uses
  DGLOpenGL, Winapi.Windows;

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
    glPushMatrix;
    FObjs[i].Render;
    glPopMatrix;
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
  if (GetKeyState(VK_UP) AND $80) <> 0 then
    FPlayer.Thrust(ttMain, DT);
  if (GetKeyState(VK_LEFT) AND $80) <> 0 then
    FPlayer.Thrust(ttSpinL, DT);
  if (GetKeyState(VK_RIGHT) AND $80) <> 0 then
    FPlayer.Thrust(ttSpinR, DT);

  if (GetKeyState(VK_SPACE) AND $80) <> 0 then begin
    FPlayer.Reset;
  end;

  for i := 0 to Length(FObjs) - 1 do begin
    FObjs[i].Update(DT);
  end;
end;

end.
