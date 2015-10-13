unit UnitConsultPayments;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit;

type
  TFrameConsultPayments = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Layout8: TLayout;
    editPlateLetters: TEdit;
    Label2: TLabel;
    editPlateNumbers: TEdit;
    Layout3: TLayout;
    Label4: TLabel;
    buttonActiveTickets: TSpeedButton;
    Rectangle2: TRectangle;
    Layout4: TLayout;
    Label6: TLabel;
    Label5: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrameConsultPayments: TFrameConsultPayments;

implementation

{$R *.fmx}

uses UnitDataModuleGeral;

end.
