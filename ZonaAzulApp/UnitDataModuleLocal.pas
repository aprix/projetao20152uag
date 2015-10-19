unit UnitDataModuleLocal;

interface

uses
  System.SysUtils, System.Classes, Data.DbxSqlite, Data.FMTBcd, Data.DB,
  Datasnap.DBClient, Datasnap.Provider, Data.SqlExpr, DateUtils,
  System.ImageList, FMX.ImgList, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.IOUtils;

type
  TDataModuleLocal = class(TDataModule)
    IconsTicketsList: TImageList;
    FDConnectionLocal: TFDConnection;
    DataSetTickets: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnectionLocalBeforeConnect(Sender: TObject);
    procedure FDConnectionLocalAfterConnect(Sender: TObject);
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
  FDConnectionLocal.Connected := True;

  //Atribui a ordenação aos tíquetes da base local.
  DataSetTickets.IndexDefs.Add('OrderByTickets', 'DeadlineTime', [ixDescending]);
  DataSetTickets.IndexName := 'OrderByTickets';
  DataSetTickets.Open();

end;

procedure TDataModuleLocal.FDConnectionLocalAfterConnect(Sender: TObject);
begin
  //Cria as tabelas da base de dados local.
  FDConnectionLocal.ExecSQL('CREATE TABLE IF NOT EXISTS Tickets('
                                  +'Plate VARCHAR(10) NOT NULL'
                                  +',StartTime DATETIME NOT NULL'
                                  +',Time INTEGER NOT NULL'
                                  +');');
end;

procedure TDataModuleLocal.FDConnectionLocalBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
  FDConnectionLocal.Params.Values['Database'] :=   TPath.GetDocumentsPath + PathDelim + 'ZonaAzul.s3db';
  {$ELSE}
  FDConnectionLocal.Params.Values['Database'] := 'ZonaAzul.s3db';
  {$ENDIF}
end;

procedure TDataModuleLocal.InsertTicketLocal(Plate: String;
  StartTime: TDateTime; Time: Integer);
var
CommandSQL: String;
begin
  //Constroi o comando de INSERT para o novo tíquete.
  CommandSQL := Format('INSERT INTO Tickets(Plate, StartTime, Time) VALUES(%s,%s, %d);'
                      ,[ QuotedStr(Plate)
                        ,QuotedStr(FormatDateTime('yyyy-MM-dd HH:mm:ss', StartTime))
                        ,Time]);

  //Executa o comando SQL de Insert do tíquete na base local.
  FDConnectionLocal.ExecSQL(CommandSQL);

  //Atualiza a consulta de DataSetTickets.
  DataSetTickets.Close;
  DataSetTickets.Open;
end;

end.
