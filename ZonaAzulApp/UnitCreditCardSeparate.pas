unit UnitCreditCardSeparate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitCadastreCreditCard, FMX.Edit, FMX.ListBox, FMX.Objects,
  FMX.Controls.Presentation, FMX.Layouts, System.ImageList, FMX.ImgList;

type
  TOnConfirm = reference to procedure;

type
  TFormCreditCardSeparate = class(TFormCadastreCreditCard)
    LayoutCSC: TLayout;
    Label5: TLabel;
    EditCSC: TEdit;
    procedure buttonSaveClick(Sender: TObject);
    procedure EditCSCChange(Sender: TObject);
  private
    { Private declarations }
    var
    OnConfirm: TOnConfirm;
  protected
    { Protected declarations}
    procedure ValidateValuesComponents; override;
  public
    { Public declarations }
    function GetCSC(): Integer;
    function GetLayoutPrincipal: TLayout;
    constructor Create(AWoner: TComponent; OnConfirm: TOnConfirm); reintroduce;
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

  //Executa o procedimento de confirmação.
  OnConfirm;
end;

constructor TFormCreditCardSeparate.Create(AWoner: TComponent;
  OnConfirm: TOnConfirm);
begin
  //Executa o construtor herdado da superclasse.
  inherited Create(AWoner);

  //Atribui ao atributo OnConfirm a referência do procedimento passado como argumento.
  Self.OnConfirm := OnConfirm;
end;

procedure TFormCreditCardSeparate.EditCSCChange(Sender: TObject);
begin
  //Permite apenas números no campo editNumber.
  editCSC.Text := GetJustNumbersOfString(editCSC.Text);
end;

function TFormCreditCardSeparate.GetCSC: Integer;
begin
  Result := StrToInt(EditCSC.Text);
end;

function TFormCreditCardSeparate.GetLayoutPrincipal: TLayout;
begin
  Result := LayoutPrincipal;
end;

procedure TFormCreditCardSeparate.ValidateValuesComponents;
begin
  inherited;

  EditCSC.Text    := GetJustNumbersOfString(editCSC.Text);
  ValidateValueComponent(EditCSC, editCSC.Text, 'Informe o código de segurança!', 3);
end;

end.
