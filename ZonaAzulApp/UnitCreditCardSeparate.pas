unit UnitCreditCardSeparate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitCadastreCreditCard, FMX.Edit, FMX.ListBox, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TFormCreditCardSeparate = class(TFormCadastreCreditCard)
    LayoutCSC: TLayout;
    Label5: TLabel;
    EditCSC: TEdit;
    procedure buttonSaveClick(Sender: TObject);
    procedure EditCSCChange(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations}
    procedure ValidateValuesComponents; override;
  public
    { Public declarations }
  end;

var
  FormCreditCardSeparate: TFormCreditCardSeparate;

implementation

{$R *.fmx}

uses UnitRoutines, UnitDataModuleGeral;

procedure TFormCreditCardSeparate.buttonSaveClick(Sender: TObject);
begin
  //Valida os valores dos campos.
  ValidateValuesComponents();

  //Retorna como resultado mrOK.
  ModalResult := mrOk;
end;

procedure TFormCreditCardSeparate.EditCSCChange(Sender: TObject);
begin
  //Permite apenas números no campo editNumber.
  editCSC.Text := GetJustNumbersOfString(editCSC.Text);
end;

procedure TFormCreditCardSeparate.ValidateValuesComponents;
begin
  inherited;

  EditCSC.Text    := GetJustNumbersOfString(editCSC.Text);
  ValidateValueComponent(EditCSC, editCSC.Text, 'Informe o código de segurança!', 3);
end;

end.
