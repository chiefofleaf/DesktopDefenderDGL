unit FoMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  LibGame, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    tmFPS: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmFPSTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FGame: TGame;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FGame := TGame.Create(Handle);
  Application.OnIdle := FGame.IdleHandler;
  FGame.Start;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FGame.Free;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Application.Terminate;
  end;
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
  FGame.Resize(ClientWidth, ClientHeight);
end;

procedure TfmMain.tmFPSTimer(Sender: TObject);
begin
  Caption := Format('FPS: %d', [FGame.FPS]);
end;

end.

