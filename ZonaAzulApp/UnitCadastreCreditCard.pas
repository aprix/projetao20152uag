unit UnitCadastreCreditCard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit, FMX.ListBox;

type
  TFormCadastreCreditCard = class(TForm)
    Layout1: TLayout;
    MasterToolBar: TToolBar;
    Rectangle1: TRectangle;
    Label3: TLabel;
    Layout3: TLayout;
    Label2: TLabel;
    Layout2: TLayout;
    Label1: TLabel;
    editName: TEdit;
    cboFlag: TComboBox;
    Layout4: TLayout;
    Layout5: TLayout;
    Label4: TLabel;
    cboMonth: TComboBox;
    cboYear: TComboBox;
    Layout6: TLayout;
    Label5: TLabel;
    editCSC: TEdit;
    buttonSave: TSpeedButton;
    Layout7: TLayout;
    Label6: TLabel;
    editNumber: TEdit;
    procedure editNameChange(Sender: TObject);
    procedure editCSCChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCadastreCreditCard: TFormCadastreCreditCard;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitRoutines;

procedure TFormCadastreCreditCard.editCSCChange(Sender: TObject);
begin
  //Permite apenas números no campo editNumber.
  editCSC.Text := GetJustNumbersOfString(editCSC.Text);
end;

procedure TFormCadastreCreditCard.editNameChange(Sender: TObject);
begin
  UnitRoutines.SetTextUpperCaseEditChange(Sender);
end;

end.
