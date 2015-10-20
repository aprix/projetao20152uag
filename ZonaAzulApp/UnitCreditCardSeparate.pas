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
  //Chama o procedimento herdado da superclasse.
  inherited;

  //Retorna como resultado mrOK.
  ModalResult := mrOk;
end;

end.
