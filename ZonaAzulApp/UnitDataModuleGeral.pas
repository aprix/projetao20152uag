unit UnitDataModuleGeral;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, Data.DB,
  Datasnap.DBClient, DateUtils, System.UITypes, FMX.Forms, System.ImageList,
  FMX.ImgList, Data.FMTBcd, Data.SqlExpr, System.iOUtils, Data.DbxSqlite,
  Datasnap.Provider, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, DBXJSON, System.JSON;

type
  IPaymentListener = interface
     procedure OnAfterPayment;
  end;

  TDataModuleGeral = class(TDataModule)
    CustomStyleBook: TStyleBook;
    ClientWebService: TRESTClient;
    RequestGetPayment: TRESTRequest;
    ResponseGetPayment: TRESTResponse;
    RequestPostPayment: TRESTRequest;
    ResponsePostPayment: TRESTResponse;
  private
    { Private declarations }
    function PostPayment(Plate: String;
                          Time: Integer;
                          FlagCreditCard: String;
                          NameCreditCard: String;
                          NumberCreditCard: String;
                          MonthCreditCard: Integer;
                          YearCreditCard: Integer;
                          CSCCredCard: Integer): TDateTime;
  public
    { Public declarations }

    function ConsultPayment(Plate: String; var DayTime, DeadlineTime: TDateTime): Boolean;

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

function TDataModuleGeral.ConsultPayment(Plate: String; var DayTime, DeadlineTime: TDateTime): Boolean;
var
Json: TJSONObject;
begin
  //Consulta no servidor o pagamento do estacionamento referente à placa passada como argumento.
  RequestGetPayment.Params.ParameterByName('json').Value := '{"Plate":"'+Plate+'"}';
  RequestGetPayment.Execute;

  //Pega o registro JSON retornado pela consulta.
  Json := (TJSONObject.ParseJSONValue(RequestGetPayment.Response.Content) as TJSONObject);

  //Se o json não tiver um par de chave "error", significa que a consulta foi realizada com sucesso.
  if (Json.Values['error'] = nil) then
  begin
    //Pega a data de início e a data de limite do pagamento retornado pelo webservice.
    DayTime      := StrToDateTime(Json.GetValue('InitialDate').Value);
    DeadlineTime := StrToDateTime(Json.GetValue('FinalDate').Value);

    //Retorna como resultado o valor true.
    Result := True;
  end
  else
  begin
    //Verifica se a mensagem retornada é "sem pagamento".
    if (Json.GetValue('error').Value.Contains('pagamento')) then
    begin
      //Retorna como resultado falso.
      Result := False;
    end
    else
    begin
      //Neste caso, levanta uma exceção com a mensagem do erro.
      raise Exception.Create(Json.GetValue('error').Value);
    end;
  end;
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

function TDataModuleGeral.postPayment(Plate: String;
  Time: Integer; FlagCreditCard, NameCreditCard,
  NumberCreditCard: String; MonthCreditCard, YearCreditCard,
  CSCCredCard: Integer): TDateTime;
var
Json: TJSONObject;
JsonResponse: TJSONObject;
begin
  //Constroi o JSON contendo os parâmetros para serem enviados ao webservice.
  Json := TJSONObject.Create;
  Json.AddPair('Plate', TJSONString.Create(Plate));
  Json.AddPair('Time', TJSONNumber.Create(Time));
  Json.AddPair('FlagCreditCard', TJSONString.Create(FlagCreditCard));
  Json.AddPair('NameCreditCard', TJSONString.Create(NameCreditCard));
  Json.AddPair('NumberCreditCard', TJSONString.Create(NumberCreditCard));
  Json.AddPair('MonthCreditCard', TJSONNumber.Create(MonthCreditCard));
  Json.AddPair('YearCreditCard', TJSONNumber.Create(YearCreditCard));
  Json.AddPair('CSCCredCard', TJSONNumber.Create(CSCCredCard));

  //Envia a requisição POST para o pagamento.
  RequestPostPayment.Params.ParameterByName('json').Value := Json.ToString;
  RequestPostPayment.Execute;

  //Pega a resposta do webservice.
  JsonResponse := (TJSONObject.ParseJSONValue(RequestPostPayment.Response.Content) as TJSONObject);

  //Se o json com a resposta contém o par de chave "Sucess", significa que o pagamento foi realizado com sucesso.
  if (JsonResponse.Values['Sucess'] <> nil) then
  begin
    //Retorna a data do tíquete atribuída pelo servidor.
    Result := StrToDateTime(JsonResponse.GetValue('Sucess').Value);
  end
  else
  begin
    //Levanta uma exceção com o erro retornado na resposta do webservice.
    raise Exception.Create(JsonResponse.GetValue('Error').Value);
  end;
end;

procedure TDataModuleGeral.sendPayment(Plate: String; Time: Integer; PaymentListener: IPaymentListener);
var
StartTime: TDateTime;
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
                          StartTime:= postPayment(
                                          Plate
                                         ,Time
                                         ,FormCreditCardSeparate.cboFlag.Selected.Text
                                         ,FormCreditCardSeparate.editName.Text
                                         ,FormCreditCardSeparate.editNumber.Text.Replace('-','')
                                         ,StrToInt(FormCreditCardSeparate.cboMonth.Selected.Text)
                                         ,StrToInt(FormCreditCardSeparate.cboYear.Selected.Text)
                                         ,StrToInt(FormCreditCardSeparate.editCSC.Text)
                                      );

                          //Insere o novo tíquete na base local.
                          DataModuleLocal.InsertTicketLocal(Plate, StartTime, Time);

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
