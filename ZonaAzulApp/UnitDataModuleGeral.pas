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
     procedure OnError(Msg: String);
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

uses UnitCreditCardSeparate, UnitBuyCredits, UnitTickets, UnitDataModuleLocal,
  UnitRoutines;

{$R *.dfm}

function TDataModuleGeral.GetDiscountPrice: Double;
begin
  Result := 0;
end;

function TDataModuleGeral.GetLastPlate: String;
begin
  //Carrega da base local a �ltima placa usada.
  Result := DataModuleLocal.DataSetTickets.FieldByName('Plate').AsString;
end;

function TDataModuleGeral.ConsultPayment(Plate: String; var DayTime, DeadlineTime: TDateTime): Boolean;
var
Json: TJSONObject;
Error: String;
begin
  //Consulta no servidor o pagamento do estacionamento referente � placa passada como argumento.
  RequestGetPayment.Params.ParameterByName('json').Value := '{"Plate":"'+Plate+'"}';
  RequestGetPayment.Execute;

  //Pega o registro JSON retornado pela consulta.
  Json := (TJSONObject.ParseJSONValue(RequestGetPayment.Response.Content) as TJSONObject);

  //Se o json n�o tiver um par de chave "error", significa que a consulta foi realizada com sucesso.
  if (Json.Values['Error'] = nil) then
  begin
    //Pega a data de in�cio e a data de limite do pagamento retornado pelo webservice.
    DayTime      := StrToDateTimeFromWebService(Json.GetValue('DateBegin').Value);
    DeadlineTime := StrToDateTimeFromWebService(Json.GetValue('DeadlineTime').Value);

    //Retorna como resultado o valor true.
    Result := True;
  end
  else
  begin
    //Verifica se a mensagem retornada � "sem pagamento".
    Error := Json.GetValue('Error').Value;
    if (Error.Contains('Veiculo nao estacionado')) then
    begin
      //Retorna como resultado falso.
      Result := False;
    end
    else
    begin
      //Neste caso, levanta uma exce��o com a mensagem do erro.
      raise Exception.Create(Error);
    end;
  end;
end;

function TDataModuleGeral.GetCreditsUser: Double;
begin
  //Retorna valor default para os testes. N�o est� implementado o cadastro do usu�rio.
  Result := 0;
end;

function TDataModuleGeral.IsUserLogged: Boolean;
begin
  //Retorna false para os testes. N�o est� implementado o cadastro do usu�rio.
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
  //Constroi o JSON contendo os par�metros para serem enviados ao webservice.
  Json := TJSONObject.Create;
  Json.AddPair('Plate', TJSONString.Create(Plate));
  Json.AddPair('Time', TJSONNumber.Create(Time));
  Json.AddPair('FlagCreditCard', TJSONString.Create(FlagCreditCard));
  Json.AddPair('NameCreditCard', TJSONString.Create(NameCreditCard));
  Json.AddPair('NumberCreditCard', TJSONString.Create(NumberCreditCard));
  Json.AddPair('MonthCreditCard', TJSONNumber.Create(MonthCreditCard));
  Json.AddPair('YearCreditCard', TJSONNumber.Create(YearCreditCard));
  Json.AddPair('CSCCredCard', TJSONNumber.Create(CSCCredCard));

  //Envia a requisi��o POST para o pagamento.
  RequestPostPayment.Params.ParameterByName('json').Value := Json.ToString;
  RequestPostPayment.Execute;

  //Pega a resposta do webservice.
  JsonResponse := (TJSONObject.ParseJSONValue(RequestPostPayment.Response.Content) as TJSONObject);

  //Se o json com a resposta cont�m o par de chave "Sucess", significa que o pagamento foi realizado com sucesso.
  if (JsonResponse.Values['Sucess'] <> nil) then
  begin
    //Retorna a data do t�quete atribu�da pelo servidor.
    Result := StrToDateTimeFromWebService(JsonResponse.GetValue('Sucess').Value);
  end
  else
  begin
    //Levanta uma exce��o com o erro retornado na resposta do webservice.
    raise Exception.Create(JsonResponse.GetValue('Error').Value);
  end;
end;

procedure TDataModuleGeral.sendPayment(Plate: String; Time: Integer; PaymentListener: IPaymentListener);
var
StartTime: TDateTime;
begin
  //Verifica se n�o existe usu�rio logado. Ou seja, pagamento avulso.
  if not(IsUserLogged) then
  begin
    //Exibe o formul�rio de cart�o de cr�dito avulso.
    FormCreditCardSeparate := TFormCreditCardSeparate.Create(Self);
    FormCreditCardSeparate
          .ShowModal(procedure(ModalResult: TModalResult)
                     begin
                        //Oculta o formul�rio.
                        FormCreditCardSeparate.Hide;

                        //Verifica se o usu�rio confirmou a opera��o.
                        if (ModalResult = mrOk) then
                        begin
                          try
                            //Envia ao servidor a requisi��o HTTP Post do pagamento.
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

                            //Insere o novo t�quete na base local.
                            DataModuleLocal.InsertTicketLocal(Plate, StartTime, Time);

                            //Chama o procedimento do ouvinte de pagamento.
                            PaymentListener.OnAfterPayment;
                          except
                            on Error: Exception do
                            begin
                              //Chama o procedimento OnError do objeto ouvinte de pagamentos.
                              PaymentListener.OnError(Error.Message);
                            end;
                          end;
                        end;

                        //Dispensa(elimina) o formul�rio.
                        //FormCreditCardSeparate.DisposeOf();
                     end);
  end;
end;

function TDataModuleGeral.GetUnitTime: Integer;
begin
  Result := 10;
end;

end.
