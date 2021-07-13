unit FoMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  LibGame, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    tmFPS: TTimer;
    pnMain: TPanel;
    pnGUI: TPanel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
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

uses
  LibShared;

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TransparentColor := DISPLAY_TRANSPARENT;
  TransparentColorValue := DISPLAY_TRANSPARENT_COLOR;

  FGame := TGame.Create(pnMain.Handle);
  Application.OnIdle := FGame.GameLoop;
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
    VK_F11: begin
      if WindowState <> wsMaximized then begin
        BorderStyle := bsNone;
        WindowState := wsMaximized;
      end else begin
        WindowState := wsNormal;
        BorderStyle := bsSizeable;
      end;
    end;
    VK_F1: begin
      pnGUI.Visible := not pnGUI.Visible;
    end;
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

