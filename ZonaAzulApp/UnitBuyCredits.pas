unit UnitBuyCredits;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.Objects;

type
  TFrameBuyCredits = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Layout3: TLayout;
    Label2: TLabel;
    Layout5: TLayout;
    Label8: TLabel;
    lblCreditsAvailable: TLabel;
    Layout4: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Layout6: TLayout;
    Label6: TLabel;
    Layout7: TLayout;
    comboBoxCreditCard: TComboBox;
    buttonBuy: TSpeedButton;
    buttonAddCredits: TSpeedButton;
    buttonRemoveCredits: TSpeedButton;
    buttonCadastreCreditCard: TSpeedButton;
    procedure buttonCadastreCreditCardClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrameBuyCredits: TFrameBuyCredits;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitCadastreCreditCard, UnitRoutines;

procedure TFrameBuyCredits.buttonCadastreCreditCardClick(Sender: TObject);
begin
  //Abre o formulário de cadastro de cartão.
  UnitRoutines.Show(TFormCadastreCreditCard.Create(Self));
end;

end.
