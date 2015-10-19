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
    procedure buttonSaveClick(Sender: TObject);
    procedure editNameKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure editNumberChange(Sender: TObject);
  private
    { Private declarations }
    procedure ValidateValuesComponents;
  public
    { Public declarations }
  end;

var
  FormCadastreCreditCard: TFormCadastreCreditCard;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitRoutines;

procedure TFormCadastreCreditCard.buttonSaveClick(Sender: TObject);
begin
  //Valida os valores dos campos.
  ValidateValuesComponents;
end;

procedure TFormCadastreCreditCard.editCSCChange(Sender: TObject);
begin
  //Permite apenas números no campo editNumber.
  editCSC.Text := GetJustNumbersOfString(editCSC.Text);
end;

procedure TFormCadastreCreditCard.editNameChange(Sender: TObject);
begin
  SetTextUpperCaseEditChange(Sender);
end;

procedure TFormCadastreCreditCard.editNameKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  AllowJustLettersEditKeyDown(Sender, Key, KeyChar, Shift);
end;

procedure TFormCadastreCreditCard.editNumberChange(Sender: TObject);
begin
  //Permite apenas números no campo editNumber.
  editNumber.Text := GetJustNumbersOfString(editNumber.Text);
end;

procedure TFormCadastreCreditCard.ValidateValuesComponents;
begin
  //Valida os valores de todos os campos.
  Focused := nil;
  editNumber.Text := GetJustNumbersOfString(editNumber.Text);
  editCSC.Text    := GetJustNumbersOfString(editCSC.Text);
  ValidateValueComponent(editName, editName.Text, 'Informe o nome impresso no cartão!');
  ValidateValueComponent(editNumber, editNumber.Text, 'Informe o número do cartão!', 16);
  ValidateValueComponent(editCSC, editCSC.Text, 'Informe o código de segurança!', 3);
end;

end.
