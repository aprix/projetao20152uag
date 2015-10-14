unit UnitCreditCardSeparate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitCadastreCreditCard, FMX.Edit, FMX.ListBox, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TFormCreditCardSeparate = class(TFormCadastreCreditCard)
    procedure buttonSaveClick(Sender: TObject);
  private
    { Private declarations }
    procedure ValidateValuesComponents;
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
  inherited;

  //Valida os valores dos campos.
  ValidateValuesComponents;

  //Retorna como resultado mrOK.
  ModalResult := mrOk;
end;

procedure TFormCreditCardSeparate.ValidateValuesComponents;
begin
  //Valida os valores de todos os campos.
  ValidateValueComponent(editName, editName.Text, 'Informe o nome impresso no cartão!');
  ValidateValueComponent(editNumber, editNumber.Text, 'Informe o número do cartão!', 16);
  ValidateValueComponent(editCSC, editCSC.Text, 'Informe o código de segurança!', 3);
end;

end.
