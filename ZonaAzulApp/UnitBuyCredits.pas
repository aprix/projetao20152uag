unit UnitBuyCredits;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.Objects,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope;

type
  IBuyListener = interface
    procedure OnSucess;
  end;

type
  TFrameBuyCredits = class(TFrame)
    LayoutPrincipal: TLayout;
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
    procedure BuyCredits;

    var
    Value: Double;
    BuyListener: IBuyListener;
  public
    { Public declarations }
    procedure UpdateComponents(IsClearValue: Boolean = True);
    procedure BeginComponents(IsClearValue: Boolean = True);
    procedure SetCreditsForBuy(Value: Double);
    procedure SetBuyListener(BuyListener: IBuyListener);
  end;

var
  FrameBuyCredits: TFrameBuyCredits;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitCadastreCreditCard, UnitRoutines;

procedure TFrameBuyCredits.BeginComponents(IsClearValue: Boolean);
begin
  //Executa a inicialização dos componentes em outra thread.
  ExecuteAsync(LayoutPrincipal
              ,procedure
               begin
                  //Atualiza os campos da tela.
                  UpdateComponents(IsClearValue);
               end
              );
end;

procedure TFrameBuyCredits.ButtonAddCreditsClick(Sender: TObject);
begin
  //Incrementa um real ao valor de crédito a ser comprado.
  Value := Value + 1;

  //Atualiza os labels.
  UpdateValuesLabels;
end;

procedure TFrameBuyCredits.ButtonBuyClick(Sender: TObject);
begin
  //Valida os valores do campos.
  ValidateValuesComponents;

  //Envia a compra de créditos em uma Thread paralela.
  ExecuteAsync(LayoutPrincipal
   ,procedure
    begin
      //Realiza a compra de créditos.
      BuyCredits;
    end);
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

procedure TFrameBuyCredits.BuyCredits;
begin
  try
    //Envia a compra de créditos ao WebService.
    DataModuleGeral.SendBuyCredits(DataModuleGeral.GetIdCreditCardSelected
                                  ,StrToInt(EditCSC.Text)
                                  ,Value);

    //Executa a atualização da interface na Thread principal.
    TThread.Synchronize(nil
     ,procedure
      begin
        //Atualiza os campos da tela.
        UpdateComponents;

        //Exibe uma mensagem de sucesso.
        ShowMessage(Format('Sua compra foi finalizada com sucesso.'+#13+'Seus Créditos: %s'
                          ,[FormatFloat(',0.00', DataModuleGeral.GetCreditsUser)]));

        //Verifica se existe um objeto ouvinte de eventos de compra.
        if (BuyListener <> nil) then
        begin
          //Executa o procedimento de sucesso do objeto ouvinte de eventos de compra.
          BuyListener.OnSucess;
        end;
      end);
  except
    on Error: Exception do
    begin
      //Levanta uma exceção com o erro.
      raise Exception.Create(Error.Message);
    end;
  end;
end;

procedure TFrameBuyCredits.UpdateComponents(IsClearValue: Boolean);
begin
  try
    //Verifica se é para limpar o valor.
    if (IsClearValue) then
    begin
      //Restaura o valor inicial de crédito para novas compras.
      Value := 1;
    end;

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

  //Executa a atualização dos campos na Thread principal.
  TThread.Synchronize(
       nil
       , procedure
         begin
          //Atualiza os valores dos labels.
          UpdateValuesLabels;
         end
  );

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

procedure TFrameBuyCredits.SetBuyListener(BuyListener: IBuyListener);
begin
  Self.BuyListener := BuyListener;
end;

procedure TFrameBuyCredits.SetCreditsForBuy(Value: Double);
begin
  //Atribui ao atributo Value a quantidade de créditos a ser adquirida.
  Self.Value := Value;

  //Atualiza os valores dos labels.
  UpdateValuesLabels;
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
