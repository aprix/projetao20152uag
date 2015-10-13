unit UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.MultiView, FMX.Layouts,
  FMX.Objects, FMX.ExtCtrls;

type
  TFormMain = class(TForm)
    MultiView1: TMultiView;
    Layout1: TLayout;
    ButtonBuyCredits: TSpeedButton;
    ButtonTickets: TSpeedButton;
    ButtonCreditCards: TSpeedButton;
    ToolBar1: TToolBar;
    SpeedButton3: TSpeedButton;
    ButtonConsultPayment: TSpeedButton;
    LayoutFrame: TLayout;
    LabelTitle: TLabel;
    VertScrollBox1: TVertScrollBox;
    Layout2: TLayout;
    Line1: TLine;
    Label1: TLabel;
    Label2: TLabel;
    PanelDataUser: TPanel;
    procedure ButtonBuyCreditsClick(Sender: TObject);
    procedure ButtonTicketsClick(Sender: TObject);
    procedure ButtonConsultPaymentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PanelDataUserClick(Sender: TObject);
  private
    { Private declarations }
    procedure Show(Frame: TFrame; Parent: TFmxObject; Title: String);
    var
    VisibleFrame: TFrame;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

uses UnitConsultPayments, UnitRoutines
  ,UnitBuyCredits, UnitDataModuleGeral, UnitCadastreCreditCard,
  UnitTickets;

procedure TFormMain.ButtonBuyCreditsClick(Sender: TObject);
begin
  Show( FrameBuyCredits,  LayoutFrame, 'Compra de Créditos');
  MultiView1.HideMaster;
end;

procedure TFormMain.ButtonTicketsClick(Sender: TObject);
begin
  Show( FrameTickets, LayoutFrame, 'Tíquetes' );
  MultiView1.HideMaster;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  //Instancia os frames(telas).
  FrameBuyCredits := TFrameBuyCredits.Create(Self);
  FrameTickets    := TFrameTickets.Create(Self);
  FrameConsultPayments := TFrameConsultPayments.Create(Self);

  //Exibe o frame(tela) de tíquetes como default.
  ButtonTicketsClick(Self);
end;

procedure TFormMain.PanelDataUserClick(Sender: TObject);
begin
  ShowMessage('Abre os dados do usuário');
end;

procedure TFormMain.Show(Frame: TFrame; Parent: TFmxObject; Title: String);
begin
  //Verifica se existe um outro frame sendo exibido no layout de frame.
  if (VisibleFrame <> nil) then
  begin
    //Remove o frame atual do layout de frame.
    VisibleFrame.Parent := nil;
    VisibleFrame.Visible:= False;
  end;

  //Adiciona o novo Frame dentro do Layout principal.
  Frame.Parent := Parent;
  Frame.Visible:= True;

  //Atualiza o label de título.
  LabelTitle.Text := Title;

  //Atualiza o atributo que contém a referência do Frame em exibição.
  VisibleFrame := Frame;
end;

procedure TFormMain.ButtonConsultPaymentClick(Sender: TObject);
begin
  Show(FrameConsultPayments, LayoutFrame, 'Consultar Veículo');
  MultiView1.HideMaster;
end;

end.
