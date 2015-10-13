unit UnitDataModuleGeral;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, Data.DB,
  Datasnap.DBClient, DateUtils, System.UITypes, FMX.Forms, System.ImageList,
  FMX.ImgList, Data.FMTBcd, Data.SqlExpr, System.iOUtils, Data.DbxSqlite;

type
  IPaymentListener = interface
     procedure OnAfterPayment;
  end;

  TDataModuleGeral = class(TDataModule)
    CustomStyleBook: TStyleBook;
    DataSetTickets: TClientDataSet;
    DataSetTicketsPlate: TStringField;
    DataSetTicketsTime: TIntegerField;
    DataSetTicketsStartTime: TDateTimeField;
    DataSetTicketsDeadlineTime: TDateTimeField;
    DataSetTicketsIconIndex: TIntegerField;
    IconsTicketsList: TImageList;
    SQLConnectionLocal: TSQLConnection;
    DataSetPlates: TSQLTable;
    QueryPlates: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataSetTicketsCalcFields(DataSet: TDataSet);
    procedure SQLConnectionLocalAfterConnect(Sender: TObject);
    procedure SQLConnectionLocalBeforeConnect(Sender: TObject);
  private
    { Private declarations }
    procedure postPayment(Plate: String;
                          Time: Integer;
                          FlagCreditCard: String;
                          NameCreditCard: String;
                          NumberCreditCard: String;
                          MonthCreditCard: Integer;
                          YearCreditCard: Integer;
                          CSCCredCard: Integer);
  public
    { Public declarations }

    procedure sendPayment(Plate: String; Time: Integer; PaymentListener: IPaymentListener);

    function IsUserLogged: Boolean;

    function GetCreditsUser: Double;

    function GetMaxTime: Integer;

    function GetMinTime: Integer;

    function GetUnitTime: Integer;

    function GetPriceTime: Double;

    function GetDiscountPrice: Double;

    function GetLastPlate: String;

    procedure SetLastPlate(Plate: String);

    procedure ExecSQL(Query: TSQLQuery; Command: String);
  end;

var
  DataModuleGeral: TDataModuleGeral;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses UnitCreditCardSeparate, UnitBuyCredits, UnitTickets;

{$R *.dfm}

procedure TDataModuleGeral.DataModuleCreate(Sender: TObject);
begin
  //Abre a conexão da base local e suas respectivas tabelas.
  SQLConnectionLocal.Open;
  DataSetPlates.Open;

  //TESTE
  DataSetTickets.CreateDataSet;
  DataSetTickets.IndexDefs.Add('OrderBy', 'DeadlineTime', [ixDescending]);
  DataSetTickets.IndexName := 'OrderBy';

  DataSetTickets.Append;
  DataSetTicketsPlate.AsString := 'PES16860';
  DataSetTicketsTime.AsInteger := 60;
  DataSetTicketsStartTime.AsDateTime := IncMinute(Now,-120);
  DataSetTickets.Post;

  DataSetTickets.Append;
  DataSetTicketsPlate.AsString := 'PES16860';
  DataSetTicketsTime.AsInteger := 60;
  DataSetTicketsStartTime.AsDateTime := IncMinute(Now,-30);
  DataSetTickets.Post;
end;

procedure TDataModuleGeral.DataSetTicketsCalcFields(DataSet: TDataSet);
var
ResourceStream : TResourceStream;
DeadlineTime: TDateTime;
IconName: String;
begin
  //Verifica se o estado do objeto DataSetTickets é dsInternalCalc.
  if (DataSetTickets.State = dsInternalCalc) then
  begin
    //Calcula o tempo limite do tíquete corrente.
    DeadlineTime := IncMinute(DataSetTicketsStartTime.AsDateTime, DataSetTicketsTime.AsInteger);

    //Atualiza os valores dos atributos internos calculados.
    DataSetTicketsDeadlineTime.AsDateTime := DeadlineTime;

    //Verifica se o tíquete passou do limite.
    if (Now > DeadlineTime) then
    begin
      //O ícone a ser atribuído ao tíquete será o de tíquete vencido.
      DataSetTicketsIconIndex.AsInteger := 0;
    end
    else
    begin
      //O ícone a ser atribuído ao tíquete será o de tíquete válido(ativo).
      DataSetTicketsIconIndex.AsInteger := 1;
    end;
  end;
end;

procedure TDataModuleGeral.ExecSQL(Query: TSQLQuery; Command: String);
begin
  //Executa o comando SQL usando o objeto Query passado como argumento.
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add(Command);
  Query.ExecSQL();
end;

function TDataModuleGeral.GetDiscountPrice: Double;
begin
  Result := 0;
end;

function TDataModuleGeral.GetLastPlate: String;
begin
  //Carrega da base local a última placa usada.
  Result := DataSetPlates.FieldByName('Plate').AsString;
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
  //Armazena a placa na base local.
  SetLastPlate(Plate);

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

                          //Para o teste, salva o pagamento no ClientDataSet de tíquetes.
                          DataSetTickets.Append;
                          DataSetTicketsPlate.AsString := Plate;
                          DataSetTicketsTime.AsInteger := Time;
                          DataSetTicketsStartTime.AsDateTime:= Now;
                          DataSetTickets.Post;
                          DataSetTickets.Close;
                          DataSetTickets.Open;

                          //Chama o procedimento do ouvinte de pagamento.
                          PaymentListener.OnAfterPayment;
                        end;

                        //Dispensa(elimina) o formulário.
                        //FormCreditCardSeparate.DisposeOf();
                     end);
  end;
end;

procedure TDataModuleGeral.SetLastPlate(Plate: String);
var
CommandSQL : String;
begin
  //Armazena a placa na base de dados.
  if (DataSetPlates.IsEmpty) then
    ExecSQL(QueryPlates, Format('INSERT INTO Plates(Plate) VALUES(%s);', [QuotedStr(Plate)]))
  else
    ExecSQL(QueryPlates, Format('UPDATE Plates SET Plate = %s;', [QuotedStr(Plate)]));

  DataSetPlates.Refresh;
end;

procedure TDataModuleGeral.SQLConnectionLocalAfterConnect(Sender: TObject);
begin
  //Cria as tabelas da base de dados local.
  SQLConnectionLocal.ExecuteDirect('CREATE TABLE IF NOT EXISTS Plates('
                                  +'Plate TEXT NOT NULL'
                                  +');');
end;

procedure TDataModuleGeral.SQLConnectionLocalBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
  SQLConnectionLocal.Params.Values['Database'] :=   TPath.GetDocumentsPath + PathDelim + 'tasks.s3db';
  {$ENDIF}
end;

function TDataModuleGeral.GetUnitTime: Integer;
begin
  Result := 10;
end;

end.
