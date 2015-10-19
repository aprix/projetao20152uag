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
    buttonNew: TSpeedButton;
    lblMessage: TLabel;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    BindSourceDB1: TBindSourceDB;
    procedure ListViewTicketsFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure buttonNewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AWOner: TComponent); override;
  end;

var
  FrameTickets: TFrameTickets;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitParking, UnitRoutines, UnitDataModuleLocal;

procedure TFrameTickets.buttonNewClick(Sender: TObject);
begin
  //Abre o formul�rio de estacionamento para o novo t�quete.
  UnitRoutines.Show(TFormParking.Create(Self));
end;

constructor TFrameTickets.Create(AWOner: TComponent);
begin
  inherited;

  //Exibe o label de mensagem se n�o existir nenhum t�quete adquirido.
  lblMessage.Visible := (DataModuleLocal.DataSetTickets.IsEmpty);
  lblMessage.Text    := 'Nenhum t�quete comprado'+#13+#13+'Clique no bot�o Novo para comprar um novo t�quete';

end;

procedure TFrameTickets.ListViewTicketsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  //Exibe registro se o fitlro est� vazio.
  //Ou se o valor filtrado est� contido no valor de seu campo sendo avaliado.
  Accept := (AFilter = EmptyStr) or (Pos(AFilter, AValue) > 0);
end;

end.
