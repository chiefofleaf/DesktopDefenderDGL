unit LibMaterial;

interface

uses
  LibRenderableObject;

type
  TMaterialType = (mtIce, mtIron, mtGold, mtDiamond, mtIridium);

  TMaterial = class (TWorldObject)
  private
    FMaterialType: TMaterialType;
  public
    property MaterialType: TMaterialType read FMaterialType;

    procedure Render; override;

    constructor Create(AMaterialType: TMaterialType);
  end;

  TMaterialArray = array of TMaterial;

implementation

uses
  DGLOpenGL;

{ TMaterial }

constructor TMaterial.Create(AMaterialType: TMaterialType);
begin
  FMaterialType := AMaterialType;
  FVR := 100;
  FZ := 1;
end;

procedure TMaterial.Render;
begin
  inherited;

  case FMaterialType of
    mtIce: begin
      glBegin(GL_LINE_LOOP);
      //light blue
      glColor3f(0.8, 1, 1);

      //cube shape
      glVertex2f( 1, 1);
      glVertex2f( 1,-1);
      glVertex2f(-1,-1);
      glVertex2f(-1, 1);
      glEnd;
    end;

    mtIron: begin
      glBegin(GL_LINE_LOOP);
      //dark red
      glColor3f(0.8, 0, 0);

      //ore nugget shape
      glVertex2f( 1  ,  0  );
      glVertex2f( 1.2, -1.7);
      glVertex2f(-0.5, -1.5);
      glVertex2f(-2  ,  1  );
      glVertex2f( 0  ,  0.5);
      glVertex2f( 1.5,  2  );
      glVertex2f( 1.8,  1  );
      glEnd;
    end;

    mtGold: begin
      glBegin(GL_LINE_LOOP);
      //yellow
      glColor3f(1, 1, 0);

      glVertex2f( 1  , -0  );
      glVertex2f( 1.2,  1.7);
      glVertex2f(-0.5,  1.5);
      glVertex2f(-2  , -1  );
      glVertex2f( 0  , -0.5);
      glVertex2f( 1.5, -2  );
      glVertex2f( 1.8, -1  );
      glEnd;
    end;

    mtDiamond: begin
      glBegin(GL_LINE_LOOP);
      //cyan
      glColor3f(0, 1, 1);

      //cut diamond shape
      glVertex2f( 0.75, 1.25);
      glVertex2f( 1.25, 0.75);
      glVertex2f( 1.25, 0   );
      glVertex2f( 0   , -1.5);
      glVertex2f(-1.25, 0   );
      glVertex2f(-1.25, 0.75);
      glVertex2f(-0.75, 1.25);
      glEnd;
    end;

    mtIridium: begin
      glBegin(GL_LINE_LOOP);
      //violet
      glColor3f(1, 0, 1);

      //cube with lines
      //cube shape
      glVertex2f( 1, 1);
      glVertex2f( 1,-1);
      glVertex2f(-1,-1);
      glVertex2f(-1, 1);
      glEnd;


      glBegin(GL_LINES);
      glVertex2f( 1, 0);
      glVertex2f( 0.5, 0);

      glVertex2f( 0,-1);
      glVertex2f( 0,-0.5);

      glVertex2f(-1, 0);
      glVertex2f(-0.5, 0);

      glVertex2f( 0, 1);
      glVertex2f( 0, 0.5);
      glEnd;
    end;
  end;
end;

end.
