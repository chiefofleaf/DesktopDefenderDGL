unit LibGame;

interface

uses
  Winapi.Windows, DGLOpenGL;

type
  IRenderableObject = interface
    procedure Update(DT: Double);
    procedure Render(DC: HDC);
  end;

  TRenderableArray = array of IRenderableObject;

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
    FObjectHandler: TObjectHandler;

    FLastTime: Int64;
    FTimeCounter: Double;
    FFrames: Integer;
    FLastFPS: Integer;

    procedure SetupGL;

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

  FObjectHandler := TObjectHandler.Create(DC);

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

  FObjectHandler.Free;

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

    FObjectHandler.UpdateAll(diff);
    FObjectHandler.RenderAll;

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

procedure TGame.Render;
begin
  FObjectHandler.RenderAll;
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

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  glTranslatef(0, 0, -5);

  glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0); glVertex3f(-1, 1, 0);
    glColor3f(0, 1, 0); glVertex3f(0, -1, 0);
    glColor3f(0, 0, 1); glVertex3f(1, 1, 0);
  glEnd;

  SwapBuffers(DC);
end;

procedure TObjectHandler.UpdateAll(DT: Double);
var
  i: Integer;
begin
  for i := 0 to Length(FObjs) - 1 do begin
    FObjs[i].Update(0.69);
  end;
end;

end.
