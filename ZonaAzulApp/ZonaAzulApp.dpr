program ZonaAzulApp;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitParking in 'UnitParking.pas' {FormParking},
  UnitBuyCredits in 'UnitBuyCredits.pas' {FrameBuyCredits},
  UnitDataModuleGeral in 'UnitDataModuleGeral.pas' {DataModuleGeral: TDataModule},
  UnitCadastreCreditCard in 'UnitCadastreCreditCard.pas' {FormCadastreCreditCard},
  UnitTickets in 'UnitTickets.pas' {FrameTickets},
  UnitRoutines in 'UnitRoutines.pas',
  UnitConsultPayments in 'UnitConsultPayments.pas' {FrameConsultPayments},
  UnitSplash in 'UnitSplash.pas' {FormSplash},
  SysUtils,
  UnitCreditCardSeparate in 'UnitCreditCardSeparate.pas' {FormCreditCardSeparate},
  UnitDataModuleLocal in 'UnitDataModuleLocal.pas' {DataModuleLocal: TDataModule},
  UnitCadastreUser in 'UnitCadastreUser.pas' {FrameCadastreUser: TFrame},
  UnitWelcome in 'UnitWelcome.pas' {FormWelcome},
  UnitCreditCards in 'UnitCreditCards.pas' {FrameCreditCards: TFrame},
  UnitDialogOptions in 'UnitDialogOptions.pas' {FrameDialogOptions: TFrame};

{$R *.res}

begin
  FormSplash := TFormSplash.Create(Application);
  FormSplash.Show;
  Application.ProcessMessages;
  Sleep(1000);
  Application.Initialize;
  //Application.CreateForm(TDataModuleLocal, DataModuleLocal);
  //Application.CreateForm(TDataModuleGeral, DataModuleGeral);
  DataModuleLocal := TDataModuleLocal.Create(Application);
  DataModuleGeral := TDataModuleGeral.Create(Application);

  //Verifica se o formulário de boas vindas deverá ser aberto.
  if (DataModuleLocal.DataSetUser.IsEmpty)
  and (DataModuleLocal.DataSetTickets.IsEmpty) then
  begin
    //Abre o formulário de boas vindas.
    Application.CreateForm(TFormWelcome, FormWelcome);
  end
  else
  begin
    //Abre o formulário principal.
    Application.CreateForm(TFormMain, FormMain);
  end;

  FormSplash.Hide;
  FormSplash.Free;
  Application.Run;
end.
