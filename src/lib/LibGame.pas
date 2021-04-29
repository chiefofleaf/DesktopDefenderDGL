unit LibGame;

interface

uses
  Winapi.Windows, DGLOpenGL,

  LibCamera2D, LibObjectHandler;

type
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

  TGame = class
  private
    //OpenGL uses these to know on which window, panel to draw
    FHandle: Cardinal;
    RC: HGLRC;
    DC: HDC;

    //whether game is paused or not
    FStarted: Boolean;

    //the important stuff
    FCam: TCamera2D;  aY, aX:Single; FZoom: Single;
    FBackgroundRenderer: TBackgroundRenderer;
    FObjectHandler: TObjectHandler;

    //used for FPS calculation
    FLastTime: Int64;
    FTimeCounter: Double;
    FFrames: Integer;
    FLastFPS: Integer;

    //set up some OpenGL stuff
    procedure SetupGL;

    //the main Update and Render procedures that get called directly by the main game loop
    //the actual updating and rendering is done by the procedures called by these main two procs
    procedure Update(DT: Double);
    procedure Render(DT: Double);

    //important for when I use OpenGL incorrectly :)
    procedure HandleError;
  public
    //public access to get the last calculated FPS value
    property FPS: Integer read FLastFPS;

    //constructor, destructor. you know what's up.
    constructor Create(WindowHandle: Cardinal);
    destructor Destroy; override;

    //called, when window gets resized
    procedure Resize(NewWidth, NewHeight: Integer);

    //main game loop. called by the delphi Application.IdleHandler
    procedure GameLoop(Sender: TObject; var Done: Boolean);

    //set FStarted
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
  FObjectHandler := TObjectHandler.Create;
  FBackgroundRenderer := TBackgroundRenderer.Create;

  QueryPerformanceCounter(FLastTime);
  FTimeCounter := 0;
  FFrames := 0;
  FLastFPS := 0;
  aY := 0;aX := 0;
  FZoom := 1;
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
  glEnable(GL_POINT_SMOOTH);
  glDisable(GL_LINE_SMOOTH);
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

  GameLoop(nil, b);
end;

procedure TGame.GameLoop(Sender: TObject; var Done: Boolean);
var
  thisTime, fr: Int64;
  diff: Double;
begin
  if FStarted then begin
    QueryPerformanceCounter(thisTime);
    QueryPerformanceFrequency(fr);
    diff := (thisTime - FLastTime) / fr;

    Update(diff);
    Render(diff);
    HandleError;

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

procedure TGame.HandleError;
var
  error: Cardinal;
  errorString: string;
begin
  error := glGetError;

  if error <> GL_NO_ERROR then begin
    errorString := gluErrorString(error);
  end;
end;

procedure TGame.Update(DT: Double);
begin
  FObjectHandler.UpdateAll(DT);
end;

procedure TGame.Render(DT: Double);
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  if KeyIsPressed(Ord('D')) then
    aY := aY + DT * 100;
  if KeyIsPressed(Ord('A')) then
    aY := aY - DT * 100;

  if KeyIsPressed(Ord('W')) then
    aX := aX + DT * 100;
  if KeyIsPressed(Ord('S')) then
    aX := aX - DT * 100;

  if KeyIsPressed(VK_ADD) then
    FZoom := FZoom * (1 - CAMERA_ZOOM_SPEED * DT);
  if KeyIsPressed(VK_SUBTRACT) then
    FZoom := FZoom * (1 + CAMERA_ZOOM_SPEED * DT);


  glTranslatef(0, 0, -CAMERA_DISTANCE * FZoom);

  glRotatef(aX, 1, 0, 0);
  glRotatef(aY, 0, 1, 0);

  FCam.SetCamera(FObjectHandler.Player.X, FObjectHandler.Player.Y, FObjectHandler.Player.Z, DT);


  glPushMatrix;
    FBackgroundRenderer.RenderBackground;
  glPopMatrix;

  glPushMatrix;
    FObjectHandler.RenderAll;
  glPopMatrix;

  glLoadIdentity;

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
var
  i: Integer;
begin
  glPointSize(2);

  glScalef(10000, 10000, 5000);
  glTranslatef(-0.5, -0.5, -0.1);
  glBegin(GL_POINTS);
    glColor3f(1, 1, 1);
    for i := 0 to GAME_BACKGROUND_STARCOUNT - 1 do begin
      glVertex3f(FStars[i].X, FStars[i].Y, FStars[i].Z);
    end;
  glEnd;
end;

end.
