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
  UnitDataModuleLocal in 'UnitDataModuleLocal.pas' {DataModuleLocal: TDataModule};

{$R *.res}

begin
  FormSplash := TFormSplash.Create(Application);
  FormSplash.Show;
  Application.ProcessMessages;
  Sleep(1000);
  Application.Initialize;
  Application.CreateForm(TDataModuleLocal, DataModuleLocal);
  Application.CreateForm(TDataModuleGeral, DataModuleGeral);
  Application.CreateForm(TFormMain, FormMain);
  FormSplash.Hide;
  FormSplash.Free;
  Application.Run;
end.
