unit UnitBuyCredits;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.Objects,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope;

type
  TFrameBuyCredits = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Layout3: TLayout;
    Label2: TLabel;
    Layout5: TLayout;
    Label8: TLabel;
    LabelCreditsAvailable: TLabel;
    Layout4: TLayout;
    Label4: TLabel;
    LabelTotal: TLabel;
    Layout6: TLayout;
    LabelValue: TLabel;
    Layout7: TLayout;
    ComboBoxCreditCard: TComboBox;
    ButtonBuy: TSpeedButton;
    ButtonAddCredits: TSpeedButton;
    ButtonRemoveCredits: TSpeedButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Layout8: TLayout;
    Label3: TLabel;
    EditCSC: TEdit;
    procedure ComboBoxCreditCardClick(Sender: TObject);
    procedure ButtonAddCreditsClick(Sender: TObject);
    procedure ButtonRemoveCreditsClick(Sender: TObject);
    procedure ButtonBuyClick(Sender: TObject);
    procedure EditCSCChange(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateValuesLabels;
    procedure ValidateValuesComponents;

    var
    Value: Double;
  public
    { Public declarations }
    procedure ClearComponents;
  end;

var
  FrameBuyCredits: TFrameBuyCredits;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitCadastreCreditCard, UnitRoutines;

procedure TFrameBuyCredits.ButtonAddCreditsClick(Sender: TObject);
begin
  //Incrementa um real ao valor de crédito a ser comprado.
  Value := Value + 1;

  //Atualiza os labels.
  UpdateValuesLabels;
end;

procedure TFrameBuyCredits.ButtonBuyClick(Sender: TObject);
begin
  try
    //Valida os valores do campos.
    ValidateValuesComponents;

    //Envia a compra de créditos ao WebService.
    DataModuleGeral.SendBuyCredits(DataModuleGeral.GetIdCreditCardSelected
                                  ,StrToInt(EditCSC.Text)
                                  ,Value);

    //Limpa os campos da tela.
    ClearComponents;

    //Exibe uma mensagem de sucesso.
    ShowMessage(Format('Sua compra foi finalizada com sucesso.'+#13+'Seus Créditos: %s'
                      ,[FormatFloat(',0.00', DataModuleGeral.GetCreditsUser)]));
  except
    on Error: Exception do
    begin
      //Levanta uma exceção com o erro.
      raise Exception.Create(Error.Message);
    end;
  end;
end;

procedure TFrameBuyCredits.ButtonRemoveCreditsClick(Sender: TObject);
begin
  //Decrementa um real do valor de crédito a ser comprado.
  Value := Value - 1;

  //Verifica se o valor de crédito é negativo, caso seja, atribui como padrão zero.
  if (Value < 0) then
    Value := 0;

  //Atualiza os labels.
  UpdateValuesLabels;
end;

procedure TFrameBuyCredits.ClearComponents;
begin
  try
    //Restaura o valor inicial de crédito para novas compras.
    Value := 1;

    //Limpa o campo de CSC do cartão de crédito.
    //EditCSC.Text := '';

    //Atualiza a consulta de cartões de créditos.
    DataModuleGeral.OpenQueryCreditCards;

    //Atualiza a consulta do crédito do usuário no servidor.
    DataModuleGeral.OpenQueryCreditsUser;
  except
    on Error: Exception do
    begin
      //Exibe a mensagem do erro.
      ShowMessage(Error.Message);
    end;
  end;

  //Atualiza os valores dos labels.
  UpdateValuesLabels;
end;

procedure TFrameBuyCredits.ComboBoxCreditCardClick(Sender: TObject);
begin
  //Se não existir cartão de crédito cadastrado.
  if (DataModuleGeral.DataSetCreditCards.IsEmpty) then
  begin
    //Abre o formulário de cadastro de cartão.
    UnitRoutines.Show(TFormCadastreCreditCard.Create(Self));
  end;
end;

procedure TFrameBuyCredits.EditCSCChange(Sender: TObject);
begin
  //Permite apenas números no campo de CSC.
  EditCSC.Text := UnitRoutines.GetJustNumbersOfString(EditCSC.Text);
end;

procedure TFrameBuyCredits.UpdateValuesLabels;
begin
  //Atualiza os valores dos labels de créditos.
  LabelCreditsAvailable.Text := 'R$ '+FormatFloat(',0.00', DataModuleGeral.GetCreditsUser);
  LabelTotal.Text := 'R$ '+FormatFloat(',0.00', DataModuleGeral.GetCreditsUser + Value);
  LabelValue.Text := 'R$ '+FormatFloat(',0.00', Value);
end;

procedure TFrameBuyCredits.ValidateValuesComponents;
begin
  //Valida os valores de todos os componentes da tela.
  EditCSC.Text := UnitRoutines.GetJustNumbersOfString(EditCSC.Text);
  UnitRoutines.ValidateValueComponent(EditCSC, EditCSC.Text, 'Informe o CSC do cartão!', 3);

  //Confirma se o usuário não selecionou um cartão de crédito.
  if (DataModuleGeral.DataSetCreditCards.IsEmpty) then
  begin
    raise Exception.Create('Informe o cartão de crédito!');
  end;
end;

end.
