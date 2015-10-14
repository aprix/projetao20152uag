unit UnitDataModuleLocal;

interface

uses
  System.SysUtils, System.Classes, Data.DbxSqlite, Data.FMTBcd, Data.DB,
  Datasnap.DBClient, Datasnap.Provider, Data.SqlExpr, DateUtils,
  System.ImageList, FMX.ImgList;

type
  TDataModuleLocal = class(TDataModule)
    SQLConnectionLocal: TSQLConnection;
    IconsTicketsList: TImageList;
    SQLTableTickets: TSQLTable;
    DataSetTickets: TClientDataSet;
    DataSetTicketsPlate: TWideStringField;
    DataSetTicketsStartTimeStr: TWideStringField;
    DataSetTicketsStartTime: TDateTimeField;
    DataSetTicketsTime: TLargeintField;
    DataSetTicketsDeadlineTime: TDateTimeField;
    DataSetTicketsIconIndex: TIntegerField;
    DataSetProviderTickets: TDataSetProvider;
    procedure DataModuleCreate(Sender: TObject);
    procedure SQLConnectionLocalAfterConnect(Sender: TObject);
    procedure SQLConnectionLocalBeforeConnect(Sender: TObject);
    procedure DataSetTicketsCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure InsertTicketLocal(Plate: String; StartTime: TDateTime; Time: Integer);
  end;

var
  DataModuleLocal: TDataModuleLocal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDataModuleLocal.DataModuleCreate(Sender: TObject);
begin
  //Abre a conexão da base local e suas respectivas tabelas.
  SQLConnectionLocal.Open;

  //Atribui a ordenação aos tíquetes da base local.
  DataSetTickets.IndexDefs.Add('OrderByTickets', 'DeadlineTime', [ixDescending]);
  DataSetTickets.IndexName := 'OrderByTickets';
  DataSetTickets.Open;

end;

procedure TDataModuleLocal.DataSetTicketsCalcFields(DataSet: TDataSet);
var
ResourceStream : TResourceStream;
DeadlineTime: TDateTime;
IconName: String;
begin
  //Verifica se o estado determina o cálculo dos atributos internos calculados.
  //E verifica se o registro do tíquete não é o padrão.
  if (DataSetTickets.State = dsInternalCalc)
  and (DataSetTicketsPlate.AsString <> EmptyStr) then
  begin
    //Atualiza os valores dos atributos calculados internamente de DataSetTickets
    //através do objeto SQLDataSetTickets vinculado.
    DataSetTicketsStartTime.AsDateTime := StrToDateTime(DataSetTicketsStartTimeStr.AsString);;

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

procedure TDataModuleLocal.SQLConnectionLocalAfterConnect(Sender: TObject);
begin
  //Cria as tabelas da base de dados local.
  SQLConnectionLocal.ExecuteDirect('CREATE TABLE IF NOT EXISTS Tickets('
                                  +'Plate CHAR(10) NOT NULL'
                                  +',StartTimeStr CHAR(20) NOT NULL'
                                  +',Time INTEGER NOT NULL'
                                  +');');
  //Necessário inserir o primeiro registro para identificação dos tipos dos atributos(Fields).
  SQLConnectionLocal.ExecuteDirect('INSERT INTO Tickets Select '''', '''', 0 Where Not Exists(Select * From Tickets)');
end;

procedure TDataModuleLocal.SQLConnectionLocalBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
  SQLConnectionLocal.Params.Values['Database'] :=   TPath.GetDocumentsPath + PathDelim + 'tasks.s3db';
  {$ENDIF}
end;

procedure TDataModuleLocal.InsertTicketLocal(Plate: String;
  StartTime: TDateTime; Time: Integer);
var
CommandSQL: String;
begin
  //Constroi o comando de INSERT para o novo tíquete.
  CommandSQL := Format('INSERT INTO Tickets(Plate, StartTimeStr, Time) VALUES(%s,%s, %d);'
                      ,[ QuotedStr(Plate)
                        ,QuotedStr(DateTimeToStr(StartTime))
                        ,Time]);

  //Executa o comando SQL de Insert do tíquete na base local.
  SQLConnectionLocal.ExecuteDirect(CommandSQL);

  //Atualiza a consulta de DataSetTickets.
  DataSetTickets.Close;
  DataSetTickets.Open;
end;

end.
