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

    procedure GameLoop(Sender: TObject; var Done: Boolean);
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

  glPushMatrix;
    FBackgroundRenderer.RenderBackground;
  glPopMatrix;

  glPushMatrix;
    FObjectHandler.RenderAll;
  glPopMatrix;

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
begin

end;

end.
