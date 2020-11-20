program DesktopDefenderDGL;

uses
  Vcl.Forms,
  FoMain in 'FoMain.pas' {fmMain},
  DGLOpenGL in '..\DGL\DGLOpenGL.pas',
  LibShared in 'LibShared.pas',
  LibGame in 'LibGame.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
