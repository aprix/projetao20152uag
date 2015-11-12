unit UnitParking;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.EditBox, FMX.NumberBox, FMX.Objects, UnitDataModuleGeral, DateUtils;

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
    editTime: TEdit;
    Layout8: TLayout;
    editPlateLetters: TEdit;
    Label2: TLabel;
    editPlateNumbers: TEdit;
    ButtonActiveTickets: TSpeedButton;
    buttonRemoveTime: TSpeedButton;
    buttonAddTime: TSpeedButton;
    TimerUpdateValues: TTimer;
    procedure editPlateLettersKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure editPlateLettersChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure buttonAddTimeClick(Sender: TObject);
    procedure buttonRemoveTimeClick(Sender: TObject);
    procedure editTimeChange(Sender: TObject);
    procedure ButtonActiveTicketsClick(Sender: TObject);
    procedure editPlateNumbersChange(Sender: TObject);
    procedure TimerUpdateValuesTimer(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateValuesLabels;
    procedure ValidateValuesComponents;
    procedure OnSucess;
    procedure OnError(Msg: String);
    var
    Time: Integer;
  public
    { Public declarations }
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

procedure TFormParking.buttonAddTimeClick(Sender: TObject);
begin
  //Incrementa uma unidade de tempo.
  //Satisfazendo o tempo máximo permitido.
  Time := Min(Time + DataModuleGeral.GetUnitTime, DataModuleGeral.GetMaxTime);

  //Atribui o novo tempo ao campo editTime.
  editTime.Text := IntToStr(Time);
end;

procedure TFormParking.buttonRemoveTimeClick(Sender: TObject);
begin
  //Decrementa uma unidade de tempo.
  //Satisfazendo o tempo mínimo permitido.
  Time := Max(Time - DataModuleGeral.GetUnitTime(), DataModuleGeral.GetMinTime());

  //Atribui o novo tempo ao campo editTime.
  editTime.Text := IntToStr(Time);
end;

procedure TFormParking.editPlateLettersChange(Sender: TObject);
begin
  SetTextUpperCaseEditChange(Sender);
end;

procedure TFormParking.editPlateLettersKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  //Permite apenas a digitação de letras no campo editPlateLatters.
  AllowJustLettersEditKeyDown(Sender, Key, KeyChar, Shift);
end;

procedure TFormParking.editPlateNumbersChange(Sender: TObject);
begin
  //Permite apenas a digitação de números no campo editPlateNumbers.
  editPlateNumbers.Text := GetJustNumbersOfString(editPlateNumbers.Text);
end;

procedure TFormParking.editTimeChange(Sender: TObject);
begin
  //Valida se o tempo digitado satisfaz o intervalo do tempo mínimo e máximo.
  Time := StrToIntDef(editTime.Text, DataModuleGeral.GetMinTime);
  Time := Max(Time, DataModuleGeral.GetMinTime);
  Time := Min(Time, DataModuleGeral.GetMaxTime);

  //Valida se o tempo satisfaz a unidade de tempo.
  Time := Round(Time / DataModuleGeral.GetUnitTime) * DataModuleGeral.GetUnitTime;

  //Atualiza o valor do componente editTime.
  editTime.Text := IntToStr(Time);

  //Atualiza os valores dos componentes referente a créditos.
  UpdateValuesLabels;
end;

procedure TFormParking.FormShow(Sender: TObject);
begin
  //Se não existir um usuário logado, oculta os créditos disponíveis.
  LayoutCreditsAvailable.Visible := DataModuleGeral.IsUserLogged;

  //Atribui valores iniciais a alguns campos.
  Time := DataModuleGeral.GetMinTime;
  editTime.Text := IntToStr(DataModuleGeral.GetMinTime());
  editPlateLetters.Text    := Copy(DataModuleGeral.GetLastPlate(), 1, 3);
  editPlateNumbers.Text    := Copy(DataModuleGeral.GetLastPlate(), 4, 4);

  //Verifica se existe um usuário logado.
  if (DataModuleGeral.IsUserLogged) then
  begin
    try
      //Atualiza a consulta de créditos do usuário logado.
      DataModuleGeral.OpenQueryCreditsUser;
    except
      on Error: Exception do
      begin
        //Exibe a mensagem do erro para o usuário.
        ShowMessage(Error.Message);
      end;
    end;
  end;

  //Atualiza os valores dos campos.
  UpdateValuesLabels();
end;

procedure TFormParking.OnSucess;
begin
  //Exibe uma mensagem de sucesso para o usuário.
  ShowMessage('Pagamento realizado!');

  //O formulário é fechado.
  Close;
end;

procedure TFormParking.OnError(Msg: String);
begin
  //Exibe a mensagem do erro para o usuário.
  ShowMessage(Msg);
end;

procedure TFormParking.TimerUpdateValuesTimer(Sender: TObject);
begin
  //Atualiza os valores dos componentes.
  UpdateValuesLabels;
end;

procedure TFormParking.UpdateValuesLabels;
begin
  //Atualiza os valores dos campos do formulário.
  lblCreditsAvailable.Text := 'R$ '+FormatValue(DataModuleGeral.GetCreditsUser());
  lblCreditsPay.Text       := 'R$ '+FormatValue(Time * DataModuleGeral.GetPriceTime());
  lblDeadline.Text         := FormatDateTime('dd/mm/YYYY hh:MM', IncMinute(Now, Time));
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
