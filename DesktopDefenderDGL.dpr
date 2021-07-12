program DesktopDefenderDGL;

uses
  Vcl.Forms,
  DGLOpenGL in '..\DGL\DGLOpenGL.pas',
  FoMain in 'src\form\FoMain.pas' {fmMain},
  LibGame in 'src\lib\LibGame.pas',
  LibShared in 'src\lib\LibShared.pas',
  LibCamera2D in 'src\lib\LibCamera2D.pas',
  LibRenderableObject in 'src\lib\objects\LibRenderableObject.pas',
  LibPlayer in 'src\lib\objects\LibPlayer.pas',
  LibObjectHandler in 'src\lib\objects\LibObjectHandler.pas',
  LibShot in 'src\lib\objects\LibShot.pas',
  LibAsteroid in 'src\lib\objects\LibAsteroid.pas',
  LibMaterial in 'src\lib\objects\LibMaterial.pas',
  LibDestroyableObject in 'src\lib\objects\LibDestroyableObject.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
