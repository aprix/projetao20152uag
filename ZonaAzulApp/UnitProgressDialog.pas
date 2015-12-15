unit UnitProgressDialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls;

type
  TFrameProgressDialog = class(TFrame)
    ProgressIndicator: TAniIndicator;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure StopAnimation;
    procedure StartAnimation;
  end;

implementation

{$R *.fmx}

{ TFrameProgressDialog }

procedure TFrameProgressDialog.StartAnimation;
begin
  ProgressIndicator.Enabled := True;
  Visible := True;
end;

procedure TFrameProgressDialog.StopAnimation;
begin
  ProgressIndicator.Enabled := False;
  Parent  := nil;
  Visible := False;
end;

end.
