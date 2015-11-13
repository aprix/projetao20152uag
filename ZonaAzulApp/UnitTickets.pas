unit UnitTickets;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.Bind.GenData,
  Fmx.Bind.GenData, Data.Bind.ObjectScope, Data.DB, Datasnap.DBClient;

type
  TFrameTickets = class(TFrame)
    Layout1: TLayout;
    ListViewTickets: TListView;
    ButtonNew: TSpeedButton;
    lblMessage: TLabel;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    BindSourceDB1: TBindSourceDB;
    TimerUpdateListTickets: TTimer;
    procedure ListViewTicketsFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure ButtonNewClick(Sender: TObject);
    procedure ListViewTicketsItemsChange(Sender: TObject);
    procedure TimerUpdateListTicketsTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateQueryTickets;
  end;

var
  FrameTickets: TFrameTickets;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitParking, UnitRoutines, UnitDataModuleLocal;

procedure TFrameTickets.ButtonNewClick(Sender: TObject);
begin
  //Abre o formulário de estacionamento para o novo tíquete.
  UnitRoutines.Show(TFormParking.Create(Self));
end;

procedure TFrameTickets.ListViewTicketsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  //Exibe registro se o fitlro está vazio.
  //Ou se o valor filtrado está contido no valor de seu campo sendo avaliado.
  Accept := (AFilter = EmptyStr) or (Pos(AFilter, AValue) > 0);
end;

procedure TFrameTickets.ListViewTicketsItemsChange(Sender: TObject);
begin
  //Exibe o label de mensagem se não existir nenhum tíquete adquirido.
  lblMessage.Visible := (DataModuleLocal.DataSetTickets.IsEmpty)
                      and ((DataModuleGeral.DataSetTickets.IsEmpty) or not(DataModuleGeral.IsUserLogged));
  lblMessage.Text    := 'Nenhum tíquete comprado'+#13+#13+'Clique no botão Novo para comprar um novo tíquete';
end;

procedure TFrameTickets.TimerUpdateListTicketsTimer(Sender: TObject);
begin
  //Verifica se existe um usuário logado.
  if (DataModuleGeral.IsUserLogged) then
  begin
    //Atualiza a consulta de tíquetes do usuário logado.
    DataModuleGeral.DataSetTickets.Close;
    DataModuleGeral.DataSetTickets.Open;
  end
  else
  begin
    //Atualiza a consulta de tíquetes(avulsos) na base local.
    DataModuleLocal.DataSetTickets.Close;
    DataModuleLocal.DataSetTickets.Open();
  end;
end;

procedure TFrameTickets.UpdateQueryTickets;
begin
  try
    //Verifica se existe um usuário logado no aplicativo.
    if (DataModuleGeral.IsUserLogged) then
    begin
      //Abre a consulta de tíquetes do usuário logado.
      DataModuleGeral.OpenQueryTicketsUser;

      //Atribui ao ListView o DataSetTickets do usuário logado como conjunto de dados.
      BindSourceDB1.DataSet := DataModuleGeral.DataSetTickets;
    end
    else
    begin
      //Atribui ao ListView o DataSetTickets da base local como conjunto de dados.
      BindSourceDB1.DataSet := DataModuleLocal.DataSetTickets;
    end;

    //Exibe o label de mensagem se não existir nenhum tíquete adquirido.
    lblMessage.Visible := (DataModuleLocal.DataSetTickets.IsEmpty)
                      and ((DataModuleGeral.DataSetTickets.IsEmpty) or not(DataModuleGeral.IsUserLogged));
    lblMessage.Text    := 'Nenhum tíquete comprado'+#13+#13+'Clique no botão Novo para comprar um novo tíquete';
  except
    on Error: Exception do
    begin
      //Exibe a mensagem do erro para o usuário.
      ShowMessage(Error.Message);
    end;
  end;
end;

end.
