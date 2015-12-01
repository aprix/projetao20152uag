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
    LayoutPrincipal: TLayout;
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
    procedure ListViewTicketsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    procedure ShowParkingForRenewTicket(Plate: String; DeadlineTime: TDateTime);
  public
    { Public declarations }
    procedure UpdateQueryTickets;
  end;

var
  FrameTickets: TFrameTickets;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitParking, UnitRoutines, UnitDataModuleLocal,
  UnitDialogOptions;

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

procedure TFrameTickets.ListViewTicketsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
DialogOptions: TFrameDialogOptions;
begin
  //Verifica se o tíquete pressionado está ATIVO (Em Aberto).
  if (AItem.ImageIndex = 1) then
  begin
    //Abre um diálogo de opções para renovação da vaga.
    DialogOptions := TFrameDialogOptions.Create(Self, LayoutPrincipal, ['Renovar Tíquete']
                  , procedure (ModalResult: TModalResult; IndexSelected: Integer)
                    begin
                      try
                        //Verifica se o resultado foi mrOk.
                        if (ModalResult = mrOk) then
                        begin
                          //Verifica qual a opção selecionada.
                          case IndexSelected of
                            //Se for a opção de renovação.
                            0: ShowParkingForRenewTicket(AItem.Text, StrToDateTime(AItem.Detail));
                          end;
                        end;
                      finally
                        //Desaloca da memória o diálogo de opções.
                        DialogOptions.Release;
                      end;
                    end
                  );
  end;
end;

procedure TFrameTickets.ListViewTicketsItemsChange(Sender: TObject);
begin
  //Exibe o label de mensagem se não existir nenhum tíquete adquirido.
  lblMessage.Visible := (DataModuleLocal.DataSetTickets.IsEmpty)
                      and ((DataModuleGeral.DataSetTickets.IsEmpty) or not(DataModuleGeral.IsUserLogged));
  lblMessage.Text    := 'Nenhum tíquete comprado'+#13+#13+'Clique no botão Novo para comprar um novo tíquete';
end;

procedure TFrameTickets.ShowParkingForRenewTicket(Plate: String;
  DeadlineTime: TDateTime);
var
FormParking: TFormParking;
begin
  //Abre o formulário de estacionamento para a renovação do tíquete passado como argumento.
  FormParking := TFormParking.Create(Self);
  FormParking.RenewTicket(Plate, DeadlineTime);
  UnitRoutines.Show(FormParking);
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
