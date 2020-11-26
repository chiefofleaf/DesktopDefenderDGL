unit LibGame;

interface

uses
  Winapi.Windows, DGLOpenGL,

  LibCamera2D;

type
  IRenderableObject = interface
    procedure Update(DT: Double);
    procedure Render(DC: HDC);
  end;

  TRenderableArray = array of IRenderableObject;

  TBackgroundStar = record
    X, Y, Z: Single;
  end;

  TBackgroundRenderer = class
  private
    FStars: array of TBackgroundStar;
  public
    constructor Create;
    procedure RenderBackground;
  end;

  TObjectHandler = class
  private
    DC: HDC;
    FObjs: TRenderableArray;
  public
    constructor Create(DeviceContext: HDC);

    procedure UpdateAll(DT: Double);
    procedure RenderAll;
  end;

  TGame = class
  private
    FHandle: Cardinal;
    RC: HGLRC;
    DC: HDC;

    FStarted: Boolean;
    FCam: TCamera2D;
    FBackgroundRenderer: TBackgroundRenderer;
    FObjectHandler: TObjectHandler;

    FLastTime: Int64;
    FTimeCounter: Double;
    FFrames: Integer;
    FLastFPS: Integer;

    procedure SetupGL;

    procedure Update(DT: Double);
    procedure Render;
  public
    property FPS: Integer read FLastFPS;


    constructor Create(WindowHandle: Cardinal);
    destructor Destroy; override;

    procedure Resize(NewWidth, NewHeight: Integer);

    procedure IdleHandler(Sender: TObject; var Done: Boolean);
    procedure Start;
    procedure Stop;
  end;

implementation

uses
  LibShared;

{ TGame }

constructor TGame.Create(WindowHandle: Cardinal);

  procedure DoNothing; begin end;

begin
  FStarted := False;
  FHandle := WindowHandle;

  if not InitOpenGL then
    DoNothing;


  DC:= GetDC(FHandle);
  RC := CreateRenderingContext(DC, [opDoubleBuffered], 32, 24, 0,0,0, 0);
  ActivateRenderingContext(DC, RC);
  SetupGL;

  FCam := TCamera2D.Create;
  FObjectHandler := TObjectHandler.Create(DC);
  FBackgroundRenderer := TBackgroundRenderer.Create;

  QueryPerformanceCounter(FLastTime);
  FTimeCounter := 0;
  FFrames := 0;
  FLastFPS := 0;
end;

destructor TGame.Destroy;
begin
  DeactivateRenderingContext;
  DestroyRenderingContext(RC);
  ReleaseDC(FHandle, DC);

  FCam.Free;
  FObjectHandler.Free;
  FBackgroundRenderer.Free;

  inherited;
end;

procedure TGame.SetupGL;
begin
  glClearColor(1/255, 1/255, 1/255, 0); //
  glEnable(GL_DEPTH_TEST);          //Tiefentest aktivieren
  glEnable(GL_CULL_FACE);           //Backface Culling aktivieren
end;

procedure TGame.Resize(NewWidth, NewHeight: Integer);
var
  b: Boolean;
begin
  glViewport(0, 0, NewWidth, NewHeight);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(45.0, NewWidth/NewHeight, DISPLAY_CLIPPING_NEAR, DISPLAY_CLIPPING_FAR);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  IdleHandler(nil, b);
end;

procedure TGame.IdleHandler(Sender: TObject; var Done: Boolean);
var
  thisTime, fr: Int64;
  diff: Double;
begin
  if FStarted then begin
    QueryPerformanceCounter(thisTime);
    QueryPerformanceFrequency(fr);
    diff := (thisTime - FLastTime) / fr;


    Update(diff);
    Render;

    FFrames := FFrames + 1;

    FTimeCounter := FTimeCounter + diff;
    if FTimeCounter >= 1 then begin
      FTimeCounter := FTimeCounter - 1;
      FLastFPS := FFrames;
      FFrames := 0;
    end;
    FLastTime := thisTime;

  end;

  sleep(10);
  Done := False;
end;

procedure TGame.Update(DT: Double);
begin
  FObjectHandler.UpdateAll(DT);
end;

procedure TGame.Render;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  FCam.SetCamera(0, 0);     //Player.X, Player.Y

  FBackgroundRenderer.RenderBackground;
  FObjectHandler.RenderAll;

  SwapBuffers(DC);
end;

procedure TGame.Start;
begin
  FStarted := True;
end;

procedure TGame.Stop;
begin
  FStarted := False;
end;

{ TObjectHandler }

constructor TObjectHandler.Create(DeviceContext: HDC);
begin
  DC := DeviceContext;
end;

procedure TObjectHandler.RenderAll;
var
  i: Integer;
begin
  for i := 0 to Length(FObjs) - 1 do begin
    FObjs[i].Render(DC);
  end;

  glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0); glVertex3f(-1, 1, 0);
    glColor3f(0, 1, 0); glVertex3f(0, -1, 0);
    glColor3f(0, 0, 1); glVertex3f(1, 1, 0);
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

{ TBackgroundRenderer }

constructor TBackgroundRenderer.Create;
var
  i: Integer;
begin
  SetLength(FStars, GAME_BACKGROUND_STARCOUNT);

  for i := 0 to GAME_BACKGROUND_STARCOUNT - 1 do begin
    FStars[i].X := Random;
    FStars[i].Y := Random;
    FStars[i].Z := -Random;
  end;
end;

procedure TBackgroundRenderer.RenderBackground;
begin

end;

end.
