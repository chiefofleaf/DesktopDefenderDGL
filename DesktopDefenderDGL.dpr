program DesktopDefenderDGL;

uses
  Vcl.Forms,
  DGLOpenGL in '..\DGL\DGLOpenGL.pas',
  FoMain in 'src\form\FoMain.pas' {fmMain},
  LibGame in 'src\lib\LibGame.pas',
  LibShared in 'src\lib\LibShared.pas',
  LibCamera2D in 'src\lib\LibCamera2D.pas',
  LibRenderableObject in 'src\lib\objects\LibRenderableObject.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
