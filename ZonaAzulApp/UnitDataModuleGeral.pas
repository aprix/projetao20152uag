unit UnitDataModuleGeral;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, Data.DB,
  Datasnap.DBClient, DateUtils, System.UITypes, FMX.Forms, System.ImageList,
  FMX.ImgList, Data.FMTBcd, Data.SqlExpr, System.iOUtils, Data.DbxSqlite,
  Datasnap.Provider;

type
  IPaymentListener = interface
     procedure OnAfterPayment;
  end;

  TDataModuleGeral = class(TDataModule)
    CustomStyleBook: TStyleBook;
  private
    { Private declarations }
    procedure PostPayment(Plate: String;
                          Time: Integer;
                          FlagCreditCard: String;
                          NameCreditCard: String;
                          NumberCreditCard: String;
                          MonthCreditCard: Integer;
                          YearCreditCard: Integer;
                          CSCCredCard: Integer);
  public
    { Public declarations }

    function ConsultPayment(Plate: String; var DayTime: TDateTime; var Time: Integer): Boolean;

    procedure sendPayment(Plate: String; Time: Integer; PaymentListener: IPaymentListener);

    function IsUserLogged: Boolean;

    function GetCreditsUser: Double;

    function GetMaxTime: Integer;

    function GetMinTime: Integer;

    function GetUnitTime: Integer;

    function GetPriceTime: Double;

    function GetDiscountPrice: Double;

    function GetLastPlate: String;
  end;

var
  DataModuleGeral: TDataModuleGeral;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses UnitCreditCardSeparate, UnitBuyCredits, UnitTickets, UnitDataModuleLocal;

{$R *.dfm}

function TDataModuleGeral.GetDiscountPrice: Double;
begin
  Result := 0;
end;

function TDataModuleGeral.GetLastPlate: String;
begin
  //Carrega da base local a última placa usada.
  Result := DataModuleLocal.DataSetTickets.FieldByName('Plate').AsString;
end;

function TDataModuleGeral.ConsultPayment(Plate: String; var DayTime: TDateTime; var Time: Integer): Boolean;
begin
  //Consulta no servidor o pagamento do estacionamento referente à placa passada como argumento.
  DayTime := now;
  Time    := 30;
  Result := True;
end;

function TDataModuleGeral.GetCreditsUser: Double;
begin
  //Retorna valor default para os testes. Não está implementado o cadastro do usuário.
  Result := 0;
end;

function TDataModuleGeral.IsUserLogged: Boolean;
begin
  //Retorna false para os testes. Não está implementado o cadastro do usuário.
  Result := False;
end;

function TDataModuleGeral.GetMaxTime: Integer;
begin
  Result := 120;
end;

function TDataModuleGeral.GetMinTime: Integer;
begin
  Result := 10;
end;

function TDataModuleGeral.GetPriceTime: Double;
begin
  Result := 1;
end;

procedure TDataModuleGeral.postPayment(Plate: String;
  Time: Integer; FlagCreditCard, NameCreditCard,
  NumberCreditCard: String; MonthCreditCard, YearCreditCard,
  CSCCredCard: Integer);
begin
  //Método sem corpo, falta implementar o Webservice.
end;

procedure TDataModuleGeral.sendPayment(Plate: String; Time: Integer; PaymentListener: IPaymentListener);
begin
  //Verifica se não existe usuário logado. Ou seja, pagamento avulso.
  if not(IsUserLogged) then
  begin
    //Exibe o formulário de cartão de crédito avulso.
    FormCreditCardSeparate := TFormCreditCardSeparate.Create(Self);
    FormCreditCardSeparate
          .ShowModal(procedure(ModalResult: TModalResult)
                     begin
                        //Oculta o formulário.
                        FormCreditCardSeparate.Hide;

                        //Verifica se o usuário confirmou a operação.
                        if (ModalResult = mrOk) then
                        begin
                          //Envia ao servidor a requisição HTTP Post do pagamento.
                          postPayment(Plate
                                     ,Time
                                     ,FormCreditCardSeparate.cboFlag.Selected.Text
                                     ,FormCreditCardSeparate.editName.Text
                                     ,FormCreditCardSeparate.editNumber.Text.Replace('-','')
                                     ,StrToInt(FormCreditCardSeparate.cboMonth.Selected.Text)
                                     ,StrToInt(FormCreditCardSeparate.cboYear.Selected.Text)
                                     ,StrToInt(FormCreditCardSeparate.editCSC.Text)
                                     );

                          //Insere o novo tíquete na base local.
                          DataModuleLocal.InsertTicketLocal(Plate, Now, Time);

                          //Chama o procedimento do ouvinte de pagamento.
                          PaymentListener.OnAfterPayment;
                        end;

                        //Dispensa(elimina) o formulário.
                        //FormCreditCardSeparate.DisposeOf();
                     end);
  end;
end;

function TDataModuleGeral.GetUnitTime: Integer;
begin
  Result := 10;
end;

end.
