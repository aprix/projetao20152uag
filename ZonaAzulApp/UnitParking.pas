unit UnitParking;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.EditBox, FMX.NumberBox, FMX.Objects, UnitDataModuleGeral, DateUtils,
  FMX.TMSBaseControl, FMX.TMSSpinner;

type
  TFormParking = class(TForm, IPaymentListener)
    Label1: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Label4: TLabel;
    Layout4: TLayout;
    Label9: TLabel;
    lblDeadline: TLabel;
    LayoutCreditsAvailable: TLayout;
    Label8: TLabel;
    lblCreditsAvailable: TLabel;
    Layout6: TLayout;
    Label5: TLabel;
    lblCreditsPay: TLabel;
    Layout7: TLayout;
    Layout8: TLayout;
    EditPlateLetters: TEdit;
    Label2: TLabel;
    EditPlateNumbers: TEdit;
    ButtonActiveTickets: TSpeedButton;
    TimerUpdateValues: TTimer;
    SpinnerTimerOut: TTMSFMXSpinner;
    VertScrollBox1: TVertScrollBox;
    procedure EditPlateLettersKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure EditPlateLettersChange(Sender: TObject);
    procedure ButtonActiveTicketsClick(Sender: TObject);
    procedure EditPlateNumbersChange(Sender: TObject);
    procedure TimerUpdateValuesTimer(Sender: TObject);
    procedure SpinnerTimerOutSelectedValueChanged(Sender: TObject;
      Column: Integer; SelectedValue: Double;
      RangeType: TTMSFMXSpinnerRangeType);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateValuesLabels;
    procedure ValidateValuesComponents;
    procedure OnSucess;
    procedure OnError(Msg: String);
    procedure UpdateValuesComponents;
    var
    Time: Integer;
    BeginTime, DeadlineTime: TDateTime;
    IsRenew: Boolean;
  public
    { Public declarations }
    procedure RenewTicket(Plate: String; DeadlineTime: TDateTime);
  end;

var
  FormParking: TFormParking;

implementation

{$R *.fmx}

uses UnitRoutines;

procedure TFormParking.ButtonActiveTicketsClick(Sender: TObject);
begin
  try
    //Valida os valores dos componentes.
    ValidateValuesComponents;

    //Envia o pagamento para o Webservice.
    DataModuleGeral.SendPayment(Format('%s%s',[editPlateLetters.Text, editPlateNumbers.Text])
                               ,Time
                               ,Self);
  except
    on Error: Exception do
    begin
      //Exibe a mensagem do erro para o usuário.
      ShowMessage(Error.Message);
    end;
  end;
end;

procedure TFormParking.EditPlateLettersChange(Sender: TObject);
begin
  SetTextUpperCaseEditChange(Sender);
end;

procedure TFormParking.EditPlateLettersKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  //Permite apenas a digitação de letras no campo editPlateLatters.
  AllowJustLettersEditKeyDown(Sender, Key, KeyChar, Shift);
end;

procedure TFormParking.EditPlateNumbersChange(Sender: TObject);
begin
  //Permite apenas a digitação de números no campo editPlateNumbers.
  editPlateNumbers.Text := GetJustNumbersOfString(editPlateNumbers.Text);
end;

procedure TFormParking.FormCreate(Sender: TObject);
begin
  try
    //Se não existir um usuário logado, oculta os créditos disponíveis.
    LayoutCreditsAvailable.Visible := DataModuleGeral.IsUserLogged;

    //Verifica se existe um usuário logado.
    if (DataModuleGeral.IsUserLogged) then
    begin
      //Atualiza a consulta de créditos do usuário logado.
      DataModuleGeral.OpenQueryCreditsUser;
    end;

    //Atualiza a consulta de preço.
    DataModuleGeral.OpenQueryPrice;

    //Atribui valores iniciais a alguns campos.
    Time := DataModuleGeral.GetMinTime;
    EditPlateLetters.Text    := Copy(DataModuleGeral.GetLastPlate(), 1, 3);
    EditPlateNumbers.Text    := Copy(DataModuleGeral.GetLastPlate(), 4, 4);

    //Atualiza os valores dos campos.
    UpdateValuesComponents();
  except
    on Error: Exception do
    begin
      //Exibe a mensagem do erro para o usuário.
      ShowMessage(Error.Message);
    end;
  end;
end;

procedure TFormParking.OnSucess;
begin
  //Exibe uma mensagem de sucesso para o usuário.
  ShowMessage('Pagamento realizado!');

  //O formulário é fechado.
  Close;
end;

procedure TFormParking.RenewTicket(Plate: String; DeadlineTime: TDateTime);
begin
  //Atribui a placa passada aos campos relacionados a placa.
  EditPlateLetters.Text := Copy(Plate, 1, 3);
  EditPlateNumbers.Text := Copy(Plate, 4, 4);

  //Atualiza os atributos de limite e indicador de renovação.
  Self.IsRenew      := True;
  Self.DeadlineTime := DeadlineTime;
end;

procedure TFormParking.SpinnerTimerOutSelectedValueChanged(Sender: TObject;
  Column: Integer; SelectedValue: Double; RangeType: TTMSFMXSpinnerRangeType);
begin
  //Valida se o tempo digitado satisfaz o intervalo do tempo mínimo e máximo.
  Time := MinutesBetween(BeginTime, SpinnerTimerOut.Columns.Items[0].SelectedDateTime);
  Time := Max(Time, DataModuleGeral.GetMinTime);
  Time := Min(Time, DataModuleGeral.GetMaxTime);

  //Valida se o tempo satisfaz a unidade de tempo.
  Time := Round(Time / DataModuleGeral.GetUnitTime) * DataModuleGeral.GetUnitTime;

  //Atualiza os valores dos componentes referente a créditos.
  UpdateValuesLabels;
end;

procedure TFormParking.OnError(Msg: String);
begin
  //Exibe a mensagem do erro para o usuário.
  ShowMessage(Msg);
end;

procedure TFormParking.TimerUpdateValuesTimer(Sender: TObject);
begin
  //Atualiza os valores dos componentes.
  UpdateValuesComponents;
end;

procedure TFormParking.UpdateValuesComponents;
var
ColumnSpinner : TTMSFMXColumn;
begin

  //Verifica se é uma renovação de vaga.
  if (IsRenew) and (DeadlineTime > Date) then
  begin
    //O tempo inicial será o tempo de limite do tíquete a ser renovado.
    BeginTime    := DeadlineTime;
  end
  else
  begin
    //Para novos tíquetes o tempo inicial será a do dispositivo.
    BeginTime    := Date;
    BeginTime    := IncMinute(BeginTime, MinuteOf(Now));
    BeginTime    := IncHour(BeginTime, HourOf(Now));
  end;

  //Atualiza o Spinner de tempo.
  ColumnSpinner := SpinnerTimerOut.Columns.Items[0];
  ColumnSpinner.DateRangeFrom := IncMinute(BeginTime, DataModuleGeral.GetMinTime);
  ColumnSpinner.DateRangeTo   := IncMinute(BeginTime, DataModuleGeral.GetMaxTime);
  ColumnSpinner.Step          := DataModuleGeral.GetUnitTime;

  //Atualiza os valores dos labels.
  UpdateValuesLabels();
end;

procedure TFormParking.UpdateValuesLabels;
begin
  //Atualiza os valores dos campos do formulário.
  lblCreditsAvailable.Text := 'R$ '+FormatValue(DataModuleGeral.GetCreditsUser());
  lblCreditsPay.Text       := 'R$ '+FormatValue(Time
                                                * DataModuleGeral.GetPriceTime()
                                                * (1 - (DataModuleGeral.GetDiscountPrice/100)));
end;

procedure TFormParking.ValidateValuesComponents;
begin
  //Valida se foi informado todos os valores dos componentes.
  Focused := nil;
  editPlateNumbers.Text := GetJustNumbersOfString(editPlateNumbers.Text);
  ValidateValueComponent(editPlateLetters, editPlateLetters.Text, 'Informe as letras da placa.', 3);
  ValidateValueComponent(editPlateNumbers, editPlateNumbers.Text, 'Informe os números da placa.', 4);
end;

end.
