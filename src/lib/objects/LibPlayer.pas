unit LibPlayer;

interface

uses
  Generics.Collections,

  LibRenderableObject, LibShot;

type
  TThrusterType = (ttMain, ttSpinL, ttSpinR, ttYSpinL, ttYSpinR, tt0);

  TPlume = class (TWorldObject)
  public
    LifeSpan: Double;
    left, right: Boolean;

    constructor Create(l, r: Boolean);

    procedure Update(DT: Double); override;
    procedure Render; override;
  end;

  TPlumeHandler = class
  private
    FCooldown: Double;
    FPlumes: TObjectList<TPlume>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Update(DT: Double);
    procedure Render;
  end;

  TPlayer = class(TWorldObject)
  private
    FCooldown: Double;
    FPlumeHandler: TPlumeHandler;

    FYSpinV, FYSpin: Single;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Thrust(ThrusterType: TThrusterType; DT: Single);
    function Shoot: TShot;


    procedure Render; override;
    procedure Update(DT: Double); override;

  end;

implementation

uses
  Winapi.Windows, DGLOpenGL,

  LibShared;

{ TPlayer }

function TPlayer.Shoot: TShot;
var
  shotAngle: Single;
begin
  Result := nil;
  if FCooldown <= 0 then begin
    shotAngle := FR + Random * GAME_SHOT_INACCURACY - GAME_SHOT_INACCURACY / 2;
    Result := TShot.Create(FX + Cos(DegTorad(shotAngle)),
                           FY + Sin(DegTorad(shotAngle)),
                           shotAngle,
                           FVX + GAME_SHOT_SPEED * Cos(DegTorad(shotAngle)),
                           FVY + GAME_SHOT_SPEED * Sin(DegTorad(shotAngle)),
                           10);

    FCooldown := GAME_PLAYER_COOLDOWN;
  end;
end;

procedure TPlayer.Thrust(ThrusterType: TThrusterType; DT: Single);
begin
  case ThrusterType of
    ttMain: begin
      FVX := FVX + GAME_PLAYER_THRUST * Cos(DegToRad(FR)) * Cos(DegToRad(FYSpin)) * DT;
      FVY := FVY + GAME_PLAYER_THRUST * Sin(DegToRad(FR)) * Cos(DegToRad(FYSpin)) * DT;

      //Enter.... the THIRD DIMENSION
      FVZ := FVZ + GAME_PLAYER_THRUST * -Sin(DegToRad(FYSpin)) * DT;
    end;
    ttSpinL: FVR := FVR + GAME_PLAYER_THRUST_ROT * DT;
    ttSpinR: FVR := FVR - GAME_PLAYER_THRUST_ROT * DT;
    ttYSpinL: FYSpinV := FYSpinV + GAME_PLAYER_THRUST_ROT * DT * 0.5;
    ttYSpinR: FYSpinV := FYSpinV - GAME_PLAYER_THRUST_ROT * DT * 0.5;
    tt0: begin
      FVX := 0;
      FVY := 0;
      FVZ := 0;
      FVR := 0;
      FR := Round(FR / 90) * 90;
      FYSpin := Round(FYSpin / 90) * 90; FYSpinV := 0;
    end;
  end;
end;

procedure TPlayer.Update(DT: Double);
begin
  inherited;

  FCooldown := FCooldown - DT;

  FPlumeHandler.Update(DT);

  FYSpin := FYSpin + FYSpinV * DT;
end;

constructor TPlayer.Create;
begin
  FPlumeHandler := TPlumeHandler.Create;
end;

destructor TPlayer.Destroy;
begin
  FPlumeHandler.Free;
  inherited;
end;

procedure TPlayer.Render;
begin
  inherited;

  glRotatef(FYSpin, 0, 1, 0);

  glLineWidth(3);

  glBegin(GL_POLYGON);
    glColor3f(0, 0, 0); glVertex3f( 3,  0, 0);
    glColor3f(0, 0, 0); glVertex3f(-1,  2, 0);
    glColor3f(0, 0, 0); glVertex3f( 0,  0, 0);
    glColor3f(0, 0, 0); glVertex3f(-1, -2, 0);
  glEnd;

  glTranslatef(0, 0, 0.1);

  glBegin(GL_LINE_LOOP);
    glColor3f(1, 0, 0);     glVertex3f( 3,  0, 0);
    glColor3f(0, 1, 0);     glVertex3f(-1,  2, 0);
    glColor3f(0, 0.5, 0.5); glVertex3f( 0,  0, 0);
    glColor3f(0, 0, 1);     glVertex3f(-1, -2, 0);
  glEnd;

  FPlumeHandler.Render;

end;

{ TPlumeHandler }

constructor TPlumeHandler.Create;
begin
  FPlumes := TObjectList<TPlume>.Create(True);
  FCooldown := 0;
end;

destructor TPlumeHandler.Destroy;
begin
  FPlumes.Free;
  inherited;
end;

procedure TPlumeHandler.Render;
var
  i: Integer;
begin
  inherited;

  for i := 0 to FPlumes.Count - 1 do begin
    glPushMatrix;
    FPlumes[i].Render;
    glPopMatrix;
  end;
end;

procedure TPlumeHandler.Update(DT: Double);
var
  i: Integer;
  l,r,u:Boolean;
begin
  inherited;
  l := KeyIsPressed(VK_LEFT);
  r := KeyIsPressed(VK_RIGHT);
  u := KeyIsPressed(VK_DOWN);

  if l or r or u then
    FCooldown := FCooldown + DT
  else
    FCooldown := 0.07 - DT;

  if (FCooldown > 0.07) and not (not u and (l and r)) then begin
    FPlumes.Add(TPlume.Create(u or l, u or r));
    FCooldown := 0;
  end;

  for i := FPlumes.Count - 1 downto 0 do begin
    FPlumes[i].Update(DT);
    if FPlumes[i].LifeSpan <= 0 then
      FPlumes.Delete(i);
  end;
end;

{ TPlume }

constructor TPlume.Create(l, r: Boolean);
begin
  left := l;
  right := r;

  FVX := -15;
  LifeSpan := 0.12;

  if l and not r then
    FVY := -10
  else if r and not l then
    FVY := 10
end;

procedure TPlume.Render;
begin
  inherited;

  glBegin(GL_LINES);
    glColor3f(0, 1, 1);

    if left then begin
      glVertex3f(-1.0,  0, 0);
      glVertex3f(-2.0,  2, 0);
    end;

    if right then begin
      glVertex3f(-1.0,  0, 0);
      glVertex3f(-2.0, -2, 0);
    end;
  glEnd;
end;

procedure TPlume.Update(DT: Double);
begin
  inherited;

  LifeSpan := LifeSpan - DT;
end;

end.

