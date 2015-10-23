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
     procedure OnSucess;
     procedure OnError(Msg: String);
  end;

  TDataModuleGeral = class(TDataModule)
    CustomStyleBook: TStyleBook;
    ClientWebService: TRESTClient;
    RequestGetPayment: TRESTRequest;
    ResponseGetPayment: TRESTResponse;
    RequestPostPayment: TRESTRequest;
    ResponsePostPayment: TRESTResponse;
    RequestPostUser: TRESTRequest;
    ResponsePostUser: TRESTResponse;
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

    function PostUser(Id: Integer; Nickname, Email, CPF, Password: String): Integer;
  public
    { Public declarations }

    function ConsultPayment(Plate: String; var DayTime, DeadlineTime: TDateTime): Boolean;

    procedure SendPayment(Plate: String; Time: Integer; PaymentListener: IPaymentListener);

    procedure SendPaymentSeparate(Plate: String; Time: Integer; PaymentListener: IPaymentListener);

    procedure SendPaymentByCredit(Plate: String; Time: Integer; PaymentListener: IPaymentListener);

    procedure SendUser(Nickname, Email, CPF, Password: String);

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

uses UnitCreditCardSeparate, UnitBuyCredits, UnitTickets, UnitDataModuleLocal,
  UnitRoutines;

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
Error: String;
begin
  //Consulta no servidor o pagamento do estacionamento referente à placa passada como argumento.
  RequestGetPayment.Params.ParameterByName('json').Value := '{"Plate":"'+Plate+'"}';
  RequestGetPayment.Execute;

  //Pega o registro JSON retornado pela consulta.
  Json := (TJSONObject.ParseJSONValue(RequestGetPayment.Response.Content) as TJSONObject);

  //Se o json não tiver um par de chave "error", significa que a consulta foi realizada com sucesso.
  if (Json.Values['Error'] = nil) then
  begin
    //Pega a data de início e a data de limite do pagamento retornado pelo webservice.
    DayTime      := StrToDateTimeFromWebService(Json.GetValue('DateBegin').Value);
    DeadlineTime := StrToDateTimeFromWebService(Json.GetValue('DeadlineTime').Value);

    //Retorna como resultado o valor true.
    Result := True;
  end
  else
  begin
    //Verifica se a mensagem retornada é "sem pagamento".
    Error := Json.GetValue('Error').Value;
    if (Error.Contains('Veiculo nao estacionado')) then
    begin
      //Retorna como resultado falso.
      Result := False;
    end
    else
    begin
      //Neste caso, levanta uma exceção com a mensagem do erro.
      raise Exception.Create(Error);
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
  //Se a consulta do usuário na base local não for vazia, significa que existe um usuário logado.
  Result := not (DataModuleLocal.DataSetUser.IsEmpty);
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

function TDataModuleGeral.PostPayment(Plate: String;
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
    Result := StrToDateTimeFromWebService(JsonResponse.GetValue('Sucess').Value);
  end
  else
  begin
    //Levanta uma exceção com o erro retornado na resposta do webservice.
    raise Exception.Create(JsonResponse.GetValue('Error').Value);
  end;
end;

function TDataModuleGeral.PostUser(Id: Integer; Nickname, Email, CPF,
  Password: String): Integer;
var
Json, JsonResponse: TJSONObject;
begin
  //Constroi o JSON do usuário que vai ser enviado ao webservice.
  Json := TJSONObject.Create;
  Json.AddPair('Id', TJSONNumber.Create(Id));
  Json.AddPair('Nickname', TJSONString.Create(Nickname));
  Json.AddPair('Email', TJSONString.Create(Email));
  Json.AddPair('CPF', TJSONString.Create(CPF));
  Json.AddPair('Password', TJSONString.Create(Password));

  //Envia a requisição POST contendo o JSON do usuário.
  RequestPostUser.Params.ParameterByName('json').Value := Json.ToString;
  RequestPostUser.Execute;

  //Pega o JSON contendo a resposta da requisição POST.
  JsonResponse := (TJSONObject.ParseJSONValue(ResponsePostUser.Content) as TJSONObject);

  //Verifica se o JSON objeto contém o par de chave Id, significando que houve sucesso.
  if (JsonResponse.Values['Id'] <> nil) then
  begin
    //Atribui ao resultado o Id recebido como resposta.
    Result := StrToInt(JsonResponse.GetValue('Id').Value);
  end
  else
  begin
    //Levanta uma exceção com o erro retornado pelo webservice.
    raise Exception.Create(JsonResponse.GetValue('Error').Value);
  end;
end;

procedure TDataModuleGeral.SendPayment(Plate: String; Time: Integer; PaymentListener: IPaymentListener);
begin
  //Verifica se não existe usuário logado. Ou seja, pagamento avulso.
  if not(IsUserLogged) then
  begin
    //Chama o procedimento de pagamento de tíquete avulso.
    SendPaymentSeparate(Plate, Time, PaymentListener);
  end
  else
  begin
    //Chama o procedimento de pagamento que utiliza os créditos já adquiridos pelo usuário.
    SendPaymentByCredit(Plate, Time, PaymentListener);
  end;
end;

procedure TDataModuleGeral.SendPaymentByCredit(Plate: String; Time: Integer;
  PaymentListener: IPaymentListener);
begin
  //Falta implementar.
end;

procedure TDataModuleGeral.SendPaymentSeparate(Plate: String; Time: Integer;
  PaymentListener: IPaymentListener);
var
StartTime: TDateTime;
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
                        try
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
                          DataModuleLocal.InsertTicket(Plate, StartTime, Time);

                          //Chama o procedimento do ouvinte de pagamento.
                          PaymentListener.OnSucess;
                        except
                          on Error: Exception do
                          begin
                            //Chama o procedimento OnError do objeto ouvinte de pagamentos.
                            PaymentListener.OnError(Error.Message);
                          end;
                        end;
                      end;

                      //Dispensa(elimina) o formulário.
                      //FormCreditCardSeparate.DisposeOf();
                   end);
end;

procedure TDataModuleGeral.SendUser(Nickname, Email, CPF, Password: String);
var
Id: Integer;
begin
  //Envia o cadastro do usuário para o webservidor.
  Id := PostUser(DataModuleLocal.DataSetUser.FieldByName('Id').AsInteger
                ,Nickname
                ,Email
                ,CPF
                ,Password);

  //Armazena na base local as alterações do usuário.
  DataModuleLocal.InsertUser(Id, Nickname, Email, CPF, Password);
end;

function TDataModuleGeral.GetUnitTime: Integer;
begin
  Result := 10;
end;

end.

