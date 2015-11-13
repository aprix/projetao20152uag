unit UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.MultiView, FMX.Layouts,
  FMX.Objects, FMX.ExtCtrls, UnitConsultPayments , UnitCreditCards
  ,UnitBuyCredits, UnitCadastreCreditCard,
  UnitTickets, UnitDataModuleLocal, UnitWelcome, UnitCadastreUser;

type
  TFormMain = class(TForm, ICadastreListener)
    MultiViewMenu: TMultiView;
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
    LabelNickname: TLabel;
    LabelEmail: TLabel;
    PanelDataUser: TPanel;
    ButtonExit: TSpeedButton;
    ButtonDataUser: TSpeedButton;
    procedure ButtonBuyCreditsClick(Sender: TObject);
    procedure ButtonTicketsClick(Sender: TObject);
    procedure ButtonConsultPaymentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure MultiViewMenuStartShowing(Sender: TObject);
    procedure ButtonCreditCardsClick(Sender: TObject);
    procedure ButtonDataUserClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure Show(Frame: TFrame; Parent: TFmxObject; Title: String);
    procedure UpdateValuesUserLabels;
    var
    VisibleFrame: TFrame;
    FrameBuyCredits: TFrameBuyCredits;
    FrameTickets: TFrameTickets;
    FrameConsultPayments: TFrameConsultPayments;
    FrameCadastreUser: TFrameCadastreUser;
    FrameCreditCards: TFrameCreditCards;
  public
    { Public declarations }
    procedure OnSucess;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

uses UnitRoutines, UnitDataModuleGeral;

procedure TFormMain.ButtonBuyCreditsClick(Sender: TObject);
begin
  //Exibe a tela de compra de créditos.
  FrameBuyCredits.ClearComponents;
  Show( FrameBuyCredits,  LayoutFrame, 'Compra de Créditos');
end;

procedure TFormMain.ButtonTicketsClick(Sender: TObject);
begin
  //Exibe a tela de tíquetes do usuário logado ou avulso.
  FrameTickets.UpdateQueryTickets;
  Show( FrameTickets, LayoutFrame, 'Tíquetes' );
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Fecha toda a aplicação.
  Application.Terminate;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  //Instancia os frames(telas).
  FrameBuyCredits := TFrameBuyCredits.Create(Self);
  FrameTickets    := TFrameTickets.Create(Self);
  FrameConsultPayments := TFrameConsultPayments.Create(Self);
  FrameCadastreUser    := TFrameCadastreUser.Create(Self, Self);
  FrameCreditCards     := TFrameCreditCards.Create(Self);

  //Exibe o frame(tela) de tíquetes como default.
  ButtonTicketsClick(Self);
end;

procedure TFormMain.MultiViewMenuStartShowing(Sender: TObject);
begin
  //Atualiza os labels de dados do usuário.
  UpdateValuesUserLabels;
end;

procedure TFormMain.OnSucess;
begin
  //Exibe o frame de tíquetes.
  Show(FrameTickets, LayoutFrame, 'Tíquetes');
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

  //Oculta o menu.
  MultiViewMenu.HideMaster;
end;

procedure TFormMain.UpdateValuesUserLabels;
begin
  //Pega os valores do usuário na base local e atualiza os labels relacionados.
  LabelNickname.Text := DataModuleLocal.GetNicknameUser();
  LabelEmail.Text    := DataModuleLocal.GetEmailUser();
end;

procedure TFormMain.ButtonConsultPaymentClick(Sender: TObject);
begin
  FrameConsultPayments.ClearComponents;
  Show(FrameConsultPayments, LayoutFrame, 'Consultar Veículo');
end;

procedure TFormMain.ButtonCreditCardsClick(Sender: TObject);
begin
  //Verifica se existe um usuário logado.
  if (DataModuleGeral.IsUserLogged) then
  begin
    //Exibe o frame de cartões de crédito.
    DataModuleGeral.OpenQueryCreditCards;
    Show(FrameCreditCards, LayoutFrame, 'Cartões de Crédito');
  end
  else
  begin
    //Exibe uma mensagem ao usuário informando que o cadastro de cartão
    //só é permitido para usuário logado
    raise Exception.Create('Necessário cadastrar o usuário para prosseguir!');
  end;
end;

procedure TFormMain.ButtonDataUserClick(Sender: TObject);
begin
  //Atualiza os valores dos campos do frame de cadastro do usuário.
  FrameCadastreUser.UpdateValuesComponents;

  //Exibe o frame com as informações do usuário.
  Show(FrameCadastreUser, LayoutFrame, 'Informações Pessoais');
end;

procedure TFormMain.ButtonExitClick(Sender: TObject);
begin
  //Fecha o menu.
  MultiViewMenu.HideMaster;

  //Abre o diálogo para averiguar se o usuário deseja sair da aplicação.
  MessageDlg( 'Deseja desconectar da sua conta?'
                 , System.UITypes.TMsgDlgType.mtConfirmation
                 , [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo]
                 , 0
                 , procedure (const Result: TModalResult)
                   begin
                      case Result of
                        mrYes:
                          begin
                            //Limpa a base de dados local.
                            DataModuleLocal.ClearDataBase;

                            //Oculta o formulário principal.
                            Hide;

                            //Abre o formulário de boas vindas.
                            UnitRoutines.Show(TFormWelcome.Create(Application));

                            //Fecha o formulário principal.
                            Close;
                          end;
                      end;
                   end
            );


end;

end.
