unit UnitCreditCards;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.ListView,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, FMX.Layouts;

type
  TFrameCreditCards = class(TFrame)
    ListViewCreditCards: TListView;
    buttonNew: TSpeedButton;
    lblMessage: TLabel;
    LayoutPrincipal: TLayout;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    procedure ListViewCreditCardsItemsChange(Sender: TObject);
    procedure ListViewCreditCardsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure buttonNewClick(Sender: TObject);
  private
    { Private declarations }
    procedure InactivateCreditCard(Number: String);
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses UnitDataModuleGeral, UnitCadastreCreditCard, UnitRoutines,
  UnitDialogOptions;

procedure TFrameCreditCards.buttonNewClick(Sender: TObject);
begin
  //Abre o cadastro de cartão de crédito para um novo registro.
  UnitRoutines.Show(TFormCadastreCreditCard.Create(Self));
end;

procedure TFrameCreditCards.InactivateCreditCard(Number: String);
begin
  //Abre um diálogo de Sim/Não para confirmar se o usuário deseja realmente excluir o cartão.
  MessageDlg('Deseja excluir o cartão de número'+#13+Number+' ?'
            ,System.UITypes.TMsgDlgType.mtConfirmation
            ,[System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo]
            ,0
            ,procedure (const ModalResult: TModalResult)
             begin
              //Verifica se o usuário confirmou (mrYes).
              if (ModalResult = mrYes) then
              begin
                //Localiza no conjunto de cartões o registro do cartão de crédito cujo
                //número foi passado como argumento.
                DataModuleGeral.DataSetCreditCards.Locate('Number', Number, []);

                //Envia a atualização do cartão de crédito para o webservice.
                DataModuleGeral.SendCreditCard(
                                     DataModuleGeral.GetIdCreditCardSelected
                                    ,DataModuleGeral.GetFlagCreditCardSelected
                                    ,''
                                    ,Copy(UnitRoutines.GenerateMD5(DataModuleGeral.GetNumberCreditCardSelected+FormatDateTime('ddHHmmss', Now())), 1,16)
                                    ,0
                                    ,0
                                    ,False);

                //Atualiza a consulta de cartões.
                DataModuleGeral.OpenQueryCreditCards;

              end;
             end
            );
end;

procedure TFrameCreditCards.ListViewCreditCardsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
DialogOptions: TFrameDialogOptions;
begin
  //Abre o diálogo de opções para editar ou excluir o cartão de crédito.
  DialogOptions:= TFrameDialogOptions.Create(nil
                    , LayoutPrincipal
                    , ['Editar', 'Excluir']
                    , procedure (ModalResult: TModalResult; IndexSelected: Integer)
                      begin
                        try
                          //Verifica se o resultado foi mrOk.
                          if (ModalResult = mrOk) then
                          begin
                            //Verifica qual a opção foi selecionada.
                            case IndexSelected of
                              0:
                              begin
                                //Abre o cadastro de cartão de crédito para alterar o cartão selecionado(clicado).
                                UnitRoutines.Show(TFormCadastreCreditCard.Create(Self, AItem.Detail));
                              end;

                              1:
                              begin
                                //Inativa o cartão selecionado.
                                InactivateCreditCard(AItem.Detail);
                              end;
                            end;
                          end;
                        finally
                          //Desaloca o frame da memória.
                          DialogOptions.Parent := nil;
                          //DialogOptions.DisposeOf;
                        end;
                      end
                    );


end;

procedure TFrameCreditCards.ListViewCreditCardsItemsChange(Sender: TObject);
begin
  lblMessage.Visible := (DataModuleGeral.DataSetCreditCards.IsEmpty);
  lblMessage.Text    := 'Nenhum cartão cadastrado.'+#13+#13+'Clique no botão Novo para cadastrar um cartão.'
end;

end.
