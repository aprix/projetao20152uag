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
    DataSetUser: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnectionLocalBeforeConnect(Sender: TObject);
    procedure FDConnectionLocalAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure InsertTicket(Plate: String; StartTime: TDateTime; Time: Integer);
    procedure InsertUser(Id: Integer; Nickname, Email, CPF, Password: String);
    procedure ClearDataBase;
    function GetIdUser: Integer;
    function GetNicknameUser: String;
    function GetEmailUser: String;
    function GetCPF: String;
    function GetPassword: String;
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
  DataSetUser.Open();

  //Atribui a ordenação aos tíquetes da base local.
  DataSetTickets.IndexDefs.Add('OrderByTickets', 'DeadlineTime', [ixDescending]);
  DataSetTickets.IndexName := 'OrderByTickets';
  DataSetTickets.Open();

end;

procedure TDataModuleLocal.ClearDataBase;
begin
  //Deleta todas as tabelas da base local.
  FDConnectionLocal.ExecSQL(' DELETE FROM User;'
                           +' DELETE FROM Tickets;');

  //Atualiza todas as consultas.
  DataSetUser.Close;
  DataSetUser.Open();
  DataSetTickets.Close;
  DataSetTickets.Open();
end;

procedure TDataModuleLocal.FDConnectionLocalAfterConnect(Sender: TObject);
begin
  //Cria as tabelas da base de dados local.
  FDConnectionLocal.ExecSQL('CREATE TABLE IF NOT EXISTS Tickets('
                                  +'Plate STRING(10) NOT NULL'
                                  +',StartTime DATETIME NOT NULL'
                                  +',Time INTEGER NOT NULL'
                                  +');');

  FDConnectionLocal.ExecSQL('CREATE TABLE IF NOT EXISTS User ('
                              +'Id       INTEGER     PRIMARY KEY,'
                              +'Nickname STRING (50),'
                              +'Email    STRING (50),'
                              +'CPF      CHAR (14),'
                              +'Password STRING (50)'
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

function TDataModuleLocal.GetCPF: String;
begin
  Result := DataSetUser.FieldByName('CPF').AsString;
end;

function TDataModuleLocal.GetEmailUser: String;
begin
  Result := DataSetUser.FieldByName('Email').AsString;
end;

function TDataModuleLocal.GetIdUser: Integer;
begin
  Result := DataSetUser.FieldByName('Id').AsInteger;
end;

function TDataModuleLocal.GetNicknameUser: String;
begin
  Result := DataSetUser.FieldByName('Nickname').AsString;
end;

function TDataModuleLocal.GetPassword: String;
begin
  Result := DataSetUser.FieldByName('Password').AsString;
end;

procedure TDataModuleLocal.InsertTicket(Plate: String;
  StartTime: TDateTime; Time: Integer);
var
CommandSQL: String;
KeyValues: array of string;
begin
  SetLength(KeyValues, 2);
  KeyValues[0] := Plate;
  KeyValues[1] := '1';

  //Verifica se já existe um tíquete aberto para a placa passada como argumento.
  if (DataSetTickets.Locate('Plate;IconIndex', KeyValues, [])) then
  begin
    //Constroi o comando de UPDATE do tíquete aberto da placa em questão.
    CommandSQL := Format('UPDATE Tickets SET'
                         +' Time = Time + %d'
                         +' WHERE Plate = %s AND StartTime = %s'
                        ,[Time
                         ,QuotedStr(Plate)
                         ,QuotedStr(FormatDateTime('yyyy-MM-dd HH:mm:ss'
                                   ,DataSetTickets.FieldByName('StartTime').AsDateTime))
                         ]);
  end
  else
  begin
    //Constroi o comando de INSERT para o novo tíquete.
    CommandSQL := Format('INSERT INTO Tickets(Plate, StartTime, Time) VALUES(%s,%s, %d);'
                        ,[ QuotedStr(Plate)
                          ,QuotedStr(FormatDateTime('yyyy-MM-dd HH:mm:ss', StartTime))
                          ,Time]);
  end;

  //Executa o comando SQL de Insert do tíquete na base local.
  FDConnectionLocal.ExecSQL(CommandSQL);

  //Atualiza a consulta de DataSetTickets.
  DataSetTickets.Close;
  DataSetTickets.Open;
end;

procedure TDataModuleLocal.InsertUser(Id: Integer; Nickname, Email, CPF,
  Password: String);
var
  CommandSQL: String;
begin
  //Deleta o registro existente, caso exista alguma informação antiga.
  FDConnectionLocal.ExecSQL('DELETE FROM User');

  //Salva na base local as novas informações do usuário.
  CommandSQL := Format( 'INSERT INTO User(Id, Nickname, Email, CPF, Password) '
                        +'VALUES(%d, %s, %s, %s, %s);'
                      ,[Id
                       ,QuotedStr(Nickname)
                       ,QuotedStr(Email)
                       ,QuotedStr(CPF)
                       ,QuotedStr(Password)]);
  FDConnectionLocal.ExecSQL(CommandSQL);

  //Atualiza a consulta aberta do usuário.
  DataSetUser.Close;
  DataSetUser.Open();
end;

end.
